/* The 54 engine methods that Moeboid.gam calls (M4; analysis/interface.tsv, interface.md 3.2).
 * Called by the CPU bridge for every engine thunk (cpu_set_engine_dispatch). Each case names the
 * wrapper and the inner routine of ZapSpot.exe. All methods are __thiscall: ECX = wrapper, the
 * bridge pops 4 x argc (cpu_engine_argc). */
#include "eng_int.h"
#include "shell_api.h"

#define LINE_MAX 600

static uint32_t arg(Engine *e, uint32_t args, uint32_t i) { return cpu_rd32(e->cpu, args + 4u * i); }

/* [wrapper + 4]: the inner object of a wrapper argument ("unwrapped", interface.md 3) */
static uint32_t inner(Engine *e, uint32_t wrapper) { return wrapper ? cpu_rd32(e->cpu, wrapper + 4u) : 0u; }

static void gstr(Engine *e, uint32_t a, char *out, uint32_t cap) { eng_modal_strings(e, a, out, cap); }

/* new wrapper + external AddRef (for example Z:0x415560) */
static uint32_t wrap_ref(Engine *e, uint32_t iface, uint32_t h) {
    EngObj *o = eng_obj_get(e, h, OT_NONE);
    uint32_t w = eng_wrap_new(e, iface, h);
    if (o) eng_addref_ext(o);
    return w;
}

static uint32_t release(Engine *e, uint32_t self) {
    /* Z:0x414ff0: inner NULL -> 0 (the wrapper stays); else inner Release (Z:0x414f90), delete the
     * wrapper, return the remaining external count. */
    uint32_t h = inner(e, self);
    if (!h) return 0;
    EngObj *o = eng_obj_get(e, h, OT_NONE);
    int32_t r = 0;
    if (o) r = eng_release_ext(e, o);
    else rt_log("engine: Release of a dead object %#x (wrapper %08x)", h, self);
    eng_wrap_free(e, self);
    return (uint32_t)r;
}

static void timer_fire(EngineTimer *t, const TimerEvent *ev) {
    /* Z:0x413510 callback part: e = {userdata, elapsed, elapsed, now} (Z:0x413545..0x41355a) */
    Engine *e = (Engine *)t->ctx;
    CTimer *ct = (CTimer *)((uint8_t *)t - __builtin_offsetof(CTimer, t));
    uint32_t w[4] = {ev->userdata, ev->elapsed1, ev->elapsed2, ev->now};
    char what[96];
    rt_snprintf(what, sizeof what, "timer %#x period=%u elapsed=%u cb=%08x", ct->o.h, t->period, ev->elapsed2,
                ct->guest_cb - e->delta);
    int32_t v[1] = {(int32_t)ct->o.h};
    eng_guest_call(e, ct->guest_cb, w, 4, what);
    if (eng_unwinding(e)) eng_origin_suspended(e, FR_ORIGIN_TIMER, v, 1);
}

void eng_dtor_timer(Engine *e, CTimer *t) {
    /* Z:0x4134b0: a started timer leaves the timer list */
    timer_release(&e->p->timers, &t->t);
}

void eng_dtor_sound(Engine *e, CSound *s) { snd_forget_owner(&e->voices, s->o.h); }

static int16_t key_state(Engine *e, int32_t code) {
    /* Z:0x426bf0: engine key code to virtual key, then GetKeyState */
    static const uint8_t vk[13] = {0x08, 0x2e, 0x09, 0x0d, 0x04, 0x11, 0x25, 0x27, 0x26, 0x28, 0x24, 0x23, 0x10};
    uint32_t v = (code >= 0 && code <= 12) ? vk[code] : (uint32_t)code;
    return core_key_state(e->p, v & 0xffu);
}

static uint32_t dispatch(Engine *e, uint32_t iface, uint32_t slot, uint32_t self, uint32_t a);

uint32_t eng_dispatch(void *ctx, uint32_t iface, uint32_t slot, uint32_t self, uint32_t a) {
    Engine *e = (Engine *)ctx;
    uint32_t saved = e->alloc_owner;
    e->alloc_owner = e->starts; /* objects made for the game (port: sweep at New Game) */
    uint32_t r = dispatch(e, iface, slot, self, a);
    e->alloc_owner = saved;
    return r;
}

