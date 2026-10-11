/* Internal definitions of the CPU module (M2). Other modules use cpu.h only. */
#ifndef MOEBOID_CPU_INT_H
#define MOEBOID_CPU_INT_H

#include "../rt/rt.h"
#include "cpu.h"

#define CPU_CHUNK_SHIFT 16u
#define CPU_CHUNK_SIZE (1u << CPU_CHUNK_SHIFT)
#define CPU_NCHUNK (1u << (32u - CPU_CHUNK_SHIFT))
#define CPU_MAX_REGIONS 32u
#define CPU_MAX_HOOKS 32u
#define CPU_MAX_DEPTH 64

#define LIKELY(x) __builtin_expect(!!(x), 1)
#define UNLIKELY(x) __builtin_expect(!!(x), 0)

/* One 64 KiB chunk of the guest address space. Offsets [lo, len) of the chunk are mapped (one
 * region per chunk); host + offset is the host byte. len = 0: unmapped. */
typedef struct CpuChunk {
    uint8_t *host;
    uint32_t lo, len;
} CpuChunk;

typedef struct CpuRegion {
    uint32_t base, size;
    uint8_t *host;
} CpuRegion;

typedef struct CpuHook {
    int id, type;
    uint32_t begin, end;
    void *fn, *user;
} CpuHook;

/* 80-bit extended value: m = significand with explicit integer bit, se = sign << 15 | exponent. */
typedef struct F80 {
    uint64_t m;
    uint16_t se;
} F80;

typedef struct CpuImport {
    char name[48];
    uint32_t thunk, iat, calls;
    int k32; /* index into the k32 stub table, -1 unknown */
} CpuImport;

typedef struct CpuExport {
    char name[48];
    uint32_t addr;
} CpuExport;

typedef struct CpuRes {
    uint32_t type_id, name_id; /* 0xffffffff when the key is a string */
    char type_name[32], name_name[64]; /* upper-case */
    uint32_t entry, data, size;
} CpuRes;

typedef struct CpuMachine {
    bool on; /* thunk bridge active */
    uint32_t base, preferred, image_size, entry, reloc_count;
    CpuImport *imp;
    uint32_t nimp;
    CpuExport *exp;
    uint32_t nexp;
    CpuRes *res;
    uint32_t nres;
    uint8_t fill;
    uint32_t heap_next, va_next, data_next, last_error;
    uint32_t cmdline, envstr;
    uint32_t *hs_key, *hs_val, hs_cap, hs_n; /* live HeapAlloc block sizes (open addressing) */
    CpuEngineDispatch dispatch;
    void *dctx;
    int8_t argc_ovr[CPU_IF_COUNT][CPU_ENGINE_SLOTS]; /* -2 = use the built-in table */
    uint64_t call_limit;
    int depth;
    /* suspended top-level cpu_call (cpu_suspend / cpu_resume) */
    bool suspended;
    uint32_t sus_esp0, sus_func;
    uint32_t sus_saved[4];
} CpuMachine;

struct Cpu {
    uint32_t r[8];
    uint32_t eip;
    uint32_t eflags;
    uint16_t sel[6];
    uint32_t sbase[6];
    uint32_t gdt_base, gdt_limit;

    /* x87: physical registers as double; ext[] holds the exact 80-bit value when ext_ok[]. */
    double st[8];
    F80 ext[8];
    uint8_t ext_ok[8];
    uint8_t empty[8];
    uint16_t fcw, fsw; /* fsw without the TOP field */
    uint32_t top;
    const CpuFsinEntry *fsin;
    uint32_t nfsin;

    /* run state */
    uint32_t next_eip; /* address after the current instruction */
    uint32_t stop_req;
    uint32_t susp_req; /* cpu_suspend: the stop is a suspension */
    uint32_t ctl; /* current instruction transfers control (ends a block) */
    uint64_t icount;
    CpuFault fault;

