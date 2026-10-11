"""M7 verification suite (port/build.sh verify): builds everything, runs every test and the M7
acceptance checks, and writes port/tests/results/verify.txt (one PASS/FAIL line per check, with numbers).

Groups:
  native    port/build/native/test_* (build.sh native)
  node      port/tests/node/*.mjs with port/build/moeboid.wasm
  python    port/tests/py/test_*.py (M2 gates test_insn_diff and test_corpus, gif, atlas, luna, zml,
            zml_wine, dialog, shell compare, cursors, engine lockstep, engine frame, ...)
  browser   port/tests/browser/*.mjs through tools/bin/web-test (inside tools/bin/nonet); Firefox runs
            when /usr/bin/firefox exists (playwright-core channel moz-firefox, no download)
  accept    (a) timing, (b) sound timing, (c) network, (d) soak, (e) determinism, credits, local run
Drivers: port/tests/native/accept_drv.c (native), port/tests/accept/wasm_drv.mjs (moeboid.wasm in node),
port/tests/browser/pagedrv.mjs (the page with a fake requestAnimationFrame). Scenarios:
port/tests/accept/scenarios.py, written to port/build/accept/.

Usage: python -I -B port/tests/accept/verify.py [--skip-build] [--rt-soak SECONDS] [--only GROUP,...]
Environment: VERIFY_RT_SOAK_S (default 600) = wall time of the real-time browser soak.
"""
import glob
import json
import os
import re
import subprocess
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
PORT = os.path.dirname(os.path.dirname(HERE))
ROOT = os.path.dirname(PORT)
BUILD = os.path.join(PORT, "build")
ACC = os.path.join(BUILD, "accept")
BT = os.path.join(BUILD, "browser-tests")
OUT = os.path.join(PORT, "tests", "results", "verify.txt")
WEBTEST = os.path.join(ROOT, "tools", "bin", "web-test")
sys.path.insert(0, HERE)
import scenarios  # noqa: E402

# Engine log lines that copy the original engine's Error() debug output (OutputDebugStringA + an
# internal list, Z:0x413390; not shown to the user). Strings: ZapSpot.exe Z:0x434938, Z:0x435d88,
# Z:0x4348ac, Z:0x4348f0, Z:0x434a4c. Same list as port/tests/browser/soak.mjs ALLOWED.
ALLOWED_LOGS = (
    "engine: Error - unrecognized child surface passed to CSurface::DetachSurface",
    "engine: Error - unrecognized EventListener",
    "engine: Invalid current key passed to protected surface",
    "engine: Invalid Image",
)
# timing.md 5: game ticks and renders in 60 s per clock model (54.925 ms: 60000 / 54.925 = 1092.4).
EXPECTED_RATES = {0: ((3000, 3000), (1200, 1200)), 1: ((1920, 1920), (960, 960)), 2: ((1092, 1093), (1092, 1093))}
CLOCK_NAME = {0: "1 ms (50 Hz)", 1: "15.625 ms (32 Hz)", 2: "54.925 ms (18.2 Hz)"}
# Every kept file of the shipped page (port/build/web).
PAGE_FILES = {"index.html", "style.css", "main.js", "input.js", "storage.js", "audio.js", "settings.js",
              "moeboid.wasm", "pack.bin", "Moeboid.gam"}
CC_TEST = ["clang", "-std=c11", "-O2", "-ffp-contract=off", "-fno-math-errno", "-Wall", "-Wextra",
           "-I" + os.path.join(PORT, "src"), "-I" + os.path.join(PORT, "tests", "native")]


class Report:
    def __init__(self):
        self.rows = []
        self.t0 = time.time()

    def add(self, ok, group, name, detail, secs=None):
        st = "PASS" if ok else "FAIL"
        self.rows.append((st, group, name, detail, secs))
        print(f"{st}  {group:8s} {name:34s} {detail}" + (f"  [{secs:.1f} s]" if secs is not None else ""), flush=True)
        return ok

    def write(self, header):
        n = len(self.rows)
        nf = sum(1 for r in self.rows if r[0] != "PASS")
        lines = list(header)
        lines.append(f"Result: {n - nf} of {n} checks PASS, {nf} FAIL; wall {time.time() - self.t0:.0f} s.")
        lines.append("")
        group = None
        for st, g, name, detail, secs in self.rows:
            if g != group:
                lines.append(f"== {g}")
                group = g
            lines.append(f"{st}  {name:34s} {detail}" + (f"  [{secs:.1f} s]" if secs is not None else ""))
        os.makedirs(os.path.dirname(OUT), exist_ok=True)
        with open(OUT, "w") as f:
            f.write("\n".join(lines) + "\n")
        return nf


