"""emu.Machine replacement that uses the C machine layer instead of the Python one.

The C side does what M4 will use: PE loader (cpu_machine_init), KERNEL32 stubs (k32.c), the thunk
bridge with engine_dispatch, cpu_call for guest calls, the x87 FSIN/FCOS table. The engine stays the
Python mock (analysis/verification/harness/mock.py): its vtable slots point to engine thunks
(cpu_engine_thunk) and engine_dispatch calls the mock behaviour through ctypes.

Interface towards mock.py and run.py: the attributes and methods of emu.Machine that they use
(uc, base, delta, image_size, entry, exports, resources, fill, heap_next, next_data, reloc_count,
api_counts, u32, w32, read, cstr, try_cstr, is_mapped_data, alloc_data, add_stub, va, call,
install_fsin_table).
"""
import ctypes
import os
import sys

import pefile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import cshim  # noqa: E402

IFACES = ["IShell", "IFactory", "ISystem", "ISettings", "ISurface", "IButton", "IAnim", "IImageSeq", "IImage",
          "IFont", "ITimer", "ISound", "IListener"]


def make_class(emu):
    """Build the class against the loaded emu module (constants, exceptions, resource indexer)."""
    PyMachine = emu.Machine

    class CMachine:
        def __init__(self, gam_path, base=emu.PREFERRED_BASE, fill=0x00, logger=None, fpcw=0x027F):
            self.uc = cshim.Uc()
            self.L = cshim.lib()
            self.c = self.uc.cpu
            self.fill = fill
            self.log = logger or (lambda rec: None)
            self.error = None
            data = open(gam_path, "rb").read()
            if self.L.cpu_machine_init(self.c, data, len(data), base, fill, fpcw) != 0:
                raise emu.GuestFault(self.uc.fault_text())
            self.pe = pefile.PE(gam_path)
            self.preferred = self.pe.OPTIONAL_HEADER.ImageBase
            self.base = self.L.cpu_machine_base(self.c)
            self.delta = self.base - self.preferred
            self.image_size = self.L.cpu_machine_image_size(self.c)
            self.reloc_count = self.L.cpu_machine_reloc_count(self.c)
            self.entry = self.L.cpu_machine_entry(self.c)
            self.esp_top = emu.STACK_LO + emu.STACK_SIZE - 0x100
            self.exports = {}
            for e in self.pe.DIRECTORY_ENTRY_EXPORT.symbols:
                name = e.name.decode()
                a = self.L.cpu_machine_export(self.c, name.encode())
                if a != self.base + e.address:
                    raise emu.GuestFault(f"C export {name} = {a:#x}, pefile {self.base + e.address:#x}")
                self.exports[name] = a
            PyMachine._index_resources(self)          # same keys as emu.py (mock.gif_size)
            for (t, n), (entry, va, size) in self.resources.items():
                d, s = ctypes.c_uint32(), ctypes.c_uint32()
                tn = t.encode() if isinstance(t, str) else None
                nn = n.encode() if isinstance(n, str) else None
                e2 = self.L.cpu_machine_find_resource(self.c, 0 if tn else t, tn, 0 if nn else n, nn,
                                                      ctypes.byref(d), ctypes.byref(s))
                if (e2, d.value, s.value) != (entry, va, size):
                    raise emu.GuestFault(f"C resource index differs for {(t, n)}")
            self.methods = {}                              # (iface, slot) -> stub dict
            self._dispatch_cb = cshim.DISPATCH_FN(self._dispatch)
            self.L.cpu_set_engine_dispatch(self.c, ctypes.cast(self._dispatch_cb, ctypes.c_void_p), None)
            self.fsin_hits = None

        # -------------------------------------------------------------- memory helpers (emu.py)
        u32 = PyMachine.u32
        w32 = PyMachine.w32
        read = PyMachine.read
        cstr = PyMachine.cstr
        try_cstr = PyMachine.try_cstr
        is_mapped_data = PyMachine.is_mapped_data
        va = PyMachine.va

        @property
        def heap_next(self):
            return self.L.cpu_machine_heap_next(self.c)

        @property
        def next_data(self):
            return self.L.cpu_machine_data_next(self.c)

        @property
        def api_counts(self):
            out = {}
            for i in range(self.L.cpu_machine_import_count(self.c)):
                n = self.L.cpu_machine_import_calls(self.c, i)
                if n:
                    out["KERNEL32.dll!" + self.L.cpu_machine_import_name(self.c, i).decode()] = n
            return out

        def alloc_data(self, data, align=16):
            a = self.L.cpu_machine_alloc_data(self.c, bytes(data), len(data), align)
            if not a:
                raise emu.GuestFault(self.uc.fault_text())
            return a

        py_fsin_hook = False    # True: use emu.py's code-hook table path (same DATA layout as emu.py)

        def install_fsin_table(self, path=emu.FSIN_TABLE):
            if self.py_fsin_hook:
                PyMachine.install_fsin_table(self, path)
            # else: the C CPU reads its own x87 table (port/src/cpu/fsin_table.h)

        # -------------------------------------------------------------- engine thunks
        def add_stub(self, kind, name, nargs, fn, **extra):
            if kind != "method":
                raise emu.GuestFault(f"CMachine.add_stub: kind {kind} not supported")
            typ, off = extra["typ"], extra["off"]
            if typ not in IFACES:
                raise emu.GuestFault(f"CMachine.add_stub: interface {typ} has no C id")
            key = (IFACES.index(typ), off // 4)
            self.methods[key] = dict(kind=kind, name=name, nargs=nargs, fn=fn, **extra)
            return self.L.cpu_engine_thunk(*key)

        def _dispatch(self, ctx, iface, slot, this, args_guest):
            try:
                st = self.methods.get((iface, slot))
                if st is None:
                    raise emu.Stop(f"engine thunk {iface}.{slot} without a mock stub")
                esp = args_guest - 4
                nargs, r = st["fn"](self, st, self.u32(esp), esp)
                argc = self.L.cpu_engine_argc(iface, slot)
                if nargs != argc:
                    raise emu.Stop(f"{st['name']}: mock pops {nargs} arguments, interface.tsv argc {argc}")
                return (r or 0) & 0xffffffff
            except BaseException as e:   # noqa: BLE001 (report every mock error as a guest fault)
                self.error = str(e) if isinstance(e, emu.Stop) else f"stub {type(e).__name__}: {e}"
                self.L.cpu_raise(self.c, 10, self.error.encode("latin-1", "replace"))
                return 0

        # -------------------------------------------------------------- guest calls
        def call(self, addr, args=(), ecx=None, max_insn=200_000_000):
            self.error = None
            arr = (ctypes.c_uint32 * max(1, len(args)))(*[a & 0xffffffff for a in args])
            pecx = ctypes.byref(ctypes.c_uint32(ecx)) if ecx is not None else None
            self.L.cpu_set_call_limit(self.c, max_insn)
            eax = self.L.cpu_call(self.c, addr, len(args), arr, pecx)
            kind, eip, fa, fs, text = self.uc.fault()
            if kind != "NONE":
                raise emu.GuestFault(self.error or f"{kind} at eip={eip:08x}: {text}")
            return eax, 0

    return CMachine
