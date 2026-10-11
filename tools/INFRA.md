# Test infrastructure (phase 2)

Date: 2026-10-11. Tags: **[V]** verified (run, file or trace given); **[I]** inferred.

Rules (`docs/port-design.md` section 10): run the original only through `tools/bin/nonet` and only on a hidden Xvfb display. Never use or capture `:0`. Run browser tests headless inside `nonet`. Source `tools/env.sh` first.

## 1. Hidden X display: `tools/bin/xvfb-run-wine`

    tools/bin/xvfb-run-wine [-d N] [-f FILE] [--] CMD [ARGS...]

- Re-executes itself inside `tools/bin/nonet` and refuses to run if the network namespace has an interface other than `lo`.
- Starts `tools/xvfb/usr/bin/Xvfb :N -nolisten tcp -noreset -screen 0 1024x768x24` on the first free display from `:90` (no `/tmp/.XN-lock`, no `/tmp/.X11-unix/XN`). `-d N` selects `:N` (N >= 90 only). `XVFB_SCREEN` changes the geometry. Log: `tools/home/tmp/xvfbN.log`.
- Waits until `xdpyinfo -display :N` connects (max 10 s), then runs CMD with `DISPLAY=:N`; `WAYLAND_DISPLAY` and `XAUTHORITY` are unset. `-f FILE` receives `:N` when the server is ready and is removed at the end.
- After CMD: waits max 10 s for the wineserver of `$WINEPREFIX`, then stops Xvfb (SIGTERM; Xvfb removes its lock and socket). Exit status = CMD status; 125 = setup error.
- Socket reachability [V: tests 2026-10-11]: a client in the same `nonet` tree connects (abstract socket); a client outside (host namespace) connects through the file socket `/tmp/.X11-unix/XN`. So helper tools (`xhelper.py`, `import`) work without `nonet`.
- Access control: no `-auth` cookie. Any local process of any user can connect to `:N` while it runs [I: X server default for local connections]. Acceptable on this single-user machine.
- Xvfb origin and verification: `tools/xvfb/SOURCE.md`.

## 2. Wine reference runs: `analysis/reference/run_original.sh`

    source tools/env.sh
    R=analysis/reference/run_original.sh
    FONT_SMOOTHING=off $R start 60      # new hidden display, setup, engine; auto-kill after 60 s
    $R display                          # prints :N
    $R shot /path/frame.png             # 800x572 frame (import -display :N -window <frame id>)
    $R desk /path/desk.png              # 1024x768 hidden screen = Wine virtual desktop
    $R click 563 253; $R key space; $R type tester
    $R x python -I -B analysis/reference/capture_session.py OUTDIR STEPFILE
    $R stop                             # wineserver -k; Xvfb stops; state file removed
    pgrep -a 'Xvfb|wine|\.exe'          # must print nothing

- `start` runs `xvfb-run-wine -f tools/home/tmp/original.display bash run_original.sh _session SECS` in the background. The session runs setup, then `timeout -s KILL SECS wine cmd /c C:\Moeboid\run.bat`, then `wineserver -k`. Xvfb stops when the session ends.
- `setup` alone runs inside its own short `xvfb-run-wine` call. Every `wine` and `wineserver` call of the script runs inside `nonet`.
- The script unsets `DISPLAY`, `WAYLAND_DISPLAY`, `XAUTHORITY` at the start. It sets `DISPLAY` only from the state file, and only to `:90`..`:189`. The script never sets `:0` [V: `grep -n ':0' run_original.sh` finds only the comment "Never :0"].
- `x CMD`: runs a helper (not an original binary) with `DISPLAY` = hidden display. `capture_session.py` and `bot_avoid.py` call `import -window` without `-display`; they take `DISPLAY` from this mode.
- Environment: `RUN_WINEDEBUG`, `RELAY_INCLUDE`, `LOG` (as before), `FONT_SMOOTHING` (section 3), `WINE_D3D_CONFIG` (default `renderer=no3d`).
- One session at a time (one prefix). `start` refuses while a session runs.

### Renderer on Xvfb [V]
With the default wined3d OpenGL renderer on Xvfb, the frame shows only its lowest clip rectangle (frame y >= 462, the ad banner area); the upper 800x462 area stays black. `LIBGL_ALWAYS_SOFTWARE=1` does not help. With `WINE_D3D_CONFIG=renderer=no3d` (CPU blits, GDI present) the whole frame shows. The script sets `renderer=no3d` by default.
Check against the earlier GL captures on `:0`: a no3d title frame differs from `screens/frame_title_installed_after_highscore.png` only in text (new fonts), the animated title sprites and the ad banner; all other pixels are equal [V: pixel diff, 2026-10-11].

### Acceptance test of the hidden display [V: 2026-10-11]
- `run_original.sh start 60`, wait 20 s, `shot` (800x572 title frame), `stop`.
- During the run, a read-only watcher selected `SubstructureNotify` on the `:0` root window (python-xlib, no capture). It saw only host desktop windows (baloo, Firefox); no Wine, ZapSpot or Moeboid window. The `:0` window list before and after showed no Wine window.
- After `stop`: `pgrep 'Xvfb|wine|\.exe'` = 0 processes; `/tmp/.X11-unix` holds only `X0`; no `/tmp/.X9*-lock`.

