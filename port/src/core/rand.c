/* MSVC rand (M1). See rand.h. */
#include "rand.h"

void msvc_srand(MsvcRand *r, uint32_t seed) {
    /* Z:0x40e38c */
    r->state = seed;
    r->calls = 0;
}

int32_t msvc_rand(MsvcRand *r) {
    /* Z:0x40e396 */
    r->state = r->state * 214013u + 2531011u;
    r->calls++;
    return (int32_t)((r->state >> 16) & 0x7fffu);
}
