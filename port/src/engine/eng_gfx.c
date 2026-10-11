/* Engine graphics objects (M4): CImage, CImageSeq, animation player, CSurface, buttons, fonts.
 * Rules: analysis/rendering.md 4-6, timing.md 4, fonts.md 3-5, interface.md 3. Each function names
 * the ZapSpot.exe routine it copies. */
#include "eng_int.h"

static inline int32_t imin(int32_t a, int32_t b) { return a < b ? a : b; }
static inline int32_t imax(int32_t a, int32_t b) { return a > b ? a : b; }

CImage *eng_image(Engine *e, uint32_t h) { return ENG_GET(e, h, CImage, OT_IMAGE); }
CSurface *eng_surface(Engine *e, uint32_t h) { return ENG_GET(e, h, CSurface, OT_SURFACE); }

static uint32_t rgb_px(uint32_t r, uint32_t g, uint32_t b) { return IMG_RGB(r & 0xffu, g & 0xffu, b & 0xffu); }

/* ------------------------------------------------------------------ fonts */
static void font_build(Engine *e, CFont *f) {
    /* Z:0x427c10: LOGFONT lfHeight = -px, lfWeight = 700 for style bit 0 else 0, italic, underline,
     * strikeout from bits 1..3; metrics with GetTextMetricsA and GetTextExtentPoint32A. */
    int32_t weight = (f->style & 1u) ? 700 : 0;
    f->ok = gdi_font_select(&f->gdi, &e->fonts, f->face, -f->px, weight, (f->style >> 2) & 1u, (f->style >> 3) & 1u) == 0;
    if (!f->ok) {
        /* GDI font mapping substitutes another face (inferred); the port has Arial atlases only. */
        f->ok = gdi_font_select(&f->gdi, &e->fonts, "Arial", -f->px, weight, (f->style >> 2) & 1u, (f->style >> 3) & 1u) == 0;
        if (!f->ok) rt_log("engine: no glyph atlas for font %s %d style %u", f->face, f->px, f->style);
    }
    if (f->ok) {
        GdiTextMetrics tm;
        gdi_get_text_metrics(&f->gdi, &tm);
        f->line_h = tm.tmExternalLeading + tm.tmHeight;
        f->ave_w = tm.tmAveCharWidth;
        int32_t cy;
        gdi_get_text_extent_point32(&f->gdi, " ", 1, &f->space_w, &cy);
        gdi_get_text_extent_point32(&f->gdi, ".", 1, &f->dot_w, &cy);
    }
    /* Z:0x427d2b: size class loop over the index column of the preset table Z:0x435cd0: entry 0
     * (index 0) matches every px >= 0 (fonts.md 3.1). */
    f->index = f->px >= 0 ? 0 : 0;
}

uint32_t eng_font_create(Engine *e, const char *face, int32_t px, uint32_t style) {
    /* Z:0x426070: cache lookup by px, style and face (lstrcmpiA); hit: internal AddRef. */
    for (int32_t i = 0; i < e->font_cache.n; i++) {
        CFont *f = ENG_GET(e, e->font_cache.v[i], CFont, OT_FONT);
        if (f && f->px == px && f->style == style && eng_str_ieq(f->face, face)) {
            eng_addref_int(&f->o);
            return f->o.h;
        }
    }
    if (e->font_cache.n == 999) {
        /* scalar delete of entry 0, then shift (Z:0x426180) */
        EngObj *o = eng_obj_get(e, e->font_cache.v[0], OT_FONT);
        hl_remove(&e->font_cache, e->font_cache.v[0]);
        if (o) eng_obj_destroy(e, o);
    }
    CFont *f = (CFont *)eng_obj_new(e, OT_FONT, sizeof(CFont));
    uint32_t i = 0;
    for (; face && face[i] && i + 1 < sizeof f->face; i++) f->face[i] = face[i];
    f->face[i] = 0;
    f->px = px;
    f->style = style;
    font_build(e, f);
    hl_push(&e->font_cache, f->o.h);
    eng_addref_int(&f->o);
    return f->o.h;
}

void eng_dtor_font(Engine *e, CFont *f) {
    hl_remove(&e->font_cache, f->o.h);
}

