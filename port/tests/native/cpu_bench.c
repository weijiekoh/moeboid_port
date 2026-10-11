/* Native speed benchmark and native/wasm determinism check of the CPU module (M2).
 *
 * Runs the original Moeboid.gam in the interpreter against a minimal C engine mock (behaviours of
 * analysis/verification/harness/mock.py, simplified: placeholder text metrics, no rendering, fixed
 * key pattern, Start click at 1000 ms, Space/Y key events every 1500 ms). The mock also shows the
 * cpu.h usage for M4: cpu_machine_init, engine vtables of thunks (cpu_engine_thunk), the
 * engine_dispatch callback with stack arguments at args_guest, cpu_call / cpu_call_cdecl for DllMain,
 * Shell_StartApplet and the timer/button/listener callbacks.
 * Nested calls: with nested = 1 every ISound.Play calls the game's CRT strlen (G:0x100088c0) through
 * cpu_call_cdecl from inside engine_dispatch; ticks and the engine call hash must equal nested = 0.
 * Output: game ticks (timer callbacks), engine calls, guest instructions, FNV-1a hash of the engine
 * call sequence and of guest memory (same in the native and the wasm build), wall time.
 *
 * Native: clang -std=c11 -O2 -ffp-contract=off -Iport/src port/tests/native/cpu_bench.c \
 *           port/src/cpu/(*).c port/src/rt/(*).c -o cpu_bench && ./cpu_bench extracted/Moeboid.gam 600000 [NESTED]
 * wasm:   see port/tests/native/cpu_bench_wasm.mjs. */
#if !defined(__wasm__)
#define _POSIX_C_SOURCE 199309L /* clock_gettime in the native main */
#endif
#include "cpu/cpu.h"
#include "rt/rt.h"

#define MAXOBJ 131072u
#define OBJ_SIZE 0x40u
#define VT_LO (CPU_FAKE_LO + 0x00800000u)
#define MAXSET 64

typedef struct Obj {
    uint32_t iface, w, h, user, period, cb, id, type, start, last, size, style;
    int32_t x, y;
    bool started, released;
} Obj;

typedef struct Bench {
    Cpu *c;
    Obj *obj;
    uint32_t nobj, rng, now, ticks, ev, base, ctx;
    uint32_t active[256], nactive;
    uint32_t keys;
    uint64_t calls, hcall;
    char set_name[MAXSET][32], set_val[MAXSET][32];
    uint32_t nset;
    const char *err;
    bool nested;
    uint32_t nested_calls, nested_str;
} Bench;

static Bench B;

static void hmix(uint64_t *h, uint32_t v) {
    for (int i = 0; i < 4; i++) {
        *h ^= (v >> (8 * i)) & 0xffu;
        *h *= 0x100000001b3ull;
    }
}

static uint32_t arg(uint32_t args, uint32_t i) { return cpu_rd32(B.c, args + 4u * i); }

static uint32_t new_obj(uint32_t iface, uint32_t w, uint32_t h) {
    if (B.nobj + 1 >= MAXOBJ) {
        B.err = "object table full";
        return 0;
    }
    uint32_t id = ++B.nobj;
    Obj *o = &B.obj[id];
    rt_memset(o, 0, sizeof *o);
    o->iface = iface;
    o->w = w;
    o->h = h;
    uint32_t a = CPU_FAKE_LO + id * OBJ_SIZE;
    cpu_wr32(B.c, a, VT_LO + iface * 0x100u);
    return a;
}

static Obj *obj_at(uint32_t a) {
    uint32_t id = (a - CPU_FAKE_LO) / OBJ_SIZE;
    return (a >= CPU_FAKE_LO && id <= B.nobj && id > 0) ? &B.obj[id] : &B.obj[0];
}

static void gstr(uint32_t a, char *buf, uint32_t n) {
    uint32_t i = 0;
    for (; i + 1 < n; i++) {
        uint8_t b = 0;
        if (!cpu_mem_read(B.c, a + i, &b, 1) || !b) break;
        buf[i] = (char)b;
    }
    buf[i] = 0;
}

