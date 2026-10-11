/* EDIT control (single-line and read-only multi-line) and its vertical scroll bar. See dialog.h.
 *
 * Rules and status (V = verified, I = inferred; no Windows ground truth, decision 4c):
 * - Geometry: WS_EX_CLIENTEDGE border 2 px (I); client area inside it; WS_VSCROLL bar of
 *   SM_CXVSCROLL = 17 px (V: Luna [SysMetrics] ScrollbarWidth 17) on the right. Formatting rectangle =
 *   client inset 1 px left/right, and 1 px top/bottom when the client is at least line height + 2
 *   (I: Wine EDIT_SetRectNP; V: text and highlight start at (9, 44) in
 *   analysis/reference/screens/dialog_high_score_entry.png). Margins 0 for raster fonts (MS Sans
 *   Serif), base_x / 2 for TrueType (I: EC_USEFONTINFO). Multi-line: visible lines = height / line
 *   height, the formatting rectangle ends after the last whole line (I).
 * - Colours: COLOR_WINDOW background and COLOR_WINDOWTEXT text; a read-only edit sends
 *   WM_CTLCOLORSTATIC, so its background is COLOR_3DFACE (V: Win32 documentation); selection
 *   COLOR_HIGHLIGHT / COLOR_HIGHLIGHTTEXT, hidden while the edit has no focus (no ES_NOHIDESEL).
 * - Word wrap (ES_MULTILINE without ES_AUTOHSCROLL): lines end at CR LF; a longer paragraph breaks
 *   after the last space run that follows the longest fitting prefix; spaces at the break stay on the
 *   upper line and may extend past the right edge ("hanging" spaces, I: Windows edit / Notepad
 *   behaviour as recalled); a word longer than the line breaks at the character that does not fit (I).
 * - Single-line ES_AUTOHSCROLL: x_offset in characters; when the caret leaves the formatting rectangle
 *   the text scrolls until the caret is 1/3 of the width inside (I: Wine EDIT_EM_ScrollCaret,
 *   HSCROLL_FRACTION 3).
 * - Caret: 1 x line height, drawn by inverting pixels, clipped to the client area; blink period
 *   530 ms (I: XP default GetCaretBlinkTime) on the virtual clock; a caret move restarts the cycle in
 *   the visible phase (I).
 * - Keys (I: Wine EDIT_WM_KeyDown / EDIT_WM_Char, which follow Windows): Left/Up and Right/Down move
 *   by one character in a single-line edit; Ctrl moves by words; Shift extends; Home/End; Delete;
 *   Backspace; Ctrl+Z undo (single level, Wine undo model); Ctrl+Backspace inserts 0x7F (XP edit without
 *   auto-complete, I). Clipboard keys (Ctrl+C/V/X, Shift+Ins/Del, Ctrl+Ins) do nothing: the port has no
 *   clipboard access (port decision). Multi-line: Up/Down by line, PgUp/PgDn scroll one page and move
 *   the caret by one page (I), Ctrl+Home/End.
 * - Mouse: click places the caret at the nearest character boundary (ties to the left, I: Wine
 *   EDIT_CharFromPos); Shift+click extends; drag selects; double click (500 ms, 4 x 4 px, I: XP
 *   defaults) selects the word and its trailing spaces (I).
 * - Mouse wheel: 3 lines per 120 units (V: SPI_GETWHEELSCROLLLINES default 3; I: Wine EDIT
 *   WM_MOUSEWHEEL accumulation), only while the edit has the focus (dialog.c).
 * - Scroll bar: classic look; geometry of Windows CalcSBStuff2 (I: recalled Windows 2000 source):
 *   arrows min(h / 2, SM_CYVSCROLL), thumb max(SM_CYVSCROLL / 2, MulDiv(track, page, range)), thumb top
 *   MulDiv(pos, travel, range - page) + arrow; range = line count, page = visible lines, pos = first
 *   visible line (I: Wine EDIT_UpdateScrollInfo). Track: gray pattern of COLOR_3DHILIGHT and COLOR_3DFACE
 *   because 3DHILIGHT equals COLOR_WINDOW (I: DefWindowProc WM_CTLCOLORSCROLLBAR); pressed page area
 *   drawn with the inverted pattern (I). Arrows and thumb: DrawEdge(EDGE_RAISED, BF_MIDDLE) without
 *   BF_SOFT; pressed arrow flat with the glyph moved by 1 px (I). Arrow glyph: triangle of the Marlett
 *   approximation in Wine uitools.c (I; the Marlett font is not available). Line and page clicks
 *   repeat after 200 ms every 50 ms (I: Wine values); page repeat stops when the thumb reaches the
 *   pointer (I). Thumb drag scrolls during the drag (SB_THUMBTRACK) (I). */
#include "dialog.h"
#include "dialog_int.h"

static int32_t imin(int32_t a, int32_t b) { return a < b ? a : b; }
static int32_t imax(int32_t a, int32_t b) { return a > b ? a : b; }

const char *dlg_edit_text(const DlgEdit *e) { return e->ext ? e->ext : e->buf; }

static int32_t cxs(const Dialog *d, const char *s, int32_t n) {
    int32_t cx, cy;
    gdi_get_text_extent_point32(d->font, s, n, &cx, &cy);
    return cx;
}

