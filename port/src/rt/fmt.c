/* printf-lite for logs and trace lines (M1). No floating point. */
#include "rt.h"

typedef struct Out {
    char *buf;
    size_t cap; /* bytes available for characters (n - 1) */
    size_t len; /* characters produced so far (may exceed cap) */
} Out;

static void put(Out *o, char c) {
    if (o->len < o->cap) o->buf[o->len] = c;
    o->len++;
}

static void put_rep(Out *o, char c, int n) {
    for (; n > 0; n--) put(o, c);
}

enum { F_LEFT = 1, F_ZERO = 2, F_PLUS = 4, F_SPACE = 8, F_ALT = 16 };

static void put_num(Out *o, uint64_t v, bool neg, unsigned base, bool upper, int flags, int width, int prec,
                    const char *prefix) {
    char tmp[24];
    int n = 0;
    const char *digits = upper ? "0123456789ABCDEF" : "0123456789abcdef";
    if (!(prec == 0 && v == 0)) {
        do {
            tmp[n++] = digits[v % base];
            v /= base;
        } while (v);
    }
    char sign = neg ? '-' : (flags & F_PLUS) ? '+' : (flags & F_SPACE) ? ' ' : 0;
    int plen = prefix ? (int)rt_strlen(prefix) : 0;
    int zeros = prec > n ? prec - n : 0;
    int body = n + zeros + plen + (sign ? 1 : 0);
    int pad = width > body ? width - body : 0;
    if ((flags & F_ZERO) && !(flags & F_LEFT) && prec < 0) {
        zeros += pad;
        pad = 0;
    }
    if (!(flags & F_LEFT)) put_rep(o, ' ', pad);
    if (sign) put(o, sign);
    for (int i = 0; i < plen; i++) put(o, prefix[i]);
    put_rep(o, '0', zeros);
    while (n) put(o, tmp[--n]);
    if (flags & F_LEFT) put_rep(o, ' ', pad);
}

int rt_vsnprintf(char *buf, size_t n, const char *fmt, rt_va_list ap) {
    Out o = {buf, n ? n - 1 : 0, 0};
    for (const char *p = fmt; *p; p++) {
        if (*p != '%') {
            put(&o, *p);
            continue;
        }
        const char *spec = p++;
        int flags = 0, width = 0, prec = -1;
        for (;; p++) {
            if (*p == '-') flags |= F_LEFT;
            else if (*p == '0') flags |= F_ZERO;
            else if (*p == '+') flags |= F_PLUS;
            else if (*p == ' ') flags |= F_SPACE;
            else if (*p == '#') flags |= F_ALT;
            else break;
        }
        if (*p == '*') {
            width = rt_va_arg(ap, int);
            if (width < 0) {
                flags |= F_LEFT;
                width = -width;
            }
            p++;
        } else
            while (*p >= '0' && *p <= '9') width = width * 10 + (*p++ - '0');
        if (*p == '.') {
            p++;
            prec = 0;
            if (*p == '*') {
                prec = rt_va_arg(ap, int);
                if (prec < 0) prec = -1;
                p++;
            } else
                while (*p >= '0' && *p <= '9') prec = prec * 10 + (*p++ - '0');
        }
        int lng = 0; /* -2 hh, -1 h, 0 int, 1 l, 2 ll, 3 size_t/ptrdiff/intmax */
        if (*p == 'h') {
            lng = -1;
            if (*++p == 'h') lng = -2, p++;
        } else if (*p == 'l') {
            lng = 1;
            if (*++p == 'l') lng = 2, p++;
        } else if (*p == 'z' || *p == 't') {
            lng = 3;
            p++;
        } else if (*p == 'j') {
            lng = 2;
            p++;
        }
        char c = *p;
        switch (c) {
        case 'd':
        case 'i': {
            int64_t v;
            if (lng == 2) v = rt_va_arg(ap, long long);
            else if (lng == 1) v = rt_va_arg(ap, long);
            else if (lng == 3) v = (int64_t)rt_va_arg(ap, ptrdiff_t);
            else {
                v = rt_va_arg(ap, int);
                if (lng == -1) v = (int16_t)v;
                if (lng == -2) v = (int8_t)v;
            }
            uint64_t u = v < 0 ? (uint64_t)0 - (uint64_t)v : (uint64_t)v;
            put_num(&o, u, v < 0, 10, false, flags, width, prec, NULL);
            break;
        }
        case 'u':
        case 'x':
        case 'X':
        case 'o': {
            uint64_t v;
            if (lng == 2) v = rt_va_arg(ap, unsigned long long);
            else if (lng == 1) v = rt_va_arg(ap, unsigned long);
            else if (lng == 3) v = rt_va_arg(ap, size_t);
            else {
                v = rt_va_arg(ap, unsigned int);
                if (lng == -1) v = (uint16_t)v;
                if (lng == -2) v = (uint8_t)v;
            }
            unsigned base = c == 'u' ? 10 : c == 'o' ? 8 : 16;
            const char *prefix = NULL;
            if ((flags & F_ALT) && v) prefix = c == 'x' ? "0x" : c == 'X' ? "0X" : c == 'o' ? "0" : NULL;
            put_num(&o, v, false, base, c == 'X', flags & ~(F_PLUS | F_SPACE), width, prec, prefix);
            break;
        }
        case 'p': {
            uintptr_t v = (uintptr_t)rt_va_arg(ap, void *);
            put_num(&o, v, false, 16, false, flags & F_LEFT, width, -1, "0x");
            break;
        }
        case 'c': {
            char ch = (char)rt_va_arg(ap, int);
            if (!(flags & F_LEFT)) put_rep(&o, ' ', width - 1);
            put(&o, ch);
            if (flags & F_LEFT) put_rep(&o, ' ', width - 1);
            break;
        }
        case 's': {
            const char *s = rt_va_arg(ap, const char *);
            if (!s) s = "(null)";
            int len = 0;
            while (s[len] && (prec < 0 || len < prec)) len++;
            if (!(flags & F_LEFT)) put_rep(&o, ' ', width - len);
            for (int i = 0; i < len; i++) put(&o, s[i]);
            if (flags & F_LEFT) put_rep(&o, ' ', width - len);
            break;
        }
        case '%':
            put(&o, '%');
            break;
        default: /* unknown conversion: copy it as text */
            for (const char *q = spec; q <= p && *q; q++) put(&o, *q);
            if (!*p) p--;
            break;
        }
    }
    if (n) buf[o.len < o.cap ? o.len : o.cap] = 0;
    return (int)o.len;
}

int rt_snprintf(char *buf, size_t n, const char *fmt, ...) {
    rt_va_list ap;
    rt_va_start(ap, fmt);
    int r = rt_vsnprintf(buf, n, fmt, ap);
    rt_va_end(ap);
    return r;
}
