/* Shell buttons and the game rail (M5b). See shell_frame.h.
 *
 * The original has two button classes: Z:0x419730 (two faces, hover = face + 1; engine_button) and the
 * image button Z:0x42b990 (four faces: normal, toggled, hover, disabled; enter shows face 2 and sets the
 * hand cursor, leave shows face 1 when toggled else face 0 and sets the pointer, Z:0x42c230,
 * Z:0x42c280). The shell never disables a button, so face 3 never shows. The port builds the face images
 * of Z:0x42b990 exactly and gives engine_button a strip of two of them: [normal or toggled, hover]. The
 * visible result is the same (verified for the rail against screens_monofonts/frame_title_installed.png,
 * port/tests/py/test_shell_compare.py). */
#include "shell_frame.h"

static void cb_new_game(Port *p, void *ctx, int32_t id) {
    (void)p;
    sh_new_game((ShellFrame *)ctx, id); /* Z:0x41c3a0 -> Z:0x41c910 */
}

static void cb_pause(Port *p, void *ctx, int32_t id) {
    (void)p;
    (void)id;
    sh_pause_toggle((ShellFrame *)ctx); /* Z:0x41c3c0 -> Z:0x41cb30 */
}

static void cb_how_to_play(Port *p, void *ctx, int32_t id) {
    (void)p;
    (void)id;
    sh_how_to_play((ShellFrame *)ctx); /* Z:0x41c3d0 -> Z:0x41c3f0 */
}

/* Cell of a GIF strip: Z:0x413a00(src, index, w, h, cw, ch) = new image w x h keyed like src, with the
 * src rectangle (index * cw, 0, (index + 1) * cw, ch) drawn over the whole image (scaled when the sizes
 * differ, Z:0x413f30 with a NULL destination). */
static bool cell_image(Image *out, const Image *src, int32_t index, int32_t w, int32_t h, int32_t cw, int32_t ch) {
    if (!sh_image_new(out, w, h, src->keyed != 0)) return false;
    DrawRect sr = {index * cw, 0, (index + 1) * cw, ch};
    draw_blt(out, NULL, src, &sr);
    return true;
}

/* Z:0x413f30(target, dst, src, NULL): source rectangle (0, 0, src w, min(src h, target h)) (Z:0x40bf70). */
static void draw_src_null(Image *t, const DrawRect *dst, const Image *src) {
    DrawRect sr = {0, 0, src->w, RT_MIN(src->h, t->h)};
    draw_blt(t, dst, src, &sr);
}

