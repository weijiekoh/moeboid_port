/* Tests for the dialog component (M5a): src/shell/dialog*.c, msgbox.c, inputbox.c, tos.c.
 *
 * Usage:
 *   test_dialog [PACK]               unit tests (default pack: <root>/port/build/web/pack.bin; skipped
 *                                    with exit 0 when the pack is missing)
 *   test_dialog render PACK OUTDIR   writes the review states as OUTDIR/<name>.rgba (u32 w, u32 h, RGBA
 *                                    rows) and prints "state <name> <x> <y> <w> <h>" (window in the frame)
 *   test_dialog rects PACK           control rectangles of all 8 templates: "rect NAME id x y w h kind"
 *   test_dialog tos PACK             ToS edit layout: "fmt x y w h vlc", "line i start len"
 * Driven by port/tests/py/test_dialog.py. Test programs may use the host libc. */
#include "shell/dialog.h"
#include "shell/dialog_modal.h"
#include "shell/inputbox.h"
#include "shell/msgbox.h"
#include "shell/tos.h"
#include "test.h"

static unsigned char *read_file(const char *path, long *n) {
    FILE *f = fopen(path, "rb");
    if (!f) return NULL;
    fseek(f, 0, SEEK_END);
    *n = ftell(f);
    fseek(f, 0, SEEK_SET);
    unsigned char *b = malloc((size_t)*n);
    if (b && fread(b, 1, (size_t)*n, f) != (size_t)*n) {
        free(b);
        b = NULL;
    }
    fclose(f);
    return b;
}

static DlgModal M; /* large (window pixels) */
static uint32_t now_ms = 1000;

#define KEY(vk) dlgm_input(&M, DLG_IN_KEYDOWN, (vk), 0, now_ms)
#define KEYUP(vk) dlgm_input(&M, DLG_IN_KEYUP, (vk), 0, now_ms)
#define CHR(c) dlgm_input(&M, DLG_IN_CHAR, (c), 0, now_ms)
/* key press as the host sends it: key down, WM_CHAR (when the key has one), key up */
static void press(uint32_t vk, int32_t ch) {
    KEY(vk);
    if (ch >= 0) CHR((uint32_t)ch);
    KEYUP(vk);
}
static void type(const char *s) {
    for (; *s; s++) {
        uint32_t c = (uint8_t)*s;
        uint32_t vk = (c >= 'a' && c <= 'z') ? c - 32 : c;
        press(vk, (int32_t)c);
    }
}
/* frame coordinates of a control centre */
static void ctl_centre(const Dialog *d, int32_t id, int32_t *x, int32_t *y) {
    int32_t i = dlg_find(d, id);
    *x = d->win_x + d->geom.client.x + d->ctl[i].r.x + d->ctl[i].r.w / 2;
    *y = d->win_y + d->geom.client.y + d->ctl[i].r.y + d->ctl[i].r.h / 2;
}
static void click_at(int32_t x, int32_t y) {
    dlgm_input(&M, DLG_IN_MOUSEMOVE, x, y, now_ms);
    dlgm_input(&M, DLG_IN_BUTTONDOWN, x, y, now_ms);
    dlgm_input(&M, DLG_IN_BUTTONUP, x, y, now_ms);
}
static int32_t take(const char **text) {
    int32_t r = -99;
    if (dlgm_take(&M, &r, text) != 0) return -99;
    return r;
}

/* ------------------------------------------------------------------ unit tests */

static void test_geometry(void) {
    CHECK_EQ(dlg_muldiv(167, 6, 4), 251);
    CHECK_EQ(dlg_muldiv(61, 13, 8), 99);
    CHECK_EQ(dlg_muldiv(12, 13, 8), 20);  /* 19.5 rounds up */
    CHECK_EQ(dlg_muldiv(-3, 13, 8), -5);  /* -4.875 */
    CHECK_EQ(dlg_muldiv(7, 6, 4), 11);    /* 10.5 */
    GdiFont f;
    CHECK_EQ(gdi_font_select(&f, &M.fonts, "MS Sans Serif", -11, 400, 0, 0), 0);
    int32_t bx, by;
    dlg_base_units(&f, &bx, &by);
    CHECK_EQ(bx, 6);
    CHECK_EQ(by, 13);
    dlg_base_units(&M.msg_font, &bx, &by);
    CHECK_EQ(bx, 6);   /* Tahoma 8 (luna README: 6 x 13) */
    CHECK_EQ(by, 13);

    /* client sizes (dialogs.json) and window sizes (Luna: + 6, + 32), centred in 800 x 572 */
    CHECK_EQ(dlgm_open_inputbox(&M, 2, "Congratulations", "p", "Name", 16, now_ms), 0);
    CHECK_EQ(M.dlg.client_w, 251);
    CHECK_EQ(M.dlg.client_h, 99);
    CHECK_EQ(M.dlg.geom.win_w, 257);
    CHECK_EQ(M.dlg.geom.win_h, 131);
    CHECK_EQ(M.dlg.win_x, 271);
    CHECK_EQ(M.dlg.win_y, 220);
    int32_t e = dlg_find(&M.dlg, INPUTBOX_ID_EDIT);
    CHECK_EQ(M.dlg.ctl[e].r.x, 6);
    CHECK_EQ(M.dlg.ctl[e].r.y, 41);
    CHECK_EQ(M.dlg.ctl[e].r.w, 237);
    CHECK_EQ(M.dlg.ctl[e].r.h, 20);
    CHECK(M.dlg.ctl[e].exstyle & DLG_WS_EX_CLIENTEDGE);
    CHECK(!(M.dlg.ctl[e].style & DLG_WS_BORDER));
    /* edit client 233 x 16 at (2, 2); formatting rectangle (3, 3) 231 x 13 */
    CHECK_EQ(M.dlg.edit.fmt.x, 3);
    CHECK_EQ(M.dlg.edit.fmt.y, 3);
    CHECK_EQ(M.dlg.edit.fmt.w, 231);
    CHECK_EQ(M.dlg.edit.fmt.h, 13);
    dlgm_close(&M);

    CHECK_EQ(dlgm_open_quit_saved(&M, now_ms), 0);
    CHECK_EQ(M.dlg.client_w, 297);
    CHECK_EQ(M.dlg.client_h, 81);
    CHECK_EQ(M.dlg.win_x, (800 - 303) / 2);
    CHECK_EQ(M.dlg.win_y, (572 - 113) / 2);
    CHECK_STR(M.dlg.caption, "Warning: Game in Progress");
    dlgm_close(&M);

    CHECK_EQ(dlgm_open_tos(&M, now_ms), 0);
    CHECK_EQ(M.dlg.client_w, 419);
    CHECK_EQ(M.dlg.client_h, 276);
    CHECK_EQ(M.dlg.geom.win_w, 425);
    CHECK_EQ(M.dlg.geom.win_h, 308);
    CHECK(M.dlg.win_x >= 0 && M.dlg.win_y >= 0 && M.dlg.win_x + 425 <= 800 && M.dlg.win_y + 308 <= 572);
    DlgEdit *te = &M.dlg.edit;
    CHECK(te->multiline && te->readonly && te->vscroll);
    CHECK_EQ(te->sb.w, 17);
    CHECK_EQ(te->client.w, 399 - 4 - 17);
    CHECK_EQ(te->fmt.w, 376);
    CHECK_EQ(te->vlc, 10);
    CHECK(!M.dlg.ctl[dlg_find(&M.dlg, TOS_ID_OPTIN)].visible);
    dlgm_close(&M);
}

