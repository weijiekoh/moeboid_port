/* x87 unit of the interpreter (M2). docs/port-design.md section 5, analysis/verification.md 3.
 *
 * Model: 8 physical registers as double, TOP, tag (empty or not), status word with C0..C3 and the
 * exception bits, control word (precision control, rounding control). The CRT of the gam sets
 * precision control 53 bit (G:0x10005976); at PC = 53 every FADD/FSUB/FMUL/FDIV/FSQRT result of the
 * x87 equals the IEEE double result for the value ranges of the game (verification.md 3.2).
 *
 * Exact 80-bit values: a register also keeps the exact 80-bit value when that value is not a
 * double (FLD m80, FILD m64 above 2^53, FSIN/FCOS table results). FMUL, FST/FSTP to memory, FIST,
 * FCOM, FCHS, FABS, FLD ST(i), FST ST(i), FXCH use the exact value; FMUL rounds the exact product
 * once to the precision-control width with the rounding control (integer arithmetic). This is path D
 * of analysis/verification/fpu/fsin_check.c (mul80_pc53) and gives the x87 result of the spawn
 * code FSIN G:0x1000125d; FMUL G:0x1000125f and FCOS G:0x1000126e; FMUL G:0x10001270
 * (verification.md 3.1). Other operations on an exact 80-bit value use its nearest double (the game
 * has none). No code address is special-cased: FSIN and FCOS always read the table.
 *
 * Behaviour that follows Unicorn 2.1.4 (QEMU) where Intel differs or leaves it undefined (verified by
 * port/tests/py/test_insn_diff.py): no stack-fault detection (push onto a full stack and pop of an
 * empty register just move TOP), a register write does not change its tag, C1 is never set by
 * arithmetic or compares (Intel: rounding direction / 0), FDIV with a zero divisor sets ZE (also
 * 0/0), FSQRT of a negative value (also -0) sets C2 and clears C0, C1, C3, inexact and other
 * exception flags are not recorded. Known limits (outside the game's value ranges, documented in the
 * test): precision control 64 bit and arithmetic under rounding control other than nearest compute in
 * double with round-to-nearest; values beyond the double exponent range. */
#include "cpu_int.h"
#include "fsin_table.h"

typedef union {
    double d;
    uint64_t u;
} DU;
typedef union {
    float f;
    uint32_t u;
} FU;

#define RC_NEAR 0u
#define RC_DOWN 1u
#define RC_UP 2u
#define RC_CHOP 3u

#define FSW_IE 0x0001u
#define FSW_ZE 0x0004u
#define FSW_C0 0x0100u
#define FSW_C1 0x0200u
#define FSW_C2 0x0400u
#define FSW_C3 0x4000u

static inline uint32_t st_phys(const Cpu *c, uint32_t i) { return (c->top + i) & 7u; }
static inline uint32_t rc_of(const Cpu *c) { return (c->fcw >> 10) & 3u; }
/* Significand bits for the precision-control field: 0 = 24, 2 = 53, 1 and 3 = 64 (QEMU). */
static inline uint32_t pc_bits(const Cpu *c) {
    uint32_t pc = (c->fcw >> 8) & 3u;
    return pc == 0 ? 24u : pc == 2 ? 53u : 64u;
}

/* ------------------------------------------------------------------ 80-bit helpers */
F80 f80_from_double(double d) {
    DU u = {.d = d};
    uint16_t s = (uint16_t)((u.u >> 48) & 0x8000u);
    uint32_t e = (uint32_t)(u.u >> 52) & 0x7ffu;
    uint64_t f = u.u & 0xfffffffffffffull;
    F80 r;
    if (e == 0x7ffu) {
        r.se = (uint16_t)(s | 0x7fffu);
        r.m = f ? (0xc000000000000000ull | (f << 11)) : 0x8000000000000000ull;
    } else if (e == 0) {
        if (f == 0) {
            r.se = s;
            r.m = 0;
        } else {
            uint32_t p = 63u - (uint32_t)__builtin_clzll(f); /* value = f * 2^-1074 */
            r.m = f << (63u - p);
            r.se = (uint16_t)(s | (15309u + p));
        }
    } else {
        r.m = 0x8000000000000000ull | (f << 11);
        r.se = (uint16_t)(s | (e - 1023u + 16383u));
    }
    return r;
}

/* Unpacked finite nonzero value: (-1)^sign * (hi:lo) * 2^(E - 127), bit 127 of hi:lo set. */
typedef struct Unp {
    int sign;
    uint64_t hi, lo;
    int32_t E;
} Unp;

