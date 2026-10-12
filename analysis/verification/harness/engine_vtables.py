"""Static helper: list ZapSpot.exe vtables (from the Ghidra export vtables.txt) with the
callee stack cleanup (RET N) of every method, read from the binary with capstone.
Read-only: the engine binary is only decoded, never executed.

Usage: python -I engine_vtables.py [--json OUT] [VTABLE_ADDR ...]
"""
import json
import os
import sys

import capstone
import pefile

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", ".."))
EXE = f"{ROOT}/extracted/ZapSpot.exe"
VTXT = f"{ROOT}/analysis/decomp/ZapSpot.exe/vtables.txt"
FTSV = f"{ROOT}/analysis/decomp/ZapSpot.exe/functions.tsv"


def load_sizes():
    sizes = {}
    for i, line in enumerate(open(FTSV)):
        if i == 0:
            continue
        f = line.rstrip("\n").split("\t")
        sizes[int(f[0], 16)] = int(f[3])
    return sizes


class Image:
    def __init__(self, path):
        pe = pefile.PE(path, fast_load=True)
        self.base = pe.OPTIONAL_HEADER.ImageBase
        self.img = pe.get_memory_mapped_image()
        self.md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
        self.md.detail = True
        self.sizes = load_sizes()

    def u32(self, va):
        o = va - self.base
        return int.from_bytes(self.img[o:o + 4], "little")

    def cleanup(self, va, depth=0, seen=None):
        """Return (bytes popped by callee, how). Follows direct JMP thunks.
        Scans the function body linearly (up to 4 KiB) and collects every RET form."""
        seen = seen or set()
        if va in seen or depth > 4:
            return None, "loop"
        seen.add(va)
        o = va - self.base
        size = self.sizes.get(va)
        rets = set()
        first = True
        for ins in self.md.disasm(self.img[o:o + (size or 0x1000)], va):
            if ins.mnemonic == "jmp" and not rets:
                op = ins.operands[0]
                if first and op.type == capstone.x86.X86_OP_IMM:
                    return self.cleanup(op.imm, depth + 1, seen)
                if op.type != capstone.x86.X86_OP_IMM and size is None:
                    return None, f"tailjmp:{ins.op_str}"
            first = False
            if ins.mnemonic == "ret":
                rets.add(ins.operands[0].imm if ins.operands else 0)
                if size is None:
                    break
            if ins.mnemonic == "int3":
                break
        if len(rets) == 1:
            return rets.pop(), "ret"
        if not rets:
            return None, "noret"
        return None, f"multi:{sorted(rets)}"


def load_vtables():
    vts = {}
    cur = None
    for line in open(VTXT):
        if line.startswith("VTABLE"):
            cur = int(line.split()[1], 16)
            vts[cur] = []
        elif cur is not None and line.startswith("  +0x"):
            parts = line.split()
            vts[cur].append((int(parts[0][1:], 16), int(parts[1], 16)))
    return vts


def main():
    args = sys.argv[1:]
    out = None
    if args[:1] == ["--json"]:
        out = args[1]
        args = args[2:]
    im = Image(EXE)
    vts = load_vtables()
    want = [int(a, 16) for a in args] or sorted(vts)
    res = {}
    for vt in want:
        ents = vts.get(vt) or []
        rows = []
        for off, tgt in ents:
            n, how = im.cleanup(tgt)
            rows.append({"off": off, "target": tgt, "cleanup": n, "how": how})
        res[f"{vt:08x}"] = rows
        if out is None:
            print(f"VTABLE {vt:08x} n={len(rows)}")
            for r in rows:
                print(f"  +0x{r['off']:03x} {r['target']:08x} cleanup={r['cleanup']} ({r['how']})")
    if out:
        json.dump(res, open(out, "w"), indent=1)


if __name__ == "__main__":
    main()
