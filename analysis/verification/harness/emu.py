"""Unicorn machine for Moeboid.gam.

Loads the PE image (sections, base relocations, import table pointing to logging stubs), gives
the guest a TEB (FS segment for SEH), a stack and a deterministic heap, and implements the
KERNEL32 functions that the statically linked MSVC6 CRT and the game code import.
The guest gets no file, network or OS access: every import is a Python stub.

Address map (guest virtual addresses):
  0x00010000  GDT                      0x00020000  TEB (FS base)
  0x00100000  stack (1 MiB)            0x02000000  HeapAlloc arena (32 MiB, bump allocator)
  0x04000000  VirtualAlloc arena       0x10000000  Moeboid.gam (preferred base; --base moves it)
  0x60000000  fake interface objects   0x7f000000  stub/trampoline code (one RET per stub)
  0x7f100000  stub-owned data (strings, callback info blocks)
"""
import struct

import pefile
from unicorn import Uc, UcError, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE, UC_HOOK_MEM_READ, \
    UC_HOOK_MEM_WRITE, UC_HOOK_MEM_INVALID, UC_PROT_ALL
from unicorn.x86_const import UC_X86_REG_EAX, UC_X86_REG_ECX, UC_X86_REG_EDX, UC_X86_REG_ESP, \
    UC_X86_REG_EIP, UC_X86_REG_GDTR, UC_X86_REG_FS, UC_X86_REG_FPCW, UC_X86_REG_EBX, \
    UC_X86_REG_ESI, UC_X86_REG_EDI, UC_X86_REG_EBP, UC_X86_REG_FPSW, UC_X86_REG_FP0, UC_X86_REG_DS, UC_X86_REG_ES, UC_X86_REG_SS
import os

PREFERRED_BASE = 0x10000000
GDT_ADDR = 0x00010000
TEB_ADDR = 0x00020000
STACK_LO, STACK_SIZE = 0x00100000, 0x00100000
HEAP_LO, HEAP_SIZE = 0x02000000, 0x02000000
VA_LO, VA_SIZE = 0x04000000, 0x02000000
FAKE_LO, FAKE_SIZE = 0x60000000, 0x01000000
STUB_LO, STUB_SIZE = 0x7f000000, 0x00100000
DATA_LO, DATA_SIZE = 0x7f100000, 0x00100000
SENTINEL = STUB_LO + STUB_SIZE - 0x10
FSIN_TABLE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "fpu", "x87_fsin_table.tsv")

HEAP_ZERO_MEMORY = 0x8
ERROR_RESOURCE_NAME_NOT_FOUND = 1814


class GuestFault(Exception):
    pass


class Stop(Exception):
    """Raised by a stub to end the run (ExitProcess, unsupported call)."""


def gdt_entry(base, limit, access, flags):
    v = limit & 0xffff
    v |= (base & 0xffffff) << 16
    v |= (access & 0xff) << 40
    v |= ((limit >> 16) & 0xf) << 48
    v |= (flags & 0xf) << 52
    v |= ((base >> 24) & 0xff) << 56
    return struct.pack("<Q", v)


