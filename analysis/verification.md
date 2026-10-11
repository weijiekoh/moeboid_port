# Exactness verification strategy (workstream J)

Status: COMPLETE for phase 1.

Labels: **verified** = read from code, data or a prototype log at the given reference. **inferred** = conclusion, with the reason. **unknown** = not determined.
References: `G:0x1xxxxxxx` = address in `extracted/Moeboid.gam`. `Z:0x4xxxxx` = address in `extracted/ZapSpot.exe`. `gdc:N` = line N of `analysis/decomp/Moeboid.gam/decompiled.c`. Logs are in `analysis/verification/logs/`.
Inputs from other workstreams: `analysis/interface.tsv` and `interface.md` (B), `timing.md` (C), `rendering.md` (D), `fonts.md` (E), `audio-input.md` (F), `shell.md` (G), `analysis/reference/` (I).

## 0. Summary

1. **The original game logic runs in a headless emulator.** The Unicorn harness loads Moeboid.gam, runs its DLL entry, calls `Shell_StartApplet` against a mocked engine, and drives it with engine timer ticks and scripted input. It reaches every screen: help page, title, CREDITS screen, start sequence, game play, eating, growth, extra life, death, game over, high-score input, play again, back to title, INVINCIBLE cheat. 0 unmodelled interface methods. 70 of 72 game functions run; the 2 others are dead code (verified, `logs/run_tour.log`).
2. **The harness is deterministic and replayable.** Same input recording, same per-tick hashes of the interface call log and of the game state: verified with repeat, replay, three stack/heap scribble bytes, a relocated image base, and a 120 s coverage tour (`logs/checks.log`).
3. **The game logic has few nondeterminism sources** (section 2): engine `rand()` (21 call sites), its own CRT `rand()` (1 site), timer elapsed time, key state and key events, button clicks, the InputBox text, the settings store, and DLL-lifetime static variables. No uninitialised memory reaches an observable output in the tested runs. The game reads no clock itself.
4. **FPU:** float32 positions from FSIN/FCOS are exact in IEEE double for all 179 000 reachable inputs, but the unrounded y value of the spawn distance test differs by 1 ulp in 11 470 inputs (6.4 %). Unicorn, QEMU, JS and wasm all share this difference. A 1000-entry table of x87 results plus one exact rounding step removes it (0 mismatches). All other x87 code is IEEE-double-equivalent at the 53-bit precision that the CRT sets (section 3).
5. **Strategy:** lockstep differential testing of game logic against the Unicorn reference, with a shared input recording format, is feasible and cheap for options (a), (c) and (d). Rendering, fonts, audio, timing and shell need separate oracle checks (section 4). Without a real Windows 2000/XP machine, fonts and timing have no single ground truth (section 7).
6. **Verdict: feasible.** Estimated verification effort: 16-24 person-days on top of the port, depending on the option (section 6).

## 1. Prototype harness

### 1.1 Files

| File | Content |
|---|---|
| `verification/harness/emu.py` | Unicorn machine: PE loader (sections, base relocations, KERNEL32 imports to stubs, exports, resource index), GDT/TEB (FS for SEH), flat SS/DS/ES, 1 MiB stack, bump heap, VirtualAlloc arena, FSIN/FCOS table hook |
| `verification/harness/mock.py` | Generic engine-interface mock and engine model (timers, events, rand, settings, inputs) |
| `verification/harness/run.py` | Driver: DllMain, `Shell_StartApplet`, scripts (`start`, `autopilot`, `tour`), replay, logs, game state digest, coverage |
| `verification/harness/checks.py` | Determinism and fidelity checks, writes `logs/checks.log` |
| `verification/harness/callsites.py`, `callsites.tsv` | Static stack-argument count of all 297 indirect calls in game code |
| `verification/harness/crosscheck.py` | Compares `callsites.tsv` and the mock with `analysis/interface.tsv`, writes `logs/interface_crosscheck.log` |
| `verification/harness/engine_vtables.py` | Static `RET n` of every ZapSpot.exe vtable method (helper, superseded by `interface.tsv`) |
| `verification/fpu/fsin_check.c`, `unicorn_fsin.py`, `x87_fsin_table.tsv`, `fsin_check.log` | FPU test (section 3) |
| `verification/logs/` | `run_autopilot.{log,ticks.tsv,input.tsv}` (60 s reference), `run_tour.{log,input.tsv}` (coverage tour), `quirk_play_again.log`, `checks.log`, `interface_crosscheck.log` |

