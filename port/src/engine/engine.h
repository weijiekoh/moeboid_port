/* ZapSpot engine core (M4): applet manager, the 13 interfaces / 54 methods of analysis/interface.tsv,
 * surface tree and rendering, events, timers, sounds, settings, modal dialogs.
 * Contract: docs/port-design.md; structure and status: src/engine/README.md.
 *
 * The engine installs itself through port_hooks_engine (core/port.h): init (machine, shell root, game
 * surfaces, applet start), input (WndProc routing), frame (none). The shell (M5) uses the API below
 * and implements shell_api.h. Handles name engine objects (surfaces, images, sounds, listeners). */
#ifndef MOEBOID_ENGINE_ENGINE_H
#define MOEBOID_ENGINE_ENGINE_H

#include "../core/port.h"
#include "../gfx/image.h"

typedef struct Engine Engine;

/* Game surface position in the 800x572 frame (Z:0x41d6c0, second branch). */
#define ENG_GAME_X 282
#define ENG_GAME_Y 50
#define ENG_GAME_W 500
#define ENG_GAME_H 420
#define ENG_FRAME_BG 0x3333ccu /* root image clear colour (Z:0x41d80a), 0xRRGGBB */

/* Surface flags of Z:0x414190 / Z:0x414330 / Z:0x414470. */
#define ENG_SURF_KEYED 1u   /* bit0: keyed (colour-key) image */
#define ENG_SURF_HOVER 2u   /* bit1: enter/leave channels and the hand cursor */

/* port_settings.quirks bits used by the engine (decisions.md item 10; default all on). */
#define ENG_QUIRK_DETACH_DIRTY 0x01u /* Z:0x4147f0 invalidates a detached child after clearing its parent */

Engine *engine_of(Port *p);

/* ---- applet manager (DAT_0045cfc8) ---- */
int32_t engine_applet_start(Port *p);   /* Z:0x424620: LoadLibraryA, DllMain, ctx, Shell_StartApplet */
void engine_applet_stop(Port *p);       /* Z:0x4248a0: Shell_StopApplet, wrappers, FreeLibrary */
int32_t engine_new_game(Port *p);       /* Z:0x41c910 engine part: page hidden, game shown and cleared,
                                           Stop, children detached, Start (fresh DLL image) */
bool engine_applet_running(Port *p);    /* manager +0x14 (Z:0x424a90) */
/* Z:0x424aa0: arg 1 fires event 0x10 (How To Play, game help page), arg 0 fires 0x11. The shell
 * handler Z:0x41c3f0 then pauses and shows ctx[3]; that part is the shell's. */
void engine_applet_event(Port *p, int32_t arg);
const char *engine_caption(Port *p);    /* ISystem::SetCaption text (shell +0x88) */
uint32_t engine_shell_buttons(Port *p); /* ISystem::SetShellButtons mask (shell +0x378) */
int32_t engine_game_in_progress(Port *p); /* ISystem::SetGameInProgress flag (shell +0x37c) */

/* ---- timers, pause, clock ---- */
bool engine_paused(Port *p);            /* Z:0x427530 */
void engine_set_paused(Port *p, bool paused); /* Z:0x427490 */
uint32_t engine_game_time_ms(Port *p);  /* Z:0x427510 */

/* ---- rendering ---- */
void engine_render(Port *p);            /* Z:0x41b210: render the dirty surfaces and present */
void engine_invalidate(Port *p, int32_t x, int32_t y, int32_t w, int32_t h); /* video +0x48 */
uint32_t engine_render_count(Port *p);
/* Root surface (the shell frame: 800x572 opaque, image = frame buffer), ctx[2] game surface,
 * ctx[3] page surface, and the protect key of ctx[2] (Z:0x414ca0). */
uint32_t engine_root(Port *p);
uint32_t engine_game_surface(Port *p);
uint32_t engine_page_surface(Port *p);
uint32_t engine_shell_key(Port *p);

