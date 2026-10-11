#!/usr/bin/env python3
"""M3 gates (b), (c), (d) and text layout tests.
  (b) every mono atlas of pack.bin: advances equal hdmx for every (size, char) present; ink extents of the
      cp1252 glyphs equal VDMX (Arial: required; other faces: reported); fonts.md 10.3 reproduction;
      Arial metrics equal the fonts.md 10.4 table.
  (c) MS Sans Serif atlas equals the FNT bitmaps of fonts/sserife.fon (independent reader), and the C
      renderer reproduces them.
  (d) GetTextExtentPoint32A, OPAQUE cell fill, underline rows, glyph placement, clipping, grey blend,
      PNG renders for review in port/tests/results/.
  Pack determinism: two mkpack runs give the same bytes.
Run: python -I -B port/tests/py/test_atlas.py   (needs port/build/web/pack.bin; exit status 0 = pass)
"""
import hashlib
import os
import struct
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
PORT = os.path.dirname(os.path.dirname(HERE))
ROOT = os.path.dirname(PORT)
sys.path.insert(0, os.path.join(PORT, 'tools'))
import mkatlas  # noqa: E402
import mkpack  # noqa: E402

NATIVE = os.path.join(PORT, 'build', 'native')
RENDER = os.path.join(NATIVE, 'text_render')
PACK = os.path.join(PORT, 'build', 'web', 'pack.bin')
RESULTS = os.path.join(PORT, 'tests', 'results')
FAIL = []

# fonts.md 10.4: px: ascent, descent, tmHeight, external leading, space, '.', '0', underline offset, thickness
FONTS_MD_104 = {
    400: {8: (8, 2, 10, 0, 2, 2, 4, 1, 1), 10: (10, 3, 13, 0, 3, 3, 6, 1, 1), 11: (11, 3, 14, 0, 3, 3, 6, 1, 1),
          12: (12, 3, 15, 0, 3, 3, 7, 1, 1), 14: (13, 3, 16, 0, 4, 4, 8, 1, 1), 18: (17, 4, 21, 1, 5, 5, 10, 2, 1),
          24: (21, 6, 27, 1, 7, 7, 13, 3, 2), 36: (33, 8, 41, 1, 10, 10, 20, 4, 3)},
    700: {8: (8, 2, 10, 0, 2, 2, 4, 1, 1), 10: (10, 2, 12, 0, 3, 3, 6, 1, 1), 11: (11, 3, 14, 0, 3, 3, 6, 1, 1),
          12: (12, 3, 15, 0, 3, 3, 7, 1, 1), 14: (13, 3, 16, 0, 4, 4, 8, 1, 1), 18: (17, 4, 21, 1, 5, 5, 10, 2, 2),
          24: (23, 6, 29, 1, 7, 7, 13, 3, 3), 36: (34, 9, 43, 1, 10, 10, 20, 4, 4)},
}


def check(cond, msg):
    print(('ok   ' if cond else 'FAIL ') + msg)
    if not cond:
        FAIL.append(msg)


def build():
    os.makedirs(NATIVE, exist_ok=True)
    srcs = [os.path.join(PORT, 'tests', 'native', 'text_render.c'), os.path.join(PORT, 'src', 'text', 'atlas.c'),
            os.path.join(PORT, 'src', 'text', 'gdi_text.c')]
    subprocess.run([os.environ.get('CC', 'cc'), '-O2', '-std=c11', '-Wall', '-Wextra', '-Werror',
                    '-ffp-contract=off', '-o', RENDER] + srcs, check=True)


def read_pack(path):
    d = open(path, 'rb').read()
    assert d[:4] == b'MPAK'
    ver, n = struct.unpack_from('<II', d, 4)
    p = 12
    out = {}
    for i in range(n):
        ln, = struct.unpack_from('<I', d, p)
        name = d[p + 4:p + 4 + ln].decode('ascii')
        off, sz = struct.unpack_from('<II', d, p + 4 + ln)
        out[name] = d[off:off + sz]
        p += 12 + ln
    return d, out


