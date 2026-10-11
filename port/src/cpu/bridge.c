/* Thunk bridge between the guest and the host (M2), docs/port-design.md section 5.
 * Executing an address in the thunk region (CPU_STUB_LO.., 1 MiB) with the bridge on does not
 * fetch code: a KERNEL32 thunk runs its stub in k32.c, an engine thunk calls engine_dispatch. The
 * bridge then pops the return address and the stack arguments (callee cleanup: stdcall KERNEL32,
 * __thiscall engine methods with 4 * argc), sets EAX and resumes at the return address.
 * Like the stub return of analysis/verification/harness/emu.py (_on_stub: the return address is
 * copied over the last argument slot, then a RET pops it), the bridge writes the return address into
 * the last argument slot, so the guest stack bytes equal the reference harness byte for byte. The
 * slot is below the new ESP (dead memory; the scribble checks show that the game never reads it). */
#include "cpu_int.h"

uint32_t k32_nargs(int stub);

/* (interface, vtable slot, argc) of every engine method the game calls: analysis/interface.tsv
 * (54 rows; argc = column argc, callee pop = 4 * argc verified there for every row). */
static const struct {
    uint8_t iface, slot, argc;
} k_argc[] = {
    {0, 2, 0}, {1, 2, 2}, {1, 3, 2}, {1, 4, 3}, {1, 5, 1}, {1, 8, 3}, {1, 10, 3}, {1, 12, 10}, {1, 13, 3},
    {1, 16, 2}, {1, 17, 4}, {2, 2, 1}, {2, 3, 1}, {2, 4, 1}, {2, 5, 3}, {2, 6, 6}, {2, 8, 1}, {3, 4, 2},
    {3, 5, 2}, {4, 1, 0}, {4, 2, 3}, {4, 3, 2}, {4, 4, 2}, {4, 6, 1}, {4, 7, 1}, {4, 11, 0}, {4, 13, 0},
    {4, 15, 1}, {4, 17, 1}, {4, 18, 2}, {5, 1, 0}, {6, 1, 0}, {6, 4, 1}, {7, 1, 0}, {7, 4, 2}, {8, 1, 0},
    {8, 3, 4}, {8, 4, 4}, {8, 6, 4}, {8, 7, 3}, {8, 9, 3}, {8, 13, 3}, {8, 16, 3}, {8, 18, 1}, {8, 19, 1},
    {8, 20, 2}, {8, 22, 4}, {9, 1, 0}, {9, 3, 4}, {10, 1, 0}, {10, 2, 0}, {11, 1, 0}, {11, 2, 1}, {12, 1, 0},
};

int cpu_engine_argc(uint32_t iface, uint32_t slot) {
    for (uint32_t i = 0; i < RT_COUNTOF(k_argc); i++)
        if (k_argc[i].iface == iface && k_argc[i].slot == slot) return k_argc[i].argc;
    return -1;
}

void cpu_engine_set_argc(Cpu *c, uint32_t iface, uint32_t slot, int argc) {
    if (iface < CPU_IF_COUNT && slot < CPU_ENGINE_SLOTS) c->m.argc_ovr[iface][slot] = (int8_t)(argc < 0 ? -1 : argc);
}

uint32_t cpu_engine_thunk(uint32_t iface, uint32_t slot) {
    return CPU_ENGINE_THUNK_LO + (iface * CPU_ENGINE_SLOTS + slot) * 4u;
}

void cpu_set_engine_dispatch(Cpu *c, CpuEngineDispatch fn, void *ctx) {
    c->m.dispatch = fn;
    c->m.dctx = ctx;
}

void cpu_set_call_limit(Cpu *c, uint64_t max_insn) { c->m.call_limit = max_insn; }