static int32_t adv(const Dialog *d, char ch) {
    TextGlyph g;
    atlas_glyph(d->font->mono, (uint8_t)ch, &g);
    return g.adv;
}

/* ------------------------------------------------------------------ geometry and layout */

void dlg_edit_init(Dialog *d, DlgControl *c) {
    DlgEdit *e = &d->edit;
    rt_memset(e, 0, sizeof *e);
    e->multiline = (c->style & DLG_ES_MULTILINE) != 0;
    e->readonly = (c->style & DLG_ES_READONLY) != 0;
    e->autohscroll = (c->style & DLG_ES_AUTOHSCROLL) != 0;
    e->nohidesel = (c->style & DLG_ES_NOHIDESEL) != 0;
    e->vscroll = e->multiline && (c->style & DLG_WS_VSCROLL) != 0;
    int32_t b = (c->exstyle & DLG_WS_EX_CLIENTEDGE) ? 2 : ((c->style & DLG_WS_BORDER) ? 1 : 0);
    e->client = (DlgRect){b, b, imax(c->r.w - 2 * b, 0), imax(c->r.h - 2 * b, 0)};
    int32_t sbw = (d->env.luna && d->env.luna->loaded) ? luna_metric(d->env.luna, LUNA_M_SCROLLBAR_WIDTH) : 17;
    if (sbw <= 0) sbw = 17;
    if (e->vscroll) {
        e->client.w = imax(e->client.w - sbw, 0);
        e->sb = (DlgRect){b + e->client.w, b, sbw, e->client.h};
    }
    e->line_h = d->tm.tmHeight;
    e->fmt = e->client;
    if (c->exstyle & DLG_WS_EX_CLIENTEDGE) {
        e->fmt.x += 1;
        e->fmt.w -= 2;
        if (e->fmt.h >= e->line_h + 2) {
            e->fmt.y += 1;
            e->fmt.h -= 2;
        }
    }
    int32_t m = (d->font->mono->flags & ATLAS_F_RASTER) ? 0 : d->base_x / 2;
    e->fmt.x += m;
    e->fmt.w -= 2 * m;
    e->fmt.w = imax(e->fmt.w, d->tm.tmAveCharWidth);
    if (e->multiline) {
        e->vlc = imax(1, e->fmt.h / e->line_h);
        e->fmt.h = e->vlc * e->line_h;
    } else {
        e->vlc = 1;
        e->fmt.h = e->line_h;
    }
    e->fmt.h = imin(e->fmt.h, e->client.y + e->client.h - e->fmt.y);
    e->nlines = 1;
}

void dlg_edit_layout(Dialog *d) {
    DlgEdit *e = &d->edit;
    const char *t = dlg_edit_text(e);
    int32_t n = (int32_t)e->len;
    if (!e->multiline) {
        e->nlines = 1;
        e->line_start[0] = 0;
        e->line_len[0] = (uint32_t)n;
        return;
    }
    bool wrap = !e->autohscroll;
    int32_t fw = e->fmt.w, pos = 0;
    e->nlines = 0;
    for (;;) {
        int32_t pend = n;
        for (int32_t i = pos; i + 1 < n; i++)
            if (t[i] == '\r' && t[i + 1] == '\n') {
                pend = i;
                break;
            }
        do {
            int32_t le = pend;
            if (wrap) {
                int32_t k = 0, w = 0;
                while (pos + k < pend) {
                    int32_t a = adv(d, t[pos + k]);
                    if (w + a > fw) break;
                    w += a;
                    k++;
                }
                if (pos + k < pend) {
                    int32_t j = pos + k;
                    if (t[j] == ' ') {
                        while (j < pend && t[j] == ' ') j++; /* hanging spaces stay on this line */
                        le = j;
                    } else {
                        int32_t jj = j;
                        while (jj > pos && t[jj - 1] != ' ') jj--;
                        le = (jj == pos) ? pos + imax(k, 1) : jj;
                    }
                }
            }
            if (e->nlines >= DLG_ML_LINES) return; /* port limit; ToS needs 360 */
            e->line_start[e->nlines] = (uint32_t)pos;
            e->line_len[e->nlines] = (uint32_t)(le - pos);
            e->nlines++;
            pos = le;
        } while (pos < pend);
        if (pend >= n) break;
        pos = pend + 2;
    }
    int32_t maxoff = imax(0, e->nlines - e->vlc);
    if (e->y_offset > maxoff) e->y_offset = maxoff;
}

static bool soft_start(const DlgEdit *e, int32_t line) {
    return line > 0 && e->line_start[line] == e->line_start[line - 1] + e->line_len[line - 1];
}

int32_t dlg_edit_line_of(const DlgEdit *e, uint32_t idx, bool after_wrap) {
    int32_t lo = 0, hi = e->nlines - 1;
    while (lo < hi) {
        int32_t mid = (lo + hi + 1) / 2;
        if (e->line_start[mid] <= idx) lo = mid;
        else hi = mid - 1;
    }
    if (after_wrap && lo > 0 && idx == e->line_start[lo] && soft_start(e, lo)) lo--;
    return lo;
}

