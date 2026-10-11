/* Engine GIF decoder and animation timing. See gif.h. */
#include "gif.h"

typedef struct Rd {
    const uint8_t *d;
    uint32_t len, pos;
    int eof;
} Rd;

static uint32_t rd_u8(Rd *r)
{
    if (r->pos >= r->len) { r->eof = 1; return 0; }
    return r->d[r->pos++];
}

static uint32_t rd_u16(Rd *r)
{
    uint32_t a = rd_u8(r);
    return a | (rd_u8(r) << 8);
}

static void rd_skip(Rd *r, uint32_t n)
{
    if (n > r->len - r->pos) { r->eof = 1; r->pos = r->len; }
    else r->pos += n;
}

/* Interlace tables: row steps Z:0x434b6c, pass start rows Z:0x434b80. */
static const uint32_t k_step[4] = { 8, 8, 4, 2 };
static const uint32_t k_start[4] = { 0, 4, 2, 1 };

typedef struct Writer {
    uint32_t *img;          /* frame image (logical screen size), NULL in pass 1 */
    uint32_t W, H;          /* logical screen */
    uint32_t left, top, w, h;
    uint32_t x, y, step, pass;
    const uint8_t *ct;      /* colour table, 3 bytes per entry */
    uint32_t ct_n;
    uint32_t keyed, tidx;
} Writer;

/* Pixel writer Z:0x418870 (rendering.md 4): transparent index skipped when the GCE flag is set;
 * the image keeps its fill or the copied previous frame there. Position advance with the engine's
 * pass logic: after a row, y += step; when y >= height the next pass starts once (no loop over empty
 * passes, unlike standard deinterlacing). Divergences, unreachable for the 81 GIFs (verified survey):
 * the engine writes past the frame rectangle and the screen without a bound check (the port clips to
 * the logical screen), and after an interlace pass change it addresses row 2*top+y and adds left in
 * bytes instead of pixels (the port uses top+y, left+x; equal when left = top = 0, as in
 * IMG-GAMEAREA.GIF, the only interlaced GIF). Indices beyond the table read garbage in the engine;
 * the port writes black. */
static void put_pixel(Writer *wr, uint32_t idx)
{
    if (wr->pass > 3) return;   /* engine reads beyond its pass tables; never reached by valid data */
    if (wr->img && !(wr->keyed && idx == wr->tidx)) {
        uint32_t X = wr->left + wr->x, Y = wr->top + wr->y;
        if (X < wr->W && Y < wr->H) {
            uint32_t c = IMG_BLACK;
            if (idx < wr->ct_n) {
                const uint8_t *e = wr->ct + 3u * idx;
                c = IMG_RGB(e[0], e[1], e[2]);
            }
            wr->img[Y * wr->W + X] = c;
        }
    }
    if (++wr->x == wr->w) {
        wr->x = 0;
        wr->y += wr->step;
        if (wr->y >= wr->h) {
            wr->pass++;
            if (wr->pass <= 3) {
                wr->step = k_step[wr->pass];
                wr->y = k_start[wr->pass];
            }
        }
    }
}

/* LZW driver Z:0x418a70. Engine specifics kept:
 * - the first code of the stream acts as a clear code whatever its value (Z:0x418c02);
 * - a code >= next is decoded as the KwKwK case (Z:0x418c84);
 * - the code size grows when next > mask, up to 12 bits (Z:0x418d36);
 * - after the end code the reader skips the rest of the current sub-block plus one byte (the expected
 *   block terminator) and does not look for further sub-blocks (Z:0x418c42).
 * Divergence: the engine keeps adding table entries past 4096 (stack overflow); the port stops adding.
 * No GIF of the game reaches 4096 entries without a clear code (verified survey). */
static int32_t lzw(Rd *r, Writer *wr, GifWork *wk)
{
    uint32_t mcs = rd_u8(r);
    if (r->eof) return GIF_E_TRUNCATED;
    if (mcs > 11) return GIF_E_LZW;
    uint32_t clear = 1u << mcs, eoi = clear + 1, size = mcs + 1, mask = (1u << size) - 1, next = clear + 2;
    int32_t old = -2;
    uint32_t fc = 0, bits = 0, nbits = 0, blk_left = 0;
    for (;;) {
        while (nbits < size) {
            if (blk_left == 0) {
                blk_left = rd_u8(r);
                if (r->eof) return GIF_E_TRUNCATED;
                if (blk_left == 0) return GIF_E_LZW;   /* data ends without an end code */
            }
            uint32_t b = rd_u8(r);
            if (r->eof) return GIF_E_TRUNCATED;
            blk_left--;
            bits |= b << nbits;
            nbits += 8;
        }
        uint32_t code = bits & mask;
        bits >>= size;
        nbits -= size;
        if (old == -2 || code == clear) {
            size = mcs + 1;
            mask = (1u << size) - 1;
            next = clear + 2;
            old = -1;
            continue;
        }
        if (code == eoi) break;
        if (old == -1) {
            put_pixel(wr, code);
            old = (int32_t)code;
            fc = code;
            continue;
        }
        uint32_t sp = 0, cur = code;
        if (code >= next) {
            wk->stack[sp++] = (uint8_t)fc;
            cur = (uint32_t)old;
        }
        while (cur >= clear) {
            if (cur >= next || sp >= 4096u) return GIF_E_LZW;
            wk->stack[sp++] = wk->suffix[cur];
            cur = wk->prefix[cur];
        }
        wk->stack[sp++] = (uint8_t)cur;
        fc = cur;
        while (sp) put_pixel(wr, wk->stack[--sp]);
        if (next < 4096u) {
            wk->suffix[next] = (uint8_t)fc;
            wk->prefix[next] = (uint16_t)old;
            next++;
        }
        old = (int32_t)code;
        if (next > mask && size != 12) {
            size++;
            mask = (1u << size) - 1;
        }
    }
    rd_skip(r, blk_left);
    rd_skip(r, 1);
    return GIF_OK;
}

