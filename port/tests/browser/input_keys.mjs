// M6 test (d): KeyboardEvent to Windows virtual key, WM_CHAR (cp1252), system keys, default
// action blocking, and pointer mapping (host/input.ts; analysis/audio-input.md 3.2, 3.5, 5). Run:
//   tools/bin/web-test port/tests/browser/input_keys.mjs
// 1. Table: synthetic KeyboardEvents (layouts US, German, French, Russian; NumLock on and off)
//    through vkFromEvent, charFromEvent, isSysKey, blocksDefault; cp1252().
// 2. Trusted key presses (Playwright) through attachInput: events sent to port_input and
//    defaultPrevented per key.
// 3. Trusted pointer events at integer scale 2: frame pixels, move dedupe, left capture,
//    chorded right button, middle button ignored; framePos at device pixel ratio 1.5.
const VK = (c) => c.charCodeAt(0);
const NO = -1;
// [code, key, modifiers (c ctrl, a alt, s shift, m meta), vk, char, block]; vk "SYS": WM_SYSKEYDOWN
const TABLE = [
  ["ArrowLeft", "ArrowLeft", "", 0x25, NO, 1], ["ArrowRight", "ArrowRight", "", 0x27, NO, 1],
  ["ArrowUp", "ArrowUp", "", 0x26, NO, 1], ["ArrowDown", "ArrowDown", "", 0x28, NO, 1],
  ["Space", " ", "", 0x20, 0x20, 1],
  ["KeyY", "y", "", 0x59, 0x79, 1], ["KeyY", "Y", "s", 0x59, 0x59, 1], ["KeyN", "n", "", 0x4e, 0x6e, 1],
  ["KeyZ", "y", "", 0x59, 0x79, 1], // German: VK follows the layout
  ["KeyQ", "a", "", 0x41, 0x61, 1], // French
  ["KeyA", "ф", "", 0x41, NO, 1], // Russian: VK by position; ф is not in cp1252
  ["Digit2", "é", "", 0x32, 0xe9, 1], ["Digit6", "-", "", 0x36, 0x2d, 1], // French digit row
  ["KeyM", ",", "", 0xbc, 0x2c, 1], // French: VK_OEM_COMMA ("any country" OEM key)
  ["NumpadDecimal", ".", "", 0x6e, 0x2e, 1], ["NumpadDecimal", ",", "", 0x6e, 0x2c, 1],
  ["NumpadMultiply", "*", "", 0x6a, 0x2a, 1], ["NumpadAdd", "+", "", 0x6b, 0x2b, 1],
  ["NumpadSubtract", "-", "", 0x6d, 0x2d, 1], ["NumpadDivide", "/", "", 0x6f, 0x2f, 1],
  ["NumpadEnter", "Enter", "", 0x0d, 0x0d, 1],
  ["NumpadDecimal", "Delete", "", 0x2e, NO, 1], ["Numpad5", "Clear", "", 0x0c, NO, 0], // NumLock off
  ["Numpad1", "End", "", 0x23, NO, 1], ["Numpad8", "ArrowUp", "", 0x26, NO, 1], ["Numpad0", "Insert", "", 0x2d, NO, 0],
  ["F1", "F1", "", 0x70, NO, 0], ["F2", "F2", "", 0x71, NO, 0], ["F3", "F3", "", 0x72, NO, 1],
  ["F4", "F4", "", 0x73, NO, 1], ["F5", "F5", "", 0x74, NO, 1], ["F6", "F6", "", 0x75, NO, 0],
  ["F7", "F7", "", 0x76, NO, 0], ["F8", "F8", "", 0x77, NO, 0], ["F9", "F9", "", 0x78, NO, 0],
  ["F10", "F10", "", "SYS", NO, 0], ["F11", "F11", "", 0x7a, NO, 0], ["F12", "F12", "", 0x7b, NO, 0],
  ["Escape", "Escape", "", 0x1b, 0x1b, 1], ["Enter", "Enter", "", 0x0d, 0x0d, 1], ["Enter", "Enter", "s", 0x0d, 0x0d, 1],
  ["Backspace", "Backspace", "", 0x08, 0x08, 1], ["Tab", "Tab", "", 0x09, 0x09, 1], ["Tab", "Tab", "s", 0x09, 0x09, 1],
  ["Delete", "Delete", "", 0x2e, NO, 1], ["Home", "Home", "", 0x24, NO, 1], ["End", "End", "", 0x23, NO, 1],
  ["PageUp", "PageUp", "", 0x21, NO, 1], ["PageDown", "PageDown", "", 0x22, NO, 1], ["Insert", "Insert", "", 0x2d, NO, 0],
  ["ShiftLeft", "Shift", "s", 0x10, NO, 0], ["ShiftRight", "Shift", "s", 0x10, NO, 0],
  ["ControlLeft", "Control", "c", 0x11, NO, 0], ["ControlRight", "Control", "c", 0x11, NO, 0],
  ["AltLeft", "Alt", "a", "SYS", NO, 0], ["MetaLeft", "Meta", "m", 0x5b, NO, 0], ["CapsLock", "CapsLock", "", 0x14, NO, 0],
  ["ContextMenu", "ContextMenu", "", 0x5d, NO, 0], ["Pause", "Pause", "", 0x13, NO, 0], ["NumLock", "NumLock", "", 0x90, NO, 0],
  ["Equal", "=", "", 0xbb, 0x3d, 1], ["Equal", "+", "s", 0xbb, 0x2b, 1], ["BracketRight", "+", "", 0xbb, 0x2b, 1],
  ["Slash", "-", "", 0xbd, 0x2d, 1], ["Semicolon", ";", "", 0xba, 0x3b, 1], ["Quote", "'", "", 0xde, 0x27, 1],
  ["IntlBackslash", "<", "", 0xe2, 0x3c, 1], ["Backquote", "`", "", 0xc0, 0x60, 1], ["BracketLeft", "[", "", 0xdb, 0x5b, 1],
  ["Backslash", "\\", "", 0xdc, 0x5c, 1], ["Minus", "-", "", 0xbd, 0x2d, 1], ["Period", ".", "", 0xbe, 0x2e, 1],
  ["Comma", ",", "", 0xbc, 0x2c, 1], ["Slash", "/", "", 0xbf, 0x2f, 1],
  ["KeyC", "c", "c", 0x43, 0x03, 0], ["KeyP", "p", "c", 0x50, 0x10, 0], ["KeyQ", "q", "c", 0x51, 0x11, 0],
  ["Enter", "Enter", "c", 0x0d, 0x0a, 0], ["Space", " ", "c", 0x20, 0x20, 0], ["BracketLeft", "[", "c", 0xdb, 0x1b, 0],
  ["Digit1", "1", "c", 0x31, NO, 0],
  ["KeyY", "y", "a", "SYS", NO, 0], ["KeyN", "n", "a", "SYS", NO, 0], ["F4", "F4", "a", "SYS", NO, 0],
  ["ArrowLeft", "ArrowLeft", "a", "SYS", NO, 0], ["F10", "F10", "s", "SYS", NO, 0],
  ["KeyQ", "@", "ca", 0x51, 0x40, 0], ["KeyE", "€", "ca", 0x45, 0x80, 0], // AltGr as Ctrl+Alt
  ["KeyE", "€", "", 0x45, 0x80, 1], // AltGr on Linux (no modifier flags)
  ["BracketLeft", "Dead", "", 0xdb, NO, 1], // dead key: WM_KEYDOWN, no WM_CHAR
  ["", "Unidentified", "", 0, NO, 0],
];
for (let c = 0x41; c <= 0x5a; c++) {
  const L = String.fromCharCode(c);
  TABLE.push([`Key${L}`, L.toLowerCase(), "", c, c + 0x20, 1]);
}
for (let d = 0; d <= 9; d++) {
  TABLE.push([`Digit${d}`, String(d), "", 0x30 + d, 0x30 + d, 1]);
  TABLE.push([`Numpad${d}`, String(d), "", 0x60 + d, 0x30 + d, 1]); // incl. 0x63/0x64/0x65/0x69 = 'c' 'd' 'e' 'i'
}
const CP1252 = [["€", 0x80], ["Š", 0x8a], ["Ÿ", 0x9f], ["ÿ", 0xff], [" ", 0xa0], ["~", 0x7e], ["\u0081", 0x81],
  ["Ā", NO], ["中", NO], ["😀", NO], ["ab", NO]];

