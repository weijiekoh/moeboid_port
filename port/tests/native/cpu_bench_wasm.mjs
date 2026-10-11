// wasm build of port/tests/native/cpu_bench.c: same workload as the native benchmark; prints the
// same hashes (engine call sequence, guest memory), so native and wasm results can be compared.
// Build (from the project root):
//   for f in port/tests/native/cpu_bench.c port/src/cpu/*.c port/src/rt/*.c; do
//     clang --target=wasm32 -nostdlib -std=c11 -O2 -ffp-contract=off -fno-math-errno -ffreestanding \
//       -nostdlibinc -Iport/src -c $f -o OUT/$(basename $f .c).o; done
//   wasm-ld --no-entry --stack-first -z stack-size=1048576 -o OUT/cpu_bench.wasm OUT/*.o
// Run: node port/tests/native/cpu_bench_wasm.mjs OUT/cpu_bench.wasm extracted/Moeboid.gam [ms [nested]]
import { readFileSync } from "node:fs";

const [wasmPath, gamPath, msArg, nestedArg] = process.argv.slice(2);
const ms = Number(msArg ?? 600000);
const nested = Number(nestedArg ?? 1);
let mem;
const dec = new TextDecoder();
const { instance } = await WebAssembly.instantiate(readFileSync(wasmPath), {
  env: { host_log: (p, n) => console.log(dec.decode(new Uint8Array(mem.buffer, p, n))) },
});
mem = instance.exports.memory;
const gam = readFileSync(gamPath);
const p = instance.exports.bench_alloc(gam.length);
new Uint8Array(mem.buffer, p, gam.length).set(gam);
const t0 = performance.now();
const r = instance.exports.bench_wasm(p, gam.length, ms, nested);
const s = (performance.now() - t0) / 1000;
const dv = new DataView(mem.buffer);
const u32 = (o) => dv.getUint32(r + o, true);
const u64 = (o) => dv.getBigUint64(r + o, true);
const text = dec.decode(new Uint8Array(mem.buffer, r + 40, 200)).replace(/\0.*$/s, "");
if (text) {
  console.log(`FAILED: ${text}`);
  process.exit(1);
}
const ticks = u32(0), insns = Number(u64(16));
console.log(`game_ms=${u32(12)} ticks=${ticks} engine_calls=${u32(4)} objects=${u32(8)} guest_insns=${insns} wall_s=${s.toFixed(3)}`);
console.log(`ticks_per_s=${(ticks / s).toFixed(0)} guest_insns_per_s=${(insns / s / 1e6).toFixed(1)}M realtime_factor=${(u32(12) / 1000 / s).toFixed(0)}`);
console.log(`hash_calls=${u64(24).toString(16).padStart(16, "0")} hash_mem=${u64(32).toString(16).padStart(16, "0")} nested_calls=${u32(240)}`);
