/* Minimal test helpers for the native core tests (M1). Test programs may use the host libc. */
#ifndef MOEBOID_TEST_H
#define MOEBOID_TEST_H

#include <inttypes.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int t_pass, t_fail;

#define CHECK(c) \
    do { \
        if (c) t_pass++; \
        else { \
            t_fail++; \
            fprintf(stderr, "%s:%d: CHECK failed: %s\n", __FILE__, __LINE__, #c); \
        } \
    } while (0)

#define CHECK_EQ(a, b) \
    do { \
        long long _a = (long long)(a), _b = (long long)(b); \
        if (_a == _b) t_pass++; \
        else { \
            t_fail++; \
            fprintf(stderr, "%s:%d: CHECK_EQ failed: %s = %lld, %s = %lld\n", __FILE__, __LINE__, #a, _a, #b, _b); \
        } \
    } while (0)

#define CHECK_STR(a, b) \
    do { \
        const char *_a = (a), *_b = (b); \
        if (_a && _b && strcmp(_a, _b) == 0) t_pass++; \
        else { \
            t_fail++; \
            fprintf(stderr, "%s:%d: CHECK_STR failed: %s = \"%s\", expected \"%s\"\n", __FILE__, __LINE__, #a, \
                    _a ? _a : "(null)", _b ? _b : "(null)"); \
        } \
    } while (0)

static inline int test_report(const char *name) {
    printf("%s: %d passed, %d failed\n", name, t_pass, t_fail);
    return t_fail ? 1 : 0;
}

/* Repository root, from the absolute path of this header (build.sh compiles with absolute
 * paths): <root>/port/tests/native/test.h. */
static inline const char *test_root(void) {
    static char buf[1024];
    const char *env = getenv("MOEBOID_ROOT");
    if (env) return env;
    snprintf(buf, sizeof buf, "%s", __FILE__);
    for (int i = 0; i < 4; i++) {
        char *s = strrchr(buf, '/');
        if (!s) return ".";
        *s = 0;
    }
    return buf;
}

#endif
