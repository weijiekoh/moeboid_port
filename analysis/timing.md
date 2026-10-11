# Timing and main loop (workstream C)

Status: COMPLETE for static analysis. Section 10 (comparison with reference traces) waits for workstream I.

Labels: **verified** = read from code or data at the given reference. **inferred** = conclusion with the reason given. **unknown** = not determined.

References:
- `Z:0x4xxxxx` = address in `extracted/ZapSpot.exe` (image base 0x400000). `G:0x1xxxxxxx` = address in `extracted/Moeboid.gam` (image base 0x10000000).
- `zdc:N` = line N of `analysis/decomp/ZapSpot.exe/decompiled.c`. `gdc:N` = line N of `analysis/decomp/Moeboid.gam/decompiled.c`.
- Scratch tools (not project files): `sim.py` (timer quantization simulation), `anim.py` (GIF slot table check) in the workstream C scratch directory.

## 0. Summary

1. The engine has no timer API from Windows. It runs a busy `PeekMessage` loop. When the message queue is empty, it polls a list of engine timer objects. Each poll reads `GetTickCount` (verified, section 1).
2. A timer fires when `now - last >= period`. Then `last = now`. There is no catch-up and no phase keeping. The callback gets the milliseconds since the timer started (verified, section 2).
3. The game creates three timers: 20 ms (game play), 20 ms (hidden credits screen with 100 bouncing baddies), 100 ms (start sequence). It does not create a 16 ms timer (verified, section 3).
4. **Correction to the project brief:** the call at `G:0x10001716` (`ctx[4]` method `+0x44` with `0x10`) is not a timer. It registers an event listener for event id 0x10. The shell fires event 0x10 when it opens the help page (Help.zml). `0x10` is an event id, not a period (verified, section 3.2).
5. The engine renders only from a 50 ms real-time timer (dirty rectangles, then one full-window `Blt`), and on `WM_PAINT`. There is no flip and no vertical-blank wait. Nominal display rate: 20 frames per second (verified, section 7).
6. All engine times come from `GetTickCount`. The engine never calls `timeBeginPeriod`. The real tick rate depends on the clock step of the OS: 50 Hz (1 ms or 10 ms step), 32 Hz (15.625 ms step, typical Windows XP), 18.2 Hz (55 ms step, Windows 9x default). Section 5 gives the table and the recommendation.
7. Game motion is time based (pixels per millisecond), but player acceleration, random direction changes and key auto-repeat are per tick. Thus the feel of the game depends on the tick rate (verified, section 3.3).

## 1. Engine main loop

### 1.1 Message loop

`Z:0x404a30` (verified, zdc:3863-3904, listing `Z:0x404abc`..`Z:0x404b16`):

```
ShowWindow; SetFocus
loop:
    while PeekMessageA(&msg, NULL, 0, 0, PM_REMOVE) == 0:          // queue empty
        if timerSys != NULL and inactive == 0:                      // 0x45cfb0, 0x436336
            timerSys->RunTimers()                                    // vtable +0x08 = Z:0x4273d0
        else if shutdownTimer != NULL:                               // 0x45dfd8
            PollTimer(shutdownTimer)                                 // Z:0x413510
    if msg.message == WM_QUIT or this->quit: break
    TranslateMessage; DispatchMessageA
SystemParametersInfoA(SPI_SETSCREENSAVEACTIVE, saved)
while soundThreadDone == 0: Sleep(10)                                // 0x459f24
DestroyWindow; timeEndPeriod(1)
```

- Loop type: busy poll. No `Sleep`, no `WaitMessage`, no `MsgWaitForMultipleObjects` (verified: none of these is imported except `Sleep`; the `Sleep` call sites are listed in 1.3). The loop uses 100% of one CPU (inferred from the code shape).
- All pending messages are dispatched before the next timer pass (verified). Input events thus always reach the game before the next tick.
- `timeEndPeriod(1)` at exit has no matching `timeBeginPeriod` (verified: `timeBeginPeriod` is not imported and the string is not in the file). The engine runs with the default system timer resolution.

### 1.2 Threads

| Thread | Start address | Purpose | Priority |
|---|---|---|---|
| Main (UI) | WinMain `Z:0x403d40` | message loop, timers, game logic, rendering | normal (not changed) |
| Sound | `Z:0x409340`, created at `Z:0x408f4c` in `Z:0x408e80` | polls 16 DirectSound buffer slots every `Sleep(10)`. A stopped buffer with loop count >= 2 is restarted (`Play`), else released | `THREAD_PRIORITY_BELOW_NORMAL` (-1), `Z:0x408f60` |