/* GIF logical screen size of an RCDATA resource (mock.py gif_size). */
static void gif_size(uint32_t name_ptr, uint32_t *w, uint32_t *h) {
    char name[64];
    gstr(name_ptr, name, sizeof name);
    for (char *p = name; *p; p++)
        if (*p >= 'a' && *p <= 'z') *p = (char)(*p - 32);
    uint32_t data = 0, size = 0;
    *w = *h = 0;
    if (!cpu_machine_find_resource(B.c, 10, NULL, 0, name, &data, &size) || size < 10) return;
    uint8_t hdr[10];
    cpu_mem_read(B.c, data, hdr, 10);
    if (hdr[0] != 'G' || hdr[1] != 'I' || hdr[2] != 'F') return;
    *w = hdr[6] | (uint32_t)hdr[7] << 8;
    *h = hdr[8] | (uint32_t)hdr[9] << 8;
}

static uint32_t dispatch(void *ctx, uint32_t iface, uint32_t slot, uint32_t self, uint32_t a) {
    (void)ctx;
    Obj *o = obj_at(self);
    uint32_t r = 0, sp, w, h;
    B.calls++;
    switch (iface << 8 | slot) {
    case CPU_IF_ISHELL << 8 | 2: /* Random: MSVC rand */
        B.rng = B.rng * 214013u + 2531011u;
        r = (B.rng >> 16) & 0x7fffu;
        break;
    case CPU_IF_IFACTORY << 8 | 2: sp = arg(a, 0); r = new_obj(CPU_IF_ISURFACE, obj_at(sp)->w, obj_at(sp)->h); break;
    case CPU_IF_IFACTORY << 8 | 3: gif_size(arg(a, 0), &w, &h); r = new_obj(CPU_IF_ISURFACE, w, h); break;
    case CPU_IF_IFACTORY << 8 | 4: r = new_obj(CPU_IF_ISURFACE, arg(a, 0), arg(a, 1)); break;
    case CPU_IF_IFACTORY << 8 | 5: sp = arg(a, 0); r = new_obj(CPU_IF_IANIM, obj_at(sp)->w, obj_at(sp)->h); break;
    case CPU_IF_IFACTORY << 8 | 8: r = new_obj(CPU_IF_IIMAGE, arg(a, 0), arg(a, 1)); break;
    case CPU_IF_IFACTORY << 8 | 10:
        r = new_obj(CPU_IF_IFONT, 0, 0);
        obj_at(r)->size = arg(a, 1);
        obj_at(r)->style = arg(a, 2);
        break;
    case CPU_IF_IFACTORY << 8 | 12:
        r = new_obj(CPU_IF_IBUTTON, arg(a, 4), arg(a, 5));
        obj_at(r)->user = arg(a, 1);
        obj_at(r)->id = arg(a, 8);
        obj_at(r)->cb = arg(a, 9);
        break;
    case CPU_IF_IFACTORY << 8 | 13:
        r = new_obj(CPU_IF_ITIMER, 0, 0);
        obj_at(r)->user = arg(a, 0);
        obj_at(r)->period = arg(a, 1);
        obj_at(r)->cb = arg(a, 2);
        break;
    case CPU_IF_IFACTORY << 8 | 16: r = new_obj(CPU_IF_ISOUND, 0, 0); break;
    case CPU_IF_IFACTORY << 8 | 17:
        r = new_obj(CPU_IF_ILISTENER, 0, 0);
        obj_at(r)->type = arg(a, 1);
        obj_at(r)->user = arg(a, 2);
        obj_at(r)->cb = arg(a, 3);
        break;
    case CPU_IF_ISYSTEM << 8 | 6: { /* InputBox: answer "TEST" */
        uint32_t out = arg(a, 3), n = arg(a, 4);
        const char t[] = "TEST";
        uint32_t k = n > 0 && n - 1 < 4 ? n - 1 : 4;
        cpu_mem_write(B.c, out, t, k);
        cpu_mem_write(B.c, out + k, "", 1);
        r = 1;
        break;
    }
    case CPU_IF_ISYSTEM << 8 | 8: r = (arg(a, 0) & 0xffu) < 32 && (B.keys >> (arg(a, 0) & 0xffu) & 1u) ? 0x80u : 0u; break;
    case CPU_IF_ISETTINGS << 8 | 4: {
        char n[32], v[32];
        gstr(arg(a, 0), n, sizeof n);
        gstr(arg(a, 1), v, sizeof v);
        uint32_t i = 0;
        while (i < B.nset && rt_strcmp(B.set_name[i], n)) i++;
        if (i == B.nset && B.nset < MAXSET) B.nset++;
        if (i < MAXSET) {
            rt_memcpy(B.set_name[i], n, sizeof n);
            rt_memcpy(B.set_val[i], v, sizeof v);
        }
        break;
    }
    case CPU_IF_ISETTINGS << 8 | 5: {
        char n[32];
        gstr(arg(a, 0), n, sizeof n);
        r = 0x19;
        for (uint32_t i = 0; i < B.nset; i++)
            if (!rt_strcmp(B.set_name[i], n)) {
                cpu_mem_write(B.c, arg(a, 1), B.set_val[i], (uint32_t)rt_strlen(B.set_val[i]) + 1u);
                r = 0;
            }
        break;
    }
    case CPU_IF_ISURFACE << 8 | 2: o->x = (int32_t)arg(a, 0); o->y = (int32_t)arg(a, 1); break;
    case CPU_IF_ISURFACE << 8 | 3: cpu_wr32(B.c, arg(a, 0), (uint32_t)o->x); cpu_wr32(B.c, arg(a, 1), (uint32_t)o->y); break;
    case CPU_IF_ISURFACE << 8 | 15: cpu_wr32(B.c, arg(a, 0), new_obj(CPU_IF_IANIM, o->w, o->h)); break;
    case CPU_IF_ISURFACE << 8 | 17: cpu_wr32(B.c, arg(a, 0), new_obj(CPU_IF_IIMAGE, o->w, o->h)); break;
    case CPU_IF_ISURFACE << 8 | 18:
    case CPU_IF_IIMAGE << 8 | 20: cpu_wr32(B.c, arg(a, 0), o->w); cpu_wr32(B.c, arg(a, 1), o->h); break;
    case CPU_IF_IANIM << 8 | 4: cpu_wr32(B.c, arg(a, 0), new_obj(CPU_IF_IIMAGESEQ, o->w, o->h)); break;
    case CPU_IF_IIMAGESEQ << 8 | 4: cpu_wr32(B.c, arg(a, 1), new_obj(CPU_IF_IIMAGE, o->w, o->h)); break;
    case CPU_IF_IIMAGE << 8 | 19: cpu_wr32(B.c, arg(a, 0), new_obj(CPU_IF_IFONT, 0, 0)); break;
    case CPU_IF_IIMAGE << 8 | 22: cpu_wr32(B.c, arg(a, 3), 7u * arg(a, 2)); cpu_wr32(B.c, arg(a, 3) + 4, 16); break;
    case CPU_IF_IFONT << 8 | 3:
        cpu_mem_write(B.c, arg(a, 0), "Arial", 6);
        cpu_wr32(B.c, arg(a, 1), o->size);
        cpu_wr32(B.c, arg(a, 2), 0);
        cpu_wr32(B.c, arg(a, 3), o->style);
        break;
    case CPU_IF_ITIMER << 8 | 1: /* Release: leave the active list (array shift, timing.md 2.4) */
        for (uint32_t i = 0; i < B.nactive; i++)
            if (B.active[i] == self) {
                rt_memmove(&B.active[i], &B.active[i + 1], (B.nactive - i - 1) * 4u);
                B.nactive--;
                break;
            }
        o->started = false;
        o->released = true;
        break;
    case CPU_IF_ITIMER << 8 | 2:
        if (!o->started && B.nactive < 256) {
            o->started = true;
            o->start = o->last = B.now;
            B.active[B.nactive++] = self;
        }
        break;
    case CPU_IF_ISOUND << 8 | 2: /* Play; nested guest call test: CRT strlen G:0x100088c0 from inside */
        if (B.nested) {
            uint32_t n = cpu_call_cdecl(B.c, B.base + 0x88c0u, 1, &B.nested_str);
            if (cpu_fault(B.c)->kind) return 0;
            if (n != 6) B.err = "nested strlen call returned a wrong length";
            B.nested_calls++;
        }
        break;
    default: /* Release of the other interfaces and drawing calls: 0 */
        if (slot == 1) o->released = true;
        break;
    }
    hmix(&B.hcall, iface << 8 | slot);
    hmix(&B.hcall, r && r - CPU_FAKE_LO >= CPU_FAKE_SIZE ? r : 0);
    if (B.err) cpu_raise(B.c, CPU_FAULT_HOST, B.err);
    return r;
}

