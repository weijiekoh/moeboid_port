# Fonts and text (workstream E)

Scope: every font that ZapSpot.exe (engine) and Moeboid.gam (game) create or use, every text drawing path, the ZML markup renderers, the characters in use, and a plan for pixel-exact text in the browser port.

Labels: **verified** = read from code or data at the given reference. **inferred** = conclusion with the reason given. **unknown** = not determined.
References: `Z:0x...` = ZapSpot.exe virtual address (image base 0x400000). `G:0x...` = Moeboid.gam virtual address (image base 0x10000000). `dZ:N` / `dG:N` = line N in `analysis/decomp/<binary>/decompiled.c`. Function names are Ghidra defaults (`FUN_<address>`).
Scripts used for checks are in the workstream scratch directory (not part of the project): `ft.py` (ctypes FreeType 2.14.3 binding), `ftcheck.py`, `vdmxcheck.py`, `v35v40.py`, `metrics.py`, `chars.py`, `fon.py`, `ttfinfo.py`.

## 1. Key findings

1. All engine and game text is **Arial**, created by one function, `Z:0x427c10`, with `lfHeight = -px` (pixel em height), `lfWeight` 0 or 700, charset 0, all precision and quality fields 0 (`DEFAULT_QUALITY`). The engine never converts points with the screen dpi. Text size does not depend on system dpi (verified, section 3).
2. The pixel sizes are 24, 18, 14, 12, 10, 8 (ZML size tags `<S0>`..`<S5>`), 18 (default font of every render context), 11 (splash), 14 (edit controls), 36 (promo text, removed in the port), plus the sizes that the game passes (12, 24). Styles: regular, bold, underline, rarely italic (removed content only).
3. Dialogs use "MS Sans Serif" 8 pt through DS_SETFONT (not DS_SHELLFONT). At 96 dpi this selects the 13 px strike of `fonts/sserife.fon`. MessageBoxA text and dialog title bars use system fonts (Tahoma on Windows 2000/XP, inferred) that the user did not supply: **decision needed** (section 12).
4. The engine has a full ZML renderer (`Z:0x416190`) with word wrap, links, shadow, centring and ellipsis. Moeboid.gam has its **own reduced ZML renderer** (`G:0x10004a00`) without word wrap: HELP.ZML, scores, messages and high-score rows use it. Both are specified in sections 6 and 7 with their quirks.
5. No static text in any binary, dialog, string table, HELP.ZML or TERMSOFSERVICE contains a byte >= 0x80 (verified, section 9). Only player-entered names can contain such bytes.
6. FreeType 2.14.3 with full hinting in monochrome mode reproduces the Microsoft rasterizer data that is stored in Arial 2.82: all 2674 advance widths of the `hdmx` table (191 cp1252 characters, 14 sizes) and the `VDMX` ascent/descent at all tested sizes, for regular and bold (verified, section 10.3). This makes pre-rendered monochrome glyph atlases from FreeType the recommended method. Glyph-bitmap identity with GDI is not proven (no Windows ground truth): section 10.6 gives a test program.
7. The `gasp` table of Arial 2.82 Regular forbids greyscale at 9..17 ppem; that of Arial Bold forbids it only at 9..10 ppem (verified table values). So regular 10, 11, 12, 14 px and bold 10 px text is monochrome on Windows in all settings. Other sizes (regular 8, 18, 24, 36; bold 8, 12, 14, 18, 24) can be antialiased, but only when "Smooth edges of screen fonts" is on and the display is deeper than 8 bpp (inferred).
8. Wine screenshots show magenta-tinted 10 px round-button captions ("Mail This", "New Game", capA/02_how_to_play.png). Inferred cause: FreeType antialiasing over the magenta colour key of the caption surface. On Windows these captions are monochrome (finding 7), so the tint is a Wine artefact. Do not copy it.

## 2. Font files

| File | Face | Version | Status |
|---|---|---|---|
| `fonts/sserife.fon` | MS Sans Serif, charset 0, cp1252 | strikes 13, 16, 20, 24, 29, 37 px | given by the user (read-only) |
| `fonts/Arial.TTF` | Arial Regular | 2.82 (name ID 5 "Version 2.82", head.fontRevision 2.82) | added, verified |
| `fonts/Arialbd.TTF` | Arial Bold | 2.82 | added, verified |

- Source of the Arial files: `arial32.exe` from the corefonts SourceForge project, 554208 bytes. Its MD5 `9637df0e91703179f0723ec095a36cb5` equals the MD5 in the SourceForge file list (verified, `sf_rss.xml`). SHA-256 values and the URL are in `fonts/SOURCES.md`. The package also holds Ariali.TTF and Arialbi.TTF (2.82, verified); they are not copied because no kept text uses italic (section 8.3).
- Licence: the Core fonts EULA allows use but restricts redistribution in modified form or as part of other products. Local use only, as stated by the user; no further action.

## 3. Font creation (task 1)

### 3.1 The font subsystem: `CSubsystem_Font_Win32`

- Global object `DAT_0045cfb4` (created by `Z:0x425ee0`, `dZ:19007`). Vtable `0x42efbc` (verified, `vtables.txt`):
  - `+0x00` `Z:0x426070` CreateFont(face, px, style): returns a cached font object if one with the same px, style and face exists (face compared by `Z:0x407360`), else creates one with `Z:0x427c10`. Cache limit 999 entries.
  - `+0x04` `Z:0x426330` ReleaseFont, `+0x08` `Z:0x426420` RemoveFont, `+0x0c` `Z:0x426300` GetPresetFont(i).
- Font object (0x30 bytes, vtable `0x42f0dc`), created by `Z:0x427c10` (`dZ:35336`):

| Offset | Content | Source |
|---|---|---|
| +0x0c | `tmAveCharWidth` | GetTextMetricsA |
| +0x10 | line height = `tmHeight + tmExternalLeading` | GetTextMetricsA |
| +0x14 | width of `" "` | GetTextExtentPoint32A(`Z:0x43405c`, 1) |
| +0x18 | width of `"."` | GetTextExtentPoint32A(`Z:0x432f70`, 1) |
| +0x1c | face (copy) | argument |
| +0x20 | px | argument |
| +0x24 | size index, always 0 (bug: the loop at `Z:0x427d2b` compares the index column of the preset table with px, so entry 0 always matches) | verified |
| +0x28 | style bits: 1 bold, 2 italic, 4 underline, 8 strikeout | argument |
| +0x2c | HFONT | CreateFontIndirectA |

  Methods: `+0x14` `Z:0x427e40` GetMetrics(&avgWidth, &lineHeight); `+0x18` `Z:0x427e60` GetDesc(face, &px, &index, &style).

- **LOGFONT of every engine font** (`Z:0x427c10`, call `CreateFontIndirectA` at `Z:0x427cd6`, verified from the listing):

| Field | Value |
|---|---|
| lfHeight | `-px` (negative: character em height in pixels) |
| lfWidth, lfEscapement, lfOrientation | 0 |
| lfWeight | 700 if style bit 0, else 0 (`FW_DONTCARE`, GDI treats as 400) |
| lfItalic / lfUnderline / lfStrikeOut | style bit 1 / bit 2 / bit 3 |
| lfCharSet | 0 (`ANSI_CHARSET`) |
| lfOutPrecision, lfClipPrecision | 0 (`OUT_DEFAULT_PRECIS`, `CLIP_DEFAULT_PRECIS`) |
| lfQuality | 0 (`DEFAULT_QUALITY`) |
| lfPitchAndFamily | 0 |
| lfFaceName | argument (always "Arial" in practice, section 3.3) |

