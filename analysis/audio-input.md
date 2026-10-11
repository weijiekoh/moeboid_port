# Audio and input (workstream F)

Status: phase 1 analysis. Static analysis only (no Wine runs by this workstream).
Labels: **verified** = read from code or bytes at the given reference. **inferred** = conclusion, with the reason.
References: `ZapSpot.exe:0x...` and `Moeboid.gam:0x...` are virtual addresses. `zdc:LINE` = `analysis/decomp/ZapSpot.exe/decompiled.c:LINE`. `gdc:LINE` = `analysis/decomp/Moeboid.gam/decompiled.c:LINE`.

## 1. Summary for the port

- Audio: DirectSound only. No waveOut, PlaySound, MCI, MIDI or streaming (verified: WINMM imports are only `timeGetTime` and `timeEndPeriod`, `analysis/decomp/ZapSpot.exe/imports.tsv`). If DirectSound is not available, the engine is silent.
- Every sound is a one-shot static buffer that holds the raw WAV `data` chunk in its own format (8-bit or 16-bit mono, 8000 or 11025 Hz). The engine never calls SetVolume, SetPan or SetFrequency. All sounds play at 0 dB, centre pan, original rate.
- Each Play call duplicates the buffer and starts a new voice. The same sound can overlap itself. Maximum 16 voices for engine and game together. A Play call when 16 voices are busy is dropped (no stealing).
- The game uses one sound method: `Play(0)` (wrapper vtable +0x08). It plays 11 WAVs at 11 call sites (table in section 2.10).
- Input: Win32 messages and `GetKeyState`. No DirectInput (DINPUT.DLL is only probed for a DirectX version number and then freed). No `GetAsyncKeyState`, `GetCursorPos`, `ShowCursor` or `ClipCursor` imports.
- Game movement: the game polls Left, Right, Up, Down once per game tick through `GetKeyState` (engine key codes 6, 7, 8, 9). Other game keys come as key-down events: Space, Y, N, and two typed cheat words on the title screen. The game reads the Windows virtual-key code.
- Mouse: the game reads no mouse coordinates. It uses engine buttons only (Start, Yes (Y), No (N)).
- Focus loss: the engine pauses the running game (same as the Pause button) and stops its timer pump. On re-activation the game stays paused until the user clicks Resume. DirectSound mutes the game's buffers while the window is not in the foreground (inferred from DirectSound focus rules).

## 2. Audio

### 2.1 Subsystem object and selection

| Item | Value | Reference |
|---|---|---|
| Global sound subsystem pointer | `DAT_0045cfc4` | ZapSpot.exe:0x413040 (zdc FUN_00413040), created by `FUN_00408e00` |
| Constructor | `FUN_00408e80`, object 0x14 bytes, vtable `0x0042e780` | ZapSpot.exe:0x408e80 |
| Order of creation | Main window (`DAT_0045cf9c = FUN_00403bb0`, which calls `CreateWindowExA` in `FUN_00404790`) is created before the sound subsystem, so `SetCooperativeLevel` gets a valid window | ZapSpot.exe:0x413040 (verified: call order in FUN_00413040) |
| Fallback devices | None. No waveOut, PlaySound, MCI, MIDI imports | verified: imports.tsv |

Object fields (verified from FUN_00408e80, FUN_004090d0, FUN_00409280):

| Offset | Meaning |
|---|---|
| +0x04 | `IDirectSound*` |
| +0x08 | byte: DirectSound ready (1 = init succeeded) |
| +0x0c | handle of the voice thread |
| +0x10 | byte: sound effects enabled (user setting) |

Vtable `0x0042e780` (verified: analysis/decomp/ZapSpot.exe/vtables.txt):

| Offset | Address | Function |
|---|---|---|
| +0x00 | 0x409030 | `LoadSound(name, flag)`: returns an engine sound object, or NULL if +0x08 is 0 |
| +0x04 | 0x4090a0 | `DeleteSound(obj)` (clears the object from the voice owner table and deletes it) |
| +0x08 | 0x42a320 | `IsEnabled()`: returns byte +0x10 |
| +0x0c | 0x408f80 | `SetEnabled(byte)`: writes byte +0x10 |

Initialisation sequence, `FUN_00408e80` (verified, ZapSpot.exe:0x408e80):

1. `CoInitialize(NULL)`. If the result is not 0 (also `S_FALSE`), return at once. No thread is created and +0x08 is not written (see open question Q3).
2. `LoadLibraryA("DSound.dll")`. If it fails: `DAT_00459f24 = 1`, +0x08 = 0, return. Result: silent.
3. `FUN_004090d0`: DirectSound setup (2.2). Its result goes to +0x08. If 0: `DAT_00459f24 = 1`, return. Result: silent.
4. Read the setting `Sound` from the platform settings table (`DAT_0045cfa8` vtable +0x1c, then `FUN_004095c0(table, "Sound")`). Enabled (+0x10 = 1) if the entry does not exist, or if its value is `true` (`lstrcmpiA`, so case-insensitive). Any other value: disabled.
5. `CreateThread(FUN_00409340)` (voice thread, 2.4), `SetThreadPriority(-1)` (THREAD_PRIORITY_BELOW_NORMAL).

Failure messages go to `Error()` (ZapSpot.exe:0x413390), which calls `OutputDebugStringA` and adds the line to an in-memory log. The user sees nothing (verified).

### 2.2 DirectSound setup (`FUN_004090d0`, continued in `FUN_0040918d`)

Ghidra split this function at the C++ `try` block; `FUN_0040918d` is the rest of the same code (verified: ZapSpot.exe:0x40918d is reached from 0x4090d0, no own prologue).