static void test_inputbox(void) {
    const char *text;
    CHECK_EQ(dlgm_open_inputbox(&M, 2, "Congratulations", "You got a high score!", "Name", 16, now_ms), 0);
    Dialog *d = &M.dlg;
    DlgEdit *e = &d->edit;
    int32_t ei = dlg_find(d, INPUTBOX_ID_EDIT), ok = dlg_find(d, DLG_IDOK);
    CHECK_EQ(d->focus, ei);                       /* first tab stop */
    CHECK_EQ(e->sel_start, 0);
    CHECK_EQ(e->sel_end, 4);                      /* EM_SETSEL(0, -1) */
    CHECK(d->ctl[ok].is_def);
    CHECK_EQ(d->def_id, DLG_IDOK);
    CHECK_STR(d->ctl[dlg_find(d, INPUTBOX_ID_PROMPT)].text, "You got a high score!");
    /* typing replaces the selection */
    type("tester");
    CHECK_STR(e->buf, "tester");
    CHECK_EQ(e->sel_end, 6);
    /* caret blink: visible after typing, 530 ms phases */
    CHECK(d->caret_on);
    dlg_tick(d, now_ms + 529);
    CHECK(d->caret_on);
    dlg_tick(d, now_ms + 530);
    CHECK(!d->caret_on);
    dlg_tick(d, now_ms + 1060);
    CHECK(d->caret_on);
    /* editing keys */
    press(DLG_VK_HOME, -1);
    CHECK_EQ(e->sel_end, 0);
    press(DLG_VK_DELETE, -1);
    CHECK_STR(e->buf, "ester");
    press(DLG_VK_END, -1);
    press(DLG_VK_BACK, 0x08);
    CHECK_STR(e->buf, "este");
    KEY(DLG_VK_SHIFT);
    press(DLG_VK_LEFT, -1);
    press(DLG_VK_LEFT, -1);
    KEYUP(DLG_VK_SHIFT);
    CHECK_EQ(e->sel_start, 4);
    CHECK_EQ(e->sel_end, 2);
    type("X");
    CHECK_STR(e->buf, "esX");
    /* undo (Ctrl+Z = WM_CHAR 0x1A); the deletion of "te" joins the Backspace deletion of 'r' at its right
     * end (Wine undo model), so the undo gives "ester"; a second undo redoes */
    CHR(0x1A);
    CHECK_STR(e->buf, "ester");
    CHR(0x1A);
    CHECK_STR(e->buf, "esX");
    CHECK_EQ(e->sel_start, 2);   /* undo selects the restored text */
    CHECK_EQ(e->sel_end, 3);
    /* Ctrl+Backspace inserts 0x7F (XP) */
    press(DLG_VK_END, -1);
    CHR(0x7F);
    CHECK_EQ((uint8_t)e->buf[3], 0x7F);
    press(DLG_VK_BACK, 0x08);
    CHECK_STR(e->buf, "esX");
    /* long text scrolls (ES_AUTOHSCROLL); GetDlgItemTextA(0x10) gives 15 characters */
    press(DLG_VK_END, -1);
    type("abcdefghijklmnopqrstuvwxyzabcdefghijklmnop");
    CHECK_EQ((int32_t)e->len, 45);
    CHECK(e->x_offset > 0);
    {
        int32_t xl = e->fmt.x + 0; /* caret inside the formatting rectangle */
        (void)xl;
        GdiFont *f = &d->font_own;
        int32_t cx, cy;
        gdi_get_text_extent_point32(f, e->buf + e->x_offset, (int32_t)e->len - e->x_offset, &cx, &cy);
        CHECK(e->fmt.x + cx <= e->fmt.x + e->fmt.w);       /* end of text visible */
        CHECK(e->fmt.x + cx >= e->fmt.x + e->fmt.w - e->fmt.w / 3 - 10);
    }
    press(DLG_VK_HOME, -1);
    CHECK_EQ(e->x_offset, 0);
    /* Enter: IDOK; its WM_CHAR does not exist */
    KEY(DLG_VK_RETURN);
    CHECK(dlgm_done(&M));
    CHECK(M.end_drop_char);
    int32_t r = take(&text);
    CHECK_EQ(r, 1);
    CHECK(text && strlen(text) == 15);
    CHECK(text && memcmp(text, "esXabcdefghijkl", 15) == 0);
    CHECK(CHR('\r'));         /* dropped */
    CHECK(!CHR('a'));         /* later characters are not for the closed dialog */

    /* Esc: IDCANCEL, no text */
    CHECK_EQ(dlgm_open_inputbox(&M, 2, "Congratulations", "p", "Name", 16, now_ms), 0);
    press(DLG_VK_ESCAPE, 0x1B);
    CHECK_EQ(take(&text), 2);
    CHECK(text == NULL);

    /* 12-letter rule (game G:0x100038d3): 13+ characters make the game show "Name too long" and open the
     * box again with the previous default; the dialog gives up to 15 */
    CHECK_EQ(dlgm_open_inputbox(&M, 2, "Congratulations", "p", "Name", 16, now_ms), 0);
    type("abcdefghijklm");
    press(DLG_VK_RETURN, '\r');
    CHECK_EQ(take(&text), 1);
    CHECK(text && strlen(text) == 13);
    CHECK_EQ(dlgm_open_messagebox(&M, "Name too long", "We're sorry, but names must be 12 letters or smaller.", 0x30,
                                  now_ms),
             0);
    press(DLG_VK_RETURN, '\r');
    CHECK_EQ(take(&text), 1);
    CHECK_EQ(dlgm_open_inputbox(&M, 2, "Congratulations", "p", "Name", 16, now_ms), 0);
    CHECK_STR(M.dlg.edit.buf, "Name");
    type("abcdefghijkl");
    press(DLG_VK_RETURN, '\r');
    CHECK_EQ(take(&text), 1);
    CHECK_STR(text, "abcdefghijkl");

    /* keyboard navigation: Tab to OK (default), Shift+Tab back selects all, arrows move in the group */
    CHECK_EQ(dlgm_open_inputbox(&M, 2, "Congratulations", "p", "Name", 16, now_ms), 0);
    d = &M.dlg;
    e = &d->edit;
    ei = dlg_find(d, INPUTBOX_ID_EDIT);
    ok = dlg_find(d, DLG_IDOK);
    CHECK(!(d->ui_state & DLG_UISF_HIDEFOCUS)); /* opened after keyboard input: cues shown */
    press(DLG_VK_END, -1);
    press(DLG_VK_TAB, '\t');
    CHECK_EQ(d->focus, ok);
    CHECK(!(d->ui_state & DLG_UISF_HIDEFOCUS));
    CHECK(d->ctl[ok].is_def);
    KEY(DLG_VK_SHIFT);
    press(DLG_VK_TAB, '\t');
    KEYUP(DLG_VK_SHIFT);
    CHECK_EQ(d->focus, ei);
    CHECK_EQ(e->sel_start, 0);
    CHECK_EQ(e->sel_end, 4);
    CHECK_STR(e->buf, "Name"); /* the tab character went nowhere */
    press(DLG_VK_TAB, '\t');
    press(DLG_VK_DOWN, -1);    /* OK does not want arrows: next in group = edit */
    CHECK_EQ(d->focus, ei);
    /* Space on the focused OK button: pushed on key down, command on key up */
    press(DLG_VK_TAB, '\t');
    KEY(DLG_VK_SPACE);
    CHECK(d->ctl[ok].pushed);
    CHR(' ');
    CHECK(!dlgm_done(&M));
    KEYUP(DLG_VK_SPACE);
    CHECK(dlgm_done(&M));
    CHECK_EQ(take(&text), 1);
    CHECK_STR(text, "Name");

    /* mouse: press on OK, move away (released look), back, release = click */
    dlgm_input(&M, DLG_IN_MOUSEMOVE, 5, 5, now_ms); /* last input = mouse */
    CHECK_EQ(dlgm_open_inputbox(&M, 2, "Congratulations", "p", "Name", 16, now_ms), 0);
    d = &M.dlg;
    ok = dlg_find(d, DLG_IDOK);
    int32_t x, y;
    ctl_centre(d, DLG_IDOK, &x, &y);
    dlgm_input(&M, DLG_IN_BUTTONDOWN, x, y, now_ms);
    CHECK(d->ctl[ok].pushed);
    CHECK_EQ(d->focus, ok);
    CHECK(d->ui_state & DLG_UISF_HIDEFOCUS); /* mouse: no focus rectangle */
    dlgm_input(&M, DLG_IN_MOUSEMOVE, x + 100, y, now_ms);
    CHECK(!d->ctl[ok].pushed);
    dlgm_input(&M, DLG_IN_BUTTONUP, x + 100, y, now_ms);
    CHECK(!dlgm_done(&M));
    click_at(x, y);
    CHECK_EQ(take(&text), 1);
    /* caption drag moves the window, kept inside the 800 x 572 frame */
    CHECK_EQ(dlgm_open_inputbox(&M, 2, "Congratulations", "p", "Name", 16, now_ms), 0);
    d = &M.dlg;
    x = d->win_x + 60;
    y = d->win_y + 12;
    dlgm_input(&M, DLG_IN_BUTTONDOWN, x, y, now_ms);
    dlgm_input(&M, DLG_IN_MOUSEMOVE, x + 30, y + 20, now_ms);
    CHECK_EQ(d->win_x, 271 + 30);
    CHECK_EQ(d->win_y, 220 + 20);
    CHECK(d->moved);
    dlgm_input(&M, DLG_IN_MOUSEMOVE, x - 1000, y + 1000, now_ms);
    CHECK_EQ(d->win_x, 0);
    CHECK_EQ(d->win_y, 572 - 131);
    dlgm_input(&M, DLG_IN_BUTTONUP, x - 1000, y + 1000, now_ms);
    dlgm_input(&M, DLG_IN_MOUSEMOVE, 400, 10, now_ms);
    CHECK_EQ(d->win_x, 0);
    /* double click selects a word and its trailing spaces */
    dlg_set_item_text(d, INPUTBOX_ID_EDIT, "ab cd  ef", -1);
    {
        int32_t ex = d->win_x + d->geom.client.x + 6 + 3, ey = d->win_y + d->geom.client.y + 41 + 8;
        int32_t cw, ch;
        gdi_get_text_extent_point32(&d->font_own, "ab c", 4, &cw, &ch);
        dlgm_input(&M, DLG_IN_BUTTONDOWN, ex + cw, ey, now_ms);
        dlgm_input(&M, DLG_IN_BUTTONUP, ex + cw, ey, now_ms);
        dlgm_input(&M, DLG_IN_BUTTONDOWN, ex + cw, ey, now_ms + 100);
        dlgm_input(&M, DLG_IN_BUTTONUP, ex + cw, ey, now_ms + 100);
        CHECK_EQ(d->edit.sel_start, 3);
        CHECK_EQ(d->edit.sel_end, 7);
        /* too slow: no double click */
        dlgm_input(&M, DLG_IN_BUTTONDOWN, ex + cw, ey, now_ms + 1000);
        dlgm_input(&M, DLG_IN_BUTTONUP, ex + cw, ey, now_ms + 1000);
        dlgm_input(&M, DLG_IN_BUTTONDOWN, ex + cw, ey, now_ms + 1600);
        dlgm_input(&M, DLG_IN_BUTTONUP, ex + cw, ey, now_ms + 1600);
        CHECK_EQ(d->edit.sel_start, d->edit.sel_end);
        /* focus loss hides the selection and the caret; the caption becomes inactive */
        dlgm_input(&M, DLG_IN_FOCUS_LOST, 0, 0, now_ms + 1700);
        CHECK(!d->active && !d->caret_on);
        dlgm_input(&M, DLG_IN_FOCUS_GAINED, 0, 0, now_ms + 1800);
        CHECK(d->active && d->caret_on);
    }
    dlgm_close(&M);
    /* click into the edit places the caret (no select-all) */
    CHECK_EQ(dlgm_open_inputbox(&M, 2, "Congratulations", "p", "Name", 16, now_ms), 0);
    d = &M.dlg;
    press(DLG_VK_TAB, '\t');
    ctl_centre(d, INPUTBOX_ID_EDIT, &x, &y);
    click_at(d->win_x + d->geom.client.x + 6 + 3 + 1, y); /* left edge of the text */
    CHECK_EQ(d->focus, dlg_find(d, INPUTBOX_ID_EDIT));
    CHECK_EQ(d->edit.sel_start, 0);
    CHECK_EQ(d->edit.sel_end, 0);
    dlgm_close(&M);
}