static bool call_cb(uint32_t cb, uint32_t w0, uint32_t w1, uint32_t w2, uint32_t w3) {
    uint32_t ev[16] = {w0, w1, w2, w3};
    cpu_mem_write(B.c, B.ev, ev, sizeof ev);
    cpu_call_cdecl(B.c, cb, 1, &B.ev);
    return cpu_fault(B.c)->kind == CPU_FAULT_NONE;
}

static void key_event(uint32_t vk) {
    for (uint32_t id = 1; id <= B.nobj; id++) {
        Obj *o = &B.obj[id];
        if (o->iface == CPU_IF_ILISTENER && !o->released && o->type == 0xb) call_cb(o->cb, o->user, 0, vk, 0);
    }
}

/* Run the benchmark for ms of game time. Returns 0 or -1 (out->text). */
typedef struct BenchResult {
    uint32_t ticks, calls, objects, ms;
    uint64_t insns, hcall, hmem;
    char text[200];
    uint32_t nested_calls;
} BenchResult;

int bench_run(const uint8_t *gam, uint32_t len, uint32_t ms, bool nested, BenchResult *out) {
    rt_memset(&B, 0, sizeof B);
    B.nested = nested;
    rt_memset(out, 0, sizeof *out);
    B.hcall = 0xcbf29ce484222325ull;
    B.rng = 12345;
    B.c = cpu_create();
    B.obj = (Obj *)rt_calloc(MAXOBJ, sizeof(Obj));
    if (!B.c || !B.obj || cpu_machine_init(B.c, gam, len, CPU_IMAGE_BASE, 0, 0x027f)) {
        rt_snprintf(out->text, sizeof out->text, "init: %s", B.c ? cpu_fault(B.c)->text : "no memory");
        return -1;
    }
    Cpu *c = B.c;
    B.base = cpu_machine_base(c);
    for (uint32_t i = 0; i < CPU_IF_COUNT; i++)
        for (uint32_t s = 0; s < CPU_ENGINE_SLOTS; s++) cpu_wr32(c, VT_LO + i * 0x100u + 4u * s, cpu_engine_thunk(i, s));
    cpu_set_engine_dispatch(c, dispatch, NULL);
    B.ev = cpu_machine_alloc_data(c, NULL, 64, 16);
    B.nested_str = cpu_machine_alloc_data(c, "nested", 7, 16);
    for (uint32_t i = 1; i <= 5; i++) { /* run.py "lowscores" settings */
        rt_snprintf(B.set_name[B.nset], 32, "Score%uName", i);
        rt_snprintf(B.set_val[B.nset++], 32, "ZapSpot");
        rt_snprintf(B.set_name[B.nset], 32, "Score%uScore", i);
        rt_snprintf(B.set_val[B.nset++], 32, "%u", 60 - 10 * i);
    }
    uint32_t dll_args[3] = {B.base, 1, 0};
    cpu_call(c, cpu_machine_entry(c), 3, dll_args, NULL);
    const CpuFault *f = cpu_fault(c);
    if (f->kind) goto fault;
    B.ctx = new_obj(CPU_IF_ISHELL, 0, 0);
    cpu_wr32(c, B.ctx + 8, new_obj(CPU_IF_ISURFACE, 500, 420));
    cpu_wr32(c, B.ctx + 12, new_obj(CPU_IF_ISURFACE, 500, 420));
    cpu_wr32(c, B.ctx + 16, new_obj(CPU_IF_IFACTORY, 0, 0));
    cpu_wr32(c, B.ctx + 20, new_obj(CPU_IF_ISYSTEM, 0, 0));
    cpu_wr32(c, B.ctx + 24, new_obj(CPU_IF_ISETTINGS, 0, 0));
    cpu_call_cdecl(c, cpu_machine_export(c, "Shell_StartApplet"), 1, &B.ctx);
    if (f->kind) goto fault;
    uint32_t start_cb = B.base + 0x4990u; /* Start button handler G:0x10004990 (interface.md 5.2) */
    for (B.now = 1; B.now <= ms; B.now++) {
        static const uint32_t pattern[4] = {1u << 7, 1u << 8, 1u << 6, 1u << 9}; /* right, up, left, down */
        B.keys = pattern[(B.now / 700u) % 4u];
        if (B.now == 1000) {
            for (uint32_t id = 1; id <= B.nobj; id++) {
                Obj *o = &B.obj[id];
                if (o->iface == CPU_IF_IBUTTON && !o->released && o->cb == start_cb) {
                    call_cb(o->cb, o->user, o->id, o->id, 0);
                    break;
                }
            }
        }
        if (B.now > 5000 && B.now % 1500 == 0) key_event((B.now / 1500) % 2 ? 0x59u : 0x20u);
        if (f->kind) goto fault;
        for (uint32_t i = 0; i < B.nactive; i++) { /* timer pass: fire when now - last >= period */
            uint32_t ta = B.active[i];
            Obj *t = obj_at(ta);
            if (B.now - t->last >= t->period) {
                uint32_t el = B.now - t->start;
                B.ticks++;
                if (!call_cb(t->cb, t->user, el, el, B.now)) goto fault;
                t->last = B.now;
            }
        }
    }
    cpu_call_cdecl(c, cpu_machine_export(c, "Shell_StopApplet"), 1, &B.ctx);
    if (f->kind) goto fault;
    out->ticks = B.ticks;
    out->calls = (uint32_t)B.calls;
    out->objects = B.nobj;
    out->ms = ms;
    out->insns = cpu_insn_count(c);
    out->hcall = B.hcall;
    out->nested_calls = B.nested_calls;
    {
        static const uint32_t reg[][2] = {{CPU_IMAGE_BASE, 0x42000}, {CPU_STACK_LO, CPU_STACK_SIZE}, {CPU_HEAP_LO, 0x10000},
                                          {CPU_VA_LO, 0x200000}};
        uint64_t h = 0xcbf29ce484222325ull;
        for (uint32_t i = 0; i < 4; i++) {
            const uint8_t *p = cpu_mem_ptr(c, reg[i][0], reg[i][1]);
            for (uint32_t k = 0; p && k < reg[i][1]; k++) {
                h ^= p[k];
                h *= 0x100000001b3ull;
            }
        }
        out->hmem = h;
    }
    cpu_destroy(c);
    rt_free(B.obj);
    return 0;
fault:
    rt_snprintf(out->text, sizeof out->text, "fault at game ms %u: %s", B.now, f->text);
    out->ticks = B.ticks;
    return -1;
}

