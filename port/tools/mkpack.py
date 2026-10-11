#!/usr/bin/env python3
"""Resource pack builder for the Moeboid port (docs/port-design.md section 7).

Run:  python -I -B port/tools/mkpack.py [--out DIR] [--quiet]
Reads extracted/ZapSpot.exe, extracted/Moeboid.gam (resources, byte-exact) and fonts/ (glyph atlases,
through mkatlas.py). Writes DIR/pack.bin and DIR/Moeboid.gam (default DIR: port/build/web) and prints
a manifest. The output is deterministic: the same inputs give the same bytes.

pack.bin layout (little-endian):
  "MPAK", u32 version (1), u32 count,
  count x {u32 name_len, name bytes (ASCII, no NUL), u32 offset (from file start), u32 length},
  data: each entry starts on a 4-byte boundary, padding bytes are 0.
Entries are sorted by name (bytewise), so a reader can use binary search.
Names: "zap/<TYPE>/<NAME>" and "gam/<TYPE>/<NAME>" for every resource of ZapSpot.exe and Moeboid.gam
(TYPE = CURSOR, BITMAP, ICON, DIALOG, STRING, RCDATA, GROUP_CURSOR, GROUP_ICON; NAME = the resource
name as stored, upper case, or the decimal id), "font/<FACE>-<px>-<weight>-<MONO|GRAY>" for atlases,
"data/..." for tables of other tools (TABLE_PRODUCERS, for example data/luna/NORMALBLUE from mkluna.py).
"""
import hashlib
import json
import os
import shutil
import struct
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import mkatlas  # noqa: E402

ROOT = mkatlas.ROOT
EXTRACTED = os.path.join(ROOT, 'extracted')
INDEX = os.path.join(ROOT, 'assets', 'index.json')
PACK_MAGIC = b'MPAK'
PACK_VERSION = 1
RT_NAMES = {1: 'CURSOR', 2: 'BITMAP', 3: 'ICON', 4: 'MENU', 5: 'DIALOG', 6: 'STRING', 9: 'ACCELERATOR',
            10: 'RCDATA', 11: 'MESSAGETABLE', 12: 'GROUP_CURSOR', 14: 'GROUP_ICON', 16: 'VERSION', 24: 'MANIFEST'}
BINARIES = (('zap', 'ZapSpot.exe'), ('gam', 'Moeboid.gam'))


def pe_resources(path):
    """Walk the PE resource tree. Returns a list of (type, name, lang, file_offset, bytes)."""
    d = open(path, 'rb').read()
    pe = struct.unpack_from('<I', d, 0x3c)[0]
    assert d[pe:pe + 4] == b'PE\0\0'
    nsec = struct.unpack_from('<H', d, pe + 6)[0]
    opt = struct.unpack_from('<H', d, pe + 20)[0]
    magic = struct.unpack_from('<H', d, pe + 24)[0]
    dd = pe + 24 + (96 if magic == 0x10b else 112)
    rva, size = struct.unpack_from('<II', d, dd + 2 * 8)
    secs = [struct.unpack_from('<8sIIII', d, pe + 24 + opt + i * 40) for i in range(nsec)]

    def off(r):
        for n, vs, va, rs, ro in secs:
            if va <= r < va + max(vs, rs):
                return r - va + ro
        raise ValueError('rva %#x outside sections' % r)

    base = off(rva)

    def name(o):
        n = struct.unpack_from('<H', d, base + o)[0]
        return d[base + o + 2:base + o + 2 + 2 * n].decode('utf-16le')

    out = []

    def walk(o, path):
        nn, ni = struct.unpack_from('<HH', d, base + o + 12)
        for i in range(nn + ni):
            idv, ov = struct.unpack_from('<II', d, base + o + 16 + i * 8)
            k = name(idv & 0x7fffffff) if idv & 0x80000000 else idv
            if ov & 0x80000000:
                walk(ov & 0x7fffffff, path + [k])
            else:
                r, s = struct.unpack_from('<II', d, base + ov)
                fo = off(r)
                out.append((path[0], path[1], k, fo, d[fo:fo + s]))

    walk(0, [])
    return out