void cpu_thunk(Cpu *c, uint32_t eip) {
    CpuMachine *m = &c->m;
    uint32_t esp = c->r[CPU_ESP];
    uint32_t ret = (uint32_t)rdm(c, esp, 4);
    if (FAULTED(c)) return;
    uint32_t idx = (eip - CPU_STUB_LO) >> 2;
    if ((eip & 3u) == 0 && idx < m->nimp) {
        CpuImport *im = &m->imp[idx];
        im->calls++;
        if (im->k32 < 0) {
            cpu_set_fault(c, CPU_FAULT_K32, eip, 0, "unimplemented import KERNEL32.dll!%s called from %08x", im->name, ret);
            return;
        }
        uint32_t n = k32_nargs(im->k32), args[8] = {0};
        for (uint32_t i = 0; i < n; i++) {
            args[i] = (uint32_t)rdm(c, esp + 4u + 4u * i, 4);
            if (FAULTED(c)) return;
        }
        uint32_t eax = k32_call(c, im->k32, args, n);
        if (FAULTED(c)) {
            c->fault.eip = ret;
            return;
        }
        if (n) wrm(c, esp + 4u * n, 4, ret); /* emu.py stub return: see the file comment */
        c->r[CPU_EAX] = eax;
        c->r[CPU_ESP] = esp + 4u + 4u * n;
        c->eip = ret;
        return;
    }
    uint32_t e = eip - CPU_ENGINE_THUNK_LO;
    if ((eip & 3u) == 0 && e < CPU_IF_COUNT * CPU_ENGINE_SLOTS * 4u) {
        uint32_t iface = (e >> 2) / CPU_ENGINE_SLOTS, slot = (e >> 2) % CPU_ENGINE_SLOTS;
        int argc = m->argc_ovr[iface][slot];
        if (argc == -2) argc = cpu_engine_argc(iface, slot);
        if (argc < 0 || !m->dispatch) {
            cpu_set_fault(c, CPU_FAULT_THUNK, eip, 0, "engine method iface %u offset %#x called from %08x: %s", iface,
                          slot * 4u, ret, m->dispatch ? "no argc entry" : "no engine dispatch");
            return;
        }
        uint32_t eax = m->dispatch(m->dctx, iface, slot, c->r[CPU_ECX], esp + 4u);
        if (FAULTED(c)) return;
        if (argc) wrm(c, esp + 4u * (uint32_t)argc, 4, ret);
        c->r[CPU_EAX] = eax;
        c->r[CPU_ESP] = esp + 4u + 4u * (uint32_t)argc;
        c->eip = ret;
        return;
    }
    cpu_set_fault(c, CPU_FAULT_THUNK, eip, 0, "jump into unassigned thunk address %08x (return address %08x)", eip, ret);
}

uint32_t cpu_call(Cpu *c, uint32_t func, uint32_t nargs, const uint32_t *args, const uint32_t *ecx) {
    CpuMachine *m = &c->m;
    if (m->depth == 0) {
        cpu_clear_fault(c);
        c->stop_req = 0;
    }
    if (m->depth >= CPU_MAX_DEPTH) {
        cpu_set_fault(c, CPU_FAULT_HOST, 0, 0, "guest call nesting deeper than %d", CPU_MAX_DEPTH);
        return 0;
    }
    uint32_t esp0 = c->r[CPU_ESP], saved[4] = {c->r[CPU_EBX], c->r[CPU_ESI], c->r[CPU_EDI], c->r[CPU_EBP]};
    uint32_t sp = esp0;
    for (uint32_t i = nargs; i-- > 0;) {
        sp -= 4;
        wrm(c, sp, 4, args[i]);
    }
    sp -= 4;
    wrm(c, sp, 4, CPU_SENTINEL);
    if (FAULTED(c)) return 0;
    c->r[CPU_ESP] = sp;
    if (ecx) c->r[CPU_ECX] = *ecx;
    m->depth++;
    CpuRunResult r = cpu_run(c, func, CPU_SENTINEL, m->call_limit);
    m->depth--;
    if (r != CPU_RUN_UNTIL) {
        if (!FAULTED(c))
            cpu_set_fault(c, CPU_FAULT_HOST, 0, 0, "guest call %08x did not return (eip=%08x, %s)", func, c->eip,
                          r == CPU_RUN_COUNT ? "instruction limit" : "stopped");
        return 0;
    }
    uint32_t now[4] = {c->r[CPU_EBX], c->r[CPU_ESI], c->r[CPU_EDI], c->r[CPU_EBP]};
    for (int i = 0; i < 4; i++)
        if (now[i] != saved[i]) {
            cpu_set_fault(c, CPU_FAULT_HOST, 0, 0, "callee-saved register changed in call %08x", func);
            return 0;
        }
    c->r[CPU_ESP] = esp0;
    return c->r[CPU_EAX];
}

uint32_t cpu_call_cdecl(Cpu *c, uint32_t func, uint32_t nargs, const uint32_t *args) {
    return cpu_call(c, func, nargs, args, NULL);
}
