// Smoke test of the browser test setup. Run:
//   tools/bin/web-test --root port/tests/browser/fixtures port/tests/browser/smoke.mjs
// Checks: page loads from 127.0.0.1, canvas pixels read back exactly, .wasm served as
// application/wasm (instantiateStreaming needs it), screenshot pixels equal canvas pixels.
export default async function ({ page, baseURL, outDir, assert, log }) {
  const resp = await page.goto(`${baseURL}/index.html`);
  assert.equal(resp.status(), 200);
  await page.waitForFunction(() => window.fixtureDone === true);

  const px = await page.evaluate(() => {
    const c = document.getElementById("c").getContext("2d");
    return [Array.from(c.getImageData(100, 100, 1, 1).data), Array.from(c.getImageData(5, 7, 1, 1).data)];
  });
  log("canvas getImageData (100,100) =", px[0].join(","), "; (5,7) =", px[1].join(","));
  assert.deepEqual(px[0], [0x33, 0x33, 0xcc, 0xff]);
  assert.deepEqual(px[1], [0xec, 0xe9, 0xd8, 0xff]);

  assert.equal(await page.evaluate(() => window.wasmResult), 5, "wasm add(2,3) via instantiateStreaming");

  // Screenshot (what the compositor shows). The canvas is at (0,0), device scale factor 1.
  // Decode the PNG in the page with createImageBitmap (no PNG decoder package in node).
  const png = await page.screenshot({ path: `${outDir}/smoke.png`, clip: { x: 0, y: 0, width: 16, height: 16 } });
  const shot = await page.evaluate(async (b64) => {
    const bytes = Uint8Array.from(atob(b64), (ch) => ch.charCodeAt(0));
    const bmp = await createImageBitmap(new Blob([bytes], { type: "image/png" }));
    const oc = new OffscreenCanvas(bmp.width, bmp.height);
    const g = oc.getContext("2d", { willReadFrequently: true });
    g.drawImage(bmp, 0, 0);
    return [Array.from(g.getImageData(10, 10, 1, 1).data), Array.from(g.getImageData(5, 7, 1, 1).data)];
  }, png.toString("base64"));
  log("screenshot (10,10) =", shot[0].join(","), "; (5,7) =", shot[1].join(","));
  assert.deepEqual(shot[0], [0x33, 0x33, 0xcc, 0xff]);
  assert.deepEqual(shot[1], [0xec, 0xe9, 0xd8, 0xff]);
}
