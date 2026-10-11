/* Windows XP MessageBox layout and procedure. See msgbox.h.
 *
 * Call site: Z:0x4058c0 calls MessageBoxA(frame, text, caption, uType) with uType = MB_OKCANCEL (1)
 * when flags & 2, | MB_ICONEXCLAMATION (0x30) when flags & 0x100 (V: Z:0x4058f1). Moeboid passes 0x101
 * ("Name too long"), so uType = 0x30: MB_OK | MB_ICONEXCLAMATION. The wrapper returns 1 for IDOK and 2 for
 * IDCANCEL (V: Z:0x405930).
 *
 * Layout (I: Windows 2000/XP user32 SoftModalMessageBox as recalled; no Windows ground truth):
 * - font: NONCLIENTMETRICS lfMessageFont = Tahoma 8 (V: Luna [SysMetrics] MsgBoxFont); base units
 *   bx, by of that font; XPix(n) = MulDiv(n, bx, 4), YPix(n) = MulDiv(n, by, 8);
 * - DU_OUTERMARGIN 7, DU_INNERMARGIN 10, DU_BTNGAP 4, DU_BTNHEIGHT 14, DU_BTNWIDTH 50;
 * - button width = max(XPix(50), extent of the longest button string by character count + 2 x
 *   extent("0")); English strings OK, Cancel, &Abort, &Retry, &Ignore, &Yes, &No, &Close, Help,
 *   &Try Again, &Continue; button height YPix(14);
 * - icon column: 32 + XPix(10) when an icon style is set (the port keeps the column although the
 *   icon image is missing; decision of this milestone);
 * - maximum width 5/8 of the work area width (reference 1024 px), caption width = extent of the caption
 *   in the message font + 2 x SM_CXSIZE;
 * - text: DrawText(DT_CALCRECT | DT_WORDBREAK | DT_EXPANDTABS | DT_NOPREFIX | DT_EXTERNALLEADING |
 *   DT_EDITCONTROL), first with the maximum width, then with the final width;
 * - client width = max(min(max width, text + icon + 2 x XPix(7), caption), buttons + 2 x XPix(7));
 *   client height = YPix(2 x 7 + 10 + 14) + max(icon 32, text height);
 * - icon at (XPix(7), YPix(7)); text at x = icon column + XPix(7), y = YPix(7) + (32 - text height) / 2
 *   when the text is lower than the icon; buttons centred, bottom = client height - YPix(7), gap XPix(4);
 * - the window is centred like a dialog (see dialog.c); WS_SYSMENU gives the close button;
 * - MB_OK: Esc and the close button return IDOK (I: user32 maps IDCANCEL to the only button). */
#include "msgbox.h"

static int32_t imax(int32_t a, int32_t b) { return a > b ? a : b; }
static int32_t imin(int32_t a, int32_t b) { return a < b ? a : b; }

static int32_t cx_of(const GdiFont *f, const char *s) {
    int32_t cx, cy;
    gdi_get_text_extent_point32(f, s, (int32_t)rt_strlen(s), &cx, &cy);
    return cx;
}

