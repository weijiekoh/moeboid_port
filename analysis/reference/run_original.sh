#!/bin/bash
# Run the original Moeboid (ZapSpot engine) under Wine with no network.
#
# Usage:
#   run_original.sh setup                 make the launcher layout inside the Wine prefix
#   run_original.sh start [SECONDS]       setup, then start the engine in the background
#                                         (killed after SECONDS, default 90). Log: $LOG.
#   run_original.sh stop                  kill all Wine processes of the prefix
#   run_original.sh wid                   print the X window id of the ZapSpot frame
#   run_original.sh shot FILE.png         save the 800x572 ZapSpot frame as PNG
#   run_original.sh click X Y             click at X,Y relative to the ZapSpot frame
#   run_original.sh key KEYSYM [MS]       press and release a key (X keysym name, e.g. space, Left)
#   run_original.sh type TEXT             type text
#
# Environment:
#   RUN_WINEDEBUG   Wine debug channels for 'start' (default: err+all,fixme-all)
#   RELAY_INCLUDE   if set, written to HKCU\Software\Wine\Debug RelayInclude before start
#   LOG             log file for 'start' (default: $SCRATCH/run.log)
#
# Layout (reproduces what moeboid.exe does on a machine with no ZapSpot install):
#   %TEMP%\~zs0001.tmp\{ZapSpot.exe,Moeboid.gam,ZapLock}, cwd = that folder, command line
#   ZapSpot.exe "<temp folder>" "<launcher path>" "Moeboid.gam"
# The command line is run from a .bat file so that the quotes reach the engine unchanged.
# The game runs inside a 1024x768 Wine virtual desktop (registry HKCU\Software\Wine\Explorer),
# so the user's X display is not mode-switched and all input goes to one X window.
# All input is synthetic (XSendEvent) to that window; the real pointer and keyboard are not used.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tools/env.sh"
# Block URL launches: ShellExecute of http/mailto URLs runs winebrowser, which would call the
# host xdg-open (outside the network namespace). Disabled here, so a URL launch fails in Wine.
export WINEDLLOVERRIDES="$WINEDLLOVERRIDES;winebrowser.exe=d"
SCRATCH="${SCRATCH:-$ROOT/tools/home/tmp}"
LOG="${LOG:-$SCRATCH/run.log}"
DRIVE_C="$WINEPREFIX/drive_c"
TMPDIR_WIN='C:\users\'"$USER"'\AppData\Local\Temp\~zs0001.tmp'
TMPDIR_UNIX="$DRIVE_C/users/$USER/AppData/Local/Temp/~zs0001.tmp"
XH="$HERE/xhelper.py"
# Do not write __pycache__ next to the scripts.
export PYTHONDONTWRITEBYTECODE=1

setup() {
    mkdir -p "$DRIVE_C/Moeboid" "$TMPDIR_UNIX"
    cp -u "$ROOT/moeboid.exe" "$DRIVE_C/Moeboid/moeboid.exe"
    cp -u "$ROOT/extracted/Moeboid.gam" "$ROOT/extracted/ZapSpot.exe" "$TMPDIR_UNIX/"
    [ -e "$TMPDIR_UNIX/ZapLock" ] || : > "$TMPDIR_UNIX/ZapLock"
    printf '@echo off\r\ncd /d %s\r\nZapSpot.exe "%s" "C:\\Moeboid\\moeboid.exe" "Moeboid.gam"\r\n' \
        "$TMPDIR_WIN" "$TMPDIR_WIN" > "$DRIVE_C/Moeboid/run.bat"
    nonet wine reg add 'HKCU\Software\Wine\Explorer' /v Desktop /d Moeboid /f >/dev/null 2>&1
    nonet wine reg add 'HKCU\Software\Wine\Explorer\Desktops' /v Moeboid /d 1024x768 /f >/dev/null 2>&1
    if [ -n "${RELAY_INCLUDE:-}" ]; then
        nonet wine reg add 'HKCU\Software\Wine\Debug' /v RelayInclude /d "$RELAY_INCLUDE" /f >/dev/null 2>&1
    else
        nonet wine reg delete 'HKCU\Software\Wine\Debug' /v RelayInclude /f >/dev/null 2>&1
    fi
    nonet wineserver -w
}

wid() {
    # X window of the ZapSpot frame (a child of the virtual desktop window, 800x572).
    python -I -B "$XH" find 'ZapSpot - ' | awk 'NR==1{print $1}'
}

case "${1:-}" in
setup) setup ;;
start)
    secs="${2:-90}"
    setup
    mkdir -p "$(dirname "$LOG")"
    cd "$DRIVE_C/Moeboid" || exit 1
    export WINEDEBUG="${RUN_WINEDEBUG:-err+all,fixme-all}"
    nohup nonet timeout -s KILL "$secs" wine cmd /c 'C:\Moeboid\run.bat' > "$LOG" 2>&1 &
    echo "started, log: $LOG, WINEDEBUG=$WINEDEBUG, auto-kill after ${secs}s (run 'stop' to end earlier)"
    ( sleep "$secs"; nonet wineserver -k ) >/dev/null 2>&1 &
    ;;
stop) nonet wineserver -k; nonet wineserver -w ;;
wid) wid ;;
shot)
    w="$(wid)"; [ -n "$w" ] || { echo "no ZapSpot window" >&2; exit 1; }
    import -window "$w" "$2"
    ;;
click)
    w="$(wid)"; python -I -B "$XH" click "$w" "$2" "$3"
    ;;
key)
    w="$(wid)"; python -I -B "$XH" key "$w" "$2" "${3:-60}"
    ;;
type)
    w="$(wid)"; python -I -B "$XH" type "$w" "$2"
    ;;
*) sed -n '2,25p' "$0"; exit 2 ;;
esac