static void test_quit_saved(void) {
    const char *text;
    CHECK_EQ(dlgm_open_quit_saved(&M, now_ms), 0);
    Dialog *d = &M.dlg;
    int32_t no = dlg_find(d, 0x7d1), yes = dlg_find(d, 0x7d2);
    CHECK_EQ(d->focus, no);
    CHECK(d->ctl[no].is_def && !d->ctl[yes].is_def);
    press(DLG_VK_TAB, '\t');
    CHECK_EQ(d->focus, yes);
    CHECK(d->ctl[yes].is_def && !d->ctl[no].is_def);
    press(DLG_VK_RETURN, '\r');
    CHECK_EQ(take(&text), 0);
    /* mnemonic without Alt: 'n' = &No */
    CHECK_EQ(dlgm_open_quit_saved(&M, now_ms), 0);
    press('N', 'n');
    CHECK_EQ(take(&text), 1);
    CHECK_EQ(dlgm_open_quit_saved(&M, now_ms), 0);
    press('Y', 'y');
    CHECK_EQ(take(&text), 0);
    CHECK_EQ(dlgm_open_quit_saved(&M, now_ms), 0);
    press(DLG_VK_ESCAPE, 0x1B);
    CHECK_EQ(take(&text), 2);
    CHECK_EQ(quit_saved_command(0x7d1), 1);
    CHECK_EQ(quit_saved_command(0x7d2), 0);
}