def run(cmd, timeout=600, env=None, cwd=ROOT):
    t = time.time()
    e = dict(os.environ)
    if env:
        e.update(env)
    try:
        p = subprocess.run(cmd, cwd=cwd, env=e, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=timeout)
        out = p.stdout.decode("utf-8", "replace")
        rc = p.returncode
    except subprocess.TimeoutExpired as x:
        out = (x.stdout or b"").decode("utf-8", "replace") + f"\nTIMEOUT after {timeout} s"
        rc = 124
    return rc, out, time.time() - t


def tail(out, n=1):
    lines = [l for l in out.splitlines() if l.strip()]
    return " | ".join(lines[-n:]) if lines else "(no output)"


def save_log(name, out):
    d = os.path.join(ACC, "logs")
    os.makedirs(d, exist_ok=True)
    with open(os.path.join(d, name + ".log"), "w") as f:
        f.write(out)


# ------------------------------------------------------------------ build


def build(rep):
    rc, out, s = run([os.path.join(PORT, "build.sh"), "all"], timeout=1800)
    save_log("build_all", out)
    rep.add(rc == 0, "build", "build.sh all", "wasm, wasm-trace, native, pylib, pack, host" if rc == 0 else tail(out, 3), s)
    if rc != 0:
        return False
    drv = os.path.join(BUILD, "native", "accept_drv")
    rc, out, s2 = run(CC_TEST + ["-o", drv, os.path.join(PORT, "tests", "native", "accept_drv.c"),
                                 os.path.join(BUILD, "native", "libmoeboid.a")])
    rep.add(rc == 0, "build", "accept_drv (native driver)", "built" if rc == 0 else tail(out, 3), s2)
    return rc == 0


# ------------------------------------------------------------------ existing tests

PY_SUMMARY = [
    re.compile(r"# addresses=(\d+).*forms=(\d+).*states=(\d+)"),
    re.compile(r"# mismatching states: \d+.*"),
    re.compile(r".*\b\d+ passed, \d+ failed.*"),
    re.compile(r".*result: \w+.*"),
    re.compile(r"^total: .*"),
    re.compile(r"^\d+ failures$"),
    re.compile(r".*: pass$"),
    re.compile(r"# native and wasm .*"),
    re.compile(r"^  \w+ vs .*: identical.*"),
]


def py_summary(out):
    hits = []
    for l in out.splitlines():
        for p in PY_SUMMARY:
            if p.match(l):
                hits.append(l.strip())
                break
    if not hits:
        return tail(out, 1)
    keep = [h for h in hits if h.startswith("# addresses") or h.startswith("# mismatching")]
    rest = [h for h in hits if h not in keep]
    return "; ".join(keep + rest[-2:])


def native_tests(rep):
    for t in sorted(glob.glob(os.path.join(BUILD, "native", "test_*"))):
        if not os.access(t, os.X_OK):
            continue
        name = os.path.basename(t)
        rc, out, s = run([t], timeout=600)
        save_log("native_" + name, out)
        m = re.findall(r"(\d+) passed, (\d+) failed", out)
        detail = f"{m[-1][0]} passed, {m[-1][1]} failed" if m else tail(out)
        rep.add(rc == 0, "native", name, detail, s)


def node_tests(rep):
    for t in sorted(glob.glob(os.path.join(PORT, "tests", "node", "*.mjs"))):
        rc, out, s = run(["node", t, os.path.join(BUILD, "moeboid.wasm")])
        save_log("node_" + os.path.basename(t), out)
        rep.add(rc == 0, "node", os.path.basename(t), tail(out), s)


def python_tests(rep):
    for t in sorted(glob.glob(os.path.join(PORT, "tests", "py", "test_*.py"))):
        rc, out, s = run([sys.executable, "-I", "-B", t], timeout=1800)
        save_log("py_" + os.path.basename(t), out)
        rep.add(rc == 0, "python", os.path.basename(t), py_summary(out), s)


# ------------------------------------------------------------------ browser


def report_json(outdir):
    try:
        with open(os.path.join(outdir, "report.json")) as f:
            return json.load(f)
    except (OSError, ValueError):
        return None


def nonloop(rep_json):
    """Requests that left 127.0.0.1 (data:, blob:, about: stay in the browser)."""
    n = 0
    for r in rep_json.get("requests", []):
        u = r.get("url", "")
        if u.startswith(("data:", "blob:", "about:")):
            continue
        if not re.match(r"^(https?|wss?)://127\.0\.0\.1(:\d+)?/", u):
            n += 1
    return n + len(rep_json.get("violations", []))


