/* Engine ZML text renderer, reimplementation of Z:0x416190 (analysis/fonts.md 6). See zml.h.
 *
 * Source: the disassembly (analysis/decomp/ZapSpot.exe/listing.asm, Z:0x416190..0x416bba); the decompiled C
 * of this function is wrong (stack confusion, fonts.md 6). Addresses in the comments are ZapSpot.exe virtual
 * addresses. Port divergences (only for malformed input, never for an engine or game string) are marked
 * "port:". */
#include "zml.h"

/* Size preset table Z:0x435cc8, records {face, px, index, style}; <Sn> reads only px (Z:0x416612),
 * GetPresetFont(i) (Z:0x426300, <Hn>) returns (Arial, px[i], bold) (fonts.md 3.2). */
static const int32_t preset_px[6] = { 24, 18, 14, 12, 10, 8 };
#define LINK_PX 12               /* DAT_00435cfc = preset_px[3], read at Z:0x416a05 */

typedef struct Target {          /* render target: an image region with its own origin and size */
    Image *img;
    int32_t ox, oy, w, h;
} Target;

typedef struct Tok {
    int32_t off, len;
    int32_t tag;                 /* 0 text, 1 tag (record type at +8, Z:0x41623f) */
} Tok;

static void copy_face(char *d, const char *s)
{
    int32_t i = 0;
    for (; s[i] && i < ZML_FACE_MAX - 1; i++) d[i] = s[i];
    for (; i < ZML_FACE_MAX; i++) d[i] = 0;
}

void zml_font_create(ZmlFont *f, const TextFonts *fonts, const char *face, int32_t px, uint32_t style)
{
    /* Z:0x427c10: LOGFONT lfHeight = -px, lfWeight = bold ? 700 : 0, lfItalic/lfUnderline/lfStrikeOut from
     * the style bits; line height = tmHeight + tmExternalLeading; widths of " " (Z:0x43405c) and "."
     * (Z:0x432f70) from GetTextExtentPoint32A. */
    copy_face(f->face, face);
    f->px = px;
    f->index = 0;
    f->style = style;
    int32_t w = (style & ZML_BOLD) ? 700 : 0;
    int32_t u = (style & ZML_UNDERLINE) ? 1 : 0, so = (style & ZML_STRIKEOUT) ? 1 : 0;
    f->ok = gdi_font_select(&f->gdi, fonts, f->face, -px, w, u, so) == 0;
    if (!f->ok) /* inferred: the GDI font mapper substitutes a face it does not know */
        f->ok = gdi_font_select(&f->gdi, fonts, "Arial", -px, w, u, so) == 0;
    if (f->ok) {
        GdiTextMetrics tm;
        int32_t cy;
        gdi_get_text_metrics(&f->gdi, &tm);
        f->line_height = tm.tmHeight + tm.tmExternalLeading;
        gdi_get_text_extent_point32(&f->gdi, " ", 1, &f->space_w, &cy);
        gdi_get_text_extent_point32(&f->gdi, ".", 1, &f->dot_w, &cy);
    } else {
        f->line_height = f->space_w = f->dot_w = 0;
    }
}

void zml_context_init(ZmlContext *c, const TextFonts *fonts, int32_t smoothing)
{
    /* Z:0x4138f0: line maximum 0, font CreateFont("Arial", 18, 0) (Z:0x413979), T = 1, text colour
     * (255, 255, 255) (Z:0x4139a4), centre 0, shadow 0. The background colour belongs to the render target;
     * its initial value is not traced (inferred: black). */
    c->fonts = fonts;
    zml_font_create(&c->font, fonts, "Arial", 18, 0);
    c->text_color = IMG_RGB(255u, 255u, 255u);
    c->bk_color = IMG_RGB(0u, 0u, 0u);
    c->transparent = 1;
    c->centre = 0;
    c->shadow = 0;
    c->smoothing = smoothing ? 1u : 0u;
    c->line_max = 0;
    c->out_x = c->out_y = c->end_x = c->end_y = 0;
    c->nlinks = 0;
    c->missing_fonts = c->font.ok ? 0 : 1;
    c->on_draw = 0;
    c->on_draw_user = 0;
}

/* ---- one call of Z:0x416190 */

typedef struct Run {
    ZmlContext *c;
    const Target *t;
    const char *text;
    int32_t len;
    GdiRect rect;                /* layout and clip rectangle, target coordinates */
    uint8_t T;                   /* local copy of rc+0x1d (Z:0x4161bc), passed to every DrawText */
    int32_t x, y;
} Run;