/* Position of the boundary before character idx, control coordinates (EM_POSFROMCHAR). */
static void pos_from_char(const Dialog *d, uint32_t idx, bool after_wrap, int32_t *x, int32_t *y) {
    const DlgEdit *e = &d->edit;
    const char *t = dlg_edit_text(e);
    if (!e->multiline) {
        *x = e->fmt.x + cxs(d, t, (int32_t)idx) - cxs(d, t, e->x_offset);
        *y = e->fmt.y;
        return;
    }
    int32_t line = dlg_edit_line_of(e, idx, after_wrap);
    uint32_t ls = e->line_start[line];
    *x = e->fmt.x + cxs(d, t + ls, (int32_t)(idx - ls));
    *y = e->fmt.y + (line - e->y_offset) * e->line_h;
}

/* Nearest character boundary to rx (pixels from the line start) in t[start .. start + len]; ties to
 * the left (Wine EDIT_CharFromPos). */
static uint32_t nearest(const Dialog *d, const char *t, uint32_t start, uint32_t len, int32_t rx) {
    if (rx <= 0) return start;
    int32_t xl = 0;
    for (uint32_t i = 0; i < len; i++) {
        int32_t xh = xl + adv(d, t[start + i]);
        if (rx < xh) return (xh - rx + 1 <= rx - xl) ? start + i + 1 : start + i;
        xl = xh;
    }
    return start + len;
}

static uint32_t char_from_pos(const Dialog *d, int32_t x, int32_t y, bool *after_wrap) {
    const DlgEdit *e = &d->edit;
    const char *t = dlg_edit_text(e);
    *after_wrap = false;
    if (!e->multiline) return nearest(d, t, 0, e->len, x - e->fmt.x + cxs(d, t, e->x_offset));
    int32_t dy = y - e->fmt.y;
    int32_t line = (dy >= 0 ? dy / e->line_h : -((-dy + e->line_h - 1) / e->line_h)) + e->y_offset;
    line = imax(0, imin(line, e->nlines - 1));
    uint32_t ls = e->line_start[line], ll = e->line_len[line];
    uint32_t idx = nearest(d, t, ls, ll, x - e->fmt.x);
    if (idx == ls + ll && line + 1 < e->nlines && soft_start(e, line + 1)) *after_wrap = true;
    return idx;
}

/* ------------------------------------------------------------------ selection, scrolling */

static void caret_moved(Dialog *d) {
    dlg_caret_reset(d);
    d->dirty = true;
}

void dlg_edit_set_sel(Dialog *d, uint32_t start, uint32_t end) {
    DlgEdit *e = &d->edit;
    if (start > e->len) start = e->len;
    if (end > e->len) end = e->len;
    bool moved = e->sel_end != end || e->after_wrap;
    e->sel_start = start;
    e->sel_end = end;
    e->after_wrap = false;
    if (moved) caret_moved(d);
    d->dirty = true;
}

void dlg_edit_scroll_lines(Dialog *d, int32_t dy) {
    DlgEdit *e = &d->edit;
    if (!e->multiline) return;
    int32_t ny = imax(0, e->y_offset + dy);
    if (ny >= e->nlines - e->vlc) ny = imax(0, e->nlines - e->vlc);
    if (ny != e->y_offset) {
        e->y_offset = ny;
        d->dirty = true;
    }
}

void dlg_edit_scroll_caret(Dialog *d) {
    DlgEdit *e = &d->edit;
    if (e->multiline) {
        int32_t line = dlg_edit_line_of(e, e->sel_end, e->after_wrap);
        if (line < e->y_offset) e->y_offset = line;
        else if (line >= e->y_offset + e->vlc) e->y_offset = line - e->vlc + 1;
        d->dirty = true;
        return;
    }
    if (!e->autohscroll) return;
    int32_t x, y, fw = e->fmt.w, right = e->fmt.x + e->fmt.w;
    pos_from_char(d, e->sel_end, false, &x, &y);
    if (x < e->fmt.x) {
        int32_t goal = e->fmt.x + fw / 3;
        do {
            e->x_offset--;
            pos_from_char(d, e->sel_end, false, &x, &y);
        } while (x < goal && e->x_offset > 0);
        if (e->x_offset < 0) e->x_offset = 0;
        d->dirty = true;
    } else if (x > right) {
        int32_t goal = right - fw / 3, xl;
        do {
            e->x_offset++;
            pos_from_char(d, e->sel_end, false, &x, &y);
            pos_from_char(d, e->len, false, &xl, &y);
        } while (x > goal && xl > right && e->x_offset < (int32_t)e->len);
        d->dirty = true;
    }
}

static void move_to(Dialog *d, uint32_t idx, bool extend, bool after_wrap) {
    DlgEdit *e = &d->edit;
    dlg_edit_set_sel(d, extend ? e->sel_start : idx, idx);
    e->after_wrap = after_wrap;
    dlg_edit_scroll_caret(d);
}

/* ------------------------------------------------------------------ editing */

static void undo_empty(DlgEdit *e) { e->undo_len = e->undo_ins = e->undo_pos = 0; }