Verified (zdc:7605-7608, zdc:7924-7964). No other `CreateThread` call exists and the CRT `_beginthread` is not linked (verified, functions.tsv). `Moeboid.gam` creates no threads and imports no time function (verified, imports.tsv).

### 1.3 Timing sources (complete list)

| API | Call site | Use |
|---|---|---|
| `GetTickCount` | `Z:0x42724b` | timer subsystem start time (fields `+0x10`, `+0x18`) |
| `GetTickCount` | `Z:0x4274f6` | real clock: `GetTickCount - start` (vtable `+0x18`) |
| `GetTickCount` | `Z:0x427516` | game clock: `GetTickCount - (start + paused time)` (vtable `+0x1c`) |
| `timeGetTime` | `Z:0x403dc4` | seed for `srand` (`Z:0x40e38c`) at startup |
| `timeGetTime` | `Z:0x4275b5` | session start time stamp (stored, not used for timing) |
| `timeEndPeriod(1)` | `Z:0x404b56` | at exit only, unmatched |
| `Sleep(250)` | `Z:0x403da0` | wait for an old instance to close (start-up) |
| `Sleep(1000)` | `Z:0x403dc2` | after the old instance closed (start-up) |
| `Sleep(10)` | `Z:0x404b3c` | exit: wait for the sound thread |
| `Sleep(10)` | `Z:0x408fb4` | sound shutdown wait |
| `Sleep(10)` | `Z:0x4092a3` | wait until the sound thread is ready |
| `Sleep(10)` | `Z:0x4093d8` | sound thread poll period |

Not used (verified, not imported): `QueryPerformanceCounter`, `timeBeginPeriod`, `timeSetEvent`, `SetTimer`/`WM_TIMER`, `WaitForSingleObject`, `MsgWaitForMultipleObjects`, `GetAsyncKeyState`.

## 2. Timer subsystem and dispatch

### 2.1 Timer subsystem object (global `0x45cfb0`)

Constructor `Z:0x4271c0` (object 0x4c bytes), vtable `Z:0x42f058` (verified):

| Offset | Method | Function |
|---|---|---|
| +0x00 | AddTimer(timer): append to the array | `Z:0x4272a0` |
| +0x04 | RemoveTimer(timer): remove, shift the rest down | `Z:0x4272f0` |
| +0x08 | RunTimers(): one pass over all timers | `Z:0x4273d0` |
| +0x0c | session start time (GetSystemTime, timeGetTime) | `Z:0x427540` |
| +0x10 | SetPaused(bool) | `Z:0x427490` |
| +0x14 | IsPaused() | `Z:0x427530` |
| +0x18 | GetRealTime(&ms) = `GetTickCount - [+0x10]` | `Z:0x4274f0` |
| +0x1c | GetGameTime(&ms) = `GetTickCount - [+0x18]` | `Z:0x427510` |
| +0x20 | copy of the session start record | `Z:0x4275e0` |

Fields: `+0x08` timer array, `+0x0c` count, `+0x10` start tick, `+0x14` real time at pause, `+0x18` game-clock base, `+0x1c` paused flag.

SetPaused (`Z:0x427490`, verified): on pause, store the real time in `+0x14`. On resume, add `(real now - +0x14)` to `+0x18`. Result: the game clock does not advance while paused, and it has no jump at resume.

### 2.2 Timer object

Constructor `Z:0x413440` `(userdata, period, callback)`, object 0x2c bytes, vtable `Z:0x42ea40` (verified):

| Offset | Field |
|---|---|
| +0x10 | period (ms, unsigned) |
| +0x14 | time of the last fire (ms) |
| +0x18 | time of Start (ms) |
| +0x1c | callback, `__cdecl void cb(EventData*)` |
| +0x20 | started flag |
| +0x24 | user data (the game passes its `this`) |
| +0x28 | run-while-paused flag; also selects the clock: 0 = game clock, 1 = real clock |

Methods (verified):
- Start `Z:0x413580`: if not started, set started, AddTimer, then `start = last = now` (clock per `+0x28`). If already started, do nothing (the phase is kept).
- Stop `Z:0x4135d0`: clear started, RemoveTimer.
- Restart `Z:0x4135f0`: `start = last = now`, then Start.
- SetRunWhilePaused `Z:0x4173e0`: write `+0x28`.
- Release: the destructor `Z:0x4134b0` calls RemoveTimer if started.

### 2.3 Poll (fire) rule

`Z:0x413510` (verified, listing `Z:0x413519`..`Z:0x413563`):

```
now = (timer.realtime ? GetRealTime() : GetGameTime())     // one GetTickCount call per poll
if (uint32)(now - timer.last) >= timer.period:
    ev.userdata = timer.userdata        // ev+0x00
    ev.elapsed1 = now - timer.start     // ev+0x04
    ev.elapsed2 = now - timer.start     // ev+0x08 (same value)
    ev.now      = now                   // ev+0x0c
    timer.callback(&ev)
    timer.last = now                    // after the callback
```