- The function calls `GetDeviceCaps(hdc, LOGPIXELSY)` at `Z:0x427c57` and discards the result (EAX is overwritten at `Z:0x427c78` before any use). Verified: **no dpi dependence**.
- The metrics DC is `GetDC(DAT_004362f4)` (main window DC).

### 3.2 Preset table `Z:0x435cc8`

16-byte records {face pointer, px, index, style}, 6 records (verified, dump of `Z:0x435cc8..0x435d27`):

| Index (`<Sn>`) | Face | px | style |
|---|---|---|---|
| 0 | Arial | 24 | 1 (bold) |
| 1 | Arial | 18 | 1 |
| 2 | Arial | 14 | 1 |
| 3 | Arial | 12 | 1 |
| 4 | Arial | 10 | 1 |
| 5 | Arial | 8 | 1 |

- `Z:0x425f60` creates all six fonts at start-up. `GetPresetFont(i)` (used only by the ZML tag `<Hn>`) returns them.
- The ZML tag `<Sn>` reads **only the px column** (`Z:0x416612`); face and style stay as they are. So `<S3>` alone gives Arial 12 regular if the current style is regular.
- Moeboid.gam holds its own copy of the same table at `G:0x1000e9a8` (verified, same values).

### 3.3 All font requests

| Site | Face | px | Style | Purpose | In port |
|---|---|---|---|---|---|
| `Z:0x4138f0`, `Z:0x413a00` (`dZ:19463`, `dZ:19537`) | Arial | 18 | regular | default font of every render context | yes |
| `Z:0x425f60` | Arial | 24/18/14/12/10/8 | bold | presets | created, used only by `<Hn>` (no string uses it) |
| `Z:0x416190` ZML `<B> <I> <U> <S> <F> <A>` | current face | current px or table px | toggled bits | ZML text | yes |
| `Z:0x416a21` ZML link | current face | 12 (`Z:0x435cfc`) | current style | link measuring only | yes |
| `Z:0x41d370` (`dZ:28011`) | Arial | caller: 12 (`Z:0x41e5d3`, `0x41e60d`, `0x41e647`) | bold | shell menu labels (View All Games, Personalize ZapSpot, About ZapSpot) | yes |
| `Z:0x41ebe0` (`dZ:28999`) | Arial | caller: 14 (`Z:0x41f10d`), 10 (`Z:0x41f193`) | bold + underline | "Install ZapSpot" (14), "Terms of Service and Privacy Policy" (10) | G decides |
| `Z:0x42b990` (`dZ:38840`) | Arial | 12 | regular | measuring of round-button captions | yes |
| `Z:0x4224a0` (`dZ:31064`) | Arial | 36 | regular | referral promo ("Having enough fun?") | no (network/ad) |
| `Z:0x4151d0` interface CreateFont (`Z:0x417c80`) | game | game | game | Moeboid calls, below | yes |
| `G:0x10001df7` button | Arial | 12 (Yes/No), 24 (Start) | bold | Moeboid buttons | yes |
| `G:0x10003b37` | Arial | 24 | bold | Moeboid number at bottom right | yes |
| `G:0x100047fc` | Arial | 12 | bold | high-score measuring | yes |
| `G:0x10004a00` tags | current face | table px | toggled bits | Moeboid ZML-lite | yes |
| `Z:0x403fde` direct CreateFontIndirectA | Arial | 11 | weight 0 | splash copyright lines | G decides |
| `Z:0x4181f5` direct CreateFontIndirectA | Arial | 14 | weight 700 | EDIT controls (WM_SETFONT) | only if an edit box is kept |

- The two direct calls use the same LOGFONT field values as section 3.1 (all other fields 0), verified at `dZ:3424..3437` and `dZ:23917..23930`.
- `<F...>` sets the face. The only face name in any string is "Arial" (`<FArial>` in `Z:0x43606c..0x4360fc`), so no other face is ever requested (verified: strings.tsv of both binaries, string tables, HELP.ZML).

### 3.4 Stock fonts and default DC fonts

- `GetStockObject` is not imported by either binary (verified, `imports.tsv`). Moeboid.gam imports only KERNEL32.
- Every engine ExtTextOutA call selects a font first (section 4). No text is drawn with the DC default font (`SYSTEM_FONT`).

### 3.5 Dialog fonts

- All 8 dialogs have DS_SETFONT with "MS Sans Serif" 8 pt (assets/INDEX.md, verified). DS_FIXEDSYS (0x08) is not set, so the style is not DS_SHELLFONT, and the face is not "MS Shell Dlg" (verified: style 0x80C800C0 for IDD_TERMSOFSERVICE; `dialogs.json`).
- Font that USER32 creates (inferred from the documented dialog manager behaviour): `lfHeight = -MulDiv(8, LOGPIXELSY, 72)` = -11 at 96 dpi, normal weight, charset 0 (DLGTEMPLATE) or 1 (DLGTEMPLATEEX, IDD_TERMSOFSERVICE). Height -11 = em height 11 = strike with `dfPixHeight - dfInternalLeading` = 13 - 2 (section 10.1). Dialog size **does** depend on dpi (dialog units); the engine fonts do not.
- No dialog procedure changes control fonts: the only WM_SETFONT (0x30) is the PostMessageA at `Z:0x418217` for engine EDIT controls (verified: `SendMessageA` is called only at `Z:0x403d69` with message 0x7ed).
- Button texts "&OK", "&Cancel", "&No", "&Yes" have mnemonic ampersands. Windows 2000/XP hide the mnemonic underline until the user presses Alt (default of SPI_GETKEYBOARDCUES, inferred).
- **System fonts outside the application's control** (inferred, Windows defaults):
  - MessageBoxA text (`Z:0x405911` in `Z:0x4058c0`; Moeboid "Name too long" reaches it, inferred, section 8.1): NONCLIENTMETRICS message font = Tahoma 8 pt on Windows 2000 and XP.
  - Dialog and message box title bars: caption font = Tahoma bold 8 pt (Windows 2000, XP classic theme) or Trebuchet MS bold 10 pt (XP Luna theme).

### 3.6 dpi

- Engine and game text: px values go directly into `lfHeight`; no dpi scaling anywhere (verified, 3.1). At 120 dpi ("Large Fonts") the engine text keeps the same pixel size.
- Dialogs scale with dpi. At 120 dpi Windows maps "MS Sans Serif" to the 120-dpi file sseriff.fon (inferred). The port assumes 96 dpi.

## 4. Text drawing paths (task 2)

