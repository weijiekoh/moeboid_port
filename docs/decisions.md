# Decisions for phase 2

Date: 2026-10-11. Source: user answers to `docs/architecture.md` section 6 and later questions. "Default" = recommendation accepted without an explicit user answer; the user can change it.

## Binding requirements (earlier answers)

- Exact gameplay, timing and visuals. Fixed-timestep loop, independent of the display refresh rate.
- Exact Microsoft fonts. Exact colours.
- ~~Simple click-to-start screen in the web page.~~ Replaced (2026-10-11, after M7): no start screen; the page starts the game at load. Sound starts at the first key press or mouse press in the page (browser autoplay rule); sounds before that are dropped.
- Local high scores only. No accounts, no bfast.com, no game downloads.
- No ads and no network communication.
- Keep the ZapSpot frame and platform menu, minus ads, network features and downloads.
- Deployment: local only (the user's machine).

## Section 6 decisions

| # | Item | Decision | Status |
|---|---|---|---|
| 1 | Technology | Option (d): original Moeboid.gam in an x86 interpreter, engine and shell in C, one wasm module (clang, no Emscripten), thin TypeScript host. Fallback to (a) at the M2 gate is automatic and must be reported. | user |
| 2 | Clock model | 1 ms step, 50 Hz game ticks. Not configurable (2026-10-11, after M7: settings form removed, "keep the default settings"); the C side keeps the 15.625 ms and 54.925 ms models for tests (`?clock=1|2`). | user |
| 3 | Colour look | 24/32-bit desktop look, exact GIF RGB. | default |
| 4a | Windows look for native dialogs and MessageBox | Windows XP Luna (blue). Note: ZapSpot.exe has no RT_MANIFEST resource, so on XP its dialog and MessageBox controls are classic (unthemed); only the non-client frame (title bar, caption buttons, border) uses Luna. Verify this in phase 2. | user |
| 4b | Font smoothing | Standard (XP default): greyscale antialiasing where the `gasp` table allows it. Exactness of greyscale pixels cannot be proven without Windows; mark as unproven. | user |
| 4c | Windows ground truth | None. The user will put `tahoma.ttf`, `tahomabd.ttf`, `trebucbd.ttf` and `luna.msstyles` (from Windows XP) into `fonts/` later. Use placeholders until then; never block on them. | user |
| 5 | Terms of Service | Keep. Drawn in the canvas (pixel-exact text, dialog component). Remove the ad opt-in checkbox and its server message. | user |
| 6 | View All Games | Keep the menu item; the page shows only the Moeboid tile. Promo tiles and "Zap Me A Game" removed. | user |
| 7 | Rail without Mail This | Leave an empty slot; other buttons keep their positions. | user |
| 8a | Minimize and close buttons | Remove both (blank). | user |
| 8b | Help and About texts | Verbatim, links inert (same look, no click target). Security page link target removed. | default |
| 8c | Personalize page | Keep the sound toggle; remove the proxy section. | default |
| 9 | Ad area | Fill with the frame's blue background colour (#3333cc, verify against rendering.md). | user |
| 10 | Quirks ("play again" snap, virtual-key quirks) | DEFERRED: user asked to be reminded later. Provisional: keep them (the interpreter keeps game quirks automatically); engine-side quirks on (the C side keeps the switch bits; the page has no switch since the settings form was removed). | reminder |
| 11 | FSIN/FCOS reference values from a modern Intel CPU | DEFERRED: user asked to be reminded later. Provisional: use them. | reminder |
| 12 | Audio | 16-voice limit, mute on blur, AudioContext at the device rate. | default |
| 13 | Splash screen | Keep, shown for about 2 s after the page start (original duration = engine start-up time, unknown). | user |

## Process decisions

- Version control: local git repository in the project, commit at each verified step. No remote, no push.
- Wine reference runs: only on a hidden X display (Xvfb unpacked from the Arch package into `tools/`, no system install), always through `tools/bin/nonet`. Never on the user's display `:0`.
- Autonomy: run M1 to M7 without stopping. Stop only for a decision that belongs to the user, a missing file that blocks all remaining work, or a failed gate with no planned fallback.

## Orchestrator decisions (phase 2)

| # | Decision | Reason |
|---|---|---|
| O1 | XP Luna applies to the non-client frame only (title bar, caption buttons, border). Dialog controls and MessageBox buttons are classic (comctl32 v5 look) but use the Luna system colours (for example COLOR_3DFACE #ECE9D8). MessageBox text uses the NONCLIENTMETRICS message font (Tahoma 8 pt); captions use the Luna caption font (Trebuchet MS Bold 10 pt). | Windows XP themes client controls only for applications with a Common Controls 6.0 manifest; it themes the non-client area of every top-level window when a visual style is active (external knowledge). ZapSpot.exe has no RT_MANIFEST resource (verified: `assets/INDEX.md`, resource types CURSOR, BITMAP, ICON, DIALOG, STRING, RCDATA, GROUP_CURSOR, GROUP_ICON), and the launcher writes no `.manifest` file (verified: `analysis/reference/NOTES.md` layout: ZapSpot.exe, Moeboid.gam, ZapLock). Luna colours, metrics, fonts and frame bitmaps come from `fonts/luna.msstyles` (XP SP3 build 2008-04-13; NORMALBLUE_INI [SysMetrics]: CaptionFont Trebuchet MS 10 bold, CaptionBarHeight 25, SmallCaptionFont Tahoma 8 bold, MsgBoxFont Tahoma 8), parsed as data only; values from that file are verified, values not in it stay inferred. Tahoma 3.15 and Trebuchet MS Bold 1.22 are XP-generation fonts with unverified retail-XP version (`fonts/SOURCES.md`). |
| O2 | Guest memory map of the interpreter equals the Unicorn harness map (`docs/port-design.md` section 4). | Lets the existing harness and corpus compare both CPU backends without translation. |
| O3 | The Python harness drives the C interpreter through `ctypes` and a Unicorn-compatible shim; the mock engine stays in Python for the M2 gate. | Reuses the verified mock and corpus (verification.md 1); no second mock implementation. |
| O4 | TypeScript is converted with node's built-in `module.stripTypeScriptTypes`; no bundler. `typescript` and `playwright-core` are dev-only npm packages in the project `node_modules/` (git-ignored). Browser tests use the installed `/usr/bin/chromium` through `playwright-core`, headless, inside `tools/bin/nonet`. | No download of browser binaries; no npm package in the shipped page. |
| O5 | Subagents never touch git. The orchestrator commits after each verified step. | One writer of the git index. |
| O6 | Greyscale text model (decision 4b): hint at the target size, rasterize the hinted outline with 4x4 oversampling, 17 coverage levels, linear blend of text colour over the destination pixel; `gasp` decides mono or grey per size. Marked unproven. | Best-documented GDI standard-smoothing model available without Windows (fonts.md 10.2, 10.5). |
| O7 | Atlases at 8 px grey are unhinted, because Arial's `gasp` sets greyscale without grid-fitting there; atlas advances follow `hdmx` where FreeType differs (Arial Bold '-' at 11 and 17 px). Atlas key uses px = -lfHeight (MS Sans Serif 8 pt = 11). | `gasp` semantics and GDI use of `hdmx` (inferred); M3 report. |
| O8 | Terms of Service dialog: the opt-in checkbox is hidden; every other control keeps its template position; the checkbox area stays empty. | Decision 5 removes the checkbox; keeping positions keeps the rest of the dialog pixel-equal to the original. |
| O9 | Dialogs are centred in the 800x572 frame (the canvas). The XP icon and system sound of MB_ICONEXCLAMATION are reserved pack entries (`data/icons/EXCLAMATION`, `data/sounds/EXCLAMATION.WAV`, sound id 16); without the files no icon is drawn and no sound plays. | The canvas is the frame; the files are not supplied. |
| O10 | New Game builds a fresh guest machine (the original unloads and reloads the DLL, verified from code), and the port frees the engine objects that the stopped game leaked. | Without the release the port heap fills after about 58 New Games; the freed objects are unreachable, so the game cannot observe the difference. |
| O11 | `refmock.py` (reference engine model for lockstep) corrects `mock.py` in 8 documented points (R1-R8: real metrics, IDOK, GetKeyState value, missing setting "", key message, listener stop, Release counts, input times on clock values). | Where the mock and the original engine code differ, the original code wins. |
| O12 | Decision 8b: links between help pages (and to About 20001 and Help contents 20002) stay active, so help topics 111-118 remain reachable as in the original; links to URLs and the Security page are inert (same look, no click target). | Making internal links inert would make kept help pages unreachable; external links are network features. |
| O13 | The removed subscribe box includes its rounded border image; the ToS link stays at (31,526) on the plain #3333cc background. The splash (400x240) shows centred on a black canvas for 2000 ms of virtual time; input and game start wait until it ends; then the original start-up order (View All Games, New Game). | Decisions 9 and 13; original start-up Z:0x41f500, Z:0x41c910. |
| O14 | Text metrics follow the GDI model (hinted advances from `hdmx`), not Wine's. Wine mono-font captures differ in centred-label positions (1-2 px), underline rows (1 px) and some long-line breaks; the port does not copy these Wine differences. | Wine's text widths are not GDI ground truth; the GDI model is the best-documented rule (fonts.md 10.3-10.5). Unproven without Windows. |
