// Browser input capture (M1; M6 refines). Sends events to port_input with event.timeStamp,
// the same time base as requestAnimationFrame (timing.md 9 rule 5; audio-input.md 5).
// Kinds: src/core/input.h.

export type InputSink = (kind: number, a: number, b: number, timeMs: number) => void;

export const IN_KEYDOWN = 1;
export const IN_KEYUP = 2;
export const IN_MOUSEMOVE = 3;
export const IN_BUTTONDOWN = 4;
export const IN_BUTTONUP = 5;
export const IN_FOCUS_LOST = 6;
export const IN_FOCUS_GAINED = 7;
export const IN_START = 8;
export const IN_CHAR = 9;

// KeyboardEvent.code to Windows virtual-key code (US layout positions).
const CODE_VK: Record<string, number> = {
  Backspace: 0x08, Tab: 0x09, Enter: 0x0d, NumpadEnter: 0x0d, ShiftLeft: 0x10, ShiftRight: 0x10,
  ControlLeft: 0x11, ControlRight: 0x11, Pause: 0x13, CapsLock: 0x14, Escape: 0x1b, Space: 0x20,
  PageUp: 0x21, PageDown: 0x22, End: 0x23, Home: 0x24, ArrowLeft: 0x25, ArrowUp: 0x26,
  ArrowRight: 0x27, ArrowDown: 0x28, Insert: 0x2d, Delete: 0x2e,
  Numpad0: 0x60, Numpad1: 0x61, Numpad2: 0x62, Numpad3: 0x63, Numpad4: 0x64, Numpad5: 0x65,
  Numpad6: 0x66, Numpad7: 0x67, Numpad8: 0x68, Numpad9: 0x69, NumpadMultiply: 0x6a,
  NumpadAdd: 0x6b, NumpadSubtract: 0x6d, NumpadDecimal: 0x6e, NumpadDivide: 0x6f,
  F1: 0x70, F2: 0x71, F3: 0x72, F4: 0x73, F5: 0x74, F6: 0x75, F7: 0x76, F8: 0x77, F9: 0x78,
  F11: 0x7a, F12: 0x7b, NumLock: 0x90, ScrollLock: 0x91,
  Semicolon: 0xba, Equal: 0xbb, Comma: 0xbc, Minus: 0xbd, Period: 0xbe, Slash: 0xbf,
  Backquote: 0xc0, BracketLeft: 0xdb, Backslash: 0xdc, BracketRight: 0xdd, Quote: 0xde,
};

// Numpad keys with NumLock off: Windows sends the navigation virtual keys (key gives the name).
const NAV_KEY_VK: Record<string, number> = {
  Insert: 0x2d, End: 0x23, ArrowDown: 0x28, PageDown: 0x22, ArrowLeft: 0x25, Clear: 0x0c,
  ArrowRight: 0x27, Home: 0x24, ArrowUp: 0x26, PageUp: 0x21, Delete: 0x2e,
};

// Windows-1252 codes 0x80..0x9f.
const CP1252_HIGH = "€\u0081‚ƒ„…†‡ˆ‰Š‹Œ\u008dŽ\u008f" +
  "\u0090‘’“”•–—˜™š›œ\u009džŸ";

// Windows VK for a key event, 0 if the key is not mapped. Letters follow the layout (key), as
// Windows virtual keys do; other keys use the physical position (code).
export function vkFromEvent(e: KeyboardEvent): number {
  const k = e.key;
  if (k.length === 1) {
    const c = k.toUpperCase().charCodeAt(0);
    if (c >= 0x41 && c <= 0x5a) return c;
  }
  const code = e.code;
  if (/^Key[A-Z]$/.test(code)) return code.charCodeAt(3);
  if (/^Digit[0-9]$/.test(code)) return code.charCodeAt(5);
  if (code.startsWith("Numpad") && k in NAV_KEY_VK) return NAV_KEY_VK[k];
  return CODE_VK[code] ?? 0;
}

