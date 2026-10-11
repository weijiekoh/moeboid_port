// Replay a moeboid-input v1 recording on moeboid-trace.wasm (the browser build with the trace) and
// print the lockstep rows (tick, ms, calls, call hash, state hash) to stdout. Helper of
// port/tests/py/test_engine_lockstep.py; same input path as enginedrv.NativeEngine.replay.
// Usage: node wasm_replay.mjs WASM PACK GAM RECORDING MS
import fs from "node:fs";

const [wasmPath, packPath, gamPath, recPath, msArg] = process.argv.slice(2);
const msEnd = Number(msArg);
const KEY_VK = { 0: 0x08, 1: 0x2e, 2: 0x09, 3: 0x0d, 5: 0x11, 6: 0x25, 7: 0x27, 8: 0x26, 9: 0x28, 10: 0x24, 11: 0x23, 12: 0x10 };
let ex;
let buf = "";
const rows = [];
const dec = new TextDecoder("utf-8");
const imports = {
  env: {
    host_log: (p, n) => process.stderr.write(`[log] ${dec.decode(new Uint8Array(ex.memory.buffer, p, n))}\n`),
    host_trace: (p, n) => {
      buf += dec.decode(new Uint8Array(ex.memory.buffer, p, n));
      let i;
      while ((i = buf.indexOf("\n")) >= 0) {
        const line = buf.slice(0, i);
        buf = buf.slice(i + 1);
        if (/^[0-9]/.test(line)) rows.push(line);
      }
    },
  },
};
const { instance } = await WebAssembly.instantiate(fs.readFileSync(wasmPath), imports);
ex = instance.exports;
const copyIn = (bytes) => {
  const p = ex.port_alloc(bytes.length + 1);
  const m = new Uint8Array(ex.memory.buffer, p, bytes.length + 1);
  m.set(bytes);
  m[bytes.length] = 0;
  return p;
};
const cstr = (s) => copyIn(Buffer.from(s, "latin1"));
const rec = fs.readFileSync(recPath, "latin1").split("\n");
for (const ln of rec) {
  if (ln.startsWith("# setting\t")) {
    const [, k, v] = ln.split("\t");
    ex.port_test_storage_set(cstr(`game/{2BFDD7F8-0EC4-4E7C-9FF4-3B2F8DC1D0F2}/${k}`), cstr(v));
  }
}
ex.port_set_seed(12345);
const pack = fs.readFileSync(packPath), gam = fs.readFileSync(gamPath);
const rc = ex.port_test_init(copyIn(pack), pack.length, copyIn(gam), gam.length, 12345, 1);
if (rc !== 0) throw new Error(`port_test_init ${rc}`);
const all = rec.filter((l) => l && !l.startsWith("#") && !l.startsWith("ms\t")).map((l) => l.split("\t"));
for (const ev of all) if (ev[2] === "dialog") ex.port_test_answer(cstr(ev[3])); // run.py: all answers first
const events = all.filter((ev) => ev[2] !== "dialog");
const xy = ex.port_alloc(8);
let i = 0;
while (i < events.length && Number(events[i][0]) <= msEnd) {
  const ms = Number(events[i][0]);
  ex.port_test_goto(ms);
  const now = ex.port_now(); // every event up to this clock value belongs to this step
  while (i < events.length && Number(events[i][0]) <= now && Number(events[i][0]) <= msEnd) {
    const [, , kind, value] = events[i];
    if (kind === "keydown" || kind === "keyup") ex.port_test_input(kind === "keydown" ? 1 : 2, KEY_VK[Number(value)], 0);
    else if (kind === "vk") {
      ex.port_test_input(1, Number(value), 0);
      ex.port_test_input(2, Number(value), 0);
    } else if (kind === "click") {
      if (!ex.port_test_button_point(cstr(value), xy)) throw new Error(`no button ${value} at ${ms}`);
      const [x, y] = new Int32Array(ex.memory.buffer, xy, 2);
      ex.port_test_input(3, x, y);
      ex.port_test_input(4, x, y);
      ex.port_test_input(5, x, y);
    } else if (kind === "event") ex.port_test_applet_event(Number(value) === 16 ? 1 : 0);
    i++;
  }
  ex.port_test_finish_step();
}
ex.port_test_run_through(msEnd);
ex.port_test_stop();
process.stdout.write(rows.join("\n") + "\n");