/* ------------------------------------------------------------------ images */
uint32_t eng_image_new(Engine *e, int32_t w, int32_t h, bool keyed) {
    /* Z:0x4138f0; render target Z:0x40b950 (background colour magenta when keyed, else black;
     * pen white; cleared to the background colour). */
    CImage *im = (CImage *)eng_obj_new(e, OT_IMAGE, sizeof(CImage));
    im->img.w = w > 0 ? w : 0;
    im->img.h = h > 0 ? h : 0;
    im->img.stride = im->img.w;
    im->img.keyed = keyed ? 1u : 0u;
    size_t n = (size_t)im->img.w * (size_t)im->img.h;
    im->img.px = n ? (uint32_t *)rt_malloc(n * 4u) : NULL;
    if (n && !im->img.px) rt_panic("engine: out of memory (image %dx%d)", w, h);
    im->keyed = im->img.keyed;
    im->bk_color = keyed ? rgb_px(255, 0, 255) : rgb_px(0, 0, 0);
    im->pen = rgb_px(255, 255, 255);
    draw_clear(&im->img, im->bk_color);
    /* default font Arial 18 regular from the font cache, then SetFont (Z:0x413979) */
    uint32_t f = eng_font_create(e, "Arial", 0x12, 0);
    eng_image_set_font(e, im->o.h, f);
    im->transparent = 1;
    im->text_color = rgb_px(255, 255, 255); /* Z:0x413d50(0xff, 0xff, 0xff) */
    im->centre = 0;
    im->shadow = 0;
    return im->o.h;
}

uint32_t eng_image_new_cell(Engine *e, uint32_t src, int32_t index, int32_t w, int32_t h) {
    /* Z:0x413a00(src, index, w, h, -1, -1): keyed like src; draw the cell (index * w, 0) - ((index + 1) * w, h)
     * of src over the whole new image (Z:0x413f30 with NULL destination). */
    CImage *s = eng_image(e, src);
    uint32_t nh = eng_image_new(e, w, h, s ? s->keyed : 0);
    if (s) {
        DrawRect sr = {index * w, 0, (index + 1) * w, h};
        eng_image_draw(e, nh, NULL, src, &sr);
    }
    return nh;
}

void eng_dtor_image(Engine *e, CImage *im) {
    /* Z:0x413b20: font internal Release, delete the render target. */
    if (im->font) eng_release_int_h(e, im->font);
    rt_free(im->img.px);
    hl_free(&im->seqs);
    hl_free(&im->links);
}

void eng_image_changed(Engine *e, uint32_t img) {
    /* Z:0x414120 -> Z:0x417390 -> Z:0x417800: invalidate every surface of every player of every
     * sequence that holds the image (whatever image the player shows now). */
    CImage *im = eng_image(e, img);
    if (!im) return;
    for (int32_t i = 0; i < im->seqs.n; i++) {
        CSeq *s = ENG_GET(e, im->seqs.v[i], CSeq, OT_SEQ);
        if (!s) continue;
        for (int32_t j = 0; j < s->anims.n; j++) {
            CAnim *a = ENG_GET(e, s->anims.v[j], CAnim, OT_ANIM);
            if (!a) continue;
            for (int32_t k = 0; k < a->surfaces.n; k++) eng_surface_invalidate(e, a->surfaces.v[k]);
        }
    }
}

int32_t eng_image_draw(Engine *e, uint32_t target, const DrawRect *dst, uint32_t src, const DrawRect *srect) {
    /* Z:0x413f30: Z:0x414120 on the SOURCE image (verified in the listing: ECX = [EBP+0xc]), then
     * render target +0x34 Blt (Z:0x40bf70). */
    CImage *t = eng_image(e, target), *s = eng_image(e, src);
    if (!t || !s) return 0;
    eng_image_changed(e, src);
    return draw_blt(&t->img, dst, &s->img, srect);
}

int32_t eng_image_draw_at(Engine *e, uint32_t target, uint32_t src, int32_t x, int32_t y) {
    /* Z:0x413f00: Z:0x414120 on the target, then render target +0x38 DrawAt (Z:0x40bef0). */
    CImage *t = eng_image(e, target), *s = eng_image(e, src);
    if (!t || !s) return 0;
    eng_image_changed(e, target);
    return draw_at(&t->img, &s->img, x, y);
}

int32_t eng_image_set_font(Engine *e, uint32_t img, uint32_t font) {
    /* Z:0x413f80: old font internal Release, new font internal AddRef. */
    CImage *im = eng_image(e, img);
    CFont *f = ENG_GET(e, font, CFont, OT_FONT);
    if (!im || !f) return 0;
    if (im->font) eng_release_int_h(e, im->font);
    im->font = font;
    eng_addref_int(&f->o);
    return 0;
}

