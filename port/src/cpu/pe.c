/* PE loader and machine set-up (M2). Equal to analysis/verification/harness/emu.py Machine:
 * same regions (port-design.md section 4), GDT/TEB, flat DS/ES/SS, FS = TEB, stack top, x87 control
 * word, image at its base with HIGHLOW relocations, one thunk per import (CPU_STUB_LO + 4 * i in
 * import-directory order), exports, resource index (type, name) -> (entry, data, size). */
#include "cpu_int.h"

static uint32_t le16(const uint8_t *p) { return (uint32_t)p[0] | (uint32_t)p[1] << 8; }

/* Number of entries of an IMAGE_RESOURCE_DIRECTORY (named + id); 0 if unmapped. */
static uint32_t res_count(Cpu *c, uint32_t dir) {
    uint16_t n[2] = {0, 0};
    if (!cpu_mem_read(c, dir + 12, n, 4)) return 0;
    return (uint32_t)n[0] + n[1];
}
static uint32_t le32(const uint8_t *p) { return le16(p) | le16(p + 2) << 16; }

static int fail(Cpu *c, const char *msg) {
    cpu_set_fault(c, CPU_FAULT_HOST, 0, 0, "PE load: %s", msg);
    return -1;
}

/* Read a guest byte string (image already loaded) into buf (NUL-terminated, at most n-1 chars). */
static void gstr(Cpu *c, uint32_t a, char *buf, uint32_t n) {
    uint32_t i = 0;
    for (; i + 1 < n; i++) {
        uint8_t b = 0;
        if (!cpu_mem_read(c, a + i, &b, 1) || b == 0) break;
        buf[i] = (char)b;
    }
    buf[i] = 0;
}

static void upper_ascii(char *s) {
    for (; *s; s++)
        if (*s >= 'a' && *s <= 'z') *s = (char)(*s - 32);
}

/* Resource directory name (IMAGE_RESOURCE_DIR_STRING_U): UTF-16 to latin-1, upper case (ASCII). */
static void res_name(Cpu *c, uint32_t a, char *buf, uint32_t n) {
    uint16_t len = 0;
    cpu_mem_read(c, a, &len, 2);
    uint32_t i = 0;
    for (; i < len && i + 1 < n; i++) {
        uint16_t w = 0;
        cpu_mem_read(c, a + 2 + 2 * i, &w, 2);
        buf[i] = w < 256 ? (char)w : '?';
    }
    buf[i] = 0;
    upper_ascii(buf);
}

static void index_resources(Cpu *c, uint32_t dir_rva) {
    CpuMachine *m = &c->m;
    uint32_t root = m->base + dir_rva;
    uint32_t cap = 0;
    for (int pass = 0; pass < 2; pass++) {
        uint32_t n = 0;
        uint32_t nt = res_count(c, root);
        for (uint32_t ti = 0; ti < nt; ti++) {
            uint32_t te = root + 16 + 8 * ti, tname = cpu_rd32(c, te), toff = cpu_rd32(c, te + 4);
            if (!(toff & 0x80000000u)) continue;
            uint32_t tdir = root + (toff & 0x7fffffffu);
            uint32_t nn = res_count(c, tdir);
            for (uint32_t ni = 0; ni < nn; ni++) {
                uint32_t ne = tdir + 16 + 8 * ni, nname = cpu_rd32(c, ne), noff = cpu_rd32(c, ne + 4);
                if (!(noff & 0x80000000u)) continue;
                uint32_t ndir = root + (noff & 0x7fffffffu);
                uint32_t nl = res_count(c, ndir);
                for (uint32_t li = 0; li < nl; li++) {
                    uint32_t le = ndir + 16 + 8 * li, loff = cpu_rd32(c, le + 4);
                    if (pass == 1) {
                        CpuRes *r = &m->res[n];
                        rt_memset(r, 0, sizeof *r);
                        r->type_id = (tname & 0x80000000u) ? 0xffffffffu : tname;
                        if (tname & 0x80000000u) res_name(c, root + (tname & 0x7fffffffu), r->type_name, sizeof r->type_name);
                        r->name_id = (nname & 0x80000000u) ? 0xffffffffu : nname;
                        if (nname & 0x80000000u) res_name(c, root + (nname & 0x7fffffffu), r->name_name, sizeof r->name_name);
                        r->entry = root + (loff & 0x7fffffffu);
                        r->data = m->base + cpu_rd32(c, r->entry);
                        r->size = cpu_rd32(c, r->entry + 4);
                    }
                    n++;
                }
            }
        }
        if (pass == 0) {
            cap = n;
            m->res = cap ? (CpuRes *)rt_calloc(cap, sizeof(CpuRes)) : NULL;
            if (cap && !m->res) return;
        } else {
            m->nres = n;
        }
    }
}

