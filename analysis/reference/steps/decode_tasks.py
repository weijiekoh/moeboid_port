import sys
words = {}
for line in open(sys.argv[1]):
    if ':' not in line:
        continue
    addr, rest = line.split(':', 1)
    try:
        a = int(addr, 16)
        vals = [int(w, 16) for w in rest.split()]
    except ValueError:
        continue
    for i, w in enumerate(vals):
        words[a + 4 * i] = w
s = [a for a in words if words[a] == 0x42f058]
if s:
    s = s[0]
    print('scheduler object %s (vtable 0x42f058): capacity %d, task array %s, task count %d' % (
        hex(s), words[s + 4], hex(words[s + 8]), words[s + 0xc]))
print('%-10s %8s %-12s %-10s %4s %s' % ('task', 'period', 'callback', 'user', 'flag', 'time base'))
for b in sorted(a for a in words if words[a] == 0x42ea40 and words.get(a + 0x10) is not None):
    g = lambda o: words.get(b + o, 0)
    fl = g(0x28) & 0xff
    print('%-10s %6d ms %-12s %-10s %4d %s' % (hex(b), g(0x10), hex(g(0x1c)), hex(g(0x24)), fl,
          'total (runs while paused)' if fl else 'active (stops while paused)'))
