"""Run analysis/verification/harness/run.py with the C machine layer (cmachine.CMachine): C PE loader,
KERNEL32 stubs (k32.c), engine thunks through engine_dispatch, cpu_call. The engine is the Python mock.

Usage: python -I -B port/tests/py/run_native.py [run.py arguments ...]
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
import emu  # noqa: E402
import cmachine  # noqa: E402

emu.Machine_python = emu.Machine
emu.Machine = cmachine.make_class(emu)


def main(argv):
    sys.argv = [os.path.join(HARNESS, "run.py")] + list(argv)
    runpy.run_path(os.path.join(HARNESS, "run.py"), run_name="__main__")


if __name__ == "__main__":
    main(sys.argv[1:])
