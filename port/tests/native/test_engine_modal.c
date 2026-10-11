/* Native test of the modal suspend/resume (M4): ISystem::InputBox and ISystem::MessageBox called by
 * Moeboid.gam inside its play timer (G:0x100037d0) while the dialog stays open across steps.
 *
 * A fake shell (strong shell_dialog_open below; the engine has a weak default) keeps every dialog
 * open (SHELL_DLG_OPEN); the test closes it later with engine_dialog_done. Three runs of the autopilot
 * recording (analysis/verification/logs/run_autopilot.input.tsv, 45 s):
 *   A  dialogs close at once (engine_test_auto_dialogs, answer "TEST");
 *   B  the InputBox stays open 5000 ms, then OK with "TEST";
 *   C  first answer "ABCDEFGHIJKLM" (13 letters): "Name too long" MessageBox (flags 0x101) opens from
 *      inside the resumed game call, then a second InputBox, then "TEST".
 * B and C must give the call hashes and state digests of A in every tick; the clock ms of the ticks
 * after the dialog are later by the dialog time (the game clock was paused during the dialog). */
#include "engine/eng_int.h"
#include "engine/shell_api.h"
#include "test.h"

/* ---- fake shell ---- */
static ShellDialog g_last;
static char g_title[128], g_text[256], g_def[128];

int32_t shell_dialog_open(Port *p, const ShellDialog *d, int32_t *result, char *text, uint32_t text_cap) {
    (void)p;
    (void)result;
    (void)text;
    (void)text_cap;
    g_last = *d;
    snprintf(g_title, sizeof g_title, "%s", d->title ? d->title : "");
    snprintf(g_text, sizeof g_text, "%s", d->text ? d->text : "");
    snprintf(g_def, sizeof g_def, "%s", d->def ? d->def : "");
    return SHELL_DLG_OPEN;
}

/* ---- trace rows ---- */
typedef struct Row {
    uint32_t tick, ms, calls;
    char hash[17], state[13];
} Row;
static Row *g_rows;
static int g_nrows, g_caprows;
static char g_tbuf[1024];
static size_t g_tlen;

static void on_trace(const char *s, uint32_t n) {
    for (uint32_t i = 0; i < n; i++) {
        if (s[i] != '\n') {
            if (g_tlen + 1 < sizeof g_tbuf) g_tbuf[g_tlen++] = s[i];
            continue;
        }
        g_tbuf[g_tlen] = 0;
        g_tlen = 0;
        if (g_tbuf[0] < '0' || g_tbuf[0] > '9') continue;
        if (g_nrows >= g_caprows) {
            g_caprows = g_caprows ? g_caprows * 2 : 4096;
            g_rows = realloc(g_rows, (size_t)g_caprows * sizeof *g_rows);
        }
        Row *r = &g_rows[g_nrows++];
        memset(r, 0, sizeof *r);
        sscanf(g_tbuf, "%u\t%u\t%u\t%16s\t%12s", &r->tick, &r->ms, &r->calls, r->hash, r->state);
    }
}

/* ---- recording ---- */
typedef struct Ev {
    uint32_t ms;
    char kind[16], value[32];
} Ev;

static int load_rec(const char *rel, Ev *ev, int max) {
    char path[1024], line[256];
    snprintf(path, sizeof path, "%s/%s", test_root(), rel);
    FILE *f = fopen(path, "r");
    if (!f) return -1;
    int n = 0;
    while (fgets(line, sizeof line, f) && n < max) {
        if (line[0] == '#' || line[0] == 'm') continue;
        unsigned ms, tick;
        if (sscanf(line, "%u\t%u\t%15s\t%31[^\n]", &ms, &tick, ev[n].kind, ev[n].value) == 4) {
            ev[n].ms = ms;
            n++;
        }
    }
    fclose(f);
    return n;
}

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

