// Page driver for the M7 acceptance browser tests (timing.mjs, soak.mjs). Not a test script itself.
//
// The real page (port/build/web/index.html, unchanged host code) runs with two init scripts:
// - a fake requestAnimationFrame: the test calls the page's frame callback with chosen timestamps, so
//   the host's port_advance sees an exact 30, 60 or 144 Hz frame clock (and no real frame runs);
// - a wrapper around WebAssembly.instantiate: the host gets a copy of the exports in which
//   port_set_seed uses the scenario seed, port_input records every host input (the click-to-start time
//   is the scenario time 0), port_sound_cmds records every sound command the host drains, and
//   env.host_log is counted.
// Scenario inputs go straight to port_input (time stamp = click time + scenario ms) before the first
// frame at or after their time: the host frame rule of port/tests/native/accept_drv.c.
import { readFileSync } from "node:fs";

export function parseScenario(path) {
  const set = { seed: 1, clock: 0, smoothing: 1, quirks: 0xffffffff, frame: 16 };
  const cmds = [];
  for (const raw of readFileSync(path, "latin1").split("\n")) {
    const f = raw.trim().split(/\s+/);
    if (!f[0] || f[0].startsWith("#")) continue;
    if (f[0] in set) set[f[0]] = Number(f[1]) >>> 0;
    else if (f[0] === "in") cmds.push(["in", Number(f[1]), Number(f[2]), Number(f[3]) | 0, Number(f[4]) | 0]);
    else if (f[0] === "check") cmds.push(["check", Number(f[1]), f[2] ?? "-"]);
  }
  return { set, cmds };
}

// Install the init scripts. Call once per page before the first navigation. fakeRaf false keeps the
// browser's own requestAnimationFrame (real-time runs).
export async function instrument(page, seed, fakeRaf = true) {
  await page.addInitScript(({ seedValue, fake }) => {
    const queue = [];
    window.__rafQueue = queue;
    if (fake) {
      window.requestAnimationFrame = (cb) => {
        queue.push(cb);
        return queue.length;
      };
      window.cancelAnimationFrame = () => {};
    }
    const orig = WebAssembly.instantiate;
    WebAssembly.instantiate = async (mod, imports) => {
      const D = (window.__drv = { startT: null, hostInputs: [], sounds: [], logs: [], ex: null, frameIndex: 1 });
      const env = { ...(imports?.env ?? {}) };
      const hostLog = env.host_log;
      env.host_log = (p, n) => {
        try {
          D.logs.push(new TextDecoder("latin1").decode(new Uint8Array(D.ex.memory.buffer, p, n)));
        } catch {
          D.logs.push("?");
        }
        if (hostLog) hostLog(p, n);
      };
      const r = await orig.call(WebAssembly, mod, { ...imports, env });
      const inst = r.instance ?? r;
      const ex = inst.exports;
      D.ex = ex;
      const wrapped = Object.create(null);
      for (const k of Object.keys(ex)) wrapped[k] = ex[k];
      wrapped.port_set_seed = () => ex.port_set_seed(seedValue);
      wrapped.port_input = (kind, a, b, t) => {
        if ((kind & 0xff) === 8 && D.startT === null) D.startT = t >>> 0;
        else D.hostInputs.push([kind, a, b, t]);
        return ex.port_input(kind, a, b, t);
      };
      wrapped.port_sound_cmds = (out) => {
        const n = ex.port_sound_cmds(out);
        if (out) {
          const w = new Uint32Array(ex.memory.buffer, out, n * 4);
          for (let i = 0; i < n; i++) D.sounds.push([w[i * 4], w[i * 4 + 1], w[i * 4 + 2], w[i * 4 + 3]]);
        }
        return n;
      };
      return r.instance ? { module: r.module, instance: { exports: wrapped } } : { exports: wrapped };
    };
  }, { seedValue: seed, fake: fakeRaf });
}

// Open the page, click "Click to start", wait until the host runs (first frame requested).
export async function start(page, url) {
  const resp = await page.goto(url);
  if (resp.status() !== 200) throw new Error(`${url}: HTTP ${resp.status()}`);
  // interval polling: the default polling uses requestAnimationFrame, which the fake one replaces
  await page.waitForFunction(() => !document.getElementById("start").disabled, null, { timeout: 20000, polling: 50 });
  await page.click("#start");
  await page.waitForFunction(
    () => window.__drv && window.__drv.startT !== null && (window.__rafQueue.length > 0 || window.__drv.ex !== null),
    null,
    { timeout: 20000, polling: 50 },
  );
  return page.evaluate(() => window.__drv.startT);
}

// Run scenario commands (kind 8 is the real click and is skipped) with frames at k * 1000 / rate ms.
// Returns one record per check: probes as in accept_drv.c, SHA-256 of the frame buffer, wasm memory.
export async function drive(page, cmds, rate) {
  return page.evaluate(
    async ({ cmds, rate }) => {
      const D = window.__drv;
      const ex = D.ex;
      const B = D.startT;
      const frameT = (k) => (k * 1000) / rate;
      const runFrame = (vt) => {
        const cbs = window.__rafQueue.splice(0);
        for (const cb of cbs) cb(B + vt);
      };
      const hex = (buf) => Array.from(new Uint8Array(buf), (b) => b.toString(16).padStart(2, "0")).join("");
      const P = (w) => ex.port_probe(w) >>> 0;
      const out = [];
      let i = D.frameIndex;
      for (const c of cmds) {
        const t = c[1];
        while (frameT(i) < t) runFrame(frameT(i++));
        if (c[0] === "in") {
          if ((c[2] & 0xff) !== 8) ex.port_input(c[2], c[3], c[4], (B + t) >>> 0);
          continue;
        }
        if (frameT(i) === t) runFrame(frameT(i++));
        else runFrame(t);
        const fb = new Uint8Array(ex.memory.buffer, ex.port_frame_ptr(), 800 * 572 * 4).slice();
        const hash = hex(await crypto.subtle.digest("SHA-256", fb));
        out.push({
          t,
          label: c[2],
          ticks: P(6),
          renders: P(5),
          frame: hash,
          fault: P(7),
          applet: P(1),
          screen: P(2),
          paused: P(8),
          dialog: P(11),
          playscreen: P(13).toString(16),
          lives: P(10),
          logs: D.logs.length,
          now: ex.port_now() >>> 0,
          heap_in_use: P(14),
          heap_top: P(15),
          wasm_mem: ex.memory.buffer.byteLength,
        });
      }
      D.frameIndex = i;
      return out;
    },
    { cmds, rate },
  );
}

// Canvas pixels equal to the frame buffer (the host copies the frame on every changed frame).
export async function canvasMatchesFrame(page) {
  return page.evaluate(() => {
    const ex = window.__drv.ex;
    const fb = new Uint8Array(ex.memory.buffer, ex.port_frame_ptr(), 800 * 572 * 4);
    const c = document.getElementById("screen").getContext("2d").getImageData(0, 0, 800, 572).data;
    let diff = 0;
    for (let i = 0; i < c.length; i++) if (c[i] !== fb[i]) diff++;
    return diff;
  });
}

export async function collected(page) {
  return page.evaluate(() => ({
    sounds: window.__drv.sounds,
    hostInputs: window.__drv.hostInputs,
    logs: window.__drv.logs,
  }));
}
