/* Settings and high-score store (M1). See storage.h. */
#include "storage.h"

static char *dup_n(const char *p, uint32_t n) {
    char *d = (char *)rt_malloc(n + 1u);
    if (!d) return NULL;
    rt_memcpy(d, p, n);
    d[n] = 0;
    return d;
}

static bool key_ok(const char *k) {
    size_t n = rt_strlen(k);
    if (n == 0 || n > 255) return false;
    for (size_t i = 0; i < n; i++)
        if ((uint8_t)k[i] < 0x20u || k[i] == '=') return false;
    return true;
}

static int32_t find(const Storage *s, const char *key) {
    for (uint32_t i = 0; i < s->count; i++)
        if (rt_strcmp(s->e[i].key, key) == 0) return (int32_t)i;
    return -1;
}

static void invalidate(Storage *s) {
    s->blob_valid = false;
}

void storage_clear(Storage *s) {
    for (uint32_t i = 0; i < s->count; i++) {
        rt_free(s->e[i].key);
        rt_free(s->e[i].value);
    }
    rt_free(s->e);
    rt_free(s->blob);
    rt_memset(s, 0, sizeof *s);
}

const char *storage_get(const Storage *s, const char *key) {
    int32_t i = find(s, key);
    return i < 0 ? NULL : s->e[i].value;
}

static bool append(Storage *s, char *k, char *v) {
    if (s->count >= s->cap) {
        uint32_t cap = s->cap ? s->cap * 2u : 16u;
        StorageEntry *e = (StorageEntry *)rt_realloc(s->e, cap * sizeof *e);
        if (!e) return false;
        s->e = e;
        s->cap = cap;
    }
    s->e[s->count].key = k;
    s->e[s->count].value = v;
    s->count++;
    return true;
}

bool storage_set(Storage *s, const char *key, const char *value) {
    if (!key_ok(key) || !value) return false;
    int32_t i = find(s, key);
    if (i >= 0 && rt_strcmp(s->e[i].value, value) == 0) return true;
    char *v = dup_n(value, (uint32_t)rt_strlen(value));
    if (!v) return false;
    if (i >= 0) {
        rt_free(s->e[i].value);
        s->e[i].value = v;
    } else {
        char *k = dup_n(key, (uint32_t)rt_strlen(key));
        if (!k || !append(s, k, v)) {
            rt_free(k);
            rt_free(v);
            return false;
        }
    }
    s->changed = true;
    invalidate(s);
    return true;
}

bool storage_remove(Storage *s, const char *key) {
    int32_t i = find(s, key);
    if (i < 0) return false;
    rt_free(s->e[i].key);
    rt_free(s->e[i].value);
    for (uint32_t j = (uint32_t)i + 1u; j < s->count; j++) s->e[j - 1] = s->e[j];
    s->count--;
    s->changed = true;
    invalidate(s);
    return true;
}

const char *storage_blob(Storage *s, uint32_t *len) {
    if (!s->blob_valid) {
        uint32_t hl = (uint32_t)rt_strlen(STORAGE_HEADER), n = hl;
        for (uint32_t i = 0; i < s->count; i++) {
            n += (uint32_t)rt_strlen(s->e[i].key) + 2u; /* '=' and '\n' */
            for (const char *p = s->e[i].value; *p; p++) n += (*p == '\\' || *p == '\n' || *p == '\r') ? 2u : 1u;
        }
        char *b = (char *)rt_realloc(s->blob, n + 1u);
        if (!b) rt_panic("storage_blob: out of memory");
        s->blob = b;
        rt_memcpy(b, STORAGE_HEADER, hl);
        uint32_t o = hl;
        for (uint32_t i = 0; i < s->count; i++) {
            uint32_t kl = (uint32_t)rt_strlen(s->e[i].key);
            rt_memcpy(b + o, s->e[i].key, kl);
            o += kl;
            b[o++] = '=';
            for (const char *p = s->e[i].value; *p; p++) {
                if (*p == '\\') b[o++] = '\\', b[o++] = '\\';
                else if (*p == '\n') b[o++] = '\\', b[o++] = 'n';
                else if (*p == '\r') b[o++] = '\\', b[o++] = 'r';
                else b[o++] = *p;
            }
            b[o++] = '\n';
        }
        b[o] = 0;
        s->blob_len = o;
        s->blob_valid = true;
    }
    *len = s->blob_len;
    return s->blob;
}

int32_t storage_load(Storage *s, const uint8_t *data, uint32_t len) {
    bool changed = s->changed;
    storage_clear(s);
    s->changed = changed;
    if (len == 0) return 0;
    uint32_t hl = (uint32_t)rt_strlen(STORAGE_HEADER);
    if (len < hl || rt_memcmp(data, STORAGE_HEADER, hl) != 0) return -1;
    int32_t bad = 0;
    uint32_t i = hl;
    while (i < len) {
        uint32_t e = i;
        while (e < len && data[e] != '\n') e++;
        uint32_t eq = i;
        while (eq < e && data[eq] != '=') eq++;
        bool ok = eq < e && eq > i;
        char *k = NULL, *v = NULL;
        if (ok) {
            k = dup_n((const char *)data + i, eq - i);
            v = (char *)rt_malloc(e - eq);
            if (!k || !v) rt_panic("storage_load: out of memory");
            uint32_t o = 0;
            for (uint32_t p = eq + 1u; p < e; p++) {
                uint8_t c = data[p];
                if (c == 0) {
                    ok = false;
                    break;
                }
                if (c == '\\' && p + 1u < e) {
                    uint8_t x = data[++p];
                    c = x == 'n' ? '\n' : x == 'r' ? '\r' : x;
                }
                v[o++] = (char)c;
            }
            v[o] = 0;
            ok = ok && key_ok(k) && find(s, k) < 0;
        }
        if (ok && append(s, k, v)) {
            /* stored */
        } else {
            rt_free(k);
            rt_free(v);
            bad++;
        }
        i = e + 1u;
    }
    invalidate(s);
    return bad;
}
