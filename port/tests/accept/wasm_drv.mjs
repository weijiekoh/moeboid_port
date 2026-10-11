// Acceptance scenario driver (M7) for moeboid.wasm in node: the same scenario format, host frame rule and
// output lines as port/tests/native/accept_drv.c (see there), so port/tests/accept/verify.py can compare
// the native and the wasm build line by line. Extra field on check lines: wasm_mem (bytes of the wasm
// memory). Heap numbers differ between the builds (pointer size), the other fields must be equal.
// Usage: node port/tests/accept/wasm_drv.mjs SCENARIO [--wasm FILE] [--quiet-sound]
import { readFileSync } from "node:fs";
import { createHash } from "node:crypto";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), "../../..");
const argv = process.argv.slice(2);
let wasmPath = `${ROOT}/port/build/moeboid.wasm`;
let quietSound = false;
const pos = [];
for (let i = 0; i < argv.length; i++) {
  if (argv[i] === "--wasm") wasmPath = argv[++i];
  else if (argv[i] === "--quiet-sound") quietSound = true;
  else pos.push(argv[i]);
}
if (pos.length !== 1) {
  console.error("usage: wasm_drv.mjs SCENARIO [--wasm FILE] [--quiet-sound]");
  process.exit(2);
}

const out = [];
const print = (s) => out.push(s);
let mem = null;
let nLogs = 0;
const text = (p, n) => Buffer.from(new Uint8Array(mem.buffer, p, n)).toString("latin1");
const imports = {
  env: {
    host_log: (p, n) => {
      nLogs++;
      print(`log ${text(p, n)}`);
    },
    host_trace: () => {},
  },
};
const { instance } = await WebAssembly.instantiate(readFileSync(wasmPath), imports);
const ex = instance.exports;
mem = ex.memory;
const pack = readFileSync(`${ROOT}/port/build/web/pack.bin`);
const gam = readFileSync(`${ROOT}/extracted/Moeboid.gam`);
const copyIn = (bytes) => {
  const p = ex.port_alloc(bytes.length);
  new Uint8Array(mem.buffer, p, bytes.length).set(bytes);
  return p;
};

const set = { seed: 1, clock: 0, smoothing: 1, quirks: 0xffffffff, frame: 16 };
let started = false;
let nextFrame = 0;
let soundBuf = 0;
const drain = () => {
  const n = ex.port_sound_cmds(soundBuf);
  if (quietSound) return;
  const w = new Uint32Array(mem.buffer, soundBuf, n * 4);
  for (let i = 0; i < n; i++) print(`snd ${w[i * 4]} ${w[i * 4 + 1]} ${w[i * 4 + 2]} ${w[i * 4 + 3]}`);
};
const advance = (t) => {
  ex.port_advance(t >>> 0);
  drain();
};
const framesBefore = (t) => {
  while (nextFrame < t) {
    advance(nextFrame);
    nextFrame += set.frame;
  }
};
const P = (w) => ex.port_probe(w) >>> 0;

for (const raw of readFileSync(pos[0], "latin1").split("\n")) {
  const f = raw.trim().split(/\s+/);
  if (!f[0] || f[0].startsWith("#")) continue;
  if (!started) {
    if (f[0] in set) {
      set[f[0]] = Number(f[1]) >>> 0;
      if (f[0] === "frame" && set.frame === 0) set.frame = 16;
      continue;
    }
    ex.port_set_seed(set.seed);
    ex.port_set_smoothing(set.smoothing);
    soundBuf = ex.port_alloc(ex.port_sound_cmds_max() * 16);
    const pp = copyIn(pack);
    const gp = copyIn(gam);
    print(`start seed=${set.seed} clock=${set.clock} smoothing=${set.smoothing} quirks=0x${set.quirks.toString(16)}`);
    if (ex.port_init(pp, pack.length, gp, gam.length, set.clock, set.quirks) !== 0) {
      print("error port_init failed");
      break;
    }
    drain();
    started = true;
    nextFrame = set.frame;
  }
  if (f[0] === "in") {
    const t = Number(f[1]);
    framesBefore(t);
    ex.port_input(Number(f[2]), Number(f[3]) | 0, Number(f[4]) | 0, t >>> 0);
  } else if (f[0] === "check") {
    const t = Number(f[1]);
    framesBefore(t);
    advance(t);
    const hash = createHash("sha256").update(new Uint8Array(mem.buffer, ex.port_frame_ptr(), 800 * 572 * 4)).digest("hex");
    print(
      `check ${t} ${f[2] ?? "-"} ticks=${P(6)} renders=${P(5)} frame=${hash} heap_in_use=${P(14)} heap_top=${P(15)} ` +
        `fault=${P(7)} applet=${P(1)} screen=${P(2)} paused=${P(8)} dialog=${P(11)} ` +
        `playscreen=${P(13).toString(16)} lives=${P(10)} logs=${nLogs} now=${ex.port_now() >>> 0} wasm_mem=${mem.buffer.byteLength}`,
    );
  }
}
print("end");
process.stdout.write(out.join("\n") + "\n");
