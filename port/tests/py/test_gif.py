#!/usr/bin/env python3
"""M3 gate (a): the C GIF decoder (port/src/gfx/gif.c) against
  1. a Python model of the engine rules (analysis/rendering.md 4, timing.md 4; rules of the verified
     workstream D script gifeng.py), pixel by pixel, every frame of the 81 GIFs;
  2. Pillow standard compositing (alpha 0 in Pillow = magenta key in keyed frames, black in opaque frames);
  3. the animation slot table and frame lookup (50 ms slots, NETSCAPE loop, image 0 after the end).
Run: python -I -B port/tests/py/test_gif.py   (exit status 0 = pass)
"""
import io
import os
import struct
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PORT = os.path.dirname(os.path.dirname(HERE))
ROOT = os.path.dirname(PORT)
sys.path.insert(0, os.path.join(PORT, 'tools'))
import mkpack  # noqa: E402

NATIVE = os.path.join(PORT, 'build', 'native')
DUMP = os.path.join(NATIVE, 'gif_dump')
KEY = (255, 0, 255, 0)
BLACK = (0, 0, 0, 255)


def build():
    os.makedirs(NATIVE, exist_ok=True)
    srcs = [os.path.join(PORT, 'tests', 'native', 'gif_dump.c'), os.path.join(PORT, 'src', 'gfx', 'gif.c')]
    cmd = [os.environ.get('CC', 'cc'), '-O2', '-std=c11', '-Wall', '-Wextra', '-Werror', '-ffp-contract=off',
           '-o', DUMP] + srcs
    subprocess.run(cmd, check=True)


def all_gifs():
    out = []
    for prefix, fname in mkpack.BINARIES:
        for typ, nm, lang, fo, data in mkpack.pe_resources(os.path.join(mkpack.EXTRACTED, fname)):
            if typ == 10 and isinstance(nm, str) and nm.upper().endswith('.GIF'):
                out.append(('%s/%s' % (prefix, nm.upper()), data))
    return out


def c_decode(data):
    r = subprocess.run([DUMP, '-'], input=data, capture_output=True, check=True).stdout
    assert r[:4] == b'GIFD'
    W, H, n, loop, status, ns = struct.unpack_from('<IIIIiI', r, 4)
    p = 28
    meta = []
    for i in range(n):
        d, = struct.unpack_from('<I', r, p)
        meta.append(dict(delay=d, keyed=r[p + 4], disp=r[p + 5], tidx=r[p + 6], inter=r[p + 7]))
        p += 12
    frames = []
    for i in range(n):
        raw = r[p:p + 4 * W * H]
        frames.append([tuple(raw[4 * k:4 * k + 4]) for k in range(W * H)])
        p += 4 * W * H
    table = list(r[p:p + max(ns, 0)])
    p += max(ns, 0)
    npr, = struct.unpack_from('<I', r, p)
    p += 4
    probes = []
    for i in range(npr):
        t, = struct.unpack_from('<I', r, p)
        probes.append((t, r[p + 4], r[p + 5], r[p + 6]))
        p += 8
    return dict(W=W, H=H, loop=loop, status=status, ns=ns, meta=meta, frames=frames, table=table, probes=probes)


# ---- Python model of the engine rules (from scratchpad D/gifeng.py, verified in workstream D)

def lzw(data, mcs, npix):
    clear = 1 << mcs
    eoi = clear + 1
    out = []
    size = mcs + 1
    dic = {}
    nxt = eoi + 1
    prev = None
    bits = nb = pos = 0

    def reset():
        nonlocal size, nxt, dic
        size = mcs + 1
        nxt = eoi + 1
        dic = {i: [i] for i in range(clear)}
    reset()
    while pos < len(data) or nb >= size:
        while nb < size and pos < len(data):
            bits |= data[pos] << nb
            nb += 8
            pos += 1
        if nb < size:
            break
        code = bits & ((1 << size) - 1)
        bits >>= size
        nb -= size
        if code == clear:
            reset()
            prev = None
            continue
        if code == eoi:
            break
        if prev is None:
            ent = dic[code]
            out += ent
            prev = ent
            continue
        if code in dic:
            ent = dic[code]
            dic[nxt] = prev + [ent[0]]
        else:
            ent = prev + [prev[0]]
            dic[nxt] = ent
        nxt += 1
        out += ent
        prev = ent
        if nxt == (1 << size) and size < 12:
            size += 1
    return out[:npix]


