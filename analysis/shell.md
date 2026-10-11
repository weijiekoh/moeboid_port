# Platform shell (workstream G)

Scope: everything the ZapSpot platform (`extracted/ZapSpot.exe`) shows or does outside the game logic of `Moeboid.gam`: main frame, shell pages, dialogs, message boxes, splash, help, high-score storage, Terms of Service, network, `.zdt` files, registry, command line. Pixel layout and colours of the frame are in `analysis/rendering.md` (workstream D); fonts in `analysis/fonts.md` (E); sounds and input in `analysis/audio-input.md` (F); the engine/game interface in `analysis/interface.md` and `analysis/interface.tsv` (B).

Labels: **verified** = read from code, data or a screenshot (reference given). **inferred** = conclusion with a reason. **unknown** = not determined.

Reference abbreviations:
- `Z:0x4xxxxx` = address in `extracted/ZapSpot.exe` (image base 0x400000). Decompiled C: `analysis/decomp/ZapSpot.exe/decompiled.c`, header `FUN_<address>`. Disassembly: `extracted/zap.asm`.
- `G:0x1xxxxxxx` = address in `extracted/Moeboid.gam`.
- `str N` = ZapSpot.exe string-table id N (`assets/ZapSpot.exe/decoded/strings.txt`).
- `capX/NN_name.png` = reference screenshot in the workstream I scratch directory `.../scratchpad/I/capX/`. Frame screenshots are 800x572 (the ZapSpot window); `*_desk*.png` are 1024x768 desktop captures.
- `K` = keep, `R` = remove, `L` = replace with a local implementation.

## 0. Summary of findings

