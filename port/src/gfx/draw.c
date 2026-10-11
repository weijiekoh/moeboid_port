/* Draw operations of the engine render target (M4). See draw.h. */
#include "draw.h"

static inline int32_t imin(int32_t a, int32_t b) { return a < b ? a : b; }
static inline int32_t imax(int32_t a, int32_t b) { return a > b ? a : b; }

static inline void put(Image *d, int32_t x, int32_t y, uint32_t c) {
    if (x >= 0 && y >= 0 && x < d->w && y < d->h) d->px[(size_t)y * (size_t)d->stride + (size_t)x] = c;
}

void draw_fill_rect(Image *dst, int32_t l, int32_t t, int32_t r, int32_t b, uint32_t color) {
    /* Z:0x40bc60: FillRect only when top <= bottom and left <= right; GDI clips to the bitmap. */
    if (t > b || l > r) return;
    l = imax(l, 0);
    t = imax(t, 0);
    r = imin(r, dst->w);
    b = imin(b, dst->h);
    for (int32_t y = t; y < b; y++) {
        uint32_t *row = dst->px + (size_t)y * (size_t)dst->stride;
        for (int32_t x = l; x < r; x++) row[x] = color;
    }
}

void draw_clear(Image *dst, uint32_t color) {
    /* Z:0x40be30: FillRect(0, 0, width, height) with a new solid brush. */
    draw_fill_rect(dst, 0, 0, dst->w, dst->h, color);
}

/* GDI LineTo with a cosmetic 1-pixel pen: every pixel from (x1, y1) towards (x2, y2), the end point
 * excluded. Horizontal and vertical lines: exact span (verified rule, rendering.md 6.1).
 * Other slopes: Bresenham (inferred; GDI tie-breaking can differ; the game draws none). */
static void gdi_line(Image *d, int32_t x1, int32_t y1, int32_t x2, int32_t y2, uint32_t c) {
    int32_t dx = x2 - x1, dy = y2 - y1;
    int32_t sx = dx < 0 ? -1 : 1, sy = dy < 0 ? -1 : 1;
    int32_t ax = dx < 0 ? -dx : dx, ay = dy < 0 ? -dy : dy;
    if (ay == 0) {
        for (int32_t x = x1; x != x2; x += sx) put(d, x, y1, c);
        return;
    }
    if (ax == 0) {
        for (int32_t y = y1; y != y2; y += sy) put(d, x1, y, c);
        return;
    }
    int32_t x = x1, y = y1;
    if (ax >= ay) {
        int32_t e = 2 * ay - ax;
        for (int32_t i = 0; i < ax; i++) {
            put(d, x, y, c);
            if (e > 0) {
                y += sy;
                e -= 2 * ax;
            }
            e += 2 * ay;
            x += sx;
        }
    } else {
        int32_t e = 2 * ax - ay;
        for (int32_t i = 0; i < ay; i++) {
            put(d, x, y, c);
            if (e > 0) {
                x += sx;
                e -= 2 * ay;
            }
            e += 2 * ax;
            y += sy;
        }
    }
}

void draw_line(Image *dst, int32_t x1, int32_t y1, int32_t x2, int32_t y2, uint32_t color) {
    /* Z:0x40baf0 (render target +0x04): +4 = width, +8 = height. */
    int32_t W = dst->w, H = dst->h;
    if (x1 == x2) {
        if (x1 < 0 || W < x1) return;
        if (y1 < y2) {
            if (y1 < 1) y1 = 0;
            if (H <= y2) y2 = H;
        } else {
            if (y2 < 1) y2 = 0;
            if (H <= y1) y1 = H;
        }
    } else {
        if (y1 < 0 || H < y1) return;
        if (x1 < x2) {
            if (x1 < 1) x1 = 0;
            if (W <= x2) x2 = W;
        } else {
            if (x2 < 1) x2 = 0;
            if (W <= x1) x1 = W;
        }
    }
    gdi_line(dst, x1, y1, x2, y2, color); /* MoveToEx(x1, y1); LineTo(x2, y2) */
}

