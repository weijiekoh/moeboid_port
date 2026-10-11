"""Gate test B of M2: corpus lockstep of the C interpreter against Unicorn.

Runs analysis/verification/harness/run.py on three backends and compares the per-tick hash tables
(tick, game-clock ms, call count, SHA-256 of the canonical call lines, SHA-256 of the game state):
  unicorn  run.py as is (reference backend);
  shim     run.py unchanged on the C CPU through the Unicorn shim (cshim.py; Python KERNEL32 stubs,
           Python PE loader, Python stub dispatch);
  native   run.py with cmachine.CMachine: C PE loader, C KERNEL32 stubs (k32.c), engine thunks through
           engine_dispatch, guest calls through cpu_call (the parts M4 uses); engine = Python mock.
Cases: the recordings analysis/verification/logs/run_autopilot.input.tsv (60 s; also compared with
logs/run_autopilot.ticks.tsv) and run_tour.input.tsv (120 s, --coverage), plus the variants of
checks.py (live autopilot script, scribble bytes, initial fill, relocated image, no x87 table, other
seed and clock step; the last two must diverge from the reference at the same tick on every backend).
Extra check: guest memory identity (image, heap, VirtualAlloc arena, stack, TEB, engine data, fake
objects) and registers of the Unicorn machine (emu.py) and the C machine (C PE loader, k32.c, bridge)
after DllMain, Shell_StartApplet and 4 s / 60 s of the autopilot recording.
Writes port/tests/py/results/corpus.txt. Exit status 0 if every comparison holds.

Usage: python -I -B port/tests/py/test_corpus.py [--quick]   (--quick: recordings only)
"""
import argparse
import hashlib
import os
import subprocess
import sys
import tempfile
import time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, "..", "..", ".."))
HARNESS = os.path.join(ROOT, "analysis", "verification", "harness")
LOGS = os.path.join(ROOT, "analysis", "verification", "logs")
RESULTS = os.path.join(HERE, "results")
AUTO = os.path.join(LOGS, "run_autopilot.input.tsv")
TOUR = os.path.join(LOGS, "run_tour.input.tsv")
GAM = os.path.join(ROOT, "extracted", "Moeboid.gam")

RUNNERS = {
    "unicorn": os.path.join(HARNESS, "run.py"),
    "shim": os.path.join(HERE, "run_c.py"),
    "native": os.path.join(HERE, "run_native.py"),
}

CASES = [
    # name, run.py arguments, reference ticks file, expected relation to the autopilot reference
    ("autopilot replay", ["--replay", AUTO, "--ms", "60000"], os.path.join(LOGS, "run_autopilot.ticks.tsv"), "equal"),
    ("tour replay --coverage", ["--replay", TOUR, "--ms", "120000", "--coverage"], None, None),
    ("autopilot script (live generator)", ["--script", "autopilot", "--ms", "60000"], "auto", "equal"),
    ("replay, scribble 0x00", ["--replay", AUTO, "--ms", "60000", "--scribble", "0x00"], "auto", "equal"),
    ("replay, scribble 0xa5", ["--replay", AUTO, "--ms", "60000", "--scribble", "0xa5"], "auto", "equal"),
    ("replay, scribble 0x5a", ["--replay", AUTO, "--ms", "60000", "--scribble", "0x5a"], "auto", "equal"),
    ("replay, fill 0xcc", ["--replay", AUTO, "--ms", "60000", "--fill", "0xcc"], "auto", "equal"),
    ("replay, image at 0x20000000", ["--replay", AUTO, "--ms", "60000", "--base", "0x20000000"], "auto", "equal"),
    ("replay, no x87 table option", ["--replay", AUTO, "--ms", "60000", "--no-fsin-table"], "auto", "equal"),
    ("replay, seed 999", ["--replay", AUTO, "--ms", "60000", "--seed", "999"], "auto", "diverge 35"),
    ("replay, clock step 15.625", ["--replay", AUTO, "--ms", "60000", "--clock-step", "15.625"], "auto", "diverge 5"),
]


def hashes(path):
    rows = [ln.rstrip("\n").split("\t") for ln in open(path)][1:]
    return [(int(r[0]), int(r[1]), r[2], r[3], r[4] if len(r) > 4 else "") for r in rows]


def compare(a, b):
    for x, y in zip(a, b):
        if x != y:
            return f"DIVERGES at tick {x[0]}", x[0]
    if len(a) != len(b):
        return f"DIVERGES: tick count {len(a)} vs {len(b)}", min(len(a), len(b)) + 1
    return f"identical ({len(a)} ticks)", None


def run(backend, args, out):
    t0 = time.time()
    p = subprocess.run([sys.executable, "-I", "-B", RUNNERS[backend], "--out", out, "--full-ticks", "0", *args],
                       capture_output=True, text=True, cwd=ROOT)
    status = p.stdout.strip().splitlines()[0] if p.stdout.strip() else ("ERROR " + p.stderr.strip()[-400:])
    return status, time.time() - t0


def coverage_line(prefix):
    try:
        return [ln.rstrip("\n") for ln in open(prefix + ".log") if ln.startswith("# coverage")]
    except OSError:
        return []


