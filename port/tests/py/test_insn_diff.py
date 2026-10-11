"""Gate test A of M2: per-instruction differential test of the C interpreter against Unicorn.

Instruction set: every instruction address of the Moeboid.gam .text (Ghidra listing
analysis/decomp/Moeboid.gam/listing.asm, 15674 addresses) plus the 3 FNSTCW/FNSTSW that follow a
WAIT which Ghidra merges into one listing line (capstone and both CPUs execute WAIT separately).
Forms: capstone mnemonic + operand kinds and sizes + segment + prefixes + opcode bytes.

For every address and every state (default 10 per address) both CPUs get the same random machine
state, execute exactly one instruction (REP string forms: until the next address), and the test
compares EAX..EDI, EIP, EFLAGS (CF PF AF ZF SF DF OF), the x87 state (all 8 physical registers as
80-bit values, FPSW incl. TOP, FPCW, tag word), all bytes written by either CPU, and the error
(#DE, unmapped access). Expected and excluded differences:
  - FSIN/FCOS: the reference is the x87 table (Unicorn uses libm sin on a double): Unicorn's ST0 is
    replaced by the table value and C2 by 0 before the comparison (contract section 5).
  - State generation stays in the domain where the double register model is exact (decisions in
    cpu_x87.c): no precision control 64 bit, rounding control nearest for x87 arithmetic (all four
    modes for FST/FIST/FISTP), no NaN/infinity inputs (they appear as results), FILD m64 inputs up to
    2^62, values below 1e150 in magnitude.
  - A control transfer to an unmapped target (jump tables that Ghidra lists inside code, e.g.
    G:0x100085d4): Unicorn executes the jump and then reports the fetch fault of the next
    instruction; the C CPU stops after one instruction. Equal EIP and state count as a match.
  - Unicorn quirk: after a DIV/IDIV at one address completed once, a later #DE at the same address
    leaves EIP and all registers unchanged but emu_start reports no error. The test counts a
    DIV/IDIV step whose EIP did not advance as #DE (verified with a 3-line probe: fresh instance
    reports UC_ERR_EXCEPTION; after a successful DIV at that address it reports UC_ERR_OK).
Undefined flags are not masked: the C CPU produces Unicorn's values (cpu_exec.c header).

Memory: image at 0x10000000 (file content, no relocation), GDT/TEB as emu.py (FS), stack
0x00100000 (1 MiB, random content), scratch 0x00400000 (1 MiB, random content). Registers used as
address bases point into the scratch or stack region; control-transfer targets read from memory or
registers are instruction addresses of the listing.

Usage: python -I -B port/tests/py/test_insn_diff.py [--states N] [--seed S] [--only ADDR,...]
       [--forms SUBSTR] [--out DIR]
Writes DIR/insn_diff.txt (default port/tests/py/results/). Exit status 0 if 0 unexplained mismatches.
"""
import argparse
import collections
import os
import random
import re
import struct
import sys
import time

import capstone
import pefile
import unicorn
from capstone import x86_const as CX
from unicorn import x86_const as UX

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import cshim  # noqa: E402

ROOT = os.path.normpath(os.path.join(HERE, "..", "..", ".."))
GAM = os.path.join(ROOT, "extracted", "Moeboid.gam")
LISTING = os.path.join(ROOT, "analysis", "decomp", "Moeboid.gam", "listing.asm")
FSIN_TABLE = os.path.join(ROOT, "analysis", "verification", "fpu", "x87_fsin_table.tsv")
RESULTS = os.path.join(HERE, "results")

BASE = 0x10000000
GDT, TEB = 0x00010000, 0x00020000
STACK_LO, STACK_SIZE = 0x00100000, 0x00100000
SCR_LO, SCR_SIZE = 0x00400000, 0x00100000
FLAGS_MASK = 0xCD5          # CF PF AF ZF SF DF OF
GPR = [UX.UC_X86_REG_EAX, UX.UC_X86_REG_ECX, UX.UC_X86_REG_EDX, UX.UC_X86_REG_EBX,
       UX.UC_X86_REG_ESP, UX.UC_X86_REG_EBP, UX.UC_X86_REG_ESI, UX.UC_X86_REG_EDI]
