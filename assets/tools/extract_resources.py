#!/usr/bin/env python3
"""Extract and decode every PE resource of the Moeboid / ZapSpot binaries.

Run from the project root:
      source tools/env.sh
      python -I assets/tools/extract_resources.py

Inputs (read only, paths relative to the project root):
  extracted/Moeboid.gam
  extracted/ZapSpot.exe
  moeboid.exe
  fonts/sserife.fon   (dialog base units)
Outputs: assets/ (this script writes nowhere else).

The script removes and rebuilds assets/<binary>/ and the top-level index files.
It does not touch assets/tools/.
"""
import hashlib
import io
import json
import re
import shutil
import struct
import subprocess
import sys
from collections import Counter, OrderedDict, defaultdict
from pathlib import Path

import pefile
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]  # assets/tools/ -> project root
OUT = ROOT / 'assets'
BINARIES = [
    ('Moeboid.gam', ROOT / 'extracted' / 'Moeboid.gam'),
    ('ZapSpot.exe', ROOT / 'extracted' / 'ZapSpot.exe'),
    ('moeboid.exe', ROOT / 'moeboid.exe'),
]
DIALOG_FONT_FILE = ROOT / 'fonts' / 'sserife.fon'
LOGPIXELSY = 96  # assumption: "Small Fonts" (96 DPI) display setting

RT_NAMES = {1: 'CURSOR', 2: 'BITMAP', 3: 'ICON', 4: 'MENU', 5: 'DIALOG', 6: 'STRING',
            7: 'FONTDIR', 8: 'FONT', 9: 'ACCELERATOR', 10: 'RCDATA', 11: 'MESSAGETABLE',
            12: 'GROUP_CURSOR', 14: 'GROUP_ICON', 16: 'VERSION', 17: 'DLGINCLUDE',
            19: 'PLUGPLAY', 20: 'VXD', 21: 'ANICURSOR', 22: 'ANIICON', 23: 'HTML', 24: 'MANIFEST'}

ANOMALIES = []          # (binary, text)
NONRESOURCE = []        # extra data outside the resource tree


def u16(b, o):
    return struct.unpack_from('<H', b, o)[0]


def u32(b, o):
    return struct.unpack_from('<I', b, o)[0]


def sha256(b):
    return hashlib.sha256(b).hexdigest()


def rel(p):
    return str(Path(p).relative_to(OUT))


def write_bytes(p, b):
    p = Path(p)
    assert OUT in p.parents, p
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_bytes(b)


def write_text(p, s):
    write_bytes(p, s.encode('utf-8'))


def write_json(p, obj):
    write_text(p, json.dumps(obj, indent=1, ensure_ascii=False) + '\n')


