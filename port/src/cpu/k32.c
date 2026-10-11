/* KERNEL32 stubs (M2). Same behaviour, return values and deterministic addresses as the stubs of
 * analysis/verification/harness/emu.py (WIN32_STUBS): bump heap at CPU_HEAP_LO with 16-byte
 * rounding, VirtualAlloc arena with 64 KiB rounding, strings in the engine data region, resource
 * functions on the PE resource index. The guest gets no file, network or OS access.
 * Differences (not reachable by Moeboid.gam, they stop with CPU_FAULT_K32 instead): UTF-16 code
 * units >= 0x100 in GetStringTypeW and LCMapStringW. */
#include "cpu_int.h"
#include "k32_tables.h"

#define HEAP_ZERO_MEMORY 0x8u
#define ERROR_RESOURCE_NAME_NOT_FOUND 1814u

typedef uint32_t (*K32Fn)(Cpu *c, const uint32_t *a);

static uint32_t stop(Cpu *c, const char *msg) {
    cpu_set_fault(c, CPU_FAULT_K32, 0, 0, "%s", msg);
    return 0;
}

static bool rd(Cpu *c, uint32_t a, void *dst, uint32_t n) {
    if (cpu_mem_read(c, a, dst, n)) return true;
    cpu_set_fault(c, CPU_FAULT_K32, a, n, "KERNEL32 stub: read of %u bytes at %08x unmapped", n, a);
    return false;
}
static bool wr(Cpu *c, uint32_t a, const void *src, uint32_t n) {
    if (cpu_mem_write(c, a, src, n)) return true;
    cpu_set_fault(c, CPU_FAULT_K32, a, n, "KERNEL32 stub: write of %u bytes at %08x unmapped", n, a);
    return false;
}
static bool w16(Cpu *c, uint32_t a, uint16_t v) { return wr(c, a, &v, 2); }

/* emu.py Machine.cstr: up to maxlen bytes without the NUL; -1 on unmapped memory. */
static int32_t cstr_len(Cpu *c, uint32_t a, uint32_t maxlen) {
    for (uint32_t i = 0; i < maxlen; i++) {
        uint8_t b;
        if (!rd(c, a + i, &b, 1)) return -1;
        if (b == 0) return (int32_t)i;
    }
    return (int32_t)maxlen;
}

/* ---- heap: live block sizes in an open-addressing table (emu.py heap_sizes) ---- */
static uint32_t hs_slot(const CpuMachine *m, uint32_t key) {
    uint32_t h = (key >> 4) * 2654435761u;
    return h & (m->hs_cap - 1u);
}
static bool hs_grow(CpuMachine *m) {
    uint32_t ncap = m->hs_cap ? m->hs_cap * 2u : 1024u;
    uint32_t *nk = (uint32_t *)rt_calloc(ncap, 4), *nv = (uint32_t *)rt_calloc(ncap, 4);
    if (!nk || !nv) {
        rt_free(nk);
        rt_free(nv);
        return false;
    }
    uint32_t ocap = m->hs_cap, *ok = m->hs_key, *ov = m->hs_val;
    m->hs_key = nk;
    m->hs_val = nv;
    m->hs_cap = ncap;
    m->hs_n = 0;
    for (uint32_t i = 0; i < ocap; i++) {
        if (ok[i] == 0 || ok[i] == 1u) continue; /* 0 empty, 1 deleted */
        uint32_t s = hs_slot(m, ok[i]);
        while (nk[s]) s = (s + 1u) & (ncap - 1u);
        nk[s] = ok[i];
        nv[s] = ov[i];
        m->hs_n++;
    }
    rt_free(ok);
    rt_free(ov);
    return true;
}
static uint32_t *hs_find(CpuMachine *m, uint32_t key) {
    if (!m->hs_cap) return NULL;
    for (uint32_t s = hs_slot(m, key), k = 0; k < m->hs_cap; k++, s = (s + 1u) & (m->hs_cap - 1u)) {
        if (m->hs_key[s] == 0) return NULL;
        if (m->hs_key[s] == key) return &m->hs_val[s];
    }
    return NULL;
}
static bool hs_put(CpuMachine *m, uint32_t key, uint32_t size) {
    uint32_t *v = hs_find(m, key);
    if (v) {
        *v = size;
        return true;
    }
    if ((m->hs_n + 1u) * 2u > m->hs_cap && !hs_grow(m)) return false;
    if (!m->hs_key || !m->hs_val) return false;
    uint32_t s = hs_slot(m, key);
    while (m->hs_key[s] > 1u) s = (s + 1u) & (m->hs_cap - 1u);
    m->hs_key[s] = key;
    m->hs_val[s] = size;
    m->hs_n++;
    return true;
}
static void hs_del(CpuMachine *m, uint32_t key) {
    if (!m->hs_cap) return;
    for (uint32_t s = hs_slot(m, key), k = 0; k < m->hs_cap; k++, s = (s + 1u) & (m->hs_cap - 1u)) {
        if (m->hs_key[s] == 0) return;
        if (m->hs_key[s] == key) {
            m->hs_key[s] = 1u; /* tombstone */
            return;
        }
    }
}

