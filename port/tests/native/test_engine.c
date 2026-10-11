/* Native tests of the engine services (M4): draw rules, dirty rectangles and the render skip rule,
 * hit test, animation timing and pause, sound voices, settings store, key state, buttons.
 * Engine without a game image (core_start with no .gam): only the shell root and the two game
 * surfaces exist. Data: port/build/web/pack.bin (fonts, GIFs, WAVs). */
#include "engine/eng_int.h"
#include "gfx/cursor.h"
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

static uint32_t px_rgb(const Image *im, int x, int y) { return im->px[y * im->stride + x] & 0xffffffu; }
static uint32_t frame_rgb(Port *p, int x, int y) {
    const uint8_t *f = p->frame + ((size_t)y * PORT_W + (size_t)x) * 4u;
    return (uint32_t)f[0] | (uint32_t)f[1] << 8 | (uint32_t)f[2] << 16;
}
#define RGB(r, g, b) ((uint32_t)(r) | (uint32_t)(g) << 8 | (uint32_t)(b) << 16)

static void test_draw(void) {
    uint32_t buf[16 * 16], src_px[4 * 4];
    Image im = {16, 16, 16, buf, 0};
    uint32_t white = IMG_RGB(255, 255, 255), red = IMG_RGB(255, 0, 0);
    draw_clear(&im, IMG_BLACK);
    /* FillRect: right and bottom exclusive (Z:0x40bc60) */
    draw_fill_rect(&im, 2, 3, 5, 6, white);
    CHECK_EQ(px_rgb(&im, 2, 3), 0xffffff);
    CHECK_EQ(px_rgb(&im, 4, 5), 0xffffff);
    CHECK_EQ(px_rgb(&im, 5, 5), 0);
    CHECK_EQ(px_rgb(&im, 4, 6), 0);
    draw_clear(&im, IMG_BLACK);
    draw_fill_rect(&im, 5, 3, 2, 6, white); /* left > right: nothing */
    draw_fill_rect(&im, -5, -5, 2, 1, white); /* clipped */
    int n = 0;
    for (int i = 0; i < 256; i++) n += (buf[i] & 0xffffff) != 0;
    CHECK_EQ(n, 2);
    /* lines: end point not drawn (GDI LineTo) */
    draw_clear(&im, IMG_BLACK);
    draw_line(&im, 1, 1, 5, 1, white);
    CHECK_EQ(px_rgb(&im, 1, 1), 0xffffff);
    CHECK_EQ(px_rgb(&im, 4, 1), 0xffffff);
    CHECK_EQ(px_rgb(&im, 5, 1), 0);
    draw_line(&im, 5, 2, 1, 2, white);
    CHECK_EQ(px_rgb(&im, 5, 2), 0xffffff);
    CHECK_EQ(px_rgb(&im, 2, 2), 0xffffff);
    CHECK_EQ(px_rgb(&im, 1, 2), 0);
    draw_line(&im, 3, 5, 3, 9, white);
    CHECK_EQ(px_rgb(&im, 3, 8), 0xffffff);
    CHECK_EQ(px_rgb(&im, 3, 9), 0);
    draw_line(&im, 0, -1, 4, -1, white); /* y < 0: Z:0x40baf0 returns */
    /* frame rectangle: 4 lines give a closed outline with all corners */
    draw_clear(&im, IMG_BLACK);
    draw_frame_rect(&im, 1, 1, 4, 3, red);
    n = 0;
    for (int i = 0; i < 256; i++) n += (buf[i] & 0xffffff) != 0;
    CHECK_EQ(n, 10);
    CHECK_EQ(px_rgb(&im, 4, 3), 0x0000ff);
    CHECK_EQ(px_rgb(&im, 2, 2), 0);
    /* keyed blit: magenta RGB is transparent */
    Image src = {4, 4, 4, src_px, 1};
    for (int i = 0; i < 16; i++) src_px[i] = (i % 4 == 1) ? IMG_KEY : IMG_RGB(0, 255, 0);
    src_px[2] = IMG_RGB(255, 0, 255); /* magenta drawn by FillRect is the key too */
    draw_clear(&im, IMG_BLACK);
    CHECK_EQ(draw_at(&im, &src, 0, 0), DRAW_OK);
    CHECK_EQ(px_rgb(&im, 0, 0), 0x00ff00);
    CHECK_EQ(px_rgb(&im, 1, 0), 0);
    CHECK_EQ(px_rgb(&im, 2, 0), 0);
    CHECK_EQ(px_rgb(&im, 1, 1), 0);
    /* negative position: Z:0x40bf70 moves the source rectangle */
    draw_clear(&im, IMG_BLACK);
    src.keyed = 0;
    for (int i = 0; i < 16; i++) src_px[i] = IMG_RGB(i, 0, 0);
    CHECK_EQ(draw_at(&im, &src, -2, -1), DRAW_OK);
    CHECK_EQ(px_rgb(&im, 0, 0), RGB(1 * 4 + 2, 0, 0));
    CHECK_EQ(px_rgb(&im, 1, 2), RGB(3 * 4 + 3, 0, 0));
    CHECK_EQ(px_rgb(&im, 2, 0), 0);
    /* fully outside to the right: no Blt (result 0); fully outside to the left: invalid rectangle */
    CHECK_EQ(draw_at(&im, &src, 20, 0), DRAW_OK);
    CHECK_EQ(draw_at(&im, &src, -10, 0), DRAW_E_BLT);
    /* clipped at the right and bottom edge */
    draw_clear(&im, IMG_BLACK);
    CHECK_EQ(draw_at(&im, &src, 14, 14), DRAW_OK);
    CHECK_EQ(px_rgb(&im, 15, 15), RGB(5, 0, 0));
}