1. The platform frame is custom-drawn (GIF images + the engine's own "ZML" text markup renderer). No Win32 menu, toolbar, tray icon or tooltip exists (verified: no MENU resource; no `TrackPopupMenu`, `Shell_NotifyIcon`, `TOOLTIPS_CLASS` import or string). The only native Windows UI is 8 dialog templates and `MessageBoxA` (section 3).
2. All network traffic goes to one HTTP-like endpoint: TCP port 80 of `api.zapspot.com` (fallback IP `216.46.233.11`), or through the IE proxy. Every request is `POST /1.0.0/<Function>.asp` with body `msg=<ShellGUID>,{00000000-0000-0000-0000-000000000000},<MsgIDH>,<MsgIDL>,<params>`. Functions: `Hello`, `TrackEvent`, `TrackEvent2`, `GetShellGUID`, `GetARBInfoB`, `UpdateShellVersion`, `SetUserProfile`, `GetUserGUID` (subscribe), `ZapZaplet` (Mail This, Zap Me A Game). Unsent messages queue in `Outbox.zdt`. The client never downloads games, ads or updates over the network: ad banners are built-in resources, games arrive by e-mail (section 5). Verified: no `GET` request string, no WinInet download import.
3. Telemetry runs without any user action: at every start the engine queues `SessionStarted`, `OSInfo2`, `GetARBInfoB`, `GameStarted` (reference `Outbox.zdt`).
4. High scores: 5 entries per game, stored as properties `Score1Name`..`Score5Name`, `Score1Score`..`Score5Score`, `LastNameEntered` in `Core.zdt` under `<ZLS ownerid="{2BFDD7F8-0EC4-4E7C-9FF4-3B2F8DC1D0F2}">`. No score is sent to the network. The original saves `Core.zdt` only when ZapSpot is "installed"; when it runs from the e-mail temp folder, high scores are lost at exit (section 2).
5. The Terms of Service dialog never opens by itself. It opens only from the "Terms of Service and Privacy Policy" link and from the `>>` button in two save dialogs (section 4).
6. `.zdt` files are XML-like text. The engine creates a default `Core.zdt` in memory when the file is missing; it needs no `.zdt` file to start or to run Moeboid (section 6).
7. The registry is read only: IE proxy settings and `ProgramFilesDir` (no registry write API is imported). Section 7.
8. `CoCreateInstance` creates `CLSID_ShellLink` {00021401-0000-0000-C000-000000000046} with `IID_IShellLinkA` {000214EE-0000-0000-C000-000000000046}, then `IPersistFile` {0000010B-0000-0000-C000-000000000046}: the desktop and Start-menu shortcut `ZapSpot.lnk` (verified, `Z:0x40a6da`, GUIDs at `Z:0x42e8b0`, `Z:0x42e8c0`, `Z:0x42e8d0`).

## 1. Engine structure and startup

Startup (verified, `Z:0x403d40` = WinMain):
1. Single instance: `FindWindowA("ZapSpot")`; if a window exists, `SendMessageA(hwnd, 0x7ed)`. The old instance replies with its "shutting down" flag (window procedure `Z:0x4040e0`, message 0x7ed). If the flag is 0, the old window is restored and brought to the front and the new process exits. If the flag is 1, the new process waits (up to 1000 x 250 ms) for the old window to close. Failure: message box "ZapSpot is having trouble running..." / "Can't stop other running ZapSpot" (`Z:0x403db0`).
2. Frame size 800x572 (`Z:0x4324a0` = 0x320, 0x23c). If the screen width is < 800, the frame is 640x460 with a different layout (`Z:0x403e06`, `Z:0x41d6c0` first branch). The port needs only the 800x572 layout (inferred: browser canvas size is free).
3. Screen saver: disabled while ZapSpot runs (`SystemParametersInfoA(SPI_SETSCREENSAVEACTIVE, 0)`, `Z:0x403e44`), restored at exit (`Z:0x404b25`). Port: R (no browser equivalent needed).
4. Splash: popup window 400x240 at the screen centre, bitmap `IMG-SPLASH`, then four lines in Arial, height -11, at x=90, y=172 + n * (tmHeight + tmExternalLeading) (verified, `Z:0x403f3b`..`Z:0x404054`):
   - "Copyright (c) 2000 ZapSpot, Inc.  All Rights Reserved."
   - "This program is protected by US and international copyright"
   - "laws.  ZapSpot, the ZapSpot logo, and Life is Good are"
   - "trademarks or registered trademarks of ZapSpot, Inc."

   The splash stays while `Z:0x413040` creates all subsystems, then it is destroyed (no fixed duration). The capture `capA/00_splash.png` is black (capture timing); the bitmap is `assets/ZapSpot.exe/decoded/BITMAP/IMG-SPLASH_0409.png`. The text is drawn by GDI with the system Arial, not by the engine font renderer.
5. `Z:0x413040` creates the subsystem singletons, loads `Core.zdt` and `Outbox.zdt`, queues the startup messages (section 5), sends `SendID` if an `eid-*.zdt` exists, queues `OSInfo2`, then the message loop `Z:0x404a30` runs. The main window is placed at the saved `WindowXLoc`/`WindowYLoc` (shell properties in `Core.zdt`) or centred in the work area (`SHAppBarMessage(ABM_GETTASKBARPOS)` subtracts the taskbar, `Z:0x4048be`). Window style 0x92080000 (`WS_POPUP|WS_VISIBLE|WS_CLIPCHILDREN|WS_SYSMENU`): no caption, the frame draws its own buttons.
6. Window title (taskbar text): "ZapSpot", then "ZapSpot - <game name>" when a game starts (`SetWindowTextA` at `Z:0x424841`). Port: L (`document.title`).
7. On `WM_CLOSE` the engine shuts down directly (`Z:0x4040e0` case 0x10 calls `Z:0x413270`; no dialog). The frame close button runs the quit dialogs (section 3.2).

Subsystem globals (verified, `Z:0x413085`..`Z:0x41315d`; role inferred from the strings each one uses):

| Global | Constructor | Role |
|---|---|---|
| `0x45cf9c` | `Z:0x403bb0` / `Z:0x404790`, vtable `Z:0x42e6b4` | OS / platform services (table below) |
| `0x45cfa8` | `Z:0x426e00`, vtable `Z:0x42f008` | ZDT data store (`Core.zdt`, `Outbox.zdt`), properties, TrackEvent |
| `0x45cfb0` | `Z:0x427130` | clock and main-loop tick; `+0x10`/`+0x14` set/get the pause flag (also set around every modal dialog) |
| `0x45cfb8` | `Z:0x4073a0`, vtable `Z:0x42e720` | network (Winsock, HTTP POST) |
| `0x45cfd0` | `Z:0x419a30` | outbox message queue |
| `0x45cfcc` | `Z:0x41acb0` | CShell: the custom-drawn frame and its pages |
| `0x45cfc8` | `Z:0x424250` | game (applet) host: `+0xc` start, `+0x10` stop, `+0x14` "game running" |
| `0x45cfa0` | `Z:0x426ce0` | video (DirectDraw); `+0x38` minimize |
| `0x45cfa4` | `Z:0x426910` | input dispatch |
| `0x45cfac` | `Z:0x4264f0` | files and resources, `*.gam` enumeration |
| `0x45cfbc` | `Z:0x425a00` | cursors |
| `0x45cfc0` | `Z:0x424b80` | event listeners (button callbacks) |
| `0x45cfc4` | `Z:0x408e00` | sound (DirectSound) |

Platform vtable `Z:0x42e6b4` (verified from `analysis/decomp/ZapSpot.exe/vtables.txt` and the code of each target):

| Offset | Function | Action |
|---|---|---|
| +0x00 | `Z:0x404b70` | `LoadStringA` (all shell texts come from the string table) |
| +0x04 | `Z:0x4049d0` | skin name "Default.skn" |
| +0x08 | `Z:0x404ba0` | window title |
| +0x0c | `Z:0x404bb0` | `ShellExecuteA(NULL, "open", url, ...)` |
| +0x10 | `Z:0x404bd0` | install ZapSpot (`Z:0x40a0e0`), then queue `GetShellGUID` |
| +0x14 | `Z:0x405400` | dialog `IDD_CONFIRM_SAVE` |
| +0x18 | `Z:0x405330` | dialog `IDD_QUIT_SAVED` |
| +0x1c | `Z:0x405390` | dialog `IDD_QUIT_NOTSAVED` |
| +0x20 | `Z:0x405330` | dialog `IDD_QUIT_SAVED` |
| +0x24 | `Z:0x405540` | dialog `IDD_TERMSOFSERVICE` |
| +0x28 | `Z:0x4055e0` | TrackEvent `OSInfo2` |
| +0x2c / +0x30 | `Z:0x404eb0` / `Z:0x404e40` | clipboard text get (max 1000 chars) / set. No caller in ZapSpot.exe found (scan of calls through `0x45cf9c`); Moeboid does not call them either (no clipboard entry in `analysis/interface.tsv`). |
| +0x34 | `Z:0x404cf0` | installed-copy update check (`Z:0x40aa50`) |
| +0x38 | `Z:0x404f40` | message box "More Games are on the Way!" (no caller found; inferred unused) |
| +0x3c | `Z:0x404a30` | message loop |
| +0x40 | `Z:0x4058c0` | message box for games and shell (`flags & 2` = OK/Cancel, `flags & 0x100` = exclamation icon) |
| +0x44 | `Z:0x405480` | input box (`flags & 2` = `IDD_INPUT_BOX` with Cancel, else `IDD_INPUT_BOX2`) |
| +0x48 | `Z:0x405770` | "installed" flag |
| +0x4c..+0x5c | `Z:0x4057c0`..`Z:0x405800` | ZapSpot folder, temp folder, launcher path, game file name |
| +0x60 | `Z:0x4058a0` | set "installed" = 1 (called when `Core.zdt` loads, `Z:0x426edb`) |
| +0x68 | `Z:0x405950` | `eid-*.zdt` / `SendID` |

"Installed" (verified): the flag is 1 when `Core.zdt` was found at startup (`Z:0x426e90`) or after the install action (`Z:0x404bd0`). It controls: saving of `Core.zdt`/`Outbox.zdt`, the "Install ZapSpot" link, the quit dialogs, ad rotation length, `DefaultIP` storage. **Port: behave as installed at all times** (inferred from requirement 5: local high scores must persist).

## 2. High scores

### 2.1 What the user sees (verified)

- The title screen table "Top Moeboids" (5 rows, name, dot leader, score with thousands separator) is drawn by the game, `G:0x10004640` (`capA/01_title_b.png`, `capH/53_after_no_00.png`). Default table when `Score1Name` is missing: ZapSpot 10000, 5000, 2500, 1000, 500 (`G:0x10004656`..`G:0x10004731`, strings `G:0x1000e988`..).
- The engine has a rail button "High Scores" (str 10015, `Z:0x41bf7c`), not shown for Moeboid: the game sets the rail mask `CShell+0x378` = 0x33 (`analysis/interface.tsv`, ISystem +0x10, `G:0x10001729`) and bit 0x04 is clear (four rail buttons in `capA/01_title_b.png`). Its callback is `Z:0x41cb30`, the same as Pause (registration `Z:0x41bfa9`). Port: R (Moeboid never shows it).
- Name entry: engine dialog `IDD_INPUT_BOX2`, caption "Congratulations", text "You got a high score! Survival of the fittest at it's best.  Please enter your name:", edit control prefilled with `LastNameEntered` or "Name" (`G:0x1000e604`), text selected, one "OK" button (`capH/51_highscore_dialog.png`, `capH/51_highscore_dialog_typed.png`). The game calls it with flags 1 (`G:0x100038ab`, call `G:0x100038c3`), so no Cancel button. The game pauses (the engine sets the pause flag around every modal dialog, `Z:0x405480`).
- After entry the title table shows the new row (`capH/53_after_no_00.png`: "tester ... 10"; the test prefix had `Score5Score` = 0, `capE/30_title_mod_table.png`).

### 2.2 Rules (verified, `G:0x100037d0`)

1. Qualification: for i = 1..5, read `Score<i>Score`, convert with `atoi`-like `G:0x100056e2`; the first i with `current >= stored` is the insert position (`G:0x1000381f` `cmp ecx,eax; jge`). If no i qualifies, no dialog. A tie inserts above the old entry. A missing property reads as "" (= 0, `Z:0x4296d5`).
2. Name dialog: `GetDlgItemTextA(..., 0x10)` returns at most 15 characters (`Z:0x405004`). If the length is >= 13 (`G:0x100038d3`), the game shows message box "Name too long" / "We're sorry, but names must be 12 letters or smaller." (OK, exclamation icon) and opens the dialog again with the previous default (not the typed text). An empty name is accepted. Enter = OK. Esc sends `IDCANCEL` (Windows dialog manager), the dialog proc ends the dialog without reading the edit control (`Z:0x405221`), so the name is empty (inferred from code; not captured).
3. Store: `LastNameEntered` = name; rows i..4 move down one place (row 5 is dropped); row i = name, `itoa(score)` (`G:0x1000392f`..`G:0x10003a30`).
4. No character filter, no case change (verified: "tester" stays lower case). Names are stored as raw bytes in `Core.zdt` (no escaping found in the save code; inferred risk: a name with `"` or `<` may corrupt the file).

### 2.3 Storage (verified)

- Game properties live in `Core.zdt`, element `<ZLS ownerid="<game GUID>">`, children `<ZLSProp name="..." value="..."/>` (reference file `analysis/reference/prefix_files/after_install/Core.zdt`). Moeboid GUID `{2BFDD7F8-0EC4-4E7C-9FF4-3B2F8DC1D0F2}` (`G:0x10040cfe`).
- Engine get: `Z:0x4294f0` (returns 0x19 and "" when missing); set: `Z:0x429710`.
- `Core.zdt` is written only if "installed" (`Z:0x40c870`, `Z:0x426f40`): at shutdown and after some shell actions (install, subscribe and `GetShellGUID` replies). A property set (`Z:0x429710`) changes only memory (verified: no file call among its callees). A crash or a killed process loses the session's scores.
- Network: no score submission exists (verified: no score string in any network message; the TrackEvent list in 5.4 has none).

### 2.4 Local replacement (requirement 5)

The port must provide:
- A per-game string property store (get returns "missing" for absent keys, so the game seeds the default table) and a per-user/shell store (sound flag). Size < 1 KB. Browser `localStorage` is sufficient (inferred).
- Write-through on every set (inferred: a browser tab can close without a shutdown event; the original's save-at-exit would lose scores).
- The name dialog with the rules in 2.2 (12-character limit message, default "Name"/last name, OK only).
- The game draws the table itself; no engine high-score screen is needed.

## 3. User-visible catalogue

### 3.1 Main frame (800x572, `Z:0x41d6c0` second branch; `capA/01_title_b.png`)

| Element | Position (frame px) | Text / image | Handler | Class | Reason |
|---|---|---|---|---|---|
| Background | full | colour #3333CC (`Z:0x41d80a`) | - | K | requirement 8 |
| Game area border | (190,13) | `IMG-GAMEAREA.GIF` | - | K | frame |
| Page title bar | (278,20) 400x24 | game name ("Moeboid" + `IMG-TM.GIF`) or page title | - | K | frame |
| Game / page surfaces | (282,50) 500x420 | game or shell page | - | K | - |
| Logo | (10,10) | `IMG-ZAPLOGO.GIF`, link text "www.ZapSpot.com" (y=114) | About page `Z:0x420d80` (inferred from callback push `Z:0x41e216`) | K | local page only, no URL is opened |
| Menu item 1 | (5,145) | str 10000 "View All Games", home icon `IMG-HOME.GIF` | `Z:0x41f500` | decision D1 | game list = downloads menu |
| Menu item 2 | (5,180) | str 10001 "Personalize ZapSpot" | `Z:0x422b90` | K (page reduced, 3.3) | requirement 8 |
| Menu item 3 | (5,215) | str 10002 "About ZapSpot" | `Z:0x420d80` | K (page reduced, 3.3) | requirement 8 |
| News text | (52,294) | str 10003 "Coming Soon...  ZapSpot news and messages." | - | K (static) | no network involved |
| Help button "?" | (705,9) 26x26 | `SLB-LILBTNICONS` icon 0 | help page 101, `Z:0x41c4c0` | K | - |
| Minimize "_" | (734,9) | icon 1 | `Z:0x41c6f0` (video +0x38) | decision D4 | no browser equivalent |
| Close "X" | (763,9) | icon 2 | `Z:0x41c830` (quit dialogs, `CloseShell.wav`) | decision D4 | browser cannot close the tab |
| Frame drag | 10-px border | cursor change, window move, saves `WindowXLoc`/`WindowYLoc` | `Z:0x41c190`, `Z:0x41c230`, `Z:0x41c290`, `Z:0x408cc0` | R | page is fixed |
| Game rail | x=1 of rail, y=85 + 67n, 46x46 | see 3.1.1 | - | K partly | - |
| Subscribe box | (11,382) | `IMG-GETZAPPEDBLOCK.GIF`, str 10004, 10005, e-mail edit (25,444), arrow button (196,439) | `Z:0x423770` | R | network (subscription) |
| Offline prompt | (20,470), (20,482) | str 10018, str 10019 | - | R | "install" concept removed |
| Install link | (70,500) | str 10007 "Install ZapSpot" | `Z:0x41cc70` | R | creates files and shortcuts |
| ToS link | (31,526) | str 10008 "Terms of Service and Privacy Policy" | `Z:0x41cb20` | decision D2 | section 4 |
| Ad caption | (280,486) | str 10009 "Please support our advertisers..." | - | R | requirement 9 |
| Ad banner | (280,500) 470x62 | rotating banners | section 5.6 | R, area blank | requirement 6 |
| Pause overlay | page surface (50,185) | str 10016 "Resume your game using the button to the left" | `Z:0x41cb30` (string `Z:0x41cbc0`) | K | `capD/21_pause.png` |
| Paused footer | page surface, separator lines y=380/381 | str 10017 "Your game is currently paused.  Jump out and go back to your game?" + arrow button | drawn by `Z:0x41b290` (string `Z:0x41b315`) on every shell page while a game runs; arrow returns to the game | K | `capB/06_mail_this.png` |

When "installed", the offline prompt and the install link are not drawn and the rectangle (34,474)-(194,522) is filled with #3333CC (`Z:0x41f16d`, verified in `capC/08_install.png`).

#### 3.1.1 Game rail (`Z:0x41b9b0`)

Buttons from top to bottom; a button is shown when its bit in `CShell+0x378` is set (verified, `Z:0x41ba7f` `test [esi+0x378],0x20; je`). Moeboid sets 0x33 (`analysis/interface.tsv`, ISystem +0x10). Only shown buttons advance y by 67 (`Z:0x41bb0d`); a removed button is overdrawn with #000099 (`Z:0x41bb46`). Images: `SLB-BIGBTNBACKS-HC.GIF`, `SLB-BIGBTNICONS.GIF` (icons: mail, new game, pause, resume, speech bubble). Label under each button in the ZML link style.

| Bit | Label | Handler | Class |
|---|---|---|---|
| 0x20 | str 10010 "Mail This" | `Z:0x420150` (Zap to a Friend page) | R (network). Note: clearing the bit moves the other buttons up 67 px (decision D3) |
| 0x01 | str 10011 "New Game" | `Z:0x41c910` | K |
| 0x02 | str 10012 "Pause" / str 10013 "Resume" | `Z:0x41cb30` (toggle) | K |
| 0x10 | str 10014 "How To Play" | `Z:0x41c3f0` (pauses, page title str 2400, game draws its help) | K |
| 0x04 | str 10015 "High Scores" | `Z:0x41cb30` | not shown for Moeboid (bit clear) |

Keys handled by the frame (`Z:0x4040e0`): Esc pauses a running game and minimizes the window ("hide from the boss", str 113). Window deactivation (`WM_ACTIVATE`) auto-pauses a running game (both in `Z:0x4040e0`). Port: Esc = pause only (decision D4); tab blur = pause (L, `visibilitychange`/`blur`).

### 3.2 Native dialogs (8 templates, `assets/ZapSpot.exe/decoded/DIALOG/*.rc`; dialog proc `Z:0x404f60` for all except DUMPINFO)

All use MS Sans Serif 8 pt, DLU 6x13 at 96 DPI. Return codes in `0x4362e8`: 0x7d2 (OK/Yes) = 0, 0x7d1 (No/Keep Playing) = 1, 0x7d3 (Save And Exit) = 2, 0x7d4 (Cancel/Dont Save) = 3, `IDOK` = 1, `IDCANCEL` = 2.

| Template | Caption | Controls | Opened by | Effect | Class |
|---|---|---|---|---|---|
| `IDD_INPUT_BOX2` | set by caller ("Congratulations") | static 1002 (prompt), edit 1003, OK | game, `Z:0x405480` | name entry (2.2) | K (L as page dialog) |
| `IDD_INPUT_BOX` | set by caller | static, edit, OK, Cancel | games with flag 2 | not used by Moeboid (inferred: Moeboid passes flag 1 only) | R |
| `IDD_TERMSOFSERVICE` | "ZapSpot Terms of Service and Privacy Policy" | read-only multiline edit 2005 (ToS text), checkbox 2006, static, OK 2002 | ToS link; `>>` in two save dialogs | section 4 | decision D2 |
| `IDD_QUIT_SAVED` | "Warning: Game in Progress" | static "Do you want to leave the game you are currently playing?", Yes 2002, No 2001 (default) | New Game or View All Games while a game is in progress (`Z:0x41b4d0`, called from `Z:0x41c943`, `Z:0x41f54a`); close button while a game is in progress and installed (`Z:0x41b580`) | Yes stops the game and continues, No returns to the game | K (New Game), D4 (close) |
| `IDD_QUIT_NOTSAVED` | "Play Again Soon" | 2 statics, `>>` 2007 (opens ToS), "Keep Playing" 2001, "Dont Save, just Exit" 2004, "Save And Exit" 2003 (default) | close button when not installed (`Z:0x41b580`) | Save And Exit installs | R (always installed) |
| `IDD_CONFIRM_SAVE` | "Save to Desktop Requested" | 2 statics, `>>` 2007, OK 2002, Cancel 2004 | sound Toggle or proxy Apply when not installed (`Z:0x4234ea`, `Z:0x42370b`) | OK installs | R |
| `DUMPINFO` / `DUMPINFO2` | "Unexpected Error Occurred" | statics, "Copy to Clipboard" 2008, `>>`/`<<` 2010/2011, "Close ZapSpot" 1, edit 2009 (report) | unhandled exception filter `Z:0x405c30` (registered at `Z:0x405c03`) via `Z:0x406200`, `Z:0x4070d0` | copies a crash report (OS info, file lists, `.zdt` contents) to the clipboard (`Z:0x406fa0`), message box "Thank you for your help" | R |

### 3.3 Shell pages (drawn in the game area with ZML text, title in the title bar)

| Page | Code | Content (strings) | Class | Reason |
|---|---|---|---|---|
| View All Games | `Z:0x41f500`, tiles `Z:0x41fdf0`, `Z:0x423d10` | str 1200 title, str 1201 "My ZapSpot", one tile per `*.gam` file in the ZapSpot folder, then promo tiles for not-installed games (ColorBreak, SortSport, Peh Pai, BubbleBound, ColorCode, FenceOut; images `IMG-PREVGAMELOGO-*.GIF`, table `Z:0x435120`), "Coming soon" tile `TXT-COMINGSOON-LOGO.GIF` when < 5 tiles, colour key str 1203-1205 (`capA/03_view_all_games.png`) | decision D1 | promo tiles = downloads |
| Zap Me A Game | `Z:0x4214b0`, send `Z:0x421820` | str 2000-2003, e-mail edit, Send/Cancel (str 20000, 20001); opened by a promo tile | R | network + downloads |
| Zap %s to a Friend (Mail This) | `Z:0x420150`, send `Z:0x420760` | str 2200-2205, From/To/Message edits, Send/Cancel (`capB/06_mail_this.png`); also opened by ad banner 1 | R | network |
| Subscribe to ZapSpot | `Z:0x423770`, result `Z:0x423ad0` | str 2300-2310 (`capC/10_subscribe_empty.png`) | R | network |
| Install ZapSpot | `Z:0x41cc70` | str 2500, str 2501 "ZapSpot has been saved to your desktop" (`capC/08_install.png`) | R | creates files |
| Personalize ZapSpot | `Z:0x422b90` | str 1101 (text, link 10000), str 1102-1105 sound On/Off + Toggle (`Z:0x423260`), str 1106-1108 proxy Server/Port + Apply (str 20002, `Z:0x423540`) (`capA/04_personalize.png`) | K sound part; R text link and proxy | proxy = network |
| About ZapSpot | `Z:0x420d80` | str 1001 (links 20002 help, 20000 security, 10000-10002 URLs), "v%d.%d" grey at (470,5) = "v1.1", McAfee button (394,328) `IMG-MCAFEE.GIF` that opens the Security page (`Z:0x421020`) (`capA/05_about.png`) | K with links inert or text edited (decision D5) | URLs = network |
| Security precautions | `Z:0x421040` | str 1002-1004, links 10004, 10005, buttons `IMG-MCAFEE.GIF` (McAfee URL + TrackEvent `AdBannerClicked`) and `IMG-VERISIGN.GIF` (VeriSign URL), handler `Z:0x421420` | decision D5 | URLs, telemetry |
| ZapSpot Help | `Z:0x41c4c0` | str 100 title, pages str 101 (contents), 111-118; link ids 101/111-118 change page; 118 "Extended Support Information" adds values after the labels (inferred from the strings "Installed", "Not Installed", "<S2>%s" in `Z:0x41c4c0`) (`capC/09_help_button.png`) | K, text decision D5 | text describes Mail This, subscribe, install |
| How To Play | `Z:0x41c3f0` | str 2400 title; the game draws `HELP.ZML` (`capA/02_how_to_play.png`) | K | game content |
| Coming Soon! | `Z:0x4214b0` (string loads `Z:0x4215be`, `Z:0x4215e7`) | str 2100, 2101; inferred: shown for the "Coming soon" tile | R | promotes subscription; tile removed |
| Low-resolution note | str 1206-1209 | 640x460 layout only | R | port uses 800x572 |

Hyperlinks inside ZML pages (`Z:0x41c700`, verified): 10000 `www.zapspot.com`, 10001 `www.zapspot.com/jobs`, 10002 `www.zapspot.com/partners`, 10003 `www.zapspot.com/support`, 10004 `http://www.mcafee.com/ZapSpot`, 10005 `https://digitalid.verisign.com/as2/ad22220c0f5c11772d39911f24517336` (all `ShellExecuteA`), 20000 security page, 20001 About (`Z:0x420d80`), 20002 help contents, other ids = help page id.

### 3.4 Message boxes (`MessageBoxA` call sites, verified)

| Site | Caption / text | When | Class |
|---|---|---|---|
| `Z:0x403db0` | "ZapSpot is having trouble running..." / "Can't stop other running ZapSpot" | second instance cannot stop the first | R |
| `Z:0x405911` | caller text | game message boxes (Moeboid: "Name too long"), "Game Not Found" (`Z:0x41cb02`, str at `Z:0x434f70`) | K for "Name too long"; R for "Game Not Found" (one built-in game) |
| `Z:0x404f52` | "More Games are on the Way!" | no caller found | R |
| `Z:0x40705f` | "Thank you for your help" | crash report copied | R |
| `Z:0x407cbf`, `Z:0x40b38a` | "Internet Connection Required" / "ZapSpot requires an internet connection to proceed.\nPlease make sure you are connected before proceeding." (OK/Cancel) | a ForceConn message (Mail This, Zap Me, Subscribe) without connection | R |
| `Z:0x408b78`, `Z:0x428c12` | "ZapSpot does not yet support dynamic display depth changes" / "We're sorry, ZapSpot does not yet support changing the display depth while running..." | display mode change | R |
| `Z:0x40a2a9`, `Z:0x40ac25` | "Oops" (empty caption) | install: no AppData and no ProgramFilesDir | R |
| CRT `Z:0x401d5e` | "Microsoft Visual C++ Runtime Library" | CRT fatal error | R |

`Error()`, `Warning()`, `Info()` (`Z:0x413390` and exports) write to `OutputDebugStringA` only; they show no window (verified). Example: with < 8 bpp the engine logs "Unavailable resolution" / "ZapSpot requires a screen resolution of 8bpp or greater..." and exits without a message (`Z:0x4082aa`..`Z:0x4082be`).

The launcher `moeboid.exe` (not ported) has its own message box "Warning - Game must be closed" / "ColorBreak needs to be closed to run this game..." (`moeboid.exe:0x4011cc`) and asks a running ZapSpot to close with message 0x7eb (`moeboid.exe:0x401207`, handled in `Z:0x4040e0` by the quit dialogs `Z:0x41b6b0`).

### 3.5 Other platform features

| Feature | Facts | Class |
|---|---|---|
| Clipboard | crash report (`Z:0x406fa0`); text get/set in the platform vtable (+0x2c/+0x30), unused by Moeboid | R |
| `SHAppBarMessage` | `ABM_GETTASKBARPOS` only, to centre the window (`Z:0x4048be`) | R |
| Tray icon, tooltips, status bar, menus | none exist (verified: no import or resource) | - |
| Desktop shortcut prompt | none: the install action creates `ZapSpot.lnk` without a question; `IDD_CONFIRM_SAVE` and `IDD_QUIT_NOTSAVED` ask before install from Personalize and quit | R |
| Cursors | `Pointer.cur` default, `Hand.cur` on links/buttons, others (see `audio-input.md`) | K |
| Shell sounds | `OpenShell.wav` (start), `CloseShell.wav` (close button), `BtnClick.wav`, `Popup.wav` (`Z:0x41b170`, `Z:0x41c830`) | K (see `audio-input.md`) |

## 4. Terms of Service dialog

When it appears (verified): only from (a) the frame link str 10008 (`Z:0x41cb20`, `capC/07_terms_dialog.png`) and (b) the `>>` button (2007) in `IDD_QUIT_NOTSAVED` and `IDD_CONFIRM_SAVE` (`Z:0x4051f1`). No first-run or per-start display exists: the only callers of platform +0x24 are these two (`Z:0x41cb28`, `Z:0x4051f1`), and the first reference run shows the title screen directly (`capA/01_title_b.png`). No flag records that the user has seen it.

Text source (verified): RCDATA `TERMSOFSERVICE`, 15418 bytes, plain text, CRLF (`Z:0x405568` loads it through the resource file subsystem; `assets/ZapSpot.exe/decoded/RCDATA/TERMSOFSERVICE_0409.utf8.txt`). It is put into edit 2005 with `SetDlgItemTextA` (`Z:0x405263`).

Controls (`IDD_TERMSOFSERVICE`, DIALOGEX 279x170 DLU = 419x276 client px): read-only multiline edit with vertical scroll bar (8,11,399x138 px), auto-checkbox 2006 with three-line label "Yes, I would like to receive special offers, advertisments, and promotions from ZapSpot based on my usage. (If you uncheck this option, ...)", static "ZapSpot respects your online privacy...", button "&OK" (152,245,110x26). No Cancel; no system menu.

Effects (verified, `Z:0x404f60`):
- Init: checkbox checked unless user property `OptOut` = "Yes".
- OK: `OptOut` = "No" (checked) or "Yes" (unchecked). If unchecked and not installed: install, save, redraw the subscribe box. Then queue `SetUserProfile` with "WantCustomOffers,1" or "WantCustomOffers,0" (network, priority 5).
- There is no decline: OK is the only exit; the dialog does not gate play.

Cost to keep in the port (inferred):
- The port needs a Windows-style dialog anyway for the high-score name entry (`IDD_INPUT_BOX2`) and the "Name too long" message box: caption bar, 3D frame, MS Sans Serif 8 pt bitmap text (from `fonts.md`), push button, single-line edit. That part is shared.
- Extra for ToS: a read-only multi-line text box with word wrap at 399 px and a vertical scroll bar (mouse wheel, arrows, thumb drag), and a checkbox with a multi-line label. With HTML elements (`<textarea readonly>`, CSS for the classic look) the extra cost is S. A pixel-exact canvas version of the Win9x scroll bar and edit word wrap is M.
- Note: the exact look of native dialogs depends on the Windows version and theme; the Wine captures show Wine's theme. No single "original" pixel image exists for them.

Recommendation: keep the dialog (S, HTML-based, classic Windows look, bitmap MS Sans Serif). Remove the checkbox and the `SetUserProfile` message, because the checkbox only controls ad targeting (requirement 9). Keep the text unchanged (it is a historical legal text; it describes data collection that the port does not do). Decision D2 for the user: keep as recommended / keep text but add a port note / remove the link and dialog.

## 5. Network

### 5.1 WSOCK32 ordinals (verified: export table of Wine `tools/wine/lib/wine/i386-windows/wsock32.dll`)

| Ordinal | Name | Call sites |
|---|---|---|
| 3 | closesocket | `Z:0x4074c1`, `Z:0x4075a7` |
| 4 | connect | `Z:0x407b5f` |
| 9 | htons | `Z:0x407b4f` |
| 16 | recv | `Z:0x40758f`, `Z:0x40b594`, `Z:0x40b6b0` |
| 19 | send | `Z:0x40b502` |
| 22 | shutdown | `Z:0x40b2d9` |
| 23 | socket | `Z:0x407aeb` |
| 101 | WSAAsyncSelect | `Z:0x407b0b` (window message 0x7ea, events 0x33 = READ, WRITE, CONNECT, CLOSE) |
| 103 | WSAAsyncGetHostByName | `Z:0x4078f4`, `Z:0x407919` (window message 0x7e9) |
| 111 | WSAGetLastError | `Z:0x407b6a`, `Z:0x40b50e`, `Z:0x40b59b` |
| 115 | WSAStartup (version 1.1) | `Z:0x407477` |
| 116 | WSACleanup | `Z:0x4074c6` |

Other network-related code: `wininet.dll!InternetGetConnectedState` loaded at run time (`Z:0x407676`) only to test the connection; `WinInet.dll` and `Crypt32.dll` are loaded only to report presence in `OSInfo2` (`Z:0x4056c1`). No other socket or HTTP API exists (verified, `imports.tsv`). `Moeboid.gam` has no network import; its only URL strings (`www.verisign.com/...`, `http://www.zapspot.com`) are inside its Authenticode certificate (verified, `strings`; inert data).

### 5.2 Connection (verified, `Z:0x407430`, `Z:0x407640`, `Z:0x407ad0`, `Z:0x407a30`, `Z:0x407d20`)

Trigger: the network object is created at startup (`Z:0x4130fc`); its constructor calls `WSAStartup` and starts the connection at once. No user action is needed.
1. `InternetGetConnectedState`; if offline, stop (messages stay queued). Reference run without network (workstream I trace `analysis/reference/traces/startup_net_files_relay.txt`): `WSAStartup(0x101)`, `LoadLibraryA("wininet.dll")`, `InternetGetConnectedState`, then no `socket`, `connect` or DNS call.
2. Proxy: `HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings` `ProxyEnable`, `ProxyServer` ("host:port", default port 80); or the shell property `DefaultProxyServer` (`Name`, `Port`) set on the Personalize page.
3. Resolve `api.zapspot.com` (or the proxy host) with `WSAAsyncGetHostByName`. Until the answer arrives the client uses `216.46.233.11`, or the shell property `DefaultIP` when installed.
4. TCP socket, non-blocking, `connect` to port 80 (or the proxy port).
5. After connect, it sends `Hello` (type 7). The reply status: 0 = OK, flush the outbox; 1 = use the IP in the reply; 2 = use the IP in the reply and store it as `DefaultIP` (`Z:0x407d20`).
6. HTTP/1.0 behaviour: the server closes the connection after a reply (`FD_CLOSE`, `Z:0x4074f0`); the next send reconnects first (`Z:0x40b2e0`, flag +0x426) (inferred from the flags; not observed).

### 5.3 Request and reply format (verified, `Z:0x40b2e0`, `Z:0x40b820`)

Request (sent with one `send`):
```
POST /1.0.0/<Function>.asp HTTP/1.0\nContent-type: application/x-www-form-urlencoded\nContent-length: <n>\n\n<body>
```
Through a proxy: `POST http://<server IP>/1.0.0/<Function>.asp HTTP/1.0...`. Line ends are `\n` only. Body:
```
msg=<ShellGUID>,{00000000-0000-0000-0000-000000000000},<MsgIDH>,<MsgIDL>,<params>
```
- `ShellGUID` = string at `CShell+0x3b4`, set from the `GetShellGUID` reply and stored as shell property `ShellGUID` (`Z:0x41f2a0` case 3).
- `MsgIDH` = seconds since 2000-01-01 00:00:00 UTC; `MsgIDL` = (low byte of a message counter) + 256 x `timeGetTime()`, masked to 31 bits (`Z:0x419c60`, `Z:0x427540`). The epoch is `mktime(2000-01-01 00:00 local)` (stored at `Z:0x427246`), and the time-zone bias is added back (`Z:0x427599`), so the value is UTC-based (DST effects not checked). Check: reference `RegDate` 845047641 = 2026-10-11 15:27:21 UTC, the day of the reference run.
- Params are joined with `,`. Mail This text is URL-encoded for space and newline, and `"` is escaped (`Z:0x420760`).

Reply: the client reads the reply with one `recv` into a 5000-byte buffer, searches the text `ZAPSRV_`, takes status = (byte[10] - 0x33) * 16 + byte[11] and the payload from byte 13 (`Z:0x40b820`). The exact server header format is unknown (only this parser exists).

### 5.4 Message catalogue (verified call sites; "auto" = sent without user action)

Queue: `Z:0x419c60(type, function, params, forceConn, priority)` tries to send at once; if the result is "not connected" (0x1c), "user declined" (0x1d) or "would block" (0x1e) it appends a `<Message>` to `Outbox.zdt` (`Z:0x419df0`). Queued messages are re-sent after the next successful `Hello` (`Z:0x419bb0`) and at startup (`Z:0x426ff0`). Replies are dispatched by type in `Z:0x41f2a0`.

| Type | Function | Trigger | Params | Reply use |
|---|---|---|---|---|
| 7 | `Hello` | auto, every connect | - | server redirect (5.2) |
| 1 | `TrackEvent` | auto; events below | `<seconds since 2000>,<event>,<args>` | none |
| 1 | `TrackEvent2` | auto, `SendID` when an `eid-*.zdt` is next to the game | `<time>,SendID,<number (unknown)>,<eid>` | none |
| 9 | `GetARBInfoB` | auto, every start (`Z:0x41317b`, priority 9) | "" | "a,b" stored at `0x45e3e8`, `0x45dffc`; enables the text banner (5.6); meaning inferred from the banner strings: affiliate name |
| 3 | `GetShellGUID` | auto after install (`Z:0x404bd0`; reference outbox) and on reply failure; a start-time path exists in `Z:0x426ff0` (condition not fully analysed) | shell version "01.01.01.1034" | stores `ShellGUID`, `ShellLastVerSentToServer` |
| 5 | `UpdateShellVersion` | auto at start if `ShellLastVerSentToServer` < running version | version | - |
| 8 | `SetUserProfile` | ToS dialog OK | "WantCustomOffers,1" or ",0" | - |
| 2 | `GetUserGUID` | Subscribe (e-mail must contain `@` and `.`, no space or comma) | e-mail | duplicate / received / error page (str 2305-2310) |
| 4 | `ZapZaplet` | Mail This "Send" (forceConn) | 4 fields `%s,%s,%s,%s` (from, to list with `,` replaced by `;`, URL-encoded message, game) (field order inferred) | str 2205 / 20006 |
| 6 | `ZapZaplet` | Zap Me A Game "Send" (forceConn) | 3 fields `%s,%s,%s` (e-mail, game) | str 2003 / 20006 |

TrackEvent events (verified call sites of store +0x38):

| Event | Args | Trigger |
|---|---|---|
| `SessionStarted` | start time | every start (`Z:0x4131ae`) |
| `SessionStopped` | session seconds | exit (`Z:0x4132dd`) |
| `OSInfo2` | platform (Win95/Win98/WinNT), version, resolution, bit depth, DirectX version, WinInet 1/0, Crypt32 1/0 | every start (`Z:0x405753`) |
| `StartupInfo` | connected flag | first socket event (`Z:0x40754d`) |
| `GameStarted` | game GUID, time | game start (`Z:0x42486f`) |
| `GameStopped2` | play seconds, game GUID | game stop (`Z:0x4249d6`) |
| `DiagCode` | code, value | play time > 36000 s, outbox anomalies (`Z:0x4249b1`, `Z:0x427030`) |
| `AdBannerTime` | banner GUID, display time | each banner rotation when installed (`Z:0x4220a5`) |
| `AdBannerClicked` | banner GUID, connected flag | banner click when installed (`Z:0x422426`); also the McAfee/VeriSign buttons with GUID {26A52249-5C78-450E-A988-B634559AF93A} (`Z:0x42146d`) |

### 5.5 Reference `Outbox.zdt` (verified, `analysis/reference/prefix_files/after_install/Outbox.zdt`, decoded)

Five queued messages from one offline run, all for user `localid="0"`:
1. TrackEvent `845047642,GameStarted,{2BFDD7F8-0EC4-4E7C-9FF4-3B2F8DC1D0F2},845047642`, priority 0.
2. TrackEvent `845047642,SessionStarted,845047641`, priority 0.
3. TrackEvent `845047642,OSInfo2,WinNT,6.2.9200,1024x768,32,DX5.1,1,1`, priority 0.
4. MsgType `GetARBInfoA`, Function `GetARBInfoB`, empty params, priority 9.
5. MsgType `GetShellGUID`, params `01.01.01.1034`, priority 12 (MsgIDH 845047644: queued after the install click).

`MsgIDL` values 11802880..12359174 = timeGetTime() x 256 + counter (consistent with 5.3).

### 5.6 Ad banners (verified, `Z:0x421bf0`, `Z:0x421ef0`, `Z:0x4223d0`, tables at `Z:0x4354ac`, `Z:0x4354d0`, `Z:0x4354f4`)

All banner images are built-in resources; nothing is downloaded. Rotation order (index, image, click target):

| # | Image | Click | GUID |
|---|---|---|---|
| 0 | `GETZAPPED.GIF` | About page | {788F0025-D602-443F-A0EC-9D9CAAAC160C} |
| 1 | `ZAPFRIEND.GIF` + text "Mail <game> to a friend" (`Z:0x4221e0`) | Mail This page | {490D86F0-A346-4D77-88F9-CCEE271892EB} |
| 2 | text banner "Hello %s." / "Earn $1 for every new ZapSpot subscriber from %s." (`Z:0x4224a0`), only after a `GetARBInfoB` reply | `http://www.zapspot.com/Affiliate` | {6E2060C5-7A10-4D03-ADAC-C9C2C2A0D2F6} |
| 3 | `MCAFEE.GIF` | `http://www.mcafee.com/zapspot` | {F6769DF4-7D3B-4C4C-A9D8-474E0BC1EB4F} |
| 4 | `ANI-ADBANNER1.GIF` | `http://service.bfast.com/bfast/click?bfmid=8188256&siteid=30189225&bfpage=homepage` | {55CF3953-C84A-48DE-8FB5-714B51BACFC1} |
| 5 | `ANI-ADBANNER2.GIF` | `...bfmid=5647408&siteid=29904199&bfpage=people550` | {6D9B148C-2624-43DE-BB59-7A06A6D87229} |
| 6 | `ANI-ADBANNER3.GIF` | `...bfmid=6902732&siteid=29904196&bfpage=home` | {A1C47439-47FE-4419-9944-264949BD2879} |
| 7 | `ANI-ADBANNER4.GIF` | `...bfmid=18604168&siteid=29939123&bfpage=homepage` | {9EEAADE3-0181-4903-BB5D-157F7EAB0B4B} |
| 8 | `ANI-ADBANNER5.GIF` | `...bfmid=115759&sourceid=29626398&categoryid=auto` | {9151B780-7683-4C6F-8D38-CE53D4D2B1D9} |

Rotation count: 8 (`Z:0x4354a8`); 9 when installed; +1 after a `GetARBInfoB` reply; index 2 is skipped while no affiliate data exists. Clicking a URL banner pauses the game and calls `ShellExecuteA`. Port: R; the banner rectangle stays blank (requirement 6).

### 5.7 Every `ShellExecuteA` URL (verified; all through platform +0x0c, `Z:0x404bc4`)

`www.zapspot.com`, `www.zapspot.com/jobs`, `www.zapspot.com/partners`, `www.zapspot.com/support`, `http://www.mcafee.com/ZapSpot`, `https://digitalid.verisign.com/as2/ad22220c0f5c11772d39911f24517336` (ZML links, `Z:0x41c700`); `http://www.mcafee.com/ZapSpot` and the VeriSign URL (Security page buttons, `Z:0x421420`); banner URLs of 5.6 (`Z:0x42248b`); one more caller `Z:0x41c37f` (generic link callback `Z:0x41c370`) and `Z:0x421c52` (banner object). The verb is "open".

### 5.8 How the port removes the network (requirement 9)

The port reimplements the shell, so the network code is not ported:
- No socket, `fetch`, `XMLHttpRequest`, `WebSocket`, `sendBeacon`, `<a href>` to external hosts or `window.open`.
- The TrackEvent/outbox API (store +0x38, +0x3c and `Z:0x419c60`) becomes a no-op; no `Outbox` storage is kept.
- The game interface has no network method (`analysis/interface.tsv` lists none); the game reaches the network only indirectly through TrackEvent `GameStarted`/`GameStopped2`, which the engine sends itself.
- Remove the subscribe box, Mail This, Zap Me A Game, proxy fields, banner clicks and all external links.
- Enforce at run time with a Content-Security-Policy such as `default-src 'self'; connect-src 'self'` (or `'none'` if all assets are inlined) and no third-party hosts. Note for the technology choice: if the port runs the original x86 code in an emulator instead of a rewrite, the stubs must sit at the WSOCK32 ordinal level (table 5.1) plus `ShellExecuteA` and `wininet.dll`.

## 6. `.zdt` files

### 6.1 Format (verified, parser `Z:0x40d510`, writer `Z:0x40ca60`)

XML-like text, CRLF line ends, three-space indentation, root `<ZDT ver="00.01.00.00" shellver="01.01.01.1034">`. Elements have attributes and text; self-closing elements are written `<X/>`. On load the engine replaces control characters with spaces (`Core.zdt`) or treats them as corruption (`Outbox.zdt`, `Z:0x40d380`), and repairs the corrupt tags `>ser>` and `>ers>` (`Z:0x40d24d`..`Z:0x40d2a4`).

### 6.2 Files

| File | Location (verified, `Z:0x40d040`, `Z:0x40c8d0`) | Content | Needed to start / run Moeboid |
|---|---|---|---|
| `Core.zdt` | `<base>\ZapSpot\System\` where `<base>` = `CSIDL_APPDATA` (fallback `ProgramFilesDir`) when the exe path contains `~zs` (e-mail temp folder), else the parent of the folder that holds ZapSpot.exe | users, user and game properties (scores), shell properties | No. Missing: the engine builds a default in memory (`Z:0x40d7c0`) and runs as "not installed" |
| `Outbox.zdt` | same folder | queued network messages (5.5) | No. Missing: empty outbox (`Z:0x40dc10`) |
| `eid-*.zdt` | searched in the temp folder of the e-mailed game (`Z:0x405950`); copied to `<base>\ZapSpot\System\etc\` when installed | e-mail referral id: the text between `eid-` and `.zdt` is sent as `SendID` | No. `moeboid.exe` contains none (overlay holds only `Moeboid.gam` and `ZapSpot.exe`) |
| `colorcode.gam` | - | only a name compare: a file `colorcode.gam` whose game name is `UltraColorCode` is treated as the built-in ColorCode promo game (`Z:0x41fe90`) | No |
| `*.gam` | ZapSpot folder (`Z:0x4266d0`) | installed games for View All Games | `Moeboid.gam` only |

Reference trace (same file as 5.2): the first start from the e-mail temp folder opens `C:\users\user\AppData\Roaming\ZapSpot\System\Core.ZDT` and `...\Outbox.ZDT` for reading; both fail (not found) and the engine continues.

Default `Core.zdt` content (verified, `Z:0x40d7c0`): `<ZDT ver shellver>`, `<Users><User localid="0"><Email>guest</Email><RegDate>seconds since 2000-01-01 UTC</RegDate></User></Users>`, `<Zaplets/>`, `<Shell><DefaultUser localid="0"/></Shell>`.

### 6.3 Reference `Core.zdt` (verified, decoded)

```
<ZDT ver="00.01.00.00" shellver="01.01.01.1034">
   <Users>
      <User localid="0">
         <Email>guest</Email>
         <RegDate>845047641</RegDate>
         <ZLS ownerid="{2BFDD7F8-0EC4-4E7C-9FF4-3B2F8DC1D0F2}">
            <ZLSProp name="Score1Name" value="ZapSpot"/>   (Score1Score 10000)
            ...                                            (5000, 2500, 1000, 500)
         </ZLS>
      </User>
   </Users>
   <Zaplets/>
   <Shell>
      <DefaultUser localid="0"/>
   </Shell>
</ZDT>
```

`RegDate` 845047641 = 2026-10-11 15:27:21 UTC with the 2000-01-01 epoch (5.3). Properties known from code but absent in this file: user `OptOut` ("Yes"/"No"), shell `ShellGUID`, `ShellLastVerSentToServer`, `DefaultIP` (attribute `IP`), `DefaultProxyServer` (`Name`, `Port`), `Sound` (`Enabled` = "true"/"false", default "true"), `WindowXLoc`, `WindowYLoc`; game `LastNameEntered`.

Port: L. Keep only the game property store (2.4) and the sound flag in `localStorage`. Do not read or write `.zdt` files (inferred: no import of original user data is required).

## 7. Registry, files, command line

Registry (verified: only `RegOpenKeyExA`, `RegQueryValueExA`, `RegCloseKey` are imported; nothing is written):
- `HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings`: `ProxyEnable`, `ProxyServer` (`Z:0x407640`).
- `HKLM\Software\Microsoft\Windows\CurrentVersion`: `ProgramFilesDir`, fallback base folder when `CSIDL_APPDATA` is empty (`Z:0x4071f0`, `Z:0x40a0e0`, `Z:0x40aa50`, `Z:0x406200`).
- Identity, settings, scores and the ToS choice are in `Core.zdt`, not in the registry.

Files written (verified, install `Z:0x40a0e0`): folder `My Documents\My ZapSpot` (CSIDL 5) with a copy of the launcher; `%APPDATA%\ZapSpot\ZapSpot.exe`, `%APPDATA%\ZapSpot\System\`, `%APPDATA%\ZapSpot\Games\<game>.gam` (games folder inferred from the strings `\Games`, `Games\`); shortcuts `ZapSpot.lnk` (description "A Whole Lotta Fun!", target `%APPDATA%\ZapSpot\ZapSpot.exe`, no arguments; reference `analysis/reference/prefix_files/after_install/ZapSpot.lnk`; desktop icon visible in `capH/51_highscore_dialog_desk.png`) on the desktop and `...\Accessories\Games\ZapSpot.lnk` (base folder not checked). `Z:0x40aa50` updates the installed `ZapSpot.exe` and game when the running copy has a newer version (game version = string id 3 of the `.gam`, "00.01.01.08"). No file is deleted (no `DeleteFileA` import). Port: R.

Command line (verified, `Z:0x403c80`): `ZapSpot.exe "<temp folder>" "<launcher path>" "<game file>"`. The parser skips the first character and expects quoted arguments. Arg 1 = temp folder (also the first ZapSpot folder); arg 2 = launcher path (copied by install); arg 3 = game file, optional. Without arg 3 the shell opens View All Games (installed start from the shortcut, `Z:0x41ea46`). `ZapLock` (0-byte file made by the launcher) is not referenced by ZapSpot.exe (verified: no string). Private window messages (all in `Z:0x4040e0`): 0x7e9 DNS reply, 0x7ea socket event, 0x7eb close request (from the launcher), 0x7ec version query, 0x7ed "shutting down" query. Port: R (the web page starts Moeboid directly after the click-to-start screen, requirement 4).

## 8. Decisions for the user

- **D1 View All Games** (menu item + page): (a) remove the item; (b) keep the item and show only the Moeboid tile (+ "Make You ..." colour key). The promo tiles and Zap Me A Game are removed in both cases (requirement 5). Recommendation: (b), it keeps the menu layout of requirement 8 with S effort.
- **D2 Terms of Service**: recommendation in section 4 (keep, HTML dialog, no checkbox, text unchanged).
- **D3 Rail without Mail This**: (a) hide it the original way, the other three buttons move up 67 px; (b) leave an empty slot at the Mail This position. Recommendation: (b) keeps the reference positions of New Game, Pause and How To Play (`capD/*`).
- **D4 Window buttons and quit**: minimize and close have no browser equivalent. Options: minimize = pause; close = `IDD_QUIT_SAVED` while a game runs, then return to the click-to-start screen; or remove both buttons (blank).
- **D5 Help, About, Security texts**: they describe subscription, Mail This, install and web links. Options: (a) keep verbatim, links inert (no click target, same look); (b) edit the texts; (c) remove the pages. Recommendation: (a) for About and Help; remove the Security page link target (it shows only partner logos).
- **D6 Personalize page**: keep the sound toggle; the proxy section is removed (blank) or the page keeps its full layout with inert fields. Recommendation: remove the proxy section.

## 9. Port scope for the platform shell

Effort: S < 1 day, M 1-3 days, L > 3 days (inferred estimates). Dependencies: F = fonts (`fonts.md`: ZML fonts and MS Sans Serif), R = frame renderer (`rendering.md`), Z = ZML text renderer with links, D = Windows-style dialog component, S = local storage, A = audio.

| Element | Class | Effort | Dependencies |
|---|---|---|---|
| Click-to-start page (replaces launcher, splash timing) | L | S | - |
| Splash bitmap + copyright text | K (optional, decision) | S | R, system Arial metrics |
| Frame background, logo, game-area border, title bar | K | S | R |
| Left menu: View All Games / Personalize / About | K (D1) | S | R, Z |
| News placeholder text | K | S | Z |
| Help / minimize / close buttons | K / D4 | S | R |
| Game rail (New Game, Pause/Resume, How To Play) | K | M | R, Z, game interface |
| Mail This rail button and page | R | - | - |
| High Scores rail button | R (hidden for Moeboid) | - | - |
| Pause overlay text and paused footer | K | S | Z |
| Esc = pause, blur = pause | L | S | input |
| Subscribe box, offline prompt, Install link | R | - | - |
| ToS link + dialog | D2 | S (HTML) / M (pixel-exact) | F, D |
| Ad caption and banner | R (blank area) | S | R |
| View All Games page | D1 | S | R, Z |
| Personalize page (sound toggle) | K partly | S | Z, S, A |
| About page (+ version "v1.1") | K, links inert | S | Z |
| Help pages 101, 111-118 | K, links inert (D5) | S | Z |
| How To Play page (game `HELP.ZML`) | K | S (shell part) | Z, game |
| Name entry dialog `IDD_INPUT_BOX2` | L | M (first dialog component) | F, D |
| Game message box ("Name too long") | L | S | D |
| `IDD_QUIT_SAVED` (New Game / View All during a game; close: D4) | K | S | D |
| `IDD_QUIT_NOTSAVED`, `IDD_CONFIRM_SAVE`, `IDD_INPUT_BOX`, DUMPINFO | R | - | - |
| High-score / property store | L | S | S |
| `Core.zdt` / `Outbox.zdt` / `eid-*.zdt` files | R (replaced by S) | - | - |
| Network, telemetry, outbox, ShellExecute | R | S (CSP + no-op API) | - |
| Install, shortcuts, registry, screen saver, appbar, single instance | R | - | - |
| Window title "ZapSpot - Moeboid" | L | S | - |
| Shell sounds, cursors | K | see `audio-input.md` | A |

## 10. Open questions

- The exact field order of the `ZapZaplet` params (irrelevant for the port: removed).
- Esc in the name dialog gives an empty name (inferred from the dialog proc; not captured in the reference runs).
- Server replies and the exact `ZAPSRV_` reply header: unknown (server gone; reference runs had no network).
