/* Engine timers (M1). Rules: analysis/timing.md 2.1-2.5 and 8. See timers.h. */
#include "timers.h"

static uint32_t tick_now(const TimerSys *ts) { return vclock_ticks(ts->clock); }

void timersys_init(TimerSys *ts, const VClock *clock) {
    rt_memset(ts, 0, sizeof *ts);
    ts->clock = clock;
    /* Z:0x4271c0: one GetTickCount, stored in +0x18 and +0x10. */
    uint32_t now = tick_now(ts);
    ts->game_base = now;
    ts->start_tick = now;
}

void timersys_free(TimerSys *ts) {
    rt_free(ts->items);
    ts->items = NULL;
    ts->count = ts->cap = 0;
}

void timersys_add(TimerSys *ts, EngineTimer *t) {
    /* Z:0x4272a0 */
    if (ts->count >= ts->cap) {
        uint32_t cap = ts->count + 50u;
        EngineTimer **p = (EngineTimer **)rt_realloc(ts->items, cap * sizeof *p);
        if (!p) rt_panic("timersys_add: out of memory");
        ts->items = p;
        ts->cap = cap;
    }
    ts->items[ts->count++] = t;
}

uint32_t timersys_remove(TimerSys *ts, EngineTimer *t) {
    /* Z:0x4272f0 */
    for (uint32_t i = 0; i < ts->count; i++) {
        if (ts->items[i] == t) {
            for (uint32_t j = i + 1; j < ts->count; j++) ts->items[j - 1] = ts->items[j];
            ts->count--;
            return 0;
        }
    }
    return 0x14;
}

void timersys_run(TimerSys *ts) {
    /* Z:0x4273d0: count, paused and the array are read again at each index. A callback that
     * removes an earlier or the current timer shifts the array, so the next timer is skipped in
     * this pass (timing.md 2.4). */
    for (uint32_t i = 0; i < ts->count; i++) {
        EngineTimer *t = ts->items[i];
        if (!ts->paused) timer_poll(ts, t);
        else if (t->realtime) timer_poll(ts, t);
    }
}

void timersys_set_paused(TimerSys *ts, bool paused) {
    /* Z:0x427490 */
    if (paused == ts->paused) return;
    if (!paused) {
        uint32_t real = timersys_real_time(ts);
        ts->game_base += real - ts->pause_real;
    } else {
        ts->pause_real = timersys_real_time(ts);
    }
    ts->paused = !ts->paused;
}

bool timersys_is_paused(const TimerSys *ts) { return ts->paused; }

uint32_t timersys_real_time(const TimerSys *ts) { return tick_now(ts) - ts->start_tick; }

uint32_t timersys_game_time(const TimerSys *ts) { return tick_now(ts) - ts->game_base; }

uint64_t timersys_next_fire_step(const TimerSys *ts, uint64_t k) {
    uint64_t best = UINT64_MAX;
    uint64_t tk = vclock_ms_at(ts->clock, k);
    for (uint32_t i = 0; i < ts->count; i++) {
        const EngineTimer *t = ts->items[i];
        if (ts->paused && !t->realtime) continue; /* cannot fire until the pause changes */
        uint32_t base = t->realtime ? ts->start_tick : ts->game_base;
        uint32_t d0 = (uint32_t)tk - base - t->last; /* (now - last) at step k */
        uint64_t j;
        if (d0 >= t->period) j = k + 1;
        else {
            /* d grows with the clock and reaches period before it can wrap. */
            uint64_t need = tk + (t->period - d0);
            j = vclock_first_step_at_or_after(ts->clock, (int64_t)need);
            if (j <= k) j = k + 1;
        }
        if (j < best) best = j;
    }
    return best;
}

void timer_init(EngineTimer *t, uint32_t userdata, uint32_t period, TimerFn cb, void *ctx) {
    /* Z:0x413440; +0x14 and +0x18 are not written by the original constructor (0 here). */
    rt_memset(t, 0, sizeof *t);
    t->userdata = userdata;
    t->period = period;
    t->callback = cb;
    t->ctx = ctx;
}

static uint32_t timer_clock(const TimerSys *ts, const EngineTimer *t) {
    return t->realtime ? timersys_real_time(ts) : timersys_game_time(ts);
}

void timer_poll(TimerSys *ts, EngineTimer *t) {
    /* Z:0x413510 (listing Z:0x413519..Z:0x413563) */
    uint32_t now = timer_clock(ts, t);
    ts->polls++;
    if ((uint32_t)(now - t->last) >= t->period) {
        TimerEvent ev;
        ev.userdata = t->userdata;
        ev.elapsed1 = now - t->start;
        ev.elapsed2 = ev.elapsed1;
        ev.now = now;
        ts->fires++;
        EngineTimer *outer = ts->polling;
        ts->polling = t;
        if (t->callback) t->callback(t, &ev);
        /* After the callback, as the original. Port guard: skip the write when the callback
         * released the timer (its memory may be free or reused now). */
        if (ts->polling == t) t->last = now;
        ts->polling = outer;
    }
}

void timer_start(TimerSys *ts, EngineTimer *t) {
    /* Z:0x413580 */
    if (t->started) return;
    t->started = true;
    timersys_add(ts, t);
    t->start = timer_clock(ts, t);
    t->last = t->start;
}

void timer_stop(TimerSys *ts, EngineTimer *t) {
    /* Z:0x4135d0 */
    t->started = false;
    timersys_remove(ts, t);
}

void timer_restart(TimerSys *ts, EngineTimer *t) {
    /* Z:0x4135f0 */
    t->start = timer_clock(ts, t);
    t->last = t->start;
    timer_start(ts, t);
}

void timer_set_realtime(EngineTimer *t, bool realtime) { t->realtime = realtime; } /* Z:0x4173e0 */

bool timer_get_realtime(const EngineTimer *t) { return t->realtime; } /* Z:0x413570 */

void timer_release(TimerSys *ts, EngineTimer *t) {
    /* Z:0x4134b0 */
    if (t->started) timersys_remove(ts, t);
    t->started = false;
    if (ts->polling == t) ts->polling = NULL;
}
