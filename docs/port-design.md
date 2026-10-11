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

Producer: `port/tools/mkpack.py` (`port/build.sh pack`). Reader: `src/text/atlas.h` (`mpack_open`, `mpack_next`, `mpack_find`). Details and checks: `port/tools/README.md`.

- Little-endian. Header: `MPAK`, u32 version 1, u32 count. Directory: count x {u32 name_len, name (ASCII, no NUL), u32 offset (from file start), u32 length}. Then data; each entry starts on a 4-byte boundary (padding 0). Entries are sorted bytewise by name.
- `zap/<TYPE>/<NAME>`, `gam/<TYPE>/<NAME>`: every resource of ZapSpot.exe (82) and Moeboid.gam (60), byte-exact. TYPE: CURSOR, BITMAP, ICON, DIALOG, STRING, RCDATA, GROUP_CURSOR, GROUP_ICON. NAME: the stored name (upper case, with suffix, for example `gam/RCDATA/HELP.ZML`, `zap/RCDATA/SLB-BEVELEDGES.GIF`) or the decimal id (`zap/STRING/63` = string block 63, ids 992..1007; `zap/CURSOR/1`). The type is part of the name because names collide across types (STRING 1 and CURSOR 1 in ZapSpot.exe).
- `font/<FACE>-<px>-<weight>-<MONO|GRAY>`: glyph atlases (section 8). FACE is upper case without spaces (ARIAL, MSSANSSERIF, TAHOMA, TREBUCHETMS).
- `data/...`: tables of other tools that define `pack_entries()` (`mkpack.TABLE_PRODUCERS`; now `data/luna/NORMALBLUE` from `mkluna.py`). A producer whose input is missing is skipped with a warning.
- mkpack compares the sha256 and file offset of every resource with `assets/index.json` (verified: 142 of 142 equal). Output is deterministic (verified: same sha256 in repeated runs). `extracted/Moeboid.gam` is copied to `port/build/web/Moeboid.gam` and passed separately to `port_init`.

## 8. Glyph atlases, image buffer, text API

Producer: `port/tools/mkatlas.py` with the FreeType helper `mkatlas_ft.c`. Consumer: `src/text/atlas.c` (loader), `src/text/gdi_text.c` (GDI text). Rebuild, FreeType version, checks, unproven parts: `port/tools/README.md`.

**Atlases.** One entry per (face, px, weight, mode); underline and strikeout are drawn at run time. px = -lfHeight (em height in pixels). Contents: Arial regular and bold at 8, 10, 11, 12, 14, 18, 24, 36 px (mono); grey atlases exactly where the `gasp` table allows grey: regular 8, 18, 24, 36, bold 8, 11, 12, 14, 18, 24, 36; MS Sans Serif em 11 (the 13 px strike of `sserife.fon`, exact copy); Tahoma 11 regular and bold (MessageBox and small caption font, 8 pt; gasp allows no grey at 9..16 ppem); Trebuchet MS bold 13 (Luna caption, 10 pt; mono and grey). Tahoma and Trebuchet MS come from the user files (flag UNVERIFIED: XP-generation font, version unverified); without the files mkatlas writes Arial placeholders (flag PLACEHOLDER).

Blob (little-endian): header 120 bytes, glyph records, coverage bytes.

| Offset | Type | Field |
|---|---|---|
| 0 | 4 bytes | `MATL` |
| 4 | u16 | version 1 |
| 6 | u8 | mode: 0 mono (coverage 0/1), 1 grey (coverage 0..16) |
| 7 | u8 | flags: 0x01 PLACEHOLDER, 0x02 RASTER (bitmap strike), 0x04 HINTED, 0x08 gasp GRIDFIT at px, 0x10 gasp DOGRAY at px (grey allowed), 0x20 UNVERIFIED |
| 8 | u16 | px (em height) |
| 10 | u16 | weight (400, 700) |
| 12, 14, 16 | u16 | first char, last char (inclusive), default char (for bytes outside first..last). TrueType: 0x00..0xFF (cp1252 to Unicode, undefined bytes to the same code point, unmapped to .notdef); MS Sans Serif: 0x20..0xFF, default 0x81 |
| 18..30 | i16 x 7 | tmHeight, tmAscent, tmDescent, tmInternalLeading, tmExternalLeading, tmAveCharWidth, tmMaxCharWidth |
| 32, 34 | i16 | underline offset (top row = baseline row + offset), underline thickness |
| 36, 38 | i16 | strikeout offset (top row = baseline row - offset), thickness (inferred, unused) |
| 40 | 4 bytes | reserved (0) |
| 44 | char[32] | face, NUL-padded ("Arial", "MS Sans Serif", "Tahoma", "Trebuchet MS") |
| 76 | char[32] | source file and version |
| 108, 112, 116 | u32 | glyph table offset (120), coverage offset, coverage length |

Glyph record, 16 bytes, one per char first..last: i16 left (first column relative to the pen x), i16 top (rows above the baseline: first row = baseline row - top), u16 width, u16 height, i16 advance, u16 0, u32 coverage offset. Coverage: width x height bytes, top row first. Baseline row = y + tmAscent (the first row below the baseline).

Metric rules (TrueType; values for Arial equal the fonts.md 10.4 table, verified by test): tmAscent and tmDescent from VDMX yMax and -yMin at px (fallback: usWinAscent/usWinDescent scaled); tmInternalLeading = tmHeight - px; tmExternalLeading = max(0, lineGap - ((winAscent + winDescent) - (hhea ascender - descender))) scaled; tmAveCharWidth = OS/2 xAvgCharWidth scaled; underline = post underlinePosition (negated) and underlineThickness (at least 1) scaled. Scaling rounds half away from zero (inferred). Advances: the `hdmx` device width when hdmx lists px (GDI behaviour, inferred), else the FreeType hinted advance. Grey atlases carry the mono advances, so layout does not depend on smoothing (inferred).

**Image buffer** (`src/gfx/image.h`, shared with M4): `Image {int32_t w, h, stride (pixels per row); uint32_t *px (row-major, top-down); uint8_t keyed}`. Pixel = uint32 0xAABBGGRR, bytes R, G, B, A in memory (canvas order). Colour = Windows COLORREF (0x00BBGGRR) | 0xFF000000 (`IMG_RGB(r, g, b)`). Keyed images mark transparent pixels with `IMG_KEY` = (255, 0, 255, alpha 0); the RGB stays magenta so that grey text over the key tints as on Windows.

**Text API** (`src/text/gdi_text.h`): `TextFonts` holds every atlas of the pack (`text_fonts_load`). `gdi_font_select(&font, fonts, face, lfHeight, lfWeight, underline, strikeout)` maps a LOGFONT (lfHeight < 0: em height; > 0: tmHeight; weight >= 550 selects 700). `gdi_get_text_metrics`, `gdi_get_text_extent_point32` (cx = sum of advances, cy = tmHeight). `gdi_ext_text_out(&image, x, y, options, &rect, str, len, &font, &state)`: options `GDI_ETO_CLIPPED`, `GDI_ETO_OPAQUE`; state = text colour, background colour, background mode (`GDI_TRANSPARENT`, `GDI_OPAQUE`: cell x..x+cx, y..y+tmHeight filled first), smoothing switch. Pen starts at (x, y + tmAscent), no kerning, no extra spacing. Grey atlas only when smoothing is on and gasp allows grey at px; grey blend per channel `(dst * (16 - v) + text * v + 8) >> 4`, alpha 255 (decision O6, unproven). Underline: thickness rows from baseline row + offset, across cx, text colour.

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