#if defined(__wasm__)
__attribute__((export_name("bench_alloc"))) void *bench_alloc(uint32_t n) { return rt_malloc(n); }
static BenchResult g_res;
__attribute__((export_name("bench_wasm"))) BenchResult *bench_wasm(const uint8_t *gam, uint32_t len, uint32_t ms,
                                                                    uint32_t nested) {
    bench_run(gam, len, ms, nested != 0, &g_res);
    return &g_res;
}
#else
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char **argv) {
    const char *path = argc > 1 ? argv[1] : "extracted/Moeboid.gam";
    uint32_t ms = argc > 2 ? (uint32_t)strtoul(argv[2], NULL, 0) : 600000u;
    bool nested = argc > 3 ? strtoul(argv[3], NULL, 0) != 0 : true;
    FILE *fp = fopen(path, "rb");
    if (!fp) {
        perror(path);
        return 2;
    }
    static uint8_t buf[1 << 21];
    uint32_t len = (uint32_t)fread(buf, 1, sizeof buf, fp);
    fclose(fp);
    BenchResult r;
    struct timespec t0, t1;
    clock_gettime(CLOCK_MONOTONIC, &t0);
    int rc = bench_run(buf, len, ms, nested, &r);
    clock_gettime(CLOCK_MONOTONIC, &t1);
    double s = (double)(t1.tv_sec - t0.tv_sec) + (double)(t1.tv_nsec - t0.tv_nsec) * 1e-9;
    if (rc) {
        printf("FAILED: %s (ticks %u)\n", r.text, r.ticks);
        return 1;
    }
    printf("game_ms=%u ticks=%u engine_calls=%u objects=%u guest_insns=%llu wall_s=%.3f\n", r.ms, r.ticks, r.calls,
           r.objects, (unsigned long long)r.insns, s);
    printf("ticks_per_s=%.0f guest_insns_per_s=%.1fM insns_per_tick=%.0f realtime_factor=%.0f\n", r.ticks / s,
           (double)r.insns / s / 1e6, (double)r.insns / r.ticks, r.ms / 1000.0 / s);
    printf("hash_calls=%016llx hash_mem=%016llx nested_calls=%u\n", (unsigned long long)r.hcall,
           (unsigned long long)r.hmem, r.nested_calls);
    return 0;
}
#endif
