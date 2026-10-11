#!/usr/bin/env python3
"""Windows XP Luna (NormalColor, NormalSize) data for the dialog and MessageBox frame of the port.

Run:  python -I -B port/tools/mkluna.py [--out DIR] [--quiet]
Reads fonts/luna.msstyles as data only (pefile, resource directory only; the file is never loaded or
executed). Writes DIR/normalblue.bin (pack entry data/luna/NORMALBLUE) and DIR/normalblue.json (the same
values in readable form, with the INI line of each value). Default DIR: port/build/luna.
mkpack.py can call pack_entries(), which returns [("data/luna/NORMALBLUE", bytes)].
Format and verified/inferred status: port/tools/README.md, section "Luna".

Blob layout (little-endian, every record 4-byte aligned):
  header 32 bytes: "LUNA", u16 version (1), u16 header size (32), u16 n_colors, u16 n_metrics,
                   u16 n_parts, u16 n_images, u32 colors_off, u32 metrics_off, u32 parts_off, u32 images_off
  color  8 bytes:  u16 id, u8 source, u8 0, u8 r, u8 g, u8 b, u8 0
  metric 8 bytes:  u16 id, u8 source, u8 0, i32 value
  part   48 bytes: u16 id, u16 image, u16 glyph (0xFFFF = none), u8 image_count, u8 glyph_count,
                   u8 sizing_type, u8 layout, u8 flags, u8 offset_type, i16 sizing[4] (l, r, t, b),
                   i16 content[4], i16 caption[4], i16 offset[2], u8 fill r, g, b, u8 0, 4 bytes 0
  image  16 bytes: u16 w, u16 h, u16 flags, u16 source bpp, u32 data_off, u32 data_len
  pixels: RGBA, top-down, straight (not premultiplied) alpha; colour-key pixels are (0, 0, 0, 0).
Source codes: 1 = [SysMetrics] of NORMALBLUE_INI, 2 = other NORMALBLUE_INI section, 0 = inferred.
"""
import hashlib
import json
import os
import struct
import sys

import pefile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
MSSTYLES = os.path.join(ROOT, 'fonts', 'luna.msstyles')
MSSTYLES_SHA256 = 'dd8e86e5a7c19ea9fe0e34992babefe592055d68eb8659763c8300558ca5dcb4'  # fonts/SOURCES.md
OUT_DIR = os.path.join(ROOT, 'port', 'build', 'luna')
PACK_NAME = 'data/luna/NORMALBLUE'
INI_NAME = 'NORMALBLUE_INI'   # FILERESNAMES entry 1: NormalColor + NormalSize (THEMES_INI [File.NormalBlue])

MAGIC = b'LUNA'
VERSION = 1
HDR = struct.Struct('<4sHHHHHHIIII')
COLOR = struct.Struct('<HBxBBBx')
METRIC = struct.Struct('<HBxi')
PART = struct.Struct('<HHHBBBBBB4h4h4h2hBBBx4x')
IMAGE = struct.Struct('<HHHHII')
assert (HDR.size, COLOR.size, METRIC.size, PART.size, IMAGE.size) == (32, 8, 8, 48, 16)

SRC_INFERRED, SRC_SYSMETRICS, SRC_INI = 0, 1, 2

