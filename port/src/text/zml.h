/* Engine ZML text renderer: reimplementation of Z:0x416190 (analysis/fonts.md 5 and 6; port-design.md 8).
 *
 * The original is a thiscall method of the render context (vtable 0x42eaa4) with the stack arguments
 * (x, y, rect, flags, text, len, parent, owner, callback); DrawZML Z:0x413c90 passes len = strlen(text) and
 * rect = {0, 0, target width, target height} when rect is NULL. It returns 0, or 0x15 when the text holds
 * '&' (nothing is drawn then). DrawZML itself always returns 0. The original has no measure-only mode
 * (flags bit 0 = plain text is the only flag it reads, Z:0x4161c2).
 *
 * ZmlContext holds the render-context state that persists between calls (fonts.md 5): font (face, px,
 * style), text colour, centre, shadow and T (transparent) flags, line maximum. The caller owns one
 * ZmlContext per render context (per surface) and keeps it alive as long as the surface.
 *
 * Coordinates are target (surface) pixels. Hyperlinks (<A>) are not drawn into the target by the original:
 * Z:0x416a62 creates a CHyperLink child surface (Z:0x4184e0) at the link rectangle, which draws its own ZML
 * string. zml_draw reports each link to a ZmlLinkSink; zml_link_draw draws it as CHyperLink does.
 * Integer arithmetic only. No allocation. Text is cp1252 bytes. */
#ifndef PORT_TEXT_ZML_H
#define PORT_TEXT_ZML_H

#include <stdint.h>
#include "../gfx/image.h"
#include "atlas.h"
#include "gdi_text.h"

#define ZML_OK 0
#define ZML_ERR_CHAR 0x15        /* Z:0x4163e1: "Unhandled character (%c) in ZML string" ('&' or '%') */
#define ZML_ERR_TOKENS (-1)      /* port only: more than ZML_MAX_TOKENS tokens (the original overflows its stack) */

#define ZML_PLAIN 1u             /* flags bit 0: the whole text is one text token, no tags (Z:0x4161c2) */

#define ZML_MAX_TOKENS 1024      /* original: about 610 on the stack, no bound check (Z:0x4161a1) */
#define ZML_FACE_MAX 32          /* LOGFONT lfFaceName size */

/* Font style bits of the engine font object (+0x28, fonts.md 3.1). Italic and strikeout have no atlas:
 * italic is ignored (no kept string draws italic text, fonts.md 8.3). */
#define ZML_BOLD 1u
#define ZML_ITALIC 2u
#define ZML_UNDERLINE 4u
#define ZML_STRIKEOUT 8u

/* Engine font object (Z:0x427c10, 0x30 bytes): the result of CreateFont(face, px, style). */
typedef struct ZmlFont {
    char face[ZML_FACE_MAX];     /* +0x1c */
    int32_t px;                  /* +0x20: lfHeight = -px */
    int32_t index;               /* +0x24: always 0 for px >= 0 (loop at Z:0x427d2b, fonts.md 3.1) */
    uint32_t style;              /* +0x28 */
    int32_t line_height;         /* +0x10: tmHeight + tmExternalLeading */
    int32_t space_w;             /* +0x14: GetTextExtentPoint32A(" ") */
    int32_t dot_w;               /* +0x18: GetTextExtentPoint32A(".") */
    int32_t ok;                  /* port: 1 if an atlas exists for (face, px, weight) */
    GdiFont gdi;                 /* +0x2c HFONT */
} ZmlFont;

/* One DrawText call of the renderer (render target vtable +0x3c, Z:0x42a250 / Z:0x40c110). For tests
 * and diagnostics; target coordinates, before clipping. */
#define ZML_DRAW_TEXT 0
#define ZML_DRAW_SHADOW 1        /* black copy at (+1, +1), Z:0x416b45 */
#define ZML_DRAW_ELLIPSIS 2      /* "..." of the <E> mode, Z:0x416877 */
typedef struct ZmlDrawInfo {
    int32_t x, y;
    const char *s;
    int32_t n;
    uint32_t color;              /* Image pixel */
    const ZmlFont *font;
    int32_t kind;
} ZmlDrawInfo;

