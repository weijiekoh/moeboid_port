// M7 settings of the click-to-start page (decisions 2, 4b, 10; host/settings.ts).
// 1. Defaults: clock 1 ms (radio 0), font smoothing Standard, every engine quirk on; the page states
//    the current settings and the reload rule; nothing in localStorage yet.
// 2. A change is saved at once (localStorage "moeboid.settings.v1"), the page says "reload to apply",
//    and the current-settings line does not change before the reload.
// 3. After the reload the new settings are current, and port_init gets them: console line
//    "moeboid: settings: clock 1, smoothing 0, quirks 0xfffffffe"; the GetTickCount model moves in
//    15.625 ms steps; the title text has no grey pixels (Start label, Arial 24 bold: grey only with
//    smoothing, gasp allows grey at 24 px).
// 4. Back to the defaults: grey text in the Start label again.
// Run: tools/bin/web-test --timeout 120 port/tests/browser/settings.mjs
const KEY = "moeboid.settings.v1";

async function titleShown(page) {
  await page.waitForFunction(() => {
    const c = document.getElementById("screen").getContext("2d");
    const eq = (x, y, rgb) => c.getImageData(x, y, 1, 1).data.slice(0, 3).every((v, i) => v === rgb[i]);
    return eq(300, 465, [102, 204, 255]) && eq(700, 300, [102, 204, 255]);
  }, null, { timeout: 15000, polling: 100 });
  await page.waitForTimeout(300);
}

// Colours in the "Start" label box (frame (535..592, 240..270)): text black, background light blue.
async function labelColours(page) {
  return page.evaluate(() => {
    const d = document.getElementById("screen").getContext("2d").getImageData(535, 240, 58, 31).data;
    const set = new Set();
    for (let i = 0; i < d.length; i += 4) set.add((d[i] << 16) | (d[i + 1] << 8) | d[i + 2]);
    return [...set];
  });
}

export default async function ({ page, baseURL, outDir, assert, log }) {
  const infos = [];
  page.on("console", (m) => {
    if (m.text().startsWith("moeboid: settings:")) infos.push(m.text());
  });
  await page.addInitScript(() => {
    const orig = WebAssembly.instantiate;
    WebAssembly.instantiate = async (...a) => {
      const r = await orig.apply(WebAssembly, a);
      window.__moeboid = r.instance ?? r;
      return r;
    };
  });
  await page.goto(`${baseURL}/index.html`);
  await page.waitForFunction(() => !document.getElementById("start").disabled, null, { timeout: 20000 });
  const current = () => page.textContent("#settings-current");
  const cur0 = await current();
  log("current:", cur0);
  assert.match(cur0, /Clock 1 ms, 50 Hz; font smoothing Standard; engine quirks: detach redraw on\./);
  assert.match(await page.textContent("#settings"), /A change takes effect after a page reload\./);
  assert.equal(await page.evaluate((k) => localStorage.getItem(k), KEY), null);
  await page.click("#settings-details summary");
  assert.equal(await page.isChecked('input[name="clock"][value="0"]'), true);
  assert.equal(await page.isChecked('input[name="smoothing"][value="1"]'), true);
  assert.equal(await page.isChecked('input[name="quirk"][value="1"]'), true);
  const labels = await page.$$eval("#settings label", (ls) => ls.map((l) => l.textContent.trim()));
  log("options:", JSON.stringify(labels));
  assert.ok(labels.some((l) => l.startsWith("Windows 2000-like: 1 ms clock step, 50 Hz game ticks (default)")));
  assert.ok(labels.some((l) => l.startsWith("Windows XP-like: 15.625 ms clock step, 32 Hz")));
  assert.ok(labels.some((l) => l.startsWith("Windows 98-like: 54.925 ms clock step, 18.2 Hz")));

  // defaults in effect: grey text in the Start label
  await page.click("#start");
  await titleShown(page);
  const grey = await labelColours(page);
  log(`Start label colours with Standard smoothing: ${grey.length}`);
  assert.equal(infos.at(-1), "moeboid: settings: clock 0, smoothing 1, quirks 0xffffffff");
  assert.ok(grey.length > 4, "grey edge pixels with Standard smoothing");

  // change: saved at once, applies after the reload
  await page.goto(`${baseURL}/index.html`);
  await page.waitForFunction(() => !document.getElementById("start").disabled, null, { timeout: 20000 });
  await page.click("#settings-details summary");
  await page.check('input[name="clock"][value="1"]');
  await page.check('input[name="smoothing"][value="0"]');
  await page.uncheck('input[name="quirk"][value="1"]');
  const stored = JSON.parse(await page.evaluate((k) => localStorage.getItem(k), KEY));
  log("stored:", JSON.stringify(stored));
  assert.deepEqual(stored, { clock: 1, smoothing: 0, quirksOff: 1 });
  assert.match(await page.textContent("#settings-note"), /Reload the page to apply the new settings\./);
  assert.equal(await current(), cur0, "current settings unchanged before the reload");
  await page.reload();
  await page.waitForFunction(() => !document.getElementById("start").disabled, null, { timeout: 20000 });
  const cur1 = await current();
  log("current after reload:", cur1);
  assert.match(cur1, /Clock 15\.625 ms, 32 Hz; font smoothing Off; engine quirks: detach redraw off\./);
  await page.click("#start");
  await titleShown(page);
  assert.equal(infos.at(-1), "moeboid: settings: clock 1, smoothing 0, quirks 0xfffffffe");
  const nows = [];
  for (let i = 0; i < 8; i++) {
    nows.push(await page.evaluate(() => window.__moeboid.exports.port_now() >>> 0));
    await page.waitForTimeout(37);
  }
  log("port_now samples (15.625 ms model):", nows.join(" "));
  assert.ok(nows.every((v) => Math.floor(Math.round(v / 15.625) * 15.625) === v), "GetTickCount on the 15.625 ms grid");
  const mono = await labelColours(page);
  log(`Start label colours with smoothing off: ${mono.length} (${mono.map((c) => c.toString(16)).join(" ")})`);
  assert.ok(mono.length <= 4 && mono.length < grey.length, "no grey edge pixels with smoothing off");
  assert.equal(await page.evaluate(() => window.__moeboid.exports.port_probe(7)), 0, "no guest fault");

  // back to the defaults
  await page.goto(`${baseURL}/index.html`);
  await page.waitForFunction(() => !document.getElementById("start").disabled, null, { timeout: 20000 });
  await page.click("#settings-details summary");
  await page.check('input[name="clock"][value="0"]');
  await page.check('input[name="smoothing"][value="1"]');
  await page.check('input[name="quirk"][value="1"]');
  assert.deepEqual(JSON.parse(await page.evaluate((k) => localStorage.getItem(k), KEY)), { clock: 0, smoothing: 1, quirksOff: 0 });
  await page.reload();
  await page.waitForFunction(() => !document.getElementById("start").disabled, null, { timeout: 20000 });
  assert.equal(await current(), cur0);
  await page.click("#settings-details summary");
  await page.screenshot({ path: `${outDir}/start_page.png` });
}
