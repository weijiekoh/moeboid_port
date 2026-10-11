// Web Audio host (M6; analysis/audio-input.md 2.3 to 2.7 and 4, decisions.md item 12).
//
// - One AudioContext at the device rate, created and resumed in the click-to-start gesture.
// - Every sound of SOUND_TABLE is decoded once from pack.bin with the engine RIFF rules (only
//   the first `fmt ` and the first `data` chunk count, audio-input.md 2.3) into an AudioBuffer
//   at the WAV's own rate (8000 or 11025 Hz); the browser resamples to the device rate.
// - port_sound_cmds records {op, sound_id, voice, at_ms} (src/core/sound_ids.h) start one
//   AudioBufferSourceNode each, gain 1.0, no pan. The C side owns the 16-voice table, the drop
//   rule and the voice release time; the host plays what it gets.
// - Focus loss: master gain 0, sources keep running (DirectSound focus mute, audio-input.md 2.7).

// Mirror of src/core/sound_ids.h (port/tests/browser/audio_wav.mjs compares both).
export const SND_OP_PLAY = 1;
export const SND_OP_STOP = 2;
export const SND_VOICE_ALL = 0xffffffff;
export const SND_F_GLOBALFOCUS = 1; // DSBCAPS_GLOBALFOCUS: not muted on focus loss

export interface SoundDef {
  id: number;
  entry: string; // pack.bin entry name
  flags: number;
}

// PORT_SOUND_TABLE of src/core/sound_ids.h. Ids are stable; the C side sends them.
export const SOUND_TABLE: readonly SoundDef[] = [
  { id: 1, entry: "gam/RCDATA/SND-GAMEOPEN.WAV", flags: 0 },
  { id: 2, entry: "gam/RCDATA/SND-GAMEOVER-HIGHSCORE.WAV", flags: 0 },
  { id: 3, entry: "gam/RCDATA/SND-GAMEOVER.WAV", flags: 0 },
  { id: 4, entry: "gam/RCDATA/SND-GAMESTART.WAV", flags: 0 },
  { id: 5, entry: "gam/RCDATA/SND-LOSELIFE.WAV", flags: 0 },
  { id: 6, entry: "gam/RCDATA/SND-MOEBEATS.WAV", flags: 0 },
  { id: 7, entry: "gam/RCDATA/SND-MOEBGROWTH.WAV", flags: 0 },
  { id: 8, entry: "gam/RCDATA/SND-NEWBADDIEGOOD.WAV", flags: 0 },
  { id: 9, entry: "gam/RCDATA/SND-NEWBADDIEBAD.WAV", flags: 0 },
  { id: 10, entry: "gam/RCDATA/SND-RANDBG.WAV", flags: 0 },
  { id: 11, entry: "gam/RCDATA/SND-EXTRALIFE.WAV", flags: 0 },
  { id: 12, entry: "zap/RCDATA/BTNCLICK.WAV", flags: 0 },
  { id: 13, entry: "zap/RCDATA/POPUP.WAV", flags: 0 },
  { id: 14, entry: "zap/RCDATA/OPENSHELL.WAV", flags: 0 },
  { id: 15, entry: "zap/RCDATA/CLOSESHELL.WAV", flags: SND_F_GLOBALFOCUS },
];

// Constant delay from "now" (the host frame that drains the commands) to the start of a
// sound made in the last clock step. A command made d ms of clock time earlier in the same
// batch starts d ms earlier, so the tick spacing stays (audio-input.md decision D5). 50 ms
// covers a batch span of one host frame up to 30 Hz plus the update period of
// AudioContext.currentTime; an older command starts at once (clamped to now).
export const LATENCY_S = 0.05;

// Audio start time for a command made at clock ms atMs, drained at clock ms nowMs (port_now)
// when the context time is ctxNow. Clock values are u32 and may wrap.
export function startTime(ctxNow: number, atMs: number, nowMs: number): number {
  return Math.max(ctxNow, ctxNow + LATENCY_S + ((atMs - nowMs) | 0) / 1000);
}

export interface WavPcm {
  rate: number;
  channels: number;
  bits: number;
  frames: number;
  data: Float32Array<ArrayBuffer>[]; // one array per channel
}

const tag = (b: Uint8Array, o: number): string => String.fromCharCode(b[o], b[o + 1], b[o + 2], b[o + 3]);