/* kind: 0 zero, 1 finite nonzero (u filled), 2 infinity, 3 NaN */
static int f80_unpack(F80 x, Unp *u) {
    uint32_t e = x.se & 0x7fffu;
    u->sign = (x.se >> 15) & 1;
    if (e == 0x7fffu) return (x.m << 1) ? 3 : 2;
    if (x.m == 0) return 0;
    uint32_t z = (uint32_t)__builtin_clzll(x.m);
    u->hi = x.m << z;
    u->lo = 0;
    u->E = (e == 0 ? 1 : (int32_t)e) - 16383 - (int32_t)z;
    return 1;
}

/* Round the top n bits (1..64) of the normalized significand. Returns the rounded value; when the
 * rounding carries out (result 2^n) *carry = 1 and the return value is 2^(n-1). */
static uint64_t rnd_sig(uint64_t hi, uint64_t lo, uint32_t n, int sign, uint32_t rc, int *carry) {
    uint64_t q;
    int rb, sticky;
    if (n == 64) {
        q = hi;
        rb = (int)(lo >> 63);
        sticky = (lo << 1) != 0;
    } else {
        q = hi >> (64u - n);
        uint64_t rem = hi << n;
        rb = (int)(rem >> 63);
        sticky = (rem << 1) != 0 || lo != 0;
    }
    int up;
    switch (rc) {
    case RC_NEAR: up = rb && (sticky || (q & 1u)); break;
    case RC_DOWN: up = (rb || sticky) && sign; break;
    case RC_UP: up = (rb || sticky) && !sign; break;
    default: up = 0; break;
    }
    *carry = 0;
    if (up) {
        q++;
        if (n == 64 ? q == 0 : (q >> n) != 0) {
            *carry = 1;
            q = 1ull << (n - 1u);
        }
    }
    return q;
}

/* Round to an integer magnitude with n = E + 1 integer bits; returns false on overflow (> 64 bits). */
static bool rnd_int(const Unp *u, uint32_t rc, uint64_t *mag) {
    int32_t n = u->E + 1;
    if (n > 64) return false;
    if (n >= 1) {
        int carry;
        uint64_t q = rnd_sig(u->hi, u->lo, (uint32_t)n, u->sign, rc, &carry);
        if (carry) {
            if (n == 64) return false;
            q = 1ull << n;
        }
        *mag = q;
        return true;
    }
    int rb = n == 0, sticky = n == 0 ? ((u->hi << 1) != 0 || u->lo != 0) : 1;
    int up;
    switch (rc) {
    case RC_NEAR: up = rb && sticky; break; /* q = 0 is even: a tie rounds to 0 */
    case RC_DOWN: up = u->sign; break;
    case RC_UP: up = !u->sign; break;
    default: up = 0; break;
    }
    *mag = up ? 1u : 0u;
    return true;
}

static double dbl_bits(uint64_t b) {
    DU u = {.u = b};
    return u.d;
}

static double overflow_double(int sign, uint32_t rc) {
    uint64_t s = (uint64_t)sign << 63;
    bool inf = rc == RC_NEAR || (rc == RC_UP && !sign) || (rc == RC_DOWN && sign);
    return dbl_bits(s | (inf ? 0x7ff0000000000000ull : 0x7fefffffffffffffull));
}

/* Round an unpacked value to double (53 bits, double exponent range, denormals). */
static double unp_to_double(const Unp *u, uint32_t rc) {
    uint64_t s = (uint64_t)u->sign << 63;
    int32_t E = u->E;
    if (E > 1023) return overflow_double(u->sign, rc);
    int carry;
    if (E >= -1022) {
        uint64_t q = rnd_sig(u->hi, u->lo, 53, u->sign, rc, &carry);
        if (carry) E++;
        if (E > 1023) return overflow_double(u->sign, rc);
        return dbl_bits(s | (uint64_t)(E + 1023) << 52 | (q & 0xfffffffffffffull));
    }
    Unp t = *u;
    t.E = E + 1074; /* value in units of 2^-1074; integer rounding gives the denormal significand */
    uint64_t mag;
    rnd_int(&t, rc, &mag); /* mag <= 2^52 (2^52 = smallest normal, encoded by the same bits) */
    return dbl_bits(s | mag);
}

