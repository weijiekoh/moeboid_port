/* Virtual clock (M1). See clock.h. */
#include "clock.h"

static const uint32_t STEP_NUM[VCLOCK_STEP_COUNT] = {1u, 125u, 2197u, 6259u};
static const uint32_t STEP_DEN[VCLOCK_STEP_COUNT] = {1u, 8u, 40u, 625u};

void vclock_init(VClock *c, uint32_t step_index) {
    if (step_index >= VCLOCK_STEP_COUNT) step_index = 0;
    c->k = 0;
    c->index = step_index;
    c->num = STEP_NUM[step_index];
    c->den = STEP_DEN[step_index];
}

uint64_t vclock_ms_at(const VClock *c, uint64_t k) { return k * c->num / c->den; }

uint32_t vclock_ticks(const VClock *c) { return (uint32_t)vclock_ms_at(c, c->k); }

uint64_t vclock_steps_at(const VClock *c, uint64_t ms) { return ms * c->den / c->num; }

uint64_t vclock_first_step_at_or_after(const VClock *c, int64_t t) {
    if (t <= 0) return 0;
    return ((uint64_t)t * c->den + c->num - 1) / c->num;
}
