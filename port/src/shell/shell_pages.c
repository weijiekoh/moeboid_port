/* Shell pages and flows (M5b): title strip, pause page and footer, How To Play, Help, About, Personalize,
 * View All Games, New Game and the quit check, Terms of Service link. See shell_frame.h.
 *
 * Page surface: ctx[3] (CShell +0x2cc, 500 x 420 opaque at (282, 50)); every page clears it to its
 * background colour (black) and detaches its children first (Z:0x413e80, Z:0x414950).
 *
 * Hyperlinks (CHyperLink Z:0x4184e0, click Z:0x41c700): decision 8b keeps the texts verbatim. Links to
 * other shell pages keep their click target (help page ids, 20001 About, 20002 Help contents), so that
 * page navigation works as in the original; links to URLs (10000..10005) are inert and the Security
 * page link (20000) has no target (port interpretation of decision 8b, reported to the orchestrator).
 * Inert links are drawn in their normal state into the page image.
 *
 * SetTextColor on the page image before a page string (Z:0x413d50, for example white in Z:0x420e39) goes
 * only to the shell's copy rc_page: the engine API has no text-colour setter, and every page string sets
 * its own colour first, so the drawn pixels are the same. */
#include "shell_frame.h"

static Port *P(ShellFrame *f) { return f->p; }

/* ------------------------------------------------------------------ page helpers */

void sh_page_release_kids(ShellFrame *f) {
    for (int32_t i = 0; i < f->n_page_kids; i++) sh_release(f, &f->page_kids[i]);
    f->n_page_kids = 0;
    for (int32_t i = 0; i < f->n_link; i++) sh_release(f, &f->link[i].s);
    f->n_link = 0;
    sh_release(f, &f->footer.s);
    sh_release(f, &f->tile.s);
    sh_release(f, &f->toggle.s);
}

static void page_kid(ShellFrame *f, uint32_t s) {
    if (!s) return;
    if (f->n_page_kids < (int32_t)RT_COUNTOF(f->page_kids)) f->page_kids[f->n_page_kids++] = s;
    else engine_release(f->p, s); /* stays attached; the engine owns it through the parent */
}

static uint32_t page_img(ShellFrame *f) { return engine_surface_image(P(f), f->page); }

void sh_page_clear(ShellFrame *f) {
    /* Z:0x413e80 (clear to the background colour: black for the opaque ctx[3]) and Z:0x414950 */
    uint32_t img = page_img(f);
    Image *im = sh_img(f, img);
    if (im) draw_clear(im, IMG_BLACK);
    sh_changed(f, img);
    engine_surface_detach_all(P(f), f->page);
    sh_page_release_kids(f);
}

void sh_show_page(ShellFrame *f) {
    /* ctx[2] SetVisible(0, shell key), ctx[3] SetVisible(1, 0) */
    engine_surface_set_visible(P(f), f->game, false, engine_shell_key(P(f)));
    engine_surface_set_visible(P(f), f->page, true, 0);
    f->pages_shown++;
}

static void show_game(ShellFrame *f) {
    engine_surface_set_visible(P(f), f->game, true, engine_shell_key(P(f)));
    engine_surface_set_visible(P(f), f->page, false, 0);
}

static void page_zml(ShellFrame *f, const char *text, int32_t x, int32_t y, const GdiRect *rect);

/* ------------------------------------------------------------------ title strip (Z:0x41b7f0) */

