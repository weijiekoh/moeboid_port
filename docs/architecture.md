# Moeboid browser port: architecture proposal (phase 1)

Date: 2026-10-11. Status: proposal for decision by the user. Phase 2 does not start before the decisions in section 6.

Inputs: `analysis/interface.md`, `analysis/interface.tsv` (B), `analysis/timing.md` (C), `analysis/rendering.md` (D), `analysis/fonts.md` (E), `analysis/audio-input.md` (F), `analysis/shell.md` (G), `assets/INDEX.md` (H), `analysis/reference/NOTES.md` (I), `analysis/verification.md` (J), `analysis/decomp/README.md` (A).
Notation: [V] = verified in the referenced document; [I] = inferred; [X] = external knowledge, not verified in this project.

## 1. Facts that drive the design

| # | Fact | Source |
|---|---|---|
| F1 | Game logic is small: 5465 instructions (about 16 KB) of game code at `G:0x10001000..0x10005110`, 72 functions, plus a static MSVC6 CRT. Whole `.text`: 15674 instructions, 88 distinct mnemonics (58 in game code). | [V] `analysis/decomp/Moeboid.gam/listing.asm`, verification.md 1.5 |
| F2 | The game talks to the engine only through 13 interfaces, 54 (interface, offset) pairs, 46 distinct behaviours. All methods are `__thiscall` with 32-bit integer arguments, callee pops 4 x argc. Engine-to-game: 2 exports and 9 `cdecl` callbacks `int cb(int* e)`. No floating-point values cross the boundary. | [V] interface.md 1, 8 |
| F3 | Moeboid.gam imports only KERNEL32 (24 functions called at run time) and has no network code. | [V] interface.md 8, verification.md 5 |
| F4 | Time: the engine busy-polls `GetTickCount`. Game tick 20 ms, render 50 ms, title sequence 100 ms; a timer fires when `now - last >= period`, then `last = now`, no catch-up. Motion uses the elapsed time; acceleration, random turns and key polling are per tick. The real tick rate depended on the OS clock step: 50 Hz (1 or 10 ms step), 32 Hz (15.625 ms, typical XP), 18.2 Hz (Windows 9x). | [V] timing.md 0, 2.3, 5; NOTES.md 4 |
| F5 | Colour: DirectDraw windowed at the desktop depth. No 8-bit frame buffer and no palette effects on a 24/32-bit desktop; GIF RGB values reach the screen unchanged. Transparency is a magenta colour key. A palette exists only on an 8-bit desktop. | [V] rendering.md 0, 3; NOTES.md 4 |
| F6 | Frame: 800x572 borderless window, completely software-drawn (GIF images plus a ZML text renderer). No Win32 menus. Native UI: 8 dialog templates and `MessageBoxA`. | [V] shell.md 0, rendering.md 7 |
| F7 | Text: all engine and game text is Arial 2.82 (8 to 36 px, regular and bold, `DEFAULT_QUALITY`) through `ExtTextOutA`; dialogs use MS Sans Serif 8 pt (13 px strike). No static text has bytes >= 0x80. FreeType mono hinting reproduces all 2674 `hdmx` advance widths of Arial 2.82; glyph-bitmap identity with GDI is not proven (no Windows ground truth). | [V] fonts.md 1, 10.3 |
| F8 | Audio: DirectSound only, one-shot static buffers, raw PCM 8000/11025 Hz, no volume/pan/frequency calls, 16 voices shared, drop when full. | [V] audio-input.md 1 |
| F9 | Input: Win32 messages and `GetKeyState` (arrows polled once per tick); no DirectInput; no mouse coordinates used by the game. Focus loss pauses the game. | [V] audio-input.md 1, 3 |
| F10 | Network: one endpoint (`api.zapspot.com:80`, `POST /1.0.0/<Function>.asp`), telemetry at each start, Mail This, subscribe, ad links. Nothing is downloaded: ads are built-in resources; no `.zdt` file is needed to run. High scores are local (Core.zdt) and never submitted. | [V] shell.md 0, 5, 6 |
| F11 | FPU: the CRT sets 53-bit precision; all game x87 code equals IEEE double arithmetic with float32 rounding at the original store points, except the spawn-position FSIN/FCOS path, which needs a 1000-entry 80-bit table plus one exact rounding (else 1-ulp differences in 6.4 % of inputs can change a retry decision). `__ftol` needs an exact helper. | [V] verification.md 3 |
| F12 | A Unicorn harness already runs the original Moeboid.gam against a mocked engine through every screen, deterministic and replayable (60 s of game time in 1.7 s). | [V] verification.md 0, 1 |
| F13 | DLL-lifetime static variables cause a visible quirk after "play again" (2 stale ticks, player snaps to (240,204) when a key is held). | [V] verification.md 2.2, `analysis/verification/logs/quirk_play_again.log` |