| Path | Function | Target DC | Font | Options |
|---|---|---|---|---|
| GDI render target DrawText | `Z:0x42a250` (vtable `0x42f188` +0x3c) | `CreateCompatibleDC(NULL)` with the target's DIB section selected | font object +0x2c | `ExtTextOutA(hdc, x, y, ETO_CLIPPED (4), rect, str, len, NULL)` |
| GDI render target MeasureText | `Z:0x42a330` (+0x60) | same | same | `GetTextExtentPoint32A`, then `SetTextJustification(hdc,0,0)` |
| DirectDraw render target DrawText | `Z:0x40c110` (vtable `0x42e790` +0x3c) | `IDirectDrawSurface::GetDC` (vtable +0x44), released with +0x68 | same | same ExtTextOutA call; returns early if len = 0 or `*str == 0` |
| DirectDraw render target MeasureText | `Z:0x40c2c0` (+0x60) | surface DC | same | GetTextExtentPoint32A |
| Font metrics | `Z:0x427c10`, `Z:0x427ea0` | main window DC | same | GetTextMetricsA, GetTextExtentPoint32A |
| Splash copyright | `Z:0x40405e` in `Z:0x403d40` | `GetDC(splash window)` | Arial 11 regular (direct) | `ExtTextOutA(hdc, 90, y, 0, NULL, ...)`, 4 lines |
| USER32 controls | dialogs, EDIT controls, MessageBoxA | USER32 | dialog font / Arial 14 bold / system | USER32 drawing |

Details (verified unless marked):
- **Background mode**: `SetBkMode(hdc, flag == 0 ? OPAQUE : TRANSPARENT)` where `flag` is the render context T flag (`Z:0x42a27d`, `Z:0x40c150`). Every render context starts with T = 1, transparent (`Z:0x4138f0`, `dZ:19465`). Only the ZML tag `<T>`/`</T>` changes it (`Z:0x414020` has no other caller). No string contains `</T>` (verified, grep of both strings.tsv files, the string tables and HELP.ZML), so all engine and game text is transparent.
- **Colours**: `SetTextColor(target+0x38)` and `SetBkColor(target+0x34)`, both plain RGB COLORREF (`0x00BBGGRR`), not PALETTERGB or PALETTEINDEX (`Z:0x429d50`, `Z:0x429d90`).
- **Alignment and mapping**: SetTextAlign, SetMapMode, SetTextCharacterExtra are not imported (verified), so TA_TOP|TA_LEFT, MM_TEXT, no extra spacing. ExtTextOutA gets `lpDx = NULL`, so GDI uses the font's own advances. GDI applies no pair kerning in ExtTextOutA (inferred: kerning needs explicit lpDx or GetCharacterPlacement).
- **Clipping**: ETO_CLIPPED with the rectangle that the caller passes: the ZML layout rectangle (section 6) or {0, 0, 800, 600} for the interface DrawText (`Z:0x413c30`, `dZ:19630`). The DIB section bounds also clip.
- **DIB section bit depth** (`Z:0x42a3b0`): `biBitCount = *(WORD*)(video + 0x9c47)`, the display depth. In palette mode the DIB is 8 bpp with `SetDIBColorTable` = the engine palette (`DAT_0045e924`, GetPaletteEntries). Workstream D owns the display mode and palette.
- **Text colour in 8-bpp targets** (inferred, GDI rule for DIB sections): GDI maps the RGB COLORREF to the nearest entry of the DIB colour table. All ZML colours are exact entries of the IMG-SPLASH palette (PAL20) except `#FFF000` (hyperlink hover, `Z:0x434b28`), whose nearest entry is index 251 `#FFFF00` (verified with `palettes.json`, Euclidean RGB distance). In 16/32-bpp modes the colour is exact (16 bpp: truncated to 5-6-5 or 5-5-5).
- **Shadow** (ZML `<SH>`): the text is drawn twice, first black at (+1, +1), then in the current colour (section 6).
- **Video subsystem choice** (GDI `0x42f138` factory `Z:0x428a00`, or DirectDraw `0x42e730` factory `Z:0x408a00`): workstream D. Text code is the same in both; only the DC source differs.
- **Splash** (`Z:0x403d40`): window 400 x 240, bitmap IMG-SPLASH, then 4 lines at x = 90, y = 172 + i * (tmHeight + tmExternalLeading). The DC is a fresh window DC (class style 3, no CS_OWNDC), so text colour black, background white, mode OPAQUE (Windows defaults, inferred): each line has a white cell background. Lines: "Copyright (c) 2000 ZapSpot, Inc.  All Rights Reserved.", "This program is protected by US and international copyright", "laws.  ZapSpot, the ZapSpot logo, and Life is Good are", "trademarks or registered trademarks of ZapSpot, Inc." (verified `Z:0x432564..0x4324b8`). The Wine capture of the splash is black (capA/00_splash.png), so no screenshot confirms this.
- **EDIT controls** (`Z:0x4180f0`): class "edit", style `0x50000004` (WS_CHILD|WS_VISIBLE|ES_MULTILINE), plus ES_AUTOHSCROLL with flag 2; font Arial 14 bold (one shared HFONT `DAT_0045dfc8`). No WM_CTLCOLOREDIT handling exists (no 0x133..0x138 constants), so system colours (black on white, inferred). The callers (`Z:0x41ed90`, `Z:0x420150`, `Z:0x4214b0`, `Z:0x422b90`, 7 call sites) are network forms (subscribe, mail a friend, proxy) except the generic wrapper `Z:0x418040`.
- **SystemParametersInfoA** is called only with SPI_GETKEYBOARDDELAY (0x16) and SPI_SETKEYBOARDDELAY (0x17) (`Z:0x403e3b`, `Z:0x403e42`, `Z:0x404b23`). The engine never reads or changes the font smoothing setting (verified).

## 5. Render context and text-related interface methods

Render context class (vtable `0x42eaa4`, constructors `Z:0x4138f0`, `Z:0x413a00`). Fields: +0x18 render target, +0x1c colour-key flag, +0x1d T flag (1), +0x20 line maximum (ZML), +0x24 centre flag (0), +0x25 shadow flag (0), +0x28 current font (Arial 18 regular). Text colour starts white (`Z:0x413d50(0xff,0xff,0xff)`).

**All of these fields persist between calls.** ZML tags change the font, colour, centre, shadow and T state of the render context, and the next call starts from that state. A port must keep this state per render context.

Game-facing render context interface, vtable `0x42ebb0` (object +4 = render context). Text-related slots (verified, `vtables.txt` and wrappers at `dZ:21438..21700`):

| Slot | Function | Meaning |
|---|---|---|
| +0x10 | `Z:0x4158d0` | FillRect(l, t, r, b) with the pen/brush colour (used before redrawing numbers) |
| +0x14 | `Z:0x4158f0` | DrawZML(text, x, y): `Z:0x413c90` with rect = whole target, flags 0 |
| +0x18 | `Z:0x415920` | DrawText(str, len, x, y): current font, T flag, clip {0,0,800,600} |
| +0x1c | `Z:0x415940` | SetPenColor(r, g, b) (`Z:0x429cc0`, pen and brush) |
| +0x24 | `Z:0x415980` | SetTextColor(r, g, b) |
| +0x28 | `Z:0x4159a0` | GetTextColor(&r, &g, &b) |
| +0x2c | `Z:0x4159c0` | SetBkColor(r, g, b) |
| +0x30 | `Z:0x4159e0` | GetBkColor |
| +0x34 | `Z:0x415a00` | Clear(r, g, b): fills the whole target |
| +0x48 | `Z:0x415a90` | SetFont(IFont) |
| +0x4c | `Z:0x415ab0` | GetFont(): new IFont wrapper |
| +0x50 | `Z:0x415b00` | GetSize(&w, &h) |
| +0x58 | `Z:0x415b40` | MeasureText(IFont, str, len, SIZE*) |

