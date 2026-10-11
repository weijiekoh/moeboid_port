# Xvfb: source and verification

Package: `xorg-server-xvfb` 21.1.25-1, x86_64 (same version as the installed `xorg-server` 21.1.25-1 and `xorg-server-common` 21.1.25-1). Date: 2026-10-11. Unpacked here as is (`usr/bin/Xvfb`, `usr/bin/xvfb-run`, man pages, licence, `.PKGINFO`, `.BUILDINFO`, `.MTREE`). No system install, no `sudo`, no `pacman -S`.

## Download

| File | URL | Bytes | SHA-256 |
|---|---|---|---|
| `xorg-server-xvfb-21.1.25-1-x86_64.pkg.tar.zst` | https://mirror.givebytes.net/archlinux/extra/os/x86_64/xorg-server-xvfb-21.1.25-1-x86_64.pkg.tar.zst | 873559 | `c6bfb4dff25df8eabab71e64b2fb4a16348c3a786cce8305f1af2602478e2813` |
| `xorg-server-xvfb-21.1.25-1-x86_64.pkg.tar.zst.sig` | same URL + `.sig` | 310 | `409772f61ff77c12690c7f81f9584ffe2f70e0b7cd5553bf1b8f11bc2ba04b82` |

Mirror from `/etc/pacman.d/mirrorlist`, HTTPS only (`curl --proto =https`). The first mirror in the list (`https://mirrors.vectair.net/archlinux`) returned HTTP 503; nothing was used from it.

## Verification

1. Sync database entry. `/var/lib/pacman/sync/extra.db` (read only), member `xorg-server-xvfb-21.1.25-1/desc`: `%SHA256SUM%` = `c6bfb4dff25df8eabab71e64b2fb4a16348c3a786cce8305f1af2602478e2813` = SHA-256 of the download. `%CSIZE%` 873559 = file size. Result: match.
   Note: the local sync database has no detached signature (`extra.db.sig` absent; `pacman.conf`: `SigLevel = Required DatabaseOptional`). So step 2 is the authoritative check.
2. OpenPGP signature. The `%PGPSIG%` field of the same entry (base64) decodes byte for byte to the downloaded `.sig`. Command (keyring copied to scratch, `/etc/pacman.d/gnupg` not written):
   `gpg --homedir <scratch copy of /etc/pacman.d/gnupg/{pubring.gpg,trustdb.gpg}> --no-autostart --batch --verify <pkg>.sig <pkg>`
   Result: `GOODSIG 94657AB20F2A092B Andreas Radke <andyrtr@archlinux.org>`, `VALIDSIG ADC8A1FCC15E01D45310419E94657AB20F2A092B`, signature date 2026-10-07, `TRUST_FULLY` (Arch packager key, trusted through the pacman master keys). Keyring file: `pubring.gpg` SHA-256 `9d69ab2fb5582529dacb64a06b4bdd653993df26ec186bb37429c8370b9547b6`.
3. Unpacked files. `tar -xf` into this directory (`--no-same-owner`). Every file digest equals its `sha256digest` in `.MTREE`:
   `usr/bin/Xvfb` `69817e2f457a3e86d31f2ebb44a8fa841af7b9645e55c669022569c29048326f`, `usr/bin/xvfb-run` `27ce50f4432e5549e662db857118761fa9cd74c6900aac52c4db768c956838db`, `COPYING` `c9f90a66...`, `Xvfb.1.gz` `f6ff7d29...`, `xvfb-run.1.gz` `b34b94b2...`.

## Shared libraries

`ldd usr/bin/Xvfb`: no library missing. All come from installed system packages (`libxfont2` 2.0.9, `libunwind` 1.8.3, `pixman` 0.46.4, `libglvnd` 1.7.0, `nettle` 4.0, `libtirpc` 1.3.8, `systemd-libs` 262, `libxdmcp` 1.1.5, `libxau` 1.0.12 and their dependencies). No further download.

Run-time data from the system: `/usr/share/X11/xkb` (`xkeyboard-config` 2.48), `/usr/bin/xkbcomp` (`xorg-xkbcomp` 1.5.0), `/usr/lib/xorg/protocol.txt` (`xorg-server-common`). Xvfb prints xkbcomp warnings (`Symbol map for key <FK23> redefined`); they are not fatal.

## Use

Do not start `Xvfb` directly. Use `tools/bin/xvfb-run-wine` (see `tools/INFRA.md`).