void sh_imgbtn(ShellFrame *f, ShellBtn *b, uint32_t parent, int32_t x, int32_t y, int32_t w, int32_t h,
               const char *backs_name, const char *icons_name, int32_t icon, int32_t id, const char *label,
               uint32_t flags, bool toggled, EngineButtonFn cb) {
    /* Z:0x42b990(parent, user, x, y, w, h, backs, icons, icon, id, label, flags, colour, cb) */
    Port *p = f->p;
    b->s = 0;
    Image *backs = NULL, *icons = NULL;
    uint32_t sb = sh_gif(f, backs_name, 0, &backs), si = icons_name ? sh_gif(f, icons_name, 0, &icons) : 0;
    if (!backs || (icons_name && !icons)) {
        sh_release(f, &sb);
        sh_release(f, &si);
        return;
    }
    int32_t lw = 0, lh = 0, sw = w, sh = h, cell_h = h, lx = 10000, ly = 0;
    if (flags & 1u) {
        /* caption under the button: measured with CreateFont("Arial", 12, 0); the surface grows to the
         * caption width and h + caption height (Z:0x413ff0); the back cells are stretched to that height
         * and drawn back into w x h (Z:0x42bb75..0x42bbc5). */
        sh_measure_font(f, "Arial", 12, 0, label, &lw, &lh);
        lx = (w / 2 - lw / 2) + x;
        if (w <= lw) sw = lw;
        sh = h + lh;
        cell_h = h + lh;
        ly = h;
    } else if (flags & 4u) {
        sh_measure_font(f, "Arial", 12, 0, label, &lw, &lh);
        ly = (h - lh) / 2; /* local_14; then local_1c = local_18 = 0 */
    }
    DrawRect dst = {(sw - w) / 2, 0, (sw - w) / 2 + w, h};
    Image icon_cell = {0};
    bool have_icon = icons && cell_image(&icon_cell, icons, icon, w, h, w, h);
    Image frames[3] = {{0}};
    static const char *const k_fmt1[2] = {"<T><S4><FArial><sh><CFFFFFF><C><U>%s</U></c>",   /* Z:0x4360fc */
                                          "<T><S4><FArial><sh><CFFFF33><C><U>%s</U></c>"};  /* Z:0x43609c */
    static const char *const k_fmt4[2] = {"<T><S2><b><FArial><sh><CFFFFFF><c>%s</c></b>",  /* Z:0x4360cc */
                                          "<T><S2><b><FArial><sh><CFFFF33><c>%s</c></b>"};  /* Z:0x43606c */
    for (int32_t fr = 0; fr < 3; fr++) {
        int32_t back = fr == 0 ? ((flags & 2u) ? 3 : 0) : fr; /* normal: cell 3 with flag 2, else 0 */
        Image cell = {0};
        if (!sh_image_new(&frames[fr], sw, sh, true) || !cell_image(&cell, backs, back, w, cell_h, w, h)) {
            sh_image_free(&cell);
            continue;
        }
        draw_src_null(&frames[fr], &dst, &cell);
        sh_image_free(&cell);
        if (have_icon) draw_src_null(&frames[fr], &dst, &icon_cell);
        if (flags & 5u) {
            char buf[320];
            rt_snprintf(buf, sizeof buf, (flags & 1u) ? k_fmt1[fr == 2] : k_fmt4[fr == 2], label);
            ZmlContext rc;
            sh_rc_init(f, &rc);
            sh_zml_image(f, &rc, &frames[fr], buf, 0, ly, NULL);
        }
    }
    sh_image_free(&icon_cell);
    sh_release(f, &sb);
    sh_release(f, &si);
    /* faces strip for engine_button: [normal or toggled (Z:0x42c2d0), hover] */
    uint32_t fs = engine_surface_blank(p, 2 * sw, sh, ENG_SURF_KEYED);
    uint32_t fimg = fs ? engine_surface_image(p, fs) : 0;
    Image *faces = sh_img(f, fimg);
    if (faces && frames[0].px && frames[1].px && frames[2].px) {
        DrawRect l = {0, 0, sw, sh}, r = {sw, 0, 2 * sw, sh};
        Image *n = toggled ? &frames[1] : &frames[0];
        Image raw = *n, rawh = frames[2];
        raw.keyed = 0; /* copy key pixels too */
        rawh.keyed = 0;
        draw_blt(faces, &l, &raw, NULL);
        draw_blt(faces, &r, &rawh, NULL);
        int32_t px = ((flags & 1u) && lx < x) ? lx : x; /* Z:0x42be8c: min(x, centred caption x) */
        b->s = engine_button(p, parent, px, y, sw, sh, fimg, 0, id, cb, f);
        b->x = px;
        b->y = y;
        b->w = sw;
        b->h = sh;
    }
    for (int32_t fr = 0; fr < 3; fr++) sh_image_free(&frames[fr]);
    sh_release(f, &fs);
}

/* Z:0x41b9b0 removal of a rail button: FillRect of its rectangle in the shell image with #000099, then
 * DetachChild (Z:0x41bb3d..0x41bb74). */
static void rail_remove(ShellFrame *f, ShellBtn *b) {
    if (!b->s) return;
    uint32_t img = engine_surface_image(f->p, f->root);
    Image *im = sh_img(f, img);
    if (im) draw_fill_rect(im, b->x, b->y, b->x + b->w, b->y + b->h, IMG_RGB(0u, 0u, 0x99u));
    sh_changed(f, img);
    engine_surface_detach(f->p, f->root, b->s);
    sh_release(f, &b->s);
}

void sh_btn_remove(ShellFrame *f, ShellBtn *b, uint32_t parent) {
    if (!b->s) return;
    engine_surface_detach(f->p, parent, b->s);
    sh_release(f, &b->s);
}

