/* Shell frame (M5b): hooks, frame build (Z:0x41d6c0), start-up and splash (Z:0x403d40), the strong
 * shell_api.h functions except shell_dialog_open (M5a, shell_modal.c). See shell_frame.h. */
#include "shell_frame.h"

ShellFrame *shell_frame_of(Port *p) {
    return (p && p->shell) ? &((ShellAll *)(void *)p->shell)->f : NULL;
}

static void splash_text(ShellFrame *f);

ShellFrame *shell_frame_get(Port *p) {
    if (!p) return NULL;
    if (!p->shell) {
        ShellAll *all = (ShellAll *)rt_calloc(1, sizeof(ShellAll));
        if (!all) return NULL;
        p->shell = &all->modal; /* shell_modal_init keeps an existing Port.shell */
        ShellFrame *f = &all->f;
        f->p = p;
        f->smoothing = p->smoothing ? 1 : 0; /* decision 4b: Port.smoothing (default 1 = Standard) */
        f->phase = SH_WAIT_START;
        f->vag_first = true;       /* DAT_004351b4 = 1 (.data) */
        f->new_game_click = false; /* DAT_00434e70 = 1 (.data): the click of Z:0x41c910 never plays */
        f->last_page = -1;
    }
    ShellFrame *f = shell_frame_of(p);
    if (!f->loaded && p->pack && p->pack_len) {
        /* resources: the pack exists from core_start on (the engine init may call shell_frame_build first) */
        f->loaded = true;
        if (mpack_open(&f->pack, p->pack, p->pack_len) == 0 && text_fonts_load(&f->fonts, &f->pack) > 0) f->ok = true;
        else rt_log("shell: no resource pack or no fonts; frame not drawn");
        sh_rc_init(f, &f->rc_root);
        sh_rc_init(f, &f->rc_title);
        sh_rc_init(f, &f->rc_page);
        f->scratch_px = (uint32_t *)rt_malloc((size_t)ENG_GAME_W * ENG_GAME_H * 4u);
        f->splash_ok = f->ok && sh_splash_decode(f) == 0;
        if (f->splash_ok) splash_text(f);
        shell_modal_init(p);
    }
    return f;
}

void sh_click(ShellFrame *f) {
    /* shell +0x80 (BtnClick.wav, loaded by Z:0x41b170 with flag 0) Play(0) */
    engine_play_sound(f->p, "BtnClick.wav");
}

/* ------------------------------------------------------------------ splash (WinMain Z:0x403d40) */

static void splash_text(ShellFrame *f) {
    /* Z:0x403f98..0x40407f: CreateFontIndirectA(Arial, lfHeight -11, weight 0) into the splash window DC;
     * four lines ExtTextOutA(hdc, 90, y, 0, NULL, ...) from y 172, step tmHeight + tmExternalLeading. The DC
     * is a fresh window DC: text black, background white, OPAQUE (Windows defaults, inferred; fonts.md 4). */
    static const char *const k_lines[4] = {
        "Copyright (c) 2000 ZapSpot, Inc.  All Rights Reserved.",       /* Z:0x432564 */
        "This program is protected by US and international copyright",  /* Z:0x432528 */
        "laws.  ZapSpot, the ZapSpot logo, and Life is Good are",       /* Z:0x4324f0 */
        "trademarks or registered trademarks of ZapSpot, Inc."};        /* Z:0x4324b8 */
    GdiFont font;
    if (gdi_font_select(&font, &f->fonts, "Arial", -11, 0, 0, 0) != 0) return;
    GdiTextMetrics tm;
    gdi_get_text_metrics(&font, &tm);
    Image im = {SH_SPLASH_W, SH_SPLASH_H, SH_SPLASH_W, f->splash_px, 0};
    GdiTextState st = {IMG_BLACK, IMG_RGB(255u, 255u, 255u), GDI_OPAQUE, (uint8_t)(f->smoothing ? 1 : 0)};
    int32_t y = 0xac;
    for (int32_t i = 0; i < 4; i++) {
        gdi_ext_text_out(&im, 0x5a, y, 0, NULL, k_lines[i], (int32_t)rt_strlen(k_lines[i]), &font, &st);
        y += tm.tmHeight + tm.tmExternalLeading;
    }
}

