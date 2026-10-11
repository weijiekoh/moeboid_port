/* i386 integer interpreter, guest memory and run loop (M2).
 *
 * Decoding works on the instruction bytes in guest memory (no listing at run time). Covered: every
 * instruction form of the Moeboid.gam .text (analysis/decomp/Moeboid.gam/listing.asm, 15674
 * instructions, 88 mnemonics), plus the other members of the same opcode groups (all ALU, shift,
 * rotate, group 3/4/5/8 forms in 8/16/32 bit). Anything else stops with CPU_FAULT_INVALID_OPCODE.
 * Not implemented: address-size prefix 0x67, far transfers, segment loads by instructions, I/O,
 * system instructions, MMX/SSE.
 *
 * EFLAGS: CF PF AF ZF SF OF are computed for every instruction that Intel defines them for. Where
 * Intel leaves a flag undefined, this code produces the value of Unicorn 2.1.4 (QEMU) in single-step
 * execution, so the per-instruction differential test compares all flags:
 *   AND/OR/XOR/TEST: AF = 0.
 *   SHL/SHR/SAR (count != 0): AF = 0; OF for count > 1 = MSB(result) XOR CF (SHL), 0 (SHR, SAR).
 *   MUL/IMUL: SF, ZF, PF from the low half of the result, AF = 0.
 *   DIV/IDIV: all flags unchanged.
 *   BT/BTS/BTR/BTC: CF = bit, other flags unchanged.
 *   ROL/ROR/RCL/RCR (count != 0): OF formula of count 1 for every count.
 * Inside a multi-instruction QEMU translation block the undefined flags after BT can differ; the
 * game never reads them (BT at G:0x100057e0 is followed by JNC; BTS at G:0x100057cb by a JMP to a
 * flag-setting OR). */
#include "cpu_int.h"

#define F_CF CPU_FLAG_CF
#define F_PF CPU_FLAG_PF
#define F_AF CPU_FLAG_AF
#define F_ZF CPU_FLAG_ZF
#define F_SF CPU_FLAG_SF
#define F_DF CPU_FLAG_DF
#define F_OF CPU_FLAG_OF
#define F_ARITH (F_CF | F_PF | F_AF | F_ZF | F_SF | F_OF)

/* ------------------------------------------------------------------ faults and life cycle */
void cpu_set_fault(Cpu *c, uint32_t kind, uint32_t addr, uint32_t size, const char *fmt, ...) {
    if (c->fault.kind != CPU_FAULT_NONE) return; /* keep the first fault */
    c->fault.kind = kind;
    c->fault.eip = c->eip;
    c->fault.addr = addr;
    c->fault.size = size;
    rt_va_list ap;
    rt_va_start(ap, fmt);
    rt_vsnprintf(c->fault.text, sizeof c->fault.text, fmt, ap);
    rt_va_end(ap);
}

const CpuFault *cpu_fault(const Cpu *c) { return &c->fault; }
void cpu_clear_fault(Cpu *c) { rt_memset(&c->fault, 0, sizeof c->fault); }
void cpu_raise(Cpu *c, uint32_t kind, const char *text) {
    cpu_set_fault(c, kind, 0, 0, "%s", text ? text : "raised by the engine");
    c->stop_req = 1;
}
void cpu_stop(Cpu *c) { c->stop_req = 1; }
void cpu_suspend(Cpu *c) {
    c->susp_req = 1;
    c->stop_req = 1;
}
uint64_t cpu_insn_count(const Cpu *c) { return c->icount; }

void cpu_fsin_default(Cpu *c); /* cpu_x87.c */

Cpu *cpu_create(void) {
    Cpu *c = (Cpu *)rt_calloc(1, sizeof(Cpu));
    if (!c) return NULL;
    c->eflags = 0x2;
    cpu_x87_reset(c);
    c->next_hook_id = 1;
    c->m.call_limit = 200000000ull;
    for (uint32_t i = 0; i < CPU_IF_COUNT; i++)
        for (uint32_t j = 0; j < CPU_ENGINE_SLOTS; j++) c->m.argc_ovr[i][j] = -2;
    cpu_fsin_default(c);
    return c;
}

void cpu_destroy(Cpu *c) {
    if (!c) return;
    cpu_machine_free(c);
    for (uint32_t i = 0; i < c->nregion; i++) rt_free(c->region[i].host);
    rt_free(c);
}

/* ------------------------------------------------------------------ guest memory */
int cpu_mem_map(Cpu *c, uint32_t addr, uint32_t size) {
    if (size == 0 || (addr & 0xfffu) || (size & 0xfffu)) return -1;
    uint64_t end = (uint64_t)addr + size;
    if (end > 0x100000000ull || c->nregion >= CPU_MAX_REGIONS) return -1;
    uint32_t c0 = addr >> CPU_CHUNK_SHIFT, c1 = (uint32_t)((end - 1u) >> CPU_CHUNK_SHIFT);
    for (uint32_t ci = c0; ci <= c1; ci++)
        if (c->chunk[ci].len) return -1; /* one region per 64 KiB chunk */
    uint8_t *h = (uint8_t *)rt_calloc(1, size);
    if (!h) return -1;
    CpuRegion *r = &c->region[c->nregion++];
    r->base = addr;
    r->size = size;
    r->host = h;
    for (uint32_t ci = c0; ci <= c1; ci++) {
        uint64_t cb = (uint64_t)ci << CPU_CHUNK_SHIFT;
        CpuChunk *ch = &c->chunk[ci];
        ch->lo = ci == c0 ? addr - (uint32_t)cb : 0u;
        ch->len = ci == c1 ? (uint32_t)(end - cb) : CPU_CHUNK_SIZE;
        ch->host = (uint8_t *)((uintptr_t)h + (uintptr_t)(cb - addr)); /* wraps for ci == c0 */
    }
    return 0;
}

static const CpuRegion *region_of(const Cpu *c, uint32_t addr) {
    for (uint32_t i = 0; i < c->nregion; i++) {
        const CpuRegion *r = &c->region[i];
        if (addr - r->base < r->size) return r;
    }
    return NULL;
}

uint8_t *cpu_mem_ptr(Cpu *c, uint32_t addr, uint32_t len) {
    const CpuRegion *r = region_of(c, addr);
    if (!r || (uint64_t)(addr - r->base) + len > r->size) return NULL;
    return r->host + (addr - r->base);
}

bool cpu_mapped(Cpu *c, uint32_t a, uint32_t n) {
    while (n) {
        const CpuChunk *ch = &c->chunk[a >> CPU_CHUNK_SHIFT];
        uint32_t o = a & (CPU_CHUNK_SIZE - 1u);
        if (o < ch->lo || o >= ch->len) return false;
        uint32_t k = ch->len - o;
        if (k >= n) return true;
        n -= k;
        a += k;
        if (a == 0) return false; /* wrapped */
    }
    return true;
}
bool cpu_mem_mapped(Cpu *c, uint32_t addr, uint32_t len) { return len == 0 || cpu_mapped(c, addr, len); }

bool cpu_mem_read(Cpu *c, uint32_t addr, void *dst, uint32_t len) {
    if (len == 0) return true;
    if (!cpu_mapped(c, addr, len)) return false;
    uint8_t *d = (uint8_t *)dst;
    while (len) {
        const CpuChunk *ch = &c->chunk[addr >> CPU_CHUNK_SHIFT];
        uint32_t o = addr & (CPU_CHUNK_SIZE - 1u), k = ch->len - o;
        if (k > len) k = len;
        rt_memcpy(d, ch->host + o, k);
        d += k;
        addr += k;
        len -= k;
    }
    return true;
}

bool cpu_mem_write(Cpu *c, uint32_t addr, const void *src, uint32_t len) {
    if (len == 0) return true;
    if (!cpu_mapped(c, addr, len)) return false;
    const uint8_t *s = (const uint8_t *)src;
    while (len) {
        const CpuChunk *ch = &c->chunk[addr >> CPU_CHUNK_SHIFT];
        uint32_t o = addr & (CPU_CHUNK_SIZE - 1u), k = ch->len - o;
        if (k > len) k = len;
        rt_memcpy(ch->host + o, s, k);
        s += k;
        addr += k;
        len -= k;
    }
    return true;
}