void sh_title(ShellFrame *f, const char *text) {
    /* Clear #FFCC00, text colour black, "<S1></b><t></u></i>" (Z:0x434e1c, 800-wide skin), then the text.
     * When a game runs and its name (applet +0x24) equals the text (lstrcmpiA), img-tm2 at (cx + 2, 4)
     * with cx = width of the text in the current font (Z:0x41b8f3..0x41b95a). */
    if (!f->title) return;
    Port *p = P(f);
    uint32_t img = engine_surface_image(p, f->title);
    Image *im = sh_img(f, img);
    if (!im) return;
    draw_clear(im, IMG_RGB(255u, 0xccu, 0u));
    f->rc_title.text_color = IMG_BLACK;
    sh_zml_image(f, &f->rc_title, im, "<S1></b><t></u></i>", 0, 0, NULL);
    sh_zml_image(f, &f->rc_title, im, text, 0, 0, NULL);
    if (engine_applet_running(p)) {
        char name[256];
        sh_string_in(f, "gam", 4, name, sizeof name); /* +0x199, set before Shell_StartApplet (Z:0x4247c9) */
        /* "PehPai" and "UltraColorCode" get display names (Z:0x41b8b2..0x41b8e2); not Moeboid */
        bool same = true;
        for (int32_t i = 0;; i++) {
            char a = name[i], b = text[i];
            if (a >= 'a' && a <= 'z') a = (char)(a - 32);
            if (b >= 'a' && b <= 'z') b = (char)(b - 32);
            if (a != b) {
                same = false;
                break;
            }
            if (!a) break;
        }
        Image *tm = f->img_tm2 ? sh_img(f, engine_surface_image(p, f->img_tm2)) : NULL;
        if (same && tm) {
            int32_t cx, cy;
            sh_measure_rc(&f->rc_title, text, &cx, &cy);
            draw_at(im, tm, cx + 2, 4);
        }
    }
    sh_changed(f, img);
}

/* ------------------------------------------------------------------ links */

#define SH_MAX_LINKS 24

typedef struct LinkSet {
    ZmlLink l[SH_MAX_LINKS];
    int32_t n;
} LinkSet;

static void link_add(void *user, const ZmlLink *link) {
    LinkSet *s = (LinkSet *)user;
    if (s->n < SH_MAX_LINKS) s->l[s->n++] = *link;
}

static bool link_active(int32_t id) {
    /* Z:0x41c700: 10000..10005 ShellExecuteA URLs and 20000 Security page: no target (decision 8b);
     * 20001 About, 20002 Help contents and help page ids change the page. */
    if (id >= 10000 && id <= 10005) return false;
    if (id == 20000) return false;
    return id == 20001 || id == 20002 || (id >= 100 && id < 10000);
}

static void cb_link(Port *p, void *ctx, int32_t id) {
    (void)p;
    ShellFrame *f = (ShellFrame *)ctx;
    if (id == 20001) sh_about(f);           /* Z:0x41c7d9 */
    else if (id == 20002) sh_help(f, 101);  /* Z:0x41c7e8: record +8 = 0x65 */
    else if (link_active(id)) sh_help(f, id); /* Z:0x41c806 */
}

static void make_links(ShellFrame *f, const LinkSet *s) {
    /* CHyperLink: keyed surface lw + space x lh + 2 at the link position, child of the page; the
     * constructor draws the hover string, then the normal string (Z:0x4187a0, Z:0x4187f0) without a clear
     * between them; enter draws hover, leave draws normal. engine_image_zml drew every link in its normal
     * state into the page; an active link gets an engine button on top with the faces [normal, hover]
     * (the normal face covers the same glyph pixels, so the page looks the same). */
    Port *p = P(f);
    for (int32_t i = 0; i < s->n; i++) {
        const ZmlLink *l = &s->l[i];
        if (!link_active(l->id)) continue;
        uint32_t fs = engine_surface_blank(p, 2 * l->w, l->h, ENG_SURF_KEYED);
        uint32_t fimg = fs ? engine_surface_image(p, fs) : 0;
        Image *faces = sh_img(f, fimg);
        if (faces) {
            ZmlLink a = *l, b = *l;
            a.x = 0;
            a.y = 0;
            b.x = l->w;
            b.y = 0;
            zml_link_draw(&f->fonts, faces, &a, 1, f->smoothing); /* constructor: hover, then normal */
            zml_link_draw(&f->fonts, faces, &a, 0, f->smoothing);
            zml_link_draw(&f->fonts, faces, &b, 1, f->smoothing); /* after enter: normal + hover */
            zml_link_draw(&f->fonts, faces, &b, 0, f->smoothing);
            zml_link_draw(&f->fonts, faces, &b, 1, f->smoothing);
            uint32_t bs = engine_button(p, f->page, l->x, l->y, l->w, l->h, fimg, 0, l->id, cb_link, f);
            if (bs && f->n_link < (int32_t)RT_COUNTOF(f->link)) {
                f->link[f->n_link] = (ShellBtn){bs, l->x, l->y, l->w, l->h};
                f->link_id[f->n_link++] = l->id;
            } else {
                page_kid(f, bs);
            }
        }
        sh_release(f, &fs);
    }
}