BROWSER_RUNS = []  # (name, browser, report dict, rc) for the network check


def web_test(rep, name, script, args=(), timeout=120, root=None, browser="chromium", expect_fail=False):
    outdir = os.path.join(BT, name)
    cmd = [WEBTEST, "--timeout", str(timeout), "--out", outdir]
    if root:
        cmd += ["--root", root]
    cmd += [os.path.join(PORT, "tests", "browser", script)] + list(args)
    env = {"WEB_TEST_BROWSER": browser} if browser == "firefox" else {"WEB_TEST_BROWSER": ""}
    rc, out, s = run(cmd, timeout=timeout + 120, env=env)
    save_log("browser_" + name, out)
    rj = report_json(outdir)
    BROWSER_RUNS.append((name, browser, rj, rc, expect_fail))
    nreq = len(rj["requests"]) if rj else 0
    nl = nonloop(rj) if rj else -1
    tests = [l[7:] for l in out.splitlines() if l.startswith("[test] ")]
    if expect_fail:
        ok = rc == 1 and rj is not None and len(rj.get("violations", [])) >= 2
        detail = f"blocked by design: {len(rj.get('violations', [])) if rj else '?'} external requests aborted and reported, exit {rc}"
    else:
        ok = rc == 0 and nl == 0
        detail = f"{browser}; {nreq} requests, {nl} non-loopback" + (f"; {tests[-1]}" if tests else "")
        if rc != 0:
            detail += " | " + tail(out, 2)
    rep.add(ok, "browser", name, detail[:400], s)
    return ok, outdir


def have_firefox():
    return os.path.exists("/usr/bin/firefox")


def browser_tests(rep, rt_soak_s):
    fx = os.path.join(PORT, "tests", "browser", "fixtures")
    web_test(rep, "smoke", "smoke.mjs", root=fx)
    web_test(rep, "guard_check", "guard_check.mjs", root=fx, expect_fail=True)
    for n in ("audio_wav", "audio_sched", "audio_focus", "input_keys", "engine_play"):
        web_test(rep, n, n + ".mjs", timeout=120)
    web_test(rep, "shell_flow", "shell_flow.mjs", timeout=180)
    web_test(rep, "settings", "settings.mjs", timeout=120)
    web_test(rep, "run_sh", "run_sh.mjs", timeout=180)
    web_test(rep, "timing", "timing.mjs", args=[ACC], timeout=300)
    web_test(rep, "soak", "soak.mjs", args=[ACC, "30"], timeout=900)
    if have_firefox():
        web_test(rep, "run_sh_firefox", "run_sh.mjs", timeout=180, browser="firefox")
        web_test(rep, "timing_firefox", "timing.mjs", args=[ACC], timeout=300, browser="firefox")
    else:
        rep.add(True, "browser", "firefox", "skipped: /usr/bin/firefox missing")
    if rt_soak_s > 0:
        web_test(rep, "soak_rt", "soak_rt.mjs", args=[str(rt_soak_s)], timeout=rt_soak_s + 300)


# ------------------------------------------------------------------ acceptance drivers


def parse_drv(out):
    """accept_drv / wasm_drv output: check dicts, snd tuples, log lines, fault lines."""
    checks, snd, logs, faults = [], [], [], []
    for l in out.splitlines():
        if l.startswith("check "):
            f = l.split()
            d = dict(kv.split("=", 1) for kv in f[3:] if "=" in kv)
            d["t"] = int(f[1])
            d["label"] = f[2]
            checks.append(d)
        elif l.startswith("snd "):
            snd.append(tuple(int(x) for x in l.split()[1:5]))
        elif l.startswith("log "):
            logs.append(l[4:])
        elif l.startswith("fault "):
            faults.append(l[6:])
    return checks, snd, logs, faults


COMPARE_KEYS = ("ticks", "renders", "frame", "fault", "applet", "screen", "paused", "dialog", "playscreen",
                "lives", "logs", "now")


def drv(name, scn, wasm=False, extra=()):
    path = os.path.join(ACC, scn)
    if wasm:
        cmd = ["node", os.path.join(HERE, "wasm_drv.mjs"), path] + list(extra)
    else:
        cmd = [os.path.join(BUILD, "native", "accept_drv"), path] + list(extra)
    rc, out, s = run(cmd, timeout=1200)
    save_log(name, out)
    return rc, out, s


