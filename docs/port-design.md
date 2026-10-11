# Port design contract (phase 2)

Binding for every phase 2 workstream. Decisions: `docs/decisions.md`. Architecture: `docs/architecture.md` section 5 (option (d)). Analysis: `analysis/*.md`, `analysis/interface.tsv`.

## 1. Directory layout and ownership

```
port/
  build.sh            build entry point (M1 owns; others add their sources to the lists in it)
  src/rt/             freestanding C runtime for wasm: mem*, str*, allocator, printf-lite (M1)
  src/core/           virtual clock, GetTickCount model, timer list, pause/game clock, MSVC rand,
                      input queue, trace log (M1)
  src/cpu/            PE loader, i386 + x87 interpreter, KERNEL32 stubs, thiscall/cdecl bridges,
                      FSIN/FCOS table (M2)
  src/gfx/            GIF decoder and animation rules, image buffers, blits, fills, lines,
                      surface tree, dirty rectangles, cursors (M3 decoder; M4 rest)
  src/text/           glyph atlas runtime, GDI text layout (ExtTextOutA, GetTextExtentPoint32A),
                      engine ZML renderer (M3 runtime; M4 ZML)
  src/engine/         the 13 interfaces / 54 methods of analysis/interface.tsv, applet manager,
                      events, settings store, sound voice table (M4)
  src/shell/          frame, rail, pages, dialogs, MessageBox, InputBox, high scores, splash (M5)
  src/main.c          wasm exports (host API, section 6) (M1 creates, M4/M5 extend)
  host/               TypeScript host: index.html (CSP), main.ts, audio.ts, input.ts, storage.ts (M1, M6)
  tools/              Python and C build tools: resource pack, glyph atlases, tables (M3)
  tests/              native tests (tests/native), Python bridges (tests/py), browser tests (tests/browser)
  build/              build outputs (git-ignored): moeboid.wasm, pack.bin, host JS, native test binaries
```

A workstream writes only in its own directories and in the shared files it is told to extend. The orchestrator commits; subagents never run `git commit`, `git add`, or any command that changes the git index or history.

## 2. Build

- `port/build.sh wasm`: clang `--target=wasm32 -nostdlib -O2 -ffp-contract=off -fno-math-errno -Wall -Wextra -std=c11`, `wasm-ld --no-entry --export-dynamic` (or explicit `--export=` list), memory exported. Output `port/build/moeboid.wasm`.
- `port/build.sh native`: the same C sources (minus `src/main.c` host glue) with the host compiler, for test executables in `port/build/native/`. `-ffp-contract=off` is mandatory in every build (no FMA contraction).
- `port/build.sh pylib`: `port/build/libmoeboid.so` for Python `ctypes` tests (CPU differential tests, lockstep corpus).
- `port/build.sh host`: TypeScript to JavaScript with node's `module.stripTypeScriptTypes` (node 25.2.1, no npm package needed). Output `port/build/web/`.
- `port/build.sh pack`: runs `port/tools/mkpack.py` (reads `extracted/Moeboid.gam`, `extracted/ZapSpot.exe`, `fonts/`), writes `port/build/web/pack.bin`.
- `port/build.sh all`, `port/build.sh test`.
- No Emscripten, no npm dependency in the shipped page.

## 3. C rules

- C11, `<stdint.h>`, `<stddef.h>`, `<stdbool.h>` only from the compiler; everything else from `src/rt`.
- Deterministic: no wall-clock reads in C; time comes only from the host through `advance()`. No uninitialised reads. No dependence on host pointer size (guest memory is a separate address space).
- Floating point only where the original uses it (CPU x87 emulation; text layout has none). Integer arithmetic with explicit widths; unsigned 32-bit wrap where the original wraps.
- One global `Port` state struct reachable from exports; no static constructors.
- Every behaviour that copies an original routine carries a comment with the original address (`Z:0x...`, `G:0x...`) and the analysis section.
- Engine-side quirks that the user may switch off (decisions.md item 10) go behind `port_settings.quirks` bits, default on.

## 4. Guest memory map (same as `analysis/verification/harness/emu.py`)

| Guest address | Size | Use |
|---|---|---|
| 0x00010000 | 4 KiB | GDT (FS selector) |
| 0x00020000 | 4 KiB | TEB (FS base; SEH chain head at FS:[0]) |
| 0x00100000 | 1 MiB | guest stack |
| 0x02000000 | 32 MiB | HeapAlloc arena (deterministic) |
| 0x04000000 | 32 MiB | VirtualAlloc arena |
| 0x10000000 | image | Moeboid.gam at its preferred base (relocations applied if moved) |
| 0x60000000 | 16 MiB | engine wrapper objects and their vtables (8-byte wrappers: vtable pointer, handle) |
| 0x7f000000 | 1 MiB | thunk addresses: one address per KERNEL32 import and per engine method (no real code) |
| 0x7f100000 | 1 MiB | engine-owned guest data (strings, event records, callback argument blocks) |

