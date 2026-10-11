# Phase 2 progress

Last update: 2026-10-11 (orchestrator). Plan: `docs/architecture.md` section 7. Contract: `docs/port-design.md`. Decisions: `docs/decisions.md`.

| Milestone | Status | Gate | Gate result |
|---|---|---|---|
| M0 Decisions | done | answers recorded | `docs/decisions.md` |
| M1 Foundation | in progress | timer unit tests reproduce timing.md section 5 table | - |
| M2 CPU | in progress | per-instruction-form differential test against Unicorn, corpus hashes equal | - |
| M3 Assets and fonts | in progress | GIF output equals engine rules for 81 GIFs; atlas advances equal `hdmx` | - |
| Infra (Xvfb, browser tests) | in progress | Wine runs on hidden Xvfb display; headless Chromium in nonet | - |
| M4 Engine core | not started | corpus with real engine equals reference; frame pixel checks | - |
| M5 Shell | not started | layout and colour equal Wine captures except text artefacts; no network | - |
| M6 Audio and input | not started | trigger timing, sample identity, focus pause | - |
| M7 Acceptance | not started | full check suite, packaging | - |

## Open issues
- None yet.

## User-supplied files
- `fonts/tahoma.ttf`, `fonts/tahomabd.ttf`, `fonts/trebucbd.ttf`, `fonts/luna.msstyles`: not present (placeholders in use). Checked at each milestone.
