/* Test entry points (M4): used by port/tests/py (ctypes over libmoeboid.so) and native tests.
 * Not used by the wasm host. */
#include "eng_int.h"

Port *engine_test_port_new(void) { return (Port *)rt_calloc(1, sizeof(Port)); }

void engine_test_trace_mode(Port *p, uint32_t mode) { trace_set_mode(&p->trace, mode); }

uint8_t *engine_test_frame_ptr(Port *p) { return p->frame; }

uint32_t engine_test_trace_tick(Port *p) { return p->trace.tick; }

void engine_test_no_jump(Port *p, bool on) { p->no_jump = on; }

uint32_t engine_test_cursor(Port *p) { return p->cursor; }

/* Reference metrics for port/tests/py/refmock.py: the engine's font and text code. */
TextFonts *engine_text_open(const uint8_t *pack, uint32_t len) {
    MPack mp;
    if (mpack_open(&mp, pack, len) != 0) return NULL;
    TextFonts *tf = (TextFonts *)rt_calloc(1, sizeof(TextFonts));
    if (!tf) return NULL;
    text_fonts_load(tf, &mp);
    return tf;
}

/* Z:0x427c10 font + Z:0x40c2c0 GetTextExtentPoint32A; returns 0, or -1 without an atlas. */
int32_t engine_text_measure(const TextFonts *tf, const char *face, int32_t px, uint32_t style, const char *s, int32_t n,
                            int32_t *cx, int32_t *cy) {
    GdiFont f;
    int32_t weight = (style & 1u) ? 700 : 0;
    *cx = *cy = 0;
    if (gdi_font_select(&f, tf, face, -px, weight, (style >> 2) & 1u, (style >> 3) & 1u) != 0 &&
        gdi_font_select(&f, tf, "Arial", -px, weight, (style >> 2) & 1u, (style >> 3) & 1u) != 0)
        return -1;
    gdi_get_text_extent_point32(&f, s, n, cx, cy);
    return 0;
}

/* GIF logical screen size as CImageSeq::LoadGIF sees it (gif_decode pass 1). */
int32_t engine_gif_size(const uint8_t *data, uint32_t len, int32_t *w, int32_t *h) {
    static GifWork work; /* tests only */
    GifInfo info;
    gif_decode(data, len, &info, NULL, 0, NULL, &work);
    *w = info.width;
    *h = info.height;
    return info.nframes ? 0 : -1;
}

/* ---- deterministic stepping for the lockstep replay (port/tests/py/test_engine_lockstep.py) ----
 * engine_test_goto(ms): run every step before ms (in chunks below PORT_MAX_LATE_MS, so the stall
 * rule never applies), then put the clock on step ms without running it. engine_test_input delivers
 * one event at once at that step (as core deliver: key state, hooks, inactive flag), so the driver
 * can look at the engine between two events of the same step. engine_test_finish_step runs the rest
 * of the step (step hooks, timer pass), as core_step after the input delivery. */
void engine_test_goto(Port *p, uint32_t ms) {
    if (!p->wall_base_set) core_advance(p, 0);
    uint64_t target = vclock_first_step_at_or_after(&p->clock, (int64_t)ms);
    while (p->clock.k + 1u < target) {
        uint64_t next = target - 1u;
        uint64_t lim = p->clock.k + (uint64_t)(PORT_MAX_LATE_MS / 2u) * p->clock.den / p->clock.num;
        if (lim < p->clock.k + 1u) lim = p->clock.k + 1u;
        if (next > lim) next = lim;
        /* wall time whose step count is exactly next: ceil(next * num / den) (step > 1 ms: below
         * the next step) */
        uint64_t wall = (next * p->clock.num + p->clock.den - 1u) / p->clock.den;
        core_advance(p, (uint32_t)(p->wall_base + wall));
        if (p->clock.k != next) rt_panic("engine_test_goto: clock at step %llu, wanted %llu",
                                         (unsigned long long)p->clock.k, (unsigned long long)next);
    }
    if (p->clock.k < target) p->clock.k = target;
}

void engine_test_input(Port *p, uint32_t kind, int32_t a, int32_t b) {
    PortInput ev;
    rt_memset(&ev, 0, sizeof ev);
    ev.kind = kind;
    ev.a = a;
    ev.b = b;
    ev.seq = p->input.seq++;
    ev.step = p->clock.k;
    keys_apply(&p->keys, &ev);
    if (PORT_IN_KIND(kind) == PORT_IN_FOCUS_GAINED) p->inactive = false;
    for (uint32_t i = 0; i < PORT_HOOK_SLOTS; i++)
        if (p->hooks[i].input) p->hooks[i].input(p, &ev);
    if (PORT_IN_KIND(kind) == PORT_IN_FOCUS_LOST) p->inactive = true;
}

void engine_test_finish_step(Port *p) {
    for (uint32_t i = 0; i < PORT_HOOK_SLOTS; i++)
        if (p->hooks[i].step) p->hooks[i].step(p);
    if (!p->inactive) {
        timersys_run(&p->timers);
        p->passes++;
    }
    p->steps_run++;
}

uint32_t engine_test_now(Port *p) { return core_ticks(p); }

bool engine_test_storage_set(Port *p, const char *key, const char *value) { return storage_set(&p->storage, key, value); }

/* live objects of one type (OT_*), and their external references */
uint32_t engine_test_live_type(Port *p, uint32_t type, uint32_t *ext_sum) {
    Engine *e = engine_of(p);
    uint32_t n = 0;
    *ext_sum = 0;
    if (!e) return 0;
    for (uint32_t i = 1; i <= e->nobj; i++) {
        EngObj *o = eng_obj_get(e, (e->gen[i] << 20) | i, (uint8_t)type);
        if (o) {
            n++;
            *ext_sum += (uint32_t)o->ext;
        }
    }
    return n;
}

/* text smoothing (decision 4b; tests compare with the monochrome Wine captures) */
void engine_test_smoothing(Port *p, bool on) {
    Engine *e = engine_of(p);
    if (e) e->smoothing = on ? 1 : 0;
}

/* the engine's frame buffer (root surface image, 800x572 pixels 0xAABBGGRR), before the shell's
 * own composition into Port.frame */
const uint32_t *engine_test_root_pixels(Port *p) {
    Engine *e = engine_of(p);
    CImage *im = e ? eng_image(e, eng_surface_image(e, e->root)) : NULL;
    return im ? im->img.px : NULL;
}

/* timer list (diagnostics): period, last, started, realtime of item i; count when i < 0 */
int32_t engine_test_timer(Port *p, int32_t i, uint32_t *period, uint32_t *last, uint32_t *flags) {
    if (i < 0) return (int32_t)p->timers.count;
    if ((uint32_t)i >= p->timers.count) return -1;
    EngineTimer *t = p->timers.items[i];
    *period = t->period;
    *last = t->last;
    *flags = (t->started ? 1u : 0u) | (t->realtime ? 2u : 0u);
    return 0;
}

/* run every step whose clock value is at most ms, timer passes included (end of a replay: run.py
 * fires the timers due up to the end time) */
void engine_test_run_through(Port *p, uint32_t ms) {
    uint64_t kend = vclock_first_step_at_or_after(&p->clock, (int64_t)ms + 1) - 1u;
    if (kend <= p->clock.k) return;
    engine_test_goto(p, (uint32_t)vclock_ms_at(&p->clock, kend));
    engine_test_finish_step(p);
}