bool cpu_mem_fill(Cpu *c, uint32_t addr, uint8_t byte, uint32_t len) {
    if (len == 0) return true;
    if (!cpu_mapped(c, addr, len)) return false;
    while (len) {
        const CpuChunk *ch = &c->chunk[addr >> CPU_CHUNK_SHIFT];
        uint32_t o = addr & (CPU_CHUNK_SIZE - 1u), k = ch->len - o;
        if (k > len) k = len;
        rt_memset(ch->host + o, byte, k);
        addr += k;
        len -= k;
    }
    return true;
}

uint32_t cpu_rd32(Cpu *c, uint32_t addr) {
    uint32_t v = 0;
    if (!cpu_mem_read(c, addr, &v, 4)) return 0;
    return v;
}
void cpu_wr32(Cpu *c, uint32_t addr, uint32_t v) { (void)cpu_mem_write(c, addr, &v, 4); }

int32_t cpu_strnlen(Cpu *c, uint32_t addr, uint32_t max) {
    for (uint32_t i = 0; i < max; i++) {
        uint8_t b;
        if (!cpu_mem_read(c, addr + i, &b, 1)) return -1;
        if (b == 0) return (int32_t)i;
    }
    return (int32_t)max;
}

uint64_t cpu_rd_slow(Cpu *c, uint32_t a, uint32_t n) {
    if (!cpu_mapped(c, a, n)) {
        cpu_set_fault(c, CPU_FAULT_READ_UNMAPPED, a, n, "read of %u bytes at %08x: unmapped", n, a);
        return 0;
    }
    uint8_t b[8] = {0};
    cpu_mem_read(c, a, b, n);
    return cpu_ld(b, n);
}

void cpu_wr_slow(Cpu *c, uint32_t a, uint32_t n, uint64_t v) {
    if (!cpu_mapped(c, a, n)) {
        cpu_set_fault(c, CPU_FAULT_WRITE_UNMAPPED, a, n, "write of %u bytes at %08x: unmapped", n, a);
        return;
    }
    uint8_t b[8];
    cpu_st(b, n, v);
    cpu_mem_write(c, a, b, n);
}

/* ------------------------------------------------------------------ registers */
uint32_t cpu_get_reg(const Cpu *c, int r) { return c->r[r & 7]; }
void cpu_set_reg(Cpu *c, int r, uint32_t v) { c->r[r & 7] = v; }
uint32_t cpu_get_eip(const Cpu *c) { return c->eip; }
void cpu_set_eip(Cpu *c, uint32_t v) { c->eip = v; }
uint32_t cpu_get_eflags(const Cpu *c) { return c->eflags; }
void cpu_set_eflags(Cpu *c, uint32_t v) { c->eflags = v | 0x2u; }
uint16_t cpu_get_seg(const Cpu *c, int s) { return c->sel[s % 6]; }
void cpu_set_seg_base(Cpu *c, int s, uint32_t base) { c->sbase[s % 6] = base; }
void cpu_set_gdtr(Cpu *c, uint32_t base, uint32_t limit) {
    c->gdt_base = base;
    c->gdt_limit = limit;
}

int cpu_set_seg(Cpu *c, int s, uint16_t sel) {
    s %= 6;
    c->sel[s] = sel;
    if ((sel & ~3u) == 0) {
        c->sbase[s] = 0;
        return 0;
    }
    uint32_t off = sel & ~7u;
    uint8_t d[8];
    if ((sel & 4u) || off + 7u > c->gdt_limit || !cpu_mem_read(c, c->gdt_base + off, d, 8)) return -1;
    c->sbase[s] = (uint32_t)d[2] | (uint32_t)d[3] << 8 | (uint32_t)d[4] << 16 | (uint32_t)d[7] << 24;
    return 0;
}

/* ------------------------------------------------------------------ hooks */
static void hooks_update(Cpu *c) {
    c->code_hook_on = c->block_hook_on = c->rd_hook_on = c->wr_hook_on = false;
    c->rd_lo = c->wr_lo = 0xffffffffu;
    c->rd_hi = c->wr_hi = 0;
    for (uint32_t i = 0; i < c->nhook; i++) {
        const CpuHook *h = &c->hook[i];
        if (h->type == CPU_HOOK_CODE) c->code_hook_on = true;
        if (h->type == CPU_HOOK_BLOCK) c->block_hook_on = true;
        if (h->type == CPU_HOOK_MEM_READ) {
            c->rd_hook_on = true;
            if (h->begin < c->rd_lo) c->rd_lo = h->begin;
            if (h->end > c->rd_hi) c->rd_hi = h->end;
        }
        if (h->type == CPU_HOOK_MEM_WRITE) {
            c->wr_hook_on = true;
            if (h->begin < c->wr_lo) c->wr_lo = h->begin;
            if (h->end > c->wr_hi) c->wr_hi = h->end;
        }
    }
}

int cpu_hook_add(Cpu *c, int type, void *fn, void *user, uint32_t begin, uint32_t end) {
    if (c->nhook >= CPU_MAX_HOOKS || !fn || type < CPU_HOOK_CODE || type > CPU_HOOK_MEM_WRITE) return -1;
    if (begin > end) {
        begin = 0;
        end = 0xffffffffu;
    }
    CpuHook *h = &c->hook[c->nhook++];
    h->id = c->next_hook_id++;
    h->type = type;
    h->begin = begin;
    h->end = end;
    h->fn = fn;
    h->user = user;
    hooks_update(c);
    return h->id;
}

void cpu_hook_del(Cpu *c, int id) {
    for (uint32_t i = 0; i < c->nhook; i++) {
        if (c->hook[i].id == id) {
            for (uint32_t j = i + 1; j < c->nhook; j++) c->hook[j - 1] = c->hook[j];
            c->nhook--;
            break;
        }
    }
    hooks_update(c);
}

void cpu_rd_hook_call(Cpu *c, uint32_t a, uint32_t n) {
    for (uint32_t i = 0; i < c->nhook; i++) {
        const CpuHook *h = &c->hook[i];
        if (h->type == CPU_HOOK_MEM_READ && a >= h->begin && a <= h->end) ((CpuMemHookFn)h->fn)(h->user, a, n);
    }
}

void cpu_wr_hook_call(Cpu *c, uint32_t a, uint32_t n) {
    for (uint32_t i = 0; i < c->nhook; i++) {
        const CpuHook *h = &c->hook[i];
        if (h->type == CPU_HOOK_MEM_WRITE && a >= h->begin && a <= h->end) ((CpuMemHookFn)h->fn)(h->user, a, n);
    }
}

static void code_hooks(Cpu *c, uint32_t eip) {
    uint32_t size = 0;
    bool have = false;
    for (uint32_t i = 0; i < c->nhook; i++) {
        const CpuHook *h = &c->hook[i];
        if (h->type != CPU_HOOK_CODE || eip < h->begin || eip > h->end) continue;
        if (!have) {
            size = cpu_insn_len(c, eip);
            have = true;
        }
        ((CpuCodeHookFn)h->fn)(h->user, eip, size);
    }
}

static void block_hooks(Cpu *c, uint32_t start, uint32_t size) {
    for (uint32_t i = 0; i < c->nhook; i++) {
        const CpuHook *h = &c->hook[i];
        if (h->type == CPU_HOOK_BLOCK && start >= h->begin && start <= h->end) ((CpuCodeHookFn)h->fn)(h->user, start, size);
    }
}

/* ------------------------------------------------------------------ flag helpers */
static inline uint32_t szmask(uint32_t sz) { return sz == 4 ? 0xffffffffu : (1u << (sz * 8u)) - 1u; }
static inline uint32_t szsign(uint32_t sz) { return 1u << (sz * 8u - 1u); }
static inline uint32_t szp(uint32_t res, uint32_t sz) {
    uint32_t f = 0;
    res &= szmask(sz);
    if (res == 0) f |= F_ZF;
    if (res & szsign(sz)) f |= F_SF;
    if (!__builtin_parity(res & 0xffu)) f |= F_PF;
    return f;
}
static inline void set_arith(Cpu *c, uint32_t f) { c->eflags = (c->eflags & ~F_ARITH) | f; }
static inline uint32_t sext(uint32_t v, uint32_t sz) {
    if (sz == 1) return (uint32_t)(int32_t)(int8_t)v;
    if (sz == 2) return (uint32_t)(int32_t)(int16_t)v;
    return v;
}