# Colour ids = Windows COLOR_* indices (WinUser.h); ids >= 64 are Luna values outside the system colours.
# (id, name, [SysMetrics] key or None, inferred default used when the key is absent)
SYS_COLORS = (
    (0, 'SCROLLBAR', 'Scrollbar', (212, 208, 200)),
    (1, 'BACKGROUND', 'Background', None),
    (2, 'ACTIVECAPTION', 'ActiveCaption', None),
    (3, 'INACTIVECAPTION', 'InactiveCaption', None),
    (4, 'MENU', 'Menu', None),
    (5, 'WINDOW', 'Window', None),
    (6, 'WINDOWFRAME', 'WindowFrame', (0, 0, 0)),
    (8, 'WINDOWTEXT', 'WindowText', (0, 0, 0)),
    (9, 'CAPTIONTEXT', 'CaptionText', None),
    (13, 'HIGHLIGHT', 'Highlight', None),
    (14, 'HIGHLIGHTTEXT', 'HighlightText', None),
    (15, 'BTNFACE', 'Btnface', None),          # COLOR_3DFACE
    (16, 'BTNSHADOW', 'BtnShadow', None),      # COLOR_3DSHADOW
    (17, 'GRAYTEXT', 'GrayText', None),
    (18, 'BTNTEXT', 'BtnText', (0, 0, 0)),
    (19, 'INACTIVECAPTIONTEXT', 'InactiveCaptionText', None),
    (20, 'BTNHIGHLIGHT', 'BtnHighlight', None),  # COLOR_3DHILIGHT
    (21, '3DDKSHADOW', 'DkShadow3d', None),
    (22, '3DLIGHT', 'Light3d', None),
    (27, 'GRADIENTACTIVECAPTION', 'GradientActiveCaption', None),
    (28, 'GRADIENTINACTIVECAPTION', 'GradientInactiveCaption', None),
    (29, 'MENUHILIGHT', 'MenuHilight', None),
    (30, 'MENUBAR', 'MenuBar', None),
)
C_CAPTION_SHADOW = 64   # [Window] TextShadowColor
C_DIALOG_FILL = 65      # [Window.dialog] FillColor (themed dialog background; unused by unthemed dialogs)

# Metric ids.
M_CAPTION_BAR_HEIGHT = 0
M_SMCAPTION_BAR_HEIGHT = 1
M_SMCAPTION_BAR_WIDTH = 2
M_SCROLLBAR_WIDTH = 3
M_SCROLLBAR_HEIGHT = 4
M_CAPTION_FONT = 5       # 5 face, 6 points, 7 weight
M_SMCAPTION_FONT = 8     # 8 face, 9 points, 10 weight
M_MSGBOX_FONT = 11       # 11 face, 12 points, 13 weight
M_SHADOW_DX = 14
M_SHADOW_DY = 15
M_SHADOW_ACTIVE = 16     # caption text shadow type, active window: 0 none, 1 single, 2 continuous
M_SHADOW_INACTIVE = 17
FONT_FACES = {'tahoma': 1, 'trebuchet ms': 2, 'franklin gothic medium': 3}
SHADOW_TYPES = {'none': 0, 'single': 1, 'continuous': 2}

# Part ids, INI section (Class.Part), state-section for the text shadow.
P_CAPTION, P_FRAMELEFT, P_FRAMERIGHT, P_FRAMEBOTTOM, P_CLOSEBUTTON = 1, 2, 3, 4, 5
PARTS = ((P_CAPTION, 'Window.Caption'), (P_FRAMELEFT, 'Window.FrameLeft'), (P_FRAMERIGHT, 'Window.FrameRight'),
         (P_FRAMEBOTTOM, 'Window.FrameBottom'), (P_CLOSEBUTTON, 'Window.CloseButton'))
SIZING = {'stretch': 0, 'tile': 1, 'truesize': 2}
LAYOUT = {'vertical': 0, 'horizontal': 1}
OFFSET_TYPES = {'topleft': 1, 'topright': 2}
PF_TRANSPARENT = 0x01        # Transparent = true (colour key applied to the image)
PF_GLYPH_TRANSPARENT = 0x02  # GlyphTransparent = true
PF_UNIFORM_SIZING = 0x04     # UniformSizing = true
IF_ALPHA = 0x01              # 32-bit source with an alpha channel
IF_COLORKEY = 0x02           # colour-key pixels were set to alpha 0
DEFAULT_TRANSPARENT_COLOR = (255, 0, 255)   # inferred: uxtheme default TransparentColor (magenta)


def load_resources(path):
    """Return (texts, bitmaps): TEXTFILE resources (str) and RT_BITMAP resources (bytes) by name."""
    pe = pefile.PE(path, fast_load=True)
    pe.parse_data_directories(directories=[pefile.DIRECTORY_ENTRY['IMAGE_DIRECTORY_ENTRY_RESOURCE']])
    texts, bitmaps = {}, {}
    for t in pe.DIRECTORY_ENTRY_RESOURCE.entries:
        tname = str(t.name) if t.name is not None else t.id
        if tname not in ('TEXTFILE', 2):
            continue
        for n in t.directory.entries:
            nm = str(n.name) if n.name is not None else str(n.id)
            leaf = n.directory.entries[0]
            data = pe.get_data(leaf.data.struct.OffsetToData, leaf.data.struct.Size)
            if tname == 'TEXTFILE':
                texts[nm] = data.decode('utf-16le')
            else:
                bitmaps[nm] = data
    pe.close()
    return texts, bitmaps


