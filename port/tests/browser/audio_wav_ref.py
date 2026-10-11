"""Reference decode of the port sounds for port/tests/browser/audio_wav.mjs (M6).

Reads the sound table from port/src/core/sound_ids.h and each WAV from the phase 1 asset
extraction (assets/<module>/raw/RCDATA/<NAME>_0409.wav), not from pack.bin. Decodes with the
engine RIFF rules (analysis/audio-input.md 2.3) and the float conversion of the host
(8-bit (b - 128) / 128, 16-bit s / 32768) and writes one JSON record per sound: rate,
channels, bits, frames, sha256 of the float32 little-endian samples (channel 0), first 8
samples, min, max.

Usage: python -I -B port/tests/browser/audio_wav_ref.py OUT.json
"""
import hashlib
import json
import pathlib
import re
import struct
import sys

ROOT = pathlib.Path(__file__).resolve().parents[3]
HEADER = ROOT / "port/src/core/sound_ids.h"
MODULE_DIR = {"gam": "Moeboid.gam", "zap": "ZapSpot.exe"}


def sound_table():
    rows = re.findall(r'X\((\d+),\s*(\w+),\s*"([^"]+)",\s*([\w|]+)\)', HEADER.read_text())
    return [(int(i), name, entry, flags) for i, name, entry, flags in rows]


def asset_path(entry):
    mod, typ, name = entry.split("/")
    stem = name[:-4] if name.upper().endswith(".WAV") else name
    return ROOT / "assets" / MODULE_DIR[mod] / "raw" / typ / f"{stem}_0409.wav"


def decode(b):
    assert b[:4] == b"RIFF" and b[8:12] == b"WAVE"
    end = min(len(b), struct.unpack_from("<I", b, 4)[0] + 8)
    p, fmt, data = 12, None, None
    while p + 8 <= end and (fmt is None or data is None):
        cid, size = struct.unpack_from("<4sI", b, p)
        if cid == b"fmt " and fmt is None:
            assert size >= 16
            fmt = struct.unpack_from("<HHIIHH", b, p + 8)
        elif cid == b"data" and data is None:
            data = b[p + 8:p + 8 + size]
        p += 8 + size + (size & 1)
    tag, ch, rate, _, align, bits = fmt
    assert tag == 1 and ch == 1 and align == bits // 8
    if bits == 8:
        vals = [(x - 128) / 128 for x in data]
    else:
        vals = [s / 32768 for (s,) in struct.iter_unpack("<h", data[:len(data) // 2 * 2])]
    f32 = struct.pack(f"<{len(vals)}f", *vals)
    assert struct.unpack(f"<{len(vals)}f", f32) == tuple(vals)  # exact in float32
    return {
        "rate": rate, "channels": ch, "bits": bits, "frames": len(vals),
        "sha256": hashlib.sha256(f32).hexdigest(),
        "first": vals[:8], "min": min(vals), "max": max(vals),
    }


def main():
    out = {}
    for sid, name, entry, flags in sound_table():
        path = asset_path(entry)
        rec = decode(path.read_bytes())
        rec.update(name=name, entry=entry, flags=flags, source=str(path.relative_to(ROOT)))
        out[str(sid)] = rec
    pathlib.Path(sys.argv[1]).write_text(json.dumps(out, indent=1) + "\n")
    print(f"audio_wav_ref: {len(out)} sounds")


if __name__ == "__main__":
    main()
