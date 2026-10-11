#!/usr/bin/env bash
# Build what is missing and serve the Moeboid page on http://127.0.0.1:PORT/ (default 8000), local
# machine only. Open the printed URL in Chromium or Firefox. Ctrl+C stops the server.
# Usage: port/run.sh [PORT]        (PORT 0: the kernel chooses a free port; the URL line shows it)
# Inputs (phase 1 outputs, read-only): extracted/Moeboid.gam, extracted/ZapSpot.exe, fonts/.
# When a page file in port/build/web/ is missing, the script runs `port/build.sh all` first.
set -euo pipefail
PORT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$PORT_DIR")"
WEB="$PORT_DIR/build/web"
LISTEN="${1:-8000}"
PYTHON="${PYTHON:-$(command -v python3 || command -v python)}"

for f in extracted/Moeboid.gam extracted/ZapSpot.exe fonts; do
    if [ ! -e "$ROOT/$f" ]; then
        echo "run.sh: missing input $ROOT/$f (phase 1 output)" >&2
        exit 2
    fi
done

missing=""
for f in index.html style.css main.js input.js storage.js audio.js settings.js moeboid.wasm pack.bin Moeboid.gam; do
    [ -f "$WEB/$f" ] || missing="$missing $f"
done
if [ -n "$missing" ]; then
    echo "run.sh: missing in port/build/web:$missing; running port/build.sh all" >&2
    "$PORT_DIR/build.sh" all
fi

echo "run.sh: open the URL below in Chromium or Firefox; Ctrl+C stops the server."
exec "$PYTHON" -I -B "$PORT_DIR/host/serve.py" --directory "$WEB" --port "$LISTEN"