| Step | Call | Arguments | Reference |
|---|---|---|---|
| 1 | `GetProcAddress(hDSound, "DirectSoundCreate")` | - | ZapSpot.exe:0x4090f8 |
| 2 | `DirectSoundCreate(lpGuid = NULL, &ds, NULL)` | default device; no IID or GUID passed | ZapSpot.exe:0x4090d0 |
| 3 | `IDirectSound::SetCooperativeLevel` (vtable +0x18) | `hwnd = DAT_004362f4` (main window), `DSSCL_PRIORITY` (2). Result ignored | ZapSpot.exe:0x4090d0 |
| 4 | `IDirectSound::CreateSoundBuffer` (+0x0c) | `DSBUFFERDESC{dwSize 0x14, dwFlags 1 = DSBCAPS_PRIMARYBUFFER, dwBufferBytes 0, lpwfxFormat NULL}` | ZapSpot.exe:0x40918d |
| 5 | `IDirectSoundBuffer::SetFormat` (+0x38) on the primary buffer | `WAVEFORMATEX{PCM, 2 ch, 22050 Hz, 88200 B/s, block 4, 16 bit, cbSize 0}` | ZapSpot.exe:0x40918d |
| 6 | `IDirectSoundBuffer::Release` (+0x08) on the primary buffer | - | ZapSpot.exe:0x40918d |

If step 4 or step 5 fails, the function returns 0 and the engine is silent (verified: return value `uVar2 & 0xffffff00`).

### 2.3 WAV path (resource to secondary buffer)

Engine sound object (vtable `0x0042e860`, 0x18 bytes, constructor `FUN_0040c440`):

| Offset | Meaning |
|---|---|
| +0x04 | external reference count (AddRef +0x04, Release +0x0c) |
| +0x08 | internal reference count (AddRef +0x08, Release +0x10); a playing voice holds one |
| +0x0c | `IDirectSoundBuffer*` (the original static buffer) |
| +0x10 | byte: `flag & 1` from `LoadSound` (game passes 0; engine passes 1 for OpenShell and CloseShell). No reader found in the sound code (inferred: unused) |
| +0x14 | repeat count, written by `Play(count)` |

Vtable `0x0042e860`: +0x00 destructor 0x40c4d0, +0x04 0x414f70, +0x08 0x414f80, +0x0c 0x414f90, +0x10 0x414fc0, +0x14 `Play(count)` 0x40c510, +0x18 0x40c530 (`DebugBreak` stub, not implemented).

Load path (verified):

1. `FUN_0040c780(name)` calls `FUN_0040c680`: the resource manager `DAT_0045cfac` vtable +0x00 `(name, 1)` opens the resource. Its vtable +0x38 returns the data pointer.
2. `FUN_0040c540` parses RIFF: requires `RIFF` and `WAVE`. It walks chunks from offset 12 to `riff_size + 8`, step `(size + 1) & ~1`. It takes the first `fmt ` chunk (size must be at least 14, else fail) as `lpwfxFormat` (pointer into the resource) and copies the first `data` chunk into a new heap block. It stops when both are found. All other chunks (`PAD `, `fact`, `cue `, `LIST`) are skipped. No format conversion.
3. `DSBUFFERDESC{dwSize 0x14, dwFlags 0x100e2, dwBufferBytes = data size, lpwfxFormat = fmt chunk}`. Flags 0x100e2 = `DSBCAPS_STATIC | DSBCAPS_CTRLFREQUENCY | DSBCAPS_CTRLPAN | DSBCAPS_CTRLVOLUME | DSBCAPS_GETCURRENTPOSITION2`. For the name `CloseShell.wav` (`lstrcmpiA`) the engine adds `DSBCAPS_GLOBALFOCUS` (0x8000). ZapSpot.exe:0x40c780.
4. `IDirectSound::CreateSoundBuffer` (+0x0c), then `FUN_0040c6e0`: `Lock(0, size, &p1, &n1, &p2, &n2, 0)` (+0x2c), copy the bytes, `Unlock` (+0x4c).
5. Error: if the buffer is NULL, `Error("Error loading sound buffer (%s)")`; the object stays with +0x0c = NULL.

Asset check against the parser (verified: assets/Moeboid.gam/decoded/wavs.json, assets/ZapSpot.exe/decoded/wavs.json): in all 15 WAVs `fmt ` is the first chunk and `data` is the last chunk. The `PAD ` chunks (SND-MOEBGROWTH, SND-RANDBG) lie before `data` and are skipped, so the 460 zero bytes are not played. The BTNCLICK cue markers have no effect. The buffer holds exactly the `data` chunk bytes.

### 2.4 Playback, voices and the voice thread

`Play(count)` = `FUN_0040c510`: writes `count` to object +0x14, then calls `FUN_00409280(subsystem, obj)` (verified, ZapSpot.exe:0x40c510).

`FUN_00409280` (verified, ZapSpot.exe:0x409280), runs in the caller thread (the main thread for game sounds, inferred because game ticks run in the main loop, section 3.1):

1. If shutdown flag `DAT_0045cfd8` is set: return.
2. Wait with `Sleep(10)` until the voice thread has started (`DAT_00459f26`).
3. If DirectSound ready (+0x08) and enabled (+0x10): find the first free slot in `DAT_00459ea0[16]` (0x459ea0 to 0x459edf).
4. `IDirectSound::DuplicateSoundBuffer(obj+0x0c, &dup)` (+0x14). If it fails: return (sound dropped).
5. Store: owner `DAT_00459e5c[i] = obj`, repeat `DAT_00459ee4[i] = obj+0x14`, voice `DAT_00459ea0[i] = dup`. Call object internal AddRef (+0x08).
6. `IDirectSoundBuffer::Play(0, 0, 0)` (+0x30) on `dup`: no `DSBPLAY_LOOPING`.
7. If no slot is free: return; the sound is dropped. No voice stealing.

Voice thread `FUN_00409340` (verified, ZapSpot.exe:0x409340):

- Clears the 16 slots, sets `DAT_00459f26 = 1`, then loops until `DAT_0045cfd8` is set: for each slot, `GetStatus` (+0x24). If status is 0 (stopped):
  - repeat value < 2: `Release` (+0x08) the duplicate, clear the slot, call owner internal Release (+0x10), clear the owner.
  - else: decrement the repeat value and `Play(0,0,0)` again from the current position (end of buffer; inferred: DirectSound rewinds a one-shot buffer that played to the end, so it restarts at 0).
