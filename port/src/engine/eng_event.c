/* Event manager (M4): channels, listeners, dispatch of keys and mouse events, buttons' events.
 * Model of DAT_0045cfc0 (ctor Z:0x424c00, vtable Z:0x42ef30) and of the channel/listener objects
 * (Z:0x427600, Z:0x427b30); analysis/interface.md 5.3, audio-input.md 3.2-3.6.
 *
 * Resumable loops (modal suspend, eng_modal.c): every loop that can call game code saves its
 * position in a frame when the call suspends (rs = RS_UNWIND) and continues from it when the engine
 * rewinds (rs = RS_REWIND). */
#include "eng_int.h"

static CChannel *chan(Engine *e, uint32_t h) { return ENG_GET(e, h, CChannel, OT_CHANNEL); }
static CListener *lis(Engine *e, uint32_t h) { return ENG_GET(e, h, CListener, OT_LISTENER); }

void eng_set_cursor(Engine *e, int32_t id) {
    /* cursor manager +0x0c: SetCursor; WM_MOUSEMOVE calls SetCursor(current) (Z:0x4040e0) */
    if (id >= 0) e->p->cursor = (uint32_t)id;
}

/* ------------------------------------------------------------------ channels and listeners */
uint32_t eng_channel_new(Engine *e, uint32_t source, int32_t type, bool autodel) {
    /* Z:0x424da0 (autodel 0) / Z:0x424e30 (autodel 1) with Z:0x427600; appended to the manager list */
    CChannel *c = (CChannel *)eng_obj_new(e, OT_CHANNEL, sizeof(CChannel));
    c->source = source;
    c->type = type;
    c->autodel = autodel ? 1u : 0u;
    hl_push(&e->channels, c->o.h);
    return c->o.h;
}

void eng_channel_removed(Engine *e, uint32_t ch) {
    /* Z:0x424ee0 */
    hl_remove(&e->channels, ch);
}

void eng_dtor_channel(Engine *e, CChannel *c) {
    /* Z:0x427680: each listener forgets the channel and loses an internal reference. */
    uint32_t ch = c->o.h;
    for (int32_t i = 0; i < c->listeners.n; i++) {
        CListener *l = lis(e, c->listeners.v[i]);
        if (!l) continue;
        l->channel = 0;
        eng_release_int(e, &l->o);
        c = chan(e, ch);
        if (!c) return;
    }
    eng_channel_removed(e, ch);
    hl_free(&c->listeners);
}

uint32_t eng_listener_add(Engine *e, uint32_t source, int32_t type, uint32_t user, uint32_t guest_cb,
                          EngListenFn cfn, void *cctx) {
    /* Z:0x424c70: new listener (Z:0x427b30), channel (source, type) from the list; when absent, a new
     * auto-delete channel only for type < 0xe (Z:0x424c60); the listener is returned in any case. */
    CListener *l = (CListener *)eng_obj_new(e, OT_LISTENER, sizeof(CListener));
    l->user = user;
    l->value = 0;
    l->channel = 0;
    l->guest_cb = guest_cb;
    l->cfn = cfn;
    l->cctx = cctx;
    uint32_t lh = l->o.h, ch = 0;
    for (int32_t i = 0; i < e->channels.n; i++) {
        CChannel *c = chan(e, e->channels.v[i]);
        if (c && c->source == source && c->type == type) {
            ch = c->o.h;
            break;
        }
    }
    if (!ch && type < 0xe) ch = eng_channel_new(e, source, type, true);
    if (ch) {
        CChannel *c = chan(e, ch);
        hl_push(&c->listeners, lh); /* Z:0x4277c0 */
        lis(e, lh)->channel = ch;
    }
    return lh;
}

void eng_listener_set_value(Engine *e, uint32_t h, uint32_t v) {
    /* Z:0x427b60 */
    CListener *l = lis(e, h);
    if (l) l->value = v;
}