GPR_NAMES = ["eax", "ecx", "edx", "ebx", "esp", "ebp", "esi", "edi"]
CS_REG = {CX.X86_REG_EAX: 0, CX.X86_REG_ECX: 1, CX.X86_REG_EDX: 2, CX.X86_REG_EBX: 3,
          CX.X86_REG_ESP: 4, CX.X86_REG_EBP: 5, CX.X86_REG_ESI: 6, CX.X86_REG_EDI: 7}
FP0 = UX.UC_X86_REG_FP0

CTI = {"call", "jmp", "ret", "ja", "jae", "jb", "jbe", "je", "jg", "jge", "jl", "jle", "jne", "jns", "jo",
       "jno", "js", "jp", "jnp"}
X87_ARITH = {"fadd", "faddp", "fsub", "fsubr", "fmul", "fdiv", "fsqrt", "fisub", "fsubp", "fsubrp",
             "fmulp", "fdivp", "fdivr", "fdivrp", "fiadd", "fimul", "fidiv", "fidivr", "fisubr"}
X87_ROUNDING = {"fst", "fstp", "fistp", "fist", "frndint"}


def gdt_entry(base, limit, access, flags):
    v = limit & 0xffff
    v |= (base & 0xffffff) << 16
    v |= (access & 0xff) << 40
    v |= ((limit >> 16) & 0xf) << 48
    v |= (flags & 0xf) << 52
    v |= ((base >> 24) & 0xff) << 56
    return struct.pack("<Q", v)


def f80_of_double(d):
    """(mantissa, sign_exponent) of a double, exact."""
    b = struct.unpack("<Q", struct.pack("<d", d))[0]
    s = (b >> 63) << 15
    e = (b >> 52) & 0x7ff
    f = b & ((1 << 52) - 1)
    if e == 0x7ff:
        return ((0xC000000000000000 | (f << 11)) if f else 0x8000000000000000, s | 0x7fff)
    if e == 0:
        if f == 0:
            return (0, s)
        p = f.bit_length() - 1
        return (f << (63 - p), s | (15309 + p))
    return (0x8000000000000000 | (f << 11), s | (e - 1023 + 16383))


def load_listing():
    addrs = []
    for line in open(LISTING):
        m = re.match(r"^  ([0-9a-f]{8})  (\S+)", line)
        if m:
            addrs.append(int(m.group(1), 16))
    return addrs


def load_fsin():
    tbl = {}
    for i, line in enumerate(open(FSIN_TABLE)):
        if i == 0:
            continue
        f = line.split()
        vals = []
        for col in f[1:4]:
            e, m = col.split(":")
            vals.append((int(m, 16), int(e, 16)))
        tbl[vals[0]] = (vals[1], vals[2])
    return tbl


class Insn:
    """Decoded instruction with the facts the state generator needs."""

    def __init__(self, ci):
        self.addr, self.size, self.mn = ci.address, ci.size, ci.mnemonic
        self.bytes = bytes(ci.bytes)
        self.text = f"{ci.mnemonic} {ci.op_str}".strip()
        self.mems = []
        kinds = []
        for o in ci.operands:
            if o.type == CX.X86_OP_REG:
                n = ci.reg_name(o.reg)
                kinds.append("st" if n.startswith("st") else f"r{o.size * 8}")
            elif o.type == CX.X86_OP_IMM:
                kinds.append(f"i{o.size * 8}")
            else:
                seg = ci.reg_name(o.mem.segment) if o.mem.segment else None
                kinds.append((seg + ":" if seg else "") + f"m{o.size * 8}")
                self.mems.append(dict(base=CS_REG.get(o.mem.base), index=CS_REG.get(o.mem.index),
                                      scale=o.mem.scale, disp=o.mem.disp & 0xffffffff, seg=seg, size=o.size,
                                      has_base=o.mem.base != 0, has_index=o.mem.index != 0))
        self.ops = [o for o in ci.operands]
        self.regs_read = set()
        for o in ci.operands:
            if o.type == CX.X86_OP_REG and o.reg in CS_REG:
                self.regs_read.add(CS_REG[o.reg])
        pre = tuple("%02x" % p for p in ci.prefix if p)
        opc = "%02x" % ci.opcode[0] + ("%02x" % ci.opcode[1] if ci.opcode[1] else "")
        self.form = f"{ci.mnemonic} {','.join(kinds)} pfx={'.'.join(pre) or '-'} op={opc}"
        self.rep = self.mn.startswith(("rep ", "repne ", "repe "))
        self.string = self.mn.split()[-1] in ("movsb", "movsw", "movsd", "stosb", "stosd", "stosw", "scasb",
                                              "scasw", "scasd", "cmpsb", "cmpsw", "cmpsd", "lodsb", "lodsw",
                                              "lodsd")
        self.x87 = self.bytes[len(pre)] in range(0xd8, 0xe0) if len(self.bytes) > len(pre) else False
        self.cti = self.mn in CTI
        self.reg_target = self.cti and self.mn in ("call", "jmp") and len(self.ops) == 1 and \
            self.ops[0].type == CX.X86_OP_REG
        self.mem_target = self.cti and self.mn in ("call", "jmp") and len(self.ops) == 1 and \
            self.ops[0].type == CX.X86_OP_MEM


