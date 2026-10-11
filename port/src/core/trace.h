/* Lockstep trace buffer (M1; port-design.md section 9).
 *
 * Same hashes as analysis/verification/harness/mock.py: per tick, the call lines are joined
 * with "\n" and hashed with SHA-256; the first 16 hex digits are the tick hash
 * (`call_log_sha256_16` in analysis/verification/logs/run_*.ticks.tsv). An optional game-state digest text gives the
 * first 12 hex digits of its SHA-256 (`game_state_sha256_12`), "-" when absent.
 * The caller (M4) formats each line exactly as mock.py does (`canon`, `canon_args`).
 *
 * Output through rt_host_trace, one record per call, each ending in "\n":
 *   TRACE_HASH: at tick end   "<tick>\t<ms>\t<calls>\t<hash16>\t<state12 or ->"  (ticks.tsv row)
 *   TRACE_FULL: also          "T<tick> ms=<ms> <what>" at tick begin, "  <line>" per line,
 *                             "  state <digest>" at tick end (the run.py log format)
 * Rows start with a digit; log records start with 'T' or ' '. */
#ifndef MOEBOID_CORE_TRACE_H
#define MOEBOID_CORE_TRACE_H

#include "../rt/rt.h"

enum { TRACE_OFF = 0, TRACE_HASH = 1, TRACE_FULL = 2 };

typedef struct Trace {
    uint32_t mode;
    uint32_t tick;  /* ticks begun since trace_init */
    uint32_t ms;    /* ms value given to the current tick */
    uint32_t lines; /* lines in the current tick */
    bool open;
    RtSha256 sha;
    char last_hash[17];
    char last_state[13];
} Trace;

void trace_init(Trace *t);
void trace_set_mode(Trace *t, uint32_t mode);
static inline bool trace_on(const Trace *t) { return t->mode != TRACE_OFF; }
/* Starts tick number t->tick + 1. An open tick is ended first (no state). */
void trace_begin_tick(Trace *t, uint32_t ms, const char *what);
/* One call line (without newline). Ignored when no tick is open or the trace is off. */
void trace_line(Trace *t, const char *line, uint32_t len);
void trace_linef(Trace *t, const char *fmt, ...) __attribute__((format(printf, 2, 3)));
/* Ends the tick; state may be NULL. Returns the 16-digit hash (also in t->last_hash). */
const char *trace_end_tick(Trace *t, const char *state);

#endif