class Machine:
    def __init__(self, gam_path, base=PREFERRED_BASE, fill=0x00, logger=None, fpcw=0x027F):
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.fill = fill
        self.log = logger or (lambda rec: None)
        self.stubs = {}          # stub address -> dict(kind, name, nargs, fn)
        self.next_stub = STUB_LO
        self.next_data = DATA_LO
        self.heap_next = HEAP_LO
        self.heap_sizes = {}
        self.va_next = VA_LO
        self.last_error = 0
        self.error = None
        self.api_counts = {}
        self.fake_read_hook = None
        self._map_regions()
        self._setup_fs()
        # Initial x87 control word. Windows starts threads with 0x27F; the CRT of the gam sets
        # precision control to 53 bit again in its initializer (Moeboid.gam:0x10005976).
        self.uc.reg_write(UC_X86_REG_FPCW, fpcw)
        self.load_pe(gam_path, base)
        self.uc.hook_add(UC_HOOK_CODE, self._on_stub, begin=STUB_LO, end=STUB_LO + STUB_SIZE - 1)
        self.uc.hook_add(UC_HOOK_MEM_INVALID, self._on_invalid)

    # ------------------------------------------------------------------ memory
    def _map_regions(self):
        u = self.uc
        u.mem_map(GDT_ADDR, 0x1000)
        u.mem_map(TEB_ADDR, 0x1000)
        u.mem_map(STACK_LO, STACK_SIZE)
        u.mem_write(STACK_LO, bytes([self.fill]) * STACK_SIZE)
        u.mem_map(HEAP_LO, HEAP_SIZE)
        u.mem_map(VA_LO, VA_SIZE)
        u.mem_map(FAKE_LO, FAKE_SIZE)
        u.mem_map(STUB_LO, STUB_SIZE)
        u.mem_write(STUB_LO, b"\xc3" * STUB_SIZE)  # every stub address is a RET
        u.mem_map(DATA_LO, DATA_SIZE)
        self.esp_top = STACK_LO + STACK_SIZE - 0x100
        u.reg_write(UC_X86_REG_ESP, self.esp_top)

    def _setup_fs(self):
        teb = bytearray(0x1000)
        struct.pack_into("<I", teb, 0x00, 0xFFFFFFFF)                 # ExceptionList end
        struct.pack_into("<I", teb, 0x04, STACK_LO + STACK_SIZE)      # StackBase
        struct.pack_into("<I", teb, 0x08, STACK_LO)                   # StackLimit
        struct.pack_into("<I", teb, 0x18, TEB_ADDR)                   # Self
        struct.pack_into("<I", teb, 0x20, 0x1000)                     # ClientId.UniqueProcess
        struct.pack_into("<I", teb, 0x24, 0x1004)                     # ClientId.UniqueThread
        self.uc.mem_write(TEB_ADDR, bytes(teb))
        gdt = (b"\0" * 8 + gdt_entry(0, 0xfffff, 0x9b, 0xc) + gdt_entry(0, 0xfffff, 0x93, 0xc)
               + gdt_entry(TEB_ADDR, 0xfff, 0x93, 0x4))
        self.uc.mem_write(GDT_ADDR, gdt)
        self.uc.reg_write(UC_X86_REG_GDTR, (0, GDT_ADDR, len(gdt) - 1, 0))
        # Flat 32-bit data segments. Without an explicit SS load Unicorn uses a 16-bit stack
        # (ESP wraps at 64 KiB).
        for r in (UC_X86_REG_DS, UC_X86_REG_ES, UC_X86_REG_SS):
            self.uc.reg_write(r, 2 << 3)
        self.uc.reg_write(UC_X86_REG_FS, 3 << 3)

    def u32(self, a):
        return struct.unpack("<I", self.uc.mem_read(a, 4))[0]

    def w32(self, a, v):
        self.uc.mem_write(a, struct.pack("<I", v & 0xffffffff))

    def read(self, a, n):
        return bytes(self.uc.mem_read(a, n))

    def cstr(self, a, maxlen=4096):
        out = bytearray()
        while len(out) < maxlen:
            chunk = self.read(a + len(out), 64)
            i = chunk.find(b"\0")
            if i >= 0:
                out += chunk[:i]
                return bytes(out)
            out += chunk
        return bytes(out)

    def try_cstr(self, a, maxlen=512):
        """Return a printable ASCII string at guest address a, or None."""
        if not self.is_mapped_data(a):
            return None
        try:
            s = self.cstr(a, maxlen)
        except UcError:
            return None
        if len(s) == 0 or len(s) >= maxlen:
            return None
        if all(32 <= c < 127 or c in (9, 10, 13) for c in s):
            return s.decode("latin-1")
        return None

    def is_mapped_data(self, a):
        return (self.base <= a < self.base + self.image_size or STACK_LO <= a < STACK_LO + STACK_SIZE
                or HEAP_LO <= a < self.heap_next or VA_LO <= a < VA_LO + VA_SIZE
                or DATA_LO <= a < self.next_data)

    def alloc_data(self, data, align=16):
        a = self.next_data
        self.uc.mem_write(a, data)
        self.next_data = (a + len(data) + align - 1) & ~(align - 1)
        return a

    # ------------------------------------------------------------------ PE loading
    def load_pe(self, path, base):
        pe = pefile.PE(path)
        self.pe = pe
        pref = pe.OPTIONAL_HEADER.ImageBase
        self.preferred = pref
        self.base = base
        self.delta = base - pref
        size = (pe.OPTIONAL_HEADER.SizeOfImage + 0xfff) & ~0xfff
        self.image_size = size
        self.uc.mem_map(base, size, UC_PROT_ALL)
        self.uc.mem_write(base, pe.header[:pe.OPTIONAL_HEADER.SizeOfHeaders])
        for s in pe.sections:
            data = s.get_data()
            self.uc.mem_write(base + s.VirtualAddress, data[:max(s.Misc_VirtualSize, len(data))])
        # base relocations (IMAGE_REL_BASED_HIGHLOW only in this file)
        self.reloc_count = 0
        if self.delta and hasattr(pe, "DIRECTORY_ENTRY_BASERELOC"):
            for blk in pe.DIRECTORY_ENTRY_BASERELOC:
                for e in blk.entries:
                    if e.type == 3:
                        a = base + e.rva
                        self.w32(a, self.u32(a) + self.delta)
                        self.reloc_count += 1
                    elif e.type != 0:
                        raise GuestFault(f"unsupported relocation type {e.type}")
        # imports
        self.imports = {}
        for d in pe.DIRECTORY_ENTRY_IMPORT:
            dll = d.dll.decode()
            for imp in d.imports:
                name = imp.name.decode() if imp.name else f"ord{imp.ordinal}"
                nargs, fn = WIN32_STUBS.get(name, (0, None))
                stub = self.add_stub("api", f"{dll}!{name}", nargs, fn)
                self.w32(imp.address + self.delta, stub)
                self.imports[name] = stub
        # exports
        self.exports = {}
        if hasattr(pe, "DIRECTORY_ENTRY_EXPORT"):
            for e in pe.DIRECTORY_ENTRY_EXPORT.symbols:
                self.exports[e.name.decode()] = base + e.address
        self.entry = base + pe.OPTIONAL_HEADER.AddressOfEntryPoint
        self._index_resources()

    def va(self, preferred_va):
        """Translate a preferred-base address (as in the Ghidra exports) to the loaded address."""
        return preferred_va + self.delta

    def _index_resources(self):
        """Map (type, name) -> (data entry VA, data VA, size). Names: int ID or upper-case str."""
        self.resources = {}
        pe = self.pe
        if not hasattr(pe, "DIRECTORY_ENTRY_RESOURCE"):
            return
        rva_dir = pe.OPTIONAL_HEADER.DATA_DIRECTORY[2].VirtualAddress

        def key(entry):
            return str(entry.name).upper() if entry.name is not None else entry.id

        for t in pe.DIRECTORY_ENTRY_RESOURCE.entries:
            for n in t.directory.entries:
                for lang in n.directory.entries:
                    de = lang.data.struct
                    # offset of the IMAGE_RESOURCE_DATA_ENTRY = directory RVA + OffsetToData of lang
                    entry_va = self.base + rva_dir + (lang.struct.OffsetToData & 0x7fffffff)
                    self.resources[(key(t), key(n))] = (entry_va, self.base + de.OffsetToData, de.Size)

    # ------------------------------------------------------------------ stubs
    def add_stub(self, kind, name, nargs, fn, **extra):
        a = self.next_stub
        self.next_stub += 4
        if self.next_stub >= SENTINEL:
            raise GuestFault("stub region full")
        self.stubs[a] = dict(kind=kind, name=name, nargs=nargs, fn=fn, **extra)
        return a

    def _on_stub(self, uc, addr, size, user):
        if addr == SENTINEL:
            uc.emu_stop()
            return
        st = self.stubs.get(addr)
        if st is None:
            self.error = f"jump into unassigned stub address {addr:08x}"
            uc.emu_stop()
            return
        esp = uc.reg_read(UC_X86_REG_ESP)
        ret = self.u32(esp)
        try:
            if st["kind"] == "api":
                nargs = st["nargs"]
                args = [self.u32(esp + 4 + 4 * i) for i in range(nargs)]
                self.api_counts[st["name"]] = self.api_counts.get(st["name"], 0) + 1
                if st["fn"] is None:
                    self.log({"kind": "api", "name": st["name"], "args": args, "ret": 0, "note": "UNIMPLEMENTED"})
                    raise Stop(f"unimplemented import {st['name']} called from {ret:08x}")
                eax = st["fn"](self, args)
                self.log({"kind": "api", "name": st["name"], "args": [f"{x:#x}" for x in args],
                          "ret": f"{(eax or 0) & 0xffffffff:#x}", "from": f"{ret:08x}"})
            else:
                nargs, eax = st["fn"](self, st, ret, esp)
        except Stop as e:
            self.error = str(e)
            uc.emu_stop()
            return
        except Exception as e:  # stub bug: stop and report, do not hide
            self.error = f"stub {st['name']} raised {type(e).__name__}: {e}"
            uc.emu_stop()
            return
        uc.reg_write(UC_X86_REG_EAX, (eax or 0) & 0xffffffff)
        if nargs:
            self.w32(esp + 4 * nargs, ret)
            uc.reg_write(UC_X86_REG_ESP, esp + 4 * nargs)

    def _on_invalid(self, uc, access, addr, size, value, user):
        eip = uc.reg_read(UC_X86_REG_EIP)
        self.error = f"invalid memory access type={access} addr={addr:08x} size={size} eip={eip:08x}"
        return False

    # ------------------------------------------------------------------ x87 FSIN/FCOS
    def install_fsin_table(self, path=FSIN_TABLE):
        """Replace FSIN (Moeboid.gam:0x1000125d) and FCOS (0x1000126e) with 80-bit results measured
        on a real x87 (fpu/x87_fsin_table.tsv). QEMU/Unicorn compute FSIN with host libm sin() on a
        double, which differs from x87 in the last bits (see fpu/fsin_check.log).
        Mechanism: code hook reads ST0, writes the table value to scratch memory, and redirects to a
        stub `FSTP ST0; FLD tword [scratch]; JMP next`."""
        tbl = {}
        for i, line in enumerate(open(path)):
            if i == 0:
                continue
            f = line.split()
            vals = []
            for col in f[1:4]:
                e, mnt = col.split(":")
                vals.append((int(mnt, 16), int(e, 16)))
            tbl[vals[0]] = (vals[1], vals[2])
        scratch = self.alloc_data(b"\0" * 16)
        self.fsin_hits = 0

        def mkstub(ret):
            code = b"\xdd\xd8\xdb\x2d" + struct.pack("<I", scratch)
            here = self.next_data
            code += b"\xe9" + struct.pack("<i", ret - (here + len(code) + 5))
            return self.alloc_data(code)

        sites = {self.va(0x1000125d): (0, mkstub(self.va(0x1000125f))),
                 self.va(0x1000126e): (1, mkstub(self.va(0x10001270)))}

        def hook(uc, addr, size, user):
            which, stub = sites[addr]
            top = (uc.reg_read(UC_X86_REG_FPSW) >> 11) & 7
            arg = tuple(uc.reg_read(UC_X86_REG_FP0 + top))
            ent = tbl.get(arg)
            if ent is None:
                self.error = f"FSIN/FCOS argument {arg} not in x87 table"
                uc.emu_stop()
                return
            uc.mem_write(scratch, struct.pack("<QH", *ent[which]))
            uc.reg_write(UC_X86_REG_EIP, stub)
            self.fsin_hits += 1

        for a in sites:
            self.uc.hook_add(UC_HOOK_CODE, hook, None, a, a)

    # ------------------------------------------------------------------ guest calls
    def call(self, addr, args=(), ecx=None, max_insn=200_000_000):
        """Call guest code at addr with stack args (pushed right to left) and optional ECX.
        Returns EAX. Restores ESP afterwards (works for cdecl, stdcall and thiscall)."""
        u = self.uc
        esp0 = u.reg_read(UC_X86_REG_ESP)
        saved = {r: u.reg_read(r) for r in (UC_X86_REG_EBX, UC_X86_REG_ESI, UC_X86_REG_EDI, UC_X86_REG_EBP)}
        sp = esp0
        for a in reversed(list(args)):
            sp -= 4
            self.w32(sp, a)
        sp -= 4
        self.w32(sp, SENTINEL)
        u.reg_write(UC_X86_REG_ESP, sp)
        if ecx is not None:
            u.reg_write(UC_X86_REG_ECX, ecx)
        self.error = None
        try:
            u.emu_start(addr, SENTINEL, count=max_insn)
        except UcError as e:
            if self.error is None:
                self.error = f"UcError {e} at eip={u.reg_read(UC_X86_REG_EIP):08x}"
        eip = u.reg_read(UC_X86_REG_EIP)
        if self.error is None and eip != SENTINEL:
            self.error = f"guest call {addr:08x} did not return (eip={eip:08x}, instruction limit?)"
        if self.error:
            raise GuestFault(self.error)
        callee_sp = u.reg_read(UC_X86_REG_ESP)
        for r, v in saved.items():
            if u.reg_read(r) != v:
                raise GuestFault(f"callee-saved register changed in call {addr:08x}")
        u.reg_write(UC_X86_REG_ESP, esp0)
        return u.reg_read(UC_X86_REG_EAX), callee_sp - (sp + 4)