static int load_pe(Cpu *c, const uint8_t *pe, uint32_t len, uint32_t base) {
    CpuMachine *m = &c->m;
    if (len < 0x40 || pe[0] != 'M' || pe[1] != 'Z') return fail(c, "no MZ header");
    uint32_t nt = le32(pe + 0x3c);
    if ((uint64_t)nt + 24 + 96 > len || le32(pe + nt) != 0x00004550u) return fail(c, "no PE header");
    const uint8_t *coff = pe + nt + 4, *opt = coff + 20;
    uint32_t nsec = le16(coff + 2), optsize = le16(coff + 16);
    if (le16(opt) != 0x10b) return fail(c, "not PE32");
    uint32_t ndirs = le32(opt + 92);
    m->preferred = le32(opt + 28);
    m->base = base;
    uint32_t delta = base - m->preferred;
    m->image_size = (le32(opt + 56) + 0xfffu) & ~0xfffu;
    uint32_t hdrsize = le32(opt + 60);
    if (cpu_mem_map(c, base, m->image_size)) return fail(c, "cannot map the image");
    if (hdrsize > len) hdrsize = len;
    cpu_mem_write(c, base, pe, hdrsize < m->image_size ? hdrsize : m->image_size);
    const uint8_t *sec = opt + optsize;
    if ((uint64_t)(sec - pe) + 40ull * nsec > len) return fail(c, "section table truncated");
    for (uint32_t i = 0; i < nsec; i++) {
        const uint8_t *s = sec + 40 * i;
        uint32_t vs = le32(s + 8), va = le32(s + 12), raw = le32(s + 16), ptr = le32(s + 20);
        if (ptr > len) raw = 0;
        else if (raw > len - ptr) raw = len - ptr;
        uint32_t n = raw; /* emu.py writes data[:max(VirtualSize, len(data))] = all raw data */
        (void)vs;
        if ((uint64_t)va + n > m->image_size) return fail(c, "section outside the image");
        cpu_mem_write(c, base + va, pe + ptr, n);
    }
    uint32_t dir_rva[16] = {0}, dir_size[16] = {0};
    for (uint32_t i = 0; i < ndirs && i < 16; i++) {
        dir_rva[i] = le32(opt + 96 + 8 * i);
        dir_size[i] = le32(opt + 96 + 8 * i + 4);
    }
    /* base relocations: IMAGE_REL_BASED_HIGHLOW only (emu.py) */
    m->reloc_count = 0;
    if (delta && dir_rva[5]) {
        uint32_t p = base + dir_rva[5], end = p + dir_size[5];
        while (p + 8 <= end) {
            uint32_t page = cpu_rd32(c, p), bsize = cpu_rd32(c, p + 4);
            if (bsize < 8) break;
            for (uint32_t k = 8; k + 2 <= bsize; k += 2) {
                uint16_t e = 0;
                cpu_mem_read(c, p + k, &e, 2);
                uint32_t type = e >> 12u;
                if (type == 3) {
                    uint32_t a = base + page + (e & 0xfffu);
                    cpu_wr32(c, a, cpu_rd32(c, a) + delta);
                    m->reloc_count++;
                } else if (type != 0) {
                    return fail(c, "unsupported relocation type");
                }
            }
            p += bsize;
        }
    }
    /* imports: one thunk per import, in import-directory order */
    uint32_t nimp = 0;
    for (int pass = 0; pass < 2; pass++) {
        uint32_t n = 0;
        for (uint32_t d = base + dir_rva[1]; dir_rva[1]; d += 20) {
            uint32_t oft = cpu_rd32(c, d), name = cpu_rd32(c, d + 12), ft = cpu_rd32(c, d + 16);
            if (!oft && !name && !ft) break;
            uint32_t lt = oft ? oft : ft;
            for (uint32_t j = 0;; j++) {
                uint32_t t = cpu_rd32(c, base + lt + 4 * j);
                if (!t) break;
                if (pass == 1) {
                    CpuImport *im = &m->imp[n];
                    rt_memset(im, 0, sizeof *im);
                    if (t & 0x80000000u) rt_snprintf(im->name, sizeof im->name, "ord%u", t & 0xffffu);
                    else gstr(c, base + t + 2, im->name, sizeof im->name);
                    im->thunk = CPU_STUB_LO + 4u * n;
                    im->iat = base + ft + 4 * j;
                    uint32_t na;
                    im->k32 = k32_lookup(im->name, &na);
                    cpu_wr32(c, im->iat, im->thunk);
                }
                n++;
            }
        }
        if (pass == 0) {
            nimp = n;
            if (CPU_STUB_LO + 4u * nimp >= CPU_ENGINE_THUNK_LO) return fail(c, "too many imports");
            m->imp = nimp ? (CpuImport *)rt_calloc(nimp, sizeof(CpuImport)) : NULL;
            if (nimp && !m->imp) return fail(c, "out of memory");
        }
    }
    m->nimp = nimp;
    /* exports (named) */
    if (dir_rva[0]) {
        uint32_t e = base + dir_rva[0];
        uint32_t nfun = cpu_rd32(c, e + 20), nnames = cpu_rd32(c, e + 24);
        uint32_t afun = cpu_rd32(c, e + 28), anames = cpu_rd32(c, e + 32), aord = cpu_rd32(c, e + 36);
        m->exp = nnames ? (CpuExport *)rt_calloc(nnames, sizeof(CpuExport)) : NULL;
        for (uint32_t i = 0; i < nnames && m->exp; i++) {
            uint16_t ord = 0;
            cpu_mem_read(c, base + aord + 2 * i, &ord, 2);
            if (ord >= nfun) continue;
            CpuExport *x = &m->exp[m->nexp++];
            gstr(c, base + cpu_rd32(c, base + anames + 4 * i), x->name, sizeof x->name);
            x->addr = base + cpu_rd32(c, base + afun + 4 * ord);
        }
    }
    m->entry = base + le32(opt + 16);
    if (dir_rva[2]) index_resources(c, dir_rva[2]);
    return 0;
}

