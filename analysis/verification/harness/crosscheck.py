"""Cross-check the static call-site table (callsites.tsv, this workstream) with workstream B's
analysis/interface.tsv (engine side: argc and callee_pop_bytes per interface method) and with the
argument signatures of the mock (mock.BEHAVIOUR).

Usage: python -I -B crosscheck.py [OUT]
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import mock  # noqa: E402

ITSV = "/home/user/moeboid_port/analysis/interface.tsv"


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "..", "logs", "interface_crosscheck.log")
    sites = {}
    for i, line in enumerate(open(os.path.join(HERE, "callsites.tsv"))):
        if i:
            f = line.rstrip("\n").split("\t")
            sites[int(f[0], 16)] = (f[1], f[3], int(f[4]))
    lines = []
    covered = {}
    bad = 0
    rows = 0
    for i, line in enumerate(open(ITSV)):
        if i == 0:
            continue
        f = line.rstrip("\n").split("\t")
        iface, off, argc, pop, callers = f[0], int(f[2], 16), int(f[6]), int(f[7]), f[11]
        rows += 1
        if pop != 4 * argc:
            lines.append(f"MISMATCH {iface}+{off:#x}: argc {argc} but callee pops {pop} bytes")
            bad += 1
        beh = mock.BEHAVIOUR.get((iface, off))
        if beh is None:
            lines.append(f"NOTE {iface}+{off:#x}: not in the mock")
        elif len(beh[1]) != argc:
            lines.append(f"MISMATCH {iface}+{off:#x}: mock signature {beh[1]!r} has {len(beh[1])} args, interface.tsv {argc}")
            bad += 1
        for c in filter(None, callers.split(",")):
            a = int(c, 16)
            if a in covered:
                lines.append(f"NOTE {a:08x} listed for {covered[a]} and {iface}+{off:#x}")
            covered[a] = f"{iface}+{off:#x}"
            s = sites.get(a)
            if s is None:
                lines.append(f"MISMATCH {a:08x} ({iface}+{off:#x}): not an indirect call site in callsites.tsv")
                bad += 1
            elif s[2] != argc or int(s[1], 16) != off:
                lines.append(f"MISMATCH {a:08x} ({iface}+{off:#x}): callsites.tsv offset {s[1]} nargs {s[2]}, interface.tsv argc {argc}")
                bad += 1
    for a, (fn, off, n) in sorted(sites.items()):
        if a not in covered:
            lines.append(f"UNCOVERED {a:08x} {fn} offset {off} nargs {n}: no interface.tsv row lists this site")
    head = [f"interface.tsv rows={rows}; call sites listed={len(covered)}; callsites.tsv sites={len(sites)}; "
            f"mismatches={bad}; uncovered={sum(1 for a in sites if a not in covered)}"]
    text = "\n".join(head + lines) + "\n"
    open(out, "w").write(text)
    sys.stdout.write(text)


if __name__ == "__main__":
    main()
