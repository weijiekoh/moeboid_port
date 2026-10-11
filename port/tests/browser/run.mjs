// Test runner for tools/bin/web-test (runs inside tools/bin/nonet). Do not call directly.
// Starts a static server on 127.0.0.1, launches headless Chromium through playwright-core,
// records every request and console message, runs the test script, writes report.json.
import http from "node:http";
import fs from "node:fs";
import path from "node:path";
import assert from "node:assert/strict";
import { fileURLToPath, pathToFileURL } from "node:url";
import { chromium } from "playwright-core";

const HERE = path.dirname(fileURLToPath(import.meta.url));
const PORT_DIR = path.resolve(HERE, "../..");

const MIME = {
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".mjs": "text/javascript; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".json": "application/json",
  ".wasm": "application/wasm",
  ".png": "image/png",
  ".gif": "image/gif",
  ".svg": "image/svg+xml",
  ".ico": "image/x-icon",
  ".txt": "text/plain; charset=utf-8",
  ".map": "application/json",
};

function usage(msg) {
  console.error(`web-test: ${msg}\nusage: web-test [--root DIR] [--out DIR] [--timeout SEC] SCRIPT.mjs [ARGS...]`);
  process.exit(2);
}

function parseArgs(argv) {
  const o = { root: path.join(PORT_DIR, "build/web"), out: null, timeout: 60, script: null, args: [] };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (o.script) o.args.push(a);
    else if (a === "--root") o.root = argv[++i];
    else if (a === "--out") o.out = argv[++i];
    else if (a === "--timeout") o.timeout = Number(argv[++i]);
    else if (a.startsWith("--")) usage(`unknown option ${a}`);
    else o.script = a;
  }
  if (!o.script) usage("no script");
  o.root = path.resolve(o.root);
  o.script = path.resolve(o.script);
  o.out = path.resolve(o.out ?? path.join(PORT_DIR, "build/browser-tests", path.basename(o.script, ".mjs")));
  if (!fs.statSync(o.root, { throwIfNoEntry: false })?.isDirectory()) usage(`root is not a directory: ${o.root}`);
  return o;
}

function startServer(root, served) {
  const server = http.createServer((req, res) => {
    const url = new URL(req.url, "http://127.0.0.1");
    let rel = decodeURIComponent(url.pathname);
    if (rel.endsWith("/")) rel += "index.html";
    const file = path.resolve(root, "." + rel);
    let status = 200;
    if (file !== root && !file.startsWith(root + path.sep)) status = 403;
    else if (!fs.statSync(file, { throwIfNoEntry: false })?.isFile()) status = 404;
    served.push({ method: req.method, path: url.pathname, status });
    if (status !== 200) {
      res.writeHead(status, { "Content-Type": "text/plain" });
      res.end(String(status));
      return;
    }
    res.writeHead(200, {
      "Content-Type": MIME[path.extname(file).toLowerCase()] ?? "application/octet-stream",
      "Cache-Control": "no-store",
    });
    fs.createReadStream(file).pipe(res);
  });
  return new Promise((resolve, reject) => {
    server.once("error", reject);
    server.listen(0, "127.0.0.1", () => resolve(server));
  });
}

function hostAllowed(u) {
  // Requests that leave the browser must go to 127.0.0.1. data:, blob: and about: stay inside.
  if (["data:", "blob:", "about:"].includes(u.protocol)) return true;
  return u.hostname === "127.0.0.1";
}

const opt = parseArgs(process.argv.slice(2));
fs.mkdirSync(opt.out, { recursive: true });
const report = {
  script: opt.script, root: opt.root, baseURL: null, chromium: null, ok: false, error: null,
  violations: [], pageErrors: [], console: [], requests: [], served: [],
};
const t0 = Date.now();
const stamp = () => Date.now() - t0;
function violation(url, kind) {
  if (!report.violations.some((v) => v.url === url && v.kind === kind)) report.violations.push({ t: stamp(), url, kind });
}