    /* hooks */
    CpuHook hook[CPU_MAX_HOOKS];
    uint32_t nhook;
    int next_hook_id;
    bool code_hook_on, block_hook_on, rd_hook_on, wr_hook_on;
    uint32_t rd_lo, rd_hi, wr_lo, wr_hi;
    uint32_t blk_end; /* end of the current translation block (block hooks) */
    bool blk_open;

    CpuMachine m;

    CpuRegion region[CPU_MAX_REGIONS];
    uint32_t nregion;
    CpuChunk chunk[CPU_NCHUNK];
};

/* ---- faults (cpu_exec.c) ---- */
void cpu_set_fault(Cpu *c, uint32_t kind, uint32_t addr, uint32_t size, const char *fmt, ...)
    __attribute__((format(printf, 5, 6)));
#define FAULTED(c) ((c)->fault.kind != CPU_FAULT_NONE)

/* ---- guest data access with fault reporting (instruction semantics) ---- */
void cpu_rd_hook_call(Cpu *c, uint32_t a, uint32_t n);
void cpu_wr_hook_call(Cpu *c, uint32_t a, uint32_t n);
uint64_t cpu_rd_slow(Cpu *c, uint32_t a, uint32_t n);
void cpu_wr_slow(Cpu *c, uint32_t a, uint32_t n, uint64_t v);

static inline uint64_t cpu_ld(const uint8_t *p, uint32_t n) {
    uint64_t v = 0;
    __builtin_memcpy(&v, p, n); /* little-endian host (x86-64, wasm32) */
    return v;
}
static inline void cpu_st(uint8_t *p, uint32_t n, uint64_t v) { __builtin_memcpy(p, &v, n); }

/* Read n (1, 2, 4, 8, 10 handled by callers) bytes; sets the fault and returns 0 if unmapped. */
static inline uint64_t rdm(Cpu *c, uint32_t a, uint32_t n) {
    if (UNLIKELY(c->rd_hook_on) && a >= c->rd_lo && a <= c->rd_hi) cpu_rd_hook_call(c, a, n);
    const CpuChunk *ch = &c->chunk[a >> CPU_CHUNK_SHIFT];
    uint32_t o = a & (CPU_CHUNK_SIZE - 1u);
    if (LIKELY(o + n <= ch->len && o >= ch->lo)) return cpu_ld(ch->host + o, n);
    return cpu_rd_slow(c, a, n);
}
static inline void wrm(Cpu *c, uint32_t a, uint32_t n, uint64_t v) {
    if (UNLIKELY(c->wr_hook_on) && a >= c->wr_lo && a <= c->wr_hi) cpu_wr_hook_call(c, a, n);
    const CpuChunk *ch = &c->chunk[a >> CPU_CHUNK_SHIFT];
    uint32_t o = a & (CPU_CHUNK_SIZE - 1u);
    if (LIKELY(o + n <= ch->len && o >= ch->lo)) {
        cpu_st(ch->host + o, n, v);
        return;
    }
    cpu_wr_slow(c, a, n, v);
}
/* True if [a, a+n) is mapped (no hook, no fault). */
bool cpu_mapped(Cpu *c, uint32_t a, uint32_t n);

/* ---- x87 (cpu_x87.c) ---- */
/* Execute the x87 instruction (opcode d8..df) whose ModRM is modrm; ea = effective address
 * (segment base included) for memory forms. */
void cpu_x87_exec(Cpu *c, uint8_t op, uint8_t modrm, uint32_t ea);
void cpu_x87_reset(Cpu *c); /* FNINIT state */
F80 f80_from_double(double d);
double f80_to_double(F80 v);
bool f80_is_double(F80 v);

/* ---- machine (pe.c, k32.c, bridge.c) ---- */
void cpu_thunk(Cpu *c, uint32_t eip); /* EIP in the thunk region with the bridge on */
int k32_lookup(const char *name, uint32_t *nargs);
uint32_t k32_call(Cpu *c, int stub, const uint32_t *args, uint32_t nargs);
void cpu_machine_free(Cpu *c);

#endif
