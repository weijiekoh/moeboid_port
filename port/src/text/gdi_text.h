/* GDI text output for the port (analysis/fonts.md 4 and 10.5; decisions 4b, O6).
 *
 * Model: ExtTextOutA(hdc, x, y, options, rect, str, len, lpDx = NULL) with TA_TOP|TA_LEFT, MM_TEXT and
 * no extra spacing (SetTextAlign, SetMapMode, SetTextCharacterExtra are not imported, fonts.md 4).
 * Pen starts at (x, y + tmAscent); per byte: draw the glyph, pen x += advance; no kerning.
 * TRANSPARENT: glyph pixels only. OPAQUE: first fill the cell (x .. x + extent, y .. y + tmHeight)
 * with the background colour. Underline: rows baseline + ul_offset .. + ul_thickness - 1 across the
 * extent, in the text colour (rounding inferred). Mono atlases set glyph pixels to the text colour.
 * Grey atlases (smoothing on and gasp allows grey at this size) blend the text colour over the
 * destination: c = (dst * (16 - v) + text * v + 8) >> 4 per channel, alpha 255 (O6, unproven).
 * Colours are Image pixels: a COLORREF 0x00BBGGRR with 0xFF000000 added.
 */
#ifndef PORT_TEXT_GDI_TEXT_H
#define PORT_TEXT_GDI_TEXT_H

#include <stdint.h>
#include "../gfx/image.h"
#include "atlas.h"

#define GDI_TRANSPARENT 1
#define GDI_OPAQUE 2
#define GDI_ETO_OPAQUE 0x0002u
#define GDI_ETO_CLIPPED 0x0004u

typedef struct GdiRect {
    int32_t left, top, right, bottom;   /* right and bottom exclusive */
} GdiRect;

typedef struct GdiFont {                /* HFONT equivalent */
    const TextAtlas *mono;              /* never NULL after gdi_font_select */
    const TextAtlas *gray;              /* NULL if gasp forbids grey at this size or no grey atlas */
    uint8_t underline, strikeout;
} GdiFont;

typedef struct GdiTextState {           /* DC state that text output reads */
    uint32_t text_color;                /* SetTextColor */
    uint32_t bk_color;                  /* SetBkColor */
    int32_t bk_mode;                    /* SetBkMode: GDI_TRANSPARENT or GDI_OPAQUE */
    uint8_t smoothing;                  /* "Smooth edges of screen fonts" (decision 4b: on) */
} GdiTextState;

typedef struct GdiTextMetrics {
    int32_t tmHeight, tmAscent, tmDescent, tmInternalLeading, tmExternalLeading, tmAveCharWidth, tmMaxCharWidth;
} GdiTextMetrics;

/* CreateFontIndirectA + font mapping for the requests of fonts.md 3: lf_height < 0 selects the em height
 * -lf_height; lf_height > 0 selects the atlas whose tmHeight equals it. lf_weight 0 means 400; weights
 * >= 550 select the bold atlas (700). Returns 0, or -1 if no atlas matches (no size substitution). */
int32_t gdi_font_select(GdiFont *f, const TextFonts *tf, const char *face, int32_t lf_height, int32_t lf_weight,
                        int32_t underline, int32_t strikeout);

/* Atlas used for drawing: grey when smoothing is on and the font has a grey atlas, else mono. */
const TextAtlas *gdi_font_atlas(const GdiFont *f, int32_t smoothing);

void gdi_get_text_metrics(const GdiFont *f, GdiTextMetrics *tm);

/* GetTextExtentPoint32A: cx = sum of advances, cy = tmHeight (also for n = 0, inferred). */
void gdi_get_text_extent_point32(const GdiFont *f, const char *s, int32_t n, int32_t *cx, int32_t *cy);

/* ExtTextOutA. options: GDI_ETO_CLIPPED (clip to rc), GDI_ETO_OPAQUE (fill rc with the background colour).
 * rc may be NULL (then both options are ignored). Drawing is also clipped to the image. Returns 1. */
int32_t gdi_ext_text_out(Image *dst, int32_t x, int32_t y, uint32_t options, const GdiRect *rc,
                         const char *s, int32_t n, const GdiFont *f, const GdiTextState *st);

#endif
