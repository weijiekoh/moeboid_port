/* Windows XP Luna (blue, normal size) non-client frame for the native dialogs and the MessageBox
 * (decision 4a, orchestrator decision O1; workstream LUNA, phase 2).
 *
 * ZapSpot.exe has no manifest, so on XP only the non-client area (caption, border, caption buttons)
 * uses the visual style; the client area and its controls are classic and use the Luna system colours
 * (luna_color). Data: pack entry "data/luna/NORMALBLUE", built by port/tools/mkluna.py from
 * fonts/luna.msstyles (format and verified/inferred status: port/tools/README.md, section "Luna").
 *
 * Window layout for a ZapSpot dialog (DS_MODALFRAME | WS_CAPTION | WS_POPUP, no WS_THICKFRAME):
 *   border left/right/bottom = LUNA_DLG_FRAME (3, inferred: SM_CXFIXEDFRAME, the theme does not
 *   change it); top = 3 + SM_CYCAPTION; SM_CYCAPTION = CaptionBarHeight (25, verified INI) + 1
 *   (inferred: iCaptionHeight + SM_CYBORDER) = 26; top = 29 = height of one BLUE_FRAMECAPTION_BMP
 *   state image (verified: 66x58, ImageCount 2).
 * No ZapSpot dialog template has WS_SYSMENU (styles 0x80C008C0 and 0x90C00840, dialogs.json), so
 * they have no close button. A MessageBox has one (MB_OK: enabled).
 *
 * Destination: M3's Image (src/gfx/image.h, pixel 0xAABBGGRR = bytes R, G, B, A). Caption text: M3's
 * GDI text output (src/text/gdi_text.h). No floating point, no allocation, no static state: a
 * LunaTheme lives in the caller's state (Port struct). */
#ifndef MOEBOID_SHELL_LUNA_H
#define MOEBOID_SHELL_LUNA_H

#include "../rt/rt.h"
#include "../gfx/image.h"
#include "../text/gdi_text.h"

/* System colour indices = Windows COLOR_* values. */
#define LUNA_COLOR_SCROLLBAR 0                /* inferred 212 208 200 (not in [SysMetrics]) */
#define LUNA_COLOR_BACKGROUND 1
#define LUNA_COLOR_ACTIVECAPTION 2
#define LUNA_COLOR_INACTIVECAPTION 3
#define LUNA_COLOR_MENU 4
#define LUNA_COLOR_WINDOW 5
#define LUNA_COLOR_WINDOWFRAME 6              /* inferred 0 0 0 */
#define LUNA_COLOR_WINDOWTEXT 8               /* inferred 0 0 0 */
#define LUNA_COLOR_CAPTIONTEXT 9
#define LUNA_COLOR_HIGHLIGHT 13
#define LUNA_COLOR_HIGHLIGHTTEXT 14
#define LUNA_COLOR_3DFACE 15                  /* COLOR_BTNFACE */
#define LUNA_COLOR_3DSHADOW 16                /* COLOR_BTNSHADOW */
#define LUNA_COLOR_GRAYTEXT 17
#define LUNA_COLOR_BTNTEXT 18                 /* inferred 0 0 0 */
#define LUNA_COLOR_INACTIVECAPTIONTEXT 19
#define LUNA_COLOR_3DHILIGHT 20               /* COLOR_BTNHIGHLIGHT */
#define LUNA_COLOR_3DDKSHADOW 21
#define LUNA_COLOR_3DLIGHT 22
#define LUNA_COLOR_GRADIENTACTIVECAPTION 27
#define LUNA_COLOR_GRADIENTINACTIVECAPTION 28
#define LUNA_COLOR_MENUHILIGHT 29
#define LUNA_COLOR_MENUBAR 30
#define LUNA_COLOR_CAPTION_SHADOW 64          /* [Window] TextShadowColor */
#define LUNA_COLOR_DIALOG_FILL 65             /* [Window.dialog] FillColor (themed dialogs only) */
#define LUNA_COLOR_COUNT 66

/* Where a value comes from (data blob source byte). */
#define LUNA_SRC_INFERRED 0
#define LUNA_SRC_SYSMETRICS 1   /* NORMALBLUE_INI [SysMetrics] (verified) */
#define LUNA_SRC_INI 2          /* another NORMALBLUE_INI section (verified) */
#define LUNA_SRC_NONE 0xFF      /* not in the data */

