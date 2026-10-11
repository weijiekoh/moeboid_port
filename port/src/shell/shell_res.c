/* Shell resources and drawing helpers (M5b). See shell_frame.h. */
#include "shell_frame.h"

/* ---- strings */

/* Unicode code points of the cp1252 bytes 0x80..0x9f (WideCharToMultiByte CP_ACP = 1252, inferred: the
 * kept strings are ASCII). */
static const uint16_t k_cp1252_hi[32] = {
    0x20ac, 0, 0x201a, 0x0192, 0x201e, 0x2026, 0x2020, 0x2021, 0x02c6, 0x2030, 0x0160, 0x2039, 0x0152, 0, 0x017d, 0,
    0, 0x2018, 0x2019, 0x201c, 0x201d, 0x2022, 0x2013, 0x2014, 0x02dc, 0x2122, 0x0161, 0x203a, 0x0153, 0, 0x017e, 0x0178};

static char to_cp1252(uint32_t c) {
    if (c < 0x80u || (c >= 0xa0u && c < 0x100u)) return (char)c;
    for (uint32_t i = 0; i < 32u; i++)
        if (k_cp1252_hi[i] == c) return (char)(0x80u + i);
    return '?';
}

int32_t sh_string_in(const ShellFrame *f, const char *module, uint32_t id, char *out, uint32_t cap) {
    /* LoadStringA(module, id, buf, cap): string block id / 16 + 1, entry id % 16 (u16 length, UTF-16
     * units); copies at most cap - 1 characters. */
    char key[32];
    uint32_t len = 0, pos = 0;
    if (!cap) return 0;
    out[0] = 0;
    rt_snprintf(key, sizeof key, "%s/STRING/%u", module, id / 16u + 1u);
    const uint8_t *d = f->ok ? mpack_find(&f->pack, key, &len) : NULL;
    if (!d) return 0;
    for (uint32_t i = 0; i < 16u && pos + 2u <= len; i++) {
        uint32_t n = (uint32_t)d[pos] | (uint32_t)d[pos + 1u] << 8;
        pos += 2u;
        if (i == id % 16u) {
            uint32_t k = 0;
            for (; k < n && k + 1u < cap && pos + 2u * k + 1u < len; k++)
                out[k] = to_cp1252((uint32_t)d[pos + 2u * k] | (uint32_t)d[pos + 2u * k + 1u] << 8);
            out[k] = 0;
            return (int32_t)k;
        }
        pos += 2u * n;
    }
    return 0;
}

int32_t sh_string(const ShellFrame *f, uint32_t id, char *out, uint32_t cap) {
    return sh_string_in(f, "zap", id, out, cap); /* platform +0x00 = Z:0x404b70 */
}

/* ---- splash bitmap */

int32_t sh_splash_decode(ShellFrame *f) {
    /* LoadBitmapA("img_splash") (Z:0x403f41): RT_BITMAP = BITMAPINFOHEADER, colour table, bits. IMG-SPLASH is
     * 400 x 240, 8 bpp, BI_RLE8, bottom-up (assets/ZapSpot.exe/decoded/BITMAP/IMG-SPLASH_0409.json). BitBlt
     * SRCCOPY on a 32-bit desktop gives the colour-table RGB (rendering.md 3.5). Pixels that the RLE stream
     * skips keep index 0 (inferred). */
    uint32_t len = 0;
    const uint8_t *d = f->ok ? mpack_find(&f->pack, "zap/BITMAP/IMG-SPLASH", &len) : NULL;
    if (!d || len < 40u) return -1;
    uint32_t hs = d[0] | (uint32_t)d[1] << 8 | (uint32_t)d[2] << 16 | (uint32_t)d[3] << 24;
    int32_t w = (int32_t)(d[4] | (uint32_t)d[5] << 8 | (uint32_t)d[6] << 16 | (uint32_t)d[7] << 24);
    int32_t h = (int32_t)(d[8] | (uint32_t)d[9] << 8 | (uint32_t)d[10] << 16 | (uint32_t)d[11] << 24);
    uint32_t bpp = d[14] | (uint32_t)d[15] << 8, comp = d[16] | (uint32_t)d[17] << 8;
    uint32_t used = d[32] | (uint32_t)d[33] << 8 | (uint32_t)d[34] << 16 | (uint32_t)d[35] << 24;
    if (w != SH_SPLASH_W || h != SH_SPLASH_H || bpp != 8u || comp != 1u) return -1;
    uint32_t ncol = used ? used : 256u;
    uint32_t pal_off = hs, bits = hs + 4u * ncol;
    if (bits > len) return -1;
    uint32_t pal[256];
    for (uint32_t i = 0; i < 256u; i++) {
        const uint8_t *q = d + pal_off + 4u * (i < ncol ? i : 0u); /* RGBQUAD: blue, green, red, reserved */
        pal[i] = IMG_RGB(q[2], q[1], q[0]);
    }
    for (int32_t i = 0; i < w * h; i++) f->splash_px[i] = pal[0];
    int32_t x = 0, y = 0; /* y counts rows from the bottom */
    uint32_t i = bits;
    while (i + 1u < len) {
        uint32_t a = d[i], b = d[i + 1u];
        i += 2u;
        if (a) { /* encoded run */
            for (uint32_t k = 0; k < a; k++, x++)
                if (x < w && y < h) f->splash_px[(h - 1 - y) * w + x] = pal[b];
        } else if (b == 0) { /* end of line */
            x = 0;
            y++;
        } else if (b == 1) { /* end of bitmap */
            break;
        } else if (b == 2) { /* delta */
            if (i + 1u >= len) break;
            x += d[i];
            y += d[i + 1u];
            i += 2u;
        } else { /* absolute run, padded to a word */
            for (uint32_t k = 0; k < b && i + k < len; k++, x++)
                if (x < w && y < h) f->splash_px[(h - 1 - y) * w + x] = pal[d[i + k]];
            i += (b + 1u) & ~1u;
        }
    }
    return 0;
}

