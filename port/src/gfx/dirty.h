/* Dirty rectangle list of the video subsystem (M4; analysis/rendering.md 1 and 5).
 * Video vtable +0x40 clear (Z:0x4137f0), +0x44 intersects (Z:0x413810), +0x48 add (Z:0x413860),
 * +0x4c flag (Z:0x413800). Rectangles are frame (root) coordinates {l, t, r, b}. */
#ifndef PORT_GFX_DIRTY_H
#define PORT_GFX_DIRTY_H

#include <stdbool.h>
#include <stdint.h>
#include "draw.h"

#define DIRTY_MAX 10000

typedef struct DirtyList {
    DrawRect r[DIRTY_MAX];
    int32_t count; /* +0x18 */
    bool flag;     /* +0x14 */
} DirtyList;

/* Z:0x4137f0 */
static inline void dirty_clear(DirtyList *d) {
    d->count = 0;
    d->flag = false;
}
/* Z:0x413800 */
static inline bool dirty_flag(const DirtyList *d) { return d->flag; }
/* Z:0x413860 add (x, y, w, h): skipped when equal to the last entry or when 10000 entries exist. */
void dirty_add(DirtyList *d, int32_t x, int32_t y, int32_t w, int32_t h);
/* Z:0x413810: true when rc touches any entry (inclusive edges). */
bool dirty_intersects(const DirtyList *d, const DrawRect *rc);

#endif
