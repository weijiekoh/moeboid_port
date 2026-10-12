"""Drive Moeboid.gam in Unicorn against the mocked engine: DLL entry, Shell_StartApplet, scripted
input, timer ticks. Writes a per-call log and a per-tick hash table.

Usage: python -I -B run.py [--out PREFIX] [--fill BYTE] [--seed N] [--clock-step MS] [--ms N] [--full-ticks N] [--log-range A-B] [--coverage]
                           [--no-fsin-table] [--base ADDR] [--script NAME] [--scribble BYTE]
                           [--replay PREFIX.input.tsv]
Outputs: PREFIX.log (calls of the first --full-ticks ticks, then one line per tick),
         PREFIX.ticks.tsv (tick, ms, calls, sha256 prefix of the canonical call lines, sha256 prefix
         of the game state digest; the digest text is in PREFIX.log for the logged ticks),
         PREFIX.input.tsv (input recording; replay with --replay PREFIX.input.tsv).
"""
import argparse
import hashlib
import os
import struct
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import emu  # noqa: E402
import mock  # noqa: E402

ROOT = os.path.abspath(os.path.join(HERE, "..", "..", ".."))
GAM = os.path.join(ROOT, "extracted", "Moeboid.gam")
VK = {"left": 6, "right": 7, "up": 8, "down": 9}   # engine key ids (inferred, Moeboid.gam:0x10003200)
GAMEPLAY_VTABLE = 0x1000d158                        # vtable of the gameplay state (Moeboid.gam:0x10002a80)
TITLE_VTABLE = 0x1000d15c                           # vtable of the title state (Moeboid.gam:0x100041a0)


def key(name, down):
    return lambda e: e.set_key(VK[name], down)


def click(label):
    return lambda e: e.click(label)


def f32(m, a):
    return struct.unpack("<f", m.read(a, 4))[0]


def autopilot(e):
    """Input generator: read game state from guest memory and steer the Moeboid to the nearest
    active baddie it can eat; answer the continue and play-again prompts. Its key changes are
    recorded like any other input, so a replay does not need the autopilot."""
    m = e.m
    game = m.u32(m.va(0x1000f5d8))
    st = m.u32(game) if game else 0
    if not st or m.u32(st) != m.va(GAMEPLAY_VTABLE):
        return
    mode = m.u32(st + 0x1bc)            # 0 play, 1 play-again prompt, 2 continue prompt
    if mode == 2:
        e.key_event(0x20)               # VK_SPACE
        return
    if mode == 1:
        if getattr(e, "answer_no_once", False):
            e.answer_no_once = False
            e.click("No")               # button "No (N)": back to the title screen
        else:
            e.key_event(0x59)           # VK 'Y': play again
        return
    pl = m.u32(st + 0xc)
    plevel, px, py = m.u32(pl), f32(m, pl + 0x10), f32(m, pl + 0x14)
    best = None
    for i in range(m.u32(st + 0x1a0)):
        b = m.u32(st + 0x10 + 4 * i)
        if not b or m.u32(b + 4) != 0 or m.u32(b) > plevel:
            continue
        d = (f32(m, b + 0xc) - px) ** 2 + (f32(m, b + 0x10) - py) ** 2
        if best is None or d < best[0]:
            best = (d, f32(m, b + 0xc), f32(m, b + 0x10))
    tx, ty = (best[1], best[2]) if best else (245.0, 209.0)
    dx, dy = tx - px, ty - py
    e.set_key(VK["right"], dx > 4)
    e.set_key(VK["left"], dx < -4)
    e.set_key(VK["down"], dy > 4)
    e.set_key(VK["up"], dy < -4)


GAME_LO, GAME_HI = 0x10001000, 0x10005110      # game code (CRT starts at __ftol 0x10005110)


def game_functions():
    """Entry addresses of the game functions (Ghidra functions.tsv), CRT excluded."""
    path = os.path.join(ROOT, "analysis", "decomp", "Moeboid.gam", "functions.tsv")
    out = []
    for i, line in enumerate(open(path)):
        if i:
            a = int(line.split("\t")[0], 16)
            if GAME_LO <= a < GAME_HI:
                out.append(a)
    return out