void draw_frame_rect(Image *dst, int32_t x1, int32_t y1, int32_t x2, int32_t y2, uint32_t color) {
    /* Z:0x40bc00 */
    draw_line(dst, x1, y1, x2, y1, color);
    draw_line(dst, x2, y1, x2, y2, color);
    draw_line(dst, x2, y2, x1, y2, color);
    draw_line(dst, x1, y2, x1, y1, color);
}

int32_t draw_blt(Image *dst, const DrawRect *dst_rect, const Image *src, const DrawRect *src_rect) {
    /* Z:0x40bf70 */
    DrawRect s = src_rect ? *src_rect : (DrawRect){0, 0, src->w, src->h};
    DrawRect d = dst_rect ? *dst_rect : (DrawRect){0, 0, dst->w, dst->h};
    if (s.l < 0) {
        int32_t v = s.l;
        s.l = -v;
        s.r += -v;
        d.r += v;
    }
    if (s.t < 0) {
        int32_t v = s.t;
        s.t = -v;
        s.b += -v;
        d.b += v;
    }
    if (!(s.r > 0 && s.b > 0)) return DRAW_OK;
    if (d.l < 0) {
        s.l = -d.l;
        d.l = 0;
    }
    if (dst->w < d.r) {
        s.r += dst->w - d.r;
        d.r = dst->w;
    }
    if (d.t < 0) {
        s.t = -d.t;
        d.t = 0;
    }
    if (dst->h < d.b) {
        s.b += dst->h - d.b;
        d.b = dst->h;
    }
    /* IDirectDrawSurface::Blt: an empty or out-of-surface rectangle fails with DDERR_INVALIDRECT
     * (offscreen surfaces have no clipper); the engine then returns 100000 (inferred DirectDraw
     * validation rule). */
    if (d.l >= d.r || d.t >= d.b || d.l < 0 || d.t < 0 || d.r > dst->w || d.b > dst->h) return DRAW_E_BLT;
    if (s.l >= s.r || s.t >= s.b || s.l < 0 || s.t < 0 || s.r > src->w || s.b > src->h) return DRAW_E_BLT;
    int32_t dw = d.r - d.l, dh = d.b - d.t, sw = s.r - s.l, sh = s.b - s.t;
    bool key = src->keyed != 0; /* DDBLT_KEYSRC when the source render target is keyed */
    for (int32_t y = 0; y < dh; y++) {
        int32_t sy = (sh == dh) ? s.t + y : s.t + (int32_t)(((int64_t)y * sh) / dh);
        const uint32_t *sp = src->px + (size_t)sy * (size_t)src->stride;
        uint32_t *dp = dst->px + (size_t)(d.t + y) * (size_t)dst->stride + (size_t)d.l;
        for (int32_t x = 0; x < dw; x++) {
            int32_t sx = (sw == dw) ? s.l + x : s.l + (int32_t)(((int64_t)x * sw) / dw);
            uint32_t p = sp[sx];
            if (key && draw_is_key(p)) continue;
            dp[x] = p;
        }
    }
    return DRAW_OK;
}

int32_t draw_at(Image *dst, const Image *src, int32_t x, int32_t y) {
    /* Z:0x40bef0: dest = (x, y, min(x + w, W), min(y + h, H)); src = (0, 0, dest r - x, dest b - y). */
    DrawRect d, s;
    d.l = x;
    d.t = y;
    d.r = (x + src->w < dst->w) ? x + src->w : dst->w;
    d.b = (dst->h <= src->h + y) ? dst->h : src->h + y;
    s.l = 0;
    s.t = 0;
    s.r = d.r - x;
    s.b = d.b - y;
    return draw_blt(dst, &d, src, &s);
}
