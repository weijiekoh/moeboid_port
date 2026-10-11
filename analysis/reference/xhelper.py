#!/usr/bin/env python3
"""Small X11 helper for the Moeboid reference captures (python-xlib only).

Commands:
  find NAME                 print "id x y w h" for each top-level X window whose name contains NAME
  tree ID                   print the child windows of ID with geometry
  click ID X Y [BUTTON]     synthetic press+release (XSendEvent) at X,Y relative to window ID
  move ID X Y               synthetic MotionNotify at X,Y relative to window ID
  key ID KEYSYM [MS]        synthetic KeyPress+KeyRelease to window ID (hold MS milliseconds)
  type ID TEXT              synthetic key events for each character in TEXT
  xclick ID X Y [BUTTON]    XTest click (moves the real pointer) at X,Y relative to window ID
  xkey KEYSYM [MS]          XTest key press+release (goes to the focused window)
  xkeydown KEYSYM / xkeyup KEYSYM
  activate ID               ask the window manager to activate window ID (_NET_ACTIVE_WINDOW)
Run with `python -I -B` (no __pycache__).
"""
import sys
import time

from Xlib import X, XK, display, protocol
from Xlib.ext import xtest

d = display.Display()
root = d.screen().root


def name_of(w):
    try:
        n = w.get_full_property(d.intern_atom('_NET_WM_NAME'), d.intern_atom('UTF8_STRING'))
        if n:
            return n.value.decode('utf-8', 'replace')
        n = w.get_wm_name()
        return n if isinstance(n, str) else (n.decode('latin1') if n else '')
    except Exception:
        return ''


def abs_geom(w):
    g = w.get_geometry()
    t = w.translate_coords(root, 0, 0)
    return -t.x, -t.y, g.width, g.height


def walk(w, depth=0, maxdepth=3):
    yield w, depth
    if depth >= maxdepth:
        return
    try:
        for c in w.query_tree().children:
            yield from walk(c, depth + 1, maxdepth)
    except Exception:
        return


def win(id_):
    return d.create_resource_object('window', int(id_, 0))


def keycode(ks):
    sym = XK.string_to_keysym(ks)
    if sym == 0 and len(ks) == 1:
        sym = ord(ks)
    return d.keysym_to_keycode(sym)


def send_button(w, x, y, button, press):
    ax, ay, _, _ = abs_geom(w)
    cls = protocol.event.ButtonPress if press else protocol.event.ButtonRelease
    ev = cls(time=X.CurrentTime, root=root, window=w, same_screen=1, child=X.NONE,
             root_x=ax + x, root_y=ay + y, event_x=x, event_y=y,
             state=0 if press else (X.Button1Mask << (button - 1)), detail=button)
    w.send_event(ev, event_mask=X.ButtonPressMask if press else X.ButtonReleaseMask, propagate=False)


def send_motion(w, x, y):
    ax, ay, _, _ = abs_geom(w)
    ev = protocol.event.MotionNotify(time=X.CurrentTime, root=root, window=w, same_screen=1,
                                     child=X.NONE, root_x=ax + x, root_y=ay + y, event_x=x,
                                     event_y=y, state=0, detail=0)
    w.send_event(ev, event_mask=X.PointerMotionMask, propagate=False)


def send_key(w, kc, press, state=0):
    cls = protocol.event.KeyPress if press else protocol.event.KeyRelease
    ev = cls(time=X.CurrentTime, root=root, window=w, same_screen=1, child=X.NONE,
             root_x=0, root_y=0, event_x=0, event_y=0, state=state, detail=kc)
    w.send_event(ev, event_mask=X.KeyPressMask if press else X.KeyReleaseMask, propagate=False)


def main(a):
    cmd = a[0]
    if cmd == 'find':
        for w, dep in walk(root, 0, 4):
            n = name_of(w)
            if a[1].lower() in n.lower():
                try:
                    x, y, ww, hh = abs_geom(w)
                except Exception:
                    continue
                print(hex(w.id), x, y, ww, hh, repr(n))
    elif cmd == 'tree':
        for w, dep in walk(win(a[1]), 0, 4):
            try:
                x, y, ww, hh = abs_geom(w)
                attrs = w.get_attributes()
            except Exception:
                continue
            print('  ' * dep + hex(w.id), x, y, ww, hh, 'mapped' if attrs.map_state else 'unmapped', repr(name_of(w)))
    elif cmd == 'click':
        w = win(a[1]); x, y = int(a[2]), int(a[3]); b = int(a[4]) if len(a) > 4 else 1
        send_motion(w, x, y); d.sync(); time.sleep(0.05)
        send_button(w, x, y, b, True); d.sync(); time.sleep(0.08)
        send_button(w, x, y, b, False); d.sync()
    elif cmd == 'move':
        send_motion(win(a[1]), int(a[2]), int(a[3])); d.sync()
    elif cmd == 'key':
        w = win(a[1]); kc = keycode(a[2]); ms = int(a[3]) if len(a) > 3 else 60
        send_key(w, kc, True); d.sync(); time.sleep(ms / 1000)
        send_key(w, kc, False); d.sync()
    elif cmd == 'type':
        w = win(a[1])
        for ch in a[2]:
            ks = {' ': 'space', '.': 'period', '-': 'minus', '@': 'at'}.get(ch, ch)
            sym = XK.string_to_keysym(ks)
            kc = d.keysym_to_keycode(sym)
            st = X.ShiftMask if ch.isupper() or ch == '@' else 0
            send_key(w, kc, True, st); d.sync(); time.sleep(0.05)
            send_key(w, kc, False, st); d.sync(); time.sleep(0.05)
    elif cmd == 'xclick':
        w = win(a[1]); ax, ay, _, _ = abs_geom(w)
        x, y = ax + int(a[2]), ay + int(a[3]); b = int(a[4]) if len(a) > 4 else 1
        xtest.fake_input(d, X.MotionNotify, x=x, y=y); d.sync(); time.sleep(0.08)
        xtest.fake_input(d, X.ButtonPress, b); d.sync(); time.sleep(0.08)
        xtest.fake_input(d, X.ButtonRelease, b); d.sync()
    elif cmd == 'xkey':
        kc = keycode(a[1]); ms = int(a[2]) if len(a) > 2 else 60
        xtest.fake_input(d, X.KeyPress, kc); d.sync(); time.sleep(ms / 1000)
        xtest.fake_input(d, X.KeyRelease, kc); d.sync()
    elif cmd == 'xkeydown':
        xtest.fake_input(d, X.KeyPress, keycode(a[1])); d.sync()
    elif cmd == 'xkeyup':
        xtest.fake_input(d, X.KeyRelease, keycode(a[1])); d.sync()
    elif cmd == 'activate':
        w = win(a[1])
        ev = protocol.event.ClientMessage(window=w, client_type=d.intern_atom('_NET_ACTIVE_WINDOW'),
                                          data=(32, [2, X.CurrentTime, 0, 0, 0]))
        root.send_event(ev, event_mask=X.SubstructureRedirectMask | X.SubstructureNotifyMask)
        d.sync()
    else:
        print(__doc__)
        return 2
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