def parse_ini(text):
    """Theme INI: {section_lower: {key_lower: (key, value, line)}}, section names as written in
    sec_names. Comments start with ';' (also after a value). A repeated key keeps the last value."""
    secs, names, cur = {}, {}, None
    for no, raw in enumerate(text.splitlines(), 1):
        line = raw.split(';', 1)[0].strip()
        if not line:
            continue
        if line.startswith('[') and line.endswith(']'):
            name = line[1:-1].strip()
            cur = secs.setdefault(name.lower(), {})
            names[name.lower()] = name
            continue
        if '=' in line and cur is not None:
            k, v = line.split('=', 1)
            cur[k.strip().lower()] = (k.strip(), v.strip(), no)
    return secs, names


def rgb(v):
    p = v.replace(',', ' ').split()
    assert len(p) == 3, v
    c = tuple(int(x) for x in p)
    assert all(0 <= x <= 255 for x in c), v
    return c


def ints(v, n):
    p = [int(x) for x in v.replace(',', ' ').split()]
    assert len(p) == n, v
    return p


def boolean(v):
    return v.strip().lower() in ('true', '1', 'yes')


def font(v):
    p = [x.strip() for x in v.split(',')]
    face = p[0]
    pt = int(p[1])
    weight = 700 if any(x.lower() == 'bold' for x in p[2:]) else 400
    return face, pt, weight


