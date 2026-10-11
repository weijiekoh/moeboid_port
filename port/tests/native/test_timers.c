/* Timer tests (M1): analysis/timing.md section 5 table and start-sequence end times, fire rule
 * (2.3), Start order and skip-after-remove (2.4), pause and game clock (2.1, 2.5). */
#include "core/port.h"
#include "test.h"

static Port P;

/* ---- fire log ---- */
typedef struct Fire {
    char name;
    uint64_t k;
    uint32_t now, elapsed1, elapsed2, userdata;
} Fire;
static Fire g_fires[200000];
static int g_nfires;

static void log_fire(EngineTimer *t, const TimerEvent *ev) {
    if (g_nfires < (int)(sizeof g_fires / sizeof g_fires[0]))
        g_fires[g_nfires++] = (Fire){(char)(uintptr_t)t->ctx, P.clock.k, ev->now, ev->elapsed1, ev->elapsed2, ev->userdata};
}

static void reset(uint32_t step_index) {
    core_init(&P, step_index, 0, 1);
    P.no_jump = true;
    g_nfires = 0;
}

/* Manual clock: set the step and run one timer pass. */
static void pass_at(uint64_t k) {
    P.clock.k = k;
    timersys_run(&P.timers);
}

/* Fixed-point decimal of num/den with d decimals, rounded half up. */
static void fixed(uint64_t num, uint64_t den, int d, char *out) {
    uint64_t scale = 1;
    for (int i = 0; i < d; i++) scale *= 10;
    uint64_t v = (num * scale * 2 + den) / (den * 2);
    if (d) sprintf(out, "%" PRIu64 ".%0*" PRIu64, v / scale, d, v % scale);
    else sprintf(out, "%" PRIu64, v);
}

/* ---- timing.md section 5 table ---- */
typedef struct Row {
    uint32_t step_index;
    const char *ms[3]; /* mean interval as printed for 20, 50, 100 ms timers */
    const char *hz[2]; /* rate as printed for 20 and 50 ms timers */
} Row;

static void test_table(void) {
    static const Row rows[] = {
        {0, {"20.000", "50.0", "100"}, {"50.0", "20.0"}},
        {3, {"20.03", "50.07", "100.14"}, {"49.93", "19.97"}},
        {1, {"31.25", "62.5", "109.4"}, {"32.0", "16.0"}},
        {2, {"54.9", "54.9", "109.9"}, {"18.2", "18.2"}},
    };
    static const uint32_t periods[3] = {20, 50, 100};
    for (size_t r = 0; r < sizeof rows / sizeof rows[0]; r++) {
        for (int pi = 0; pi < 3; pi++) {
            reset(rows[r].step_index);
            P.no_jump = false;
            EngineTimer t;
            timer_init(&t, 0, periods[pi], log_fire, (void *)(uintptr_t)'T');
            timer_start(&P.timers, &t); /* Start at clock step 0 (time 0) */
            /* drive with host frames of 16/17 ms (60 Hz) for 200 s of wall time */
            uint32_t wall = 5000;
            core_advance(&P, wall);
            for (int f = 0; f < 12000; f++) {
                wall += (f % 3 == 2) ? 16 : 17;
                core_advance(&P, wall);
            }
            CHECK(g_nfires > 100);
            /* constant number of clock steps per fire */
            uint64_t m = g_fires[0].k;
            int same = 1;
            for (int i = 1; i < g_nfires; i++) same &= (g_fires[i].k - g_fires[i - 1].k) == m;
            CHECK(same);
            /* mean interval = m * S = m * num / den ms, printed as in timing.md */
            uint64_t num = m * P.clock.num, den = P.clock.den;
            const char *want = rows[r].ms[pi];
            const char *dot = strchr(want, '.');
            int d = dot ? (int)strlen(dot + 1) : 0;
            char got[32];
            fixed(num, den, d, got);
            CHECK_STR(got, want);
            /* measured mean from the fire times agrees with m * S to < 1 ms / (n - 1) */
            uint64_t span = g_fires[g_nfires - 1].now - g_fires[0].now;
            uint64_t n1 = (uint64_t)g_nfires - 1;
            CHECK(span * den + den > n1 * num && span * den < n1 * num + den);
            if (pi < 2) {
                want = rows[r].hz[pi];
                dot = strchr(want, '.');
                d = dot ? (int)strlen(dot + 1) : 0;
                fixed(1000 * den, num, d, got);
                CHECK_STR(got, want);
            }
            /* every interval in ms is floor or ceil of m * S */
            int ok = 1;
            for (int i = 1; i < g_nfires; i++) {
                uint64_t iv = g_fires[i].now - g_fires[i - 1].now;
                ok &= iv * den >= num - (num % den ? den : 0) && iv * den <= num + (num % den ? den : 0);
            }
            CHECK(ok);
            timer_release(&P.timers, &t);
        }
    }
}

