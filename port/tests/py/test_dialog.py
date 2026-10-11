#!/usr/bin/env python3
"""Tests for the dialog component (M5a): port/src/shell/dialog*.c, msgbox.c, inputbox.c, tos.c.

Run:  python -I -B port/tests/py/test_dialog.py
1. Build: every M5a source compiles without warnings for the host and for wasm32; the driver
   port/tests/native/test_dialog.c is linked with the needed port sources (not with the engine).
2. C unit tests (driver without mode): geometry, edit behaviour, keyboard navigation, scroll bar,
   MessageBox layout and procedure; port/tests/native/test_dialog_modal.c: shell_modal.c against the
   shell_api.h contract with a stub engine (input_seq, dropped WM_CHAR, "Name too long" loop, repaint).
3. Geometry: client sizes and control rectangles of all 8 templates equal
   assets/ZapSpot.exe/decoded/dialogs.json (pixel values).
4. ToS word wrap: the C line table equals an independent Python model of the same rule (atlas advances
   from the pack); the line count of the full text is printed; the number of lines that a Wine-style
   wrap (trailing spaces must fit) would place differently is reported.
5. Wine references (layout only; analysis/reference): the 10 visible ToS lines and the ToS static text
   are pixel-equal to analysis/reference/screens_monofonts/dialog_terms_of_service.png (same MS Sans
   Serif strike); text bounding boxes of the other captures within 1 px; window placement relative to the
   frame in the desktop captures.
6. Review images: port/tests/results/dialogs/*.png (window images with transparent rounded corners) and
   frame_*.png (window composed over a reference frame capture).
"""
import json
import os
import re
import struct
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(HERE)))
PORT = os.path.join(ROOT, 'port')
from PIL import Image, ImageChops  # noqa: E402

BUILD = os.path.join(PORT, 'build', 'native', 'dialog_test')
RESULTS = os.path.join(PORT, 'tests', 'results', 'dialogs')
DIALOGS = os.path.join(ROOT, 'assets', 'ZapSpot.exe', 'decoded', 'dialogs.json')
REF = os.path.join(ROOT, 'analysis', 'reference')

M5A_SOURCES = ['shell/dialog.c', 'shell/dialog_edit.c', 'shell/dialog_modal.c', 'shell/msgbox.c', 'shell/inputbox.c',
               'shell/tos.c', 'shell/shell_modal.c']
LINK_SOURCES = ['shell/dialog.c', 'shell/dialog_edit.c', 'shell/dialog_modal.c', 'shell/msgbox.c', 'shell/inputbox.c',
                'shell/tos.c', 'shell/luna.c', 'text/atlas.c', 'text/gdi_text.c', 'rt/mem.c']

fails = []
passes = [0]


def check(cond, msg):
    if cond:
        passes[0] += 1
    else:
        fails.append(msg)
        print('FAIL:', msg)


# ---------------------------------------------------------------- build