static void page_zml(ShellFrame *f, const char *text, int32_t x, int32_t y, const GdiRect *rect) {
    /* DrawZML on ctx[3] with parent = ctx[3], owner = shell, callback Z:0x41cdf0 (links). The pixels come
     * from engine_image_zml, which keeps the render context of ctx[3] that the game's renderer shares
     * (How To Play). The link rectangles come from the same layout run with the shell's copy of that
     * state (rc_page) on a scratch image. */
    uint32_t img = page_img(f);
    Image *im = sh_img(f, img);
    if (!im || !f->scratch_px) return;
    LinkSet set;
    set.n = 0;
    ZmlLinkSink sink = {link_add, &set, 0};
    Image scratch = {RT_MIN(im->w, ENG_GAME_W), RT_MIN(im->h, ENG_GAME_H), ENG_GAME_W, f->scratch_px, 0};
    zml_draw(&f->rc_page, &scratch, text, (int32_t)rt_strlen(text), x, y, rect, 0, &sink);
    engine_image_zml(P(f), img, text, x, y, rect);
    make_links(f, &set);
}

/* ------------------------------------------------------------------ footer, pause */

static void cb_back(Port *p, void *ctx, int32_t id) {
    (void)p;
    (void)id;
    sh_back_to_game((ShellFrame *)ctx); /* Z:0x41c3e0 -> Z:0x41b430 */
}

void sh_footer(ShellFrame *f) {
    /* Z:0x41b290: pen #333333, lines (5, 380)-(495, 380) and (5, 381)-(495, 381); str 10017 at (0, 392);
     * arrow button (Z:0x42b990: ctx[3], (445, 387), 26 x 26, lil backs, lil icon 3, flags 0) */
    uint32_t img = page_img(f);
    Image *im = sh_img(f, img);
    if (!im) return;
    draw_line(im, 5, 0x17c, 0x1ef, 0x17c, IMG_RGB(0x33u, 0x33u, 0x33u));
    draw_line(im, 5, 0x17d, 0x1ef, 0x17d, IMG_RGB(0x33u, 0x33u, 0x33u));
    char buf[SH_STR_MAX];
    sh_string(f, 10017, buf, sizeof buf);
    page_zml(f, buf, 0, 0x188, NULL);
    sh_imgbtn(f, &f->footer, f->page, 0x1bd, 0x183, 0x1a, 0x1a, "slb-lilbtnbacks-hc.gif", "slb-lilbtnicons.gif", 3, 0,
              "", 0u, false, cb_back);
}

void sh_pause_toggle(ShellFrame *f) {
    /* Z:0x41cb30 */
    Port *p = P(f);
    sh_click(f);
    engine_set_paused(p, !engine_paused(p));
    sh_page_clear(f);
    sh_rail(f);
    if (engine_paused(p)) {
        char buf[SH_STR_MAX];
        sh_string(f, 10016, buf, sizeof buf);
        page_zml(f, buf, 0x32, 0xb9, NULL);
        if (engine_applet_running(p)) sh_footer(f);
        sh_show_page(f);
        f->last_page = 10016;
    } else {
        sh_title(f, f->caption);
        /* input +0x08 (SetFocus) and the e-mail edit (+0x368): no port equivalent */
        show_game(f);
    }
}

void sh_back_to_game(ShellFrame *f) {
    /* Z:0x41b430: the page image is not cleared, only its children go */
    Port *p = P(f);
    if (engine_applet_running(p)) {
        sh_title(f, f->caption);
        engine_set_paused(p, false);
        engine_surface_detach_all(p, f->page);
        sh_page_release_kids(f);
        show_game(f);
        sh_rail(f);
        return;
    }
    sh_view_all_games(f);
    sh_rail(f);
}

/* ------------------------------------------------------------------ How To Play, Help */