static void test_dirty(void) {
    static DirtyList d;
    dirty_clear(&d);
    CHECK(!dirty_flag(&d));
    dirty_add(&d, 0, 0, 5, 5);
    dirty_add(&d, 0, 0, 5, 5); /* equal to the last: skipped */
    dirty_add(&d, 1, 0, 5, 5);
    dirty_add(&d, 0, 0, 5, 5); /* equal to an older one only: added */
    CHECK_EQ(d.count, 3);
    CHECK(dirty_flag(&d));
    DrawRect touch = {5, 5, 6, 6}, apart = {7, 6, 8, 8};
    CHECK(dirty_intersects(&d, &touch)); /* inclusive edges (Z:0x413810) */
    CHECK(!dirty_intersects(&d, &apart));
    for (int i = 0; i < DIRTY_MAX + 5; i++) dirty_add(&d, i, 0, 1, 1);
    CHECK_EQ(d.count, DIRTY_MAX);
    dirty_clear(&d);
    CHECK_EQ(d.count, 0);
    CHECK(!dirty_flag(&d));
}

static Port *new_engine(const uint8_t *pack, uint32_t pack_len, uint32_t quirks) {
    Port *p = (Port *)calloc(1, sizeof(Port));
    core_init(p, 0, quirks, 1);
    CHECK_EQ(core_start(p, pack, pack_len, NULL, 0), 0);
    core_advance(p, 0);
    return p;
}

/* advance in steps below PORT_MAX_LATE_MS (a longer jump is a stall: one late pass) */
static void run_to(Port *p, uint32_t ms) {
    uint32_t now = core_ticks(p);
    while (now + 100 < ms) {
        now += 100;
        core_advance(p, now);
    }
    core_advance(p, ms);
}

static uint32_t solid_child(Engine *e, uint32_t parent, int w, int h, int x, int y, uint32_t rgb) {
    uint32_t s = eng_surface_new_blank(e, w, h, 0);
    eng_image_clear(e, eng_surface_image(e, s), rgb);
    eng_surface_attach(e, parent, s);
    eng_surface_set_loc(e, s, x, y, 0);
    return s;
}