static uint32_t unp_to_float_bits(const Unp *u, uint32_t rc) {
    uint32_t s = (uint32_t)u->sign << 31;
    int32_t E = u->E;
    bool inf = rc == RC_NEAR || (rc == RC_UP && !u->sign) || (rc == RC_DOWN && u->sign);
    uint32_t ovf = s | (inf ? 0x7f800000u : 0x7f7fffffu);
    if (E > 127) return ovf;
    int carry;
    if (E >= -126) {
        uint64_t q = rnd_sig(u->hi, u->lo, 24, u->sign, rc, &carry);
        if (carry) E++;
        if (E > 127) return ovf;
        return s | (uint32_t)(E + 127) << 23 | ((uint32_t)q & 0x7fffffu);
    }
    Unp t = *u;
    t.E = E + 149;
    uint64_t mag;
    rnd_int(&t, rc, &mag);
    return s | (uint32_t)mag;
}

/* Round to n significant bits (24, 53, 64) keeping the 15-bit exponent: the x87 register result. */
static F80 unp_to_f80(const Unp *u, uint32_t n, uint32_t rc) {
    int carry;
    uint64_t q = rnd_sig(u->hi, u->lo, n, u->sign, rc, &carry);
    int32_t E = u->E + carry;
    F80 r;
    if (E > 16383) {
        r.se = (uint16_t)((u->sign << 15) | 0x7fff);
        r.m = 0x8000000000000000ull;
        return r;
    }
    if (E < -16382) E = -16382; /* x87 denormal range: not reachable by the game (approximation) */
    r.m = q << (64u - n);
    r.se = (uint16_t)((u->sign << 15) | (uint32_t)(E + 16383));
    return r;
}

double f80_to_double(F80 v) {
    Unp u;
    switch (f80_unpack(v, &u)) {
    case 0: return dbl_bits((uint64_t)(v.se >> 15) << 63);
    case 2: return dbl_bits((uint64_t)(v.se >> 15) << 63 | 0x7ff0000000000000ull);
    case 3: return dbl_bits((uint64_t)(v.se >> 15) << 63 | 0x7ff8000000000000ull | ((v.m << 1) >> 12));
    default: return unp_to_double(&u, RC_NEAR);
    }
}

bool f80_is_double(F80 v) {
    if ((v.se & 0x7fffu) == 0x7fffu) return true; /* infinities and NaNs: kept as double */
    F80 r = f80_from_double(f80_to_double(v));
    if (v.m == 0) return true;
    return r.m == v.m && r.se == v.se;
}

/* ------------------------------------------------------------------ register values */
typedef struct FV {
    double d; /* nearest double */
    F80 x; /* exact value if ext */
    bool ext;
} FV;

static inline FV fv_d(double d) {
    FV v;
    v.d = d;
    v.x.m = 0;
    v.x.se = 0;
    v.ext = false;
    return v;
}
static FV fv_x(F80 x) {
    FV v;
    v.d = f80_to_double(x);
    v.x = x;
    v.ext = !f80_is_double(x);
    return v;
}
static inline FV fv_reg(const Cpu *c, uint32_t p) {
    FV v;
    v.d = c->st[p];
    v.x = c->ext[p];
    v.ext = c->ext_ok[p] != 0;
    return v;
}
static inline F80 fv_f80(FV v) { return v.ext ? v.x : f80_from_double(v.d); }
static inline void set_reg(Cpu *c, uint32_t p, FV v) {
    c->st[p] = v.d;
    c->ext[p] = v.x;
    c->ext_ok[p] = v.ext;
}
static inline void fpush(Cpu *c) {
    c->top = (c->top - 1u) & 7u;
    c->empty[c->top] = 0;
}
static inline void fpop(Cpu *c) {
    c->empty[c->top] = 1;
    c->top = (c->top + 1u) & 7u;
}
static void set_exc(Cpu *c, uint16_t mask) {
    c->fsw |= mask;
    if (c->fsw & ~c->fcw & 0x3fu) c->fsw |= 0x8080u; /* ES and B when unmasked (QEMU) */
}

/* Precision control 24 bit: round the double result to 24 significant bits, nearest-even, keeping
 * the exponent (the x87 register keeps its 15-bit exponent; a float cast would overflow at 2^128).
 * Rounding the exact result to 53 and then to 24 bits equals one rounding to 24 bits for
 * + - * / sqrt (53 >= 2 * 24 + 2). Denormal doubles are outside the game's ranges and kept. */
