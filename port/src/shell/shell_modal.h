/* Shell side of the modal dialogs (M5a): implements shell_dialog_open of src/engine/shell_api.h (M4)
 * and gives the frame code the dialogs it opens itself (IDD_QUIT_SAVED, Terms of Service).
 *
 * State: struct Shell (Port.shell). M5a defines it with the dialog part; the frame/rail/page part of
 * M5 adds its members here (coordination point, see the M5a report).
 *
 * Hooks: the frame part (M5b, shell_frame.c) defines port_hooks_shell and calls shell_modal_init (init),
 * shell_modal_input (every input event: routes it to the open dialog) and shell_modal_frame (caret
 * blink, scroll repeat, composition of the dialog over the engine frame, repaint after close). M5b
 * allocates Port.shell (struct ShellAll, struct Shell first); shell_modal_init keeps an existing one.
 *
 * Engine-opened dialogs (shell_api.h steps 1-5): shell_dialog_open opens the window and returns
 * SHELL_DLG_OPEN; the input hook takes events with seq > input_seq; when the dialog ends the shell
 * removes the window, then calls engine_dialog_done(result, text). A key that ends the dialog has no
 * WM_CHAR (IsDialogMessage handled it), so when its PORT_IN_CHAR is queued next, engine_dialog_done
 * waits until the shell has dropped that character. */
#ifndef MOEBOID_SHELL_SHELL_MODAL_H
#define MOEBOID_SHELL_SHELL_MODAL_H

#include "../core/port.h"
#include "dialog_modal.h"

/* Host input kind for the mouse wheel: PORT_IN_WHEEL (kind 10, core/input.h), a = wheel delta in
 * WHEEL_DELTA units (120 per notch, positive = away from the user). The input hook passes it to the open
 * dialog; shell_modal_wheel is the direct entry for tests. */
#define SHELL_IN_WHEEL ((uint32_t)PORT_IN_WHEEL)

struct Shell {
    DlgModal modal;
    bool ok;                 /* dlgm_init succeeded */
    bool engine_wait;        /* the engine waits for the open (or ended, not reported) dialog */
    uint32_t input_seq;      /* events with seq <= input_seq are not for the dialog */
    bool pending;            /* ended; engine_dialog_done waits for the dropped WM_CHAR */
    int32_t pending_result;
    bool pending_has_text;
    char pending_text[DLG_EDIT_MAX];
    bool frame_owned;        /* the open dialog was opened by the frame code */
    bool frame_result_ready;
    uint32_t frame_kind;
    int32_t frame_result;
    bool saved_paused;       /* IsPaused before a frame-opened dialog (Z:0x405330, Z:0x405540) */
    bool composed;           /* the window is in the frame buffer */
    uint32_t render_seen;    /* engine_render_count at the last composition */
    bool repaint;            /* frame area of a removed or moved window must be repainted */
    int32_t rx, ry, rw, rh;
};

/* Building blocks for the frame part's hooks. */
int32_t shell_modal_init(Port *p);
void shell_modal_input(Port *p, const PortInput *ev);
void shell_modal_frame(Port *p);

/* Dialogs opened by the frame code. Each saves the pause state and pauses (V: Z:0x405330, Z:0x405540),
 * returns 0, or -1 when a dialog is open or the data is missing. */
int32_t shell_modal_open_quit_saved(Port *p);   /* New Game / View All Games during a game (Z:0x41b4d0) */
int32_t shell_modal_open_tos(Port *p);          /* "Terms of Service and Privacy Policy" link (Z:0x41cb20) */
/* Result of a frame-opened dialog, once: kind DLGM_QUIT_SAVED (0 Yes, 1 No, 2 Esc) or DLGM_TOS (0 OK,
 * 2 Esc). Restores the pause state. */
bool shell_modal_take_result(Port *p, uint32_t *kind, int32_t *result);
bool shell_modal_active(Port *p);
/* Mouse wheel for the dialog (delta in 1/120 notches); the host has no input kind for it yet. */
void shell_modal_wheel(Port *p, int32_t delta);
/* DLG_CURSOR_* for a frame point (NONE when no dialog is under it). */
int32_t shell_modal_cursor(Port *p, int32_t x, int32_t y);

#endif
