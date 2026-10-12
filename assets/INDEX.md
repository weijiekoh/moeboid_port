# Moeboid resource assets

The script `tools/extract_resources.py` writes this file. Do not edit it by hand. To rebuild all outputs, run from the project root:

    source tools/env.sh
    python -I assets/tools/extract_resources.py

Paths are relative to `assets/`. `index.json` holds the same data in machine-readable form. `palettes.json` holds every colour table.

Labels: **verified** = read from the bytes at the given file or offset. **inferred** = conclusion, not proven by the bytes alone.

## Totals and verification

| Binary | File SHA-256 | Resources | Counts per type | Raw files | Own walker | pefile | Hash mismatches |
|---|---|---|---|---|---|---|---|
| Moeboid.gam | `c7d13dc930c73c7939eb4562f6e9cb803e6cd33312d901c4a636835d93e7090b` | 60 | STRING 2, RCDATA 58 | 60 | 60 | 60 | 0 |
| ZapSpot.exe | `9181bb0e68510931c47a9078895e732b27cfd062287261c3dd1a5c1eece05ca8` | 82 | CURSOR 6, BITMAP 1, ICON 2, DIALOG 8, STRING 18, RCDATA 40, GROUP_CURSOR 6, GROUP_ICON 1 | 82 | 82 | 82 | 0 |
| moeboid.exe | `82b6e4c16404dae85cd045c26b10a977f47f7acc78cc11bbe65b33e617bfdeee` | 3 | ICON 2, GROUP_ICON 1 | 3 | 3 | 3 | 0 |

- Total: 145 resources. Every resource has one raw file and one index row (verified: count check).
- The script re-reads each raw file and compares its SHA-256 with the bytes at the recorded file offset in the binary (verified: 0 mismatches).
- The script walks the resource tree itself and compares the (offset, size) list with pefile (verified: equal).
- Resource types present: BITMAP, CURSOR, DIALOG, GROUP_CURSOR, GROUP_ICON, ICON, RCDATA, STRING. Types absent in all three binaries: VERSION, MENU, ACCELERATOR, FONT, FONTDIR, MANIFEST, MESSAGETABLE, HTML (verified).
- All resources use language 0x0409 and code page field 0 (verified).
- No resource has the same bytes as another resource.

## Layout

- `<binary>/raw/<TYPE>/<name>_<lang>.<ext>`: resource bytes as stored in the binary. The file name drops a `.GIF`, `.WAV` or `.ZML` suffix of the resource name. `index.json` keeps the exact name.
- `<binary>/raw/_NONRESOURCE/`: data outside the resource tree (signature, debug record). These files are not resources and are not in the resource counts.
- `<binary>/decoded/strings.txt`, `strings.json`: string tables. The JSON lists all 16 slots of each block.
- `<binary>/decoded/DIALOG/*.rc`, `dialogs.json`: dialog templates in RC syntax, with decoded styles and pixel rectangles.
- `<binary>/decoded/gifs.json`: GIF metadata. `decoded/GIF/<stem>/frame_NNN.png`: Pillow composite of frame NNN (RGBA, full logical screen). `frame_NNN_indexed.png`: frame rectangle only, decoded by the script's own LZW decoder, exact colour table, tRNS for the transparent index.
- `<binary>/decoded/wavs.json`: WAV chunk list and format.
- `<binary>/decoded/BITMAP/`: `.bmp` (BITMAPFILEHEADER added), `.png`, `.json` (header, palette).
- `<binary>/decoded/CURSOR/`, `ICON/`: rebuilt `.cur`/`.ico`, one `.png` per image, `.json` with hotspots. PNG previews show AND-mask pixels with a black XOR value as transparent and screen-invert pixels as magenta.
- `<binary>/decoded/RCDATA/*.utf8.txt`: text resources converted from cp1252 to UTF-8.
- `Moeboid.gam/decoded/zml_tags.txt`: markup tags in HELP.ZML. `ZapSpot.exe/decoded/zml_tags.txt`: markup tags in the ZapSpot string tables.

## Palette summary

| Group | Colour tables | Distinct ordered palettes | Distinct colour sets | Table colour union | Used colour union | Used, not web-safe | Used, not in IMG-SPLASH palette |
|---|---|---|---|---|---|---|---|
| Moeboid.gam GIF | 46 | 19 | 18 | 102 | 98 | 0 | 2 |
| ZapSpot.exe bitmap | 1 | 1 | 1 | 256 | 69 | 29 | 0 |
| ZapSpot.exe banner 468x60 | 8 | 8 | 8 | 319 | 295 | 240 | 238 |
| ZapSpot.exe GIF | 27 | 27 | 27 | 1310 | 950 | 843 | 834 |

Findings (verified from the colour tables and the decoded pixel indices):

