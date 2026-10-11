# Source this file: `source tools/env.sh`. Keeps all tool state inside the project.
TOOLS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export MOEBOID_TOOLS="$TOOLS"
export XDG_CONFIG_HOME="$TOOLS/home/config"
export XDG_CACHE_HOME="$TOOLS/home/cache"
export XDG_DATA_HOME="$TOOLS/home/data"
export XDG_STATE_HOME="$TOOLS/home/state"
mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$TOOLS/home/tmp"

export GHIDRA_HOME="$TOOLS/ghidra_12.1.4_PUBLIC"
# Ghidra JVM properties are set in $GHIDRA_HOME/support/launch.properties.

export RIZIN_HOME="$TOOLS/rizin-v0.9.1"

# Wine: private prefix, no desktop integration. Run the original game only through
# `nonet` (no network namespace), never directly.
export WINEPREFIX="$TOOLS/home/wineprefix"
export WINEARCH=win64
export WINEDLLOVERRIDES="winemenubuilder.exe=d;mscoree=d;mshtml=d"
export WINEDEBUG="${WINEDEBUG:--all}"

export PATH="$TOOLS/bin:$TOOLS/.venv/bin:$RIZIN_HOME/bin:$TOOLS/wine/bin:$GHIDRA_HOME/support:$PATH"
