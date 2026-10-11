#!/usr/bin/env bash
# Moeboid port build (port-design.md section 2). Usage: port/build.sh TARGET...
#   wasm        port/build/moeboid.wasm (release: imports env.host_log only), copied to build/web/
#   wasm-trace  port/build/moeboid-trace.wasm (PORT_TRACE=1: also imports env.host_trace)
#   native      objects + test executables in port/build/native/
#   pylib       port/build/libmoeboid.so (all modules, no src/main.c)
#   host        TypeScript to JavaScript (node module.stripTypeScriptTypes) + page files in build/web/
#   pack        python -I -B port/tools/mkpack.py (skipped while the script does not exist)
#   test        native, pylib, wasm, wasm-trace, then every test: build/native/test_*,
#               tests/node/*.mjs (argument: build/moeboid.wasm), tests/py/test_*.py (python -I -B)
#   all         wasm wasm-trace native pylib pack host
#   clean       remove port/build/
# Sources: every *.c below port/src/<module>/ for the modules in PORT_MODULES (default:
# rt core cpu gfx text engine shell snd); a new file needs no change here.
# Generated headers: put them in port/build/gen/ (on the include path of every build).
# Environment: PORT_MODULES (module list), CC (native compiler, default clang), JOBS, PYTHON.
set -euo pipefail

PORT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$PORT")"
SRC="$PORT/src"
OUT="$PORT/build"
MODULES="${PORT_MODULES:-rt core cpu gfx text engine shell snd}"
CC="${CC:-clang}"
JOBS="${JOBS:-$(nproc 2>/dev/null || echo 4)}"
PYTHON="${PYTHON:-$(command -v python || command -v python3)}"

# Shared C flags. -ffp-contract=off is mandatory (no FMA contraction). -ffreestanding and
# -nostdlibinc keep libc headers out of the port sources (only compiler headers remain).
CFLAGS_COMMON=(-std=c11 -O2 -ffp-contract=off -fno-math-errno -Wall -Wextra -ffreestanding -nostdlibinc -I"$SRC" -I"$OUT/gen")
CFLAGS_WASM=(--target=wasm32 -nostdlib "${CFLAGS_COMMON[@]}")
CFLAGS_NATIVE=("${CFLAGS_COMMON[@]}" -fPIC)
# Test programs use the host libc; the port sources do not.
CFLAGS_TEST=(-std=c11 -O2 -ffp-contract=off -fno-math-errno -Wall -Wextra -I"$SRC" -I"$PORT/tests/native")

log() { printf '%s\n' "$*" >&2; }

sources() {
    local m
    for m in $MODULES; do
        [ -d "$SRC/$m" ] && find "$SRC/$m" -name '*.c' -type f
    done | LC_ALL=C sort
}

# compile_all OBJDIR COMPILER FLAGS...: compile every source below the module directories into
# OBJDIR (only when the object is missing or older than its source or any header); write the
# object list to OBJDIR/.objects.
compile_all() {
    local objdir="$1"
    shift
    local src obj rel
    local -a hdirs=("$SRC")
    [ -d "$OUT/gen" ] && hdirs+=("$OUT/gen")
    mkdir -p "$objdir"
    : >"$objdir/.objects"
    : >"$objdir/.todo"
    {
        printf 'set -e\necho "  cc $1" >&2\nexec'
        printf ' %q' "$@"
        printf ' -c "$1" -o "$2"\n'
    } >"$objdir/.cc.sh"
    while IFS= read -r src; do
        rel="${src#"$SRC"/}"
        obj="$objdir/${rel%.c}.o"
        printf '%s\n' "$obj" >>"$objdir/.objects"
        if [ -f "$obj" ] && [ ! "$src" -nt "$obj" ] &&
            [ -z "$(find "${hdirs[@]}" -name '*.h' -newer "$obj" -print -quit)" ]; then
            continue
        fi
        mkdir -p "$(dirname "$obj")"
        printf '%s\0%s\0' "$src" "$obj" >>"$objdir/.todo"
    done < <(sources)
    if [ -s "$objdir/.todo" ]; then
        xargs -0 -n 2 -P "$JOBS" bash "$objdir/.cc.sh" <"$objdir/.todo"
    fi
    rm -f "$objdir/.todo"
}

objects() { cat "$1/.objects"; }

build_wasm() { # build_wasm OUTFILE TRACE(0|1)
    local outfile="$1" trace="$2" objdir="$OUT/wasm-obj-$2"
    log "wasm: $outfile"
    compile_all "$objdir" clang "${CFLAGS_WASM[@]}" -DPORT_TRACE="$trace"
    mkdir -p "$objdir/main"
    clang "${CFLAGS_WASM[@]}" -DPORT_TRACE="$trace" -c "$SRC/main.c" -o "$objdir/main/main.o"
    local -a objs
    mapfile -t objs < <(objects "$objdir")
    wasm-ld --no-entry --stack-first -z stack-size=4194304 --strip-debug \
        -o "$outfile" "${objs[@]}" "$objdir/main/main.o"
}

target_wasm() {
    build_wasm "$OUT/moeboid.wasm" 0
    mkdir -p "$OUT/web"
    cp "$OUT/moeboid.wasm" "$OUT/web/moeboid.wasm"
}

target_wasm_trace() { build_wasm "$OUT/moeboid-trace.wasm" 1; }

