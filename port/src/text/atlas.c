/* Resource pack reader and glyph atlas runtime. See atlas.h. */
#include "atlas.h"

static uint32_t le16(const uint8_t *p) { return (uint32_t)p[0] | ((uint32_t)p[1] << 8); }
static uint32_t le32(const uint8_t *p) { return le16(p) | (le16(p + 2) << 16); }
static int16_t sle16(const uint8_t *p) { return (int16_t)(uint16_t)le16(p); }

int32_t mpack_open(MPack *p, const uint8_t *data, uint32_t len)
{
    if (len < 12 || data[0] != 'M' || data[1] != 'P' || data[2] != 'A' || data[3] != 'K' || le32(data + 4) != 1u)
        return -1;
    p->data = data;
    p->len = len;
    p->count = le32(data + 8);
    MPackIter it = { 0, 0 };
    MPackEntry e;
    uint32_t n = 0;
    int32_t r;
    while ((r = mpack_next(p, &it, &e)) == 1) n++;
    if (r < 0 || n != p->count) return -1;
    return 0;
}

int32_t mpack_next(const MPack *p, MPackIter *it, MPackEntry *e)
{
    if (it->index >= p->count) return 0;
    uint32_t pos = it->pos ? it->pos : 12u;
    if (pos > p->len || p->len - pos < 4) return -1;
    uint32_t nl = le32(p->data + pos);
    if (nl > p->len - pos - 4 || p->len - pos - 4 - nl < 8) return -1;
    uint32_t off = le32(p->data + pos + 4 + nl), ln = le32(p->data + pos + 8 + nl);
    if (off > p->len || ln > p->len - off) return -1;
    e->name = (const char *)(p->data + pos + 4);
    e->name_len = nl;
    e->data = p->data + off;
    e->len = ln;
    it->pos = pos + 12 + nl;
    it->index++;
    return 1;
}

const uint8_t *mpack_find(const MPack *p, const char *name, uint32_t *len)
{
    MPackIter it = { 0, 0 };
    MPackEntry e;
    while (mpack_next(p, &it, &e) == 1) {
        uint32_t i = 0;
        while (i < e.name_len && name[i] == e.name[i]) i++;
        if (i == e.name_len && name[i] == 0) {
            if (len) *len = e.len;
            return e.data;
        }
    }
    return 0;
}

int32_t atlas_parse(TextAtlas *a, const uint8_t *b, uint32_t len)
{
    if (len < 120 || b[0] != 'M' || b[1] != 'A' || b[2] != 'T' || b[3] != 'L' || le16(b + 4) != 1u) return -1;
    a->blob = b;
    a->len = len;
    a->mode = b[6];
    a->flags = b[7];
    a->px = (uint16_t)le16(b + 8);
    a->weight = (uint16_t)le16(b + 10);
    a->first = (uint16_t)le16(b + 12);
    a->last = (uint16_t)le16(b + 14);
    a->defchar = (uint16_t)le16(b + 16);
    a->tm_height = sle16(b + 18);
    a->tm_ascent = sle16(b + 20);
    a->tm_descent = sle16(b + 22);
    a->tm_int_leading = sle16(b + 24);
    a->tm_ext_leading = sle16(b + 26);
    a->tm_ave_width = sle16(b + 28);
    a->tm_max_width = sle16(b + 30);
    a->ul_offset = sle16(b + 32);
    a->ul_thickness = sle16(b + 34);
    a->so_offset = sle16(b + 36);
    a->so_thickness = sle16(b + 38);
    for (int i = 0; i < 32; i++) {
        a->face[i] = (char)b[44 + i];
        a->source[i] = (char)b[76 + i];
    }
    a->face[31] = 0;
    a->source[31] = 0;
    uint32_t goff = le32(b + 108), coff = le32(b + 112), clen = le32(b + 116);
    if (a->mode > ATLAS_GRAY || a->last < a->first || a->last > 255u || a->defchar < a->first || a->defchar > a->last)
        return -1;
    uint32_t ng = (uint32_t)a->last - a->first + 1u;
    if (goff > len || ng * 16u > len - goff || coff > len || clen > len - coff) return -1;
    a->glyphs = b + goff;
    a->cov = b + coff;
    a->cov_len = clen;
    uint32_t maxv = a->mode == ATLAS_GRAY ? 16u : 1u;
    for (uint32_t i = 0; i < ng; i++) {
        const uint8_t *g = a->glyphs + 16u * i;
        uint32_t w = le16(g + 4), h = le16(g + 6), o = le32(g + 12);
        if (o > clen || w * h > clen - o) return -1;
        for (uint32_t k = 0; k < w * h; k++)
            if (a->cov[o + k] > maxv) return -1;
    }
    return 0;
}

void atlas_glyph(const TextAtlas *a, uint32_t ch, TextGlyph *g)
{
    if (ch < a->first || ch > a->last) ch = a->defchar;
    const uint8_t *r = a->glyphs + 16u * (ch - a->first);
    g->left = sle16(r);
    g->top = sle16(r + 2);
    g->w = (uint16_t)le16(r + 4);
    g->h = (uint16_t)le16(r + 6);
    g->adv = sle16(r + 8);
    g->cov = a->cov + le32(r + 12);
}

int32_t text_fonts_load(TextFonts *tf, const MPack *p)
{
    MPackIter it = { 0, 0 };
    MPackEntry e;
    tf->n = 0;
    while (mpack_next(p, &it, &e) == 1) {
        if (e.name_len < 5 || e.name[0] != 'f' || e.name[1] != 'o' || e.name[2] != 'n' || e.name[3] != 't' ||
            e.name[4] != '/')
            continue;
        if (tf->n >= TEXT_MAX_ATLASES) return -1;
        if (atlas_parse(&tf->atlas[tf->n], e.data, e.len) != 0) return -1;
        tf->n++;
    }
    return (int32_t)tf->n;
}

static int face_eq(const char *a, const char *b)
{
    for (;; a++, b++) {
        char x = *a, y = *b;
        if (x >= 'a' && x <= 'z') x = (char)(x - 32);
        if (y >= 'a' && y <= 'z') y = (char)(y - 32);
        if (x != y) return 0;
        if (x == 0) return 1;
    }
}

const TextAtlas *text_fonts_find(const TextFonts *tf, const char *face, uint32_t px, uint32_t weight, uint32_t mode)
{
    for (uint32_t i = 0; i < tf->n; i++) {
        const TextAtlas *a = &tf->atlas[i];
        if (a->px == px && a->weight == weight && a->mode == mode && face_eq(a->face, face)) return a;
    }
    return 0;
}
