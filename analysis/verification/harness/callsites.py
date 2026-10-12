"""Static stack-argument analysis of the indirect CALLs in Moeboid.gam game code.

For every `CALL dword ptr [reg + off]` in the game code (0x10001000..0x10005110), estimate the
number of stack arguments that the caller pushed for this call. Method: CFG walk per function
with a model of the stack as a list of push records. Records have a kind:
  save   callee-saved register pushed before the function wrote it (prologue)
  seh    SEH frame pushes (push -1 / push handler / push fs:[0])
  alloc  stack space (sub esp, push ecx in the prologue, _alloca_probe)
  arg    everything else (an outgoing argument)
At an indirect call, N = number of contiguous unconsumed `arg` records at the top of the stack.
The model assumes callee-pop (MSVC __thiscall) unless the next instruction is `add esp, 4*N`.
Direct calls to game functions pop the number of bytes of the target's `ret N`.

Limit: if an outer call's argument was pushed before an inner indirect call (f(g(x), a) pattern),
N of the inner call is too large. The harness cross-checks N per (interface, offset) at run time,
and engine_vtables.py gives the engine's `ret N` for comparison. All values are PROVISIONAL until
workstream B's analysis/interface.tsv exists.

Usage: python -I callsites.py [OUT.tsv]
"""
import os
import sys

import capstone
from capstone import x86 as X
import pefile

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", ".."))
GAM = f"{ROOT}/extracted/Moeboid.gam"
FTSV = f"{ROOT}/analysis/decomp/Moeboid.gam/functions.tsv"
GAME_LO, GAME_HI = 0x10001000, 0x10005110
ALLOCA_PROBE = 0x10005600  # verified: Moeboid.gam:0x10005600 is the MSVC _alloca_probe (ESP -= EAX)

# stdcall argument counts of the KERNEL32 functions called from game code (FUN_10004e90).
WINAPI_ARGS = {"FindResourceA": 3, "CreateFileA": 7, "GetFileSize": 2, "ReadFile": 5,
               "CloseHandle": 1, "LoadResource": 2, "LockResource": 1, "SizeofResource": 2}

SAVED = {"ebx", "esi", "edi", "ebp"}


def load_functions():
    funcs = {}
    for i, line in enumerate(open(FTSV)):
        if i == 0:
            continue
        f = line.rstrip("\n").split("\t")
        funcs[int(f[0], 16)] = (f[1], int(f[3]))
    return funcs


