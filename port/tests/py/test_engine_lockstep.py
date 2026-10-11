"""Gate test of M4: lockstep of the port engine against the reference.

(a) reference: analysis/verification/harness/run.py on Unicorn with refmock.py (copy of mock.py with
    the real metrics of the port and the original-engine semantics R1-R7, see refmock.py);
(b) native port: the C interpreter and the C engine (objects of the native build without the shell,
    enginedrv.engine_only_lib), inputs through the
    real input path (enginedrv.NativeEngine: key messages, mouse move/down/up on the button found by
    the hit test, applet event 0x10, InputBox answers);
(c) wasm port: the trace-build objects without the shell (enginedrv.engine_only_wasm, the browser
    build's engine with the trace exports) in node, same inputs (wasm_replay.mjs); rows must equal (b).
The shell (M5) is left out: its splash starts the game later and blocks input; the engine alone (weak
shell_api.h defaults) starts the game at step 0, as the reference harness.
Both write one row per engine-to-game call (tick, clock ms, calls, SHA-256 of the canonical call
lines, SHA-256 of the game state digest). Recordings: analysis/verification/logs/run_autopilot.input.tsv
(60 s) and run_tour.input.tsv (120 s) at the 1 ms clock step; also the autopilot recording at the
15.625 and 54.925 ms steps and the tour with engine seed 999 (reference and port run the same
inputs; the game reacts differently, both sides must agree). Every row must be equal.
Also reported (information): the first tick where refmock differs from the original mock.py logs.
Writes port/tests/py/results/engine_lockstep.txt. Exit status 0 when both recordings are identical.

Usage: python -I -B port/tests/py/test_engine_lockstep.py
"""
import os
import re
import subprocess
import sys
import tempfile
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import enginedrv  # noqa: E402

ROOT = enginedrv.ROOT
LOGS = os.path.join(ROOT, "analysis", "verification", "logs")
RESULTS = os.path.join(HERE, "results")
AUTO = os.path.join(LOGS, "run_autopilot.input.tsv")
TOUR = os.path.join(LOGS, "run_tour.input.tsv")
# name, recording, ms, clock step index (clock.h) and run.py --clock-step, engine seed, wasm check
CASES = [("autopilot", AUTO, 60000, 0, "1.0", 12345, True),
         ("tour", TOUR, 120000, 0, "1.0", 12345, True),
         ("autopilot, clock step 15.625 ms", AUTO, 60000, 1, "15.625", 12345, False),
         ("autopilot, clock step 54.925 ms", AUTO, 60000, 2, "54.925", 12345, False),
         ("tour, engine seed 999", TOUR, 120000, 0, "1.0", 999, False)]


def read_rows(path):
    rows = [ln.rstrip("\n").split("\t") for ln in open(path)][1:]
    return [(int(r[0]), int(r[1]), int(r[2]), r[3], r[4] if len(r) > 4 else "-") for r in rows]


def settings_of(rec):
    out = {}
    for ln in open(rec):
        if ln.startswith("# setting\t"):
            _, k, v = ln.rstrip("\n").split("\t")
            out[k] = v
    return out


def tick_lines(lines, t):
    out, on = [], False
    for ln in lines:
        if ln.startswith("T"):
            on = ln.startswith(f"T{t} ")
            if on:
                out.append(ln)
        elif on and re.match(r"  [0-9a-f]{8} ", ln):
            out.append(ln)
    return out


def compare(a, b, end_ms=None):
    """First differing tick. end_ms: the last row (Shell_StopApplet) may have that ms on one side:
    run.py stops at the raw end time, the port at the last GetTickCount value <= the end time
    (differs only when the clock step is not 1 ms)."""
    for i, (x, y) in enumerate(zip(a, b)):
        if x != y:
            if end_ms is not None and i == len(a) - 1 == len(b) - 1 and x[0] == y[0] and x[2:] == y[2:] \
                    and end_ms in (x[1], y[1]) and abs(x[1] - y[1]) < 60:
                continue
            return x[0]
    return None if len(a) == len(b) else min(len(a), len(b)) + 1


