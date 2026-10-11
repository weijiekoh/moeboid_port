// Negative check of the network guard of tools/bin/web-test. This run MUST FAIL (exit 1) and
// list two NETWORK VIOLATION lines (example.com fetch, example.org image). Run:
//   tools/bin/web-test --root port/tests/browser/fixtures port/tests/browser/guard_check.mjs
export default async function ({ page, baseURL, log }) {
  // A 404 page of the test server has no CSP, so the requests reach the network layer.
  await page.goto(`${baseURL}/no-csp-404`);
  const r = await page.evaluate(async () => {
    const img = new Image();
    img.src = "https://example.org/guard.png";
    try { await fetch("http://example.com/guard"); return "fetch resolved"; } catch (e) { return "fetch rejected: " + e; }
  });
  log(r);
  await page.waitForTimeout(300);
}
