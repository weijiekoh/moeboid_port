/* Modal dialog manager of the shell (engine-independent part). One modal dialog at a time, as in the
 * original (every dialog runs in its own DialogBoxParamA / MessageBoxA modal loop).
 *
 * Dialogs: MessageBox (Z:0x4058c0), InputBox (Z:0x405480), IDD_QUIT_SAVED (Z:0x405330), Terms of Service
 * (Z:0x405540). The engine glue (shell_modal.c) and the frame code call these functions; tests call them
 * directly.
 *
 * Use:
 *   dlgm_init(m, pack, len)                    once; loads fonts and the Luna data from the pack
 *   dlgm_open_*(m, ..., now)                   opens; returns 0 or -1 (busy or data missing)
 *   dlgm_input(m, kind, a, b, now)             every host input event (also while closed: it records
 *                                              whether the last input was keyboard or mouse)
 *   dlgm_wheel(m, delta, now)                  mouse wheel (host input kind 10, core/input.h)
 *   dlgm_tick(m, now)                          caret blink, scroll repeat; true = redraw needed
 *   dlgm_compose(m, frame_rgba, w, h)          draws (when dirty) and copies the window into the frame
 *   dlgm_done(m) / dlgm_take(m, &res, &text)   result when the dialog ended; take closes the manager
 * Sound: m->sound_id != 0 after an open that wants a system sound (MessageBox exclamation), only when
 * the pack holds DLG_SND_EXCLAMATION_ENTRY; the caller pushes it and clears it. */
#ifndef MOEBOID_SHELL_DIALOG_MODAL_H
#define MOEBOID_SHELL_DIALOG_MODAL_H

#include "dialog.h"

enum { DLGM_NONE = 0, DLGM_MESSAGEBOX, DLGM_INPUTBOX, DLGM_QUIT_SAVED, DLGM_TOS };

/* Optional user-supplied system resources (not in the pack now; decision 4c, docs/progress.md). */
#define DLG_ICON_EXCLAMATION_ENTRY "data/icons/EXCLAMATION"     /* 32x32 RGBA, straight alpha, 4096 bytes */
#define DLG_SND_EXCLAMATION_ENTRY "data/sounds/EXCLAMATION.WAV" /* Windows XP Exclamation.wav */
#define DLG_SND_EXCLAMATION_ID 16u   /* reserved sound id (next free row of core/sound_ids.h) */
#define DLG_SND_SYSTEM_VOICE 16u     /* outside the 16 DirectSound voices: PlaySound is separate (I) */

typedef struct DlgModal {
    bool ready;
    MPack pack;
    TextFonts fonts;
    LunaTheme luna;
    GdiFont caption_font, msg_font;
    DlgEnv env;
    const uint8_t *icon_exclamation; /* NULL when the pack has no icon */
    bool has_exclamation_sound;

    uint32_t kind;                 /* DLGM_* of the open (or ended, not yet taken) dialog */
    bool open;                     /* window shown */
    bool ended;                    /* EndDialog: result ready */
    int32_t result;
    bool has_text;
    char text[DLG_EDIT_MAX];
    int32_t max_len;               /* InputBox GetDlgItemTextA size */
    uint32_t mb_type;              /* MessageBox uType */
    bool last_kbd;                 /* last host input was a keyboard event */
    uint32_t sound_id;             /* pending system sound command, 0 = none */
    bool end_drop_char;            /* the dialog ended on a key whose WM_CHAR does not exist */
    int32_t last_x, last_y, last_w, last_h; /* frame rectangle of the window when it was last composed */
    Dialog dlg;
} DlgModal;

/* Load fonts (MS Sans Serif 8, Tahoma 8, Trebuchet MS 10 bold) and the Luna data from the pack. Returns 0
 * or -1 (pack invalid or MS Sans Serif missing). Works without Luna data (plain frame). */
int32_t dlgm_init(DlgModal *m, const uint8_t *pack, uint32_t len);

int32_t dlgm_open_messagebox(DlgModal *m, const char *title, const char *text, uint32_t mb_type, uint32_t now);
/* template_box 1 = IDD_INPUT_BOX, 2 = IDD_INPUT_BOX2; max_len = GetDlgItemTextA size (>= 1). */
int32_t dlgm_open_inputbox(DlgModal *m, uint32_t template_box, const char *title, const char *prompt, const char *def,
                           int32_t max_len, uint32_t now);
int32_t dlgm_open_quit_saved(DlgModal *m, uint32_t now);
int32_t dlgm_open_tos(DlgModal *m, uint32_t now);

/* Returns true when the event belongs to the dialog (it is open or the event is the WM_CHAR of the key
 * that ended it). */
bool dlgm_input(DlgModal *m, uint32_t kind, int32_t a, int32_t b, uint32_t now);
void dlgm_wheel(DlgModal *m, int32_t delta, uint32_t now);
bool dlgm_tick(DlgModal *m, uint32_t now);
void dlgm_compose(DlgModal *m, uint8_t *frame_rgba, int32_t fw, int32_t fh);
int32_t dlgm_cursor(const DlgModal *m, int32_t x, int32_t y);

bool dlgm_done(const DlgModal *m);
/* Result of the ended dialog; *text = NULL when the dialog gives no text. Closes the manager. */
int32_t dlgm_take(DlgModal *m, int32_t *result, const char **text);
/* Close without result (tests, shutdown). */
void dlgm_close(DlgModal *m);

/* IDD_QUIT_SAVED procedure (Z:0x404f60, DAT_00436339 = 0): result for an id, -1 = stays open. */
int32_t quit_saved_command(int32_t id);

#endif