static void splash_compose(ShellFrame *f) {
    /* Port: the canvas is black around the 400 x 240 splash, which sits at the canvas centre (the original
     * centres it on the screen, Z:0x403eda). */
    Port *p = f->p;
    const int32_t ox = ((int32_t)PORT_W - SH_SPLASH_W) / 2, oy = ((int32_t)PORT_H - SH_SPLASH_H) / 2;
    for (uint32_t i = 0; i < PORT_W * PORT_H; i++) {
        p->frame[4u * i + 0u] = 0u;
        p->frame[4u * i + 1u] = 0u;
        p->frame[4u * i + 2u] = 0u;
        p->frame[4u * i + 3u] = 255u;
    }
    if (f->phase == SH_SPLASH && f->splash_ok) {
        for (int32_t y = 0; y < SH_SPLASH_H; y++)
            for (int32_t x = 0; x < SH_SPLASH_W; x++) {
                uint32_t px = f->splash_px[y * SH_SPLASH_W + x];
                uint8_t *d = p->frame + 4u * ((uint32_t)(oy + y) * PORT_W + (uint32_t)(ox + x));
                d[0] = (uint8_t)IMG_R(px);
                d[1] = (uint8_t)IMG_G(px);
                d[2] = (uint8_t)IMG_B(px);
                d[3] = 255u;
            }
    }
    core_frame_changed(p);
}

static void startup_pages(ShellFrame *f) {
    /* End of Z:0x41d6c0 with a game file on the command line (Z:0x41ea1d..0x41ea5f): View All Games
     * (Z:0x41f500), then New Game (Z:0x41c910) with the index of that game (DAT_0045dff0 = 0). */
    sh_view_all_games(f);
    sh_new_game(f, 0);
}

static void splash_end(EngineTimer *t, const TimerEvent *ev) {
    /* The splash window is destroyed when the subsystems exist (Z:0x403d40 after Z:0x413040); decision 13
     * gives it SH_SPLASH_MS of virtual time. Then the frame is shown; the shell starts the game unless the
     * engine already started it in its init hook. */
    (void)ev;
    ShellFrame *f = (ShellFrame *)t->ctx;
    Port *p = f->p;
    timer_stop(&p->timers, t);
    f->phase = SH_RUNNING;
    if (!f->built) shell_frame_build(p);
    if (!engine_applet_running(p)) startup_pages(f);
    engine_invalidate(p, 0, 0, (int32_t)PORT_W, (int32_t)PORT_H); /* WM_PAINT of the new window */
    engine_render(p);
    core_frame_changed(p);
}

static void start_splash(ShellFrame *f) {
    if (f->phase != SH_WAIT_START) return;
    f->phase = SH_SPLASH;
    timer_init(&f->splash_timer, 0, SH_SPLASH_MS, splash_end, f);
    timer_set_realtime(&f->splash_timer, true);
    timer_start(&f->p->timers, &f->splash_timer);
    splash_compose(f);
}

/* ------------------------------------------------------------------ frame build (Z:0x41d6c0) */

static void cb_about(Port *p, void *ctx, int32_t id) {
    (void)p;
    (void)id;
    sh_about((ShellFrame *)ctx); /* Z:0x41f1e0 -> Z:0x420d80 */
}
static void cb_personalize(Port *p, void *ctx, int32_t id) {
    (void)p;
    (void)id;
    sh_personalize((ShellFrame *)ctx); /* Z:0x41f200 -> Z:0x422b90 */
}
static void cb_view_all(Port *p, void *ctx, int32_t id) {
    (void)p;
    (void)id;
    sh_view_all_games((ShellFrame *)ctx); /* Z:0x41f250 -> Z:0x41f500 */
}
static void cb_help(Port *p, void *ctx, int32_t id) {
    (void)p;
    sh_help((ShellFrame *)ctx, id); /* Z:0x41f1f0 -> Z:0x41c4c0, record +8 = button id 0x65 */
}
static void cb_tos(Port *p, void *ctx, int32_t id) {
    (void)p;
    (void)id;
    sh_tos((ShellFrame *)ctx); /* Z:0x41f290 -> Z:0x41cb20 */
}

/* Z:0x41eac0 (horizontal) and Z:0x41eb50 (vertical) edge tiling: DrawAt per cell; the last partial cell
 * is drawn with Z:0x413f30 into the rest of the edge (source rectangle NULL = whole cell). */