Exact semantics:
- Unit: milliseconds (GetTickCount) (verified).
- First call: at the first poll where the clock is at least `start + period`. Never at Start (verified). On a coarse clock the first real interval is between `ceil(period/step) - 1` and `ceil(period/step)` clock steps, because Start reads the clock at a random phase inside a step (inferred).
- Late timer: one call only. `last = now`, not `last + period`. Missed periods are lost and the phase moves (verified). The callback receives the absolute elapsed time since Start, so code that uses it does not drift.
- Elapsed time: yes, `ev+0x04` and `ev+0x08` = ms since Start. The game reads `ev+0x08` (verified: `G:0x10002a10`, `G:0x10002ea0`, `G:0x100045a0`).
- Wrap: unsigned 32-bit subtraction, safe across the 49.7-day wrap (verified).

### 2.4 RunTimers and order

`Z:0x4273d0` (verified, zdc:34819-34861):

```
for i = 0; i < count; i++:              // count is read again each iteration
    if not paused: PollTimer(timers[i])
    else if timers[i].realtime: PollTimer(timers[i])
```

- Order: array order = order of the Start calls (verified). Each timer is polled at most once per pass and reads the clock again (verified).
- A timer started inside a callback is appended and polled in the same pass, but it cannot fire (its `last` is now) (inferred from the rule).
- A timer stopped inside a callback shifts the array. The timer after the removed one is skipped for that pass (inferred from `Z:0x4272f0` and the loop). This happens at screen changes (the old screen releases its timer).
- Order at run time: `Z:0x413040` creates and starts the 1000 ms outbox timer (`Z:0x419a30`, real-time) before CShell (`Z:0x41acb0`); CShell calls `Z:0x41d6c0`, which creates and starts the 50 ms render timer (verified, functions.tsv callers and zdc:19001-19028, zdc:25231-25236, zdc:28183-28188). Game timers and animation timers come later, in the order they start (inferred: they start after the game loads). Thus the render timer runs before the game tick when both are due in the same pass, and that frame shows the state before the tick.

### 2.5 Pause and activity states

| State | Effect | Reference |
|---|---|---|
| Paused (SetPaused(1)) | only real-time timers run (render timer, ad banner); game timers and game animations stop; game clock frozen | `Z:0x4273d0` |
| Modal dialog (`IDD_QUIT_SAVED`, `IDD_QUIT_NOTSAVED`, `IDD_CONFIRM_SAVE`, message boxes) | saves IsPaused, SetPaused(1), `DialogBoxParamA` (own modal loop, no timer pass at all), then restores the old state | `Z:0x405330`, `Z:0x405390`, `Z:0x405400`, `Z:0x405480`, `Z:0x4058c0` |
| Shell help page | fires event 0x10 to the game, then SetPaused(1) | `Z:0x41c3f0` (`Z:0x41c45d`, `Z:0x41c46a`) |
| Esc key while a game runs | toggles pause: `SetPaused(!IsPaused())` and shows or hides the pause page | WndProc `Z:0x4040e0` (zdc:3576-3581), `Z:0x41cb30` (`Z:0x41cb5a`..`Z:0x41cb69`) |
| Window deactivated (`WM_ACTIVATE`, `WA_INACTIVE`) | if a game runs and it is not paused: toggle pause (as Esc). Then render once and set `inactive = 1`: the main loop stops all timer passes (also real-time timers and rendering) | zdc:3510-3522 |
| Window activated | `inactive = 0`. The pause stays on. The player must resume (no automatic resume found) | zdc:3523-3529; global `0x436338` is written but not read elsewhere (verified, globals.tsv) |
| Minimized | `WM_ACTIVATE` with `WA_INACTIVE` comes first (Windows behaviour, inferred), thus as "deactivated" | |

After a long inactive period the render timer fires once (no catch-up). The game clock does not jump because the game is paused.

## 3. Game timers and update rate

### 3.1 Applet-facing timing interfaces

The game receives the context `ctx` (object 0x1c bytes, vtable `Z:0x42ef20`) from `Z:0x424620` (verified, zdc:32346-32406). Timing-related methods:

