// Browser input capture (M1, M6; analysis/audio-input.md 3 and 5, timing.md 9 rules 5 and 6).
// Sends events to port_input with event.timeStamp, the time base of requestAnimationFrame.
// Kinds: src/core/input.h. The C side applies every Win32 rule that does not need the browser
// (engine key codes, VK_RETURN key-down drop, Escape pause, capture coordinates).

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

const VK_MENU = 0x12;
const VK_F10 = 0x79;

// KeyboardEvent.code to Windows virtual key (US positions). Letters and the four
// layout-independent OEM characters follow the layout (vkFromEvent).
const CODE_VK: Record<string, number> = {
  Backspace: 0x08, Tab: 0x09, NumpadClear: 0x0c, Enter: 0x0d, NumpadEnter: 0x0d, ShiftLeft: 0x10,
  ShiftRight: 0x10, ControlLeft: 0x11, ControlRight: 0x11, AltLeft: VK_MENU, AltRight: VK_MENU,
  Pause: 0x13, CapsLock: 0x14, KanaMode: 0x15, Lang1: 0x15, Lang2: 0x19, Convert: 0x1c,
  NonConvert: 0x1d, Escape: 0x1b, Space: 0x20, PageUp: 0x21, PageDown: 0x22, End: 0x23, Home: 0x24,
  ArrowLeft: 0x25, ArrowUp: 0x26, ArrowRight: 0x27, ArrowDown: 0x28, Insert: 0x2d, Delete: 0x2e,
  MetaLeft: 0x5b, MetaRight: 0x5c, OSLeft: 0x5b, OSRight: 0x5c, ContextMenu: 0x5d,
  Numpad0: 0x60, Numpad1: 0x61, Numpad2: 0x62, Numpad3: 0x63, Numpad4: 0x64, Numpad5: 0x65,
  Numpad6: 0x66, Numpad7: 0x67, Numpad8: 0x68, Numpad9: 0x69, NumpadMultiply: 0x6a,
  NumpadAdd: 0x6b, NumpadComma: 0x6c, NumpadSubtract: 0x6d, NumpadDecimal: 0x6e, NumpadDivide: 0x6f,
  F1: 0x70, F2: 0x71, F3: 0x72, F4: 0x73, F5: 0x74, F6: 0x75, F7: 0x76, F8: 0x77, F9: 0x78,
  F10: VK_F10, F11: 0x7a, F12: 0x7b, F13: 0x7c, F14: 0x7d, F15: 0x7e, F16: 0x7f, F17: 0x80,
  F18: 0x81, F19: 0x82, F20: 0x83, F21: 0x84, F22: 0x85, F23: 0x86, F24: 0x87,
  NumLock: 0x90, ScrollLock: 0x91,
  Semicolon: 0xba, Equal: 0xbb, Comma: 0xbc, Minus: 0xbd, Period: 0xbe, Slash: 0xbf, Backquote: 0xc0,
  IntlRo: 0xc1, BracketLeft: 0xdb, Backslash: 0xdc, IntlYen: 0xdc, BracketRight: 0xdd, Quote: 0xde,
  IntlBackslash: 0xe2,
};

// Numpad keys with NumLock off: Windows sends the navigation virtual keys (key gives the name).
const NAV_KEY_VK: Record<string, number> = {
  Insert: 0x2d, End: 0x23, ArrowDown: 0x28, PageDown: 0x22, ArrowLeft: 0x25, Clear: 0x0c,
  ArrowRight: 0x27, Home: 0x24, ArrowUp: 0x26, PageUp: 0x21, Delete: 0x2e,
};

// VK_OEM_PLUS, VK_OEM_COMMA, VK_OEM_MINUS, VK_OEM_PERIOD: "for any country/region, the '+' (',',
// '-', '.') key" (Windows virtual-key documentation); the other OEM keys vary by layout.
const OEM_CHAR_VK: Record<string, number> = { "+": 0xbb, ",": 0xbc, "-": 0xbd, ".": 0xbe };

const own = (r: Record<string, number>, k: string): number | undefined => (Object.hasOwn(r, k) ? r[k] : undefined);

// Windows VK for a key event, 0 if the key has no mapping.
export function vkFromEvent(e: KeyboardEvent): number {
  const k = e.key;
  const code = e.code;
  // Numpad: VK by position (VK_NUMPAD0..9, VK_DECIMAL 0x6e also on layouts with a ',' key), or
  // the navigation VK when NumLock is off.
  if (code.startsWith("Numpad")) return own(NAV_KEY_VK, k) ?? own(CODE_VK, code) ?? 0;
  if (/^[A-Za-z]$/.test(k)) return k.toUpperCase().charCodeAt(0); // VK_A..VK_Z follow the layout
  const oem = code.startsWith("Digit") ? undefined : own(OEM_CHAR_VK, k);
  if (oem !== undefined) return oem;
  // Layouts without Latin letters keep VK_A..VK_Z on the letter positions (audio-input.md 5).
  if (/^Key[A-Z]$/.test(code)) return code.charCodeAt(3);
  if (/^Digit[0-9]$/.test(code)) return code.charCodeAt(5); // VK_0..VK_9 by position
  return own(CODE_VK, code) ?? 0;
}