static void tile_h(Image *dst, const Image *src, const DrawRect *cell, int32_t x, int32_t y, int32_t xmax) {
    int32_t cw = cell->r - cell->l, ch = cell->b - cell->t;
    for (; x <= xmax; x += cw) {
        if (xmax - x < cw) {
            DrawRect d = {x, y, xmax + 1, ch + y};
            DrawRect s = {cell->l, cell->t, cell->r, cell->t + RT_MIN(ch, dst->h)};
            draw_blt(dst, &d, src, &s);
        } else {
            DrawRect d = {x, y, x + cw, y + ch};
            draw_blt(dst, &d, src, cell);
        }
    }
}

static void tile_v(Image *dst, const Image *src, const DrawRect *cell, int32_t x, int32_t y, int32_t ymax) {
    int32_t cw = cell->r - cell->l, ch = cell->b - cell->t;
    for (; y <= ymax; y += ch) {
        if (ymax - y < ch) {
            DrawRect d = {x, y, cw + x, ymax + 1};
            DrawRect s = {cell->l, cell->t, cell->r, cell->t + RT_MIN(ch, dst->h)};
            draw_blt(dst, &d, src, &s);
        } else {
            DrawRect d = {x, y, x + cw, y + ch};
            draw_blt(dst, &d, src, cell);
        }
    }
}

static void bevel_edges(ShellFrame *f, Image *root) {
    /* Z:0x41e2b2..0x41e5b0: slb-BevelEdges.gif, cells of 5 x 5 (Z:0x413a00(img, n, 5, 5, -1, -1)): 4 left
     * edge, 5 right edge, 6 top edge, 7 bottom edge, then corners 0 (0, 0), 1 (w-5, 0), 2 (w-5, h-5),
     * 3 (0, h-5). */
    Image *b = NULL;
    uint32_t s = sh_gif(f, "slb-BevelEdges.gif", 0, &b);
    if (b) {
        const int32_t w = root->w, h = root->h;
        DrawRect c[8];
        for (int32_t i = 0; i < 8; i++) c[i] = (DrawRect){5 * i, 0, 5 * i + 5, 5};
        tile_v(root, b, &c[4], 0, 5, h - 5);
        tile_v(root, b, &c[5], w - 5, 5, h - 5);
        tile_h(root, b, &c[6], 5, 0, w - 5);
        tile_h(root, b, &c[7], 5, h - 5, w - 5);
        const int32_t cx[4] = {0, w - 5, w - 5, 0}, cy[4] = {0, 0, h - 5, h - 5};
        for (int32_t i = 0; i < 4; i++) {
            DrawRect d = {cx[i], cy[i], cx[i] + 5, cy[i] + 5};
            draw_blt(root, &d, b, &c[i]);
        }
    }
    sh_release(f, &s);
}

static void build_logo(ShellFrame *f) {
    /* Z:0x41e1bd..0x41e244: img-ZapLogo.gif surface, flags 2 (hover, hand cursor), at (10, 10); click
     * (event 10) -> Z:0x41f1e0 (About page); ZML "<s4><CFFFFFF><u><c>www.ZapSpot.com" (Z:0x434ff8) at
     * (0, 114) into its image. Port: an engine button whose two faces are that image (same look and
     * cursor; the original surface has no hover face). */
    Port *p = f->p;
    Image *logo = NULL;
    uint32_t ls = sh_gif(f, "img-ZapLogo.gif", 0, &logo);
    if (logo) {
        Image im = {0};
        if (sh_image_new(&im, logo->w, logo->h, logo->keyed != 0)) {
            Image raw = *logo;
            raw.keyed = 0;
            draw_blt(&im, NULL, &raw, NULL);
            ZmlContext rc;
            sh_rc_init(f, &rc);
            sh_zml_image(f, &rc, &im, "<s4><CFFFFFF><u><c>www.ZapSpot.com", 0, 0x72, NULL);
            uint32_t fs = engine_surface_blank(p, 2 * logo->w, logo->h, logo->keyed ? ENG_SURF_KEYED : 0u);
            uint32_t fimg = fs ? engine_surface_image(p, fs) : 0;
            Image *faces = sh_img(f, fimg);
            if (faces) {
                im.keyed = 0;
                DrawRect l = {0, 0, logo->w, logo->h}, r = {logo->w, 0, 2 * logo->w, logo->h};
                draw_blt(faces, &l, &im, NULL);
                draw_blt(faces, &r, &im, NULL);
                f->logo = engine_button(p, f->root, 10, 10, logo->w, logo->h, fimg, 0, 0, cb_about, f);
            }
            sh_release(f, &fs);
            sh_image_free(&im);
        }
    }
    sh_release(f, &ls);
}

