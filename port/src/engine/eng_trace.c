/* Lockstep trace of the engine calls (M4; port-design.md section 9).
 * One tick per engine-to-game call (DllMain, Shell_StartApplet, timer, listener, Shell_StopApplet),
 * one line per game-to-engine call in the canonical form of analysis/verification/harness/mock.py
 * (Engine._method, canon_args, Obj.__repr__), and the game-state digest of run.py game_state. */
#include "eng_int.h"

typedef struct MethodInfo {
    uint8_t iface, slot;
    const char *name;
    const char *sig;
} MethodInfo;

/* (interface, slot): name and argument signature of mock.py BEHAVIOUR. */
static const MethodInfo k_methods[] = {
    {CPU_IF_ISHELL, 2, "Random", ""},
    {CPU_IF_IFACTORY, 2, "CreateSurfaceFromAnim", "oi"},
    {CPU_IF_IFACTORY, 3, "CreateSurfaceFromFile", "si"},
    {CPU_IF_IFACTORY, 4, "CreateSurface", "iii"},
    {CPU_IF_IFACTORY, 5, "CreateAnim", "o"},
    {CPU_IF_IFACTORY, 8, "CreateImage", "iii"},
    {CPU_IF_IFACTORY, 10, "CreateFont", "sii"},
    {CPU_IF_IFACTORY, 12, "CreateButton", "opiiiioiic"},
    {CPU_IF_IFACTORY, 13, "CreateTimer", "pic"},
    {CPU_IF_IFACTORY, 16, "CreateSound", "si"},
    {CPU_IF_IFACTORY, 17, "CreateListener", "oipc"},
    {CPU_IF_ISYSTEM, 2, "SetCaption", "s"},
    {CPU_IF_ISYSTEM, 3, "SetGameInProgress", "i"},
    {CPU_IF_ISYSTEM, 4, "SetShellButtons", "i"},
    {CPU_IF_ISYSTEM, 5, "MessageBox", "ssi"},
    {CPU_IF_ISYSTEM, 6, "InputBox", "ssspii"},
    {CPU_IF_ISYSTEM, 8, "GetKeyState", "b"},
    {CPU_IF_ISETTINGS, 4, "SetGameValue", "ss"},
    {CPU_IF_ISETTINGS, 5, "GetGameValue", "sp"},
    {CPU_IF_ISURFACE, 1, "Release", ""},
    {CPU_IF_ISURFACE, 2, "SetLoc", "iii"},
    {CPU_IF_ISURFACE, 3, "GetLoc", "pp"},
    {CPU_IF_ISURFACE, 4, "SetVisible", "ii"},
    {CPU_IF_ISURFACE, 6, "AttachSurface", "o"},
    {CPU_IF_ISURFACE, 7, "DetachSurface", "o"},
    {CPU_IF_ISURFACE, 11, "PlayAnim", ""},
    {CPU_IF_ISURFACE, 13, "StopAnim", ""},
    {CPU_IF_ISURFACE, 15, "GetAnim", "p"},
    {CPU_IF_ISURFACE, 17, "GetImage", "p"},
    {CPU_IF_ISURFACE, 18, "GetSize", "pp"},
    {CPU_IF_IBUTTON, 1, "Release", ""},
    {CPU_IF_IANIM, 1, "Release", ""},
    {CPU_IF_IANIM, 4, "GetImageSeq", "p"},
    {CPU_IF_IIMAGESEQ, 1, "Release", ""},
    {CPU_IF_IIMAGESEQ, 4, "GetImage", "ip"},
    {CPU_IF_IIMAGE, 1, "Release", ""},
    {CPU_IF_IIMAGE, 3, "DrawRect", "iiii"},
    {CPU_IF_IIMAGE, 4, "FillRect", "iiii"},
    {CPU_IF_IIMAGE, 6, "DrawText", "niii"},
    {CPU_IF_IIMAGE, 7, "SetColor", "bbb"},
    {CPU_IF_IIMAGE, 9, "SetTextColor", "bbb"},
    {CPU_IF_IIMAGE, 13, "ClearToColor", "bbb"},
    {CPU_IF_IIMAGE, 16, "DrawImage", "oii"},
    {CPU_IF_IIMAGE, 18, "SetFont", "o"},
    {CPU_IF_IIMAGE, 19, "GetFont", "p"},
    {CPU_IF_IIMAGE, 20, "GetSize", "pp"},
    {CPU_IF_IIMAGE, 22, "MeasureText", "onip"},
    {CPU_IF_IFONT, 1, "Release", ""},
    {CPU_IF_IFONT, 3, "GetInfo", "pppp"},
    {CPU_IF_ITIMER, 1, "Release", ""},
    {CPU_IF_ITIMER, 2, "Start", ""},
    {CPU_IF_ISOUND, 1, "Release", ""},
    {CPU_IF_ISOUND, 2, "Play", "i"},
    {CPU_IF_ILISTENER, 1, "Release", ""},
};

