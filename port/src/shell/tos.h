/* Terms of Service dialog (Z:0x405540, IDD_TERMSOFSERVICE, procedure Z:0x404f60 with DAT_00436339 = 1).
 * Decision 5: kept, drawn in the canvas, without the ad opt-in checkbox 2006 and its SetUserProfile
 * message. The other controls keep their template positions; the checkbox area stays empty. */
#ifndef MOEBOID_SHELL_TOS_H
#define MOEBOID_SHELL_TOS_H

#include "dialog.h"

#define TOS_ID_TEXT 2005     /* read-only multi-line edit */
#define TOS_ID_OPTIN 2006    /* BS_AUTOCHECKBOX, removed (decision 5) */
#define TOS_ID_OK 2002

/* Returns 0, or -1 when the template or the TERMSOFSERVICE resource is missing. */
int32_t tos_open(Dialog *d, const DlgEnv *env, const TextFonts *fonts, const MPack *pack, uint32_t now,
                 bool last_input_keyboard);

/* Dialog procedure: result (DAT_004362e8) for a WM_COMMAND id, -1 = stays open. */
int32_t tos_command(int32_t id);

#endif
