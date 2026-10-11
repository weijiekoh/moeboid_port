/* i386 + x87 interpreter that runs the original Moeboid.gam (milestone M2).
 * Contract: docs/port-design.md sections 4 (guest memory map) and 5 (CPU and engine bridge).
 *
 * Guest memory is a separate 32-bit address space (regions of host memory, one 64 KiB chunk
 * table). The engine reads and writes guest memory only through cpu_mem_* (or a host pointer
 * from cpu_mem_ptr, valid until the region is unmapped; regions are never moved).
 *
 * Typical engine use (M4):
 *   Cpu *c = cpu_create();
 *   cpu_machine_init(c, gam, gam_len, CPU_IMAGE_BASE, 0x00, 0x027f);   maps the section 4 regions
 *   cpu_set_engine_dispatch(c, my_dispatch, my_ctx);
 *   vtable slot k of interface i = cpu_engine_thunk(i, k)                 (guest address)
 *   cpu_call(c, cpu_machine_entry(c), 3, (uint32_t[]){base, 1, 0}, NULL)  DllMain
 *   cpu_call_cdecl(c, cpu_machine_export(c, "Shell_StartApplet"), 1, &ctx)
 * Every call returns EAX; on a fault the call returns 0 and cpu_fault(c)->kind != CPU_FAULT_NONE
 * (the fault stays set until the next cpu_clear_fault or top-level call). */
#ifndef MOEBOID_CPU_H
#define MOEBOID_CPU_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

/* ---- guest memory map (port-design.md section 4, equal to analysis/verification/harness/emu.py) ---- */
#define CPU_GDT_ADDR 0x00010000u
#define CPU_TEB_ADDR 0x00020000u
#define CPU_STACK_LO 0x00100000u
#define CPU_STACK_SIZE 0x00100000u
#define CPU_HEAP_LO 0x02000000u
#define CPU_HEAP_SIZE 0x02000000u
#define CPU_VA_LO 0x04000000u
#define CPU_VA_SIZE 0x02000000u
#define CPU_IMAGE_BASE 0x10000000u
#define CPU_FAKE_LO 0x60000000u
#define CPU_FAKE_SIZE 0x01000000u
#define CPU_STUB_LO 0x7f000000u
#define CPU_STUB_SIZE 0x00100000u
#define CPU_DATA_LO 0x7f100000u
#define CPU_DATA_SIZE 0x00100000u
/* Return address pushed by cpu_call: the run loop stops when EIP reaches it (emu.py SENTINEL). */
#define CPU_SENTINEL (CPU_STUB_LO + CPU_STUB_SIZE - 0x10u)
/* Engine method thunks: CPU_ENGINE_THUNK_LO + (iface * CPU_ENGINE_SLOTS + slot) * 4.
 * KERNEL32 import thunks: CPU_STUB_LO + 4 * import_index (same order as emu.py). */
#define CPU_ENGINE_THUNK_LO 0x7f080000u
#define CPU_ENGINE_SLOTS 64u

typedef struct Cpu Cpu;

/* General registers (x86 encoding order). */
enum { CPU_EAX = 0, CPU_ECX, CPU_EDX, CPU_EBX, CPU_ESP, CPU_EBP, CPU_ESI, CPU_EDI };
/* Segment registers (x86 encoding order). */
enum { CPU_ES = 0, CPU_CS, CPU_SS, CPU_DS, CPU_FS, CPU_GS };

/* EFLAGS bits that the interpreter keeps. */
#define CPU_FLAG_CF 0x001u
#define CPU_FLAG_PF 0x004u
#define CPU_FLAG_AF 0x010u
#define CPU_FLAG_ZF 0x040u
#define CPU_FLAG_SF 0x080u
#define CPU_FLAG_DF 0x400u
#define CPU_FLAG_OF 0x800u

/* Engine interfaces (analysis/interface.tsv; ids are this module's numbering). */
enum {
    CPU_IF_ISHELL = 0,
    CPU_IF_IFACTORY,
    CPU_IF_ISYSTEM,
    CPU_IF_ISETTINGS,
    CPU_IF_ISURFACE,
    CPU_IF_IBUTTON,
    CPU_IF_IANIM,
    CPU_IF_IIMAGESEQ,
    CPU_IF_IIMAGE,
    CPU_IF_IFONT,
    CPU_IF_ITIMER,
    CPU_IF_ISOUND,
    CPU_IF_ILISTENER,
    CPU_IF_COUNT
};