Commands (from `analysis/verification/harness`, after `source tools/env.sh`):

```
python -I -B run.py --script autopilot --ms 60000 --out /tmp/x      # run, log, recording
python -I -B run.py --replay ../logs/run_autopilot.input.tsv --out /tmp/y
python -I -B checks.py SCRATCH_DIR                                   # all checks, about 25 s
python -I -B crosscheck.py
```

Speed: 60 s of game time in 1.7 s, 120 s in 5.7 s wall time on the i7-13700HX (verified, `logs/run_autopilot.log`, `logs/run_tour.log`).

### 1.2 Machine

- Guest isolation: the guest sees only its image, a stack, a heap arena and fake objects. All 53 KERNEL32 imports go to Python stubs. `CreateFileA` is denied. `FindResourceA`/`LoadResource`/`SizeofResource` read the PE resource directory of the image. No file, network or OS access (verified, `emu.py`, `WIN32_STUBS`).
- DllMain: CRT start-up runs to completion, returns TRUE (low byte 1) (verified, `logs/run_autopilot.log`). The CRT init calls `_controlfp(_PC_53, _MCW_PC)` at G:0x10005976 from G:0x10005146 (verified: hook hit once, FPCW precision field changes from 64 to 53 bit).
- Fixes to the earlier draft of `emu.py`: Unicorn needs explicit flat SS/DS/ES loads, else ESP wraps at 64 KiB (verified, first run faulted at 0x0000feec).

### 1.3 Interface mock

- Each engine object is a fake object whose vtable slots point to distinct stub addresses. A stub logs call site, object id, interface, offset, arguments and return value.
- Stack cleanup: the number of stack arguments comes from the call site, not from the method (`callsites.tsv`, keyed by the CALL address; found from the return address). The mock pops them (callee cleanup, `__thiscall`).
- Cross-check with workstream B (`logs/interface_crosscheck.log`, verified): 54 interface rows, 295 call sites. 0 mismatches of offset, argument count, callee pop bytes (`pop = 4 * argc` for every row) and mock signature. The 2 sites that B does not list (G:0x10001c75, G:0x10001dc1) call the scalar deleting destructor of the game's own state objects (vtables at G:0x1000d150..), not the engine.
- Run-time checks (verified, `logs/run_autopilot.log` footer): no (interface, offset) with two argument counts; no direct field read of an engine object by the game (only `ctx[2..6]`); ECX always equals the object of the called vtable.
- Canonical log: arguments rendered by type (int, uint8, string, object id, `ptr` for out-parameters and game pointers, `code:ADDR` for callbacks). The log is independent of load address and heap layout (verified: relocated image gives identical hashes). Colour arguments are uint8 (interface.tsv); the game pushes them as dwords whose upper 24 bits are stale stack data (G:0x10004d58, G:0x10004d74, G:0x10004d91, verified), so the log keeps only the low byte.

### 1.4 Engine model in the mock

| Behaviour | Model | Source |
|---|---|---|
| Random (ctx+0x08) | MSVC `rand()`, `s = s*214013 + 2531011`, `(s>>16) & 0x7fff`; seed is a free input | interface.tsv (verified by B) |
| Timers | started timers in Start order; fire when `(uint32)(now - last) >= period`, `last = now` after the callback, no catch-up; Release removes the timer (array shift skips the next one in that pass) | timing.md 2.2-2.4 |
| Timer event | `{userdata, now-start, now-start, now}`; game reads `+8` | timing.md 2.3 |
| Clock | `floor(k * step)`, step 1 ms default; 10.0144, 15.625, 54.925 selectable | timing.md 5 |
| Listener event | `{userdata, 0, wParam}`; 0xb = WM_KEYDOWN virtual-key code; 0x10 = help page | interface.tsv, audio-input.md, timing.md 3.2 |
| Button event | `{userdata, id, id}` | interface.tsv |
| GetKeyState | 0x80 if the engine key index (6 left, 7 right, 8 up, 9 down) is down | interface.tsv |
| Settings | dictionary; GetGameValue returns 0x19 if the name is missing | interface.tsv |
| InputBox | answer from the recording (default "TEST") | inferred |
| Sizes | GIF logical screen size read from the resource | inferred (B: size of the current image) |
| MeasureText | **placeholder** 7 px per character, 16 px high | real metrics: fonts.md |