void msgbox_layout(const GdiFont *font, const char *title, const char *text, uint32_t type, int32_t caption_x_size,
                   MsgBoxLayout *L) {
    static const char *const strings[] = {"OK", "Cancel", "&Abort", "&Retry", "&Ignore", "&Yes",
                                          "&No", "&Close", "Help", "&Try Again", "&Continue"};
    rt_memset(L, 0, sizeof *L);
    int32_t bx, by;
    dlg_base_units(font, &bx, &by);
    L->base_x = bx;
    L->base_y = by;
#define XPIX(n) dlg_muldiv((n), bx, 4)
#define YPIX(n) dlg_muldiv((n), by, 8)
    /* MB_FindLongestString: longest by character count, measured with its '&' */
    const char *longest = strings[0];
    for (uint32_t i = 1; i < RT_COUNTOF(strings); i++)
        if (rt_strlen(strings[i]) > rt_strlen(longest)) longest = strings[i];
    L->btn_w = imax(XPIX(50), cx_of(font, longest) + 2 * cx_of(font, "0"));
    L->btn_h = YPIX(14);
    L->nbtn = ((type & MB_TYPE_MASK) == MB_TYPE_OKCANCEL) ? 2 : 1;
    int32_t cx_buttons = L->nbtn * L->btn_w + (L->nbtn - 1) * XPIX(4);
    bool icon = (type & MB_ICON_MASK) != 0;
    int32_t cx_icon = icon ? 32 + XPIX(10) : 0, cy_icon = icon ? 32 : 0;
    int32_t cx_caption = cx_of(font, title) + 2 * caption_x_size;
    int32_t cx_max = dlg_muldiv(MB_WORK_W, 5, 8);
    int32_t cx_foo = 2 * XPIX(7);
    int32_t cx_box = cx_max - 2 * LUNA_DLG_FRAME;
    uint32_t dt = DLG_DT_WORDBREAK | DLG_DT_EXPANDTABS | DLG_DT_NOPREFIX | DLG_DT_EXTERNALLEADING | DLG_DT_EDITCONTROL;
    DtText t;
    int32_t n = (int32_t)rt_strlen(text);
    dt_layout(&t, font, text, n, cx_box - cx_foo - cx_icon, dt);
    int32_t cx_text = t.width + cx_icon + cx_foo;
    cx_box = imin(cx_box, imax(cx_text, cx_caption));
    cx_box = imax(cx_box, cx_buttons + cx_foo);
    cx_text = cx_box - cx_foo - cx_icon;
    dt_layout(&t, font, text, n, cx_text, dt);
    int32_t cy_text = t.height;
    L->text_lines = t.nlines;
    L->client_w = cx_box;
    L->client_h = YPIX(2 * 7 + 10 + 14) + imax(cy_icon, cy_text);
    int32_t bx0 = (cx_box - cx_buttons) / 2;
    int32_t by0 = L->client_h - YPIX(7) - L->btn_h;
    for (int32_t i = 0; i < L->nbtn; i++) L->btn[i] = (DlgRect){bx0 + i * (L->btn_w + XPIX(4)), by0, L->btn_w, L->btn_h};
    if (icon) L->icon = (DlgRect){XPIX(7), YPIX(7), 32, 32};
    int32_t ty = YPIX(7) + (cy_text < cy_icon ? (cy_icon - cy_text) / 2 : 0);
    L->text = (DlgRect){cx_icon + XPIX(7), ty, cx_text, cy_text};
#undef XPIX
#undef YPIX
}

int32_t msgbox_open(Dialog *d, const DlgEnv *env, const GdiFont *font, const char *title, const char *text,
                    uint32_t type, const uint8_t *icon_rgba, uint32_t now, bool last_input_keyboard) {
    uint32_t bt = type & MB_TYPE_MASK;
    if (bt != MB_TYPE_OK && bt != MB_TYPE_OKCANCEL) return -1;
    /* SM_CXSIZE: the theme gives no CaptionBarWidth; width = height = [SysMetrics] CaptionBarHeight (I). */
    int32_t cxsize = (env->luna && env->luna->loaded) ? luna_metric(env->luna, LUNA_M_CAPTION_BAR_HEIGHT) : 25;
    MsgBoxLayout L;
    msgbox_layout(font, title, text, type, cxsize, &L);
    dlg_init(d, env, font, L.client_w, L.client_h, DLG_WS_SYSMENU | DLG_DS_CENTER, true);
    d->open = false;
    dlg_set_caption(d, title, -1);
    static const char *const labels[2] = {"OK", "Cancel"};
    for (int32_t i = 0; i < L.nbtn; i++) {
        uint32_t st = DLG_WS_VISIBLE | DLG_WS_TABSTOP | (i == 0 ? DLG_WS_GROUP | DLG_BS_DEFPUSHBUTTON : 0);
        dlg_add_control(d, DLG_K_BUTTON, i == 0 ? DLG_IDOK : DLG_IDCANCEL, st, 0, L.btn[i], labels[i], -1);
    }
    if (L.icon.w > 0)
        dlg_add_control(d, DLG_K_ICON, MB_ID_ICON, DLG_WS_VISIBLE | DLG_WS_GROUP | DLG_SS_ICON, 0, L.icon, NULL, 0);
    dlg_add_control(d, DLG_K_STATIC, MB_ID_TEXT,
                    DLG_WS_VISIBLE | DLG_WS_GROUP | DLG_SS_LEFT | DLG_SS_NOPREFIX | DLG_SS_EDITCONTROL, 0, L.text, text,
                    imin((int32_t)rt_strlen(text), DLG_LABEL_MAX - 1));
    d->icon_rgba = icon_rgba;
    /* The default button (MB_DEFBUTTON1) gets the focus (I). */
    dlg_start(d, now, last_input_keyboard, DLG_IDOK);
    return 0;
}

int32_t msgbox_command(uint32_t type, int32_t id) {
    if (id == DLG_IDOK) return DLG_IDOK;
    if (id == DLG_IDCANCEL) return ((type & MB_TYPE_MASK) == MB_TYPE_OK) ? DLG_IDOK : DLG_IDCANCEL;
    return -1;
}
