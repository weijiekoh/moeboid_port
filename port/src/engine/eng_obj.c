/* Engine object table, reference counts and guest wrappers (M4; analysis/interface.md 3). */
#include "eng_int.h"

#define IDX_BITS 20u
#define IDX_MASK ((1u << IDX_BITS) - 1u)
#define GEN_MASK 0xfffu

/* ------------------------------------------------------------------ handle lists */
void hl_push(HList *l, uint32_t h) {
    if (l->n >= l->cap) {
        int32_t cap = l->cap ? l->cap * 2 : 4;
        uint32_t *v = (uint32_t *)rt_realloc(l->v, (size_t)cap * sizeof *v);
        if (!v) rt_panic("engine: out of memory (list)");
        l->v = v;
        l->cap = cap;
    }
    l->v[l->n++] = h;
}

int32_t hl_find(const HList *l, uint32_t h) {
    for (int32_t i = 0; i < l->n; i++)
        if (l->v[i] == h) return i;
    return -1;
}

bool hl_remove(HList *l, uint32_t h) {
    int32_t i = hl_find(l, h);
    if (i < 0) return false;
    for (int32_t j = i + 1; j < l->n; j++) l->v[j - 1] = l->v[j];
    l->n--;
    return true;
}

void hl_free(HList *l) {
    rt_free(l->v);
    l->v = NULL;
    l->n = l->cap = 0;
}

/* ------------------------------------------------------------------ objects */
EngObj *eng_obj_new(Engine *e, uint8_t type, uint32_t size) {
    EngObj *o = (EngObj *)rt_calloc(1, size);
    if (!o) rt_panic("engine: out of memory (object type %u)", type);
    uint32_t idx = e->free_head;
    if (idx) {
        e->free_head = (uint32_t)(uintptr_t)e->obj[idx] >> 1; /* free slots hold (next << 1) | 1 */
    } else {
        if (e->nobj + 1 >= e->capobj) {
            uint32_t cap = e->capobj ? e->capobj * 2 : 1024;
            if (cap > IDX_MASK) rt_panic("engine: too many objects");
            EngObj **p = (EngObj **)rt_realloc(e->obj, cap * sizeof *p);
            uint32_t *g = (uint32_t *)rt_realloc(e->gen, cap * sizeof *g);
            if (!p || !g) rt_panic("engine: out of memory (object table)");
            for (uint32_t i = e->capobj; i < cap; i++) {
                p[i] = NULL;
                g[i] = 0;
            }
            e->obj = p;
            e->gen = g;
            e->capobj = cap;
        }
        idx = ++e->nobj;
    }
    e->gen[idx] = (e->gen[idx] + 1u) & GEN_MASK;
    if (e->gen[idx] == 0) e->gen[idx] = 1;
    e->obj[idx] = o;
    o->type = type;
    o->serial = ++e->serial;
    o->owner = e->alloc_owner;
    o->h = (e->gen[idx] << IDX_BITS) | idx;
    e->live++;
    return o;
}

static bool slot_live(const Engine *e, uint32_t idx) {
    return idx && idx <= e->nobj && e->obj[idx] && !((uintptr_t)e->obj[idx] & 1u);
}

EngObj *eng_obj_get(Engine *e, uint32_t h, uint8_t type) {
    uint32_t idx = h & IDX_MASK;
    if (!slot_live(e, idx) || e->gen[idx] != (h >> IDX_BITS)) return NULL;
    EngObj *o = e->obj[idx];
    if (type != OT_NONE && o->type != type) return NULL;
    return o;
}

/* Type destructors (scalar deleting destructors of the inner vtables, slot +0x00). */
void eng_dtor_image(Engine *e, CImage *o);
void eng_dtor_seq(Engine *e, CSeq *o);
void eng_dtor_anim(Engine *e, CAnim *o);
void eng_dtor_surface(Engine *e, CSurface *o);
void eng_dtor_font(Engine *e, CFont *o);
void eng_dtor_timer(Engine *e, CTimer *o);
void eng_dtor_sound(Engine *e, CSound *o);
void eng_dtor_listener(Engine *e, CListener *o);
void eng_dtor_channel(Engine *e, CChannel *o);

void eng_obj_destroy(Engine *e, EngObj *o) {
    uint32_t idx = o->h & IDX_MASK;
    if (!slot_live(e, idx) || e->obj[idx] != o || o->dying) return;
    o->dying = 1;
    switch (o->type) {
    case OT_IMAGE: eng_dtor_image(e, (CImage *)o); break;
    case OT_SEQ: eng_dtor_seq(e, (CSeq *)o); break;
    case OT_ANIM: eng_dtor_anim(e, (CAnim *)o); break;
    case OT_SURFACE: eng_dtor_surface(e, (CSurface *)o); break;
    case OT_FONT: eng_dtor_font(e, (CFont *)o); break;
    case OT_TIMER: eng_dtor_timer(e, (CTimer *)o); break;
    case OT_SOUND: eng_dtor_sound(e, (CSound *)o); break;
    case OT_LISTENER: eng_dtor_listener(e, (CListener *)o); break;
    case OT_CHANNEL: eng_dtor_channel(e, (CChannel *)o); break;
    default: break;
    }
    e->obj[idx] = (EngObj *)(uintptr_t)((e->free_head << 1) | 1u);
    e->free_head = idx;
    e->live--;
    rt_free(o);
}

