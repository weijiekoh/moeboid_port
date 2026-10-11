#!/usr/bin/env python3
"""Shell frame states of the port (M5b) against the Wine references with monochrome text.

Runs port/build/native/test_shell (font smoothing off; build it first with port/build.sh native), which
writes raw RGBA frames to port/build/shell_frames/. Converts them to PNG in port/tests/results/shell/ and
compares each frame with its Wine capture in analysis/reference/screens_monofonts/ (made with
port/tests/py/test_shell_wine_steps.txt, same click sequence). Masks cover the intended differences:

  removed   minimise/close buttons (decision 8a), Mail This rail button (decision 7: empty slot),
            subscribe box with its texts, e-mail box and arrow (network; the ToS link inside stays),
            advertiser caption and ad banner (decision 9), promo tiles of View All Games (decision 6),
            proxy section of Personalize (decision 8c)
  dynamic   the game surface while the game shows (title animation, play)
  dialog    the dialog windows (Wine theme versus Windows XP Luna, M5a)

Output: port/tests/results/shell/<state>.png (port), diff_<state>.png (red = different, grey = masked),
compare.txt (per state: pixels compared, pixels different outside the masks, difference boxes).
Exit status 1 when a state differs outside its masks or a reference is missing.
Run: python -I -B port/tests/py/test_shell_compare.py
"""
import os
import struct
import subprocess
import sys

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
BIN = os.path.join(ROOT, 'port/build/native/test_shell')
RAW = os.path.join(ROOT, 'port/build/shell_frames')
OUT = os.path.join(ROOT, 'port/tests/results/shell')
REF = os.path.join(ROOT, 'analysis/reference/screens_monofonts')
SPLASH = os.path.join(ROOT, 'assets/ZapSpot.exe/decoded/BITMAP/IMG-SPLASH_0409.png')
W, H = 800, 572

