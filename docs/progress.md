# Phase 2 progress

Last update: 2026-10-11 11:30 (orchestrator). Plan: `docs/architecture.md` section 7. Contract: `docs/port-design.md`. Decisions: `docs/decisions.md`.

| Milestone | Status | Gate | Gate result |
|---|---|---|---|
| M0 Decisions | done | answers recorded | `docs/decisions.md` |
| M1 Foundation | done (2fc8234) | timer unit tests reproduce timing.md section 5 table | pass: 8 native test programs (orchestrator re-run), table exact for 1/10.0144/15.625/54.925 ms; node smoke 76 checks; headless Chromium click-to-start and CSP |
| M2 CPU | done (fc1bb3a) | per-instruction-form differential test against Unicorn, corpus hashes equal | pass: 15677 addresses, 280 forms, 156770 states, 0 unexplained mismatches (orchestrator re-run); recordings identical on 3 backends; option (d) confirmed, no fallback |
| M3 Assets and fonts | done (fe61941) | GIF output equals engine rules for 81 GIFs; atlas advances equal `hdmx` | pass: 81 GIFs, 258 frames, 0 pixel differences (re-run by orchestrator); 0/2304 advances differ from hdmx; sserife exact; pack deterministic |
| Luna frame (from luna.msstyles) | done (dbeb924) | frame metrics and colours equal NORMALBLUE_INI | pass: 192 checks |
| Engine ZML renderer | done (32f89cf) | line breaks and positions equal Wine captures | pass: all captured pages, same line breaks, max 1 px position difference |
| Infra (Xvfb, browser tests) | done (6a32e41) | Wine runs on hidden Xvfb display; headless Chromium in nonet | pass: Xvfb package verified (sha256 + gpg); Wine frame captured on hidden display, no window on :0; web-test blocks non-loopback requests |
| M4 Engine core | in progress | corpus with real engine equals reference; frame pixel checks | - |
| M5 Shell | in progress: M5a dialogs, M5b frame/pages/splash/cursors | layout and colour equal Wine captures except text artefacts; no network | - |
| M6 Audio and input | host side done (fd88842); C voice table in M4 | trigger timing, sample identity, focus pause | host pass: 15 sounds sample-identical, tick spacing 0 samples deviation, mute on blur, 137 key events (orchestrator re-ran 2 of 4 tests) |
| M7 Acceptance | not started | full check suite, packaging | - |

## Open issues
- Cursor images: host still uses CSS cursor names; the six original cursors (PNG + hotspot) go to M5b.
- Arial Bold '-' and 0xAD at 11 and 17 px: FreeType advance differs from hdmx by 1; atlases use hdmx (as GDI, inferred). No kept text uses these sizes.
- Wine on Xvfb needs `WINE_D3D_CONFIG=renderer=no3d` (default in run_original.sh).

## User-supplied files
- Missing, optional: the XP exclamation icon (user32.dll icon 101 / IDI_EXCLAMATION, 32x32 32-bit) and `C:\WINDOWS\Media\Windows XP Exclamation.wav`. The "Name too long" MessageBox uses flags 0x101 = MB_OK | MB_ICONEXCLAMATION (verified `Z:0x4058f1`); on XP this shows the icon and plays the system exclamation sound. Placeholder: no icon, no sound.
- `fonts/tahoma.ttf` (3.15), `fonts/tahomabd.ttf` (3.15), `fonts/trebucbd.ttf` (1.22): received 2026-10-11, XP-generation, retail-XP version unverified; M3 integrates them.
- `fonts/luna.msstyles` (XP SP3): received 2026-10-11; Luna workstream extracts frame data.
