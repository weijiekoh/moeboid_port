// Moeboid page host (M1). Loads moeboid.wasm, pack.bin and Moeboid.gam from this origin, shows
// the click-to-start screen, then drives port_advance from requestAnimationFrame.
// Host API: docs/port-design.md section 6; src/main.c.

import { attachInput, IN_START } from "./input.js";
import { loadStorage, saveStorage } from "./storage.js";
import { createAudio } from "./audio.js";
import type { PortAudio } from "./audio.js";

interface PortExports {
  memory: WebAssembly.Memory;
  port_alloc(n: number): number;
  port_free(p: number): void;
  port_set_seed(seed: number): void;
  port_init(pack: number, packLen: number, gam: number, gamLen: number, clockStep: number, quirks: number): number;
  port_advance(wallMs: number): number;
  port_input(kind: number, a: number, b: number, timeMs: number): number;
  port_frame_ptr(): number;
  port_frame_w(): number;
  port_frame_h(): number;
  port_cursor(): number;
  port_sound_cmds(out: number): number;
  port_sound_cmds_max(): number;
  port_storage_get_ptr(): number;
  port_storage_get_len(): number;
  port_storage_load(p: number, n: number): number;
  port_now(): number;
}

const ADV_FRAME = 1;
const ADV_SOUND = 2;
const ADV_STORAGE = 4;
const QUIRKS_ALL = 0xffffffff; // decisions.md item 10: engine quirks on by default
// CSS cursor per port_cursor() id (M6 replaces these with the extracted cursor images).
const CURSORS = ["default", "pointer", "default", "default", "default", "default"];

const $ = <T extends HTMLElement>(id: string): T => document.getElementById(id) as T;

function setStatus(text: string): void {
  $("status").textContent = text;
}

async function fetchBytes(name: string, optional: boolean): Promise<Uint8Array<ArrayBuffer>> {
  const r = await fetch(name, { cache: "no-cache" });
  if (!r.ok) {
    if (optional) {
      console.warn(`moeboid: ${name} not found (${r.status}); using an empty file`);
      return new Uint8Array(0);
    }
    throw new Error(`${name}: HTTP ${r.status}`);
  }
  return new Uint8Array(await r.arrayBuffer());
}

async function compileModule(): Promise<WebAssembly.Module> {
  try {
    return await WebAssembly.compileStreaming(fetch("moeboid.wasm"));
  } catch {
    // Server without the application/wasm MIME type: compile from bytes.
    return WebAssembly.compile(await fetchBytes("moeboid.wasm", false));
  }
}

// Clock step setting (decision 2): ?clock=0 (1 ms, default), 1 (15.625 ms), 2 (54.925 ms).
function clockStepSetting(): number {
  const v = Number(new URLSearchParams(window.location.search).get("clock") ?? "0");
  return v === 1 || v === 2 ? v : 0;
}

// Largest integer number of device pixels per frame pixel that fits the window (minimum 1).
function fitCanvas(canvas: HTMLCanvasElement, w: number, h: number): void {
  const dpr = window.devicePixelRatio || 1;
  const f = Math.max(1, Math.floor(Math.min((window.innerWidth * dpr) / w, (window.innerHeight * dpr) / h)));
  canvas.style.width = `${(w * f) / dpr}px`;
  canvas.style.height = `${(h * f) / dpr}px`;
}

