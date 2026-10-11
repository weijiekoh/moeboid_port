/* Shell side of the modal dialogs. See shell_modal.h. */
#include "shell_modal.h"
#include "../core/sound_ids.h"
#include "../engine/engine.h"
#include "../engine/shell_api.h"

static struct Shell *sh(Port *p) { return p->shell; }

int32_t shell_modal_init(Port *p) {
    if (!p->shell) {
        p->shell = (struct Shell *)rt_calloc(1, sizeof(struct Shell));
        if (!p->shell) return -1;
    }
    struct Shell *s = sh(p);
    s->ok = dlgm_init(&s->modal, p->pack, p->pack_len) == 0;
    if (!s->ok) rt_log("shell: dialog data missing in the pack; dialogs close at once");
    return 0;
}

static void request_repaint(struct Shell *s, int32_t x, int32_t y, int32_t w, int32_t h) {
    if (w <= 0 || h <= 0) return;
    if (s->repaint) { /* union */
        int32_t r = RT_MAX(s->rx + s->rw, x + w), b = RT_MAX(s->ry + s->rh, y + h);
        s->rx = RT_MIN(s->rx, x);
        s->ry = RT_MIN(s->ry, y);
        s->rw = r - s->rx;
        s->rh = b - s->ry;
    } else {
        s->rx = x;
        s->ry = y;
        s->rw = w;
        s->rh = h;
        s->repaint = true;
    }
}

static void do_repaint(Port *p) {
    struct Shell *s = sh(p);
    if (!s->repaint) return;
    s->repaint = false;
    /* WM_PAINT of the uncovered frame (shell_api.h step 5; Z:0x4040e0 case 0xf). */
    engine_invalidate(p, s->rx, s->ry, s->rw, s->rh);
    engine_render(p);
    core_frame_changed(p);
}

static void report_engine(Port *p) {
    struct Shell *s = sh(p);
    char text[DLG_EDIT_MAX];
    int32_t result = s->pending_result;
    bool has = s->pending_has_text;
    if (has) rt_memcpy(text, s->pending_text, sizeof text);
    s->pending = false;
    s->engine_wait = false;
    do_repaint(p);
    /* The game may open the next dialog inside this call (shell_api.h step 4). */
    engine_dialog_done(p, result, has ? text : NULL);
}

/* The dialog ended: remove the window, then report. */
static void finish(Port *p) {
    struct Shell *s = sh(p);
    DlgModal *m = &s->modal;
    uint32_t kind = m->kind;
    int32_t result;
    const char *text;
    if (s->composed) request_repaint(s, m->last_x, m->last_y, m->last_w, m->last_h);
    s->composed = false;
    if (dlgm_take(m, &result, &text) != 0) return;
    if (s->frame_owned) {
        s->frame_owned = false;
        s->frame_result_ready = true;
        s->frame_kind = kind;
        s->frame_result = result;
        /* end of the modal loop of DialogBoxParamA (Z:0x40536e, Z:0x4055a5): timer passes and game input
         * resume (M5b) */
        engine_modal_hold(p, false);
        do_repaint(p);
        return;
    }
    if (!s->engine_wait) return;
    s->pending_result = result;
    s->pending_has_text = text != NULL;
    if (text) {
        uint32_t n = (uint32_t)rt_strlen(text);
        if (n >= sizeof s->pending_text) n = sizeof s->pending_text - 1u;
        rt_memcpy(s->pending_text, text, n);
        s->pending_text[n] = 0;
    }
    const PortInput *nx = inq_peek(&p->input);
    if (m->end_drop_char && nx && PORT_IN_KIND(nx->kind) == PORT_IN_CHAR) {
        s->pending = true; /* report after the WM_CHAR that does not exist was dropped */
        return;
    }
    report_engine(p);
}

void shell_modal_input(Port *p, const PortInput *ev) {
    struct Shell *s = sh(p);
    if (!s || !s->ok) return;
    DlgModal *m = &s->modal;
    uint32_t k = PORT_IN_KIND(ev->kind);
    if (m->open && s->engine_wait && ev->seq <= s->input_seq) {
        /* The event that opened the dialog: only its kind counts (UIS_INITIALIZE uses the last input). */
        if (ev->seq == s->input_seq && (k == PORT_IN_KEYDOWN || k == PORT_IN_KEYUP || k == PORT_IN_CHAR ||
                                        k == PORT_IN_MOUSEMOVE || k == PORT_IN_BUTTONDOWN || k == PORT_IN_BUTTONUP)) {
            bool kbd = k == PORT_IN_KEYDOWN || k == PORT_IN_KEYUP || k == PORT_IN_CHAR;
            m->last_kbd = kbd;
            m->dlg.ui_state = kbd ? 0 : (DLG_UISF_HIDEFOCUS | DLG_UISF_HIDEACCEL);
            m->dlg.dirty = true;
        }
        return;
    }
    if (k == SHELL_IN_WHEEL) { /* proposed host kind, see shell_modal.h */
        dlgm_wheel(m, ev->a, core_ticks(p));
        return;
    }
    dlgm_input(m, ev->kind, ev->a, ev->b, core_ticks(p));
    if (m->ended) finish(p);
    else if (s->pending) report_engine(p);
}

