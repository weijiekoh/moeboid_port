# Wine captures with monochrome text (`FONT_SMOOTHING=off`)

Original `ZapSpot.exe` + `Moeboid.gam` under Wine 11.19, hidden Xvfb display, `tools/bin/nonet`, renderer
`no3d`, installed prefix state (`%APPDATA%\ZapSpot\System\Core.zdt` present, default high-score table, no
`Sound` entry). Fonts: `fonts/Arial.TTF` 2.82, `Arialbd.TTF`, `sserife.fon` (tools/INFRA.md 3). Text at
10..14 px is monochrome in both smoothing modes (gasp); `off` also makes 18 and 24 px monochrome.
Dialogs use Wine's own theme and Tahoma (not Windows XP Luna).

## Files from tools/INFRA.md 3 (2026-10-11)

`frame_title_installed.png`, `desktop_title_installed.png`, `dialog_terms_of_service.png`,
`desktop_terms_dialog.png`: see tools/INFRA.md section 3 (SHA-256 there).

## Files for the M5b shell comparison (2026-10-11)

Made with the step file `port/tests/py/test_shell_wine_steps.txt`:

    source tools/env.sh
    FONT_SMOOTHING=off analysis/reference/run_original.sh start 420
    analysis/reference/run_original.sh x python -I -B analysis/reference/capture_session.py OUT \
        port/tests/py/test_shell_wine_steps.txt
    analysis/reference/run_original.sh stop

Frame coordinates; before every shot a click at (100, 300) (news text, no handler) moves the pointer away
from the buttons. The port test `port/tests/native/test_shell.c` runs the same sequence.

| File | State |
|---|---|
| `frame_title_m5b.png` | title screen after start (about 48 s; game sprites animate) |
| `frame_how_to_play.png` | How To Play (rail button), game paused, Resume on the rail, paused footer |
| `frame_paused.png` | Resume, then Pause: pause page "Resume your game using the button to the left" + footer |
| `frame_help_101.png` | "?" button: ZapSpot Help, table of contents |
| `frame_help_111.png` .. `frame_help_118.png` | help topics, each opened by its link on page 101 |
| `frame_about.png` | About ZapSpot |
| `frame_personalize_sound_on.png`, `frame_personalize_sound_off.png` | Personalize before and after Toggle (installed: no save dialog) |
| `frame_view_all_games.png` | View All Games on the title screen (no game in progress: no dialog) |
| `frame_title_again.png` | after a click on the Moeboid tile (New Game) |
| `frame_game_running.png` | about 8 s after a click on Start |
| `desktop_quit_dialog.png` | New Game during the game: "Warning: Game in Progress" over the frame (frame at (112, 97)) |
| `dialog_quit_saved.png` | that dialog window alone (303 x 113, Wine caption) |
| `desktop_tos_dialog.png` | Terms of Service dialog over the frame, after Esc on the quit dialog |

SHA-256:

    99f4b553f7a3f3997dd5658adf9b431ad9a8b294c94738be786cda64bf746749  desktop_quit_dialog.png
    936ac444c9f8e39f4853e11cd18c7eb97e638446f8ea566881a1448785f6c60e  desktop_tos_dialog.png
    bc812610f50ffa5939b4a72f9d8587261e78137425cf3fbfbe8acec187c09c21  dialog_quit_saved.png
    64cc9d1434665797e2b0f45f0378cdaa18cb1bb6157a9827b2eac0a68f5cea99  frame_about.png
    d65d51eac8a9266fe6d1542d967d20bcdaa716bca77cf280ce6e9ee42934e6fe  frame_game_running.png
    6f74576e1e22549d939450814b7a115efd582325308785f5e1138b1c65b314ef  frame_help_101.png
    055f9732523a09ddd165bec2be889a82aeccd2b63a8f3c382521e1ce12718043  frame_help_111.png
    8a93418a1d8c241a3dadedaf5d8f1e3cb5142eb14a2076c0ffcd5f64023ca5fc  frame_help_112.png
    8a76f191bb673a9698ad687b669ff4d72b04dc14ea5fe9ff2fda2fe8237ef73a  frame_help_113.png
    535f495de73797c75cb04d8dc036419235063a9d6affaa1e70fbe7f12b28dd0f  frame_help_114.png
    70f623d6616ab2b3a66ab770cd523203b07819fb2ff214da5d63c810b4bbbe03  frame_help_115.png
    c8967eaa75403794b08d059a3339097382373c9fad1497ae36bd71fb040f9d2f  frame_help_116.png
    bb7acf9af5cd2c1acb7dd909cf71171c2f02b664f14184b5f2dc6c943d1deea9  frame_help_117.png
    68e1872f860cd65ef8cf2021eed460be1e6e4128f74fcb91faf5be19737223fb  frame_help_118.png
    7e1830dfe163c76bee0afb4854c2f80aa523d25db3413c3b1406f3543d95d1f2  frame_how_to_play.png
    fdaf124a261568c5fe24af39112f45ac6628eec46f533907c36bbfa5d57a49cb  frame_paused.png
    74ab24681bf0345902c86893887abeb23782c7eb934aa971797c845b2366eec3  frame_personalize_sound_off.png
    54ac8b3b86998a03a822d236fee4fa7d4a6f120ddaa1b8a34f0a90cd7120eb5a  frame_personalize_sound_on.png
    ccb29e9b44366c96e8621f79f1b91e3a7aab07fb465b902d5fbb5a9dfe5743bd  frame_title_again.png
    3d64f594537994e1ed4d0b9dfc84c096b2b9d38c444423230058e418cbc78699  frame_title_m5b.png
    a6831e15c9299296f036794bca39cb4cb30b6b5635ff2c07d11825ecb7e77ecf  frame_view_all_games.png

Notes:
- No splash capture: the 400 x 240 start-up window captures black under Wine (reference NOTES.md 2).
- The capture tool logged an X error for `wshot dialog_quit_saved` after the file was written; the file
  is a valid 303 x 113 image of the dialog.
- The session toggled the sound setting twice (back to on) and was ended with `stop` (no exit save).
