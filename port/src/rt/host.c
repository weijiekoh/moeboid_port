/* Host sinks for logs and lockstep traces (M1).
 * wasm: env.host_log always; env.host_trace only with -DPORT_TRACE=1 (test builds,
 * port-design.md section 6). native: function pointers, default none. */
#include "rt.h"

#if defined(__wasm__)
__attribute__((import_module("env"), import_name("host_log"))) void host_log(const char *ptr, uint32_t len);
#if defined(PORT_TRACE) && PORT_TRACE
__attribute__((import_module("env"), import_name("host_trace"))) void host_trace(const char *ptr, uint32_t len);
#endif

void rt_set_sinks(RtSinkFn log, RtSinkFn trace) {
    (void)log;
    (void)trace;
}
void rt_host_log(const char *ptr, uint32_t len) { host_log(ptr, len); }
void rt_host_trace(const char *ptr, uint32_t len) {
#if defined(PORT_TRACE) && PORT_TRACE
    host_trace(ptr, len);
#else
    (void)ptr;
    (void)len;
#endif
}
bool rt_trace_available(void) {
#if defined(PORT_TRACE) && PORT_TRACE
    return true;
#else
    return false;
#endif
}

#else

static RtSinkFn g_log, g_trace;

void rt_set_sinks(RtSinkFn log, RtSinkFn trace) {
    g_log = log;
    g_trace = trace;
}
void rt_host_log(const char *ptr, uint32_t len) {
    if (g_log) g_log(ptr, len);
}
void rt_host_trace(const char *ptr, uint32_t len) {
    if (g_trace) g_trace(ptr, len);
}
bool rt_trace_available(void) { return g_trace != NULL; }

#endif

void rt_log(const char *fmt, ...) {
    char buf[512];
    rt_va_list ap;
    rt_va_start(ap, fmt);
    int n = rt_vsnprintf(buf, sizeof buf, fmt, ap);
    rt_va_end(ap);
    if (n > (int)sizeof buf - 1) n = (int)sizeof buf - 1;
    rt_host_log(buf, (uint32_t)n);
}

_Noreturn void rt_panic(const char *fmt, ...) {
    char buf[512];
    int k = rt_snprintf(buf, sizeof buf, "panic: ");
    rt_va_list ap;
    rt_va_start(ap, fmt);
    int n = rt_vsnprintf(buf + k, sizeof buf - (size_t)k, fmt, ap);
    rt_va_end(ap);
    n += k;
    if (n > (int)sizeof buf - 1) n = (int)sizeof buf - 1;
    rt_host_log(buf, (uint32_t)n);
    __builtin_trap();
}
