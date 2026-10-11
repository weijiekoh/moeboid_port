#!/usr/bin/env python3
"""Drive one capture session against a running ZapSpot (start it first with run_original.sh start).
Usage: python -I -B capture_session.py OUTDIR STEPFILE
STEPFILE lines:  wait SEC | click X Y | key KEYSYM [MS] | hold KEYSYM MS | shot NAME | desk NAME
                 splash NAME | type TEXT | log TEXT | deskloop COUNT INTERVAL NAME
                 waitframe SEC | dclick X Y | wshot NAME WINPREFIX | wclick X Y WINPREFIX
                 wkey KEYSYM WINPREFIX | wtype TEXT WINPREFIX | idleplay SEC PREFIX | tree
Coordinates are relative to the ZapSpot frame window. 'desk' saves the 1024x768 virtual desktop.
"""
import os
import subprocess
import sys
import time

sys.dont_write_bytecode = True
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import xhelper as xh  # noqa: E402

out = sys.argv[1]
steps = [l.strip() for l in open(sys.argv[2]) if l.strip() and not l.startswith('#')]
os.makedirs(out, exist_ok=True)
t0 = time.time()


def find(pred):
    for w, dep in xh.walk(xh.root, 0, 5):
        n = xh.name_of(w)
        try:
            if pred(n) and w.get_attributes().map_state == 2:
                return w
        except Exception:
            pass
    return None


def frame():
    return find(lambda n: n.startswith('ZapSpot - '))


def desk():
    return find(lambda n: n == 'Moeboid - Wine Desktop')


def log(*a):
    print('%7.2f' % (time.time() - t0), *a, flush=True)


