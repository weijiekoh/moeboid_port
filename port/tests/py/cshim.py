"""Unicorn-compatible shim over the C interpreter (port/build/libmoeboid.so, ctypes).

Implements the Unicorn 2 API subset that analysis/verification/harness/{emu,mock,run,checks}.py
and the M2 tests use, so the harness runs unchanged on the C CPU (decisions.md O3):
  Uc(UC_ARCH_X86, UC_MODE_32), mem_map, mem_read, mem_write, reg_read, reg_write (general,
  8/16-bit parts, EIP, EFLAGS, segment registers with GDT descriptor load, GDTR, FPCW, FPSW,
  FPTAG, FP0..FP7 as (mantissa, sign_exponent)), hook_add/hook_del for UC_HOOK_CODE,
  UC_HOOK_BLOCK, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE (value argument 0) and the
  UC_HOOK_MEM_*_UNMAPPED / UC_HOOK_MEM_INVALID family,
  emu_start(begin, until, timeout, count), emu_stop, UcError (errno, Unicorn message text).
Differences from Unicorn (documented, not used by the harness):
  - mem_map: one region per 64 KiB chunk; regions never unmapped; permissions ignored.
  - UC_HOOK_INTR and other hook types raise UcError(UC_ERR_HOOK).
  - The invalid-memory hooks run after the faulting instruction stopped the run; their return
    value is ignored (the run never resumes).
  - Code hooks always see the instruction length; block hooks see the QEMU translation-block size
    computed by the interpreter (same coverage numbers as Unicorn in run.py --coverage).
  - Hook exceptions: stored, the run stops, emu_start re-raises them (Unicorn 2.1 binding rule).
  - Faults without a Unicorn equivalent (FSIN/FCOS argument outside the x87 table) raise
    UcError(UC_ERR_EXCEPTION); Uc.fault_text() returns the interpreter's description.

Use: `import cshim; cshim.install()` before `import unicorn` puts the shim in sys.modules as
`unicorn`, `unicorn.x86_const` and `unicorn.unicorn_const`.
"""
import ctypes
import os
import sys
import types

LIB_DEFAULT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "build", "libmoeboid.so")

# ---------------------------------------------------------------------- constants (Unicorn 2.1.4)
UC_ARCH_X86 = 4
UC_MODE_32 = 4
UC_PROT_NONE, UC_PROT_READ, UC_PROT_WRITE, UC_PROT_EXEC, UC_PROT_ALL = 0, 1, 2, 4, 7
UC_HOOK_INTR = 1
UC_HOOK_INSN = 2
UC_HOOK_CODE = 4
UC_HOOK_BLOCK = 8
UC_HOOK_MEM_READ_UNMAPPED = 16
UC_HOOK_MEM_WRITE_UNMAPPED = 32
UC_HOOK_MEM_FETCH_UNMAPPED = 64
UC_HOOK_MEM_READ_PROT = 128
UC_HOOK_MEM_WRITE_PROT = 256
UC_HOOK_MEM_FETCH_PROT = 512
UC_HOOK_MEM_READ = 1024
UC_HOOK_MEM_WRITE = 2048
UC_HOOK_MEM_FETCH = 4096
UC_HOOK_MEM_UNMAPPED = 112
UC_HOOK_MEM_PROT = 896
UC_HOOK_MEM_INVALID = 1008
UC_MEM_READ, UC_MEM_WRITE, UC_MEM_FETCH = 16, 17, 18
UC_MEM_READ_UNMAPPED, UC_MEM_WRITE_UNMAPPED, UC_MEM_FETCH_UNMAPPED = 19, 20, 21
UC_ERR_OK = 0
UC_ERR_READ_UNMAPPED = 6
UC_ERR_WRITE_UNMAPPED = 7
UC_ERR_FETCH_UNMAPPED = 8
UC_ERR_HOOK = 9
UC_ERR_INSN_INVALID = 10
UC_ERR_MAP = 11
UC_ERR_ARG = 15
UC_ERR_EXCEPTION = 21
_ERRTEXT = {
    UC_ERR_OK: "OK (UC_ERR_OK)",
    UC_ERR_READ_UNMAPPED: "Invalid memory read (UC_ERR_READ_UNMAPPED)",
    UC_ERR_WRITE_UNMAPPED: "Invalid memory write (UC_ERR_WRITE_UNMAPPED)",
    UC_ERR_FETCH_UNMAPPED: "Invalid memory fetch (UC_ERR_FETCH_UNMAPPED)",
    UC_ERR_HOOK: "Invalid hook type (UC_ERR_HOOK)",
    UC_ERR_INSN_INVALID: "Invalid instruction (UC_ERR_INSN_INVALID)",
    UC_ERR_MAP: "Invalid memory mapping (UC_ERR_MAP)",
    UC_ERR_ARG: "Invalid argument (UC_ERR_ARG)",
    UC_ERR_EXCEPTION: "Unhandled CPU exception (UC_ERR_EXCEPTION)",
}