def build_driver():
    os.makedirs(BUILD, exist_ok=True)
    flags = ['-std=c11', '-O2', '-ffp-contract=off', '-fno-math-errno', '-Wall', '-Wextra', '-Werror',
             '-ffreestanding', '-nostdlibinc', '-I' + os.path.join(PORT, 'src')]
    for src in M5A_SOURCES:
        obj = os.path.join(BUILD, os.path.basename(src)[:-2] + '.wasm.o')
        r = subprocess.run(['clang', '--target=wasm32', '-nostdlib'] + flags + ['-c', os.path.join(PORT, 'src', src),
                                                                                 '-o', obj], capture_output=True, text=True)
        check(r.returncode == 0, 'wasm32 compile %s %s' % (src, r.stderr.strip()[:300]))
    objs = []
    for src in sorted(set(LINK_SOURCES + ['shell/shell_modal.c'])):
        obj = os.path.join(BUILD, os.path.basename(src)[:-2] + '.o')
        r = subprocess.run(['clang'] + flags + ['-fPIC', '-c', os.path.join(PORT, 'src', src), '-o', obj],
                           capture_output=True, text=True)
        check(r.returncode == 0, 'host compile %s %s' % (src, r.stderr.strip()[:300]))
        if src in LINK_SOURCES:
            objs.append(obj)
    exe = os.path.join(BUILD, 'test_dialog')
    subprocess.run(['clang', '-std=c11', '-O2', '-ffp-contract=off', '-Wall', '-Wextra', '-Werror',
                    '-I' + os.path.join(PORT, 'src'), '-I' + os.path.join(PORT, 'tests', 'native'),
                    os.path.join(PORT, 'tests', 'native', 'test_dialog.c')] + objs + ['-o', exe], check=True)
    # integration driver: shell_modal.c with the core (no engine: the test defines the engine API)
    core = sorted('core/' + f for f in os.listdir(os.path.join(PORT, 'src', 'core')) if f.endswith('.c'))
    rt = sorted('rt/' + f for f in os.listdir(os.path.join(PORT, 'src', 'rt')) if f.endswith('.c'))
    objs2 = []
    for src in sorted(set(LINK_SOURCES + core + rt + ['shell/shell_modal.c'])):
        obj = os.path.join(BUILD, 'm_' + src.replace('/', '_')[:-2] + '.o')
        r = subprocess.run(['clang'] + flags + ['-fPIC', '-c', os.path.join(PORT, 'src', src), '-o', obj],
                           capture_output=True, text=True)
        check(r.returncode == 0, 'host compile %s %s' % (src, r.stderr.strip()[:300]))
        objs2.append(obj)
    exe2 = os.path.join(BUILD, 'test_dialog_modal')
    subprocess.run(['clang', '-std=c11', '-O2', '-ffp-contract=off', '-Wall', '-Wextra', '-Werror',
                    '-I' + os.path.join(PORT, 'src'), '-I' + os.path.join(PORT, 'tests', 'native'),
                    os.path.join(PORT, 'tests', 'native', 'test_dialog_modal.c')] + objs2 + ['-o', exe2], check=True)
    return exe, exe2


def run(exe, *args):
    r = subprocess.run([exe] + [str(a) for a in args], capture_output=True, text=True)
    if r.returncode != 0:
        print(r.stdout, r.stderr)
    return r.returncode, r.stdout


# ---------------------------------------------------------------- pack

def pack_entries(path):
    d = open(path, 'rb').read()
    assert d[:4] == b'MPAK'
    n = struct.unpack_from('<I', d, 8)[0]
    p, out = 12, {}
    for _ in range(n):
        ln = struct.unpack_from('<I', d, p)[0]
        name = d[p + 4:p + 4 + ln].decode()
        off, size = struct.unpack_from('<II', d, p + 4 + ln)
        out[name] = d[off:off + size]
        p += 12 + ln
    return out


def get_pack():
    need = ['font/MSSANSSERIF-11-400-MONO', 'font/TAHOMA-11-400-MONO', 'font/TREBUCHETMS-13-700-MONO',
            'data/luna/NORMALBLUE', 'zap/DIALOG/IDD_TERMSOFSERVICE', 'zap/RCDATA/TERMSOFSERVICE']
    path = os.path.join(PORT, 'build', 'web', 'pack.bin')
    if not (os.path.exists(path) and all(k in pack_entries(path) for k in need)):
        out = os.path.join(BUILD, 'pack')
        subprocess.run([sys.executable, '-I', '-B', os.path.join(PORT, 'tools', 'mkpack.py'), '--out', out, '--quiet'],
                       check=True, cwd=ROOT)
        path = os.path.join(out, 'pack.bin')
    ent = pack_entries(path)
    for k in need:
        check(k in ent, 'pack has %s' % k)
    return path, ent


def atlas_advances(blob):
    first, last, dflt = struct.unpack_from('<HHH', blob, 12)
    adv = {}
    for c in range(256):
        cc = c if first <= c <= last else dflt
        adv[c] = struct.unpack_from('<h', blob, 120 + 16 * (cc - first) + 8)[0]
    return adv


# ---------------------------------------------------------------- geometry against dialogs.json

