#!/usr/bin/env python3
"""Glyph atlas builder for the Moeboid port (docs/port-design.md section 8).

Run:  python -I -B port/tools/mkatlas.py [--verify] [--quiet]
      --verify  also reproduce analysis/fonts.md 10.3 (all hdmx ppems <= 40, 191 cp1252 characters,
                regular and bold) and the VDMX extent check at ppem 8..36.
mkpack.py imports this module and calls build_atlases().

Sources (read-only): fonts/Arial.TTF, fonts/Arialbd.TTF (2.82), fonts/sserife.fon (13 px strike),
fonts/tahoma.ttf, fonts/tahomabd.ttf, fonts/trebucbd.ttf (used when present, else Arial placeholders).
Rasterizer: system FreeType through the host helper mkatlas_ft.c (built into port/build/tools/).
"""
import os
import struct
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
FONTS = os.path.join(ROOT, 'fonts')
TOOL_DIR = os.path.join(ROOT, 'port', 'build', 'tools')
FT_SRC = os.path.join(HERE, 'mkatlas_ft.c')
FT_BIN = os.path.join(TOOL_DIR, 'mkatlas_ft')

MAGIC = b'MATL'
VERSION = 1
MODE_MONO, MODE_GRAY = 0, 1
# Atlas flags (header byte 7).
F_PLACEHOLDER = 0x01   # glyphs and metrics come from a substitute face (Arial)
F_RASTER = 0x02        # bitmap font strike (FNT), exact copy
F_HINTED = 0x04        # outline grid-fitted at the target ppem
F_GASP_GRIDFIT = 0x08  # gasp GASP_GRIDFIT bit at this ppem
F_GASP_DOGRAY = 0x10   # gasp GASP_DOGRAY bit at this ppem: grey allowed when smoothing is on
F_UNVERIFIED = 0x20    # XP-generation font, version unverified (user-supplied, see fonts/SOURCES.md)

# Header: magic, version, mode, flags, px, weight, first, last, default char,
# tmHeight, tmAscent, tmDescent, tmInternalLeading, tmExternalLeading, tmAveCharWidth, tmMaxCharWidth,
# underline offset, underline thickness, strikeout offset, strikeout thickness, 4 reserved bytes,
# face[32], source[32], glyph table offset, coverage offset, coverage length. 120 bytes.
HDR = struct.Struct('<4sHBBHHHHH11h4x32s32sIII')
# Glyph record: left, top, width, height, advance, reserved, coverage offset. 16 bytes.
GLYPH = struct.Struct('<hhHHhHI')
assert HDR.size == 120 and GLYPH.size == 16

ARIAL_SIZES = (8, 10, 11, 12, 14, 18, 24, 36)
ARIAL_FILES = {400: 'Arial.TTF', 700: 'Arialbd.TTF'}
# System fonts outside the engine's control (decision 4c, O1): (face, px, weight, file, placeholder weight)
SYSTEM_FONTS = (
    ('Tahoma', 11, 400, 'tahoma.ttf'),          # MessageBox text, 8 pt at 96 dpi
    ('Tahoma', 11, 700, 'tahomabd.ttf'),        # small caption font, 8 pt bold
    ('Trebuchet MS', 13, 700, 'trebucbd.ttf'),  # Luna caption font, 10 pt bold
)
UNVERIFIED_FILES = {'tahoma.ttf', 'tahomabd.ttf', 'trebucbd.ttf'}
EXPECTED_VERSIONS = {'tahoma.ttf': 'Version 3.15', 'tahomabd.ttf': 'Version 3.15', 'trebucbd.ttf': 'Version 1.22'}
VDMX_CHECK_PPEMS = (8, 10, 11, 12, 13, 14, 16, 18, 24, 36)


def cp1252_unicode(c):
    """Windows cp1252 (MultiByteToWideChar) mapping; undefined bytes map to the same code point."""
    try:
        return ord(bytes([c]).decode('cp1252'))
    except UnicodeDecodeError:
        return c


def cp1252_defined(c):
    try:
        bytes([c]).decode('cp1252')
        return True
    except UnicodeDecodeError:
        return False