def muldiv(a, b, c):
    """Win32 MulDiv: 64-bit product, round half away from zero."""
    if c == 0:
        return -1
    if c < 0:
        a, c = -a, -c
    p = a * b
    if p >= 0:
        return (p + c // 2) // c
    return -((-p + c // 2) // c)


def esc(s):
    """Escape control characters for one-line text output."""
    out = []
    for ch in s:
        o = ord(ch)
        if ch == '\\':
            out.append('\\\\')
        elif ch == '"':
            out.append('\\"')
        elif ch == '\n':
            out.append('\\n')
        elif ch == '\r':
            out.append('\\r')
        elif ch == '\t':
            out.append('\\t')
        elif o < 0x20 or 0x7f <= o < 0xa0:
            out.append('\\x%02x' % o)
        elif o in (0x2028, 0x2029, 0xfeff, 0xfffe, 0xffff):
            out.append('\\u%04x' % o)
        else:
            out.append(ch)
    return ''.join(out)


# ---------------------------------------------------------------------------
# PE resource walker (independent of pefile; pefile is used as a cross-check)
# ---------------------------------------------------------------------------

def pe_sections(data):
    pe = u32(data, 0x3c)
    assert data[pe:pe + 4] == b'PE\0\0'
    nsec = u16(data, pe + 6)
    opt_size = u16(data, pe + 20)
    opt = pe + 24
    magic = u16(data, opt)
    dd = opt + (96 if magic == 0x10b else 112)
    ndd = u32(data, dd - 4)
    dirs = [struct.unpack_from('<II', data, dd + 8 * i) for i in range(ndd)]
    secs = []
    for i in range(nsec):
        name, vs, va, rs, ro = struct.unpack_from('<8sIIII', data, opt + opt_size + 40 * i)
        secs.append(dict(name=name.rstrip(b'\0').decode('latin-1'), vsize=vs, va=va, rsize=rs, roff=ro))
    return secs, dirs


def rva2off(secs, rva):
    for s in secs:
        if s['va'] <= rva < s['va'] + max(s['vsize'], s['rsize']):
            d = rva - s['va']
            if d >= s['rsize']:
                return None
            return s['roff'] + d
    return None


def walk_resources(data):
    secs, dirs = pe_sections(data)
    rsrc_rva, rsrc_size = dirs[2]
    base = rva2off(secs, rsrc_rva)
    covered = []
    entries = []
    visited = set()

    def read_name(o):
        n = u16(data, base + o)
        covered.append((base + o, base + o + 2 + 2 * n, 'name'))
        return data[base + o + 2: base + o + 2 + 2 * n].decode('utf-16le')

    def walk(o, path):
        if o in visited:
            raise ValueError('resource directory loop at 0x%x' % o)
        visited.add(o)
        chars, ts, vmaj, vmin, nn, ni = struct.unpack_from('<IIHHHH', data, base + o)
        covered.append((base + o, base + o + 16 + 8 * (nn + ni), 'dir'))
        if not path:
            walk.root = dict(characteristics=chars, timestamp=ts, version='%d.%d' % (vmaj, vmin))
        for i in range(nn + ni):
            idv, ov = struct.unpack_from('<II', data, base + o + 16 + 8 * i)
            key = read_name(idv & 0x7fffffff) if idv & 0x80000000 else idv
            if ov & 0x80000000:
                walk(ov & 0x7fffffff, path + [key])
            else:
                rva, size, cp, res = struct.unpack_from('<IIII', data, base + ov)
                covered.append((base + ov, base + ov + 16, 'entry'))
                fo = rva2off(secs, rva)
                if fo is None:
                    raise ValueError('resource data outside file: %r' % (path + [key]))
                covered.append((fo, fo + size, 'data'))
                entries.append(dict(path=path + [key], rva=rva, size=size, codepage=cp,
                                    reserved=res, file_offset=fo, entry_offset=base + ov))
    walk.root = None
    walk(0, [])
    rsec = next(s for s in secs if s['va'] <= rsrc_rva < s['va'] + max(s['vsize'], s['rsize']))
    return entries, covered, rsec, secs, dirs, walk.root


def uncovered_nonzero(data, covered, start, end):
    """Byte ranges in [start,end) not covered by any resource structure and not all zero."""
    marks = bytearray(end - start)
    for a, b, _ in covered:
        a2, b2 = max(a, start), min(b, end)
        if a2 < b2:
            marks[a2 - start:b2 - start] = b'\1' * (b2 - a2)
    out = []
    i = 0
    n = len(marks)
    while i < n:
        if marks[i]:
            i += 1
            continue
        j = i
        while j < n and not marks[j]:
            j += 1
        chunk = data[start + i:start + j]
        if any(chunk):
            out.append(dict(offset=start + i, length=j - i, sample=chunk[:48].hex()))
        i = j
    return out


# ---------------------------------------------------------------------------
# GIF parser with LZW decoder
# ---------------------------------------------------------------------------

def hexcol(r, g, b):
    return '#%02x%02x%02x' % (r, g, b)


def table_colors(b):
    return [hexcol(b[i], b[i + 1], b[i + 2]) for i in range(0, len(b), 3)]


def lzw_decode(data, min_code, npix):
    clear = 1 << min_code
    eoi = clear + 1
    code_size = min_code + 1
    table = [bytes([i]) for i in range(clear)] + [b'', b'']
    out = bytearray()
    prev = None
    bitbuf = 0
    nbits = 0
    pos = 0
    status = 'no_eoi'
    while True:
        while nbits < code_size and pos < len(data):
            bitbuf |= data[pos] << nbits
            nbits += 8
            pos += 1
        if nbits < code_size:
            break
        code = bitbuf & ((1 << code_size) - 1)
        bitbuf >>= code_size
        nbits -= code_size
        if code == clear:
            table = table[:clear + 2]
            code_size = min_code + 1
            prev = None
            continue
        if code == eoi:
            status = 'eoi'
            break
        if prev is None:
            if code >= len(table):
                status = 'bad_code'
                break
            entry = table[code]
        elif code < len(table):
            entry = table[code]
            if len(table) < 4096:
                table.append(prev + entry[:1])
        elif code == len(table):
            entry = prev + prev[:1]
            if len(table) < 4096:
                table.append(entry)
        else:
            status = 'bad_code'
            break
        out += entry
        prev = entry
        if len(table) == (1 << code_size) and code_size < 12:
            code_size += 1
    return bytes(out[:npix]), dict(status=status, decoded_pixels=len(out), expected_pixels=npix,
                                   unused_bytes_after_eoi=len(data) - pos)


def deinterlace(idx, w, h):
    rows = []
    for start, step in ((0, 8), (4, 8), (2, 4), (1, 2)):
        rows.extend(range(start, h, step))
    out = bytearray(w * h)
    for i, r in enumerate(rows):
        out[r * w:(r + 1) * w] = idx[i * w:(i + 1) * w]
    return bytes(out)


def read_subblocks(b, pos):
    chunks = []
    while True:
        if pos >= len(b):
            return chunks, pos, False
        n = b[pos]
        pos += 1
        if n == 0:
            return chunks, pos, True
        chunks.append(b[pos:pos + n])
        pos += n


DISPOSAL = {0: 'unspecified', 1: 'do_not_dispose', 2: 'restore_to_background', 3: 'restore_to_previous'}


def parse_gif(b):
    g = OrderedDict()
    g['signature'] = b[:6].decode('latin-1')
    w, h, packed, bg, aspect = struct.unpack_from('<HHBBB', b, 6)
    g['width'], g['height'] = w, h
    gct_flag = packed >> 7
    g['color_resolution_bits'] = ((packed >> 4) & 7) + 1
    g['gct_sorted'] = bool((packed >> 3) & 1)
    gct_size = 2 ** ((packed & 7) + 1) if gct_flag else 0
    g['global_color_table_size'] = gct_size
    g['background_index'] = bg
    g['pixel_aspect_byte'] = aspect
    pos = 13
    gct = b[pos:pos + 3 * gct_size]
    pos += 3 * gct_size
    g['global_color_table'] = table_colors(gct)
    frames, exts = [], []
    gce = None
    loop = None
    problems = []
    while True:
        if pos >= len(b):
            problems.append('no trailer (0x3B) before end of data')
            break
        c = b[pos]
        if c == 0x21:
            label = b[pos + 1]
            ext_off = pos
            chunks, pos, ok = read_subblocks(b, pos + 2)
            if not ok:
                problems.append('truncated extension at 0x%x' % ext_off)
                break
            e = OrderedDict(offset=ext_off, label='0x%02x' % label)
            if label == 0xF9:
                blk = chunks[0] if chunks else b''
                e['type'] = 'graphic_control'
                if len(blk) >= 4:
                    p, delay, ti = struct.unpack_from('<BHB', blk, 0)
                    gce = dict(disposal=(p >> 2) & 7, user_input=bool(p & 2), transparent=bool(p & 1),
                               delay_cs=delay, transparent_index=ti, reserved_bits=p >> 5)
                    if len(blk) != 4:
                        problems.append('GCE block size %d at 0x%x' % (len(blk), ext_off))
                else:
                    problems.append('short GCE at 0x%x' % ext_off)
                continue  # attached to next image; not listed separately
            elif label == 0xFF:
                ident = chunks[0] if chunks else b''
                e['type'] = 'application'
                e['identifier'] = ident[:8].decode('latin-1')
                e['auth_code'] = ident[8:11].decode('latin-1')
                e['data_hex'] = b''.join(chunks[1:]).hex()
                if ident[:11] in (b'NETSCAPE2.0', b'ANIMEXTS1.0') and len(chunks) > 1 and len(chunks[1]) >= 3 \
                        and chunks[1][0] == 1:
                    loop = u16(chunks[1], 1)
                    e['loop_count'] = loop
            elif label == 0xFE:
                e['type'] = 'comment'
                e['text'] = b''.join(chunks).decode('latin-1')
            elif label == 0x01:
                e['type'] = 'plain_text'
                e['data_hex'] = b''.join(chunks).hex()
            else:
                e['type'] = 'unknown'
                e['data_hex'] = b''.join(chunks).hex()
            exts.append(e)
        elif c == 0x2C:
            fo = pos
            x, y, fw, fh, p = struct.unpack_from('<HHHHB', b, pos + 1)
            pos += 10
            lct_flag = p >> 7
            interlace = bool((p >> 6) & 1)
            lct_size = 2 ** ((p & 7) + 1) if lct_flag else 0
            lct = b[pos:pos + 3 * lct_size]
            pos += 3 * lct_size
            min_code = b[pos]
            pos += 1
            chunks, pos, ok = read_subblocks(b, pos)
            if not ok:
                problems.append('truncated image data at 0x%x' % fo)
            raw, lzw = lzw_decode(b''.join(chunks), min_code, fw * fh)
            if interlace and len(raw) == fw * fh:
                raw = deinterlace(raw, fw, fh)
            f = OrderedDict(index=len(frames), offset=fo, left=x, top=y, width=fw, height=fh,
                            interlaced=interlace, local_color_table_size=lct_size,
                            lct_sorted=bool((p >> 5) & 1), lzw_min_code_size=min_code)
            if gce:
                f['disposal'] = gce['disposal']
                f['disposal_name'] = DISPOSAL.get(gce['disposal'], 'reserved')
                f['delay_cs'] = gce['delay_cs']
                f['transparent'] = gce['transparent']
                f['transparent_index'] = gce['transparent_index']
                f['user_input'] = gce['user_input']
                f['has_gce'] = True
            else:
                f.update(disposal=0, disposal_name='none (no GCE)', delay_cs=0, transparent=False,
                         transparent_index=None, user_input=False, has_gce=False)
            f['local_color_table'] = table_colors(lct)
            f['lzw'] = lzw
            if lzw['decoded_pixels'] < fw * fh or lzw['status'] != 'eoi':
                problems.append('frame %d LZW: %s' % (len(frames), lzw))
            if x + fw > w or y + fh > h:
                problems.append('frame %d rect exceeds logical screen' % len(frames))
            f['_indices'] = raw
            gce = None
            frames.append(f)
        elif c == 0x3B:
            pos += 1
            break
        else:
            problems.append('unknown block byte 0x%02x at 0x%x' % (c, pos))
            break
    n_ext = len(exts) + sum(1 for f in frames if f['has_gce'])
    if g['signature'] == 'GIF87a' and n_ext:
        problems.append('GIF87a signature, but the file holds %d GIF89a extension blocks' % n_ext)
    g['loop_count'] = loop
    g['frame_count'] = len(frames)
    g['frames'] = frames
    g['extensions'] = exts
    tail = b[pos:]
    g['bytes_after_trailer'] = len(tail)
    g['bytes_after_trailer_all_zero'] = not any(tail)
    if tail:
        problems.append('%d bytes after trailer (zero: %s)' % (len(tail), not any(tail)))
    g['problems'] = problems
    return g


def gif_frame_png(f, palette_hex, path):
    im = Image.frombytes('P', (f['width'], f['height']), f['_indices'])
    pal = []
    for c in palette_hex:
        pal += [int(c[1:3], 16), int(c[3:5], 16), int(c[5:7], 16)]
    im.putpalette(pal or [0, 0, 0])
    buf = io.BytesIO()
    if f['transparent']:
        im.save(buf, 'PNG', transparency=f['transparent_index'])
    else:
        im.save(buf, 'PNG')
    write_bytes(path, buf.getvalue())


# ---------------------------------------------------------------------------
# WAV parser
# ---------------------------------------------------------------------------

WAVE_TAGS = {1: 'PCM', 2: 'MS ADPCM', 3: 'IEEE float', 6: 'A-law', 7: 'mu-law', 0x11: 'IMA ADPCM',
             0x31: 'GSM 6.10', 0x55: 'MPEG Layer 3', 0xFFFE: 'EXTENSIBLE'}


def parse_wav(b):
    w = OrderedDict()
    w['riff_id'] = b[:4].decode('latin-1')
    w['riff_size_field'] = u32(b, 4)
    w['form'] = b[8:12].decode('latin-1')
    w['resource_size'] = len(b)
    w['riff_size_matches'] = (w['riff_size_field'] + 8 == len(b))
    chunks = []
    pos = 12
    end = min(len(b), 8 + w['riff_size_field'])
    fmt = None
    data_len = None
    while pos + 8 <= end:
        cid = b[pos:pos + 4].decode('latin-1')
        cs = u32(b, pos + 4)
        body = b[pos + 8:pos + 8 + cs]
        ch = OrderedDict(id=cid, offset=pos, size=cs)
        if cid == 'fmt ':
            tag, nch, sr, abps, ba, bps = struct.unpack_from('<HHIIHH', body, 0)
            fmt = OrderedDict(format_tag=tag, format_name=WAVE_TAGS.get(tag, 'unknown'), channels=nch,
                              sample_rate=sr, avg_bytes_per_sec=abps, block_align=ba, bits_per_sample=bps)
            if cs >= 18:
                fmt['cb_size'] = u16(body, 16)
                fmt['extra_hex'] = body[18:18 + fmt['cb_size']].hex()
            ch['fmt'] = fmt
        elif cid == 'data':
            data_len = cs
            ch['data_sha256'] = sha256(body)
        elif cid == 'fact':
            ch['sample_count'] = u32(body, 0) if cs >= 4 else None
        elif cid == 'LIST':
            ch['list_type'] = body[:4].decode('latin-1')
            subs = []
            p = 4
            while p + 8 <= len(body):
                sid = body[p:p + 4].decode('latin-1')
                ss = u32(body, p + 4)
                subs.append(dict(id=sid, size=ss, value=body[p + 8:p + 8 + ss].rstrip(b'\0').decode('latin-1')))
                p += 8 + ss + (ss & 1)
            ch['subchunks'] = subs
        elif cid == 'smpl':
            vals = struct.unpack_from('<9I', body, 0)
            names = ['manufacturer', 'product', 'sample_period_ns', 'midi_unity_note', 'midi_pitch_fraction',
                     'smpte_format', 'smpte_offset', 'num_sample_loops', 'sampler_data']
            ch['smpl'] = dict(zip(names, vals))
            loops = []
            for i in range(vals[7]):
                lid, lt, ls, le, lf, lc = struct.unpack_from('<6I', body, 36 + 24 * i)
                loops.append(dict(cue_id=lid, type=lt, start=ls, end=le, fraction=lf, play_count=lc))
            ch['loops'] = loops
        elif cid == 'cue ':
            n = u32(body, 0)
            cues = []
            for i in range(n):
                cid2, ppos, dck, cst, bst, soff = struct.unpack_from('<II4sIII', body, 4 + 24 * i)
                cues.append(dict(id=cid2, position=ppos, chunk=dck.decode('latin-1'), chunk_start=cst,
                                 block_start=bst, sample_offset=soff))
            ch['cues'] = cues
        else:
            ch['body_hex_head'] = body[:64].hex()
        chunks.append(ch)
        pos += 8 + cs + (cs & 1)
    w['chunks'] = chunks
    w['fmt'] = fmt
    w['data_length'] = data_len
    w['bytes_after_riff'] = len(b) - (8 + w['riff_size_field']) if 8 + w['riff_size_field'] <= len(b) else None
    if fmt and data_len is not None and fmt['block_align']:
        frames = data_len // fmt['block_align']
        if fmt['format_tag'] == 1:
            w['sample_frames'] = frames
            w['duration_s'] = round(frames / fmt['sample_rate'], 6)
        else:
            fact = next((c.get('sample_count') for c in chunks if c['id'] == 'fact'), None)
            if fact:
                w['sample_frames'] = fact
                w['duration_s'] = round(fact / fmt['sample_rate'], 6)
            else:
                w['duration_s'] = round(data_len / fmt['avg_bytes_per_sec'], 6) if fmt['avg_bytes_per_sec'] else None
        w['data_length_is_block_multiple'] = (data_len % fmt['block_align'] == 0)
    w['extra_chunks'] = [c['id'] for c in chunks if c['id'] not in ('fmt ', 'data')]
    w['notes'] = []
    frames = w.get('sample_frames')
    for c in chunks:
        for q in c.get('cues', []):
            if frames is not None and q['sample_offset'] > frames:
                w['notes'].append('cue %d at sample %d is beyond the %d data samples' % (q['id'], q['sample_offset'],
                                                                                         frames))
    return w


# ---------------------------------------------------------------------------
# Dialog templates
# ---------------------------------------------------------------------------

DS_BITS = [(0x01, 'DS_ABSALIGN'), (0x02, 'DS_SYSMODAL'), (0x04, 'DS_3DLOOK'), (0x08, 'DS_FIXEDSYS'),
           (0x10, 'DS_NOFAILCREATE'), (0x20, 'DS_LOCALEDIT'), (0x40, 'DS_SETFONT'), (0x80, 'DS_MODALFRAME'),
           (0x100, 'DS_NOIDLEMSG'), (0x200, 'DS_SETFOREGROUND'), (0x400, 'DS_CONTROL'), (0x800, 'DS_CENTER'),
           (0x1000, 'DS_CENTERMOUSE'), (0x2000, 'DS_CONTEXTHELP')]
WS_EX_BITS = [(0x1, 'WS_EX_DLGMODALFRAME'), (0x4, 'WS_EX_NOPARENTNOTIFY'), (0x8, 'WS_EX_TOPMOST'),
              (0x10, 'WS_EX_ACCEPTFILES'), (0x20, 'WS_EX_TRANSPARENT'), (0x40, 'WS_EX_MDICHILD'),
              (0x80, 'WS_EX_TOOLWINDOW'), (0x100, 'WS_EX_WINDOWEDGE'), (0x200, 'WS_EX_CLIENTEDGE'),
              (0x400, 'WS_EX_CONTEXTHELP'), (0x1000, 'WS_EX_RIGHT'), (0x2000, 'WS_EX_RTLREADING'),
              (0x4000, 'WS_EX_LEFTSCROLLBAR'), (0x10000, 'WS_EX_CONTROLPARENT'), (0x20000, 'WS_EX_STATICEDGE'),
              (0x40000, 'WS_EX_APPWINDOW'), (0x80000, 'WS_EX_LAYERED'), (0x100000, 'WS_EX_NOINHERITLAYOUT'),
              (0x400000, 'WS_EX_LAYOUTRTL'), (0x2000000, 'WS_EX_COMPOSITED'), (0x8000000, 'WS_EX_NOACTIVATE')]
ATOMS = {0x80: 'Button', 0x81: 'Edit', 0x82: 'Static', 0x83: 'ListBox', 0x84: 'ScrollBar', 0x85: 'ComboBox'}
BS_TYPES = ['BS_PUSHBUTTON', 'BS_DEFPUSHBUTTON', 'BS_CHECKBOX', 'BS_AUTOCHECKBOX', 'BS_RADIOBUTTON', 'BS_3STATE',
            'BS_AUTO3STATE', 'BS_GROUPBOX', 'BS_USERBUTTON', 'BS_AUTORADIOBUTTON', 'BS_PUSHBOX', 'BS_OWNERDRAW',
            'BS_TYPE_0x0C', 'BS_TYPE_0x0D', 'BS_TYPE_0x0E', 'BS_TYPE_0x0F']
SS_TYPES = {0: 'SS_LEFT', 1: 'SS_CENTER', 2: 'SS_RIGHT', 3: 'SS_ICON', 4: 'SS_BLACKRECT', 5: 'SS_GRAYRECT',
            6: 'SS_WHITERECT', 7: 'SS_BLACKFRAME', 8: 'SS_GRAYFRAME', 9: 'SS_WHITEFRAME', 0xA: 'SS_USERITEM',
            0xB: 'SS_SIMPLE', 0xC: 'SS_LEFTNOWORDWRAP', 0xD: 'SS_OWNERDRAW', 0xE: 'SS_BITMAP',
            0xF: 'SS_ENHMETAFILE', 0x10: 'SS_ETCHEDHORZ', 0x11: 'SS_ETCHEDVERT', 0x12: 'SS_ETCHEDFRAME'}


def bits(value, table):
    names = []
    for m, n in table:
        if value & m == m:
            names.append(n)
            value &= ~m
    return names, value


def decode_ws(style, top_level):
    names = []
    v = style & 0xFFFF0000
    if v & 0x00C00000 == 0x00C00000:
        names.append('WS_CAPTION')
        v &= ~0x00C00000
    hi = [(0x80000000, 'WS_POPUP'), (0x40000000, 'WS_CHILD'), (0x20000000, 'WS_MINIMIZE'),
          (0x10000000, 'WS_VISIBLE'), (0x08000000, 'WS_DISABLED'), (0x04000000, 'WS_CLIPSIBLINGS'),
          (0x02000000, 'WS_CLIPCHILDREN'), (0x01000000, 'WS_MAXIMIZE'), (0x00800000, 'WS_BORDER'),
          (0x00400000, 'WS_DLGFRAME'), (0x00200000, 'WS_VSCROLL'), (0x00100000, 'WS_HSCROLL'),
          (0x00080000, 'WS_SYSMENU'), (0x00040000, 'WS_THICKFRAME')]
    hi += [(0x00020000, 'WS_MINIMIZEBOX'), (0x00010000, 'WS_MAXIMIZEBOX')] if top_level else \
        [(0x00020000, 'WS_GROUP'), (0x00010000, 'WS_TABSTOP')]
    n2, rest = bits(v, hi)
    return names + n2, rest


def decode_control_low(cls, style):
    low = style & 0xFFFF
    c = cls.lower() if isinstance(cls, str) else ''
    names = []
    if c == 'button':
        names.append(BS_TYPES[low & 0xF])
        low &= ~0xF
        h = low & 0x300
        names += {0x100: ['BS_LEFT'], 0x200: ['BS_RIGHT'], 0x300: ['BS_CENTER']}.get(h, [])
        v = low & 0xC00
        names += {0x400: ['BS_TOP'], 0x800: ['BS_BOTTOM'], 0xC00: ['BS_VCENTER']}.get(v, [])
        low &= ~0xF00
        n2, low = bits(low, [(0x20, 'BS_LEFTTEXT'), (0x40, 'BS_ICON'), (0x80, 'BS_BITMAP'), (0x1000, 'BS_PUSHLIKE'),
                             (0x2000, 'BS_MULTILINE'), (0x4000, 'BS_NOTIFY'), (0x8000, 'BS_FLAT')])
        names += n2
    elif c == 'edit':
        names.append(['ES_LEFT', 'ES_CENTER', 'ES_RIGHT', 'ES_ALIGN_3'][low & 3])
        low &= ~3
        n2, low = bits(low, [(0x4, 'ES_MULTILINE'), (0x8, 'ES_UPPERCASE'), (0x10, 'ES_LOWERCASE'),
                             (0x20, 'ES_PASSWORD'), (0x40, 'ES_AUTOVSCROLL'), (0x80, 'ES_AUTOHSCROLL'),
                             (0x100, 'ES_NOHIDESEL'), (0x400, 'ES_OEMCONVERT'), (0x800, 'ES_READONLY'),
                             (0x1000, 'ES_WANTRETURN'), (0x2000, 'ES_NUMBER')])
        names += n2
    elif c == 'static':
        names.append(SS_TYPES.get(low & 0x1F, 'SS_TYPE_0x%02X' % (low & 0x1F)))
        low &= ~0x1F
        e = low & 0xC000
        names += {0x4000: ['SS_ENDELLIPSIS'], 0x8000: ['SS_PATHELLIPSIS'], 0xC000: ['SS_WORDELLIPSIS']}.get(e, [])
        low &= ~0xC000
        n2, low = bits(low, [(0x40, 'SS_REALSIZECONTROL'), (0x80, 'SS_NOPREFIX'), (0x100, 'SS_NOTIFY'),
                             (0x200, 'SS_CENTERIMAGE'), (0x400, 'SS_RIGHTJUST'), (0x800, 'SS_REALSIZEIMAGE'),
                             (0x1000, 'SS_SUNKEN'), (0x2000, 'SS_EDITCONTROL')])
        names += n2
    elif c == 'listbox':
        n2, low = bits(low, [(0x1, 'LBS_NOTIFY'), (0x2, 'LBS_SORT'), (0x4, 'LBS_NOREDRAW'), (0x8, 'LBS_MULTIPLESEL'),
                             (0x10, 'LBS_OWNERDRAWFIXED'), (0x20, 'LBS_OWNERDRAWVARIABLE'), (0x40, 'LBS_HASSTRINGS'),
                             (0x80, 'LBS_USETABSTOPS'), (0x100, 'LBS_NOINTEGRALHEIGHT'), (0x200, 'LBS_MULTICOLUMN'),
                             (0x400, 'LBS_WANTKEYBOARDINPUT'), (0x800, 'LBS_EXTENDEDSEL'),
                             (0x1000, 'LBS_DISABLENOSCROLL'), (0x2000, 'LBS_NODATA'), (0x4000, 'LBS_NOSEL'),
                             (0x8000, 'LBS_COMBOBOX')])
        names += n2
    elif c == 'combobox':
        names.append({0: 'CBS_TYPE_0', 1: 'CBS_SIMPLE', 2: 'CBS_DROPDOWN', 3: 'CBS_DROPDOWNLIST'}[low & 3])
        low &= ~3
        n2, low = bits(low, [(0x10, 'CBS_OWNERDRAWFIXED'), (0x20, 'CBS_OWNERDRAWVARIABLE'), (0x40, 'CBS_AUTOHSCROLL'),
                             (0x80, 'CBS_OEMCONVERT'), (0x100, 'CBS_SORT'), (0x200, 'CBS_HASSTRINGS'),
                             (0x400, 'CBS_NOINTEGRALHEIGHT'), (0x800, 'CBS_DISABLENOSCROLL'),
                             (0x2000, 'CBS_UPPERCASE'), (0x4000, 'CBS_LOWERCASE')])
        names += n2
    elif c == 'scrollbar':
        names.append('SBS_VERT' if low & 1 else 'SBS_HORZ')
        low &= ~1
        n2, low = bits(low, [(0x2, 'SBS_TOPALIGN/LEFTALIGN'), (0x4, 'SBS_BOTTOMALIGN/RIGHTALIGN'),
                             (0x8, 'SBS_SIZEBOX'), (0x10, 'SBS_SIZEGRIP')])
        names += n2
    else:
        return ['0x%04X (class-specific, not decoded)' % low] if low else [], 0
    return names, low


def sz_or_ord(b, pos):
    if u16(b, pos) == 0xFFFF:
        return u16(b, pos + 2), pos + 4
    end = pos
    while u16(b, end) != 0:
        end += 2
    return b[pos:end].decode('utf-16le'), end + 2


def align4(p):
    return (p + 3) & ~3


def parse_dialog(b):
    d = OrderedDict()
    ex = len(b) >= 4 and u16(b, 0) == 1 and u16(b, 2) == 0xFFFF
    d['format'] = 'DLGTEMPLATEEX' if ex else 'DLGTEMPLATE'
    if ex:
        d['help_id'], d['exstyle'], d['style'], n, x, y, cx, cy = struct.unpack_from('<IIIHhhhh', b, 4)
        pos = 26
    else:
        d['style'], d['exstyle'], n, x, y, cx, cy = struct.unpack_from('<IIHhhhh', b, 0)
        d['help_id'] = None
        pos = 18
    d['item_count'] = n
    d['x'], d['y'], d['cx'], d['cy'] = x, y, cx, cy
    if u16(b, pos) == 0:
        d['menu'] = None
        pos += 2
    else:
        d['menu'], pos = sz_or_ord(b, pos)
    if u16(b, pos) == 0:
        d['class'] = None
        pos += 2
    else:
        d['class'], pos = sz_or_ord(b, pos)
    d['caption'], pos = sz_or_ord(b, pos)
    d['font'] = None
    if d['style'] & 0x40:
        f = OrderedDict(point_size=u16(b, pos))
        pos += 2
        if ex:
            f['weight'], f['italic'], f['charset'] = struct.unpack_from('<HBB', b, pos)
            pos += 4
        else:
            f['weight'], f['italic'], f['charset'] = None, None, None
        f['face'], pos = sz_or_ord(b, pos)
        d['font'] = f
    d['style_names'], d['style_unknown'] = None, None
    ws, rest = decode_ws(d['style'], True)
    ds, rest_low = bits(d['style'] & 0xFFFF, DS_BITS)
    d['style_names'] = ds + ws
    d['style_unknown_bits'] = '0x%08X' % (rest | rest_low) if (rest | rest_low) else None
    exn, exr = bits(d['exstyle'], WS_EX_BITS)
    d['exstyle_names'] = exn
    d['exstyle_unknown_bits'] = '0x%08X' % exr if exr else None
    items = []
    for i in range(n):
        pos = align4(pos)
        it = OrderedDict(offset=pos)
        if ex:
            it['help_id'], it['exstyle'], it['style'], x, y, cx, cy, cid = struct.unpack_from('<IIIhhhhI', b, pos)
            pos += 24
        else:
            it['style'], it['exstyle'], x, y, cx, cy, cid = struct.unpack_from('<IIhhhhH', b, pos)
            it['help_id'] = None
            pos += 18
        it['id'] = cid
        if ex:
            it['id_signed'] = cid - (1 << 32) if cid >= 0x80000000 else cid
        else:
            it['id_signed'] = cid - 0x10000 if cid >= 0x8000 else cid
        it['x'], it['y'], it['cx'], it['cy'] = x, y, cx, cy
        cls, pos = sz_or_ord(b, pos)
        it['class_raw'] = cls
        it['class'] = ATOMS.get(cls, 'atom_0x%04X' % cls) if isinstance(cls, int) else cls
        it['text'], pos = sz_or_ord(b, pos)
        extra = u16(b, pos)
        pos += 2
        it['creation_data_hex'] = b[pos:pos + extra].hex() if extra else None
        pos += extra
        ws, rest = decode_ws(it['style'], False)
        low, lrest = decode_control_low(it['class'], it['style'])
        it['style_names'] = low + ws
        it['style_unknown_bits'] = '0x%08X' % (rest | lrest) if (rest | lrest) else None
        exn, exr = bits(it['exstyle'], WS_EX_BITS)
        it['exstyle_names'] = exn
        it['exstyle_unknown_bits'] = '0x%08X' % exr if exr else None
        items.append(it)
    d['items'] = items
    d['bytes_used'] = pos
    d['trailing_bytes'] = len(b) - pos
    return d


def load_fon_faces(path):
    d = path.read_bytes()
    ne = u32(d, 0x3c)
    assert d[ne:ne + 2] == b'NE'
    rt = ne + u16(d, ne + 0x24)
    shift = u16(d, rt)
    p = rt + 2
    faces = []
    while True:
        tid = u16(d, p)
        if tid == 0:
            break
        cnt = u16(d, p + 2)
        p += 8
        for _ in range(cnt):
            off, ln, fl, rid = struct.unpack_from('<HHHH', d, p)
            p += 12
            if tid == 0x8008:
                f = d[off << shift:(off << shift) + (ln << shift)]
                ver = u16(f, 0)
                pts, vres, hres, asc, il, el = struct.unpack_from('<HHHHHH', f, 68)
                fo = u32(f, 105)
                face = f[fo:f.index(b'\0', fo)].decode('latin-1')
                fc, lc = f[95], f[96]
                ct, es = (148, 6) if ver == 0x300 else (118, 4)
                widths = {c: u16(f, ct + (c - fc) * es) for c in range(fc, lc + 1)}
                faces.append(dict(version='0x%X' % ver, face=face, points=pts, vert_res=vres, horiz_res=hres,
                                  ascent=asc, internal_leading=il, external_leading=el,
                                  weight=u16(f, 83), charset=f[85], pix_height=u16(f, 88), avg_width=u16(f, 91),
                                  first_char=fc, last_char=lc, default_char=f[97], widths=widths))
    return faces


def dialog_base_units(font):
    """Return base units for a DS_SETFONT dialog, or None with a reason."""
    if not DIALOG_FONT_FILE.exists():
        return None, 'font file %s missing' % DIALOG_FONT_FILE
    if font is None:
        return None, 'no DS_SETFONT: system font base units (not computed)'
    if font['face'].lower() != 'ms sans serif':
        return None, 'font %r metrics not available; convert in a later step' % font['face']
    if font['weight'] not in (None, 0, 400) or font['italic']:
        return None, 'weight/italic simulation not modelled; convert in a later step'
    req_em = muldiv(font['point_size'], LOGPIXELSY, 72)
    faces = load_fon_faces(DIALOG_FONT_FILE)
    match = [f for f in faces if f['pix_height'] - f['internal_leading'] == req_em and f['vert_res'] == LOGPIXELSY]
    if len(match) != 1:
        return None, 'no exact bitmap strike for %d px em in %s' % (req_em, DIALOG_FONT_FILE.name)
    f = match[0]
    alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    ext = sum(f['widths'][ord(c)] for c in alphabet)
    bu = dict(x=(ext // 26 + 1) // 2, y=f['pix_height'],
              method='GdiGetCharDimensions: x=(extent("a..zA..Z")/26+1)/2, y=tmHeight; '
                     'px: x,cx *bx/4, y,cy *by/8 with MulDiv rounding',
              font_file=DIALOG_FONT_FILE.relative_to(ROOT).as_posix(), font_file_sha256=sha256(DIALOG_FONT_FILE.read_bytes()),
              strike=dict(points=f['points'], pix_height=f['pix_height'], internal_leading=f['internal_leading'],
                          ascent=f['ascent'], avg_width=f['avg_width'], charset=f['charset'], version=f['version']),
              alphabet_extent_px=ext, requested_height_px=-req_em, logpixelsy=LOGPIXELSY)
    return bu, None


def rc_str(s):
    if isinstance(s, int):
        return str(s)
    return '"' + s.replace('"', '""').replace('\\', '\\\\').replace('\r', '\\r').replace('\n', '\\n') \
        .replace('\t', '\\t') + '"'


def dialog_rc(binname, name, ent, d, bu, bu_reason):
    L = []
    L.append('// %s RT_DIALOG %s, language 0x%04X, %s, %d bytes, file offset 0x%X' %
             (binname, name, ent['lang'], d['format'], ent['size'], ent['file_offset']))
    if bu:
        L.append('// Pixel values: dialog base units %dx%d (MS Sans Serif %dpt strike from %s, %d DPI). '
                 'Client area only; frame size depends on the non-client metrics.' %
                 (bu['x'], bu['y'], d['font']['point_size'], Path(bu['font_file']).name, LOGPIXELSY))
    else:
        L.append('// Pixel values: not computed (%s).' % bu_reason)
    kw = 'DIALOGEX' if d['format'] == 'DLGTEMPLATEEX' else 'DIALOG'
    hdr = '%s %s %d, %d, %d, %d' % (name, kw, d['x'], d['y'], d['cx'], d['cy'])
    if d['help_id']:
        hdr += ', %d' % d['help_id']
    L.append(hdr)
    if bu:
        L.append('// client px: x=%d y=%d w=%d h=%d' % (muldiv(d['x'], bu['x'], 4), muldiv(d['y'], bu['y'], 8),
                                                         muldiv(d['cx'], bu['x'], 4), muldiv(d['cy'], bu['y'], 8)))
    L.append('STYLE %s   // 0x%08X%s' % (' | '.join(d['style_names']) or '0', d['style'],
                                         ', unknown bits ' + d['style_unknown_bits'] if d['style_unknown_bits'] else ''))
    if d['exstyle']:
        L.append('EXSTYLE %s   // 0x%08X' % (' | '.join(d['exstyle_names']), d['exstyle']))
    L.append('CAPTION %s' % rc_str(d['caption']))
    if d['menu'] is not None:
        L.append('MENU %s' % rc_str(d['menu']))
    if d['class'] is not None:
        L.append('CLASS %s' % rc_str(d['class']))
    if d['font']:
        f = d['font']
        if d['format'] == 'DLGTEMPLATEEX':
            L.append('FONT %d, %s, %d, %d, 0x%X   // point size, face, weight, italic, charset' %
                     (f['point_size'], rc_str(f['face']), f['weight'], f['italic'], f['charset']))
        else:
            L.append('FONT %d, %s   // DLGTEMPLATE: weight, italic and charset are not stored' %
                     (f['point_size'], rc_str(f['face'])))
    L.append('BEGIN')
    for it in d['items']:
        cls = rc_str(it['class']) if not isinstance(it['class_raw'], int) or it['class_raw'] in ATOMS \
            else '0x%04X' % it['class_raw']
        line = '    CONTROL %s, %d, %s, %s, %d, %d, %d, %d' % (
            rc_str(it['text']), it['id_signed'], cls, ' | '.join(it['style_names']) or '0',
            it['x'], it['y'], it['cx'], it['cy'])
        if it['exstyle'] or it['help_id']:
            line += ', %s' % (' | '.join(it['exstyle_names']) or '0')
        if it['help_id']:
            line += ', %d' % it['help_id']
        L.append(line)
        cm = '        // id=%d (0x%X) style=0x%08X exstyle=0x%08X' % (it['id_signed'], it['id'], it['style'], it['exstyle'])
        if it['style_unknown_bits']:
            cm += ' unknown-bits=%s' % it['style_unknown_bits']
        if it['creation_data_hex']:
            cm += ' creation-data=%s' % it['creation_data_hex']
        if bu:
            cm += ' | px x=%d y=%d w=%d h=%d' % (muldiv(it['x'], bu['x'], 4), muldiv(it['y'], bu['y'], 8),
                                                 muldiv(it['cx'], bu['x'], 4), muldiv(it['cy'], bu['y'], 8))
        L.append(cm)
    L.append('END')
    if d['trailing_bytes']:
        L.append('// %d trailing bytes after the last item' % d['trailing_bytes'])
    return '\n'.join(L) + '\n'


# ---------------------------------------------------------------------------
# Icons, cursors, bitmaps
# ---------------------------------------------------------------------------

def parse_bih(b):
    keys = ['biSize', 'biWidth', 'biHeight', 'biPlanes', 'biBitCount', 'biCompression', 'biSizeImage',
            'biXPelsPerMeter', 'biYPelsPerMeter', 'biClrUsed', 'biClrImportant']
    return OrderedDict(zip(keys, struct.unpack_from('<IiiHHIIiiII', b, 0)))


def dib_palette(b, h):
    n = h['biClrUsed'] or ((1 << h['biBitCount']) if h['biBitCount'] <= 8 else 0)
    off = h['biSize'] + (12 if h['biCompression'] == 3 and h['biSize'] == 40 else 0)
    return [hexcol(b[o + 2], b[o + 1], b[o]) for o in range(off, off + 4 * n, 4)], off + 4 * n


def render_icon_dib(dib):
    """Render an RT_ICON/RT_CURSOR DIB (XOR + AND mask) to RGBA. Return image and stats."""
    h = parse_bih(dib)
    w, hh, bpp = h['biWidth'], h['biHeight'] // 2, h['biBitCount']
    pal, xor_off = dib_palette(dib, h)
    xs = ((w * bpp + 31) // 32) * 4
    and_off = xor_off + xs * hh
    ands = ((w + 31) // 32) * 4
    need = and_off + ands * hh
    im = Image.new('RGBA', (w, hh))
    px = im.load()
    stats = Counter()
    for row in range(hh):
        y = hh - 1 - row
        xr = dib[xor_off + row * xs: xor_off + (row + 1) * xs]
        ar = dib[and_off + row * ands: and_off + (row + 1) * ands]
        for x in range(w):
            if bpp <= 8:
                bitpos = x * bpp
                v = (xr[bitpos // 8] >> (8 - bpp - bitpos % 8)) & ((1 << bpp) - 1)
                c = pal[v]
                r, g, bl = int(c[1:3], 16), int(c[3:5], 16), int(c[5:7], 16)
                a = 255
            elif bpp == 24:
                bl, g, r = xr[3 * x:3 * x + 3]
                a = 255
            elif bpp == 32:
                bl, g, r, a = xr[4 * x:4 * x + 4]
            else:
                raise ValueError('bpp %d' % bpp)
            m = (ar[x // 8] >> (7 - x % 8)) & 1 if ar else 0
            if m:
                if (r, g, bl) == (0, 0, 0):
                    px[x, y] = (0, 0, 0, 0)
                    stats['transparent'] += 1
                else:
                    px[x, y] = (255, 0, 255, 255)  # screen-invert pixel, shown as magenta
                    stats['invert'] += 1
            else:
                px[x, y] = (r, g, bl, a)
                stats['opaque'] += 1
    info = OrderedDict(header=h, width=w, height=hh, bits_per_pixel=bpp, palette=pal,
                       mask_bytes_expected_end=need, data_size=len(dib), pixel_stats=dict(stats),
                       preview_note='AND=1 & XOR=black: transparent; AND=1 & XOR!=black: screen invert, shown magenta')
    return im, info


# ---------------------------------------------------------------------------
# Strings, ZML
# ---------------------------------------------------------------------------

def decode_string_block(b, block):
    pos = 0
    out = []
    for i in range(16):
        n = u16(b, pos)
        pos += 2
        s = b[pos:pos + 2 * n].decode('utf-16le', 'surrogatepass')
        pos += 2 * n
        out.append(((block - 1) * 16 + i, s))
    return out, len(b) - pos


ZML_TAG = re.compile(r'<[^<>\r\n]{0,64}>')


def zml_tags(text):
    return Counter(ZML_TAG.findall(text))


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def magic_kind(name, b):
    if b[:6] in (b'GIF87a', b'GIF89a'):
        return 'gif', '.gif'
    if b[:4] == b'RIFF' and b[8:12] == b'WAVE':
        return 'wav', '.wav'
    if b[:8] == b'\x89PNG\r\n\x1a\n':
        return 'png', '.png'
    if b[:2] == b'BM':
        return 'bmp', '.bmp'
    if b[:3] == b'\xff\xd8\xff':
        return 'jpeg', '.jpg'
    if b[:2] == b'MZ':
        return 'mz', '.bin'
    if isinstance(name, str) and name.upper().endswith('.ZML'):
        return 'zml', '.zml'
    if b and sum(1 for c in b if 32 <= c < 127 or c in (9, 10, 13)) / len(b) > 0.97:
        return 'text', '.txt'
    return 'unknown', '.bin'


def safe(s):
    return re.sub(r'[^A-Za-z0-9._-]', '_', s)


def raw_filename(name, lang, ext):
    base = str(name) if isinstance(name, int) else safe(name)
    if ext and ext != '.bin' and base.lower().endswith(ext):
        base = base[:-len(ext)]
    return '%s_%04x%s' % (base, lang, ext)


def stem_name(name, lang):
    """Decoded-file stem: name without a known file extension, plus language."""
    base = str(name) if isinstance(name, int) else safe(name)
    for x in ('.gif', '.wav', '.zml', '.cur', '.ico'):
        if base.lower().endswith(x):
            base = base[:-len(x)]
    return '%s_%04x' % (base, lang)


def type_label(t):
    return RT_NAMES.get(t, 'TYPE_%d' % t) if isinstance(t, int) else safe(t)


def name_str(n):
    return str(n) if isinstance(n, int) else n


def process_binary(binname, path, palette_reg, gif_all):
    data = path.read_bytes()
    bdir = OUT / binname
    if bdir.exists():
        shutil.rmtree(bdir)
    entries, covered, rsec, secs, dirs, root = walk_resources(data)
    # pefile cross-check
    pe = pefile.PE(str(path), fast_load=True)
    pe.parse_data_directories(directories=[pefile.DIRECTORY_ENTRY['IMAGE_DIRECTORY_ENTRY_RESOURCE']])
    pf = []
    for t in pe.DIRECTORY_ENTRY_RESOURCE.entries:
        for n in t.directory.entries:
            for l in n.directory.entries:
                pf.append((pe.get_offset_from_rva(l.data.struct.OffsetToData), l.data.struct.Size))
    own = sorted((e['file_offset'], e['size']) for e in entries)
    pefile_match = sorted(pf) == own
    if not pefile_match:
        ANOMALIES.append((binname, 'pefile and own walker disagree on the resource list'))
    for e in entries:
        if len(e['path']) != 3:
            ANOMALIES.append((binname, 'resource path depth %d: %r' % (len(e['path']), e['path'])))
        e['type'], e['name'], e['lang'] = e['path'][0], e['path'][1], e['path'][-1]
        e['data'] = data[e['file_offset']:e['file_offset'] + e['size']]
        if e['codepage'] or e['reserved']:
            ANOMALIES.append((binname, 'non-zero codepage/reserved field in %r' % e['path']))
        if not (rsec['roff'] <= e['file_offset'] and e['file_offset'] + e['size'] <= rsec['roff'] + rsec['rsize']):
            ANOMALIES.append((binname, 'resource data outside .rsrc section: %r' % e['path']))
    by_type_id = defaultdict(dict)
    for e in entries:
        by_type_id[e['type']][e['name']] = e

    records = []
    strings_txt = []
    strings_json = []
    dialogs_json = OrderedDict()
    gifs_json = OrderedDict()
    wavs_json = OrderedDict()
    icons_json = OrderedDict()
    bitmaps_json = OrderedDict()
    used_cursor_ids, used_icon_ids = set(), set()
    zml_texts = []
    bu_cache = {}

    for e in entries:
        t, n, lang, b = e['type'], e['name'], e['lang'], e['data']
        tl = type_label(t)
        kind, ext = magic_kind(n, b) if t in (10,) or isinstance(t, str) else ('resource', '.bin')
        rawp = bdir / 'raw' / tl / raw_filename(n, lang, ext)
        if rawp.exists():
            raise RuntimeError('raw file name collision: %s' % rawp)
        write_bytes(rawp, b)
        rec = OrderedDict(binary=binname, type=tl, type_id=t if isinstance(t, int) else None,
                          name=name_str(n), lang='0x%04X' % lang, size=len(b), file_offset='0x%X' % e['file_offset'],
                          rva='0x%X' % e['rva'], sha256=sha256(b), raw_path=rel(rawp), decoded_paths=[],
                          format=kind, description='')
        dec = bdir / 'decoded'
        stem = stem_name(n, lang)
        if t == 6:  # string table block
            strs, trail = decode_string_block(b, n)
            defined = [(i, s) for i, s in strs if s]
            for i, s in strs:
                strings_json.append(OrderedDict(id=i, lang='0x%04X' % lang, block=n, defined=bool(s), string=s))
                if s:
                    strings_txt.append('%d\t0x%04X\t"%s"' % (i, lang, esc(s)))
                    if ZML_TAG.search(s):
                        zml_texts.append(('STRING %d' % i, s))
            rec['decoded_paths'] = [rel(dec / 'strings.txt'), rel(dec / 'strings.json')]
            rec['description'] = 'String block %d (ids %d-%d): %d defined strings%s' % (
                n, (n - 1) * 16, (n - 1) * 16 + 15, len(defined), ', %d trailing bytes' % trail if trail else '')
            if trail:
                ANOMALIES.append((binname, 'STRING block %d has %d trailing bytes' % (n, trail)))
        elif t == 5:  # dialog
            d = parse_dialog(b)
            key = json.dumps(d['font'], sort_keys=True)
            if key not in bu_cache:
                bu_cache[key] = dialog_base_units(d['font'])
            bu, reason = bu_cache[key]
            d['base_units'] = bu
            d['pixel_conversion'] = 'computed' if bu else 'later step: ' + reason
            if bu:
                d['client_px'] = dict(x=muldiv(d['x'], bu['x'], 4), y=muldiv(d['y'], bu['y'], 8),
                                      w=muldiv(d['cx'], bu['x'], 4), h=muldiv(d['cy'], bu['y'], 8))
                for it in d['items']:
                    it['px'] = dict(x=muldiv(it['x'], bu['x'], 4), y=muldiv(it['y'], bu['y'], 8),
                                    w=muldiv(it['cx'], bu['x'], 4), h=muldiv(it['cy'], bu['y'], 8))
            rcp = dec / 'DIALOG' / (stem + '.rc')
            write_text(rcp, dialog_rc(binname, name_str(n), e, d, bu, reason))
            dialogs_json[name_str(n)] = d
            rec['decoded_paths'] = [rel(rcp), rel(dec / 'dialogs.json')]
            f = d['font']
            rec['description'] = '%s "%s", %dx%d DLU, %d controls, font %s' % (
                d['format'], esc(d['caption']) if isinstance(d['caption'], str) else d['caption'], d['cx'], d['cy'],
                d['item_count'], ('%s %dpt' % (f['face'], f['point_size'])) if f else 'system')
            if d['trailing_bytes']:
                ANOMALIES.append((binname, 'DIALOG %s: %d trailing bytes' % (name_str(n), d['trailing_bytes'])))
            for it in d['items']:
                if it['creation_data_hex']:
                    ANOMALIES.append((binname, 'DIALOG %s control %d has creation data' % (name_str(n), it['id'])))
        elif t == 2:  # bitmap
            h = parse_bih(b)
            pal, bits_off = dib_palette(b, h)
            bmp = b'BM' + struct.pack('<IHHI', 14 + len(b), 0, 0, 14 + bits_off) + b
            bmpp = dec / 'BITMAP' / (stem + '.bmp')
            write_bytes(bmpp, bmp)
            im = Image.open(io.BytesIO(bmp))
            im.load()
            pngp = dec / 'BITMAP' / (stem + '.png')
            buf = io.BytesIO()
            im.save(buf, 'PNG')
            write_bytes(pngp, buf.getvalue())
            used = sorted(i for c, i in im.getcolors(1 << 16)) if im.mode == 'P' else None
            info = OrderedDict(header=h, compression_name={0: 'BI_RGB', 1: 'BI_RLE8', 2: 'BI_RLE4', 3: 'BI_BITFIELDS'}
                               .get(h['biCompression'], str(h['biCompression'])), bits_offset_in_resource=bits_off,
                               bits_bytes=len(b) - bits_off, palette_size=len(pal), palette=pal,
                               used_indices=used, used_colors=sorted({pal[i] for i in used}) if used else None,
                               pillow_mode=im.mode, pillow_size=list(im.size), top_down=h['biHeight'] < 0)
            bitmaps_json[name_str(n)] = info
            write_json(dec / 'BITMAP' / (stem + '.json'), info)
            rec['decoded_paths'] = [rel(bmpp), rel(pngp), rel(dec / 'BITMAP' / (stem + '.json'))]
            rec['description'] = 'DIB %dx%d, %d bpp, %s, palette %d entries (%d used)' % (
                h['biWidth'], abs(h['biHeight']), h['biBitCount'], info['compression_name'], len(pal),
                len(used) if used else 0)
            palette_reg.append(dict(source='%s:BITMAP/%s' % (binname, name_str(n)), role='bitmap', colors=pal,
                                    used_colors=info['used_colors'], group=binname + ' bitmap'))
        elif t in (12, 14):  # group cursor / icon
            is_cur = t == 12
            reserved, typ, cnt = struct.unpack_from('<HHH', b, 0)
            gentries = []
            images = []
            for i in range(cnt):
                o = 6 + 14 * i
                if is_cur:
                    gw, gh, planes, bpp, nbytes, nid = struct.unpack_from('<HHHHIH', b, o)
                    ge = OrderedDict(width=gw, height_field=gh, planes=planes, bit_count=bpp, bytes_in_res=nbytes, id=nid)
                    used_cursor_ids.add(nid)
                    img = by_type_id[1].get(nid)
                else:
                    bw, bh, cc, rs, planes, bpp, nbytes, nid = struct.unpack_from('<BBBBHHIH', b, o)
                    ge = OrderedDict(width=bw, height=bh, color_count=cc, reserved=rs, planes=planes, bit_count=bpp,
                                     bytes_in_res=nbytes, id=nid)
                    used_icon_ids.add(nid)
                    img = by_type_id[3].get(nid)
                if img is None:
                    ANOMALIES.append((binname, 'GROUP %s references missing image id %d' % (name_str(n), nid)))
                    continue
                if img['size'] != nbytes:
                    ANOMALIES.append((binname, 'GROUP %s entry %d size %d != image size %d' %
                                      (name_str(n), nid, nbytes, img['size'])))
                gentries.append(ge)
                images.append(img)
            # rebuild file
            hdr = struct.pack('<HHH', 0, 2 if is_cur else 1, len(images))
            dir_bytes = b''
            blobs = b''
            off = 6 + 16 * len(images)
            meta_imgs = []
            for img in images:
                ib = img['data']
                if is_cur:
                    hx, hy = struct.unpack_from('<HH', ib, 0)
                    dib = ib[4:]
                else:
                    hx = hy = None
                    dib = ib
                ih = parse_bih(dib)
                iw, ihh, ibpp = ih['biWidth'], ih['biHeight'] // 2, ih['biBitCount']
                cc = (1 << ibpp) if ibpp < 8 else 0
                if is_cur:
                    dir_bytes += struct.pack('<BBBBHHII', iw & 0xFF, ihh & 0xFF, cc, 0, hx, hy, len(dib), off)
                else:
                    dir_bytes += struct.pack('<BBBBHHII', iw & 0xFF, ihh & 0xFF, cc, 0, ih['biPlanes'], ibpp,
                                             len(dib), off)
                blobs += dib
                off += len(dib)
                im, info = render_icon_dib(dib)
                kindname = 'CURSOR' if is_cur else 'ICON'
                pngp = dec / kindname / ('%s_%dx%dx%d.png' % (stem, iw, ihh, ibpp))
                buf = io.BytesIO()
                im.save(buf, 'PNG')
                write_bytes(pngp, buf.getvalue())
                info['resource_id'] = img['name']
                info['hotspot'] = [hx, hy] if is_cur else None
                info['png'] = rel(pngp)
                meta_imgs.append(info)
                if info['data_size'] < info['mask_bytes_expected_end']:
                    ANOMALIES.append((binname, '%s %d: DIB shorter than XOR+AND size' % (kindname, img['name'])))
            filep = dec / ('CURSOR' if is_cur else 'ICON') / (stem + ('.cur' if is_cur else '.ico'))
            write_bytes(filep, hdr + dir_bytes + blobs)
            chk = Image.open(io.BytesIO(hdr + dir_bytes + blobs))
            chk.load()
            gmeta = OrderedDict(group_type='cursor' if is_cur else 'icon', group_header=dict(reserved=reserved, type=typ,
                                count=cnt), entries=gentries, images=meta_imgs, file=rel(filep),
                                pillow_open_check='%s %s %s' % (chk.format, chk.size, chk.mode))
            icons_json['%s/%s' % (tl, name_str(n))] = gmeta
            jp = dec / ('CURSOR' if is_cur else 'ICON') / (stem + '.json')
            write_json(jp, gmeta)
            rec['decoded_paths'] = [rel(filep)] + [m['png'] for m in meta_imgs] + [rel(jp)]
            if is_cur:
                rec['description'] = 'Cursor group: ' + ', '.join(
                    'id %d %dx%d %d bpp hotspot (%d,%d)' % (m['resource_id'], m['width'], m['height'],
                                                             m['bits_per_pixel'], m['hotspot'][0], m['hotspot'][1])
                    for m in meta_imgs)
            else:
                rec['description'] = 'Icon group: ' + ', '.join(
                    'id %d %dx%d %d bpp' % (m['resource_id'], m['width'], m['height'], m['bits_per_pixel'])
                    for m in meta_imgs)
        elif t in (1, 3):  # cursor/icon image, decoded with its group
            if t == 1:
                hx, hy = struct.unpack_from('<HH', b, 0)
                ih = parse_bih(b[4:])
                rec['description'] = 'Cursor image %dx%d, %d bpp, hotspot (%d,%d); see group' % (
                    ih['biWidth'], ih['biHeight'] // 2, ih['biBitCount'], hx, hy)
            else:
                if b[:8] == b'\x89PNG\r\n\x1a\n':
                    rec['description'] = 'Icon image (PNG)'
                else:
                    ih = parse_bih(b)
                    rec['description'] = 'Icon image %dx%d, %d bpp; see group' % (
                        ih['biWidth'], ih['biHeight'] // 2, ih['biBitCount'])
        elif kind == 'gif':
            g = parse_gif(b)
            gdir = dec / 'GIF' / stem
            # own decoder: indexed frames (frame rectangle only)
            for f in g['frames']:
                pal = f['local_color_table'] or g['global_color_table']
                gif_frame_png(f, pal, gdir / ('frame_%03d_indexed.png' % f['index']))
                idx = f['_indices']
                cnt = Counter(idx)
                f['used_indices'] = sorted(cnt)
                if f['transparent'] and f['transparent_index'] in cnt:
                    f['transparent_pixels'] = cnt[f['transparent_index']]
                else:
                    f['transparent_pixels'] = 0
                bad = [i for i in cnt if i >= len(pal)]
                if bad:
                    g['problems'].append('frame %d uses indices beyond the colour table: %s' % (f['index'], bad))
                f['used_colors'] = sorted({pal[i] for i in cnt if i < len(pal) and not
                                           (f['transparent'] and i == f['transparent_index'])})
                if f['transparent'] and f['transparent_index'] < len(pal):
                    f['transparent_colour'] = pal[f['transparent_index']]
                    f['transparent_colour_also_visible'] = f['transparent_colour'] in f['used_colors']
                else:
                    f['transparent_colour'] = None
                    f['transparent_colour_also_visible'] = False
            m = re.search(r'-(\d+)X(\d+)\.GIF$', name_str(n), re.I)
            if m and (int(m.group(1)), int(m.group(2))) != (g['width'], g['height']):
                g['problems'].append('name says %sx%s, logical screen is %dx%d' %
                                     (m.group(1), m.group(2), g['width'], g['height']))
            # Pillow previews (composited as Pillow shows them)
            im = Image.open(io.BytesIO(b))
            pil = OrderedDict(n_frames=getattr(im, 'n_frames', 1), loop=im.info.get('loop'), durations_ms=[],
                              frame0_mode=im.mode, frame0_index_match=None)
            for i in range(pil['n_frames']):
                im.seek(i)
                pil['durations_ms'].append(im.info.get('duration'))
                if i == 0 and im.mode == 'P' and g['frames']:
                    f0 = g['frames'][0]
                    crop = im.crop((f0['left'], f0['top'], f0['left'] + f0['width'], f0['top'] + f0['height']))
                    pil['frame0_index_match'] = crop.tobytes() == f0['_indices']
                buf = io.BytesIO()
                im.convert('RGBA').save(buf, 'PNG')
                write_bytes(gdir / ('frame_%03d.png' % i), buf.getvalue())
            g['pillow'] = pil
            if pil['n_frames'] != g['frame_count']:
                g['problems'].append('Pillow frame count %d != parser %d' % (pil['n_frames'], g['frame_count']))
            if pil['frame0_index_match'] is False:
                g['problems'].append('frame 0 indices differ between own LZW decoder and Pillow')
            for f in g['frames']:
                del f['_indices']
            for pmsg in g['problems']:
                ANOMALIES.append((binname, 'GIF %s: %s' % (name_str(n), pmsg)))
            gifs_json[name_str(n)] = g
            group = binname + (' banner 468x60' if (g['width'], g['height']) == (468, 60) else ' GIF')
            gif_all.append((binname, name_str(n), g, group))
            if g['global_color_table']:
                palette_reg.append(dict(source='%s:%s:global' % (binname, name_str(n)), role='gif_global',
                                        colors=g['global_color_table'], group=group,
                                        used_colors=sorted({c for f in g['frames'] if not f['local_color_table']
                                                            for c in f['used_colors']})))
            for f in g['frames']:
                if f['local_color_table']:
                    palette_reg.append(dict(source='%s:%s:frame%d' % (binname, name_str(n), f['index']),
                                            role='gif_local', colors=f['local_color_table'], group=group,
                                            used_colors=f['used_colors']))
            rec['decoded_paths'] = [rel(gdir) + '/', rel(dec / 'gifs.json')]
            tr = sorted({f['transparent_index'] for f in g['frames'] if f['transparent']})
            delays = sorted({f['delay_cs'] for f in g['frames']})
            rec['description'] = '%s %dx%d, %d frame%s%s, GCT %d%s%s%s%s' % (
                g['signature'], g['width'], g['height'], g['frame_count'], '' if g['frame_count'] == 1 else 's',
                (', delay %s cs' % '/'.join(map(str, delays))) if g['frame_count'] > 1 else '',
                g['global_color_table_size'],
                ', LCT' if any(f['local_color_table_size'] for f in g['frames']) else '',
                (', transparent idx %s' % '/'.join(map(str, tr))) if tr else '',
                (', loop %s' % g['loop_count']) if g['loop_count'] is not None else
                (', no loop extension' if g['frame_count'] > 1 else ''),
                ', interlaced' if any(f['interlaced'] for f in g['frames']) else '')
        elif kind == 'wav':
            w = parse_wav(b)
            wavs_json[name_str(n)] = w
            rec['decoded_paths'] = [rel(dec / 'wavs.json')]
            f = w['fmt']
            rec['description'] = 'WAV %s %d Hz %d-bit %s, %d data bytes, %.3f s%s' % (
                f['format_name'], f['sample_rate'], f['bits_per_sample'],
                {1: 'mono', 2: 'stereo'}.get(f['channels'], '%d ch' % f['channels']), w['data_length'],
                w['duration_s'], (', chunks: ' + ' '.join(c.strip() for c in w['extra_chunks'])) if w['extra_chunks'] else '')
            if not w['riff_size_matches']:
                ANOMALIES.append((binname, 'WAV %s: RIFF size field %d + 8 != resource size %d' %
                                  (name_str(n), w['riff_size_field'], len(b))))
        elif kind == 'zml':
            text = b.decode('cp1252')
            zml_texts.append((name_str(n), text))
            tp = dec / 'RCDATA' / (stem + '.utf8.txt')
            write_text(tp, text)
            rec['decoded_paths'] = [rel(tp), rel(dec / 'zml_tags.txt')]
            nonascii = sum(1 for c in b if c >= 0x80)
            rec['description'] = 'ZapSpot markup text, cp1252, %d lines, %d non-ASCII bytes, starts/ends with %r/%r' % (
                text.count('\n'), nonascii, text[:1], text[-1:])
        elif kind == 'text':
            text = b.decode('cp1252')
            tp = dec / 'RCDATA' / (stem + '.utf8.txt')
            write_text(tp, text)
            rec['decoded_paths'] = [rel(tp)]
            rec['description'] = 'Plain text (ASCII/cp1252), %d lines, NUL bytes: %d, first line %r' % (
                text.count('\n'), b.count(0), text.splitlines()[0][:60] if text else '')
        else:
            rec['description'] = 'Unidentified format (magic %s)' % b[:8].hex()
            ANOMALIES.append((binname, 'unidentified resource %s/%s' % (tl, name_str(n))))
        records.append(rec)

    # cursor/icon images not referenced by any group
    for e_id in by_type_id.get(1, {}):
        if e_id not in used_cursor_ids:
            ANOMALIES.append((binname, 'RT_CURSOR %s not referenced by any group' % e_id))
    for e_id in by_type_id.get(3, {}):
        if e_id not in used_icon_ids:
            ANOMALIES.append((binname, 'RT_ICON %s not referenced by any group' % e_id))

    dec = bdir / 'decoded'
    if strings_json:
        hdr = ['# %s string tables: id<TAB>language<TAB>"string"' % binname,
               '# Escapes: \\n \\r \\t \\\\ \\" \\xHH. Only defined (non-empty) ids are listed; '
               'strings.json lists all 16 slots per block.',
               '# %d blocks, %d defined strings' % (len({s['block'] for s in strings_json}),
                                                     sum(1 for s in strings_json if s['defined']))]
        write_text(dec / 'strings.txt', '\n'.join(hdr + strings_txt) + '\n')
        write_json(dec / 'strings.json', strings_json)
    if dialogs_json:
        write_json(dec / 'dialogs.json', dialogs_json)
    if gifs_json:
        write_json(dec / 'gifs.json', gifs_json)
    if wavs_json:
        write_json(dec / 'wavs.json', wavs_json)
    if zml_texts:
        write_zml_tags(binname, dec, zml_texts)

    # coverage and non-resource data
    gaps = uncovered_nonzero(data, covered, rsec['roff'], rsec['roff'] + rsec['rsize'])
    for gp in gaps:
        ANOMALIES.append((binname, '.rsrc bytes not referenced by the resource tree and not zero: offset 0x%X, '
                                   '%d bytes, starts %s' % (gp['offset'], gp['length'], gp['sample'][:32])))
    extra = nonresource(binname, data, secs, dirs, bdir)
    meta = OrderedDict(binary=binname, path=path.relative_to(ROOT).as_posix(), size=len(data), sha256=sha256(data),
                       resource_count=len(entries), pefile_count=len(pf), pefile_match=pefile_match,
                       rsrc_section=dict(name=rsec['name'], file_offset='0x%X' % rsec['roff'], raw_size=rsec['rsize'],
                                         virtual_size=rsec['vsize']),
                       resource_directory=dict(characteristics=root['characteristics'],
                                               timestamp=root['timestamp'], version=root['version']),
                       unreferenced_nonzero_rsrc_ranges=gaps, nonresource_data=extra,
                       type_counts=dict(Counter(r['type'] for r in records)))
    return records, meta


def write_zml_tags(binname, dec, texts):
    total = Counter()
    per = OrderedDict()
    for src, t in texts:
        c = zml_tags(t)
        per[src] = c
        total.update(c)
    folded = Counter()
    for k, v in total.items():
        folded[k.upper()] += v
    L = ['# %s: distinct ZML markup tags (regex <[^<>\\r\\n]{0,64}>), exact spelling, with counts' % binname,
         '# Sources: ' + ', '.join(per)]
    if binname == 'Moeboid.gam':
        L = ['# Moeboid.gam HELP.ZML: distinct markup tags, exact spelling, with counts']
        c = per.get('HELP.ZML', Counter())
        L.append('# %d tags, %d distinct' % (sum(c.values()), len(c)))
        for k, v in sorted(c.items(), key=lambda kv: (-kv[1], kv[0])):
            L.append('%6d  %s' % (v, k))
        f2 = Counter()
        for k, v in c.items():
            f2[k.upper()] += v
        L.append('')
        L.append('# Case-folded (upper case) counts')
        for k, v in sorted(f2.items(), key=lambda kv: (-kv[1], kv[0])):
            L.append('%6d  %s' % (v, k))
        others = [s for s in per if s != 'HELP.ZML']
        if others:
            L.append('')
            L.append('# Tags in string tables of this binary')
            oc = Counter()
            for s in others:
                oc.update(per[s])
            for k, v in sorted(oc.items(), key=lambda kv: (-kv[1], kv[0])):
                L.append('%6d  %s' % (v, k))
    else:
        L.append('# %d tags, %d distinct' % (sum(total.values()), len(total)))
        for k, v in sorted(total.items(), key=lambda kv: (-kv[1], kv[0])):
            L.append('%6d  %s' % (v, k))
        L.append('')
        L.append('# Case-folded (upper case) counts')
        for k, v in sorted(folded.items(), key=lambda kv: (-kv[1], kv[0])):
            L.append('%6d  %s' % (v, k))
    write_text(dec / 'zml_tags.txt', '\n'.join(L) + '\n')


def nonresource(binname, data, secs, dirs, bdir):
    """Record data outside the sections (overlay): debug record, Authenticode signature, payload."""
    out = []
    end_sec = max(s['roff'] + s['rsize'] for s in secs)
    sec_rva, sec_size = dirs[4] if len(dirs) > 4 else (0, 0)
    if sec_size:
        blob = data[sec_rva:sec_rva + sec_size]
        length, rev, ctype = struct.unpack_from('<IHH', blob, 0)
        p = bdir / 'raw' / '_NONRESOURCE' / ('authenticode_0x%X.p7b' % sec_rva)
        write_bytes(p, blob[8:length])
        subjects = []
        try:
            r = subprocess.run(['openssl', 'pkcs7', '-inform', 'DER', '-print_certs', '-noout'],
                               input=blob[8:length], capture_output=True, timeout=30)
            subjects = [ln.decode('latin-1').split('=', 1)[1] for ln in r.stdout.splitlines()
                        if ln.startswith(b'subject=')]
        except (OSError, subprocess.SubprocessError):
            subjects = ['(openssl not available)']
        out.append(dict(kind='Authenticode WIN_CERTIFICATE (security directory)', file_offset='0x%X' % sec_rva,
                        size=sec_size, revision='0x%X' % rev, certificate_type=ctype, sha256=sha256(blob),
                        raw_path=rel(p), certificate_subjects=subjects,
                        note='PKCS#7 SignedData without the 8-byte WIN_CERTIFICATE header'))
    if end_sec < len(data):
        ov = data[end_sec:]
        desc = 'overlay after last section'
        if ov[:4] == b'NB10':
            desc = 'CodeView NB10 debug record, PDB path "%s"' % ov[16:ov.index(b'\0', 16)].decode('latin-1')
            dlen = ov.index(b'\0', 16) + 1
            p = bdir / 'raw' / '_NONRESOURCE' / ('codeview_nb10_0x%X.bin' % end_sec)
            write_bytes(p, ov[:dlen])
            out.append(dict(kind=desc, file_offset='0x%X' % end_sec, size=dlen, sha256=sha256(ov[:dlen]),
                            raw_path=rel(p)))
        elif sec_size and sec_rva > end_sec:
            out.append(dict(kind='overlay before the signature (not a resource; see the extraction workstream)',
                            file_offset='0x%X' % end_sec, size=sec_rva - end_sec,
                            sha256=sha256(data[end_sec:sec_rva]), magic=data[end_sec:end_sec + 8].hex()))
        covered_to = sec_rva + sec_size if sec_size else end_sec
        if covered_to < len(data) and not (ov[:4] == b'NB10'):
            out.append(dict(kind='bytes after signature', file_offset='0x%X' % covered_to,
                            size=len(data) - covered_to))
    return out


def palette_analysis(palette_reg, gif_all):
    pals = OrderedDict()
    for p in palette_reg:
        key = tuple(p['colors'])
        if key not in pals:
            pals[key] = dict(id='PAL%02d' % (len(pals) + 1), size=len(key), colors=list(key), used_by=[])
        pals[key]['used_by'].append(p['source'])
        p['palette_id'] = pals[key]['id']
    groups = OrderedDict()
    for p in palette_reg:
        g = groups.setdefault(p['group'], dict(sources=0, ordered_palettes=set(), color_sets=set(),
                                               table_colors=set(), used_colors=set()))
        g['sources'] += 1
        g['ordered_palettes'].add(p['palette_id'])
        g['color_sets'].add(frozenset(p['colors']))
        g['table_colors'].update(p['colors'])
        g['used_colors'].update(p['used_colors'] or [])
    websafe = {hexcol(r, g, b) for r in range(0, 256, 51) for g in range(0, 256, 51) for b in range(0, 256, 51)}
    static_order = ['#000000', '#800000', '#008000', '#808000', '#000080', '#800080', '#008080', '#c0c0c0',
                    '#c0dcc0', '#a6caf0', '#fffbf0', '#a0a0a4', '#808080', '#ff0000', '#00ff00', '#ffff00',
                    '#0000ff', '#ff00ff', '#00ffff', '#ffffff']
    static20 = set(static_order)
    splash = next((p for p in palette_reg if p['role'] == 'bitmap'), None)
    splash_set = set(splash['colors']) if splash else set()
    splash_info = None
    if splash:
        sc = splash['colors']
        splash_info = OrderedDict(
            source=splash['source'], palette=splash['palette_id'], size=len(sc), distinct=len(set(sc)),
            static20_at_0_9=sc[:10] == static_order[:10],
            static20_at_246_255=len(sc) == 256 and sc[246:] == static_order[10:],
            websafe_entries=sum(1 for c in sc if c in websafe),
            missing_websafe=sorted(websafe - set(sc)),
            other_entries=[[i, c] for i, c in enumerate(sc) if c not in websafe and c not in static20],
            same_palette_used_by=[p['source'] for p in palette_reg if p['palette_id'] == splash['palette_id']])
    summary = OrderedDict()
    for gname, g in groups.items():
        used = g['used_colors']
        summary[gname] = OrderedDict(
            colour_tables=g['sources'], distinct_ordered_palettes=len(g['ordered_palettes']),
            distinct_colour_sets=len(g['color_sets']), table_colour_union=len(g['table_colors']),
            used_colour_union=len(used), used_not_websafe=len(used - websafe),
            used_not_websafe_or_static20=len(used - websafe - static20),
            used_not_in_splash_palette=len(used - splash_set) if splash else None,
            used_colours=sorted(used))
    all_used = set().union(*[g['used_colors'] for g in groups.values()]) if groups else set()
    game_used = set().union(*[g['used_colors'] for n, g in groups.items() if n.startswith('Moeboid.gam')])
    eng_used = set().union(*[g['used_colors'] for n, g in groups.items() if n.startswith('ZapSpot.exe') and
                             'banner' not in n])
    transp = []
    for binname, name, g, grp in gif_all:
        t = sorted({(f['transparent_index'], (f['local_color_table'] or g['global_color_table'])[f['transparent_index']]
                     if f['transparent_index'] < len(f['local_color_table'] or g['global_color_table']) else None)
                    for f in g['frames'] if f['transparent']})
        transp.append(dict(file='%s:%s' % (binname, name), frames=g['frame_count'],
                           transparent_frames=sum(1 for f in g['frames'] if f['transparent']),
                           transparent_index_and_colour=t,
                           transparent_pixels=sum(f.get('transparent_pixels', 0) for f in g['frames']),
                           transparent_colour_also_visible=any(f['transparent_colour_also_visible']
                                                               for f in g['frames'])))
    files = OrderedDict()
    for p in palette_reg:
        files.setdefault(p['source'].rsplit(':', 1)[0] if p['role'] != 'bitmap' else p['source'], []).append(
            dict(table=p['source'].rsplit(':', 1)[-1] if p['role'] != 'bitmap' else 'bitmap', palette=p['palette_id'],
                 size=len(p['colors']), used_colors=p['used_colors']))
    return OrderedDict(
        notes=['Palettes are compared as exact ordered colour lists (padding entries included).',
               '"used" colours are colours of indices that pixels reference, excluding the transparent index.',
               'websafe = 6x6x6 cube (0x00,0x33,...,0xff); static20 = Windows 20 reserved system colours.'],
        palettes=list(pals.values()), per_file=files, group_summary=summary, splash_palette=splash_info,
        union_used_all=len(all_used), union_used_game_plus_engine=len(game_used | eng_used),
        game_and_engine_used_colours=sorted(game_used | eng_used),
        transparency=transp)


def write_index(all_records, metas, pal):
    write_json(OUT / 'index.json', OrderedDict(binaries=metas, resources=all_records,
                                                anomalies=[dict(binary=b, text=t) for b, t in ANOMALIES]))
    write_json(OUT / 'palettes.json', pal)


def main():
    palette_reg, gif_all = [], []
    all_records, metas = [], []
    for binname, path in BINARIES:
        recs, meta = process_binary(binname, path, palette_reg, gif_all)
        all_records += recs
        metas.append(meta)
    pal = palette_analysis(palette_reg, gif_all)
    # duplicates across resources
    byhash = defaultdict(list)
    for r in all_records:
        byhash[r['sha256']].append('%s:%s/%s' % (r['binary'], r['type'], r['name']))
    dups = [v for v in byhash.values() if len(v) > 1]
    for d in metas:
        d['duplicates'] = [v for v in dups if any(x.startswith(d['binary'] + ':') for x in v)]
    write_index(all_records, metas, pal)
    verify(all_records, metas)
    write_index_md(all_records, metas, pal, dups)
    print('resources:', len(all_records))
    for m in metas:
        print(' ', m['binary'], m['resource_count'], m['type_counts'], 'pefile match', m['pefile_match'])
    print('duplicates:', dups)
    print('anomalies:')
    for b, t in ANOMALIES:
        print('  [%s] %s' % (b, t))


def md(s):
    return str(s).replace('|', '\\|').replace('\n', ' ')


def write_index_md(all_records, metas, pal, dups):
    L = []
    A = L.append
    A('# Moeboid resource assets')
    A('')
    A('The script `tools/extract_resources.py` writes this file. Do not edit it by hand. To rebuild all outputs, '
      'run from the project root:')
    A('')
    A('    source tools/env.sh')
    A('    python -I assets/tools/extract_resources.py')
    A('')
    A('Paths are relative to `assets/`. `index.json` holds the same data in machine-readable form. '
      '`palettes.json` holds every colour table.')
    A('')
    A('Labels: **verified** = read from the bytes at the given file or offset. **inferred** = conclusion, not '
      'proven by the bytes alone.')
    A('')
    # totals
    A('## Totals and verification')
    A('')
    A('| Binary | File SHA-256 | Resources | Counts per type | Raw files | Own walker | pefile | Hash mismatches |')
    A('|---|---|---|---|---|---|---|---|')
    for m in metas:
        v = m['verification']
        A('| %s | `%s` | %d | %s | %d | %d | %d | %d |' % (
            m['binary'], m['sha256'], m['resource_count'],
            ', '.join('%s %d' % kv for kv in m['type_counts'].items()), v['raw_files'], v['walker_count'],
            v['pefile_count'], v['hash_mismatches']))
    A('')
    total = len(all_records)
    A('- Total: %d resources. Every resource has one raw file and one index row (verified: count check).' % total)
    A('- The script re-reads each raw file and compares its SHA-256 with the bytes at the recorded file offset in '
      'the binary (verified: 0 mismatches).')
    A('- The script walks the resource tree itself and compares the (offset, size) list with pefile (verified: equal).')
    present = sorted({r['type'] for r in all_records})
    absent = [t for t in ('VERSION', 'MENU', 'ACCELERATOR', 'FONT', 'FONTDIR', 'MANIFEST', 'MESSAGETABLE', 'HTML')
              if t not in present]
    A('- Resource types present: %s. Types absent in all three binaries: %s (verified).' %
      (', '.join(present), ', '.join(absent)))
    A('- All resources use language 0x0409 and code page field 0 (verified).' if all(
        r['lang'] == '0x0409' for r in all_records) else '- Languages: %s.' % sorted({r['lang'] for r in all_records}))
    A('- No resource has the same bytes as another resource.' if not dups else
      '- Resources with identical bytes: %s.' % '; '.join(', '.join(d) for d in dups))
    A('')
    A('## Layout')
    A('')
    A('- `<binary>/raw/<TYPE>/<name>_<lang>.<ext>`: resource bytes as stored in the binary. The file name drops a '
      '`.GIF`, `.WAV` or `.ZML` suffix of the resource name. `index.json` keeps the exact name.')
    A('- `<binary>/raw/_NONRESOURCE/`: data outside the resource tree (signature, debug record). These files are not '
      'resources and are not in the resource counts.')
    A('- `<binary>/decoded/strings.txt`, `strings.json`: string tables. The JSON lists all 16 slots of each block.')
    A('- `<binary>/decoded/DIALOG/*.rc`, `dialogs.json`: dialog templates in RC syntax, with decoded styles and '
      'pixel rectangles.')
    A('- `<binary>/decoded/gifs.json`: GIF metadata. `decoded/GIF/<stem>/frame_NNN.png`: Pillow composite of '
      'frame NNN (RGBA, full logical screen). `frame_NNN_indexed.png`: frame rectangle only, decoded by the '
      'script\'s own LZW decoder, exact colour table, tRNS for the transparent index.')
    A('- `<binary>/decoded/wavs.json`: WAV chunk list and format.')
    A('- `<binary>/decoded/BITMAP/`: `.bmp` (BITMAPFILEHEADER added), `.png`, `.json` (header, palette).')
    A('- `<binary>/decoded/CURSOR/`, `ICON/`: rebuilt `.cur`/`.ico`, one `.png` per image, `.json` with hotspots. '
      'PNG previews show AND-mask pixels with a black XOR value as transparent and screen-invert pixels as magenta.')
    A('- `<binary>/decoded/RCDATA/*.utf8.txt`: text resources converted from cp1252 to UTF-8.')
    A('- `Moeboid.gam/decoded/zml_tags.txt`: markup tags in HELP.ZML. `ZapSpot.exe/decoded/zml_tags.txt`: '
      'markup tags in the ZapSpot string tables.')
    A('')
    # palette summary
    A('## Palette summary')
    A('')
    gs = pal['group_summary']
    A('| Group | Colour tables | Distinct ordered palettes | Distinct colour sets | Table colour union | '
      'Used colour union | Used, not web-safe | Used, not in IMG-SPLASH palette |')
    A('|---|---|---|---|---|---|---|---|')
    for gname, s in gs.items():
        A('| %s | %d | %d | %d | %d | %d | %d | %s |' % (
            gname, s['colour_tables'], s['distinct_ordered_palettes'], s['distinct_colour_sets'],
            s['table_colour_union'], s['used_colour_union'], s['used_not_websafe'], s['used_not_in_splash_palette']))
    A('')
    gifs = {}
    for b in ('Moeboid.gam', 'ZapSpot.exe'):
        p = OUT / b / 'decoded' / 'gifs.json'
        if p.exists():
            gifs[b] = json.loads(p.read_text())
    n_lct = sum(1 for b in gifs.values() for g in b.values() for f in g['frames'] if f['local_color_table_size'])
    game = gifs.get('Moeboid.gam', {})
    gsum = gs.get('Moeboid.gam GIF')
    A('Findings (verified from the colour tables and the decoded pixel indices):')
    A('')
    A('- No GIF has a local colour table (%d local tables in %d GIFs). Each GIF uses its global table only.' %
      (n_lct, sum(len(b) for b in gifs.values())))
    if gsum:
        shared = [p for p in pal['palettes'] if sum(1 for u in p['used_by'] if u.startswith('Moeboid.gam')) > 1]
        A('- Moeboid.gam: the %d GIFs do **not** share one palette. They have %d distinct ordered palettes '
          '(%d distinct colour sets). LEFT/RIGHT sprite pairs of one size share a table; %s.' % (
              gsum['colour_tables'], gsum['distinct_ordered_palettes'], gsum['distinct_colour_sets'],
              '; '.join('%s is shared by %d files' % (p['id'], len(p['used_by'])) for p in shared
                        if len(p['used_by']) > 2) or 'no table is shared by more than two files'))
        A('- Moeboid.gam: the pixels use %d distinct colours in total. %d of them are outside the 216-colour '
          'web-safe cube (levels 00, 33, 66, 99, cc, ff). %d of them are outside the IMG-SPLASH palette.' %
          (gsum['used_colour_union'], gsum['used_not_websafe'], gsum['used_not_in_splash_palette']))
    sp = pal.get('splash_palette')
    sp_colors = next((p['colors'] for p in pal['palettes'] if sp and p['id'] == sp['palette']), [])
    if sp:
        A('- IMG-SPLASH (ZapSpot.exe BITMAP) has a %d-entry palette (%s, %d distinct colours). %s. It holds %d of '
          'the 216 web-safe colours (missing: %s). Other entries: %s. The same %d-entry table occurs in: %s.' % (
              sp['size'], sp['palette'], sp['distinct'],
              'Entries 0-9 and 246-255 hold the 20 Windows static colours in system-palette order'
              if sp['static20_at_0_9'] and sp['static20_at_246_255'] else
              'Static colours at 0-9: %s; at 246-255: %s' % (sp['static20_at_0_9'], sp['static20_at_246_255']),
              sp['websafe_entries'], ', '.join(sp['missing_websafe']) or 'none',
              ', '.join('%d=%s' % (i, c) for i, c in sp['other_entries']), sp['size'],
              ', '.join(sp['same_palette_used_by'])))
    for gname in gs:
        if gname.startswith('ZapSpot.exe') and gname != 'ZapSpot.exe bitmap':
            s = gs[gname]
            A('- %s: %d tables, %d distinct, %d used colours, %d not web-safe, %d not in the IMG-SPLASH palette.' %
              (gname, s['colour_tables'], s['distinct_ordered_palettes'], s['used_colour_union'],
               s['used_not_websafe'], s['used_not_in_splash_palette']))
    A('- Union of used colours over all GIFs and IMG-SPLASH: %d. Game plus engine (no 468x60 banners): %d.' %
      (pal['union_used_all'], pal['union_used_game_plus_engine']))
    # transparency
    tr_game = [t for t in pal['transparency'] if t['file'].startswith('Moeboid.gam')]
    with_tr = [t for t in tr_game if t['transparent_frames']]
    cols = Counter(c for t in with_tr for _, c in t['transparent_index_and_colour'])
    idxs = sorted({i for t in with_tr for i, _ in t['transparent_index_and_colour']})
    A('- Transparency, Moeboid.gam: %d of %d GIFs set the GCE transparency flag on every frame. The transparent '
      'index differs per file (%s). Colour of the transparent entry: %s.' % (
          len(with_tr), len(tr_game), ', '.join(map(str, idxs)),
          ', '.join('%s in %d file%s' % (c, n, '' if n == 1 else 's') for c, n in cols.most_common())))
    odd = [t['file'].split(':', 1)[1] for t in with_tr if any(c != cols.most_common(1)[0][0]
                                                               for _, c in t['transparent_index_and_colour'])]
    if odd:
        A('  - Files whose transparent entry has a different colour: %s.' % ', '.join(odd))
    coll = [t['file'] for t in pal['transparency'] if t['transparent_colour_also_visible']]
    A('  - Files where the colour of the transparent entry also occurs on a visible pixel (a colour-key blit '
      'by colour value would make those pixels transparent): %s. In all other files with transparency, the '
      'transparent colour does not occur on a visible pixel.' % (', '.join(coll) if coll else 'none'))
    A('  - Files without transparency in Moeboid.gam: %s.' %
      ', '.join(t['file'].split(':', 1)[1] for t in tr_game if not t['transparent_frames']))
    if gsum and sp:
        miss = [c for c in gsum['used_colours'] if c not in set(sp_colors)]
        users = sorted({f.split(':', 1)[1] for f, tabs in pal['per_file'].items() if f.startswith('Moeboid.gam')
                        for t in tabs if set(t['used_colors'] or []) & set(miss)})
        A('- Game colours outside the IMG-SPLASH palette: %s, used by %s.' % (
            ', '.join(miss) or 'none', ', '.join(users) or 'no file'))
        A('- Inferred: the game art uses only web-safe colours, and the IMG-SPLASH palette holds %d of the %d. '
          'In an 8-bit display mode with that palette, the engine or GDI would remap the other %d colours. '
          'The bytes do not show the display mode. The engine code workstream must confirm the display mode and '
          'how the engine maps GIF colours and transparency.' % (
              gsum['used_colour_union'] - len(miss), gsum['used_colour_union'], len(miss)))
    A('')
    # dialogs
    A('## Dialog fonts and pixel conversion')
    A('')
    dj = json.loads((OUT / 'ZapSpot.exe' / 'decoded' / 'dialogs.json').read_text())
    fonts = Counter((('"%s" %d pt (%s)' % (d['font']['face'], d['font']['point_size'], d['format'])) +
                     ((', weight %d, italic %d, charset %d' % (d['font']['weight'], d['font']['italic'],
                                                                d['font']['charset']))
                      if d['format'] == 'DLGTEMPLATEEX' else ''))
                    if d['font'] else 'system font' for d in dj.values())
    A('- Fonts (verified, DS_SETFONT data): %s. DLGTEMPLATE does not store weight, italic or charset; '
      'DLGTEMPLATEEX stores charset 1 = DEFAULT_CHARSET.' % '; '.join('%s: %d dialog%s' % (k, v, '' if v == 1 else 's') for k, v in fonts.items()))
    bu = next((d['base_units'] for d in dj.values() if d['base_units']), None)
    if bu:
        A('- Dialog base units: %d x %d px. Source: `fonts/sserife.fon` (sha256 `%s`), %dpt strike: tmHeight %d, '
          'internal leading %d, charset %d, extent of "a..zA..Z" = %d px. Formula (GdiGetCharDimensions): '
          'x = (extent / 26 + 1) / 2, y = tmHeight. Pixel values: x and cx times %d / 4, y and cy times %d / 8, '
          'with MulDiv rounding.' % (bu['x'], bu['y'], bu['font_file_sha256'], bu['strike']['points'],
                                     bu['strike']['pix_height'], bu['strike']['internal_leading'],
                                     bu['strike']['charset'], bu['alphabet_extent_px'], bu['x'], bu['y']))
        A('- Assumptions (inferred): 96 DPI ("Small Fonts"); Windows XP maps "MS Sans Serif" to the bitmap font '
          'sserife.fon. The pixel sizes are client-area sizes. The window frame and caption size depend on the '
          'theme metrics; compute them in a later step.')
    A('')
    A('| Dialog | Format | Caption | DLU (cx x cy) | Client px (w x h) | Controls | Style |')
    A('|---|---|---|---|---|---|---|')
    for name, d in dj.items():
        cp = d.get('client_px')
        A('| %s | %s | %s | %d x %d | %s | %d | %s |' % (
            name, d['format'], md(d['caption']), d['cx'], d['cy'], '%d x %d' % (cp['w'], cp['h']) if cp else
            'later step', d['item_count'], ' '.join(d['style_names'])))
    A('')
    # WAVs
    A('## WAV formats')
    A('')
    A('| Binary | Name | Format | Rate (Hz) | Bits | Channels | Block align | Data bytes | Duration (s) | '
      'Extra chunks |')
    A('|---|---|---|---|---|---|---|---|---|---|')
    wav_notes = []
    for b in ('Moeboid.gam', 'ZapSpot.exe'):
        p = OUT / b / 'decoded' / 'wavs.json'
        if not p.exists():
            continue
        for name, w in json.loads(p.read_text()).items():
            f = w['fmt']
            A('| %s | %s | %s | %d | %d | %d | %d | %d | %.3f | %s |' % (
                b, name, f['format_name'], f['sample_rate'], f['bits_per_sample'], f['channels'], f['block_align'],
                w['data_length'], w['duration_s'], ', '.join('`%s`' % c for c in w['extra_chunks']) or '-'))
            for n_ in w['notes']:
                wav_notes.append('%s %s: %s' % (b, name, n_))
            for c in w['chunks']:
                if c['id'] == 'LIST':
                    wav_notes.append('%s %s: LIST/%s labels %s' % (b, name, c['list_type'], ', '.join(
                        repr(s['value'][4:]) for s in c['subchunks'])))
                if c['id'] == 'PAD ':
                    wav_notes.append('%s %s: `PAD ` chunk, %d bytes, all zero: %s' % (
                        b, name, c['size'], set(c['body_hex_head']) <= {'0'}))
    A('')
    for n_ in wav_notes:
        A('- %s.' % n_)
    A('')
    # anomalies
    A('## Anomalies and notes')
    A('')
    rc = Counter(r['format'] for r in all_records if r['binary'] == 'Moeboid.gam')
    A('- Task brief count differs from the binary: the brief states 54 GIFs and 12 WAVs in Moeboid.gam. The resource '
      'tree holds %d GIFs, %d WAVs, %d ZML, and %d STRING blocks (verified).' % (
          rc['gif'], rc['wav'], rc['zml'], sum(1 for r in all_records if r['binary'] == 'Moeboid.gam'
                                                and r['type'] == 'STRING')))
    for b, t in ANOMALIES:
        A('- %s: %s (verified).' % (b, md(t)))
    for b, bj in gifs.items():
        for name, g in bj.items():
            other = [e['identifier'] + e['auth_code'] for e in g['extensions']
                     if e['type'] == 'application' and e['identifier'] != 'NETSCAPE']
            if other:
                A('- %s %s: application extension %s (verified).' % (b, name, ', '.join(other)))
            if g['frame_count'] > 1 and g['loop_count'] is None:
                A('- %s %s: %d frames and no NETSCAPE loop extension. A browser plays it once (verified: no '
                  'extension).' % (b, name, g['frame_count']))
            if any(f['interlaced'] for f in g['frames']):
                A('- %s %s: interlaced (verified).' % (b, name))
            if any(e['type'] == 'comment' for e in g['extensions']):
                A('- %s %s: comment extension %r (verified).' % (b, name, [e['text'] for e in g['extensions']
                                                                          if e['type'] == 'comment']))
    for r in all_records:
        if r['format'] in ('zml', 'text'):
            raw = (OUT / r['raw_path']).read_bytes()
            nul = [i for i, c in enumerate(raw) if c == 0]
            A('- %s %s: %d bytes, first byte 0x%02X, last byte 0x%02X, NUL bytes at offsets %s (verified).' % (
                r['binary'], r['name'], len(raw), raw[0], raw[-1], ', '.join(map(str, nul)) or 'none'))
    for m in metas:
        rd = m['resource_directory']
        if rd['timestamp'] == 0:
            A('- %s: resource directory TimeDateStamp is 0 (verified).' % m['binary'])
    sj = {}
    for b in ('Moeboid.gam', 'ZapSpot.exe'):
        p = OUT / b / 'decoded' / 'strings.json'
        if p.exists():
            sj[b] = {s['id']: s['string'] for s in json.loads(p.read_text()) if s['defined']}
    vers = []
    for b, s in sj.items():
        for i, v in s.items():
            if re.fullmatch(r'\d+\.\d+\.\d+\.\d+', v):
                vers.append('%s string %d = "%s"' % (b, i, v))
    if vers:
        A('- No RT_VERSION resource exists. Version-like strings: %s (verified; meaning inferred).' % '; '.join(vers))
    A('')
    A('## Non-resource data')
    A('')
    for m in metas:
        for x in m['nonresource_data']:
            A('- %s, file offset %s, %d bytes: %s.%s%s' % (
                m['binary'], x['file_offset'], x['size'], x['kind'],
                (' Raw copy: `%s`.' % x['raw_path']) if x.get('raw_path') else '',
                (' Certificate subjects: %s.' % ' / '.join('"%s"' % s for s in x['certificate_subjects']))
                if x.get('certificate_subjects') else ''))
        if m['unreferenced_nonzero_rsrc_ranges']:
            A('- %s: %d non-zero byte ranges in .rsrc that the resource tree does not reference.' % (
                m['binary'], len(m['unreferenced_nonzero_rsrc_ranges'])))
        else:
            A('- %s: every non-zero byte in the .rsrc section belongs to the resource tree (verified).' % m['binary'])
    A('')
    # per-binary tables
    for m in metas:
        A('## %s' % m['binary'])
        A('')
        A('Source: `%s`, %d bytes. .rsrc section at file offset %s, raw size %d.' % (
            m['path'], m['size'], m['rsrc_section']['file_offset'], m['rsrc_section']['raw_size']))
        A('')
        A('| Type | Name/ID | Lang | Size | SHA-256 | Raw path | Decoded path | Description |')
        A('|---|---|---|---|---|---|---|---|')
        for r in all_records:
            if r['binary'] != m['binary']:
                continue
            A('| %s | %s | %s | %d | `%s` | `%s` | %s | %s |' % (
                r['type'], md(r['name']), r['lang'][2:], r['size'], r['sha256'], r['raw_path'],
                '<br>'.join('`%s`' % p for p in r['decoded_paths'][:3]) +
                (' (+%d)' % (len(r['decoded_paths']) - 3) if len(r['decoded_paths']) > 3 else '') or '-',
                md(r['description'])))
        A('')
    write_text(OUT / 'INDEX.md', '\n'.join(L) + '\n')


def verify(all_records, metas):
    """Re-read raw files and compare with the bytes in the binaries; count check."""
    fails = 0
    for binname, path in BINARIES:
        data = path.read_bytes()
        recs = [r for r in all_records if r['binary'] == binname]
        for r in recs:
            off = int(r['file_offset'], 16)
            raw = (OUT / r['raw_path']).read_bytes()
            if sha256(raw) != sha256(data[off:off + r['size']]) or sha256(raw) != r['sha256']:
                fails += 1
                print('HASH MISMATCH', r['raw_path'])
        on_disk = [p for p in (OUT / binname / 'raw').rglob('*') if p.is_file() and '_NONRESOURCE' not in p.parts]
        m = next(m for m in metas if m['binary'] == binname)
        ok = len(on_disk) == len(recs) == m['resource_count'] == m['pefile_count']
        m['verification'] = dict(raw_files=len(on_disk), index_records=len(recs), walker_count=m['resource_count'],
                                 pefile_count=m['pefile_count'], counts_equal=ok, hash_mismatches=fails)
        print('verify %s: raw files %d, index %d, walker %d, pefile %d, equal %s, hash mismatches %d' %
              (binname, len(on_disk), len(recs), m['resource_count'], m['pefile_count'], ok, fails))
        if not ok:
            fails += 1
    # rewrite index.json with verification results
    idx = json.loads((OUT / 'index.json').read_text())
    idx['binaries'] = metas
    write_json(OUT / 'index.json', idx)
    if fails:
        sys.exit('verification failed')


if __name__ == '__main__':
    main()