- `Sleep(10)` after each pass. At exit: `CloseHandle`, `DAT_00459f24 = 1`.

Consequences:

| Question | Answer | Status |
|---|---|---|
| Same sound already playing | A new independent voice starts; both play to the end | verified (duplicate per Play) |
| Maximum simultaneous sounds | 16 voices, shared by engine and game | verified |
| Voice allocation | First free slot, index order | verified |
| Voice stealing | None; new sound dropped when 16 are busy | verified |
| Slot release time | Up to one thread pass (10 ms `Sleep`, real period 10 to 16 ms) after the voice stops | verified (code); period inferred (Windows timer granularity) |
| Looping | Only by the repeat count: `count` 0 or 1 plays once; `count` N >= 2 plays N times, with a gap of up to one thread pass between plays. No infinite loop. No Stop method in the interface | verified |
| Game repeat counts | Always 0 (11 sites push 0) | verified, section 2.10 |
| Streaming | None. All sounds are static buffers | verified |
| Thread safety | No lock between the caller and the voice thread (inferred: no synchronisation calls in either function) | inferred |

### 2.5 Volume, pan, frequency

No code calls `SetVolume` (+0x3c), `SetPan` (+0x40) or `SetFrequency` (+0x44). Verified: the only code that touches `IDirectSoundBuffer` pointers is FUN_00408f90, FUN_00409280, FUN_00409340, FUN_0040c6e0, FUN_0040c780, FUN_0040918d, and their vtable offsets are +0x08, +0x24, +0x2c, +0x30, +0x38, +0x48, +0x4c only. The `CTRL*` flags are set but not used. Result: volume `DSBVOLUME_MAX` (0, no attenuation), pan `DSBPAN_CENTER` (0), frequency = the WAV sample rate. A duplicate starts with the parameters of the original buffer (DirectSound documentation), which are the defaults.

There is no engine volume scale. The only user control is sound on/off (2.6).

### 2.6 Sound on/off setting

| Item | Value | Reference |
|---|---|---|
| Storage | Entry `Sound` in the table that the ZDT data store `DAT_0045cfa8` returns from vtable +0x1c (`FUN_00409910` searches `this+0x2864`); first value, string `true` or `false`. The ZDT store is XML in `Core.zdt`; analysis/shell.md gives the form `Sound` with attribute `Enabled` = "true"/"false". The fresh-install `Core.zdt` has no `Sound` entry, so sound is on (verified: analysis/reference/prefix_files/after_install/Core.zdt) | ZapSpot.exe:0x408e80, 0x423260 |
| Default | On (entry missing, or value `true`) | verified, FUN_00408e80 |
| UI | Personalize page: string 1102 "Sound effects are currently" + 1103 "On" / 1104 "Off", button string 1105 "Toggle" | assets/ZapSpot.exe/decoded/strings.txt |
| Toggle code | `FUN_00423260`: if value is `true` then write `false`, show "Off", `SetEnabled(0)`; else write `true`, show "On", `SetEnabled(1)` | ZapSpot.exe:0x4233fd to 0x4234c3 |
| Effect | Only new Play calls check the flag. Voices that already play continue to the end | verified (flag read only in FUN_00409280) |
| Persistence | After the toggle the engine may ask "Okay to Save to Desktop?" when the platform is not installed (DAT_0045cf9c vtable +0x48). Details belong to analysis/shell.md | ZapSpot.exe:0x4234ce |

No registry value is read for sound (verified: registry imports are used by FUN_00406200, FUN_004071f0, FUN_00407640, FUN_0040a0e0, FUN_0040aa50, none of them in the sound code).

### 2.7 Focus behaviour

- Game and shell buffers have neither `DSBCAPS_GLOBALFOCUS` nor `DSBCAPS_STICKYFOCUS` (verified, 2.3). With `DSSCL_PRIORITY`, DirectSound mutes such buffers while the cooperative window is not the foreground window. The buffers continue to play silently; their play position advances (inferred from the DirectX 7 DSBUFFERDESC documentation, not from code). Wine may not apply this rule (inferred: Wine dsound focus support is incomplete; the workstream I traces can confirm).
- `CloseShell.wav` has `DSBCAPS_GLOBALFOCUS`, so it stays audible while the window closes.
- The engine itself does not stop or pause voices on focus loss (verified: WM_ACTIVATE handling, section 3.6, has no sound calls). New game sounds do not start because the game is paused.

### 2.8 Shutdown

`FUN_00408f90` (verified): wait until the thread has stopped (`DAT_00459f24`), then for each slot `Stop` (+0x48) and `Release` (+0x08) the duplicate and call owner internal Release; release `IDirectSound`; `FreeLibrary`; `CoUninitialize`. The main loop waits for `DAT_00459f24` before `DestroyWindow` (ZapSpot.exe:0x404a30).

Engine sound object destructor `FUN_0040c4d0`/`FUN_0040c500` only resets the vtable; it does not release the static buffer at +0x0c (verified; a leak, no effect on the port).

### 2.9 Sound interface seen by the game

The game gets sounds from the resource factory (`ctx[4]`, `DAT_1000f5b0`, engine object `DAT_0045cfd4`, vtable `0x0042eae0`).

| Interface | Offset | Engine address | Game use | Arguments | Behaviour |
|---|---|---|---|---|---|
| factory | +0x40 | 0x415300, calls `FUN_00417f30` | `LoadSound` | `(const char* name, int flag)`; game passes flag 0 | calls subsystem `LoadSound`, wraps the result in a wrapper (vtable `0x0042ed90`, 8 bytes, +0x04 = engine sound object or NULL), AddRef. Returns the wrapper (never NULL unless out of memory) |
| sound wrapper | +0x00 | 0x415460 | not used | `(byte flags)` | scalar deleting destructor |
| sound wrapper | +0x04 | 0x414ff0 | `Release` | none | calls engine object Release (+0x0c), deletes the wrapper. If the engine object is NULL: returns 0 and does not delete the wrapper |
| sound wrapper | +0x08 | 0x415db0 | `Play` | `(int count)`; game passes 0 | engine object NULL: returns 8, no sound. Else `FUN_0040c510(count)`, returns 0 |
| sound wrapper | +0x0c | 0x415dd0 | not used | none | calls engine object +0x18 = `DebugBreak` stub |

