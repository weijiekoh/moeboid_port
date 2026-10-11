// M6 test (b): sound scheduling keeps the tick spacing. Run:
//   tools/bin/web-test port/tests/browser/audio_sched.mjs
// An OfflineAudioContext (32 kHz) is suspended at each fake host frame; the frame drains a fake
// command stream (game ticks every 20 ms, two sounds in every third tick, frames 16 ms apart
// with 48 ms and 120 ms gaps) into createPlayer().commands(words, n, now_ms). Checks:
// 1. every scheduled start time (AudioBufferSourceNode.start argument) minus at_ms / 1000 is
//    the same constant for every command younger than LATENCY_S (spacing exact across frames);
//    older commands (only in the 120 ms gap) start at the frame time;
// 2. the rendered output has its impulses at exactly 32 samples per ms of at_ms spacing;
// 3. startTime() with u32 wrap of the clock;
// 4. STOP of one voice and of all voices.
export default async function ({ page, baseURL, assert, log }) {
  await page.route("**/m6-blank.html", (r) =>
    r.fulfill({ contentType: "text/html", body: "<!doctype html><title>m6</title><canvas id=c></canvas>" }));
  await page.goto(`${baseURL}/m6-blank.html`);
  const r = await page.evaluate(async () => {
    const A = await import("/audio.js");
    const SR = 32000;
    const BASE = 1000; // clock ms at audio time 0
    const starts = [];
    const origStart = AudioBufferSourceNode.prototype.start;
    AudioBufferSourceNode.prototype.start = function (when, ...rest) {
      starts.push({ when, ctx: this.context.currentTime });
      return origStart.call(this, when, ...rest);
    };

    // Host frames (clock ms after port_advance): 16 ms apart, a 48 ms gap, a 120 ms gap.
    const frames = [];
    for (let f = BASE + 16; f <= BASE + 400; f += 16) frames.push(f);
    for (let f = BASE + 448; f <= BASE + 640; f += 16) frames.push(f);
    for (let f = BASE + 760; f <= BASE + 1000; f += 16) frames.push(f);
    // Game ticks every 20 ms from clock 1003: sound 1; every third tick also sound 2 (same tick).
    const cmds = [];
    for (let at = BASE + 3, i = 0; at <= BASE + 1000; at += 20, i++) {
      cmds.push([1, 1, i % 16, at]);
      if (i % 3 === 0) cmds.push([1, 2, (i + 1) % 16, at]);
    }

    const off = new OfflineAudioContext(1, SR * 1.2, SR);
    const pl = A.createPlayer(off);
    const imp = (v) => {
      const b = off.createBuffer(1, 1, SR);
      b.getChannelData(0)[0] = v;
      return b;
    };
    pl.setSound(1, imp(0.25), 0);
    pl.setSound(2, imp(0.5), 0);
    const plan = [];
    let prev = -Infinity;
    for (const now of frames) {
      const batch = cmds.filter((c) => c[3] > prev && c[3] <= now);
      prev = now;
      const words = new Uint32Array(batch.flat());
      // Suspend times: frame time plus 1 ns, so the floor to a 128-frame boundary is exact.
      off.suspend((now - BASE) / 1000 + 1e-9).then(() => {
        plan.push({ now, t: off.currentTime, n: batch.length, ats: batch.map((c) => c[3]) });
        pl.commands(words, batch.length, now);
        void off.resume();
      });
    }
    const out = (await off.startRendering()).getChannelData(0);
    AudioBufferSourceNode.prototype.start = origStart;
    const onsets = [];
    for (let i = 0; i < out.length; i++) if (out[i] !== 0) onsets.push([i, out[i]]);

    // STOP: a 0.5 s DC sound on voice 4 and voice 5; STOP voice 4 at 100 ms, STOP all at 200 ms.
    const off2 = new OfflineAudioContext(1, SR / 2, SR);
    const p2 = A.createPlayer(off2);
    const dc = off2.createBuffer(1, SR / 2, SR);
    dc.getChannelData(0).fill(0.25);
    p2.setSound(3, dc, 0);
    const step = (t, words) =>
      off2.suspend(t + 1e-9).then(() => {
        p2.commands(new Uint32Array(words), words.length / 4, Math.round(t * 1000));
        void off2.resume();
      });
    step(0, [A.SND_OP_PLAY, 3, 4, 0, A.SND_OP_PLAY, 3, 5, 0]);
    step(0.1, [A.SND_OP_STOP, 0, 4, 100]);
    step(0.2, [A.SND_OP_STOP, 0, A.SND_VOICE_ALL, 200]);
    const o2 = (await off2.startRendering()).getChannelData(0);
    const level = (ms) => o2[Math.round((ms * SR) / 1000)];

    return {
      sr: SR, base: BASE, latency: A.LATENCY_S, plan, starts, onsets,
      wrap: [A.startTime(1, 0xfffffff0, 5), A.startTime(1, 5, 0xfffffff0), A.startTime(2, 0, 100), A.startTime(2, 100, 100)],
      stop: [10, 140, 149, 160, 260, 400].map((ms) => [ms, level(ms)]),
    };
  });

  const L = r.latency;
  log(`LATENCY_S = ${L}; ${r.plan.length} frames, ${r.starts.length} start() calls, ${r.onsets.length} rendered impulses`);
  // Order of start() calls = order of commands in the plan.
  const ats = r.plan.flatMap((p) => p.ats.map((at) => ({ at, now: p.now, t: p.t })));
  assert.equal(r.starts.length, ats.length);
  let exact = 0;
  let clamped = 0;
  const K = -(r.base / 1000) + L; // when = at / 1000 + K for every command younger than L
  for (let i = 0; i < ats.length; i++) {
    const { at, now, t } = ats[i];
    const w = r.starts[i].when;
    if (now - at <= L * 1000) {
      assert.ok(Math.abs(w - (at / 1000 + K)) < 1e-9, `at ${at} now ${now}: when ${w} != ${at / 1000 + K}`);
      exact++;
    } else {
      assert.equal(w, t, `at ${at} now ${now}: older than the latency, starts at the frame time`);
      clamped++;
    }
  }
  log(`start times: ${exact} commands at at_ms/1000 + ${K.toFixed(3)} s (exact spacing over all frames), ${clamped} older than ${L * 1000} ms clamped to the frame time`);
  assert.ok(clamped > 0 && clamped <= 6, "clamped commands only in the 120 ms gap");

  // Rendered output: impulse i at sample 32 * (at - BASE + 50) for the exact ones.
  const byIndex = new Map(r.onsets.map(([i, v]) => [i, v]));
  let found = 0;
  let maxDev = 0;
  for (let i = 0; i < ats.length; i++) {
    const { at, now } = ats[i];
    if (now - at > L * 1000) continue;
    const want = Math.round((at - r.base) * (r.sr / 1000) + L * r.sr);
    const near = [want - 1, want, want + 1].filter((k) => byIndex.has(k));
    assert.ok(near.length > 0, `no impulse near sample ${want} (at ${at})`);
    const got = near.reduce((a, k) => (byIndex.get(k) > byIndex.get(a) ? k : a), near[0]);
    maxDev = Math.max(maxDev, Math.abs(got - want));
    found++;
  }
  // Same-tick pairs: sound 1 (0.25) + sound 2 (0.5) sum to 0.75 in one sample.
  const pairs = r.onsets.filter(([, v]) => Math.abs(v - 0.75) < 1e-6).length;
  log(`rendered: ${found} impulses at 32 samples per ms of tick time, max deviation ${maxDev} samples; ${pairs} same-tick pairs start in the same sample`);
  assert.equal(maxDev, 0, "impulses sample-exact");
  assert.ok(pairs >= 15, "same-tick sounds start together");

  // u32 wrap and clamp.
  assert.ok(Math.abs(r.wrap[0] - (1 + L - 0.021)) < 1e-12, "at just before a clock wrap");
  assert.ok(Math.abs(r.wrap[1] - (1 + L + 0.021)) < 1e-12, "at just after a clock wrap");
  assert.equal(r.wrap[2], 2, "older than the latency: clamped to now");
  assert.equal(r.wrap[3], 2 + L, "at == now: now + latency");
  log(`startTime wrap and clamp: ${JSON.stringify(r.wrap)}`);

  // STOP: until 100 ms + L both voices (0.5), until 200 ms + L voice 5 only (0.25), then 0.
  const st = Object.fromEntries(r.stop);
  assert.equal(st[10], 0, "before the start (latency)");
  assert.equal(st[140], 0.5, "two voices");
  assert.equal(st[149], 0.5, "voice 4 still plays until its STOP time");
  assert.equal(st[160], 0.25, "STOP voice 4");
  assert.equal(st[260], 0, "STOP all");
  assert.equal(st[400], 0, "stays stopped");
  log(`STOP: levels ${JSON.stringify(r.stop)}`);
}