void eng_dtor_listener(Engine *e, CListener *l) {
    /* Z:0x4259b0 -> Z:0x427810: leave the channel; an empty auto-delete channel goes too. */
    CChannel *c = chan(e, l->channel);
    if (!c) return;
    if (!hl_remove(&c->listeners, l->o.h)) {
        rt_log("engine: Error - unrecognized EventListener");
        return;
    }
    l->channel = 0;
    if (c->autodel && c->listeners.n == 0) {
        eng_channel_removed(e, c->o.h);
        eng_obj_destroy(e, &c->o);
    }
}

/* ------------------------------------------------------------------ fire */
static uint32_t listener_call(Engine *e, uint32_t lh, EvRec *rec) {
    /* Z:0x427b10: record word 0 = userdata, word 1 = listener value, then the callback. */
    CListener *l = lis(e, lh);
    if (!l) return 1;
    rec->w[0] = l->user;
    rec->w[1] = l->value;
    if (l->guest_cb) {
        char what[96];
        CChannel *c = chan(e, l->channel);
        rt_snprintf(what, sizeof what, "event %#x listener %#x", c ? (unsigned)c->type : 0u, lh);
        return eng_guest_call(e, l->guest_cb, rec->w, 8, what);
    }
    return l->cfn ? l->cfn(e, l->cctx, rec) : 1;
}

uint32_t eng_fire(Engine *e, uint32_t ch, EvRec *rec) {
    /* Z:0x427750: listeners in list order until one returns 0 (result 0), else 1. */
    int32_t j = 0;
    bool resume = false;
    if (eng_rewinding(e)) {
        EngFrame *f = eng_frame_pop(e, FR_FIRE);
        if (!f) return 0;
        ch = (uint32_t)f->v[0];
        j = f->v[1];
        *rec = f->rec;
        resume = true;
    }
    for (;;) {
        CChannel *c = chan(e, ch);
        if (!c || j >= c->listeners.n) {
            if (resume) eng_fail(e, "rewind: channel %#x changed", ch);
            return 1;
        }
        resume = false;
        uint32_t r = listener_call(e, c->listeners.v[j], rec);
        if (eng_unwinding(e)) {
            int32_t v[2] = {(int32_t)ch, j};
            eng_frame_push(e, FR_FIRE, v, 2, rec);
            return 0;
        }
        if (r == 0) return 0;
        j++;
    }
}

/* ------------------------------------------------------------------ keys */
void eng_key_dispatch(Engine *e, int32_t type, int32_t keycode, uint32_t wparam) {
    /* Z:0x425870: every channel of the type (the source is not compared), in list order, until a
     * fire returns 0. Record: w2 = wParam, w3 = type, w4 = key code; w0 = channel source (then the
     * listener userdata). */
    EvRec rec;
    rt_memset(&rec, 0, sizeof rec);
    rec.w[2] = wparam;
    rec.w[3] = (uint32_t)type;
    rec.w[4] = (uint32_t)keycode;
    int32_t i = 0;
    bool resume = false;
    if (eng_rewinding(e)) {
        EngFrame *f = eng_frame_pop(e, FR_KEYDISP);
        if (!f) return;
        i = f->v[0];
        rec = f->rec;
        resume = true;
    }
    for (; i < e->channels.n; i++) {
        uint32_t ch = e->channels.v[i];
        if (!resume) {
            CChannel *c = chan(e, ch);
            if (!c || c->type != type) continue;
            rec.w[0] = c->source;
        }
        resume = false;
        uint32_t r = eng_fire(e, ch, &rec);
        if (eng_unwinding(e)) {
            int32_t v[1] = {i};
            eng_frame_push(e, FR_KEYDISP, v, 1, &rec);
            return;
        }
        if (r == 0) return;
    }
}

/* ------------------------------------------------------------------ mouse */
static void hit_local(Engine *e, uint32_t s, int32_t x, int32_t y, int32_t *lx, int32_t *ly) {
    /* subtract the position of s and of every parent (Z:0x425020, FUN_004149e0 = GetParent) */
    *lx = x;
    *ly = y;
    for (CSurface *p = eng_surface(e, s); p; p = eng_surface(e, p->parent)) {
        *lx -= p->x;
        *ly -= p->y;
    }
}