int32_t eng_image_clear(Engine *e, uint32_t img, uint32_t rgb) {
    /* Z:0x413dd0: +0x20 = 0; delete the ZML link surfaces; Z:0x414120; render target Clear
     * (Z:0x40be30 FillRect of the whole image). rgb = 0xRRGGBB. */
    CImage *im = eng_image(e, img);
    if (!im) return 0;
    for (int32_t i = 0; i < im->links.n; i++) {
        CSurface *l = eng_surface(e, im->links.v[i]);
        if (!l) continue;
        if (l->parent) eng_surface_detach(e, l->parent, l->o.h);
        eng_obj_destroy(e, &l->o);
    }
    im->links.n = 0;
    eng_image_changed(e, img);
    draw_clear(&im->img, rgb_px(rgb >> 16, rgb >> 8, rgb));
    return 0;
}

int32_t eng_image_text(Engine *e, uint32_t img, const char *s, int32_t n, int32_t x, int32_t y) {
    /* Z:0x413c30: Z:0x414120, then render target DrawText (Z:0x40c110): nothing when len = 0 or
     * *str = 0; SetBkMode(T ? TRANSPARENT : OPAQUE); ExtTextOutA(x, y, ETO_CLIPPED, {0, 0, 800, 600}). */
    CImage *im = eng_image(e, img);
    if (!im) return 0;
    eng_image_changed(e, img);
    if (im->label[0] == 0 || rt_strlen(im->label) + (size_t)n + 2 < sizeof im->label) {
        size_t l = rt_strlen(im->label);
        if (l) im->label[l++] = ' ';
        for (int32_t i = 0; i < n && l + 1 < sizeof im->label; i++) im->label[l++] = s[i] ? s[i] : ' ';
        im->label[l] = 0;
    }
    if (n == 0 || s[0] == 0) return 0;
    CFont *f = ENG_GET(e, im->font, CFont, OT_FONT);
    if (!f || !f->ok) return 0;
    GdiTextState st;
    st.text_color = im->text_color;
    st.bk_color = im->bk_color;
    st.bk_mode = im->transparent ? GDI_TRANSPARENT : GDI_OPAQUE;
    st.smoothing = (uint8_t)e->smoothing;
    GdiRect rc = {0, 0, 800, 600};
    gdi_ext_text_out(&im->img, x, y, GDI_ETO_CLIPPED, &rc, s, n, &f->gdi, &st);
    return 0;
}

int32_t eng_image_measure(Engine *e, uint32_t img, uint32_t font, const char *s, int32_t n, int32_t *cx, int32_t *cy) {
    /* Z:0x414030 -> render target +0x60 (Z:0x40c2c0): GetTextExtentPoint32A with the given font. */
    (void)img;
    CFont *f = ENG_GET(e, font, CFont, OT_FONT);
    *cx = *cy = 0;
    if (!f || !f->ok) return 0;
    gdi_get_text_extent_point32(&f->gdi, s, n < 0 ? 0 : n, cx, cy);
    return 0;
}

/* ------------------------------------------------------------------ image sequences */
static void seq_recalc(Engine *e, CSeq *s) {
    /* Z:0x4171b0 CAnim::RecalcTimes: image i gets delay / 50 slots. */
    (void)e;
    uint32_t total = 0;
    for (int32_t i = 0; i < s->ndelays; i++) total += s->delays[i] / GIF_SLOT_MS;
    rt_free(s->slots);
    s->slots = NULL;
    s->nslots = 0;
    if (!total) return;
    s->slots = (uint8_t *)rt_malloc(total);
    if (!s->slots) rt_panic("engine: out of memory (slots)");
    int32_t r = gif_anim_slots(s->delays, (uint32_t)s->ndelays, s->slots, total);
    s->nslots = r < 0 ? 0 : r;
}

void eng_seq_add(Engine *e, uint32_t seq, uint32_t img, uint32_t delay) {
    /* Z:0x416e80: append the image (internal AddRef) and its delay; the image lists the sequence;
     * RecalcTimes. */
    CSeq *s = ENG_GET(e, seq, CSeq, OT_SEQ);
    CImage *im = eng_image(e, img);
    if (!s || !im) return;
    hl_push(&s->images, img);
    eng_addref_int(&im->o);
    if (s->ndelays >= s->cap_delays) {
        int32_t cap = s->cap_delays ? s->cap_delays * 2 : 4;
        uint32_t *d = (uint32_t *)rt_realloc(s->delays, (size_t)cap * 4u);
        if (!d) rt_panic("engine: out of memory (delays)");
        s->delays = d;
        s->cap_delays = cap;
    }
    s->delays[s->ndelays++] = delay;
    hl_push(&im->seqs, seq);
    seq_recalc(e, s);
}

uint32_t eng_seq_new_image(Engine *e, uint32_t img) {
    /* Z:0x416c30 */
    CSeq *s = (CSeq *)eng_obj_new(e, OT_SEQ, sizeof(CSeq));
    eng_seq_add(e, s->o.h, img, 0);
    return s->o.h;
}

