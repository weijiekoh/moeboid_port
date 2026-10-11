/* GDI text output. See gdi_text.h. Engine call sites: Z:0x42a250 (GDI render target DrawText),
 * Z:0x40c110 (DirectDraw render target DrawText), Z:0x42a330 / Z:0x40c2c0 (MeasureText), fonts.md 4. */
#include "gdi_text.h"

int32_t gdi_font_select(GdiFont *f, const TextFonts *tf, const char *face, int32_t lf_height, int32_t lf_weight,
                        int32_t underline, int32_t strikeout)
{
    /* Z:0x427c10 builds the LOGFONT: lfHeight = -px, lfWeight 0 or 700 (fonts.md 3.1). */
    uint32_t weight = (lf_weight >= 550) ? 700u : 400u;
    const TextAtlas *m = 0;
    if (lf_height < 0) {
        m = text_fonts_find(tf, face, (uint32_t)(-lf_height), weight, ATLAS_MONO);
    } else if (lf_height > 0) {
        for (uint32_t i = 0; i < tf->n && !m; i++) {
            const TextAtlas *a = &tf->atlas[i];
            if (a->mode == ATLAS_MONO && a->weight == weight && a->tm_height == lf_height &&
                text_fonts_find(tf, face, a->px, weight, ATLAS_MONO) == a)
                m = a;
        }
    }
    if (!m) return -1;
    f->mono = m;
    f->gray = (m->flags & ATLAS_F_GASP_DOGRAY) ? text_fonts_find(tf, face, m->px, weight, ATLAS_GRAY) : 0;
    f->underline = underline ? 1u : 0u;
    f->strikeout = strikeout ? 1u : 0u;
    return 0;
}

const TextAtlas *gdi_font_atlas(const GdiFont *f, int32_t smoothing)
{
    return (smoothing && f->gray) ? f->gray : f->mono;
}

void gdi_get_text_metrics(const GdiFont *f, GdiTextMetrics *tm)
{
    const TextAtlas *a = f->mono;
    tm->tmHeight = a->tm_height;
    tm->tmAscent = a->tm_ascent;
    tm->tmDescent = a->tm_descent;
    tm->tmInternalLeading = a->tm_int_leading;
    tm->tmExternalLeading = a->tm_ext_leading;
    tm->tmAveCharWidth = a->tm_ave_width;
    tm->tmMaxCharWidth = a->tm_max_width;
}

void gdi_get_text_extent_point32(const GdiFont *f, const char *s, int32_t n, int32_t *cx, int32_t *cy)
{
    int32_t w = 0;
    TextGlyph g;
    for (int32_t i = 0; i < n; i++) {
        atlas_glyph(f->mono, (uint8_t)s[i], &g);
        w += g.adv;
    }
    *cx = w;
    *cy = f->mono->tm_height;
}

static int32_t imax(int32_t a, int32_t b) { return a > b ? a : b; }
static int32_t imin(int32_t a, int32_t b) { return a < b ? a : b; }

static void fill(Image *dst, const GdiRect *clip, int32_t l, int32_t t, int32_t r, int32_t b, uint32_t c)
{
    l = imax(l, clip->left);
    t = imax(t, clip->top);
    r = imin(r, clip->right);
    b = imin(b, clip->bottom);
    for (int32_t y = t; y < b; y++) {
        uint32_t *row = dst->px + y * dst->stride;
        for (int32_t x = l; x < r; x++) row[x] = c;
    }
}

static uint32_t blend(uint32_t d, uint32_t t, uint32_t v)
{
    uint32_t iv = 16u - v;
    uint32_t r = (IMG_R(d) * iv + IMG_R(t) * v + 8u) >> 4;
    uint32_t g = (IMG_G(d) * iv + IMG_G(t) * v + 8u) >> 4;
    uint32_t b = (IMG_B(d) * iv + IMG_B(t) * v + 8u) >> 4;
    return IMG_RGB(r, g, b);
}

int32_t gdi_ext_text_out(Image *dst, int32_t x, int32_t y, uint32_t options, const GdiRect *rc,
                         const char *s, int32_t n, const GdiFont *f, const GdiTextState *st)
{
    GdiRect clip = { 0, 0, dst->w, dst->h };
    if (rc && (options & GDI_ETO_CLIPPED)) {
        clip.left = imax(clip.left, rc->left);
        clip.top = imax(clip.top, rc->top);
        clip.right = imin(clip.right, rc->right);
        clip.bottom = imin(clip.bottom, rc->bottom);
    }
    GdiRect img = { 0, 0, dst->w, dst->h };
    uint32_t bk = st->bk_color | 0xff000000u, fg = st->text_color | 0xff000000u;
    if (rc && (options & GDI_ETO_OPAQUE)) fill(dst, &img, rc->left, rc->top, rc->right, rc->bottom, bk);
    if (n <= 0) return 1;
    const TextAtlas *a = gdi_font_atlas(f, st->smoothing);
    int32_t cx, cy;
    gdi_get_text_extent_point32(f, s, n, &cx, &cy);
    if (st->bk_mode == GDI_OPAQUE) fill(dst, &clip, x, y, x + cx, y + cy, bk);
    int32_t base = y + a->tm_ascent;   /* baseline row: first row below the baseline */
    int32_t pen = x;
    TextGlyph g;
    for (int32_t i = 0; i < n; i++) {
        atlas_glyph(a, (uint8_t)s[i], &g);
        int32_t gx = pen + g.left, gy = base - g.top;
        int32_t r0 = imax(0, clip.top - gy), r1 = imin((int32_t)g.h, clip.bottom - gy);
        int32_t c0 = imax(0, clip.left - gx), c1 = imin((int32_t)g.w, clip.right - gx);
        for (int32_t r = r0; r < r1; r++) {
            const uint8_t *cv = g.cov + (uint32_t)r * g.w;
            uint32_t *row = dst->px + (gy + r) * dst->stride;
            for (int32_t c = c0; c < c1; c++) {
                uint32_t v = cv[c];
                if (!v) continue;
                if (a->mode == ATLAS_MONO || v >= 16u) row[gx + c] = fg;
                else row[gx + c] = blend(row[gx + c], fg, v);
            }
        }
        pen += g.adv;
    }
    if (f->underline) {
        int32_t t = base + a->ul_offset;
        fill(dst, &clip, x, t, x + cx, t + a->ul_thickness, fg);
    }
    if (f->strikeout) {
        int32_t t = base - a->so_offset;
        fill(dst, &clip, x, t, x + cx, t + a->so_thickness, fg);
    }
    return 1;
}