All calls are `__thiscall` (ECX = interface, arguments on the stack, callee pops). Verified from listing: ZapSpot.exe:0x415300 (`RET 0x8`), 0x415db0 (`RET 0x4`).

Game load sites (verified, Moeboid.gam:0x100016a0, gdc:362 to 384). The game object (`DAT_1000f5cc`) stores the wrappers:

| Game object offset | Resource name passed | Load call site |
|---|---|---|
| +0xc8 | `snd-gameopen.wav` | 0x100019fb |
| +0xd0 | `snd-gameover-highscore.wav` | 0x10001a13 |
| +0xcc | `snd-gameover.wav` | 0x10001a2b |
| +0xd4 | `snd-gamestart.wav` | 0x10001a43 |
| +0xd8 | `snd-loselife.wav` | 0x10001a5b |
| +0xdc | `snd-moebeats.wav` | 0x10001a73 |
| +0xe0 | `snd-moebgrowth.wav` | 0x10001a8b |
| +0xe4 | `snd-newbaddieGood.wav` | 0x10001aa3 |
| +0xe8 | `snd-newbaddieBad.wav` | 0x10001abb |
| +0xec | `snd-randbg.wav` | 0x10001ad3 |
| +0xf0 | `snd-ExtraLife.wav` | 0x10001aeb |

(Addresses are the string references from analysis/decomp/Moeboid.gam/strings.tsv.) The game releases all 11 wrappers in `FUN_10001b50` (Shell_StopApplet path, gdc:400).

### 2.10 Game sound triggers

Each row is one `CALL [reg+0x8]` with `PUSH 0` (verified in analysis/decomp/Moeboid.gam/listing.asm).

| Sound | Call site | Function | Event | Reference |
|---|---|---|---|---|
| SND-GAMEOPEN | 0x100041e3 | FUN_100041a0 (title screen state constructor) | Title screen shown. Callers: FUN_100016a0 (applet start), FUN_100029a0 (end of credits), FUN_10003f60 (No at Play Again) | gdc:2289 |
| SND-GAMESTART | 0x10004583 | FUN_10004530 (Start button callback) | User clicks Start. The same function starts a 100 ms timer; its callback FUN_100045a0 creates the play state when the timer value passes 3000 (inferred: ms; analysis/timing.md) | gdc:2453 |
| SND-NEWBADDIEBAD | 0x10001414 | FUN_10001380 (enemy update) | An enemy appears and is larger than the player (`player size < enemy size`) | gdc:241 |
| SND-NEWBADDIEGOOD | 0x1000142e | FUN_10001380 | An enemy appears and is not larger than the player | gdc:244 |
| SND-MOEBEATS | 0x10002525 | FUN_100024e0 (collision with enemy) | Player eats an enemy (enemy size <= player size) | gdc:911 |
| SND-MOEBGROWTH | 0x10002546 | FUN_100024e0 | Same eat event, when the growth threshold is reached (player grows one level). Starts in the same tick as MOEBEATS | gdc:914 |
| SND-EXTRALIFE | 0x100025c9 | FUN_100024e0 | Every third growth (`growth count % 3 == 0`): extra life. Same tick as MOEBEATS and MOEBGROWTH | gdc:933 |
| SND-RANDBG | 0x1000302a | FUN_10002ea0 (play tick) | Tick time passes the next ambient time; next time += `rand % 4000 + 5000` ms. First time = `rand % 4000 + 3000` (FUN_10002a80). Only in normal play (no death animation, no dialog) | gdc:1426, gdc:1428, gdc:1296 |
| SND-LOSELIFE | 0x1000308d | FUN_10002ea0 | Player touched a larger enemy and a life remains (not when the INVINCIBLE cheat is on) | gdc:1435 |
| SND-GAMEOVER-HIGHSCORE | 0x10003842 | FUN_100037d0 (high score check) | Last life lost and the score enters the top 5. Plays before the name dialog opens | gdc:1888 |
| SND-GAMEOVER | 0x100030c3 | FUN_10002ea0 | Last life lost and the score does not enter the top 5 | gdc:1442 |

Gameplay meaning of sizes, timers and random numbers belongs to analysis/timing.md and analysis/verification.md. The table only fixes which sound plays at which code point.

### 2.11 Engine (platform) sound triggers

The port keeps the platform frame (requirement 8), so these sounds stay.

| Sound | Load | Play | Notes |
|---|---|---|---|
| BtnClick.wav | FUN_0041b170, shell +0x80, flag 0 | many shell button handlers, for example FUN_00423260 (sound toggle) and FUN_0041cb30 (pause toggle), `Play(0)` | button click |
| Popup.wav | FUN_0041b170, shell +0x84, flag 0 | not traced (G) | |
| OpenShell.wav | FUN_0041b170, shell +0x7c, flag 1 | ZapSpot.exe:0x41b1ee, `Play(0)`, only if the shell method `DAT_0045cf9c` +0x5c returns an empty string | platform start |
| CloseShell.wav | FUN_0041c830, flag 1, own buffer with GLOBALFOCUS, loaded at each exit | ZapSpot.exe:0x41c893, `Play(0)` if `IsEnabled()`; then a 1000 ms timer (callback FUN_0041ce00) runs the exit | platform exit |

## 3. Input

### 3.1 Devices and threads

