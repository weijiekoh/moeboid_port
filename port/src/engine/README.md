# Engine core (M4)

The ZapSpot engine around the original `Moeboid.gam`: applet manager, the 13 interfaces and 54 methods of `analysis/interface.tsv`, surface tree and rendering, events, timers, sounds, settings, modal dialogs. Contract: `docs/port-design.md`. Every routine names the ZapSpot.exe function it copies (`Z:0x...`).

## Files

| File | Content |
|---|---|
| `engine.h` | public API (shell, host exports, tests) |
| `shell_api.h`, `shell_weak.c` | calls from the engine to the shell (M5) and their weak defaults |
| `eng_int.h` | internal objects and functions |
| `engine.c` | start-up, applet Start/Stop/New Game, render timer, present, input routing (WndProc `Z:0x4040e0`), resources, sounds, settings |
| `eng_obj.c` | object table (handles), reference counts, guest wrappers |
| `eng_gfx.c` | CImage, CImageSeq, animation player, CSurface, buttons, font cache |
| `eng_event.c` | event manager: channels, listeners, fire, key dispatch, mouse routing |
| `eng_dispatch.c` | the 54 methods (CPU bridge callback) |
| `eng_modal.c` | guest calls, MessageBox/InputBox, suspend and resume |
| `eng_trace.c`, `eng_callsites.c` | lockstep trace (mock.py canonical lines, run.py state digest) |
| `eng_testapi.c` | test entry points (ctypes, native tests) |
| `../gfx/draw.*`, `../gfx/dirty.*`, `../gfx/cursor.h` | render-target pixel rules, dirty list, cursor ids |
| `../snd/snd.*` | 16-voice table and voice-thread release model |

## Object model

- Engine objects (surface, image, image sequence, animation player, font, timer, sound, listener, channel) are host structures named by a handle (generation << 20 | index). Each has the external and internal reference counts of the original (`Z:0x414f70`..`Z:0x414fc0`) and is freed when both are 0, with the destructor of its class.
- The game sees 8-byte guest wrappers `{vtable, handle}` at `0x60010000..` (fake-object region). The 13 vtables (`0x60800000`) hold engine thunks (`cpu_engine_thunk`). Every factory method and every getter makes a new wrapper and adds an external reference; `Release` (`Z:0x414ff0`) releases, frees the wrapper and returns the remaining external count. ctx (0x1c bytes) and the ISystem object (0x10 bytes, `Z:0x415df0`) live at `0x60000100`.
- The shell root is a CSurface (800x572, opaque, the frame buffer). ctx[2] and ctx[3] are its children at (282, 50), 500x420, opaque; ctx[3] hidden; ctx[2] protected with the shell key (`Z:0x41d6c0`).

## Start-up, Stop, New Game, DLL reload

`eng_init` (core init hook, step 0): fonts and WAV facts from the pack, root surface, 50 ms render timer (first timer of the list, run while paused), root cleared to #3333cc, ctx[2], ctx[3], `shell_frame_build`, then (unless `shell_starts_applet`) `engine_applet_start` (`Z:0x424620`): fresh machine (`cpu_machine_init` = LoadLibraryA), DllMain(PROCESS_ATTACH), ctx and wrappers, `Shell_StartApplet(ctx)`. `engine_applet_stop` (`Z:0x4248a0`): `Shell_StopApplet(ctx)`, wrapper destructors (the ISystem destructor releases its two event channels), DllMain(PROCESS_DETACH), machine destroyed. `engine_new_game` (`Z:0x41c910` engine part): ctx[3] hidden, ctx[2] shown and cleared to its background colour, Stop, children of both surfaces detached, Start.

DLL reload (interface.md 9.1): **the image is unmapped at Stop and mapped fresh at Start** (verified from the code, no Wine run): Start holds one LoadLibraryA reference until Stop's FreeLibrary; every other LoadLibraryA on the game path is paired with a FreeLibrary on the success paths Moeboid uses (enumeration `Z:0x4243b0`; CFile `Z:0x427ef0`/`Z:0x428130`, closed by the GIF loader `Z:0x418d90` and the WAV loader `Z:0x40c680`); the third CFile branch frees without loading, which can only lower the count. So the count reaches 0 at Stop. The port creates a new machine at every Start: DLL statics (for example the INVINCIBLE flag) and the game's CRT rand (`G:0x1000ea40` = 1) start again; the engine rand continues (`test_engine_modal`, `test_new_game`).