/* ---- run results and faults ---- */
typedef enum CpuRunResult {
    CPU_RUN_UNTIL = 0, /* EIP reached the stop address */
    CPU_RUN_COUNT = 1, /* instruction limit reached */
    CPU_RUN_STOPPED = 2, /* cpu_stop() (from a hook or a bridge callback) */
    CPU_RUN_FAULT = 3, /* see cpu_fault() */
    CPU_RUN_SUSPENDED = 4 /* cpu_suspend() from engine_dispatch (modal engine call, M4) */
} CpuRunResult;

typedef enum CpuFaultKind {
    CPU_FAULT_NONE = 0,
    CPU_FAULT_READ_UNMAPPED,
    CPU_FAULT_WRITE_UNMAPPED,
    CPU_FAULT_FETCH_UNMAPPED,
    CPU_FAULT_INVALID_OPCODE, /* opcode outside the implemented set */
    CPU_FAULT_DIVIDE, /* #DE: DIV/IDIV by zero or quotient overflow; EIP = the instruction */
    CPU_FAULT_INT, /* INT3, HLT, #MF from WAIT */
    CPU_FAULT_FSIN_TABLE, /* FSIN/FCOS argument not in the x87 table */
    CPU_FAULT_THUNK, /* call into an unassigned thunk or an unknown engine method */
    CPU_FAULT_K32, /* KERNEL32 stub refused (ExitProcess, unimplemented import, ...) */
    CPU_FAULT_HOST /* host-side error (out of memory, bad argument, nested depth) */
} CpuFaultKind;

typedef struct CpuFault {
    uint32_t kind; /* CpuFaultKind */
    uint32_t eip; /* address of the faulting instruction */
    uint32_t addr; /* memory address for *_UNMAPPED */
    uint32_t size;
    char text[200];
} CpuFault;

/* ---- life cycle ---- */
Cpu *cpu_create(void);
void cpu_destroy(Cpu *c);

/* ---- guest memory ---- */
/* Map [addr, addr+size), 4 KiB aligned, zero-filled. Returns 0, or -1 (overlap, alignment, memory). */
int cpu_mem_map(Cpu *c, uint32_t addr, uint32_t size);
/* Host pointer for [addr, addr+len) if the range lies in one region, else NULL. */
uint8_t *cpu_mem_ptr(Cpu *c, uint32_t addr, uint32_t len);
bool cpu_mem_read(Cpu *c, uint32_t addr, void *dst, uint32_t len);
bool cpu_mem_write(Cpu *c, uint32_t addr, const void *src, uint32_t len);
bool cpu_mem_fill(Cpu *c, uint32_t addr, uint8_t byte, uint32_t len);
bool cpu_mem_mapped(Cpu *c, uint32_t addr, uint32_t len);
uint32_t cpu_rd32(Cpu *c, uint32_t addr); /* 0 if unmapped */
void cpu_wr32(Cpu *c, uint32_t addr, uint32_t v); /* ignored if unmapped */
/* Length of the NUL-terminated string at addr (at most max); -1 if it runs into unmapped memory. */
int32_t cpu_strnlen(Cpu *c, uint32_t addr, uint32_t max);

/* ---- registers ---- */
uint32_t cpu_get_reg(const Cpu *c, int r);
void cpu_set_reg(Cpu *c, int r, uint32_t v);
uint32_t cpu_get_eip(const Cpu *c);
void cpu_set_eip(Cpu *c, uint32_t v);
uint32_t cpu_get_eflags(const Cpu *c);
void cpu_set_eflags(Cpu *c, uint32_t v);
uint16_t cpu_get_seg(const Cpu *c, int s);
/* Load a segment selector: base from the GDT in guest memory (cpu_set_gdtr first); 0 ok. */
int cpu_set_seg(Cpu *c, int s, uint16_t sel);
void cpu_set_seg_base(Cpu *c, int s, uint32_t base);
void cpu_set_gdtr(Cpu *c, uint32_t base, uint32_t limit);

/* x87 state. Registers are physical (index 0..7, ST(i) = phys[(top + i) & 7]).
 * Values in 80-bit form: mantissa (explicit integer bit) and sign/exponent word, as Unicorn's
 * UC_X86_REG_FP0..7. A register holds a double; it also holds the exact 80-bit value when that
 * value is not a double (FLD m80, FILD m64 above 2^53, FSIN/FCOS table results). */