static uint8_t at(const Run *r, int32_t i)
{
    /* port: bytes at or after len read as the NUL terminator; the original reads past the terminator in
     * malformed tags (tag without '>', <A>/<C> parameters at the end of the string). */
    return (i >= 0 && i < r->len) ? (uint8_t)r->text[i] : 0u;
}

static int32_t cspn(const Run *r, int32_t i, const char *set)
{
    /* strcspn, Z:0x42a6c0 */
    int32_t n = 0;
    for (;;) {
        uint8_t ch = at(r, i + n);
        if (!ch) return n;
        for (const char *p = set; *p; p++)
            if ((uint8_t)*p == ch) return n;
        n++;
    }
}

static void font_set(ZmlContext *c, const char *face, int32_t px, uint32_t style)
{
    /* CreateFont via the font subsystem (DAT_0045cfb4 vtable +0, cached), result stored in rc+0x28. */
    ZmlFont f;
    zml_font_create(&f, c->fonts, face, px, style);
    if (!f.ok) c->missing_fonts++;
    c->font = f;
}

static void measure(const ZmlFont *f, const char *s, int32_t n, int32_t *cx, int32_t *cy)
{
    /* render target MeasureText (vtable +0x60, Z:0x42a330): GetTextExtentPoint32A */
    if (!f->ok || n < 0) {
        *cx = 0;
        *cy = f->ok ? f->gdi.mono->tm_height : 0;
        return;
    }
    gdi_get_text_extent_point32(&f->gdi, s, n, cx, cy);
}

static void draw_text(const Run *r, const ZmlFont *f, int32_t x, int32_t y, const char *s, int32_t n, int32_t kind)
{
    /* render target DrawText (vtable +0x3c, Z:0x42a250): SetBkMode(T ? TRANSPARENT : OPAQUE), text and
     * background colour of the target, ExtTextOutA(x, y, ETO_CLIPPED, rect, s, n, NULL). The target image
     * bounds clip as well (DIB section bounds). */
    ZmlContext *c = r->c;
    if (c->on_draw) {
        ZmlDrawInfo d = { x, y, s, n, c->text_color, f, kind };
        c->on_draw(c->on_draw_user, &d);
    }
    if (!f->ok || n <= 0) return;
    const Target *t = r->t;
    GdiRect clip = { r->rect.left + t->ox, r->rect.top + t->oy, r->rect.right + t->ox, r->rect.bottom + t->oy };
    if (clip.left < t->ox) clip.left = t->ox;
    if (clip.top < t->oy) clip.top = t->oy;
    if (clip.right > t->ox + t->w) clip.right = t->ox + t->w;
    if (clip.bottom > t->oy + t->h) clip.bottom = t->oy + t->h;
    if (clip.right <= clip.left || clip.bottom <= clip.top) return;
    GdiTextState st = { c->text_color, c->bk_color, r->T ? GDI_TRANSPARENT : GDI_OPAQUE, c->smoothing };
    gdi_ext_text_out(t->img, t->ox + x, t->oy + y, GDI_ETO_CLIPPED, &clip, s, n, &f->gdi, &st);
}

static void newline(Run *r)
{
    /* Z:0x416110: x = rect.left; y += line maximum; line maximum = line height of the current font */
    r->x = r->rect.left;
    r->y += r->c->line_max;
    r->c->line_max = r->c->font.line_height;
}

static int32_t hexval(uint8_t ch)
{
    /* Z:0x416150 */
    if (ch >= 'a' && ch <= 'f') return ch - 0x57;
    if (ch >= '0' && ch <= '9') return ch - '0';
    if (ch >= 'A' && ch <= 'F') return ch - 0x37;
    return 0;
}

static int32_t is_digit(uint8_t ch) { return ch >= '0' && ch <= '9'; }

#define MAX_PENDING_LINKS 64

typedef struct LinkState {
    uint8_t in_link;             /* [EBP+0x1f] */
    int32_t id;                  /* [EBP-0x20] */
    const ZmlLinkSink *sink;
    int32_t draw;                /* draw links at the end of the call */
    ZmlLink pending[MAX_PENDING_LINKS];
    int32_t npending;
} LinkState;