## Rendering

The render timer (`Z:0x41f1d0` -> `Z:0x41b210`) renders when the dirty flag is set: `CSurface::Render` (`Z:0x414cd0`) from the root with clip (0, 0, 800, 572); a surface that touches no dirty rectangle returns with its children; else the whole clipped surface is drawn with `Z:0x413f30`, which first invalidates every surface of the source image (rectangles added during the pass also count for later surfaces); then the whole root image goes to `Port.frame` (alpha 255). Invalidation: `SetLoc` (old and new rectangle), `SetVisible`, attach (parent and child), detach (child, after its parent was cleared: no parent offset, quirk bit `ENG_QUIRK_DETACH_DIRTY`), every draw into an image and every frame change (all surfaces of every player of every sequence that holds the image). Draw rules: `gfx/draw.h` (FillRect exclusive edges, GDI lines without the end point after the clamping of `Z:0x40baf0`, Blt rectangle rules of `Z:0x40bf70`, colour key = magenta RGB). Text: `gdi_text.h` with `Port.smoothing` (decision 4b: Standard by default; the page setting "Font smoothing" can switch it off, `port_set_smoothing` before `port_init`).

## Input routing (`Z:0x4040e0`)

Key down: Escape toggles the pause of a running game through `shell_pause_toggle` (`Z:0x41cb30`; minimise removed, decision 8a) and is not passed on; Enter key-down is dropped (`Z:0x4269b0`); other keys go to the key dispatch (`Z:0x425870`: every channel of the type in creation order, until a listener returns 0) with wParam, type and engine key code. Key up: event 0xd; character (kind 9): event 0xc. Mouse: `Z:0x425020` (hit test `Z:0x414a00` with its strict test and the +1 child rectangle, capture surface, enter/leave, click on button up over the pressed surface, cursors). Focus lost: pause toggle of a running unpaused game, one render; the core then stops the passes. `GetKeyState` returns the SHORT sign-extended (down = 0xff80 | toggle).

## Modal dialogs: suspend and resume

MessageBox/InputBox (`Z:0x4058c0`, `Z:0x405480`): save IsPaused, pause, render, `shell_dialog_open`. Closed at once: the method returns the result. Left open: the dispatch calls `cpu_suspend`; the interpreter finishes the thunk and stops; the top-level `cpu_call` returns with `cpu_suspended()`; the guest stack keeps the suspended game call.

1. Unwind: `eng_guest_call` sets `rs = RS_UNWIND`. Every engine loop between the origin and the game callback saves its position in a frame (`FR_FIRE` listener index, `FR_KEYDISP` channel index, `FR_MOUSE` phase and index) and returns. The origin (timer callback, key or mouse dispatch, applet event) pushes its own frame and stops the timer passes: a timer origin ends the current pass after this callback (`timersys_suspend_pass`, the pass index is kept), other origins hold the list (`timersys_hold`). While the dialog is open: no timer pass (also no render), no input for the game.
2. The shell calls `engine_dialog_done(result, text)`: the InputBox text goes to the guest buffer (at most size - 1 characters, `Z:0x405004`), the pause state is restored, the trace line gets its result.
3. Rewind: `rs = RS_REWIND`; the origin frame is popped and the origin is called again; each loop pops its frame and calls inward at the saved position; the innermost `eng_guest_call` resumes the interpreter (`cpu_resume`, EAX = result). The game may open the next dialog before the resume returns ("Name too long"): the unwind repeats.
4. After the callback: the loops continue; a timer origin polls the rest of the interrupted pass (`timersys_resume`).

Limits: a dialog opened inside a nested game call (game -> engine -> game -> dialog) or in DllMain/Shell_StartApplet/Shell_StopApplet stops the applet with an error (Moeboid opens dialogs only in its play timer, `G:0x100037d0`). A shell action that fires an applet event cannot continue its own code after a suspended game callback (event 0x10 never suspends in Moeboid). `engine_modal_hold` gives the same hold for dialogs that the shell opens itself.

## Shell API (`shell_api.h`, for M5)

