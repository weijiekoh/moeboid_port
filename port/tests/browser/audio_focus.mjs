// M6 test (c): focus loss sends port_input kind 6 and mutes audio; focus gain sends kind 7 and
// unmutes (decision 12, timing.md 9 rule 6). Run:
//   tools/bin/web-test port/tests/browser/audio_focus.mjs
// attachInput (host/input.ts) with a recording sink and onActive = player.setActive, as in
// main.ts. An OfflineAudioContext (32 kHz) plays a ramp (every sample distinct); at suspend
// points the test dispatches blur, focus and visibilitychange (visibilityState and hasFocus
// overridden). Checks: one event per state change; output 0 while muted (from the event time
// + LATENCY_S, the same time line as the sounds); after unmute the ramp continues at the
// position it would have reached (sources keep running); a GLOBALFOCUS sound is not muted.
export default async function ({ page, baseURL, assert, log }) {
  await page.route("**/m6-blank.html", (r) =>
    r.fulfill({ contentType: "text/html", body: "<!doctype html><title>m6</title><canvas id=c width=800 height=572></canvas>" }));
  await page.goto(`${baseURL}/m6-blank.html`);
  const r = await page.evaluate(async () => {
    const A = await import("/audio.js");
    const I = await import("/input.js");
    const SR = 32000;
    let vis = "visible";
    let focus = true;
    Object.defineProperty(document, "visibilityState", { configurable: true, get: () => vis });
    document.hasFocus = () => focus;

    const run = async (withGlobal) => {
      const off = new OfflineAudioContext(1, SR, SR);
      const pl = A.createPlayer(off);
      const ramp = off.createBuffer(1, SR * 0.9, SR);
      const d = ramp.getChannelData(0);
      for (let i = 0; i < d.length; i++) d[i] = (i + 1) / 65536;
      pl.setSound(1, ramp, 0);
      if (withGlobal) {
        const dc = off.createBuffer(1, SR * 0.9, SR);
        dc.getChannelData(0).fill(0.5);
        pl.setSound(2, dc, A.SND_F_GLOBALFOCUS);
      }
      const events = [];
      const canvas = document.createElement("canvas");
      document.body.append(canvas);
      I.attachInput(canvas, 800, 572, (k, a, b) => events.push([k, a, b]), (on) => pl.setActive(on));
      const muted = [];
      const at = (t, fn) =>
        off.suspend(t + 1e-9).then(() => {
          fn();
          muted.push([t, pl.muted]);
          void off.resume();
        });
      at(0, () => {
        const w = new Uint32Array([A.SND_OP_PLAY, 1, 0, 0, ...(withGlobal ? [A.SND_OP_PLAY, 2, 1, 0] : [])]);
        pl.commands(w, w.length / 4, 0);
      });
      at(0.2, () => window.dispatchEvent(new FocusEvent("blur")));
      at(0.3, () => window.dispatchEvent(new FocusEvent("focus")));
      at(0.4, () => {
        vis = "hidden";
        document.dispatchEvent(new Event("visibilitychange"));
      });
      at(0.44, () => {
        focus = false;
        window.dispatchEvent(new FocusEvent("blur")); // already inactive: no second event
      });
      at(0.5, () => {
        vis = "visible";
        focus = true;
        document.dispatchEvent(new Event("visibilitychange"));
      });
      at(0.52, () => window.dispatchEvent(new FocusEvent("focus"))); // already active
      const out = Array.from((await off.startRendering()).getChannelData(0));
      canvas.remove();
      // Copies: the listeners of this run stay on window and see the events of the next run.
      return { events: events.slice(), muted: muted.slice(), out };
    };
    return { sr: SR, latency: A.LATENCY_S, a: await run(false), b: await run(true) };
  });

  const L = Math.round(r.latency * r.sr);
  const S = (s) => Math.round(s * r.sr);
  const start = L; // ramp starts at 0 + latency
  const mutes = [[S(0.2) + L, S(0.3) + L], [S(0.4) + L, S(0.5) + L]];
  const rampAt = (i) => (i >= start && i < start + S(0.9) ? (i - start + 1) / 65536 : 0);
  const check = (run, extra, name) => {
    let bad = 0;
    let first = -1;
    for (let i = 0; i < run.out.length; i++) {
      const inMute = mutes.some(([a, b]) => i >= a && i < b);
      if (mutes.some(([a, b]) => Math.abs(i - a) <= 1 || Math.abs(i - b) <= 1)) continue; // boundary sample
      const g = i >= start && i < start + S(0.9) ? extra : 0;
      const want = (inMute ? 0 : rampAt(i)) + g;
      if (Math.abs(run.out[i] - want) > 1e-6) {
        bad++;
        if (first < 0) first = i;
      }
    }
    log(`${name}: ${run.out.length} samples, ${bad} differ${first >= 0 ? ` (first at ${first}: ${run.out[first]})` : ""}`);
    assert.equal(bad, 0, `${name} output`);
  };

  const ev = [[6, 0, 0], [7, 0, 0], [6, 0, 0], [7, 0, 0]];
  assert.deepEqual(r.a.events, ev, "focus events: lost, gained, lost (hidden), gained (visible); no repeats");
  assert.deepEqual(r.a.muted.map((m) => m[1]), [false, true, false, true, true, false, false], "player muted flag");
  log(`events ${JSON.stringify(r.a.events)}; muted ${JSON.stringify(r.a.muted)}`);
  log(`mute windows (samples at ${r.sr} Hz): ${JSON.stringify(mutes)} = event time + ${r.latency * 1000} ms`);
  check(r.a, 0, "ramp: silent while muted, continues at the running position after unmute");
  // Spot values: just after unmute the ramp is at the position of a source that kept running.
  const u = mutes[0][1] + 10;
  assert.equal(r.a.out[u], (u - start + 1) / 65536, "source kept running while muted");
  assert.equal(r.a.out[mutes[0][0] + 10], 0, "muted");
  assert.deepEqual(r.b.events, ev);
  check(r.b, 0.5, "GLOBALFOCUS sound (CloseShell) stays audible while muted");
}