static void gdt_entry(uint8_t *p, uint32_t base, uint32_t limit, uint32_t access, uint32_t flags) {
    uint64_t v = limit & 0xffffu;
    v |= (uint64_t)(base & 0xffffffu) << 16;
    v |= (uint64_t)(access & 0xffu) << 40;
    v |= (uint64_t)((limit >> 16) & 0xfu) << 48;
    v |= (uint64_t)(flags & 0xfu) << 52;
    v |= (uint64_t)((base >> 24) & 0xffu) << 56;
    for (int i = 0; i < 8; i++) p[i] = (uint8_t)(v >> (8 * i));
}

int cpu_machine_init(Cpu *c, const uint8_t *pe, uint32_t pe_len, uint32_t base, uint8_t fill, uint16_t fpcw) {
    CpuMachine *m = &c->m;
    cpu_clear_fault(c);
    static const uint32_t regions[][2] = {
        {CPU_GDT_ADDR, 0x1000}, {CPU_TEB_ADDR, 0x1000}, {CPU_STACK_LO, CPU_STACK_SIZE}, {CPU_HEAP_LO, CPU_HEAP_SIZE},
        {CPU_VA_LO, CPU_VA_SIZE}, {CPU_FAKE_LO, CPU_FAKE_SIZE}, {CPU_STUB_LO, CPU_STUB_SIZE}, {CPU_DATA_LO, CPU_DATA_SIZE},
    };
    for (uint32_t i = 0; i < RT_COUNTOF(regions); i++)
        if (cpu_mem_map(c, regions[i][0], regions[i][1])) return fail(c, "cannot map a machine region");
    cpu_mem_fill(c, CPU_STACK_LO, fill, CPU_STACK_SIZE);
    cpu_mem_fill(c, CPU_STUB_LO, 0xc3, CPU_STUB_SIZE); /* every thunk address holds a RET (emu.py) */
    m->fill = fill;
    m->heap_next = CPU_HEAP_LO;
    m->va_next = CPU_VA_LO;
    m->data_next = CPU_DATA_LO;
    c->r[CPU_ESP] = CPU_STACK_LO + CPU_STACK_SIZE - 0x100u;
    /* TEB: SEH chain end, stack base and limit, self, client id (emu.py _setup_fs) */
    cpu_wr32(c, CPU_TEB_ADDR + 0x00, 0xffffffffu);
    cpu_wr32(c, CPU_TEB_ADDR + 0x04, CPU_STACK_LO + CPU_STACK_SIZE);
    cpu_wr32(c, CPU_TEB_ADDR + 0x08, CPU_STACK_LO);
    cpu_wr32(c, CPU_TEB_ADDR + 0x18, CPU_TEB_ADDR);
    cpu_wr32(c, CPU_TEB_ADDR + 0x20, 0x1000);
    cpu_wr32(c, CPU_TEB_ADDR + 0x24, 0x1004);
    uint8_t gdt[32] = {0};
    gdt_entry(gdt + 8, 0, 0xfffff, 0x9b, 0xc);
    gdt_entry(gdt + 16, 0, 0xfffff, 0x93, 0xc);
    gdt_entry(gdt + 24, CPU_TEB_ADDR, 0xfff, 0x93, 0x4);
    cpu_mem_write(c, CPU_GDT_ADDR, gdt, sizeof gdt);
    cpu_set_gdtr(c, CPU_GDT_ADDR, sizeof gdt - 1);
    cpu_set_seg(c, CPU_DS, 2 << 3);
    cpu_set_seg(c, CPU_ES, 2 << 3);
    cpu_set_seg(c, CPU_SS, 2 << 3);
    cpu_set_seg(c, CPU_FS, 3 << 3);
    c->fcw = fpcw;
    if (load_pe(c, pe, pe_len, base)) return -1;
    m->on = true;
    return 0;
}