def cmap_glyph(d, t):
    off = t['cmap'][0]
    n = struct.unpack_from('>H', d, off + 2)[0]
    for i in range(n):
        pid, eid, so = struct.unpack_from('>HHI', d, off + 4 + 8 * i)
        if pid == 3 and eid == 1:
            s = off + so
            assert struct.unpack_from('>H', d, s)[0] == 4
            seg = struct.unpack_from('>H', d, s + 6)[0] // 2
            ends = struct.unpack_from('>%dH' % seg, d, s + 14)
            starts = struct.unpack_from('>%dH' % seg, d, s + 16 + 2 * seg)
            deltas = struct.unpack_from('>%dh' % seg, d, s + 16 + 4 * seg)
            rpos = s + 16 + 6 * seg
            ro = struct.unpack_from('>%dH' % seg, d, rpos)

            def g(c):
                for k in range(seg):
                    if starts[k] <= c <= ends[k]:
                        if ro[k] == 0:
                            return (c + deltas[k]) & 0xffff
                        gi = struct.unpack_from('>H', d, rpos + 2 * k + ro[k] + 2 * (c - starts[k]))[0]
                        return (gi + deltas[k]) & 0xffff if gi else 0
                return 0
            return g


class Renderer:
    def __init__(self):
        self.p = subprocess.Popen([RENDER, PACK], stdin=subprocess.PIPE, stdout=subprocess.PIPE)

    def cmd(self, line):
        self.p.stdin.write(line.encode('latin-1') + b'\n')
        self.p.stdin.flush()
        out = []
        while True:
            r = self.p.stdout.readline().decode('latin-1').rstrip('\n')
            if r.startswith('ok') or r.startswith('err'):
                if r.startswith('err'):
                    raise RuntimeError('%s: %s' % (line, r))
                return out, r[3:]
            out.append(r)

    def image(self):
        fd, path = tempfile.mkstemp(suffix='.rgba')
        os.close(fd)
        self.cmd('save ' + path)
        d = open(path, 'rb').read()
        os.unlink(path)
        w, h = struct.unpack_from('<II', d, 4)
        px = [tuple(d[12 + 4 * i:16 + 4 * i]) for i in range(w * h)]
        return w, h, px

    def close(self):
        self.p.stdin.close()
        self.p.wait()


# ---------------------------------------------------------------- (b)

