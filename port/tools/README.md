# Port build tools (M3)

Formats: `docs/port-design.md` sections 7 (pack) and 8 (atlases, image buffer, text API).

## Rebuild

```
source tools/env.sh                          # in the project root
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

## Luna (mkluna.py, workstream LUNA)

Windows XP Luna (NormalColor, NormalSize) data for the non-client frame of the 8 dialogs and the MessageBox (decision 4a, O1). ZapSpot.exe has no manifest: only caption, border and caption buttons are themed; client controls are classic with the Luna system colours.

```
python -I -B port/tools/mkluna.py            # port/build/luna/normalblue.bin + normalblue.json
python -I -B port/tests/py/test_luna.py      # data, C renderer, review PNGs in port/tests/results/luna/
```

Input: `fonts/luna.msstyles` (sha256 `dd8e86e5...`, `fonts/SOURCES.md`), read with pefile as data only (resource directory: TEXTFILE `NORMALBLUE_INI`, `THEMES_INI`; RT_BITMAP `BLUE_*_BMP`). Nothing in the file is loaded or executed. Output: pack entry `data/luna/NORMALBLUE` through `mkpack.py` `TABLE_PRODUCERS` (`mkluna.pack_entries()`); the same bytes in `port/build/luna/normalblue.bin`; `normalblue.json` lists every value with its INI line and status. Deterministic (39 984 bytes, sha256 `36d375ab...` on 2026-10-11).

### Blob format `LUNA` version 1 (little-endian, records 4-byte aligned)

| Part | Layout |
|---|---|
| header (32) | `"LUNA"`, u16 version 1, u16 header size 32, u16 n_colors, u16 n_metrics, u16 n_parts, u16 n_images, u32 offsets of colors, metrics, parts, images |
| color (8) | u16 id (Windows `COLOR_*` index; 64 caption shadow, 65 dialog fill), u8 source, pad, u8 r, g, b, pad |
| metric (8) | u16 id (`LUNA_M_*` in `src/shell/luna.h`), u8 source, pad, i32 value |
| part (48) | u16 id (1 caption, 2 frame left, 3 frame right, 4 frame bottom, 5 close button), u16 image, u16 glyph (0xFFFF none), u8 image_count, u8 glyph_count, u8 sizing type (0 stretch, 1 tile, 2 truesize), u8 layout (0 vertical), u8 flags, u8 offset type (1 top left, 2 top right), i16 SizingMargins[4], ContentMargins[4], CaptionMargins[4] (left, right, top, bottom), i16 Offset[2], u8 FillColorHint r, g, b, 5 bytes 0 |
| image (16) | u16 w, u16 h, u16 flags (1 alpha, 2 colour key applied), u16 source bpp, u32 data offset, u32 data length |
| pixels | RGBA, top-down, straight alpha (as in the file); colour-key pixels (255 0 255) stored as (0, 0, 0, 0) |

Source byte: 1 = `[SysMetrics]`, 2 = other NORMALBLUE_INI section (both verified), 0 = inferred.

### Verified from the file (resource, INI line)

- `[SysMetrics]` (lines 17-66): Btnface 236 233 216 (COLOR_3DFACE), BtnHighlight 255 255 255 (3DHILIGHT), Light3d 241 239 226, BtnShadow 172 168 153, DkShadow3d 113 111 100, Window 255 255 255, Highlight 49 106 197, HighlightText 255 255 255, GrayText 172 168 153, ActiveCaption 0 84 227, CaptionText 255 255 255, InactiveCaption 122 150 223, InactiveCaptionText 216 228 248, GradientActiveCaption 61 149 255, GradientInactiveCaption 157 185 235, Background 0 78 152, Menu, MenuBar, MenuHilight. CaptionBarHeight 25 (line 46), CaptionFont Trebuchet MS 10 bold (45), SmallCaptionFont Tahoma 8 bold (47), MsgBoxFont Tahoma 8 (52), SMCaptionBarHeight/Width 17, ScrollbarWidth/Height 17. THEMES_INI `[Subst.NormalSize]` repeats CaptionBarHeight, CaptionFont, MsgBoxFont (cross-checked).
- `[Window]` (1020): Transparent true, TextShadowOffset 1,1, TextShadowColor 10 24 131. `[Window.Caption(active)]` (1037): TextShadowType Single. `[Window.dialog]` (1154): FillColor 236 233 216.
- `[Window.Caption]` (1026): `Blue\FrameCaption.bmp` = `BLUE_FRAMECAPTION_BMP` 66x58 8 bpp, ImageCount 2 vertical (29 rows per state: active, inactive), SizingMargins 28, 35, 9, 17, SizingType stretch, ContentMargins 1,1,1,1, CaptionMargins 4, 3, 0, 0, Transparent true, FillColorHint 0 84 229. 12 magenta pixels per top corner.
- `[Window.FrameLeft]`/`FrameRight` (1097/1106): `BLUE_FRAMELEFT_BMP`/`BLUE_FRAMERIGHT_BMP` 5x62 8 bpp, 2 states, SizingMargins 2, 2, 0, 0, stretch, Transparent false. `[Window.FrameBottom]` (1115): `BLUE_FRAMEBOTTOM_BMP` 49x10, 2 states, SizingMargins 5, 5, 2, 2.
- `[Window.CloseButton]` (1161): `BLUE_CLOSEBUTTON_BMP` 21x168 32 bpp with alpha (8 states of 21x21), SizingMargins 5,5,5,5, ContentMargins 2,2,2,2, OffsetType TopRight, Offset -25, 5, GlyphType ImageGlyph, ImageSelectType size, ImageFile1..5 = CloseGlyph6/9/(13)/19/23. Alpha in the file is straight (not premultiplied): 134 pixels have a channel above alpha.
- Absent for these parts (no value used): TextColor, BorderSize, MinSize, ContentAlignment, TransparentColor, GlyphImageFile.

### Inferred (no Windows ground truth, decision 4c)

- Frame size: border 3 px left, right, bottom (SM_CXFIXEDFRAME; XP themes do not change it; the 4 px white band of `BLUE_FRAMECAPTIONSIZING_BMP` is the sizing-frame variant). Top = 3 + SM_CYCAPTION; SM_CYCAPTION = CaptionBarHeight + 1 = 26; top 29 = caption image height (consistent). Window = client + (6, 32).
- Placement: caption image over the full top 29 rows; left/right frames between caption and bottom frame; bottom frame across the full width.
- Nine-grid: nearest neighbour; source = segment start + d * src / dst (floor); when the destination is smaller than the margins they shrink in proportion (left = dst * l / (l + r)). So the 5-px frame images give columns 0, 3, 4 at 3 px.
- Colour key: TransparentColor default 255 0 255; key pixels are not drawn (the window region clips the rounded corners).
- Alpha images: premultiplied at load, AlphaBlend per pixel: `d = (s*a + 127)/255 + (d*(255-a) + 127)/255`.
- States: caption and frames image 1 active, 2 inactive; close button images 1-4 = CBS_NORMAL..DISABLED active, 5-8 the same for inactive windows.
- Close button: at (win_w - 25, 5), 21x21 (Offset relative to the window's top-right corner, no DPI scaling). Glyph: ImageSelectType size picks the largest ImageFileN that fits the 17x17 content box = `BLUE_CLOSEGLYPH_BMP` 13x13 (32 bpp alpha), centred (button + 4, + 4). No ZapSpot template has WS_SYSMENU (0x80C008C0, 0x90C00840), so only the MessageBox has the button.
- Caption text: rectangle x = 3 + CaptionMargins.left = 7, y = 3, h = 26, right = close button left (or win_w - 3) - 3. DT_SINGLELINE | DT_LEFT | DT_VCENTER | DT_END_ELLIPSIS; y = 3 + (26 - tmHeight 18) / 2 = 7. Colour COLOR_CAPTIONTEXT / COLOR_INACTIVECAPTIONTEXT (no TextColor in the theme). Shadow (active only): 10 24 131 at (+1, +1), drawn first. Font: atlas Trebuchet MS 13 px bold (grey when smoothing is on, gasp allows it).
- Colours not in `[SysMetrics]`: BTNTEXT, WINDOWTEXT, WINDOWFRAME 0 0 0; SCROLLBAR 212 208 200 (Windows default scheme).
- Inactive caption has no text shadow (TextShadowType only in `Caption(active)`).
- MessageBox client size for the test image ("Name too long", MB_OK | MB_ICONEXCLAMATION): 325x88 from NT MessageBox dialog units with the message font (Tahoma 8: base units 6x13 from hdmx/VDMX, verified): margin 7 DLU (11 px), icon 32 + gap 10 DLU (15 px), text 256 px (hdmx), button 50x14 DLU (75x23), gap above the buttons 7 DLU. Rule inferred; M5 owns the MessageBox client layout.

### API for M5 (`src/shell/luna.h`)

```c
LunaTheme lt;                                   /* in the Port state; points into the pack */
uint32_t len; const uint8_t *b = mpack_find(&pack, "data/luna/NORMALBLUE", &len);
if (!b || luna_load(&lt, b, len) != LUNA_OK) { /* no Luna data: fall back */ }
GdiFont cap;                                    /* caption font from M3 atlases */
gdi_font_select(&cap, &fonts, "Trebuchet MS", -luna_font_px(luna_metric(&lt, LUNA_M_CAPTION_FONT_PT)),
                luna_metric(&lt, LUNA_M_CAPTION_FONT_WEIGHT), 0, 0);
LunaWindow w = {client_w, client_h, active, has_sysmenu, LUNA_BTN_NORMAL, caption, -1};
LunaGeom g;                                     /* window size, client rect, close rect for hit tests */
luna_draw_window(&lt, &frame_image, win_x, win_y, &w, &cap, 1 /* smoothing */, &g);
uint32_t face = luna_pixel(&lt, LUNA_COLOR_3DFACE);   /* IMG_RGB pixel; luna_color() gives 0xRRGGBB */
```

`luna_geom()` gives the geometry without drawing (centring with DS_CENTER, hit tests). `luna_color(t, i, &src)` reports the source (LUNA_SRC_SYSMETRICS, LUNA_SRC_INI, LUNA_SRC_INFERRED). Close button states: LUNA_BTN_NORMAL, HOT, PUSHED, DISABLED (MB_YESNO disables it). No allocation, no floating point, no static state.