void sh_how_to_play(ShellFrame *f) {
    /* Z:0x41c3f0 */
    Port *p = P(f);
    char buf[SH_STR_MAX];
    sh_click(f);
    sh_string(f, 2400, buf, sizeof buf);
    sh_title(f, buf);
    sh_page_clear(f);
    engine_applet_event(p, 1); /* applet +0x08(1): event 0x10, the game draws HELP.ZML into ctx[3] */
    /* The game's renderer (G:0x10004a00) changes the render context of the ctx[3] image: its last line
     * (G:0x10001d86) leaves Arial 10, the style of the end of HELP.ZML (regular) and #999999 (fonts.md 7,
     * 8.1). The engine keeps that state for engine_image_zml; the shell's copy (used only for link
     * rectangles) takes the same values (inferred from fonts.md, no engine getter). */
    zml_font_create(&f->rc_page.font, &f->fonts, "Arial", 10, 0);
    f->rc_page.text_color = IMG_RGB(0x99u, 0x99u, 0x99u);
    engine_set_paused(p, true);
    sh_rail(f);
    if (engine_applet_running(p)) sh_footer(f);
    sh_show_page(f);
    f->last_page = 2400;
}

void sh_help(ShellFrame *f, int32_t id) {
    /* Z:0x41c4c0(record): record +8 = page string id (101 contents, 111..118 topics) */
    Port *p = P(f);
    char buf[SH_STR_MAX], text[0x1000];
    sh_click(f);
    if (engine_applet_running(p)) engine_set_paused(p, true);
    sh_string(f, 100, buf, sizeof buf);
    sh_title(f, buf);
    sh_string(f, (uint32_t)id, text, sizeof text);
    sh_page_clear(f);
    page_zml(f, text, 0, 0, NULL);
    if (id == 0x76) {
        /* Extended Support Information: "<S2>%s" with the shell version (+0x3a4, str 1) at (180, 65), shell
         * GUID (+0x3b4, all zero without a server, Z:0x41ad7f) at (180, 81), "Installed" (the port is
         * always installed, shell.md 1) at (180, 97), game name (+0x24) at (180, 129), game version (+0x28)
         * at (180, 145). */
        char ver[16], line[64];
        sh_string(f, 1, ver, 14);
        rt_snprintf(line, sizeof line, "<S2>%s", ver);
        page_zml(f, line, 0xb4, 0x41, NULL);
        page_zml(f, "{00000000-0000-0000-0000-000000000000}", 0xb4, 0x51, NULL);
        page_zml(f, "Installed", 0xb4, 0x61, NULL);
        page_zml(f, f->game_name, 0xb4, 0x81, NULL);
        page_zml(f, f->game_version, 0xb4, 0x91, NULL);
    }
    if (engine_applet_running(p)) sh_footer(f);
    sh_rail(f);
    sh_show_page(f);
    f->last_page = id;
}

/* ------------------------------------------------------------------ About */

void sh_about(ShellFrame *f) {
    /* Z:0x420d80 */
    Port *p = P(f);
    char buf[SH_STR_MAX];
    sh_click(f);
    if (engine_applet_running(p)) engine_set_paused(p, true);
    sh_string(f, 1000, buf, sizeof buf);
    sh_title(f, buf);
    sh_page_clear(f);
    f->rc_page.text_color = IMG_RGB(255u, 255u, 255u);
    sh_string(f, 1001, buf, sizeof buf);
    GdiRect r = {0xf, 0xf, 0x1e5, 0x195};
    page_zml(f, buf, 0xf, 0xf, &r);
    /* "<S3><C999999>v%d.%d" with the version bytes +0x399, +0x39a of "01.01.01.1034" (str 1): "v1.1" */
    char ver[16], line[48];
    int32_t num[4] = {0, 0, 0, 0}, k = 0;
    sh_string(f, 1, ver, 14);
    for (int32_t i = 0; ver[i] && k < 4; i++) {
        if (ver[i] == '.') k++;
        else if (ver[i] >= '0' && ver[i] <= '9') num[k] = num[k] * 10 + (ver[i] - '0');
    }
    rt_snprintf(line, sizeof line, "<S3><C999999>v%d.%d", (int)num[1], (int)num[2]);
    page_zml(f, line, 0x1d6, 5, NULL);
    /* McAfee button (Z:0x420ed4..0x420fb4): faces 2w x h opaque with img-mcafee.gif twice, button at
     * (394, 328) that opens the Security page (Z:0x421490). The Security page is removed (decision 8b):
     * the face is drawn into the page, no click target. */
    Image *mc = NULL;
    uint32_t ms = sh_gif(f, "img-mcafee.gif", 2, &mc);
    uint32_t img = page_img(f);
    Image *im = sh_img(f, img);
    if (mc && im) {
        Image face = {0};
        if (sh_image_new(&face, mc->w, mc->h, false)) {
            draw_at(&face, mc, 0, 0);
            draw_at(im, &face, 0x18a, 0x148);
            sh_image_free(&face);
        }
        sh_changed(f, img);
    }
    sh_release(f, &ms);
    if (engine_applet_running(p)) sh_footer(f);
    sh_show_page(f);
    sh_rail(f);
    f->last_page = 1000;
}