export default async function ({ page, baseURL, assert, log }) {
  await page.setViewportSize({ width: 1700, height: 1250 });
  await page.route("**/m6-blank.html", (r) =>
    r.fulfill({
      contentType: "text/html",
      body: "<!doctype html><title>m6</title><style>body{margin:0}#c{position:absolute;left:10px;top:20px;" +
        "width:1600px;height:1144px}</style><canvas id=c width=800 height=572 tabindex=0></canvas>",
    }));
  await page.goto(`${baseURL}/m6-blank.html`);

  // 1. Table.
  const res = await page.evaluate(async ({ table, cp }) => {
    const I = await import("/input.js");
    const rows = table.map(([code, key, mods]) => {
      const e = new KeyboardEvent("keydown", {
        code, key, ctrlKey: mods.includes("c"), altKey: mods.includes("a"), shiftKey: mods.includes("s"), metaKey: mods.includes("m"),
      });
      const sys = I.isSysKey(e);
      const vk = I.vkFromEvent(e);
      return [sys ? "SYS" : vk, I.charFromEvent(e), sys ? 0 : I.blocksDefault(vk, e) ? 1 : 0];
    });
    return { rows, cp: cp.map(([c]) => I.cp1252(c)) };
  }, { table: TABLE, cp: CP1252 });
  const hex = (v) => (typeof v === "number" && v >= 0 ? `0x${v.toString(16)}` : String(v));
  let bad = 0;
  TABLE.forEach(([code, key, mods, vk, ch, block], i) => {
    const [gvk, gch, gblock] = res.rows[i];
    if (gvk !== vk || gch !== ch || (vk !== "SYS" && gblock !== block)) {
      bad++;
      log(`MISMATCH ${code}/${JSON.stringify(key)}/${mods}: vk ${hex(gvk)} want ${hex(vk)}, char ${hex(gch)} want ${hex(ch)}, block ${gblock} want ${block}`);
    }
  });
  CP1252.forEach(([c, want], i) => {
    if (res.cp[i] !== want) {
      bad++;
      log(`MISMATCH cp1252(${JSON.stringify(c)}) = ${res.cp[i]} want ${want}`);
    }
  });
  log(`key table: ${TABLE.length} key events, ${CP1252.length} cp1252 cases, ${bad} mismatches`);
  assert.equal(bad, 0, "key table");

  // 2. Trusted key presses through attachInput.
  await page.evaluate(async () => {
    const I = await import("/input.js");
    window.m6marker = 1; // a reload (F5) would remove it
    window.ev = [];
    window.prev = [];
    const c = document.getElementById("c");
    I.attachInput(c, 800, 572, (k, a, b) => window.ev.push([k, a, b]), (on) => window.ev.push(["active", on]));
    window.addEventListener("keydown", (e) => window.prev.push(`${e.code}:${e.defaultPrevented ? "P" : "-"}`));
    c.focus();
  });
  const take = () => page.evaluate(() => {
    const r = { ev: window.ev, prev: window.prev.join(" ") };
    window.ev = [];
    window.prev = [];
    return r;
  });
  const cdp = await page.context().newCDPSession(page);
  const numpad = async (code, key, vk) => {
    const base = { code, key, windowsVirtualKeyCode: vk, nativeVirtualKeyCode: vk, location: 3 };
    await cdp.send("Input.dispatchKeyEvent", { type: "keyDown", text: key, unmodifiedText: key, ...base });
    await cdp.send("Input.dispatchKeyEvent", { type: "keyUp", ...base });
  };
  const K = (vk, rep = 0) => [[1, vk, rep]];
  const C = (ch, rep = 0) => [[9, ch, rep]];
  const U = (vk) => [[2, vk, 0]];
  const cases = [
    ["press ArrowLeft", (k) => k.press("ArrowLeft"), [...K(0x25), ...U(0x25)], "ArrowLeft:P"],
    ["Space", (k) => k.press("Space"), [...K(0x20), ...C(0x20), ...U(0x20)], "Space:P"],
    ["KeyY held (auto-repeat)", async (k) => { await k.down("KeyY"); await k.down("KeyY"); await k.up("KeyY"); },
      [...K(0x59), ...C(0x79), ...K(0x59, 1), ...C(0x79, 1), ...U(0x59)], "KeyY:P KeyY:P"],
    ["F10 (WM_SYSKEYDOWN)", (k) => k.press("F10"), [], "F10:-"],
    ["F5 (credits quirk 't'; no reload)", (k) => k.press("F5"), [...K(0x74), ...U(0x74)], "F5:P"],
    ["F3", (k) => k.press("F3"), [...K(0x72), ...U(0x72)], "F3:P"],
    ["F4", (k) => k.press("F4"), [...K(0x73), ...U(0x73)], "F4:P"],
    ["F2 (not used: browser keeps it)", (k) => k.press("F2"), [...K(0x71), ...U(0x71)], "F2:-"],
    ["Alt+KeyY (WM_SYSKEYDOWN; key-up kept)", (k) => k.press("Alt+KeyY"), [...U(0x59)], "AltLeft:- KeyY:-"],
    // Playwright numpad keys behave as with NumLock off: VK_DELETE, VK_NEXT (Windows does the same).
    ["NumpadDecimal, NumLock off", (k) => k.press("NumpadDecimal"), [...K(0x2e), ...U(0x2e)], "NumpadDecimal:P"],
    ["Numpad3, NumLock off", (k) => k.press("Numpad3"), [...K(0x22), ...U(0x22)], "Numpad3:P"],
    // NumLock on through CDP Input.dispatchKeyEvent (location 3 = numpad).
    ["NumpadDecimal, NumLock on (VK_DECIMAL, 'n' quirk)", () => numpad("NumpadDecimal", ".", 110), [...K(0x6e), ...C(0x2e), ...U(0x6e)], "NumpadDecimal:P"],
    ["Numpad3, NumLock on ('c' quirk)", () => numpad("Numpad3", "3", 99), [...K(0x63), ...C(0x33), ...U(0x63)], "Numpad3:P"],
    ["Numpad5, NumLock on ('e' quirk)", () => numpad("Numpad5", "5", 101), [...K(0x65), ...C(0x35), ...U(0x65)], "Numpad5:P"],
    ["Shift+KeyA", (k) => k.press("Shift+KeyA"), [...K(0x10), ...K(0x41), ...C(0x41), ...U(0x41), ...U(0x10)], "ShiftLeft:- KeyA:P"],
    ["Control+KeyC", (k) => k.press("Control+KeyC"), [...K(0x11), ...K(0x43), ...C(0x03), ...U(0x43), ...U(0x11)], "ControlLeft:- KeyC:-"],
    ["Enter", (k) => k.press("Enter"), [...K(0x0d), ...C(0x0d), ...U(0x0d)], "Enter:P"],
    ["Escape", (k) => k.press("Escape"), [...K(0x1b), ...C(0x1b), ...U(0x1b)], "Escape:P"],
    ["Tab", (k) => k.press("Tab"), [...K(0x09), ...C(0x09), ...U(0x09)], "Tab:P"],
    ["type credits", (k) => k.type("credits"),
      [..."credits"].flatMap((c) => [...K(VK(c.toUpperCase())), ...C(VK(c)), ...U(VK(c.toUpperCase()))]),
      [..."CREDITS"].map((c) => `Key${c}:P`).join(" ")],
  ];
  let kbad = 0;
  for (const [name, act, ev, prev] of cases) {
    await act(page.keyboard);
    const got = await take();
    const ok = JSON.stringify(got.ev) === JSON.stringify(ev) && got.prev === prev;
    if (!ok) kbad++;
    log(`${ok ? "ok  " : "FAIL"} ${name}: ${JSON.stringify(got.ev)} prevented [${got.prev}]${ok ? "" : ` want ${JSON.stringify(ev)} [${prev}]`}`);
  }
  assert.equal(await page.evaluate(() => window.m6marker), 1, "page not reloaded by F5");
  assert.equal(kbad, 0, "trusted key presses");

  // 3. Pointer: canvas at (10, 20), 1600 x 1144 CSS px = scale 2 at device pixel ratio 1.
  const P = (x, y) => [10 + 2 * x + 1, 20 + 2 * y + 1];
  const m = page.mouse;
  const steps = [
    ["move to (100, 50)", () => m.move(...P(100, 50)), [[3, 100, 50]]],
    ["move inside the same frame pixel", () => m.move(10 + 200 + 1.5, 20 + 100 + 1.5), []],
    ["left down", () => m.down(), [[4, 100, 50]]],
    ["right down (chord)", () => m.down({ button: "right" }), [[4 | 0x200, 100, 50]]],
    ["right up (chord)", () => m.up({ button: "right" }), [[5 | 0x200, 100, 50]]],
    ["move outside with left captured", () => m.move(5, 5), [[3, -3, -8]]],
    ["left up outside", () => m.up(), [[5, -3, -8]]],
    ["middle click (ignored)", async () => { await m.move(...P(10, 10)); await m.down({ button: "middle" }); await m.up({ button: "middle" }); }, [[3, 10, 10]]],
    ["right click", async () => { await m.down({ button: "right" }); await m.up({ button: "right" }); }, [[4 | 0x200, 10, 10], [5 | 0x200, 10, 10]]],
    ["move to (799, 571)", () => m.move(...P(799, 571)), [[3, 799, 571]]],
    ["move to (0, 0)", () => m.move(...P(0, 0)), [[3, 0, 0]]],
    ["left drag from outside into the canvas, release inside (no button message)", async () => {
      await m.move(5, 5); await m.down(); await m.move(...P(20, 30)); await m.up();
    }, [[3, 20, 30]]],
  ];
  let pbad = 0;
  await take();
  for (const [name, act, ev] of steps) {
    await act();
    const got = (await take()).ev;
    const ok = JSON.stringify(got) === JSON.stringify(ev);
    if (!ok) pbad++;
    log(`${ok ? "ok  " : "FAIL"} pointer ${name}: ${JSON.stringify(got)}${ok ? "" : ` want ${JSON.stringify(ev)}`}`);
  }
  assert.equal(pbad, 0, "pointer events");

  // framePos at device pixel ratio 1.5, integer scale 2 (CSS width 800 * 2 / 1.5).
  const fp = await page.evaluate(async () => {
    const I = await import("/input.js");
    const r = { left: 3.25, top: 7.5, width: (800 * 2) / 1.5, height: (572 * 2) / 1.5 };
    let wrong = 0;
    for (let x = 0; x < 800; x++) {
      for (const f of [0.01, 0.5, 0.99]) {
        const cx = r.left + ((x + f) * r.width) / 800;
        const cy = r.top + (((x % 572) + f) * r.height) / 572;
        const [gx, gy] = I.framePos(cx, cy, r, 800, 572);
        if (gx !== x || gy !== x % 572) wrong++;
      }
    }
    return wrong;
  });
  log(`framePos at dpr 1.5, scale 2: 2400 points, ${fp} wrong`);
  assert.equal(fp, 0, "framePos");
}
