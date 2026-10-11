#!/usr/bin/env bash
# Serve port/build/web on http://127.0.0.1:PORT/ (default 8000), local machine only.
# Usage: port/serve.sh [PORT]     (build first: port/build.sh wasm pack host)
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON="${PYTHON:-$(command -v python3 || command -v python)}"
exec "$PYTHON" -I -B "$DIR/host/serve.py" --directory "$DIR/build/web" --port "${1:-8000}"
