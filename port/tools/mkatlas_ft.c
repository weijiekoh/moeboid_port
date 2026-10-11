/* mkatlas_ft: FreeType rasterizer helper for port/tools/mkatlas.py (host tool, not part of the port).
 *
 * Usage: mkatlas_ft FONTFILE PPEM MODE [--no-hdmx] [--nohint] [--interp N] CODE...
 *   MODE mono : full hinting, FT_LOAD_TARGET_MONO | FT_LOAD_MONOCHROME, FreeType mono rasterizer.
 *               Same flags as the verified check of analysis/fonts.md 10.3.
 *   MODE gray : decision O6 model. Hint at PPEM (FT_LOAD_TARGET_NORMAL, so the bytecode sees the
 *               grayscale GETINFO bit), or no hinting with --nohint (gasp GRIDFIT off), scale the
 *               outline by 4 in x and y, scan-convert it with the mono rasterizer, count the set
 *               subpixels of each 4x4 cell: coverage 0..16 (17 levels, GGO_GRAY4 style).
 *   --no-hdmx : rename the hdmx table tag in memory, so the advance comes from the hinted
 *               phantom points and not from the Microsoft device widths.
 *   --interp N: TrueType interpreter version (default 35, the classic Microsoft-compatible one).
 *   CODE      : Unicode code points (decimal). Output order equals argument order.
 *
 * Output (text, one line each): "V major.minor.patch", then per code point
 *   "G code gindex adv26_6 left top width rows data"
 *   data: mono one char '0'/'1' per pixel; gray two hex digits per pixel; rows top first; '-' if empty.
 */
#include <ft2build.h>
#include FT_FREETYPE_H
#include FT_OUTLINE_H
#include FT_MODULE_H
#include FT_DRIVER_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static unsigned char *read_file(const char *path, long *len)
{
    FILE *f = fopen(path, "rb");
    if (!f) return NULL;
    fseek(f, 0, SEEK_END);
    *len = ftell(f);
    fseek(f, 0, SEEK_SET);
    unsigned char *b = malloc((size_t)*len);
    if (b && fread(b, 1, (size_t)*len, f) != (size_t)*len) { free(b); b = NULL; }
    fclose(f);
    return b;
}

static void rename_table(unsigned char *d, long len, const char *tag)
{
    if (len < 12) return;
    unsigned n = (unsigned)(d[4] << 8 | d[5]);
    for (unsigned i = 0; i < n && 12 + 16 * (long)i + 16 <= len; i++) {
        unsigned char *t = d + 12 + 16 * i;
        if (memcmp(t, tag, 4) == 0) memcpy(t, "zzzz", 4);
    }
}

static long floor_div(long a, long b) { long q = a / b; if ((a % b) != 0 && ((a < 0) != (b < 0))) q--; return q; }
static long ceil_div(long a, long b) { return -floor_div(-a, b); }