static double pc_round(const Cpu *c, double r) {
    if (pc_bits(c) != 24) return r;
    DU u = {.d = r};
    uint32_t e = (uint32_t)(u.u >> 52) & 0x7ffu;
    if (e == 0 || e == 0x7ffu) return r;
    uint64_t rem = u.u & 0x1fffffffull, half = 0x10000000ull;
    u.u &= ~0x1fffffffull;
    if (rem > half || (rem == half && (u.u & 0x20000000ull))) u.u += 0x20000000ull;
    return u.d;
}

static FV fmul_exact(Cpu *c, FV a, FV b) {
    Unp ua, ub;
    int ka = f80_unpack(fv_f80(a), &ua), kb = f80_unpack(fv_f80(b), &ub);
    if (ka != 1 || kb != 1) return fv_d(pc_round(c, a.d * b.d));
    Unp p;
    p.sign = ua.sign ^ ub.sign;
    uint64_t a0 = ua.hi & 0xffffffffu, a1 = ua.hi >> 32, b0 = ub.hi & 0xffffffffu, b1 = ub.hi >> 32;
    uint64_t p00 = a0 * b0, p01 = a0 * b1, p10 = a1 * b0, p11 = a1 * b1;
    uint64_t mid = (p00 >> 32) + (p01 & 0xffffffffu) + (p10 & 0xffffffffu);
    uint64_t lo = (p00 & 0xffffffffu) | (mid << 32);
    uint64_t hi = p11 + (p01 >> 32) + (p10 >> 32) + (mid >> 32);
    p.E = ua.E + ub.E;
    if (hi >> 63) {
        p.E += 1;
    } else {
        hi = hi << 1 | lo >> 63;
        lo <<= 1;
    }
    p.hi = hi;
    p.lo = lo;
    return fv_x(unp_to_f80(&p, pc_bits(c), rc_of(c)));
}

/* a op b. op: 0 add, 1 mul, 4 sub (a - b), 5 subr (b - a), 6 div (a / b), 7 divr (b / a). */
static FV fop(Cpu *c, uint32_t op, FV a, FV b) {
    if (op == 5 || op == 7) {
        FV t = a;
        a = b;
        b = t;
        op--;
    }
    if (op == 1 && (a.ext || b.ext)) return fmul_exact(c, a, b);
    double r;
    switch (op) {
    case 0: r = a.d + b.d; break;
    case 1: r = a.d * b.d; break;
    case 4: r = a.d - b.d; break;
    default:
        if (b.d == 0.0) set_exc(c, FSW_ZE);
        r = a.d / b.d;
        break;
    }
    return fv_d(pc_round(c, r));
}

static int fcmp(FV a, FV b) { /* -1 less, 0 equal, 1 greater, 2 unordered */
    if (!a.ext && !b.ext) {
        if (a.d != a.d || b.d != b.d) return 2;
        return a.d < b.d ? -1 : a.d == b.d ? 0 : 1;
    }
    F80 x = fv_f80(a), y = fv_f80(b);
    Unp ux = {0, 0, 0, 0}, uy = {0, 0, 0, 0};
    int kx = f80_unpack(x, &ux), ky = f80_unpack(y, &uy);
    if (kx == 3 || ky == 3) return 2;
    if (kx == 0 && ky == 0) return 0;
    /* compare as signed magnitudes: zero is (sign 0, E very small) */
    int sx = kx == 0 ? 0 : ux.sign, sy = ky == 0 ? 0 : uy.sign;
    if (sx != sy) return sx ? -1 : 1;
    int mag; /* |x| vs |y| */
    if (kx == 0) mag = -1;
    else if (ky == 0) mag = 1;
    else if (kx == 2 || ky == 2) mag = (kx == 2) - (ky == 2);
    else if (ux.E != uy.E) mag = ux.E < uy.E ? -1 : 1;
    else mag = ux.hi < uy.hi ? -1 : ux.hi > uy.hi ? 1 : 0;
    return sx ? -mag : mag;
}

static void fcom_set(Cpu *c, int r) {
    static const uint16_t cc[4] = {FSW_C0, FSW_C3, 0, FSW_C0 | FSW_C2 | FSW_C3};
    c->fsw = (uint16_t)((c->fsw & ~(FSW_C0 | FSW_C2 | FSW_C3)) | cc[r + 1]);
}