uint32_t eng_seq_new_gif(Engine *e, const char *name) {
    /* Z:0x416d00 -> CImageSeq::LoadGIF Z:0x418d90 (decoder: gfx/gif.c). Each frame becomes a CImage
     * of the logical screen size (keyed when the GCE transparency flag is in force), added with
     * its delay; NETSCAPE2.0 sets the loop flag. */
    CSeq *s = (CSeq *)eng_obj_new(e, OT_SEQ, sizeof(CSeq));
    uint32_t h = s->o.h;
    uint32_t len = 0;
    const uint8_t *data = eng_resource(e, name, &len);
    if (!data) {
        rt_log("engine: Error loading file (%s) in CImageSeq::LoadGIF", name);
        return h;
    }
    GifInfo info;
    gif_decode(data, len, &info, NULL, 0, NULL, &e->gifwork);
    if (!info.nframes) {
        rt_log("engine: GIF %s: no frame (status %d)", name, info.status);
        return h;
    }
    uint32_t nf = info.nframes;
    size_t fp = (size_t)info.width * info.height;
    GifFrame *frames = (GifFrame *)rt_malloc(nf * sizeof *frames);
    uint32_t *pix = (uint32_t *)rt_malloc(nf * fp * 4u + 4u);
    if (!frames || !pix) rt_panic("engine: out of memory (GIF %s)", name);
    gif_decode(data, len, &info, frames, nf, pix, &e->gifwork);
    for (uint32_t i = 0; i < info.nframes && i < nf; i++) {
        uint32_t img = eng_image_new(e, info.width, info.height, frames[i].keyed != 0);
        CImage *im = eng_image(e, img);
        if (fp) rt_memcpy(im->img.px, pix + i * fp, fp * 4u);
        eng_seq_add(e, h, img, frames[i].delay_ms);
    }
    s = ENG_GET(e, h, CSeq, OT_SEQ);
    if (s) s->loop = info.loop;
    rt_free(frames);
    rt_free(pix);
    return h;
}

int32_t eng_seq_get(Engine *e, uint32_t seq, int32_t index, uint32_t *img) {
    /* Z:0x417060: error 4 only when index > count (index == count reads past the end; the port
     * returns 0 there). */
    CSeq *s = ENG_GET(e, seq, CSeq, OT_SEQ);
    *img = 0;
    if (!s) return 4;
    if (s->images.n < index) {
        rt_log("engine: Invalid Image (%d) passed to CImageSeq::GetImage (count %d)", index, s->images.n);
        return 4;
    }
    if (index >= 0 && index < s->images.n) *img = s->images.v[index];
    return 0;
}

void eng_dtor_seq(Engine *e, CSeq *s) {
    /* Z:0x416da0: each image forgets the sequence and loses an internal reference. */
    uint32_t h = s->o.h;
    for (int32_t i = 0; i < s->images.n; i++) {
        CImage *im = eng_image(e, s->images.v[i]);
        if (!im) continue;
        hl_remove(&im->seqs, h);
        eng_release_int(e, &im->o);
    }
    hl_free(&s->images);
    hl_free(&s->anims);
    rt_free(s->delays);
    rt_free(s->slots);
}

/* Z:0x4170d0 frame lookup for elapsed ms; *img = image; returns the AL result. */
static uint32_t seq_lookup(CSeq *s, uint32_t elapsed, uint32_t *img) {
    uint32_t slot = elapsed / GIF_SLOT_MS;
    uint32_t idx;
    uint32_t al;
    if (slot < (uint32_t)s->nslots) {
        idx = s->slots[slot];
        al = 1;
    } else if (s->loop && s->nslots) {
        idx = s->slots[slot % (uint32_t)s->nslots];
        al = 0;
    } else {
        idx = 0; /* non-looping past the end (and the original's division by 0 for loop without slots) */
        al = 1;
    }
    *img = (int32_t)idx < s->images.n ? s->images.v[idx] : 0;
    return al;
}

/* ------------------------------------------------------------------ animation players */
static void anim_invalidate(Engine *e, CAnim *a) {
    /* Z:0x417800 */
    for (int32_t i = 0; i < a->surfaces.n; i++) eng_surface_invalidate(e, a->surfaces.v[i]);
}

static uint32_t anim_clock(Engine *e, const CAnim *a) { return a->realtime ? eng_real_time(e) : eng_game_time(e); }