- No GIF has a local colour table (0 local tables in 81 GIFs). Each GIF uses its global table only.
- Moeboid.gam: the 46 GIFs do **not** share one palette. They have 19 distinct ordered palettes (18 distinct colour sets). LEFT/RIGHT sprite pairs of one size share a table; PAL14 is shared by 17 files.
- Moeboid.gam: the pixels use 98 distinct colours in total. 0 of them are outside the 216-colour web-safe cube (levels 00, 33, 66, 99, cc, ff). 2 of them are outside the IMG-SPLASH palette.
- IMG-SPLASH (ZapSpot.exe BITMAP) has a 256-entry palette (PAL20, 256 distinct colours). Entries 0-9 and 246-255 hold the 20 Windows static colours in system-palette order. It holds 212 of the 216 web-safe colours (missing: #0033ff, #00ff33, #3300ff, #33ff00). Other entries: 10=#040404, 11=#080808, 12=#0c0c0c, 13=#111111, 14=#161616, 15=#1c1c1c, 16=#222222, 17=#292929, 18=#555555, 19=#4d4d4d, 20=#424242, 21=#393939, 22=#ff7c80, 23=#ff5050, 24=#d60093, 25=#ccecff, 26=#efd6c6, 27=#e7e7d6, 28=#ada990, 233=#a50021, 234=#5f5f5f, 235=#777777, 236=#868686, 237=#969696, 238=#cbcbcb, 239=#b2b2b2, 240=#d7d7d7, 241=#dddddd, 242=#e3e3e3, 243=#eaeaea, 244=#f1f1f1, 245=#f8f8f8. The same 256-entry table occurs in: ZapSpot.exe:BITMAP/IMG-SPLASH, ZapSpot.exe:IMG-TM.GIF:global.
- ZapSpot.exe banner 468x60: 8 tables, 8 distinct, 295 used colours, 240 not web-safe, 238 not in the IMG-SPLASH palette.
- ZapSpot.exe GIF: 27 tables, 27 distinct, 950 used colours, 843 not web-safe, 834 not in the IMG-SPLASH palette.
- Union of used colours over all GIFs and IMG-SPLASH: 1255. Game plus engine (no 468x60 banners): 1017.
- Transparency, Moeboid.gam: 42 of 46 GIFs set the GCE transparency flag on every frame. The transparent index differs per file (0, 4, 5, 6, 7, 8). Colour of the transparent entry: #000000 in 41 files, #ffffff in 1 file.
  - Files whose transparent entry has a different colour: ANI-MEBOID_LEFT-31X31.GIF.
  - Files where the colour of the transparent entry also occurs on a visible pixel (a colour-key blit by colour value would make those pixels transparent): Moeboid.gam:ANI-MEBOID_LEFT-31X31.GIF, ZapSpot.exe:ANI-ADBANNER2.GIF, ZapSpot.exe:IMG-GAMEAREA.GIF, ZapSpot.exe:IMG-GETZAPPEDBLOCK.GIF, ZapSpot.exe:SLB-LILBTNICONS.GIF, ZapSpot.exe:SLB-RECTBTNBACKS-HC.GIF. In all other files with transparency, the transparent colour does not occur on a visible pixel.
  - Files without transparency in Moeboid.gam: ANI-TITLESCREEN_ANIMATION-500X79.GIF, IMG-BACKGROUNDSCREEN-500X420.GIF, IMG-SHELL_ICON-80X60.GIF, IMG-TITLESCREEN-500X420.GIF.
- Game colours outside the IMG-SPLASH palette: #3300ff, #33ff00, used by ANI-BADDIE_LEFT-43X43.GIF, ANI-BADDIE_RIGHT-43X43.GIF, IMG-BACKGROUNDSCREEN-500X420.GIF, IMG-TITLESCREEN-500X420.GIF.
- Inferred: the game art uses only web-safe colours, and the IMG-SPLASH palette holds 96 of the 98. In an 8-bit display mode with that palette, the engine or GDI would remap the other 2 colours. The bytes do not show the display mode. The engine code workstream must confirm the display mode and how the engine maps GIF colours and transparency.

## Dialog fonts and pixel conversion

- Fonts (verified, DS_SETFONT data): "MS Sans Serif" 8 pt (DLGTEMPLATE): 7 dialogs; "MS Sans Serif" 8 pt (DLGTEMPLATEEX), weight 0, italic 0, charset 1: 1 dialog. DLGTEMPLATE does not store weight, italic or charset; DLGTEMPLATEEX stores charset 1 = DEFAULT_CHARSET.
- Dialog base units: 6 x 13 px. Source: `fonts/sserife.fon` (sha256 `28877eee4ccda2a33e0fac39da7f3effdea061e4fd9cc019f00d82405b9f9682`), 8pt strike: tmHeight 13, internal leading 2, charset 0, extent of "a..zA..Z" = 323 px. Formula (GdiGetCharDimensions): x = (extent / 26 + 1) / 2, y = tmHeight. Pixel values: x and cx times 6 / 4, y and cy times 13 / 8, with MulDiv rounding.
- Assumptions (inferred): 96 DPI ("Small Fonts"); Windows XP maps "MS Sans Serif" to the bitmap font sserife.fon. The pixel sizes are client-area sizes. The window frame and caption size depend on the theme metrics; compute them in a later step.

| Dialog | Format | Caption | DLU (cx x cy) | Client px (w x h) | Controls | Style |
|---|---|---|---|---|---|---|
| DUMPINFO | DLGTEMPLATE | Unexpected Error Occurred | 320 x 122 | 480 x 198 | 9 | DS_SETFONT DS_MODALFRAME DS_CENTER WS_CAPTION WS_POPUP |
| DUMPINFO2 | DLGTEMPLATE | Unexpected Error Occurred | 320 x 236 | 480 x 384 | 9 | DS_SETFONT DS_MODALFRAME DS_CENTER WS_CAPTION WS_POPUP |
| IDD_CONFIRM_SAVE | DLGTEMPLATE | Save to Desktop Requested | 207 x 90 | 311 x 146 | 5 | DS_SETFONT DS_CENTER WS_CAPTION WS_POPUP WS_VISIBLE |
| IDD_INPUT_BOX | DLGTEMPLATE | Dialog | 167 x 61 | 251 x 99 | 4 | DS_SETFONT DS_MODALFRAME DS_CENTER WS_CAPTION WS_POPUP |
| IDD_INPUT_BOX2 | DLGTEMPLATE | Dialog | 167 x 61 | 251 x 99 | 3 | DS_SETFONT DS_MODALFRAME DS_CENTER WS_CAPTION WS_POPUP |
| IDD_QUIT_NOTSAVED | DLGTEMPLATE | Play Again Soon | 235 x 90 | 353 x 146 | 6 | DS_SETFONT DS_MODALFRAME DS_CENTER WS_CAPTION WS_POPUP |
| IDD_QUIT_SAVED | DLGTEMPLATE | Warning: Game in Progress | 198 x 50 | 297 x 81 | 3 | DS_SETFONT DS_MODALFRAME DS_CENTER WS_CAPTION WS_POPUP |
| IDD_TERMSOFSERVICE | DLGTEMPLATEEX | ZapSpot Terms of Service and Privacy Policy | 279 x 170 | 419 x 276 | 4 | DS_SETFONT DS_MODALFRAME DS_CENTER WS_CAPTION WS_POPUP |

## WAV formats

| Binary | Name | Format | Rate (Hz) | Bits | Channels | Block align | Data bytes | Duration (s) | Extra chunks |
|---|---|---|---|---|---|---|---|---|---|
| Moeboid.gam | SND-EXTRALIFE.WAV | PCM | 11025 | 16 | 1 | 2 | 13572 | 0.616 | - |
| Moeboid.gam | SND-GAMEOPEN.WAV | PCM | 11025 | 8 | 1 | 1 | 10253 | 0.930 | - |
| Moeboid.gam | SND-GAMEOVER-HIGHSCORE.WAV | PCM | 11025 | 8 | 1 | 1 | 10176 | 0.923 | - |
| Moeboid.gam | SND-GAMEOVER.WAV | PCM | 11025 | 8 | 1 | 1 | 6538 | 0.593 | - |
| Moeboid.gam | SND-GAMESTART.WAV | PCM | 8000 | 16 | 1 | 2 | 32830 | 2.052 | - |
| Moeboid.gam | SND-LOSELIFE.WAV | PCM | 11025 | 8 | 1 | 1 | 3821 | 0.347 | - |
| Moeboid.gam | SND-MOEBEATS.WAV | PCM | 11025 | 8 | 1 | 1 | 1652 | 0.150 | - |
| Moeboid.gam | SND-MOEBGROWTH.WAV | PCM | 11025 | 8 | 1 | 1 | 4513 | 0.409 | `PAD ` |
| Moeboid.gam | SND-NEWBADDIEBAD.WAV | PCM | 11025 | 8 | 1 | 1 | 2029 | 0.184 | - |
| Moeboid.gam | SND-NEWBADDIEGOOD.WAV | PCM | 11025 | 8 | 1 | 1 | 1932 | 0.175 | `fact` |
| Moeboid.gam | SND-RANDBG.WAV | PCM | 11025 | 8 | 1 | 1 | 19993 | 1.813 | `PAD ` |
| ZapSpot.exe | BTNCLICK.WAV | PCM | 11025 | 8 | 1 | 1 | 480 | 0.044 | `cue `, `LIST`, `fact` |
| ZapSpot.exe | CLOSESHELL.WAV | PCM | 11025 | 8 | 1 | 1 | 10401 | 0.943 | - |
| ZapSpot.exe | OPENSHELL.WAV | PCM | 11025 | 8 | 1 | 1 | 31863 | 2.890 | - |
| ZapSpot.exe | POPUP.WAV | PCM | 11025 | 8 | 1 | 1 | 1692 | 0.153 | `fact` |

- Moeboid.gam SND-MOEBGROWTH.WAV: `PAD ` chunk, 460 bytes, all zero: True.
- Moeboid.gam SND-RANDBG.WAV: `PAD ` chunk, 460 bytes, all zero: True.
- ZapSpot.exe BTNCLICK.WAV: cue 2 at sample 41707 is beyond the 480 data samples.
- ZapSpot.exe BTNCLICK.WAV: cue 3 at sample 41707 is beyond the 480 data samples.
- ZapSpot.exe BTNCLICK.WAV: LIST/adtl labels 'Untitled Marker 3', 'New File mix2', 'New File mix2.2'.

## Anomalies and notes

- Task brief count differs from the binary: the brief states 54 GIFs and 12 WAVs in Moeboid.gam. The resource tree holds 46 GIFs, 11 WAVs, 1 ZML, and 2 STRING blocks (verified).
- Moeboid.gam: GIF ANI-TITLESCREEN_ANIMATION-500X79.GIF: name says 500x79, logical screen is 500x89 (verified).
- ZapSpot.exe: GIF ANI-ADBANNER3.GIF: GIF87a signature, but the file holds 17 GIF89a extension blocks (verified).
- Moeboid.gam ANI-BADDIE-BLOB-39X39.GIF: 6 frames and no NETSCAPE loop extension. A browser plays it once (verified: no extension).
- Moeboid.gam IMG-BACKGROUNDSCREEN-500X420.GIF: 3 frames and no NETSCAPE loop extension. A browser plays it once (verified: no extension).
- ZapSpot.exe ANI-ADBANNER2.GIF: application extension ADOBE:IR1.0 (verified).
- ZapSpot.exe ANI-ADBANNER5.GIF: application extension ADOBE:IR1.0 (verified).
- ZapSpot.exe IMG-GAMEAREA.GIF: interlaced (verified).
- Moeboid.gam HELP.ZML: 1396 bytes, first byte 0x22, last byte 0x22, NUL bytes at offsets none (verified).
- ZapSpot.exe TERMSOFSERVICE: 15418 bytes, first byte 0x5A, last byte 0x00, NUL bytes at offsets 15417 (verified).
- Moeboid.gam: resource directory TimeDateStamp is 0 (verified).
- ZapSpot.exe: resource directory TimeDateStamp is 0 (verified).
- moeboid.exe: resource directory TimeDateStamp is 0 (verified).
- No RT_VERSION resource exists. Version-like strings: Moeboid.gam string 3 = "00.01.01.08"; ZapSpot.exe string 1 = "01.01.01.1034" (verified; meaning inferred).

## Non-resource data

- Moeboid.gam, file offset 0x41050, 4560 bytes: Authenticode WIN_CERTIFICATE (security directory). Raw copy: `Moeboid.gam/raw/_NONRESOURCE/authenticode_0x41050.p7b`. Certificate subjects: "O=VeriSign, Inc., OU=VeriSign Trust Network, OU=www.verisign.com/repository/RPA Incorp. by Ref.,LIAB.LTD(c)98, CN=VeriSign Time Stamping Service CA SW1" / "L=Internet, O=VeriSign, Inc., OU=VeriSign Commercial Software Publishers CA, OU=www.verisign.com/repository/CPS Incorp. by Ref.,LIAB.LTD(c)96, OU=Digital ID Class 3 - Microsoft Software Validation v2, C=US, ST=New York, L=New York, CN=ZapSpot, Inc., OU=ZapSpot, Inc.".
- Moeboid.gam, file offset 0x41000, 73 bytes: CodeView NB10 debug record, PDB path "C:\Prog\ZapSpot_CoreDev\Apps\Moeboid\Release\Moeboid.pdb". Raw copy: `Moeboid.gam/raw/_NONRESOURCE/codeview_nb10_0x41000.bin`.
- Moeboid.gam: every non-zero byte in the .rsrc section belongs to the resource tree (verified).
- ZapSpot.exe, file offset 0x77050, 4552 bytes: Authenticode WIN_CERTIFICATE (security directory). Raw copy: `ZapSpot.exe/raw/_NONRESOURCE/authenticode_0x77050.p7b`. Certificate subjects: "O=VeriSign, Inc., OU=VeriSign Trust Network, OU=www.verisign.com/repository/RPA Incorp. by Ref.,LIAB.LTD(c)98, CN=VeriSign Time Stamping Service CA SW1" / "L=Internet, O=VeriSign, Inc., OU=VeriSign Commercial Software Publishers CA, OU=www.verisign.com/repository/CPS Incorp. by Ref.,LIAB.LTD(c)96, OU=Digital ID Class 3 - Microsoft Software Validation v2, C=US, ST=New York, L=New York, CN=ZapSpot, Inc., OU=ZapSpot, Inc.".
- ZapSpot.exe, file offset 0x77000, 74 bytes: CodeView NB10 debug record, PDB path "C:\Prog\ZapSpot_CoreDev\Shell\ZapSpot\Release\ZapSpot.pdb". Raw copy: `ZapSpot.exe/raw/_NONRESOURCE/codeview_nb10_0x77000.bin`.
- ZapSpot.exe: every non-zero byte in the .rsrc section belongs to the resource tree (verified).
- moeboid.exe, file offset 0x7DFE0, 4608 bytes: Authenticode WIN_CERTIFICATE (security directory). Raw copy: `moeboid.exe/raw/_NONRESOURCE/authenticode_0x7DFE0.p7b`. Certificate subjects: "O=VeriSign, Inc., OU=VeriSign Trust Network, OU=www.verisign.com/repository/RPA Incorp. by Ref.,LIAB.LTD(c)98, CN=VeriSign Time Stamping Service CA SW1" / "L=Internet, O=VeriSign, Inc., OU=VeriSign Commercial Software Publishers CA, OU=www.verisign.com/repository/CPS Incorp. by Ref.,LIAB.LTD(c)96, OU=Digital ID Class 3 - Microsoft Software Validation v2, C=US, ST=New York, L=New York, CN=ZapSpot, Inc., OU=ZapSpot, Inc.".
- moeboid.exe, file offset 0xB000, 471008 bytes: overlay before the signature (not a resource; see the extraction workstream).
- moeboid.exe: every non-zero byte in the .rsrc section belongs to the resource tree (verified).

## Moeboid.gam

Source: `extracted/Moeboid.gam`, 270880 bytes. .rsrc section at file offset 0x10000, raw size 196608.

| Type | Name/ID | Lang | Size | SHA-256 | Raw path | Decoded path | Description |
|---|---|---|---|---|---|---|---|
| STRING | 1 | 0409 | 302 | `93f518cc48148d0432aa50d42345a76b3b813aad07c7ba589cacdc2fc50ae77b` | `Moeboid.gam/raw/STRING/1_0409.bin` | `Moeboid.gam/decoded/strings.txt`<br>`Moeboid.gam/decoded/strings.json` | String block 1 (ids 0-15): 7 defined strings |
| STRING | 63 | 0409 | 56 | `9f8783b578761fac44194395c48d8ad17a5fcc10c2af9d09148dc763efe88065` | `Moeboid.gam/raw/STRING/63_0409.bin` | `Moeboid.gam/decoded/strings.txt`<br>`Moeboid.gam/decoded/strings.json` | String block 63 (ids 992-1007): 1 defined strings |
| RCDATA | ANI-BADDIE-BLOB-39X39.GIF | 0409 | 338 | `3f1616a567b2750501e719931736672cff3f6ea214983fa86c3498eff980be62` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE-BLOB-39X39_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE-BLOB-39X39_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 39x39, 6 frames, delay 10 cs, GCT 2, transparent idx 0, no loop extension |
| RCDATA | ANI-BADDIE_LEFT-11X11.GIF | 0409 | 180 | `232b215e6eef5fbc08beaf1de0a4a5d4fb41eceecaddb76e050f0fadae561fa0` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_LEFT-11X11_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_LEFT-11X11_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 11x11, 3 frames, delay 100 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-BADDIE_LEFT-15X15.GIF | 0409 | 330 | `f2d4fe7cd5e99b9ebd467b4201ddee9f315b1ee70c6f98fa768a8eda6fad92e2` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_LEFT-15X15_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_LEFT-15X15_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 15x15, 3 frames, delay 40 cs, GCT 8, transparent idx 6, loop 0 |
| RCDATA | ANI-BADDIE_LEFT-19X19.GIF | 0409 | 245 | `f32f20bc112ef10c4013d53bb31c8905294af4f9e786407bfb062c5b981ff975` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_LEFT-19X19_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_LEFT-19X19_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 19x19, 3 frames, delay 30 cs, GCT 8, transparent idx 7, loop 0 |
| RCDATA | ANI-BADDIE_LEFT-23X23.GIF | 0409 | 605 | `1d784175d3d3cb28f13bbc83c85780ee4277fe6c845aeb7c6ec5f3166c39f6b7` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_LEFT-23X23_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_LEFT-23X23_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 23x23, 3 frames, delay 50 cs, GCT 16, transparent idx 8, loop 0 |
| RCDATA | ANI-BADDIE_LEFT-27X27.GIF | 0409 | 635 | `8ea10c0e6406d76fdfb701bd0cedde193f044bb5632817d482212ea52c9ea217` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_LEFT-27X27_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_LEFT-27X27_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 27x27, 3 frames, delay 20 cs, GCT 8, transparent idx 6, loop 0 |
| RCDATA | ANI-BADDIE_LEFT-31X31.GIF | 0409 | 636 | `26af05a7acfa5cd3ef1bfe1d6f2b2d3112faca0acd58b50e49318f8e97aa803e` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_LEFT-31X31_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_LEFT-31X31_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 31x31, 3 frames, delay 30 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-BADDIE_LEFT-35X35.GIF | 0409 | 839 | `da292ab75a139096ac90adb3816727b86dbc7a0cabd7f483cddc131cbf675845` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_LEFT-35X35_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_LEFT-35X35_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 35x35, 3 frames, delay 40 cs, GCT 8, transparent idx 6, loop 0 |
| RCDATA | ANI-BADDIE_LEFT-39X39.GIF | 0409 | 1040 | `bf406199f11f6f717912b7b355bae5af25cd19e20d4dbb543e0555b1ec48c504` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_LEFT-39X39_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_LEFT-39X39_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 39x39, 3 frames, delay 30 cs, GCT 8, transparent idx 7, loop 0 |
| RCDATA | ANI-BADDIE_LEFT-43X43.GIF | 0409 | 1071 | `3f132b1463892b9316ffd84c8748de9d81452a3597b8cebddfa4845f0fbfd65a` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_LEFT-43X43_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_LEFT-43X43_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 43x43, 3 frames, delay 20 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-BADDIE_LEFT-47X47.GIF | 0409 | 1096 | `16424c832de707bc4045ff6c4837fc9bc1f0b1da9618dc15fee4d352acf28476` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_LEFT-47X47_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_LEFT-47X47_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 47x47, 3 frames, delay 20 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-BADDIE_RIGHT-11X11.GIF | 0409 | 179 | `4e4ccb451d20ec797e6d82bf7502bb4d0876d70a56adf4e541e4862fcc641380` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_RIGHT-11X11_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_RIGHT-11X11_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 11x11, 3 frames, delay 100 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-BADDIE_RIGHT-15X15.GIF | 0409 | 332 | `a6def76aac3cbcf9b8aa0e88955c459b541f47257bed41443ab2c775c5e5f776` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_RIGHT-15X15_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_RIGHT-15X15_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 15x15, 3 frames, delay 40 cs, GCT 8, transparent idx 6, loop 0 |
| RCDATA | ANI-BADDIE_RIGHT-19X19.GIF | 0409 | 245 | `eba9948e1ca47f3fc792e1cb547ac6aebd942fdac6aeadd1cdbd1b05c5282993` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_RIGHT-19X19_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_RIGHT-19X19_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 19x19, 3 frames, delay 30 cs, GCT 8, transparent idx 7, loop 0 |
| RCDATA | ANI-BADDIE_RIGHT-23X23.GIF | 0409 | 585 | `c12825f5a6e3be07fa7491c4468005bbdc8f0af7c5cd3fa7b3c9c9a1d7a438ba` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_RIGHT-23X23_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_RIGHT-23X23_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 23x23, 3 frames, delay 50 cs, GCT 16, transparent idx 8, loop 0 |
| RCDATA | ANI-BADDIE_RIGHT-27X27.GIF | 0409 | 634 | `27cf0b3b55d8d00c39b38860671ee3a396be5e1a01aea2b82e09764c8215d1c2` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_RIGHT-27X27_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_RIGHT-27X27_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 27x27, 3 frames, delay 20 cs, GCT 8, transparent idx 6, loop 0 |
| RCDATA | ANI-BADDIE_RIGHT-31X31.GIF | 0409 | 646 | `81d38ed2bff54adbcd4ecbc9c6a3f897ab88f160774faeece791200aec60404c` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_RIGHT-31X31_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_RIGHT-31X31_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 31x31, 3 frames, delay 30 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-BADDIE_RIGHT-35X35.GIF | 0409 | 836 | `254419bc3384c96f436f4cfef43501824a9334819c660b22e6d4d4b1b88adba3` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_RIGHT-35X35_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_RIGHT-35X35_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 35x35, 3 frames, delay 40 cs, GCT 8, transparent idx 6, loop 0 |
| RCDATA | ANI-BADDIE_RIGHT-39X39.GIF | 0409 | 1044 | `548c02a90ff5c57d9ce03132e4b170c0988bc736fd16bfcbd1f056b12648140d` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_RIGHT-39X39_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_RIGHT-39X39_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 39x39, 3 frames, delay 30 cs, GCT 8, transparent idx 7, loop 0 |
| RCDATA | ANI-BADDIE_RIGHT-43X43.GIF | 0409 | 1091 | `f51e8850b9b87f1eeb2153981fd3e8b348d3864f3579c82cc134c724e0e1164e` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_RIGHT-43X43_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_RIGHT-43X43_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 43x43, 3 frames, delay 20 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-BADDIE_RIGHT-47X47.GIF | 0409 | 1095 | `e6098eb4e9e34da822ddc02fd4f8d3c52ff13dd7acee482ce60cf41c56255f92` | `Moeboid.gam/raw/RCDATA/ANI-BADDIE_RIGHT-47X47_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-BADDIE_RIGHT-47X47_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 47x47, 3 frames, delay 20 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_ANGEL-19X19.GIF | 0409 | 314 | `82f7cfddb4f0b7f801f6eb0694bcffc44507f010659452edbbb6098d1233c5cd` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_ANGEL-19X19_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_ANGEL-19X19_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 19x19, 3 frames, delay 10 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_LEFT-11X11.GIF | 0409 | 170 | `a9281cf2ea3fa5c57d629c0298ab5a85cbb1bd2d006dfbd2e774f562e60795f9` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_LEFT-11X11_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_LEFT-11X11_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 11x11, 3 frames, delay 100 cs, GCT 8, transparent idx 4, loop 0 |
| RCDATA | ANI-MEBOID_LEFT-15X15.GIF | 0409 | 403 | `044747b239d584426d9ff5f668e94a4c642a226160c71a30c1cc38875929cfea` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_LEFT-15X15_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_LEFT-15X15_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 15x15, 4 frames, delay 25 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_LEFT-19X19.GIF | 0409 | 508 | `126c60757601babdf389ff1a769139e9733b30ccdf26d34117acb236fe826a37` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_LEFT-19X19_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_LEFT-19X19_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 19x19, 4 frames, delay 25 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_LEFT-23X23.GIF | 0409 | 626 | `1787e0fe368866733aab713a943d9d253547b946f42fe70bf0b4c3941459c8fc` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_LEFT-23X23_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_LEFT-23X23_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 23x23, 4 frames, delay 25 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_LEFT-27X27.GIF | 0409 | 775 | `84e2520e8bac2c74ec955fa40eb0aea93cd86e381edd3818e3e7f483951be5e1` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_LEFT-27X27_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_LEFT-27X27_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 27x27, 4 frames, delay 30 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_LEFT-31X31.GIF | 0409 | 922 | `80382cfea338d22e46b929dca6c9dd0e0f312fda0f7f9db54ed4a055a0c71225` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_LEFT-31X31_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_LEFT-31X31_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 31x31, 4 frames, delay 30 cs, GCT 8, transparent idx 6, loop 0 |
| RCDATA | ANI-MEBOID_LEFT-35X35.GIF | 0409 | 1080 | `8582387ca96dab76ae5ea0c7afa70f118e4212c48147ed441d4b67d3525d8a09` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_LEFT-35X35_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_LEFT-35X35_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 35x35, 4 frames, delay 30 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_LEFT-39X39.GIF | 0409 | 1205 | `08ba1164280f94398976213a4cc9ed6566e2017d8bbbb17386e374d0cddc44cb` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_LEFT-39X39_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_LEFT-39X39_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 39x39, 4 frames, delay 25 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_LEFT-43X43.GIF | 0409 | 1388 | `ba297b6b7e03121e2a3602ea9c6e072c33e892cd45c1704db1d80739b44dbfcd` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_LEFT-43X43_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_LEFT-43X43_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 43x43, 4 frames, delay 25 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_LEFT-47X47.GIF | 0409 | 1280 | `7237941ceec2859d58d5942d613c5c2988c1d3f13a9014705ffd44893f81ac14` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_LEFT-47X47_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_LEFT-47X47_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 47x47, 4 frames, delay 25 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_RIGHT-11X11.GIF | 0409 | 170 | `8050ee3febb22788f048841a2a01def320c2dec3b91955427049fbda7f1530b0` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_RIGHT-11X11_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_RIGHT-11X11_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 11x11, 3 frames, delay 100 cs, GCT 8, transparent idx 4, loop 0 |
| RCDATA | ANI-MEBOID_RIGHT-15X15.GIF | 0409 | 405 | `f9d146186dea44d77209995e2213eadb86abbed45924163c7d609284b4344d05` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_RIGHT-15X15_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_RIGHT-15X15_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 15x15, 4 frames, delay 25 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_RIGHT-19X19.GIF | 0409 | 512 | `2bb7ea93b134793ad90328dff2bb3c9fa075467330ba9a2c22f054c521eedf47` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_RIGHT-19X19_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_RIGHT-19X19_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 19x19, 4 frames, delay 25 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_RIGHT-23X23.GIF | 0409 | 626 | `0782ee7ec1b173e30ed6bf8808bec04edf341e3c1daafdc9918d4ad96a400d67` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_RIGHT-23X23_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_RIGHT-23X23_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 23x23, 4 frames, delay 25 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_RIGHT-27X27.GIF | 0409 | 773 | `58869e5d7a3a6158bfebb897aecd0e2f3c6408429294279228d29e1a4c5d8fa1` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_RIGHT-27X27_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_RIGHT-27X27_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 27x27, 4 frames, delay 30 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_RIGHT-31X31.GIF | 0409 | 922 | `5988cfbaa839b4cda7e6fc75a693f38c3a744ec9c72a43865599b311f7972eee` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_RIGHT-31X31_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_RIGHT-31X31_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 31x31, 4 frames, delay 30 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_RIGHT-35X35.GIF | 0409 | 1070 | `6114e7a1c7157a365da24cf2bdf3f86cf6768c9404858b8803fbe4d0e25ea560` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_RIGHT-35X35_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_RIGHT-35X35_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 35x35, 4 frames, delay 30 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_RIGHT-39X39.GIF | 0409 | 1195 | `81edbd13faaa7a1a0ddc942caf37aa567bd90c5ea4251727442eda07652d76a3` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_RIGHT-39X39_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_RIGHT-39X39_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 39x39, 4 frames, delay 25 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_RIGHT-43X43.GIF | 0409 | 1372 | `cda0ab2169a6a166f3ee6c413bb3d23664506a680a2a2b8f353967f25fa73eff` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_RIGHT-43X43_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_RIGHT-43X43_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 43x43, 4 frames, delay 25 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-MEBOID_RIGHT-47X47.GIF | 0409 | 1269 | `3c160e2c6e4c0f31301d349ecc68012a0786fdff1241027d5d719729a4ac6823` | `Moeboid.gam/raw/RCDATA/ANI-MEBOID_RIGHT-47X47_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-MEBOID_RIGHT-47X47_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 47x47, 4 frames, delay 25 cs, GCT 8, transparent idx 5, loop 0 |
| RCDATA | ANI-TITLESCREEN_ANIMATION-500X79.GIF | 0409 | 9290 | `c492090393e381cb42938a8475e92f5b013d00b7b41aaaed2d81a71491b7c53e` | `Moeboid.gam/raw/RCDATA/ANI-TITLESCREEN_ANIMATION-500X79_0409.gif` | `Moeboid.gam/decoded/GIF/ANI-TITLESCREEN_ANIMATION-500X79_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 500x89, 24 frames, delay 50/100/200/250/400 cs, GCT 32, loop 0 |
| RCDATA | HELP.ZML | 0409 | 1396 | `916d2489a0a56ac5fecafd4e947179c9465d8c0906512aaed871b3fcc2186106` | `Moeboid.gam/raw/RCDATA/HELP_0409.zml` | `Moeboid.gam/decoded/RCDATA/HELP_0409.utf8.txt`<br>`Moeboid.gam/decoded/zml_tags.txt` | ZapSpot markup text, cp1252, 23 lines, 0 non-ASCII bytes, starts/ends with '"'/'"' |
| RCDATA | IMG-BACKGROUNDSCREEN-500X420.GIF | 0409 | 29565 | `7c0e7daf3cc01161c9633a828932f50e08ee3e28c50f5e3290534229e08ab320` | `Moeboid.gam/raw/RCDATA/IMG-BACKGROUNDSCREEN-500X420_0409.gif` | `Moeboid.gam/decoded/GIF/IMG-BACKGROUNDSCREEN-500X420_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 500x420, 3 frames, delay 100/600 cs, GCT 64, no loop extension |
| RCDATA | IMG-SHELL_ICON-80X60.GIF | 0409 | 1479 | `659a065b83f6b7fd0b7bf1d31c7c6ad7c0bc476de715ae17170f495aa6d1abcc` | `Moeboid.gam/raw/RCDATA/IMG-SHELL_ICON-80X60_0409.gif` | `Moeboid.gam/decoded/GIF/IMG-SHELL_ICON-80X60_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 80x60, 1 frame, GCT 32 |
| RCDATA | IMG-TITLESCREEN-500X420.GIF | 0409 | 8557 | `3b8cb1cc7e41393f6397f6401c77aae51ef8a5bfa6c28e16b59c9f4de9551605` | `Moeboid.gam/raw/RCDATA/IMG-TITLESCREEN-500X420_0409.gif` | `Moeboid.gam/decoded/GIF/IMG-TITLESCREEN-500X420_0409/`<br>`Moeboid.gam/decoded/gifs.json` | GIF89a 500x420, 1 frame, GCT 32 |
| RCDATA | SND-EXTRALIFE.WAV | 0409 | 13616 | `1e114d7c3b842ff9df8ced2c393ab901010ab4a7ebdffb9966324b55da4a8a46` | `Moeboid.gam/raw/RCDATA/SND-EXTRALIFE_0409.wav` | `Moeboid.gam/decoded/wavs.json` | WAV PCM 11025 Hz 16-bit mono, 13572 data bytes, 0.616 s |
| RCDATA | SND-GAMEOPEN.WAV | 0409 | 10298 | `ef6c335ad5bcbfc7d3c8a47fc544926dff5253d4845ddef22a54e45b0f127cae` | `Moeboid.gam/raw/RCDATA/SND-GAMEOPEN_0409.wav` | `Moeboid.gam/decoded/wavs.json` | WAV PCM 11025 Hz 8-bit mono, 10253 data bytes, 0.930 s |
| RCDATA | SND-GAMEOVER-HIGHSCORE.WAV | 0409 | 10220 | `25279ff90e256c3f4444092effec472243b79fec0f6411ac426e40720e9fa402` | `Moeboid.gam/raw/RCDATA/SND-GAMEOVER-HIGHSCORE_0409.wav` | `Moeboid.gam/decoded/wavs.json` | WAV PCM 11025 Hz 8-bit mono, 10176 data bytes, 0.923 s |
| RCDATA | SND-GAMEOVER.WAV | 0409 | 6582 | `19f09401959a45b0a0887f1a08f04086e11226b792b1a969e4fe94833aedfdac` | `Moeboid.gam/raw/RCDATA/SND-GAMEOVER_0409.wav` | `Moeboid.gam/decoded/wavs.json` | WAV PCM 11025 Hz 8-bit mono, 6538 data bytes, 0.593 s |
| RCDATA | SND-GAMESTART.WAV | 0409 | 32874 | `8d140b565cdf8ce39e5ce7ce0a1ccfe6b31f78e062b92b6218d88d296cd13b09` | `Moeboid.gam/raw/RCDATA/SND-GAMESTART_0409.wav` | `Moeboid.gam/decoded/wavs.json` | WAV PCM 8000 Hz 16-bit mono, 32830 data bytes, 2.052 s |
| RCDATA | SND-LOSELIFE.WAV | 0409 | 3866 | `3ba696970d69c42351469d35421d91bebd3ecfc2e3709651f656e546946d9ef9` | `Moeboid.gam/raw/RCDATA/SND-LOSELIFE_0409.wav` | `Moeboid.gam/decoded/wavs.json` | WAV PCM 11025 Hz 8-bit mono, 3821 data bytes, 0.347 s |
| RCDATA | SND-MOEBEATS.WAV | 0409 | 1696 | `f18df17854f5d59310656b980c42a2d8390954a4a29a8573c696cd24b41814e8` | `Moeboid.gam/raw/RCDATA/SND-MOEBEATS_0409.wav` | `Moeboid.gam/decoded/wavs.json` | WAV PCM 11025 Hz 8-bit mono, 1652 data bytes, 0.150 s |
| RCDATA | SND-MOEBGROWTH.WAV | 0409 | 5026 | `7d578bf49af41ed62e45af9e0967fa362f0b184e60bbe9649f081d42d9d109f2` | `Moeboid.gam/raw/RCDATA/SND-MOEBGROWTH_0409.wav` | `Moeboid.gam/decoded/wavs.json` | WAV PCM 11025 Hz 8-bit mono, 4513 data bytes, 0.409 s, chunks: PAD |
| RCDATA | SND-NEWBADDIEBAD.WAV | 0409 | 2074 | `55125993bce2b5ca06c59fcdabe4fdbb3b78e5a99243f0f2112281066c6a7cc0` | `Moeboid.gam/raw/RCDATA/SND-NEWBADDIEBAD_0409.wav` | `Moeboid.gam/decoded/wavs.json` | WAV PCM 11025 Hz 8-bit mono, 2029 data bytes, 0.184 s |
| RCDATA | SND-NEWBADDIEGOOD.WAV | 0409 | 1988 | `8f649bd44c8c94958bce37abe6532d7d8377627caa853fa7203133266e2009f3` | `Moeboid.gam/raw/RCDATA/SND-NEWBADDIEGOOD_0409.wav` | `Moeboid.gam/decoded/wavs.json` | WAV PCM 11025 Hz 8-bit mono, 1932 data bytes, 0.175 s, chunks: fact |
| RCDATA | SND-RANDBG.WAV | 0409 | 20506 | `de2403398660a520c7c6d245b3760e37ba7e4c5d246c8e3aba88aca111651923` | `Moeboid.gam/raw/RCDATA/SND-RANDBG_0409.wav` | `Moeboid.gam/decoded/wavs.json` | WAV PCM 11025 Hz 8-bit mono, 19993 data bytes, 1.813 s, chunks: PAD |

## ZapSpot.exe

Source: `extracted/ZapSpot.exe`, 492056 bytes. .rsrc section at file offset 0x37000, raw size 245760.

| Type | Name/ID | Lang | Size | SHA-256 | Raw path | Decoded path | Description |
|---|---|---|---|---|---|---|---|
| CURSOR | 1 | 0409 | 308 | `e116c303520528d033958df437e1aad8589685adf62f8e3eedc23006690e21fe` | `ZapSpot.exe/raw/CURSOR/1_0409.bin` | - | Cursor image 32x32, 1 bpp, hotspot (13,7); see group |
| CURSOR | 2 | 0409 | 308 | `2c7df4335f93e223092081816023126b12fb202daafcc5dbf3554bcfd7c7fc14` | `ZapSpot.exe/raw/CURSOR/2_0409.bin` | - | Cursor image 32x32, 1 bpp, hotspot (12,6); see group |
| CURSOR | 3 | 0409 | 308 | `4c40fd81482da89c9853d97e2837871c7408a91a2733536372ec6e55f682ee74` | `ZapSpot.exe/raw/CURSOR/3_0409.bin` | - | Cursor image 32x32, 1 bpp, hotspot (16,15); see group |
| CURSOR | 4 | 0409 | 308 | `e188fb9113d64e483e1fb5205ed91f140ae3e8e9a317d9ef80c0109442234aa9` | `ZapSpot.exe/raw/CURSOR/4_0409.bin` | - | Cursor image 32x32, 1 bpp, hotspot (15,17); see group |
| CURSOR | 5 | 0409 | 308 | `c754f936b943268596168b2aaf58e9e481ea6e5a42014945b6032f4a57dc734a` | `ZapSpot.exe/raw/CURSOR/5_0409.bin` | - | Cursor image 32x32, 1 bpp, hotspot (15,17); see group |
| CURSOR | 6 | 0409 | 308 | `9636f4e89624faa15913429a67cd1bb2751602949b47a37c85d546d2419afcdd` | `ZapSpot.exe/raw/CURSOR/6_0409.bin` | - | Cursor image 32x32, 1 bpp, hotspot (16,15); see group |
| BITMAP | IMG-SPLASH | 0409 | 10268 | `a744268f8eaa43495b086f733486a7518806b68af86d0288bcabcb4c333e39f9` | `ZapSpot.exe/raw/BITMAP/IMG-SPLASH_0409.bin` | `ZapSpot.exe/decoded/BITMAP/IMG-SPLASH_0409.bmp`<br>`ZapSpot.exe/decoded/BITMAP/IMG-SPLASH_0409.png`<br>`ZapSpot.exe/decoded/BITMAP/IMG-SPLASH_0409.json` | DIB 400x240, 8 bpp, BI_RLE8, palette 256 entries (69 used) |
| ICON | 7 | 0409 | 744 | `61b6a76ac13a6e51dd0f1715562d0f30f0e402b08f31b8724e4d8dbc9cd189e1` | `ZapSpot.exe/raw/ICON/7_0409.bin` | - | Icon image 32x32, 4 bpp; see group |
| ICON | 8 | 0409 | 296 | `1c916c9e57add4814f170f797bf0015196dcf6498ffa72c26a107c0801c65639` | `ZapSpot.exe/raw/ICON/8_0409.bin` | - | Icon image 16x16, 4 bpp; see group |
| DIALOG | DUMPINFO | 0409 | 2000 | `9a3783c824f49b58c7afa3e4df8244ed4cb46df0f3f36f81114654279032ffba` | `ZapSpot.exe/raw/DIALOG/DUMPINFO_0409.bin` | `ZapSpot.exe/decoded/DIALOG/DUMPINFO_0409.rc`<br>`ZapSpot.exe/decoded/dialogs.json` | DLGTEMPLATE "Unexpected Error Occurred", 320x122 DLU, 9 controls, font MS Sans Serif 8pt |
| DIALOG | DUMPINFO2 | 0409 | 1868 | `61257981dcb354fec50fc7dbdbfcda63536ef06887d1277c188a675748debe71` | `ZapSpot.exe/raw/DIALOG/DUMPINFO2_0409.bin` | `ZapSpot.exe/decoded/DIALOG/DUMPINFO2_0409.rc`<br>`ZapSpot.exe/decoded/dialogs.json` | DLGTEMPLATE "Unexpected Error Occurred", 320x236 DLU, 9 controls, font MS Sans Serif 8pt |
| DIALOG | IDD_CONFIRM_SAVE | 0409 | 820 | `62a2b61bad0bde8ad9c0f233a4efbcfc717b943dc3836e5408cb8ed511855d2d` | `ZapSpot.exe/raw/DIALOG/IDD_CONFIRM_SAVE_0409.bin` | `ZapSpot.exe/decoded/DIALOG/IDD_CONFIRM_SAVE_0409.rc`<br>`ZapSpot.exe/decoded/dialogs.json` | DLGTEMPLATE "Save to Desktop Requested", 207x90 DLU, 5 controls, font MS Sans Serif 8pt |
| DIALOG | IDD_INPUT_BOX | 0409 | 206 | `07e73e7bc61a9fcc536efece315bbc06fa3c4d96125f5218a80fd08ece5b49cc` | `ZapSpot.exe/raw/DIALOG/IDD_INPUT_BOX_0409.bin` | `ZapSpot.exe/decoded/DIALOG/IDD_INPUT_BOX_0409.rc`<br>`ZapSpot.exe/decoded/dialogs.json` | DLGTEMPLATE "Dialog", 167x61 DLU, 4 controls, font MS Sans Serif 8pt |
| DIALOG | IDD_INPUT_BOX2 | 0409 | 166 | `e4abfef22c787e91b809d0123e27f9936512ec602201f03604039aaa6560b620` | `ZapSpot.exe/raw/DIALOG/IDD_INPUT_BOX2_0409.bin` | `ZapSpot.exe/decoded/DIALOG/IDD_INPUT_BOX2_0409.rc`<br>`ZapSpot.exe/decoded/dialogs.json` | DLGTEMPLATE "Dialog", 167x61 DLU, 3 controls, font MS Sans Serif 8pt |
| DIALOG | IDD_QUIT_NOTSAVED | 0409 | 856 | `57b0447b5cb0415cbcab41335b1a8851812715d5d9e02a1b0664742337920ec9` | `ZapSpot.exe/raw/DIALOG/IDD_QUIT_NOTSAVED_0409.bin` | `ZapSpot.exe/decoded/DIALOG/IDD_QUIT_NOTSAVED_0409.rc`<br>`ZapSpot.exe/decoded/dialogs.json` | DLGTEMPLATE "Play Again Soon", 235x90 DLU, 6 controls, font MS Sans Serif 8pt |
| DIALOG | IDD_QUIT_SAVED | 0409 | 310 | `a07a7ffa431585675a2e86c2a84242be5981533bda15336899327bdcbbbeb3e7` | `ZapSpot.exe/raw/DIALOG/IDD_QUIT_SAVED_0409.bin` | `ZapSpot.exe/decoded/DIALOG/IDD_QUIT_SAVED_0409.rc`<br>`ZapSpot.exe/decoded/dialogs.json` | DLGTEMPLATE "Warning: Game in Progress", 198x50 DLU, 3 controls, font MS Sans Serif 8pt |
| DIALOG | IDD_TERMSOFSERVICE | 0409 | 1086 | `ee13cf7245dc80fea7b26b1ea94e0f05a9f56fa4b1b2a7db87a44eb88c65e7e9` | `ZapSpot.exe/raw/DIALOG/IDD_TERMSOFSERVICE_0409.bin` | `ZapSpot.exe/decoded/DIALOG/IDD_TERMSOFSERVICE_0409.rc`<br>`ZapSpot.exe/decoded/dialogs.json` | DLGTEMPLATEEX "ZapSpot Terms of Service and Privacy Policy", 279x170 DLU, 4 controls, font MS Sans Serif 8pt |
| STRING | 1 | 0409 | 88 | `06b06276c4237b884b5748281b31903ac17490ec573df70f94ddba1f86fcec45` | `ZapSpot.exe/raw/STRING/1_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 1 (ids 0-15): 2 defined strings |
| STRING | 7 | 0409 | 4828 | `5b22ff18671a9b342ca137716c0e2b8711f2ff0c86e0b56d2e3680df5869b624` | `ZapSpot.exe/raw/STRING/7_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 7 (ids 96-111): 3 defined strings |
| STRING | 8 | 0409 | 13898 | `cd41d6c71a9eccda1f8db149141e42f6567779e6d1c9d02824be8e9c3774a91e` | `ZapSpot.exe/raw/STRING/8_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 8 (ids 112-127): 7 defined strings |
| STRING | 63 | 0409 | 4844 | `4ab1e30bbd4c38339b5215296082fdef4e63202651f14a4ea0fc5585afd33f3b` | `ZapSpot.exe/raw/STRING/63_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 63 (ids 992-1007): 5 defined strings |
| STRING | 69 | 0409 | 1094 | `ee166050abe7ad716cf944583f9d05bbd1a65f603879eb99e87856c8c0e6e526` | `ZapSpot.exe/raw/STRING/69_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 69 (ids 1088-1103): 4 defined strings |
| STRING | 70 | 0409 | 382 | `22f9b7ad04735abc0cf70f2034168ee6e269e4e87ee73bad4a6cac1e86227fd5` | `ZapSpot.exe/raw/STRING/70_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 70 (ids 1104-1119): 5 defined strings |
| STRING | 76 | 0409 | 1082 | `4af9e2f593ba1ea7f98ff29c70f3f386c2fbe5dbda0b896c0ae9de23c1ccc3a7` | `ZapSpot.exe/raw/STRING/76_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 76 (ids 1200-1215): 10 defined strings |
| STRING | 126 | 0409 | 920 | `51465b167ef5b138e374f9ce389e1887403cade5cdd35acb3bf840d5db2c1d38` | `ZapSpot.exe/raw/STRING/126_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 126 (ids 2000-2015): 4 defined strings |
| STRING | 132 | 0409 | 982 | `d0748384e3279475aab30ce20ce3c10bc573f9cdffa946f9ed03b155d0d43488` | `ZapSpot.exe/raw/STRING/132_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 132 (ids 2096-2111): 2 defined strings |
| STRING | 138 | 0409 | 984 | `bda3143b7ee549bd262a7f862aebf4d6f8ab8e0b6b0ef541c9e8797b7e06dc49` | `ZapSpot.exe/raw/STRING/138_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 138 (ids 2192-2207): 6 defined strings |
| STRING | 144 | 0409 | 992 | `7066be442b0895b8f527dbe1722d5dd456381f1452781a6710010636e5d5fbae` | `ZapSpot.exe/raw/STRING/144_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 144 (ids 2288-2303): 4 defined strings |
| STRING | 145 | 0409 | 2964 | `4c130ae827e0ab2f654550f7bd71f8e79e730be6fe97c4bc62be8e08a992b39a` | `ZapSpot.exe/raw/STRING/145_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 145 (ids 2304-2319): 7 defined strings |
| STRING | 151 | 0409 | 54 | `14c5a6a3710a161be078544852a6cb366b70d85ef2d452f98dd2407c3e614a03` | `ZapSpot.exe/raw/STRING/151_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 151 (ids 2400-2415): 1 defined strings |
| STRING | 157 | 0409 | 178 | `b81440fa931284275c96bb6cd1c81c9f2a59d1c3dca9e3408ad5a2b5ca2d73a1` | `ZapSpot.exe/raw/STRING/157_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 157 (ids 2496-2511): 2 defined strings |
| STRING | 626 | 0409 | 992 | `b7e17d9e9bd0d271bf646430af45012dc289adadc3adfe7987997731bf304d70` | `ZapSpot.exe/raw/STRING/626_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 626 (ids 10000-10015): 15 defined strings |
| STRING | 627 | 0409 | 572 | `168640f89737a619e26ab9a53f0c25f50ac997aca216352960c851ae52d9de7d` | `ZapSpot.exe/raw/STRING/627_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 627 (ids 10016-10031): 4 defined strings |
| STRING | 1251 | 0409 | 928 | `38b079efc454824a5a17e86f4719a99d3fe1b478c36031908657b0f514a3e3b2` | `ZapSpot.exe/raw/STRING/1251_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 1251 (ids 20000-20015): 7 defined strings |
| STRING | 1876 | 0409 | 56 | `c23543537e6f8e9bbc405c44dfd0f73f88231323453a5ff0e733493b82748e36` | `ZapSpot.exe/raw/STRING/1876_0409.bin` | `ZapSpot.exe/decoded/strings.txt`<br>`ZapSpot.exe/decoded/strings.json` | String block 1876 (ids 30000-30015): 1 defined strings |
| RCDATA | ANI-ADBANNER1.GIF | 0409 | 5102 | `b97a1eec1314eecd174fd38dec4ae4e8defc8d35b1f7662cc7904299528038ed` | `ZapSpot.exe/raw/RCDATA/ANI-ADBANNER1_0409.gif` | `ZapSpot.exe/decoded/GIF/ANI-ADBANNER1_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 468x60, 6 frames, delay 20/50/300 cs, GCT 32, transparent idx 30, loop 0 |
| RCDATA | ANI-ADBANNER2.GIF | 0409 | 9864 | `ba5ab31506f95cd4e665175919e805b61cb4fa9722ce6655a4fc2cab428a20ee` | `ZapSpot.exe/raw/RCDATA/ANI-ADBANNER2_0409.gif` | `ZapSpot.exe/decoded/GIF/ANI-ADBANNER2_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 468x60, 4 frames, delay 50/75 cs, GCT 128, transparent idx 68, loop 1 |
| RCDATA | ANI-ADBANNER3.GIF | 0409 | 10371 | `e790363c69991356897840d731ac339f3d1ddd3d462ae03d97d8b5b0a2e8f56c` | `ZapSpot.exe/raw/RCDATA/ANI-ADBANNER3_0409.gif` | `ZapSpot.exe/decoded/GIF/ANI-ADBANNER3_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF87a 468x60, 16 frames, delay 8/40/80/112/264/272 cs, GCT 16, transparent idx 15, loop 0 |
| RCDATA | ANI-ADBANNER4.GIF | 0409 | 10030 | `d5cc32ff92047988c94180d329dd9bc860b0784157fcf387aacdee008c040628` | `ZapSpot.exe/raw/RCDATA/ANI-ADBANNER4_0409.gif` | `ZapSpot.exe/decoded/GIF/ANI-ADBANNER4_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 468x60, 3 frames, delay 20/50 cs, GCT 32, loop 2 |
| RCDATA | ANI-ADBANNER5.GIF | 0409 | 12800 | `d808f518235664146c29429c64d90232e888cffbc4a3a221a87b8be74f334686` | `ZapSpot.exe/raw/RCDATA/ANI-ADBANNER5_0409.gif` | `ZapSpot.exe/decoded/GIF/ANI-ADBANNER5_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 468x60, 8 frames, delay 10/70/300 cs, GCT 128, loop 0 |
| RCDATA | BTNCLICK.WAV | 0409 | 718 | `5d5b0281e6a5915c7d8160ee1d0997ec9f62f07f2d2f78fc2a6b1c8462f6ed48` | `ZapSpot.exe/raw/RCDATA/BTNCLICK_0409.wav` | `ZapSpot.exe/decoded/wavs.json` | WAV PCM 11025 Hz 8-bit mono, 480 data bytes, 0.044 s, chunks: cue LIST fact |
| RCDATA | CLOSESHELL.WAV | 0409 | 10446 | `cfc9f7c516ad9bc1024733f5e2926c4982d4461f61c49b103d3c7cee6fbe6831` | `ZapSpot.exe/raw/RCDATA/CLOSESHELL_0409.wav` | `ZapSpot.exe/decoded/wavs.json` | WAV PCM 11025 Hz 8-bit mono, 10401 data bytes, 0.943 s |
| RCDATA | GETZAPPED.GIF | 0409 | 8825 | `dbed0e91011a17ec221757fef0224e7e8816eed655fce7a0962eac46661e242a` | `ZapSpot.exe/raw/RCDATA/GETZAPPED_0409.gif` | `ZapSpot.exe/decoded/GIF/GETZAPPED_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 468x60, 4 frames, delay 200/400 cs, GCT 64, loop 0 |
| RCDATA | IMG-ERR-ARROW.GIF | 0409 | 149 | `4e4fdc7442e30e113783d0f56fb4c4b807c523abf5d58514370ed6903bb1eb2b` | `ZapSpot.exe/raw/RCDATA/IMG-ERR-ARROW_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-ERR-ARROW_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 20x20, 1 frame, GCT 8 |
| RCDATA | IMG-ERR-BLUE.GIF | 0409 | 737 | `77523ffcf8d79525643b8042c45f43f8dc288f3a0face2a6b68caa795c388ecc` | `ZapSpot.exe/raw/RCDATA/IMG-ERR-BLUE_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-ERR-BLUE_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 91x69, 1 frame, GCT 32, transparent idx 31 |
| RCDATA | IMG-ERR-GREEN.GIF | 0409 | 739 | `7b634a7a09b33755062335eabfabcf803e535f43dec1cdd0586e6ed4ae4e79fb` | `ZapSpot.exe/raw/RCDATA/IMG-ERR-GREEN_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-ERR-GREEN_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 91x69, 1 frame, GCT 32, transparent idx 31 |
| RCDATA | IMG-ERR-RED.GIF | 0409 | 741 | `ab9d42076c65fec38d46d984f9d1b2cbbe0a604cd2f9271d19d0b2d025f4a859` | `ZapSpot.exe/raw/RCDATA/IMG-ERR-RED_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-ERR-RED_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 91x69, 1 frame, GCT 32, transparent idx 31 |
| RCDATA | IMG-GAMEAREA.GIF | 0409 | 6087 | `c87120ecd58463391d21902b551d76747cd27ca2897952a7728187fbe283c71a` | `ZapSpot.exe/raw/RCDATA/IMG-GAMEAREA_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-GAMEAREA_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 603x468, 1 frame, GCT 64, transparent idx 35, interlaced |
| RCDATA | IMG-GETZAPPEDBLOCK.GIF | 0409 | 1132 | `09e23a6732a288a28a6909bf74e267df44071304ca8fd3b2970c78559e2a0599` | `ZapSpot.exe/raw/RCDATA/IMG-GETZAPPEDBLOCK_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-GETZAPPEDBLOCK_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 220x164, 1 frame, GCT 16, transparent idx 15 |
| RCDATA | IMG-HOME.GIF | 0409 | 252 | `999cbfdc6f99f5d93776b502d0a0997170b90fd4e6c40cdcebaea783f07b621d` | `ZapSpot.exe/raw/RCDATA/IMG-HOME_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-HOME_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 27x21, 1 frame, GCT 16, transparent idx 15 |
| RCDATA | IMG-HOME2.GIF | 0409 | 246 | `fd3f306bea042e132e11bad206b9d5826e522b72916a232c80d3f73ec223a8fd` | `ZapSpot.exe/raw/RCDATA/IMG-HOME2_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-HOME2_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 27x21, 1 frame, GCT 16, transparent idx 15 |
| RCDATA | IMG-LOGO-88X82.GIF | 0409 | 1675 | `b2e53592d282e2d4f34e79da2167964042151e9963d9d6a0db5d9f33d7d97d37` | `ZapSpot.exe/raw/RCDATA/IMG-LOGO-88X82_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-LOGO-88X82_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 88x82, 1 frame, GCT 16 |
| RCDATA | IMG-MCAFEE.GIF | 0409 | 985 | `f65e7def03d61b44008e9e11c682182e5bb1d7b43e4300d3ed10fb71b6961deb` | `ZapSpot.exe/raw/RCDATA/IMG-MCAFEE_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-MCAFEE_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 100x50, 1 frame, GCT 16 |
| RCDATA | IMG-PREVGAMELOGO-BUBBLEBOUND.GIF | 0409 | 1626 | `30bd0454e688f7e4cfbb39584ca0c0d3eb4097ae671fd4c54f10a92f71688c01` | `ZapSpot.exe/raw/RCDATA/IMG-PREVGAMELOGO-BUBBLEBOUND_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-PREVGAMELOGO-BUBBLEBOUND_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 80x60, 1 frame, GCT 32 |
| RCDATA | IMG-PREVGAMELOGO-COLORBREAK.GIF | 0409 | 2187 | `b2f371edb04ea4fc0e900760e308facffa23f7b8ce22c4b656358e3961ec3214` | `ZapSpot.exe/raw/RCDATA/IMG-PREVGAMELOGO-COLORBREAK_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-PREVGAMELOGO-COLORBREAK_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 80x60, 1 frame, GCT 64 |
| RCDATA | IMG-PREVGAMELOGO-COLORCODE.GIF | 0409 | 2853 | `1d712efbc2fff9888689881b726f8a4176bb879ba2d80932a8d5113ec247a755` | `ZapSpot.exe/raw/RCDATA/IMG-PREVGAMELOGO-COLORCODE_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-PREVGAMELOGO-COLORCODE_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 80x60, 1 frame, GCT 128 |
| RCDATA | IMG-PREVGAMELOGO-FENCEOUT.GIF | 0409 | 2284 | `61c4213c44b1effd82c2064be4e9dcacdb994ef737e7d27f1a9d5c0e4c67a872` | `ZapSpot.exe/raw/RCDATA/IMG-PREVGAMELOGO-FENCEOUT_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-PREVGAMELOGO-FENCEOUT_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 80x60, 1 frame, GCT 128 |
| RCDATA | IMG-PREVGAMELOGO-PEHPAI.GIF | 0409 | 1736 | `9c616bdc646c38948f03dfa6a923e78cc16cf66149132415703f09d81fc10ef4` | `ZapSpot.exe/raw/RCDATA/IMG-PREVGAMELOGO-PEHPAI_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-PREVGAMELOGO-PEHPAI_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 80x60, 1 frame, GCT 16 |
| RCDATA | IMG-PREVGAMELOGO-SORTSPORT.GIF | 0409 | 1657 | `bf9799d188a9b2610aad40e8f5e5fc3ef03c76de3e75e6e5bb79012358f8b423` | `ZapSpot.exe/raw/RCDATA/IMG-PREVGAMELOGO-SORTSPORT_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-PREVGAMELOGO-SORTSPORT_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 80x60, 1 frame, GCT 32 |
| RCDATA | IMG-TM.GIF | 0409 | 818 | `88881f47cdcd5d8e906e74f51d0f10652eb87e20b7a80db9c578eb5743cc41dd` | `ZapSpot.exe/raw/RCDATA/IMG-TM_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-TM_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 7x3, 1 frame, GCT 256, transparent idx 0 |
| RCDATA | IMG-TM2.GIF | 0409 | 818 | `c82fcfe217258c4156f4673c1112a68285bdb59ad08fdc99a6235b0053e45d20` | `ZapSpot.exe/raw/RCDATA/IMG-TM2_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-TM2_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 7x3, 1 frame, GCT 256, transparent idx 249 |
| RCDATA | IMG-VERISIGN.GIF | 0409 | 834 | `61634c1d31cf504a2a1ecfe54ec1f9ea460f0bfba4231b7ee731ded8c93bb799` | `ZapSpot.exe/raw/RCDATA/IMG-VERISIGN_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-VERISIGN_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 100x42, 1 frame, GCT 16 |
| RCDATA | IMG-ZAPLOGO.GIF | 0409 | 2002 | `ec6a1be6626921ca3986ae2a9483259be796be4bb8061c7502d4fc066e5c9a0b` | `ZapSpot.exe/raw/RCDATA/IMG-ZAPLOGO_0409.gif` | `ZapSpot.exe/decoded/GIF/IMG-ZAPLOGO_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 175x135, 1 frame, GCT 16, transparent idx 15 |
| RCDATA | MCAFEE.GIF | 0409 | 12408 | `4a84e6db4a3807b30fc22c521dc387096b3bb0de8070d0c344ae7abd746e5960` | `ZapSpot.exe/raw/RCDATA/MCAFEE_0409.gif` | `ZapSpot.exe/decoded/GIF/MCAFEE_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 468x60, 11 frames, delay 50/100/150/200 cs, GCT 16, transparent idx 15, loop 0 |
| RCDATA | OPENSHELL.WAV | 0409 | 31907 | `b04f92775e3500376634f3f2ba51c4b865cbb1a7f185571aeffcd8c9080d60dd` | `ZapSpot.exe/raw/RCDATA/OPENSHELL_0409.wav` | `ZapSpot.exe/decoded/wavs.json` | WAV PCM 11025 Hz 8-bit mono, 31863 data bytes, 2.890 s |
| RCDATA | POPUP.WAV | 0409 | 1748 | `b3251979b2965d22b67c2a06901582353abac690ddce2b8e3c06aa625193d807` | `ZapSpot.exe/raw/RCDATA/POPUP_0409.wav` | `ZapSpot.exe/decoded/wavs.json` | WAV PCM 11025 Hz 8-bit mono, 1692 data bytes, 0.153 s, chunks: fact |
| RCDATA | SLB-BEVELEDGES.GIF | 0409 | 100 | `2946dd3b173f5db61595b53602e58bfcb626515c071f8138fa9ecaa396cd428a` | `ZapSpot.exe/raw/RCDATA/SLB-BEVELEDGES_0409.gif` | `ZapSpot.exe/decoded/GIF/SLB-BEVELEDGES_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 40x5, 1 frame, GCT 4 |
| RCDATA | SLB-BIGBTNBACKS-HC.GIF | 0409 | 4855 | `d76832d0821d8f2db156e3f5399ac191713e7e20d14b1e1ea3647e83bd9125f3` | `ZapSpot.exe/raw/RCDATA/SLB-BIGBTNBACKS-HC_0409.gif` | `ZapSpot.exe/decoded/GIF/SLB-BIGBTNBACKS-HC_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 184x46, 1 frame, GCT 128, transparent idx 127 |
| RCDATA | SLB-BIGBTNICONS.GIF | 0409 | 942 | `10e98ab9b56df9297474b201284b22a00aa62bf90b790d6d545b775e8f714d16` | `ZapSpot.exe/raw/RCDATA/SLB-BIGBTNICONS_0409.gif` | `ZapSpot.exe/decoded/GIF/SLB-BIGBTNICONS_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 230x46, 1 frame, GCT 16, transparent idx 8 |
| RCDATA | SLB-LILBTNBACKS-HC.GIF | 0409 | 2146 | `6fd68635b2c61904c2a007d5f325fb2823a4d906324229869f93ba00c2f7d0a6` | `ZapSpot.exe/raw/RCDATA/SLB-LILBTNBACKS-HC_0409.gif` | `ZapSpot.exe/decoded/GIF/SLB-LILBTNBACKS-HC_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 104x26, 1 frame, GCT 128, transparent idx 127 |
| RCDATA | SLB-LILBTNICONS.GIF | 0409 | 398 | `b9899c34edc398e160a55ed48fb09f5a0d793b15d336a6ce4257090275429a07` | `ZapSpot.exe/raw/RCDATA/SLB-LILBTNICONS_0409.gif` | `ZapSpot.exe/decoded/GIF/SLB-LILBTNICONS_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 130x26, 1 frame, GCT 8, transparent idx 6 |
| RCDATA | SLB-RECTBTNBACKS-HC.GIF | 0409 | 5607 | `b7837775d824a57b955baf10989e46855e7b6f16c25c91b2a1d679d646b2934a` | `ZapSpot.exe/raw/RCDATA/SLB-RECTBTNBACKS-HC_0409.gif` | `ZapSpot.exe/decoded/GIF/SLB-RECTBTNBACKS-HC_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 352x32, 1 frame, GCT 256, transparent idx 255 |
| RCDATA | TERMSOFSERVICE | 0409 | 15418 | `857f291744c6f631aff178e5f781eea53d65e2976d6ea70de4c0e7a81259c02b` | `ZapSpot.exe/raw/RCDATA/TERMSOFSERVICE_0409.txt` | `ZapSpot.exe/decoded/RCDATA/TERMSOFSERVICE_0409.utf8.txt` | Plain text (ASCII/cp1252), 106 lines, NUL bytes: 1, first line 'ZAPSPOT LEGAL STUFF AND PRIVACY POLICY' |
| RCDATA | TXT-COMINGSOON-LOGO.GIF | 0409 | 1116 | `96ec1b579caec680587cd6dd0ff4a8951ee860011ccb047d980a4a66ed5be7ff` | `ZapSpot.exe/raw/RCDATA/TXT-COMINGSOON-LOGO_0409.gif` | `ZapSpot.exe/decoded/GIF/TXT-COMINGSOON-LOGO_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 80x60, 1 frame, GCT 16 |
| RCDATA | ZAPFRIEND.GIF | 0409 | 8476 | `4cff07b49a21384f8baf8846cc65a811fdf10c74b41083345a654ec0e0eee1ab` | `ZapSpot.exe/raw/RCDATA/ZAPFRIEND_0409.gif` | `ZapSpot.exe/decoded/GIF/ZAPFRIEND_0409/`<br>`ZapSpot.exe/decoded/gifs.json` | GIF89a 468x60, 3 frames, delay 250/500 cs, GCT 64, loop 0 |
| GROUP_CURSOR | CLOSEDHAND.CUR | 0409 | 20 | `a0adcedb82b57089f64e2857f97cefd6cf25f4d27eefc6648bda83fd5fef66bb` | `ZapSpot.exe/raw/GROUP_CURSOR/CLOSEDHAND.CUR_0409.bin` | `ZapSpot.exe/decoded/CURSOR/CLOSEDHAND_0409.cur`<br>`ZapSpot.exe/decoded/CURSOR/CLOSEDHAND_0409_32x32x1.png`<br>`ZapSpot.exe/decoded/CURSOR/CLOSEDHAND_0409.json` | Cursor group: id 5 32x32 1 bpp hotspot (15,17) |
| GROUP_CURSOR | HAND.CUR | 0409 | 20 | `b07e022f8ef0a8e5fd3f56986b2e5bf06df07054e9ea9177996b0a6c27d74d7c` | `ZapSpot.exe/raw/GROUP_CURSOR/HAND.CUR_0409.bin` | `ZapSpot.exe/decoded/CURSOR/HAND_0409.cur`<br>`ZapSpot.exe/decoded/CURSOR/HAND_0409_32x32x1.png`<br>`ZapSpot.exe/decoded/CURSOR/HAND_0409.json` | Cursor group: id 2 32x32 1 bpp hotspot (12,6) |
| GROUP_CURSOR | HOURGLASS.CUR | 0409 | 20 | `6e1e7738a1b6373d8829f817915822ef415a1727bb5bb7cfe809e31b3c143ac5` | `ZapSpot.exe/raw/GROUP_CURSOR/HOURGLASS.CUR_0409.bin` | `ZapSpot.exe/decoded/CURSOR/HOURGLASS_0409.cur`<br>`ZapSpot.exe/decoded/CURSOR/HOURGLASS_0409_32x32x1.png`<br>`ZapSpot.exe/decoded/CURSOR/HOURGLASS_0409.json` | Cursor group: id 6 32x32 1 bpp hotspot (16,15) |
| GROUP_CURSOR | NOLINK.CUR | 0409 | 20 | `43f40dd5140804309a4c901ec3c85b54481316e67a6fe18beb9d5c0ce3a42c3a` | `ZapSpot.exe/raw/GROUP_CURSOR/NOLINK.CUR_0409.bin` | `ZapSpot.exe/decoded/CURSOR/NOLINK_0409.cur`<br>`ZapSpot.exe/decoded/CURSOR/NOLINK_0409_32x32x1.png`<br>`ZapSpot.exe/decoded/CURSOR/NOLINK_0409.json` | Cursor group: id 3 32x32 1 bpp hotspot (16,15) |
| GROUP_CURSOR | OPENHAND.CUR | 0409 | 20 | `ff47a48c11c234903a7d625cb8b62101909f735ad84266c98dd4834549452c39` | `ZapSpot.exe/raw/GROUP_CURSOR/OPENHAND.CUR_0409.bin` | `ZapSpot.exe/decoded/CURSOR/OPENHAND_0409.cur`<br>`ZapSpot.exe/decoded/CURSOR/OPENHAND_0409_32x32x1.png`<br>`ZapSpot.exe/decoded/CURSOR/OPENHAND_0409.json` | Cursor group: id 4 32x32 1 bpp hotspot (15,17) |
| GROUP_CURSOR | POINTER.CUR | 0409 | 20 | `c53efa8085835ba129c1909beaff8a67b45f50837707f22dfff0f24d8cd26710` | `ZapSpot.exe/raw/GROUP_CURSOR/POINTER.CUR_0409.bin` | `ZapSpot.exe/decoded/CURSOR/POINTER_0409.cur`<br>`ZapSpot.exe/decoded/CURSOR/POINTER_0409_32x32x1.png`<br>`ZapSpot.exe/decoded/CURSOR/POINTER_0409.json` | Cursor group: id 1 32x32 1 bpp hotspot (13,7) |
| GROUP_ICON | ZAPICON | 0409 | 34 | `7b7cc020e1888740524df4831d80184a709a3cf52ed76335cb247253157f6e60` | `ZapSpot.exe/raw/GROUP_ICON/ZAPICON_0409.bin` | `ZapSpot.exe/decoded/ICON/ZAPICON_0409.ico`<br>`ZapSpot.exe/decoded/ICON/ZAPICON_0409_32x32x4.png`<br>`ZapSpot.exe/decoded/ICON/ZAPICON_0409_16x16x4.png` (+1) | Icon group: id 7 32x32 4 bpp, id 8 16x16 4 bpp |

## moeboid.exe

Source: `moeboid.exe`, 520672 bytes. .rsrc section at file offset 0xA000, raw size 4096.

| Type | Name/ID | Lang | Size | SHA-256 | Raw path | Decoded path | Description |
|---|---|---|---|---|---|---|---|
| ICON | 1 | 0409 | 744 | `628352fdd8a8d0e1d74f4371a16b1ae299a6ad7f63ed9410f145a07b9ee3c589` | `moeboid.exe/raw/ICON/1_0409.bin` | - | Icon image 32x32, 4 bpp; see group |
| ICON | 2 | 0409 | 296 | `8a18c0ffbff11d39251d0925b1601c0e62d6224212c8a0bb470136247085b0cd` | `moeboid.exe/raw/ICON/2_0409.bin` | - | Icon image 16x16, 4 bpp; see group |
| GROUP_ICON | BOOT2.ICO | 0409 | 34 | `b10e28a32eddb2ab20a46ceae59d9c0786911eb20f0c8dd2a28421f226ea2b8b` | `moeboid.exe/raw/GROUP_ICON/BOOT2.ICO_0409.bin` | `moeboid.exe/decoded/ICON/BOOT2_0409.ico`<br>`moeboid.exe/decoded/ICON/BOOT2_0409_32x32x4.png`<br>`moeboid.exe/decoded/ICON/BOOT2_0409_16x16x4.png` (+1) | Icon group: id 1 32x32 4 bpp, id 2 16x16 4 bpp |

