# Decisions for phase 2

Date: 2026-10-11. Source: user answers to `docs/architecture.md` section 6 and later questions. "Default" = recommendation accepted without an explicit user answer; the user can change it.

## Binding requirements (earlier answers)

- Exact gameplay, timing and visuals. Fixed-timestep loop, independent of the display refresh rate.
- Exact Microsoft fonts. Exact colours.
- Simple click-to-start screen in the web page.
- Local high scores only. No accounts, no bfast.com, no game downloads.
- No ads and no network communication.
- Keep the ZapSpot frame and platform menu, minus ads, network features and downloads.
- Deployment: local only (the user's machine).

## Section 6 decisions

| # | Item | Decision | Status |
|---|---|---|---|
| 1 | Technology | Option (d): original Moeboid.gam in an x86 interpreter, engine and shell in C, one wasm module (clang, no Emscripten), thin TypeScript host. Fallback to (a) at the M2 gate is automatic and must be reported. | user |
| 2 | Clock model | A setting with three values (1 ms, 15.625 ms, 54.9 ms step). Default: 1 ms step, 50 Hz game ticks. | user |
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
| 10 | Quirks ("play again" snap, virtual-key quirks) | DEFERRED: user asked to be reminded later. Provisional: keep them (the interpreter keeps game quirks automatically); make engine-side quirks switchable. | reminder |
| 11 | FSIN/FCOS reference values from a modern Intel CPU | DEFERRED: user asked to be reminded later. Provisional: use them. | reminder |
| 12 | Audio | 16-voice limit, mute on blur, AudioContext at the device rate. | default |
| 13 | Splash screen | Keep, shown for about 2 s after click-to-start (original duration = engine start-up time, unknown). | user |

## Process decisions

- Version control: local git repository in the project, commit at each verified step. No remote, no push.
- Wine reference runs: only on a hidden X display (Xvfb unpacked from the Arch package into `tools/`, no system install), always through `tools/bin/nonet`. Never on the user's display `:0`.
- Autonomy: run M1 to M7 without stopping. Stop only for a decision that belongs to the user, a missing file that blocks all remaining work, or a failed gate with no planned fallback.