Consequences [I]:
- The engine (ZapSpot.exe) is where every required change lives: ads, network, downloads, accounts, ToS, high-score storage, frame and menu. The game logic needs no change at all.
- The engine surface that the game uses is small and regular (F2). The shell around it (frame, ZML pages, dialogs) is the larger part of the work in every option except pure emulation.
- Exact colour is simple (F5): an RGBA canvas, no palette emulation for the recommended 24/32-bit look.
- Exact text is a font-atlas problem (F7), the same in every option except emulation.

## 2. Options

### 2.1 (a) Hand-port to C, compiled to wasm with clang; thin TypeScript host

- Game logic: port the 72 game functions from the decompiled C to clean C (float32 at store points, double intermediates, `__ftol` helper, FSIN table, MSVC `rand`, DLL-static semantics).
- Engine: reimplement the 46 behaviours plus the shell in C. Host in TypeScript: canvas, Web Audio, input, `localStorage`, click-to-start.
- Exactness: lockstep differential tests against the Unicorn reference (F12). Equality is proven only for the recorded scenarios; 88.5 % of game code bytes are covered so far.
- Maintainability: high; all source readable.
- Risk: porting errors in rare branches; float and integer-width errors. The lockstep harness finds most of them.

### 2.2 (b) Emulation of the original binaries (retrowin32, BoxedWine, v86 plus Wine or Windows)

- [X] retrowin32: Rust x86 emulator plus a partial Win32 reimplementation, with a web build. Its coverage of the engine's API surface (dialogs, GDI TrueType text, DirectDraw windowed, DirectSound, wininet, wsock32, COM shell links) is unknown and likely incomplete.
- [X] BoxedWine: Wine in the browser on an emulated x86 and Linux. Large download (tens of MB, inferred). Wine renders text with FreeType and its own theme: the Wine captures show antialiased, magenta-tinted captions (fonts.md 1.8), and dialogs in the Wine look, not the Windows look.
- [X] v86 plus Windows: needs a Windows image and licence; very large; slow start.
- Changes (ads, network, downloads, ToS, scores) need binary patches of ZapSpot.exe. The busy `PeekMessage` loop takes 100 % of one core (NOTES.md 4) and needs a patch in an emulator.
- Exactness: game logic original, but text, timing (`GetTickCount` step of the emulator) and FSIN (host `sin`, verification.md 5) are not exact without emulator changes.
- Maintainability: low (binary patches, external emulator). Effort to "it runs": low. Effort to "exact": high and uncertain.

### 2.3 (c) Pure TypeScript rewrite

- Same structure as (a), all in TypeScript.
- JavaScript has only double numbers: `Math.fround` at each float store, explicit uint32 wrap, BigInt for the FSIN path, explicit `__ftol`. These are the errors that are easy to make (verification.md 5, 6: most divergence fixing).
- No native build for fast lockstep runs; tests run in node.
- Maintainability: good. Effort: like (a), more iterations.

### 2.4 (d) Hybrid: the original Moeboid.gam runs in a small x86 interpreter; new engine in C; thin TypeScript host