enum { ALU_ADD, ALU_OR, ALU_ADC, ALU_SBB, ALU_AND, ALU_SUB, ALU_XOR, ALU_CMP };

static uint32_t alu(Cpu *c, uint32_t op, uint32_t a, uint32_t b, uint32_t sz) {
    uint32_t m = szmask(sz), sb = szsign(sz), res, f, cin = c->eflags & F_CF;
    a &= m;
    b &= m;
    switch (op) {
    case ALU_ADD:
    case ALU_ADC:
        if (op == ALU_ADD) cin = 0;
        res = (a + b + cin) & m;
        f = szp(res, sz) | ((a ^ b ^ res) & F_AF);
        if (cin ? res <= a : res < a) f |= F_CF;
        if ((a ^ res) & (b ^ res) & sb) f |= F_OF;
        break;
    case ALU_SUB:
    case ALU_SBB:
    case ALU_CMP:
        if (op != ALU_SBB) cin = 0;
        res = (a - b - cin) & m;
        f = szp(res, sz) | ((a ^ b ^ res) & F_AF);
        if (cin ? a <= b : a < b) f |= F_CF;
        if ((a ^ b) & (a ^ res) & sb) f |= F_OF;
        break;
    case ALU_OR: res = a | b; f = szp(res, sz); break;
    case ALU_AND: res = a & b; f = szp(res, sz); break;
    default: res = a ^ b; f = szp(res, sz); break;
    }
    set_arith(c, f);
    return res;
}

static uint32_t incdec(Cpu *c, uint32_t v, bool dec, uint32_t sz) {
    uint32_t m = szmask(sz), sb = szsign(sz);
    v &= m;
    uint32_t res = (dec ? v - 1u : v + 1u) & m;
    uint32_t f = szp(res, sz) | ((v ^ 1u ^ res) & F_AF) | (c->eflags & F_CF);
    if (dec ? v == sb : res == sb) f |= F_OF;
    set_arith(c, f);
    return res;
}

/* Group 2: 0 ROL, 1 ROR, 2 RCL, 3 RCR, 4 SHL, 5 SHR, 6 SAL (= SHL), 7 SAR. Flag rules: QEMU helpers. */
static uint32_t shift(Cpu *c, uint32_t op, uint32_t v, uint32_t cnt, uint32_t sz) {
    uint32_t bits = sz * 8u, m = szmask(sz);
    cnt &= 0x1fu;
    v &= m;
    if (cnt == 0) return v;
    uint32_t res, f;
    switch (op) {
    case 0:
    case 1: {
        uint32_t r = cnt & (bits - 1u);
        if (op == 0) res = r ? ((v << r) | (v >> (bits - r))) & m : v;
        else res = r ? ((v >> r) | (v << (bits - r))) & m : v;
        uint32_t msb = (res >> (bits - 1u)) & 1u, cf, of;
        if (op == 0) {
            cf = res & 1u;
            of = msb ^ cf;
        } else {
            cf = msb;
            of = msb ^ ((res >> (bits - 2u)) & 1u);
        }
        c->eflags = (c->eflags & ~(F_CF | F_OF)) | (cf ? F_CF : 0) | (of ? F_OF : 0);
        return res;
    }
    case 2:
    case 3: {
        uint32_t n = sz == 1 ? cnt % 9u : sz == 2 ? cnt % 17u : cnt;
        if (n == 0) return v;
        uint64_t cf = c->eflags & F_CF, src = v, r64;
        uint32_t ncf;
        if (op == 2) {
            r64 = (src << n) | (cf << (n - 1u));
            if (n > 1) r64 |= src >> (bits + 1u - n);
            ncf = (uint32_t)(src >> (bits - n)) & 1u;
        } else {
            r64 = (src >> n) | (cf << (bits - n));
            if (n > 1) r64 |= src << (bits + 1u - n);
            ncf = (uint32_t)(src >> (n - 1u)) & 1u;
        }
        uint32_t of = (uint32_t)((src ^ r64) >> (bits - 1u)) & 1u;
        c->eflags = (c->eflags & ~(F_CF | F_OF)) | (ncf ? F_CF : 0) | (of ? F_OF : 0);
        return (uint32_t)r64 & m;
    }
    case 4:
    case 6: {
        uint64_t src = (uint64_t)v << (cnt - 1u), dst = src << 1;
        res = (uint32_t)dst & m;
        f = szp(res, sz);
        if ((src >> (bits - 1u)) & 1u) f |= F_CF;
        if (((src ^ dst) >> (bits - 1u)) & 1u) f |= F_OF;
        set_arith(c, f);
        return res;
    }
    case 5: {
        uint32_t src = cnt - 1u >= 32u ? 0u : v >> (cnt - 1u), dst = src >> 1;
        res = dst & m;
        f = szp(res, sz) | (src & 1u ? F_CF : 0);
        if (((src ^ dst) >> (bits - 1u)) & 1u) f |= F_OF;
        set_arith(c, f);
        return res;
    }
    default: {
        int32_t sv = (int32_t)sext(v, sz);
        int32_t src = sv >> (cnt - 1u), dst = src >> 1;
        res = (uint32_t)dst & m;
        f = szp(res, sz) | ((uint32_t)src & 1u ? F_CF : 0);
        if ((((uint32_t)src ^ (uint32_t)dst) >> (bits - 1u)) & 1u) f |= F_OF;
        set_arith(c, f);
        return res;
    }
    }
}

static bool cond(const Cpu *c, uint32_t cc) {
    uint32_t f = c->eflags;
    bool r, sf = (f & F_SF) != 0, of = (f & F_OF) != 0;
    switch (cc >> 1) {
    case 0: r = f & F_OF; break;
    case 1: r = f & F_CF; break;
    case 2: r = f & F_ZF; break;
    case 3: r = (f & (F_CF | F_ZF)) != 0; break;
    case 4: r = f & F_SF; break;
    case 5: r = f & F_PF; break;
    case 6: r = sf != of; break;
    default: r = (f & F_ZF) || sf != of; break;
    }
    return (cc & 1u) ? !r : r;
}

/* ------------------------------------------------------------------ decoding */
typedef struct Dec {
    const uint8_t *b;
    uint32_t avail, i, eip;
    int seg;
    uint8_t rep, osz;
    uint8_t mod, reg, rm;
    bool mem, esp_base;
    uint32_t off, ea; /* effective offset; ea = off + segment base */
    uint8_t buf[16];
} Dec;

static void fetch_fault(Cpu *c, Dec *d) {
    if (FAULTED(c)) return;
    uint32_t a = d->eip + d->avail;
    cpu_set_fault(c, CPU_FAULT_FETCH_UNMAPPED, a, 1, "instruction fetch at %08x: unmapped", a);
}
static inline uint32_t f8(Cpu *c, Dec *d) {
    if (UNLIKELY(d->i >= d->avail)) {
        fetch_fault(c, d);
        return 0;
    }
    return d->b[d->i++];
}
static inline uint32_t f16(Cpu *c, Dec *d) {
    uint32_t lo = f8(c, d);
    return lo | f8(c, d) << 8;
}
static inline uint32_t f32(Cpu *c, Dec *d) {
    uint32_t lo = f16(c, d);
    return lo | f16(c, d) << 16;
}
static inline uint32_t fimm(Cpu *c, Dec *d, uint32_t sz) {
    return sz == 1 ? f8(c, d) : sz == 2 ? f16(c, d) : f32(c, d);
}

static void modrm(Cpu *c, Dec *d) {
    uint32_t m = f8(c, d);
    d->mod = (uint8_t)(m >> 6);
    d->reg = (uint8_t)((m >> 3) & 7u);
    d->rm = (uint8_t)(m & 7u);
    d->mem = d->mod != 3;
    d->esp_base = false;
    if (!d->mem) return;
    uint32_t off;
    int seg = CPU_DS;
    if (d->rm == 4) {
        uint32_t sib = f8(c, d), base = sib & 7u, idx = (sib >> 3) & 7u;
        off = idx == 4 ? 0u : c->r[idx] << (sib >> 6);
        if (base == 5 && d->mod == 0) {
            off += f32(c, d);
        } else {
            off += c->r[base];
            if (base == 4 || base == 5) seg = CPU_SS;
            d->esp_base = base == 4;
        }
    } else if (d->rm == 5 && d->mod == 0) {
        off = f32(c, d);
    } else {
        off = c->r[d->rm];
        if (d->rm == 5) seg = CPU_SS;
    }
    if (d->mod == 1) off += (uint32_t)(int32_t)(int8_t)f8(c, d);
    else if (d->mod == 2) off += f32(c, d);
    if (d->seg >= 0) seg = d->seg;
    d->off = off;
    d->ea = off + c->sbase[seg];
}