## 3. Reference fonts and font smoothing in Wine

Setup copies `fonts/Arial.TTF`, `fonts/Arialbd.TTF`, `fonts/sserife.fon` to `C:\windows\Fonts` of the prefix (`install -C -m 0644`; `fonts/` is not changed). Wine 11.19 then uses [V: `WINEDEBUG=+font`, lines `select_font Chosen:` and `insert_face_in_family_list`, run 2026-10-11]:

| Requested face | Wine uses |
|---|---|
| Arial (engine/ZML text, -10..-24 px) | `C:\windows\fonts\Arial.TTF` (Arial 2.82) |
| Arial Bold | `C:\windows\fonts\Arialbd.TTF` |
| MS Sans Serif (dialog font, -11 = 8 pt at 96 DPI) | 13 px strike of `C:\windows\fonts\sserife.fon` (the `fonts/` copy). Wine's own `share/wine/fonts/sserife.fon` is loaded but not added to the family. |
| Tahoma (Wine caption and MessageBox) | Wine's own `share/wine/fonts/tahoma.ttf` (`fonts/tahoma.ttf` is not installed) |
| System | Wine's `vgasys.fon` |

`FONT_SMOOTHING=off|on` (unset: unchanged) sets, before the engine starts:
- registry `HKCU\Control Panel\Desktop`: off `FontSmoothing`="0"; on `FontSmoothing`="2"; both `FontSmoothingType`=dword 1 (standard greyscale);
- X resources of the hidden display (`xrdb -merge`): off `Xft.antialias: 0`; on `Xft.antialias: 1`, `Xft.rgba: none`.

Findings:
- The registry value alone has no effect on engine text [V]: with `FontSmoothing`="0" and no X resource, "Start" (Arial Bold 24 px) is greyscale (17 colours); with `Xft.antialias: 0` it has 2 colours. With `on` it is greyscale again (17 colours). [I] Cause: winex11 (`get_xft_aa_flags`) sets the antialias mode of `DEFAULT_QUALITY` fonts from the X resources before win32u reads the registry.
- Wine applies the `gasp` table: Arial at 10..14 px stays monochrome in both modes (trace `aa disabled by GASP`) [V]. Only larger text (18 px, 24 px) changes.
- The earlier `screens/` captures were made on `:0` with Wine substitute fonts and the host `Xft.rgba` setting: "Start" there shows colour fringes (subpixel) [V: zoom of `screens/frame_title_first_run.png`; I: cause].
- Wine's greyscale is not the GDI greyscale of Windows XP (decision 4b, O6: unproven). Use `off` captures for layout and monochrome glyph comparisons.

Captures with `FONT_SMOOTHING=off`, installed prefix state, renderer no3d, in `analysis/reference/screens_monofonts/`:

| File | Content | SHA-256 |
|---|---|---|
| `frame_title_installed.png` | Title frame 800x572 | `66063ea3686cdab2c10e91654618ab89673c5379ed7dbc597bc500313867874f` |
| `desktop_title_installed.png` | Hidden screen 1024x768 with the frame at (112,97) | `8ce0d60ac0b3928eac5435216f24fe8a6f10e83568962a43cc7b5d8563338a95` |
| `dialog_terms_of_service.png` | Terms of Service dialog X window 425x308 (Wine caption, MS Sans Serif text) | `fcc2ec0d39a8d800f6ab54cfaa46861ba159569588b6bfbcee17c6c24241cc16` |
| `desktop_terms_dialog.png` | Hidden screen with the dialog over the frame | `0f237a52e70bd38d1c418236b9956611db0716df11e5e7d88d15938859528c86` |

Step file used (`capture_session.py`): `waitframe 40`, `wait 4`, `shot`, `desk`, `click 120 531`, `wait 3`, `wshot ... ZapSpot Terms of Service`, `desk`, `wclick 212 289 ZapSpot Terms of Service`.

## 4. Browser tests: `tools/bin/web-test`

    source tools/env.sh
    web-test --root port/tests/browser/fixtures port/tests/browser/smoke.mjs        # PASS, exit 0
    web-test --root port/tests/browser/fixtures port/tests/browser/guard_check.mjs  # FAIL by design, exit 1
    web-test port/tests/browser/<test>.mjs          # default root: port/build/web