void cpu_fpu_get_reg(const Cpu *c, int phys, uint64_t *mant, uint16_t *se);
void cpu_fpu_set_reg(Cpu *c, int phys, uint64_t mant, uint16_t se);
double cpu_fpu_get_double(const Cpu *c, int phys);
uint16_t cpu_fpu_get_cw(const Cpu *c);
void cpu_fpu_set_cw(Cpu *c, uint16_t cw);
uint16_t cpu_fpu_get_sw(const Cpu *c); /* with TOP in bits 11..13 */
void cpu_fpu_set_sw(Cpu *c, uint16_t sw);
/* Tag word as Unicorn reads it: 3 empty, 1 zero, 2 special (NaN, inf, denormal), 0 valid. */
uint16_t cpu_fpu_get_tag(const Cpu *c);
/* Only empty (3) or not empty matters for a write. */
void cpu_fpu_set_tag(Cpu *c, uint16_t tag);

/* ---- execution ---- */
/* EIP = begin, run until EIP == until, max_insn instructions (0 = no limit), cpu_stop or a fault. */
CpuRunResult cpu_run(Cpu *c, uint32_t begin, uint32_t until, uint64_t max_insn);
void cpu_stop(Cpu *c);
const CpuFault *cpu_fault(const Cpu *c);
void cpu_clear_fault(Cpu *c);
uint64_t cpu_insn_count(const Cpu *c); /* instructions executed since cpu_create */
/* Length in bytes of the instruction at addr, from its bytes (0 if unknown or unmapped). */
uint32_t cpu_insn_len(Cpu *c, uint32_t addr);

/* ---- hooks (tests, Python shim; the engine does not need them) ----
 * Code hook: before the instruction at addr in [begin, end] executes (size = instruction length).
 * A hook may change registers, EIP (the loop then restarts at the new EIP) or call cpu_stop
 * (the instruction does not execute). Block hook: at the start of each translation block that starts
 * in [begin, end], with the block size of QEMU/Unicorn (up to and including the first jump, call,
 * return or REP string instruction). Read/write hooks: before each guest data access whose start
 * address is in [begin, end] (instruction semantics only, not cpu_mem_*). begin > end means all
 * addresses. */
typedef void (*CpuCodeHookFn)(void *user, uint32_t addr, uint32_t size);
typedef void (*CpuMemHookFn)(void *user, uint32_t addr, uint32_t size);
enum { CPU_HOOK_CODE = 1, CPU_HOOK_BLOCK = 2, CPU_HOOK_MEM_READ = 3, CPU_HOOK_MEM_WRITE = 4 };
int cpu_hook_add(Cpu *c, int type, void *fn, void *user, uint32_t begin, uint32_t end);
void cpu_hook_del(Cpu *c, int id);

/* ---- FSIN/FCOS table (decisions.md item 11: replaceable). Argument and results in 80-bit form.
 * Default table: fsin_table.h, generated from analysis/verification/fpu/x87_fsin_table.tsv. ---- */
typedef struct CpuFsinEntry {
    uint64_t arg_m, sin_m, cos_m;
    uint16_t arg_se, sin_se, cos_se;
} CpuFsinEntry;
/* Entries must be sorted by argument value (ascending). The table is not copied. */
void cpu_set_fsin_table(Cpu *c, const CpuFsinEntry *t, uint32_t n);

/* ---- machine: PE image, emu.py-equal environment, KERNEL32, engine bridge ---- */
/* Map the regions of section 4, write GDT and TEB, set FS/DS/ES/SS, ESP, FPCW, load the PE image at
 * base (relocated if base != preferred), point every import at its thunk, enable the thunk bridge.
 * fill: initial byte of the stack and of HeapAlloc blocks without HEAP_ZERO_MEMORY (emu.py fill).
 * Call once on a fresh Cpu (regions are never unmapped). Host memory: about 84 MiB from rt_calloc.
 * Returns 0 or -1 (cpu_fault() has the reason). */
int cpu_machine_init(Cpu *c, const uint8_t *pe, uint32_t pe_len, uint32_t base, uint8_t fill, uint16_t fpcw);
uint32_t cpu_machine_entry(const Cpu *c);
uint32_t cpu_machine_export(const Cpu *c, const char *name); /* 0 if absent */
uint32_t cpu_machine_base(const Cpu *c);
uint32_t cpu_machine_image_size(const Cpu *c);
uint32_t cpu_machine_reloc_count(const Cpu *c);
uint32_t cpu_machine_heap_next(const Cpu *c);
uint32_t cpu_machine_data_next(const Cpu *c);
/* Bump allocation in the engine-owned data region (0x7f100000, 1 MiB, no free), 16-byte aligned like
 * emu.py alloc_data; src may be NULL (block stays zero). Returns the guest address or 0 (full). */
