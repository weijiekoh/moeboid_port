/* Windows XP dialog component: templates, dialog manager, push buttons, statics, drawing.
 * See dialog.h. Edit control and scroll bar: dialog_edit.c.
 *
 * Sources and status of the rules (V = verified, I = inferred; no Windows ground truth exists, decision 4c):
 * - Templates: RT_DIALOG resources of ZapSpot.exe (pack entries zap/DIALOG/NAME), DLGTEMPLATE and DLGTEMPLATEEX
 *   layout (Win32 documentation). V: control rectangles equal assets/ZapSpot.exe/decoded/dialogs.json
 *   (test_dialog). DLU to pixels: MulDiv(x, base_x, 4), MulDiv(y, base_y, 8); base units 6 x 13 for MS
 *   Sans Serif 8 (V: assets). Base unit rule (text extent of A..Za..z / 26 + 1) / 2 and tmHeight: I
 *   (GdiGetCharDimensions).
 * - 3D look: ZapSpot.exe has subsystem version 4.0 (V: PE header), so the dialog manager gives every
 *   control the 3D look (I: DS_3DLOOK documentation); an edit with WS_BORDER gets WS_EX_CLIENTEDGE
 *   instead (I).
 * - Placement: DS_CENTER centres the window in the monitor work area (I: Win32 documentation). The
 *   frame window is centred in the same area (V: Z:0x40491a CreateWindowExA at ((w - 800) / 2,
 *   (h - taskbar - 572) / 2)), so with even screen sizes the dialog is at ((800 - w) / 2, (572 - h) / 2)
 *   in frame pixels (I). The port uses that.
 * - Dialog manager (IsDialogMessage, DefDlgProc, CheckDefPushButton): Tab / Shift+Tab, arrow keys in
 *   groups, Enter, Esc, mnemonics, default push button, focus selection of edits: I (Win32 documentation,
 *   Windows 2000 dialog manager behaviour as recalled, Wine dlgproc/dialog.c). Details at each function.
 * - UI state (XP "hide keyboard cues" default on): a dialog opened after mouse input hides focus
 *   rectangles and mnemonic underlines until Tab or an arrow key (UIS_INITIALIZE): I.
 * - Classic control look (user32 BUTTON, STATIC; DrawEdge colour tables, DrawFocusRect): I (Wine
 *   uitools.c tables and recalled Windows 2000 drawing). Colours: Luna [SysMetrics] (V: luna.h).
 * - Caption drag moves the window; the port keeps it inside the 800x572 canvas (port decision). */
#include "dialog.h"
#include "dialog_int.h"

/* ------------------------------------------------------------------ helpers */

static int32_t imin(int32_t a, int32_t b) { return a < b ? a : b; }
static int32_t imax(int32_t a, int32_t b) { return a > b ? a : b; }

int32_t dlg_muldiv(int32_t a, int32_t b, int32_t c) {
    if (c == 0) return -1;
    int64_t p = (int64_t)a * (int64_t)b;
    bool neg = (p < 0) != (c < 0);
    uint64_t up = (uint64_t)(p < 0 ? -p : p), uc = (uint64_t)(c < 0 ? -(int64_t)c : (int64_t)c);
    uint64_t q = (up + uc / 2u) / uc;
    return neg ? -(int32_t)q : (int32_t)q;
}

static bool pt_in(const DlgRect *r, int32_t x, int32_t y) {
    return x >= r->x && y >= r->y && x < r->x + r->w && y < r->y + r->h;
}

static int32_t text_cx(const GdiFont *f, const char *s, int32_t n) {
    int32_t cx, cy;
    gdi_get_text_extent_point32(f, s, n, &cx, &cy);
    return cx;
}