static uint32_t heap_alloc(Cpu *c, uint32_t size, bool zero) {
    CpuMachine *m = &c->m;
    if (size == 0) size = 1;
    uint32_t a = m->heap_next;
    uint64_t n = ((uint64_t)size + 15u) & ~(uint64_t)15u;
    if (a + n > (uint64_t)CPU_HEAP_LO + CPU_HEAP_SIZE) return stop(c, "heap arena exhausted");
    m->heap_next = (uint32_t)(a + n);
    if (!hs_put(m, a, size)) return stop(c, "heap size table: out of memory");
    cpu_mem_fill(c, a, zero ? 0 : m->fill, (uint32_t)n);
    return a;
}

static uint32_t k_HeapAlloc(Cpu *c, const uint32_t *a) { return heap_alloc(c, a[2], (a[1] & HEAP_ZERO_MEMORY) != 0); }

static uint32_t k_HeapReAlloc(Cpu *c, const uint32_t *a) {
    uint32_t old = a[2], size = a[3];
    uint32_t nw = heap_alloc(c, size, (a[1] & HEAP_ZERO_MEMORY) != 0);
    if (FAULTED(c)) return 0;
    uint32_t *os = hs_find(&c->m, old);
    if (os) {
        uint32_t n = *os < size ? *os : size;
        for (uint32_t i = 0; i < n; i++) {
            uint8_t b;
            if (!rd(c, old + i, &b, 1) || !wr(c, nw + i, &b, 1)) return 0;
        }
    }
    return nw;
}

static uint32_t k_HeapFree(Cpu *c, const uint32_t *a) {
    hs_del(&c->m, a[2]);
    return 1;
}

static uint32_t k_VirtualAlloc(Cpu *c, const uint32_t *a) {
    CpuMachine *m = &c->m;
    uint32_t addr = a[0];
    if (addr == 0) {
        addr = m->va_next;
        uint64_t nx = ((uint64_t)addr + a[1] + 0xffffu) & ~(uint64_t)0xffffu;
        if (nx > (uint64_t)CPU_VA_LO + CPU_VA_SIZE) return stop(c, "VirtualAlloc arena exhausted");
        m->va_next = (uint32_t)nx;
    }
    return addr; /* arena is mapped and zero-filled from the start */
}

static uint32_t k_GetCommandLineA(Cpu *c, const uint32_t *a) {
    (void)a;
    static const char s[] = "\"C:\\ZapSpot\\ZapSpot.exe\"";
    if (!c->m.cmdline) c->m.cmdline = cpu_machine_alloc_data(c, s, sizeof s, 16);
    return c->m.cmdline;
}