void dlg_edit_replace_sel(Dialog *d, const char *s, uint32_t n, bool can_undo) {
    DlgEdit *e = &d->edit;
    if (e->ext) return; /* external text is immutable (read-only ToS) */
    uint32_t s0 = RT_MIN(e->sel_start, e->sel_end), e0 = RT_MAX(e->sel_start, e->sel_end);
    uint32_t keep = e->len - (e0 - s0);
    uint32_t avail = (DLG_EDIT_MAX - 1u) - keep;
    if (n > avail) n = avail; /* EN_MAXTEXT: insert what fits (I: Wine) */
    if (e0 > s0) {
        uint32_t dl = e0 - s0;
        if (can_undo) {
            if (!e->undo_ins && e->undo_len && s0 == e->undo_pos && e->undo_len + dl < DLG_EDIT_MAX) {
                rt_memcpy(e->undo_text + e->undo_len, e->buf + s0, dl); /* extended to the right */
                e->undo_len += dl;
            } else if (!e->undo_ins && e->undo_len && e0 == e->undo_pos && e->undo_len + dl < DLG_EDIT_MAX) {
                rt_memmove(e->undo_text + dl, e->undo_text, e->undo_len); /* extended to the left */
                rt_memcpy(e->undo_text, e->buf + s0, dl);
                e->undo_len += dl;
                e->undo_pos = s0;
            } else {
                rt_memcpy(e->undo_text, e->buf + s0, dl);
                e->undo_len = dl;
                e->undo_pos = s0;
            }
            e->undo_ins = 0;
        } else {
            undo_empty(e);
        }
        rt_memmove(e->buf + s0, e->buf + e0, e->len - e0);
        e->len -= dl;
    }
    if (n) {
        rt_memmove(e->buf + s0 + n, e->buf + s0, e->len - s0);
        rt_memcpy(e->buf + s0, s, n);
        e->len += n;
        if (can_undo) {
            if (s0 == e->undo_pos || (e->undo_ins && s0 == e->undo_pos + e->undo_ins)) {
                e->undo_ins += n;
            } else {
                e->undo_pos = s0;
                e->undo_ins = n;
                e->undo_len = 0;
            }
        } else {
            undo_empty(e);
        }
    }
    e->buf[e->len] = 0;
    dlg_edit_layout(d);
    e->sel_start = e->sel_end = s0 + n;
    e->after_wrap = false;
    dlg_edit_scroll_caret(d);
    caret_moved(d);
}

void dlg_edit_undo(Dialog *d) {
    DlgEdit *e = &d->edit;
    if (e->ext) return;
    char tmp[DLG_EDIT_MAX];
    uint32_t ul = e->undo_len, pos = e->undo_pos, ins = e->undo_ins;
    rt_memcpy(tmp, e->undo_text, ul);
    dlg_edit_set_sel(d, pos, pos + ins);
    undo_empty(e);
    dlg_edit_replace_sel(d, tmp, ul, true);
    dlg_edit_set_sel(d, e->undo_pos, e->undo_pos + e->undo_ins);
    dlg_edit_scroll_caret(d);
}

/* Character classes for word moves (default word break procedure: spaces separate words; I). */
static bool is_sp(char c) { return c == ' ' || c == '\t'; }

static uint32_t word_left(const DlgEdit *e, uint32_t idx) {
    const char *t = dlg_edit_text(e);
    int32_t line = dlg_edit_line_of(e, idx, false);
    uint32_t ls = e->line_start[line];
    if (idx == ls) return line > 0 ? e->line_start[line - 1] + e->line_len[line - 1] : 0;
    while (idx > ls && is_sp(t[idx - 1])) idx--;
    while (idx > ls && !is_sp(t[idx - 1])) idx--;
    return idx;
}

static uint32_t word_right(const DlgEdit *e, uint32_t idx) {
    const char *t = dlg_edit_text(e);
    int32_t line = dlg_edit_line_of(e, idx, false);
    uint32_t le = e->line_start[line] + e->line_len[line];
    if (idx >= le) return line + 1 < e->nlines ? e->line_start[line + 1] : e->len;
    while (idx < le && !is_sp(t[idx])) idx++;
    while (idx < le && is_sp(t[idx])) idx++;
    return idx;
}

static uint32_t back1(const DlgEdit *e, uint32_t idx) {
    const char *t = dlg_edit_text(e);
    if (idx == 0) return 0;
    if (idx >= 2 && t[idx - 1] == '\n' && t[idx - 2] == '\r') return idx - 2;
    return idx - 1;
}

static uint32_t fwd1(const DlgEdit *e, uint32_t idx) {
    const char *t = dlg_edit_text(e);
    if (idx >= e->len) return e->len;
    if (idx + 1 < e->len && t[idx] == '\r' && t[idx + 1] == '\n') return idx + 2;
    return idx + 1;
}

static void vert_move(Dialog *d, int32_t lines, bool extend) {
    DlgEdit *e = &d->edit;
    int32_t x, y;
    pos_from_char(d, e->sel_end, e->after_wrap, &x, &y);
    bool aw;
    uint32_t idx = char_from_pos(d, x, y + lines * e->line_h, &aw);
    move_to(d, idx, extend, aw);
}

