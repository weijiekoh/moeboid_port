#!/bin/bash
# Run the original Moeboid (ZapSpot engine) under Wine with no network, on a hidden X display.
#
# Usage:
#   run_original.sh setup                 make the launcher layout inside the Wine prefix
#   run_original.sh start [SECONDS]       setup, then start the engine in the background on a new
#                                         hidden Xvfb display (killed after SECONDS, default 90).
#                                         Log: $LOG.
#   run_original.sh stop                  kill all Wine processes of the prefix; Xvfb then stops
#   run_original.sh display               print the hidden display of the running session (:N)
#   run_original.sh wid                   print the X window id of the ZapSpot frame
#   run_original.sh shot FILE.png         save the 800x572 ZapSpot frame as PNG
#   run_original.sh desk FILE.png         save the 1024x768 hidden screen (= Wine virtual desktop)
#   run_original.sh click X Y             click at X,Y relative to the ZapSpot frame
#   run_original.sh key KEYSYM [MS]       press and release a key (X keysym name, e.g. space, Left)
#   run_original.sh type TEXT             type text
#   run_original.sh x CMD [ARGS...]       run a helper (capture_session.py, bot_avoid.py, import)
#                                         with DISPLAY set to the hidden display
#
# Environment:
#   RUN_WINEDEBUG   Wine debug channels for 'start' (default: err+all,fixme-all)
#   RELAY_INCLUDE   if set, written to HKCU\Software\Wine\Debug RelayInclude before start
#   FONT_SMOOTHING  off | on: written to HKCU\Control Panel\Desktop before start
#                   (off: FontSmoothing "0"; on: FontSmoothing "2", FontSmoothingType 1 = standard
#                   greyscale). Unset: registry unchanged.
#   WINE_D3D_CONFIG wined3d options (default: renderer=no3d, see below)
#   LOG             log file for 'start' (default: $SCRATCH/run.log)
#
# Display: every Wine command runs through tools/bin/xvfb-run-wine (Xvfb on :90 or higher, inside
# tools/bin/nonet). This script unsets DISPLAY, WAYLAND_DISPLAY and XAUTHORITY at the start; it
# sets DISPLAY only to the hidden display that xvfb-run-wine reports in $STATE. Never :0.
#
# Layout (reproduces what moeboid.exe does on a machine with no ZapSpot install):
#   %TEMP%\~zs0001.tmp\{ZapSpot.exe,Moeboid.gam,ZapLock}, cwd = that folder, command line
#   ZapSpot.exe "<temp folder>" "<launcher path>" "Moeboid.gam"
# The command line is run from a .bat file so that the quotes reach the engine unchanged.
# The game runs inside a 1024x768 Wine virtual desktop (registry HKCU\Software\Wine\Explorer).
# All input is synthetic (XSendEvent) to that window on the hidden display.
# Setup also copies fonts/Arial.TTF, Arialbd.TTF and sserife.fon into C:\windows\Fonts.
set -u
# Internal modes (_setup, _session) run inside xvfb-run-wine and keep its hidden DISPLAY
# (checked in setup()). All other modes start with no display.
case "${1:-}" in
_setup|_session) ;;
*) unset DISPLAY WAYLAND_DISPLAY XAUTHORITY ;;
esac
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
SELF="$HERE/run_original.sh"
# shellcheck source=/dev/null
source "$ROOT/tools/env.sh"
# Block URL launches: ShellExecute of http/mailto URLs runs winebrowser, which would call the
# host xdg-open (outside the network namespace). Disabled here, so a URL launch fails in Wine.
export WINEDLLOVERRIDES="$WINEDLLOVERRIDES;winebrowser.exe=d"
# DirectDraw on Xvfb: the wined3d OpenGL renderer presents only the last rectangle of the
# 4-rectangle frame clip region (upper 800x462 of the frame stays black); the CPU renderer
# "no3d" presents the whole frame. Override with WINE_D3D_CONFIG=renderer=gl.
export WINE_D3D_CONFIG="${WINE_D3D_CONFIG:-renderer=no3d}"
SCRATCH="${SCRATCH:-$ROOT/tools/home/tmp}"
LOG="${LOG:-$SCRATCH/run.log}"
# Hidden display of the running session, written by xvfb-run-wine -f, removed when Xvfb stops.
STATE="$ROOT/tools/home/tmp/original.display"
DRIVE_C="$WINEPREFIX/drive_c"
TMPDIR_WIN='C:\users\'"$USER"'\AppData\Local\Temp\~zs0001.tmp'
TMPDIR_UNIX="$DRIVE_C/users/$USER/AppData/Local/Temp/~zs0001.tmp"
XH="$HERE/xhelper.py"
# Do not write __pycache__ next to the scripts.
export PYTHONDONTWRITEBYTECODE=1

