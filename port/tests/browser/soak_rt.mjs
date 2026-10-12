// M7 real-time soak in the real page: the browser's own requestAnimationFrame, real DOM input from
// Playwright (keyboard and mouse, seeded random sequence of the same kinds as the native soak), for
// SECONDS of wall time (default 600). Samples every 60 s: guest fault flag, engine log lines, game
// ticks and renders, wasm memory size and (Chromium) the JS heap. Asserts: no guest fault, every
// engine log line is an original-engine diagnostic (soak.mjs ALLOWED), the game clock advances, the
// wasm memory and the JS heap stay bounded. Output: <outDir>/soak_rt.json.
// Run: tools/bin/web-test --timeout 900 port/tests/browser/soak_rt.mjs [SECONDS [SEED]]
import { writeFileSync } from "node:fs";
import { join } from "node:path";
import { instrument } from "./pagedrv.mjs";
import { ALLOWED } from "./soak.mjs";

// Frame points as port/tests/accept/scenarios.py TARGETS (weights there).
const TARGETS = [
  [557, 252, 3], [233, 175, 1], [233, 242, 1], [233, 310, 1], [740, 450, 2], [718, 22, 1], [120, 531, 1],
  [95, 164, 1], [95, 199, 1], [95, 234, 1], [333, 111, 3], [676, 308, 1], [350, 314, 2], [400, 300, 1],
  [360, 330, 1], [440, 330, 1],
];

function mulberry32(a) {
  return () => {
    a = (a + 0x6d2b79f5) >>> 0;
    let t = a;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

export default async function ({ page, baseURL, outDir, args, assert, log }) {
  const seconds = Number(args[0] ?? 600);
  const rnd = mulberry32(Number(args[1] ?? 20261011));
  const ri = (lo, hi) => lo + Math.floor(rnd() * (hi - lo + 1));
  await instrument(page, 12345, false);
  await page.goto(`${baseURL}/index.html`);
  await page.waitForFunction(() => window.__drv && window.__drv.ex !== null, null, { timeout: 20000 });
  await page.waitForTimeout(3000);
  const box = await (await page.$("#screen")).boundingBox();
  const sc = box.width / 800;
  const at = (x, y) => [box.x + x * sc, box.y + y * sc];
  const sample = () =>
    page.evaluate(() => {
      const ex = window.__drv.ex;
      return {
        fault: ex.port_probe(7),
        ticks: ex.port_probe(6),
        renders: ex.port_probe(5),
        screen: ex.port_probe(2),
        now: ex.port_now() >>> 0,
        wasm_mem: ex.memory.buffer.byteLength,
        heap_in_use: ex.port_probe(14) >>> 0,
        js_heap: performance.memory ? performance.memory.usedJSHeapSize : null,
        logs: window.__drv.logs.length,
        sounds: window.__drv.sounds.length,
      };
    });
  const samples = [{ t: 0, ...(await sample()) }];
  const t0 = Date.now();
  let next = 60;
  let actions = 0;
  const totalWeight = TARGETS.reduce((a, t) => a + t[2], 0);
  while ((Date.now() - t0) / 1000 < seconds) {
    const r = rnd();
    if (r < 0.3) {
      const k = ["ArrowLeft", "ArrowUp", "ArrowRight", "ArrowDown"][ri(0, 3)];
      await page.keyboard.down(k);
      await page.waitForTimeout(ri(50, 1500));
      await page.keyboard.up(k);
    } else if (r < 0.38) {
      await page.keyboard.press(["Space", "KeyY", "KeyN"][ri(0, 2)]);
    } else if (r < 0.45) {
      await page.keyboard.press("Enter");
    } else if (r < 0.47) {
      await page.keyboard.press("Escape");
    } else if (r < 0.55) {
      for (let i = ri(1, 15); i > 0; i--) await page.keyboard.press(`Key${String.fromCharCode(65 + ri(0, 25))}`);
    } else if (r < 0.57) {
      await page.keyboard.press(["Backspace", "Tab"][ri(0, 1)]);
    } else if (r < 0.69) {
      let w = rnd() * totalWeight;
      let tg = TARGETS[0];
      for (const t of TARGETS) {
        if ((w -= t[2]) < 0) {
          tg = t;
          break;
        }
      }
      await page.mouse.click(...at(tg[0] + ri(-3, 3), tg[1] + ri(-3, 3)));
    } else if (r < 0.79) {
      await page.mouse.click(...at(ri(0, 799), ri(0, 571)));
    } else if (r < 0.87) {
      for (let i = ri(1, 5); i > 0; i--) await page.mouse.move(...at(ri(0, 799), ri(0, 571)));
    } else if (r < 0.89) {
      await page.mouse.click(...at(ri(0, 799), ri(0, 571)), { button: "right" });
    } else if (r < 0.91) {
      await page.mouse.move(...at(400, 300));
      await page.mouse.wheel(0, [120, -120, 240, -360][ri(0, 3)]);
    }
    actions++;
    await page.waitForTimeout(ri(50, 600));
    const el = (Date.now() - t0) / 1000;
    if (el >= next) {
      const s = { t: Math.round(el), ...(await sample()) };
      samples.push(s);
      log(`${s.t} s: ticks ${s.ticks}, renders ${s.renders}, screen ${s.screen}, fault ${s.fault}, logs ${s.logs}, ` +
          `wasm ${(s.wasm_mem / 1048576).toFixed(1)} MiB, JS heap ${s.js_heap === null ? "-" : (s.js_heap / 1048576).toFixed(1) + " MiB"}`);
      next += 60;
    }
  }
  const last = { t: Math.round((Date.now() - t0) / 1000), ...(await sample()) };
  samples.push(last);
  const logs = await page.evaluate(() => window.__drv.logs);
  const bad = logs.filter((l) => !ALLOWED.some((a) => l.startsWith(a)));
  writeFileSync(join(outDir, "soak_rt.json"), JSON.stringify({ seconds, actions, samples, logs }, null, 1));
  log(`${actions} input actions in ${last.t} s; clock ${last.now} ms; ${last.sounds} sound commands; ${logs.length} log lines`);
  assert.ok(samples.every((s) => s.fault === 0), "no guest fault");
  assert.deepEqual(bad, [], "no engine error");
  assert.ok(last.now >= seconds * 1000 * 0.9, "the virtual clock follows the wall clock");
  const mem0 = samples[1]?.wasm_mem ?? samples[0].wasm_mem;
  assert.ok(last.wasm_mem <= mem0 + 16 * 1048576, "wasm memory bounded (at most 16 MiB growth after the first minute)");
  if (last.js_heap !== null) {
    const js = samples.filter((s) => s.js_heap !== null).map((s) => s.js_heap);
    assert.ok(last.js_heap <= Math.max(2 * js[1 < js.length ? 1 : 0], 64 * 1048576), "JS heap bounded");
  }
}
