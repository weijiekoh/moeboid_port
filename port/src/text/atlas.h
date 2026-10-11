/* Resource pack reader and glyph atlas runtime (docs/port-design.md sections 7 and 8).
 * No allocation: every structure points into the pack bytes, which must stay alive. */
#ifndef PORT_TEXT_ATLAS_H
#define PORT_TEXT_ATLAS_H

#include <stdint.h>

/* ---- pack.bin ("MPAK", version 1) */
typedef struct MPack {
    const uint8_t *data;
    uint32_t len, count;
} MPack;

typedef struct MPackEntry {
    const char *name;        /* not NUL-terminated */
    uint32_t name_len;
    const uint8_t *data;
    uint32_t len;
} MPackEntry;

typedef struct MPackIter {
    uint32_t index, pos;     /* start with {0, 0} */
} MPackIter;

int32_t mpack_open(MPack *p, const uint8_t *data, uint32_t len);   /* 0 ok, -1 bad header or bounds */
int32_t mpack_next(const MPack *p, MPackIter *it, MPackEntry *e);   /* 1 = entry returned, 0 = end */
const uint8_t *mpack_find(const MPack *p, const char *name, uint32_t *len);  /* NULL if absent */

/* ---- glyph atlas ("MATL", version 1), one per (face, px, weight, mode) */
#define ATLAS_MONO 0u                /* coverage 0/1 */
#define ATLAS_GRAY 1u                /* coverage 0..16 (17 levels, decision O6, unproven) */
#define ATLAS_F_PLACEHOLDER 0x01u    /* glyphs from a substitute face (Arial) */
#define ATLAS_F_RASTER 0x02u         /* bitmap font strike, exact copy (MS Sans Serif) */
#define ATLAS_F_HINTED 0x04u         /* grid-fitted at px */
#define ATLAS_F_GASP_GRIDFIT 0x08u   /* gasp GASP_GRIDFIT at px */
#define ATLAS_F_GASP_DOGRAY 0x10u    /* gasp GASP_DOGRAY at px: grey allowed when smoothing is on */
#define ATLAS_F_UNVERIFIED 0x20u     /* XP-generation font, version unverified */

typedef struct TextAtlas {
    const uint8_t *blob;
    uint32_t len;
    char face[32];               /* requested face name, e.g. "Arial", "MS Sans Serif", "Tahoma" */
    char source[32];             /* font file and version */
    uint16_t px;                 /* em height = -lfHeight */
    uint16_t weight;             /* 400 or 700 */
    uint8_t mode, flags;
    uint16_t first, last, defchar;
    int16_t tm_height, tm_ascent, tm_descent, tm_int_leading, tm_ext_leading, tm_ave_width, tm_max_width;
    int16_t ul_offset;           /* underline top row = baseline row + ul_offset (inferred) */
    int16_t ul_thickness;
    int16_t so_offset, so_thickness;  /* strikeout top row = baseline row - so_offset (inferred, unused) */
    const uint8_t *glyphs;       /* (last - first + 1) records of 16 bytes */
    const uint8_t *cov;          /* coverage bytes */
    uint32_t cov_len;
} TextAtlas;

typedef struct TextGlyph {
    int16_t left;                /* first column relative to the pen x */
    int16_t top;                 /* rows above the baseline: first row = baseline row - top */
    uint16_t w, h;
    int16_t adv;                 /* pen advance in pixels */
    const uint8_t *cov;          /* w * h coverage bytes, top row first */
} TextGlyph;

int32_t atlas_parse(TextAtlas *a, const uint8_t *blob, uint32_t len);  /* 0 ok, -1 invalid */
void atlas_glyph(const TextAtlas *a, uint32_t ch, TextGlyph *g);       /* ch outside first..last: defchar */

/* ---- every atlas of the pack */
#define TEXT_MAX_ATLASES 64u

typedef struct TextFonts {
    TextAtlas atlas[TEXT_MAX_ATLASES];
    uint32_t n;
} TextFonts;

int32_t text_fonts_load(TextFonts *tf, const MPack *p);   /* loads every "font/" entry; count or -1 */
/* Face compared without case. mode ATLAS_MONO or ATLAS_GRAY. NULL if absent. */
const TextAtlas *text_fonts_find(const TextFonts *tf, const char *face, uint32_t px, uint32_t weight, uint32_t mode);

#endif
