// Web Audio host (M1 creates the AudioContext in the click-to-start gesture; M6 adds playback,
// the 16-voice table, focus mute and scheduling, audio-input.md 4).

export interface PortAudio {
  readonly ctx: AudioContext | null;
  // words: 4 x u32 per command {op, sound_id, voice, at_ms} (port_sound_cmds).
  commands(words: Uint32Array, count: number): void;
  setActive(active: boolean): void;
}

// Call inside a user gesture handler: browsers allow audio only after a gesture.
export function createAudio(): PortAudio {
  let ctx: AudioContext | null = null;
  let master: GainNode | null = null;
  try {
    ctx = new AudioContext();
    master = ctx.createGain();
    master.connect(ctx.destination);
    void ctx.resume();
  } catch (err) {
    console.warn("moeboid: no Web Audio", err);
    ctx = null;
  }
  return {
    ctx,
    commands(words: Uint32Array, count: number): void {
      void words;
      void count; // M6: decode WAV data from the pack and start AudioBufferSourceNodes.
    },
    setActive(active: boolean): void {
      if (master && ctx) master.gain.setValueAtTime(active ? 1 : 0, ctx.currentTime);
    },
  };
}