async function start(module: WebAssembly.Module, pack: Uint8Array, gam: Uint8Array, clickTime: number): Promise<void> {
  const canvas = $<HTMLCanvasElement>("screen");
  const button = $<HTMLButtonElement>("start");
  // M6 audio: AudioContext inside the click gesture; sounds decoded from pack.bin.
  const audio: PortAudio = createAudio();
  const nSounds = audio.load(pack);
  if (audio.ctx) console.info(`moeboid: audio: ${nSounds} sounds, ${audio.ctx.sampleRate} Hz`);
  const decoder = new TextDecoder("latin1");
  let ex: PortExports;
  const text = (p: number, n: number): string => decoder.decode(new Uint8Array(ex.memory.buffer, p, n));
  const imports = {
    env: {
      host_log: (p: number, n: number): void => console.log(`[moeboid] ${text(p, n)}`),
      host_trace: (p: number, n: number): void => console.debug(text(p, n)),
    },
  };
  const instance = await WebAssembly.instantiate(module, imports);
  ex = instance.exports as unknown as PortExports;
  const W = ex.port_frame_w();
  const H = ex.port_frame_h();
  canvas.width = W;
  canvas.height = H;

  const copyIn = (bytes: Uint8Array): number => {
    const p = ex.port_alloc(bytes.length);
    new Uint8Array(ex.memory.buffer, p, bytes.length).set(bytes);
    return p;
  };
  // Engine srand seed: the original uses timeGetTime at start (timing.md 3.1).
  ex.port_set_seed(crypto.getRandomValues(new Uint32Array(1))[0]);
  const blob = loadStorage();
  if (blob.length) {
    const p = copyIn(blob);
    if (ex.port_storage_load(p, blob.length) !== 0) console.warn("moeboid: stored settings partly invalid");
    ex.port_free(p);
  }
  const packPtr = copyIn(pack);
  const gamPtr = copyIn(gam);
  const rc = ex.port_init(packPtr, pack.length, gamPtr, gam.length, clockStepSetting(), QUIRKS_ALL);
  if (rc !== 0) {
    setStatus(`Start failed (code ${rc}).`);
    return;
  }

  // M6 input: focus loss sends kind 6 and mutes audio, focus gain kind 7 and unmutes.
  attachInput(
    canvas,
    W,
    H,
    (kind, a, b, t) => {
      ex.port_input(kind, a, b, t);
    },
    (active) => audio.setActive(active),
  );
  ex.port_input(IN_START, 0, 0, Math.floor(clickTime) >>> 0);

  const ctx = canvas.getContext("2d", { alpha: false });
  if (!ctx) throw new Error("no 2D canvas context");
  const soundMax = ex.port_sound_cmds_max();
  const soundBuf = ex.port_alloc(soundMax * 16);
  let cursor = -1;
  button.hidden = true;
  setStatus("");
  canvas.focus();
  fitCanvas(canvas, W, H);
  window.addEventListener("resize", () => fitCanvas(canvas, W, H));

  const frame = (ts: number): void => {
    const flags = ex.port_advance(Math.floor(ts) >>> 0);
    if (flags & ADV_FRAME) {
      const px = new Uint8ClampedArray(ex.memory.buffer, ex.port_frame_ptr(), W * H * 4);
      ctx.putImageData(new ImageData(px, W, H), 0, 0);
    }
    if (flags & ADV_SOUND) {
      // M6: start times keep the clock spacing of the commands (audio.ts startTime).
      const n = ex.port_sound_cmds(soundBuf);
      const now = ex.port_now();
      audio.commands(new Uint32Array(ex.memory.buffer, soundBuf, n * 4), n, now);
    }
    if (flags & ADV_STORAGE) {
      const p = ex.port_storage_get_ptr();
      saveStorage(new Uint8Array(ex.memory.buffer, p, ex.port_storage_get_len()).slice());
    }
    const c = ex.port_cursor();
    if (c !== cursor) {
      cursor = c;
      canvas.style.cursor = CURSORS[c] ?? "default";
    }
    window.requestAnimationFrame(frame);
  };
  window.requestAnimationFrame(frame);
}

async function boot(): Promise<void> {
  const button = $<HTMLButtonElement>("start");
  const canvas = $<HTMLCanvasElement>("screen");
  fitCanvas(canvas, canvas.width, canvas.height);
  try {
    const [module, pack, gam] = await Promise.all([
      compileModule(),
      fetchBytes("pack.bin", true),
      fetchBytes("Moeboid.gam", false),
    ]);
    button.textContent = "Click to start";
    button.disabled = false;
    button.addEventListener(
      "click",
      (e: MouseEvent) => {
        button.disabled = true;
        start(module, pack, gam, e.timeStamp).catch((err: unknown) => {
          setStatus(String(err));
          console.error(err);
        });
      },
      { once: true },
    );
  } catch (err) {
    button.textContent = "Cannot start";
    setStatus(String(err));
    console.error(err);
  }
}

void boot();