/* ------------------------------------------------------------------ Personalize */

static void cb_toggle(Port *p, void *ctx, int32_t id) {
    (void)p;
    (void)id;
    sh_sound_toggle((ShellFrame *)ctx); /* Z:0x423760 -> Z:0x423260 */
}

static bool sound_on(ShellFrame *f) {
    /* "Sound" entry, value "true" (lstrcmpiA, Z:0x422dd1); a missing entry is created as "true" */
    const char *v = engine_prop_get(P(f), "Sound");
    if (!v) return true;
    const char *t = "true";
    for (int32_t i = 0;; i++) {
        char a = v[i], b = t[i];
        if (a >= 'A' && a <= 'Z') a = (char)(a + 32);
        if (a != b) return false;
        if (!a) return true;
    }
}

static void sound_line(ShellFrame *f, bool on) {
    /* str 1102 + (1103 "On" | 1104 "Off") (lstrcatA) at (22, 250) */
    char buf[SH_STR_MAX], s2[SH_STR_MAX];
    sh_string(f, 1102, buf, sizeof buf);
    sh_string(f, on ? 1103 : 1104, s2, sizeof s2);
    size_t n = rt_strlen(buf), m = rt_strlen(s2);
    if (n + m + 1u > sizeof buf) m = sizeof buf - n - 1u;
    rt_memcpy(buf + n, s2, m);
    buf[n + m] = 0;
    page_zml(f, buf, 0x16, 0xfa, NULL);
}

void sh_personalize(ShellFrame *f) {
    /* Z:0x422b90. Kept: str 1101 (its URL link inert), the sound row with Toggle, the separator rectangles.
     * Removed (decision 8c): the proxy section (str 1106-1108, Server/Port edit boxes, Apply). */
    Port *p = P(f);
    char buf[SH_STR_MAX];
    sh_click(f);
    if (engine_applet_running(p)) engine_set_paused(p, true);
    sh_string(f, 1100, buf, sizeof buf);
    sh_title(f, buf);
    sh_page_clear(f);
    f->rc_page.text_color = IMG_RGB(255u, 255u, 255u);
    sh_string(f, 1101, buf, sizeof buf);
    GdiRect r = {0xf, 0xf, 0x1e5, 0x195};
    page_zml(f, buf, 0xf, 0xf, &r);
    sound_line(f, sound_on(f));
    sh_string(f, 1105, buf, sizeof buf);
    sh_imgbtn(f, &f->toggle, f->page, 0x15e, 0xf2, 0x58, 0x20, "slb-rectbtnbacks-hc.gif", NULL, 0, 0, buf, 4u, false,
              cb_toggle);
    /* str 1106 (290), 1107 (313), Server box (20, 330)-(140, 350), 1108, Port box (200, 330)-(320, 350):
     * removed (decision 8c) */
    uint32_t img = page_img(f);
    Image *im = sh_img(f, img);
    if (im) { /* pen #333333, frame rectangles (20, 230)-(480, 231) and (20, 280)-(480, 281) (Z:0x413bd0) */
        draw_frame_rect(im, 0x14, 0xe6, 0x1e0, 0xe7, IMG_RGB(0x33u, 0x33u, 0x33u));
        draw_frame_rect(im, 0x14, 0x118, 0x1e0, 0x119, IMG_RGB(0x33u, 0x33u, 0x33u));
        sh_changed(f, img);
    }
    /* Apply (str 20002, rect button at (350, 322)): removed with the proxy section */
    if (engine_applet_running(p)) sh_footer(f);
    sh_show_page(f);
    sh_rail(f);
    f->last_page = 1100;
}