void engine_test_goto(Port *p, uint32_t ms);
void engine_test_input(Port *p, uint32_t kind, int32_t a, int32_t b);
void engine_test_finish_step(Port *p);
bool engine_test_storage_set(Port *p, const char *key, const char *value);

static const uint32_t k_key_vk[13] = {0x08, 0x2e, 0x09, 0x0d, 0x04, 0x11, 0x25, 0x27, 0x26, 0x28, 0x24, 0x23, 0x10};

typedef struct RunInfo {
    int dialogs;               /* dialogs opened */
    uint32_t dialog_open_ms;   /* clock ms when the first dialog opened */
    uint32_t delay;            /* total time the dialogs stayed open */
    uint32_t waiting_ticks;    /* trace ticks that began while the dialog was open (must be 0) */
    bool paused_after;         /* pause state after the last close */
    char first_title[128], second_text[256];
    uint32_t second_flags;
} RunInfo;

/* mode 0: auto dialogs; 1: InputBox open 5000 ms, answer "TEST"; 2: 13-letter name, then MessageBox,
 * then InputBox "TEST". */
static void run(const uint8_t *pack, uint32_t pack_len, const uint8_t *gam, uint32_t gam_len, const Ev *ev, int nev,
                uint32_t ms_end, int mode, RunInfo *ri) {
    memset(ri, 0, sizeof *ri);
    g_nrows = 0;
    rt_set_sinks(NULL, on_trace);
    Port *p = (Port *)calloc(1, sizeof(Port));
    for (int i = 1; i <= 5; i++) {
        char k[96], v[16];
        snprintf(k, sizeof k, "game/{2BFDD7F8-0EC4-4E7C-9FF4-3B2F8DC1D0F2}/Score%dName", i);
        engine_test_storage_set(p, k, "ZapSpot");
        snprintf(k, sizeof k, "game/{2BFDD7F8-0EC4-4E7C-9FF4-3B2F8DC1D0F2}/Score%dScore", i);
        snprintf(v, sizeof v, "%d", 60 - 10 * i);
        engine_test_storage_set(p, k, v);
    }
    core_init(p, 0, 0xffffffffu, 12345);
    trace_set_mode(&p->trace, TRACE_HASH);
    CHECK_EQ(core_start(p, pack, pack_len, gam, gam_len), 0);
    engine_test_auto_dialogs(p, mode == 0);
    if (mode == 0) engine_test_answer(p, "TEST");
    core_advance(p, 0);
    uint32_t shift = 0; /* the recording's times are game times: add the dialog time */
    int i = 0;
    while (i < nev && ev[i].ms <= ms_end) {
        uint32_t ms = ev[i].ms + shift;
        engine_test_goto(p, ms);
        while (i < nev && ev[i].ms + shift == ms) {
            const Ev *e = &ev[i];
            if (!strcmp(e->kind, "keydown") || !strcmp(e->kind, "keyup")) {
                int idx = atoi(e->value);
                engine_test_input(p, e->kind[3] == 'd' ? PORT_IN_KEYDOWN : PORT_IN_KEYUP, (int32_t)k_key_vk[idx], 0);
            } else if (!strcmp(e->kind, "vk")) {
                engine_test_input(p, PORT_IN_KEYDOWN, atoi(e->value), 0);
                engine_test_input(p, PORT_IN_KEYUP, atoi(e->value), 0);
            } else if (!strcmp(e->kind, "click")) {
                int32_t x, y;
                CHECK(engine_test_button_point(p, e->value, &x, &y));
                engine_test_input(p, PORT_IN_MOUSEMOVE, x, y);
                engine_test_input(p, PORT_IN_BUTTONDOWN, x, y);
                engine_test_input(p, PORT_IN_BUTTONUP, x, y);
            } else if (!strcmp(e->kind, "event")) {
                engine_applet_event(p, atoi(e->value) == 16 ? 1 : 0);
            }
            i++;
        }
        engine_test_finish_step(p);
        while (engine_dialog_waiting(p)) {
            /* the dialog stays open; time passes; no game tick and no timer pass may run */
            ri->dialogs++;
            if (ri->dialogs == 1) {
                ri->dialog_open_ms = core_ticks(p);
                snprintf(ri->first_title, sizeof ri->first_title, "%s", g_title);
            }
            if (ri->dialogs == 2) {
                snprintf(ri->second_text, sizeof ri->second_text, "%s", g_text);
                ri->second_flags = g_last.flags;
            }
            uint32_t ticks0 = p->trace.tick, passes0 = (uint32_t)p->passes;
            uint32_t wait = mode == 1 ? 5000u : 1000u + 250u * (uint32_t)ri->dialogs;
            uint32_t t = core_ticks(p);
            for (uint32_t k = 100; k <= wait; k += 100) core_advance(p, t + k);
            ri->waiting_ticks += p->trace.tick - ticks0;
            CHECK_EQ((uint32_t)p->passes, passes0); /* held: no pass at all */
            CHECK(engine_paused(p));
            shift += wait;
            engine_test_goto(p, t + wait + 1);
            shift += 1;
            if (mode == 2 && ri->dialogs == 1) engine_dialog_done(p, 1, "ABCDEFGHIJKLM");
            else if (g_last.kind == SHELL_DLG_MESSAGEBOX) engine_dialog_done(p, 1, NULL);
            else engine_dialog_done(p, 1, "TEST");
            engine_test_finish_step(p);
            ri->delay += wait + 1;
            ri->paused_after = engine_paused(p);
        }
    }
    engine_test_goto(p, ms_end + shift);
    engine_test_finish_step(p);
    CHECK_STR(engine_fault_text(p), "");
    engine_applet_stop(p);
    free(p);
}

