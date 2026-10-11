"""Generic engine-interface mock for Moeboid.gam running in emu.Machine.

Every engine object is a fake object in guest memory (FAKE_LO..) whose first dword points to a
per-interface vtable. Each vtable slot points to its own stub address; the stub handler logs
(tick, call site, object id, interface, vtable offset, ECX, stack arguments, return value), runs
the configured behaviour, and pops the stack arguments (callee cleanup, __thiscall).
The number of stack arguments comes from the call site (callsites.tsv, keyed by the address of the
CALL instruction), so the mock needs no prior knowledge of a method signature. Unknown
(interface, offset) pairs return a new fake object and are logged as UNMODELLED.
crosscheck.py compares callsites.tsv with workstream B's analysis/interface.tsv.

Interface and method names follow analysis/interface.tsv (workstream B). Engine behaviour that the
game can observe is modelled after analysis/timing.md (workstream C): timer fire rule, timer pass
order, event structures, rand(). Rendering, fonts and sound are not modelled (placeholders).
"""
import hashlib
import math
import struct

import emu
from emu import FAKE_LO, Stop
from unicorn import UC_HOOK_MEM_READ, UC_HOOK_CODE
from unicorn.x86_const import UC_X86_REG_ECX, UC_X86_REG_EAX, UC_X86_REG_ESP

OBJ_SIZE = 0x40
VT_LO = FAKE_LO + 0x00800000
VT_SLOTS = 0x40
NOT_FOUND = 0x19   # ISettings.GetGameValue result for a missing name (interface.tsv)
RT_RCDATA = 10
EV_KEYDOWN, EV_HELP = 0xb, 0x10


class Obj:
    def __init__(self, oid, typ, addr, attrs):
        self.id, self.type, self.addr, self.attrs, self.released = oid, typ, addr, attrs, False

    def __repr__(self):
        return f"#{self.id}:{self.type}"


def load_callsites(path):
    sites = {}
    for i, line in enumerate(open(path)):
        if i == 0:
            continue
        f = line.rstrip("\n").split("\t")
        sites[int(f[0], 16)] = (int(f[4]), f[2])
    return sites


class MsvcRand:
    """IShell+0x08 Random() = MSVC CRT rand() of ZapSpot.exe (interface.tsv, timing.md 3.1):
    s = s * 214013 + 2531011; return (s >> 16) & 0x7fff. The engine seeds it with timeGetTime()
    (Z:0x403dc4), so the seed is a free input; the engine itself consumes one value in the banner
    constructor (Z:0x421c8f) before the game starts (interface.md)."""

    def __init__(self, seed):
        self.s = seed & 0xffffffff
        self.count = 0

    def next(self):
        self.s = (self.s * 214013 + 2531011) & 0xffffffff
        self.count += 1
        return (self.s >> 16) & 0x7fff


class Clock:
    """Engine game clock (GetTickCount based, timing.md 1.3, 5): value at step k = floor(k * step)."""

    def __init__(self, step):
        self.step = step

    def next_at_or_after(self, t):
        k = max(0, math.ceil(t / self.step - 1e-9))
        while math.floor(k * self.step + 1e-9) < t:
            k += 1
        return int(math.floor(k * self.step + 1e-9))


