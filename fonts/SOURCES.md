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