enum { MP_HIT = 1, MP_PRESSED, MP_LEAVE, MP_ENTER, MP_CLICK, MP_REENTER };
#define MF_ENTER_FIRED 1
#define MF_LEAVE_FIRED 2

void eng_mouse_event(Engine *e, int32_t type, int32_t x, int32_t y) {
    /* Z:0x425020 MouseEvent(type, x, y) (event manager +0x00). Types: 1 L down, 2 L up, 3 L dbl,
     * 4 R down, 5 R up, 6 R dbl, 7 move; listeners 8 enter, 9 leave, 10 click. */
    EvRec rec;
    rt_memset(&rec, 0, sizeof rec);
    uint32_t hit = 0;
    int32_t lx = 0, ly = 0, i = 0, phase = 0, flags = 0, r_leave = 1, r_enter = 1;
    uint32_t r;
    bool resume = false;
    if (eng_rewinding(e)) {
        EngFrame *f = eng_frame_pop(e, FR_MOUSE);
        if (!f) return;
        phase = f->v[0];
        i = f->v[1];
        hit = (uint32_t)f->v[2];
        lx = f->v[3];
        ly = f->v[4];
        flags = f->v[5];
        r_leave = f->v[6];
        r_enter = f->v[7];
        rec = f->rec;
        resume = true;
        switch (phase) {
        case MP_HIT: goto p_hit;
        case MP_PRESSED: goto p_pressed;
        case MP_LEAVE: goto p_leave;
        case MP_ENTER: goto p_enter;
        case MP_CLICK: goto p_click;
        case MP_REENTER: goto p_reenter;
        default: return;
        }
    }
#define SAVE(ph)                                                                                  \
    do {                                                                                          \
        int32_t v_[8] = {(ph), i, (int32_t)hit, lx, ly, flags, r_leave, r_enter};                 \
        eng_frame_push(e, FR_MOUSE, v_, 8, &rec);                                                 \
        return;                                                                                   \
    } while (0)

    e->mouse_x = x;
    e->mouse_y = y;
    eng_surface_hit(e, e->root, x, y, &hit);
    lx = x;
    ly = y;
    if (hit) hit_local(e, hit, x, y, &lx, &ly);
    /* type 1: SetCapture; SetFocus when inside the game surface; type 2: ReleaseCapture (no state) */
    e->last_hit = hit;

    /* phase 1: channels of the hit surface for this type, unless another surface has the capture */
    for (i = 0; i < e->channels.n; i++) {
        {
            CChannel *c = chan(e, e->channels.v[i]);
            if (!c || c->source != hit || c->type != type) continue;
            if (!(e->pressed == 0 || hit == e->pressed)) continue;
            rec.w[0] = c->source;
            rec.w[2] = (uint32_t)lx;
            rec.w[3] = (uint32_t)ly;
        }
    p_hit:
        resume = false;
        r = eng_fire(e, e->channels.v[i], &rec);
        if (eng_unwinding(e)) SAVE(MP_HIT);
        if (r == 0) break;
    }
    /* phase 2: the capture surface, when phase 1 ran through */
    if (e->pressed != 0 && i == e->channels.n) {
        for (i = 0; i < e->channels.n; i++) {
            {
                CChannel *c = chan(e, e->channels.v[i]);
                if (!c || c->source != e->pressed || c->type != type) continue;
                hit_local(e, e->pressed, x, y, &lx, &ly);
                rec.w[0] = c->source;
                rec.w[2] = (uint32_t)lx;
                rec.w[3] = (uint32_t)ly;
            }
        p_pressed:
            resume = false;
            r = eng_fire(e, e->channels.v[i], &rec);
            if (eng_unwinding(e)) SAVE(MP_PRESSED);
            if (r == 0) break;
        }
    }
    if (type == 7) {
        if (e->hover != hit) {
            /* leave on the old hover surface while the fires return 1 */
            for (i = 0; i < e->channels.n; i++) {
                if (r_leave != 1) continue;
                {
                    CChannel *c = chan(e, e->channels.v[i]);
                    if (!c || c->source != e->hover || c->type != 9) continue;
                    rec.w[0] = c->source;
                }
            p_leave:
                resume = false;
                r_leave = (int32_t)eng_fire(e, e->channels.v[i], &rec);
                if (eng_unwinding(e)) SAVE(MP_LEAVE);
                flags |= MF_LEAVE_FIRED;
                CSurface *hs = eng_surface(e, e->hover);
                if (hs && hs->cursor >= 0) eng_set_cursor(e, 0); /* cursor manager +0x08(0) */
            }
            /* enter on the new surface */
            for (i = 0; i < e->channels.n; i++) {
                if (r_enter != 1) continue;
                {
                    CChannel *c = chan(e, e->channels.v[i]);
                    if (!c || c->source != hit || c->type != 8) continue;
                    if (!(e->pressed == 0 || hit == e->pressed)) continue;
                    rec.w[0] = c->source;
                }
            p_enter:
                resume = false;
                r_enter = (int32_t)eng_fire(e, e->channels.v[i], &rec);
                if (eng_unwinding(e)) SAVE(MP_ENTER);
                flags |= MF_ENTER_FIRED;
                CSurface *hs = eng_surface(e, hit);
                if (hs && hs->cursor >= 0) eng_set_cursor(e, hs->cursor);
            }
            if (flags & MF_ENTER_FIRED) e->hover = hit;
            else if (flags & MF_LEAVE_FIRED) e->hover = 0;
        }
    } else if (type == 1 && !e->hit_destroyed) {
        e->pressed = hit;
    }
    e->hit_destroyed = false;
    if (type == 2) {
        if (hit == e->pressed) {
            for (i = 0; i < e->channels.n; i++) {
                {
                    CChannel *c = chan(e, e->channels.v[i]);
                    if (!c || c->source != hit || c->type != 10) continue;
                    rec.w[0] = c->source;
                }
            p_click:
                resume = false;
                r = eng_fire(e, e->channels.v[i], &rec);
                if (eng_unwinding(e)) SAVE(MP_CLICK);
                if (r == 0) break;
            }
        } else {
            for (i = 0; i < e->channels.n; i++) {
                {
                    CChannel *c = chan(e, e->channels.v[i]);
                    if (!c || c->source != hit || c->type != 8) continue;
                    rec.w[0] = c->source;
                }
            p_reenter:
                resume = false;
                r = eng_fire(e, e->channels.v[i], &rec);
                if (eng_unwinding(e)) SAVE(MP_REENTER);
                CSurface *hs = eng_surface(e, hit);
                if (hs && hs->cursor >= 0) eng_set_cursor(e, hs->cursor);
                if (r == 0) break;
            }
        }
        e->pressed = 0;
    }
    (void)resume;
#undef SAVE
}

