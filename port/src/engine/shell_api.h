/* Calls from the engine (M4) to the platform shell (M5). The engine defines weak defaults in
 * shell_weak.c; M5 defines the strong versions in src/shell/. The defaults keep the engine usable
 * without the shell: dialogs close at once (OK, default text), notifications only store values,
 * the pause toggle only toggles the timer pause.
 *
 * Original routines: CShell (Z:0x41acb0) and the platform object (DAT_0045cf9c, vtable Z:0x42e6b4).
 *
 * Modal dialogs (ISystem::MessageBox / InputBox, Z:0x4058c0 / Z:0x405480):
 *   1. The engine saves IsPaused, pauses, renders the frame once (Z:0x41b210), then calls
 *      shell_dialog_open.
 *   2. The shell returns SHELL_DLG_DONE (result filled; for example when it cannot show the dialog),
 *      or SHELL_DLG_OPEN: the dialog stays open, the engine suspends the game in the middle of its
 *      call and stops all timer passes (the original modal loop runs no timer pass).
 *   3. While the dialog is open the engine routes no input to the game; the shell takes every input
 *      event whose PortInput.seq is greater than ShellDialog.input_seq (the event that opened the
 *      dialog, if any, is not for the dialog).
 *   4. On close the shell calls engine_dialog_done(p, result, text). The engine restores the pause
 *      state and resumes the game inside that call. The game may open the next dialog before
 *      engine_dialog_done returns (Moeboid: "Name too long" after the name entry), so the shell
 *      must remove the closed dialog before it calls engine_dialog_done.
 *   5. After the close the shell should call engine_invalidate for the dialog rectangle (Windows
 *      sends WM_PAINT to the uncovered frame; Z:0x4040e0 case 0xf) and engine_render. */
#ifndef MOEBOID_ENGINE_SHELL_API_H
#define MOEBOID_ENGINE_SHELL_API_H

#include "../core/port.h"

enum { SHELL_DLG_MESSAGEBOX = 1, SHELL_DLG_INPUTBOX = 2 };
enum { SHELL_DLG_DONE = 0, SHELL_DLG_OPEN = 1 };

typedef struct ShellDialog {
    uint32_t kind;         /* SHELL_DLG_* */
    const char *title;     /* window caption (cp1252) */
    const char *text;      /* MessageBox text; InputBox prompt (static text 0x3ea) */
    const char *def;       /* InputBox default text (edit control 0x3eb, selected); NULL for MessageBox */
    uint32_t flags;        /* game flags (MessageBox 0x101, InputBox 1) */
    uint32_t mb_type;      /* MessageBoxA uType: MB_OKCANCEL (1) if flags & 2, | MB_ICONEXCLAMATION (0x30) if flags & 0x100 */
    uint32_t template_box; /* InputBox: 1 = IDD_INPUT_BOX (OK, Cancel; flags & 2), 2 = IDD_INPUT_BOX2 (OK only) */
    int32_t max_len;       /* InputBox: GetDlgItemTextA size (at most max_len - 1 characters) */
    uint32_t input_seq;    /* see step 3 above */
} ShellDialog;

/* Open a dialog (step 2). For SHELL_DLG_DONE fill *result (IDOK 1, IDCANCEL 2) and, for an InputBox,
 * text (NUL-terminated, at most text_cap bytes). */
int32_t shell_dialog_open(Port *p, const ShellDialog *d, int32_t *result, char *text, uint32_t text_cap);

/* ISystem::SetCaption (Z:0x415f20): the engine stored the text (engine_caption); the shell draws it
 * as ZML on its title surface (Z:0x41b7f0). */
void shell_caption_changed(Port *p, const char *text);
/* ISystem::SetGameInProgress (Z:0x41b970): shell +0x37c = flag. */
void shell_game_in_progress(Port *p, int32_t flag);
/* ISystem::SetShellButtons (Z:0x41b990): shell +0x378 = mask, rebuild the rail (Z:0x41b9b0). */
void shell_buttons_changed(Port *p, uint32_t mask);
/* Pause toggle Z:0x41cb30: Escape on a running game (Z:0x4040e0 WM_KEYDOWN VK_ESCAPE) and focus loss
 * of a running, unpaused game (WM_ACTIVATE WA_INACTIVE). Default: engine_set_paused(!paused). */
void shell_pause_toggle(Port *p);
/* Shell frame parts after the engine created the root, ctx[2] and ctx[3] (Z:0x41d6c0) and before the
 * applet starts. Default: nothing (the root stays #3333cc). */
void shell_frame_build(Port *p);
/* Applet started (after Shell_StartApplet) or stopped (after FreeLibrary). Default: nothing. */
void shell_applet_changed(Port *p, bool running);

#endif
