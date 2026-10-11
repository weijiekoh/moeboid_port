"""Native port driver for tests (M4): the C CPU and the C engine in port/build/libmoeboid.so (ctypes).

NativeEngine runs Moeboid.gam on the port engine with a fresh Port, collects the lockstep trace
(port-design.md section 9: one row per tick, as analysis/verification/harness/run.py writes
ticks.tsv) and replays input recordings in the moeboid-input v1 format (verification.md 4.7)
through the real input path (key and mouse events, button hit test).
"""
import ctypes
import os

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, "..", "..", ".."))
LIB = os.path.join(ROOT, "port", "build", "libmoeboid.so")
PACK = os.path.join(ROOT, "port", "build", "web", "pack.bin")
GAM = os.path.join(ROOT, "extracted", "Moeboid.gam")
GUID = "{2BFDD7F8-0EC4-4E7C-9FF4-3B2F8DC1D0F2}"

SINK = ctypes.CFUNCTYPE(None, ctypes.c_char_p, ctypes.c_uint32)
# engine key index (GetKeyState) to virtual key (Z:0x426bf0)
KEY_VK = {0: 0x08, 1: 0x2E, 2: 0x09, 3: 0x0D, 5: 0x11, 6: 0x25, 7: 0x27, 8: 0x26, 9: 0x28, 10: 0x24, 11: 0x23, 12: 0x10}
IN_KEYDOWN, IN_KEYUP, IN_MOUSEMOVE, IN_BUTTONDOWN, IN_BUTTONUP = 1, 2, 3, 4, 5

_lib = None


def lib():
    global _lib
    if _lib is None:
        L = ctypes.CDLL(LIB)
        P, U, I, B = ctypes.c_void_p, ctypes.c_uint32, ctypes.c_int32, ctypes.c_bool
        sig = {
            "engine_test_port_new": ([], P), "core_init": ([P, U, U, U], None),
            "core_start": ([P, ctypes.c_char_p, U, ctypes.c_char_p, U], I), "core_advance": ([P, U], U),
            "core_input": ([P, U, I, I, U], B), "engine_test_trace_mode": ([P, U], None),
            "engine_test_goto": ([P, U], None), "engine_test_input": ([P, U, I, I], None),
            "engine_test_finish_step": ([P], None), "engine_test_now": ([P], U),
            "engine_test_storage_set": ([P, ctypes.c_char_p, ctypes.c_char_p], B),
            "engine_test_button_point": ([P, ctypes.c_char_p, ctypes.POINTER(I), ctypes.POINTER(I)], B),
            "engine_test_answer": ([P, ctypes.c_char_p], None), "engine_test_auto_dialogs": ([P, B], None),
            "engine_applet_event": ([P, I], None), "engine_applet_stop": ([P], None),
            "engine_fault_text": ([P], ctypes.c_char_p), "engine_test_frame_ptr": ([P], P),
            "engine_test_live_objects": ([P], U), "engine_render_count": ([P], U),
            "rt_set_sinks": ([SINK, SINK], None), "engine_test_cursor": ([P], U),
            "engine_text_open": ([ctypes.c_char_p, U], P),
            "engine_text_measure": ([P, ctypes.c_char_p, I, U, ctypes.c_char_p, I, ctypes.POINTER(I), ctypes.POINTER(I)], I),
            "engine_gif_size": ([ctypes.c_char_p, U, ctypes.POINTER(I), ctypes.POINTER(I)], I),
            "engine_new_game": ([P], I), "engine_paused": ([P], B), "engine_set_paused": ([P, B], None),
            "engine_dialog_waiting": ([P], B), "engine_dialog_done": ([P, I, ctypes.c_char_p], None),
            "engine_test_no_jump": ([P, B], None), "engine_test_run_through": ([P, U], None),
        }
        for name, (args, res) in sig.items():
            f = getattr(L, name)
            f.argtypes = args
            f.restype = res
        _lib = L
    return _lib