X86_REGS = {
    "EAX": 19, "ECX": 22, "EDX": 24, "EBX": 21, "ESP": 30, "EBP": 20, "ESI": 29, "EDI": 23, "EIP": 26,
    "EFLAGS": 25, "AX": 3, "CX": 12, "DX": 18, "BX": 8, "SP": 47, "BP": 6, "SI": 45, "DI": 14, "AL": 2,
    "CL": 10, "DL": 16, "BL": 5, "AH": 1, "CH": 9, "DH": 13, "BH": 4, "CS": 11, "SS": 49, "DS": 17,
    "ES": 28, "FS": 32, "GS": 33, "GDTR": 243, "FPCW": 246, "FPSW": 31, "FPTAG": 247, "FP0": 82,
    "FP1": 83, "FP2": 84, "FP3": 85, "FP4": 86, "FP5": 87, "FP6": 88, "FP7": 89,
}
_R = X86_REGS
_GPR32 = {_R[n]: i for i, n in enumerate(("EAX", "ECX", "EDX", "EBX", "ESP", "EBP", "ESI", "EDI"))}
_GPR16 = {_R[n]: i for i, n in enumerate(("AX", "CX", "DX", "BX", "SP", "BP", "SI", "DI"))}
_GPR8L = {_R[n]: i for i, n in enumerate(("AL", "CL", "DL", "BL"))}
_GPR8H = {_R[n]: i for i, n in enumerate(("AH", "CH", "DH", "BH"))}
_SEG = {_R[n]: i for i, n in enumerate(("ES", "CS", "SS", "DS", "FS", "GS"))}

# C interpreter constants (port/src/cpu/cpu.h)
CPU_RUN_UNTIL, CPU_RUN_COUNT, CPU_RUN_STOPPED, CPU_RUN_FAULT = 0, 1, 2, 3
FAULT_NAMES = ["NONE", "READ_UNMAPPED", "WRITE_UNMAPPED", "FETCH_UNMAPPED", "INVALID_OPCODE", "DIVIDE", "INT",
               "FSIN_TABLE", "THUNK", "K32", "HOST"]
_FAULT_ERRNO = {1: UC_ERR_READ_UNMAPPED, 2: UC_ERR_WRITE_UNMAPPED, 3: UC_ERR_FETCH_UNMAPPED, 4: UC_ERR_INSN_INVALID}
_FAULT_ACCESS = {1: (UC_MEM_READ_UNMAPPED, UC_HOOK_MEM_READ_UNMAPPED),
                 2: (UC_MEM_WRITE_UNMAPPED, UC_HOOK_MEM_WRITE_UNMAPPED),
                 3: (UC_MEM_FETCH_UNMAPPED, UC_HOOK_MEM_FETCH_UNMAPPED)}
CPU_HOOK_CODE, CPU_HOOK_BLOCK, CPU_HOOK_MEM_READ, CPU_HOOK_MEM_WRITE = 1, 2, 3, 4


