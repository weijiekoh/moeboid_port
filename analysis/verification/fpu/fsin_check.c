/* Compare the x87 FSIN/FCOS path of Moeboid.gam:0x10001252..0x10001279 (baddie spawn position)
 * with the same computation in IEEE double (what Unicorn/QEMU, wasm and JS do).
 * Runs our own test code on the host x87 FPU (not the original binary).
 *
 * Original sequence (Moeboid.gam, verified in analysis/decomp/Moeboid.gam/listing.asm):
 *   1000123a FILD qword [EBP-0x10]      r = rnd % (0xbe - width)   (high dword = 0)
 *   1000123d FSTP float [EBP+0x8]       r as float32 (exact, r < 2^24)
 *   10001252 FILD qword [EBP-0x18]      k = rnd % 1000             (high dword = 0)
 *   10001255 FMUL float [0x1000d118]    0x3bcde32e = 0.0062831854f
 *   1000125b FLD ST0
 *   1000125d FSIN
 *   1000125f FMUL float [EBP+0x8]       * r
 *   10001262 FADD float [0x1000d114]    + 249.0f
 *   10001268 FST  float [EBP-0x4]       x (float32)
 *   1000126b FSTP float [ESI+0xc]       x (float32)
 *   1000126e FCOS
 *   10001270 FMUL float [EBP+0x8]       * r
 *   10001273 FADD float [0x1000d110]    + 207.0f
 *   10001279 FST  float [ESI+0x10]      y (float32); the UNROUNDED y (53-bit, PC=53) stays in ST0
 *   10001285 FSUB float [EAX+0x14] ... FSQRT, FCOMP double [0x1000d108] (80.0): retry if <= 80.
 * The game runs with x87 precision control = 53 bit (CRT _controlfp(0x10000, 0x30000) at
 * Moeboid.gam:0x10005976). FSIN/FCOS ignore precision control (64-bit significand result).
 * Domain: k in 0..999; r < 0xbe - width, width = baddie GIF width 11..47 (assets/INDEX.md), so
 * r in 0..178. All 1000 * 179 = 179000 reachable (k, r) pairs are tested.
 *
 * Paths compared with the x87 path (A):
 *   B  libm: double xd = k * C; sin(xd) * r + 249 in double. Same as Unicorn/QEMU, whose FSIN
 *      helper calls the host libm sin() on the argument converted to double.
 *   C  table: s = (double)FSIN80(k) (x87 result rounded to nearest double); s * r + 249 in double.
 *   D  exact: table of the 80-bit x87 FSIN/FCOS results (64-bit significand); FMUL emulated as one
 *      round-to-nearest-even of the exact product to 53 bits (integer arithmetic); FADD in double.
 *      This is the recipe for a port (C/wasm: unsigned __int128 or two uint64; TypeScript: BigInt).
 * Compared values: x (float32), y (float32), y53 (unrounded y, used by the distance check).
 *
 * Build: gcc -O0 -o fsin_check fsin_check.c -lm
 * Usage: ./fsin_check [DUMP [TABLE]]
 *   DUMP  = binary file of x87 results, 16 bytes per (k, r): float x, float y, double y53
 *           (k major, r minor), for unicorn_fsin.py.
 *   TABLE = text file (x87_fsin_table.tsv): k, angle, FSIN(angle), FCOS(angle); each 80-bit value
 *           as sign_exponent:significand in hex. Used by emu.Machine.install_fsin_table().
 */
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

static float fconst(uint32_t bits) { float f; memcpy(&f, &bits, 4); return f; }

/* x87 FMUL with precision control 53 bit: round(v80 * r) to 53 bits, nearest-even. r >= 0 integer. */
static double mul80_pc53(long double v, uint32_t r) {
    unsigned char b[10];
    memcpy(b, &v, 10);
    uint64_t m;
    memcpy(&m, b, 8);
    int sign = b[9] >> 7, e = ((b[9] & 0x7f) << 8 | b[8]) - 16383 - 63; /* v = m * 2^e */
    if (m == 0 || r == 0) return sign ? -0.0 : 0.0;
    unsigned __int128 p = (unsigned __int128)m * r;
    int len = 0;
    for (unsigned __int128 t = p; t; t >>= 1) len++;
    int sh = len - 53;
    if (sh > 0) {
        unsigned __int128 rem = p & (((unsigned __int128)1 << sh) - 1), half = (unsigned __int128)1 << (sh - 1);
        p >>= sh;
        if (rem > half || (rem == half && (p & 1))) p++;
        e += sh;
    }
    double d = ldexp((double)(uint64_t)p, e); /* p < 2^54, exact */
    return sign ? -d : d;
}

