/* Core main loop (M1). See port.h. */
#include "port.h"

__attribute__((weak)) void port_hooks_engine(PortHooks *h) { (void)h; }
__attribute__((weak)) void port_hooks_shell(PortHooks *h) { (void)h; }

void core_frame_fill(Port *p, uint32_t rgba_le) {
    uint8_t px[4] = {(uint8_t)rgba_le, (uint8_t)(rgba_le >> 8), (uint8_t)(rgba_le >> 16), (uint8_t)(rgba_le >> 24)};
    for (uint32_t i = 0; i < PORT_W * PORT_H * 4u; i += 4u) rt_memcpy(p->frame + i, px, 4);
    core_frame_changed(p);
}

void core_init(Port *p, uint32_t step_index, uint32_t quirks, uint32_t seed) {
    if (p->ready) timersys_free(&p->timers);
    p->ready = false;
    p->quirks = quirks;
    p->seed = seed;
    p->pack = p->gam = NULL;
    p->pack_len = p->gam_len = 0;
    vclock_init(&p->clock, step_index);
    timersys_init(&p->timers, &p->clock); /* engine start at step 0 (Z:0x4271c0) */
    msvc_srand(&p->rand, seed);            /* srand(timeGetTime()) at Z:0x403dc4 */
    inq_clear(&p->input);
    keys_clear(&p->keys);
    trace_init(&p->trace);
    p->wall_base_set = false;
    p->wall_base = 0;
    p->inactive = false;
    p->no_jump = false;
    p->out_flags = 0;
    p->cursor = 0;
    p->sound_count = p->sound_dropped = 0;
    p->steps_run = p->passes = 0;
    p->late_jumps = 0;
    p->engine = NULL;
    p->shell = NULL;
    p->cpu = NULL;
    rt_memset(p->hooks, 0, sizeof p->hooks);
    core_frame_fill(p, PORT_BG_RGBA);
    p->ready = true;
}

int32_t core_start(Port *p, const uint8_t *pack, uint32_t pack_len, const uint8_t *gam, uint32_t gam_len) {
    p->pack = pack;
    p->pack_len = pack_len;
    p->gam = gam;
    p->gam_len = gam_len;
    port_hooks_engine(&p->hooks[PORT_HOOK_ENGINE]);
    port_hooks_shell(&p->hooks[PORT_HOOK_SHELL]);
    for (uint32_t i = 0; i < PORT_HOOK_SLOTS; i++) {
        if (p->hooks[i].init) {
            int32_t r = p->hooks[i].init(p, pack, pack_len, gam, gam_len);
            if (r) {
                rt_log("core_start: init hook %s failed: %d", p->hooks[i].name ? p->hooks[i].name : "?", r);
                return r;
            }
        }
    }
    return 0;
}

bool core_input(Port *p, uint32_t kind, int32_t a, int32_t b, uint32_t time_ms) {
    if (!p->wall_base_set) {
        p->wall_base = time_ms;
        p->wall_base_set = true;
    }
    PortInput ev;
    rt_memset(&ev, 0, sizeof ev);
    ev.kind = kind;
    ev.a = a;
    ev.b = b;
    ev.t = (int32_t)(time_ms - p->wall_base);
    return inq_push(&p->input, ev);
}

/* timing.md 9 rule 5: an event is due before the pass of step k when t <= k * S. */
static bool input_due(const Port *p, const PortInput *ev, uint64_t k) {
    if (ev->t <= 0) return true;
    return (uint64_t)ev->t * p->clock.den <= k * p->clock.num;
}

static void deliver(Port *p, PortInput *ev) {
    uint32_t kind = PORT_IN_KIND(ev->kind);
    keys_apply(&p->keys, ev);
    /* WM_ACTIVATE active: inactive = 0 before anything else (zdc:3523-3529). */
    if (kind == PORT_IN_FOCUS_GAINED) p->inactive = false;
    for (uint32_t i = 0; i < PORT_HOOK_SLOTS; i++)
        if (p->hooks[i].input) p->hooks[i].input(p, ev);
    /* WM_ACTIVATE WA_INACTIVE: the shell pauses and renders first, then inactive = 1
     * (zdc:3510-3522; Z:0x436336). */
    if (kind == PORT_IN_FOCUS_LOST) p->inactive = true;
}

