#!/usr/bin/env python3
"""Steer the player into purple ('Avoid') amoebas to reach game over (for the high-score screens).
Usage: python -I -B bot_avoid.py OUTDIR SECONDS   (engine must be in gameplay; run_original.sh start first)"""
import os
import subprocess
import sys
import time

sys.dont_write_bytecode = True
from PIL import Image
from Xlib import X

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import xhelper as xh  # noqa: E402

out = sys.argv[1]
secs = float(sys.argv[2])
os.makedirs(out, exist_ok=True)
t0 = time.time()
X0, Y0, W, H = 150, 30, 640, 440
CELL = 6
PURPLE = {(102, 0, 153), (153, 102, 255), (204, 102, 255)}
OUTLINE = (204, 51, 153)


def log(*a):
    print('%7.2f' % (time.time() - t0), *a, flush=True)


def frame():
    for w, dep in xh.walk(xh.root, 0, 5):
        if xh.name_of(w).startswith('ZapSpot - '):
            return w


def grab(w):
    raw = w.get_image(X0, Y0, W, H, X.ZPixmap, 0xffffffff).data
    return Image.frombytes('RGB', (W, H), raw, 'raw', 'BGRX')


def cells(img, pred):
    px = img.load()
    hits = {}
    for y in range(0, H, 2):
        for x in range(0, W, 2):
            if pred(px[x, y]):
                k = (x // CELL, y // CELL)
                hits[k] = hits.get(k, 0) + 1
    return hits


def cluster(hits):
    seen, groups = set(), []
    for k in hits:
        if k in seen:
            continue
        stack, g = [k], []
        seen.add(k)
        while stack:
            c = stack.pop()
            g.append(c)
            for dx in (-1, 0, 1):
                for dy in (-1, 0, 1):
                    n = (c[0] + dx, c[1] + dy)
                    if n in hits and n not in seen:
                        seen.add(n)
                        stack.append(n)
        cx = sum(c[0] for c in g) / len(g) * CELL + CELL / 2
        cy = sum(c[1] for c in g) / len(g) * CELL + CELL / 2
        groups.append((cx, cy, len(g)))
    return groups


def press(w, keys, ms):
    kcs = [xh.keycode(k) for k in keys]
    for kc in kcs:
        xh.send_key(w, kc, True)
    xh.d.sync()
    time.sleep(ms / 1000)
    for kc in kcs:
        xh.send_key(w, kc, False)
    xh.d.sync()


player = (378, 230)
n = 0
msg_seen = 0
while time.time() - t0 < secs:
    w = frame()
    if w is None:
        log('no frame')
        break
    dlg = [c for c, dep in xh.walk(xh.root, 0, 5) if xh.name_of(c) == 'Congratulations']
    if dlg:
        log('high score dialog')
        break
    # message box (death / game over) in the dish centre
    p = w.get_image(450, 215, 1, 1, X.ZPixmap, 0xffffffff).data
    if (p[2], p[1], p[0]) == (153, 204, 255):
        time.sleep(0.5)
        subprocess.run(['import', '-window', hex(w.id), os.path.join(out, 'msg_%02d.png' % n)])
        log('message', n)
        n += 1
        msg_seen += 1
        press(w, ['space'], 80)
        time.sleep(1.5)
        subprocess.run(['import', '-window', hex(w.id), os.path.join(out, 'after_%02d.png' % n)])
        n += 1
        if msg_seen >= 3:
            break
        continue
    img = grab(w)
    purple = cluster(cells(img, lambda c: c in PURPLE))
    cand = cluster(cells(img, lambda c: c == OUTLINE))
    if cand:
        # the player is the outline cluster closest to the previous position
        player = min(cand, key=lambda g: (g[0] - player[0]) ** 2 + (g[1] - player[1]) ** 2)[:2]
    if not purple:
        time.sleep(0.15)
        continue
    tx, ty, _ = min(purple, key=lambda g: (g[0] - player[0]) ** 2 + (g[1] - player[1]) ** 2)
    dx, dy = tx - player[0], ty - player[1]
    keys = []
    if abs(dx) > 4:
        keys.append('Right' if dx > 0 else 'Left')
    if abs(dy) > 4:
        keys.append('Down' if dy > 0 else 'Up')
    if keys:
        press(w, keys, 120)
log('end, messages:', msg_seen)
