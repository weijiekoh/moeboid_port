#!/usr/bin/env python3
"""Tests for the XP Luna dialog frame (workstream LUNA): port/tools/mkluna.py and port/src/shell/luna.c.

Run:  python -I -B port/tests/py/test_luna.py
1. Data: the blob values equal the NORMALBLUE_INI lines (read again here with a separate parser),
   the 8-bit bitmaps equal a PIL decode, the build is deterministic.
2. C renderer (driver port/tests/native/luna_render.c, compiled here with clang): load, colours,
   metrics, geometry (caption height, borders), close button; every pixel of a render without text
   equals a Python model of the same drawing rules (nine-grid, colour key, alpha blend); the caption
   text (M3 atlas Trebuchet MS 13 px bold, smoothing on) changes pixels only inside the text rectangle;
   DT_END_ELLIPSIS fit.
3. Review images: port/tests/results/luna/*.png with caption text (transparent pixels = rounded
   corners outside the window region).
Fonts: port/build/web/pack.bin when it has the Trebuchet atlas, else mkpack.py builds a pack in
port/build/native/luna_test/pack/.
"""
import hashlib
import io
import json
import os
import re
import struct
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(HERE)))
PORT = os.path.join(ROOT, 'port')
sys.path.insert(0, os.path.join(PORT, 'tools'))
import mkluna  # noqa: E402
from PIL import Image  # noqa: E402

BUILD = os.path.join(PORT, 'build', 'native', 'luna_test')
RESULTS = os.path.join(PORT, 'tests', 'results', 'luna')
DIALOGS = os.path.join(ROOT, 'assets', 'ZapSpot.exe', 'decoded', 'dialogs.json')

fails = []
passes = [0]


def check(cond, msg):
    if cond:
        passes[0] += 1
    else:
        fails.append(msg)
        print('FAIL:', msg)


# ---------------------------------------------------------------- data

def ini_lookup(text, section, key):
    """Separate minimal INI reader: value of key in [section] (case-insensitive), comment cut."""
    cur = None
    for raw in text.splitlines():
        line = raw.split(';', 1)[0].strip()
        m = re.match(r'^\[(.+)\]$', line)
        if m:
            cur = m.group(1).strip().lower()
            continue
        if cur == section.lower() and '=' in line:
            k, v = line.split('=', 1)
            if k.strip().lower() == key.lower():
                return v.strip()
    return None


