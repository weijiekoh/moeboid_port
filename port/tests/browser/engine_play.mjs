// M4 browser check: the engine runs Moeboid.gam in the page. Run (after port/build.sh all):
//   tools/bin/web-test port/tests/browser/engine_play.mjs
// 1. Click-to-start, then the title screen (game screen kind 1) appears in the canvas: title image in
//    the game area at (282, 50) (after the shell splash, if the shell shows one). Screenshot:
//    port/tests/results/m4_title.png.
// 2. A mouse click on the "Start" button (frame (562, 254)) starts the intro; the play screen (kind 2)
//    follows after about 3 s. Before that the title keydown listener gets "INVINCIBLE" (typed letters,
//    event 0xb with virtual keys; G:0x100043f0 sets the cheat flag), so the player cannot die.
// 3. Keyboard play: held arrow keys move the player (x and y from guest memory through port_probe);
//    Escape toggles the timer pause. Screenshot: port/tests/results/m4_play.png.
// The wasm exports are taken from WebAssembly.instantiate by an init script (the host is unchanged).
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const RESULTS = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "../results");

export default async function ({ page, baseURL, assert, log }) {
  await page.addInitScript(() => {
    const orig = WebAssembly.instantiate;
    WebAssembly.instantiate = async (...a) => {
      const r = await orig.apply(WebAssembly, a);
      window.__moeboid = r.instance ?? r;
      return r;
    };
  });
  const resp = await page.goto(`${baseURL}/index.html`);
  assert.equal(resp.status(), 200);
  await page.waitForFunction(() => !document.getElementById("start").disabled, null, { timeout: 20000 });
  await page.click("#start");
  const probe = (what) => page.evaluate((w) => window.__moeboid.exports.port_probe(w), what);
  await page.waitForFunction(() => window.__moeboid && window.__moeboid.exports.port_probe(2) === 1 &&
                             window.__moeboid.exports.port_probe(5) >= 1, null, { timeout: 15000 });
  // The shell (M5) may show its splash first: wait until the title image is in the canvas.
  await page.waitForFunction(() => {
    const c = document.getElementById("screen").getContext("2d");
    const eq = (x, y, rgb) => c.getImageData(x, y, 1, 1).data.slice(0, 3).every((v, i) => v === rgb[i]);
    return eq(300, 465, [102, 204, 255]) && eq(700, 300, [102, 204, 255]);
  }, null, { timeout: 15000, polling: 100 });
  await page.waitForTimeout(300);
  const canvas = await page.$("#screen");
  const box = await canvas.boundingBox();
  const scale = box.width / 800;
  log(`canvas at ${box.x},${box.y} size ${box.width}x${box.height} (scale ${scale})`);
  const pixels = (pts) => page.evaluate((p) => {
    const c = document.getElementById("screen").getContext("2d");
    return p.map(([x, y]) => Array.from(c.getImageData(x, y, 1, 1).data.slice(0, 3)));
  }, pts);
  fs.mkdirSync(RESULTS, { recursive: true });
  await canvas.screenshot({ path: path.join(RESULTS, "m4_title.png") });
  // static pixels of IMG-TITLESCREEN (bubbles) and of the "Start" label (black, Arial 24 bold)
  const title = await pixels([[300, 465], [700, 300], [540, 260]]);
  log("title pixels", JSON.stringify(title));
  assert.deepEqual(title[0], [102, 204, 255]);
  assert.deepEqual(title[1], [102, 204, 255]);
  const gameArea = await page.evaluate(() => {
    const d = document.getElementById("screen").getContext("2d").getImageData(282, 50, 500, 420).data;
    let black = 0;
    for (let i = 0; i < d.length; i += 4) if (d[i] === 0 && d[i + 1] === 0 && d[i + 2] === 0) black++;
    return black;
  });
  log(`black pixels in the game area: ${gameArea} of 210000`);
  assert.ok(gameArea < 21000, "title image drawn into the game surface");
  assert.equal(await probe(7), 0, "no guest fault");

  // typed letters reach the game as key events (event 0xb): the INVINCIBLE cheat (G:0x100043f0)
  await canvas.focus();
  for (const ch of "INVINCIBLE") await page.keyboard.press(`Key${ch}`);
  await page.waitForTimeout(100);
  assert.equal(await probe(9), 1, "INVINCIBLE cheat flag set by typed key events");
  // Start button (child of ctx[2] at (250, 190), Arial 24 bold "Start"): click its centre
  await page.mouse.move(box.x + 562 * scale, box.y + 254 * scale);
  await page.waitForTimeout(100);
  await page.mouse.down();
  await page.mouse.up();
  await page.waitForFunction(() => window.__moeboid.exports.port_probe(2) === 2, null, { timeout: 8000 });
  await page.waitForTimeout(300);
  const f32 = async (what) => {
    const v = await probe(what);
    const b = new DataView(new ArrayBuffer(4));
    b.setUint32(0, v >>> 0, true);
    return b.getFloat32(0, true);
  };
  const x0 = await f32(3), y0 = await f32(4);
  await page.keyboard.down("ArrowRight");
  await page.waitForTimeout(700);
  await page.keyboard.up("ArrowRight");
  const x1 = await f32(3);
  await page.keyboard.down("ArrowDown");
  await page.waitForTimeout(700);
  await page.keyboard.up("ArrowDown");
  const y1 = await f32(4);
  const x1b = await f32(3); /* the right velocity stays during ArrowDown */
  await page.keyboard.down("ArrowLeft");
  await page.waitForTimeout(900);
  await page.keyboard.up("ArrowLeft");
  const x2 = await f32(3);
  log(`player x ${x0.toFixed(1)} -> ${x1.toFixed(1)} -> ${x1b.toFixed(1)} -> ${x2.toFixed(1)}; ` +
      `y ${y0.toFixed(1)} -> ${y1.toFixed(1)}`);
  assert.ok(x1 > x0 + 10, "ArrowRight moves the player right");
  assert.ok(y1 > y0 + 10, "ArrowDown moves the player down");
  assert.ok(x2 < x1b - 10, "ArrowLeft moves the player left");
  await canvas.screenshot({ path: path.join(RESULTS, "m4_play.png") });
  // Escape: pause toggle of a running game (Z:0x4040e0, Z:0x41cb30)
  assert.equal(await probe(8), 0);
  await page.keyboard.press("Escape");
  await page.waitForTimeout(150);
  assert.equal(await probe(8), 1, "Escape pauses");
  const xp = await f32(3);
  await page.keyboard.down("ArrowRight");
  await page.waitForTimeout(400);
  await page.keyboard.up("ArrowRight");
  assert.equal(await f32(3), xp, "no movement while paused");
  await page.keyboard.press("Escape");
  await page.waitForTimeout(150);
  assert.equal(await probe(8), 0, "Escape resumes");
  assert.equal(await probe(7), 0, "no guest fault");
  log(`renders ${await probe(5)}, ticks ${await probe(6)}, lives ${await probe(10)}`);
}
