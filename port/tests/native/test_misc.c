/* Tests (M1): MSVC rand, storage blob, lockstep trace hashes against the reference corpus
 * (analysis/verification/logs/run_autopilot.log and .ticks.tsv). */
#include "core/port.h"
#include "test.h"

static void test_rand(void) {
    MsvcRand r;
    msvc_srand(&r, 1);
    static const int32_t want[] = {41, 18467, 6334, 26500, 19169, 15724, 11478, 29358, 26962, 24464};
    for (size_t i = 0; i < sizeof want / sizeof want[0]; i++) CHECK_EQ(msvc_rand(&r), want[i]);
    CHECK_EQ(r.calls, 10);
    /* two instances are independent */
    MsvcRand a, b;
    msvc_srand(&a, 12345);
    msvc_srand(&b, 12345);
    msvc_rand(&a);
    CHECK(a.state != b.state);
    CHECK_EQ(msvc_rand(&b), 7584); /* value from a Python model of the formula */
    /* seed 0 */
    msvc_srand(&a, 0);
    CHECK_EQ(msvc_rand(&a), 38);
    /* Port init seeds the engine instance */
    static Port p;
    core_init(&p, 0, 0, 1);
    CHECK_EQ(msvc_rand(&p.rand), 41);
}

static void test_storage(void) {
    Storage s;
    memset(&s, 0, sizeof s);
    CHECK(storage_get(&s, "Score1Name") == NULL);
    CHECK(storage_set(&s, "Score1Name", "ZapSpot"));
    CHECK(storage_set(&s, "Score1Score", "10000"));
    CHECK(storage_set(&s, "odd", "a\\b\nc\rd=e \xe9"));
    CHECK(storage_set(&s, "empty", ""));
    CHECK(s.changed);
    CHECK_STR(storage_get(&s, "Score1Name"), "ZapSpot");
    CHECK(!storage_set(&s, "", "x"));
    CHECK(!storage_set(&s, "a=b", "x"));
    CHECK(!storage_set(&s, "a\nb", "x"));
    uint32_t n;
    const char *blob = storage_blob(&s, &n);
    const char *want =
        "MOEBOID-STORAGE 1\nScore1Name=ZapSpot\nScore1Score=10000\nodd=a\\\\b\\nc\\rd=e \xe9\nempty=\n";
    CHECK_EQ(n, strlen(want));
    CHECK(memcmp(blob, want, n) == 0);
    /* same value: no change flag */
    s.changed = false;
    CHECK(storage_set(&s, "Score1Name", "ZapSpot"));
    CHECK(!s.changed);
    CHECK(storage_set(&s, "Score1Name", "tester"));
    CHECK(s.changed);
    CHECK(storage_remove(&s, "empty"));
    CHECK(!storage_remove(&s, "empty"));
    /* round trip */
    char copy[256];
    blob = storage_blob(&s, &n);
    memcpy(copy, blob, n);
    Storage t;
    memset(&t, 0, sizeof t);
    CHECK_EQ(storage_load(&t, (const uint8_t *)copy, n), 0);
    CHECK(!t.changed);
    CHECK_EQ(t.count, 3);
    CHECK_STR(storage_get(&t, "odd"), "a\\b\nc\rd=e \xe9");
    CHECK_STR(storage_get(&t, "Score1Name"), "tester");
    uint32_t n2;
    const char *b2 = storage_blob(&t, &n2);
    CHECK(n2 == n && memcmp(b2, copy, n) == 0);
    /* bad input */
    CHECK_EQ(storage_load(&t, (const uint8_t *)"garbage", 7), -1);
    CHECK_EQ(t.count, 0);
    const char *mixed = "MOEBOID-STORAGE 1\nok=1\nnoequals\n=novalue\nok=dup\n\nk2=2";
    CHECK_EQ(storage_load(&t, (const uint8_t *)mixed, (uint32_t)strlen(mixed)), 4);
    CHECK_EQ(t.count, 2);
    CHECK_STR(storage_get(&t, "ok"), "1");
    CHECK_STR(storage_get(&t, "k2"), "2");
    CHECK_EQ(storage_load(&t, NULL, 0), 0);
    CHECK_EQ(t.count, 0);
    storage_clear(&s);
    storage_clear(&t);
}

/* ---- trace: replay the logged ticks of the reference corpus through the trace API ---- */
static char g_rows[1 << 20];
static size_t g_rows_len;
static void sink(const char *p, uint32_t n) {
    if (g_rows_len + n < sizeof g_rows) {
        memcpy(g_rows + g_rows_len, p, n);
        g_rows_len += n;
    }
}

static int is_call_line(const char *l) {
    if (strncmp(l, "  ", 2) != 0) return 0;
    for (int i = 2; i < 10; i++)
        if (!((l[i] >= '0' && l[i] <= '9') || (l[i] >= 'a' && l[i] <= 'f'))) return 0;
    return l[10] == ' ';
}