// RIFF parse as the engine (Z:0x40c540): needs RIFF and WAVE; walks chunks from offset 12 to
// riff_size + 8 with step (size + 1) & ~1; first `fmt ` (size >= 14, else fail) and first
// `data`; stops when both are found; skips every other chunk (PAD, fact, cue, LIST). PCM to
// float: 8-bit unsigned (b - 128) / 128, 16-bit signed s / 32768 (exact in float32). Returns
// null where DirectSound would make no buffer: no fmt or data, not PCM, not 8 or 16 bit, bad
// block align, no sample frame (inferred from the DirectSound PCM rules).
export function parseWav(b: Uint8Array): WavPcm | null {
  if (b.length < 12 || tag(b, 0) !== "RIFF" || tag(b, 8) !== "WAVE") return null;
  const v = new DataView(b.buffer, b.byteOffset, b.byteLength);
  const end = Math.min(b.length, v.getUint32(4, true) + 8);
  let fmt = -1;
  let fmtLen = 0;
  let data = -1;
  let dataLen = 0;
  for (let p = 12; p + 8 <= end && (fmt < 0 || data < 0); ) {
    const id = tag(b, p);
    const size = v.getUint32(p + 4, true);
    if (id === "fmt " && fmt < 0) {
      if (size < 14) return null;
      fmt = p + 8;
      fmtLen = size;
    } else if (id === "data" && data < 0) {
      data = p + 8;
      dataLen = Math.min(size, b.length - data); // the engine copies size bytes; clamp to the resource
    }
    p += 8 + size + (size & 1);
  }
  if (fmt < 0 || data < 0 || fmtLen < 16 || fmt + 16 > b.length) return null;
  const formatTag = v.getUint16(fmt, true);
  const channels = v.getUint16(fmt + 2, true);
  const rate = v.getUint32(fmt + 4, true);
  const blockAlign = v.getUint16(fmt + 12, true);
  const bits = v.getUint16(fmt + 14, true);
  if (formatTag !== 1 || (bits !== 8 && bits !== 16) || channels < 1 || channels > 2) return null;
  if (blockAlign !== (channels * bits) / 8) return null;
  const frames = Math.floor(dataLen / blockAlign);
  if (frames < 1 || rate < 1) return null;
  const out: Float32Array<ArrayBuffer>[] = [];
  for (let c = 0; c < channels; c++) {
    const ch = new Float32Array(frames);
    if (bits === 8) {
      for (let i = 0, o = data + c; i < frames; i++, o += blockAlign) ch[i] = (b[o] - 128) / 128;
    } else {
      for (let i = 0, o = data + 2 * c; i < frames; i++, o += blockAlign) ch[i] = v.getInt16(o, true) / 32768;
    }
    out.push(ch);
  }
  return { rate, channels, bits, frames, data: out };
}

// pack.bin directory (docs/port-design.md section 7): name to entry bytes (views, no copy).
export function packEntries(pack: Uint8Array): Map<string, Uint8Array> {
  const m = new Map<string, Uint8Array>();
  if (pack.length < 12 || tag(pack, 0) !== "MPAK") return m;
  const v = new DataView(pack.buffer, pack.byteOffset, pack.byteLength);
  const count = v.getUint32(8, true);
  let p = 12;
  for (let i = 0; i < count && p + 4 <= pack.length; i++) {
    const n = v.getUint32(p, true);
    if (p + 12 + n > pack.length) break;
    const name = String.fromCharCode(...pack.subarray(p + 4, p + 4 + n));
    const off = v.getUint32(p + 4 + n, true);
    const len = v.getUint32(p + 8 + n, true);
    p += 12 + n;
    if (off + len <= pack.length) m.set(name, pack.subarray(off, off + len));
  }
  return m;
}

export interface PortAudio {
  readonly ctx: BaseAudioContext | null;
  readonly muted: boolean;
  // Decode every SOUND_TABLE sound from pack.bin; returns the number of sounds ready.
  load(pack: Uint8Array): number;
  // Use buf for sound id (tests; load() fills every pack sound).
  setSound(id: number, buf: AudioBuffer, flags: number): void;
  buffer(id: number): AudioBuffer | null;
  // words: 4 x u32 per command {op, sound_id, voice, at_ms} (port_sound_cmds); nowMs = port_now().
  commands(words: Uint32Array, count: number, nowMs: number): void;
  // false: focus lost (master gain 0), true: focus gained (gain 1).
  setActive(active: boolean): void;
}