# ---------------------------------------------------------------------- KERNEL32 stubs
def _heap_alloc(m, size, zero):
    size = max(size, 1)
    a = m.heap_next
    n = (size + 15) & ~15
    if a + n > HEAP_LO + HEAP_SIZE:
        raise Stop("heap arena exhausted")
    m.heap_next = a + n
    m.heap_sizes[a] = size
    m.uc.mem_write(a, (b"\0" if zero else bytes([m.fill])) * n)
    return a


def k_HeapAlloc(m, a):
    return _heap_alloc(m, a[2], bool(a[1] & HEAP_ZERO_MEMORY))


def k_HeapReAlloc(m, a):
    old, size = a[2], a[3]
    new = _heap_alloc(m, size, bool(a[1] & HEAP_ZERO_MEMORY))
    if old in m.heap_sizes:
        n = min(m.heap_sizes[old], size)
        m.uc.mem_write(new, m.read(old, n))
    return new


def k_HeapFree(m, a):
    m.heap_sizes.pop(a[2], None)
    return 1


def k_VirtualAlloc(m, a):
    addr, size, typ = a[0], a[1], a[2]
    if addr == 0:
        addr = m.va_next
        m.va_next = (addr + size + 0xffff) & ~0xffff
        if m.va_next > VA_LO + VA_SIZE:
            raise Stop("VirtualAlloc arena exhausted")
    return addr  # arena is mapped and zero-filled from the start (commit gives zeroed pages)