static void anim_tick(EngineTimer *t, const TimerEvent *ev) {
    /* Z:0x417850 -> Z:0x417750 */
    (void)ev;
    Engine *e = (Engine *)t->ctx;
    CAnim *a = (CAnim *)((uint8_t *)t - __builtin_offsetof(CAnim, timer));
    CSeq *s = ENG_GET(e, a->seq, CSeq, OT_SEQ);
    if (!s) return;
    uint32_t now = anim_clock(e, a);
    uint32_t old = a->img;
    uint32_t al = seq_lookup(s, now - a->start, &a->img);
    if (a->img != old) anim_invalidate(e, a);
    if (al && a->autodelete) eng_obj_destroy(e, &a->o);
}

uint32_t eng_anim_new(Engine *e, uint32_t seq) {
    /* Z:0x4173f0: set the sequence (Z:0x417580), own 50 ms timer, image 0. */
    CAnim *a = (CAnim *)eng_obj_new(e, OT_ANIM, sizeof(CAnim));
    CSeq *s = ENG_GET(e, seq, CSeq, OT_SEQ);
    if (s) {
        a->seq = seq;
        eng_addref_int(&s->o);
        hl_push(&s->anims, a->o.h);
    }
    timer_init(&a->timer, a->o.h, 0x32, anim_tick, e);
    eng_seq_get(e, seq, 0, &a->img);
    a->autodelete = 0;
    a->realtime = 0;
    return a->o.h;
}

int32_t eng_anim_start(Engine *e, uint32_t anim) {
    /* Z:0x4176f0: start = clock now; timer Start (no effect when running); image for t = 0. */
    CAnim *a = ENG_GET(e, anim, CAnim, OT_ANIM);
    if (!a) return 0;
    a->start = anim_clock(e, a);
    timer_start(&e->p->timers, &a->timer);
    CSeq *s = ENG_GET(e, a->seq, CSeq, OT_SEQ);
    uint32_t old = a->img;
    if (s) seq_lookup(s, 0, &a->img);
    if (a->img != old) anim_invalidate(e, a);
    return 0;
}

int32_t eng_anim_stop(Engine *e, uint32_t anim) {
    /* Z:0x417740 -> timer Stop Z:0x4135d0 (result 0) */
    CAnim *a = ENG_GET(e, anim, CAnim, OT_ANIM);
    if (a) timer_stop(&e->p->timers, &a->timer);
    return 0;
}

void eng_anim_set_frame(Engine *e, uint32_t anim, int32_t index) {
    /* Z:0x417560: invalidate first, then image = sequence image index. */
    CAnim *a = ENG_GET(e, anim, CAnim, OT_ANIM);
    if (!a) return;
    anim_invalidate(e, a);
    uint32_t img;
    eng_seq_get(e, a->seq, index, &img);
    a->img = img;
}

void eng_dtor_anim(Engine *e, CAnim *a) {
    /* Z:0x4174e0: the frame timer goes (its destructor removes a started timer), the sequence forgets
     * the player and loses an internal reference. */
    timer_release(&e->p->timers, &a->timer);
    CSeq *s = ENG_GET(e, a->seq, CSeq, OT_SEQ);
    if (s) {
        hl_remove(&s->anims, a->o.h);
        eng_release_int(e, &s->o);
    }
    hl_free(&a->surfaces);
}

/* ------------------------------------------------------------------ surfaces */
static void surface_add_anim(Engine *e, CSurface *s, uint32_t anim) {
    /* Z:0x414bc0 */
    CAnim *a = ENG_GET(e, anim, CAnim, OT_ANIM);
    hl_push(&s->anims, anim);
    if (a) {
        hl_push(&a->surfaces, s->o.h);
        eng_addref_int(&a->o);
    }
}

static CSurface *surface_alloc(Engine *e, uint32_t flags) {
    CSurface *s = (CSurface *)eng_obj_new(e, OT_SURFACE, sizeof(CSurface));
    s->visible = 1;
    s->cursor = -1;
    (void)flags;
    return s;
}

static void surface_finish(Engine *e, CSurface *s, uint32_t flags) {
    /* tail of Z:0x414190 / Z:0x414330 / Z:0x414470 */
    s->x = s->y = 0;
    s->parent = 0;
    s->visible = 1;
    if (flags & ENG_SURF_HOVER) {
        s->ch_enter = eng_channel_new(e, s->o.h, 8, false); /* event manager +0x0c */
        s->ch_leave = eng_channel_new(e, s->o.h, 9, false);
        s->cursor = 1; /* cursor manager +0x08(1): Hand */
    } else {
        s->ch_enter = s->ch_leave = 0;
        s->cursor = -1;
    }
    s->key = 0;
    s->nohit = 0;
}

