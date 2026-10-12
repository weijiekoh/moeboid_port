# Reference captures of the original (Wine) - workstream I

Engine: `extracted/ZapSpot.exe` (shell version 01.01.01.1034). Game: `extracted/Moeboid.gam`
(game version 00.01.01.08, game GUID {2BFDD7F8-0EC4-4E7C-9FF4-3B2F8DC1D0F2}).
Host: Wine 11.19 wow64, prefix `tools/home/wineprefix`, every run through `nonet`.

Evidence tags: **[V]** verified (file, trace line, screenshot, address given); **[I]** inferred.

Important: Wine font rendering is not Windows GDI. Use the screenshots as references for layout,
colour and content, not for exact glyph pixels. Wine substitutes its own Tahoma/Arial-like fonts.

## 1. How to run

    analysis/reference/run_original.sh start 90     # setup + start; auto-kill after 90 s
    analysis/reference/run_original.sh shot /tmp/x.png
    analysis/reference/run_original.sh click 563 253 # frame coordinates
    analysis/reference/run_original.sh key Right 600
    analysis/reference/run_original.sh stop          # nonet wineserver -k

- `run_original.sh` runs `nonet wine cmd /c C:\Moeboid\run.bat` [V: script]. It never runs the
  engine without `nonet`. It disables `winebrowser.exe`, so a URL launch cannot reach the host.
- Environment: `RUN_WINEDEBUG` (Wine channels), `RELAY_INCLUDE` (written to
  `HKCU\Software\Wine\Debug\RelayInclude`; deleted when unset), `LOG`, `SCRATCH`.
- Scripted sessions: `python -I -B analysis/reference/capture_session.py OUTDIR STEPFILE`.
  Step files of all runs are in `steps/`. `bot_avoid.py` steers the player into purple
  amoebas to reach game over (used for the high-score screens).
- Python is run with `-I -B` and `PYTHONDONTWRITEBYTECODE=1`: no `__pycache__`.
- Input is synthetic (XSendEvent to the frame X window). The real pointer is not used.

### Layout that the script reproduces

    C:\Moeboid\moeboid.exe                                  copy of the launcher (not executed)
    %TEMP%\~zs0001.tmp\ZapSpot.exe, Moeboid.gam, ZapLock    (ZapLock: empty file)
    working directory = %TEMP%\~zs0001.tmp
    ZapSpot.exe "<temp folder>" "C:\Moeboid\moeboid.exe" "Moeboid.gam"

- argv[2] is the launcher path [V: install copies `C:\Moeboid\moeboid.exe` to
  `Documents\My ZapSpot\moeboid.exe`, `traces/install_exit_files_relay.txt`].
- Launcher strings `ZapSpot.exe`, `ZapLock`, `~zs*`, `*.gam`, `Moeboid.gam` support the layout
  [V: `strings moeboid.exe`]. The name `~zs0001.tmp` comes from the earlier agent's launcher
  analysis. `moeboid.exe` itself was not executed in this workstream.
- Display: 1024x768 Wine virtual desktop (`HKCU\Software\Wine\Explorer`), so the host X
  display is not mode-switched. The engine reads 1024x768, 32 bpp [V: `ddraw_dsound_setup.txt`].

### Prefix state

- First-run state = no `%APPDATA%\ZapSpot`. Installed state = after "Install ZapSpot" or "Save".
- At the end of this workstream the prefix is in the installed state (run I + run X).
  To get the first-run state again, delete `%APPDATA%\ZapSpot`, `Documents\My ZapSpot`,
  `Desktop\ZapSpot.lnk`, `ProgramData\...\Start Menu\Programs\ZapSpot.lnk`.
- After install, the engine loads the game from
  `%APPDATA%\ZapSpot\Games\{GUID}\{GUID}.gam`, not from the temp folder, although the command
  line names `Moeboid.gam` [V: run X relay, `LoadLibraryA("{2BFDD7F8-...}.gam")`].

## 2. What works, what fails

Works [V: screenshots]: start-up, title, all platform pages, help viewer, mail form, terms
dialog, install, game intro, gameplay, pause, life-lost and game-over messages, high-score
dialog and table, close dialogs, clean exit. Sound initialises (Wine DirectSound).

Fails or limited:
- The 400x240 start-up window titled `ZapSpot` (painted once with GDI `BitBlt` 400x240
  [V: `timing_relay.txt`, caller 0x403f7c]) captures as black. No usable splash screenshot.
