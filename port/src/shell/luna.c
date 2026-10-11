/* Windows XP Luna non-client frame (see luna.h). Workstream LUNA, phase 2.
 *
 * Reference: this file copies no ZapSpot routine. It models uxtheme (XP SP3) drawing of the
 * Window class parts of fonts/luna.msstyles NORMALBLUE_INI. Values from the file are verified;
 * every drawing rule below that is not in the file is marked "inferred" (no Windows ground truth,
 * decision 4c). */
#include "luna.h"

static uint32_t rd16(const uint8_t *p) { return (uint32_t)p[0] | ((uint32_t)p[1] << 8); }
static uint32_t rd32(const uint8_t *p) {
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}
static int16_t rds16(const uint8_t *p) { return (int16_t)(uint16_t)rd16(p); }

/* Blob layout: port/tools/mkluna.py docstring. */
#define HDR_SIZE 32u
#define COLOR_SIZE 8u
#define METRIC_SIZE 8u
#define PART_SIZE 48u
#define IMAGE_SIZE 16u

static bool in_blob(uint32_t len, uint32_t off, uint32_t n, uint32_t size) {
    uint64_t end = (uint64_t)off + (uint64_t)n * size;
    return end <= len;
}

int luna_load(LunaTheme *t, const uint8_t *blob, uint32_t len) {
    *t = (LunaTheme){0};
    for (int32_t i = 0; i < LUNA_COLOR_COUNT; i++) t->color_src[i] = LUNA_SRC_NONE;
    for (int32_t i = 0; i < LUNA_METRIC_COUNT; i++) t->metric_src[i] = LUNA_SRC_NONE;
    if (len < HDR_SIZE) return LUNA_E_SHORT;
    if (blob[0] != 'L' || blob[1] != 'U' || blob[2] != 'N' || blob[3] != 'A') return LUNA_E_MAGIC;
    if (rd16(blob + 4) != 1 || rd16(blob + 6) != HDR_SIZE) return LUNA_E_VERSION;
    uint32_t nc = rd16(blob + 8), nm = rd16(blob + 10), np = rd16(blob + 12), ni = rd16(blob + 14);
    uint32_t oc = rd32(blob + 16), om = rd32(blob + 20), op = rd32(blob + 24), oi = rd32(blob + 28);
    if (!in_blob(len, oc, nc, COLOR_SIZE) || !in_blob(len, om, nm, METRIC_SIZE) || !in_blob(len, op, np, PART_SIZE) ||
        !in_blob(len, oi, ni, IMAGE_SIZE) || ni > LUNA_IMAGE_MAX)
        return LUNA_E_RANGE;
    for (uint32_t i = 0; i < nc; i++) {
        const uint8_t *p = blob + oc + i * COLOR_SIZE;
        uint32_t id = rd16(p);
        if (id >= LUNA_COLOR_COUNT) return LUNA_E_RANGE;
        t->color[id] = ((uint32_t)p[4] << 16) | ((uint32_t)p[5] << 8) | p[6];
        t->color_src[id] = p[2];
    }
    for (uint32_t i = 0; i < nm; i++) {
        const uint8_t *p = blob + om + i * METRIC_SIZE;
        uint32_t id = rd16(p);
        if (id >= LUNA_METRIC_COUNT) return LUNA_E_RANGE;
        t->metric[id] = (int32_t)rd32(p + 4);
        t->metric_src[id] = p[2];
    }
    for (uint32_t i = 0; i < ni; i++) {
        const uint8_t *p = blob + oi + i * IMAGE_SIZE;
        uint32_t w = rd16(p), h = rd16(p + 2), off = rd32(p + 8), n = rd32(p + 12);
        if (w == 0 || h == 0 || n != w * h * 4u || !in_blob(len, off, n, 1)) return LUNA_E_RANGE;
        t->image[i] = (LunaBitmap){blob + off, (uint16_t)w, (uint16_t)h, (uint16_t)rd16(p + 4)};
    }
    t->n_images = (uint16_t)ni;
    for (uint32_t i = 0; i < np; i++) {
        const uint8_t *p = blob + op + i * PART_SIZE;
        uint32_t id = rd16(p);
        if (id == 0 || id >= LUNA_PART_COUNT) return LUNA_E_PART;
        LunaPart *q = &t->part[id];
        q->image = (uint16_t)rd16(p + 2);
        q->glyph = (uint16_t)rd16(p + 4);
        q->image_count = p[6];
        q->glyph_count = p[7];
        q->sizing_type = p[8];
        q->layout = p[9];
        q->flags = p[10];
        q->offset_type = p[11];
        for (int32_t k = 0; k < 4; k++) {
            q->sizing[k] = rds16(p + 12 + 2 * k);
            q->content[k] = rds16(p + 20 + 2 * k);
            q->caption[k] = rds16(p + 28 + 2 * k);
        }
        q->offset[0] = rds16(p + 36);
        q->offset[1] = rds16(p + 38);
        q->fill = ((uint32_t)p[40] << 16) | ((uint32_t)p[41] << 8) | p[42];
        if (q->image >= ni || q->image_count == 0) return LUNA_E_PART;
        const LunaBitmap *b = &t->image[q->image];
        if ((q->layout == 0 ? b->h : b->w) % q->image_count) return LUNA_E_PART;
        if (q->glyph != 0xFFFF) {
            if (q->glyph >= ni || q->glyph_count == 0) return LUNA_E_PART;
            const LunaBitmap *g = &t->image[q->glyph];
            if ((q->layout == 0 ? g->h : g->w) % q->glyph_count) return LUNA_E_PART;
        }
        q->present = true;
    }
    static const int32_t need[] = {LUNA_PART_CAPTION, LUNA_PART_FRAMELEFT, LUNA_PART_FRAMERIGHT,
                                   LUNA_PART_FRAMEBOTTOM, LUNA_PART_CLOSEBUTTON};
    for (uint32_t i = 0; i < RT_COUNTOF(need); i++)
        if (!t->part[need[i]].present) return LUNA_E_PART;
    if (t->metric_src[LUNA_M_CAPTION_BAR_HEIGHT] == LUNA_SRC_NONE || t->color_src[LUNA_COLOR_3DFACE] == LUNA_SRC_NONE)
        return LUNA_E_RANGE;
    t->loaded = true;
    return LUNA_OK;
}

