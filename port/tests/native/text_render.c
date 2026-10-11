/* text_render: drive port/src/text (atlas loader, GDI text output) for port/tests/py/test_atlas.py.
 * Usage: text_render PACK.bin < commands
 * Commands, one per line (FACE uses '_' for spaces; STRING is the rest of the line, raw bytes):
 *   fonts                       list atlases: name px weight mode flags tmHeight source
 *   image W H R G B             new opaque canvas filled with (R, G, B)
 *   keyed W H                   new keyed canvas filled with the magenta key (alpha 0)
 *   font FACE LFHEIGHT LFWEIGHT UNDERLINE STRIKEOUT
 *   color R G B | bk R G B | mode T|O | smooth 0|1 | clip L T R B | noclip | opaquerect L T R B | noopaquerect
 *   metrics                     tmHeight tmAscent tmDescent tmInternalLeading tmExternalLeading tmAveCharWidth
 *                               tmMaxCharWidth ul_offset ul_thickness gray_available
 *   extent STRING               cx cy (GetTextExtentPoint32A)
 *   text X Y STRING             ExtTextOutA
 *   save PATH                   raw file: "RGBA", u32 w, u32 h, w*h u32 pixels
 * Each command prints one line starting with "ok" or "err". */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../../src/text/gdi_text.h"

static MPack pack;
static TextFonts fonts;

