/* Main-loop tests (M1): core_advance (timing.md 9), MAX_LATE one-late-pass rule (rule 7), input
 * delivery rule (rule 5), key-state table, focus and inactive state (2.5), output flags, the
 * jump optimisation (rule 3: same results with and without), determinism. */
#include "core/port.h"
#include "test.h"

static Port P;

/* ---- event log: every fire, input delivery and key poll, as text ---- */
static char g_log[1 << 22];
static size_t g_loglen;

static void logf_(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
static void logf_(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    int n = vsnprintf(g_log + g_loglen, sizeof g_log - g_loglen, fmt, ap);
    va_end(ap);
    if (n > 0 && g_loglen + (size_t)n < sizeof g_log) g_loglen += (size_t)n;
}

static void reset(uint32_t idx, bool no_jump) {
    core_init(&P, idx, 0xffffffffu, 1);
    P.no_jump = no_jump;
    g_loglen = 0;
    g_log[0] = 0;
}

/* ---- simple fire recorder ---- */
static int g_fires;
static uint32_t g_fire_now[4096];
static uint64_t g_fire_k[4096];
static int16_t g_fire_key[4096];

static void rec(EngineTimer *t, const TimerEvent *ev) {
    (void)t;
    if (g_fires < 4096) {
        g_fire_now[g_fires] = ev->now;
        g_fire_k[g_fires] = P.clock.k;
        g_fire_key[g_fires] = core_key_state(&P, 0x25); /* VK_LEFT, as the per-tick poll */
    }
    g_fires++;
}

static int g_inputs;
static PortInput g_in[256];
static void on_input(Port *p, const PortInput *ev) {
    (void)p;
    if (g_inputs < 256) g_in[g_inputs] = *ev;
    g_inputs++;
}

static void test_basics(void) {
    reset(0, false);
    /* frame cleared to #3333cc, reported once */
    CHECK(P.frame[0] == 0x33 && P.frame[1] == 0x33 && P.frame[2] == 0xcc && P.frame[3] == 0xff);
    size_t last = (size_t)PORT_W * PORT_H * 4 - 4;
    CHECK(P.frame[last] == 0x33 && P.frame[last + 2] == 0xcc && P.frame[last + 3] == 0xff);
    CHECK_EQ(core_advance(&P, 1000), PORT_ADV_FRAME); /* first call: base, no step */
    CHECK_EQ(P.clock.k, 0);
    CHECK_EQ(core_advance(&P, 1100), 0);
    CHECK_EQ(P.clock.k, 100);
    CHECK_EQ(core_ticks(&P), 100);
    CHECK_EQ(core_advance(&P, 1050), 0); /* time going back: no change */
    CHECK_EQ(P.clock.k, 100);
    /* 15.625 ms steps: floor(wall / S) */
    reset(1, false);
    core_advance(&P, 0);
    core_advance(&P, 46);
    CHECK_EQ(P.clock.k, 2);
    core_advance(&P, 47);
    CHECK_EQ(P.clock.k, 3);
    CHECK_EQ(core_ticks(&P), 46);
    /* host time base wraps (uint32) */
    reset(0, false);
    core_advance(&P, 0xfffffff0u);
    core_advance(&P, 0x10u);
    CHECK_EQ(P.clock.k, 32);
    /* sound queue: commands stamped with the clock ms; bit 1 while pending */
    reset(0, false);
    core_advance(&P, 0);
    core_advance(&P, 37);
    CHECK(core_sound_push(&P, 1, 7, 3));
    CHECK(core_sound_push(&P, 1, 8, 4));
    uint32_t f = core_advance(&P, 40);
    CHECK(f & PORT_ADV_SOUND);
    PortSoundCmd out[PORT_SOUND_QUEUE_MAX];
    CHECK_EQ(core_sound_drain(&P, NULL), 2);
    CHECK_EQ(core_sound_drain(&P, out), 2);
    CHECK(out[0].op == 1 && out[0].sound_id == 7 && out[0].voice == 3 && out[0].at_ms == 37);
    CHECK_EQ(out[1].sound_id, 8);
    CHECK_EQ(core_sound_drain(&P, out), 0);
    CHECK_EQ(core_advance(&P, 41) & PORT_ADV_SOUND, 0);
    for (uint32_t i = 0; i < PORT_SOUND_QUEUE_MAX; i++) core_sound_push(&P, 1, i, 0);
    CHECK(!core_sound_push(&P, 1, 0, 0));
    CHECK_EQ(P.sound_dropped, 1);
    core_sound_drain(&P, out);
    /* storage change: bit 2 once */
    CHECK(storage_set(&P.storage, "k", "v"));
    CHECK_EQ(core_advance(&P, 42), PORT_ADV_STORAGE);
    CHECK_EQ(core_advance(&P, 43), 0);
    storage_clear(&P.storage);
    /* frame hook marks the frame once per advance that moved the clock */
    core_frame_changed(&P);
    CHECK_EQ(core_advance(&P, 43), PORT_ADV_FRAME);
}

static int g_frame_calls;
static void on_frame(Port *p) {
    g_frame_calls++;
    core_frame_changed(p);
}

static void test_frame_hook(void) {
    reset(0, false);
    P.hooks[PORT_HOOK_SHELL].frame = on_frame;
    g_frame_calls = 0;
    core_advance(&P, 0);
    CHECK_EQ(g_frame_calls, 0);
    CHECK_EQ(core_advance(&P, 16), PORT_ADV_FRAME);
    CHECK_EQ(core_advance(&P, 16), 0);
    CHECK_EQ(g_frame_calls, 1);
}

/* ---- MAX_LATE: more than 250 ms pending gives one late pass (timing.md 9 rule 7) ---- */
static void test_max_late(void) {
    for (int nj = 0; nj < 2; nj++) {
        reset(0, nj);
        EngineTimer t;
        timer_init(&t, 0, 20, rec, NULL);
        timer_start(&P.timers, &t);
        g_fires = 0;
        core_advance(&P, 0);
        core_advance(&P, 250); /* exactly 250 ms pending: every step runs */
        CHECK_EQ(P.clock.k, 250);
        CHECK_EQ(P.late_jumps, 0);
        CHECK_EQ(g_fires, 12);
        if (nj) CHECK_EQ(P.steps_run, 250);
        core_advance(&P, 501); /* 251 ms pending: skip to 500, one pass at 501 */
        CHECK_EQ(P.clock.k, 501);
        CHECK_EQ(P.late_jumps, 1);
        CHECK_EQ(g_fires, 13);
        CHECK_EQ(g_fire_now[12], 501);
        if (nj) CHECK_EQ(P.steps_run, 251);
        core_advance(&P, 520); /* phase moved: next fire at 521 */
        CHECK_EQ(g_fires, 13);
        core_advance(&P, 521);
        CHECK_EQ(g_fires, 14);
        timer_release(&P.timers, &t);
    }
    /* 54.925 ms step: 4 steps (219.7 ms) run, 5 steps (274.6 ms) skip to the last */
    reset(2, true);
    core_advance(&P, 0);
    core_advance(&P, 220);
    CHECK_EQ(P.clock.k, 4);
    CHECK_EQ(P.late_jumps, 0);
    CHECK_EQ(P.steps_run, 4);
    core_advance(&P, 220 + 275);
    CHECK_EQ(P.clock.k, 9);
    CHECK_EQ(P.late_jumps, 1);
    CHECK_EQ(P.steps_run, 5);
    /* 15.625 ms step: 16 steps = 250 ms run, 17 skip */
    reset(1, true);
    core_advance(&P, 0);
    core_advance(&P, 250);
    CHECK_EQ(P.clock.k, 16);
    CHECK_EQ(P.late_jumps, 0);
    core_advance(&P, 250 + 266);
    CHECK_EQ(P.clock.k, 33);
    CHECK_EQ(P.late_jumps, 1);
}

/* ---- input delivery rule (timing.md 9 rule 5) ---- */
static void test_input_rule(void) {
    for (int nj = 0; nj < 2; nj++) {
        reset(1, nj); /* 15.625 ms */
        P.hooks[PORT_HOOK_ENGINE].input = on_input;
        g_inputs = 0;
        g_fires = 0;
        EngineTimer t; /* fires every step: floor diffs 15 or 16 >= 15 */
        timer_init(&t, 0, 15, rec, NULL);
        timer_start(&P.timers, &t);
        core_advance(&P, 1000); /* base */
        core_input(&P, PORT_IN_KEYDOWN, 0x25, 0, 1000 + 37);
        core_advance(&P, 1000 + 46); /* steps 1, 2 (31.25 < 37) */
        CHECK_EQ(g_inputs, 0);
        core_advance(&P, 1000 + 47); /* step 3 (46.875 >= 37) */
        CHECK_EQ(g_inputs, 1);
        CHECK_EQ(g_in[0].step, 3);
        CHECK_EQ(g_in[0].t, 37);
        /* the pass of step 3 sees the key down; step 2 did not */
        CHECK_EQ(g_fires, 3);
        CHECK_EQ(g_fire_key[1], 0);
        CHECK_EQ((uint16_t)g_fire_key[2], 0xff81); /* down + toggle */
        /* exact boundary: t = 125 = 8 * 15.625 is due at step 8; t = 126 at step 9 */
        core_input(&P, PORT_IN_KEYUP, 0x25, 0, 1000 + 125);
        core_input(&P, PORT_IN_KEYDOWN, 0x41, 0, 1000 + 126);
        core_advance(&P, 1000 + 130);
        CHECK_EQ(g_inputs, 2);
        CHECK_EQ(g_in[1].step, 8);
        core_advance(&P, 1000 + 141);
        CHECK_EQ(g_inputs, 3);
        CHECK_EQ(g_in[2].step, 9);
        CHECK_EQ(core_key_state(&P, 0x25), 1); /* up, toggle kept */
        /* an event whose step is already done goes to the next step */
        core_input(&P, PORT_IN_KEYDOWN, 0x42, 0, 1000 + 50);
        core_advance(&P, 1000 + 160); /* step 10 = 156.25 */
        CHECK_EQ(g_inputs, 4);
        CHECK_EQ(g_in[3].step, 10);
        /* an event before the base (negative stamp) is due at the next step */
        core_input(&P, PORT_IN_KEYUP, 0x42, 0, 900);
        core_advance(&P, 1000 + 172);
        CHECK_EQ(g_inputs, 5);
        CHECK_EQ(g_in[4].step, 11);
        CHECK(g_in[4].t < 0);
        timer_release(&P.timers, &t);
    }
}

/* ---- key poll per tick: a press and release between two ticks is not seen ---- */
static void test_short_press(void) {
    reset(0, false);
    EngineTimer t;
    timer_init(&t, 0, 20, rec, NULL);
    timer_start(&P.timers, &t);
    g_fires = 0;
    core_advance(&P, 0);
    core_input(&P, PORT_IN_KEYDOWN, 0x25, 0, 21);
    core_input(&P, PORT_IN_KEYUP, 0x25, 0, 35);
    core_advance(&P, 100);
    CHECK_EQ(g_fires, 5);
    int seen = 0;
    for (int i = 0; i < 5; i++) seen |= g_fire_key[i] & 0x80;
    CHECK_EQ(seen, 0);
    CHECK_EQ(core_key_state(&P, 0x25), 1); /* toggled once */
    /* held across a tick: seen */
    core_input(&P, PORT_IN_KEYDOWN, 0x25, 0, 110);
    core_input(&P, PORT_IN_KEYDOWN, 0x25, 1, 130); /* auto-repeat: no toggle */
    core_input(&P, PORT_IN_KEYUP, 0x25, 0, 150);
    core_advance(&P, 160);
    CHECK_EQ(g_fires, 8);
    CHECK_EQ(g_fire_key[5] & 0x80, 0x80);
    CHECK_EQ(g_fire_key[6] & 0x80, 0x80);
    CHECK_EQ(g_fire_key[7] & 0x80, 0);
    CHECK_EQ(core_key_state(&P, 0x25), 0);
    /* mouse buttons in the table: left = VK_LBUTTON, right (button 2) = VK_RBUTTON */
    core_input(&P, PORT_IN_BUTTONDOWN, 10, 20, 170);
    core_input(&P, PORT_IN_BUTTONDOWN | (2u << 8), 10, 20, 170);
    core_advance(&P, 171);
    CHECK_EQ(core_key_state(&P, VK_LBUTTON) & 0x80, 0x80);
    CHECK_EQ(core_key_state(&P, VK_RBUTTON) & 0x80, 0x80);
    core_input(&P, PORT_IN_BUTTONUP, 10, 20, 172);
    core_advance(&P, 173);
    CHECK_EQ(core_key_state(&P, VK_LBUTTON) & 0x80, 0);
    timer_release(&P.timers, &t);
}

/* ---- focus: inactive stops every pass; one late fire at reactivation (timing.md 2.5) ---- */
static bool g_inactive_seen_by_hook;
static void on_input_focus(Port *p, const PortInput *ev) {
    if (PORT_IN_KIND(ev->kind) == PORT_IN_FOCUS_LOST) g_inactive_seen_by_hook = p->inactive;
    on_input(p, ev);
}

static void test_focus(void) {
    for (int nj = 0; nj < 2; nj++) {
        reset(0, nj);
        P.hooks[PORT_HOOK_SHELL].input = on_input_focus;
        g_inputs = 0;
        g_fires = 0;
        EngineTimer t;
        timer_init(&t, 0, 50, rec, NULL);
        timer_set_realtime(&t, true); /* the render timer is real-time */
        timer_start(&P.timers, &t);
        core_advance(&P, 0);
        core_input(&P, PORT_IN_KEYDOWN, 0x26, 0, 55);
        core_input(&P, PORT_IN_FOCUS_LOST, 0, 0, 60);
        core_advance(&P, 200);
        CHECK_EQ(g_fires, 1); /* 50 only */
        CHECK(P.inactive);
        CHECK(!g_inactive_seen_by_hook);               /* hook runs before inactive = 1 */
        CHECK_EQ(core_key_state(&P, 0x26) & 0x80, 0);   /* keys released on focus loss */
        CHECK_EQ(core_key_state(&P, 0x26) & 1, 1);
        for (uint32_t w = 216; w < 500; w += 16) core_advance(&P, w);
        CHECK_EQ(g_fires, 1);
        core_input(&P, PORT_IN_FOCUS_GAINED, 0, 0, 500);
        core_advance(&P, 500);
        CHECK(!P.inactive);
        CHECK_EQ(g_fires, 2); /* one late fire at 500, no catch-up */
        CHECK_EQ(g_fire_now[1], 500);
        core_advance(&P, 549);
        CHECK_EQ(g_fires, 2);
        core_advance(&P, 550);
        CHECK_EQ(g_fires, 3);
        timer_release(&P.timers, &t);
    }
}

/* ---- mouse moves due at one step merge into the last one ---- */
static void test_mouse_merge(void) {
    reset(0, false);
    P.hooks[PORT_HOOK_ENGINE].input = on_input;
    g_inputs = 0;
    core_advance(&P, 0);
    core_input(&P, PORT_IN_MOUSEMOVE, 1, 1, 4);
    core_input(&P, PORT_IN_MOUSEMOVE, 2, 2, 5);
    core_input(&P, PORT_IN_MOUSEMOVE, 3, 3, 5);
    core_input(&P, PORT_IN_BUTTONDOWN, 3, 3, 5);
    core_input(&P, PORT_IN_MOUSEMOVE, 4, 4, 5);
    core_input(&P, PORT_IN_MOUSEMOVE, 5, 5, 9);
    core_advance(&P, 4); /* step 4: only the move at t = 4 is due, no merge across steps */
    CHECK_EQ(g_inputs, 1);
    CHECK_EQ(g_in[0].a, 1);
    core_advance(&P, 6); /* step 5: moves 2 and 3 merge into 3; the button breaks the run */
    CHECK_EQ(g_inputs, 4);
    CHECK(g_in[1].kind == PORT_IN_MOUSEMOVE && g_in[1].a == 3);
    CHECK(g_in[2].kind == PORT_IN_BUTTONDOWN);
    CHECK(g_in[3].kind == PORT_IN_MOUSEMOVE && g_in[3].a == 4);
    core_advance(&P, 10);
    CHECK_EQ(g_inputs, 5);
    CHECK_EQ(g_in[4].a, 5);
    /* queue full: drop and count */
    for (uint32_t i = 0; i < PORT_INPUT_QUEUE_MAX; i++) core_input(&P, PORT_IN_KEYDOWN, 0x41, 0, 100);
    CHECK(!core_input(&P, PORT_IN_KEYDOWN, 0x41, 0, 100));
    CHECK_EQ(P.input.dropped, 1);
}

/* ---- randomized scenarios: the jump gives the same log; runs are deterministic ---- */
typedef struct Scn {
    uint32_t rng;
    EngineTimer t[12];
    int n;
} Scn;
static Scn S;

static uint32_t scn_rand(void) {
    S.rng = S.rng * 1664525u + 1013904223u;
    return S.rng >> 8;
}

static void scn_cb(EngineTimer *t, const TimerEvent *ev) {
    int id = (int)(t - S.t);
    logf_("F%d k=%llu now=%u el=%u key=%d\n", id, (unsigned long long)P.clock.k, ev->now, ev->elapsed2,
          core_key_state(&P, 0x25));
    trace_begin_tick(&P.trace, ev->now, "timer");
    trace_linef(&P.trace, "%08x t%d(%u) = %d", 0x10000000u + (unsigned)id, id, ev->elapsed2, msvc_rand(&P.rand));
    trace_end_tick(&P.trace, NULL);
    uint32_t r = scn_rand() % 100;
    EngineTimer *o = &S.t[scn_rand() % (uint32_t)S.n];
    if (r < 6) timer_stop(&P.timers, o);
    else if (r < 12) timer_start(&P.timers, o);
    else if (r < 15) timer_restart(&P.timers, o);
    else if (r < 18) timersys_set_paused(&P.timers, !timersys_is_paused(&P.timers));
    else if (r < 20) timer_stop(&P.timers, t);
    else if (r < 21) core_sound_push(&P, 1, (uint32_t)id, 0);
}

static void scn_input(Port *p, const PortInput *ev) {
    logf_("I k=%llu kind=%u a=%d t=%d\n", (unsigned long long)p->clock.k, ev->kind, ev->a, ev->t);
    if (PORT_IN_KIND(ev->kind) == PORT_IN_KEYDOWN && ev->a == 0x50)
        timersys_set_paused(&p->timers, !timersys_is_paused(&p->timers));
    if (PORT_IN_KIND(ev->kind) == PORT_IN_KEYDOWN && ev->a == 0x53) timer_start(&p->timers, &S.t[0]);
}

static uint64_t fnv(const char *s, size_t n) {
    uint64_t h = 1469598103934665603ull;
    for (size_t i = 0; i < n; i++) h = (h ^ (uint8_t)s[i]) * 1099511628211ull;
    return h;
}

static char g_trace_out[1 << 22];
static size_t g_trace_len;
static void trace_sink(const char *p, uint32_t n) {
    if (g_trace_len + n < sizeof g_trace_out) {
        memcpy(g_trace_out + g_trace_len, p, n);
        g_trace_len += n;
    }
}

/* Returns a hash of the full log, the final state and the trace rows. */
static uint64_t run_scenario(uint32_t idx, uint32_t seed, bool no_jump, uint64_t *steps) {
    reset(idx, no_jump);
    P.hooks[PORT_HOOK_ENGINE].input = scn_input;
    trace_set_mode(&P.trace, TRACE_HASH);
    g_trace_len = 0;
    memset(&S, 0, sizeof S);
    S.rng = seed;
    S.n = 3 + (int)(scn_rand() % 9);
    for (int i = 0; i < S.n; i++) {
        uint32_t period = (scn_rand() % 4 == 0) ? scn_rand() % 8 : 1 + scn_rand() % 300;
        timer_init(&S.t[i], (uint32_t)i, period, scn_cb, NULL);
        timer_set_realtime(&S.t[i], scn_rand() % 3 == 0);
        if (scn_rand() % 4) timer_start(&P.timers, &S.t[i]);
    }
    uint32_t wall = scn_rand();
    core_advance(&P, wall);
    /* inputs use their own generator, so the script is the same in both modes */
    uint32_t irng = seed ^ 0x9e3779b9u;
    for (int f = 0; f < 600; f++) {
        irng = irng * 1103515245u + 12345u;
        uint32_t r = irng >> 8;
        uint32_t dt = (r % 50 == 0) ? 200 + r % 900 : 1 + r % 40;
        for (int e = 0; e < (int)((r >> 4) % 3); e++) {
            irng = irng * 1103515245u + 12345u;
            uint32_t q = irng >> 8;
            static const uint32_t kinds[] = {1, 2, 3, 4, 5, 6, 7, 1, 2, 3};
            uint32_t kind = kinds[q % 10];
            int32_t a = (kind == 1 || kind == 2) ? (int32_t)(q % 7 == 0 ? 0x50 : q % 11 == 0 ? 0x53 : 0x25 + q % 4)
                                                 : (int32_t)(q % 800);
            core_input(&P, kind, a, (int32_t)(q % 572), wall + (q >> 12) % (dt + 30) - 10);
        }
        wall += dt;
        uint32_t fl = core_advance(&P, wall);
        logf_("A k=%llu fl=%u\n", (unsigned long long)P.clock.k, fl);
        if (fl & PORT_ADV_SOUND) {
            PortSoundCmd out[PORT_SOUND_QUEUE_MAX];
            uint32_t n = core_sound_drain(&P, out);
            for (uint32_t i = 0; i < n; i++) logf_("S %u %u\n", out[i].sound_id, out[i].at_ms);
        }
    }
    logf_("END k=%llu paused=%d inactive=%d count=%u rand=%u game=%u real=%u\n", (unsigned long long)P.clock.k,
          P.timers.paused, P.inactive, P.timers.count, P.rand.state, timersys_game_time(&P.timers),
          timersys_real_time(&P.timers));
    for (int i = 0; i < S.n; i++)
        logf_("T%d started=%d last=%u start=%u\n", i, S.t[i].started, S.t[i].last, S.t[i].start);
    *steps = P.steps_run;
    for (int i = 0; i < S.n; i++) timer_release(&P.timers, &S.t[i]);
    return fnv(g_log, g_loglen) ^ (fnv(g_trace_out, g_trace_len) * 31u);
}

static void test_jump_equivalence(void) {
    rt_set_sinks(NULL, trace_sink);
    int same = 0, total = 0;
    uint64_t steps_jump = 0, steps_all = 0;
    for (uint32_t idx = 0; idx < VCLOCK_STEP_COUNT; idx++) {
        for (uint32_t seed = 1; seed <= 25; seed++) {
            uint64_t s1, s2, s3;
            uint64_t h_all = run_scenario(idx, seed * 7919u, true, &s1);
            size_t len_all = g_loglen;
            uint64_t h_jump = run_scenario(idx, seed * 7919u, false, &s2);
            uint64_t h_jump2 = run_scenario(idx, seed * 7919u, false, &s3);
            total++;
            if (h_all == h_jump && h_jump == h_jump2 && len_all == g_loglen) same++;
            else fprintf(stderr, "scenario idx=%u seed=%u differs\n", idx, seed);
            steps_all += s1;
            steps_jump += s2;
        }
    }
    CHECK_EQ(same, total);
    CHECK(steps_jump < steps_all); /* the jump skipped steps */
    printf("jump equivalence: %d/%d scenarios equal; steps processed %llu (jump) vs %llu (every step)\n", same,
           total, (unsigned long long)steps_jump, (unsigned long long)steps_all);
    rt_set_sinks(NULL, NULL);
}

/* ---- a step hook turns the jump off (every step runs) ---- */
static int g_step_calls;
static void on_step(Port *p) {
    (void)p;
    g_step_calls++;
}
static void test_step_hook(void) {
    reset(0, false);
    P.hooks[PORT_HOOK_ENGINE].step = on_step;
    g_step_calls = 0;
    core_advance(&P, 0);
    core_advance(&P, 100);
    CHECK_EQ(g_step_calls, 100);
    CHECK_EQ(P.steps_run, 100);
    P.inactive = true;
    core_advance(&P, 110);
    CHECK_EQ(g_step_calls, 110);
    CHECK_EQ(P.passes, 100);
}

int main(void) {
    test_basics();
    test_frame_hook();
    test_max_late();
    test_input_rule();
    test_short_press();
    test_focus();
    test_mouse_merge();
    test_step_hook();
    test_jump_equivalence();
    return test_report("test_loop");
}
