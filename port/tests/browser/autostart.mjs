// Page start without a start screen (user request after M7; decisions 2, 4b, 10, 13).
// 1. The page has no start button and no settings form; the port starts at page load, with no click.
// 2. Fixed settings: console line "moeboid: settings: clock 0, smoothing 1, quirks 0xffffffff", also
//    when localStorage holds settings of the removed form ("moeboid.settings.v1", non-default values).
//    Standard smoothing: grey edge pixels in the title's "Start" label (Arial 24 bold, gasp allows grey).
// 3. Audio: before the first user gesture a suspended AudioContext starts no sound; a mouse press in
//    the page makes the context run. Headless browsers may allow audio at once: the test logs the state.
// Run: tools/bin/web-test --timeout 120 port/tests/browser/autostart.mjs
const OLD_KEY = "moeboid.settings.v1";

export default async function ({ page, baseURL, outDir, assert, log }) {
  const infos = [];
  page.on("console", (m) => {
    if (m.text().startsWith("moeboid: settings:")) infos.push(m.text());
  });
  await page.addInitScript((key) => {
    try {
      localStorage.setItem(key, JSON.stringify({ clock: 2, smoothing: 0, quirksOff: 1 }));
    } catch {
      // storage blocked: the stale-settings case is not tested
    }
    const orig = WebAssembly.instantiate;
    WebAssembly.instantiate = async (...a) => {
      const r = await orig.apply(WebAssembly, a);
      window.__moeboid = r.instance ?? r;
      return r;
    };
    // Every AudioContext and every source start, with the context state at the call.
    window.__audio = { ctxs: [], starts: [] };
    const OrigCtx = window.AudioContext;
    window.AudioContext = class extends OrigCtx {
      constructor(...a) {
        super(...a);
        window.__audio.ctxs.push(this);
      }
    };
    const origStart = AudioBufferSourceNode.prototype.start;
    AudioBufferSourceNode.prototype.start = function (...a) {
      window.__audio.starts.push(this.context.state);
      return origStart.apply(this, a);
    };
  }, OLD_KEY);

  await page.goto(`${baseURL}/index.html`);
  // 1. no start screen
  for (const sel of ["#start", "#panel", "#settings"]) assert.equal(await page.$(sel), null, `no ${sel} element`);
  await page.waitForFunction(() => window.__moeboid && window.__moeboid.exports.port_probe(5) >= 1, null, { timeout: 20000 });
  log("port started without a click");

  // 2. fixed settings, stale stored settings ignored
  assert.equal(await page.evaluate((k) => localStorage.getItem(k), OLD_KEY) !== null, true, "stale settings stored");
  assert.deepEqual(infos, ["moeboid: settings: clock 0, smoothing 1, quirks 0xffffffff"]);
  await page.waitForFunction(() => {
    const c = document.getElementById("screen").getContext("2d");
    const eq = (x, y, rgb) => c.getImageData(x, y, 1, 1).data.slice(0, 3).every((v, i) => v === rgb[i]);
    return eq(300, 465, [102, 204, 255]) && eq(700, 300, [102, 204, 255]);
  }, null, { timeout: 15000, polling: 100 });
  await page.waitForTimeout(300);
  const colours = await page.evaluate(() => {
    const d = document.getElementById("screen").getContext("2d").getImageData(535, 240, 58, 31).data;
    const set = new Set();
    for (let i = 0; i < d.length; i += 4) set.add((d[i] << 16) | (d[i + 1] << 8) | d[i + 2]);
    return set.size;
  });
  log(`Start label colours: ${colours}`);
  assert.ok(colours > 4, "grey edge pixels (Standard smoothing)");
  const nows = [];
  for (let i = 0; i < 6; i++) {
    nows.push(await page.evaluate(() => window.__moeboid.exports.port_now() >>> 0));
    await page.waitForTimeout(23);
  }
  log("port_now samples:", nows.join(" "));
  const onGrid = (v) => Math.floor(Math.round(v / 15.625) * 15.625) === v;
  assert.ok(!nows.every(onGrid), "1 ms clock model (GetTickCount not on the 15.625 ms grid)");

  // 3. audio before and after the first gesture
  const before = await page.evaluate(() => ({
    n: window.__audio.ctxs.length,
    state: window.__audio.ctxs[0]?.state,
    starts: window.__audio.starts.slice(),
  }));
  log(`before a gesture: ${before.n} AudioContext, state ${before.state}, source starts ${JSON.stringify(before.starts)}`);
  assert.equal(before.n, 1, "one AudioContext");
  assert.ok(before.starts.every((s) => s === "running"), "no sound started on a suspended context");
  const box = await (await page.$("#screen")).boundingBox();
  await page.mouse.click(box.x + 100 * (box.width / 800), box.y + 300 * (box.height / 572));
  await page.waitForFunction(() => window.__audio.ctxs[0].state === "running", null, { timeout: 5000, polling: 50 });
  log("after a mouse press: AudioContext running");
  assert.equal(await page.evaluate(() => window.__moeboid.exports.port_probe(7)), 0, "no guest fault");
  await page.screenshot({ path: `${outDir}/autostart.png` });
}