static void rail_make(ShellFrame *f, int32_t slot, int32_t y, int32_t icon, int32_t id, uint32_t str, bool toggled,
                      EngineButtonFn cb) {
    char label[SH_STR_MAX];
    sh_string(f, str, label, sizeof label);
    if (f->rail[slot].s) return; /* an existing button keeps its place */
    sh_imgbtn(f, &f->rail[slot], f->root, 0xd2, y, 0x2e, 0x2e, "slb-bigbtnbacks-hc.gif", "slb-bigbtnicons.gif", icon, id,
              label, 1u, toggled, cb);
}

void sh_rail(ShellFrame *f) {
    /* Z:0x41b9b0: buttons at x 210, y 85 + 67 n (800-wide skin); a button shows when its bit in +0x378
     * is set; only shown buttons advance y (Z:0x41bb0d). */
    if (!f->built) return;
    int32_t y = 0x55;
    if (f->mask & 0x20u) {
        /* Mail This (str 10010, icon 0, Z:0x420150): removed (network); decision 7 keeps its slot empty. */
        y += 0x43;
    } else {
        rail_remove(f, &f->rail[SH_RAIL_MAIL]);
    }
    if (f->mask & 0x01u) {
        rail_make(f, SH_RAIL_NEW, y, 1, f->game_index, 10011, false, cb_new_game);
        y += 0x43;
    } else {
        rail_remove(f, &f->rail[SH_RAIL_NEW]);
    }
    if (f->mask & 0x02u) {
        if (engine_paused(f->p)) {
            rail_remove(f, &f->rail[SH_RAIL_PAUSE]);
            rail_make(f, SH_RAIL_RESUME, y, 3, 0, 10013, true, cb_pause);
        } else {
            rail_remove(f, &f->rail[SH_RAIL_RESUME]);
            rail_make(f, SH_RAIL_PAUSE, y, 2, 0, 10012, false, cb_pause);
        }
        y += 0x43;
    } else {
        rail_remove(f, &f->rail[SH_RAIL_PAUSE]);
        rail_remove(f, &f->rail[SH_RAIL_RESUME]);
    }
    if (f->mask & 0x04u) {
        rail_make(f, SH_RAIL_SCORES, y, 5, 0, 10015, false, cb_pause); /* High Scores (not for Moeboid) */
        y += 0x43;
    } else {
        rail_remove(f, &f->rail[SH_RAIL_SCORES]);
    }
    if (f->mask & 0x10u) rail_make(f, SH_RAIL_HELP, y, 4, 0, 10014, false, cb_how_to_play);
    else rail_remove(f, &f->rail[SH_RAIL_HELP]);
}