- A capture of a window before Wine paints it can return host screen content. One such capture
  was deleted. `deskloop` waits are short; check new captures before you keep them.
- Frame captures can show a black rectangle where a dialog overlaps and is not painted yet
  (example: high-score dialog area). The curated set excludes these.
- `winedbg` attach works, but the engine crashes some seconds after detach (Wine wow64 break-in
  thread faults at 0xfff211bc). Take one memory dump per run.
- Network: offline under `nonet` (see section 5). No online feature can be shown.
- Not tested: ad banner clicks and links in About/Personalize (they open a browser), game icons
  in View All Games, the minimize button, the Apply (proxy) button, display depth change
  (the engine shows "ZapSpot does not yet support dynamic display depth changes" and exits [V: string]).
- 8-bpp desktop (palette path, "CreatePalette in GetDisplayMode" [V: string]) not exercised:
  Wine gives a 32-bpp desktop.
- The high-score entry for 10 points (screens below) was possible because the earlier agent
  set the fifth table score to 0 in `Core.zdt` before run E [I: `capE/30_title_mod_table.png`
  shows 0, the default is 500].

## 3. Screenshots (`screens/`)

Crop rules:
- `frame_*.png`: the X window of the top-level Win32 window `ZapSpot - Moeboid`, 800x572,
  borderless (custom skin). It sits at (112,97) in the 1024x768 virtual desktop [V: desktop
  bounding box, and the primary-surface Blt rect (112,97)-(912,669)]. Frame = client area.
- `dialog_*.png`: the dialog's own X window, Wine-drawn caption included.
- `desktop_*.png`: the 1024x768 virtual desktop (dialog placement, desktop icon).
- `ad_banners_sheet.png`: frame rect (279,499)-(751,564) from all captures, near-duplicates removed.

| File | Content |
|---|---|
| frame_title_first_run.png | Title. "Top Moeboids" table (ZapSpot 10,000/5,000/2,500/1,000/500), Start, "Install ZapSpot" link (first-run state) |
| frame_title_installed_after_highscore.png | Title after a high-score entry ("tester 10"); no Install link (installed state) |
| frame_how_to_play.png | How To Play text; game paused; "Resume" button |
| frame_view_all_games.png | View All Games: Moeboid, ColorBreak, SortSport, Peh Pa, BubbleBound, FenceOut; button column empty |
| frame_personalize_sound_on.png | Personalize: sound On, Toggle, proxy Server Name/Port Number, Apply |
| frame_personalize_sound_off.png | Personalize after Toggle (sound Off) and Cancel of the save dialog |
| frame_about.png | About ZapSpot text and links |
| frame_mail_this.png | "Zap Moeboid to a Friend" form: From/To e-mail, Message, Send, Cancel |
| frame_mail_this_send_empty_error.png | Send with empty fields: "An error was encountered... You must enter a valid e-mail..." |
| frame_install_saved_to_desktop.png | After "Install ZapSpot": "ZapSpot has been saved to your desktop" |
| frame_subscribe_invalid_email.png | Subscribe arrow with empty e-mail: "That's not your e-mail!" |
| frame_help_table_of_contents.png | Help (? button): ZapSpot Help table of contents (ZML links) |
| frame_help_getting_started.png | Help topic "Getting started with ZapSpot" |
| frame_help_enjoying_games.png | Help topic "Enjoying ZapSpot Games" (ESC = boss key: minimizes) |
| frame_help_extended_support_info.png | Help "Extended Support Information": shell 01.01.01.1034, shell GUID all zero, "Not Installed", game version 00.01.01.08 |
| frame_game_intro_a.png, frame_game_intro_b.png | Two frames of the intro animation after Start |
| frame_game_start.png | Gameplay start: lives x2, Avoid icon, score 0, player only |
| frame_game_play_score0.png | Gameplay with amoebas, score 0 |
| frame_game_play_score20.png | Gameplay, 1 life, score 20 |
| frame_game_paused.png | Pause: "Resume your game using the button to the left" |
| frame_message_life_lost_2_left.png | "Hmm... When we said 'Eat or be eaten'... you have 2 more lives left... Press the space bar to continue..." |
| frame_message_life_lost_1_left.png | Same message, "1 more life left" |
| frame_message_game_over_play_again.png | "That was good. Unfortunately that was also all the lives... Play Again? Yes (Y) No (N)" |
| dialog_terms_of_service.png | "ZapSpot Terms of Service and Privacy Policy" (text box, opt-in checkbox, OK) |
| dialog_high_score_entry.png, dialog_high_score_entry_typed.png | "Congratulations" name entry (default "Name"; typed "tester") |
| dialog_game_in_progress.png | "Warning: Game in Progress" Yes/No (New Game or close during a game) |
| dialog_save_to_desktop_requested.png | "Save to Desktop Requested" OK/Cancel (sound Toggle in first-run state) |
| dialog_play_again_soon.png | "Play Again Soon": Keep Playing / Dont Save, just Exit / Save And Exit (close in first-run state) |
| desktop_terms_dialog.png, desktop_high_score_dialog.png, desktop_game_in_progress_dialog.png | Dialog placement over the frame |
| desktop_title_first_run.png | Frame position in the desktop |
| desktop_after_exit_shortcut_icon.png | Desktop after exit in installed state: ZapSpot.lnk icon top-left |
| ad_banners_sheet.png | Ad banner frames: Rescue your friends..., ...by zapping them our games!, Mail Moeboid to a friend, Cable TV = $40/month, McAfee Clinic (animated), Subscribe to ZapSpot..., Newspaper = $.75/day, ZapSpot = $0/game |