// Player on any context (AudioContext in the page, OfflineAudioContext in tests); null: silent.
export function createPlayer(ctx: BaseAudioContext | null): PortAudio {
  const sounds = new Map<number, { buf: AudioBuffer; flags: number }>();
  const voices = new Map<number, Set<AudioBufferSourceNode>>();
  const missing = new Set<number>();
  let master: GainNode | null = null;
  let muted = false;
  if (ctx) {
    master = ctx.createGain();
    master.gain.value = 1; // 0 dB: the engine never calls SetVolume (audio-input.md 2.5)
    master.connect(ctx.destination);
  }

  const play = (c: BaseAudioContext, id: number, voice: number, when: number): void => {
    const s = sounds.get(id);
    if (!s) {
      if (!missing.has(id)) console.warn(`moeboid: audio: no sound for id ${id}`);
      missing.add(id);
      return;
    }
    const src = c.createBufferSource();
    src.buffer = s.buf;
    // Mono source into the stereo destination: Web Audio up-mix gives L = R = mono, 0 dB, as
    // DirectSound centre pan (audio-input.md 4).
    src.connect(s.flags & SND_F_GLOBALFOCUS ? c.destination : (master as GainNode));
    let set = voices.get(voice);
    if (!set) voices.set(voice, (set = new Set()));
    const vs = set;
    vs.add(src);
    src.onended = (): void => {
      vs.delete(src);
      src.disconnect();
    };
    src.start(when);
  };

  const stop = (voice: number, when: number): void => {
    for (const [v, set] of voices) {
      if (voice !== SND_VOICE_ALL && v !== voice) continue;
      for (const src of set) {
        try {
          src.stop(when);
        } catch {
          // already stopped
        }
      }
    }
  };

  return {
    ctx,
    get muted(): boolean {
      return muted;
    },
    load(pack: Uint8Array): number {
      if (!ctx) return 0;
      const entries = packEntries(pack);
      let n = 0;
      for (const d of SOUND_TABLE) {
        const bytes = entries.get(d.entry);
        const pcm = bytes ? parseWav(bytes) : null;
        if (!pcm) {
          console.warn(`moeboid: audio: ${d.entry} ${bytes ? "is not a playable WAV" : "is not in pack.bin"}`);
          continue;
        }
        try {
          const buf = ctx.createBuffer(pcm.channels, pcm.frames, pcm.rate);
          for (let c = 0; c < pcm.channels; c++) buf.copyToChannel(pcm.data[c], c);
          sounds.set(d.id, { buf, flags: d.flags });
          n++;
        } catch (err) {
          console.warn(`moeboid: audio: ${d.entry}: no AudioBuffer at ${pcm.rate} Hz`, err);
        }
      }
      return n;
    },
    setSound(id: number, buf: AudioBuffer, flags: number): void {
      sounds.set(id, { buf, flags });
    },
    buffer(id: number): AudioBuffer | null {
      return sounds.get(id)?.buf ?? null;
    },
    commands(words: Uint32Array, count: number, nowMs: number): void {
      if (!ctx) return;
      const now = ctx.currentTime;
      for (let i = 0; i < count; i++) {
        const op = words[4 * i];
        const when = startTime(now, words[4 * i + 3], nowMs);
        if (op === SND_OP_PLAY) play(ctx, words[4 * i + 1], words[4 * i + 2], when);
        else if (op === SND_OP_STOP) stop(words[4 * i + 2], when);
      }
    },
    setActive(active: boolean): void {
      muted = !active;
      if (!ctx || !master) return;
      // Same delayed time line as the sounds: a sound made just before the focus change stays
      // audible until the change, as in the original.
      const t = ctx.currentTime + LATENCY_S;
      master.gain.cancelScheduledValues(t);
      master.gain.setValueAtTime(active ? 1 : 0, t);
      if (active && ctx instanceof AudioContext && ctx.state === "suspended") void ctx.resume().catch(() => {});
    },
  };
}

// Call inside the click-to-start gesture handler: browsers allow audio only after a gesture.
// No sampleRate option: the context runs at the device rate (decision 12).
export function createAudio(): PortAudio {
  let ctx: AudioContext | null = null;
  try {
    ctx = new AudioContext();
    void ctx.resume().catch((err: unknown) => console.warn("moeboid: AudioContext.resume failed", err));
  } catch (err) {
    console.warn("moeboid: no Web Audio", err);
    ctx = null;
  }
  return createPlayer(ctx);
}