static void test_scene(const uint8_t *pack, uint32_t pack_len) {
    /* quirk on (original): DetachSurface invalidates the child without the parent offset */
    Port *p = new_engine(pack, pack_len, ENG_QUIRK_DETACH_DIRTY);
    Engine *e = engine_of(p);
    CHECK(e != NULL);
    eng_render(e);
    CHECK_EQ(frame_rgb(p, 10, 10), 0x3333cc / 0x10000 | (0x33 << 8) | (0xcc << 16)); /* #3333cc */
    CHECK_EQ(frame_rgb(p, 300, 60), 0);   /* ctx[2]: opaque 500x420, black */
    CHECK(dirty_flag(e->dirty) == false);
    uint32_t red = solid_child(e, e->game, 20, 20, 10, 10, 0xff0000);
    eng_render(e);
    CHECK_EQ(frame_rgb(p, ENG_GAME_X + 15, ENG_GAME_Y + 15), RGB(255, 0, 0));
    /* detach: dirty rectangle at (10, 10) in frame coordinates, far from the game surface: stale */
    eng_surface_detach(e, e->game, red);
    eng_render(e);
    CHECK_EQ(frame_rgb(p, ENG_GAME_X + 15, ENG_GAME_Y + 15), RGB(255, 0, 0));
    /* a change of the game image invalidates the whole game surface: the child disappears */
    eng_image_changed(e, eng_surface_image(e, e->game));
    eng_render(e);
    CHECK_EQ(frame_rgb(p, ENG_GAME_X + 15, ENG_GAME_Y + 15), 0);
    /* skip rule: a dirty rectangle that touches only a child: its parent is skipped, so the child is
     * not drawn either (Z:0x414cd0 returns with its children). */
    uint32_t box = solid_child(e, e->root, 40, 40, 20, 300, 0x00ff00);
    uint32_t inner = solid_child(e, box, 10, 10, 50, 50, 0x0000ff); /* outside the parent: clipped away */
    eng_render(e);
    CHECK_EQ(frame_rgb(p, 25, 305), RGB(0, 255, 0));
    CImage *bi = eng_image(e, eng_surface_image(e, box));
    draw_clear(&bi->img, IMG_RGB(255, 255, 0)); /* pixels change without Z:0x414120 */
    dirty_add(e->dirty, 100, 100, 1, 1);         /* somewhere else */
    eng_render(e);
    CHECK_EQ(frame_rgb(p, 25, 305), RGB(0, 255, 0)); /* not redrawn */
    eng_surface_invalidate(e, box);
    eng_render(e);
    CHECK_EQ(frame_rgb(p, 25, 305), RGB(255, 255, 0));
    /* drawing a surface adds its rectangle during the pass (Z:0x413f30 -> Z:0x414120 on the source):
     * a later sibling over it is drawn too, although only the first was dirty */
    uint32_t over = solid_child(e, e->root, 10, 10, 30, 310, 0xff00ff); /* keyed? no: opaque magenta */
    eng_render(e);
    CImage *oi = eng_image(e, eng_surface_image(e, over));
    draw_clear(&oi->img, IMG_RGB(1, 2, 3));
    eng_surface_invalidate(e, box);
    eng_render(e);
    CHECK_EQ(frame_rgb(p, 32, 312), RGB(1, 2, 3));
    (void)inner;
    /* hit test: strict inside test, child rectangle (x, y, x + w + 1, y + h + 1) */
    uint32_t hit = 0;
    eng_surface_hit(e, e->root, 20, 305, &hit);
    CHECK_EQ(hit, e->root); /* x = 20 is the left edge: not inside (strict) */
    hit = 0;
    eng_surface_hit(e, e->root, 21, 305, &hit);
    CHECK_EQ(hit, box);
    hit = 0;
    eng_surface_hit(e, e->root, 60, 305, &hit); /* x = 20 + 40: inside because of the +1 */
    CHECK_EQ(hit, box);
    hit = 0;
    eng_surface_hit(e, e->root, 61, 305, &hit);
    CHECK_EQ(hit, e->root);
    /* protect key of ctx[2] (Z:0x414ca0, Z:0x4146a0) */
    CHECK_EQ(eng_surface_set_loc(e, e->game, 0, 0, 0), 0xb);
    CHECK_EQ(eng_surface_set_visible(e, e->game, false, 0), 0xb);
    CHECK_EQ(eng_surface_set_loc(e, e->game, ENG_GAME_X, ENG_GAME_Y, e->shell_key), 0);
    /* DetachSurface of a surface that is no child: 4 */
    CHECK_EQ(eng_surface_detach(e, e->game, box), 4);
    free(p);

    /* quirk off: the detached child is invalidated at its real position */
    p = new_engine(pack, pack_len, 0);
    e = engine_of(p);
    eng_render(e);
    red = solid_child(e, e->game, 20, 20, 10, 10, 0xff0000);
    eng_render(e);
    eng_surface_detach(e, e->game, red);
    eng_render(e);
    CHECK_EQ(frame_rgb(p, ENG_GAME_X + 15, ENG_GAME_Y + 15), 0);
    free(p);
}

