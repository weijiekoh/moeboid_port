"""Run analysis/verification/harness/run.py unchanged on the C interpreter (Unicorn shim).

Usage: python -I -B port/tests/py/run_c.py [run.py arguments ...]
  Same arguments and outputs as run.py (--out PREFIX writes PREFIX.log, .ticks.tsv, .input.tsv).
  Environment: MOEBOID_LIB = path of libmoeboid.so (default port/build/libmoeboid.so).
"""
import os
import runpy
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
HARNESS = os.path.normpath(os.path.join(HERE, "..", "..", "..", "analysis", "verification", "harness"))

sys.path.insert(0, HERE)
import cshim  # noqa: E402

cshim.install()
sys.path.insert(0, HARNESS)


def main(argv):
    sys.argv = [os.path.join(HARNESS, "run.py")] + list(argv)
    runpy.run_path(os.path.join(HARNESS, "run.py"), run_name="__main__")


if __name__ == "__main__":
    main(sys.argv[1:])