static void test_tos(void) {
    const char *text;
    CHECK_EQ(dlgm_open_tos(&M, now_ms), 0);
    Dialog *d = &M.dlg;
    DlgEdit *e = &d->edit;
    int32_t ok = dlg_find(d, TOS_ID_OK), ed = dlg_find(d, TOS_ID_TEXT);
    CHECK_EQ(d->focus, ok);             /* OK is the first control with WS_TABSTOP */
    CHECK(d->ctl[ok].is_def);           /* focused push button looks default */
    CHECK_EQ((int32_t)e->len, 15417);   /* up to the NUL */
    printf("tos lines %d\n", e->nlines);
    CHECK(e->nlines > 250 && e->nlines < 330); /* exact count: test_dialog.py (independent model) */
    CHECK_EQ(e->y_offset, 0);
    /* wheel goes to the focus window: OK ignores it */
    dlgm_wheel(&M, -120, now_ms);
    CHECK_EQ(e->y_offset, 0);
    /* scroll bar geometry: arrows 17, thumb max(8, ...) */
    DlgSbCalc c;
    dlg_sb_calc(d, &c);
    CHECK_EQ(c.px_up, 17);
    CHECK_EQ(c.px_down, 134 - 17);
    CHECK_EQ(c.thumb_h, 8);
    CHECK_EQ(c.thumb_top, 17);
    /* click the down arrow: one line, repeat after 200 ms, then every 50 ms */
    int32_t sx = d->win_x + d->geom.client.x + d->ctl[ed].r.x + e->sb.x + 8;
    int32_t sy = d->win_y + d->geom.client.y + d->ctl[ed].r.y + e->sb.y + e->sb.h - 8;
    dlgm_input(&M, DLG_IN_MOUSEMOVE, sx, sy, now_ms);
    dlgm_input(&M, DLG_IN_BUTTONDOWN, sx, sy, now_ms);
    CHECK_EQ(e->y_offset, 1);
    CHECK_EQ(d->focus, ok);              /* scroll bar click does not move the focus */
    dlgm_tick(&M, now_ms + 199);
    CHECK_EQ(e->y_offset, 1);
    dlgm_tick(&M, now_ms + 200);
    CHECK_EQ(e->y_offset, 2);
    dlgm_tick(&M, now_ms + 300);
    CHECK_EQ(e->y_offset, 4);
    dlgm_input(&M, DLG_IN_BUTTONUP, sx, sy, now_ms + 300);
    dlgm_tick(&M, now_ms + 1000);
    CHECK_EQ(e->y_offset, 4);
    /* page down by the visible line count */
    dlg_sb_calc(d, &c);
    int32_t py = d->win_y + d->geom.client.y + d->ctl[ed].r.y + e->sb.y + c.thumb_top + c.thumb_h + 5;
    dlgm_input(&M, DLG_IN_BUTTONDOWN, sx, py, now_ms + 1000);
    dlgm_input(&M, DLG_IN_BUTTONUP, sx, py, now_ms + 1000);
    CHECK_EQ(e->y_offset, 14);
    /* drag the thumb to the bottom: last page */
    dlg_sb_calc(d, &c);
    int32_t ty = d->win_y + d->geom.client.y + d->ctl[ed].r.y + e->sb.y + c.thumb_top + 2;
    dlgm_input(&M, DLG_IN_BUTTONDOWN, sx, ty, now_ms + 1100);
    dlgm_input(&M, DLG_IN_MOUSEMOVE, sx, ty + 200, now_ms + 1100);
    CHECK_EQ(e->y_offset, e->nlines - e->vlc);
    dlgm_input(&M, DLG_IN_BUTTONUP, sx, ty + 200, now_ms + 1100);
    CHECK_EQ(e->y_offset, e->nlines - e->vlc);
    dlg_sb_calc(d, &c);
    CHECK_EQ(c.thumb_top + c.thumb_h, c.px_down);
    /* Tab: focus to the edit (checkbox removed), all text selected; Tab again: OK */
    press(DLG_VK_TAB, '\t');
    CHECK_EQ(d->focus, ed);
    CHECK_EQ(e->sel_start, 0);
    CHECK_EQ((int32_t)e->sel_end, 15417);
    CHECK(!d->ctl[ok].is_def);           /* no default id: no button looks default (I) */
    /* wheel now scrolls 3 lines per notch */
    int32_t y0 = e->y_offset;
    dlgm_wheel(&M, 120, now_ms + 1200);
    CHECK_EQ(e->y_offset, y0 - 3);
    dlgm_wheel(&M, 60, now_ms + 1200);
    CHECK_EQ(e->y_offset, y0 - 3);
    dlgm_wheel(&M, 60, now_ms + 1200);
    CHECK_EQ(e->y_offset, y0 - 6);
    /* keys in the read-only edit: Ctrl+Home goes to the top, typing does nothing */
    KEY(DLG_VK_CONTROL);
    press(DLG_VK_HOME, -1);
    KEYUP(DLG_VK_CONTROL);
    CHECK_EQ(e->y_offset, 0);
    CHECK_EQ(e->sel_end, 0);
    type("x");
    CHECK_EQ((int32_t)e->len, 15417);
    press(DLG_VK_DOWN, -1);
    CHECK_EQ(dlg_edit_line_of(e, e->sel_end, e->after_wrap), 1);
    press(DLG_VK_NEXT, -1);
    CHECK_EQ(e->y_offset, 10);
    CHECK_EQ(dlg_edit_line_of(e, e->sel_end, e->after_wrap), 11);
    press(DLG_VK_TAB, '\t');
    CHECK_EQ(d->focus, ok);
    press(DLG_VK_RETURN, '\r');
    CHECK_EQ(take(&text), 0);
    CHECK_EQ(dlgm_open_tos(&M, now_ms), 0);
    press(DLG_VK_ESCAPE, 0x1B);
    CHECK_EQ(take(&text), 2);
    CHECK_EQ(dlgm_open_tos(&M, now_ms), 0);
    press('O', 'o');                     /* &OK mnemonic */
    CHECK_EQ(take(&text), 0);
}