static uint32_t k_GetEnvironmentStrings(Cpu *c, const uint32_t *a) {
    (void)a;
    static const char s[] = "PATH=C:\\WINDOWS\0"; /* + the array NUL: "PATH=C:\WINDOWS\0\0" */
    if (!c->m.envstr) c->m.envstr = cpu_machine_alloc_data(c, s, sizeof s, 16);
    return c->m.envstr;
}

static uint32_t k_GetModuleFileNameA(Cpu *c, const uint32_t *a) {
    static const char name[] = "C:\\ZapSpot\\Moeboid.gam";
    int64_t len = (int64_t)sizeof name - 1, n = (int64_t)a[2] - 1;
    if (n > len) n = len;
    int64_t k = n >= 0 ? n : len + n; /* Python name[:n] with a negative n */
    if (k < 0) k = 0;
    char buf[sizeof name + 1];
    rt_memcpy(buf, name, (size_t)k);
    buf[k] = 0;
    wr(c, a[1], buf, (uint32_t)k + 1u);
    return (uint32_t)n;
}

static uint32_t k_GetStartupInfoA(Cpu *c, const uint32_t *a) {
    uint8_t b[68] = {68};
    wr(c, a[0], b, sizeof b);
    return 0;
}

static uint32_t k_GetCPInfo(Cpu *c, const uint32_t *a) {
    uint8_t b[18] = {1, 0, 0, 0, '?', 0};
    wr(c, a[1], b, sizeof b);
    return 1;
}

static uint32_t k_MultiByteToWideChar(Cpu *c, const uint32_t *a) {
    uint32_t src = a[2], srclen = a[3], dst = a[4], dstlen = a[5], n;
    if (srclen == 0xffffffffu) {
        int32_t l = cstr_len(c, src, 4096);
        if (l < 0) return 0;
        n = (uint32_t)l + 1u; /* emu.py: cstr(src) + b"\0" (the NUL is appended, also at maxlen) */
    } else {
        n = srclen;
    }
    if (dstlen == 0) return n;
    uint32_t k = n < dstlen ? n : dstlen;
    for (uint32_t i = 0; i < k; i++) {
        uint8_t b = 0;
        if (!(srclen == 0xffffffffu && i == n - 1u) && !rd(c, src + i, &b, 1)) return 0;
        if (!w16(c, dst + 2 * i, b)) return 0;
    }
    return k;
}

static uint32_t k_WideCharToMultiByte(Cpu *c, const uint32_t *a) {
    uint32_t src = a[2], srclen = a[3], dst = a[4], dstlen = a[5];
    uint32_t units;
    if (srclen == 0xffffffffu) {
        for (units = 0;; units++) {
            uint16_t w;
            if (!rd(c, src + 2 * units, &w, 2)) return 0;
            if (w == 0) {
                units++;
                break;
            }
        }
    } else {
        units = srclen;
    }
    /* decode UTF-16 (a lone surrogate makes Python raise: stop), encode latin-1 with '?' */
    uint32_t out = 0;
    for (uint32_t i = 0; i < units; i++) {
        uint16_t w;
        if (!rd(c, src + 2 * i, &w, 2)) return 0;
        uint8_t ch;
        if (w >= 0xd800 && w <= 0xdbff) {
            uint16_t w2 = 0;
            if (i + 1 >= units || !rd(c, src + 2 * (i + 1), &w2, 2) || w2 < 0xdc00 || w2 > 0xdfff)
                return stop(c, "WideCharToMultiByte: invalid UTF-16 (stub error in emu.py)");
            i++;
            ch = '?';
        } else if (w >= 0xdc00 && w <= 0xdfff) {
            return stop(c, "WideCharToMultiByte: invalid UTF-16 (stub error in emu.py)");
        } else {
            ch = w < 256 ? (uint8_t)w : (uint8_t)'?';
        }
        if (dstlen != 0 && out < dstlen && !wr(c, dst + out, &ch, 1)) return 0;
        out++;
    }
    if (dstlen == 0) return out;
    return out < dstlen ? out : dstlen;
}

