/* Modal dialog manager. See dialog_modal.h. */
#include "dialog_modal.h"
#include "inputbox.h"
#include "msgbox.h"
#include "tos.h"

int32_t dlgm_init(DlgModal *m, const uint8_t *pack, uint32_t len) {
    rt_memset(m, 0, offsetof(DlgModal, dlg));
    m->dlg.open = false;
    if (mpack_open(&m->pack, pack, len) != 0) return -1;
    if (text_fonts_load(&m->fonts, &m->pack) <= 0) return -1;
    uint32_t ll = 0;
    const uint8_t *lb = mpack_find(&m->pack, "data/luna/NORMALBLUE", &ll);
    if (!lb || luna_load(&m->luna, lb, ll) != LUNA_OK) m->luna.loaded = false;
    int32_t cap_pt = m->luna.loaded ? luna_metric(&m->luna, LUNA_M_CAPTION_FONT_PT) : 10;
    int32_t cap_w = m->luna.loaded ? luna_metric(&m->luna, LUNA_M_CAPTION_FONT_WEIGHT) : 700;
    int32_t msg_pt = m->luna.loaded ? luna_metric(&m->luna, LUNA_M_MSGBOX_FONT_PT) : 8;
    int32_t msg_w = m->luna.loaded ? luna_metric(&m->luna, LUNA_M_MSGBOX_FONT_WEIGHT) : 400;
    bool have_cap = gdi_font_select(&m->caption_font, &m->fonts, "Trebuchet MS", -luna_font_px(cap_pt), cap_w, 0, 0) == 0;
    if (gdi_font_select(&m->msg_font, &m->fonts, "Tahoma", -luna_font_px(msg_pt), msg_w ? msg_w : 400, 0, 0) != 0)
        return -1;
    GdiFont probe;
    if (gdi_font_select(&probe, &m->fonts, "MS Sans Serif", -11, 400, 0, 0) != 0) return -1;
    uint32_t il = 0;
    const uint8_t *icon = mpack_find(&m->pack, DLG_ICON_EXCLAMATION_ENTRY, &il);
    m->icon_exclamation = (icon && il == 32u * 32u * 4u) ? icon : NULL;
    m->has_exclamation_sound = mpack_find(&m->pack, DLG_SND_EXCLAMATION_ENTRY, &il) != NULL;
    m->env = (DlgEnv){m->luna.loaded ? &m->luna : NULL, have_cap ? &m->caption_font : NULL, 1, DLG_MAX_W, DLG_MAX_H};
    m->ready = true;
    return 0;
}

static bool can_open(const DlgModal *m) { return m->ready && !m->open && !m->ended; }

static void opened(DlgModal *m, uint32_t kind) {
    m->kind = kind;
    m->open = true;
    m->ended = false;
    m->has_text = false;
    m->text[0] = 0;
    m->result = 0;
    m->end_drop_char = false;
    m->last_w = m->last_h = 0;
}

int32_t dlgm_open_messagebox(DlgModal *m, const char *title, const char *text, uint32_t mb_type, uint32_t now) {
    if (!can_open(m)) return -1;
    const uint8_t *icon = ((mb_type & MB_ICON_MASK) == MB_ICON_EXCLAMATION) ? m->icon_exclamation : NULL;
    if (msgbox_open(&m->dlg, &m->env, &m->msg_font, title ? title : "", text ? text : "", mb_type, icon, now,
                    m->last_kbd) != 0)
        return -1;
    m->mb_type = mb_type;
    opened(m, DLGM_MESSAGEBOX);
    /* MessageBoxA with MB_ICONEXCLAMATION plays the SystemExclamation sound (I: XP MessageBeep). Only when
     * the user supplied the sound file. */
    m->sound_id = ((mb_type & MB_ICON_MASK) == MB_ICON_EXCLAMATION && m->has_exclamation_sound) ? DLG_SND_EXCLAMATION_ID : 0;
    return 0;
}

int32_t dlgm_open_inputbox(DlgModal *m, uint32_t template_box, const char *title, const char *prompt, const char *def,
                           int32_t max_len, uint32_t now) {
    if (!can_open(m)) return -1;
    if (inputbox_open(&m->dlg, &m->env, &m->fonts, &m->pack, template_box, title, prompt, def, now, m->last_kbd) != 0)
        return -1;
    m->max_len = max_len < 1 ? 1 : (max_len > DLG_EDIT_MAX ? DLG_EDIT_MAX : max_len);
    opened(m, DLGM_INPUTBOX);
    return 0;
}