static int32_t run_tokens(ZmlContext *c, const Target *t, const char *text, int32_t len, int32_t x, int32_t y,
                          const GdiRect *rect, uint32_t flags, LinkState *ls)
{
    Run r;
    r.c = c;
    r.t = t;
    r.text = text;
    r.len = len < 0 ? 0 : len;
    if (rect) r.rect = *rect;
    else { r.rect.left = 0; r.rect.top = 0; r.rect.right = t->w; r.rect.bottom = t->h; }   /* Z:0x413cc5 */
    r.T = c->transparent;
    r.x = x;
    r.y = y;

    /* ---- tokenizer, Z:0x4161c2..0x4163ca */
    Tok tok[ZML_MAX_TOKENS];
    int32_t ntok = 0;
    if (flags & ZML_PLAIN) {
        tok[0].off = 0; tok[0].len = r.len; tok[0].tag = 0;   /* Z:0x4161ce: one text record (text, len) */
        ntok = 1;
    } else {
        int32_t pos = 0;
        uint8_t al = at(&r, 0);
        while (al != 0) {                                     /* Z:0x4162e6 */
            int32_t esi = 0, skip = 0;
            if (al != '<') {
                esi = cspn(&r, pos, "<&");                    /* Z:0x4162f5, delimiters Z:0x4349f4 */
                if (ntok >= ZML_MAX_TOKENS) return ZML_ERR_TOKENS;
                tok[ntok].off = pos; tok[ntok].len = esi; tok[ntok].tag = 0;
                if (at(&r, pos + esi) == ' ') tok[ntok].len = ++esi;   /* Z:0x41630d (never true: delimiter) */
                ntok++;
            }
            if (esi < r.len) {                                /* Z:0x416340: offset compared with total length */
                while (at(&r, pos + esi) == ' ') esi++;      /* Z:0x416345 (never true: delimiter) */
                uint8_t ch = at(&r, pos + esi);
                if (ch == '%' || ch == '&') {                 /* Z:0x416354: Error(), return 0x15 */
                    return ZML_ERR_CHAR;
                }
                if (ch == '<') {                              /* Z:0x416369 */
                    pos += 1;
                    int32_t start = pos + esi;
                    int32_t m = cspn(&r, start, ">");         /* Z:0x416376, delimiter Z:0x434048 */
                    if (ntok >= ZML_MAX_TOKENS) return ZML_ERR_TOKENS;
                    tok[ntok].off = start; tok[ntok].len = m; tok[ntok].tag = 1;
                    ntok++;
                    skip = m + 1;
                }
            }
            esi += skip;                                      /* Z:0x4163b8 */
            al = at(&r, pos + esi);
            pos += esi;
        }
    }

    /* ---- layout, Z:0x4161ed..0x416ba8 */
    uint8_t n_mode = 0, e_mode = 0;                           /* [EBP+0xb], [EBP+0x17] */
    ls->in_link = 0;
    ls->id = -1;
    c->line_max = 0;                                          /* Z:0x416213 */
    int32_t last = 0;   /* [EBP-0x5c]; port: 0 where the original reads it uninitialised (empty token, wrap) */
    for (int32_t ti = 0; ti < ntok; ti++) {
        const Tok *tk = &tok[ti];
        if (tk->tag) {
            /* ---- tag, Z:0x416252 */
            int32_t p = tk->off;
            uint8_t closing = 0;
            if (at(&r, p) == '/') { closing = 1; p++; }
            uint8_t ch = at(&r, p);
            if (ch < 'A' || ch > 'u') continue;               /* Z:0x416263: index > 0x34 (unsigned) */
            if (ch >= 'a') ch = (uint8_t)(ch - 0x20);         /* tables Z:0x416bf4 / Z:0x416bc0 map both cases */
            ZmlFont *f = &c->font;
            switch (ch) {
            case 'A':                                         /* Z:0x4164d0 */
                if (!closing) {
                    uint32_t v = (uint32_t)ls->id;            /* starts from the previous id if position 1 is no digit */
                    if (is_digit(at(&r, p + 1))) v = (uint32_t)(at(&r, p + 1) - '0');
                    for (int32_t k = 2; k <= 5; k++)          /* Z:0x4164ed..0x41654a; may read past '>' */
                        if (is_digit(at(&r, p + k))) v = v * 10u + (uint32_t)(at(&r, p + k) - '0');
                    ls->id = (int32_t)v;
                    ls->in_link = 1;
                } else {
                    ls->in_link = 0;                          /* Z:0x416553 */
                }
                /* falls through to U (Z:0x416557) */
                font_set(c, f->face, f->px, closing ? (f->style & ~ZML_UNDERLINE) : (f->style | ZML_UNDERLINE));
                break;
            case 'B':                                         /* Z:0x41627b */
                if (at(&r, p + 1) == 'r' || at(&r, p + 1) == 'R') { newline(&r); break; }   /* <BR>, also </BR> */
                font_set(c, f->face, f->px, closing ? (f->style & ~ZML_BOLD) : (f->style | ZML_BOLD));
                break;
            case 'C':                                         /* Z:0x4166a3 */
                if (at(&r, p + 1) == '>') { c->centre = (uint8_t)!closing; break; }   /* <C>, </C> */
                {   /* colour, also when closing; byte arithmetic */
                    uint32_t rr = (uint32_t)((hexval(at(&r, p + 1)) << 4) + hexval(at(&r, p + 2))) & 0xffu;
                    uint32_t gg = (uint32_t)((hexval(at(&r, p + 3)) << 4) + hexval(at(&r, p + 4))) & 0xffu;
                    uint32_t bb = (uint32_t)((hexval(at(&r, p + 5)) << 4) + hexval(at(&r, p + 6))) & 0xffu;
                    c->text_color = IMG_RGB(rr, gg, bb);      /* Z:0x41673a: target SetTextColor(r, g, b) */
                }
                break;
            case 'E':                                         /* Z:0x41677b */
                e_mode = (uint8_t)!closing;
                break;
            case 'F': {                                       /* Z:0x416645: face up to '>' (also </F>: empty) */
                char face[ZML_FACE_MAX];
                int32_t k = 0, q = p + 1;
                while (at(&r, q) != '>' && at(&r, q) != 0) {  /* port: also stops at the end of the string */
                    if (k < ZML_FACE_MAX - 1) face[k++] = (char)at(&r, q);
                    q++;
                }
                face[k] = 0;
                font_set(c, face, f->px, f->style);
                break;
            }
            case 'H': {                                       /* Z:0x416421: GetPresetFont(digit - 1), newline twice */
                int32_t i = (int32_t)(int8_t)at(&r, p + 1) - '1';
                if (i >= 0 && i < 6) font_set(c, "Arial", preset_px[i], ZML_BOLD);
                /* port: other indexes read outside the preset array in the original; the font is kept */
                newline(&r);
                newline(&r);
                break;
            }
            case 'I':                                         /* Z:0x416463 */
                font_set(c, f->face, f->px, closing ? (f->style & ~ZML_ITALIC) : (f->style | ZML_ITALIC));
                break;
            case 'N':                                         /* Z:0x416770 */
                n_mode = (uint8_t)!closing;
                break;
            case 'P':                                         /* Z:0x416744 */
                newline(&r);
                newline(&r);
                break;
            case 'S': {                                       /* Z:0x4165a3 */
                uint8_t c2 = at(&r, p + 1);
                if (c2 == 'h' || c2 == 'H') { c->shadow = (uint8_t)!closing; break; }   /* <SH>, </SH> */
                int32_t idx = f->index;                       /* GetDesc: always 0 */
                if (c2 == '-') idx = (idx + 1 < 5) ? idx + 1 : 5;          /* Z:0x4165d4 */
                else if (c2 == '+') idx = (idx - 1 <= 0) ? 0 : idx - 1;    /* Z:0x4165ea */
                else idx = (int32_t)(int8_t)c2 - '0';                      /* Z:0x4165fc, not checked */
                /* port: an index outside 0..5 reads outside the table in the original; the font is kept */
                if (idx >= 0 && idx < 6) font_set(c, f->face, preset_px[idx], f->style);   /* Z:0x416612 */
                break;
            }
            case 'T':                                         /* Z:0x4164b2: rc+0x1d and the local T */
                c->transparent = (uint8_t)!closing;
                r.T = c->transparent;
                break;
            case 'U':                                         /* Z:0x416557 */
                font_set(c, f->face, f->px, closing ? (f->style & ~ZML_UNDERLINE) : (f->style | ZML_UNDERLINE));
                break;
            default:
                break;                                        /* Z:0x416b96 */
            }
            continue;
        }

        /* ---- text token, Z:0x416786 */
        const ZmlFont *f = &c->font;
        int32_t s = tk->off, n = tk->len;
        int32_t cx, cy;
        measure(f, text + s, n, &cx, &cy);
        if (c->line_max <= cy) c->line_max = cy;              /* Z:0x416798 */
        if (r.x + cx <= r.rect.right) {                       /* Z:0x4167b5: token fits */
            if (ls->in_link) {                                /* Z:0x4169bb: CHyperLink, nothing drawn here */
                ZmlFont f12;
                int32_t lw, lh;
                zml_font_create(&f12, c->fonts, f->face, LINK_PX, f->style);   /* Z:0x416a21 */
                if (!f12.ok) c->missing_fonts++;
                measure(&f12, text + s, n, &lw, &lh);         /* Z:0x416a3b */
                ZmlLink lk;
                lk.x = c->centre ? (r.rect.right - cx - r.rect.left) / 2 : r.x;   /* Z:0x416a3e: cx of F */
                lk.y = r.y;
                lk.w = lw + f12.space_w;                      /* Z:0x416a93 */
                lk.h = lh + 2;                                /* Z:0x416a8c */
                lk.id = ls->id;
                lk.text = text + s;
                lk.len = n;
                lk.x += t->ox;
                lk.y += t->oy;
                c->nlinks++;
                if (ls->sink && ls->sink->add) ls->sink->add(ls->sink->user, &lk);
                if (ls->draw) {
                    if (ls->npending < MAX_PENDING_LINKS) ls->pending[ls->npending++] = lk;
                    else zml_link_draw(c->fonts, t->img, &lk, 0, c->smoothing);   /* port: more links than kept */
                }
                /* Z:0x416ac1: font restored to CreateFont(face, px, style), the same font object */
            } else {
                int32_t dx = c->centre ? (r.rect.right - cx - r.rect.left) / 2 : r.x;   /* Z:0x416adf */
                if (c->shadow) {                              /* Z:0x416afd */
                    uint32_t saved = c->text_color;           /* target GetTextColor (+0x20) */
                    c->text_color = IMG_RGB(0u, 0u, 0u);      /* SetTextColor(0, 0, 0) */
                    draw_text(&r, f, dx + 1, r.y + 1, text + s, n, ZML_DRAW_SHADOW);
                    c->text_color = saved;
                }
                draw_text(&r, f, dx, r.y, text + s, n, ZML_DRAW_TEXT);   /* Z:0x416b77 */
                c->end_x = cx + dx;                           /* Z:0x416b88 */
                c->end_y = r.y;
            }
            r.x += cx;                                        /* Z:0x416b90: from x, not from dx */
        } else if (e_mode) {                                  /* Z:0x4167bd: ellipsis */
            if (r.x < r.rect.right) {
                int32_t limit = r.rect.right - 3 * f->dot_w;  /* Z:0x4167d9 */
                if (f->space_w + cx + r.x > limit) {
                    while (n > 0) {                           /* Z:0x4167e7 */
                        int32_t old = n;
                        n--;
                        measure(f, text + s, old, &cx, &cy);  /* measures the old length (off by one) */
                        if (f->space_w + cx + r.x <= limit) break;
                    }
                }
                draw_text(&r, f, r.x + f->space_w, r.y, text + s, n, ZML_DRAW_TEXT);       /* Z:0x41684d */
                draw_text(&r, f, cx - f->space_w + r.x, r.y, "...", 3, ZML_DRAW_ELLIPSIS);  /* Z:0x416877 */
                r.x += 3 * f->dot_w;                          /* Z:0x416883 */
            }
            r.x += cx;
        } else if (n_mode) {                                  /* Z:0x41688e: no wrap */
            if (r.x < r.rect.right) draw_text(&r, f, f->space_w + r.x, r.y, text + s, n, ZML_DRAW_TEXT);
            r.x += cx;
        } else {                                              /* Z:0x4168c8: word wrap, no centring, no shadow */
            int32_t rem = n, zero_lines = 0;
            while (rem != 0) {                                /* Z:0x4168d0 */
                int32_t k = rem;
                if (r.x + cx > r.rect.right) {
                    while (k > 0) {                           /* Z:0x4168e0: longest prefix that fits */
                        k--;
                        measure(f, text + s, k, &cx, &cy);
                        if (r.x + cx <= r.rect.right) break;
                    }
                    if (k != rem) {                           /* Z:0x416907: break at the last space before k */
                        int32_t j = k;
                        if (at(&r, s + k) != ' ') {
                            for (;;) {
                                if (j <= 0) break;            /* Z:0x416916: no space: mid-word break */
                                j--;
                                if (at(&r, s + j) == ' ') break;
                            }
                        }
                        if (j > 0) k = j;                     /* Z:0x416924 */
                    }
                }
                draw_text(&r, f, r.x, r.y, text + s, k, ZML_DRAW_TEXT);   /* Z:0x416945 */
                if (k < rem) newline(&r);                     /* Z:0x416948 */
                rem -= k;                                     /* Z:0x416962 */
                uint8_t nx = at(&r, s + k);
                s += k;
                if (nx == ' ') { rem--; s++; }                /* skips exactly one space */
                last = cx;                                    /* Z:0x41697e: width of the character-fit piece */
                measure(f, text + s, rem, &cx, &cy);          /* Z:0x416990 */
                /* port: the original loops forever when not even one character fits at rect.left */
                if (k == 0) { if (++zero_lines > 1) break; } else zero_lines = 0;
            }
            cx = last;                                        /* Z:0x41699e */
            c->end_x = last + r.x;
            c->end_y = r.y;
            r.x += cx;
        }
    }
    c->out_x = r.x;
    c->out_y = r.y;
    return ZML_OK;
}

