// M7 soak in the real page: the first MINUTES (default 10) of the random soak recording of
// port/tests/accept/scenarios.py (fixed seed) at a fake 60 Hz frame clock (pagedrv.mjs). Records per
// minute the probes, the frame hash and the wasm memory size. Asserts: no guest fault, every engine log
// line is an original-engine diagnostic (ALLOWED), no host input besides the page start, canvas equals
// the frame buffer. port/tests/accept/verify.py compares the checkpoints with the native run.
// Run: tools/bin/web-test --timeout 600 port/tests/browser/soak.mjs [SCENARIO_DIR [MINUTES]]
//   SCENARIO_DIR (default port/build/accept) holds soak.scn. Output: <outDir>/soak.json.
import { writeFileSync } from "node:fs";
import { join, resolve, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { parseScenario, instrument, start, drive, canvasMatchesFrame, collected } from "./pagedrv.mjs";

const PORT_DIR = resolve(dirname(fileURLToPath(import.meta.url)), "../..");
// Log lines that copy the original engine's Error() debug output (OutputDebugStringA, not shown to the
// user; ZapSpot.exe strings at Z:0x434938, Z:0x435d88, Z:0x4348ac, Z:0x4348f0, Z:0x434a4c).
export const ALLOWED = [
  "engine: Error - unrecognized child surface passed to CSurface::DetachSurface",
  "engine: Error - unrecognized EventListener",
  "engine: Invalid current key passed to protected surface",
  "engine: Invalid Image",
];

export default async function ({ context, baseURL, outDir, args, assert, log }) {
  const dir = resolve(args[0] ?? join(PORT_DIR, "build/accept"));
  const minutes = Number(args[1] ?? 10);
  const { set, cmds } = parseScenario(join(dir, "soak.scn"));
  const end = minutes * 60000;
  const mine = cmds.filter((c) => c[1] <= end);
  const page = await context.newPage();
  await instrument(page, set.seed);
  const B = await start(page, `${baseURL}/index.html?clock=${set.clock}`);
  const checks = [];
  const t0 = Date.now();
  // one evaluate per minute of virtual time (progress in the log)
  for (let m = 1; m <= minutes; m++) {
    const part = mine.filter((c) => c[1] > (m - 1) * 60000 && c[1] <= m * 60000);
    const r = await drive(page, part, 60);
    checks.push(...r);
    const c = r[r.length - 1];
    if (c) log(`minute ${m}: ticks ${c.ticks}, renders ${c.renders}, screen ${c.screen}, fault ${c.fault}, ` +
               `logs ${c.logs}, wasm memory ${(c.wasm_mem / 1048576).toFixed(1)} MiB, heap in use ${(c.heap_in_use / 1048576).toFixed(1)} MiB`);
  }
  const wall = (Date.now() - t0) / 1000;
  const canvasDiff = await canvasMatchesFrame(page);
  const { sounds, hostInputs, logs } = await collected(page);
  await page.close();
  const bad = logs.filter((l) => !ALLOWED.some((a) => l.startsWith(a)));
  writeFileSync(join(outDir, "soak.json"),
                JSON.stringify({ minutes, startT: B, wall_s: wall, checks, sounds, hostInputs, logs, canvasDiff }, null, 1));
  log(`${minutes} min of virtual time in ${wall.toFixed(1)} s; ${sounds.length} sound commands; ${logs.length} log lines ` +
      `(${bad.length} not allowed)`);
  assert.equal(checks.length, minutes, "one checkpoint per minute");
  assert.ok(checks.every((c) => c.fault === 0), "no guest fault");
  assert.deepEqual(bad, [], "no engine error");
  assert.equal(hostInputs.length, 0, "no host input besides the page start");
  assert.equal(canvasDiff, 0, "canvas equals the frame buffer");
}