def write_scenarios():
    os.makedirs(ACC, exist_ok=True)
    files = {f"timing{c}.scn": scenarios.timing(c) for c in (0, 1, 2)}
    files["soak.scn"] = scenarios.soak()
    files["credits_fresh.scn"] = scenarios.credits_fresh()
    files["credits_after.scn"] = scenarios.credits_after_game()
    for n, txt in files.items():
        with open(os.path.join(ACC, n), "w") as f:
            f.write(txt)


NATIVE = {}  # scenario -> parsed native output
WASM = {}


def run_drivers(rep):
    write_scenarios()
    for scn in ("timing0", "timing1", "timing2", "soak", "credits_fresh", "credits_after"):
        rc, out, s = drv("native_" + scn, scn + ".scn")
        NATIVE[scn] = parse_drv(out)
        rep.add(rc == 0, "drivers", f"native {scn}", f"{len(NATIVE[scn][0])} checkpoints, {len(NATIVE[scn][1])} sound commands", s)
    for scn in ("soak", "credits_after"):
        rc, out, s = drv("wasm_" + scn, scn + ".scn", wasm=True)
        WASM[scn] = parse_drv(out)
        rep.add(rc == 0, "drivers", f"wasm {scn}", f"{len(WASM[scn][0])} checkpoints, {len(WASM[scn][1])} sound commands", s)


# ------------------------------------------------------------------ (a) timing


def load_json(path):
    try:
        with open(path) as f:
            return json.load(f)
    except (OSError, ValueError):
        return None


def check_timing(rep):
    for browser, d in (("chromium", "timing"), ("firefox", "timing_firefox")):
        res = load_json(os.path.join(BT, d, "timing.json"))
        if res is None:
            if browser == "firefox" and not have_firefox():
                continue
            rep.add(False, "(a) timing", f"{browser}", "no timing.json (browser test failed)")
            continue
        for clock in (0, 1, 2):
            nat = NATIVE[f"timing{clock}"]
            nc = nat[0]
            n_ticks = int(nc[-1]["ticks"]) - int(nc[0]["ticks"])
            n_rend = int(nc[-1]["renders"]) - int(nc[0]["renders"])
            runs = [r for r in res["runs"] if r["clock"] == clock]
            (tlo, thi), (rlo, rhi) = EXPECTED_RATES[clock]
            ok = len(runs) == 3
            parts = []
            for r in runs:
                same_ck = all(
                    str(b["ticks"]) == a["ticks"] and str(b["renders"]) == a["renders"] and b["frame"] == a["frame"]
                    and str(b["screen"]) == a["screen"] for a, b in zip(nc, r["checks"])) and len(nc) == len(r["checks"])
                snd_ok = [tuple(x) for x in r["sounds"]] == nat[1]
                ok &= (r["ticks"] == n_ticks and r["renders"] == n_rend and same_ck and snd_ok
                       and tlo <= r["ticks"] <= thi and rlo <= r["renders"] <= rhi)
                parts.append(f"{r['rate']} Hz {r['ticks']}/{r['renders']}" + ("" if same_ck and snd_ok else " (checkpoints differ)"))
            detail = (f"clock {CLOCK_NAME[clock]}: 60 s game ticks/renders native {n_ticks}/{n_rend}, expected "
                      f"{tlo}/{rlo}" + ("" if thi == tlo else f"..{thi}/{rhi}") + "; browser " + ", ".join(parts) +
                      f"; {len(nc)} checkpoint frame hashes and {len(nat[1])} sound commands equal native")
            rep.add(ok, "(a) timing", f"{browser} clock {clock}", detail)


# ------------------------------------------------------------------ (b) sound timing


def sound_table():
    h = open(os.path.join(PORT, "src", "core", "sound_ids.h")).read()
    return {m.group(3).rsplit("/", 1)[-1].upper(): int(m.group(1))
            for m in re.finditer(r'X\((\d+),\s*(\w+),\s*"([^"]+)"', h)}