int32_t dlgm_open_quit_saved(DlgModal *m, uint32_t now) {
    if (!can_open(m)) return -1;
    uint32_t len = 0;
    const uint8_t *t = mpack_find(&m->pack, "zap/DIALOG/IDD_QUIT_SAVED", &len);
    if (!t || dlg_create(&m->dlg, &m->env, &m->fonts, t, len) != 0) return -1;
    /* Z:0x404f60 WM_INITDIALOG with DAT_00436339 = 0 and DAT_0043633a = 0: returns 1 only (V). */
    dlg_start(&m->dlg, now, m->last_kbd, 0);
    opened(m, DLGM_QUIT_SAVED);
    return 0;
}

int32_t dlgm_open_tos(DlgModal *m, uint32_t now) {
    if (!can_open(m)) return -1;
    if (tos_open(&m->dlg, &m->env, &m->fonts, &m->pack, now, m->last_kbd) != 0) return -1;
    opened(m, DLGM_TOS);
    return 0;
}

int32_t quit_saved_command(int32_t id) {
    /* Z:0x404f60 WM_COMMAND (V): 0x7d2 Yes 0, 0x7d1 No 1, 2 (Esc) 2, 1 1 (GetDlgItemTextA into a stale
     * buffer; the port writes nothing), 0x7d3 2, 0x7d4 3. */
    switch (id) {
    case 0x7d2: return 0;
    case 0x7d1: return 1;
    case 1: return 1;
    case 2: return 2;
    case 0x7d3: return 2;
    case 0x7d4: return 3;
    default: return -1;
    }
}

/* Run the dialog procedure for pending WM_COMMAND ids; EndDialog stops at the first result. */
static void run_proc(DlgModal *m) {
    int32_t id;
    while (m->open && (id = dlg_take_command(&m->dlg)) != 0) {
        int32_t r = -1;
        switch (m->kind) {
        case DLGM_MESSAGEBOX: r = msgbox_command(m->mb_type, id); break;
        case DLGM_INPUTBOX: r = inputbox_command(&m->dlg, id, m->max_len, m->text, &m->has_text); break;
        case DLGM_QUIT_SAVED: r = quit_saved_command(id); break;
        case DLGM_TOS: r = tos_command(id); break;
        default: break;
        }
        if (r >= 0) {
            m->result = r;
            m->ended = true;
            m->open = false;
            m->dlg.open = false;
        }
    }
}

bool dlgm_input(DlgModal *m, uint32_t kind, int32_t a, int32_t b, uint32_t now) {
    uint32_t k = kind & 0xFFu;
    if (k == DLG_IN_KEYDOWN || k == DLG_IN_KEYUP || k == DLG_IN_CHAR) m->last_kbd = true;
    else if (k == DLG_IN_MOUSEMOVE || k == DLG_IN_BUTTONDOWN || k == DLG_IN_BUTTONUP) m->last_kbd = false;
    if (!m->open) {
        if (m->end_drop_char) {
            m->end_drop_char = false;
            if (k == DLG_IN_CHAR) return true; /* WM_CHAR of the key that ended the dialog: none (I) */
        }
        return false;
    }
    bool used = dlg_input(&m->dlg, kind, a, b, now);
    if (k == DLG_IN_KEYDOWN || k == DLG_IN_KEYUP || k == DLG_IN_CHAR) used = true; /* keyboard focus is in the dialog */
    run_proc(m);
    if (m->ended && k == DLG_IN_KEYDOWN) m->end_drop_char = m->dlg.drop_char;
    return used || m->ended;
}

void dlgm_wheel(DlgModal *m, int32_t delta, uint32_t now) {
    if (m->open) dlg_wheel(&m->dlg, delta, now);
}

bool dlgm_tick(DlgModal *m, uint32_t now) { return m->open && dlg_tick(&m->dlg, now); }

void dlgm_compose(DlgModal *m, uint8_t *frame_rgba, int32_t fw, int32_t fh) {
    if (!m->open) return;
    dlg_draw(&m->dlg, false);
    dlg_compose(&m->dlg, frame_rgba, fw, fh);
    m->last_x = m->dlg.win_x;
    m->last_y = m->dlg.win_y;
    m->last_w = m->dlg.geom.win_w;
    m->last_h = m->dlg.geom.win_h;
    m->dlg.moved = false;
}

int32_t dlgm_cursor(const DlgModal *m, int32_t x, int32_t y) {
    return m->open ? dlg_cursor(&m->dlg, x, y) : DLG_CURSOR_NONE;
}

bool dlgm_done(const DlgModal *m) { return m->ended; }

int32_t dlgm_take(DlgModal *m, int32_t *result, const char **text) {
    if (!m->ended) return -1;
    *result = m->result;
    if (text) *text = m->has_text ? m->text : NULL;
    m->ended = false;
    m->open = false;
    m->dlg.open = false;
    m->kind = DLGM_NONE;
    return 0;
}

void dlgm_close(DlgModal *m) {
    m->open = m->ended = false;
    m->dlg.open = false;
    m->kind = DLGM_NONE;
    m->end_drop_char = false;
}