Not modelled (they do not change game logic, or they are outside the game): rendering, animation frame timers, render timer, sound output, pause on help page and dialogs (the game clock stops; the harness makes dialogs instantaneous, which is equivalent), focus loss, shell menu actions. "New Game" from the shell menu unloads and reloads the DLL (interface.md, Stop/Start); the harness does not model a DLL reload yet (see 2.2).

### 1.5 Results (how far it gets)

| Run | Result | Reference |
|---|---|---|
| DllMain + `Shell_StartApplet` | 602 interface calls: 45 GIF loads, 11 sounds, title screen, high-score table, Start button | verified, `logs/run_autopilot.log` T2 |
| `autopilot` 60 s | help page, Start, start sequence (100 ms timer, elapsed > 3000), 2835 ticks, 35 baddies eaten, 3 growths, 4 lives lost, game over with high score, InputBox, play again | verified, `logs/run_autopilot.log`, `.input.tsv` |
| `tour` 120 s | additionally CREDITS screen (100 baddies, 20 ms timer), Done button, No button, INVINCIBLE cheat; 5663 ticks; 70/72 game functions, 88.5 % of game code bytes | verified, `logs/run_tour.log` |
| Blockers | none for game logic. Placeholder font metrics change text layout coordinates in the log (the game positions text runs from MeasureText results, G:0x10004a00) | verified |

The two functions never entered: G:0x10002680 (base-class scalar deleting destructor; derived destructors are always used) and G:0x10005030 (integer parser without callers) (verified, functions.tsv callers).

### 1.6 Checks (`logs/checks.log`, verified)

| Variant of the 60 s reference | Per-tick call hash and state digest |
|---|---|
| same command again | identical, 2835 ticks |
| replay of the input recording | identical |
| scribble 0x00, 0xa5, 0x5a (stack below ESP before each callback, every `operator new` block) | identical |
| initial stack and heap fill 0xcc | identical |
| image relocated to 0x20000000 | identical |
| Unicorn FSIN/FCOS instead of the x87 table | identical (no spawn decision changed in this run) |
| engine seed 999 | diverges at tick 35 (first game tick that uses rand) |
| GetTickCount step 15.625 ms | diverges at tick 5 (first 100 ms tick at 1109 ms) |
| tour replay | identical, 5663 ticks |

## 2. Nondeterminism sources in Moeboid.gam

### 2.1 Table