def main():
    os.makedirs(RESULTS, exist_ok=True)
    out = []
    ok = True
    with tempfile.TemporaryDirectory(prefix="m4lock") as tmp:
        for n, (name, rec, ms, clock, step, seed, wasm_check) in enumerate(CASES):
            t0 = time.time()
            ref = os.path.join(tmp, f"ref_{n}")
            p = subprocess.run([sys.executable, "-I", "-B", os.path.join(HERE, "refrun.py"), "--replay", rec, "--ms",
                                str(ms), "--out", ref, "--full-ticks", "1000000", "--clock-step", step, "--seed",
                                str(seed)], capture_output=True, text=True, cwd=ROOT)
            status = p.stdout.strip().splitlines()[0] if p.stdout.strip() else "ERROR " + p.stderr[-400:]
            t_ref = time.time() - t0
            if not os.path.exists(ref + ".ticks.tsv"):
                out.append(f"{name}: reference failed: {status}")
                ok = False
                continue
            rrows = read_rows(ref + ".ticks.tsv")
            t0 = time.time()
            e = enginedrv.NativeEngine(settings=settings_of(rec), trace=2, clock_index=clock, seed=seed)
            e.replay(rec, ms)
            t_nat = time.time() - t0
            nrows = e.rows
            d = compare(rrows, nrows, end_ms=ms if clock else None)
            res = "identical" if d is None else f"DIVERGES at tick {d}"
            out.append(f"{name} ({ms} ms): reference run.py+refmock {status}, {len(rrows)} ticks ({t_ref:.1f} s); "
                       f"native port {len(nrows)} ticks ({t_nat:.1f} s), fault '{e.fault}'; per-tick call hashes, "
                       f"call counts, clock ms and state digests: {res}")
            calls = sum(r[2] for r in nrows)
            states = sum(1 for r in nrows if r[4] != "-")
            out.append(f"  calls compared {calls}, ticks with a game-state digest {states}, engine log lines "
                       f"{len(e.log)}")
            if d is not None:
                ok = False
                rl = tick_lines(open(ref + ".log").read().split("\n"), d)
                nl = tick_lines(e.full, d)
                for i in range(max(len(rl), len(nl))):
                    x = rl[i] if i < len(rl) else ""
                    y = nl[i] if i < len(nl) else ""
                    if x != y:
                        out.append(f"  ref:    {x}")
                        out.append(f"  native: {y}")
                        break
            wasm = enginedrv.engine_only_wasm()
            if not wasm_check:
                continue
            t0 = time.time()
            q = subprocess.run(["node", os.path.join(HERE, "wasm_replay.mjs"), wasm, enginedrv.PACK, enginedrv.GAM, rec,
                                str(ms)], capture_output=True, text=True, cwd=ROOT)
            wrows = [tuple(int(x) if i < 3 else x for i, x in enumerate(ln.split("\t")))
                     for ln in q.stdout.splitlines() if ln[:1].isdigit()]
            wd = compare(nrows, wrows)
            if q.returncode != 0 or wd is not None:
                ok = False
            out.append(f"  wasm (engine trace build in node {time.time() - t0:.1f} s): {len(wrows)} ticks, rows "
                       + ("identical to the native port" if wd is None and q.returncode == 0
                          else f"DIFFER at tick {wd} (exit {q.returncode}) {q.stderr[-300:]}"))
            orig = os.path.join(LOGS, f"run_{name}.ticks.tsv")
            if os.path.exists(orig) and clock == 0 and seed == 12345:
                od = compare(read_rows(orig), rrows)
                out.append(f"  information: refmock vs the original mock.py log ({os.path.basename(orig)}): "
                           + ("identical" if od is None else f"first difference at tick {od} (R1-R7 of refmock.py)"))
    out.append("# result: " + ("PASS" if ok else "FAIL"))
    text = "\n".join(out) + "\n"
    open(os.path.join(RESULTS, "engine_lockstep.txt"), "w").write(text)
    sys.stdout.write(text)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