static void test_anim(const uint8_t *pack, uint32_t pack_len) {
    /* 50 ms slots of the GIF delays (Z:0x4171b0), frame timer on the game clock (Z:0x4176f0,
     * Z:0x417750), pause (Z:0x427490): the frame timer stops, the render timer runs. */
    Port *p = new_engine(pack, pack_len, 0xffffffffu);
    Engine *e = engine_of(p);
    uint32_t s = eng_surface_new_gif(e, "img-backgroundscreen-500x420.gif", 0); /* 1000, 1000, 6000 ms, no loop */
    eng_surface_attach(e, e->game, s);
    CSurface *sf = eng_surface(e, s);
    CAnim *a = ENG_GET(e, sf->anim, CAnim, OT_ANIM);
    CSeq *q = ENG_GET(e, a->seq, CSeq, OT_SEQ);
    CHECK_EQ(q->images.n, 3);
    CHECK_EQ(q->nslots, 160);
    CHECK_EQ(q->loop, 0);
    uint32_t img0 = q->images.v[0], img1 = q->images.v[1], img2 = q->images.v[2];
    CHECK_EQ(a->img, img0);
    run_to(p, 100);
    eng_anim_start(e, sf->anim);
    uint32_t r0 = e->renders;
    run_to(p, 1099);
    CHECK_EQ(a->img, img0); /* 999 ms after start (frame timer fires at 1050 first) */
    run_to(p, 1150);
    CHECK_EQ(a->img, img1);
    CHECK(e->renders > r0);
    engine_set_paused(p, true);
    uint32_t r1 = e->renders;
    eng_image_changed(e, img1);
    run_to(p, 4000);
    CHECK_EQ(a->img, img1); /* game clock stopped */
    CHECK(e->renders > r1); /* render timer runs while paused */
    engine_set_paused(p, false);
    run_to(p, 4100); /* game time 1150 + 100 - start 100: 1150 ms since start */
    CHECK_EQ(a->img, img1);
    run_to(p, 5000); /* about 2050 ms since start */
    CHECK_EQ(a->img, img2);
    run_to(p, 20000); /* past the end of a non-looping sequence: image 0 */
    CHECK_EQ(a->img, img0);
    eng_anim_stop(e, sf->anim);
    CHECK(!a->timer.started);
    free(p);
}

static void test_voices(void) {
    /* Z:0x409280: first free of 16 slots, drop when full; Z:0x409340: freed by the first 10 ms pass
     * after the end. */
    static SndVoices v;
    memset(&v, 0, sizeof v);
    v.ready = v.enabled = true;
    v.info[1] = (SndInfo){11025, 1, 11025, true}; /* exactly 1000 ms */
    int32_t rv;
    for (int i = 0; i < 16; i++) CHECK_EQ(snd_alloc(&v, 7, 1, 0, 3), i);
    CHECK_EQ(snd_alloc(&v, 7, 1, 0, 3), -1);
    CHECK_EQ(v.drops, 1);
    CHECK_EQ(v.v[0].release_ms, 1010);
    CHECK(!snd_poll(&v, 1009, &rv));
    CHECK(v.v[0].busy);
    CHECK(!snd_poll(&v, 1010, &rv));
    CHECK(!v.v[0].busy);
    CHECK_EQ(snd_alloc(&v, 7, 1, 0, 1010), 0);
    CHECK_EQ(v.v[0].release_ms, 2010);
    /* repeat count 3: two restarts */
    memset(&v, 0, sizeof v);
    v.info[1] = (SndInfo){11025, 1, 11025, true};
    CHECK_EQ(snd_alloc(&v, 7, 1, 3, 0), 0);
    CHECK(snd_poll(&v, 1000, &rv));
    CHECK_EQ(rv, 0);
    CHECK_EQ(v.v[0].release_ms, 2000);
    CHECK(snd_poll(&v, 2000, &rv));
    CHECK(!snd_poll(&v, 3000, &rv));
    CHECK(!v.v[0].busy);
    /* WAV parser (Z:0x40c540) on a pack file */
}