| Source | Where | Notes |
|---|---|---|
| Engine `rand()` (ctx+0x08) | 21 sites: G:0x10001071, 0x1000109b, 0x100010b6, 0x100010e0 (baddie speed and sign, G:0x10001060); 0x100011d0, 0x100011f3 (CREDITS spawn); 0x1000121b, 0x10001240 (spawn radius and angle); 0x10001320 (spawn delay); 0x10001489 (1/100 direction change); 0x10002842 (CREDITS sizes); 0x10002b6a, 0x10002c6f (level sizes, first background sound); 0x10003035 (next background sound); 0x1000355c, 0x100035dc, 0x100035f4, 0x100036ea, 0x10003767, 0x1000377f, 0x100040eb (new baddie sizes) | verified, interface.tsv. Engine seeds with `timeGetTime()` (Z:0x403dc4) and consumes one value in the banner constructor (Z:0x421c8f) before the game starts (interface.md). The number of calls per tick depends on the spawn retry loop |
| Game CRT `rand()` | G:0x10005639, called only at G:0x10002fa3 (death animation x jitter, `rand()%3==1`) | verified. Seed `DAT_1000ea40` = 1 in the file, no `srand`. State lives as long as the DLL image |
| Timer elapsed ms (`ev+8`) | G:0x10002a10 (CREDITS), G:0x10002ea0 (game), G:0x100045a0 (start sequence > 3000 ms) | verified. Motion is time based, acceleration and direction changes are per tick (timing.md 3.3). The elapsed sequence depends on the GetTickCount step and on stalls |
| Key state poll | ISystem+0x20 at G:0x10003200 (keys 6, 7, 8, 9; 10 ms hold rule against elapsed time) | verified |
| Key-down events (0xb) | G:0x10002e20 (Space, Y, N), G:0x100043f0 (CREDITS, INVINCIBLE words) | verified. Auto-repeat creates more events (audio-input.md) |
| Button clicks | Start (G:0x10004990), Yes/No (G:0x10003f50), Done (G:0x10002a60) | verified |
| Help event 0x10 | G:0x10001f40 | verified |
| InputBox text, MessageBox | G:0x100037d0 (name; length >= 13 gives "Name too long" and a new InputBox) | verified |
| Settings store | GetGameValue at G:0x10004640 (table), G:0x100037d0 (insert, "LastNameEntered") | verified. Persistent input. GetGameValue copies without a size limit into 20- and 100-byte stack buffers (interface.tsv, gdc:1899): stored values must stay short |
| DLL-lifetime static state | `DAT_1000f5d0`/`DAT_1000f5d4` (local static of G:0x10002330), `DAT_1000f5ec`, `DAT_1000f5f8`, `DAT_1000f5e8`, `DAT_1000f5f4`, `DAT_1000f5fc` (death animation), `DAT_1000f5f0` (key flags), `DAT_1000f604` (INVINCIBLE), `DAT_1000f605` (CREDITS mode), `DAT_1000ea40` (CRT rand) | verified from code. See 2.2 |
| Uninitialised memory | baddie +0x26, +0x27, +0x31..+0x33; player +0x05..+0x0b, +0x29..+0x2b; game state unused slots, +0x1af, +0x1b8, +0x1d4 before the first tick | verified by scribble (prototype): never read in a way that changes calls or the state digest. Colour dwords: see 1.3 |
| Floating point | FSIN G:0x1000125d, FCOS G:0x1000126e, FSQRT G:0x10001298; precision control | section 3 |
| Memory layout, heap addresses | none observable | verified (relocation and scribble checks) |

### 2.2 Verified quirk from DLL-lifetime statics

"Play again" (Y) creates a new game state (G:0x10002a80) but does not reset `DAT_1000f5ec`/`DAT_1000f5f8` or the static `DAT_1000f5d0` of G:0x10002330 (verified, gdc:1209-1300, gdc:840-843). Result in the harness (`logs/quirk_play_again.log`):

- Ticks T1877 and T1878 run the old death-animation branch (G:0x10002ea0, gdc:1461-1478) and only remove the angel sprite.
- T1879: the first player update computes `dt = (uint32)(20..60 - old_last)`, about 4.29e9 ms. With a key held, the clamp formula moves the Moeboid from (242.5, 202.5) to (240.0, 204.0013) and sets its speed to 0 (state digest bits `x=43700000 y=434c0056`).

A port must keep these statics with the same lifetime: they persist across "play again" and "No" (same DLL), and reset when the shell reloads the DLL for "New Game", if the image is unmapped (interface.md: the engine `CFile` also holds a reference; unknown).

## 3. Floating point

### 3.1 Spawn position FSIN/FCOS (G:0x10001252..0x100012a9)

Sequence (verified, listing): `FILD qword k; FMUL float 0x3bcde32e; FLD ST0; FSIN; FMUL float r; FADD float 249; FST/FSTP float x; FCOS; FMUL float r; FADD float 207; FST float y` and the **unrounded y stays in ST0** for `FSUB float py ... FSQRT; FCOMP double 80.0` (retry while distance <= 80).