class NativeEngine:
    """One port instance. trace: 0 off, 1 tick rows, 2 full log (rows plus call lines)."""

    def __init__(self, seed=12345, clock_index=0, quirks=0xFFFFFFFF, trace=2, settings=None, auto_dialogs=True,
                 gam=GAM, pack=PACK):
        L = lib()
        self.L = L
        self.rows, self.log, self.full = [], [], []
        self._buf = b""
        self._trace_cb = SINK(self._on_trace)
        self._log_cb = SINK(lambda p, n: self.log.append(ctypes.string_at(p, n).decode("latin-1")))
        L.rt_set_sinks(self._log_cb, self._trace_cb)
        self.pack = open(pack, "rb").read()
        self.gam = open(gam, "rb").read()
        self.p = L.engine_test_port_new()
        for k, v in (settings or {}).items():
            L.engine_test_storage_set(self.p, f"game/{GUID}/{k}".encode("latin-1"), v.encode("latin-1"))
        L.core_init(self.p, clock_index, quirks, seed)
        L.engine_test_trace_mode(self.p, trace)
        self.rc = L.core_start(self.p, self.pack, len(self.pack), self.gam, len(self.gam))
        L.engine_test_auto_dialogs(self.p, auto_dialogs)
        L.core_advance(self.p, 0)

    def _on_trace(self, p, n):
        self._buf += ctypes.string_at(p, n)
        while b"\n" in self._buf:
            line, self._buf = self._buf.split(b"\n", 1)
            s = line.decode("utf-8", "replace")
            self.full.append(s)
            if s[:1].isdigit():
                f = s.split("\t")
                self.rows.append((int(f[0]), int(f[1]), int(f[2]), f[3], f[4]))

    @property
    def fault(self):
        return self.L.engine_fault_text(self.p).decode("latin-1")

    def now(self):
        return self.L.engine_test_now(self.p)

    def run_until(self, ms):
        self.L.engine_test_goto(self.p, ms)
        self.L.engine_test_finish_step(self.p)

    def key(self, vk, down):
        self.L.engine_test_input(self.p, IN_KEYDOWN if down else IN_KEYUP, vk, 0)

    def click(self, label):
        x, y = ctypes.c_int32(), ctypes.c_int32()
        if not self.L.engine_test_button_point(self.p, label.encode("latin-1"), ctypes.byref(x), ctypes.byref(y)):
            raise RuntimeError(f"no clickable button with label {label!r} at {self.now()} ms")
        self.L.engine_test_input(self.p, IN_MOUSEMOVE, x.value, y.value)
        self.L.engine_test_input(self.p, IN_BUTTONDOWN, x.value, y.value)
        self.L.engine_test_input(self.p, IN_BUTTONUP, x.value, y.value)
        return x.value, y.value

    def replay(self, path, ms_end, stop=True):
        """Replay a moeboid-input v1 recording up to ms_end, then Shell_StopApplet (as run.py)."""
        events = []
        for line in open(path):
            if line.startswith("#") or line.startswith("ms\t"):
                continue
            ms, tick, kind, value = line.rstrip("\n").split("\t")
            if kind == "dialog":   # run.py load_replay: every answer is queued at the start
                self.L.engine_test_answer(self.p, value.encode("latin-1"))
                continue
            events.append((int(ms), kind, value))
        i = 0
        while i < len(events):
            ms = events[i][0]
            if ms > ms_end:
                break
            self.L.engine_test_goto(self.p, ms)
            now = self.now()   # every event up to this clock value belongs to this step (core input_due)
            while i < len(events) and events[i][0] <= now and events[i][0] <= ms_end:
                _, kind, value = events[i]
                if kind == "keydown":
                    self.key(KEY_VK[int(value)], True)
                elif kind == "keyup":
                    self.key(KEY_VK[int(value)], False)
                elif kind == "vk":
                    self.key(int(value), True)
                    self.key(int(value), False)
                elif kind == "click":
                    self.click(value)
                elif kind == "event":
                    self.L.engine_applet_event(self.p, 1 if int(value) == 16 else 0)
                i += 1
            self.L.engine_test_finish_step(self.p)
        self.L.engine_test_run_through(self.p, ms_end)
        if stop:
            self.L.engine_applet_stop(self.p)

    def frame(self):
        return ctypes.string_at(self.L.engine_test_frame_ptr(self.p), 800 * 572 * 4)
