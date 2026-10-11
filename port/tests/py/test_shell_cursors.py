#!/usr/bin/env python3
"""Cursors of the web host (M5b): port/tools/mkcursors.py output against the asset workstream's decode.

Checks: the cursor block of port/host/main.ts equals the generated one (mkcursors --check); each PNG
(port/build/cursors/<NAME>.png) has the same opaque/transparent pixels and colours as
assets/ZapSpot.exe/decoded/CURSOR/<NAME>_0409_32x32x1.png; hotspots equal analysis/rendering.md 8.
Run: python -I -B port/tests/py/test_shell_cursors.py (needs port/build/web/pack.bin)
"""
import os
import subprocess
import sys

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
HOTSPOTS = {'POINTER': (13, 7), 'HAND': (12, 6), 'NOLINK': (16, 15), 'OPENHAND': (15, 17),
            'CLOSEDHAND': (15, 17), 'HOURGLASS': (16, 15)}  # rendering.md 8


def main():
    if not os.path.exists(os.path.join(ROOT, 'port/build/web/pack.bin')):
        print('test_shell_cursors: skipped (pack.bin missing)')
        return 0
    r = subprocess.run([sys.executable, '-I', '-B', os.path.join(ROOT, 'port/tools/mkcursors.py'), '--check'],
                       capture_output=True, text=True)
    print(r.stdout, end='')
    fails = 0 if r.returncode == 0 else 1
    for line in r.stdout.splitlines():
        for name, (hx, hy) in HOTSPOTS.items():
            if line.startswith('mkcursors: %s:' % name) and 'hotspot (%d, %d)' % (hx, hy) not in line:
                print('FAIL hotspot %s: %s' % (name, line))
                fails += 1
    for name in HOTSPOTS:
        a = Image.open(os.path.join(ROOT, 'port/build/cursors/%s.png' % name)).convert('RGBA').tobytes()
        b = Image.open(os.path.join(ROOT, 'assets/ZapSpot.exe/decoded/CURSOR/%s_0409_32x32x1.png' % name)).convert(
            'RGBA').tobytes()
        bad = sum(1 for i in range(0, len(a), 4)
                  if (a[i + 3] == 0) != (b[i + 3] == 0) or (a[i + 3] and a[i:i + 3] != b[i:i + 3]))
        print('%-10s pixels different from the asset decode: %d' % (name, bad))
        fails += bad != 0
    print('test_shell_cursors: %s' % ('pass' if not fails else 'FAIL'))
    return 1 if fails else 0


if __name__ == '__main__':
    sys.exit(main())