static int is_netscape(const uint8_t *p)
{
    static const char id[11] = { 'N', 'E', 'T', 'S', 'C', 'A', 'P', 'E', '2', '.', '0' };
    for (int i = 0; i < 11; i++)
        if (p[i] != (uint8_t)id[i]) return 0;
    return 1;
}

/* CImageSeq::LoadGIF Z:0x418d90. */
int32_t gif_decode(const uint8_t *data, uint32_t len, GifInfo *info, GifFrame *frames, uint32_t max_frames,
                   uint32_t *pixels, GifWork *work)
{
    Rd r = { data, len, 0, 0 };
    GifInfo in = { 0, 0, 0, 0, 0, GIF_OK };
    /* Signature: compared with "Gif87a"/"Gif89a" by a check that never fails (Z:0x418e80): not checked. */
    rd_skip(&r, 6);
    in.width = (uint16_t)rd_u16(&r);
    in.height = (uint16_t)rd_u16(&r);
    uint32_t packed = rd_u8(&r);
    rd_u8(&r);   /* background colour index: unused by the engine */
    rd_u8(&r);   /* aspect ratio */
    const uint8_t *gct = 0;
    uint32_t gct_n = 0;
    if (packed & 0x80u) {
        gct_n = 2u << (packed & 7u);
        if (3u * gct_n <= len - (r.pos < len ? r.pos : len)) gct = data + r.pos;
        rd_skip(&r, 3u * gct_n);
        in.has_gct = 1;
    }
    if (r.eof) { in.status = GIF_E_TRUNCATED; *info = in; return in.status; }
    uint32_t W = in.width, H = in.height, npix = W * H;
    uint32_t cap = (frames || pixels) ? max_frames : GIF_MAX_FRAMES;
    /* GCE locals persist across frames (Z:0x418d90: initialised once before the block loop). */
    uint32_t gce_packed = 0, gce_delay = 0, gce_tidx = 0, own_gce = 0;
    uint32_t prev_disp = 0, prev_keyed = 0, n = 0;
    uint32_t c = rd_u8(&r);
    while (c != 0 && !r.eof) {   /* the engine loop also ends on a 0 byte */
        while (c == '!') {
            uint32_t label = rd_u8(&r);
            if (label == 0xF9) {          /* fixed layout: size byte, packed, delay, index, terminator */
                rd_u8(&r);
                gce_packed = rd_u8(&r);
                gce_delay = rd_u16(&r);
                gce_tidx = rd_u8(&r);
                rd_skip(&r, 1);
                own_gce = 1;
            } else if (label == 0xFF) {
                uint32_t sz = rd_u8(&r);
                uint32_t at = r.pos;
                rd_skip(&r, sz);
                if (!r.eof && sz >= 11 && is_netscape(data + at)) {
                    uint32_t s = rd_u8(&r);
                    while (s != 0 && !r.eof) {
                        if (s != 3) { in.status = GIF_E_NETSCAPE; goto done; }
                        rd_u8(&r);           /* sub-block id */
                        rd_u16(&r);          /* loop count: read and ignored (infinite loop) */
                        in.loop = 1;
                        s = rd_u8(&r);
                    }
                } else {
                    uint32_t s = rd_u8(&r);
                    while (s != 0 && !r.eof) { rd_skip(&r, s); s = rd_u8(&r); }
                }
            } else {
                uint32_t s = rd_u8(&r);
                while (s != 0 && !r.eof) { rd_skip(&r, s); s = rd_u8(&r); }
            }
            if (r.eof) { in.status = GIF_E_TRUNCATED; goto done; }
            c = rd_u8(&r);
        }
        if (r.eof || c == ';' || c == 0) break;
        if (c != ',') { in.status = GIF_E_BLOCK; break; }
        Writer wr;
        wr.left = rd_u16(&r);
        wr.top = rd_u16(&r);
        wr.w = rd_u16(&r);
        wr.h = rd_u16(&r);
        uint32_t ipk = rd_u8(&r);
        const uint8_t *ct = gct;
        uint32_t ct_n = gct ? gct_n : 0;
        if (ipk & 0x80u) {
            uint32_t ln = 2u << (ipk & 7u);
            ct = (!r.eof && 3u * ln <= len - r.pos) ? data + r.pos : 0;
            ct_n = ct ? ln : 0;
            rd_skip(&r, 3u * ln);
        }
        if (r.eof) { in.status = GIF_E_TRUNCATED; break; }
        if (n >= GIF_MAX_FRAMES) { in.status = GIF_E_FRAMES; break; }
        /* A frame beyond the caller's capacity is decoded without output: if it is valid the result is
         * GIF_E_ARGS, else the same error as in pass 1. */
        uint32_t over = n >= cap;
        uint32_t keyed = gce_packed & 1u, disp = (gce_packed >> 2) & 7u;
        uint32_t *img = (pixels && !over) ? pixels + (uint32_t)n * npix : 0;
        if (img) {
            /* Render target constructor Z:0x40b950: keyed images start magenta key, others black. */
            uint32_t fill = keyed ? IMG_KEY : IMG_BLACK;
            for (uint32_t i = 0; i < npix; i++) img[i] = fill;
            if (n > 0 && (prev_disp == 1 || prev_disp == 3)) {
                /* Z:0x4192f3: DrawAt(previous image, 0, 0), keyed copy if the previous image is keyed. */
                const uint32_t *pv = img - npix;
                for (uint32_t i = 0; i < npix; i++)
                    if (!(prev_keyed && IMG_A(pv[i]) == 0)) img[i] = pv[i];
            }
            /* Disposal 2: clear to the background colour, equal to the fill. 0, 4..7: nothing. */
        }
        prev_disp = disp;
        prev_keyed = keyed;
        wr.img = img;
        wr.W = W;
        wr.H = H;
        wr.x = 0;
        wr.y = 0;
        wr.step = (ipk & 0x40u) ? 8u : 1u;
        wr.pass = (ipk & 0x40u) ? 0u : 3u;
        wr.ct = ct;
        wr.ct_n = ct_n;
        wr.keyed = keyed;
        wr.tidx = gce_tidx;
        int32_t st = lzw(&r, &wr, work);
        if (st != GIF_OK) { in.status = st; break; }
        if (over) { in.status = GIF_E_ARGS; break; }
        if (frames) {
            GifFrame *f = &frames[n];
            f->delay_ms = gce_delay * 10u;
            f->left = (uint16_t)wr.left;
            f->top = (uint16_t)wr.top;
            f->width = (uint16_t)wr.w;
            f->height = (uint16_t)wr.h;
            f->keyed = (uint8_t)keyed;
            f->disposal = (uint8_t)disp;
            f->transparent_index = (uint8_t)gce_tidx;
            f->interlaced = (uint8_t)((ipk >> 6) & 1u);
            f->own_gce = (uint8_t)own_gce;
            f->local_table = (uint8_t)((ipk >> 7) & 1u);
        }
        own_gce = 0;
        n++;
        c = rd_u8(&r);
    }
done:
    in.nframes = (uint16_t)n;
    *info = in;
    return in.status;
}