/* ---- start sequence end: 100 ms timer, ends at the first fire with elapsed > 3000
 * (G:0x100045a0; timing.md section 5: 3100 / 3004 / 3062 / 3075 ms) ---- */
static uint32_t g_end;
static void start_seq_cb(EngineTimer *t, const TimerEvent *ev) {
    if (ev->elapsed2 > 3000 && !g_end) {
        g_end = ev->elapsed2;
        timer_stop(&P.timers, t);
    }
}

static void test_start_sequence(void) {
    static const struct {
        uint32_t idx, end;
    } want[] = {{0, 3100}, {3, 3004}, {1, 3062}, {2, 3075}};
    for (size_t i = 0; i < 4; i++) {
        reset(want[i].idx);
        P.no_jump = false;
        g_end = 0;
        EngineTimer t;
        timer_init(&t, 0, 100, start_seq_cb, NULL);
        timer_start(&P.timers, &t);
        core_advance(&P, 1000);
        for (uint32_t w = 1000; w < 1000 + 5000; w += 16) core_advance(&P, w);
        CHECK_EQ(g_end, want[i].end);
        CHECK_EQ(P.timers.count, 0);
    }
}

/* ---- fire rule (timing.md 2.3) ---- */
static void test_fire_rule(void) {
    reset(0);
    EngineTimer a;
    timer_init(&a, 0xdead, 20, log_fire, (void *)(uintptr_t)'A');
    P.clock.k = 5;
    timer_start(&P.timers, &a);
    CHECK_EQ(a.start, 5);
    CHECK_EQ(a.last, 5);
    pass_at(5); /* never at Start */
    CHECK_EQ(g_nfires, 0);
    pass_at(24); /* now - last = 19 < 20 */
    CHECK_EQ(g_nfires, 0);
    pass_at(25); /* = period: fires */
    CHECK_EQ(g_nfires, 1);
    CHECK_EQ(g_fires[0].now, 25);
    CHECK_EQ(g_fires[0].elapsed1, 20);
    CHECK_EQ(g_fires[0].elapsed2, 20);
    CHECK_EQ(g_fires[0].userdata, 0xdead);
    CHECK_EQ(a.last, 25);
    /* late: one call only, last = now (phase moves, no catch-up) */
    pass_at(100);
    CHECK_EQ(g_nfires, 2);
    CHECK_EQ(g_fires[1].now, 100);
    CHECK_EQ(g_fires[1].elapsed2, 95);
    pass_at(101);
    pass_at(119);
    CHECK_EQ(g_nfires, 2);
    pass_at(120);
    CHECK_EQ(g_nfires, 3);
    timer_release(&P.timers, &a);
    CHECK_EQ(P.timers.count, 0);

    /* unsigned 32-bit wrap of the clock (49.7 days) */
    reset(0);
    uint64_t k0 = 0x100000000ull - 30; /* real time 2^32 - 30 */
    P.clock.k = k0;
    timer_init(&a, 0, 20, log_fire, (void *)(uintptr_t)'W');
    timer_start(&P.timers, &a);
    for (uint64_t k = k0 + 1; k <= k0 + 100; k++) pass_at(k);
    CHECK_EQ(g_nfires, 5);
    CHECK_EQ(g_fires[0].now, 0xfffffff6u); /* 2^32 - 10 */
    CHECK_EQ(g_fires[1].now, 10);          /* wrapped */
    CHECK_EQ(g_fires[1].elapsed2, 40);
    CHECK_EQ(g_fires[4].elapsed2, 100);
    timer_release(&P.timers, &a);

    /* period 0 fires at every pass; the subsystem fields of Z:0x4271c0 */
    reset(0);
    P.clock.k = 7;
    timersys_init(&P.timers, &P.clock);
    CHECK_EQ(P.timers.start_tick, 7);
    CHECK_EQ(P.timers.game_base, 7);
    timer_init(&a, 0, 0, log_fire, (void *)(uintptr_t)'Z');
    timer_start(&P.timers, &a);
    pass_at(7);
    pass_at(7);
    CHECK_EQ(g_nfires, 2);
    timer_release(&P.timers, &a);
}