| Interface | Method | Engine function | Meaning |
|---|---|---|---|
| `ctx` (vtable `Z:0x42ef20`) | +0x08 | `Z:0x4160b0` jumps to `Z:0x40e396` | `rand()`: MSVC LCG `s = s*214013 + 2531011; return (s >> 16) & 0x7fff`. Seed = `timeGetTime()` at startup (`Z:0x403dc4`, `Z:0x40e38c`) |
| `ctx[4]` (vtable `Z:0x42eae0`) | +0x34 | `Z:0x415270`, `Z:0x417e40` | CreateTimer(userdata, period_ms, callback): returns a timer interface (vtable `Z:0x42ed68`), not started |
| `ctx[4]` | +0x44 | `Z:0x4152d0`, `Z:0x417fe0`, `Z:0x424c70` | AddEventListener(host = `ctx[5]`, event id, userdata, callback): returns a listener handle |
| `ctx[4]` | +0x3c | `Z:0x4152b0`, `Z:0x417f80`, `Z:0x424da0` | create an event channel (engine use: `ctx[5]` creates channels 0x11 and 0x10, `Z:0x415df0`) |
| timer interface (vtable `Z:0x42ed68`) | +0x04 Release, +0x08 Start, +0x0c Stop, +0x10 Poll, +0x14 SetRunWhilePaused, +0x18 GetRunWhilePaused, +0x1c Restart | thunks `Z:0x415ce0`..`Z:0x415d40` to `Z:0x413580`, `Z:0x4135d0`, `Z:0x413510`, `Z:0x4173e0`, `Z:0x413570`, `Z:0x4135f0` | |
| view (vtable `Z:0x42eb34`) | +0x2c StartAnim, +0x30 SelectAnim(index), +0x34 StopAnim | `Z:0x415500` to `Z:0x4176f0`; `Z:0x415510` to `Z:0x414b70`; `Z:0x415530` to `Z:0x417740` | animation control (section 4) |
| `ctx[5]` (vtable `Z:0x42ec3c`) | +0x20 | `Z:0x416000`, input subsystem `+0x0c`, `Z:0x426bf0` (`GetKeyState`) | key state query used once per tick (section 6) |

The game does not call Poll, SetRunWhilePaused or Restart (verified: no call through those slots in gdc). All game timers use the game clock.

### 3.2 The `0x10` argument at `G:0x10001716` is an event id

Verified chain:
- `G:0x100016e8`..`G:0x10001716`: `ctx[4]->AddEventListener(ctx[5], 0x10, this, G:0x10001f40)`.
- `Z:0x424c70` searches the channel list for `(source, id)`. Ids >= 0xe are only accepted if the channel exists (`Z:0x424c60`: `id < 0xe`). `ctx[5]` creates channels 0x11 and 0x10 (`Z:0x415df0`).
- `Z:0x424aa0` (vtable `Z:0x42eeac` +0x08) fires channel 0x10 when its argument is 1, channel 0x11 when it is 0. The only call site is `Z:0x41c461` with 1, in `Z:0x41c3f0`, which shows a shell page (string id 0x960) and pauses the timers.
- The game callback `G:0x10001f40` calls `G:0x10001c90`, which loads `Help.zml` and draws it with "Moeboid is a trademark ..." (verified). The target is the view `ctx[3]` (inferred: `ctx[3]+0x44` is called first; Ghidra lost the register that holds the target).

Conclusion: event 0x10 = "draw your help text" (inferred name from `Help.zml`). Event 0x11 is never fired (verified: one call site only). The game registers one more listener: event 0xb (key down, from `WM_KEYDOWN`) in game play (`G:0x10002c14`, gdc:1282) and in the start screen (gdc:2303).

### 3.3 Game timers

| Screen (constructor) | Period | Callback | Started | Reference |
|---|---|---|---|---|
| Hidden credits screen with 100 random baddies (`G:0x100026c0`); opens when the player types `credits` on the start screen (`G:0x100043f0`, string `G:0x1000e844`) | 20 ms (0x14) | `G:0x10002a70` to `G:0x10002a10`: updates all baddies with `ev.elapsed` | at once | gdc:1074-1076 |
| Game play (`G:0x10002a80`) | 20 ms (0x14) | `G:0x100031e0` to `G:0x10002ea0`: main game tick | at once | gdc:1284-1286 |
| Start screen "Top Moeboids" (`G:0x100041a0`) | 100 ms | `G:0x100049b0` to `G:0x100045a0`: start sequence | on the "Start" button (`G:0x10004530`) | gdc:2306, gdc:2454 |

No other timer exists in the game (verified: three `+0x34` calls on `ctx[4]` in gdc). The game play timer is not restarted between levels (verified: `G:0x10004000` does not touch it). `ev.elapsed` thus counts from the start of the game.