static uint32_t k_GetStringTypeW(Cpu *c, const uint32_t *a) {
    uint32_t src = a[1], n = a[2], out = a[3];
    if (n == 0xffffffffu) {
        for (n = 0;; n++) {
            uint16_t w;
            if (!rd(c, src + 2 * n, &w, 2)) return 0;
            if (w == 0) break;
        }
        n++;
    }
    for (uint32_t i = 0; i < n; i++) {
        uint16_t w;
        if (!rd(c, src + 2 * i, &w, 2)) return 0;
        if (w >= 256) return stop(c, "GetStringTypeW: code unit >= 0x100 not modelled");
        if (!w16(c, out + 2 * i, k_ctype1[w])) return 0;
    }
    return 1;
}

static uint32_t k_GetStringTypeA(Cpu *c, const uint32_t *a) {
    uint32_t src = a[2], n = a[3], out = a[4];
    if (n == 0xffffffffu) {
        int32_t l = cstr_len(c, src, 4096);
        if (l < 0) return 0;
        n = (uint32_t)l + 1u;
    }
    for (uint32_t i = 0; i < n; i++) {
        uint8_t b;
        if (!rd(c, src + i, &b, 1)) return 0;
        if (!w16(c, out + 2 * i, k_ctype1[b])) return 0;
    }
    return 1;
}

static uint32_t k_LCMapStringA(Cpu *c, const uint32_t *a) {
    uint32_t flags = a[1], src = a[2], n = a[3], dst = a[4], dstn = a[5];
    bool nul = false;
    if (n == 0xffffffffu) {
        int32_t l = cstr_len(c, src, 4096);
        if (l < 0) return 0;
        n = (uint32_t)l + 1u;
        nul = true;
    }
    if (dstn == 0) return n;
    uint32_t k = n < dstn ? n : dstn;
    for (uint32_t i = 0; i < k; i++) {
        uint8_t b = 0;
        if (!(nul && i == n - 1u) && !rd(c, src + i, &b, 1)) return 0;
        if ((flags & 0x100u) && b >= 'A' && b <= 'Z') b = (uint8_t)(b + 32);
        else if (!(flags & 0x100u) && (flags & 0x200u) && b >= 'a' && b <= 'z') b = (uint8_t)(b - 32);
        if (!wr(c, dst + i, &b, 1)) return 0;
    }
    return k;
}

static uint32_t k_LCMapStringW(Cpu *c, const uint32_t *a) {
    uint32_t flags = a[1], src = a[2], n = a[3], dst = a[4], dstn = a[5];
    if (n == 0xffffffffu) {
        for (n = 0;; n++) {
            uint16_t w;
            if (!rd(c, src + 2 * n, &w, 2)) return 0;
            if (w == 0) break;
        }
        n++;
    }
    uint32_t out = 0; /* code units written (the mapped string may be longer than n: U+00DF) */
    for (uint32_t i = 0; i < n; i++) {
        uint16_t w;
        if (!rd(c, src + 2 * i, &w, 2)) return 0;
        if (w >= 256) return stop(c, "LCMapStringW: code unit >= 0x100 not modelled");
        uint16_t m[2] = {w, 0};
        uint32_t k = 1;
        if (flags & 0x100u) {
            m[0] = k_lower[w];
        } else if (flags & 0x200u) {
            if (w == 0xdf) {
                m[0] = m[1] = 'S';
                k = 2;
            } else {
                m[0] = k_upper[w];
            }
        }
        for (uint32_t j = 0; j < k; j++, out++)
            if (dstn != 0 && out < dstn && !w16(c, dst + 2 * out, m[j])) return 0;
    }
    if (dstn == 0) return n;
    return n < dstn ? n : dstn;
}