# Frame rectangles [x0, y0, x1) x [y0, y1)
MIN_CLOSE = ('min/close removed (8a)', (734, 9, 790, 36))
MAIL = ('Mail This removed (7)', (195, 85, 272, 147))
SUBSCRIBE = ('subscribe box removed', (11, 382, 231, 546))
TOS_LINK = (31, 526, 212, 538)  # kept inside the subscribe box: compared
ADS = ('ad caption and banner removed (9)', (279, 484, 800, 566))
GAME = ('game surface (animation)', (282, 50, 782, 470))
PROMO = [('promo tile removed (6)', (282 + 5 + (i % 5) * 100, 50 + 20 + (i // 5) * 88,
                                     282 + 5 + (i % 5) * 100 + 92, 50 + 20 + (i // 5) * 88 + 82)) for i in range(1, 6)]
PROXY = ('proxy section removed (8c)', (282, 332, 782, 420))
QUIT_DLG = ('dialog (Wine theme vs Luna)', (245, 226, 555, 346))
TOS_DLG = ('dialog (Wine theme vs Luna)', (184, 128, 615, 444))
COMMON = [MIN_CLOSE, MAIL, SUBSCRIBE, ADS]

# state -> (reference file, crop origin in the reference or None, extra masks)
STATES = [
    ('title', 'frame_title_m5b.png', None, [GAME]),
    ('how_to_play', 'frame_how_to_play.png', None, []),
    ('paused', 'frame_paused.png', None, []),
    ('help_101', 'frame_help_101.png', None, []),
] + [('help_%d' % i, 'frame_help_%d.png' % i, None, []) for i in range(111, 119)] + [
    ('about', 'frame_about.png', None, []),
    ('personalize_sound_on', 'frame_personalize_sound_on.png', None, [PROXY]),
    ('personalize_sound_off', 'frame_personalize_sound_off.png', None, [PROXY]),
    ('view_all_games', 'frame_view_all_games.png', None, PROMO),
    ('title_again', 'frame_title_again.png', None, [GAME]),
    ('game_running', 'frame_game_running.png', None, [GAME]),
    ('quit_dialog', 'desktop_quit_dialog.png', (112, 97), [GAME, QUIT_DLG]),
    ('tos_dialog', 'desktop_tos_dialog.png', (112, 97), [GAME, TOS_DLG]),
]


def load_raw(name):
    with open(os.path.join(RAW, name + '.rgba'), 'rb') as f:
        d = f.read()
    w, h = struct.unpack_from('<II', d, 4)
    return Image.frombytes('RGBA', (w, h), d[12:]).convert('RGB')


def mask_of(extra):
    m = bytearray(W * H)  # 1 = masked
    for _, (x0, y0, x1, y1) in COMMON + extra:
        for y in range(max(0, y0), min(H, y1)):
            m[y * W + max(0, x0):y * W + min(W, x1)] = b'\1' * (min(W, x1) - max(0, x0))
    x0, y0, x1, y1 = TOS_LINK
    for y in range(y0, y1):
        m[y * W + x0:y * W + x1] = b'\0' * (x1 - x0)
    return m


def boxes(diff):
    """Bounding boxes of 8-connected difference clusters (cells of 4 x 4 merged)."""
    cells = {}
    for i in diff:
        cells.setdefault(((i % W) // 4, (i // W) // 4), []).append(i)
    seen, out = set(), []
    for c in cells:
        if c in seen:
            continue
        stack, xs, ys, n = [c], [], [], 0
        seen.add(c)
        while stack:
            cx, cy = stack.pop()
            for i in cells[(cx, cy)]:
                xs.append(i % W)
                ys.append(i // W)
                n += 1
            for dx in (-1, 0, 1):
                for dy in (-1, 0, 1):
                    k = (cx + dx, cy + dy)
                    if k in cells and k not in seen:
                        seen.add(k)
                        stack.append(k)
        out.append((min(xs), min(ys), max(xs) + 1, max(ys) + 1, n))
    return sorted(out, key=lambda b: (b[1], b[0]))


def px(img, x, y):
    i = 3 * (y * W + x)
    return img[i:i + 3]


def shift_only(a, b, box):
    """True when the box is text that only moved: the port pixels moved by dx in -2..2 equal the reference
    except at most 2 pixels per row (the underline is drawn across the text extent, so a 1-px extent
    difference leaves 1 underline pixel)."""
    x0, y0, x1, y1, _ = box
    xa, xb = max(0, x0 - 3), min(W, x1 + 3)
    best = None
    for dx in range(-2, 3):
        bad = 0
        for y in range(y0, y1):
            for x in range(xa, xb):
                pa = px(a, x - dx, y) if 0 <= x - dx < W else b'\0\0\0'
                bad += pa != px(b, x, y)
        best = bad if best is None else min(best, bad)
    return best <= 2 * (y1 - y0)


# Colours of shell and game text and of the plain backgrounds under it (ZML strings, fonts.md 6.6, 8.1).
TEXT_COLOURS = {bytes(c) for c in (
    (255, 255, 255), (0, 0, 0), (255, 255, 0x33), (255, 0xf0, 0), (0, 255, 255), (0x99, 0x99, 0x99),
    (255, 0x33, 0x33), (0x66, 0x66, 255), (0x33, 255, 0x33), (255, 0, 0), (0x33, 0x33, 255),
    (0x33, 0x33, 0xcc), (255, 0xcc, 0), (0, 0, 0x99), (0x33, 0x33, 0x33),
    (4, 4, 4))}  # (4, 4, 4): IMG-TM.GIF, placed at the text extent (Z:0x423e35)
# Grey glyph pixels over the black page: (text * v + 8) >> 4, v = 1..15 (gdi_text.h, decision O6).
GREY_BLENDS = {bytes(((c[0] * v + 8) >> 4, (c[1] * v + 8) >> 4, (c[2] * v + 8) >> 4))
               for c in ((255, 255, 255), (255, 0x33, 0x33)) for v in range(1, 16)}


def text_only(a, b, box):
    """True when the box (port and reference) holds only text colours and plain backgrounds: glyph shapes,
    advances and line breaks (Wine's text rendering differs from the GDI model, NOTES.md 'Wine font
    rendering is not Windows GDI')."""
    x0, y0, x1, y1, _ = box
    return all(px(a, x, y) in TEXT_COLOURS and px(b, x, y) in TEXT_COLOURS
               for y in range(y0, y1) for x in range(x0, x1))


def grey_text(a, b, box):
    """True when the port box holds greyscale-smoothed glyph pixels where the reference has monochrome text:
    game text drawn by the engine with font smoothing on (decision 4b; the Wine reference has it off)."""
    x0, y0, x1, y1, _ = box
    if not all(px(b, x, y) in TEXT_COLOURS for y in range(y0, y1) for x in range(x0, x1)):
        return False
    return any(px(a, x, y) in GREY_BLENDS for y in range(y0, y1) for x in range(x0, x1))


def compare(name, ref_file, crop, extra, lines):
    port = load_raw(name)
    port.save(os.path.join(OUT, name + '.png'))
    path = os.path.join(REF, ref_file)
    if not os.path.exists(path):
        lines.append('%-22s reference missing: %s' % (name, ref_file))
        return False
    ref = Image.open(path).convert('RGB')
    if crop:
        ref = ref.crop((crop[0], crop[1], crop[0] + W, crop[1] + H))
    m = mask_of(extra)
    a, b = port.tobytes(), ref.tobytes()
    diff = []
    for y in range(H):  # rows that are equal cost one comparison
        ra, rb = a[3 * W * y:3 * W * (y + 1)], b[3 * W * y:3 * W * (y + 1)]
        if ra == rb:
            continue
        for x in range(W):
            i = y * W + x
            if not m[i] and ra[3 * x:3 * x + 3] != rb[3 * x:3 * x + 3]:
                diff.append(i)
    compared = W * H - sum(m)
    # picture: masked area grey (half brightness), differences red
    grey = port.convert('L').point(lambda v: v // 2).convert('RGB')
    vis = Image.composite(grey, port, Image.frombytes('L', (W, H), bytes(255 * v for v in m)))
    red = bytearray(W * H)
    for i in diff:
        red[i] = 255
    vis = Image.composite(Image.new('RGB', (W, H), (255, 0, 0)), vis, Image.frombytes('L', (W, H), bytes(red)))
    vis.save(os.path.join(OUT, 'diff_' + name + '.png'))
    bx = boxes(diff)
    shifted = [bb for bb in bx if shift_only(a, b, bb)]
    layout = [bb for bb in bx if bb not in shifted and text_only(a, b, bb)]
    greys = [bb for bb in bx if bb not in shifted and bb not in layout and grey_text(a, b, bb)]
    other = [bb for bb in bx if bb not in shifted and bb not in layout and bb not in greys]
    nshift, nlay, ngrey = sum(bb[4] for bb in shifted), sum(bb[4] for bb in layout), sum(bb[4] for bb in greys)
    lines.append('%-22s %-31s compared %6d  different %5d  text moved %5d  glyphs/breaks %5d  game grey text %4d  '
                 'other %4d' % (name, ref_file, compared, len(diff), nshift, nlay, ngrey,
                                len(diff) - nshift - nlay - ngrey))
    for kind, lst in (('glyphs/breaks', layout), ('game grey', greys), ('other', other)):
        for x0, y0, x1, y1, n in lst:
            lines.append('    %-13s (%d, %d)-(%d, %d): %d px' % (kind, x0, y0, x1, y1, n))
    return not other


def check_splash(lines):
    """Splash: bitmap at the canvas centre equals IMG-SPLASH (decoded by the asset workstream), outside
    the four text lines; the canvas around it is black."""
    port = load_raw('splash')
    port.save(os.path.join(OUT, 'splash.png'))
    if not os.path.exists(SPLASH):
        lines.append('splash                 reference bitmap missing')
        return False
    ref = Image.open(SPLASH).convert('RGB')
    ox, oy = (W - 400) // 2, (H - 240) // 2
    a = port.crop((ox, oy, ox + 400, oy + 240)).tobytes()
    b = ref.tobytes()
    text = (85, 172, 400, 172 + 4 * 14)  # opaque text cells of the four lines (glyph overhang from x 89)
    diff = n = 0
    for y in range(240):
        for x in range(400):
            if text[0] <= x < text[2] and text[1] <= y < text[3]:
                continue
            n += 1
            i = 3 * (y * 400 + x)
            diff += a[i:i + 3] != b[i:i + 3]
    full = port.tobytes()
    outside = sum(1 for y in range(H) for x in range(W)
                  if not (ox <= x < ox + 400 and oy <= y < oy + 240) and full[3 * (y * W + x):3 * (y * W + x) + 3] != b'\0\0\0')
    lines.append('%-22s ref %-32s compared %6d  different %5d  (non-black outside: %d)' %
                 ('splash', 'IMG-SPLASH_0409.png', n, diff, outside))
    return diff == 0 and outside == 0


def main():
    if not os.path.exists(BIN):
        print('test_shell_compare: %s missing (run port/build.sh native)' % BIN)
        return 1
    os.makedirs(OUT, exist_ok=True)
    env = dict(os.environ, SHELL_OUT=RAW)
    r = subprocess.run([BIN], env=env, capture_output=True, text=True)
    sys.stdout.write(r.stdout[-400:])
    if r.returncode != 0:
        sys.stdout.write(r.stderr)
        print('test_shell_compare: test_shell failed')
        return 1
    lines, ok = [], True
    ok &= check_splash(lines)
    for name, ref, crop, extra in STATES:
        ok &= compare(name, ref, crop, extra, lines)
    text = '\n'.join(lines) + '\n'
    with open(os.path.join(OUT, 'compare.txt'), 'w') as f:
        f.write(text)
    sys.stdout.write(text)
    print('test_shell_compare: %s' % ('pass' if ok else 'differences outside the masks'))
    return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(main())