class Analyzer:
    def __init__(self):
        pe = pefile.PE(GAM)
        self.base = pe.OPTIONAL_HEADER.ImageBase
        self.img = pe.get_memory_mapped_image()
        self.iat = {}
        for d in pe.DIRECTORY_ENTRY_IMPORT:
            for imp in d.imports:
                self.iat[imp.address] = imp.name.decode()
        self.md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
        self.md.detail = True
        self.funcs = load_functions()
        self.cache = {}
        self._pop = {}

    def ins(self, va):
        if va not in self.cache:
            o = va - self.base
            self.cache[va] = next(self.md.disasm(self.img[o:o + 16], va))
        return self.cache[va]

    def u32(self, va):
        o = va - self.base
        return int.from_bytes(self.img[o:o + 4], "little")

    def callee_pop(self, t):
        """Bytes popped by a game-image function (from its ret instructions)."""
        if t in self._pop:
            return self._pop[t]
        name, size = self.funcs.get(t, (None, 0x400))
        o = t - self.base
        rets = set()
        for i in self.md.disasm(self.img[o:o + size], t):
            if i.mnemonic == "ret":
                rets.add(i.operands[0].imm if i.operands else 0)
        r = max(rets) if rets else 0
        self._pop[t] = r
        return r

    def analyze(self, entry):
        name, size = self.funcs[entry]
        sites = []
        conflicts = []
        # state: (records tuple of (kind, addr, consumed)), written regs, eax const, eax_fs0, ebp_depth, called
        start = ((), frozenset(), None, False, None, False)
        seen = {}
        work = [(entry, start)]
        while work:
            va, st = work.pop()
            while True:
                if va in seen:
                    if len(seen[va][0]) != len(st[0]):
                        conflicts.append((va, len(seen[va][0]), len(st[0])))
                    break
                seen[va] = st
                recs, written, eaxc, eaxfs, ebpd, called = st
                recs = list(recs)
                i = self.ins(va)
                m = i.mnemonic
                nxt = va + i.size
                succ = [nxt]
                ops = i.operands
                w = set(written)
                # registers written by this instruction
                try:
                    _, regs_w = i.regs_access()
                    for r in regs_w:
                        w.add(i.reg_name(r))
                except capstone.CsError:
                    pass
                new_eaxc, new_eaxfs = None, False
                if m == "push":
                    op = ops[0]
                    kind = "arg"
                    narg = sum(1 for r in recs if r[0] == "arg")
                    if op.type == X.X86_OP_REG:
                        rn = i.reg_name(op.reg)
                        if rn in SAVED and rn not in written:
                            kind = "save"
                        elif rn == "ecx" and "ecx" not in written and not called and narg == 0:
                            kind = "alloc"
                        elif rn == "eax" and eaxfs:
                            kind = "seh"
                    elif op.type == X.X86_OP_IMM and not called and narg == 0 and ebpd is not None and \
                            (op.imm & 0xffffffff in (0xffffffff,) or GAME_HI <= op.imm < 0x1000d000):
                        kind = "seh"  # push -1 / push SEH handler (handlers live at 0x1000c5xx)
                    recs.append((kind, va, False))
                    w.discard("esp")
                elif m == "pop":
                    if recs:
                        recs.pop()
                elif m == "sub" and ops[0].type == X.X86_OP_REG and i.reg_name(ops[0].reg) == "esp" \
                        and ops[1].type == X.X86_OP_IMM:
                    recs += [("alloc", va, False)] * (ops[1].imm // 4)
                elif m == "add" and ops[0].type == X.X86_OP_REG and i.reg_name(ops[0].reg) == "esp" \
                        and ops[1].type == X.X86_OP_IMM:
                    k = ops[1].imm // 4
                    del recs[max(0, len(recs) - k):]
                elif m == "mov" and ops[0].type == X.X86_OP_REG and i.reg_name(ops[0].reg) == "ebp" \
                        and ops[1].type == X.X86_OP_REG and i.reg_name(ops[1].reg) == "esp":
                    ebpd = len(recs)
                elif m in ("mov", "lea") and ops[0].type == X.X86_OP_REG and i.reg_name(ops[0].reg) == "esp":
                    if m == "mov" and ebpd is not None:
                        del recs[ebpd:]
                    else:
                        recs = [r for r in recs if r[0] != "arg"]
                elif m == "leave":
                    if ebpd is not None:
                        del recs[ebpd:]
                    if recs:
                        recs.pop()
                elif m == "mov" and ops[0].type == X.X86_OP_REG and i.reg_name(ops[0].reg) == "eax":
                    if ops[1].type == X.X86_OP_IMM:
                        new_eaxc = ops[1].imm
                    elif ops[1].type == X.X86_OP_MEM and ops[1].mem.segment != 0:
                        new_eaxfs = True
                elif m == "call":
                    called = True
                    op = ops[0]
                    after = self.ins(nxt)
                    add_after = None
                    if after.mnemonic == "add" and after.operands[0].type == X.X86_OP_REG and \
                            after.reg_name(after.operands[0].reg) == "esp" and after.operands[1].type == X.X86_OP_IMM:
                        add_after = after.operands[1].imm // 4
                    elif after.mnemonic == "pop" and after.operands[0].type == X.X86_OP_REG and \
                            after.reg_name(after.operands[0].reg) == "ecx":
                        add_after = 1
                    if op.type == X.X86_OP_IMM:
                        t = op.imm
                        if t == ALLOCA_PROBE:
                            recs += [("alloc", va, False)] * ((eaxc or 0) // 4)
                        else:
                            c = self.callee_pop(t) // 4
                            if c:
                                del recs[max(0, len(recs) - c):]
                            elif add_after:
                                for j in range(max(0, len(recs) - add_after), len(recs)):
                                    recs[j] = (recs[j][0], recs[j][1], True)
                    elif op.type == X.X86_OP_MEM and op.mem.base == 0 and op.mem.index == 0 and \
                            (op.mem.disp & 0xffffffff) in self.iat:
                        api = self.iat[op.mem.disp & 0xffffffff]
                        c = WINAPI_ARGS.get(api, 0)
                        del recs[max(0, len(recs) - c):]
                    else:
                        n = 0
                        for r in reversed(recs):
                            if r[0] != "arg" or r[2]:
                                break
                            n += 1
                        caller_pop = add_after is not None and add_after == n and n > 0
                        disp = op.mem.disp if op.type == X.X86_OP_MEM else None
                        sites.append({"addr": va, "func": name, "insn": f"{m} {i.op_str}",
                                      "off": disp, "nargs": n, "caller_pop": caller_pop,
                                      "pushes": [r[1] for r in recs[len(recs) - n:]] if n else []})
                        if not caller_pop:
                            del recs[max(0, len(recs) - n):]
                    w.update({"eax", "ecx", "edx"})
                elif m == "ret":
                    break
                elif m == "jmp":
                    op = ops[0]
                    if op.type == X.X86_OP_IMM:
                        succ = [op.imm]
                    elif op.type == X.X86_OP_MEM and op.mem.index != 0 and op.mem.scale == 4:
                        # switch table: count from the preceding cmp reg, imm
                        tbl = op.mem.disp & 0xffffffff
                        succ = []
                        while entry <= self.u32(tbl + 4 * len(succ)) < entry + size:
                            succ.append(self.u32(tbl + 4 * len(succ)))
                    else:
                        succ = []
                elif m.startswith("j") or m.startswith("loop"):
                    if ops and ops[0].type == X.X86_OP_IMM:
                        succ = [nxt, ops[0].imm]
                st2 = (tuple(recs), frozenset(w), new_eaxc, new_eaxfs, ebpd, called)
                if not succ:
                    break
                for s in succ[1:]:
                    work.append((s, st2))
                va, st = succ[0], st2
        return sites, conflicts


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else None
    a = Analyzer()
    rows = []
    allconf = []
    for entry in sorted(a.funcs):
        if not (GAME_LO <= entry < GAME_HI):
            continue
        s, c = a.analyze(entry)
        rows += s
        allconf += [(a.funcs[entry][0],) + x for x in c]
    rows.sort(key=lambda r: r["addr"])
    lines = ["address\tfunction\tinstruction\tvtable_offset\tnargs\tcaller_pop\tpush_addresses"]
    for r in rows:
        lines.append(f"{r['addr']:08x}\t{r['func']}\t{r['insn']}\t"
                     f"{'' if r['off'] is None else hex(r['off'])}\t{r['nargs']}\t{int(r['caller_pop'])}\t"
                     + ",".join(f"{p:08x}" for p in r["pushes"]))
    text = "\n".join(lines) + "\n"
    if out:
        open(out, "w").write(text)
    else:
        sys.stdout.write(text)
    print(f"# {len(rows)} indirect call sites; {len(allconf)} merge conflicts", file=sys.stderr)
    for c in allconf:
        print(f"# conflict {c[0]} at {c[1]:08x}: {c[2]} vs {c[3]} records", file=sys.stderr)


if __name__ == "__main__":
    main()
