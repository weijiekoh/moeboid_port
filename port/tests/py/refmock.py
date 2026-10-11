"""Reference engine mock with the real metrics of the port (M4 lockstep gate).

Copy of analysis/verification/harness/mock.py (that file stays unchanged). Changes, each because the
original engine code differs from the earlier model (the original code wins, task M4):
  R1 MeasureText, GIF sizes: the port's C font/atlas and GIF code through libmoeboid.so (ctypes),
     not the 7 px x 16 px placeholder (fonts.md; Z:0x40c2c0 GetTextExtentPoint32A, Z:0x418d90).
  R2 ISystem::MessageBox returns 1 for IDOK (Z:0x405928), not 0.
  R3 ISystem::GetKeyState returns the GetKeyState SHORT sign-extended in EAX (Z:0x426bf0 returns the
     API value unchanged): down = 0xff80 | toggle (-128 or -127), up = toggle (0 or 1); the toggle bit
     flips at each press (Windows rule; value inferred, the game tests bit 0x80 only).
  R4 ISettings::GetGameValue of a missing name writes "" to the buffer (Z:0x4296d5) and returns 0x19.
  R5 A key state change of the recording is a key message: WM_KEYDOWN fires listener event 0xb with
     the virtual key, WM_KEYUP event 0xd (Z:0x4040e0, Z:0x4269b0); a "vk" event is a key press and
     release (both messages) and changes the key state.
  R6 Event dispatch stops at the first listener that returns 0 (Z:0x427750, Z:0x425870); channels in
     creation order.
  R7 Release returns the remaining external reference count (Z:0x414f90), DetachSurface of a
     surface that is not a child returns 4 (Z:0x4147f0).
  R8 An input is handled at a GetTickCount value: the first clock value at or after its time (the
     earlier model used the raw time; equal for the 1 ms step).

Generic engine-interface mock for Moeboid.gam running in emu.Machine.

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
import ctypes
import hashlib
import math
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import enginedrv  # noqa: E402  (libmoeboid.so: real metrics)

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
        self.L = enginedrv.lib()
        self._pack = open(enginedrv.PACK, "rb").read()
        self.tf = self.L.engine_text_open(self._pack, len(self._pack))
        self.vk_state = {}            # R3: virtual key -> (down, toggle)
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
        data = self.m.read(r[1], r[2])
        w, h = ctypes.c_int32(), ctypes.c_int32()
        if self.L.engine_gif_size(data, len(data), ctypes.byref(w), ctypes.byref(h)) != 0:
            return None
        return (w.value, h.value)   # R1: gfx/gif.c logical screen

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
            extra = {"inner": {"kind": "surface", "ext": 0, "anim": _new_anim(), "children": []}} if typ == "ISurface" else {}
            self.m.w32(ctx.addr + 4 * i, self.new(typ, name=name, w=500, h=420, **extra).addr)
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
        r, _ = self.m.call(cb, [ev])
        self.last_ret = r & 0xffffffff
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
                # R8: a message is handled at a GetTickCount value (the first clock value >= its time)
                self.now = max(self.now, self.clock.next_at_or_after(ms))
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

    KEY_VK = {0: 0x08, 1: 0x2E, 2: 0x09, 3: 0x0D, 5: 0x11, 6: 0x25, 7: 0x27, 8: 0x26, 9: 0x28, 10: 0x24, 11: 0x23,
              12: 0x10}

    def vk_message(self, vk, down):
        """R3, R5: GetKeyState table update and the key message (event 0xb or 0xd)."""
        d, t = self.vk_state.get(vk, (False, 0))
        if down and not d:
            t ^= 1
        self.vk_state[vk] = (down, t)
        if vk == 0x1B:
            return                    # Escape: shell pause toggle, not a game event
        if down and vk == 0x0D:
            return                    # Z:0x4269b0 drops WM_KEYDOWN of VK_RETURN
        self.dispatch(EV_KEYDOWN if down else 0xD, vk, f"key{'down' if down else 'up'} vk={vk:#x}")

    def set_key(self, k, down):
        if (k in self.keys) != down:
            (self.keys.add if down else self.keys.discard)(k)
            self.record("keydown" if down else "keyup", k)
            self.log(f"  input ms={self.now} key {k} {'down' if down else 'up'}")
            self.vk_message(self.KEY_VK.get(k, k), down)

    def click(self, label):
        self.record("click", label)
        for b in reversed(self.buttons):
            if not b.released and label in b.attrs["label"]:
                a = b.attrs
                bid = a["id"] - (1 << 32) if a["id"] & 0x80000000 else a["id"]
                return self.call_cb(a["cb"], [a["user"], a["id"], a["id"]], f"click {b!r} {a['label']!r} id={bid}")
        raise Stop(f"no live button with label {label!r}")

    def key_event(self, vk):
        """Key press and release: WM_KEYDOWN (event 0xb, e[2] = virtual key) and WM_KEYUP (R5)."""
        self.record("vk", vk)
        self.vk_message(vk, True)
        self.vk_message(vk, False)

    def event(self, typ):
        """Other listener events, e.g. 0x10 on ISystem: help page (G:0x10001f40)."""
        self.record("event", typ)
        self.dispatch(typ, 0, f"event {typ:#x}")

    def dispatch(self, typ, value, what):
        """R6: listeners in creation order (one channel per source and type, created with the first
        listener); the dispatch ends at the first callback that returns 0 (Z:0x427750)."""
        for h in list(self.listeners):
            a = h.attrs
            if not h.released and a["type"] == typ:
                self.call_cb(a["cb"], [a["user"], 0, value], f"{what} {h!r}")
                if self.last_ret == 0:
                    return


# ---------------------------------------------------------------------- behaviours
def _release(e, o, a):
    """R7: Z:0x414ff0 -> Z:0x414f90, remaining external count of the inner object."""
    o.released = True
    inner = o.attrs.get("inner")
    if inner is None:
        return 0
    inner["ext"] = max(inner["ext"] - 1, 0)
    return inner["ext"]


def _ret(v):
    return lambda e, o, a: v


# ---------------------------------------------------------------------- R7: inner objects
# Each wrapper (Obj) has attrs["inner"]: the engine object behind it, with its external reference
# count (Z:0x414f70 AddRef at every wrapper creation, Z:0x414f90 Release). Shared inner objects: the
# animation player of CreateSurfaceFromAnim, the sequence of CreateAnim, the image font, the font
# cache entry of CreateFont (Z:0x426070: face without case, size, style).


def _inner(kind, **kw):
    d = {"kind": kind, "ext": 0}
    d.update(kw)
    return d


def _new_seq():
    return _inner("seq", images={})


def _new_anim(seq=None):
    return _inner("anim", seq=seq if seq is not None else _new_seq(), image=None)


def _font_inner(e, face, size, style):
    cache = e.__dict__.setdefault("font_cache", {})
    key = (face.lower(), size, style)
    if key not in cache:
        cache[key] = _inner("font", face=face, size=size, style=style)
    return cache[key]


def _new_image(e):
    return _inner("image", font=_font_inner(e, "Arial", 18, 0))


def _anim_image(e, anim):
    if anim["image"] is None:
        anim["image"] = _new_image(e)
    return anim["image"]


def _wrap(e, typ, inner, **attrs):
    inner["ext"] += 1
    return e.new(typ, inner=inner, **attrs)


def _new_surface(e, typ_attrs, anim):
    return _inner("surface", anim=anim, children=[], **typ_attrs)


def f_surface_from_file(e, o, a):
    name = e.text(a[0])
    wh = e.gif_size(name) or (0, 0)
    return _wrap(e, "ISurface", _new_surface(e, {}, _new_anim()), name=name, w=wh[0], h=wh[1]).addr


def f_surface_from_anim(e, o, a):
    src = e.obj(a[0])
    at = src.attrs if src is not None else {}
    anim = at.get("inner") or _new_anim()
    return _wrap(e, "ISurface", _new_surface(e, {}, anim), name=at.get("name"), w=at.get("w", 0), h=at.get("h", 0)).addr


def f_create_surface(e, o, a):
    return _wrap(e, "ISurface", _new_surface(e, {}, _new_anim()), name=None, w=a[0], h=a[1]).addr


def f_create_anim(e, o, a):
    src = e.obj(a[0])
    at = src.attrs if src is not None else {}
    seq = at.get("inner") or _new_seq()
    return _wrap(e, "IAnim", _new_anim(seq), name=at.get("name"), w=at.get("w", 0), h=at.get("h", 0)).addr


def f_create_image(e, o, a):
    return _wrap(e, "IImage", _new_image(e), name=None, w=a[0], h=a[1]).addr


def f_get_anim(e, o, a):
    inner = o.attrs.get("inner") or _new_surface(e, {}, _new_anim())
    at = o.attrs
    e.m.w32(a[0], _wrap(e, "IAnim", inner["anim"], name=at.get("name"), w=at.get("w", 0), h=at.get("h", 0)).addr)
    return 0


def f_get_image(e, o, a):
    inner = o.attrs.get("inner") or _new_surface(e, {}, _new_anim())
    at = o.attrs
    img = _anim_image(e, inner["anim"])
    e.m.w32(a[0], _wrap(e, "IImage", img, name=at.get("name"), w=at.get("w", 0), h=at.get("h", 0)).addr)
    return 0


def f_get_seq(e, o, a):
    inner = o.attrs.get("inner") or _new_anim()
    at = o.attrs
    e.m.w32(a[0], _wrap(e, "IImageSeq", inner["seq"], name=at.get("name"), w=at.get("w", 0), h=at.get("h", 0)).addr)
    return 0


def f_seq_image(e, o, a):
    inner = o.attrs.get("inner") or _new_seq()
    img = inner["images"].setdefault(a[0], _new_image(e))
    at = o.attrs
    e.m.w32(a[1], _wrap(e, "IImage", img, name=at.get("name"), w=at.get("w", 0), h=at.get("h", 0)).addr)
    return 0


def f_attach(e, o, a):
    """Z:0x414780: append (no duplicate check)."""
    c = e.obj(a[0])
    if o.attrs.get("inner") is not None and c is not None and c.attrs.get("inner") is not None:
        o.attrs["inner"]["children"].append(c.attrs["inner"])
    return 0


def f_detach(e, o, a):
    """Z:0x4147f0: 4 when the surface is not a child (R7)."""
    c = e.obj(a[0])
    ch = o.attrs.get("inner", {}).get("children") if o.attrs.get("inner") is not None else None
    ci = c.attrs.get("inner") if c is not None else None
    if ch is None or ci is None:
        return 0
    for i, x in enumerate(ch):
        if x is ci:
            del ch[i]
            return 0
    return 4


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
    face, size, style = e.text(a[0]), a[1], a[2]
    inner = _font_inner(e, face, size, style)
    return _wrap(e, "IFont", inner, face=inner["face"], size=size, style=style).addr


def f_font_info(e, o, a):
    """Z:0x427e60: face of the cache entry, size, size class 0 (fonts.md 3.1), style."""
    e.m.uc.mem_write(a[0], o.attrs.get("face", "Arial").encode("latin-1") + b"\0")
    e.out_u32(a[1], o.attrs.get("size", 18))
    e.out_u32(a[2], 0)
    e.out_u32(a[3], o.attrs.get("style", 0))
    return 0


def f_set_font(e, o, a):
    o.attrs["font"] = a[0]
    f = e.obj(a[0])
    if o.attrs.get("inner") is not None and f is not None and f.attrs.get("inner") is not None:
        o.attrs["inner"]["font"] = f.attrs["inner"]
    return 0


def f_get_font(e, o, a):
    img = o.attrs.get("inner") or _new_image(e)
    fi = img["font"]
    nf = _wrap(e, "IFont", fi, face=fi["face"], size=fi["size"], style=fi["style"])
    e.out_u32(a[0], nf.addr)
    return 0


def f_measure(e, o, a):
    """R1: GetTextExtentPoint32A with the port's glyph atlases (gdi_text.c)."""
    f = e.obj(a[0])
    fa = f.attrs if f is not None else {}
    text = e.m.read(a[1], a[2]) if a[1] and a[2] < 0x10000 else b""
    cx, cy = ctypes.c_int32(), ctypes.c_int32()
    e.L.engine_text_measure(e.tf, fa.get("face", "Arial").encode("latin-1"), fa.get("size", 18), fa.get("style", 0),
                            text, len(text), ctypes.byref(cx), ctypes.byref(cy))
    e.out_u32(a[3], cx.value)
    e.out_u32(a[3] + 4, cy.value)
    return 0