static inline uint32_t rget(const Cpu *c, uint32_t r, uint32_t sz) {
    if (sz == 4) return c->r[r];
    if (sz == 2) return c->r[r] & 0xffffu;
    return r < 4 ? c->r[r] & 0xffu : (c->r[r - 4] >> 8) & 0xffu;
}
static inline void rset(Cpu *c, uint32_t r, uint32_t sz, uint32_t v) {
    if (sz == 4) c->r[r] = v;
    else if (sz == 2) c->r[r] = (c->r[r] & 0xffff0000u) | (v & 0xffffu);
    else if (r < 4) c->r[r] = (c->r[r] & ~0xffu) | (v & 0xffu);
    else c->r[r - 4] = (c->r[r - 4] & ~0xff00u) | ((v & 0xffu) << 8);
}
static inline uint32_t rd_rm(Cpu *c, const Dec *d, uint32_t sz) {
    return d->mem ? (uint32_t)rdm(c, d->ea, sz) : rget(c, d->rm, sz);
}
static inline void wr_rm(Cpu *c, const Dec *d, uint32_t sz, uint32_t v) {
    if (d->mem) wrm(c, d->ea, sz, v);
    else rset(c, d->rm, sz, v);
}

static inline void push(Cpu *c, uint32_t v, uint32_t sz) {
    uint32_t sp = c->r[CPU_ESP] - sz;
    wrm(c, sp + c->sbase[CPU_SS], sz, v);
    if (!FAULTED(c)) c->r[CPU_ESP] = sp;
}
static inline uint32_t pop(Cpu *c, uint32_t sz) {
    uint32_t v = (uint32_t)rdm(c, c->r[CPU_ESP] + c->sbase[CPU_SS], sz);
    if (!FAULTED(c)) c->r[CPU_ESP] += sz;
    return v;
}

static void invalid(Cpu *c, const Dec *d, uint32_t op) {
    uint32_t n = d->avail < 8 ? d->avail : 8;
    char hex[20];
    for (uint32_t i = 0; i < n; i++) rt_snprintf(hex + 2 * i, 3, "%02x", d->b[i]);
    hex[2 * n] = 0;
    cpu_set_fault(c, CPU_FAULT_INVALID_OPCODE, d->eip, 0, "invalid or unimplemented opcode %02x at %08x (bytes %s)",
                  op, d->eip, hex);
}

static void divide_error(Cpu *c, const Dec *d) {
    cpu_set_fault(c, CPU_FAULT_DIVIDE, d->eip, 0, "#DE divide error at %08x", d->eip);
}

/* ------------------------------------------------------------------ instruction groups */
static void group3(Cpu *c, Dec *d, uint32_t sz) {
    uint32_t m = szmask(sz);
    switch (d->reg) {
    case 0:
    case 1: {
        uint32_t imm = fimm(c, d, sz);
        if (FAULTED(c)) return;
        uint32_t v = rd_rm(c, d, sz);
        if (FAULTED(c)) return;
        alu(c, ALU_AND, v, imm, sz);
        return;
    }
    case 2: {
        uint32_t v = rd_rm(c, d, sz);
        if (FAULTED(c)) return;
        wr_rm(c, d, sz, ~v & m);
        return;
    }
    case 3: {
        uint32_t v = rd_rm(c, d, sz);
        if (FAULTED(c)) return;
        uint32_t res = alu(c, ALU_SUB, 0, v, sz);
        /* NEG: CF = (operand != 0); ALU_SUB from 0 gives exactly that */
        wr_rm(c, d, sz, res);
        return;
    }
    case 4:
    case 5: {
        uint32_t v = rd_rm(c, d, sz);
        if (FAULTED(c)) return;
        bool sgn = d->reg == 5, ovf;
        if (sz == 1) {
            uint32_t al = c->r[CPU_EAX] & 0xffu, p;
            if (sgn) {
                int32_t sp = (int32_t)(int8_t)al * (int32_t)(int8_t)v;
                p = (uint32_t)sp & 0xffffu;
                ovf = sp != (int32_t)(int8_t)sp;
            } else {
                p = al * v;
                ovf = (p & 0xff00u) != 0;
            }
            rset(c, CPU_EAX, 2, p);
            set_arith(c, szp(p, 1) | (ovf ? F_CF | F_OF : 0));
        } else if (sz == 2) {
            uint32_t ax = c->r[CPU_EAX] & 0xffffu, p;
            if (sgn) {
                int32_t sp = (int32_t)(int16_t)ax * (int32_t)(int16_t)v;
                p = (uint32_t)sp;
                ovf = sp != (int32_t)(int16_t)sp;
            } else {
                p = ax * v;
                ovf = (p >> 16) != 0;
            }
            rset(c, CPU_EAX, 2, p);
            rset(c, CPU_EDX, 2, p >> 16);
            set_arith(c, szp(p, 2) | (ovf ? F_CF | F_OF : 0));
        } else {
            uint64_t p;
            if (sgn) {
                int64_t sp = (int64_t)(int32_t)c->r[CPU_EAX] * (int64_t)(int32_t)v;
                p = (uint64_t)sp;
                ovf = sp != (int64_t)(int32_t)sp;
            } else {
                p = (uint64_t)c->r[CPU_EAX] * v;
                ovf = (p >> 32) != 0;
            }
            c->r[CPU_EAX] = (uint32_t)p;
            c->r[CPU_EDX] = (uint32_t)(p >> 32);
            set_arith(c, szp((uint32_t)p, 4) | (ovf ? F_CF | F_OF : 0));
        }
        return;
    }
    default: { /* 6 DIV, 7 IDIV: flags unchanged (QEMU), #DE on zero divisor or quotient overflow */
        uint32_t v = rd_rm(c, d, sz);
        if (FAULTED(c)) return;
        if (v == 0) {
            divide_error(c, d);
            return;
        }
        if (d->reg == 6) {
            if (sz == 1) {
                uint32_t n = c->r[CPU_EAX] & 0xffffu, q = n / v, r = n % v;
                if (q > 0xffu) return divide_error(c, d);
                rset(c, CPU_EAX, 2, q | r << 8);
            } else if (sz == 2) {
                uint32_t n = (c->r[CPU_EDX] & 0xffffu) << 16 | (c->r[CPU_EAX] & 0xffffu), q = n / v, r = n % v;
                if (q > 0xffffu) return divide_error(c, d);
                rset(c, CPU_EAX, 2, q);
                rset(c, CPU_EDX, 2, r);
            } else {
                uint64_t n = (uint64_t)c->r[CPU_EDX] << 32 | c->r[CPU_EAX], q = n / v, r = n % v;
                if (q > 0xffffffffull) return divide_error(c, d);
                c->r[CPU_EAX] = (uint32_t)q;
                c->r[CPU_EDX] = (uint32_t)r;
            }
        } else {
            if (sz == 1) {
                int32_t n = (int16_t)(c->r[CPU_EAX] & 0xffffu), dv = (int8_t)v, q = n / dv, r = n % dv;
                if (q != (int8_t)q) return divide_error(c, d);
                rset(c, CPU_EAX, 2, ((uint32_t)q & 0xffu) | ((uint32_t)r & 0xffu) << 8);
            } else if (sz == 2) {
                int32_t n = (int32_t)((c->r[CPU_EDX] & 0xffffu) << 16 | (c->r[CPU_EAX] & 0xffffu)), dv = (int16_t)v;
                int64_t q = (int64_t)n / dv, r = (int64_t)n % dv;
                if (q != (int16_t)q) return divide_error(c, d);
                rset(c, CPU_EAX, 2, (uint32_t)q);
                rset(c, CPU_EDX, 2, (uint32_t)r);
            } else {
                int64_t n = (int64_t)((uint64_t)c->r[CPU_EDX] << 32 | c->r[CPU_EAX]), dv = (int32_t)v;
                if (dv == -1 && n == INT64_MIN) return divide_error(c, d);
                int64_t q = n / dv, r = n % dv;
                if (q != (int32_t)q) return divide_error(c, d);
                c->r[CPU_EAX] = (uint32_t)q;
                c->r[CPU_EDX] = (uint32_t)r;
            }
        }
        return;
    }
    }
}