def _str_buf(m, text):
    return m.alloc_data(text.encode("latin-1") + b"\0")


def k_GetCommandLineA(m, a):
    if not hasattr(m, "_cmdline"):
        m._cmdline = _str_buf(m, '"C:\\ZapSpot\\ZapSpot.exe"')
    return m._cmdline


def k_GetEnvironmentStrings(m, a):
    if not hasattr(m, "_env"):
        m._env = m.alloc_data(b"PATH=C:\\WINDOWS\0\0")
    return m._env


def k_GetModuleFileNameA(m, a):
    name = b"C:\\ZapSpot\\Moeboid.gam"
    n = min(len(name), a[2] - 1)
    m.uc.mem_write(a[1], name[:n] + b"\0")
    return n


def k_GetStartupInfoA(m, a):
    m.uc.mem_write(a[0], struct.pack("<I", 68) + b"\0" * 64)
    return 0


def k_GetCPInfo(m, a):
    # CPINFO: MaxCharSize=1, DefaultChar='?', LeadByte all zero
    m.uc.mem_write(a[1], struct.pack("<I", 1) + b"?\0" + b"\0" * 12)
    return 1


def k_MultiByteToWideChar(m, a):
    cp, flags, src, srclen, dst, dstlen = a
    data = m.cstr(src) + b"\0" if srclen == 0xffffffff else m.read(src, srclen)
    if dstlen == 0:
        return len(data)
    w = data.decode("latin-1").encode("utf-16-le")
    n = min(len(data), dstlen)
    m.uc.mem_write(dst, w[:2 * n])
    return n