- A purpose-built i386 + x87 interpreter in C (compiled to wasm) runs the unchanged Moeboid.gam: PE loader with relocations, 24 KERNEL32 stubs, `thiscall` bridge to the engine, `cdecl` callback bridge. The code is static and fully known (F1): every instruction form that can execute is in the listing.
- x87 registers as f64 at 53-bit precision (F11), with the FSIN/FCOS pair special-cased by the table.
- Engine and shell: reimplemented in C, as in (a). Host as in (a).
- Exactness: game logic exact by construction, including all quirks (F13, stale register bits, struct padding), provided the interpreter is correct. Interpreter correctness can be tested per instruction form against Unicorn (all forms enumerable), then end-to-end with the lockstep corpus.
- Maintainability: engine and shell source readable; game logic stays machine code, with the decompiled C as documentation. The game logic needs no changes (section 1), so this costs little.
- Variant [I]: static translation of the known instructions to C instead of interpretation. Same exactness argument, faster, but a translator is more work than an interpreter at this size. Not needed for performance: the game runs 50 ticks per second on a few thousand instructions per tick.

## 3. Comparison against the requirements

Scale: ++ strong, + adequate, o possible with extra work, - weak or contrary.

| Requirement or criterion | (a) C port | (b) emulation | (c) TypeScript | (d) hybrid |
|---|---|---|---|---|
| R1 exact gameplay | + (lockstep, scenario coverage) | o (original code; emulator FPU and timing) | + (more risk) | ++ (original code) |
| R1 exact timing, fixed timestep | ++ (virtual ms clock, timing.md 9) | o (emulator clock, busy loop) | ++ | ++ |
| R1 exact visuals (frame, sprites) | ++ | + | ++ | ++ |
| R2 pixel-exact fonts | + (atlases; GDI identity unproven) | - (Wine FreeType, AA) | + | + |
| R3 exact colours | ++ | + (at 32-bit desktop) | ++ | ++ |
| R4 click-to-start | ++ | + | ++ | ++ |
| R5 local scores, no accounts, no downloads | ++ (not ported) | o (patches) | ++ | ++ |
| R6 blank ad area | ++ | o (patch) | ++ | ++ |
| R7 ToS dialog | + (shared dialog component) | ++ (original) | + | + |
| R8 frame and platform menu kept | ++ (rebuilt from analysis) | ++ (original) | ++ | ++ |
| R9 no ads, no network | ++ (no network code exists; CSP) | o (stubs and patches) | ++ | ++ |
| Maintainability | ++ | - | + | + (engine source; game binary) |
| Effort, phase 2 total (person-days, inferred) | 30-42 | 15-25 to run, unknown to exact | 33-46 | 30-42 |
| of which verification (verification.md 6) | 16-21 | 18-25 | 17-22 | 14-19 |

Totals include the verification items of verification.md 6. They exclude divergence fixing beyond one iteration, which is largest for (c) and smallest for (d) (verification.md 6).

## 4. Recommendation

Option (d): the original Moeboid.gam in a purpose-built x86 interpreter, a reimplemented ZapSpot engine and shell in C, both compiled to one wasm module with clang (no Emscripten), and a thin TypeScript host.

Reasons:
1. Requirement 1 has the highest weight. In (d) the game logic is the original instruction stream, so rare branches, quirks and float details are exact without per-path proof. In (a) and (c) they are exact only where tests reach.
2. The verification of (d) is stronger and cheaper (verification.md 5, 6): the interpreter is tested per instruction form against Unicorn (complete for this static code), the corpus then checks the whole.
3. All required changes are in the engine and shell, which every non-emulation option rewrites in source. The game logic needs no change, so keeping it as machine code costs no maintainability that matters.
4. The boundary is small, regular and verified at all 295 call sites (F2). The Unicorn harness is already a working prototype of (d) in Python (F12).
5. (b) cannot meet R2 without replacing the emulator's text rendering, and needs binary patches for R5, R6 and R9.

Fallback: the engine exposes the original interface (13 interfaces, 54 methods) as its module boundary. If the interpreter does not pass its gate (milestone M2), a hand-ported game module (option (a)) plugs into the same boundary and the same lockstep harness. No engine work is lost.

## 5. Target architecture (option (d))