uint32_t luna_color(const LunaTheme *t, int32_t index, uint8_t *src) {
    if (index < 0 || index >= LUNA_COLOR_COUNT || t->color_src[index] == LUNA_SRC_NONE) {
        if (src) *src = LUNA_SRC_NONE;
        return 0;
    }
    if (src) *src = t->color_src[index];
    return t->color[index];
}

uint32_t luna_pixel(const LunaTheme *t, int32_t index) {
    uint32_t c = luna_color(t, index, NULL);
    return IMG_RGB(c >> 16, (c >> 8) & 0xffu, c & 0xffu);
}

int32_t luna_metric(const LunaTheme *t, int32_t id) {
    if (id < 0 || id >= LUNA_METRIC_COUNT) return 0;
    return t->metric[id];
}

int32_t luna_font_px(int32_t points) { return (points * 96 + 36) / 72; /* MulDiv rounding, points > 0 */ }

/* ---- pixels ---- */

/* Source over destination. Alpha 255: copy; alpha 0: keep (colour key, window region). Partial alpha:
 * inferred uxtheme rule for 32-bit images: premultiply at load, then GDI AlphaBlend with AC_SRC_ALPHA,
 * dst = src * a / 255 + dst * (255 - a) / 255, each term rounded to nearest. */
static void put_px(uint32_t *d, const uint8_t *s) {
    uint32_t a = s[3];
    if (a == 0) return;
    if (a == 255) {
        *d = IMG_RGB(s[0], s[1], s[2]);
        return;
    }
    uint32_t ia = 255 - a, p = *d;
    uint32_t r = (s[0] * a + 127) / 255 + (IMG_R(p) * ia + 127) / 255;
    uint32_t g = (s[1] * a + 127) / 255 + (IMG_G(p) * ia + 127) / 255;
    uint32_t b = (s[2] * a + 127) / 255 + (IMG_B(p) * ia + 127) / 255;
    *d = IMG_RGBA(r, g, b, a + (IMG_A(p) * ia + 127) / 255);
}

static void fill_rect(Image *dst, int32_t x, int32_t y, int32_t w, int32_t h, uint32_t pixel) {
    int32_t x0 = RT_MAX(x, 0), y0 = RT_MAX(y, 0);
    int32_t x1 = RT_MIN(x + w, dst->w), y1 = RT_MIN(y + h, dst->h);
    for (int32_t yy = y0; yy < y1; yy++) {
        uint32_t *d = dst->px + (size_t)yy * (size_t)dst->stride;
        for (int32_t xx = x0; xx < x1; xx++) d[xx] = pixel;
    }
}

