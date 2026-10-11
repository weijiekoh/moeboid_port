"""FSIN/FCOS path D on the C interpreter (contract section 5, verification.md 3.1).

Runs the original spawn-position bytes of Moeboid.gam (G:0x10001252..0x1000127c) for all 179000
reachable (k, r) pairs on the C CPU and compares x (float32), y (float32) and the unrounded y left in
ST0 (53 bit) with the host x87 results of analysis/verification/fpu/fsin_check.c. Two modes:
  native  the C CPU executes FSIN/FCOS itself (x87 table, exact 80-bit value, FMUL rounded once);
  hook    emu.Machine.install_fsin_table() (harness code hook, FSTP ST0; FLD tword; JMP stub).
The reference dump is produced by compiling and running fsin_check.c (own test code, not an
original binary) on this host; the x87 table was measured on the same host type (i7-13700HX).
Expected: 0 mismatches in both modes. Writes port/tests/py/results/fsin_path.txt.

Usage: python -I -B port/tests/py/test_fsin_path.py
"""
import os
import subprocess
import sys
import tempfile
import time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, "..", "..", ".."))
FPU = os.path.join(ROOT, "analysis", "verification", "fpu")
RESULTS = os.path.join(HERE, "results")
sys.path.insert(0, HERE)
import cshim  # noqa: E402

cshim.install()
sys.path.insert(0, FPU)
sys.path.insert(0, os.path.join(ROOT, "analysis", "verification", "harness"))
import unicorn_fsin  # noqa: E402  (imports emu, which now uses the shim)


def main():
    t0 = time.time()
    with tempfile.TemporaryDirectory() as tmp:
        exe = os.path.join(tmp, "fsin_check")
        subprocess.run(["gcc", "-O0", "-o", exe, os.path.join(FPU, "fsin_check.c"), "-lm"], check=True)
        dump = os.path.join(tmp, "x87_spawn.bin")
        out = subprocess.run([exe, dump], check=True, capture_output=True, text=True).stdout
        ref = open(dump, "rb").read()
    lines = ["# test_fsin_path.py: spawn code G:0x10001252..0x1000127c on the C CPU vs host x87 (fsin_check.c)",
             "# fsin_check.c on this host: " + " | ".join(ln for ln in out.splitlines() if ln.startswith(("B ", "C ", "D ")))]
    ok = True
    for mode, label in (("raw", "native (C CPU FSIN/FCOS table)"), ("table", "hook (emu.install_fsin_table)")):
        n, mism, first = unicorn_fsin.run(mode, ref)
        bad = sum(mism.values())
        ok &= bad == 0 and n == 179000
        lines.append(f"{label}: pairs={n} mismatches x32={mism['x32']} y32={mism['y32']} y53={mism['y53']}"
                     + (" e.g. " + "; ".join(first) if first else ""))
    lines.append(f"# result: {'PASS' if ok else 'FAIL'} wall {time.time() - t0:.1f} s")
    os.makedirs(RESULTS, exist_ok=True)
    with open(os.path.join(RESULTS, "fsin_path.txt"), "w") as f:
        f.write("\n".join(lines) + "\n")
    print("\n".join(lines))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