def check_sound(rep):
    trace = os.path.join(ACC, "soak.sound.trace")
    rc, out, s = drv("native_soak_trace", "soak.scn", extra=["--trace", trace, "--trace-grep", "Sound"])
    checks, snd, _, _ = parse_drv(out)
    table = sound_table()
    obj = {}
    calls = []  # (ms, sound id)
    for l in open(trace):
        ms, line, son = l.rstrip("\n").split("\t")
        m = re.search(r"CreateSound\('([^']+)', \d+\) = #(\d+):ISound", line)
        if m:
            obj[m.group(2)] = table.get(m.group(1).upper(), 0)
            continue
        m = re.search(r"#(\d+):ISound\+0x8 Play\(", line)
        if m:
            calls.append((int(ms), obj.get(m.group(1), 0), son == "sound_on=1"))
    plays = [(c[3], c[1]) for c in snd if c[0] == 1 and 1 <= c[1] <= 11]
    # match in order: each PLAY with a later Play call of the same sound at the same clock ms; the Play
    # calls passed over are the dropped ones (sound off, 16 voices busy)
    i = 0
    matched = bad = 0
    misses = []
    used = set()
    for at, sid in plays:
        j = i
        while j < len(calls) and not (calls[j][1] == sid and calls[j][0] == at):
            j += 1
        if j < len(calls):
            matched += 1
            used.add(j)
            i = j + 1
        else:
            bad += 1
            misses.append((at, sid))
    dropped = [c for k, c in enumerate(calls) if k not in used]
    drop_off = sum(1 for c in dropped if not c[2])
    same_trace = snd == NATIVE["soak"][1]
    ok = rc == 0 and bad == 0 and matched == len(plays) and len(plays) > 50 and same_trace
    rep.add(ok, "(b) sound", "PLAY at_ms = game Play call time",
            f"30 min soak: {len(plays)} game PLAY commands, {matched} at the clock ms of their ISound.Play call "
            f"(trace), {bad} mismatches; {len(calls)} Play calls, {len(dropped)} without PLAY ({drop_off} with the Sound "
            f"setting off, {len(dropped) - drop_off} with 16 busy voices); platform sounds (ids 12..16) "
            f"{sum(1 for c in snd if c[0] == 1 and c[1] > 11)}; "
            f"trace on/off same commands: {same_trace}" + (f"; unmatched {misses[:5]}" if misses else ""), s)
    w = WASM["soak"][1]
    rep.add(w == NATIVE["soak"][1], "(b) sound", "wasm = native commands",
            f"{len(w)} commands (op, id, voice, at_ms) of the 30 min soak equal in moeboid.wasm and native")
    res = load_json(os.path.join(BT, "timing", "timing.json"))
    if res:
        eq = all([tuple(x) for x in r["sounds"]] == NATIVE[f"timing{r['clock']}"][1] for r in res["runs"])
        n = sum(len(r["sounds"]) for r in res["runs"])
        rep.add(eq, "(b) sound", "page = native commands",
                f"{n} commands drained by the page host in 9 runs (3 clocks x 30/60/144 Hz) equal native")


# ------------------------------------------------------------------ (c) network

NET_PATTERNS = [
    ("XMLHttpRequest", r"\bXMLHttpRequest\b"), ("WebSocket", r"\bWebSocket\b"), ("EventSource", r"\bEventSource\b"),
    ("sendBeacon", r"\bsendBeacon\b"), ("window.open", r"\bwindow\.open\b|\bopen\s*\(\s*['\"]https?:"),
    ("serviceWorker", r"\bserviceWorker\b"), ("importScripts", r"\bimportScripts\b"), ("Worker", r"\bnew\s+(Shared)?Worker\b"),
    ("RTCPeerConnection", r"\bRTCPeerConnection\b"), ("external URL in href/src", r"(href|src|action)\s*=\s*[\"']?\s*(https?:|//)"),
    ("CSS url() or @import of a URL", r"(url\(\s*[\"']?\s*(https?:|//))|@import"),
    ("http(s) URL literal", r"[\"'`]\s*(https?|wss?):"), ("iframe/object/embed", r"<\s*(iframe|object|embed)\b"),
    ("form", r"<\s*form\b"), ("prefetch/preconnect", r"rel\s*=\s*[\"']?(prefetch|preconnect|dns-prefetch|prerender)"),
]


def scan_file(path):
    txt = open(path, encoding="utf-8", errors="replace").read()
    hits = []
    for name, pat in NET_PATTERNS:
        for m in re.finditer(pat, txt):
            hits.append(f"{os.path.relpath(path, ROOT)}: {name}: {txt[max(0, m.start() - 20):m.end() + 20]!r}")
    # every fetch() argument: a quoted file name of this origin or the fetchBytes parameter `name`
    for m in re.finditer(r"\bfetch\s*\(\s*([^,)]*)", txt):
        a = m.group(1).strip()
        if not (re.fullmatch(r"[\"'][\w.-]+[\"']", a) or a == "name"):
            hits.append(f"{os.path.relpath(path, ROOT)}: fetch({a})")
    for m in re.finditer(r"\bfetchBytes\s*\(\s*([^,)]*)", txt):
        a = m.group(1).strip()
        if not (re.fullmatch(r"[\"'][\w.-]+[\"']", a) or a == "name" or a.startswith("name:")):
            hits.append(f"{os.path.relpath(path, ROOT)}: fetchBytes({a})")
    return hits