static void test_trace_corpus(void) {
    char path[1200];
    snprintf(path, sizeof path, "%s/analysis/verification/logs/run_autopilot.log", test_root());
    FILE *f = fopen(path, "rb");
    if (!f) {
        fprintf(stderr, "skip: %s not found\n", path);
        return;
    }
    Trace t;
    trace_init(&t);
    trace_set_mode(&t, TRACE_HASH);
    rt_set_sinks(NULL, sink);
    g_rows_len = 0;
    static char line[1 << 16];
    static char state[4096];
    state[0] = 0;
    int ticks = 0;
    while (fgets(line, sizeof line, f)) {
        size_t n = strlen(line);
        while (n && (line[n - 1] == '\n' || line[n - 1] == '\r')) line[--n] = 0;
        unsigned tick, ms;
        if (line[0] == 'T' && sscanf(line, "T%u ms=%u ", &tick, &ms) == 2) {
            if (t.open) trace_end_tick(&t, state);
            state[0] = 0;
            const char *what = strchr(strchr(line, ' ') + 1, ' ');
            trace_begin_tick(&t, ms, what ? what + 1 : "");
            ticks++;
        } else if (t.open && is_call_line(line)) {
            trace_line(&t, line + 2, (uint32_t)(n - 2));
        } else if (t.open && strncmp(line, "  state ", 8) == 0) {
            snprintf(state, sizeof state, "%s", line + 8);
        } else if (t.open && strncmp(line, "  ", 2) != 0) {
            trace_end_tick(&t, state);
            state[0] = 0;
        }
    }
    if (t.open) trace_end_tick(&t, state);
    fclose(f);
    rt_set_sinks(NULL, NULL);
    CHECK_EQ(ticks, 60);
    /* compare the rows with the first lines of ticks.tsv */
    snprintf(path, sizeof path, "%s/analysis/verification/logs/run_autopilot.ticks.tsv", test_root());
    f = fopen(path, "rb");
    CHECK(f != NULL);
    if (!f) return;
    char *want = (char *)calloc(1, 1 << 20);
    size_t wn = 0;
    CHECK(fgets(line, sizeof line, f) != NULL); /* header */
    for (int i = 0; i < ticks && fgets(line, sizeof line, f); i++) {
        size_t n = strlen(line);
        memcpy(want + wn, line, n);
        wn += n;
    }
    fclose(f);
    CHECK_EQ(g_rows_len, wn);
    int equal = g_rows_len == wn && memcmp(g_rows, want, wn) == 0;
    CHECK(equal);
    if (!equal) fprintf(stderr, "trace rows differ:\n%.*s\n", (int)(g_rows_len < 400 ? g_rows_len : 400), g_rows);
    else printf("trace: %d corpus ticks reproduce run_autopilot.ticks.tsv rows 1-%d\n", ticks, ticks);
    free(want);
}

static void test_trace_api(void) {
    Trace t;
    trace_init(&t);
    trace_set_mode(&t, TRACE_FULL);
    rt_set_sinks(NULL, sink);
    g_rows_len = 0;
    trace_begin_tick(&t, 0, "x");
    CHECK_STR(trace_end_tick(&t, NULL), "e3b0c44298fc1c14"); /* empty tick */
    trace_begin_tick(&t, 20, "timer");
    trace_line(&t, "a", 1);
    trace_linef(&t, "%s", "b");
    CHECK_STR(trace_end_tick(&t, NULL), "7e18f737311b2dc3"); /* sha256("a\nb") */
    /* a long formatted line (> 512 bytes) */
    char big[2000];
    memset(big, 'z', sizeof big - 1);
    big[sizeof big - 1] = 0;
    trace_begin_tick(&t, 40, "big");
    trace_linef(&t, "%s", big);
    trace_end_tick(&t, NULL);
    RtSha256 s;
    uint8_t d[32];
    char h[17];
    rt_sha256_init(&s);
    rt_sha256_update(&s, big, strlen(big));
    rt_sha256_final(&s, d);
    rt_sha256_hex(d, h, 16);
    CHECK_STR(t.last_hash, h);
    g_rows[g_rows_len] = 0;
    CHECK(strncmp(g_rows, "T1 ms=0 x\n1\t0\t0\te3b0c44298fc1c14\t-\nT2 ms=20 timer\n  a\n  b\n2\t20\t2\t7e18f737311b2dc3\t-\n",
                  80) == 0);
    /* mode off: no output, lines ignored */
    trace_set_mode(&t, TRACE_OFF);
    size_t before = g_rows_len;
    trace_begin_tick(&t, 60, "off");
    trace_line(&t, "a", 1);
    trace_end_tick(&t, NULL);
    CHECK_EQ(g_rows_len, before);
    rt_set_sinks(NULL, NULL);
}

int main(void) {
    test_rand();
    test_storage();
    test_trace_api();
    test_trace_corpus();
    return test_report("test_misc");
}
