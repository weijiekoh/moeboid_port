// M7 local run: the page as served by port/run.sh (host/serve.py), not by the web-test server.
// The script starts `port/run.sh 0` (kernel-chosen port on 127.0.0.1) inside the same network namespace,
// reads the printed URL, and checks: HTTP headers (Content-Security-Policy, nosniff), the CSP meta tag,
// start without a click, the splash, the title frame in the canvas, a game start with the keyboard and mouse,
// no guest fault, no page error. Works with Chromium (default) and Firefox (WEB_TEST_BROWSER=firefox,
// run.mjs). Run: tools/bin/web-test --timeout 120 port/tests/browser/run_sh.mjs
import { spawn } from "node:child_process";
import { resolve, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const PORT_DIR = resolve(dirname(fileURLToPath(import.meta.url)), "../..");

function startServer(log) {
  return new Promise((ok, fail) => {
    const p = spawn("bash", [`${PORT_DIR}/run.sh`, "0"], { stdio: ["ignore", "pipe", "pipe"] });
    let buf = "";
    const timer = setTimeout(() => fail(new Error(`run.sh printed no URL: ${buf}`)), 60000);
    const onData = (d) => {
      buf += d.toString();
      const m = buf.match(/http:\/\/127\.0\.0\.1:(\d+)\//);
      if (m) {
        clearTimeout(timer);
        log(`run.sh output: ${buf.trim().split("\n").join(" | ")}`);
        ok({ proc: p, url: m[0] });
      }
    };
    p.stdout.on("data", onData);
    p.stderr.on("data", (d) => (buf += d.toString()));
    p.on("exit", (code) => fail(new Error(`run.sh exited (${code}): ${buf}`)));
  });
}

export default async function ({ page, browser, assert, log }) {
  const { proc, url } = await startServer(log);
  try {
    log(`browser ${browser.browserType().name()} ${browser.version()}; page ${url}`);
    // The page starts the port without a click; the host logs its settings just before port_init.
    const started = page.waitForEvent("console", { predicate: (m) => m.text().startsWith("moeboid: settings:"), timeout: 30000 });
    const resp = await page.goto(url);
    assert.equal(resp.status(), 200);
    const h = await resp.allHeaders();
    log(`CSP header: ${h["content-security-policy"]}`);
    assert.match(h["content-security-policy"] ?? "", /^default-src 'none'; script-src 'self' 'wasm-unsafe-eval';/);
    assert.match(h["content-security-policy"] ?? "", /connect-src 'self'/);
    assert.equal(h["x-content-type-options"], "nosniff");
    const meta = await page.getAttribute('meta[http-equiv="Content-Security-Policy"]', "content");
    assert.match(meta ?? "", /^default-src 'none';/);
    await started;
    const px = (x, y) =>
      page.evaluate(([x, y]) => Array.from(document.getElementById("screen").getContext("2d").getImageData(x, y, 1, 1).data).slice(0, 3), [x, y]);
    await page.waitForTimeout(700);
    const splash = await px(10, 10);
    log(`splash corner ${splash}`);
    assert.deepEqual(splash, [0, 0, 0], "black canvas around the splash");
    await page.waitForFunction(() => {
      const c = document.getElementById("screen").getContext("2d");
      const eq = (x, y, rgb) => Array.from(c.getImageData(x, y, 1, 1).data.slice(0, 3)).every((v, i) => v === rgb[i]);
      return eq(300, 465, [102, 204, 255]) && eq(300, 25, [255, 204, 0]) && eq(300, 530, [51, 51, 204]);
    }, null, { timeout: 20000, polling: 100 });
    log("title frame shown (game area, title strip, blank ad area)");
    // Start the game with a click on "Start" (frame (557, 252)); the play screen fills the game area
    const box = await (await page.$("#screen")).boundingBox();
    const s = box.width / 800;
    await page.mouse.move(box.x + 557 * s, box.y + 252 * s);
    await page.mouse.down();
    await page.mouse.up();
    await page.waitForTimeout(4500);
    await page.keyboard.down("ArrowRight");
    await page.waitForTimeout(500);
    await page.keyboard.up("ArrowRight");
    const changed = await page.evaluate(() => {
      const d = document.getElementById("screen").getContext("2d").getImageData(282, 50, 500, 420).data;
      let black = 0;
      for (let i = 0; i < d.length; i += 4) if (d[i] === 0 && d[i + 1] === 0 && d[i + 2] === 0) black++;
      return black;
    });
    log(`black pixels in the game area during play: ${changed}`);
    assert.ok(changed > 1000, "play screen (black playfield border) shown");
  } finally {
    proc.kill("SIGTERM");
  }
}
