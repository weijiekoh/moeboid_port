"""Frame check of M4: the title screen of the port engine against the Wine capture of the original.

Reference: analysis/reference/screens_monofonts/frame_title_installed.png (Wine, renderer no3d,
FONT_SMOOTHING=off, real Arial 2.82; tools/INFRA.md 3). Port: the engine's frame buffer (root
surface image, before the shell's composition) 3 s after the start, text smoothing off, empty
settings store (the default high-score table, as in the capture).
Compared: the game area (282, 50)-(782, 470). Allowed differences:
  - the two title sprites that move along their path (frame (490..563, 392..433)): the capture time
    is not known;
  - the underline rows of "Top Moeboids" (frame (336..462, 255..257)) and "Start" ((536..593, 265..268)): Wine
    draws them one row higher (and 1 px shorter at 18 px) than gdi_text.c; Wine is not GDI, and
    the GDI underline rule of gdi_text.c is inferred (port/tools/README.md "Unproven").
Every other pixel must be equal (images, colour keys, ZML-lite text of the game, monochrome glyphs,
fills). Writes port/tests/results/m4_title_vs_wine.png (red = different). Exit 0 on success.
"""
import ctypes
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import enginedrv  # noqa: E402
from PIL import Image  # noqa: E402

REF = os.path.join(enginedrv.ROOT, "analysis", "reference", "screens_monofonts", "frame_title_installed.png")
OUT = os.path.join(HERE, "..", "results", "m4_title_vs_wine.png")


def allowed(x, y):
    if 490 <= x <= 563 and 392 <= y <= 433:
        return True
    return (336 <= x <= 462 and 255 <= y <= 257) or (536 <= x <= 593 and 265 <= y <= 268)


def main():
    e = enginedrv.NativeEngine(trace=0)
    L = e.L
    L.engine_test_smoothing.argtypes = [ctypes.c_void_p, ctypes.c_bool]
    L.engine_test_root_pixels.argtypes = [ctypes.c_void_p]
    L.engine_test_root_pixels.restype = ctypes.c_void_p
    L.engine_test_smoothing(e.p, False)
    L.engine_test_goto(e.p, 10)
    L.engine_new_game(e.p)          # the title texts are drawn at start: start again without smoothing
    L.engine_test_finish_step(e.p)
    e.run_until(3000)
    px = ctypes.string_at(L.engine_test_root_pixels(e.p), 800 * 572 * 4)
    a = Image.frombytes("RGBA", (800, 572), px).convert("RGB").load()
    b = Image.open(REF).convert("RGB").load()
    vis = Image.new("RGB", (500, 420))
    v = vis.load()
    same = diff_ok = diff_bad = 0
    for y in range(50, 470):
        for x in range(282, 782):
            if a[x, y] == b[x, y]:
                same += 1
                v[x - 282, y - 50] = tuple(c // 3 for c in a[x, y])
            elif allowed(x, y):
                diff_ok += 1
                v[x - 282, y - 50] = (255, 160, 0)
            else:
                diff_bad += 1
                v[x - 282, y - 50] = (255, 0, 0)
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    vis.save(OUT)
    print(f"game area 500x420: equal {same}, different in the allowed regions {diff_ok}, other differences "
          f"{diff_bad}; image {os.path.normpath(OUT)}")
    print("result: " + ("PASS" if diff_bad == 0 else "FAIL"))
    return 0 if diff_bad == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