Per tick in game play (`G:0x10002ea0`, verified):
1. `t = ev.elapsed` (global `0x1000f5e0`).
2. Random background sound (`snd_randbg.wav`, object `+0xec`, gdc:381) at absolute times: play when `t > +0x1a8`, then `+0x1a8 += rand()%4000 + 5000` (first value `rand()%4000 + 3000`, gdc:1296).
3. Key state poll (`G:0x10003200`): for each of 4 keys (engine key ids 6, 7, 8, 9), on the first tick that sees the key down: one acceleration step. While held: one step per tick when more than 10 ms passed since the press. In practice: one step every tick from the second tick.
4. Player update (`G:0x10002330`): position += `dt_ms * v * 0.1`, `dt_ms` = time since the last update.
5. Each baddie (`G:0x10001380`): with probability 1/100 per tick (`rand() % 100 == 0`) a new random direction (`G:0x10001060`), else position += `dt_ms * v * 0.09`; bounce on the circle edge. Spawn delays (`rand()%4000` ms) and the 600 ms blob phase use absolute times.
6. Game-over phases use absolute times: 1000 ms, 2000 ms after the end (`G:0x10002ea0`, gdc:1461-1478).

Rate dependence (verified from the formulas above):
- Speed of motion: time based. The same at every tick rate.
- Player acceleration: per tick. Velocity `+= 0.1` per tick (0.0707 diagonal), doubled when reversing, limit 1.0 (0.707 diagonal), in units of 0.1 px/ms (`G:0x10002110`). Time to full speed: 10 ticks = 200 ms at 50 Hz, 312 ms at 32 Hz, 549 ms at 18.2 Hz.
- Baddie direction changes: mean interval 100 ticks = 2.0 s at 50 Hz, 3.1 s at 32 Hz, 5.5 s at 18.2 Hz.
- Collision and bounce tests: once per tick on the new positions. Larger steps at lower rates.
- RNG consumption: per tick, so the random sequence depends on the tick count.
- CPU speed: the busy loop makes the tick rate independent of CPU speed while one pass takes less than one clock step. A slower pass delays the tick (no catch-up) (inferred). The game logic per tick is small (about 100 objects at most, float math). Unknown on 2000-era hardware without measurement.

## 4. Animation timing (CAnim)

Verified, `Z:0x418d90` (CImageSeq::LoadGIF), `Z:0x416e80` (add frame), `Z:0x4171b0` (CAnim::RecalcTimes), `Z:0x4173f0` (animation instance), `Z:0x4176f0` (StartAnim), `Z:0x417750` (animation tick), `Z:0x4170d0` (frame lookup):

- Frame delay: GIF Graphic Control Extension delay (1/100 s) times 10, in ms (zdc:24841).
- A frame without its own GCE uses the delay of the last GCE read before it. The first frame without any GCE gets 0 (zdc:24716, zdc:24724; the variable is set once before the block loop).
- Slots: each frame gets `delay_ms / 50` slots (integer division, truncation) (zdc:22867, zdc:22887). A frame with a delay below 50 ms gets 0 slots and is never shown. Delays that are not multiples of 50 ms are cut down (for example 80 ms becomes 50 ms). Slot and frame indices are bytes: at most 256 frames, and a delay of 12 800 ms or more is not handled (byte counter) (inferred from the code, no asset is affected).
- Loop: the loop flag is set when the GIF has a NETSCAPE2.0 extension with a 3-byte sub-block. The loop count is ignored: any NETSCAPE2.0 extension loops forever (zdc:24742-24758, zdc:24881).
- Each animation instance has its own 50 ms engine timer (`Z:0x413440(this, 0x32, Z:0x417850)`, zdc:23015). It uses the game clock, unless SetRealTime is set (`Z:0x4177d0`, used by the shell and the ad banner only).
- StartAnim: store the start time, Start the 50 ms timer (no effect if it already runs), show frame 0 at once.
- On each 50 ms timer fire: `slot = (now - animStart) / 50`. If `slot < nslots`: frame = table[slot]. Else if looping: table[slot % nslots]. Else: frame 0 (`Z:0x417137`..`Z:0x417162`). The frame is selected from wall-clock (game clock) time, not from a tick count. A changed frame adds its rectangle to the dirty list (`Z:0x417800`, `Z:0x414ef0`). It becomes visible at the next render timer fire.
- StopAnim: Stop the timer. The current frame stays.

Moeboid assets (from `assets/*/decoded/gifs.json`, checked with the rules above):