uint32_t eng_surface_new_blank(Engine *e, int32_t w, int32_t h, uint32_t flags) {
    /* Z:0x414190: image (flags bit0 keyed), sequence, player. */
    CSurface *s = surface_alloc(e, flags);
    uint32_t sh = s->o.h;
    uint32_t img = eng_image_new(e, w, h, (flags & ENG_SURF_KEYED) != 0);
    uint32_t seq = eng_seq_new_image(e, img);
    uint32_t anim = eng_anim_new(e, seq);
    s = eng_surface(e, sh);
    s->anim = anim;
    surface_add_anim(e, s, anim);
    surface_finish(e, s, flags);
    return sh;
}

uint32_t eng_surface_new_gif(Engine *e, const char *name, uint32_t flags) {
    /* Z:0x414330 */
    CSurface *s = surface_alloc(e, flags);
    uint32_t sh = s->o.h;
    uint32_t seq = eng_seq_new_gif(e, name);
    uint32_t anim = eng_anim_new(e, seq);
    s = eng_surface(e, sh);
    s->anim = anim;
    surface_add_anim(e, s, anim);
    surface_finish(e, s, flags);
    return sh;
}

uint32_t eng_surface_new_anim(Engine *e, uint32_t anim, uint32_t flags) {
    /* Z:0x414470: shares the player (and its timer) with the other surfaces. */
    CSurface *s = surface_alloc(e, flags);
    s->anim = anim;
    surface_add_anim(e, s, anim);
    surface_finish(e, s, flags);
    return s->o.h;
}

uint32_t eng_surface_image(Engine *e, uint32_t sh) {
    /* Z:0x414c40 = current image of the current player (Z:0x417550) */
    CSurface *s = eng_surface(e, sh);
    if (!s) return 0;
    CAnim *a = ENG_GET(e, s->anim, CAnim, OT_ANIM);
    return a ? a->img : 0;
}

void eng_surface_size(Engine *e, uint32_t sh, int32_t *w, int32_t *h) {
    /* Z:0x414c70 */
    CImage *im = eng_image(e, eng_surface_image(e, sh));
    *w = im ? im->img.w : 0;
    *h = im ? im->img.h : 0;
}

void eng_surface_invalidate(Engine *e, uint32_t sh) {
    /* Z:0x414ef0: absolute rectangle (own position plus every parent position, image size). */
    CSurface *s = eng_surface(e, sh);
    if (!s) return;
    int32_t x = s->x, y = s->y, w, h;
    eng_surface_size(e, sh, &w, &h);
    for (CSurface *p = eng_surface(e, s->parent); p; p = eng_surface(e, p->parent)) {
        x += p->x;
        y += p->y;
    }
    dirty_add(e->dirty, x, y, w, h);
}

int32_t eng_surface_set_loc(Engine *e, uint32_t sh, int32_t x, int32_t y, uint32_t key) {
    /* Z:0x4146a0 */
    CSurface *s = eng_surface(e, sh);
    if (!s) return 0;
    if (key != s->key) {
        rt_log("engine: Invalid current key passed to protected surface in CSurface::SetLoc");
        return 0xb;
    }
    eng_surface_invalidate(e, sh);
    s->x = x;
    s->y = y;
    eng_surface_invalidate(e, sh);
    return 0; /* event manager +0x18 (Z:0x425010) does nothing */
}

int32_t eng_surface_set_visible(Engine *e, uint32_t sh, bool v, uint32_t key) {
    /* Z:0x414720 */
    CSurface *s = eng_surface(e, sh);
    if (!s) return 0;
    if (key != s->key) {
        rt_log("engine: Invalid current key passed to protected surface in CSurface::SetVisible");
        return 0xb;
    }
    s->visible = v ? 1u : 0u;
    eng_surface_invalidate(e, sh);
    return 0;
}

int32_t eng_surface_attach(Engine *e, uint32_t ph, uint32_t ch) {
    /* Z:0x414780: append (top of the z-order), parent, internal AddRef, invalidate parent and child. */
    CSurface *p = eng_surface(e, ph), *c = eng_surface(e, ch);
    if (!p || !c) return 0;
    hl_push(&p->children, ch);
    c->parent = ph;
    eng_addref_int(&c->o);
    eng_surface_invalidate(e, ph);
    eng_surface_invalidate(e, ch);
    return 0;
}

int32_t eng_surface_detach(Engine *e, uint32_t ph, uint32_t ch) {
    /* Z:0x4147f0: the child is invalidated after its parent was cleared, so the dirty rectangle has
     * no parent offset (quirk ENG_QUIRK_DETACH_DIRTY; off: invalidate at the real position). */
    CSurface *p = eng_surface(e, ph), *c = eng_surface(e, ch);
    if (!p || !c || !hl_remove(&p->children, ch)) {
        rt_log("engine: Error - unrecognized child surface passed to CSurface::DetachSurface");
        return 4;
    }
    if (!(e->p->quirks & ENG_QUIRK_DETACH_DIRTY)) eng_surface_invalidate(e, ch);
    c->parent = 0;
    if (e->p->quirks & ENG_QUIRK_DETACH_DIRTY) eng_surface_invalidate(e, ch);
    eng_release_int(e, &c->o);
    return 0;
}

