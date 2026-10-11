"""Scenario files for the acceptance drivers (M7): port/tests/native/accept_drv.c (native),
port/tests/accept/wasm_drv.mjs (moeboid.wasm in node), port/tests/browser/timing.mjs and soak.mjs (page).
Format: see accept_drv.c. Times are ms after click-to-start (input kind 8 at 0).

Scenarios:
  timing(clock)        title, typed INVINCIBLE, Start click, then 60 s of play without input; checkpoints
                       at 10 s and every 6 s up to 70 s (all on the common 30/60/144 Hz frame grid).
  soak(seed, minutes)  random but valid input (key holds, typing, clicks on the frame and dialogs, wheel,
                       focus loss) with a fixed seed; one checkpoint per minute.
Input validity rules: a key or button goes down only when it is up and always goes up again; no input
while the page has no focus; key-down is followed by the WM_CHAR the host would send (host/input.ts).
"""
import random

IN_KEYDOWN, IN_KEYUP, IN_MOVE, IN_BDOWN, IN_BUP, IN_BLUR, IN_FOCUS, IN_START, IN_CHAR, IN_WHEEL = range(1, 11)
VK_BACK, VK_TAB, VK_RETURN, VK_ESCAPE, VK_SPACE = 0x08, 0x09, 0x0D, 0x1B, 0x20
VK_LEFT, VK_UP, VK_RIGHT, VK_DOWN = 0x25, 0x26, 0x27, 0x28

# Frame points (frame pixels) of the shell and game controls, with the weight of a random click
# (port/tests/native/test_shell.c, tests/browser/engine_play.mjs).
TARGETS = {
    "start": ((557, 252), 3),        # title "Start" button (game)
    "new_game": ((233, 175), 1),     # rail New Game
    "pause": ((233, 242), 1),        # rail Pause / Resume
    "how_to_play": ((233, 310), 1),  # rail How To Play
    "footer": ((740, 450), 2),       # page footer arrow (back to the game)
    "help": ((718, 22), 1),          # frame help button
    "tos": ((120, 531), 1),          # Terms of Service link (dialog)
    "view_all": ((95, 164), 1),      # menu View All Games (stops the game)
    "personalize": ((95, 199), 1),   # menu Personalize
    "about": ((95, 234), 1),         # menu About
    "tile0": ((333, 111), 3),        # View All Games: the Moeboid tile (New Game)
    "toggle": ((676, 308), 1),       # Personalize: sound toggle
    "quit_yes": ((350, 314), 2),     # "Game in progress" dialog: Yes
    "dlg_center": ((400, 300), 1),   # dialogs are centred in the frame (O9)
    "dlg_left": ((360, 330), 1),
    "dlg_right": ((440, 330), 1),
}


def char_of(vk, shift=False):
    """WM_CHAR code the host sends after a key-down (host/input.ts charFromEvent), or None."""
    if 0x41 <= vk <= 0x5A:
        return vk if shift else vk + 0x20
    if 0x30 <= vk <= 0x39 or vk in (VK_SPACE, VK_BACK, VK_TAB, VK_RETURN, VK_ESCAPE):
        return vk
    return None


class Writer:
    def __init__(self):
        self.ev = []  # (t, seq, line)
        self.seq = 0

    def add(self, t, line):
        self.ev.append((t, self.seq, line))
        self.seq += 1

    def inp(self, t, kind, a=0, b=0):
        self.add(t, f"in {t} {kind} {a} {b}")

    def check(self, t, label):
        self.add(t, f"check {t} {label}")

    def press(self, t, vk, hold=30, shift=False):
        self.inp(t, IN_KEYDOWN, vk, 0)
        c = char_of(vk, shift)
        if c is not None:
            self.inp(t, IN_CHAR, c, 0)
        self.inp(t + hold, IN_KEYUP, vk, 0)

    def click(self, t, x, y, button=0):
        self.inp(t, IN_MOVE, x, y)
        self.inp(t + 30, IN_BDOWN | (button << 8), x, y)
        self.inp(t + 90, IN_BUP | (button << 8), x, y)

    def text(self, header):
        lines = [f"# moeboid-scenario v1"] + header
        lines += [l for _, _, l in sorted(self.ev, key=lambda e: (e[0], e[1]))]
        return "\n".join(lines) + "\n"