int main(int argc, char **argv)
{
    if (argc < 4) { fprintf(stderr, "usage: mkatlas_ft FONT PPEM mono|gray [opts] CODE...\n"); return 2; }
    const char *path = argv[1];
    int ppem = atoi(argv[2]);
    int gray = strcmp(argv[3], "gray") == 0;
    if (!gray && strcmp(argv[3], "mono") != 0) { fprintf(stderr, "bad mode\n"); return 2; }
    int nohdmx = 0, nohint = 0, interp = 35, first_code = 4;
    for (int i = 4; i < argc; i++) {
        if (strcmp(argv[i], "--no-hdmx") == 0) nohdmx = 1;
        else if (strcmp(argv[i], "--nohint") == 0) nohint = 1;
        else if (strcmp(argv[i], "--interp") == 0 && i + 1 < argc) interp = atoi(argv[++i]);
        else { first_code = i; break; }
        first_code = i + 1;
    }
    long len = 0;
    unsigned char *data = read_file(path, &len);
    if (!data) { fprintf(stderr, "cannot read %s\n", path); return 1; }
    if (nohdmx) rename_table(data, len, "hdmx");

    FT_Library lib;
    if (FT_Init_FreeType(&lib)) return 1;
    FT_UInt iv = (FT_UInt)interp;
    if (FT_Property_Set(lib, "truetype", "interpreter-version", &iv)) { fprintf(stderr, "interpreter-version %d refused\n", interp); return 1; }
    FT_Face face;
    if (FT_New_Memory_Face(lib, data, len, 0, &face)) { fprintf(stderr, "FT_New_Memory_Face failed\n"); return 1; }
    if (FT_Set_Pixel_Sizes(face, 0, (FT_UInt)ppem)) { fprintf(stderr, "FT_Set_Pixel_Sizes failed\n"); return 1; }
    FT_Int ma, mi, pa;
    FT_Library_Version(lib, &ma, &mi, &pa);
    printf("V %d.%d.%d\n", ma, mi, pa);

    for (int i = first_code; i < argc; i++) {
        unsigned long code = strtoul(argv[i], NULL, 10);
        FT_UInt gi = FT_Get_Char_Index(face, code);
        if (!gray) {
            FT_Int32 fl = FT_LOAD_TARGET_MONO | FT_LOAD_MONOCHROME | FT_LOAD_RENDER | FT_LOAD_NO_AUTOHINT;
            if (FT_Load_Glyph(face, gi, fl)) { fprintf(stderr, "load %lu failed\n", code); return 1; }
            FT_GlyphSlot s = face->glyph;
            FT_Bitmap *bm = &s->bitmap;
            if (bm->rows && bm->width && bm->pixel_mode != FT_PIXEL_MODE_MONO) { fprintf(stderr, "not mono\n"); return 1; }
            printf("G %lu %u %ld %d %d %u %u ", code, gi, (long)s->advance.x, s->bitmap_left, s->bitmap_top, bm->width, bm->rows);
            if (!bm->rows || !bm->width) { printf("-\n"); continue; }
            for (unsigned y = 0; y < bm->rows; y++) {
                const unsigned char *row = bm->buffer + (long)y * bm->pitch;
                for (unsigned x = 0; x < bm->width; x++) putchar((row[x >> 3] >> (7 - (x & 7))) & 1 ? '1' : '0');
            }
            putchar('\n');
        } else {
            FT_Int32 fl = FT_LOAD_NO_BITMAP | FT_LOAD_NO_AUTOHINT | (nohint ? FT_LOAD_NO_HINTING : FT_LOAD_TARGET_NORMAL);
            if (FT_Load_Glyph(face, gi, fl)) { fprintf(stderr, "load %lu failed\n", code); return 1; }
            FT_GlyphSlot s = face->glyph;
            if (s->format != FT_GLYPH_FORMAT_OUTLINE) { fprintf(stderr, "no outline for %lu\n", code); return 1; }
            FT_Outline *o = &s->outline;
            FT_Matrix m = { 4 << 16, 0, 0, 4 << 16 };
            FT_Outline_Transform(o, &m);
            FT_BBox cb;
            FT_Outline_Get_CBox(o, &cb);
            long x0 = 0, x1 = 0, y0 = 0, y1 = 0;
            if (o->n_points > 0) {
                x0 = floor_div(cb.xMin, 256); x1 = ceil_div(cb.xMax, 256);
                y0 = floor_div(cb.yMin, 256); y1 = ceil_div(cb.yMax, 256);
            }
            long w = x1 - x0, h = y1 - y0;
            printf("G %lu %u %ld %ld %ld %ld %ld ", code, gi, (long)s->advance.x, x0, y1, w, h);
            if (w <= 0 || h <= 0) { printf("-\n"); continue; }
            FT_Outline_Translate(o, -x0 * 256, -y0 * 256);
            FT_Bitmap bm;
            memset(&bm, 0, sizeof bm);
            bm.width = (unsigned)(4 * w);
            bm.rows = (unsigned)(4 * h);
            bm.pitch = (int)((bm.width + 7) / 8);
            bm.pixel_mode = FT_PIXEL_MODE_MONO;
            bm.num_grays = 2;
            bm.buffer = calloc((size_t)bm.pitch * bm.rows, 1);
            if (!bm.buffer || FT_Outline_Get_Bitmap(lib, o, &bm)) { fprintf(stderr, "raster failed\n"); return 1; }
            for (long y = 0; y < h; y++) {
                for (long x = 0; x < w; x++) {
                    int c = 0;
                    for (int sy = 0; sy < 4; sy++) {
                        const unsigned char *row = bm.buffer + (4 * y + sy) * bm.pitch;
                        for (int sx = 0; sx < 4; sx++) {
                            long px = 4 * x + sx;
                            c += (row[px >> 3] >> (7 - (px & 7))) & 1;
                        }
                    }
                    printf("%02x", c);
                }
            }
            putchar('\n');
            free(bm.buffer);
        }
    }
    FT_Done_Face(face);
    FT_Done_FreeType(lib);
    free(data);
    return 0;
}
