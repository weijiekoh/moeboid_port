# Moeboid browser port

Contract: `docs/port-design.md`. Decisions: `docs/decisions.md`. Timing rules: `analysis/timing.md`.

## Requirements

- clang 23 with the `wasm32` target and `wasm-ld` (LLD 23), `llvm-ar`.
- node 25.2.1 (`module.stripTypeScriptTypes`; no npm package in the shipped page).
- Python 3 (resource pack, Python tests, local server).
- Optional: `port/node_modules` (`typescript` for the type check in `build.sh host`, `playwright-core` for browser tests).

Start every shell with:

```
source /home/user/moeboid_port/tools/env.sh
cd /home/user/moeboid_port
```

## Build

```
port/build.sh all          # wasm, wasm-trace, native, pylib, pack, host
port/build.sh wasm         # port/build/moeboid.wasm (also copied to port/build/web/)
port/build.sh wasm-trace   # port/build/moeboid-trace.wasm (imports env.host_trace)
port/build.sh native       # port/build/native/libmoeboid.a and test executables
port/build.sh pylib        # port/build/libmoeboid.so (Python ctypes)
port/build.sh pack         # port/build/web/pack.bin (port/tools/mkpack.py)
port/build.sh host         # port/build/web/*.js, index.html, style.css, Moeboid.gam
port/build.sh clean        # remove port/build/
```

`build.sh` compiles every `*.c` below `port/src/<module>/` (modules `rt core cpu gfx text engine shell snd`); a new source file needs no change in the script. `PORT_MODULES="rt core" port/build.sh test` restricts the module list. Generated C headers go to `port/build/gen/` (on the include path). All C builds use `-ffp-contract=off`. Port sources compile with `-ffreestanding -nostdlibinc`: only `stdint.h`, `stddef.h`, `stdbool.h` come from the compiler; everything else comes from `src/rt`.

## Test

```
port/build.sh test
```

Builds native, pylib, wasm and wasm-trace, then runs:
- `port/build/native/test_*` (from `port/tests/native/test_*.c`),
- `node port/tests/node/*.mjs port/build/moeboid.wasm`,
- `python -I -B port/tests/py/test_*.py`.

It prints `test programs: N, failed: F` and exits non-zero on a failure.

## Run locally

```
port/build.sh wasm pack host
port/serve.sh 8000         # http://127.0.0.1:8000/  (127.0.0.1 only)
```

Open `http://127.0.0.1:8000/` and click "Click to start". The click creates the AudioContext. Clock step setting (decision 2): `?clock=0` (1 ms, default), `?clock=1` (15.625 ms), `?clock=2` (54.925 ms).

The page loads only `moeboid.wasm`, `pack.bin` and `Moeboid.gam` from its own directory. The Content-Security-Policy (meta tag in `host/index.html`, also sent as a header by `host/serve.py`) blocks every other origin.

## Source map

| Path | Content |
|---|---|
| `src/rt/` | `rt_mem*`, `rt_str*`, allocator (`rt_malloc`), `rt_snprintf`, host sinks (`rt_log`), SHA-256 |
| `src/core/clock.*` | virtual clock, GetTickCount model `floor(k * num / den)` |
| `src/core/timers.*` | engine timer list (Z:0x4271c0, Z:0x413440 and methods) |
| `src/core/rand.*` | MSVC rand (Z:0x40e38c, Z:0x40e396) |
| `src/core/input.*` | input queue, GetKeyState table |
| `src/core/storage.*` | settings and high-score text blob |
| `src/core/trace.*` | lockstep trace hashes (same as `analysis/verification/harness/mock.py`) |
| `src/core/port.*` | `Port` state, main loop (`core_advance`), hooks |
| `src/main.c` | wasm exports (`port_*`) |
| `host/` | `index.html`, `style.css`, `main.ts`, `input.ts`, `storage.ts`, `audio.ts`, `serve.py` |

## Rules for other modules

- Runtime: call the `rt_` names (`rt_memcpy`, `rt_malloc`, `rt_snprintf`, ...). The wasm build also defines `memcpy`, `memmove`, `memset`, `memcmp` for compiler-generated calls; the native build takes these four from libc.
- Hooks: define `void port_hooks_engine(PortHooks *h)` (M4) or `void port_hooks_shell(PortHooks *h)` (M5) and fill `init`, `input`, `step`, `frame` (`src/core/port.h`). The core has weak empty defaults. A `step` hook turns the jump optimisation off.
- Time: read `core_ticks(p)` (GetTickCount model). Use `EngineTimer` and `timer_start`/`timer_stop` for every engine timer; call `timer_release` before freeing a timer.
- Rendering: write RGBA pixels to `p->frame` (`PORT_W` x `PORT_H`) and call `core_frame_changed(p)`.
- Sound: `core_sound_push(p, op, sound_id, voice)`.
- Storage: `storage_get`/`storage_set` on `p->storage` (write-through to `localStorage`).
- Key state: `core_key_state(p, vk)`.

## Host audio and input

Owner M6. Sources: `host/audio.ts`, `host/input.ts`, the `M6` lines in `host/main.ts`, contract header `src/core/sound_ids.h`. Analysis: `analysis/audio-input.md` 2 to 5, `analysis/timing.md` 9 rules 5 and 6, decisions 10 and 12.