def game_state(e):
    """Game state digest after a tick (gameplay state only): player level, x, y (float32 bits),
    velocity x, y (bits), score, lives, baddie count, sha256 prefix of all baddie records.
    Field offsets from Moeboid.gam:0x10002a80 (state), 0x10001f50 (player), 0x100011a0 (baddie)."""
    m = e.m
    game = m.u32(m.va(0x1000f5d8))
    st = m.u32(game) if game else 0
    if not st or m.u32(st) != m.va(GAMEPLAY_VTABLE):
        return ""
    pl = m.u32(st + 0xc)
    n = m.u32(st + 0x1a0)
    h = hashlib.sha256()
    for i in range(n):
        b = m.u32(st + 0x10 + 4 * i)
        if b:   # level, sprite present flags, x, y, vx, vy, w, h, flags, timers (0x38 bytes)
            rec = bytearray(m.read(b, 0x38))
            for off in (4, 8):          # engine object pointers: keep only "present" information
                rec[off:off + 4] = (b"\1\0\0\0" if any(rec[off:off + 4]) else b"\0\0\0\0")
            for off in (0x26, 0x27, 0x31, 0x32, 0x33):   # struct padding, never written (scribble test)
                rec[off] = 0
            h.update(bytes(rec))
    return (f"lvl={m.u32(pl)} x={m.u32(pl + 0x10):08x} y={m.u32(pl + 0x14):08x} "
            f"vx={m.u32(pl + 0x18):08x} vy={m.u32(pl + 0x1c):08x} score={m.u32(st + 8)} "
            f"lives={m.u32(st + 0x1a4) - (1 << 32) if m.u32(st + 0x1a4) & 0x80000000 else m.u32(st + 0x1a4)} "
            f"baddies={n} bh={h.hexdigest()[:12]}")


SCRIPTS = {
    # Title screen, click Start at 1000 ms, wait for the 3 s game-start timer, then steer.
    "start": ([(1000, click("Start")),
               (4500, key("right", True)), (5500, key("right", False)),
               (5600, key("up", True)), (6400, key("up", False)),
               (6500, key("left", True)), (7700, key("left", False)),
               (7800, key("down", True)), (8600, key("down", False))], None),
    "autopilot": ([(500, lambda e: e.event(16)), (1000, click("Start"))], autopilot),
    "idle": ([], None),
    # Coverage tour: help page, CREDITS screen and its Done button, Start, autopilot; at the first
    # game over the No button (title screen), then the INVINCIBLE cheat and Start again.
    "tour": ([(500, lambda e: e.event(16))]
             + [(1000 + 50 * i, (lambda c: lambda e: e.key_event(ord(c)))(c)) for i, c in enumerate("CREDITS")]
             + [(4000, click("Done")), (4500, lambda e: setattr(e, "answer_no_once", True)),
                (5000, click("Start"))], lambda e: tour_pilot(e)),
}


SETTINGS = {
    "none": {},
    # high-score table with low scores, so that the first game over opens the InputBox
    "lowscores": {f"Score{i}{k}": v for i in range(1, 6)
                  for k, v in (("Name", "ZapSpot"), ("Score", str(60 - 10 * i)))},
}


def tour_pilot(e):
    """autopilot, plus: when the title screen is back after the No button, type INVINCIBLE and
    click Start once."""
    m = e.m
    game = m.u32(m.va(0x1000f5d8))
    st = m.u32(game) if game else 0
    no_now = st and m.u32(st) == m.va(GAMEPLAY_VTABLE) and m.u32(st + 0x1bc) == 1 and \
        getattr(e, "answer_no_once", False)
    autopilot(e)
    if no_now:                          # the title screen is back (no timer runs there)
        for c in "INVINCIBLE":
            e.key_event(ord(c))
        e.click("Start")


def load_replay(path, e):
    """Read an input recording (format: see write_recording) into timed inputs and settings."""
    inputs = []
    for line in open(path):
        if line.startswith("# setting\t"):
            _, k, v = line.rstrip("\n").split("\t")
            e.settings[k] = v
            continue
        if line.startswith("#") or line.startswith("ms\t"):
            continue
        ms, tick, kind, value = line.rstrip("\n").split("\t")
        ms = int(ms)
        if kind in ("keydown", "keyup"):
            inputs.append((ms, (lambda k, d: lambda e: e.set_key(k, d))(int(value), kind == "keydown")))
        elif kind == "click":
            inputs.append((ms, (lambda v: lambda e: e.click(v))(value)))
        elif kind == "vk":
            inputs.append((ms, (lambda v: lambda e: e.key_event(v))(int(value))))
        elif kind == "event":
            inputs.append((ms, (lambda v: lambda e: e.event(v))(int(value))))
        elif kind == "dialog":
            e.dialog_answers.append(value)
    return inputs


