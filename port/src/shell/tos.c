/* Terms of Service dialog. See tos.h.
 * V: Z:0x405540 loads the resource "TermsOfService" (RCDATA TERMSOFSERVICE, 15418 bytes, CR LF, NUL at
 * the end) and Z:0x404f60 WM_INITDIALOG puts it into edit 2005 with SetDlgItemTextA, then sets the
 * checkbox from the OptOut property (removed here) and returns 1. WM_COMMAND: 0x7d2 (OK) result 0 (the
 * OptOut and SetUserProfile part is removed, decision 5); 1 result 1 (the procedure also calls
 * GetDlgItemTextA(0x3eb) into a stale buffer; the port writes nothing); 2 (Esc) result 2; 0x7d1 result 1;
 * 0x7d3 result 2; 0x7d4 result 3; 0x7d7 opens a second ToS dialog (not reachable: no such control).
 * Port decision (decision 5): checkbox 2006 hidden, every other control at its template position. */
#include "tos.h"

int32_t tos_open(Dialog *d, const DlgEnv *env, const TextFonts *fonts, const MPack *pack, uint32_t now,
                 bool last_input_keyboard) {
    uint32_t len = 0, tlen = 0;
    const uint8_t *t = mpack_find(pack, "zap/DIALOG/IDD_TERMSOFSERVICE", &len);
    const uint8_t *txt = mpack_find(pack, "zap/RCDATA/TERMSOFSERVICE", &tlen);
    if (!t || !txt || dlg_create(d, env, fonts, t, len) != 0) return -1;
    dlg_set_item_text_ext(d, TOS_ID_TEXT, (const char *)txt, tlen);
    dlg_show_item(d, TOS_ID_OPTIN, false);
    dlg_start(d, now, last_input_keyboard, 0);
    return 0;
}

int32_t tos_command(int32_t id) {
    switch (id) {
    case 0x7d2: return 0;
    case 1: return 1;
    case 2: return 2;
    case 0x7d1: return 1;
    case 0x7d3: return 2;
    case 0x7d4: return 3;
    default: return -1;
    }
}
