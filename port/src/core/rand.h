/* MSVC CRT rand as a reusable state (M1; analysis/interface.md 7.3, timing.md 3.1).
 * Engine instance: srand Z:0x40e38c, rand Z:0x40e396, static state Z:0x434100 (file value 1).
 * The game's own CRT rand (G:0x10005639) runs as guest code in the CPU; it does not use this. */
#ifndef MOEBOID_CORE_RAND_H
#define MOEBOID_CORE_RAND_H

#include "../rt/rt.h"

typedef struct MsvcRand {
    uint32_t state;
    uint32_t calls; /* rand calls since the last srand (for traces) */
} MsvcRand;

/* State before any srand call (file value of Z:0x434100). */
#define MSVC_RAND_DEFAULT_STATE 1u

void msvc_srand(MsvcRand *r, uint32_t seed);
/* state = state * 214013 + 2531011 (mod 2^32); return (state >> 16) & 0x7fff. */
int32_t msvc_rand(MsvcRand *r);

#endif