static void test_wrap_rules(void) {
    /* multi-line wrap: hanging spaces, long words, CR LF paragraphs (synthetic text in the ToS edit) */
    static char txt[600];
    CHECK_EQ(dlgm_open_tos(&M, now_ms), 0);
    Dialog *d = &M.dlg;
    DlgEdit *e = &d->edit;
    GdiFont *f = &d->font_own;
    int32_t sp, cy, w;
    gdi_get_text_extent_point32(f, " ", 1, &sp, &cy);
    /* a word that ends exactly at the right edge followed by spaces: the spaces stay on the line */
    int32_t n = 0, width = 0;
    while (1) {
        gdi_get_text_extent_point32(f, "a", 1, &w, &cy);
        if (width + w > e->fmt.w) break;
        txt[n++] = 'a';
        width += w;
    }
    int32_t first = n; /* the longest run of 'a' that fits */
    memcpy(txt + n, "     bb\r\n\r\ncc", 13);
    n += 13;
    txt[n] = 0;
    dlg_set_item_text_ext(d, TOS_ID_TEXT, txt, (uint32_t)n);
    CHECK_EQ(e->nlines, 4);
    CHECK_EQ(e->line_len[0], (uint32_t)first + 5);  /* hanging spaces stay on the line */
    CHECK_EQ(e->line_start[1], (uint32_t)first + 5);
    CHECK_EQ(e->line_len[1], 2);
    CHECK_EQ(e->line_len[2], 0);                    /* empty paragraph */
    CHECK_EQ(e->line_start[3], (uint32_t)(n - 2));
    /* a word longer than the line breaks at the character that does not fit */
    memset(txt, 'a', (size_t)first + 3);
    txt[first + 3] = 0;
    dlg_set_item_text_ext(d, TOS_ID_TEXT, txt, (uint32_t)first + 3);
    CHECK_EQ(e->nlines, 2);
    CHECK_EQ(e->line_len[0], (uint32_t)first);
    CHECK_EQ(e->line_len[1], 3);
    /* words: "x x x ..." */
    n = 0;
    for (int i = 0; i < 200; i++) {
        txt[n++] = 'x';
        txt[n++] = ' ';
    }
    txt[n] = 0;
    dlg_set_item_text_ext(d, TOS_ID_TEXT, txt, (uint32_t)n);
    int32_t xw;
    gdi_get_text_extent_point32(f, "x ", 2, &xw, &cy);
    CHECK(e->nlines >= 2);
    /* every full line holds whole "x " pairs and fits the width without its trailing space */
    for (int32_t i = 0; i + 1 < e->nlines; i++) {
        CHECK_EQ(e->line_len[i] % 2, 0);
        int32_t lw;
        gdi_get_text_extent_point32(f, txt + e->line_start[i], (int32_t)e->line_len[i] - 1, &lw, &cy);
        CHECK(lw <= e->fmt.w);
    }
    dlgm_close(&M);
}