/* ---- images */

Image *sh_img(ShellFrame *f, uint32_t img) { return img ? engine_image_pixels(f->p, img) : NULL; }

void sh_changed(ShellFrame *f, uint32_t img) {
    if (img) engine_image_changed(f->p, img); /* Z:0x414120 */
}

bool sh_image_new(Image *im, int32_t w, int32_t h, bool keyed) {
    /* render target Z:0x40b950: cleared to (255, 0, 255) when keyed, else (0, 0, 0) */
    im->w = w > 0 ? w : 0;
    im->h = h > 0 ? h : 0;
    im->stride = im->w;
    im->keyed = keyed ? 1u : 0u;
    size_t n = (size_t)im->w * (size_t)im->h;
    im->px = n ? (uint32_t *)rt_malloc(n * 4u) : NULL;
    if (n && !im->px) return false;
    draw_clear(im, keyed ? IMG_KEY : IMG_BLACK);
    return true;
}

void sh_image_free(Image *im) {
    rt_free(im->px);
    im->px = NULL;
    im->w = im->h = im->stride = 0;
}

uint32_t sh_gif(ShellFrame *f, const char *name, uint32_t flags, Image **out) {
    /* Z:0x414330 surface from a GIF resource; its image is frame 0 (Z:0x414c40) */
    uint32_t s = engine_surface_gif(f->p, name, flags);
    if (out) *out = s ? sh_img(f, engine_surface_image(f->p, s)) : NULL;
    return s;
}

void sh_release(ShellFrame *f, uint32_t *h) {
    if (*h) engine_release(f->p, *h);
    *h = 0;
}

void sh_rc_init(ShellFrame *f, ZmlContext *rc) {
    /* render context of a new image (Z:0x4138f0): Arial 18 regular, white, T = 1 */
    zml_context_init(rc, &f->fonts, f->smoothing);
}

/* ---- text */

int32_t sh_zml_image(ShellFrame *f, ZmlContext *rc, Image *dst, const char *text, int32_t x, int32_t y,
                     const GdiRect *rect) {
    /* DrawZML Z:0x413c90: len = strlen(text), rect NULL = whole target, flags 0. Hyperlinks: decision 8b
     * (verbatim, inert): drawn in the normal CHyperLink state (Z:0x4187f0) into the image; no link surface
     * and no click target. */
    (void)f;
    if (!dst || !text) return 0;
    return zml_draw(rc, dst, text, (int32_t)rt_strlen(text), x, y, rect, 0, NULL);
}

int32_t sh_zml(ShellFrame *f, ZmlContext *rc, uint32_t img, const char *text, int32_t x, int32_t y, const GdiRect *rect) {
    Image *dst = sh_img(f, img);
    int32_t r = sh_zml_image(f, rc, dst, text, x, y, rect);
    sh_changed(f, img);
    return r;
}

void sh_measure_rc(const ZmlContext *rc, const char *s, int32_t *cx, int32_t *cy) {
    /* Z:0x414050: render target MeasureText with the image's current font */
    *cx = 0;
    *cy = 0;
    if (rc->font.ok) gdi_get_text_extent_point32(&rc->font.gdi, s, (int32_t)rt_strlen(s), cx, cy);
}

void sh_measure_font(ShellFrame *f, const char *face, int32_t px, uint32_t style, const char *s, int32_t *cx,
                     int32_t *cy) {
    /* Z:0x414030 MeasureText(font, ...) with a font of the font subsystem (Z:0x426070) */
    ZmlFont font;
    zml_font_create(&font, &f->fonts, face, px, style);
    *cx = 0;
    *cy = 0;
    if (font.ok) gdi_get_text_extent_point32(&font.gdi, s, (int32_t)rt_strlen(s), cx, cy);
}