`shell_dialog_open` (MessageBox/InputBox, see above), `shell_caption_changed`, `shell_game_in_progress`, `shell_buttons_changed`, `shell_pause_toggle`, `shell_frame_build`, `shell_applet_changed`, `shell_starts_applet` (true: the shell starts the game after its splash, decision 13; the engine init then does not), `shell_input_blocked` (true: no input to the game or the surfaces, for example during the splash). The engine calls every `shell_*` function with allocation owner 0, and the `engine.h` creation functions make owner-0 objects, so shell objects survive the New Game sweep. Engine services for the shell: `engine.h` (root and game surfaces, blank and GIF surfaces, attach/detach/SetLoc/SetVisible with keys, images and `engine_image_changed`, `engine_image_zml` (DrawZML `Z:0x413c90` with the persistent render-context state of the image, links inert), buttons with C callbacks, render and invalidate, pause, applet start/stop/new game/event 0x10, platform sounds by name, global properties `core/<name>`, `engine_dialog_done`, `engine_modal_hold`).

## Settings and storage

Game properties: storage key `game/<owner id>/<name>` (owner id = game string 5), name compared without case (lstrcmpiA); missing: "" and 0x19 (`Z:0x4294f0`); every set writes through (`PORT_ADV_STORAGE`). Global properties: `core/<name>` (`core/Sound` = "true"/"false", read at start: missing = on).

## Sounds

`CreateSound` maps the resource name to a `PORT_SND_*` id (sound_ids.h, case-insensitive base name). `Play` (`Z:0x40c510`, `Z:0x409280`): dropped when sound is off or the 16 voices are busy, else the first free slot and a PLAY command. A slot is free after the first voice-thread pass at or after the end of the WAV data (passes every 10 ms of the clock from engine start: **inferred**, real period 10 to 16 ms, phase unknown).

## Trace and tests

Trace build (`PORT_TRACE=1`, pylib): one tick per engine-to-game call, call lines and state digest as `analysis/verification/harness/mock.py` / `run.py`. Tests:
- `tests/native/test_engine.c`: draw rules, dirty list, skip rule, detach quirk, hit test, protect key, animation slots and pause, voices, WAVs, settings, key state, buttons, modal hold.
- `tests/native/test_engine_modal.c`: dialogs open across steps (InputBox 5 s; "Name too long" MessageBox and a second InputBox), New Game DLL reload.
- `tests/py/test_engine_lockstep.py` (gate): Unicorn + `refmock.py` (run.py unchanged, `refrun.py`) against the native port and the wasm trace build (`wasm_replay.mjs`), both linked without `src/shell` (`enginedrv.engine_only_lib`, `engine_only_wasm`: the shell splash would start the game later); autopilot and tour recordings, also at the 15.625 and 54.925 ms clock steps and with engine seed 999. `refmock.py` = mock.py with R1-R8 (real metrics; original-engine results: MessageBox IDOK, GetKeyState SHORT, GetGameValue "", key messages, dispatch stop at 0, reference counts, input times on clock values).
- `tests/py/test_engine_frame.py`: title frame (smoothing off) against the Wine capture `screens_monofonts/frame_title_installed.png`: every game-area pixel equal except the moving title sprites and two underline rows (gdi_text.c underline rule, inferred).
- `tests/browser/engine_play.mjs`: title after click-to-start, typed INVINCIBLE, Start click, arrow keys move the player, Escape pause.

Port-only measure: at New Game the engine frees the objects that the stopped game made and never released (`sweep` in engine.c; the game leaks about 2.5 MB per run; nothing can reach them after the detach of ctx[2] and ctx[3] children).

## Verified and inferred

Verified from the code (addresses in the sources): object lifetimes and Release results, surface tree, Render and its skip rule, dirty list, hit test, Blt/DrawAt/FillRect/line clamping, animation slots and frame lookup, timer rules (core), event dispatch and mouse routing, buttons, key code tables, MessageBox/InputBox results and pause handling, settings get/set, Start/Stop/New Game sequences, DLL reload.
Inferred (marked in the sources): GetKeyState value in EAX (sign-extended SHORT, toggle bit), the DirectDraw rule that an empty or out-of-surface Blt rectangle fails, stretch Blt by nearest neighbour (not reached), diagonal GDI lines (not reached), the voice-thread pass times, no engine rand value consumed by the removed ad banner (`Z:0x421c8f`), the modal window activation messages (no net effect).