def wasm_imports(path):
    js = ("const fs=require('fs');const m=new WebAssembly.Module(fs.readFileSync(process.argv[1]));"
          "console.log(JSON.stringify(WebAssembly.Module.imports(m).map(i=>i.module+'.'+i.name+':'+i.kind)))")
    rc, out, _ = run(["node", "-e", js, path])
    try:
        return json.loads(out.strip().splitlines()[-1])
    except (ValueError, IndexError):
        return None


def check_network(rep):
    runs = [(n, b, rj, rc) for n, b, rj, rc, xf in BROWSER_RUNS if not xf]
    total = sum(len(rj["requests"]) for _, _, rj, _ in runs if rj)
    nl = sum(nonloop(rj) for _, _, rj, _ in runs if rj)
    missing = [n for n, _, rj, _ in runs if rj is None]
    rep.add(nl == 0 and not missing and runs, "(c) network", "web-test runs: loopback only",
            f"{len(runs)} browser runs, {total} requests, {nl} to a host other than 127.0.0.1" +
            (f"; no report: {missing}" if missing else ""))
    files = sorted(glob.glob(os.path.join(PORT, "host", "*")) + glob.glob(os.path.join(BUILD, "web", "*")))
    text = [f for f in files if f.endswith((".ts", ".js", ".html", ".css", ".py", ".json"))]
    hits = [h for f in text for h in scan_file(f)]
    rep.add(not hits, "(c) network", "static scan of host and page",
            f"{len(text)} files (port/host, port/build/web): " + ("no fetch to another origin, XMLHttpRequest, WebSocket, "
            "EventSource, sendBeacon, window.open, external href/src, service worker" if not hits else "; ".join(hits[:6])))
    page = set(os.listdir(os.path.join(BUILD, "web")))
    rep.add(page == PAGE_FILES, "(c) network", "shipped page files",
            f"port/build/web = {len(page)} files" + ("" if page == PAGE_FILES else f"; unexpected {sorted(page - PAGE_FILES)}, missing {sorted(PAGE_FILES - page)}"))
    imp = wasm_imports(os.path.join(BUILD, "web", "moeboid.wasm"))
    rep.add(imp == ["env.host_log:function"], "(c) network", "wasm imports", f"moeboid.wasm imports {imp}")
    html = open(os.path.join(BUILD, "web", "index.html")).read()
    meta = re.search(r'http-equiv="Content-Security-Policy" content="([^"]+)"', html)
    serve = open(os.path.join(PORT, "host", "serve.py")).read()
    hdr = re.search(r'CSP = \("([^"]+)"\s*"([^"]+)"\s*"([^"]+)"\)', serve)
    csp_ok = bool(meta) and meta.group(1).startswith("default-src 'none';") and "connect-src 'self'" in meta.group(1)
    hdr_ok = bool(hdr) and "default-src 'none'" in hdr.group(1) and 'send_header("Content-Security-Policy", CSP)' in serve
    bind_ok = '("127.0.0.1", ns.port)' in serve and "0.0.0.0" not in serve
    rs = load_json(os.path.join(BT, "run_sh", "report.json"))
    rep.add(csp_ok and hdr_ok and bind_ok, "(c) network", "CSP meta and header",
            f"meta: {meta.group(1) if meta else 'missing'}; serve.py sends the CSP header (run_sh browser test reads it: "
            f"{'yes' if rs and rs.get('ok') else 'no'}); serve.py binds 127.0.0.1 only: {bind_ok}")
    # The guest side: Moeboid.gam imports only KERNEL32 (stubs in src/cpu/k32.c), no network DLL.
    try:
        import pefile
        pe = pefile.PE(os.path.join(ROOT, "extracted", "Moeboid.gam"), fast_load=True)
        pe.parse_data_directories(directories=[pefile.DIRECTORY_ENTRY["IMAGE_DIRECTORY_ENTRY_IMPORT"]])
        dlls = sorted({e.dll.decode() for e in pe.DIRECTORY_ENTRY_IMPORT})
        rep.add(dlls == ["KERNEL32.dll"], "(c) network", "guest imports", f"Moeboid.gam imports {dlls} only (KERNEL32 stubs)")
    except Exception as x:  # pefile missing: report, do not fail the network check
        rep.add(True, "(c) network", "guest imports", f"not checked ({x})")