bool dlg_edit_key(Dialog *d, uint32_t vk) {
    DlgEdit *e = &d->edit;
    bool sh = d->shift_down, ct = d->ctrl_down, ml = e->multiline;
    switch (vk) {
    case DLG_VK_LEFT:
    case DLG_VK_UP:
        if (ml && vk == DLG_VK_UP) vert_move(d, -1, sh);
        else move_to(d, ct ? word_left(e, e->sel_end) : back1(e, e->sel_end), sh, false);
        return true;
    case DLG_VK_RIGHT:
    case DLG_VK_DOWN:
        if (ml && vk == DLG_VK_DOWN) vert_move(d, 1, sh);
        else move_to(d, ct ? word_right(e, e->sel_end) : fwd1(e, e->sel_end), sh, false);
        return true;
    case DLG_VK_HOME:
        if (ml && !ct) {
            int32_t line = dlg_edit_line_of(e, e->sel_end, e->after_wrap);
            move_to(d, e->line_start[line], sh, false);
        } else {
            move_to(d, 0, sh, false);
        }
        return true;
    case DLG_VK_END:
        if (ml && !ct) {
            int32_t line = dlg_edit_line_of(e, e->sel_end, e->after_wrap);
            uint32_t end = e->line_start[line] + e->line_len[line];
            bool aw = line + 1 < e->nlines && soft_start(e, line + 1);
            move_to(d, end, sh, aw);
        } else {
            move_to(d, e->len, sh, false);
        }
        return true;
    case DLG_VK_PRIOR:
    case DLG_VK_NEXT:
        if (ml) {
            int32_t dir = vk == DLG_VK_NEXT ? 1 : -1;
            dlg_edit_scroll_lines(d, dir * e->vlc);
            vert_move(d, dir * e->vlc, sh);
        }
        return true;
    case DLG_VK_DELETE:
        if (e->readonly || sh) return true; /* Shift+Del = cut: no clipboard (port) */
        if (e->sel_start == e->sel_end) {
            uint32_t to = fwd1(e, e->sel_end);
            if (ct) {
                int32_t line = dlg_edit_line_of(e, e->sel_end, e->after_wrap);
                to = e->line_start[line] + e->line_len[line];
            }
            e->sel_start = e->sel_end;
            e->sel_end = to;
        }
        dlg_edit_replace_sel(d, "", 0, true);
        return true;
    default:
        return false;
    }
}

bool dlg_edit_char(Dialog *d, uint32_t ch) {
    DlgEdit *e = &d->edit;
    switch (ch) {
    case '\r':
    case '\t':
    case 0x1B:
        return true; /* in a dialog: handled by the dialog manager or ignored (I) */
    case '\n':
        if (e->multiline && e->readonly) {
            /* Ctrl+Enter in a read-only multi-line edit: start of the next line (I: Wine) */
            int32_t line = dlg_edit_line_of(e, e->sel_end, e->after_wrap);
            if (line + 1 < e->nlines) move_to(d, e->line_start[line + 1], false, false);
        }
        return true;
    case 0x08:
        if (e->readonly) return true;
        if (e->sel_start == e->sel_end) {
            e->sel_start = back1(e, e->sel_end);
            if (e->sel_start == e->sel_end) return true;
        }
        dlg_edit_replace_sel(d, "", 0, true);
        return true;
    case 0x1A:
        if (!e->readonly) dlg_edit_undo(d);
        return true;
    default:
        if (e->readonly || ch < 0x20) return true;
        {
            char c = (char)ch;
            dlg_edit_replace_sel(d, &c, 1, true);
        }
        return true;
    }
}

void dlg_edit_focus(Dialog *d, bool gained) {
    if (gained) dlg_caret_reset(d);
    else d->caret_on = false;
    d->dirty = true;
}

void dlg_edit_mouse(Dialog *d, uint32_t kind, int32_t cx, int32_t cy) {
    DlgEdit *e = &d->edit;
    bool aw;
    if (kind == DLG_IN_BUTTONDOWN) {
        if (e->has_last_click && d->now - e->last_click_ms <= DLG_DBLCLK_MS && cx - e->last_click_x <= 2 &&
            e->last_click_x - cx <= 2 && cy - e->last_click_y <= 2 && e->last_click_y - cy <= 2) {
            e->has_last_click = false;
            e->selecting = false;
            uint32_t idx = char_from_pos(d, cx, cy, &aw);
            uint32_t l = idx, r = idx;
            const char *t = dlg_edit_text(e);
            int32_t line = dlg_edit_line_of(e, idx, aw);
            uint32_t ls = e->line_start[line], le = ls + e->line_len[line];
            while (l > ls && !is_sp(t[l - 1])) l--;
            while (r < le && !is_sp(t[r])) r++;
            while (r < le && is_sp(t[r])) r++;
            dlg_edit_set_sel(d, l, r);
            dlg_edit_scroll_caret(d);
            return;
        }
        e->has_last_click = true;
        e->last_click_ms = d->now;
        e->last_click_x = cx;
        e->last_click_y = cy;
        uint32_t idx = char_from_pos(d, cx, cy, &aw);
        move_to(d, idx, d->shift_down, aw);
        e->selecting = true;
        return;
    }
    if (kind == DLG_IN_MOUSEMOVE && e->selecting) {
        uint32_t idx = char_from_pos(d, cx, cy, &aw);
        if (idx != e->sel_end) move_to(d, idx, true, aw);
        return;
    }
    if (kind == DLG_IN_BUTTONUP) e->selecting = false;
}

/* ------------------------------------------------------------------ scroll bar */