int main(int argc, char **argv) {
    const float C = fconst(0x3bcde32e), C249 = 249.0f, C207 = 207.0f;
    unsigned short cw = 0x27f, old;
    long total = 0, sin_bits_diff = 0, cos_bits_diff = 0;
    long mB_x = 0, mB_y = 0, mB_y53 = 0, mC_x = 0, mC_y = 0, mC_y53 = 0, mD_x = 0, mD_y = 0, mD_y53 = 0;
    FILE *dump = argc > 1 ? fopen(argv[1], "wb") : NULL;
    FILE *table = argc > 2 ? fopen(argv[2], "w") : NULL;
    if (table) fprintf(table, "k\tangle\tfsin\tfcos\n");
    __asm__ volatile("fnstcw %0" : "=m"(old));
    for (int64_t k = 0; k < 1000; k++) {
        long double xs, xc;
        __asm__ volatile("fldcw %1\n\t"
                         "fildll %2\n\t"
                         "fmuls %3\n\t"
                         "fld %%st(0)\n\t"
                         "fsin\n\t"
                         "fstpt %0\n\t"
                         "fstp %%st(0)\n\t"
                         "fldcw %4"
                         : "=m"(xs) : "m"(cw), "m"(k), "m"(C), "m"(old));
        __asm__ volatile("fldcw %1\n\t"
                         "fildll %2\n\t"
                         "fmuls %3\n\t"
                         "fcos\n\t"
                         "fstpt %0\n\t"
                         "fldcw %4"
                         : "=m"(xc) : "m"(cw), "m"(k), "m"(C), "m"(old));
        double xd = (double)k * (double)C; /* exact: 10-bit * 24-bit */
        if (table) {
            long double xa;
            __asm__ volatile("fldcw %1\n\tfildll %2\n\tfmuls %3\n\tfstpt %0\n\tfldcw %4"
                             : "=m"(xa) : "m"(cw), "m"(k), "m"(C), "m"(old));
            long double v[3] = {xa, xs, xc};
            fprintf(table, "%ld", (long)k);
            for (int j = 0; j < 3; j++) {
                uint64_t mm; uint16_t ee;
                memcpy(&mm, &v[j], 8); memcpy(&ee, (char *)&v[j] + 8, 2);
                fprintf(table, "\t%04x:%016llx", ee, (unsigned long long)mm);
            }
            fprintf(table, "\n");
        }
        double ts = (double)xs, tc = (double)xc; /* table path values */
        if (ts != sin(xd)) sin_bits_diff++;
        if (tc != cos(xd)) cos_bits_diff++;
        for (int64_t r = 0; r < 179; r++) {
            float rf = (float)r, ox, oy;
            double oy53;
            __asm__ volatile("fldcw %3\n\t"
                             "fildll %4\n\t"
                             "fmuls %5\n\t"
                             "fld %%st(0)\n\t"
                             "fsin\n\t"
                             "fmuls %6\n\t"
                             "fadds %7\n\t"
                             "fstps %0\n\t"
                             "fcos\n\t"
                             "fmuls %6\n\t"
                             "fadds %8\n\t"
                             "fsts %1\n\t"
                             "fstpl %2\n\t"
                             "fldcw %9"
                             : "=m"(ox), "=m"(oy), "=m"(oy53)
                             : "m"(cw), "m"(k), "m"(C), "m"(rf), "m"(C249), "m"(C207), "m"(old));
            double bx = sin(xd) * (double)rf + 249.0, by = cos(xd) * (double)rf + 207.0;
            double cx = ts * (double)rf + 249.0, cy = tc * (double)rf + 207.0;
            double dx = mul80_pc53(xs, (uint32_t)r) + 249.0, dy = mul80_pc53(xc, (uint32_t)r) + 207.0;
            float bx32 = (float)bx, by32 = (float)by, cx32 = (float)cx, cy32 = (float)cy;
            float dx32 = (float)dx, dy32 = (float)dy;
            if (memcmp(&dx32, &ox, 4)) mD_x++;
            if (memcmp(&dy32, &oy, 4)) mD_y++;
            if (memcmp(&dy, &oy53, 8)) mD_y53++;
            total++;
            if (memcmp(&bx32, &ox, 4)) mB_x++;
            if (memcmp(&by32, &oy, 4)) mB_y++;
            if (memcmp(&by, &oy53, 8)) { mB_y53++; if (mB_y53 <= 3) printf("B y53 mismatch k=%ld r=%ld x87=%a libm=%a\n", (long)k, (long)r, oy53, by); }
            if (memcmp(&cx32, &ox, 4)) mC_x++;
            if (memcmp(&cy32, &oy, 4)) mC_y++;
            if (memcmp(&cy, &oy53, 8)) { mC_y53++; if (mC_y53 <= 3) printf("C y53 mismatch k=%ld r=%ld x87=%a table=%a\n", (long)k, (long)r, oy53, cy); }
            if (dump) { fwrite(&ox, 4, 1, dump); fwrite(&oy, 4, 1, dump); fwrite(&oy53, 8, 1, dump); }
        }
    }
    if (dump) fclose(dump);
    if (table) fclose(table);
    printf("args=1000 fsin(rounded to double)!=libm sin: %ld; fcos: %ld\n", sin_bits_diff, cos_bits_diff);
    printf("pairs=%ld\n", total);
    printf("B (libm double, = Unicorn/QEMU): mismatches x32=%ld y32=%ld y53=%ld\n", mB_x, mB_y, mB_y53);
    printf("C (table of x87 FSIN/FCOS rounded to double): mismatches x32=%ld y32=%ld y53=%ld\n", mC_x, mC_y, mC_y53);
    printf("D (table of 80-bit x87 FSIN/FCOS + exact PC53 multiply): mismatches x32=%ld y32=%ld y53=%ld\n", mD_x, mD_y, mD_y53);
    return 0;
}
