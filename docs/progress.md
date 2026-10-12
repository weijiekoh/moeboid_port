# Phase 2 progress

Last update: 2026-10-11 14:15 (orchestrator). Phase 2 complete: all gates passed. Summary of exactness: `docs/exactness.md`. Run: `port/run.sh`. Plan: `docs/architecture.md` section 7. Contract: `docs/port-design.md`. Decisions: `docs/decisions.md`.

| Milestone | Status | Gate | Gate result |
|---|---|---|---|
| M0 Decisions | done | answers recorded | `docs/decisions.md` |
| M1 Foundation | done (2fc8234) | timer unit tests reproduce timing.md section 5 table | pass: 8 native test programs (orchestrator re-run), table exact for 1/10.0144/15.625/54.925 ms; node smoke 76 checks; headless Chromium click-to-start and CSP |
| M2 CPU | done (fc1bb3a) | per-instruction-form differential test against Unicorn, corpus hashes equal | pass: 15677 addresses, 280 forms, 156770 states, 0 unexplained mismatches (orchestrator re-run); recordings identical on 3 backends; option (d) confirmed, no fallback |
| M3 Assets and fonts | done (fe61941) | GIF output equals engine rules for 81 GIFs; atlas advances equal `hdmx` | pass: 81 GIFs, 258 frames, 0 pixel differences (re-run by orchestrator); 0/2304 advances differ from hdmx; sserife exact; pack deterministic |
| Luna frame (from luna.msstyles) | done (dbeb924) | frame metrics and colours equal NORMALBLUE_INI | pass: 192 checks |
| Engine ZML renderer | done (32f89cf) | line breaks and positions equal Wine captures | pass: all captured pages, same line breaks, max 1 px position difference |
| Infra (Xvfb, browser tests) | done (6a32e41) | Wine runs on hidden Xvfb display; headless Chromium in nonet | pass: Xvfb package verified (sha256 + gpg); Wine frame captured on hidden display, no window on :0; web-test blocks non-loopback requests |
| M4 Engine core | done (1075e2b) | corpus with real engine equals reference; frame pixel checks | pass: lockstep identical per tick for 5 cases (orchestrator re-run); 221 engine checks; title frame equals Wine mono capture except moving sprites and 2 underline rows; playable in headless Chromium |
| M5 Shell | done (1c4bdce, f93d445) | layout and colour equal Wine captures except text artefacts; no network | pass: 21 screens vs Wine mono-font captures, 0 layout/image/colour differences outside intended masks; text differences explained (O14); full suite 25/25 and shell browser flow pass (orchestrator re-run) |
| M6 Audio and input | host side done (fd88842); C voice table in M4 | trigger timing, sample identity, focus pause | host pass: 15 sounds sample-identical, tick spacing 0 samples deviation, mute on blur, 137 key events (orchestrator re-ran 2 of 4 tests) |
| M7 Acceptance | done | full check suite, packaging | pass: `port/build.sh verify` 74 of 74 (orchestrator re-run, 60 s real-time soak; agent run with 600 s soak also 74/74); timing equal at 30/60/144 Hz frame clocks in Chromium and Firefox; 0 non-loopback requests in 14 browser runs; native/wasm/page frame hashes equal; 30 min soak 0 faults |
| Post-M7: no start screen | done | user request: remove the click-to-start page, keep default settings | pass: `port/build.sh verify` 74 of 74 (600 s real-time soak); page starts at load, fixed settings (clock 0, smoothing Standard, quirks on), sound from the first key or mouse press (`tests/browser/autostart.mjs`) |

## Open issues
- Original game bug reproduced: typing `credits` on the title after a game over (Play again: No) faults at G:0x10001401 (use-after-free of the play screen); the port stops the game, a page reload recovers. Inferred: the original crashes the same way. Keeping or patching it belongs with deferred decision 10.
- The random soak never reached the high-score InputBox; native tests cover it.
- Underline row: Wine draws it 1 row higher than the port (inferred GDI rule in gdi_text.c); no Windows ground truth.
- XP system cursors (arrow, I-beam) for dialogs are not in any supplied file; placeholder: CSS `default`/`text`.
- Arial Bold '-' and 0xAD at 11 and 17 px: FreeType advance differs from hdmx by 1; atlases use hdmx (as GDI, inferred). No kept text uses these sizes.
- Wine on Xvfb needs `WINE_D3D_CONFIG=renderer=no3d` (default in run_original.sh).

## User-supplied files
- Missing, optional: the XP exclamation icon (user32.dll icon 101 / IDI_EXCLAMATION, 32x32 32-bit) and `C:\WINDOWS\Media\Windows XP Exclamation.wav`. The "Name too long" MessageBox uses flags 0x101 = MB_OK | MB_ICONEXCLAMATION (verified `Z:0x4058f1`); on XP this shows the icon and plays the system exclamation sound. Placeholder: no icon, no sound.
- `fonts/tahoma.ttf` (3.15), `fonts/tahomabd.ttf` (3.15), `fonts/trebucbd.ttf` (1.22): received 2026-10-11, XP-generation, retail-XP version unverified; M3 integrates them.
- `fonts/luna.msstyles` (XP SP3): received 2026-10-11; Luna workstream extracts frame data.
