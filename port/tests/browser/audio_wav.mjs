// M6 test (a): WAV decoding and the sound id contract. Run:
//   tools/bin/web-test port/tests/browser/audio_wav.mjs        (root port/build/web: host, pack)
// 1. port/tests/browser/audio_wav_ref.py decodes every sound of src/core/sound_ids.h from the
//    phase 1 assets (not from pack.bin) into a small JSON (sha256 of the float32 samples).
// 2. host/audio.ts SOUND_TABLE and op constants equal src/core/sound_ids.h.
// 3. In Chromium: createPlayer(OfflineAudioContext).load(pack.bin); every AudioBuffer has the
//    WAV rate, channel count, frame count and float32 samples of the reference (sha256 equal).
// 4. parseWav follows the engine RIFF rules on synthetic files.
// 5. The real page: click to start creates the AudioContext and decodes 15 sounds.
import { execFileSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const HERE = path.dirname(fileURLToPath(import.meta.url));
const PORT = path.resolve(HERE, "../..");

function headerContract() {
  const h = fs.readFileSync(path.join(PORT, "src/core/sound_ids.h"), "utf8");
  const defs = {};
  for (const m of h.matchAll(/#define (PORT_SND_\w+) (0x[0-9a-f]+|\d+)u\b/gi)) defs[m[1]] = Number(m[2]);
  const flags = (expr) => expr.split("|").map((s) => s.trim()).reduce((a, s) => a | (s in defs ? defs[s] : Number(s)), 0);
  const table = [...h.matchAll(/X\((\d+),\s*(\w+),\s*"([^"]+)",\s*([\w| ]+)\)/g)].map((m) => ({
    id: Number(m[1]), entry: m[3], flags: flags(m[4]),
  }));
  return { defs, table };
}

export default async function ({ page, baseURL, outDir, assert, log }) {
  const refPath = path.join(outDir, "audio_wav_ref.json");
  execFileSync("python", ["-I", "-B", path.join(HERE, "audio_wav_ref.py"), refPath], { stdio: "inherit" });
  const ref = JSON.parse(fs.readFileSync(refPath, "utf8"));
  const hdr = headerContract();
  assert.equal(hdr.table.length, 15, "sound_ids.h rows");

  await page.route("**/m6-blank.html", (r) =>
    r.fulfill({ contentType: "text/html", body: "<!doctype html><title>m6</title><canvas id=c></canvas>" }));
  await page.goto(`${baseURL}/m6-blank.html`);
  const got = await page.evaluate(async () => {
    const A = await import("/audio.js");
    const pack = new Uint8Array(await (await fetch("/pack.bin")).arrayBuffer());
    const off = new OfflineAudioContext(1, 128, 48000);
    const pl = A.createPlayer(off);
    const hex = async (u8) =>
      Array.from(new Uint8Array(await crypto.subtle.digest("SHA-256", u8)), (x) => x.toString(16).padStart(2, "0")).join("");
    const out = {
      loaded: pl.load(pack),
      table: A.SOUND_TABLE,
      consts: { PLAY: A.SND_OP_PLAY, STOP: A.SND_OP_STOP, ALL: A.SND_VOICE_ALL, GF: A.SND_F_GLOBALFOCUS },
      wavEntries: [...A.packEntries(pack).keys()].filter((n) => n.endsWith(".WAV")),
      sounds: {},
    };
    for (const d of A.SOUND_TABLE) {
      const b = pl.buffer(d.id);
      if (!b) continue;
      const ch = b.getChannelData(0);
      out.sounds[d.id] = {
        rate: b.sampleRate, channels: b.numberOfChannels, frames: b.length,
        sha256: await hex(new Uint8Array(ch.buffer, ch.byteOffset, ch.byteLength)), first: Array.from(ch.slice(0, 8)),
      };
    }
    // Synthetic RIFF files (engine rules, audio-input.md 2.3).
    const enc = (s) => Array.from(s, (c) => c.charCodeAt(0));
    const u32 = (n) => [n & 255, (n >>> 8) & 255, (n >>> 16) & 255, n >>> 24];
    const chunk = (id, body) => [...enc(id), ...u32(body.length), ...body, ...(body.length & 1 ? [0] : [])];
    const fmt = (rate, bits, ch = 1, size = 16) =>
      chunk("fmt ", [1, 0, ch, 0, ...u32(rate), ...u32((rate * ch * bits) / 8), (ch * bits) / 8, 0, bits, 0, 0, 0].slice(0, size));
    const riff = (chunks, sizeAdj = 0) => {
      const body = [...enc("WAVE"), ...chunks.flat()];
      return new Uint8Array([...enc("RIFF"), ...u32(body.length + sizeAdj), ...body]);
    };
    const w = (b) => {
      const r = A.parseWav(b);
      return r && { rate: r.rate, bits: r.bits, channels: r.channels, frames: r.frames, data: r.data.map((c) => Array.from(c)) };
    };
    out.synth = {
      // odd-size chunk with pad byte, then fmt, a skipped PAD chunk, two data chunks (first wins)
      oddPad: w(riff([chunk("junk", [1, 2, 3]), fmt(8000, 8), chunk("PAD ", [9, 9]), chunk("data", [0, 128, 255]), chunk("data", [7])])),
      int16: w(riff([fmt(11025, 16), chunk("data", [0x00, 0x80, 0xff, 0x7f, 0xff, 0xff, 0x01])])), // odd tail byte dropped
      stereo8: w(riff([fmt(11025, 8, 2), chunk("data", [0, 255, 128, 64])])),
      fmtTooShort: w(riff([fmt(8000, 8, 1, 12), chunk("data", [1])])),
      fmt14: w(riff([fmt(8000, 8, 1, 14), chunk("data", [1])])), // WAVEFORMAT without bit count
      notRiff: w(new Uint8Array([...enc("RIFX"), ...u32(4), ...enc("WAVE")])),
      noData: w(riff([fmt(8000, 8)])),
      dataBeyondRiffSize: w(riff([fmt(8000, 8), chunk("data", [1, 2])], -10)),
      dataTruncated: w((() => { const b = riff([fmt(8000, 8), chunk("data", [10, 20, 30, 40])]); return b.subarray(0, b.length - 2); })()),
      bits24: w(riff([fmt(8000, 24), chunk("data", [1, 2, 3])])),
    };
    return out;
  });

  // Contract: TS table and constants equal the C header.
  assert.deepEqual(got.table.map((d) => ({ id: d.id, entry: d.entry, flags: d.flags })), hdr.table, "SOUND_TABLE equals sound_ids.h");
  assert.deepEqual(got.consts, {
    PLAY: hdr.defs.PORT_SND_OP_PLAY, STOP: hdr.defs.PORT_SND_OP_STOP, ALL: hdr.defs.PORT_SND_VOICE_ALL,
    GF: hdr.defs.PORT_SND_F_GLOBALFOCUS,
  }, "op constants equal sound_ids.h");
  assert.deepEqual([...got.wavEntries].sort(), hdr.table.map((d) => d.entry).sort(), "every pack WAV has an id");
  assert.equal(got.loaded, 15, "sounds loaded from pack.bin");

  // Sample identity with the Python reference.
  let samples = 0;
  for (const [id, r] of Object.entries(ref)) {
    const g = got.sounds[id];
    assert.ok(g, `sound ${id} decoded`);
    assert.equal(g.rate, r.rate, `${r.name} rate`);
    assert.equal(g.channels, r.channels, `${r.name} channels`);
    assert.equal(g.frames, r.frames, `${r.name} frames`);
    assert.deepEqual(g.first, r.first, `${r.name} first samples`);
    assert.equal(g.sha256, r.sha256, `${r.name} float32 sha256`);
    samples += r.frames;
    log(`${id.padStart(2)} ${r.name.padEnd(24)} ${r.rate} Hz ${String(r.bits).padStart(2)}-bit ${String(r.frames).padStart(6)} frames sha256 ${r.sha256.slice(0, 16)} equal`);
  }
  log(`sample identity: ${Object.keys(ref).length} sounds, ${samples} samples equal the Python reference`);

  // RIFF rules on synthetic files.
  const s = got.synth;
  assert.deepEqual(s.oddPad, { rate: 8000, bits: 8, channels: 1, frames: 3, data: [[-1, 0, 127 / 128]] }, "odd chunk pad, PAD skipped, first data");
  assert.deepEqual(s.int16, { rate: 11025, bits: 16, channels: 1, frames: 3, data: [[-1, 32767 / 32768, -1 / 32768]] }, "16-bit");
  assert.deepEqual(s.stereo8, { rate: 11025, bits: 8, channels: 2, frames: 2, data: [[-1, 0], [127 / 128, -0.5]] }, "8-bit stereo");
  assert.equal(s.fmtTooShort, null, "fmt chunk < 14 bytes fails");
  assert.equal(s.fmt14, null, "14-byte WAVEFORMAT (no bit count) gives no buffer");
  assert.equal(s.notRiff, null, "not RIFF");
  assert.equal(s.noData, null, "no data chunk");
  assert.equal(s.dataBeyondRiffSize, null, "chunk walk ends at riff_size + 8");
  assert.deepEqual(s.dataTruncated?.data, [[(10 - 128) / 128, (20 - 128) / 128]], "data chunk clamped to the resource");
  assert.equal(s.bits24, null, "24-bit");
  log("parseWav RIFF rules: 10 synthetic cases pass");

  // Real page: click to start (user gesture) creates the AudioContext and decodes the pack sounds.
  const info = page.waitForEvent("console", { predicate: (m) => m.text().startsWith("moeboid: audio:"), timeout: 20000 });
  await page.goto(`${baseURL}/index.html`);
  await page.waitForSelector("#start:not([disabled])", { timeout: 20000 });
  await page.click("#start");
  const msg = (await info).text();
  log(`page: ${msg}`);
  assert.match(msg, /^moeboid: audio: 15 sounds, \d+ Hz$/);
}
