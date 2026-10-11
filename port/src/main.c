/* wasm exports: host API of port-design.md section 6 (M1 creates, M4/M5 extend).
 * Only the wasm build compiles this file. The single global Port is `g_port`; engine and shell
 * code receive it through the hooks (src/core/port.h), not through this symbol. */
#include "core/port.h"

#define EXPORT(name) __attribute__((export_name(#name), used))

static Port g_port;

/* Memory for host data (pack, Moeboid.gam, storage blob). */
EXPORT(port_alloc) void *port_alloc(uint32_t n) { return rt_malloc(n ? n : 1u); }
/* Extension: free a port_alloc block (not for blocks passed to port_init). */
EXPORT(port_free) void port_free(void *p) { rt_free(p); }

/* Extension: engine srand seed (the original seeds with timeGetTime at start, Z:0x403dc4).
 * Call before port_init; without a call the seed is 1 (CRT default state). */
static uint32_t g_seed = MSVC_RAND_DEFAULT_STATE;
EXPORT(port_set_seed) void port_set_seed(uint32_t seed) { g_seed = seed; }

/* The pack and Moeboid.gam blocks must stay allocated (the engine reads them later).
 * clock_step_index: 0 = 1 ms, 1 = 15.625 ms, 2 = 54.925 ms (3 = 10.0144 ms, tests only).
 * Returns 0 or the first error of an init hook. Call once per module instance. */
EXPORT(port_init)
int32_t port_init(const uint8_t *pack, uint32_t pack_len, const uint8_t *gam, uint32_t gam_len, uint32_t clock_step_index,
                  uint32_t quirks) {
    core_init(&g_port, clock_step_index, quirks, g_seed);
    return core_start(&g_port, pack, pack_len, gam, gam_len);
}

/* Bits: 0 frame changed, 1 sound commands pending, 2 storage changed. */
EXPORT(port_advance) uint32_t port_advance(uint32_t wall_ms) { return core_advance(&g_port, wall_ms); }

/* Kinds: src/core/input.h. Returns 1 if queued, 0 if the queue was full. */
EXPORT(port_input) uint32_t port_input(uint32_t kind, int32_t a, int32_t b, uint32_t time_ms) {
    return core_input(&g_port, kind, a, b, time_ms) ? 1u : 0u;
}

EXPORT(port_frame_ptr) uint8_t *port_frame_ptr(void) { return g_port.frame; }
EXPORT(port_frame_w) uint32_t port_frame_w(void) { return PORT_W; }
EXPORT(port_frame_h) uint32_t port_frame_h(void) { return PORT_H; }

EXPORT(port_cursor) uint32_t port_cursor(void) { return g_port.cursor; }

/* Drains the sound queue into out (room for PORT_SOUND_QUEUE_MAX records of 4 x u32:
 * op, sound_id, voice, at_ms). Returns the count. out == 0: count only, no drain. */
EXPORT(port_sound_cmds) uint32_t port_sound_cmds(PortSoundCmd *out) { return core_sound_drain(&g_port, out); }
EXPORT(port_sound_cmds_max) uint32_t port_sound_cmds_max(void) { return PORT_SOUND_QUEUE_MAX; }

/* Storage blob (src/core/storage.h). The pointer is valid until the next port call. */
EXPORT(port_storage_get_ptr) const char *port_storage_get_ptr(void) {
    uint32_t n;
    return storage_blob(&g_port.storage, &n);
}
EXPORT(port_storage_get_len) uint32_t port_storage_get_len(void) {
    uint32_t n;
    storage_blob(&g_port.storage, &n);
    return n;
}
/* Replace the store with a blob from localStorage; call before port_init. Returns the
 * storage_load result (0 clean, > 0 bad lines skipped, -1 bad header). */
EXPORT(port_storage_load) int32_t port_storage_load(const uint8_t *ptr, uint32_t len) {
    return storage_load(&g_port.storage, ptr, len);
}

/* Extension: GetTickCount model of the current step (ms since port_init). */
EXPORT(port_now) uint32_t port_now(void) { return core_ticks(&g_port); }

/* Extension: trace mode 0 off, 1 tick hashes, 2 full log (needs a PORT_TRACE=1 build). */
EXPORT(port_trace_mode) uint32_t port_trace_mode(uint32_t mode) {
    if (!rt_trace_available()) return 0;
    trace_set_mode(&g_port.trace, mode);
    return 1;
}
