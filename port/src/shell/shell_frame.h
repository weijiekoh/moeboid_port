/* ZapSpot platform shell, frame part (milestone M5b): frame, rail, menu pages, splash, pause page,
 * quit flow, shell sounds. The dialog part (M5a) is shell_modal.h; both share Port.shell.
 *
 * Original: CShell (Z:0x41acb0, global DAT_0045cfcc), frame build Z:0x41d6c0 (800-wide branch from
 * Z:0x41e07c), rail Z:0x41b9b0, pages Z:0x41c4c0 / Z:0x41c3f0 / Z:0x41cb30 / Z:0x41f500 / Z:0x420d80 /
 * Z:0x422b90, splash in WinMain Z:0x403d40. Catalogue and port classes: analysis/shell.md 1, 3, 4, 8, 9;
 * pixels: analysis/rendering.md 7, 7.1, 8; decisions: docs/decisions.md 5-9, 13.
 *
 * State layout: struct ShellAll = {struct Shell (M5a, first member), ShellFrame}. The frame part
 * allocates it and stores &all->modal in Port.shell before shell_modal_init runs, so M5a's code sees its
 * own struct and the frame code reaches its part with shell_frame_of(). No static state.
 *
 * Engine interface: src/engine/engine.h and shell_api.h only. Every drawing into an engine image goes
 * through engine_image_pixels + engine_image_changed (Z:0x414120). */
#ifndef MOEBOID_SHELL_SHELL_FRAME_H
#define MOEBOID_SHELL_SHELL_FRAME_H

#include "../core/port.h"
#include "../engine/engine.h"
#include "../engine/shell_api.h"
#include "../gfx/draw.h"
#include "../text/atlas.h"
#include "../text/zml.h"
#include "shell_modal.h"

/* Start-up phases (decision 13, port only). */
enum { SH_WAIT_START = 0, SH_SPLASH = 1, SH_RUNNING = 2 };

/* Flows that wait for IDD_QUIT_SAVED (Z:0x41b4d0). */
enum { SH_PEND_NONE = 0, SH_PEND_NEW_GAME = 1, SH_PEND_VIEW_ALL = 2 };

/* Rail slots: CShell members (Z:0x41b9b0). */
enum {
    SH_RAIL_MAIL = 0,    /* +0x300, bit 0x20, removed: empty slot (decision 7) */
    SH_RAIL_NEW = 1,     /* +0x2fc, bit 0x01 */
    SH_RAIL_PAUSE = 2,   /* +0x304, bit 0x02, not paused */
    SH_RAIL_RESUME = 3,  /* +0x314, bit 0x02, paused */
    SH_RAIL_SCORES = 4,  /* +0x308, bit 0x04 */
    SH_RAIL_HELP = 5,    /* +0x30c, bit 0x10 */
    SH_RAIL_COUNT = 6
};

#define SH_SPLASH_W 400
#define SH_SPLASH_H 240
#define SH_SPLASH_MS 2000u         /* decision 13: about 2 s of virtual time after click-to-start */
#define SH_GAME_FILE "Moeboid.gam" /* platform +0x5c: the game file of the command line (shell.md 7) */
#define SH_STR_MAX 5000            /* LoadStringA buffer of the shell (0x1388) */
/* port_cursor() ids after the six cursors of the cursor manager (gfx/cursor.h): system cursors of the
 * modal dialogs (dialog.h DLG_CURSOR_*); the host maps them to CSS "default" and "text" (placeholders:
 * no Windows XP cursor file in the project). */
#define SH_CURSOR_ARROW 6u
#define SH_CURSOR_IBEAM 7u

/* One engine button made by the shell, with its rectangle in parent coordinates (GetLoc, GetSize). */
typedef struct ShellBtn {
    uint32_t s;       /* engine surface handle, 0 = none */
    int32_t x, y, w, h;
} ShellBtn;

