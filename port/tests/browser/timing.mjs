// M7 timing check in the real page (verification.md 4.4; timing.md 5 and 9). For each clock model
// (0: 1 ms, 1: 15.625 ms, 2: 54.925 ms) and each frame rate (30, 60, 144 Hz, fake requestAnimationFrame
// timestamps, pagedrv.mjs) the page runs the timing scenario of port/tests/accept/scenarios.py: title,
// typed INVINCIBLE, Start, then 60 s of play without input (virtual time 10 s .. 70 s).
// Result per run: game ticks (engine-to-game calls; only the 20 ms game timer calls the game here) and
// engine renders in the 60 s window, the checkpoint states and frame hashes, the drained sound commands.
// The test asserts that the three frame rates give identical results per clock model and that the
// canvas equals the frame buffer; port/tests/accept/verify.py compares the results with the native
// reference (accept_drv) and the timing.md 5 rates.
// Run: tools/bin/web-test --timeout 300 port/tests/browser/timing.mjs [SCENARIO_DIR]
//   SCENARIO_DIR (default port/build/accept) holds timing0.scn, timing1.scn, timing2.scn.
// Output: <outDir>/timing.json.
import { writeFileSync } from "node:fs";
import { join, resolve, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { parseScenario, instrument, start, drive, canvasMatchesFrame, collected } from "./pagedrv.mjs";

const PORT_DIR = resolve(dirname(fileURLToPath(import.meta.url)), "../..");
const RATES = [30, 60, 144];

export default async function ({ context, baseURL, outDir, args, assert, log }) {
  const dir = resolve(args[0] ?? join(PORT_DIR, "build/accept"));
  const result = { runs: [] };
  for (const clock of [0, 1, 2]) {
    const { set, cmds } = parseScenario(join(dir, `timing${clock}.scn`));
    assert.equal(set.clock, clock);
    let first = null;
    for (const rate of RATES) {
      const page = await context.newPage();
      await instrument(page, set.seed);
      const B = await start(page, `${baseURL}/index.html?clock=${clock}`);
      const t0 = Date.now();
      const checks = await drive(page, cmds, rate);
      const wall = (Date.now() - t0) / 1000;
      const canvasDiff = await canvasMatchesFrame(page);
      const { sounds, hostInputs, logs } = await collected(page);
      await page.close();
      const c0 = checks[0];
      const c1 = checks[checks.length - 1];
      const run = {
        clock,
        rate,
        startT: B,
        wall_s: wall,
        window_ms: c1.t - c0.t,
        ticks: c1.ticks - c0.ticks,
        renders: c1.renders - c0.renders,
        checks,
        sounds,
        hostInputs,
        logs,
        canvasDiff,
      };
      result.runs.push(run);
      log(
        `clock ${clock} rate ${rate} Hz: ${run.ticks} ticks, ${run.renders} renders in ${run.window_ms} ms ` +
          `(screen ${c1.screen}, fault ${c1.fault}); ${sounds.length} sound commands; wall ${wall.toFixed(1)} s`,
      );
      assert.equal(hostInputs.length, 0, "no host input besides the page start (the test sends every input)");
      assert.equal(canvasDiff, 0, "canvas equals the frame buffer");
      assert.equal(c1.fault, 0, "no guest fault");
      assert.equal(c0.screen, 2, "play screen at 10 s");
      if (!first) first = run;
      else {
        assert.equal(run.ticks, first.ticks, `clock ${clock}: ticks at ${rate} Hz equal ${RATES[0]} Hz`);
        assert.equal(run.renders, first.renders, `clock ${clock}: renders at ${rate} Hz equal ${RATES[0]} Hz`);
        assert.deepEqual(
          run.checks.map((c) => [c.t, c.ticks, c.renders, c.frame]),
          first.checks.map((c) => [c.t, c.ticks, c.renders, c.frame]),
          `clock ${clock}: checkpoints and frame hashes at ${rate} Hz equal ${RATES[0]} Hz`,
        );
        assert.deepEqual(run.sounds, first.sounds, `clock ${clock}: sound commands at ${rate} Hz equal ${RATES[0]} Hz`);
      }
    }
  }
  writeFileSync(join(outDir, "timing.json"), JSON.stringify(result, null, 1));
}