def test_data():
    blob, doc = mkluna.build()
    blob2, _ = mkluna.build()
    check(blob == blob2, 'mkluna output is deterministic')
    sources = open(os.path.join(ROOT, 'fonts', 'SOURCES.md')).read()
    check(doc['source']['sha256'] in sources, 'luna.msstyles sha256 is the one in fonts/SOURCES.md')
    texts, bitmaps = mkluna.load_resources(mkluna.MSSTYLES)
    ini = texts['NORMALBLUE_INI']
    # O1 / SOURCES.md values.
    check(ini_lookup(ini, 'SysMetrics', 'CaptionBarHeight') == '25', 'INI CaptionBarHeight = 25')
    check(ini_lookup(ini, 'SysMetrics', 'CaptionFont') == 'Trebuchet MS, 10, bold', 'INI CaptionFont')
    check(ini_lookup(ini, 'SysMetrics', 'SmallCaptionFont') == 'Tahoma, 8, bold', 'INI SmallCaptionFont')
    check(ini_lookup(ini, 'SysMetrics', 'MsgBoxFont') == 'Tahoma, 8', 'INI MsgBoxFont')
    met = doc['metrics']
    check(met['CaptionBarHeight']['value'] == 25, 'blob CaptionBarHeight = 25')
    check((met['CaptionFont.face']['value'], met['CaptionFont.points']['value'], met['CaptionFont.weight']['value'])
          == (2, 10, 700), 'blob caption font = Trebuchet MS 10 bold')
    check((met['MsgBoxFont.face']['value'], met['MsgBoxFont.points']['value'], met['MsgBoxFont.weight']['value'])
          == (1, 8, 400), 'blob message font = Tahoma 8')
    # Every verified colour equals its INI line; inferred ones are absent from [SysMetrics].
    for name, c in doc['colors'].items():
        m = re.match(r'NORMALBLUE_INI \[(.+?)\] (\w+) = ', c['ref'])
        if c['status'] == 'verified':
            v = ini_lookup(ini, m.group(1), m.group(2))
            check(v is not None and [int(x) for x in v.split()] == c['rgb'], 'colour %s = INI %s' % (name, v))
        else:
            key = [k for _, n, k, _ in mkluna.SYS_COLORS if n == name][0]
            check(ini_lookup(ini, 'SysMetrics', key) is None, 'inferred colour %s is absent from the INI' % name)
    for name, key in (('BTNFACE', 'Btnface'), ('3DLIGHT', 'Light3d'), ('BTNSHADOW', 'BtnShadow'),
                      ('3DDKSHADOW', 'DkShadow3d'), ('BTNHIGHLIGHT', 'BtnHighlight')):
        check(doc['colors'][name]['status'] == 'verified', '%s verified from [SysMetrics] %s' % (name, key))
    check(doc['colors']['BTNFACE']['rgb'] == [236, 233, 216], 'COLOR_3DFACE = 236 233 216 (O1)')
    # Bitmaps: 8-bit images equal a PIL decode (BITMAPFILEHEADER added).
    for name in ('BLUE_FRAMECAPTION_BMP', 'BLUE_FRAMELEFT_BMP', 'BLUE_FRAMERIGHT_BMP', 'BLUE_FRAMEBOTTOM_BMP'):
        d = bitmaps[name]
        hs, _, _, _, bpp, _, _, _, _, clru, _ = struct.unpack_from('<IiiHHIIiiII', d)
        off = 14 + hs + 4 * (clru or (1 << bpp))
        im = Image.open(io.BytesIO(b'BM' + struct.pack('<IHHI', 14 + len(d), 0, 0, off) + d)).convert('RGBA')
        w, h, _, px = mkluna.decode_bmp(d)
        check(im.size == (w, h) and im.tobytes() == px, 'PIL decode equals mkluna decode: %s' % name)
    imgs = doc['images']
    check((imgs['BLUE_FRAMECAPTION_BMP']['w'], imgs['BLUE_FRAMECAPTION_BMP']['h']) == (66, 58), 'caption 66x58')
    check(imgs['BLUE_FRAMECAPTION_BMP']['colorkey_pixels'] == 48, 'caption: 48 magenta pixels (12 per corner)')
    check(imgs['BLUE_CLOSEBUTTON_BMP']['alpha'] and imgs['BLUE_CLOSEGLYPH_BMP']['alpha'], 'close images have alpha')
    check(doc['parts']['Window.CloseButton']['glyph_selected']['file'] == 'Blue\\CloseGlyph.bmp',
          'close glyph = CloseGlyph.bmp (13x13)')
    return blob, doc


# ---------------------------------------------------------------- Python model of luna.c

class Bmp:
    def __init__(self, w, h, px):
        self.w, self.h, self.px = w, h, px


def model_images(blob):
    _, _, _, _, _, np_, ni, _, _, op, oi = struct.unpack_from('<4sHHHHHHIIII', blob)
    imgs = []
    for i in range(ni):
        w, h, flags, bpp, off, ln = struct.unpack_from('<HHHHII', blob, oi + 16 * i)
        imgs.append(Bmp(w, h, blob[off:off + ln]))
    parts = {}
    for i in range(np_):
        r = struct.unpack_from('<HHHBBBBBB4h4h4h2hBBB', blob, op + 48 * i)
        parts[r[0]] = {'image': r[1], 'glyph': r[2], 'count': r[3], 'gcount': r[4], 'sizing_type': r[5],
                       'layout': r[6], 'sizing': r[9:13], 'content': r[13:17], 'caption': r[17:21],
                       'offset': r[21:23]}
    return imgs, parts