class Engine:
    def __init__(self, m, callsites_path, seed=12345, log=None, clock_step=1.0):
        self.m = m
        self.sites = load_callsites(callsites_path)
        self.rng = MsvcRand(seed)
        self.clock = Clock(clock_step)
        self.objs = []
        self.by_addr = {}
        self.vtables = {}
        self.timers = []              # all ITimer objects
        self.active = []              # started timers in Start order (engine timer array)
        self.buttons, self.listeners = [], []
        self.settings = {}
        self.keys = set()
        self.dialog_answers = []
        self.now = 0
        self.tick = 0
        self.log = log or (lambda line: None)
        self.tick_lines = []
        self.tick_hashes = []
        self.unmodelled = {}
        self.nargs_seen = {}          # (interface, off) -> set of stack-argument counts
        self.direct_reads = {}
        self.ctx = None
        self.state_fn = None          # callable(engine) -> str: game state digest after each tick
        self.recording = []           # (ms, tick, kind, value): input recording, see run.py
        self.event_buf = m.alloc_data(b"\0" * 64)
        m.uc.hook_add(UC_HOOK_MEM_READ, self._on_fake_read, None, FAKE_LO, VT_LO - 1)

    # ------------------------------------------------------------------ objects
    def vtable(self, typ):
        if typ not in self.vtables:
            vt = VT_LO + len(self.vtables) * VT_SLOTS * 4
            for i in range(VT_SLOTS):
                stub = self.m.add_stub("method", f"{typ}+{4 * i:#x}", None, self._method, typ=typ, off=4 * i)
                self.m.w32(vt + 4 * i, stub)
            self.vtables[typ] = vt
        return self.vtables[typ]

    def new(self, typ, **attrs):
        oid = len(self.objs) + 1
        addr = FAKE_LO + oid * OBJ_SIZE
        if addr + OBJ_SIZE > VT_LO:
            raise Stop("fake object region full")
        o = Obj(oid, typ, addr, attrs)
        self.objs.append(o)
        self.by_addr[addr] = o
        self.m.w32(addr, self.vtable(typ))
        return o

    def obj(self, addr):
        return self.by_addr.get(addr)

    def _on_fake_read(self, uc, access, addr, size, value, user):
        base = FAKE_LO + ((addr - FAKE_LO) // OBJ_SIZE) * OBJ_SIZE
        o = self.by_addr.get(base)
        if o is not None and addr != base and o is not self.ctx:
            k = (o.type, addr - base)
            self.direct_reads[k] = self.direct_reads.get(k, 0) + 1

    # ------------------------------------------------------------------ helpers for behaviours
    def out_u32(self, ptr, v):
        self.m.w32(ptr, v & 0xffffffff)

    def out_obj(self, ptr, typ, **attrs):
        o = self.new(typ, **attrs)
        self.m.w32(ptr, o.addr)
        return o

    def text(self, a):
        return self.m.cstr(a).decode("latin-1")

    def gif_size(self, name):
        r = self.m.resources.get((RT_RCDATA, name.upper()))
        if r is None:
            return None
        hdr = self.m.read(r[1], 10)
        if hdr[:3] != b"GIF":
            return None
        return struct.unpack_from("<HH", hdr, 6)

    def canon(self, v):
        """Address-independent rendering of an argument (generic, for unmodelled methods)."""
        o = self.by_addr.get(v)
        if o is not None:
            return repr(o)
        m = self.m
        if m.base + 0x1000 <= v < m.base + 0xc000:
            return f"code:{v - m.delta:08x}"
        s = m.try_cstr(v, 256) if v >= 0x10000 else None
        if s is not None:
            return repr(s)
        if m.is_mapped_data(v):
            return "ptr"
        return str(v - (1 << 32) if v & 0x80000000 else v)

    def canon_args(self, args, sig):
        """sig: one character per argument. i int, b byte (low 8 bits), s C string, n string with
        length in the next argument, o engine object, p pointer (buffer, out-parameter or game
        object), c code pointer. None: generic rendering (may show stale buffer contents)."""
        if sig is None or len(sig) != len(args):
            return [self.canon(a) for a in args]
        out = []
        for i, (k, v) in enumerate(zip(sig, args)):
            if k == "i":
                out.append(str(v - (1 << 32) if v & 0x80000000 else v))
            elif k == "b":
                # uint8 parameters: Moeboid.gam:0x10004d58/0x10004d74/0x10004d91 store colour bytes
                # into stack dwords and push the whole dword (upper 24 bits are stale stack data)
                out.append(str(v & 0xff))
            elif k == "s":
                out.append(repr(self.text(v)) if v else "NULL")
            elif k == "n":
                n = args[i + 1]
                out.append(repr(self.m.read(v, n).decode("latin-1")) if v and n < 0x10000 else "ptr")
            elif k == "o":
                o = self.by_addr.get(v)
                out.append(repr(o) if o is not None else ("NULL" if v == 0 else f"?{v:#x}"))
            elif k == "c":
                out.append(f"code:{v - self.m.delta:08x}")
            else:
                out.append("ptr" if v else "NULL")
        return out

    # ------------------------------------------------------------------ method dispatch
    def nargs_for(self, ret):
        pref = ret - self.m.delta
        for n in (2, 3, 6):
            s = self.sites.get(pref - n)
            if s is not None:
                return s[0], pref - n
        raise Stop(f"no call-site entry for return address {pref:08x}")

    def _method(self, m, st, ret, esp):
        typ, off = st["typ"], st["off"]
        nargs, site = self.nargs_for(ret)
        self.nargs_seen.setdefault((typ, off), set()).add(nargs)
        args = [m.u32(esp + 4 + 4 * i) for i in range(nargs)]
        ecx = m.uc.reg_read(UC_X86_REG_ECX)
        o = self.obj(ecx)
        if o is None or o.type != typ:
            raise Stop(f"method {typ}+{off:#x} called with ECX={ecx:08x} ({o}) from {site:08x}")
        beh = BEHAVIOUR.get((typ, off))
        sig = beh[1] if beh else None
        cargs = self.canon_args(args, sig)   # before the call: out-params are rendered as "ptr"
        if beh is None:
            self.unmodelled[(typ, off)] = self.unmodelled.get((typ, off), 0) + 1
            name = f"UNMODELLED_{off:#x}"
            r = self.new(f"{typ}.r{off:x}").addr
        else:
            name, sig, fn = beh
            if len(sig) != nargs:
                raise Stop(f"{typ}+{off:#x} {name}: call site {site:08x} pushes {nargs} args, mock expects {len(sig)}")
            r = fn(self, o, args)
        r = (r or 0) & 0xffffffff
        ro = self.by_addr.get(r)
        rtxt = repr(ro) if ro is not None else str(r - (1 << 32) if r & 0x80000000 else r)
        line = f"{site:08x} {o!r}+{off:#x} {name}({', '.join(cargs)}) = {rtxt}"
        self.tick_lines.append(line)
        self.log("  " + line)
        return nargs, r

    # ------------------------------------------------------------------ context and ticks
    def make_ctx(self):
        """ctx: [0] IShell vtable, [2] game ISurface, [3] overlay ISurface (help page), [4] IFactory,
        [5] ISystem, [6] ISettings (interface.tsv)."""
        ctx = self.new("IShell")
        self.ctx = ctx
        parts = {2: ("ISurface", "game"), 3: ("ISurface", "overlay"), 4: ("IFactory", None),
                 5: ("ISystem", None), 6: ("ISettings", None)}
        for i, (typ, name) in parts.items():
            self.m.w32(ctx.addr + 4 * i, self.new(typ, name=name, w=500, h=420).addr)
        return ctx.addr

    def begin_tick(self, what):
        self.tick += 1
        self.tick_lines = []
        self.log(f"T{self.tick} ms={self.now} {what}")

    def end_tick(self):
        h = hashlib.sha256("\n".join(self.tick_lines).encode()).hexdigest()[:16]
        state = self.state_fn(self) if self.state_fn else ""
        sh = hashlib.sha256(state.encode()).hexdigest()[:12] if state else "-"
        if state:
            self.log(f"  state {state}")
        self.tick_hashes.append((self.tick, self.now, len(self.tick_lines), h, sh))
        return h

    def enable_scribble(self, byte):
        """Uninitialised-memory probe: before every engine-to-game call fill 128 KiB of stack below
        ESP with `byte`, and fill every operator_new block (Moeboid.gam:0x100051a2) with `byte`.
        Runs with different bytes must give identical per-tick hashes."""
        self.scribble = byte
        ret = self.m.va(0x100051af)   # RET of operator_new: EAX = block, [ESP+4] = size

        def on_new_ret(uc, addr, size, user):
            blk = uc.reg_read(UC_X86_REG_EAX)
            n = self.m.u32(uc.reg_read(UC_X86_REG_ESP) + 4)
            if blk:
                uc.mem_write(blk, bytes([byte]) * n)
        self.m.uc.hook_add(UC_HOOK_CODE, on_new_ret, None, ret, ret)

    def _scribble_stack(self):
        if getattr(self, "scribble", None) is None:
            return
        esp = self.m.uc.reg_read(UC_X86_REG_ESP)
        lo = max(emu.STACK_LO, esp - 0x20000)
        self.m.uc.mem_write(lo, bytes([self.scribble]) * (esp - 0x40 - lo))

    def call_cb(self, cb, words, what):
        self._scribble_stack()
        ev = self.event_buf
        self.m.uc.mem_write(ev, b"\0" * 64)
        for i, w in enumerate(words):
            self.m.w32(ev + 4 * i, w)
        self.begin_tick(what)
        self.m.call(cb, [ev])
        return self.end_tick()

    # ------------------------------------------------------------------ engine timer manager
    def timer_start(self, t):
        a = t.attrs
        if not a["started"]:          # Start on a started timer keeps the phase (timing.md 2.2)
            a.update(started=True, start=self.now, last=self.now)
            self.active.append(t)

    def timer_release(self, t):
        if t.attrs["started"]:
            t.attrs["started"] = False
            self.active.remove(t)     # shifts the array: the pass skips the next timer (timing.md 2.4)

    def timer_pass(self):
        """RunTimers Z:0x4273d0 + PollTimer Z:0x413510: fire when (uint32)(now - last) >= period;
        ev = {userdata, now - start, now - start, now}; last = now after the callback."""
        i = 0
        while i < len(self.active):
            t = self.active[i]
            a = t.attrs
            if ((self.now - a["last"]) & 0xffffffff) >= a["period"]:
                el = (self.now - a["start"]) & 0xffffffff
                a["fired"] += 1
                self.call_cb(a["cb"], [a["user"], el, el, self.now],
                             f"timer {t!r} period={a['period']} elapsed={el} cb={a['cb'] - self.m.delta:08x}")
                a["last"] = self.now
            i += 1

    def run_until(self, t_end, inputs=(), pre_tick=None):
        """Advance the game clock to t_end. At each clock value where a timer is due: apply inputs
        with ms <= that value (window messages are dispatched before a timer pass, timing.md 1.1),
        run pre_tick (input generator), then one timer pass.
        inputs: list of (ms, callable(engine)). pre_tick: callable(engine); it records its inputs."""
        pending = sorted(inputs, key=lambda x: x[0])
        pre_done = None
        while True:
            due = [a.attrs["last"] + a.attrs["period"] for a in self.active]
            c_due = self.clock.next_at_or_after(min(due)) if due else None
            if pending and pending[0][0] <= t_end and (c_due is None or pending[0][0] <= c_due):
                ms, act = pending.pop(0)
                self.now = max(self.now, ms)
                act(self)
                continue
            if c_due is None or c_due > t_end:
                self.now = t_end
                return
            self.now = c_due
            if pre_tick and pre_done != c_due:
                pre_done = c_due      # the generator may start or release timers: evaluate again
                pre_tick(self)
                continue
            self.timer_pass()

    # ------------------------------------------------------------------ inputs (all recorded)
    def record(self, kind, value, in_tick=False):
        """Inputs between ticks apply before tick self.tick + 1; a modal dialog answer is consumed
        inside the current tick (in_tick=True)."""
        self.recording.append((self.now, self.tick if in_tick else self.tick + 1, kind, value))

    def set_key(self, k, down):
        if (k in self.keys) != down:
            (self.keys.add if down else self.keys.discard)(k)
            self.record("keydown" if down else "keyup", k)
            self.log(f"  input ms={self.now} key {k} {'down' if down else 'up'}")

    def click(self, label):
        self.record("click", label)
        for b in reversed(self.buttons):
            if not b.released and label in b.attrs["label"]:
                a = b.attrs
                bid = a["id"] - (1 << 32) if a["id"] & 0x80000000 else a["id"]
                return self.call_cb(a["cb"], [a["user"], a["id"], a["id"]], f"click {b!r} {a['label']!r} id={bid}")
        raise Stop(f"no live button with label {label!r}")

    def key_event(self, vk):
        """WM_KEYDOWN: listener event 0xb, e[2] = wParam (virtual-key code), audio-input.md."""
        self.record("vk", vk)
        self.dispatch(EV_KEYDOWN, vk, f"keydown vk={vk:#x}")

    def event(self, typ):
        """Other listener events, e.g. 0x10 on ISystem: help page (G:0x10001f40)."""
        self.record("event", typ)
        self.dispatch(typ, 0, f"event {typ:#x}")

    def dispatch(self, typ, value, what):
        for h in list(self.listeners):
            a = h.attrs
            if not h.released and a["type"] == typ:
                self.call_cb(a["cb"], [a["user"], 0, value], f"{what} {h!r}")


# ---------------------------------------------------------------------- behaviours
def _release(e, o, a):
    o.released = True
    return 0


def _ret(v):
    return lambda e, o, a: v


def _derive(e, typ, src, **extra):
    at = src.attrs if src is not None else {}
    return e.new(typ, name=at.get("name"), w=at.get("w", 0), h=at.get("h", 0), **extra)


def f_surface_from_file(e, o, a):
    name = e.text(a[0])
    wh = e.gif_size(name) or (0, 0)
    return e.new("ISurface", name=name, w=wh[0], h=wh[1]).addr


def f_out_derived(typ):
    def f(e, o, a):
        e.m.w32(a[-1], _derive(e, typ, o).addr)
        return 0
    return f


def f_size(e, o, a):
    e.out_u32(a[0], o.attrs.get("w", 0))
    e.out_u32(a[1], o.attrs.get("h", 0))
    return 0


def f_setloc(e, o, a):
    o.attrs["pos"] = (a[0], a[1])
    return 0


def f_getloc(e, o, a):
    x, y = o.attrs.get("pos", (0, 0))
    e.out_u32(a[0], x)
    e.out_u32(a[1], y)
    return 0


def f_create_font(e, o, a):
    return e.new("IFont", face=e.text(a[0]), size=a[1], style=a[2]).addr


def f_font_info(e, o, a):
    e.m.uc.mem_write(a[0], o.attrs.get("face", "Arial").encode("latin-1") + b"\0")
    e.out_u32(a[1], o.attrs.get("size", 18))
    e.out_u32(a[2], 0)   # size class: placeholder (interface.tsv: index in table Z:0x435cd0)
    e.out_u32(a[3], o.attrs.get("style", 0))
    return 0


def f_set_font(e, o, a):
    o.attrs["font"] = a[0]
    return 0


def f_get_font(e, o, a):
    f = e.obj(o.attrs.get("font", 0))
    nf = e.new("IFont", face=f.attrs["face"] if f else "Arial", size=f.attrs["size"] if f else 18,
               style=f.attrs["style"] if f else 0)
    e.out_u32(a[0], nf.addr)
    return 0


def f_measure(e, o, a):
    # Placeholder metrics: 7 px per character, 16 px line height. Real metrics: workstream E.
    e.out_u32(a[3], 7 * a[2])
    e.out_u32(a[3] + 4, 16)
    return 0


def f_draw_text(e, o, a):
    o.attrs.setdefault("texts", []).append(e.m.read(a[0], a[1]).decode("latin-1") if a[1] < 4096 else "")
    return 0


def f_create_button(e, o, a):
    faces = e.obj(a[6])
    label = " ".join(faces.attrs.get("texts", [])) if faces else ""
    b = e.new("IButton", parent=a[0], user=a[1], x=a[2], y=a[3], w=a[4], h=a[5], id=a[8], cb=a[9], label=label)
    e.buttons.append(b)
    return b.addr


def f_create_timer(e, o, a):
    t = e.new("ITimer", user=a[0], period=a[1], cb=a[2], started=False, start=0, last=0, fired=0)
    e.timers.append(t)
    return t.addr


def f_timer_start(e, o, a):
    e.timer_start(o)
    return 0


def f_timer_release(e, o, a):
    e.timer_release(o)
    o.released = True
    return 0


def f_listener(e, o, a):
    h = e.new("IListener", source=a[0], type=a[1], user=a[2], cb=a[3])
    e.listeners.append(h)
    return h.addr


def f_play(e, o, a):
    o.attrs.setdefault("plays", []).append((e.tick, e.now))
    return 0


def f_key_state(e, o, a):
    return 0x80 if (a[0] & 0xff) in e.keys else 0


def f_set_value(e, o, a):
    e.settings[e.text(a[0])] = e.text(a[1])
    return 0


def f_get_value(e, o, a):
    k = e.text(a[0])
    if k not in e.settings:
        return NOT_FOUND
    e.m.uc.mem_write(a[1], e.settings[k].encode("latin-1") + b"\0")
    return 0


def f_input_box(e, o, a):
    ans = e.dialog_answers.pop(0) if e.dialog_answers else "TEST"
    e.record("dialog", ans, in_tick=True)
    e.m.uc.mem_write(a[3], ans.encode("latin-1")[:a[4] - 1] + b"\0")
    return 1


# (interface, vtable offset): (method name from interface.tsv, argument signature, behaviour)
BEHAVIOUR = {
    ("IShell", 0x08): ("Random", "", lambda e, o, a: e.rng.next()),
    ("IFactory", 0x08): ("CreateSurfaceFromAnim", "oi", lambda e, o, a: _derive(e, "ISurface", e.obj(a[0])).addr),
    ("IFactory", 0x0c): ("CreateSurfaceFromFile", "si", f_surface_from_file),
    ("IFactory", 0x10): ("CreateSurface", "iii", lambda e, o, a: e.new("ISurface", name=None, w=a[0], h=a[1]).addr),
    ("IFactory", 0x14): ("CreateAnim", "o", lambda e, o, a: _derive(e, "IAnim", e.obj(a[0])).addr),
    ("IFactory", 0x20): ("CreateImage", "iii", lambda e, o, a: e.new("IImage", name=None, w=a[0], h=a[1]).addr),
    ("IFactory", 0x28): ("CreateFont", "sii", f_create_font),
    ("IFactory", 0x30): ("CreateButton", "opiiiioiic", f_create_button),
    ("IFactory", 0x34): ("CreateTimer", "pic", f_create_timer),
    ("IFactory", 0x40): ("CreateSound", "si", lambda e, o, a: e.new("ISound", name=e.text(a[0])).addr),
    ("IFactory", 0x44): ("CreateListener", "oipc", f_listener),
    ("ISystem", 0x08): ("SetCaption", "s", _ret(0)),
    ("ISystem", 0x0c): ("SetGameInProgress", "i", _ret(0)),
    ("ISystem", 0x10): ("SetShellButtons", "i", _ret(0)),
    ("ISystem", 0x14): ("MessageBox", "ssi", _ret(0)),
    ("ISystem", 0x18): ("InputBox", "ssspii", f_input_box),
    ("ISystem", 0x20): ("GetKeyState", "b", f_key_state),
    ("ISettings", 0x10): ("SetGameValue", "ss", f_set_value),
    ("ISettings", 0x14): ("GetGameValue", "sp", f_get_value),
    ("ISurface", 0x04): ("Release", "", _release),
    ("ISurface", 0x08): ("SetLoc", "iii", f_setloc),
    ("ISurface", 0x0c): ("GetLoc", "pp", f_getloc),
    ("ISurface", 0x10): ("SetVisible", "ii", _ret(0)),
    ("ISurface", 0x18): ("AttachSurface", "o", _ret(0)),
    ("ISurface", 0x1c): ("DetachSurface", "o", _ret(0)),
    ("ISurface", 0x2c): ("PlayAnim", "", _ret(0)),
    ("ISurface", 0x34): ("StopAnim", "", _ret(0)),
    ("ISurface", 0x3c): ("GetAnim", "p", f_out_derived("IAnim")),
    ("ISurface", 0x44): ("GetImage", "p", f_out_derived("IImage")),
    ("ISurface", 0x48): ("GetSize", "pp", f_size),
    ("IAnim", 0x04): ("Release", "", _release),
    ("IAnim", 0x10): ("GetImageSeq", "p", f_out_derived("IImageSeq")),
    ("IImageSeq", 0x04): ("Release", "", _release),
    ("IImageSeq", 0x10): ("GetImage", "ip", f_out_derived("IImage")),
    ("IImage", 0x04): ("Release", "", _release),
    ("IImage", 0x0c): ("DrawRect", "iiii", _ret(0)),
    ("IImage", 0x10): ("FillRect", "iiii", _ret(0)),
    ("IImage", 0x18): ("DrawText", "niii", f_draw_text),
    ("IImage", 0x1c): ("SetColor", "bbb", _ret(0)),
    ("IImage", 0x24): ("SetTextColor", "bbb", _ret(0)),
    ("IImage", 0x34): ("ClearToColor", "bbb", _ret(0)),
    ("IImage", 0x40): ("DrawImage", "oii", _ret(0)),
    ("IImage", 0x48): ("SetFont", "o", f_set_font),
    ("IImage", 0x4c): ("GetFont", "p", f_get_font),
    ("IImage", 0x50): ("GetSize", "pp", f_size),
    ("IImage", 0x58): ("MeasureText", "onip", f_measure),
    ("IFont", 0x04): ("Release", "", _release),
    ("IFont", 0x0c): ("GetInfo", "pppp", f_font_info),
    ("ITimer", 0x04): ("Release", "", f_timer_release),
    ("ITimer", 0x08): ("Start", "", f_timer_start),
    ("ISound", 0x04): ("Release", "", _release),
    ("ISound", 0x08): ("Play", "i", f_play),
    ("IButton", 0x04): ("Release", "", _release),
    ("IListener", 0x04): ("Release", "", _release),
}