void sh_sound_toggle(ShellFrame *f) {
    /* Z:0x423260: click (before the change), black FillRect (22, 250)-(300, 270), flip the "Sound" value,
     * the new line, SetEnabled. Not installed: IDD_CONFIRM_SAVE (removed: always installed). */
    sh_click(f);
    uint32_t img = page_img(f);
    Image *im = sh_img(f, img);
    if (im) draw_fill_rect(im, 0x16, 0xfa, 300, 0x10e, IMG_BLACK);
    bool on = !sound_on(f);
    engine_sound_set_enabled(P(f), on); /* also stores core/Sound ("true" / "false") */
    sound_line(f, on);
    sh_changed(f, img);
}

/* ------------------------------------------------------------------ View All Games, New Game */

static void cb_tile(Port *p, void *ctx, int32_t id) {
    (void)p;
    sh_new_game((ShellFrame *)ctx, id); /* Z:0x424220 -> Z:0x423fc0 -> Z:0x41c910 (record +8 = tile index) */
}

static void tile_draw(ShellFrame *f, ZmlContext *rc, Image *im, const char *name, bool hover) {
    /* Z:0x423ff0 (hover) / Z:0x424100 (leave) */
    uint32_t pen = hover ? IMG_RGB(255u, 255u, 0u) : IMG_BLACK;
    draw_line(im, 0x12, 1, 0x5b, 1, pen);
    draw_line(im, 0x5b, 1, 0x5b, 0x46, pen);
    draw_line(im, 0x5c, 0x45, 2, 0x45, pen);
    draw_line(im, 3, 0x45, 3, 0x11, pen);
    if (!hover) draw_fill_rect(im, 0, 0x45, 100, 0x59, pen);
    sh_zml_image(f, rc, im, hover ? "<S4><u><C>" : "<S4><C>", 0, 0, NULL);
    sh_zml_image(f, rc, im, name, 0, 0x45, NULL);
    sh_zml_image(f, rc, im, hover ? "</C></u>" : "</C>", 0, 0, NULL);
    int32_t cx, cy;
    sh_measure_rc(rc, name, &cx, &cy);
    Image *tm = f->img_tm ? sh_img(f, engine_surface_image(P(f), f->img_tm)) : NULL;
    if (tm) draw_at(im, tm, cx / 2 + 0x30, 0x47);
}

