/* Weak defaults of shell_api.h (M4). M5 replaces them with strong definitions. */
#include "shell_api.h"
#include "eng_int.h"

__attribute__((weak)) int32_t shell_dialog_open(Port *p, const ShellDialog *d, int32_t *result, char *text,
                                                uint32_t text_cap) {
    (void)p;
    *result = 1; /* IDOK */
    if (d->kind == SHELL_DLG_INPUTBOX && text && text_cap) {
        uint32_t i = 0;
        const char *s = d->def ? d->def : "";
        for (; s[i] && i + 1 < text_cap; i++) text[i] = s[i];
        text[i] = 0;
    }
    return SHELL_DLG_DONE;
}

__attribute__((weak)) void shell_caption_changed(Port *p, const char *text) {
    (void)p;
    (void)text;
}

__attribute__((weak)) void shell_game_in_progress(Port *p, int32_t flag) {
    (void)p;
    (void)flag;
}

__attribute__((weak)) void shell_buttons_changed(Port *p, uint32_t mask) {
    (void)p;
    (void)mask;
}

__attribute__((weak)) void shell_pause_toggle(Port *p) {
    /* Z:0x41cb30 core: SetPaused(!IsPaused()). The pause page, the click sound and the rail update
     * are the shell's. */
    engine_set_paused(p, !engine_paused(p));
}

__attribute__((weak)) void shell_frame_build(Port *p) { (void)p; }

__attribute__((weak)) void shell_applet_changed(Port *p, bool running) {
    (void)p;
    (void)running;
}

__attribute__((weak)) bool shell_starts_applet(Port *p) {
    (void)p;
    return false;
}

__attribute__((weak)) bool shell_input_blocked(Port *p) {
    (void)p;
    return false;
}