/* ---- Start order, Start ignored, Restart (timing.md 2.2, 2.4) ---- */
static void test_order(void) {
    reset(0);
    EngineTimer a, b;
    timer_init(&a, 0, 20, log_fire, (void *)(uintptr_t)'A');
    timer_init(&b, 0, 20, log_fire, (void *)(uintptr_t)'B');
    timer_start(&P.timers, &a);
    timer_start(&P.timers, &b);
    pass_at(20);
    CHECK_EQ(g_nfires, 2);
    CHECK(g_fires[0].name == 'A' && g_fires[1].name == 'B');
    /* Stop + Start moves A to the end */
    timer_stop(&P.timers, &a);
    CHECK(!a.started);
    timer_start(&P.timers, &a); /* start = last = 20 */
    pass_at(40);
    CHECK_EQ(g_nfires, 4);
    CHECK(g_fires[2].name == 'B' && g_fires[3].name == 'A');
    CHECK_EQ(g_fires[3].elapsed2, 20);
    /* Start on a started timer: nothing (phase kept) */
    P.clock.k = 50;
    timer_start(&P.timers, &a);
    CHECK_EQ(P.timers.count, 2);
    CHECK_EQ(a.last, 40);
    CHECK_EQ(a.start, 20);
    pass_at(60);
    CHECK_EQ(g_nfires, 6);
    /* Restart: start = last = now, no second list entry */
    P.clock.k = 65;
    timer_restart(&P.timers, &a);
    CHECK_EQ(P.timers.count, 2);
    CHECK_EQ(a.start, 65);
    pass_at(80); /* B fires (last 60); A does not (65 + 20 = 85) */
    CHECK_EQ(g_nfires, 7);
    CHECK(g_fires[6].name == 'B');
    pass_at(85);
    CHECK_EQ(g_nfires, 8);
    CHECK(g_fires[7].name == 'A' && g_fires[7].elapsed2 == 20);
    /* Restart of a stopped timer starts it */
    timer_stop(&P.timers, &b);
    P.clock.k = 90;
    timer_restart(&P.timers, &b);
    CHECK(b.started && P.timers.count == 2 && b.start == 90);
    /* Remove of a timer not in the list returns 0x14 */
    EngineTimer c;
    timer_init(&c, 0, 20, log_fire, NULL);
    CHECK_EQ(timersys_remove(&P.timers, &c), 0x14);
    timer_release(&P.timers, &a);
    timer_release(&P.timers, &b);
}

/* ---- callbacks that change the list during a pass (timing.md 2.4) ---- */
static EngineTimer ta, tb, tc, td;
static int g_mode;

static void cb_mut(EngineTimer *t, const TimerEvent *ev) {
    log_fire(t, ev);
    char n = (char)(uintptr_t)t->ctx;
    if (g_mode == 1 && n == 'A') timer_stop(&P.timers, &ta);      /* A stops itself */
    if (g_mode == 2 && n == 'A') timer_stop(&P.timers, &tc);      /* A stops a later timer */
    if (g_mode == 3 && n == 'C') timer_stop(&P.timers, &ta);      /* C stops an earlier timer */
    if (g_mode == 4 && n == 'A' && !td.started) timer_start(&P.timers, &td); /* start in callback */
    if (g_mode == 5 && n == 'A') timer_release(&P.timers, &ta);   /* release in own callback */
    if (g_mode == 6 && n == 'A') timersys_set_paused(&P.timers, true); /* pause inside a pass */
}

static void setup3(int mode) {
    reset(0);
    g_mode = mode;
    timer_init(&ta, 0, 20, cb_mut, (void *)(uintptr_t)'A');
    timer_init(&tb, 0, 20, cb_mut, (void *)(uintptr_t)'B');
    timer_init(&tc, 0, 20, cb_mut, (void *)(uintptr_t)'C');
    timer_init(&td, 0, 20, cb_mut, (void *)(uintptr_t)'D');
    timer_start(&P.timers, &ta);
    timer_start(&P.timers, &tb);
    timer_start(&P.timers, &tc);
}

static void names(char *out) {
    for (int i = 0; i < g_nfires; i++) out[i] = g_fires[i].name;
    out[g_nfires] = 0;
}

