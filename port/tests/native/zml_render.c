/* zml_render: drive port/src/text/zml.c for port/tests/py/test_zml.py.
 * Usage: zml_render PACK.bin < commands
 * Commands, one per line; each prints zero or more data lines, then one line starting with "ok" or "err":
 *   image W H R G B         new opaque canvas filled with (R, G, B)
 *   keyed W H               new keyed canvas filled with the magenta key (alpha 0)
 *   ctx ID SMOOTH           select render context ID (0..15); create it (zml_context_init) on first use
 *   reset ID SMOOTH         re-create render context ID
 *   smooth S                smoothing of the current context
 *   bk R G B                background colour of the current context (OPAQUE mode)
 *   color R G B             text colour of the current context (render target SetTextColor, Z:0x413d50)
 *   fill L T R B R G B      fill a rectangle of the canvas (opaque)
 *   rect L T R B | norect   layout rectangle for the next zml commands (norect: NULL = whole image)
 *   links MODE              collect (sink, not drawn) | draw (NULL sink: drawn at the end of each call)
 *   zml X Y FLAGS HEX       zml_draw with the string given as hex bytes; prints
 *                           "d KIND X Y PX STYLE RRGGBB HEXTEXT" per DrawText call,
 *                           "l X Y W H ID HEXTEXT" per link, "s FACE PX STYLE RRGGBB CENTRE SHADOW T LINEMAX
 *                           OUTX OUTY ENDX ENDY NLINKS MISSING", then "ok RV"
 *   drawlinks HOVER         zml_link_draw for every collected link (0 normal, 1 hover); clears the list
 *   clearlinks              clear the collected links
 *   save PATH               raw file: "RGBA", u32 w, u32 h, w*h u32 pixels */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../../src/text/zml.h"

#define MAX_CTX 16
#define MAX_LINKS 512

static MPack pack;
static TextFonts fonts;
static ZmlContext ctxs[MAX_CTX];
static int ctx_used[MAX_CTX];
static ZmlLink links[MAX_LINKS];
static char *link_text[MAX_LINKS];
static int nlinks;

static void hexout(const char *s, int32_t n)
{
    for (int32_t i = 0; i < n; i++) printf("%02x", (unsigned char)s[i]);
    if (n <= 0) printf("-");
}

static uint32_t rgb_hex(uint32_t px) { return (IMG_R(px) << 16) | (IMG_G(px) << 8) | IMG_B(px); }

static void on_draw(void *user, const ZmlDrawInfo *d)
{
    (void)user;
    printf("d %d %d %d %d %u %06x ", d->kind, d->x, d->y, d->font->px, d->font->style, rgb_hex(d->color));
    hexout(d->s, d->n);
    printf("\n");
}

static void on_link(void *user, const ZmlLink *l)
{
    (void)user;
    printf("l %d %d %d %d %d ", l->x, l->y, l->w, l->h, l->id);
    hexout(l->text, l->len);
    printf("\n");
    if (nlinks < MAX_LINKS) {
        links[nlinks] = *l;
        link_text[nlinks] = malloc((size_t)l->len + 1);
        memcpy(link_text[nlinks], l->text, (size_t)l->len);
        link_text[nlinks][l->len] = 0;
        links[nlinks].text = link_text[nlinks];
        nlinks++;
    }
}

static void clear_links(void)
{
    for (int i = 0; i < nlinks; i++) free(link_text[i]);
    nlinks = 0;
}

static int unhex(const char *h, char *out, int cap)
{
    int n = 0;
    if (h[0] == '-' && (h[1] == 0 || h[1] == ' ')) return 0;
    while (h[0] && h[1] && h[0] != ' ' && n < cap) {
        unsigned v;
        if (sscanf(h, "%2x", &v) != 1) return -1;
        out[n++] = (char)v;
        h += 2;
    }
    return n;
}