Domain: k = rand % 1000 (0..999); r = rand % (0xbe - width), width = baddie GIF width 11..47 (assets/INDEX.md), so r = 0..178. The test covers all 1000 x 179 = 179 000 pairs, and the exact instruction order with precision control 53 bit (verified, `fpu/fsin_check.c`).

Results (`fpu/fsin_check.log`, host i7-13700HX, glibc 2.44, Unicorn 2.1.4, verified):

| Path | x float32 | y float32 | y unrounded (53 bit) |
|---|---|---|---|
| B: IEEE double + libm sin/cos | 0 mismatches | 0 | **11 470** (1 ulp) |
| C: table of x87 FSIN/FCOS rounded to double | 0 | 0 | **11 470** |
| D: table of 80-bit x87 FSIN/FCOS + FMUL rounded once to 53 bit (integer arithmetic) | 0 | 0 | **0** |
| Unicorn, original bytes, own FSIN | 0 | 0 | 11 470 (same as B: QEMU calls host `sin()` on a double) |
| Unicorn, original bytes, harness table hook | 0 | 0 | **0** |

Cause: x87 multiplies the 64-bit-significand FSIN result by r and rounds once; double arithmetic rounds sin first. Effect: the retry decision can differ only when the distance is within about 1e-13 of 80.0 (inferred from the 1-ulp size). In the 60 s and 120 s runs it changed nothing (verified, `checks.log`). Recipe for a port: `fpu/x87_fsin_table.tsv` (1000 entries, 80-bit) plus path D (`mul80_pc53` in `fsin_check.c`, about 25 lines; BigInt in TypeScript). Do not use `Math.sin`: it is not specified to be correctly rounded and differs between engines (inferred).

### 3.2 Other x87 code

- Instruction census of game code (verified, listing.asm 0x10001000..0x10005137): FLD, FST(P), FILD, FISTP (in `__ftol`), FMUL, FADD, FSUB(R), FISUB, FDIV, FCOM(P), FNSTSW, FSQRT, FSIN, FCOS, FLDCW/FSTCW (only in `__ftol`).
- Precision control 53 bit: set by the game CRT at DLL load (G:0x10005976, verified in the harness) and by the engine CRT (Z:0x4108af calls the controlfp helper Z:0x4115eb; the only FLDCW in the engine is Z:0x4115e3) (verified). System DLLs could change it; DirectDraw without Direct3D does not (inferred).
- With PC=53, FADD/FSUB/FMUL/FDIV/FSQRT round once to 53 bits: equal to IEEE double for the value ranges of this game (no overflow, no subnormals; inferred from the ranges: coordinates < 1000, times < 2^32). A port must round to float32 exactly where the original stores to a float variable, and nowhere else (Ghidra's `float` types hide where values stay in registers; check the listing).
- `__ftol` (G:0x10005110): truncation to int64 with rounding mode "chop", then the low 32 bits. Out-of-range values give the low dword of 0x8000000000000000 = 0. A C cast in wasm traps on overflow; JS `| 0` wraps differently. A port needs an explicit helper.
- Constants: the port must use the same constant width (float 0.01f and double 0.01 differ). The lockstep test detects a wrong width.

### 3.3 FPU conclusion

Exact gameplay needs: double arithmetic with float32 rounding at the original store points, the `__ftol` helper, unsigned 32-bit time arithmetic, and the FSIN/FCOS table with path D. The table is measured on one Intel CPU. Other x87 implementations (other Intel generations, AMD, Cyrix) may give other last bits for FSIN; the original players did not all see the same values (inferred). So "exact" means exact against this reference.

## 4. Strategy

### 4.1 (a) Lockstep differential testing of game logic

Reference: the original gam in the Unicorn harness with the mock engine. Candidate: the port's game logic (or, for options (b) and (d), the port's CPU core).