- Runs inside `nonet` (refuses otherwise), headless only (`DISPLAY`, `WAYLAND_DISPLAY` unset). Temporary files (Chromium profile) go to `tools/home/tmp/web-test.XXXXXX` and are deleted at exit.
- `port/tests/browser/run.mjs` (called by `web-test`, not directly) starts a static `node:http` server on `127.0.0.1`, port chosen by the kernel. MIME types: `.wasm` `application/wasm`, `.js`/`.mjs` `text/javascript`, `.html`, `.css`, `.json`, `.png`, `.gif`, `.svg`, `.ico`, `.txt`; others `application/octet-stream`. `Cache-Control: no-store`. No path outside the root.
- Browser: `/usr/bin/chromium` through `playwright-core`, headless, Chromium sandbox on, `--disable-gpu --no-proxy-server --disable-component-update`; viewport 1024x768, device scale factor 1, service workers blocked. `WEB_TEST_ARGS`, `WEB_TEST_CHROMIUM`, `WEB_TEST_NO_SANDBOX=1` override.
- Test script: `export default async function ({ page, context, browser, baseURL, root, outDir, args, assert, log })`. A thrown error fails the test. Limit: `--timeout SEC` (default 60).
- Network guard: every request whose host is not `127.0.0.1` (`data:`, `blob:`, `about:` excepted) is aborted and recorded; also WebSockets. Any such request, any uncaught page error or a script error gives FAIL (exit 1).
- Report: `<out>/report.json` (default out `port/build/browser-tests/<script>/`): every request (method, URL, type, status, content type, failure), every server hit, every console message, page errors, violations.
- `port/serve.sh` did not exist; the server is built into `run.mjs`. If M1 adds `port/serve.sh`, `web-test` does not use it.
- Loopback inside `nonet` [V]: `lo` is UP; a TCP connect to 127.0.0.1 works; a connect to 1.1.1.1 fails (`Network is unreachable`); DNS fails.
- `smoke.mjs` [V: PASS]: loads `fixtures/index.html` (CSP `default-src 'self'`), reads canvas pixels with `getImageData` ((100,100) = #3333cc, marker (5,7) = #ece9d8), loads `add.wasm` with `WebAssembly.instantiateStreaming` (needs `application/wasm`; add(2,3) = 5), and reads the same two pixels from a page screenshot. Requests: 3, all to 127.0.0.1.
- `guard_check.mjs` [V: FAIL as expected]: from a page without CSP, an image of `https://example.org/` and a fetch of `http://example.com/`; both listed as `NETWORK VIOLATION`, exit 1.

## 5. Versions

| Tool | Version | Source |
|---|---|---|
| Xvfb | xorg-server-xvfb 21.1.25-1 | Arch package, unpacked in `tools/xvfb/` (`SOURCE.md`) |
| Wine | 11.19 (wow64) | `tools/wine/` |
| ImageMagick (`import`) | 7.1.2-32 | system |
| xdpyinfo, xrdb | 1.4.0, 1.2.3 | system |
| bubblewrap (`nonet`) | 0.13.0 | system |
| node, npm | 25.2.1, 11.6.2 | `~/.nvm` |
| Chromium | 153.0.8010.52 | system `/usr/bin/chromium` (decision O4) |
| playwright-core | 1.64.0 (dev) | npm registry |
| typescript | 7.0.2 (dev; native `tsc`, package `@typescript/typescript-linux-x64` 7.0.2) | npm registry |

playwright-core 1.64.0 expects Chromium 156; it drives the system Chromium 153 without error in the smoke test [V]. No browser binary was downloaded.

## 6. npm install record

    cd port   # package.json: private, no dependencies, devDependencies only
    npm_config_cache=tools/home/cache/npm npm install --save-dev --save-exact --ignore-scripts \
        --no-fund --no-audit --registry=https://registry.npmjs.org/ playwright-core typescript

- Every package in `port/package-lock.json` resolves to `https://registry.npmjs.org/...` and carries a `sha512` integrity value; npm checks it at download [V: lock file]. Lock file SHA-256 `97f3e726324ddca549eb782b1bb2867d375e47f5974004c3c415b53da4850386`.
- Install scripts disabled (`--ignore-scripts`); `tsc --version` = 7.0.2 works without them [V].
- `port/node_modules/` (44 MB) is git-ignored (`.gitignore`: `node_modules/`).

## 7. Known problems

- `.gitignore` ignores `/tools/*` except `env.sh`, `bin/`, `pe_rsrc.py`. So `tools/INFRA.md` and `tools/xvfb/SOURCE.md` are ignored now. The orchestrator must add exceptions (for example `!/tools/INFRA.md`, `!/tools/xvfb/`, `/tools/xvfb/*`, `!/tools/xvfb/SOURCE.md`).
- After `kill -9` of Xvfb, `/tmp/.XN-lock` and `/tmp/.X11-unix/XN` stay; `xvfb-run-wine` then skips `:N`. Remove them by hand.
- No splash capture was tried on Xvfb (the `:0` runs gave black splash captures).
- Wine prints `MESA-EGL` warnings at start (no DRI on Xvfb); harmless with `renderer=no3d`.

## Firefox (added in M7)

`WEB_TEST_BROWSER=firefox tools/bin/web-test SCRIPT.mjs` drives the installed `/usr/bin/firefox` through playwright-core channel `moz-firefox` (WebDriver BiDi), headless, inside nonet. No browser download.