```
browser page (TypeScript host, no network)
  click-to-start screen, canvas (800x572, integer scale, no smoothing), Web Audio, input queue,
  localStorage, requestAnimationFrame
        |  imports/exports (integers, pointers into wasm memory)
wasm module (C, clang --target=wasm32, freestanding)
  clock      virtual integer ms clock, GetTickCount model with selectable step (timing.md 9)
  timers     engine timer list, fire rule, pause and game clock (timing.md 2)
  engine     13 interfaces / 46 behaviours (interface.tsv), MSVC rand, settings store
  render     surface tree with dirty rectangles, colour-key blit, fill, line, 800x572 RGBA buffer
  text       Arial and MS Sans Serif glyph atlases, GDI text layout, engine ZML renderer
  shell      frame, rail, pages, dialogs, high scores, sound toggle
  sound      16-voice table; emits play commands with tick time stamps to the host
  cpu        PE loader, i386 + x87 interpreter, KERNEL32 stubs, thiscall/cdecl bridges
  Moeboid.gam (original bytes, loaded at start)
```

- Clock and loop: the host calls `advance(wall_ms)` from `requestAnimationFrame`. The module runs all due virtual-clock steps (input delivery, timer passes), composes a frame only on the 50 ms render timer, and the host copies the buffer to the canvas when it changed (timing.md 9). Default clock step: per decision 6.2.
- Rendering: 800x572 RGBA frame buffer in wasm memory; host `putImageData` plus CSS integer scaling with `image-rendering: pixelated` (rendering.md 11).
- Text: atlases built offline from `fonts/Arial.TTF`, `fonts/Arialbd.TTF` (FreeType mono, full hinting) and `fonts/sserife.fon` (13 px strike), stored as data files; GDI layout rules of fonts.md 10.5. No browser text rendering.
- Dialogs: drawn by the module into the canvas with MS Sans Serif (pixel-exact text); the window frame look per decision 6.4.
- Audio: WAV data from the .gam resources, decoded once into `AudioBuffer`s at the original rate; one `AudioBufferSourceNode` per play; 16-voice rule in the module (audio-input.md 4).
- Input: DOM `keydown`/`keyup`/pointer events with `timeStamp` go into a queue; the module delivers them before the clock step at or after their time stamp; a key-state table answers the per-tick `GetKeyState` poll (audio-input.md 5).
- Storage: settings and high scores (5 rows, rules of shell.md 2) in `localStorage`, written on every change.
- No network: the module has no network code; the host uses no `fetch` to other origins, no external links, no `window.open`; a Content-Security-Policy `default-src 'self'` enforces it (shell.md 5.8).
- Build: clang 23 `--target=wasm32` with `wasm-ld`, a small freestanding C library (memcpy, memset, allocator); the same C sources build natively with gcc or clang for tests. TypeScript is converted with node's built-in `module.stripTypeScriptTypes` ([V] available in node 25.2.1, experimental); type checking with `tsc` would need one npm package (optional, user decision).
- Deployment: local only. A small static server script (localhost) or a single HTML file with the wasm and data inlined (works from `file://`). The original `Moeboid.gam` file is an input of the build or of the page; it is not modified.
- Test harness: the native build of the module runs the lockstep corpus against the existing Unicorn reference (`analysis/verification/harness/`), plus the per-instruction CPU tests and the rendering, font, timing, audio and shell checks of verification.md 4.

## 6. Decisions for the user

1. Target technology: (d) recommended; (a) is the fallback and the alternative if you prefer readable game source.
2. Clock model (timing.md 5): 1 ms step = coded rates, 50 Hz ticks, 20 fps (recommended default); 15.625 ms = typical Windows XP, 32 Hz; 54.9 ms = Windows 98, 18.2 Hz. Recommended: a setting, default 1 ms.
3. Colour look (rendering.md 12): 24/32-bit desktop look, exact (recommended), or a 16-bit look.
4. Fonts and Windows look (fonts.md 12): which Windows is the reference for dialog frames, captions and MessageBox text (2000, XP classic, XP Luna)? Tahoma / Trebuchet MS files are not supplied. Font smoothing off (recommended). Can you run the GDI dump program of fonts.md 10.6 on a Windows 2000/XP machine or VM for ground truth?
5. Terms of Service (shell.md 4, 8 D2): keep it. Cost: S with an HTML dialog (not pixel-exact text, conflicts with R2), M (1-2 days extra on the shared dialog component) pixel-exact in the canvas (recommended). Remove the ad opt-in checkbox and its server message.
6. View All Games (shell.md D1): remove, or keep with only the Moeboid tile (recommended).
7. Rail without Mail This (shell.md D3): empty slot (recommended) or move the buttons up 67 px as the original does.
8. Minimize and close buttons (shell.md D4); Help/About texts verbatim with inert links (D5); Personalize page without proxy fields (D6).
9. Ad area (rendering.md 13): black 470x62 box (the original initial state) or the #3333cc background.
10. Quirks: keep the "play again" quirk (verification.md 2.2) and the virtual-key quirks (numpad `.` = No, F3/F5 variants of `credits`; audio-input.md D3)? Recommended: keep for exactness.
11. FSIN reference values from a modern Intel CPU (verification.md 3.3): accept?
12. Audio (audio-input.md 6): keep the 16-voice limit, mute on blur, AudioContext at the device rate (all recommended).
13. Splash screen (400x240 bitmap with copyright text): keep or drop (it was never captured; rendering.md 7.1).