void eng_surface_detach_all(Engine *e, uint32_t sh) {
    /* Z:0x414950 */
    for (;;) {
        CSurface *s = eng_surface(e, sh);
        if (!s || !s->children.n) return;
        uint32_t c = s->children.v[0];
        eng_surface_invalidate(e, c);
        eng_surface_detach(e, sh, c);
    }
}

int32_t eng_surface_protect(Engine *e, uint32_t sh, uint32_t old_key, uint32_t key) {
    /* Z:0x414ca0 */
    CSurface *s = eng_surface(e, sh);
    if (!s) return 0;
    if (old_key != s->key) return 0xb;
    s->key = key;
    return 0;
}

void eng_dtor_surface(Engine *e, CSurface *s) {
    uint32_t sh = s->o.h;
    if (s->is_button) {
        /* Z:0x419920: click, enter, leave and game listeners, then the 0xe channel */
        uint32_t l[5] = {s->l_click, s->l_enter, s->l_leave, s->l_game, s->ch_activate};
        for (int i = 0; i < 5; i++)
            if (l[i]) eng_release_int_h(e, l[i]);
        s = eng_surface(e, sh);
        if (!s) return;
    }
    /* Z:0x414560 */
    eng_surface_invalidate(e, sh);
    for (int32_t i = 0; i < s->anims.n; i++) {
        CAnim *a = ENG_GET(e, s->anims.v[i], CAnim, OT_ANIM);
        if (!a) continue;
        hl_remove(&a->surfaces, sh); /* Z:0x417620 */
        eng_release_int(e, &a->o);
    }
    if (s->ch_enter) eng_release_int_h(e, s->ch_enter);
    if (s->ch_leave) eng_release_int_h(e, s->ch_leave);
    eng_surface_detach_all(e, sh);
    eng_surface_destroyed(e, sh); /* event manager +0x1c (Z:0x424fb0) */
    hl_free(&s->children);
    hl_free(&s->anims);
}

static bool inside_strict(int32_t l, int32_t t, int32_t r, int32_t b, int32_t x, int32_t y) {
    /* Z:0x413640 */
    return l < x && x < r && t < y && y < b;
}

void eng_surface_hit(Engine *e, uint32_t sh, int32_t x, int32_t y, uint32_t *out) {
    /* Z:0x414a00: the surface rectangle in parent coordinates (strict test); children from the top of
     * the z-order, skipping +0x0c and invisible ones, with the rectangle (x, y, x + w + 1, y + h + 1);
     * recursion with child-local coordinates. */
    CSurface *s = eng_surface(e, sh);
    if (!s) return;
    int32_t w, h;
    eng_surface_size(e, sh, &w, &h);
    if (inside_strict(s->x, s->y, s->x + w, s->y + h, x, y)) *out = sh;
    for (int32_t i = s->children.n - 1; i >= 0; i--) {
        uint32_t ch = s->children.v[i];
        CSurface *c = eng_surface(e, ch);
        if (!c || c->nohit || !c->visible) continue;
        eng_surface_size(e, ch, &w, &h);
        if (inside_strict(c->x, c->y, c->x + w + 1, c->y + h + 1, x, y)) {
            *out = ch;
            eng_surface_hit(e, ch, x - c->x, y - c->y, out);
            return;
        }
    }
}

void eng_surface_render(Engine *e, uint32_t sh, uint32_t target, const DrawRect *clip, int32_t x, int32_t y,
                        int32_t px, int32_t py) {
    /* Z:0x414cd0 (checked in assembly): clip test with inclusive edges; the source rectangle uses
     * the parent position for the left and top cut (exact while the parent itself is not cut);
     * target 0 = root (draws nothing itself); a surface that touches no dirty rectangle returns with
     * its children; else the whole clipped surface is drawn with Z:0x413f30 (which adds dirty
     * rectangles for the source image during the pass). */
    CSurface *s = eng_surface(e, sh);
    if (!s) return;
    uint32_t img = eng_surface_image(e, sh);
    int32_t w, h;
    eng_surface_size(e, sh, &w, &h);
    int32_t ax = x + px, right = x + w + px, ay = y + py, bottom = y + h + py;
    if (ax > clip->r || right < clip->l || ay > clip->b || bottom < clip->t) return;
    DrawRect src = {0, 0, w, h};
    if (ax < clip->l) src.l = px - ax;
    if (ay < clip->t) src.t = py - ay;
    if (right > clip->r) src.r = clip->r - ax;
    if (bottom > clip->b) src.b = clip->b - ay;
    DrawRect dst = {imax(ax, clip->l), imax(ay, clip->t), imin(right, clip->r), imin(bottom, clip->b)};
    uint32_t tgt = img;
    if (target) {
        if (!dirty_intersects(e->dirty, &dst)) return;
        eng_image_draw(e, target, &dst, img, &src);
        tgt = target;
    }
    for (int32_t i = 0; i < s->children.n; i++) {
        uint32_t ch = s->children.v[i];
        CSurface *c = eng_surface(e, ch);
        if (!c || !c->visible) continue;
        eng_surface_render(e, ch, tgt, &dst, c->x, c->y, ax, ay);
        s = eng_surface(e, sh);
        if (!s) return;
    }
}