def decode_bmp(d):
    """BITMAP resource (BITMAPINFOHEADER, no file header): returns (w, h, bpp, rgba bytes, top-down)."""
    hs, w, h, planes, bpp, comp, _, _, _, clru, _ = struct.unpack_from('<IiiHHIIiiII', d)
    assert hs == 40 and planes == 1 and comp == 0, (hs, planes, comp)
    off = hs
    pal = []
    if bpp <= 8:
        n = clru or (1 << bpp)
        for i in range(n):
            b, g, r, _ = d[off + 4 * i:off + 4 * i + 4]
            pal.append((r, g, b))
        off += 4 * n
    stride = ((w * bpp + 31) // 32) * 4
    top_down = h < 0
    hh = abs(h)
    assert off + stride * hh <= len(d), 'bitmap data truncated'
    out = bytearray()
    for y in range(hh):
        sy = y if top_down else hh - 1 - y
        row = d[off + sy * stride:off + (sy + 1) * stride]
        for x in range(w):
            if bpp == 32:
                b, g, r, a = row[4 * x:4 * x + 4]
                out += bytes((r, g, b, a))
            elif bpp == 24:
                b, g, r = row[3 * x:3 * x + 3]
                out += bytes((r, g, b, 255))
            else:
                bit = x * bpp
                v = (row[bit // 8] >> (8 - bpp - bit % 8)) & ((1 << bpp) - 1)
                out += bytes(pal[v] + (255,))
    return w, hh, bpp, bytes(out)


def res_name(image_file):
    """INI ImageFile path to resource name: Blue\\frameLeft.bmp gives BLUE_FRAMELEFT_BMP."""
    return image_file.replace('\\', '_').replace('/', '_').replace('.', '_').upper()


class Builder:
    def __init__(self, path=MSSTYLES):
        data = open(path, 'rb').read()
        self.sha256 = hashlib.sha256(data).hexdigest()
        self.texts, self.bitmaps = load_resources(path)
        self.ini, self.ini_names = parse_ini(self.texts[INI_NAME])
        self.themes, _ = parse_ini(self.texts['THEMES_INI'])
        self.colors, self.metrics, self.parts, self.images = [], [], [], []
        self.image_index = {}
        self.doc = {'source': {'file': 'fonts/luna.msstyles', 'sha256': self.sha256, 'ini': INI_NAME},
                    'colors': {}, 'metrics': {}, 'parts': {}, 'images': {}}

    # ---- property lookup: Class.Part(State), Class.Part, Class, globals (inferred uxtheme order) ----
    def prop(self, section, key):
        chain = [section]
        base = section.split('(')[0]
        if base != section:
            chain.append(base)
        if '.' in base:
            chain.append(base.split('.')[0])
        chain.append('globals')
        for s in chain:
            e = self.ini.get(s.lower(), {}).get(key.lower())
            if e is not None:
                return e[1], '%s [%s] %s = %s (line %d)' % (INI_NAME, self.ini_names[s.lower()], e[0], e[1], e[2])
        return None, None

    def sysmetric(self, key):
        return self.prop('SysMetrics', key) if key.lower() in self.ini['sysmetrics'] else (None, None)

    def add_color(self, cid, name, value, source, ref):
        self.colors.append((cid, source, value))
        self.doc['colors'][name] = {'id': cid, 'rgb': list(value), 'status': 'inferred' if source == SRC_INFERRED
                                    else 'verified', 'ref': ref}

    def add_metric(self, mid, name, value, source, ref):
        self.metrics.append((mid, source, value))
        self.doc['metrics'][name] = {'id': mid, 'value': value, 'status': 'inferred' if source == SRC_INFERRED
                                     else 'verified', 'ref': ref}

    def build_colors(self):
        for cid, name, key, default in SYS_COLORS:
            v, ref = self.sysmetric(key)
            if v is not None:
                self.add_color(cid, name, rgb(v), SRC_SYSMETRICS, ref)
            else:
                assert default is not None, 'missing [SysMetrics] %s' % key
                self.add_color(cid, name, default, SRC_INFERRED,
                               'not in [SysMetrics]; Windows default scheme value (inferred)')
        v, ref = self.prop('Window', 'TextShadowColor')
        self.add_color(C_CAPTION_SHADOW, 'CAPTION_SHADOW', rgb(v), SRC_INI, ref)
        v, ref = self.prop('Window.dialog', 'FillColor')
        self.add_color(C_DIALOG_FILL, 'DIALOG_FILL', rgb(v), SRC_INI, ref)

    def build_metrics(self):
        for mid, name, key in ((M_CAPTION_BAR_HEIGHT, 'CaptionBarHeight', 'CaptionBarHeight'),
                               (M_SMCAPTION_BAR_HEIGHT, 'SMCaptionBarHeight', 'SMCaptionBarHeight'),
                               (M_SMCAPTION_BAR_WIDTH, 'SMCaptionBarWidth', 'SMCaptionBarWidth'),
                               (M_SCROLLBAR_WIDTH, 'ScrollbarWidth', 'ScrollbarWidth'),
                               (M_SCROLLBAR_HEIGHT, 'ScrollbarHeight', 'ScrollbarHeight')):
            v, ref = self.sysmetric(key)
            self.add_metric(mid, name, int(v), SRC_SYSMETRICS, ref)
        for mid, name in ((M_CAPTION_FONT, 'CaptionFont'), (M_SMCAPTION_FONT, 'SmallCaptionFont'),
                          (M_MSGBOX_FONT, 'MsgBoxFont')):
            v, ref = self.sysmetric(name)
            face, pt, weight = font(v)
            self.add_metric(mid, name + '.face', FONT_FACES[face.lower()], SRC_SYSMETRICS, ref + ' [face %s]' % face)
            self.add_metric(mid + 1, name + '.points', pt, SRC_SYSMETRICS, ref)
            self.add_metric(mid + 2, name + '.weight', weight, SRC_SYSMETRICS, ref)
        v, ref = self.prop('Window', 'TextShadowOffset')
        dx, dy = ints(v, 2)
        self.add_metric(M_SHADOW_DX, 'TextShadowOffset.x', dx, SRC_INI, ref)
        self.add_metric(M_SHADOW_DY, 'TextShadowOffset.y', dy, SRC_INI, ref)
        v, ref = self.prop('Window.Caption(active)', 'TextShadowType')
        self.add_metric(M_SHADOW_ACTIVE, 'Caption(active).TextShadowType', SHADOW_TYPES[v.lower()], SRC_INI, ref)
        v, ref = self.prop('Window.Caption(inactive)', 'TextShadowType')
        if v is None:
            self.add_metric(M_SHADOW_INACTIVE, 'Caption(inactive).TextShadowType', 0, SRC_INFERRED,
                            'no TextShadowType in [Window.Caption], [Window] or [globals]; default none (inferred)')
        else:
            self.add_metric(M_SHADOW_INACTIVE, 'Caption(inactive).TextShadowType', SHADOW_TYPES[v.lower()],
                            SRC_INI, ref)
        # Cross-check THEMES_INI [Subst.NormalSize] (the size substitution table of the same scheme).
        sub = self.themes['subst.normalsize']
        assert int(sub['captionbarheight'][1]) == self.doc['metrics']['CaptionBarHeight']['value']
        assert font(sub['captionfont'][1]) == ('Trebuchet MS', 10, 700)
        assert font(sub['msgboxfont'][1]) == ('Tahoma', 8, 400)

    def add_image(self, name, transparent, transparent_color):
        key = (name, transparent, transparent_color)
        if key in self.image_index:
            return self.image_index[key]
        w, h, bpp, px = decode_bmp(self.bitmaps[name])
        flags = 0
        alphas = set(px[3::4])
        if bpp == 32 and alphas != {0}:
            flags |= IF_ALPHA     # inferred: an all-zero alpha channel would mean "no alpha"
        elif bpp == 32:
            px = bytes(b if i % 4 != 3 else 255 for i, b in enumerate(px))
        keyed = 0
        if transparent and not flags & IF_ALPHA:
            out = bytearray(px)
            for i in range(0, len(out), 4):
                if tuple(out[i:i + 3]) == transparent_color:
                    out[i:i + 4] = b'\0\0\0\0'
                    keyed += 1
            px = bytes(out)
            flags |= IF_COLORKEY
        idx = len(self.images)
        self.images.append((w, h, flags, bpp, px))
        self.image_index[key] = idx
        self.doc['images'][name] = {'index': idx, 'w': w, 'h': h, 'bpp': bpp, 'alpha': bool(flags & IF_ALPHA),
                                    'colorkey_pixels': keyed, 'sha256_rgba': hashlib.sha256(px).hexdigest()}
        return idx

    def build_parts(self):
        for pid, sec in PARTS:
            d = {'section': sec}

            def get(key, conv=None, default=None, d=d, sec=sec):
                v, ref = self.prop(sec, key)
                if v is None:
                    d[key] = {'value': default, 'status': 'absent'}
                    return default
                val = conv(v) if conv else v
                d[key] = {'value': val, 'ref': ref}
                return val

            image_file = get('ImageFile')
            count = get('ImageCount', int, 1)
            layout = get('ImageLayout', lambda v: LAYOUT[v.lower()], 1)
            sizing_type = get('SizingType', lambda v: SIZING[v.lower()], 0)
            sizing = get('SizingMargins', lambda v: ints(v, 4), [0, 0, 0, 0])
            content = get('ContentMargins', lambda v: ints(v, 4), [0, 0, 0, 0])
            caption = get('CaptionMargins', lambda v: ints(v, 4), [0, 0, 0, 0])
            transparent = get('Transparent', boolean, False)
            tcolor = get('TransparentColor', rgb, None)
            offset_type = get('OffsetType', lambda v: OFFSET_TYPES[v.lower()], 0)
            offset = get('Offset', lambda v: ints(v, 2), [0, 0])
            fill = get('FillColorHint', rgb, (0, 0, 0))
            for key in ('BorderSize', 'TextColor', 'ContentAlignment', 'MinSize', 'BgType', 'TextShadowType',
                        'ImageSelectType', 'GlyphType', 'GlyphImageFile', 'GlyphTransparent', 'UniformSizing',
                        'BorderOnly'):
                get(key)
            if tcolor is None and transparent:
                tcolor = DEFAULT_TRANSPARENT_COLOR
                d['TransparentColor']['inferred_default'] = list(tcolor)
            flags = PF_TRANSPARENT if transparent else 0
            img = self.add_image(res_name(image_file), transparent, tcolor)
            iw, ih = self.images[img][0], self.images[img][1]
            assert (ih if layout == 0 else iw) % count == 0, (sec, iw, ih, count)
            glyph, gcount = 0xFFFF, 0
            if pid == P_CLOSEBUTTON:
                # GlyphType = ImageGlyph without GlyphImageFile: ImageFile1..5 are the glyph images
                # (INI comment "glyphs"); ImageSelectType = size picks the largest one that fits the
                # content rectangle of the button at its own size (inferred selection rule).
                assert d['GlyphType']['value'].lower() == 'imageglyph' and d['ImageSelectType']['value'] == 'size'
                bw = iw if layout == 0 else iw // count
                bh = ih // count if layout == 0 else ih
                cw, ch = bw - content[0] - content[1], bh - content[2] - content[3]
                best = None
                for n in range(1, 6):
                    f = get('ImageFile%d' % n)
                    gw, gh, _, _ = decode_bmp(self.bitmaps[res_name(f)])[:4] if f else (0, 0, 0, 0)
                    gh1 = gh // count
                    if f and gw <= cw and gh1 <= ch and (best is None or gw > best[1]):
                        best = (f, gw)
                gt = get('GlyphTransparent', boolean, False)
                if gt:
                    flags |= PF_GLYPH_TRANSPARENT
                if get('UniformSizing', boolean, False):
                    flags |= PF_UNIFORM_SIZING
                glyph = self.add_image(res_name(best[0]), gt, DEFAULT_TRANSPARENT_COLOR)
                gcount = count
                d['glyph_selected'] = {'file': best[0], 'status': 'inferred (ImageSelectType = size rule)',
                                       'content_box': [cw, ch]}
            self.parts.append((pid, img, glyph, count, gcount, sizing_type, layout, flags, offset_type,
                               sizing, content, caption, offset, fill))
            self.doc['parts'][sec] = d

    def blob(self):
        self.build_colors()
        self.build_metrics()
        self.build_parts()
        self.colors.sort()
        self.metrics.sort()
        colors_off = HDR.size
        metrics_off = colors_off + COLOR.size * len(self.colors)
        parts_off = metrics_off + METRIC.size * len(self.metrics)
        images_off = parts_off + PART.size * len(self.parts)
        data_off = images_off + IMAGE.size * len(self.images)
        out = bytearray(HDR.pack(MAGIC, VERSION, HDR.size, len(self.colors), len(self.metrics), len(self.parts),
                                 len(self.images), colors_off, metrics_off, parts_off, images_off))
        for cid, src, (r, g, b) in self.colors:
            out += COLOR.pack(cid, src, r, g, b)
        for mid, src, v in self.metrics:
            out += METRIC.pack(mid, src, v)
        for (pid, img, glyph, count, gcount, st, lay, flags, ot, sm, cm, capm, off, fill) in self.parts:
            out += PART.pack(pid, img, glyph, count, gcount, st, lay, flags, ot, *sm, *cm, *capm, *off, *fill)
        pos = data_off
        recs, datas = bytearray(), bytearray()
        for (w, h, flags, bpp, px) in self.images:
            recs += IMAGE.pack(w, h, flags, bpp, pos, len(px))
            datas += px
            pos += len(px)    # w * h * 4: always a multiple of 4
        out += recs + datas
        assert len(out) == pos
        self.doc['blob'] = {'name': PACK_NAME, 'bytes': len(out), 'sha256': hashlib.sha256(out).hexdigest()}
        return bytes(out)


def build(path=MSSTYLES):
    """Return (blob, doc)."""
    b = Builder(path)
    if b.sha256 != MSSTYLES_SHA256:
        print('mkluna: warning: luna.msstyles sha256 %s differs from fonts/SOURCES.md' % b.sha256, file=sys.stderr)
    blob = b.blob()
    return blob, b.doc


def pack_entries():
    """For mkpack.py: [(pack name, bytes)]."""
    return [(PACK_NAME, build()[0])]


def main(argv):
    out_dir = OUT_DIR
    if '--out' in argv:
        out_dir = argv[argv.index('--out') + 1]
    quiet = '--quiet' in argv
    blob, doc = build()
    os.makedirs(out_dir, exist_ok=True)
    for name, data in (('normalblue.bin', blob),
                       ('normalblue.json', (json.dumps(doc, indent=1, sort_keys=True) + '\n').encode())):
        p = os.path.join(out_dir, name)
        with open(p + '.tmp', 'wb') as f:
            f.write(data)
        os.replace(p + '.tmp', p)
    if not quiet:
        print('%s: %d bytes, sha256 %s (%d colors, %d metrics, %d parts, %d images)' % (
            PACK_NAME, len(blob), doc['blob']['sha256'], len(doc['colors']), len(doc['metrics']),
            len(doc['parts']), len(doc['images'])))
        print('written to %s' % out_dir)
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