1. Common inputs: one input recording (4.7) with engine seed, clock model, initial settings, and all inputs with their tick numbers.
2. Common boundary: the engine interface of `interface.tsv`. The port's game logic calls an engine API with the same methods and argument order; a logger renders each call in the canonical form of `mock.py` (`_method`, `canon_args`).
3. Per-tick comparison: tick number, game-clock ms, number of calls, SHA-256 of the canonical call lines, SHA-256 of the state digest (`run.py` `game_state`: player level, x, y, vx, vy as float32 bits, score, lives, baddie count, all baddie records). Both sides write `ticks.tsv` in the same format; a diff gives the first diverging tick.
4. On divergence: rerun both sides with `--log-range A-B` for the full call lines and state of the diverging ticks.
5. Engine return values that the game reads (rand, GetKeyState, GetSize, MeasureText, GetLoc, GetGameValue, InputBox) come from the shared engine model, so the comparison isolates the game logic. Use the real metrics tables of fonts.md in both, not the placeholder.
6. Corpus: `autopilot` and `tour` recordings at clock steps 1, 10.0144, 15.625, 54.925 ms, several seeds, plus targeted recordings: CREDITS screen, INVINCIBLE, "Name too long", long holds and auto-repeat, stalls (clock jumps), play again with keys held (2.2), many games in one DLL lifetime. Track coverage with `--coverage` (target: 70/72 functions, all branches that the static review lists).
7. CI: one command per side, under 1 minute for the corpus (inferred from 1.7 s per minute of game time).

What it proves: identical calls and state for the recorded scenarios. What it does not prove: see section 7.

### 4.2 (b) Rendering checks

