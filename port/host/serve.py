"""Static server for the Moeboid port page (M1). Binds to 127.0.0.1 only, serves .wasm as
application/wasm (needed by WebAssembly.compileStreaming) and sends the page CSP as a header.

Usage: python -I -B port/host/serve.py --directory port/build/web [--port 8000]
"""
import argparse
import functools
import http.server
import sys

# Same policy as the meta tag in index.html, plus frame-ancestors (header only).
CSP = ("default-src 'none'; script-src 'self' 'wasm-unsafe-eval'; style-src 'self'; "
       "img-src blob: data:; connect-src 'self'; base-uri 'none'; form-action 'none'; "
       "frame-ancestors 'none'")

TYPES = {
    ".html": "text/html; charset=utf-8",
    ".js": "text/javascript; charset=utf-8",
    ".mjs": "text/javascript; charset=utf-8",
    ".css": "text/css; charset=utf-8",
    ".wasm": "application/wasm",
    ".bin": "application/octet-stream",
    ".gam": "application/octet-stream",
    ".json": "application/json",
    ".png": "image/png",
}


class Handler(http.server.SimpleHTTPRequestHandler):
    extensions_map = {**http.server.SimpleHTTPRequestHandler.extensions_map, **TYPES}

    def end_headers(self):
        self.send_header("Content-Security-Policy", CSP)
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header("Referrer-Policy", "no-referrer")
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cache-Control", "no-cache")
        super().end_headers()


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--directory", required=True)
    ap.add_argument("--port", type=int, default=8000)
    ns = ap.parse_args()
    handler = functools.partial(Handler, directory=ns.directory)
    with http.server.ThreadingHTTPServer(("127.0.0.1", ns.port), handler) as srv:
        print(f"serving {ns.directory} at http://127.0.0.1:{srv.server_address[1]}/", flush=True)
        try:
            srv.serve_forever()
        except KeyboardInterrupt:
            pass
    return 0


if __name__ == "__main__":
    sys.exit(main())