native_objects() {
    compile_all "$OUT/native/obj" "$CC" "${CFLAGS_NATIVE[@]}"
}

# Tests link against a static archive: each test pulls only the objects it needs, so the core
# tests do not depend on unfinished modules. A strong port_hooks_engine/port_hooks_shell
# replaces the weak core default only when its object is pulled in (by a direct reference).
target_native() {
    log "native: $OUT/native/"
    native_objects
    local -a objs
    mapfile -t objs < <(objects "$OUT/native/obj")
    rm -f "$OUT/native/libmoeboid.a"
    llvm-ar rcs "$OUT/native/libmoeboid.a" "${objs[@]}"
    local t name
    for t in "$PORT"/tests/native/test_*.c; do
        [ -f "$t" ] || continue
        name="$(basename "${t%.c}")"
        log "  ld $name"
        "$CC" "${CFLAGS_TEST[@]}" -o "$OUT/native/$name" "$t" "$OUT/native/libmoeboid.a"
    done
}

target_pylib() {
    log "pylib: $OUT/libmoeboid.so"
    native_objects
    local -a objs
    mapfile -t objs < <(objects "$OUT/native/obj")
    "$CC" -shared -o "$OUT/libmoeboid.so" "${objs[@]}"
}

target_host() {
    log "host: $OUT/web/"
    mkdir -p "$OUT/web"
    local f
    for f in "$PORT"/host/*.html "$PORT"/host/*.css; do
        [ -f "$f" ] && cp "$f" "$OUT/web/"
    done
    # module.stripTypeScriptTypes is experimental in node 25.2.1: the warning is suppressed.
    node --disable-warning=ExperimentalWarning --input-type=module -e '
        import { stripTypeScriptTypes } from "node:module";
        import { readFileSync, writeFileSync, readdirSync } from "node:fs";
        const [src, dst] = process.argv.slice(1);
        for (const f of readdirSync(src).sort()) {
            if (!f.endsWith(".ts") || f.endsWith(".d.ts")) continue;
            const js = stripTypeScriptTypes(readFileSync(`${src}/${f}`, "utf8"), { mode: "strip" });
            writeFileSync(`${dst}/${f.slice(0, -3)}.js`, js);
        }' "$PORT/host" "$OUT/web"
    # Optional type check with the dev-only typescript package (decisions.md O4).
    if [ -x "$PORT/node_modules/.bin/tsc" ]; then
        log "  tsc --noEmit"
        "$PORT/node_modules/.bin/tsc" --noEmit --strict --target es2022 --module esnext --moduleResolution bundler \
            --lib es2022,dom,dom.iterable --erasableSyntaxOnly --noUnusedLocals --noUnusedParameters "$PORT"/host/*.ts
    else
        log "  note: no type check (port/node_modules/.bin/tsc missing)"
    fi
    if [ -f "$OUT/moeboid.wasm" ]; then cp "$OUT/moeboid.wasm" "$OUT/web/moeboid.wasm"; fi
    # The page loads the original Moeboid.gam from its own directory (read-only copy).
    cp "$ROOT/extracted/Moeboid.gam" "$OUT/web/Moeboid.gam"
    [ -f "$OUT/web/pack.bin" ] || log "  note: $OUT/web/pack.bin missing (run: port/build.sh pack)"
}

target_pack() {
    if [ -f "$PORT/tools/mkpack.py" ]; then
        log "pack: $PYTHON -I -B port/tools/mkpack.py"
        mkdir -p "$OUT/web"
        (cd "$ROOT" && "$PYTHON" -I -B "$PORT/tools/mkpack.py")
    else
        log "pack: skipped (port/tools/mkpack.py does not exist yet)"
    fi
}

target_test() {
    target_native
    target_pylib
    target_wasm
    target_wasm_trace
    local fails=0 n=0 t
    for t in "$OUT"/native/test_*; do
        [ -x "$t" ] || continue
        n=$((n + 1))
        log "== $(basename "$t")"
        "$t" || { fails=$((fails + 1)); log "FAILED: $t"; }
    done
    for t in "$PORT"/tests/node/*.mjs; do
        [ -f "$t" ] || continue
        n=$((n + 1))
        log "== node $(basename "$t")"
        node "$t" "$OUT/moeboid.wasm" || { fails=$((fails + 1)); log "FAILED: $t"; }
    done
    if [ -d "$PORT/tests/py" ]; then
        for t in "$PORT"/tests/py/test_*.py; do
            [ -f "$t" ] || continue
            n=$((n + 1))
            log "== python $(basename "$t")"
            (cd "$ROOT" && "$PYTHON" -I -B "$t") || { fails=$((fails + 1)); log "FAILED: $t"; }
        done
    fi
    log "test programs: $n, failed: $fails"
    [ "$fails" -eq 0 ]
}

main() {
    [ $# -gt 0 ] || set -- all
    mkdir -p "$OUT"
    local t
    for t in "$@"; do
        case "$t" in
        wasm) target_wasm ;;
        wasm-trace) target_wasm_trace ;;
        native) target_native ;;
        pylib) target_pylib ;;
        host) target_host ;;
        pack) target_pack ;;
        test) target_test ;;
        all) target_wasm; target_wasm_trace; target_native; target_pylib; target_pack; target_host ;;
        clean) rm -rf "$OUT" ;;
        *) log "unknown target: $t"; exit 2 ;;
        esac
    done
}

main "$@"