def memory_identity(lines, ms):
    """Run Unicorn machine (emu.py, Python KERNEL32) and C machine side by side in this process.
    Both use emu.py's x87 table hook (identical engine data layout); the C CPU then runs the
    FSTP ST0; FLD tword path of the hook stub."""
    sys.path.insert(0, HARNESS)
    sys.path.insert(0, HERE)
    import emu
    import mock
    import run as runmod
    import cmachine
    CM = cmachine.make_class(emu)
    CM.py_fsin_hook = True
    out = {}
    for name, cls in (("unicorn", emu.Machine), ("c", CM)):
        m = cls(GAM)
        m.install_fsin_table()
        e = mock.Engine(m, os.path.join(HARNESS, "callsites.tsv"), seed=12345, clock_step=1.0)
        e.state_fn = runmod.game_state
        inputs = runmod.load_replay(AUTO, e)
        m.call(m.entry, [m.base, 1, 0])
        ctx = e.make_ctx()
        m.call(m.exports["Shell_StartApplet"], [ctx])
        e.run_until(ms, inputs, None)
        regions = {"image": (m.base, m.image_size), "heap": (emu.HEAP_LO, m.heap_next - emu.HEAP_LO),
                   "va": (emu.VA_LO, 0x200000), "stack": (emu.STACK_LO, emu.STACK_SIZE), "teb": (emu.TEB_ADDR, 0x1000),
                   "data": (emu.DATA_LO, m.next_data - emu.DATA_LO), "fake": (emu.FAKE_LO, 0x40 * (len(e.objs) + 2))}
        digest = {k: hashlib.sha256(m.read(a, n)).hexdigest()[:16] for k, (a, n) in regions.items()}
        from unicorn.x86_const import UC_X86_REG_ESP, UC_X86_REG_FPCW, UC_X86_REG_FPSW, UC_X86_REG_EAX
        digest["regs"] = (m.uc.reg_read(UC_X86_REG_ESP), m.uc.reg_read(UC_X86_REG_FPCW),
                          m.uc.reg_read(UC_X86_REG_FPSW), m.uc.reg_read(UC_X86_REG_EAX))
        digest["heap_next"] = m.heap_next
        digest["ticks"] = e.tick_hashes[-1]
        out[name] = digest
    same = out["unicorn"] == out["c"]
    lines.append(f"memory identity after DllMain, Shell_StartApplet, {ms} ms of the autopilot recording "
                 f"(emu.py machine on Unicorn vs C machine): {'identical' if same else 'DIFFERENT'}")
    for k in out["unicorn"]:
        lines.append(f"  {k}: unicorn={out['unicorn'][k]} c={out['c'][k]}")
    return same


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--quick", action="store_true")
    ns = ap.parse_args()
    t0 = time.time()
    cases = CASES[:2] if ns.quick else CASES
    lines = ["# test_corpus.py: per-tick hashes of run.py on Unicorn, C CPU via shim, C machine (native bridge)"]
    ok = True
    with tempfile.TemporaryDirectory() as tmp:
        auto_ref = None
        for i, (name, args, ref, expect) in enumerate(cases):
            res = {}
            for be in RUNNERS:
                out = os.path.join(tmp, f"case{i}_{be}")
                status, wall = run(be, args, out)
                res[be] = (status, wall, out)
            hu = hashes(res["unicorn"][2] + ".ticks.tsv") if os.path.exists(res["unicorn"][2] + ".ticks.tsv") else []
            if i == 0:
                auto_ref = hu
            lines.append(f"{name}: " + ", ".join(f"{be} {s} {w:.1f}s" for be, (s, w, _) in res.items()))
            for be in ("shim", "native"):
                path = res[be][2] + ".ticks.tsv"
                hc = hashes(path) if os.path.exists(path) else []
                txt, _ = compare(hu, hc)
                good = txt.startswith("identical") and res[be][0] == "ok" and res["unicorn"][0] == "ok"
                ok &= good
                lines.append(f"  {be} vs unicorn: {txt}{'' if good else '  <-- FAIL'}")
            if ref:
                refh = hashes(ref) if ref != "auto" else auto_ref
                for be in RUNNERS:
                    path = res[be][2] + ".ticks.tsv"
                    txt, tick = compare(refh, hashes(path) if os.path.exists(path) else [])
                    if expect == "equal":
                        good = txt.startswith("identical")
                    else:
                        good = tick == int(expect.split()[1])
                    ok &= good
                    lines.append(f"  {be} vs {'logs/run_autopilot.ticks.tsv' if ref != 'auto' else 'autopilot reference'}"
                                 f" (expected {expect}): {txt}{'' if good else '  <-- FAIL'}")
            if "--coverage" in args:
                cov = {be: coverage_line(res[be][2]) for be in RUNNERS}
                same = cov["unicorn"] == cov["shim"] == cov["native"]
                ok &= same
                lines.append(f"  coverage lines {'identical' if same else 'DIFFERENT'}: {cov['unicorn']}"
                             + ("" if same else f" shim={cov['shim']} native={cov['native']}"))
    if not ns.quick:
        ok &= memory_identity(lines, 4000)
        ok &= memory_identity(lines, 60000)
    lines.append(f"# result: {'PASS' if ok else 'FAIL'}; wall {time.time() - t0:.1f} s")
    os.makedirs(RESULTS, exist_ok=True)
    with open(os.path.join(RESULTS, "corpus.txt" if not ns.quick else "corpus_quick.txt"), "w") as f:
        f.write("\n".join(lines) + "\n")
    print("\n".join(lines))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
