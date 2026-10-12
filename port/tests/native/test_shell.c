/* Native test of the shell frame part (M5b): start-up (page start, splash, frame), rail, pages, pause,
 * quit dialog, ToS dialog, sounds, cursors. Runs the real engine with Moeboid.gam on the virtual clock.
 * Data: port/build/web/pack.bin, extracted/Moeboid.gam.
 *
 * Frames: every captured state is written as raw RGBA ("RGBA", u32 w, u32 h, rows) to the directory
 * SHELL_OUT (default port/build/shell_frames); port/tests/py/test_shell_compare.py converts them to PNG
 * (port/tests/results/shell/) and compares them with the Wine references.
 * Usage: test_shell [smooth]   (default: font smoothing off, as the screens_monofonts references) */
#include <sys/stat.h>

#include "core/sound_ids.h"
#include "engine/engine.h"
#include "gfx/cursor.h"
#include "shell/shell_frame.h"
#include "test.h"

/* engine test entry (src/engine/eng_testapi.c): text smoothing of the engine (game text) */
void engine_test_smoothing(Port *p, bool on);

static Port *P;
static uint32_t T;          /* host ms = virtual ms (1 ms step) */
static char out_dir[1024];
static int sounds[PORT_SND_ID_END + 1];

static uint8_t *read_file(const char *rel, uint32_t *len) {
    char path[1024];
    snprintf(path, sizeof path, "%s/%s", test_root(), rel);
    FILE *f = fopen(path, "rb");
    if (!f) return NULL;
    fseek(f, 0, SEEK_END);
    long n = ftell(f);
    fseek(f, 0, SEEK_SET);
    uint8_t *b = malloc((size_t)n + 1);
    if (fread(b, 1, (size_t)n, f) != (size_t)n) n = 0;
    fclose(f);
    *len = (uint32_t)n;
    return b;
}

static void drain_sounds(void) {
    PortSoundCmd cmd[PORT_SOUND_QUEUE_MAX];
    uint32_t n = core_sound_drain(P, cmd);
    for (uint32_t i = 0; i < n; i++)
        if (cmd[i].op == PORT_SND_OP_PLAY && cmd[i].sound_id < PORT_SND_ID_END) sounds[cmd[i].sound_id]++;
}

/* Advance the host clock in 16 ms frames (below PORT_MAX_LATE_MS, so no step is skipped). */
static void adv(uint32_t ms) {
    uint32_t end = T + ms;
    while (T < end) {
        T += (end - T) < 16u ? (end - T) : 16u;
        core_advance(P, T);
        drain_sounds();
    }
}

static void input(uint32_t kind, int32_t a, int32_t b) {
    core_input(P, kind, a, b, T);
    adv(1);
}

static void click(int32_t x, int32_t y) {
    input(PORT_IN_MOUSEMOVE, x, y);
    adv(30);
    input(PORT_IN_BUTTONDOWN, x, y);
    adv(60);
    input(PORT_IN_BUTTONUP, x, y);
    adv(30);
}

static void away(void) {
    click(100, 300);
    adv(300);
}

static void save(const char *name) {
    char path[1200];
    snprintf(path, sizeof path, "%s/%s.rgba", out_dir, name);
    FILE *f = fopen(path, "wb");
    if (!f) {
        fprintf(stderr, "test_shell: cannot write %s\n", path);
        t_fail++;
        return;
    }
    uint32_t hdr[2] = {PORT_W, PORT_H};
    fwrite("RGBA", 1, 4, f);
    fwrite(hdr, 4, 2, f);
    fwrite(P->frame, 1, (size_t)PORT_W * PORT_H * 4u, f);
    fclose(f);
    printf("frame %s t=%u\n", name, T);
}

static uint32_t rgb(int32_t x, int32_t y) {
    const uint8_t *q = P->frame + ((size_t)y * PORT_W + (size_t)x) * 4u;
    return (uint32_t)q[0] << 16 | (uint32_t)q[1] << 8 | q[2];
}