static void test_msgbox(void) {
    const char *text;
    const char *msg = "We're sorry, but names must be 12 letters or smaller.";
    MsgBoxLayout L;
    msgbox_layout(&M.msg_font, "Name too long", msg, 0x30, 25, &L);
    printf("msgbox client %d %d btn %d %d %d %d icon %d %d text %d %d %d %d\n", L.client_w, L.client_h, L.btn[0].x,
           L.btn[0].y, L.btn[0].w, L.btn[0].h, L.icon.x, L.icon.y, L.text.x, L.text.y, L.text.w, L.text.h);
    int32_t tw, cy;
    gdi_get_text_extent_point32(&M.msg_font, msg, (int32_t)strlen(msg), &tw, &cy);
    CHECK_EQ(L.btn_w, 75);
    CHECK_EQ(L.btn_h, 23);
    CHECK_EQ(L.icon.x, 11);
    CHECK_EQ(L.icon.y, 11);
    CHECK_EQ(L.text.x, 58);
    CHECK_EQ(L.text.w, tw);
    CHECK_EQ(L.text_lines, 1);
    CHECK_EQ(L.client_w, 11 + 32 + 15 + tw + 11);
    CHECK_EQ(L.client_h, 62 + 32);
    CHECK_EQ(L.btn[0].x, (L.client_w - 75) / 2);
    CHECK_EQ(L.btn[0].y + L.btn[0].h, L.client_h - 11);
    CHECK_EQ(L.text.y, 11 + (32 - L.text.h) / 2);
    /* long text wraps at 5/8 of 1024 */
    static char longmsg[200];
    memset(longmsg, 0, sizeof longmsg);
    for (int i = 0; i < 39; i++) memcpy(longmsg + i * 5, "word ", 5);
    msgbox_layout(&M.msg_font, "t", longmsg, 0x30, 25, &L);
    CHECK(L.text_lines >= 2);
    CHECK(L.client_w <= 640 - 6);

    CHECK_EQ(dlgm_open_messagebox(&M, "Name too long", msg, 0x30, now_ms), 0);
    Dialog *d = &M.dlg;
    CHECK(d->close_button);
    CHECK_EQ(d->focus, dlg_find(d, DLG_IDOK));
    CHECK(d->ctl[d->focus].is_def);
    CHECK_EQ(M.sound_id, 0u); /* no sound file in the pack */
    CHECK(d->icon_rgba == NULL);
    press(DLG_VK_ESCAPE, 0x1B);
    CHECK_EQ(take(&text), 1);     /* MB_OK: Esc returns IDOK */
    CHECK_EQ(dlgm_open_messagebox(&M, "Name too long", msg, 0x30, now_ms), 0);
    d = &M.dlg;
    int32_t cx = d->win_x + d->geom.close.x + 10, cyy = d->win_y + d->geom.close.y + 10;
    dlgm_input(&M, DLG_IN_MOUSEMOVE, cx, cyy, now_ms);
    CHECK(d->close_hot);
    dlgm_input(&M, DLG_IN_BUTTONDOWN, cx, cyy, now_ms);
    CHECK(d->close_pushed);
    dlgm_input(&M, DLG_IN_BUTTONUP, cx, cyy, now_ms);
    CHECK_EQ(take(&text), 1);     /* close button: IDCANCEL mapped to IDOK */
    CHECK_EQ(dlgm_open_messagebox(&M, "t", "x", 0x31, now_ms), 0); /* MB_OKCANCEL */
    press(DLG_VK_ESCAPE, 0x1B);
    CHECK_EQ(take(&text), 2);
    CHECK_EQ(dlgm_open_messagebox(&M, "t", "x", 0x31, now_ms), 0);
    press(DLG_VK_RETURN, '\r');
    CHECK_EQ(take(&text), 1);
    /* only one dialog at a time */
    CHECK_EQ(dlgm_open_messagebox(&M, "t", "x", 0, now_ms), 0);
    CHECK_EQ(dlgm_open_quit_saved(&M, now_ms), -1);
    dlgm_close(&M);
}

static void test_text_layout(void) {
    GdiFont f;
    gdi_font_select(&f, &M.fonts, "MS Sans Serif", -11, 400, 0, 0);
    DtText t;
    dt_layout(&t, &f, "&No", 3, 100, DLG_DT_SINGLELINE);
    CHECK_EQ(t.n, 2);
    CHECK_EQ(t.underline, 0);
    dt_layout(&t, &f, "a&&b", 4, 100, DLG_DT_SINGLELINE);
    CHECK_EQ(t.n, 3);
    CHECK_EQ(t.underline, -1);
    const char *s = "You got a high score! Survival of the fittest at it's best.  Please enter your name:";
    dt_layout(&t, &f, s, (int32_t)strlen(s), 237, DLG_DT_WORDBREAK | DLG_DT_CENTER);
    CHECK_EQ(t.nlines, 2);
    CHECK(t.nlines == 2 && t.line[1].start == (int32_t)(strstr(s, "best.") - s));
    CHECK(t.nlines == 2 && t.s[t.line[0].start + t.line[0].len - 1] == 's'); /* "...at it's" */
    const char *q = "Do you want to leave the game you are currently playing?";
    dt_layout(&t, &f, q, (int32_t)strlen(q), 273, DLG_DT_WORDBREAK);
    printf("quit static lines %d width %d\n", t.nlines, t.width);
}