int main(int argc, char **argv)
{
    if (argc != 2) { fprintf(stderr, "usage: text_render PACK\n"); return 2; }
    FILE *f = fopen(argv[1], "rb");
    if (!f) { perror(argv[1]); return 1; }
    fseek(f, 0, SEEK_END);
    long len = ftell(f);
    fseek(f, 0, SEEK_SET);
    uint8_t *data = malloc((size_t)len);
    if (!data || fread(data, 1, (size_t)len, f) != (size_t)len) return 1;
    fclose(f);
    if (mpack_open(&pack, data, (uint32_t)len) != 0) { fprintf(stderr, "bad pack\n"); return 1; }
    if (text_fonts_load(&fonts, &pack) < 0) { fprintf(stderr, "bad atlas\n"); return 1; }
    Image img = { 0, 0, 0, NULL, 0 };
    GdiFont font;
    memset(&font, 0, sizeof font);
    GdiTextState st = { IMG_RGB(0, 0, 0), IMG_RGB(255, 255, 255), GDI_TRANSPARENT, 0 };
    GdiRect clip = { 0, 0, 0, 0 }, orect = { 0, 0, 0, 0 };
    int use_clip = 0, use_orect = 0;
    static char line[8192];
    while (fgets(line, sizeof line, stdin)) {
        size_t ln = strlen(line);
        if (ln && line[ln - 1] == '\n') line[--ln] = 0;
        char cmd[32];
        int pos = 0;
        if (sscanf(line, "%31s%n", cmd, &pos) != 1) continue;
        const char *rest = line + pos + (line[pos] == ' ' ? 1 : 0);
        int a, b, c, d;
        if (!strcmp(cmd, "fonts")) {
            for (uint32_t i = 0; i < fonts.n; i++) {
                const TextAtlas *t = &fonts.atlas[i];
                printf("font %s|%u|%u|%u|%u|%d|%s\n", t->face, t->px, t->weight, t->mode, t->flags, t->tm_height,
                       t->source);
            }
            printf("ok %u\n", fonts.n);
        } else if (!strcmp(cmd, "image") || !strcmp(cmd, "keyed")) {
            int w, h, r = 0, g = 0, bb = 0;
            int k = sscanf(rest, "%d %d %d %d %d", &w, &h, &r, &g, &bb);
            if (k < 2) { printf("err args\n"); continue; }
            free(img.px);
            img.w = w; img.h = h; img.stride = w;
            img.px = malloc((size_t)w * (size_t)h * 4);
            img.keyed = cmd[0] == 'k';
            uint32_t fillc = img.keyed ? IMG_KEY : IMG_RGB(r, g, bb);
            for (long i = 0; i < (long)w * h; i++) img.px[i] = fillc;
            printf("ok\n");
        } else if (!strcmp(cmd, "font")) {
            char face[64];
            if (sscanf(rest, "%63s %d %d %d %d", face, &a, &b, &c, &d) != 5) { printf("err args\n"); continue; }
            for (char *p = face; *p; p++) if (*p == '_') *p = ' ';
            if (gdi_font_select(&font, &fonts, face, a, b, c, d) != 0) printf("err nofont\n");
            else printf("ok %s|%u|%u|gray=%d\n", font.mono->face, font.mono->px, font.mono->weight, font.gray != NULL);
        } else if (!strcmp(cmd, "color") || !strcmp(cmd, "bk")) {
            if (sscanf(rest, "%d %d %d", &a, &b, &c) != 3) { printf("err args\n"); continue; }
            if (cmd[0] == 'c') st.text_color = IMG_RGB(a, b, c); else st.bk_color = IMG_RGB(a, b, c);
            printf("ok\n");
        } else if (!strcmp(cmd, "mode")) {
            st.bk_mode = rest[0] == 'O' ? GDI_OPAQUE : GDI_TRANSPARENT;
            printf("ok\n");
        } else if (!strcmp(cmd, "smooth")) {
            st.smoothing = (uint8_t)(rest[0] == '1');
            printf("ok\n");
        } else if (!strcmp(cmd, "clip") || !strcmp(cmd, "opaquerect")) {
            if (sscanf(rest, "%d %d %d %d", &a, &b, &c, &d) != 4) { printf("err args\n"); continue; }
            GdiRect r = { a, b, c, d };
            if (cmd[0] == 'c') { clip = r; use_clip = 1; } else { orect = r; use_orect = 1; }
            printf("ok\n");
        } else if (!strcmp(cmd, "noclip")) {
            use_clip = 0;
            printf("ok\n");
        } else if (!strcmp(cmd, "noopaquerect")) {
            use_orect = 0;
            printf("ok\n");
        } else if (!strcmp(cmd, "metrics")) {
            if (!font.mono) { printf("err nofont\n"); continue; }
            GdiTextMetrics tm;
            gdi_get_text_metrics(&font, &tm);
            printf("ok %d %d %d %d %d %d %d %d %d %d\n", tm.tmHeight, tm.tmAscent, tm.tmDescent, tm.tmInternalLeading,
                   tm.tmExternalLeading, tm.tmAveCharWidth, tm.tmMaxCharWidth, font.mono->ul_offset,
                   font.mono->ul_thickness, font.gray != NULL);
        } else if (!strcmp(cmd, "extent")) {
            if (!font.mono) { printf("err nofont\n"); continue; }
            int32_t cx, cy;
            gdi_get_text_extent_point32(&font, rest, (int32_t)strlen(rest), &cx, &cy);
            printf("ok %d %d\n", cx, cy);
        } else if (!strcmp(cmd, "text")) {
            int p2 = 0;
            if (!font.mono || !img.px || sscanf(rest, "%d %d%n", &a, &b, &p2) != 2) { printf("err state\n"); continue; }
            const char *s = rest + p2 + (rest[p2] == ' ' ? 1 : 0);
            GdiRect r = use_clip ? clip : orect;
            uint32_t opt = (use_clip ? GDI_ETO_CLIPPED : 0u) | (use_orect ? GDI_ETO_OPAQUE : 0u);
            if (use_clip && use_orect) { printf("err clip and opaquerect together\n"); continue; }
            gdi_ext_text_out(&img, a, b, opt, (use_clip || use_orect) ? &r : NULL, s, (int32_t)strlen(s), &font, &st);
            printf("ok\n");
        } else if (!strcmp(cmd, "save")) {
            FILE *o = fopen(rest, "wb");
            if (!o || !img.px) { printf("err save\n"); continue; }
            uint32_t hdr[2] = { (uint32_t)img.w, (uint32_t)img.h };
            fwrite("RGBA", 1, 4, o);
            fwrite(hdr, 4, 2, o);
            fwrite(img.px, 4, (size_t)img.w * (size_t)img.h, o);
            fclose(o);
            printf("ok\n");
        } else {
            printf("err unknown %s\n", cmd);
        }
        fflush(stdout);
    }
    free(img.px);
    free(data);
    return 0;
}
