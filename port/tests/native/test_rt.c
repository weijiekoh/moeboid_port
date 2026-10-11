/* Tests for src/rt: memory/string functions, allocator, printf-lite, SHA-256 (M1). */
#include "rt/rt.h"
#include "test.h"

static void test_mem(void) {
    uint8_t a[64], b[64];
    for (int i = 0; i < 64; i++) a[i] = (uint8_t)i;
    rt_memset(b, 0xab, sizeof b);
    CHECK(b[0] == 0xab && b[63] == 0xab);
    rt_memcpy(b + 3, a + 5, 40);
    CHECK(memcmp(b + 3, a + 5, 40) == 0 && b[2] == 0xab && b[43] == 0xab);
    /* overlapping moves in both directions */
    rt_memmove(a + 2, a, 20);
    CHECK(a[2] == 0 && a[21] == 19);
    for (int i = 0; i < 64; i++) a[i] = (uint8_t)i;
    rt_memmove(a, a + 2, 20);
    CHECK(a[0] == 2 && a[19] == 21);
    CHECK(rt_memcmp("abc", "abd", 3) < 0);
    CHECK(rt_memcmp("abd", "abc", 3) > 0);
    CHECK(rt_memcmp("\xff", "\x01", 1) > 0); /* unsigned compare */
    CHECK(rt_memcmp("abc", "abd", 2) == 0);
    CHECK_EQ(rt_strlen(""), 0);
    CHECK_EQ(rt_strlen("hello"), 5);
    CHECK(rt_strcmp("a", "b") < 0 && rt_strcmp("b", "a") > 0 && rt_strcmp("x", "x") == 0);
    CHECK(rt_strcmp("ab", "abc") < 0);
    CHECK(rt_strncmp("abcX", "abcY", 3) == 0 && rt_strncmp("abcX", "abcY", 4) < 0);
    CHECK(rt_strncmp("ab", "ab", 10) == 0);
    const char *s = "hello";
    CHECK(rt_strchr(s, 'l') == s + 2);
    CHECK(rt_strchr(s, 0) == s + 5);
    CHECK(rt_strchr(s, 'z') == NULL);
}

static void test_fmt(void) {
    static const struct {
        const char *fmt;
        long long v;
    } ints[] = {
        {"%d", 0}, {"%d", -1}, {"%5d", 42}, {"%-5d|", 42}, {"%05d", -42}, {"%+d", 7}, {"% d", 7},
        {"%x", 0xbeef}, {"%X", 0xbeef}, {"%#x", 255}, {"%08x", 0x1234}, {"%o", 8}, {"%u", 4000000000LL},
        {"%.3d", 5}, {"%3.2d|", 1}, {"%.0d|", 0}, {"%i", -2147483647LL - 1},
    };
    char a[128], b[128];
    for (size_t i = 0; i < sizeof ints / sizeof ints[0]; i++) {
        int na, nb;
        if (strchr(ints[i].fmt, 'u') || strchr(ints[i].fmt, 'x') || strchr(ints[i].fmt, 'X') || strchr(ints[i].fmt, 'o')) {
            na = rt_snprintf(a, sizeof a, ints[i].fmt, (unsigned)ints[i].v);
            nb = snprintf(b, sizeof b, ints[i].fmt, (unsigned)ints[i].v);
        } else {
            na = rt_snprintf(a, sizeof a, ints[i].fmt, (int)ints[i].v);
            nb = snprintf(b, sizeof b, ints[i].fmt, (int)ints[i].v);
        }
        CHECK_STR(a, b);
        CHECK_EQ(na, nb);
    }
    rt_snprintf(a, sizeof a, "%lld %llu %llx", -9000000000LL, 18446744073709551615ULL, 0x123456789abcULL);
    CHECK_STR(a, "-9000000000 18446744073709551615 123456789abc");
    rt_snprintf(a, sizeof a, "%zu %ld %hd %hhu", (size_t)77, -5L, (short)-3, (unsigned char)200);
    CHECK_STR(a, "77 -5 -3 200");
    rt_snprintf(a, sizeof a, "[%s] [%6s] [%-6s] [%.2s] [%*s] [%c%c] %%", "abc", "abc", "abc", "abc", 4, "x", 'o', 'k');
    CHECK_STR(a, "[abc] [   abc] [abc   ] [ab] [   x] [ok] %");
    rt_snprintf(a, sizeof a, "%s", (const char *)NULL);
    CHECK_STR(a, "(null)");
    /* truncation: return value = full length, output NUL-terminated */
    int n = rt_snprintf(a, 5, "%s", "abcdefgh");
    CHECK_EQ(n, 8);
    CHECK_STR(a, "abcd");
    n = rt_snprintf(NULL, 0, "%d", 12345);
    CHECK_EQ(n, 5);
    const char *unknown = "%q %d"; /* unknown conversion: copied as text */
    rt_snprintf(a, sizeof a, unknown, 1);
    CHECK_STR(a, "%q 1");
}

