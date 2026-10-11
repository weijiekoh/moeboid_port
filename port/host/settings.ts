// Port settings of the click-to-start page (M7; decisions.md items 2, 4b, 10). Kept in localStorage,
// read once at page load, applied at port_init. A change is saved at once and takes effect after a
// page reload (the wasm module reads the settings only at start).

const KEY = "moeboid.settings.v1";

// Clock models (decision 2; analysis/timing.md section 5). Index = port_init clock_step_index.
export const CLOCK_MODELS: readonly string[] = [
  "Windows 2000-like: 1 ms clock step, 50 Hz game ticks",
  "Windows XP-like: 15.625 ms clock step, 32 Hz game ticks",
  "Windows 98-like: 54.925 ms clock step, 18.2 Hz game ticks",
];
export const CLOCK_SHORT: readonly string[] = ["1 ms, 50 Hz", "15.625 ms, 32 Hz", "54.925 ms, 18.2 Hz"];

// Engine-side quirk switches = the port_settings.quirks bits of src/engine/engine.h (decision 10,
// provisional: on). Game quirks (play-again snap, letter keys on F3/F4/F5/F10) are in the original
// game code and always stay.
export interface QuirkSwitch {
  bit: number;
  name: string;
  label: string;
}
export const QUIRK_SWITCHES: readonly QuirkSwitch[] = [
  {
    bit: 0x01, // ENG_QUIRK_DETACH_DIRTY
    name: "detach redraw",
    label: "Detach redraw: a removed sprite is redrawn at its unshifted position (Z:0x4147f0)",
  },
];

export interface PortSettings {
  clock: number; // 0, 1, 2
  smoothing: number; // 1 Standard (decision 4b), 0 off
  quirksOff: number; // QUIRK_SWITCHES bits switched off
}

export const DEFAULTS: PortSettings = { clock: 0, smoothing: 1, quirksOff: 0 };

const knownBits = (): number => QUIRK_SWITCHES.reduce((m, q) => m | q.bit, 0);

function sanitize(v: unknown): PortSettings {
  const o = (typeof v === "object" && v !== null ? v : {}) as Record<string, unknown>;
  const clock = Number(o.clock);
  const smoothing = Number(o.smoothing);
  const off = Number(o.quirksOff);
  return {
    clock: clock === 1 || clock === 2 ? clock : 0,
    smoothing: smoothing === 0 ? 0 : 1,
    quirksOff: Number.isInteger(off) ? (off & knownBits()) >>> 0 : 0,
  };
}

export function loadSettings(): PortSettings {
  try {
    const s = window.localStorage.getItem(KEY);
    return s ? sanitize(JSON.parse(s)) : { ...DEFAULTS };
  } catch {
    return { ...DEFAULTS }; // storage blocked or bad JSON: defaults
  }
}

export function saveSettings(s: PortSettings): boolean {
  try {
    window.localStorage.setItem(KEY, JSON.stringify(sanitize(s)));
    return true;
  } catch (err) {
    console.warn("moeboid: settings not saved", err);
    return false;
  }
}

// port_init quirks word: every bit on except the switched-off ones (unknown bits stay on).
export function quirksWord(s: PortSettings): number {
  return (0xffffffff & ~s.quirksOff) >>> 0;
}

export function describe(s: PortSettings): string {
  const q = QUIRK_SWITCHES.map((w) => `${w.name} ${s.quirksOff & w.bit ? "off" : "on"}`).join(", ");
  return `Clock ${CLOCK_SHORT[s.clock]}; font smoothing ${s.smoothing ? "Standard" : "Off"}; engine quirks: ${q}.`;
}

const same = (a: PortSettings, b: PortSettings): boolean =>
  a.clock === b.clock && a.smoothing === b.smoothing && a.quirksOff === b.quirksOff;

// Builds the controls in #settings (plain DOM, no inline style: CSP style-src 'self').
export function attachSettingsForm(active: PortSettings): void {
  const root = document.getElementById("settings");
  if (!root) return;
  const current = document.getElementById("settings-current");
  const note = document.getElementById("settings-note");
  if (current) current.textContent = `Current settings: ${describe(active)}`;
  const saved = loadSettings();
  let edit: PortSettings = { ...saved };

  const el = <K extends keyof HTMLElementTagNameMap>(tag: K, text?: string): HTMLElementTagNameMap[K] => {
    const e = document.createElement(tag);
    if (text !== undefined) e.textContent = text;
    return e;
  };
  const group = (legend: string): HTMLFieldSetElement => {
    const f = el("fieldset");
    f.append(el("legend", legend));
    return f;
  };
  const option = (f: HTMLFieldSetElement, type: string, name: string, value: string, text: string, on: boolean) => {
    const label = el("label");
    const input = el("input");
    input.type = type;
    input.name = name;
    input.value = value;
    input.checked = on;
    label.append(input, ` ${text}`);
    f.append(label);
    return input;
  };
  const update = (): void => {
    if (!saveSettings(edit)) {
      if (note) note.textContent = "Settings cannot be saved in this browser (storage blocked).";
      return;
    }
    if (note)
      note.textContent = same(edit, active)
        ? "Saved. These are the current settings."
        : "Saved. Reload the page to apply the new settings.";
  };

  const clock = group("Clock model (game speed of the original platform)");
  CLOCK_MODELS.forEach((text, i) => {
    const input = option(clock, "radio", "clock", String(i), i === 0 ? `${text} (default)` : text, edit.clock === i);
    input.addEventListener("change", () => {
      edit = { ...edit, clock: i };
      update();
    });
  });
  const smooth = group("Font smoothing");
  [
    [1, "Standard: grey edges where the font allows them, as on Windows XP"],
    [0, "Off: black-and-white text"],
  ].forEach(([v, text]) => {
    const input = option(smooth, "radio", "smoothing", String(v), v === 1 ? `${text} (default)` : String(text), edit.smoothing === v);
    input.addEventListener("change", () => {
      edit = { ...edit, smoothing: Number(v) };
      update();
    });
  });
  const quirks = group("Engine quirks (on = original behaviour, default)");
  for (const q of QUIRK_SWITCHES) {
    const input = option(quirks, "checkbox", "quirk", String(q.bit), q.label, !(edit.quirksOff & q.bit));
    input.addEventListener("change", () => {
      edit = { ...edit, quirksOff: input.checked ? edit.quirksOff & ~q.bit : edit.quirksOff | q.bit };
      update();
    });
  }
  const controls = document.getElementById("settings-controls");
  (controls ?? root).append(clock, smooth, quirks);
}