| Item | Finding | Status |
|---|---|---|
| DirectInput | Not used. `FUN_0040afa0` (DirectX version probe, same logic as the DirectX SDK `GetDXVersion` sample) loads DINPUT.DLL, checks `GetProcAddress("DirectInputCreateA")`, and calls `FreeLibrary` at once. Callers: FUN_004055e0 and FUN_00406510 (system info dump) | verified, ZapSpot.exe:0x40afa0 |
| Keyboard | Window messages WM_KEYDOWN, WM_KEYUP, WM_CHAR, plus `GetKeyState` for polled state | verified |
| Mouse | WM_MOUSEMOVE, WM_LBUTTONDOWN/UP/DBLCLK, WM_RBUTTONDOWN/UP/DBLCLK. `SetCapture` on left button down, `ReleaseCapture` on left button up | verified |
| Not imported | `GetAsyncKeyState`, `GetCursorPos`, `ShowCursor`, `ClipCursor`, joystick functions | verified, imports.tsv |
| Main loop | `FUN_00404a30`: `PeekMessageA(PM_REMOVE)`, `TranslateMessage`, `DispatchMessageA`. When the queue is empty and the window is active, it calls the timer pump `DAT_0045cfb0` vtable +0x08. Game ticks therefore run in the main thread, between messages | verified, ZapSpot.exe:0x404a30 |

Because game ticks run in the thread that owns the window, `GetKeyState` returns the key state after all messages that the loop has removed so far (inferred from the `GetKeyState` contract).

### 3.2 Window procedure routing (`FUN_004040e0`)

All input cases return early when the shutdown flag `DAT_0045cfd8` is set or when `DAT_0045cfa4` (input subsystem) or `DAT_0045cfcc` (shell) is NULL (verified, zdc:3476 to 3746).

| Message | Action | Engine event type |
|---|---|---|
| WM_KEYDOWN (0x100), VK_ESCAPE | If an applet runs (applet loader `DAT_0045cfc8` +0x14 = ZapSpot.exe:0x424a90 returns byte +4, which FUN_00424620 sets to 1 before it calls `Shell_StartApplet`): pause toggle `FUN_0041cb30`. Then video subsystem `DAT_0045cfa0` vtable +0x38, which minimises the window ("hide from the boss", analysis/shell.md). The minimise then causes WM_ACTIVATE(WA_INACTIVE) (3.6). Net result: the game is paused in both cases (Esc on a running game: pause, then no second toggle because already paused; Esc on a paused game: resume, then the deactivation pauses again; inferred from the code order). Not passed to the game | - |
| WM_KEYDOWN, other keys | input subsystem +0x00 `(0xb, wParam)` | 0xb |
| WM_KEYUP (0x101), not VK_ESCAPE | input +0x00 `(0xd, wParam)` | 0xd |
| WM_CHAR (0x102), not 0x1b | input +0x00 `(0xc, wParam)` | 0xc |
| WM_MOUSEMOVE (0x200) | input +0x04 `(7, (short)x, (short)y)`, then `SetCursor(DAT_004362fc)` | 7 |
| WM_LBUTTONDOWN (0x201) | input +0x04 `(1, LOWORD, HIWORD)` | 1 |
| WM_LBUTTONUP (0x202) | `(2, x, y)` | 2 |
| WM_LBUTTONDBLCLK (0x203) | `(3, x, y)`. Never sent: the window class style is 3 (`CS_HREDRAW | CS_VREDRAW`), without `CS_DBLCLKS` (verified, FUN_00404790, zdc:3780). The second click of a double click arrives as WM_LBUTTONDOWN | 3 |
| WM_RBUTTONDOWN (0x204) | `(4, x, y)` | 4 |
| WM_RBUTTONUP (0x205) | `(5, x, y)` | 5 |
| WM_RBUTTONDBLCLK (0x206) | `(6, x, y)`. Never sent (no `CS_DBLCLKS`) | 6 |
| WM_SYSKEYDOWN, WM_SYSKEYUP | Not handled; `DefWindowProcA`. Alt combinations and F10 never reach the game | verified (no case) |
| WM_ACTIVATE (6) | Section 3.6 | - |

Key auto-repeat: the engine does not test lParam bit 30. Every auto-repeat WM_KEYDOWN becomes a new event 0xb (verified: only wParam is passed).

### 3.3 Input subsystem (`DAT_0045cfa4`, vtable `0x0042eff8`)

| Offset | Address | Function |
|---|---|---|
| +0x00 | 0x4269b0 | `KeyEvent(type, wParam)`: maps the virtual key to an engine key code, then calls the applet manager `DAT_0045cfc0` +0x04 `(type, keycode, wParam)` |
| +0x04 | 0x426bc0 | `MouseEvent(type, x, y)`: calls applet manager +0x00 `FUN_00425020` |
| +0x08 | 0x426be0 | `SetFocus(DAT_004362f4)` (main window) |
| +0x0c | 0x426bf0 | `GetKeyState(map(code))`: returns the `GetKeyState` result |

Engine key codes (verified, FUN_004269b0 and FUN_00426bf0):

| Code | Virtual key | Note |
|---|---|---|
| 0 | VK_BACK 0x08 | |
| 1 | VK_DELETE 0x2e | |
| 2 | VK_TAB 0x09 | |
| 3 | VK_RETURN 0x0d | WM_KEYDOWN of VK_RETURN is dropped by `KeyEvent`; WM_CHAR 0x0d and WM_KEYUP pass |
| 4 | - | every WM_CHAR that is not 0x08, 0x09, 0x0d, 0x10, 0x11 |
| 5 | VK_CONTROL 0x11 | |
| 6 | VK_LEFT 0x25 | |
| 7 | VK_RIGHT 0x27 | |
| 8 | VK_UP 0x26 | |
| 9 | VK_DOWN 0x28 | |
| 10 | VK_HOME 0x24 | |
| 11 | VK_END 0x23 | |
| 12 | VK_SHIFT 0x10 | |
| -1 | any other key | event still sent with wParam |

For `GetKeyState(code)`, code 4 and codes above 12 pass through unchanged as a virtual key (verified: jump table of FUN_00426bf0 at ZapSpot.exe:0x426bff; code 4 gives `GetKeyState(4)` = VK_MBUTTON). The `KeyEvent` mapping uses a jump table at ZapSpot.exe:0x426b48 for wParam 0x08 to 0x11 (verified: 0x08, 0x09, 0x0d, 0x10, 0x11 have cases, the others go to the default path). For WM_CHAR the control characters 0x08, 0x09, 0x0d, 0x10 (Ctrl+P), 0x11 (Ctrl+Q) therefore also get codes 0, 2, 3, 12, 5.