/* Random input on every dialog (deterministic LCG): no crash, invariants hold. */
static void test_stress(void) {
    uint32_t r = 12345u;
#define RND() (r = r * 1103515245u + 12345u, (r >> 16) & 0x7FFFu)
    static const uint32_t vks[] = {DLG_VK_TAB,  DLG_VK_RETURN, DLG_VK_ESCAPE, DLG_VK_SPACE, DLG_VK_LEFT, DLG_VK_RIGHT,
                                   DLG_VK_UP,   DLG_VK_DOWN,   DLG_VK_HOME,   DLG_VK_END,   DLG_VK_PRIOR, DLG_VK_NEXT,
                                   DLG_VK_BACK, DLG_VK_DELETE, DLG_VK_SHIFT,  DLG_VK_CONTROL, 'A', 'N', 'Y', 'O'};
    int bad = 0, opened = 0;
    uint32_t t = 5000;
    for (int round = 0; round < 400; round++) {
        int kind = round % 4;
        int rc = kind == 0   ? dlgm_open_inputbox(&M, 2, "Congratulations", "prompt text", "Name", 16, t)
                 : kind == 1 ? dlgm_open_quit_saved(&M, t)
                 : kind == 2 ? dlgm_open_tos(&M, t)
                             : dlgm_open_messagebox(&M, "Name too long", "We're sorry.", 0x30, t);
        if (rc != 0) {
            bad++;
            continue;
        }
        opened++;
        for (int k = 0; k < 300 && M.open; k++) {
            uint32_t op = RND() % 9;
            t += RND() % 80;
            Dialog *d = &M.dlg;
            int32_t x = d->win_x - 20 + (int32_t)(RND() % (uint32_t)(d->geom.win_w + 40));
            int32_t y = d->win_y - 20 + (int32_t)(RND() % (uint32_t)(d->geom.win_h + 40));
            switch (op) {
            case 0: case 1: { uint32_t vk = vks[RND() % (sizeof vks / sizeof vks[0])];
                if (vk == DLG_VK_ESCAPE || vk == DLG_VK_RETURN) vk = (RND() % 8) ? DLG_VK_TAB : vk;
                dlgm_input(&M, DLG_IN_KEYDOWN, (int32_t)vk, 0, t); break; }
            case 2: dlgm_input(&M, DLG_IN_KEYUP, (int32_t)vks[RND() % (sizeof vks / sizeof vks[0])], 0, t); break;
            case 3: { uint32_t c = 0x20 + RND() % 0xE0; if (RND() % 10 == 0) c = RND() % 0x20;
                if (c == 0x0D || c == 0x1B) c = 'q';
                dlgm_input(&M, DLG_IN_CHAR, (int32_t)c, 0, t); break; }
            case 4: case 5: dlgm_input(&M, DLG_IN_MOUSEMOVE, x, y, t); break;
            case 6: dlgm_input(&M, (RND() % 6) ? DLG_IN_BUTTONDOWN : (DLG_IN_BUTTONDOWN | 0x200u), x, y, t); break;
            case 7: dlgm_input(&M, DLG_IN_BUTTONUP, x, y, t); break;
            default: dlgm_wheel(&M, (int32_t)(RND() % 480) - 240, t); dlgm_tick(&M, t); break;
            }
            if (M.open) {
                DlgEdit *e = &d->edit;
                if (d->edit_ctl >= 0) {
                    if (e->sel_start > e->len || e->sel_end > e->len || e->y_offset < 0 ||
                        e->y_offset > (e->nlines > e->vlc ? e->nlines - e->vlc : 0) || e->x_offset < 0 ||
                        e->x_offset > (int32_t)e->len)
                        bad++;
                }
                if (d->focus < -1 || d->focus >= d->n) bad++;
                if (d->win_x < 0 || d->win_y < 0 || d->win_x + d->geom.win_w > 800 || d->win_y + d->geom.win_h > 572) bad++;
                if (k % 50 == 0) dlg_draw(d, true);
            }
        }
        if (M.ended) {
            int32_t res;
            const char *txt;
            dlgm_take(&M, &res, &txt);
            if (txt && (int32_t)strlen(txt) > 15) bad++;
        } else {
            dlgm_close(&M);
        }
        dlgm_input(&M, DLG_IN_KEYUP, DLG_VK_SHIFT, 0, t);
    }
#undef RND
    printf("stress: %d dialogs, %d violations\n", opened, bad);
    CHECK_EQ(bad, 0);
    CHECK_EQ(opened, 400);
}

/* ------------------------------------------------------------------ render and dump modes */

static void dump(const char *dir, const char *name) {
    Dialog *d = &M.dlg;
    dlg_draw(d, true);
    char path[1024];
    snprintf(path, sizeof path, "%s/%s.rgba", dir, name);
    FILE *f = fopen(path, "wb");
    if (!f) {
        fprintf(stderr, "cannot write %s\n", path);
        exit(2);
    }
    uint32_t hdr[2] = {(uint32_t)d->img.w, (uint32_t)d->img.h};
    fwrite(hdr, 4, 2, f);
    for (int32_t y = 0; y < d->img.h; y++) fwrite(d->img.px + y * d->img.stride, 4, (size_t)d->img.w, f);
    fclose(f);
    printf("state %s %d %d %d %d\n", name, d->win_x, d->win_y, d->img.w, d->img.h);
}

static int render(const char *dir) {
    int32_t x, y;
    /* high-score name entry: opened after mouse input (cues hidden) */
    M.last_kbd = false;
    dlgm_open_inputbox(&M, 2, "Congratulations",
                       "You got a high score! Survival of the fittest at it's best.  Please enter your name:", "Name",
                       16, now_ms);
    dlg_tick(&M.dlg, now_ms);
    dump(dir, "inputbox_initial");
    dlg_tick(&M.dlg, now_ms + 530);
    dump(dir, "inputbox_initial_caret_off");
    type("tester");
    dump(dir, "inputbox_typed");
    type("abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz");
    dump(dir, "inputbox_typed_long_scrolled");
    press(DLG_VK_TAB, '\t');
    dump(dir, "inputbox_ok_focused");
    KEY(DLG_VK_SPACE);
    dump(dir, "inputbox_ok_pressed");
    dlgm_close(&M);
    /* opened after keyboard input: focus cues shown */
    M.last_kbd = true;
    dlgm_open_inputbox(&M, 2, "Congratulations",
                       "You got a high score! Survival of the fittest at it's best.  Please enter your name:", "Name",
                       16, now_ms);
    dump(dir, "inputbox_initial_kbd");
    dlg_set_focus(&M.dlg, dlg_find(&M.dlg, INPUTBOX_ID_EDIT), true);
    dlgm_close(&M);

    M.last_kbd = false;
    dlgm_open_quit_saved(&M, now_ms);
    dump(dir, "quit_saved_initial");
    ctl_centre(&M.dlg, 0x7d2, &x, &y);
    dlgm_input(&M, DLG_IN_BUTTONDOWN, x, y, now_ms);
    dump(dir, "quit_saved_yes_pressed");
    dlgm_close(&M);
    M.last_kbd = true;
    dlgm_open_quit_saved(&M, now_ms);
    press(DLG_VK_TAB, '\t');
    dump(dir, "quit_saved_yes_focused_kbd");
    dlgm_close(&M);

    M.last_kbd = false;
    dlgm_open_tos(&M, now_ms);
    dump(dir, "tos_initial");
    DlgEdit *e = &M.dlg.edit;
    dlg_edit_scroll_lines(&M.dlg, (e->nlines - e->vlc) / 2);
    dump(dir, "tos_middle");
    dlg_edit_scroll_lines(&M.dlg, e->nlines);
    dump(dir, "tos_end");
    press(DLG_VK_TAB, '\t');
    dlg_edit_scroll_lines(&M.dlg, -e->nlines);
    dump(dir, "tos_edit_focused_all_selected");
    /* pressed down arrow */
    int32_t ed = dlg_find(&M.dlg, TOS_ID_TEXT);
    int32_t sx = M.dlg.win_x + M.dlg.geom.client.x + M.dlg.ctl[ed].r.x + e->sb.x + 8;
    int32_t sy = M.dlg.win_y + M.dlg.geom.client.y + M.dlg.ctl[ed].r.y + e->sb.y + e->sb.h - 8;
    dlgm_input(&M, DLG_IN_MOUSEMOVE, sx, sy, now_ms);
    dlgm_input(&M, DLG_IN_BUTTONDOWN, sx, sy, now_ms);
    dump(dir, "tos_down_arrow_pressed");
    dlgm_close(&M);

    M.last_kbd = true;
    dlgm_open_messagebox(&M, "Name too long", "We're sorry, but names must be 12 letters or smaller.", 0x30, now_ms);
    dump(dir, "msgbox_name_too_long");
    int32_t cx = M.dlg.win_x + M.dlg.geom.close.x + 10, cy = M.dlg.win_y + M.dlg.geom.close.y + 10;
    dlgm_input(&M, DLG_IN_MOUSEMOVE, cx, cy, now_ms);
    dump(dir, "msgbox_close_hot");
    ctl_centre(&M.dlg, DLG_IDOK, &x, &y);
    dlgm_input(&M, DLG_IN_MOUSEMOVE, x, y, now_ms);
    dlgm_input(&M, DLG_IN_BUTTONDOWN, x, y, now_ms);
    dump(dir, "msgbox_ok_pressed");
    dlgm_close(&M);
    return 0;
}