def type_word(w, t, word, gap=40, hold=20):
    for ch in word.upper():
        w.press(t, ord(ch), hold=hold)
        t += gap
    return t


def timing(clock, seed=4242, frame=16):
    w = Writer()
    w.inp(0, IN_START)
    t = type_word(w, 3000, "INVINCIBLE")
    w.click(t + 200, *TARGETS["start"][0])
    w.check(10000, "c00")
    for i in range(1, 11):
        w.check(10000 + 6000 * i, f"c{i:02d}")
    return w.text([f"seed {seed}", f"clock {clock}", "smoothing 1", "quirks 0xffffffff", f"frame {frame}"])


def soak(seed=20261011, minutes=30, clock=0, frame=16):
    rng = random.Random(seed)
    w = Writer()
    w.inp(0, IN_START)
    end = minutes * 60000
    busy = {}           # key or button -> time it is up again
    focus_back = 0      # no input before this time (focus lost)
    t = 2500
    letters = [0x41 + i for i in range(26)]

    def free(k, at):
        return busy.get(k, 0) < at

    def any_held(at):
        return any(v >= at for v in busy.values())

    while t < end - 3000:
        r = rng.random()
        if t < focus_back:
            t = focus_back + rng.randint(5, 50)
            continue
        if r < 0.30:  # arrow hold (game movement)
            vk = rng.choice((VK_LEFT, VK_UP, VK_RIGHT, VK_DOWN))
            hold = rng.randint(50, 1500)
            if free(vk, t):
                w.press(t, vk, hold)
                busy[vk] = t + hold
        elif r < 0.38:  # game keys: Space (start), Y / N (play again)
            vk = rng.choice((VK_SPACE, 0x59, 0x4E))
            if free(vk, t):
                hold = rng.randint(30, 150)
                w.press(t, vk, hold)
                busy[vk] = t + hold
        elif r < 0.45:
            if free(VK_RETURN, t):
                w.press(t, VK_RETURN, 60)
                busy[VK_RETURN] = t + 60
        elif r < 0.47:  # Escape: pause toggle of a running game, dialog cancel
            if free(VK_ESCAPE, t):
                w.press(t, VK_ESCAPE, 60)
                busy[VK_ESCAPE] = t + 60
        elif r < 0.55:  # typing burst of random letters (high-score name); the cheat words "credits" and
            # "invincible" are not typed on purpose (credits: see credits_after_game, original bug)
            codes = [rng.choice(letters) for _ in range(rng.randint(1, 15))]
            shift = rng.random() < 0.3
            for vk in codes:
                if free(vk, t):
                    w.press(t, vk, 25, shift)
                    busy[vk] = t + 25
                t += rng.randint(40, 120)
        elif r < 0.57:
            vk = rng.choice((VK_BACK, VK_TAB))
            if free(vk, t):
                w.press(t, vk, 40)
                busy[vk] = t + 40
        elif r < 0.69:  # click on a known control
            names = list(TARGETS)
            name = rng.choices(names, weights=[TARGETS[n][1] for n in names])[0]
            x, y = TARGETS[name][0]
            if free("b0", t):
                w.click(t, x + rng.randint(-3, 3), y + rng.randint(-3, 3))
                busy["b0"] = t + 90
        elif r < 0.79:  # click anywhere in the frame
            if free("b0", t):
                w.click(t, rng.randint(0, 799), rng.randint(0, 571))
                busy["b0"] = t + 90
        elif r < 0.87:  # mouse moves
            for _ in range(rng.randint(1, 5)):
                w.inp(t, IN_MOVE, rng.randint(-20, 819), rng.randint(-20, 591))
                t += rng.randint(10, 60)
        elif r < 0.89:  # right click
            if free("b2", t):
                w.click(t, rng.randint(0, 799), rng.randint(0, 571), button=2)
                busy["b2"] = t + 90
        elif r < 0.91:  # wheel (only open dialogs read it)
            w.inp(t, IN_WHEEL, rng.choice((120, -120, 240, -360)), 0)
        elif r < 0.92:  # focus loss and return (only when nothing is held: the browser sends no key-up then)
            if not any_held(t):
                back = t + rng.randint(100, 3000)
                w.inp(t, IN_BLUR)
                w.inp(back, IN_FOCUS)
                focus_back = back + 1
        elif r < 0.94:  # drag
            if free("b0", t):
                x, y = rng.randint(0, 799), rng.randint(0, 571)
                w.inp(t, IN_MOVE, x, y)
                w.inp(t + 20, IN_BDOWN, x, y)
                tt = t + 40
                for _ in range(rng.randint(2, 8)):
                    x, y = rng.randint(0, 799), rng.randint(0, 571)
                    w.inp(tt, IN_MOVE, x, y)
                    tt += rng.randint(15, 80)
                w.inp(tt, IN_BUP, x, y)
                busy["b0"] = tt
        t += rng.randint(50, 600)
    for m in range(1, minutes + 1):
        w.check(m * 60000, f"m{m:02d}")
    return w.text([f"seed {seed}", f"clock {clock}", "smoothing 1", "quirks 0xffffffff", f"frame {frame}"])