def resource_entries(log):
    entries = []
    index = None
    if os.path.exists(INDEX):
        index = {}
        for r in json.load(open(INDEX))['resources']:
            index[(r['binary'], r['type'], r['name'])] = r
    for prefix, fname in BINARIES:
        path = os.path.join(EXTRACTED, fname)
        res = pe_resources(path)
        seen = set()
        for typ, nm, lang, fo, data in res:
            tname = RT_NAMES.get(typ, str(typ)) if isinstance(typ, int) else typ
            rname = str(nm) if isinstance(nm, int) else nm.upper()
            key = '%s/%s/%s' % (prefix, tname, rname)
            assert key not in seen, 'duplicate resource %s (language %s)' % (key, lang)
            seen.add(key)
            if index is not None:
                r = index.get((fname, tname, str(nm)))
                assert r is not None, 'resource %s missing from assets/index.json' % key
                assert r['sha256'] == hashlib.sha256(data).hexdigest(), 'sha256 differs from index: %s' % key
                assert int(r['file_offset'], 16) == fo, 'offset differs from index: %s' % key
            entries.append((key, data))
        log('%s: %d resources%s' % (fname, len(res), ', sha256 and offsets equal assets/index.json'
                                     if index is not None else ''))
    return entries


# Optional table producers in port/tools: module name -> its pack_entries() returns [(name, bytes)].
# A producer whose input is missing (decision 4c: never block on user files) is skipped with a warning.
TABLE_PRODUCERS = ('mkluna',)


def table_entries(log):
    out = []
    for mod in TABLE_PRODUCERS:
        if not os.path.exists(os.path.join(HERE, mod + '.py')):
            continue
        try:
            m = __import__(mod)
            ent = m.pack_entries()
        except Exception as e:  # noqa: BLE001 - report and continue without this table
            log('WARNING: %s.pack_entries() failed, its entries are omitted: %s: %s' % (mod, type(e).__name__, e))
            continue
        for name, blob in ent:
            assert name.startswith('data/'), name
            out.append((name, bytes(blob)))
        log('%s: %s' % (mod, ', '.join('%s %d bytes' % (n, len(b)) for n, b in ent)))
    return out


def write_pack(entries):
    entries = sorted(entries, key=lambda e: e[0].encode('ascii'))
    names = [e[0].encode('ascii') for e in entries]
    assert len(set(names)) == len(names)
    head = 12 + sum(4 + len(n) + 8 for n in names)
    pos = (head + 3) & ~3
    dirb = bytearray(PACK_MAGIC + struct.pack('<II', PACK_VERSION, len(entries)))
    data = bytearray()
    offsets = []
    for n, (_, blob) in zip(names, entries):
        offsets.append(pos)
        dirb += struct.pack('<I', len(n)) + n + struct.pack('<II', pos, len(blob))
        data += blob
        pad = (-len(blob)) & 3
        data += b'\0' * pad
        pos += len(blob) + pad
    dirb += b'\0' * (((head + 3) & ~3) - head)
    out = bytes(dirb) + bytes(data)
    return out, [(e[0], o, len(e[1])) for e, o in zip(entries, offsets)]


def main(argv):
    out_dir = os.path.join(ROOT, 'port', 'build', 'web')
    if '--out' in argv:
        out_dir = argv[argv.index('--out') + 1]
    quiet = '--quiet' in argv
    log = (lambda s: None) if quiet else print
    entries = resource_entries(print)
    atlases, report = mkatlas.build_atlases(log)
    mkatlas.print_report(report, atlases, log)
    entries += atlases
    entries += table_entries(print)
    pack, manifest = write_pack(entries)
    os.makedirs(out_dir, exist_ok=True)
    pack_path = os.path.join(out_dir, 'pack.bin')
    tmp = pack_path + '.tmp'
    with open(tmp, 'wb') as f:
        f.write(pack)
    os.replace(tmp, pack_path)
    gam_src = os.path.join(EXTRACTED, 'Moeboid.gam')
    gam_dst = os.path.join(out_dir, 'Moeboid.gam')
    shutil.copyfile(gam_src, gam_dst)
    log('manifest: offset length sha256[:16] name')
    for name, off, ln in manifest:
        blob = pack[off:off + ln]
        log('  %8d %7d %s %s' % (off, ln, hashlib.sha256(blob).hexdigest()[:16], name))
    print('pack.bin: %d entries, %d bytes, sha256 %s' % (len(manifest), len(pack), hashlib.sha256(pack).hexdigest()))
    print('Moeboid.gam: %d bytes, sha256 %s' % (os.path.getsize(gam_dst),
                                                 hashlib.sha256(open(gam_dst, 'rb').read()).hexdigest()))
    print('written to %s' % out_dir)
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