def test_rects(exe, pack):
    rc, out = run(exe, 'rects', pack)
    check(rc == 0, 'driver rects exit code')
    js = json.load(open(DIALOGS))
    got = {}
    clients = {}
    for ln in out.splitlines():
        m = re.match(r'^dialog (\S+) (\d+) (\d+) (.*)$', ln)
        if m:
            clients[m.group(1)] = (int(m.group(2)), int(m.group(3)), m.group(4))
        m = re.match(r'^rect (\S+) (-?\d+) (-?\d+) (-?\d+) (-?\d+) (-?\d+) (\d+)$', ln)
        if m:
            got.setdefault(m.group(1), []).append(tuple(int(v) for v in m.groups()[1:6]))
    check(len(clients) == 8, 'all 8 templates parsed')
    for name, d in js.items():
        bx, by = 6, 13
        cw, ch = (d['cx'] * bx * 2 + 4) // 8, (d['cy'] * by * 2 + 8) // 16  # MulDiv rounding, positive values
        check(clients.get(name, (0, 0))[:2] == (cw, ch), 'client size %s %s = %s' % (name, clients.get(name), (cw, ch)))
        check(clients.get(name, (0, 0, ''))[2] == d['caption'], 'caption %s' % name)
        want = [(it['id_signed'], it['px']['x'], it['px']['y'], it['px']['w'], it['px']['h']) for it in d['items']]
        check(got.get(name) == want, 'control rectangles %s equal dialogs.json' % name)


# ---------------------------------------------------------------- ToS wrap

def wrap_model(text, adv, fw, hanging=True):
    """Independent model of the edit word wrap (rule in dialog_edit.c). hanging=False: Wine-style rule
    (the line including its trailing spaces must fit)."""
    lines = []
    pos, n = 0, len(text)
    while True:
        pend = text.find(b'\r\n', pos)
        if pend < 0:
            pend = n
        while True:
            le = pend
            w, k = 0, 0
            while pos + k < pend and w + adv[text[pos + k]] <= fw:
                w += adv[text[pos + k]]
                k += 1
            if pos + k < pend:
                j = pos + k
                if hanging:
                    if text[j] == 0x20:
                        while j < pend and text[j] == 0x20:
                            j += 1
                        le = j
                    else:
                        jj = j
                        while jj > pos and text[jj - 1] != 0x20:
                            jj -= 1
                        le = pos + max(k, 1) if jj == pos else jj
                else:
                    jj = j
                    while jj > pos and text[jj - 1] != 0x20:
                        jj -= 1
                    le = pos + max(k, 1) if jj == pos else jj
            lines.append((pos, le - pos))
            pos = le
            if pos >= pend:
                break
        if pend >= n:
            break
        pos = pend + 2
    return lines


def test_tos_wrap(exe, pack, ent):
    rc, out = run(exe, 'tos', pack)
    check(rc == 0, 'driver tos exit code')
    fmt = re.search(r'^fmt (\d+) (\d+) (\d+) (\d+) (\d+)$', out, re.M)
    fw = int(fmt.group(3))
    check(fw == 376 and int(fmt.group(5)) == 10, 'ToS formatting width 376, 10 visible lines')
    c_lines = [tuple(int(v) for v in m.groups()) for m in re.finditer(r'^line \d+ (\d+) (\d+)$', out, re.M)]
    text = ent['zap/RCDATA/TERMSOFSERVICE']
    text = text[:text.index(b'\0')] if b'\0' in text else text
    adv = atlas_advances(ent['font/MSSANSSERIF-11-400-MONO'])
    model = wrap_model(text, adv, fw)
    check(c_lines == model, 'ToS line table equals the Python model (%d / %d lines)' % (len(c_lines), len(model)))
    wine = wrap_model(text, adv, fw, hanging=False)
    diff = sum(1 for a, b in zip(model, wine) if a != b) + abs(len(model) - len(wine))
    print('ToS wrap: %d lines at width %d (MS Sans Serif 8); Wine-style rule: %d lines, %d differ' %
          (len(model), fw, len(wine), diff))
    return len(model)


# ---------------------------------------------------------------- review images and Wine comparisons

def read_rgba(path):
    d = open(path, 'rb').read()
    w, h = struct.unpack_from('<II', d)
    return Image.frombytes('RGBA', (w, h), d[8:8 + w * h * 4])


def text_mask(im, box, thr=80):
    im = im.convert('RGB')
    x0, y0, x1, y1 = box
    px = im.load()
    return {(x - x0, y - y0) for y in range(y0, y1) for x in range(x0, x1) if sum(px[x, y]) < 3 * thr}