def f_draw_text(e, o, a):
    o.attrs.setdefault("texts", []).append(e.m.read(a[0], a[1]).decode("latin-1") if a[1] < 4096 else "")
    return 0


def f_create_button(e, o, a):
    faces = e.obj(a[6])
    label = " ".join(faces.attrs.get("texts", [])) if faces else ""
    bi = _inner("button", children=[])
    b = _wrap(e, "IButton", bi, parent=a[0], user=a[1], x=a[2], y=a[3], w=a[4], h=a[5], id=a[8],
              cb=a[9], label=label)
    p = e.obj(a[0])
    if p is not None and p.attrs.get("inner") is not None:
        p.attrs["inner"]["children"].append(bi)   # Z:0x419730 attaches the button to its parent
    e.buttons.append(b)
    return b.addr


def f_create_timer(e, o, a):
    t = _wrap(e, "ITimer", _inner("timer"), user=a[0], period=a[1], cb=a[2], started=False, start=0, last=0, fired=0)
    e.timers.append(t)
    return t.addr


def f_timer_start(e, o, a):
    e.timer_start(o)
    return 0


def f_timer_release(e, o, a):
    e.timer_release(o)
    return _release(e, o, a)


def f_listener(e, o, a):
    h = _wrap(e, "IListener", _inner("listener"), source=a[0], type=a[1], user=a[2], cb=a[3])
    e.listeners.append(h)
    return h.addr