def gate_b(atl):
    print('== (b) atlas advances against hdmx, ink extents against VDMX')
    ok103 = mkatlas.verify_fonts_md(print)
    print('note: fonts.md 10.3 reproduction %s (FreeType hinted advances; the atlases take hdmx widths, see '
          'README)' % ('passes' if ok103 else 'shows FreeType/hdmx differences'))
    tot_adv = bad_adv = 0
    for name, a in sorted(atl.items()):
        if a['flags'] & mkatlas.F_RASTER:
            continue
        fname = a['source'].split(' ')[0]
        f = mkatlas.TTF(mkatlas.find_font(fname))
        g = cmap_glyph(f.data, f.t)
        if a['mode'] == mkatlas.MODE_MONO:
            if a['px'] in f.hdmx:
                w = f.hdmx[a['px']]
                bad = [c for c in range(256) if a['glyphs'][c]['adv'] != w[g(mkatlas.cp1252_unicode(c))]]
                tot_adv += 256
                bad_adv += len(bad)
                check(not bad, '%s advances = hdmx for 256 codes (mismatches %s)' % (name, bad[:8]))
            if a['px'] in f.vdmx:
                ink = [(a['glyphs'][c]['top'], a['glyphs'][c]['top'] - a['glyphs'][c]['h']) for c in range(0x20, 0x100)
                       if mkatlas.cp1252_defined(c) and g(mkatlas.cp1252_unicode(c)) and a['glyphs'][c]['h']]
                ext = (max(t for t, b in ink), min(b for t, b in ink))
                vd = f.vdmx[a['px']]
                if fname.lower().startswith('arial'):
                    check(ext == vd, '%s cp1252 ink extents %s = VDMX %s' % (name, ext, vd))
                else:
                    print('info %s cp1252 ink extents %s, VDMX %s (VDMX of this face spans more glyphs)'
                          % (name, ext, vd) if ext != vd else 'ok   %s cp1252 ink extents %s = VDMX %s' % (name, ext, vd))
                check((a['ascent'], -a['descent']) == vd, '%s tmAscent/tmDescent from VDMX' % name)
            gname = name.replace('-MONO', '-GRAY')
            check(bool(a['flags'] & mkatlas.F_GASP_DOGRAY) == (gname in atl),
                  '%s gasp DOGRAY flag %d, grey atlas present %d' % (name, bool(a['flags'] & mkatlas.F_GASP_DOGRAY),
                                                                     gname in atl))
            check(all(v in (0, 1) for gl in a['glyphs'].values() for v in gl['cov']), '%s coverage 0/1' % name)
            if fname.lower().startswith('arial') and a['face'] == 'Arial':
                exp = FONTS_MD_104[a['weight']][a['px']]
                got = (a['ascent'], a['descent'], a['height'], a['ext_leading'], a['glyphs'][0x20]['adv'],
                       a['glyphs'][0x2e]['adv'], a['glyphs'][0x30]['adv'], a['ul_offset'], a['ul_thickness'])
                check(got == exp, '%s metrics = fonts.md 10.4 %s (got %s)' % (name, exp, got))
        else:
            mono = atl[name.replace('-GRAY', '-MONO')]
            check(all(a['glyphs'][c]['adv'] == mono['glyphs'][c]['adv'] for c in range(256)),
                  '%s advances = mono advances' % name)
            check(all(v <= 16 for gl in a['glyphs'].values() for v in gl['cov']), '%s coverage 0..16' % name)
    check(bad_adv == 0, 'total advance mismatches against hdmx: %d of %d' % (bad_adv, tot_adv))
    for name in ('font/TAHOMA-11-400-MONO', 'font/TAHOMA-11-700-MONO', 'font/TREBUCHETMS-13-700-MONO'):
        a = atl[name]
        real = mkatlas.find_font({'TAHOMA-11-400': 'tahoma.ttf', 'TAHOMA-11-700': 'tahomabd.ttf',
                                  'TREBUCHETMS-13-700': 'trebucbd.ttf'}[name[5:-5]]) is not None
        if real:
            check(a['flags'] & mkatlas.F_UNVERIFIED and not a['flags'] & mkatlas.F_PLACEHOLDER,
                  '%s from the user file, flag UNVERIFIED (%s)' % (name, a['source']))
        else:
            check(a['flags'] & mkatlas.F_PLACEHOLDER, '%s PLACEHOLDER' % name)


# ---------------------------------------------------------------- (c)

