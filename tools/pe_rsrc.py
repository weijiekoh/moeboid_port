import sys,struct
def parse(path):
    d=open(path,'rb').read()
    pe=struct.unpack_from('<I',d,0x3c)[0]
    nsec=struct.unpack_from('<H',d,pe+6)[0]; opt=struct.unpack_from('<H',d,pe+20)[0]
    rva,size=struct.unpack_from('<II',d,pe+24+96+2*8)
    secs=[struct.unpack_from('<8sIIII',d,pe+24+opt+i*40) for i in range(nsec)]
    def off(r):
        for n,vs,va,rs,ro in secs:
            if va<=r<va+max(vs,rs): return r-va+ro
    base=off(rva)
    def name(o):
        n=struct.unpack_from('<H',d,base+o)[0]; return d[base+o+2:base+o+2+2*n].decode('utf-16le')
    def walk(o,path):
        nn,ni=struct.unpack_from('<HH',d,base+o+12)
        for i in range(nn+ni):
            idv,ov=struct.unpack_from('<II',d,base+o+16+i*8)
            k=name(idv&0x7fffffff) if idv&0x80000000 else idv
            if ov&0x80000000: yield from walk(ov&0x7fffffff,path+[k])
            else:
                r,s=struct.unpack_from('<II',d,base+ov); yield path+[k],s,d[off(r):off(r)+s]
    return list(walk(0,[]))
T={1:'CURSOR',2:'BITMAP',3:'ICON',4:'MENU',5:'DIALOG',6:'STRING',10:'RCDATA',12:'GROUP_CURSOR',14:'GROUP_ICON',16:'VERSION'}
from collections import defaultdict
for p in sys.argv[1:]:
    agg=defaultdict(lambda:[0,0]); ex=[]
    for k,s,b in parse(p):
        t=T.get(k[0],k[0]); agg[t][0]+=1; agg[t][1]+=s
        if len(ex)<40: ex.append((t,k[1],s,b[:8]))
    print('===',p); [print(f'  {t}: {c} items, {s} bytes') for t,(c,s) in agg.items()]
    [print('   ',e) for e in ex]