/* ------------------------------------------------------------------ buttons */
static uint32_t button_click(Engine *e, void *ctx, EvRec *rec) {
    /* Z:0x419a00 -> Z:0x4199a0: fire the 0xe channel with record word 2 = id; result 0. */
    (void)rec;
    uint32_t sh = (uint32_t)(uintptr_t)ctx;
    CSurface *s = eng_surface(e, sh);
    if (!s) return 0;
    EvRec r;
    rt_memset(&r, 0, sizeof r);
    r.w[2] = (uint32_t)s->button_id;
    eng_fire(e, s->ch_activate, &r);
    return 0;
}

static uint32_t button_hover(Engine *e, void *ctx, EvRec *rec, int32_t frame) {
    (void)rec;
    CSurface *s = eng_surface(e, (uint32_t)(uintptr_t)ctx);
    if (s) eng_anim_set_frame(e, s->anim, frame);
    return 0;
}
static uint32_t button_in(Engine *e, void *ctx, EvRec *rec) { return button_hover(e, ctx, rec, 1); }  /* Z:0x4199c0 */
static uint32_t button_out(Engine *e, void *ctx, EvRec *rec) { return button_hover(e, ctx, rec, 0); } /* Z:0x4199e0 */

uint32_t eng_button_new(Engine *e, uint32_t parent, uint32_t user, int32_t x, int32_t y, int32_t w, int32_t h,
                        uint32_t faces, int32_t index, int32_t id, uint32_t guest_cb, EngListenFn cfn, void *cctx) {
    /* Z:0x419730 */
    uint32_t sh = eng_surface_new_blank(e, w, h, ENG_SURF_KEYED | ENG_SURF_HOVER);
    CSurface *s = eng_surface(e, sh);
    s->is_button = 1;
    CImage *fi = eng_image(e, faces);
    if (fi) {
        size_t i = 0;
        for (; fi->label[i] && i + 1 < sizeof s->label; i++) s->label[i] = fi->label[i];
        s->label[i] = 0;
    }
    uint32_t img1 = eng_image_new_cell(e, faces, index, w, h);
    eng_image_draw_at(e, eng_surface_image(e, sh), img1, 0, 0);
    EngObj *o1 = eng_obj_get(e, img1, OT_IMAGE);
    if (o1) eng_obj_destroy(e, o1); /* scalar delete (not Release) */
    uint32_t img2 = eng_image_new_cell(e, faces, index + 1, w, h);
    s = eng_surface(e, sh);
    CAnim *a = ENG_GET(e, s->anim, CAnim, OT_ANIM);
    if (a) eng_seq_add(e, a->seq, img2, 0);
    eng_anim_set_frame(e, s->anim, 0);
    eng_surface_set_loc(e, sh, x, y, 0);
    s = eng_surface(e, sh);
    s->ch_activate = eng_channel_new(e, sh, 0xe, false);
    s->l_game = eng_listener_add(e, sh, 0xe, user, guest_cb, cfn, cctx);
    eng_listener_set_value(e, s->l_game, (uint32_t)id);
    s->l_click = eng_listener_add(e, sh, 10, sh, 0, button_click, (void *)(uintptr_t)sh);
    eng_listener_set_value(e, s->l_click, (uint32_t)id);
    s->l_enter = eng_listener_add(e, sh, 8, sh, 0, button_in, (void *)(uintptr_t)sh);
    eng_listener_set_value(e, s->l_enter, (uint32_t)id);
    s->l_leave = eng_listener_add(e, sh, 9, sh, 0, button_out, (void *)(uintptr_t)sh);
    eng_listener_set_value(e, s->l_leave, (uint32_t)id);
    eng_surface_attach(e, parent, sh);
    s = eng_surface(e, sh);
    s->button_id = id;
    return sh;
}
