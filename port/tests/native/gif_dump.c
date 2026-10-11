/* gif_dump: decode one GIF with port/src/gfx/gif.c and write the result for port/tests/py/test_gif.py.
 * Usage: gif_dump FILE.gif|- > out.bin
 * Output (little-endian): "GIFD", u32 width, height, nframes, loop, status (i32), nslots,
 *   nframes x {u32 delay_ms, u8 keyed, disposal, transparent_index, interlaced, own_gce, local_table, 0, 0},
 *   nframes x width x height x u32 RGBA pixels, nslots bytes of the slot table,
 *   u32 nprobe, nprobe x {u32 elapsed_ms, u8 frame, al, finished, 0} from gif_anim_frame. */
#include <stdio.h>
#include <stdlib.h>
#include "../../src/gfx/gif.h"

static void put32(uint32_t v) { fwrite(&v, 4, 1, stdout); }

int main(int argc, char **argv)
{
    if (argc != 2) { fprintf(stderr, "usage: gif_dump FILE\n"); return 2; }
    FILE *f = argv[1][0] == '-' && argv[1][1] == 0 ? stdin : fopen(argv[1], "rb");
    if (!f) { perror(argv[1]); return 1; }
    size_t cap = 1 << 16, len = 0, got;
    uint8_t *data = malloc(cap);
    while (data && (got = fread(data + len, 1, cap - len, f)) > 0) {
        len += got;
        if (len == cap) data = realloc(data, cap *= 2);
    }
    if (!data) return 1;
    static GifWork work;
    GifInfo info;
    gif_decode(data, (uint32_t)len, &info, NULL, 0, NULL, &work);
    uint32_t n = info.nframes, npix = (uint32_t)info.width * info.height;
    GifFrame *frames = calloc(n ? n : 1, sizeof *frames);
    uint32_t *px = calloc((size_t)(n ? n : 1) * npix + 1, 4);
    GifInfo info2;
    gif_decode(data, (uint32_t)len, &info2, frames, n, px, &work);
    if (info2.nframes != n || info2.status != info.status) { fprintf(stderr, "pass mismatch\n"); return 1; }
    uint32_t *delays = calloc(n ? n : 1, 4);
    for (uint32_t i = 0; i < n; i++) delays[i] = frames[i].delay_ms;
    static uint8_t table[256 * 256];
    int32_t ns = gif_anim_slots(delays, n, table, sizeof table);
    fwrite("GIFD", 1, 4, stdout);
    put32(info.width); put32(info.height); put32(n); put32(info.loop); put32((uint32_t)info.status);
    put32((uint32_t)ns);
    for (uint32_t i = 0; i < n; i++) {
        uint8_t b[8] = { frames[i].keyed, frames[i].disposal, frames[i].transparent_index, frames[i].interlaced,
                         frames[i].own_gce, frames[i].local_table, 0, 0 };
        put32(frames[i].delay_ms);
        fwrite(b, 1, 8, stdout);
    }
    fwrite(px, 4, (size_t)n * npix, stdout);
    if (ns > 0) fwrite(table, 1, (size_t)ns, stdout);
    uint32_t span = (ns > 0 ? (uint32_t)ns : 1u) * GIF_SLOT_MS * 3u + 200u, nprobe = 0;
    for (uint32_t t = 0; t <= span; t += 25) nprobe++;
    nprobe += 2;
    put32(nprobe);
    for (uint32_t t = 0, k = 0; k < nprobe; k++) {
        uint32_t tt = k == nprobe - 2 ? 0xffffffe0u : k == nprobe - 1 ? 0xffffffffu : t;
        uint8_t al = 9, fin = 9;
        uint32_t fr = gif_anim_frame(table, ns > 0 ? (uint32_t)ns : 0u, info.loop, tt, &al, &fin);
        uint8_t b[4] = { (uint8_t)fr, al, fin, 0 };
        put32(tt);
        fwrite(b, 1, 4, stdout);
        t += 25;
    }
    return 0;
}
