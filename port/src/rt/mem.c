/* Memory and string functions (M1). `no_builtin` stops the optimiser from turning the loops
 * back into calls to memcpy/memset (which would recurse in the wasm build). */
#include "rt.h"

#define RT_NOBUILTIN __attribute__((no_builtin))

typedef uint64_t __attribute__((may_alias)) rt_u64a;

RT_NOBUILTIN void *rt_memcpy(void *dst, const void *src, size_t n) {
#if defined(__wasm_bulk_memory__)
    /* memory.copy instruction: no call. */
    __builtin_memcpy(dst, src, n);
#else
    uint8_t *d = (uint8_t *)dst;
    const uint8_t *s = (const uint8_t *)src;
    if ((((uintptr_t)d | (uintptr_t)s) & 7u) == 0) {
        for (; n >= 8; n -= 8, d += 8, s += 8) *(rt_u64a *)(void *)d = *(const rt_u64a *)(const void *)s;
    }
    for (; n; n--) *d++ = *s++;
#endif
    return dst;
}

RT_NOBUILTIN void *rt_memmove(void *dst, const void *src, size_t n) {
#if defined(__wasm_bulk_memory__)
    __builtin_memmove(dst, src, n);
#else
    uint8_t *d = (uint8_t *)dst;
    const uint8_t *s = (const uint8_t *)src;
    if (d == s || n == 0) return dst;
    if (d < s || d >= s + n) {
        for (; n; n--) *d++ = *s++;
    } else {
        d += n;
        s += n;
        for (; n; n--) *--d = *--s;
    }
#endif
    return dst;
}

RT_NOBUILTIN void *rt_memset(void *dst, int c, size_t n) {
#if defined(__wasm_bulk_memory__)
    __builtin_memset(dst, c, n);
#else
    uint8_t *d = (uint8_t *)dst;
    uint8_t b = (uint8_t)c;
    if (((uintptr_t)d & 7u) == 0) {
        uint64_t w = 0x0101010101010101ull * b;
        for (; n >= 8; n -= 8, d += 8) *(rt_u64a *)(void *)d = w;
    }
    for (; n; n--) *d++ = b;
#endif
    return dst;
}

RT_NOBUILTIN int rt_memcmp(const void *a, const void *b, size_t n) {
    const uint8_t *x = (const uint8_t *)a, *y = (const uint8_t *)b;
    for (; n; n--, x++, y++)
        if (*x != *y) return (int)*x - (int)*y;
    return 0;
}

RT_NOBUILTIN size_t rt_strlen(const char *s) {
    const char *p = s;
    while (*p) p++;
    return (size_t)(p - s);
}

RT_NOBUILTIN int rt_strcmp(const char *a, const char *b) {
    const uint8_t *x = (const uint8_t *)a, *y = (const uint8_t *)b;
    while (*x && *x == *y) x++, y++;
    return (int)*x - (int)*y;
}

RT_NOBUILTIN int rt_strncmp(const char *a, const char *b, size_t n) {
    const uint8_t *x = (const uint8_t *)a, *y = (const uint8_t *)b;
    for (; n; n--, x++, y++) {
        if (*x != *y) return (int)*x - (int)*y;
        if (*x == 0) return 0;
    }
    return 0;
}

RT_NOBUILTIN char *rt_strchr(const char *s, int c) {
    char ch = (char)c;
    for (;; s++) {
        if (*s == ch) return (char *)s;
        if (*s == 0) return NULL;
    }
}

#if defined(__wasm__)
/* Standard names for compiler-generated calls (wasm only; native uses libc). */
void *memcpy(void *dst, const void *src, size_t n) { return rt_memcpy(dst, src, n); }
void *memmove(void *dst, const void *src, size_t n) { return rt_memmove(dst, src, n); }
void *memset(void *dst, int c, size_t n) { return rt_memset(dst, c, n); }
int memcmp(const void *a, const void *b, size_t n) { return rt_memcmp(a, b, n); }
#endif