static void make_tile(ShellFrame *f, int32_t index) {
    /* Game info (Z:0x4243b0): strings 3 (version), 4 (name), 6 (logo GIF), 8 (type: "Sweat" 0 red,
     * "Relax" 1 green, other 2 blue). Tile Z:0x423d10: surface 92 x 82, flags 2; logo at (8, 6), border
     * image of the type at (0, 0), "<S4><C>" name at (0, 69) "</C>", img-tm at (cx / 2 + 48, 71); the
     * arrow (71, 49) only for games that are not installed. Position ((i % 5) * 100 + 5, (i / 5) * 88 + 20)
     * in ctx[3]. Port: engine button with faces [constructor state, hover state] (the leave state equals
     * the constructor state: its lines touch only black pixels). */
    Port *p = P(f);
    char name[256], logo_name[256], type[256];
    sh_string_in(f, "gam", 4, name, sizeof name);
    sh_string_in(f, "gam", 6, logo_name, sizeof logo_name);
    sh_string_in(f, "gam", 8, type, sizeof type);
    int32_t colour = 2;
    if (!rt_strcmp(type, "Sweat")) colour = 0;
    else if (!rt_strcmp(type, "Relax")) colour = 1;
    const int32_t w = 0x5c, h = 0x52;
    Image tile = {0};
    if (!sh_image_new(&tile, w, h, false)) return;
    Image *logo = NULL;
    uint32_t ls = sh_gif(f, logo_name, 0, &logo);
    if (logo) draw_at(&tile, logo, 8, 6);
    sh_release(f, &ls);
    Image *err = f->img_err[colour] ? sh_img(f, engine_surface_image(p, f->img_err[colour])) : NULL;
    if (err) draw_at(&tile, err, 0, 0);
    ZmlContext rc;
    sh_rc_init(f, &rc);
    rc.text_color = IMG_RGB(255u, 255u, 255u);
    sh_zml_image(f, &rc, &tile, "<S4><C>", 0, 0, NULL);
    sh_zml_image(f, &rc, &tile, name, 0, 0x45, NULL);
    sh_zml_image(f, &rc, &tile, "</C>", 0, 0, NULL);
    int32_t cx, cy;
    sh_measure_rc(&rc, name, &cx, &cy);
    Image *tm = f->img_tm ? sh_img(f, engine_surface_image(p, f->img_tm)) : NULL;
    if (tm) draw_at(&tile, tm, cx / 2 + 0x30, 0x47);
    uint32_t fs = engine_surface_blank(p, 2 * w, h, 0);
    uint32_t fimg = fs ? engine_surface_image(p, fs) : 0;
    Image *faces = sh_img(f, fimg);
    if (faces) {
        DrawRect l = {0, 0, w, h}, r = {w, 0, 2 * w, h};
        draw_blt(faces, &l, &tile, NULL);
        tile_draw(f, &rc, &tile, name, true);
        draw_blt(faces, &r, &tile, NULL);
        int32_t x = (index % 5) * 100 + 5, y = (index / 5) * 0x58 + 0x14;
        f->tile.s = engine_button(p, f->page, x, y, w, h, fimg, 0, index, cb_tile, f);
        f->tile.x = x;
        f->tile.y = y;
        f->tile.w = w;
        f->tile.h = h;
    }
    sh_release(f, &fs);
    sh_image_free(&tile);
}

/* Z:0x41b4d0. Returns 1 = go on, 0 = stop, 2 = wait for IDD_QUIT_SAVED (sh_modal_poll continues). */
static int32_t quit_check(ShellFrame *f, int32_t pend, int32_t id) {
    Port *p = P(f);
    if (!engine_applet_running(p)) return 1;
    if (f->gip == 2) return 0;
    bool paused0 = engine_paused(p);
    if (!paused0) engine_set_paused(p, true);
    if (f->gip != 0) {
        /* platform +0x18 = Z:0x405330: IDD_QUIT_SAVED "Warning: Game in Progress" (M5a) */
        if (shell_modal_open_quit_saved(p) == 0) {
            f->pending = pend;
            f->pending_id = id;
            f->pending_paused0 = paused0;
            return 2;
        }
        if (!paused0) engine_set_paused(p, false); /* no dialog possible: keep playing */
        return 0;
    }
    engine_set_paused(p, false);
    engine_applet_stop(p);
    return 1;
}