/* New Game (Z:0x41c910): Stop, FreeLibrary, Start, LoadLibraryA: a fresh image of the game, so DLL
 * statics (INVINCIBLE flag G:0x1000f604) and the game's own CRT rand state (G:0x1000ea40, file value 1)
 * start again (README.md: DLL reload). */
static void test_new_game(const uint8_t *pack, uint32_t pack_len, const uint8_t *gam, uint32_t gam_len) {
    g_nrows = 0;
    rt_set_sinks(NULL, on_trace);
    Port *p = (Port *)calloc(1, sizeof(Port));
    core_init(p, 0, 0xffffffffu, 7);
    trace_set_mode(&p->trace, TRACE_HASH);
    CHECK_EQ(core_start(p, pack, pack_len, gam, gam_len), 0);
    core_advance(p, 0);
    engine_test_goto(p, 500);
    for (const char *s = "INVINCIBLE"; *s; s++) {
        engine_test_input(p, PORT_IN_KEYDOWN, *s, 0);
        engine_test_input(p, PORT_IN_KEYUP, *s, 0);
    }
    engine_test_finish_step(p);
    struct Cpu *c = engine_cpu(p);
    CHECK_EQ(cpu_rd32(c, 0x1000f604u) & 0xffu, 1);
    CHECK_EQ(cpu_rd32(c, 0x1000ea40u), 1);
    cpu_wr32(c, 0x1000ea40u, 0x12345u); /* as if the game had called its rand */
    int rows0 = g_nrows;
    engine_test_goto(p, 600);
    CHECK_EQ(engine_new_game(p), 0);
    engine_test_finish_step(p);
    c = engine_cpu(p);
    CHECK(c != NULL);
    CHECK(engine_applet_running(p));
    CHECK_EQ(cpu_rd32(c, 0x1000f604u) & 0xffu, 0);
    CHECK_EQ(cpu_rd32(c, 0x1000ea40u), 1);
    uint32_t game = cpu_rd32(c, 0x1000f5d8u), st = game ? cpu_rd32(c, game) : 0;
    CHECK_EQ(st ? cpu_rd32(c, st) : 0, 0x1000d15cu); /* title screen */
    CHECK_EQ(g_nrows - rows0, 3); /* Shell_StopApplet, DllMain, Shell_StartApplet */
    engine_test_goto(p, 2000);
    engine_test_finish_step(p);
    CHECK_STR(engine_fault_text(p), "");
    /* objects that the stopped game leaked are freed at New Game (port sweep): the count stays */
    uint32_t live0 = engine_test_live_objects(p);
    for (uint32_t k = 0; k < 3; k++) {
        engine_test_goto(p, 3000 + 1000 * k);
        CHECK_EQ(engine_new_game(p), 0);
        engine_test_finish_step(p);
        CHECK_EQ(engine_test_live_objects(p), live0);
    }
    engine_applet_stop(p);
    free(p);
}

