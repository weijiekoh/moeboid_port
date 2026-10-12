/* wasm exports: host API of port-design.md section 6 (M1 creates, M4/M5 extend).
 * Only the wasm build compiles this file. The single global Port is `g_port`; engine and shell
 * code receive it through the hooks (src/core/port.h), not through this symbol. */
#include "core/port.h"
#include "cpu/cpu.h"
#include "engine/engine.h"

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

/* Extension: font smoothing (decision 4b; the host sets Standard, port/host/main.ts). 1 = Standard
 * (default: grey text where the font's gasp table allows it), 0 = off (monochrome text). Call before
 * port_init; the engine, frame and dialog text read it once at start. */
static uint32_t g_smoothing = 1u;
EXPORT(port_set_smoothing) void port_set_smoothing(uint32_t on) { g_smoothing = on ? 1u : 0u; }

/* The pack and Moeboid.gam blocks must stay allocated (the engine reads them later).
 * clock_step_index: 0 = 1 ms, 1 = 15.625 ms, 2 = 54.925 ms (3 = 10.0144 ms, tests only).
 * Returns 0 or the first error of an init hook. Call once per module instance. */
EXPORT(port_init)
int32_t port_init(const uint8_t *pack, uint32_t pack_len, const uint8_t *gam, uint32_t gam_len, uint32_t clock_step_index,
                  uint32_t quirks) {
    core_init(&g_port, clock_step_index, quirks, g_seed);
    g_port.smoothing = (uint8_t)g_smoothing;
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

/* Extension (M4): engine diagnostics for tests. what: 1 applet running, 2 game screen kind
 * (1 title, 2 play, 3 credits, 0 none), 3 / 4 player x / y (float32 bits; play screen only),
 * 5 engine renders, 6 trace ticks begun, 7 1 if a guest fault stopped the game, 8 timer pause,
 * 9 INVINCIBLE cheat flag (G:0x1000f604), 10 lives (play screen +0x1a4); M7 acceptance drivers
 * (port/tests/accept): 11 1 if the game waits for a dialog, 13 the game's play-screen pointer
 * DAT_1000f5e4 (G:0x1000f5e4), 14 / 15 heap bytes in use / carved (rt_heap_stats). No shell symbol
 * here: the engine-only test link (port/tests/py/enginedrv.py) has no src/shell. */
EXPORT(port_probe) uint32_t port_probe(uint32_t what) {
    Port *p = &g_port;
    struct Cpu *c = engine_cpu(p);
    uint32_t game = c ? cpu_rd32(c, 0x1000f5d8u) : 0u;          /* game object (G:0x100025f0) */
    uint32_t st = game ? cpu_rd32(c, game) : 0u;                 /* current screen */
    uint32_t vt = st ? cpu_rd32(c, st) : 0u;                     /* screen vtable (G:0x1000d150..) */
    uint32_t pl = (vt == 0x1000d158u) ? cpu_rd32(c, st + 0xcu) : 0u;
    switch (what) {
    case 1: return engine_applet_running(p) ? 1u : 0u;
    case 2: return vt == 0x1000d15cu ? 1u : vt == 0x1000d158u ? 2u : vt == 0x1000d154u ? 3u : 0u;
    case 3: return pl ? cpu_rd32(c, pl + 0x10u) : 0u;
    case 4: return pl ? cpu_rd32(c, pl + 0x14u) : 0u;
    case 5: return engine_render_count(p);
    case 6: return p->trace.tick;
    case 7: return engine_fault_text(p)[0] ? 1u : 0u;
    case 8: return engine_paused(p) ? 1u : 0u;
    case 9: return c ? cpu_rd32(c, 0x1000f604u) & 0xffu : 0u;
    case 10: return (vt == 0x1000d158u) ? cpu_rd32(c, st + 0x1a4u) : 0u;
    case 11: return engine_dialog_waiting(p) ? 1u : 0u;
    case 13: return c ? cpu_rd32(c, 0x1000f5e4u) : 0u;
    case 14:
    case 15: {
        RtHeapStats hs;
        rt_heap_stats(&hs);
        return what == 14 ? hs.in_use : hs.top;
    }
    default: return 0u;
    }
}

#if PORT_TRACE
/* Test exports of the trace build (M4 lockstep: port/tests/py/wasm_replay.mjs). Not in the release
 * build. port_test_init = port_init with the trace on from step 0 (DllMain, Shell_StartApplet). */
void engine_test_goto(Port *p, uint32_t ms);
void engine_test_input(Port *p, uint32_t kind, int32_t a, int32_t b);
void engine_test_finish_step(Port *p);
bool engine_test_storage_set(Port *p, const char *key, const char *value);

EXPORT(port_test_storage_set) uint32_t port_test_storage_set(const char *key, const char *value) {
    return engine_test_storage_set(&g_port, key, value) ? 1u : 0u;
}
EXPORT(port_test_init)
int32_t port_test_init(const uint8_t *pack, uint32_t pack_len, const uint8_t *gam, uint32_t gam_len, uint32_t seed,
                       uint32_t trace_mode) {
    core_init(&g_port, 0, 0xffffffffu, seed);
    trace_set_mode(&g_port.trace, trace_mode);
    int32_t r = core_start(&g_port, pack, pack_len, gam, gam_len);
    engine_test_auto_dialogs(&g_port, true);
    core_advance(&g_port, 0);
    return r;
}
EXPORT(port_test_goto) void port_test_goto(uint32_t ms) { engine_test_goto(&g_port, ms); }
EXPORT(port_test_input) void port_test_input(uint32_t kind, int32_t a, int32_t b) { engine_test_input(&g_port, kind, a, b); }
EXPORT(port_test_finish_step) void port_test_finish_step(void) { engine_test_finish_step(&g_port); }
void engine_test_run_through(Port *p, uint32_t ms);
EXPORT(port_test_run_through) void port_test_run_through(uint32_t ms) { engine_test_run_through(&g_port, ms); }
EXPORT(port_test_button_point) uint32_t port_test_button_point(const char *label, int32_t *xy) {
    return engine_test_button_point(&g_port, label, &xy[0], &xy[1]) ? 1u : 0u;
}
EXPORT(port_test_answer) void port_test_answer(const char *text) { engine_test_answer(&g_port, text); }
EXPORT(port_test_applet_event) void port_test_applet_event(int32_t arg) { engine_applet_event(&g_port, arg); }
EXPORT(port_test_stop) void port_test_stop(void) { engine_applet_stop(&g_port); }
EXPORT(port_test_fault) const char *port_test_fault(void) { return engine_fault_text(&g_port); }
#endif