static void test_alloc(void) {
    rt_heap_reset();
    void *p[16];
    for (int i = 0; i < 16; i++) {
        p[i] = rt_malloc((size_t)(i * 13 + 1));
        CHECK(p[i] != NULL);
        CHECK(((uintptr_t)p[i] & 7u) == 0);
    }
    /* deterministic layout: 8-byte header + payload rounded to 8, min block 16 */
    CHECK_EQ(rt_heap_offset(p[0]), 8);
    CHECK_EQ(rt_heap_offset(p[1]), 8 + 16 + 0);    /* block 0 = 16 bytes (1 -> 8 + 8) */
    CHECK_EQ(rt_heap_offset(p[2]), 8 + 16 + 24);   /* block 1 = 24 bytes (14 -> 16 + 8) */
    CHECK_EQ(rt_heap_check(), 0);
    /* first fit: free block 3, a smaller request takes its front part */
    uint32_t off3 = rt_heap_offset(p[3]);
    rt_free(p[3]);
    void *q = rt_malloc(8);
    CHECK_EQ(rt_heap_offset(q), off3);
    CHECK_EQ(rt_heap_check(), 0);
    rt_free(q);
    /* merge: free 4 and 5 next to the free block 3 */
    rt_free(p[4]);
    rt_free(p[5]);
    CHECK_EQ(rt_heap_check(), 0);
    RtHeapStats st;
    rt_heap_stats(&st);
    CHECK_EQ(st.free_blocks, 1);
    /* top shrink: free the last blocks */
    uint32_t top_before = st.top;
    rt_free(p[15]);
    rt_heap_stats(&st);
    CHECK(st.top < top_before);
    CHECK_EQ(rt_heap_check(), 0);
    /* realloc keeps content */
    char *r = (char *)rt_malloc(10);
    memcpy(r, "123456789", 10);
    r = (char *)rt_realloc(r, 1000);
    CHECK(r && strcmp(r, "123456789") == 0);
    r = (char *)rt_realloc(r, 5); /* shrink: same block */
    CHECK(r && memcmp(r, "12345", 5) == 0);
    /* calloc zeroes reused memory */
    rt_free(r);
    unsigned char *z = (unsigned char *)rt_calloc(100, 3);
    int nz = 0;
    for (int i = 0; i < 300; i++) nz += z[i] != 0;
    CHECK_EQ(nz, 0);
    CHECK(rt_calloc((size_t)1 << 40, (size_t)1 << 40) == NULL);
    CHECK(rt_malloc((size_t)RT_ARENA_BYTES + 1) == NULL);
    rt_free(NULL);
    CHECK(rt_realloc(z, 0) == NULL);
    CHECK_EQ(rt_heap_check(), 0);

    /* random stress, twice from a reset: identical offsets (determinism), consistent heap */
    uint64_t sig[2] = {0, 0};
    for (int run = 0; run < 2; run++) {
        rt_heap_reset();
        void *slot[256] = {0};
        uint32_t x = 12345;
        int bad = 0;
        for (int i = 0; i < 20000; i++) {
            x = x * 1103515245u + 12345u;
            int k = (int)((x >> 16) & 255u);
            if (slot[k]) {
                if ((x >> 8) & 1) rt_free(slot[k]), slot[k] = NULL;
                else slot[k] = rt_realloc(slot[k], (x >> 20) & 4095u);
            } else {
                slot[k] = rt_malloc((x >> 20) & 4095u);
                if (!slot[k]) bad++;
            }
            if (slot[k]) sig[run] = sig[run] * 31u + rt_heap_offset(slot[k]);
            if ((i & 1023) == 0 && rt_heap_check()) bad++;
        }
        CHECK_EQ(bad, 0);
        for (int k = 0; k < 256; k++) rt_free(slot[k]);
        rt_heap_stats(&st);
        CHECK_EQ(st.top, 0); /* everything returned to the arena */
        CHECK_EQ(rt_heap_check(), 0);
    }
    CHECK(sig[0] == sig[1]);
}

static void hex(const void *data, size_t n, char *out) {
    RtSha256 s;
    uint8_t d[32];
    rt_sha256_init(&s);
    rt_sha256_update(&s, data, n);
    rt_sha256_final(&s, d);
    rt_sha256_hex(d, out, 64);
}

static void test_sha256(void) {
    char h[65];
    hex("", 0, h);
    CHECK_STR(h, "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855");
    hex("abc", 3, h);
    CHECK_STR(h, "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad");
    const char *m = "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq";
    hex(m, strlen(m), h);
    CHECK_STR(h, "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1");
    /* one million 'a', fed in odd-sized pieces */
    RtSha256 s;
    uint8_t d[32];
    char buf[997];
    memset(buf, 'a', sizeof buf);
    rt_sha256_init(&s);
    size_t left = 1000000;
    while (left) {
        size_t k = left < sizeof buf ? left : sizeof buf;
        rt_sha256_update(&s, buf, k);
        left -= k;
    }
    rt_sha256_final(&s, d);
    rt_sha256_hex(d, h, 16);
    CHECK_STR(h, "cdc76e5c9914fb92");
}

int main(void) {
    test_mem();
    test_fmt();
    test_alloc();
    test_sha256();
    return test_report("test_rt");
}
