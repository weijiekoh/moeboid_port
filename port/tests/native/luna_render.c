/* Test driver for src/shell/luna.c (workstream LUNA). Built and run by port/tests/py/test_luna.py.
 *
 * Usage:
 *   luna_render info BLOB
 *       prints the load results, "color ID RRGGBB SRC", "metric ID VALUE SRC", "fontpx 13 11"
 *   luna_render render BLOB PACK OUT CLIENT_W CLIENT_H ACTIVE CLOSE CLOSE_STATE CAPTION
 *       renders one window at (0, 0) into a transparent image of the window size, writes OUT
 *       (u32 w, u32 h, then RGBA rows) and prints "geom ...". PACK "-": no caption text; else the
 *       caption font comes from the pack atlases (Trebuchet MS 13 px bold, smoothing on).
 *   luna_render fit PACK MAX_W CAPTION
 *       prints "fit <text>" = luna_fit_ellipsis result
 * Test programs may use the host libc. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "shell/luna.h"
#include "text/atlas.h"

static unsigned char *read_file(const char *path, long *n) {
    FILE *f = fopen(path, "rb");
    if (!f) return NULL;
    fseek(f, 0, SEEK_END);
    *n = ftell(f);
    fseek(f, 0, SEEK_SET);
    unsigned char *b = malloc((size_t)*n);
    if (b && fread(b, 1, (size_t)*n, f) != (size_t)*n) {
        free(b);
        b = NULL;
    }
    fclose(f);
    return b;
}

static LunaTheme theme;
static TextFonts fonts;
static MPack pack;

/* Caption font from the pack (M3 atlases). Returns 0 on success. */
static int caption_font(const char *pack_path, GdiFont *f, const LunaTheme *t) {
    long n = 0;
    unsigned char *p = read_file(pack_path, &n);
    if (!p || mpack_open(&pack, p, (uint32_t)n) != 0 || text_fonts_load(&fonts, &pack) <= 0) return -1;
    int32_t pt = t ? luna_metric(t, LUNA_M_CAPTION_FONT_PT) : 10;
    int32_t weight = t ? luna_metric(t, LUNA_M_CAPTION_FONT_WEIGHT) : 700;
    return gdi_font_select(f, &fonts, "Trebuchet MS", -luna_font_px(pt), weight, 0, 0) == 0 ? 0 : -1;
}

int main(int argc, char **argv) {
    if (argc < 3) {
        fprintf(stderr, "usage: luna_render info|render|fit ...\n");
        return 2;
    }
    if (strcmp(argv[1], "fit") == 0 && argc == 5) {
        GdiFont f;
        if (caption_font(argv[2], &f, NULL) != 0) return 2;
        char out[64];
        int32_t n = luna_fit_ellipsis(&f, argv[4], (int32_t)strlen(argv[4]), atoi(argv[3]), out, (int32_t)sizeof out);
        int32_t cx, cy;
        gdi_get_text_extent_point32(&f, out, n, &cx, &cy);
        printf("fit %d %.*s\n", cx, (int)n, out);
        return 0;
    }
    long n = 0;
    unsigned char *blob = read_file(argv[2], &n);
    if (!blob) {
        fprintf(stderr, "cannot read %s\n", argv[2]);
        return 2;
    }
    int rc = luna_load(&theme, blob, (uint32_t)n);
    if (strcmp(argv[1], "info") == 0) {
        static LunaTheme t2;
        printf("load %d\n", rc);
        printf("load_short %d\n", luna_load(&t2, blob, 20));
        printf("load_trunc %d\n", luna_load(&t2, blob, (uint32_t)n - 1));
        blob[0] = 'X';
        printf("load_magic %d\n", luna_load(&t2, blob, (uint32_t)n));
        blob[0] = 'L';
        for (int i = 0; i < LUNA_COLOR_COUNT; i++) {
            uint8_t src;
            uint32_t c = luna_color(&theme, i, &src);
            if (src != LUNA_SRC_NONE) printf("color %d %06x %u\n", i, c, src);
        }
        for (int i = 0; i < LUNA_METRIC_COUNT; i++)
            printf("metric %d %d %u\n", i, luna_metric(&theme, i), theme.metric_src[i]);
        printf("fontpx %d %d\n", luna_font_px(10), luna_font_px(8));
        return rc == LUNA_OK ? 0 : 1;
    }
    if (strcmp(argv[1], "render") != 0 || argc != 11 || rc != LUNA_OK) {
        fprintf(stderr, "bad arguments or load error %d\n", rc);
        return 2;
    }
    GdiFont font;
    const GdiFont *fp = NULL;
    if (strcmp(argv[3], "-") != 0) {
        if (caption_font(argv[3], &font, &theme) != 0) {
            fprintf(stderr, "no caption font in %s\n", argv[3]);
            return 2;
        }
        fp = &font;
    }
    LunaWindow w = {0};
    w.client_w = atoi(argv[5]);
    w.client_h = atoi(argv[6]);
    w.active = atoi(argv[7]) != 0;
    w.close_button = atoi(argv[8]) != 0;
    w.close_state = (uint8_t)atoi(argv[9]);
    w.caption = argv[10];
    w.caption_len = -1;
    LunaGeom g;
    luna_geom(&theme, w.client_w, w.client_h, w.close_button, &g);
    Image img = {g.win_w, g.win_h, g.win_w, calloc((size_t)g.win_w * (size_t)g.win_h, 4), 0};
    luna_draw_window(&theme, &img, 0, 0, &w, fp, 1, &g);
    printf("geom %d %d frame %d top %d caption_h %d client %d %d %d %d text %d %d %d %d close %d %d %d %d\n", g.win_w,
           g.win_h, g.frame, g.top, g.caption_h, g.client.x, g.client.y, g.client.w, g.client.h, g.text.x, g.text.y,
           g.text.w, g.text.h, g.close.x, g.close.y, g.close.w, g.close.h);
    FILE *f = fopen(argv[4], "wb");
    if (!f) return 2;
    uint32_t hdr[2] = {(uint32_t)g.win_w, (uint32_t)g.win_h};
    fwrite(hdr, 4, 2, f);
    fwrite(img.px, 4, (size_t)g.win_w * (size_t)g.win_h, f); /* 0xAABBGGRR little-endian = R, G, B, A */
    fclose(f);
    free(img.px);
    free(blob);
    return 0;
}
