/* Dirty rectangle list (M4). See dirty.h. */
#include "dirty.h"

void dirty_add(DirtyList *d, int32_t x, int32_t y, int32_t w, int32_t h) {
    /* Z:0x413860 */
    int32_t n = d->count;
    if (n >= 1) {
        const DrawRect *last = &d->r[n - 1];
        if (last->l == x && last->t == y && last->r == x + w && last->b == y + h) return;
    }
    if (n >= DIRTY_MAX) return;
    d->r[n].l = x;
    d->r[n].t = y;
    d->r[n].r = x + w;
    d->r[n].b = y + h;
    d->flag = true;
    d->count = n + 1;
}

bool dirty_intersects(const DirtyList *d, const DrawRect *rc) {
    /* Z:0x413810 */
    for (int32_t i = 0; i < d->count; i++) {
        const DrawRect *e = &d->r[i];
        if (rc->l <= e->r && e->l <= rc->r && rc->t <= e->b && e->t <= rc->b) return true;
    }
    return false;
}
