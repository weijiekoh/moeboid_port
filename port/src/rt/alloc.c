/* Deterministic allocator (M1): first fit over an address-ordered free list, alignment 8.
 * Block = 8-byte header {u32 size | in-use bit, u32 next free offset} + payload. Sizes are
 * multiples of 8, minimum 16. Free blocks merge with adjacent free blocks; a free block that
 * ends at the top of the carved area goes back to the arena. Offsets, not pointers, link the
 * list, so the layout is the same in the wasm32 and the native build. */
#include "rt.h"

#define HDR 8u
#define MIN_BLOCK 16u
#define USED 1u
#define NIL 0xffffffffu

typedef struct Hdr {
    uint32_t size; /* block bytes including the header; bit 0 = in use */
    uint32_t next; /* free blocks only: offset of the next free block, NIL at the end */
} Hdr;

static struct {
    uint8_t *base;
    uint32_t cap; /* usable bytes from base */
    uint32_t top; /* carved bytes from base */
    uint32_t free_head;
    uint32_t allocs;
    bool ready;
} A;

#if defined(__wasm__)
extern uint8_t __heap_base;
#else
static uint8_t g_arena[RT_ARENA_BYTES] __attribute__((aligned(16)));
#endif

static void arena_init(void) {
#if defined(__wasm__)
    uintptr_t b = ((uintptr_t)&__heap_base + 7u) & ~(uintptr_t)7u;
    uintptr_t end = (uintptr_t)__builtin_wasm_memory_size(0) * 65536u;
    A.base = (uint8_t *)b;
    A.cap = (uint32_t)(end - b);
    if (A.cap > RT_ARENA_BYTES) A.cap = RT_ARENA_BYTES;
#else
    A.base = g_arena;
    A.cap = RT_ARENA_BYTES;
#endif
    A.top = 0;
    A.free_head = NIL;
    A.allocs = 0;
    A.ready = true;
}

/* Make at least `end` bytes from base usable. */
static bool arena_reserve(uint64_t end) {
    if (end <= A.cap) return true;
    if (end > RT_ARENA_BYTES) return false;
#if defined(__wasm__)
    uintptr_t have = (uintptr_t)__builtin_wasm_memory_size(0) * 65536u;
    uint64_t want = (uint64_t)(uintptr_t)A.base + end;
    uint64_t pages = (want - have + 65535u) / 65536u;
    if (__builtin_wasm_memory_grow(0, (size_t)pages) == (size_t)-1) return false;
    uint64_t cap = (uint64_t)__builtin_wasm_memory_size(0) * 65536u - (uintptr_t)A.base;
    A.cap = cap > RT_ARENA_BYTES ? RT_ARENA_BYTES : (uint32_t)cap;
    return end <= A.cap;
#else
    return false;
#endif
}

static inline Hdr *H(uint32_t off) { return (Hdr *)(void *)(A.base + off); }

static uint32_t block_size_for(size_t n) {
    if (n > RT_ARENA_BYTES) return 0;
    uint32_t need = (uint32_t)((n + 7u) & ~(size_t)7u) + HDR;
    return need < MIN_BLOCK ? MIN_BLOCK : need;
}

void *rt_malloc(size_t n) {
    if (!A.ready) arena_init();
    uint32_t need = block_size_for(n);
    if (need == 0) return NULL;
    uint32_t prev = NIL, cur = A.free_head;
    while (cur != NIL) {
        Hdr *h = H(cur);
        uint32_t sz = h->size;
        if (sz >= need) {
            uint32_t next = h->next;
            if (sz - need >= MIN_BLOCK) { /* split: the front part is used */
                uint32_t rem = cur + need;
                H(rem)->size = sz - need;
                H(rem)->next = next;
                next = rem;
                sz = need;
            }
            if (prev == NIL) A.free_head = next;
            else H(prev)->next = next;
            h->size = sz | USED;
            h->next = 0;
            A.allocs++;
            return A.base + cur + HDR;
        }
        prev = cur;
        cur = h->next;
    }
    if (!arena_reserve((uint64_t)A.top + need)) return NULL;
    uint32_t off = A.top;
    A.top += need;
    H(off)->size = need | USED;
    H(off)->next = 0;
    A.allocs++;
    return A.base + off + HDR;
}