/* Metric ids (data blob). Font face ids: 1 Tahoma, 2 Trebuchet MS, 3 Franklin Gothic Medium. */
#define LUNA_M_CAPTION_BAR_HEIGHT 0
#define LUNA_M_SMCAPTION_BAR_HEIGHT 1
#define LUNA_M_SMCAPTION_BAR_WIDTH 2
#define LUNA_M_SCROLLBAR_WIDTH 3
#define LUNA_M_SCROLLBAR_HEIGHT 4
#define LUNA_M_CAPTION_FONT_FACE 5
#define LUNA_M_CAPTION_FONT_PT 6
#define LUNA_M_CAPTION_FONT_WEIGHT 7
#define LUNA_M_SMCAPTION_FONT_FACE 8
#define LUNA_M_SMCAPTION_FONT_PT 9
#define LUNA_M_SMCAPTION_FONT_WEIGHT 10
#define LUNA_M_MSGBOX_FONT_FACE 11
#define LUNA_M_MSGBOX_FONT_PT 12
#define LUNA_M_MSGBOX_FONT_WEIGHT 13
#define LUNA_M_SHADOW_DX 14
#define LUNA_M_SHADOW_DY 15
#define LUNA_M_SHADOW_ACTIVE 16     /* caption text shadow type: 0 none, 1 single, 2 continuous */
#define LUNA_M_SHADOW_INACTIVE 17
#define LUNA_METRIC_COUNT 18
#define LUNA_FACE_TAHOMA 1
#define LUNA_FACE_TREBUCHET 2

/* Parts (data blob part ids). */
#define LUNA_PART_CAPTION 1
#define LUNA_PART_FRAMELEFT 2
#define LUNA_PART_FRAMERIGHT 3
#define LUNA_PART_FRAMEBOTTOM 4
#define LUNA_PART_CLOSEBUTTON 5
#define LUNA_PART_COUNT 6
#define LUNA_IMAGE_MAX 16

#define LUNA_SIZING_STRETCH 0
#define LUNA_SIZING_TILE 1
#define LUNA_SIZING_TRUESIZE 2

/* Close button states (uxtheme CBS_*). Inactive window: image index state - 1 + 4 (inferred from
 * the 8 images of BLUE_CLOSEBUTTON_BMP: images 5..8 are the faded versions of 1..4). */
#define LUNA_BTN_NORMAL 1
#define LUNA_BTN_HOT 2
#define LUNA_BTN_PUSHED 3
#define LUNA_BTN_DISABLED 4

#define LUNA_DLG_FRAME 3  /* SM_CXFIXEDFRAME = SM_CYFIXEDFRAME (inferred, XP value) */

/* Error codes of luna_load. */
#define LUNA_OK 0
#define LUNA_E_SHORT (-1)
#define LUNA_E_MAGIC (-2)
#define LUNA_E_VERSION (-3)
#define LUNA_E_RANGE (-4)
#define LUNA_E_PART (-5)

typedef struct LunaRect {
    int32_t x, y, w, h;
} LunaRect;

typedef struct LunaBitmap {
    const uint8_t *rgba; /* points into the blob; straight alpha; colour-key pixels have alpha 0 */
    uint16_t w, h;
    uint16_t flags; /* bit0: 32-bit source with alpha; bit1: colour key applied */
} LunaBitmap;

typedef struct LunaPart {
    bool present;
    uint16_t image, glyph; /* indices into LunaTheme.image; 0xFFFF = none */
    uint8_t image_count, glyph_count, sizing_type, layout, flags, offset_type;
    int16_t sizing[4];  /* SizingMargins: left, right, top, bottom */
    int16_t content[4]; /* ContentMargins */
    int16_t caption[4]; /* CaptionMargins */
    int16_t offset[2];  /* Offset x, y */
    uint32_t fill;      /* FillColorHint 0xRRGGBB */
} LunaPart;

