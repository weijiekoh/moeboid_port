/* Integration test of src/shell/shell_modal.c (shell_api.h contract of M4) with a stub engine.
 * The stub stands for the engine side of Z:0x405480 / Z:0x4058c0 and for the game's name entry rule
 * (G:0x100038d3: 13 or more characters give the "Name too long" box, then the InputBox again with the
 * previous default). Usage: test_dialog_modal [PACK] (default <root>/port/build/web/pack.bin; skipped
 * when missing). Built by port/build.sh native; also by port/tests/py/test_dialog.py. */
#include "core/port.h"
#include "engine/engine.h"
#include "engine/shell_api.h"
#include "shell/shell_modal.h"
#include "test.h"

/* ---------------------------------------------------------------- stub engine */
static struct {
    int done_calls;
    int32_t last_result;
    char last_text[64];
    bool last_text_null;
    int invalidates, renders;
    int32_t inv_x, inv_y, inv_w, inv_h;
    bool paused;
    bool emulate_game; /* engine_dialog_done runs the game's name rule */
    int opened;
} E;

static ShellDialog input_box(uint32_t seq) {
    ShellDialog d = {0};
    d.kind = SHELL_DLG_INPUTBOX;
    d.title = "Congratulations";
    d.text = "You got a high score! Survival of the fittest at it's best.  Please enter your name:";
    d.def = "Name";
    d.flags = 1;
    d.mb_type = 0;
    d.template_box = 2;
    d.max_len = 16;
    d.input_seq = seq;
    return d;
}

void engine_dialog_done(Port *p, int32_t result, const char *text) {
    E.done_calls++;
    E.last_result = result;
    E.last_text_null = text == NULL;
    snprintf(E.last_text, sizeof E.last_text, "%s", text ? text : "");
    if (!E.emulate_game) return;
    int32_t r;
    char buf[64];
    if (text && strlen(text) >= 13) {
        ShellDialog m = {0};
        m.kind = SHELL_DLG_MESSAGEBOX;
        m.title = "Name too long";
        m.text = "We're sorry, but names must be 12 letters or smaller.";
        m.flags = 0x101;
        m.mb_type = 0x30;
        if (shell_dialog_open(p, &m, &r, buf, sizeof buf) == SHELL_DLG_OPEN) E.opened++;
    } else if (!text && result == 1 && E.opened == 1) {
        ShellDialog d = input_box(0);
        if (shell_dialog_open(p, &d, &r, buf, sizeof buf) == SHELL_DLG_OPEN) E.opened++;
    }
}
void engine_invalidate(Port *p, int32_t x, int32_t y, int32_t w, int32_t h) {
    (void)p;
    E.invalidates++;
    E.inv_x = x;
    E.inv_y = y;
    E.inv_w = w;
    E.inv_h = h;
}
void engine_render(Port *p) {
    E.renders++;
    core_frame_fill(p, PORT_BG_RGBA); /* the frame below the dialog */
}
uint32_t engine_render_count(Port *p) {
    (void)p;
    return (uint32_t)E.renders;
}
bool engine_paused(Port *p) {
    (void)p;
    return E.paused;
}
/* M5b: shell_modal.c holds the engine while a frame-opened dialog (quit, ToS) is open */
void engine_modal_hold(Port *p, bool on) {
    (void)p;
    (void)on;
}
void engine_set_paused(Port *p, bool paused) {
    (void)p;
    E.paused = paused;
}

/* ---------------------------------------------------------------- helpers */
static Port P;
static uint32_t seq = 100;

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

/* Deliver one event as core deliver() does: the event is out of the queue, later events stay queued. */
static void deliver(uint32_t kind, int32_t a, int32_t b) {
    PortInput ev = {0};
    ev.kind = kind;
    ev.a = a;
    ev.b = b;
    ev.seq = ++seq;
    shell_modal_input(&P, &ev);
}
static void queue_char(int32_t c) {
    PortInput ev = {0};
    ev.kind = PORT_IN_CHAR;
    ev.a = c;
    inq_push(&P.input, ev);
}
/* key press: down (with its character queued behind it), character, up */
static void press(uint32_t vk, int32_t ch) {
    if (ch >= 0) queue_char(ch);
    deliver(PORT_IN_KEYDOWN, (int32_t)vk, 0);
    if (ch >= 0) {
        inq_pop(&P.input);
        deliver(PORT_IN_CHAR, ch, 0);
    }
    deliver(PORT_IN_KEYUP, (int32_t)vk, 0);
}
static void type(const char *s) {
    for (; *s; s++) press((uint32_t)((*s >= 'a' && *s <= 'z') ? *s - 32 : *s), *s);
}
static uint32_t frame_px(int32_t x, int32_t y) {
    const uint8_t *q = P.frame + ((size_t)y * PORT_W + (size_t)x) * 4u;
    return (uint32_t)q[0] | ((uint32_t)q[1] << 8) | ((uint32_t)q[2] << 16) | ((uint32_t)q[3] << 24);
}