def rnd(num, den):
    """Round num/den half away from zero (inferred GDI rounding of scaled font units)."""
    if num >= 0:
        return (2 * num + den) // (2 * den)
    return -((-2 * num + den) // (2 * den))


def find_font(name):
    if not os.path.isdir(FONTS):
        return None
    for f in sorted(os.listdir(FONTS)):
        if f.lower() == name.lower():
            return os.path.join(FONTS, f)
    return None


class TTF:
    def __init__(self, path):
        self.path = path
        self.file = os.path.basename(path)
        d = self.data = open(path, 'rb').read()
        n = struct.unpack_from('>H', d, 4)[0]
        self.t = {d[12 + 16 * i:16 + 16 * i].decode('latin1'): struct.unpack_from('>II', d, 20 + 16 * i)
                  for i in range(n)}
        o = self.t['head'][0]
        self.upem = struct.unpack_from('>H', d, o + 18)[0]
        o = self.t['hhea'][0]
        self.asc, self.desc, self.gap, self.adv_max = struct.unpack_from('>hhhH', d, o + 4)
        o = self.t['OS/2'][0]
        self.xavg = struct.unpack_from('>h', d, o + 2)[0]
        self.so_size, self.so_pos = struct.unpack_from('>hh', d, o + 26)
        self.win_asc, self.win_desc = struct.unpack_from('>HH', d, o + 74)
        o = self.t['post'][0]
        self.ul_pos, self.ul_thick = struct.unpack_from('>hh', d, o + 8)
        self.version = self._name(5)
        self.gasp = self._gasp()
        self.vdmx = self._vdmx()
        self.hdmx = self._hdmx()

    def _name(self, nid):
        d = self.data
        off = self.t['name'][0]
        fmt, cnt, so = struct.unpack_from('>HHH', d, off)
        mac = None
        for i in range(cnt):
            pid, eid, lid, n, ln, o = struct.unpack_from('>HHHHHH', d, off + 6 + 12 * i)
            raw = d[off + so + o:off + so + o + ln]
            if n == nid and pid == 3 and lid == 0x409:
                return raw.decode('utf-16-be')
            if n == nid and pid == 1 and mac is None:
                mac = raw.decode('latin1')
        return mac or ''

    def _gasp(self):
        if 'gasp' not in self.t:
            return []
        o = self.t['gasp'][0]
        v, n = struct.unpack_from('>HH', self.data, o)
        return [struct.unpack_from('>HH', self.data, o + 4 + 4 * i) for i in range(n)]

    def gasp_flags(self, ppem):
        for maxppem, fl in self.gasp:
            if ppem <= maxppem:
                return fl
        return 0 if self.gasp else 1  # no gasp table: grid-fit, no grey (inferred GDI default)

    def _vdmx(self):
        if 'VDMX' not in self.t:
            return {}
        d = self.data
        o = self.t['VDMX'][0]
        ver, nrec, nrat = struct.unpack_from('>HHH', d, o)
        pick = None
        for i in range(nrat):
            cs, x, ys, ye = struct.unpack_from('>BBBB', d, o + 6 + 4 * i)
            if x == 0 or ys <= x <= ye:  # 1:1 device aspect (96 x 96 dpi)
                pick = i
                break
        if pick is None:
            return {}
        go = o + struct.unpack_from('>H', d, o + 6 + 4 * nrat + 2 * pick)[0]
        recs = struct.unpack_from('>H', d, go)[0]
        out = {}
        for i in range(recs):
            yp, ymax, ymin = struct.unpack_from('>Hhh', d, go + 4 + 6 * i)
            out[yp] = (ymax, ymin)
        return out

    def _hdmx(self):
        if 'hdmx' not in self.t:
            return {}
        d = self.data
        o = self.t['hdmx'][0]
        v, n, sz = struct.unpack_from('>HhI', d, o)
        return {d[o + 8 + sz * i]: d[o + 10 + sz * i:o + 8 + sz * (i + 1)] for i in range(n)}

    def metrics(self, ppem):
        """GDI TEXTMETRIC values for lfHeight = -ppem (fonts.md 10.4 rules; rounding inferred)."""
        if ppem in self.vdmx:
            asc, desc = self.vdmx[ppem][0], -self.vdmx[ppem][1]
        else:
            asc, desc = rnd(self.win_asc * ppem, self.upem), rnd(self.win_desc * ppem, self.upem)
        height = asc + desc
        ext = max(0, rnd((self.gap - ((self.win_asc + self.win_desc) - (self.asc - self.desc))) * ppem, self.upem))
        return dict(height=height, ascent=asc, descent=desc, int_leading=height - ppem, ext_leading=ext,
                    ave_width=rnd(self.xavg * ppem, self.upem), max_width=rnd(self.adv_max * ppem, self.upem),
                    ul_offset=rnd(-self.ul_pos * ppem, self.upem),
                    ul_thickness=max(1, rnd(self.ul_thick * ppem, self.upem)),
                    so_offset=rnd(self.so_pos * ppem, self.upem),
                    so_thickness=max(1, rnd(self.so_size * ppem, self.upem)))


# ---------------------------------------------------------------- FreeType helper

def ensure_tool(log):
    os.makedirs(TOOL_DIR, exist_ok=True)
    if os.path.exists(FT_BIN) and os.path.getmtime(FT_BIN) >= os.path.getmtime(FT_SRC):
        return
    try:
        flags = subprocess.run(['pkg-config', '--cflags', '--libs', 'freetype2'], capture_output=True,
                               text=True, check=True).stdout.split()
    except (OSError, subprocess.CalledProcessError):
        flags = ['-I/usr/include/freetype2', '-lfreetype']
    cc = os.environ.get('CC', 'cc')
    cmd = [cc, '-O2', '-std=c11', '-Wall', '-Wextra', '-o', FT_BIN, FT_SRC] + flags
    log('build ' + ' '.join(cmd))
    subprocess.run(cmd, check=True)


def ft_render(path, ppem, mode, codes, nohint=False, nohdmx=True):
    """Return (FreeType version, list of glyph dicts in code order)."""
    args = [FT_BIN, path, str(ppem), mode]
    if nohdmx:
        args.append('--no-hdmx')
    if nohint:
        args.append('--nohint')
    args += [str(c) for c in codes]
    lines = subprocess.run(args, capture_output=True, text=True, check=True).stdout.split('\n')
    assert lines[0].startswith('V ')
    ver = lines[0].split()[1]
    out = []
    for line in lines[1:]:
        if not line:
            continue
        f = line.split(' ')
        code, gi, adv, left, top, w, h = map(int, f[1:8])
        data = f[8]
        if data == '-':
            cov = b''
            w = h = 0
        elif mode == 'mono':
            cov = bytes(1 if ch == '1' else 0 for ch in data)
        else:
            cov = bytes.fromhex(data)
        assert len(cov) == w * h, (path, ppem, code)
        if mode == 'mono':
            assert adv % 64 == 0, (path, ppem, code, adv)  # hinted advances are whole pixels
        out.append(dict(code=code, gi=gi, adv=adv // 64, adv26=adv, left=left, top=top, w=w, h=h, cov=cov))
    assert len(out) == len(codes)
    return ver, out


# ---------------------------------------------------------------- FNT (sserife.fon)

def fon_fonts(path):
    d = open(path, 'rb').read()
    ne = struct.unpack_from('<I', d, 0x3c)[0]
    assert d[ne:ne + 2] == b'NE'
    rt = ne + struct.unpack_from('<H', d, ne + 0x24)[0]
    shift = struct.unpack_from('<H', d, rt)[0]
    p = rt + 2
    fonts = []
    while True:
        tid = struct.unpack_from('<H', d, p)[0]
        if tid == 0:
            break
        cnt = struct.unpack_from('<H', d, p + 2)[0]
        p += 8
        for i in range(cnt):
            off, ln, fl, rid = struct.unpack_from('<HHHH', d, p)
            if tid == 0x8008:
                fonts.append(d[off << shift:(off << shift) + (ln << shift)])
            p += 12
    return fonts


FNT_KEYS = [('dfVersion', 'H'), ('dfSize', 'I'), ('dfCopyright', '60s'), ('dfType', 'H'), ('dfPoints', 'H'),
            ('dfVertRes', 'H'), ('dfHorizRes', 'H'), ('dfAscent', 'H'), ('dfInternalLeading', 'H'),
            ('dfExternalLeading', 'H'), ('dfItalic', 'B'), ('dfUnderline', 'B'), ('dfStrikeOut', 'B'),
            ('dfWeight', 'H'), ('dfCharSet', 'B'), ('dfPixWidth', 'H'), ('dfPixHeight', 'H'),
            ('dfPitchAndFamily', 'B'), ('dfAvgWidth', 'H'), ('dfMaxWidth', 'H'), ('dfFirstChar', 'B'),
            ('dfLastChar', 'B'), ('dfDefaultChar', 'B'), ('dfBreakChar', 'B'), ('dfWidthBytes', 'H'),
            ('dfDevice', 'I'), ('dfFace', 'I'), ('dfBitsPointer', 'I'), ('dfBitsOffset', 'I'), ('dfReserved', 'B')]


def parse_fnt(b):
    f = {}
    p = 0
    for k, t in FNT_KEYS:
        f[k] = struct.unpack_from('<' + t, b, p)[0]
        p += struct.calcsize('<' + t)
    f['face'] = b[f['dfFace']:].split(b'\0')[0].decode('latin1')
    ver = f['dfVersion']
    nch = f['dfLastChar'] - f['dfFirstChar'] + 2
    ct = 118 if ver == 0x200 else 148
    ent = 4 if ver == 0x200 else 6
    h = f['dfPixHeight']
    glyphs = {}
    for i in range(nch):
        if ver == 0x200:
            w, off = struct.unpack_from('<HH', b, ct + i * ent)
        else:
            w, off = struct.unpack_from('<HI', b, ct + i * ent)
        cols = (w + 7) // 8
        rows = []
        for y in range(h):
            row = 0
            for c in range(cols):
                row = (row << 8) | b[off + c * h + y]
            rows.append(row)
        glyphs[f['dfFirstChar'] + i] = (w, cols, rows)
    f['glyphs'] = glyphs
    return f


def fnt_cov(w, cols, rows):
    out = bytearray()
    for row in rows:
        for x in range(w):
            out.append((row >> (cols * 8 - 1 - x)) & 1)
    return bytes(out)


# ---------------------------------------------------------------- atlas blobs

def entry_name(face, px, weight, mode):
    return 'font/%s-%d-%d-%s' % (face.upper().replace(' ', ''), px, weight, 'MONO' if mode == MODE_MONO else 'GRAY')


def pack_atlas(face, px, weight, mode, flags, first, last, default, m, source, glyphs):
    assert len(glyphs) == last - first + 1
    recs = []
    cov = bytearray()
    for g in glyphs:
        recs.append(GLYPH.pack(g['left'], g['top'], g['w'], g['h'], g['adv'], 0, len(cov)))
        cov += g['cov']
    glyph_off = HDR.size
    cov_off = glyph_off + GLYPH.size * len(glyphs)
    hdr = HDR.pack(MAGIC, VERSION, mode, flags, px, weight, first, last, default,
                   m['height'], m['ascent'], m['descent'], m['int_leading'], m['ext_leading'],
                   m['ave_width'], m['max_width'], m['ul_offset'], m['ul_thickness'],
                   m['so_offset'], m['so_thickness'],
                   face.encode('ascii'), source.encode('ascii')[:31], glyph_off, cov_off, len(cov))
    return hdr + b''.join(recs) + bytes(cov)


def unpack_atlas(blob):
    """Parse an atlas blob (used by the tests and the self-check)."""
    v = HDR.unpack_from(blob, 0)
    keys = ('magic', 'version', 'mode', 'flags', 'px', 'weight', 'first', 'last', 'default', 'height', 'ascent',
            'descent', 'int_leading', 'ext_leading', 'ave_width', 'max_width', 'ul_offset', 'ul_thickness',
            'so_offset', 'so_thickness', 'face', 'source', 'glyph_off', 'cov_off', 'cov_len')
    a = dict(zip(keys, v))
    a['face'] = a['face'].rstrip(b'\0').decode('ascii')
    a['source'] = a['source'].rstrip(b'\0').decode('ascii')
    a['glyphs'] = {}
    for i in range(a['last'] - a['first'] + 1):
        left, top, w, h, adv, _, off = GLYPH.unpack_from(blob, a['glyph_off'] + GLYPH.size * i)
        c = a['cov_off'] + off
        a['glyphs'][a['first'] + i] = dict(left=left, top=top, w=w, h=h, adv=adv, cov=blob[c:c + w * h])
    return a


# ---------------------------------------------------------------- checks

def check_hdmx(f, glyphs, ppem):
    """Advance of every atlas glyph against the hdmx device width. Returns (mismatches, total)."""
    if ppem not in f.hdmx:
        return None
    w = f.hdmx[ppem]
    bad = [(g['code'], g['adv'], w[g['gi']]) for g in glyphs if g['adv'] != w[g['gi']]]
    return bad, len(glyphs)


def check_vdmx(f, glyphs, ppem):
    """Max top / min bottom of the cp1252 glyphs (0x20..0xFF, defined, mapped) against VDMX."""
    if ppem not in f.vdmx:
        return None
    ymax, ymin = -999, 999
    for g in glyphs:
        c = g['code_byte']
        if c < 0x20 or not cp1252_defined(c) or g['gi'] == 0 or not g['h']:
            continue
        ymax = max(ymax, g['top'])
        ymin = min(ymin, g['top'] - g['h'])
    return (ymax, ymin), f.vdmx[ppem]


def verify_fonts_md(log):
    """Reproduce analysis/fonts.md 10.3 tests 1 and 2 for Arial regular and bold."""
    ensure_tool(log)
    ok = True
    chars = list(range(0x20, 0x7f)) + list(range(0xa0, 0x100))
    for weight, fname in sorted(ARIAL_FILES.items()):
        path = find_font(fname)
        f = TTF(path)
        bad = tot = 0
        for ppem in sorted(p for p in f.hdmx if p <= 40):
            ver, gl = ft_render(path, ppem, 'mono', [cp1252_unicode(c) for c in chars])
            w = f.hdmx[ppem]
            mism = [(chr(g['code']), w[g['gi']], g['adv']) for g in gl if g['adv'] != w[g['gi']]]
            bad += len(mism)
            tot += len(gl)
            if mism:
                log('  %s ppem %d advance mismatches: %s' % (fname, ppem, mism[:8]))
        log('10.3 test 1 %s: hdmx advance mismatches %d of %d (%d ppems)' %
            (fname, bad, tot, len([p for p in f.hdmx if p <= 40])))
        ok &= bad == 0
        cp = [c for c in range(0x20, 0x100) if cp1252_defined(c)]
        res = []
        for ppem in VDMX_CHECK_PPEMS:
            ver, gl = ft_render(path, ppem, 'mono', [cp1252_unicode(c) for c in cp])
            for c, g in zip(cp, gl):
                g['code_byte'] = c
            (ext, vd) = check_vdmx(f, gl, ppem)
            res.append('%d:%s' % (ppem, 'ok' if ext == vd else 'FAIL %s vs %s' % (ext, vd)))
            ok &= ext == vd
        log('10.3 test 2 %s: VDMX extents %s' % (fname, ' '.join(res)))
    return ok


# ---------------------------------------------------------------- generation

def tt_atlases(face, px, weight, path, flags_extra, log, report):
    """Mono atlas, plus a grey atlas when the gasp table allows grey at px. Returns list of (name, blob)."""
    f = TTF(path)
    codes = [cp1252_unicode(c) for c in range(256)]
    gasp = f.gasp_flags(px)
    gflags = (F_GASP_GRIDFIT if gasp & 1 else 0) | (F_GASP_DOGRAY if gasp & 2 else 0)
    m = f.metrics(px)
    source = '%s %s' % (f.file, f.version.replace('Version ', 'v'))
    ver, mono = ft_render(path, px, 'mono', codes)
    report['freetype'] = ver
    for c, g in enumerate(mono):
        g['code_byte'] = c
    out = []
    flags = flags_extra | F_HINTED | gflags
    name = entry_name(face, px, weight, MODE_MONO)
    ft_hd = check_hdmx(f, mono, px)  # FreeType hinted advances (hdmx disabled) against hdmx
    if px in f.hdmx:
        # GDI takes the advance from hdmx when the ppem is listed (fonts.md 10.2, inferred).
        for g in mono:
            g['adv'] = f.hdmx[px][g['gi']]
    hd = check_hdmx(f, mono, px)
    vd = check_vdmx(f, mono, px)
    vd_set = 'cp1252'
    if vd is not None and vd[0] != vd[1]:
        # Some fonts build VDMX from every glyph (Trebuchet MS: Latin Extended). Compare with all glyphs.
        ver, allg = ft_render(path, px, 'mono', list(range(0x20, 0x2500)))
        hit = [g for g in allg if g['gi'] and g['h']]
        vd = ((max(g['top'] for g in hit), min(g['top'] - g['h'] for g in hit)), vd[1])
        vd_set = 'all glyphs U+0020..U+24FF'
    out.append((name, pack_atlas(face, px, weight, MODE_MONO, flags, 0, 255, 0x1f, m, source, mono)))
    report['checks'].append(dict(name=name, file=f.file, placeholder=bool(flags_extra & F_PLACEHOLDER),
                                 ft_hdmx=None if ft_hd is None else (len(ft_hd[0]), ft_hd[1], ft_hd[0][:6]),
                                 hdmx=None if hd is None else (len(hd[0]), hd[1], hd[0][:6]),
                                 vdmx=vd, vdmx_set=vd_set))
    if gasp & 2:
        nohint = not (gasp & 1)
        ver, gray = ft_render(path, px, 'gray', codes, nohint=nohint)
        diff = 0
        for g, gm in zip(gray, mono):
            diff += g['adv26'] != gm['adv'] * 64
            g['adv'] = gm['adv']  # layout is identical in both modes (inferred)
        gfl = flags_extra | gflags | (0 if nohint else F_HINTED)
        gname = entry_name(face, px, weight, MODE_GRAY)
        out.append((gname, pack_atlas(face, px, weight, MODE_GRAY, gfl, 0, 255, 0x1f, m, source, gray)))
        report['gray'].append(dict(name=gname, hinted=not nohint, adv_diff=diff))
    return out


def fon_atlas(path, log, report):
    want = None
    for b in fon_fonts(path):
        f = parse_fnt(b)
        if f['dfPixHeight'] - f['dfInternalLeading'] == 11 and f['dfWeight'] == 400:
            want = f
    assert want, 'no 13 px strike in %s' % path
    f = want
    glyphs = []
    for c in range(f['dfFirstChar'], f['dfLastChar'] + 1):
        w, cols, rows = f['glyphs'][c]
        glyphs.append(dict(left=0, top=f['dfAscent'], w=w, h=f['dfPixHeight'], adv=w, cov=fnt_cov(w, cols, rows)))
    h = f['dfPixHeight']
    m = dict(height=h, ascent=f['dfAscent'], descent=h - f['dfAscent'], int_leading=f['dfInternalLeading'],
             ext_leading=f['dfExternalLeading'], ave_width=f['dfAvgWidth'], max_width=f['dfMaxWidth'],
             ul_offset=1, ul_thickness=1, so_offset=(f['dfAscent'] - f['dfInternalLeading']) // 2, so_thickness=1)
    default = f['dfFirstChar'] + f['dfDefaultChar']
    name = entry_name('MS Sans Serif', 11, 400, MODE_MONO)
    report['checks'].append(dict(name=name, file=os.path.basename(path), strike=h))
    return [(name, pack_atlas('MS Sans Serif', 11, 400, MODE_MONO, F_RASTER, f['dfFirstChar'], f['dfLastChar'],
                              default, m, '%s %dpx strike' % (os.path.basename(path), h), glyphs))]


def build_atlases(log=print):
    """Build every atlas. Returns (sorted list of (entry name, blob), report dict). Raises on a failed check."""
    ensure_tool(log)
    report = dict(checks=[], gray=[], fonts=[], freetype=None)
    out = []
    for weight in (400, 700):
        path = find_font(ARIAL_FILES[weight])
        if path is None:
            raise SystemExit('missing fonts/%s' % ARIAL_FILES[weight])
        f = TTF(path)
        report['fonts'].append('%s: name ID 5 "%s", gasp %s' % (f.file, f.version, f.gasp))
        for px in ARIAL_SIZES:
            out += tt_atlases('Arial', px, weight, path, 0, log, report)
    for face, px, weight, fname in SYSTEM_FONTS:
        path = find_font(fname)
        if path is not None:
            f = TTF(path)
            note = '' if f.version == EXPECTED_VERSIONS.get(fname) else ' (expected %s)' % EXPECTED_VERSIONS.get(fname)
            report['fonts'].append('%s: name ID 5 "%s"%s, gasp %s, XP-generation font, version unverified' %
                                   (f.file, f.version, note, f.gasp))
            out += tt_atlases(face, px, weight, path, F_UNVERIFIED if fname in UNVERIFIED_FILES else 0, log, report)
        else:
            report['fonts'].append('%s: missing, PLACEHOLDER from %s' % (fname, ARIAL_FILES[weight]))
            out += tt_atlases(face, px, weight, find_font(ARIAL_FILES[weight]), F_PLACEHOLDER, log, report)
    fon = find_font('sserife.fon')
    if fon is None:
        raise SystemExit('missing fonts/sserife.fon')
    out += fon_atlas(fon, log, report)
    out.sort(key=lambda e: e[0].encode('ascii'))
    # Gate checks: Arial mono atlases must match hdmx and VDMX exactly.
    failed = []
    for c in report['checks']:
        if 'hdmx' not in c:
            continue
        hd_ok = c['hdmx'] is None or c['hdmx'][0] == 0
        vd_ok = c['vdmx'] is None or c['vdmx'][0] == c['vdmx'][1]
        c['ok'] = hd_ok and vd_ok
        if not c['ok'] and c['file'] in ARIAL_FILES.values() and not c['placeholder']:
            failed.append(c['name'])
    if failed:
        raise SystemExit('atlas check failed: %s' % failed)
    return out, report


def print_report(report, entries, log=print):
    log('FreeType %s, interpreter v35, mono: FT_LOAD_TARGET_MONO|FT_LOAD_MONOCHROME, grey: O6 4x4 model' %
        report['freetype'])
    for line in report['fonts']:
        log('font ' + line)
    for c in report['checks']:
        if 'strike' in c:
            log('check %-32s raster strike %d px (exact copy)' % (c['name'], c['strike']))
            continue
        hd = 'hdmx -' if c['hdmx'] is None else 'atlas/hdmx %d/%d, FreeType/hdmx %d %s' % (
            c['hdmx'][0], c['hdmx'][1], c['ft_hdmx'][0], c['ft_hdmx'][2] or '')
        vd = 'VDMX -' if c['vdmx'] is None else ('VDMX ok %s (%s)' % (c['vdmx'][1], c['vdmx_set'])
                                                  if c['vdmx'][0] == c['vdmx'][1]
                                                  else 'VDMX DIFF glyphs %s table %s' % c['vdmx'])
        log('check %-28s %-36s %s%s' % (c['name'], hd, vd, ' PLACEHOLDER' if c['placeholder'] else ''))
    for g in report['gray']:
        log('gray  %-32s %s, grey-hinting advance differences %d (mono advances kept)' %
            (g['name'], 'hinted' if g['hinted'] else 'unhinted (gasp GRIDFIT off)', g['adv_diff']))
    log('atlases %d, %d bytes' % (len(entries), sum(len(b) for _, b in entries)))


def main(argv):
    quiet = '--quiet' in argv
    log = (lambda s: None) if quiet else print
    ok = True
    if '--verify' in argv:
        ok = verify_fonts_md(print)
    entries, report = build_atlases(log)
    print_report(report, entries, print)
    return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