void sh_menu_item(ShellFrame *f, ShellBtn *b, const char *text, int32_t x, int32_t y, bool home, int32_t px,
                  EngineButtonFn cb) {
    /* Z:0x41d370(text, x, y, home, size, owner, cb): faces 360 x 30 opaque (Z:0x4138f0(0x168, 0x1e, 0)), font
     * CreateFont("Arial", size, 1) (bold), cleared #3333cc; text white at ((180 - cx) / 2, 27 - cy), the
     * same in #FFCC00 at +180; 3-line underline (Z:0x41d2b0); small round back (cell 0 / hover cell 2) at
     * (150, 4) / (330, 4); home icons (IMG-HOME / IMG-HOME2) at (0, 6) / (180, 6); button 180 x 30. */
    Port *p = f->p;
    b->s = 0;
    Image *backs = NULL;
    uint32_t sb = sh_gif(f, "slb-lilbtnbacks-hc.gif", 0, &backs);
    uint32_t fs = engine_surface_blank(p, 0x168, 0x1e, 0);
    uint32_t fimg = fs ? engine_surface_image(p, fs) : 0;
    Image *faces = sh_img(f, fimg);
    if (faces && backs) {
        ZmlContext rc;
        sh_rc_init(f, &rc);
        zml_font_create(&rc.font, &f->fonts, "Arial", px, ZML_BOLD); /* Z:0x413f80 SetFont */
        int32_t cx, cy;
        sh_measure_rc(&rc, text, &cx, &cy);
        draw_clear(faces, IMG_RGB(0x33u, 0x33u, 0xccu));
        rc.text_color = IMG_RGB(255u, 255u, 255u);
        sh_zml_image(f, &rc, faces, text, (0xb4 - cx) / 2, 0x1b - cy, NULL);
        rc.text_color = IMG_RGB(255u, 0xccu, 0u);
        sh_zml_image(f, &rc, faces, text, (0xb4 - cx) / 2 + 0xb4, 0x1b - cy, NULL);
        for (int32_t k = 0; k < 2; k++) { /* Z:0x41d2b0(img, x1, 27, x2, 27, 0) */
            int32_t x1 = k ? 0xb4 : 0, x2 = k ? 0x159 : 0xa5;
            draw_line(faces, x1, 0x1b, x2, 0x1b, IMG_RGB(0x99u, 0x99u, 0x99u));
            draw_line(faces, x1, 0x1c, x2, 0x1c, IMG_RGB(0x66u, 0x66u, 0x66u));
            draw_line(faces, x1, 0x1d, x2, 0x1d, IMG_RGB(0x33u, 0x33u, 0x33u));
        }
        DrawRect d0 = {0x96, 4, 0xb0, 0x1e}, s0 = {0, 0, 0x1a, 0x1a};
        DrawRect d1 = {0x14a, 4, 0x164, 0x1e}, s1 = {0x34, 0, 0x4e, 0x1a};
        draw_blt(faces, &d0, backs, &s0);
        draw_blt(faces, &d1, backs, &s1);
        if (home) {
            Image *h1 = NULL, *h2 = NULL;
            uint32_t a = sh_gif(f, "img-home.gif", 0, &h1), c = sh_gif(f, "img-home2.gif", 0, &h2);
            if (h1) draw_at(faces, h1, 0, 6);
            if (h2) draw_at(faces, h2, 0xb4, 6);
            sh_release(f, &a);
            sh_release(f, &c);
        }
        b->s = engine_button(p, f->root, x, y, 0xb4, 0x1e, fimg, 0, 0, cb, f);
        b->x = x;
        b->y = y;
        b->w = 0xb4;
        b->h = 0x1e;
    }
    sh_release(f, &fs);
    sh_release(f, &sb);
}

void sh_link_button(ShellFrame *f, ShellBtn *b, const char *text, int32_t x, int32_t y, int32_t id, int32_t px,
                    EngineButtonFn cb) {
    /* Z:0x41ebe0(text, x, y, id, size, owner, cb): font CreateFont("Arial", size, 5) (bold, underline);
     * w = cx + 4; faces 2w x cy keyed, cleared #3333cc; "<B>" then the text in white at (0, 0), the text in
     * #FFCC00 at (w, 0); button w x cy. */
    Port *p = f->p;
    b->s = 0;
    ZmlContext rc;
    sh_rc_init(f, &rc);
    zml_font_create(&rc.font, &f->fonts, "Arial", px, ZML_BOLD | ZML_UNDERLINE);
    int32_t cx, cy;
    sh_measure_rc(&rc, text, &cx, &cy);
    int32_t w = cx + 4;
    uint32_t fs = engine_surface_blank(p, 2 * w, cy, ENG_SURF_KEYED);
    uint32_t fimg = fs ? engine_surface_image(p, fs) : 0;
    Image *faces = sh_img(f, fimg);
    if (faces) {
        draw_clear(faces, IMG_RGB(0x33u, 0x33u, 0xccu));
        rc.text_color = IMG_RGB(255u, 255u, 255u);
        sh_zml_image(f, &rc, faces, "<B>", 0, 0, NULL); /* Z:0x4350f0 */
        sh_zml_image(f, &rc, faces, text, 0, 0, NULL);
        rc.text_color = IMG_RGB(255u, 0xccu, 0u);
        sh_zml_image(f, &rc, faces, text, w, 0, NULL);
        b->s = engine_button(p, f->root, x, y, w, cy, fimg, 0, id, cb, f);
        b->x = x;
        b->y = y;
        b->w = w;
        b->h = cy;
    }
    sh_release(f, &fs);
}
