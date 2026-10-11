/* Virtual clock and GetTickCount model (M1; analysis/timing.md sections 5 and 9).
 *
 * The clock counts steps k (uint64). One step is S = num/den milliseconds, an exact fraction,
 * so there is no floating-point drift. The emulated GetTickCount at step k is floor(k * S),
 * truncated to 32 bits (it wraps as the original after 49.7 days).
 *
 * Step table (index = port_init clock_step_index):
 *   0: 1 ms          (decision 2 default; Windows 2000 coded rate)
 *   1: 15.625 ms     = 125/8    (typical Windows XP)
 *   2: 54.925 ms     = 2197/40  (Windows 9x; decision 2 says "54.9 ms", timing.md section 5
 *                                uses 54.925, recorded here as the exact value)
 *   3: 10.0144 ms    = 6259/625 (Windows NT/2000 single CPU; timing.md section 5 table row,
 *                                not a user setting; kept for the table tests)
 * An index out of range selects index 0. */
#ifndef MOEBOID_CORE_CLOCK_H
#define MOEBOID_CORE_CLOCK_H

#include "../rt/rt.h"

#define VCLOCK_STEP_COUNT 4u

typedef struct VClock {
    uint64_t k;   /* steps done; step 0 = time of port_init */
    uint32_t num; /* step length = num/den ms */
    uint32_t den;
    uint32_t index;
} VClock;

void vclock_init(VClock *c, uint32_t step_index);
/* GetTickCount model: floor(k * num / den) mod 2^32. */
uint32_t vclock_ticks(const VClock *c);
/* floor(k * num / den) without the 32-bit truncation. */
uint64_t vclock_ms_at(const VClock *c, uint64_t k);
/* Number of whole steps done at wall time `ms` (ms >= 0): floor(ms * den / num). */
uint64_t vclock_steps_at(const VClock *c, uint64_t ms);
/* Smallest step j with j * num / den >= t (exact rational compare); t may be negative.
 * For an integer t this is also the first step with floor(j * num / den) >= t. */
uint64_t vclock_first_step_at_or_after(const VClock *c, int64_t t);

#endif