/* emu.py _res_key: id below 0x10000, else a string: "#123" is an id, other names upper case. */
static bool res_key(Cpu *c, uint32_t v, uint32_t *id, char *name, uint32_t cap, bool *is_name) {
    *is_name = false;
    if (v < 0x10000u) {
        *id = v;
        return true;
    }
    int32_t l = cstr_len(c, v, 4096);
    if (l < 0) return false;
    if ((uint32_t)l >= cap) l = (int32_t)cap - 1;
    rd(c, v, name, (uint32_t)l);
    name[l] = 0;
    if (name[0] == '#') {
        uint32_t x = 0;
        int i = 1;
        if (!name[1]) return stop(c, "FindResourceA: bad numeric name"), false;
        for (; name[i]; i++) {
            if (name[i] < '0' || name[i] > '9') return stop(c, "FindResourceA: bad numeric name"), false;
            x = x * 10u + (uint32_t)(name[i] - '0');
        }
        *id = x;
        return true;
    }
    for (int i = 0; name[i]; i++)
        if (name[i] >= 'a' && name[i] <= 'z') name[i] = (char)(name[i] - 32);
    *is_name = true;
    return true;
}

static uint32_t k_FindResourceA(Cpu *c, const uint32_t *a) {
    uint32_t tid = 0, nid = 0;
    char tn[64], nn[64];
    bool tis, nis;
    if (!res_key(c, a[2], &tid, tn, sizeof tn, &tis) || !res_key(c, a[1], &nid, nn, sizeof nn, &nis)) return 0;
    uint32_t e = cpu_machine_find_resource(c, tid, tis ? tn : NULL, nid, nis ? nn : NULL, NULL, NULL);
    if (!e) c->m.last_error = ERROR_RESOURCE_NAME_NOT_FOUND;
    return e;
}

static const CpuRes *res_by_entry(Cpu *c, uint32_t h) {
    for (uint32_t i = 0; i < c->m.nres; i++)
        if (c->m.res[i].entry == h) return &c->m.res[i];
    stop(c, "unknown HRSRC");
    return NULL;
}
static uint32_t k_LoadResource(Cpu *c, const uint32_t *a) {
    if (!a[1]) return 0;
    const CpuRes *r = res_by_entry(c, a[1]);
    return r ? r->data : 0;
}
static uint32_t k_SizeofResource(Cpu *c, const uint32_t *a) {
    if (!a[1]) return 0;
    const CpuRes *r = res_by_entry(c, a[1]);
    return r ? r->size : 0;
}

static uint32_t k_CreateFileA(Cpu *c, const uint32_t *a) {
    if (cstr_len(c, a[0], 4096) < 0) return 0;
    c->m.last_error = 2;
    return 0xffffffffu; /* denied (emu.py policy) */
}

static uint32_t k_WriteFile(Cpu *c, const uint32_t *a) {
    if (a[2] && !cpu_mem_mapped(c, a[1], a[2])) return stop(c, "WriteFile: buffer unmapped");
    if (a[3]) wr(c, a[3], &a[2], 4);
    return 1;
}

static uint32_t k_exit(Cpu *c, const uint32_t *a) {
    cpu_set_fault(c, CPU_FAULT_K32, 0, 0, "process exit requested (code %#x)", a[0]);
    return 0;
}

static uint32_t k_GetLastError(Cpu *c, const uint32_t *a) {
    (void)a;
    return c->m.last_error;
}
static uint32_t k_SetHandleCount(Cpu *c, const uint32_t *a) {
    (void)c;
    return a[0];
}
static uint32_t k_LockResource(Cpu *c, const uint32_t *a) {
    (void)c;
    return a[0];
}

#define K_CONST(name, v) \
    static uint32_t name(Cpu *c, const uint32_t *a) { \
        (void)c; \
        (void)a; \
        return v; \
    }
K_CONST(k_ret0, 0u)
K_CONST(k_ret1, 1u)
K_CONST(k_retm1, 0xffffffffu)
K_CONST(k_GetVersion, 0x0a280105u) /* Windows XP 5.1 build 2600 */
K_CONST(k_HeapCreate, 0x00a10000u)
K_CONST(k_GetACP, 1252u)
K_CONST(k_GetOEMCP, 437u)