/* ------------------------------------------------------------------ conversions to memory */
static uint32_t fv_to_f32(const Cpu *c, FV v) {
    uint32_t rc = rc_of(c);
    if (!v.ext && rc == RC_NEAR) {
        FU u = {.f = (float)v.d};
        return u.u;
    }
    F80 x = fv_f80(v);
    Unp u;
    switch (f80_unpack(x, &u)) {
    case 0: return (uint32_t)(x.se >> 15) << 31;
    case 2: return (uint32_t)(x.se >> 15) << 31 | 0x7f800000u;
    case 3: return (uint32_t)(x.se >> 15) << 31 | 0x7fc00000u | (uint32_t)((x.m << 1) >> 41);
    default: return unp_to_float_bits(&u, rc);
    }
}

static uint64_t fv_to_f64(const Cpu *c, FV v) {
    DU r;
    if (!v.ext) {
        r.d = v.d;
        return r.u;
    }
    Unp u;
    if (f80_unpack(v.x, &u) != 1) r.d = v.d;
    else r.d = unp_to_double(&u, rc_of(c));
    return r.u;
}

/* FIST: bytes = 2, 4, 8; integer indefinite on overflow, NaN, infinity. */
static uint64_t fv_to_int(const Cpu *c, FV v, uint32_t bytes) {
    uint64_t indef = 1ull << (bytes * 8u - 1u);
    Unp u;
    int k = f80_unpack(fv_f80(v), &u);
    if (k == 0) return 0;
    if (k != 1) return indef;
    uint64_t mag;
    if (!rnd_int(&u, rc_of(c), &mag)) return indef;
    if (mag == 0) return 0;
    if (u.sign ? mag > indef : mag > indef - 1u) return indef;
    uint64_t r = u.sign ? (uint64_t)0 - mag : mag;
    return bytes == 8 ? r : r & ((1ull << (bytes * 8u)) - 1u);
}

static FV fv_from_i64(int64_t v) {
    uint64_t mag = v < 0 ? (uint64_t)0 - (uint64_t)v : (uint64_t)v;
    if (mag == 0) return fv_d(0.0);
    uint32_t lz = (uint32_t)__builtin_clzll(mag), tz = (uint32_t)__builtin_ctzll(mag);
    if (64u - lz - tz <= 53u) return fv_d((double)v);
    F80 x;
    x.m = mag << lz;
    x.se = (uint16_t)((v < 0 ? 0x8000u : 0u) | (uint32_t)(16383 + 63 - (int32_t)lz));
    return fv_x(x);
}

static FV ld_mem(Cpu *c, uint32_t kind, uint32_t ea) {
    /* kind: 0 m32 real, 1 m32 int, 2 m64 real, 3 m16 int (the D8/DA/DC/DE operand order) */
    switch (kind) {
    case 0: {
        FU u = {.u = (uint32_t)rdm(c, ea, 4)};
        return fv_d((double)u.f);
    }
    case 1: return fv_d((double)(int32_t)(uint32_t)rdm(c, ea, 4));
    case 2: {
        DU u = {.u = rdm(c, ea, 8)};
        return fv_d(u.d);
    }
    default: return fv_d((double)(int16_t)(uint16_t)rdm(c, ea, 2));
    }
}

/* ------------------------------------------------------------------ FSIN/FCOS table */
void cpu_set_fsin_table(Cpu *c, const CpuFsinEntry *t, uint32_t n) {
    c->fsin = t;
    c->nfsin = n;
}
void cpu_fsin_default(Cpu *c) { cpu_set_fsin_table(c, cpu_fsin_table_default, CPU_FSIN_TABLE_N); }

static int f80_key_cmp(uint16_t se, uint64_t m, uint16_t se2, uint64_t m2) {
    /* entries are sorted by value; arguments of the table are >= 0 */
    if (se != se2) return se < se2 ? -1 : 1;
    return m < m2 ? -1 : m > m2 ? 1 : 0;
}

/* FSIN (cosine = false) or FCOS of ST0 through the x87 table (G:0x1000125d FSIN, G:0x1000126e FCOS;
 * verification.md 3.1). QEMU semantics for |x| >= 2^63: C2 = 1, ST0 unchanged. */