class Machine:
    """One backend (Unicorn module or cshim module) with the test memory layout."""

    def __init__(self, mod, image, rnd_stack, rnd_scr):
        self.mod = mod
        self.uc = mod.Uc(mod.UC_ARCH_X86, mod.UC_MODE_32)
        uc = self.uc
        uc.mem_map(GDT, 0x1000)
        uc.mem_map(TEB, 0x1000)
        uc.mem_map(STACK_LO, STACK_SIZE)
        uc.mem_map(SCR_LO, SCR_SIZE)
        uc.mem_map(BASE, len(image))
        uc.mem_write(BASE, bytes(image))
        uc.mem_write(STACK_LO, rnd_stack)
        uc.mem_write(SCR_LO, rnd_scr)
        gdt = (b"\0" * 8 + gdt_entry(0, 0xfffff, 0x9b, 0xc) + gdt_entry(0, 0xfffff, 0x93, 0xc)
               + gdt_entry(TEB, 0xfff, 0x93, 0x4))
        uc.mem_write(GDT, gdt)
        uc.reg_write(UX.UC_X86_REG_GDTR, (0, GDT, len(gdt) - 1, 0))
        for r in (UX.UC_X86_REG_DS, UX.UC_X86_REG_ES, UX.UC_X86_REG_SS):
            uc.reg_write(r, 2 << 3)
        uc.reg_write(UX.UC_X86_REG_FS, 3 << 3)
        self.writes = []
        uc.hook_add(mod.UC_HOOK_MEM_WRITE, self._on_write)

    def _on_write(self, uc, access, addr, size, value, user):
        self.writes.append((addr, size))

    def set_state(self, st):
        uc = self.uc
        for r, v in zip(GPR, st["gpr"]):
            uc.reg_write(r, v)
        uc.reg_write(UX.UC_X86_REG_EFLAGS, st["eflags"])
        uc.reg_write(UX.UC_X86_REG_FPCW, st["fpcw"])
        uc.reg_write(UX.UC_X86_REG_FPSW, st["fpsw"])
        uc.reg_write(UX.UC_X86_REG_FPTAG, st["fptag"])
        for i, v in enumerate(st["fp"]):
            uc.reg_write(FP0 + i, v)
        for a, data in st["patches"]:
            uc.mem_write(a, data)
        self.writes = []

    def step(self, ins):
        uc = self.uc
        err = None
        try:
            if ins.rep:
                uc.emu_start(ins.addr, ins.addr + ins.size)
            else:
                uc.emu_start(ins.addr, 0xfffffff0, count=1)
        except self.mod.UcError as e:
            err = e.errno
        return err

    def get_state(self):
        uc = self.uc
        return dict(gpr=[uc.reg_read(r) for r in GPR], eip=uc.reg_read(UX.UC_X86_REG_EIP),
                    eflags=uc.reg_read(UX.UC_X86_REG_EFLAGS) & FLAGS_MASK,
                    fpcw=uc.reg_read(UX.UC_X86_REG_FPCW), fpsw=uc.reg_read(UX.UC_X86_REG_FPSW),
                    fptag=uc.reg_read(UX.UC_X86_REG_FPTAG),
                    fp=[tuple(uc.reg_read(FP0 + i)) for i in range(8)])