def k_WideCharToMultiByte(m, a):
    cp, flags, src, srclen, dst, dstlen = a[:6]
    if srclen == 0xffffffff:
        raw = bytearray()
        while True:
            c = m.read(src + len(raw), 2)
            raw += c
            if c == b"\0\0":
                break
    else:
        raw = m.read(src, 2 * srclen)
    s = raw.decode("utf-16-le").encode("latin-1", "replace")
    if dstlen == 0:
        return len(s)
    n = min(len(s), dstlen)
    m.uc.mem_write(dst, s[:n])
    return n


def k_GetStringTypeW(m, a):
    # GetStringTypeW(dwInfoType, lpSrcStr, cchSrc, lpCharType): CT_CTYPE1 only
    typ, src, n, out = a
    if n == 0xffffffff:
        n = 0
        while m.read(src + 2 * n, 2) != b"\0\0":
            n += 1
        n += 1
    for i in range(n):
        c = struct.unpack("<H", m.read(src + 2 * i, 2))[0]
        m.uc.mem_write(out + 2 * i, struct.pack("<H", _ctype1(c)))
    return 1


def k_GetStringTypeA(m, a):
    lcid, typ, src, n, out = a
    if n == 0xffffffff:
        n = len(m.cstr(src)) + 1
    for i in range(n):
        c = m.read(src + i, 1)[0]
        m.uc.mem_write(out + 2 * i, struct.pack("<H", _ctype1(c)))
    return 1


