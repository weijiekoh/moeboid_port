# Rendering and colour (workstream D)

Status: complete for phase 1. Section 12 lists open items.

Labels: **verified** = read from code, data or screenshots at the given reference. **inferred** = conclusion, with the reason. **unknown** = not determined.

References: `zap:0x4xxxxx` = address in `extracted/ZapSpot.exe` (image base 0x400000). `gam:0x10xxxxxx` = address in `extracted/Moeboid.gam`. `decomp:N` = line N of `analysis/decomp/ZapSpot.exe/decompiled.c`. Screenshots: `capX/name.png` = Wine captures in the workstream I scratch directory (`.../scratchpad/I/capX/`); workstream I copies them to `analysis/reference/`. Scripts used for the checks: `.../scratchpad/D/verify_layout.py`, `gifeng.py`, `keycheck.py`.

## 0. Summary

1. The engine has two renderers: DirectDraw (class strings `CSubsystem_Video_DirectX`, `CRenderer_DirectX`, `CRenderTarget_DirectX`) and GDI (`CRenderTarget_GDI`). There is no registry key and no command-line switch. The engine uses DirectDraw when `DDraw.dll` loads and `DirectDrawCreate` and the initialisation succeed; else it uses GDI (verified, zap:0x426ce0). A Windows 2000/XP machine uses DirectDraw (inferred: both systems ship DirectDraw).
2. DirectDraw runs **windowed** (`DDSCL_NORMAL`). There is no display mode change, no back buffer chain and no `Flip`. All images are offscreen surfaces in **system memory** with the desktop pixel format. One `Blt` per frame copies the 800x572 frame buffer to the primary surface through a clipper (verified, zap:0x408130, zap:0x4086d0, zap:0x408a90).
3. **The frame buffer has the desktop bit depth, not 8 bits.** On a 16/24/32-bit desktop the engine draws in 16/24/32-bit colour. It uses a palette only when the Windows desktop itself is in 8-bit mode. The engine never changes the palette at run time: no fades, no flashes, no per-screen palettes (verified, section 3).
4. On a 24/32-bit desktop every GIF pixel keeps its exact file RGB value. The Wine reference captures confirm this: 202961 of 210000 title-screen pixels and 8428 of 8431 logo pixels have the exact GIF RGB values (verified, section 3.6).
5. The 8-bit palette (8-bit desktop only) is: 20 Windows static colours, the 216-colour web-safe cube at indices 10-225, and indices 226-245 copied from the current system palette (unknown content). It is **not** the IMG-SPLASH palette. #3300ff and #33ff00 are web-safe, so they map exactly to cube indices 51 and 76 (verified, zap:0x408130, zap:0x4087e0).
6. Transparency uses a source colour key with the value **magenta** (#ff00ff, or its 16-bit or palette equivalent). The GIF decoder does not write transparent pixels, so the image keeps the magenta fill there. No visible GIF pixel collides with the key at 32, 16 (565) or 15 (555) bits (verified, section 4).
7. The engine composes a retained tree of surfaces (`CSurface`) with dirty rectangles. A 50 ms shell timer renders the tree when something is dirty (verified, zap:0x41b210, zap:0x414cd0).
8. Window: popup window 800x572 without caption or border; the engine draws the whole client area, including its own title bar and buttons. Game area: 500x420 at client (282,50). Ad banner: 470x62 at (280,500) (verified, zap:0x404790, zap:0x41d6c0, screenshots).
9. Cursors: six monochrome Win32 cursors from resources, set with `SetCursor`. No software cursor, the cursor is never hidden (verified, zap:0x425a80, imports).
10. Port recipe: 800x572 RGB frame buffer, GIF RGB as-is, 1-bit transparency, painter's order of the surface tree, nearest-neighbour integer scaling. No palette emulation is necessary for the 24/32-bit look (section 11).

## 1. Video subsystems and selection

| Item | Value | Reference |
|---|---|---|
| Selection function | zap:0x426ce0, called once from engine start zap:0x413040 (decomp:19004); result in global `0x45cfa0` | verified |
| Step 1 | `LoadLibraryA("DDraw.dll")`. Failure: GDI subsystem (zap:0x428520) | verified, zap:0x426d08 |
| Step 2 | `GetProcAddress("DirectDrawCreate")`. Missing: error message, returns NULL | verified, zap:0x426d22 |
| Step 3 | `DirectDrawCreate(NULL, &dd, NULL)`, then `Release`. If HRESULT = 0x887600de (DDERR_NODIRECTDRAWSUPPORT): call zap:0x40116c(-1) (exit path), else continue | verified, zap:0x426d90 |
| Step 4 | HRESULT = 0: create `CSubsystem_Video_DirectX` (zap:0x408080, size 0x27554). If its init fails (global `0x459e4c` != 0): delete it and create the GDI subsystem | verified, zap:0x426da3 |
| Step 5 | Any other HRESULT: GDI subsystem `CSubsystem_Video_GDI`-like class (zap:0x428580, vtable 0x42f138, size 0x27544) | verified |
| Registry / command line | none read in this path | verified (no other inputs in zap:0x426ce0) |
| Typical Windows 2000/XP | DirectDraw | inferred: Windows 2000 ships DirectX 7, Windows XP DirectX 8.1; `DirectDrawCreate(NULL)` succeeds with any display driver |
| Wine reference runs | DirectDraw (Wine ddraw) on a 24/32-bit X display | inferred from exact RGB values in the captures (section 3.6) |

Video subsystem vtable, DirectDraw `0x42e730` (GDI `0x42f138` has the same layout):

| Offset | DirectDraw | GDI | Function |
|---|---|---|---|
| +0x00 | 0x408760 | 0x428760 | Realize palette: 8-bit only, `SetPalette` on the primary surface again (GDI: `SelectPalette`+`RealizePalette` on the window DC) |
| +0x04 | 0x4087a0 | 0x4287a0 | Is8Bit (byte at +0x2754e) |
| +0x08 | 0x408da0 | 0x428c00 | Restore surfaces (`WM_DISPLAYCHANGE`); DirectDraw: `Restore` on the primary surface, on DDERR_WRONGMODE re-run InitDirectDraw |
| +0x0c | 0x4087e0 | 0x4287e0 | RGB to palette index (section 3.3) |
| +0x10 | 0x408900 | 0x428900 | RGB to 16-bit pixel (section 3.4) |
| +0x14 | 0x4087b0 | 0x4287b0 | Palette index to RGB |
| +0x18 | 0x408960 | 0x428960 | 16-bit pixel to RGB |
| +0x1c | 0x4089e0 | 0x4289e0 | Get colour key value |
| +0x20/+0x24/+0x28 | 0x408c10 / 0x408c70 / 0x408cc0 | 0x428b60 / 0x428bc0 / 0x428bf0 | Window drag: move, begin (`SetCapture`, cursor 4), end (cursor 3, save `WindowXLoc`/`WindowYLoc`) |
| +0x2c | 0x408a00 | 0x428a00 | Create render target (w, h, keyed) |
| +0x30 | 0x408a70 | 0x408a70 | Delete render target |
| +0x34 | 0x408a90 | 0x428a70 | Present frame buffer to the window |
| +0x38 | 0x428b30 | 0x428b30 | Minimise (`ShowWindow(SW_MINIMIZE)`); Esc key calls it (zap:0x4040e0) |
| +0x3c | 0x408be0 | 0x408be0 | Hide window (`ShowWindow(SW_HIDE)`) |
| +0x40 | 0x4137f0 | same | Clear dirty-rectangle list |
| +0x44 | 0x413810 | same | Rectangle intersects a dirty rectangle (inclusive edges) |
| +0x48 | 0x413860 | same | Add dirty rectangle (x, y, w, h); skip if equal to the last one; max 10000 |
| +0x4c | 0x413800 | same | Dirty flag |

## 2. DirectDraw setup (InitDirectDraw, zap:0x408130, decomp:6895)

All items verified at the given addresses. IDirectDraw and IDirectDrawSurface vtable offsets are DirectX 3 layout (`IDirectDraw`, `IDirectDrawSurface`, no `QueryInterface` to newer versions in this path). A separate probe zap:0x40afa0 (strings "Couldn't QI DDraw2", "Couldn't CreateSurface") creates DirectDraw objects only to detect the DirectX version for the diagnostic report (callers zap:0x4055e0, zap:0x406510 with the "OSInfo" strings); it does not draw (inferred from the callers and strings).

- `DirectDrawCreate(NULL, &dd, NULL)` through `GetProcAddress`.
- `IDirectDraw::SetCooperativeLevel(hwnd, 8)`: 8 = `DDSCL_NORMAL`. Windowed. No `SetDisplayMode` call (IDirectDraw +0x54) exists in zap:0x408080..0x408e00 (verified: no `call [reg+0x54]` in that range).
- `IDirectDraw::GetDisplayMode(&desc)`: reads `dwRGBBitCount` and the R/G/B masks of the desktop. If bit count < 8: message "ZapSpot requires a screen resolution of 8bpp or greater". Bit count is stored in global `0x459e44` and at +0x27134.
- Primary surface: `CreateSurface` with `DDSD_CAPS`, `DDSCAPS_PRIMARYSURFACE` (0x200). No back buffer, no `DDSCAPS_FLIP`.
- Clipper: `IDirectDraw::CreateClipper`, `IDirectDrawSurface::SetClipper` on the primary, `IDirectDrawClipper::SetHWnd(hwnd)`.
- 16/24/32-bit desktop: shift and loss values from the masks (+0x27548..+0x2754d). Colour key: 16-bit = packed magenta from the masks; 24/32-bit = 0xff00ff.
- 8-bit desktop: palette set-up, section 3.3. Colour key = `RGBToIndex(255,0,255)` = index 195.
- Offscreen surfaces (zap:0x4086d0): `DDSD_CAPS|DDSD_HEIGHT|DDSD_WIDTH`, caps 0x840 = `DDSCAPS_OFFSCREENPLAIN|DDSCAPS_SYSTEMMEMORY`. No pixel format given, so the format is the primary format. Keyed images add `DDSD_CKSRCBLT` with low = high = colour key.
- Software drawing: the GIF decoder writes pixels after `Lock(NULL, desc, DDLOCK_WAIT, 0)` (render target +0x4c zap:0x40c250, `Unlock` +0x50 zap:0x40c2a0). All other drawing uses `GetDC` on the surface and GDI (`FillRect`, `MoveToEx`/`LineTo`, `ExtTextOutA`) or `Blt`.
- `Blt` only: no `BltFast` (+0x1c) or `Flip` (+0x2c) surface call in zap:0x408080..0x408e00 and zap:0x40b950..0x40c440 (verified). Flags: `DDBLT_WAIT` (0x1000000), plus `DDBLT_KEYSRC` (0x8000) when the source render target is keyed (zap:0x40bf70). No `DDBLTFX`, so no mirroring, no colour fill by Blt, no raster operations.
- Present (zap:0x408a90): `IDirectDrawSurface::Blt` on the primary (dest = client rectangle in screen coordinates (ClientToScreen(0,0), size 800x572), src = whole frame-buffer surface, `DDBLT_WAIT`). Retries while DDERR_WASSTILLDRAWING. On DDERR_SURFACELOST it restores and retries; if that fails it shows "ZapSpot does not yet support changing the display depth while running" and exits.
- Display depth change at run time: not supported (message above).

## 3. Pixel formats, palette and colour

### 3.1 Frame buffer

- The frame buffer is the image of the root surface (the shell, zap:0x41acb0): 800x572, opaque, same pixel format as the desktop (verified: zap:0x41acb0 calls `CSurface(0x4324a0=800, 0x4324a4=572, flags 0)`; zap:0x4086d0 uses the primary format).
- Desktop width < 800: the engine uses 640x460 (0x280 x 0x1cc) and a different layout (verified, zap:0x403d40, zap:0x41d6c0 branch at zap:0x41d816). Not relevant for the port (inferred: the port targets the 800-wide layout seen in the captures).

### 3.2 Palette operations: complete list

| Call | Where | When | Content |
|---|---|---|---|
| `GetSystemPaletteEntries(0, 256)` | zap:0x4083d2 (DirectDraw), zap:0x428682 (GDI) | init, 8-bit desktop only | base table |
| `IDirectDraw::CreatePalette(DDPCAPS_8BIT, entries)` | zap:0x408130 (vtable +0x14) | init, 8-bit only | table of 3.3 |
| `IDirectDrawSurface::SetPalette` on primary | zap:0x408130, zap:0x408760 | init; `WM_QUERYNEWPALETTE`; `WM_PALETTECHANGED` from another window | same palette object |
| `IDirectDrawPalette::GetEntries` | zap:0x408130 | init | copy kept at +0x27138 for RGB-to-index |
| `CreatePalette` (GDI) | zap:0x4286ee | init, GDI path, 8-bit only | same table as 3.3 |
| `SelectPalette`/`RealizePalette` | zap:0x428760, zap:0x428a70, zap:0x42a3b0 | GDI path, 8-bit only | same palette |
| `GetPaletteEntries` + `SetDIBColorTable` | zap:0x42a3b0 | GDI path, 8-bit only, each new DIB section | DIB colour table = palette |
| `SetEntries` | none | never | no import, no vtable call found |

Result (verified from this table): the palette content never changes after init. No fades, flashes or per-screen palettes exist. The game DLL cannot reach a palette function: no interface wrapper calls video subsystem +0x00 or +0x0c except the GIF loader (verified, wrappers zap:0x415020..0x4160f0).

### 3.3 8-bit desktop: palette and colour mapping

Palette (verified, zap:0x408130 lines decomp:7076-7104; same in GDI zap:0x428580):

- Index 0-9 and 246-255: system palette entries (Windows static colours).
- Index 10-225: web-safe cube, `index = 10 + 36*(R/51) + 6*(G/51) + B/51`, flags `PC_RESERVED|PC_NOCOLLAPSE` (5).
- Index 226-245: copied from the system palette at start-up, flags as returned by `GetSystemPaletteEntries`. Content: **unknown** (depends on the palettes of other programs at that moment).

RGB to index (zap:0x4087e0, used for every GIF colour-table entry, zap:0x418d90):

1. If R, G and B are all multiples of 51: return the cube index above. All 98 game colours are web-safe, so the game art maps exactly. #3300ff maps to index 51, #33ff00 to index 76.
2. Else: search all 256 entries, distance = (dR)^2 + (dG)^2 + (dB)^2 (equal weights), keep the first strict minimum (lowest index wins a tie), stop at distance 0.

Colours that GDI draws into 8-bit surfaces (`FillRect`, text, lines with an RGB `COLORREF`): **unknown**. No palette is selected into the surface DC in the DirectDraw path, so GDI maps them by its own rules (inferred: nearest static colour or dither). This affects only 8-bit desktops.

Colour key in 8-bit mode: the key is index 195 (cube magenta), but keyed images are cleared with GDI `FillRect` and RGB(255,0,255) (zap:0x40b950, zap:0x40be30). The static palette entry 253 is also #ff00ff. If GDI picks 253, transparent areas show magenta on 8-bit desktops. Which index GDI picks: **unknown**.

IMG-SPLASH palette: not used by the engine palette. The splash bitmap is drawn by GDI `BitBlt` from `LoadBitmapA` (zap:0x403d40). On a 24/32-bit desktop GDI shows its exact colours (inferred: standard DDB conversion).

### 3.4 16-bit desktop

- GIF pixel to 16-bit pixel (zap:0x408900): `((R >> rLoss) << rShift) + ((G >> gLoss) << gShift) + ((B >> bLoss) << bShift)`. Truncation, no rounding, no dithering (verified). Loss and shift come from the primary masks (565: rLoss 3, gLoss 2, bLoss 3).
- How the display hardware expands 5/6-bit values to 8 bits: **unknown** (inferred: typical `x<<3 | x>>2`). 16-bit pixel to RGB in the engine (zap:0x408960) uses `x << loss` without bit replication; the engine uses it for colour queries only.
- GDI (`FillRect`, text) on 16-bit surfaces: conversion by GDI, **unknown** detail (inferred: also truncation).
- GDI renderer path, 16-bit: DIB sections with `biBitCount` 16 and `BI_RGB` (555), colour key 0x7c1f. The GDI constructor zap:0x428580 does not set the shift fields that zap:0x428900 reads (inferred from the code: no writes to +0x27538..+0x2753d found in zap:0x428580). Colours in this rare path may be wrong; not relevant for the port.

### 3.5 24/32-bit desktop

- GIF pixel: B, G, R bytes written unchanged (zap:0x418870, cases 0x18 and 0x20). The fourth byte of a 32-bit pixel is not written.
- GDI colours: exact `COLORREF` values.
- Result: every pixel is the exact RGB of the source (verified by the captures, 3.6).

### 3.6 Check against the Wine captures (verified, `verify_layout.py`)

| Element | Position | Exact-RGB match | Note |
|---|---|---|---|
| IMG-TITLESCREEN-500X420, frame 0 | (282,50) | 202961 / 210000 | rest: sprites and text over it |
| IMG-BACKGROUNDSCREEN-500X420, composited frame 2 | (282,50) | 206355 / 210000 | 2453 pixels: score box filled with #ff9933 |
| IMG-ZAPLOGO | (10,10) | 8428 / 8431 | |
| IMG-GAMEAREA, outside child surfaces | (190,13) | 43192 / 51500 | rest: big buttons drawn over it |
| Root background | outside images | 90463 pixels are exactly #3333cc | |

Captures: `capN/01_title_fresh.png`, `capN/20_game_moving.png`. The Wine display depth is not recorded in `run_original.sh`; the exact values show a 24/32-bit desktop (inferred).

### 3.7 Exact colour recipe for the port

For the 24/32-bit look (recommended, identical to the Wine captures):

1. Each GIF pixel: RGB from the global colour table entry of its index (no GIF here has a local table).
2. Transparent GIF pixel (GCE flag set and index = transparent index): alpha 0. All other pixels: alpha 255. No partial alpha exists anywhere.
3. `FillRect`, line, text and clear colours: the RGB values the code passes (for example #3333cc, #ff9933, #3399ff, #9999cc, #cc3399, #333333).
4. Blit: copy pixels with alpha 255, skip alpha 0. No blending, no scaling.
5. Output: frame buffer RGB unchanged.

Optional 16-bit look (only if the user wants a typical 16-bit Windows 2000 machine): per channel `v5 = R >> 3`, `v6 = G >> 2`, `v5b = B >> 3`, then expand with the assumed DAC rule. Uncertain (3.4).

8-bit look: not reproducible exactly (palette entries 226-245 and GDI colour mapping unknown). For game art it equals the 24/32-bit look, because all game GIF colours are in the cube.

## 4. GIF decoding in the engine

Loader: `CImageSeq::LoadGIF` zap:0x418d90; LZW driver zap:0x418a70; pixel writer zap:0x418870. All verified.

- Signature check: compares the 6 header bytes with "Gif87a" and "Gif89a" (0x434d30, mixed case) and reports an error only if the header equals both (zap:0x418e80..0x418e98). The check never fails, so it has no effect (verified).
- Logical screen size: every frame becomes one `CImage` of the **logical screen size**, not the frame rectangle size.
- Global colour table: read. 8-bit desktop: each entry mapped once with RGB-to-index.
- Local colour table: read, but the 8-bit mapping code converts the global table into the global map (bug; inferred harmless: 0 local tables in the 81 GIFs, `assets/INDEX.md`).
- Graphic Control Extension: packed byte, delay, transparent index. **The values persist** to later frames that have no GCE of their own (the variables are not reset per frame).
- Keyed image: a frame image is keyed (colour key, magenta fill) when the current GCE transparency flag is set; else it is opaque and starts black (render target constructor zap:0x40b950 clears to (255,0,255) or (0,0,0)).
- Transparent pixels: the writer skips them (zap:0x418870 tests flag and index). The surface keeps its fill (magenta key) or the copied previous frame.
- Disposal of the **previous** frame before a new frame (zap:0x4192f3..0x419307): 1 or 3: copy the previous frame image to (0,0) with `DrawAt` (keyed copy if the previous image is keyed); 2: clear the whole new image to its background colour; 0 and 4-7: nothing (new image keeps its fill). Disposal 3 (restore previous) is treated as 1.
- Interlace: standard four passes, tables at 0x434b6c (steps 8,8,4,2) and 0x434b80 (starts 0,4,2,1).
- Indices beyond the table size: read beyond the table (undefined). None occur in the 81 GIFs (verified, `keycheck.py`).
- NETSCAPE2.0 extension: sets the loop flag of the sequence (+0x28). The loop count is read and ignored (infinite loop). Sub-block id 5 is rejected with an error. Without the extension the sequence does not loop.
- Delay: `delay_cs * 10` ms per image (zap:0x418d90 call to zap:0x416e80).
- Animation time base (zap:0x4171b0 `CAnim::RecalcTimes`, zap:0x4170d0): a table of 50 ms slots; image i gets `delay_ms / 50` slots (integer division; an image with delay < 50 ms is never shown). Time t selects slot `t / 50`. Past the end: looping sequences use `slot mod total`; non-looping sequences show **image 0** and report "finished". Timing detail belongs to workstream C.

Comparison with standard GIF compositing (verified, `gifeng.py` over all 81 GIFs): the engine result equals standard compositing in every frame of every GIF, when standard "transparent" is read as magenta key for keyed frames and black for opaque frames. Pillow-style decoding plus the rules above gives the engine images.

Colour-key collisions (verified, `keycheck.py`): no visible pixel of a keyed frame equals the key at 32 bits (#ff00ff), at 565 or at 555. The RGB-collision warning in `assets/INDEX.md` (white transparent entry plus visible white) does not apply to the engine, because the engine keys on magenta written by the decoder, not on the GIF colour of the transparent entry.

## 5. Scene composition and frame present

Classes (verified): `CSurface` (vtable 0x42eab8, size 0x58, constructors zap:0x414190 blank, zap:0x414330 from GIF, zap:0x414470 from animation), `CImage` (0x42eaa4, zap:0x4138f0; owns one render target), `CImageSeq` (0x42ec64), `CAnim` (0x42ec78), render target (DirectDraw 0x42e790 zap:0x40b950; GDI 0x42f188 zap:0x4299e0).

- A surface has a position relative to its parent (+0x20,+0x24), a visible flag (+0x0d), an ordered child list (+0x14, count +0x18), and a current animation whose current image is drawn.
- Z-order: children draw after the parent, in list order. `AttachChild` (zap:0x414780) appends, so the last attached child is on top. `BringToFront` (zap:0x414900) detaches and re-attaches.
- Dirty rectangles: `SetLoc`, `SetVisible`, attach, detach call `Invalidate` (zap:0x414ef0): absolute rectangle of the surface (sum of parent offsets, image size) is added to the dirty list. `SetLoc` adds the old and the new rectangle. Any draw operation on an image (zap:0x414120) and any change of animation frame (zap:0x417800) invalidates every surface that shows that image, as a whole.
- Render (zap:0x41b210): if the dirty flag is set: `CSurface::Render(root, target NULL, clip = 0,0,800,572)` (zap:0x414cd0), then present (video +0x34), then clear the dirty list.
- `CSurface::Render` (zap:0x414cd0, checked in assembly): compute the surface rectangle clipped by the parent rectangle. If empty: return. Root (target NULL): draw nothing for itself; its own image is the frame buffer. Other surfaces: if the clipped rectangle intersects no dirty rectangle (inclusive edge test zap:0x413810): **return, also skipping all children**. Else blit the **whole clipped surface** (not only the dirty part) to the frame buffer with `CImage::Draw` (keyed if the image is keyed). Then recurse into visible children.
- Consequence (inferred from the algorithm): the root image is never cleared. It holds the frame graphics drawn once at skin load. A child that moves is erased only because an opaque surface below it is redrawn. A keyed surface directly on the root that changes its image keeps old pixels where the new image is transparent. A surface that does not intersect a dirty rectangle is not redrawn even if a surface below it was redrawn over it. Whether Moeboid shows such artefacts is unknown; the game redraws its 500x420 image often, which invalidates the whole game area.
- Trigger: a shell timer (zap:0x41d6c0, decomp:28183: timer object zap:0x413440 with period 0x32 and callback zap:0x41f1d0) calls zap:0x41b170, which calls zap:0x41b210. The timer (zap:0x413510) fires when `now - last >= period` and then sets `last = now` (no catch-up). Unit: inferred milliseconds (the ad timer uses 60000 together with a 60-second counter, zap:0x421bf0); workstream C confirms. Other calls: `WM_PAINT` (adds the paint rectangle, but passes right/bottom as width/height, so the dirty area is larger), window deactivation, before modal dialogs (zap:0x4040e0, zap:0x405400). Frame rate of the display is therefore at most 20 per second while dirty (timing: workstream C).

## 6. Draw operations available to the game

The game gets interfaces through `ctx` (zap:0x424620): ctx[2] and ctx[3] = `ISurface` wrappers (vtable 0x42eb34) of the shell surfaces +0x2c8 and +0x2cc (the two 500x420 game surfaces); ctx[4] = factory (vtable 0x42eae0, global 0x45cfd4). Workstream B owns the complete map; this section lists drawing semantics.

### 6.1 IImage (wrapper vtable 0x42ebb0; CImage method; render target slot)

| Offset | Wrapper | CImage | RT slot: DirectDraw / GDI | Operation and pixel semantics |
|---|---|---|---|---|
| +0x08 | 0x415890 | 0x413ba0 | +0x04: 0x40baf0 / 0x429b50 | Line(x1,y1,x2,y2): GDI `MoveToEx`/`LineTo` with `CreatePen(PS_SOLID,1,cur colour)`; end point not drawn; vertical lines clipped in y, other lines clipped in x only |
| +0x0c | 0x4158b0 | 0x413bd0 | +0x08: 0x40bc00 | Frame rectangle: four Line calls (x1,y1)-(x2,y1)-(x2,y2)-(x1,y2)-(x1,y1) |
| +0x10 | 0x4158d0 | 0x413c00 | +0x0c: 0x40bc60 / 0x429c50 | FillRect(left,top,right,bottom): GDI `FillRect` with solid brush of the current colour; right and bottom exclusive; nothing if right < left or bottom < top |
| +0x14 | 0x4158f0 | 0x413c90 | (text layout zap:0x416190) | ZML text: workstream E |
| +0x18 | 0x415920 | 0x413c30 | +0x3c: 0x40c110 / 0x42a250 | Text out (`ExtTextOutA`, `ETO_CLIPPED`, clip 0,0,800,600): workstream E |
| +0x1c / +0x20 | 0x415940 / 0x415960 | 0x413d10 / 0x413d30 | +0x14 / +0x18 | Set / get current colour (R,G,B) for pen and brush |
| +0x24 / +0x28 | 0x415980 / 0x4159a0 | 0x413d50 / 0x413d70 | +0x1c 0x429d50 / +0x20 | Set / get text colour; default white |
| +0x2c / +0x30 | 0x4159c0 / 0x4159e0 | 0x413d90 / 0x413db0 | +0x24 / +0x28 | Set / get background colour; default (255,0,255) keyed or (0,0,0) opaque |
| +0x34 | 0x415a00 | 0x413dd0 | +0x2c: 0x40be30 / 0x429e30 | ClearToColor(R,G,B): fill whole image |
| +0x38 | 0x415a20 | 0x413e80 | +0x30: 0x40bed0 | Clear to background colour |
| +0x3c | 0x415a50 | 0x413f30 | +0x34: 0x40bf70 / 0x429f50 | Draw(destRect, srcImage, srcRect): `Blt`; key if source keyed; dest clipped to the target; NULL source = (0,0,source width, min(source height, target height)); NULL destination = whole target (zap:0x40bf70). DirectDraw scales if the sizes differ; the GDI path copies without scaling (zap:0x429f50). Only caller with different sizes: the frame edge tiling (zap:0x41eac0, zap:0x41eb50) for its last partial tile; the edge cells 4-7 of slb-BevelEdges are uniform along the tiling direction, so the result equals cropping (verified). The game never calls +0x3c |
| +0x40 | 0x415a30 | 0x413f00 | +0x38: 0x40bef0 / 0x429ed0 | DrawAt(srcImage, x, y): unscaled copy, clipped to the target |
| +0x44 | 0x415a70 | 0x413f60 | +0x40: 0x40c100 / 0x42a240 | returns constant 2 / 0; purpose unknown |
| +0x48 / +0x4c | 0x415a90 / 0x415ab0 | 0x413f80 / 0x413fb0 | | Set / get font (E) |
| +0x50 | 0x415b00 | 0x413fd0 | +0x54 | Get size |
| +0x54 | 0x415b20 | 0x413ff0 | +0x58: 0x40c350 | Resize: new surface, copy old content |
| +0x58 | 0x415b40 | 0x414030 | +0x60 | Text extent (E) |
| +0x5c | 0x415b70 | 0x414170 | +0x64: 0x40c3f0 / 0x42a600 | Polygon: no operation in DirectDraw, `Polygon` in GDI |

Not available: alpha blending, mirroring, rotation, per-pixel access for the game (Lock is internal), palette access.

### 6.2 Other drawing-related interfaces (offsets in the wrapper vtables)

- Factory (0x42eae0): +0x0c surface from GIF name (zap:0x4178f0; flags bit 1 = clickable with Hand cursor), +0x10 blank surface (w,h,flags; bit 0 keyed) (zap:0x417860), +0x08 surface from animation, +0x14 animation from sequence, +0x18 sequence from GIF, +0x1c sequence from one image, +0x20 blank image (w,h,keyed) (zap:0x417b90), +0x28 font (E), +0x38 cursor object by index.
- ISurface (0x42eb34): +0x08 SetLoc(x,y,key) zap:0x4146a0, +0x0c GetLoc, +0x10 SetVisible(flag,key) zap:0x414720, +0x14 IsVisible, +0x18 AttachChild zap:0x414780, +0x1c DetachChild zap:0x4147f0, +0x20 BringToFront zap:0x414900, +0x24 GetParent, +0x28 HitTest zap:0x414a00, +0x30 select animation, +0x38 add animation, +0x3c GetAnim, +0x40/+0x44 GetImage, +0x48 GetSize, +0x4c Protect(key) zap:0x414ca0.
- IImageSeq (0x42ec10): +0x08 AddImage(image, ms), +0x0c RemoveImage, +0x10 GetImage(n), +0x14 image at time, +0x18 SetLoop.
- IAnim (0x42eb8c): +0x0c SetFrame(n) zap:0x417560, +0x14 restart zap:0x4176f0, others: workstream B/C.

### 6.3 What Moeboid draws (verified, gam code 0x10001000..0x10005030)

- Game image = image of ctx[2] (`gam` global 0x1000f5b8, from ctx[2]+0x44). Calls: DrawAt (+0x40) of IMG-TITLESCREEN frame 0 and IMG-BACKGROUNDSCREEN image 2 at (0,0); SetCurColor (+0x1c) with (255,153,51), (0,0,0), (51,153,255); FillRect (+0x10) for score, lives and message boxes (for example (0,0,70,40), (428,375,500,420)); ClearToColor (+0x34) (153,153,204); text through its own ZML routine gam:0x10004a00 (E).
- Sprites: child surfaces of ctx[2], attached and detached with +0x18/+0x1c (24 call sites).
- The game uses image 2 of IMG-BACKGROUNDSCREEN (gam:0x100016a0, sequence +0x10 with argument 2). This image is the composite of frames 0, 1 and 2 (disposal 1), so the port must composite, not take frame 2 alone.

## 7. Frame layout (800-wide skin, zap:0x41d6c0 from zap:0x41e07c)

Window (verified, zap:0x404790): class "ZapSpot", class style `CS_HREDRAW|CS_VREDRAW`, background brush `COLOR_WINDOW+1`; `CreateWindowExA(0, ..., style 0x92080000 = WS_POPUP|WS_VISIBLE|WS_CLIPCHILDREN|WS_SYSMENU, 800x572)`. No caption, no border: window size = client size = 800x572. Start position: centred in the work area (screen minus taskbar from `SHAppBarMessage(ABM_GETTASKBARPOS)`), or `WindowXLoc`/`WindowYLoc` from settings (zap:0x404a30). The user drags the window by the engine-drawn frame (video +0x20..+0x28).

Elements, client coordinates (all from zap:0x41d6c0 unless noted; "image" = drawn once into the root image; "surface" = child surface):

| Element | Kind | Rectangle | Check |
|---|---|---|---|
| Root background | root image cleared to #3333cc | 0,0-800,572 | verified, capture |
| Bevel corners and edges (slb-BevelEdges cells 0-7, 5x5) | image | 5 px band on all four sides | code; capture: corner (0,0) black |
| IMG-GAMEAREA (603x468, keyed) | image | 190,13-793,481 | verified, capture |
| Game surface ctx[2] (shell +0x2c8), 500x420, opaque | surface | 282,50-782,470 | verified, capture |
| Second game surface ctx[3] (+0x2cc), same rectangle, hidden at start | surface | 282,50-782,470 | code |
| Title strip (game name), 400x24 | surface | 278,20-678,44 | code |
| IMG-ZAPLOGO, keyed, clickable, text "www.ZapSpot.com" drawn into it at y 114 | surface | 10,10-185,145 | verified, capture |
| Small buttons (help, minimise, close), 26x26 | surfaces | x 705, 734, 763; y 9 | code, capture |
| Menu items "View All Games", "Personalize ZapSpot", "About ZapSpot" (zap:0x41d370) | surfaces | x 5; y 145, 180, 215 | code; text and catalogue: workstream G |
| Big round buttons (Mail This, New Game, Pause, How To Play), 46x46, slb-bigbtnbacks-hc / slb-bigbtnicons | surfaces (zap:0x41b9b0) | about x 210-256, y 87-332 | capture; exact positions computed at run time, not extracted |
| ZML text "Coming Soon..." | image | at (52,294) | code |
| ZML text "Please support our advertisers..." | image | at (280,486) | code |
| Ad banner, 470x62, opaque, clickable (zap:0x421bf0); 60 s rotation timer (60000 ms) | surface | 280,500-750,562 | verified, code and capture: 1 px black border, ad content from (281,501) to (749,561) |
| Subscribe panel (IMG-GETZAPPEDBLOCK), e-mail edit box 166x18 at (25,444) (Win32 child window zap:0x4180f0), small button at (196,439), links at (70,500) and (31,526) | surfaces (zap:0x41ed90) | lower left | code; catalogue: workstream G |

What GDI draws versus the game renderer: everything inside the 800x572 window comes from the surface tree and the DirectDraw present. GDI draws only into surfaces (text, fills, lines) and the separate splash window. Standard Windows dialogs (Terms of Service, input boxes, `MessageBoxA`) are separate windows drawn by Windows (workstream G).

### 7.1 Splash window (zap:0x403d40)

- `CreateWindowExA(WS_EX_TOOLWINDOW, ..., WS_POPUP|WS_VISIBLE, 400x240)`, centred on the full screen (`HORZRES`, `VERTRES`).
- `LoadBitmapA("img_splash")` and `BitBlt` SRCCOPY to (0,0). No palette selection.
- Four copyright lines in Arial, `lfHeight` -11, at x 90, first y 172, line step `tmHeight + tmExternalLeading`, default text colour and opaque background of the window DC (font detail: workstream E).
- The window stays while the engine initialises (zap:0x413040), then `DestroyWindow`. No `WM_PAINT` handler (`DefWindowProcA`). Duration = initialisation time (workstream C).
- The reference captures do not contain the splash (`capA/00_splash.png` is black; `capN/00_splash_*` show the desktop after the splash).

## 8. Cursors

Verified (zap:0x425a80, `assets/INDEX.md` for hotspots):

| Index | Resource | Size | Hotspot | Use |
|---|---|---|---|---|
| 0 | POINTER.CUR | 32x32, 1 bpp | (13,7) | default; set at start and when the pointer leaves a clickable item |
| 1 | HAND.CUR | 32x32, 1 bpp | (12,6) | clickable surfaces (flag bit 1), buttons (zap:0x42c230) |
| 2 | NOLINK.CUR | 32x32, 1 bpp | (16,15) | use not found |
| 3 | OPENHAND.CUR | 32x32, 1 bpp | (15,17) | window frame area (10 px border band, zap:0x41c190), end of drag |
| 4 | CLOSEDHAND.CUR | 32x32, 1 bpp | (15,17) | during window drag (zap:0x408c70) |
| 5 | HOURGLASS.CUR | 32x32, 1 bpp | (16,15) | use not found |

- Win32 hardware cursor: `LoadCursorA` + `SetCursor`; the window class has no cursor, and `WM_MOUSEMOVE` calls `SetCursor(current)` (zap:0x4040e0).
- No `ShowCursor` import: the cursor is never hidden. No game image is used as a cursor.
- The game DLL can get a cursor object (factory +0x38) but does not call it (verified: no factory +0x38 call in the game code).

## 9. Other rendering facts

- `WM_DISPLAYCHANGE`: restore surfaces; a depth change ends the program (2).
- Esc key (`WM_KEYDOWN` VK_ESCAPE): calls zap:0x41cb30 when subsystem 0x45cfc8 +0x14 returns true (inferred: pause a running game), then minimises (verified, zap:0x4040e0, video +0x38).
- Window deactivation: calls zap:0x41cb30 under the same condition as Esc, renders once, then the main loop stops calling the timer subsystem until reactivation (verified, zap:0x4040e0 case 6, zap:0x404a30).

## 10. Facts that affect the choice of target technology

- No palette animation and no 8-bit dependency: a plain RGBA canvas reproduces the 24/32-bit output exactly. No WebGL or shader is needed.
- Integer scaling only: nearest-neighbour (`image-rendering: pixelated`, `imageSmoothingEnabled = false`). The engine has no visible scaling (6.1, Draw row).
- Text is GDI bitmap-font output into surfaces (workstream E); the port needs pre-rendered glyphs or exact bitmap fonts, not canvas `fillText`.
- The whole frame, including frame graphics, menus and buttons, is software-drawn into one 800x572 buffer. Native DOM widgets are not needed except for the separate Windows dialogs and the e-mail edit box (zap:0x4180f0 creates a Win32 child window; workstream G).
- An emulation approach (original binaries in an x86 emulator with Windows or Wine) needs: DirectDraw windowed mode (`DDSCL_NORMAL`), system-memory offscreen surfaces, clipper on the primary, `Blt` with source colour key, `Lock`/`Unlock`, `GetDC`/`ReleaseDC` on surfaces with GDI `FillRect`, `LineTo`, `ExtTextOutA` and font rendering. **A palettized (8-bit) DirectDraw mode is not needed and is not the reference look**; run the emulated desktop at 24 or 32 bits. If DirectDraw is missing, the GDI fallback needs `CreateDIBSection` and `BitBlt`.

## 11. Port recipe (exact reproduction)

1. Frame buffer: 800x572, RGB (store as RGBA with alpha 255). Root image: clear to #3333cc, draw the frame graphics once (positions in 7).
2. Images: decode each GIF frame to a logical-screen-size RGBA image with the rules of 4 (alpha 0 = keyed transparent; opaque frames start black). Animation sequences with the 50 ms slot rule.
3. Surface tree: replicate `CSurface` (position relative to the parent, visible flag, ordered children, current image). Replicate the dirty-rectangle list and `CSurface::Render` exactly (5), including the skip rule. A full repaint every frame is simpler, but it differs from the engine wherever the engine leaves stale pixels; replicating the algorithm costs little.
4. Blit = copy alpha-255 pixels, clip to the target. FillRect: right/bottom exclusive. Line: GDI rules, end point excluded (for horizontal and vertical lines a simple span).
5. Present: when the frame is rendered (50 ms timer, workstream C), copy the buffer to a canvas. Scale with an integer factor and no smoothing.
6. Colours: exact RGB from the files and the code (3.7). Do not quantise to the IMG-SPLASH palette.
7. Cursor: CSS `cursor: url(...) x y` with the six cursors converted to PNG and the hotspots of 8.

## 12. Uncertain or unknown

- Desktop depth used by "typical" players in 2000-2002: unknown. Windows XP defaults to 32 bit; Windows 2000 machines often ran 16 bit (inferred, no data). The choice between the 24/32-bit look (recommended, matches the captures) and a 16-bit look is a user decision.
- 16-bit display expansion rule and GDI 16-bit colour conversion: unknown (3.4).
- 8-bit mode: palette entries 226-245, GDI colour mapping into 8-bit surfaces, and whether keyed images are transparent at all (key index 195 versus GDI fill index): unknown (3.3).
- Whether the stale-pixel cases of 5 occur during Moeboid play: unknown. A test in the reference runs: compare consecutive captures while only one sprite moves.
- Exact rectangles of the big round buttons, menu items and subscribe panel: not extracted here (workstream G owns the screen catalogue).
- Splash pixels: no capture exists (section 7.1).

## 13. Facts for other workstreams

- B (interface): wrapper vtables 0x42eae0 (factory), 0x42eb34 (surface), 0x42ebb0 (image), 0x42ec10 (sequence), 0x42eb8c (animation); method table in 6. ctx[2]/ctx[3] are the shell surfaces +0x2c8/+0x2cc at (282,50). The shell protects ctx[2] with key = shell pointer (zap:0x41d6c0 calls `Protect(0, this)`), so `SetLoc`/`SetVisible` on ctx[2] with key 0 fail with "Invalid current key" (zap:0x4146a0, zap:0x414720).
- C (timing): render timer 50 ms (zap:0x41d6c0, callback zap:0x41f1d0); animation slots of 50 ms with integer division (zap:0x4171b0); frames with delay < 50 ms never show; non-looping animations return to image 0 when finished; the main loop stops the timer subsystem while the window is inactive.
- E (fonts): text is drawn with GDI `ExtTextOutA` into DirectDraw surface DCs (zap:0x40c110: bk mode opaque or transparent, `ETO_CLIPPED`, clip 0,0,800,600). `CImage` default font: "Arial", size 0x12, from the font subsystem (zap:0x4138f0). Splash text: Arial `lfHeight` -11 (zap:0x403d40).
- G (shell): layout table in 7; Esc minimises; the ad banner surface is opaque 470x62. Its image starts black (zap:0x40b950), and the 1-pixel black border in the captures is that initial colour (inferred). With no ad drawn the area is black, which is one option for requirement 6 ("blank").
- I (reference): record the X display depth used for the captures; a splash capture is missing; a capture pair for the stale-pixel test (12) is useful.