### 3.4 How the game receives input

Two paths:

1. Polled state (movement). Shell interface `ctx[5]` (`DAT_1000f5c8`, vtable `0x0042ec3c`) +0x20 = `FUN_00416000(char code)`: calls input +0x0c. The game tests bit 0x80 of the low byte (`TEST AL,0x80`). Windows returns 0xFF80 or 0xFF81 for a key that is down (inferred: documented only as "high-order bit set"; the low byte value comes from ReactOS and Wine behaviour, so bit 0x80 is set when the key is down).
2. Events (key down). Resource factory +0x44 = `FUN_004152d0` registers a callback: `(target, eventType, userData, callback)`. It forwards to the applet manager `FUN_00424c70`. Event types above 0xd are rejected unless a handler for the same target and type exists (verified, FUN_00424c60: `type <= 0xd`). Dispatch `FUN_00425870` calls every handler of the matching type (the target is not compared) in list order (inferred: append order, FUN_00424e30) until a callback returns 0. The game callbacks always return 0 (verified: FUN_10002e20, FUN_100043f0), so later handlers of type 0xb do not see the event. The callback gets a pointer to:

| Offset | Content |
|---|---|
| +0x00 | userData (game object) |
| +0x04 | callback id |
| +0x08 | wParam: virtual key (0xb, 0xd) or character (0xc) |
| +0x0c | event type |
| +0x10 | engine key code |

The game registers (verified):

| Site | Type | Callback | Purpose |
|---|---|---|---|
| Moeboid.gam:0x100016a0 (gdc:292) | 0x10 | FUN_10001f40 to FUN_10001c90 | Help text (`Help.zml`). Type 0x10 is above 0xd; delivery depends on the shell (analysis/shell.md) |
| Moeboid.gam:0x10002a80 (gdc:1282) | 0xb | FUN_100031f0 to FUN_10002e20 | Play state keys (Space, Y, N) |
| Moeboid.gam:0x100041a0 (gdc:2303) | 0xb | FUN_100049a0 to FUN_100043f0 | Title screen cheat words |

The game registers no mouse event handlers and reads no mouse coordinates (verified: all factory +0x44 calls are listed above). Mouse use goes through engine buttons, created by factory +0x30 in `FUN_10001de0`.

### 3.5 Keys and mouse actions used by the game

| Input | How | Where | Effect |
|---|---|---|---|
| Left arrow | polled, code 6 | FUN_10003200, called each play tick from FUN_10002ea0 | `FUN_10002110(1)`: accelerate left |
| Right arrow | polled, code 7 | FUN_10003200 | `FUN_10002110(2)`: accelerate right |
| Up arrow | polled, code 8 | FUN_10003200 | `FUN_10002110(3)`: accelerate up |
| Down arrow | polled, code 9 | FUN_10003200 | `FUN_10002110(4)`: accelerate down |
| Space (VK 0x20) | event 0xb | FUN_10002e20 | When the "lost a life" message shows (state 2): continue |
| Y (VK 0x59) or VK 0x79 | event 0xb | FUN_10002e20 | When "Play Again?" shows (state 1): new game |
| N (VK 0x4e) or VK 0x6e | event 0xb | FUN_10002e20 | When "Play Again?" shows: back to the title |
| C R E D I T S | event 0xb, VK sequence | FUN_100043f0 | Title screen, before Start: show credits |
| I N V I N C I B L E | event 0xb, VK sequence | FUN_100043f0 | Title screen, before Start: invincible (`DAT_1000f604 = 1`; reset on each title screen) |
| Left click on Start | engine button, id -1 | FUN_100041a0, callback FUN_10004990 | Start the game |
| Left click on Yes (Y) / No (N) | engine buttons, id 0 / 1 | FUN_10003e70, callback FUN_10003f50 | Same as Y / N keys |
| Text entry | Win32 modal input box (shell `DAT_0045cf9c` +0x44 = ZapSpot.exe:0x405480; flags 1 selects `IDD_INPUT_BOX2`, analysis/shell.md) | FUN_100037d0 via ctx[5] +0x18 | High score name, `GetDlgItemTextA` limit 0x10 (15 characters), game rejects 13 or more |

Polling detail (verified, FUN_10003200, Moeboid.gam:0x10003200): for each arrow, on the tick where the key is first seen down, the game records the tick time and calls `FUN_10002110` once. On later ticks, while the key stays down and more than 10 ms of tick time have passed since that first tick, it calls `FUN_10002110` again on each tick. When the key is seen up, the state clears. A key press that starts and ends between two ticks is not seen. Bits of `DAT_1000f5f0` (bit 0 Left, bit 1 Right, bit 2 Up, bit 3 Down) select the diagonal factor 0.707 in FUN_10002110.

Virtual-key quirks (verified from the compared constants; consequences inferred from Win32 key code values):

- The game compares event 0xb wParam (a virtual-key code) with ASCII letters. Upper-case letters equal VK_A to VK_Z. Lower-case letters equal other virtual keys: `y` 0x79 = VK_F10 (never arrives, because F10 gives WM_SYSKEYDOWN), `n` 0x6e = VK_DECIMAL (numpad `.` with NumLock on, works as No).
- `credits` lower case: 0x63 VK_NUMPAD3, 0x72 VK_F3, 0x65 VK_NUMPAD5, 0x64 VK_NUMPAD4, 0x69 VK_NUMPAD9, 0x74 VK_F5, 0x73 VK_F4. Mixed sequences of these keys and the letter keys also match.
- Any other key-down between letters resets the cheat counter, also VK_SHIFT and its auto-repeat. A wrong key resets the counter to 0 without testing it as the first letter.
- Letters depend on the keyboard layout (virtual keys follow the layout). Arrows and Space do not.

### 3.6 Focus loss, pause, Escape

WM_ACTIVATE (verified, ZapSpot.exe:0x4041bc to 0x404225):

