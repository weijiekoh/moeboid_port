/* Draw operations of the engine render target (M4; analysis/rendering.md 6.1, 4).
 *
 * Model of the DirectDraw render target of ZapSpot.exe (vtable Z:0x42e790, ctor Z:0x40b950). Every
 * drawing operation of the game reaches one of these functions. Pixels: Image (gfx/image.h).
 * Colour key: a keyed source image is drawn with DDBLT_KEYSRC, the key is magenta (255, 0, 255)
 * (rendering.md 4). The key test compares the RGB of a pixel only, so IMG_KEY pixels of the GIF
 * decoder and magenta drawn by FillRect/Clear are both transparent, as on Windows (verified rule:
 * DirectDraw source colour key low = high = 0xff00ff on a 32-bit desktop, Z:0x4086d0).
 * Coordinates are signed; every operation clips to the image. No allocation. */
#ifndef PORT_GFX_DRAW_H
#define PORT_GFX_DRAW_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include "image.h"

/* Rectangle {left, top, right, bottom}, right and bottom exclusive (Win32 RECT). */
typedef struct DrawRect {
    int32_t l, t, r, b;
} DrawRect;

/* Blt result codes of Z:0x40bf70. */
#define DRAW_OK 0
#define DRAW_E_BLT 100000 /* "Error occurred in call to Blt" (DDERR_INVALIDRECT and similar) */

static inline bool draw_is_key(uint32_t px) { return (px & 0x00ffffffu) == 0x00ff00ffu; }

/* GDI FillRect with a solid brush: [l, r) x [t, b), clipped to the image. Z:0x40bc60 draws only
 * when t <= b and l <= r; GDI itself draws nothing for an empty rectangle. */
void draw_fill_rect(Image *dst, int32_t l, int32_t t, int32_t r, int32_t b, uint32_t color);

/* Z:0x40be30 ClearToColor: FillRect of the whole image. */
void draw_clear(Image *dst, uint32_t color);

/* Z:0x40baf0 Line: endpoint clamping of the original, then GDI MoveToEx/LineTo with a 1-pixel
 * PS_SOLID pen (end point not drawn). */
void draw_line(Image *dst, int32_t x1, int32_t y1, int32_t x2, int32_t y2, uint32_t color);

/* Z:0x40bc00 frame rectangle: four lines (x1,y1)-(x2,y1)-(x2,y2)-(x1,y2)-(x1,y1). */
void draw_frame_rect(Image *dst, int32_t x1, int32_t y1, int32_t x2, int32_t y2, uint32_t color);

/* Z:0x40bf70 Blt(dest rect, src, src rect) with the rectangle adjustments of the original.
 * dst_rect NULL = whole destination; src_rect NULL = {0, 0, src w, src h}. Both rectangles are
 * modified copies, the caller's values stay. Equal sizes: plain copy (keyed: skip key pixels).
 * Different sizes: nearest-neighbour stretch (DirectDraw would scale; not reached by the game,
 * inferred rule). Returns DRAW_OK or DRAW_E_BLT (rectangle outside the surfaces: nothing drawn). */
int32_t draw_blt(Image *dst, const DrawRect *dst_rect, const Image *src, const DrawRect *src_rect);

/* Z:0x40bef0 DrawAt(src, x, y): unscaled copy, dest clamped to the destination size. */
int32_t draw_at(Image *dst, const Image *src, int32_t x, int32_t y);

#endif