def fnt_strike13(path):
    """Independent FNT reader: 13 px strike of sserife.fon -> {code: (width, rows of 0/1)}."""
    d = open(path, 'rb').read()
    ne = struct.unpack_from('<I', d, 0x3c)[0]
    rt = ne + struct.unpack_from('<H', d, ne + 0x24)[0]
    shift = struct.unpack_from('<H', d, rt)[0]
    p = rt + 2
    while True:
        tid, cnt = struct.unpack_from('<HH', d, p)
        if tid == 0:
            break
        p += 8
        for i in range(cnt):
            off, ln = struct.unpack_from('<HH', d, p)
            p += 12
            if tid != 0x8008:
                continue
            b = d[off << shift:(off + ln) << shift]
            ver = struct.unpack_from('<H', b, 0)[0]
            height = struct.unpack_from('<H', b, 88)[0]
            first, last = b[95], b[96]
            if height != 13:
                continue
            out = {}
            for k in range(last - first + 1):
                if ver == 0x200:
                    w, o = struct.unpack_from('<HH', b, 118 + 4 * k)
                else:
                    w, o = struct.unpack_from('<HI', b, 148 + 6 * k)
                rows = []
                for y in range(height):
                    rows.append([(b[o + (x // 8) * height + y] >> (7 - x % 8)) & 1 for x in range(w)])
                out[first + k] = (w, rows)
            return out, struct.unpack_from('<H', b, 74)[0]
    raise SystemExit('no 13 px strike')


def gate_c(atl, rd):
    print('== (c) MS Sans Serif 13 px strike')
    ref, ascent = fnt_strike13(mkatlas.find_font('sserife.fon'))
    a = atl['font/MSSANSSERIF-11-400-MONO']
    bad = []
    for c in range(0x20, 0x100):
        w, rows = ref[c]
        gl = a['glyphs'][c]
        flat = bytes(v for r in rows for v in r)
        if (gl['w'], gl['h'], gl['adv'], gl['left'], gl['top'], gl['cov']) != (w, 13, w, 0, ascent, flat):
            bad.append(c)
    check(not bad, 'atlas glyphs 0x20..0xFF equal the FNT bitmaps (%d differ %s)' % (len(bad), bad[:8]))
    check((a['height'], a['ascent'], a['int_leading'], a['ave_width']) == (13, 11, 2, 5),
          'MS Sans Serif tmHeight 13, ascent 11, internal leading 2, avg width 5 (fonts.md 10.1)')
    # C renderer: draw every character once, compare pixels with the FNT bits.
    chars = ''.join(chr(c) for c in range(0x21, 0x100) if c != 0x7f)
    rd.cmd('font MS_Sans_Serif -11 400 0 0')
    _, ext = rd.cmd('extent ' + chars)
    cx = int(ext.split()[0])
    rd.cmd('image %d 20 255 255 255' % (cx + 4))
    rd.cmd('color 0 0 0')
    rd.cmd('mode T')
    rd.cmd('smooth 0')
    rd.cmd('noclip')
    rd.cmd('text 2 3 ' + chars)
    W, H, px = rd.image()
    exp = [[0] * W for _ in range(H)]
    pen = 2
    for ch in chars:
        w, rows = ref[ord(ch)]
        for y in range(13):
            for x in range(w):
                if rows[y][x]:
                    exp[3 + y][pen + x] = 1
        pen += w
    diff = sum(1 for y in range(H) for x in range(W) if (px[y * W + x][:3] == (0, 0, 0)) != bool(exp[y][x]))
    check(diff == 0 and pen == cx + 2, 'C renderer output equals the FNT bits for %d characters (%d pixels differ)'
          % (len(chars), diff))


# ---------------------------------------------------------------- (d)

def gate_d(atl, rd, entries):
    print('== (d) layout: extents, OPAQUE cell, underline, placement, clipping, grey blend')
    rd.cmd('smooth 0')
    rd.cmd('noclip')
    for face, h, wgt, s in (('Arial', 12, 700, 'Top Moeboids'), ('Arial', 18, 400, 'How To Play'),
                            ('Arial', 10, 400, 'Mail This'), ('Arial', 24, 700, '1,234,567'),
                            ('Tahoma', 11, 400, 'Name too long'), ('MS_Sans_Serif', 11, 400, 'Cancel')):
        rd.cmd('font %s -%d %d 0 0' % (face, h, wgt))
        _, r = rd.cmd('extent ' + s)
        cx, cy = map(int, r.split())
        key = 'font/%s-%d-%d-MONO' % (face.upper().replace('_', ''), h, wgt)
        a = atl[key]
        exp = sum(a['glyphs'][ord(ch)]['adv'] for ch in s)
        check((cx, cy) == (exp, a['height']), 'extent %-14s %s %d/%d = (%d, %d)' % (repr(s), face, h, wgt, exp,
                                                                                 a['height']))
    # OPAQUE cell fill and underline (Arial 12 regular, then 24 bold).
    for h, wgt in ((12, 400), (24, 700), (11, 400)):
        a = atl['font/ARIAL-%d-%d-MONO' % (h, wgt)]
        rd.cmd('font Arial -%d %d 1 0' % (h, wgt))
        s = 'Ag j_'
        _, r = rd.cmd('extent ' + s)
        cx, cy = map(int, r.split())
        rd.cmd('image 120 60 0 0 255')
        rd.cmd('color 255 0 0')
        rd.cmd('bk 0 255 0')
        rd.cmd('mode O')
        rd.cmd('text 10 7 ' + s)
        W, H, px = rd.image()
        inside = lambda x, y: 10 <= x < 10 + cx and 7 <= y < 7 + cy
        outside_ok = all(px[y * W + x] == (0, 0, 255, 255) for y in range(H) for x in range(W) if not inside(x, y))
        inside_ok = all(px[y * W + x] in ((0, 255, 0, 255), (255, 0, 0, 255)) for y in range(H) for x in range(W)
                        if inside(x, y))
        check(outside_ok and inside_ok, 'OPAQUE cell = (10,7)-(%d,%d) Arial %d/%d' % (10 + cx, 7 + cy, h, wgt))
        # underline only: a string of spaces
        rd.cmd('mode T')
        rd.cmd('image 120 60 255 255 255')
        rd.cmd('text 10 7      ')
        W, H, px = rd.image()
        red = {(x, y) for y in range(H) for x in range(W) if px[y * W + x] == (255, 0, 0, 255)}
        sp = 5 * a['glyphs'][0x20]['adv']
        top = 7 + a['ascent'] + a['ul_offset']
        exp = {(x, y) for x in range(10, 10 + sp) for y in range(top, top + a['ul_thickness'])}
        check(red == exp, 'underline rows %d..%d (baseline row %d + offset %d), columns 10..%d, Arial %d/%d'
              % (top, top + a['ul_thickness'] - 1, 7 + a['ascent'], a['ul_offset'], 9 + sp, h, wgt))
    # glyph placement and clipping
    a = atl['font/ARIAL-18-400-MONO']
    rd.cmd('font Arial -18 400 0 0')
    rd.cmd('image 80 40 255 255 255')
    rd.cmd('color 0 0 0')
    rd.cmd('text 5 4 Qy')
    W, H, px = rd.image()
    exp = set()
    pen = 5
    for ch in 'Qy':
        gl = a['glyphs'][ord(ch)]
        for y in range(gl['h']):
            for x in range(gl['w']):
                if gl['cov'][y * gl['w'] + x]:
                    exp.add((pen + gl['left'] + x, 4 + a['ascent'] - gl['top'] + y))
        pen += gl['adv']
    got = {(x, y) for y in range(H) for x in range(W) if px[y * W + x] == (0, 0, 0, 255)}
    check(got == exp and len(exp) > 0, 'glyph placement: pen (5, 4 + ascent), %d pixels' % len(exp))
    rd.cmd('image 80 40 255 255 255')
    rd.cmd('clip 8 6 20 15')
    rd.cmd('text 5 4 Qy')
    W, H, px = rd.image()
    got2 = {(x, y) for y in range(H) for x in range(W) if px[y * W + x] == (0, 0, 0, 255)}
    check(got2 == {p for p in exp if 8 <= p[0] < 20 and 6 <= p[1] < 15}, 'ETO_CLIPPED clips to (8,6)-(20,15)')
    rd.cmd('noclip')
    # grey blend (Arial 18 regular, smoothing on): black on white, and white on the magenta key
    g = atl['font/ARIAL-18-400-GRAY']
    rd.cmd('smooth 1')
    _, r = rd.cmd('font Arial -18 400 0 0')
    check(r.endswith('gray=1'), 'Arial 18 regular has a grey atlas')
    rd.cmd('image 80 40 255 255 255')
    rd.cmd('text 5 4 Qy')
    W, H, px = rd.image()
    bad = 0
    pen = 5
    expect = {}
    for ch in 'Qy':
        gl = g['glyphs'][ord(ch)]
        for y in range(gl['h']):
            for x in range(gl['w']):
                v = gl['cov'][y * gl['w'] + x]
                if v:
                    expect[(pen + gl['left'] + x, 4 + g['ascent'] - gl['top'] + y)] = v
        pen += gl['adv']
    for (x, y), v in expect.items():
        e = (255 * (16 - v) + 8) >> 4
        bad += px[y * W + x] != (e, e, e, 255)
    levels = sorted(set(expect.values()))
    check(bad == 0 and len(levels) > 3, 'grey blend (255*(16-v)+8)>>4 at %d pixels, levels %s' % (len(expect), levels))
    rd.cmd('keyed 80 40')
    rd.cmd('color 255 255 255')
    rd.cmd('text 5 4 Qy')
    W, H, px = rd.image()
    bad = 0
    for (x, y), v in expect.items():
        e = (255 * (16 - v) + 255 * v + 8) >> 4, (0 * (16 - v) + 255 * v + 8) >> 4, 255
        bad += px[y * W + x] != (e[0], e[1], e[2], 255)
    check(bad == 0, 'grey text over the colour key blends with magenta and becomes opaque (as GDI)')
    rd.cmd('smooth 0')
    _, r = rd.cmd('font Arial -12 400 0 0')
    check(r.endswith('gray=0'), 'Arial 12 regular has no grey atlas (gasp 9..17 ppem: grid-fit only)')
    renders(rd, entries, atl)


def zml_lite(rd, text, x0, y0, smooth):
    """Preview only (not the port's ZML renderer): Moeboid ZML-lite rules of fonts.md 7."""
    px_table = (24, 18, 14, 12, 10, 8)
    st = dict(px=18, bold=0, ul=0, centre=0, x=0, y=y0)

    def setfont():
        rd.cmd('font Arial -%d %d %d 0' % (st['px'], 700 if st['bold'] else 400, st['ul']))
    setfont()
    rd.cmd('smooth %d' % smooth)
    p = 0
    while p < len(text):
        if text[p] != '<':
            q = text.find('<', p)
            q = len(text) if q < 0 else q
            s = text[p:q]
            _, r = rd.cmd('extent ' + s)
            cx = int(r.split()[0])
            dx = (800 - cx) // 2 if st['centre'] else st['x'] + 4
            rd.cmd('text %d %d %s' % (x0 + dx, st['y'], s))
            st['x'] += cx
            p = q
            continue
        q = text.find('>', p)
        tag = text[p + 1:q]
        p = q + 1
        closing = tag.startswith('/')
        t = tag[1:] if closing else tag
        u = t.upper()
        if u == 'BR':
            st['x'] = 0
            st['y'] += 15
        elif u == 'P':
            st['x'] = 0
            st['y'] += 30
        elif u == 'B':
            st['bold'] = 0 if closing else 1
            setfont()
        elif u == 'U':
            st['ul'] = 0 if closing else 1
            setfont()
        elif u.startswith('S') and len(u) > 1 and u[1].isdigit():
            st['px'] = px_table[int(u[1])]
            setfont()
        elif u == 'C':
            st['centre'] = 0 if closing else 1
        elif u.startswith('C') and len(u) == 7:
            rd.cmd('color %d %d %d' % (int(u[1:3], 16), int(u[3:5], 16), int(u[5:7], 16)))


def string_table(blob, block):
    out = {}
    p = 0
    for i in range(16):
        n, = struct.unpack_from('<H', blob, p)
        out[(block - 1) * 16 + i] = blob[p + 2:p + 2 + 2 * n].decode('utf-16le')
        p += 2 + 2 * n
    return out


def save_png(rd, path):
    from PIL import Image
    W, H, px = rd.image()
    im = Image.new('RGBA', (W, H))
    im.putdata(px)
    im.convert('RGB').save(path, optimize=True)
    return os.path.getsize(path)


def renders(rd, entries, atl):
    os.makedirs(RESULTS, exist_ok=True)
    help_raw = entries['gam/RCDATA/HELP.ZML'].decode('latin-1')
    help_txt = help_raw.split('"')[1].replace('\r', ' ').replace('\n', ' ')
    sizes = []
    for smooth in (0, 1):
        rd.cmd('noclip')
        rd.cmd('mode T')
        rd.cmd('image 500 420 153 153 204')
        rd.cmd('color 255 255 255')
        zml_lite(rd, help_txt, 0, 10, smooth)
        rd.cmd('font Arial -10 400 0 0')
        rd.cmd('color 153 153 153')
        rd.cmd('text 307 400 Moeboid is a trademark of ZapSpot, Inc.')
        name = 'text_help_%s.png' % ('gray' if smooth else 'mono')
        sizes.append((name, save_png(rd, os.path.join(RESULTS, name))))
    strings = {}
    for k, v in entries.items():
        if k.startswith('zap/STRING/'):
            strings.update(string_table(v, int(k.split('/')[-1])))
    rd.cmd('smooth 0')
    rd.cmd('image 800 372 51 51 204')
    y = 4
    lines = [
        ('Arial', 12, 700, 0, (255, 255, 255), [strings.get(i, '') for i in (10000, 10001, 10002)]),
        ('Arial', 10, 400, 1, (255, 255, 255), ['Mail This', 'New Game', 'Pause', 'Resume', 'How To Play',
                                                 'High Scores']),
        ('Arial', 18, 400, 0, (0, 0, 0), ['How To Play', 'Moeboid']),
        ('Arial', 18, 700, 1, (0, 0, 0), ['Top Moeboids']),
        ('Arial', 12, 700, 0, (51, 51, 153), ['Sorry, you got eaten!', '1 life left...', 'Play Again?']),
        ('Arial', 24, 700, 0, (204, 51, 153), ['12,345', '0123456789']),
        ('Arial', 14, 700, 1, (255, 255, 255), ['Install ZapSpot']),
        ('Arial', 11, 400, 0, (0, 0, 0), ['Copyright (c) 2000 ZapSpot, Inc.  All Rights Reserved.']),
        ('Tahoma', 11, 400, 0, (0, 0, 0), ['Name too long', 'MessageBox text (Tahoma 8 pt)']),
        ('Tahoma', 11, 700, 0, (0, 0, 0), ['Small caption (Tahoma 8 pt bold)']),
        ('Trebuchet_MS', 13, 700, 0, (255, 255, 255), ['Congratulations', 'Warning: Game in Progress']),
        ('MS_Sans_Serif', 11, 400, 0, (0, 0, 0), ['&OK  Cancel  Please enter your name:  0123456789 \xc0\xe9\xfc']),
    ]
    for face, h, wgt, ul, col, texts in lines:
        rd.cmd('font %s -%d %d %d 0' % (face, h, wgt, ul))
        rd.cmd('color %d %d %d' % col)
        rd.cmd('text 4 %d %s' % (y, '   '.join(t for t in texts if t)))
        _, m = rd.cmd('metrics')
        y += int(m.split()[0]) + 4
    y0 = y
    for smooth in (0, 1):
        rd.cmd('smooth %d' % smooth)
        y = y0
        for face, h, wgt in (('Arial', 18, 400), ('Arial', 14, 700), ('Arial', 24, 700), ('Trebuchet_MS', 13, 700)):
            rd.cmd('font %s -%d %d 0 0' % (face, h, wgt))
            rd.cmd('color 255 255 255')
            rd.cmd('text %d %d %s %d/%d smoothing %s' % (4 + 400 * smooth, y, face.replace('_', ' '), h, wgt,
                                                        'on' if smooth else 'off'))
            _, m = rd.cmd('metrics')
            y += int(m.split()[0]) + 2
    sizes.append(('text_shell.png', save_png(rd, os.path.join(RESULTS, 'text_shell.png'))))
    for n, s in sizes:
        print('wrote port/tests/results/%s (%d bytes)' % (n, s))


def determinism():
    print('== pack determinism')
    h = []
    with tempfile.TemporaryDirectory() as td:
        for i in range(2):
            out = os.path.join(td, str(i))
            subprocess.run([sys.executable, '-I', '-B', os.path.join(PORT, 'tools', 'mkpack.py'), '--quiet',
                            '--out', out], check=True, capture_output=True)
            h.append(hashlib.sha256(open(os.path.join(out, 'pack.bin'), 'rb').read()).hexdigest())
    ref = hashlib.sha256(open(PACK, 'rb').read()).hexdigest()
    check(h[0] == h[1] == ref, 'two mkpack runs and port/build/web/pack.bin have one sha256 %s' % h[0][:16])


def main():
    build()
    if not os.path.exists(PACK):
        subprocess.run([sys.executable, '-I', '-B', os.path.join(PORT, 'tools', 'mkpack.py'), '--quiet'], check=True)
    raw, entries = read_pack(PACK)
    atl = {k: mkatlas.unpack_atlas(v) for k, v in entries.items() if k.startswith('font/')}
    print('pack: %d entries, %d atlases' % (len(entries), len(atl)))
    rd = Renderer()
    _, r = rd.cmd('fonts')
    check(int(r) == len(atl), 'C loader parsed %s atlases' % r)
    gate_b(atl)
    gate_c(atl, rd)
    gate_d(atl, rd, entries)
    rd.close()
    determinism()
    print('%d failures' % len(FAIL))
    return 1 if FAIL else 0


if __name__ == '__main__':
    sys.exit(main())
