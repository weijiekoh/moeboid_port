"""Determinism and fidelity checks of the harness. Runs run.py variants and compares the per-tick
call-log hashes and game-state digests (PREFIX.ticks.tsv) with the reference run.

Usage: python -I -B checks.py SCRATCH_DIR [--ms N]
Writes ../logs/run_autopilot.{log,ticks.tsv,input.tsv} (reference), ../logs/run_tour.{log,input.tsv}
(coverage tour) and ../logs/checks.log.
"""
import os
import shutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
LOGS = os.path.join(HERE, "..", "logs")


def run(out, *args):
    cmd = [sys.executable, "-I", "-B", os.path.join(HERE, "run.py"), "--out", out, *args]
    p = subprocess.run(cmd, capture_output=True, text=True)
    return p.stdout.strip().splitlines()[0] if p.stdout else p.stderr.strip()[-300:]


def hashes(prefix):
    rows = [ln.rstrip("\n").split("\t") for ln in open(prefix + ".ticks.tsv")][1:]
    return [(int(r[0]), int(r[1]), r[3], r[4] if len(r) > 4 else "") for r in rows]


def compare(a, b):
    for x, y in zip(a, b):
        if x != y:
            return f"DIVERGES at tick {x[0]} (ms {x[1]} vs {y[1]})"
    if len(a) != len(b):
        return f"DIVERGES: tick count {len(a)} vs {len(b)}"
    return f"identical ({len(a)} ticks)"


def main():
    scratch = sys.argv[1]
    ms = sys.argv[sys.argv.index("--ms") + 1] if "--ms" in sys.argv else "60000"
    os.makedirs(LOGS, exist_ok=True)
    ref = os.path.join(LOGS, "run_autopilot")
    lines = [f"reference: run.py --script autopilot --ms {ms} --full-ticks 60: "
             + run(ref, "--script", "autopilot", "--ms", ms, "--full-ticks", "60")]
    h0 = hashes(ref)
    rec = ref + ".input.tsv"
    variants = [
        ("repeat (same command again)", ["--script", "autopilot"]),
        ("replay of the input recording", ["--replay", rec]),
        ("replay, scribble 0x00 (stack below ESP and new heap blocks)", ["--replay", rec, "--scribble", "0x00"]),
        ("replay, scribble 0xa5", ["--replay", rec, "--scribble", "0xa5"]),
        ("replay, scribble 0x5a", ["--replay", rec, "--scribble", "0x5a"]),
        ("replay, initial stack/heap fill 0xcc", ["--replay", rec, "--fill", "0xcc"]),
        ("replay, image relocated to 0x20000000", ["--replay", rec, "--base", "0x20000000"]),
        ("replay, Unicorn FSIN/FCOS (no x87 table)", ["--replay", rec, "--no-fsin-table"]),
        ("replay, engine RNG seed 999 (must diverge)", ["--replay", rec, "--seed", "999"]),
        ("replay, GetTickCount step 15.625 ms (timing model; must diverge)", ["--replay", rec, "--clock-step", "15.625"]),
    ]
    for i, (name, args) in enumerate(variants):
        out = os.path.join(scratch, f"check{i}")
        status = run(out, "--ms", ms, "--full-ticks", "0", *args)
        lines.append(f"{name}: run {status}; per-tick call hashes and state digests {compare(h0, hashes(out))}")
    # coverage tour: help, CREDITS screen, No button, INVINCIBLE cheat (log and recording in ../logs)
    tour = os.path.join(LOGS, "run_tour")
    lines.append("tour: run.py --script tour --ms 120000 --coverage: "
                 + run(tour, "--script", "tour", "--ms", "120000", "--full-ticks", "0", "--coverage"))
    lines += [ln.rstrip("\n") for ln in open(tour + ".log") if ln.startswith(("# coverage", "# functions not"))]
    out = os.path.join(scratch, "check_tour_replay")
    status = run(out, "--ms", "120000", "--full-ticks", "0", "--replay", tour + ".input.tsv")
    lines.append(f"tour replay: run {status}; per-tick call hashes and state digests "
                 f"{compare(hashes(tour), hashes(out))}")
    shutil.move(tour + ".ticks.tsv", os.path.join(scratch, "run_tour.ticks.tsv"))   # 250 KB: keep out of logs
    text = "\n".join(lines) + "\n"
    open(os.path.join(LOGS, "checks.log"), "w").write(text)
    sys.stdout.write(text)


if __name__ == "__main__":
    main()
