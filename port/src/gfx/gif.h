/* Engine GIF decoder and animation timing (analysis/rendering.md section 4, analysis/timing.md section 4).
 *
 * Model of ZapSpot.exe CImageSeq::LoadGIF Z:0x418d90, LZW driver Z:0x418a70, pixel writer Z:0x418870,
 * CAnim::RecalcTimes Z:0x4171b0 and frame lookup Z:0x4170d0. No allocation: the caller owns all memory.
 *
 * Use:
 *   GifInfo info; static GifWork work;
 *   gif_decode(data, len, &info, NULL, 0, NULL, &work);          pass 1: frame count and metadata
 *   pixels = <info.nframes * info.width * info.height uint32_t>;
 *   frames = <info.nframes GifFrame>;
 *   gif_decode(data, len, &info, frames, info.nframes, pixels, &work);   pass 2: RGBA frames
 * Frame i occupies pixels + i * width * height (stride = width). Each frame is a full logical-screen
 * image, composited with the engine rules (equal to standard GIF compositing for the 81 game GIFs).
 * Keyed frames (GCE transparency flag in force) use IMG_KEY (alpha 0) for transparent pixels;
 * opaque frames start black (IMG_BLACK).
 */
#ifndef PORT_GFX_GIF_H
#define PORT_GFX_GIF_H

#include <stdint.h>
#include "image.h"

#define GIF_MAX_FRAMES 256u          /* the engine stores frame indices as bytes (Z:0x4171b0) */
#define GIF_SLOT_MS 50u              /* animation slot length (Z:0x4171b0, Z:0x4170d0) */

enum {
    GIF_OK = 0,
    GIF_E_TRUNCATED = -1,  /* data ends inside a block */
    GIF_E_NETSCAPE = -2,   /* NETSCAPE2.0 sub-block size other than 3: engine error 6 */
    GIF_E_BLOCK = -3,      /* unknown block introducer: engine error 6 ("Unrecognized extension") */
    GIF_E_FRAMES = -4,     /* more than GIF_MAX_FRAMES frames */
    GIF_E_LZW = -5,        /* LZW minimum code size > 11, or corrupt code stream */
    GIF_E_ARGS = -6        /* buffer arguments do not match pass 1 */
};

typedef struct GifInfo {
    uint16_t width, height;  /* logical screen: size of every frame image */
    uint16_t nframes;        /* frames decoded completely (before an error, if any) */
    uint8_t loop;            /* NETSCAPE2.0 with a 3-byte sub-block: loops forever, count ignored */
    uint8_t has_gct;
    int32_t status;          /* GIF_OK or the error that stopped the decoder */
} GifInfo;

typedef struct GifFrame {
    uint32_t delay_ms;       /* GCE delay * 10, from the last GCE read (values persist, first default 0) */
    uint16_t left, top, width, height;  /* frame rectangle */
    uint8_t keyed;           /* GCE transparency flag in force: keyed image (magenta key fill) */
    uint8_t disposal;        /* GCE disposal method in force (0..7) */
    uint8_t transparent_index;
    uint8_t interlaced;
    uint8_t own_gce;         /* this frame had its own GCE */
    uint8_t local_table;     /* frame has a local colour table */
} GifFrame;

typedef struct GifWork {     /* LZW tables (about 16 KiB); one per decoder call, no state kept */
    uint16_t prefix[4096];
    uint8_t suffix[4096];
    uint8_t stack[4097];
} GifWork;

/* Decode. frames/pixels may be NULL (pass 1). Returns info->status. */
int32_t gif_decode(const uint8_t *data, uint32_t len, GifInfo *info, GifFrame *frames, uint32_t max_frames,
                   uint32_t *pixels, GifWork *work);

/* Slot table of CAnim::RecalcTimes Z:0x4171b0: frame i gets delays_ms[i] / 50 slots (integer division;
 * a frame below 50 ms is never shown). table receives one frame index (byte) per 50 ms slot.
 * Returns the slot count, or -1 if cap is too small or a frame needs more than 255 slots
 * (the engine's byte counter never ends: delay >= 12800 ms). */
int32_t gif_anim_slots(const uint32_t *delays_ms, uint32_t n, uint8_t *table, uint32_t cap);

/* Frame lookup Z:0x4170d0 for elapsed = now - start (unsigned 32-bit). slot = elapsed / 50.
 * slot < nslots: table[slot]. Past the end: looping: table[slot % nslots]; else frame 0 (image 0
 * after a non-looping animation ends). *al (may be NULL) receives the engine's AL result: 1 in range
 * or past the end without loop, 0 after a loop wrap. *finished (may be NULL): 1 past the end without loop.
 * nslots = 0: the engine divides by zero when looping; the port returns frame 0. */
uint32_t gif_anim_frame(const uint8_t *table, uint32_t nslots, int loop, uint32_t elapsed_ms,
                        uint8_t *al, uint8_t *finished);

#endif