static int rects(void) {
    static const char *names[] = {"DUMPINFO", "DUMPINFO2", "IDD_CONFIRM_SAVE", "IDD_INPUT_BOX", "IDD_INPUT_BOX2",
                                  "IDD_QUIT_NOTSAVED", "IDD_QUIT_SAVED", "IDD_TERMSOFSERVICE"};
    for (size_t i = 0; i < sizeof names / sizeof names[0]; i++) {
        char key[64];
        snprintf(key, sizeof key, "zap/DIALOG/%s", names[i]);
        uint32_t len;
        const uint8_t *t = mpack_find(&M.pack, key, &len);
        if (!t || dlg_create(&M.dlg, &M.env, &M.fonts, t, len) != 0) {
            printf("error %s\n", names[i]);
            continue;
        }
        printf("dialog %s %d %d %s\n", names[i], M.dlg.client_w, M.dlg.client_h, M.dlg.caption);
        for (int32_t k = 0; k < M.dlg.n; k++) {
            DlgControl *c = &M.dlg.ctl[k];
            printf("rect %s %d %d %d %d %d %d\n", names[i], c->id, c->r.x, c->r.y, c->r.w, c->r.h, c->kind);
        }
    }
    return 0;
}

static int tos_dump(void) {
    dlgm_open_tos(&M, now_ms);
    DlgEdit *e = &M.dlg.edit;
    int32_t ed = dlg_find(&M.dlg, TOS_ID_TEXT);
    printf("ctl %d %d %d %d\n", M.dlg.ctl[ed].r.x, M.dlg.ctl[ed].r.y, M.dlg.ctl[ed].r.w, M.dlg.ctl[ed].r.h);
    printf("fmt %d %d %d %d %d\n", e->fmt.x, e->fmt.y, e->fmt.w, e->fmt.h, e->vlc);
    for (int32_t i = 0; i < e->nlines; i++) printf("line %d %u %u\n", i, e->line_start[i], e->line_len[i]);
    dlgm_close(&M);
    return 0;
}

int main(int argc, char **argv) {
    const char *mode = "test";
    const char *pack_path = NULL;
    char def[1200];
    if (argc >= 2 && (!strcmp(argv[1], "render") || !strcmp(argv[1], "rects") || !strcmp(argv[1], "tos"))) {
        mode = argv[1];
        if (argc < 3) return 2;
        pack_path = argv[2];
    } else if (argc >= 2) {
        pack_path = argv[1];
    } else {
        snprintf(def, sizeof def, "%s/port/build/web/pack.bin", test_root());
        pack_path = def;
    }
    long n = 0;
    unsigned char *pack = read_file(pack_path, &n);
    if (!pack) {
        printf("test_dialog: %s missing (run port/build.sh pack); skipped\n", pack_path);
        return 0;
    }
    if (dlgm_init(&M, pack, (uint32_t)n) != 0) {
        fprintf(stderr, "dlgm_init failed\n");
        return 2;
    }
    if (!strcmp(mode, "render")) return argc >= 4 ? render(argv[3]) : 2;
    if (!strcmp(mode, "rects")) return rects();
    if (!strcmp(mode, "tos")) return tos_dump();
    CHECK(M.luna.loaded);
    test_geometry();
    test_text_layout();
    test_inputbox();
    test_quit_saved();
    test_tos();
    test_wrap_rules();
    test_msgbox();
    test_stress();
    /* without Luna data (pack without data/luna/NORMALBLUE): same geometry, plain frame */
    {
        DlgEnv keep = M.env;
        M.env.luna = NULL;
        CHECK_EQ(dlgm_open_messagebox(&M, "Name too long", "x", 0x30, now_ms), 0);
        CHECK_EQ(M.dlg.geom.top, 29);
        CHECK_EQ(M.dlg.geom.close.x, M.dlg.geom.win_w - 25);
        dlg_draw(&M.dlg, true);
        dlgm_close(&M);
        CHECK_EQ(dlgm_open_tos(&M, now_ms), 0);
        CHECK_EQ(M.dlg.edit.sb.w, 17);
        dlg_draw(&M.dlg, true);
        dlgm_close(&M);
        M.env = keep;
    }
    return test_report("test_dialog");
}