// Character code for WM_CHAR (Windows-1252), -1 if none.
export function charFromEvent(e: KeyboardEvent): number {
  const k = e.key;
  if (e.ctrlKey && !e.altKey && k.length === 1) {
    const c = k.toUpperCase().charCodeAt(0);
    if (c >= 0x41 && c <= 0x5a) return c - 0x40; // Ctrl+A..Z: control characters 1..26
    return -1;
  }
  if (k === "Enter") return 0x0d;
  if (k === "Backspace") return 0x08;
  if (k === "Tab") return 0x09;
  if (k === "Escape") return 0x1b;
  if (k.length !== 1) return -1;
  const u = k.charCodeAt(0);
  if (u >= 0x20 && u < 0x80) return u;
  if (u >= 0xa0 && u <= 0xff) return u;
  const i = CP1252_HIGH.indexOf(k);
  return i >= 0 ? 0x80 + i : -1;
}

export function attachInput(canvas: HTMLCanvasElement, frameW: number, frameH: number, sink: InputSink): void {
  const t = (e: Event): number => Math.floor(e.timeStamp) >>> 0;
  let active = document.hasFocus() && document.visibilityState === "visible";

  window.addEventListener("keydown", (e: KeyboardEvent) => {
    // Alt combinations and F10 are WM_SYSKEYDOWN in Windows; the engine ignores them.
    if (e.altKey || e.key === "Alt" || e.code === "F10" || e.isComposing || e.key === "Dead" || e.key === "Process") return;
    const vk = vkFromEvent(e);
    if (vk === 0) return;
    if (!e.ctrlKey && !e.metaKey) e.preventDefault();
    sink(IN_KEYDOWN, vk, e.repeat ? 1 : 0, t(e));
    const ch = charFromEvent(e);
    if (ch >= 0) sink(IN_CHAR, ch, e.repeat ? 1 : 0, t(e));
  });
  window.addEventListener("keyup", (e: KeyboardEvent) => {
    if (e.key === "Alt" || e.code === "F10") return;
    const vk = vkFromEvent(e);
    if (vk === 0) return;
    if (!e.ctrlKey && !e.metaKey) e.preventDefault();
    sink(IN_KEYUP, vk, 0, t(e));
  });

  const pos = (e: PointerEvent): [number, number] => {
    const r = canvas.getBoundingClientRect();
    return [Math.floor((e.clientX - r.left) * frameW / r.width), Math.floor((e.clientY - r.top) * frameH / r.height)];
  };
  canvas.addEventListener("pointermove", (e: PointerEvent) => {
    const [x, y] = pos(e);
    sink(IN_MOUSEMOVE, x, y, t(e));
  });
  canvas.addEventListener("pointerdown", (e: PointerEvent) => {
    canvas.focus();
    canvas.setPointerCapture(e.pointerId); // SetCapture on button down (audio-input.md 3.6)
    const [x, y] = pos(e);
    sink(IN_BUTTONDOWN | (e.button << 8), x, y, t(e));
    e.preventDefault();
  });
  canvas.addEventListener("pointerup", (e: PointerEvent) => {
    const [x, y] = pos(e);
    sink(IN_BUTTONUP | (e.button << 8), x, y, t(e));
    if (canvas.hasPointerCapture(e.pointerId)) canvas.releasePointerCapture(e.pointerId);
  });
  canvas.addEventListener("contextmenu", (e: Event) => e.preventDefault());

  // Focus: WM_ACTIVATE model (timing.md 2.5, 9 rule 6). One event per state change.
  const setActive = (on: boolean, e: Event): void => {
    if (on === active) return;
    active = on;
    sink(on ? IN_FOCUS_GAINED : IN_FOCUS_LOST, 0, 0, t(e));
  };
  window.addEventListener("blur", (e: Event) => setActive(false, e));
  window.addEventListener("focus", (e: Event) => setActive(true, e));
  document.addEventListener("visibilitychange", (e: Event) => {
    setActive(document.visibilityState === "visible" && document.hasFocus(), e);
  });
}