/* BT/BTS/BTR/BTC: kind 0..3. off = bit offset (register form: may address outside the operand). */
static void bitop(Cpu *c, Dec *d, uint32_t kind, uint32_t off, bool imm) {
    uint32_t sz = d->osz, bits = sz * 8u, ea = d->ea;
    if (d->mem && !imm) {
        int32_t so = (int32_t)sext(off, sz);
        ea += (uint32_t)((so >> (sz == 2 ? 4 : 5)) * (int32_t)sz);
    }
    uint32_t bit = off & (bits - 1u);
    uint32_t v = d->mem ? (uint32_t)rdm(c, ea, sz) : rget(c, d->rm, sz);
    if (FAULTED(c)) return;
    uint32_t cf = (v >> bit) & 1u, nv = v;
    if (kind == 1) nv = v | (1u << bit);
    else if (kind == 2) nv = v & ~(1u << bit);
    else if (kind == 3) nv = v ^ (1u << bit);
    if (kind) {
        if (d->mem) wrm(c, ea, sz, nv);
        else rset(c, d->rm, sz, nv);
        if (FAULTED(c)) return;
    }
    c->eflags = (c->eflags & ~F_CF) | cf;
}

static void string_op(Cpu *c, Dec *d, uint32_t op) {
    uint32_t sz = (op & 1u) ? d->osz : 1u, base = op & ~1u;
    uint32_t step = (c->eflags & F_DF) ? (uint32_t)-(int32_t)sz : sz;
    uint32_t sb = c->sbase[d->seg >= 0 ? d->seg : CPU_DS], db = c->sbase[CPU_ES];
    bool rep = d->rep != 0;
    if (rep && c->r[CPU_ECX] == 0) return;
    for (;;) {
        switch (base) {
        case 0xa4: {
            uint32_t v = (uint32_t)rdm(c, sb + c->r[CPU_ESI], sz);
            if (FAULTED(c)) return;
            wrm(c, db + c->r[CPU_EDI], sz, v);
            if (FAULTED(c)) return;
            c->r[CPU_ESI] += step;
            c->r[CPU_EDI] += step;
            break;
        }
        case 0xa6: {
            uint32_t a = (uint32_t)rdm(c, sb + c->r[CPU_ESI], sz);
            if (FAULTED(c)) return;
            uint32_t b = (uint32_t)rdm(c, db + c->r[CPU_EDI], sz);
            if (FAULTED(c)) return;
            alu(c, ALU_CMP, a, b, sz);
            c->r[CPU_ESI] += step;
            c->r[CPU_EDI] += step;
            break;
        }
        case 0xaa:
            wrm(c, db + c->r[CPU_EDI], sz, rget(c, CPU_EAX, sz));
            if (FAULTED(c)) return;
            c->r[CPU_EDI] += step;
            break;
        case 0xac: {
            uint32_t v = (uint32_t)rdm(c, sb + c->r[CPU_ESI], sz);
            if (FAULTED(c)) return;
            rset(c, CPU_EAX, sz, v);
            c->r[CPU_ESI] += step;
            break;
        }
        default: { /* 0xae SCAS */
            uint32_t b = (uint32_t)rdm(c, db + c->r[CPU_EDI], sz);
            if (FAULTED(c)) return;
            alu(c, ALU_CMP, rget(c, CPU_EAX, sz), b, sz);
            c->r[CPU_EDI] += step;
            break;
        }
        }
        if (!rep) return;
        if (--c->r[CPU_ECX] == 0) return;
        if (base == 0xa6 || base == 0xae) {
            bool zf = (c->eflags & F_ZF) != 0;
            if (d->rep == 0xf3 ? !zf : zf) return;
        }
    }
}