// Windows-1252 codes 0x80..0x9f; the five undefined codes map to the same C1 code point, as
// MultiByteToWideChar does.
const CP1252_HIGH = "€\u0081‚ƒ„…†‡ˆ‰Š‹Œ\u008dŽ\u008f\u0090‘’“”•–—˜™š›œ\u009džŸ";

// Windows-1252 code of one character, -1 if it is not in the code page.
export function cp1252(ch: string): number {
  if (ch.length !== 1) return -1;
  const u = ch.charCodeAt(0);
  if (u < 0x80 || (u >= 0xa0 && u <= 0xff)) return u;
  const i = CP1252_HIGH.indexOf(ch);
  return i >= 0 ? 0x80 + i : -1;
}

// True when Windows posts WM_SYSKEYDOWN/WM_SYSKEYUP, not WM_KEYDOWN/WM_KEYUP: F10, and any key
// while Alt is down and Ctrl is not (inferred from the WM_SYSKEYDOWN documentation and the
// ReactOS keyboard code; Ctrl+Alt, as AltGr, gives normal key messages). The engine WndProc
// has no case for these (audio-input.md 3.2), so they never reach the game.
export function isSysKey(e: KeyboardEvent): boolean {
  if (e.code === "F10" || e.key === "F10") return true;
  return (e.altKey || e.key === "Alt") && !e.ctrlKey;
}

// WM_CHAR code (Windows-1252) that TranslateMessage makes for the key-down, -1 if none.
export function charFromEvent(e: KeyboardEvent): number {
  if (isSysKey(e)) return -1; // WM_SYSCHAR, not WM_CHAR
  const k = e.key;
  if (e.ctrlKey && !e.altKey) {
    if (/^[A-Za-z]$/.test(k)) return k.toUpperCase().charCodeAt(0) - 0x40; // Ctrl+A..Z: 1..26
    if (k === " ") return 0x20;
    if (k === "Enter") return 0x0a;
    if (k === "Backspace") return 0x7f;
    if (k === "[" || k === "\\" || k === "]") return k.charCodeAt(0) - 0x40; // 0x1b, 0x1c, 0x1d
    return -1;
  }
  if (k === "Enter") return 0x0d;
  if (k === "Backspace") return 0x08;
  if (k === "Tab") return 0x09;
  if (k === "Escape") return 0x1b;
  return cp1252(k); // Ctrl+Alt (AltGr) characters as typed
}

// Keys whose browser default action the page blocks while it has focus: keys the game or the
// shell reads (arrows, Space, letters, digits, numpad incl. VK_DECIMAL, Enter, Escape, Tab,
// Backspace, Delete, Home, End, text keys for the name box) and the quirk keys F3, F4, F5 (the
// game takes them as 'r', 's', 't' of "credits"; decisions.md item 10, provisional). F1, F2,
// F6..F12 and every Ctrl, Alt or Meta combination keep their browser action.
export function blocksDefault(vk: number, e: KeyboardEvent): boolean {
  if (e.ctrlKey || e.altKey || e.metaKey) return false;
  return (
    vk === 0x08 || vk === 0x09 || vk === 0x0d || vk === 0x1b || (vk >= 0x20 && vk <= 0x28) || vk === 0x2e ||
    (vk >= 0x30 && vk <= 0x39) || (vk >= 0x41 && vk <= 0x5a) || (vk >= 0x60 && vk <= 0x6f) ||
    (vk >= 0x72 && vk <= 0x74) || (vk >= 0xba && vk <= 0xc1) || (vk >= 0xdb && vk <= 0xdf) || vk === 0xe2
  );
}

export interface Rect {
  left: number;
  top: number;
  width: number;
  height: number;
}

// Client coordinates (CSS px) to frame pixels. The canvas shows each frame pixel as an integer
// number of device pixels (main.ts fitCanvas), so one frame pixel = rect.width / frameW CSS px.
// Points outside the canvas give values outside 0..frameW-1 (signed, as WM_MOUSEMOVE).
export function framePos(clientX: number, clientY: number, r: Rect, frameW: number, frameH: number): [number, number] {
  return [Math.floor(((clientX - r.left) * frameW) / r.width), Math.floor(((clientY - r.top) * frameH) / r.height)];
}