int main(int argc, char **argv)
{
    if (argc != 2) { fprintf(stderr, "usage: zml_render PACK\n"); return 2; }
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
    int cur = 0;
    GdiRect rect = { 0, 0, 0, 0 };
    int use_rect = 0, collect = 1;
    static char line[65536];
    static char buf[32768];
    while (fgets(line, sizeof line, stdin)) {
        size_t ln = strlen(line);
        if (ln && line[ln - 1] == '\n') line[--ln] = 0;
        char cmd[32];
        int pos = 0;
        if (sscanf(line, "%31s%n", cmd, &pos) != 1) continue;
        const char *rest = line + pos + (line[pos] == ' ' ? 1 : 0);
        int a, b, c, d, e;
        if (!strcmp(cmd, "image") || !strcmp(cmd, "keyed")) {
            int w, h, r = 0, g = 0, bb = 0;
            if (sscanf(rest, "%d %d %d %d %d", &w, &h, &r, &g, &bb) < 2) { printf("err args\n"); fflush(stdout); continue; }
            free(img.px);
            img.w = w; img.h = h; img.stride = w;
            img.px = malloc((size_t)w * (size_t)h * 4);
            img.keyed = cmd[0] == 'k';
            uint32_t fillc = img.keyed ? IMG_KEY : IMG_RGB(r, g, bb);
            for (long i = 0; i < (long)w * h; i++) img.px[i] = fillc;
            printf("ok\n");
        } else if (!strcmp(cmd, "ctx") || !strcmp(cmd, "reset")) {
            if (sscanf(rest, "%d %d", &a, &b) != 2 || a < 0 || a >= MAX_CTX) { printf("err args\n"); fflush(stdout); continue; }
            cur = a;
            if (!ctx_used[a] || cmd[0] == 'r') {
                zml_context_init(&ctxs[a], &fonts, b);
                ctxs[a].on_draw = on_draw;
                ctx_used[a] = 1;
            }
            ctxs[a].smoothing = (uint8_t)(b != 0);
            printf("ok\n");
        } else if (!strcmp(cmd, "smooth")) {
            ctxs[cur].smoothing = (uint8_t)(rest[0] == '1');
            printf("ok\n");
        } else if (!strcmp(cmd, "bk")) {
            if (sscanf(rest, "%d %d %d", &a, &b, &c) != 3) { printf("err args\n"); fflush(stdout); continue; }
            ctxs[cur].bk_color = IMG_RGB(a, b, c);
            printf("ok\n");
        } else if (!strcmp(cmd, "color")) {
            if (sscanf(rest, "%d %d %d", &a, &b, &c) != 3) { printf("err args\n"); fflush(stdout); continue; }
            ctxs[cur].text_color = IMG_RGB(a, b, c);
            printf("ok\n");
        } else if (!strcmp(cmd, "fill")) {
            int r, g, bb;
            if (!img.px || sscanf(rest, "%d %d %d %d %d %d %d", &a, &b, &c, &d, &r, &g, &bb) != 7) {
                printf("err args\n"); fflush(stdout); continue;
            }
            for (int yy = b < 0 ? 0 : b; yy < d && yy < img.h; yy++)
                for (int xx = a < 0 ? 0 : a; xx < c && xx < img.w; xx++) img.px[yy * img.stride + xx] = IMG_RGB(r, g, bb);
            printf("ok\n");
        } else if (!strcmp(cmd, "rect")) {
            if (sscanf(rest, "%d %d %d %d", &a, &b, &c, &d) != 4) { printf("err args\n"); fflush(stdout); continue; }
            rect.left = a; rect.top = b; rect.right = c; rect.bottom = d;
            use_rect = 1;
            printf("ok\n");
        } else if (!strcmp(cmd, "norect")) {
            use_rect = 0;
            printf("ok\n");
        } else if (!strcmp(cmd, "links")) {
            collect = strncmp(rest, "collect", 7) == 0;
            printf("ok\n");
        } else if (!strcmp(cmd, "zml")) {
            int p2 = 0;
            if (!img.px || !ctx_used[cur] || sscanf(rest, "%d %d %d%n", &a, &b, &e, &p2) != 3) {
                printf("err state\n"); fflush(stdout); continue;
            }
            const char *h = rest + p2 + (rest[p2] == ' ' ? 1 : 0);
            int n = unhex(h, buf, (int)sizeof buf - 1);
            if (n < 0) { printf("err hex\n"); fflush(stdout); continue; }
            buf[n] = 0;
            ZmlLinkSink sink = { on_link, NULL, 0 };
            ZmlContext *cx = &ctxs[cur];
            int32_t rv = zml_draw(cx, &img, buf, n, a, b, use_rect ? &rect : NULL, (uint32_t)e, collect ? &sink : NULL);
            printf("s %s %d %u %06x %d %d %d %d %d %d %d %d %d %d\n", cx->font.face[0] ? cx->font.face : "-", cx->font.px,
                   cx->font.style, rgb_hex(cx->text_color), cx->centre, cx->shadow, cx->transparent, cx->line_max,
                   cx->out_x, cx->out_y, cx->end_x, cx->end_y, cx->nlinks, cx->missing_fonts);
            printf("ok %d\n", rv);
        } else if (!strcmp(cmd, "drawlinks")) {
            if (!img.px) { printf("err state\n"); fflush(stdout); continue; }
            int hover = rest[0] == '1';
            for (int i = 0; i < nlinks; i++) zml_link_draw(&fonts, &img, &links[i], hover, ctxs[cur].smoothing);
            clear_links();
            printf("ok\n");
        } else if (!strcmp(cmd, "clearlinks")) {
            clear_links();
            printf("ok\n");
        } else if (!strcmp(cmd, "save")) {
            FILE *o = fopen(rest, "wb");
            if (!o || !img.px) { printf("err save\n"); fflush(stdout); continue; }
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
    clear_links();
    free(img.px);
    free(data);
    return 0;
}