/* ------------------------------------------------------------------ one instruction */
static void step(Cpu *c) {
    Dec dd;
    Dec *d = &dd;
    uint32_t eip = c->eip;
    d->eip = eip;
    d->i = 0;
    {
        const CpuChunk *ch = &c->chunk[eip >> CPU_CHUNK_SHIFT];
        uint32_t o = eip & (CPU_CHUNK_SIZE - 1u);
        if (LIKELY(o >= ch->lo && o + 16u <= ch->len)) {
            d->b = ch->host + o;
            d->avail = 16;
        } else {
            d->avail = 0;
            while (d->avail < 16 && cpu_mapped(c, eip + d->avail, 1)) {
                uint32_t a = eip + d->avail;
                d->buf[d->avail++] = c->chunk[a >> CPU_CHUNK_SHIFT].host[a & (CPU_CHUNK_SIZE - 1u)];
            }
            d->b = d->buf;
        }
    }
    d->seg = -1;
    d->rep = 0;
    d->osz = 4;
    d->mem = false;
    uint32_t op;
    for (;;) {
        op = f8(c, d);
        if (FAULTED(c)) return;
        if (d->i > 14) return invalid(c, d, op);
        switch (op) {
        case 0x26: d->seg = CPU_ES; continue;
        case 0x2e: d->seg = CPU_CS; continue;
        case 0x36: d->seg = CPU_SS; continue;
        case 0x3e: d->seg = CPU_DS; continue;
        case 0x64: d->seg = CPU_FS; continue;
        case 0x65: d->seg = CPU_GS; continue;
        case 0x66: d->osz = 2; continue;
        case 0xf0: continue; /* LOCK: no effect in a single-threaded interpreter */
        case 0xf2:
        case 0xf3: d->rep = (uint8_t)op; continue;
        default: break;
        }
        break;
    }
    c->ctl = 0;
    uint32_t osz = d->osz;

    if (op < 0x40 && (op & 7u) < 6u && op != 0x0f) { /* ALU: ADD OR ADC SBB AND SUB XOR CMP */
        uint32_t aop = op >> 3, form = op & 7u, sz = (form & 1u) ? osz : 1u;
        if (form < 4) {
            modrm(c, d);
            if (FAULTED(c)) return;
            uint32_t a, b;
            if (form < 2) {
                a = rd_rm(c, d, sz);
                b = rget(c, d->reg, sz);
            } else {
                a = rget(c, d->reg, sz);
                b = rd_rm(c, d, sz);
            }
            if (FAULTED(c)) return;
            uint32_t res = alu(c, aop, a, b, sz);
            if (aop != ALU_CMP) {
                if (form < 2) wr_rm(c, d, sz, res);
                else rset(c, d->reg, sz, res);
            }
        } else {
            uint32_t imm = fimm(c, d, sz);
            if (FAULTED(c)) return;
            uint32_t res = alu(c, aop, rget(c, CPU_EAX, sz), imm, sz);
            if (aop != ALU_CMP) rset(c, CPU_EAX, sz, res);
        }
        goto done;
    }

    switch (op) {
    case 0x40: case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47:
        rset(c, op & 7u, osz, incdec(c, rget(c, op & 7u, osz), false, osz));
        break;
    case 0x48: case 0x49: case 0x4a: case 0x4b: case 0x4c: case 0x4d: case 0x4e: case 0x4f:
        rset(c, op & 7u, osz, incdec(c, rget(c, op & 7u, osz), true, osz));
        break;
    case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57:
        push(c, rget(c, op & 7u, osz), osz);
        break;
    case 0x58: case 0x59: case 0x5a: case 0x5b: case 0x5c: case 0x5d: case 0x5e: case 0x5f: {
        uint32_t v = pop(c, osz);
        if (FAULTED(c)) return;
        rset(c, op & 7u, osz, v);
        break;
    }
    case 0x60: { /* PUSHAD */
        if (osz != 4) return invalid(c, d, op);
        uint32_t sp = c->r[CPU_ESP], a = sp - 32u + c->sbase[CPU_SS];
        if (!cpu_mapped(c, a, 32)) {
            cpu_set_fault(c, CPU_FAULT_WRITE_UNMAPPED, a, 32, "PUSHAD at %08x: stack unmapped", eip);
            return;
        }
        for (uint32_t i = 0; i < 8; i++) wrm(c, a + 28u - 4u * i, 4, i == CPU_ESP ? sp : c->r[i]);
        c->r[CPU_ESP] = sp - 32u;
        break;
    }
    case 0x61: { /* POPAD */
        if (osz != 4) return invalid(c, d, op);
        uint32_t a = c->r[CPU_ESP] + c->sbase[CPU_SS], v[8];
        for (uint32_t i = 0; i < 8; i++) {
            v[i] = (uint32_t)rdm(c, a + 28u - 4u * i, 4);
            if (FAULTED(c)) return;
        }
        for (uint32_t i = 0; i < 8; i++)
            if (i != CPU_ESP) c->r[i] = v[i];
        c->r[CPU_ESP] += 32u;
        break;
    }
    case 0x68: {
        uint32_t imm = fimm(c, d, osz);
        if (FAULTED(c)) return;
        push(c, imm, osz);
        break;
    }
    case 0x6a: {
        uint32_t imm = sext(f8(c, d), 1);
        if (FAULTED(c)) return;
        push(c, imm, osz);
        break;
    }
    case 0x69:
    case 0x6b: {
        modrm(c, d);
        uint32_t imm = op == 0x69 ? fimm(c, d, osz) : sext(f8(c, d), 1);
        if (FAULTED(c)) return;
        uint32_t v = rd_rm(c, d, osz);
        if (FAULTED(c)) return;
        uint32_t res;
        bool ovf;
        if (osz == 2) {
            int32_t p = (int32_t)(int16_t)v * (int32_t)(int16_t)imm;
            res = (uint32_t)p & 0xffffu;
            ovf = p != (int32_t)(int16_t)p;
        } else {
            int64_t p = (int64_t)(int32_t)v * (int64_t)(int32_t)imm;
            res = (uint32_t)p;
            ovf = p != (int64_t)(int32_t)p;
        }
        rset(c, d->reg, osz, res);
        set_arith(c, szp(res, osz) | (ovf ? F_CF | F_OF : 0));
        break;
    }
    case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77:
    case 0x78: case 0x79: case 0x7a: case 0x7b: case 0x7c: case 0x7d: case 0x7e: case 0x7f: {
        uint32_t rel = sext(f8(c, d), 1);
        if (FAULTED(c)) return;
        c->ctl = 1;
        c->next_eip = eip + d->i;
        c->eip = cond(c, op & 15u) ? c->next_eip + rel : c->next_eip;
        return;
    }
    case 0x80:
    case 0x81:
    case 0x82:
    case 0x83: {
        uint32_t sz = op == 0x80 || op == 0x82 ? 1u : osz;
        modrm(c, d);
        uint32_t imm = op == 0x81 ? fimm(c, d, sz) : (op == 0x83 ? sext(f8(c, d), 1) : f8(c, d));
        if (FAULTED(c)) return;
        uint32_t a = rd_rm(c, d, sz);
        if (FAULTED(c)) return;
        uint32_t res = alu(c, d->reg, a, imm, sz);
        if (d->reg != ALU_CMP) wr_rm(c, d, sz, res);
        break;
    }
    case 0x84:
    case 0x85: {
        uint32_t sz = op == 0x84 ? 1u : osz;
        modrm(c, d);
        if (FAULTED(c)) return;
        uint32_t a = rd_rm(c, d, sz);
        if (FAULTED(c)) return;
        alu(c, ALU_AND, a, rget(c, d->reg, sz), sz);
        break;
    }
    case 0x86:
    case 0x87: {
        uint32_t sz = op == 0x86 ? 1u : osz;
        modrm(c, d);
        if (FAULTED(c)) return;
        uint32_t a = rd_rm(c, d, sz);
        if (FAULTED(c)) return;
        wr_rm(c, d, sz, rget(c, d->reg, sz));
        if (FAULTED(c)) return;
        rset(c, d->reg, sz, a);
        break;
    }
    case 0x88:
    case 0x89: {
        uint32_t sz = op == 0x88 ? 1u : osz;
        modrm(c, d);
        if (FAULTED(c)) return;
        wr_rm(c, d, sz, rget(c, d->reg, sz));
        break;
    }
    case 0x8a:
    case 0x8b: {
        uint32_t sz = op == 0x8a ? 1u : osz;
        modrm(c, d);
        if (FAULTED(c)) return;
        uint32_t v = rd_rm(c, d, sz);
        if (FAULTED(c)) return;
        rset(c, d->reg, sz, v);
        break;
    }
    case 0x8d:
        modrm(c, d);
        if (FAULTED(c)) return;
        if (!d->mem) return invalid(c, d, op);
        rset(c, d->reg, osz, d->off);
        break;
    case 0x8f: {
        modrm(c, d);
        if (FAULTED(c)) return;
        if (d->reg != 0) return invalid(c, d, op);
        uint32_t sp = c->r[CPU_ESP];
        uint32_t v = (uint32_t)rdm(c, sp + c->sbase[CPU_SS], osz);
        if (FAULTED(c)) return;
        if (d->mem) {
            uint32_t ea = d->ea + (d->esp_base ? osz : 0u); /* ESP base: address after the increment */
            wrm(c, ea, osz, v);
            if (FAULTED(c)) return;
            c->r[CPU_ESP] = sp + osz;
        } else {
            c->r[CPU_ESP] = sp + osz;
            rset(c, d->rm, osz, v);
        }
        break;
    }
    case 0x90:
        break;
    case 0x91: case 0x92: case 0x93: case 0x94: case 0x95: case 0x96: case 0x97: {
        uint32_t a = rget(c, CPU_EAX, osz);
        rset(c, CPU_EAX, osz, rget(c, op & 7u, osz));
        rset(c, op & 7u, osz, a);
        break;
    }
    case 0x98:
        if (osz == 2) rset(c, CPU_EAX, 2, sext(c->r[CPU_EAX] & 0xffu, 1));
        else c->r[CPU_EAX] = sext(c->r[CPU_EAX] & 0xffffu, 2);
        break;
    case 0x99:
        if (osz == 2) rset(c, CPU_EDX, 2, (c->r[CPU_EAX] & 0x8000u) ? 0xffffu : 0u);
        else c->r[CPU_EDX] = (c->r[CPU_EAX] & 0x80000000u) ? 0xffffffffu : 0u;
        break;
    case 0x9b: /* WAIT: QEMU raises #MF only with CR0.NE; Unicorn does not, so no effect */
        break;
    case 0x9e:
        c->eflags = (c->eflags & ~(F_SF | F_ZF | F_AF | F_PF | F_CF)) |
                    ((c->r[CPU_EAX] >> 8) & (F_SF | F_ZF | F_AF | F_PF | F_CF));
        break;
    case 0x9f:
        rset(c, 4, 1, (c->eflags & (F_SF | F_ZF | F_AF | F_PF | F_CF)) | 0x2u);
        break;
    case 0xa0: case 0xa1: case 0xa2: case 0xa3: {
        uint32_t sz = (op & 1u) ? osz : 1u, a = f32(c, d);
        if (FAULTED(c)) return;
        a += c->sbase[d->seg >= 0 ? d->seg : CPU_DS];
        if (op < 0xa2) {
            uint32_t v = (uint32_t)rdm(c, a, sz);
            if (FAULTED(c)) return;
            rset(c, CPU_EAX, sz, v);
        } else {
            wrm(c, a, sz, rget(c, CPU_EAX, sz));
        }
        break;
    }
    case 0xa4: case 0xa5: case 0xa6: case 0xa7: case 0xaa: case 0xab: case 0xac: case 0xad: case 0xae: case 0xaf:
        string_op(c, d, op);
        break;
    case 0xa8:
    case 0xa9: {
        uint32_t sz = op == 0xa8 ? 1u : osz, imm = fimm(c, d, sz);
        if (FAULTED(c)) return;
        alu(c, ALU_AND, rget(c, CPU_EAX, sz), imm, sz);
        break;
    }
    case 0xb0: case 0xb1: case 0xb2: case 0xb3: case 0xb4: case 0xb5: case 0xb6: case 0xb7: {
        uint32_t imm = f8(c, d);
        if (FAULTED(c)) return;
        rset(c, op & 7u, 1, imm);
        break;
    }
    case 0xb8: case 0xb9: case 0xba: case 0xbb: case 0xbc: case 0xbd: case 0xbe: case 0xbf: {
        uint32_t imm = fimm(c, d, osz);
        if (FAULTED(c)) return;
        rset(c, op & 7u, osz, imm);
        break;
    }
    case 0xc0: case 0xc1: case 0xd0: case 0xd1: case 0xd2: case 0xd3: {
        uint32_t sz = (op & 1u) ? osz : 1u;
        modrm(c, d);
        uint32_t cnt = op <= 0xc1 ? f8(c, d) : op <= 0xd1 ? 1u : c->r[CPU_ECX] & 0xffu;
        if (FAULTED(c)) return;
        uint32_t v = rd_rm(c, d, sz);
        if (FAULTED(c)) return;
        uint32_t res = shift(c, d->reg, v, cnt, sz);
        if (cnt & 0x1fu) wr_rm(c, d, sz, res);
        break;
    }
    case 0xc2:
    case 0xc3: {
        if (osz != 4) return invalid(c, d, op);
        uint32_t imm = op == 0xc2 ? f16(c, d) : 0u;
        if (FAULTED(c)) return;
        uint32_t ret = pop(c, 4);
        if (FAULTED(c)) return;
        c->r[CPU_ESP] += imm;
        c->ctl = 1;
        c->next_eip = eip + d->i;
        c->eip = ret;
        return;
    }
    case 0xc6:
    case 0xc7: {
        uint32_t sz = op == 0xc6 ? 1u : osz;
        modrm(c, d);
        uint32_t imm = fimm(c, d, sz);
        if (FAULTED(c)) return;
        if (d->reg != 0) return invalid(c, d, op);
        wr_rm(c, d, sz, imm);
        break;
    }
    case 0xc9: { /* LEAVE (QEMU order: load [EBP], then ESP = EBP + 4, EBP = value) */
        uint32_t ebp = c->r[CPU_EBP];
        uint32_t v = (uint32_t)rdm(c, ebp + c->sbase[CPU_SS], osz);
        if (FAULTED(c)) return;
        c->r[CPU_ESP] = ebp + osz;
        rset(c, CPU_EBP, osz, v);
        break;
    }
    case 0xcc:
        cpu_set_fault(c, CPU_FAULT_INT, eip, 0, "INT3 at %08x", eip);
        return;
    case 0xd8: case 0xd9: case 0xda: case 0xdb: case 0xdc: case 0xdd: case 0xde: case 0xdf: {
        uint32_t m = d->i < d->avail ? d->b[d->i] : 0u;
        modrm(c, d);
        if (FAULTED(c)) return;
        c->next_eip = eip + d->i;
        cpu_x87_exec(c, (uint8_t)op, (uint8_t)m, d->ea);
        if (FAULTED(c)) return;
        break;
    }
    case 0xe8:
    case 0xe9:
    case 0xeb: {
        if (osz != 4) return invalid(c, d, op);
        uint32_t rel = op == 0xeb ? sext(f8(c, d), 1) : f32(c, d);
        if (FAULTED(c)) return;
        uint32_t next = eip + d->i;
        if (op == 0xe8) {
            push(c, next, 4);
            if (FAULTED(c)) return;
        }
        c->ctl = 1;
        c->next_eip = next;
        c->eip = next + rel;
        return;
    }
    case 0xf4:
        cpu_set_fault(c, CPU_FAULT_INT, eip, 0, "HLT at %08x", eip);
        return;
    case 0xf5: c->eflags ^= F_CF; break;
    case 0xf8: c->eflags &= ~F_CF; break;
    case 0xf9: c->eflags |= F_CF; break;
    case 0xfc: c->eflags &= ~F_DF; break;
    case 0xfd: c->eflags |= F_DF; break;
    case 0xf6:
    case 0xf7:
        modrm(c, d);
        if (FAULTED(c)) return;
        group3(c, d, op == 0xf6 ? 1u : osz);
        if (FAULTED(c)) return;
        break;
    case 0xfe: {
        modrm(c, d);
        if (FAULTED(c)) return;
        if (d->reg > 1) return invalid(c, d, op);
        uint32_t v = rd_rm(c, d, 1);
        if (FAULTED(c)) return;
        uint32_t res = incdec(c, v, d->reg == 1, 1);
        wr_rm(c, d, 1, res);
        break;
    }
    case 0xff: {
        modrm(c, d);
        if (FAULTED(c)) return;
        switch (d->reg) {
        case 0:
        case 1: {
            uint32_t v = rd_rm(c, d, osz);
            if (FAULTED(c)) return;
            uint32_t res = incdec(c, v, d->reg == 1, osz);
            wr_rm(c, d, osz, res);
            break;
        }
        case 2:
        case 4: {
            if (osz != 4) return invalid(c, d, op);
            uint32_t t = rd_rm(c, d, 4);
            if (FAULTED(c)) return;
            uint32_t next = eip + d->i;
            if (d->reg == 2) {
                push(c, next, 4);
                if (FAULTED(c)) return;
            }
            c->ctl = 1;
            c->next_eip = next;
            c->eip = t;
            return;
        }
        case 6: {
            uint32_t v = rd_rm(c, d, osz);
            if (FAULTED(c)) return;
            push(c, v, osz);
            break;
        }
        default:
            return invalid(c, d, op);
        }
        break;
    }
    case 0x0f: {
        uint32_t op2 = f8(c, d);
        if (FAULTED(c)) return;
        if (op2 >= 0x80 && op2 <= 0x8f) {
            if (osz != 4) return invalid(c, d, op2 | 0x0f00u);
            uint32_t rel = f32(c, d);
            if (FAULTED(c)) return;
            c->ctl = 1;
            c->next_eip = eip + d->i;
            c->eip = cond(c, op2 & 15u) ? c->next_eip + rel : c->next_eip;
            return;
        }
        if (op2 >= 0x90 && op2 <= 0x9f) {
            modrm(c, d);
            if (FAULTED(c)) return;
            wr_rm(c, d, 1, cond(c, op2 & 15u) ? 1u : 0u);
            break;
        }
        switch (op2) {
        case 0xa3: case 0xab: case 0xb3: case 0xbb:
            modrm(c, d);
            if (FAULTED(c)) return;
            bitop(c, d, (op2 >> 3) & 3u, rget(c, d->reg, osz), false);
            break;
        case 0xba: {
            modrm(c, d);
            uint32_t imm = f8(c, d);
            if (FAULTED(c)) return;
            if (d->reg < 4) return invalid(c, d, 0x0fbau);
            bitop(c, d, d->reg - 4u, imm, true);
            break;
        }
        case 0xaf: {
            modrm(c, d);
            if (FAULTED(c)) return;
            uint32_t v = rd_rm(c, d, osz);
            if (FAULTED(c)) return;
            uint32_t a = rget(c, d->reg, osz), res;
            bool ovf;
            if (osz == 2) {
                int32_t p = (int32_t)(int16_t)a * (int32_t)(int16_t)v;
                res = (uint32_t)p & 0xffffu;
                ovf = p != (int32_t)(int16_t)p;
            } else {
                int64_t p = (int64_t)(int32_t)a * (int64_t)(int32_t)v;
                res = (uint32_t)p;
                ovf = p != (int64_t)(int32_t)p;
            }
            rset(c, d->reg, osz, res);
            set_arith(c, szp(res, osz) | (ovf ? F_CF | F_OF : 0));
            break;
        }
        case 0xb6: case 0xb7: case 0xbe: case 0xbf: {
            uint32_t ssz = (op2 & 1u) ? 2u : 1u;
            modrm(c, d);
            if (FAULTED(c)) return;
            uint32_t v = rd_rm(c, d, ssz);
            if (FAULTED(c)) return;
            if (op2 >= 0xbe) v = sext(v, ssz);
            rset(c, d->reg, osz, v);
            break;
        }
        default:
            return invalid(c, d, 0x0f00u | op2);
        }
        break;
    }
    default:
        return invalid(c, d, op);
    }
done:
    if (FAULTED(c)) return;
    c->next_eip = eip + d->i;
    c->eip = c->next_eip;
}

