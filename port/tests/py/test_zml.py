#!/usr/bin/env python3
"""Tests of the engine ZML renderer port/src/text/zml.c (Z:0x416190, analysis/fonts.md 6).

  (a) build: driver tests/native/zml_render.c (host cc, -Werror; also an ASan/UBSan build when the compiler
      supports it); zml.c compiled for wasm32 with the port flags references no libc symbol.
  (b) strings: the ZML strings of the kept shell, read from pack.bin (zap/STRING/<block>), equal
      assets/ZapSpot.exe/decoded/strings.txt and hold no '&'.
  (c) rules and quirks of fonts.md 6.1..6.5 with synthetic strings; expectations computed here from the atlas
      advances and metrics (independent of zml.c).
  (d) pages: every ZML string of the kept shell rendered at its target rectangle (smoothing off and on) into
      port/tests/results/zml/*.png; text-line layout compared with the Wine captures in
      analysis/reference/screens_monofonts/ (Arial 2.82, monochrome) and analysis/reference/screens/
      (Wine substitute font Liberation Sans, antialiased; tools/INFRA.md 3).
Run: python -I -B port/tests/py/test_zml.py   (needs port/build/web/pack.bin; exit status 0 = pass)
"""
import os
import shutil
import struct
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
PORT = os.path.dirname(os.path.dirname(HERE))
ROOT = os.path.dirname(PORT)
sys.path.insert(0, os.path.join(PORT, 'tools'))
import mkatlas  # noqa: E402

NATIVE = os.path.join(PORT, 'build', 'native')
DRIVER = os.path.join(NATIVE, 'zml_render')
DRIVER_ASAN = os.path.join(NATIVE, 'zml_render_asan')
PACK = os.path.join(PORT, 'build', 'web', 'pack.bin')
RESULTS = os.path.join(PORT, 'tests', 'results', 'zml')
REF = os.path.join(ROOT, 'analysis', 'reference')
STRINGS_TXT = os.path.join(ROOT, 'assets', 'ZapSpot.exe', 'decoded', 'strings.txt')
SRCS = [os.path.join(PORT, 'tests', 'native', 'zml_render.c'), os.path.join(PORT, 'src', 'text', 'zml.c'),
        os.path.join(PORT, 'src', 'text', 'gdi_text.c'), os.path.join(PORT, 'src', 'text', 'atlas.c')]
FAIL = []


def check(cond, msg):
    print(('ok   ' if cond else 'FAIL ') + msg)
    if not cond:
        FAIL.append(msg)


# ---------------------------------------------------------------- (a) build

def build():
    print('== (a) build')
    os.makedirs(NATIVE, exist_ok=True)
    cc = os.environ.get('CC', 'cc')
    flags = ['-O2', '-std=c11', '-Wall', '-Wextra', '-Werror', '-ffp-contract=off']
    subprocess.run([cc] + flags + ['-o', DRIVER] + SRCS, check=True)
    asan = subprocess.run([cc] + flags + ['-g', '-fsanitize=address,undefined', '-fno-sanitize-recover=all',
                                          '-o', DRIVER_ASAN] + SRCS, capture_output=True)
    if asan.returncode != 0:
        print('note: no ASan/UBSan build (%s)' % asan.stderr.decode(errors='replace').strip()[:120])
    clang, nm = shutil.which('clang'), shutil.which('llvm-nm')
    if clang and nm:
        with tempfile.TemporaryDirectory() as td:
            obj = os.path.join(td, 'zml.o')
            subprocess.run([clang, '--target=wasm32', '-nostdlib', '-std=c11', '-O2', '-ffp-contract=off',
                            '-fno-math-errno', '-Wall', '-Wextra', '-Werror', '-ffreestanding', '-nostdlibinc',
                            '-I' + os.path.join(PORT, 'src'), '-c', SRCS[1], '-o', obj], check=True)
            und = [ln.split()[-1] for ln in subprocess.run([nm, obj], capture_output=True, text=True,
                                                           check=True).stdout.splitlines() if ' U ' in ln]
            allowed = {'gdi_ext_text_out', 'gdi_font_select', 'gdi_get_text_extent_point32', 'gdi_get_text_metrics',
                       '__stack_pointer', '__indirect_function_table', '__linear_memory'}
            check(set(und) <= allowed, 'zml.c (wasm32, freestanding) references only text/ symbols: %s' % sorted(und))
    else:
        print('note: clang or llvm-nm missing, wasm32 symbol check skipped')
    return os.path.exists(DRIVER_ASAN) and asan.returncode == 0


# ---------------------------------------------------------------- pack, strings, atlases

def read_pack(path):
    d = open(path, 'rb').read()
    assert d[:4] == b'MPAK'
    _, n = struct.unpack_from('<II', d, 4)
    p = 12
    out = {}
    for _ in range(n):
        ln, = struct.unpack_from('<I', d, p)
        name = d[p + 4:p + 4 + ln].decode('ascii')
        off, sz = struct.unpack_from('<II', d, p + 4 + ln)
        out[name] = d[off:off + sz]
        p += 12 + ln
    return out