for s in steps:
    p = s.split(None, 1)
    cmd, arg = p[0], (p[1] if len(p) > 1 else '')
    if cmd == 'wait':
        time.sleep(float(arg))
    elif cmd == 'waitframe':
        end = time.time() + float(arg)
        while time.time() < end and frame() is None:
            time.sleep(0.2)
        log('frame', hex(frame().id) if frame() else None)
    elif cmd == 'splash':
        end = time.time() + 30
        w = None
        while time.time() < end:
            w = find(lambda n: n == 'ZapSpot')
            if w:
                break
            time.sleep(0.05)
        if w:
            g = w.get_geometry()
            log('splash', hex(w.id), g.width, g.height)
            i = 0
            while find(lambda n: n == 'ZapSpot') is not None and i < 60:
                r = subprocess.run(['import', '-window', hex(w.id),
                                    os.path.join(out, '%s_%02d.png' % (arg, i))], capture_output=True)
                log('splash shot', i, r.returncode)
                i += 1
        else:
            log('splash not found')
    elif cmd == 'deskloop':
        # deskloop COUNT INTERVAL NAME: save the virtual desktop COUNT times (splash screen)
        cnt, iv, nm = arg.split()
        end = time.time() + 30
        while desk() is None and time.time() < end:
            time.sleep(0.05)
        for i in range(int(cnt)):
            w = desk()
            if w is not None:
                subprocess.run(['import', '-window', hex(w.id), '-crop', '1024x768+0+0', '+repage',
                                os.path.join(out, '%s_%02d.png' % (nm, i))])
                log('deskloop', i, 'frame' if frame() else 'noframe')
            time.sleep(float(iv))
    elif cmd == 'shot':
        w = frame()
        subprocess.run(['import', '-window', hex(w.id), os.path.join(out, arg + '.png')])
        log('shot', arg)
    elif cmd == 'desk':
        w = desk()
        subprocess.run(['import', '-window', hex(w.id), '-crop', '1024x768+0+0', '+repage',
                        os.path.join(out, arg + '.png')])
        log('desk', arg)
    elif cmd == 'click':
        x, y = arg.split()
        xh.main(['click', hex(frame().id), x, y])
        log('click', x, y)
    elif cmd == 'dclick':
        # click relative to the virtual desktop (for dialogs outside the frame)
        x, y = arg.split()
        xh.main(['click', hex(desk().id), x, y])
        log('dclick', x, y)
    elif cmd == 'key':
        a = arg.split()
        xh.main(['key', hex(frame().id)] + a)
        log('key', arg)
    elif cmd == 'type':
        xh.main(['type', hex(frame().id), arg])
        log('type', arg)
    elif cmd == 'wshot':
        # wshot FILE WINDOW-NAME-PREFIX
        f, nm = arg.split(None, 1)
        w = find(lambda n: n.startswith(nm))
        if w:
            subprocess.run(['import', '-window', hex(w.id), os.path.join(out, f + '.png')])
        log('wshot', f, hex(w.id) if w else None)
    elif cmd == 'wclick':
        # wclick X Y WINDOW-NAME-PREFIX
        x, y, nm = arg.split(None, 2)
        w = find(lambda n: n.startswith(nm))
        if w:
            xh.main(['click', hex(w.id), x, y])
        log('wclick', x, y, nm, hex(w.id) if w else None)
    elif cmd == 'idleplay':
        # idleplay SECONDS PREFIX: no movement; on a message box press space; shots on events
        secs, pre = arg.split()
        end = time.time() + float(secs)
        n = 0
        last_idle = 0
        known = None
        from Xlib import X as _X
        while time.time() < end:
            w = frame()
            if w is None:
                log('no frame'); break
            kids = [c for c, dep in xh.walk(desk(), 0, 1) if dep == 1 and xh.name_of(c)
                    and c.get_attributes().map_state == 2]
            names = sorted(xh.name_of(c) for c in kids)
            if known is None:
                known = names
            if names != known:
                log('windows changed', names)
                subprocess.run(['import', '-window', hex(desk().id), '-crop', '1024x768+0+0', '+repage',
                                os.path.join(out, '%s_%02d_desk.png' % (pre, n))]); n += 1
                break
            px = w.get_image(450, 215, 1, 1, _X.ZPixmap, 0xffffffff).data
            b, g, r = px[0], px[1], px[2]
            if (r, g, b) == (153, 204, 255):
                time.sleep(0.6)
                subprocess.run(['import', '-window', hex(w.id), os.path.join(out, '%s_%02d_msg.png' % (pre, n))])
                log('message box', n); n += 1
                xh.main(['key', hex(w.id), 'space', '80'])
                time.sleep(1.5)
                subprocess.run(['import', '-window', hex(w.id), os.path.join(out, '%s_%02d_after.png' % (pre, n))])
                n += 1
                continue
            if time.time() - last_idle > 6:
                subprocess.run(['import', '-window', hex(w.id), os.path.join(out, '%s_%02d_idle.png' % (pre, n))])
                n += 1; last_idle = time.time()
            time.sleep(0.3)
    elif cmd == 'wkey':
        # wkey KEYSYM WINDOW-NAME-PREFIX
        k, nm = arg.split(None, 1)
        w = find(lambda n: n.startswith(nm))
        xh.main(['key', hex(w.id), k, '60'])
        log('wkey', k, hex(w.id))
    elif cmd == 'wtype':
        # wtype TEXT WINDOW-NAME-PREFIX (TEXT without spaces)
        t, nm = arg.split(None, 1)
        w = find(lambda n: n.startswith(nm))
        xh.main(['type', hex(w.id), t])
        log('wtype', t, hex(w.id))
    elif cmd == 'log':
        log(arg)
    elif cmd == 'tree':
        w = desk()
        for c, dep in xh.walk(w, 0, 3):
            try:
                if c.get_attributes().map_state == 2:
                    x, y, ww, hh = xh.abs_geom(c)
                    log('  ' * dep, hex(c.id), x, y, ww, hh, repr(xh.name_of(c)))
            except Exception:
                pass
log('done')