def parse(b):
    W = b[6] | b[7] << 8
    H = b[8] | b[9] << 8
    pk = b[10]
    p = 13
    gct = None
    if pk & 0x80:
        n = 2 << (pk & 7)
        gct = [tuple(b[p + 3 * i:p + 3 * i + 3]) for i in range(n)]
        p += 3 * n
    gce = {'tr': 0, 'ti': 0, 'disp': 0, 'delay': 0}   # persists across frames (engine)
    frames = []
    loop = False
    while p < len(b):
        c = b[p]
        p += 1
        if c == 0x21:
            lab = b[p]
            p += 1
            if lab == 0xf9:
                sz = b[p]
                pk2 = b[p + 1]
                gce = {'tr': pk2 & 1, 'disp': (pk2 >> 2) & 7, 'delay': b[p + 2] | b[p + 3] << 8, 'ti': b[p + 4]}
                p += 1 + sz
                while b[p]:
                    p += 1 + b[p]
                p += 1
            else:
                if lab == 0xff and b[p + 1:p + 12] == b'NETSCAPE2.0':
                    loop = True
                while b[p]:
                    p += 1 + b[p]
                p += 1
        elif c == 0x2c:
            l, t, w, h = [b[p + 2 * i] | b[p + 2 * i + 1] << 8 for i in range(4)]
            pk2 = b[p + 8]
            p += 9
            lct = None
            if pk2 & 0x80:
                n = 2 << (pk2 & 7)
                lct = [tuple(b[p + 3 * i:p + 3 * i + 3]) for i in range(n)]
                p += 3 * n
            mcs = b[p]
            p += 1
            data = bytearray()
            while b[p]:
                data += b[p + 1:p + 1 + b[p]]
                p += 1 + b[p]
            p += 1
            idx = lzw(bytes(data), mcs, w * h)
            if pk2 & 0x40:
                rows = [idx[i * w:(i + 1) * w] for i in range(h)]
                order = list(range(0, h, 8)) + list(range(4, h, 8)) + list(range(2, h, 4)) + list(range(1, h, 2))
                new = [None] * h
                for k, r in enumerate(order):
                    new[r] = rows[k]
                idx = [x for r in new for x in r]
            frames.append(dict(l=l, t=t, w=w, h=h, idx=idx, ct=lct or gct, **gce))
        elif c == 0x3b:
            break
        else:
            raise ValueError('bad block %x' % c)
    return W, H, frames, loop


def engine(W, H, frames):
    out = []
    prev = None
    prevdisp = 0
    prevkeyed = 0
    for n, f in enumerate(frames):
        bg = KEY if f['tr'] else BLACK
        can = [bg] * (W * H)
        if n > 0 and prevdisp in (1, 3):
            can = [bg if (prevkeyed and px[3] == 0) else px for px in prev]
        prevdisp = f['disp']
        prevkeyed = f['tr']
        for y in range(f['h']):
            for x in range(f['w']):
                i = f['idx'][y * f['w'] + x]
                if f['tr'] and i == f['ti']:
                    continue
                X = f['l'] + x
                Y = f['t'] + y
                if X < W and Y < H:
                    can[Y * W + X] = f['ct'][i] + (255,) if i < len(f['ct']) else BLACK
        out.append(can)
        prev = can
    return out


def pillow_frames(b):
    from PIL import Image
    im = Image.open(io.BytesIO(b))
    out = []
    for i in range(getattr(im, 'n_frames', 1)):
        im.seek(i)
        raw = im.convert('RGBA').tobytes()
        out.append([tuple(raw[k:k + 4]) for k in range(0, len(raw), 4)])
    return out


def anim_expect(meta, loop, t):
    slots = []
    for i, m in enumerate(meta):
        slots += [i] * (m['delay'] // 50)
    s = t // 50
    if s < len(slots):
        return slots[s], 1, 0, slots
    if loop:
        return (slots[s % len(slots)] if slots else 0), 0, 0, slots
    return 0, 1, 1, slots


def main():
    build()
    gifs = all_gifs()
    ngam = sum(1 for n, _ in gifs if n.startswith('gam/'))
    nzap = len(gifs) - ngam
    print('GIFs: %d (Moeboid.gam %d, ZapSpot.exe %d)' % (len(gifs), ngam, nzap))
    fail = 0
    tot_frames = tot_px = 0
    for name, data in gifs:
        c = c_decode(data)
        W, H, fr, loop = parse(data)
        ref = engine(W, H, fr)
        pil = pillow_frames(data)
        notes = []
        if c['status'] != 0:
            notes.append('status %d' % c['status'])
        if (c['W'], c['H'], len(c['frames'])) != (W, H, len(ref)):
            notes.append('size/frame count differ')
        if c['loop'] != int(loop):
            notes.append('loop flag differs')
        d_ref = d_pil = 0
        for n, (cf, rf) in enumerate(zip(c['frames'], ref)):
            d_ref += sum(1 for a, b in zip(cf, rf) if a != b)
            keyed = fr[n]['tr']
            if n < len(pil):
                for a, p in zip(cf, pil[n]):
                    if p[3] == 0:
                        exp = KEY if keyed else BLACK
                    else:
                        exp = p[:3] + (255,)
                    d_pil += a != exp
            for m, f in zip(c['meta'], fr):
                if m['delay'] != f['delay'] * 10 or m['keyed'] != f['tr'] or m['disp'] != f['disp']:
                    notes.append('meta differs')
                    break
        if len(pil) != len(ref):
            notes.append('Pillow frame count %d' % len(pil))
        # animation
        d_anim = 0
        for t, frame, al, fin in c['probes']:
            ef, eal, efin, slots = anim_expect(c['meta'], c['loop'], t)
            d_anim += (frame, al, fin) != (ef, eal, efin)
        if c['table'] != anim_expect(c['meta'], c['loop'], 0)[3]:
            notes.append('slot table differs')
        tot_frames += len(c['frames'])
        tot_px += sum(len(f) for f in c['frames'])
        ok = not notes and d_ref == 0 and d_pil == 0 and d_anim == 0
        fail += not ok
        print('%-4s %-44s %3dx%-3d frames %2d loop %d slots %4d  engine-model diff %d  Pillow diff %d  anim diff %d %s'
              % ('ok' if ok else 'FAIL', name, W, H, len(c['frames']), c['loop'], c['ns'], d_ref, d_pil, d_anim,
                 ' '.join(notes)))
    print('total: %d GIFs, %d frames, %d pixels compared twice, %d failures' % (len(gifs), tot_frames, tot_px, fail))
    if len(gifs) != 81 or ngam != 46 or nzap != 35:
        print('FAIL: expected 81 GIFs (46 + 35)')
        return 1
    return 1 if fail else 0


if __name__ == '__main__':
    sys.exit(main())