class CpuFault(ctypes.Structure):
    _fields_ = [("kind", ctypes.c_uint32), ("eip", ctypes.c_uint32), ("addr", ctypes.c_uint32),
                ("size", ctypes.c_uint32), ("text", ctypes.c_char * 200)]


HOOK_FN = ctypes.CFUNCTYPE(None, ctypes.c_void_p, ctypes.c_uint32, ctypes.c_uint32)
DISPATCH_FN = ctypes.CFUNCTYPE(ctypes.c_uint32, ctypes.c_void_p, ctypes.c_uint32, ctypes.c_uint32,
                               ctypes.c_uint32, ctypes.c_uint32)

_lib = None


def lib(path=None):
    """Load libmoeboid.so (env MOEBOID_LIB overrides the path) and declare the cpu.h prototypes."""
    global _lib
    if _lib is not None:
        return _lib
    L = ctypes.CDLL(os.path.abspath(path or os.environ.get("MOEBOID_LIB", LIB_DEFAULT)))
    P, U32, U16, I32, U64, B = ctypes.c_void_p, ctypes.c_uint32, ctypes.c_uint16, ctypes.c_int32, ctypes.c_uint64, ctypes.c_bool
    protos = {
        "cpu_create": (P, []), "cpu_destroy": (None, [P]),
        "cpu_mem_map": (ctypes.c_int, [P, U32, U32]),
        "cpu_mem_read": (B, [P, U32, ctypes.c_void_p, U32]),
        "cpu_mem_write": (B, [P, U32, ctypes.c_char_p, U32]),
        "cpu_mem_fill": (B, [P, U32, ctypes.c_uint8, U32]),
        "cpu_mem_mapped": (B, [P, U32, U32]),
        "cpu_get_reg": (U32, [P, ctypes.c_int]), "cpu_set_reg": (None, [P, ctypes.c_int, U32]),
        "cpu_get_eip": (U32, [P]), "cpu_set_eip": (None, [P, U32]),
        "cpu_get_eflags": (U32, [P]), "cpu_set_eflags": (None, [P, U32]),
        "cpu_get_seg": (U16, [P, ctypes.c_int]), "cpu_set_seg": (ctypes.c_int, [P, ctypes.c_int, U16]),
        "cpu_set_seg_base": (None, [P, ctypes.c_int, U32]), "cpu_set_gdtr": (None, [P, U32, U32]),
        "cpu_fpu_get_reg": (None, [P, ctypes.c_int, ctypes.POINTER(U64), ctypes.POINTER(U16)]),
        "cpu_fpu_set_reg": (None, [P, ctypes.c_int, U64, U16]),
        "cpu_fpu_get_double": (ctypes.c_double, [P, ctypes.c_int]),
        "cpu_fpu_get_cw": (U16, [P]), "cpu_fpu_set_cw": (None, [P, U16]),
        "cpu_fpu_get_sw": (U16, [P]), "cpu_fpu_set_sw": (None, [P, U16]),
        "cpu_fpu_get_tag": (U16, [P]), "cpu_fpu_set_tag": (None, [P, U16]),
        "cpu_run": (ctypes.c_int, [P, U32, U32, U64]),
        "cpu_stop": (None, [P]),
        "cpu_fault": (ctypes.POINTER(CpuFault), [P]),
        "cpu_clear_fault": (None, [P]),
        "cpu_insn_count": (U64, [P]),
        "cpu_insn_len": (U32, [P, U32]),
        "cpu_hook_add": (ctypes.c_int, [P, ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, U32, U32]),
        "cpu_hook_del": (None, [P, ctypes.c_int]),
        "cpu_set_fsin_table": (None, [P, ctypes.c_void_p, U32]),
        "cpu_machine_init": (ctypes.c_int, [P, ctypes.c_char_p, U32, U32, ctypes.c_uint8, U16]),
        "cpu_machine_entry": (U32, [P]),
        "cpu_machine_export": (U32, [P, ctypes.c_char_p]),
        "cpu_machine_base": (U32, [P]),
        "cpu_machine_image_size": (U32, [P]),
        "cpu_machine_reloc_count": (U32, [P]),
        "cpu_machine_heap_next": (U32, [P]),
        "cpu_machine_data_next": (U32, [P]),
        "cpu_machine_alloc_data": (U32, [P, ctypes.c_char_p, U32, U32]),
        "cpu_machine_find_resource": (U32, [P, U32, ctypes.c_char_p, U32, ctypes.c_char_p,
                                            ctypes.POINTER(U32), ctypes.POINTER(U32)]),
        "cpu_machine_import_count": (U32, [P]),
        "cpu_machine_import_name": (ctypes.c_char_p, [P, U32]),
        "cpu_machine_import_calls": (U32, [P, U32]),
        "cpu_set_engine_dispatch": (None, [P, ctypes.c_void_p, ctypes.c_void_p]),
        "cpu_engine_thunk": (U32, [U32, U32]),
        "cpu_engine_argc": (ctypes.c_int, [U32, U32]),
        "cpu_engine_set_argc": (None, [P, U32, U32, ctypes.c_int]),
        "cpu_call": (U32, [P, U32, U32, ctypes.POINTER(U32), ctypes.POINTER(U32)]),
        "cpu_call_cdecl": (U32, [P, U32, U32, ctypes.POINTER(U32)]),
        "cpu_set_call_limit": (None, [P, U64]),
        "cpu_raise": (None, [P, U32, ctypes.c_char_p]),
    }
    for name, (res, args) in protos.items():
        f = getattr(L, name)
        f.restype = res
        f.argtypes = args
    _lib = L
    return L


