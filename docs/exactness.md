# Exactness of the Moeboid browser port

Date: 2026-10-11 (M7). Labels: **proven** = a test compares the port with an independent reference and gives the stated result; **by construction** = the port runs or copies the original data or code, so no model can differ; **unproven** = no ground truth, the rule is inferred; **approximate** = known not bit-exact. Test results: `port/tests/results/verify.txt` (`port/build.sh verify`), `docs/progress.md`. Decisions: `docs/decisions.md`.

## 1. Exact and proven

| Item | Reference | Test | Result |
|---|---|---|---|
| x86 + x87 interpreter | Unicorn 2.1.4, one instruction per state | `tests/py/test_insn_diff.py` (M2 gate) | 15677 addresses, 280 forms, 156770 states, 0 unexplained mismatches |
| Game logic run (CPU) | `analysis/verification` corpus on Unicorn | `tests/py/test_corpus.py` (M2 gate) | per-tick hashes identical on Unicorn, C CPU via shim, C machine: autopilot 2835 ticks, tour 5663 ticks, clock steps 15.625 and 54.925 ms, seed 999, relocated image |
| FSIN/FCOS + PC53 multiply (path D) | 80-bit x87 table of one Intel CPU | `tests/py/test_fsin_path.py` | 179000 pairs, 0 mismatches (x32, y32, y53) |
| Engine (54 methods, timers, events, objects) | `refmock.py` (mock.py corrected from the engine code, O11) | `tests/py/test_engine_lockstep.py` | 5 cases (autopilot, tour, 15.625 ms, 54.925 ms, seed 999): per-tick calls, clock ms, state digests identical; native = wasm trace build |
| GIF decoding and animation slots | engine rules (rendering.md, timing.md 4) and Pillow | `tests/py/test_gif.py` | 81 GIFs, 258 frames, 0 pixel differences |
| Glyph advances and line metrics | `hdmx`, `VDMX` of Arial 2.82, Tahoma 3.15, Trebuchet MS 1.22 | `tests/py/test_atlas.py` | 0 of 2304 advances differ from `hdmx`; extents = VDMX; Arial metrics = fonts.md 10.4 |
| MS Sans Serif 8 pt (dialogs) | 13 px strike of `fonts/sserife.fon` | `tests/py/test_atlas.py` | 222 characters, 0 pixels differ |
| Luna frame (caption, borders, close button) | `fonts/luna.msstyles` NORMALBLUE_INI and bitmaps | `tests/py/test_luna.py` | 192 checks |
| Engine frame (title screen, game area) | Wine capture with monochrome fonts | `tests/py/test_engine_frame.py` | 207691 pixels equal; 2309 differ only in the moving sprites and 2 underline rows (see 3) |
| Shell layout, images, colours | 21 Wine captures (`screens_monofonts`) | `tests/py/test_shell_compare.py` | 0 layout, image or colour differences outside text; text differences explained (O14) |
| Cursors | ZapSpot.exe cursor resources | `tests/py/test_shell_cursors.py` | 0 pixels differ from the asset decode |
| Dialog component | dialog templates, Luna data | `tests/native/test_dialog.c`, `tests/py/test_dialog.py` | 251 + 93 checks; 400-dialog stress: 0 violations |
| Sound samples | phase 1 WAV assets (Python decode) | `tests/browser/audio_wav.mjs` | 15 of 15 sounds sample-identical (float32 sha256) |
| Sound scheduling | command clock ms | `tests/browser/audio_sched.mjs` | start-time spacing exact, 0 samples deviation |
| Sound trigger time | game `ISound.Play` call in the lockstep trace | verify (b) | 66 of 66 game PLAY commands at the clock ms of their Play call; 33 calls without PLAY, all with the Sound setting off; page = native commands |
| Timer rates (timing.md 5) | timing.md 5 table | `tests/native/test_timers.c`, `test_loop.c` | table exact for 1, 10.0144, 15.625, 54.925 ms; step jump = every step in 100 of 100 scenarios |
| Frame-rate independence | native run (no browser) | verify (a), `tests/browser/timing.mjs` | 60 s of play: 3000 ticks / 1200 renders (1 ms), 1920 / 960 (15.625 ms), 1092 / 1092 (54.925 ms) at 30, 60 and 144 Hz frame clocks, Chromium and Firefox; 11 frame hashes per run equal native |
| Determinism | same input recording | verify (e) | 30 min random-input soak: native = wasm = page at 30 checkpoints (frame SHA-256 and 11 probe values); 203 sound commands equal |
| Soak | random valid input, fixed seed | verify (d) | 30 min native and 30 min page (virtual time), 10 min real time: no guest fault, no engine error, heap and wasm memory bounded |
| No network | web-test guard, static scan | verify (c) | 0 non-loopback requests in every browser run; no XMLHttpRequest, WebSocket, EventSource, sendBeacon, window.open, external href/src, service worker; wasm imports only `env.host_log`; CSP meta and header; Moeboid.gam imports only KERNEL32 |
| Font smoothing setting | grey vs mono atlases | `tests/native/test_settings.c`, `tests/browser/autostart.mjs` (Standard only; the page has no setting) | Standard: 17 colours in the "Start" label, Off: 2; engine, frame and dialog text follow the setting |

