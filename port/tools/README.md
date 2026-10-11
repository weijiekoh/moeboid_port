# Port build tools (M3)

Formats: `docs/port-design.md` sections 7 (pack) and 8 (atlases, image buffer, text API).

## Rebuild

```
source /home/user/moeboid_port/tools/env.sh
python -I -B port/tools/mkpack.py            # pack.bin + Moeboid.gam into port/build/web/, prints the manifest
python -I -B port/tools/mkatlas.py --verify  # atlases only: report, fonts.md 10.3 reproduction
python -I -B port/tests/py/test_gif.py       # gate (a)
python -I -B port/tests/py/test_atlas.py     # gates (b) (c) (d), pack determinism, PNG renders
```

`port/build.sh pack` runs `mkpack.py`. mkatlas compiles `mkatlas_ft.c` into `port/build/tools/mkatlas_ft` when the binary is missing or older than the source (`cc -O2 -std=c11`, flags from `pkg-config freetype2`). Inputs (read-only): `extracted/ZapSpot.exe`, `extracted/Moeboid.gam`, `assets/index.json` (cross-check), `fonts/`. Python: the project venv (`tools/.venv`, Pillow for the tests, pefile for `mkluna.py`).

| File | Role |
|---|---|
| `mkpack.py` | PE resource walker, pack writer, manifest. Calls `mkatlas.build_atlases()` and the optional table producers (`TABLE_PRODUCERS`: `mkluna.pack_entries()`) |
| `mkatlas.py` | TrueType table reader (hdmx, VDMX, gasp, OS/2, hhea, post, name), FNT reader, atlas writer, checks |
| `mkatlas_ft.c` | host helper: FreeType rasterization, mono and grey (4x4) modes |
| `mkluna.py` | Luna data (other workstream; see its own section if present) |

## FreeType and flags

- System FreeType **2.14.3** (`/usr/lib/libfreetype.so.6`, Arch package), printed in every run. The atlases depend on this version; another version can change pixels. Check the printed version after a system update.
- TrueType interpreter **v35** (`FT_Property_Set(lib, "truetype", "interpreter-version", 35)`), `FT_LOAD_NO_AUTOHINT`.
- Mono: `FT_LOAD_TARGET_MONO | FT_LOAD_MONOCHROME | FT_LOAD_RENDER`, full hinting at ppem = px, the `hdmx` tag renamed in memory so that the advance comes from the hinted phantom points. These are the flags of the verified check in `analysis/fonts.md` 10.3.
- Grey (decision O6): `FT_LOAD_TARGET_NORMAL | FT_LOAD_NO_BITMAP` (hinting at px; the bytecode sees the grayscale GETINFO bit), outline scaled by 4 in x and y, scan-converted with the FreeType mono rasterizer (dropout flags as set by the font), coverage = set subpixels per 4x4 cell, 0..16. Where gasp has DOGRAY without GRIDFIT (8 px), the outline is not hinted (`FT_LOAD_NO_HINTING`) and the HINTED flag is clear.
- Advances: `hdmx` device width when hdmx lists the size, else the hinted advance. Grey atlases carry the mono advances.
- MS Sans Serif: the 13 px strike of `fonts/sserife.fon` (em height 11 = lfHeight -11, 8 pt at 96 dpi), copied bit for bit; advance = glyph width; top = dfAscent 11.
- Tahoma 3.15, Tahoma Bold 3.15, Trebuchet MS Bold 1.22: `fonts/tahoma.ttf`, `tahomabd.ttf`, `trebucbd.ttf` (file names matched without case). mkatlas prints the name ID 5 version string. **XP-generation font, version unverified** (Windows Server 2003 R2 folder, `fonts/SOURCES.md`); the atlases carry flag UNVERIFIED (0x20). If a file is missing, mkatlas writes an Arial placeholder of the same px and weight with flag PLACEHOLDER (0x01).

## Results (2026-10-11)