void shell_frame_build(Port *p) {
    /* Z:0x41d6c0, 800-wide branch (Z:0x41e07c). The engine made the root (cleared #3333cc), ctx[2] and
     * ctx[3] (hidden), the render timer and the protect key. Kept and removed parts: shell.md 3.1. */
    ShellFrame *f = shell_frame_get(p);
    if (!f || f->built || !f->ok) return;
    f->root = engine_root(p);
    f->game = engine_game_surface(p);
    f->page = engine_page_surface(p);
    if (!f->root) return;
    uint32_t root_img = engine_surface_image(p, f->root);
    Image *root = sh_img(f, root_img);
    if (!root) return;
    char buf[SH_STR_MAX];

    /* IMG-GAMEAREA into the shell image at (190, 13) (Z:0x41e0be) */
    Image *ga = NULL;
    uint32_t gs = sh_gif(f, "img-gamearea.gif", 0, &ga);
    if (ga) draw_at(root, ga, 0xbe, 0xd);
    sh_release(f, &gs);

    build_logo(f);

    /* title strip +0x2d4: blank 400 x 24 opaque at (278, 20) (Z:0x41e25b) */
    f->title = engine_surface_blank(p, 0x190, 0x18, 0);
    engine_surface_set_loc(p, f->title, 0x116, 0x14, 0);
    engine_surface_attach(p, f->root, f->title);

    bevel_edges(f, root);

    /* menu items, Arial 12 bold (Z:0x41e5b2..0x41e65b) */
    sh_string(f, 10000, buf, sizeof buf);
    sh_menu_item(f, &f->menu[0], buf, 5, 0x91, true, 0xc, cb_view_all);
    sh_string(f, 10001, buf, sizeof buf);
    sh_menu_item(f, &f->menu[1], buf, 5, 0xb4, false, 0xc, cb_personalize);
    sh_string(f, 10002, buf, sizeof buf);
    sh_menu_item(f, &f->menu[2], buf, 5, 0xd7, false, 0xc, cb_about);

    /* news text str 10003 at (52, 294), rect (52, 294)-(150, 346) (Z:0x41e660) */
    sh_string(f, 10003, buf, sizeof buf);
    GdiRect nr = {0x34, 0x126, 0x96, 0x15a};
    sh_zml_image(f, &f->rc_root, root, buf, 0x34, 0x126, &nr);

    /* Listeners 7, 1, 2 on the shell (Z:0x41e6b9..0x41e703: frame drag, open-hand cursor in the 10-px
     * band): removed, the page is fixed (shell.md 3.1). */

    /* small buttons: help "?" at (705, 9) (Z:0x41e7a2, id 0x65, flags 2); minimise (734, 9) and close
     * (763, 9) removed, blank (decision 8a) */
    sh_imgbtn(f, &f->help, f->root, 0x2c1, 9, 0x1a, 0x1a, "slb-lilbtnbacks-hc.gif", "slb-lilbtnicons.gif", 0, 0x65, "",
              2u, false, cb_help);

    /* rail: pointers cleared, mask 0 (Z:0x41e889..0x41e8bb); built later through SetShellButtons */
    f->mask = 0;
    f->built = true;
    sh_rail(f);

    /* advertiser caption str 10009 at (280, 486): removed with the ad banner (decision 9) */

    /* +0x58..+0x6c images (Z:0x41e8f9..0x41ea15) */
    f->img_err[0] = sh_gif(f, "img-err-red.gif", 0, NULL);
    f->img_err[1] = sh_gif(f, "img-err-green.gif", 0, NULL);
    f->img_err[2] = sh_gif(f, "img-err-blue.gif", 0, NULL);
    f->img_err_arrow = sh_gif(f, "img-err-arrow.gif", 1, NULL);
    f->img_tm = sh_gif(f, "img-tm.gif", 1, NULL);
    f->img_tm2 = sh_gif(f, "img-tm2.gif", 1, NULL);

    /* Z:0x41ed90: subscribe box (IMG-GETZAPPEDBLOCK at (11, 382), str 10004/10005, e-mail edit, arrow
     * button) removed (network, shell.md 3.1); the "installed" branch (the port is always installed,
     * shell.md 1) fills (34, 474)-(194, 522) with #3333CC instead of the offline prompt and the Install
     * link (Z:0x41f16d); then the ToS link str 10008 at (31, 526), Arial 10 bold underline. */
    draw_fill_rect(root, 0x22, 0x1da, 0xc2, 0x20a, IMG_RGB(0x33u, 0x33u, 0xccu));
    sh_string(f, 10008, buf, sizeof buf);
    sh_link_button(f, &f->tos, buf, 0x1f, 0x20e, 0, 10, cb_tos);

    /* ad banner (Z:0x421bf0) at (280, 500): removed; the area keeps the frame colour (decision 9) */
    sh_changed(f, root_img);
}