void cpu_machine_free(Cpu *c) {
    CpuMachine *m = &c->m;
    rt_free(m->imp);
    rt_free(m->exp);
    rt_free(m->res);
    rt_free(m->hs_key);
    rt_free(m->hs_val);
    m->imp = NULL;
    m->exp = NULL;
    m->res = NULL;
    m->hs_key = m->hs_val = NULL;
}

uint32_t cpu_machine_entry(const Cpu *c) { return c->m.entry; }
uint32_t cpu_machine_base(const Cpu *c) { return c->m.base; }
uint32_t cpu_machine_image_size(const Cpu *c) { return c->m.image_size; }
uint32_t cpu_machine_reloc_count(const Cpu *c) { return c->m.reloc_count; }
uint32_t cpu_machine_heap_next(const Cpu *c) { return c->m.heap_next; }
uint32_t cpu_machine_data_next(const Cpu *c) { return c->m.data_next; }
uint32_t cpu_machine_import_count(const Cpu *c) { return c->m.nimp; }
const char *cpu_machine_import_name(const Cpu *c, uint32_t i) { return i < c->m.nimp ? c->m.imp[i].name : ""; }
uint32_t cpu_machine_import_calls(const Cpu *c, uint32_t i) { return i < c->m.nimp ? c->m.imp[i].calls : 0; }

uint32_t cpu_machine_export(const Cpu *c, const char *name) {
    for (uint32_t i = 0; i < c->m.nexp; i++)
        if (rt_strcmp(c->m.exp[i].name, name) == 0) return c->m.exp[i].addr;
    return 0;
}

uint32_t cpu_machine_alloc_data(Cpu *c, const void *src, uint32_t len, uint32_t align) {
    CpuMachine *m = &c->m;
    uint32_t a = m->data_next;
    if (align == 0) align = 16;
    if ((uint64_t)a + len > CPU_DATA_LO + CPU_DATA_SIZE) {
        cpu_set_fault(c, CPU_FAULT_HOST, a, len, "engine data region full");
        return 0;
    }
    if (src) cpu_mem_write(c, a, src, len);
    m->data_next = (uint32_t)(((uint64_t)a + len + align - 1u) & ~(uint64_t)(align - 1u));
    return a;
}

uint32_t cpu_machine_find_resource(Cpu *c, uint32_t type_id, const char *type_name, uint32_t name_id,
                                   const char *name_name, uint32_t *data, uint32_t *size) {
    /* later entries win, like the emu.py dictionary */
    for (uint32_t i = c->m.nres; i-- > 0;) {
        const CpuRes *r = &c->m.res[i];
        bool t = type_name ? (r->type_id == 0xffffffffu && rt_strcmp(r->type_name, type_name) == 0) : r->type_id == type_id;
        bool n = name_name ? (r->name_id == 0xffffffffu && rt_strcmp(r->name_name, name_name) == 0) : r->name_id == name_id;
        if (t && n) {
            if (data) *data = r->data;
            if (size) *size = r->size;
            return r->entry;
        }
    }
    return 0;
}