static void view_all_rest(ShellFrame *f) {
    /* Z:0x41f566.. */
    Port *p = P(f);
    char buf[SH_STR_MAX];
    /* applet +0x1c("None") (Z:0x41f575): the path of the current game; no visible effect */
    f->mask = 0;
    sh_rail(f);
    sh_string(f, 1200, buf, sizeof buf);
    sh_title(f, buf);
    sh_page_clear(f);
    f->rc_page.text_color = IMG_RGB(255u, 255u, 255u);
    sh_string(f, 1201, buf, sizeof buf);
    page_zml(f, buf, 1, 3, NULL);
    uint32_t img = page_img(f);
    Image *im = sh_img(f, img);
    if (im) {
        draw_line(im, 0x5b, 0xf, 0x1ef, 0xf, IMG_RGB(0x33u, 0x33u, 0x33u));
        draw_line(im, 0x5b, 0x10, 0x1ef, 0x10, IMG_RGB(0x33u, 0x33u, 0x33u));
    }
    /* One tile per installed game (files +0x0c, Z:0x41fdf0): Moeboid only. Promo tiles (table Z:0x435120)
     * and the "Coming soon" tile: removed (decision 6). */
    make_tile(f, 0);
    /* colour key (Z:0x41fb2a..0x41fcbe) */
    static const uint32_t k_str[3] = {1203, 1204, 1205};
    static const int32_t k_tx[3] = {0x32, 0xd2, 0x172};
    static const int32_t k_x[4] = {5, 0xa8, 0x14c, 0x1ef};
    const uint32_t pen[3] = {IMG_RGB(0x33u, 0x33u, 0xffu), IMG_RGB(0x33u, 0xffu, 0x33u), IMG_RGB(0xffu, 0u, 0u)};
    const uint32_t txt[3] = {IMG_RGB(0x66u, 0x66u, 0xffu), IMG_RGB(0x33u, 0xffu, 0x33u), IMG_RGB(0xffu, 0u, 0u)};
    for (int32_t i = 0; i < 3; i++) {
        f->rc_page.text_color = txt[i];
        sh_string(f, k_str[i], buf, sizeof buf);
        page_zml(f, buf, k_tx[i], 0x197, NULL);
        im = sh_img(f, img);
        if (im) {
            int32_t ya = i == 0 ? 0x195 : 0x194, yb = i == 0 ? 0x194 : 0x195; /* line order as Z:0x41fb5f.. */
            draw_line(im, k_x[i], ya, k_x[i + 1], ya, pen[i]);
            draw_line(im, k_x[i], yb, k_x[i + 1], yb, pen[i]);
        }
    }
    sh_changed(f, img);
    sh_show_page(f);
    f->last_page = 1200;
    (void)p;
}

void sh_view_all_games(ShellFrame *f) {
    /* Z:0x41f500 */
    if (f->vag_first) f->vag_first = false; /* DAT_004351b4: no click at the start-up call */
    else sh_click(f);
    if (f->pending) return;
    int32_t r = quit_check(f, SH_PEND_VIEW_ALL, 0);
    if (r == 1) view_all_rest(f);
}

static void new_game_rest(ShellFrame *f, int32_t id) {
    /* Z:0x41c973..: id >= game count opens Zap Me A Game (removed; one game). Then page hidden, game
     * shown and cleared, Stop, children detached, Start (engine_new_game), rail. */
    Port *p = P(f);
    if (id >= 1) return;
    f->game_index = id; /* DAT_0045dfdc */
    engine_new_game(p);
    sh_page_release_kids(f);
    sh_rail(f);
}

void sh_new_game(ShellFrame *f, int32_t id) {
    /* Z:0x41c910: the click plays only when DAT_00434e70 == 0, which never happens */
    if (f->new_game_click) sh_click(f);
    if (f->pending) return;
    int32_t r = quit_check(f, SH_PEND_NEW_GAME, id);
    if (r == 1) new_game_rest(f, id);
}

void sh_tos(ShellFrame *f) {
    /* Z:0x41cb20 -> platform +0x24 (Z:0x405540): Terms of Service dialog (M5a, decision 5) */
    shell_modal_open_tos(P(f));
}

void sh_modal_poll(ShellFrame *f) {
    /* Continuation of Z:0x41b4d0 after IDD_QUIT_SAVED (0 Yes, 1 No, 2 Esc); ToS needs nothing (OK only,
     * the opt-in checkbox and SetUserProfile are removed, decision 5). */
    Port *p = P(f);
    uint32_t kind;
    int32_t result;
    if (!shell_modal_take_result(p, &kind, &result)) return;
    if (kind != DLGM_QUIT_SAVED || !f->pending) return;
    int32_t pend = f->pending, id = f->pending_id;
    f->pending = SH_PEND_NONE;
    if (result != 0) {
        if (!f->pending_paused0) engine_set_paused(p, false);
        return;
    }
    engine_set_paused(p, false);
    engine_applet_stop(p);
    if (pend == SH_PEND_NEW_GAME) new_game_rest(f, id);
    else view_all_rest(f);
}