void dlg_sb_calc(const Dialog *d, DlgSbCalc *c) {
    const DlgEdit *e = &d->edit;
    int32_t sbw = e->sb.w > 0 ? e->sb.w : 17;
    int32_t h = e->sb.h;
    c->range = e->nlines; /* nMin 0, nMax lines - 1 */
    c->page = e->vlc;
    c->pos = e->y_offset;
    int32_t arrow = imin(h / 2, sbw);
    c->px_up = arrow;
    c->px_down = h - arrow;
    int32_t thumb = sbw;
    if (c->page != 0 && c->range != 0) thumb = imax(thumb / 2, dlg_muldiv(c->px_down - c->px_up, c->page, c->range));
    c->px_min = arrow;
    c->cpx = h - arrow - thumb - c->px_min;
    int32_t denom = c->range - (c->page ? c->page : 1);
    c->thumb_h = thumb;
    if (c->cpx < 0 || denom <= 0) {
        c->thumb_h = 0; /* no room or nothing to scroll (SIF_DISABLENOSCROLL: no thumb, I) */
        c->thumb_top = c->px_min;
        return;
    }
    c->thumb_top = dlg_muldiv(c->pos, c->cpx, denom) + c->px_min;
    if (d->sb_mode == DLG_SB_THUMB) c->thumb_top = d->sb_thumb_px;
}

static int32_t sb_pos_from_px(const DlgSbCalc *c, int32_t px) {
    if (px < c->px_min) return 0;
    if (px >= c->px_min + c->cpx) return c->range - c->page;
    return c->cpx ? dlg_muldiv(c->range - c->page, px - c->px_min, c->cpx) : 0;
}

static void sb_step(Dialog *d) {
    DlgEdit *e = &d->edit;
    switch (d->sb_mode) {
    case DLG_SB_LINEUP: dlg_edit_scroll_lines(d, -1); break;
    case DLG_SB_LINEDOWN: dlg_edit_scroll_lines(d, 1); break;
    case DLG_SB_PAGEUP: dlg_edit_scroll_lines(d, -e->vlc); break; /* SB_PAGEUP: format height / line height (I) */
    case DLG_SB_PAGEDOWN: dlg_edit_scroll_lines(d, e->vlc); break;
    default: break;
    }
}

/* Is the pointer over the part that was pressed (and, for paging, not yet reached by the thumb)? */
static bool sb_over(const Dialog *d, int32_t sx, int32_t sy) {
    const DlgEdit *e = &d->edit;
    DlgSbCalc c;
    dlg_sb_calc(d, &c);
    if (sx < 0 || sx >= e->sb.w) return false;
    switch (d->sb_mode) {
    case DLG_SB_LINEUP: return sy >= 0 && sy < c.px_up;
    case DLG_SB_LINEDOWN: return sy >= c.px_down && sy < e->sb.h;
    case DLG_SB_PAGEUP: return sy >= c.px_up && sy < c.thumb_top;
    case DLG_SB_PAGEDOWN: return sy >= c.thumb_top + c.thumb_h && sy < c.px_down;
    default: return false;
    }
}

bool dlg_sb_mouse(Dialog *d, uint32_t kind, int32_t sx, int32_t sy) {
    DlgSbCalc c;
    dlg_sb_calc(d, &c);
    if (kind == DLG_IN_BUTTONDOWN) {
        if (sy < c.px_up) d->sb_mode = DLG_SB_LINEUP;
        else if (sy >= c.px_down) d->sb_mode = DLG_SB_LINEDOWN;
        else if (c.thumb_h > 0 && sy >= c.thumb_top && sy < c.thumb_top + c.thumb_h) d->sb_mode = DLG_SB_THUMB;
        else if (c.thumb_h > 0 && sy < c.thumb_top) d->sb_mode = DLG_SB_PAGEUP;
        else if (c.thumb_h > 0) d->sb_mode = DLG_SB_PAGEDOWN;
        else return false;
        if (d->sb_mode == DLG_SB_THUMB) {
            d->sb_drag_off = sy - c.thumb_top;
            d->sb_thumb_px = c.thumb_top;
        } else {
            sb_step(d);
            d->sb_pressed = true;
            d->sb_next_ms = d->now + DLG_SCROLL_FIRST_MS;
        }
        d->sb_track_y = sy;
        d->dirty = true;
        return true;
    }
    if (kind == DLG_IN_MOUSEMOVE) {
        if (d->sb_mode == DLG_SB_THUMB) {
            int32_t top = imax(c.px_min, imin(sy - d->sb_drag_off, c.px_min + c.cpx));
            if (top != d->sb_thumb_px) {
                d->sb_thumb_px = top;
                d->dirty = true;
            }
            int32_t pos = sb_pos_from_px(&c, top);
            if (pos != d->edit.y_offset) dlg_edit_scroll_lines(d, pos - d->edit.y_offset); /* SB_THUMBTRACK */
        } else {
            bool over = sb_over(d, sx, sy);
            if (over != d->sb_pressed) {
                d->sb_pressed = over;
                d->dirty = true;
            }
            d->sb_track_y = sy;
        }
        return true;
    }
    if (kind == DLG_IN_BUTTONUP) {
        if (d->sb_mode == DLG_SB_THUMB) {
            int32_t pos = sb_pos_from_px(&c, d->sb_thumb_px); /* SB_THUMBPOSITION */
            d->sb_mode = DLG_SB_NONE;
            dlg_edit_scroll_lines(d, pos - d->edit.y_offset);
        }
        d->sb_mode = DLG_SB_NONE;
        d->sb_pressed = false;
        d->dirty = true;
        return true;
    }
    return false;
}