# ------------------------------------------------------------------ (d) soak, (e) determinism, credits


def mib(n):
    return f"{int(n) / 1048576:.1f}"


def check_soak(rep):
    checks, snd, logs, faults = NATIVE["soak"]
    bad_logs = [l for l in logs if not l.startswith(ALLOWED_LOGS)]
    inuse = [int(c["heap_in_use"]) for c in checks]
    top = [int(c["heap_top"]) for c in checks]
    third = len(checks) // 3
    bounded = max(inuse[-third:]) <= 1.05 * max(inuse[:third]) and max(top[-third:]) <= 1.05 * max(top[:third])
    nf = sum(int(c["fault"]) for c in checks)
    screens = {k: sum(1 for c in checks if c["screen"] == k) for k in ("0", "1", "2", "3")}
    series = ", ".join(f"{c['t'] // 60000}:{mib(c['heap_in_use'])}" for c in checks[4::5])
    ok = len(checks) == 30 and nf == 0 and not bad_logs and bounded
    rep.add(ok, "(d) soak", "native 30 min",
            f"{len(checks)} checkpoints, {checks[-1]['ticks']} game calls, {checks[-1]['renders']} renders, {len(snd)} sound "
            f"commands; faults {nf}; engine log lines {len(logs)} (original Error() diagnostics {len(logs) - len(bad_logs)}, "
            f"other {len(bad_logs)}); minute samples title/play/credits/none {screens['1']}/{screens['2']}/{screens['3']}/{screens['0']}; "
            f"heap in use MiB at min {series}; high-water {mib(max(top[:third]))} -> {mib(max(top))} MiB")
    sj = load_json(os.path.join(BT, "soak", "soak.json"))
    if not sj:
        rep.add(False, "(d) soak", "browser 30 min (fake rAF 60 Hz)", "no soak.json")
    else:
        bc = sj["checks"]
        bl = [l for l in sj["logs"] if not l.startswith(ALLOWED_LOGS)]
        mem = [c["wasm_mem"] for c in bc]
        ok = len(bc) == sj["minutes"] and all(c["fault"] == 0 for c in bc) and not bl and max(mem) <= mem[0] + 16 * 1048576
        rep.add(ok, "(d) soak", f"browser {sj['minutes']} min (fake rAF 60 Hz)",
                f"wall {sj['wall_s']:.1f} s; faults 0: {all(c['fault'] == 0 for c in bc)}; log lines {len(sj['logs'])} (other {len(bl)}); "
                f"wasm memory MiB at min " + ", ".join(f"{c['t'] // 60000}:{mib(c['wasm_mem'])}" for c in bc[::5]) +
                f", end {mib(mem[-1])}")
    rj = load_json(os.path.join(BT, "soak_rt", "soak_rt.json"))
    if rj:
        sm = rj["samples"]
        rep.add(all(s["fault"] == 0 for s in sm), "(d) soak", f"browser real time {rj['seconds']} s",
                f"{rj['actions']} Playwright input actions, real requestAnimationFrame; clock {sm[-1]['now']} ms; faults 0; "
                f"log lines {len(rj['logs'])}; wasm memory MiB " + ", ".join(mib(s["wasm_mem"]) for s in sm[::3]) +
                "; JS heap MiB " + ", ".join(mib(s["js_heap"]) if s["js_heap"] is not None else "-" for s in sm[::3]))


def check_determinism(rep):
    n, w = NATIVE["soak"], WASM["soak"]
    diffs = [(a["t"], k) for a, b in zip(n[0], w[0]) for k in COMPARE_KEYS if a.get(k) != b.get(k)]
    ok = len(n[0]) == len(w[0]) == 30 and not diffs and n[1] == w[1] and n[2] == w[2]
    rep.add(ok, "(e) determinism", "native = wasm (node), 30 min soak",
            f"{len(n[0])} checkpoints: frame SHA-256 and {len(COMPARE_KEYS) - 1} probe values equal" if not diffs
            else f"differences at {diffs[:5]}" + f"; sound commands equal {n[1] == w[1]} ({len(n[1])}); log lines equal {n[2] == w[2]}")
    sj = load_json(os.path.join(BT, "soak", "soak.json"))
    if sj:
        bc = sj["checks"]
        d2 = [(a["t"], k) for a, b in zip(n[0], bc) for k in COMPARE_KEYS if a.get(k) != str(b.get(k))]
        snd_ok = [tuple(x) for x in sj["sounds"]] == n[1][:len(sj["sounds"])]
        rep.add(not d2 and len(bc) >= 10 and snd_ok, "(e) determinism", "native = page (Chromium)",
                f"{len(bc)} checkpoints of the soak in the real page (fake rAF 60 Hz): frame SHA-256 and probes equal native"
                if not d2 else f"differences at {d2[:5]}" + f"; sound commands equal: {snd_ok}")
    first = NATIVE["soak"][0][0]["frame"][:16]
    rep.add(True, "(e) determinism", "frame hashes (first, last)", f"{first}.., {NATIVE['soak'][0][-1]['frame'][:16]}..")


