/* Acceptance scenario driver (M7), native build. Runs the full port (engine, shell, Moeboid.gam) on the
 * virtual clock from a scenario file and prints checkpoint lines. port/tests/accept/wasm_drv.mjs runs the
 * same scenario on moeboid.wasm with the same host frame rule and prints the same lines; the browser
 * tests (port/tests/browser/timing.mjs, soak.mjs) apply it through the real page with a fake
 * requestAnimationFrame. Not a test_* program: port/tests/accept/verify.py builds and runs it.
 *
 * Usage: accept_drv SCENARIO [--trace FILE [--trace-grep TEXT]] [--quiet-sound] [--dump DIR]
 * Data: port/build/web/pack.bin, extracted/Moeboid.gam (MOEBOID_ROOT or the source path).
 *
 * Scenario (text, one command per line, times in ms after the page start (input kind 8), nondecreasing):
 *   seed N | clock N | smoothing N | quirks N | frame N     settings (before the first event);
 *                                                          frame = host frame period (default 16)
 *   in T KIND A B                                          port_input(KIND, A, B, T)
 *   check T [LABEL]                                        advance to T, print a checkpoint line
 * Host frame rule (same in every driver): frames at k * frame ms; before an input at T every frame
 * < T runs, then the input is queued (so it is due at its own clock step on every frame schedule); a
 * check at T runs the frames < T and then one advance at T.
 *
 * Output lines:
 *   start seed=.. clock=.. smoothing=.. quirks=..
 *   check T LABEL ticks=N renders=N frame=SHA256 heap_in_use=N heap_top=N fault=0|1 applet=0|1 screen=K
 *         paused=0|1 dialog=0|1 shell=PHASE playscreen=HEX lives=N logs=N now=MS (PHASE: shell_frame.h SH_*;
 *         playscreen: the game's DAT_1000f5e4)
 *   snd OP ID VOICE AT_MS            every drained sound command
 *   log TEXT                         every engine/shell log line (rt_log)
 * --trace FILE: lockstep trace in full mode; every line is written as "<clock ms>\t<line>\tsound_on=0|1"
 * with the GetTickCount value and the engine "Sound" setting at the moment the engine emitted it;
 * --trace-grep keeps only lines with TEXT.
 * --dump DIR: every checkpoint frame as DIR/<T>.rgba ("RGBA", u32 w, u32 h, rows; as test_shell.c). */
#include "cpu/cpu.h"
#include "engine/engine.h"
#include "shell/shell_frame.h" /* shell_test_phase: the reference also links the shell (port_hooks_shell) */
#include "test.h"

static Port *P;
static FILE *trace_out;
static char trace_buf[4096];
static size_t trace_len;
static uint32_t n_logs;
static bool quiet_sound;
static const char *dump_dir;
static const char *trace_grep; /* --trace-grep: write only trace lines that contain this text */

static uint8_t *read_file(const char *rel, uint32_t *len) {
    char path[1024];
    snprintf(path, sizeof path, "%s/%s", test_root(), rel);
    FILE *f = fopen(path, "rb");
    if (!f) return NULL;
    fseek(f, 0, SEEK_END);
    long n = ftell(f);
    fseek(f, 0, SEEK_SET);
    uint8_t *b = malloc((size_t)n + 1);
    if (fread(b, 1, (size_t)n, f) != (size_t)n) n = 0;
    fclose(f);
    *len = (uint32_t)n;
    return b;
}

static void log_sink(const char *p, uint32_t n) {
    n_logs++;
    printf("log %.*s\n", (int)n, p);
}

static void trace_sink(const char *p, uint32_t n) {
    if (!trace_out) return;
    for (uint32_t i = 0; i < n; i++) {
        if (p[i] == '\n') {
            trace_buf[trace_len] = 0;
            if (!trace_grep || strstr(trace_buf, trace_grep))
                fprintf(trace_out, "%u\t%.*s\tsound_on=%d\n", core_ticks(P), (int)trace_len, trace_buf,
                        engine_sound_enabled(P) ? 1 : 0);
            trace_len = 0;
        } else if (trace_len < sizeof trace_buf - 1) {
            trace_buf[trace_len++] = p[i];
        }
    }
}