1. Reference renderer: an independent implementation of the engine compositor from rendering.md (surface tree, painter's order, SetLoc/SetVisible/Attach/Detach, colour key, ClearToColor/FillRect/DrawRect/DrawImage/DrawText, 50 ms animation slots, 50 ms render timer, 800x572 frame) that replays a canonical call log. Python + Pillow is enough.
2. Frames: render both at the same render-timer instants (every 50 ms of game clock, render timer before the game tick when both are due, timing.md 2.4).
3. Compare: RGB 800x572 bitwise. Indexed mode: map with the 8-bit palette of rendering.md (system 20 + web cube) and compare indices; this applies only if the port offers the 8-bit-desktop look (rendering.md 3: the original is RGB on 16/24/32-bit desktops).
4. Cross-check the reference renderer against Wine screenshots of the same screens (workstream I): static screens (title, high-score table, help page) must match outside text areas. Wine is not ground truth for text (FreeType) and timing.
5. Unit images: every GIF frame decoded by the port equals the decoded asset (assets/INDEX.md), including the frame-slot rule (delay / 50 ms) and the loop rule (timing.md 4).

### 4.3 (c) Font checks

1. Ground truth, in order of strength: (1) glyph bitmaps from Windows 2000/XP GDI, dumped by a small test program (not the original binaries) for Arial 8, 10, 11, 12, 14, 18, 24, 36 px, regular and bold, cp1252 0x20..0xFF, with smoothing off and on; (2) Microsoft data in the Arial 2.82 files: hdmx advances and VDMX ascent/descent (fonts.md 10.3: FreeType mono matches all 2674 hdmx widths); (3) MS Sans Serif 13 px strike in `sserife.fon` (exact bitmaps).
2. Checks: atlas glyph = ground-truth glyph bitwise; atlas advance = hdmx; line metrics = VDMX. For each DrawText and MeasureText in the lockstep corpus: port string width = reference width; rendered text block = reference renderer text block, pixel exact.
3. Without source (1), only metrics are proven; single-pixel differences from dropout control remain possible (fonts.md 10.3).

### 4.4 (d) Timing checks

1. Model: choose the clock step to emulate (decision; timing.md 5 lists 50 Hz at 1 or 10 ms steps, 32 Hz at 15.625 ms).
2. Scheduler conformance: feed the port's timer scheduler the same clock sequence as the mock; compare the list of (tick, timer, elapsed) for all three game timers, including late timers (inject a 100 ms stall: exactly one callback, elapsed jumps, `last = now`) and release inside a callback (array shift).
3. Rate: in the browser, measure ticks per real second over 60 s with `requestAnimationFrame` and with a hidden tab; expected 50.0 (or the chosen model) within 1 tick; rendering rate must not change the tick sequence.
4. Pause: help page, dialogs, focus loss and Esc stop the game clock (timing.md 2.5); a replay with a pause must give the same tick hashes as without it, shifted in real time only.

### 4.5 (e) Audio checks

1. Trigger timing: every `ISound.Play` in the lockstep log is a sound event with tick and game-clock ms (`run.py` summary lists them). The port must start the same sample in the same tick; tolerance: one engine sound-thread poll (10 ms, audio-input.md) plus one audio render quantum.
2. Sample identity: decode each WAV `data` chunk; the port's PCM before resampling must equal the file samples (8-bit unsigned: (b-128)/128, 16-bit: s/32768), bitwise.
3. Voice rules: 16 voices for engine and game, a Play with 16 busy voices is dropped, a sound can overlap itself (audio-input.md). Test with a recording that eats many baddies in a short time.
4. Resampling (8000/11025 Hz to the device rate) is not bit-reproducible against DirectSound; check only duration and level.

### 4.6 (f) Platform shell checks

1. Reference: Wine screenshots of the shell screens (workstream I): frame, title bar, menu buttons, game area at client (282,50), banner area 470x62 at (280,500) (rendering.md 0.8).
2. Check layout only: bounding boxes of buttons and panels, positions within 0 px for images, text within the font tolerance of 4.3; the banner area must be blank; removed items (ads, network, downloads) must be absent; Terms of Service dialog if kept.
3. Interactive: click each remaining menu button in a scripted session in both (Wine run by workstream I, port in a headless browser) and compare the resulting screen layout.

### 4.7 (g) Shared input recording format

Implemented as `moeboid-input v1` (TSV, verified: written by `run.py`, replayed with identical hashes):

```
# moeboid-input v1
# gam_sha256=...
# engine_rng=msvc_rand seed=12345 (state before the first game call)
# clock=floor(k*1.0) ms; timer rule: fire when now-last>=period, last=now
# gam_crt_rand_seed=1 (fresh DLL load)
# setting<TAB>Score1Name<TAB>ZapSpot          (initial settings store)
ms     tick  kind     value
500    3     event    16       listener event (16 = help page)
1000   4     click    Start    button label (add parent and id in v2)
4120   36    keydown  9        engine key index (GetKeyState)
33200  1490  vk       32       WM_KEYDOWN wParam
39840  1824  dialog   TEST     InputBox text, consumed inside tick 1824
```
(Rows from `logs/run_autopilot.input.tsv`; the comment column is not part of the file.)

Rules: an input with tick N applies before tick N; `dialog` applies inside tick N. Needed for v2: `pause`/`resume`, `focus`, `stall` (clock jump), `dllreload` (shell New Game), button id instead of label, and the real clock sequence when recorded from a live browser session. The port writes the same format from its input layer, so a bug found in the browser can be replayed in the harness.

## 5. Application to the port options

| Check | (a) C to wasm + TS host | (b) emulation of original binaries | (c) pure TS rewrite | (d) original gam in x86 interpreter + new engine |
|---|---|---|---|---|
| Lockstep game logic (4.1) | Full. The C code calls an engine API with the interface methods; log in C | Game logic is original. Use the corpus to test the emulator CPU/FPU against Unicorn, if the emulator can hook the interface calls (retrowin32: yes, Rust source; v86+Wine: hard) | Full; most needed (uint32, float32, `__ftol` errors are easy in TS) | Engine side only: the interpreter runs the original code; replay the corpus in the browser interpreter and in Unicorn: identical hashes prove CPU conformance |
| FPU (3) | wasm f64/f32 are IEEE; no FMA contraction (`-ffp-contract=off`); FSIN table + path D | Emulator FSIN: v86 uses `Math.sin`, BoxedWine uses its libm (inferred): 1-ulp y differences; patch G:0x1000125d..0x10001273 or accept | `Math.fround` at store points; FSIN table + BigInt path D | Interpreter can hold x87 registers as f64 (all code runs at PC=53) except the FSIN/FCOS + FMUL pair: special-case it with the table and path D |
| Rendering (4.2) | Full | Wine's DirectDraw and GDI (FreeType) are in the loop: compare screenshots against the reference renderer and Windows ground truth | Full | Full |
| Fonts (4.3) | Full | Wine renders with FreeType: not GDI-exact unless patched | Full | Full |
| Timing (4.4) | Full | Emulator timer and GetTickCount behaviour must be checked; busy loop in the browser | Full | Full |
| Audio (4.5) | Full | Wine DirectSound in the loop | Full | Full |
| Shell (4.6) | Full | Original shell: patches for ads, network, downloads must be checked | Full | Full |
| Input format (4.7) | Port records and replays | Needs an input hook in the emulator | Port records and replays | Port records and replays |

Hybrid note (d): the harness is a working prototype of option (d) in Python. The gam imports 53 KERNEL32 functions; 24 are called (CRT start-up, heap, VirtualAlloc, and the 4 resource functions for `Help.zml`) (verified, `logs/run_tour.log` footer). It uses 54 engine interface methods (interface.tsv).

## 6. Effort estimates (person-days, inferred)

| Item | (a) | (b) | (c) | (d) |
|---|---|---|---|---|
| Finish reference harness (real font metrics, DLL reload, pause, input format v2) | 2 | 2 | 2 | 2 |
| Port-side canonical logger, state digest, ticks.tsv | 1.5 | 3-5 (emulator hooks) | 1.5 | 1 |
| Corpus of recordings and coverage review | 2 | 2 | 3 | 1 |
| Reference renderer and pixel compare | 4-6 | 4-6 | 4-6 | 4-6 |
| Font ground truth and atlas checks | 2-3 (+ Windows VM) | 2-3 | 2-3 | 2-3 |
| Timing checks | 1-2 | 2-3 | 1-2 | 1-2 |
| Audio checks | 1-2 | 1-2 | 1-2 | 1-2 |
| Shell layout checks | 2 | 2 | 2 | 2 |
| Total | 16-21 | 18-25 | 17-22 | 14-19 |

Divergence fixing during the port is not included; for (c) expect the most iterations.

## 7. Limits (what the checks cannot prove)

1. **Shared model errors.** The mock engine and the reference renderer come from static analysis (B, C, D, E, F). If that analysis is wrong, the reference and the port agree and both are wrong. Wine runs (I) catch only coarse errors: Wine is not Windows (FreeType text, DirectDraw emulation, Linux timer behaviour).
2. **No differential run against the original.** The engine seeds `rand()` from `timeGetTime()` and the gam calls it through an engine-internal interface that Wine relay traces do not show, so a Wine session cannot be replayed exactly in the harness without instrumenting the engine (not allowed in this phase). Original-vs-harness comparisons are limited to screenshots and statistics.
3. **Coverage.** Equality holds for the recorded scenarios only. Two game functions are dead; 11.5 % of game code bytes did not run in the tour (error paths, rare branches).
4. **FSIN ground truth** is one Intel CPU; period CPUs may differ in the last bits (3.3).
5. **Timing ground truth** depends on the OS GetTickCount step of the player's PC (timing.md 5); the port must choose one model.
6. **Fonts** without a Windows GDI dump: metrics proven, bitmaps not.
7. **Audio** mixing and resampling are not bit-reproducible.
8. **Engine-side quirks outside the game** (render order inside one pass, dirty rectangles, cursor) are checked only by the rendering oracle.

## 8. Decisions and questions for the user

1. Is a Windows 2000/XP machine or VM available for font ground truth (a small GDI dump program, not the original binaries)?
2. Which clock model must the port reproduce: 50 Hz (Windows 2000, 1 or 10 ms step) or 32 Hz (typical Windows XP, 15.625 ms)? Lockstep needs one fixed choice.
3. Must the port keep the "play again" quirk of 2.2 (inferred: yes, under requirement 1)?
4. Accept the FSIN reference of a modern Intel CPU (3.3)?
