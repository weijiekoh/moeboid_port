/* Engine timer list, fire rule, real and game clock, pause (M1; analysis/timing.md 2.1-2.5, 8).
 *
 * Copies of the original ZapSpot.exe routines (addresses Z:0x...):
 *   TimerSys  = timer subsystem object, ctor Z:0x4271c0, vtable Z:0x42f058
 *   EngineTimer = timer object, ctor Z:0x413440, vtable Z:0x42ea40
 * All times are uint32 milliseconds with unsigned wrap, as GetTickCount values.
 *
 * Ownership: the creator owns each EngineTimer (static, embedded or rt_malloc). The list holds
 * pointers only. Call timer_release before the memory goes away (the original destructor
 * Z:0x4134b0 removes a started timer from the list). */
#ifndef MOEBOID_CORE_TIMERS_H
#define MOEBOID_CORE_TIMERS_H

#include "clock.h"

/* Event record that Z:0x413510 passes to the callback (timing.md 2.3). */
typedef struct TimerEvent {
    uint32_t userdata; /* ev+0x00 = timer +0x24 */
    uint32_t elapsed1; /* ev+0x04 = now - start */
    uint32_t elapsed2; /* ev+0x08 = now - start (the game reads this field) */
    uint32_t now;      /* ev+0x0c = clock value of this poll */
} TimerEvent;

typedef struct EngineTimer EngineTimer;
typedef void (*TimerFn)(EngineTimer *t, const TimerEvent *ev);

struct EngineTimer {
    uint32_t period;   /* +0x10 ms */
    uint32_t last;     /* +0x14 clock value of the last fire (or of Start) */
    uint32_t start;    /* +0x18 clock value of Start */
    TimerFn callback;  /* +0x1c */
    bool started;      /* +0x20 */
    uint32_t userdata; /* +0x24 (guest value or host cookie; copied into ev+0x00) */
    bool realtime;     /* +0x28 run while paused; also selects the real clock */
    void *ctx;         /* host context for the callback (port only, not in the original) */
};

typedef struct TimerSys {
    const VClock *clock;
    EngineTimer **items; /* +0x08 array in Start order */
    uint32_t count;      /* +0x0c */
    uint32_t cap;        /* +0x04 (grows by 50 as the original) */
    uint32_t start_tick; /* +0x10 GetTickCount at construction */
    uint32_t pause_real; /* +0x14 real time at SetPaused(1) */
    uint32_t game_base;  /* +0x18 GetTickCount base of the game clock */
    bool paused;         /* +0x1c */
    EngineTimer *polling; /* timer whose callback runs now (port only, see timer_release) */
    uint32_t polls;      /* statistics: polls and fires since init (port only) */
    uint32_t fires;
} TimerSys;

/* Z:0x4271c0: start_tick = game_base = GetTickCount now. */
void timersys_init(TimerSys *ts, const VClock *clock);
void timersys_free(TimerSys *ts);
/* Z:0x4272a0 AddTimer: append (no duplicate check). */
void timersys_add(TimerSys *ts, EngineTimer *t);
/* Z:0x4272f0 RemoveTimer: remove the first match, shift the rest down. 0 or 0x14 (not found). */
uint32_t timersys_remove(TimerSys *ts, EngineTimer *t);
/* Z:0x4273d0 RunTimers: one pass in array order; count and paused re-read per index. */
void timersys_run(TimerSys *ts);
/* Z:0x427490 SetPaused. */
void timersys_set_paused(TimerSys *ts, bool paused);
/* Z:0x427530 IsPaused. */
bool timersys_is_paused(const TimerSys *ts);
/* Z:0x4274f0 GetRealTime = GetTickCount - start_tick. */
uint32_t timersys_real_time(const TimerSys *ts);
/* Z:0x427510 GetGameTime = GetTickCount - game_base. Note: it keeps counting while paused;
 * SetPaused(0) moves game_base, so the value falls back to the pause time at resume. */
uint32_t timersys_game_time(const TimerSys *ts);
/* Smallest step j > k at which a pass can fire any timer of the list, with the current state
 * (paused flag, timer fields). UINT64_MAX if none can fire. Port only: exact lower bound for
 * the jump optimisation of timing.md 9 rule 3. */
uint64_t timersys_next_fire_step(const TimerSys *ts, uint64_t k);

/* Z:0x413440 ctor(userdata, period, callback): not started, game clock. last = start = 0. */
void timer_init(EngineTimer *t, uint32_t userdata, uint32_t period, TimerFn cb, void *ctx);
/* Z:0x413510 Poll: fire if (uint32)(now - last) >= period; last = now after the callback. */
void timer_poll(TimerSys *ts, EngineTimer *t);
/* Z:0x413580 Start: if started, nothing; else started = 1, AddTimer, start = last = now. */
void timer_start(TimerSys *ts, EngineTimer *t);
/* Z:0x4135d0 Stop: started = 0, RemoveTimer. */
void timer_stop(TimerSys *ts, EngineTimer *t);
/* Z:0x4135f0 Restart: start = last = now, then Start. */
void timer_restart(TimerSys *ts, EngineTimer *t);
/* Z:0x4173e0 SetRunWhilePaused (also selects the real clock). */
void timer_set_realtime(EngineTimer *t, bool realtime);
/* Z:0x413570 GetRunWhilePaused. */
bool timer_get_realtime(const EngineTimer *t);
/* Z:0x4134b0 destructor part: RemoveTimer if started. Call it before the timer memory is freed,
 * also from inside the timer's own callback: the poll then does not write `last` afterwards. */
void timer_release(TimerSys *ts, EngineTimer *t);

#endif