Frame click points used (frame coordinates) [V: step files]: Mail This (233,110), New Game
(233,177), Pause/Resume (233,243), How To Play (233,310), View All Games (95,164), Personalize
(95,199), About (95,234), Help (718,22), Minimize (747,22), Close (776,22), Start (563,253),
Subscribe arrow (209,451), Install ZapSpot (122,508), Terms link (120,531), back-to-game arrow
(740,450), Send (475,344), Cancel (587,344), Toggle (675,309), Apply (675,389).
Keys: arrows move; space continues after a message; Y/N answer Play Again.

## 4. Timing, display and sound measurements

Method: Wine relay trace with `RelayInclude` (run T), `+ddraw,+dsound` (run D2), `+fps` only
(run F2), `top -H` (run X), and a memory dump of the engine task table with `winedbg` (runs M).
Caveats: relay slows the busy loop by a large factor (call rates in run T are not native);
Wine `GetTickCount` has 1 ms steps, Windows NT has 10-15.6 ms steps; `RelayFromExclude`
(Wine default) hides calls made from inside user32/gdi32/advapi32/kernel32.

### Main loop and threads
- Main loop at 0x404abc: `PeekMessageA(PM_REMOVE)`; on WM_QUIT exit; else Translate/Dispatch;
  with no message call the scheduler (object at [0x45cfb0], vtable 0x42f058, method 0x4273d0).
  No Sleep, no wait [V: run T counts: main thread 3.43M+3.43M GetTickCount, 858k PeekMessageA,
  0 Sleep]. Main thread uses 99.9 % of one CPU core [V: `top -H`, run X gameplay].
- Clock: `GetTickCount` through timer methods 0x4274f0 (total elapsed) and 0x427510
  (elapsed minus pause time) [V: disassembly, relay callers 0x4274fc/0x42751c].
- `timeGetTime`: only for message IDs (0x4275b5) and once at start-up before `srand`-like call
  0x40e38c (0x403dc4) [V: relay; I: srand].
- `timeBeginPeriod`: never called (not imported, no string) [V]. `timeEndPeriod(1)` once at exit
  (0x404b56) [V: runs I and X relay].
- Engine threads: one extra thread, start 0x409340, `SetThreadPriority(-1)` (BELOW_NORMAL),
  loop: for 16 sound slots `GetStatus`; replay or release; `Sleep(10)` [V: relay 0x408f52,
  0x408f66, 0x4093d8]. Wine-internal threads: wined3d command stream, dsound mixer (priority 15,
  20 ms period), wininet worker.
- DirectInput is not used. `DINPUT.DLL` is loaded only by the DirectX version probe on NT 4
  (0x40afe6..0x40b020) [V: code; no DINPUT load in relay runs]. Input = window messages [I].

### Scheduler tasks [V: `traces/scheduler_tasks.txt`]
Fire rule (0x413510): `if (now - last >= period) { callback(); last = now; }`.

| Period | Callback | Time base | Count (title / game) | Meaning |
|---|---|---|---|---|
| 20 ms | 0x100031e0 (Moeboid.gam) | pause-aware | 0 / 1 | game tick; registered at 0x10002c26 with `push 0x14` via engine vtable+0x34 [V] |
| 50 ms | 0x41f1d0 | total | 1 / 1 | [I] screen/frame task |
| 50 ms | 0x417850 | pause-aware or total | 2 / 9 | [I] per-object animation tasks |
| 1000 ms | 0x41aca0 | total | 1 / 1 | [I] |
| 60000 ms | 0x422b40 | total | 1 / 1 | [I] |