static void test_wav_and_sound(const uint8_t *pack, uint32_t pack_len) {
    Port *p = new_engine(pack, pack_len, 0xffffffffu);
    Engine *e = engine_of(p);
    CHECK(e->voices.info[PORT_SND_GAMEOPEN].ok);
    CHECK(e->voices.info[PORT_SND_BTNCLICK].ok);
    CHECK(engine_sound_enabled(p));
    uint32_t snd = eng_sound_load(e, "snd-gameopen.wav", 0);
    CHECK(snd != 0);
    uint32_t n0 = core_sound_drain(p, NULL);
    for (int i = 0; i < 17; i++) CHECK_EQ(eng_sound_play(e, snd, 0), 0);
    CHECK_EQ(core_sound_drain(p, NULL) - n0, 16);
    CHECK_EQ(p->sound[n0].op, PORT_SND_OP_PLAY);
    CHECK_EQ(p->sound[n0].sound_id, PORT_SND_GAMEOPEN);
    CHECK_EQ(p->sound[n0 + 15].voice, 15);
    engine_sound_set_enabled(p, false);
    CHECK_STR(storage_get(&p->storage, "core/Sound"), "false");
    run_to(p, 60000);
    uint32_t n1 = core_sound_drain(p, NULL);
    eng_sound_play(e, snd, 0);
    CHECK_EQ(core_sound_drain(p, NULL), n1); /* off: no command */
    engine_sound_set_enabled(p, true);
    eng_sound_play(e, snd, 0);
    CHECK_EQ(core_sound_drain(p, NULL), n1 + 1);
    CHECK_EQ(p->sound[n1].voice, 0); /* every voice ended long ago */
    CHECK_EQ(engine_play_sound(p, "BtnClick.wav"), 0);
    CHECK_EQ(engine_play_sound(p, "nothing.wav"), 8);
    free(p);
}

static void test_settings(const uint8_t *pack, uint32_t pack_len) {
    Port *p = new_engine(pack, pack_len, 0xffffffffu);
    Engine *e = engine_of(p);
    rt_snprintf(e->owner_id, sizeof e->owner_id, "%s", "{GUID}");
    char out[64] = "junk";
    CHECK_EQ(eng_prop_get_game(e, "Score1Name", out, sizeof out), 0x19); /* Z:0x4294f0 */
    CHECK_STR(out, "");
    p->storage.changed = false;
    eng_prop_set_game(e, "Score1Name", "ZapSpot");
    CHECK(p->storage.changed); /* write-through */
    CHECK_STR(storage_get(&p->storage, "game/{GUID}/Score1Name"), "ZapSpot");
    CHECK_EQ(eng_prop_get_game(e, "score1name", out, sizeof out), 0); /* lstrcmpiA */
    CHECK_STR(out, "ZapSpot");
    eng_prop_set_game(e, "SCORE1NAME", "x");
    CHECK_STR(storage_get(&p->storage, "game/{GUID}/Score1Name"), "x");
    CHECK(storage_get(&p->storage, "game/{GUID}/SCORE1NAME") == NULL);
    engine_prop_set(p, "Sound", "true");
    CHECK_STR(engine_prop_get(p, "Sound"), "true");
    free(p);
}