static void fsincos(Cpu *c, bool cosine) {
    uint32_t p = st_phys(c, 0);
    F80 x = fv_f80(fv_reg(c, p));
    if ((x.se & 0x7fffu) >= 16383u + 63u) {
        c->fsw |= FSW_C2;
        return;
    }
    if ((x.se & 0x8000u) == 0) {
        uint32_t lo = 0, hi = c->nfsin;
        while (lo < hi) {
            uint32_t mid = (lo + hi) / 2;
            const CpuFsinEntry *e = &c->fsin[mid];
            int r = f80_key_cmp(x.se, x.m, e->arg_se, e->arg_m);
            if (r == 0) {
                F80 v;
                v.m = cosine ? e->cos_m : e->sin_m;
                v.se = cosine ? e->cos_se : e->sin_se;
                set_reg(c, p, fv_x(v));
                c->fsw &= (uint16_t)~FSW_C2;
                return;
            }
            if (r < 0) hi = mid;
            else lo = mid + 1;
        }
    }
    cpu_set_fault(c, CPU_FAULT_FSIN_TABLE, 0, 0, "%s argument %04x:%016llx not in the x87 table", cosine ? "FCOS" : "FSIN",
                  x.se, (unsigned long long)x.m);
}

/* ------------------------------------------------------------------ state access */
void cpu_x87_reset(Cpu *c) {
    c->fcw = 0x037f;
    c->fsw = 0;
    c->top = 0;
    for (int i = 0; i < 8; i++) c->empty[i] = 1;
}

void cpu_fpu_get_reg(const Cpu *c, int phys, uint64_t *mant, uint16_t *se) {
    F80 x = fv_f80(fv_reg(c, (uint32_t)phys & 7u));
    *mant = x.m;
    *se = x.se;
}
void cpu_fpu_set_reg(Cpu *c, int phys, uint64_t mant, uint16_t se) {
    F80 x;
    x.m = mant;
    x.se = se;
    set_reg(c, (uint32_t)phys & 7u, fv_x(x));
}
double cpu_fpu_get_double(const Cpu *c, int phys) { return c->st[phys & 7]; }
uint16_t cpu_fpu_get_cw(const Cpu *c) { return c->fcw; }
void cpu_fpu_set_cw(Cpu *c, uint16_t cw) { c->fcw = cw; }
uint16_t cpu_fpu_get_sw(const Cpu *c) { return (uint16_t)((c->fsw & ~0x3800u) | (c->top & 7u) << 11); }
void cpu_fpu_set_sw(Cpu *c, uint16_t sw) {
    c->top = (sw >> 11) & 7u;
    c->fsw = sw & (uint16_t)~0x3800u;
}
uint16_t cpu_fpu_get_tag(const Cpu *c) {
    uint16_t tag = 0;
    for (int i = 7; i >= 0; i--) {
        tag <<= 2;
        if (c->empty[i]) {
            tag |= 3;
            continue;
        }
        F80 x = fv_f80(fv_reg(c, (uint32_t)i));
        uint32_t e = x.se & 0x7fffu;
        if (e == 0 && x.m == 0) tag |= 1;
        else if (e == 0 || e == 0x7fffu || !(x.m >> 63)) tag |= 2;
    }
    return tag;
}
void cpu_fpu_set_tag(Cpu *c, uint16_t tag) {
    for (int i = 0; i < 8; i++) c->empty[i] = ((tag >> (2 * i)) & 3u) == 3u;
}

/* ------------------------------------------------------------------ instruction execution */
static void bad(Cpu *c, uint8_t op, uint8_t modrm) {
    cpu_set_fault(c, CPU_FAULT_INVALID_OPCODE, c->eip, 0, "unimplemented x87 instruction %02x %02x at %08x", op, modrm, c->eip);
}