def grid_map(d, dst_len, src_len, m0, m1, sizing):
    if sizing == 2:
        return min(d, src_len - 1)
    a, b = m0, m1
    if a + b > dst_len:
        a = dst_len * m0 // (m0 + m1) if m0 + m1 else 0
        b = dst_len - a
    if d < a:
        return d * m0 // a
    if d >= dst_len - b:
        return src_len - m1 + (d - (dst_len - b)) * m1 // b
    ms, md, e = src_len - m0 - m1, dst_len - a - b, d - a
    return m0 + (e % ms if sizing == 1 else e * ms // md)


def put(img, W, x, y, s):
    i = (y * W + x) * 4
    a = s[3]
    if a == 0:
        return
    if a == 255:
        img[i:i + 4] = bytes((s[0], s[1], s[2], 255))
        return
    ia = 255 - a
    for c in range(3):
        img[i + c] = (s[c] * a + 127) // 255 + (img[i + c] * ia + 127) // 255
    img[i + 3] = a + (img[i + 3] * ia + 127) // 255


def blit(img, W, H, b, count, state, m, sizing, rx, ry, rw, rh):
    sw, sh = b.w, b.h // count
    x1, y1 = min(rx + rw, W), min(ry + rh, H)
    if sizing == 2:
        x1, y1 = min(x1, rx + sw), min(y1, ry + sh)
    for y in range(max(ry, 0), y1):
        sy = state * sh + grid_map(y - ry, rh, sh, m[2], m[3], sizing)
        for x in range(max(rx, 0), x1):
            sx = grid_map(x - rx, rw, sw, m[0], m[1], sizing)
            o = (sy * b.w + sx) * 4
            put(img, W, x, y, b.px[o:o + 4])


def model_render(blob, doc, cw, ch, active, close, close_state):
    imgs, parts = model_images(blob)
    frame, top = 3, 3 + doc['metrics']['CaptionBarHeight']['value'] + 1
    W, H = cw + 6, ch + top + 3
    img = bytearray(W * H * 4)
    face = doc['colors']['BTNFACE']['rgb']
    for y in range(top, top + ch):
        for x in range(frame, frame + cw):
            img[(y * W + x) * 4:(y * W + x) * 4 + 4] = bytes(face + [255])
    st = 0 if active else 1
    for pid, rect in ((1, (0, 0, W, top)), (2, (0, top, frame, H - top - frame)),
                      (3, (W - frame, top, frame, H - top - frame)), (4, (0, H - frame, W, frame))):
        p = parts[pid]
        blit(img, W, H, imgs[p['image']], p['count'], st, p['sizing'], p['sizing_type'], *rect)
    if close:
        p = parts[5]
        b = imgs[p['image']]
        bw, bh = b.w, b.h // p['count']
        bx, by = W + p['offset'][0], p['offset'][1]
        s = close_state - 1 + (0 if active else 4)
        blit(img, W, H, b, p['count'], s, p['sizing'], 0, bx, by, bw, bh)
        g = imgs[p['glyph']]
        gw, gh = g.w, g.h // p['gcount']
        c = p['content']
        cx, cy, ccw, cch = bx + c[0], by + c[2], bw - c[0] - c[1], bh - c[2] - c[3]
        blit(img, W, H, g, p['gcount'], s, (0, 0, 0, 0), 2, cx + (ccw - gw) // 2, cy + (cch - gh) // 2, gw, gh)
    return W, H, bytes(img)


# ---------------------------------------------------------------- C driver

def build_driver():
    os.makedirs(BUILD, exist_ok=True)
    port_flags = ['-std=c11', '-O2', '-ffp-contract=off', '-fno-math-errno', '-Wall', '-Wextra', '-Werror',
                  '-ffreestanding', '-nostdlibinc', '-I' + os.path.join(PORT, 'src'), '-fPIC']
    objs = []
    for src in ('shell/luna.c', 'rt/mem.c', 'text/atlas.c', 'text/gdi_text.c'):
        obj = os.path.join(BUILD, os.path.basename(src)[:-2] + '.o')
        subprocess.run(['clang'] + port_flags + ['-c', os.path.join(PORT, 'src', src), '-o', obj], check=True)
        objs.append(obj)
    # The same source must also compile for wasm32 without warnings.
    subprocess.run(['clang', '--target=wasm32', '-nostdlib'] + port_flags[:-1] +
                   ['-c', os.path.join(PORT, 'src', 'shell', 'luna.c'), '-o', os.path.join(BUILD, 'luna.wasm.o')],
                   check=True)
    exe = os.path.join(BUILD, 'luna_render')
    subprocess.run(['clang', '-std=c11', '-O2', '-ffp-contract=off', '-Wall', '-Wextra', '-Werror',
                    '-I' + os.path.join(PORT, 'src'), os.path.join(PORT, 'tests', 'native', 'luna_render.c')] + objs +
                   ['-o', exe], check=True)
    return exe


def run(exe, *args):
    r = subprocess.run([exe] + [str(a) for a in args], capture_output=True, text=True)
    if r.returncode != 0:
        print(r.stdout, r.stderr)
    return r.returncode, r.stdout


def test_info(exe, blob_path, doc):
    rc, out = run(exe, 'info', blob_path)
    check(rc == 0, 'driver info exit code')
    lines = out.split('\n')
    check('load 0' in lines, 'luna_load returns LUNA_OK')
    check('load_short -1' in lines, 'luna_load rejects a 20-byte blob')
    check(any(re.match(r'load_trunc -\d', ln) for ln in lines), 'luna_load rejects a truncated blob')
    check('load_magic -2' in lines, 'luna_load rejects a bad magic')
    colors = {int(m.group(1)): (int(m.group(2), 16), int(m.group(3)))
              for m in re.finditer(r'^color (\d+) ([0-9a-f]{6}) (\d+)$', out, re.M)}
    for name, c in doc['colors'].items():
        r, g, b = c['rgb']
        src = 0 if c['status'] == 'inferred' else (1 if 'SysMetrics' in c['ref'] else 2)
        check(colors.get(c['id']) == ((r << 16) | (g << 8) | b, src), 'C colour %s' % name)
    check(len(colors) == len(doc['colors']), 'C colour count')
    metrics = {int(m.group(1)): int(m.group(2)) for m in re.finditer(r'^metric (\d+) (-?\d+) \d+$', out, re.M)}
    for name, m in doc['metrics'].items():
        check(metrics.get(m['id']) == m['value'], 'C metric %s' % name)
    check('fontpx 13 11' in lines, 'font px: 10 pt = 13 px, 8 pt = 11 px')


def messagebox_client():
    """Client size of MessageBox("We're sorry, but names must be 12 letters or smaller.", "Name too long",
    MB_OK | MB_ICONEXCLAMATION). Inputs verified (Tahoma 3.15 hdmx/VDMX at 11 ppem); layout rule INFERRED
    (NT MessageBox dialog units with the message font: outer margin 7 DLU, icon-text gap 10 DLU,
    button 50x14 DLU, gap above the buttons 7 DLU; icon 32x32)."""
    from fontTools.ttLib import TTFont
    f = TTFont(os.path.join(ROOT, 'fonts', 'tahoma.ttf'))
    hd = f['hdmx'].hdmx[11]
    cmap = f.getBestCmap()
    ext = sum(hd[cmap[ord(c)]] for c in 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
    bx = (ext // 26 + 1) // 2
    asc, desc = f['VDMX'].groups[0][11]
    by = asc - desc
    text_w = sum(hd[cmap[ord(c)]] for c in "We're sorry, but names must be 12 letters or smaller.")

    def muldiv(a, b, c):
        return (a * b + c // 2) // c

    ox, oy = muldiv(7, bx, 4), muldiv(7, by, 8)
    cw = ox + max(32 + muldiv(10, bx, 4) + text_w, muldiv(50, bx, 4)) + ox
    chh = oy + max(32, by) + oy + muldiv(14, by, 8) + oy
    return (bx, by, text_w), (cw, chh)


def save_png(path, w, h, px):
    Image.frombytes('RGBA', (w, h), px).save(path, optimize=True)


def pack_entries(path):
    d = open(path, 'rb').read()
    assert d[:4] == b'MPAK'
    n = struct.unpack_from('<I', d, 8)[0]
    p, out = 12, {}
    for _ in range(n):
        ln = struct.unpack_from('<I', d, p)[0]
        name = d[p + 4:p + 4 + ln].decode('ascii')
        off, size = struct.unpack_from('<II', d, p + 4 + ln)
        out[name] = d[off:off + size]
        p += 4 + ln + 8
    return out


def font_pack(blob):
    """Pack with the caption font atlas: the build pack if it has one, else a fresh mkpack.py run."""
    path = os.path.join(PORT, 'build', 'web', 'pack.bin')
    if not (os.path.exists(path) and 'font/TREBUCHETMS-13-700-MONO' in pack_entries(path)):
        out = os.path.join(BUILD, 'pack')
        subprocess.run([sys.executable, '-I', '-B', os.path.join(PORT, 'tools', 'mkpack.py'), '--out', out,
                        '--quiet'], check=True, capture_output=True, cwd=ROOT)
        path = os.path.join(out, 'pack.bin')
    ent = pack_entries(path)
    check('font/TREBUCHETMS-13-700-MONO' in ent, 'pack has the Trebuchet MS 13 px bold atlas')
    if ent.get('data/luna/NORMALBLUE') != blob:
        print('note: %s has no or an older data/luna/NORMALBLUE (rebuild with port/build.sh pack)' % path)
    return path


def test_fit(exe, pack):
    cap = 'ZapSpot Terms of Service and Privacy Policy'
    rc, out = run(exe, 'fit', pack, 1000, cap)
    m = re.match(r'fit (\d+) (.*)$', out.strip())
    check(rc == 0 and m and m.group(2) == cap, 'fit: caption that fits is unchanged')
    full = int(m.group(1)) if m else 0
    rc, out = run(exe, 'fit', pack, full // 2, cap)
    m = re.match(r'fit (\d+) (.*)$', out.strip())
    check(rc == 0 and m and m.group(2).endswith('...') and int(m.group(1)) <= full // 2
          and cap.startswith(m.group(2)[:-3]), 'fit: long caption cut with "..." within the width (%s)' % out.strip())


def test_render(exe, blob_path, blob, doc, pack):
    dialogs = json.load(open(DIALOGS))
    (bx, by, tw), mb = messagebox_client()
    check((bx, by) == (6, 13), 'Tahoma 8 base units 6x13')
    print('MessageBox (inferred layout): text %d px, client %dx%d' % (tw, mb[0], mb[1]))
    cases = []
    for name, active in (('IDD_INPUT_BOX2', True), ('IDD_INPUT_BOX2', False), ('IDD_QUIT_SAVED', True),
                         ('IDD_TERMSOFSERVICE', True)):
        d = dialogs[name]
        check(not d['style'] & 0x00080000, '%s has no WS_SYSMENU (no close button)' % name)
        cap = 'Congratulations' if name == 'IDD_INPUT_BOX2' else d['caption']   # INPUT_BOX2: set by the game
        cases.append(('%s_%s' % (name.lower(), 'active' if active else 'inactive'),
                      d['client_px']['w'], d['client_px']['h'], active, False, 1, cap))
    cases.append(('messagebox_name_too_long_active', mb[0], mb[1], True, True, 1, 'Name too long'))
    cases.append(('messagebox_name_too_long_inactive', mb[0], mb[1], False, True, 1, 'Name too long'))
    os.makedirs(RESULTS, exist_ok=True)
    face = tuple(doc['colors']['BTNFACE']['rgb'])
    for tag, cw, ch, active, close, cstate, cap in cases:
        out = os.path.join(BUILD, tag + '.rgba')
        rc, so = run(exe, 'render', blob_path, '-', out, cw, ch, int(active), int(close), cstate, cap)
        check(rc == 0, '%s: driver exit code' % tag)
        raw = open(out, 'rb').read()
        W, H = struct.unpack_from('<II', raw)
        px = raw[8:]
        g = [int(x) for x in re.findall(r'-?\d+', re.search(r'^geom .*$', so, re.M).group(0))]
        # geom W H frame F top T caption_h C client x y w h text x y w h close x y w h
        check((W, H) == (cw + 6, ch + 32), '%s: window = client + (6, 32): %dx%d' % (tag, W, H))
        check(g[2] == 3 and g[3] == 29 and g[4] == 26, '%s: frame 3, top 29, SM_CYCAPTION 26 = 25 + 1' % tag)
        check(g[5:9] == [3, 29, cw, ch], '%s: client rect' % tag)
        check(g[9:13] == [7, 3, (W - 25 if close else W - 3) - 3 - 7, 26], '%s: caption text rect %s' % (tag, g[9:13]))
        check(g[13:17] == ([W - 25, 5, 21, 21] if close else [0, 0, 0, 0]), '%s: close button rect' % tag)
        # Pixel-exact equality with the Python model.
        mw, mh, mpx = model_render(blob, doc, cw, ch, active, close, cstate)
        diff = sum(1 for i in range(0, len(px), 4) if px[i:i + 4] != mpx[i:i + 4]) if (mw, mh) == (W, H) else -1
        check(diff == 0, '%s: C pixels equal the Python model (%d differ)' % (tag, diff))

        def at(x, y):
            i = (y * W + x) * 4
            return tuple(px[i:i + 4])
        # Client area = COLOR_3DFACE (INI Btnface).
        check(all(at(x, y) == face + (255,) for y in (29, 29 + ch // 2, 28 + ch) for x in (3, 3 + cw // 2, 2 + cw)),
              '%s: client = Btnface 236 233 216' % tag)
        # Rounded top corners: 24 transparent pixels (window region), all others opaque.
        alpha0 = sum(1 for i in range(3, len(px), 4) if px[i] == 0)
        check(alpha0 == 24 and at(0, 0)[3] == 0 and at(W - 1, 0)[3] == 0 and at(4, 0)[3] == 0 and at(5, 0)[3] == 255,
              '%s: 24 corner pixels transparent' % tag)
        # Frame colours (constant source columns of BLUE_FRAMELEFT/RIGHT_BMP, 5 px squeezed to 3).
        if active:
            check(at(0, H // 2)[:3] == (0x00, 0x19, 0xcf) and at(1, H // 2)[:3] == (0x16, 0x6a, 0xee)
                  and at(2, H // 2)[:3] == (0x08, 0x55, 0xdd), '%s: left frame 0019cf 166aee 0855dd' % tag)
            check(at(W - 3, H // 2)[:3] == (0x00, 0x48, 0xf1) and at(W - 1, H // 2)[:3] == (0x00, 0x13, 0x8c),
                  '%s: right frame 0048f1 .. 00138c' % tag)
            check(at(W // 2, H - 1)[:3] == (0x00, 0x13, 0x8c), '%s: bottom frame outer row 00138c' % tag)
            # Caption: mean colour near [Window.Caption] FillColorHint 0 84 229 ("average background").
            n, acc = 0, [0, 0, 0]
            for y in range(3, 29):
                for x in range(28, W - 35):
                    for c in range(3):
                        acc[c] += at(x, y)[c]
                    n += 1
            mean = [a // n for a in acc]
            check(all(abs(m - f) <= 24 for m, f in zip(mean, (0, 84, 229))),
                  '%s: caption mean %s near FillColorHint 0 84 229' % (tag, mean))
        else:
            check(at(0, H // 2)[:3] == (0x5b, 0x68, 0xcd), '%s: inactive left frame 5b68cd' % tag)
        if close:
            check(at(W - 25 + 10, 5 + 10)[3] == 255 and at(W - 25 + 10, 5 + 10) != at(W - 30, 15),
                  '%s: close button drawn' % tag)
        # Caption text (M3 GDI text): changes only pixels inside the text rectangle (+ shadow offset).
        tout = os.path.join(BUILD, tag + '.text.rgba')
        rc, _ = run(exe, 'render', blob_path, pack, tout, cw, ch, int(active), int(close), cstate, cap)
        tpx = open(tout, 'rb').read()[8:]
        tx, ty, tw, th = g[9:13]
        sh = 1 if active else 0
        changed = [(i // 4 % W, i // 4 // W) for i in range(0, len(px), 4) if px[i:i + 4] != tpx[i:i + 4]]
        check(rc == 0 and len(changed) > 50, '%s: caption text drawn (%d pixels)' % (tag, len(changed)))
        check(all(tx <= x < tx + tw + sh and ty <= y < ty + th + sh for x, y in changed),
              '%s: caption text inside its rectangle' % tag)
        if changed:
            print('%s: text rows %d..%d, columns %d..%d' % (tag, min(y for _, y in changed), max(y for _, y in changed),
                                                            min(x for x, _ in changed), max(x for x, _ in changed)))
        save_png(os.path.join(RESULTS, tag + '.png'), W, H, tpx)
    # Zoomed review crop: MessageBox caption right end with the close button, x4.
    im = Image.open(os.path.join(RESULTS, 'messagebox_name_too_long_active.png'))
    im.crop((im.width - 48, 0, im.width, 36)).resize((192, 144), Image.NEAREST).save(
        os.path.join(RESULTS, 'messagebox_close_x4.png'), optimize=True)


def main():
    blob, doc = test_data()
    blob_path = os.path.join(BUILD, 'normalblue.bin')
    os.makedirs(BUILD, exist_ok=True)
    with open(blob_path, 'wb') as f:
        f.write(blob)
    exe = build_driver()
    test_info(exe, blob_path, doc)
    pack = font_pack(blob)
    test_fit(exe, pack)
    test_render(exe, blob_path, blob, doc, pack)
    print('test_luna: %d passed, %d failed' % (passes[0], len(fails)))
    print('blob sha256 %s, %d bytes' % (hashlib.sha256(blob).hexdigest(), len(blob)))
    return 1 if fails else 0


if __name__ == '__main__':
    sys.exit(main())