/* ------------------------------------------------------------------ shell_api.h */

void shell_caption_changed(Port *p, const char *text) {
    /* ISystem::SetCaption Z:0x415f20: copy to +0x88, draw the title strip (Z:0x41b7f0) */
    ShellFrame *f = shell_frame_of(p);
    if (!f) return;
    uint32_t i = 0;
    for (; text && text[i] && i + 1u < sizeof f->caption; i++) f->caption[i] = text[i];
    f->caption[i] = 0;
    if (f->built) sh_title(f, f->caption);
}

void shell_game_in_progress(Port *p, int32_t flag) {
    ShellFrame *f = shell_frame_of(p);
    if (f) f->gip = flag; /* Z:0x41b970: +0x37c */
}

void shell_buttons_changed(Port *p, uint32_t mask) {
    /* Z:0x41b990: +0x378 = mask, then the rail (Z:0x41b9b0). Moeboid calls it inside Shell_StartApplet
     * (G:0x10001729); the engine gives objects made in shell callbacks to the shell (ENG_SHELL_CALL), so
     * the rail buttons survive the next New Game. */
    ShellFrame *f = shell_frame_of(p);
    if (!f) return;
    f->mask = mask;
    sh_rail(f);
}

void shell_pause_toggle(Port *p) {
    ShellFrame *f = shell_frame_of(p);
    if (f && f->built) sh_pause_toggle(f);
    else engine_set_paused(p, !engine_paused(p));
}

void shell_applet_changed(Port *p, bool running) {
    /* Applet manager +0x24 / +0x28 (Z:0x424b00, Z:0x424b20): name and version of the last started game
     * (strings 4 and 3 of the .gam, Z:0x4247bc..0x4247ed); Stop does not clear them. The window title
     * "ZapSpot - <game>" (Z:0x424841) has no port equivalent here (the host owns document.title). */
    ShellFrame *f = shell_frame_of(p);
    if (!f || !running) return;
    sh_string_in(f, "gam", 4, f->game_name, sizeof f->game_name);
    sh_string_in(f, "gam", 3, f->game_version, sizeof f->game_version);
}

/* Proposed shell_api.h additions (engine API request, M4): the engine asks these before it starts the
 * applet in its init hook and before it routes an input event. */
bool shell_starts_applet(Port *p) {
    (void)p;
    return true; /* the shell starts the game after the splash (Z:0x41d6c0 end, decision 13) */
}

bool shell_input_blocked(Port *p) {
    ShellFrame *f = shell_frame_of(p);
    if (!f) return false;
    /* No input reaches the frame while the splash shows (the original runs no message loop during its
     * init) or while a dialog opened by the frame is open (its own modal loop, Z:0x405330, Z:0x405540). */
    return f->phase != SH_RUNNING || shell_modal_active(p);
}

/* ------------------------------------------------------------------ hooks */

static int32_t hook_init(Port *p, const uint8_t *pack, uint32_t pack_len, const uint8_t *gam, uint32_t gam_len) {
    (void)pack;
    (void)pack_len;
    (void)gam;
    (void)gam_len;
    return shell_frame_get(p) ? 0 : -1;
}

static void dialog_cursor(ShellFrame *f) {
    /* Dialog windows set their own cursor (class cursor IDC_ARROW, edit controls IDC_IBEAM); the disabled
     * frame under a modal dialog gets no WM_MOUSEMOVE, so the arrow shows there (inferred). After the
     * dialog the engine cursor comes back. */
    Port *p = f->p;
    bool active = shell_modal_active(p);
    if (active) {
        if (!f->dlg_cursor) f->saved_cursor = p->cursor;
        f->dlg_cursor = true;
        int32_t k = shell_modal_cursor(p, f->mouse_x, f->mouse_y);
        p->cursor = k == DLG_CURSOR_IBEAM ? SH_CURSOR_IBEAM : SH_CURSOR_ARROW;
    } else if (f->dlg_cursor) {
        f->dlg_cursor = false;
        p->cursor = f->saved_cursor;
    }
}