/* Nine-grid source coordinate along one axis (inferred model of the XP nine-grid stretch,
 * DrvNineGrid/GdiDrawStream, nearest neighbour):
 *  - destination margins = source margins m0, m1; when dst_len < m0 + m1 they shrink in proportion:
 *    a = dst_len * m0 / (m0 + m1) (floor), b = dst_len - a;
 *  - inside a segment, source = segment start + d * src_seg / dst_seg (floor); for tile in the middle
 *    segment, source = start + d mod src_seg. */
static int32_t grid_map(int32_t d, int32_t dst_len, int32_t src_len, int32_t m0, int32_t m1, int32_t sizing) {
    if (sizing == LUNA_SIZING_TRUESIZE) return d < src_len ? d : src_len - 1;
    int32_t a = m0, b = m1;
    if (a + b > dst_len) {
        a = (m0 + m1) > 0 ? dst_len * m0 / (m0 + m1) : 0;
        b = dst_len - a;
    }
    if (d < a) return d * m0 / a;
    if (d >= dst_len - b) {
        int32_t e = d - (dst_len - b);
        return src_len - m1 + e * m1 / b;
    }
    int32_t ms = src_len - m0 - m1, md = dst_len - a - b, e = d - a;
    if (ms <= 0) return m0 < src_len ? m0 : src_len - 1;
    if (sizing == LUNA_SIZING_TILE) return m0 + e % ms;
    return m0 + e * ms / md;
}

/* Blit state image `state` of bitmap b (count images in `layout`) into r with the margins m. */
static void blit_grid(Image *dst, const LunaBitmap *b, int32_t count, int32_t layout, int32_t state,
                      const int16_t m[4], int32_t sizing, const LunaRect *r) {
    if (r->w <= 0 || r->h <= 0 || count <= 0 || state < 0 || state >= count) return;
    int32_t sw = layout == 0 ? b->w : b->w / count;
    int32_t sh = layout == 0 ? b->h / count : b->h;
    int32_t sx0 = layout == 0 ? 0 : state * sw;
    int32_t sy0 = layout == 0 ? state * sh : 0;
    int32_t x0 = RT_MAX(r->x, 0), y0 = RT_MAX(r->y, 0);
    int32_t x1 = RT_MIN(r->x + r->w, dst->w), y1 = RT_MIN(r->y + r->h, dst->h);
    if (sizing == LUNA_SIZING_TRUESIZE) {
        x1 = RT_MIN(x1, r->x + sw);
        y1 = RT_MIN(y1, r->y + sh);
    }
    for (int32_t yy = y0; yy < y1; yy++) {
        int32_t sy = sy0 + grid_map(yy - r->y, r->h, sh, m[2], m[3], sizing);
        const uint8_t *srow = b->rgba + (size_t)sy * b->w * 4;
        uint32_t *d = dst->px + (size_t)yy * (size_t)dst->stride;
        for (int32_t xx = x0; xx < x1; xx++) {
            int32_t sx = sx0 + grid_map(xx - r->x, r->w, sw, m[0], m[1], sizing);
            put_px(d + xx, srow + (size_t)sx * 4);
        }
    }
}

void luna_draw_part(const LunaTheme *t, Image *dst, int32_t part_id, bool glyph, int32_t state, const LunaRect *r) {
    if (!t->loaded || part_id <= 0 || part_id >= LUNA_PART_COUNT || !t->part[part_id].present) return;
    const LunaPart *p = &t->part[part_id];
    if (!glyph) {
        blit_grid(dst, &t->image[p->image], p->image_count, p->layout, state, p->sizing, p->sizing_type, r);
        return;
    }
    if (p->glyph == 0xFFFF) return;
    /* Glyph: true size, centred in r (inferred: content rectangle = part rect minus ContentMargins;
     * the selected glyph fits, so UniformSizing never scales it). */
    const LunaBitmap *g = &t->image[p->glyph];
    int32_t gw = p->layout == 0 ? g->w : g->w / p->glyph_count;
    int32_t gh = p->layout == 0 ? g->h / p->glyph_count : g->h;
    LunaRect gr = {r->x + (r->w - gw) / 2, r->y + (r->h - gh) / 2, gw, gh};
    static const int16_t none[4] = {0, 0, 0, 0};
    blit_grid(dst, g, p->glyph_count, p->layout, state, none, LUNA_SIZING_TRUESIZE, &gr);
}

