/* Windows XP MessageBox (MessageBoxA as called by Z:0x4058c0) built as a Dialog. See msgbox.c for the
 * layout rules and their status. */
#ifndef MOEBOID_SHELL_MSGBOX_H
#define MOEBOID_SHELL_MSGBOX_H

#include "dialog.h"

#define MB_TYPE_OK 0x0u
#define MB_TYPE_OKCANCEL 0x1u
#define MB_TYPE_MASK 0xFu
#define MB_ICON_EXCLAMATION 0x30u
#define MB_ICON_MASK 0xF0u
#define MB_ID_ICON 20         /* IDUSERICON (I) */
#define MB_ID_TEXT 0xFFFF     /* static text id (I) */

/* Reference desktop for the width limit: 1024 pixels (analysis/reference/NOTES.md, Wine virtual desktop;
 * the original user's screen is unknown). */
#define MB_WORK_W 1024

/* Layout result (client coordinates), exposed for tests. */
typedef struct MsgBoxLayout {
    int32_t base_x, base_y;
    int32_t client_w, client_h;
    int32_t btn_w, btn_h, nbtn;
    DlgRect btn[2];
    DlgRect icon;            /* w = h = 0 without icon */
    DlgRect text;
    int32_t text_lines;
} MsgBoxLayout;

/* Compute the layout. font = NONCLIENTMETRICS lfMessageFont (Tahoma 8 = atlas TAHOMA-11-400). */
void msgbox_layout(const GdiFont *font, const char *title, const char *text, uint32_t type, int32_t caption_x_size,
                   MsgBoxLayout *L);

/* Build the dialog (controls, centred window, focus on the default button). icon_rgba: 32x32 RGBA or
 * NULL (place kept, nothing drawn). Returns 0, -1 for an unsupported type. */
int32_t msgbox_open(Dialog *d, const DlgEnv *env, const GdiFont *font, const char *title, const char *text,
                    uint32_t type, const uint8_t *icon_rgba, uint32_t now, bool last_input_keyboard);

/* Dialog procedure: WM_COMMAND id to the MessageBoxA return value; -1 = the box stays open. */
int32_t msgbox_command(uint32_t type, int32_t id);

#endif
