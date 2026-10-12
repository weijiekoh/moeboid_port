"""Run the original spawn-position bytes of Moeboid.gam (0x10001252..0x1000127c) inside Unicorn for
all 179000 reachable (k, r) pairs and compare with host x87 results from fsin_check.c.

Modes:
  raw    Unicorn executes FSIN/FCOS itself (QEMU helper: host libm sin()/cos() on a double).
  table  harness hook replaces FSIN/FCOS (0x1000125d, 0x1000126e) with 80-bit values measured on
         the host x87 (x87_fsin_table.tsv). Same mechanism as emu.Machine.install_fsin_table().
Compared: x (float32 at [ESI+0xc]), y (float32 at [ESI+0x10]), y53 (unrounded y left in ST0 and used
by the distance check at 0x10001285..0x100012a9).

Usage: python -I -B unicorn_fsin.py X87_SPAWN.bin [mode ...]
  X87_SPAWN.bin: output 1 of `fsin_check DUMP TABLE`.
"""
import math
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "harness"))
import emu  # noqa: E402
from unicorn.x86_const import UC_X86_REG_EBP, UC_X86_REG_ESI, UC_X86_REG_FPSW, UC_X86_REG_FP0, \
    UC_X86_REG_FPCW  # noqa: E402

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", ".."))
GAM = os.path.join(ROOT, "extracted", "Moeboid.gam")
START, END = 0x10001252, 0x1000127c


def f80_to_float(m, e):
    sign = -1.0 if e & 0x8000 else 1.0
    if m == 0:
        return 0.0 * sign
    return sign * math.ldexp(m, (e & 0x7fff) - 16383 - 63)  # exact when the value has <= 53 bits


def run(mode, ref):
    m = emu.Machine(GAM)
    if mode == "table":
        m.install_fsin_table()
    uc = m.uc
    frame = emu.STACK_LO + 0x8000            # EBP
    obj = emu.HEAP_LO + 0x100                # ESI
    pop = m.alloc_data(b"\xdd\xd8")          # FSTP ST0: empty the x87 stack after each run
    mism = {"x32": 0, "y32": 0, "y53": 0}
    first = []
    i = 0
    for k in range(1000):
        for r in range(179):
            uc.reg_write(UC_X86_REG_FPCW, 0x27f)
            uc.mem_write(frame - 0x18, struct.pack("<Q", k))
            uc.mem_write(frame + 8, struct.pack("<f", float(r)))
            uc.reg_write(UC_X86_REG_EBP, frame)
            uc.reg_write(UC_X86_REG_ESI, obj)
            uc.emu_start(START, END)
            if m.error:
                raise SystemExit(m.error)
            top = (uc.reg_read(UC_X86_REG_FPSW) >> 11) & 7
            y53 = f80_to_float(*uc.reg_read(UC_X86_REG_FP0 + top))
            uc.emu_start(pop, pop + 2)
            x32b = bytes(uc.mem_read(obj + 0xc, 4))
            y32b = bytes(uc.mem_read(obj + 0x10, 4))
            rx, ry, ry53 = struct.unpack_from("<ffd", ref, 16 * i)
            if x32b != struct.pack("<f", rx):
                mism["x32"] += 1
            if y32b != struct.pack("<f", ry):
                mism["y32"] += 1
            if struct.pack("<d", y53) != struct.pack("<d", ry53):
                mism["y53"] += 1
                if len(first) < 2:
                    first.append(f"k={k} r={r} unicorn={y53.hex()} x87={ry53.hex()}")
            i += 1
    return i, mism, first


def main():
    ref = open(sys.argv[1], "rb").read()
    modes = sys.argv[2:] or ["raw", "table"]
    for mode in modes:
        n, mism, first = run(mode, ref)
        print(f"unicorn mode={mode} pairs={n} mismatches x32={mism['x32']} y32={mism['y32']} "
              f"y53={mism['y53']}" + ("; e.g. " + "; ".join(first) if first else ""))


if __name__ == "__main__":
    main()