// onActive(false) on focus loss, onActive(true) on focus gain (audio mute, decision 12).
export function attachInput(
  canvas: HTMLCanvasElement,
  frameW: number,
  frameH: number,
  sink: InputSink,
  onActive?: (active: boolean) => void,
): void {
  const t = (e: Event): number => Math.floor(e.timeStamp) >>> 0;
  // The C side starts active (the click-to-start gesture gives the page focus).
  let active = true;
  let buttons = 0; // PointerEvent.buttons bits sent so far: 1 left, 2 right
  let lastX = NaN; // last position sent (frame pixels)
  let lastY = NaN;

  window.addEventListener("keydown", (e: KeyboardEvent) => {
    if (e.isComposing || e.key === "Process") return; // input method editor
    // F10 (VK 0x79, also the 'y' of the game's Y test) and Alt combinations: WM_SYSKEYDOWN.
    if (isSysKey(e)) return;
    const vk = vkFromEvent(e);
    if (vk === VK_MENU || e.key === "AltGraph") return; // AltGr itself: no key message sent
    const rep = e.repeat ? 1 : 0;
    if (vk !== 0) sink(IN_KEYDOWN, vk, rep, t(e));
    if (e.key !== "Dead") {
      const ch = charFromEvent(e);
      if (ch >= 0) sink(IN_CHAR, ch, rep, t(e));
    }
    if (active && blocksDefault(vk, e)) e.preventDefault();
  });
  window.addEventListener("keyup", (e: KeyboardEvent) => {
    if (e.isComposing) return;
    const vk = vkFromEvent(e);
    // Key-ups also come with Alt down (WM_SYSKEYUP updates GetKeyState as well; the game reads
    // no key-up event), so no key stays down. F10 and Alt: no key-down was sent.
    if (vk === 0 || vk === VK_MENU || vk === VK_F10) return;
    sink(IN_KEYUP, vk, 0, t(e));
    if (active && blocksDefault(vk, e)) e.preventDefault();
  });

  const pos = (e: PointerEvent): [number, number] =>
    framePos(e.clientX, e.clientY, canvas.getBoundingClientRect(), frameW, frameH);
  // Left (bit 1, DOM button 0) and right (bit 2, DOM button 2) only: the WndProc has no case
  // for the middle button (audio-input.md 3.2). Chorded presses arrive as pointermove.
  const syncButtons = (e: PointerEvent, x: number, y: number): void => {
    const now = e.buttons & 3;
    for (const [bit, dom] of [[1, 0], [2, 2]]) {
      if ((now & bit) === (buttons & bit)) continue;
      const down = (now & bit) !== 0;
      sink((down ? IN_BUTTONDOWN : IN_BUTTONUP) | (dom << 8), x, y, t(e));
      // SetCapture on left down, ReleaseCapture on left up (audio-input.md 3.6).
      if (dom === 0 && down) canvas.setPointerCapture(e.pointerId);
      if (dom === 0 && !down && canvas.hasPointerCapture(e.pointerId)) canvas.releasePointerCapture(e.pointerId);
      lastX = x;
      lastY = y;
    }
    buttons = now;
  };
  // Moves and releases are taken on window: events on the canvas, plus any event during a left
  // drag (the captured case of the original) when the browser has dropped the capture.
  const mine = (e: PointerEvent): boolean => e.target === canvas || (buttons & 1) !== 0;
  window.addEventListener("pointermove", (e: PointerEvent) => {
    if (!mine(e)) return;
    const [x, y] = pos(e);
    // The original window is at 1:1 scale: Windows sends WM_MOUSEMOVE only when the pixel
    // changes, and none for a button change.
    if (x !== lastX || y !== lastY) {
      sink(IN_MOUSEMOVE, x, y, t(e));
      lastX = x;
      lastY = y;
    }
    // A chorded press or release comes as pointermove with button >= 0. A drag that started
    // outside the canvas (button -1) gives no button message, as on Windows.
    if (e.button >= 0) syncButtons(e, x, y);
  });
  canvas.addEventListener("pointerdown", (e: PointerEvent) => {
    canvas.focus();
    const [x, y] = pos(e);
    syncButtons(e, x, y);
    e.preventDefault();
  });
  const up = (e: PointerEvent): void => {
    if (!mine(e)) return;
    const [x, y] = pos(e);
    syncButtons(e, x, y);
  };
  window.addEventListener("pointerup", up);
  window.addEventListener("pointercancel", up);
  canvas.addEventListener("contextmenu", (e: Event) => e.preventDefault());
  // Chromium drops the capture after a chorded right-button release (verified: headless
  // Chromium 153, port/tests/browser/input_keys.mjs); take it back while the left button is down.
  canvas.addEventListener("lostpointercapture", (e: PointerEvent) => {
    if (buttons & 1) {
      try {
        canvas.setPointerCapture(e.pointerId);
      } catch {
        // pointer no longer active
      }
    }
  });

  // Focus: WM_ACTIVATE model (timing.md 2.5, 9 rule 6). One event per state change. The C side
  // releases every key and button on focus loss; the host forgets its button state too.
  const setActive = (on: boolean, e: Event): void => {
    if (on === active) return;
    active = on;
    if (!on) buttons = 0;
    sink(on ? IN_FOCUS_GAINED : IN_FOCUS_LOST, 0, 0, t(e));
    onActive?.(on);
  };
  window.addEventListener("blur", (e: Event) => setActive(false, e));
  window.addEventListener("focus", (e: Event) => setActive(true, e));
  document.addEventListener("visibilitychange", (e: Event) => {
    setActive(document.visibilityState === "visible" && document.hasFocus(), e);
  });
}