| Asset | Frames | Delays (ms) | NETSCAPE | Engine behaviour |
|---|---|---|---|---|
| ANI-TITLESCREEN_ANIMATION-500X79 | 24 | 500..4000, total 30 500 | yes (count 0) | loops forever, cycle 30.5 s. **The brief says "no loop extensions"; this file has one** (`extensions` in gifs.json) |
| IMG-BACKGROUNDSCREEN-500X420 | 3 | 1000, 1000, 6000 | no | start sequence: frame 0 at 0 s, frame 1 at 1 s, frame 2 at 2 s; the screen is removed at the first 100 ms tick with elapsed > 3000 ms. Frame 2 is also kept as the game-play background (`G:0x100016a0`, gdc:345-349; inferred from the index argument 2) |
| ANI-BADDIE-BLOB-39X39 | 6 | 100 each | no | plays once (600 ms), then frame 0; the game removes it about 600 ms after start |
| ANI-BADDIE_*/ANI-MEBOID_* | 3-4 | 100..1000 | yes | loop forever |

All Moeboid delays are multiples of 50 ms, so no frame is lost. Ad-banner GIFs (not ported) have delays of 80, 1120, 2640, 2720 ms that the engine truncates.

## 5. Effective real rate on period hardware

The rate is set by the step of `GetTickCount`, because every timer compares `GetTickCount` values (section 2.3) and the loop polls without pause. Simulation of the exact fire rule against a clock that steps by S ms (scratch `sim.py`; clock model `floor(k * S)`, inferred from the NT tick-count design):

| GetTickCount step S | 20 ms game timer | 50 ms render and animation timers | 100 ms start timer |
|---|---|---|---|
| 1 ms | 20.000 ms, 50.0 Hz | 50.0 ms, 20.0 Hz | 100 ms |
| 10.0144 ms | 20.03 ms, 49.93 Hz | 50.07 ms, 19.97 Hz | 100.14 ms |
| 15.625 ms | 31.25 ms, 32.0 Hz | 62.5 ms, 16.0 Hz | 109.4 ms |
| 54.925 ms | 54.9 ms, 18.2 Hz | 54.9 ms, 18.2 Hz | 109.9 ms |

Which systems had which step (external knowledge, not verified in this project):
- Windows NT 4.0/2000 on a single-CPU PC: about 10 ms (10.0144 ms). Multi-CPU and ACPI APIC HALs, thus most Windows XP PCs: 15.625 ms. Some single-CPU XP PCs: 10.0144 ms. On the NT family, `timeBeginPeriod` changes the interrupt rate but not the `GetTickCount` step (inferred from the documented tick-count design; other programs could not make it finer).
- Windows 95/98/ME: the period SDK documentation states about 55 ms for the system timer behind `GetTickCount`. Whether another program that called `timeBeginPeriod(1)` made it finer on 9x is unknown.
- Wine (reference runs): unknown until workstream I measures it.

Start sequence end (100 ms timer, condition `elapsed > 3000`, `G:0x100045a0`), from `sim.py`: 3100 ms (1 ms step; the fire at exactly 3000 does not pass `>`), 3004 ms (10.0144 ms step), 3062 ms (15.625 ms step), 3075 ms (54.925 ms step).

Thus the original rate depended on the OS. The coded intent is a 20 ms game tick and a 50 ms render period (verified constants). The rates the 2000-2004 player saw were about 50 Hz (Windows 2000 on a single-CPU PC), 32 Hz (most Windows XP PCs) or 18.2 Hz (Windows 98/ME), all inferred.

Recommendation for the port: use a virtual clock with a 1 ms step. This gives the coded rates exactly: 20 ms game tick (50 Hz), 50 ms render, 50 ms animation, 100 ms start timer. Reasons: (a) the constants in the code are the only verified intent; (b) Windows 2000 on 10 ms hardware gives nearly the same result (49.93 Hz); (c) the result is deterministic and the same on all browsers.

Decision for the user (alternatives): make the clock step a setting of the port. The same engine code then reproduces any original platform exactly:
- A. 1 ms step (recommended): 50 Hz ticks, 20 fps display.
- B. 15.625 ms step: 32 Hz ticks, 16 fps display, slower player acceleration (Windows XP feel).
- C. 54.925 ms step: 18.2 Hz ticks and display (Windows 98 default feel).

## 6. Input sampling relative to ticks

- Window messages are drained completely before each timer pass (section 1.1). Mouse and key messages go through WndProc `Z:0x4040e0` to the input subsystem (global `0x45cfa4`) and the event channels, synchronously, between passes (verified). Event ids from WndProc: 1 `WM_LBUTTONDOWN`, 2 `WM_LBUTTONUP`, 3 `WM_LBUTTONDBLCLK`, 4 `WM_RBUTTONDOWN`, 5 `WM_RBUTTONUP`, 6 `WM_RBUTTONDBLCLK`, 7 `WM_MOUSEMOVE`, 0xb `WM_KEYDOWN`, 0xc `WM_CHAR`, 0xd `WM_KEYUP` (verified, zdc:3557-3740). Esc is taken by the shell (pause toggle) and never reaches the game.
- The game play tick polls 4 keys with `GetKeyState` once per tick (`G:0x10003200`, `Z:0x426bf0`). `GetKeyState` returns the state as of the last message the thread took from the queue (Windows behaviour). Because the queue is drained before the pass, the tick sees all key transitions up to the start of the pass (inferred).
- A key pressed and released between two ticks is not seen by the poll (inferred). It is still seen by the event 0xb listener (used for y/n and space only, `G:0x10002e20`).
- Device details: workstream F.

