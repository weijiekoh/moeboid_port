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
