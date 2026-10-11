/* 32-bit RGBA image buffer shared by gfx/ and text/ (docs/port-design.md section 8).
 *
 * Pixel = uint32_t 0xAABBGGRR: in memory the bytes are R, G, B, A on little-endian hosts (wasm32, x86),
 * the canvas ImageData order. A Windows COLORREF (0x00BBGGRR) becomes a pixel with `| 0xFF000000`.
 * Opaque pixels have alpha 255. In a keyed (colour-key) image a transparent pixel is IMG_KEY: the
 * magenta key colour (255, 0, 255) with alpha 0. Its RGB stays magenta so that GDI-style blends over
 * it (grey text) give the same tinted result as on Windows.
 */
#ifndef PORT_GFX_IMAGE_H
#define PORT_GFX_IMAGE_H

#include <stdint.h>

typedef struct Image {
    int32_t w, h;      /* size in pixels */
    int32_t stride;    /* pixels per row (>= w) */
    uint32_t *px;      /* row-major, top-down; row y starts at px + y * stride */
    uint8_t keyed;     /* 1: colour-key image, alpha 0 pixels are transparent */
} Image;

#define IMG_RGBA(r, g, b, a) ((uint32_t)(r) | ((uint32_t)(g) << 8) | ((uint32_t)(b) << 16) | ((uint32_t)(a) << 24))
#define IMG_RGB(r, g, b) IMG_RGBA((r), (g), (b), 255u)
#define IMG_KEY IMG_RGBA(255u, 0u, 255u, 0u)   /* engine colour key, render target Z:0x40b950 */
#define IMG_BLACK IMG_RGB(0u, 0u, 0u)
#define IMG_R(p) ((uint32_t)(p) & 0xffu)
#define IMG_G(p) (((uint32_t)(p) >> 8) & 0xffu)
#define IMG_B(p) (((uint32_t)(p) >> 16) & 0xffu)
#define IMG_A(p) ((uint32_t)(p) >> 24)

#endif