Note: the `push 0x10` near the callback 0x10001f40 (0x10001713) goes to engine vtable+0x44, not
to the timer call; 0x10 is not the game tick period [V: 0x100016e8..0x10001716; I: event id].

### Frame rate [V: `traces/frame_cadence.txt`]
- Frame = one `Blt` of the 800x572 back buffer to the primary at (112,97)-(912,669), DDBLT_WAIT.
- Gameplay: interval mode 50 ms (range 49-63 ms), mean 54.7 ms = 18.3 frames/s (run D2,
  141 frames). Run F2 (`+fps` only): 73.4-75.7 frontbuffer updates/s = 18.4-18.9 frames/s
  (4 frontbuffer updates per frame: window clip region of 4 rectangles).
- Intro after Start: irregular, 57-1054 ms between frames.
- Title idle: no DirectDraw call for 7 s (static screen).
- Host display is 60 Hz; 75 updates/s exceeds it, so vsync is not the limit [V: xrandr].
- [I] Nominal frame period 50 ms (20 Hz) from the 50 ms tasks; game logic 20 ms (50 Hz).
  On Windows with 10-15.6 ms `GetTickCount` steps the real cadence can differ (not measured).

### Display (DirectDraw) [V: `traces/ddraw_dsound_setup.txt`]
- `DirectDrawCreate(NULL)` twice: 0x426d5d (DX version probe, released) and 0x4081a3.
- `SetCooperativeLevel(hwnd, DDSCL_NORMAL)`: windowed. No `SetDisplayMode`. Uses the desktop
  mode: 1024x768, 32 bpp, R 0xff0000 G 0xff00 B 0xff, 60 Hz.
- Primary surface + clipper bound to the frame window. The clip region has a hole at frame
  (25..191, 444..462) = the native EDIT control of the Subscribe e-mail box [I].
- Back buffer: 800x572 `DDSCAPS_OFFSCREENPLAIN|SYSTEMMEMORY`, desktop format.
- Sprite surfaces: 263 with source colour key 0x00ff00ff (magenta), 69 without (run D2).
- `Blt` flags only DDBLT_WAIT (0x1000000) and DDBLT_WAIT|DDBLT_KEYSRC (0x1008000). No `Flip`,
  no `CreatePalette` at 32 bpp. Text is drawn with GDI on surfaces (`GetDC`/`ReleaseDC`,
  819 pairs in run D2) [I: GDI text].
- Gameplay frame order: dish background 500x420 to back buffer (282,50); amoeba sprites
  (11x11, 39x39, keyed); two panel parts (175x135 at (10,10), 180x30 at (5,145), keyed);
  back buffer to primary.

### Sound (DirectSound) [V: `traces/dsound_buffers.txt`]
- `DirectSoundCreate(NULL)`, `SetCooperativeLevel(hwnd, DSSCL_PRIORITY)`, primary buffer
  `SetFormat` PCM 2 ch 22050 Hz 16 bit.
- Secondary buffers: flags 0x000100e2 = STATIC|CTRLFREQUENCY|CTRLPAN|CTRLVOLUME|GETCURRENTPOSITION2.
- 11 game sounds (format inside Moeboid.gam), bytes: 10253, 10176, 6538, 32830, 3821, 1652,
  4513, 1932, 2029, 19993, 13572. All PCM mono 11025 Hz 8 bit, except 32830 bytes =
  8000 Hz 16 bit and 13572 bytes = 11025 Hz 16 bit.
- 3 shell sounds (format inside ZapSpot.exe): 480, 1692, 31863 bytes, PCM mono 11025 Hz 8 bit.
- Each play: `DuplicateSoundBuffer` + `Play(0,0,0)` (no loop flag). The engine sound thread
  replays for a loop count or releases the duplicate.
- The WAVEFORMAT pointers point to 16-byte `fmt ` chunks inside RIFF images (cbSize reads the
  next chunk id) [V: cbSize 0x6164 'da', 0x6166 'fa', 0x4150 'PA'].

## 5. Network attempts [V: `traces/startup_net_files_relay.txt`, `install_exit_files_relay.txt`]

Observed in runs N (first-run), I and X (installed), 20-110 s each, title and gameplay:
1. `WSAStartup(0x0101)` at start-up (0x40747c).
2. `LoadLibraryA("wininet.dll")`, `InternetGetConnectedState` returns 0 (offline) (0x40768e),
   `FreeLibrary`. The engine then stops: no proxy registry read, no DNS, no socket, no connect.