static uint32_t checked_offset(const void *p) {
    uintptr_t a = (uintptr_t)p, b = (uintptr_t)A.base;
    if (!A.ready || a < b + HDR || a >= b + A.top || ((a - b) & 7u) != 0) rt_panic("rt_free: bad pointer");
    uint32_t off = (uint32_t)(a - b) - HDR;
    if (!(H(off)->size & USED)) rt_panic("rt_free: block not in use (double free)");
    return off;
}

void rt_free(void *p) {
    if (!p) return;
    uint32_t off = checked_offset(p);
    Hdr *h = H(off);
    h->size &= ~USED;
    uint32_t pprev = NIL, prev = NIL, cur = A.free_head;
    while (cur != NIL && cur < off) {
        pprev = prev;
        prev = cur;
        cur = H(cur)->next;
    }
    h->next = cur;
    if (prev == NIL) A.free_head = off;
    else H(prev)->next = off;
    if (cur != NIL && off + h->size == cur) { /* merge with the next block */
        h->size += H(cur)->size;
        h->next = H(cur)->next;
    }
    uint32_t pred = prev;
    if (prev != NIL && prev + H(prev)->size == off) { /* merge into the previous block */
        H(prev)->size += h->size;
        H(prev)->next = h->next;
        off = prev;
        pred = pprev;
    }
    if (off + H(off)->size == A.top) { /* last block: give it back to the arena */
        if (pred == NIL) A.free_head = H(off)->next;
        else H(pred)->next = H(off)->next;
        A.top = off;
    }
}

void *rt_calloc(size_t count, size_t size) {
    if (size && count > (size_t)RT_ARENA_BYTES / size) return NULL;
    void *p = rt_malloc(count * size);
    if (p) rt_memset(p, 0, count * size);
    return p;
}

void *rt_realloc(void *p, size_t n) {
    if (!p) return rt_malloc(n);
    if (n == 0) {
        rt_free(p);
        return NULL;
    }
    uint32_t off = checked_offset(p);
    uint32_t sz = H(off)->size & ~USED;
    if (n <= sz - HDR) return p;
    uint32_t need = block_size_for(n);
    if (need == 0) return NULL;
    if (off + sz == A.top) { /* top block: grow in place */
        if (!arena_reserve((uint64_t)off + need)) return NULL;
        A.top = off + need;
        H(off)->size = need | USED;
        return p;
    }
    void *q = rt_malloc(n);
    if (!q) return NULL;
    rt_memcpy(q, p, sz - HDR);
    rt_free(p);
    return q;
}

uint32_t rt_heap_offset(const void *p) { return (uint32_t)((uintptr_t)p - (uintptr_t)A.base); }

void rt_heap_reset(void) { arena_init(); }

void rt_heap_stats(RtHeapStats *out) {
    if (!A.ready) arena_init();
    rt_memset(out, 0, sizeof *out);
    out->top = A.top;
    out->allocs = A.allocs;
    for (uint32_t off = 0; off < A.top;) {
        uint32_t sz = H(off)->size & ~USED;
        if (H(off)->size & USED) out->in_use += sz;
        else {
            out->free_bytes += sz;
            out->free_blocks++;
        }
        if (sz < MIN_BLOCK) break;
        off += sz;
    }
}

int rt_heap_check(void) {
    if (!A.ready) arena_init();
    uint32_t fl = A.free_head, last_free = 0;
    bool prev_free = false;
    for (uint32_t off = 0; off < A.top;) {
        uint32_t raw = H(off)->size, sz = raw & ~USED;
        if (sz < MIN_BLOCK || (sz & 7u) || off + sz > A.top) return 1; /* broken size */
        if (!(raw & USED)) {
            if (fl != off) return 2;      /* free block missing from the ordered list */
            if (prev_free) return 3;      /* two adjacent free blocks not merged */
            fl = H(off)->next;
            last_free = off + sz;
            prev_free = true;
        } else prev_free = false;
        off += sz;
    }
    if (fl != NIL) return 4;              /* list entries beyond the carved area */
    if (A.top && last_free == A.top) return 5; /* free block at the top not returned */
    return 0;
}