def mapped(a, n):
    for lo, size in ((BASE, 0x42000), (STACK_LO, STACK_SIZE), (SCR_LO, SCR_SIZE), (TEB, 0x1000)):
        if lo <= a and a + n <= lo + size:
            return True
    return False


class Gen:
    """Random machine states for one instruction."""

    def __init__(self, rng, targets, fsin_args, image=None):
        self.r = rng
        self.targets = targets
        self.target_set = set(targets)
        self.fsin_args = fsin_args
        self.image = image

    def u32(self):
        r = self.r
        k = r.random()
        if k < 0.25:
            return r.randrange(0, 256)
        if k < 0.40:
            return (-r.randrange(1, 257)) & 0xffffffff
        if k < 0.65:
            return r.getrandbits(32)
        if k < 0.80:
            return r.choice([0, 1, 2, 0x7f, 0x80, 0xff, 0x100, 0x7fff, 0x8000, 0xffff, 0x10000, 0x7fffffff,
                             0x80000000, 0x80000001, 0xfffffffe, 0xffffffff, 0x1f, 0x20, 0x21])
        if k < 0.90:
            return r.randrange(0, 1 << r.choice([8, 12, 16, 20, 24]))
        return (r.getrandbits(8) << 24) | (r.getrandbits(8) << 8) | r.getrandbits(4)

    def fpval(self):
        r = self.r
        k = r.random()
        if k < 0.20:
            return float(struct.unpack("<f", struct.pack("<f", r.uniform(-1000, 1000)))[0])
        if k < 0.35:
            return r.uniform(-1e4, 1e4)
        if k < 0.50:
            return float(r.randrange(-1000, 1001))
        if k < 0.58:
            return r.randrange(-100, 100) + 0.5
        if k < 0.70:
            e = r.randrange(31, 63)
            return float(r.choice([-1, 1]) * (r.getrandbits(52) | (1 << 52)) * 2.0 ** (e - 52))
        if k < 0.78:
            return r.choice([0.0, -0.0, 1.0, -1.0, 2.0, 0.5, 80.0, 249.0, 207.0, 0.01, 1e-3, 3.0,
                             0.006283185351, 2.0 ** 31, -2.0 ** 31, 2.0 ** 32, 2.0 ** 62, -2.0 ** 62,
                             2.0 ** 63, -2.0 ** 63, 4294967295.0, 4294967296.5, 65535.5, 32767.5, -32768.5])
        if k < 0.88:
            return r.uniform(-1, 1) * 10.0 ** r.randrange(-30, 31)
        return float(struct.unpack("<f", struct.pack("<f", r.uniform(-2, 2)))[0])

    def state(self, ins):
        r = self.r
        g = [self.u32() for _ in range(8)]
        g[4] = STACK_LO + 0x80000 + r.randrange(-0x4000, 0x4000)          # ESP
        if r.random() < 0.7 or any(m["base"] == 5 for m in ins.mems) or ins.mn == "leave":
            g[5] = STACK_LO + 0x80000 + r.randrange(-0x2000, 0x6000)      # EBP
        patches = []
        mn = ins.mn
        if ins.string:
            n = r.randrange(0, 300) if "scas" in mn else r.randrange(0, 40)
            if ins.rep:
                g[1] = n
            g[6] = SCR_LO + 0x40000 + r.randrange(0, 0x10000)
            g[7] = SCR_LO + 0x80000 + r.randrange(0, 0x10000)
            if "scas" in mn and r.random() < 0.5:
                g[0] = (g[0] & ~0xff) | r.choice([0, 0x20, 0x2e])
        if mn in ("div", "idiv") and r.random() < 0.6:
            g[2] = 0 if mn == "div" else (0xffffffff if g[0] & 0x80000000 else 0)
        if mn in ("bt", "bts", "btr", "btc") and ins.ops[1].type == CX.X86_OP_REG:
            reg = CS_REG.get(ins.ops[1].reg)
            if reg is not None:
                g[reg] = r.randrange(-512, 512) & 0xffffffff
        # memory operand bases and indexes
        eas = []
        for m in ins.mems:
            if ins.string:
                continue
            seg = TEB if m["seg"] == "fs" else 0
            if m["has_base"] and m["base"] in (4, 5):
                idx = r.randrange(0, 16)
                if m["has_index"] and m["index"] not in (4, 5):
                    g[m["index"]] = idx
            elif m["has_base"] or m["has_index"]:
                t = SCR_LO + 0x10000 + r.randrange(0, 0xc0000)
                b, x, s = m["base"], m["index"], m["scale"]
                if m["has_base"] and m["has_index"] and b == x:
                    g[b] = ((t - m["disp"]) // (1 + s)) & 0xffffffff
                else:
                    iv = 0
                    if m["has_index"]:
                        iv = r.randrange(0, 16)
                        if not m["has_base"] and m["disp"] < BASE:
                            iv = ((t - m["disp"]) // s) & 0xffffffff     # index only: EA in scratch
                        elif not m["has_base"] and ins.mem_target and self.image is not None \
                                and BASE + 0x1000 <= m["disp"] < BASE + 0xd000:
                            # jump table inside .text: never patch code bytes (Unicorn caches
                            # translated blocks); use an entry that holds a listing address
                            ok = [k for k in range(16) if struct.unpack_from(
                                "<I", self.image, m["disp"] - BASE + k * s)[0] in self.target_set]
                            iv = r.choice(ok) if ok else 0
                        g[x] = iv           # with a base, or an absolute table: small index
                    if m["has_base"]:
                        g[b] = (t - m["disp"] - iv * s) & 0xffffffff
            ea = (seg + m["disp"] + (g[m["base"]] if m["has_base"] else 0)
                  + (g[m["index"]] * m["scale"] if m["has_index"] else 0)) & 0xffffffff
            eas.append((ea, m["size"]))
        if ins.reg_target:
            g[CS_REG[ins.ops[0].reg]] = r.choice(self.targets)
        # memory content at the operands
        for ea, size in (eas if mn != "lea" else []):
            if not mapped(ea, max(size, 4) + 4):
                raise SystemExit(f"generator: EA {ea:08x} unmapped for {ins.addr:08x} {ins.text}")
            if BASE + 0x1000 <= ea < BASE + 0xd000:
                continue                                       # never patch code bytes
            if ins.mem_target:
                patches.append((ea, struct.pack("<I", r.choice(self.targets))))
            else:
                data = bytearray(r.getrandbits(8) for _ in range(max(size, 4) + 4))
                if ins.x87 and size in (4, 8) and mn.startswith("f") and not mn.startswith(("fi", "fnst", "fldcw")):
                    v = self.fpval()
                    data[:size] = struct.pack("<f" if size == 4 else "<d", v)
                if mn == "fild" and size == 8:
                    data[:8] = struct.pack("<q", r.randrange(-(1 << 62), 1 << 62) >> r.randrange(0, 62))
                if mn == "fldcw":
                    data[:2] = struct.pack("<H", r.choice([0x27f, 0x7f, 0x37f, 0xe7f, 0x67f, 0xa7f, 0x1372, 0x23f]))
                patches.append((ea, bytes(data)))
        if mn == "ret":
            patches.append((g[4], struct.pack("<I", r.choice(self.targets))))
        # flags
        ef = 0x2 | (r.getrandbits(12) & 0x8D5)
        if ins.string and r.random() < 0.5:
            ef |= 0x400
        # x87
        depth = r.randrange(0, 9)
        top = r.randrange(0, 8)
        fp = [f80_of_double(self.fpval()) for _ in range(8)]
        if mn in ("fsin", "fcos"):
            fp[top] = r.choice(self.fsin_args)
            depth = max(depth, 1)
        tag = 0
        for i in range(8):
            phys = (top + i) & 7
            if i >= depth:
                tag |= 3 << (2 * phys)
        if mn in X87_ARITH:
            cw = r.choice([0x27f, 0x27f, 0x07f])
        elif mn in X87_ROUNDING:
            cw = r.choice([0x27f, 0x67f, 0xa7f, 0xe7f, 0x07f, 0x47f, 0x87f, 0xc7f])
        elif ins.x87:
            cw = r.choice([0x27f, 0x07f, 0x37f, 0xe7f, 0x67f, 0xa7f])
        else:
            cw = 0x27f
        sw = (top << 11) | (r.getrandbits(16) & 0x473f)
        return dict(gpr=g, eflags=ef, fpcw=cw, fpsw=sw, fptag=tag, fp=fp, patches=patches)


def diff_run(U, C, insns, states, seed, targets, fsin, max_report, base_mem, image=None):
    """Compare one-instruction steps of both machines for every instruction and state."""
    n_states = n_mism = 0
    fsin_args = list(fsin.keys())
    per_form = collections.OrderedDict()
    for i in sorted(insns, key=lambda i: i.form):
        per_form.setdefault(i.form, dict(addrs=0, states=0, mism=0, errors=0, fsin=0, de_quirk=0, fetch_after=0))
    reports = []

    def restore(machines, ranges):
        for a, n in ranges:
            for lo, data in base_mem.items():
                if lo <= a < lo + len(data):
                    k = min(n, lo + len(data) - a)
                    for m in machines:
                        m.uc.mem_write(a, data[a - lo:a - lo + k])
            if TEB <= a < TEB + 0x1000:
                for m in machines:
                    m.uc.mem_write(a, b"\0" * min(n, TEB + 0x1000 - a))

    for ins in insns:
        pf = per_form[ins.form]
        pf["addrs"] += 1
        gen = Gen(random.Random((seed << 32) ^ ins.addr), targets, fsin_args, image)
        for k in range(states):
            st = gen.state(ins)
            U.set_state(st)
            C.set_state(st)
            eu = U.step(ins)
            ec = C.step(ins)
            su, sc = U.get_state(), C.get_state()
            if ins.mn in ("div", "idiv") and eu is None and su["eip"] == ins.addr:
                eu = unicorn.UC_ERR_EXCEPTION     # Unicorn quirk: repeated #DE at one address not reported
                pf["de_quirk"] += 1
            if ins.cti and eu == unicorn.UC_ERR_FETCH_UNMAPPED and ec is None and su["eip"] == sc["eip"]:
                eu = None     # Unicorn reports the fetch fault at the jump target; the C CPU stops before it
                pf["fetch_after"] += 1
            if ins.mn in ("fsin", "fcos") and eu is None:
                top = (st["fpsw"] >> 11) & 7
                arg = st["fp"][top]
                su["fp"][top] = fsin[arg][0 if ins.mn == "fsin" else 1]
                su["fpsw"] &= ~0x400
                pf["fsin"] += 1
            wr = set()
            for a, n in U.writes + C.writes:
                wr.add((a, n))
            diffs = []
            if eu != ec:
                diffs.append(f"error unicorn={eu} c={ec}")
            for key in ("eip", "eflags", "fpcw", "fpsw", "fptag"):
                if su[key] != sc[key]:
                    diffs.append(f"{key} unicorn={su[key]:#x} c={sc[key]:#x}")
            for j in range(8):
                if su["gpr"][j] != sc["gpr"][j]:
                    diffs.append(f"{GPR_NAMES[j]} unicorn={su['gpr'][j]:#x} c={sc['gpr'][j]:#x}")
                if su["fp"][j] != sc["fp"][j]:
                    diffs.append(f"fp{j} unicorn={su['fp'][j][1]:04x}:{su['fp'][j][0]:016x} "
                                 f"c={sc['fp'][j][1]:04x}:{sc['fp'][j][0]:016x}")
            for a, n in sorted(wr):
                try:
                    mu = bytes(U.uc.mem_read(a, n))
                except unicorn.UcError:
                    mu = None
                try:
                    mc = bytes(C.uc.mem_read(a, n))
                except cshim.UcError:
                    mc = None
                if mu != mc:
                    diffs.append(f"mem {a:08x}+{n} unicorn={mu.hex() if mu else None} c={mc.hex() if mc else None}")
            n_states += 1
            pf["states"] += 1
            if eu is not None:
                pf["errors"] += 1
            if diffs:
                n_mism += 1
                pf["mism"] += 1
                if len(reports) < max_report:
                    regs = " ".join(f"{n}={v:08x}" for n, v in zip(GPR_NAMES, st["gpr"]))
                    reports.append(f"{ins.addr:08x} {ins.text} [{ins.form}] state {k}: {regs} "
                                   f"eflags={st['eflags']:#x} fpcw={st['fpcw']:#x} fpsw={st['fpsw']:#x}\n    "
                                   + "\n    ".join(diffs))
            restore((U, C), [(a, n) for a, n in wr] + [(a, len(d)) for a, d in st["patches"]])

    return per_form, reports, n_states, n_mism


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--states", type=int, default=10)
    ap.add_argument("--seed", type=int, default=1)
    ap.add_argument("--only", default=None, help="comma-separated hex addresses")
    ap.add_argument("--forms", default=None, help="only forms containing this text")
    ap.add_argument("--out", default=RESULTS)
    ap.add_argument("--max-report", type=int, default=40)
    ns = ap.parse_args()
    t0 = time.time()

    pe = pefile.PE(GAM)
    image = bytearray(pe.get_memory_mapped_image()[:(pe.OPTIONAL_HEADER.SizeOfImage + 0xfff) & ~0xfff])
    image += b"\0" * (((pe.OPTIONAL_HEADER.SizeOfImage + 0xfff) & ~0xfff) - len(image))
    rng0 = random.Random(ns.seed)
    rnd_stack = bytes(rng0.getrandbits(8) for _ in range(STACK_SIZE))
    rnd_scr = bytes(rng0.getrandbits(8) for _ in range(SCR_SIZE))
    base_mem = {STACK_LO: rnd_stack, SCR_LO: rnd_scr, BASE: bytes(image)}

    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    listing = load_listing()
    addrs = list(listing)
    extra = []
    for a in listing:
        off = a - BASE
        ci = next(md.disasm(bytes(image[off:off + 16]), a))
        if ci.mnemonic == "wait" and (a + 1) not in set(listing):
            extra.append(a + 1)
    addrs = sorted(set(addrs) | set(extra))
    insns = []
    for a in addrs:
        off = a - BASE
        insns.append(Insn(next(md.disasm(bytes(image[off:off + 16]), a))))
    targets = listing
    fsin = load_fsin()
    fsin_args = list(fsin.keys())

    U = Machine(unicorn, image, rnd_stack, rnd_scr)
    C = Machine(cshim, image, rnd_stack, rnd_scr)

    # instruction length of the C decoder against capstone, for every address
    len_bad = [i for i in insns if C.uc.insn_len(i.addr) != i.size]

    if ns.only:
        want = {int(x, 16) for x in ns.only.split(",")}
        insns = [i for i in insns if i.addr in want]
    if ns.forms:
        insns = [i for i in insns if ns.forms in i.form]

    per_form, reports, n_states, n_mism = diff_run(U, C, insns, ns.states, ns.seed, targets, fsin, ns.max_report,
                                                    base_mem, bytes(image))

    wall = time.time() - t0
    os.makedirs(ns.out, exist_ok=True)
    lines = [f"# test_insn_diff.py: C interpreter vs Unicorn {unicorn.__version__}, one instruction per state",
             f"# addresses={len(insns)} (listing {len(listing)} + {len(extra)} split WAIT successors) "
             f"forms={len(per_form)} states_per_address={ns.states} seed={ns.seed} states={n_states}",
             f"# instruction length (C decoder vs capstone) mismatches: {len(len_bad)}"
             + (" " + " ".join(f"{i.addr:08x}" for i in len_bad[:20]) if len_bad else ""),
             f"# mismatching states: {n_mism} (unexplained)",
             f"# FSIN/FCOS states compared against the x87 table: {sum(p['fsin'] for p in per_form.values())}",
             f"# DIV/IDIV states where Unicorn left EIP at the instruction without reporting #DE (counted as "
             f"#DE): {sum(p['de_quirk'] for p in per_form.values())}",
             f"# control transfers to an unmapped target (Unicorn reports the fetch fault of the next "
             f"instruction, same EIP): {sum(p['fetch_after'] for p in per_form.values())}",
             f"# wall time {wall:.1f} s",
             "form\taddresses\tstates\terror_states\tmismatches"]
    for f, p in per_form.items():
        lines.append(f"{f}\t{p['addrs']}\t{p['states']}\t{p['errors']}\t{p['mism']}")
    if reports:
        lines.append("# first mismatches:")
        lines += reports
    text = "\n".join(lines) + "\n"
    name = "insn_diff.txt" if not (ns.only or ns.forms) else "insn_diff_partial.txt"
    with open(os.path.join(ns.out, name), "w") as f:
        f.write(text)
    print("\n".join(lines[:6]))
    if reports:
        print("\n".join(reports[:10]))
    return 0 if n_mism == 0 and not len_bad else 1


if __name__ == "__main__":
    sys.exit(main())
