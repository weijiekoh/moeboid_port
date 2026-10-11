"""Supplementary differential test: implemented instruction forms that are not in the Moeboid.gam
listing (other members of the same opcode groups, 8/16-bit variants, other x87 forms).

Same machine states, comparison and report as test_insn_diff.py; the instructions are synthetic byte
sequences placed in an extra code page (0x00500000), one per 16 bytes. Every listed form must match
Unicorn. Forms outside the listing cannot change the game (the game never executes them); this test
keeps the implemented code honest. Writes port/tests/py/results/insn_extra.txt.

Usage: python -I -B port/tests/py/test_insn_extra.py [--states N] [--seed S]
"""
import argparse
import os
import random
import struct
import sys
import time

import capstone
import pefile
import unicorn

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import cshim  # noqa: E402
import test_insn_diff as T  # noqa: E402

CODE_LO, CODE_SIZE = 0x00500000, 0x00040000
ABS = 0x00410100                       # absolute memory operand inside the scratch region


def modrms(reg, regs=True, mems=True):
    """ModRM (+SIB, displacement) variants with the given reg field."""
    out = []
    if regs:
        out += [bytes([0xC0 | reg << 3 | r]) for r in (0, 3, 6)]
    if mems:
        out += [bytes([0x40 | reg << 3 | 3, 0x10]),                              # [ebx+0x10]
                bytes([0x84 | reg << 3, 0x8e]) + struct.pack("<i", 0x20),        # [esi+ecx*4+0x20]
                bytes([0x05 | reg << 3]) + struct.pack("<I", ABS),               # [abs32]
                bytes([0x45 | reg << 3, 0xf8])]                                  # [ebp-8]
    return out