- `LOWORD(wParam) == WA_INACTIVE`: read `paused = DAT_0045cfb0 +0x14()`. If not paused and an applet runs, call `FUN_0041cb30` (pause toggle). Redraw (`FUN_0041b210`). Set `DAT_00436336 = 1`; the main loop then stops calling the timer pump (no game ticks).
- Active and `HIWORD(wParam) == 0` (not minimised): clear `DAT_00436338`, `DAT_00436335`. Set `DAT_00436336 = 0`; ticks run again. The game stays paused; the user must click Resume (no automatic resume, verified: no pause call in this branch).

Pause toggle `FUN_0041cb30` (verified): plays BtnClick (shell +0x80, `Play(0)`, ZapSpot.exe:0x41cb4f; so a focus loss during a game also starts BtnClick, which DirectSound probably mutes at once, inferred), inverts the pause flag (`+0x10(!+0x14())`), and when paused shows string 10016 "Resume your game using the button to the left". When it resumes, it calls input +0x08 (`SetFocus` main window). Escape key calls the same toggle (3.2).

Mouse capture and focus: left button down calls `SetCapture(main window)`. If the point is inside the game area (shell +0x2c8 origin, 500 x 420), it calls input +0x08 (`SetFocus`). Left button up calls `ReleaseCapture` (verified, FUN_00425020).

Cursor: no hiding (no `ShowCursor`), no clipping (no `ClipCursor`). The window class has no cursor (`hCursor = NULL`, zdc:3779), so the engine sets `DAT_004362fc` on every WM_MOUSEMOVE; the hover code calls the cursor manager `DAT_0045cfbc` +0x08/+0x0c. Cursor images belong to analysis/rendering.md.

Mouse coordinates: client coordinates of the main window (WM_MOUSE* lParam). WM_MOUSEMOVE uses signed 16-bit values; the button messages use unsigned LOWORD/HIWORD, so a left button up outside the window during capture gives large positive values (65535 for -1) and hits no control (verified: zdc WndProc cases 0x200 and 0x202). `FUN_00425020` finds the control under the point (`FUN_00414a00`) and converts to control-local coordinates by subtracting each parent offset. Event types 8 (enter) and 9 (leave) go to hover changes. Buttons are a shell topic (analysis/shell.md).

## 4. Port mapping: Web Audio

| Original | Web Audio | Exact? |
|---|---|---|
| DirectSound init after the window | Create one `AudioContext` in the click handler of the click-to-start screen (user gesture, unlocks audio); call `resume()` there | n/a |
| WAV `data` chunk, 8-bit unsigned or 16-bit signed mono, own rate | Decode at load: own parser that copies the `data` chunk (skip all other chunks, as the engine does) into an `AudioBuffer` with `sampleRate` = WAV rate (8000 or 11025; the Web Audio specification requires `createBuffer` to accept at least 8000 to 96000 Hz). 8-bit: `(b - 128) / 128` (same scale as the DirectSound 8-to-16-bit conversion `(b - 128) << 8`); 16-bit: `s / 32768`. `decodeAudioData` also works but resamples to the context rate at load | sample values exact |
| No volume, pan, frequency | One `AudioBufferSourceNode` per Play into a master `GainNode` (gain 1.0) | exact (no attenuation) |
| Mono buffer, centre pan, stereo primary | Mono source into a stereo destination: Web Audio up-mix copies mono to both channels at full level. DirectSound centre pan also gives 0 dB on both channels (DirectSound pan attenuates only one side) | exact level |
| dB to linear | Not needed (all 0 dB). If a later feature needs it: `gain = 10 ** (hundredthsDb / 2000)` | - |
| Resampling 11025/8000 to 22050 (DirectSound mixer), then to the device rate | Browser resampler from buffer rate to context rate | not exact: interpolation differs (audible only as small high-frequency differences). Option: `new AudioContext({sampleRate: 22050})` to keep the intermediate rate; the browser resamples to the device |
| Mixing and clipping at 16 bit | Float sum, clipped at the output | near-exact; 16-bit quantisation of the mix is not reproduced |
| `Play(count)` duplicate per call | New source node per call, `start()` at once | exact semantics |
| 16-voice limit, drop when full | Keep a 16-entry voice table; free an entry on `onended` (plus one 10 ms thread pass if wanted); drop the Play call if full. Shared with platform sounds | timing of slot release not exact (thread period) |
| Repeat count N >= 2 | Restart in `onended` N-1 times | gap not exact (original gap 0 to 16 ms); game never uses it |
| Start latency | Original: the game calls Play inside the tick callback, in the main thread; `DuplicateSoundBuffer` and `Play` run at once (verified, FUN_00409280); the sound is heard after the DirectSound mixer write-ahead (driver dependent, tens of ms, inferred). Port: start the source in the same tick as the game event. Sounds of one tick start together, as in the original. If the fixed-timestep loop runs several catch-up ticks in one browser frame, `start()` without a time would merge sounds of different ticks; to keep their spacing, schedule `start(t0 + (tickTime - batchFirstTickTime) + d)` with a small constant `d` (for example one tick) | absolute latency not exact; order and same-tick grouping exact; see D5 |
| Sound on/off | Boolean in local storage (key name in analysis/shell.md); check only at Play; do not stop voices that play | exact |
| Focus loss mute | On `blur` or `visibilitychange` to hidden: set master gain to 0, keep sources running (position advances, as DirectSound). Exception: CloseShell (GLOBALFOCUS) is not muted | inferred original behaviour; check with the I traces |
| Autoplay policy | Audio can start only after the click-to-start gesture. SND-GAMEOPEN plays when the title appears; the title must appear after the click, or the first GAMEOPEN is lost | browser constraint |

What cannot be exact: resampler and mixer quantisation (DirectSound software mixer and the original driver are not reproducible); absolute output latency; voice slot release timing; focus mute timing. None of these change game logic, because the game never reads sound state.

## 5. Port mapping: browser input