def bbox(m):
    if not m:
        return None
    xs = [p[0] for p in m]
    ys = [p[1] for p in m]
    return (min(xs), min(ys), max(xs), max(ys))


def find_window(desk, win, guess, radius=12):
    """Position of the Wine dialog capture inside a Wine desktop capture (exact match), near guess."""
    gx, gy = guess
    w, h = win.size
    win = win.convert('RGB')
    desk = desk.convert('RGB')
    for dy in range(-radius, radius + 1):
        for dx in range(-radius, radius + 1):
            x, y = gx + dx, gy + dy
            if x < 0 or y < 0:
                continue
            crop = desk.crop((x, y, x + w, y + 20))
            if ImageChops.difference(crop, win.crop((0, 0, w, 20))).getbbox() is None:
                return x, y
    return None


def test_render(exe, pack):
    os.makedirs(RESULTS, exist_ok=True)
    for f in os.listdir(RESULTS):
        if f.endswith('.png'):
            os.remove(os.path.join(RESULTS, f))
    tmp = os.path.join(BUILD, 'render')
    os.makedirs(tmp, exist_ok=True)
    rc, out = run(exe, 'render', pack, tmp)
    check(rc == 0, 'driver render exit code')
    states = {}
    for m in re.finditer(r'^state (\S+) (-?\d+) (-?\d+) (\d+) (\d+)$', out, re.M):
        states[m.group(1)] = tuple(int(v) for v in m.groups()[1:])
    check(len(states) >= 17, 'render states written (%d)' % len(states))
    imgs = {}
    for name in states:
        im = read_rgba(os.path.join(tmp, name + '.rgba'))
        im.save(os.path.join(RESULTS, name + '.png'), optimize=True)
        imgs[name] = im
    # composition over reference frame captures (frame pixels; window position from the driver)
    bgs = {'inputbox_initial': 'frame_game_play_score20.png', 'quit_saved_initial': 'frame_game_play_score20.png',
           'tos_initial': 'frame_title_first_run.png', 'msgbox_name_too_long': 'frame_game_play_score20.png'}
    for name, bgname in bgs.items():
        bg = Image.open(os.path.join(REF, 'screens', bgname)).convert('RGBA')
        x, y = states[name][:2]
        bg.alpha_composite(imgs[name], (x, y))
        bg.convert('RGB').save(os.path.join(RESULTS, 'frame_' + name + '.png'), optimize=True)

    # rounded caption corners stay transparent; everything else is opaque
    im = imgs['inputbox_initial']
    check(im.getpixel((0, 0))[3] == 0 and im.getpixel((im.width - 1, 0))[3] == 0, 'rounded corners transparent')
    check(im.getpixel((im.width // 2, im.height // 2))[3] == 255, 'window body opaque')

    # 1. ToS against the Wine capture with the same MS Sans Serif strike (pixel-exact text)
    wine = Image.open(os.path.join(REF, 'screens_monofonts', 'dialog_terms_of_service.png'))
    ours = imgs['tos_initial']
    check(wine.size == ours.size, 'ToS window size equals the Wine capture %s' % (wine.size,))
    # client origin (3, 29) in both: Wine border 3, caption 26; Luna frame 3, caption 26 (luna.h)
    edit_text = (3 + 8 + 2 + 1, 29 + 11 + 2 + 1, 3 + 8 + 2 + 1 + 376, 29 + 11 + 2 + 1 + 130)
    a, b = text_mask(wine, edit_text), text_mask(ours, edit_text)
    check(len(a) > 5000 and a == b, 'ToS edit: 10 visible lines pixel-equal to Wine (%d pixels, %d differ)' %
          (len(a), len(a ^ b)))
    static = (3 + 12, 29 + 208, 3 + 419, 29 + 245)
    a, b = text_mask(wine, static), text_mask(ours, static)
    check(len(a) > 1000 and a == b, 'ToS static text pixel-equal to Wine (%d differ)' % len(a ^ b))
    # OK label: same columns (Wine draws a themed button: its label is 1 row lower, ignored)
    lab = (3 + 152 + 30, 29 + 245 + 5, 3 + 152 + 80, 29 + 245 + 18)
    a, b = bbox(text_mask(wine, lab)), bbox(text_mask(ours, lab))
    check(a and b and a[0] == b[0] and a[2] == b[2], 'ToS OK label columns equal Wine %s %s' % (a, b))

    # 2. older captures (Wine's own MS Sans Serif glyphs differ in 'w', 'y'): text bounding boxes
    cmp = [('dialog_high_score_entry.png', 'inputbox_initial', (3 + 6, 29 + 7, 3 + 243, 29 + 40), 'name entry prompt'),
           ('dialog_high_score_entry.png', 'inputbox_initial', (3 + 6 + 3, 29 + 41 + 3, 3 + 6 + 3 + 40, 29 + 41 + 16),
            'name entry selection'),
           ('dialog_game_in_progress.png', 'quit_saved_initial', (3 + 12, 29 + 16, 3 + 285, 29 + 37), 'quit prompt')]
    for wname, oname, box, label in cmp:
        w = Image.open(os.path.join(REF, 'screens', wname))
        o = imgs[oname]
        if label == 'name entry selection':
            # highlight rectangle: COLOR_HIGHLIGHT-like blue pixels
            def blue(im):
                im = im.convert('RGB')
                return bbox({(x, y) for y in range(box[1], box[3]) for x in range(box[0], box[2])
                             if im.getpixel((x, y))[2] > 150 and im.getpixel((x, y))[0] < 110})
            a, b = blue(w), blue(o)
        else:
            a, b = bbox(text_mask(w, box)), bbox(text_mask(o, box))
        ok = a and b and all(abs(p - q) <= 1 for p, q in zip(a, b))
        check(ok, '%s bounding box within 1 px of Wine: wine %s ours %s' % (label, a, b))
        print('  %-22s wine %s ours %s' % (label, a, b))
    # button labels in the older capture (MS Sans Serif "Yes" / "No": columns)
    w = Image.open(os.path.join(REF, 'screens', 'dialog_game_in_progress.png'))
    for label, (bx, by, bw, bh) in (('Yes', (62, 44, 75, 26)), ('No', (153, 44, 75, 26))):
        box = (3 + bx + 6, 29 + by + 6, 3 + bx + bw - 6, 29 + by + bh - 9)
        a, b = bbox(text_mask(w, box)), bbox(text_mask(imgs['quit_saved_initial'], box))
        check(a and b and abs(a[0] - b[0]) <= 1 and abs(a[2] - b[2]) <= 1,
              'button label %s columns within 1 px: wine %s ours %s' % (label, a, b))

    # 3. placement: Wine centres the dialog on the screen; the frame is at (112, 97) in the desktop
    #    captures (Wine's taskbar rectangle makes it 97, not 98). The port centres in the frame.
    for desk, dlg, state in (('desktop_high_score_dialog.png', 'dialog_high_score_entry.png', 'inputbox_initial'),
                             ('desktop_game_in_progress_dialog.png', 'dialog_game_in_progress.png', 'quit_saved_initial'),
                             ('desktop_terms_dialog.png', 'dialog_terms_of_service.png', 'tos_initial')):
        dimg = Image.open(os.path.join(REF, 'screens', desk))
        wimg = Image.open(os.path.join(REF, 'screens', dlg))
        guess = ((1024 - wimg.width) // 2, (768 - wimg.height) // 2)
        pos = find_window(dimg, wimg, guess)
        x, y = states[state][:2]
        if pos:
            rel = (pos[0] - 112, pos[1] - 97)
            check(rel[0] == x and abs(rel[1] - y) <= 1,
                  'placement %s: Wine frame-relative %s, port %s' % (state, rel, (x, y)))
            print('  placement %-20s Wine screen %s frame-relative %s port %s' % (state, pos, rel, (x, y)))
        else:
            print('  placement %s: window not found in %s' % (state, desk))


def main():
    exe, exe2 = build_driver()
    pack, ent = get_pack()
    rc, out = run(exe, pack)
    print(out.strip())
    check(rc == 0, 'C unit tests (test_dialog)')
    rc, out = run(exe2, pack)
    print(out.strip())
    check(rc == 0, 'shell_api integration (test_dialog_modal)')
    test_rects(exe, pack)
    test_tos_wrap(exe, pack, ent)
    test_render(exe, pack)
    print('test_dialog.py: %d passed, %d failed' % (passes[0], len(fails)))
    return 1 if fails else 0


if __name__ == '__main__':
    sys.exit(main())