static void hook_input(Port *p, const PortInput *ev) {
    ShellFrame *f = shell_frame_of(p);
    if (!f) return;
    uint32_t k = PORT_IN_KIND(ev->kind);
    if (k == PORT_IN_START) {
        start_splash(f); /* page start done (port-design.md 6, kind 8) */
        return;
    }
    if (k == PORT_IN_MOUSEMOVE || k == PORT_IN_BUTTONDOWN || k == PORT_IN_BUTTONUP) {
        f->mouse_x = ev->a;
        f->mouse_y = ev->b;
    }
    shell_modal_input(p, ev);
    sh_modal_poll(f);
    dialog_cursor(f);
}

static void hook_frame(Port *p) {
    ShellFrame *f = shell_frame_of(p);
    if (!f) return;
    if (f->phase != SH_RUNNING) {
        splash_compose(f); /* over whatever the engine presented */
        return;
    }
    shell_modal_frame(p);
    sh_modal_poll(f);
    dialog_cursor(f);
}

void port_hooks_shell(PortHooks *h) {
    h->name = "shell";
    h->init = hook_init;
    h->input = hook_input;
    h->step = NULL; /* no step hook: the core keeps its step jump (port.h) */
    h->frame = hook_frame;
}

/* ------------------------------------------------------------------ test aids */

void shell_test_set_smoothing(Port *p, int32_t on) {
    /* call between core_init and core_start (the frame is built during core_start) */
    ShellFrame *f = shell_frame_get(p);
    if (!f) return;
    f->smoothing = on ? 1 : 0;
    f->rc_root.smoothing = f->rc_title.smoothing = f->rc_page.smoothing = (uint8_t)f->smoothing;
    if (f->splash_ok) {
        sh_splash_decode(f);
        splash_text(f);
    }
}

int32_t shell_test_last_page(Port *p) {
    ShellFrame *f = shell_frame_of(p);
    return f ? f->last_page : -1;
}

int32_t shell_test_phase(Port *p) {
    ShellFrame *f = shell_frame_of(p);
    return f ? f->phase : -1;
}

static bool btn_point(Port *p, const ShellBtn *b, int32_t ox, int32_t oy, int32_t *x, int32_t *y) {
    (void)p;
    if (!b->s) return false;
    *x = ox + b->x + b->w / 2;
    *y = oy + b->y + b->h / 2;
    return true;
}

bool shell_test_point(Port *p, const char *name, int32_t *x, int32_t *y) {
    ShellFrame *f = shell_frame_of(p);
    if (!f || !name) return false;
    if (name[0] == 'm' && name[1] == 'e' && name[4] >= '0' && name[4] <= '2')
        return btn_point(p, &f->menu[name[4] - '0'], 0, 0, x, y);
    if (!rt_strcmp(name, "help")) return btn_point(p, &f->help, 0, 0, x, y);
    if (!rt_strcmp(name, "tos")) return btn_point(p, &f->tos, 0, 0, x, y);
    if (!rt_strcmp(name, "footer")) return btn_point(p, &f->footer, ENG_GAME_X, ENG_GAME_Y, x, y);
    if (!rt_strcmp(name, "tile0")) return btn_point(p, &f->tile, ENG_GAME_X, ENG_GAME_Y, x, y);
    if (!rt_strcmp(name, "toggle")) return btn_point(p, &f->toggle, ENG_GAME_X, ENG_GAME_Y, x, y);
    if (name[0] == 'l' && name[1] == 'i' && name[2] == 'n' && name[3] == 'k') {
        int32_t id = 0;
        for (const char *c = name + 4; *c >= '0' && *c <= '9'; c++) id = id * 10 + (*c - '0');
        for (int32_t i = 0; i < f->n_link; i++)
            if (f->link_id[i] == id) return btn_point(p, &f->link[i], ENG_GAME_X, ENG_GAME_Y, x, y);
        return false;
    }
    if (!rt_strcmp(name, "logo")) {
        if (!f->logo) return false;
        *x = 10 + 87;
        *y = 10 + 50;
        return true;
    }
    if (name[0] == 'r' && name[1] == 'a' && name[4] >= '0' && name[4] < '0' + SH_RAIL_COUNT) {
        const ShellBtn *b = &f->rail[name[4] - '0'];
        if (!b->s) return false;
        *x = b->x + b->w / 2;
        *y = b->y + 23; /* centre of the 46 x 46 round button */
        return true;
    }
    return false;
}