def gen_bytes():
    seqs = []
    add = seqs.append
    for op in range(8):                                   # ALU, all encodings, 8/16/32 bit
        for f in range(4):
            for m in modrms(1):
                add(bytes([op << 3 | f]) + m)
                if f & 1:
                    add(b"\x66" + bytes([op << 3 | f]) + m)
        add(bytes([op << 3 | 4, 0x85]))
        add(bytes([op << 3 | 5]) + struct.pack("<I", 0x80000001))
        add(b"\x66" + bytes([op << 3 | 5]) + struct.pack("<H", 0x8001))
        for m in modrms(op):
            add(b"\x80" + m + b"\x7f")
            add(b"\x81" + m + struct.pack("<I", 0xffff8000))
            add(b"\x66\x81" + m + struct.pack("<H", 0x7fff))
            add(b"\x83" + m + b"\x81")
            add(b"\x66\x83" + m + b"\x01")
    for r in range(8):                                    # group 2: ROL ROR RCL RCR SHL SHR SAL SAR
        for m in modrms(r):
            for pre in (b"", b"\x66"):
                add(pre + b"\xc1" + m + bytes([random.Random(r).choice([1, 3, 7, 8, 15, 16, 17, 31])]))
                add(pre + b"\xd1" + m)
                add(pre + b"\xd3" + m)
            add(b"\xc0" + m + b"\x05")
            add(b"\xc0" + m + b"\x09")
            add(b"\xd0" + m)
            add(b"\xd2" + m)
    for r in (0, 2, 3, 4, 5, 6, 7):                       # group 3, 8/16/32 bit (/1: undocumented TEST
        for m in modrms(r):                               # alias; Unicorn raises #UD, the C CPU runs TEST)
            imm8, imm16, imm32 = (b"\x81", b"\x01\x80", b"\x01\x00\x00\x80") if r < 2 else (b"", b"", b"")
            add(b"\xf6" + m + imm8)
            add(b"\x66\xf7" + m + imm16)
            add(b"\xf7" + m + imm32)
    for m in modrms(0) + modrms(1):                       # INC/DEC r/m 8/16/32
        add(b"\xfe" + m)
        add(b"\x66\xff" + m)
        add(b"\xff" + m)
    for m in modrms(6, regs=False):                       # PUSH m32, POP m32
        add(b"\xff" + m)
        add(b"\x8f" + bytes([m[0] & ~0x38]) + m[1:])
    add(b"\x8f\x44\x24\x08")                              # POP [esp+8] (address after the increment)
    add(b"\xff\x74\x24\x04")                              # PUSH [esp+4]
    for r in range(8):
        add(b"\x66" + bytes([0x40 | r]))
        add(b"\x66" + bytes([0x48 | r]))
        add(b"\x66" + bytes([0x50 | r]))
        add(b"\x66" + bytes([0x58 | r]))
        add(bytes([0x90 | r]))
        add(b"\x66" + bytes([0x90 | r]))
        add(bytes([0xb0 | r, 0x9c]))
        add(b"\x66" + bytes([0xb8 | r]) + b"\x34\x12")
    add(b"\x60")
    add(b"\x61")
    add(b"\x66\x68\x34\x12")
    add(b"\x6a\x80")
    for m in modrms(2):                                   # IMUL 2/3 operands, 16/32
        add(b"\x0f\xaf" + m)
        add(b"\x66\x0f\xaf" + m)
        add(b"\x69" + m + struct.pack("<I", 0x12345))
        add(b"\x66\x69" + m + struct.pack("<H", 0x8123))
        add(b"\x6b" + m + b"\x85")
        add(b"\x66\x6b" + m + b"\x7f")
    for op2 in (0xa3, 0xab, 0xb3, 0xbb):                  # BT BTS BTR BTC
        for m in modrms(1):
            add(b"\x0f" + bytes([op2]) + m)
            add(b"\x66\x0f" + bytes([op2]) + m)
    for r in (4, 5, 6, 7):
        for m in modrms(r):
            add(b"\x0f\xba" + m + b"\x25")
            add(b"\x66\x0f\xba" + m + b"\x13")
    for op2 in (0xb6, 0xb7, 0xbe, 0xbf):                  # MOVZX MOVSX, 16/32 bit destinations
        for m in modrms(2):
            add(b"\x0f" + bytes([op2]) + m)
            add(b"\x66\x0f" + bytes([op2]) + m)
    for cc in range(16):                                  # SETcc, Jcc rel8 and rel32
        add(b"\x0f" + bytes([0x90 | cc]) + b"\xc1")
        add(b"\x0f" + bytes([0x90 | cc]) + b"\x43\x10")
        add(bytes([0x70 | cc, 0x40]))
        add(b"\x0f" + bytes([0x80 | cc]) + struct.pack("<i", -0x80))
    for b in (b"\x98", b"\x66\x98", b"\x99", b"\x66\x99", b"\x9e", b"\x9f", b"\xf5", b"\xf8", b"\xf9", b"\xfc",
              b"\xfd", b"\x90", b"\xc9", b"\x66\xc9", b"\xc3", b"\xc2\x08\x00", b"\xe8\x00\x01\x00\x00",
              b"\xe9\x00\xff\xff\xff", b"\xeb\x20"):
        add(b)
    for op in (0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b):       # XCHG, MOV, 8/16/32
        for m in modrms(3):
            add(bytes([op]) + m)
            if op & 1:
                add(b"\x66" + bytes([op]) + m)
    for m in modrms(5, regs=False):
        add(b"\x8d" + m)
        add(b"\x66\x8d" + m)
    for m in modrms(0):
        add(b"\xc6" + m + b"\xa5")
        add(b"\xc7" + m + struct.pack("<I", 0xdeadbeef))
        add(b"\x66\xc7" + m + struct.pack("<H", 0xbeef))
    for op in (0xa0, 0xa1, 0xa2, 0xa3):
        add(bytes([op]) + struct.pack("<I", ABS))
        add(b"\x66" + bytes([op]) + struct.pack("<I", ABS))
    add(b"\x64\xa1\x00\x00\x00\x00")
    for op in (0xa4, 0xa5, 0xa6, 0xa7, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf):   # string forms
        for pre in (b"", b"\xf3", b"\xf2"):
            if pre == b"\xf2" and op in (0xa4, 0xa5, 0xaa, 0xab, 0xac, 0xad):
                continue
            add(pre + bytes([op]))
            if op & 1:
                add(b"\x66" + pre + bytes([op]))
    # x87 memory forms
    x87mem = [(0xd8, r) for r in range(8)] + [(0xda, r) for r in range(8)] + [(0xdc, r) for r in range(8)] + \
             [(0xde, r) for r in range(8)] + [(0xd9, r) for r in (0, 2, 3, 5, 7)] + \
             [(0xdb, r) for r in (0, 2, 3, 5, 7)] + [(0xdd, r) for r in (0, 2, 3, 7)] + \
             [(0xdf, r) for r in (0, 2, 3, 5, 7)]
    for op, r in x87mem:
        for m in modrms(r, regs=False):
            add(bytes([op]) + m)
    # x87 register forms
    for r in range(8):
        for i in (0, 1, 3, 7):
            add(bytes([0xd8, 0xc0 | r << 3 | i]))
            if r not in (2, 3):                           # DC D0..DF: undocumented FCOM aliases
                add(bytes([0xdc, 0xc0 | r << 3 | i]))
            if r not in (2, 3):
                add(bytes([0xde, 0xc0 | r << 3 | i]))
    for i in (0, 1, 2, 7):
        add(bytes([0xd9, 0xc0 | i]))                      # FLD ST(i)
        add(bytes([0xd9, 0xc8 | i]))                      # FXCH
        add(bytes([0xdd, 0xc0 | i]))                      # FFREE
        add(bytes([0xdd, 0xd0 | i]))                      # FST ST(i)
        add(bytes([0xdd, 0xd8 | i]))                      # FSTP ST(i)
        add(bytes([0xdd, 0xe0 | i]))                      # FUCOM
        add(bytes([0xdd, 0xe8 | i]))                      # FUCOMP
    for b in (b"\xd9\xd0", b"\xd9\xe0", b"\xd9\xe1", b"\xd9\xe4", b"\xd9\xe8", b"\xd9\xee", b"\xd9\xf6",
              b"\xd9\xf7", b"\xd9\xfa", b"\xd9\xfc", b"\xde\xd9", b"\xda\xe9", b"\xdb\xe2", b"\xdb\xe3",
              b"\xdf\xe0", b"\x9b"):
        add(b)
    return seqs


