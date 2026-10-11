/* Port state and core main loop (M1; analysis/timing.md 8 and 9, port-design.md section 6).
 *
 * One global Port (src/main.c, `g_port`) holds all state. Native tests create their own Port.
 *
 * Main loop model: the original is a discrete-event system on the GetTickCount clock
 * (Z:0x404a30). The port runs one "step" per clock step k:
 *   1. deliver every queued input event that is due (time stamp <= k * S), in arrival order
 *      (all messages before the timer pass, timing.md 1.1 and 9 rule 5);
 *   2. call the `step` hooks;
 *   3. if not inactive: one timer pass (Z:0x4273d0).
 * core_advance(wall_ms) runs every step up to floor((wall_ms - wall_base) / S). When more than
 * PORT_MAX_LATE_MS of steps are pending, it skips to the last one (one late pass, timing.md 9
 * rule 7). When no `step` hook is installed, it jumps over steps in which no input is due and no
 * timer can fire (rule 3); test_loop.c proves the same results with and without the jump.
 *
 * Hook registration (M4, M5): define a strong
 *     void port_hooks_engine(PortHooks *h)   (M4, src/engine/)
 *     void port_hooks_shell(PortHooks *h)    (M5, src/shell/)
 * The core has weak empty defaults. core_start calls engine then shell, then every init hook in
 * that order. Every other hook is called for slot 0 (engine) then slot 1 (shell). */
#ifndef MOEBOID_CORE_PORT_H
#define MOEBOID_CORE_PORT_H

#include "../rt/rt.h"
#include "clock.h"
#include "input.h"
#include "rand.h"
#include "storage.h"
#include "timers.h"
#include "trace.h"

#define PORT_W 800u
#define PORT_H 572u
/* Frame buffer bytes R, G, B, A of the background (#3333cc, decision 9). */
#define PORT_BG_RGBA 0xffcc3333u /* little-endian uint32 of bytes 33 33 cc ff */
#define PORT_SOUND_QUEUE_MAX 256u
#define PORT_MAX_LATE_MS 250u

/* port_advance result bits (port-design.md section 6). */
enum { PORT_ADV_FRAME = 1u, PORT_ADV_SOUND = 2u, PORT_ADV_STORAGE = 4u };

/* One sound command for the host (port_sound_cmds). at_ms = clock ms (GetTickCount model) of
 * the step that made the command; wall time of that step = wall_base + at_ms (+ < 1 step). */
typedef struct PortSoundCmd {
    uint32_t op;
    uint32_t sound_id;
    uint32_t voice;
    uint32_t at_ms;
} PortSoundCmd;

typedef struct Port Port;

typedef struct PortHooks {
    const char *name;
    /* Engine start at step 0. Return 0 for success; core_start returns the first non-zero. */
    int32_t (*init)(Port *p, const uint8_t *pack, uint32_t pack_len, const uint8_t *gam, uint32_t gam_len);
    /* One delivered input event, after the key-state table update (WndProc dispatch). */
    void (*input)(Port *p, const PortInput *ev);
    /* Every processed step, after input delivery, before the timer pass. Installing it turns
     * the jump optimisation off (every step then runs). */
    void (*step)(Port *p);
    /* Once per core_advance call that moved the clock, after the last step. For
     * work that is needed only once per host frame (for example converting a back surface to
     * the RGBA frame). Call core_frame_changed when the RGBA frame changed. */
    void (*frame)(Port *p);
} PortHooks;

enum { PORT_HOOK_ENGINE = 0, PORT_HOOK_SHELL = 1, PORT_HOOK_SLOTS = 2 };

struct Engine; /* M4 */
struct Shell;  /* M5 */
struct Cpu;    /* M2 */

struct Port {
    bool ready;
    uint32_t quirks; /* port_settings.quirks bits (port-design.md section 3), default all on */
    uint32_t seed;   /* engine srand seed (original: timeGetTime at start, Z:0x403dc4) */
    const uint8_t *pack;
    uint32_t pack_len;
    const uint8_t *gam;
    uint32_t gam_len;

    VClock clock;
    TimerSys timers; /* engine timer subsystem (global 0x45cfb0 in the original) */
    MsvcRand rand;   /* engine rand, ctx +0x08 */
    InputQueue input;
    KeyState keys;
    Trace trace;
    Storage storage; /* survives core_init (the host loads it before port_init) */

    bool wall_base_set;
    uint32_t wall_base; /* host ms of clock step 0 */
    bool inactive;      /* Z:0x436336: no timer passes (window not active) */
    bool no_jump;       /* tests: process every step */
    uint32_t out_flags; /* PORT_ADV_* bits not yet reported */
    uint32_t cursor;    /* cursor id 0..5 for the host */

    PortSoundCmd sound[PORT_SOUND_QUEUE_MAX];
    uint32_t sound_count;
    uint32_t sound_dropped;

    uint64_t steps_run;  /* statistics */
    uint64_t passes;
    uint32_t late_jumps;

    struct Engine *engine;
    struct Shell *shell;
    struct Cpu *cpu;
    PortHooks hooks[PORT_HOOK_SLOTS];

    uint8_t frame[PORT_W * PORT_H * 4u]; /* RGBA, row-major, top-down */
};

/* Weak defaults in port.c; M4 and M5 define the strong versions. */
void port_hooks_engine(PortHooks *h);
void port_hooks_shell(PortHooks *h);

/* Core state at step 0: clock, timers, rand, queues, frame cleared to #3333cc. No hooks. */
void core_init(Port *p, uint32_t step_index, uint32_t quirks, uint32_t seed);
/* Install the hooks (port_hooks_engine, port_hooks_shell) and run their init hooks. */
int32_t core_start(Port *p, const uint8_t *pack, uint32_t pack_len, const uint8_t *gam, uint32_t gam_len);
/* Run every due step; returns PORT_ADV_* bits and clears them. */
uint32_t core_advance(Port *p, uint32_t wall_ms);
/* Queue one host event (port_input). False if the queue is full. */
bool core_input(Port *p, uint32_t kind, int32_t a, int32_t b, uint32_t time_ms);
/* GetTickCount model at the current step. */
static inline uint32_t core_ticks(const Port *p) { return vclock_ticks(&p->clock); }
/* GetKeyState model. */
static inline int16_t core_key_state(const Port *p, uint32_t vk) { return keys_get(&p->keys, vk); }
static inline void core_frame_changed(Port *p) { p->out_flags |= PORT_ADV_FRAME; }
void core_frame_fill(Port *p, uint32_t rgba_le);
/* Queue a sound command stamped with the current clock ms. False if the queue is full. */
bool core_sound_push(Port *p, uint32_t op, uint32_t sound_id, uint32_t voice);
/* Copy and remove every queued command; out must hold PORT_SOUND_QUEUE_MAX entries. With
 * out == NULL: return the count only. */
uint32_t core_sound_drain(Port *p, PortSoundCmd *out);
/* Smallest step > k at which something can happen (input due or timer fire); UINT64_MAX if
 * nothing is pending. Used by the jump optimisation. */
uint64_t core_next_event_step(const Port *p);

#endif