typedef struct ShellFrame {
    Port *p;
    bool loaded;              /* resource loading tried (Port.pack set) */
    bool ok;                  /* pack and fonts loaded */
    MPack pack;
    TextFonts fonts;
    int32_t smoothing;        /* decision 4b (1); tests set 0 for the monochrome Wine references */

    /* start-up (decision 13) */
    int32_t phase;            /* SH_* */
    EngineTimer splash_timer; /* SH_SPLASH_MS, run while paused */
    bool splash_ok;
    uint32_t splash_px[SH_SPLASH_W * SH_SPLASH_H];
    bool built;               /* shell_frame_build ran */
    bool first_render;        /* DAT_00434d80: Z:0x41b170 loaded the shell sounds */

    /* engine objects */
    uint32_t root, game, page;          /* CShell, +0x2c8 (ctx[2]), +0x2cc (ctx[3]) */
    uint32_t title;                     /* +0x2d4 title strip 400x24 */
    uint32_t logo;                      /* +0x2d8 logo (button with two equal faces) */
    ShellBtn menu[3];                   /* View All Games, Personalize, About (Z:0x41d370) */
    ShellBtn help;                      /* "?" button (705, 9) */
    ShellBtn rail[SH_RAIL_COUNT];
    ShellBtn tos;                       /* +0x2c4 ToS link (Z:0x41ebe0) */
    ShellBtn footer;                    /* arrow of the paused footer (Z:0x41b290), child of ctx[3] */
    ShellBtn tile;                      /* Moeboid tile of View All Games (Z:0x423d10), child of ctx[3] */
    ShellBtn toggle;                    /* Personalize "Toggle" button, child of ctx[3] */
    uint32_t page_kids[48];             /* other ctx[3] children made by the shell (released at clear) */
    int32_t n_page_kids;
    ShellBtn link[24];                  /* active hyperlinks of the page (CHyperLink Z:0x4184e0) */
    int32_t link_id[24];
    int32_t n_link;
    uint32_t img_tm, img_tm2;           /* +0x64 img-tm.gif, +0x68 img-tm2.gif (surfaces, not attached) */
    uint32_t img_err[3];                /* +0x58 red, +0x5c green, +0x60 blue */
    uint32_t img_err_arrow;             /* +0x6c */

    /* render contexts (persistent ZML state per image, fonts.md 5) */
    ZmlContext rc_root, rc_title;
    ZmlContext rc_page;       /* shell copy of the ctx[3] state, for link rectangles (pixels: engine_image_zml) */
    uint32_t *scratch_px;     /* 500 x 420 layout target of rc_page */

    /* CShell fields */
    char caption[256];        /* +0x88 */
    uint32_t mask;            /* +0x378 */
    int32_t gip;              /* +0x37c game in progress */
    int32_t game_index;       /* DAT_0045dfdc */
    char game_name[64];       /* applet manager +0x24 (help page 118) */
    char game_version[32];    /* applet manager +0x28 */
    bool vag_first;           /* DAT_004351b4: the first View All Games plays no click */
    bool new_game_click;      /* DAT_00434e70 == 0: never true (initial value 1, no writer) */

    /* quit flow (Z:0x41b4d0) waiting for IDD_QUIT_SAVED */
    int32_t pending;          /* SH_PEND_* */
    int32_t pending_id;
    bool pending_paused0;     /* IsPaused before the check */

    /* cursor over a modal dialog (port ids SH_CURSOR_*, host/main.ts) */
    bool dlg_cursor;          /* a dialog was open at the last input */
    uint32_t saved_cursor;    /* engine cursor before the dialog */
    int32_t mouse_x, mouse_y; /* last pointer position (frame) */

    /* test aids */
    uint32_t pages_shown;     /* count of page draws */
    int32_t last_page;        /* string id of the last page title */
} ShellFrame;

typedef struct ShellAll {
    struct Shell modal;       /* M5a part, must stay first (Port.shell points here) */
    ShellFrame f;
} ShellAll;

ShellFrame *shell_frame_of(Port *p);  /* NULL before the shell state exists */
ShellFrame *shell_frame_get(Port *p); /* creates the state when needed */

/* ---- shell_res.c: resources and drawing helpers */
int32_t sh_string(const ShellFrame *f, uint32_t id, char *out, uint32_t cap); /* LoadStringA, Z:0x404b70 */
int32_t sh_string_in(const ShellFrame *f, const char *module, uint32_t id, char *out, uint32_t cap); /* "zap", "gam" */
int32_t sh_splash_decode(ShellFrame *f);   /* IMG-SPLASH (BI_RLE8) into f->splash_px */
Image *sh_img(ShellFrame *f, uint32_t img);
void sh_changed(ShellFrame *f, uint32_t img);
/* DrawZML Z:0x413c90 with the render context rc (rect NULL = whole image); links drawn inert. */
int32_t sh_zml(ShellFrame *f, ZmlContext *rc, uint32_t img, const char *text, int32_t x, int32_t y, const GdiRect *rect);
int32_t sh_zml_image(ShellFrame *f, ZmlContext *rc, Image *dst, const char *text, int32_t x, int32_t y,
                     const GdiRect *rect);