static void test_mutation(void) {
    char s[64];
    /* A stops itself: B shifts into A's index and is skipped in this pass */
    setup3(1);
    pass_at(20);
    names(s);
    CHECK_STR(s, "AC");
    pass_at(21); /* B: now - last = 21 >= 20 */
    names(s);
    CHECK_STR(s, "ACB");
    pass_at(40);
    names(s);
    CHECK_STR(s, "ACBC");
    pass_at(41);
    names(s);
    CHECK_STR(s, "ACBCB");
    /* A stops a later timer C: B is polled normally, C is gone */
    setup3(2);
    pass_at(20);
    names(s);
    CHECK_STR(s, "AB");
    CHECK_EQ(P.timers.count, 2);
    /* C stops an earlier timer A: C moves to index 1; the loop ends */
    setup3(3);
    pass_at(20);
    names(s);
    CHECK_STR(s, "ABC");
    CHECK_EQ(P.timers.count, 2);
    pass_at(40);
    names(s);
    CHECK_STR(s, "ABCBC");
    /* a timer started in a callback is polled in the same pass but cannot fire */
    setup3(4);
    pass_at(20);
    names(s);
    CHECK_STR(s, "ABC");
    CHECK_EQ(P.timers.count, 4);
    CHECK_EQ(td.start, 20);
    pass_at(40);
    names(s);
    CHECK_STR(s, "ABCABCD");
    /* release inside the own callback: no write of `last` afterwards (port guard) */
    setup3(5);
    ta.last = 0;
    pass_at(20);
    names(s);
    CHECK_STR(s, "AC");
    CHECK_EQ(ta.last, 0);
    /* pause inside a pass: later game timers of the same pass do not run */
    setup3(6);
    pass_at(20);
    names(s);
    CHECK_STR(s, "A");
    for (int i = 0; i < 4; i++) timer_release(&P.timers, i == 0 ? &ta : i == 1 ? &tb : i == 2 ? &tc : &td);
}

/* ---- pause, real clock and game clock (timing.md 2.1, 2.5) ---- */
static void test_pause(void) {
    reset(0);
    EngineTimer g, r;
    timer_init(&g, 0, 20, log_fire, (void *)(uintptr_t)'G');
    timer_init(&r, 0, 20, log_fire, (void *)(uintptr_t)'R');
    timer_set_realtime(&r, true);
    CHECK(timer_get_realtime(&r) && !timer_get_realtime(&g));
    timer_start(&P.timers, &g);
    timer_start(&P.timers, &r);
    for (uint64_t k = 1; k <= 100; k++) pass_at(k);
    CHECK_EQ(g_nfires, 10);
    timersys_set_paused(&P.timers, true); /* at real 100 */
    CHECK(timersys_is_paused(&P.timers));
    CHECK_EQ(P.timers.pause_real, 100);
    int before = g_nfires;
    for (uint64_t k = 101; k <= 149; k++) pass_at(k);
    /* GetGameTime keeps counting while paused (Z:0x427510 reads GetTickCount - game_base) */
    P.clock.k = 150;
    CHECK_EQ(timersys_game_time(&P.timers), 150);
    CHECK_EQ(timersys_real_time(&P.timers), 150);
    /* a game timer started while paused takes the running game time ... */
    EngineTimer s;
    timer_init(&s, 0, 20, log_fire, (void *)(uintptr_t)'S');
    timer_start(&P.timers, &s);
    CHECK_EQ(s.start, 150);
    for (uint64_t k = 150; k <= 199; k++) pass_at(k);
    int rf = 0, gf = 0;
    for (int i = before; i < g_nfires; i++) rf += g_fires[i].name == 'R', gf += g_fires[i].name != 'R';
    CHECK_EQ(rf, 4); /* real-time timer runs while paused: 120, 140, 160, 180 */
    CHECK_EQ(gf, 0); /* game timers do not */
    P.clock.k = 200;
    timersys_set_paused(&P.timers, false); /* game_base += 200 - 100 */
    CHECK_EQ(P.timers.game_base, 100);
    CHECK_EQ(timersys_game_time(&P.timers), 100); /* no jump: game time = time at pause */
    before = g_nfires;
    pass_at(200);
    /* ... so after resume now - last is negative (huge unsigned) and S fires at the first pass
     * with elapsed = now - start = -50 (inferred from Z:0x427510, Z:0x427490, Z:0x413510). */
    CHECK_EQ(g_nfires, before + 2); /* R (200 - 180 = 20) and S */
    CHECK(g_fires[before + 1].name == 'S');
    CHECK_EQ(g_fires[before + 1].now, 100);
    CHECK_EQ(g_fires[before + 1].elapsed2, (uint32_t)-50);
    /* G: last = game 100, fires at game 120 = real 220 */
    for (uint64_t k = 201; k <= 220; k++) pass_at(k);
    int found = 0;
    for (int i = before; i < g_nfires; i++)
        if (g_fires[i].name == 'G') {
            found++;
            CHECK_EQ(g_fires[i].k, 220);
            CHECK_EQ(g_fires[i].now, 120);
            CHECK_EQ(g_fires[i].elapsed2, 120);
        }
    CHECK_EQ(found, 1);
    /* SetPaused with the current value: no change */
    uint32_t gb = P.timers.game_base;
    timersys_set_paused(&P.timers, false);
    CHECK_EQ(P.timers.game_base, gb);
    timer_release(&P.timers, &g);
    timer_release(&P.timers, &r);
    timer_release(&P.timers, &s);
}

int main(void) {
    test_table();
    test_start_sequence();
    test_fire_rule();
    test_order();
    test_mutation();
    test_pause();
    return test_report("test_timers");
}