static const struct {
    const char *name;
    uint32_t nargs;
    K32Fn fn; /* NULL: unimplemented, stops the run (emu.py: fn None) */
} K32[] = {
    {"GetVersion", 0, k_GetVersion},
    {"HeapCreate", 3, k_HeapCreate},
    {"HeapDestroy", 1, k_ret1},
    {"HeapAlloc", 3, k_HeapAlloc},
    {"HeapFree", 3, k_HeapFree},
    {"HeapReAlloc", 4, k_HeapReAlloc},
    {"VirtualAlloc", 4, k_VirtualAlloc},
    {"VirtualFree", 3, k_ret1},
    {"GetCommandLineA", 0, k_GetCommandLineA},
    {"GetEnvironmentStrings", 0, k_GetEnvironmentStrings},
    {"GetEnvironmentStringsW", 0, k_ret0},
    {"FreeEnvironmentStringsA", 1, k_ret1},
    {"FreeEnvironmentStringsW", 1, k_ret1},
    {"GetModuleFileNameA", 3, k_GetModuleFileNameA},
    {"GetModuleHandleA", 1, k_ret0},
    {"GetProcAddress", 2, k_ret0},
    {"LoadLibraryA", 1, k_ret0},
    {"GetStartupInfoA", 1, k_GetStartupInfoA},
    {"GetStdHandle", 1, k_retm1},
    {"GetFileType", 1, k_ret0},
    {"SetHandleCount", 1, k_SetHandleCount},
    {"SetStdHandle", 2, k_ret1},
    {"GetACP", 0, k_GetACP},
    {"GetOEMCP", 0, k_GetOEMCP},
    {"GetCPInfo", 2, k_GetCPInfo},
    {"MultiByteToWideChar", 6, k_MultiByteToWideChar},
    {"WideCharToMultiByte", 8, k_WideCharToMultiByte},
    {"GetStringTypeA", 5, k_GetStringTypeA},
    {"GetStringTypeW", 4, k_GetStringTypeW},
    {"LCMapStringA", 6, k_LCMapStringA},
    {"LCMapStringW", 6, k_LCMapStringW},
    {"GetLastError", 0, k_GetLastError},
    {"GetCurrentProcess", 0, k_retm1},
    {"IsBadReadPtr", 2, k_ret0},
    {"IsBadWritePtr", 2, k_ret0},
    {"IsBadCodePtr", 1, k_ret0},
    {"SetUnhandledExceptionFilter", 1, k_ret0},
    {"UnhandledExceptionFilter", 1, k_ret0},
    {"SetConsoleCtrlHandler", 2, k_ret1},
    {"FindResourceA", 3, k_FindResourceA},
    {"LoadResource", 2, k_LoadResource},
    {"LockResource", 1, k_LockResource},
    {"SizeofResource", 2, k_SizeofResource},
    {"CreateFileA", 7, k_CreateFileA},
    {"ReadFile", 5, k_ret0},
    {"WriteFile", 5, k_WriteFile},
    {"GetFileSize", 2, k_retm1},
    {"SetFilePointer", 4, k_retm1},
    {"FlushFileBuffers", 1, k_ret1},
    {"CloseHandle", 1, k_ret1},
    {"ExitProcess", 1, k_exit},
    {"TerminateProcess", 2, k_exit},
    {"RtlUnwind", 4, NULL},
};

int k32_lookup(const char *name, uint32_t *nargs) {
    for (uint32_t i = 0; i < RT_COUNTOF(K32); i++)
        if (rt_strcmp(K32[i].name, name) == 0) {
            *nargs = K32[i].nargs;
            return K32[i].fn ? (int)i : -1;
        }
    *nargs = 0;
    return -1;
}

uint32_t k32_nargs(int stub) { return K32[stub].nargs; }

uint32_t k32_call(Cpu *c, int stub, const uint32_t *args, uint32_t nargs) {
    (void)nargs;
    return K32[stub].fn(c, args);
}