int main(void) {
    uint32_t pack_len = 0, gam_len = 0;
    uint8_t *pack = read_file("port/build/web/pack.bin", &pack_len);
    uint8_t *gam = read_file("extracted/Moeboid.gam", &gam_len);
    static Ev ev[4096];
    int nev = load_rec("analysis/verification/logs/run_autopilot.input.tsv", ev, 4096);
    if (!pack || !gam || nev <= 0) {
        fprintf(stderr, "test_engine_modal: pack.bin, Moeboid.gam or the recording missing\n");
        return 1;
    }
    const uint32_t ms_end = 45000;
    RunInfo ra, rb, rc;
    run(pack, pack_len, gam, gam_len, ev, nev, ms_end, 0, &ra);
    int na = g_nrows;
    Row *a = malloc((size_t)na * sizeof *a);
    memcpy(a, g_rows, (size_t)na * sizeof *a);
    CHECK(na > 2000);
    CHECK_EQ(ra.dialogs, 0);

    for (int mode = 1; mode <= 2; mode++) {
        RunInfo *ri = mode == 1 ? &rb : &rc;
        run(pack, pack_len, gam, gam_len, ev, nev, ms_end, mode, ri);
        CHECK_EQ(ri->dialogs, mode == 1 ? 1 : 3);
        CHECK_STR(ri->first_title, "Congratulations");
        CHECK_EQ(ri->waiting_ticks, 0);
        CHECK(!ri->paused_after);
        if (mode == 2) {
            CHECK_STR(ri->second_text, "We're sorry, but names must be 12 letters or smaller.");
            CHECK_EQ(ri->second_flags, 0x101);
        }
        CHECK_EQ(g_nrows, na);
        int bad = 0;
        uint32_t bad_ms = 0;
        for (int i = 0; i < g_nrows && i < na; i++) {
            const Row *x = &a[i], *y = &g_rows[i];
            uint32_t want_ms = x->ms <= ri->dialog_open_ms ? x->ms : x->ms + ri->delay;
            bool same = x->tick == y->tick && x->calls == y->calls && !strcmp(x->hash, y->hash) && !strcmp(x->state, y->state);
            if (!same || y->ms != want_ms) {
                bad_ms = x->ms;
                if (bad++ < 3 && !(mode == 2 && x->ms == ri->dialog_open_ms))
                    fprintf(stderr, "mode %d row %d: auto %u %u %u %s %s, modal %u %u %u %s %s\n", mode, i, x->tick, x->ms,
                            x->calls, x->hash, x->state, y->tick, y->ms, y->calls, y->hash, y->state);
            }
        }
        /* mode 2: the dialog tick has 2 more calls (MessageBox "Name too long", the second InputBox);
         * every other tick is equal */
        CHECK_EQ(bad, mode == 2 ? 1 : 0);
        if (mode == 2) CHECK_EQ(bad_ms, ri->dialog_open_ms);
        printf("mode %d: dialogs %d, open at %u ms, %u ms, rows %d\n", mode, ri->dialogs, ri->dialog_open_ms, ri->delay, g_nrows);
    }
    test_new_game(pack, pack_len, gam, gam_len);
    return test_report("test_engine_modal");
}