3. `WSACleanup` at exit.
4. `LoadLibraryA("WinInet.dll")` and `("Crypt32.dll")` at 0x4056c1: load, then free at once
   [V]; the result goes into the last two fields "1,1" of the OSInfo2 report [I].
No `ShellExecuteA/ExA` call in any traced run. No URL launch.

Not observed, static only [V: strings; I: use]: host `api.zapspot.com`;
`POST /1.0.0/%s.asp HTTP/1.0` and `POST http://%s/1.0.0/%s.asp HTTP/1.0` (proxy form);
`HKCU\...\Internet Settings` ProxyEnable/ProxyServer; imports `WSAAsyncGetHostByName`, `connect`,
`send`, `recv`, `WSAAsyncSelect`. Online path (after a connected state) reads the proxy key at
0x4076b4 [V: code].

Queued messages instead of network: `Outbox.zdt` gets `TrackEvent` (GameStarted,
SessionStarted, OSInfo2 "WinNT,6.2.9200,1024x768,32,DX5.1,1,1", GameStopped2 <seconds>,
SessionStopped <seconds>), `GetARBInfoA/B`, `GetShellGUID "01.01.01.1034"`
[V: `prefix_files/*/Outbox.zdt`]. MsgIDH and RegDate look like seconds since 2000-01-01 [I].

## 6. Files and registry created [V: `traces/registry_files_diff.txt`, relay extracts]

- First-run state: the engine reads `%APPDATA%\ZapSpot\System\Core.ZDT` and `Outbox.ZDT`
  (not found) and `eid-*.zdt` in the working directory (not found). It writes no file while it runs.
  Exit with "Dont Save, just Exit" was not observed (run N was killed).
- Install ("Install ZapSpot" link, or OK/Save in the save dialogs [I]) creates:
  - `Documents\My ZapSpot\moeboid.exe` (copy of argv[2])
  - `%APPDATA%\ZapSpot\ZapSpot.exe` (copy of the running engine)
  - `%APPDATA%\ZapSpot\Games\{2BFDD7F8-0EC4-4E7C-9FF4-3B2F8DC1D0F2}\{same}.gam` (copy of Moeboid.gam)
  - `%APPDATA%\ZapSpot\System\Core.zdt`, `Outbox.zdt`
  - `Desktop\ZapSpot.lnk` and `ProgramData\Microsoft\Windows\Start Menu\Programs\ZapSpot.lnk`
    (IShellLink; target `%APPDATA%\ZapSpot\ZapSpot.exe`, work dir `%APPDATA%\ZapSpot`,
    description "A Whole Lotta Fun!").
- Clean exit (installed) rewrites `Core.zdt` and `Outbox.zdt`. A killed engine writes nothing.
- `Core.zdt`: XML-like text: `<ZDT ver shellver><Users><User localid=0><Email>guest</Email>
  <RegDate>...<ZLS ownerid={GUID}><ZLSProp name="Score1Name" value=.../>...Score5Score,
  LastNameEntered</ZLS></User></Users><Zaplets/><Shell><DefaultUser localid=0/></Shell>`.
  Copies: `prefix_files/after_install/` (earlier agent), `after_highscore_tester/`,
  `after_installed_run_exit/`.
- Registry: the engine creates no key and writes no value. Imports only `RegOpenKeyExA`,
  `RegQueryValueExA`, `RegCloseKey`; the value diffs show only `Wine\Debug\RelayInclude` (written
  by `run_original.sh`) and Wine device keys. Registry writes at exit come from Wine msacm32.

## 7. Files in this folder

- `run_original.sh`, `xhelper.py`, `capture_session.py`, `bot_avoid.py`: run and drive the engine.
- `steps/`: step files of runs A-H (earlier agent), N, T, F2, I, X; `scheduler_dump.wdbg`
  (winedbg commands) and `decode_tasks.py` (decodes its output).
- `screens/`: curated screenshots (section 3). `traces/`: extracts (see `traces/README.md`).
- `prefix_files/`: ZDT files and the shortcut copied from the prefix.
- Local user name removed: `traces/` and `analysis/shell.md` write the Wine user folder as
  `C:\users\user`; `prefix_files/after_install/ZapSpot.lnk` uses `xx`, a placeholder of the same
  length, so the size, offset and string-length fields of the shortcut stay valid.