class UcError(Exception):
    def __init__(self, errno, *args):
        super().__init__(*args)
        self.errno = errno

    def __str__(self):
        return _ERRTEXT.get(self.errno, f"Unicorn error {self.errno}")


class Uc:
    """Unicorn-compatible front end of one C interpreter instance."""

    def __init__(self, arch=UC_ARCH_X86, mode=UC_MODE_32):
        if arch != UC_ARCH_X86 or mode != UC_MODE_32:
            raise UcError(UC_ERR_ARG)
        self._L = lib()
        self._c = self._L.cpu_create()
        if not self._c:
            raise UcError(UC_ERR_ARG)
        self._hooks = {}          # handle -> (kind, c_id or None, cfunc, callback, user, types)
        self._next_handle = 1
        self._hook_exception = None
        self._gdtr = (0, 0, 0, 0)

    def __del__(self):
        try:
            if self._c:
                self._L.cpu_destroy(self._c)
                self._c = None
        except Exception:
            pass

    @property
    def cpu(self):
        """C handle (Cpu *) for direct cpu.h calls."""
        return self._c

    # ------------------------------------------------------------------ memory
    def mem_map(self, address, size, perms=UC_PROT_ALL):
        if self._L.cpu_mem_map(self._c, address, size) != 0:
            raise UcError(UC_ERR_MAP)

    def mem_read(self, address, size):
        buf = ctypes.create_string_buffer(size)
        if not self._L.cpu_mem_read(self._c, address & 0xffffffff, buf, size):
            raise UcError(UC_ERR_READ_UNMAPPED)
        return bytearray(buf.raw)

    def mem_write(self, address, data):
        data = bytes(data)
        if not self._L.cpu_mem_write(self._c, address & 0xffffffff, data, len(data)):
            raise UcError(UC_ERR_WRITE_UNMAPPED)

    # ------------------------------------------------------------------ registers
    def reg_read(self, reg_id, aux=None):
        L, c = self._L, self._c
        if reg_id in _GPR32:
            return L.cpu_get_reg(c, _GPR32[reg_id])
        if reg_id == _R["EIP"]:
            return L.cpu_get_eip(c)
        if reg_id == _R["EFLAGS"]:
            return L.cpu_get_eflags(c)
        if reg_id in _GPR16:
            return L.cpu_get_reg(c, _GPR16[reg_id]) & 0xffff
        if reg_id in _GPR8L:
            return L.cpu_get_reg(c, _GPR8L[reg_id]) & 0xff
        if reg_id in _GPR8H:
            return (L.cpu_get_reg(c, _GPR8H[reg_id]) >> 8) & 0xff
        if reg_id in _SEG:
            return L.cpu_get_seg(c, _SEG[reg_id])
        if _R["FP0"] <= reg_id <= _R["FP7"]:
            m, se = ctypes.c_uint64(), ctypes.c_uint16()
            L.cpu_fpu_get_reg(c, reg_id - _R["FP0"], ctypes.byref(m), ctypes.byref(se))
            return (m.value, se.value)
        if reg_id == _R["FPCW"]:
            return L.cpu_fpu_get_cw(c)
        if reg_id == _R["FPSW"]:
            return L.cpu_fpu_get_sw(c)
        if reg_id == _R["FPTAG"]:
            return L.cpu_fpu_get_tag(c)
        if reg_id == _R["GDTR"]:
            return self._gdtr
        raise UcError(UC_ERR_ARG)

    def reg_write(self, reg_id, value):
        L, c = self._L, self._c
        if reg_id in _GPR32:
            L.cpu_set_reg(c, _GPR32[reg_id], value & 0xffffffff)
        elif reg_id == _R["EIP"]:
            L.cpu_set_eip(c, value & 0xffffffff)
        elif reg_id == _R["EFLAGS"]:
            L.cpu_set_eflags(c, value & 0xffffffff)
        elif reg_id in _GPR16:
            i = _GPR16[reg_id]
            L.cpu_set_reg(c, i, (L.cpu_get_reg(c, i) & 0xffff0000) | (value & 0xffff))
        elif reg_id in _GPR8L:
            i = _GPR8L[reg_id]
            L.cpu_set_reg(c, i, (L.cpu_get_reg(c, i) & 0xffffff00) | (value & 0xff))
        elif reg_id in _GPR8H:
            i = _GPR8H[reg_id]
            L.cpu_set_reg(c, i, (L.cpu_get_reg(c, i) & 0xffff00ff) | ((value & 0xff) << 8))
        elif reg_id in _SEG:
            if L.cpu_set_seg(c, _SEG[reg_id], value & 0xffff) != 0:
                raise UcError(UC_ERR_EXCEPTION)
        elif _R["FP0"] <= reg_id <= _R["FP7"]:
            m, se = value
            L.cpu_fpu_set_reg(c, reg_id - _R["FP0"], m & 0xffffffffffffffff, se & 0xffff)
        elif reg_id == _R["FPCW"]:
            L.cpu_fpu_set_cw(c, value & 0xffff)
        elif reg_id == _R["FPSW"]:
            L.cpu_fpu_set_sw(c, value & 0xffff)
        elif reg_id == _R["FPTAG"]:
            L.cpu_fpu_set_tag(c, value & 0xffff)
        elif reg_id == _R["GDTR"]:
            self._gdtr = tuple(value)
            L.cpu_set_gdtr(c, value[1] & 0xffffffff, value[2] & 0xffffffff)
        else:
            raise UcError(UC_ERR_ARG)

    # ------------------------------------------------------------------ hooks
    def _guard(self, fn):
        def wrapper(*args):
            try:
                return fn(*args)
            except BaseException as e:   # Unicorn 2.1 binding: keep the first, stop, re-raise later
                if self._hook_exception is None:
                    self._hook_exception = e
                self._L.cpu_stop(self._c)
        return wrapper

    def hook_add(self, htype, callback, user_data=None, begin=1, end=0, arg1=0, arg2=0):
        h = self._next_handle
        self._next_handle += 1
        if htype & (UC_HOOK_MEM_UNMAPPED | UC_HOOK_MEM_PROT) and not htype & ~(UC_HOOK_MEM_UNMAPPED | UC_HOOK_MEM_PROT):
            self._hooks[h] = ("invalid", None, None, callback, user_data, htype, begin, end)
            return h
        if htype == UC_HOOK_CODE or htype == UC_HOOK_BLOCK:
            g = self._guard(lambda user, addr, size: callback(self, addr, size, user_data))
            kind = CPU_HOOK_CODE if htype == UC_HOOK_CODE else CPU_HOOK_BLOCK
        elif htype == UC_HOOK_MEM_READ:
            g = self._guard(lambda user, addr, size: callback(self, UC_MEM_READ, addr, size, 0, user_data))
            kind = CPU_HOOK_MEM_READ
        elif htype == UC_HOOK_MEM_WRITE:   # value argument: always 0 (difference from Unicorn)
            g = self._guard(lambda user, addr, size: callback(self, UC_MEM_WRITE, addr, size, 0, user_data))
            kind = CPU_HOOK_MEM_WRITE
        else:
            raise UcError(UC_ERR_HOOK)
        cf = HOOK_FN(g)
        cid = self._L.cpu_hook_add(self._c, kind, ctypes.cast(cf, ctypes.c_void_p), None,
                                   begin & 0xffffffff, end & 0xffffffff)
        if cid < 0:
            raise UcError(UC_ERR_HOOK)
        self._hooks[h] = ("c", cid, cf, callback, user_data, htype, begin, end)
        return h

    def hook_del(self, h):
        ent = self._hooks.pop(h, None)
        if ent and ent[1] is not None:
            self._L.cpu_hook_del(self._c, ent[1])

    # ------------------------------------------------------------------ execution
    def emu_start(self, begin, until, timeout=0, count=0):
        self._hook_exception = None
        r = self._L.cpu_run(self._c, begin & 0xffffffff, until & 0xffffffff, count)
        if r == CPU_RUN_FAULT:
            f = self._L.cpu_fault(self._c).contents
            if f.kind in _FAULT_ACCESS:
                access, mask = _FAULT_ACCESS[f.kind]
                for kind, _, _, cb, user, htype, b, e in list(self._hooks.values()):
                    if kind == "invalid" and htype & mask and (b > e or b <= f.addr <= e):
                        cb(self, access, f.addr, f.size, 0, user)
            raise UcError(_FAULT_ERRNO.get(f.kind, UC_ERR_EXCEPTION))
        if self._hook_exception is not None:
            raise self._hook_exception

    def emu_stop(self):
        self._L.cpu_stop(self._c)

    # ------------------------------------------------------------------ extras (not Unicorn API)
    def fault(self):
        """(kind name, eip, addr, size, text) of the last fault."""
        f = self._L.cpu_fault(self._c).contents
        return (FAULT_NAMES[f.kind] if f.kind < len(FAULT_NAMES) else str(f.kind), f.eip, f.addr, f.size,
                f.text.decode("latin-1"))

    def fault_text(self):
        return self.fault()[4]

    def insn_len(self, addr):
        return self._L.cpu_insn_len(self._c, addr)

    def fpu_double(self, phys):
        return self._L.cpu_fpu_get_double(self._c, phys)


def _module():
    mod = types.ModuleType("unicorn")
    mod.__doc__ = "cshim: Unicorn-compatible front end of the Moeboid C interpreter"
    g = globals()
    for k, v in g.items():
        if k.startswith(("UC_",)):
            setattr(mod, k, v)
    mod.Uc, mod.UcError, mod.CSHIM = Uc, UcError, True
    x86 = types.ModuleType("unicorn.x86_const")
    for n, v in X86_REGS.items():
        setattr(x86, "UC_X86_REG_" + n, v)
    const = types.ModuleType("unicorn.unicorn_const")
    for k in dir(mod):
        if k.startswith("UC_"):
            setattr(const, k, getattr(mod, k))
    mod.x86_const, mod.unicorn_const = x86, const
    return mod, x86, const


def install():
    """Make `import unicorn` (and unicorn.x86_const) resolve to this shim."""
    mod, x86, const = _module()
    sys.modules["unicorn"] = mod
    sys.modules["unicorn.x86_const"] = x86
    sys.modules["unicorn.unicorn_const"] = const
    return mod