bool dlg_sb_tick(Dialog *d) {
    if (d->sb_mode == DLG_SB_NONE || d->sb_mode == DLG_SB_THUMB) return false;
    bool changed = false;
    while ((int32_t)(d->now - d->sb_next_ms) >= 0) {
        d->sb_next_ms += DLG_SCROLL_REPEAT_MS;
        int32_t old = d->edit.y_offset;
        if (d->sb_pressed) {
            DlgSbCalc c;
            dlg_sb_calc(d, &c);
            bool go = true;
            if (d->sb_mode == DLG_SB_PAGEUP) go = d->sb_track_y < c.thumb_top;
            if (d->sb_mode == DLG_SB_PAGEDOWN) go = d->sb_track_y >= c.thumb_top + c.thumb_h;
            if (go) sb_step(d);
            /* the pressed look follows the part under the pointer */
            bool over = sb_over(d, 0, d->sb_track_y);
            if (!over) d->sb_pressed = false;
        }
        if (d->edit.y_offset != old) changed = true;
    }
    if (changed) d->dirty = true;
    return changed;
}

/* Arrow glyph (Wine UITOOLS95_DrawFrameScroll Marlett approximation, I): filled triangle. */
static void sb_glyph(Dialog *d, int32_t l, int32_t t, int32_t r, int32_t b, DlgRect rc, bool up, bool pushed) {
    int32_t side = imin(rc.w, rc.h);
    DlgRect sq = rc;
    if (rc.w < rc.h) {
        sq.y += (rc.h - rc.w) / 2;
        sq.h = side;
    } else if (rc.w > rc.h) {
        sq.x += (rc.w - rc.h) / 2;
        sq.w = side;
    }
    int32_t small = side - 2;
    int32_t tri = 290 * small / 1000 - 1;
    if (tri <= 0) tri = 1;
    int32_t ax = sq.x + 470 * small / 1000 + 2, ay;
    if (up) ay = sq.y + sq.h - (687 * small / 1000 + 1);
    else ay = sq.y + 687 * small / 1000 + 1;
    if (!pushed) {
        ax--;
        ay--;
    }
    uint32_t col = dlg_pixel(d, LUNA_COLOR_BTNTEXT);
    for (int32_t k = 0; k <= tri; k++) {
        int32_t y = up ? ay + k : ay - k;
        for (int32_t x = ax - k; x <= ax + k; x++) dlg_put(&d->img, l, t, r, b, x, y, col);
    }
}

static void draw_sb(Dialog *d, int32_t ox, int32_t oy, int32_t l, int32_t t, int32_t r, int32_t b) {
    DlgEdit *e = &d->edit;
    DlgSbCalc c;
    dlg_sb_calc(d, &c);
    int32_t sx = ox + e->sb.x, sy = oy + e->sb.y, w = e->sb.w, h = e->sb.h;
    uint32_t hi = dlg_pixel(d, LUNA_COLOR_3DHILIGHT), face = dlg_pixel(d, LUNA_COLOR_3DFACE);
    /* track: up arrow bottom .. down arrow top */
    int32_t tt = c.px_up, tb = c.px_down;
    int32_t th = c.thumb_h;
    int32_t ttop = c.thumb_top;
    bool pu = d->sb_mode == DLG_SB_PAGEUP && d->sb_pressed, pd = d->sb_mode == DLG_SB_PAGEDOWN && d->sb_pressed;
    if (th > 0) {
        dlg_fill_pattern(&d->img, l, t, r, b, sx, sy + tt, w, ttop - tt, ox, oy, pu ? (hi ^ 0x00FFFFFFu) : hi,
                         pu ? (face ^ 0x00FFFFFFu) : face);
        dlg_fill_pattern(&d->img, l, t, r, b, sx, sy + ttop + th, w, tb - ttop - th, ox, oy,
                         pd ? (hi ^ 0x00FFFFFFu) : hi, pd ? (face ^ 0x00FFFFFFu) : face);
        dlg_draw_edge(d, l, t, r, b, (DlgRect){sx, sy + ttop, w, th}, DLG_EDGE_RAISED, DLG_BF_MIDDLE);
    } else {
        dlg_fill_pattern(&d->img, l, t, r, b, sx, sy + tt, w, tb - tt, ox, oy, hi, face);
    }
    bool up_p = d->sb_mode == DLG_SB_LINEUP && d->sb_pressed, dn_p = d->sb_mode == DLG_SB_LINEDOWN && d->sb_pressed;
    DlgRect ru = {sx, sy, w, c.px_up}, rd = {sx, sy + c.px_down, w, h - c.px_down};
    if (up_p) dlg_draw_edge(d, l, t, r, b, ru, DLG_EDGE_SUNKEN, DLG_BF_FLAT | DLG_BF_SOFT | DLG_BF_MIDDLE);
    else dlg_draw_edge(d, l, t, r, b, ru, DLG_EDGE_RAISED, DLG_BF_MIDDLE);
    sb_glyph(d, l, t, r, b, ru, true, up_p);
    if (dn_p) dlg_draw_edge(d, l, t, r, b, rd, DLG_EDGE_SUNKEN, DLG_BF_FLAT | DLG_BF_SOFT | DLG_BF_MIDDLE);
    else dlg_draw_edge(d, l, t, r, b, rd, DLG_EDGE_RAISED, DLG_BF_MIDDLE);
    sb_glyph(d, l, t, r, b, rd, false, dn_p);
}

