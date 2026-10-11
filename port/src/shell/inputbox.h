/* Engine InputBox (Z:0x405480): IDD_INPUT_BOX2 (OK only) or IDD_INPUT_BOX (OK, Cancel) with the
 * dialog procedure Z:0x404f60 (input branch, DAT_0043633a = 1). Moeboid: the high-score name entry
 * (analysis/shell.md 2.2): title "Congratulations", maximum 0x10 (15 characters), flags 1. The
 * 12-letter rule and the "Name too long" message box are game code (G:0x100038d3) that runs in the
 * interpreter; this module returns the text that GetDlgItemTextA gives. */
#ifndef MOEBOID_SHELL_INPUTBOX_H
#define MOEBOID_SHELL_INPUTBOX_H

#include "dialog.h"

#define INPUTBOX_ID_EDIT 1003   /* 0x3eb */
#define INPUTBOX_ID_PROMPT 1002 /* 0x3ea */

/* template_box: 1 = IDD_INPUT_BOX (flags & 2), 2 = IDD_INPUT_BOX2. Returns 0 or -1 (template missing). */
int32_t inputbox_open(Dialog *d, const DlgEnv *env, const TextFonts *fonts, const MPack *pack, uint32_t template_box,
                      const char *title, const char *prompt, const char *def, uint32_t now, bool last_input_keyboard);

/* Dialog procedure Z:0x404f60 for one WM_COMMAND id. Returns the result (DAT_004362e8: IDOK 1 with
 * *has_text = true and text = GetDlgItemTextA(0x3eb, text, max_len); IDCANCEL 2 without text) or -1 when
 * the dialog stays open. text must hold max_len bytes (max_len >= 1). */
int32_t inputbox_command(Dialog *d, int32_t id, int32_t max_len, char *text, bool *has_text);

#endif
