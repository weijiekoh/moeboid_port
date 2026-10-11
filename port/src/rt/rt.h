/* Freestanding runtime for the Moeboid port (M1). Same code in the wasm and the native build.
 *
 * Naming: every runtime function has an `rt_` prefix in both builds, so the native build
 * (linked with the host libc for tests and libmoeboid.so) never clashes with libc. Port code
 * calls the `rt_` names only and includes no libc header.
 * The wasm build also defines the standard names memcpy, memmove, memset, memcmp (src/rt/mem.c),
 * because the compiler emits calls to them for structure copies and large initialisers. In the
 * native build these four come from libc.
 *
 * Allowed compiler headers (port-design.md section 3): stdint.h, stddef.h, stdbool.h.
 * Variable arguments use the compiler builtins (__builtin_va_*) directly. */
#ifndef MOEBOID_RT_H
#define MOEBOID_RT_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

typedef __builtin_va_list rt_va_list;
#define rt_va_start(ap, last) __builtin_va_start(ap, last)
#define rt_va_arg(ap, type) __builtin_va_arg(ap, type)
#define rt_va_end(ap) __builtin_va_end(ap)
#define rt_va_copy(d, s) __builtin_va_copy(d, s)

#define RT_COUNTOF(a) (sizeof(a) / sizeof((a)[0]))
#define RT_MIN(a, b) ((a) < (b) ? (a) : (b))
#define RT_MAX(a, b) ((a) > (b) ? (a) : (b))

/* ---- memory and strings (src/rt/mem.c) ---- */
void *rt_memcpy(void *dst, const void *src, size_t n);
void *rt_memmove(void *dst, const void *src, size_t n);
void *rt_memset(void *dst, int c, size_t n);
int rt_memcmp(const void *a, const void *b, size_t n);
size_t rt_strlen(const char *s);
int rt_strcmp(const char *a, const char *b);
int rt_strncmp(const char *a, const char *b, size_t n);
char *rt_strchr(const char *s, int c);

/* ---- allocator (src/rt/alloc.c) ----
 * First-fit, address-ordered free list over one contiguous arena. Alignment 8. Block header
 * 8 bytes (u32 size with in-use bit, u32 next-free offset), so block offsets are the same in
 * the wasm32 and the native (64-bit) build for the same call sequence.
 * Arena: native = static array of RT_ARENA_BYTES; wasm = memory above __heap_base, grown with
 * memory.grow up to RT_ARENA_BYTES. Out of memory returns NULL. */
#ifndef RT_ARENA_BYTES
#define RT_ARENA_BYTES (256u * 1024u * 1024u)
#endif
void *rt_malloc(size_t n);
void *rt_calloc(size_t count, size_t size);
void *rt_realloc(void *p, size_t n);
void rt_free(void *p);
/* Offset of a block from the arena base (for determinism tests). */
uint32_t rt_heap_offset(const void *p);
typedef struct RtHeapStats {
    uint32_t top;        /* bytes carved from the arena (high-water of the block area) */
    uint32_t in_use;     /* bytes in allocated blocks, headers included */
    uint32_t free_bytes; /* bytes in free-list blocks */
    uint32_t free_blocks;
    uint32_t allocs;     /* successful rt_malloc calls since reset */
} RtHeapStats;
void rt_heap_stats(RtHeapStats *out);
/* Forget every block. Only for a full re-initialisation (tests, port_init). */
void rt_heap_reset(void);
/* Walk the heap and check every header; returns 0 if consistent. */
int rt_heap_check(void);

/* ---- formatted print (src/rt/fmt.c) ----
 * Conversions: %d %i %u %x %X %o %c %s %p %%. Flags - 0 + space #. Width and precision as
 * numbers or *. Length modifiers hh h l ll z j t. No floating point. Returns the length that
 * the full output needs (C99 semantics); the output is always NUL-terminated when n > 0. */
int rt_vsnprintf(char *buf, size_t n, const char *fmt, rt_va_list ap);
int rt_snprintf(char *buf, size_t n, const char *fmt, ...) __attribute__((format(printf, 3, 4)));

/* ---- host sinks (src/rt/host.c) ----
 * wasm: imports env.host_log, and env.host_trace only when built with PORT_TRACE=1.
 * native: function pointers set with rt_set_sinks (default: output is dropped). */
typedef void (*RtSinkFn)(const char *ptr, uint32_t len);
void rt_set_sinks(RtSinkFn log, RtSinkFn trace);
void rt_host_log(const char *ptr, uint32_t len);
void rt_host_trace(const char *ptr, uint32_t len);
bool rt_trace_available(void);
void rt_log(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
_Noreturn void rt_panic(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
#define RT_ASSERT(c) \
    do { \
        if (!(c)) rt_panic("assert %s:%d: %s", __FILE__, __LINE__, #c); \
    } while (0)

/* ---- SHA-256 (src/rt/sha256.c), for lockstep trace hashes ---- */
typedef struct RtSha256 {
    uint32_t h[8];
    uint64_t len;
    uint8_t buf[64];
    uint32_t fill;
} RtSha256;
void rt_sha256_init(RtSha256 *s);
void rt_sha256_update(RtSha256 *s, const void *data, size_t n);
void rt_sha256_final(RtSha256 *s, uint8_t out[32]);
/* Lower-case hex of the first nhex digits of the digest; out gets nhex + 1 bytes. */
void rt_sha256_hex(const uint8_t digest[32], char *out, uint32_t nhex);

#endif