int main(int argc, char **argv) {
    int smooth = argc > 1 && !strcmp(argv[1], "smooth");
    const char *env = getenv("SHELL_OUT");
    if (env) snprintf(out_dir, sizeof out_dir, "%s", env);
    else snprintf(out_dir, sizeof out_dir, "%s/port/build/shell_frames", test_root());
    mkdir(out_dir, 0755);
    uint32_t pack_len = 0, gam_len = 0;
    const char *pack_rel = getenv("SHELL_PACK"); /* diagnostic packs (test_shell_compare.py --wine-metrics) */
    uint8_t *pack = read_file(pack_rel ? pack_rel : "port/build/web/pack.bin", &pack_len);
    uint8_t *gam = read_file("extracted/Moeboid.gam", &gam_len);
    if (!pack || !gam) {
        printf("test_shell: skipped (pack.bin or Moeboid.gam missing)\n");
        return 0;
    }
    P = calloc(1, sizeof(Port));
    core_init(P, 0, 0xffffffffu, 1);
    shell_test_set_smoothing(P, smooth); /* before core_start: the engine init builds the frame */
    CHECK_EQ(core_start(P, pack, pack_len, gam, gam_len), 0);
    engine_test_smoothing(P, smooth); /* game text drawn from now on (the title screen is drawn already) */
    CHECK_EQ(shell_test_phase(P), SH_WAIT_START);

    /* page start (kind 8) at host time 0, then the splash for 2000 ms of virtual time (decision 13) */
    T = 0;
    core_input(P, PORT_IN_START, 0, 0, 0);
    adv(1000);
    CHECK_EQ(shell_test_phase(P), SH_SPLASH);
    CHECK_EQ(rgb(0, 0), 0x000000);
    save("splash");
    click(95, 234); /* About, not visible yet: no input reaches the frame during the splash */
    CHECK_EQ(shell_test_last_page(P), -1);
    adv(990 - 121);
    CHECK_EQ(shell_test_phase(P), SH_SPLASH);
    {
        /* decision 13 and the original start-up order: the applet starts when the splash ends
         * (shell_starts_applet), so no game sound plays behind the splash */
        int n = 0;
        for (int i = 1; i < PORT_SND_ID_END; i++) n += sounds[i];
        CHECK(!engine_applet_running(P));
        CHECK_EQ(n, 0);
    }
    adv(20);
    CHECK_EQ(shell_test_phase(P), SH_RUNNING);
    CHECK(engine_applet_running(P));
    CHECK_EQ(sounds[PORT_SND_GAMEOPEN], 1); /* the title screen sound, when the frame shows */
    CHECK_EQ(shell_test_last_page(P), 1200); /* start-up: View All Games, then New Game (Z:0x41ea43) */
    adv(1000);
    save("title");
    /* frame colour, ad area (decision 9), removed subscribe box area, installed fill */
    CHECK_EQ(rgb(300, 530), 0x3333cc);
    CHECK_EQ(rgb(100, 500), 0x3333cc);
    CHECK_EQ(rgb(20, 470), 0x3333cc);
    /* rail for mask 0x33: Mail This slot empty (decision 7), New Game, Pause, How To Play */
    int32_t x, y;
    CHECK(!shell_test_point(P, "rail0", &x, &y));
    CHECK(shell_test_point(P, "rail1", &x, &y) && y == 152 + 23);
    CHECK(shell_test_point(P, "rail2", &x, &y) && y == 219 + 23);
    CHECK(!shell_test_point(P, "rail3", &x, &y));
    CHECK(!shell_test_point(P, "rail4", &x, &y));
    CHECK(shell_test_point(P, "rail5", &x, &y) && y == 286 + 23);

    /* cursors: hand over a button (rendering.md 8: HAND.CUR id 1), pointer elsewhere */
    shell_test_point(P, "help", &x, &y);
    input(PORT_IN_MOUSEMOVE, x, y);
    adv(20);
    CHECK_EQ(P->cursor, CURSOR_HAND);
    input(PORT_IN_MOUSEMOVE, 100, 330);
    adv(20);
    CHECK_EQ(P->cursor, CURSOR_POINTER);

    /* The sequence below mirrors analysis/reference/screens_monofonts/steps_m5b.txt (Wine), with the same
     * frame coordinates; "away" = a click on the news text area (no handler in both), so that no button
     * shows its hover face in the capture. */
    /* How To Play: click sound, page with the game's HELP.ZML, paused, Resume on the rail */
    int clicks0 = sounds[PORT_SND_BTNCLICK];
    click(233, 310);
    adv(2000);
    CHECK_EQ(sounds[PORT_SND_BTNCLICK], clicks0 + 1);
    CHECK(engine_paused(P));
    CHECK(shell_test_point(P, "rail3", &x, &y));
    CHECK(shell_test_point(P, "footer", &x, &y) && x == 740 && y == 450);
    away();
    save("how_to_play");
    click(233, 242); /* Resume */
    adv(1500);
    CHECK(!engine_paused(P));
    CHECK(shell_test_point(P, "rail2", &x, &y));
    click(233, 242); /* Pause: pause page and footer */
    adv(1500);
    CHECK(engine_paused(P));
    away();
    save("paused");
    click(740, 450); /* footer arrow: back to the game */
    adv(1500);
    CHECK(!engine_paused(P));

    /* Escape toggles the pause (Z:0x4040e0); not passed to the game */
    input(PORT_IN_KEYDOWN, 0x1b, 0);
    input(PORT_IN_KEYUP, 0x1b, 0);
    adv(100);
    CHECK(engine_paused(P));
    input(PORT_IN_KEYDOWN, 0x1b, 0);
    input(PORT_IN_KEYUP, 0x1b, 0);
    adv(100);
    CHECK(!engine_paused(P));

    /* Help contents and topics (links of page 101) */
    click(718, 22);
    adv(2000);
    away();
    save("help_101");
    for (int id = 111; id <= 118; id++) {
        char name[32];
        snprintf(name, sizeof name, "link%d", id);
        if (shell_test_point(P, name, &x, &y)) {
            printf("link %d at %d %d\n", id, x, y);
            click(x, y);
        } else {
            fprintf(stderr, "test_shell: no link to help page %d\n", id);
            t_fail++;
        }
        adv(2000);
        away();
        snprintf(name, sizeof name, "help_%d", id);
        save(name);
        click(718, 22);
        adv(1500);
    }

    /* About, Personalize (sound toggle) */
    click(95, 234);
    adv(2000);
    away();
    save("about");
    click(95, 199);
    adv(2000);
    away();
    save("personalize_sound_on");
    CHECK(engine_sound_enabled(P));
    CHECK(shell_test_point(P, "toggle", &x, &y) && x == 676 && y == 308);
    click(676, 308);
    adv(2000);
    CHECK(!engine_sound_enabled(P));
    away();
    save("personalize_sound_off");
    click(676, 308);
    adv(1500);
    CHECK(engine_sound_enabled(P));
    click(740, 450);
    adv(1500);

    /* View All Games on the title screen (no game in progress: no dialog, the game stops) */
    click(95, 164);
    adv(2000);
    CHECK(!engine_applet_running(P));
    CHECK(!shell_test_point(P, "rail1", &x, &y));
    CHECK(shell_test_point(P, "tile0", &x, &y) && x == 333 && y == 111);
    away();
    save("view_all_games");
    click(333, 111); /* the Moeboid tile: New Game */
    adv(3000);
    CHECK(engine_applet_running(P));
    away();
    save("title_again");

    /* a game: the Start button of the title screen (G:0x1000428e, game (250, 190)) */
    click(557, 252);
    adv(8000);
    away();
    save("game_running");
    /* New Game during a game: IDD_QUIT_SAVED (M5a); Esc keeps the game */
    click(233, 175);
    adv(2000);
    CHECK(shell_modal_active(P));
    save("quit_dialog");
    input(PORT_IN_KEYDOWN, 0x1b, 0);
    input(PORT_IN_KEYUP, 0x1b, 0);
    adv(1000);
    CHECK(!shell_modal_active(P));
    CHECK(engine_applet_running(P));

    /* a second New Game during the game: Yes stops it and starts a new one (title screen); the pointer
     * over the dialog shows the dialog arrow (port_cursor 6), the game gets no input meanwhile */
    click(233, 175);
    adv(1000);
    CHECK(shell_modal_active(P));
    input(PORT_IN_MOUSEMOVE, 300, 300);
    CHECK_EQ(P->cursor, SH_CURSOR_ARROW);
    click(350, 314); /* Yes */
    adv(2000);
    CHECK(!shell_modal_active(P));
    CHECK(engine_applet_running(P));
    away();
    int hover_px = 0;
    for (int yy = 195; yy < 215; yy++)
        for (int xx = 195; xx < 270; xx++) hover_px += rgb(xx, yy) == 0xffff33;
    CHECK_EQ(hover_px, 0); /* New Game caption back to its normal face after the pointer left */
    save("new_game_after_yes");

    /* Terms of Service link (M5a dialog) */
    click(120, 531);
    adv(2000);
    CHECK(shell_modal_active(P));
    save("tos_dialog");
    input(PORT_IN_KEYDOWN, 0x0d, 0); /* Enter = OK */
    input(PORT_IN_KEYUP, 0x0d, 0);
    adv(1000);
    CHECK(!shell_modal_active(P));
    printf("sounds: btnclick %d popup %d openshell %d closeshell %d\n", sounds[PORT_SND_BTNCLICK],
           sounds[PORT_SND_POPUP], sounds[PORT_SND_OPENSHELL], sounds[PORT_SND_CLOSESHELL]);
    CHECK_EQ(sounds[PORT_SND_OPENSHELL], 0); /* a game file is given (Z:0x41b1ee) */
    CHECK_EQ(sounds[PORT_SND_POPUP], 0);     /* loaded, never played */
    CHECK_EQ(sounds[PORT_SND_CLOSESHELL], 0); /* close button removed (decision 8a) */
    const char *fault = engine_fault_text(P);
    if (fault && fault[0]) {
        fprintf(stderr, "engine fault: %s\n", fault);
        t_fail++;
    }
    return test_report("test_shell");
}