int32_t eng_release_ext(Engine *e, EngObj *o) {
    /* Z:0x414f90: ext = max(ext - 1, 0); freed when both counts are 0 (result 0), else ext. */
    int32_t v = o->ext - 1;
    if (v < 0) v = 0;
    o->ext = v;
    if (o->in == 0 && v == 0) {
        eng_obj_destroy(e, o);
        return 0;
    }
    return v;
}

int32_t eng_release_int(Engine *e, EngObj *o) {
    /* Z:0x414fc0: in = max(in - 1, 0); freed when both counts are 0 (result 0), else ext + in. */
    int32_t v = o->in - 1;
    if (v < 0) v = 0;
    o->in = v;
    if (v == 0 && o->ext == 0) {
        eng_obj_destroy(e, o);
        return 0;
    }
    return o->ext + v;
}

uint32_t eng_release_int_h(Engine *e, uint32_t h) {
    EngObj *o = eng_obj_get(e, h, OT_NONE);
    return o ? (uint32_t)eng_release_int(e, o) : 0u;
}

/* ------------------------------------------------------------------ wrappers */
uint32_t eng_wrap_new(Engine *e, uint32_t iface, uint32_t handle) {
    /* operator new(8); [0] = wrapper vtable, [1] = inner object (for example Z:0x417860). */
    uint32_t slot;
    if (e->wrap_free) {
        slot = e->wrap_free - 1u;
        e->wrap_free = e->wrap[slot].next_free;
    } else {
        if (e->nwrap >= e->capwrap) {
            uint32_t cap = e->capwrap ? e->capwrap * 2 : 4096;
            if ((uint64_t)cap * 8u > ENG_WRAP_HI - ENG_WRAP_LO) cap = (ENG_WRAP_HI - ENG_WRAP_LO) / 8u;
            if (cap <= e->nwrap) return 0;
            WrapSlot *w = (WrapSlot *)rt_realloc(e->wrap, cap * sizeof *w);
            if (!w) rt_panic("engine: out of memory (wrappers)");
            e->wrap = w;
            e->capwrap = cap;
        }
        slot = e->nwrap++;
    }
    WrapSlot *w = &e->wrap[slot];
    w->trace_id = 0;
    w->iface = (uint8_t)iface;
    w->live = 1;
    w->next_free = 0;
    uint32_t a = ENG_WRAP_LO + slot * 8u;
    cpu_wr32(e->cpu, a, ENG_VT_LO + iface * CPU_ENGINE_SLOTS * 4u);
    cpu_wr32(e->cpu, a + 4u, handle);
    eng_trace_id_assign(e, a, iface);
    return a;
}

const WrapSlot *eng_wrap_slot(const Engine *e, uint32_t addr) {
    if (addr < ENG_WRAP_LO || addr >= ENG_WRAP_HI || (addr & 7u)) return NULL;
    uint32_t slot = (addr - ENG_WRAP_LO) / 8u;
    if (slot >= e->nwrap || !e->wrap[slot].live) return NULL;
    return &e->wrap[slot];
}

void eng_wrap_free(Engine *e, uint32_t addr) {
    /* scalar deleting destructor of the wrapper (Z:0x415460): delete the 8 bytes only */
    if (!eng_wrap_slot(e, addr)) return;
    uint32_t slot = (addr - ENG_WRAP_LO) / 8u;
    e->wrap[slot].live = 0;
    e->wrap[slot].next_free = e->wrap_free;
    e->wrap_free = slot + 1u;
    cpu_wr32(e->cpu, addr, 0);
    cpu_wr32(e->cpu, addr + 4u, 0);
}

uint32_t eng_wrap_handle(Engine *e, uint32_t addr) { return cpu_rd32(e->cpu, addr + 4u); }

uint32_t eng_trace_id_assign(Engine *e, uint32_t addr, uint32_t iface) {
    (void)iface;
    if (addr < ENG_WRAP_LO || addr >= ENG_WRAP_HI) return 0;
    uint32_t slot = (addr - ENG_WRAP_LO) / 8u;
    if (slot >= e->nwrap) return 0;
    e->wrap[slot].trace_id = ++e->next_trace_id;
    return e->wrap[slot].trace_id;
}