/* ---- window ---- */

void luna_geom(const LunaTheme *t, int32_t client_w, int32_t client_h, bool close_button, LunaGeom *g) {
    const LunaPart *cap = &t->part[LUNA_PART_CAPTION];
    int32_t frame = LUNA_DLG_FRAME;
    /* SM_CYCAPTION = iCaptionHeight + SM_CYBORDER (inferred win32k rule); iCaptionHeight =
     * [SysMetrics] CaptionBarHeight (verified INI value 25). */
    int32_t cy_caption = luna_metric(t, LUNA_M_CAPTION_BAR_HEIGHT) + 1;
    *g = (LunaGeom){0};
    g->frame = frame;
    g->caption_h = cy_caption;
    g->top = frame + cy_caption;
    g->win_w = client_w + 2 * frame;
    g->win_h = client_h + g->top + frame;
    g->client = (LunaRect){frame, g->top, client_w, client_h};
    g->caption = (LunaRect){0, 0, g->win_w, g->top};
    int32_t text_right = g->win_w - frame;
    if (close_button) {
        /* [Window.CloseButton] OffsetType = TopRight, Offset = -25, 5 (verified INI): the button's
         * top-left corner relative to the window's top-right corner (inferred meaning). Size = one
         * state of BLUE_CLOSEBUTTON_BMP (21x21, verified) at 96 dpi (inferred: no scaling). */
        const LunaPart *cb = &t->part[LUNA_PART_CLOSEBUTTON];
        const LunaBitmap *b = &t->image[cb->image];
        int32_t bw = cb->layout == 0 ? b->w : b->w / cb->image_count;
        int32_t bh = cb->layout == 0 ? b->h / cb->image_count : b->h;
        int32_t bx = cb->offset_type == 1 ? cb->offset[0] : g->win_w + cb->offset[0];
        g->close = (LunaRect){bx, cb->offset[1], bw, bh};
        text_right = bx;
    }
    /* Caption text: [Window.Caption] CaptionMargins = 4, 3, 0, 0 (verified INI) applied inside the
     * caption bar below the top border; no icon (DS_MODALFRAME windows have none). Inferred layout. */
    int32_t tl = frame + cap->caption[0];
    int32_t tr = text_right - cap->caption[1];
    g->text = (LunaRect){tl, frame + cap->caption[2], RT_MAX(tr - tl, 0), cy_caption - cap->caption[2] - cap->caption[3]};
}

int32_t luna_fit_ellipsis(const GdiFont *f, const char *s, int32_t n, int32_t max_w, char *out, int32_t out_size) {
    int32_t cx, cy;
    if (n > out_size) n = out_size;
    gdi_get_text_extent_point32(f, s, n, &cx, &cy);
    if (cx <= max_w) {
        for (int32_t i = 0; i < n; i++) out[i] = s[i];
        return n;
    }
    /* DT_END_ELLIPSIS (inferred rule): drop characters from the end until prefix + "..." fits; when
     * not even "..." fits, return "..." and let the clip cut it. */
    int32_t ell, k = RT_MIN(n, out_size - 3);
    gdi_get_text_extent_point32(f, "...", 3, &ell, &cy);
    while (k > 0) {
        gdi_get_text_extent_point32(f, s, k, &cx, &cy);
        if (cx + ell <= max_w) break;
        k--;
    }
    for (int32_t i = 0; i < k; i++) out[i] = s[i];
    out[k] = out[k + 1] = out[k + 2] = '.';
    return k + 3;
}