typedef struct LunaTheme {
    bool loaded;
    uint32_t color[LUNA_COLOR_COUNT]; /* 0xRRGGBB */
    uint8_t color_src[LUNA_COLOR_COUNT];
    int32_t metric[LUNA_METRIC_COUNT];
    uint8_t metric_src[LUNA_METRIC_COUNT];
    LunaPart part[LUNA_PART_COUNT];
    LunaBitmap image[LUNA_IMAGE_MAX];
    uint16_t n_images;
} LunaTheme;

/* Window geometry, window-relative (0, 0 = outer top-left corner). */
typedef struct LunaGeom {
    int32_t win_w, win_h;
    int32_t frame;    /* left, right and bottom border width */
    int32_t top;      /* top border + caption = client.y */
    int32_t caption_h; /* SM_CYCAPTION */
    LunaRect client;
    LunaRect caption; /* caption part: (0, 0, win_w, top) */
    LunaRect text;    /* caption text rectangle (single line, left, vertically centred) */
    LunaRect close;   /* close button; w = h = 0 when there is none */
} LunaGeom;

typedef struct LunaWindow {
    int32_t client_w, client_h;
    bool active;
    bool close_button;   /* window has WS_SYSMENU (MessageBox); false for every ZapSpot dialog */
    uint8_t close_state; /* LUNA_BTN_* */
    const char *caption; /* cp1252 bytes */
    int32_t caption_len; /* < 0: NUL-terminated */
} LunaWindow;

/* Parse the data blob (pack entry data/luna/NORMALBLUE). The theme keeps pointers into blob: the
 * blob must stay alive. Returns LUNA_OK or a LUNA_E_* code (theme->loaded = false). */
int luna_load(LunaTheme *t, const uint8_t *blob, uint32_t len);

/* System colour 0xRRGGBB for a LUNA_COLOR_* index; 0 when absent. *src (optional) gets LUNA_SRC_*. */
uint32_t luna_color(const LunaTheme *t, int32_t index, uint8_t *src);
/* The same colour as an opaque Image pixel (IMG_RGB), for gfx/ fills and GdiTextState colours. */
uint32_t luna_pixel(const LunaTheme *t, int32_t index);

/* Metric value for a LUNA_M_* id; 0 when absent. */
int32_t luna_metric(const LunaTheme *t, int32_t id);

/* Font height in pixels at 96 dpi for a point size: MulDiv(pt, 96, 72) (10 pt = 13 px, 8 pt = 11 px). */
int32_t luna_font_px(int32_t points);

/* Geometry of a dialog window with the given client size. */
void luna_geom(const LunaTheme *t, int32_t client_w, int32_t client_h, bool close_button, LunaGeom *g);

/* Draw the whole window with its outer top-left corner at (x, y) of dst: client area filled with
 * COLOR_3DFACE, caption, left/right/bottom frame, close button with glyph (if close_button), caption
 * text. The 12 colour-key pixels in each rounded top corner are not written (XP clips them with the
 * window region). Clipped to dst. Fills *g when g != NULL.
 * caption_font: the caption font selected by the caller, gdi_font_select(&f, fonts, "Trebuchet MS",
 * -luna_font_px(luna_metric(t, LUNA_M_CAPTION_FONT_PT)), luna_metric(t, LUNA_M_CAPTION_FONT_WEIGHT), 0, 0)
 * (pack atlas TREBUCHETMS-13-700); NULL draws no text. smoothing: decision 4b (1 = standard). */
void luna_draw_window(const LunaTheme *t, Image *dst, int32_t x, int32_t y, const LunaWindow *w,
                      const GdiFont *caption_font, uint8_t smoothing, LunaGeom *g);

/* Caption text as DrawText DT_SINGLELINE | DT_END_ELLIPSIS would show it in max_w pixels: copies s
 * (or the longest prefix that fits with "...", plus "...") to out (no NUL) and returns its length.
 * out_size >= 4. Inferred rule (no Windows ground truth). */
int32_t luna_fit_ellipsis(const GdiFont *f, const char *s, int32_t n, int32_t max_w, char *out, int32_t out_size);

/* Draw state image `state` (0-based) of a part image into the rectangle r of dst (nine-grid with the
 * part's SizingMargins; clipped to dst). glyph: the part's glyph image at true size, centred in r.
 * Exposed for tests and for other themed parts. */
void luna_draw_part(const LunaTheme *t, Image *dst, int32_t part_id, bool glyph, int32_t state, const LunaRect *r);

#endif