/* ------------------------------------------------------------------ drawing */

static void text_run(Dialog *d, const GdiRect *clip, int32_t x, int32_t y, const char *s, int32_t n, bool sel) {
    if (n <= 0) return;
    GdiTextState st;
    st.smoothing = d->env.smoothing;
    if (sel) {
        st.text_color = dlg_pixel(d, LUNA_COLOR_HIGHLIGHTTEXT);
        st.bk_color = dlg_pixel(d, LUNA_COLOR_HIGHLIGHT);
        st.bk_mode = GDI_OPAQUE;
    } else {
        st.text_color = dlg_pixel(d, LUNA_COLOR_WINDOWTEXT);
        st.bk_color = 0;
        st.bk_mode = GDI_TRANSPARENT;
    }
    gdi_ext_text_out(&d->img, x, y, GDI_ETO_CLIPPED, clip, s, n, d->font, &st);
}

void dlg_edit_draw(Dialog *d, const DlgControl *c, int32_t ox, int32_t oy) {
    DlgEdit *e = &d->edit;
    int32_t cl = d->geom.client.x, ct = d->geom.client.y;
    int32_t l = imax(ox, cl), t = imax(oy, ct);
    int32_t r = imin(ox + c->r.w, cl + d->client_w), b = imin(oy + c->r.h, ct + d->client_h);
    uint32_t bg = dlg_pixel(d, e->readonly ? LUNA_COLOR_3DFACE : LUNA_COLOR_WINDOW);
    dlg_fill(&d->img, l, t, r, b, ox + e->client.x, oy + e->client.y, e->client.w, e->client.h, bg);
    if (c->exstyle & DLG_WS_EX_CLIENTEDGE)
        dlg_draw_edge(d, l, t, r, b, (DlgRect){ox, oy, c->r.w, c->r.h}, DLG_EDGE_SUNKEN, 0);
    else if (c->style & DLG_WS_BORDER) {
        uint32_t k = dlg_pixel(d, LUNA_COLOR_WINDOWFRAME);
        dlg_fill(&d->img, l, t, r, b, ox, oy, c->r.w, 1, k);
        dlg_fill(&d->img, l, t, r, b, ox, oy + c->r.h - 1, c->r.w, 1, k);
        dlg_fill(&d->img, l, t, r, b, ox, oy, 1, c->r.h, k);
        dlg_fill(&d->img, l, t, r, b, ox + c->r.w - 1, oy, 1, c->r.h, k);
    }
    if (e->vscroll) draw_sb(d, ox, oy, l, t, r, b);

    /* text, clipped to the formatting rectangle */
    GdiRect fc = {imax(l, ox + e->fmt.x), imax(t, oy + e->fmt.y), imin(r, ox + e->fmt.x + e->fmt.w),
                  imin(b, oy + e->fmt.y + e->fmt.h)};
    const char *txt = dlg_edit_text(e);
    int32_t idx = (int32_t)(c - d->ctl);
    bool focused = idx == d->focus && d->active;
    bool show_sel = (focused || e->nohidesel) && e->sel_start != e->sel_end;
    uint32_t s0 = RT_MIN(e->sel_start, e->sel_end), s1 = RT_MAX(e->sel_start, e->sel_end);
    int32_t first = e->multiline ? e->y_offset : 0;
    int32_t last = e->multiline ? imin(e->nlines, e->y_offset + e->vlc) : 1;
    for (int32_t i = first; i < last; i++) {
        uint32_t ls = e->line_start[i], ll = e->line_len[i];
        int32_t y = oy + e->fmt.y + (i - first) * e->line_h;
        int32_t x = ox + e->fmt.x - (e->multiline ? 0 : cxs(d, txt, e->x_offset));
        if (!show_sel || s1 <= ls || s0 >= ls + ll) {
            text_run(d, &fc, x, y, txt + ls, (int32_t)ll, false);
            continue;
        }
        uint32_t a = RT_MAX(s0, ls), z = RT_MIN(s1, ls + ll);
        int32_t xa = x + cxs(d, txt + ls, (int32_t)(a - ls));
        int32_t xz = xa + cxs(d, txt + a, (int32_t)(z - a));
        text_run(d, &fc, x, y, txt + ls, (int32_t)(a - ls), false);
        text_run(d, &fc, xa, y, txt + a, (int32_t)(z - a), true);
        text_run(d, &fc, xz, y, txt + z, (int32_t)(ls + ll - z), false);
    }
    /* caret: inverted 1 x line height, clipped to the client area */
    if (focused && d->caret_on) {
        int32_t x, y;
        pos_from_char(d, e->sel_end, e->after_wrap, &x, &y);
        int32_t cl2 = imax(l, ox + e->client.x), ct2 = imax(t, oy + e->client.y);
        int32_t cr2 = imin(r, ox + e->client.x + e->client.w), cb2 = imin(b, oy + e->client.y + e->client.h);
        for (int32_t yy = 0; yy < e->line_h; yy++) dlg_invert(&d->img, cl2, ct2, cr2, cb2, ox + x, oy + y + yy);
    }
}