static int32_t run(ZmlContext *c, const Target *t, const char *text, int32_t len, int32_t x, int32_t y,
                   const GdiRect *rect, uint32_t flags, const ZmlLinkSink *links)
{
    LinkState ls;
    ls.sink = links;
    ls.draw = links ? links->draw : 1;
    ls.npending = 0;
    c->nlinks = 0;
    int32_t rv = run_tokens(c, t, text, len, x, y, rect, flags, &ls);
    /* Links are child surfaces, composed above the target (inferred from the surface tree): draw them last. */
    for (int32_t i = 0; i < ls.npending; i++) zml_link_draw(c->fonts, t->img, &ls.pending[i], 0, c->smoothing);
    return rv;
}

int32_t zml_draw(ZmlContext *c, Image *dst, const char *text, int32_t len, int32_t x, int32_t y,
                 const GdiRect *rect, uint32_t flags, const ZmlLinkSink *links)
{
    Target t = { dst, 0, 0, dst->w, dst->h };
    return run(c, &t, text, len, x, y, rect, flags, links);
}

static int32_t slen(const char *s)
{
    int32_t n = 0;
    while (s[n]) n++;
    return n;
}

int32_t zml_link_draw(const TextFonts *fonts, Image *dst, const ZmlLink *link, int32_t hover, int32_t smoothing)
{
    /* CHyperLink (Z:0x4184e0): surface of link->w x link->h, colour key (Z:0x414190 flag 3 & 1), a new render
     * context (Z:0x4138f0 defaults). The strings are prefix + text + suffix (Z:0x418576..0x4185e7); the
     * three parts are drawn as three calls on the same context, which gives the same result: the prefix and
     * suffix hold only tags, the text starts at (0, 0) in both cases, and the context state carries over. */
    static const char pre_normal[] = "<T><S3><U><SH><C><CFFFFFF>";   /* Z:0x434afc */
    static const char suf_normal[] = "</C></SH></U>";                /* Z:0x434aec */
    static const char pre_hover[] = "<T><S3><U><C><Sh><CFFF000>";    /* Z:0x434b28 */
    static const char suf_hover[] = "</C></sh></U>";                 /* Z:0x434b18 */
    const char *pre = hover ? pre_hover : pre_normal, *suf = hover ? suf_hover : suf_normal;
    ZmlContext c;
    zml_context_init(&c, fonts, smoothing);
    Target t = { dst, link->x, link->y, link->w, link->h };
    ZmlLinkSink none = { 0, 0, 0 };
    /* The constructor draws hover (Z:0x4185f3), then normal (Z:0x4185fc); events 8 and 9 redraw one state.
     * The state at the text is the same in both orders: every relevant field is set by the prefix. */
    int32_t rv = run(&c, &t, pre, slen(pre), 0, 0, 0, 0, &none);
    if (rv == ZML_OK) rv = run(&c, &t, link->text, link->len, 0, 0, 0, 0, &none);
    if (rv == ZML_OK) rv = run(&c, &t, suf, slen(suf), 0, 0, 0, 0, &none);
    return rv;
}