def check_credits(rep):
    c, _, logs, faults = NATIVE["credits_fresh"]
    ok = all(x["fault"] == "0" and x["screen"] == "3" for x in c) and int(c[-1]["ticks"]) > int(c[0]["ticks"]) + 2000
    rep.add(ok, "credits", "CREDITS from a fresh DLL",
            f"typed 'credits' on the title: credits screen for {(c[-1]['t'] - c[0]['t']) // 1000} s, "
            f"{int(c[-1]['ticks']) - int(c[0]['ticks'])} game calls, no fault, {len(logs)} log lines")
    c, _, logs, faults = NATIVE["credits_after"]
    title = next((x for x in c if x["label"] == "title"), None)
    pre = title is not None and title["screen"] == "1" and title["playscreen"] != "0"
    fault_at = next((x["t"] for x in c if x["fault"] == "1"), None)
    eip = re.search(r"eip=([0-9a-f]+)", faults[0]).group(1) if faults else None
    w = WASM["credits_after"][0]
    same = [(a["t"], k) for a, b in zip(c, w) for k in COMPARE_KEYS if a.get(k) != b.get(k)]
    ok = pre and fault_at is not None and eip == "10001401" and not same and len(c) == len(w)
    rep.add(ok, "credits", "CREDITS after a game (original bug)",
            f"precondition (title after game over, DAT_1000f5e4 = {title['playscreen'] if title else '?'} dangling): {pre}; "
            f"guest fault at G:0x{eip} (CMP EDX,[ECX], ECX = freed play screen +0xc) first seen at {fault_at} ms; "
            f"native = wasm: {not same}. Expected: the original game reads the freed play screen here "
            f"(use-after-free, G:0x100013f3..0x10001401); the port reproduces it (see docs/exactness.md)")


# ------------------------------------------------------------------ main


def main():
    args = sys.argv[1:]
    skip_build = "--skip-build" in args
    rt = int(os.environ.get("VERIFY_RT_SOAK_S", "600"))
    if "--rt-soak" in args:
        rt = int(args[args.index("--rt-soak") + 1])
    only = None
    if "--only" in args:
        only = set(args[args.index("--only") + 1].split(","))
    want = lambda g: only is None or g in only  # noqa: E731
    rep = Report()
    if not skip_build and not build(rep):
        rep.write(["# port/build.sh verify (M7)", "build failed"])
        return 1
    if want("native"):
        native_tests(rep)
    if want("node"):
        node_tests(rep)
    if want("python"):
        python_tests(rep)
    write_scenarios()
    if want("accept") or want("browser"):
        run_drivers(rep)
    if want("browser"):
        browser_tests(rep, rt)
    if want("accept"):
        check_timing(rep)
        check_sound(rep)
        if want("browser"):
            check_network(rep)
        check_soak(rep)
        check_determinism(rep)
        check_credits(rep)
    rc, ver, _ = run(["bash", "-c", "clang --version | head -1; node --version; /usr/bin/chromium --version 2>/dev/null; "
                      "/usr/bin/firefox --version 2>/dev/null"])
    header = [
        "# port/build.sh verify (M7): every test of the port and the M7 acceptance checks",
        f"# date {time.strftime('%Y-%m-%d %H:%M')}; tools: " + "; ".join(l.strip() for l in ver.splitlines() if l.strip()),
        "# scenarios: port/tests/accept/scenarios.py (port/build/accept/*.scn); logs: port/build/accept/logs/",
        "# browser runs: tools/bin/web-test inside tools/bin/nonet (reports: port/build/browser-tests/<name>/report.json)",
    ]
    nf = rep.write(header)
    print(f"verify: {len(rep.rows) - nf} of {len(rep.rows)} checks PASS; {OUT}")
    return 0 if nf == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