void dlg_base_units(const GdiFont *f, int32_t *bx, int32_t *by) {
    static const char letters[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    *bx = (text_cx(f, letters, 52) / 26 + 1) / 2;
    *by = f->mono->tm_height;
}

static uint32_t pixel(const Dialog *d, int32_t index) {
    if (d->env.luna && d->env.luna->loaded) return luna_pixel(d->env.luna, index);
    /* No theme data: Luna values of luna.h (same numbers, for tests without the pack). */
    switch (index) {
    case LUNA_COLOR_WINDOW: case LUNA_COLOR_3DHILIGHT: case LUNA_COLOR_HIGHLIGHTTEXT: return IMG_RGB(255, 255, 255);
    case LUNA_COLOR_3DFACE: return IMG_RGB(236, 233, 216);
    case LUNA_COLOR_3DSHADOW: return IMG_RGB(172, 168, 153);
    case LUNA_COLOR_3DDKSHADOW: return IMG_RGB(113, 111, 100);
    case LUNA_COLOR_3DLIGHT: return IMG_RGB(241, 239, 226);
    case LUNA_COLOR_HIGHLIGHT: return IMG_RGB(49, 106, 197);
    default: return IMG_RGB(0, 0, 0);
    }
}

/* ------------------------------------------------------------------ drawing primitives (clipped) */

typedef struct Clip {
    int32_t l, t, r, b;
} Clip;

static Clip clip_of(const Image *img, int32_t x, int32_t y, int32_t w, int32_t h) {
    Clip c = {imax(x, 0), imax(y, 0), imin(x + w, img->w), imin(y + h, img->h)};
    return c;
}

static void fill(Image *img, const Clip *c, int32_t x, int32_t y, int32_t w, int32_t h, uint32_t px) {
    int32_t l = imax(x, c->l), t = imax(y, c->t), r = imin(x + w, c->r), b = imin(y + h, c->b);
    for (int32_t yy = t; yy < b; yy++) {
        uint32_t *row = img->px + yy * img->stride;
        for (int32_t xx = l; xx < r; xx++) row[xx] = px;
    }
}

static void put(Image *img, const Clip *c, int32_t x, int32_t y, uint32_t px) {
    if (x >= c->l && x < c->r && y >= c->t && y < c->b) img->px[y * img->stride + x] = px;
}

static void invert(Image *img, const Clip *c, int32_t x, int32_t y) {
    if (x >= c->l && x < c->r && y >= c->t && y < c->b) img->px[y * img->stride + x] ^= 0x00FFFFFFu;
}

/* Gray pattern brush (gpsi->hbrGray, 8x8 rows 0xAA, 0x55, ...; I): bit set where (x + y) is even,
 * relative to the brush origin (the window's top-left corner, I). */
static bool gray_bit(int32_t x, int32_t y) { return ((x + y) & 1) == 0; }

/* Monochrome pattern fill: set bits get `set`, clear bits get `clear`. (ox, oy) = brush origin. */
static void fill_pattern(Image *img, const Clip *c, int32_t x, int32_t y, int32_t w, int32_t h, int32_t ox, int32_t oy,
                         uint32_t set, uint32_t clear) {
    int32_t l = imax(x, c->l), t = imax(y, c->t), r = imin(x + w, c->r), b = imin(y + h, c->b);
    for (int32_t yy = t; yy < b; yy++) {
        uint32_t *row = img->px + yy * img->stride;
        for (int32_t xx = l; xx < r; xx++) row[xx] = gray_bit(xx - ox, yy - oy) ? set : clear;
    }
}

/* DrawEdge colour tables (Wine uitools.c, which models Windows; I). Index = edge & 0x0F
 * (BDR_RAISEDOUTER 1, BDR_SUNKENOUTER 2, BDR_RAISEDINNER 4, BDR_SUNKENINNER 8). -1 = no line. */
#define C_HI LUNA_COLOR_3DHILIGHT
#define C_SH LUNA_COLOR_3DSHADOW
#define C_DK LUNA_COLOR_3DDKSHADOW
#define C_LT LUNA_COLOR_3DLIGHT
#define C_FA LUNA_COLOR_3DFACE
static const int8_t lt_inner_normal[16] = {-1, -1, -1, -1, -1, C_HI, C_HI, -1, -1, C_DK, C_DK, -1, -1, -1, -1, -1};
static const int8_t lt_outer_normal[16] = {-1, C_LT, C_SH, -1, C_HI, C_LT, C_SH, -1, C_DK, C_LT, C_SH, -1, -1, C_LT, C_SH, -1};
static const int8_t rb_inner_normal[16] = {-1, -1, -1, -1, -1, C_SH, C_SH, -1, -1, C_LT, C_LT, -1, -1, -1, -1, -1};
static const int8_t rb_outer_normal[16] = {-1, C_DK, C_HI, -1, C_SH, C_DK, C_HI, -1, C_LT, C_DK, C_HI, -1, -1, C_DK, C_HI, -1};
static const int8_t lt_inner_soft[16] = {-1, -1, -1, -1, -1, C_LT, C_LT, -1, -1, C_SH, C_SH, -1, -1, -1, -1, -1};
static const int8_t lt_outer_soft[16] = {-1, C_HI, C_DK, -1, C_LT, C_HI, C_DK, -1, C_SH, C_HI, C_DK, -1, -1, C_HI, C_DK, -1};
static const int8_t ltrb_outer_flat[16] = {-1, C_SH, C_SH, C_SH, C_FA, C_SH, C_SH, C_SH, C_FA, C_SH, C_SH, C_SH, C_FA, C_SH, C_SH, C_SH};
static const int8_t ltrb_inner_flat[16] = {-1, -1, -1, -1, -1, C_FA, C_FA, C_FA, -1, C_FA, C_FA, C_FA, -1, -1, -1, -1};

#define EDGE_RAISED 5
#define EDGE_SUNKEN 10
#define BF_SOFT 0x1000u
#define BF_FLAT 0x4000u
#define BF_MIDDLE 0x0800u

static void frame_lines(Image *img, const Clip *c, int32_t x, int32_t y, int32_t w, int32_t h, int32_t lt, int32_t rb,
                        const Dialog *d) {
    if (w <= 0 || h <= 0) return;
    if (lt >= 0) {
        fill(img, c, x, y, w - 1, 1, pixel(d, lt));     /* top: left .. right - 1 */
        fill(img, c, x, y, 1, h - 1, pixel(d, lt));     /* left: top .. bottom - 1 */
    }
    if (rb >= 0) {
        fill(img, c, x, y + h - 1, w, 1, pixel(d, rb)); /* bottom: full width */
        fill(img, c, x + w - 1, y, 1, h, pixel(d, rb)); /* right: full height */
    }
}

/* DrawEdge(BF_RECT | flags) over (x, y, w, h); returns the interior rectangle (BF_ADJUST). */
static DlgRect draw_edge(Image *img, const Clip *c, const Dialog *d, DlgRect r, uint32_t edge, uint32_t flags) {
    int32_t lti, lto, rbi, rbo;
    if (flags & BF_FLAT) {
        lto = rbo = ltrb_outer_flat[edge & 15];
        lti = rbi = ltrb_inner_flat[edge & 15];
    } else if (flags & BF_SOFT) {
        lto = lt_outer_soft[edge & 15];
        lti = lt_inner_soft[edge & 15];
        rbo = rb_outer_normal[edge & 15];
        rbi = rb_inner_normal[edge & 15];
    } else {
        lto = lt_outer_normal[edge & 15];
        lti = lt_inner_normal[edge & 15];
        rbo = rb_outer_normal[edge & 15];
        rbi = rb_inner_normal[edge & 15];
    }
    frame_lines(img, c, r.x, r.y, r.w, r.h, lto, rbo, d);
    DlgRect in = {r.x + 1, r.y + 1, r.w - 2, r.h - 2};
    if (lti >= 0 || rbi >= 0) {
        frame_lines(img, c, in.x, in.y, in.w, in.h, lti, rbi, d);
        in = (DlgRect){in.x + 1, in.y + 1, in.w - 2, in.h - 2};
    }
    if (flags & BF_MIDDLE) fill(img, c, in.x, in.y, in.w, in.h, pixel(d, LUNA_COLOR_3DFACE));
    return in;
}

/* DrawFocusRect: PatBlt PATINVERT with the gray brush on the 1-pixel border (I: Windows uses black text
 * and white background colours, so pattern bits invert the destination). (ox, oy) = brush origin. */
static void focus_rect(Image *img, const Clip *c, DlgRect r, int32_t ox, int32_t oy) {
    if (r.w <= 0 || r.h <= 0) return;
    for (int32_t x = r.x; x < r.x + r.w; x++) {
        if (gray_bit(x - ox, r.y - oy)) invert(img, c, x, r.y);
        if (r.h > 1 && gray_bit(x - ox, r.y + r.h - 1 - oy)) invert(img, c, x, r.y + r.h - 1);
    }
    for (int32_t y = r.y + 1; y < r.y + r.h - 1; y++) {
        if (gray_bit(r.x - ox, y - oy)) invert(img, c, r.x, y);
        if (r.w > 1 && gray_bit(r.x + r.w - 1 - ox, y - oy)) invert(img, c, r.x + r.w - 1, y);
    }
}

/* ------------------------------------------------------------------ DrawText model */

/* Layout rules (I: DrawText behaviour as documented, Wine TEXT_NextLineW):
 * - prefix: "&x" underlines x, "&&" is "&" (unless DT_NOPREFIX); the first single '&' is the mnemonic;
 * - DT_SINGLELINE: one line; else lines end at CR LF, CR or LF;
 * - DT_WORDBREAK: the longest prefix that fits (sum of advances <= width) is kept; if the next
 *   character is a space, the line ends there; else at the last space of the prefix; the spaces at the
 *   break are dropped; a word wider than the line stays whole (DT_EDITCONTROL: broken at the width);
 * - line height tmHeight (+ tmExternalLeading with DT_EXTERNALLEADING). Tabs are not expanded (no
 *   kept text has one). */
void dt_layout(DtText *t, const GdiFont *f, const char *s, int32_t n, int32_t width, uint32_t flags) {
    t->n = 0;
    t->underline = -1;
    t->nlines = 0;
    t->width = t->height = 0;
    for (int32_t i = 0; i < n && t->n < DLG_LABEL_MAX; i++) {
        char ch = s[i];
        if (ch == '&' && !(flags & DLG_DT_NOPREFIX)) {
            if (i + 1 < n && s[i + 1] == '&') {
                t->s[t->n++] = '&';
                i++;
                continue;
            }
            if (i + 1 < n && t->underline < 0) t->underline = t->n;
            continue;
        }
        t->s[t->n++] = ch;
    }
    const char *p = t->s;
    int32_t len = t->n, pos = 0;
    while (t->nlines < (int32_t)RT_COUNTOF(t->line)) {
        int32_t pend = len;
        int32_t next_para = len;
        if (!(flags & DLG_DT_SINGLELINE)) {
            for (int32_t i = pos; i < len; i++) {
                if (p[i] == '\r' || p[i] == '\n') {
                    pend = i;
                    next_para = (p[i] == '\r' && i + 1 < len && p[i + 1] == '\n') ? i + 2 : i + 1;
                    break;
                }
            }
        }
        /* lines of the paragraph pos .. pend */
        do {
            int32_t le = pend, nx = pend;
            if ((flags & DLG_DT_WORDBREAK) && !(flags & DLG_DT_SINGLELINE)) {
                int32_t k = 0, w = 0;
                TextGlyph g;
                while (pos + k < pend) {
                    atlas_glyph(f->mono, (uint8_t)p[pos + k], &g);
                    if (w + g.adv > width) break;
                    w += g.adv;
                    k++;
                }
                if (pos + k < pend) {
                    int32_t j = pos + k;
                    if (p[j] != ' ') {
                        while (j > pos && p[j - 1] != ' ') j--;
                        if (j == pos) { /* no space: word too long */
                            if (flags & DLG_DT_EDITCONTROL) {
                                j = pos + imax(k, 1);
                                le = nx = j;
                            } else {
                                j = pos;
                                while (j < pend && p[j] != ' ') j++;
                                le = nx = j;
                            }
                        } else {
                            le = j;
                            nx = j;
                        }
                    } else {
                        le = nx = j;
                    }
                    while (le > pos && p[le - 1] == ' ') le--;
                    while (nx < pend && p[nx] == ' ') nx++;
                }
            }
            DtLine *L = &t->line[t->nlines++];
            L->start = pos;
            L->len = le - pos;
            L->width = text_cx(f, p + pos, L->len);
            t->width = imax(t->width, L->width);
            pos = nx;
        } while (pos < pend && t->nlines < (int32_t)RT_COUNTOF(t->line));
        if (next_para >= len && pend >= len) break;
        pos = next_para;
        if (pos >= len && pend < len) {
            /* text ends with a line break: DrawText shows no extra empty line (I) */
            break;
        }
    }
    int32_t lh = f->mono->tm_height + ((flags & DLG_DT_EXTERNALLEADING) ? f->mono->tm_ext_leading : 0);
    t->height = t->nlines * lh;
}

void dt_draw(Image *dst, const DtText *t, const GdiFont *f, DlgRect r, const GdiRect *clip, uint32_t flags,
             uint32_t color, uint8_t smoothing) {
    int32_t lh = f->mono->tm_height + ((flags & DLG_DT_EXTERNALLEADING) ? f->mono->tm_ext_leading : 0);
    GdiTextState st = {color, 0, GDI_TRANSPARENT, smoothing};
    int32_t y = r.y;
    if ((flags & DLG_DT_SINGLELINE) && (flags & DLG_DT_VCENTER)) y = r.y + (r.h - lh) / 2;
    for (int32_t i = 0; i < t->nlines; i++, y += lh) {
        const DtLine *L = &t->line[i];
        int32_t x = r.x;
        if (flags & DLG_DT_CENTER) x = r.x + (r.w - L->width) / 2;
        else if (flags & DLG_DT_RIGHT) x = r.x + r.w - L->width;
        gdi_ext_text_out(dst, x, y, GDI_ETO_CLIPPED, clip, t->s + L->start, L->len, f, &st);
        /* Mnemonic underline: row y + tmAscent + 1, from the character's pen x for advance - 1 pixels
         * (I: Wine TEXT_DrawUnderscore; Windows draws it in the text colour). */
        if (t->underline >= L->start && t->underline < L->start + L->len && !(flags & DLG_DT_HIDEPREFIX)) {
            int32_t ux = x + text_cx(f, t->s + L->start, t->underline - L->start);
            int32_t uw = text_cx(f, t->s + t->underline, 1) - 1;
            int32_t uy = y + f->mono->tm_ascent + 1;
            for (int32_t xx = ux; xx < ux + uw; xx++)
                if (xx >= clip->left && xx < clip->right && uy >= clip->top && uy < clip->bottom && xx >= 0 &&
                    uy >= 0 && xx < dst->w && uy < dst->h)
                    dst->px[uy * dst->stride + xx] = color | 0xFF000000u;
        }
    }
}

/* ------------------------------------------------------------------ template parser */

typedef struct Rd {
    const uint8_t *b;
    uint32_t len, pos;
    bool err;
} Rd;

static uint32_t r16(Rd *r) {
    if (r->pos + 2 > r->len) {
        r->err = true;
        return 0;
    }
    uint32_t v = (uint32_t)r->b[r->pos] | ((uint32_t)r->b[r->pos + 1] << 8);
    r->pos += 2;
    return v;
}
static uint32_t r32(Rd *r) {
    uint32_t lo = r16(r);
    return lo | (r16(r) << 16);
}
static int32_t rs16(Rd *r) { return (int32_t)(int16_t)(uint16_t)r16(r); }
static void ralign4(Rd *r) { r->pos = (r->pos + 3u) & ~3u; }

/* UTF-16 code unit to Windows-1252 (WideCharToMultiByte, default char '?'). */
static char to_cp1252(uint32_t u) {
    static const uint16_t hi[32] = {0x20AC, 0x81, 0x201A, 0x0192, 0x201E, 0x2026, 0x2020, 0x2021, 0x02C6, 0x2030, 0x0160,
                                    0x2039, 0x0152, 0x8D, 0x017D, 0x8F, 0x90, 0x2018, 0x2019, 0x201C, 0x201D, 0x2022,
                                    0x2013, 0x2014, 0x02DC, 0x2122, 0x0161, 0x203A, 0x0153, 0x9D, 0x017E, 0x0178};
    if (u < 0x80 || (u >= 0xA0 && u <= 0xFF)) return (char)u;
    for (uint32_t i = 0; i < 32; i++)
        if (hi[i] == u) return (char)(0x80 + i);
    return '?';
}

/* sz_Or_Ord: returns the ordinal (>= 0) or -1 for a string (copied to out as cp1252) or -2 for none. */
static int32_t rszord(Rd *r, char *out, int32_t cap, int32_t *n_out) {
    int32_t n = 0;
    uint32_t w = r16(r);
    if (n_out) *n_out = 0;
    if (w == 0) {
        if (out && cap > 0) out[0] = 0;
        return -2;
    }
    if (w == 0xFFFF) return (int32_t)r16(r);
    while (!r->err && w != 0) {
        if (out && n < cap - 1) out[n++] = to_cp1252(w);
        w = r16(r);
    }
    if (out && cap > 0) out[n] = 0;
    if (n_out) *n_out = n;
    return -1;
}

static void geom_update(Dialog *d) {
    if (d->env.luna && d->env.luna->loaded) {
        luna_geom(d->env.luna, d->client_w, d->client_h, d->close_button, &d->geom);
    } else {
        /* No Luna data in the pack: the same metrics (luna.h: border 3, caption 26, close button 21 x 21 at
         * (w - 25, 5)), plain drawing. */
        LunaGeom *g = &d->geom;
        *g = (LunaGeom){0};
        g->frame = LUNA_DLG_FRAME;
        g->caption_h = 26;
        g->top = g->frame + g->caption_h;
        g->win_w = d->client_w + 2 * g->frame;
        g->win_h = d->client_h + g->top + g->frame;
        g->client = (LunaRect){g->frame, g->top, d->client_w, d->client_h};
        g->caption = (LunaRect){0, 0, g->win_w, g->top};
        if (d->close_button) g->close = (LunaRect){g->win_w - 25, 5, 21, 21};
        g->text = (LunaRect){g->frame + 4, g->frame, g->win_w - 2 * g->frame - 8, g->caption_h};
    }
    d->img = (Image){d->geom.win_w, d->geom.win_h, d->geom.win_w, d->px, 1};
}

static void centre(Dialog *d) {
    /* DS_CENTER in the work area = centre in the frame (see file header). */
    d->win_x = (d->env.frame_w - d->geom.win_w) / 2;
    d->win_y = (d->env.frame_h - d->geom.win_h) / 2;
}

static void dlg_reset(Dialog *d, const DlgEnv *env) {
    /* Clear everything except the pixel buffer. */
    rt_memset(d, 0, offsetof(Dialog, px));
    d->env = *env;
    d->focus = -1;
    d->capture = -1;
    d->edit_ctl = -1;
    d->active = true;
    d->dirty = true;
}

void dlg_init(Dialog *d, const DlgEnv *env, const GdiFont *font, int32_t client_w, int32_t client_h, uint32_t style,
              bool close_button) {
    dlg_reset(d, env);
    d->font_own = *font;
    d->font = &d->font_own;
    gdi_get_text_metrics(d->font, &d->tm);
    dlg_base_units(d->font, &d->base_x, &d->base_y);
    d->style = style;
    d->close_button = close_button;
    d->client_w = imin(client_w, DLG_MAX_W - 2 * LUNA_DLG_FRAME);
    d->client_h = client_h;
    geom_update(d);
    if (d->geom.win_h > DLG_MAX_H) {
        d->client_h -= d->geom.win_h - DLG_MAX_H;
        geom_update(d);
    }
    centre(d);
    d->open = true;
}

int32_t dlg_add_control(Dialog *d, uint8_t kind, int32_t id, uint32_t style, uint32_t exstyle, DlgRect r,
                        const char *text, int32_t n) {
    if (d->n >= DLG_MAX_CTL) return -1;
    int32_t i = d->n++;
    DlgControl *c = &d->ctl[i];
    rt_memset(c, 0, sizeof *c);
    c->kind = kind;
    c->id = id;
    /* 3D look: WS_BORDER on an edit becomes WS_EX_CLIENTEDGE (I, see header). */
    if (kind == DLG_K_EDIT && (style & DLG_WS_BORDER)) {
        style &= ~DLG_WS_BORDER;
        exstyle |= DLG_WS_EX_CLIENTEDGE;
    }
    c->style = style;
    c->exstyle = exstyle;
    c->r = r;
    c->visible = (style & DLG_WS_VISIBLE) != 0;
    if (n < 0) n = text ? (int32_t)rt_strlen(text) : 0;
    n = imin(n, DLG_LABEL_MAX - 1);
    if (kind != DLG_K_EDIT && text) rt_memcpy(c->text, text, (size_t)n);
    c->text_len = (kind != DLG_K_EDIT && text) ? n : 0;
    if (kind == DLG_K_BUTTON && (style & DLG_BS_TYPEMASK) == DLG_BS_DEFPUSHBUTTON) {
        c->is_def = true;
        if (d->def_id == 0) d->def_id = id; /* DM_GETDEFID: first BS_DEFPUSHBUTTON (I) */
    }
    if (kind == DLG_K_EDIT) {
        if (d->edit_ctl >= 0) { /* one edit per dialog (port limit) */
            c->kind = DLG_K_NONE;
            c->visible = false;
        } else {
            d->edit_ctl = i;
            dlg_edit_init(d, c);
            if (text && n > 0) dlg_set_item_text(d, id, text, n);
        }
    }
    d->dirty = true;
    return i;
}

int32_t dlg_create(Dialog *d, const DlgEnv *env, const TextFonts *fonts, const uint8_t *tmpl, uint32_t len) {
    Rd r = {tmpl, len, 0, false};
    bool ex = len >= 4 && tmpl[0] == 1 && tmpl[1] == 0 && tmpl[2] == 0xFF && tmpl[3] == 0xFF;
    uint32_t style, exstyle, count;
    int32_t x, y, cx, cy;
    if (ex) {
        r.pos = 4;
        (void)r32(&r); /* helpID */
        exstyle = r32(&r);
        style = r32(&r);
    } else {
        style = r32(&r);
        exstyle = r32(&r);
    }
    (void)exstyle;
    count = r16(&r);
    x = rs16(&r);
    y = rs16(&r);
    cx = rs16(&r);
    cy = rs16(&r);
    (void)x;
    (void)y;
    char caption[DLG_CAPTION_MAX], face[64];
    int32_t caplen = 0;
    rszord(&r, NULL, 0, NULL);                              /* menu */
    rszord(&r, NULL, 0, NULL);                              /* class */
    rszord(&r, caption, (int32_t)sizeof caption, &caplen);  /* title */
    int32_t pt = 8, weight = 400;
    face[0] = 0;
    if (style & DLG_DS_SETFONT) {
        pt = (int32_t)r16(&r);
        if (ex) {
            weight = (int32_t)r16(&r);
            (void)r16(&r); /* italic, charset */
        }
        rszord(&r, face, (int32_t)sizeof face, NULL);
    }
    if (r.err || count > 64) return -1;
    /* Font: LOGFONT lfHeight = -MulDiv(pt, 96, 72) (96 dpi), FW_DONTCARE = 400. */
    GdiFont f;
    if (gdi_font_select(&f, fonts, face[0] ? face : "MS Sans Serif", -dlg_muldiv(pt, 96, 72), weight ? weight : 400, 0,
                        0) != 0)
        return -1;
    int32_t bx, by;
    dlg_base_units(&f, &bx, &by);
    dlg_init(d, env, &f, dlg_muldiv(cx, bx, 4), dlg_muldiv(cy, by, 8), style, (style & DLG_WS_SYSMENU) != 0);
    d->open = false;
    dlg_set_caption(d, caption, caplen);
    for (uint32_t k = 0; k < count; k++) {
        ralign4(&r);
        uint32_t ist, iex;
        int32_t id;
        if (ex) {
            (void)r32(&r);
            iex = r32(&r);
            ist = r32(&r);
        } else {
            ist = r32(&r);
            iex = r32(&r);
        }
        int32_t ix = rs16(&r), iy = rs16(&r), icx = rs16(&r), icy = rs16(&r);
        id = ex ? (int32_t)r32(&r) : (int32_t)(int16_t)(uint16_t)r16(&r);
        int32_t cls = rszord(&r, NULL, 0, NULL);
        char text[DLG_LABEL_MAX];
        int32_t tn = 0;
        int32_t tord = rszord(&r, text, (int32_t)sizeof text, &tn);
        if (tord != -1) tn = 0;
        uint32_t extra = r16(&r);
        r.pos += extra;
        if (r.err || r.pos > len) return -1;
        uint8_t kind = DLG_K_NONE;
        if (cls == 0x80) kind = ((ist & DLG_BS_TYPEMASK) == DLG_BS_AUTOCHECKBOX) ? DLG_K_CHECKBOX : DLG_K_BUTTON;
        else if (cls == 0x81) kind = DLG_K_EDIT;
        else if (cls == 0x82) kind = ((ist & DLG_SS_TYPEMASK) == DLG_SS_ICON) ? DLG_K_ICON : DLG_K_STATIC;
        DlgRect rc = {dlg_muldiv(ix, bx, 4), dlg_muldiv(iy, by, 8), dlg_muldiv(icx, bx, 4), dlg_muldiv(icy, by, 8)};
        if (ex && id > 0xFFFF) id = (int32_t)(int16_t)(uint16_t)id;
        if (!ex) id = (int32_t)(int16_t)(uint16_t)(id & 0xFFFF);
        if (dlg_add_control(d, kind, id, ist, iex, rc, kind == DLG_K_EDIT ? NULL : text, tn) < 0) return -1;
    }
    d->open = true;
    return 0;
}

int32_t dlg_find(const Dialog *d, int32_t id) {
    for (int32_t i = 0; i < d->n; i++)
        if (d->ctl[i].id == id && d->ctl[i].kind != DLG_K_NONE) return i;
    return -1;
}

void dlg_set_caption(Dialog *d, const char *s, int32_t n) {
    if (n < 0) n = (int32_t)rt_strlen(s);
    n = imin(n, DLG_CAPTION_MAX - 1);
    rt_memcpy(d->caption, s, (size_t)n);
    d->caption[n] = 0;
    d->caption_len = n;
    d->dirty = true;
}

void dlg_set_item_text(Dialog *d, int32_t id, const char *s, int32_t n) {
    int32_t i = dlg_find(d, id);
    if (i < 0) return;
    if (n < 0) n = (int32_t)rt_strlen(s);
    DlgControl *c = &d->ctl[i];
    if (c->kind == DLG_K_EDIT) {
        DlgEdit *e = &d->edit;
        e->ext = NULL;
        uint32_t m = (uint32_t)imin(n, DLG_EDIT_MAX - 1);
        rt_memcpy(e->buf, s, m);
        e->buf[m] = 0;
        e->len = m;
        /* WM_SETTEXT: selection 0, view at the top, undo buffer empty (I). */
        e->sel_start = e->sel_end = 0;
        e->after_wrap = false;
        e->x_offset = 0;
        e->y_offset = 0;
        e->undo_len = e->undo_ins = e->undo_pos = 0;
        dlg_edit_layout(d);
    } else {
        n = imin(n, DLG_LABEL_MAX - 1);
        rt_memcpy(c->text, s, (size_t)n);
        c->text_len = n;
    }
    d->dirty = true;
}

void dlg_set_item_text_ext(Dialog *d, int32_t id, const char *s, uint32_t n) {
    int32_t i = dlg_find(d, id);
    if (i < 0 || d->ctl[i].kind != DLG_K_EDIT) return;
    DlgEdit *e = &d->edit;
    uint32_t m = 0;
    while (m < n && s[m]) m++; /* SetDlgItemTextA reads to the NUL (the ToS resource ends with one, V) */
    e->ext = s;
    e->len = m;
    e->sel_start = e->sel_end = 0;
    e->after_wrap = false;
    e->x_offset = e->y_offset = 0;
    e->undo_len = e->undo_ins = e->undo_pos = 0;
    dlg_edit_layout(d);
    d->dirty = true;
}

void dlg_show_item(Dialog *d, int32_t id, bool visible) {
    int32_t i = dlg_find(d, id);
    if (i < 0) return;
    d->ctl[i].visible = visible;
    if (visible) d->ctl[i].style |= DLG_WS_VISIBLE;
    else d->ctl[i].style &= ~DLG_WS_VISIBLE;
    d->dirty = true;
}

int32_t dlg_get_item_text(const Dialog *d, int32_t id, char *buf, int32_t max) {
    if (max <= 0) return 0;
    int32_t i = dlg_find(d, id);
    const char *s = "";
    int32_t n = 0;
    if (i >= 0) {
        if (d->ctl[i].kind == DLG_K_EDIT) {
            s = dlg_edit_text(&d->edit);
            n = (int32_t)d->edit.len;
        } else {
            s = d->ctl[i].text;
            n = d->ctl[i].text_len;
        }
    }
    n = imin(n, max - 1); /* GetDlgItemTextA(..., max): at most max - 1 characters and a NUL (V: Win32) */
    rt_memcpy(buf, s, (size_t)n);
    buf[n] = 0;
    return n;
}

/* ------------------------------------------------------------------ focus, default button */

static bool is_push(const DlgControl *c) { return c->kind == DLG_K_BUTTON; }

static bool can_focus(const DlgControl *c) {
    return c->visible && !(c->style & DLG_WS_DISABLED) && c->kind != DLG_K_NONE && c->kind != DLG_K_STATIC &&
           c->kind != DLG_K_ICON;
}

/* CheckDefPushButton (I, Windows dialog manager): exactly one push button looks default: the focused
 * push button, or else the button with the dialog's default id (DM_GETDEFID; IDOK when none). */
static void check_def(Dialog *d) {
    int32_t want = -1;
    if (d->focus >= 0 && is_push(&d->ctl[d->focus])) want = d->focus;
    else want = dlg_find(d, d->def_id ? d->def_id : DLG_IDOK);
    for (int32_t i = 0; i < d->n; i++) {
        DlgControl *c = &d->ctl[i];
        if (!is_push(c)) continue;
        bool def = (i == want);
        if (c->is_def != def) {
            c->is_def = def;
            d->dirty = true;
        }
    }
}

void dlg_set_focus(Dialog *d, int32_t index, bool select_all) {
    if (index < 0 || index >= d->n) return;
    int32_t old = d->focus;
    /* DlgSetFocus: an edit (DLGC_HASSETSEL) gets EM_SETSEL(0, -1) before SetFocus (I: Wine
     * DEFDLG_SetFocus; the visible effect "Name" selected is V: dialog_high_score_entry.png). */
    if (select_all && d->ctl[index].kind == DLG_K_EDIT) dlg_edit_set_sel(d, 0, d->edit.len);
    if (old != index) {
        if (old >= 0) {
            DlgControl *o = &d->ctl[old];
            if (o->kind == DLG_K_EDIT) dlg_edit_focus(d, false);
            if (o->kind == DLG_K_BUTTON && o->space_down) {
                o->space_down = false;
                o->pushed = false;
            }
        }
        d->focus = index;
        if (d->ctl[index].kind == DLG_K_EDIT) dlg_edit_focus(d, true);
    }
    check_def(d);
    d->dirty = true;
}

/* GetNextDlgTabItem: next (previous) visible, enabled control with WS_TABSTOP, wrapping (I: Win32). */
int32_t dlg_next_tab(const Dialog *d, int32_t from, bool previous) {
    if (d->n == 0) return -1;
    int32_t i = from < 0 ? (previous ? 0 : d->n - 1) : from;
    for (int32_t k = 0; k < d->n; k++) {
        i = previous ? (i + d->n - 1) % d->n : (i + 1) % d->n;
        const DlgControl *c = &d->ctl[i];
        if (can_focus(c) && (c->style & DLG_WS_TABSTOP)) return i;
    }
    return from;
}

/* GetNextDlgGroupItem: next (previous) visible, enabled control in the group of `from`; a group starts at
 * a WS_GROUP control (or the first control) and runs to the next WS_GROUP control; wraps inside the
 * group (I: Win32 documentation). Statics are skipped here (they cannot take the focus). */
int32_t dlg_next_group(const Dialog *d, int32_t from, bool previous) {
    if (from < 0) return -1;
    int32_t start = from;
    while (start > 0 && !(d->ctl[start].style & DLG_WS_GROUP)) start--;
    int32_t end = from + 1;
    while (end < d->n && !(d->ctl[end].style & DLG_WS_GROUP)) end++;
    int32_t len = end - start, i = from;
    for (int32_t k = 0; k < len; k++) {
        i = previous ? (i - start + len - 1) % len + start : (i - start + 1) % len + start;
        if (can_focus(&d->ctl[i])) return i;
    }
    return from;
}

void dlg_start(Dialog *d, uint32_t now, bool last_input_keyboard, int32_t focus_id) {
    d->now = now;
    /* UIS_INITIALIZE (I): keyboard last = cues shown, mouse last = focus and accelerators hidden. */
    d->ui_state = last_input_keyboard ? 0 : (DLG_UISF_HIDEFOCUS | DLG_UISF_HIDEACCEL);
    int32_t i = focus_id > 0 ? dlg_find(d, focus_id) : dlg_next_tab(d, -1, false);
    if (i >= 0) dlg_set_focus(d, i, focus_id <= 0);
    else check_def(d);
    d->open = true;
    d->dirty = true;
}

static void command(Dialog *d, int32_t id) {
    if (d->ncmd < (int32_t)RT_COUNTOF(d->cmd)) d->cmd[d->ncmd++] = id;
}

int32_t dlg_take_command(Dialog *d) {
    if (d->ncmd == 0) return 0;
    int32_t id = d->cmd[0];
    for (int32_t i = 1; i < d->ncmd; i++) d->cmd[i - 1] = d->cmd[i];
    d->ncmd--;
    return id;
}

/* ------------------------------------------------------------------ keyboard */

/* Mnemonic search (IsDialogMessage WM_CHAR when the focus does not want characters; I: Wine
 * DIALOG_IsAccelerator): from the focus control in template order, wrapping; first single '&'. */
static bool mnemonic(Dialog *d, uint32_t ch) {
    if (ch < 0x21 || ch == 0x7F) return false;
    uint32_t up = (ch >= 'a' && ch <= 'z') ? ch - 32 : ch;
    int32_t startc = d->focus < 0 ? 0 : d->focus;
    for (int32_t k = 0; k < d->n; k++) {
        int32_t i = (startc + k) % d->n;
        DlgControl *c = &d->ctl[i];
        if (!c->visible || (c->style & DLG_WS_DISABLED)) continue;
        if (c->kind != DLG_K_BUTTON && c->kind != DLG_K_STATIC && c->kind != DLG_K_CHECKBOX) continue;
        int32_t j = 0;
        for (; j + 1 < c->text_len; j++) {
            if (c->text[j] != '&') continue;
            if (c->text[j + 1] == '&') {
                j++;
                continue;
            }
            break;
        }
        if (j + 1 >= c->text_len) continue;
        uint32_t m = (uint8_t)c->text[j + 1];
        if (m >= 'a' && m <= 'z') m -= 32;
        if (m != up) continue;
        if (c->kind == DLG_K_STATIC) {
            /* focus to the static, then on to the next control */
            int32_t nx = dlg_next_tab(d, i, false);
            if (nx >= 0) dlg_set_focus(d, nx, true);
        } else {
            /* BM_CLICK: the button takes the focus, then BN_CLICKED */
            dlg_set_focus(d, i, false);
            command(d, c->id);
        }
        return true;
    }
    return false;
}

static void show_focus_cues(Dialog *d) {
    if (d->ui_state & DLG_UISF_HIDEFOCUS) {
        d->ui_state &= (uint8_t)~DLG_UISF_HIDEFOCUS;
        d->dirty = true;
    }
}

/* Returns true when the dialog manager handled the key (then TranslateMessage is not called: the
 * following WM_CHAR does not exist; I: IsDialogMessage returns before TranslateMessage). */
static bool key_down(Dialog *d, uint32_t vk) {
    if (vk == DLG_VK_SHIFT) d->shift_down = true;
    if (vk == DLG_VK_CONTROL) d->ctrl_down = true;
    DlgControl *f = d->focus >= 0 ? &d->ctl[d->focus] : NULL;
    bool in_edit = f && f->kind == DLG_K_EDIT;
    bool ml_edit = in_edit && d->edit.multiline;
    if (vk == DLG_VK_TAB || (vk >= DLG_VK_LEFT && vk <= DLG_VK_DOWN)) show_focus_cues(d);
    switch (vk) {
    case DLG_VK_TAB: {
        if (d->ctrl_down && ml_edit) return false; /* Ctrl+Tab in a multi-line edit: nothing here */
        int32_t nx = dlg_next_tab(d, d->focus, d->shift_down);
        if (nx >= 0) dlg_set_focus(d, nx, true);
        /* A multi-line edit gets the key and sends WM_NEXTDLGCTL itself; its WM_CHAR '\t' then goes to the
         * edit and is ignored there. Either way no character reaches the new focus. */
        return true;
    }
    case DLG_VK_RETURN:
        if (ml_edit) {
            /* Multi-line edit without ES_WANTRETURN (I: edit control): DM_GETDEFID; when a default
             * control exists, it takes the focus and gets the Enter key. */
            int32_t di = d->def_id ? dlg_find(d, d->def_id) : -1;
            if (di >= 0 && can_focus(&d->ctl[di])) {
                dlg_set_focus(d, di, false);
                command(d, d->ctl[di].id);
            }
            return true; /* the WM_CHAR '\r' goes to the edit, which ignores it */
        }
        if (f && is_push(f)) command(d, f->id);
        else {
            int32_t id = d->def_id ? d->def_id : DLG_IDOK;
            int32_t di = dlg_find(d, id);
            if (di < 0 || !(d->ctl[di].style & DLG_WS_DISABLED)) command(d, id);
        }
        return true;
    case DLG_VK_ESCAPE:
        /* IsDialogMessage (or WM_CLOSE from a multi-line edit): WM_COMMAND IDCANCEL (I). */
        command(d, DLG_IDCANCEL);
        return true;
    case DLG_VK_LEFT:
    case DLG_VK_UP:
    case DLG_VK_RIGHT:
    case DLG_VK_DOWN:
        if (in_edit) {
            dlg_edit_key(d, vk);
            return false;
        }
        if (f) {
            int32_t nx = dlg_next_group(d, d->focus, vk == DLG_VK_LEFT || vk == DLG_VK_UP);
            if (nx >= 0) dlg_set_focus(d, nx, true);
        }
        return true;
    case DLG_VK_SPACE:
        if (f && is_push(f) && !f->space_down) {
            /* BUTTON WM_KEYDOWN VK_SPACE: BM_SETSTATE(TRUE) (I) */
            f->space_down = true;
            f->pushed = true;
            d->dirty = true;
        }
        return false;
    default:
        if (in_edit) dlg_edit_key(d, vk);
        return false;
    }
}

static void key_up(Dialog *d, uint32_t vk) {
    if (vk == DLG_VK_SHIFT) d->shift_down = false;
    if (vk == DLG_VK_CONTROL) d->ctrl_down = false;
    if (vk == DLG_VK_SPACE && d->focus >= 0) {
        DlgControl *f = &d->ctl[d->focus];
        if (is_push(f) && f->space_down) {
            bool was = f->pushed;
            f->space_down = false;
            f->pushed = false;
            d->dirty = true;
            if (was) command(d, f->id);
        }
    }
}

static void on_char(Dialog *d, uint32_t ch) {
    DlgControl *f = d->focus >= 0 ? &d->ctl[d->focus] : NULL;
    if (f && f->kind == DLG_K_EDIT) {
        dlg_edit_char(d, ch); /* edits want characters (DLGC_WANTCHARS) */
        return;
    }
    mnemonic(d, ch);
}

/* ------------------------------------------------------------------ mouse */

static int32_t hit_control(const Dialog *d, int32_t cx, int32_t cy) {
    for (int32_t i = 0; i < d->n; i++) {
        const DlgControl *c = &d->ctl[i];
        if (!c->visible || c->kind == DLG_K_NONE || c->kind == DLG_K_STATIC || c->kind == DLG_K_ICON) continue;
        if (pt_in(&c->r, cx, cy)) return i; /* statics are HTTRANSPARENT (I) */
    }
    return -1;
}

static bool in_close(const Dialog *d, int32_t wx, int32_t wy) {
    return d->close_button && pt_in(&(DlgRect){d->geom.close.x, d->geom.close.y, d->geom.close.w, d->geom.close.h}, wx, wy);
}

static void set_close(Dialog *d, bool hot, bool pushed) {
    if (d->close_hot != hot || d->close_pushed != pushed) {
        d->close_hot = hot;
        d->close_pushed = pushed;
        d->dirty = true;
    }
}

static void move_window(Dialog *d, int32_t x, int32_t y) {
    x = imax(0, imin(x, d->env.frame_w - d->geom.win_w));
    y = imax(0, imin(y, d->env.frame_h - d->geom.win_h));
    if (x == d->win_x && y == d->win_y) return;
    if (!d->moved) {
        d->old_x = d->win_x;
        d->old_y = d->win_y;
    }
    d->moved = true;
    d->win_x = x;
    d->win_y = y;
}

static bool mouse(Dialog *d, uint32_t kind, uint32_t button, int32_t x, int32_t y) {
    int32_t wx = x - d->win_x, wy = y - d->win_y;
    int32_t cx = wx - d->geom.client.x, cy = wy - d->geom.client.y;
    bool inside = wx >= 0 && wy >= 0 && wx < d->geom.win_w && wy < d->geom.win_h;
    d->mouse_x = x;
    d->mouse_y = y;
    d->mouse_inside = inside;
    if (kind == DLG_IN_MOUSEMOVE) {
        if (d->dragging) {
            move_window(d, x - d->drag_dx, y - d->drag_dy);
            return true;
        }
        if (d->close_capture) {
            bool in = in_close(d, wx, wy);
            set_close(d, false, in);
            return true;
        }
        if (d->capture >= 0) {
            DlgControl *c = &d->ctl[d->capture];
            if (c->kind == DLG_K_BUTTON) {
                bool in = pt_in(&c->r, cx, cy);
                if (c->pushed != in) {
                    c->pushed = in;
                    d->dirty = true;
                }
            } else if (c->kind == DLG_K_EDIT) {
                if (d->sb_mode != DLG_SB_NONE)
                    dlg_sb_mouse(d, kind, cx - c->r.x - d->edit.sb.x, cy - c->r.y - d->edit.sb.y);
                else dlg_edit_mouse(d, kind, cx - c->r.x, cy - c->r.y);
            }
            return true;
        }
        set_close(d, in_close(d, wx, wy), false);
        return inside;
    }
    if (button != 0) return inside; /* right and middle buttons: no action (context menus not modelled) */
    if (kind == DLG_IN_BUTTONDOWN) {
        if (!inside) return false;
        if (in_close(d, wx, wy)) {
            d->close_capture = true;
            set_close(d, false, true);
            return true;
        }
        if (wy < d->geom.top) {
            if (wy >= d->geom.frame && wx >= d->geom.frame && wx < d->geom.win_w - d->geom.frame) {
                d->dragging = true; /* HTCAPTION: SC_MOVE with full drag (XP default) */
                d->drag_dx = x - d->win_x;
                d->drag_dy = y - d->win_y;
            }
            return true;
        }
        int32_t i = hit_control(d, cx, cy);
        if (i < 0) return true;
        DlgControl *c = &d->ctl[i];
        if (c->kind == DLG_K_BUTTON) {
            /* BUTTON WM_LBUTTONDOWN: SetFocus, BM_SETSTATE(TRUE), SetCapture (I) */
            dlg_set_focus(d, i, false);
            c->pushed = true;
            d->capture = i;
            d->dirty = true;
        } else if (c->kind == DLG_K_EDIT) {
            int32_t ex = cx - c->r.x, ey = cy - c->r.y;
            DlgEdit *e = &d->edit;
            if (e->vscroll && pt_in(&e->sb, ex, ey)) {
                /* non-client scroll bar: no focus change (I) */
                if (dlg_sb_mouse(d, kind, ex - e->sb.x, ey - e->sb.y)) d->capture = i;
            } else if (pt_in(&e->client, ex, ey)) {
                dlg_set_focus(d, i, false);
                d->capture = i;
                dlg_edit_mouse(d, kind, ex, ey);
            }
        }
        return true;
    }
    if (kind == DLG_IN_BUTTONUP) {
        if (d->dragging) {
            d->dragging = false;
            return true;
        }
        if (d->close_capture) {
            d->close_capture = false;
            bool in = in_close(d, wx, wy);
            set_close(d, in, false);
            if (in) command(d, DLG_IDCANCEL); /* SC_CLOSE: WM_CLOSE, DefDlgProc sends IDCANCEL (I) */
            return true;
        }
        if (d->capture >= 0) {
            int32_t i = d->capture;
            DlgControl *c = &d->ctl[i];
            d->capture = -1;
            if (c->kind == DLG_K_BUTTON) {
                bool was = c->pushed && pt_in(&c->r, cx, cy);
                c->pushed = false;
                d->dirty = true;
                if (was) command(d, c->id);
            } else if (c->kind == DLG_K_EDIT) {
                if (d->sb_mode != DLG_SB_NONE)
                    dlg_sb_mouse(d, kind, cx - c->r.x - d->edit.sb.x, cy - c->r.y - d->edit.sb.y);
                else dlg_edit_mouse(d, kind, cx - c->r.x, cy - c->r.y);
            }
            return true;
        }
        return inside;
    }
    return inside;
}

/* ------------------------------------------------------------------ input entry */

bool dlg_input(Dialog *d, uint32_t kind, int32_t a, int32_t b, uint32_t now) {
    if (!d->open) return false;
    d->now = now;
    uint32_t k = kind & 0xFFu;
    bool drop = d->drop_char;
    d->drop_char = false;
    switch (k) {
    case DLG_IN_KEYDOWN:
        d->drop_char = key_down(d, (uint32_t)a);
        return true;
    case DLG_IN_KEYUP:
        key_up(d, (uint32_t)a);
        return true;
    case DLG_IN_CHAR:
        if (!drop) on_char(d, (uint32_t)a & 0xFFu);
        return true;
    case DLG_IN_MOUSEMOVE:
    case DLG_IN_BUTTONDOWN:
    case DLG_IN_BUTTONUP:
        return mouse(d, k, (kind >> 8) & 0xFFu, a, b);
    case DLG_IN_FOCUS_LOST:
        /* WM_ACTIVATE inactive: caption inactive, WM_KILLFOCUS to the focus control, capture released (I). */
        d->active = false;
        d->shift_down = d->ctrl_down = false;
        if (d->focus >= 0 && d->ctl[d->focus].kind == DLG_K_EDIT) dlg_edit_focus(d, false);
        for (int32_t i = 0; i < d->n; i++) d->ctl[i].pushed = d->ctl[i].space_down = false;
        d->capture = -1;
        d->dragging = d->close_capture = false;
        d->sb_mode = DLG_SB_NONE;
        d->edit.selecting = false;
        set_close(d, false, false);
        d->dirty = true;
        return true;
    case DLG_IN_FOCUS_GAINED:
        d->active = true;
        if (d->focus >= 0 && d->ctl[d->focus].kind == DLG_K_EDIT) dlg_edit_focus(d, true);
        d->dirty = true;
        return true;
    default:
        return false;
    }
}

void dlg_wheel(Dialog *d, int32_t delta, uint32_t now) {
    if (!d->open) return;
    d->now = now;
    /* WM_MOUSEWHEEL goes to the focus window; DefWindowProc passes it to the parent (V: Win32
     * documentation). Only the multi-line edit scrolls; a button or the dialog ignore it. */
    if (d->focus < 0 || d->ctl[d->focus].kind != DLG_K_EDIT || !d->edit.multiline) return;
    DlgEdit *e = &d->edit;
    e->wheel_acc -= delta;
    if (e->wheel_acc >= 120 || e->wheel_acc <= -120) {
        int32_t lines = imin(e->nlines, DLG_WHEEL_LINES) * (e->wheel_acc / 120);
        e->wheel_acc %= 120;
        dlg_edit_scroll_lines(d, lines);
    }
}

bool dlg_tick(Dialog *d, uint32_t now) {
    if (!d->open) return false;
    d->now = now;
    bool changed = dlg_sb_tick(d);
    bool want = false;
    if (d->active && d->focus >= 0 && d->ctl[d->focus].kind == DLG_K_EDIT)
        want = (((now - d->caret_t0) / DLG_CARET_BLINK_MS) & 1u) == 0;
    if (want != d->caret_on) {
        d->caret_on = want;
        changed = true;
    }
    if (changed) d->dirty = true;
    return d->dirty;
}

void dlg_caret_reset(Dialog *d) {
    d->caret_t0 = d->now;
    d->caret_on = d->active && d->focus >= 0 && d->ctl[d->focus].kind == DLG_K_EDIT;
    d->dirty = true;
}

int32_t dlg_cursor(const Dialog *d, int32_t x, int32_t y) {
    int32_t wx = x - d->win_x, wy = y - d->win_y;
    if (!d->open || wx < 0 || wy < 0 || wx >= d->geom.win_w || wy >= d->geom.win_h) return DLG_CURSOR_NONE;
    if (d->capture >= 0 && d->ctl[d->capture].kind == DLG_K_EDIT && d->edit.selecting) return DLG_CURSOR_IBEAM;
    int32_t cx = wx - d->geom.client.x, cy = wy - d->geom.client.y;
    int32_t i = hit_control(d, cx, cy);
    if (i >= 0 && d->ctl[i].kind == DLG_K_EDIT) {
        DlgRect cl = d->edit.client;
        cl.x += d->ctl[i].r.x;
        cl.y += d->ctl[i].r.y;
        if (pt_in(&cl, cx, cy)) return DLG_CURSOR_IBEAM;
    }
    return DLG_CURSOR_ARROW;
}

/* ------------------------------------------------------------------ drawing */

/* Classic push button (I: user32 BUTTON, Windows 2000 look):
 * - default look: 1-pixel COLOR_WINDOWFRAME (black) frame, then the face inside it;
 * - normal: DrawFrameControl(DFCS_BUTTONPUSH) = DrawEdge(EDGE_RAISED, BF_SOFT | BF_MIDDLE);
 * - pushed default button: DFCS_PUSHED | DFCS_FLAT = flat 1-pixel COLOR_3DSHADOW frame;
 * - label: DrawText(DT_CENTER | DT_VCENTER | DT_SINGLELINE) in the face rectangle, +1/+1 when pushed;
 *   mnemonic underline hidden with UISF_HIDEACCEL;
 * - focus: DrawFocusRect inset 3 pixels from the outer edge (4 with the default frame): edge (2) plus a
 *   1-pixel gap (I: recalled Windows 2000/XP classic buttons), hidden with UISF_HIDEFOCUS. */
static void draw_button(Dialog *d, const DlgControl *c, int32_t ox, int32_t oy, const Clip *pc) {
    Clip cl = {imax(pc->l, ox), imax(pc->t, oy), imin(pc->r, ox + c->r.w), imin(pc->b, oy + c->r.h)};
    DlgRect r = {ox, oy, c->r.w, c->r.h};
    if (c->is_def) {
        frame_lines(&d->img, &cl, r.x, r.y, r.w, r.h, LUNA_COLOR_WINDOWFRAME, LUNA_COLOR_WINDOWFRAME, d);
        r = (DlgRect){r.x + 1, r.y + 1, r.w - 2, r.h - 2};
    }
    if (c->pushed) {
        if (c->is_def) draw_edge(&d->img, &cl, d, r, EDGE_SUNKEN, BF_FLAT | BF_MIDDLE | BF_SOFT);
        else draw_edge(&d->img, &cl, d, r, EDGE_SUNKEN, BF_SOFT | BF_MIDDLE);
    } else {
        draw_edge(&d->img, &cl, d, r, EDGE_RAISED, BF_SOFT | BF_MIDDLE);
    }
    DtText t;
    uint32_t fl = DLG_DT_CENTER | DLG_DT_VCENTER | DLG_DT_SINGLELINE;
    if (d->ui_state & DLG_UISF_HIDEACCEL) fl |= DLG_DT_HIDEPREFIX;
    dt_layout(&t, d->font, c->text, c->text_len, r.w, fl);
    DlgRect tr = r;
    if (c->pushed) {
        tr.x++;
        tr.y++;
    }
    GdiRect gc = {cl.l, cl.t, cl.r, cl.b};
    dt_draw(&d->img, &t, d->font, tr, &gc, fl, pixel(d, LUNA_COLOR_BTNTEXT), d->env.smoothing);
    int32_t idx = (int32_t)(c - d->ctl);
    if (idx == d->focus && !(d->ui_state & DLG_UISF_HIDEFOCUS)) {
        int32_t in = 3 + (c->is_def ? 1 : 0);
        focus_rect(&d->img, &cl, (DlgRect){ox + in, oy + in, c->r.w - 2 * in, c->r.h - 2 * in}, ox, oy);
    }
}

/* Static text (I: user32 STATIC): background COLOR_3DFACE (WM_CTLCOLORSTATIC default), text
 * COLOR_WINDOWTEXT, DrawText(DT_WORDBREAK | DT_EXPANDTABS | alignment | SS_NOPREFIX, SS_EDITCONTROL),
 * clipped to the control; UISF_HIDEACCEL adds DT_HIDEPREFIX. */
static void draw_static(Dialog *d, const DlgControl *c, int32_t ox, int32_t oy, const Clip *pc) {
    Clip cl = {imax(pc->l, ox), imax(pc->t, oy), imin(pc->r, ox + c->r.w), imin(pc->b, oy + c->r.h)};
    fill(&d->img, &cl, ox, oy, c->r.w, c->r.h, pixel(d, LUNA_COLOR_3DFACE));
    uint32_t fl = DLG_DT_WORDBREAK | DLG_DT_EXPANDTABS;
    uint32_t a = c->style & DLG_SS_TYPEMASK;
    if (a == DLG_SS_CENTER) fl |= DLG_DT_CENTER;
    else if (a == DLG_SS_RIGHT) fl |= DLG_DT_RIGHT;
    if (c->style & DLG_SS_NOPREFIX) fl |= DLG_DT_NOPREFIX;
    if (c->style & DLG_SS_EDITCONTROL) fl |= DLG_DT_EDITCONTROL;
    if (d->ui_state & DLG_UISF_HIDEACCEL) fl |= DLG_DT_HIDEPREFIX;
    DtText t;
    dt_layout(&t, d->font, c->text, c->text_len, c->r.w, fl);
    GdiRect gc = {cl.l, cl.t, cl.r, cl.b};
    dt_draw(&d->img, &t, d->font, (DlgRect){ox, oy, c->r.w, c->r.h}, &gc, fl, pixel(d, LUNA_COLOR_WINDOWTEXT),
            d->env.smoothing);
}

/* SS_ICON (MessageBox icon): DrawIcon of a 32x32 32-bit icon with alpha (I: per-pixel blend
 * d = (s * a + d * (255 - a) + 127) / 255). Without icon data nothing is drawn (the place stays). */
static void draw_icon(Dialog *d, const DlgControl *c, int32_t ox, int32_t oy, const Clip *pc) {
    if (!d->icon_rgba) return;
    for (int32_t y = 0; y < 32 && y < c->r.h; y++)
        for (int32_t x = 0; x < 32 && x < c->r.w; x++) {
            int32_t px = ox + x, py = oy + y;
            if (px < pc->l || px >= pc->r || py < pc->t || py >= pc->b) continue;
            const uint8_t *s = d->icon_rgba + (y * 32 + x) * 4;
            uint32_t a = s[3];
            if (a == 0) continue;
            uint32_t *p = &d->img.px[py * d->img.stride + px];
            uint32_t r = (s[0] * a + IMG_R(*p) * (255u - a) + 127u) / 255u;
            uint32_t g = (s[1] * a + IMG_G(*p) * (255u - a) + 127u) / 255u;
            uint32_t b = (s[2] * a + IMG_B(*p) * (255u - a) + 127u) / 255u;
            *p = IMG_RGB(r, g, b);
        }
}

void dlg_draw(Dialog *d, bool force) {
    if (!d->open || (!d->dirty && !force)) return;
    Image *img = &d->img;
    for (int32_t i = 0; i < img->w * img->h; i++) img->px[i] = IMG_KEY;
    LunaWindow w = {d->client_w, d->client_h, d->active, d->close_button,
                    (uint8_t)(d->close_pushed ? LUNA_BTN_PUSHED : d->close_hot ? LUNA_BTN_HOT : LUNA_BTN_NORMAL),
                    d->caption, d->caption_len};
    if (d->env.luna && d->env.luna->loaded) {
        luna_draw_window(d->env.luna, img, 0, 0, &w, d->env.caption_font, d->env.smoothing, NULL);
    } else {
        Clip all = clip_of(img, 0, 0, img->w, img->h);
        fill(img, &all, 0, 0, img->w, img->h, pixel(d, LUNA_COLOR_3DFACE));
    }
    Clip cc = clip_of(img, d->geom.client.x, d->geom.client.y, d->client_w, d->client_h);
    for (int32_t i = 0; i < d->n; i++) {
        DlgControl *c = &d->ctl[i];
        if (!c->visible) continue;
        int32_t ox = d->geom.client.x + c->r.x, oy = d->geom.client.y + c->r.y;
        switch (c->kind) {
        case DLG_K_BUTTON: draw_button(d, c, ox, oy, &cc); break;
        case DLG_K_STATIC: draw_static(d, c, ox, oy, &cc); break;
        case DLG_K_ICON: draw_icon(d, c, ox, oy, &cc); break;
        case DLG_K_EDIT: dlg_edit_draw(d, c, ox, oy); break;
        default: break; /* checkbox: only in IDD_TERMSOFSERVICE, removed (decision 5) */
        }
    }
    d->dirty = false;
}

void dlg_compose(const Dialog *d, uint8_t *frame_rgba, int32_t fw, int32_t fh) {
    if (!d->open) return;
    for (int32_t y = 0; y < d->img.h; y++) {
        int32_t fy = d->win_y + y;
        if (fy < 0 || fy >= fh) continue;
        const uint32_t *src = d->img.px + y * d->img.stride;
        for (int32_t x = 0; x < d->img.w; x++) {
            int32_t fx = d->win_x + x;
            if (fx < 0 || fx >= fw || IMG_A(src[x]) == 0) continue;
            uint8_t *p = frame_rgba + ((size_t)fy * (size_t)fw + (size_t)fx) * 4u;
            p[0] = (uint8_t)IMG_R(src[x]);
            p[1] = (uint8_t)IMG_G(src[x]);
            p[2] = (uint8_t)IMG_B(src[x]);
            p[3] = 255;
        }
    }
}

/* exported for dialog_edit.c */
uint32_t dlg_pixel(const Dialog *d, int32_t index) { return pixel(d, index); }
void dlg_fill(Image *img, int32_t l, int32_t t, int32_t r, int32_t b, int32_t x, int32_t y, int32_t w, int32_t h,
              uint32_t px) {
    Clip c = {l, t, r, b};
    fill(img, &c, x, y, w, h, px);
}
void dlg_fill_pattern(Image *img, int32_t l, int32_t t, int32_t r, int32_t b, int32_t x, int32_t y, int32_t w, int32_t h,
                      int32_t ox, int32_t oy, uint32_t set, uint32_t clear) {
    Clip c = {l, t, r, b};
    fill_pattern(img, &c, x, y, w, h, ox, oy, set, clear);
}
void dlg_draw_edge(Dialog *d, int32_t l, int32_t t, int32_t r, int32_t b, DlgRect rc, uint32_t edge, uint32_t flags) {
    Clip c = {l, t, r, b};
    draw_edge(&d->img, &c, d, rc, edge, flags);
}
void dlg_invert(Image *img, int32_t l, int32_t t, int32_t r, int32_t b, int32_t x, int32_t y) {
    Clip c = {l, t, r, b};
    invert(img, &c, x, y);
}
void dlg_put(Image *img, int32_t l, int32_t t, int32_t r, int32_t b, int32_t x, int32_t y, uint32_t px) {
    Clip c = {l, t, r, b};
    put(img, &c, x, y, px);
}