void luna_draw_window(const LunaTheme *t, Image *dst, int32_t x, int32_t y, const LunaWindow *w,
                      const GdiFont *caption_font, uint8_t smoothing, LunaGeom *gout) {
    if (!t->loaded) return;
    LunaGeom g;
    luna_geom(t, w->client_w, w->client_h, w->close_button, &g);
    if (gout) *gout = g;
    int32_t st = w->active ? 0 : 1; /* FS_ACTIVE / CS_ACTIVE = image 1, *_INACTIVE = image 2 */

    fill_rect(dst, x + g.client.x, y + g.client.y, g.client.w, g.client.h, luna_pixel(t, LUNA_COLOR_3DFACE));

    /* Caption covers the top border and the caption bar (verified: image height 29 = g.top). */
    LunaRect r = {x, y, g.win_w, g.top};
    luna_draw_part(t, dst, LUNA_PART_CAPTION, false, st, &r);
    /* Left and right frame between caption and bottom frame; bottom frame across the full width
     * (its 5 px SizingMargins hold the corners). Inferred placement. */
    int32_t side_h = g.win_h - g.top - g.frame;
    r = (LunaRect){x, y + g.top, g.frame, side_h};
    luna_draw_part(t, dst, LUNA_PART_FRAMELEFT, false, st, &r);
    r = (LunaRect){x + g.win_w - g.frame, y + g.top, g.frame, side_h};
    luna_draw_part(t, dst, LUNA_PART_FRAMERIGHT, false, st, &r);
    r = (LunaRect){x, y + g.win_h - g.frame, g.win_w, g.frame};
    luna_draw_part(t, dst, LUNA_PART_FRAMEBOTTOM, false, st, &r);

    if (w->close_button) {
        const LunaPart *cb = &t->part[LUNA_PART_CLOSEBUTTON];
        int32_t s = (w->close_state >= LUNA_BTN_NORMAL && w->close_state <= LUNA_BTN_DISABLED) ? w->close_state - 1 : 0;
        if (!w->active && cb->image_count >= 8) s += 4;
        r = (LunaRect){x + g.close.x, y + g.close.y, g.close.w, g.close.h};
        luna_draw_part(t, dst, LUNA_PART_CLOSEBUTTON, false, s, &r);
        LunaRect c = {r.x + cb->content[0], r.y + cb->content[2], r.w - cb->content[0] - cb->content[1],
                      r.h - cb->content[2] - cb->content[3]};
        luna_draw_part(t, dst, LUNA_PART_CLOSEBUTTON, true, s, &c);
    }

    if (caption_font && w->caption) {
        /* DrawThemeText(DT_SINGLELINE | DT_LEFT | DT_VCENTER | DT_END_ELLIPSIS) in the caption text
         * rectangle (inferred flags). Colours: COLOR_CAPTIONTEXT / COLOR_INACTIVECAPTIONTEXT
         * ([SysMetrics]; inferred: uxtheme uses them because [Window.Caption] has no TextColor).
         * Shadow: TextShadowType = Single only in [Window.Caption(active)]; TextShadowColor and
         * TextShadowOffset from [Window] (verified INI); shadow drawn first (inferred). */
        char buf[256];
        int32_t len = w->caption_len >= 0 ? w->caption_len : (int32_t)rt_strlen(w->caption);
        int32_t n = luna_fit_ellipsis(caption_font, w->caption, len, g.text.w, buf, (int32_t)sizeof buf);
        GdiTextMetrics tm;
        gdi_get_text_metrics(caption_font, &tm);
        int32_t tx = x + g.text.x, ty = y + g.text.y + (g.text.h - tm.tmHeight) / 2;
        GdiRect rc = {tx, y + g.text.y, tx + g.text.w, y + g.text.y + g.text.h};
        GdiTextState ts = {0, 0, GDI_TRANSPARENT, smoothing};
        if (luna_metric(t, w->active ? LUNA_M_SHADOW_ACTIVE : LUNA_M_SHADOW_INACTIVE) != 0) {
            int32_t dx = luna_metric(t, LUNA_M_SHADOW_DX), dy = luna_metric(t, LUNA_M_SHADOW_DY);
            GdiRect rs = {rc.left + dx, rc.top + dy, rc.right + dx, rc.bottom + dy};
            ts.text_color = luna_pixel(t, LUNA_COLOR_CAPTION_SHADOW);
            gdi_ext_text_out(dst, tx + dx, ty + dy, GDI_ETO_CLIPPED, &rs, buf, n, caption_font, &ts);
        }
        ts.text_color = luna_pixel(t, w->active ? LUNA_COLOR_CAPTIONTEXT : LUNA_COLOR_INACTIVECAPTIONTEXT);
        gdi_ext_text_out(dst, tx, ty, GDI_ETO_CLIPPED, &rc, buf, n, caption_font, &ts);
    }
}
