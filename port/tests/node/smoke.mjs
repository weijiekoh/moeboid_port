// Node smoke test for moeboid.wasm (M1): imports, exports, port_init with an empty pack, advance,
// frame buffer colour #3333cc, flags, storage blob, input queue, sound queue.
// Usage: node port/tests/node/smoke.mjs [path/to/moeboid.wasm]
import { readFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";

const here = fileURLToPath(new URL(".", import.meta.url));
const wasmPath = process.argv[2] ?? `${here}/../../build/moeboid.wasm`;
let pass = 0;
let fail = 0;
const check = (cond, what) => {
  if (cond) pass++;
  else {
    fail++;
    console.error(`FAIL: ${what}`);
  }
};

const EXPORTS = [
  "memory", "port_alloc", "port_free", "port_set_seed", "port_init", "port_advance", "port_input",
  "port_frame_ptr", "port_frame_w", "port_frame_h", "port_cursor", "port_sound_cmds", "port_sound_cmds_max",
  "port_storage_get_ptr", "port_storage_get_len", "port_storage_load", "port_now", "port_trace_mode",
];

async function load(path, traceLines) {
  const module = await WebAssembly.compile(readFileSync(path));
  const logs = [];
  let mem = null;
  const text = (p, n) => Buffer.from(new Uint8Array(mem.buffer, p, n)).toString("latin1");
  const imports = {
    env: {
      host_log: (p, n) => logs.push(text(p, n)),
      host_trace: (p, n) => traceLines.push(text(p, n)),
    },
  };
  const instance = await WebAssembly.instantiate(module, imports);
  mem = instance.exports.memory;
  return { module, ex: instance.exports, logs };
}

async function smoke(path, traceBuild) {
  const traceLines = [];
  const { module, ex } = await load(path, traceLines);
  const imports = WebAssembly.Module.imports(module).map((i) => `${i.module}.${i.name}`).sort();
  // Only env.host_log; env.host_trace only in the trace build (and only when code uses it).
  const allowed = traceBuild ? ["env.host_log", "env.host_trace"] : ["env.host_log"];
  check(imports.includes("env.host_log") && imports.every((i) => allowed.includes(i)), `imports ${imports}`);
  const names = WebAssembly.Module.exports(module).map((e) => e.name);
  for (const n of EXPORTS) check(names.includes(n), `export ${n}`);

  ex.port_set_seed(1);
  check(ex.port_init(0, 0, 0, 0, 0, 0xffffffff) === 0, "port_init with an empty pack returns 0");
  check(ex.port_frame_w() === 800 && ex.port_frame_h() === 572, "frame size 800x572");
  let f = ex.port_advance(1000);
  check((f & 1) === 1, "first advance reports a new frame");
  f = ex.port_advance(1100);
  check(f === 0, "second advance: no flags");
  check(ex.port_now() === 100, "100 clock steps after 100 ms (1 ms step)");
  const fb = new Uint8Array(ex.memory.buffer, ex.port_frame_ptr(), 800 * 572 * 4);
  let bad = 0;
  for (let i = 0; i < fb.length; i += 4) {
    if (fb[i] !== 0x33 || fb[i + 1] !== 0x33 || fb[i + 2] !== 0xcc || fb[i + 3] !== 0xff) bad++;
  }
  check(bad === 0, `frame buffer is #3333cc (${bad} other pixels)`);
  check(ex.port_cursor() === 0, "cursor 0");
  check(ex.port_sound_cmds(0) === 0, "empty sound queue");
  check(ex.port_input(1, 0x25, 0, 1150) === 1, "input queued");
  ex.port_advance(1200);

  // storage blob: empty store, then load and read back
  const hdr = "MOEBOID-STORAGE 1\n";
  const blobText = () =>
    Buffer.from(new Uint8Array(ex.memory.buffer, ex.port_storage_get_ptr(), ex.port_storage_get_len())).toString("latin1");
  check(blobText() === hdr, "empty storage blob is the header");
  const src = Buffer.from(`${hdr}Score1Name=ZapSpot\nScore1Score=10000\n`, "latin1");
  const p = ex.port_alloc(src.length);
  check(p !== 0 && p % 8 === 0, "port_alloc returns an 8-byte aligned block");
  new Uint8Array(ex.memory.buffer, p, src.length).set(src);
  check(ex.port_storage_load(p, src.length) === 0, "storage load");
  ex.port_free(p);
  check(blobText() === src.toString("latin1"), "storage round trip");

  // allocator grows the wasm memory on demand; too large a request returns 0
  const pagesBefore = ex.memory.buffer.byteLength / 65536;
  const big = ex.port_alloc(64 * 1024 * 1024);
  check(big !== 0 && big % 8 === 0, "64 MiB block");
  check(ex.memory.buffer.byteLength / 65536 > pagesBefore, "memory grew");
  new Uint8Array(ex.memory.buffer, big, 64 * 1024 * 1024).fill(0xa5);
  ex.port_free(big);
  check(ex.port_alloc(0x7fffffff) === 0, "request above the arena limit returns 0");
  const fb2 = new Uint8Array(ex.memory.buffer, ex.port_frame_ptr(), 4);
  check(fb2[0] === 0x33 && fb2[2] === 0xcc, "frame intact after memory growth");

  // clock step 15.625 ms on a fresh instance
  const two = await load(path, []);
  two.ex.port_init(0, 0, 0, 0, 1, 0);
  two.ex.port_advance(0);
  two.ex.port_advance(47);
  check(two.ex.port_now() === 46, "15.625 ms step: 3 steps at 47 ms, GetTickCount 46");

  check(ex.port_trace_mode(1) === (traceBuild ? 1 : 0), "trace mode availability");
}

await smoke(wasmPath, false);
const tracePath = wasmPath.replace(/moeboid\.wasm$/, "moeboid-trace.wasm");
if (tracePath !== wasmPath && existsSync(tracePath)) await smoke(tracePath, true);
console.log(`smoke: ${pass} passed, ${fail} failed`);
process.exit(fail ? 1 : 0);