void cpu_x87_exec(Cpu *c, uint8_t op, uint8_t modrm, uint32_t ea) {
    uint32_t reg = (modrm >> 3) & 7u, rm = modrm & 7u;
    bool mem = (modrm >> 6) != 3;
    uint32_t p0 = st_phys(c, 0);

    if (mem) {
        switch (op) {
        case 0xd8:
        case 0xda:
        case 0xdc:
        case 0xde: { /* arithmetic with a memory operand: m32 real, m32 int, m64 real, m16 int */
            FV b = ld_mem(c, (uint32_t)(op - 0xd8) >> 1, ea);
            if (FAULTED(c)) return;
            FV a = fv_reg(c, p0);
            if (reg == 2 || reg == 3) {
                fcom_set(c, fcmp(a, b));
                if (reg == 3) fpop(c);
                return;
            }
            set_reg(c, p0, fop(c, reg, a, b));
            return;
        }
        case 0xd9:
            switch (reg) {
            case 0: {
                FV v = ld_mem(c, 0, ea);
                if (FAULTED(c)) return;
                fpush(c);
                set_reg(c, st_phys(c, 0), v);
                return;
            }
            case 2:
            case 3:
                wrm(c, ea, 4, fv_to_f32(c, fv_reg(c, p0)));
                if (FAULTED(c)) return;
                if (reg == 3) fpop(c);
                return;
            case 5: {
                uint32_t cw = (uint32_t)rdm(c, ea, 2);
                if (FAULTED(c)) return;
                c->fcw = (uint16_t)cw;
                return;
            }
            case 7: wrm(c, ea, 2, c->fcw); return;
            default: return bad(c, op, modrm);
            }
        case 0xdb:
            switch (reg) {
            case 0: {
                FV v = ld_mem(c, 1, ea);
                if (FAULTED(c)) return;
                fpush(c);
                set_reg(c, st_phys(c, 0), v);
                return;
            }
            case 2:
            case 3:
                wrm(c, ea, 4, fv_to_int(c, fv_reg(c, p0), 4));
                if (FAULTED(c)) return;
                if (reg == 3) fpop(c);
                return;
            case 5: {
                F80 x;
                x.m = rdm(c, ea, 8);
                x.se = (uint16_t)rdm(c, ea + 8u, 2);
                if (FAULTED(c)) return;
                fpush(c);
                set_reg(c, st_phys(c, 0), fv_x(x));
                return;
            }
            case 7: {
                F80 x = fv_f80(fv_reg(c, p0));
                if (!cpu_mapped(c, ea, 10)) {
                    cpu_set_fault(c, CPU_FAULT_WRITE_UNMAPPED, ea, 10, "write of 10 bytes at %08x: unmapped", ea);
                    return;
                }
                wrm(c, ea, 8, x.m);
                wrm(c, ea + 8u, 2, x.se);
                fpop(c);
                return;
            }
            default: return bad(c, op, modrm);
            }
        case 0xdd:
            switch (reg) {
            case 0: {
                FV v = ld_mem(c, 2, ea);
                if (FAULTED(c)) return;
                fpush(c);
                set_reg(c, st_phys(c, 0), v);
                return;
            }
            case 2:
            case 3:
                wrm(c, ea, 8, fv_to_f64(c, fv_reg(c, p0)));
                if (FAULTED(c)) return;
                if (reg == 3) fpop(c);
                return;
            case 7: wrm(c, ea, 2, cpu_fpu_get_sw(c)); return;
            default: return bad(c, op, modrm);
            }
        default: /* 0xdf */
            switch (reg) {
            case 0:
            case 5: {
                int64_t v = reg == 0 ? (int64_t)(int16_t)(uint16_t)rdm(c, ea, 2) : (int64_t)rdm(c, ea, 8);
                if (FAULTED(c)) return;
                fpush(c);
                set_reg(c, st_phys(c, 0), fv_from_i64(v));
                return;
            }
            case 2:
            case 3:
                wrm(c, ea, 2, fv_to_int(c, fv_reg(c, p0), 2));
                if (FAULTED(c)) return;
                if (reg == 3) fpop(c);
                return;
            case 7:
                wrm(c, ea, 8, fv_to_int(c, fv_reg(c, p0), 8));
                if (FAULTED(c)) return;
                fpop(c);
                return;
            default: return bad(c, op, modrm);
            }
        }
    }

    /* register forms */
    uint32_t pi = st_phys(c, rm);
    switch (op) {
    case 0xd8: { /* ST0 = ST0 op ST(i); FCOM/FCOMP ST(i) */
        FV a = fv_reg(c, p0), b = fv_reg(c, pi);
        if (reg == 2 || reg == 3) {
            fcom_set(c, fcmp(a, b));
            if (reg == 3) fpop(c);
            return;
        }
        set_reg(c, p0, fop(c, reg, a, b));
        return;
    }
    case 0xdc:
    case 0xde: { /* ST(i) = ST(i) op ST0 (reg 4: ST0 - ST(i), 5: ST(i) - ST0, 6: ST0 / ST(i), 7: ST(i) / ST0) */
        if (op == 0xde && reg == 3 && rm == 1) { /* FCOMPP */
            fcom_set(c, fcmp(fv_reg(c, p0), fv_reg(c, st_phys(c, 1))));
            fpop(c);
            fpop(c);
            return;
        }
        if (reg == 2 || reg == 3) {
            if (op == 0xde) return bad(c, op, modrm);
            fcom_set(c, fcmp(fv_reg(c, p0), fv_reg(c, pi))); /* DC D0+i / D8+i: FCOM aliases */
            if (reg == 3) fpop(c);
            return;
        }
        static const uint8_t stn_op[8] = {0, 1, 0, 0, 5, 4, 7, 6};
        set_reg(c, pi, fop(c, stn_op[reg], fv_reg(c, pi), fv_reg(c, p0)));
        if (op == 0xde) fpop(c);
        return;
    }
    case 0xd9:
        switch (reg) {
        case 0: { /* FLD ST(i) */
            FV v = fv_reg(c, pi);
            fpush(c);
            set_reg(c, st_phys(c, 0), v);
            return;
        }
        case 1: { /* FXCH ST(i): values only, tags unchanged (QEMU) */
            FV a = fv_reg(c, p0), b = fv_reg(c, pi);
            set_reg(c, p0, b);
            set_reg(c, pi, a);
            return;
        }
        case 2:
            if (rm == 0) return; /* FNOP */
            return bad(c, op, modrm);
        case 4:
            switch (rm) {
            case 0: { /* FCHS */
                FV v = fv_reg(c, p0);
                v.d = -v.d;
                v.x.se ^= 0x8000u;
                set_reg(c, p0, v);
                return;
            }
            case 1: { /* FABS */
                FV v = fv_reg(c, p0);
                DU u = {.d = v.d};
                u.u &= ~(1ull << 63);
                v.d = u.d;
                v.x.se &= 0x7fffu;
                set_reg(c, p0, v);
                return;
            }
            case 4: fcom_set(c, fcmp(fv_reg(c, p0), fv_d(0.0))); return; /* FTST */
            default: return bad(c, op, modrm);
            }
        case 5:
            if (rm == 0 || rm == 6) { /* FLD1, FLDZ */
                fpush(c);
                set_reg(c, st_phys(c, 0), fv_d(rm == 0 ? 1.0 : 0.0));
                return;
            }
            return bad(c, op, modrm);
        case 6:
            if (rm == 6 || rm == 7) { /* FDECSTP, FINCSTP (QEMU clears C0..C3) */
                c->top = (c->top + (rm == 6 ? 7u : 1u)) & 7u;
                c->fsw &= (uint16_t)~0x4700u;
                return;
            }
            return bad(c, op, modrm);
        default: /* reg 7 */
            switch (rm) {
            case 2: { /* FSQRT */
                FV v = fv_reg(c, p0);
                DU u = {.d = v.d};
                if (u.u >> 63) c->fsw = (uint16_t)((c->fsw & ~0x4700u) | FSW_C2);
                set_reg(c, p0, fv_d(pc_round(c, __builtin_sqrt(v.d))));
                return;
            }
            case 4: { /* FRNDINT: rounding control, no precision control */
                FV v = fv_reg(c, p0);
                Unp u;
                if (f80_unpack(fv_f80(v), &u) != 1 || u.E >= 63) return;
                uint64_t mag;
                rnd_int(&u, rc_of(c), &mag);
                FV r = fv_from_i64((int64_t)mag);
                if (u.sign) {
                    r.d = -r.d;
                    r.x.se |= 0x8000u;
                }
                set_reg(c, p0, r);
                return;
            }
            case 6: fsincos(c, false); return;
            case 7: fsincos(c, true); return;
            default: return bad(c, op, modrm);
            }
        }
    case 0xda:
        if (modrm == 0xe9) { /* FUCOMPP */
            fcom_set(c, fcmp(fv_reg(c, p0), fv_reg(c, st_phys(c, 1))));
            fpop(c);
            fpop(c);
            return;
        }
        return bad(c, op, modrm);
    case 0xdb:
        if (modrm == 0xe2) { /* FNCLEX */
            c->fsw &= 0x7f00u;
            return;
        }
        if (modrm == 0xe3) { /* FNINIT */
            cpu_x87_reset(c);
            return;
        }
        return bad(c, op, modrm);
    case 0xdd:
        switch (reg) {
        case 0: c->empty[pi] = 1; return; /* FFREE */
        case 2:
        case 3: /* FST/FSTP ST(i) */
            set_reg(c, pi, fv_reg(c, p0));
            if (reg == 3) fpop(c);
            return;
        case 4:
        case 5: /* FUCOM/FUCOMP ST(i) */
            fcom_set(c, fcmp(fv_reg(c, p0), fv_reg(c, pi)));
            if (reg == 5) fpop(c);
            return;
        default: return bad(c, op, modrm);
        }
    default: /* 0xdf */
        if (modrm == 0xe0) { /* FNSTSW AX */
            c->r[CPU_EAX] = (c->r[CPU_EAX] & 0xffff0000u) | cpu_fpu_get_sw(c);
            return;
        }
        return bad(c, op, modrm);
    }
}
