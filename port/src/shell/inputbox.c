/* Engine InputBox. See inputbox.h.
 * V: Z:0x405480 selects IDD_INPUT_BOX2 unless flags & 2 and stores title, prompt, default text, buffer and
 * size; Z:0x404f60 WM_INITDIALOG (0x110) with DAT_0043633a set: SetWindowTextA(title),
 * SetDlgItemTextA(0x3eb, default), SetDlgItemTextA(0x3ea, prompt), returns 1 (focus to the first tab stop,
 * the edit, with its text selected); WM_COMMAND (0x111): id 1 = GetDlgItemTextA(0x3eb, buffer, size),
 * result 1, EndDialog; id 2 = result 2, EndDialog (buffer untouched). The id check ignores the
 * notification code (V: only LOWORD(wParam) is compared). */
#include "inputbox.h"

int32_t inputbox_open(Dialog *d, const DlgEnv *env, const TextFonts *fonts, const MPack *pack, uint32_t template_box,
                      const char *title, const char *prompt, const char *def, uint32_t now, bool last_input_keyboard) {
    uint32_t len = 0;
    const uint8_t *t = mpack_find(pack, template_box == 1 ? "zap/DIALOG/IDD_INPUT_BOX" : "zap/DIALOG/IDD_INPUT_BOX2", &len);
    if (!t || dlg_create(d, env, fonts, t, len) != 0) return -1;
    dlg_set_caption(d, title ? title : "", -1);
    dlg_set_item_text(d, INPUTBOX_ID_EDIT, def ? def : "", -1);
    dlg_set_item_text(d, INPUTBOX_ID_PROMPT, prompt ? prompt : "", -1);
    dlg_start(d, now, last_input_keyboard, 0);
    return 0;
}

int32_t inputbox_command(Dialog *d, int32_t id, int32_t max_len, char *text, bool *has_text) {
    *has_text = false;
    if (id == DLG_IDOK) {
        dlg_get_item_text(d, INPUTBOX_ID_EDIT, text, max_len);
        *has_text = true;
        return 1;
    }
    if (id == DLG_IDCANCEL) return 2;
    return -1;
}