void eng_surface_destroyed(Engine *e, uint32_t s) {
    /* Z:0x424fb0: a destroyed hover or capture surface is cleared and the last mouse position is
     * dispatched again as a move; the last hit surface marks the current dispatch. */
    if (s == e->hover) {
        e->hover = 0;
        eng_mouse_event(e, 7, e->mouse_x, e->mouse_y);
    }
    if (s == e->pressed) {
        e->pressed = 0;
        eng_mouse_event(e, 7, e->mouse_x, e->mouse_y);
    }
    if (e->last_hit == s) e->hit_destroyed = true;
}

/* ------------------------------------------------------------------ applet events */
uint32_t eng_applet_event(Engine *e, int32_t arg) {
    /* Z:0x424aa0: arg 0 fires ISystem[2] (channel 0x11), arg 1 ISystem[3] (channel 0x10);
     * record word 2 = 0. */
    EvRec rec;
    rt_memset(&rec, 0, sizeof rec);
    uint32_t ch = 0;
    if (eng_rewinding(e)) return eng_fire(e, 0, &rec); /* the FR_FIRE frame has the channel */
    if (arg == 0) ch = e->sys_ch11;
    else if (arg == 1) ch = e->sys_ch10;
    if (!ch) return 0;
    eng_fire(e, ch, &rec);
    return 0;
}