- Pack: 175 entries (142 resources, 32 atlases, `data/luna/NORMALBLUE`), 1 565 868 bytes; every resource sha256 and offset equal `assets/index.json`; same sha256 in repeated runs (verified).
- fonts.md 10.3 reproduction: Arial regular 0 of 2674 hinted advances differ from hdmx; VDMX extents equal at ppem 8..36 (verified). Arial **bold**: 4 of 2674 differ: '-' and soft hyphen (0xAD) at ppem 11 (FreeType 3, hdmx 4) and 17 (5, 6), in v35 and v40. The atlases use the hdmx width there (GDI behaviour, inferred); the hyphen bitmap at bold 11 may differ from GDI by one column (no kept text uses bold 11 or 17).
- Atlases: 0 of 2304 advances differ from hdmx (all sizes that hdmx lists: Arial 11, 12, 24, Tahoma 11, Trebuchet 13); cp1252 ink extents equal VDMX for all 16 Arial mono atlases and Tahoma 11; Trebuchet MS 13: VDMX (14, -4) equals the extents over all glyphs of the font (Latin Extended), cp1252 gives (13, -3); tmAscent/tmDescent use VDMX. Arial metrics equal the fonts.md 10.4 table (verified by `test_atlas.py`).
- Gasp: Arial regular `[(8,2),(17,1),(65535,3)]`, bold `[(8,2),(10,1),(65535,3)]`, Tahoma and Tahoma Bold `[(8,2),(16,1),(65535,3)]`, Trebuchet MS Bold `[(8,2),(11,1),(65535,3)]`.
- GIF decoder: 81 GIFs (46 + 35), 258 frames equal the engine-rule model and Pillow compositing; animation slot tables and lookups equal timing.md 4 (verified, `test_gif.py`). Fuzzing with truncated, mutated and random input under ASan/UBSan: 1706 runs, no fault.

## C runtime parts (M3)

No allocation and no libc calls (verified: the wasm32 objects reference no libc symbol); the caller owns all memory.

- `src/gfx/image.h`: `Image` buffer (contract section 8).
- `src/gfx/gif.h`: `gif_decode(data, len, &info, frames, max_frames, pixels, &work)`. Pass 1 with `frames = pixels = NULL` gives `info.width/height/nframes/loop`; pass 2 fills `nframes * width * height` pixels (each frame a full logical-screen RGBA image, keyed frames use `IMG_KEY`, opaque frames start black) and `GifFrame` metadata (delay_ms, keyed, disposal). `GifWork` (16 KiB LZW tables) is scratch memory. `gif_anim_slots(delays_ms, n, table, cap)` builds the 50 ms slot table; `gif_anim_frame(table, nslots, loop, elapsed_ms, &al, &finished)` returns the frame (loop wrap, or image 0 after a non-looping animation ends). Engine addresses and the documented divergences for malformed files are in the source comments.
- `src/text/atlas.h`: pack reader (`mpack_open`, `mpack_next`, `mpack_find`), `atlas_parse`, `atlas_glyph`, `TextFonts` (`text_fonts_load`, `text_fonts_find`).
- `src/text/gdi_text.h`: `gdi_font_select`, `gdi_get_text_metrics`, `gdi_get_text_extent_point32`, `gdi_ext_text_out`.
- Test drivers: `tests/native/gif_dump.c` (used by `test_gif.py`), `tests/native/text_render.c` (command interpreter used by `test_atlas.py`). Renders for review: `tests/results/text_help_mono.png`, `text_help_gray.png`, `text_shell.png`.

## Unproven

- **GDI bitmap identity**: no Windows ground truth. Mono glyphs are FreeType v35 output, verified only through advances (hdmx) and vertical extents (VDMX). Single pixels from dropout control or rounding can differ. Test program for ground truth: `analysis/fonts.md` 10.6.
- **Grey model** (decisions 4b, O6): 4x4 oversampling, 17 levels, linear blend `(dst * (16 - v) + text * v + 8) >> 4`, dropout behaviour, GETINFO grayscale bit, no hinting at 8 px (gasp), mono advances in grey mode, and the rounding: all inferred.
- **GDI rules**: underline row (baseline row + rounded post offset) and thickness, tmExternalLeading and tmAveCharWidth rounding, strikeout position, MS Sans Serif underline (offset 1, thickness 1), `GetTextExtentPoint32A` cy for empty strings, .notdef for unmapped cp1252 bytes, the hdmx preference for advances.
- **Tahoma / Trebuchet MS versions**: XP-generation font, version unverified.
- **FreeType version drift**: atlases are rebuilt from the system library on every pack build.