**Sound contract** (`src/core/sound_ids.h`, mirrored in `audio.ts` `SOUND_TABLE`; `tests/browser/audio_wav.mjs` fails when the two differ). Command record = `PortSoundCmd` {op, sound_id, voice, at_ms}, 4 x u32. op 1 PLAY, op 2 STOP (voice, or 0xffffffff = all). Ids 1..11: game sounds in the Moeboid.gam load order; 12..15: BTNCLICK, POPUP, OPENSHELL, CLOSESHELL. Flag 1 = GLOBALFOCUS (CloseShell: not muted on blur). The C side (M4) owns the name-to-id lookup, the Sound setting check, the 16-voice table with drop-when-full and the voice release time (WAV duration plus the 10 ms voice-thread pass); the header lists these duties. The host plays every PLAY it gets and has no voice limit.

**Audio** (`audio.ts`):
- One `AudioContext` at the device rate, created and resumed in the click-to-start handler (decision 12). The page logs `moeboid: audio: 15 sounds, <rate> Hz`.
- `load(pack)`: every table entry from `pack.bin`, RIFF parsed as the engine (`Z:0x40c540`: first `fmt `, first `data`, other chunks skipped, walk ends at riff_size + 8), PCM to float32 exactly (8-bit `(b - 128) / 128`, 16-bit `s / 32768`), `AudioBuffer` at the WAV rate (8000 or 11025 Hz). The browser resamples to the device rate (Chromium 153: linear interpolation, seen in a probe; not the DirectSound resampler).
- `commands(words, n, port_now())` after each `port_advance` with bit 1: start = `currentTime + LATENCY_S + (at_ms - now_ms) / 1000`, never before `currentTime`. `LATENCY_S` = 50 ms, so a batch of one host frame up to 30 Hz keeps its clock spacing exactly; older commands (stalls) start at once. One `AudioBufferSourceNode` per PLAY into the master `GainNode` (gain 1.0, no pan; mono up-mix gives L = R).
- `setActive(false)` (blur, hidden tab): master gain 0 from the event time + `LATENCY_S` (the time line of the sounds); sources keep running. `setActive(true)`: gain 1.

**Input** (`input.ts`, kinds of `src/core/input.h`):
- Key-down kind 1 (a = VK, b = `event.repeat`), key-up kind 2, character kind 9 after the key-down (TranslateMessage order). Time stamps = `event.timeStamp`.
- VK: letters from `key` (follow the layout, as Windows VKs); letter keys with non-Latin characters from `code`; digit row by position; numpad by position (`NumpadDecimal` = VK_DECIMAL 0x6e, the game's 'n') or the navigation VK when NumLock is off; `+ , - .` by character (layout-independent VK_OEM keys); all other keys by `code` at US positions (F1..F24, Escape, Enter, Tab, Backspace, Insert, Delete, Home, End, PageUp, PageDown, arrows, Shift, Control, Pause, CapsLock, NumLock, ScrollLock, Meta, ContextMenu, OEM keys).
- Not sent (WM_SYSKEYDOWN in Windows, no WndProc case): F10 (VK 0x79 = the game's 'y', so lower-case y via F10 never works, as in the original), Alt combinations without Ctrl, Alt and AltGr themselves, IME composition. Ctrl+Alt (AltGr on Windows browsers) gives normal key messages (inferred from the ReactOS keyboard code). Key-ups are sent also with Alt down, so no key stays down.
- WM_CHAR: Windows-1252 code of `key` (characters outside cp1252 are dropped), Ctrl+A..Z 1..26, Ctrl+[ \ ] 0x1b..0x1d, Ctrl+Enter 0x0a, Ctrl+Backspace 0x7f, none for dead keys.
- `preventDefault` only while the page is active and without Ctrl, Alt or Meta, only for keys the game or shell uses: arrows, Space, PageUp/Down, Home, End, Delete, Enter, Escape, Tab, Backspace, letters, digits, numpad, text keys (VK_OEM_*), and the quirk keys F3, F4, F5 (`credits` as VK_F3/F4/F5; decision 10 provisional: keep the quirks, so F5 does not reload while the game has focus). F1, F2, F6..F12 and browser shortcuts stay with the browser.
- Pointer: kinds 3, 4, 5, button in kind bits 8..15 (0 left, 2 right; middle not sent, no WndProc case). Frame pixel = `floor((clientX - rect.left) * 800 / rect.width)` (rect = canvas at its integer scale), signed outside the canvas. A move is sent only when the frame pixel changes. Left down takes the pointer capture (SetCapture); chorded presses come from `pointermove`; Chromium drops the capture after a chorded right release, so the host takes it back and also reads window events during a left drag.
- Focus: `blur`, `focus`, `visibilitychange` give kind 6 or 7 once per state change and call `onActive` (audio mute). The C side pauses and stops the timer passes.

**Known deviations** (inferred): Windows updates GetKeyState also for Alt-held keys (WM_SYSKEYDOWN); the port sends nothing, so an arrow pressed while Alt is down does not move the player. OEM keys other than `+ , - .` use US positions; Windows VKs for them depend on the layout. The cursor images are not done (`main.ts` `CURSORS` still uses CSS cursors).

**Tests** (`tools/bin/web-test port/tests/browser/<name>.mjs`; results `tests/results/m6.txt`): `audio_wav.mjs` (sample identity with the Python reference `audio_wav_ref.py`, which decodes the phase 1 assets; table contract; RIFF rules; page start), `audio_sched.mjs` (start times and rendered impulses keep the tick spacing, clamp, u32 wrap, STOP), `audio_focus.mjs` (kinds 6/7, mute window, sources keep running, GLOBALFOCUS), `input_keys.mjs` (137 key events, cp1252, trusted key presses with defaultPrevented, pointer mapping at scale 2 and at device pixel ratio 1.5).