typedef struct ZmlContext {
    const TextFonts *fonts;
    ZmlFont font;                /* rc+0x28: current font, initial Arial 18 regular (Z:0x413979) */
    uint32_t text_color;         /* target text colour (Z:0x429d50), Image pixel; initial white (Z:0x4139a4) */
    uint32_t bk_color;           /* target background colour, used only when T = 0 (inferred initial: black) */
    uint8_t transparent;         /* rc+0x1d T flag, initial 1 (Z:0x41399d) */
    uint8_t centre;              /* rc+0x24, initial 0 */
    uint8_t shadow;              /* rc+0x25, initial 0 */
    uint8_t smoothing;           /* decision 4b: grey atlases where gasp allows them */
    int32_t line_max;            /* rc+0x20: reset to 0 at each call (Z:0x416213) */
    /* Results of the last zml_draw call. Port extras: the original keeps x and y local. */
    int32_t out_x, out_y;        /* layout position after the last token */
    int32_t end_x, end_y;        /* DAT_0045dfc0 / DAT_0045dfc4: end of the last drawn text (no engine reader) */
    int32_t nlinks;              /* links created */
    int32_t missing_fonts;       /* port: font requests without an atlas (nothing drawn, extent 0) */
    /* Optional hook, called for every DrawText call (NULL: none). */
    void (*on_draw)(void *user, const ZmlDrawInfo *d);
    void *on_draw_user;
} ZmlContext;

/* CHyperLink child created for a link token that fits on the line (Z:0x416a60..0x416aa9). */
typedef struct ZmlLink {
    int32_t x, y;                /* centre ? (rect.right - cx - rect.left) / 2 : x (cx in the current font), line y */
    int32_t w, h;                /* width of the text in (face, 12 px, current style) + its space width; height + 2 */
    int32_t id;                  /* link id from <Annnnn>; -1 if none was parsed (Z:0x41620c) */
    const char *text;            /* the token text, inside the caller's string (valid during zml_draw) */
    int32_t len;
} ZmlLink;

typedef struct ZmlLinkSink {
    void (*add)(void *user, const ZmlLink *link);   /* may be NULL */
    void *user;
    uint8_t draw;                /* 1: zml_draw also draws every link (normal state) on top at the end of the call */
} ZmlLinkSink;

/* Render context constructor defaults (Z:0x4138f0, Z:0x413a00). */
void zml_context_init(ZmlContext *c, const TextFonts *fonts, int32_t smoothing);

/* CreateFont(face, px, style) of the font subsystem (Z:0x426070 / Z:0x427c10). Unknown faces map to Arial
 * (GDI font mapper substitution, inferred). */
void zml_font_create(ZmlFont *f, const TextFonts *fonts, const char *face, int32_t px, uint32_t style);

/* Z:0x416190. dst = the render target (surface) image. text[0..len) is the string; the byte at len is taken
 * as the NUL terminator (callers of the original pass len = strlen). rect NULL = {0, 0, dst->w, dst->h}
 * (Z:0x413cc5). links NULL: links are drawn in their normal state on top of the text at the end of the call.
 * Returns ZML_OK, ZML_ERR_CHAR (the tokenizer fails before the layout starts: nothing drawn, no state changed)
 * or ZML_ERR_TOKENS (same). */
int32_t zml_draw(ZmlContext *c, Image *dst, const char *text, int32_t len, int32_t x, int32_t y,
                 const GdiRect *rect, uint32_t flags, const ZmlLinkSink *links);

/* Draw one link as CHyperLink does (Z:0x4184e0, 0x4187a0 hover, 0x4187f0 normal): a new render context on a
 * keyed link.w x link.h surface at (link.x, link.y) of dst draws "<T><S3><U><SH><C><CFFFFFF>" text
 * "</C></SH></U>" (normal) or "<T><S3><U><C><Sh><CFFF000>" text "</C></sh></U>" (hover): Arial 12 regular
 * underlined, black shadow at (+1, +1), centred in the link surface. Only glyph pixels change in dst
 * (keyed surface). Returns the zml_draw result. */
int32_t zml_link_draw(const TextFonts *fonts, Image *dst, const ZmlLink *link, int32_t hover, int32_t smoothing);

#endif
