/* Lockstep trace (M1). See trace.h. */
#include "trace.h"

static void emit(const char *p, uint32_t n) { rt_host_trace(p, n); }

static void emitf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
static void emitf(const char *fmt, ...) {
    char buf[256];
    rt_va_list ap;
    rt_va_start(ap, fmt);
    int n = rt_vsnprintf(buf, sizeof buf, fmt, ap);
    rt_va_end(ap);
    if (n > (int)sizeof buf - 1) n = (int)sizeof buf - 1;
    emit(buf, (uint32_t)n);
}

void trace_init(Trace *t) {
    rt_memset(t, 0, sizeof *t);
    rt_sha256_init(&t->sha);
}

void trace_set_mode(Trace *t, uint32_t mode) { t->mode = mode <= TRACE_FULL ? mode : TRACE_FULL; }

void trace_begin_tick(Trace *t, uint32_t ms, const char *what) {
    if (t->open) trace_end_tick(t, NULL);
    t->tick++;
    t->ms = ms;
    t->lines = 0;
    t->open = true;
    rt_sha256_init(&t->sha);
    if (t->mode == TRACE_FULL) emitf("T%u ms=%u %s\n", t->tick, ms, what ? what : "");
}

void trace_line(Trace *t, const char *line, uint32_t len) {
    if (!t->open || t->mode == TRACE_OFF) return;
    if (t->lines) rt_sha256_update(&t->sha, "\n", 1);
    rt_sha256_update(&t->sha, line, len);
    t->lines++;
    if (t->mode == TRACE_FULL) {
        emit("  ", 2);
        emit(line, len);
        emit("\n", 1);
    }
}

void trace_linef(Trace *t, const char *fmt, ...) {
    if (!t->open || t->mode == TRACE_OFF) return;
    char buf[512];
    rt_va_list ap, ap2;
    rt_va_start(ap, fmt);
    rt_va_copy(ap2, ap);
    int n = rt_vsnprintf(buf, sizeof buf, fmt, ap);
    rt_va_end(ap);
    if (n < (int)sizeof buf) {
        trace_line(t, buf, (uint32_t)n);
    } else {
        char *big = (char *)rt_malloc((size_t)n + 1u);
        if (!big) rt_panic("trace_linef: out of memory");
        rt_vsnprintf(big, (size_t)n + 1u, fmt, ap2);
        trace_line(t, big, (uint32_t)n);
        rt_free(big);
    }
    rt_va_end(ap2);
}

const char *trace_end_tick(Trace *t, const char *state) {
    uint8_t d[32];
    rt_sha256_final(&t->sha, d);
    rt_sha256_hex(d, t->last_hash, 16);
    if (state && *state) {
        RtSha256 s;
        rt_sha256_init(&s);
        rt_sha256_update(&s, state, rt_strlen(state));
        rt_sha256_final(&s, d);
        rt_sha256_hex(d, t->last_state, 12);
    } else {
        t->last_state[0] = '-';
        t->last_state[1] = 0;
    }
    if (t->mode == TRACE_FULL && state && *state) {
        emit("  state ", 8);
        emit(state, (uint32_t)rt_strlen(state));
        emit("\n", 1);
    }
    if (t->mode != TRACE_OFF) emitf("%u\t%u\t%u\t%s\t%s\n", t->tick, t->ms, t->lines, t->last_hash, t->last_state);
    t->open = false;
    rt_sha256_init(&t->sha);
    return t->last_hash;
}