def _ctype1(c):
    v = 0
    ch = chr(c)
    if ch.isupper():
        v |= 0x1
    if ch.islower():
        v |= 0x2
    if ch.isdigit():
        v |= 0x4
    if ch in " \t\n\r\x0b\x0c":
        v |= 0x8
    if 33 <= c < 127 and not ch.isalnum():
        v |= 0x10
    if c < 32 or c == 127:
        v |= 0x20
    if c == 32 or c == 9:
        v |= 0x40
    if ch in "0123456789abcdefABCDEF":
        v |= 0x80
    if ch.isalpha():
        v |= 0x100
    return v


def k_LCMapStringA(m, a):
    lcid, flags, src, n, dst, dstn = a
    s = m.cstr(src) + b"\0" if n == 0xffffffff else m.read(src, n)
    if flags & 0x100:
        s = s.lower()
    elif flags & 0x200:
        s = s.upper()
    if dstn == 0:
        return len(s)
    m.uc.mem_write(dst, s[:dstn])
    return min(len(s), dstn)


def k_LCMapStringW(m, a):
    lcid, flags, src, n, dst, dstn = a
    if n == 0xffffffff:
        n = 0
        while m.read(src + 2 * n, 2) != b"\0\0":
            n += 1
        n += 1
    s = m.read(src, 2 * n).decode("utf-16-le")
    if flags & 0x100:
        s = s.lower()
    elif flags & 0x200:
        s = s.upper()
    if dstn == 0:
        return n
    m.uc.mem_write(dst, s.encode("utf-16-le")[:2 * dstn])
    return min(n, dstn)


def _res_key(m, v):
    if v < 0x10000:
        return v
    s = m.cstr(v).decode("latin-1")
    if s.startswith("#"):
        return int(s[1:])
    return s.upper()


def k_FindResourceA(m, a):
    hmod, name, typ = a
    k = (_res_key(m, typ), _res_key(m, name))
    r = m.resources.get(k)
    if r is None:
        m.last_error = ERROR_RESOURCE_NAME_NOT_FOUND
        return 0
    return r[0]


def _res_by_entry(m, h):
    for r in m.resources.values():
        if r[0] == h:
            return r
    raise Stop(f"unknown HRSRC {h:#x}")


def k_LoadResource(m, a):
    return _res_by_entry(m, a[1])[1] if a[1] else 0