def pack_strings(pack):
    """zap/STRING/<block>: 16 strings of (u16 length, UTF-16LE); block b holds ids (b - 1) * 16 .. b * 16 - 1."""
    out = {}
    for name, blob in pack.items():
        if not name.startswith('zap/STRING/'):
            continue
        b = int(name.split('/')[-1])
        p = 0
        for i in range(16):
            n, = struct.unpack_from('<H', blob, p)
            p += 2
            s = blob[p:p + 2 * n].decode('utf-16-le')
            p += 2 * n
            if s:
                out[(b - 1) * 16 + i] = s.encode('cp1252')
    return out


def txt_strings(path):
    out = {}
    for ln in open(path, encoding='ascii'):
        if ln.startswith('#') or not ln.strip():
            continue
        i, _, s = ln.rstrip('\n').split('\t', 2)
        assert s[0] == '"' and s[-1] == '"'
        out[int(i)] = s[1:-1].encode('latin-1').decode('unicode_escape').encode('latin-1')
    return out


class Fonts:
    """Advances and metrics from the pack atlases (mkatlas.unpack_atlas), for independent expectations."""

    def __init__(self, pack):
        self.a = {}
        for name, blob in pack.items():
            if name.startswith('font/ARIAL-') and name.endswith('-MONO'):
                a = mkatlas.unpack_atlas(blob)
                self.a[(a['px'], a['weight'])] = a

    def at(self, px, bold=False):
        return self.a[(px, 700 if bold else 400)]

    def w(self, s, px, bold=False):
        a = self.at(px, bold)
        return sum(a['glyphs'][c]['adv'] for c in (s.encode('cp1252') if isinstance(s, str) else s))

    def h(self, px, bold=False):
        return self.at(px, bold)['height']

    def lh(self, px, bold=False):
        a = self.at(px, bold)
        return a['height'] + a['ext_leading']


# ---------------------------------------------------------------- driver

class Driver:
    def __init__(self, exe=DRIVER):
        self.p = subprocess.Popen([exe, PACK], stdin=subprocess.PIPE, stdout=subprocess.PIPE)

    def cmd(self, line):
        self.p.stdin.write(line.encode('latin-1') + b'\n')
        self.p.stdin.flush()
        out = []
        while True:
            r = self.p.stdout.readline().decode('latin-1')
            if not r:
                raise RuntimeError('driver exited at: %s' % line)
            r = r.rstrip('\n')
            if r.startswith('ok') or r.startswith('err'):
                if r.startswith('err'):
                    raise RuntimeError('%s: %s' % (line, r))
                return out, r[3:]
            out.append(r)

    def zml(self, x, y, s, flags=0):
        if isinstance(s, str):
            s = s.encode('cp1252')
        lines, rv = self.cmd('zml %d %d %d %s' % (x, y, flags, s.hex() if s else '-'))
        draws, links, state = [], [], None
        for ln in lines:
            f = ln.split(' ')
            if f[0] == 'd':
                t = b'' if f[7] == '-' else bytes.fromhex(f[7])
                draws.append(dict(kind=int(f[1]), x=int(f[2]), y=int(f[3]), px=int(f[4]), style=int(f[5]),
                                  color=f[6], text=t.decode('cp1252')))
            elif f[0] == 'l':
                t = b'' if f[6] == '-' else bytes.fromhex(f[6])
                links.append(dict(x=int(f[1]), y=int(f[2]), w=int(f[3]), h=int(f[4]), id=int(f[5]),
                                  text=t.decode('cp1252')))
            elif f[0] == 's':
                k = ('face', 'px', 'style', 'color', 'centre', 'shadow', 'T', 'line_max', 'out_x', 'out_y', 'end_x',
                     'end_y', 'nlinks', 'missing')
                state = dict(zip(k, [f[1], int(f[2]), int(f[3]), f[4]] + [int(v) for v in f[5:]]))
                if state['face'] == '-':
                    state['face'] = ''
        return dict(rv=int(rv), draws=draws, links=links, state=state)

    def image(self):
        fd, path = tempfile.mkstemp(suffix='.rgba')
        os.close(fd)
        self.cmd('save ' + path)
        d = open(path, 'rb').read()
        os.unlink(path)
        w, h = struct.unpack_from('<II', d, 4)
        return w, h, d[12:]

    def close(self):
        self.p.stdin.close()
        self.p.wait()


def texts(r, kind=0):
    return [(d['text'], d['x'], d['y']) for d in r['draws'] if d['kind'] == kind]


# ---------------------------------------------------------------- (c) rules and quirks