int main(int argc, char **argv) {
    char def[1200];
    const char *path = argc > 1 ? argv[1] : NULL;
    if (!path) {
        snprintf(def, sizeof def, "%s/port/build/web/pack.bin", test_root());
        path = def;
    }
    long n = 0;
    unsigned char *pack = read_file(path, &n);
    if (!pack) {
        printf("test_dialog_modal: %s missing; skipped\n", path);
        return 0;
    }
    core_init(&P, 0, 0xFFFFFFFFu, 1);
    P.pack = pack;
    P.pack_len = (uint32_t)n;
    CHECK_EQ(shell_modal_init(&P), 0);
    struct Shell *s = P.shell;
    CHECK(s && s->ok);

    /* the game opens the name entry during the key event seq 101 (a key press: cues shown) */
    int32_t r = -1;
    char buf[64];
    ShellDialog d = input_box(seq + 1);
    CHECK_EQ(shell_dialog_open(&P, &d, &r, buf, sizeof buf), SHELL_DLG_OPEN);
    CHECK(shell_modal_active(&P));
    deliver(PORT_IN_KEYDOWN, 'A', 0); /* the opening event: not typed into the box */
    CHECK_STR(s->modal.dlg.edit.buf, "Name");
    CHECK_EQ(s->modal.dlg.ui_state, 0);
    deliver(PORT_IN_KEYUP, 'A', 0);
    /* composition: the frame hook draws the window into the frame */
    P.out_flags = 0;
    shell_modal_frame(&P);
    CHECK(P.out_flags & PORT_ADV_FRAME);
    Dialog *dl = &s->modal.dlg;
    int32_t cx = dl->win_x + dl->geom.client.x + 2, cy = dl->win_y + dl->geom.client.y + 2;
    CHECK_EQ(frame_px(cx, cy), 0xFFD8E9ECu);            /* COLOR_3DFACE 236 233 216 */
    CHECK_EQ(frame_px(dl->win_x, dl->win_y), PORT_BG_RGBA); /* rounded corner: frame stays */
    /* no change: no composition; an engine render: composition again */
    P.out_flags = 0;
    shell_modal_frame(&P);
    CHECK(!(P.out_flags & PORT_ADV_FRAME));
    engine_render(&P);
    P.out_flags = 0;
    shell_modal_frame(&P);
    CHECK(P.out_flags & PORT_ADV_FRAME);
    CHECK_EQ(frame_px(cx, cy), 0xFFD8E9ECu);
    /* cursor */
    CHECK_EQ(shell_modal_cursor(&P, dl->win_x + dl->geom.client.x + 20, dl->win_y + dl->geom.client.y + 50),
             DLG_CURSOR_IBEAM);
    CHECK_EQ(shell_modal_cursor(&P, dl->win_x + dl->geom.client.x + 20, dl->win_y + dl->geom.client.y + 20),
             DLG_CURSOR_ARROW);
    CHECK_EQ(shell_modal_cursor(&P, 5, 5), DLG_CURSOR_NONE);

    /* 13 letters: Enter ends the box; the engine hears of it only after the dropped WM_CHAR */
    E.emulate_game = true;
    int32_t old_x = dl->win_x, old_w = dl->geom.win_w;
    type("abcdefghijklm");
    queue_char('\r');
    deliver(PORT_IN_KEYDOWN, 0x0D, 0);
    CHECK(!s->modal.open);
    CHECK_EQ(E.done_calls, 0);
    CHECK(s->pending);
    inq_pop(&P.input);
    deliver(PORT_IN_CHAR, '\r', 0);
    CHECK_EQ(E.done_calls, 1);
    CHECK_EQ(E.last_result, 1);
    CHECK_STR(E.last_text, "abcdefghijklm");
    CHECK(E.invalidates >= 1);                         /* the old window area is repainted */
    CHECK_EQ(E.inv_x, old_x);
    CHECK_EQ(E.inv_w, old_w);
    /* the game opened "Name too long" inside engine_dialog_done */
    CHECK_EQ(E.opened, 1);
    CHECK(s->modal.open && s->modal.kind == DLGM_MESSAGEBOX);
    CHECK(s->engine_wait);
    deliver(PORT_IN_KEYUP, 0x0D, 0);
    CHECK(s->modal.open);
    /* OK by mouse click: result IDOK, then the game opens the name entry again (default "Name") */
    dl = &s->modal.dlg;
    int32_t ok = dlg_find(dl, 1);
    int32_t bx = dl->win_x + dl->geom.client.x + dl->ctl[ok].r.x + 10, by = dl->win_y + dl->geom.client.y + dl->ctl[ok].r.y + 10;
    deliver(PORT_IN_MOUSEMOVE, bx, by);
    deliver(PORT_IN_BUTTONDOWN, bx, by);
    deliver(PORT_IN_BUTTONUP, bx, by);
    CHECK_EQ(E.done_calls, 2);
    CHECK_EQ(E.last_result, 1);
    CHECK(E.last_text_null);
    CHECK_EQ(E.opened, 2);
    CHECK(s->modal.open && s->modal.kind == DLGM_INPUTBOX);
    CHECK_STR(s->modal.dlg.edit.buf, "Name");
    CHECK(s->modal.dlg.ui_state & DLG_UISF_HIDEFOCUS); /* opened after a mouse click */
    E.emulate_game = false;
    type("tester");
    press(0x0D, '\r');
    CHECK_EQ(E.done_calls, 3);
    CHECK_STR(E.last_text, "tester");
    CHECK(!shell_modal_active(&P));
    /* the next character after the close belongs to the game again */
    deliver(PORT_IN_CHAR, 'x', 0);
    CHECK_EQ(E.done_calls, 3);
    /* Esc: IDCANCEL without text */
    d = input_box(0);
    CHECK_EQ(shell_dialog_open(&P, &d, &r, buf, sizeof buf), SHELL_DLG_OPEN);
    press(0x1B, 0x1B);
    CHECK_EQ(E.done_calls, 4);
    CHECK_EQ(E.last_result, 2);
    CHECK(E.last_text_null);

    /* frame-opened Terms of Service: pause around the dialog, result by polling */
    E.paused = false;
    CHECK_EQ(shell_modal_open_tos(&P), 0);
    CHECK(E.paused);
    shell_modal_frame(&P);
    /* wheel (proposed kind 10) while the focus is on OK: ignored; after Tab: 3 lines */
    deliver(SHELL_IN_WHEEL, -120, 0);
    CHECK_EQ(s->modal.dlg.edit.y_offset, 0);
    press(0x09, '\t');
    deliver(SHELL_IN_WHEEL, -120, 0);
    CHECK_EQ(s->modal.dlg.edit.y_offset, 3);
    shell_modal_wheel(&P, -240);
    CHECK_EQ(s->modal.dlg.edit.y_offset, 9);
    uint32_t kind = 0;
    CHECK(!shell_modal_take_result(&P, &kind, &r));
    press(0x1B, 0x1B);
    CHECK(shell_modal_take_result(&P, &kind, &r));
    CHECK_EQ(kind, DLGM_TOS);
    CHECK_EQ(r, 2);
    CHECK(!E.paused);
    CHECK_EQ(E.done_calls, 4); /* the engine is not told about frame dialogs */
    /* IDD_QUIT_SAVED while paused: the pause stays */
    E.paused = true;
    CHECK_EQ(shell_modal_open_quit_saved(&P), 0);
    CHECK_EQ(shell_modal_open_tos(&P), -1); /* one at a time */
    press('Y', 'y');
    CHECK(shell_modal_take_result(&P, &kind, &r));
    CHECK_EQ(kind, DLGM_QUIT_SAVED);
    CHECK_EQ(r, 0);
    CHECK(E.paused);
    /* no sound file in the pack: no sound command for the exclamation box */
    CHECK_EQ(core_sound_drain(&P, NULL), 0);
    return test_report("test_dialog_modal");
}
