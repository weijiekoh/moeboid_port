/* Font smoothing setting (M7; decision 4b, host settings of the click-to-start page).
 * Port.smoothing (core_init: 1 = Standard; port_init copies port_set_smoothing) reaches the three text
 * paths: engine text (game, IImage DrawText/DrawZML), shell frame text (rail, menu, ZML pages) and the
 * dialogs (Luna caption). The test runs the full port twice (smoothing 1 and 0) to the title frame and
 * once more with the Terms of Service dialog, and compares:
 *   - default after core_init is 1 (Standard);
 *   - "Start" label (Arial 24 bold, gasp allows grey at 24 px): more than 4 colours with Standard,
 *     at most 3 without (text, background);
 *   - shell area outside the game surface and the dialog: pixels differ between the two runs, and
 *     every differing pixel of the "off" run is a pure text colour (no blend level).
 * Data: port/build/web/pack.bin, extracted/Moeboid.gam (skipped when missing). */
#include "engine/engine.h"
#include "shell/shell_frame.h"
#include "shell/shell_modal.h"
#include "test.h"

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

static uint8_t *pack, *gam;
static uint32_t pack_len, gam_len;

static void adv(Port *p, uint32_t *t, uint32_t ms) {
    uint32_t end = *t + ms;
    while (*t < end) {
        *t += (end - *t) < 16u ? (end - *t) : 16u;
        core_advance(p, *t);
        core_sound_drain(p, NULL);
    }
}

/* Title frame (and optionally the ToS dialog) with the given smoothing; returns a copy of the frame. */
static uint8_t *run(int smoothing, int tos) {
    Port *p = calloc(1, sizeof(Port));
    core_init(p, 0, 0xffffffffu, 1);
    CHECK_EQ(p->smoothing, 1); /* decision 4b default */
    p->smoothing = (uint8_t)smoothing;
    CHECK_EQ(core_start(p, pack, pack_len, gam, gam_len), 0);
    uint32_t t = 0;
    core_input(p, PORT_IN_START, 0, 0, 0);
    adv(p, &t, 4000);
    CHECK_EQ(shell_test_phase(p), SH_RUNNING);
    if (tos) {
        CHECK_EQ(shell_modal_open_tos(p), 0);
        adv(p, &t, 500);
        CHECK(shell_modal_active(p));
    }
    uint8_t *f = malloc(PORT_W * PORT_H * 4u);
    memcpy(f, p->frame, PORT_W * PORT_H * 4u);
    /* the port state is not freed: the test process ends soon */
    return f;
}

static uint32_t px(const uint8_t *f, int x, int y) {
    const uint8_t *q = f + ((size_t)y * PORT_W + (size_t)x) * 4u;
    return (uint32_t)q[0] << 16 | (uint32_t)q[1] << 8 | q[2];
}

static int colours(const uint8_t *f, int x0, int y0, int w, int h) {
    uint32_t seen[64];
    int n = 0;
    for (int y = y0; y < y0 + h; y++)
        for (int x = x0; x < x0 + w; x++) {
            uint32_t c = px(f, x, y);
            int k = 0;
            while (k < n && seen[k] != c) k++;
            if (k == n && n < 64) seen[n++] = c;
        }
    return n;
}

static bool in_game(int x, int y) {
    return x >= ENG_GAME_X && x < ENG_GAME_X + ENG_GAME_W && y >= ENG_GAME_Y && y < ENG_GAME_Y + ENG_GAME_H;
}

/* Pixels outside the game surface that differ; `blends` counts differing pixels of `off` whose colour
 * also differs from every colour in `on` at the same place's 3x3 neighbourhood in `off` (a new colour
 * that only a blend can make). */
static int shell_diff(const uint8_t *on, const uint8_t *off, int *blends) {
    int n = 0;
    *blends = 0;
    for (int y = 0; y < (int)PORT_H; y++)
        for (int x = 0; x < (int)PORT_W; x++) {
            if (in_game(x, y) || px(on, x, y) == px(off, x, y)) continue;
            n++;
            uint32_t c = px(off, x, y);
            bool found = false;
            for (int dy = -2; dy <= 2 && !found; dy++)
                for (int dx = -2; dx <= 2 && !found; dx++) {
                    int xx = x + dx, yy = y + dy;
                    if (xx < 0 || yy < 0 || xx >= (int)PORT_W || yy >= (int)PORT_H) continue;
                    if (px(on, xx, yy) == c) found = true;
                }
            if (!found) (*blends)++;
        }
    return n;
}

int main(void) {
    pack = read_file("port/build/web/pack.bin", &pack_len);
    gam = read_file("extracted/Moeboid.gam", &gam_len);
    if (!pack || !gam) {
        printf("test_settings: skipped (pack.bin or Moeboid.gam missing)\n");
        return 0;
    }
    uint8_t *on = run(1, 0), *off = run(0, 0);
    int c_on = colours(on, 535, 240, 58, 31), c_off = colours(off, 535, 240, 58, 31);
    printf("Start label colours: Standard %d, off %d\n", c_on, c_off);
    CHECK(c_on > 4);
    CHECK(c_off <= 3);
    int blends = 0, d = shell_diff(on, off, &blends);
    printf("shell area: %d pixels differ, %d of them with a colour absent near the Standard pixel\n", d, blends);
    CHECK(d > 0);
    CHECK_EQ(blends, 0); /* the "off" run has text colour or background only */
    uint8_t *ton = run(1, 1), *toff = run(0, 1);
    int dd = 0;
    for (int y = 0; y < (int)PORT_H; y++)
        for (int x = 0; x < (int)PORT_W; x++)
            if (px(ton, x, y) != px(toff, x, y) && px(on, x, y) == px(off, x, y)) dd++;
    printf("Terms of Service dialog: %d pixels differ outside the frame differences\n", dd);
    CHECK(dd > 0);
    return test_report("test_settings");
}