## 2. Exact by construction

| Item | Why |
|---|---|
| Game logic, including its quirks | the original `Moeboid.gam` code runs unchanged in the interpreter; game statics live as long as the DLL image (fresh image at New Game, O10) |
| Game memory behaviour | the game's own CRT heap (VC6 small-block heap) runs as guest code, so block reuse and use-after-free reads repeat the original (see 4) |
| Resources | 142 resources byte-exact in `pack.bin` (sha256 = `assets/index.json`) |
| Colours | GIF RGB and frame colours copied (decisions 3, 9) |
| Random numbers | MSVC rand LCG, engine and game CRT (verified constants) |
| GetTickCount, timer fire rule, pause clock | copied from the engine code (`Z:0x413510`, `Z:0x4273d0`, `Z:0x427490`); the clock model is a setting (decision 2) |
| Error diagnostics | the engine `Error()` messages (`Z:0x413390`, debug output, not visible) appear in the log; the soak shows 2 (DetachSurface after a game over), as the original code path |

## 3. Unproven or approximate

| Item | Status | Reason |
|---|---|---|
| Monochrome glyph bitmaps | unproven | FreeType 2.14.3 v35 output; no Windows GDI dump; only advances and extents are proven |
| Greyscale text (Standard smoothing) | unproven | model O6 (4x4 oversampling, 17 levels, linear blend) is inferred; no Windows reference |
| Underline row | unproven | Wine draws 1 row higher; the port uses the inferred GDI rule (2 rows in `test_engine_frame.py`) |
| Text widths in shell pages | unproven | GDI model (O14); Wine differs by 1-2 px in centred labels and some line breaks |
| Tahoma, Trebuchet MS versions | unproven | XP-generation files; retail XP version not confirmed |
| FSIN/FCOS last bits | exact against one modern Intel CPU (decision 11, provisional) | period CPUs may differ |
| Clock model | setting | the original rate depended on the OS (timing.md 5); 1 ms is the coded intent |
| Voice release (16-voice limit) | approximate | voice-thread pass every 10 ms from engine start (inferred; real period 10-16 ms) |
| Audio output | approximate | browser resampling (linear) and mixing are not DirectSound; samples and start times are exact |
| Dialog geometry, MessageBox layout | unproven | inferred from NT DLU rules and Luna data; Wine dialogs are not XP |
| Dialog cursors (arrow, I-beam) | placeholder | CSS cursors; the XP cursor files were not supplied |
| "Name too long" MessageBox icon and sound | missing | XP exclamation icon and sound not supplied (O9) |
| Splash duration | inferred | 2 s (decision 13); the original showed it for the engine start-up time |
| Alt-held keys, OEM keys | approximate | the browser gives no WM_SYSKEYDOWN; OEM keys use US positions (`port/README.md`) |
| Removed features | intentional | ads, network, downloads, Mail This, minimise/close (decisions 5-9) |
| Coverage | limited | lockstep proves the recorded scenarios only; 11.5 % of game code bytes never ran in the tour |

## 4. Original game bug reproduced: CREDITS after a game

Verify check "credits": typing `credits` on the title screen after a game over in the same DLL lifetime (Play again: No) makes the CREDITS baddies read the play screen of the ended game through `DAT_1000f5e4` (set by the play screen constructor, never cleared). The play screen was freed and its block reused by the CREDITS objects; at the end of a baddie's spawn phase `G:0x100013f3..0x10001401` loads `[DAT_1000f5e4 + 0xc]` (now a float, for example 353.0 = 0x43b08000) and dereferences it. The port stops the game with a guest fault at `G:0x10001401` (native = wasm, deterministic); the frame stays, New Game does not recover, a page reload does. Inferred: the original faults at the same instruction (same guest CRT heap code, same allocation sequence); on Windows this is an access violation in ZapSpot.exe. CREDITS from a fresh DLL image (no game before) runs without fault. A switch to avoid the crash would change game behaviour: decision for the user (item 10, quirks).

## 5. What the user can still supply

| Item | Closes |
|---|---|
| XP exclamation icon: `user32.dll` icon 101 (IDI_EXCLAMATION), 32x32 32-bit | icon in the "Name too long" MessageBox (pack entry `data/icons/EXCLAMATION`) |
| `C:\WINDOWS\Media\Windows XP Exclamation.wav` | MessageBox sound (pack entry `data/sounds/EXCLAMATION.WAV`, sound id 16) |
| GDI glyph dump from Windows 2000/XP (test program of `analysis/fonts.md` 10.6): Arial 8-36 px regular and bold, Tahoma 11, Trebuchet MS Bold 13, smoothing off and Standard | monochrome glyphs, greyscale model, underline row, text widths (section 3) |
| Retail Windows XP `tahoma.ttf`, `tahomabd.ttf`, `trebucbd.ttf` | font version doubt |
| XP arrow and I-beam cursors | dialog cursor placeholders |
| One run of the original on Windows XP: CREDITS after a game; GetTickCount step; splash time | section 4 (crash or not), clock model, splash duration |