def write_recording(path, e, ns, gam_sha):
    with open(path, "w") as f:
        f.write(f"# moeboid-input v1\n# gam_sha256={gam_sha}\n"
                f"# engine_rng=msvc_rand seed={ns.seed} (state before the first game call)\n"
                f"# clock=floor(k*{ns.clock_step}) ms; timer rule: fire when now-last>=period, last=now\n"
                f"# gam_crt_rand_seed=1 (fresh DLL load)\n"
                f"# kinds: keydown/keyup VALUE=engine key index (GetKeyState), vk VALUE=WM_KEYDOWN wParam,\n"
                f"#        click VALUE=button label, event VALUE=listener event id, dialog VALUE=InputBox text\n")
        for k, v in e.initial_settings.items():
            f.write(f"# setting\t{k}\t{v}\n")
        f.write("ms\ttick\tkind\tvalue\n")
        for ms, tick, kind, value in e.recording:
            f.write(f"{ms}\t{tick}\t{kind}\t{value}\n")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=os.path.join(HERE, "..", "logs", "run_start"))
    ap.add_argument("--fill", type=lambda s: int(s, 0), default=0)
    ap.add_argument("--seed", type=int, default=12345)
    ap.add_argument("--clock-step", type=float, default=1.0,
                    help="GetTickCount step in ms (1, 10.0144, 15.625, 54.925; timing.md 5)")
    ap.add_argument("--ms", type=int, default=12000)
    ap.add_argument("--full-ticks", type=int, default=12)
    ap.add_argument("--log-range", default=None, help="also log all calls of ticks A-B")
    ap.add_argument("--coverage", action="store_true",
                    help="report executed game functions and code bytes (0x10001000..0x10005110)")
    ap.add_argument("--no-fsin-table", action="store_true")
    ap.add_argument("--base", type=lambda s: int(s, 0), default=emu.PREFERRED_BASE)
    ap.add_argument("--script", default="start")
    ap.add_argument("--replay", default=None, help="input recording (PREFIX.input.tsv) to replay")
    ap.add_argument("--settings", default="lowscores", choices=sorted(SETTINGS),
                    help="initial ISettings store (ignored with --replay: the recording has it)")
    ap.add_argument("--scribble", type=lambda s: int(s, 0), default=None,
                    help="fill stack below ESP before each callback and new heap blocks with this byte")
    ns = ap.parse_args()
    os.makedirs(os.path.dirname(os.path.abspath(ns.out)), exist_ok=True)
    out = open(ns.out + ".log", "w")
    state = {"full": ns.full_ticks > 0 or not ns.log_range}

    def log(line):
        if state["full"] or line.startswith("# "):
            out.write(line + "\n")

    def api_log(rec):
        if rec.get("kind") == "api" and not rec["name"].endswith(("HeapAlloc", "HeapFree", "HeapReAlloc")):
            log(f"  api {rec['name']}({', '.join(map(str, rec.get('args', [])))}) = {rec.get('ret')}"
                + (f" {rec['note']}" if "note" in rec else ""))
        elif rec.get("kind") in ("policy", "stdio"):
            log(f"  {rec['kind']} {rec.get('note') or rec.get('text')}")

    t0 = time.time()
    m = emu.Machine(GAM, base=ns.base, fill=ns.fill, logger=api_log)
    if not ns.no_fsin_table:
        m.install_fsin_table()
    e = mock.Engine(m, os.path.join(HERE, "callsites.tsv"), seed=ns.seed, log=log, clock_step=ns.clock_step)
    if ns.scribble is not None:
        e.enable_scribble(ns.scribble)
    e.state_fn = game_state
    cov = set()
    if ns.coverage:
        from unicorn import UC_HOOK_BLOCK
        m.uc.hook_add(UC_HOOK_BLOCK, lambda uc, a, n, u: cov.add((a - m.delta, n)), None,
                      m.va(GAME_LO), m.va(GAME_HI) - 1)
    if ns.replay:
        inputs, pre = load_replay(ns.replay, e), None
    else:
        e.settings.update(SETTINGS[ns.settings])
        inputs, pre = SCRIPTS[ns.script]
    e.initial_settings = dict(e.settings)
    log(f"# Moeboid.gam base={m.base:08x} relocations={m.reloc_count} fill={ns.fill:#x} seed={ns.seed} clock_step={ns.clock_step} "
        f"fsin_table={not ns.no_fsin_table} script={ns.script} replay={ns.replay} scribble={ns.scribble}")
    status = "ok"
    try:
        e.begin_tick("DllMain(DLL_PROCESS_ATTACH)")
        r, _ = m.call(m.entry, [m.base, 1, 0])
        e.end_tick()
        log(f"# DllMain returned {r}")
        ctx = e.make_ctx()
        e.begin_tick("Shell_StartApplet(ctx)")
        m.call(m.exports["Shell_StartApplet"], [ctx])
        e.end_tick()

        lo, hi = map(int, ns.log_range.split("-")) if ns.log_range else (0, -1)

        def limit_log(ev):
            state["full"] = e.tick < ns.full_ticks or lo - 1 <= e.tick <= hi - 1
        orig_begin = e.begin_tick

        def begin(what):
            limit_log(None)
            orig_begin(what)
        e.begin_tick = begin
        e.run_until(ns.ms, inputs, pre)
        state["full"] = True
        e.begin_tick("Shell_StopApplet()")
        m.call(m.exports["Shell_StopApplet"], [])
        e.end_tick()
    except (emu.GuestFault, emu.Stop) as ex:
        status = f"STOPPED at tick {e.tick} ms={e.now}: {ex}"
    state["full"] = True
    log(f"# status: {status}")
    log(f"# ticks={e.tick} sim_ms={e.now} rng_calls={e.rng.count} objects={len(e.objs)} "
        f"started_timers={len(e.active)} "
        f"fsin_hits={getattr(m, 'fsin_hits', 0)} wall_s={time.time() - t0:.1f}")
    log(f"# unmodelled: {sorted((f'{t}+{o:#x}', n) for (t, o), n in e.unmodelled.items())}")
    log(f"# direct field reads of engine objects: {sorted((f'{t}+{o:#x}', n) for (t, o), n in e.direct_reads.items())}")
    multi = {k: v for k, v in e.nargs_seen.items() if len(v) > 1}
    log(f"# (type, offset) with more than one stack-argument count: "
        f"{sorted((f'{t}+{o:#x}', sorted(v)) for (t, o), v in multi.items())}")
    log(f"# kernel32 calls: {sorted(m.api_counts.items())}")
    if ns.coverage:
        covered = set()
        for a, n in cov:
            covered.update(range(a, min(a + n, GAME_HI)))
        funcs = game_functions()
        hit = [f for f in funcs if f in covered]
        missed = [f"{f:08x}" for f in funcs if f not in covered]
        log(f"# coverage: game functions entered {len(hit)}/{len(funcs)}; game code bytes executed "
            f"{len(covered)}/{GAME_HI - GAME_LO} ({100 * len(covered) / (GAME_HI - GAME_LO):.1f}%)")
        log(f"# functions not entered: {' '.join(missed)}")
    for o in e.objs:
        if o.type == "ISound" and o.attrs.get("plays"):
            p = o.attrs["plays"]
            log(f"# sound {o.attrs['name']}: {len(p)} plays, first at tick {p[0][0]} ms={p[0][1]}")
    out.close()
    write_recording(ns.out + ".input.tsv", e, ns, hashlib.sha256(open(GAM, "rb").read()).hexdigest())
    with open(ns.out + ".ticks.tsv", "w") as f:
        f.write("tick\tms\tcalls\tcall_log_sha256_16\tgame_state_sha256_12\n")
        for row in e.tick_hashes:
            f.write("\t".join(map(str, row)) + "\n")
    print(status)
    print(f"ticks={e.tick} sim_ms={e.now} objects={len(e.objs)} unmodelled={len(e.unmodelled)}")


if __name__ == "__main__":
    main()