def k_SizeofResource(m, a):
    return _res_by_entry(m, a[1])[2] if a[1] else 0


def k_CreateFileA(m, a):
    m.log({"kind": "policy", "note": f"CreateFileA({m.cstr(a[0]).decode('latin-1')!r}) denied"})
    m.last_error = 2
    return 0xFFFFFFFF


def k_WriteFile(m, a):
    h, buf, n, written, ov = a
    m.log({"kind": "stdio", "handle": h, "text": m.read(buf, n).decode("latin-1")})
    if written:
        m.w32(written, n)
    return 1


def k_exit(m, a):
    raise Stop(f"process exit requested (code {a[0] if a else 0:#x})")


def const(v):
    return lambda m, a: v


def k_SetLastError_get(m, a):
    return m.last_error


WIN32_STUBS = {
    # name: (stdcall argument count, implementation)
    "GetVersion": (0, const(0x0A280105)),            # Windows XP 5.1 build 2600 (configurable choice)
    "HeapCreate": (3, const(0x00A10000)),
    "HeapDestroy": (1, const(1)),
    "HeapAlloc": (3, k_HeapAlloc),
    "HeapFree": (3, k_HeapFree),
    "HeapReAlloc": (4, k_HeapReAlloc),
    "VirtualAlloc": (4, k_VirtualAlloc),
    "VirtualFree": (3, const(1)),
    "GetCommandLineA": (0, k_GetCommandLineA),
    "GetEnvironmentStrings": (0, k_GetEnvironmentStrings),
    "GetEnvironmentStringsW": (0, const(0)),         # forces the CRT onto the ANSI path
    "FreeEnvironmentStringsA": (1, const(1)),
    "FreeEnvironmentStringsW": (1, const(1)),
    "GetModuleFileNameA": (3, k_GetModuleFileNameA),
    "GetModuleHandleA": (1, const(0)),
    "GetProcAddress": (2, const(0)),
    "LoadLibraryA": (1, const(0)),
    "GetStartupInfoA": (1, k_GetStartupInfoA),
    "GetStdHandle": (1, const(0xFFFFFFFF)),
    "GetFileType": (1, const(0)),
    "SetHandleCount": (1, lambda m, a: a[0]),
    "SetStdHandle": (2, const(1)),
    "GetACP": (0, const(1252)),
    "GetOEMCP": (0, const(437)),
    "GetCPInfo": (2, k_GetCPInfo),
    "MultiByteToWideChar": (6, k_MultiByteToWideChar),
    "WideCharToMultiByte": (8, k_WideCharToMultiByte),
    "GetStringTypeA": (5, k_GetStringTypeA),
    "GetStringTypeW": (4, k_GetStringTypeW),
    "LCMapStringA": (6, k_LCMapStringA),
    "LCMapStringW": (6, k_LCMapStringW),
    "GetLastError": (0, k_SetLastError_get),
    "GetCurrentProcess": (0, const(0xFFFFFFFF)),
    "IsBadReadPtr": (2, const(0)),
    "IsBadWritePtr": (2, const(0)),
    "IsBadCodePtr": (1, const(0)),
    "SetUnhandledExceptionFilter": (1, const(0)),
    "UnhandledExceptionFilter": (1, const(0)),       # EXCEPTION_CONTINUE_SEARCH
    "SetConsoleCtrlHandler": (2, const(1)),
    "FindResourceA": (3, k_FindResourceA),
    "LoadResource": (2, k_LoadResource),
    "LockResource": (1, lambda m, a: a[0]),
    "SizeofResource": (2, k_SizeofResource),
    "CreateFileA": (7, k_CreateFileA),
    "ReadFile": (5, const(0)),
    "WriteFile": (5, k_WriteFile),
    "GetFileSize": (2, const(0xFFFFFFFF)),
    "SetFilePointer": (4, const(0xFFFFFFFF)),
    "FlushFileBuffers": (1, const(1)),
    "CloseHandle": (1, const(1)),
    "ExitProcess": (1, k_exit),
    "TerminateProcess": (2, k_exit),
    "RtlUnwind": (4, None),                          # SEH unwinding: not expected; stop if called
}
