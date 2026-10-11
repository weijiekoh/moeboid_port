#!/usr/bin/env python3
"""ZML layout against the Wine captures in analysis/reference/screens/ (help, About, Personalize, View All Games,
pause, news, logo link, tab titles).

Those captures were made with the Wine substitute font for Arial, Liberation Sans, antialiased (tools/INFRA.md 3;
host fontconfig: fc-match Arial = LiberationSans-Regular.ttf). Its metrics differ from Arial 2.82 (12 px: tmHeight
14 instead of 15; other advances), so the port's Arial layout cannot match them pixel for pixel. This test checks
the layout code itself: it builds a temporary pack whose "Arial" atlases come from the host Liberation Sans 2.1.5
files, with the metrics of a font without VDMX (ascent and descent = usWinAscent / usWinDescent scaled and rounded,
mkatlas.TTF.metrics) and the unhinted advance rounded to whole pixels (inferred Wine rule for antialiased text;
the hinted v35 advances give different line breaks on help 111). It then renders every page with the port
renderer and requires: same number of text lines, line tops equal, line start x and end x within 2 pixels
(antialiased glyph edges). Skipped (exit 0) when the Liberation Sans files or the FreeType helper are missing.
Run: python -I -B port/tests/py/test_zml_wine.py
"""
import os
import struct
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import test_zml as T  # noqa: E402
import mkatlas  # noqa: E402  (path set by test_zml)

LIB = {400: '/usr/share/fonts/liberation/LiberationSans-Regular.ttf',
       700: '/usr/share/fonts/liberation/LiberationSans-Bold.ttf'}


def write_pack(path, entries):
    """MPAK version 1 (port-design.md 7): sorted names, data on 4-byte boundaries."""
    items = sorted(entries.items(), key=lambda e: e[0].encode('ascii'))
    dir_len = 12 + sum(12 + len(n) for n, _ in items)
    data_off = (dir_len + 3) & ~3
    hdr = bytearray(b'MPAK' + struct.pack('<II', 1, len(items)))
    data = bytearray()
    offs = []
    for _, b in items:
        offs.append(data_off + len(data))
        data += b
        data += b'\0' * (-len(data) % 4)
    for (n, b), o in zip(items, offs):
        hdr += struct.pack('<I', len(n)) + n.encode('ascii') + struct.pack('<II', o, len(b))
    hdr += b'\0' * (data_off - len(hdr))
    open(path, 'wb').write(bytes(hdr) + bytes(data))


def liberation_pack(path):
    pack = T.read_pack(T.PACK)
    mkatlas.ensure_tool(print)
    codes = [mkatlas.cp1252_unicode(c) for c in range(256)]
    for weight, font in LIB.items():
        f = mkatlas.TTF(font)
        for px in mkatlas.ARIAL_SIZES:
            _, mono = mkatlas.ft_render(font, px, 'mono', codes)
            _, lin = mkatlas.ft_render(font, px, 'gray', codes, nohint=True)
            for g, u in zip(mono, lin):
                g['adv'] = (u['adv26'] + 32) >> 6
            name = mkatlas.entry_name('Arial', px, weight, mkatlas.MODE_MONO)
            pack[name] = mkatlas.pack_atlas('Arial', px, weight, mkatlas.MODE_MONO, mkatlas.F_HINTED, 0, 255, 0x1f,
                                            f.metrics(px), '%s %s' % (f.file, f.version), mono)
            pack.pop(name.replace('-MONO', '-GRAY'), None)
    write_pack(path, pack)
    return f.version


def main():
    missing = [p for p in LIB.values() if not os.path.exists(p)]
    if missing:
        print('skip: Liberation Sans files missing: %s' % missing)
        return 0
    if not os.path.exists(T.DRIVER):
        T.build()
    real = T.read_pack(T.PACK)
    S = T.pack_strings(real)
    with tempfile.TemporaryDirectory() as td:
        path = os.path.join(td, 'pack_liberation.bin')
        try:
            ver = liberation_pack(path)
        except (OSError, SystemExit) as e:
            print('skip: FreeType helper unavailable (%s)' % e)
            return 0
        print('== Liberation Sans %s model (unhinted advances rounded, win ascent/descent) against screens/' % ver)
        T.PACK = path
        drv = T.Driver()
        drv.cmd('ctx 0 0')
        rows = []
        for spec in T.page_specs(S):
            for cap in [c for c in spec['caps'] if c.startswith('screens/')]:
                img, _ = T.render_page(drv, spec, 0)
                d = T.layout_diff(spec, img, os.path.join(T.REF, cap))
                rows.append((spec['name'], cap.split('/')[1]) + d[:6])
                T.check(d[0] == d[1] and d[2] == 0 and d[4] <= 2 and d[5] <= 2,
                        '%s vs %s: %d/%d lines (same line breaks), max |d top| %d, |d left| %d, |d right| %d'
                        % (spec['name'], cap, d[0], d[1], d[2], d[4], d[5]))
        drv.close()
    print('%-24s %-42s %5s %5s %5s %6s %5s %5s' % ('page', 'capture', 'lines', 'cap', 'top', 'bottom', 'left', 'right'))
    for r in rows:
        print('%-24s %-42s %5d %5d %5d %6d %5d %5d' % r)
    print('result: %s' % ('PASS' if not T.FAIL else 'FAIL (%d)' % len(T.FAIL)))
    return 1 if T.FAIL else 0


if __name__ == '__main__':
    sys.exit(main())