/* MeasureText with the render context font (Z:0x414050) or with an explicit font (Z:0x414030). */
void sh_measure_rc(const ZmlContext *rc, const char *s, int32_t *cx, int32_t *cy);
void sh_measure_font(ShellFrame *f, const char *face, int32_t px, uint32_t style, const char *s, int32_t *cx,
                     int32_t *cy);
/* Temporary keyed or opaque pixel buffer (render target Z:0x40b950: key or black). */
bool sh_image_new(Image *im, int32_t w, int32_t h, bool keyed);
void sh_image_free(Image *im);
/* Image of a GIF surface (frame 0); the caller keeps the surface handle. */
uint32_t sh_gif(ShellFrame *f, const char *name, uint32_t flags, Image **out);
void sh_release(ShellFrame *f, uint32_t *h);
void sh_rc_init(ShellFrame *f, ZmlContext *rc);

/* ---- shell_rail.c: buttons and rail */
/* Z:0x42b990 image button. flags: 1 caption under the button, 2 back cell 3 for the normal face,
 * 4 caption centred in the button. toggled: Z:0x42c2d0(1) (normal face = back cell 1). */
void sh_imgbtn(ShellFrame *f, ShellBtn *b, uint32_t parent, int32_t x, int32_t y, int32_t w, int32_t h,
               const char *backs, const char *icons, int32_t icon, int32_t id, const char *label, uint32_t flags,
               bool toggled, EngineButtonFn cb);
void sh_btn_remove(ShellFrame *f, ShellBtn *b, uint32_t parent);
void sh_rail(ShellFrame *f);            /* Z:0x41b9b0 */
void sh_menu_item(ShellFrame *f, ShellBtn *b, const char *text, int32_t x, int32_t y, bool home, int32_t px,
                  EngineButtonFn cb);   /* Z:0x41d370 */
void sh_link_button(ShellFrame *f, ShellBtn *b, const char *text, int32_t x, int32_t y, int32_t id, int32_t px,
                    EngineButtonFn cb); /* Z:0x41ebe0 */

/* ---- shell_pages.c: pages and flows */
void sh_title(ShellFrame *f, const char *text);        /* Z:0x41b7f0 */
void sh_pause_toggle(ShellFrame *f);                   /* Z:0x41cb30 */
void sh_footer(ShellFrame *f);                         /* Z:0x41b290 */
void sh_back_to_game(ShellFrame *f);                   /* Z:0x41b430 */
void sh_how_to_play(ShellFrame *f);                    /* Z:0x41c3f0 */
void sh_help(ShellFrame *f, int32_t id);               /* Z:0x41c4c0 */
void sh_about(ShellFrame *f);                          /* Z:0x420d80 */
void sh_personalize(ShellFrame *f);                    /* Z:0x422b90 */
void sh_sound_toggle(ShellFrame *f);                   /* Z:0x423260 */
void sh_view_all_games(ShellFrame *f);                 /* Z:0x41f500 */
void sh_new_game(ShellFrame *f, int32_t id);           /* Z:0x41c910 */
void sh_tos(ShellFrame *f);                            /* Z:0x41cb20 */
void sh_modal_poll(ShellFrame *f);                     /* result of IDD_QUIT_SAVED / ToS */
void sh_page_clear(ShellFrame *f);                     /* Z:0x413e80 + Z:0x414950 on ctx[3] */
void sh_show_page(ShellFrame *f);                      /* ctx[2] hidden, ctx[3] shown */
void sh_click(ShellFrame *f);                          /* shell +0x80 BtnClick Play(0) */
void sh_page_release_kids(ShellFrame *f);              /* after Z:0x414950 on ctx[3] */

/* ---- test aids (native tests) */
void shell_test_set_smoothing(Port *p, int32_t on);
int32_t shell_test_phase(Port *p);
int32_t shell_test_last_page(Port *p); /* string id of the last page title shown, -1 none */
/* Button point (frame coordinates) of a shell element: "menu0".."menu2", "help", "rail1".."rail5",
 * "tos", "footer", "logo", "tile0". Returns false when the element does not exist. */
bool shell_test_point(Port *p, const char *name, int32_t *x, int32_t *y);

#endif