## 7. Rendering cadence

- The render timer: `Z:0x41d7c9` creates a timer `(shell, 50 ms, Z:0x41f1d0)`, Starts it, then sets run-while-paused (verified, zdc:28183-28188). The callback `Z:0x41b170` calls `Z:0x41b210`.
- `Z:0x41b210` (verified, zdc:26468-26491): if the dirty list is not empty (`video +0x4c`), redraw the tree inside the dirty rectangles, call `video +0x34` (present), clear the list (`video +0x40`). If nothing changed, nothing is drawn.
- Dirty list (`Z:0x413860`): up to 10 000 rectangles; a rectangle equal to the last one is not added again (verified).
- Present (DirectDraw path, `Z:0x408a90`): one `IDirectDrawSurface::Blt` of the full client area (800x572 or 640x460) from the back surface to the primary surface with `DDBLT_WAIT` (0x1000000) (verified). `DDBLT_WAIT` waits for the blitter, not for vertical blank (DirectDraw documentation, external). No `Flip` and no `WaitForVerticalBlank` call found (checked: the two `CALL [reg+0x58]` sites call engine objects). Tearing was possible (inferred). GDI fallback (no DDraw.dll, `Z:0x426ce0`): the same vtable slot +0x34 is `Z:0x428a70` (`GdiFlush`, then `BitBlt` to the window DC), thus the same cadence (verified, vtable `Z:0x42f138`). Details: workstream D.
- Other render calls (verified, callers of `Z:0x41b210`): `WM_PAINT` (adds the paint rectangle, renders at once), deactivation, before modal dialogs and message boxes.
- Game code never renders. Sprite moves and frame changes only add dirty rectangles (inferred from the call graph: `Z:0x41b210` has no other callers and no indirect references).
- Result: the screen shows a new image at most every 50 ms (20 fps on a 1 ms or 10 ms clock, 16 fps on 15.625 ms, 18.2 fps on 55 ms). Between two renders about 2.5 game ticks run; their intermediate states are never shown.

## 8. Original engine loop (pseudo-code)

```
procedure MainLoop():
    loop:
        while queue has message m:
            if m is WM_QUIT: exit
            dispatch(m)                      // input events, WM_PAINT render, WM_ACTIVATE
        if inactive: continue                // window not active: no timers, no render
        for i in 0 .. timers.count-1:        // count re-read each step
            t = timers[i]
            if paused and not t.realtime: continue
            now = t.realtime ? GetTickCount() - base
                             : GetTickCount() - base - pausedTotal
            if (uint32)(now - t.last) >= t.period:
                t.callback({t.userdata, now - t.start, now - t.start, now})
                t.last = now

Start(t):   if not t.started: t.started = true; timers.append(t); t.start = t.last = clock(t)
Stop(t):    t.started = false; timers.remove(t)
SetPaused(p): if p != paused:
                 if p: pauseAt = realNow
                 else: pausedTotal += realNow - pauseAt
                 paused = p
```

## 9. Proposed fixed-timestep design for the port

Goal: the same timer sequence as the original, independent of `requestAnimationFrame` (rAF) and of the display refresh rate.

Principle: the original is a discrete-event system on an integer millisecond clock. Callbacks take no virtual time. A timer fires at the first clock step `>= last + period`. The port runs the same rule on a virtual clock and drives it from the wall clock.

```
const STEP = 1            // ms; setting: 1, 10.0144, 15.625, 54.925 (section 5)
let k = 0                  // virtual clock steps done
let wallBase = null

function tickCount(k) { return Math.floor(k * STEP) }   // emulated GetTickCount

function advanceTo(wallMs):                    // called from rAF
    target = Math.floor(wallMs / STEP)         // steps that should be done
    if target - k > MAX_STEPS:                 // tab hidden, long stall: original behaviour
        k = target - 1                         // = one late pass, no catch-up
    while k < target:
        k += 1
        deliverInputEventsUpTo(k * STEP)       // queued DOM events with timeStamp <= this step
        if not inactive: runTimersPass()       // exact rules of section 8, reads tickCount(k)

function frame(ts):                            // rAF
    advanceTo(ts - wallBase)
    if composedFrameIsNew: blit offscreen canvas to visible canvas
    requestAnimationFrame(frame)
```