class ExtraGen(T.Gen):
    def state(self, ins):
        st = super().state(ins)
        if ins.x87 and ins.mn in ("fld", "fstp") and any(m["size"] == 10 for m in ins.mems):
            r = self.r
            patches = []
            for a, data in st["patches"]:
                v = self.fpval()
                mant, se = T.f80_of_double(v if v == v else 1.0)
                if mant:
                    mant |= r.getrandbits(11)            # not a double: exercises the exact 80-bit value
                patches.append((a, struct.pack("<QH", mant, se) + data[10:]))
            st["patches"] = patches
        return st


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--states", type=int, default=20)
    ap.add_argument("--seed", type=int, default=3)
    ap.add_argument("--max-report", type=int, default=40)
    ns = ap.parse_args()
    t0 = time.time()
    pe = pefile.PE(T.GAM)
    size = (pe.OPTIONAL_HEADER.SizeOfImage + 0xfff) & ~0xfff
    image = bytearray(pe.get_memory_mapped_image()[:size])
    image += b"\0" * (size - len(image))
    rng0 = random.Random(ns.seed)
    rnd_stack = bytes(rng0.getrandbits(8) for _ in range(T.STACK_SIZE))
    rnd_scr = bytes(rng0.getrandbits(8) for _ in range(T.SCR_SIZE))
    base_mem = {T.STACK_LO: rnd_stack, T.SCR_LO: rnd_scr, T.BASE: bytes(image)}
    seqs = gen_bytes()
    code = bytearray(b"\x90" * CODE_SIZE)
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    insns = []
    for k, b in enumerate(seqs):
        a = CODE_LO + 0x1000 + 16 * k
        code[a - CODE_LO:a - CODE_LO + len(b)] = b
        ci = next(md.disasm(bytes(b) + b"\x90" * 8, a), None)
        if ci is None or ci.size != len(b):
            raise SystemExit(f"capstone cannot decode {b.hex()} as one instruction")
        insns.append(T.Insn(ci))
    U = T.Machine(unicorn, image, rnd_stack, rnd_scr)
    C = T.Machine(cshim, image, rnd_stack, rnd_scr)
    for m in (U, C):
        m.uc.mem_map(CODE_LO, CODE_SIZE)
        m.uc.mem_write(CODE_LO, bytes(code))
    len_bad = [i for i in insns if C.uc.insn_len(i.addr) != i.size]
    targets = [CODE_LO + 0x1000 + 16 * k for k in range(len(seqs))]
    gen_cls, T.Gen = T.Gen, ExtraGen
    try:
        per_form, reports, n_states, n_mism = T.diff_run(U, C, insns, ns.states, ns.seed, targets, T.load_fsin(),
                                                          ns.max_report, base_mem)
    finally:
        T.Gen = gen_cls
    lines = [f"# test_insn_extra.py: implemented forms outside the listing, C interpreter vs Unicorn {unicorn.__version__}",
             f"# instructions={len(insns)} forms={len(per_form)} states_per_instruction={ns.states} seed={ns.seed} "
             f"states={n_states}",
             f"# instruction length (C decoder vs capstone) mismatches: {len(len_bad)}"
             + (" " + " ".join(i.bytes.hex() for i in len_bad[:20]) if len_bad else ""),
             f"# mismatching states: {n_mism}",
             f"# DIV/IDIV Unicorn #DE reporting quirk states: {sum(p['de_quirk'] for p in per_form.values())}",
             f"# wall time {time.time() - t0:.1f} s",
             "form\tinstructions\tstates\terror_states\tmismatches"]
    for f, p in per_form.items():
        lines.append(f"{f}\t{p['addrs']}\t{p['states']}\t{p['errors']}\t{p['mism']}")
    if reports:
        lines.append("# first mismatches:")
        lines += reports
    os.makedirs(T.RESULTS, exist_ok=True)
    with open(os.path.join(T.RESULTS, "insn_extra.txt"), "w") as f:
        f.write("\n".join(lines) + "\n")
    print("\n".join(lines[:6]))
    if reports:
        print("\n".join(reports[:12]))
    return 0 if n_mism == 0 and not len_bad else 1


if __name__ == "__main__":
    sys.exit(main())