uint32_t cpu_machine_alloc_data(Cpu *c, const void *src, uint32_t len, uint32_t align);
/* Resource lookup like emu.py: type and name are integer ids or upper-case strings.
 * Returns the IMAGE_RESOURCE_DATA_ENTRY address (HRSRC) and sets *data, *size, or returns 0. */
uint32_t cpu_machine_find_resource(Cpu *c, uint32_t type_id, const char *type_name, uint32_t name_id,
                                   const char *name_name, uint32_t *data, uint32_t *size);
/* Number of KERNEL32 imports, their names and call counts (diagnostics). */
uint32_t cpu_machine_import_count(const Cpu *c);
const char *cpu_machine_import_name(const Cpu *c, uint32_t i);
uint32_t cpu_machine_import_calls(const Cpu *c, uint32_t i);

/* Engine dispatch: called when the guest executes an engine thunk.
 * iface = CPU_IF_*, slot = vtable byte offset / 4, this_guest = ECX, args_guest = address of the
 * first stack argument (ESP + 4 at the thunk). Returns EAX. The bridge then pops the return address
 * and 4 * argc bytes (argc from analysis/interface.tsv, cpu_engine_argc) and resumes at the return
 * address. Like the stub return of emu.py, the bridge also copies the return address over the last
 * stack argument (dead memory below the new ESP; keeps guest memory equal to the reference harness).
 * The callback may call cpu_call_cdecl (nested guest calls) and cpu_stop / cpu_raise. */
typedef uint32_t (*CpuEngineDispatch)(void *ctx, uint32_t iface, uint32_t slot, uint32_t this_guest,
                                      uint32_t args_guest);
void cpu_set_engine_dispatch(Cpu *c, CpuEngineDispatch fn, void *ctx);
uint32_t cpu_engine_thunk(uint32_t iface, uint32_t slot);
/* Stack argument count of (iface, slot) per interface.tsv; -1 if the game never calls it. */
int cpu_engine_argc(uint32_t iface, uint32_t slot);
/* Override or add an argc entry (engine-specific methods); argc -1: the method faults when called. */
void cpu_engine_set_argc(Cpu *c, uint32_t iface, uint32_t slot, int argc);

/* Call guest code: push args right to left and CPU_SENTINEL, ECX = *ecx if ecx != NULL, run until
 * the sentinel (cdecl, stdcall and thiscall: ESP is restored afterwards). Nested calls are allowed.
 * Returns EAX, or 0 with cpu_fault() set. Checks that EBX, ESI, EDI, EBP are preserved (fault
 * CPU_FAULT_HOST otherwise, like emu.py Machine.call). */
uint32_t cpu_call(Cpu *c, uint32_t func, uint32_t nargs, const uint32_t *args, const uint32_t *ecx);
uint32_t cpu_call_cdecl(Cpu *c, uint32_t func, uint32_t nargs, const uint32_t *args);
/* Maximum instructions per top-level cpu_call (default 200000000, emu.py max_insn). */
void cpu_set_call_limit(Cpu *c, uint64_t max_insn);
/* Set a fault from engine code (for example inside engine_dispatch) and stop the run. */
void cpu_raise(Cpu *c, uint32_t kind, const char *text);

/* ---- suspend and resume (M4: modal ISystem::MessageBox / InputBox) ----
 * cpu_suspend, called inside engine_dispatch: the thunk returns as usual (EAX = the dispatch value,
 * replaced by cpu_resume), then the run stops and the top-level cpu_call returns 0 with
 * cpu_suspended() true. The guest stack and registers stay as they are. Only a top-level call can
 * suspend (nesting depth 1); a suspend inside a nested guest call faults (CPU_FAULT_HOST).
 * cpu_resume sets EAX and continues the suspended call to its end; it returns like cpu_call
 * (EAX, or 0 with a fault), and it can suspend again. No other guest call may run while a call is
 * suspended (the engine guarantees it). */
void cpu_suspend(Cpu *c);
bool cpu_suspended(const Cpu *c);
uint32_t cpu_resume(Cpu *c, uint32_t eax);

#endif