## 7. Phase 2 work plan (option (d))

Effort in person-days, inferred. Each milestone ends with a gate.

| Milestone | Content | Effort | Gate |
|---|---|---|---|
| M0 Decisions | Answers to section 6. Optional: Windows VM font dump. | - | answers recorded |
| M1 Foundation | Repository layout (`port/`), clang wasm and native builds, freestanding libc, virtual clock, timer subsystem, MSVC `rand`, host skeleton (click-to-start, canvas, rAF, input queue, CSP). | 3-4 | unit tests reproduce the timing table of timing.md 5 |
| M2 CPU | PE loader, i386 + x87 interpreter for the instruction forms in the listing, 24 KERNEL32 stubs, thiscall and cdecl bridges, FSIN/FCOS table (path D). | 5-7 | every instruction form passes a randomized differential test against Unicorn; the J corpus gives identical per-tick hashes with the mock engine. If not met within budget: switch the game module to option (a). |
| M3 Assets and fonts | GIF decoding and animation rules, WAV parsing, cursors, glyph atlases (Arial 2.82, MS Sans Serif 13 px), optional Windows ground truth. | 3-4 | GIF output equals the engine rules for all 81 GIFs; atlas advances equal `hdmx` |
| M4 Engine core | The 46 behaviours of `interface.tsv`: surfaces and dirty rectangles, image ops, GDI text, engine ZML, timers and events, sounds, settings, MessageBox/InputBox, pause and focus. Open question: DLL reload on New Game (interface.md 9.1). | 7-9 | corpus with the real engine equals the Unicorn reference; reference-renderer frames equal pixel by pixel |
| M5 Shell | Frame, rail, pages, dialog component (name entry, quit, MessageBox, ToS), local high scores, removed features, blank ad area, sound toggle. | 6-9 | layout and colour equal the Wine captures (`analysis/reference/screens/`) except Wine text artefacts; no request in the browser network log; CSP active |
| M6 Audio and input | Web Audio voices and scheduling, key mapping, focus and visibility behaviour. | 2-3 | trigger timing and sample identity tests; focus pause test |
| M7 Acceptance | Full check suite (verification.md 4), side-by-side play against the Wine reference, packaging for local use, user play test. | 4-6 | user acceptance |
| Total | | 30-42 | |

## 8. Risks

| Risk | Effect | Mitigation |
|---|---|---|
| Interpreter defects (flags, x87 edge cases) | game divergence | per-form differential tests against Unicorn; corpus lockstep; fallback to (a) |
| Shared misreading in the static analysis (mock engine and port agree, both wrong) | wrong engine behaviour | Wine side-by-side checks; targeted reference runs (I) for doubtful behaviours |
| No Windows GDI ground truth | glyph pixels unproven | user VM dump (fonts.md 10.6); else accept FreeType mono with metric proof |
| Clock-model choice | game feel differs from some players' memory | clock step as a setting |
| Browser frame pacing and tab throttling | late passes | timing.md 9 rules (one late pass, as the original) |
| DLL reload semantics on New Game unknown | game-local `rand` and statics reset or not | one reference run with a module-load trace in M4 |