/* CAnim::RecalcTimes Z:0x4171b0. */
int32_t gif_anim_slots(const uint32_t *delays_ms, uint32_t n, uint8_t *table, uint32_t cap)
{
    uint32_t total = 0;
    for (uint32_t i = 0; i < n; i++) {
        uint32_t s = delays_ms[i] / GIF_SLOT_MS;
        if (s > 255u) return -1;
        total += s;
    }
    if (total > cap) return -1;
    uint32_t k = 0;
    for (uint32_t i = 0; i < n; i++) {
        uint32_t s = delays_ms[i] / GIF_SLOT_MS;
        for (uint32_t j = 0; j < s; j++) table[k++] = (uint8_t)i;
    }
    return (int32_t)total;
}

/* Frame lookup Z:0x4170d0 (unsigned division by 50 at Z:0x4170d9). */
uint32_t gif_anim_frame(const uint8_t *table, uint32_t nslots, int loop, uint32_t elapsed_ms,
                        uint8_t *al, uint8_t *finished)
{
    uint32_t slot = elapsed_ms / GIF_SLOT_MS;
    uint32_t frame;
    uint8_t a, fin = 0;
    if (slot < nslots) {
        frame = table[slot];
        a = 1;
    } else if (loop) {
        frame = nslots ? table[slot % nslots] : 0u;
        a = 0;
    } else {
        frame = 0;   /* image 0 after a non-looping animation ends */
        a = 1;
        fin = 1;
    }
    if (al) *al = a;
    if (finished) *finished = fin;
    return frame;
}