static uint32_t dispatch(Engine *e, uint32_t iface, uint32_t slot, uint32_t self, uint32_t a) {
    char line[LINE_MAX];
    bool tr = trace_on(&e->p->trace) && e->tick_open;
    if (tr) eng_trace_call(e, iface, slot, self, a, 0, line, sizeof line, true);
    uint32_t r = 0, h = 0;
    char s1[1024], s2[1024], s3[1024];
    if (iface != CPU_IF_ISHELL && iface != CPU_IF_ISYSTEM && iface != CPU_IF_ISETTINGS) h = inner(e, self);

    switch (iface << 8 | slot) {
    /* ---- IShell (ctx, vtable Z:0x42ef20) ---- */
    case CPU_IF_ISHELL << 8 | 2: /* Random: Z:0x4160b0 -> rand Z:0x40e396 */
        r = (uint32_t)msvc_rand(&e->p->rand);
        break;

    /* ---- IFactory (vtable Z:0x42eae0) ---- */
    case CPU_IF_IFACTORY << 8 | 2: /* CreateSurfaceFromAnim: Z:0x415110 -> Z:0x417980 */
        r = wrap_ref(e, CPU_IF_ISURFACE, eng_surface_new_anim(e, inner(e, arg(e, a, 0)), arg(e, a, 1) & 0xffu));
        break;
    case CPU_IF_IFACTORY << 8 | 3: /* CreateSurfaceFromFile: Z:0x4150f0 -> Z:0x4178f0 */
        gstr(e, arg(e, a, 0), s1, sizeof s1);
        r = wrap_ref(e, CPU_IF_ISURFACE, eng_surface_new_gif(e, s1, arg(e, a, 1) & 0xffu));
        break;
    case CPU_IF_IFACTORY << 8 | 4: /* CreateSurface: Z:0x4150d0 -> Z:0x417860 (flags & 0xffffff01 to the image) */
        r = wrap_ref(e, CPU_IF_ISURFACE,
                     eng_surface_new_blank(e, (int32_t)arg(e, a, 0), (int32_t)arg(e, a, 1), arg(e, a, 2) & 0xffu));
        break;
    case CPU_IF_IFACTORY << 8 | 5: /* CreateAnim: Z:0x415130 -> Z:0x417a10 */
        r = wrap_ref(e, CPU_IF_IANIM, eng_anim_new(e, inner(e, arg(e, a, 0))));
        break;
    case CPU_IF_IFACTORY << 8 | 8: /* CreateImage: Z:0x415190 -> Z:0x417b90 (keyed = byte argument) */
        r = wrap_ref(e, CPU_IF_IIMAGE,
                     eng_image_new(e, (int32_t)arg(e, a, 0), (int32_t)arg(e, a, 1), (arg(e, a, 2) & 0xffu) != 0));
        break;
    case CPU_IF_IFACTORY << 8 | 10: /* CreateFont: Z:0x4151d0 -> Z:0x417c80, cache Z:0x426070 */
        gstr(e, arg(e, a, 0), s1, sizeof s1);
        r = wrap_ref(e, CPU_IF_IFONT, eng_font_create(e, s1, (int32_t)arg(e, a, 1), arg(e, a, 2)));
        break;
    case CPU_IF_IFACTORY << 8 | 12: /* CreateButton: Z:0x415230 -> Z:0x417d90 -> Z:0x419730 */
        r = wrap_ref(e, CPU_IF_IBUTTON,
                     eng_button_new(e, inner(e, arg(e, a, 0)), arg(e, a, 1), (int32_t)arg(e, a, 2), (int32_t)arg(e, a, 3),
                                    (int32_t)arg(e, a, 4), (int32_t)arg(e, a, 5), inner(e, arg(e, a, 6)),
                                    (int32_t)arg(e, a, 7), (int32_t)arg(e, a, 8), arg(e, a, 9), NULL, NULL));
        break;
    case CPU_IF_IFACTORY << 8 | 13: { /* CreateTimer: Z:0x415270 -> Z:0x417e40, ctor Z:0x413440 */
        CTimer *t = (CTimer *)eng_obj_new(e, OT_TIMER, sizeof(CTimer));
        timer_init(&t->t, arg(e, a, 0), arg(e, a, 1), timer_fire, e);
        t->guest_cb = arg(e, a, 2);
        r = wrap_ref(e, CPU_IF_ITIMER, t->o.h);
        break;
    }
    case CPU_IF_IFACTORY << 8 | 16: /* CreateSound: Z:0x415300 -> Z:0x417f30 (inner NULL when sound is off) */
        gstr(e, arg(e, a, 0), s1, sizeof s1);
        h = eng_sound_load(e, s1, arg(e, a, 1) & 1u);
        r = h ? wrap_ref(e, CPU_IF_ISOUND, h) : eng_wrap_new(e, CPU_IF_ISOUND, 0);
        break;
    case CPU_IF_IFACTORY << 8 | 17: /* CreateListener: Z:0x4152d0 -> Z:0x417fe0 -> Z:0x424c70 */
        r = wrap_ref(e, CPU_IF_ILISTENER,
                     eng_listener_add(e, inner(e, arg(e, a, 0)), (int32_t)arg(e, a, 1), arg(e, a, 2), arg(e, a, 3), NULL,
                                      NULL));
        break;

    /* ---- ISystem (vtable Z:0x42ec3c, object of Z:0x415df0) ---- */
    case CPU_IF_ISYSTEM << 8 | 2: { /* SetCaption: Z:0x415f20 (shell +0x88, Z:0x41b7f0) */
        gstr(e, arg(e, a, 0), e->caption, sizeof e->caption);
        shell_caption_changed(e->p, e->caption);
        break;
    }
    case CPU_IF_ISYSTEM << 8 | 3: /* SetGameInProgress: Z:0x415f50 -> Z:0x41b970 */
        e->game_in_progress = (int32_t)arg(e, a, 0);
        shell_game_in_progress(e->p, e->game_in_progress);
        break;
    case CPU_IF_ISYSTEM << 8 | 4: /* SetShellButtons: Z:0x415f70 -> Z:0x41b990 */
        e->shell_buttons = arg(e, a, 0);
        shell_buttons_changed(e->p, e->shell_buttons);
        break;
    case CPU_IF_ISYSTEM << 8 | 5: /* MessageBox: Z:0x415f90 -> Z:0x41c2c0 -> platform +0x40 Z:0x4058c0 */
        gstr(e, arg(e, a, 0), s1, sizeof s1);
        gstr(e, arg(e, a, 1), s2, sizeof s2);
        r = eng_modal_dialog(e, SHELL_DLG_MESSAGEBOX, s1, s2, NULL, 0, 0, arg(e, a, 2));
        break;
    case CPU_IF_ISYSTEM << 8 | 6: /* InputBox: Z:0x415fb0 -> Z:0x41c2e0 -> platform +0x44 Z:0x405480 */
        gstr(e, arg(e, a, 0), s1, sizeof s1);
        gstr(e, arg(e, a, 1), s2, sizeof s2);
        gstr(e, arg(e, a, 2), s3, sizeof s3);
        r = eng_modal_dialog(e, SHELL_DLG_INPUTBOX, s1, s2, s3, arg(e, a, 3), (int32_t)arg(e, a, 4), arg(e, a, 5));
        break;
    case CPU_IF_ISYSTEM << 8 | 8: /* GetKeyState: Z:0x416000 (MOVSX) -> input +0x0c Z:0x426bf0 */
        r = (uint32_t)(int32_t)key_state(e, (int32_t)(int8_t)(arg(e, a, 0) & 0xffu));
        break;

    /* ---- ISettings (vtable Z:0x42ef04) ---- */
    case CPU_IF_ISETTINGS << 8 | 4: /* SetGameValue: Z:0x416060 -> store +0x08 Z:0x429710 */
        gstr(e, arg(e, a, 0), s1, sizeof s1);
        gstr(e, arg(e, a, 1), s2, sizeof s2);
        eng_prop_set_game(e, s1, s2);
        break;
    case CPU_IF_ISETTINGS << 8 | 5: { /* GetGameValue: Z:0x416080 -> store +0x0c Z:0x4294f0 */
        gstr(e, arg(e, a, 0), s1, sizeof s1);
        r = (uint32_t)eng_prop_get_game(e, s1, s2, sizeof s2);
        uint32_t out = arg(e, a, 1);
        cpu_mem_write(e->cpu, out, s2, (uint32_t)rt_strlen(s2) + 1u); /* strcpy, no size limit */
        break;
    }

    /* ---- Release (Z:0x414ff0, the same function in every vtable) ---- */
    case CPU_IF_ISURFACE << 8 | 1:
    case CPU_IF_IBUTTON << 8 | 1:
    case CPU_IF_IANIM << 8 | 1:
    case CPU_IF_IIMAGESEQ << 8 | 1:
    case CPU_IF_IIMAGE << 8 | 1:
    case CPU_IF_IFONT << 8 | 1:
    case CPU_IF_ITIMER << 8 | 1:
    case CPU_IF_ISOUND << 8 | 1:
    case CPU_IF_ILISTENER << 8 | 1:
        r = release(e, self);
        break;

    /* ---- ISurface (vtable Z:0x42eb34, CSurface) ---- */
    case CPU_IF_ISURFACE << 8 | 2: /* SetLoc: Z:0x415360 -> Z:0x4146a0 */
        r = (uint32_t)eng_surface_set_loc(e, h, (int32_t)arg(e, a, 0), (int32_t)arg(e, a, 1), arg(e, a, 2));
        break;
    case CPU_IF_ISURFACE << 8 | 3: { /* GetLoc: Z:0x415380 -> Z:0x414700 */
        CSurface *s = eng_surface(e, h);
        cpu_wr32(e->cpu, arg(e, a, 0), s ? (uint32_t)s->x : 0u);
        cpu_wr32(e->cpu, arg(e, a, 1), s ? (uint32_t)s->y : 0u);
        break;
    }
    case CPU_IF_ISURFACE << 8 | 4: /* SetVisible: Z:0x4153a0 -> Z:0x414720 (byte argument) */
        r = (uint32_t)eng_surface_set_visible(e, h, (arg(e, a, 0) & 0xffu) != 0, arg(e, a, 1));
        break;
    case CPU_IF_ISURFACE << 8 | 6: /* AttachSurface: Z:0x4153d0 -> Z:0x414780 */
        r = (uint32_t)eng_surface_attach(e, h, inner(e, arg(e, a, 0)));
        break;
    case CPU_IF_ISURFACE << 8 | 7: /* DetachSurface: Z:0x4154e0 -> Z:0x4147f0 */
        r = (uint32_t)eng_surface_detach(e, h, inner(e, arg(e, a, 0)));
        break;
    case CPU_IF_ISURFACE << 8 | 11: { /* PlayAnim: Z:0x415500 -> Z:0x414b60 -> Z:0x4176f0 */
        CSurface *s = eng_surface(e, h);
        r = s ? (uint32_t)eng_anim_start(e, s->anim) : 0u;
        break;
    }
    case CPU_IF_ISURFACE << 8 | 13: { /* StopAnim: Z:0x415530 -> Z:0x414bb0 -> Z:0x417740 */
        CSurface *s = eng_surface(e, h);
        r = s ? (uint32_t)eng_anim_stop(e, s->anim) : 0u;
        break;
    }
    case CPU_IF_ISURFACE << 8 | 15: { /* GetAnim: Z:0x415560 */
        CSurface *s = eng_surface(e, h);
        cpu_wr32(e->cpu, arg(e, a, 0), wrap_ref(e, CPU_IF_IANIM, s ? s->anim : 0u));
        break;
    }
    case CPU_IF_ISURFACE << 8 | 17: /* GetImage: Z:0x4155b0 */
        cpu_wr32(e->cpu, arg(e, a, 0), wrap_ref(e, CPU_IF_IIMAGE, eng_surface_image(e, h)));
        break;
    case CPU_IF_ISURFACE << 8 | 18: { /* GetSize: Z:0x415640 -> Z:0x414c70 */
        int32_t w, hh;
        eng_surface_size(e, h, &w, &hh);
        cpu_wr32(e->cpu, arg(e, a, 0), (uint32_t)w);
        cpu_wr32(e->cpu, arg(e, a, 1), (uint32_t)hh);
        break;
    }

    /* ---- IAnim (vtable Z:0x42eb8c) ---- */
    case CPU_IF_IANIM << 8 | 4: { /* GetImageSeq: Z:0x415720 */
        CAnim *an = ENG_GET(e, h, CAnim, OT_ANIM);
        cpu_wr32(e->cpu, arg(e, a, 0), wrap_ref(e, CPU_IF_IIMAGESEQ, an ? an->seq : 0u));
        break;
    }

    /* ---- IImageSeq (vtable Z:0x42ec10) ---- */
    case CPU_IF_IIMAGESEQ << 8 | 4: { /* GetImage: Z:0x4157f0 -> Z:0x417060 */
        uint32_t img;
        if (eng_seq_get(e, h, (int32_t)arg(e, a, 0), &img) != 0 || !img) {
            cpu_raise(e->cpu, CPU_FAULT_HOST, "IImageSeq::GetImage: invalid index (the original dereferences NULL)");
            return 0;
        }
        cpu_wr32(e->cpu, arg(e, a, 1), wrap_ref(e, CPU_IF_IIMAGE, img));
        break;
    }

    /* ---- IImage (vtable Z:0x42ebb0, CImage, render target Z:0x42e790) ---- */
    case CPU_IF_IIMAGE << 8 | 3: { /* DrawRect: Z:0x4158b0 -> Z:0x413bd0 -> rt +0x08 Z:0x40bc00 */
        CImage *im = eng_image(e, h);
        if (!im) break;
        eng_image_changed(e, h);
        draw_frame_rect(&im->img, (int32_t)arg(e, a, 0), (int32_t)arg(e, a, 1), (int32_t)arg(e, a, 2), (int32_t)arg(e, a, 3),
                        im->pen);
        break;
    }
    case CPU_IF_IIMAGE << 8 | 4: { /* FillRect: Z:0x4158d0 -> Z:0x413c00 -> rt +0x0c Z:0x40bc60 */
        CImage *im = eng_image(e, h);
        if (!im) break;
        eng_image_changed(e, h);
        draw_fill_rect(&im->img, (int32_t)arg(e, a, 0), (int32_t)arg(e, a, 1), (int32_t)arg(e, a, 2), (int32_t)arg(e, a, 3),
                       im->pen);
        break;
    }
    case CPU_IF_IIMAGE << 8 | 6: { /* DrawText: Z:0x415920 -> Z:0x413c30 -> rt +0x3c Z:0x40c110 */
        int32_t n = (int32_t)arg(e, a, 1);
        if (n < 0) n = 0;
        if (n > (int32_t)sizeof s1) n = (int32_t)sizeof s1;
        if (n) cpu_mem_read(e->cpu, arg(e, a, 0), s1, (uint32_t)n);
        if (!n) s1[0] = 0;
        r = (uint32_t)eng_image_text(e, h, s1, n, (int32_t)arg(e, a, 2), (int32_t)arg(e, a, 3));
        break;
    }
    case CPU_IF_IIMAGE << 8 | 7: { /* SetColor: Z:0x415940 -> Z:0x413d10 -> rt +0x14 Z:0x40bcc0 (pen and brush) */
        CImage *im = eng_image(e, h);
        if (im) im->pen = IMG_RGB(arg(e, a, 0) & 0xffu, arg(e, a, 1) & 0xffu, arg(e, a, 2) & 0xffu);
        break;
    }
    case CPU_IF_IIMAGE << 8 | 9: { /* SetTextColor: Z:0x415980 -> Z:0x413d50 -> rt +0x1c Z:0x429d50 */
        CImage *im = eng_image(e, h);
        if (im) im->text_color = IMG_RGB(arg(e, a, 0) & 0xffu, arg(e, a, 1) & 0xffu, arg(e, a, 2) & 0xffu);
        break;
    }
    case CPU_IF_IIMAGE << 8 | 13: /* ClearToColor: Z:0x415a00 -> Z:0x413dd0 */
        r = (uint32_t)eng_image_clear(e, h, (arg(e, a, 0) & 0xffu) << 16 | (arg(e, a, 1) & 0xffu) << 8 | (arg(e, a, 2) & 0xffu));
        break;
    case CPU_IF_IIMAGE << 8 | 16: /* DrawImage: Z:0x415a30 -> Z:0x413f00 -> rt +0x38 Z:0x40bef0 */
        r = (uint32_t)eng_image_draw_at(e, h, inner(e, arg(e, a, 0)), (int32_t)arg(e, a, 1), (int32_t)arg(e, a, 2));
        break;
    case CPU_IF_IIMAGE << 8 | 18: /* SetFont: Z:0x415a90 -> Z:0x413f80 */
        r = (uint32_t)eng_image_set_font(e, h, inner(e, arg(e, a, 0)));
        break;
    case CPU_IF_IIMAGE << 8 | 19: { /* GetFont: Z:0x415ab0 */
        CImage *im = eng_image(e, h);
        cpu_wr32(e->cpu, arg(e, a, 0), wrap_ref(e, CPU_IF_IFONT, im ? im->font : 0u));
        break;
    }
    case CPU_IF_IIMAGE << 8 | 20: { /* GetSize: Z:0x415b00 -> Z:0x413fd0 -> rt +0x54 Z:0x40c330 */
        CImage *im = eng_image(e, h);
        cpu_wr32(e->cpu, arg(e, a, 0), im ? (uint32_t)im->img.w : 0u);
        cpu_wr32(e->cpu, arg(e, a, 1), im ? (uint32_t)im->img.h : 0u);
        break;
    }
    case CPU_IF_IIMAGE << 8 | 22: { /* MeasureText: Z:0x415b40 -> Z:0x414030 -> rt +0x60 Z:0x40c2c0 */
        int32_t n = (int32_t)arg(e, a, 2), cx, cy;
        if (n < 0) n = 0;
        if (n > (int32_t)sizeof s1) n = (int32_t)sizeof s1;
        if (n) cpu_mem_read(e->cpu, arg(e, a, 1), s1, (uint32_t)n);
        r = (uint32_t)eng_image_measure(e, h, inner(e, arg(e, a, 0)), s1, n, &cx, &cy);
        cpu_wr32(e->cpu, arg(e, a, 3), (uint32_t)cx);
        cpu_wr32(e->cpu, arg(e, a, 3) + 4u, (uint32_t)cy);
        break;
    }

    /* ---- IFont (vtable Z:0x42ec2c) ---- */
    case CPU_IF_IFONT << 8 | 3: { /* GetInfo: Z:0x415cc0 -> font +0x18 Z:0x427e60 */
        CFont *f = ENG_GET(e, h, CFont, OT_FONT);
        const char *face = f ? f->face : "";
        cpu_mem_write(e->cpu, arg(e, a, 0), face, (uint32_t)rt_strlen(face) + 1u);
        cpu_wr32(e->cpu, arg(e, a, 1), f ? (uint32_t)f->px : 0u);
        cpu_wr32(e->cpu, arg(e, a, 2), f ? (uint32_t)f->index : 0u);
        cpu_wr32(e->cpu, arg(e, a, 3), f ? f->style : 0u);
        break;
    }

    /* ---- ITimer (vtable Z:0x42ed68) ---- */
    case CPU_IF_ITIMER << 8 | 2: { /* Start: Z:0x415ce0 -> Z:0x413580 */
        CTimer *t = ENG_GET(e, h, CTimer, OT_TIMER);
        if (t) timer_start(&e->p->timers, &t->t);
        break;
    }

    /* ---- ISound (vtable Z:0x42ed90) ---- */
    case CPU_IF_ISOUND << 8 | 2: /* Play: Z:0x415db0 (8 when the inner sound is NULL) -> Z:0x40c510 */
        r = h ? (uint32_t)eng_sound_play(e, h, (int32_t)arg(e, a, 0)) : 8u;
        break;

    default: {
        char t[96];
        rt_snprintf(t, sizeof t, "engine method %u.%#x not implemented", iface, slot * 4u);
        cpu_raise(e->cpu, CPU_FAULT_THUNK, t);
        return 0;
    }
    }

    if (tr) {
        if (cpu_suspended(e->cpu) || e->modal.active) {
            /* MessageBox / InputBox waits: the line gets its result in engine_dialog_done */
            rt_memcpy(e->modal.line, line, sizeof line);
            e->modal.trace_pending = true;
        } else {
            eng_trace_finish_line(e, line, r);
        }
    }
    return r;
}