Rules:
1. Clock: keep integer ms. Emulate GetTickCount, the real clock (`tick - base`) and the game clock (`tick - base - pausedTotal`) exactly as in section 2.1.
2. Timers: one array in Start order, the poll rule of section 2.3, `last = now`, no catch-up, the skip-after-remove behaviour of section 2.4, Start ignored when already started.
3. Optimisation (optional, same result): instead of every step, jump to the next step at which any timer can fire (`min(last + period)` rounded up to a clock step), because no timer fires in between. Input events must still be inserted at their own steps.
4. Rendering: compose the scene only in the 50 ms render-timer callback, into an offscreen canvas, with the original dirty-rectangle rules. rAF only copies the last composed image. This keeps the original 20 fps look on 60, 120 or 144 Hz displays. Option for the user: compose after every game tick (smoother, not original).
5. Input: queue DOM events with `event.timeStamp` (same time base as rAF). Deliver each event before the first unprocessed pass whose time is at or after its time stamp; an event that arrives after its step was processed goes to the next step. This keeps the original order "all messages, then the timer pass". Keep a key-state table updated by the delivered events; the per-tick key poll reads that table (as `GetKeyState`).
6. Focus: on `blur` or `visibilitychange` (hidden), do what `WM_ACTIVATE` inactive does: toggle pause if a game runs and it is not paused, render once, then stop the passes. On focus, clear `inactive`; the pause stays on (as the original). rAF is throttled when hidden; after the return, the `MAX_STEPS` check in `advanceTo` gives one late pass, as the original.
7. Long stalls (`MAX_STEPS`, for example 250 ms): one pass with the late time, as the original under CPU starvation. For normal frames all steps run, so the tick sequence does not depend on the frame rate.
8. RNG: MSVC LCG with the formula of section 3.1. Seed from the time at start (original behaviour). For tests, use a fixed seed: with a fixed seed and scripted input at fixed virtual times, the run is deterministic.
9. Animations: the slot rules of section 4, driven by their own 50 ms timers on the game clock.
10. Sound loop restarts: the original restarts a looping DirectSound buffer from a 10 ms poll thread, so there is a gap of 0-10 ms (plus scheduling) between repeats (inferred, `Z:0x409340`). Details: workstream F.

Facts that affect the choice of technology:
- Integer ms clock and unsigned 32-bit arithmetic: use `Math.floor` and `>>> 0` (JavaScript) or integer types (WebAssembly).
- Float math in game updates is single precision (`float` fields, gdc:184-212). JavaScript numbers are double: use `Math.fround` after each operation to match, or a language with `f32` (see workstream J for FPU details).
- The main loop is single-threaded and deterministic. No worker thread is needed for timing.

## 10. Comparison with reference measurements

Checked at the end of this work: `analysis/reference/traces/` holds only `startup_net_files_relay.txt` (file, LoadLibrary and network relay calls; no `GetTickCount`, `Sleep` or `Blt` entries). It agrees with the load order in this document (`DDraw.dll` at `Z:0x426d13`, then `DSound.dll` at `Z:0x408eb3`, then `Moeboid.gam`), but it has no timing data. `NOTES.md` status: IN PROGRESS. Expected values to check when timing traces exist:
- `GetTickCount` step under Wine.
- Game-tick interval in game play: 20 ms at a 1 ms step, else per the table in section 5.
- Render (`Blt` to primary) interval: 50 ms, or less frequent when nothing changes.
- Title animation frame changes at multiples of 50 ms after StartAnim, cycle 30.5 s.

## 11. Facts for other workstreams

- B (interface): timer interface vtable `Z:0x42ed68` and the `ctx[4]` methods +0x34, +0x3c, +0x44 (section 3.1). `ctx[4]+0x44` is AddEventListener, not a timer call. `ctx` +0x08 is `rand()`.
- D (rendering): render only from the 50 ms real-time timer, dirty list max 10 000, full-window `Blt` with `DDBLT_WAIT`, no flip, no vblank wait (section 7).
- F (input/audio): input event ids (section 6), per-tick `GetKeyState` poll of keys 6-9, sound thread `Sleep(10)` poll (section 1.2).
- G and J: typing `INVINCIBLE` on the start screen sets the cheat flag `G:0x1000f604` (no life loss, checked in `G:0x10002ea0`); typing `credits` opens the credits screen (`G:0x100043f0`).
- G (shell): event 0x10 = help page request to the game; Esc and deactivation toggle the pause; dialogs pause and restore (section 2.5).
- Asset index: the title animation GIF has a NETSCAPE2.0 extension (loop forever); `assets/INDEX.md` lines 113-114 are correct for BLOB and BACKGROUNDSCREEN only.