IFont wrapper vtable `0x42ec2c`: +0x04 Release (`Z:0x414ff0`), +0x08 GetMetrics (`Z:0x415ca0`), +0x0c GetDesc(face, &px, &index, &style) (`Z:0x415cc0`).
Platform interface vtable `0x42eae0`: +0x28 `Z:0x4151d0` CreateFont(face, px, style) returns an IFont (`Z:0x417c80`). Workstream B owns the full interface tables.

## 6. Engine ZML renderer `Z:0x416190` (task 3)

Entry: `Z:0x413c90` DrawZML(rc, text, x, y, rect, flags, parent, owner, callback) computes `len = strlen(text)`, uses rect = {0, 0, target w, target h} if rect is NULL, and calls `Z:0x416190` (thiscall on rc, 9 stack arguments, `RET 0x24`). The decompiler output for `Z:0x416190` is wrong (stack confusion); the description below comes from the disassembly (`listing.asm`, copy in the scratch file `zml_engine.asm`).

### 6.1 Tokenizer (`Z:0x4161ed..0x4163ca`)

```
tokens = []
if flags & 1:  tokens = [TEXT(text, len)]                # plain text, no tags
else:
  p = text
  while *p != 0:
    n = 0; skip = 0
    if *p != '<':
      n = strcspn(p, "<&")                              # Z:0x4349f4
      tokens += TEXT(p, n)                              # includes leading/inner/trailing spaces
    if n < len:
      c = p[n]                                          # always '<', '&' or NUL here
      if c == '%' or c == '&':
        Error("Unhandled character (%c) in ZML string"); return 0x15   # NOTHING is drawn
      if c == '<':
        p = p + 1
        m = strcspn(p + n, ">")                         # Z:0x434048
        tokens += TAG(p + n, m)                         # tag text without '<' and '>'
        skip = m + 1
    p = p + n + skip
```
- Consequence: one `&` anywhere in an engine ZML string suppresses the whole string. No kept string contains `&` (verified, section 9).
- Spaces are not collapsed. CR/LF are not converted.
- Token buffer: about 610 tokens on the stack (`0x1c88` bytes / 12), no bound check.

### 6.2 State

| State | Scope | Initial value |
|---|---|---|
| x, y | per call | arguments |
| rect (left, top, right, bottom) | per call | argument |
| lineMax (rc+0x20) | reset to 0 at each call start (`Z:0x416213`) | 0 |
| E (ellipsis), N (no wrap) | per call | false |
| inLink, linkId | per call | false, -1 |
| T (local copy of rc+0x1d) | per call, written back by `<T>` | rc+0x1d |
| font F (face, px, style), text colour, centre (rc+0x24), shadow (rc+0x25), T (rc+0x1d) | **render context, persists** | Arial 18 regular, white, off, off, 1 |

### 6.3 Tags

The first character selects the tag, case-insensitive, through the tables at `Z:0x416bf4` (index) and `Z:0x416bc0` (jumps). A leading `/` sets `closing`. Characters other than those below, and characters outside 'A'..'u', are ignored.

| Tag | Action (verified) |
|---|---|
| `A` | Not closing: linkId = up to 5 decimal digits at tag positions 1..5. Each non-digit position is skipped, but parsing continues and can read past `>` into the following text. inLink = true. Then do `U`. Closing: inLink = false, then do `U`. |
| `B` | If the 2nd character is `r`/`R` (`<BR>`, also `</BR>`): newline. Else style bit 0 (bold) on, or off if closing. |
| `C` | `<C>` (2nd character is `>`): centre = !closing. Else colour = 6 hex digits at positions 1..6 (`Z:0x416150`: 0-9, a-f, A-F, anything else = 0), also when closing. |
| `E` | E = !closing (ellipsis mode). |
| `F` | face = characters up to `>`; also when closing (`</F>` gives the empty face). New font. |
| `H` | F = GetPresetFont(digit - 1); newline twice. Closing is not checked. Not used by any string. |
| `I` | style bit 1 (italic). |
| `N` | N = !closing (no-wrap mode). |
| `P` | newline twice. |
| `S` | If 2nd character is `h`/`H`: shadow = !closing. Else `-`: index = min(index + 1, 5); `+`: index = max(index - 1, 0); digit: index = digit. px = preset table px[index]; face and style unchanged. Closing is not checked. Because the font object index is always 0 (3.1), `<S->` always gives index 1 and `<S+>` index 0. The strings use only `<S0>`..`<S4>`; `<S5>`, `<S->`, `<S+>` and `</S..>` do not occur (verified, grep of both strings.tsv files, the string tables and HELP.ZML). |
| `T` | rc T flag and local T = !closing (TRANSPARENT when true). |
| `U` | style bit 2 (underline). |

Every font change calls `CreateFont(face, px, style)` (cached).

**Newline** (`Z:0x416110`): `x = rect.left; y = y + lineMax; lineMax = F.lineHeight` (tmHeight + tmExternalLeading of the current font).

### 6.4 Text token layout (`Z:0x416786..0x416b93`)

```
(cx, cy) = Measure(F, s, n)                 # GetTextExtentPoint32A; cy = tmHeight
lineMax = max(lineMax, cy)
if x + cx <= rect.right:                    # token fits
    if inLink: make_link(); x += cx; continue
    dx = centre ? (rect.right - cx - rect.left) / 2 : x      # C integer division (toward 0); rect.left is subtracted, not added
    if shadow:
        save colour; colour = (0,0,0); Draw(F, dx + 1, y + 1, s, n); restore colour
    Draw(F, dx, y, s, n)
    x += cx                                 # from x, not from dx
elif E:                                     # ellipsis
    if x < rect.right:
        limit = rect.right - 3 * F.dotWidth
        while x + F.spaceWidth + cx > limit and n > 0:
            old = n; n -= 1; cx = Measure(F, s, old).cx        # measures the OLD length (off by one)
        Draw(F, x + F.spaceWidth, y, s, n)
        Draw(F, x + cx - F.spaceWidth, y, "...", 3)
        x += 3 * F.dotWidth
    x += cx
elif N:                                     # no wrap
    if x < rect.right: Draw(F, x + F.spaceWidth, y, s, n)
    x += cx
else:                                       # word wrap
    rem = n; str = s; last = cx
    while rem != 0:
        k = rem
        if x + cx > rect.right:
            while k > 0:
                k -= 1; cx = Measure(F, str, k).cx
                if x + cx <= rect.right: break
            if k != rem and str[k] != ' ':
                j = k
                while j > 0:
                    j -= 1
                    if str[j] == ' ': (if j > 0: k = j); break
                # no space found: k stays at the character-fit length (mid-word break)
        Draw(F, x, y, str, k)               # no centring, no shadow in this path
        if k < rem: newline()
        str += k; rem -= k
        if str[0] == ' ': str += 1; rem -= 1  # skips exactly one space; reads 1 byte past the token
        last = cx
        cx = Measure(F, str, rem).cx
    x += last
```
- `Draw` = render target DrawText with clip = rect and the local T flag. All text is top-aligned at y (TA_TOP); tokens of different sizes on one line share the top edge.
- `make_link` (`Z:0x4169bb..0x416ada`): F12 = CreateFont(face, 12, style); (lw, lh) = Measure(F12, s, n); lx = centre ? (rect.right - cx - rect.left) / 2 : x; create `CHyperLink` (`Z:0x4184e0`) at (lx, y), size (lw + F12.spaceWidth, lh + 2), with the token text and linkId, as a child of the parent object (arguments p7..p9); restore F. Nothing is drawn by the renderer itself.
- The globals `0x45dfc0`/`0x45dfc4` receive the end point of the last drawn text (not used by kept text, inferred).

