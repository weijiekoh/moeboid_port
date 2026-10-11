# Font sources

| File | SHA-256 | Source | Notes |
|---|---|---|---|
| `sserife.fon` | `28877eee4ccda2a33e0fac39da7f3effdea061e4fd9cc019f00d82405b9f9682` | https://github.com/chyyuu/msfonts/raw/refs/heads/master/sserife.fon (third-party repo, 2018; Windows version of origin unknown) | MS Sans Serif, Western (charset 0, cp1252). 6 strikes: 13, 16, 20, 24, 29, 37 px. Font used by English Windows dialogs. |

Glyph comparison against the Central European variant `sserifee.fon` (charset 238, sha256 b99ad27d..., deleted 2026-10-11, not needed): ASCII 0x20-0x7E identical at 13, 24, 29, 37 px; differs at 16 px (`" # / \`) and at 20 px (almost all glyphs). 0x80-0xFF differs at 71-127 codes per size.

## Arial 2.82 (workstream E, 2026-10-11)

| File | SHA-256 | Source | Notes |
|---|---|---|---|
| `Arial.TTF` | `35c0f3559d8db569e36c31095b8a60d441643d95f59139de40e23fada819b833` | https://sourceforge.net/projects/corefonts/files/the%20fonts/final/arial32.exe/download (Microsoft Core fonts for the Web, corefonts SourceForge project). Package `arial32.exe`: 554208 bytes, MD5 `9637df0e91703179f0723ec095a36cb5` = MD5 published in the SourceForge file list (verified 2026-10-11), SHA-256 `85297a4d146e9c87ac6f74822734bdee5f4b2a722d7eaa584b7f2cbf76f478f6`. Extracted copy kept in `tools/dl/fonts/corefonts-arial32/x/`. | Arial Regular, name ID 5 "Version 2.82", head.fontRevision 2.82 (the version of Windows 2000/XP). 275572 bytes, file date 2000-05-11. Used for engine and game text (regular). |
| `Arialbd.TTF` | `4044aa6b5bebbc36980206b45b0aaaaa5681552a48bcadb41746d5d1d71fd7b4` | Same package as `Arial.TTF`. | Arial Bold, name ID 5 "Version 2.82". 286620 bytes. Used for bold ZML text and engine buttons. Ariali.TTF (sha256 `70ade233...`) and Arialbi.TTF (sha256 `2f371cd9...`), same package and version, are not copied: no kept text uses italic (see `analysis/fonts.md`). |

## Tahoma and Trebuchet MS Bold (user-directed source, 2026-10-11)

Source repository: https://github.com/pjobson/Microsoft-Fonts (third-party collection, files gzip-compressed, file names carry the MD5 of the font; all MD5 values verified). The repository has no retail Windows XP folder. Chosen folder: `2005 - Windows Server 2003 R2/ttf/` (NT 5.x family, same generation as Windows XP SP2/SP3). Whether retail XP shipped exactly these versions is **unverified**.

| File | SHA-256 | Repository path | Version | Notes |
|---|---|---|---|---|
| `tahoma.ttf` | `08f45bf539954d3252df97a2ae563362ed2ad5ebe05f2d1f2bc54b931e4d0550` | `2005 - Windows Server 2003 R2/ttf/Tahoma - b49845f7bdc0be0a93c24345546b686d.ttf.gz` | Version 3.15, head.modified 2004-09-20, 2036 glyphs | Same file in the `2002 - Windows XP Media Center Edition` folder. XP MessageBox text (Tahoma 8 pt). |
| `tahomabd.ttf` | `4ba89e145ff39f208151ce269841899fc4e4a360189a4a31dc2359168dae27d0` | `2005 - Windows Server 2003 R2/ttf/Tahoma Bold - f415c9e76c9b5b2b805b0acf3d7d13b3.ttf.gz` | Version 3.15, 2004-09-20 | Same file in the XP Media Center folder. |
| `trebucbd.ttf` | `73150ef5306b3651eac743ad570bc956c2ca41f5564e8700c8ae83928827441e` | `2005 - Windows Server 2003 R2/ttf/Trebuchet MS Bold - 6cbec14f7ae96def20259b23fb722619.ttf.gz` | Version 1.22, 2001-02-26 | XP Luna caption font. The XP Media Center folder has version 5.00 (2006, Vista/7 era) instead; its ASCII glyphs, metrics and hinting programs are identical to 1.22 (fontTools comparison). |

Version sensitivity (fontTools comparison of ASCII glyph data, including per-glyph hinting instructions): Tahoma 3.15 differs from Tahoma 2.95 (Whistler beta, 2000-12) in 64 ASCII glyphs and from Tahoma 2.80 (Windows 2000) in 71; the font-level hinting programs differ too. Tahoma Bold 3.15 equals 2.95 in ASCII glyph data but its font-level programs differ. Trebuchet MS Bold 1.22 differs from 1.20 (Whistler) in 7 ASCII glyphs. So the exact XP version matters for pixels; 3.15 is the newest XP-generation version.

`luna.msstyles` is not in this repository; still missing.

## luna.msstyles (user-supplied, 2026-10-11)

| File | SHA-256 | Source | Notes |
|---|---|---|---|
| `luna.msstyles` | `dd8e86e5a7c19ea9fe0e34992babefe592055d68eb8659763c8300558ca5dcb4` | Downloaded by the user into `XP Luna Theme/Luna/luna.msstyles` (download URL not recorded). | 4190352 bytes. Resource-only PE (no code, no imports, entry point 0), image base 0x10000000, PE timestamp 2008-04-13 17:02:25 UTC (Windows XP SP3 build date). Version info: CompanyName "Microsoft", FileDescription "luna Theme for Windows", OriginalFilename "luna.mst", LegalCopyright "Copyright © 2000". XP visual-style format: TEXTFILE (10 INI resources incl. THEMES_INI, NORMALBLUE_INI), 558 RT_BITMAP (BLUE_*_BMP etc.), COLORNAMES, SIZENAMES, FILERESNAMES, ORIGFILENAMES, MINDEPTH, PACKTHEM_VERSION. 144-byte overlay after the image (inferred: the XP theme signature block). NORMALBLUE_INI [SysMetrics]: CaptionFont = Trebuchet MS, 10, bold; CaptionBarHeight = 25; SmallCaptionFont = Tahoma, 8, bold; MsgBoxFont = Tahoma, 8. Inferred genuine XP SP3 file; not verified against a Microsoft hash. |

Rejected candidate: `https://github.com/pazuzu156/KalebKlein/raw/refs/heads/master/Windows%20XP%20Theme%20Installer/Themes/Luna/Luna.msstyles` (sha256 `fc76fbb0...`): version info "AveStyle DLL", Andreas Verhoeven, 2008; Vista/7 visual-style format (VARIANT, VMAP, RMAP, BCMAP, IMAGE, STREAM). A third-party Luna recreation for Vista/7, not the XP file.