/* SHA-256 of the RGBA frame (rt_sha256 of the port runtime). */
static void frame_hash(char out[65]) {
    RtSha256 h;
    uint8_t d[32];
    rt_sha256_init(&h);
    rt_sha256_update(&h, P->frame, PORT_W * PORT_H * 4u);
    rt_sha256_final(&h, d);
    rt_sha256_hex(d, out, 64);
}

/* DAT_1000f5e4: the game's play-screen pointer (set by the play screen constructor, never cleared;
 * analysis/interface.md 9). Non-zero on the title or credits screen = dangling pointer of an ended game. */
/* Lives of the running game (port_probe(10): play screen +0x1a4), 0 elsewhere. */
static uint32_t lives(void) {
    struct Cpu *c = engine_cpu(P);
    uint32_t game = c ? cpu_rd32(c, 0x1000f5d8u) : 0u;
    uint32_t st = game ? cpu_rd32(c, game) : 0u;
    return (st && cpu_rd32(c, st) == 0x1000d158u) ? cpu_rd32(c, st + 0x1a4u) : 0u;
}

static uint32_t play_screen_ptr(void) {
    struct Cpu *c = engine_cpu(P);
    return c ? cpu_rd32(c, 0x1000f5e4u) : 0u;
}

/* Game screen kind as port_probe(2) in src/main.c: 1 title, 2 play, 3 credits, 0 none. */
static uint32_t screen_kind(void) {
    struct Cpu *c = engine_cpu(P);
    uint32_t game = c ? cpu_rd32(c, 0x1000f5d8u) : 0u;
    uint32_t st = game ? cpu_rd32(c, game) : 0u;
    uint32_t vt = st ? cpu_rd32(c, st) : 0u;
    return vt == 0x1000d15cu ? 1u : vt == 0x1000d158u ? 2u : vt == 0x1000d154u ? 3u : 0u;
}

static void drain(void) {
    PortSoundCmd cmd[PORT_SOUND_QUEUE_MAX];
    uint32_t n = core_sound_drain(P, cmd);
    if (quiet_sound) return;
    for (uint32_t i = 0; i < n; i++) printf("snd %u %u %u %u\n", cmd[i].op, cmd[i].sound_id, cmd[i].voice, cmd[i].at_ms);
}