def f_create_sound(e, o, a):
    return _wrap(e, "ISound", _inner("sound"), name=e.text(a[0])).addr


def f_play(e, o, a):
    o.attrs.setdefault("plays", []).append((e.tick, e.now))
    return 0


def f_key_state(e, o, a):
    """R3: GetKeyState SHORT sign-extended: down 0xff80 | toggle, up toggle."""
    vk = e.KEY_VK.get(a[0] & 0xff, a[0] & 0xff)
    down, toggle = e.vk_state.get(vk, (False, 0))
    return (0xFFFFFF80 | toggle) if down else toggle


def f_set_value(e, o, a):
    e.settings[e.text(a[0])] = e.text(a[1])
    return 0


def f_get_value(e, o, a):
    """R4: missing name: "" and 0x19 (Z:0x4294f0)."""
    k = e.text(a[0])
    if k not in e.settings:
        e.m.uc.mem_write(a[1], b"\0")
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
    ("IFactory", 0x08): ("CreateSurfaceFromAnim", "oi", f_surface_from_anim),
    ("IFactory", 0x0c): ("CreateSurfaceFromFile", "si", f_surface_from_file),
    ("IFactory", 0x10): ("CreateSurface", "iii", f_create_surface),
    ("IFactory", 0x14): ("CreateAnim", "o", f_create_anim),
    ("IFactory", 0x20): ("CreateImage", "iii", f_create_image),
    ("IFactory", 0x28): ("CreateFont", "sii", f_create_font),
    ("IFactory", 0x30): ("CreateButton", "opiiiioiic", f_create_button),
    ("IFactory", 0x34): ("CreateTimer", "pic", f_create_timer),
    ("IFactory", 0x40): ("CreateSound", "si", f_create_sound),
    ("IFactory", 0x44): ("CreateListener", "oipc", f_listener),
    ("ISystem", 0x08): ("SetCaption", "s", _ret(0)),
    ("ISystem", 0x0c): ("SetGameInProgress", "i", _ret(0)),
    ("ISystem", 0x10): ("SetShellButtons", "i", _ret(0)),
    ("ISystem", 0x14): ("MessageBox", "ssi", _ret(1)),   # R2: IDOK
    ("ISystem", 0x18): ("InputBox", "ssspii", f_input_box),
    ("ISystem", 0x20): ("GetKeyState", "b", f_key_state),
    ("ISettings", 0x10): ("SetGameValue", "ss", f_set_value),
    ("ISettings", 0x14): ("GetGameValue", "sp", f_get_value),
    ("ISurface", 0x04): ("Release", "", _release),
    ("ISurface", 0x08): ("SetLoc", "iii", f_setloc),
    ("ISurface", 0x0c): ("GetLoc", "pp", f_getloc),
    ("ISurface", 0x10): ("SetVisible", "ii", _ret(0)),
    ("ISurface", 0x18): ("AttachSurface", "o", f_attach),
    ("ISurface", 0x1c): ("DetachSurface", "o", f_detach),
    ("ISurface", 0x2c): ("PlayAnim", "", _ret(0)),
    ("ISurface", 0x34): ("StopAnim", "", _ret(0)),
    ("ISurface", 0x3c): ("GetAnim", "p", f_get_anim),
    ("ISurface", 0x44): ("GetImage", "p", f_get_image),
    ("ISurface", 0x48): ("GetSize", "pp", f_size),
    ("IAnim", 0x04): ("Release", "", _release),
    ("IAnim", 0x10): ("GetImageSeq", "p", f_get_seq),
    ("IImageSeq", 0x04): ("Release", "", _release),
    ("IImageSeq", 0x10): ("GetImage", "ip", f_seq_image),
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