static void test_keys_and_buttons(const uint8_t *pack, uint32_t pack_len) {
    Port *p = new_engine(pack, pack_len, 0xffffffffu);
    Engine *e = engine_of(p);
    /* key state: GetKeyState SHORT, toggle at each press */
    PortInput ev = {PORT_IN_KEYDOWN, 0x25, 0, 0, 0, 0};
    keys_apply(&p->keys, &ev);
    CHECK_EQ((int32_t)core_key_state(p, 0x25), -127);
    ev.kind = PORT_IN_KEYUP;
    keys_apply(&p->keys, &ev);
    CHECK_EQ((int32_t)core_key_state(p, 0x25), 1);
    /* a button with a C callback (Z:0x419730): hover face, hand cursor, click on button up */
    uint32_t faces = eng_image_new(e, 40, 10, true);
    CImage *fi = eng_image(e, faces);
    draw_fill_rect(&fi->img, 0, 0, 20, 10, IMG_RGB(10, 20, 30));
    draw_fill_rect(&fi->img, 20, 0, 40, 10, IMG_RGB(40, 50, 60));
    static int clicks, last_id;
    struct Ctx { int dummy; } ctx;
    (void)ctx;
    clicks = 0;
    uint32_t b = engine_button(p, e->game, 100, 100, 20, 10, faces, 0, 42, NULL, NULL);
    CHECK(b != 0);
    CSurface *bs = eng_surface(e, b);
    CAnim *ba = ENG_GET(e, bs->anim, CAnim, OT_ANIM);
    CSeq *bq = ENG_GET(e, ba->seq, CSeq, OT_SEQ);
    CHECK_EQ(bq->images.n, 2);
    CHECK_EQ(ba->img, bq->images.v[0]);
    CHECK_EQ(px_rgb(&eng_image(e, ba->img)->img, 1, 1), RGB(10, 20, 30));
    int32_t bx = ENG_GAME_X + 100 + 10, by = ENG_GAME_Y + 100 + 5;
    eng_mouse_event(e, 7, bx, by);
    CHECK_EQ(e->hover, b);
    CHECK_EQ(ba->img, bq->images.v[1]); /* hover face */
    CHECK_EQ(px_rgb(&eng_image(e, ba->img)->img, 1, 1), RGB(40, 50, 60));
    CHECK_EQ(p->cursor, CURSOR_HAND);
    eng_mouse_event(e, 1, bx, by);
    CHECK_EQ(e->pressed, b);
    eng_mouse_event(e, 2, bx, by);
    CHECK_EQ(e->pressed, 0);
    eng_mouse_event(e, 7, 5, 5);
    CHECK_EQ(e->hover, 0);
    CHECK_EQ(ba->img, bq->images.v[0]);
    CHECK_EQ(p->cursor, CURSOR_POINTER);
    (void)clicks;
    (void)last_id;
    free(p);
}

static void test_modal_hold(const uint8_t *pack, uint32_t pack_len) {
    /* engine_modal_hold: shell-opened dialog = original modal loop: no timer pass, no input */
    Port *p = new_engine(pack, pack_len, 0xffffffffu);
    Engine *e = engine_of(p);
    run_to(p, 1000);
    uint64_t passes = p->passes;
    uint32_t renders = e->renders;
    engine_modal_hold(p, true);
    eng_image_changed(e, eng_surface_image(e, e->game));
    run_to(p, 3000);
    CHECK_EQ(p->passes, passes);
    CHECK_EQ(e->renders, renders);
    uint32_t hover0 = e->hover;
    core_input(p, PORT_IN_MOUSEMOVE, 400, 300, 3001);
    run_to(p, 3010);
    CHECK_EQ(e->mouse_x, 0); /* no mouse routing while held */
    CHECK_EQ(e->hover, hover0);
    engine_modal_hold(p, false);
    run_to(p, 3200);
    CHECK(p->passes > passes);
    CHECK(e->renders > renders);
    free(p);
}

int main(void) {
    uint32_t pack_len = 0;
    uint8_t *pack = read_file("port/build/web/pack.bin", &pack_len);
    if (!pack) {
        fprintf(stderr, "test_engine: port/build/web/pack.bin missing (port/build.sh pack)\n");
        return 1;
    }
    test_draw();
    test_dirty();
    test_scene(pack, pack_len);
    test_anim(pack, pack_len);
    test_voices();
    test_wav_and_sound(pack, pack_len);
    test_settings(pack, pack_len);
    test_keys_and_buttons(pack, pack_len);
    test_modal_hold(pack, pack_len);
    return test_report("test_engine");
}