**Quirks a reimplementation must keep** (all derived from the code above):
1. Text inside `<A>` that does not fit on the current line goes through the wrap path: it is drawn as plain text and **no link is created**.
2. The wrap path draws without shadow and without centring. Example: string 10003 "`<s4><cffffff><sh>Coming Soon...  ZapSpot news and messages.</sh>`" wraps, so it has no shadow (consistent with capA/02_how_to_play.png).
3. Mid-word breaks happen when a run has no space before the fit point, for example a run that starts after a tag near the right edge.
4. If only a trailing space overflows, the line breaks, the space is skipped, and the next token starts at `rect.left + width(last piece)` instead of `rect.left`.
5. With two spaces at a break, one space can stay at the start of the next line.
6. Each centred token is centred on its own; several tokens on one centred line overlap.
7. The first line advance is max(token cy) = tmHeight; later lines use tmHeight + tmExternalLeading (newline sets lineMax to the line height).
8. N and E modes draw at `x + spaceWidth`. No kept string uses `<N>` or `<E>` (verified, tag lists).

### 6.5 CHyperLink (`Z:0x4184e0`)

- Two ZML strings built at construction: normal = `<T><S3><U><SH><C><CFFFFFF>` + text + `</C></SH></U>` (`Z:0x434afc`, `Z:0x434aec`); hover = `<T><S3><U><C><Sh><CFFF000>` + text + `</C></sh></U>` (`Z:0x434b28`, `Z:0x434b18`).
- Drawn by `Z:0x4187a0` (hover, event 8) and `Z:0x4187f0` (normal, event 9) with DrawZML into the link's own surface; the constructor draws hover, then normal. Click (event 10) calls `Z:0x418780` with linkId.
- The link surface has a new render context (default Arial 18 regular), so link text is **Arial 12 regular underlined** with shadow, centred in a surface of width lw + spaceWidth, even inside bold text.
- Whether the surface is cleared between the two state drawings is unknown (not traced; workstream G/D).

### 6.6 Where the engine uses ZML (kept shell content)