static void advance(uint32_t t) {
    core_advance(P, t);
    drain();
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "usage: accept_drv SCENARIO [--trace FILE] [--quiet-sound]\n");
        return 2;
    }
    const char *trace_path = NULL;
    for (int i = 2; i < argc; i++) {
        if (!strcmp(argv[i], "--trace") && i + 1 < argc) trace_path = argv[++i];
        else if (!strcmp(argv[i], "--quiet-sound")) quiet_sound = true;
        else if (!strcmp(argv[i], "--dump") && i + 1 < argc) dump_dir = argv[++i];
        else if (!strcmp(argv[i], "--trace-grep") && i + 1 < argc) trace_grep = argv[++i];
    }
    FILE *sc = fopen(argv[1], "r");
    if (!sc) {
        fprintf(stderr, "accept_drv: cannot open %s\n", argv[1]);
        return 2;
    }
    uint32_t pack_len = 0, gam_len = 0;
    uint8_t *pack = read_file("port/build/web/pack.bin", &pack_len);
    uint8_t *gam = read_file("extracted/Moeboid.gam", &gam_len);
    if (!pack || !gam) {
        fprintf(stderr, "accept_drv: pack.bin or Moeboid.gam missing\n");
        return 2;
    }
    uint32_t seed = 1, clock = 0, smoothing = 1, quirks = 0xffffffffu, frame = 16;
    bool started = false;
    uint32_t next_frame = 0;
    char line[512];
    setvbuf(stdout, NULL, _IOFBF, 1 << 16);
    rt_set_sinks(log_sink, trace_sink);
    while (fgets(line, sizeof line, sc)) {
        char cmd[32] = "", label[64] = "";
        unsigned long long v[4] = {0, 0, 0, 0};
        long long sv[2] = {0, 0};
        if (line[0] == '#' || sscanf(line, "%31s", cmd) != 1) continue;
        if (!started) {
            if (!strcmp(cmd, "seed") && sscanf(line, "%*s %llu", &v[0]) == 1) { seed = (uint32_t)v[0]; continue; }
            if (!strcmp(cmd, "clock") && sscanf(line, "%*s %llu", &v[0]) == 1) { clock = (uint32_t)v[0]; continue; }
            if (!strcmp(cmd, "smoothing") && sscanf(line, "%*s %llu", &v[0]) == 1) { smoothing = (uint32_t)v[0]; continue; }
            if (!strcmp(cmd, "quirks") && sscanf(line, "%*s %lli", &sv[0]) == 1) { quirks = (uint32_t)sv[0]; continue; }
            if (!strcmp(cmd, "frame") && sscanf(line, "%*s %llu", &v[0]) == 1) { frame = (uint32_t)v[0] ? (uint32_t)v[0] : 16u; continue; }
            /* first event: port_set_seed, port_set_smoothing, port_init (as the page host) */
            P = calloc(1, sizeof(Port));
            core_init(P, clock, quirks, seed);
            P->smoothing = smoothing ? 1u : 0u;
            if (trace_path) {
                trace_out = fopen(trace_path, "w");
                trace_set_mode(&P->trace, TRACE_FULL);
            }
            printf("start seed=%u clock=%u smoothing=%u quirks=0x%x\n", seed, clock, smoothing, quirks);
            if (core_start(P, pack, pack_len, gam, gam_len) != 0) {
                printf("error core_start failed\n");
                return 1;
            }
            drain();
            started = true;
            next_frame = frame;
        }
        uint32_t t;
        if (!strcmp(cmd, "in")) {
            if (sscanf(line, "%*s %llu %llu %lld %lld", &v[0], &v[1], &sv[0], &sv[1]) != 4) continue;
            t = (uint32_t)v[0];
            while (next_frame < t) {
                advance(next_frame);
                next_frame += frame;
            }
            core_input(P, (uint32_t)v[1], (int32_t)sv[0], (int32_t)sv[1], t);
        } else if (!strcmp(cmd, "check")) {
            if (sscanf(line, "%*s %llu %63s", &v[0], label) < 1) continue;
            t = (uint32_t)v[0];
            while (next_frame < t) {
                advance(next_frame);
                next_frame += frame;
            }
            advance(t);
            char hx[65];
            frame_hash(hx);
            RtHeapStats hs;
            rt_heap_stats(&hs);
            printf("check %u %s ticks=%u renders=%u frame=%s heap_in_use=%u heap_top=%u fault=%d applet=%d screen=%u "
                   "paused=%d dialog=%d shell=%d playscreen=%x lives=%u logs=%u now=%u\n",
                   t, label[0] ? label : "-", P->trace.tick, engine_render_count(P), hx, hs.in_use, hs.top,
                   engine_fault_text(P)[0] ? 1 : 0, engine_applet_running(P) ? 1 : 0, screen_kind(),
                   engine_paused(P) ? 1 : 0, engine_dialog_waiting(P) ? 1 : 0, (int)shell_test_phase(P), play_screen_ptr(), lives(), n_logs,
                   core_ticks(P));
            if (engine_fault_text(P)[0]) {
                struct Cpu *c = engine_cpu(P);
                printf("fault eip=%08x %s\n", c ? cpu_fault(c)->eip : 0u, engine_fault_text(P));
            }
            if (dump_dir) {
                char path[1200];
                snprintf(path, sizeof path, "%s/%u.rgba", dump_dir, t);
                FILE *f = fopen(path, "wb");
                if (f) {
                    uint32_t wh[2] = {PORT_W, PORT_H};
                    fwrite("RGBA", 1, 4, f);
                    fwrite(wh, 4, 2, f);
                    fwrite(P->frame, 1, PORT_W * PORT_H * 4u, f);
                    fclose(f);
                }
            }
            fflush(stdout);
        }
    }
    fclose(sc);
    if (trace_out) fclose(trace_out);
    printf("end heap_check=%d\n", rt_heap_check());
    return 0;
}
