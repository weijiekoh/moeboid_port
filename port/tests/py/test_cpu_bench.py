"""Speed of the C interpreter and native/wasm equality (M2 task 6).

Builds port/tests/native/cpu_bench.c twice (native with the host compiler; wasm32 freestanding with
clang + wasm-ld, run by node through port/tests/native/cpu_bench_wasm.mjs), runs the same workload
(Moeboid.gam against the C engine mock of cpu_bench.c for GAME_MS of game time) and compares the
hashes of the engine call sequence and of guest memory. A third run without the nested guest calls
(cpu_bench.c: strlen from inside engine_dispatch) must give the same ticks and engine call hash.
Reports game ticks per second of wall time.
Writes port/tests/py/results/cpu_bench.txt.

Usage: python -I -B port/tests/py/test_cpu_bench.py [GAME_MS]   (default 600000 = 10 min of game time)
"""
import glob
import os
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
PORT = os.path.normpath(os.path.join(HERE, "..", ".."))
ROOT = os.path.dirname(PORT)
GAM = os.path.join(ROOT, "extracted", "Moeboid.gam")
RESULTS = os.path.join(HERE, "results")
FLAGS = ["-std=c11", "-O2", "-ffp-contract=off", "-fno-math-errno", "-Wall", "-Wextra", "-I" + os.path.join(PORT, "src")]


def main():
    ms = sys.argv[1] if len(sys.argv) > 1 else "600000"
    srcs = sorted(glob.glob(os.path.join(PORT, "src", "cpu", "*.c")) + glob.glob(os.path.join(PORT, "src", "rt", "*.c")))
    bench = os.path.join(PORT, "tests", "native", "cpu_bench.c")
    out = {}
    with tempfile.TemporaryDirectory() as tmp:
        exe = os.path.join(tmp, "cpu_bench")
        subprocess.run(["clang", *FLAGS, bench, *srcs, "-o", exe], check=True)
        out["native"] = subprocess.run([exe, GAM, ms, "1"], check=True, capture_output=True, text=True).stdout
        out["native, no nested calls"] = subprocess.run([exe, GAM, ms, "0"], check=True, capture_output=True,
                                                        text=True).stdout
        objs = []
        for i, f in enumerate([bench] + srcs):
            o = os.path.join(tmp, f"{i}.o")
            subprocess.run(["clang", "--target=wasm32", "-nostdlib", "-ffreestanding", "-nostdlibinc", *FLAGS, "-c", f,
                            "-o", o], check=True)
            objs.append(o)
        wasm = os.path.join(tmp, "cpu_bench.wasm")
        subprocess.run(["wasm-ld", "--no-entry", "--stack-first", "-z", "stack-size=1048576", "-o", wasm, *objs],
                       check=True)
        out["wasm"] = subprocess.run(["node", os.path.join(PORT, "tests", "native", "cpu_bench_wasm.mjs"), wasm, GAM, ms,
                                      "1"], check=True, capture_output=True, text=True).stdout

    def field(text, key):
        for tok in text.split():
            if tok.startswith(key + "="):
                return tok.split("=", 1)[1]
        return None

    same = all(field(out["native"], k) == field(out["wasm"], k) and field(out["native"], k) is not None
               for k in ("ticks", "engine_calls", "guest_insns", "hash_calls", "hash_mem", "nested_calls"))
    nested_ok = all(field(out["native"], k) == field(out["native, no nested calls"], k)
                    for k in ("ticks", "engine_calls", "hash_calls")) and int(field(out["native"], "nested_calls")) > 0
    lines = [f"# test_cpu_bench.py: Moeboid.gam with the C engine mock of port/tests/native/cpu_bench.c, {ms} ms game time"]
    for k in ("native", "native, no nested calls", "wasm"):
        lines.append(f"{k}:")
        lines += ["  " + ln for ln in out[k].strip().splitlines()]
    lines.append(f"# native and wasm ticks, call hash, memory hash: {'identical' if same else 'DIFFERENT'}")
    lines.append(f"# nested guest calls from engine_dispatch (strlen per ISound.Play): ticks and call hash "
                 f"{'unchanged' if nested_ok else 'CHANGED'}")
    os.makedirs(RESULTS, exist_ok=True)
    with open(os.path.join(RESULTS, "cpu_bench.txt"), "w") as f:
        f.write("\n".join(lines) + "\n")
    print("\n".join(lines))
    return 0 if same and nested_ok else 1


if __name__ == "__main__":
    sys.exit(main())