Guest memory is a set of host byte arrays per region (or a page table); the CPU module owns it and exposes `cpu_mem_ptr(guest_addr, len)` for the engine.

## 5. CPU and engine bridge

- Executing an address inside the thunk region stops the interpreter loop and dispatches:
  KERNEL32 thunk: C stub in `src/cpu/k32.c`; engine thunk: `engine_dispatch(iface_id, slot, this_guest, args_guest_ptr)` returning EAX. The bridge pops the return address and `4 x argc` bytes (`argc` from `analysis/interface.tsv`), sets EAX, and resumes at the return address.
- Engine to game callbacks (`int __cdecl cb(int* e)`): `cpu_call_cdecl(func, nargs, args)` pushes the arguments and a sentinel return address, runs until the sentinel, pops the arguments (caller cleanup), returns EAX. Nested calls (game calls engine, engine calls game) are allowed.
- x87: 8 registers as `double` with tag word and status word; precision control 53 bit as set by the CRT. FSIN/FCOS at G:0x1000125d/0x1000126e use the 80-bit table `analysis/verification/fpu/x87_fsin_table.tsv` with path D of `fsin_check.c` (verification.md 3.1). `__ftol` behaviour comes from the emulated instructions themselves.
- The Python harness can drive the C interpreter through `port/build/libmoeboid.so` with a Unicorn-compatible shim (`port/tests/py/cshim.py`), so `analysis/verification/harness/` runs unchanged on either backend.

## 6. Host API (wasm exports and imports)

Exports (C, `src/main.c`):
- `port_alloc(n)`, `port_init(pack_ptr, pack_len, gam_ptr, gam_len, clock_step_index, quirks)`.
- `port_advance(wall_ms_u32)`: runs all due clock steps (timing.md 9). Returns flags: bit0 frame changed, bit1 sound commands pending, bit2 storage changed.
- `port_input(kind, a, b, time_ms)`: kind 1 key down (a = Windows VK, b = repeat), 2 key up, 3 mouse move (a = x, b = y in frame pixels), 4 button down, 5 button up, 6 focus lost, 7 focus gained, 8 click-to-start done.
- `port_frame_ptr()`: 800x572 RGBA, row-major, top-down (may grow if dialogs need a larger canvas; constants `PORT_W`, `PORT_H`).
- `port_cursor()`: current cursor id (0..5), host sets CSS cursor.
- `port_sound_cmds(ptr_out)`: drains commands {op, sound_id, voice, at_ms}; sound data comes from the pack.
- `port_storage_get_ptr()/len()` and `port_storage_load(ptr, len)`: settings and high scores as one text blob (host keeps it in `localStorage`).
Imports (host, module `env`): `host_log(ptr, len)`, `host_trace(ptr, len)` (test builds only). No other import. No import can reach the network.

## 7. Resource pack (`pack.bin`)

Little-endian. Header `MPAK`, u32 version 1, u32 count, then entries {u32 name_len, name (ASCII, upper-case resource names as in `assets/index.json`, prefixed `zap/`, `gam/`, `font/`, `data/`), u32 offset, u32 length}, then data. Contents: every RCDATA, STRING, DIALOG, CURSOR, BITMAP resource of ZapSpot.exe and Moeboid.gam byte-exact, glyph atlases, tables. The whole `Moeboid.gam` file is passed separately to `port_init`.

## 8. Glyph atlases

One entry per (face, px, weight, underline-independent, mode) where mode is `mono` or `gray` (GDI standard smoothing model, decision 4b, unproven). Per character 0x20..0xFF: width, height, left offset, top offset (from baseline), advance, coverage bytes (mono: 0/1; gray: 0..16 levels as GDI GGO_GRAY4 style, inferred). Per font: tmHeight, tmAscent, tmDescent, tmInternalLeading, tmExternalLeading, tmAveCharWidth, underline position and thickness. Producer: `port/tools/mkatlas.*`. Consumer: `src/text/`.

## 9. Lockstep trace

`host_trace` records (test builds): per game-clock tick, every engine method call from the game as `iface.slot(args)=ret`, with the same canonical form as `analysis/verification/harness/mock.py` (`canon`, `canon_args`), so per-tick hashes compare directly with `logs/*.ticks.tsv`.

## 10. Process rules for subagents

- `source /home/user/moeboid_port/tools/env.sh` in every shell. Absolute paths.
- Never modify `moeboid.exe`, `extracted/`, user-supplied `fonts/` files, `prompts.md`. Never commit.
- Original binaries run only through `tools/bin/nonet` and only on the hidden Xvfb display set by `tools/bin/xvfb-run-wine` (never `:0`, never capture `:0`).
- Browser tests run headless inside `tools/bin/nonet`.
- Network only for tool downloads from official sources, into `tools/` or project `node_modules/`.
- Writing style for docs and reports: ASD-STE100, terse, active voice, no filler, no arrows.
- Mark claims verified (with reference) or inferred. Update your section of `docs/progress.md` only if told to; otherwise report to the orchestrator.