/* ---- surfaces and images for the shell (handles; 0 = failure) ---- */
uint32_t engine_surface_blank(Port *p, int32_t w, int32_t h, uint32_t flags);  /* Z:0x414190 */
uint32_t engine_surface_gif(Port *p, const char *rcdata_name, uint32_t flags); /* Z:0x414330 */
int32_t engine_surface_attach(Port *p, uint32_t parent, uint32_t child);       /* Z:0x414780 */
int32_t engine_surface_detach(Port *p, uint32_t parent, uint32_t child);       /* Z:0x4147f0 */
void engine_surface_detach_all(Port *p, uint32_t s);                           /* Z:0x414950 */
int32_t engine_surface_set_loc(Port *p, uint32_t s, int32_t x, int32_t y, uint32_t key);   /* Z:0x4146a0 */
int32_t engine_surface_set_visible(Port *p, uint32_t s, bool visible, uint32_t key);       /* Z:0x414720 */
uint32_t engine_surface_image(Port *p, uint32_t s);                            /* Z:0x414c40 current image */
int32_t engine_surface_play(Port *p, uint32_t s);                              /* Z:0x414b60 */
void engine_release(Port *p, uint32_t h);  /* external Release (Z:0x414f90) of a handle the API returned */
Image *engine_image_pixels(Port *p, uint32_t img); /* draw into it, then call engine_image_changed */
void engine_image_changed(Port *p, uint32_t img);  /* Z:0x414120 */
/* Button (Z:0x419730) with a C callback: cb(p, ctx, id) on a left click (event 0xe). */
typedef void (*EngineButtonFn)(Port *p, void *ctx, int32_t id);
uint32_t engine_button(Port *p, uint32_t parent, int32_t x, int32_t y, int32_t w, int32_t h, uint32_t faces_img,
                       int32_t face_index, int32_t id, EngineButtonFn cb, void *ctx);

/* ---- sound ---- */
bool engine_sound_enabled(Port *p);             /* subsystem +0x10 ("Sound" setting) */
void engine_sound_set_enabled(Port *p, bool on); /* Z:0x408f80; also stores core/Sound */
/* Play a platform sound by resource name (for example "BtnClick.wav"); the engine keeps one sound
 * object per name. Returns 0 or 8 (no sound). */
int32_t engine_play_sound(Port *p, const char *name);

/* ---- settings (ZDT store DAT_0045cfa8) ---- */
/* Global (shell) property, storage key "core/<name>"; NULL when absent. */
const char *engine_prop_get(Port *p, const char *name);
void engine_prop_set(Port *p, const char *name, const char *value);

/* ---- dialogs (see shell_api.h) ---- */
/* The shell calls this when a dialog that shell_dialog_open left open closes. result: IDOK 1,
 * IDCANCEL 2 (MessageBox: the IDs of MessageBoxA); text: the edit text (InputBox, may be NULL).
 * The engine restores the pause state, writes the text, and resumes the game; the call returns
 * after the interrupted engine pass completed (or after the game opened the next dialog). */
void engine_dialog_done(Port *p, int32_t result, const char *text);
bool engine_dialog_waiting(Port *p);   /* the game waits for a dialog result */
/* A modal dialog that the shell opens itself (IDD_QUIT_SAVED, IDD_TERMSOFSERVICE; Z:0x405330,
 * Z:0x405540) runs its own modal loop in the original: no timer pass and no input for the game.
 * on: the engine holds the timer passes and routes no input event; off: both resume. The pause
 * state is the shell's (the dialog code saves IsPaused and pauses). */
void engine_modal_hold(Port *p, bool on);

/* ---- tests (lockstep, native tests) ---- */
void engine_test_answer(Port *p, const char *text);   /* queue an InputBox answer */
void engine_test_auto_dialogs(Port *p, bool on);       /* dialogs close at once without the shell */
/* Point of the most recently created live button whose faces label contains `label`, inside the
 * button and on top in the hit test (frame coordinates). Returns false when none. */
bool engine_test_button_point(Port *p, const char *label, int32_t *x, int32_t *y);
uint32_t engine_test_live_objects(Port *p);
const char *engine_fault_text(Port *p);   /* "" when the applet runs without a guest fault */
struct Cpu *engine_cpu(Port *p);

#endif