void shell_modal_frame(Port *p) {
    struct Shell *s = sh(p);
    if (!s || !s->ok) return;
    DlgModal *m = &s->modal;
    dlgm_tick(m, core_ticks(p));
    if (m->open && m->dlg.moved) request_repaint(s, m->last_x, m->last_y, m->last_w, m->last_h);
    do_repaint(p);
    if (m->open) {
        uint32_t rc = engine_render_count(p);
        if (!s->composed || m->dlg.dirty || m->dlg.moved || rc != s->render_seen) {
            dlgm_compose(m, p->frame, (int32_t)PORT_W, (int32_t)PORT_H);
            s->composed = true;
            s->render_seen = rc;
            core_frame_changed(p);
        }
    }
}

int32_t shell_dialog_open(Port *p, const ShellDialog *d, int32_t *result, char *text, uint32_t text_cap) {
    struct Shell *s = sh(p);
    int32_t rc = -1;
    if (s && s->ok && !s->modal.open && !s->modal.ended && !s->pending) {
        DlgModal *m = &s->modal;
        uint32_t now = core_ticks(p);
        if (d->kind == SHELL_DLG_MESSAGEBOX) rc = dlgm_open_messagebox(m, d->title, d->text, d->mb_type, now);
        else if (d->kind == SHELL_DLG_INPUTBOX)
            rc = dlgm_open_inputbox(m, d->template_box == 1 ? 1u : 2u, d->title, d->text, d->def, d->max_len, now);
        if (rc == 0) {
            s->engine_wait = true;
            s->frame_owned = false;
            s->input_seq = d->input_seq;
            s->composed = false;
            if (m->sound_id) {
                core_sound_push(p, PORT_SND_OP_PLAY, m->sound_id, DLG_SND_SYSTEM_VOICE);
                m->sound_id = 0;
            }
            return SHELL_DLG_OPEN;
        }
    }
    /* No dialog possible: close at once like the engine default (OK, default text). */
    *result = 1;
    if (d->kind == SHELL_DLG_INPUTBOX && text && text_cap) {
        uint32_t i = 0;
        const char *def = d->def ? d->def : "";
        uint32_t lim = d->max_len > 0 && (uint32_t)d->max_len < text_cap ? (uint32_t)d->max_len : text_cap;
        for (; def[i] && i + 1 < lim; i++) text[i] = def[i];
        text[i] = 0;
    }
    return SHELL_DLG_DONE;
}

static int32_t frame_open(Port *p, uint32_t kind) {
    struct Shell *s = sh(p);
    if (!s || !s->ok || s->modal.open || s->modal.ended || s->pending) return -1;
    DlgModal *m = &s->modal;
    uint32_t now = core_ticks(p);
    int32_t rc = kind == DLGM_TOS ? dlgm_open_tos(m, now) : dlgm_open_quit_saved(m, now);
    if (rc != 0) return -1;
    s->saved_paused = engine_paused(p);
    engine_set_paused(p, true);
    s->frame_owned = true;
    /* the dialog runs its own modal loop: no timer pass, no input for the game (M5b) */
    engine_modal_hold(p, true);
    s->frame_result_ready = false;
    s->composed = false;
    return 0;
}

int32_t shell_modal_open_quit_saved(Port *p) { return frame_open(p, DLGM_QUIT_SAVED); }
int32_t shell_modal_open_tos(Port *p) { return frame_open(p, DLGM_TOS); }

bool shell_modal_take_result(Port *p, uint32_t *kind, int32_t *result) {
    struct Shell *s = sh(p);
    if (!s || !s->frame_result_ready) return false;
    s->frame_result_ready = false;
    *kind = s->frame_kind;
    *result = s->frame_result;
    engine_set_paused(p, s->saved_paused);
    return true;
}

bool shell_modal_active(Port *p) {
    struct Shell *s = sh(p);
    return s && (s->modal.open || s->pending);
}

void shell_modal_wheel(Port *p, int32_t delta) {
    struct Shell *s = sh(p);
    if (s && s->ok) dlgm_wheel(&s->modal, delta, core_ticks(p));
}

int32_t shell_modal_cursor(Port *p, int32_t x, int32_t y) {
    struct Shell *s = sh(p);
    return (s && s->ok) ? dlgm_cursor(&s->modal, x, y) : DLG_CURSOR_NONE;
}