die() { echo "run_original.sh: $*" >&2; exit 1; }

# True inside xvfb-run-wine: private network namespace and a hidden display.
inside_hidden() {
    [ "$(awk 'NR > 2 { sub(":", "", $1); print $1 }' /proc/net/dev | tr '\n' ' ')" = "lo " ] \
        && [[ "${DISPLAY:-}" =~ ^:(9[0-9]|1[0-8][0-9])$ ]]
}

# True if a session (Xvfb of $STATE) is running.
running() {
    [ -s "$STATE" ] || return 1
    local n pid
    n="$(sed 's/^://' "$STATE")"
    pid="$(tr -d ' \n' < "/tmp/.X$n-lock" 2>/dev/null)"
    [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null
}

# Set DISPLAY to the hidden display of the running session.
use_hidden() {
    running || die "no hidden display: run 'start' first"
    DISPLAY="$(cat "$STATE")"
    [[ "$DISPLAY" =~ ^:(9[0-9]|1[0-8][0-9])$ ]] || die "unexpected display '$DISPLAY' in $STATE"
    export DISPLAY
}

# Runs inside xvfb-run-wine (already in nonet): call wine directly.
setup() {
    inside_hidden || die "setup must run inside xvfb-run-wine"
    mkdir -p "$DRIVE_C/Moeboid" "$TMPDIR_UNIX" "$DRIVE_C/windows/Fonts"
    cp -u "$ROOT/moeboid.exe" "$DRIVE_C/Moeboid/moeboid.exe"
    cp -u "$ROOT/extracted/Moeboid.gam" "$ROOT/extracted/ZapSpot.exe" "$TMPDIR_UNIX/"
    [ -e "$TMPDIR_UNIX/ZapLock" ] || : > "$TMPDIR_UNIX/ZapLock"
    for f in Arial.TTF Arialbd.TTF sserife.fon; do
        install -C -m 0644 "$ROOT/fonts/$f" "$DRIVE_C/windows/Fonts/$f"
    done
    printf '@echo off\r\ncd /d %s\r\nZapSpot.exe "%s" "C:\\Moeboid\\moeboid.exe" "Moeboid.gam"\r\n' \
        "$TMPDIR_WIN" "$TMPDIR_WIN" > "$DRIVE_C/Moeboid/run.bat"
    wine reg add 'HKCU\Software\Wine\Explorer' /v Desktop /d Moeboid /f >/dev/null 2>&1
    wine reg add 'HKCU\Software\Wine\Explorer\Desktops' /v Moeboid /d 1024x768 /f >/dev/null 2>&1
    if [ -n "${RELAY_INCLUDE:-}" ]; then
        wine reg add 'HKCU\Software\Wine\Debug' /v RelayInclude /d "$RELAY_INCLUDE" /f >/dev/null 2>&1
    else
        wine reg delete 'HKCU\Software\Wine\Debug' /v RelayInclude /f >/dev/null 2>&1
    fi
    local fs="" ft=1
    case "${FONT_SMOOTHING:-}" in
    off) fs=0 ;;
    on) fs=2 ;;
    "") ;;
    *) die "FONT_SMOOTHING must be off or on" ;;
    esac
    if [ -n "$fs" ]; then
        wine reg add 'HKCU\Control Panel\Desktop' /v FontSmoothing /d "$fs" /f >/dev/null 2>&1
        wine reg add 'HKCU\Control Panel\Desktop' /v FontSmoothingType /t REG_DWORD /d "$ft" /f >/dev/null 2>&1
        # winex11 takes the antialias mode of DEFAULT_QUALITY fonts from the X resources
        # Xft.antialias / Xft.rgba of the display (get_xft_aa_flags) before the registry.
        # Set them on the hidden display (RESOURCE_MANAGER of its root window) to match.
        if [ "$fs" = 0 ]; then
            printf 'Xft.antialias: 0\n' | xrdb -nocpp -merge
        else
            printf 'Xft.antialias: 1\nXft.rgba: none\n' | xrdb -nocpp -merge
        fi
    fi
    echo "setup done: FONT_SMOOTHING=${FONT_SMOOTHING:-unchanged}, DISPLAY=$DISPLAY"
    wineserver -w
}

