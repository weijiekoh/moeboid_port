/* Internal drawing helpers shared by dialog.c and dialog_edit.c (not part of the public API).
 * Clip arguments l, t, r, b: clip rectangle in image pixels (right and bottom exclusive). */
#ifndef MOEBOID_SHELL_DIALOG_INT_H
#define MOEBOID_SHELL_DIALOG_INT_H

#include "dialog.h"

#define DLG_EDGE_RAISED 5u
#define DLG_EDGE_SUNKEN 10u
#define DLG_BF_SOFT 0x1000u
#define DLG_BF_FLAT 0x4000u
#define DLG_BF_MIDDLE 0x0800u

uint32_t dlg_pixel(const Dialog *d, int32_t index);
void dlg_fill(Image *img, int32_t l, int32_t t, int32_t r, int32_t b, int32_t x, int32_t y, int32_t w, int32_t h,
              uint32_t px);
void dlg_fill_pattern(Image *img, int32_t l, int32_t t, int32_t r, int32_t b, int32_t x, int32_t y, int32_t w, int32_t h,
                      int32_t ox, int32_t oy, uint32_t set, uint32_t clear);
void dlg_draw_edge(Dialog *d, int32_t l, int32_t t, int32_t r, int32_t b, DlgRect rc, uint32_t edge, uint32_t flags);
void dlg_invert(Image *img, int32_t l, int32_t t, int32_t r, int32_t b, int32_t x, int32_t y);
void dlg_put(Image *img, int32_t l, int32_t t, int32_t r, int32_t b, int32_t x, int32_t y, uint32_t px);

#endif