/* ------------------------------------------------------------------ instruction length */
enum { L_M = 1, L_I8 = 2, L_IZ = 4, L_I16 = 8, L_MOFFS = 16, L_G3 = 32 };

static uint32_t op_class(uint32_t op) {
    if (op < 0x40) {
        uint32_t f = op & 7u;
        return f < 4 ? L_M : f == 4 ? L_I8 : f == 5 ? L_IZ : 0;
    }
    if (op >= 0x70 && op <= 0x7f) return L_I8;
    if (op >= 0x84 && op <= 0x8f) return L_M;
    if (op >= 0xa0 && op <= 0xa3) return L_MOFFS;
    if (op >= 0xb0 && op <= 0xb7) return L_I8;
    if (op >= 0xb8 && op <= 0xbf) return L_IZ;
    if (op >= 0xd8 && op <= 0xdf) return L_M;
    if (op >= 0xe0 && op <= 0xe7) return L_I8;
    switch (op) {
    case 0x62: case 0x63: case 0xc4: case 0xc5: case 0xd0: case 0xd1: case 0xd2: case 0xd3: case 0xfe: case 0xff:
        return L_M;
    case 0x68: case 0xe8: case 0xe9: case 0xa9: return L_IZ;
    case 0x69: case 0x81: case 0xc7: return L_M | L_IZ;
    case 0x6a: case 0xa8: case 0xcd: case 0xd4: case 0xd5: case 0xeb: return L_I8;
    case 0x6b: case 0x80: case 0x82: case 0x83: case 0xc0: case 0xc1: case 0xc6: return L_M | L_I8;
    case 0x9a: case 0xea: return L_IZ | L_I16;
    case 0xc2: case 0xca: return L_I16;
    case 0xc8: return L_I16 | L_I8;
    case 0xf6: case 0xf7: return L_M | L_G3;
    default: return 0;
    }
}

