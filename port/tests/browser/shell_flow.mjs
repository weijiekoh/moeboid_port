// Shell flow in the real page (M5b): click-to-start, splash, title frame, How To Play, a page change
// (About), a game with New Game and the "Warning: Game in Progress" dialog, the original cursors.
// Run (after port/build.sh wasm host pack):
//   tools/bin/web-test --timeout 120 port/tests/browser/shell_flow.mjs
// Screenshots: port/tests/results/shell/browser_*.png (canvas area, 1:1 at the 1024x768 viewport).
import { mkdirSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const RESULTS = join(dirname(fileURLToPath(import.meta.url)), "../results/shell");

export default async function ({ page, baseURL, assert, log }) {
  mkdirSync(RESULTS, { recursive: true });
  await page.goto(`${baseURL}/index.html`);
  await page.waitForFunction(() => {
    const b = document.getElementById("start");
    return b && !b.disabled;
  });
  const rect = await page.evaluate(() => {
    const r = document.getElementById("screen").getBoundingClientRect();
    return { x: r.x, y: r.y, w: r.width, h: r.height };
  });
  log("canvas", JSON.stringify(rect));
  assert.equal(rect.w, 800, "canvas shown at scale 1 in a 1024x768 viewport");
  const px = (x, y) =>
    page.evaluate(
      ([x, y]) => Array.from(document.getElementById("screen").getContext("2d").getImageData(x, y, 1, 1).data).slice(0, 3),
      [x, y],
    );
  const hex = (p) => p.map((v) => v.toString(16).padStart(2, "0")).join("");
  const shot = (name) =>
    page.screenshot({ path: join(RESULTS, `browser_${name}.png`), clip: { x: rect.x, y: rect.y, width: 800, height: 572 } });
  const click = async (x, y) => {
    await page.mouse.move(rect.x + x, rect.y + y);
    await page.waitForTimeout(80);
    await page.mouse.down();
    await page.waitForTimeout(80);
    await page.mouse.up();
  };
  const away = async () => {
    await click(100, 300);
    await page.waitForTimeout(300);
  };

  // click-to-start, then the splash (decision 13): black canvas, IMG-SPLASH at the centre
  await page.click("#start");
  await page.waitForTimeout(800);
  const sp = [await px(10, 10), await px(220, 200), await px(500, 260)];
  log("splash pixels", sp.map(hex).join(" "));
  assert.equal(hex(sp[0]), "000000", "canvas black around the splash");
  assert.notEqual(hex(sp[1]), "000000", "splash bitmap shown");
  await shot("splash");

  // title frame after about 2 s of virtual time
  await page.waitForTimeout(2500);
  const t = [await px(300, 530), await px(300, 25), await px(100, 470)];
  log("title pixels", t.map(hex).join(" "));
  assert.equal(hex(t[0]), "3333cc", "ad area = frame colour (decision 9)");
  assert.equal(hex(t[1]), "ffcc00", "title strip");
  assert.equal(hex(t[2]), "3333cc", "subscribe box removed");
  await shot("title");

  // cursors: HAND.CUR over a button (port_cursor 1), POINTER.CUR elsewhere (0)
  await page.mouse.move(rect.x + 718, rect.y + 22);
  await page.waitForTimeout(300);
  const hand = await page.evaluate(() => document.getElementById("screen").style.cursor);
  await page.mouse.move(rect.x + 100, rect.y + 330);
  await page.waitForTimeout(300);
  const pointer = await page.evaluate(() => document.getElementById("screen").style.cursor);
  log("cursor over help:", hand.slice(0, 40), "...", hand.slice(-20));
  assert.ok(hand.startsWith('url("data:image/png;base64,') && hand.includes(" 12 6"), "hand cursor, hotspot (12, 6)");
  assert.ok(pointer.startsWith('url("data:image/png;base64,') && pointer.includes(" 13 7"), "pointer, hotspot (13, 7)");

  // How To Play (rail): page with the game's help, paused
  await click(233, 310);
  await page.waitForTimeout(800);
  await away();
  const h = [await px(300, 100), await px(300, 25)];
  assert.equal(hex(h[0]), "000000", "page surface shown");
  await shot("how_to_play");

  // a page change: About
  await click(95, 234);
  await page.waitForTimeout(800);
  await away();
  await shot("about");

  // back to the game (footer arrow), Start, then New Game during the game
  await click(740, 450);
  await page.waitForTimeout(800);
  await click(557, 252);
  await page.waitForTimeout(6000);
  await away();
  await shot("game");
  await click(233, 175);
  await page.waitForTimeout(800);
  const d = await px(300, 300);
  log("dialog face", hex(d));
  assert.equal(hex(d), "ece9d8", "IDD_QUIT_SAVED face colour (Luna COLOR_3DFACE, decision O1)");
  await shot("quit_dialog");
  // Yes (2002): the game stops and a new game starts at the title screen
  await click(350, 314);
  await page.waitForTimeout(2500);
  await away();
  const n = await px(300, 25);
  assert.equal(hex(n), "ffcc00", "title strip after New Game");
  await shot("new_game");
}
