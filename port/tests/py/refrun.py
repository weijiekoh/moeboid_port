"""Reference run for the M4 lockstep gate: analysis/verification/harness/run.py (unchanged) on Unicorn
with refmock.py in place of mock.py (the real metrics and the original-engine semantics R1-R7).

Usage: python -I -B port/tests/py/refrun.py [run.py arguments ...]
"""
import os
import runpy
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
HARNESS = os.path.normpath(os.path.join(HERE, "..", "..", "..", "analysis", "verification", "harness"))
sys.path.insert(0, HERE)
sys.path.insert(0, HARNESS)
import refmock  # noqa: E402

sys.modules["mock"] = refmock


def main(argv):
    sys.argv = [os.path.join(HARNESS, "run.py")] + list(argv)
    runpy.run_path(os.path.join(HARNESS, "run.py"), run_name="__main__")


if __name__ == "__main__":
    main(sys.argv[1:])