def quirks(drv, F):
    print('== (c) rules and quirks (fonts.md 6.1..6.5)')
    W, H, LH = F.w, F.h, F.lh
    sp12 = W(' ', 12)
    drv.cmd('image 600 400 0 0 0')
    drv.cmd('links collect')

    def fresh(rect=None):
        drv.cmd('reset 0 0')
        drv.cmd('clearlinks')
        drv.cmd('rect %d %d %d %d' % rect if rect else 'norect')

    # 6.1 tokenizer: one '&' suppresses the whole string; plain flag
    fresh()
    drv.zml(0, 0, 'x')
    r = drv.zml(10, 10, '<S3><B>abc&def')
    check(r['rv'] == 0x15 and not r['draws'] and r['state']['style'] == 0 and r['state']['px'] == 18
          and r['state']['line_max'] == H(18),
          "6.1 '&' anywhere: return 0x15 before the layout, nothing drawn, no state change (Z:0x4163e1)")
    r = drv.zml(10, 10, '<S3>ab<B>&c')
    check(r['rv'] == 0x15 and not r['draws'], "6.1 '&' right after a tag: 0x15")
    r = drv.zml(10, 10, '<B>x&<U>', 1)
    check(r['rv'] == 0 and texts(r) == [('<B>x&<U>', 10, 10)], '6.1 flags bit 0: one plain text token, no tags')
    r = drv.zml(10, 10, '  a  <S3> b  ')
    check(texts(r) == [('  a  ', 10, 10), (' b  ', 10 + W('  a  ', 18), 10)],
          '6.1 spaces kept: leading, inner and trailing spaces belong to the text tokens')
    # 6.3 tags, font changes, top alignment
    fresh()
    r = drv.zml(5, 7, '<S3>ab<S1>cd<S2><B>ef</B><S4>gh')
    check(texts(r) == [('ab', 5, 7), ('cd', 5 + W('ab', 12), 7), ('ef', 5 + W('ab', 12) + W('cd', 18), 7),
                       ('gh', 5 + W('ab', 12) + W('cd', 18) + W('ef', 14, True), 7)]
          and [d['px'] for d in r['draws']] == [12, 18, 14, 10] and r['draws'][2]['style'] == 1,
          '6.3 <Sn> sets px only, <B> bold; tokens of different sizes share the top edge (TA_TOP)')
    fresh()
    r = drv.zml(0, 0, '<S->a')
    r2 = drv.zml(0, 0, '<S3><S+>b')
    check(r['draws'][0]['px'] == 18 and r2['draws'][0]['px'] == 24,
          '6.3 <S-> gives index 1 (18 px), <S+> index 0 (24 px): font object index is always 0 (Z:0x427d2b)')
    fresh()
    r = drv.zml(0, 0, '<S3><b>a</B><u>b</U><i>c</i></b>d')
    check([d['style'] for d in r['draws']] == [1, 4, 2, 0], '6.3 B/U/I set and clear style bits 1/4/2, any case')
    fresh()
    r = drv.zml(0, 0, '<C12zZ5F>a<cABCDEF>b</C00ff00>c<Cfff>d')
    check([d['color'] for d in r['draws']] == ['12005f', 'abcdef', '00ff00', 'fff0d0'],
          '6.3 colour: 6 hex digits, non-hex = 0, also when closing, reads past a short tag (Z:0x416150)')
    fresh()
    r = drv.zml(0, 0, '<S3><H2>a<S3><Q>b<1x><>c</>')
    check(texts(r)[0] == ('a', 0, LH(18, True)) and r['draws'][0]['px'] == 18 and r['draws'][0]['style'] == 1
          and [t for t, _, _ in texts(r)] == ['a', 'b', 'c'],
          '6.3 <H2>: preset 1 (Arial 18 bold), two newlines; unknown tags ignored')
    fresh()
    r = drv.zml(0, 0, '<FArial>a</F>b<FNoSuchFace>c')
    check(r['state']['face'] == 'NoSuchFace' and all(d['px'] == 18 for d in r['draws']) and len(r['draws']) == 3
          and r['state']['missing'] == 0,
          '6.3 <F...> sets the face (also </F>: empty); unknown faces map to Arial (inferred)')
    # newline rule (quirk 7) and <BR>, </BR>, <P>
    fresh()
    r = drv.zml(3, 4, '<S3>a<BR>b</br>c<P>d')
    check(texts(r) == [('a', 3, 4), ('b', 0, 4 + 15), ('c', 0, 4 + 30), ('d', 0, 4 + 60)],
          '6.3 <BR> and </BR> newline, <P> two newlines; x back to rect.left')
    fresh((20, 0, 600, 400))
    r = drv.zml(50, 4, '<S1>a<BR>b<BR>c<S3><BR>d<BR>e')
    y2 = 4 + H(18) + LH(18)
    check(texts(r) == [('a', 50, 4), ('b', 20, 4 + H(18)), ('c', 20, y2), ('d', 20, y2 + LH(18)),
                       ('e', 20, y2 + LH(18) + LH(12))],
          'quirk 7: first line advance tmHeight (%d), later lines tmHeight + external leading (%d); newline x = '
          'rect.left' % (H(18), LH(18)))
    # centring (quirk 6), shadow, rect.left subtracted
    fresh((100, 0, 300, 400))
    r = drv.zml(100, 10, '<S3><C>ab<B>cdef</B></C>g')
    wab, wcd = W('ab', 12), W('cdef', 12, True)
    check(texts(r) == [('ab', (300 - wab - 100) // 2, 10), ('cdef', (300 - wcd - 100) // 2, 10),
                       ('g', 100 + wab + wcd, 10)],
          'quirk 6: each centred token on its own, dx = (right - cx - left) / 2 (left subtracted); x advances '
          'from x, not dx')
    fresh((0, 0, 99, 400))
    r = drv.zml(0, 0, '<S3><C>abc')
    check(texts(r) == [('abc', (99 - W('abc', 12)) // 2, 0)], 'centring: C integer division')
    fresh()
    r = drv.zml(10, 20, '<S3><CFF0000><SH>ab</SH>c')
    check([(d['kind'], d['text'], d['x'], d['y'], d['color']) for d in r['draws']] ==
          [(1, 'ab', 11, 21, '000000'), (0, 'ab', 10, 20, 'ff0000'), (0, 'c', 10 + W('ab', 12), 20, 'ff0000')]
          and r['state']['color'] == 'ff0000',
          '6.4 shadow: black copy at (+1, +1) first, colour restored')
    # word wrap (quirks 2..5)
    fresh((0, 0, W('aaa bbb', 12) + 2, 400))
    r = drv.zml(0, 0, '<S3><SH><C>aaa bbb ccc')
    check(texts(r) == [('aaa bbb', 0, 0), ('ccc', 0, 15)] and not texts(r, 1),
          'quirk 2: a wrapped token is drawn without shadow and without centring; break at the last space')
    R = W('aaaa bbbb', 12)
    fresh((0, 0, R, 400))
    r = drv.zml(0, 0, '<S3>aaaa bbbb <B>c')
    check(texts(r) == [('aaaa bbbb', 0, 0), ('', R, 15), ('c', 0, 30)],
          'quirk 4: only the trailing space overflows: next token starts at rect.left + width (%d), wraps to a '
          'third line' % R)
    fresh((0, 0, W('aaaa', 12) + 2, 400))
    r = drv.zml(0, 0, '<S3>aaaa  bb')
    check(texts(r) == [('aaaa', 0, 0), (' bb', 0, 15)], 'quirk 5: two spaces at a break, one stays at the line start')
    wa = W('aaaa', 12)
    R = wa + W('bbb', 12, True) + 1
    fresh((0, 0, R, 400))
    r = drv.zml(0, 0, '<S3>aaaa<B>bbbbbbbb')
    k = max(i for i in range(9) if wa + W('b' * i, 12, True) <= R)
    k2 = max(i for i in range(9 - k) if W('b' * i, 12, True) <= R)
    check(texts(r)[:3] == [('aaaa', 0, 0), ('b' * k, wa, 0), ('b' * k2, 0, 15)],
          'quirk 3: a run without a space breaks mid-word at the character-fit length (%d)' % k)
    R = W('aaaa', 12) + W(' b', 12, True) + 1
    fresh((0, 0, R, 400))
    r = drv.zml(0, 0, '<S3>aaaa<B> bbbbbb')
    kk = max(i for i in range(8) if W('aaaa', 12) + W(' bbbbbb'[:i], 12, True) <= R)
    check(kk == 2 and texts(r)[1] == (' b', W('aaaa', 12), 0),
          'wrap: a space at index 0 is no break point, mid-word break (Z:0x416924)')
    fresh((0, 0, 5, 400))
    r = drv.zml(0, 0, '<S3>WW')
    check(r['rv'] == 0 and len(r['draws']) <= 3, 'port: no endless loop when not one character fits (original hangs)')
    # last-piece x advance after a wrap
    R = W('aaa bbb', 12) + 2
    fresh((0, 0, R, 400))
    r = drv.zml(0, 0, '<S3>aaa bbb ccc<B>d')
    check(texts(r)[-1] == ('d', W('ccc', 12), 15), 'wrap: x continues after the last piece')
    # ellipsis and no-wrap modes
    R = 60
    fresh((0, 0, R, 400))
    r = drv.zml(5, 0, '<S3><E>abcdefghijklmn</E>')
    s, x0, sp, dot = 'abcdefghijklmn', 5, sp12, W('.', 12)
    n, cx = len(s), W(s, 12)
    lim = R - 3 * dot
    if sp + cx + x0 > lim:
        while n > 0:
            old = n
            n -= 1
            cx = W(s[:old], 12)
            if sp + cx + x0 <= lim:
                break
    check([(d['kind'], d['text'], d['x']) for d in r['draws']] == [(0, s[:n], x0 + sp), (2, '...', x0 + cx - sp)]
          and r['state']['out_x'] == x0 + 3 * dot + cx,
          'E mode: text at x + space (%d chars, old-length measure), "..." at x + cx - space, x += 3 dots + cx' % n)
    fresh((0, 0, 30, 400))
    r = drv.zml(4, 0, '<S3><N>abcdefgh</N>')
    check(texts(r) == [('abcdefgh', 4 + sp12, 0)] and r['state']['out_x'] == 4 + W('abcdefgh', 12),
          'N mode: no wrap, drawn at x + space width')
    r = drv.zml(40, 0, '<S3><N>abc')
    check(texts(r) == [] and r['state']['out_x'] == 40 + W('abc', 12), 'N mode: x >= rect.right draws nothing')
    # links (6.4 make_link, 6.5 CHyperLink)
    fresh()
    r = drv.zml(10, 30, '<S3>go <A123>here</A> now')
    lk = r['links']
    check(texts(r) == [('go ', 10, 30), (' now', 10 + W('go ', 12) + W('here', 12), 30)] and len(lk) == 1
          and (lk[0]['x'], lk[0]['y'], lk[0]['w'], lk[0]['h'], lk[0]['id'], lk[0]['text']) ==
          (10 + W('go ', 12), 30, W('here', 12) + sp12, H(12) + 2, 123, 'here') and r['draws'][1]['style'] == 0,
          'link: not drawn by the renderer; CHyperLink at (x, y), size (12 px width + space, height + 2), id 123; '
          '</A> clears underline')
    fresh()
    r = drv.zml(0, 0, '<S2><B><A7>xy</A></B>z')
    lk = r['links'][0]
    check((lk['w'], lk['h']) == (W('xy', 12, True) + W(' ', 12, True), H(12, True) + 2)
          and texts(r) == [('z', W('xy', 14, True), 0)],
          'link in 14 bold: measured in (Arial, 12, current style), x advances by the 14 px width')
    fresh((40, 0, 400, 400))
    r = drv.zml(40, 5, '<S1><C><A9>hi</A>')
    check(r['links'][0]['x'] == (400 - W('hi', 18) - 40) // 2, 'link centred: x from the cx of the current font')
    fresh((0, 0, W('ab ', 12) + W('cd ef', 12), 400))
    r = drv.zml(0, 0, '<S3>ab <A5>cd efgh</A>')
    check(not r['links'] and texts(r) == [('ab ', 0, 0), ('cd', W('ab ', 12), 0), ('efgh', 0, 15)],
          'quirk 1: link text that does not fit is drawn as plain text by the wrap path, no link')
    fresh()
    r = drv.zml(0, 0, '<S3><A>12</A><A1x2>a</A><A1234567>b</A><A5>c</A><A>d')
    ids = [l['id'] for l in r['links']]
    check(ids == [-88, 12, 12345, 5, 5] and [l['text'] for l in r['links']] == ['12', 'a', 'b', 'c', 'd'],
          '<A> id: digits at tag positions 1..5, also past ">"; starts from the previous id (-1 initially): %s' % ids)
    # persistence between calls (fonts.md 5), line_max reset, T flag
    fresh()
    drv.zml(0, 0, '<S3><B><C00ff00><SH><C>')
    r = drv.zml(0, 50, 'abc')
    check([(d['kind'], d['px'], d['style'], d['color']) for d in r['draws']] == [(1, 12, 1, '000000'), (0, 12, 1, '00ff00')]
          and texts(r) == [('abc', (600 - W('abc', 12, True)) // 2, 50)],
          'state persists between calls: font, colour, shadow, centre')
    r = drv.zml(0, 0, '</B></SH></C>a<BR>b')
    check(texts(r) == [('a', 0, 0), ('b', 0, 15)], 'line maximum starts at 0 in every call (Z:0x416213)')
    fresh()
    drv.cmd('image 60 30 10 20 30')
    drv.cmd('bk 200 100 50')
    r = drv.zml(5, 5, '<S3></T>ab<T>')
    w, h, px = drv.image()
    cell = px[4 * (6 * 60 + 6):4 * (6 * 60 + 6) + 3]
    check(r['state']['T'] == 1 and tuple(cell) == (200, 100, 50), '</T>: OPAQUE cell in the background colour; <T> back')
    drv.cmd('image 600 400 0 0 0')
    # tokens over the bound
    fresh()
    r = drv.zml(0, 0, '<B>' * 1100)
    check(r['rv'] == -1, 'port: more than 1024 tokens returns -1 (original: stack overflow)')
    # tab title (Z:0x41b7f0): state from a tags-only call
    fresh()
    drv.cmd('color 0 0 0')
    drv.zml(0, 0, '<S1></b><t></u></i>')
    r = drv.zml(0, 0, 'Moeboid')
    check(texts(r) == [('Moeboid', 0, 0)] and r['draws'][0]['px'] == 18 and r['draws'][0]['style'] == 0,
          'tab title: Arial 18 regular from the tags-only call')
    # CHyperLink drawing = the ZML string drawn in a new context on the link surface
    for hover in (0, 1):
        fresh()
        drv.cmd('image 80 20 40 40 40')
        r = drv.zml(0, 0, '<S3><A3>Link</A>')
        lk = r['links'][0]
        drv.cmd('drawlinks %d' % hover)
        _, _, a = drv.image()
        drv.cmd('image 80 20 40 40 40')
        drv.cmd('reset 1 0')
        drv.cmd('rect 0 0 %d %d' % (lk['w'], lk['h']))
        pre = '<T><S3><U><C><Sh><CFFF000>' if hover else '<T><S3><U><SH><C><CFFFFFF>'
        suf = '</C></sh></U>' if hover else '</C></SH></U>'
        r2 = drv.zml(0, 0, pre + 'Link' + suf)
        _, _, b = drv.image()
        dx = (lk['w'] - W('Link', 12)) // 2
        col = (255, 240, 0) if hover else (255, 255, 255)
        cols = {tuple(a[i:i + 3]) for i in range(0, len(a), 4)}
        check(a == b and texts(r2) == [('Link', dx, 0)] and texts(r2, 1) == [('Link', dx + 1, 1)]
              and col in cols and (0, 0, 0) in cols,
              'CHyperLink %s: Arial 12 underlined, shadow, centred at dx %d, colour %s; equals one ZML string'
              % ('hover' if hover else 'normal', dx, '#FFF000' if hover else '#FFFFFF'))
    # link sink modes: collect (sink only, nothing drawn) and NULL sink (drawn on top at the end of the call)
    for mode in ('collect', 'draw'):
        fresh()
        drv.cmd('image 80 20 0 0 0')
        drv.cmd('links ' + mode)
        r = drv.zml(0, 0, '<S3><A1>Hi</A>')
        _, _, a = drv.image()
        lit = any(a[i] for i in range(0, len(a), 4))
        check(lit == (mode == 'draw') and (len(r['links']) == (1 if mode == 'collect' else 0)),
              'links %s: %s' % (mode, 'reported to the sink, not drawn' if mode == 'collect' else
                                'NULL sink, drawn by zml_draw'))
    drv.cmd('links collect')
    drv.cmd('image 600 400 0 0 0')
    drv.cmd('reset 0 0')
    drv.cmd('norect')


def asan_run(exe):
    """The quirk strings and malformed tags under ASan/UBSan (memory errors abort the driver)."""
    d = Driver(exe)
    d.cmd('image 300 200 0 0 0')
    d.cmd('ctx 0 0')
    d.cmd('links draw')
    bad = ['<', '<B', 'abc<', '<A', '<A1', '<C', '<C1', '<F', '<FArial', '<S', '<S9>x', '<Sx>x', '<H9>x', '<H>x',
           '</', '<>', '<<>>', 'a<A>b', '<E>' + 'x' * 300, '<N>' + 'y' * 300, ' ' * 50, '<S3>' + 'w ' * 400]
    for s in bad:
        d.zml(3, 3, s)
        d.zml(3, 3, s, 1)
    d.cmd('rect 0 0 4 50')
    d.zml(0, 0, '<S3>WWW W W  W')
    d.cmd('drawlinks 1')
    d.close()
    check(d.p.returncode == 0, 'ASan/UBSan driver: malformed tags, tiny rect, plain mode, no error')


# ---------------------------------------------------------------- (d) pages

PAGE = (282, 50, 500, 420)        # page surface ctx[3] (shell +0x2cc), rendering.md 7
TITLE = (278, 20, 400, 24)        # title strip, Z:0x41b7f0
LOGO = (10, 10, 175, 135)         # IMG-ZAPLOGO surface
ROOTF = (0, 0, 800, 572)          # root image


def help_values():
    # Z:0x41c5a3..0x41c6a2: values of page 118, as in the Wine capture frame_help_extended_support_info.png
    return [(180, 0x41, b'<S2>%s' % b'01.01.01.1034'), (180, 0x51, b'{00000000-0000-0000-0000-000000000000}'),
            (180, 0x61, b'Not Installed'), (180, 0x81, b'Moeboid'), (180, 0x91, b'00.01.01.08')]


def footer(S):
    # Z:0x41b290: separator lines (5,380)-(495,380), (5,381)-(495,381) in #333333, str 10017 at (0, 392)
    return [('fill', 5, 380, 495, 382, 0x33, 0x33, 0x33), ('norect',), ('zml', 0, 392, 0, S[10017])]


def page_specs(S):
    P = []
    hv = {101: 'frame_help_table_of_contents', 111: 'frame_help_getting_started', 113: 'frame_help_enjoying_games',
          118: 'frame_help_extended_support_info'}
    for pid in (101, 111, 112, 113, 114, 115, 116, 117, 118):
        ops = [('norect',), ('zml', 0, 0, 0, S[pid])]          # Z:0x41c591: (0, 0), rect NULL
        if pid == 118:
            ops += [('zml', x, y, 0, s) for x, y, s in help_values()]
        ops += footer(S)                                       # a game runs in the captures
        P.append(dict(name='help_%d' % pid, surf=PAGE, bg=(0, 0, 0), ops=ops,
                      caps=['screens/%s.png' % hv[pid]] if pid in hv else [],
                      regions=[((0, 0, 500, 378), 'bright'), ((0, 382, 440, 420), 'bright')]))
    # About Z:0x420d80: SetTextColor(255,255,255), str 1001 at (15,15) rect (15,15,485,405); "v1.1" at (470,5)
    P.append(dict(name='about', surf=PAGE, bg=(0, 0, 0), caps=['screens/frame_about.png'],
                  ops=[('color', 255, 255, 255), ('rect', 15, 15, 485, 405), ('zml', 15, 15, 0, S[1001]),
                       ('norect',), ('zml', 470, 5, 0, b'<S3><C999999>v%d.%d' % (1, 1))],
                  regions=[((0, 18, 500, 323), 'bright'), ((0, 323, 390, 420), 'bright'), ((440, 0, 500, 17), 'grey')]))
    # Personalize Z:0x422b90 (kept part, decision 8c): str 1101 at (15,15) rect (15,15,485,405);
    # str 1102 + 1103/1104 at (22, 250), rect NULL (also Z:0x423260 after Toggle)
    for on, cap in ((1, 'frame_personalize_sound_on'), (0, 'frame_personalize_sound_off')):
        P.append(dict(name='personalize_sound_%s' % ('on' if on else 'off'), surf=PAGE, bg=(0, 0, 0),
                      caps=['screens/%s.png' % cap],
                      ops=[('color', 255, 255, 255), ('rect', 15, 15, 485, 405), ('zml', 15, 15, 0, S[1101]),
                           ('norect',), ('zml', 22, 250, 0, S[1102] + S[1103 if on else 1104])],
                      regions=[((0, 0, 500, 225), 'bright'), ((0, 240, 340, 275), 'bright')]))
    # View All Games Z:0x41f500: str 1201 at (1, 3); 1203/1204/1205 at (50|210|370, 407); rect NULL
    P.append(dict(name='view_all_games', surf=PAGE, bg=(0, 0, 0), caps=['screens/frame_view_all_games.png'],
                  ops=[('color', 255, 255, 255), ('norect',), ('zml', 1, 3, 0, S[1201]),
                       ('color', 0x66, 0x66, 0xff), ('zml', 50, 407, 0, S[1203]), ('zml', 210, 407, 0, S[1204]),
                       ('zml', 370, 407, 0, S[1205])],
                  regions=[((0, 0, 200, 15), 'white'), ((0, 408, 500, 420), 'white')]))
    # Pause Z:0x41cb30: str 10016 at (50, 185), rect NULL; then the paused footer
    P.append(dict(name='pause', surf=PAGE, bg=(0, 0, 0), caps=['screens/frame_game_paused.png'],
                  ops=[('norect',), ('zml', 50, 185, 0, S[10016])] + footer(S),
                  regions=[((0, 150, 500, 240), 'bright'), ((0, 382, 440, 410), 'bright')]))
    # News text Z:0x41e6b4: str 10003 at (52, 294), rect (52, 294, 150, 346), root image #3333CC
    P.append(dict(name='news', surf=ROOTF, bg=(0x33, 0x33, 0xcc),
                  caps=['screens_monofonts/frame_title_installed.png', 'screens/frame_title_first_run.png'],
                  ops=[('rect', 52, 294, 150, 346), ('zml', 52, 294, 0, S[10003])],
                  regions=[((40, 288, 170, 350), 'bright')]))
    # Logo link text Z:0x41e244: "<s4><CFFFFFF><u><c>www.ZapSpot.com" at (0, 114) of the logo surface (new context)
    P.append(dict(name='logo_link', surf=LOGO, bg=(0x33, 0x33, 0xcc),
                  caps=['screens_monofonts/frame_title_installed.png', 'screens/frame_title_first_run.png'],
                  ops=[('norect',), ('zml', 0, 114, 0, b'<s4><CFFFFFF><u><c>www.ZapSpot.com')],
                  regions=[((0, 113, 175, 132), 'white')]))
    # Tab titles Z:0x41b7f0: clear #FFCC00, colour black, "<S1></b><t></u></i>" then the title at (0, 0)
    for name, s, cap in (('help', S[100], 'frame_help_table_of_contents'), ('about', S[1000], 'frame_about'),
                         ('personalize', S[1100], 'frame_personalize_sound_on'),
                         ('view_all_games', S[1200], 'frame_view_all_games'), ('moeboid', b'Moeboid',
                                                                               'frame_game_paused')):
        P.append(dict(name='title_' + name, surf=TITLE, bg=(0xff, 0xcc, 0x00), caps=['screens/%s.png' % cap],
                      ops=[('color', 0, 0, 0), ('norect',), ('zml', 0, 0, 0, b'<S1></b><t></u></i>'),
                           ('zml', 0, 0, 0, s)],
                      regions=[((0, 0, 70 if name == 'moeboid' else 400, 24), 'dark')]))
    return P


def render_page(drv, spec, smooth):
    x0, y0, w, h = spec['surf']
    drv.cmd('image %d %d %d %d %d' % ((w, h) + spec['bg']))
    drv.cmd('reset 0 %d' % smooth)
    drv.cmd('links collect')
    drv.cmd('clearlinks')
    log = []
    for op in spec['ops']:
        if op[0] == 'zml':
            r = drv.zml(op[1], op[2], op[4], op[3])
            check(r['rv'] == 0 and r['state']['missing'] == 0, '%s: zml (%d, %d) returns 0, all fonts present'
                  % (spec['name'], op[1], op[2]))
            log.append(r)
        elif op[0] == 'rect':
            drv.cmd('rect %d %d %d %d' % op[1:])
        elif op[0] == 'norect':
            drv.cmd('norect')
        elif op[0] == 'color':
            drv.cmd('color %d %d %d' % op[1:])
        elif op[0] == 'fill':
            drv.cmd('fill %d %d %d %d %d %d %d' % op[1:])
    drv.cmd('drawlinks 0')      # child surfaces above the page text
    return drv.image(), log


def save_png(path, w, h, rgba):
    from PIL import Image
    Image.frombytes('RGBA', (w, h), rgba).convert('RGB').save(path, optimize=True)


def ink_fn(rule):
    if rule == 'bright':
        return lambda r, g, b: g >= 128
    if rule == 'white':
        return lambda r, g, b: min(r, g, b) >= 128
    if rule == 'grey':
        return lambda r, g, b: max(r, g, b) >= 96      # grey text, also with colour fringes (screens/)
    return lambda r, g, b: max(r, g, b) < 100


def bands(get, region, rule):
    """Text lines in a region: groups of consecutive rows with ink; per band (top, bottom, left, right)."""
    x0, y0, x1, y1 = region
    ink = ink_fn(rule)
    rows = []
    for y in range(y0, y1):
        xs = [x for x in range(x0, x1) if ink(*get(x, y))]
        rows.append((y, min(xs), max(xs)) if xs else None)
    out, cur = [], None
    for r in rows + [None]:
        if r is None:
            if cur:
                out.append(tuple(cur))
            cur = None
        elif cur is None:
            cur = [r[0], r[0], r[1], r[2]]
        else:
            cur[1] = r[0]
            cur[2] = min(cur[2], r[1])
            cur[3] = max(cur[3], r[2])
    return out


def compare(spec, img, cap_path):
    from PIL import Image
    w, h, rgba = img
    x0, y0 = spec['surf'][:2]
    cap = Image.open(cap_path).convert('RGB').load()

    def mine(x, y):
        i = 4 * (y * w + x)
        return rgba[i], rgba[i + 1], rgba[i + 2]

    def theirs(x, y):
        return cap[x0 + x, y0 + y]

    res = []
    for region, rule in spec['regions']:
        a, b = bands(mine, region, rule), bands(theirs, region, rule)
        res.append((region, a, b))
    return res


def layout_diff(spec, img, cap_path):
    """(port lines, capture lines, max |d top|, |d bottom|, |d left|, |d right|, band pairs)."""
    res = compare(spec, img, cap_path)
    d = [0, 0, 0, 0]
    rows = []
    for _, a, b in res:
        for p, q in zip(a, b):
            for i in range(4):
                d[i] = max(d[i], abs(p[i] - q[i]))
            rows.append((p, q))
    if os.environ.get('ZML_VERBOSE'):
        for _, a, b in res:
            for i in range(max(len(a), len(b))):
                print('   %s: port %-22s capture %s' % (spec['name'], a[i] if i < len(a) else None,
                                                       b[i] if i < len(b) else None))
    return (sum(len(a) for _, a, _ in res), sum(len(b) for _, _, b in res)) + tuple(d) + (rows,)


def pages(drv, S):
    print('== (d) pages: kept shell ZML strings at their target rectangles')
    os.makedirs(RESULTS, exist_ok=True)
    summary = []
    for spec in page_specs(S):
        img0, log0 = render_page(drv, spec, 0)
        img1, log1 = render_page(drv, spec, 1)
        save_png(os.path.join(RESULTS, spec['name'] + '_mono.png'), *img0)
        save_png(os.path.join(RESULTS, spec['name'] + '_smooth.png'), *img1)
        same = [[(d['x'], d['y'], d['text']) for d in r['draws']] for r in log0] == \
               [[(d['x'], d['y'], d['text']) for d in r['draws']] for r in log1]
        check(same, '%s: layout with smoothing on equals smoothing off' % spec['name'])
        for cap in spec['caps']:
            path = os.path.join(REF, cap)
            if not os.path.exists(path):
                print('note: missing capture %s' % cap)
                continue
            d = layout_diff(spec, img0, path)
            summary.append((spec['name'], cap.split('/')[0]) + d[:6])
            if 'monofonts' in cap:
                check(d[0] == d[1] and d[2] == 0 and d[3] == 0 and d[4] <= 1 and d[5] <= 1,
                      '%s vs %s (Wine, Arial 2.82, mono): %d/%d lines, max |d top| %d, |d left| %d, |d right| %d'
                      % (spec['name'], cap, d[0], d[1], d[2], d[4], d[5]))
    print('== layout against the captures (lines = ink bands; d = |capture - port|, pixels). screens/ was captured '
          'with Liberation Sans (tools/INFRA.md 3): there the differences come from the font metrics; '
          'test_zml_wine.py checks the layout with a Liberation Sans model')
    print('%-24s %-18s %5s %5s %5s %6s %5s %5s' % ('page', 'capture', 'lines', 'cap', 'top', 'bottom', 'left', 'right'))
    for r in summary:
        print('%-24s %-18s %5d %5d %5d %6d %5d %5d' % r)
    return summary


def main():
    asan_ok = build()
    pack = read_pack(PACK)
    print('== (b) strings')
    S = pack_strings(pack)
    T = txt_strings(STRINGS_TXT)
    kept = [100, 101] + list(range(111, 119)) + [1000, 1001, 1100, 1101, 1102, 1103, 1104, 1200, 1201, 1203, 1204,
                                                  1205, 10003, 10016, 10017]
    check(all(S.get(i) == T.get(i) for i in kept), 'pack strings = strings.txt for %d kept ids' % len(kept))
    check(not any(b'&' in S[i] for i in kept), "no kept string contains '&' (fonts.md 6.1)")
    F = Fonts(pack)
    drv = Driver()
    drv.cmd('ctx 0 0')
    quirks(drv, F)
    pages(drv, S)
    drv.close()
    if asan_ok:
        asan_run(DRIVER_ASAN)
    print('result: %s' % ('PASS' if not FAIL else 'FAIL (%d)' % len(FAIL)))
    return 1 if FAIL else 0


if __name__ == '__main__':
    sys.exit(main())