| Original | Browser | Notes |
|---|---|---|
| `GetKeyState` poll for codes 6 to 9 at each tick | Keep a held-key set from `keydown`/`keyup` (`KeyboardEvent.code` `ArrowLeft`, `ArrowRight`, `ArrowUp`, `ArrowDown`); the tick reads the set | Do not latch short presses: the original misses a press that ends between ticks. Ticks that run in one batch see the same key state, in the original (no messages are removed between them, inferred) and in the port |
| Event 0xb with VK | On `keydown` (also `repeat == true`), compute a Windows VK and send event 0xb to the handlers | auto-repeat must be forwarded (cheat counters and Space see repeats) |
| Space | `code == "Space"`, VK 0x20 | |
| Y, N, cheat letters | Use `KeyboardEvent.key` upper-cased for letters (layout dependent, like VK). Also map `NumpadDecimal` to VK 0x6e (No), `Numpad3/4/5/9` to 0x63/0x64/0x65/0x69 and `F3/F4/F5` to 0x72/0x73/0x74 if the numpad and F-key quirks are kept | decision D3 |
| VK_SHIFT and VK_CONTROL key-downs reset cheat counters | Forward `ShiftLeft/ShiftRight` as VK 0x10, `ControlLeft/ControlRight` as 0x11, with repeats | needed for exact cheat behaviour |
| WM_KEYDOWN VK_RETURN dropped | Do not send event 0xb for Enter | |
| WM_SYSKEYDOWN not handled | Do not send Alt combinations or F10 as event 0xb | |
| Escape toggles pause and minimises | `keydown` `Escape`: run the pause toggle, then the deactivation logic (pause if not paused); do not forward. No minimise in the browser (analysis/shell.md decision D4) | |
| Mouse client coordinates | Pointer events on the canvas; convert `offsetX/offsetY` to frame pixels (divide by CSS scale). Left button: `button == 0`; right: `button == 2` | No pointer lock needed |
| `SetCapture` on left down | `setPointerCapture(pointerId)` on `pointerdown`, release on `pointerup` | |
| Double click (types 3, 6) | Never generated by the original (no `CS_DBLCLKS`). Send every `pointerdown` as type 1 or 4; ignore `dblclick` | exact |
| Cursor | CSS `cursor` with the extracted cursor images (analysis/rendering.md) | no hiding needed |
| Focus loss | `blur` and `visibilitychange`: run the WA_INACTIVE logic (pause if a game runs, stop ticks). `focus`: restart ticks, keep paused. Clear the held-key set on `blur` | see D2 |
| High score name box | HTML modal text input, `maxlength` 15; game rejects 13 or more characters | analysis/shell.md owns the dialog |
| Key state on blur | Windows keeps the last key state of the thread when the key-up goes to another window (inferred); the browser loses `keyup` too. Clearing the set on `blur` avoids stuck keys | small deviation, game is paused anyway |

Ambiguities:

- `KeyboardEvent.code` versus `key`: arrows and Space are the same in both. For letters, `key` follows the layout as Windows VK codes do; `code` does not. For layouts without Latin letters (for example Cyrillic), Windows still gives VK_A to VK_Z by key position (inferred from the standard layout tables); use `code` (`KeyA` to `KeyZ`) when `key` is not A to Z.
- Browsers with an input method editor or dead keys can send `key == "Dead"` or `"Process"`; ignore those.
- Some browsers reserve keys (for example F3 for find, F5 for reload). Call `preventDefault()` for keys the port maps.

## 6. Decisions for the user

- D1: Keep the 16-voice limit with drop-new? Recommended: yes (cheap, exact semantics).
- D2: On focus loss, pause the game as the original does (yes, recommended), and mute audio while hidden (recommended: master gain 0, sources continue).
- D3: Keep the virtual-key quirks (numpad `.` as No; numpad and F-key variants of `credits`)? Recommended: yes for exactness, but F3/F5 conflict with browser shortcuts; `preventDefault()` only while the game page has focus.
- D4: AudioContext sample rate 22050 (closer to the original mixer) or the device default. Recommended: device default; the difference is small.
- D5: Sound start time in a catch-up batch of ticks: start at once (simple; sounds of different ticks in one browser frame merge) or schedule with the tick offset plus a constant delay (keeps spacing, adds latency). Recommended: schedule with offset; decide together with the loop design in analysis/timing.md.

## 7. Open questions

- Q1: Real start latency and focus muting under the reference runs: compare with analysis/reference/ when workstream I has traces.
- Q2: The game registers its help callback with event type 0x10, above the `type <= 0xd` limit of FUN_00424c60. analysis/shell.md links it to the How To Play rail button (`Z:0x41c3f0`). This workstream did not trace how the shell attaches and calls it.
- Q3: `CoInitialize` failure path leaves +0x08 uninitialised and creates no thread; `Play` would then wait forever at the `Sleep(10)` loop if +0x08 is not 0. Only relevant if COM was already initialised on the main thread (not the case at start, inferred). No port impact.
- Q4: Exact `GetKeyState` low-byte value on Windows 98/2000/XP (the game tests bit 0x80, not bit 15).

## 8. Facts for other workstreams

- C (timing): game ticks run from the idle part of the main loop (FUN_00404a30) through `DAT_0045cfb0` +0x08, only while the window is active (`DAT_00436336 == 0`). Arrow keys are sampled once per tick; the repeat rule is "more than 10 ms of tick time since the first down tick".
- G (shell): pause toggle FUN_0041cb30 (string 10016), ESC handling, WM_ACTIVATE pause, sound toggle FUN_00423260 and its "Save to Desktop" prompt, event type 0x10, input box for names (`DAT_0045cf9c` +0x44).
- D (rendering): `SetCursor(DAT_004362fc)` on every WM_MOUSEMOVE; hover cursors through `DAT_0045cfbc` +0x08/+0x0c.
- B (interface): sound wrapper vtable `0x0042ed90` (+0x04 Release, +0x08 Play(count), +0x0c unimplemented); factory +0x40 LoadSound, +0x44 RegisterHandler; ctx[5] +0x20 and +0x24 GetKeyState(code); event record layout in 3.4.