wid() {
    # X window of the ZapSpot frame (a child of the virtual desktop window, 800x572).
    python -I -B "$XH" find 'ZapSpot - ' | awk 'NR==1{print $1}'
}

case "${1:-}" in
_setup) setup ;;
_session)
    # Internal: one complete session inside xvfb-run-wine.
    secs="$2"
    setup
    cd "$DRIVE_C/Moeboid" || exit 1
    export WINEDEBUG="${RUN_WINEDEBUG:-err+all,fixme-all}"
    echo "engine start: DISPLAY=$DISPLAY, WINEDEBUG=$WINEDEBUG, WINE_D3D_CONFIG=$WINE_D3D_CONFIG," \
         "auto-kill after ${secs}s"
    timeout -s KILL "$secs" wine cmd /c 'C:\Moeboid\run.bat'
    echo "engine end: status $?"
    wineserver -k 2>/dev/null
    wineserver -w
    ;;
setup)
    running && die "a session is running on $(cat "$STATE"); run 'stop' first"
    xvfb-run-wine bash "$SELF" _setup
    ;;
start)
    secs="${2:-90}"
    running && die "a session is running on $(cat "$STATE"); run 'stop' first"
    rm -f "$STATE"
    mkdir -p "$(dirname "$LOG")" "$(dirname "$STATE")"
    nohup xvfb-run-wine -f "$STATE" bash "$SELF" _session "$secs" > "$LOG" 2>&1 &
    for _ in $(seq 150); do [ -s "$STATE" ] && break; sleep 0.1; done
    [ -s "$STATE" ] || die "hidden display did not start; see $LOG"
    echo "started on hidden display $(cat "$STATE"), log: $LOG," \
         "WINEDEBUG=${RUN_WINEDEBUG:-err+all,fixme-all}, FONT_SMOOTHING=${FONT_SMOOTHING:-unchanged}," \
         "auto-kill after ${secs}s (run 'stop' to end earlier)"
    ;;
stop)
    nonet wineserver -k 2>/dev/null
    nonet wineserver -w
    # xvfb-run-wine stops Xvfb and removes $STATE when the session ends.
    for _ in $(seq 150); do [ -e "$STATE" ] || break; sleep 0.1; done
    if running; then
        n="$(sed 's/^://' "$STATE")"
        kill "$(tr -d ' \n' < "/tmp/.X$n-lock")" 2>/dev/null
        echo "stopped Xvfb :$n by force" >&2
    fi
    rm -f "$STATE"
    ;;
display) use_hidden; echo "$DISPLAY" ;;
wid) use_hidden; wid ;;
shot)
    use_hidden
    w="$(wid)"; [ -n "$w" ] || die "no ZapSpot window"
    import -display "$DISPLAY" -window "$w" "$2"
    ;;
desk)
    use_hidden
    import -display "$DISPLAY" -window root -crop 1024x768+0+0 +repage "$2"
    ;;
click)
    use_hidden; w="$(wid)"; python -I -B "$XH" click "$w" "$2" "$3"
    ;;
key)
    use_hidden; w="$(wid)"; python -I -B "$XH" key "$w" "$2" "${3:-60}"
    ;;
type)
    use_hidden; w="$(wid)"; python -I -B "$XH" type "$w" "$2"
    ;;
x)
    use_hidden; shift; exec "$@"
    ;;
*) sed -n '2,39p' "$0"; exit 2 ;;
esac