| Text | String | Font result | Colour |
|---|---|---|---|
| Menu labels (View All Games, Personalize ZapSpot, About ZapSpot) | `Z:0x41d370`, ids 10000..10002 | Arial 12 bold, centred in 180 px halves, bottom at y 27 | white; hover #FFCC00; background fill #3333CC |
| Round-button captions (Mail This, New Game, Pause, Resume, How To Play, High Scores) | `Z:0x42b990`, `<T><S4><FArial><sh><CFFFFFF><C><U>%s</U></c>` | Arial 10 regular underline, shadow, centred | white; hover #FFFF33 |
| Game list labels (View All Games screen) | `Z:0x42b990`, `<T><S2><b><FArial><sh>...<c>%s</c></b>` | Arial 14 bold, shadow, centred | white; hover #FFFF33 |
| Tab title ("How To Play", game name) | `Z:0x41b7f0`, prefix `<S1></b><t></u></i>` (`<S2><b><t></u></i>` if screen width < 800) | Arial 18 regular (14 bold) | black on #FFCC00; game name followed by IMG-TM.GIF |
| Help, About, Personalize pages | string ids 101..118, 1001..1004, 1101.. | `<S1>`/`<S2><B>`/`<S3>` mix: 18, 14 bold, 12; links 12 regular underline | white (#FFFFFF), #00FFFF for On/Off |
| Status line | ids 10016, 10017 | 18 or 12, centred | white |
| "Install ZapSpot", "Terms of Service and Privacy Policy" | `Z:0x41ebe0` with `<B>` prefix | Arial 14 / 10 bold underline | white; hover #FFCC00 |
| "Subscribe To ZapSpot", news text, e-mail prompts, advertiser caption | ids 10003..10005, 10009, 10018, 10019 | 18 bold shadow / 10 | white |

Positions and which items stay are workstream G (shell) decisions.

## 7. Moeboid ZML-lite renderer `G:0x10004a00`

A cdecl function `(rc, text, x, y)` in Moeboid.gam. It draws through the interface (DrawText +0x18, MeasureText +0x58, SetFont +0x48, GetFont +0x4c, SetTextColor +0x24, GetSize +0x50, platform CreateFont +0x28). Verified from the disassembly (`listing.asm` of Moeboid.gam, `G:0x10004a00..0x10004e13`); the decompiler output is wrong.

- Tokenizer: the same as 6.1 (delimiters "<&" at `G:0x1000ea14`, ">" at `G:0x1000ea10`) but **without the `&` error**. An `&` makes the loop stop advancing (endless loop, inferred from `G:0x10004a56..0x10004b13`). No Moeboid text contains `&`.
- Start: F = rc.GetFont(); (w, h) = rc.GetSize(); centre = false. It measures "Test" (`G:0x1000ea08`) and does not use the result.
- Text token: (cx, cy) = Measure(F, s, n); dx = centre ? (w - cx) / 2 : **x + 4**; DrawText(s, n, dx, y); x += cx. No wrap, no shadow, no links, no lineMax.
- Tags (index table `G:0x10004e30`, jumps `G:0x10004e14`; case-insensitive):
  - `B`: `<BR>`: x = 0, y += 15. Else bold bit.
  - `C`: `<C>`: centre = !closing (local). Else colour (6 hex digits) through rc.SetTextColor.
  - `I`: italic bit. `U`: underline bit.
  - `P`: x = 0, y += 30.
  - `S`: `-`/`+`/digit as in the engine, px from `G:0x1000e9ac`.
  - Font change: F.GetDesc, F.Release, F = CreateFont(face, px, style), rc.SetFont(F). The font therefore persists in the render context.
  - No `A`, `E`, `F`, `H`, `N`, `T`, `SH`.
- Line breaks reset x to 0, not to the start x.

## 8. Text that the game draws (task 4)

All game text is Arial through the renderer of section 7 or the engine button helper. No bitmap digit GIFs exist for scores (the 46 GIFs hold sprites, backgrounds and the title, verified in assets/INDEX.md). Text is transparent (T = 1).

### 8.1 Items

| Item | Code | String | Font | Colour | Position (x is before the +4 inset) |
|---|---|---|---|---|---|
| Help page | `G:0x10001c90` | HELP.ZML between the first two `"` (`G:0x10004fb0`), CR and LF replaced by spaces | 12 bold title, 12 regular body (`<S3>`), last line 14 bold (`<S2><B>`) | #FFFFFF, #FF3333 | (0, 10), line step 15 (`<BR>`) |
| Trademark line | `G:0x10001d86` | `<C999999><s4>Moeboid is a trademark of ZapSpot, Inc.` | 10, style left from the help text (regular) | #999999 | (303, 0) |
| Number at top (`[obj+0x1a4]`) | `G:0x10003a60` | `<s0><ccc3399><b>%d</b>` | 24 bold | #CC3399 | (53, 4); area (57,7)-(78,32) filled #FF9933 first |
| Number at bottom right (`[obj+8]`) | `G:0x10003ad0` | `%d` | CreateFont("Arial", 24, bold) | #CC3399 | x = 457 - cx/2, y = 390; area (425,390)-(500,420) filled #FF9933 first |
| Life lost box | `G:0x10003d80` | 4 lines `<s3><c333399><b>...` (`G:0x1000e720`, `e6f0`, `e6c0`, `e694` with %d), then "life left..." or "lives left...", then `<C000000>Press the space bar to continue...` | 12 bold (bold stays on: no `</b>`) | #333399, last line #000000 | box at (155,160)-(360,320); lines at (11, 21/36/51/81/96), last (5, 126) |
| Game over box | `G:0x10003e70` | 3 lines `<s3><c333399><b>...`, `<s3><c333399><b><c>Play Again?</c>` | 12 bold | #333399 | box (155,160)-(355,290); lines (11, 21/36/51), "Play Again?" centred at y 81 |
| Yes/No buttons | `G:0x10001de0` | "Yes (Y)", "No (N)" with `<B><U>` | 12 bold underline | black; hover white | (27,107), (127,107) in the box |
| Start button | `G:0x1000428e` | "Start" | 24 bold underline | black; hover white | (250, 190) |
| High-score title | `G:0x100042a9` | `<C000000><S1><b><u>Top Moeboids</u></b>` | 18 bold underline | #000000 | (50, 187) |
| High-score rows | `G:0x10004640` | leader `<s3><c000000><b>. . . . . . . . . . . . . . . . .</b>`, name `<s3><b><c000000>%s</b>`, score `<s3><b><c000000>%d</b>`, `%d,%03d`, `%d,%03d,%03d` (thousands groups for > 999 and > 999999) | 12 bold | #000000 | 5 rows, y = 212 + 17 * i. First all leaders at (50, y). Per row: measure the name in Arial 12 bold, FillRect (50, y)-(cx + 58, y + 17) with #3399FF (erases the dots under the name), name at (50, y), score at (155, y) (`G:0x1000473e..0x10004966`) |
| Credits | `G:0x100026c0` | `<S2><c><b><c000000><u>The ZapSpot Team...`, `<S3><c><b><c000000>%s</b></c>` with 23 names | 14 bold underline, 12 bold, centred | #000000 | workstream B/C |

- Button helper `G:0x10001de0`: image width 2 * (cx + 4), height cy (cy of the bold 12/24 px font), background #99CCFF (#66CCFF for id -1, #FF9933 when `G:0x1000f605` is set); normal label black at x 4 (0 + inset), hover label white at x cx + 8; then the platform creates the button (+0x30).
- The engine button helpers `Z:0x41d370` and `Z:0x41ebe0` follow the same two-state pattern (section 6.6).
- Name entry: Moeboid calls the dialog interface `DAT_1000f5c8` +0x18 (`G:0x100038c3`) with title "Congratulations", the prompt `G:0x1000e5ac`, buffer size 0x10 and flags 1, and +0x14 (`G:0x100038ef`) with "Name too long" and flags 0x101. Inferred (argument pattern; workstream B maps the slots): the first is the engine InputBox `Z:0x405480`, which shows IDD_INPUT_BOX2 for flags without bit 2 (MS Sans Serif); the second is `Z:0x4058c0`, MessageBoxA with MB_OK | MB_ICONEXCLAMATION (bit 0x100 gives 0x30).

### 8.2 Persistent state matters

Moeboid relies on state carried between calls on one render context. Examples: "life left..." has no tags and inherits 12 bold #333399 from the previous line; the trademark line inherits the regular style from the end of HELP.ZML.

### 8.3 Styles in use

Regular, bold, underline (bold + underline, regular + underline). Italic appears only in `Z:0x4359cc` (referral promo, `Z:0x4224a0`, removed) and as closing `</i>` in `Z:0x434e1c`/`0x434e30`. Strikeout: never. So Ariali.TTF and Arialbi.TTF are not needed.

## 9. Characters (task 5)

Method: `chars.py` scans the dialog captions and item texts (`dialogs.json`), both string tables (`strings.json`), HELP.ZML, TERMSOFSERVICE (raw bytes), and every C string in Ghidra `strings.tsv` of both binaries (raw bytes from the PE).

- Bytes >= 0x80: **none** in any source (verified). The splash uses "(c)", not 0xA9. The "TM" after the game name is the image IMG-TM.GIF (`Z:0x41b7f0`), not a glyph.
- Control bytes: CR/LF in HELP.ZML (replaced by spaces) and TERMSOFSERVICE (EDIT control lines); NUL terminator.
- `&`: only the dialog mnemonics (&OK, &Cancel, &No, &Yes) and the bfast.com URLs (not drawn). No ZML string contains `&` (verified).
- `%`: only in format strings (`%d`, `%s`, `%03d`), expanded before drawing.
- Dynamic text: numbers (digits and ","), player names (max 12 characters, typed in a MS Sans Serif EDIT control, stored in the registry, then drawn in Arial 12 bold). Names can contain any cp1252 character the user types. The help page 118 can show install paths (removed content, inferred).
- Required repertoire: ASCII 0x20..0x7E for static text; cp1252 0x20..0xFF for names. Default glyph for undefined codes: MS Sans Serif `dfDefaultChar` = 0x81 (32 + 97); Arial maps through cp1252 to Unicode; undefined cp1252 codes (0x81, 0x8D, 0x8F, 0x90, 0x9D) give the .notdef box (inferred).

## 10. Rendering plan (task 6)

### 10.1 MS Sans Serif (`fonts/sserife.fon`)

Strikes (verified with `fon.py`; all weight 400, charset 0, first 0x20, last 0xFF, default char 0x81, break char 0x20, pitch/family 0x21, 96 dpi):

| dfPixHeight | dfPoints | ascent | internal leading | em height | avg width | max width |
|---|---|---|---|---|---|---|
| 13 | 8 | 11 | 2 | 11 | 5 | 11 |
| 16 | 10 | 13 | 3 | 13 | 7 | 14 |
| 20 | 12 | 16 | 4 | 16 | 8 | 16 |
| 24 | 14 | 19 | 6 | 18 | 9 | 19 |
| 29 | 18 | 23 | 5 | 24 | 12 | 24 |
| 37 | 24 | 29 | 5 | 32 | 16 | 32 |

- Strike choice: dialogs request -11 at 96 dpi; the 13 px strike has em height 11, an exact match (inferred from the GDI mapper rule for negative heights: compare `dfPixHeight - dfInternalLeading`). Only this strike is used.
- Rendering is exact by construction: copy the 1-bpp glyph columns of the 13 px strike, advance by the glyph width, cell height 13, baseline at 11. No synthesis is needed: no request asks for bold, italic, underline or strikeout of MS Sans Serif (verified, 3.5). If a future need appears: GDI synthesizes bold for raster fonts by drawing the glyph twice with a 1 px x offset and adding 1 to the advance, and italic by shearing rows (inferred).
- Dialog base units 6 x 13 (assets/INDEX.md) come from this strike.
- What GDI/USER32 add and the port must reproduce: control layout, EDIT word wrap and margins, button frames, focus rectangles, the scroll bar of the TOS EDIT control. EDIT control margins for raster fonts are unknown (needs ground truth); workstream G owns the dialog layout.

### 10.2 Arial in GDI (Windows 2000/XP behaviour)

- Rasterizer: the Microsoft TrueType rasterizer runs the font's bytecode (full hinting) at ppem = px. Advances come from `hdmx` when the ppem is listed there (11, 12, 13, 15, 16, 17, 19, 21, 24, 27, 29, 32, 33, 37, ...), otherwise from the hinted advance (inferred; the FreeType check in 10.3 shows the two agree).
- Ascent and descent: from `VDMX` for the ppem (inferred: GDI uses VDMX when present; consistent with the known tmHeight 15 of Arial -12).
- External leading: hhea lineGap 67 scaled by ppem/2048 and rounded (inferred; rounding rule unknown, values below assume round half up).
- Mono or greyscale: `lfQuality = DEFAULT_QUALITY` means the system setting decides. With "Smooth edges of screen fonts" (standard smoothing) on, GDI still follows the `gasp` table of Arial 2.82: ppem <= 8 greyscale without grid-fit, 9..17 grid-fit only (**monochrome**), >= 18 grid-fit and greyscale (verified table values: regular `[(8,2),(17,1),(65535,3)]`, bold `[(8,2),(10,1),(65535,3)]` — bold allows greyscale from 11 ppem). GDI does not antialias on 8-bpp palette surfaces (inferred: Windows font smoothing needs a high-colour or true-colour display). DirectDraw surface DCs behave like the display depth (inferred).
  - Bold correction: Arialbd.TTF gasp switches to greyscale-capable at ppem > 10, so with smoothing on, **bold 12 and 14 px** may be greyscale. Verified gasp values; GDI behaviour inferred.
- Default smoothing setting: Windows 2000 default off and Windows XP default "Standard" on are commonly reported (unknown, not verified here). The reference machine's setting decides. Decision for the user (section 12).
- Underline: GDI draws a rectangle under the text from the post table (position -217, thickness 150 regular / 215 bold, scaled and rounded; inferred). Table below. Exact rounding needs ground truth.
- Kerning: none (ExtTextOutA without lpDx). Arial has a `kern` table, the port must ignore it.

### 10.3 FreeType versus the Microsoft data (verified tests)

Tests with FreeType 2.14.3 (`/usr/lib/libfreetype.so.6`) through ctypes, load flags `FT_LOAD_TARGET_MONO | FT_LOAD_MONOCHROME`, full hinting:

1. Advances: hdmx table renamed so FreeType cannot use it; hinted advances compared with the hdmx device widths for 191 cp1252 characters at all 14 hdmx ppems up to 37: **0 mismatches of 2674**, Arial regular, interpreter v35 and v40 (`ftcheck.py`).
2. Vertical extents: max top and min bottom of the rendered cp1252 glyphs compared with VDMX yMax/yMin at ppem 8, 10, 11, 12, 13, 14, 16, 18, 24, 36: **all equal**, regular and bold (`vdmxcheck.py`). (Over all glyphs in the font the extents are larger, so VDMX was made from the ANSI character set.)
3. Interpreter v35 and v40 give identical monochrome bitmaps for all 219 cp1252 glyphs at 8, 10, 11, 12, 14, 18, 24, 36 px, regular and bold (`v35v40.py`). In monochrome mode FreeType v40 disables its subpixel ("lean") hinting.

Conclusion (inferred): FreeType mono hinting executes the Arial bytecode the same way as the Microsoft rasterizer in all measurable horizontal and vertical metrics. Remaining risk: single pixels from dropout control and rounding inside the outline, which these tests cannot see. Greyscale output of GDI (Windows 2000/XP "Standard" smoothing) cannot be reproduced with FreeType's antialiasing; it needs captured bitmaps.

Do not use Pillow's `getlength` for advances: it returns unhinted linear advances (checked: fractional values).

### 10.4 Arial metrics for the port (ppem = px)

From VDMX (ascent/descent), FreeType hinted advances (equal to hdmx where hdmx has the ppem), hhea lineGap (rounded half up, inferred), post underline (inferred rounding):

| Face | px | ascent | descent | tmHeight | ext. leading | line height | space | "." | "0" | underline offset below baseline | underline thickness |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Regular | 8 | 8 | 2 | 10 | 0 | 10 | 2 | 2 | 4 | 1 | 1 |
| Regular | 10 | 10 | 3 | 13 | 0 | 13 | 3 | 3 | 6 | 1 | 1 |
| Regular | 11 | 11 | 3 | 14 | 0 | 14 | 3 | 3 | 6 | 1 | 1 |
| Regular | 12 | 12 | 3 | 15 | 0 | 15 | 3 | 3 | 7 | 1 | 1 |
| Regular | 14 | 13 | 3 | 16 | 0 | 16 | 4 | 4 | 8 | 1 | 1 |
| Regular | 18 | 17 | 4 | 21 | 1 | 22 | 5 | 5 | 10 | 2 | 1 |
| Regular | 24 | 21 | 6 | 27 | 1 | 28 | 7 | 7 | 13 | 3 | 2 |
| Regular | 36 | 33 | 8 | 41 | 1 | 42 | 10 | 10 | 20 | 4 | 3 |
| Bold | 8 | 8 | 2 | 10 | 0 | 10 | 2 | 2 | 4 | 1 | 1 |
| Bold | 10 | 10 | 2 | 12 | 0 | 12 | 3 | 3 | 6 | 1 | 1 |
| Bold | 11 | 11 | 3 | 14 | 0 | 14 | 3 | 3 | 6 | 1 | 1 |
| Bold | 12 | 12 | 3 | 15 | 0 | 15 | 3 | 3 | 7 | 1 | 1 |
| Bold | 14 | 13 | 3 | 16 | 0 | 16 | 4 | 4 | 8 | 1 | 1 |
| Bold | 18 | 17 | 4 | 21 | 1 | 22 | 5 | 5 | 10 | 2 | 2 |
| Bold | 24 | 23 | 6 | 29 | 1 | 30 | 7 | 7 | 13 | 3 | 3 |
| Bold | 36 | 34 | 9 | 43 | 1 | 44 | 10 | 10 | 20 | 4 | 4 |

ZML line advance = tmHeight for the first line, tmHeight + external leading after a newline (6.4 quirk 7). Moeboid ZML-lite uses a fixed 15 px.

### 10.5 Method for pixel-exact output

1. Build offline, once, glyph atlases for each (face, px, weight) in section 11: for every cp1252 code 0x20..0xFF, the monochrome bitmap, its left offset and top offset relative to the pen and baseline, and the advance. Tool: FreeType mono, full hinting (as in 10.3), Arial 2.82 files from `fonts/`. Store as PNG plus JSON. MS Sans Serif: convert the 13 px strike directly from `sserife.fon` (exact).
2. At run time, draw text the GDI way: pen starts at (x, y + ascent); for each byte, blit the glyph mask in the text colour (no blending), then pen x += advance. No kerning. Clip to the given rectangle. TRANSPARENT mode only draws glyph pixels; OPAQUE also fills the cell (advance x tmHeight) with the background colour first.
3. Underline: fill a rectangle of the computed thickness across the full advance width of the string, at baseline + offset (10.4). Replace the inferred values with ground truth when available.
4. Measure text with the same advance tables (GetTextExtentPoint32A = sum of advances, cy = tmHeight). Layout code (ZML) must use these numbers, not browser text metrics.
5. Do not use the browser's text rendering or CSS fonts: browsers antialias and position at subpixels.
6. Colour: draw with the exact RGB from the ZML tag. If workstream D decides on an 8-bit palette emulation, map #FFF000 to #FFFF00 (section 4).
7. Optional greyscale mode for 8, 18, 24, 36 px (and bold >= 11 px) only if the user's reference machine used font smoothing; then the atlases must come from Windows captures (10.6).

### 10.6 Ground truth on a real Windows 2000/XP machine or VM

No Windows is available here, and Wine uses FreeType with antialiasing (not GDI). To get ground truth the user can build and run a small Win32 program (C, any compiler for Win32; no installation needed on the target) that does exactly what the engine does:

1. For each request (face "Arial", px in {8, 10, 11, 12, 14, 18, 24, 36}, weight 0 and 700, underline 0 and 1) create the font with the LOGFONT of section 3.1. Also create "MS Sans Serif" with lfHeight -11.
2. Write `GetTextMetricsA`, `GetOutlineTextMetricsA` (underline position and size), and `GetCharWidth32A`/`GetCharABCWidthsA` for 0x20..0xFF to a text file.
3. Create a 32-bpp top-down DIB section (`CreateDIBSection`), fill it white, `SetBkMode(TRANSPARENT)`, `SetTextColor(0)`, and draw every character 0x20..0xFF with `ExtTextOutA(hdc, x, y, ETO_CLIPPED, &rc, &ch, 1, NULL)` in a grid with known pen positions. Also draw full test strings (ZML samples, digits "0123456789,", underlined text) with one ExtTextOutA call each.
4. Repeat with an 8-bpp DIB section that has the engine palette, and with "Smooth edges of screen fonts" off and on (SPI_SETFONTSMOOTHING), to confirm 10.2.
5. Save the DIBs as BMP files. Record `SPI_GETFONTSMOOTHING`, `SPI_GETFONTSMOOTHINGTYPE` (XP), the display depth, and NONCLIENTMETRICS (caption and message fonts).
6. Optionally take screenshots of the TOS dialog, the input box and a MessageBox with `PrintWindow` or a screen BitBlt, for the USER32 parts.

`GetGlyphOutline(GGO_BITMAP)` is a weaker alternative: it uses the same rasterizer, but the ExtTextOutA output is what the engine shows, including underline and pen rounding. Compare the BMPs with the FreeType atlases pixel by pixel; replace any differing glyphs by the captured ones.

## 11. Font requirements for the port (task 7)

| Face | File | Pixel sizes | Styles | Characters | Rendering | Status |
|---|---|---|---|---|---|---|
| Arial | `fonts/Arial.TTF` (2.82) | 10, 12, 18 (kept text); 11 (splash, if kept); 14, 24 (only if a kept string combines them with regular: none known); 8, 36 not needed | regular, regular + underline | 0x20..0x7E static; 0x20..0xFF for names | monochrome hinted atlases (10.5); greyscale only for 18 px if the user's reference used smoothing | have file |
| Arial Bold | `fonts/Arialbd.TTF` (2.82) | 10, 12, 14, 18, 24 | bold, bold + underline | 0x20..0x7E; 0x20..0xFF for names at 12 px | monochrome hinted atlases; greyscale question for 12..24 px (gasp, 10.2) | have file |
| Arial Bold | same | 8, 36 | bold | none in kept text (presets only) | not needed | have file |
| Arial Italic, Bold Italic | not copied | none | italic | none in kept text | not needed | in `tools/dl/fonts/corefonts-arial32/x/` (verified 2.82) |
| MS Sans Serif | `fonts/sserife.fon` | 13 px strike (8 pt at 96 dpi) | regular | 0x20..0x7E in dialogs and TOS; names typed in the input box: 0x20..0xFF | exact bitmap copy | have file |
| Tahoma 8 pt (MessageBox text), Tahoma bold 8 pt or Trebuchet MS bold 10 pt (title bars) | none | system | system | captions, "Name too long" message | depends on decision 12.1 | missing (not supplied; user decision) |

## 12. Decisions for the user

1. **System fonts** for MessageBox text and dialog title bars are not MS Sans Serif or Arial on Windows 2000/XP (inferred: Tahoma; Trebuchet MS for XP Luna title bars). Options: (a) supply Tahoma (and Trebuchet MS) files from the target Windows version; (b) use MS Sans Serif 13 px for these texts (the Windows 98/NT 4 look); (c) draw the "Name too long" message in the game area instead of a MessageBox. Which Windows look (2000, XP classic, XP Luna) is the reference?
2. **Font smoothing**: was "Smooth edges of screen fonts" on in the reference? If yes, 18 px regular and 12..24 px bold text was greyscale in 16/32-bpp modes, and exact output needs Windows captures (10.6). Recommended default: off (monochrome), which is exact for all sizes where the tests apply.
3. **Ground truth**: can the user run the test program of 10.6 on Windows 2000 or XP (VM is fine)? Without it, Arial glyph bitmaps are "FreeType v35 mono", verified only by metrics.
4. Which shell texts stay (splash copyright, news text, advertiser caption, subscribe box, "Install ZapSpot"): workstream G.

## 13. Open questions

- Exact underline position/thickness rounding and tmExternalLeading rounding in GDI (inferred values in 10.4).
- EDIT control margins and wrap for the TOS text with a raster font.
- Whether the CHyperLink surface is cleared before a state redraw (6.5).
- Video subsystem in use (GDI DIB or DirectDraw) and display depth: workstream D. Text code is identical in both.
- The splash text background (white OPAQUE cells) is predicted from defaults, not seen in a capture (capA/00_splash.png is black).

## 14. Facts for other workstreams

- B (interface): text slots of vtable `0x42ebb0` and `0x42eae0` +0x28 (section 5); IFont vtable `0x42ec2c`; dialog interface: InputBox `Z:0x405480`, MessageBox `Z:0x4058c0`.
- D (rendering): text uses ExtTextOutA into the render target's DIB section or DirectDraw surface DC; RGB colours map to the nearest palette entry in 8-bpp mode; only #FFF000 is not in PAL20. Colour-key surfaces (magenta #FF00FF background, `Z:0x4299e0`) receive text with TRANSPARENT mode; monochrome text keeps the key colour clean.
- G (shell): kept shell texts and their fonts (6.6); render context state persists between calls; ZML wrap quirks (6.4); links are 12 px regular underlined with shadow.
- J (verification): compare text against FreeType mono atlases, not against Wine screenshots (Wine antialiases); test cases: help page wrap, link creation at line end, Moeboid help (15 px steps, x + 4 inset).