static uint32_t op2_class(uint32_t op2) {
    if (op2 >= 0x80 && op2 <= 0x8f) return L_IZ;
    if ((op2 >= 0x90 && op2 <= 0x9f) || (op2 >= 0x40 && op2 <= 0x4f)) return L_M;
    switch (op2) {
    case 0xa3: case 0xab: case 0xb3: case 0xbb: case 0xaf: case 0xb6: case 0xb7: case 0xbe: case 0xbf:
    case 0xa5: case 0xad: case 0xb0: case 0xb1: case 0xc0: case 0xc1:
        return L_M;
    case 0xba: case 0xa4: case 0xac: return L_M | L_I8;
    default: return 0;
    }
}

/* Length of the instruction at eip from its bytes; 0 if a byte is unmapped. */
uint32_t cpu_insn_len(Cpu *c, uint32_t eip) {
    uint8_t b[16];
    uint32_t n = 0;
    while (n < 16 && cpu_mem_read(c, eip + n, &b[n], 1)) n++;
    uint32_t i = 0, osz = 4, op;
    for (;;) {
        if (i >= n) return 0;
        op = b[i++];
        if (op == 0x26 || op == 0x2e || op == 0x36 || op == 0x3e || op == 0x64 || op == 0x65 || op == 0xf0 ||
            op == 0xf2 || op == 0xf3 || op == 0x67)
            continue;
        if (op == 0x66) {
            osz = 2;
            continue;
        }
        break;
    }
    uint32_t cls;
    if (op == 0x0f) {
        if (i >= n) return 0;
        cls = op2_class(b[i++]);
    } else {
        cls = op_class(op);
    }
    if (cls & L_M) {
        if (i >= n) return 0;
        uint32_t m = b[i++], mod = m >> 6, rm = m & 7u;
        if (mod != 3) {
            if (rm == 4) {
                if (i >= n) return 0;
                uint32_t sib = b[i++];
                if (mod == 0 && (sib & 7u) == 5) i += 4;
            } else if (mod == 0 && rm == 5) {
                i += 4;
            }
            if (mod == 1) i += 1;
            else if (mod == 2) i += 4;
        }
        if ((cls & L_G3) && ((m >> 3) & 7u) < 2) i += op == 0xf6 ? 1u : osz;
    }
    if (cls & L_I8) i += 1;
    if (cls & L_IZ) i += osz;
    if (cls & L_I16) i += 2;
    if (cls & L_MOFFS) i += 4;
    return i <= n ? i : 0;
}

/* ------------------------------------------------------------------ translation blocks */
/* True if the instruction ends a QEMU translation block: jumps, calls, returns, INT/HLT, POPF,
 * STI and REP/REPNE string instructions (QEMU 5 target/i386 translate.c, gen_eob/gen_jmp). */
static bool tb_ender(Cpu *c, uint32_t pc) {
    uint8_t b[16];
    uint32_t n = 0;
    while (n < 16 && cpu_mem_read(c, pc + n, &b[n], 1)) n++;
    uint32_t i = 0;
    bool rep = false;
    while (i < n && (b[i] == 0x26 || b[i] == 0x2e || b[i] == 0x36 || b[i] == 0x3e || b[i] == 0x64 || b[i] == 0x65 ||
                     b[i] == 0x66 || b[i] == 0x67 || b[i] == 0xf0 || b[i] == 0xf2 || b[i] == 0xf3)) {
        if (b[i] == 0xf2 || b[i] == 0xf3) rep = true;
        i++;
    }
    if (i >= n) return true;
    uint32_t op = b[i];
    if (op == 0x0f) return i + 1 < n && b[i + 1] >= 0x80 && b[i + 1] <= 0x8f;
    if ((op >= 0x70 && op <= 0x7f) || (op >= 0xe0 && op <= 0xe3) || (op >= 0xe8 && op <= 0xeb)) return true;
    switch (op) {
    case 0x9a: case 0x9d: case 0xc2: case 0xc3: case 0xca: case 0xcb: case 0xcc: case 0xcd: case 0xce: case 0xcf:
    case 0xf4: case 0xfb:
        return true;
    case 0xff: {
        uint32_t reg = i + 1 < n ? (b[i + 1] >> 3) & 7u : 0u;
        return reg >= 2 && reg <= 5;
    }
    default:
        return rep && ((op >= 0xa4 && op <= 0xa7) || (op >= 0xaa && op <= 0xaf));
    }
}

/* Size of the QEMU translation block that starts at pc (block hooks report it at block start, like
 * Unicorn): up to and including the first block-ending instruction, at most 512 instructions or
 * 4064 bytes, never including the stop address of the run. */
static uint32_t tb_size(Cpu *c, uint32_t start, uint32_t until) {
    uint32_t pc = start;
    for (uint32_t n = 0; n < 512; n++) {
        if (pc == until && pc != start) break;
        uint32_t len = cpu_insn_len(c, pc);
        if (len == 0) break;
        bool end = tb_ender(c, pc);
        pc += len;
        if (end || pc - start >= 4096u - 32u) break;
    }
    return pc - start;
}

/* ------------------------------------------------------------------ run loop */
CpuRunResult cpu_run(Cpu *c, uint32_t begin, uint32_t until, uint64_t max_insn) {
    c->eip = begin;
    if (c->m.depth == 0) {
        c->stop_req = 0;
        cpu_clear_fault(c);
    }
    c->blk_open = false;
    uint64_t n = 0;
    for (;;) {
        uint32_t eip = c->eip;
        if (eip == until) return CPU_RUN_UNTIL;
        if (max_insn && n >= max_insn) return CPU_RUN_COUNT;
        if (c->stop_req) return FAULTED(c) ? CPU_RUN_FAULT : (c->susp_req ? CPU_RUN_SUSPENDED : CPU_RUN_STOPPED);
        if (c->m.on && eip - CPU_STUB_LO < CPU_STUB_SIZE) {
            c->blk_open = false;
            cpu_thunk(c, eip);
            n++;
            c->icount++;
            if (FAULTED(c)) return CPU_RUN_FAULT;
            continue;
        }
        if (UNLIKELY(c->block_hook_on) && (!c->blk_open || eip == c->blk_end)) {
            uint32_t size = tb_size(c, eip, until);
            c->blk_open = true;
            c->blk_end = eip + size;
            block_hooks(c, eip, size);
            if (FAULTED(c)) return CPU_RUN_FAULT;
            if (c->stop_req) return CPU_RUN_STOPPED;
            if (c->eip != eip) {
                c->blk_open = false;
                continue;
            }
        }
        if (UNLIKELY(c->code_hook_on)) {
            code_hooks(c, eip);
            if (FAULTED(c)) return CPU_RUN_FAULT;
            if (c->stop_req) return CPU_RUN_STOPPED;
            if (c->eip != eip) {
                c->blk_open = false;
                continue;
            }
        }
        step(c);
        if (FAULTED(c)) {
            c->eip = eip;
            return CPU_RUN_FAULT;
        }
        n++;
        c->icount++;
        if (c->ctl) c->blk_open = false;
    }
}