let server, browser;
try {
  server = await startServer(opt.root, report.served);
  report.baseURL = `http://127.0.0.1:${server.address().port}`;

  const extra = (process.env.WEB_TEST_ARGS ?? "").split(/\s+/).filter(Boolean);
  browser = await chromium.launch({
    executablePath: process.env.WEB_TEST_CHROMIUM ?? "/usr/bin/chromium",
    headless: true,
    chromiumSandbox: process.env.WEB_TEST_NO_SANDBOX !== "1",
    args: ["--disable-gpu", "--no-proxy-server", "--disable-component-update", ...extra],
  });
  report.chromium = browser.version();
  const context = await browser.newContext({
    viewport: { width: 1024, height: 768 }, deviceScaleFactor: 1, serviceWorkers: "block",
  });

  await context.route("**/*", (route) => {
    const u = new URL(route.request().url());
    if (hostAllowed(u)) return route.continue();
    violation(u.href, "request");
    return route.abort("blockedbyclient");
  });
  context.on("request", (r) => {
    const u = new URL(r.url());
    if (!hostAllowed(u)) violation(u.href, "request");
    report.requests.push({ t: stamp(), method: r.method(), url: r.url(), type: r.resourceType() });
  });
  context.on("response", (r) => {
    const e = report.requests.findLast((q) => q.url === r.url() && q.status === undefined);
    if (e) { e.status = r.status(); e.contentType = r.headers()["content-type"]; }
  });
  context.on("requestfailed", (r) => {
    const e = report.requests.findLast((q) => q.url === r.url() && q.failure === undefined);
    if (e) e.failure = r.failure()?.errorText ?? "failed";
  });

  const page = await context.newPage();
  page.on("console", (m) => {
    const l = m.location();
    report.console.push({ t: stamp(), type: m.type(), text: m.text(), url: l.url, line: l.lineNumber });
  });
  page.on("pageerror", (e) => report.pageErrors.push({ t: stamp(), message: String(e?.stack ?? e) }));
  page.on("websocket", (ws) => {
    const u = new URL(ws.url());
    if (u.hostname !== "127.0.0.1") violation(u.href, "websocket");
  });

  const mod = await import(pathToFileURL(opt.script).href);
  if (typeof mod.default !== "function") throw new Error("script has no default export function");
  const log = (...a) => console.log("[test]", ...a);
  let timer;
  await Promise.race([
    mod.default({ page, context, browser, baseURL: report.baseURL, root: opt.root, outDir: opt.out,
                  args: opt.args, assert, log }),
    new Promise((_, rej) => { timer = setTimeout(() => rej(new Error(`timeout after ${opt.timeout} s`)), opt.timeout * 1000); }),
  ]).finally(() => clearTimeout(timer));
  report.ok = true;
} catch (e) {
  report.error = String(e?.stack ?? e);
} finally {
  if (browser) await browser.close().catch(() => {});
  if (server) await new Promise((r) => server.close(r));
}

if (report.violations.length) report.ok = false;
if (report.pageErrors.length) report.ok = false;
fs.writeFileSync(path.join(opt.out, "report.json"), JSON.stringify(report, null, 2));

for (const c of report.console) console.log(`console.${c.type}: ${c.text}`);
for (const e of report.pageErrors) console.log(`PAGE ERROR: ${e.message}`);
for (const v of report.violations) console.log(`NETWORK VIOLATION (${v.kind}): ${v.url}`);
if (report.error) console.log(`ERROR: ${report.error}`);
const hosts = [...new Set(report.requests.map((r) => new URL(r.url).host || new URL(r.url).protocol))];
console.log(`chromium ${report.chromium}; ${report.requests.length} requests (hosts: ${hosts.join(", ") || "none"}); ` +
            `${report.console.length} console messages; report ${path.join(opt.out, "report.json")}`);
console.log(report.ok ? "PASS" : "FAIL");
process.exit(report.ok ? 0 : 1);