def parse(text):
    """Scenario text to (settings dict, list of commands) for the drivers in JS (JSON)."""
    settings = {"seed": 1, "clock": 0, "smoothing": 1, "quirks": 0xFFFFFFFF, "frame": 16}
    cmds = []
    for line in text.splitlines():
        f = line.split()
        if not f or f[0].startswith("#"):
            continue
        if f[0] in settings:
            settings[f[0]] = int(f[1], 0)
        elif f[0] == "in":
            cmds.append(["in", int(f[1]), int(f[2]), int(f[3]), int(f[4])])
        elif f[0] == "check":
            cmds.append(["check", int(f[1]), f[2] if len(f) > 2 else "-"])
    return settings, cmds


def credits_fresh(seed=4242, frame=16):
    """CREDITS screen (typed "credits" on the title) from a fresh DLL image: 60 s, no game before."""
    w = Writer()
    w.inp(0, IN_START)
    type_word(w, 3000, "credits")
    for i in range(0, 7):
        w.check(4000 + 10000 * i, f"c{i:02d}")
    return w.text([f"seed {seed}", "clock 0", "smoothing 1", "quirks 0xffffffff", f"frame {frame}"])


# credits_after_game: the soak recording (default seed) up to its first game over and "N" (back to the
# title in the same DLL lifetime), then "credits". Precondition (verify.py checks it at AFTER_TITLE_MS):
# title screen and a non-zero DAT_1000f5e4 (play screen pointer of the ended game).
AFTER_CUT_MS = 1223500       # after the "N" key of the first game over of soak(20261011, 30)
AFTER_TITLE_MS = 1224000
AFTER_CREDITS_MS = 1225000


def credits_after_game():
    base = soak()
    head = [l for l in base.splitlines() if not l.startswith(("in ", "check "))]
    ev = [l for l in base.splitlines() if l.startswith("in ") and int(l.split()[1]) <= AFTER_CUT_MS]
    w = Writer()
    w.check(AFTER_TITLE_MS, "title")
    type_word(w, AFTER_CREDITS_MS, "credits")
    for t in range(AFTER_CREDITS_MS + 1000, AFTER_CREDITS_MS + 31000, 5000):
        w.check(t, f"t{t // 1000}")
    tail = [l for l in w.text([]).splitlines() if l.startswith(("in ", "check "))]
    lines = sorted(ev + tail, key=lambda l: int(l.split()[1]))  # stable: inputs before checks at equal times
    return "\n".join(head + lines) + "\n"