static void deliver_due_inputs(Port *p, uint64_t k) {
    const PortInput *head;
    while ((head = inq_peek(&p->input)) && input_due(p, head, k)) {
        PortInput ev = *head;
        inq_pop(&p->input);
        if (PORT_IN_KIND(ev.kind) == PORT_IN_MOUSEMOVE) {
            /* Windows keeps one WM_MOUSEMOVE per read of the queue: a move followed by
             * another due move is replaced by the later one (inferred, Win32 behaviour). */
            const PortInput *n = inq_peek(&p->input);
            if (n && PORT_IN_KIND(n->kind) == PORT_IN_MOUSEMOVE && input_due(p, n, k)) continue;
        }
        ev.step = k;
        deliver(p, &ev);
    }
}

static bool any_step_hook(const Port *p) {
    for (uint32_t i = 0; i < PORT_HOOK_SLOTS; i++)
        if (p->hooks[i].step) return true;
    return false;
}

static void core_step(Port *p) {
    deliver_due_inputs(p, p->clock.k);
    for (uint32_t i = 0; i < PORT_HOOK_SLOTS; i++)
        if (p->hooks[i].step) p->hooks[i].step(p);
    /* Z:0x404a30: RunTimers only when the queue is empty and inactive == 0. */
    if (!p->inactive) {
        timersys_run(&p->timers);
        p->passes++;
    }
    p->steps_run++;
}

uint64_t core_next_event_step(const Port *p) {
    uint64_t k = p->clock.k, best = UINT64_MAX;
    const PortInput *head = inq_peek(&p->input);
    if (head) {
        uint64_t j = vclock_first_step_at_or_after(&p->clock, head->t);
        best = j <= k ? k + 1 : j;
    }
    if (!p->inactive && !p->timers.held) {
        uint64_t j = timersys_next_fire_step(&p->timers, k);
        if (j < best) best = j;
    }
    return best;
}

uint32_t core_advance(Port *p, uint32_t wall_ms) {
    if (!p->wall_base_set) {
        p->wall_base = wall_ms;
        p->wall_base_set = true;
    }
    int32_t rel = (int32_t)(wall_ms - p->wall_base);
    bool ran = false;
    if (rel > 0) {
        uint64_t target = vclock_steps_at(&p->clock, (uint64_t)rel);
        if (target > p->clock.k) {
            ran = true;
            /* timing.md 9 rule 7: long stall, one pass with the late time, no catch-up. */
            if ((target - p->clock.k) * p->clock.num > (uint64_t)PORT_MAX_LATE_MS * p->clock.den) {
                p->clock.k = target - 1;
                p->late_jumps++;
            }
            bool jump = !p->no_jump && !any_step_hook(p);
            while (p->clock.k < target) {
                uint64_t next = p->clock.k + 1;
                if (jump) {
                    uint64_t j = core_next_event_step(p);
                    if (j > target) {
                        p->clock.k = target; /* nothing can happen up to target */
                        break;
                    }
                    if (j > next) next = j;
                }
                p->clock.k = next;
                core_step(p);
            }
        }
    }
    if (ran)
        for (uint32_t i = 0; i < PORT_HOOK_SLOTS; i++)
            if (p->hooks[i].frame) p->hooks[i].frame(p);
    uint32_t flags = p->out_flags;
    p->out_flags = 0;
    if (p->sound_count) flags |= PORT_ADV_SOUND;
    if (p->storage.changed) {
        flags |= PORT_ADV_STORAGE;
        p->storage.changed = false;
    }
    return flags;
}

bool core_sound_push(Port *p, uint32_t op, uint32_t sound_id, uint32_t voice) {
    if (p->sound_count >= PORT_SOUND_QUEUE_MAX) {
        p->sound_dropped++;
        return false;
    }
    PortSoundCmd *c = &p->sound[p->sound_count++];
    c->op = op;
    c->sound_id = sound_id;
    c->voice = voice;
    c->at_ms = core_ticks(p);
    return true;
}

uint32_t core_sound_drain(Port *p, PortSoundCmd *out) {
    uint32_t n = p->sound_count;
    if (!out) return n;
    rt_memcpy(out, p->sound, n * sizeof *out);
    p->sound_count = 0;
    return n;
}