static const char *k_iface_names[CPU_IF_COUNT] = {"IShell", "IFactory", "ISystem", "ISettings", "ISurface",
                                                   "IButton", "IAnim", "IImageSeq", "IImage", "IFont",
                                                   "ITimer", "ISound", "IListener"};

typedef struct Buf {
    char *p;
    uint32_t n, cap;
} Buf;

static void bput(Buf *b, const char *s, uint32_t n) {
    for (uint32_t i = 0; i < n; i++)
        if (b->n + 1 < b->cap) b->p[b->n++] = s[i];
    b->p[b->n] = 0;
}
static void bstr(Buf *b, const char *s) { bput(b, s, (uint32_t)rt_strlen(s)); }
static void bfmt(Buf *b, const char *fmt, ...) __attribute__((format(printf, 2, 3)));
static void bfmt(Buf *b, const char *fmt, ...) {
    char tmp[96];
    rt_va_list ap;
    rt_va_start(ap, fmt);
    int n = rt_vsnprintf(tmp, sizeof tmp, fmt, ap);
    rt_va_end(ap);
    if (n > (int)sizeof tmp - 1) n = (int)sizeof tmp - 1;
    bput(b, tmp, (uint32_t)n);
}

/* Python repr() of a latin-1 decoded str, UTF-8 encoded (mock.py: repr(text), lines encoded as UTF-8). */
static void py_repr(Buf *b, const uint8_t *s, uint32_t n) {
    bool sq = false, dq = false;
    for (uint32_t i = 0; i < n; i++) {
        if (s[i] == '\'') sq = true;
        if (s[i] == '"') dq = true;
    }
    char q = (sq && !dq) ? '"' : '\'';
    bput(b, &q, 1);
    for (uint32_t i = 0; i < n; i++) {
        uint8_t c = s[i];
        char t[8];
        if (c == (uint8_t)q || c == '\\') {
            t[0] = '\\';
            t[1] = (char)c;
            bput(b, t, 2);
        } else if (c == '\t') bstr(b, "\\t");
        else if (c == '\n') bstr(b, "\\n");
        else if (c == '\r') bstr(b, "\\r");
        else if (c < 0x20 || c == 0x7f || (c >= 0x80 && c <= 0xa0) || c == 0xad) bfmt(b, "\\x%02x", c);
        else if (c < 0x80) bput(b, (const char *)&c, 1);
        else {
            t[0] = (char)(0xc0u | (c >> 6));
            t[1] = (char)(0x80u | (c & 0x3fu));
            bput(b, t, 2);
        }
    }
    bput(b, &q, 1);
}

static const MethodInfo *method_info(uint32_t iface, uint32_t slot) {
    for (uint32_t i = 0; i < RT_COUNTOF(k_methods); i++)
        if (k_methods[i].iface == iface && k_methods[i].slot == slot) return &k_methods[i];
    return NULL;
}

/* repr of an engine object address: "#id:Type"; false when the address is no object. */
static bool obj_repr(Engine *e, Buf *b, uint32_t a) {
    if (a && a == e->ctx) {
        bfmt(b, "#%u:IShell", e->ctx_tid);
        return true;
    }
    if (a && a == e->sysobj) {
        bfmt(b, "#%u:ISystem", e->sys_tid);
        return true;
    }
    const WrapSlot *w = eng_wrap_slot(e, a);
    if (!w) return false;
    bfmt(b, "#%u:%s", w->trace_id, w->iface < CPU_IF_COUNT ? k_iface_names[w->iface] : "?");
    return true;
}

static uint32_t site_of(Engine *e, uint32_t ret) {
    uint32_t pref = ret - e->delta;
    static const uint32_t ns[3] = {2, 3, 6};
    for (int k = 0; k < 3; k++) {
        uint32_t s = pref - ns[k];
        uint32_t lo = 0, hi = eng_callsite_count;
        while (lo < hi) {
            uint32_t mid = (lo + hi) / 2;
            if (eng_callsites[mid] < s) lo = mid + 1;
            else hi = mid;
        }
        if (lo < eng_callsite_count && eng_callsites[lo] == s) return s;
    }
    return pref; /* not a listed call site (the mock stops there) */
}

static void str_arg(Engine *e, Buf *b, uint32_t a, int32_t len) {
    uint8_t tmp[1024];
    uint32_t n = 0;
    if (len < 0) {
        int32_t l = cpu_strnlen(e->cpu, a, sizeof tmp);
        n = l < 0 ? 0 : (uint32_t)l;
    } else {
        n = (uint32_t)len < sizeof tmp ? (uint32_t)len : sizeof tmp;
    }
    if (n) cpu_mem_read(e->cpu, a, tmp, n);
    py_repr(b, tmp, n);
}

void eng_trace_call(Engine *e, uint32_t iface, uint32_t slot, uint32_t self, uint32_t args, uint32_t ret,
                    char *line, uint32_t cap, bool pending) {
    Buf b = {line, 0, cap};
    line[0] = 0;
    const MethodInfo *mi = method_info(iface, slot);
    uint32_t site = site_of(e, cpu_rd32(e->cpu, args - 4u));
    bfmt(&b, "%08x ", site);
    if (!obj_repr(e, &b, self)) bfmt(&b, "?%#x", self);
    bfmt(&b, "+%#x %s(", slot * 4u, mi ? mi->name : "UNMODELLED");
    const char *sig = mi ? mi->sig : "";
    uint32_t n = (uint32_t)rt_strlen(sig);
    for (uint32_t i = 0; i < n; i++) {
        uint32_t v = cpu_rd32(e->cpu, args + 4u * i);
        if (i) bstr(&b, ", ");
        switch (sig[i]) {
        case 'i': bfmt(&b, "%d", (int32_t)v); break;
        case 'b': bfmt(&b, "%u", v & 0xffu); break;
        case 's':
            if (v) str_arg(e, &b, v, -1);
            else bstr(&b, "NULL");
            break;
        case 'n': {
            uint32_t len = cpu_rd32(e->cpu, args + 4u * (i + 1u));
            if (v && len < 0x10000u) str_arg(e, &b, v, (int32_t)len);
            else bstr(&b, "ptr");
            break;
        }
        case 'o':
            if (!obj_repr(e, &b, v)) {
                if (v == 0) bstr(&b, "NULL");
                else bfmt(&b, "?%#x", v);
            }
            break;
        case 'c': bfmt(&b, "code:%08x", v - e->delta); break;
        default: bstr(&b, v ? "ptr" : "NULL"); break;
        }
    }
    bstr(&b, ")");
    if (!pending) eng_trace_finish_line(e, line, ret);
}

void eng_trace_finish_line(Engine *e, char *line, uint32_t ret) {
    uint32_t n = (uint32_t)rt_strlen(line);
    Buf b = {line, n, 600};
    bstr(&b, " = ");
    if (!obj_repr(e, &b, ret)) bfmt(&b, "%d", (int32_t)ret);
    trace_line(&e->p->trace, line, b.n);
}

/* run.py game_state: gameplay state digest after a tick (Moeboid.gam:0x10002a80, 0x10001f50, 0x100011a0). */
static void game_state(Engine *e, char *out, uint32_t cap) {
    Cpu *c = e->cpu;
    out[0] = 0;
    uint32_t game = cpu_rd32(c, 0x1000f5d8u + e->delta);
    uint32_t st = game ? cpu_rd32(c, game) : 0;
    if (!st || cpu_rd32(c, st) != 0x1000d158u + e->delta) return;
    uint32_t pl = cpu_rd32(c, st + 0xc), n = cpu_rd32(c, st + 0x1a0);
    RtSha256 h;
    rt_sha256_init(&h);
    for (uint32_t i = 0; i < n; i++) {
        uint32_t bp = cpu_rd32(c, st + 0x10 + 4 * i);
        if (!bp) continue;
        uint8_t rec[0x38];
        cpu_mem_read(c, bp, rec, sizeof rec);
        for (int off = 4; off <= 8; off += 4) {
            bool any = rec[off] || rec[off + 1] || rec[off + 2] || rec[off + 3];
            rec[off] = any ? 1 : 0;
            rec[off + 1] = rec[off + 2] = rec[off + 3] = 0;
        }
        rec[0x26] = rec[0x27] = rec[0x31] = rec[0x32] = rec[0x33] = 0;
        rt_sha256_update(&h, rec, sizeof rec);
    }
    uint8_t d[32];
    char hx[13];
    rt_sha256_final(&h, d);
    rt_sha256_hex(d, hx, 12);
    rt_snprintf(out, cap, "lvl=%u x=%08x y=%08x vx=%08x vy=%08x score=%u lives=%d baddies=%u bh=%s", cpu_rd32(c, pl),
                cpu_rd32(c, pl + 0x10), cpu_rd32(c, pl + 0x14), cpu_rd32(c, pl + 0x18), cpu_rd32(c, pl + 0x1c),
                cpu_rd32(c, st + 8), (int32_t)cpu_rd32(c, st + 0x1a4), n, hx);
}

void eng_trace_begin(Engine *e, const char *what) {
    trace_begin_tick(&e->p->trace, core_ticks(e->p), what);
    e->tick_open = true;
}

void eng_trace_end(Engine *e) {
    if (!e->tick_open) return;
    e->tick_open = false;
    if (!trace_on(&e->p->trace)) {
        trace_end_tick(&e->p->trace, NULL);
        return;
    }
    char st[200];
    game_state(e, st, sizeof st);
    trace_end_tick(&e->p->trace, st);
}
