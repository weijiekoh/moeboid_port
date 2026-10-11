
out/Moeboid.gam:     file format pei-i386


Disassembly of section .text:

10001000 <.text>:
10001000:	55                   	push   ebp
10001001:	8b ec                	mov    ebp,esp
10001003:	56                   	push   esi
10001004:	8b f1                	mov    esi,ecx
10001006:	57                   	push   edi
10001007:	d9 46 0c             	fld    DWORD PTR [esi+0xc]
1000100a:	e8 01 41 00 00       	call   0x10005110
1000100f:	8b c8                	mov    ecx,eax
10001011:	8b 46 1c             	mov    eax,DWORD PTR [esi+0x1c]
10001014:	99                   	cdq
10001015:	8b 7d 08             	mov    edi,DWORD PTR [ebp+0x8]
10001018:	2b c2                	sub    eax,edx
1000101a:	d1 f8                	sar    eax,1
1000101c:	2b c8                	sub    ecx,eax
1000101e:	83 c1 03             	add    ecx,0x3
10001021:	89 0f                	mov    DWORD PTR [edi],ecx
10001023:	d9 46 10             	fld    DWORD PTR [esi+0x10]
10001026:	e8 e5 40 00 00       	call   0x10005110
1000102b:	8b c8                	mov    ecx,eax
1000102d:	8b 46 20             	mov    eax,DWORD PTR [esi+0x20]
10001030:	99                   	cdq
10001031:	2b c2                	sub    eax,edx
10001033:	8b 17                	mov    edx,DWORD PTR [edi]
10001035:	d1 f8                	sar    eax,1
10001037:	2b c8                	sub    ecx,eax
10001039:	83 c1 03             	add    ecx,0x3
1000103c:	89 4f 04             	mov    DWORD PTR [edi+0x4],ecx
1000103f:	8b 46 1c             	mov    eax,DWORD PTR [esi+0x1c]
10001042:	8d 4c 02 fd          	lea    ecx,[edx+eax*1-0x3]
10001046:	8b 47 04             	mov    eax,DWORD PTR [edi+0x4]
10001049:	89 4f 08             	mov    DWORD PTR [edi+0x8],ecx
1000104c:	8b 56 20             	mov    edx,DWORD PTR [esi+0x20]
1000104f:	8d 4c 02 fd          	lea    ecx,[edx+eax*1-0x3]
10001053:	89 4f 0c             	mov    DWORD PTR [edi+0xc],ecx
10001056:	5f                   	pop    edi
10001057:	5e                   	pop    esi
10001058:	5d                   	pop    ebp
10001059:	c2 04 00             	ret    0x4
1000105c:	90                   	nop
1000105d:	90                   	nop
1000105e:	90                   	nop
1000105f:	90                   	nop
10001060:	55                   	push   ebp
10001061:	8b ec                	mov    ebp,esp
10001063:	83 ec 08             	sub    esp,0x8
10001066:	56                   	push   esi
10001067:	8b f1                	mov    esi,ecx
10001069:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
1000106f:	8b 01                	mov    eax,DWORD PTR [ecx]
10001071:	ff 50 08             	call   DWORD PTR [eax+0x8]
10001074:	33 d2                	xor    edx,edx
10001076:	b9 32 00 00 00       	mov    ecx,0x32
1000107b:	f7 f1                	div    ecx
1000107d:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [ebp-0x4],0x0
10001084:	89 55 f8             	mov    DWORD PTR [ebp-0x8],edx
10001087:	df 6d f8             	fild   QWORD PTR [ebp-0x8]
1000108a:	d8 0d 00 d1 00 10    	fmul   DWORD PTR ds:0x1000d100
10001090:	d9 5e 14             	fstp   DWORD PTR [esi+0x14]
10001093:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
10001099:	8b 11                	mov    edx,DWORD PTR [ecx]
1000109b:	ff 52 08             	call   DWORD PTR [edx+0x8]
1000109e:	a8 01                	test   al,0x1
100010a0:	75 0c                	jne    0x100010ae
100010a2:	d9 46 14             	fld    DWORD PTR [esi+0x14]
100010a5:	d8 0d fc d0 00 10    	fmul   DWORD PTR ds:0x1000d0fc
100010ab:	d9 5e 14             	fstp   DWORD PTR [esi+0x14]
100010ae:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
100010b4:	8b 01                	mov    eax,DWORD PTR [ecx]
100010b6:	ff 50 08             	call   DWORD PTR [eax+0x8]
100010b9:	33 d2                	xor    edx,edx
100010bb:	b9 32 00 00 00       	mov    ecx,0x32
100010c0:	f7 f1                	div    ecx
100010c2:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [ebp-0x4],0x0
100010c9:	89 55 f8             	mov    DWORD PTR [ebp-0x8],edx
100010cc:	df 6d f8             	fild   QWORD PTR [ebp-0x8]
100010cf:	d8 0d 00 d1 00 10    	fmul   DWORD PTR ds:0x1000d100
100010d5:	d9 5e 18             	fstp   DWORD PTR [esi+0x18]
100010d8:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
100010de:	8b 11                	mov    edx,DWORD PTR [ecx]
100010e0:	ff 52 08             	call   DWORD PTR [edx+0x8]
100010e3:	a8 01                	test   al,0x1
100010e5:	75 0c                	jne    0x100010f3
100010e7:	d9 46 18             	fld    DWORD PTR [esi+0x18]
100010ea:	d8 0d fc d0 00 10    	fmul   DWORD PTR ds:0x1000d0fc
100010f0:	d9 5e 18             	fstp   DWORD PTR [esi+0x18]
100010f3:	8b ce                	mov    ecx,esi
100010f5:	e8 06 00 00 00       	call   0x10001100
100010fa:	5e                   	pop    esi
100010fb:	8b e5                	mov    esp,ebp
100010fd:	5d                   	pop    ebp
100010fe:	c3                   	ret
100010ff:	90                   	nop
10001100:	53                   	push   ebx
10001101:	56                   	push   esi
10001102:	8b f1                	mov    esi,ecx
10001104:	57                   	push   edi
10001105:	d9 46 14             	fld    DWORD PTR [esi+0x14]
10001108:	d8 1d 04 d1 00 10    	fcomp  DWORD PTR ds:0x1000d104
1000110e:	df e0                	fnstsw ax
10001110:	f6 c4 01             	test   ah,0x1
10001113:	74 07                	je     0x1000111c
10001115:	b8 01 00 00 00       	mov    eax,0x1
1000111a:	eb 02                	jmp    0x1000111e
1000111c:	33 c0                	xor    eax,eax
1000111e:	88 46 24             	mov    BYTE PTR [esi+0x24],al
10001121:	8b 46 08             	mov    eax,DWORD PTR [esi+0x8]
10001124:	85 c0                	test   eax,eax
10001126:	74 14                	je     0x1000113c
10001128:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
1000112e:	50                   	push   eax
1000112f:	8b 11                	mov    edx,DWORD PTR [ecx]
10001131:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
10001134:	8b 4e 08             	mov    ecx,DWORD PTR [esi+0x8]
10001137:	8b 01                	mov    eax,DWORD PTR [ecx]
10001139:	ff 50 04             	call   DWORD PTR [eax+0x4]
1000113c:	8b 06                	mov    eax,DWORD PTR [esi]
1000113e:	8b 3d cc f5 00 10    	mov    edi,DWORD PTR ds:0x1000f5cc
10001144:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
1000114a:	33 db                	xor    ebx,ebx
1000114c:	8a 5e 24             	mov    bl,BYTE PTR [esi+0x24]
1000114f:	8b 11                	mov    edx,DWORD PTR [ecx]
10001151:	8d 04 43             	lea    eax,[ebx+eax*2]
10001154:	8b 04 87             	mov    eax,DWORD PTR [edi+eax*4]
10001157:	50                   	push   eax
10001158:	ff 52 14             	call   DWORD PTR [edx+0x14]
1000115b:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10001161:	8b f8                	mov    edi,eax
10001163:	6a 00                	push   0x0
10001165:	57                   	push   edi
10001166:	8b 11                	mov    edx,DWORD PTR [ecx]
10001168:	ff 52 08             	call   DWORD PTR [edx+0x8]
1000116b:	89 46 08             	mov    DWORD PTR [esi+0x8],eax
1000116e:	8b 07                	mov    eax,DWORD PTR [edi]
10001170:	8b cf                	mov    ecx,edi
10001172:	ff 50 04             	call   DWORD PTR [eax+0x4]
10001175:	8b 4e 08             	mov    ecx,DWORD PTR [esi+0x8]
10001178:	8b 11                	mov    edx,DWORD PTR [ecx]
1000117a:	ff 52 2c             	call   DWORD PTR [edx+0x2c]
1000117d:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
10001183:	8b 56 08             	mov    edx,DWORD PTR [esi+0x8]
10001186:	52                   	push   edx
10001187:	8b 01                	mov    eax,DWORD PTR [ecx]
10001189:	ff 50 18             	call   DWORD PTR [eax+0x18]
1000118c:	8b 4e 08             	mov    ecx,DWORD PTR [esi+0x8]
1000118f:	8d 56 20             	lea    edx,[esi+0x20]
10001192:	83 c6 1c             	add    esi,0x1c
10001195:	52                   	push   edx
10001196:	8b 01                	mov    eax,DWORD PTR [ecx]
10001198:	56                   	push   esi
10001199:	ff 50 48             	call   DWORD PTR [eax+0x48]
1000119c:	5f                   	pop    edi
1000119d:	5e                   	pop    esi
1000119e:	5b                   	pop    ebx
1000119f:	c3                   	ret
100011a0:	55                   	push   ebp
100011a1:	8b ec                	mov    ebp,esp
100011a3:	83 ec 18             	sub    esp,0x18
100011a6:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100011a9:	53                   	push   ebx
100011aa:	56                   	push   esi
100011ab:	8b f1                	mov    esi,ecx
100011ad:	33 db                	xor    ebx,ebx
100011af:	57                   	push   edi
100011b0:	89 06                	mov    DWORD PTR [esi],eax
100011b2:	89 5e 08             	mov    DWORD PTR [esi+0x8],ebx
100011b5:	88 5e 25             	mov    BYTE PTR [esi+0x25],bl
100011b8:	89 5e 34             	mov    DWORD PTR [esi+0x34],ebx
100011bb:	e8 a0 fe ff ff       	call   0x10001060
100011c0:	38 1d 05 f6 00 10    	cmp    BYTE PTR ds:0x1000f605,bl
100011c6:	74 4b                	je     0x10001213
100011c8:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
100011ce:	8b 11                	mov    edx,DWORD PTR [ecx]
100011d0:	ff 52 08             	call   DWORD PTR [edx+0x8]
100011d3:	33 d2                	xor    edx,edx
100011d5:	b9 2c 01 00 00       	mov    ecx,0x12c
100011da:	f7 f1                	div    ecx
100011dc:	89 5d fc             	mov    DWORD PTR [ebp-0x4],ebx
100011df:	83 c2 64             	add    edx,0x64
100011e2:	89 55 f8             	mov    DWORD PTR [ebp-0x8],edx
100011e5:	df 6d f8             	fild   QWORD PTR [ebp-0x8]
100011e8:	d9 5e 0c             	fstp   DWORD PTR [esi+0xc]
100011eb:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
100011f1:	8b 11                	mov    edx,DWORD PTR [ecx]
100011f3:	ff 52 08             	call   DWORD PTR [edx+0x8]
100011f6:	33 d2                	xor    edx,edx
100011f8:	b9 c8 00 00 00       	mov    ecx,0xc8
100011fd:	f7 f1                	div    ecx
100011ff:	89 5d fc             	mov    DWORD PTR [ebp-0x4],ebx
10001202:	83 c2 64             	add    edx,0x64
10001205:	89 55 f8             	mov    DWORD PTR [ebp-0x8],edx
10001208:	df 6d f8             	fild   QWORD PTR [ebp-0x8]
1000120b:	d9 5e 10             	fstp   DWORD PTR [esi+0x10]
1000120e:	e9 9c 00 00 00       	jmp    0x100012af
10001213:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
10001219:	8b 11                	mov    edx,DWORD PTR [ecx]
1000121b:	ff 52 08             	call   DWORD PTR [edx+0x8]
1000121e:	8b 56 1c             	mov    edx,DWORD PTR [esi+0x1c]
10001221:	b9 be 00 00 00       	mov    ecx,0xbe
10001226:	2b ca                	sub    ecx,edx
10001228:	33 d2                	xor    edx,edx
1000122a:	f7 f1                	div    ecx
1000122c:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
10001232:	89 5d f4             	mov    DWORD PTR [ebp-0xc],ebx
10001235:	89 55 f0             	mov    DWORD PTR [ebp-0x10],edx
10001238:	8b 11                	mov    edx,DWORD PTR [ecx]
1000123a:	df 6d f0             	fild   QWORD PTR [ebp-0x10]
1000123d:	d9 5d 08             	fstp   DWORD PTR [ebp+0x8]
10001240:	ff 52 08             	call   DWORD PTR [edx+0x8]
10001243:	33 d2                	xor    edx,edx
10001245:	b9 e8 03 00 00       	mov    ecx,0x3e8
1000124a:	f7 f1                	div    ecx
1000124c:	89 5d ec             	mov    DWORD PTR [ebp-0x14],ebx
1000124f:	89 55 e8             	mov    DWORD PTR [ebp-0x18],edx
10001252:	df 6d e8             	fild   QWORD PTR [ebp-0x18]
10001255:	d8 0d 18 d1 00 10    	fmul   DWORD PTR ds:0x1000d118
1000125b:	d9 c0                	fld    st(0)
1000125d:	d9 fe                	fsin
1000125f:	d8 4d 08             	fmul   DWORD PTR [ebp+0x8]
10001262:	d8 05 14 d1 00 10    	fadd   DWORD PTR ds:0x1000d114
10001268:	d9 55 fc             	fst    DWORD PTR [ebp-0x4]
1000126b:	d9 5e 0c             	fstp   DWORD PTR [esi+0xc]
1000126e:	d9 ff                	fcos
10001270:	d8 4d 08             	fmul   DWORD PTR [ebp+0x8]
10001273:	d8 05 10 d1 00 10    	fadd   DWORD PTR ds:0x1000d110
10001279:	d9 56 10             	fst    DWORD PTR [esi+0x10]
1000127c:	8b 15 e4 f5 00 10    	mov    edx,DWORD PTR ds:0x1000f5e4
10001282:	8b 42 0c             	mov    eax,DWORD PTR [edx+0xc]
10001285:	d8 60 14             	fsub   DWORD PTR [eax+0x14]
10001288:	d9 45 fc             	fld    DWORD PTR [ebp-0x4]
1000128b:	d8 60 10             	fsub   DWORD PTR [eax+0x10]
1000128e:	d9 c0                	fld    st(0)
10001290:	d8 c9                	fmul   st,st(1)
10001292:	d9 c2                	fld    st(2)
10001294:	d8 cb                	fmul   st,st(3)
10001296:	de c1                	faddp  st(1),st
10001298:	d9 fa                	fsqrt
1000129a:	dc 1d 08 d1 00 10    	fcomp  QWORD PTR ds:0x1000d108
100012a0:	df e0                	fnstsw ax
100012a2:	dd d8                	fstp   st(0)
100012a4:	f6 c4 41             	test   ah,0x41
100012a7:	dd d8                	fstp   st(0)
100012a9:	0f 85 64 ff ff ff    	jne    0x10001213
100012af:	8b 7e 08             	mov    edi,DWORD PTR [esi+0x8]
100012b2:	53                   	push   ebx
100012b3:	d9 46 10             	fld    DWORD PTR [esi+0x10]
100012b6:	8b 17                	mov    edx,DWORD PTR [edi]
100012b8:	89 55 08             	mov    DWORD PTR [ebp+0x8],edx
100012bb:	e8 50 3e 00 00       	call   0x10005110
100012c0:	d9 46 0c             	fld    DWORD PTR [esi+0xc]
100012c3:	50                   	push   eax
100012c4:	e8 47 3e 00 00       	call   0x10005110
100012c9:	50                   	push   eax
100012ca:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100012cd:	8b cf                	mov    ecx,edi
100012cf:	ff 50 08             	call   DWORD PTR [eax+0x8]
100012d2:	8b 4e 08             	mov    ecx,DWORD PTR [esi+0x8]
100012d5:	6a 00                	push   0x0
100012d7:	6a 00                	push   0x0
100012d9:	8b 11                	mov    edx,DWORD PTR [ecx]
100012db:	ff 52 10             	call   DWORD PTR [edx+0x10]
100012de:	8b 15 cc f5 00 10    	mov    edx,DWORD PTR ds:0x1000f5cc
100012e4:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
100012ea:	8b 92 a8 00 00 00    	mov    edx,DWORD PTR [edx+0xa8]
100012f0:	8b 01                	mov    eax,DWORD PTR [ecx]
100012f2:	52                   	push   edx
100012f3:	ff 50 14             	call   DWORD PTR [eax+0x14]
100012f6:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
100012fc:	8b f8                	mov    edi,eax
100012fe:	6a 00                	push   0x0
10001300:	57                   	push   edi
10001301:	8b 01                	mov    eax,DWORD PTR [ecx]
10001303:	ff 50 08             	call   DWORD PTR [eax+0x8]
10001306:	89 46 04             	mov    DWORD PTR [esi+0x4],eax
10001309:	8b 17                	mov    edx,DWORD PTR [edi]
1000130b:	8b cf                	mov    ecx,edi
1000130d:	ff 52 04             	call   DWORD PTR [edx+0x4]
10001310:	a1 e0 f5 00 10       	mov    eax,ds:0x1000f5e0
10001315:	89 46 28             	mov    DWORD PTR [esi+0x28],eax
10001318:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
1000131e:	8b 11                	mov    edx,DWORD PTR [ecx]
10001320:	ff 52 08             	call   DWORD PTR [edx+0x8]
10001323:	33 d2                	xor    edx,edx
10001325:	b9 a0 0f 00 00       	mov    ecx,0xfa0
1000132a:	f7 f1                	div    ecx
1000132c:	c6 46 30 01          	mov    BYTE PTR [esi+0x30],0x1
10001330:	8b c6                	mov    eax,esi
10001332:	5f                   	pop    edi
10001333:	89 56 2c             	mov    DWORD PTR [esi+0x2c],edx
10001336:	5e                   	pop    esi
10001337:	5b                   	pop    ebx
10001338:	8b e5                	mov    esp,ebp
1000133a:	5d                   	pop    ebp
1000133b:	c2 04 00             	ret    0x4
1000133e:	90                   	nop
1000133f:	90                   	nop
10001340:	56                   	push   esi
10001341:	8b f1                	mov    esi,ecx
10001343:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
10001349:	8b 56 08             	mov    edx,DWORD PTR [esi+0x8]
1000134c:	8b 01                	mov    eax,DWORD PTR [ecx]
1000134e:	52                   	push   edx
1000134f:	ff 50 1c             	call   DWORD PTR [eax+0x1c]
10001352:	8b 4e 08             	mov    ecx,DWORD PTR [esi+0x8]
10001355:	8b 01                	mov    eax,DWORD PTR [ecx]
10001357:	ff 50 04             	call   DWORD PTR [eax+0x4]
1000135a:	8b 46 04             	mov    eax,DWORD PTR [esi+0x4]
1000135d:	85 c0                	test   eax,eax
1000135f:	74 1b                	je     0x1000137c
10001361:	8a 4e 25             	mov    cl,BYTE PTR [esi+0x25]
10001364:	84 c9                	test   cl,cl
10001366:	74 0c                	je     0x10001374
10001368:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
1000136e:	50                   	push   eax
1000136f:	8b 11                	mov    edx,DWORD PTR [ecx]
10001371:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
10001374:	8b 4e 04             	mov    ecx,DWORD PTR [esi+0x4]
10001377:	8b 01                	mov    eax,DWORD PTR [ecx]
10001379:	ff 50 04             	call   DWORD PTR [eax+0x4]
1000137c:	5e                   	pop    esi
1000137d:	c3                   	ret
1000137e:	90                   	nop
1000137f:	90                   	nop
10001380:	55                   	push   ebp
10001381:	8b ec                	mov    ebp,esp
10001383:	83 ec 18             	sub    esp,0x18
10001386:	56                   	push   esi
10001387:	8b f1                	mov    esi,ecx
10001389:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
1000138c:	57                   	push   edi
1000138d:	8a 46 30             	mov    al,BYTE PTR [esi+0x30]
10001390:	84 c0                	test   al,al
10001392:	0f 84 a1 00 00 00    	je     0x10001439
10001398:	8b 7e 28             	mov    edi,DWORD PTR [esi+0x28]
1000139b:	8b 56 2c             	mov    edx,DWORD PTR [esi+0x2c]
1000139e:	8b c1                	mov    eax,ecx
100013a0:	2b c7                	sub    eax,edi
100013a2:	3b c2                	cmp    eax,edx
100013a4:	0f 86 8f 00 00 00    	jbe    0x10001439
100013aa:	8b 46 04             	mov    eax,DWORD PTR [esi+0x4]
100013ad:	c6 46 25 01          	mov    BYTE PTR [esi+0x25],0x1
100013b1:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
100013b7:	50                   	push   eax
100013b8:	8b 11                	mov    edx,DWORD PTR [ecx]
100013ba:	ff 52 18             	call   DWORD PTR [edx+0x18]
100013bd:	8b 4e 04             	mov    ecx,DWORD PTR [esi+0x4]
100013c0:	8b 11                	mov    edx,DWORD PTR [ecx]
100013c2:	ff 52 2c             	call   DWORD PTR [edx+0x2c]
100013c5:	8b 7e 04             	mov    edi,DWORD PTR [esi+0x4]
100013c8:	6a 00                	push   0x0
100013ca:	d9 46 10             	fld    DWORD PTR [esi+0x10]
100013cd:	8b 17                	mov    edx,DWORD PTR [edi]
100013cf:	89 55 08             	mov    DWORD PTR [ebp+0x8],edx
100013d2:	e8 39 3d 00 00       	call   0x10005110
100013d7:	d9 46 0c             	fld    DWORD PTR [esi+0xc]
100013da:	83 e8 0a             	sub    eax,0xa
100013dd:	50                   	push   eax
100013de:	e8 2d 3d 00 00       	call   0x10005110
100013e3:	83 e8 0a             	sub    eax,0xa
100013e6:	8b cf                	mov    ecx,edi
100013e8:	50                   	push   eax
100013e9:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100013ec:	ff 50 08             	call   DWORD PTR [eax+0x8]
100013ef:	c6 46 30 00          	mov    BYTE PTR [esi+0x30],0x0
100013f3:	a1 e4 f5 00 10       	mov    eax,ds:0x1000f5e4
100013f8:	85 c0                	test   eax,eax
100013fa:	74 23                	je     0x1000141f
100013fc:	8b 48 0c             	mov    ecx,DWORD PTR [eax+0xc]
100013ff:	8b 16                	mov    edx,DWORD PTR [esi]
10001401:	3b 11                	cmp    edx,DWORD PTR [ecx]
10001403:	7e 1a                	jle    0x1000141f
10001405:	a1 cc f5 00 10       	mov    eax,ds:0x1000f5cc
1000140a:	6a 00                	push   0x0
1000140c:	8b 88 e8 00 00 00    	mov    ecx,DWORD PTR [eax+0xe8]
10001412:	8b 11                	mov    edx,DWORD PTR [ecx]
10001414:	ff 52 08             	call   DWORD PTR [edx+0x8]
10001417:	5f                   	pop    edi
10001418:	5e                   	pop    esi
10001419:	8b e5                	mov    esp,ebp
1000141b:	5d                   	pop    ebp
1000141c:	c2 04 00             	ret    0x4
1000141f:	a1 cc f5 00 10       	mov    eax,ds:0x1000f5cc
10001424:	6a 00                	push   0x0
10001426:	8b 88 e4 00 00 00    	mov    ecx,DWORD PTR [eax+0xe4]
1000142c:	8b 11                	mov    edx,DWORD PTR [ecx]
1000142e:	ff 52 08             	call   DWORD PTR [edx+0x8]
10001431:	5f                   	pop    edi
10001432:	5e                   	pop    esi
10001433:	8b e5                	mov    esp,ebp
10001435:	5d                   	pop    ebp
10001436:	c2 04 00             	ret    0x4
10001439:	8b 46 04             	mov    eax,DWORD PTR [esi+0x4]
1000143c:	85 c0                	test   eax,eax
1000143e:	74 41                	je     0x10001481
10001440:	8b 56 28             	mov    edx,DWORD PTR [esi+0x28]
10001443:	2b ca                	sub    ecx,edx
10001445:	8b 56 2c             	mov    edx,DWORD PTR [esi+0x2c]
10001448:	81 c2 58 02 00 00    	add    edx,0x258
1000144e:	3b ca                	cmp    ecx,edx
10001450:	0f 86 39 02 00 00    	jbe    0x1000168f
10001456:	c6 46 25 00          	mov    BYTE PTR [esi+0x25],0x0
1000145a:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
10001460:	50                   	push   eax
10001461:	8b 11                	mov    edx,DWORD PTR [ecx]
10001463:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
10001466:	8b 4e 04             	mov    ecx,DWORD PTR [esi+0x4]
10001469:	8b 01                	mov    eax,DWORD PTR [ecx]
1000146b:	ff 50 04             	call   DWORD PTR [eax+0x4]
1000146e:	8b 4e 08             	mov    ecx,DWORD PTR [esi+0x8]
10001471:	c7 46 04 00 00 00 00 	mov    DWORD PTR [esi+0x4],0x0
10001478:	6a 00                	push   0x0
1000147a:	6a 01                	push   0x1
1000147c:	8b 11                	mov    edx,DWORD PTR [ecx]
1000147e:	ff 52 10             	call   DWORD PTR [edx+0x10]
10001481:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
10001487:	8b 01                	mov    eax,DWORD PTR [ecx]
10001489:	ff 50 08             	call   DWORD PTR [eax+0x8]
1000148c:	33 d2                	xor    edx,edx
1000148e:	b9 64 00 00 00       	mov    ecx,0x64
10001493:	f7 f1                	div    ecx
10001495:	85 d2                	test   edx,edx
10001497:	75 0c                	jne    0x100014a5
10001499:	8b ce                	mov    ecx,esi
1000149b:	e8 c0 fb ff ff       	call   0x10001060
100014a0:	e9 c6 01 00 00       	jmp    0x1000166b
100014a5:	8b 46 34             	mov    eax,DWORD PTR [esi+0x34]
100014a8:	85 c0                	test   eax,eax
100014aa:	75 09                	jne    0x100014b5
100014ac:	8b 15 e0 f5 00 10    	mov    edx,DWORD PTR ds:0x1000f5e0
100014b2:	89 56 34             	mov    DWORD PTR [esi+0x34],edx
100014b5:	a1 e0 f5 00 10       	mov    eax,ds:0x1000f5e0
100014ba:	8b 4e 34             	mov    ecx,DWORD PTR [esi+0x34]
100014bd:	2b c1                	sub    eax,ecx
100014bf:	c7 45 ec 00 00 00 00 	mov    DWORD PTR [ebp-0x14],0x0
100014c6:	89 45 e8             	mov    DWORD PTR [ebp-0x18],eax
100014c9:	8b 46 1c             	mov    eax,DWORD PTR [esi+0x1c]
100014cc:	df 6d e8             	fild   QWORD PTR [ebp-0x18]
100014cf:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
100014d2:	99                   	cdq
100014d3:	d9 c0                	fld    st(0)
100014d5:	d8 4e 14             	fmul   DWORD PTR [esi+0x14]
100014d8:	2b c2                	sub    eax,edx
100014da:	d1 f8                	sar    eax,1
100014dc:	d8 0d 38 d1 00 10    	fmul   DWORD PTR ds:0x1000d138
100014e2:	89 45 08             	mov    DWORD PTR [ebp+0x8],eax
100014e5:	8b 46 20             	mov    eax,DWORD PTR [esi+0x20]
100014e8:	99                   	cdq
100014e9:	d9 5d f0             	fstp   DWORD PTR [ebp-0x10]
100014ec:	2b c2                	sub    eax,edx
100014ee:	d8 4e 18             	fmul   DWORD PTR [esi+0x18]
100014f1:	d1 f8                	sar    eax,1
100014f3:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax
100014f6:	a0 05 f6 00 10       	mov    al,ds:0x1000f605
100014fb:	d8 0d 38 d1 00 10    	fmul   DWORD PTR ds:0x1000d138
10001501:	84 c0                	test   al,al
10001503:	d9 5d ec             	fstp   DWORD PTR [ebp-0x14]
10001506:	db 45 08             	fild   DWORD PTR [ebp+0x8]
10001509:	d9 46 0c             	fld    DWORD PTR [esi+0xc]
1000150c:	d8 25 34 d1 00 10    	fsub   DWORD PTR ds:0x1000d134
10001512:	de c1                	faddp  st(1),st
10001514:	d8 45 f0             	fadd   DWORD PTR [ebp-0x10]
10001517:	d9 5d 08             	fstp   DWORD PTR [ebp+0x8]
1000151a:	db 45 f4             	fild   DWORD PTR [ebp-0xc]
1000151d:	d9 46 10             	fld    DWORD PTR [esi+0x10]
10001520:	d8 25 30 d1 00 10    	fsub   DWORD PTR ds:0x1000d130
10001526:	de c1                	faddp  st(1),st
10001528:	d8 45 ec             	fadd   DWORD PTR [ebp-0x14]
1000152b:	d9 55 f8             	fst    DWORD PTR [ebp-0x8]
1000152e:	d8 4d f8             	fmul   DWORD PTR [ebp-0x8]
10001531:	d9 45 08             	fld    DWORD PTR [ebp+0x8]
10001534:	d8 4d 08             	fmul   DWORD PTR [ebp+0x8]
10001537:	de c1                	faddp  st(1),st
10001539:	d9 5d f4             	fstp   DWORD PTR [ebp-0xc]
1000153c:	db 45 fc             	fild   DWORD PTR [ebp-0x4]
1000153f:	d8 0d 2c d1 00 10    	fmul   DWORD PTR ds:0x1000d12c
10001545:	d8 2d 28 d1 00 10    	fsubr  DWORD PTR ds:0x1000d128
1000154b:	d9 c0                	fld    st(0)
1000154d:	d8 c9                	fmul   st,st(1)
1000154f:	d9 5d fc             	fstp   DWORD PTR [ebp-0x4]
10001552:	dd d8                	fstp   st(0)
10001554:	74 6f                	je     0x100015c5
10001556:	d9 46 0c             	fld    DWORD PTR [esi+0xc]
10001559:	d8 1d 24 d1 00 10    	fcomp  DWORD PTR ds:0x1000d124
1000155f:	df e0                	fnstsw ax
10001561:	f6 c4 01             	test   ah,0x1
10001564:	75 20                	jne    0x10001586
10001566:	d9 46 0c             	fld    DWORD PTR [esi+0xc]
10001569:	d8 1d 20 d1 00 10    	fcomp  DWORD PTR ds:0x1000d120
1000156f:	df e0                	fnstsw ax
10001571:	f6 c4 41             	test   ah,0x41
10001574:	74 10                	je     0x10001586
10001576:	d9 46 14             	fld    DWORD PTR [esi+0x14]
10001579:	d8 1d 04 d1 00 10    	fcomp  DWORD PTR ds:0x1000d104
1000157f:	df e0                	fnstsw ax
10001581:	f6 c4 41             	test   ah,0x41
10001584:	74 30                	je     0x100015b6
10001586:	d9 46 0c             	fld    DWORD PTR [esi+0xc]
10001589:	d8 1d 20 d1 00 10    	fcomp  DWORD PTR ds:0x1000d120
1000158f:	df e0                	fnstsw ax
10001591:	f6 c4 41             	test   ah,0x41
10001594:	75 2f                	jne    0x100015c5
10001596:	d9 46 0c             	fld    DWORD PTR [esi+0xc]
10001599:	d8 1d 1c d1 00 10    	fcomp  DWORD PTR ds:0x1000d11c
1000159f:	df e0                	fnstsw ax
100015a1:	f6 c4 41             	test   ah,0x41
100015a4:	74 1f                	je     0x100015c5
100015a6:	d9 46 14             	fld    DWORD PTR [esi+0x14]
100015a9:	d8 1d 04 d1 00 10    	fcomp  DWORD PTR ds:0x1000d104
100015af:	df e0                	fnstsw ax
100015b1:	f6 c4 01             	test   ah,0x1
100015b4:	74 0f                	je     0x100015c5
100015b6:	d9 46 14             	fld    DWORD PTR [esi+0x14]
100015b9:	d9 e0                	fchs
100015bb:	d9 5e 14             	fstp   DWORD PTR [esi+0x14]
100015be:	8b ce                	mov    ecx,esi
100015c0:	e8 3b fb ff ff       	call   0x10001100
100015c5:	d9 45 f4             	fld    DWORD PTR [ebp-0xc]
100015c8:	d8 5d fc             	fcomp  DWORD PTR [ebp-0x4]
100015cb:	df e0                	fnstsw ax
100015cd:	f6 c4 01             	test   ah,0x1
100015d0:	75 5a                	jne    0x1000162c
100015d2:	d9 45 fc             	fld    DWORD PTR [ebp-0x4]
100015d5:	d8 4d 08             	fmul   DWORD PTR [ebp+0x8]
100015d8:	8b 46 1c             	mov    eax,DWORD PTR [esi+0x1c]
100015db:	99                   	cdq
100015dc:	d8 75 f4             	fdiv   DWORD PTR [ebp-0xc]
100015df:	2b c2                	sub    eax,edx
100015e1:	d1 f8                	sar    eax,1
100015e3:	89 45 08             	mov    DWORD PTR [ebp+0x8],eax
100015e6:	8b 46 20             	mov    eax,DWORD PTR [esi+0x20]
100015e9:	99                   	cdq
100015ea:	2b c2                	sub    eax,edx
100015ec:	d1 f8                	sar    eax,1
100015ee:	d8 05 34 d1 00 10    	fadd   DWORD PTR ds:0x1000d134
100015f4:	da 65 08             	fisub  DWORD PTR [ebp+0x8]
100015f7:	89 45 08             	mov    DWORD PTR [ebp+0x8],eax
100015fa:	d9 5e 0c             	fstp   DWORD PTR [esi+0xc]
100015fd:	d9 45 fc             	fld    DWORD PTR [ebp-0x4]
10001600:	d8 4d f8             	fmul   DWORD PTR [ebp-0x8]
10001603:	d8 75 f4             	fdiv   DWORD PTR [ebp-0xc]
10001606:	d8 05 30 d1 00 10    	fadd   DWORD PTR ds:0x1000d130
1000160c:	da 65 08             	fisub  DWORD PTR [ebp+0x8]
1000160f:	d9 5e 10             	fstp   DWORD PTR [esi+0x10]
10001612:	d9 46 14             	fld    DWORD PTR [esi+0x14]
10001615:	d8 0d fc d0 00 10    	fmul   DWORD PTR ds:0x1000d0fc
1000161b:	d9 5e 14             	fstp   DWORD PTR [esi+0x14]
1000161e:	d9 46 18             	fld    DWORD PTR [esi+0x18]
10001621:	d8 0d fc d0 00 10    	fmul   DWORD PTR ds:0x1000d0fc
10001627:	d9 5e 18             	fstp   DWORD PTR [esi+0x18]
1000162a:	eb 12                	jmp    0x1000163e
1000162c:	d9 45 f0             	fld    DWORD PTR [ebp-0x10]
1000162f:	d8 46 0c             	fadd   DWORD PTR [esi+0xc]
10001632:	d9 5e 0c             	fstp   DWORD PTR [esi+0xc]
10001635:	d9 45 ec             	fld    DWORD PTR [ebp-0x14]
10001638:	d8 46 10             	fadd   DWORD PTR [esi+0x10]
1000163b:	d9 5e 10             	fstp   DWORD PTR [esi+0x10]
1000163e:	8b 7e 08             	mov    edi,DWORD PTR [esi+0x8]
10001641:	6a 00                	push   0x0
10001643:	d9 46 10             	fld    DWORD PTR [esi+0x10]
10001646:	8b 17                	mov    edx,DWORD PTR [edi]
10001648:	89 55 08             	mov    DWORD PTR [ebp+0x8],edx
1000164b:	e8 c0 3a 00 00       	call   0x10005110
10001650:	d9 46 0c             	fld    DWORD PTR [esi+0xc]
10001653:	50                   	push   eax
10001654:	e8 b7 3a 00 00       	call   0x10005110
10001659:	50                   	push   eax
1000165a:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000165d:	8b cf                	mov    ecx,edi
1000165f:	ff 50 08             	call   DWORD PTR [eax+0x8]
10001662:	8b 0d e0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5e0
10001668:	89 4e 34             	mov    DWORD PTR [esi+0x34],ecx
1000166b:	8b 7e 08             	mov    edi,DWORD PTR [esi+0x8]
1000166e:	6a 00                	push   0x0
10001670:	d9 46 10             	fld    DWORD PTR [esi+0x10]
10001673:	8b 17                	mov    edx,DWORD PTR [edi]
10001675:	89 55 08             	mov    DWORD PTR [ebp+0x8],edx
10001678:	e8 93 3a 00 00       	call   0x10005110
1000167d:	d9 46 0c             	fld    DWORD PTR [esi+0xc]
10001680:	50                   	push   eax
10001681:	e8 8a 3a 00 00       	call   0x10005110
10001686:	8b 55 08             	mov    edx,DWORD PTR [ebp+0x8]
10001689:	50                   	push   eax
1000168a:	8b cf                	mov    ecx,edi
1000168c:	ff 52 08             	call   DWORD PTR [edx+0x8]
1000168f:	5f                   	pop    edi
10001690:	5e                   	pop    esi
10001691:	8b e5                	mov    esp,ebp
10001693:	5d                   	pop    ebp
10001694:	c2 04 00             	ret    0x4
10001697:	90                   	nop
10001698:	90                   	nop
10001699:	90                   	nop
1000169a:	90                   	nop
1000169b:	90                   	nop
1000169c:	90                   	nop
1000169d:	90                   	nop
1000169e:	90                   	nop
1000169f:	90                   	nop
100016a0:	55                   	push   ebp
100016a1:	8b ec                	mov    ebp,esp
100016a3:	6a ff                	push   0xffffffff
100016a5:	68 5b c5 00 10       	push   0x1000c55b
100016aa:	64 a1 00 00 00 00    	mov    eax,fs:0x0
100016b0:	50                   	push   eax
100016b1:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
100016b8:	81 ec 04 01 00 00    	sub    esp,0x104
100016be:	53                   	push   ebx
100016bf:	56                   	push   esi
100016c0:	57                   	push   edi
100016c1:	8b 7d 08             	mov    edi,DWORD PTR [ebp+0x8]
100016c4:	8b f1                	mov    esi,ecx
100016c6:	89 3d b4 f5 00 10    	mov    DWORD PTR ds:0x1000f5b4,edi
100016cc:	89 35 cc f5 00 10    	mov    DWORD PTR ds:0x1000f5cc,esi
100016d2:	8b 4f 08             	mov    ecx,DWORD PTR [edi+0x8]
100016d5:	89 0d bc f5 00 10    	mov    DWORD PTR ds:0x1000f5bc,ecx
100016db:	68 b8 f5 00 10       	push   0x1000f5b8
100016e0:	8b 01                	mov    eax,DWORD PTR [ecx]
100016e2:	ff 50 44             	call   DWORD PTR [eax+0x44]
100016e5:	8b 4f 0c             	mov    ecx,DWORD PTR [edi+0xc]
100016e8:	68 40 1f 00 10       	push   0x10001f40
100016ed:	89 0d c0 f5 00 10    	mov    DWORD PTR ds:0x1000f5c0,ecx
100016f3:	8b 57 14             	mov    edx,DWORD PTR [edi+0x14]
100016f6:	89 15 c8 f5 00 10    	mov    DWORD PTR ds:0x1000f5c8,edx
100016fc:	8b 47 18             	mov    eax,DWORD PTR [edi+0x18]
100016ff:	a3 c4 f5 00 10       	mov    ds:0x1000f5c4,eax
10001704:	8b 4f 10             	mov    ecx,DWORD PTR [edi+0x10]
10001707:	89 0d b0 f5 00 10    	mov    DWORD PTR ds:0x1000f5b0,ecx
1000170d:	8b 47 14             	mov    eax,DWORD PTR [edi+0x14]
10001710:	8b 11                	mov    edx,DWORD PTR [ecx]
10001712:	56                   	push   esi
10001713:	6a 10                	push   0x10
10001715:	50                   	push   eax
10001716:	ff 52 44             	call   DWORD PTR [edx+0x44]
10001719:	89 46 04             	mov    DWORD PTR [esi+0x4],eax
1000171c:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
10001722:	6a 33                	push   0x33
10001724:	8b 49 14             	mov    ecx,DWORD PTR [ecx+0x14]
10001727:	8b 11                	mov    edx,DWORD PTR [ecx]
10001729:	ff 52 10             	call   DWORD PTR [edx+0x10]
1000172c:	8d 45 b8             	lea    eax,[ebp-0x48]
1000172f:	8d 4e 0c             	lea    ecx,[esi+0xc]
10001732:	c7 45 b8 0b 00 00 00 	mov    DWORD PTR [ebp-0x48],0xb
10001739:	c7 45 bc 0f 00 00 00 	mov    DWORD PTR [ebp-0x44],0xf
10001740:	c7 45 c0 13 00 00 00 	mov    DWORD PTR [ebp-0x40],0x13
10001747:	c7 45 c4 17 00 00 00 	mov    DWORD PTR [ebp-0x3c],0x17
1000174e:	c7 45 c8 1b 00 00 00 	mov    DWORD PTR [ebp-0x38],0x1b
10001755:	c7 45 cc 1f 00 00 00 	mov    DWORD PTR [ebp-0x34],0x1f
1000175c:	c7 45 d0 23 00 00 00 	mov    DWORD PTR [ebp-0x30],0x23
10001763:	c7 45 d4 27 00 00 00 	mov    DWORD PTR [ebp-0x2c],0x27
1000176a:	c7 45 d8 2b 00 00 00 	mov    DWORD PTR [ebp-0x28],0x2b
10001771:	c7 45 dc 2f 00 00 00 	mov    DWORD PTR [ebp-0x24],0x2f
10001778:	89 45 ec             	mov    DWORD PTR [ebp-0x14],eax
1000177b:	89 4d e8             	mov    DWORD PTR [ebp-0x18],ecx
1000177e:	c7 45 e4 0a 00 00 00 	mov    DWORD PTR [ebp-0x1c],0xa
10001785:	8b 55 ec             	mov    edx,DWORD PTR [ebp-0x14]
10001788:	8d 85 54 ff ff ff    	lea    eax,[ebp-0xac]
1000178e:	8b 3a                	mov    edi,DWORD PTR [edx]
10001790:	57                   	push   edi
10001791:	57                   	push   edi
10001792:	68 1c e2 00 10       	push   0x1000e21c
10001797:	50                   	push   eax
10001798:	e8 13 3a 00 00       	call   0x100051b0
1000179d:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
100017a3:	83 c4 10             	add    esp,0x10
100017a6:	8d 85 54 ff ff ff    	lea    eax,[ebp-0xac]
100017ac:	8b 11                	mov    edx,DWORD PTR [ecx]
100017ae:	6a 00                	push   0x0
100017b0:	50                   	push   eax
100017b1:	ff 52 0c             	call   DWORD PTR [edx+0xc]
100017b4:	8b d8                	mov    ebx,eax
100017b6:	8d 45 08             	lea    eax,[ebp+0x8]
100017b9:	50                   	push   eax
100017ba:	8b cb                	mov    ecx,ebx
100017bc:	8b 13                	mov    edx,DWORD PTR [ebx]
100017be:	ff 52 3c             	call   DWORD PTR [edx+0x3c]
100017c1:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
100017c4:	8b 45 e8             	mov    eax,DWORD PTR [ebp-0x18]
100017c7:	83 c0 fc             	add    eax,0xfffffffc
100017ca:	8b 11                	mov    edx,DWORD PTR [ecx]
100017cc:	50                   	push   eax
100017cd:	ff 52 10             	call   DWORD PTR [edx+0x10]
100017d0:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
100017d3:	8b 11                	mov    edx,DWORD PTR [ecx]
100017d5:	ff 52 04             	call   DWORD PTR [edx+0x4]
100017d8:	8b 03                	mov    eax,DWORD PTR [ebx]
100017da:	8b cb                	mov    ecx,ebx
100017dc:	ff 50 04             	call   DWORD PTR [eax+0x4]
100017df:	57                   	push   edi
100017e0:	57                   	push   edi
100017e1:	8d 8d 54 ff ff ff    	lea    ecx,[ebp-0xac]
100017e7:	68 00 e2 00 10       	push   0x1000e200
100017ec:	51                   	push   ecx
100017ed:	e8 be 39 00 00       	call   0x100051b0
100017f2:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
100017f8:	83 c4 10             	add    esp,0x10
100017fb:	8d 85 54 ff ff ff    	lea    eax,[ebp-0xac]
10001801:	8b 11                	mov    edx,DWORD PTR [ecx]
10001803:	6a 00                	push   0x0
10001805:	50                   	push   eax
10001806:	ff 52 0c             	call   DWORD PTR [edx+0xc]
10001809:	8b f8                	mov    edi,eax
1000180b:	8d 45 08             	lea    eax,[ebp+0x8]
1000180e:	50                   	push   eax
1000180f:	8b cf                	mov    ecx,edi
10001811:	8b 17                	mov    edx,DWORD PTR [edi]
10001813:	ff 52 3c             	call   DWORD PTR [edx+0x3c]
10001816:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
10001819:	8b 5d e8             	mov    ebx,DWORD PTR [ebp-0x18]
1000181c:	53                   	push   ebx
1000181d:	8b 11                	mov    edx,DWORD PTR [ecx]
1000181f:	ff 52 10             	call   DWORD PTR [edx+0x10]
10001822:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
10001825:	8b 01                	mov    eax,DWORD PTR [ecx]
10001827:	ff 50 04             	call   DWORD PTR [eax+0x4]
1000182a:	8b 17                	mov    edx,DWORD PTR [edi]
1000182c:	8b cf                	mov    ecx,edi
1000182e:	ff 52 04             	call   DWORD PTR [edx+0x4]
10001831:	8b 55 ec             	mov    edx,DWORD PTR [ebp-0x14]
10001834:	8b 45 e4             	mov    eax,DWORD PTR [ebp-0x1c]
10001837:	83 c2 04             	add    edx,0x4
1000183a:	83 c3 08             	add    ebx,0x8
1000183d:	48                   	dec    eax
1000183e:	89 55 ec             	mov    DWORD PTR [ebp-0x14],edx
10001841:	89 5d e8             	mov    DWORD PTR [ebp-0x18],ebx
10001844:	89 45 e4             	mov    DWORD PTR [ebp-0x1c],eax
10001847:	0f 85 38 ff ff ff    	jne    0x10001785
1000184d:	33 ff                	xor    edi,edi
1000184f:	8b 44 bd b8          	mov    eax,DWORD PTR [ebp+edi*4-0x48]
10001853:	50                   	push   eax
10001854:	50                   	push   eax
10001855:	8d 85 f0 fe ff ff    	lea    eax,[ebp-0x110]
1000185b:	68 e4 e1 00 10       	push   0x1000e1e4
10001860:	50                   	push   eax
10001861:	e8 4a 39 00 00       	call   0x100051b0
10001866:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
1000186c:	83 c4 10             	add    esp,0x10
1000186f:	8d 85 f0 fe ff ff    	lea    eax,[ebp-0x110]
10001875:	8b 11                	mov    edx,DWORD PTR [ecx]
10001877:	6a 00                	push   0x0
10001879:	50                   	push   eax
1000187a:	ff 52 0c             	call   DWORD PTR [edx+0xc]
1000187d:	8b d8                	mov    ebx,eax
1000187f:	8d 84 be 80 00 00 00 	lea    eax,[esi+edi*4+0x80]
10001886:	50                   	push   eax
10001887:	8b cb                	mov    ecx,ebx
10001889:	8b 13                	mov    edx,DWORD PTR [ebx]
1000188b:	ff 52 3c             	call   DWORD PTR [edx+0x3c]
1000188e:	83 ff 02             	cmp    edi,0x2
10001891:	75 0e                	jne    0x100018a1
10001893:	8b 13                	mov    edx,DWORD PTR [ebx]
10001895:	8d 86 b8 00 00 00    	lea    eax,[esi+0xb8]
1000189b:	50                   	push   eax
1000189c:	8b cb                	mov    ecx,ebx
1000189e:	ff 52 44             	call   DWORD PTR [edx+0x44]
100018a1:	8b 13                	mov    edx,DWORD PTR [ebx]
100018a3:	8b cb                	mov    ecx,ebx
100018a5:	ff 52 04             	call   DWORD PTR [edx+0x4]
100018a8:	8b 44 bd b8          	mov    eax,DWORD PTR [ebp+edi*4-0x48]
100018ac:	50                   	push   eax
100018ad:	50                   	push   eax
100018ae:	8d 85 f0 fe ff ff    	lea    eax,[ebp-0x110]
100018b4:	68 c8 e1 00 10       	push   0x1000e1c8
100018b9:	50                   	push   eax
100018ba:	e8 f1 38 00 00       	call   0x100051b0
100018bf:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
100018c5:	83 c4 10             	add    esp,0x10
100018c8:	8d 85 f0 fe ff ff    	lea    eax,[ebp-0x110]
100018ce:	8b 11                	mov    edx,DWORD PTR [ecx]
100018d0:	6a 00                	push   0x0
100018d2:	50                   	push   eax
100018d3:	ff 52 0c             	call   DWORD PTR [edx+0xc]
100018d6:	8b d8                	mov    ebx,eax
100018d8:	8d 44 be 58          	lea    eax,[esi+edi*4+0x58]
100018dc:	50                   	push   eax
100018dd:	8b cb                	mov    ecx,ebx
100018df:	8b 13                	mov    edx,DWORD PTR [ebx]
100018e1:	ff 52 3c             	call   DWORD PTR [edx+0x3c]
100018e4:	8b 13                	mov    edx,DWORD PTR [ebx]
100018e6:	8b cb                	mov    ecx,ebx
100018e8:	ff 52 04             	call   DWORD PTR [edx+0x4]
100018eb:	47                   	inc    edi
100018ec:	83 ff 0a             	cmp    edi,0xa
100018ef:	0f 8c 5a ff ff ff    	jl     0x1000184f
100018f5:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
100018fb:	6a 00                	push   0x0
100018fd:	68 ac e1 00 10       	push   0x1000e1ac
10001902:	8b 01                	mov    eax,DWORD PTR [ecx]
10001904:	ff 50 0c             	call   DWORD PTR [eax+0xc]
10001907:	8b f8                	mov    edi,eax
10001909:	8d 86 bc 00 00 00    	lea    eax,[esi+0xbc]
1000190f:	50                   	push   eax
10001910:	8b cf                	mov    ecx,edi
10001912:	8b 17                	mov    edx,DWORD PTR [edi]
10001914:	ff 52 44             	call   DWORD PTR [edx+0x44]
10001917:	8b 17                	mov    edx,DWORD PTR [edi]
10001919:	8b cf                	mov    ecx,edi
1000191b:	ff 52 04             	call   DWORD PTR [edx+0x4]
1000191e:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10001924:	6a 00                	push   0x0
10001926:	68 88 e1 00 10       	push   0x1000e188
1000192b:	8b 01                	mov    eax,DWORD PTR [ecx]
1000192d:	ff 50 0c             	call   DWORD PTR [eax+0xc]
10001930:	8d 4d f0             	lea    ecx,[ebp-0x10]
10001933:	89 86 ac 00 00 00    	mov    DWORD PTR [esi+0xac],eax
10001939:	8b 10                	mov    edx,DWORD PTR [eax]
1000193b:	51                   	push   ecx
1000193c:	8b c8                	mov    ecx,eax
1000193e:	ff 52 3c             	call   DWORD PTR [edx+0x3c]
10001941:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
10001944:	8d 45 e0             	lea    eax,[ebp-0x20]
10001947:	50                   	push   eax
10001948:	8b 11                	mov    edx,DWORD PTR [ecx]
1000194a:	ff 52 10             	call   DWORD PTR [edx+0x10]
1000194d:	8b 4d e0             	mov    ecx,DWORD PTR [ebp-0x20]
10001950:	8d 86 c0 00 00 00    	lea    eax,[esi+0xc0]
10001956:	50                   	push   eax
10001957:	6a 02                	push   0x2
10001959:	8b 11                	mov    edx,DWORD PTR [ecx]
1000195b:	ff 52 10             	call   DWORD PTR [edx+0x10]
1000195e:	8b 4d e0             	mov    ecx,DWORD PTR [ebp-0x20]
10001961:	8b 11                	mov    edx,DWORD PTR [ecx]
10001963:	ff 52 04             	call   DWORD PTR [edx+0x4]
10001966:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
10001969:	8b 01                	mov    eax,DWORD PTR [ecx]
1000196b:	ff 50 04             	call   DWORD PTR [eax+0x4]
1000196e:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10001974:	6a 00                	push   0x0
10001976:	68 6c e1 00 10       	push   0x1000e16c
1000197b:	8b 11                	mov    edx,DWORD PTR [ecx]
1000197d:	ff 52 0c             	call   DWORD PTR [edx+0xc]
10001980:	8b f8                	mov    edi,eax
10001982:	8d 4d f0             	lea    ecx,[ebp-0x10]
10001985:	51                   	push   ecx
10001986:	8b cf                	mov    ecx,edi
10001988:	8b 07                	mov    eax,DWORD PTR [edi]
1000198a:	ff 50 3c             	call   DWORD PTR [eax+0x3c]
1000198d:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
10001990:	8d 86 a8 00 00 00    	lea    eax,[esi+0xa8]
10001996:	50                   	push   eax
10001997:	8b 11                	mov    edx,DWORD PTR [ecx]
10001999:	ff 52 10             	call   DWORD PTR [edx+0x10]
1000199c:	8b 17                	mov    edx,DWORD PTR [edi]
1000199e:	8b cf                	mov    ecx,edi
100019a0:	ff 52 04             	call   DWORD PTR [edx+0x4]
100019a3:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
100019a6:	8b 01                	mov    eax,DWORD PTR [ecx]
100019a8:	ff 50 04             	call   DWORD PTR [eax+0x4]
100019ab:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
100019b1:	6a 00                	push   0x0
100019b3:	68 50 e1 00 10       	push   0x1000e150
100019b8:	8b 11                	mov    edx,DWORD PTR [ecx]
100019ba:	ff 52 0c             	call   DWORD PTR [edx+0xc]
100019bd:	8b f8                	mov    edi,eax
100019bf:	8d 8e c4 00 00 00    	lea    ecx,[esi+0xc4]
100019c5:	51                   	push   ecx
100019c6:	8b cf                	mov    ecx,edi
100019c8:	8b 07                	mov    eax,DWORD PTR [edi]
100019ca:	ff 50 3c             	call   DWORD PTR [eax+0x3c]
100019cd:	8b 17                	mov    edx,DWORD PTR [edi]
100019cf:	8b cf                	mov    ecx,edi
100019d1:	ff 52 04             	call   DWORD PTR [edx+0x4]
100019d4:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
100019da:	6a 00                	push   0x0
100019dc:	8b 01                	mov    eax,DWORD PTR [ecx]
100019de:	68 28 e1 00 10       	push   0x1000e128
100019e3:	ff 50 0c             	call   DWORD PTR [eax+0xc]
100019e6:	89 86 b0 00 00 00    	mov    DWORD PTR [esi+0xb0],eax
100019ec:	c6 86 b4 00 00 00 00 	mov    BYTE PTR [esi+0xb4],0x0
100019f3:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
100019f9:	6a 00                	push   0x0
100019fb:	68 14 e1 00 10       	push   0x1000e114
10001a00:	8b 11                	mov    edx,DWORD PTR [ecx]
10001a02:	ff 52 40             	call   DWORD PTR [edx+0x40]
10001a05:	89 86 c8 00 00 00    	mov    DWORD PTR [esi+0xc8],eax
10001a0b:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10001a11:	6a 00                	push   0x0
10001a13:	68 f8 e0 00 10       	push   0x1000e0f8
10001a18:	8b 01                	mov    eax,DWORD PTR [ecx]
10001a1a:	ff 50 40             	call   DWORD PTR [eax+0x40]
10001a1d:	89 86 d0 00 00 00    	mov    DWORD PTR [esi+0xd0],eax
10001a23:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10001a29:	6a 00                	push   0x0
10001a2b:	68 e4 e0 00 10       	push   0x1000e0e4
10001a30:	8b 11                	mov    edx,DWORD PTR [ecx]
10001a32:	ff 52 40             	call   DWORD PTR [edx+0x40]
10001a35:	89 86 cc 00 00 00    	mov    DWORD PTR [esi+0xcc],eax
10001a3b:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10001a41:	6a 00                	push   0x0
10001a43:	68 d0 e0 00 10       	push   0x1000e0d0
10001a48:	8b 01                	mov    eax,DWORD PTR [ecx]
10001a4a:	ff 50 40             	call   DWORD PTR [eax+0x40]
10001a4d:	89 86 d4 00 00 00    	mov    DWORD PTR [esi+0xd4],eax
10001a53:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10001a59:	6a 00                	push   0x0
10001a5b:	68 bc e0 00 10       	push   0x1000e0bc
10001a60:	8b 11                	mov    edx,DWORD PTR [ecx]
10001a62:	ff 52 40             	call   DWORD PTR [edx+0x40]
10001a65:	89 86 d8 00 00 00    	mov    DWORD PTR [esi+0xd8],eax
10001a6b:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10001a71:	6a 00                	push   0x0
10001a73:	68 a8 e0 00 10       	push   0x1000e0a8
10001a78:	8b 01                	mov    eax,DWORD PTR [ecx]
10001a7a:	ff 50 40             	call   DWORD PTR [eax+0x40]
10001a7d:	89 86 dc 00 00 00    	mov    DWORD PTR [esi+0xdc],eax
10001a83:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10001a89:	6a 00                	push   0x0
10001a8b:	68 94 e0 00 10       	push   0x1000e094
10001a90:	8b 11                	mov    edx,DWORD PTR [ecx]
10001a92:	ff 52 40             	call   DWORD PTR [edx+0x40]
10001a95:	89 86 e0 00 00 00    	mov    DWORD PTR [esi+0xe0],eax
10001a9b:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10001aa1:	6a 00                	push   0x0
10001aa3:	68 7c e0 00 10       	push   0x1000e07c
10001aa8:	8b 01                	mov    eax,DWORD PTR [ecx]
10001aaa:	ff 50 40             	call   DWORD PTR [eax+0x40]
10001aad:	89 86 e4 00 00 00    	mov    DWORD PTR [esi+0xe4],eax
10001ab3:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10001ab9:	6a 00                	push   0x0
10001abb:	68 64 e0 00 10       	push   0x1000e064
10001ac0:	8b 11                	mov    edx,DWORD PTR [ecx]
10001ac2:	ff 52 40             	call   DWORD PTR [edx+0x40]
10001ac5:	89 86 e8 00 00 00    	mov    DWORD PTR [esi+0xe8],eax
10001acb:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10001ad1:	6a 00                	push   0x0
10001ad3:	68 54 e0 00 10       	push   0x1000e054
10001ad8:	8b 01                	mov    eax,DWORD PTR [ecx]
10001ada:	ff 50 40             	call   DWORD PTR [eax+0x40]
10001add:	89 86 ec 00 00 00    	mov    DWORD PTR [esi+0xec],eax
10001ae3:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10001ae9:	6a 00                	push   0x0
10001aeb:	68 40 e0 00 10       	push   0x1000e040
10001af0:	8b 11                	mov    edx,DWORD PTR [ecx]
10001af2:	ff 52 40             	call   DWORD PTR [edx+0x40]
10001af5:	6a 20                	push   0x20
10001af7:	89 86 f0 00 00 00    	mov    DWORD PTR [esi+0xf0],eax
10001afd:	e8 a0 36 00 00       	call   0x100051a2
10001b02:	83 c4 04             	add    esp,0x4
10001b05:	89 45 08             	mov    DWORD PTR [ebp+0x8],eax
10001b08:	85 c0                	test   eax,eax
10001b0a:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [ebp-0x4],0x0
10001b11:	74 0a                	je     0x10001b1d
10001b13:	56                   	push   esi
10001b14:	8b c8                	mov    ecx,eax
10001b16:	e8 85 26 00 00       	call   0x100041a0
10001b1b:	eb 02                	jmp    0x10001b1f
10001b1d:	33 c0                	xor    eax,eax
10001b1f:	50                   	push   eax
10001b20:	6a 00                	push   0x0
10001b22:	8b ce                	mov    ecx,esi
10001b24:	c7 45 fc ff ff ff ff 	mov    DWORD PTR [ebp-0x4],0xffffffff
10001b2b:	e8 80 02 00 00       	call   0x10001db0
10001b30:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
10001b33:	8b c6                	mov    eax,esi
10001b35:	5f                   	pop    edi
10001b36:	5e                   	pop    esi
10001b37:	5b                   	pop    ebx
10001b38:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
10001b3f:	8b e5                	mov    esp,ebp
10001b41:	5d                   	pop    ebp
10001b42:	c2 04 00             	ret    0x4
10001b45:	90                   	nop
10001b46:	90                   	nop
10001b47:	90                   	nop
10001b48:	90                   	nop
10001b49:	90                   	nop
10001b4a:	90                   	nop
10001b4b:	90                   	nop
10001b4c:	90                   	nop
10001b4d:	90                   	nop
10001b4e:	90                   	nop
10001b4f:	90                   	nop
10001b50:	56                   	push   esi
10001b51:	8b f1                	mov    esi,ecx
10001b53:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10001b59:	8b 01                	mov    eax,DWORD PTR [ecx]
10001b5b:	ff 50 04             	call   DWORD PTR [eax+0x4]
10001b5e:	8b 4e 04             	mov    ecx,DWORD PTR [esi+0x4]
10001b61:	8b 11                	mov    edx,DWORD PTR [ecx]
10001b63:	ff 52 04             	call   DWORD PTR [edx+0x4]
10001b66:	8b 8e bc 00 00 00    	mov    ecx,DWORD PTR [esi+0xbc]
10001b6c:	8b 01                	mov    eax,DWORD PTR [ecx]
10001b6e:	ff 50 04             	call   DWORD PTR [eax+0x4]
10001b71:	8a 86 b4 00 00 00    	mov    al,BYTE PTR [esi+0xb4]
10001b77:	84 c0                	test   al,al
10001b79:	74 12                	je     0x10001b8d
10001b7b:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
10001b81:	8b 86 ac 00 00 00    	mov    eax,DWORD PTR [esi+0xac]
10001b87:	50                   	push   eax
10001b88:	8b 11                	mov    edx,DWORD PTR [ecx]
10001b8a:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
10001b8d:	8b 8e c0 00 00 00    	mov    ecx,DWORD PTR [esi+0xc0]
10001b93:	53                   	push   ebx
10001b94:	57                   	push   edi
10001b95:	8b 11                	mov    edx,DWORD PTR [ecx]
10001b97:	ff 52 04             	call   DWORD PTR [edx+0x4]
10001b9a:	8d be 80 00 00 00    	lea    edi,[esi+0x80]
10001ba0:	bb 0a 00 00 00       	mov    ebx,0xa
10001ba5:	8b 4f d8             	mov    ecx,DWORD PTR [edi-0x28]
10001ba8:	8b 01                	mov    eax,DWORD PTR [ecx]
10001baa:	ff 50 04             	call   DWORD PTR [eax+0x4]
10001bad:	8b 0f                	mov    ecx,DWORD PTR [edi]
10001baf:	8b 11                	mov    edx,DWORD PTR [ecx]
10001bb1:	ff 52 04             	call   DWORD PTR [edx+0x4]
10001bb4:	83 c7 04             	add    edi,0x4
10001bb7:	4b                   	dec    ebx
10001bb8:	75 eb                	jne    0x10001ba5
10001bba:	8b 8e c8 00 00 00    	mov    ecx,DWORD PTR [esi+0xc8]
10001bc0:	8b 01                	mov    eax,DWORD PTR [ecx]
10001bc2:	ff 50 04             	call   DWORD PTR [eax+0x4]
10001bc5:	8b 8e cc 00 00 00    	mov    ecx,DWORD PTR [esi+0xcc]
10001bcb:	8b 11                	mov    edx,DWORD PTR [ecx]
10001bcd:	ff 52 04             	call   DWORD PTR [edx+0x4]
10001bd0:	8b 8e d0 00 00 00    	mov    ecx,DWORD PTR [esi+0xd0]
10001bd6:	8b 01                	mov    eax,DWORD PTR [ecx]
10001bd8:	ff 50 04             	call   DWORD PTR [eax+0x4]
10001bdb:	8b 8e d4 00 00 00    	mov    ecx,DWORD PTR [esi+0xd4]
10001be1:	8b 11                	mov    edx,DWORD PTR [ecx]
10001be3:	ff 52 04             	call   DWORD PTR [edx+0x4]
10001be6:	8b 8e d8 00 00 00    	mov    ecx,DWORD PTR [esi+0xd8]
10001bec:	8b 01                	mov    eax,DWORD PTR [ecx]
10001bee:	ff 50 04             	call   DWORD PTR [eax+0x4]
10001bf1:	8b 8e dc 00 00 00    	mov    ecx,DWORD PTR [esi+0xdc]
10001bf7:	8b 11                	mov    edx,DWORD PTR [ecx]
10001bf9:	ff 52 04             	call   DWORD PTR [edx+0x4]
10001bfc:	8b 8e e0 00 00 00    	mov    ecx,DWORD PTR [esi+0xe0]
10001c02:	8b 01                	mov    eax,DWORD PTR [ecx]
10001c04:	ff 50 04             	call   DWORD PTR [eax+0x4]
10001c07:	8b 8e e4 00 00 00    	mov    ecx,DWORD PTR [esi+0xe4]
10001c0d:	8b 11                	mov    edx,DWORD PTR [ecx]
10001c0f:	ff 52 04             	call   DWORD PTR [edx+0x4]
10001c12:	8b 8e e8 00 00 00    	mov    ecx,DWORD PTR [esi+0xe8]
10001c18:	8b 01                	mov    eax,DWORD PTR [ecx]
10001c1a:	ff 50 04             	call   DWORD PTR [eax+0x4]
10001c1d:	8b 8e ec 00 00 00    	mov    ecx,DWORD PTR [esi+0xec]
10001c23:	8b 11                	mov    edx,DWORD PTR [ecx]
10001c25:	ff 52 04             	call   DWORD PTR [edx+0x4]
10001c28:	8b 8e f0 00 00 00    	mov    ecx,DWORD PTR [esi+0xf0]
10001c2e:	8b 01                	mov    eax,DWORD PTR [ecx]
10001c30:	ff 50 04             	call   DWORD PTR [eax+0x4]
10001c33:	8b 8e c4 00 00 00    	mov    ecx,DWORD PTR [esi+0xc4]
10001c39:	8b 11                	mov    edx,DWORD PTR [ecx]
10001c3b:	ff 52 04             	call   DWORD PTR [edx+0x4]
10001c3e:	8b 8e a8 00 00 00    	mov    ecx,DWORD PTR [esi+0xa8]
10001c44:	8b 01                	mov    eax,DWORD PTR [ecx]
10001c46:	ff 50 04             	call   DWORD PTR [eax+0x4]
10001c49:	8b 8e b8 00 00 00    	mov    ecx,DWORD PTR [esi+0xb8]
10001c4f:	8b 11                	mov    edx,DWORD PTR [ecx]
10001c51:	ff 52 04             	call   DWORD PTR [edx+0x4]
10001c54:	8d 7e 08             	lea    edi,[esi+0x8]
10001c57:	bb 14 00 00 00       	mov    ebx,0x14
10001c5c:	8b 0f                	mov    ecx,DWORD PTR [edi]
10001c5e:	8b 01                	mov    eax,DWORD PTR [ecx]
10001c60:	ff 50 04             	call   DWORD PTR [eax+0x4]
10001c63:	83 c7 04             	add    edi,0x4
10001c66:	4b                   	dec    ebx
10001c67:	75 f3                	jne    0x10001c5c
10001c69:	8b 0e                	mov    ecx,DWORD PTR [esi]
10001c6b:	5f                   	pop    edi
10001c6c:	85 c9                	test   ecx,ecx
10001c6e:	5b                   	pop    ebx
10001c6f:	74 06                	je     0x10001c77
10001c71:	8b 11                	mov    edx,DWORD PTR [ecx]
10001c73:	6a 01                	push   0x1
10001c75:	ff 12                	call   DWORD PTR [edx]
10001c77:	8b 8e b0 00 00 00    	mov    ecx,DWORD PTR [esi+0xb0]
10001c7d:	8b 01                	mov    eax,DWORD PTR [ecx]
10001c7f:	ff 50 04             	call   DWORD PTR [eax+0x4]
10001c82:	5e                   	pop    esi
10001c83:	c3                   	ret
10001c84:	90                   	nop
10001c85:	90                   	nop
10001c86:	90                   	nop
10001c87:	90                   	nop
10001c88:	90                   	nop
10001c89:	90                   	nop
10001c8a:	90                   	nop
10001c8b:	90                   	nop
10001c8c:	90                   	nop
10001c8d:	90                   	nop
10001c8e:	90                   	nop
10001c8f:	90                   	nop
10001c90:	55                   	push   ebp
10001c91:	8b ec                	mov    ebp,esp
10001c93:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10001c99:	6a ff                	push   0xffffffff
10001c9b:	68 7b c5 00 10       	push   0x1000c57b
10001ca0:	50                   	push   eax
10001ca1:	b8 18 27 00 00       	mov    eax,0x2718
10001ca6:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10001cad:	e8 4e 39 00 00       	call   0x10005600
10001cb2:	8b 0d c0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c0
10001cb8:	8d 55 f0             	lea    edx,[ebp-0x10]
10001cbb:	56                   	push   esi
10001cbc:	52                   	push   edx
10001cbd:	8b 01                	mov    eax,DWORD PTR [ecx]
10001cbf:	ff 50 44             	call   DWORD PTR [eax+0x44]
10001cc2:	6a 10                	push   0x10
10001cc4:	e8 d9 34 00 00       	call   0x100051a2
10001cc9:	83 c4 04             	add    esp,0x4
10001ccc:	89 45 ec             	mov    DWORD PTR [ebp-0x14],eax
10001ccf:	85 c0                	test   eax,eax
10001cd1:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [ebp-0x4],0x0
10001cd8:	74 10                	je     0x10001cea
10001cda:	68 70 e2 00 10       	push   0x1000e270
10001cdf:	8b c8                	mov    ecx,eax
10001ce1:	e8 aa 31 00 00       	call   0x10004e90
10001ce6:	8b f0                	mov    esi,eax
10001ce8:	eb 02                	jmp    0x10001cec
10001cea:	33 f6                	xor    esi,esi
10001cec:	8d 85 dc d8 ff ff    	lea    eax,[ebp-0x2724]
10001cf2:	68 10 27 00 00       	push   0x2710
10001cf7:	50                   	push   eax
10001cf8:	8b ce                	mov    ecx,esi
10001cfa:	c7 45 fc ff ff ff ff 	mov    DWORD PTR [ebp-0x4],0xffffffff
10001d01:	e8 aa 32 00 00       	call   0x10004fb0
10001d06:	83 f8 08             	cmp    eax,0x8
10001d09:	74 6b                	je     0x10001d76
10001d0b:	57                   	push   edi
10001d0c:	8b ce                	mov    ecx,esi
10001d0e:	e8 4d 32 00 00       	call   0x10004f60
10001d13:	56                   	push   esi
10001d14:	e8 7e 34 00 00       	call   0x10005197
10001d19:	8d bd dc d8 ff ff    	lea    edi,[ebp-0x2724]
10001d1f:	83 c9 ff             	or     ecx,0xffffffff
10001d22:	33 c0                	xor    eax,eax
10001d24:	83 c4 04             	add    esp,0x4
10001d27:	33 d2                	xor    edx,edx
10001d29:	f2 ae                	repnz scas al,BYTE PTR es:[edi]
10001d2b:	f7 d1                	not    ecx
10001d2d:	49                   	dec    ecx
10001d2e:	85 c9                	test   ecx,ecx
10001d30:	7e 2c                	jle    0x10001d5e
10001d32:	8a 84 15 dc d8 ff ff 	mov    al,BYTE PTR [ebp+edx*1-0x2724]
10001d39:	3c 0d                	cmp    al,0xd
10001d3b:	74 04                	je     0x10001d41
10001d3d:	3c 0a                	cmp    al,0xa
10001d3f:	75 08                	jne    0x10001d49
10001d41:	c6 84 15 dc d8 ff ff 	mov    BYTE PTR [ebp+edx*1-0x2724],0x20
10001d48:	20 
10001d49:	8d bd dc d8 ff ff    	lea    edi,[ebp-0x2724]
10001d4f:	83 c9 ff             	or     ecx,0xffffffff
10001d52:	33 c0                	xor    eax,eax
10001d54:	42                   	inc    edx
10001d55:	f2 ae                	repnz scas al,BYTE PTR es:[edi]
10001d57:	f7 d1                	not    ecx
10001d59:	49                   	dec    ecx
10001d5a:	3b d1                	cmp    edx,ecx
10001d5c:	7c d4                	jl     0x10001d32
10001d5e:	8b 55 f0             	mov    edx,DWORD PTR [ebp-0x10]
10001d61:	6a 0a                	push   0xa
10001d63:	8d 8d dc d8 ff ff    	lea    ecx,[ebp-0x2724]
10001d69:	6a 00                	push   0x0
10001d6b:	51                   	push   ecx
10001d6c:	52                   	push   edx
10001d6d:	e8 8e 2c 00 00       	call   0x10004a00
10001d72:	83 c4 10             	add    esp,0x10
10001d75:	5f                   	pop    edi
10001d76:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
10001d79:	6a 00                	push   0x0
10001d7b:	68 2f 01 00 00       	push   0x12f
10001d80:	68 38 e2 00 10       	push   0x1000e238
10001d85:	50                   	push   eax
10001d86:	e8 75 2c 00 00       	call   0x10004a00
10001d8b:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
10001d8e:	83 c4 10             	add    esp,0x10
10001d91:	8b 11                	mov    edx,DWORD PTR [ecx]
10001d93:	ff 52 04             	call   DWORD PTR [edx+0x4]
10001d96:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
10001d99:	33 c0                	xor    eax,eax
10001d9b:	5e                   	pop    esi
10001d9c:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
10001da3:	8b e5                	mov    esp,ebp
10001da5:	5d                   	pop    ebp
10001da6:	c2 04 00             	ret    0x4
10001da9:	90                   	nop
10001daa:	90                   	nop
10001dab:	90                   	nop
10001dac:	90                   	nop
10001dad:	90                   	nop
10001dae:	90                   	nop
10001daf:	90                   	nop
10001db0:	55                   	push   ebp
10001db1:	8b ec                	mov    ebp,esp
10001db3:	56                   	push   esi
10001db4:	8b f1                	mov    esi,ecx
10001db6:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
10001db9:	85 c9                	test   ecx,ecx
10001dbb:	74 12                	je     0x10001dcf
10001dbd:	8b 01                	mov    eax,DWORD PTR [ecx]
10001dbf:	6a 01                	push   0x1
10001dc1:	ff 10                	call   DWORD PTR [eax]
10001dc3:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
10001dc6:	33 c0                	xor    eax,eax
10001dc8:	89 0e                	mov    DWORD PTR [esi],ecx
10001dca:	5e                   	pop    esi
10001dcb:	5d                   	pop    ebp
10001dcc:	c2 08 00             	ret    0x8
10001dcf:	8b 55 0c             	mov    edx,DWORD PTR [ebp+0xc]
10001dd2:	33 c0                	xor    eax,eax
10001dd4:	89 16                	mov    DWORD PTR [esi],edx
10001dd6:	5e                   	pop    esi
10001dd7:	5d                   	pop    ebp
10001dd8:	c2 08 00             	ret    0x8
10001ddb:	90                   	nop
10001ddc:	90                   	nop
10001ddd:	90                   	nop
10001dde:	90                   	nop
10001ddf:	90                   	nop
10001de0:	55                   	push   ebp
10001de1:	8b ec                	mov    ebp,esp
10001de3:	83 ec 08             	sub    esp,0x8
10001de6:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10001dec:	8b 55 1c             	mov    edx,DWORD PTR [ebp+0x1c]
10001def:	53                   	push   ebx
10001df0:	56                   	push   esi
10001df1:	8b 01                	mov    eax,DWORD PTR [ecx]
10001df3:	57                   	push   edi
10001df4:	6a 01                	push   0x1
10001df6:	52                   	push   edx
10001df7:	68 90 e2 00 10       	push   0x1000e290
10001dfc:	ff 50 28             	call   DWORD PTR [eax+0x28]
10001dff:	8b 7d 0c             	mov    edi,DWORD PTR [ebp+0xc]
10001e02:	8b d8                	mov    ebx,eax
10001e04:	8d 45 f8             	lea    eax,[ebp-0x8]
10001e07:	83 c9 ff             	or     ecx,0xffffffff
10001e0a:	50                   	push   eax
10001e0b:	33 c0                	xor    eax,eax
10001e0d:	f2 ae                	repnz scas al,BYTE PTR es:[edi]
10001e0f:	8b 15 b8 f5 00 10    	mov    edx,DWORD PTR ds:0x1000f5b8
10001e15:	f7 d1                	not    ecx
10001e17:	8b 32                	mov    esi,DWORD PTR [edx]
10001e19:	49                   	dec    ecx
10001e1a:	51                   	push   ecx
10001e1b:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
10001e1e:	51                   	push   ecx
10001e1f:	53                   	push   ebx
10001e20:	8b ca                	mov    ecx,edx
10001e22:	ff 56 58             	call   DWORD PTR [esi+0x58]
10001e25:	8b 55 f8             	mov    edx,DWORD PTR [ebp-0x8]
10001e28:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
10001e2b:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10001e31:	6a 01                	push   0x1
10001e33:	8d 7a 04             	lea    edi,[edx+0x4]
10001e36:	89 45 1c             	mov    DWORD PTR [ebp+0x1c],eax
10001e39:	8b 11                	mov    edx,DWORD PTR [ecx]
10001e3b:	50                   	push   eax
10001e3c:	8d 04 3f             	lea    eax,[edi+edi*1]
10001e3f:	50                   	push   eax
10001e40:	ff 52 20             	call   DWORD PTR [edx+0x20]
10001e43:	8b f0                	mov    esi,eax
10001e45:	53                   	push   ebx
10001e46:	8b ce                	mov    ecx,esi
10001e48:	8b 16                	mov    edx,DWORD PTR [esi]
10001e4a:	ff 52 48             	call   DWORD PTR [edx+0x48]
10001e4d:	a0 05 f6 00 10       	mov    al,ds:0x1000f605
10001e52:	84 c0                	test   al,al
10001e54:	74 10                	je     0x10001e66
10001e56:	8b 06                	mov    eax,DWORD PTR [esi]
10001e58:	6a 33                	push   0x33
10001e5a:	68 99 00 00 00       	push   0x99
10001e5f:	68 ff 00 00 00       	push   0xff
10001e64:	eb 2c                	jmp    0x10001e92
10001e66:	83 7d 18 ff          	cmp    DWORD PTR [ebp+0x18],0xffffffff
10001e6a:	75 15                	jne    0x10001e81
10001e6c:	8b 16                	mov    edx,DWORD PTR [esi]
10001e6e:	68 ff 00 00 00       	push   0xff
10001e73:	68 cc 00 00 00       	push   0xcc
10001e78:	6a 66                	push   0x66
10001e7a:	8b ce                	mov    ecx,esi
10001e7c:	ff 52 34             	call   DWORD PTR [edx+0x34]
10001e7f:	eb 16                	jmp    0x10001e97
10001e81:	8b 06                	mov    eax,DWORD PTR [esi]
10001e83:	68 ff 00 00 00       	push   0xff
10001e88:	68 cc 00 00 00       	push   0xcc
10001e8d:	68 99 00 00 00       	push   0x99
10001e92:	8b ce                	mov    ecx,esi
10001e94:	ff 50 34             	call   DWORD PTR [eax+0x34]
10001e97:	8b 16                	mov    edx,DWORD PTR [esi]
10001e99:	6a 00                	push   0x0
10001e9b:	6a 00                	push   0x0
10001e9d:	6a 00                	push   0x0
10001e9f:	8b ce                	mov    ecx,esi
10001ea1:	ff 52 24             	call   DWORD PTR [edx+0x24]
10001ea4:	6a 00                	push   0x0
10001ea6:	6a 00                	push   0x0
10001ea8:	68 88 e2 00 10       	push   0x1000e288
10001ead:	56                   	push   esi
10001eae:	e8 4d 2b 00 00       	call   0x10004a00
10001eb3:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10001eb6:	6a 00                	push   0x0
10001eb8:	6a 00                	push   0x0
10001eba:	50                   	push   eax
10001ebb:	56                   	push   esi
10001ebc:	e8 3f 2b 00 00       	call   0x10004a00
10001ec1:	8b 16                	mov    edx,DWORD PTR [esi]
10001ec3:	83 c4 20             	add    esp,0x20
10001ec6:	8b ce                	mov    ecx,esi
10001ec8:	68 ff 00 00 00       	push   0xff
10001ecd:	68 ff 00 00 00       	push   0xff
10001ed2:	68 ff 00 00 00       	push   0xff
10001ed7:	ff 52 24             	call   DWORD PTR [edx+0x24]
10001eda:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10001edd:	6a 00                	push   0x0
10001edf:	57                   	push   edi
10001ee0:	50                   	push   eax
10001ee1:	56                   	push   esi
10001ee2:	e8 19 2b 00 00       	call   0x10004a00
10001ee7:	6a 00                	push   0x0
10001ee9:	6a 00                	push   0x0
10001eeb:	68 7c e2 00 10       	push   0x1000e27c
10001ef0:	56                   	push   esi
10001ef1:	e8 0a 2b 00 00       	call   0x10004a00
10001ef6:	8b 13                	mov    edx,DWORD PTR [ebx]
10001ef8:	83 c4 20             	add    esp,0x20
10001efb:	8b cb                	mov    ecx,ebx
10001efd:	ff 52 04             	call   DWORD PTR [edx+0x4]
10001f00:	8b 55 24             	mov    edx,DWORD PTR [ebp+0x24]
10001f03:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10001f09:	52                   	push   edx
10001f0a:	8b 55 18             	mov    edx,DWORD PTR [ebp+0x18]
10001f0d:	52                   	push   edx
10001f0e:	8b 55 1c             	mov    edx,DWORD PTR [ebp+0x1c]
10001f11:	6a 00                	push   0x0
10001f13:	56                   	push   esi
10001f14:	52                   	push   edx
10001f15:	8b 55 14             	mov    edx,DWORD PTR [ebp+0x14]
10001f18:	57                   	push   edi
10001f19:	8b 01                	mov    eax,DWORD PTR [ecx]
10001f1b:	52                   	push   edx
10001f1c:	8b 55 10             	mov    edx,DWORD PTR [ebp+0x10]
10001f1f:	52                   	push   edx
10001f20:	8b 55 20             	mov    edx,DWORD PTR [ebp+0x20]
10001f23:	52                   	push   edx
10001f24:	8b 55 08             	mov    edx,DWORD PTR [ebp+0x8]
10001f27:	52                   	push   edx
10001f28:	ff 50 30             	call   DWORD PTR [eax+0x30]
10001f2b:	8b f8                	mov    edi,eax
10001f2d:	8b 06                	mov    eax,DWORD PTR [esi]
10001f2f:	8b ce                	mov    ecx,esi
10001f31:	ff 50 04             	call   DWORD PTR [eax+0x4]
10001f34:	8b c7                	mov    eax,edi
10001f36:	5f                   	pop    edi
10001f37:	5e                   	pop    esi
10001f38:	5b                   	pop    ebx
10001f39:	8b e5                	mov    esp,ebp
10001f3b:	5d                   	pop    ebp
10001f3c:	c2 20 00             	ret    0x20
10001f3f:	90                   	nop
10001f40:	55                   	push   ebp
10001f41:	8b ec                	mov    ebp,esp
10001f43:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10001f46:	50                   	push   eax
10001f47:	8b 08                	mov    ecx,DWORD PTR [eax]
10001f49:	e8 42 fd ff ff       	call   0x10001c90
10001f4e:	5d                   	pop    ebp
10001f4f:	c3                   	ret
10001f50:	55                   	push   ebp
10001f51:	8b ec                	mov    ebp,esp
10001f53:	83 ec 28             	sub    esp,0x28
10001f56:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10001f59:	53                   	push   ebx
10001f5a:	56                   	push   esi
10001f5b:	8b f1                	mov    esi,ecx
10001f5d:	c7 45 d8 05 00 00 00 	mov    DWORD PTR [ebp-0x28],0x5
10001f64:	c7 45 dc 07 00 00 00 	mov    DWORD PTR [ebp-0x24],0x7
10001f6b:	89 46 38             	mov    DWORD PTR [esi+0x38],eax
10001f6e:	c7 45 e0 0a 00 00 00 	mov    DWORD PTR [ebp-0x20],0xa
10001f75:	c7 45 e4 0d 00 00 00 	mov    DWORD PTR [ebp-0x1c],0xd
10001f7c:	c7 45 e8 12 00 00 00 	mov    DWORD PTR [ebp-0x18],0x12
10001f83:	c7 45 ec 17 00 00 00 	mov    DWORD PTR [ebp-0x14],0x17
10001f8a:	c7 45 f0 1e 00 00 00 	mov    DWORD PTR [ebp-0x10],0x1e
10001f91:	c7 45 f4 23 00 00 00 	mov    DWORD PTR [ebp-0xc],0x23
10001f98:	c7 45 f8 28 00 00 00 	mov    DWORD PTR [ebp-0x8],0x28
10001f9f:	c7 45 fc 2d 00 00 00 	mov    DWORD PTR [ebp-0x4],0x2d
10001fa6:	b9 01 00 00 00       	mov    ecx,0x1
10001fab:	33 c0                	xor    eax,eax
10001fad:	8b 54 05 dc          	mov    edx,DWORD PTR [ebp+eax*1-0x24]
10001fb1:	41                   	inc    ecx
10001fb2:	0f af d1             	imul   edx,ecx
10001fb5:	8b 98 98 e2 00 10    	mov    ebx,DWORD PTR [eax+0x1000e298]
10001fbb:	83 c0 04             	add    eax,0x4
10001fbe:	03 d3                	add    edx,ebx
10001fc0:	83 f8 24             	cmp    eax,0x24
10001fc3:	89 90 98 e2 00 10    	mov    DWORD PTR [eax+0x1000e298],edx
10001fc9:	7c e2                	jl     0x10001fad
10001fcb:	a1 08 f6 00 10       	mov    eax,ds:0x1000f608
10001fd0:	6a 01                	push   0x1
10001fd2:	8b ce                	mov    ecx,esi
10001fd4:	89 06                	mov    DWORD PTR [esi],eax
10001fd6:	c7 46 0c 00 00 00 00 	mov    DWORD PTR [esi+0xc],0x0
10001fdd:	e8 ae 00 00 00       	call   0x10002090
10001fe2:	8b 0e                	mov    ecx,DWORD PTR [esi]
10001fe4:	c7 46 2c 00 00 00 00 	mov    DWORD PTR [esi+0x2c],0x0
10001feb:	c7 46 34 00 00 00 00 	mov    DWORD PTR [esi+0x34],0x0
10001ff2:	8b 14 8d 94 e2 00 10 	mov    edx,DWORD PTR [ecx*4+0x1000e294]
10001ff9:	8b ce                	mov    ecx,esi
10001ffb:	89 56 30             	mov    DWORD PTR [esi+0x30],edx
10001ffe:	e8 2d 00 00 00       	call   0x10002030
10002003:	8b c6                	mov    eax,esi
10002005:	5e                   	pop    esi
10002006:	5b                   	pop    ebx
10002007:	8b e5                	mov    esp,ebp
10002009:	5d                   	pop    ebp
1000200a:	c2 04 00             	ret    0x4
1000200d:	90                   	nop
1000200e:	90                   	nop
1000200f:	90                   	nop
10002010:	56                   	push   esi
10002011:	8b f1                	mov    esi,ecx
10002013:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
10002019:	8b 56 0c             	mov    edx,DWORD PTR [esi+0xc]
1000201c:	8b 01                	mov    eax,DWORD PTR [ecx]
1000201e:	52                   	push   edx
1000201f:	ff 50 1c             	call   DWORD PTR [eax+0x1c]
10002022:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
10002025:	8b 01                	mov    eax,DWORD PTR [ecx]
10002027:	ff 50 04             	call   DWORD PTR [eax+0x4]
1000202a:	5e                   	pop    esi
1000202b:	c3                   	ret
1000202c:	90                   	nop
1000202d:	90                   	nop
1000202e:	90                   	nop
1000202f:	90                   	nop
10002030:	53                   	push   ebx
10002031:	56                   	push   esi
10002032:	8b f1                	mov    esi,ecx
10002034:	57                   	push   edi
10002035:	6a 01                	push   0x1
10002037:	db 46 20             	fild   DWORD PTR [esi+0x20]
1000203a:	c6 46 04 00          	mov    BYTE PTR [esi+0x4],0x0
1000203e:	d8 0d 2c d1 00 10    	fmul   DWORD PTR ds:0x1000d12c
10002044:	d8 2d 40 d1 00 10    	fsubr  DWORD PTR ds:0x1000d140
1000204a:	d9 5e 10             	fstp   DWORD PTR [esi+0x10]
1000204d:	db 46 24             	fild   DWORD PTR [esi+0x24]
10002050:	d8 0d 2c d1 00 10    	fmul   DWORD PTR ds:0x1000d12c
10002056:	d8 2d 3c d1 00 10    	fsubr  DWORD PTR ds:0x1000d13c
1000205c:	d9 5e 14             	fstp   DWORD PTR [esi+0x14]
1000205f:	e8 2c 00 00 00       	call   0x10002090
10002064:	8b 7e 0c             	mov    edi,DWORD PTR [esi+0xc]
10002067:	6a 00                	push   0x0
10002069:	d9 46 14             	fld    DWORD PTR [esi+0x14]
1000206c:	8b 1f                	mov    ebx,DWORD PTR [edi]
1000206e:	e8 9d 30 00 00       	call   0x10005110
10002073:	d9 46 10             	fld    DWORD PTR [esi+0x10]
10002076:	50                   	push   eax
10002077:	e8 94 30 00 00       	call   0x10005110
1000207c:	50                   	push   eax
1000207d:	8b cf                	mov    ecx,edi
1000207f:	ff 53 08             	call   DWORD PTR [ebx+0x8]
10002082:	33 c0                	xor    eax,eax
10002084:	5f                   	pop    edi
10002085:	89 46 18             	mov    DWORD PTR [esi+0x18],eax
10002088:	89 46 1c             	mov    DWORD PTR [esi+0x1c],eax
1000208b:	5e                   	pop    esi
1000208c:	5b                   	pop    ebx
1000208d:	c3                   	ret
1000208e:	90                   	nop
1000208f:	90                   	nop
10002090:	55                   	push   ebp
10002091:	8b ec                	mov    ebp,esp
10002093:	8a 45 08             	mov    al,BYTE PTR [ebp+0x8]
10002096:	56                   	push   esi
10002097:	8b f1                	mov    esi,ecx
10002099:	57                   	push   edi
1000209a:	88 46 28             	mov    BYTE PTR [esi+0x28],al
1000209d:	8b 46 0c             	mov    eax,DWORD PTR [esi+0xc]
100020a0:	85 c0                	test   eax,eax
100020a2:	74 14                	je     0x100020b8
100020a4:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
100020aa:	50                   	push   eax
100020ab:	8b 11                	mov    edx,DWORD PTR [ecx]
100020ad:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
100020b0:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
100020b3:	8b 01                	mov    eax,DWORD PTR [ecx]
100020b5:	ff 50 04             	call   DWORD PTR [eax+0x4]
100020b8:	8a 46 28             	mov    al,BYTE PTR [esi+0x28]
100020bb:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
100020c1:	8b 3d cc f5 00 10    	mov    edi,DWORD PTR ds:0x1000f5cc
100020c7:	6a 00                	push   0x0
100020c9:	8b 11                	mov    edx,DWORD PTR [ecx]
100020cb:	84 c0                	test   al,al
100020cd:	8b 06                	mov    eax,DWORD PTR [esi]
100020cf:	74 06                	je     0x100020d7
100020d1:	8b 44 87 54          	mov    eax,DWORD PTR [edi+eax*4+0x54]
100020d5:	eb 04                	jmp    0x100020db
100020d7:	8b 44 87 7c          	mov    eax,DWORD PTR [edi+eax*4+0x7c]
100020db:	50                   	push   eax
100020dc:	ff 52 08             	call   DWORD PTR [edx+0x8]
100020df:	89 46 0c             	mov    DWORD PTR [esi+0xc],eax
100020e2:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
100020e8:	50                   	push   eax
100020e9:	8b 11                	mov    edx,DWORD PTR [ecx]
100020eb:	ff 52 18             	call   DWORD PTR [edx+0x18]
100020ee:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
100020f1:	8b 11                	mov    edx,DWORD PTR [ecx]
100020f3:	ff 52 2c             	call   DWORD PTR [edx+0x2c]
100020f6:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
100020f9:	8d 56 24             	lea    edx,[esi+0x24]
100020fc:	83 c6 20             	add    esi,0x20
100020ff:	52                   	push   edx
10002100:	8b 01                	mov    eax,DWORD PTR [ecx]
10002102:	56                   	push   esi
10002103:	ff 50 48             	call   DWORD PTR [eax+0x48]
10002106:	5f                   	pop    edi
10002107:	5e                   	pop    esi
10002108:	5d                   	pop    ebp
10002109:	c2 04 00             	ret    0x4
1000210c:	90                   	nop
1000210d:	90                   	nop
1000210e:	90                   	nop
1000210f:	90                   	nop
10002110:	55                   	push   ebp
10002111:	8b ec                	mov    ebp,esp
10002113:	83 ec 08             	sub    esp,0x8
10002116:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10002119:	56                   	push   esi
1000211a:	8b f1                	mov    esi,ecx
1000211c:	48                   	dec    eax
1000211d:	b9 03 00 00 00       	mov    ecx,0x3
10002122:	c7 45 f8 cd cc cc 3d 	mov    DWORD PTR [ebp-0x8],0x3dcccccd
10002129:	3b c1                	cmp    eax,ecx
1000212b:	c7 45 fc 00 00 80 3f 	mov    DWORD PTR [ebp-0x4],0x3f800000
10002132:	0f 87 ce 01 00 00    	ja     0x10002306
10002138:	ff 24 85 14 23 00 10 	jmp    DWORD PTR [eax*4+0x10002314]
1000213f:	8a 46 28             	mov    al,BYTE PTR [esi+0x28]
10002142:	84 c0                	test   al,al
10002144:	75 09                	jne    0x1000214f
10002146:	6a 01                	push   0x1
10002148:	8b ce                	mov    ecx,esi
1000214a:	e8 41 ff ff ff       	call   0x10002090
1000214f:	f6 05 f0 f5 00 10 0c 	test   BYTE PTR ds:0x1000f5f0,0xc
10002156:	74 0e                	je     0x10002166
10002158:	c7 45 f8 2a cb 90 3d 	mov    DWORD PTR [ebp-0x8],0x3d90cb2a
1000215f:	c7 45 fc f4 fd 34 3f 	mov    DWORD PTR [ebp-0x4],0x3f34fdf4
10002166:	d9 46 18             	fld    DWORD PTR [esi+0x18]
10002169:	d8 1d 04 d1 00 10    	fcomp  DWORD PTR ds:0x1000d104
1000216f:	d9 45 fc             	fld    DWORD PTR [ebp-0x4]
10002172:	d9 e0                	fchs
10002174:	df e0                	fnstsw ax
10002176:	f6 c4 41             	test   ah,0x41
10002179:	75 2b                	jne    0x100021a6
1000217b:	d9 45 f8             	fld    DWORD PTR [ebp-0x8]
1000217e:	dc c0                	fadd   st(0),st
10002180:	d8 6e 18             	fsubr  DWORD PTR [esi+0x18]
10002183:	d9 5d 08             	fstp   DWORD PTR [ebp+0x8]
10002186:	d8 55 08             	fcom   DWORD PTR [ebp+0x8]
10002189:	df e0                	fnstsw ax
1000218b:	f6 c4 41             	test   ah,0x41
1000218e:	74 05                	je     0x10002195
10002190:	dd d8                	fstp   st(0)
10002192:	d9 45 08             	fld    DWORD PTR [ebp+0x8]
10002195:	d9 5e 18             	fstp   DWORD PTR [esi+0x18]
10002198:	8b ce                	mov    ecx,esi
1000219a:	e8 91 01 00 00       	call   0x10002330
1000219f:	5e                   	pop    esi
100021a0:	8b e5                	mov    esp,ebp
100021a2:	5d                   	pop    ebp
100021a3:	c2 04 00             	ret    0x4
100021a6:	d9 46 18             	fld    DWORD PTR [esi+0x18]
100021a9:	d8 65 f8             	fsub   DWORD PTR [ebp-0x8]
100021ac:	d9 5d 08             	fstp   DWORD PTR [ebp+0x8]
100021af:	d8 55 08             	fcom   DWORD PTR [ebp+0x8]
100021b2:	df e0                	fnstsw ax
100021b4:	f6 c4 41             	test   ah,0x41
100021b7:	74 05                	je     0x100021be
100021b9:	dd d8                	fstp   st(0)
100021bb:	d9 45 08             	fld    DWORD PTR [ebp+0x8]
100021be:	d9 5e 18             	fstp   DWORD PTR [esi+0x18]
100021c1:	8b ce                	mov    ecx,esi
100021c3:	e8 68 01 00 00       	call   0x10002330
100021c8:	5e                   	pop    esi
100021c9:	8b e5                	mov    esp,ebp
100021cb:	5d                   	pop    ebp
100021cc:	c2 04 00             	ret    0x4
100021cf:	8a 46 28             	mov    al,BYTE PTR [esi+0x28]
100021d2:	84 c0                	test   al,al
100021d4:	74 09                	je     0x100021df
100021d6:	6a 00                	push   0x0
100021d8:	8b ce                	mov    ecx,esi
100021da:	e8 b1 fe ff ff       	call   0x10002090
100021df:	f6 05 f0 f5 00 10 0c 	test   BYTE PTR ds:0x1000f5f0,0xc
100021e6:	74 0e                	je     0x100021f6
100021e8:	c7 45 f8 2a cb 90 3d 	mov    DWORD PTR [ebp-0x8],0x3d90cb2a
100021ef:	c7 45 fc f4 fd 34 3f 	mov    DWORD PTR [ebp-0x4],0x3f34fdf4
100021f6:	d9 46 18             	fld    DWORD PTR [esi+0x18]
100021f9:	d8 1d 04 d1 00 10    	fcomp  DWORD PTR ds:0x1000d104
100021ff:	d9 45 f8             	fld    DWORD PTR [ebp-0x8]
10002202:	df e0                	fnstsw ax
10002204:	f6 c4 01             	test   ah,0x1
10002207:	74 02                	je     0x1000220b
10002209:	dc c0                	fadd   st(0),st
1000220b:	d8 46 18             	fadd   DWORD PTR [esi+0x18]
1000220e:	d9 45 fc             	fld    DWORD PTR [ebp-0x4]
10002211:	d8 d9                	fcomp  st(1)
10002213:	df e0                	fnstsw ax
10002215:	f6 c4 01             	test   ah,0x1
10002218:	74 05                	je     0x1000221f
1000221a:	dd d8                	fstp   st(0)
1000221c:	d9 45 fc             	fld    DWORD PTR [ebp-0x4]
1000221f:	d9 5e 18             	fstp   DWORD PTR [esi+0x18]
10002222:	8b ce                	mov    ecx,esi
10002224:	e8 07 01 00 00       	call   0x10002330
10002229:	5e                   	pop    esi
1000222a:	8b e5                	mov    esp,ebp
1000222c:	5d                   	pop    ebp
1000222d:	c2 04 00             	ret    0x4
10002230:	84 0d f0 f5 00 10    	test   BYTE PTR ds:0x1000f5f0,cl
10002236:	74 0e                	je     0x10002246
10002238:	c7 45 f8 2a cb 90 3d 	mov    DWORD PTR [ebp-0x8],0x3d90cb2a
1000223f:	c7 45 fc f4 fd 34 3f 	mov    DWORD PTR [ebp-0x4],0x3f34fdf4
10002246:	d9 46 1c             	fld    DWORD PTR [esi+0x1c]
10002249:	d8 1d 04 d1 00 10    	fcomp  DWORD PTR ds:0x1000d104
1000224f:	d9 45 fc             	fld    DWORD PTR [ebp-0x4]
10002252:	d9 e0                	fchs
10002254:	df e0                	fnstsw ax
10002256:	f6 c4 41             	test   ah,0x41
10002259:	75 2f                	jne    0x1000228a
1000225b:	d9 45 f8             	fld    DWORD PTR [ebp-0x8]
1000225e:	dc c0                	fadd   st(0),st
10002260:	d8 6e 1c             	fsubr  DWORD PTR [esi+0x1c]
10002263:	d9 5d 08             	fstp   DWORD PTR [ebp+0x8]
10002266:	d8 55 08             	fcom   DWORD PTR [ebp+0x8]
10002269:	df e0                	fnstsw ax
1000226b:	f6 c4 41             	test   ah,0x41
1000226e:	0f 84 8f 00 00 00    	je     0x10002303
10002274:	dd d8                	fstp   st(0)
10002276:	d9 45 08             	fld    DWORD PTR [ebp+0x8]
10002279:	8b ce                	mov    ecx,esi
1000227b:	d9 5e 1c             	fstp   DWORD PTR [esi+0x1c]
1000227e:	e8 ad 00 00 00       	call   0x10002330
10002283:	5e                   	pop    esi
10002284:	8b e5                	mov    esp,ebp
10002286:	5d                   	pop    ebp
10002287:	c2 04 00             	ret    0x4
1000228a:	d9 46 1c             	fld    DWORD PTR [esi+0x1c]
1000228d:	d8 65 f8             	fsub   DWORD PTR [ebp-0x8]
10002290:	d9 5d 08             	fstp   DWORD PTR [ebp+0x8]
10002293:	d8 55 08             	fcom   DWORD PTR [ebp+0x8]
10002296:	df e0                	fnstsw ax
10002298:	f6 c4 41             	test   ah,0x41
1000229b:	74 66                	je     0x10002303
1000229d:	dd d8                	fstp   st(0)
1000229f:	d9 45 08             	fld    DWORD PTR [ebp+0x8]
100022a2:	8b ce                	mov    ecx,esi
100022a4:	d9 5e 1c             	fstp   DWORD PTR [esi+0x1c]
100022a7:	e8 84 00 00 00       	call   0x10002330
100022ac:	5e                   	pop    esi
100022ad:	8b e5                	mov    esp,ebp
100022af:	5d                   	pop    ebp
100022b0:	c2 04 00             	ret    0x4
100022b3:	84 0d f0 f5 00 10    	test   BYTE PTR ds:0x1000f5f0,cl
100022b9:	74 0e                	je     0x100022c9
100022bb:	c7 45 f8 2a cb 90 3d 	mov    DWORD PTR [ebp-0x8],0x3d90cb2a
100022c2:	c7 45 fc f4 fd 34 3f 	mov    DWORD PTR [ebp-0x4],0x3f34fdf4
100022c9:	d9 46 1c             	fld    DWORD PTR [esi+0x1c]
100022cc:	d8 1d 04 d1 00 10    	fcomp  DWORD PTR ds:0x1000d104
100022d2:	d9 45 f8             	fld    DWORD PTR [ebp-0x8]
100022d5:	df e0                	fnstsw ax
100022d7:	f6 c4 01             	test   ah,0x1
100022da:	74 13                	je     0x100022ef
100022dc:	dc c0                	fadd   st(0),st
100022de:	d8 46 1c             	fadd   DWORD PTR [esi+0x1c]
100022e1:	d9 45 fc             	fld    DWORD PTR [ebp-0x4]
100022e4:	d8 d9                	fcomp  st(1)
100022e6:	df e0                	fnstsw ax
100022e8:	f6 c4 01             	test   ah,0x1
100022eb:	74 16                	je     0x10002303
100022ed:	eb 0f                	jmp    0x100022fe
100022ef:	d8 46 1c             	fadd   DWORD PTR [esi+0x1c]
100022f2:	d9 45 fc             	fld    DWORD PTR [ebp-0x4]
100022f5:	d8 d9                	fcomp  st(1)
100022f7:	df e0                	fnstsw ax
100022f9:	f6 c4 01             	test   ah,0x1
100022fc:	74 05                	je     0x10002303
100022fe:	dd d8                	fstp   st(0)
10002300:	d9 45 fc             	fld    DWORD PTR [ebp-0x4]
10002303:	d9 5e 1c             	fstp   DWORD PTR [esi+0x1c]
10002306:	8b ce                	mov    ecx,esi
10002308:	e8 23 00 00 00       	call   0x10002330
1000230d:	5e                   	pop    esi
1000230e:	8b e5                	mov    esp,ebp
10002310:	5d                   	pop    ebp
10002311:	c2 04 00             	ret    0x4
10002314:	3f                   	aas
10002315:	21 00                	and    DWORD PTR [eax],eax
10002317:	10 cf                	adc    bh,cl
10002319:	21 00                	and    DWORD PTR [eax],eax
1000231b:	10 30                	adc    BYTE PTR [eax],dh
1000231d:	22 00                	and    al,BYTE PTR [eax]
1000231f:	10 b3 22 00 10 90    	adc    BYTE PTR [ebx-0x6fefffde],dh
10002325:	90                   	nop
10002326:	90                   	nop
10002327:	90                   	nop
10002328:	90                   	nop
10002329:	90                   	nop
1000232a:	90                   	nop
1000232b:	90                   	nop
1000232c:	90                   	nop
1000232d:	90                   	nop
1000232e:	90                   	nop
1000232f:	90                   	nop
10002330:	55                   	push   ebp
10002331:	8b ec                	mov    ebp,esp
10002333:	83 ec 20             	sub    esp,0x20
10002336:	a0 d4 f5 00 10       	mov    al,ds:0x1000f5d4
1000233b:	53                   	push   ebx
1000233c:	56                   	push   esi
1000233d:	8b f1                	mov    esi,ecx
1000233f:	b1 01                	mov    cl,0x1
10002341:	57                   	push   edi
10002342:	84 c1                	test   cl,al
10002344:	a1 e0 f5 00 10       	mov    eax,ds:0x1000f5e0
10002349:	75 13                	jne    0x1000235e
1000234b:	8a 15 d4 f5 00 10    	mov    dl,BYTE PTR ds:0x1000f5d4
10002351:	a3 d0 f5 00 10       	mov    ds:0x1000f5d0,eax
10002356:	0a d1                	or     dl,cl
10002358:	88 15 d4 f5 00 10    	mov    BYTE PTR ds:0x1000f5d4,dl
1000235e:	8b 1d d0 f5 00 10    	mov    ebx,DWORD PTR ds:0x1000f5d0
10002364:	33 c9                	xor    ecx,ecx
10002366:	2b c3                	sub    eax,ebx
10002368:	89 4d e4             	mov    DWORD PTR [ebp-0x1c],ecx
1000236b:	89 45 e0             	mov    DWORD PTR [ebp-0x20],eax
1000236e:	8b 46 20             	mov    eax,DWORD PTR [esi+0x20]
10002371:	df 6d e0             	fild   QWORD PTR [ebp-0x20]
10002374:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
10002377:	99                   	cdq
10002378:	d9 c0                	fld    st(0)
1000237a:	d8 4e 18             	fmul   DWORD PTR [esi+0x18]
1000237d:	2b c2                	sub    eax,edx
1000237f:	d1 f8                	sar    eax,1
10002381:	d8 0d 44 d1 00 10    	fmul   DWORD PTR ds:0x1000d144
10002387:	89 45 e8             	mov    DWORD PTR [ebp-0x18],eax
1000238a:	8b 46 24             	mov    eax,DWORD PTR [esi+0x24]
1000238d:	99                   	cdq
1000238e:	d9 5d e4             	fstp   DWORD PTR [ebp-0x1c]
10002391:	2b c2                	sub    eax,edx
10002393:	d8 4e 1c             	fmul   DWORD PTR [esi+0x1c]
10002396:	d1 f8                	sar    eax,1
10002398:	d8 0d 44 d1 00 10    	fmul   DWORD PTR ds:0x1000d144
1000239e:	db 45 e8             	fild   DWORD PTR [ebp-0x18]
100023a1:	89 45 e8             	mov    DWORD PTR [ebp-0x18],eax
100023a4:	d9 5d f0             	fstp   DWORD PTR [ebp-0x10]
100023a7:	d9 46 10             	fld    DWORD PTR [esi+0x10]
100023aa:	d8 25 34 d1 00 10    	fsub   DWORD PTR ds:0x1000d134
100023b0:	d8 45 f0             	fadd   DWORD PTR [ebp-0x10]
100023b3:	d8 45 e4             	fadd   DWORD PTR [ebp-0x1c]
100023b6:	d9 5d fc             	fstp   DWORD PTR [ebp-0x4]
100023b9:	db 45 e8             	fild   DWORD PTR [ebp-0x18]
100023bc:	d9 5d e8             	fstp   DWORD PTR [ebp-0x18]
100023bf:	d9 46 14             	fld    DWORD PTR [esi+0x14]
100023c2:	d8 25 30 d1 00 10    	fsub   DWORD PTR ds:0x1000d130
100023c8:	d8 45 e8             	fadd   DWORD PTR [ebp-0x18]
100023cb:	d8 c1                	fadd   st,st(1)
100023cd:	d9 55 f4             	fst    DWORD PTR [ebp-0xc]
100023d0:	d8 4d f4             	fmul   DWORD PTR [ebp-0xc]
100023d3:	d9 45 fc             	fld    DWORD PTR [ebp-0x4]
100023d6:	d8 4d fc             	fmul   DWORD PTR [ebp-0x4]
100023d9:	de c1                	faddp  st(1),st
100023db:	d9 55 ec             	fst    DWORD PTR [ebp-0x14]
100023de:	db 45 f8             	fild   DWORD PTR [ebp-0x8]
100023e1:	d8 0d 2c d1 00 10    	fmul   DWORD PTR ds:0x1000d12c
100023e7:	d8 2d 28 d1 00 10    	fsubr  DWORD PTR ds:0x1000d128
100023ed:	d9 c0                	fld    st(0)
100023ef:	d8 c9                	fmul   st,st(1)
100023f1:	d9 5d f8             	fstp   DWORD PTR [ebp-0x8]
100023f4:	dd d8                	fstp   st(0)
100023f6:	d8 5d f8             	fcomp  DWORD PTR [ebp-0x8]
100023f9:	df e0                	fnstsw ax
100023fb:	f6 c4 01             	test   ah,0x1
100023fe:	75 34                	jne    0x10002434
10002400:	dd d8                	fstp   st(0)
10002402:	d9 45 f8             	fld    DWORD PTR [ebp-0x8]
10002405:	d8 4d fc             	fmul   DWORD PTR [ebp-0x4]
10002408:	89 4e 18             	mov    DWORD PTR [esi+0x18],ecx
1000240b:	89 4e 1c             	mov    DWORD PTR [esi+0x1c],ecx
1000240e:	d8 75 ec             	fdiv   DWORD PTR [ebp-0x14]
10002411:	d8 05 34 d1 00 10    	fadd   DWORD PTR ds:0x1000d134
10002417:	d8 65 f0             	fsub   DWORD PTR [ebp-0x10]
1000241a:	d9 5e 10             	fstp   DWORD PTR [esi+0x10]
1000241d:	d9 45 f8             	fld    DWORD PTR [ebp-0x8]
10002420:	d8 4d f4             	fmul   DWORD PTR [ebp-0xc]
10002423:	d8 75 ec             	fdiv   DWORD PTR [ebp-0x14]
10002426:	d8 05 30 d1 00 10    	fadd   DWORD PTR ds:0x1000d130
1000242c:	d8 65 e8             	fsub   DWORD PTR [ebp-0x18]
1000242f:	d9 5e 14             	fstp   DWORD PTR [esi+0x14]
10002432:	eb 0f                	jmp    0x10002443
10002434:	d9 45 e4             	fld    DWORD PTR [ebp-0x1c]
10002437:	d8 46 10             	fadd   DWORD PTR [esi+0x10]
1000243a:	d9 5e 10             	fstp   DWORD PTR [esi+0x10]
1000243d:	d8 46 14             	fadd   DWORD PTR [esi+0x14]
10002440:	d9 5e 14             	fstp   DWORD PTR [esi+0x14]
10002443:	8b 7e 0c             	mov    edi,DWORD PTR [esi+0xc]
10002446:	51                   	push   ecx
10002447:	d9 46 14             	fld    DWORD PTR [esi+0x14]
1000244a:	8b 1f                	mov    ebx,DWORD PTR [edi]
1000244c:	e8 bf 2c 00 00       	call   0x10005110
10002451:	d9 46 10             	fld    DWORD PTR [esi+0x10]
10002454:	50                   	push   eax
10002455:	e8 b6 2c 00 00       	call   0x10005110
1000245a:	50                   	push   eax
1000245b:	8b cf                	mov    ecx,edi
1000245d:	ff 53 08             	call   DWORD PTR [ebx+0x8]
10002460:	a1 e0 f5 00 10       	mov    eax,ds:0x1000f5e0
10002465:	5f                   	pop    edi
10002466:	5e                   	pop    esi
10002467:	a3 d0 f5 00 10       	mov    ds:0x1000f5d0,eax
1000246c:	5b                   	pop    ebx
1000246d:	8b e5                	mov    esp,ebp
1000246f:	5d                   	pop    ebp
10002470:	c3                   	ret
10002471:	90                   	nop
10002472:	90                   	nop
10002473:	90                   	nop
10002474:	90                   	nop
10002475:	90                   	nop
10002476:	90                   	nop
10002477:	90                   	nop
10002478:	90                   	nop
10002479:	90                   	nop
1000247a:	90                   	nop
1000247b:	90                   	nop
1000247c:	90                   	nop
1000247d:	90                   	nop
1000247e:	90                   	nop
1000247f:	90                   	nop
10002480:	55                   	push   ebp
10002481:	8b ec                	mov    ebp,esp
10002483:	56                   	push   esi
10002484:	8b f1                	mov    esi,ecx
10002486:	57                   	push   edi
10002487:	d9 46 10             	fld    DWORD PTR [esi+0x10]
1000248a:	e8 81 2c 00 00       	call   0x10005110
1000248f:	8b c8                	mov    ecx,eax
10002491:	8b 46 20             	mov    eax,DWORD PTR [esi+0x20]
10002494:	8b 7d 08             	mov    edi,DWORD PTR [ebp+0x8]
10002497:	99                   	cdq
10002498:	2b c2                	sub    eax,edx
1000249a:	d1 f8                	sar    eax,1
1000249c:	2b c8                	sub    ecx,eax
1000249e:	89 0f                	mov    DWORD PTR [edi],ecx
100024a0:	d9 46 14             	fld    DWORD PTR [esi+0x14]
100024a3:	e8 68 2c 00 00       	call   0x10005110
100024a8:	8b c8                	mov    ecx,eax
100024aa:	8b 46 24             	mov    eax,DWORD PTR [esi+0x24]
100024ad:	99                   	cdq
100024ae:	2b c2                	sub    eax,edx
100024b0:	8b 17                	mov    edx,DWORD PTR [edi]
100024b2:	d1 f8                	sar    eax,1
100024b4:	2b c8                	sub    ecx,eax
100024b6:	89 4f 04             	mov    DWORD PTR [edi+0x4],ecx
100024b9:	8b 46 20             	mov    eax,DWORD PTR [esi+0x20]
100024bc:	03 d0                	add    edx,eax
100024be:	8b c1                	mov    eax,ecx
100024c0:	89 57 08             	mov    DWORD PTR [edi+0x8],edx
100024c3:	8b 4e 24             	mov    ecx,DWORD PTR [esi+0x24]
100024c6:	03 c1                	add    eax,ecx
100024c8:	89 47 0c             	mov    DWORD PTR [edi+0xc],eax
100024cb:	5f                   	pop    edi
100024cc:	5e                   	pop    esi
100024cd:	5d                   	pop    ebp
100024ce:	c2 04 00             	ret    0x4
100024d1:	90                   	nop
100024d2:	90                   	nop
100024d3:	90                   	nop
100024d4:	90                   	nop
100024d5:	90                   	nop
100024d6:	90                   	nop
100024d7:	90                   	nop
100024d8:	90                   	nop
100024d9:	90                   	nop
100024da:	90                   	nop
100024db:	90                   	nop
100024dc:	90                   	nop
100024dd:	90                   	nop
100024de:	90                   	nop
100024df:	90                   	nop
100024e0:	55                   	push   ebp
100024e1:	8b ec                	mov    ebp,esp
100024e3:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100024e6:	56                   	push   esi
100024e7:	8b f1                	mov    esi,ecx
100024e9:	8b 00                	mov    eax,DWORD PTR [eax]
100024eb:	39 06                	cmp    DWORD PTR [esi],eax
100024ed:	7d 07                	jge    0x100024f6
100024ef:	b0 01                	mov    al,0x1
100024f1:	5e                   	pop    esi
100024f2:	5d                   	pop    ebp
100024f3:	c2 04 00             	ret    0x4
100024f6:	8b 4e 2c             	mov    ecx,DWORD PTR [esi+0x2c]
100024f9:	8d 14 80             	lea    edx,[eax+eax*4]
100024fc:	03 c8                	add    ecx,eax
100024fe:	89 4e 2c             	mov    DWORD PTR [esi+0x2c],ecx
10002501:	8b 4e 38             	mov    ecx,DWORD PTR [esi+0x38]
10002504:	d1 e2                	shl    edx,1
10002506:	8b 41 08             	mov    eax,DWORD PTR [ecx+0x8]
10002509:	03 c2                	add    eax,edx
1000250b:	89 41 08             	mov    DWORD PTR [ecx+0x8],eax
1000250e:	8b 4e 38             	mov    ecx,DWORD PTR [esi+0x38]
10002511:	e8 ba 15 00 00       	call   0x10003ad0
10002516:	a1 cc f5 00 10       	mov    eax,ds:0x1000f5cc
1000251b:	6a 00                	push   0x0
1000251d:	8b 88 dc 00 00 00    	mov    ecx,DWORD PTR [eax+0xdc]
10002523:	8b 11                	mov    edx,DWORD PTR [ecx]
10002525:	ff 52 08             	call   DWORD PTR [edx+0x8]
10002528:	8b 46 2c             	mov    eax,DWORD PTR [esi+0x2c]
1000252b:	8b 4e 30             	mov    ecx,DWORD PTR [esi+0x30]
1000252e:	3b c1                	cmp    eax,ecx
10002530:	0f 8c ac 00 00 00    	jl     0x100025e2
10002536:	8b 0d cc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5cc
1000253c:	6a 00                	push   0x0
1000253e:	8b 89 e0 00 00 00    	mov    ecx,DWORD PTR [ecx+0xe0]
10002544:	8b 11                	mov    edx,DWORD PTR [ecx]
10002546:	ff 52 08             	call   DWORD PTR [edx+0x8]
10002549:	8b 06                	mov    eax,DWORD PTR [esi]
1000254b:	83 f8 09             	cmp    eax,0x9
1000254e:	75 1e                	jne    0x1000256e
10002550:	db 46 30             	fild   DWORD PTR [esi+0x30]
10002553:	dc 0d 48 d1 00 10    	fmul   QWORD PTR ds:0x1000d148
10002559:	e8 b2 2b 00 00       	call   0x10005110
1000255e:	89 46 30             	mov    DWORD PTR [esi+0x30],eax
10002561:	8b 0d e4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5e4
10002567:	e8 04 11 00 00       	call   0x10003670
1000256c:	eb 13                	jmp    0x10002581
1000256e:	8b 0c 85 98 e2 00 10 	mov    ecx,DWORD PTR [eax*4+0x1000e298]
10002575:	40                   	inc    eax
10002576:	89 4e 30             	mov    DWORD PTR [esi+0x30],ecx
10002579:	89 06                	mov    DWORD PTR [esi],eax
1000257b:	ff 05 dc f5 00 10    	inc    DWORD PTR ds:0x1000f5dc
10002581:	8a 56 28             	mov    dl,BYTE PTR [esi+0x28]
10002584:	8b ce                	mov    ecx,esi
10002586:	52                   	push   edx
10002587:	e8 04 fb ff ff       	call   0x10002090
1000258c:	8b 4e 34             	mov    ecx,DWORD PTR [esi+0x34]
1000258f:	41                   	inc    ecx
10002590:	8b c1                	mov    eax,ecx
10002592:	89 4e 34             	mov    DWORD PTR [esi+0x34],ecx
10002595:	99                   	cdq
10002596:	b9 03 00 00 00       	mov    ecx,0x3
1000259b:	f7 f9                	idiv   ecx
1000259d:	85 d2                	test   edx,edx
1000259f:	75 2b                	jne    0x100025cc
100025a1:	8b 46 38             	mov    eax,DWORD PTR [esi+0x38]
100025a4:	8b 88 a4 01 00 00    	mov    ecx,DWORD PTR [eax+0x1a4]
100025aa:	41                   	inc    ecx
100025ab:	89 88 a4 01 00 00    	mov    DWORD PTR [eax+0x1a4],ecx
100025b1:	8b 4e 38             	mov    ecx,DWORD PTR [esi+0x38]
100025b4:	e8 a7 14 00 00       	call   0x10003a60
100025b9:	8b 15 cc f5 00 10    	mov    edx,DWORD PTR ds:0x1000f5cc
100025bf:	6a 00                	push   0x0
100025c1:	8b 8a f0 00 00 00    	mov    ecx,DWORD PTR [edx+0xf0]
100025c7:	8b 01                	mov    eax,DWORD PTR [ecx]
100025c9:	ff 50 08             	call   DWORD PTR [eax+0x8]
100025cc:	8b 0d e4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5e4
100025d2:	e8 e9 15 00 00       	call   0x10003bc0
100025d7:	8b 0d e4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5e4
100025dd:	e8 8e 10 00 00       	call   0x10003670
100025e2:	32 c0                	xor    al,al
100025e4:	5e                   	pop    esi
100025e5:	5d                   	pop    ebp
100025e6:	c2 04 00             	ret    0x4
100025e9:	90                   	nop
100025ea:	90                   	nop
100025eb:	90                   	nop
100025ec:	90                   	nop
100025ed:	90                   	nop
100025ee:	90                   	nop
100025ef:	90                   	nop
100025f0:	55                   	push   ebp
100025f1:	8b ec                	mov    ebp,esp
100025f3:	56                   	push   esi
100025f4:	68 f4 00 00 00       	push   0xf4
100025f9:	e8 a4 2b 00 00       	call   0x100051a2
100025fe:	8b 75 08             	mov    esi,DWORD PTR [ebp+0x8]
10002601:	83 c4 04             	add    esp,0x4
10002604:	85 c0                	test   eax,eax
10002606:	74 0a                	je     0x10002612
10002608:	56                   	push   esi
10002609:	8b c8                	mov    ecx,eax
1000260b:	e8 90 f0 ff ff       	call   0x100016a0
10002610:	eb 02                	jmp    0x10002614
10002612:	33 c0                	xor    eax,eax
10002614:	a3 d8 f5 00 10       	mov    ds:0x1000f5d8,eax
10002619:	8b 4e 14             	mov    ecx,DWORD PTR [esi+0x14]
1000261c:	68 60 e3 00 10       	push   0x1000e360
10002621:	8b 01                	mov    eax,DWORD PTR [ecx]
10002623:	ff 50 08             	call   DWORD PTR [eax+0x8]
10002626:	5e                   	pop    esi
10002627:	5d                   	pop    ebp
10002628:	c3                   	ret
10002629:	90                   	nop
1000262a:	90                   	nop
1000262b:	90                   	nop
1000262c:	90                   	nop
1000262d:	90                   	nop
1000262e:	90                   	nop
1000262f:	90                   	nop
10002630:	8b 0d d8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5d8
10002636:	85 c9                	test   ecx,ecx
10002638:	74 15                	je     0x1000264f
1000263a:	56                   	push   esi
1000263b:	8b f1                	mov    esi,ecx
1000263d:	e8 0e f5 ff ff       	call   0x10001b50
10002642:	56                   	push   esi
10002643:	e8 4f 2b 00 00       	call   0x10005197
10002648:	83 c4 04             	add    esp,0x4
1000264b:	33 c0                	xor    eax,eax
1000264d:	5e                   	pop    esi
1000264e:	c3                   	ret
1000264f:	33 c0                	xor    eax,eax
10002651:	c3                   	ret
10002652:	90                   	nop
10002653:	90                   	nop
10002654:	90                   	nop
10002655:	90                   	nop
10002656:	90                   	nop
10002657:	90                   	nop
10002658:	90                   	nop
10002659:	90                   	nop
1000265a:	90                   	nop
1000265b:	90                   	nop
1000265c:	90                   	nop
1000265d:	90                   	nop
1000265e:	90                   	nop
1000265f:	90                   	nop
10002660:	55                   	push   ebp
10002661:	8b ec                	mov    ebp,esp
10002663:	8b c1                	mov    eax,ecx
10002665:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
10002668:	c7 00 50 d1 00 10    	mov    DWORD PTR [eax],0x1000d150
1000266e:	89 48 04             	mov    DWORD PTR [eax+0x4],ecx
10002671:	5d                   	pop    ebp
10002672:	c2 04 00             	ret    0x4
10002675:	90                   	nop
10002676:	90                   	nop
10002677:	90                   	nop
10002678:	90                   	nop
10002679:	90                   	nop
1000267a:	90                   	nop
1000267b:	90                   	nop
1000267c:	90                   	nop
1000267d:	90                   	nop
1000267e:	90                   	nop
1000267f:	90                   	nop
10002680:	55                   	push   ebp
10002681:	8b ec                	mov    ebp,esp
10002683:	56                   	push   esi
10002684:	8b f1                	mov    esi,ecx
10002686:	e8 25 00 00 00       	call   0x100026b0
1000268b:	f6 45 08 01          	test   BYTE PTR [ebp+0x8],0x1
1000268f:	74 09                	je     0x1000269a
10002691:	56                   	push   esi
10002692:	e8 00 2b 00 00       	call   0x10005197
10002697:	83 c4 04             	add    esp,0x4
1000269a:	8b c6                	mov    eax,esi
1000269c:	5e                   	pop    esi
1000269d:	5d                   	pop    ebp
1000269e:	c2 04 00             	ret    0x4
100026a1:	90                   	nop
100026a2:	90                   	nop
100026a3:	90                   	nop
100026a4:	90                   	nop
100026a5:	90                   	nop
100026a6:	90                   	nop
100026a7:	90                   	nop
100026a8:	90                   	nop
100026a9:	90                   	nop
100026aa:	90                   	nop
100026ab:	90                   	nop
100026ac:	90                   	nop
100026ad:	90                   	nop
100026ae:	90                   	nop
100026af:	90                   	nop
100026b0:	c7 01 50 d1 00 10    	mov    DWORD PTR [ecx],0x1000d150
100026b6:	c3                   	ret
100026b7:	90                   	nop
100026b8:	90                   	nop
100026b9:	90                   	nop
100026ba:	90                   	nop
100026bb:	90                   	nop
100026bc:	90                   	nop
100026bd:	90                   	nop
100026be:	90                   	nop
100026bf:	90                   	nop
100026c0:	55                   	push   ebp
100026c1:	8b ec                	mov    ebp,esp
100026c3:	6a ff                	push   0xffffffff
100026c5:	68 a3 c5 00 10       	push   0x1000c5a3
100026ca:	64 a1 00 00 00 00    	mov    eax,fs:0x0
100026d0:	50                   	push   eax
100026d1:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
100026d8:	81 ec ec 03 00 00    	sub    esp,0x3ec
100026de:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100026e1:	53                   	push   ebx
100026e2:	56                   	push   esi
100026e3:	57                   	push   edi
100026e4:	8b f1                	mov    esi,ecx
100026e6:	50                   	push   eax
100026e7:	89 75 f0             	mov    DWORD PTR [ebp-0x10],esi
100026ea:	e8 71 ff ff ff       	call   0x10002660
100026ef:	c7 06 54 d1 00 10    	mov    DWORD PTR [esi],0x1000d154
100026f5:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
100026fb:	c6 05 05 f6 00 10 01 	mov    BYTE PTR ds:0x1000f605,0x1
10002702:	8b 46 04             	mov    eax,DWORD PTR [esi+0x4]
10002705:	8b 11                	mov    edx,DWORD PTR [ecx]
10002707:	6a 00                	push   0x0
10002709:	8b 80 c0 00 00 00    	mov    eax,DWORD PTR [eax+0xc0]
1000270f:	6a 00                	push   0x0
10002711:	50                   	push   eax
10002712:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [ebp-0x4],0x0
10002719:	ff 52 40             	call   DWORD PTR [edx+0x40]
1000271c:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10002722:	6a 33                	push   0x33
10002724:	68 99 00 00 00       	push   0x99
10002729:	68 ff 00 00 00       	push   0xff
1000272e:	8b 11                	mov    edx,DWORD PTR [ecx]
10002730:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
10002733:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10002739:	6a 28                	push   0x28
1000273b:	6a 46                	push   0x46
1000273d:	6a 00                	push   0x0
1000273f:	8b 01                	mov    eax,DWORD PTR [ecx]
10002741:	6a 00                	push   0x0
10002743:	ff 50 10             	call   DWORD PTR [eax+0x10]
10002746:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
1000274c:	68 a4 01 00 00       	push   0x1a4
10002751:	68 f4 01 00 00       	push   0x1f4
10002756:	68 77 01 00 00       	push   0x177
1000275b:	8b 11                	mov    edx,DWORD PTR [ecx]
1000275d:	68 ac 01 00 00       	push   0x1ac
10002762:	ff 52 10             	call   DWORD PTR [edx+0x10]
10002765:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
1000276b:	6a 00                	push   0x0
1000276d:	6a 00                	push   0x0
1000276f:	6a 00                	push   0x0
10002771:	8b 01                	mov    eax,DWORD PTR [ecx]
10002773:	ff 50 1c             	call   DWORD PTR [eax+0x1c]
10002776:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
1000277c:	6a 28                	push   0x28
1000277e:	68 f4 01 00 00       	push   0x1f4
10002783:	6a 00                	push   0x0
10002785:	8b 11                	mov    edx,DWORD PTR [ecx]
10002787:	68 ac 01 00 00       	push   0x1ac
1000278c:	ff 52 10             	call   DWORD PTR [edx+0x10]
1000278f:	a1 bc f5 00 10       	mov    eax,ds:0x1000f5bc
10002794:	8b 4e 04             	mov    ecx,DWORD PTR [esi+0x4]
10002797:	68 60 2a 00 10       	push   0x10002a60
1000279c:	56                   	push   esi
1000279d:	6a 12                	push   0x12
1000279f:	6a 00                	push   0x0
100027a1:	68 81 01 00 00       	push   0x181
100027a6:	68 ac 01 00 00       	push   0x1ac
100027ab:	68 40 e5 00 10       	push   0x1000e540
100027b0:	50                   	push   eax
100027b1:	e8 2a f6 ff ff       	call   0x10001de0
100027b6:	89 86 9c 01 00 00    	mov    DWORD PTR [esi+0x19c],eax
100027bc:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
100027c2:	6a 1e                	push   0x1e
100027c4:	6a 00                	push   0x0
100027c6:	68 0c e5 00 10       	push   0x1000e50c
100027cb:	51                   	push   ecx
100027cc:	e8 2f 22 00 00       	call   0x10004a00
100027d1:	83 c4 10             	add    esp,0x10
100027d4:	bb 32 00 00 00       	mov    ebx,0x32
100027d9:	bf 68 e3 00 10       	mov    edi,0x1000e368
100027de:	8b 17                	mov    edx,DWORD PTR [edi]
100027e0:	8d 85 08 fc ff ff    	lea    eax,[ebp-0x3f8]
100027e6:	52                   	push   edx
100027e7:	68 ec e4 00 10       	push   0x1000e4ec
100027ec:	50                   	push   eax
100027ed:	e8 be 29 00 00       	call   0x100051b0
100027f2:	8b 15 b8 f5 00 10    	mov    edx,DWORD PTR ds:0x1000f5b8
100027f8:	53                   	push   ebx
100027f9:	8d 8d 08 fc ff ff    	lea    ecx,[ebp-0x3f8]
100027ff:	6a 00                	push   0x0
10002801:	51                   	push   ecx
10002802:	52                   	push   edx
10002803:	e8 f8 21 00 00       	call   0x10004a00
10002808:	83 c7 04             	add    edi,0x4
1000280b:	83 c4 1c             	add    esp,0x1c
1000280e:	83 c3 10             	add    ebx,0x10
10002811:	81 ff c0 e3 00 10    	cmp    edi,0x1000e3c0
10002817:	7c c5                	jl     0x100027de
10002819:	c7 86 98 01 00 00 00 	mov    DWORD PTR [esi+0x198],0x0
10002820:	00 00 00 
10002823:	6a 38                	push   0x38
10002825:	e8 78 29 00 00       	call   0x100051a2
1000282a:	8b f8                	mov    edi,eax
1000282c:	83 c4 04             	add    esp,0x4
1000282f:	89 7d 08             	mov    DWORD PTR [ebp+0x8],edi
10002832:	85 ff                	test   edi,edi
10002834:	c6 45 fc 01          	mov    BYTE PTR [ebp-0x4],0x1
10002838:	74 1f                	je     0x10002859
1000283a:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
10002840:	8b 01                	mov    eax,DWORD PTR [ecx]
10002842:	ff 50 08             	call   DWORD PTR [eax+0x8]
10002845:	33 d2                	xor    edx,edx
10002847:	b9 0a 00 00 00       	mov    ecx,0xa
1000284c:	f7 f1                	div    ecx
1000284e:	8b cf                	mov    ecx,edi
10002850:	42                   	inc    edx
10002851:	52                   	push   edx
10002852:	e8 49 e9 ff ff       	call   0x100011a0
10002857:	eb 02                	jmp    0x1000285b
10002859:	33 c0                	xor    eax,eax
1000285b:	8b 96 98 01 00 00    	mov    edx,DWORD PTR [esi+0x198]
10002861:	c6 45 fc 00          	mov    BYTE PTR [ebp-0x4],0x0
10002865:	89 44 96 08          	mov    DWORD PTR [esi+edx*4+0x8],eax
10002869:	8b 8e 98 01 00 00    	mov    ecx,DWORD PTR [esi+0x198]
1000286f:	41                   	inc    ecx
10002870:	8b c1                	mov    eax,ecx
10002872:	89 8e 98 01 00 00    	mov    DWORD PTR [esi+0x198],ecx
10002878:	83 f8 64             	cmp    eax,0x64
1000287b:	7c a6                	jl     0x10002823
1000287d:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10002883:	68 70 2a 00 10       	push   0x10002a70
10002888:	6a 14                	push   0x14
1000288a:	56                   	push   esi
1000288b:	8b 01                	mov    eax,DWORD PTR [ecx]
1000288d:	ff 50 34             	call   DWORD PTR [eax+0x34]
10002890:	89 86 a0 01 00 00    	mov    DWORD PTR [esi+0x1a0],eax
10002896:	8b 10                	mov    edx,DWORD PTR [eax]
10002898:	8b c8                	mov    ecx,eax
1000289a:	ff 52 08             	call   DWORD PTR [edx+0x8]
1000289d:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
100028a0:	8b c6                	mov    eax,esi
100028a2:	5f                   	pop    edi
100028a3:	5e                   	pop    esi
100028a4:	5b                   	pop    ebx
100028a5:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
100028ac:	8b e5                	mov    esp,ebp
100028ae:	5d                   	pop    ebp
100028af:	c2 04 00             	ret    0x4
100028b2:	90                   	nop
100028b3:	90                   	nop
100028b4:	90                   	nop
100028b5:	90                   	nop
100028b6:	90                   	nop
100028b7:	90                   	nop
100028b8:	90                   	nop
100028b9:	90                   	nop
100028ba:	90                   	nop
100028bb:	90                   	nop
100028bc:	90                   	nop
100028bd:	90                   	nop
100028be:	90                   	nop
100028bf:	90                   	nop
100028c0:	55                   	push   ebp
100028c1:	8b ec                	mov    ebp,esp
100028c3:	56                   	push   esi
100028c4:	8b f1                	mov    esi,ecx
100028c6:	e8 25 00 00 00       	call   0x100028f0
100028cb:	f6 45 08 01          	test   BYTE PTR [ebp+0x8],0x1
100028cf:	74 09                	je     0x100028da
100028d1:	56                   	push   esi
100028d2:	e8 c0 28 00 00       	call   0x10005197
100028d7:	83 c4 04             	add    esp,0x4
100028da:	8b c6                	mov    eax,esi
100028dc:	5e                   	pop    esi
100028dd:	5d                   	pop    ebp
100028de:	c2 04 00             	ret    0x4
100028e1:	90                   	nop
100028e2:	90                   	nop
100028e3:	90                   	nop
100028e4:	90                   	nop
100028e5:	90                   	nop
100028e6:	90                   	nop
100028e7:	90                   	nop
100028e8:	90                   	nop
100028e9:	90                   	nop
100028ea:	90                   	nop
100028eb:	90                   	nop
100028ec:	90                   	nop
100028ed:	90                   	nop
100028ee:	90                   	nop
100028ef:	90                   	nop
100028f0:	55                   	push   ebp
100028f1:	8b ec                	mov    ebp,esp
100028f3:	6a ff                	push   0xffffffff
100028f5:	68 b8 c5 00 10       	push   0x1000c5b8
100028fa:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10002900:	50                   	push   eax
10002901:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10002908:	83 ec 08             	sub    esp,0x8
1000290b:	53                   	push   ebx
1000290c:	56                   	push   esi
1000290d:	8b f1                	mov    esi,ecx
1000290f:	89 75 ec             	mov    DWORD PTR [ebp-0x14],esi
10002912:	c7 06 54 d1 00 10    	mov    DWORD PTR [esi],0x1000d154
10002918:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
1000291e:	8b 96 9c 01 00 00    	mov    edx,DWORD PTR [esi+0x19c]
10002924:	33 db                	xor    ebx,ebx
10002926:	52                   	push   edx
10002927:	8b 01                	mov    eax,DWORD PTR [ecx]
10002929:	89 5d fc             	mov    DWORD PTR [ebp-0x4],ebx
1000292c:	ff 50 1c             	call   DWORD PTR [eax+0x1c]
1000292f:	8b 8e 9c 01 00 00    	mov    ecx,DWORD PTR [esi+0x19c]
10002935:	8b 01                	mov    eax,DWORD PTR [ecx]
10002937:	ff 50 04             	call   DWORD PTR [eax+0x4]
1000293a:	39 9e 98 01 00 00    	cmp    DWORD PTR [esi+0x198],ebx
10002940:	7e 35                	jle    0x10002977
10002942:	8d 4e 08             	lea    ecx,[esi+0x8]
10002945:	57                   	push   edi
10002946:	89 4d f0             	mov    DWORD PTR [ebp-0x10],ecx
10002949:	8b 55 f0             	mov    edx,DWORD PTR [ebp-0x10]
1000294c:	8b 3a                	mov    edi,DWORD PTR [edx]
1000294e:	85 ff                	test   edi,edi
10002950:	74 10                	je     0x10002962
10002952:	8b cf                	mov    ecx,edi
10002954:	e8 e7 e9 ff ff       	call   0x10001340
10002959:	57                   	push   edi
1000295a:	e8 38 28 00 00       	call   0x10005197
1000295f:	83 c4 04             	add    esp,0x4
10002962:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
10002965:	8b 86 98 01 00 00    	mov    eax,DWORD PTR [esi+0x198]
1000296b:	43                   	inc    ebx
1000296c:	83 c1 04             	add    ecx,0x4
1000296f:	3b d8                	cmp    ebx,eax
10002971:	89 4d f0             	mov    DWORD PTR [ebp-0x10],ecx
10002974:	7c d3                	jl     0x10002949
10002976:	5f                   	pop    edi
10002977:	8b 8e a0 01 00 00    	mov    ecx,DWORD PTR [esi+0x1a0]
1000297d:	8b 01                	mov    eax,DWORD PTR [ecx]
1000297f:	ff 50 04             	call   DWORD PTR [eax+0x4]
10002982:	8b ce                	mov    ecx,esi
10002984:	c7 45 fc ff ff ff ff 	mov    DWORD PTR [ebp-0x4],0xffffffff
1000298b:	e8 20 fd ff ff       	call   0x100026b0
10002990:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
10002993:	5e                   	pop    esi
10002994:	5b                   	pop    ebx
10002995:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
1000299c:	8b e5                	mov    esp,ebp
1000299e:	5d                   	pop    ebp
1000299f:	c3                   	ret
100029a0:	55                   	push   ebp
100029a1:	8b ec                	mov    ebp,esp
100029a3:	6a ff                	push   0xffffffff
100029a5:	68 db c5 00 10       	push   0x1000c5db
100029aa:	64 a1 00 00 00 00    	mov    eax,fs:0x0
100029b0:	50                   	push   eax
100029b1:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
100029b8:	51                   	push   ecx
100029b9:	56                   	push   esi
100029ba:	8b f1                	mov    esi,ecx
100029bc:	6a 20                	push   0x20
100029be:	e8 df 27 00 00       	call   0x100051a2
100029c3:	83 c4 04             	add    esp,0x4
100029c6:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax
100029c9:	85 c0                	test   eax,eax
100029cb:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [ebp-0x4],0x0
100029d2:	74 0d                	je     0x100029e1
100029d4:	8b 4e 04             	mov    ecx,DWORD PTR [esi+0x4]
100029d7:	51                   	push   ecx
100029d8:	8b c8                	mov    ecx,eax
100029da:	e8 c1 17 00 00       	call   0x100041a0
100029df:	eb 02                	jmp    0x100029e3
100029e1:	33 c0                	xor    eax,eax
100029e3:	8b 4e 04             	mov    ecx,DWORD PTR [esi+0x4]
100029e6:	50                   	push   eax
100029e7:	56                   	push   esi
100029e8:	c7 45 fc ff ff ff ff 	mov    DWORD PTR [ebp-0x4],0xffffffff
100029ef:	e8 bc f3 ff ff       	call   0x10001db0
100029f4:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
100029f7:	33 c0                	xor    eax,eax
100029f9:	5e                   	pop    esi
100029fa:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
10002a01:	8b e5                	mov    esp,ebp
10002a03:	5d                   	pop    ebp
10002a04:	c2 04 00             	ret    0x4
10002a07:	90                   	nop
10002a08:	90                   	nop
10002a09:	90                   	nop
10002a0a:	90                   	nop
10002a0b:	90                   	nop
10002a0c:	90                   	nop
10002a0d:	90                   	nop
10002a0e:	90                   	nop
10002a0f:	90                   	nop
10002a10:	55                   	push   ebp
10002a11:	8b ec                	mov    ebp,esp
10002a13:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10002a16:	53                   	push   ebx
10002a17:	8b d9                	mov    ebx,ecx
10002a19:	56                   	push   esi
10002a1a:	8b 48 08             	mov    ecx,DWORD PTR [eax+0x8]
10002a1d:	33 f6                	xor    esi,esi
10002a1f:	89 0d e0 f5 00 10    	mov    DWORD PTR ds:0x1000f5e0,ecx
10002a25:	8b 83 98 01 00 00    	mov    eax,DWORD PTR [ebx+0x198]
10002a2b:	85 c0                	test   eax,eax
10002a2d:	7e 29                	jle    0x10002a58
10002a2f:	57                   	push   edi
10002a30:	8d 7b 08             	lea    edi,[ebx+0x8]
10002a33:	8b 55 08             	mov    edx,DWORD PTR [ebp+0x8]
10002a36:	8b 0f                	mov    ecx,DWORD PTR [edi]
10002a38:	8b 42 08             	mov    eax,DWORD PTR [edx+0x8]
10002a3b:	50                   	push   eax
10002a3c:	e8 3f e9 ff ff       	call   0x10001380
10002a41:	8b 83 98 01 00 00    	mov    eax,DWORD PTR [ebx+0x198]
10002a47:	46                   	inc    esi
10002a48:	83 c7 04             	add    edi,0x4
10002a4b:	3b f0                	cmp    esi,eax
10002a4d:	7c e4                	jl     0x10002a33
10002a4f:	5f                   	pop    edi
10002a50:	5e                   	pop    esi
10002a51:	33 c0                	xor    eax,eax
10002a53:	5b                   	pop    ebx
10002a54:	5d                   	pop    ebp
10002a55:	c2 04 00             	ret    0x4
10002a58:	5e                   	pop    esi
10002a59:	33 c0                	xor    eax,eax
10002a5b:	5b                   	pop    ebx
10002a5c:	5d                   	pop    ebp
10002a5d:	c2 04 00             	ret    0x4
10002a60:	55                   	push   ebp
10002a61:	8b ec                	mov    ebp,esp
10002a63:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10002a66:	50                   	push   eax
10002a67:	8b 08                	mov    ecx,DWORD PTR [eax]
10002a69:	e8 32 ff ff ff       	call   0x100029a0
10002a6e:	5d                   	pop    ebp
10002a6f:	c3                   	ret
10002a70:	55                   	push   ebp
10002a71:	8b ec                	mov    ebp,esp
10002a73:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10002a76:	50                   	push   eax
10002a77:	8b 08                	mov    ecx,DWORD PTR [eax]
10002a79:	e8 92 ff ff ff       	call   0x10002a10
10002a7e:	5d                   	pop    ebp
10002a7f:	c3                   	ret
10002a80:	55                   	push   ebp
10002a81:	8b ec                	mov    ebp,esp
10002a83:	6a ff                	push   0xffffffff
10002a85:	68 0e c6 00 10       	push   0x1000c60e
10002a8a:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10002a90:	50                   	push   eax
10002a91:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10002a98:	51                   	push   ecx
10002a99:	53                   	push   ebx
10002a9a:	56                   	push   esi
10002a9b:	57                   	push   edi
10002a9c:	8b 7d 08             	mov    edi,DWORD PTR [ebp+0x8]
10002a9f:	8b f1                	mov    esi,ecx
10002aa1:	57                   	push   edi
10002aa2:	89 75 f0             	mov    DWORD PTR [ebp-0x10],esi
10002aa5:	e8 b6 fb ff ff       	call   0x10002660
10002aaa:	33 db                	xor    ebx,ebx
10002aac:	c7 06 58 d1 00 10    	mov    DWORD PTR [esi],0x1000d158
10002ab2:	88 1d 05 f6 00 10    	mov    BYTE PTR ds:0x1000f605,bl
10002ab8:	89 1d e0 f5 00 10    	mov    DWORD PTR ds:0x1000f5e0,ebx
10002abe:	89 3d cc f5 00 10    	mov    DWORD PTR ds:0x1000f5cc,edi
10002ac4:	89 35 e4 f5 00 10    	mov    DWORD PTR ds:0x1000f5e4,esi
10002aca:	8b 56 04             	mov    edx,DWORD PTR [esi+0x4]
10002acd:	89 9e bc 01 00 00    	mov    DWORD PTR [esi+0x1bc],ebx
10002ad3:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10002ad9:	53                   	push   ebx
10002ada:	8b 92 c0 00 00 00    	mov    edx,DWORD PTR [edx+0xc0]
10002ae0:	53                   	push   ebx
10002ae1:	8b 01                	mov    eax,DWORD PTR [ecx]
10002ae3:	52                   	push   edx
10002ae4:	89 5d fc             	mov    DWORD PTR [ebp-0x4],ebx
10002ae7:	ff 50 40             	call   DWORD PTR [eax+0x40]
10002aea:	89 5e 08             	mov    DWORD PTR [esi+0x8],ebx
10002aed:	c7 86 a4 01 00 00 02 	mov    DWORD PTR [esi+0x1a4],0x2
10002af4:	00 00 00 
10002af7:	a1 08 f6 00 10       	mov    eax,ds:0x1000f608
10002afc:	6a 3c                	push   0x3c
10002afe:	a3 dc f5 00 10       	mov    ds:0x1000f5dc,eax
10002b03:	e8 9a 26 00 00       	call   0x100051a2
10002b08:	83 c4 04             	add    esp,0x4
10002b0b:	89 45 08             	mov    DWORD PTR [ebp+0x8],eax
10002b0e:	3b c3                	cmp    eax,ebx
10002b10:	c6 45 fc 01          	mov    BYTE PTR [ebp-0x4],0x1
10002b14:	74 0a                	je     0x10002b20
10002b16:	56                   	push   esi
10002b17:	8b c8                	mov    ecx,eax
10002b19:	e8 32 f4 ff ff       	call   0x10001f50
10002b1e:	eb 02                	jmp    0x10002b22
10002b20:	33 c0                	xor    eax,eax
10002b22:	89 46 0c             	mov    DWORD PTR [esi+0xc],eax
10002b25:	89 9e a0 01 00 00    	mov    DWORD PTR [esi+0x1a0],ebx
10002b2b:	8b 08                	mov    ecx,DWORD PTR [eax]
10002b2d:	88 5d fc             	mov    BYTE PTR [ebp-0x4],bl
10002b30:	8d 54 09 04          	lea    edx,[ecx+ecx*1+0x4]
10002b34:	85 d2                	test   edx,edx
10002b36:	0f 8e 89 00 00 00    	jle    0x10002bc5
10002b3c:	8b 46 0c             	mov    eax,DWORD PTR [esi+0xc]
10002b3f:	8b 08                	mov    ecx,DWORD PTR [eax]
10002b41:	b8 56 55 55 55       	mov    eax,0x55555556
10002b46:	8d 54 09 04          	lea    edx,[ecx+ecx*1+0x4]
10002b4a:	f7 ea                	imul   edx
10002b4c:	8b c2                	mov    eax,edx
10002b4e:	c1 e8 1f             	shr    eax,0x1f
10002b51:	03 d0                	add    edx,eax
10002b53:	8b 86 a0 01 00 00    	mov    eax,DWORD PTR [esi+0x1a0]
10002b59:	3b c2                	cmp    eax,edx
10002b5b:	7d 05                	jge    0x10002b62
10002b5d:	8d 79 01             	lea    edi,[ecx+0x1]
10002b60:	eb 15                	jmp    0x10002b77
10002b62:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
10002b68:	8b 11                	mov    edx,DWORD PTR [ecx]
10002b6a:	ff 52 08             	call   DWORD PTR [edx+0x8]
10002b6d:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
10002b70:	33 d2                	xor    edx,edx
10002b72:	f7 31                	div    DWORD PTR [ecx]
10002b74:	8b fa                	mov    edi,edx
10002b76:	47                   	inc    edi
10002b77:	6a 38                	push   0x38
10002b79:	e8 24 26 00 00       	call   0x100051a2
10002b7e:	83 c4 04             	add    esp,0x4
10002b81:	89 45 08             	mov    DWORD PTR [ebp+0x8],eax
10002b84:	3b c3                	cmp    eax,ebx
10002b86:	c6 45 fc 02          	mov    BYTE PTR [ebp-0x4],0x2
10002b8a:	74 0a                	je     0x10002b96
10002b8c:	57                   	push   edi
10002b8d:	8b c8                	mov    ecx,eax
10002b8f:	e8 0c e6 ff ff       	call   0x100011a0
10002b94:	eb 02                	jmp    0x10002b98
10002b96:	33 c0                	xor    eax,eax
10002b98:	8b 96 a0 01 00 00    	mov    edx,DWORD PTR [esi+0x1a0]
10002b9e:	88 5d fc             	mov    BYTE PTR [ebp-0x4],bl
10002ba1:	89 44 96 10          	mov    DWORD PTR [esi+edx*4+0x10],eax
10002ba5:	8b be a0 01 00 00    	mov    edi,DWORD PTR [esi+0x1a0]
10002bab:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
10002bae:	47                   	inc    edi
10002baf:	89 be a0 01 00 00    	mov    DWORD PTR [esi+0x1a0],edi
10002bb5:	8b c7                	mov    eax,edi
10002bb7:	8b 11                	mov    edx,DWORD PTR [ecx]
10002bb9:	8d 4c 12 04          	lea    ecx,[edx+edx*1+0x4]
10002bbd:	3b c1                	cmp    eax,ecx
10002bbf:	0f 8c 77 ff ff ff    	jl     0x10002b3c
10002bc5:	88 9e c0 01 00 00    	mov    BYTE PTR [esi+0x1c0],bl
10002bcb:	88 9e c1 01 00 00    	mov    BYTE PTR [esi+0x1c1],bl
10002bd1:	88 9e c2 01 00 00    	mov    BYTE PTR [esi+0x1c2],bl
10002bd7:	88 9e c3 01 00 00    	mov    BYTE PTR [esi+0x1c3],bl
10002bdd:	89 9e c4 01 00 00    	mov    DWORD PTR [esi+0x1c4],ebx
10002be3:	89 9e c8 01 00 00    	mov    DWORD PTR [esi+0x1c8],ebx
10002be9:	89 9e cc 01 00 00    	mov    DWORD PTR [esi+0x1cc],ebx
10002bef:	89 9e d0 01 00 00    	mov    DWORD PTR [esi+0x1d0],ebx
10002bf5:	89 9e e4 01 00 00    	mov    DWORD PTR [esi+0x1e4],ebx
10002bfb:	89 9e e0 01 00 00    	mov    DWORD PTR [esi+0x1e0],ebx
10002c01:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10002c07:	a1 c8 f5 00 10       	mov    eax,ds:0x1000f5c8
10002c0c:	68 f0 31 00 10       	push   0x100031f0
10002c11:	56                   	push   esi
10002c12:	8b 11                	mov    edx,DWORD PTR [ecx]
10002c14:	6a 0b                	push   0xb
10002c16:	50                   	push   eax
10002c17:	ff 52 44             	call   DWORD PTR [edx+0x44]
10002c1a:	89 86 b4 01 00 00    	mov    DWORD PTR [esi+0x1b4],eax
10002c20:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10002c26:	68 e0 31 00 10       	push   0x100031e0
10002c2b:	6a 14                	push   0x14
10002c2d:	8b 11                	mov    edx,DWORD PTR [ecx]
10002c2f:	56                   	push   esi
10002c30:	ff 52 34             	call   DWORD PTR [edx+0x34]
10002c33:	89 86 b0 01 00 00    	mov    DWORD PTR [esi+0x1b0],eax
10002c39:	8b 10                	mov    edx,DWORD PTR [eax]
10002c3b:	8b c8                	mov    ecx,eax
10002c3d:	ff 52 08             	call   DWORD PTR [edx+0x8]
10002c40:	8b ce                	mov    ecx,esi
10002c42:	e8 19 0e 00 00       	call   0x10003a60
10002c47:	8b ce                	mov    ecx,esi
10002c49:	e8 82 0e 00 00       	call   0x10003ad0
10002c4e:	8b ce                	mov    ecx,esi
10002c50:	e8 6b 0f 00 00       	call   0x10003bc0
10002c55:	88 9e ad 01 00 00    	mov    BYTE PTR [esi+0x1ad],bl
10002c5b:	88 9e ae 01 00 00    	mov    BYTE PTR [esi+0x1ae],bl
10002c61:	88 9e ac 01 00 00    	mov    BYTE PTR [esi+0x1ac],bl
10002c67:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
10002c6d:	8b 01                	mov    eax,DWORD PTR [ecx]
10002c6f:	ff 50 08             	call   DWORD PTR [eax+0x8]
10002c72:	33 d2                	xor    edx,edx
10002c74:	b9 a0 0f 00 00       	mov    ecx,0xfa0
10002c79:	f7 f1                	div    ecx
10002c7b:	89 9e d8 01 00 00    	mov    DWORD PTR [esi+0x1d8],ebx
10002c81:	89 9e dc 01 00 00    	mov    DWORD PTR [esi+0x1dc],ebx
10002c87:	6a 01                	push   0x1
10002c89:	81 c2 b8 0b 00 00    	add    edx,0xbb8
10002c8f:	89 96 a8 01 00 00    	mov    DWORD PTR [esi+0x1a8],edx
10002c95:	8b 0d c8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c8
10002c9b:	8b 11                	mov    edx,DWORD PTR [ecx]
10002c9d:	ff 52 0c             	call   DWORD PTR [edx+0xc]
10002ca0:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
10002ca3:	8b c6                	mov    eax,esi
10002ca5:	5f                   	pop    edi
10002ca6:	5e                   	pop    esi
10002ca7:	5b                   	pop    ebx
10002ca8:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
10002caf:	8b e5                	mov    esp,ebp
10002cb1:	5d                   	pop    ebp
10002cb2:	c2 08 00             	ret    0x8
10002cb5:	90                   	nop
10002cb6:	90                   	nop
10002cb7:	90                   	nop
10002cb8:	90                   	nop
10002cb9:	90                   	nop
10002cba:	90                   	nop
10002cbb:	90                   	nop
10002cbc:	90                   	nop
10002cbd:	90                   	nop
10002cbe:	90                   	nop
10002cbf:	90                   	nop
10002cc0:	55                   	push   ebp
10002cc1:	8b ec                	mov    ebp,esp
10002cc3:	56                   	push   esi
10002cc4:	8b f1                	mov    esi,ecx
10002cc6:	e8 25 00 00 00       	call   0x10002cf0
10002ccb:	f6 45 08 01          	test   BYTE PTR [ebp+0x8],0x1
10002ccf:	74 09                	je     0x10002cda
10002cd1:	56                   	push   esi
10002cd2:	e8 c0 24 00 00       	call   0x10005197
10002cd7:	83 c4 04             	add    esp,0x4
10002cda:	8b c6                	mov    eax,esi
10002cdc:	5e                   	pop    esi
10002cdd:	5d                   	pop    ebp
10002cde:	c2 04 00             	ret    0x4
10002ce1:	90                   	nop
10002ce2:	90                   	nop
10002ce3:	90                   	nop
10002ce4:	90                   	nop
10002ce5:	90                   	nop
10002ce6:	90                   	nop
10002ce7:	90                   	nop
10002ce8:	90                   	nop
10002ce9:	90                   	nop
10002cea:	90                   	nop
10002ceb:	90                   	nop
10002cec:	90                   	nop
10002ced:	90                   	nop
10002cee:	90                   	nop
10002cef:	90                   	nop
10002cf0:	55                   	push   ebp
10002cf1:	8b ec                	mov    ebp,esp
10002cf3:	6a ff                	push   0xffffffff
10002cf5:	68 28 c6 00 10       	push   0x1000c628
10002cfa:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10002d00:	50                   	push   eax
10002d01:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10002d08:	83 ec 08             	sub    esp,0x8
10002d0b:	53                   	push   ebx
10002d0c:	56                   	push   esi
10002d0d:	8b f1                	mov    esi,ecx
10002d0f:	57                   	push   edi
10002d10:	89 75 ec             	mov    DWORD PTR [ebp-0x14],esi
10002d13:	c7 06 58 d1 00 10    	mov    DWORD PTR [esi],0x1000d158
10002d19:	8b 8e b0 01 00 00    	mov    ecx,DWORD PTR [esi+0x1b0]
10002d1f:	33 db                	xor    ebx,ebx
10002d21:	89 5d fc             	mov    DWORD PTR [ebp-0x4],ebx
10002d24:	8b 01                	mov    eax,DWORD PTR [ecx]
10002d26:	ff 50 04             	call   DWORD PTR [eax+0x4]
10002d29:	39 9e a0 01 00 00    	cmp    DWORD PTR [esi+0x1a0],ebx
10002d2f:	7e 33                	jle    0x10002d64
10002d31:	8d 4e 10             	lea    ecx,[esi+0x10]
10002d34:	89 4d f0             	mov    DWORD PTR [ebp-0x10],ecx
10002d37:	8b 55 f0             	mov    edx,DWORD PTR [ebp-0x10]
10002d3a:	8b 3a                	mov    edi,DWORD PTR [edx]
10002d3c:	85 ff                	test   edi,edi
10002d3e:	74 10                	je     0x10002d50
10002d40:	8b cf                	mov    ecx,edi
10002d42:	e8 f9 e5 ff ff       	call   0x10001340
10002d47:	57                   	push   edi
10002d48:	e8 4a 24 00 00       	call   0x10005197
10002d4d:	83 c4 04             	add    esp,0x4
10002d50:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
10002d53:	8b 86 a0 01 00 00    	mov    eax,DWORD PTR [esi+0x1a0]
10002d59:	43                   	inc    ebx
10002d5a:	83 c1 04             	add    ecx,0x4
10002d5d:	3b d8                	cmp    ebx,eax
10002d5f:	89 4d f0             	mov    DWORD PTR [ebp-0x10],ecx
10002d62:	7c d3                	jl     0x10002d37
10002d64:	8b 7e 0c             	mov    edi,DWORD PTR [esi+0xc]
10002d67:	85 ff                	test   edi,edi
10002d69:	74 10                	je     0x10002d7b
10002d6b:	8b cf                	mov    ecx,edi
10002d6d:	e8 9e f2 ff ff       	call   0x10002010
10002d72:	57                   	push   edi
10002d73:	e8 1f 24 00 00       	call   0x10005197
10002d78:	83 c4 04             	add    esp,0x4
10002d7b:	8b 8e d8 01 00 00    	mov    ecx,DWORD PTR [esi+0x1d8]
10002d81:	85 c9                	test   ecx,ecx
10002d83:	74 05                	je     0x10002d8a
10002d85:	8b 01                	mov    eax,DWORD PTR [ecx]
10002d87:	ff 50 04             	call   DWORD PTR [eax+0x4]
10002d8a:	8b 86 e0 01 00 00    	mov    eax,DWORD PTR [esi+0x1e0]
10002d90:	85 c0                	test   eax,eax
10002d92:	74 17                	je     0x10002dab
10002d94:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
10002d9a:	50                   	push   eax
10002d9b:	8b 11                	mov    edx,DWORD PTR [ecx]
10002d9d:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
10002da0:	8b 8e e0 01 00 00    	mov    ecx,DWORD PTR [esi+0x1e0]
10002da6:	8b 01                	mov    eax,DWORD PTR [ecx]
10002da8:	ff 50 04             	call   DWORD PTR [eax+0x4]
10002dab:	8b 86 e4 01 00 00    	mov    eax,DWORD PTR [esi+0x1e4]
10002db1:	85 c0                	test   eax,eax
10002db3:	74 17                	je     0x10002dcc
10002db5:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
10002dbb:	50                   	push   eax
10002dbc:	8b 11                	mov    edx,DWORD PTR [ecx]
10002dbe:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
10002dc1:	8b 8e e4 01 00 00    	mov    ecx,DWORD PTR [esi+0x1e4]
10002dc7:	8b 01                	mov    eax,DWORD PTR [ecx]
10002dc9:	ff 50 04             	call   DWORD PTR [eax+0x4]
10002dcc:	8b 86 dc 01 00 00    	mov    eax,DWORD PTR [esi+0x1dc]
10002dd2:	85 c0                	test   eax,eax
10002dd4:	74 17                	je     0x10002ded
10002dd6:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
10002ddc:	50                   	push   eax
10002ddd:	8b 11                	mov    edx,DWORD PTR [ecx]
10002ddf:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
10002de2:	8b 8e dc 01 00 00    	mov    ecx,DWORD PTR [esi+0x1dc]
10002de8:	8b 01                	mov    eax,DWORD PTR [ecx]
10002dea:	ff 50 04             	call   DWORD PTR [eax+0x4]
10002ded:	8b 8e b4 01 00 00    	mov    ecx,DWORD PTR [esi+0x1b4]
10002df3:	8b 11                	mov    edx,DWORD PTR [ecx]
10002df5:	ff 52 04             	call   DWORD PTR [edx+0x4]
10002df8:	8b ce                	mov    ecx,esi
10002dfa:	c7 45 fc ff ff ff ff 	mov    DWORD PTR [ebp-0x4],0xffffffff
10002e01:	e8 aa f8 ff ff       	call   0x100026b0
10002e06:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
10002e09:	5f                   	pop    edi
10002e0a:	5e                   	pop    esi
10002e0b:	5b                   	pop    ebx
10002e0c:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
10002e13:	8b e5                	mov    esp,ebp
10002e15:	5d                   	pop    ebp
10002e16:	c3                   	ret
10002e17:	90                   	nop
10002e18:	90                   	nop
10002e19:	90                   	nop
10002e1a:	90                   	nop
10002e1b:	90                   	nop
10002e1c:	90                   	nop
10002e1d:	90                   	nop
10002e1e:	90                   	nop
10002e1f:	90                   	nop
10002e20:	55                   	push   ebp
10002e21:	8b ec                	mov    ebp,esp
10002e23:	83 ec 0c             	sub    esp,0xc
10002e26:	8b 81 bc 01 00 00    	mov    eax,DWORD PTR [ecx+0x1bc]
10002e2c:	48                   	dec    eax
10002e2d:	74 1b                	je     0x10002e4a
10002e2f:	48                   	dec    eax
10002e30:	75 5f                	jne    0x10002e91
10002e32:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10002e35:	83 78 08 20          	cmp    DWORD PTR [eax+0x8],0x20
10002e39:	75 56                	jne    0x10002e91
10002e3b:	6a 00                	push   0x0
10002e3d:	e8 be 11 00 00       	call   0x10004000
10002e42:	33 c0                	xor    eax,eax
10002e44:	8b e5                	mov    esp,ebp
10002e46:	5d                   	pop    ebp
10002e47:	c2 04 00             	ret    0x4
10002e4a:	8b 55 08             	mov    edx,DWORD PTR [ebp+0x8]
10002e4d:	8b 42 08             	mov    eax,DWORD PTR [edx+0x8]
10002e50:	83 f8 59             	cmp    eax,0x59
10002e53:	74 2b                	je     0x10002e80
10002e55:	83 f8 79             	cmp    eax,0x79
10002e58:	74 26                	je     0x10002e80
10002e5a:	83 f8 4e             	cmp    eax,0x4e
10002e5d:	74 05                	je     0x10002e64
10002e5f:	83 f8 6e             	cmp    eax,0x6e
10002e62:	75 2d                	jne    0x10002e91
10002e64:	b8 01 00 00 00       	mov    eax,0x1
10002e69:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
10002e6c:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
10002e6f:	8d 45 f4             	lea    eax,[ebp-0xc]
10002e72:	50                   	push   eax
10002e73:	e8 e8 10 00 00       	call   0x10003f60
10002e78:	33 c0                	xor    eax,eax
10002e7a:	8b e5                	mov    esp,ebp
10002e7c:	5d                   	pop    ebp
10002e7d:	c2 04 00             	ret    0x4
10002e80:	8d 55 f4             	lea    edx,[ebp-0xc]
10002e83:	33 c0                	xor    eax,eax
10002e85:	52                   	push   edx
10002e86:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
10002e89:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
10002e8c:	e8 cf 10 00 00       	call   0x10003f60
10002e91:	33 c0                	xor    eax,eax
10002e93:	8b e5                	mov    esp,ebp
10002e95:	5d                   	pop    ebp
10002e96:	c2 04 00             	ret    0x4
10002e99:	90                   	nop
10002e9a:	90                   	nop
10002e9b:	90                   	nop
10002e9c:	90                   	nop
10002e9d:	90                   	nop
10002e9e:	90                   	nop
10002e9f:	90                   	nop
10002ea0:	55                   	push   ebp
10002ea1:	8b ec                	mov    ebp,esp
10002ea3:	51                   	push   ecx
10002ea4:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10002ea7:	53                   	push   ebx
10002ea8:	56                   	push   esi
10002ea9:	8b f1                	mov    esi,ecx
10002eab:	8b 40 08             	mov    eax,DWORD PTR [eax+0x8]
10002eae:	89 86 d4 01 00 00    	mov    DWORD PTR [esi+0x1d4],eax
10002eb4:	a3 e0 f5 00 10       	mov    ds:0x1000f5e0,eax
10002eb9:	a0 ec f5 00 10       	mov    al,ds:0x1000f5ec
10002ebe:	84 c0                	test   al,al
10002ec0:	0f 84 30 01 00 00    	je     0x10002ff6
10002ec6:	8a 86 ac 01 00 00    	mov    al,BYTE PTR [esi+0x1ac]
10002ecc:	84 c0                	test   al,al
10002ece:	a1 f8 f5 00 10       	mov    eax,ds:0x1000f5f8
10002ed3:	75 54                	jne    0x10002f29
10002ed5:	8b 8e d4 01 00 00    	mov    ecx,DWORD PTR [esi+0x1d4]
10002edb:	2b c8                	sub    ecx,eax
10002edd:	81 f9 e8 03 00 00    	cmp    ecx,0x3e8
10002ee3:	76 44                	jbe    0x10002f29
10002ee5:	8a 86 ad 01 00 00    	mov    al,BYTE PTR [esi+0x1ad]
10002eeb:	84 c0                	test   al,al
10002eed:	74 18                	je     0x10002f07
10002eef:	8b ce                	mov    ecx,esi
10002ef1:	e8 8a 0e 00 00       	call   0x10003d80
10002ef6:	c6 86 ac 01 00 00 01 	mov    BYTE PTR [esi+0x1ac],0x1
10002efd:	5e                   	pop    esi
10002efe:	33 c0                	xor    eax,eax
10002f00:	5b                   	pop    ebx
10002f01:	8b e5                	mov    esp,ebp
10002f03:	5d                   	pop    ebp
10002f04:	c2 04 00             	ret    0x4
10002f07:	8a 86 ae 01 00 00    	mov    al,BYTE PTR [esi+0x1ae]
10002f0d:	84 c0                	test   al,al
10002f0f:	74 07                	je     0x10002f18
10002f11:	8b ce                	mov    ecx,esi
10002f13:	e8 58 0f 00 00       	call   0x10003e70
10002f18:	c6 86 ac 01 00 00 01 	mov    BYTE PTR [esi+0x1ac],0x1
10002f1f:	5e                   	pop    esi
10002f20:	33 c0                	xor    eax,eax
10002f22:	5b                   	pop    ebx
10002f23:	8b e5                	mov    esp,ebp
10002f25:	5d                   	pop    ebp
10002f26:	c2 04 00             	ret    0x4
10002f29:	8b 96 d4 01 00 00    	mov    edx,DWORD PTR [esi+0x1d4]
10002f2f:	2b d0                	sub    edx,eax
10002f31:	81 fa d0 07 00 00    	cmp    edx,0x7d0
10002f37:	76 2e                	jbe    0x10002f67
10002f39:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
10002f3f:	8b 15 e8 f5 00 10    	mov    edx,DWORD PTR ds:0x1000f5e8
10002f45:	52                   	push   edx
10002f46:	8b 01                	mov    eax,DWORD PTR [ecx]
10002f48:	ff 50 1c             	call   DWORD PTR [eax+0x1c]
10002f4b:	8b 0d e8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5e8
10002f51:	8b 01                	mov    eax,DWORD PTR [ecx]
10002f53:	ff 50 04             	call   DWORD PTR [eax+0x4]
10002f56:	5e                   	pop    esi
10002f57:	c6 05 ec f5 00 10 00 	mov    BYTE PTR ds:0x1000f5ec,0x0
10002f5e:	33 c0                	xor    eax,eax
10002f60:	5b                   	pop    ebx
10002f61:	8b e5                	mov    esp,ebp
10002f63:	5d                   	pop    ebp
10002f64:	c2 04 00             	ret    0x4
10002f67:	a1 f4 f5 00 10       	mov    eax,ds:0x1000f5f4
10002f6c:	99                   	cdq
10002f6d:	33 c2                	xor    eax,edx
10002f6f:	2b c2                	sub    eax,edx
10002f71:	83 f8 05             	cmp    eax,0x5
10002f74:	a1 fc f5 00 10       	mov    eax,ds:0x1000f5fc
10002f79:	7e 07                	jle    0x10002f82
10002f7b:	f7 d8                	neg    eax
10002f7d:	a3 fc f5 00 10       	mov    ds:0x1000f5fc,eax
10002f82:	8b 1d f4 f5 00 10    	mov    ebx,DWORD PTR ds:0x1000f5f4
10002f88:	8b 0d e8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5e8
10002f8e:	03 d8                	add    ebx,eax
10002f90:	8d 45 fc             	lea    eax,[ebp-0x4]
10002f93:	50                   	push   eax
10002f94:	89 1d f4 f5 00 10    	mov    DWORD PTR ds:0x1000f5f4,ebx
10002f9a:	8b 11                	mov    edx,DWORD PTR [ecx]
10002f9c:	8d 45 08             	lea    eax,[ebp+0x8]
10002f9f:	50                   	push   eax
10002fa0:	ff 52 0c             	call   DWORD PTR [edx+0xc]
10002fa3:	e8 91 26 00 00       	call   0x10005639
10002fa8:	99                   	cdq
10002fa9:	b9 03 00 00 00       	mov    ecx,0x3
10002fae:	f7 f9                	idiv   ecx
10002fb0:	83 fa 01             	cmp    edx,0x1
10002fb3:	75 03                	jne    0x10002fb8
10002fb5:	ff 45 08             	inc    DWORD PTR [ebp+0x8]
10002fb8:	a1 fc f5 00 10       	mov    eax,ds:0x1000f5fc
10002fbd:	8b 0d e8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5e8
10002fc3:	85 c0                	test   eax,eax
10002fc5:	8b 11                	mov    edx,DWORD PTR [ecx]
10002fc7:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
10002fca:	6a 00                	push   0x0
10002fcc:	7d 14                	jge    0x10002fe2
10002fce:	48                   	dec    eax
10002fcf:	50                   	push   eax
10002fd0:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10002fd3:	48                   	dec    eax
10002fd4:	50                   	push   eax
10002fd5:	ff 52 08             	call   DWORD PTR [edx+0x8]
10002fd8:	5e                   	pop    esi
10002fd9:	33 c0                	xor    eax,eax
10002fdb:	5b                   	pop    ebx
10002fdc:	8b e5                	mov    esp,ebp
10002fde:	5d                   	pop    ebp
10002fdf:	c2 04 00             	ret    0x4
10002fe2:	48                   	dec    eax
10002fe3:	50                   	push   eax
10002fe4:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10002fe7:	40                   	inc    eax
10002fe8:	50                   	push   eax
10002fe9:	ff 52 08             	call   DWORD PTR [edx+0x8]
10002fec:	5e                   	pop    esi
10002fed:	33 c0                	xor    eax,eax
10002fef:	5b                   	pop    ebx
10002ff0:	8b e5                	mov    esp,ebp
10002ff2:	5d                   	pop    ebp
10002ff3:	c2 04 00             	ret    0x4
10002ff6:	8b 86 bc 01 00 00    	mov    eax,DWORD PTR [esi+0x1bc]
10002ffc:	85 c0                	test   eax,eax
10002ffe:	74 0a                	je     0x1000300a
10003000:	5e                   	pop    esi
10003001:	33 c0                	xor    eax,eax
10003003:	5b                   	pop    ebx
10003004:	8b e5                	mov    esp,ebp
10003006:	5d                   	pop    ebp
10003007:	c2 04 00             	ret    0x4
1000300a:	8b 8e d4 01 00 00    	mov    ecx,DWORD PTR [esi+0x1d4]
10003010:	8b 86 a8 01 00 00    	mov    eax,DWORD PTR [esi+0x1a8]
10003016:	3b c8                	cmp    ecx,eax
10003018:	76 3b                	jbe    0x10003055
1000301a:	8b 15 cc f5 00 10    	mov    edx,DWORD PTR ds:0x1000f5cc
10003020:	6a 00                	push   0x0
10003022:	8b 8a ec 00 00 00    	mov    ecx,DWORD PTR [edx+0xec]
10003028:	8b 01                	mov    eax,DWORD PTR [ecx]
1000302a:	ff 50 08             	call   DWORD PTR [eax+0x8]
1000302d:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
10003033:	8b 11                	mov    edx,DWORD PTR [ecx]
10003035:	ff 52 08             	call   DWORD PTR [edx+0x8]
10003038:	33 d2                	xor    edx,edx
1000303a:	b9 a0 0f 00 00       	mov    ecx,0xfa0
1000303f:	f7 f1                	div    ecx
10003041:	8b 86 a8 01 00 00    	mov    eax,DWORD PTR [esi+0x1a8]
10003047:	81 c2 88 13 00 00    	add    edx,0x1388
1000304d:	03 c2                	add    eax,edx
1000304f:	89 86 a8 01 00 00    	mov    DWORD PTR [esi+0x1a8],eax
10003055:	8b ce                	mov    ecx,esi
10003057:	e8 04 04 00 00       	call   0x10003460
1000305c:	84 c0                	test   al,al
1000305e:	74 7e                	je     0x100030de
10003060:	a0 04 f6 00 10       	mov    al,ds:0x1000f604
10003065:	84 c0                	test   al,al
10003067:	75 75                	jne    0x100030de
10003069:	8b 8e a4 01 00 00    	mov    ecx,DWORD PTR [esi+0x1a4]
1000306f:	49                   	dec    ecx
10003070:	8b c1                	mov    eax,ecx
10003072:	89 8e a4 01 00 00    	mov    DWORD PTR [esi+0x1a4],ecx
10003078:	83 f8 ff             	cmp    eax,0xffffffff
1000307b:	7e 2b                	jle    0x100030a8
1000307d:	8b 15 cc f5 00 10    	mov    edx,DWORD PTR ds:0x1000f5cc
10003083:	6a 00                	push   0x0
10003085:	8b 8a d8 00 00 00    	mov    ecx,DWORD PTR [edx+0xd8]
1000308b:	8b 01                	mov    eax,DWORD PTR [ecx]
1000308d:	ff 50 08             	call   DWORD PTR [eax+0x8]
10003090:	8b ce                	mov    ecx,esi
10003092:	c6 86 ad 01 00 00 01 	mov    BYTE PTR [esi+0x1ad],0x1
10003099:	e8 92 00 00 00       	call   0x10003130
1000309e:	5e                   	pop    esi
1000309f:	33 c0                	xor    eax,eax
100030a1:	5b                   	pop    ebx
100030a2:	8b e5                	mov    esp,ebp
100030a4:	5d                   	pop    ebp
100030a5:	c2 04 00             	ret    0x4
100030a8:	8b ce                	mov    ecx,esi
100030aa:	e8 21 07 00 00       	call   0x100037d0
100030af:	84 c0                	test   al,al
100030b1:	75 13                	jne    0x100030c6
100030b3:	8b 0d cc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5cc
100030b9:	6a 00                	push   0x0
100030bb:	8b 89 cc 00 00 00    	mov    ecx,DWORD PTR [ecx+0xcc]
100030c1:	8b 11                	mov    edx,DWORD PTR [ecx]
100030c3:	ff 52 08             	call   DWORD PTR [edx+0x8]
100030c6:	8b ce                	mov    ecx,esi
100030c8:	c6 86 ae 01 00 00 01 	mov    BYTE PTR [esi+0x1ae],0x1
100030cf:	e8 5c 00 00 00       	call   0x10003130
100030d4:	5e                   	pop    esi
100030d5:	33 c0                	xor    eax,eax
100030d7:	5b                   	pop    ebx
100030d8:	8b e5                	mov    esp,ebp
100030da:	5d                   	pop    ebp
100030db:	c2 04 00             	ret    0x4
100030de:	57                   	push   edi
100030df:	8b ce                	mov    ecx,esi
100030e1:	e8 1a 01 00 00       	call   0x10003200
100030e6:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
100030e9:	e8 42 f2 ff ff       	call   0x10002330
100030ee:	8b 86 a0 01 00 00    	mov    eax,DWORD PTR [esi+0x1a0]
100030f4:	33 ff                	xor    edi,edi
100030f6:	85 c0                	test   eax,eax
100030f8:	7e 1f                	jle    0x10003119
100030fa:	8d 5e 10             	lea    ebx,[esi+0x10]
100030fd:	8b 86 d4 01 00 00    	mov    eax,DWORD PTR [esi+0x1d4]
10003103:	8b 0b                	mov    ecx,DWORD PTR [ebx]
10003105:	50                   	push   eax
10003106:	e8 75 e2 ff ff       	call   0x10001380
1000310b:	8b 86 a0 01 00 00    	mov    eax,DWORD PTR [esi+0x1a0]
10003111:	47                   	inc    edi
10003112:	83 c3 04             	add    ebx,0x4
10003115:	3b f8                	cmp    edi,eax
10003117:	7c e4                	jl     0x100030fd
10003119:	5f                   	pop    edi
1000311a:	5e                   	pop    esi
1000311b:	33 c0                	xor    eax,eax
1000311d:	5b                   	pop    ebx
1000311e:	8b e5                	mov    esp,ebp
10003120:	5d                   	pop    ebp
10003121:	c2 04 00             	ret    0x4
10003124:	90                   	nop
10003125:	90                   	nop
10003126:	90                   	nop
10003127:	90                   	nop
10003128:	90                   	nop
10003129:	90                   	nop
1000312a:	90                   	nop
1000312b:	90                   	nop
1000312c:	90                   	nop
1000312d:	90                   	nop
1000312e:	90                   	nop
1000312f:	90                   	nop
10003130:	53                   	push   ebx
10003131:	56                   	push   esi
10003132:	8b f1                	mov    esi,ecx
10003134:	b8 01 00 00 00       	mov    eax,0x1
10003139:	33 db                	xor    ebx,ebx
1000313b:	a2 ec f5 00 10       	mov    ds:0x1000f5ec,al
10003140:	8b 8e d4 01 00 00    	mov    ecx,DWORD PTR [esi+0x1d4]
10003146:	88 9e ac 01 00 00    	mov    BYTE PTR [esi+0x1ac],bl
1000314c:	a3 fc f5 00 10       	mov    ds:0x1000f5fc,eax
10003151:	a1 cc f5 00 10       	mov    eax,ds:0x1000f5cc
10003156:	89 0d f8 f5 00 10    	mov    DWORD PTR ds:0x1000f5f8,ecx
1000315c:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10003162:	89 1d f4 f5 00 10    	mov    DWORD PTR ds:0x1000f5f4,ebx
10003168:	8b 80 c4 00 00 00    	mov    eax,DWORD PTR [eax+0xc4]
1000316e:	8b 11                	mov    edx,DWORD PTR [ecx]
10003170:	57                   	push   edi
10003171:	53                   	push   ebx
10003172:	50                   	push   eax
10003173:	ff 52 08             	call   DWORD PTR [edx+0x8]
10003176:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
1000317c:	a3 e8 f5 00 10       	mov    ds:0x1000f5e8,eax
10003181:	50                   	push   eax
10003182:	8b 11                	mov    edx,DWORD PTR [ecx]
10003184:	ff 52 18             	call   DWORD PTR [edx+0x18]
10003187:	8b 0d e8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5e8
1000318d:	8b 01                	mov    eax,DWORD PTR [ecx]
1000318f:	ff 50 2c             	call   DWORD PTR [eax+0x2c]
10003192:	8b 76 0c             	mov    esi,DWORD PTR [esi+0xc]
10003195:	8b 0d e8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5e8
1000319b:	53                   	push   ebx
1000319c:	8b 46 24             	mov    eax,DWORD PTR [esi+0x24]
1000319f:	8b 39                	mov    edi,DWORD PTR [ecx]
100031a1:	d9 46 14             	fld    DWORD PTR [esi+0x14]
100031a4:	99                   	cdq
100031a5:	2b c2                	sub    eax,edx
100031a7:	8b d8                	mov    ebx,eax
100031a9:	d1 fb                	sar    ebx,1
100031ab:	e8 60 1f 00 00       	call   0x10005110
100031b0:	2b c3                	sub    eax,ebx
100031b2:	50                   	push   eax
100031b3:	8b 46 20             	mov    eax,DWORD PTR [esi+0x20]
100031b6:	d9 46 10             	fld    DWORD PTR [esi+0x10]
100031b9:	99                   	cdq
100031ba:	2b c2                	sub    eax,edx
100031bc:	8b d8                	mov    ebx,eax
100031be:	d1 fb                	sar    ebx,1
100031c0:	e8 4b 1f 00 00       	call   0x10005110
100031c5:	8b 0d e8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5e8
100031cb:	2b c3                	sub    eax,ebx
100031cd:	50                   	push   eax
100031ce:	ff 57 08             	call   DWORD PTR [edi+0x8]
100031d1:	5f                   	pop    edi
100031d2:	5e                   	pop    esi
100031d3:	5b                   	pop    ebx
100031d4:	c3                   	ret
100031d5:	90                   	nop
100031d6:	90                   	nop
100031d7:	90                   	nop
100031d8:	90                   	nop
100031d9:	90                   	nop
100031da:	90                   	nop
100031db:	90                   	nop
100031dc:	90                   	nop
100031dd:	90                   	nop
100031de:	90                   	nop
100031df:	90                   	nop
100031e0:	55                   	push   ebp
100031e1:	8b ec                	mov    ebp,esp
100031e3:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100031e6:	50                   	push   eax
100031e7:	8b 08                	mov    ecx,DWORD PTR [eax]
100031e9:	e8 b2 fc ff ff       	call   0x10002ea0
100031ee:	5d                   	pop    ebp
100031ef:	c3                   	ret
100031f0:	55                   	push   ebp
100031f1:	8b ec                	mov    ebp,esp
100031f3:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100031f6:	50                   	push   eax
100031f7:	8b 08                	mov    ecx,DWORD PTR [eax]
100031f9:	e8 22 fc ff ff       	call   0x10002e20
100031fe:	5d                   	pop    ebp
100031ff:	c3                   	ret
10003200:	53                   	push   ebx
10003201:	56                   	push   esi
10003202:	8b f1                	mov    esi,ecx
10003204:	bb 01 00 00 00       	mov    ebx,0x1
10003209:	8b 0d c8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c8
1000320f:	8a 86 c0 01 00 00    	mov    al,BYTE PTR [esi+0x1c0]
10003215:	84 c0                	test   al,al
10003217:	74 43                	je     0x1000325c
10003219:	8b 01                	mov    eax,DWORD PTR [ecx]
1000321b:	6a 07                	push   0x7
1000321d:	ff 50 20             	call   DWORD PTR [eax+0x20]
10003220:	a8 80                	test   al,0x80
10003222:	74 28                	je     0x1000324c
10003224:	8b 8e d4 01 00 00    	mov    ecx,DWORD PTR [esi+0x1d4]
1000322a:	8b 96 c4 01 00 00    	mov    edx,DWORD PTR [esi+0x1c4]
10003230:	2b ca                	sub    ecx,edx
10003232:	83 f9 0a             	cmp    ecx,0xa
10003235:	76 58                	jbe    0x1000328f
10003237:	f6 05 f0 f5 00 10 02 	test   BYTE PTR ds:0x1000f5f0,0x2
1000323e:	74 4f                	je     0x1000328f
10003240:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
10003243:	6a 02                	push   0x2
10003245:	e8 c6 ee ff ff       	call   0x10002110
1000324a:	eb 43                	jmp    0x1000328f
1000324c:	c6 86 c0 01 00 00 00 	mov    BYTE PTR [esi+0x1c0],0x0
10003253:	a1 f0 f5 00 10       	mov    eax,ds:0x1000f5f0
10003258:	24 fd                	and    al,0xfd
1000325a:	eb 2e                	jmp    0x1000328a
1000325c:	8b 11                	mov    edx,DWORD PTR [ecx]
1000325e:	6a 07                	push   0x7
10003260:	ff 52 20             	call   DWORD PTR [edx+0x20]
10003263:	a8 80                	test   al,0x80
10003265:	74 28                	je     0x1000328f
10003267:	8b 86 d4 01 00 00    	mov    eax,DWORD PTR [esi+0x1d4]
1000326d:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
10003270:	6a 02                	push   0x2
10003272:	89 86 c4 01 00 00    	mov    DWORD PTR [esi+0x1c4],eax
10003278:	88 9e c0 01 00 00    	mov    BYTE PTR [esi+0x1c0],bl
1000327e:	e8 8d ee ff ff       	call   0x10002110
10003283:	a1 f0 f5 00 10       	mov    eax,ds:0x1000f5f0
10003288:	0c 02                	or     al,0x2
1000328a:	a3 f0 f5 00 10       	mov    ds:0x1000f5f0,eax
1000328f:	8a 86 c1 01 00 00    	mov    al,BYTE PTR [esi+0x1c1]
10003295:	8b 0d c8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c8
1000329b:	84 c0                	test   al,al
1000329d:	8b 11                	mov    edx,DWORD PTR [ecx]
1000329f:	6a 06                	push   0x6
100032a1:	74 3d                	je     0x100032e0
100032a3:	ff 52 20             	call   DWORD PTR [edx+0x20]
100032a6:	a8 80                	test   al,0x80
100032a8:	74 26                	je     0x100032d0
100032aa:	8b 86 d4 01 00 00    	mov    eax,DWORD PTR [esi+0x1d4]
100032b0:	8b 96 c8 01 00 00    	mov    edx,DWORD PTR [esi+0x1c8]
100032b6:	2b c2                	sub    eax,edx
100032b8:	83 f8 0a             	cmp    eax,0xa
100032bb:	76 51                	jbe    0x1000330e
100032bd:	84 1d f0 f5 00 10    	test   BYTE PTR ds:0x1000f5f0,bl
100032c3:	74 49                	je     0x1000330e
100032c5:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
100032c8:	53                   	push   ebx
100032c9:	e8 42 ee ff ff       	call   0x10002110
100032ce:	eb 3e                	jmp    0x1000330e
100032d0:	c6 86 c1 01 00 00 00 	mov    BYTE PTR [esi+0x1c1],0x0
100032d7:	a1 f0 f5 00 10       	mov    eax,ds:0x1000f5f0
100032dc:	24 fe                	and    al,0xfe
100032de:	eb 29                	jmp    0x10003309
100032e0:	ff 52 20             	call   DWORD PTR [edx+0x20]
100032e3:	a8 80                	test   al,0x80
100032e5:	74 27                	je     0x1000330e
100032e7:	8b 86 d4 01 00 00    	mov    eax,DWORD PTR [esi+0x1d4]
100032ed:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
100032f0:	53                   	push   ebx
100032f1:	89 86 c8 01 00 00    	mov    DWORD PTR [esi+0x1c8],eax
100032f7:	88 9e c1 01 00 00    	mov    BYTE PTR [esi+0x1c1],bl
100032fd:	e8 0e ee ff ff       	call   0x10002110
10003302:	a1 f0 f5 00 10       	mov    eax,ds:0x1000f5f0
10003307:	0b c3                	or     eax,ebx
10003309:	a3 f0 f5 00 10       	mov    ds:0x1000f5f0,eax
1000330e:	8a 86 c2 01 00 00    	mov    al,BYTE PTR [esi+0x1c2]
10003314:	8b 0d c8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c8
1000331a:	84 c0                	test   al,al
1000331c:	8b 11                	mov    edx,DWORD PTR [ecx]
1000331e:	6a 08                	push   0x8
10003320:	74 3f                	je     0x10003361
10003322:	ff 52 20             	call   DWORD PTR [edx+0x20]
10003325:	a8 80                	test   al,0x80
10003327:	74 28                	je     0x10003351
10003329:	8b 86 d4 01 00 00    	mov    eax,DWORD PTR [esi+0x1d4]
1000332f:	8b 96 cc 01 00 00    	mov    edx,DWORD PTR [esi+0x1cc]
10003335:	2b c2                	sub    eax,edx
10003337:	83 f8 0a             	cmp    eax,0xa
1000333a:	76 54                	jbe    0x10003390
1000333c:	f6 05 f0 f5 00 10 04 	test   BYTE PTR ds:0x1000f5f0,0x4
10003343:	74 4b                	je     0x10003390
10003345:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
10003348:	6a 03                	push   0x3
1000334a:	e8 c1 ed ff ff       	call   0x10002110
1000334f:	eb 3f                	jmp    0x10003390
10003351:	c6 86 c2 01 00 00 00 	mov    BYTE PTR [esi+0x1c2],0x0
10003358:	a1 f0 f5 00 10       	mov    eax,ds:0x1000f5f0
1000335d:	24 fb                	and    al,0xfb
1000335f:	eb 2a                	jmp    0x1000338b
10003361:	ff 52 20             	call   DWORD PTR [edx+0x20]
10003364:	a8 80                	test   al,0x80
10003366:	74 28                	je     0x10003390
10003368:	8b 86 d4 01 00 00    	mov    eax,DWORD PTR [esi+0x1d4]
1000336e:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
10003371:	6a 03                	push   0x3
10003373:	89 86 cc 01 00 00    	mov    DWORD PTR [esi+0x1cc],eax
10003379:	88 9e c2 01 00 00    	mov    BYTE PTR [esi+0x1c2],bl
1000337f:	e8 8c ed ff ff       	call   0x10002110
10003384:	a1 f0 f5 00 10       	mov    eax,ds:0x1000f5f0
10003389:	0c 04                	or     al,0x4
1000338b:	a3 f0 f5 00 10       	mov    ds:0x1000f5f0,eax
10003390:	8a 86 c3 01 00 00    	mov    al,BYTE PTR [esi+0x1c3]
10003396:	8b 0d c8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c8
1000339c:	84 c0                	test   al,al
1000339e:	8b 11                	mov    edx,DWORD PTR [ecx]
100033a0:	6a 09                	push   0x9
100033a2:	74 46                	je     0x100033ea
100033a4:	ff 52 20             	call   DWORD PTR [edx+0x20]
100033a7:	a8 80                	test   al,0x80
100033a9:	74 29                	je     0x100033d4
100033ab:	8b 86 d4 01 00 00    	mov    eax,DWORD PTR [esi+0x1d4]
100033b1:	8b 96 d0 01 00 00    	mov    edx,DWORD PTR [esi+0x1d0]
100033b7:	2b c2                	sub    eax,edx
100033b9:	83 f8 0a             	cmp    eax,0xa
100033bc:	76 5b                	jbe    0x10003419
100033be:	f6 05 f0 f5 00 10 08 	test   BYTE PTR ds:0x1000f5f0,0x8
100033c5:	74 52                	je     0x10003419
100033c7:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
100033ca:	6a 04                	push   0x4
100033cc:	e8 3f ed ff ff       	call   0x10002110
100033d1:	5e                   	pop    esi
100033d2:	5b                   	pop    ebx
100033d3:	c3                   	ret
100033d4:	c6 86 c3 01 00 00 00 	mov    BYTE PTR [esi+0x1c3],0x0
100033db:	a1 f0 f5 00 10       	mov    eax,ds:0x1000f5f0
100033e0:	24 f7                	and    al,0xf7
100033e2:	5e                   	pop    esi
100033e3:	a3 f0 f5 00 10       	mov    ds:0x1000f5f0,eax
100033e8:	5b                   	pop    ebx
100033e9:	c3                   	ret
100033ea:	ff 52 20             	call   DWORD PTR [edx+0x20]
100033ed:	a8 80                	test   al,0x80
100033ef:	74 28                	je     0x10003419
100033f1:	8b 86 d4 01 00 00    	mov    eax,DWORD PTR [esi+0x1d4]
100033f7:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
100033fa:	6a 04                	push   0x4
100033fc:	89 86 d0 01 00 00    	mov    DWORD PTR [esi+0x1d0],eax
10003402:	88 9e c3 01 00 00    	mov    BYTE PTR [esi+0x1c3],bl
10003408:	e8 03 ed ff ff       	call   0x10002110
1000340d:	a1 f0 f5 00 10       	mov    eax,ds:0x1000f5f0
10003412:	0c 08                	or     al,0x8
10003414:	a3 f0 f5 00 10       	mov    ds:0x1000f5f0,eax
10003419:	5e                   	pop    esi
1000341a:	5b                   	pop    ebx
1000341b:	c3                   	ret
1000341c:	90                   	nop
1000341d:	90                   	nop
1000341e:	90                   	nop
1000341f:	90                   	nop
10003420:	55                   	push   ebp
10003421:	8b ec                	mov    ebp,esp
10003423:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10003426:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
10003429:	56                   	push   esi
1000342a:	8b 10                	mov    edx,DWORD PTR [eax]
1000342c:	8b 71 08             	mov    esi,DWORD PTR [ecx+0x8]
1000342f:	3b d6                	cmp    edx,esi
10003431:	7f 25                	jg     0x10003458
10003433:	8b 50 08             	mov    edx,DWORD PTR [eax+0x8]
10003436:	8b 31                	mov    esi,DWORD PTR [ecx]
10003438:	3b d6                	cmp    edx,esi
1000343a:	7c 1c                	jl     0x10003458
1000343c:	8b 50 04             	mov    edx,DWORD PTR [eax+0x4]
1000343f:	8b 71 0c             	mov    esi,DWORD PTR [ecx+0xc]
10003442:	3b d6                	cmp    edx,esi
10003444:	7f 12                	jg     0x10003458
10003446:	8b 40 0c             	mov    eax,DWORD PTR [eax+0xc]
10003449:	8b 51 04             	mov    edx,DWORD PTR [ecx+0x4]
1000344c:	3b c2                	cmp    eax,edx
1000344e:	7c 08                	jl     0x10003458
10003450:	b8 01 00 00 00       	mov    eax,0x1
10003455:	5e                   	pop    esi
10003456:	5d                   	pop    ebp
10003457:	c3                   	ret
10003458:	33 c0                	xor    eax,eax
1000345a:	5e                   	pop    esi
1000345b:	5d                   	pop    ebp
1000345c:	c3                   	ret
1000345d:	90                   	nop
1000345e:	90                   	nop
1000345f:	90                   	nop
10003460:	55                   	push   ebp
10003461:	8b ec                	mov    ebp,esp
10003463:	6a ff                	push   0xffffffff
10003465:	68 61 c6 00 10       	push   0x1000c661
1000346a:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10003470:	50                   	push   eax
10003471:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10003478:	83 ec 2c             	sub    esp,0x2c
1000347b:	53                   	push   ebx
1000347c:	56                   	push   esi
1000347d:	8b f1                	mov    esi,ecx
1000347f:	8d 45 c8             	lea    eax,[ebp-0x38]
10003482:	57                   	push   edi
10003483:	50                   	push   eax
10003484:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
10003487:	e8 f4 ef ff ff       	call   0x10002480
1000348c:	8b 8e a0 01 00 00    	mov    ecx,DWORD PTR [esi+0x1a0]
10003492:	c7 45 f0 00 00 00 00 	mov    DWORD PTR [ebp-0x10],0x0
10003499:	85 c9                	test   ecx,ecx
1000349b:	7e 19                	jle    0x100034b6
1000349d:	8b 56 0c             	mov    edx,DWORD PTR [esi+0xc]
100034a0:	8d 46 10             	lea    eax,[esi+0x10]
100034a3:	8b 3a                	mov    edi,DWORD PTR [edx]
100034a5:	8b d1                	mov    edx,ecx
100034a7:	8b 18                	mov    ebx,DWORD PTR [eax]
100034a9:	39 3b                	cmp    DWORD PTR [ebx],edi
100034ab:	7f 03                	jg     0x100034b0
100034ad:	ff 45 f0             	inc    DWORD PTR [ebp-0x10]
100034b0:	83 c0 04             	add    eax,0x4
100034b3:	4a                   	dec    edx
100034b4:	75 f1                	jne    0x100034a7
100034b6:	85 c9                	test   ecx,ecx
100034b8:	c7 45 ec 00 00 00 00 	mov    DWORD PTR [ebp-0x14],0x0
100034bf:	0f 8e 7d 01 00 00    	jle    0x10003642
100034c5:	8d 5e 10             	lea    ebx,[esi+0x10]
100034c8:	8b 0b                	mov    ecx,DWORD PTR [ebx]
100034ca:	8d 45 d8             	lea    eax,[ebp-0x28]
100034cd:	50                   	push   eax
100034ce:	e8 2d db ff ff       	call   0x10001000
100034d3:	8d 4d d8             	lea    ecx,[ebp-0x28]
100034d6:	8d 55 c8             	lea    edx,[ebp-0x38]
100034d9:	51                   	push   ecx
100034da:	52                   	push   edx
100034db:	e8 40 ff ff ff       	call   0x10003420
100034e0:	83 c4 08             	add    esp,0x8
100034e3:	84 c0                	test   al,al
100034e5:	0f 84 3f 01 00 00    	je     0x1000362a
100034eb:	8b 03                	mov    eax,DWORD PTR [ebx]
100034ed:	8b 48 04             	mov    ecx,DWORD PTR [eax+0x4]
100034f0:	85 c9                	test   ecx,ecx
100034f2:	0f 85 32 01 00 00    	jne    0x1000362a
100034f8:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
100034fb:	50                   	push   eax
100034fc:	e8 df ef ff ff       	call   0x100024e0
10003501:	84 c0                	test   al,al
10003503:	0f 85 4c 01 00 00    	jne    0x10003655
10003509:	8b 3b                	mov    edi,DWORD PTR [ebx]
1000350b:	85 ff                	test   edi,edi
1000350d:	74 10                	je     0x1000351f
1000350f:	8b cf                	mov    ecx,edi
10003511:	e8 2a de ff ff       	call   0x10001340
10003516:	57                   	push   edi
10003517:	e8 7b 1c 00 00       	call   0x10005197
1000351c:	83 c4 04             	add    esp,0x4
1000351f:	8b 46 0c             	mov    eax,DWORD PTR [esi+0xc]
10003522:	8b 08                	mov    ecx,DWORD PTR [eax]
10003524:	8d 44 09 04          	lea    eax,[ecx+ecx*1+0x4]
10003528:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
1000352b:	99                   	cdq
1000352c:	83 e2 03             	and    edx,0x3
1000352f:	03 c2                	add    eax,edx
10003531:	c1 f8 02             	sar    eax,0x2
10003534:	3b c8                	cmp    ecx,eax
10003536:	7f 3c                	jg     0x10003574
10003538:	6a 38                	push   0x38
1000353a:	e8 63 1c 00 00       	call   0x100051a2
1000353f:	8b f8                	mov    edi,eax
10003541:	83 c4 04             	add    esp,0x4
10003544:	89 7d e8             	mov    DWORD PTR [ebp-0x18],edi
10003547:	33 c0                	xor    eax,eax
10003549:	3b f8                	cmp    edi,eax
1000354b:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
1000354e:	0f 84 c6 00 00 00    	je     0x1000361a
10003554:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
1000355a:	8b 11                	mov    edx,DWORD PTR [ecx]
1000355c:	ff 52 08             	call   DWORD PTR [edx+0x8]
1000355f:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
10003562:	33 d2                	xor    edx,edx
10003564:	f7 31                	div    DWORD PTR [ecx]
10003566:	8b cf                	mov    ecx,edi
10003568:	42                   	inc    edx
10003569:	52                   	push   edx
1000356a:	e8 31 dc ff ff       	call   0x100011a0
1000356f:	e9 a6 00 00 00       	jmp    0x1000361a
10003574:	8b 86 a0 01 00 00    	mov    eax,DWORD PTR [esi+0x1a0]
1000357a:	6a 38                	push   0x38
1000357c:	8d 04 40             	lea    eax,[eax+eax*2]
1000357f:	99                   	cdq
10003580:	83 e2 03             	and    edx,0x3
10003583:	03 c2                	add    eax,edx
10003585:	c1 f8 02             	sar    eax,0x2
10003588:	3b c8                	cmp    ecx,eax
1000358a:	7c 30                	jl     0x100035bc
1000358c:	e8 11 1c 00 00       	call   0x100051a2
10003591:	83 c4 04             	add    esp,0x4
10003594:	89 45 e8             	mov    DWORD PTR [ebp-0x18],eax
10003597:	85 c0                	test   eax,eax
10003599:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [ebp-0x4],0x1
100035a0:	74 76                	je     0x10003618
100035a2:	8b 56 0c             	mov    edx,DWORD PTR [esi+0xc]
100035a5:	8b 12                	mov    edx,DWORD PTR [edx]
100035a7:	42                   	inc    edx
100035a8:	83 fa 0a             	cmp    edx,0xa
100035ab:	7c 05                	jl     0x100035b2
100035ad:	ba 0a 00 00 00       	mov    edx,0xa
100035b2:	52                   	push   edx
100035b3:	8b c8                	mov    ecx,eax
100035b5:	e8 e6 db ff ff       	call   0x100011a0
100035ba:	eb 5e                	jmp    0x1000361a
100035bc:	e8 e1 1b 00 00       	call   0x100051a2
100035c1:	8b f8                	mov    edi,eax
100035c3:	83 c4 04             	add    esp,0x4
100035c6:	89 7d e8             	mov    DWORD PTR [ebp-0x18],edi
100035c9:	85 ff                	test   edi,edi
100035cb:	c7 45 fc 02 00 00 00 	mov    DWORD PTR [ebp-0x4],0x2
100035d2:	74 44                	je     0x10003618
100035d4:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
100035da:	8b 01                	mov    eax,DWORD PTR [ecx]
100035dc:	ff 50 08             	call   DWORD PTR [eax+0x8]
100035df:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
100035e2:	33 d2                	xor    edx,edx
100035e4:	f7 31                	div    DWORD PTR [ecx]
100035e6:	42                   	inc    edx
100035e7:	83 fa 0a             	cmp    edx,0xa
100035ea:	73 1d                	jae    0x10003609
100035ec:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
100035f2:	8b 11                	mov    edx,DWORD PTR [ecx]
100035f4:	ff 52 08             	call   DWORD PTR [edx+0x8]
100035f7:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
100035fa:	33 d2                	xor    edx,edx
100035fc:	f7 31                	div    DWORD PTR [ecx]
100035fe:	8b cf                	mov    ecx,edi
10003600:	42                   	inc    edx
10003601:	52                   	push   edx
10003602:	e8 99 db ff ff       	call   0x100011a0
10003607:	eb 11                	jmp    0x1000361a
10003609:	ba 0a 00 00 00       	mov    edx,0xa
1000360e:	8b cf                	mov    ecx,edi
10003610:	52                   	push   edx
10003611:	e8 8a db ff ff       	call   0x100011a0
10003616:	eb 02                	jmp    0x1000361a
10003618:	33 c0                	xor    eax,eax
1000361a:	89 03                	mov    DWORD PTR [ebx],eax
1000361c:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
1000361f:	48                   	dec    eax
10003620:	c7 45 fc ff ff ff ff 	mov    DWORD PTR [ebp-0x4],0xffffffff
10003627:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax
1000362a:	8b 45 ec             	mov    eax,DWORD PTR [ebp-0x14]
1000362d:	8b 8e a0 01 00 00    	mov    ecx,DWORD PTR [esi+0x1a0]
10003633:	40                   	inc    eax
10003634:	83 c3 04             	add    ebx,0x4
10003637:	3b c1                	cmp    eax,ecx
10003639:	89 45 ec             	mov    DWORD PTR [ebp-0x14],eax
1000363c:	0f 8c 86 fe ff ff    	jl     0x100034c8
10003642:	5f                   	pop    edi
10003643:	5e                   	pop    esi
10003644:	32 c0                	xor    al,al
10003646:	5b                   	pop    ebx
10003647:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
1000364a:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
10003651:	8b e5                	mov    esp,ebp
10003653:	5d                   	pop    ebp
10003654:	c3                   	ret
10003655:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
10003658:	5f                   	pop    edi
10003659:	5e                   	pop    esi
1000365a:	b0 01                	mov    al,0x1
1000365c:	5b                   	pop    ebx
1000365d:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
10003664:	8b e5                	mov    esp,ebp
10003666:	5d                   	pop    ebp
10003667:	c3                   	ret
10003668:	90                   	nop
10003669:	90                   	nop
1000366a:	90                   	nop
1000366b:	90                   	nop
1000366c:	90                   	nop
1000366d:	90                   	nop
1000366e:	90                   	nop
1000366f:	90                   	nop
10003670:	55                   	push   ebp
10003671:	8b ec                	mov    ebp,esp
10003673:	6a ff                	push   0xffffffff
10003675:	68 91 c6 00 10       	push   0x1000c691
1000367a:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10003680:	50                   	push   eax
10003681:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10003688:	51                   	push   ecx
10003689:	56                   	push   esi
1000368a:	8b f1                	mov    esi,ecx
1000368c:	57                   	push   edi
1000368d:	33 ff                	xor    edi,edi
1000368f:	8b 8e a0 01 00 00    	mov    ecx,DWORD PTR [esi+0x1a0]
10003695:	85 c9                	test   ecx,ecx
10003697:	7e 17                	jle    0x100036b0
10003699:	8b 46 0c             	mov    eax,DWORD PTR [esi+0xc]
1000369c:	53                   	push   ebx
1000369d:	8b 10                	mov    edx,DWORD PTR [eax]
1000369f:	8d 46 10             	lea    eax,[esi+0x10]
100036a2:	8b 18                	mov    ebx,DWORD PTR [eax]
100036a4:	39 13                	cmp    DWORD PTR [ebx],edx
100036a6:	7f 01                	jg     0x100036a9
100036a8:	47                   	inc    edi
100036a9:	83 c0 04             	add    eax,0x4
100036ac:	49                   	dec    ecx
100036ad:	75 f3                	jne    0x100036a2
100036af:	5b                   	pop    ebx
100036b0:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
100036b3:	8b 09                	mov    ecx,DWORD PTR [ecx]
100036b5:	8d 44 09 04          	lea    eax,[ecx+ecx*1+0x4]
100036b9:	99                   	cdq
100036ba:	83 e2 03             	and    edx,0x3
100036bd:	03 c2                	add    eax,edx
100036bf:	c1 f8 02             	sar    eax,0x2
100036c2:	3b f8                	cmp    edi,eax
100036c4:	7d 3c                	jge    0x10003702
100036c6:	6a 38                	push   0x38
100036c8:	e8 d5 1a 00 00       	call   0x100051a2
100036cd:	8b f8                	mov    edi,eax
100036cf:	83 c4 04             	add    esp,0x4
100036d2:	89 7d f0             	mov    DWORD PTR [ebp-0x10],edi
100036d5:	33 c0                	xor    eax,eax
100036d7:	3b f8                	cmp    edi,eax
100036d9:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
100036dc:	0f 84 c3 00 00 00    	je     0x100037a5
100036e2:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
100036e8:	8b 11                	mov    edx,DWORD PTR [ecx]
100036ea:	ff 52 08             	call   DWORD PTR [edx+0x8]
100036ed:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
100036f0:	33 d2                	xor    edx,edx
100036f2:	f7 31                	div    DWORD PTR [ecx]
100036f4:	8b cf                	mov    ecx,edi
100036f6:	42                   	inc    edx
100036f7:	52                   	push   edx
100036f8:	e8 a3 da ff ff       	call   0x100011a0
100036fd:	e9 a3 00 00 00       	jmp    0x100037a5
10003702:	8d 44 49 06          	lea    eax,[ecx+ecx*2+0x6]
10003706:	6a 38                	push   0x38
10003708:	d1 e0                	shl    eax,1
1000370a:	99                   	cdq
1000370b:	83 e2 03             	and    edx,0x3
1000370e:	03 c2                	add    eax,edx
10003710:	c1 f8 02             	sar    eax,0x2
10003713:	3b f8                	cmp    edi,eax
10003715:	7e 30                	jle    0x10003747
10003717:	e8 86 1a 00 00       	call   0x100051a2
1000371c:	83 c4 04             	add    esp,0x4
1000371f:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax
10003722:	85 c0                	test   eax,eax
10003724:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [ebp-0x4],0x1
1000372b:	74 76                	je     0x100037a3
1000372d:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
10003730:	8b 11                	mov    edx,DWORD PTR [ecx]
10003732:	42                   	inc    edx
10003733:	83 fa 0a             	cmp    edx,0xa
10003736:	7c 05                	jl     0x1000373d
10003738:	ba 0a 00 00 00       	mov    edx,0xa
1000373d:	52                   	push   edx
1000373e:	8b c8                	mov    ecx,eax
10003740:	e8 5b da ff ff       	call   0x100011a0
10003745:	eb 5e                	jmp    0x100037a5
10003747:	e8 56 1a 00 00       	call   0x100051a2
1000374c:	8b f8                	mov    edi,eax
1000374e:	83 c4 04             	add    esp,0x4
10003751:	89 7d f0             	mov    DWORD PTR [ebp-0x10],edi
10003754:	85 ff                	test   edi,edi
10003756:	c7 45 fc 02 00 00 00 	mov    DWORD PTR [ebp-0x4],0x2
1000375d:	74 44                	je     0x100037a3
1000375f:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
10003765:	8b 01                	mov    eax,DWORD PTR [ecx]
10003767:	ff 50 08             	call   DWORD PTR [eax+0x8]
1000376a:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
1000376d:	33 d2                	xor    edx,edx
1000376f:	f7 31                	div    DWORD PTR [ecx]
10003771:	42                   	inc    edx
10003772:	83 fa 0a             	cmp    edx,0xa
10003775:	73 1d                	jae    0x10003794
10003777:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
1000377d:	8b 11                	mov    edx,DWORD PTR [ecx]
1000377f:	ff 52 08             	call   DWORD PTR [edx+0x8]
10003782:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
10003785:	33 d2                	xor    edx,edx
10003787:	f7 31                	div    DWORD PTR [ecx]
10003789:	8b cf                	mov    ecx,edi
1000378b:	42                   	inc    edx
1000378c:	52                   	push   edx
1000378d:	e8 0e da ff ff       	call   0x100011a0
10003792:	eb 11                	jmp    0x100037a5
10003794:	ba 0a 00 00 00       	mov    edx,0xa
10003799:	8b cf                	mov    ecx,edi
1000379b:	52                   	push   edx
1000379c:	e8 ff d9 ff ff       	call   0x100011a0
100037a1:	eb 02                	jmp    0x100037a5
100037a3:	33 c0                	xor    eax,eax
100037a5:	8b 96 a0 01 00 00    	mov    edx,DWORD PTR [esi+0x1a0]
100037ab:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
100037ae:	5f                   	pop    edi
100037af:	89 44 96 10          	mov    DWORD PTR [esi+edx*4+0x10],eax
100037b3:	8b 86 a0 01 00 00    	mov    eax,DWORD PTR [esi+0x1a0]
100037b9:	40                   	inc    eax
100037ba:	89 86 a0 01 00 00    	mov    DWORD PTR [esi+0x1a0],eax
100037c0:	5e                   	pop    esi
100037c1:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
100037c8:	8b e5                	mov    esp,ebp
100037ca:	5d                   	pop    ebp
100037cb:	c3                   	ret
100037cc:	90                   	nop
100037cd:	90                   	nop
100037ce:	90                   	nop
100037cf:	90                   	nop
100037d0:	55                   	push   ebp
100037d1:	8b ec                	mov    ebp,esp
100037d3:	81 ec a4 00 00 00    	sub    esp,0xa4
100037d9:	53                   	push   ebx
100037da:	56                   	push   esi
100037db:	8b f1                	mov    esi,ecx
100037dd:	bb 01 00 00 00       	mov    ebx,0x1
100037e2:	89 75 c0             	mov    DWORD PTR [ebp-0x40],esi
100037e5:	53                   	push   ebx
100037e6:	8d 45 ec             	lea    eax,[ebp-0x14]
100037e9:	68 1c e6 00 10       	push   0x1000e61c
100037ee:	50                   	push   eax
100037ef:	e8 bc 19 00 00       	call   0x100051b0
100037f4:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
100037fa:	83 c4 0c             	add    esp,0xc
100037fd:	8d 85 5c ff ff ff    	lea    eax,[ebp-0xa4]
10003803:	8b 11                	mov    edx,DWORD PTR [ecx]
10003805:	50                   	push   eax
10003806:	8d 45 ec             	lea    eax,[ebp-0x14]
10003809:	50                   	push   eax
1000380a:	ff 52 14             	call   DWORD PTR [edx+0x14]
1000380d:	8d 8d 5c ff ff ff    	lea    ecx,[ebp-0xa4]
10003813:	51                   	push   ecx
10003814:	e8 c9 1e 00 00       	call   0x100056e2
10003819:	8b 4e 08             	mov    ecx,DWORD PTR [esi+0x8]
1000381c:	83 c4 04             	add    esp,0x4
1000381f:	3b c8                	cmp    ecx,eax
10003821:	7d 0e                	jge    0x10003831
10003823:	43                   	inc    ebx
10003824:	83 fb 05             	cmp    ebx,0x5
10003827:	7e bc                	jle    0x100037e5
10003829:	5e                   	pop    esi
1000382a:	32 c0                	xor    al,al
1000382c:	5b                   	pop    ebx
1000382d:	8b e5                	mov    esp,ebp
1000382f:	5d                   	pop    ebp
10003830:	c3                   	ret
10003831:	8b 15 cc f5 00 10    	mov    edx,DWORD PTR ds:0x1000f5cc
10003837:	57                   	push   edi
10003838:	6a 00                	push   0x0
1000383a:	8b 8a d0 00 00 00    	mov    ecx,DWORD PTR [edx+0xd0]
10003840:	8b 01                	mov    eax,DWORD PTR [ecx]
10003842:	ff 50 08             	call   DWORD PTR [eax+0x8]
10003845:	33 c9                	xor    ecx,ecx
10003847:	33 d2                	xor    edx,edx
10003849:	89 4d d8             	mov    DWORD PTR [ebp-0x28],ecx
1000384c:	89 55 c4             	mov    DWORD PTR [ebp-0x3c],edx
1000384f:	89 4d dc             	mov    DWORD PTR [ebp-0x24],ecx
10003852:	89 55 c8             	mov    DWORD PTR [ebp-0x38],edx
10003855:	89 4d e0             	mov    DWORD PTR [ebp-0x20],ecx
10003858:	89 55 cc             	mov    DWORD PTR [ebp-0x34],edx
1000385b:	89 4d e4             	mov    DWORD PTR [ebp-0x1c],ecx
1000385e:	89 55 d0             	mov    DWORD PTR [ebp-0x30],edx
10003861:	89 4d e8             	mov    DWORD PTR [ebp-0x18],ecx
10003864:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
1000386a:	89 55 d4             	mov    DWORD PTR [ebp-0x2c],edx
1000386d:	8d 55 d8             	lea    edx,[ebp-0x28]
10003870:	8b 01                	mov    eax,DWORD PTR [ecx]
10003872:	52                   	push   edx
10003873:	68 0c e6 00 10       	push   0x1000e60c
10003878:	ff 50 14             	call   DWORD PTR [eax+0x14]
1000387b:	83 f8 19             	cmp    eax,0x19
1000387e:	75 25                	jne    0x100038a5
10003880:	bf 04 e6 00 10       	mov    edi,0x1000e604
10003885:	83 c9 ff             	or     ecx,0xffffffff
10003888:	33 c0                	xor    eax,eax
1000388a:	8d 55 d8             	lea    edx,[ebp-0x28]
1000388d:	f2 ae                	repnz scas al,BYTE PTR es:[edi]
1000388f:	f7 d1                	not    ecx
10003891:	2b f9                	sub    edi,ecx
10003893:	8b c1                	mov    eax,ecx
10003895:	8b f7                	mov    esi,edi
10003897:	8b fa                	mov    edi,edx
10003899:	c1 e9 02             	shr    ecx,0x2
1000389c:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000389e:	8b c8                	mov    ecx,eax
100038a0:	83 e1 03             	and    ecx,0x3
100038a3:	f3 a4                	rep movs BYTE PTR es:[edi],BYTE PTR ds:[esi]
100038a5:	8b 0d c8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c8
100038ab:	6a 01                	push   0x1
100038ad:	8d 45 c4             	lea    eax,[ebp-0x3c]
100038b0:	6a 10                	push   0x10
100038b2:	8b 11                	mov    edx,DWORD PTR [ecx]
100038b4:	50                   	push   eax
100038b5:	8d 45 d8             	lea    eax,[ebp-0x28]
100038b8:	50                   	push   eax
100038b9:	68 ac e5 00 10       	push   0x1000e5ac
100038be:	68 9c e5 00 10       	push   0x1000e59c
100038c3:	ff 52 18             	call   DWORD PTR [edx+0x18]
100038c6:	8d 7d c4             	lea    edi,[ebp-0x3c]
100038c9:	83 c9 ff             	or     ecx,0xffffffff
100038cc:	33 c0                	xor    eax,eax
100038ce:	f2 ae                	repnz scas al,BYTE PTR es:[edi]
100038d0:	f7 d1                	not    ecx
100038d2:	49                   	dec    ecx
100038d3:	83 f9 0c             	cmp    ecx,0xc
100038d6:	76 4d                	jbe    0x10003925
100038d8:	8b 0d c8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c8
100038de:	68 01 01 00 00       	push   0x101
100038e3:	68 64 e5 00 10       	push   0x1000e564
100038e8:	68 54 e5 00 10       	push   0x1000e554
100038ed:	8b 11                	mov    edx,DWORD PTR [ecx]
100038ef:	ff 52 14             	call   DWORD PTR [edx+0x14]
100038f2:	8b 0d c8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c8
100038f8:	6a 01                	push   0x1
100038fa:	8d 55 c4             	lea    edx,[ebp-0x3c]
100038fd:	6a 10                	push   0x10
100038ff:	8b 01                	mov    eax,DWORD PTR [ecx]
10003901:	52                   	push   edx
10003902:	8d 55 d8             	lea    edx,[ebp-0x28]
10003905:	52                   	push   edx
10003906:	68 ac e5 00 10       	push   0x1000e5ac
1000390b:	68 9c e5 00 10       	push   0x1000e59c
10003910:	ff 50 18             	call   DWORD PTR [eax+0x18]
10003913:	8d 7d c4             	lea    edi,[ebp-0x3c]
10003916:	83 c9 ff             	or     ecx,0xffffffff
10003919:	33 c0                	xor    eax,eax
1000391b:	f2 ae                	repnz scas al,BYTE PTR es:[edi]
1000391d:	f7 d1                	not    ecx
1000391f:	49                   	dec    ecx
10003920:	83 f9 0c             	cmp    ecx,0xc
10003923:	77 b3                	ja     0x100038d8
10003925:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
1000392b:	8d 55 c4             	lea    edx,[ebp-0x3c]
1000392e:	52                   	push   edx
1000392f:	68 0c e6 00 10       	push   0x1000e60c
10003934:	8b 01                	mov    eax,DWORD PTR [ecx]
10003936:	ff 50 10             	call   DWORD PTR [eax+0x10]
10003939:	be 04 00 00 00       	mov    esi,0x4
1000393e:	3b de                	cmp    ebx,esi
10003940:	0f 8f a6 00 00 00    	jg     0x100039ec
10003946:	56                   	push   esi
10003947:	8d 45 ec             	lea    eax,[ebp-0x14]
1000394a:	68 48 e5 00 10       	push   0x1000e548
1000394f:	50                   	push   eax
10003950:	e8 5b 18 00 00       	call   0x100051b0
10003955:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
1000395b:	83 c4 0c             	add    esp,0xc
1000395e:	8d 45 d8             	lea    eax,[ebp-0x28]
10003961:	8b 11                	mov    edx,DWORD PTR [ecx]
10003963:	50                   	push   eax
10003964:	8d 45 ec             	lea    eax,[ebp-0x14]
10003967:	50                   	push   eax
10003968:	ff 52 14             	call   DWORD PTR [edx+0x14]
1000396b:	56                   	push   esi
1000396c:	8d 4d ec             	lea    ecx,[ebp-0x14]
1000396f:	68 1c e6 00 10       	push   0x1000e61c
10003974:	51                   	push   ecx
10003975:	e8 36 18 00 00       	call   0x100051b0
1000397a:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
10003980:	83 c4 0c             	add    esp,0xc
10003983:	8d 85 5c ff ff ff    	lea    eax,[ebp-0xa4]
10003989:	8b 11                	mov    edx,DWORD PTR [ecx]
1000398b:	50                   	push   eax
1000398c:	8d 45 ec             	lea    eax,[ebp-0x14]
1000398f:	50                   	push   eax
10003990:	ff 52 14             	call   DWORD PTR [edx+0x14]
10003993:	8d 7e 01             	lea    edi,[esi+0x1]
10003996:	8d 4d ec             	lea    ecx,[ebp-0x14]
10003999:	57                   	push   edi
1000399a:	68 48 e5 00 10       	push   0x1000e548
1000399f:	51                   	push   ecx
100039a0:	e8 0b 18 00 00       	call   0x100051b0
100039a5:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
100039ab:	83 c4 0c             	add    esp,0xc
100039ae:	8d 45 d8             	lea    eax,[ebp-0x28]
100039b1:	8b 11                	mov    edx,DWORD PTR [ecx]
100039b3:	50                   	push   eax
100039b4:	8d 45 ec             	lea    eax,[ebp-0x14]
100039b7:	50                   	push   eax
100039b8:	ff 52 10             	call   DWORD PTR [edx+0x10]
100039bb:	57                   	push   edi
100039bc:	8d 4d ec             	lea    ecx,[ebp-0x14]
100039bf:	68 1c e6 00 10       	push   0x1000e61c
100039c4:	51                   	push   ecx
100039c5:	e8 e6 17 00 00       	call   0x100051b0
100039ca:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
100039d0:	83 c4 0c             	add    esp,0xc
100039d3:	8d 85 5c ff ff ff    	lea    eax,[ebp-0xa4]
100039d9:	8b 11                	mov    edx,DWORD PTR [ecx]
100039db:	50                   	push   eax
100039dc:	8d 45 ec             	lea    eax,[ebp-0x14]
100039df:	50                   	push   eax
100039e0:	ff 52 10             	call   DWORD PTR [edx+0x10]
100039e3:	4e                   	dec    esi
100039e4:	3b f3                	cmp    esi,ebx
100039e6:	0f 8d 5a ff ff ff    	jge    0x10003946
100039ec:	53                   	push   ebx
100039ed:	8d 4d ec             	lea    ecx,[ebp-0x14]
100039f0:	68 48 e5 00 10       	push   0x1000e548
100039f5:	51                   	push   ecx
100039f6:	e8 b5 17 00 00       	call   0x100051b0
100039fb:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
10003a01:	83 c4 0c             	add    esp,0xc
10003a04:	8d 45 c4             	lea    eax,[ebp-0x3c]
10003a07:	8b 11                	mov    edx,DWORD PTR [ecx]
10003a09:	50                   	push   eax
10003a0a:	8d 45 ec             	lea    eax,[ebp-0x14]
10003a0d:	50                   	push   eax
10003a0e:	ff 52 10             	call   DWORD PTR [edx+0x10]
10003a11:	53                   	push   ebx
10003a12:	8d 4d ec             	lea    ecx,[ebp-0x14]
10003a15:	68 1c e6 00 10       	push   0x1000e61c
10003a1a:	51                   	push   ecx
10003a1b:	e8 90 17 00 00       	call   0x100051b0
10003a20:	8b 45 c0             	mov    eax,DWORD PTR [ebp-0x40]
10003a23:	8d 95 5c ff ff ff    	lea    edx,[ebp-0xa4]
10003a29:	6a 0a                	push   0xa
10003a2b:	52                   	push   edx
10003a2c:	8b 48 08             	mov    ecx,DWORD PTR [eax+0x8]
10003a2f:	51                   	push   ecx
10003a30:	e8 79 89 00 00       	call   0x1000c3ae
10003a35:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
10003a3b:	83 c4 18             	add    esp,0x18
10003a3e:	8d 85 5c ff ff ff    	lea    eax,[ebp-0xa4]
10003a44:	8b 11                	mov    edx,DWORD PTR [ecx]
10003a46:	50                   	push   eax
10003a47:	8d 45 ec             	lea    eax,[ebp-0x14]
10003a4a:	50                   	push   eax
10003a4b:	ff 52 10             	call   DWORD PTR [edx+0x10]
10003a4e:	5f                   	pop    edi
10003a4f:	5e                   	pop    esi
10003a50:	b0 01                	mov    al,0x1
10003a52:	5b                   	pop    ebx
10003a53:	8b e5                	mov    esp,ebp
10003a55:	5d                   	pop    ebp
10003a56:	c3                   	ret
10003a57:	90                   	nop
10003a58:	90                   	nop
10003a59:	90                   	nop
10003a5a:	90                   	nop
10003a5b:	90                   	nop
10003a5c:	90                   	nop
10003a5d:	90                   	nop
10003a5e:	90                   	nop
10003a5f:	90                   	nop
10003a60:	55                   	push   ebp
10003a61:	8b ec                	mov    ebp,esp
10003a63:	83 ec 34             	sub    esp,0x34
10003a66:	56                   	push   esi
10003a67:	8b f1                	mov    esi,ecx
10003a69:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10003a6f:	6a 33                	push   0x33
10003a71:	68 99 00 00 00       	push   0x99
10003a76:	68 ff 00 00 00       	push   0xff
10003a7b:	8b 01                	mov    eax,DWORD PTR [ecx]
10003a7d:	ff 50 1c             	call   DWORD PTR [eax+0x1c]
10003a80:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10003a86:	6a 20                	push   0x20
10003a88:	6a 4e                	push   0x4e
10003a8a:	6a 07                	push   0x7
10003a8c:	8b 11                	mov    edx,DWORD PTR [ecx]
10003a8e:	6a 39                	push   0x39
10003a90:	ff 52 10             	call   DWORD PTR [edx+0x10]
10003a93:	8b 86 a4 01 00 00    	mov    eax,DWORD PTR [esi+0x1a4]
10003a99:	8d 4d cc             	lea    ecx,[ebp-0x34]
10003a9c:	50                   	push   eax
10003a9d:	68 2c e6 00 10       	push   0x1000e62c
10003aa2:	51                   	push   ecx
10003aa3:	e8 08 17 00 00       	call   0x100051b0
10003aa8:	a1 b8 f5 00 10       	mov    eax,ds:0x1000f5b8
10003aad:	6a 04                	push   0x4
10003aaf:	8d 55 cc             	lea    edx,[ebp-0x34]
10003ab2:	6a 35                	push   0x35
10003ab4:	52                   	push   edx
10003ab5:	50                   	push   eax
10003ab6:	e8 45 0f 00 00       	call   0x10004a00
10003abb:	83 c4 1c             	add    esp,0x1c
10003abe:	5e                   	pop    esi
10003abf:	8b e5                	mov    esp,ebp
10003ac1:	5d                   	pop    ebp
10003ac2:	c3                   	ret
10003ac3:	90                   	nop
10003ac4:	90                   	nop
10003ac5:	90                   	nop
10003ac6:	90                   	nop
10003ac7:	90                   	nop
10003ac8:	90                   	nop
10003ac9:	90                   	nop
10003aca:	90                   	nop
10003acb:	90                   	nop
10003acc:	90                   	nop
10003acd:	90                   	nop
10003ace:	90                   	nop
10003acf:	90                   	nop
10003ad0:	55                   	push   ebp
10003ad1:	8b ec                	mov    ebp,esp
10003ad3:	83 ec 6c             	sub    esp,0x6c
10003ad6:	53                   	push   ebx
10003ad7:	56                   	push   esi
10003ad8:	8b f1                	mov    esi,ecx
10003ada:	57                   	push   edi
10003adb:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10003ae1:	6a 33                	push   0x33
10003ae3:	68 99 00 00 00       	push   0x99
10003ae8:	68 ff 00 00 00       	push   0xff
10003aed:	8b 01                	mov    eax,DWORD PTR [ecx]
10003aef:	ff 50 1c             	call   DWORD PTR [eax+0x1c]
10003af2:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10003af8:	68 a4 01 00 00       	push   0x1a4
10003afd:	68 f4 01 00 00       	push   0x1f4
10003b02:	68 86 01 00 00       	push   0x186
10003b07:	8b 11                	mov    edx,DWORD PTR [ecx]
10003b09:	68 a9 01 00 00       	push   0x1a9
10003b0e:	ff 52 10             	call   DWORD PTR [edx+0x10]
10003b11:	8b 46 08             	mov    eax,DWORD PTR [esi+0x8]
10003b14:	8d 4d 94             	lea    ecx,[ebp-0x6c]
10003b17:	50                   	push   eax
10003b18:	68 44 e6 00 10       	push   0x1000e644
10003b1d:	51                   	push   ecx
10003b1e:	e8 8d 16 00 00       	call   0x100051b0
10003b23:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10003b29:	83 c4 0c             	add    esp,0xc
10003b2c:	8b 11                	mov    edx,DWORD PTR [ecx]
10003b2e:	6a 01                	push   0x1
10003b30:	6a 18                	push   0x18
10003b32:	68 90 e2 00 10       	push   0x1000e290
10003b37:	ff 52 28             	call   DWORD PTR [edx+0x28]
10003b3a:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10003b40:	8b f0                	mov    esi,eax
10003b42:	56                   	push   esi
10003b43:	8b 01                	mov    eax,DWORD PTR [ecx]
10003b45:	ff 50 48             	call   DWORD PTR [eax+0x48]
10003b48:	8d 4d f8             	lea    ecx,[ebp-0x8]
10003b4b:	8d 7d 94             	lea    edi,[ebp-0x6c]
10003b4e:	51                   	push   ecx
10003b4f:	83 c9 ff             	or     ecx,0xffffffff
10003b52:	33 c0                	xor    eax,eax
10003b54:	8b 15 b8 f5 00 10    	mov    edx,DWORD PTR ds:0x1000f5b8
10003b5a:	f2 ae                	repnz scas al,BYTE PTR es:[edi]
10003b5c:	8b 1a                	mov    ebx,DWORD PTR [edx]
10003b5e:	8d 45 94             	lea    eax,[ebp-0x6c]
10003b61:	f7 d1                	not    ecx
10003b63:	49                   	dec    ecx
10003b64:	51                   	push   ecx
10003b65:	50                   	push   eax
10003b66:	56                   	push   esi
10003b67:	8b ca                	mov    ecx,edx
10003b69:	ff 53 58             	call   DWORD PTR [ebx+0x58]
10003b6c:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10003b72:	68 99 00 00 00       	push   0x99
10003b77:	6a 33                	push   0x33
10003b79:	68 cc 00 00 00       	push   0xcc
10003b7e:	8b 11                	mov    edx,DWORD PTR [ecx]
10003b80:	ff 52 24             	call   DWORD PTR [edx+0x24]
10003b83:	8b 45 f8             	mov    eax,DWORD PTR [ebp-0x8]
10003b86:	b9 c9 01 00 00       	mov    ecx,0x1c9
10003b8b:	99                   	cdq
10003b8c:	2b c2                	sub    eax,edx
10003b8e:	68 86 01 00 00       	push   0x186
10003b93:	d1 f8                	sar    eax,1
10003b95:	2b c8                	sub    ecx,eax
10003b97:	a1 b8 f5 00 10       	mov    eax,ds:0x1000f5b8
10003b9c:	8d 55 94             	lea    edx,[ebp-0x6c]
10003b9f:	51                   	push   ecx
10003ba0:	52                   	push   edx
10003ba1:	50                   	push   eax
10003ba2:	e8 59 0e 00 00       	call   0x10004a00
10003ba7:	83 c4 10             	add    esp,0x10
10003baa:	5f                   	pop    edi
10003bab:	5e                   	pop    esi
10003bac:	5b                   	pop    ebx
10003bad:	8b e5                	mov    esp,ebp
10003baf:	5d                   	pop    ebp
10003bb0:	c3                   	ret
10003bb1:	90                   	nop
10003bb2:	90                   	nop
10003bb3:	90                   	nop
10003bb4:	90                   	nop
10003bb5:	90                   	nop
10003bb6:	90                   	nop
10003bb7:	90                   	nop
10003bb8:	90                   	nop
10003bb9:	90                   	nop
10003bba:	90                   	nop
10003bbb:	90                   	nop
10003bbc:	90                   	nop
10003bbd:	90                   	nop
10003bbe:	90                   	nop
10003bbf:	90                   	nop
10003bc0:	55                   	push   ebp
10003bc1:	8b ec                	mov    ebp,esp
10003bc3:	83 ec 0c             	sub    esp,0xc
10003bc6:	8b 41 0c             	mov    eax,DWORD PTR [ecx+0xc]
10003bc9:	8b 15 cc f5 00 10    	mov    edx,DWORD PTR ds:0x1000f5cc
10003bcf:	56                   	push   esi
10003bd0:	8b 08                	mov    ecx,DWORD PTR [eax]
10003bd2:	8b 4c ca 08          	mov    ecx,DWORD PTR [edx+ecx*8+0x8]
10003bd6:	8d 55 fc             	lea    edx,[ebp-0x4]
10003bd9:	52                   	push   edx
10003bda:	6a 01                	push   0x1
10003bdc:	8b 01                	mov    eax,DWORD PTR [ecx]
10003bde:	ff 50 10             	call   DWORD PTR [eax+0x10]
10003be1:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10003be4:	8d 55 f4             	lea    edx,[ebp-0xc]
10003be7:	52                   	push   edx
10003be8:	8d 55 f8             	lea    edx,[ebp-0x8]
10003beb:	8b 01                	mov    eax,DWORD PTR [ecx]
10003bed:	52                   	push   edx
10003bee:	ff 50 50             	call   DWORD PTR [eax+0x50]
10003bf1:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10003bf7:	6a 00                	push   0x0
10003bf9:	6a 00                	push   0x0
10003bfb:	6a 00                	push   0x0
10003bfd:	8b 01                	mov    eax,DWORD PTR [ecx]
10003bff:	ff 50 1c             	call   DWORD PTR [eax+0x1c]
10003c02:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10003c08:	6a 4e                	push   0x4e
10003c0a:	68 f4 01 00 00       	push   0x1f4
10003c0f:	6a 17                	push   0x17
10003c11:	8b 11                	mov    edx,DWORD PTR [ecx]
10003c13:	68 ad 01 00 00       	push   0x1ad
10003c18:	ff 52 10             	call   DWORD PTR [edx+0x10]
10003c1b:	8b 45 f8             	mov    eax,DWORD PTR [ebp-0x8]
10003c1e:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10003c24:	99                   	cdq
10003c25:	8b 31                	mov    esi,DWORD PTR [ecx]
10003c27:	2b c2                	sub    eax,edx
10003c29:	d1 f8                	sar    eax,1
10003c2b:	ba c9 01 00 00       	mov    edx,0x1c9
10003c30:	6a 1b                	push   0x1b
10003c32:	2b d0                	sub    edx,eax
10003c34:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
10003c37:	52                   	push   edx
10003c38:	50                   	push   eax
10003c39:	ff 56 40             	call   DWORD PTR [esi+0x40]
10003c3c:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10003c3f:	8b 11                	mov    edx,DWORD PTR [ecx]
10003c41:	ff 52 04             	call   DWORD PTR [edx+0x4]
10003c44:	5e                   	pop    esi
10003c45:	8b e5                	mov    esp,ebp
10003c47:	5d                   	pop    ebp
10003c48:	c3                   	ret
10003c49:	90                   	nop
10003c4a:	90                   	nop
10003c4b:	90                   	nop
10003c4c:	90                   	nop
10003c4d:	90                   	nop
10003c4e:	90                   	nop
10003c4f:	90                   	nop
10003c50:	55                   	push   ebp
10003c51:	8b ec                	mov    ebp,esp
10003c53:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10003c56:	53                   	push   ebx
10003c57:	8b 5d 10             	mov    ebx,DWORD PTR [ebp+0x10]
10003c5a:	56                   	push   esi
10003c5b:	8b f1                	mov    esi,ecx
10003c5d:	57                   	push   edi
10003c5e:	8b 7d 14             	mov    edi,DWORD PTR [ebp+0x14]
10003c61:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
10003c64:	2b f9                	sub    edi,ecx
10003c66:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10003c6c:	2b d8                	sub    ebx,eax
10003c6e:	6a 01                	push   0x1
10003c70:	8b 01                	mov    eax,DWORD PTR [ecx]
10003c72:	8d 57 02             	lea    edx,[edi+0x2]
10003c75:	52                   	push   edx
10003c76:	8d 53 02             	lea    edx,[ebx+0x2]
10003c79:	52                   	push   edx
10003c7a:	ff 50 10             	call   DWORD PTR [eax+0x10]
10003c7d:	89 86 dc 01 00 00    	mov    DWORD PTR [esi+0x1dc],eax
10003c83:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
10003c89:	50                   	push   eax
10003c8a:	8b 11                	mov    edx,DWORD PTR [ecx]
10003c8c:	ff 52 18             	call   DWORD PTR [edx+0x18]
10003c8f:	8b 55 0c             	mov    edx,DWORD PTR [ebp+0xc]
10003c92:	8b 8e dc 01 00 00    	mov    ecx,DWORD PTR [esi+0x1dc]
10003c98:	6a 00                	push   0x0
10003c9a:	52                   	push   edx
10003c9b:	8b 55 08             	mov    edx,DWORD PTR [ebp+0x8]
10003c9e:	8b 01                	mov    eax,DWORD PTR [ecx]
10003ca0:	52                   	push   edx
10003ca1:	ff 50 08             	call   DWORD PTR [eax+0x8]
10003ca4:	8b 8e dc 01 00 00    	mov    ecx,DWORD PTR [esi+0x1dc]
10003caa:	81 c6 d8 01 00 00    	add    esi,0x1d8
10003cb0:	56                   	push   esi
10003cb1:	8b 01                	mov    eax,DWORD PTR [ecx]
10003cb3:	ff 50 44             	call   DWORD PTR [eax+0x44]
10003cb6:	8b 0e                	mov    ecx,DWORD PTR [esi]
10003cb8:	6a 63                	push   0x63
10003cba:	6a 63                	push   0x63
10003cbc:	6a 00                	push   0x0
10003cbe:	8b 11                	mov    edx,DWORD PTR [ecx]
10003cc0:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
10003cc3:	8b 0e                	mov    ecx,DWORD PTR [esi]
10003cc5:	57                   	push   edi
10003cc6:	53                   	push   ebx
10003cc7:	6a 01                	push   0x1
10003cc9:	8b 01                	mov    eax,DWORD PTR [ecx]
10003ccb:	6a 01                	push   0x1
10003ccd:	ff 50 0c             	call   DWORD PTR [eax+0xc]
10003cd0:	8b 0e                	mov    ecx,DWORD PTR [esi]
10003cd2:	8d 47 ff             	lea    eax,[edi-0x1]
10003cd5:	50                   	push   eax
10003cd6:	8d 43 ff             	lea    eax,[ebx-0x1]
10003cd9:	8b 11                	mov    edx,DWORD PTR [ecx]
10003cdb:	50                   	push   eax
10003cdc:	6a 02                	push   0x2
10003cde:	6a 02                	push   0x2
10003ce0:	ff 52 0c             	call   DWORD PTR [edx+0xc]
10003ce3:	8b 0e                	mov    ecx,DWORD PTR [esi]
10003ce5:	68 ff 00 00 00       	push   0xff
10003cea:	68 cc 00 00 00       	push   0xcc
10003cef:	68 99 00 00 00       	push   0x99
10003cf4:	8b 11                	mov    edx,DWORD PTR [ecx]
10003cf6:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
10003cf9:	8b 0e                	mov    ecx,DWORD PTR [esi]
10003cfb:	8d 53 01             	lea    edx,[ebx+0x1]
10003cfe:	8d 47 01             	lea    eax,[edi+0x1]
10003d01:	89 55 08             	mov    DWORD PTR [ebp+0x8],edx
10003d04:	8b 11                	mov    edx,DWORD PTR [ecx]
10003d06:	89 45 10             	mov    DWORD PTR [ebp+0x10],eax
10003d09:	50                   	push   eax
10003d0a:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10003d0d:	50                   	push   eax
10003d0e:	6a 00                	push   0x0
10003d10:	6a 00                	push   0x0
10003d12:	ff 52 0c             	call   DWORD PTR [edx+0xc]
10003d15:	8b 0e                	mov    ecx,DWORD PTR [esi]
10003d17:	8d 47 fe             	lea    eax,[edi-0x2]
10003d1a:	8d 53 fe             	lea    edx,[ebx-0x2]
10003d1d:	89 45 14             	mov    DWORD PTR [ebp+0x14],eax
10003d20:	89 55 0c             	mov    DWORD PTR [ebp+0xc],edx
10003d23:	8b 11                	mov    edx,DWORD PTR [ecx]
10003d25:	50                   	push   eax
10003d26:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10003d29:	50                   	push   eax
10003d2a:	6a 04                	push   0x4
10003d2c:	6a 04                	push   0x4
10003d2e:	ff 52 10             	call   DWORD PTR [edx+0x10]
10003d31:	8b 45 14             	mov    eax,DWORD PTR [ebp+0x14]
10003d34:	8b 0e                	mov    ecx,DWORD PTR [esi]
10003d36:	50                   	push   eax
10003d37:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10003d3a:	8b 11                	mov    edx,DWORD PTR [ecx]
10003d3c:	50                   	push   eax
10003d3d:	6a 03                	push   0x3
10003d3f:	6a 03                	push   0x3
10003d41:	ff 52 0c             	call   DWORD PTR [edx+0xc]
10003d44:	8b 0e                	mov    ecx,DWORD PTR [esi]
10003d46:	6a 00                	push   0x0
10003d48:	6a 00                	push   0x0
10003d4a:	6a 00                	push   0x0
10003d4c:	8b 11                	mov    edx,DWORD PTR [ecx]
10003d4e:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
10003d51:	8b 55 10             	mov    edx,DWORD PTR [ebp+0x10]
10003d54:	8b 0e                	mov    ecx,DWORD PTR [esi]
10003d56:	52                   	push   edx
10003d57:	8b 55 08             	mov    edx,DWORD PTR [ebp+0x8]
10003d5a:	8b 01                	mov    eax,DWORD PTR [ecx]
10003d5c:	52                   	push   edx
10003d5d:	6a 00                	push   0x0
10003d5f:	6a 00                	push   0x0
10003d61:	ff 50 0c             	call   DWORD PTR [eax+0xc]
10003d64:	8b 36                	mov    esi,DWORD PTR [esi]
10003d66:	83 c7 fd             	add    edi,0xfffffffd
10003d69:	83 c3 fd             	add    ebx,0xfffffffd
10003d6c:	57                   	push   edi
10003d6d:	8b 06                	mov    eax,DWORD PTR [esi]
10003d6f:	53                   	push   ebx
10003d70:	6a 04                	push   0x4
10003d72:	6a 04                	push   0x4
10003d74:	8b ce                	mov    ecx,esi
10003d76:	ff 50 0c             	call   DWORD PTR [eax+0xc]
10003d79:	5f                   	pop    edi
10003d7a:	5e                   	pop    esi
10003d7b:	5b                   	pop    ebx
10003d7c:	5d                   	pop    ebp
10003d7d:	c2 10 00             	ret    0x10
10003d80:	55                   	push   ebp
10003d81:	8b ec                	mov    ebp,esp
10003d83:	81 ec 00 04 00 00    	sub    esp,0x400
10003d89:	56                   	push   esi
10003d8a:	68 40 01 00 00       	push   0x140
10003d8f:	68 68 01 00 00       	push   0x168
10003d94:	68 a0 00 00 00       	push   0xa0
10003d99:	8b f1                	mov    esi,ecx
10003d9b:	68 9b 00 00 00       	push   0x9b
10003da0:	e8 ab fe ff ff       	call   0x10003c50
10003da5:	8b 86 d8 01 00 00    	mov    eax,DWORD PTR [esi+0x1d8]
10003dab:	6a 15                	push   0x15
10003dad:	6a 0b                	push   0xb
10003daf:	68 20 e7 00 10       	push   0x1000e720
10003db4:	50                   	push   eax
10003db5:	e8 46 0c 00 00       	call   0x10004a00
10003dba:	8b 8e d8 01 00 00    	mov    ecx,DWORD PTR [esi+0x1d8]
10003dc0:	6a 24                	push   0x24
10003dc2:	6a 0b                	push   0xb
10003dc4:	68 f0 e6 00 10       	push   0x1000e6f0
10003dc9:	51                   	push   ecx
10003dca:	e8 31 0c 00 00       	call   0x10004a00
10003dcf:	8b 96 d8 01 00 00    	mov    edx,DWORD PTR [esi+0x1d8]
10003dd5:	6a 33                	push   0x33
10003dd7:	6a 0b                	push   0xb
10003dd9:	68 c0 e6 00 10       	push   0x1000e6c0
10003dde:	52                   	push   edx
10003ddf:	e8 1c 0c 00 00       	call   0x10004a00
10003de4:	8b 86 a4 01 00 00    	mov    eax,DWORD PTR [esi+0x1a4]
10003dea:	8d 8d 00 fc ff ff    	lea    ecx,[ebp-0x400]
10003df0:	40                   	inc    eax
10003df1:	50                   	push   eax
10003df2:	68 94 e6 00 10       	push   0x1000e694
10003df7:	51                   	push   ecx
10003df8:	e8 b3 13 00 00       	call   0x100051b0
10003dfd:	8b 86 d8 01 00 00    	mov    eax,DWORD PTR [esi+0x1d8]
10003e03:	6a 51                	push   0x51
10003e05:	8d 95 00 fc ff ff    	lea    edx,[ebp-0x400]
10003e0b:	6a 0b                	push   0xb
10003e0d:	52                   	push   edx
10003e0e:	50                   	push   eax
10003e0f:	e8 ec 0b 00 00       	call   0x10004a00
10003e14:	8b 86 a4 01 00 00    	mov    eax,DWORD PTR [esi+0x1a4]
10003e1a:	83 c4 4c             	add    esp,0x4c
10003e1d:	85 c0                	test   eax,eax
10003e1f:	6a 60                	push   0x60
10003e21:	6a 0b                	push   0xb
10003e23:	7e 0e                	jle    0x10003e33
10003e25:	8b 8e d8 01 00 00    	mov    ecx,DWORD PTR [esi+0x1d8]
10003e2b:	68 84 e6 00 10       	push   0x1000e684
10003e30:	51                   	push   ecx
10003e31:	eb 0c                	jmp    0x10003e3f
10003e33:	8b 96 d8 01 00 00    	mov    edx,DWORD PTR [esi+0x1d8]
10003e39:	68 74 e6 00 10       	push   0x1000e674
10003e3e:	52                   	push   edx
10003e3f:	e8 bc 0b 00 00       	call   0x10004a00
10003e44:	8b 86 d8 01 00 00    	mov    eax,DWORD PTR [esi+0x1d8]
10003e4a:	83 c4 10             	add    esp,0x10
10003e4d:	c7 86 bc 01 00 00 02 	mov    DWORD PTR [esi+0x1bc],0x2
10003e54:	00 00 00 
10003e57:	6a 7e                	push   0x7e
10003e59:	6a 05                	push   0x5
10003e5b:	68 48 e6 00 10       	push   0x1000e648
10003e60:	50                   	push   eax
10003e61:	e8 9a 0b 00 00       	call   0x10004a00
10003e66:	83 c4 10             	add    esp,0x10
10003e69:	5e                   	pop    esi
10003e6a:	8b e5                	mov    esp,ebp
10003e6c:	5d                   	pop    ebp
10003e6d:	c3                   	ret
10003e6e:	90                   	nop
10003e6f:	90                   	nop
10003e70:	56                   	push   esi
10003e71:	68 22 01 00 00       	push   0x122
10003e76:	68 63 01 00 00       	push   0x163
10003e7b:	68 a0 00 00 00       	push   0xa0
10003e80:	8b f1                	mov    esi,ecx
10003e82:	68 9b 00 00 00       	push   0x9b
10003e87:	e8 c4 fd ff ff       	call   0x10003c50
10003e8c:	8b 86 d8 01 00 00    	mov    eax,DWORD PTR [esi+0x1d8]
10003e92:	6a 15                	push   0x15
10003e94:	6a 0b                	push   0xb
10003e96:	68 d8 e7 00 10       	push   0x1000e7d8
10003e9b:	50                   	push   eax
10003e9c:	e8 5f 0b 00 00       	call   0x10004a00
10003ea1:	8b 8e d8 01 00 00    	mov    ecx,DWORD PTR [esi+0x1d8]
10003ea7:	6a 24                	push   0x24
10003ea9:	6a 0b                	push   0xb
10003eab:	68 ac e7 00 10       	push   0x1000e7ac
10003eb0:	51                   	push   ecx
10003eb1:	e8 4a 0b 00 00       	call   0x10004a00
10003eb6:	8b 96 d8 01 00 00    	mov    edx,DWORD PTR [esi+0x1d8]
10003ebc:	6a 33                	push   0x33
10003ebe:	6a 0b                	push   0xb
10003ec0:	68 80 e7 00 10       	push   0x1000e780
10003ec5:	52                   	push   edx
10003ec6:	e8 35 0b 00 00       	call   0x10004a00
10003ecb:	8b 86 d8 01 00 00    	mov    eax,DWORD PTR [esi+0x1d8]
10003ed1:	6a 51                	push   0x51
10003ed3:	6a 0b                	push   0xb
10003ed5:	68 5c e7 00 10       	push   0x1000e75c
10003eda:	50                   	push   eax
10003edb:	e8 20 0b 00 00       	call   0x10004a00
10003ee0:	83 c4 40             	add    esp,0x40
10003ee3:	8b 8e dc 01 00 00    	mov    ecx,DWORD PTR [esi+0x1dc]
10003ee9:	c7 86 bc 01 00 00 01 	mov    DWORD PTR [esi+0x1bc],0x1
10003ef0:	00 00 00 
10003ef3:	68 50 3f 00 10       	push   0x10003f50
10003ef8:	56                   	push   esi
10003ef9:	6a 0c                	push   0xc
10003efb:	6a 00                	push   0x0
10003efd:	6a 6b                	push   0x6b
10003eff:	6a 1b                	push   0x1b
10003f01:	68 54 e7 00 10       	push   0x1000e754
10003f06:	51                   	push   ecx
10003f07:	8b 0d cc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5cc
10003f0d:	e8 ce de ff ff       	call   0x10001de0
10003f12:	8b 96 dc 01 00 00    	mov    edx,DWORD PTR [esi+0x1dc]
10003f18:	68 50 3f 00 10       	push   0x10003f50
10003f1d:	56                   	push   esi
10003f1e:	6a 0c                	push   0xc
10003f20:	6a 01                	push   0x1
10003f22:	6a 6b                	push   0x6b
10003f24:	6a 7f                	push   0x7f
10003f26:	89 86 e0 01 00 00    	mov    DWORD PTR [esi+0x1e0],eax
10003f2c:	8b 0d cc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5cc
10003f32:	68 4c e7 00 10       	push   0x1000e74c
10003f37:	52                   	push   edx
10003f38:	e8 a3 de ff ff       	call   0x10001de0
10003f3d:	89 86 e4 01 00 00    	mov    DWORD PTR [esi+0x1e4],eax
10003f43:	5e                   	pop    esi
10003f44:	c3                   	ret
10003f45:	90                   	nop
10003f46:	90                   	nop
10003f47:	90                   	nop
10003f48:	90                   	nop
10003f49:	90                   	nop
10003f4a:	90                   	nop
10003f4b:	90                   	nop
10003f4c:	90                   	nop
10003f4d:	90                   	nop
10003f4e:	90                   	nop
10003f4f:	90                   	nop
10003f50:	55                   	push   ebp
10003f51:	8b ec                	mov    ebp,esp
10003f53:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10003f56:	50                   	push   eax
10003f57:	8b 08                	mov    ecx,DWORD PTR [eax]
10003f59:	e8 02 00 00 00       	call   0x10003f60
10003f5e:	5d                   	pop    ebp
10003f5f:	c3                   	ret
10003f60:	55                   	push   ebp
10003f61:	8b ec                	mov    ebp,esp
10003f63:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10003f69:	6a ff                	push   0xffffffff
10003f6b:	68 b6 c6 00 10       	push   0x1000c6b6
10003f70:	50                   	push   eax
10003f71:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10003f74:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10003f7b:	56                   	push   esi
10003f7c:	8b f1                	mov    esi,ecx
10003f7e:	8b 48 04             	mov    ecx,DWORD PTR [eax+0x4]
10003f81:	85 c9                	test   ecx,ecx
10003f83:	75 2a                	jne    0x10003faf
10003f85:	68 e8 01 00 00       	push   0x1e8
10003f8a:	e8 13 12 00 00       	call   0x100051a2
10003f8f:	83 c4 04             	add    esp,0x4
10003f92:	89 45 08             	mov    DWORD PTR [ebp+0x8],eax
10003f95:	85 c0                	test   eax,eax
10003f97:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [ebp-0x4],0x0
10003f9e:	74 34                	je     0x10003fd4
10003fa0:	8b 4e 04             	mov    ecx,DWORD PTR [esi+0x4]
10003fa3:	6a 00                	push   0x0
10003fa5:	51                   	push   ecx
10003fa6:	8b c8                	mov    ecx,eax
10003fa8:	e8 d3 ea ff ff       	call   0x10002a80
10003fad:	eb 27                	jmp    0x10003fd6
10003faf:	6a 20                	push   0x20
10003fb1:	e8 ec 11 00 00       	call   0x100051a2
10003fb6:	83 c4 04             	add    esp,0x4
10003fb9:	89 45 08             	mov    DWORD PTR [ebp+0x8],eax
10003fbc:	85 c0                	test   eax,eax
10003fbe:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [ebp-0x4],0x1
10003fc5:	74 0d                	je     0x10003fd4
10003fc7:	8b 56 04             	mov    edx,DWORD PTR [esi+0x4]
10003fca:	8b c8                	mov    ecx,eax
10003fcc:	52                   	push   edx
10003fcd:	e8 ce 01 00 00       	call   0x100041a0
10003fd2:	eb 02                	jmp    0x10003fd6
10003fd4:	33 c0                	xor    eax,eax
10003fd6:	8b 4e 04             	mov    ecx,DWORD PTR [esi+0x4]
10003fd9:	50                   	push   eax
10003fda:	56                   	push   esi
10003fdb:	c7 45 fc ff ff ff ff 	mov    DWORD PTR [ebp-0x4],0xffffffff
10003fe2:	e8 c9 dd ff ff       	call   0x10001db0
10003fe7:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
10003fea:	33 c0                	xor    eax,eax
10003fec:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
10003ff3:	5e                   	pop    esi
10003ff4:	8b e5                	mov    esp,ebp
10003ff6:	5d                   	pop    ebp
10003ff7:	c2 04 00             	ret    0x4
10003ffa:	90                   	nop
10003ffb:	90                   	nop
10003ffc:	90                   	nop
10003ffd:	90                   	nop
10003ffe:	90                   	nop
10003fff:	90                   	nop
10004000:	55                   	push   ebp
10004001:	8b ec                	mov    ebp,esp
10004003:	6a ff                	push   0xffffffff
10004005:	68 cb c6 00 10       	push   0x1000c6cb
1000400a:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10004010:	50                   	push   eax
10004011:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10004018:	51                   	push   ecx
10004019:	56                   	push   esi
1000401a:	8b f1                	mov    esi,ecx
1000401c:	57                   	push   edi
1000401d:	33 ff                	xor    edi,edi
1000401f:	8b 8e d8 01 00 00    	mov    ecx,DWORD PTR [esi+0x1d8]
10004025:	3b cf                	cmp    ecx,edi
10004027:	74 0b                	je     0x10004034
10004029:	8b 01                	mov    eax,DWORD PTR [ecx]
1000402b:	ff 50 04             	call   DWORD PTR [eax+0x4]
1000402e:	89 be d8 01 00 00    	mov    DWORD PTR [esi+0x1d8],edi
10004034:	8b 86 dc 01 00 00    	mov    eax,DWORD PTR [esi+0x1dc]
1000403a:	3b c7                	cmp    eax,edi
1000403c:	74 1d                	je     0x1000405b
1000403e:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
10004044:	50                   	push   eax
10004045:	8b 11                	mov    edx,DWORD PTR [ecx]
10004047:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
1000404a:	8b 8e dc 01 00 00    	mov    ecx,DWORD PTR [esi+0x1dc]
10004050:	8b 01                	mov    eax,DWORD PTR [ecx]
10004052:	ff 50 04             	call   DWORD PTR [eax+0x4]
10004055:	89 be dc 01 00 00    	mov    DWORD PTR [esi+0x1dc],edi
1000405b:	8b 86 a0 01 00 00    	mov    eax,DWORD PTR [esi+0x1a0]
10004061:	53                   	push   ebx
10004062:	3b c7                	cmp    eax,edi
10004064:	89 7d f0             	mov    DWORD PTR [ebp-0x10],edi
10004067:	7e 2f                	jle    0x10004098
10004069:	8d 5e 10             	lea    ebx,[esi+0x10]
1000406c:	8b 3b                	mov    edi,DWORD PTR [ebx]
1000406e:	85 ff                	test   edi,edi
10004070:	74 10                	je     0x10004082
10004072:	8b cf                	mov    ecx,edi
10004074:	e8 c7 d2 ff ff       	call   0x10001340
10004079:	57                   	push   edi
1000407a:	e8 18 11 00 00       	call   0x10005197
1000407f:	83 c4 04             	add    esp,0x4
10004082:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
10004085:	8b 8e a0 01 00 00    	mov    ecx,DWORD PTR [esi+0x1a0]
1000408b:	40                   	inc    eax
1000408c:	83 c3 04             	add    ebx,0x4
1000408f:	3b c1                	cmp    eax,ecx
10004091:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax
10004094:	7c d6                	jl     0x1000406c
10004096:	33 ff                	xor    edi,edi
10004098:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
1000409b:	e8 90 df ff ff       	call   0x10002030
100040a0:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
100040a3:	c6 86 ac 01 00 00 00 	mov    BYTE PTR [esi+0x1ac],0x0
100040aa:	c6 86 ad 01 00 00 00 	mov    BYTE PTR [esi+0x1ad],0x0
100040b1:	c6 86 ae 01 00 00 00 	mov    BYTE PTR [esi+0x1ae],0x0
100040b8:	89 be a0 01 00 00    	mov    DWORD PTR [esi+0x1a0],edi
100040be:	8b 39                	mov    edi,DWORD PTR [ecx]
100040c0:	8d 4c 3f 04          	lea    ecx,[edi+edi*1+0x4]
100040c4:	85 c9                	test   ecx,ecx
100040c6:	7e 7d                	jle    0x10004145
100040c8:	83 cb ff             	or     ebx,0xffffffff
100040cb:	b8 56 55 55 55       	mov    eax,0x55555556
100040d0:	f7 e9                	imul   ecx
100040d2:	8b c2                	mov    eax,edx
100040d4:	c1 e8 1f             	shr    eax,0x1f
100040d7:	03 d0                	add    edx,eax
100040d9:	8b 86 a0 01 00 00    	mov    eax,DWORD PTR [esi+0x1a0]
100040df:	3b c2                	cmp    eax,edx
100040e1:	7c 14                	jl     0x100040f7
100040e3:	8b 0d b4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b4
100040e9:	8b 11                	mov    edx,DWORD PTR [ecx]
100040eb:	ff 52 08             	call   DWORD PTR [edx+0x8]
100040ee:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
100040f1:	33 d2                	xor    edx,edx
100040f3:	f7 31                	div    DWORD PTR [ecx]
100040f5:	8b fa                	mov    edi,edx
100040f7:	6a 38                	push   0x38
100040f9:	47                   	inc    edi
100040fa:	e8 a3 10 00 00       	call   0x100051a2
100040ff:	83 c4 04             	add    esp,0x4
10004102:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax
10004105:	85 c0                	test   eax,eax
10004107:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [ebp-0x4],0x0
1000410e:	74 0a                	je     0x1000411a
10004110:	57                   	push   edi
10004111:	8b c8                	mov    ecx,eax
10004113:	e8 88 d0 ff ff       	call   0x100011a0
10004118:	eb 02                	jmp    0x1000411c
1000411a:	33 c0                	xor    eax,eax
1000411c:	8b 96 a0 01 00 00    	mov    edx,DWORD PTR [esi+0x1a0]
10004122:	89 5d fc             	mov    DWORD PTR [ebp-0x4],ebx
10004125:	89 44 96 10          	mov    DWORD PTR [esi+edx*4+0x10],eax
10004129:	8b be a0 01 00 00    	mov    edi,DWORD PTR [esi+0x1a0]
1000412f:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
10004132:	47                   	inc    edi
10004133:	89 be a0 01 00 00    	mov    DWORD PTR [esi+0x1a0],edi
10004139:	8b c7                	mov    eax,edi
1000413b:	8b 39                	mov    edi,DWORD PTR [ecx]
1000413d:	8d 4c 3f 04          	lea    ecx,[edi+edi*1+0x4]
10004141:	3b c1                	cmp    eax,ecx
10004143:	7c 86                	jl     0x100040cb
10004145:	a0 ec f5 00 10       	mov    al,ds:0x1000f5ec
1000414a:	5b                   	pop    ebx
1000414b:	84 c0                	test   al,al
1000414d:	74 23                	je     0x10004172
1000414f:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
10004155:	a1 e8 f5 00 10       	mov    eax,ds:0x1000f5e8
1000415a:	50                   	push   eax
1000415b:	8b 11                	mov    edx,DWORD PTR [ecx]
1000415d:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
10004160:	8b 0d e8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5e8
10004166:	8b 11                	mov    edx,DWORD PTR [ecx]
10004168:	ff 52 04             	call   DWORD PTR [edx+0x4]
1000416b:	c6 05 ec f5 00 10 00 	mov    BYTE PTR ds:0x1000f5ec,0x0
10004172:	8b ce                	mov    ecx,esi
10004174:	e8 e7 f8 ff ff       	call   0x10003a60
10004179:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
1000417c:	c7 86 bc 01 00 00 00 	mov    DWORD PTR [esi+0x1bc],0x0
10004183:	00 00 00 
10004186:	5f                   	pop    edi
10004187:	33 c0                	xor    eax,eax
10004189:	5e                   	pop    esi
1000418a:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
10004191:	8b e5                	mov    esp,ebp
10004193:	5d                   	pop    ebp
10004194:	c2 04 00             	ret    0x4
10004197:	90                   	nop
10004198:	90                   	nop
10004199:	90                   	nop
1000419a:	90                   	nop
1000419b:	90                   	nop
1000419c:	90                   	nop
1000419d:	90                   	nop
1000419e:	90                   	nop
1000419f:	90                   	nop
100041a0:	55                   	push   ebp
100041a1:	8b ec                	mov    ebp,esp
100041a3:	6a ff                	push   0xffffffff
100041a5:	68 e8 c6 00 10       	push   0x1000c6e8
100041aa:	64 a1 00 00 00 00    	mov    eax,fs:0x0
100041b0:	50                   	push   eax
100041b1:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
100041b8:	51                   	push   ecx
100041b9:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100041bc:	53                   	push   ebx
100041bd:	56                   	push   esi
100041be:	8b f1                	mov    esi,ecx
100041c0:	50                   	push   eax
100041c1:	89 75 f0             	mov    DWORD PTR [ebp-0x10],esi
100041c4:	e8 97 e4 ff ff       	call   0x10002660
100041c9:	c7 06 5c d1 00 10    	mov    DWORD PTR [esi],0x1000d15c
100041cf:	8b 0d cc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5cc
100041d5:	33 db                	xor    ebx,ebx
100041d7:	8b 89 c8 00 00 00    	mov    ecx,DWORD PTR [ecx+0xc8]
100041dd:	53                   	push   ebx
100041de:	89 5d fc             	mov    DWORD PTR [ebp-0x4],ebx
100041e1:	8b 11                	mov    edx,DWORD PTR [ecx]
100041e3:	ff 52 08             	call   DWORD PTR [edx+0x8]
100041e6:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
100041ec:	88 1d 05 f6 00 10    	mov    BYTE PTR ds:0x1000f605,bl
100041f2:	88 1d 04 f6 00 10    	mov    BYTE PTR ds:0x1000f604,bl
100041f8:	c7 05 08 f6 00 10 01 	mov    DWORD PTR ds:0x1000f608,0x1
100041ff:	00 00 00 
10004202:	8b 01                	mov    eax,DWORD PTR [ecx]
10004204:	68 cc 00 00 00       	push   0xcc
10004209:	68 99 00 00 00       	push   0x99
1000420e:	68 99 00 00 00       	push   0x99
10004213:	ff 50 34             	call   DWORD PTR [eax+0x34]
10004216:	a1 cc f5 00 10       	mov    eax,ds:0x1000f5cc
1000421b:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
10004221:	8b 80 b0 00 00 00    	mov    eax,DWORD PTR [eax+0xb0]
10004227:	8b 11                	mov    edx,DWORD PTR [ecx]
10004229:	50                   	push   eax
1000422a:	ff 52 18             	call   DWORD PTR [edx+0x18]
1000422d:	8b 0d cc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5cc
10004233:	53                   	push   ebx
10004234:	68 4a 01 00 00       	push   0x14a
10004239:	53                   	push   ebx
1000423a:	8b 89 b0 00 00 00    	mov    ecx,DWORD PTR [ecx+0xb0]
10004240:	8b 11                	mov    edx,DWORD PTR [ecx]
10004242:	ff 52 08             	call   DWORD PTR [edx+0x8]
10004245:	a1 cc f5 00 10       	mov    eax,ds:0x1000f5cc
1000424a:	8b 88 b0 00 00 00    	mov    ecx,DWORD PTR [eax+0xb0]
10004250:	8b 11                	mov    edx,DWORD PTR [ecx]
10004252:	ff 52 2c             	call   DWORD PTR [edx+0x2c]
10004255:	8b 56 04             	mov    edx,DWORD PTR [esi+0x4]
10004258:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
1000425e:	53                   	push   ebx
1000425f:	53                   	push   ebx
10004260:	8b 92 bc 00 00 00    	mov    edx,DWORD PTR [edx+0xbc]
10004266:	8b 01                	mov    eax,DWORD PTR [ecx]
10004268:	52                   	push   edx
10004269:	ff 50 40             	call   DWORD PTR [eax+0x40]
1000426c:	a1 bc f5 00 10       	mov    eax,ds:0x1000f5bc
10004271:	8b 4e 04             	mov    ecx,DWORD PTR [esi+0x4]
10004274:	68 90 49 00 10       	push   0x10004990
10004279:	56                   	push   esi
1000427a:	6a 18                	push   0x18
1000427c:	6a ff                	push   0xffffffff
1000427e:	68 be 00 00 00       	push   0xbe
10004283:	68 fa 00 00 00       	push   0xfa
10004288:	68 30 e8 00 10       	push   0x1000e830
1000428d:	50                   	push   eax
1000428e:	e8 4d db ff ff       	call   0x10001de0
10004293:	89 46 0c             	mov    DWORD PTR [esi+0xc],eax
10004296:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
1000429c:	68 bb 00 00 00       	push   0xbb
100042a1:	6a 32                	push   0x32
100042a3:	68 08 e8 00 10       	push   0x1000e808
100042a8:	51                   	push   ecx
100042a9:	e8 52 07 00 00       	call   0x10004a00
100042ae:	83 c4 10             	add    esp,0x10
100042b1:	89 5e 14             	mov    DWORD PTR [esi+0x14],ebx
100042b4:	89 5e 18             	mov    DWORD PTR [esi+0x18],ebx
100042b7:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
100042bd:	a1 c8 f5 00 10       	mov    eax,ds:0x1000f5c8
100042c2:	68 a0 49 00 10       	push   0x100049a0
100042c7:	8b 11                	mov    edx,DWORD PTR [ecx]
100042c9:	56                   	push   esi
100042ca:	6a 0b                	push   0xb
100042cc:	50                   	push   eax
100042cd:	ff 52 44             	call   DWORD PTR [edx+0x44]
100042d0:	89 46 10             	mov    DWORD PTR [esi+0x10],eax
100042d3:	8b ce                	mov    ecx,esi
100042d5:	e8 66 03 00 00       	call   0x10004640
100042da:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
100042e0:	68 b0 49 00 10       	push   0x100049b0
100042e5:	6a 64                	push   0x64
100042e7:	56                   	push   esi
100042e8:	8b 11                	mov    edx,DWORD PTR [ecx]
100042ea:	ff 52 34             	call   DWORD PTR [edx+0x34]
100042ed:	89 46 1c             	mov    DWORD PTR [esi+0x1c],eax
100042f0:	a1 b4 f5 00 10       	mov    eax,ds:0x1000f5b4
100042f5:	53                   	push   ebx
100042f6:	8b 48 14             	mov    ecx,DWORD PTR [eax+0x14]
100042f9:	8b 11                	mov    edx,DWORD PTR [ecx]
100042fb:	ff 52 0c             	call   DWORD PTR [edx+0xc]
100042fe:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
10004301:	8b c6                	mov    eax,esi
10004303:	5e                   	pop    esi
10004304:	5b                   	pop    ebx
10004305:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
1000430c:	8b e5                	mov    esp,ebp
1000430e:	5d                   	pop    ebp
1000430f:	c2 04 00             	ret    0x4
10004312:	90                   	nop
10004313:	90                   	nop
10004314:	90                   	nop
10004315:	90                   	nop
10004316:	90                   	nop
10004317:	90                   	nop
10004318:	90                   	nop
10004319:	90                   	nop
1000431a:	90                   	nop
1000431b:	90                   	nop
1000431c:	90                   	nop
1000431d:	90                   	nop
1000431e:	90                   	nop
1000431f:	90                   	nop
10004320:	55                   	push   ebp
10004321:	8b ec                	mov    ebp,esp
10004323:	56                   	push   esi
10004324:	8b f1                	mov    esi,ecx
10004326:	e8 25 00 00 00       	call   0x10004350
1000432b:	f6 45 08 01          	test   BYTE PTR [ebp+0x8],0x1
1000432f:	74 09                	je     0x1000433a
10004331:	56                   	push   esi
10004332:	e8 60 0e 00 00       	call   0x10005197
10004337:	83 c4 04             	add    esp,0x4
1000433a:	8b c6                	mov    eax,esi
1000433c:	5e                   	pop    esi
1000433d:	5d                   	pop    ebp
1000433e:	c2 04 00             	ret    0x4
10004341:	90                   	nop
10004342:	90                   	nop
10004343:	90                   	nop
10004344:	90                   	nop
10004345:	90                   	nop
10004346:	90                   	nop
10004347:	90                   	nop
10004348:	90                   	nop
10004349:	90                   	nop
1000434a:	90                   	nop
1000434b:	90                   	nop
1000434c:	90                   	nop
1000434d:	90                   	nop
1000434e:	90                   	nop
1000434f:	90                   	nop
10004350:	55                   	push   ebp
10004351:	8b ec                	mov    ebp,esp
10004353:	6a ff                	push   0xffffffff
10004355:	68 08 c7 00 10       	push   0x1000c708
1000435a:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10004360:	50                   	push   eax
10004361:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10004368:	51                   	push   ecx
10004369:	56                   	push   esi
1000436a:	8b f1                	mov    esi,ecx
1000436c:	89 75 f0             	mov    DWORD PTR [ebp-0x10],esi
1000436f:	c7 06 5c d1 00 10    	mov    DWORD PTR [esi],0x1000d15c
10004375:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
1000437b:	8b 56 0c             	mov    edx,DWORD PTR [esi+0xc]
1000437e:	52                   	push   edx
1000437f:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [ebp-0x4],0x0
10004386:	8b 01                	mov    eax,DWORD PTR [ecx]
10004388:	ff 50 1c             	call   DWORD PTR [eax+0x1c]
1000438b:	8b 4e 0c             	mov    ecx,DWORD PTR [esi+0xc]
1000438e:	8b 01                	mov    eax,DWORD PTR [ecx]
10004390:	ff 50 04             	call   DWORD PTR [eax+0x4]
10004393:	8b 4e 10             	mov    ecx,DWORD PTR [esi+0x10]
10004396:	8b 11                	mov    edx,DWORD PTR [ecx]
10004398:	ff 52 04             	call   DWORD PTR [edx+0x4]
1000439b:	8b 4e 1c             	mov    ecx,DWORD PTR [esi+0x1c]
1000439e:	8b 01                	mov    eax,DWORD PTR [ecx]
100043a0:	ff 50 04             	call   DWORD PTR [eax+0x4]
100043a3:	a1 cc f5 00 10       	mov    eax,ds:0x1000f5cc
100043a8:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
100043ae:	8b 80 b0 00 00 00    	mov    eax,DWORD PTR [eax+0xb0]
100043b4:	8b 11                	mov    edx,DWORD PTR [ecx]
100043b6:	50                   	push   eax
100043b7:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
100043ba:	8b 0d cc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5cc
100043c0:	8b 89 b0 00 00 00    	mov    ecx,DWORD PTR [ecx+0xb0]
100043c6:	8b 11                	mov    edx,DWORD PTR [ecx]
100043c8:	ff 52 34             	call   DWORD PTR [edx+0x34]
100043cb:	8b ce                	mov    ecx,esi
100043cd:	c7 45 fc ff ff ff ff 	mov    DWORD PTR [ebp-0x4],0xffffffff
100043d4:	e8 d7 e2 ff ff       	call   0x100026b0
100043d9:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
100043dc:	5e                   	pop    esi
100043dd:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
100043e4:	8b e5                	mov    esp,ebp
100043e6:	5d                   	pop    ebp
100043e7:	c3                   	ret
100043e8:	90                   	nop
100043e9:	90                   	nop
100043ea:	90                   	nop
100043eb:	90                   	nop
100043ec:	90                   	nop
100043ed:	90                   	nop
100043ee:	90                   	nop
100043ef:	90                   	nop
100043f0:	55                   	push   ebp
100043f1:	8b ec                	mov    ebp,esp
100043f3:	6a ff                	push   0xffffffff
100043f5:	68 2b c7 00 10       	push   0x1000c72b
100043fa:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10004400:	50                   	push   eax
10004401:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10004408:	83 ec 1c             	sub    esp,0x1c
1000440b:	a1 4c e8 00 10       	mov    eax,ds:0x1000e84c
10004410:	8b 15 44 e8 00 10    	mov    edx,DWORD PTR ds:0x1000e844
10004416:	53                   	push   ebx
10004417:	56                   	push   esi
10004418:	8b f1                	mov    esi,ecx
1000441a:	89 45 ec             	mov    DWORD PTR [ebp-0x14],eax
1000441d:	a1 48 e8 00 10       	mov    eax,ds:0x1000e848
10004422:	8b 0d 50 e8 00 10    	mov    ecx,DWORD PTR ds:0x1000e850
10004428:	89 55 e4             	mov    DWORD PTR [ebp-0x1c],edx
1000442b:	8b 15 3c e8 00 10    	mov    edx,DWORD PTR ds:0x1000e83c
10004431:	89 45 e8             	mov    DWORD PTR [ebp-0x18],eax
10004434:	66 a1 40 e8 00 10    	mov    ax,ds:0x1000e840
1000443a:	89 55 dc             	mov    DWORD PTR [ebp-0x24],edx
1000443d:	8b 56 04             	mov    edx,DWORD PTR [esi+0x4]
10004440:	89 4d f0             	mov    DWORD PTR [ebp-0x10],ecx
10004443:	8b 0d 38 e8 00 10    	mov    ecx,DWORD PTR ds:0x1000e838
10004449:	66 89 45 e0          	mov    WORD PTR [ebp-0x20],ax
1000444d:	8a 82 b4 00 00 00    	mov    al,BYTE PTR [edx+0xb4]
10004453:	89 4d d8             	mov    DWORD PTR [ebp-0x28],ecx
10004456:	8a 0d 42 e8 00 10    	mov    cl,BYTE PTR ds:0x1000e842
1000445c:	33 db                	xor    ebx,ebx
1000445e:	88 4d e2             	mov    BYTE PTR [ebp-0x1e],cl
10004461:	3a c3                	cmp    al,bl
10004463:	0f 85 aa 00 00 00    	jne    0x10004513
10004469:	8b 46 14             	mov    eax,DWORD PTR [esi+0x14]
1000446c:	8b 55 08             	mov    edx,DWORD PTR [ebp+0x8]
1000446f:	57                   	push   edi
10004470:	0f be 7c 05 ec       	movsx  edi,BYTE PTR [ebp+eax*1-0x14]
10004475:	8b 4a 08             	mov    ecx,DWORD PTR [edx+0x8]
10004478:	3b cf                	cmp    ecx,edi
1000447a:	74 0e                	je     0x1000448a
1000447c:	0f be 7c 05 e4       	movsx  edi,BYTE PTR [ebp+eax*1-0x1c]
10004481:	3b cf                	cmp    ecx,edi
10004483:	74 05                	je     0x1000448a
10004485:	89 5e 14             	mov    DWORD PTR [esi+0x14],ebx
10004488:	eb 04                	jmp    0x1000448e
1000448a:	40                   	inc    eax
1000448b:	89 46 14             	mov    DWORD PTR [esi+0x14],eax
1000448e:	8b 46 18             	mov    eax,DWORD PTR [esi+0x18]
10004491:	8b 7a 08             	mov    edi,DWORD PTR [edx+0x8]
10004494:	0f be 4c 05 d8       	movsx  ecx,BYTE PTR [ebp+eax*1-0x28]
10004499:	3b f9                	cmp    edi,ecx
1000449b:	75 06                	jne    0x100044a3
1000449d:	40                   	inc    eax
1000449e:	89 46 18             	mov    DWORD PTR [esi+0x18],eax
100044a1:	eb 03                	jmp    0x100044a6
100044a3:	89 5e 18             	mov    DWORD PTR [esi+0x18],ebx
100044a6:	8d 7d d8             	lea    edi,[ebp-0x28]
100044a9:	83 c9 ff             	or     ecx,0xffffffff
100044ac:	33 c0                	xor    eax,eax
100044ae:	f2 ae                	repnz scas al,BYTE PTR es:[edi]
100044b0:	8b 46 18             	mov    eax,DWORD PTR [esi+0x18]
100044b3:	f7 d1                	not    ecx
100044b5:	49                   	dec    ecx
100044b6:	3b c1                	cmp    eax,ecx
100044b8:	75 0a                	jne    0x100044c4
100044ba:	c6 05 04 f6 00 10 01 	mov    BYTE PTR ds:0x1000f604,0x1
100044c1:	89 5e 18             	mov    DWORD PTR [esi+0x18],ebx
100044c4:	8d 7d ec             	lea    edi,[ebp-0x14]
100044c7:	83 c9 ff             	or     ecx,0xffffffff
100044ca:	33 c0                	xor    eax,eax
100044cc:	f2 ae                	repnz scas al,BYTE PTR es:[edi]
100044ce:	8b 46 14             	mov    eax,DWORD PTR [esi+0x14]
100044d1:	5f                   	pop    edi
100044d2:	f7 d1                	not    ecx
100044d4:	49                   	dec    ecx
100044d5:	3b c1                	cmp    eax,ecx
100044d7:	75 3a                	jne    0x10004513
100044d9:	68 a4 01 00 00       	push   0x1a4
100044de:	e8 bf 0c 00 00       	call   0x100051a2
100044e3:	83 c4 04             	add    esp,0x4
100044e6:	89 45 08             	mov    DWORD PTR [ebp+0x8],eax
100044e9:	3b c3                	cmp    eax,ebx
100044eb:	89 5d fc             	mov    DWORD PTR [ebp-0x4],ebx
100044ee:	74 0d                	je     0x100044fd
100044f0:	8b 56 04             	mov    edx,DWORD PTR [esi+0x4]
100044f3:	8b c8                	mov    ecx,eax
100044f5:	52                   	push   edx
100044f6:	e8 c5 e1 ff ff       	call   0x100026c0
100044fb:	eb 02                	jmp    0x100044ff
100044fd:	33 c0                	xor    eax,eax
100044ff:	8b 4e 04             	mov    ecx,DWORD PTR [esi+0x4]
10004502:	50                   	push   eax
10004503:	56                   	push   esi
10004504:	c7 45 fc ff ff ff ff 	mov    DWORD PTR [ebp-0x4],0xffffffff
1000450b:	e8 a0 d8 ff ff       	call   0x10001db0
10004510:	89 5e 14             	mov    DWORD PTR [esi+0x14],ebx
10004513:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
10004516:	5e                   	pop    esi
10004517:	33 c0                	xor    eax,eax
10004519:	5b                   	pop    ebx
1000451a:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
10004521:	8b e5                	mov    esp,ebp
10004523:	5d                   	pop    ebp
10004524:	c2 04 00             	ret    0x4
10004527:	90                   	nop
10004528:	90                   	nop
10004529:	90                   	nop
1000452a:	90                   	nop
1000452b:	90                   	nop
1000452c:	90                   	nop
1000452d:	90                   	nop
1000452e:	90                   	nop
1000452f:	90                   	nop
10004530:	56                   	push   esi
10004531:	8b f1                	mov    esi,ecx
10004533:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
10004539:	8b 56 04             	mov    edx,DWORD PTR [esi+0x4]
1000453c:	8b 01                	mov    eax,DWORD PTR [ecx]
1000453e:	8b 92 ac 00 00 00    	mov    edx,DWORD PTR [edx+0xac]
10004544:	52                   	push   edx
10004545:	ff 50 18             	call   DWORD PTR [eax+0x18]
10004548:	8b 46 04             	mov    eax,DWORD PTR [esi+0x4]
1000454b:	6a 00                	push   0x0
1000454d:	6a 00                	push   0x0
1000454f:	6a 00                	push   0x0
10004551:	c6 80 b4 00 00 00 01 	mov    BYTE PTR [eax+0xb4],0x1
10004558:	8b 4e 04             	mov    ecx,DWORD PTR [esi+0x4]
1000455b:	8b 89 ac 00 00 00    	mov    ecx,DWORD PTR [ecx+0xac]
10004561:	8b 11                	mov    edx,DWORD PTR [ecx]
10004563:	ff 52 08             	call   DWORD PTR [edx+0x8]
10004566:	8b 46 04             	mov    eax,DWORD PTR [esi+0x4]
10004569:	8b 88 ac 00 00 00    	mov    ecx,DWORD PTR [eax+0xac]
1000456f:	8b 11                	mov    edx,DWORD PTR [ecx]
10004571:	ff 52 2c             	call   DWORD PTR [edx+0x2c]
10004574:	a1 cc f5 00 10       	mov    eax,ds:0x1000f5cc
10004579:	6a 00                	push   0x0
1000457b:	8b 88 d4 00 00 00    	mov    ecx,DWORD PTR [eax+0xd4]
10004581:	8b 11                	mov    edx,DWORD PTR [ecx]
10004583:	ff 52 08             	call   DWORD PTR [edx+0x8]
10004586:	8b 4e 1c             	mov    ecx,DWORD PTR [esi+0x1c]
10004589:	8b 01                	mov    eax,DWORD PTR [ecx]
1000458b:	ff 50 08             	call   DWORD PTR [eax+0x8]
1000458e:	33 c0                	xor    eax,eax
10004590:	5e                   	pop    esi
10004591:	c2 04 00             	ret    0x4
10004594:	90                   	nop
10004595:	90                   	nop
10004596:	90                   	nop
10004597:	90                   	nop
10004598:	90                   	nop
10004599:	90                   	nop
1000459a:	90                   	nop
1000459b:	90                   	nop
1000459c:	90                   	nop
1000459d:	90                   	nop
1000459e:	90                   	nop
1000459f:	90                   	nop
100045a0:	55                   	push   ebp
100045a1:	8b ec                	mov    ebp,esp
100045a3:	64 a1 00 00 00 00    	mov    eax,fs:0x0
100045a9:	6a ff                	push   0xffffffff
100045ab:	68 4b c7 00 10       	push   0x1000c74b
100045b0:	50                   	push   eax
100045b1:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100045b4:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
100045bb:	56                   	push   esi
100045bc:	8b f1                	mov    esi,ecx
100045be:	81 78 08 b8 0b 00 00 	cmp    DWORD PTR [eax+0x8],0xbb8
100045c5:	76 5c                	jbe    0x10004623
100045c7:	8b 46 04             	mov    eax,DWORD PTR [esi+0x4]
100045ca:	8b 0d bc f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5bc
100045d0:	8b 80 ac 00 00 00    	mov    eax,DWORD PTR [eax+0xac]
100045d6:	8b 11                	mov    edx,DWORD PTR [ecx]
100045d8:	50                   	push   eax
100045d9:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
100045dc:	8b 4e 04             	mov    ecx,DWORD PTR [esi+0x4]
100045df:	68 e8 01 00 00       	push   0x1e8
100045e4:	c6 81 b4 00 00 00 00 	mov    BYTE PTR [ecx+0xb4],0x0
100045eb:	e8 b2 0b 00 00       	call   0x100051a2
100045f0:	83 c4 04             	add    esp,0x4
100045f3:	89 45 08             	mov    DWORD PTR [ebp+0x8],eax
100045f6:	85 c0                	test   eax,eax
100045f8:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [ebp-0x4],0x0
100045ff:	74 0f                	je     0x10004610
10004601:	8b 56 04             	mov    edx,DWORD PTR [esi+0x4]
10004604:	6a 01                	push   0x1
10004606:	52                   	push   edx
10004607:	8b c8                	mov    ecx,eax
10004609:	e8 72 e4 ff ff       	call   0x10002a80
1000460e:	eb 02                	jmp    0x10004612
10004610:	33 c0                	xor    eax,eax
10004612:	8b 4e 04             	mov    ecx,DWORD PTR [esi+0x4]
10004615:	50                   	push   eax
10004616:	56                   	push   esi
10004617:	c7 45 fc ff ff ff ff 	mov    DWORD PTR [ebp-0x4],0xffffffff
1000461e:	e8 8d d7 ff ff       	call   0x10001db0
10004623:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
10004626:	33 c0                	xor    eax,eax
10004628:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
1000462f:	5e                   	pop    esi
10004630:	8b e5                	mov    esp,ebp
10004632:	5d                   	pop    ebp
10004633:	c2 04 00             	ret    0x4
10004636:	90                   	nop
10004637:	90                   	nop
10004638:	90                   	nop
10004639:	90                   	nop
1000463a:	90                   	nop
1000463b:	90                   	nop
1000463c:	90                   	nop
1000463d:	90                   	nop
1000463e:	90                   	nop
1000463f:	90                   	nop
10004640:	55                   	push   ebp
10004641:	8b ec                	mov    ebp,esp
10004643:	81 ec d0 00 00 00    	sub    esp,0xd0
10004649:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
1000464f:	8d 95 30 ff ff ff    	lea    edx,[ebp-0xd0]
10004655:	52                   	push   edx
10004656:	68 98 e9 00 10       	push   0x1000e998
1000465b:	8b 01                	mov    eax,DWORD PTR [ecx]
1000465d:	ff 50 14             	call   DWORD PTR [eax+0x14]
10004660:	83 f8 19             	cmp    eax,0x19
10004663:	0f 85 d2 00 00 00    	jne    0x1000473b
10004669:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
1000466f:	68 90 e9 00 10       	push   0x1000e990
10004674:	68 98 e9 00 10       	push   0x1000e998
10004679:	8b 01                	mov    eax,DWORD PTR [ecx]
1000467b:	ff 50 10             	call   DWORD PTR [eax+0x10]
1000467e:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
10004684:	68 88 e9 00 10       	push   0x1000e988
10004689:	68 7c e9 00 10       	push   0x1000e97c
1000468e:	8b 11                	mov    edx,DWORD PTR [ecx]
10004690:	ff 52 10             	call   DWORD PTR [edx+0x10]
10004693:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
10004699:	68 90 e9 00 10       	push   0x1000e990
1000469e:	68 70 e9 00 10       	push   0x1000e970
100046a3:	8b 01                	mov    eax,DWORD PTR [ecx]
100046a5:	ff 50 10             	call   DWORD PTR [eax+0x10]
100046a8:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
100046ae:	68 68 e9 00 10       	push   0x1000e968
100046b3:	68 5c e9 00 10       	push   0x1000e95c
100046b8:	8b 11                	mov    edx,DWORD PTR [ecx]
100046ba:	ff 52 10             	call   DWORD PTR [edx+0x10]
100046bd:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
100046c3:	68 90 e9 00 10       	push   0x1000e990
100046c8:	68 50 e9 00 10       	push   0x1000e950
100046cd:	8b 01                	mov    eax,DWORD PTR [ecx]
100046cf:	ff 50 10             	call   DWORD PTR [eax+0x10]
100046d2:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
100046d8:	68 48 e9 00 10       	push   0x1000e948
100046dd:	68 3c e9 00 10       	push   0x1000e93c
100046e2:	8b 11                	mov    edx,DWORD PTR [ecx]
100046e4:	ff 52 10             	call   DWORD PTR [edx+0x10]
100046e7:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
100046ed:	68 90 e9 00 10       	push   0x1000e990
100046f2:	68 30 e9 00 10       	push   0x1000e930
100046f7:	8b 01                	mov    eax,DWORD PTR [ecx]
100046f9:	ff 50 10             	call   DWORD PTR [eax+0x10]
100046fc:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
10004702:	68 28 e9 00 10       	push   0x1000e928
10004707:	68 1c e9 00 10       	push   0x1000e91c
1000470c:	8b 11                	mov    edx,DWORD PTR [ecx]
1000470e:	ff 52 10             	call   DWORD PTR [edx+0x10]
10004711:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
10004717:	68 90 e9 00 10       	push   0x1000e990
1000471c:	68 10 e9 00 10       	push   0x1000e910
10004721:	8b 01                	mov    eax,DWORD PTR [ecx]
10004723:	ff 50 10             	call   DWORD PTR [eax+0x10]
10004726:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
1000472c:	68 0c e9 00 10       	push   0x1000e90c
10004731:	68 00 e9 00 10       	push   0x1000e900
10004736:	8b 11                	mov    edx,DWORD PTR [ecx]
10004738:	ff 52 10             	call   DWORD PTR [edx+0x10]
1000473b:	53                   	push   ebx
1000473c:	56                   	push   esi
1000473d:	57                   	push   edi
1000473e:	be d4 00 00 00       	mov    esi,0xd4
10004743:	a1 b8 f5 00 10       	mov    eax,ds:0x1000f5b8
10004748:	56                   	push   esi
10004749:	6a 32                	push   0x32
1000474b:	68 c8 e8 00 10       	push   0x1000e8c8
10004750:	50                   	push   eax
10004751:	e8 aa 02 00 00       	call   0x10004a00
10004756:	83 c6 11             	add    esi,0x11
10004759:	83 c4 10             	add    esp,0x10
1000475c:	81 fe 29 01 00 00    	cmp    esi,0x129
10004762:	7c df                	jl     0x10004743
10004764:	be 01 00 00 00       	mov    esi,0x1
10004769:	c7 45 fc d4 00 00 00 	mov    DWORD PTR [ebp-0x4],0xd4
10004770:	89 75 f8             	mov    DWORD PTR [ebp-0x8],esi
10004773:	eb 03                	jmp    0x10004778
10004775:	8b 75 f8             	mov    esi,DWORD PTR [ebp-0x8]
10004778:	56                   	push   esi
10004779:	8d 4d dc             	lea    ecx,[ebp-0x24]
1000477c:	68 48 e5 00 10       	push   0x1000e548
10004781:	51                   	push   ecx
10004782:	e8 29 0a 00 00       	call   0x100051b0
10004787:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
1000478d:	83 c4 0c             	add    esp,0xc
10004790:	8d 85 30 ff ff ff    	lea    eax,[ebp-0xd0]
10004796:	8b 11                	mov    edx,DWORD PTR [ecx]
10004798:	50                   	push   eax
10004799:	8d 45 dc             	lea    eax,[ebp-0x24]
1000479c:	50                   	push   eax
1000479d:	ff 52 14             	call   DWORD PTR [edx+0x14]
100047a0:	56                   	push   esi
100047a1:	8d 4d dc             	lea    ecx,[ebp-0x24]
100047a4:	68 1c e6 00 10       	push   0x1000e61c
100047a9:	51                   	push   ecx
100047aa:	e8 01 0a 00 00       	call   0x100051b0
100047af:	8b 0d c4 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5c4
100047b5:	83 c4 0c             	add    esp,0xc
100047b8:	8d 45 c8             	lea    eax,[ebp-0x38]
100047bb:	8b 11                	mov    edx,DWORD PTR [ecx]
100047bd:	50                   	push   eax
100047be:	8d 45 dc             	lea    eax,[ebp-0x24]
100047c1:	50                   	push   eax
100047c2:	ff 52 14             	call   DWORD PTR [edx+0x14]
100047c5:	8d 4d c8             	lea    ecx,[ebp-0x38]
100047c8:	51                   	push   ecx
100047c9:	e8 14 0f 00 00       	call   0x100056e2
100047ce:	8d 95 30 ff ff ff    	lea    edx,[ebp-0xd0]
100047d4:	8b d8                	mov    ebx,eax
100047d6:	52                   	push   edx
100047d7:	8d 85 64 ff ff ff    	lea    eax,[ebp-0x9c]
100047dd:	68 c4 e8 00 10       	push   0x1000e8c4
100047e2:	50                   	push   eax
100047e3:	e8 c8 09 00 00       	call   0x100051b0
100047e8:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
100047ee:	83 c4 10             	add    esp,0x10
100047f1:	8b 11                	mov    edx,DWORD PTR [ecx]
100047f3:	6a 01                	push   0x1
100047f5:	6a 0c                	push   0xc
100047f7:	68 90 e2 00 10       	push   0x1000e290
100047fc:	ff 52 28             	call   DWORD PTR [edx+0x28]
100047ff:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10004805:	8b f0                	mov    esi,eax
10004807:	56                   	push   esi
10004808:	8b 01                	mov    eax,DWORD PTR [ecx]
1000480a:	ff 50 48             	call   DWORD PTR [eax+0x48]
1000480d:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10004813:	8d 45 f0             	lea    eax,[ebp-0x10]
10004816:	50                   	push   eax
10004817:	8d bd 64 ff ff ff    	lea    edi,[ebp-0x9c]
1000481d:	8b 11                	mov    edx,DWORD PTR [ecx]
1000481f:	83 c9 ff             	or     ecx,0xffffffff
10004822:	33 c0                	xor    eax,eax
10004824:	f2 ae                	repnz scas al,BYTE PTR es:[edi]
10004826:	f7 d1                	not    ecx
10004828:	49                   	dec    ecx
10004829:	51                   	push   ecx
1000482a:	8d 8d 64 ff ff ff    	lea    ecx,[ebp-0x9c]
10004830:	51                   	push   ecx
10004831:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10004837:	56                   	push   esi
10004838:	ff 52 58             	call   DWORD PTR [edx+0x58]
1000483b:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10004841:	68 ff 00 00 00       	push   0xff
10004846:	68 99 00 00 00       	push   0x99
1000484b:	6a 33                	push   0x33
1000484d:	8b 11                	mov    edx,DWORD PTR [ecx]
1000484f:	ff 52 1c             	call   DWORD PTR [edx+0x1c]
10004852:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
10004855:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
1000485b:	8d 78 11             	lea    edi,[eax+0x11]
1000485e:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
10004861:	8b 11                	mov    edx,DWORD PTR [ecx]
10004863:	83 c0 3a             	add    eax,0x3a
10004866:	57                   	push   edi
10004867:	50                   	push   eax
10004868:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
1000486b:	50                   	push   eax
1000486c:	6a 32                	push   0x32
1000486e:	ff 52 10             	call   DWORD PTR [edx+0x10]
10004871:	8b 16                	mov    edx,DWORD PTR [esi]
10004873:	8b ce                	mov    ecx,esi
10004875:	ff 52 04             	call   DWORD PTR [edx+0x4]
10004878:	8d 85 30 ff ff ff    	lea    eax,[ebp-0xd0]
1000487e:	8d 8d 64 ff ff ff    	lea    ecx,[ebp-0x9c]
10004884:	50                   	push   eax
10004885:	68 ac e8 00 10       	push   0x1000e8ac
1000488a:	51                   	push   ecx
1000488b:	e8 20 09 00 00       	call   0x100051b0
10004890:	8b 75 fc             	mov    esi,DWORD PTR [ebp-0x4]
10004893:	a1 b8 f5 00 10       	mov    eax,ds:0x1000f5b8
10004898:	56                   	push   esi
10004899:	8d 95 64 ff ff ff    	lea    edx,[ebp-0x9c]
1000489f:	6a 32                	push   0x32
100048a1:	52                   	push   edx
100048a2:	50                   	push   eax
100048a3:	e8 58 01 00 00       	call   0x10004a00
100048a8:	83 c4 1c             	add    esp,0x1c
100048ab:	81 fb 3f 42 0f 00    	cmp    ebx,0xf423f
100048b1:	7e 4f                	jle    0x10004902
100048b3:	8b c3                	mov    eax,ebx
100048b5:	b9 e8 03 00 00       	mov    ecx,0x3e8
100048ba:	99                   	cdq
100048bb:	f7 f9                	idiv   ecx
100048bd:	b8 d3 4d 62 10       	mov    eax,0x10624dd3
100048c2:	52                   	push   edx
100048c3:	f7 eb                	imul   ebx
100048c5:	c1 fa 06             	sar    edx,0x6
100048c8:	8b ca                	mov    ecx,edx
100048ca:	8b c2                	mov    eax,edx
100048cc:	c1 e9 1f             	shr    ecx,0x1f
100048cf:	03 c1                	add    eax,ecx
100048d1:	b9 e8 03 00 00       	mov    ecx,0x3e8
100048d6:	99                   	cdq
100048d7:	f7 f9                	idiv   ecx
100048d9:	b8 83 de 1b 43       	mov    eax,0x431bde83
100048de:	8d 8d 64 ff ff ff    	lea    ecx,[ebp-0x9c]
100048e4:	52                   	push   edx
100048e5:	f7 eb                	imul   ebx
100048e7:	c1 fa 12             	sar    edx,0x12
100048ea:	8b c2                	mov    eax,edx
100048ec:	c1 e8 1f             	shr    eax,0x1f
100048ef:	03 d0                	add    edx,eax
100048f1:	52                   	push   edx
100048f2:	68 88 e8 00 10       	push   0x1000e888
100048f7:	51                   	push   ecx
100048f8:	e8 b3 08 00 00       	call   0x100051b0
100048fd:	83 c4 14             	add    esp,0x14
10004900:	eb 50                	jmp    0x10004952
10004902:	81 fb e7 03 00 00    	cmp    ebx,0x3e7
10004908:	7e 33                	jle    0x1000493d
1000490a:	8b c3                	mov    eax,ebx
1000490c:	b9 e8 03 00 00       	mov    ecx,0x3e8
10004911:	99                   	cdq
10004912:	f7 f9                	idiv   ecx
10004914:	b8 d3 4d 62 10       	mov    eax,0x10624dd3
10004919:	8d 8d 64 ff ff ff    	lea    ecx,[ebp-0x9c]
1000491f:	52                   	push   edx
10004920:	f7 eb                	imul   ebx
10004922:	c1 fa 06             	sar    edx,0x6
10004925:	8b c2                	mov    eax,edx
10004927:	c1 e8 1f             	shr    eax,0x1f
1000492a:	03 d0                	add    edx,eax
1000492c:	52                   	push   edx
1000492d:	68 6c e8 00 10       	push   0x1000e86c
10004932:	51                   	push   ecx
10004933:	e8 78 08 00 00       	call   0x100051b0
10004938:	83 c4 10             	add    esp,0x10
1000493b:	eb 15                	jmp    0x10004952
1000493d:	53                   	push   ebx
1000493e:	8d 95 64 ff ff ff    	lea    edx,[ebp-0x9c]
10004944:	68 54 e8 00 10       	push   0x1000e854
10004949:	52                   	push   edx
1000494a:	e8 61 08 00 00       	call   0x100051b0
1000494f:	83 c4 0c             	add    esp,0xc
10004952:	8b 0d b8 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b8
10004958:	56                   	push   esi
10004959:	8d 85 64 ff ff ff    	lea    eax,[ebp-0x9c]
1000495f:	68 9b 00 00 00       	push   0x9b
10004964:	50                   	push   eax
10004965:	51                   	push   ecx
10004966:	e8 95 00 00 00       	call   0x10004a00
1000496b:	8b 45 f8             	mov    eax,DWORD PTR [ebp-0x8]
1000496e:	83 c4 10             	add    esp,0x10
10004971:	40                   	inc    eax
10004972:	89 7d fc             	mov    DWORD PTR [ebp-0x4],edi
10004975:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
10004978:	48                   	dec    eax
10004979:	83 f8 05             	cmp    eax,0x5
1000497c:	0f 8c f3 fd ff ff    	jl     0x10004775
10004982:	5f                   	pop    edi
10004983:	5e                   	pop    esi
10004984:	5b                   	pop    ebx
10004985:	8b e5                	mov    esp,ebp
10004987:	5d                   	pop    ebp
10004988:	c3                   	ret
10004989:	90                   	nop
1000498a:	90                   	nop
1000498b:	90                   	nop
1000498c:	90                   	nop
1000498d:	90                   	nop
1000498e:	90                   	nop
1000498f:	90                   	nop
10004990:	55                   	push   ebp
10004991:	8b ec                	mov    ebp,esp
10004993:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10004996:	50                   	push   eax
10004997:	8b 08                	mov    ecx,DWORD PTR [eax]
10004999:	e8 92 fb ff ff       	call   0x10004530
1000499e:	5d                   	pop    ebp
1000499f:	c3                   	ret
100049a0:	55                   	push   ebp
100049a1:	8b ec                	mov    ebp,esp
100049a3:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100049a6:	50                   	push   eax
100049a7:	8b 08                	mov    ecx,DWORD PTR [eax]
100049a9:	e8 42 fa ff ff       	call   0x100043f0
100049ae:	5d                   	pop    ebp
100049af:	c3                   	ret
100049b0:	55                   	push   ebp
100049b1:	8b ec                	mov    ebp,esp
100049b3:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100049b6:	50                   	push   eax
100049b7:	8b 08                	mov    ecx,DWORD PTR [eax]
100049b9:	e8 e2 fb ff ff       	call   0x100045a0
100049be:	5d                   	pop    ebp
100049bf:	c3                   	ret
100049c0:	55                   	push   ebp
100049c1:	8b ec                	mov    ebp,esp
100049c3:	8a 45 08             	mov    al,BYTE PTR [ebp+0x8]
100049c6:	3c 61                	cmp    al,0x61
100049c8:	7c 0c                	jl     0x100049d6
100049ca:	3c 66                	cmp    al,0x66
100049cc:	7f 08                	jg     0x100049d6
100049ce:	0f be c0             	movsx  eax,al
100049d1:	83 e8 57             	sub    eax,0x57
100049d4:	5d                   	pop    ebp
100049d5:	c3                   	ret
100049d6:	3c 30                	cmp    al,0x30
100049d8:	7c 0c                	jl     0x100049e6
100049da:	3c 39                	cmp    al,0x39
100049dc:	7f 08                	jg     0x100049e6
100049de:	0f be c0             	movsx  eax,al
100049e1:	83 e8 30             	sub    eax,0x30
100049e4:	5d                   	pop    ebp
100049e5:	c3                   	ret
100049e6:	3c 41                	cmp    al,0x41
100049e8:	7c 0c                	jl     0x100049f6
100049ea:	3c 46                	cmp    al,0x46
100049ec:	7f 08                	jg     0x100049f6
100049ee:	0f be c0             	movsx  eax,al
100049f1:	83 e8 37             	sub    eax,0x37
100049f4:	5d                   	pop    ebp
100049f5:	c3                   	ret
100049f6:	33 c0                	xor    eax,eax
100049f8:	5d                   	pop    ebp
100049f9:	c3                   	ret
100049fa:	90                   	nop
100049fb:	90                   	nop
100049fc:	90                   	nop
100049fd:	90                   	nop
100049fe:	90                   	nop
100049ff:	90                   	nop
10004a00:	55                   	push   ebp
10004a01:	8b ec                	mov    ebp,esp
10004a03:	b8 7c 5e 00 00       	mov    eax,0x5e7c
10004a08:	e8 f3 0b 00 00       	call   0x10005600
10004a0d:	53                   	push   ebx
10004a0e:	56                   	push   esi
10004a0f:	8b 75 0c             	mov    esi,DWORD PTR [ebp+0xc]
10004a12:	57                   	push   edi
10004a13:	8b fe                	mov    edi,esi
10004a15:	83 c9 ff             	or     ecx,0xffffffff
10004a18:	33 c0                	xor    eax,eax
10004a1a:	f2 ae                	repnz scas al,BYTE PTR es:[edi]
10004a1c:	f7 d1                	not    ecx
10004a1e:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax
10004a21:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
10004a24:	49                   	dec    ecx
10004a25:	89 45 e0             	mov    DWORD PTR [ebp-0x20],eax
10004a28:	8a 06                	mov    al,BYTE PTR [esi]
10004a2a:	89 4d dc             	mov    DWORD PTR [ebp-0x24],ecx
10004a2d:	8b 4d 14             	mov    ecx,DWORD PTR [ebp+0x14]
10004a30:	84 c0                	test   al,al
10004a32:	89 4d e4             	mov    DWORD PTR [ebp-0x1c],ecx
10004a35:	0f 84 de 00 00 00    	je     0x10004b19
10004a3b:	8d 9d 88 a1 ff ff    	lea    ebx,[ebp-0x5e78]
10004a41:	8d 95 84 a1 ff ff    	lea    edx,[ebp-0x5e7c]
10004a47:	8d 8d 8c a1 ff ff    	lea    ecx,[ebp-0x5e74]
10004a4d:	89 5d 10             	mov    DWORD PTR [ebp+0x10],ebx
10004a50:	89 55 ec             	mov    DWORD PTR [ebp-0x14],edx
10004a53:	89 4d 0c             	mov    DWORD PTR [ebp+0xc],ecx
10004a56:	33 ff                	xor    edi,edi
10004a58:	3c 3c                	cmp    al,0x3c
10004a5a:	89 7d e8             	mov    DWORD PTR [ebp-0x18],edi
10004a5d:	74 46                	je     0x10004aa5
10004a5f:	68 14 ea 00 10       	push   0x1000ea14
10004a64:	56                   	push   esi
10004a65:	e8 46 0d 00 00       	call   0x100057b0
10004a6a:	8b 55 0c             	mov    edx,DWORD PTR [ebp+0xc]
10004a6d:	8b f8                	mov    edi,eax
10004a6f:	83 c4 08             	add    esp,0x8
10004a72:	8a 04 37             	mov    al,BYTE PTR [edi+esi*1]
10004a75:	c7 02 00 00 00 00    	mov    DWORD PTR [edx],0x0
10004a7b:	3c 20                	cmp    al,0x20
10004a7d:	89 3b                	mov    DWORD PTR [ebx],edi
10004a7f:	75 03                	jne    0x10004a84
10004a81:	47                   	inc    edi
10004a82:	89 3b                	mov    DWORD PTR [ebx],edi
10004a84:	8b 45 ec             	mov    eax,DWORD PTR [ebp-0x14]
10004a87:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
10004a8a:	8b 55 0c             	mov    edx,DWORD PTR [ebp+0xc]
10004a8d:	41                   	inc    ecx
10004a8e:	89 30                	mov    DWORD PTR [eax],esi
10004a90:	83 c2 0c             	add    edx,0xc
10004a93:	83 c0 0c             	add    eax,0xc
10004a96:	83 c3 0c             	add    ebx,0xc
10004a99:	89 4d f0             	mov    DWORD PTR [ebp-0x10],ecx
10004a9c:	89 55 0c             	mov    DWORD PTR [ebp+0xc],edx
10004a9f:	89 45 ec             	mov    DWORD PTR [ebp-0x14],eax
10004aa2:	89 5d 10             	mov    DWORD PTR [ebp+0x10],ebx
10004aa5:	3b 7d dc             	cmp    edi,DWORD PTR [ebp-0x24]
10004aa8:	7d 5d                	jge    0x10004b07
10004aaa:	80 3c 37 20          	cmp    BYTE PTR [edi+esi*1],0x20
10004aae:	75 09                	jne    0x10004ab9
10004ab0:	8a 44 37 01          	mov    al,BYTE PTR [edi+esi*1+0x1]
10004ab4:	47                   	inc    edi
10004ab5:	3c 20                	cmp    al,0x20
10004ab7:	74 f7                	je     0x10004ab0
10004ab9:	80 3c 37 3c          	cmp    BYTE PTR [edi+esi*1],0x3c
10004abd:	75 48                	jne    0x10004b07
10004abf:	46                   	inc    esi
10004ac0:	68 10 ea 00 10       	push   0x1000ea10
10004ac5:	8d 1c 37             	lea    ebx,[edi+esi*1]
10004ac8:	53                   	push   ebx
10004ac9:	e8 e2 0c 00 00       	call   0x100057b0
10004ace:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
10004ad1:	8b 55 ec             	mov    edx,DWORD PTR [ebp-0x14]
10004ad4:	83 c2 0c             	add    edx,0xc
10004ad7:	83 c4 08             	add    esp,0x8
10004ada:	c7 01 01 00 00 00    	mov    DWORD PTR [ecx],0x1
10004ae0:	89 5a f4             	mov    DWORD PTR [edx-0xc],ebx
10004ae3:	8b 5d 10             	mov    ebx,DWORD PTR [ebp+0x10]
10004ae6:	89 55 ec             	mov    DWORD PTR [ebp-0x14],edx
10004ae9:	8b 55 10             	mov    edx,DWORD PTR [ebp+0x10]
10004aec:	83 c1 0c             	add    ecx,0xc
10004aef:	89 03                	mov    DWORD PTR [ebx],eax
10004af1:	8b 5d f0             	mov    ebx,DWORD PTR [ebp-0x10]
10004af4:	43                   	inc    ebx
10004af5:	83 c2 0c             	add    edx,0xc
10004af8:	40                   	inc    eax
10004af9:	89 5d f0             	mov    DWORD PTR [ebp-0x10],ebx
10004afc:	89 4d 0c             	mov    DWORD PTR [ebp+0xc],ecx
10004aff:	89 55 10             	mov    DWORD PTR [ebp+0x10],edx
10004b02:	89 45 e8             	mov    DWORD PTR [ebp-0x18],eax
10004b05:	8b da                	mov    ebx,edx
10004b07:	8b 45 e8             	mov    eax,DWORD PTR [ebp-0x18]
10004b0a:	03 f8                	add    edi,eax
10004b0c:	8a 04 3e             	mov    al,BYTE PTR [esi+edi*1]
10004b0f:	03 f7                	add    esi,edi
10004b11:	84 c0                	test   al,al
10004b13:	0f 85 3d ff ff ff    	jne    0x10004a56
10004b19:	8b 7d 08             	mov    edi,DWORD PTR [ebp+0x8]
10004b1c:	8d 45 fc             	lea    eax,[ebp-0x4]
10004b1f:	50                   	push   eax
10004b20:	8b cf                	mov    ecx,edi
10004b22:	8b 17                	mov    edx,DWORD PTR [edi]
10004b24:	ff 52 4c             	call   DWORD PTR [edx+0x4c]
10004b27:	8b 17                	mov    edx,DWORD PTR [edi]
10004b29:	8d 45 cc             	lea    eax,[ebp-0x34]
10004b2c:	8d 4d d8             	lea    ecx,[ebp-0x28]
10004b2f:	50                   	push   eax
10004b30:	51                   	push   ecx
10004b31:	8b cf                	mov    ecx,edi
10004b33:	ff 52 50             	call   DWORD PTR [edx+0x50]
10004b36:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10004b39:	8b 17                	mov    edx,DWORD PTR [edi]
10004b3b:	8d 45 c4             	lea    eax,[ebp-0x3c]
10004b3e:	c6 45 13 00          	mov    BYTE PTR [ebp+0x13],0x0
10004b42:	50                   	push   eax
10004b43:	6a 04                	push   0x4
10004b45:	68 08 ea 00 10       	push   0x1000ea08
10004b4a:	51                   	push   ecx
10004b4b:	8b cf                	mov    ecx,edi
10004b4d:	ff 52 58             	call   DWORD PTR [edx+0x58]
10004b50:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
10004b53:	85 c0                	test   eax,eax
10004b55:	0f 8e a8 02 00 00    	jle    0x10004e03
10004b5b:	8d 8d 88 a1 ff ff    	lea    ecx,[ebp-0x5e78]
10004b61:	89 45 e8             	mov    DWORD PTR [ebp-0x18],eax
10004b64:	89 4d 08             	mov    DWORD PTR [ebp+0x8],ecx
10004b67:	8b 71 fc             	mov    esi,DWORD PTR [ecx-0x4]
10004b6a:	8b 19                	mov    ebx,DWORD PTR [ecx]
10004b6c:	8b 41 04             	mov    eax,DWORD PTR [ecx+0x4]
10004b6f:	33 c9                	xor    ecx,ecx
10004b71:	2b c1                	sub    eax,ecx
10004b73:	c6 45 0f 00          	mov    BYTE PTR [ebp+0xf],0x0
10004b77:	0f 84 2a 02 00 00    	je     0x10004da7
10004b7d:	48                   	dec    eax
10004b7e:	0f 85 69 02 00 00    	jne    0x10004ded
10004b84:	80 3e 2f             	cmp    BYTE PTR [esi],0x2f
10004b87:	75 05                	jne    0x10004b8e
10004b89:	c6 45 0f 01          	mov    BYTE PTR [ebp+0xf],0x1
10004b8d:	46                   	inc    esi
10004b8e:	0f be 06             	movsx  eax,BYTE PTR [esi]
10004b91:	83 c0 be             	add    eax,0xffffffbe
10004b94:	83 f8 33             	cmp    eax,0x33
10004b97:	0f 87 50 02 00 00    	ja     0x10004ded
10004b9d:	33 d2                	xor    edx,edx
10004b9f:	8a 90 30 4e 00 10    	mov    dl,BYTE PTR [eax+0x10004e30]
10004ba5:	ff 24 95 14 4e 00 10 	jmp    DWORD PTR [edx*4+0x10004e14]
10004bac:	8b 45 e4             	mov    eax,DWORD PTR [ebp-0x1c]
10004baf:	89 4d e0             	mov    DWORD PTR [ebp-0x20],ecx
10004bb2:	83 c0 1e             	add    eax,0x1e
10004bb5:	89 45 e4             	mov    DWORD PTR [ebp-0x1c],eax
10004bb8:	e9 30 02 00 00       	jmp    0x10004ded
10004bbd:	8a 46 01             	mov    al,BYTE PTR [esi+0x1]
10004bc0:	3c 72                	cmp    al,0x72
10004bc2:	74 31                	je     0x10004bf5
10004bc4:	3c 52                	cmp    al,0x52
10004bc6:	74 2d                	je     0x10004bf5
10004bc8:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10004bcb:	8d 55 14             	lea    edx,[ebp+0x14]
10004bce:	52                   	push   edx
10004bcf:	8d 55 f8             	lea    edx,[ebp-0x8]
10004bd2:	8b 01                	mov    eax,DWORD PTR [ecx]
10004bd4:	52                   	push   edx
10004bd5:	8d 55 f4             	lea    edx,[ebp-0xc]
10004bd8:	52                   	push   edx
10004bd9:	8d 95 44 ff ff ff    	lea    edx,[ebp-0xbc]
10004bdf:	52                   	push   edx
10004be0:	ff 50 0c             	call   DWORD PTR [eax+0xc]
10004be3:	8a 45 0f             	mov    al,BYTE PTR [ebp+0xf]
10004be6:	84 c0                	test   al,al
10004be8:	8b 45 14             	mov    eax,DWORD PTR [ebp+0x14]
10004beb:	74 04                	je     0x10004bf1
10004bed:	24 fe                	and    al,0xfe
10004bef:	eb 40                	jmp    0x10004c31
10004bf1:	0c 01                	or     al,0x1
10004bf3:	eb 3c                	jmp    0x10004c31
10004bf5:	8b 45 e4             	mov    eax,DWORD PTR [ebp-0x1c]
10004bf8:	89 4d e0             	mov    DWORD PTR [ebp-0x20],ecx
10004bfb:	83 c0 0f             	add    eax,0xf
10004bfe:	89 45 e4             	mov    DWORD PTR [ebp-0x1c],eax
10004c01:	e9 e7 01 00 00       	jmp    0x10004ded
10004c06:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10004c09:	8d 55 14             	lea    edx,[ebp+0x14]
10004c0c:	52                   	push   edx
10004c0d:	8d 55 f8             	lea    edx,[ebp-0x8]
10004c10:	8b 01                	mov    eax,DWORD PTR [ecx]
10004c12:	52                   	push   edx
10004c13:	8d 55 f4             	lea    edx,[ebp-0xc]
10004c16:	52                   	push   edx
10004c17:	8d 95 44 ff ff ff    	lea    edx,[ebp-0xbc]
10004c1d:	52                   	push   edx
10004c1e:	ff 50 0c             	call   DWORD PTR [eax+0xc]
10004c21:	8a 45 0f             	mov    al,BYTE PTR [ebp+0xf]
10004c24:	84 c0                	test   al,al
10004c26:	8b 45 14             	mov    eax,DWORD PTR [ebp+0x14]
10004c29:	74 04                	je     0x10004c2f
10004c2b:	24 fd                	and    al,0xfd
10004c2d:	eb 02                	jmp    0x10004c31
10004c2f:	0c 02                	or     al,0x2
10004c31:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10004c34:	89 45 14             	mov    DWORD PTR [ebp+0x14],eax
10004c37:	8b 01                	mov    eax,DWORD PTR [ecx]
10004c39:	ff 50 04             	call   DWORD PTR [eax+0x4]
10004c3c:	8b 45 14             	mov    eax,DWORD PTR [ebp+0x14]
10004c3f:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10004c45:	50                   	push   eax
10004c46:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
10004c49:	8b 11                	mov    edx,DWORD PTR [ecx]
10004c4b:	50                   	push   eax
10004c4c:	8d 85 44 ff ff ff    	lea    eax,[ebp-0xbc]
10004c52:	50                   	push   eax
10004c53:	ff 52 28             	call   DWORD PTR [edx+0x28]
10004c56:	8b 17                	mov    edx,DWORD PTR [edi]
10004c58:	50                   	push   eax
10004c59:	8b cf                	mov    ecx,edi
10004c5b:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
10004c5e:	ff 52 48             	call   DWORD PTR [edx+0x48]
10004c61:	e9 87 01 00 00       	jmp    0x10004ded
10004c66:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10004c69:	8d 55 14             	lea    edx,[ebp+0x14]
10004c6c:	52                   	push   edx
10004c6d:	8d 55 f8             	lea    edx,[ebp-0x8]
10004c70:	8b 01                	mov    eax,DWORD PTR [ecx]
10004c72:	52                   	push   edx
10004c73:	8d 55 f4             	lea    edx,[ebp-0xc]
10004c76:	52                   	push   edx
10004c77:	8d 95 44 ff ff ff    	lea    edx,[ebp-0xbc]
10004c7d:	52                   	push   edx
10004c7e:	ff 50 0c             	call   DWORD PTR [eax+0xc]
10004c81:	8a 45 0f             	mov    al,BYTE PTR [ebp+0xf]
10004c84:	84 c0                	test   al,al
10004c86:	8b 45 14             	mov    eax,DWORD PTR [ebp+0x14]
10004c89:	74 04                	je     0x10004c8f
10004c8b:	24 fb                	and    al,0xfb
10004c8d:	eb a2                	jmp    0x10004c31
10004c8f:	0c 04                	or     al,0x4
10004c91:	eb 9e                	jmp    0x10004c31
10004c93:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10004c96:	8d 55 14             	lea    edx,[ebp+0x14]
10004c99:	52                   	push   edx
10004c9a:	8d 55 f8             	lea    edx,[ebp-0x8]
10004c9d:	8b 01                	mov    eax,DWORD PTR [ecx]
10004c9f:	52                   	push   edx
10004ca0:	8d 55 f4             	lea    edx,[ebp-0xc]
10004ca3:	52                   	push   edx
10004ca4:	8d 95 44 ff ff ff    	lea    edx,[ebp-0xbc]
10004caa:	52                   	push   edx
10004cab:	ff 50 0c             	call   DWORD PTR [eax+0xc]
10004cae:	8a 46 01             	mov    al,BYTE PTR [esi+0x1]
10004cb1:	3c 2d                	cmp    al,0x2d
10004cb3:	75 10                	jne    0x10004cc5
10004cb5:	8b 45 f8             	mov    eax,DWORD PTR [ebp-0x8]
10004cb8:	40                   	inc    eax
10004cb9:	83 f8 05             	cmp    eax,0x5
10004cbc:	7c 23                	jl     0x10004ce1
10004cbe:	b8 05 00 00 00       	mov    eax,0x5
10004cc3:	eb 1c                	jmp    0x10004ce1
10004cc5:	3c 2b                	cmp    al,0x2b
10004cc7:	75 12                	jne    0x10004cdb
10004cc9:	8b 4d f8             	mov    ecx,DWORD PTR [ebp-0x8]
10004ccc:	33 d2                	xor    edx,edx
10004cce:	8d 41 ff             	lea    eax,[ecx-0x1]
10004cd1:	85 c0                	test   eax,eax
10004cd3:	0f 9e c2             	setle  dl
10004cd6:	4a                   	dec    edx
10004cd7:	23 c2                	and    eax,edx
10004cd9:	eb 06                	jmp    0x10004ce1
10004cdb:	0f be c0             	movsx  eax,al
10004cde:	83 e8 30             	sub    eax,0x30
10004ce1:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10004ce4:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
10004ce7:	c1 e0 04             	shl    eax,0x4
10004cea:	8b 80 ac e9 00 10    	mov    eax,DWORD PTR [eax+0x1000e9ac]
10004cf0:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax
10004cf3:	8b 11                	mov    edx,DWORD PTR [ecx]
10004cf5:	ff 52 04             	call   DWORD PTR [edx+0x4]
10004cf8:	8b 55 14             	mov    edx,DWORD PTR [ebp+0x14]
10004cfb:	8b 0d b0 f5 00 10    	mov    ecx,DWORD PTR ds:0x1000f5b0
10004d01:	52                   	push   edx
10004d02:	8b 55 f4             	mov    edx,DWORD PTR [ebp-0xc]
10004d05:	8b 01                	mov    eax,DWORD PTR [ecx]
10004d07:	52                   	push   edx
10004d08:	8d 95 44 ff ff ff    	lea    edx,[ebp-0xbc]
10004d0e:	52                   	push   edx
10004d0f:	ff 50 28             	call   DWORD PTR [eax+0x28]
10004d12:	8b 17                	mov    edx,DWORD PTR [edi]
10004d14:	50                   	push   eax
10004d15:	8b cf                	mov    ecx,edi
10004d17:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
10004d1a:	ff 52 48             	call   DWORD PTR [edx+0x48]
10004d1d:	e9 cb 00 00 00       	jmp    0x10004ded
10004d22:	8a 5e 01             	mov    bl,BYTE PTR [esi+0x1]
10004d25:	80 fb 3e             	cmp    bl,0x3e
10004d28:	75 0e                	jne    0x10004d38
10004d2a:	8a 45 0f             	mov    al,BYTE PTR [ebp+0xf]
10004d2d:	84 c0                	test   al,al
10004d2f:	0f 94 45 13          	sete   BYTE PTR [ebp+0x13]
10004d33:	e9 b5 00 00 00       	jmp    0x10004ded
10004d38:	8a 46 02             	mov    al,BYTE PTR [esi+0x2]
10004d3b:	50                   	push   eax
10004d3c:	e8 7f fc ff ff       	call   0x100049c0
10004d41:	8b d0                	mov    edx,eax
10004d43:	53                   	push   ebx
10004d44:	89 55 0c             	mov    DWORD PTR [ebp+0xc],edx
10004d47:	e8 74 fc ff ff       	call   0x100049c0
10004d4c:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
10004d4f:	8a 56 03             	mov    dl,BYTE PTR [esi+0x3]
10004d52:	c0 e0 04             	shl    al,0x4
10004d55:	02 c8                	add    cl,al
10004d57:	52                   	push   edx
10004d58:	88 4d f0             	mov    BYTE PTR [ebp-0x10],cl
10004d5b:	e8 60 fc ff ff       	call   0x100049c0
10004d60:	8b d8                	mov    ebx,eax
10004d62:	8a 46 04             	mov    al,BYTE PTR [esi+0x4]
10004d65:	50                   	push   eax
10004d66:	c0 e3 04             	shl    bl,0x4
10004d69:	e8 52 fc ff ff       	call   0x100049c0
10004d6e:	8a 4e 05             	mov    cl,BYTE PTR [esi+0x5]
10004d71:	02 d8                	add    bl,al
10004d73:	51                   	push   ecx
10004d74:	88 5d ec             	mov    BYTE PTR [ebp-0x14],bl
10004d77:	e8 44 fc ff ff       	call   0x100049c0
10004d7c:	8a 56 06             	mov    dl,BYTE PTR [esi+0x6]
10004d7f:	8b d8                	mov    ebx,eax
10004d81:	52                   	push   edx
10004d82:	c0 e3 04             	shl    bl,0x4
10004d85:	e8 36 fc ff ff       	call   0x100049c0
10004d8a:	8b 55 ec             	mov    edx,DWORD PTR [ebp-0x14]
10004d8d:	02 d8                	add    bl,al
10004d8f:	8b 07                	mov    eax,DWORD PTR [edi]
10004d91:	88 5d dc             	mov    BYTE PTR [ebp-0x24],bl
10004d94:	8b 4d dc             	mov    ecx,DWORD PTR [ebp-0x24]
10004d97:	83 c4 18             	add    esp,0x18
10004d9a:	51                   	push   ecx
10004d9b:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
10004d9e:	52                   	push   edx
10004d9f:	51                   	push   ecx
10004da0:	8b cf                	mov    ecx,edi
10004da2:	ff 50 24             	call   DWORD PTR [eax+0x24]
10004da5:	eb 46                	jmp    0x10004ded
10004da7:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10004daa:	8b 17                	mov    edx,DWORD PTR [edi]
10004dac:	8d 45 d0             	lea    eax,[ebp-0x30]
10004daf:	50                   	push   eax
10004db0:	53                   	push   ebx
10004db1:	56                   	push   esi
10004db2:	51                   	push   ecx
10004db3:	8b cf                	mov    ecx,edi
10004db5:	ff 52 58             	call   DWORD PTR [edx+0x58]
10004db8:	8a 45 13             	mov    al,BYTE PTR [ebp+0x13]
10004dbb:	84 c0                	test   al,al
10004dbd:	74 0f                	je     0x10004dce
10004dbf:	8b 45 d8             	mov    eax,DWORD PTR [ebp-0x28]
10004dc2:	8b 55 d0             	mov    edx,DWORD PTR [ebp-0x30]
10004dc5:	2b c2                	sub    eax,edx
10004dc7:	99                   	cdq
10004dc8:	2b c2                	sub    eax,edx
10004dca:	d1 f8                	sar    eax,1
10004dcc:	eb 06                	jmp    0x10004dd4
10004dce:	8b 55 e0             	mov    edx,DWORD PTR [ebp-0x20]
10004dd1:	8d 42 04             	lea    eax,[edx+0x4]
10004dd4:	8b 4d e4             	mov    ecx,DWORD PTR [ebp-0x1c]
10004dd7:	8b 17                	mov    edx,DWORD PTR [edi]
10004dd9:	51                   	push   ecx
10004dda:	50                   	push   eax
10004ddb:	53                   	push   ebx
10004ddc:	56                   	push   esi
10004ddd:	8b cf                	mov    ecx,edi
10004ddf:	ff 52 18             	call   DWORD PTR [edx+0x18]
10004de2:	8b 55 d0             	mov    edx,DWORD PTR [ebp-0x30]
10004de5:	8b 45 e0             	mov    eax,DWORD PTR [ebp-0x20]
10004de8:	03 c2                	add    eax,edx
10004dea:	89 45 e0             	mov    DWORD PTR [ebp-0x20],eax
10004ded:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
10004df0:	8b 45 e8             	mov    eax,DWORD PTR [ebp-0x18]
10004df3:	83 c1 0c             	add    ecx,0xc
10004df6:	48                   	dec    eax
10004df7:	89 4d 08             	mov    DWORD PTR [ebp+0x8],ecx
10004dfa:	89 45 e8             	mov    DWORD PTR [ebp-0x18],eax
10004dfd:	0f 85 64 fd ff ff    	jne    0x10004b67
10004e03:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10004e06:	8b 01                	mov    eax,DWORD PTR [ecx]
10004e08:	ff 50 04             	call   DWORD PTR [eax+0x4]
10004e0b:	5f                   	pop    edi
10004e0c:	5e                   	pop    esi
10004e0d:	33 c0                	xor    eax,eax
10004e0f:	5b                   	pop    ebx
10004e10:	8b e5                	mov    esp,ebp
10004e12:	5d                   	pop    ebp
10004e13:	c3                   	ret
10004e14:	bd 4b 00 10 22       	mov    ebp,0x2210004b
10004e19:	4d                   	dec    ebp
10004e1a:	00 10                	add    BYTE PTR [eax],dl
10004e1c:	06                   	push   es
10004e1d:	4c                   	dec    esp
10004e1e:	00 10                	add    BYTE PTR [eax],dl
10004e20:	ac                   	lods   al,BYTE PTR ds:[esi]
10004e21:	4b                   	dec    ebx
10004e22:	00 10                	add    BYTE PTR [eax],dl
10004e24:	93                   	xchg   ebx,eax
10004e25:	4c                   	dec    esp
10004e26:	00 10                	add    BYTE PTR [eax],dl
10004e28:	66 4c                	dec    sp
10004e2a:	00 10                	add    BYTE PTR [eax],dl
10004e2c:	ed                   	in     eax,dx
10004e2d:	4d                   	dec    ebp
10004e2e:	00 10                	add    BYTE PTR [eax],dl
10004e30:	00 01                	add    BYTE PTR [ecx],al
10004e32:	06                   	push   es
10004e33:	06                   	push   es
10004e34:	06                   	push   es
10004e35:	06                   	push   es
10004e36:	06                   	push   es
10004e37:	02 06                	add    al,BYTE PTR [esi]
10004e39:	06                   	push   es
10004e3a:	06                   	push   es
10004e3b:	06                   	push   es
10004e3c:	06                   	push   es
10004e3d:	06                   	push   es
10004e3e:	03 06                	add    eax,DWORD PTR [esi]
10004e40:	06                   	push   es
10004e41:	04 06                	add    al,0x6
10004e43:	05 06 06 06 06       	add    eax,0x6060606
10004e48:	06                   	push   es
10004e49:	06                   	push   es
10004e4a:	06                   	push   es
10004e4b:	06                   	push   es
10004e4c:	06                   	push   es
10004e4d:	06                   	push   es
10004e4e:	06                   	push   es
10004e4f:	06                   	push   es
10004e50:	00 01                	add    BYTE PTR [ecx],al
10004e52:	06                   	push   es
10004e53:	06                   	push   es
10004e54:	06                   	push   es
10004e55:	06                   	push   es
10004e56:	06                   	push   es
10004e57:	02 06                	add    al,BYTE PTR [esi]
10004e59:	06                   	push   es
10004e5a:	06                   	push   es
10004e5b:	06                   	push   es
10004e5c:	06                   	push   es
10004e5d:	06                   	push   es
10004e5e:	03 06                	add    eax,DWORD PTR [esi]
10004e60:	06                   	push   es
10004e61:	04 06                	add    al,0x6
10004e63:	05 90 90 90 90       	add    eax,0x90909090
10004e68:	90                   	nop
10004e69:	90                   	nop
10004e6a:	90                   	nop
10004e6b:	90                   	nop
10004e6c:	90                   	nop
10004e6d:	90                   	nop
10004e6e:	90                   	nop
10004e6f:	90                   	nop
10004e70:	55                   	push   ebp
10004e71:	8b ec                	mov    ebp,esp
10004e73:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10004e76:	a3 0c f6 00 10       	mov    ds:0x1000f60c,eax
10004e7b:	b0 01                	mov    al,0x1
10004e7d:	5d                   	pop    ebp
10004e7e:	c2 0c 00             	ret    0xc
10004e81:	90                   	nop
10004e82:	90                   	nop
10004e83:	90                   	nop
10004e84:	90                   	nop
10004e85:	90                   	nop
10004e86:	90                   	nop
10004e87:	90                   	nop
10004e88:	90                   	nop
10004e89:	90                   	nop
10004e8a:	90                   	nop
10004e8b:	90                   	nop
10004e8c:	90                   	nop
10004e8d:	90                   	nop
10004e8e:	90                   	nop
10004e8f:	90                   	nop
10004e90:	55                   	push   ebp
10004e91:	8b ec                	mov    ebp,esp
10004e93:	53                   	push   ebx
10004e94:	8b 5d 08             	mov    ebx,DWORD PTR [ebp+0x8]
10004e97:	56                   	push   esi
10004e98:	8b f1                	mov    esi,ecx
10004e9a:	57                   	push   edi
10004e9b:	6a 0a                	push   0xa
10004e9d:	c7 06 00 00 00 00    	mov    DWORD PTR [esi],0x0
10004ea3:	c7 46 08 00 00 00 00 	mov    DWORD PTR [esi+0x8],0x0
10004eaa:	c6 46 0c 00          	mov    BYTE PTR [esi+0xc],0x0
10004eae:	a1 0c f6 00 10       	mov    eax,ds:0x1000f60c
10004eb3:	53                   	push   ebx
10004eb4:	50                   	push   eax
10004eb5:	ff 15 1c d0 00 10    	call   DWORD PTR ds:0x1000d01c
10004ebb:	8b f8                	mov    edi,eax
10004ebd:	85 ff                	test   edi,edi
10004ebf:	75 5d                	jne    0x10004f1e
10004ec1:	50                   	push   eax
10004ec2:	68 80 00 00 00       	push   0x80
10004ec7:	6a 03                	push   0x3
10004ec9:	50                   	push   eax
10004eca:	50                   	push   eax
10004ecb:	68 00 00 00 80       	push   0x80000000
10004ed0:	53                   	push   ebx
10004ed1:	ff 15 18 d0 00 10    	call   DWORD PTR ds:0x1000d018
10004ed7:	8b f8                	mov    edi,eax
10004ed9:	83 ff ff             	cmp    edi,0xffffffff
10004edc:	74 73                	je     0x10004f51
10004ede:	6a 00                	push   0x0
10004ee0:	57                   	push   edi
10004ee1:	ff 15 14 d0 00 10    	call   DWORD PTR ds:0x1000d014
10004ee7:	89 46 04             	mov    DWORD PTR [esi+0x4],eax
10004eea:	83 c0 02             	add    eax,0x2
10004eed:	50                   	push   eax
10004eee:	e8 af 02 00 00       	call   0x100051a2
10004ef3:	8b 56 04             	mov    edx,DWORD PTR [esi+0x4]
10004ef6:	83 c4 04             	add    esp,0x4
10004ef9:	8d 4d 08             	lea    ecx,[ebp+0x8]
10004efc:	89 06                	mov    DWORD PTR [esi],eax
10004efe:	6a 00                	push   0x0
10004f00:	51                   	push   ecx
10004f01:	52                   	push   edx
10004f02:	50                   	push   eax
10004f03:	57                   	push   edi
10004f04:	ff 15 10 d0 00 10    	call   DWORD PTR ds:0x1000d010
10004f0a:	57                   	push   edi
10004f0b:	ff 15 0c d0 00 10    	call   DWORD PTR ds:0x1000d00c
10004f11:	c6 46 0c 01          	mov    BYTE PTR [esi+0xc],0x1
10004f15:	8b c6                	mov    eax,esi
10004f17:	5f                   	pop    edi
10004f18:	5e                   	pop    esi
10004f19:	5b                   	pop    ebx
10004f1a:	5d                   	pop    ebp
10004f1b:	c2 04 00             	ret    0x4
10004f1e:	a1 0c f6 00 10       	mov    eax,ds:0x1000f60c
10004f23:	57                   	push   edi
10004f24:	50                   	push   eax
10004f25:	ff 15 08 d0 00 10    	call   DWORD PTR ds:0x1000d008
10004f2b:	85 c0                	test   eax,eax
10004f2d:	74 22                	je     0x10004f51
10004f2f:	50                   	push   eax
10004f30:	ff 15 04 d0 00 10    	call   DWORD PTR ds:0x1000d004
10004f36:	85 c0                	test   eax,eax
10004f38:	89 06                	mov    DWORD PTR [esi],eax
10004f3a:	74 15                	je     0x10004f51
10004f3c:	8b 0d 0c f6 00 10    	mov    ecx,DWORD PTR ds:0x1000f60c
10004f42:	57                   	push   edi
10004f43:	51                   	push   ecx
10004f44:	ff 15 6c d0 00 10    	call   DWORD PTR ds:0x1000d06c
10004f4a:	89 46 04             	mov    DWORD PTR [esi+0x4],eax
10004f4d:	c6 46 0c 01          	mov    BYTE PTR [esi+0xc],0x1
10004f51:	8b c6                	mov    eax,esi
10004f53:	5f                   	pop    edi
10004f54:	5e                   	pop    esi
10004f55:	5b                   	pop    ebx
10004f56:	5d                   	pop    ebp
10004f57:	c2 04 00             	ret    0x4
10004f5a:	90                   	nop
10004f5b:	90                   	nop
10004f5c:	90                   	nop
10004f5d:	90                   	nop
10004f5e:	90                   	nop
10004f5f:	90                   	nop
10004f60:	33 c0                	xor    eax,eax
10004f62:	c3                   	ret
10004f63:	90                   	nop
10004f64:	90                   	nop
10004f65:	90                   	nop
10004f66:	90                   	nop
10004f67:	90                   	nop
10004f68:	90                   	nop
10004f69:	90                   	nop
10004f6a:	90                   	nop
10004f6b:	90                   	nop
10004f6c:	90                   	nop
10004f6d:	90                   	nop
10004f6e:	90                   	nop
10004f6f:	90                   	nop
10004f70:	55                   	push   ebp
10004f71:	8b ec                	mov    ebp,esp
10004f73:	8a 41 0c             	mov    al,BYTE PTR [ecx+0xc]
10004f76:	84 c0                	test   al,al
10004f78:	75 06                	jne    0x10004f80
10004f7a:	b0 01                	mov    al,0x1
10004f7c:	5d                   	pop    ebp
10004f7d:	c2 04 00             	ret    0x4
10004f80:	8b 11                	mov    edx,DWORD PTR [ecx]
10004f82:	56                   	push   esi
10004f83:	8b 75 08             	mov    esi,DWORD PTR [ebp+0x8]
10004f86:	8a 02                	mov    al,BYTE PTR [edx]
10004f88:	42                   	inc    edx
10004f89:	89 11                	mov    DWORD PTR [ecx],edx
10004f8b:	8b 51 08             	mov    edx,DWORD PTR [ecx+0x8]
10004f8e:	42                   	inc    edx
10004f8f:	85 f6                	test   esi,esi
10004f91:	89 51 08             	mov    DWORD PTR [ecx+0x8],edx
10004f94:	74 10                	je     0x10004fa6
10004f96:	53                   	push   ebx
10004f97:	57                   	push   edi
10004f98:	8b 79 04             	mov    edi,DWORD PTR [ecx+0x4]
10004f9b:	33 db                	xor    ebx,ebx
10004f9d:	3b d7                	cmp    edx,edi
10004f9f:	5f                   	pop    edi
10004fa0:	0f 9e c3             	setle  bl
10004fa3:	89 1e                	mov    DWORD PTR [esi],ebx
10004fa5:	5b                   	pop    ebx
10004fa6:	5e                   	pop    esi
10004fa7:	5d                   	pop    ebp
10004fa8:	c2 04 00             	ret    0x4
10004fab:	90                   	nop
10004fac:	90                   	nop
10004fad:	90                   	nop
10004fae:	90                   	nop
10004faf:	90                   	nop
10004fb0:	55                   	push   ebp
10004fb1:	8b ec                	mov    ebp,esp
10004fb3:	83 ec 08             	sub    esp,0x8
10004fb6:	56                   	push   esi
10004fb7:	57                   	push   edi
10004fb8:	8b f9                	mov    edi,ecx
10004fba:	33 f6                	xor    esi,esi
10004fbc:	89 7d f8             	mov    DWORD PTR [ebp-0x8],edi
10004fbf:	8a 47 0c             	mov    al,BYTE PTR [edi+0xc]
10004fc2:	84 c0                	test   al,al
10004fc4:	75 0d                	jne    0x10004fd3
10004fc6:	5f                   	pop    edi
10004fc7:	b8 01 00 00 00       	mov    eax,0x1
10004fcc:	5e                   	pop    esi
10004fcd:	8b e5                	mov    esp,ebp
10004fcf:	5d                   	pop    ebp
10004fd0:	c2 08 00             	ret    0x8
10004fd3:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [ebp-0x4],0x1
10004fda:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
10004fdd:	85 c0                	test   eax,eax
10004fdf:	74 0f                	je     0x10004ff0
10004fe1:	8d 45 fc             	lea    eax,[ebp-0x4]
10004fe4:	8b cf                	mov    ecx,edi
10004fe6:	50                   	push   eax
10004fe7:	e8 84 ff ff ff       	call   0x10004f70
10004fec:	3c 22                	cmp    al,0x22
10004fee:	75 ea                	jne    0x10004fda
10004ff0:	8b 7d 0c             	mov    edi,DWORD PTR [ebp+0xc]
10004ff3:	53                   	push   ebx
10004ff4:	8b 5d 08             	mov    ebx,DWORD PTR [ebp+0x8]
10004ff7:	85 ff                	test   edi,edi
10004ff9:	7e 1f                	jle    0x1000501a
10004ffb:	8d 4d fc             	lea    ecx,[ebp-0x4]
10004ffe:	51                   	push   ecx
10004fff:	8b 4d f8             	mov    ecx,DWORD PTR [ebp-0x8]
10005002:	e8 69 ff ff ff       	call   0x10004f70
10005007:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
1000500a:	85 c9                	test   ecx,ecx
1000500c:	74 0c                	je     0x1000501a
1000500e:	3c 22                	cmp    al,0x22
10005010:	74 08                	je     0x1000501a
10005012:	88 04 1e             	mov    BYTE PTR [esi+ebx*1],al
10005015:	46                   	inc    esi
10005016:	3b f7                	cmp    esi,edi
10005018:	7c e1                	jl     0x10004ffb
1000501a:	c6 04 1e 00          	mov    BYTE PTR [esi+ebx*1],0x0
1000501e:	5b                   	pop    ebx
1000501f:	5f                   	pop    edi
10005020:	33 c0                	xor    eax,eax
10005022:	5e                   	pop    esi
10005023:	8b e5                	mov    esp,ebp
10005025:	5d                   	pop    ebp
10005026:	c2 08 00             	ret    0x8
10005029:	90                   	nop
1000502a:	90                   	nop
1000502b:	90                   	nop
1000502c:	90                   	nop
1000502d:	90                   	nop
1000502e:	90                   	nop
1000502f:	90                   	nop
10005030:	55                   	push   ebp
10005031:	8b ec                	mov    ebp,esp
10005033:	83 ec 08             	sub    esp,0x8
10005036:	53                   	push   ebx
10005037:	8b d9                	mov    ebx,ecx
10005039:	8a 43 0c             	mov    al,BYTE PTR [ebx+0xc]
1000503c:	84 c0                	test   al,al
1000503e:	75 0c                	jne    0x1000504c
10005040:	b8 01 00 00 00       	mov    eax,0x1
10005045:	5b                   	pop    ebx
10005046:	8b e5                	mov    esp,ebp
10005048:	5d                   	pop    ebp
10005049:	c2 04 00             	ret    0x4
1000504c:	8d 45 fc             	lea    eax,[ebp-0x4]
1000504f:	50                   	push   eax
10005050:	8b cb                	mov    ecx,ebx
10005052:	e8 19 ff ff ff       	call   0x10004f70
10005057:	3c 20                	cmp    al,0x20
10005059:	74 0c                	je     0x10005067
1000505b:	3c 0d                	cmp    al,0xd
1000505d:	74 08                	je     0x10005067
1000505f:	3c 09                	cmp    al,0x9
10005061:	74 04                	je     0x10005067
10005063:	3c 0a                	cmp    al,0xa
10005065:	75 0d                	jne    0x10005074
10005067:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
1000506a:	85 c9                	test   ecx,ecx
1000506c:	7e 06                	jle    0x10005074
1000506e:	8d 4d fc             	lea    ecx,[ebp-0x4]
10005071:	51                   	push   ecx
10005072:	eb dc                	jmp    0x10005050
10005074:	56                   	push   esi
10005075:	8b 75 08             	mov    esi,DWORD PTR [ebp+0x8]
10005078:	57                   	push   edi
10005079:	33 ff                	xor    edi,edi
1000507b:	3c 2f                	cmp    al,0x2f
1000507d:	89 7d f8             	mov    DWORD PTR [ebp-0x8],edi
10005080:	89 3e                	mov    DWORD PTR [esi],edi
10005082:	75 22                	jne    0x100050a6
10005084:	3c 0a                	cmp    al,0xa
10005086:	74 0f                	je     0x10005097
10005088:	8d 55 fc             	lea    edx,[ebp-0x4]
1000508b:	8b cb                	mov    ecx,ebx
1000508d:	52                   	push   edx
1000508e:	e8 dd fe ff ff       	call   0x10004f70
10005093:	3c 0a                	cmp    al,0xa
10005095:	75 f1                	jne    0x10005088
10005097:	8d 45 fc             	lea    eax,[ebp-0x4]
1000509a:	8b cb                	mov    ecx,ebx
1000509c:	50                   	push   eax
1000509d:	e8 ce fe ff ff       	call   0x10004f70
100050a2:	3c 2f                	cmp    al,0x2f
100050a4:	74 de                	je     0x10005084
100050a6:	3c 30                	cmp    al,0x30
100050a8:	7c 19                	jl     0x100050c3
100050aa:	3c 39                	cmp    al,0x39
100050ac:	7f 15                	jg     0x100050c3
100050ae:	8b 0e                	mov    ecx,DWORD PTR [esi]
100050b0:	bf 01 00 00 00       	mov    edi,0x1
100050b5:	0f be d0             	movsx  edx,al
100050b8:	8d 0c 89             	lea    ecx,[ecx+ecx*4]
100050bb:	8d 44 4a d0          	lea    eax,[edx+ecx*2-0x30]
100050bf:	89 06                	mov    DWORD PTR [esi],eax
100050c1:	eb 0f                	jmp    0x100050d2
100050c3:	85 ff                	test   edi,edi
100050c5:	75 1d                	jne    0x100050e4
100050c7:	3c 2d                	cmp    al,0x2d
100050c9:	75 07                	jne    0x100050d2
100050cb:	c7 45 f8 01 00 00 00 	mov    DWORD PTR [ebp-0x8],0x1
100050d2:	8d 4d fc             	lea    ecx,[ebp-0x4]
100050d5:	51                   	push   ecx
100050d6:	8b cb                	mov    ecx,ebx
100050d8:	e8 93 fe ff ff       	call   0x10004f70
100050dd:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
100050e0:	85 c9                	test   ecx,ecx
100050e2:	75 c2                	jne    0x100050a6
100050e4:	8b 45 f8             	mov    eax,DWORD PTR [ebp-0x8]
100050e7:	85 c0                	test   eax,eax
100050e9:	74 06                	je     0x100050f1
100050eb:	8b 16                	mov    edx,DWORD PTR [esi]
100050ed:	f7 da                	neg    edx
100050ef:	89 16                	mov    DWORD PTR [esi],edx
100050f1:	5f                   	pop    edi
100050f2:	5e                   	pop    esi
100050f3:	33 c0                	xor    eax,eax
100050f5:	5b                   	pop    ebx
100050f6:	8b e5                	mov    esp,ebp
100050f8:	5d                   	pop    ebp
100050f9:	c2 04 00             	ret    0x4
100050fc:	90                   	nop
100050fd:	90                   	nop
100050fe:	90                   	nop
100050ff:	90                   	nop
10005100:	8a 41 0c             	mov    al,BYTE PTR [ecx+0xc]
10005103:	c3                   	ret
10005104:	90                   	nop
10005105:	90                   	nop
10005106:	90                   	nop
10005107:	90                   	nop
10005108:	90                   	nop
10005109:	90                   	nop
1000510a:	90                   	nop
1000510b:	90                   	nop
1000510c:	90                   	nop
1000510d:	90                   	nop
1000510e:	90                   	nop
1000510f:	90                   	nop
10005110:	55                   	push   ebp
10005111:	8b ec                	mov    ebp,esp
10005113:	83 c4 f4             	add    esp,0xfffffff4
10005116:	9b d9 7d fe          	fstcw  WORD PTR [ebp-0x2]
1000511a:	9b                   	fwait
1000511b:	66 8b 45 fe          	mov    ax,WORD PTR [ebp-0x2]
1000511f:	80 cc 0c             	or     ah,0xc
10005122:	66 89 45 fc          	mov    WORD PTR [ebp-0x4],ax
10005126:	d9 6d fc             	fldcw  WORD PTR [ebp-0x4]
10005129:	df 7d f4             	fistp  QWORD PTR [ebp-0xc]
1000512c:	d9 6d fe             	fldcw  WORD PTR [ebp-0x2]
1000512f:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
10005132:	8b 55 f8             	mov    edx,DWORD PTR [ebp-0x8]
10005135:	c9                   	leave
10005136:	c3                   	ret
10005137:	e8 13 00 00 00       	call   0x1000514f
1000513c:	e8 85 08 00 00       	call   0x100059c6
10005141:	a3 14 f6 00 10       	mov    ds:0x1000f614,eax
10005146:	e8 2b 08 00 00       	call   0x10005976
1000514b:	db e2                	fnclex
1000514d:	c3                   	ret
1000514e:	c3                   	ret
1000514f:	b8 b4 5d 00 10       	mov    eax,0x10005db4
10005154:	c7 05 58 ea 00 10 49 	mov    DWORD PTR ds:0x1000ea58,0x10005a49
1000515b:	5a 00 10 
1000515e:	a3 54 ea 00 10       	mov    ds:0x1000ea54,eax
10005163:	c7 05 5c ea 00 10 af 	mov    DWORD PTR ds:0x1000ea5c,0x10005aaf
1000516a:	5a 00 10 
1000516d:	c7 05 60 ea 00 10 ef 	mov    DWORD PTR ds:0x1000ea60,0x100059ef
10005174:	59 00 10 
10005177:	c7 05 64 ea 00 10 97 	mov    DWORD PTR ds:0x1000ea64,0x10005a97
1000517e:	5a 00 10 
10005181:	a3 68 ea 00 10       	mov    ds:0x1000ea68,eax
10005186:	c3                   	ret
10005187:	8b 4c 24 04          	mov    ecx,DWORD PTR [esp+0x4]
1000518b:	a1 10 f6 00 10       	mov    eax,ds:0x1000f610
10005190:	89 0d 10 f6 00 10    	mov    DWORD PTR ds:0x1000f610,ecx
10005196:	c3                   	ret
10005197:	ff 74 24 04          	push   DWORD PTR [esp+0x4]
1000519b:	e8 8a 0c 00 00       	call   0x10005e2a
100051a0:	59                   	pop    ecx
100051a1:	c3                   	ret
100051a2:	6a 01                	push   0x1
100051a4:	ff 74 24 08          	push   DWORD PTR [esp+0x8]
100051a8:	e8 be 0c 00 00       	call   0x10005e6b
100051ad:	59                   	pop    ecx
100051ae:	59                   	pop    ecx
100051af:	c3                   	ret
100051b0:	55                   	push   ebp
100051b1:	8b ec                	mov    ebp,esp
100051b3:	83 ec 20             	sub    esp,0x20
100051b6:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100051b9:	56                   	push   esi
100051ba:	89 45 e8             	mov    DWORD PTR [ebp-0x18],eax
100051bd:	89 45 e0             	mov    DWORD PTR [ebp-0x20],eax
100051c0:	8d 45 10             	lea    eax,[ebp+0x10]
100051c3:	c7 45 ec 42 00 00 00 	mov    DWORD PTR [ebp-0x14],0x42
100051ca:	50                   	push   eax
100051cb:	8d 45 e0             	lea    eax,[ebp-0x20]
100051ce:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
100051d1:	c7 45 e4 ff ff ff 7f 	mov    DWORD PTR [ebp-0x1c],0x7fffffff
100051d8:	50                   	push   eax
100051d9:	e8 04 0e 00 00       	call   0x10005fe2
100051de:	83 c4 0c             	add    esp,0xc
100051e1:	ff 4d e4             	dec    DWORD PTR [ebp-0x1c]
100051e4:	8b f0                	mov    esi,eax
100051e6:	78 08                	js     0x100051f0
100051e8:	8b 45 e0             	mov    eax,DWORD PTR [ebp-0x20]
100051eb:	80 20 00             	and    BYTE PTR [eax],0x0
100051ee:	eb 0d                	jmp    0x100051fd
100051f0:	8d 45 e0             	lea    eax,[ebp-0x20]
100051f3:	50                   	push   eax
100051f4:	6a 00                	push   0x0
100051f6:	e8 d2 0c 00 00       	call   0x10005ecd
100051fb:	59                   	pop    ecx
100051fc:	59                   	pop    ecx
100051fd:	8b c6                	mov    eax,esi
100051ff:	5e                   	pop    esi
10005200:	c9                   	leave
10005201:	c3                   	ret
10005202:	55                   	push   ebp
10005203:	8b ec                	mov    ebp,esp
10005205:	51                   	push   ecx
10005206:	53                   	push   ebx
10005207:	56                   	push   esi
10005208:	57                   	push   edi
10005209:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
1000520c:	83 c0 0c             	add    eax,0xc
1000520f:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
10005212:	64 8b 1d 00 00 00 00 	mov    ebx,DWORD PTR fs:0x0
10005219:	8b 03                	mov    eax,DWORD PTR [ebx]
1000521b:	64 a3 00 00 00 00    	mov    fs:0x0,eax
10005221:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10005224:	8b 5d 0c             	mov    ebx,DWORD PTR [ebp+0xc]
10005227:	8b 63 fc             	mov    esp,DWORD PTR [ebx-0x4]
1000522a:	8b 6d fc             	mov    ebp,DWORD PTR [ebp-0x4]
1000522d:	ff e0                	jmp    eax
1000522f:	5f                   	pop    edi
10005230:	5e                   	pop    esi
10005231:	5b                   	pop    ebx
10005232:	c9                   	leave
10005233:	c2 08 00             	ret    0x8
10005236:	58                   	pop    eax
10005237:	59                   	pop    ecx
10005238:	87 04 24             	xchg   DWORD PTR [esp],eax
1000523b:	ff e0                	jmp    eax
1000523d:	58                   	pop    eax
1000523e:	59                   	pop    ecx
1000523f:	87 04 24             	xchg   DWORD PTR [esp],eax
10005242:	ff e0                	jmp    eax
10005244:	58                   	pop    eax
10005245:	59                   	pop    ecx
10005246:	87 04 24             	xchg   DWORD PTR [esp],eax
10005249:	ff e0                	jmp    eax
1000524b:	55                   	push   ebp
1000524c:	8b ec                	mov    ebp,esp
1000524e:	51                   	push   ecx
1000524f:	51                   	push   ecx
10005250:	53                   	push   ebx
10005251:	56                   	push   esi
10005252:	57                   	push   edi
10005253:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10005259:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
1000525c:	c7 45 fc 73 52 00 10 	mov    DWORD PTR [ebp-0x4],0x10005273
10005263:	6a 00                	push   0x0
10005265:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
10005268:	ff 75 fc             	push   DWORD PTR [ebp-0x4]
1000526b:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000526e:	e8 2d 70 00 00       	call   0x1000c2a0
10005273:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10005276:	8b 40 04             	mov    eax,DWORD PTR [eax+0x4]
10005279:	24 fd                	and    al,0xfd
1000527b:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
1000527e:	89 41 04             	mov    DWORD PTR [ecx+0x4],eax
10005281:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10005287:	8b 5d f8             	mov    ebx,DWORD PTR [ebp-0x8]
1000528a:	89 03                	mov    DWORD PTR [ebx],eax
1000528c:	64 89 1d 00 00 00 00 	mov    DWORD PTR fs:0x0,ebx
10005293:	5f                   	pop    edi
10005294:	5e                   	pop    esi
10005295:	5b                   	pop    ebx
10005296:	c9                   	leave
10005297:	c2 08 00             	ret    0x8
1000529a:	55                   	push   ebp
1000529b:	8b ec                	mov    ebp,esp
1000529d:	83 ec 04             	sub    esp,0x4
100052a0:	53                   	push   ebx
100052a1:	56                   	push   esi
100052a2:	57                   	push   edi
100052a3:	fc                   	cld
100052a4:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
100052a7:	33 c0                	xor    eax,eax
100052a9:	50                   	push   eax
100052aa:	50                   	push   eax
100052ab:	50                   	push   eax
100052ac:	ff 75 fc             	push   DWORD PTR [ebp-0x4]
100052af:	ff 75 14             	push   DWORD PTR [ebp+0x14]
100052b2:	ff 75 10             	push   DWORD PTR [ebp+0x10]
100052b5:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
100052b8:	ff 75 08             	push   DWORD PTR [ebp+0x8]
100052bb:	e8 2c 15 00 00       	call   0x100067ec
100052c0:	83 c4 20             	add    esp,0x20
100052c3:	89 45 14             	mov    DWORD PTR [ebp+0x14],eax
100052c6:	5f                   	pop    edi
100052c7:	5e                   	pop    esi
100052c8:	5b                   	pop    ebx
100052c9:	8b 45 14             	mov    eax,DWORD PTR [ebp+0x14]
100052cc:	8b e5                	mov    esp,ebp
100052ce:	5d                   	pop    ebp
100052cf:	c3                   	ret
100052d0:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
100052d4:	ff 70 1c             	push   DWORD PTR [eax+0x1c]
100052d7:	ff 70 28             	push   DWORD PTR [eax+0x28]
100052da:	6a 00                	push   0x0
100052dc:	ff 70 18             	push   DWORD PTR [eax+0x18]
100052df:	e8 4f 18 00 00       	call   0x10006b33
100052e4:	83 c4 10             	add    esp,0x10
100052e7:	c2 04 00             	ret    0x4
100052ea:	55                   	push   ebp
100052eb:	8b ec                	mov    ebp,esp
100052ed:	83 ec 14             	sub    esp,0x14
100052f0:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
100052f3:	83 65 ec 00          	and    DWORD PTR [ebp-0x14],0x0
100052f7:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
100052fa:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax
100052fd:	8b 45 14             	mov    eax,DWORD PTR [ebp+0x14]
10005300:	c7 45 f0 3e 53 00 10 	mov    DWORD PTR [ebp-0x10],0x1000533e
10005307:	40                   	inc    eax
10005308:	89 4d f8             	mov    DWORD PTR [ebp-0x8],ecx
1000530b:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
1000530e:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10005314:	89 45 ec             	mov    DWORD PTR [ebp-0x14],eax
10005317:	8d 85 ec ff ff ff    	lea    eax,[ebp-0x14]
1000531d:	64 a3 00 00 00 00    	mov    fs:0x0,eax
10005323:	ff 75 18             	push   DWORD PTR [ebp+0x18]
10005326:	51                   	push   ecx
10005327:	ff 75 10             	push   DWORD PTR [ebp+0x10]
1000532a:	e8 c1 1c 00 00       	call   0x10006ff0
1000532f:	8b c8                	mov    ecx,eax
10005331:	8b 45 ec             	mov    eax,DWORD PTR [ebp-0x14]
10005334:	64 a3 00 00 00 00    	mov    fs:0x0,eax
1000533a:	8b c1                	mov    eax,ecx
1000533c:	c9                   	leave
1000533d:	c3                   	ret
1000533e:	55                   	push   ebp
1000533f:	8b ec                	mov    ebp,esp
10005341:	fc                   	cld
10005342:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10005345:	6a 00                	push   0x0
10005347:	50                   	push   eax
10005348:	ff 70 10             	push   DWORD PTR [eax+0x10]
1000534b:	ff 70 08             	push   DWORD PTR [eax+0x8]
1000534e:	6a 00                	push   0x0
10005350:	ff 75 10             	push   DWORD PTR [ebp+0x10]
10005353:	ff 70 0c             	push   DWORD PTR [eax+0xc]
10005356:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10005359:	e8 8e 14 00 00       	call   0x100067ec
1000535e:	83 c4 20             	add    esp,0x20
10005361:	5d                   	pop    ebp
10005362:	c3                   	ret
10005363:	55                   	push   ebp
10005364:	8b ec                	mov    ebp,esp
10005366:	83 ec 34             	sub    esp,0x34
10005369:	53                   	push   ebx
1000536a:	56                   	push   esi
1000536b:	57                   	push   edi
1000536c:	83 65 d8 00          	and    DWORD PTR [ebp-0x28],0x0
10005370:	c7 45 dc 17 54 00 10 	mov    DWORD PTR [ebp-0x24],0x10005417
10005377:	8b 45 18             	mov    eax,DWORD PTR [ebp+0x18]
1000537a:	89 45 e0             	mov    DWORD PTR [ebp-0x20],eax
1000537d:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10005380:	89 45 e4             	mov    DWORD PTR [ebp-0x1c],eax
10005383:	8b 45 1c             	mov    eax,DWORD PTR [ebp+0x1c]
10005386:	89 45 e8             	mov    DWORD PTR [ebp-0x18],eax
10005389:	8b 45 20             	mov    eax,DWORD PTR [ebp+0x20]
1000538c:	89 45 ec             	mov    DWORD PTR [ebp-0x14],eax
1000538f:	83 65 f0 00          	and    DWORD PTR [ebp-0x10],0x0
10005393:	83 65 f4 00          	and    DWORD PTR [ebp-0xc],0x0
10005397:	83 65 f8 00          	and    DWORD PTR [ebp-0x8],0x0
1000539b:	83 65 fc 00          	and    DWORD PTR [ebp-0x4],0x0
1000539f:	c7 45 f0 e9 53 00 10 	mov    DWORD PTR [ebp-0x10],0x100053e9
100053a6:	89 65 f4             	mov    DWORD PTR [ebp-0xc],esp
100053a9:	89 6d f8             	mov    DWORD PTR [ebp-0x8],ebp
100053ac:	64 a1 00 00 00 00    	mov    eax,fs:0x0
100053b2:	89 45 d8             	mov    DWORD PTR [ebp-0x28],eax
100053b5:	8d 85 d8 ff ff ff    	lea    eax,[ebp-0x28]
100053bb:	64 a3 00 00 00 00    	mov    fs:0x0,eax
100053c1:	c7 45 cc 01 00 00 00 	mov    DWORD PTR [ebp-0x34],0x1
100053c8:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100053cb:	89 45 d0             	mov    DWORD PTR [ebp-0x30],eax
100053ce:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
100053d1:	89 45 d4             	mov    DWORD PTR [ebp-0x2c],eax
100053d4:	8d 45 d0             	lea    eax,[ebp-0x30]
100053d7:	50                   	push   eax
100053d8:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100053db:	ff 30                	push   DWORD PTR [eax]
100053dd:	ff 15 44 f6 00 10    	call   DWORD PTR ds:0x1000f644
100053e3:	59                   	pop    ecx
100053e4:	59                   	pop    ecx
100053e5:	83 65 cc 00          	and    DWORD PTR [ebp-0x34],0x0
100053e9:	83 7d fc 00          	cmp    DWORD PTR [ebp-0x4],0x0
100053ed:	74 17                	je     0x10005406
100053ef:	64 8b 1d 00 00 00 00 	mov    ebx,DWORD PTR fs:0x0
100053f6:	8b 03                	mov    eax,DWORD PTR [ebx]
100053f8:	8b 5d d8             	mov    ebx,DWORD PTR [ebp-0x28]
100053fb:	89 03                	mov    DWORD PTR [ebx],eax
100053fd:	64 89 1d 00 00 00 00 	mov    DWORD PTR fs:0x0,ebx
10005404:	eb 09                	jmp    0x1000540f
10005406:	8b 45 d8             	mov    eax,DWORD PTR [ebp-0x28]
10005409:	64 a3 00 00 00 00    	mov    fs:0x0,eax
1000540f:	8b 45 cc             	mov    eax,DWORD PTR [ebp-0x34]
10005412:	5f                   	pop    edi
10005413:	5e                   	pop    esi
10005414:	5b                   	pop    ebx
10005415:	c9                   	leave
10005416:	c3                   	ret
10005417:	55                   	push   ebp
10005418:	8b ec                	mov    ebp,esp
1000541a:	53                   	push   ebx
1000541b:	56                   	push   esi
1000541c:	57                   	push   edi
1000541d:	fc                   	cld
1000541e:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10005421:	8b 40 04             	mov    eax,DWORD PTR [eax+0x4]
10005424:	83 e0 66             	and    eax,0x66
10005427:	85 c0                	test   eax,eax
10005429:	74 0f                	je     0x1000543a
1000542b:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
1000542e:	c7 40 24 01 00 00 00 	mov    DWORD PTR [eax+0x24],0x1
10005435:	6a 01                	push   0x1
10005437:	58                   	pop    eax
10005438:	eb 4d                	jmp    0x10005487
1000543a:	6a 01                	push   0x1
1000543c:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
1000543f:	ff 70 14             	push   DWORD PTR [eax+0x14]
10005442:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10005445:	ff 70 10             	push   DWORD PTR [eax+0x10]
10005448:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
1000544b:	ff 70 08             	push   DWORD PTR [eax+0x8]
1000544e:	6a 00                	push   0x0
10005450:	ff 75 10             	push   DWORD PTR [ebp+0x10]
10005453:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10005456:	ff 70 0c             	push   DWORD PTR [eax+0xc]
10005459:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000545c:	e8 8b 13 00 00       	call   0x100067ec
10005461:	83 c4 20             	add    esp,0x20
10005464:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10005467:	83 78 24 00          	cmp    DWORD PTR [eax+0x24],0x0
1000546b:	75 0b                	jne    0x10005478
1000546d:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10005470:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
10005473:	e8 d3 fd ff ff       	call   0x1000524b
10005478:	8b 5d 0c             	mov    ebx,DWORD PTR [ebp+0xc]
1000547b:	8b 63 1c             	mov    esp,DWORD PTR [ebx+0x1c]
1000547e:	8b 6b 20             	mov    ebp,DWORD PTR [ebx+0x20]
10005481:	ff 63 18             	jmp    DWORD PTR [ebx+0x18]
10005484:	6a 01                	push   0x1
10005486:	58                   	pop    eax
10005487:	5f                   	pop    edi
10005488:	5e                   	pop    esi
10005489:	5b                   	pop    ebx
1000548a:	5d                   	pop    ebp
1000548b:	c3                   	ret
1000548c:	55                   	push   ebp
1000548d:	8b ec                	mov    ebp,esp
1000548f:	51                   	push   ecx
10005490:	53                   	push   ebx
10005491:	56                   	push   esi
10005492:	83 7d 0c 00          	cmp    DWORD PTR [ebp+0xc],0x0
10005496:	57                   	push   edi
10005497:	8b 7d 08             	mov    edi,DWORD PTR [ebp+0x8]
1000549a:	8b 77 0c             	mov    esi,DWORD PTR [edi+0xc]
1000549d:	8b 5f 10             	mov    ebx,DWORD PTR [edi+0x10]
100054a0:	8b c6                	mov    eax,esi
100054a2:	89 75 08             	mov    DWORD PTR [ebp+0x8],esi
100054a5:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
100054a8:	7c 39                	jl     0x100054e3
100054aa:	83 fe ff             	cmp    esi,0xffffffff
100054ad:	75 05                	jne    0x100054b4
100054af:	e8 ee 1b 00 00       	call   0x100070a2
100054b4:	8b 4d 10             	mov    ecx,DWORD PTR [ebp+0x10]
100054b7:	4e                   	dec    esi
100054b8:	8d 04 b6             	lea    eax,[esi+esi*4]
100054bb:	39 4c 83 04          	cmp    DWORD PTR [ebx+eax*4+0x4],ecx
100054bf:	8d 04 83             	lea    eax,[ebx+eax*4]
100054c2:	7d 05                	jge    0x100054c9
100054c4:	3b 48 08             	cmp    ecx,DWORD PTR [eax+0x8]
100054c7:	7e 05                	jle    0x100054ce
100054c9:	83 fe ff             	cmp    esi,0xffffffff
100054cc:	75 0c                	jne    0x100054da
100054ce:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100054d1:	ff 4d 0c             	dec    DWORD PTR [ebp+0xc]
100054d4:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
100054d7:	89 75 08             	mov    DWORD PTR [ebp+0x8],esi
100054da:	83 7d 0c 00          	cmp    DWORD PTR [ebp+0xc],0x0
100054de:	7d ca                	jge    0x100054aa
100054e0:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
100054e3:	8b 4d 14             	mov    ecx,DWORD PTR [ebp+0x14]
100054e6:	46                   	inc    esi
100054e7:	89 31                	mov    DWORD PTR [ecx],esi
100054e9:	8b 4d 18             	mov    ecx,DWORD PTR [ebp+0x18]
100054ec:	89 01                	mov    DWORD PTR [ecx],eax
100054ee:	3b 47 0c             	cmp    eax,DWORD PTR [edi+0xc]
100054f1:	77 04                	ja     0x100054f7
100054f3:	3b f0                	cmp    esi,eax
100054f5:	76 05                	jbe    0x100054fc
100054f7:	e8 a6 1b 00 00       	call   0x100070a2
100054fc:	8d 04 b6             	lea    eax,[esi+esi*4]
100054ff:	5f                   	pop    edi
10005500:	5e                   	pop    esi
10005501:	8d 04 83             	lea    eax,[ebx+eax*4]
10005504:	5b                   	pop    ebx
10005505:	c9                   	leave
10005506:	c3                   	ret
10005507:	cc                   	int3
10005508:	55                   	push   ebp
10005509:	8b ec                	mov    ebp,esp
1000550b:	53                   	push   ebx
1000550c:	56                   	push   esi
1000550d:	57                   	push   edi
1000550e:	55                   	push   ebp
1000550f:	6a 00                	push   0x0
10005511:	6a 00                	push   0x0
10005513:	68 20 55 00 10       	push   0x10005520
10005518:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000551b:	e8 80 6d 00 00       	call   0x1000c2a0
10005520:	5d                   	pop    ebp
10005521:	5f                   	pop    edi
10005522:	5e                   	pop    esi
10005523:	5b                   	pop    ebx
10005524:	8b e5                	mov    esp,ebp
10005526:	5d                   	pop    ebp
10005527:	c3                   	ret
10005528:	8b 4c 24 04          	mov    ecx,DWORD PTR [esp+0x4]
1000552c:	f7 41 04 06 00 00 00 	test   DWORD PTR [ecx+0x4],0x6
10005533:	b8 01 00 00 00       	mov    eax,0x1
10005538:	74 0f                	je     0x10005549
1000553a:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
1000553e:	8b 54 24 10          	mov    edx,DWORD PTR [esp+0x10]
10005542:	89 02                	mov    DWORD PTR [edx],eax
10005544:	b8 03 00 00 00       	mov    eax,0x3
10005549:	c3                   	ret
1000554a:	53                   	push   ebx
1000554b:	56                   	push   esi
1000554c:	57                   	push   edi
1000554d:	8b 44 24 10          	mov    eax,DWORD PTR [esp+0x10]
10005551:	50                   	push   eax
10005552:	6a fe                	push   0xfffffffe
10005554:	68 28 55 00 10       	push   0x10005528
10005559:	64 ff 35 00 00 00 00 	push   DWORD PTR fs:0x0
10005560:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10005567:	8b 44 24 20          	mov    eax,DWORD PTR [esp+0x20]
1000556b:	8b 58 08             	mov    ebx,DWORD PTR [eax+0x8]
1000556e:	8b 70 0c             	mov    esi,DWORD PTR [eax+0xc]
10005571:	83 fe ff             	cmp    esi,0xffffffff
10005574:	74 2e                	je     0x100055a4
10005576:	3b 74 24 24          	cmp    esi,DWORD PTR [esp+0x24]
1000557a:	74 28                	je     0x100055a4
1000557c:	8d 34 76             	lea    esi,[esi+esi*2]
1000557f:	8b 0c b3             	mov    ecx,DWORD PTR [ebx+esi*4]
10005582:	89 4c 24 08          	mov    DWORD PTR [esp+0x8],ecx
10005586:	89 48 0c             	mov    DWORD PTR [eax+0xc],ecx
10005589:	83 7c b3 04 00       	cmp    DWORD PTR [ebx+esi*4+0x4],0x0
1000558e:	75 12                	jne    0x100055a2
10005590:	68 01 01 00 00       	push   0x101
10005595:	8b 44 b3 08          	mov    eax,DWORD PTR [ebx+esi*4+0x8]
10005599:	e8 40 00 00 00       	call   0x100055de
1000559e:	ff 54 b3 08          	call   DWORD PTR [ebx+esi*4+0x8]
100055a2:	eb c3                	jmp    0x10005567
100055a4:	64 8f 05 00 00 00 00 	pop    DWORD PTR fs:0x0
100055ab:	83 c4 0c             	add    esp,0xc
100055ae:	5f                   	pop    edi
100055af:	5e                   	pop    esi
100055b0:	5b                   	pop    ebx
100055b1:	c3                   	ret
100055b2:	33 c0                	xor    eax,eax
100055b4:	64 8b 0d 00 00 00 00 	mov    ecx,DWORD PTR fs:0x0
100055bb:	81 79 04 28 55 00 10 	cmp    DWORD PTR [ecx+0x4],0x10005528
100055c2:	75 10                	jne    0x100055d4
100055c4:	8b 51 0c             	mov    edx,DWORD PTR [ecx+0xc]
100055c7:	8b 52 0c             	mov    edx,DWORD PTR [edx+0xc]
100055ca:	39 51 08             	cmp    DWORD PTR [ecx+0x8],edx
100055cd:	75 05                	jne    0x100055d4
100055cf:	b8 01 00 00 00       	mov    eax,0x1
100055d4:	c3                   	ret
100055d5:	53                   	push   ebx
100055d6:	51                   	push   ecx
100055d7:	bb 2c ea 00 10       	mov    ebx,0x1000ea2c
100055dc:	eb 0a                	jmp    0x100055e8
100055de:	53                   	push   ebx
100055df:	51                   	push   ecx
100055e0:	bb 2c ea 00 10       	mov    ebx,0x1000ea2c
100055e5:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
100055e8:	89 4b 08             	mov    DWORD PTR [ebx+0x8],ecx
100055eb:	89 43 04             	mov    DWORD PTR [ebx+0x4],eax
100055ee:	89 6b 0c             	mov    DWORD PTR [ebx+0xc],ebp
100055f1:	59                   	pop    ecx
100055f2:	5b                   	pop    ebx
100055f3:	c2 04 00             	ret    0x4
100055f6:	cc                   	int3
100055f7:	cc                   	int3
100055f8:	cc                   	int3
100055f9:	cc                   	int3
100055fa:	cc                   	int3
100055fb:	cc                   	int3
100055fc:	cc                   	int3
100055fd:	cc                   	int3
100055fe:	cc                   	int3
100055ff:	cc                   	int3
10005600:	51                   	push   ecx
10005601:	3d 00 10 00 00       	cmp    eax,0x1000
10005606:	8d 4c 24 08          	lea    ecx,[esp+0x8]
1000560a:	72 14                	jb     0x10005620
1000560c:	81 e9 00 10 00 00    	sub    ecx,0x1000
10005612:	2d 00 10 00 00       	sub    eax,0x1000
10005617:	85 01                	test   DWORD PTR [ecx],eax
10005619:	3d 00 10 00 00       	cmp    eax,0x1000
1000561e:	73 ec                	jae    0x1000560c
10005620:	2b c8                	sub    ecx,eax
10005622:	8b c4                	mov    eax,esp
10005624:	85 01                	test   DWORD PTR [ecx],eax
10005626:	8b e1                	mov    esp,ecx
10005628:	8b 08                	mov    ecx,DWORD PTR [eax]
1000562a:	8b 40 04             	mov    eax,DWORD PTR [eax+0x4]
1000562d:	50                   	push   eax
1000562e:	c3                   	ret
1000562f:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
10005633:	a3 40 ea 00 10       	mov    ds:0x1000ea40,eax
10005638:	c3                   	ret
10005639:	a1 40 ea 00 10       	mov    eax,ds:0x1000ea40
1000563e:	69 c0 fd 43 03 00    	imul   eax,eax,0x343fd
10005644:	05 c3 9e 26 00       	add    eax,0x269ec3
10005649:	a3 40 ea 00 10       	mov    ds:0x1000ea40,eax
1000564e:	c1 f8 10             	sar    eax,0x10
10005651:	25 ff 7f 00 00       	and    eax,0x7fff
10005656:	c3                   	ret
10005657:	53                   	push   ebx
10005658:	55                   	push   ebp
10005659:	56                   	push   esi
1000565a:	57                   	push   edi
1000565b:	8b 7c 24 14          	mov    edi,DWORD PTR [esp+0x14]
1000565f:	83 3d 94 ec 00 10 01 	cmp    DWORD PTR ds:0x1000ec94,0x1
10005666:	7e 0f                	jle    0x10005677
10005668:	0f b6 07             	movzx  eax,BYTE PTR [edi]
1000566b:	6a 08                	push   0x8
1000566d:	50                   	push   eax
1000566e:	e8 85 1a 00 00       	call   0x100070f8
10005673:	59                   	pop    ecx
10005674:	59                   	pop    ecx
10005675:	eb 0f                	jmp    0x10005686
10005677:	0f b6 07             	movzx  eax,BYTE PTR [edi]
1000567a:	8b 0d 88 ea 00 10    	mov    ecx,DWORD PTR ds:0x1000ea88
10005680:	8a 04 41             	mov    al,BYTE PTR [ecx+eax*2]
10005683:	83 e0 08             	and    eax,0x8
10005686:	85 c0                	test   eax,eax
10005688:	74 03                	je     0x1000568d
1000568a:	47                   	inc    edi
1000568b:	eb d2                	jmp    0x1000565f
1000568d:	0f b6 37             	movzx  esi,BYTE PTR [edi]
10005690:	47                   	inc    edi
10005691:	83 fe 2d             	cmp    esi,0x2d
10005694:	8b ee                	mov    ebp,esi
10005696:	74 05                	je     0x1000569d
10005698:	83 fe 2b             	cmp    esi,0x2b
1000569b:	75 04                	jne    0x100056a1
1000569d:	0f b6 37             	movzx  esi,BYTE PTR [edi]
100056a0:	47                   	inc    edi
100056a1:	33 db                	xor    ebx,ebx
100056a3:	83 3d 94 ec 00 10 01 	cmp    DWORD PTR ds:0x1000ec94,0x1
100056aa:	7e 0c                	jle    0x100056b8
100056ac:	6a 04                	push   0x4
100056ae:	56                   	push   esi
100056af:	e8 44 1a 00 00       	call   0x100070f8
100056b4:	59                   	pop    ecx
100056b5:	59                   	pop    ecx
100056b6:	eb 0b                	jmp    0x100056c3
100056b8:	a1 88 ea 00 10       	mov    eax,ds:0x1000ea88
100056bd:	8a 04 70             	mov    al,BYTE PTR [eax+esi*2]
100056c0:	83 e0 04             	and    eax,0x4
100056c3:	85 c0                	test   eax,eax
100056c5:	74 0d                	je     0x100056d4
100056c7:	8d 04 9b             	lea    eax,[ebx+ebx*4]
100056ca:	8d 5c 46 d0          	lea    ebx,[esi+eax*2-0x30]
100056ce:	0f b6 37             	movzx  esi,BYTE PTR [edi]
100056d1:	47                   	inc    edi
100056d2:	eb cf                	jmp    0x100056a3
100056d4:	83 fd 2d             	cmp    ebp,0x2d
100056d7:	8b c3                	mov    eax,ebx
100056d9:	75 02                	jne    0x100056dd
100056db:	f7 d8                	neg    eax
100056dd:	5f                   	pop    edi
100056de:	5e                   	pop    esi
100056df:	5d                   	pop    ebp
100056e0:	5b                   	pop    ebx
100056e1:	c3                   	ret
100056e2:	ff 74 24 04          	push   DWORD PTR [esp+0x4]
100056e6:	e8 6c ff ff ff       	call   0x10005657
100056eb:	59                   	pop    ecx
100056ec:	c3                   	ret
100056ed:	51                   	push   ecx
100056ee:	53                   	push   ebx
100056ef:	55                   	push   ebp
100056f0:	56                   	push   esi
100056f1:	57                   	push   edi
100056f2:	8b 7c 24 18          	mov    edi,DWORD PTR [esp+0x18]
100056f6:	83 3d 94 ec 00 10 01 	cmp    DWORD PTR ds:0x1000ec94,0x1
100056fd:	7e 0f                	jle    0x1000570e
100056ff:	0f b6 07             	movzx  eax,BYTE PTR [edi]
10005702:	6a 08                	push   0x8
10005704:	50                   	push   eax
10005705:	e8 ee 19 00 00       	call   0x100070f8
1000570a:	59                   	pop    ecx
1000570b:	59                   	pop    ecx
1000570c:	eb 0f                	jmp    0x1000571d
1000570e:	0f b6 07             	movzx  eax,BYTE PTR [edi]
10005711:	8b 0d 88 ea 00 10    	mov    ecx,DWORD PTR ds:0x1000ea88
10005717:	8a 04 41             	mov    al,BYTE PTR [ecx+eax*2]
1000571a:	83 e0 08             	and    eax,0x8
1000571d:	85 c0                	test   eax,eax
1000571f:	74 03                	je     0x10005724
10005721:	47                   	inc    edi
10005722:	eb d2                	jmp    0x100056f6
10005724:	0f b6 37             	movzx  esi,BYTE PTR [edi]
10005727:	47                   	inc    edi
10005728:	83 fe 2d             	cmp    esi,0x2d
1000572b:	89 74 24 10          	mov    DWORD PTR [esp+0x10],esi
1000572f:	74 05                	je     0x10005736
10005731:	83 fe 2b             	cmp    esi,0x2b
10005734:	75 04                	jne    0x1000573a
10005736:	0f b6 37             	movzx  esi,BYTE PTR [edi]
10005739:	47                   	inc    edi
1000573a:	33 db                	xor    ebx,ebx
1000573c:	33 ed                	xor    ebp,ebp
1000573e:	83 3d 94 ec 00 10 01 	cmp    DWORD PTR ds:0x1000ec94,0x1
10005745:	7e 0c                	jle    0x10005753
10005747:	6a 04                	push   0x4
10005749:	56                   	push   esi
1000574a:	e8 a9 19 00 00       	call   0x100070f8
1000574f:	59                   	pop    ecx
10005750:	59                   	pop    ecx
10005751:	eb 0b                	jmp    0x1000575e
10005753:	a1 88 ea 00 10       	mov    eax,ds:0x1000ea88
10005758:	8a 04 70             	mov    al,BYTE PTR [eax+esi*2]
1000575b:	83 e0 04             	and    eax,0x4
1000575e:	85 c0                	test   eax,eax
10005760:	74 29                	je     0x1000578b
10005762:	8d 46 d0             	lea    eax,[esi-0x30]
10005765:	6a 00                	push   0x0
10005767:	99                   	cdq
10005768:	8b f0                	mov    esi,eax
1000576a:	6a 0a                	push   0xa
1000576c:	55                   	push   ebp
1000576d:	89 74 24 24          	mov    DWORD PTR [esp+0x24],esi
10005771:	53                   	push   ebx
10005772:	8b f2                	mov    esi,edx
10005774:	e8 f7 19 00 00       	call   0x10007170
10005779:	8b 4c 24 18          	mov    ecx,DWORD PTR [esp+0x18]
1000577d:	03 c8                	add    ecx,eax
1000577f:	13 f2                	adc    esi,edx
10005781:	8b d9                	mov    ebx,ecx
10005783:	8b ee                	mov    ebp,esi
10005785:	0f b6 37             	movzx  esi,BYTE PTR [edi]
10005788:	47                   	inc    edi
10005789:	eb b3                	jmp    0x1000573e
1000578b:	83 7c 24 10 2d       	cmp    DWORD PTR [esp+0x10],0x2d
10005790:	8b c3                	mov    eax,ebx
10005792:	75 0b                	jne    0x1000579f
10005794:	f7 d8                	neg    eax
10005796:	8b d5                	mov    edx,ebp
10005798:	83 d2 00             	adc    edx,0x0
1000579b:	f7 da                	neg    edx
1000579d:	eb 02                	jmp    0x100057a1
1000579f:	8b d5                	mov    edx,ebp
100057a1:	5f                   	pop    edi
100057a2:	5e                   	pop    esi
100057a3:	5d                   	pop    ebp
100057a4:	5b                   	pop    ebx
100057a5:	59                   	pop    ecx
100057a6:	c3                   	ret
100057a7:	cc                   	int3
100057a8:	cc                   	int3
100057a9:	cc                   	int3
100057aa:	cc                   	int3
100057ab:	cc                   	int3
100057ac:	cc                   	int3
100057ad:	cc                   	int3
100057ae:	cc                   	int3
100057af:	cc                   	int3
100057b0:	55                   	push   ebp
100057b1:	8b ec                	mov    ebp,esp
100057b3:	56                   	push   esi
100057b4:	33 c0                	xor    eax,eax
100057b6:	50                   	push   eax
100057b7:	50                   	push   eax
100057b8:	50                   	push   eax
100057b9:	50                   	push   eax
100057ba:	50                   	push   eax
100057bb:	50                   	push   eax
100057bc:	50                   	push   eax
100057bd:	50                   	push   eax
100057be:	8b 55 0c             	mov    edx,DWORD PTR [ebp+0xc]
100057c1:	8d 49 00             	lea    ecx,[ecx+0x0]
100057c4:	8a 02                	mov    al,BYTE PTR [edx]
100057c6:	0a c0                	or     al,al
100057c8:	74 07                	je     0x100057d1
100057ca:	42                   	inc    edx
100057cb:	0f ab 04 24          	bts    DWORD PTR [esp],eax
100057cf:	eb f3                	jmp    0x100057c4
100057d1:	8b 75 08             	mov    esi,DWORD PTR [ebp+0x8]
100057d4:	83 c9 ff             	or     ecx,0xffffffff
100057d7:	90                   	nop
100057d8:	41                   	inc    ecx
100057d9:	8a 06                	mov    al,BYTE PTR [esi]
100057db:	0a c0                	or     al,al
100057dd:	74 07                	je     0x100057e6
100057df:	46                   	inc    esi
100057e0:	0f a3 04 24          	bt     DWORD PTR [esp],eax
100057e4:	73 f2                	jae    0x100057d8
100057e6:	8b c1                	mov    eax,ecx
100057e8:	83 c4 20             	add    esp,0x20
100057eb:	5e                   	pop    esi
100057ec:	c9                   	leave
100057ed:	c3                   	ret
100057ee:	83 7c 24 08 01       	cmp    DWORD PTR [esp+0x8],0x1
100057f3:	75 7e                	jne    0x10005873
100057f5:	ff 15 28 d0 00 10    	call   DWORD PTR ds:0x1000d028
100057fb:	6a 00                	push   0x0
100057fd:	a3 58 f6 00 10       	mov    ds:0x1000f658,eax
10005802:	e8 bd 1a 00 00       	call   0x100072c4
10005807:	85 c0                	test   eax,eax
10005809:	59                   	pop    ecx
1000580a:	0f 84 92 00 00 00    	je     0x100058a2
10005810:	a1 58 f6 00 10       	mov    eax,ds:0x1000f658
10005815:	33 c9                	xor    ecx,ecx
10005817:	8a 0d 59 f6 00 10    	mov    cl,BYTE PTR ds:0x1000f659
1000581d:	25 ff 00 00 00       	and    eax,0xff
10005822:	c1 2d 58 f6 00 10 10 	shr    DWORD PTR ds:0x1000f658,0x10
10005829:	a3 60 f6 00 10       	mov    ds:0x1000f660,eax
1000582e:	89 0d 64 f6 00 10    	mov    DWORD PTR ds:0x1000f664,ecx
10005834:	c1 e0 08             	shl    eax,0x8
10005837:	03 c1                	add    eax,ecx
10005839:	a3 5c f6 00 10       	mov    ds:0x1000f65c,eax
1000583e:	ff 15 24 d0 00 10    	call   DWORD PTR ds:0x1000d024
10005844:	a3 b8 0b 01 10       	mov    ds:0x10010bb8,eax
10005849:	e8 fb 1f 00 00       	call   0x10007849
1000584e:	a3 1c f6 00 10       	mov    ds:0x1000f61c,eax
10005853:	e8 1d 1b 00 00       	call   0x10007375
10005858:	e8 9f 1d 00 00       	call   0x100075fc
1000585d:	e8 e1 1c 00 00       	call   0x10007543
10005862:	e8 3d 19 00 00       	call   0x100071a4
10005867:	ff 05 18 f6 00 10    	inc    DWORD PTR ds:0x1000f618
1000586d:	6a 01                	push   0x1
1000586f:	58                   	pop    eax
10005870:	c2 0c 00             	ret    0xc
10005873:	33 c0                	xor    eax,eax
10005875:	39 44 24 08          	cmp    DWORD PTR [esp+0x8],eax
10005879:	75 f2                	jne    0x1000586d
1000587b:	39 05 18 f6 00 10    	cmp    DWORD PTR ds:0x1000f618,eax
10005881:	7e 1f                	jle    0x100058a2
10005883:	ff 0d 18 f6 00 10    	dec    DWORD PTR ds:0x1000f618
10005889:	39 05 90 f6 00 10    	cmp    DWORD PTR ds:0x1000f690,eax
1000588f:	75 05                	jne    0x10005896
10005891:	e8 5d 19 00 00       	call   0x100071f3
10005896:	e8 85 1c 00 00       	call   0x10007520
1000589b:	e8 60 1a 00 00       	call   0x10007300
100058a0:	eb cb                	jmp    0x1000586d
100058a2:	33 c0                	xor    eax,eax
100058a4:	eb ca                	jmp    0x10005870
100058a6:	55                   	push   ebp
100058a7:	8b ec                	mov    ebp,esp
100058a9:	53                   	push   ebx
100058aa:	8b 5d 08             	mov    ebx,DWORD PTR [ebp+0x8]
100058ad:	56                   	push   esi
100058ae:	8b 75 0c             	mov    esi,DWORD PTR [ebp+0xc]
100058b1:	57                   	push   edi
100058b2:	8b 7d 10             	mov    edi,DWORD PTR [ebp+0x10]
100058b5:	85 f6                	test   esi,esi
100058b7:	75 09                	jne    0x100058c2
100058b9:	83 3d 18 f6 00 10 00 	cmp    DWORD PTR ds:0x1000f618,0x0
100058c0:	eb 26                	jmp    0x100058e8
100058c2:	83 fe 01             	cmp    esi,0x1
100058c5:	74 05                	je     0x100058cc
100058c7:	83 fe 02             	cmp    esi,0x2
100058ca:	75 22                	jne    0x100058ee
100058cc:	a1 bc 0b 01 10       	mov    eax,ds:0x10010bbc
100058d1:	85 c0                	test   eax,eax
100058d3:	74 09                	je     0x100058de
100058d5:	57                   	push   edi
100058d6:	56                   	push   esi
100058d7:	53                   	push   ebx
100058d8:	ff d0                	call   eax
100058da:	85 c0                	test   eax,eax
100058dc:	74 0c                	je     0x100058ea
100058de:	57                   	push   edi
100058df:	56                   	push   esi
100058e0:	53                   	push   ebx
100058e1:	e8 08 ff ff ff       	call   0x100057ee
100058e6:	85 c0                	test   eax,eax
100058e8:	75 04                	jne    0x100058ee
100058ea:	33 c0                	xor    eax,eax
100058ec:	eb 4e                	jmp    0x1000593c
100058ee:	57                   	push   edi
100058ef:	56                   	push   esi
100058f0:	53                   	push   ebx
100058f1:	e8 7a f5 ff ff       	call   0x10004e70
100058f6:	83 fe 01             	cmp    esi,0x1
100058f9:	89 45 0c             	mov    DWORD PTR [ebp+0xc],eax
100058fc:	75 0c                	jne    0x1000590a
100058fe:	85 c0                	test   eax,eax
10005900:	75 37                	jne    0x10005939
10005902:	57                   	push   edi
10005903:	50                   	push   eax
10005904:	53                   	push   ebx
10005905:	e8 e4 fe ff ff       	call   0x100057ee
1000590a:	85 f6                	test   esi,esi
1000590c:	74 05                	je     0x10005913
1000590e:	83 fe 03             	cmp    esi,0x3
10005911:	75 26                	jne    0x10005939
10005913:	57                   	push   edi
10005914:	56                   	push   esi
10005915:	53                   	push   ebx
10005916:	e8 d3 fe ff ff       	call   0x100057ee
1000591b:	85 c0                	test   eax,eax
1000591d:	75 03                	jne    0x10005922
1000591f:	21 45 0c             	and    DWORD PTR [ebp+0xc],eax
10005922:	83 7d 0c 00          	cmp    DWORD PTR [ebp+0xc],0x0
10005926:	74 11                	je     0x10005939
10005928:	a1 bc 0b 01 10       	mov    eax,ds:0x10010bbc
1000592d:	85 c0                	test   eax,eax
1000592f:	74 08                	je     0x10005939
10005931:	57                   	push   edi
10005932:	56                   	push   esi
10005933:	53                   	push   ebx
10005934:	ff d0                	call   eax
10005936:	89 45 0c             	mov    DWORD PTR [ebp+0xc],eax
10005939:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
1000593c:	5f                   	pop    edi
1000593d:	5e                   	pop    esi
1000593e:	5b                   	pop    ebx
1000593f:	5d                   	pop    ebp
10005940:	c2 0c 00             	ret    0xc
10005943:	a1 24 f6 00 10       	mov    eax,ds:0x1000f624
10005948:	83 f8 01             	cmp    eax,0x1
1000594b:	74 0d                	je     0x1000595a
1000594d:	85 c0                	test   eax,eax
1000594f:	75 0e                	jne    0x1000595f
10005951:	83 3d 28 f6 00 10 01 	cmp    DWORD PTR ds:0x1000f628,0x1
10005958:	75 05                	jne    0x1000595f
1000595a:	e8 1c 20 00 00       	call   0x1000797b
1000595f:	ff 74 24 04          	push   DWORD PTR [esp+0x4]
10005963:	e8 4c 20 00 00       	call   0x100079b4
10005968:	68 ff 00 00 00       	push   0xff
1000596d:	ff 15 50 ea 00 10    	call   DWORD PTR ds:0x1000ea50
10005973:	59                   	pop    ecx
10005974:	59                   	pop    ecx
10005975:	c3                   	ret
10005976:	68 00 00 03 00       	push   0x30000
1000597b:	68 00 00 01 00       	push   0x10000
10005980:	e8 0f 22 00 00       	call   0x10007b94
10005985:	59                   	pop    ecx
10005986:	59                   	pop    ecx
10005987:	c3                   	ret
10005988:	55                   	push   ebp
10005989:	8b ec                	mov    ebp,esp
1000598b:	83 ec 18             	sub    esp,0x18
1000598e:	dd 05 70 d1 00 10    	fld    QWORD PTR ds:0x1000d170
10005994:	dd 5d f8             	fstp   QWORD PTR [ebp-0x8]
10005997:	dd 05 68 d1 00 10    	fld    QWORD PTR ds:0x1000d168
1000599d:	dd 5d f0             	fstp   QWORD PTR [ebp-0x10]
100059a0:	dd 45 f0             	fld    QWORD PTR [ebp-0x10]
100059a3:	dc 75 f8             	fdiv   QWORD PTR [ebp-0x8]
100059a6:	dc 4d f8             	fmul   QWORD PTR [ebp-0x8]
100059a9:	dc 6d f0             	fsubr  QWORD PTR [ebp-0x10]
100059ac:	dd 5d e8             	fstp   QWORD PTR [ebp-0x18]
100059af:	dd 45 e8             	fld    QWORD PTR [ebp-0x18]
100059b2:	dc 1d 60 d1 00 10    	fcomp  QWORD PTR ds:0x1000d160
100059b8:	df e0                	fnstsw ax
100059ba:	9e                   	sahf
100059bb:	76 05                	jbe    0x100059c2
100059bd:	6a 01                	push   0x1
100059bf:	58                   	pop    eax
100059c0:	c9                   	leave
100059c1:	c3                   	ret
100059c2:	33 c0                	xor    eax,eax
100059c4:	c9                   	leave
100059c5:	c3                   	ret
100059c6:	68 94 d1 00 10       	push   0x1000d194
100059cb:	ff 15 30 d0 00 10    	call   DWORD PTR ds:0x1000d030
100059d1:	85 c0                	test   eax,eax
100059d3:	74 15                	je     0x100059ea
100059d5:	68 78 d1 00 10       	push   0x1000d178
100059da:	50                   	push   eax
100059db:	ff 15 2c d0 00 10    	call   DWORD PTR ds:0x1000d02c
100059e1:	85 c0                	test   eax,eax
100059e3:	74 05                	je     0x100059ea
100059e5:	6a 00                	push   0x0
100059e7:	ff d0                	call   eax
100059e9:	c3                   	ret
100059ea:	e9 99 ff ff ff       	jmp    0x10005988
100059ef:	56                   	push   esi
100059f0:	8b 74 24 08          	mov    esi,DWORD PTR [esp+0x8]
100059f4:	0f be 06             	movsx  eax,BYTE PTR [esi]
100059f7:	50                   	push   eax
100059f8:	e8 2f 23 00 00       	call   0x10007d2c
100059fd:	83 f8 65             	cmp    eax,0x65
10005a00:	59                   	pop    ecx
10005a01:	74 2c                	je     0x10005a2f
10005a03:	46                   	inc    esi
10005a04:	83 3d 94 ec 00 10 01 	cmp    DWORD PTR ds:0x1000ec94,0x1
10005a0b:	7e 0f                	jle    0x10005a1c
10005a0d:	0f be 06             	movsx  eax,BYTE PTR [esi]
10005a10:	6a 04                	push   0x4
10005a12:	50                   	push   eax
10005a13:	e8 e0 16 00 00       	call   0x100070f8
10005a18:	59                   	pop    ecx
10005a19:	59                   	pop    ecx
10005a1a:	eb 0f                	jmp    0x10005a2b
10005a1c:	0f be 06             	movsx  eax,BYTE PTR [esi]
10005a1f:	8b 0d 88 ea 00 10    	mov    ecx,DWORD PTR ds:0x1000ea88
10005a25:	8a 04 41             	mov    al,BYTE PTR [ecx+eax*2]
10005a28:	83 e0 04             	and    eax,0x4
10005a2b:	85 c0                	test   eax,eax
10005a2d:	75 d4                	jne    0x10005a03
10005a2f:	8a 0d 98 ec 00 10    	mov    cl,BYTE PTR ds:0x1000ec98
10005a35:	8a 06                	mov    al,BYTE PTR [esi]
10005a37:	88 0e                	mov    BYTE PTR [esi],cl
10005a39:	46                   	inc    esi
10005a3a:	8a 0e                	mov    cl,BYTE PTR [esi]
10005a3c:	88 06                	mov    BYTE PTR [esi],al
10005a3e:	8a c1                	mov    al,cl
10005a40:	8a 0e                	mov    cl,BYTE PTR [esi]
10005a42:	46                   	inc    esi
10005a43:	84 c9                	test   cl,cl
10005a45:	75 f3                	jne    0x10005a3a
10005a47:	5e                   	pop    esi
10005a48:	c3                   	ret
10005a49:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
10005a4d:	8a 15 98 ec 00 10    	mov    dl,BYTE PTR ds:0x1000ec98
10005a53:	8a 08                	mov    cl,BYTE PTR [eax]
10005a55:	84 c9                	test   cl,cl
10005a57:	74 0c                	je     0x10005a65
10005a59:	3a ca                	cmp    cl,dl
10005a5b:	74 08                	je     0x10005a65
10005a5d:	8a 48 01             	mov    cl,BYTE PTR [eax+0x1]
10005a60:	40                   	inc    eax
10005a61:	84 c9                	test   cl,cl
10005a63:	75 f4                	jne    0x10005a59
10005a65:	8a 08                	mov    cl,BYTE PTR [eax]
10005a67:	40                   	inc    eax
10005a68:	84 c9                	test   cl,cl
10005a6a:	74 2a                	je     0x10005a96
10005a6c:	8a 08                	mov    cl,BYTE PTR [eax]
10005a6e:	84 c9                	test   cl,cl
10005a70:	74 0d                	je     0x10005a7f
10005a72:	80 f9 65             	cmp    cl,0x65
10005a75:	74 08                	je     0x10005a7f
10005a77:	80 f9 45             	cmp    cl,0x45
10005a7a:	74 03                	je     0x10005a7f
10005a7c:	40                   	inc    eax
10005a7d:	eb ed                	jmp    0x10005a6c
10005a7f:	8b c8                	mov    ecx,eax
10005a81:	48                   	dec    eax
10005a82:	80 38 30             	cmp    BYTE PTR [eax],0x30
10005a85:	74 fa                	je     0x10005a81
10005a87:	38 10                	cmp    BYTE PTR [eax],dl
10005a89:	75 01                	jne    0x10005a8c
10005a8b:	48                   	dec    eax
10005a8c:	8a 11                	mov    dl,BYTE PTR [ecx]
10005a8e:	40                   	inc    eax
10005a8f:	41                   	inc    ecx
10005a90:	84 d2                	test   dl,dl
10005a92:	88 10                	mov    BYTE PTR [eax],dl
10005a94:	75 f6                	jne    0x10005a8c
10005a96:	c3                   	ret
10005a97:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
10005a9b:	dd 00                	fld    QWORD PTR [eax]
10005a9d:	dc 1d a0 d1 00 10    	fcomp  QWORD PTR ds:0x1000d1a0
10005aa3:	df e0                	fnstsw ax
10005aa5:	9e                   	sahf
10005aa6:	72 04                	jb     0x10005aac
10005aa8:	6a 01                	push   0x1
10005aaa:	58                   	pop    eax
10005aab:	c3                   	ret
10005aac:	33 c0                	xor    eax,eax
10005aae:	c3                   	ret
10005aaf:	55                   	push   ebp
10005ab0:	8b ec                	mov    ebp,esp
10005ab2:	51                   	push   ecx
10005ab3:	51                   	push   ecx
10005ab4:	83 7d 08 00          	cmp    DWORD PTR [ebp+0x8],0x0
10005ab8:	ff 75 10             	push   DWORD PTR [ebp+0x10]
10005abb:	74 1b                	je     0x10005ad8
10005abd:	8d 45 f8             	lea    eax,[ebp-0x8]
10005ac0:	50                   	push   eax
10005ac1:	e8 3d 27 00 00       	call   0x10008203
10005ac6:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10005ac9:	59                   	pop    ecx
10005aca:	59                   	pop    ecx
10005acb:	8b 4d f8             	mov    ecx,DWORD PTR [ebp-0x8]
10005ace:	89 08                	mov    DWORD PTR [eax],ecx
10005ad0:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10005ad3:	89 48 04             	mov    DWORD PTR [eax+0x4],ecx
10005ad6:	c9                   	leave
10005ad7:	c3                   	ret
10005ad8:	8d 45 10             	lea    eax,[ebp+0x10]
10005adb:	50                   	push   eax
10005adc:	e8 7d 27 00 00       	call   0x1000825e
10005ae1:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10005ae4:	59                   	pop    ecx
10005ae5:	59                   	pop    ecx
10005ae6:	8b 4d 10             	mov    ecx,DWORD PTR [ebp+0x10]
10005ae9:	89 08                	mov    DWORD PTR [eax],ecx
10005aeb:	c9                   	leave
10005aec:	c3                   	ret
10005aed:	55                   	push   ebp
10005aee:	8b ec                	mov    ebp,esp
10005af0:	80 3d 30 f6 00 10 00 	cmp    BYTE PTR ds:0x1000f630,0x0
10005af7:	53                   	push   ebx
10005af8:	56                   	push   esi
10005af9:	74 27                	je     0x10005b22
10005afb:	8b 5d 10             	mov    ebx,DWORD PTR [ebp+0x10]
10005afe:	a1 2c f6 00 10       	mov    eax,ds:0x1000f62c
10005b03:	33 c9                	xor    ecx,ecx
10005b05:	8b f0                	mov    esi,eax
10005b07:	85 db                	test   ebx,ebx
10005b09:	0f 9f c1             	setg   cl
10005b0c:	51                   	push   ecx
10005b0d:	33 c9                	xor    ecx,ecx
10005b0f:	83 38 2d             	cmp    DWORD PTR [eax],0x2d
10005b12:	0f 94 c1             	sete   cl
10005b15:	03 4d 0c             	add    ecx,DWORD PTR [ebp+0xc]
10005b18:	51                   	push   ecx
10005b19:	e8 e7 02 00 00       	call   0x10005e05
10005b1e:	59                   	pop    ecx
10005b1f:	59                   	pop    ecx
10005b20:	eb 38                	jmp    0x10005b5a
10005b22:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10005b25:	51                   	push   ecx
10005b26:	51                   	push   ecx
10005b27:	dd 00                	fld    QWORD PTR [eax]
10005b29:	dd 1c 24             	fstp   QWORD PTR [esp]
10005b2c:	e8 c6 28 00 00       	call   0x100083f7
10005b31:	8b 5d 10             	mov    ebx,DWORD PTR [ebp+0x10]
10005b34:	8b f0                	mov    esi,eax
10005b36:	56                   	push   esi
10005b37:	8b 55 0c             	mov    edx,DWORD PTR [ebp+0xc]
10005b3a:	8d 43 01             	lea    eax,[ebx+0x1]
10005b3d:	50                   	push   eax
10005b3e:	33 c0                	xor    eax,eax
10005b40:	83 3e 2d             	cmp    DWORD PTR [esi],0x2d
10005b43:	0f 94 c0             	sete   al
10005b46:	33 c9                	xor    ecx,ecx
10005b48:	85 db                	test   ebx,ebx
10005b4a:	0f 9f c1             	setg   cl
10005b4d:	03 d0                	add    edx,eax
10005b4f:	03 ca                	add    ecx,edx
10005b51:	51                   	push   ecx
10005b52:	e8 29 28 00 00       	call   0x10008380
10005b57:	83 c4 14             	add    esp,0x14
10005b5a:	83 3e 2d             	cmp    DWORD PTR [esi],0x2d
10005b5d:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10005b60:	75 04                	jne    0x10005b66
10005b62:	c6 00 2d             	mov    BYTE PTR [eax],0x2d
10005b65:	40                   	inc    eax
10005b66:	85 db                	test   ebx,ebx
10005b68:	7e 14                	jle    0x10005b7e
10005b6a:	8a 48 01             	mov    cl,BYTE PTR [eax+0x1]
10005b6d:	57                   	push   edi
10005b6e:	8d 78 01             	lea    edi,[eax+0x1]
10005b71:	88 08                	mov    BYTE PTR [eax],cl
10005b73:	8a 0d 98 ec 00 10    	mov    cl,BYTE PTR ds:0x1000ec98
10005b79:	8b c7                	mov    eax,edi
10005b7b:	5f                   	pop    edi
10005b7c:	88 08                	mov    BYTE PTR [eax],cl
10005b7e:	33 c9                	xor    ecx,ecx
10005b80:	68 a8 d1 00 10       	push   0x1000d1a8
10005b85:	38 0d 30 f6 00 10    	cmp    BYTE PTR ds:0x1000f630,cl
10005b8b:	0f 94 c1             	sete   cl
10005b8e:	03 c8                	add    ecx,eax
10005b90:	03 cb                	add    ecx,ebx
10005b92:	51                   	push   ecx
10005b93:	e8 f8 26 00 00       	call   0x10008290
10005b98:	83 7d 14 00          	cmp    DWORD PTR [ebp+0x14],0x0
10005b9c:	59                   	pop    ecx
10005b9d:	59                   	pop    ecx
10005b9e:	8b c8                	mov    ecx,eax
10005ba0:	74 03                	je     0x10005ba5
10005ba2:	c6 01 45             	mov    BYTE PTR [ecx],0x45
10005ba5:	8b 46 0c             	mov    eax,DWORD PTR [esi+0xc]
10005ba8:	41                   	inc    ecx
10005ba9:	80 38 30             	cmp    BYTE PTR [eax],0x30
10005bac:	74 3c                	je     0x10005bea
10005bae:	8b 5e 04             	mov    ebx,DWORD PTR [esi+0x4]
10005bb1:	4b                   	dec    ebx
10005bb2:	79 05                	jns    0x10005bb9
10005bb4:	f7 db                	neg    ebx
10005bb6:	c6 01 2d             	mov    BYTE PTR [ecx],0x2d
10005bb9:	41                   	inc    ecx
10005bba:	83 fb 64             	cmp    ebx,0x64
10005bbd:	7c 11                	jl     0x10005bd0
10005bbf:	8b c3                	mov    eax,ebx
10005bc1:	6a 64                	push   0x64
10005bc3:	99                   	cdq
10005bc4:	5e                   	pop    esi
10005bc5:	f7 fe                	idiv   esi
10005bc7:	00 01                	add    BYTE PTR [ecx],al
10005bc9:	8b c3                	mov    eax,ebx
10005bcb:	99                   	cdq
10005bcc:	f7 fe                	idiv   esi
10005bce:	8b da                	mov    ebx,edx
10005bd0:	41                   	inc    ecx
10005bd1:	83 fb 0a             	cmp    ebx,0xa
10005bd4:	7c 11                	jl     0x10005be7
10005bd6:	8b c3                	mov    eax,ebx
10005bd8:	6a 0a                	push   0xa
10005bda:	99                   	cdq
10005bdb:	5e                   	pop    esi
10005bdc:	f7 fe                	idiv   esi
10005bde:	00 01                	add    BYTE PTR [ecx],al
10005be0:	8b c3                	mov    eax,ebx
10005be2:	99                   	cdq
10005be3:	f7 fe                	idiv   esi
10005be5:	8b da                	mov    ebx,edx
10005be7:	00 59 01             	add    BYTE PTR [ecx+0x1],bl
10005bea:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10005bed:	5e                   	pop    esi
10005bee:	5b                   	pop    ebx
10005bef:	5d                   	pop    ebp
10005bf0:	c3                   	ret
10005bf1:	80 3d 30 f6 00 10 00 	cmp    BYTE PTR ds:0x1000f630,0x0
10005bf8:	53                   	push   ebx
10005bf9:	55                   	push   ebp
10005bfa:	8b 6c 24 10          	mov    ebp,DWORD PTR [esp+0x10]
10005bfe:	56                   	push   esi
10005bff:	57                   	push   edi
10005c00:	74 2a                	je     0x10005c2c
10005c02:	a1 34 f6 00 10       	mov    eax,ds:0x1000f634
10005c07:	8b 5c 24 1c          	mov    ebx,DWORD PTR [esp+0x1c]
10005c0b:	8b 35 2c f6 00 10    	mov    esi,DWORD PTR ds:0x1000f62c
10005c11:	3b c3                	cmp    eax,ebx
10005c13:	75 47                	jne    0x10005c5c
10005c15:	33 c9                	xor    ecx,ecx
10005c17:	83 3e 2d             	cmp    DWORD PTR [esi],0x2d
10005c1a:	0f 94 c1             	sete   cl
10005c1d:	03 c8                	add    ecx,eax
10005c1f:	03 cd                	add    ecx,ebp
10005c21:	8b c1                	mov    eax,ecx
10005c23:	c6 00 30             	mov    BYTE PTR [eax],0x30
10005c26:	80 60 01 00          	and    BYTE PTR [eax+0x1],0x0
10005c2a:	eb 30                	jmp    0x10005c5c
10005c2c:	8b 44 24 14          	mov    eax,DWORD PTR [esp+0x14]
10005c30:	51                   	push   ecx
10005c31:	51                   	push   ecx
10005c32:	dd 00                	fld    QWORD PTR [eax]
10005c34:	dd 1c 24             	fstp   QWORD PTR [esp]
10005c37:	e8 bb 27 00 00       	call   0x100083f7
10005c3c:	8b 5c 24 24          	mov    ebx,DWORD PTR [esp+0x24]
10005c40:	8b f0                	mov    esi,eax
10005c42:	56                   	push   esi
10005c43:	8b 46 04             	mov    eax,DWORD PTR [esi+0x4]
10005c46:	03 c3                	add    eax,ebx
10005c48:	50                   	push   eax
10005c49:	33 c0                	xor    eax,eax
10005c4b:	83 3e 2d             	cmp    DWORD PTR [esi],0x2d
10005c4e:	0f 94 c0             	sete   al
10005c51:	03 c5                	add    eax,ebp
10005c53:	50                   	push   eax
10005c54:	e8 27 27 00 00       	call   0x10008380
10005c59:	83 c4 14             	add    esp,0x14
10005c5c:	83 3e 2d             	cmp    DWORD PTR [esi],0x2d
10005c5f:	8b fd                	mov    edi,ebp
10005c61:	75 07                	jne    0x10005c6a
10005c63:	c6 45 00 2d          	mov    BYTE PTR [ebp+0x0],0x2d
10005c67:	8d 7d 01             	lea    edi,[ebp+0x1]
10005c6a:	8b 46 04             	mov    eax,DWORD PTR [esi+0x4]
10005c6d:	85 c0                	test   eax,eax
10005c6f:	7f 10                	jg     0x10005c81
10005c71:	6a 01                	push   0x1
10005c73:	57                   	push   edi
10005c74:	e8 8c 01 00 00       	call   0x10005e05
10005c79:	59                   	pop    ecx
10005c7a:	c6 07 30             	mov    BYTE PTR [edi],0x30
10005c7d:	59                   	pop    ecx
10005c7e:	47                   	inc    edi
10005c7f:	eb 02                	jmp    0x10005c83
10005c81:	03 f8                	add    edi,eax
10005c83:	85 db                	test   ebx,ebx
10005c85:	7e 41                	jle    0x10005cc8
10005c87:	6a 01                	push   0x1
10005c89:	57                   	push   edi
10005c8a:	e8 76 01 00 00       	call   0x10005e05
10005c8f:	a0 98 ec 00 10       	mov    al,ds:0x1000ec98
10005c94:	59                   	pop    ecx
10005c95:	88 07                	mov    BYTE PTR [edi],al
10005c97:	8b 76 04             	mov    esi,DWORD PTR [esi+0x4]
10005c9a:	47                   	inc    edi
10005c9b:	59                   	pop    ecx
10005c9c:	85 f6                	test   esi,esi
10005c9e:	7d 28                	jge    0x10005cc8
10005ca0:	80 3d 30 f6 00 10 00 	cmp    BYTE PTR ds:0x1000f630,0x0
10005ca7:	74 04                	je     0x10005cad
10005ca9:	f7 de                	neg    esi
10005cab:	eb 06                	jmp    0x10005cb3
10005cad:	f7 de                	neg    esi
10005caf:	3b de                	cmp    ebx,esi
10005cb1:	7c 02                	jl     0x10005cb5
10005cb3:	8b de                	mov    ebx,esi
10005cb5:	53                   	push   ebx
10005cb6:	57                   	push   edi
10005cb7:	e8 49 01 00 00       	call   0x10005e05
10005cbc:	53                   	push   ebx
10005cbd:	6a 30                	push   0x30
10005cbf:	57                   	push   edi
10005cc0:	e8 5b 28 00 00       	call   0x10008520
10005cc5:	83 c4 14             	add    esp,0x14
10005cc8:	5f                   	pop    edi
10005cc9:	8b c5                	mov    eax,ebp
10005ccb:	5e                   	pop    esi
10005ccc:	5d                   	pop    ebp
10005ccd:	5b                   	pop    ebx
10005cce:	c3                   	ret
10005ccf:	55                   	push   ebp
10005cd0:	8b ec                	mov    ebp,esp
10005cd2:	53                   	push   ebx
10005cd3:	56                   	push   esi
10005cd4:	57                   	push   edi
10005cd5:	8b 7d 08             	mov    edi,DWORD PTR [ebp+0x8]
10005cd8:	51                   	push   ecx
10005cd9:	51                   	push   ecx
10005cda:	dd 07                	fld    QWORD PTR [edi]
10005cdc:	dd 1c 24             	fstp   QWORD PTR [esp]
10005cdf:	e8 13 27 00 00       	call   0x100083f7
10005ce4:	a3 2c f6 00 10       	mov    ds:0x1000f62c,eax
10005ce9:	8b 48 04             	mov    ecx,DWORD PTR [eax+0x4]
10005cec:	49                   	dec    ecx
10005ced:	8b 5d 10             	mov    ebx,DWORD PTR [ebp+0x10]
10005cf0:	89 0d 34 f6 00 10    	mov    DWORD PTR ds:0x1000f634,ecx
10005cf6:	33 c9                	xor    ecx,ecx
10005cf8:	83 38 2d             	cmp    DWORD PTR [eax],0x2d
10005cfb:	50                   	push   eax
10005cfc:	53                   	push   ebx
10005cfd:	0f 94 c1             	sete   cl
10005d00:	03 4d 0c             	add    ecx,DWORD PTR [ebp+0xc]
10005d03:	8b f1                	mov    esi,ecx
10005d05:	56                   	push   esi
10005d06:	e8 75 26 00 00       	call   0x10008380
10005d0b:	a1 2c f6 00 10       	mov    eax,ds:0x1000f62c
10005d10:	83 c4 14             	add    esp,0x14
10005d13:	8b 48 04             	mov    ecx,DWORD PTR [eax+0x4]
10005d16:	49                   	dec    ecx
10005d17:	39 0d 34 f6 00 10    	cmp    DWORD PTR ds:0x1000f634,ecx
10005d1d:	0f 9c c1             	setl   cl
10005d20:	88 0d 38 f6 00 10    	mov    BYTE PTR ds:0x1000f638,cl
10005d26:	8b 40 04             	mov    eax,DWORD PTR [eax+0x4]
10005d29:	48                   	dec    eax
10005d2a:	83 f8 fc             	cmp    eax,0xfffffffc
10005d2d:	a3 34 f6 00 10       	mov    ds:0x1000f634,eax
10005d32:	7c 21                	jl     0x10005d55
10005d34:	3b c3                	cmp    eax,ebx
10005d36:	7d 1d                	jge    0x10005d55
10005d38:	84 c9                	test   cl,cl
10005d3a:	74 0a                	je     0x10005d46
10005d3c:	8a 06                	mov    al,BYTE PTR [esi]
10005d3e:	46                   	inc    esi
10005d3f:	84 c0                	test   al,al
10005d41:	75 f9                	jne    0x10005d3c
10005d43:	20 46 fe             	and    BYTE PTR [esi-0x2],al
10005d46:	53                   	push   ebx
10005d47:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
10005d4a:	57                   	push   edi
10005d4b:	e8 41 00 00 00       	call   0x10005d91
10005d50:	83 c4 0c             	add    esp,0xc
10005d53:	eb 10                	jmp    0x10005d65
10005d55:	ff 75 14             	push   DWORD PTR [ebp+0x14]
10005d58:	53                   	push   ebx
10005d59:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
10005d5c:	57                   	push   edi
10005d5d:	e8 08 00 00 00       	call   0x10005d6a
10005d62:	83 c4 10             	add    esp,0x10
10005d65:	5f                   	pop    edi
10005d66:	5e                   	pop    esi
10005d67:	5b                   	pop    ebx
10005d68:	5d                   	pop    ebp
10005d69:	c3                   	ret
10005d6a:	ff 74 24 10          	push   DWORD PTR [esp+0x10]
10005d6e:	c6 05 30 f6 00 10 01 	mov    BYTE PTR ds:0x1000f630,0x1
10005d75:	ff 74 24 10          	push   DWORD PTR [esp+0x10]
10005d79:	ff 74 24 10          	push   DWORD PTR [esp+0x10]
10005d7d:	ff 74 24 10          	push   DWORD PTR [esp+0x10]
10005d81:	e8 67 fd ff ff       	call   0x10005aed
10005d86:	80 25 30 f6 00 10 00 	and    BYTE PTR ds:0x1000f630,0x0
10005d8d:	83 c4 10             	add    esp,0x10
10005d90:	c3                   	ret
10005d91:	ff 74 24 0c          	push   DWORD PTR [esp+0xc]
10005d95:	c6 05 30 f6 00 10 01 	mov    BYTE PTR ds:0x1000f630,0x1
10005d9c:	ff 74 24 0c          	push   DWORD PTR [esp+0xc]
10005da0:	ff 74 24 0c          	push   DWORD PTR [esp+0xc]
10005da4:	e8 48 fe ff ff       	call   0x10005bf1
10005da9:	80 25 30 f6 00 10 00 	and    BYTE PTR ds:0x1000f630,0x0
10005db0:	83 c4 0c             	add    esp,0xc
10005db3:	c3                   	ret
10005db4:	55                   	push   ebp
10005db5:	8b ec                	mov    ebp,esp
10005db7:	83 7d 10 65          	cmp    DWORD PTR [ebp+0x10],0x65
10005dbb:	74 32                	je     0x10005def
10005dbd:	83 7d 10 45          	cmp    DWORD PTR [ebp+0x10],0x45
10005dc1:	74 2c                	je     0x10005def
10005dc3:	83 7d 10 66          	cmp    DWORD PTR [ebp+0x10],0x66
10005dc7:	75 13                	jne    0x10005ddc
10005dc9:	ff 75 14             	push   DWORD PTR [ebp+0x14]
10005dcc:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
10005dcf:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10005dd2:	e8 1a fe ff ff       	call   0x10005bf1
10005dd7:	83 c4 0c             	add    esp,0xc
10005dda:	5d                   	pop    ebp
10005ddb:	c3                   	ret
10005ddc:	ff 75 18             	push   DWORD PTR [ebp+0x18]
10005ddf:	ff 75 14             	push   DWORD PTR [ebp+0x14]
10005de2:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
10005de5:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10005de8:	e8 e2 fe ff ff       	call   0x10005ccf
10005ded:	eb 11                	jmp    0x10005e00
10005def:	ff 75 18             	push   DWORD PTR [ebp+0x18]
10005df2:	ff 75 14             	push   DWORD PTR [ebp+0x14]
10005df5:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
10005df8:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10005dfb:	e8 ed fc ff ff       	call   0x10005aed
10005e00:	83 c4 10             	add    esp,0x10
10005e03:	5d                   	pop    ebp
10005e04:	c3                   	ret
10005e05:	57                   	push   edi
10005e06:	8b 7c 24 0c          	mov    edi,DWORD PTR [esp+0xc]
10005e0a:	85 ff                	test   edi,edi
10005e0c:	74 1a                	je     0x10005e28
10005e0e:	56                   	push   esi
10005e0f:	8b 74 24 0c          	mov    esi,DWORD PTR [esp+0xc]
10005e13:	56                   	push   esi
10005e14:	e8 a7 2a 00 00       	call   0x100088c0
10005e19:	40                   	inc    eax
10005e1a:	50                   	push   eax
10005e1b:	56                   	push   esi
10005e1c:	03 f7                	add    esi,edi
10005e1e:	56                   	push   esi
10005e1f:	e8 5c 27 00 00       	call   0x10008580
10005e24:	83 c4 10             	add    esp,0x10
10005e27:	5e                   	pop    esi
10005e28:	5f                   	pop    edi
10005e29:	c3                   	ret
10005e2a:	56                   	push   esi
10005e2b:	8b 74 24 08          	mov    esi,DWORD PTR [esp+0x8]
10005e2f:	85 f6                	test   esi,esi
10005e31:	74 24                	je     0x10005e57
10005e33:	56                   	push   esi
10005e34:	e8 66 2b 00 00       	call   0x1000899f
10005e39:	59                   	pop    ecx
10005e3a:	85 c0                	test   eax,eax
10005e3c:	56                   	push   esi
10005e3d:	74 0a                	je     0x10005e49
10005e3f:	50                   	push   eax
10005e40:	e8 85 2b 00 00       	call   0x100089ca
10005e45:	59                   	pop    ecx
10005e46:	59                   	pop    ecx
10005e47:	5e                   	pop    esi
10005e48:	c3                   	ret
10005e49:	6a 00                	push   0x0
10005e4b:	ff 35 a4 0b 01 10    	push   DWORD PTR ds:0x10010ba4
10005e51:	ff 15 34 d0 00 10    	call   DWORD PTR ds:0x1000d034
10005e57:	5e                   	pop    esi
10005e58:	c3                   	ret
10005e59:	ff 35 d8 f7 00 10    	push   DWORD PTR ds:0x1000f7d8
10005e5f:	ff 74 24 08          	push   DWORD PTR [esp+0x8]
10005e63:	e8 03 00 00 00       	call   0x10005e6b
10005e68:	59                   	pop    ecx
10005e69:	59                   	pop    ecx
10005e6a:	c3                   	ret
10005e6b:	83 7c 24 04 e0       	cmp    DWORD PTR [esp+0x4],0xffffffe0
10005e70:	77 22                	ja     0x10005e94
10005e72:	ff 74 24 04          	push   DWORD PTR [esp+0x4]
10005e76:	e8 1c 00 00 00       	call   0x10005e97
10005e7b:	85 c0                	test   eax,eax
10005e7d:	59                   	pop    ecx
10005e7e:	75 16                	jne    0x10005e96
10005e80:	39 44 24 08          	cmp    DWORD PTR [esp+0x8],eax
10005e84:	74 10                	je     0x10005e96
10005e86:	ff 74 24 04          	push   DWORD PTR [esp+0x4]
10005e8a:	e8 27 3a 00 00       	call   0x100098b6
10005e8f:	85 c0                	test   eax,eax
10005e91:	59                   	pop    ecx
10005e92:	75 de                	jne    0x10005e72
10005e94:	33 c0                	xor    eax,eax
10005e96:	c3                   	ret
10005e97:	56                   	push   esi
10005e98:	8b 74 24 08          	mov    esi,DWORD PTR [esp+0x8]
10005e9c:	3b 35 70 ed 00 10    	cmp    esi,DWORD PTR ds:0x1000ed70
10005ea2:	77 0b                	ja     0x10005eaf
10005ea4:	56                   	push   esi
10005ea5:	e8 4b 2e 00 00       	call   0x10008cf5
10005eaa:	85 c0                	test   eax,eax
10005eac:	59                   	pop    ecx
10005ead:	75 1c                	jne    0x10005ecb
10005eaf:	85 f6                	test   esi,esi
10005eb1:	75 03                	jne    0x10005eb6
10005eb3:	6a 01                	push   0x1
10005eb5:	5e                   	pop    esi
10005eb6:	83 c6 0f             	add    esi,0xf
10005eb9:	83 e6 f0             	and    esi,0xfffffff0
10005ebc:	56                   	push   esi
10005ebd:	6a 00                	push   0x0
10005ebf:	ff 35 a4 0b 01 10    	push   DWORD PTR ds:0x10010ba4
10005ec5:	ff 15 38 d0 00 10    	call   DWORD PTR ds:0x1000d038
10005ecb:	5e                   	pop    esi
10005ecc:	c3                   	ret
10005ecd:	55                   	push   ebp
10005ece:	8b ec                	mov    ebp,esp
10005ed0:	53                   	push   ebx
10005ed1:	56                   	push   esi
10005ed2:	8b 75 0c             	mov    esi,DWORD PTR [ebp+0xc]
10005ed5:	8b 46 0c             	mov    eax,DWORD PTR [esi+0xc]
10005ed8:	8b 5e 10             	mov    ebx,DWORD PTR [esi+0x10]
10005edb:	a8 82                	test   al,0x82
10005edd:	0f 84 f3 00 00 00    	je     0x10005fd6
10005ee3:	a8 40                	test   al,0x40
10005ee5:	0f 85 eb 00 00 00    	jne    0x10005fd6
10005eeb:	a8 01                	test   al,0x1
10005eed:	74 16                	je     0x10005f05
10005eef:	83 66 04 00          	and    DWORD PTR [esi+0x4],0x0
10005ef3:	a8 10                	test   al,0x10
10005ef5:	0f 84 db 00 00 00    	je     0x10005fd6
10005efb:	8b 4e 08             	mov    ecx,DWORD PTR [esi+0x8]
10005efe:	24 fe                	and    al,0xfe
10005f00:	89 0e                	mov    DWORD PTR [esi],ecx
10005f02:	89 46 0c             	mov    DWORD PTR [esi+0xc],eax
10005f05:	8b 46 0c             	mov    eax,DWORD PTR [esi+0xc]
10005f08:	83 66 04 00          	and    DWORD PTR [esi+0x4],0x0
10005f0c:	83 65 0c 00          	and    DWORD PTR [ebp+0xc],0x0
10005f10:	24 ef                	and    al,0xef
10005f12:	0c 02                	or     al,0x2
10005f14:	66 a9 0c 01          	test   ax,0x10c
10005f18:	89 46 0c             	mov    DWORD PTR [esi+0xc],eax
10005f1b:	75 22                	jne    0x10005f3f
10005f1d:	81 fe 98 ed 00 10    	cmp    esi,0x1000ed98
10005f23:	74 08                	je     0x10005f2d
10005f25:	81 fe b8 ed 00 10    	cmp    esi,0x1000edb8
10005f2b:	75 0b                	jne    0x10005f38
10005f2d:	53                   	push   ebx
10005f2e:	e8 29 3c 00 00       	call   0x10009b5c
10005f33:	85 c0                	test   eax,eax
10005f35:	59                   	pop    ecx
10005f36:	75 07                	jne    0x10005f3f
10005f38:	56                   	push   esi
10005f39:	e8 da 3b 00 00       	call   0x10009b18
10005f3e:	59                   	pop    ecx
10005f3f:	66 f7 46 0c 08 01    	test   WORD PTR [esi+0xc],0x108
10005f45:	57                   	push   edi
10005f46:	74 64                	je     0x10005fac
10005f48:	8b 46 08             	mov    eax,DWORD PTR [esi+0x8]
10005f4b:	8b 3e                	mov    edi,DWORD PTR [esi]
10005f4d:	2b f8                	sub    edi,eax
10005f4f:	8d 48 01             	lea    ecx,[eax+0x1]
10005f52:	89 0e                	mov    DWORD PTR [esi],ecx
10005f54:	8b 4e 18             	mov    ecx,DWORD PTR [esi+0x18]
10005f57:	49                   	dec    ecx
10005f58:	85 ff                	test   edi,edi
10005f5a:	89 4e 04             	mov    DWORD PTR [esi+0x4],ecx
10005f5d:	7e 10                	jle    0x10005f6f
10005f5f:	57                   	push   edi
10005f60:	50                   	push   eax
10005f61:	53                   	push   ebx
10005f62:	e8 04 3a 00 00       	call   0x1000996b
10005f67:	83 c4 0c             	add    esp,0xc
10005f6a:	89 45 0c             	mov    DWORD PTR [ebp+0xc],eax
10005f6d:	eb 33                	jmp    0x10005fa2
10005f6f:	83 fb ff             	cmp    ebx,0xffffffff
10005f72:	74 16                	je     0x10005f8a
10005f74:	8b c3                	mov    eax,ebx
10005f76:	8b cb                	mov    ecx,ebx
10005f78:	c1 f8 05             	sar    eax,0x5
10005f7b:	83 e1 1f             	and    ecx,0x1f
10005f7e:	8b 04 85 a0 0a 01 10 	mov    eax,DWORD PTR [eax*4+0x10010aa0]
10005f85:	8d 04 c8             	lea    eax,[eax+ecx*8]
10005f88:	eb 05                	jmp    0x10005f8f
10005f8a:	b8 a8 ec 00 10       	mov    eax,0x1000eca8
10005f8f:	f6 40 04 20          	test   BYTE PTR [eax+0x4],0x20
10005f93:	74 0d                	je     0x10005fa2
10005f95:	6a 02                	push   0x2
10005f97:	6a 00                	push   0x0
10005f99:	53                   	push   ebx
10005f9a:	e8 32 39 00 00       	call   0x100098d1
10005f9f:	83 c4 0c             	add    esp,0xc
10005fa2:	8b 46 08             	mov    eax,DWORD PTR [esi+0x8]
10005fa5:	8a 4d 08             	mov    cl,BYTE PTR [ebp+0x8]
10005fa8:	88 08                	mov    BYTE PTR [eax],cl
10005faa:	eb 14                	jmp    0x10005fc0
10005fac:	6a 01                	push   0x1
10005fae:	8d 45 08             	lea    eax,[ebp+0x8]
10005fb1:	5f                   	pop    edi
10005fb2:	57                   	push   edi
10005fb3:	50                   	push   eax
10005fb4:	53                   	push   ebx
10005fb5:	e8 b1 39 00 00       	call   0x1000996b
10005fba:	83 c4 0c             	add    esp,0xc
10005fbd:	89 45 0c             	mov    DWORD PTR [ebp+0xc],eax
10005fc0:	39 7d 0c             	cmp    DWORD PTR [ebp+0xc],edi
10005fc3:	5f                   	pop    edi
10005fc4:	74 06                	je     0x10005fcc
10005fc6:	83 4e 0c 20          	or     DWORD PTR [esi+0xc],0x20
10005fca:	eb 0f                	jmp    0x10005fdb
10005fcc:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10005fcf:	25 ff 00 00 00       	and    eax,0xff
10005fd4:	eb 08                	jmp    0x10005fde
10005fd6:	0c 20                	or     al,0x20
10005fd8:	89 46 0c             	mov    DWORD PTR [esi+0xc],eax
10005fdb:	83 c8 ff             	or     eax,0xffffffff
10005fde:	5e                   	pop    esi
10005fdf:	5b                   	pop    ebx
10005fe0:	5d                   	pop    ebp
10005fe1:	c3                   	ret
10005fe2:	55                   	push   ebp
10005fe3:	8b ec                	mov    ebp,esp
10005fe5:	81 ec 48 02 00 00    	sub    esp,0x248
10005feb:	53                   	push   ebx
10005fec:	56                   	push   esi
10005fed:	57                   	push   edi
10005fee:	8b 7d 0c             	mov    edi,DWORD PTR [ebp+0xc]
10005ff1:	33 f6                	xor    esi,esi
10005ff3:	8a 1f                	mov    bl,BYTE PTR [edi]
10005ff5:	47                   	inc    edi
10005ff6:	84 db                	test   bl,bl
10005ff8:	89 75 f4             	mov    DWORD PTR [ebp-0xc],esi
10005ffb:	89 75 ec             	mov    DWORD PTR [ebp-0x14],esi
10005ffe:	89 7d 0c             	mov    DWORD PTR [ebp+0xc],edi
10006001:	0f 84 f4 06 00 00    	je     0x100066fb
10006007:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
1000600a:	33 d2                	xor    edx,edx
1000600c:	eb 08                	jmp    0x10006016
1000600e:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
10006011:	8b 75 d0             	mov    esi,DWORD PTR [ebp-0x30]
10006014:	33 d2                	xor    edx,edx
10006016:	39 55 ec             	cmp    DWORD PTR [ebp-0x14],edx
10006019:	0f 8c dc 06 00 00    	jl     0x100066fb
1000601f:	80 fb 20             	cmp    bl,0x20
10006022:	7c 13                	jl     0x10006037
10006024:	80 fb 78             	cmp    bl,0x78
10006027:	7f 0e                	jg     0x10006037
10006029:	0f be c3             	movsx  eax,bl
1000602c:	8a 80 90 d1 00 10    	mov    al,BYTE PTR [eax+0x1000d190]
10006032:	83 e0 0f             	and    eax,0xf
10006035:	eb 02                	jmp    0x10006039
10006037:	33 c0                	xor    eax,eax
10006039:	0f be 84 c6 b0 d1 00 	movsx  eax,BYTE PTR [esi+eax*8+0x1000d1b0]
10006040:	10 
10006041:	c1 f8 04             	sar    eax,0x4
10006044:	83 f8 07             	cmp    eax,0x7
10006047:	89 45 d0             	mov    DWORD PTR [ebp-0x30],eax
1000604a:	0f 87 9a 06 00 00    	ja     0x100066ea
10006050:	ff 24 85 03 67 00 10 	jmp    DWORD PTR [eax*4+0x10006703]
10006057:	83 4d f0 ff          	or     DWORD PTR [ebp-0x10],0xffffffff
1000605b:	89 55 cc             	mov    DWORD PTR [ebp-0x34],edx
1000605e:	89 55 d8             	mov    DWORD PTR [ebp-0x28],edx
10006061:	89 55 e0             	mov    DWORD PTR [ebp-0x20],edx
10006064:	89 55 e4             	mov    DWORD PTR [ebp-0x1c],edx
10006067:	89 55 fc             	mov    DWORD PTR [ebp-0x4],edx
1000606a:	89 55 dc             	mov    DWORD PTR [ebp-0x24],edx
1000606d:	e9 78 06 00 00       	jmp    0x100066ea
10006072:	0f be c3             	movsx  eax,bl
10006075:	83 e8 20             	sub    eax,0x20
10006078:	74 3b                	je     0x100060b5
1000607a:	83 e8 03             	sub    eax,0x3
1000607d:	74 2d                	je     0x100060ac
1000607f:	83 e8 08             	sub    eax,0x8
10006082:	74 1f                	je     0x100060a3
10006084:	48                   	dec    eax
10006085:	48                   	dec    eax
10006086:	74 12                	je     0x1000609a
10006088:	83 e8 03             	sub    eax,0x3
1000608b:	0f 85 59 06 00 00    	jne    0x100066ea
10006091:	83 4d fc 08          	or     DWORD PTR [ebp-0x4],0x8
10006095:	e9 50 06 00 00       	jmp    0x100066ea
1000609a:	83 4d fc 04          	or     DWORD PTR [ebp-0x4],0x4
1000609e:	e9 47 06 00 00       	jmp    0x100066ea
100060a3:	83 4d fc 01          	or     DWORD PTR [ebp-0x4],0x1
100060a7:	e9 3e 06 00 00       	jmp    0x100066ea
100060ac:	80 4d fc 80          	or     BYTE PTR [ebp-0x4],0x80
100060b0:	e9 35 06 00 00       	jmp    0x100066ea
100060b5:	83 4d fc 02          	or     DWORD PTR [ebp-0x4],0x2
100060b9:	e9 2c 06 00 00       	jmp    0x100066ea
100060be:	80 fb 2a             	cmp    bl,0x2a
100060c1:	75 23                	jne    0x100060e6
100060c3:	8d 45 10             	lea    eax,[ebp+0x10]
100060c6:	50                   	push   eax
100060c7:	e8 f5 06 00 00       	call   0x100067c1
100060cc:	85 c0                	test   eax,eax
100060ce:	59                   	pop    ecx
100060cf:	89 45 e0             	mov    DWORD PTR [ebp-0x20],eax
100060d2:	0f 8d 12 06 00 00    	jge    0x100066ea
100060d8:	83 4d fc 04          	or     DWORD PTR [ebp-0x4],0x4
100060dc:	f7 d8                	neg    eax
100060de:	89 45 e0             	mov    DWORD PTR [ebp-0x20],eax
100060e1:	e9 04 06 00 00       	jmp    0x100066ea
100060e6:	8b 45 e0             	mov    eax,DWORD PTR [ebp-0x20]
100060e9:	0f be cb             	movsx  ecx,bl
100060ec:	8d 04 80             	lea    eax,[eax+eax*4]
100060ef:	8d 44 41 d0          	lea    eax,[ecx+eax*2-0x30]
100060f3:	eb e9                	jmp    0x100060de
100060f5:	89 55 f0             	mov    DWORD PTR [ebp-0x10],edx
100060f8:	e9 ed 05 00 00       	jmp    0x100066ea
100060fd:	80 fb 2a             	cmp    bl,0x2a
10006100:	75 1e                	jne    0x10006120
10006102:	8d 45 10             	lea    eax,[ebp+0x10]
10006105:	50                   	push   eax
10006106:	e8 b6 06 00 00       	call   0x100067c1
1000610b:	85 c0                	test   eax,eax
1000610d:	59                   	pop    ecx
1000610e:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax
10006111:	0f 8d d3 05 00 00    	jge    0x100066ea
10006117:	83 4d f0 ff          	or     DWORD PTR [ebp-0x10],0xffffffff
1000611b:	e9 ca 05 00 00       	jmp    0x100066ea
10006120:	8d 04 89             	lea    eax,[ecx+ecx*4]
10006123:	0f be cb             	movsx  ecx,bl
10006126:	8d 44 41 d0          	lea    eax,[ecx+eax*2-0x30]
1000612a:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax
1000612d:	e9 b8 05 00 00       	jmp    0x100066ea
10006132:	80 fb 49             	cmp    bl,0x49
10006135:	74 2e                	je     0x10006165
10006137:	80 fb 68             	cmp    bl,0x68
1000613a:	74 20                	je     0x1000615c
1000613c:	80 fb 6c             	cmp    bl,0x6c
1000613f:	74 12                	je     0x10006153
10006141:	80 fb 77             	cmp    bl,0x77
10006144:	0f 85 a0 05 00 00    	jne    0x100066ea
1000614a:	80 4d fd 08          	or     BYTE PTR [ebp-0x3],0x8
1000614e:	e9 97 05 00 00       	jmp    0x100066ea
10006153:	83 4d fc 10          	or     DWORD PTR [ebp-0x4],0x10
10006157:	e9 8e 05 00 00       	jmp    0x100066ea
1000615c:	83 4d fc 20          	or     DWORD PTR [ebp-0x4],0x20
10006160:	e9 85 05 00 00       	jmp    0x100066ea
10006165:	80 3f 36             	cmp    BYTE PTR [edi],0x36
10006168:	75 14                	jne    0x1000617e
1000616a:	80 7f 01 34          	cmp    BYTE PTR [edi+0x1],0x34
1000616e:	75 0e                	jne    0x1000617e
10006170:	47                   	inc    edi
10006171:	47                   	inc    edi
10006172:	80 4d fd 80          	or     BYTE PTR [ebp-0x3],0x80
10006176:	89 7d 0c             	mov    DWORD PTR [ebp+0xc],edi
10006179:	e9 6c 05 00 00       	jmp    0x100066ea
1000617e:	89 55 d0             	mov    DWORD PTR [ebp-0x30],edx
10006181:	8b 0d 88 ea 00 10    	mov    ecx,DWORD PTR ds:0x1000ea88
10006187:	89 55 dc             	mov    DWORD PTR [ebp-0x24],edx
1000618a:	0f b6 c3             	movzx  eax,bl
1000618d:	f6 44 41 01 80       	test   BYTE PTR [ecx+eax*2+0x1],0x80
10006192:	74 19                	je     0x100061ad
10006194:	8d 45 ec             	lea    eax,[ebp-0x14]
10006197:	50                   	push   eax
10006198:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000619b:	0f be c3             	movsx  eax,bl
1000619e:	50                   	push   eax
1000619f:	e8 7f 05 00 00       	call   0x10006723
100061a4:	8a 1f                	mov    bl,BYTE PTR [edi]
100061a6:	83 c4 0c             	add    esp,0xc
100061a9:	47                   	inc    edi
100061aa:	89 7d 0c             	mov    DWORD PTR [ebp+0xc],edi
100061ad:	8d 45 ec             	lea    eax,[ebp-0x14]
100061b0:	50                   	push   eax
100061b1:	ff 75 08             	push   DWORD PTR [ebp+0x8]
100061b4:	0f be c3             	movsx  eax,bl
100061b7:	50                   	push   eax
100061b8:	e8 66 05 00 00       	call   0x10006723
100061bd:	83 c4 0c             	add    esp,0xc
100061c0:	e9 25 05 00 00       	jmp    0x100066ea
100061c5:	0f be c3             	movsx  eax,bl
100061c8:	83 f8 67             	cmp    eax,0x67
100061cb:	0f 8f 1c 02 00 00    	jg     0x100063ed
100061d1:	83 f8 65             	cmp    eax,0x65
100061d4:	0f 8d 96 00 00 00    	jge    0x10006270
100061da:	83 f8 58             	cmp    eax,0x58
100061dd:	0f 8f eb 00 00 00    	jg     0x100062ce
100061e3:	0f 84 78 02 00 00    	je     0x10006461
100061e9:	83 e8 43             	sub    eax,0x43
100061ec:	0f 84 9f 00 00 00    	je     0x10006291
100061f2:	48                   	dec    eax
100061f3:	48                   	dec    eax
100061f4:	74 70                	je     0x10006266
100061f6:	48                   	dec    eax
100061f7:	48                   	dec    eax
100061f8:	74 6c                	je     0x10006266
100061fa:	83 e8 0c             	sub    eax,0xc
100061fd:	0f 85 e9 03 00 00    	jne    0x100065ec
10006203:	66 f7 45 fc 30 08    	test   WORD PTR [ebp-0x4],0x830
10006209:	75 04                	jne    0x1000620f
1000620b:	80 4d fd 08          	or     BYTE PTR [ebp-0x3],0x8
1000620f:	8b 75 f0             	mov    esi,DWORD PTR [ebp-0x10]
10006212:	83 fe ff             	cmp    esi,0xffffffff
10006215:	75 05                	jne    0x1000621c
10006217:	be ff ff ff 7f       	mov    esi,0x7fffffff
1000621c:	8d 45 10             	lea    eax,[ebp+0x10]
1000621f:	50                   	push   eax
10006220:	e8 9c 05 00 00       	call   0x100067c1
10006225:	66 f7 45 fc 10 08    	test   WORD PTR [ebp-0x4],0x810
1000622b:	59                   	pop    ecx
1000622c:	8b c8                	mov    ecx,eax
1000622e:	89 4d f8             	mov    DWORD PTR [ebp-0x8],ecx
10006231:	0f 84 fe 01 00 00    	je     0x10006435
10006237:	85 c9                	test   ecx,ecx
10006239:	75 09                	jne    0x10006244
1000623b:	8b 0d 70 ea 00 10    	mov    ecx,DWORD PTR ds:0x1000ea70
10006241:	89 4d f8             	mov    DWORD PTR [ebp-0x8],ecx
10006244:	c7 45 dc 01 00 00 00 	mov    DWORD PTR [ebp-0x24],0x1
1000624b:	8b c1                	mov    eax,ecx
1000624d:	8b d6                	mov    edx,esi
1000624f:	4e                   	dec    esi
10006250:	85 d2                	test   edx,edx
10006252:	0f 84 d4 01 00 00    	je     0x1000642c
10006258:	66 83 38 00          	cmp    WORD PTR [eax],0x0
1000625c:	0f 84 ca 01 00 00    	je     0x1000642c
10006262:	40                   	inc    eax
10006263:	40                   	inc    eax
10006264:	eb e7                	jmp    0x1000624d
10006266:	c7 45 cc 01 00 00 00 	mov    DWORD PTR [ebp-0x34],0x1
1000626d:	80 c3 20             	add    bl,0x20
10006270:	83 4d fc 40          	or     DWORD PTR [ebp-0x4],0x40
10006274:	8d bd b8 fd ff ff    	lea    edi,[ebp-0x248]
1000627a:	3b ca                	cmp    ecx,edx
1000627c:	89 7d f8             	mov    DWORD PTR [ebp-0x8],edi
1000627f:	0f 8d cf 00 00 00    	jge    0x10006354
10006285:	c7 45 f0 06 00 00 00 	mov    DWORD PTR [ebp-0x10],0x6
1000628c:	e9 d1 00 00 00       	jmp    0x10006362
10006291:	66 f7 45 fc 30 08    	test   WORD PTR [ebp-0x4],0x830
10006297:	75 04                	jne    0x1000629d
10006299:	80 4d fd 08          	or     BYTE PTR [ebp-0x3],0x8
1000629d:	66 f7 45 fc 10 08    	test   WORD PTR [ebp-0x4],0x810
100062a3:	8d 45 10             	lea    eax,[ebp+0x10]
100062a6:	50                   	push   eax
100062a7:	74 3b                	je     0x100062e4
100062a9:	e8 30 05 00 00       	call   0x100067de
100062ae:	50                   	push   eax
100062af:	8d 85 b8 fd ff ff    	lea    eax,[ebp-0x248]
100062b5:	50                   	push   eax
100062b6:	e8 80 39 00 00       	call   0x10009c3b
100062bb:	83 c4 0c             	add    esp,0xc
100062be:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax
100062c1:	85 c0                	test   eax,eax
100062c3:	7d 32                	jge    0x100062f7
100062c5:	c7 45 d8 01 00 00 00 	mov    DWORD PTR [ebp-0x28],0x1
100062cc:	eb 29                	jmp    0x100062f7
100062ce:	83 e8 5a             	sub    eax,0x5a
100062d1:	74 32                	je     0x10006305
100062d3:	83 e8 09             	sub    eax,0x9
100062d6:	74 c5                	je     0x1000629d
100062d8:	48                   	dec    eax
100062d9:	0f 84 e8 01 00 00    	je     0x100064c7
100062df:	e9 08 03 00 00       	jmp    0x100065ec
100062e4:	e8 d8 04 00 00       	call   0x100067c1
100062e9:	59                   	pop    ecx
100062ea:	88 85 b8 fd ff ff    	mov    BYTE PTR [ebp-0x248],al
100062f0:	c7 45 f4 01 00 00 00 	mov    DWORD PTR [ebp-0xc],0x1
100062f7:	8d 85 b8 fd ff ff    	lea    eax,[ebp-0x248]
100062fd:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
10006300:	e9 e7 02 00 00       	jmp    0x100065ec
10006305:	8d 45 10             	lea    eax,[ebp+0x10]
10006308:	50                   	push   eax
10006309:	e8 b3 04 00 00       	call   0x100067c1
1000630e:	85 c0                	test   eax,eax
10006310:	59                   	pop    ecx
10006311:	74 33                	je     0x10006346
10006313:	8b 48 04             	mov    ecx,DWORD PTR [eax+0x4]
10006316:	85 c9                	test   ecx,ecx
10006318:	74 2c                	je     0x10006346
1000631a:	f6 45 fd 08          	test   BYTE PTR [ebp-0x3],0x8
1000631e:	74 17                	je     0x10006337
10006320:	0f bf 00             	movsx  eax,WORD PTR [eax]
10006323:	d1 e8                	shr    eax,1
10006325:	89 4d f8             	mov    DWORD PTR [ebp-0x8],ecx
10006328:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax
1000632b:	c7 45 dc 01 00 00 00 	mov    DWORD PTR [ebp-0x24],0x1
10006332:	e9 b5 02 00 00       	jmp    0x100065ec
10006337:	83 65 dc 00          	and    DWORD PTR [ebp-0x24],0x0
1000633b:	89 4d f8             	mov    DWORD PTR [ebp-0x8],ecx
1000633e:	0f bf 00             	movsx  eax,WORD PTR [eax]
10006341:	e9 a3 02 00 00       	jmp    0x100065e9
10006346:	a1 6c ea 00 10       	mov    eax,ds:0x1000ea6c
1000634b:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
1000634e:	50                   	push   eax
1000634f:	e9 8e 00 00 00       	jmp    0x100063e2
10006354:	75 0c                	jne    0x10006362
10006356:	80 fb 67             	cmp    bl,0x67
10006359:	75 07                	jne    0x10006362
1000635b:	c7 45 f0 01 00 00 00 	mov    DWORD PTR [ebp-0x10],0x1
10006362:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
10006365:	ff 75 cc             	push   DWORD PTR [ebp-0x34]
10006368:	83 c0 08             	add    eax,0x8
1000636b:	89 45 10             	mov    DWORD PTR [ebp+0x10],eax
1000636e:	ff 75 f0             	push   DWORD PTR [ebp-0x10]
10006371:	8b 48 f8             	mov    ecx,DWORD PTR [eax-0x8]
10006374:	89 4d b8             	mov    DWORD PTR [ebp-0x48],ecx
10006377:	8b 40 fc             	mov    eax,DWORD PTR [eax-0x4]
1000637a:	89 45 bc             	mov    DWORD PTR [ebp-0x44],eax
1000637d:	0f be c3             	movsx  eax,bl
10006380:	50                   	push   eax
10006381:	8d 85 b8 fd ff ff    	lea    eax,[ebp-0x248]
10006387:	50                   	push   eax
10006388:	8d 45 b8             	lea    eax,[ebp-0x48]
1000638b:	50                   	push   eax
1000638c:	ff 15 54 ea 00 10    	call   DWORD PTR ds:0x1000ea54
10006392:	8b 75 fc             	mov    esi,DWORD PTR [ebp-0x4]
10006395:	83 c4 14             	add    esp,0x14
10006398:	81 e6 80 00 00 00    	and    esi,0x80
1000639e:	74 14                	je     0x100063b4
100063a0:	83 7d f0 00          	cmp    DWORD PTR [ebp-0x10],0x0
100063a4:	75 0e                	jne    0x100063b4
100063a6:	8d 85 b8 fd ff ff    	lea    eax,[ebp-0x248]
100063ac:	50                   	push   eax
100063ad:	ff 15 60 ea 00 10    	call   DWORD PTR ds:0x1000ea60
100063b3:	59                   	pop    ecx
100063b4:	80 fb 67             	cmp    bl,0x67
100063b7:	75 12                	jne    0x100063cb
100063b9:	85 f6                	test   esi,esi
100063bb:	75 0e                	jne    0x100063cb
100063bd:	8d 85 b8 fd ff ff    	lea    eax,[ebp-0x248]
100063c3:	50                   	push   eax
100063c4:	ff 15 58 ea 00 10    	call   DWORD PTR ds:0x1000ea58
100063ca:	59                   	pop    ecx
100063cb:	80 bd b8 fd ff ff 2d 	cmp    BYTE PTR [ebp-0x248],0x2d
100063d2:	75 0d                	jne    0x100063e1
100063d4:	80 4d fd 01          	or     BYTE PTR [ebp-0x3],0x1
100063d8:	8d bd b9 fd ff ff    	lea    edi,[ebp-0x247]
100063de:	89 7d f8             	mov    DWORD PTR [ebp-0x8],edi
100063e1:	57                   	push   edi
100063e2:	e8 d9 24 00 00       	call   0x100088c0
100063e7:	59                   	pop    ecx
100063e8:	e9 fc 01 00 00       	jmp    0x100065e9
100063ed:	83 e8 69             	sub    eax,0x69
100063f0:	0f 84 d1 00 00 00    	je     0x100064c7
100063f6:	83 e8 05             	sub    eax,0x5
100063f9:	0f 84 9e 00 00 00    	je     0x1000649d
100063ff:	48                   	dec    eax
10006400:	0f 84 84 00 00 00    	je     0x1000648a
10006406:	48                   	dec    eax
10006407:	74 51                	je     0x1000645a
10006409:	83 e8 03             	sub    eax,0x3
1000640c:	0f 84 fd fd ff ff    	je     0x1000620f
10006412:	48                   	dec    eax
10006413:	48                   	dec    eax
10006414:	0f 84 b1 00 00 00    	je     0x100064cb
1000641a:	83 e8 03             	sub    eax,0x3
1000641d:	0f 85 c9 01 00 00    	jne    0x100065ec
10006423:	c7 45 d4 27 00 00 00 	mov    DWORD PTR [ebp-0x2c],0x27
1000642a:	eb 3c                	jmp    0x10006468
1000642c:	2b c1                	sub    eax,ecx
1000642e:	d1 f8                	sar    eax,1
10006430:	e9 b4 01 00 00       	jmp    0x100065e9
10006435:	85 c9                	test   ecx,ecx
10006437:	75 09                	jne    0x10006442
10006439:	8b 0d 6c ea 00 10    	mov    ecx,DWORD PTR ds:0x1000ea6c
1000643f:	89 4d f8             	mov    DWORD PTR [ebp-0x8],ecx
10006442:	8b c1                	mov    eax,ecx
10006444:	8b d6                	mov    edx,esi
10006446:	4e                   	dec    esi
10006447:	85 d2                	test   edx,edx
10006449:	74 08                	je     0x10006453
1000644b:	80 38 00             	cmp    BYTE PTR [eax],0x0
1000644e:	74 03                	je     0x10006453
10006450:	40                   	inc    eax
10006451:	eb f1                	jmp    0x10006444
10006453:	2b c1                	sub    eax,ecx
10006455:	e9 8f 01 00 00       	jmp    0x100065e9
1000645a:	c7 45 f0 08 00 00 00 	mov    DWORD PTR [ebp-0x10],0x8
10006461:	c7 45 d4 07 00 00 00 	mov    DWORD PTR [ebp-0x2c],0x7
10006468:	f6 45 fc 80          	test   BYTE PTR [ebp-0x4],0x80
1000646c:	c7 45 f4 10 00 00 00 	mov    DWORD PTR [ebp-0xc],0x10
10006473:	74 5d                	je     0x100064d2
10006475:	8a 45 d4             	mov    al,BYTE PTR [ebp-0x2c]
10006478:	c6 45 ea 30          	mov    BYTE PTR [ebp-0x16],0x30
1000647c:	04 51                	add    al,0x51
1000647e:	c7 45 e4 02 00 00 00 	mov    DWORD PTR [ebp-0x1c],0x2
10006485:	88 45 eb             	mov    BYTE PTR [ebp-0x15],al
10006488:	eb 48                	jmp    0x100064d2
1000648a:	f6 45 fc 80          	test   BYTE PTR [ebp-0x4],0x80
1000648e:	c7 45 f4 08 00 00 00 	mov    DWORD PTR [ebp-0xc],0x8
10006495:	74 3b                	je     0x100064d2
10006497:	80 4d fd 02          	or     BYTE PTR [ebp-0x3],0x2
1000649b:	eb 35                	jmp    0x100064d2
1000649d:	8d 45 10             	lea    eax,[ebp+0x10]
100064a0:	50                   	push   eax
100064a1:	e8 1b 03 00 00       	call   0x100067c1
100064a6:	f6 45 fc 20          	test   BYTE PTR [ebp-0x4],0x20
100064aa:	59                   	pop    ecx
100064ab:	74 09                	je     0x100064b6
100064ad:	66 8b 4d ec          	mov    cx,WORD PTR [ebp-0x14]
100064b1:	66 89 08             	mov    WORD PTR [eax],cx
100064b4:	eb 05                	jmp    0x100064bb
100064b6:	8b 4d ec             	mov    ecx,DWORD PTR [ebp-0x14]
100064b9:	89 08                	mov    DWORD PTR [eax],ecx
100064bb:	c7 45 d8 01 00 00 00 	mov    DWORD PTR [ebp-0x28],0x1
100064c2:	e9 23 02 00 00       	jmp    0x100066ea
100064c7:	83 4d fc 40          	or     DWORD PTR [ebp-0x4],0x40
100064cb:	c7 45 f4 0a 00 00 00 	mov    DWORD PTR [ebp-0xc],0xa
100064d2:	f6 45 fd 80          	test   BYTE PTR [ebp-0x3],0x80
100064d6:	74 0c                	je     0x100064e4
100064d8:	8d 45 10             	lea    eax,[ebp+0x10]
100064db:	50                   	push   eax
100064dc:	e8 ed 02 00 00       	call   0x100067ce
100064e1:	59                   	pop    ecx
100064e2:	eb 41                	jmp    0x10006525
100064e4:	f6 45 fc 20          	test   BYTE PTR [ebp-0x4],0x20
100064e8:	74 21                	je     0x1000650b
100064ea:	f6 45 fc 40          	test   BYTE PTR [ebp-0x4],0x40
100064ee:	8d 45 10             	lea    eax,[ebp+0x10]
100064f1:	50                   	push   eax
100064f2:	74 0c                	je     0x10006500
100064f4:	e8 c8 02 00 00       	call   0x100067c1
100064f9:	59                   	pop    ecx
100064fa:	0f bf c0             	movsx  eax,ax
100064fd:	99                   	cdq
100064fe:	eb 25                	jmp    0x10006525
10006500:	e8 bc 02 00 00       	call   0x100067c1
10006505:	59                   	pop    ecx
10006506:	0f b7 c0             	movzx  eax,ax
10006509:	eb f2                	jmp    0x100064fd
1000650b:	f6 45 fc 40          	test   BYTE PTR [ebp-0x4],0x40
1000650f:	8d 45 10             	lea    eax,[ebp+0x10]
10006512:	50                   	push   eax
10006513:	74 08                	je     0x1000651d
10006515:	e8 a7 02 00 00       	call   0x100067c1
1000651a:	59                   	pop    ecx
1000651b:	eb e0                	jmp    0x100064fd
1000651d:	e8 9f 02 00 00       	call   0x100067c1
10006522:	59                   	pop    ecx
10006523:	33 d2                	xor    edx,edx
10006525:	f6 45 fc 40          	test   BYTE PTR [ebp-0x4],0x40
10006529:	74 1b                	je     0x10006546
1000652b:	85 d2                	test   edx,edx
1000652d:	7f 17                	jg     0x10006546
1000652f:	7c 04                	jl     0x10006535
10006531:	85 c0                	test   eax,eax
10006533:	73 11                	jae    0x10006546
10006535:	f7 d8                	neg    eax
10006537:	83 d2 00             	adc    edx,0x0
1000653a:	8b f0                	mov    esi,eax
1000653c:	f7 da                	neg    edx
1000653e:	80 4d fd 01          	or     BYTE PTR [ebp-0x3],0x1
10006542:	8b fa                	mov    edi,edx
10006544:	eb 04                	jmp    0x1000654a
10006546:	8b f0                	mov    esi,eax
10006548:	8b fa                	mov    edi,edx
1000654a:	f6 45 fd 80          	test   BYTE PTR [ebp-0x3],0x80
1000654e:	75 03                	jne    0x10006553
10006550:	83 e7 00             	and    edi,0x0
10006553:	83 7d f0 00          	cmp    DWORD PTR [ebp-0x10],0x0
10006557:	7d 09                	jge    0x10006562
10006559:	c7 45 f0 01 00 00 00 	mov    DWORD PTR [ebp-0x10],0x1
10006560:	eb 04                	jmp    0x10006566
10006562:	83 65 fc f7          	and    DWORD PTR [ebp-0x4],0xfffffff7
10006566:	8b c6                	mov    eax,esi
10006568:	0b c7                	or     eax,edi
1000656a:	75 04                	jne    0x10006570
1000656c:	83 65 e4 00          	and    DWORD PTR [ebp-0x1c],0x0
10006570:	8d 45 b7             	lea    eax,[ebp-0x49]
10006573:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
10006576:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
10006579:	ff 4d f0             	dec    DWORD PTR [ebp-0x10]
1000657c:	85 c0                	test   eax,eax
1000657e:	7f 06                	jg     0x10006586
10006580:	8b c6                	mov    eax,esi
10006582:	0b c7                	or     eax,edi
10006584:	74 3b                	je     0x100065c1
10006586:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
10006589:	99                   	cdq
1000658a:	52                   	push   edx
1000658b:	50                   	push   eax
1000658c:	57                   	push   edi
1000658d:	56                   	push   esi
1000658e:	89 45 c0             	mov    DWORD PTR [ebp-0x40],eax
10006591:	89 55 c4             	mov    DWORD PTR [ebp-0x3c],edx
10006594:	e8 87 37 00 00       	call   0x10009d20
10006599:	ff 75 c4             	push   DWORD PTR [ebp-0x3c]
1000659c:	8b d8                	mov    ebx,eax
1000659e:	83 c3 30             	add    ebx,0x30
100065a1:	ff 75 c0             	push   DWORD PTR [ebp-0x40]
100065a4:	57                   	push   edi
100065a5:	56                   	push   esi
100065a6:	e8 05 37 00 00       	call   0x10009cb0
100065ab:	83 fb 39             	cmp    ebx,0x39
100065ae:	8b f0                	mov    esi,eax
100065b0:	8b fa                	mov    edi,edx
100065b2:	7e 03                	jle    0x100065b7
100065b4:	03 5d d4             	add    ebx,DWORD PTR [ebp-0x2c]
100065b7:	8b 45 f8             	mov    eax,DWORD PTR [ebp-0x8]
100065ba:	ff 4d f8             	dec    DWORD PTR [ebp-0x8]
100065bd:	88 18                	mov    BYTE PTR [eax],bl
100065bf:	eb b5                	jmp    0x10006576
100065c1:	8d 45 b7             	lea    eax,[ebp-0x49]
100065c4:	2b 45 f8             	sub    eax,DWORD PTR [ebp-0x8]
100065c7:	ff 45 f8             	inc    DWORD PTR [ebp-0x8]
100065ca:	f6 45 fd 02          	test   BYTE PTR [ebp-0x3],0x2
100065ce:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax
100065d1:	74 19                	je     0x100065ec
100065d3:	8b 4d f8             	mov    ecx,DWORD PTR [ebp-0x8]
100065d6:	80 39 30             	cmp    BYTE PTR [ecx],0x30
100065d9:	75 04                	jne    0x100065df
100065db:	85 c0                	test   eax,eax
100065dd:	75 0d                	jne    0x100065ec
100065df:	ff 4d f8             	dec    DWORD PTR [ebp-0x8]
100065e2:	40                   	inc    eax
100065e3:	8b 4d f8             	mov    ecx,DWORD PTR [ebp-0x8]
100065e6:	c6 01 30             	mov    BYTE PTR [ecx],0x30
100065e9:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax
100065ec:	83 7d d8 00          	cmp    DWORD PTR [ebp-0x28],0x0
100065f0:	0f 85 f4 00 00 00    	jne    0x100066ea
100065f6:	8b 5d fc             	mov    ebx,DWORD PTR [ebp-0x4]
100065f9:	f6 c3 40             	test   bl,0x40
100065fc:	74 26                	je     0x10006624
100065fe:	f6 c7 01             	test   bh,0x1
10006601:	74 06                	je     0x10006609
10006603:	c6 45 ea 2d          	mov    BYTE PTR [ebp-0x16],0x2d
10006607:	eb 14                	jmp    0x1000661d
10006609:	f6 c3 01             	test   bl,0x1
1000660c:	74 06                	je     0x10006614
1000660e:	c6 45 ea 2b          	mov    BYTE PTR [ebp-0x16],0x2b
10006612:	eb 09                	jmp    0x1000661d
10006614:	f6 c3 02             	test   bl,0x2
10006617:	74 0b                	je     0x10006624
10006619:	c6 45 ea 20          	mov    BYTE PTR [ebp-0x16],0x20
1000661d:	c7 45 e4 01 00 00 00 	mov    DWORD PTR [ebp-0x1c],0x1
10006624:	8b 75 e0             	mov    esi,DWORD PTR [ebp-0x20]
10006627:	2b 75 e4             	sub    esi,DWORD PTR [ebp-0x1c]
1000662a:	2b 75 f4             	sub    esi,DWORD PTR [ebp-0xc]
1000662d:	f6 c3 0c             	test   bl,0xc
10006630:	75 12                	jne    0x10006644
10006632:	8d 45 ec             	lea    eax,[ebp-0x14]
10006635:	50                   	push   eax
10006636:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10006639:	56                   	push   esi
1000663a:	6a 20                	push   0x20
1000663c:	e8 17 01 00 00       	call   0x10006758
10006641:	83 c4 10             	add    esp,0x10
10006644:	8d 45 ec             	lea    eax,[ebp-0x14]
10006647:	50                   	push   eax
10006648:	8d 45 ea             	lea    eax,[ebp-0x16]
1000664b:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000664e:	ff 75 e4             	push   DWORD PTR [ebp-0x1c]
10006651:	50                   	push   eax
10006652:	e8 32 01 00 00       	call   0x10006789
10006657:	83 c4 10             	add    esp,0x10
1000665a:	f6 c3 08             	test   bl,0x8
1000665d:	74 17                	je     0x10006676
1000665f:	f6 c3 04             	test   bl,0x4
10006662:	75 12                	jne    0x10006676
10006664:	8d 45 ec             	lea    eax,[ebp-0x14]
10006667:	50                   	push   eax
10006668:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000666b:	56                   	push   esi
1000666c:	6a 30                	push   0x30
1000666e:	e8 e5 00 00 00       	call   0x10006758
10006673:	83 c4 10             	add    esp,0x10
10006676:	83 7d dc 00          	cmp    DWORD PTR [ebp-0x24],0x0
1000667a:	74 41                	je     0x100066bd
1000667c:	83 7d f4 00          	cmp    DWORD PTR [ebp-0xc],0x0
10006680:	7e 3b                	jle    0x100066bd
10006682:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
10006685:	8b 5d f8             	mov    ebx,DWORD PTR [ebp-0x8]
10006688:	8d 78 ff             	lea    edi,[eax-0x1]
1000668b:	66 8b 03             	mov    ax,WORD PTR [ebx]
1000668e:	43                   	inc    ebx
1000668f:	50                   	push   eax
10006690:	8d 45 c8             	lea    eax,[ebp-0x38]
10006693:	50                   	push   eax
10006694:	43                   	inc    ebx
10006695:	e8 a1 35 00 00       	call   0x10009c3b
1000669a:	59                   	pop    ecx
1000669b:	85 c0                	test   eax,eax
1000669d:	59                   	pop    ecx
1000669e:	7e 32                	jle    0x100066d2
100066a0:	8d 4d ec             	lea    ecx,[ebp-0x14]
100066a3:	51                   	push   ecx
100066a4:	ff 75 08             	push   DWORD PTR [ebp+0x8]
100066a7:	50                   	push   eax
100066a8:	8d 45 c8             	lea    eax,[ebp-0x38]
100066ab:	50                   	push   eax
100066ac:	e8 d8 00 00 00       	call   0x10006789
100066b1:	83 c4 10             	add    esp,0x10
100066b4:	8b c7                	mov    eax,edi
100066b6:	4f                   	dec    edi
100066b7:	85 c0                	test   eax,eax
100066b9:	75 d0                	jne    0x1000668b
100066bb:	eb 15                	jmp    0x100066d2
100066bd:	8d 45 ec             	lea    eax,[ebp-0x14]
100066c0:	50                   	push   eax
100066c1:	ff 75 08             	push   DWORD PTR [ebp+0x8]
100066c4:	ff 75 f4             	push   DWORD PTR [ebp-0xc]
100066c7:	ff 75 f8             	push   DWORD PTR [ebp-0x8]
100066ca:	e8 ba 00 00 00       	call   0x10006789
100066cf:	83 c4 10             	add    esp,0x10
100066d2:	f6 45 fc 04          	test   BYTE PTR [ebp-0x4],0x4
100066d6:	74 12                	je     0x100066ea
100066d8:	8d 45 ec             	lea    eax,[ebp-0x14]
100066db:	50                   	push   eax
100066dc:	ff 75 08             	push   DWORD PTR [ebp+0x8]
100066df:	56                   	push   esi
100066e0:	6a 20                	push   0x20
100066e2:	e8 71 00 00 00       	call   0x10006758
100066e7:	83 c4 10             	add    esp,0x10
100066ea:	8b 7d 0c             	mov    edi,DWORD PTR [ebp+0xc]
100066ed:	8a 1f                	mov    bl,BYTE PTR [edi]
100066ef:	47                   	inc    edi
100066f0:	84 db                	test   bl,bl
100066f2:	89 7d 0c             	mov    DWORD PTR [ebp+0xc],edi
100066f5:	0f 85 13 f9 ff ff    	jne    0x1000600e
100066fb:	8b 45 ec             	mov    eax,DWORD PTR [ebp-0x14]
100066fe:	5f                   	pop    edi
100066ff:	5e                   	pop    esi
10006700:	5b                   	pop    ebx
10006701:	c9                   	leave
10006702:	c3                   	ret
10006703:	81 61 00 10 57 60 00 	and    DWORD PTR [ecx+0x0],0x605710
1000670a:	10 72 60             	adc    BYTE PTR [edx+0x60],dh
1000670d:	00 10                	add    BYTE PTR [eax],dl
1000670f:	be 60 00 10 f5       	mov    esi,0xf5100060
10006714:	60                   	pusha
10006715:	00 10                	add    BYTE PTR [eax],dl
10006717:	fd                   	std
10006718:	60                   	pusha
10006719:	00 10                	add    BYTE PTR [eax],dl
1000671b:	32 61 00             	xor    ah,BYTE PTR [ecx+0x0]
1000671e:	10 c5                	adc    ch,al
10006720:	61                   	popa
10006721:	00 10                	add    BYTE PTR [eax],dl
10006723:	55                   	push   ebp
10006724:	8b ec                	mov    ebp,esp
10006726:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
10006729:	ff 49 04             	dec    DWORD PTR [ecx+0x4]
1000672c:	78 0e                	js     0x1000673c
1000672e:	8b 11                	mov    edx,DWORD PTR [ecx]
10006730:	8a 45 08             	mov    al,BYTE PTR [ebp+0x8]
10006733:	88 02                	mov    BYTE PTR [edx],al
10006735:	ff 01                	inc    DWORD PTR [ecx]
10006737:	0f b6 c0             	movzx  eax,al
1000673a:	eb 0b                	jmp    0x10006747
1000673c:	51                   	push   ecx
1000673d:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10006740:	e8 88 f7 ff ff       	call   0x10005ecd
10006745:	59                   	pop    ecx
10006746:	59                   	pop    ecx
10006747:	83 f8 ff             	cmp    eax,0xffffffff
1000674a:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
1000674d:	75 05                	jne    0x10006754
1000674f:	83 08 ff             	or     DWORD PTR [eax],0xffffffff
10006752:	5d                   	pop    ebp
10006753:	c3                   	ret
10006754:	ff 00                	inc    DWORD PTR [eax]
10006756:	5d                   	pop    ebp
10006757:	c3                   	ret
10006758:	56                   	push   esi
10006759:	57                   	push   edi
1000675a:	8b 7c 24 10          	mov    edi,DWORD PTR [esp+0x10]
1000675e:	8b c7                	mov    eax,edi
10006760:	4f                   	dec    edi
10006761:	85 c0                	test   eax,eax
10006763:	7e 21                	jle    0x10006786
10006765:	8b 74 24 18          	mov    esi,DWORD PTR [esp+0x18]
10006769:	56                   	push   esi
1000676a:	ff 74 24 18          	push   DWORD PTR [esp+0x18]
1000676e:	ff 74 24 14          	push   DWORD PTR [esp+0x14]
10006772:	e8 ac ff ff ff       	call   0x10006723
10006777:	83 c4 0c             	add    esp,0xc
1000677a:	83 3e ff             	cmp    DWORD PTR [esi],0xffffffff
1000677d:	74 07                	je     0x10006786
1000677f:	8b c7                	mov    eax,edi
10006781:	4f                   	dec    edi
10006782:	85 c0                	test   eax,eax
10006784:	7f e3                	jg     0x10006769
10006786:	5f                   	pop    edi
10006787:	5e                   	pop    esi
10006788:	c3                   	ret
10006789:	53                   	push   ebx
1000678a:	8b 5c 24 0c          	mov    ebx,DWORD PTR [esp+0xc]
1000678e:	8b c3                	mov    eax,ebx
10006790:	4b                   	dec    ebx
10006791:	56                   	push   esi
10006792:	57                   	push   edi
10006793:	85 c0                	test   eax,eax
10006795:	7e 26                	jle    0x100067bd
10006797:	8b 7c 24 1c          	mov    edi,DWORD PTR [esp+0x1c]
1000679b:	8b 74 24 10          	mov    esi,DWORD PTR [esp+0x10]
1000679f:	0f be 06             	movsx  eax,BYTE PTR [esi]
100067a2:	57                   	push   edi
100067a3:	46                   	inc    esi
100067a4:	ff 74 24 1c          	push   DWORD PTR [esp+0x1c]
100067a8:	50                   	push   eax
100067a9:	e8 75 ff ff ff       	call   0x10006723
100067ae:	83 c4 0c             	add    esp,0xc
100067b1:	83 3f ff             	cmp    DWORD PTR [edi],0xffffffff
100067b4:	74 07                	je     0x100067bd
100067b6:	8b c3                	mov    eax,ebx
100067b8:	4b                   	dec    ebx
100067b9:	85 c0                	test   eax,eax
100067bb:	7f e2                	jg     0x1000679f
100067bd:	5f                   	pop    edi
100067be:	5e                   	pop    esi
100067bf:	5b                   	pop    ebx
100067c0:	c3                   	ret
100067c1:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
100067c5:	83 00 04             	add    DWORD PTR [eax],0x4
100067c8:	8b 00                	mov    eax,DWORD PTR [eax]
100067ca:	8b 40 fc             	mov    eax,DWORD PTR [eax-0x4]
100067cd:	c3                   	ret
100067ce:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
100067d2:	83 00 08             	add    DWORD PTR [eax],0x8
100067d5:	8b 08                	mov    ecx,DWORD PTR [eax]
100067d7:	8b 41 f8             	mov    eax,DWORD PTR [ecx-0x8]
100067da:	8b 51 fc             	mov    edx,DWORD PTR [ecx-0x4]
100067dd:	c3                   	ret
100067de:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
100067e2:	83 00 04             	add    DWORD PTR [eax],0x4
100067e5:	8b 00                	mov    eax,DWORD PTR [eax]
100067e7:	66 8b 40 fc          	mov    ax,WORD PTR [eax-0x4]
100067eb:	c3                   	ret
100067ec:	55                   	push   ebp
100067ed:	8b ec                	mov    ebp,esp
100067ef:	56                   	push   esi
100067f0:	8b 75 18             	mov    esi,DWORD PTR [ebp+0x18]
100067f3:	57                   	push   edi
100067f4:	bf 20 05 93 19       	mov    edi,0x19930520
100067f9:	39 3e                	cmp    DWORD PTR [esi],edi
100067fb:	74 05                	je     0x10006802
100067fd:	e8 a0 08 00 00       	call   0x100070a2
10006802:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10006805:	f6 40 04 66          	test   BYTE PTR [eax+0x4],0x66
10006809:	74 1f                	je     0x1000682a
1000680b:	83 7e 04 00          	cmp    DWORD PTR [esi+0x4],0x0
1000680f:	74 6f                	je     0x10006880
10006811:	83 7d 1c 00          	cmp    DWORD PTR [ebp+0x1c],0x0
10006815:	75 69                	jne    0x10006880
10006817:	6a ff                	push   0xffffffff
10006819:	56                   	push   esi
1000681a:	ff 75 14             	push   DWORD PTR [ebp+0x14]
1000681d:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
10006820:	e8 0e 03 00 00       	call   0x10006b33
10006825:	83 c4 10             	add    esp,0x10
10006828:	eb 56                	jmp    0x10006880
1000682a:	83 7e 0c 00          	cmp    DWORD PTR [esi+0xc],0x0
1000682e:	74 50                	je     0x10006880
10006830:	81 38 63 73 6d e0    	cmp    DWORD PTR [eax],0xe06d7363
10006836:	75 2c                	jne    0x10006864
10006838:	39 78 14             	cmp    DWORD PTR [eax+0x14],edi
1000683b:	76 27                	jbe    0x10006864
1000683d:	8b 48 1c             	mov    ecx,DWORD PTR [eax+0x1c]
10006840:	8b 49 08             	mov    ecx,DWORD PTR [ecx+0x8]
10006843:	85 c9                	test   ecx,ecx
10006845:	74 1d                	je     0x10006864
10006847:	0f b6 55 24          	movzx  edx,BYTE PTR [ebp+0x24]
1000684b:	52                   	push   edx
1000684c:	ff 75 20             	push   DWORD PTR [ebp+0x20]
1000684f:	ff 75 1c             	push   DWORD PTR [ebp+0x1c]
10006852:	56                   	push   esi
10006853:	ff 75 14             	push   DWORD PTR [ebp+0x14]
10006856:	ff 75 10             	push   DWORD PTR [ebp+0x10]
10006859:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
1000685c:	50                   	push   eax
1000685d:	ff d1                	call   ecx
1000685f:	83 c4 20             	add    esp,0x20
10006862:	eb 1f                	jmp    0x10006883
10006864:	ff 75 20             	push   DWORD PTR [ebp+0x20]
10006867:	ff 75 1c             	push   DWORD PTR [ebp+0x1c]
1000686a:	ff 75 24             	push   DWORD PTR [ebp+0x24]
1000686d:	56                   	push   esi
1000686e:	ff 75 14             	push   DWORD PTR [ebp+0x14]
10006871:	ff 75 10             	push   DWORD PTR [ebp+0x10]
10006874:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
10006877:	50                   	push   eax
10006878:	e8 0a 00 00 00       	call   0x10006887
1000687d:	83 c4 20             	add    esp,0x20
10006880:	6a 01                	push   0x1
10006882:	58                   	pop    eax
10006883:	5f                   	pop    edi
10006884:	5e                   	pop    esi
10006885:	5d                   	pop    ebp
10006886:	c3                   	ret
10006887:	55                   	push   ebp
10006888:	8b ec                	mov    ebp,esp
1000688a:	83 ec 18             	sub    esp,0x18
1000688d:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10006890:	80 65 ec 00          	and    BYTE PTR [ebp-0x14],0x0
10006894:	8b 40 08             	mov    eax,DWORD PTR [eax+0x8]
10006897:	83 f8 ff             	cmp    eax,0xffffffff
1000689a:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax
1000689d:	7c 08                	jl     0x100068a7
1000689f:	8b 4d 18             	mov    ecx,DWORD PTR [ebp+0x18]
100068a2:	3b 41 04             	cmp    eax,DWORD PTR [ecx+0x4]
100068a5:	7c 05                	jl     0x100068ac
100068a7:	e8 f6 07 00 00       	call   0x100070a2
100068ac:	53                   	push   ebx
100068ad:	56                   	push   esi
100068ae:	8b 75 08             	mov    esi,DWORD PTR [ebp+0x8]
100068b1:	bb 63 73 6d e0       	mov    ebx,0xe06d7363
100068b6:	57                   	push   edi
100068b7:	bf 20 05 93 19       	mov    edi,0x19930520
100068bc:	39 1e                	cmp    DWORD PTR [esi],ebx
100068be:	0f 85 3f 01 00 00    	jne    0x10006a03
100068c4:	83 7e 10 03          	cmp    DWORD PTR [esi+0x10],0x3
100068c8:	75 56                	jne    0x10006920
100068ca:	39 7e 14             	cmp    DWORD PTR [esi+0x14],edi
100068cd:	75 51                	jne    0x10006920
100068cf:	83 7e 1c 00          	cmp    DWORD PTR [esi+0x1c],0x0
100068d3:	75 4b                	jne    0x10006920
100068d5:	8b 35 3c f6 00 10    	mov    esi,DWORD PTR ds:0x1000f63c
100068db:	85 f6                	test   esi,esi
100068dd:	0f 84 1b 01 00 00    	je     0x100069fe
100068e3:	a1 40 f6 00 10       	mov    eax,ds:0x1000f640
100068e8:	6a 01                	push   0x1
100068ea:	56                   	push   esi
100068eb:	89 45 10             	mov    DWORD PTR [ebp+0x10],eax
100068ee:	c6 45 ec 01          	mov    BYTE PTR [ebp-0x14],0x1
100068f2:	e8 02 35 00 00       	call   0x10009df9
100068f7:	59                   	pop    ecx
100068f8:	85 c0                	test   eax,eax
100068fa:	59                   	pop    ecx
100068fb:	75 05                	jne    0x10006902
100068fd:	e8 a0 07 00 00       	call   0x100070a2
10006902:	39 1e                	cmp    DWORD PTR [esi],ebx
10006904:	0f 85 f9 00 00 00    	jne    0x10006a03
1000690a:	83 7e 10 03          	cmp    DWORD PTR [esi+0x10],0x3
1000690e:	75 10                	jne    0x10006920
10006910:	39 7e 14             	cmp    DWORD PTR [esi+0x14],edi
10006913:	75 0b                	jne    0x10006920
10006915:	83 7e 1c 00          	cmp    DWORD PTR [esi+0x1c],0x0
10006919:	75 05                	jne    0x10006920
1000691b:	e8 82 07 00 00       	call   0x100070a2
10006920:	39 1e                	cmp    DWORD PTR [esi],ebx
10006922:	0f 85 db 00 00 00    	jne    0x10006a03
10006928:	83 7e 10 03          	cmp    DWORD PTR [esi+0x10],0x3
1000692c:	0f 85 d1 00 00 00    	jne    0x10006a03
10006932:	39 7e 14             	cmp    DWORD PTR [esi+0x14],edi
10006935:	0f 85 c8 00 00 00    	jne    0x10006a03
1000693b:	8b 7d f0             	mov    edi,DWORD PTR [ebp-0x10]
1000693e:	8d 45 e8             	lea    eax,[ebp-0x18]
10006941:	50                   	push   eax
10006942:	8d 45 fc             	lea    eax,[ebp-0x4]
10006945:	50                   	push   eax
10006946:	57                   	push   edi
10006947:	ff 75 20             	push   DWORD PTR [ebp+0x20]
1000694a:	ff 75 18             	push   DWORD PTR [ebp+0x18]
1000694d:	e8 3a eb ff ff       	call   0x1000548c
10006952:	83 c4 14             	add    esp,0x14
10006955:	8b d8                	mov    ebx,eax
10006957:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
1000695a:	3b 45 e8             	cmp    eax,DWORD PTR [ebp-0x18]
1000695d:	0f 83 8b 00 00 00    	jae    0x100069ee
10006963:	39 3b                	cmp    DWORD PTR [ebx],edi
10006965:	7f 7c                	jg     0x100069e3
10006967:	3b 7b 04             	cmp    edi,DWORD PTR [ebx+0x4]
1000696a:	7f 77                	jg     0x100069e3
1000696c:	8b 43 10             	mov    eax,DWORD PTR [ebx+0x10]
1000696f:	89 45 08             	mov    DWORD PTR [ebp+0x8],eax
10006972:	8b 43 0c             	mov    eax,DWORD PTR [ebx+0xc]
10006975:	85 c0                	test   eax,eax
10006977:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax
1000697a:	7e 64                	jle    0x100069e0
1000697c:	8b 46 1c             	mov    eax,DWORD PTR [esi+0x1c]
1000697f:	8b 40 0c             	mov    eax,DWORD PTR [eax+0xc]
10006982:	8d 78 04             	lea    edi,[eax+0x4]
10006985:	8b 00                	mov    eax,DWORD PTR [eax]
10006987:	85 c0                	test   eax,eax
10006989:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
1000698c:	7e 1f                	jle    0x100069ad
1000698e:	ff 76 1c             	push   DWORD PTR [esi+0x1c]
10006991:	ff 37                	push   DWORD PTR [edi]
10006993:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10006996:	e8 3b 01 00 00       	call   0x10006ad6
1000699b:	83 c4 0c             	add    esp,0xc
1000699e:	85 c0                	test   eax,eax
100069a0:	75 1a                	jne    0x100069bc
100069a2:	ff 4d f8             	dec    DWORD PTR [ebp-0x8]
100069a5:	83 c7 04             	add    edi,0x4
100069a8:	39 45 f8             	cmp    DWORD PTR [ebp-0x8],eax
100069ab:	7f e1                	jg     0x1000698e
100069ad:	ff 4d f4             	dec    DWORD PTR [ebp-0xc]
100069b0:	83 45 08 10          	add    DWORD PTR [ebp+0x8],0x10
100069b4:	83 7d f4 00          	cmp    DWORD PTR [ebp-0xc],0x0
100069b8:	7f c2                	jg     0x1000697c
100069ba:	eb 24                	jmp    0x100069e0
100069bc:	ff 75 ec             	push   DWORD PTR [ebp-0x14]
100069bf:	ff 75 24             	push   DWORD PTR [ebp+0x24]
100069c2:	ff 75 20             	push   DWORD PTR [ebp+0x20]
100069c5:	53                   	push   ebx
100069c6:	ff 37                	push   DWORD PTR [edi]
100069c8:	ff 75 08             	push   DWORD PTR [ebp+0x8]
100069cb:	ff 75 18             	push   DWORD PTR [ebp+0x18]
100069ce:	ff 75 14             	push   DWORD PTR [ebp+0x14]
100069d1:	ff 75 10             	push   DWORD PTR [ebp+0x10]
100069d4:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
100069d7:	56                   	push   esi
100069d8:	e8 0a 02 00 00       	call   0x10006be7
100069dd:	83 c4 2c             	add    esp,0x2c
100069e0:	8b 7d f0             	mov    edi,DWORD PTR [ebp-0x10]
100069e3:	ff 45 fc             	inc    DWORD PTR [ebp-0x4]
100069e6:	83 c3 14             	add    ebx,0x14
100069e9:	e9 69 ff ff ff       	jmp    0x10006957
100069ee:	80 7d 1c 00          	cmp    BYTE PTR [ebp+0x1c],0x0
100069f2:	74 0a                	je     0x100069fe
100069f4:	6a 01                	push   0x1
100069f6:	56                   	push   esi
100069f7:	e8 60 05 00 00       	call   0x10006f5c
100069fc:	59                   	pop    ecx
100069fd:	59                   	pop    ecx
100069fe:	5f                   	pop    edi
100069ff:	5e                   	pop    esi
10006a00:	5b                   	pop    ebx
10006a01:	c9                   	leave
10006a02:	c3                   	ret
10006a03:	80 7d 1c 00          	cmp    BYTE PTR [ebp+0x1c],0x0
10006a07:	75 20                	jne    0x10006a29
10006a09:	ff 75 24             	push   DWORD PTR [ebp+0x24]
10006a0c:	ff 75 20             	push   DWORD PTR [ebp+0x20]
10006a0f:	ff 75 f0             	push   DWORD PTR [ebp-0x10]
10006a12:	ff 75 18             	push   DWORD PTR [ebp+0x18]
10006a15:	ff 75 14             	push   DWORD PTR [ebp+0x14]
10006a18:	ff 75 10             	push   DWORD PTR [ebp+0x10]
10006a1b:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
10006a1e:	56                   	push   esi
10006a1f:	e8 0a 00 00 00       	call   0x10006a2e
10006a24:	83 c4 20             	add    esp,0x20
10006a27:	eb d5                	jmp    0x100069fe
10006a29:	e9 0e 06 00 00       	jmp    0x1000703c
10006a2e:	55                   	push   ebp
10006a2f:	8b ec                	mov    ebp,esp
10006a31:	51                   	push   ecx
10006a32:	51                   	push   ecx
10006a33:	83 3d 44 f6 00 10 00 	cmp    DWORD PTR ds:0x1000f644,0x0
10006a3a:	56                   	push   esi
10006a3b:	57                   	push   edi
10006a3c:	74 21                	je     0x10006a5f
10006a3e:	ff 75 24             	push   DWORD PTR [ebp+0x24]
10006a41:	ff 75 20             	push   DWORD PTR [ebp+0x20]
10006a44:	ff 75 18             	push   DWORD PTR [ebp+0x18]
10006a47:	ff 75 14             	push   DWORD PTR [ebp+0x14]
10006a4a:	ff 75 10             	push   DWORD PTR [ebp+0x10]
10006a4d:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
10006a50:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10006a53:	e8 0b e9 ff ff       	call   0x10005363
10006a58:	83 c4 1c             	add    esp,0x1c
10006a5b:	85 c0                	test   eax,eax
10006a5d:	75 73                	jne    0x10006ad2
10006a5f:	8b 7d 1c             	mov    edi,DWORD PTR [ebp+0x1c]
10006a62:	8d 45 f8             	lea    eax,[ebp-0x8]
10006a65:	50                   	push   eax
10006a66:	8d 45 fc             	lea    eax,[ebp-0x4]
10006a69:	50                   	push   eax
10006a6a:	57                   	push   edi
10006a6b:	ff 75 20             	push   DWORD PTR [ebp+0x20]
10006a6e:	ff 75 18             	push   DWORD PTR [ebp+0x18]
10006a71:	e8 16 ea ff ff       	call   0x1000548c
10006a76:	83 c4 14             	add    esp,0x14
10006a79:	8b f0                	mov    esi,eax
10006a7b:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
10006a7e:	3b 45 f8             	cmp    eax,DWORD PTR [ebp-0x8]
10006a81:	73 4f                	jae    0x10006ad2
10006a83:	3b 3e                	cmp    edi,DWORD PTR [esi]
10006a85:	7c 43                	jl     0x10006aca
10006a87:	3b 7e 04             	cmp    edi,DWORD PTR [esi+0x4]
10006a8a:	7f 3e                	jg     0x10006aca
10006a8c:	8b 46 0c             	mov    eax,DWORD PTR [esi+0xc]
10006a8f:	8b 4e 10             	mov    ecx,DWORD PTR [esi+0x10]
10006a92:	c1 e0 04             	shl    eax,0x4
10006a95:	03 c1                	add    eax,ecx
10006a97:	8b 48 f4             	mov    ecx,DWORD PTR [eax-0xc]
10006a9a:	85 c9                	test   ecx,ecx
10006a9c:	74 06                	je     0x10006aa4
10006a9e:	80 79 08 00          	cmp    BYTE PTR [ecx+0x8],0x0
10006aa2:	75 26                	jne    0x10006aca
10006aa4:	6a 01                	push   0x1
10006aa6:	83 c0 f0             	add    eax,0xfffffff0
10006aa9:	ff 75 24             	push   DWORD PTR [ebp+0x24]
10006aac:	ff 75 20             	push   DWORD PTR [ebp+0x20]
10006aaf:	56                   	push   esi
10006ab0:	6a 00                	push   0x0
10006ab2:	50                   	push   eax
10006ab3:	ff 75 18             	push   DWORD PTR [ebp+0x18]
10006ab6:	ff 75 14             	push   DWORD PTR [ebp+0x14]
10006ab9:	ff 75 10             	push   DWORD PTR [ebp+0x10]
10006abc:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
10006abf:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10006ac2:	e8 20 01 00 00       	call   0x10006be7
10006ac7:	83 c4 2c             	add    esp,0x2c
10006aca:	ff 45 fc             	inc    DWORD PTR [ebp-0x4]
10006acd:	83 c6 14             	add    esi,0x14
10006ad0:	eb a9                	jmp    0x10006a7b
10006ad2:	5f                   	pop    edi
10006ad3:	5e                   	pop    esi
10006ad4:	c9                   	leave
10006ad5:	c3                   	ret
10006ad6:	56                   	push   esi
10006ad7:	57                   	push   edi
10006ad8:	8b 7c 24 0c          	mov    edi,DWORD PTR [esp+0xc]
10006adc:	8b 47 04             	mov    eax,DWORD PTR [edi+0x4]
10006adf:	85 c0                	test   eax,eax
10006ae1:	74 4a                	je     0x10006b2d
10006ae3:	80 78 08 00          	cmp    BYTE PTR [eax+0x8],0x0
10006ae7:	8d 50 08             	lea    edx,[eax+0x8]
10006aea:	74 41                	je     0x10006b2d
10006aec:	8b 74 24 10          	mov    esi,DWORD PTR [esp+0x10]
10006af0:	8b 4e 04             	mov    ecx,DWORD PTR [esi+0x4]
10006af3:	3b c1                	cmp    eax,ecx
10006af5:	74 10                	je     0x10006b07
10006af7:	83 c1 08             	add    ecx,0x8
10006afa:	51                   	push   ecx
10006afb:	52                   	push   edx
10006afc:	e8 4f 33 00 00       	call   0x10009e50
10006b01:	59                   	pop    ecx
10006b02:	85 c0                	test   eax,eax
10006b04:	59                   	pop    ecx
10006b05:	75 22                	jne    0x10006b29
10006b07:	f6 06 02             	test   BYTE PTR [esi],0x2
10006b0a:	74 05                	je     0x10006b11
10006b0c:	f6 07 08             	test   BYTE PTR [edi],0x8
10006b0f:	74 18                	je     0x10006b29
10006b11:	8b 44 24 14          	mov    eax,DWORD PTR [esp+0x14]
10006b15:	8b 00                	mov    eax,DWORD PTR [eax]
10006b17:	a8 01                	test   al,0x1
10006b19:	74 05                	je     0x10006b20
10006b1b:	f6 07 01             	test   BYTE PTR [edi],0x1
10006b1e:	74 09                	je     0x10006b29
10006b20:	a8 02                	test   al,0x2
10006b22:	74 09                	je     0x10006b2d
10006b24:	f6 07 02             	test   BYTE PTR [edi],0x2
10006b27:	75 04                	jne    0x10006b2d
10006b29:	33 c0                	xor    eax,eax
10006b2b:	eb 03                	jmp    0x10006b30
10006b2d:	6a 01                	push   0x1
10006b2f:	58                   	pop    eax
10006b30:	5f                   	pop    edi
10006b31:	5e                   	pop    esi
10006b32:	c3                   	ret
10006b33:	55                   	push   ebp
10006b34:	8b ec                	mov    ebp,esp
10006b36:	6a ff                	push   0xffffffff
10006b38:	68 28 d2 00 10       	push   0x1000d228
10006b3d:	68 dc 9e 00 10       	push   0x10009edc
10006b42:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10006b48:	50                   	push   eax
10006b49:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10006b50:	83 ec 0c             	sub    esp,0xc
10006b53:	53                   	push   ebx
10006b54:	56                   	push   esi
10006b55:	57                   	push   edi
10006b56:	89 65 e8             	mov    DWORD PTR [ebp-0x18],esp
10006b59:	8b 5d 08             	mov    ebx,DWORD PTR [ebp+0x8]
10006b5c:	8b 73 08             	mov    esi,DWORD PTR [ebx+0x8]
10006b5f:	89 75 e4             	mov    DWORD PTR [ebp-0x1c],esi
10006b62:	8b 7d 10             	mov    edi,DWORD PTR [ebp+0x10]
10006b65:	3b 75 14             	cmp    esi,DWORD PTR [ebp+0x14]
10006b68:	74 55                	je     0x10006bbf
10006b6a:	83 fe ff             	cmp    esi,0xffffffff
10006b6d:	7e 05                	jle    0x10006b74
10006b6f:	3b 77 04             	cmp    esi,DWORD PTR [edi+0x4]
10006b72:	7c 05                	jl     0x10006b79
10006b74:	e8 29 05 00 00       	call   0x100070a2
10006b79:	83 65 fc 00          	and    DWORD PTR [ebp-0x4],0x0
10006b7d:	8b 47 08             	mov    eax,DWORD PTR [edi+0x8]
10006b80:	8b 44 f0 04          	mov    eax,DWORD PTR [eax+esi*8+0x4]
10006b84:	85 c0                	test   eax,eax
10006b86:	74 0c                	je     0x10006b94
10006b88:	68 03 01 00 00       	push   0x103
10006b8d:	53                   	push   ebx
10006b8e:	50                   	push   eax
10006b8f:	e8 5c 04 00 00       	call   0x10006ff0
10006b94:	83 4d fc ff          	or     DWORD PTR [ebp-0x4],0xffffffff
10006b98:	eb 1a                	jmp    0x10006bb4
10006b9a:	ff 75 ec             	push   DWORD PTR [ebp-0x14]
10006b9d:	e8 2f 00 00 00       	call   0x10006bd1
10006ba2:	59                   	pop    ecx
10006ba3:	c3                   	ret
10006ba4:	8b 65 e8             	mov    esp,DWORD PTR [ebp-0x18]
10006ba7:	83 4d fc ff          	or     DWORD PTR [ebp-0x4],0xffffffff
10006bab:	8b 7d 10             	mov    edi,DWORD PTR [ebp+0x10]
10006bae:	8b 5d 08             	mov    ebx,DWORD PTR [ebp+0x8]
10006bb1:	8b 75 e4             	mov    esi,DWORD PTR [ebp-0x1c]
10006bb4:	8b 47 08             	mov    eax,DWORD PTR [edi+0x8]
10006bb7:	8b 34 f0             	mov    esi,DWORD PTR [eax+esi*8]
10006bba:	89 75 e4             	mov    DWORD PTR [ebp-0x1c],esi
10006bbd:	eb a6                	jmp    0x10006b65
10006bbf:	89 73 08             	mov    DWORD PTR [ebx+0x8],esi
10006bc2:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
10006bc5:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
10006bcc:	5f                   	pop    edi
10006bcd:	5e                   	pop    esi
10006bce:	5b                   	pop    ebx
10006bcf:	c9                   	leave
10006bd0:	c3                   	ret
10006bd1:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
10006bd5:	8b 00                	mov    eax,DWORD PTR [eax]
10006bd7:	81 38 63 73 6d e0    	cmp    DWORD PTR [eax],0xe06d7363
10006bdd:	74 03                	je     0x10006be2
10006bdf:	33 c0                	xor    eax,eax
10006be1:	c3                   	ret
10006be2:	e9 55 04 00 00       	jmp    0x1000703c
10006be7:	55                   	push   ebp
10006be8:	8b ec                	mov    ebp,esp
10006bea:	83 7d 20 00          	cmp    DWORD PTR [ebp+0x20],0x0
10006bee:	53                   	push   ebx
10006bef:	8b 5d 1c             	mov    ebx,DWORD PTR [ebp+0x1c]
10006bf2:	56                   	push   esi
10006bf3:	57                   	push   edi
10006bf4:	8b 7d 0c             	mov    edi,DWORD PTR [ebp+0xc]
10006bf7:	74 10                	je     0x10006c09
10006bf9:	ff 75 20             	push   DWORD PTR [ebp+0x20]
10006bfc:	53                   	push   ebx
10006bfd:	57                   	push   edi
10006bfe:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10006c01:	e8 92 01 00 00       	call   0x10006d98
10006c06:	83 c4 10             	add    esp,0x10
10006c09:	83 7d 2c 00          	cmp    DWORD PTR [ebp+0x2c],0x0
10006c0d:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10006c10:	75 03                	jne    0x10006c15
10006c12:	57                   	push   edi
10006c13:	eb 03                	jmp    0x10006c18
10006c15:	ff 75 2c             	push   DWORD PTR [ebp+0x2c]
10006c18:	e8 2e e6 ff ff       	call   0x1000524b
10006c1d:	8b 75 24             	mov    esi,DWORD PTR [ebp+0x24]
10006c20:	ff 36                	push   DWORD PTR [esi]
10006c22:	ff 75 18             	push   DWORD PTR [ebp+0x18]
10006c25:	ff 75 14             	push   DWORD PTR [ebp+0x14]
10006c28:	57                   	push   edi
10006c29:	e8 05 ff ff ff       	call   0x10006b33
10006c2e:	8b 46 04             	mov    eax,DWORD PTR [esi+0x4]
10006c31:	68 00 01 00 00       	push   0x100
10006c36:	ff 75 28             	push   DWORD PTR [ebp+0x28]
10006c39:	40                   	inc    eax
10006c3a:	89 47 08             	mov    DWORD PTR [edi+0x8],eax
10006c3d:	ff 73 0c             	push   DWORD PTR [ebx+0xc]
10006c40:	ff 75 18             	push   DWORD PTR [ebp+0x18]
10006c43:	ff 75 10             	push   DWORD PTR [ebp+0x10]
10006c46:	57                   	push   edi
10006c47:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10006c4a:	e8 13 00 00 00       	call   0x10006c62
10006c4f:	83 c4 2c             	add    esp,0x2c
10006c52:	85 c0                	test   eax,eax
10006c54:	74 07                	je     0x10006c5d
10006c56:	57                   	push   edi
10006c57:	50                   	push   eax
10006c58:	e8 a5 e5 ff ff       	call   0x10005202
10006c5d:	5f                   	pop    edi
10006c5e:	5e                   	pop    esi
10006c5f:	5b                   	pop    ebx
10006c60:	5d                   	pop    ebp
10006c61:	c3                   	ret
10006c62:	55                   	push   ebp
10006c63:	8b ec                	mov    ebp,esp
10006c65:	6a ff                	push   0xffffffff
10006c67:	68 38 d2 00 10       	push   0x1000d238
10006c6c:	68 dc 9e 00 10       	push   0x10009edc
10006c71:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10006c77:	50                   	push   eax
10006c78:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10006c7f:	83 ec 1c             	sub    esp,0x1c
10006c82:	53                   	push   ebx
10006c83:	56                   	push   esi
10006c84:	57                   	push   edi
10006c85:	89 65 e8             	mov    DWORD PTR [ebp-0x18],esp
10006c88:	8b 45 18             	mov    eax,DWORD PTR [ebp+0x18]
10006c8b:	89 45 d4             	mov    DWORD PTR [ebp-0x2c],eax
10006c8e:	33 db                	xor    ebx,ebx
10006c90:	89 5d dc             	mov    DWORD PTR [ebp-0x24],ebx
10006c93:	8b 75 0c             	mov    esi,DWORD PTR [ebp+0xc]
10006c96:	8b 4e fc             	mov    ecx,DWORD PTR [esi-0x4]
10006c99:	89 4d d8             	mov    DWORD PTR [ebp-0x28],ecx
10006c9c:	8b 0d 3c f6 00 10    	mov    ecx,DWORD PTR ds:0x1000f63c
10006ca2:	89 4d e4             	mov    DWORD PTR [ebp-0x1c],ecx
10006ca5:	8b 0d 40 f6 00 10    	mov    ecx,DWORD PTR ds:0x1000f640
10006cab:	89 4d e0             	mov    DWORD PTR [ebp-0x20],ecx
10006cae:	8b 7d 08             	mov    edi,DWORD PTR [ebp+0x8]
10006cb1:	89 3d 3c f6 00 10    	mov    DWORD PTR ds:0x1000f63c,edi
10006cb7:	8b 4d 10             	mov    ecx,DWORD PTR [ebp+0x10]
10006cba:	89 0d 40 f6 00 10    	mov    DWORD PTR ds:0x1000f640,ecx
10006cc0:	89 5d fc             	mov    DWORD PTR [ebp-0x4],ebx
10006cc3:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [ebp-0x4],0x1
10006cca:	ff 75 20             	push   DWORD PTR [ebp+0x20]
10006ccd:	ff 75 1c             	push   DWORD PTR [ebp+0x1c]
10006cd0:	50                   	push   eax
10006cd1:	ff 75 14             	push   DWORD PTR [ebp+0x14]
10006cd4:	56                   	push   esi
10006cd5:	e8 10 e6 ff ff       	call   0x100052ea
10006cda:	83 c4 14             	add    esp,0x14
10006cdd:	89 45 d4             	mov    DWORD PTR [ebp-0x2c],eax
10006ce0:	89 5d fc             	mov    DWORD PTR [ebp-0x4],ebx
10006ce3:	83 4d fc ff          	or     DWORD PTR [ebp-0x4],0xffffffff
10006ce7:	e8 3c 00 00 00       	call   0x10006d28
10006cec:	8b 45 d4             	mov    eax,DWORD PTR [ebp-0x2c]
10006cef:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
10006cf2:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
10006cf9:	5f                   	pop    edi
10006cfa:	5e                   	pop    esi
10006cfb:	5b                   	pop    ebx
10006cfc:	c9                   	leave
10006cfd:	c3                   	ret
10006cfe:	ff 75 ec             	push   DWORD PTR [ebp-0x14]
10006d01:	e8 68 00 00 00       	call   0x10006d6e
10006d06:	59                   	pop    ecx
10006d07:	c3                   	ret
10006d08:	8b 65 e8             	mov    esp,DWORD PTR [ebp-0x18]
10006d0b:	83 65 d4 00          	and    DWORD PTR [ebp-0x2c],0x0
10006d0f:	6a ff                	push   0xffffffff
10006d11:	8d 45 f0             	lea    eax,[ebp-0x10]
10006d14:	50                   	push   eax
10006d15:	e8 30 e8 ff ff       	call   0x1000554a
10006d1a:	59                   	pop    ecx
10006d1b:	59                   	pop    ecx
10006d1c:	33 c0                	xor    eax,eax
10006d1e:	eb cf                	jmp    0x10006cef
10006d20:	33 db                	xor    ebx,ebx
10006d22:	8b 75 0c             	mov    esi,DWORD PTR [ebp+0xc]
10006d25:	8b 7d 08             	mov    edi,DWORD PTR [ebp+0x8]
10006d28:	8b 45 d8             	mov    eax,DWORD PTR [ebp-0x28]
10006d2b:	89 46 fc             	mov    DWORD PTR [esi-0x4],eax
10006d2e:	8b 45 e4             	mov    eax,DWORD PTR [ebp-0x1c]
10006d31:	a3 3c f6 00 10       	mov    ds:0x1000f63c,eax
10006d36:	8b 45 e0             	mov    eax,DWORD PTR [ebp-0x20]
10006d39:	a3 40 f6 00 10       	mov    ds:0x1000f640,eax
10006d3e:	81 3f 63 73 6d e0    	cmp    DWORD PTR [edi],0xe06d7363
10006d44:	75 27                	jne    0x10006d6d
10006d46:	83 7f 10 03          	cmp    DWORD PTR [edi+0x10],0x3
10006d4a:	75 21                	jne    0x10006d6d
10006d4c:	81 7f 14 20 05 93 19 	cmp    DWORD PTR [edi+0x14],0x19930520
10006d53:	75 18                	jne    0x10006d6d
10006d55:	39 5d dc             	cmp    DWORD PTR [ebp-0x24],ebx
10006d58:	75 13                	jne    0x10006d6d
10006d5a:	39 5d d4             	cmp    DWORD PTR [ebp-0x2c],ebx
10006d5d:	74 0e                	je     0x10006d6d
10006d5f:	e8 4e e8 ff ff       	call   0x100055b2
10006d64:	50                   	push   eax
10006d65:	57                   	push   edi
10006d66:	e8 f1 01 00 00       	call   0x10006f5c
10006d6b:	59                   	pop    ecx
10006d6c:	59                   	pop    ecx
10006d6d:	c3                   	ret
10006d6e:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
10006d72:	8b 00                	mov    eax,DWORD PTR [eax]
10006d74:	81 38 63 73 6d e0    	cmp    DWORD PTR [eax],0xe06d7363
10006d7a:	75 19                	jne    0x10006d95
10006d7c:	83 78 10 03          	cmp    DWORD PTR [eax+0x10],0x3
10006d80:	75 13                	jne    0x10006d95
10006d82:	81 78 14 20 05 93 19 	cmp    DWORD PTR [eax+0x14],0x19930520
10006d89:	75 0a                	jne    0x10006d95
10006d8b:	83 78 1c 00          	cmp    DWORD PTR [eax+0x1c],0x0
10006d8f:	75 04                	jne    0x10006d95
10006d91:	6a 01                	push   0x1
10006d93:	58                   	pop    eax
10006d94:	c3                   	ret
10006d95:	33 c0                	xor    eax,eax
10006d97:	c3                   	ret
10006d98:	55                   	push   ebp
10006d99:	8b ec                	mov    ebp,esp
10006d9b:	6a ff                	push   0xffffffff
10006d9d:	68 50 d2 00 10       	push   0x1000d250
10006da2:	68 dc 9e 00 10       	push   0x10009edc
10006da7:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10006dad:	50                   	push   eax
10006dae:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10006db5:	83 ec 0c             	sub    esp,0xc
10006db8:	53                   	push   ebx
10006db9:	56                   	push   esi
10006dba:	57                   	push   edi
10006dbb:	89 65 e8             	mov    DWORD PTR [ebp-0x18],esp
10006dbe:	8b 4d 10             	mov    ecx,DWORD PTR [ebp+0x10]
10006dc1:	8b 41 04             	mov    eax,DWORD PTR [ecx+0x4]
10006dc4:	85 c0                	test   eax,eax
10006dc6:	0f 84 75 01 00 00    	je     0x10006f41
10006dcc:	80 78 08 00          	cmp    BYTE PTR [eax+0x8],0x0
10006dd0:	0f 84 6b 01 00 00    	je     0x10006f41
10006dd6:	8b 41 08             	mov    eax,DWORD PTR [ecx+0x8]
10006dd9:	85 c0                	test   eax,eax
10006ddb:	0f 84 60 01 00 00    	je     0x10006f41
10006de1:	8b 55 0c             	mov    edx,DWORD PTR [ebp+0xc]
10006de4:	8d 7c 10 0c          	lea    edi,[eax+edx*1+0xc]
10006de8:	83 65 fc 00          	and    DWORD PTR [ebp-0x4],0x0
10006dec:	f6 01 08             	test   BYTE PTR [ecx],0x8
10006def:	74 44                	je     0x10006e35
10006df1:	8b 75 08             	mov    esi,DWORD PTR [ebp+0x8]
10006df4:	6a 01                	push   0x1
10006df6:	ff 76 18             	push   DWORD PTR [esi+0x18]
10006df9:	e8 fb 2f 00 00       	call   0x10009df9
10006dfe:	59                   	pop    ecx
10006dff:	59                   	pop    ecx
10006e00:	85 c0                	test   eax,eax
10006e02:	0f 84 30 01 00 00    	je     0x10006f38
10006e08:	6a 01                	push   0x1
10006e0a:	57                   	push   edi
10006e0b:	e8 05 30 00 00       	call   0x10009e15
10006e10:	59                   	pop    ecx
10006e11:	59                   	pop    ecx
10006e12:	85 c0                	test   eax,eax
10006e14:	0f 84 1e 01 00 00    	je     0x10006f38
10006e1a:	8b 46 18             	mov    eax,DWORD PTR [esi+0x18]
10006e1d:	89 07                	mov    DWORD PTR [edi],eax
10006e1f:	8b 4d 14             	mov    ecx,DWORD PTR [ebp+0x14]
10006e22:	83 c1 08             	add    ecx,0x8
10006e25:	51                   	push   ecx
10006e26:	50                   	push   eax
10006e27:	e8 97 01 00 00       	call   0x10006fc3
10006e2c:	59                   	pop    ecx
10006e2d:	59                   	pop    ecx
10006e2e:	89 07                	mov    DWORD PTR [edi],eax
10006e30:	e9 08 01 00 00       	jmp    0x10006f3d
10006e35:	8b 75 14             	mov    esi,DWORD PTR [ebp+0x14]
10006e38:	f6 06 01             	test   BYTE PTR [esi],0x1
10006e3b:	74 52                	je     0x10006e8f
10006e3d:	8b 5d 08             	mov    ebx,DWORD PTR [ebp+0x8]
10006e40:	6a 01                	push   0x1
10006e42:	ff 73 18             	push   DWORD PTR [ebx+0x18]
10006e45:	e8 af 2f 00 00       	call   0x10009df9
10006e4a:	59                   	pop    ecx
10006e4b:	59                   	pop    ecx
10006e4c:	85 c0                	test   eax,eax
10006e4e:	0f 84 e4 00 00 00    	je     0x10006f38
10006e54:	6a 01                	push   0x1
10006e56:	57                   	push   edi
10006e57:	e8 b9 2f 00 00       	call   0x10009e15
10006e5c:	59                   	pop    ecx
10006e5d:	59                   	pop    ecx
10006e5e:	85 c0                	test   eax,eax
10006e60:	0f 84 d2 00 00 00    	je     0x10006f38
10006e66:	ff 76 14             	push   DWORD PTR [esi+0x14]
10006e69:	ff 73 18             	push   DWORD PTR [ebx+0x18]
10006e6c:	57                   	push   edi
10006e6d:	e8 0e 17 00 00       	call   0x10008580
10006e72:	83 c4 0c             	add    esp,0xc
10006e75:	83 7e 14 04          	cmp    DWORD PTR [esi+0x14],0x4
10006e79:	0f 85 be 00 00 00    	jne    0x10006f3d
10006e7f:	8b 07                	mov    eax,DWORD PTR [edi]
10006e81:	85 c0                	test   eax,eax
10006e83:	0f 84 b4 00 00 00    	je     0x10006f3d
10006e89:	83 c6 08             	add    esi,0x8
10006e8c:	56                   	push   esi
10006e8d:	eb 97                	jmp    0x10006e26
10006e8f:	83 7e 18 00          	cmp    DWORD PTR [esi+0x18],0x0
10006e93:	8b 5d 08             	mov    ebx,DWORD PTR [ebp+0x8]
10006e96:	6a 01                	push   0x1
10006e98:	ff 73 18             	push   DWORD PTR [ebx+0x18]
10006e9b:	75 3a                	jne    0x10006ed7
10006e9d:	e8 57 2f 00 00       	call   0x10009df9
10006ea2:	59                   	pop    ecx
10006ea3:	59                   	pop    ecx
10006ea4:	85 c0                	test   eax,eax
10006ea6:	0f 84 8c 00 00 00    	je     0x10006f38
10006eac:	6a 01                	push   0x1
10006eae:	57                   	push   edi
10006eaf:	e8 61 2f 00 00       	call   0x10009e15
10006eb4:	59                   	pop    ecx
10006eb5:	59                   	pop    ecx
10006eb6:	85 c0                	test   eax,eax
10006eb8:	74 7e                	je     0x10006f38
10006eba:	ff 76 14             	push   DWORD PTR [esi+0x14]
10006ebd:	83 c6 08             	add    esi,0x8
10006ec0:	56                   	push   esi
10006ec1:	ff 73 18             	push   DWORD PTR [ebx+0x18]
10006ec4:	e8 fa 00 00 00       	call   0x10006fc3
10006ec9:	59                   	pop    ecx
10006eca:	59                   	pop    ecx
10006ecb:	50                   	push   eax
10006ecc:	57                   	push   edi
10006ecd:	e8 ae 16 00 00       	call   0x10008580
10006ed2:	83 c4 0c             	add    esp,0xc
10006ed5:	eb 66                	jmp    0x10006f3d
10006ed7:	e8 1d 2f 00 00       	call   0x10009df9
10006edc:	59                   	pop    ecx
10006edd:	59                   	pop    ecx
10006ede:	85 c0                	test   eax,eax
10006ee0:	74 56                	je     0x10006f38
10006ee2:	6a 01                	push   0x1
10006ee4:	57                   	push   edi
10006ee5:	e8 2b 2f 00 00       	call   0x10009e15
10006eea:	59                   	pop    ecx
10006eeb:	59                   	pop    ecx
10006eec:	85 c0                	test   eax,eax
10006eee:	74 48                	je     0x10006f38
10006ef0:	ff 76 18             	push   DWORD PTR [esi+0x18]
10006ef3:	e8 39 2f 00 00       	call   0x10009e31
10006ef8:	59                   	pop    ecx
10006ef9:	85 c0                	test   eax,eax
10006efb:	74 3b                	je     0x10006f38
10006efd:	f6 06 04             	test   BYTE PTR [esi],0x4
10006f00:	74 1c                	je     0x10006f1e
10006f02:	6a 01                	push   0x1
10006f04:	8d 46 08             	lea    eax,[esi+0x8]
10006f07:	50                   	push   eax
10006f08:	ff 73 18             	push   DWORD PTR [ebx+0x18]
10006f0b:	e8 b3 00 00 00       	call   0x10006fc3
10006f10:	59                   	pop    ecx
10006f11:	59                   	pop    ecx
10006f12:	50                   	push   eax
10006f13:	ff 76 18             	push   DWORD PTR [esi+0x18]
10006f16:	57                   	push   edi
10006f17:	e8 28 e3 ff ff       	call   0x10005244
10006f1c:	eb 1f                	jmp    0x10006f3d
10006f1e:	8d 46 08             	lea    eax,[esi+0x8]
10006f21:	50                   	push   eax
10006f22:	ff 73 18             	push   DWORD PTR [ebx+0x18]
10006f25:	e8 99 00 00 00       	call   0x10006fc3
10006f2a:	59                   	pop    ecx
10006f2b:	59                   	pop    ecx
10006f2c:	50                   	push   eax
10006f2d:	ff 76 18             	push   DWORD PTR [esi+0x18]
10006f30:	57                   	push   edi
10006f31:	e8 07 e3 ff ff       	call   0x1000523d
10006f36:	eb 05                	jmp    0x10006f3d
10006f38:	e8 65 01 00 00       	call   0x100070a2
10006f3d:	83 4d fc ff          	or     DWORD PTR [ebp-0x4],0xffffffff
10006f41:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
10006f44:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
10006f4b:	5f                   	pop    edi
10006f4c:	5e                   	pop    esi
10006f4d:	5b                   	pop    ebx
10006f4e:	c9                   	leave
10006f4f:	c3                   	ret
10006f50:	6a 01                	push   0x1
10006f52:	58                   	pop    eax
10006f53:	c3                   	ret
10006f54:	8b 65 e8             	mov    esp,DWORD PTR [ebp-0x18]
10006f57:	e9 e0 00 00 00       	jmp    0x1000703c
10006f5c:	55                   	push   ebp
10006f5d:	8b ec                	mov    ebp,esp
10006f5f:	6a ff                	push   0xffffffff
10006f61:	68 60 d2 00 10       	push   0x1000d260
10006f66:	68 dc 9e 00 10       	push   0x10009edc
10006f6b:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10006f71:	50                   	push   eax
10006f72:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10006f79:	51                   	push   ecx
10006f7a:	51                   	push   ecx
10006f7b:	53                   	push   ebx
10006f7c:	56                   	push   esi
10006f7d:	57                   	push   edi
10006f7e:	89 65 e8             	mov    DWORD PTR [ebp-0x18],esp
10006f81:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10006f84:	85 c0                	test   eax,eax
10006f86:	74 1b                	je     0x10006fa3
10006f88:	8b 48 1c             	mov    ecx,DWORD PTR [eax+0x1c]
10006f8b:	8b 49 04             	mov    ecx,DWORD PTR [ecx+0x4]
10006f8e:	85 c9                	test   ecx,ecx
10006f90:	74 11                	je     0x10006fa3
10006f92:	83 65 fc 00          	and    DWORD PTR [ebp-0x4],0x0
10006f96:	51                   	push   ecx
10006f97:	ff 70 18             	push   DWORD PTR [eax+0x18]
10006f9a:	e8 97 e2 ff ff       	call   0x10005236
10006f9f:	83 4d fc ff          	or     DWORD PTR [ebp-0x4],0xffffffff
10006fa3:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
10006fa6:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
10006fad:	5f                   	pop    edi
10006fae:	5e                   	pop    esi
10006faf:	5b                   	pop    ebx
10006fb0:	c9                   	leave
10006fb1:	c3                   	ret
10006fb2:	33 c0                	xor    eax,eax
10006fb4:	38 45 0c             	cmp    BYTE PTR [ebp+0xc],al
10006fb7:	0f 95 c0             	setne  al
10006fba:	c3                   	ret
10006fbb:	8b 65 e8             	mov    esp,DWORD PTR [ebp-0x18]
10006fbe:	e9 79 00 00 00       	jmp    0x1000703c
10006fc3:	8b 4c 24 08          	mov    ecx,DWORD PTR [esp+0x8]
10006fc7:	56                   	push   esi
10006fc8:	8b 74 24 08          	mov    esi,DWORD PTR [esp+0x8]
10006fcc:	8b 01                	mov    eax,DWORD PTR [ecx]
10006fce:	8b 51 04             	mov    edx,DWORD PTR [ecx+0x4]
10006fd1:	03 c6                	add    eax,esi
10006fd3:	85 d2                	test   edx,edx
10006fd5:	7c 0d                	jl     0x10006fe4
10006fd7:	8b 34 32             	mov    esi,DWORD PTR [edx+esi*1]
10006fda:	8b 49 08             	mov    ecx,DWORD PTR [ecx+0x8]
10006fdd:	8b 0c 0e             	mov    ecx,DWORD PTR [esi+ecx*1]
10006fe0:	03 ca                	add    ecx,edx
10006fe2:	03 c1                	add    eax,ecx
10006fe4:	5e                   	pop    esi
10006fe5:	c3                   	ret
10006fe6:	cc                   	int3
10006fe7:	cc                   	int3
10006fe8:	cc                   	int3
10006fe9:	cc                   	int3
10006fea:	cc                   	int3
10006feb:	cc                   	int3
10006fec:	cc                   	int3
10006fed:	cc                   	int3
10006fee:	cc                   	int3
10006fef:	cc                   	int3
10006ff0:	55                   	push   ebp
10006ff1:	8b ec                	mov    ebp,esp
10006ff3:	83 ec 04             	sub    esp,0x4
10006ff6:	53                   	push   ebx
10006ff7:	51                   	push   ecx
10006ff8:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10006ffb:	83 c0 0c             	add    eax,0xc
10006ffe:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
10007001:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10007004:	55                   	push   ebp
10007005:	ff 75 10             	push   DWORD PTR [ebp+0x10]
10007008:	8b 4d 10             	mov    ecx,DWORD PTR [ebp+0x10]
1000700b:	8b 6d fc             	mov    ebp,DWORD PTR [ebp-0x4]
1000700e:	e8 c2 e5 ff ff       	call   0x100055d5
10007013:	56                   	push   esi
10007014:	57                   	push   edi
10007015:	ff d0                	call   eax
10007017:	5f                   	pop    edi
10007018:	5e                   	pop    esi
10007019:	8b dd                	mov    ebx,ebp
1000701b:	5d                   	pop    ebp
1000701c:	8b 4d 10             	mov    ecx,DWORD PTR [ebp+0x10]
1000701f:	55                   	push   ebp
10007020:	8b eb                	mov    ebp,ebx
10007022:	81 f9 00 01 00 00    	cmp    ecx,0x100
10007028:	75 05                	jne    0x1000702f
1000702a:	b9 02 00 00 00       	mov    ecx,0x2
1000702f:	51                   	push   ecx
10007030:	e8 a0 e5 ff ff       	call   0x100055d5
10007035:	5d                   	pop    ebp
10007036:	59                   	pop    ecx
10007037:	5b                   	pop    ebx
10007038:	c9                   	leave
10007039:	c2 0c 00             	ret    0xc
1000703c:	55                   	push   ebp
1000703d:	8b ec                	mov    ebp,esp
1000703f:	6a ff                	push   0xffffffff
10007041:	68 70 d2 00 10       	push   0x1000d270
10007046:	68 dc 9e 00 10       	push   0x10009edc
1000704b:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10007051:	50                   	push   eax
10007052:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10007059:	51                   	push   ecx
1000705a:	51                   	push   ecx
1000705b:	53                   	push   ebx
1000705c:	56                   	push   esi
1000705d:	57                   	push   edi
1000705e:	89 65 e8             	mov    DWORD PTR [ebp-0x18],esp
10007061:	83 65 fc 00          	and    DWORD PTR [ebp-0x4],0x0
10007065:	a1 48 f6 00 10       	mov    eax,ds:0x1000f648
1000706a:	85 c0                	test   eax,eax
1000706c:	74 16                	je     0x10007084
1000706e:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [ebp-0x4],0x1
10007075:	ff d0                	call   eax
10007077:	eb 07                	jmp    0x10007080
10007079:	6a 01                	push   0x1
1000707b:	58                   	pop    eax
1000707c:	c3                   	ret
1000707d:	8b 65 e8             	mov    esp,DWORD PTR [ebp-0x18]
10007080:	83 65 fc 00          	and    DWORD PTR [ebp-0x4],0x0
10007084:	83 4d fc ff          	or     DWORD PTR [ebp-0x4],0xffffffff
10007088:	e8 00 00 00 00       	call   0x1000708d
1000708d:	e9 22 2f 00 00       	jmp    0x10009fb4
10007092:	a1 80 ea 00 10       	mov    eax,ds:0x1000ea80
10007097:	85 c0                	test   eax,eax
10007099:	74 02                	je     0x1000709d
1000709b:	ff d0                	call   eax
1000709d:	e9 9a ff ff ff       	jmp    0x1000703c
100070a2:	55                   	push   ebp
100070a3:	8b ec                	mov    ebp,esp
100070a5:	6a ff                	push   0xffffffff
100070a7:	68 88 d2 00 10       	push   0x1000d288
100070ac:	68 dc 9e 00 10       	push   0x10009edc
100070b1:	64 a1 00 00 00 00    	mov    eax,fs:0x0
100070b7:	50                   	push   eax
100070b8:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
100070bf:	51                   	push   ecx
100070c0:	51                   	push   ecx
100070c1:	53                   	push   ebx
100070c2:	56                   	push   esi
100070c3:	57                   	push   edi
100070c4:	89 65 e8             	mov    DWORD PTR [ebp-0x18],esp
100070c7:	83 65 fc 00          	and    DWORD PTR [ebp-0x4],0x0
100070cb:	a1 84 ea 00 10       	mov    eax,ds:0x1000ea84
100070d0:	85 c0                	test   eax,eax
100070d2:	74 16                	je     0x100070ea
100070d4:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [ebp-0x4],0x1
100070db:	ff d0                	call   eax
100070dd:	eb 07                	jmp    0x100070e6
100070df:	6a 01                	push   0x1
100070e1:	58                   	pop    eax
100070e2:	c3                   	ret
100070e3:	8b 65 e8             	mov    esp,DWORD PTR [ebp-0x18]
100070e6:	83 65 fc 00          	and    DWORD PTR [ebp-0x4],0x0
100070ea:	83 4d fc ff          	or     DWORD PTR [ebp-0x4],0xffffffff
100070ee:	e8 00 00 00 00       	call   0x100070f3
100070f3:	e9 44 ff ff ff       	jmp    0x1000703c
100070f8:	55                   	push   ebp
100070f9:	8b ec                	mov    ebp,esp
100070fb:	51                   	push   ecx
100070fc:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100070ff:	8d 48 01             	lea    ecx,[eax+0x1]
10007102:	81 f9 00 01 00 00    	cmp    ecx,0x100
10007108:	77 0c                	ja     0x10007116
1000710a:	8b 0d 88 ea 00 10    	mov    ecx,DWORD PTR ds:0x1000ea88
10007110:	0f b7 04 41          	movzx  eax,WORD PTR [ecx+eax*2]
10007114:	eb 52                	jmp    0x10007168
10007116:	8b c8                	mov    ecx,eax
10007118:	56                   	push   esi
10007119:	8b 35 88 ea 00 10    	mov    esi,DWORD PTR ds:0x1000ea88
1000711f:	c1 f9 08             	sar    ecx,0x8
10007122:	0f b6 d1             	movzx  edx,cl
10007125:	f6 44 56 01 80       	test   BYTE PTR [esi+edx*2+0x1],0x80
1000712a:	5e                   	pop    esi
1000712b:	74 0e                	je     0x1000713b
1000712d:	80 65 fe 00          	and    BYTE PTR [ebp-0x2],0x0
10007131:	88 4d fc             	mov    BYTE PTR [ebp-0x4],cl
10007134:	88 45 fd             	mov    BYTE PTR [ebp-0x3],al
10007137:	6a 02                	push   0x2
10007139:	eb 09                	jmp    0x10007144
1000713b:	80 65 fd 00          	and    BYTE PTR [ebp-0x3],0x0
1000713f:	88 45 fc             	mov    BYTE PTR [ebp-0x4],al
10007142:	6a 01                	push   0x1
10007144:	58                   	pop    eax
10007145:	8d 4d 0a             	lea    ecx,[ebp+0xa]
10007148:	6a 01                	push   0x1
1000714a:	6a 00                	push   0x0
1000714c:	6a 00                	push   0x0
1000714e:	51                   	push   ecx
1000714f:	50                   	push   eax
10007150:	8d 45 fc             	lea    eax,[ebp-0x4]
10007153:	50                   	push   eax
10007154:	6a 01                	push   0x1
10007156:	e8 70 2e 00 00       	call   0x10009fcb
1000715b:	83 c4 1c             	add    esp,0x1c
1000715e:	85 c0                	test   eax,eax
10007160:	75 02                	jne    0x10007164
10007162:	c9                   	leave
10007163:	c3                   	ret
10007164:	0f b7 45 0a          	movzx  eax,WORD PTR [ebp+0xa]
10007168:	23 45 0c             	and    eax,DWORD PTR [ebp+0xc]
1000716b:	c9                   	leave
1000716c:	c3                   	ret
1000716d:	cc                   	int3
1000716e:	cc                   	int3
1000716f:	cc                   	int3
10007170:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
10007174:	8b 4c 24 10          	mov    ecx,DWORD PTR [esp+0x10]
10007178:	0b c8                	or     ecx,eax
1000717a:	8b 4c 24 0c          	mov    ecx,DWORD PTR [esp+0xc]
1000717e:	75 09                	jne    0x10007189
10007180:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
10007184:	f7 e1                	mul    ecx
10007186:	c2 10 00             	ret    0x10
10007189:	53                   	push   ebx
1000718a:	f7 e1                	mul    ecx
1000718c:	8b d8                	mov    ebx,eax
1000718e:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
10007192:	f7 64 24 14          	mul    DWORD PTR [esp+0x14]
10007196:	03 d8                	add    ebx,eax
10007198:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
1000719c:	f7 e1                	mul    ecx
1000719e:	03 d3                	add    edx,ebx
100071a0:	5b                   	pop    ebx
100071a1:	c2 10 00             	ret    0x10
100071a4:	a1 20 ea 00 10       	mov    eax,ds:0x1000ea20
100071a9:	85 c0                	test   eax,eax
100071ab:	74 02                	je     0x100071af
100071ad:	ff d0                	call   eax
100071af:	68 18 e0 00 10       	push   0x1000e018
100071b4:	68 08 e0 00 10       	push   0x1000e008
100071b9:	e8 ec 00 00 00       	call   0x100072aa
100071be:	68 04 e0 00 10       	push   0x1000e004
100071c3:	68 00 e0 00 10       	push   0x1000e000
100071c8:	e8 dd 00 00 00       	call   0x100072aa
100071cd:	83 c4 10             	add    esp,0x10
100071d0:	c3                   	ret
100071d1:	6a 00                	push   0x0
100071d3:	6a 00                	push   0x0
100071d5:	ff 74 24 0c          	push   DWORD PTR [esp+0xc]
100071d9:	e8 33 00 00 00       	call   0x10007211
100071de:	83 c4 0c             	add    esp,0xc
100071e1:	c3                   	ret
100071e2:	6a 00                	push   0x0
100071e4:	6a 01                	push   0x1
100071e6:	ff 74 24 0c          	push   DWORD PTR [esp+0xc]
100071ea:	e8 22 00 00 00       	call   0x10007211
100071ef:	83 c4 0c             	add    esp,0xc
100071f2:	c3                   	ret
100071f3:	6a 01                	push   0x1
100071f5:	6a 00                	push   0x0
100071f7:	6a 00                	push   0x0
100071f9:	e8 13 00 00 00       	call   0x10007211
100071fe:	83 c4 0c             	add    esp,0xc
10007201:	c3                   	ret
10007202:	6a 01                	push   0x1
10007204:	6a 01                	push   0x1
10007206:	6a 00                	push   0x0
10007208:	e8 04 00 00 00       	call   0x10007211
1000720d:	83 c4 0c             	add    esp,0xc
10007210:	c3                   	ret
10007211:	57                   	push   edi
10007212:	6a 01                	push   0x1
10007214:	5f                   	pop    edi
10007215:	39 3d 94 f6 00 10    	cmp    DWORD PTR ds:0x1000f694,edi
1000721b:	75 11                	jne    0x1000722e
1000721d:	ff 74 24 08          	push   DWORD PTR [esp+0x8]
10007221:	ff 15 44 d0 00 10    	call   DWORD PTR ds:0x1000d044
10007227:	50                   	push   eax
10007228:	ff 15 40 d0 00 10    	call   DWORD PTR ds:0x1000d040
1000722e:	83 7c 24 0c 00       	cmp    DWORD PTR [esp+0xc],0x0
10007233:	53                   	push   ebx
10007234:	8b 5c 24 14          	mov    ebx,DWORD PTR [esp+0x14]
10007238:	89 3d 90 f6 00 10    	mov    DWORD PTR ds:0x1000f690,edi
1000723e:	88 1d 8c f6 00 10    	mov    BYTE PTR ds:0x1000f68c,bl
10007244:	75 3c                	jne    0x10007282
10007246:	a1 b4 0b 01 10       	mov    eax,ds:0x10010bb4
1000724b:	85 c0                	test   eax,eax
1000724d:	74 22                	je     0x10007271
1000724f:	8b 0d b0 0b 01 10    	mov    ecx,DWORD PTR ds:0x10010bb0
10007255:	56                   	push   esi
10007256:	8d 71 fc             	lea    esi,[ecx-0x4]
10007259:	3b f0                	cmp    esi,eax
1000725b:	72 13                	jb     0x10007270
1000725d:	8b 06                	mov    eax,DWORD PTR [esi]
1000725f:	85 c0                	test   eax,eax
10007261:	74 02                	je     0x10007265
10007263:	ff d0                	call   eax
10007265:	83 ee 04             	sub    esi,0x4
10007268:	3b 35 b4 0b 01 10    	cmp    esi,DWORD PTR ds:0x10010bb4
1000726e:	73 ed                	jae    0x1000725d
10007270:	5e                   	pop    esi
10007271:	68 24 e0 00 10       	push   0x1000e024
10007276:	68 1c e0 00 10       	push   0x1000e01c
1000727b:	e8 2a 00 00 00       	call   0x100072aa
10007280:	59                   	pop    ecx
10007281:	59                   	pop    ecx
10007282:	68 30 e0 00 10       	push   0x1000e030
10007287:	68 28 e0 00 10       	push   0x1000e028
1000728c:	e8 19 00 00 00       	call   0x100072aa
10007291:	59                   	pop    ecx
10007292:	59                   	pop    ecx
10007293:	85 db                	test   ebx,ebx
10007295:	5b                   	pop    ebx
10007296:	75 10                	jne    0x100072a8
10007298:	ff 74 24 08          	push   DWORD PTR [esp+0x8]
1000729c:	89 3d 94 f6 00 10    	mov    DWORD PTR ds:0x1000f694,edi
100072a2:	ff 15 3c d0 00 10    	call   DWORD PTR ds:0x1000d03c
100072a8:	5f                   	pop    edi
100072a9:	c3                   	ret
100072aa:	56                   	push   esi
100072ab:	8b 74 24 08          	mov    esi,DWORD PTR [esp+0x8]
100072af:	3b 74 24 0c          	cmp    esi,DWORD PTR [esp+0xc]
100072b3:	73 0d                	jae    0x100072c2
100072b5:	8b 06                	mov    eax,DWORD PTR [esi]
100072b7:	85 c0                	test   eax,eax
100072b9:	74 02                	je     0x100072bd
100072bb:	ff d0                	call   eax
100072bd:	83 c6 04             	add    esi,0x4
100072c0:	eb ed                	jmp    0x100072af
100072c2:	5e                   	pop    esi
100072c3:	c3                   	ret
100072c4:	33 c0                	xor    eax,eax
100072c6:	6a 00                	push   0x0
100072c8:	39 44 24 08          	cmp    DWORD PTR [esp+0x8],eax
100072cc:	68 00 10 00 00       	push   0x1000
100072d1:	0f 94 c0             	sete   al
100072d4:	50                   	push   eax
100072d5:	ff 15 4c d0 00 10    	call   DWORD PTR ds:0x1000d04c
100072db:	85 c0                	test   eax,eax
100072dd:	a3 a4 0b 01 10       	mov    ds:0x10010ba4,eax
100072e2:	74 15                	je     0x100072f9
100072e4:	e8 78 16 00 00       	call   0x10008961
100072e9:	85 c0                	test   eax,eax
100072eb:	75 0f                	jne    0x100072fc
100072ed:	ff 35 a4 0b 01 10    	push   DWORD PTR ds:0x10010ba4
100072f3:	ff 15 48 d0 00 10    	call   DWORD PTR ds:0x1000d048
100072f9:	33 c0                	xor    eax,eax
100072fb:	c3                   	ret
100072fc:	6a 01                	push   0x1
100072fe:	58                   	pop    eax
100072ff:	c3                   	ret
10007300:	53                   	push   ebx
10007301:	33 db                	xor    ebx,ebx
10007303:	39 1d 94 0a 01 10    	cmp    DWORD PTR ds:0x10010a94,ebx
10007309:	55                   	push   ebp
1000730a:	8b 2d 34 d0 00 10    	mov    ebp,DWORD PTR ds:0x1000d034
10007310:	7e 44                	jle    0x10007356
10007312:	a1 98 0a 01 10       	mov    eax,ds:0x10010a98
10007317:	56                   	push   esi
10007318:	57                   	push   edi
10007319:	8b 3d 50 d0 00 10    	mov    edi,DWORD PTR ds:0x1000d050
1000731f:	8d 70 0c             	lea    esi,[eax+0xc]
10007322:	68 00 40 00 00       	push   0x4000
10007327:	68 00 00 10 00       	push   0x100000
1000732c:	ff 36                	push   DWORD PTR [esi]
1000732e:	ff d7                	call   edi
10007330:	68 00 80 00 00       	push   0x8000
10007335:	6a 00                	push   0x0
10007337:	ff 36                	push   DWORD PTR [esi]
10007339:	ff d7                	call   edi
1000733b:	ff 76 04             	push   DWORD PTR [esi+0x4]
1000733e:	6a 00                	push   0x0
10007340:	ff 35 a4 0b 01 10    	push   DWORD PTR ds:0x10010ba4
10007346:	ff d5                	call   ebp
10007348:	83 c6 14             	add    esi,0x14
1000734b:	43                   	inc    ebx
1000734c:	3b 1d 94 0a 01 10    	cmp    ebx,DWORD PTR ds:0x10010a94
10007352:	7c ce                	jl     0x10007322
10007354:	5f                   	pop    edi
10007355:	5e                   	pop    esi
10007356:	ff 35 98 0a 01 10    	push   DWORD PTR ds:0x10010a98
1000735c:	6a 00                	push   0x0
1000735e:	ff 35 a4 0b 01 10    	push   DWORD PTR ds:0x10010ba4
10007364:	ff d5                	call   ebp
10007366:	ff 35 a4 0b 01 10    	push   DWORD PTR ds:0x10010ba4
1000736c:	ff 15 48 d0 00 10    	call   DWORD PTR ds:0x1000d048
10007372:	5d                   	pop    ebp
10007373:	5b                   	pop    ebx
10007374:	c3                   	ret
10007375:	83 ec 44             	sub    esp,0x44
10007378:	53                   	push   ebx
10007379:	55                   	push   ebp
1000737a:	56                   	push   esi
1000737b:	57                   	push   edi
1000737c:	68 00 01 00 00       	push   0x100
10007381:	e8 d3 ea ff ff       	call   0x10005e59
10007386:	8b f0                	mov    esi,eax
10007388:	59                   	pop    ecx
10007389:	85 f6                	test   esi,esi
1000738b:	75 08                	jne    0x10007395
1000738d:	6a 1b                	push   0x1b
1000738f:	e8 af e5 ff ff       	call   0x10005943
10007394:	59                   	pop    ecx
10007395:	89 35 a0 0a 01 10    	mov    DWORD PTR ds:0x10010aa0,esi
1000739b:	c7 05 a0 0b 01 10 20 	mov    DWORD PTR ds:0x10010ba0,0x20
100073a2:	00 00 00 
100073a5:	8d 86 00 01 00 00    	lea    eax,[esi+0x100]
100073ab:	3b f0                	cmp    esi,eax
100073ad:	73 1a                	jae    0x100073c9
100073af:	80 66 04 00          	and    BYTE PTR [esi+0x4],0x0
100073b3:	83 0e ff             	or     DWORD PTR [esi],0xffffffff
100073b6:	c6 46 05 0a          	mov    BYTE PTR [esi+0x5],0xa
100073ba:	a1 a0 0a 01 10       	mov    eax,ds:0x10010aa0
100073bf:	83 c6 08             	add    esi,0x8
100073c2:	05 00 01 00 00       	add    eax,0x100
100073c7:	eb e2                	jmp    0x100073ab
100073c9:	8d 44 24 10          	lea    eax,[esp+0x10]
100073cd:	50                   	push   eax
100073ce:	ff 15 60 d0 00 10    	call   DWORD PTR ds:0x1000d060
100073d4:	66 83 7c 24 42 00    	cmp    WORD PTR [esp+0x42],0x0
100073da:	0f 84 c5 00 00 00    	je     0x100074a5
100073e0:	8b 44 24 44          	mov    eax,DWORD PTR [esp+0x44]
100073e4:	85 c0                	test   eax,eax
100073e6:	0f 84 b9 00 00 00    	je     0x100074a5
100073ec:	8b 30                	mov    esi,DWORD PTR [eax]
100073ee:	8d 68 04             	lea    ebp,[eax+0x4]
100073f1:	b8 00 08 00 00       	mov    eax,0x800
100073f6:	3b f0                	cmp    esi,eax
100073f8:	8d 1c 2e             	lea    ebx,[esi+ebp*1]
100073fb:	7c 02                	jl     0x100073ff
100073fd:	8b f0                	mov    esi,eax
100073ff:	39 35 a0 0b 01 10    	cmp    DWORD PTR ds:0x10010ba0,esi
10007405:	7d 52                	jge    0x10007459
10007407:	bf a4 0a 01 10       	mov    edi,0x10010aa4
1000740c:	68 00 01 00 00       	push   0x100
10007411:	e8 43 ea ff ff       	call   0x10005e59
10007416:	85 c0                	test   eax,eax
10007418:	59                   	pop    ecx
10007419:	74 38                	je     0x10007453
1000741b:	83 05 a0 0b 01 10 20 	add    DWORD PTR ds:0x10010ba0,0x20
10007422:	89 07                	mov    DWORD PTR [edi],eax
10007424:	8d 88 00 01 00 00    	lea    ecx,[eax+0x100]
1000742a:	3b c1                	cmp    eax,ecx
1000742c:	73 18                	jae    0x10007446
1000742e:	80 60 04 00          	and    BYTE PTR [eax+0x4],0x0
10007432:	83 08 ff             	or     DWORD PTR [eax],0xffffffff
10007435:	c6 40 05 0a          	mov    BYTE PTR [eax+0x5],0xa
10007439:	8b 0f                	mov    ecx,DWORD PTR [edi]
1000743b:	83 c0 08             	add    eax,0x8
1000743e:	81 c1 00 01 00 00    	add    ecx,0x100
10007444:	eb e4                	jmp    0x1000742a
10007446:	83 c7 04             	add    edi,0x4
10007449:	39 35 a0 0b 01 10    	cmp    DWORD PTR ds:0x10010ba0,esi
1000744f:	7c bb                	jl     0x1000740c
10007451:	eb 06                	jmp    0x10007459
10007453:	8b 35 a0 0b 01 10    	mov    esi,DWORD PTR ds:0x10010ba0
10007459:	33 ff                	xor    edi,edi
1000745b:	85 f6                	test   esi,esi
1000745d:	7e 46                	jle    0x100074a5
1000745f:	8b 03                	mov    eax,DWORD PTR [ebx]
10007461:	83 f8 ff             	cmp    eax,0xffffffff
10007464:	74 36                	je     0x1000749c
10007466:	8a 4d 00             	mov    cl,BYTE PTR [ebp+0x0]
10007469:	f6 c1 01             	test   cl,0x1
1000746c:	74 2e                	je     0x1000749c
1000746e:	f6 c1 08             	test   cl,0x8
10007471:	75 0b                	jne    0x1000747e
10007473:	50                   	push   eax
10007474:	ff 15 5c d0 00 10    	call   DWORD PTR ds:0x1000d05c
1000747a:	85 c0                	test   eax,eax
1000747c:	74 1e                	je     0x1000749c
1000747e:	8b c7                	mov    eax,edi
10007480:	8b cf                	mov    ecx,edi
10007482:	c1 f8 05             	sar    eax,0x5
10007485:	83 e1 1f             	and    ecx,0x1f
10007488:	8b 04 85 a0 0a 01 10 	mov    eax,DWORD PTR [eax*4+0x10010aa0]
1000748f:	8d 04 c8             	lea    eax,[eax+ecx*8]
10007492:	8b 0b                	mov    ecx,DWORD PTR [ebx]
10007494:	89 08                	mov    DWORD PTR [eax],ecx
10007496:	8a 4d 00             	mov    cl,BYTE PTR [ebp+0x0]
10007499:	88 48 04             	mov    BYTE PTR [eax+0x4],cl
1000749c:	47                   	inc    edi
1000749d:	45                   	inc    ebp
1000749e:	83 c3 04             	add    ebx,0x4
100074a1:	3b fe                	cmp    edi,esi
100074a3:	7c ba                	jl     0x1000745f
100074a5:	33 db                	xor    ebx,ebx
100074a7:	a1 a0 0a 01 10       	mov    eax,ds:0x10010aa0
100074ac:	83 3c d8 ff          	cmp    DWORD PTR [eax+ebx*8],0xffffffff
100074b0:	8d 34 d8             	lea    esi,[eax+ebx*8]
100074b3:	75 4d                	jne    0x10007502
100074b5:	85 db                	test   ebx,ebx
100074b7:	c6 46 04 81          	mov    BYTE PTR [esi+0x4],0x81
100074bb:	75 05                	jne    0x100074c2
100074bd:	6a f6                	push   0xfffffff6
100074bf:	58                   	pop    eax
100074c0:	eb 0a                	jmp    0x100074cc
100074c2:	8b c3                	mov    eax,ebx
100074c4:	48                   	dec    eax
100074c5:	f7 d8                	neg    eax
100074c7:	1b c0                	sbb    eax,eax
100074c9:	83 c0 f5             	add    eax,0xfffffff5
100074cc:	50                   	push   eax
100074cd:	ff 15 58 d0 00 10    	call   DWORD PTR ds:0x1000d058
100074d3:	8b f8                	mov    edi,eax
100074d5:	83 ff ff             	cmp    edi,0xffffffff
100074d8:	74 17                	je     0x100074f1
100074da:	57                   	push   edi
100074db:	ff 15 5c d0 00 10    	call   DWORD PTR ds:0x1000d05c
100074e1:	85 c0                	test   eax,eax
100074e3:	74 0c                	je     0x100074f1
100074e5:	25 ff 00 00 00       	and    eax,0xff
100074ea:	89 3e                	mov    DWORD PTR [esi],edi
100074ec:	83 f8 02             	cmp    eax,0x2
100074ef:	75 06                	jne    0x100074f7
100074f1:	80 4e 04 40          	or     BYTE PTR [esi+0x4],0x40
100074f5:	eb 0f                	jmp    0x10007506
100074f7:	83 f8 03             	cmp    eax,0x3
100074fa:	75 0a                	jne    0x10007506
100074fc:	80 4e 04 08          	or     BYTE PTR [esi+0x4],0x8
10007500:	eb 04                	jmp    0x10007506
10007502:	80 4e 04 80          	or     BYTE PTR [esi+0x4],0x80
10007506:	43                   	inc    ebx
10007507:	83 fb 03             	cmp    ebx,0x3
1000750a:	7c 9b                	jl     0x100074a7
1000750c:	ff 35 a0 0b 01 10    	push   DWORD PTR ds:0x10010ba0
10007512:	ff 15 54 d0 00 10    	call   DWORD PTR ds:0x1000d054
10007518:	5f                   	pop    edi
10007519:	5e                   	pop    esi
1000751a:	5d                   	pop    ebp
1000751b:	5b                   	pop    ebx
1000751c:	83 c4 44             	add    esp,0x44
1000751f:	c3                   	ret
10007520:	56                   	push   esi
10007521:	be a0 0a 01 10       	mov    esi,0x10010aa0
10007526:	8b 06                	mov    eax,DWORD PTR [esi]
10007528:	85 c0                	test   eax,eax
1000752a:	74 0a                	je     0x10007536
1000752c:	50                   	push   eax
1000752d:	e8 f8 e8 ff ff       	call   0x10005e2a
10007532:	83 26 00             	and    DWORD PTR [esi],0x0
10007535:	59                   	pop    ecx
10007536:	83 c6 04             	add    esi,0x4
10007539:	81 fe a0 0b 01 10    	cmp    esi,0x10010ba0
1000753f:	7c e5                	jl     0x10007526
10007541:	5e                   	pop    esi
10007542:	c3                   	ret
10007543:	53                   	push   ebx
10007544:	33 db                	xor    ebx,ebx
10007546:	39 1d ac 0b 01 10    	cmp    DWORD PTR ds:0x10010bac,ebx
1000754c:	56                   	push   esi
1000754d:	57                   	push   edi
1000754e:	75 05                	jne    0x10007555
10007550:	e8 93 2f 00 00       	call   0x1000a4e8
10007555:	8b 35 1c f6 00 10    	mov    esi,DWORD PTR ds:0x1000f61c
1000755b:	33 ff                	xor    edi,edi
1000755d:	8a 06                	mov    al,BYTE PTR [esi]
1000755f:	3a c3                	cmp    al,bl
10007561:	74 12                	je     0x10007575
10007563:	3c 3d                	cmp    al,0x3d
10007565:	74 01                	je     0x10007568
10007567:	47                   	inc    edi
10007568:	56                   	push   esi
10007569:	e8 52 13 00 00       	call   0x100088c0
1000756e:	59                   	pop    ecx
1000756f:	8d 74 06 01          	lea    esi,[esi+eax*1+0x1]
10007573:	eb e8                	jmp    0x1000755d
10007575:	8d 04 bd 04 00 00 00 	lea    eax,[edi*4+0x4]
1000757c:	50                   	push   eax
1000757d:	e8 d7 e8 ff ff       	call   0x10005e59
10007582:	8b f0                	mov    esi,eax
10007584:	59                   	pop    ecx
10007585:	3b f3                	cmp    esi,ebx
10007587:	89 35 74 f6 00 10    	mov    DWORD PTR ds:0x1000f674,esi
1000758d:	75 08                	jne    0x10007597
1000758f:	6a 09                	push   0x9
10007591:	e8 ad e3 ff ff       	call   0x10005943
10007596:	59                   	pop    ecx
10007597:	8b 3d 1c f6 00 10    	mov    edi,DWORD PTR ds:0x1000f61c
1000759d:	38 1f                	cmp    BYTE PTR [edi],bl
1000759f:	74 39                	je     0x100075da
100075a1:	55                   	push   ebp
100075a2:	57                   	push   edi
100075a3:	e8 18 13 00 00       	call   0x100088c0
100075a8:	8b e8                	mov    ebp,eax
100075aa:	59                   	pop    ecx
100075ab:	45                   	inc    ebp
100075ac:	80 3f 3d             	cmp    BYTE PTR [edi],0x3d
100075af:	74 22                	je     0x100075d3
100075b1:	55                   	push   ebp
100075b2:	e8 a2 e8 ff ff       	call   0x10005e59
100075b7:	3b c3                	cmp    eax,ebx
100075b9:	59                   	pop    ecx
100075ba:	89 06                	mov    DWORD PTR [esi],eax
100075bc:	75 08                	jne    0x100075c6
100075be:	6a 09                	push   0x9
100075c0:	e8 7e e3 ff ff       	call   0x10005943
100075c5:	59                   	pop    ecx
100075c6:	57                   	push   edi
100075c7:	ff 36                	push   DWORD PTR [esi]
100075c9:	e8 c2 0c 00 00       	call   0x10008290
100075ce:	59                   	pop    ecx
100075cf:	83 c6 04             	add    esi,0x4
100075d2:	59                   	pop    ecx
100075d3:	03 fd                	add    edi,ebp
100075d5:	38 1f                	cmp    BYTE PTR [edi],bl
100075d7:	75 c9                	jne    0x100075a2
100075d9:	5d                   	pop    ebp
100075da:	ff 35 1c f6 00 10    	push   DWORD PTR ds:0x1000f61c
100075e0:	e8 45 e8 ff ff       	call   0x10005e2a
100075e5:	59                   	pop    ecx
100075e6:	89 1d 1c f6 00 10    	mov    DWORD PTR ds:0x1000f61c,ebx
100075ec:	89 1e                	mov    DWORD PTR [esi],ebx
100075ee:	5f                   	pop    edi
100075ef:	5e                   	pop    esi
100075f0:	c7 05 a8 0b 01 10 01 	mov    DWORD PTR ds:0x10010ba8,0x1
100075f7:	00 00 00 
100075fa:	5b                   	pop    ebx
100075fb:	c3                   	ret
100075fc:	55                   	push   ebp
100075fd:	8b ec                	mov    ebp,esp
100075ff:	51                   	push   ecx
10007600:	51                   	push   ecx
10007601:	53                   	push   ebx
10007602:	33 db                	xor    ebx,ebx
10007604:	39 1d ac 0b 01 10    	cmp    DWORD PTR ds:0x10010bac,ebx
1000760a:	56                   	push   esi
1000760b:	57                   	push   edi
1000760c:	75 05                	jne    0x10007613
1000760e:	e8 d5 2e 00 00       	call   0x1000a4e8
10007613:	be 98 f6 00 10       	mov    esi,0x1000f698
10007618:	68 04 01 00 00       	push   0x104
1000761d:	56                   	push   esi
1000761e:	53                   	push   ebx
1000761f:	ff 15 64 d0 00 10    	call   DWORD PTR ds:0x1000d064
10007625:	a1 b8 0b 01 10       	mov    eax,ds:0x10010bb8
1000762a:	89 35 84 f6 00 10    	mov    DWORD PTR ds:0x1000f684,esi
10007630:	8b fe                	mov    edi,esi
10007632:	38 18                	cmp    BYTE PTR [eax],bl
10007634:	74 02                	je     0x10007638
10007636:	8b f8                	mov    edi,eax
10007638:	8d 45 f8             	lea    eax,[ebp-0x8]
1000763b:	50                   	push   eax
1000763c:	8d 45 fc             	lea    eax,[ebp-0x4]
1000763f:	50                   	push   eax
10007640:	53                   	push   ebx
10007641:	53                   	push   ebx
10007642:	57                   	push   edi
10007643:	e8 4d 00 00 00       	call   0x10007695
10007648:	8b 45 f8             	mov    eax,DWORD PTR [ebp-0x8]
1000764b:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
1000764e:	8d 04 88             	lea    eax,[eax+ecx*4]
10007651:	50                   	push   eax
10007652:	e8 02 e8 ff ff       	call   0x10005e59
10007657:	8b f0                	mov    esi,eax
10007659:	83 c4 18             	add    esp,0x18
1000765c:	3b f3                	cmp    esi,ebx
1000765e:	75 08                	jne    0x10007668
10007660:	6a 08                	push   0x8
10007662:	e8 dc e2 ff ff       	call   0x10005943
10007667:	59                   	pop    ecx
10007668:	8d 45 f8             	lea    eax,[ebp-0x8]
1000766b:	50                   	push   eax
1000766c:	8d 45 fc             	lea    eax,[ebp-0x4]
1000766f:	50                   	push   eax
10007670:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
10007673:	8d 04 86             	lea    eax,[esi+eax*4]
10007676:	50                   	push   eax
10007677:	56                   	push   esi
10007678:	57                   	push   edi
10007679:	e8 17 00 00 00       	call   0x10007695
1000767e:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
10007681:	83 c4 14             	add    esp,0x14
10007684:	48                   	dec    eax
10007685:	89 35 6c f6 00 10    	mov    DWORD PTR ds:0x1000f66c,esi
1000768b:	5f                   	pop    edi
1000768c:	5e                   	pop    esi
1000768d:	a3 68 f6 00 10       	mov    ds:0x1000f668,eax
10007692:	5b                   	pop    ebx
10007693:	c9                   	leave
10007694:	c3                   	ret
10007695:	55                   	push   ebp
10007696:	8b ec                	mov    ebp,esp
10007698:	8b 4d 18             	mov    ecx,DWORD PTR [ebp+0x18]
1000769b:	8b 45 14             	mov    eax,DWORD PTR [ebp+0x14]
1000769e:	53                   	push   ebx
1000769f:	56                   	push   esi
100076a0:	83 21 00             	and    DWORD PTR [ecx],0x0
100076a3:	8b 75 10             	mov    esi,DWORD PTR [ebp+0x10]
100076a6:	57                   	push   edi
100076a7:	8b 7d 0c             	mov    edi,DWORD PTR [ebp+0xc]
100076aa:	c7 00 01 00 00 00    	mov    DWORD PTR [eax],0x1
100076b0:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100076b3:	85 ff                	test   edi,edi
100076b5:	74 08                	je     0x100076bf
100076b7:	89 37                	mov    DWORD PTR [edi],esi
100076b9:	83 c7 04             	add    edi,0x4
100076bc:	89 7d 0c             	mov    DWORD PTR [ebp+0xc],edi
100076bf:	80 38 22             	cmp    BYTE PTR [eax],0x22
100076c2:	75 44                	jne    0x10007708
100076c4:	8a 50 01             	mov    dl,BYTE PTR [eax+0x1]
100076c7:	40                   	inc    eax
100076c8:	80 fa 22             	cmp    dl,0x22
100076cb:	74 29                	je     0x100076f6
100076cd:	84 d2                	test   dl,dl
100076cf:	74 25                	je     0x100076f6
100076d1:	0f b6 d2             	movzx  edx,dl
100076d4:	f6 82 61 f9 00 10 04 	test   BYTE PTR [edx+0x1000f961],0x4
100076db:	74 0c                	je     0x100076e9
100076dd:	ff 01                	inc    DWORD PTR [ecx]
100076df:	85 f6                	test   esi,esi
100076e1:	74 06                	je     0x100076e9
100076e3:	8a 10                	mov    dl,BYTE PTR [eax]
100076e5:	88 16                	mov    BYTE PTR [esi],dl
100076e7:	46                   	inc    esi
100076e8:	40                   	inc    eax
100076e9:	ff 01                	inc    DWORD PTR [ecx]
100076eb:	85 f6                	test   esi,esi
100076ed:	74 d5                	je     0x100076c4
100076ef:	8a 10                	mov    dl,BYTE PTR [eax]
100076f1:	88 16                	mov    BYTE PTR [esi],dl
100076f3:	46                   	inc    esi
100076f4:	eb ce                	jmp    0x100076c4
100076f6:	ff 01                	inc    DWORD PTR [ecx]
100076f8:	85 f6                	test   esi,esi
100076fa:	74 04                	je     0x10007700
100076fc:	80 26 00             	and    BYTE PTR [esi],0x0
100076ff:	46                   	inc    esi
10007700:	80 38 22             	cmp    BYTE PTR [eax],0x22
10007703:	75 46                	jne    0x1000774b
10007705:	40                   	inc    eax
10007706:	eb 43                	jmp    0x1000774b
10007708:	ff 01                	inc    DWORD PTR [ecx]
1000770a:	85 f6                	test   esi,esi
1000770c:	74 05                	je     0x10007713
1000770e:	8a 10                	mov    dl,BYTE PTR [eax]
10007710:	88 16                	mov    BYTE PTR [esi],dl
10007712:	46                   	inc    esi
10007713:	8a 10                	mov    dl,BYTE PTR [eax]
10007715:	40                   	inc    eax
10007716:	0f b6 da             	movzx  ebx,dl
10007719:	f6 83 61 f9 00 10 04 	test   BYTE PTR [ebx+0x1000f961],0x4
10007720:	74 0c                	je     0x1000772e
10007722:	ff 01                	inc    DWORD PTR [ecx]
10007724:	85 f6                	test   esi,esi
10007726:	74 05                	je     0x1000772d
10007728:	8a 18                	mov    bl,BYTE PTR [eax]
1000772a:	88 1e                	mov    BYTE PTR [esi],bl
1000772c:	46                   	inc    esi
1000772d:	40                   	inc    eax
1000772e:	80 fa 20             	cmp    dl,0x20
10007731:	74 09                	je     0x1000773c
10007733:	84 d2                	test   dl,dl
10007735:	74 09                	je     0x10007740
10007737:	80 fa 09             	cmp    dl,0x9
1000773a:	75 cc                	jne    0x10007708
1000773c:	84 d2                	test   dl,dl
1000773e:	75 03                	jne    0x10007743
10007740:	48                   	dec    eax
10007741:	eb 08                	jmp    0x1000774b
10007743:	85 f6                	test   esi,esi
10007745:	74 04                	je     0x1000774b
10007747:	80 66 ff 00          	and    BYTE PTR [esi-0x1],0x0
1000774b:	83 65 18 00          	and    DWORD PTR [ebp+0x18],0x0
1000774f:	80 38 00             	cmp    BYTE PTR [eax],0x0
10007752:	0f 84 e0 00 00 00    	je     0x10007838
10007758:	8a 10                	mov    dl,BYTE PTR [eax]
1000775a:	80 fa 20             	cmp    dl,0x20
1000775d:	74 05                	je     0x10007764
1000775f:	80 fa 09             	cmp    dl,0x9
10007762:	75 03                	jne    0x10007767
10007764:	40                   	inc    eax
10007765:	eb f1                	jmp    0x10007758
10007767:	80 38 00             	cmp    BYTE PTR [eax],0x0
1000776a:	0f 84 c8 00 00 00    	je     0x10007838
10007770:	85 ff                	test   edi,edi
10007772:	74 08                	je     0x1000777c
10007774:	89 37                	mov    DWORD PTR [edi],esi
10007776:	83 c7 04             	add    edi,0x4
10007779:	89 7d 0c             	mov    DWORD PTR [ebp+0xc],edi
1000777c:	8b 55 14             	mov    edx,DWORD PTR [ebp+0x14]
1000777f:	ff 02                	inc    DWORD PTR [edx]
10007781:	c7 45 08 01 00 00 00 	mov    DWORD PTR [ebp+0x8],0x1
10007788:	33 db                	xor    ebx,ebx
1000778a:	80 38 5c             	cmp    BYTE PTR [eax],0x5c
1000778d:	75 04                	jne    0x10007793
1000778f:	40                   	inc    eax
10007790:	43                   	inc    ebx
10007791:	eb f7                	jmp    0x1000778a
10007793:	80 38 22             	cmp    BYTE PTR [eax],0x22
10007796:	75 2c                	jne    0x100077c4
10007798:	f6 c3 01             	test   bl,0x1
1000779b:	75 25                	jne    0x100077c2
1000779d:	33 ff                	xor    edi,edi
1000779f:	39 7d 18             	cmp    DWORD PTR [ebp+0x18],edi
100077a2:	74 0d                	je     0x100077b1
100077a4:	80 78 01 22          	cmp    BYTE PTR [eax+0x1],0x22
100077a8:	8d 50 01             	lea    edx,[eax+0x1]
100077ab:	75 04                	jne    0x100077b1
100077ad:	8b c2                	mov    eax,edx
100077af:	eb 03                	jmp    0x100077b4
100077b1:	89 7d 08             	mov    DWORD PTR [ebp+0x8],edi
100077b4:	8b 7d 0c             	mov    edi,DWORD PTR [ebp+0xc]
100077b7:	33 d2                	xor    edx,edx
100077b9:	39 55 18             	cmp    DWORD PTR [ebp+0x18],edx
100077bc:	0f 94 c2             	sete   dl
100077bf:	89 55 18             	mov    DWORD PTR [ebp+0x18],edx
100077c2:	d1 eb                	shr    ebx,1
100077c4:	8b d3                	mov    edx,ebx
100077c6:	4b                   	dec    ebx
100077c7:	85 d2                	test   edx,edx
100077c9:	74 0e                	je     0x100077d9
100077cb:	43                   	inc    ebx
100077cc:	85 f6                	test   esi,esi
100077ce:	74 04                	je     0x100077d4
100077d0:	c6 06 5c             	mov    BYTE PTR [esi],0x5c
100077d3:	46                   	inc    esi
100077d4:	ff 01                	inc    DWORD PTR [ecx]
100077d6:	4b                   	dec    ebx
100077d7:	75 f3                	jne    0x100077cc
100077d9:	8a 10                	mov    dl,BYTE PTR [eax]
100077db:	84 d2                	test   dl,dl
100077dd:	74 4a                	je     0x10007829
100077df:	83 7d 18 00          	cmp    DWORD PTR [ebp+0x18],0x0
100077e3:	75 0a                	jne    0x100077ef
100077e5:	80 fa 20             	cmp    dl,0x20
100077e8:	74 3f                	je     0x10007829
100077ea:	80 fa 09             	cmp    dl,0x9
100077ed:	74 3a                	je     0x10007829
100077ef:	83 7d 08 00          	cmp    DWORD PTR [ebp+0x8],0x0
100077f3:	74 2e                	je     0x10007823
100077f5:	85 f6                	test   esi,esi
100077f7:	74 19                	je     0x10007812
100077f9:	0f b6 da             	movzx  ebx,dl
100077fc:	f6 83 61 f9 00 10 04 	test   BYTE PTR [ebx+0x1000f961],0x4
10007803:	74 06                	je     0x1000780b
10007805:	88 16                	mov    BYTE PTR [esi],dl
10007807:	46                   	inc    esi
10007808:	40                   	inc    eax
10007809:	ff 01                	inc    DWORD PTR [ecx]
1000780b:	8a 10                	mov    dl,BYTE PTR [eax]
1000780d:	88 16                	mov    BYTE PTR [esi],dl
1000780f:	46                   	inc    esi
10007810:	eb 0f                	jmp    0x10007821
10007812:	0f b6 d2             	movzx  edx,dl
10007815:	f6 82 61 f9 00 10 04 	test   BYTE PTR [edx+0x1000f961],0x4
1000781c:	74 03                	je     0x10007821
1000781e:	40                   	inc    eax
1000781f:	ff 01                	inc    DWORD PTR [ecx]
10007821:	ff 01                	inc    DWORD PTR [ecx]
10007823:	40                   	inc    eax
10007824:	e9 58 ff ff ff       	jmp    0x10007781
10007829:	85 f6                	test   esi,esi
1000782b:	74 04                	je     0x10007831
1000782d:	80 26 00             	and    BYTE PTR [esi],0x0
10007830:	46                   	inc    esi
10007831:	ff 01                	inc    DWORD PTR [ecx]
10007833:	e9 17 ff ff ff       	jmp    0x1000774f
10007838:	85 ff                	test   edi,edi
1000783a:	74 03                	je     0x1000783f
1000783c:	83 27 00             	and    DWORD PTR [edi],0x0
1000783f:	8b 45 14             	mov    eax,DWORD PTR [ebp+0x14]
10007842:	5f                   	pop    edi
10007843:	5e                   	pop    esi
10007844:	5b                   	pop    ebx
10007845:	ff 00                	inc    DWORD PTR [eax]
10007847:	5d                   	pop    ebp
10007848:	c3                   	ret
10007849:	51                   	push   ecx
1000784a:	51                   	push   ecx
1000784b:	a1 9c f7 00 10       	mov    eax,ds:0x1000f79c
10007850:	53                   	push   ebx
10007851:	55                   	push   ebp
10007852:	8b 2d 78 d0 00 10    	mov    ebp,DWORD PTR ds:0x1000d078
10007858:	56                   	push   esi
10007859:	57                   	push   edi
1000785a:	33 db                	xor    ebx,ebx
1000785c:	33 f6                	xor    esi,esi
1000785e:	33 ff                	xor    edi,edi
10007860:	3b c3                	cmp    eax,ebx
10007862:	75 33                	jne    0x10007897
10007864:	ff d5                	call   ebp
10007866:	8b f0                	mov    esi,eax
10007868:	3b f3                	cmp    esi,ebx
1000786a:	74 0c                	je     0x10007878
1000786c:	c7 05 9c f7 00 10 01 	mov    DWORD PTR ds:0x1000f79c,0x1
10007873:	00 00 00 
10007876:	eb 28                	jmp    0x100078a0
10007878:	ff 15 74 d0 00 10    	call   DWORD PTR ds:0x1000d074
1000787e:	8b f8                	mov    edi,eax
10007880:	3b fb                	cmp    edi,ebx
10007882:	0f 84 ea 00 00 00    	je     0x10007972
10007888:	c7 05 9c f7 00 10 02 	mov    DWORD PTR ds:0x1000f79c,0x2
1000788f:	00 00 00 
10007892:	e9 8f 00 00 00       	jmp    0x10007926
10007897:	83 f8 01             	cmp    eax,0x1
1000789a:	0f 85 81 00 00 00    	jne    0x10007921
100078a0:	3b f3                	cmp    esi,ebx
100078a2:	75 0c                	jne    0x100078b0
100078a4:	ff d5                	call   ebp
100078a6:	8b f0                	mov    esi,eax
100078a8:	3b f3                	cmp    esi,ebx
100078aa:	0f 84 c2 00 00 00    	je     0x10007972
100078b0:	66 39 1e             	cmp    WORD PTR [esi],bx
100078b3:	8b c6                	mov    eax,esi
100078b5:	74 0e                	je     0x100078c5
100078b7:	40                   	inc    eax
100078b8:	40                   	inc    eax
100078b9:	66 39 18             	cmp    WORD PTR [eax],bx
100078bc:	75 f9                	jne    0x100078b7
100078be:	40                   	inc    eax
100078bf:	40                   	inc    eax
100078c0:	66 39 18             	cmp    WORD PTR [eax],bx
100078c3:	75 f2                	jne    0x100078b7
100078c5:	2b c6                	sub    eax,esi
100078c7:	8b 3d 70 d0 00 10    	mov    edi,DWORD PTR ds:0x1000d070
100078cd:	d1 f8                	sar    eax,1
100078cf:	53                   	push   ebx
100078d0:	53                   	push   ebx
100078d1:	40                   	inc    eax
100078d2:	53                   	push   ebx
100078d3:	53                   	push   ebx
100078d4:	50                   	push   eax
100078d5:	56                   	push   esi
100078d6:	53                   	push   ebx
100078d7:	53                   	push   ebx
100078d8:	89 44 24 34          	mov    DWORD PTR [esp+0x34],eax
100078dc:	ff d7                	call   edi
100078de:	8b e8                	mov    ebp,eax
100078e0:	3b eb                	cmp    ebp,ebx
100078e2:	74 32                	je     0x10007916
100078e4:	55                   	push   ebp
100078e5:	e8 6f e5 ff ff       	call   0x10005e59
100078ea:	3b c3                	cmp    eax,ebx
100078ec:	59                   	pop    ecx
100078ed:	89 44 24 10          	mov    DWORD PTR [esp+0x10],eax
100078f1:	74 23                	je     0x10007916
100078f3:	53                   	push   ebx
100078f4:	53                   	push   ebx
100078f5:	55                   	push   ebp
100078f6:	50                   	push   eax
100078f7:	ff 74 24 24          	push   DWORD PTR [esp+0x24]
100078fb:	56                   	push   esi
100078fc:	53                   	push   ebx
100078fd:	53                   	push   ebx
100078fe:	ff d7                	call   edi
10007900:	85 c0                	test   eax,eax
10007902:	75 0e                	jne    0x10007912
10007904:	ff 74 24 10          	push   DWORD PTR [esp+0x10]
10007908:	e8 1d e5 ff ff       	call   0x10005e2a
1000790d:	59                   	pop    ecx
1000790e:	89 5c 24 10          	mov    DWORD PTR [esp+0x10],ebx
10007912:	8b 5c 24 10          	mov    ebx,DWORD PTR [esp+0x10]
10007916:	56                   	push   esi
10007917:	ff 15 00 d0 00 10    	call   DWORD PTR ds:0x1000d000
1000791d:	8b c3                	mov    eax,ebx
1000791f:	eb 53                	jmp    0x10007974
10007921:	83 f8 02             	cmp    eax,0x2
10007924:	75 4c                	jne    0x10007972
10007926:	3b fb                	cmp    edi,ebx
10007928:	75 0c                	jne    0x10007936
1000792a:	ff 15 74 d0 00 10    	call   DWORD PTR ds:0x1000d074
10007930:	8b f8                	mov    edi,eax
10007932:	3b fb                	cmp    edi,ebx
10007934:	74 3c                	je     0x10007972
10007936:	38 1f                	cmp    BYTE PTR [edi],bl
10007938:	8b c7                	mov    eax,edi
1000793a:	74 0a                	je     0x10007946
1000793c:	40                   	inc    eax
1000793d:	38 18                	cmp    BYTE PTR [eax],bl
1000793f:	75 fb                	jne    0x1000793c
10007941:	40                   	inc    eax
10007942:	38 18                	cmp    BYTE PTR [eax],bl
10007944:	75 f6                	jne    0x1000793c
10007946:	2b c7                	sub    eax,edi
10007948:	40                   	inc    eax
10007949:	8b e8                	mov    ebp,eax
1000794b:	55                   	push   ebp
1000794c:	e8 08 e5 ff ff       	call   0x10005e59
10007951:	8b f0                	mov    esi,eax
10007953:	59                   	pop    ecx
10007954:	3b f3                	cmp    esi,ebx
10007956:	75 04                	jne    0x1000795c
10007958:	33 f6                	xor    esi,esi
1000795a:	eb 0b                	jmp    0x10007967
1000795c:	55                   	push   ebp
1000795d:	57                   	push   edi
1000795e:	56                   	push   esi
1000795f:	e8 ac 2b 00 00       	call   0x1000a510
10007964:	83 c4 0c             	add    esp,0xc
10007967:	57                   	push   edi
10007968:	ff 15 68 d0 00 10    	call   DWORD PTR ds:0x1000d068
1000796e:	8b c6                	mov    eax,esi
10007970:	eb 02                	jmp    0x10007974
10007972:	33 c0                	xor    eax,eax
10007974:	5f                   	pop    edi
10007975:	5e                   	pop    esi
10007976:	5d                   	pop    ebp
10007977:	5b                   	pop    ebx
10007978:	59                   	pop    ecx
10007979:	59                   	pop    ecx
1000797a:	c3                   	ret
1000797b:	a1 24 f6 00 10       	mov    eax,ds:0x1000f624
10007980:	83 f8 01             	cmp    eax,0x1
10007983:	74 0d                	je     0x10007992
10007985:	85 c0                	test   eax,eax
10007987:	75 2a                	jne    0x100079b3
10007989:	83 3d 28 f6 00 10 01 	cmp    DWORD PTR ds:0x1000f628,0x1
10007990:	75 21                	jne    0x100079b3
10007992:	68 fc 00 00 00       	push   0xfc
10007997:	e8 18 00 00 00       	call   0x100079b4
1000799c:	a1 a0 f7 00 10       	mov    eax,ds:0x1000f7a0
100079a1:	59                   	pop    ecx
100079a2:	85 c0                	test   eax,eax
100079a4:	74 02                	je     0x100079a8
100079a6:	ff d0                	call   eax
100079a8:	68 ff 00 00 00       	push   0xff
100079ad:	e8 02 00 00 00       	call   0x100079b4
100079b2:	59                   	pop    ecx
100079b3:	c3                   	ret
100079b4:	55                   	push   ebp
100079b5:	8b ec                	mov    ebp,esp
100079b7:	81 ec a4 01 00 00    	sub    esp,0x1a4
100079bd:	8b 55 08             	mov    edx,DWORD PTR [ebp+0x8]
100079c0:	33 c9                	xor    ecx,ecx
100079c2:	b8 b0 ec 00 10       	mov    eax,0x1000ecb0
100079c7:	3b 10                	cmp    edx,DWORD PTR [eax]
100079c9:	74 0b                	je     0x100079d6
100079cb:	83 c0 08             	add    eax,0x8
100079ce:	41                   	inc    ecx
100079cf:	3d 40 ed 00 10       	cmp    eax,0x1000ed40
100079d4:	7c f1                	jl     0x100079c7
100079d6:	56                   	push   esi
100079d7:	8b f1                	mov    esi,ecx
100079d9:	c1 e6 03             	shl    esi,0x3
100079dc:	3b 96 b0 ec 00 10    	cmp    edx,DWORD PTR [esi+0x1000ecb0]
100079e2:	0f 85 1c 01 00 00    	jne    0x10007b04
100079e8:	a1 24 f6 00 10       	mov    eax,ds:0x1000f624
100079ed:	83 f8 01             	cmp    eax,0x1
100079f0:	0f 84 e8 00 00 00    	je     0x10007ade
100079f6:	85 c0                	test   eax,eax
100079f8:	75 0d                	jne    0x10007a07
100079fa:	83 3d 28 f6 00 10 01 	cmp    DWORD PTR ds:0x1000f628,0x1
10007a01:	0f 84 d7 00 00 00    	je     0x10007ade
10007a07:	81 fa fc 00 00 00    	cmp    edx,0xfc
10007a0d:	0f 84 f1 00 00 00    	je     0x10007b04
10007a13:	8d 85 5c fe ff ff    	lea    eax,[ebp-0x1a4]
10007a19:	68 04 01 00 00       	push   0x104
10007a1e:	50                   	push   eax
10007a1f:	6a 00                	push   0x0
10007a21:	ff 15 64 d0 00 10    	call   DWORD PTR ds:0x1000d064
10007a27:	85 c0                	test   eax,eax
10007a29:	75 13                	jne    0x10007a3e
10007a2b:	8d 85 5c fe ff ff    	lea    eax,[ebp-0x1a4]
10007a31:	68 78 d5 00 10       	push   0x1000d578
10007a36:	50                   	push   eax
10007a37:	e8 54 08 00 00       	call   0x10008290
10007a3c:	59                   	pop    ecx
10007a3d:	59                   	pop    ecx
10007a3e:	8d 85 5c fe ff ff    	lea    eax,[ebp-0x1a4]
10007a44:	57                   	push   edi
10007a45:	50                   	push   eax
10007a46:	8d bd 5c fe ff ff    	lea    edi,[ebp-0x1a4]
10007a4c:	e8 6f 0e 00 00       	call   0x100088c0
10007a51:	40                   	inc    eax
10007a52:	59                   	pop    ecx
10007a53:	83 f8 3c             	cmp    eax,0x3c
10007a56:	76 29                	jbe    0x10007a81
10007a58:	8d 85 5c fe ff ff    	lea    eax,[ebp-0x1a4]
10007a5e:	50                   	push   eax
10007a5f:	e8 5c 0e 00 00       	call   0x100088c0
10007a64:	8b f8                	mov    edi,eax
10007a66:	8d 85 5c fe ff ff    	lea    eax,[ebp-0x1a4]
10007a6c:	83 e8 3b             	sub    eax,0x3b
10007a6f:	6a 03                	push   0x3
10007a71:	03 f8                	add    edi,eax
10007a73:	68 74 d5 00 10       	push   0x1000d574
10007a78:	57                   	push   edi
10007a79:	e8 52 2e 00 00       	call   0x1000a8d0
10007a7e:	83 c4 10             	add    esp,0x10
10007a81:	8d 85 60 ff ff ff    	lea    eax,[ebp-0xa0]
10007a87:	68 58 d5 00 10       	push   0x1000d558
10007a8c:	50                   	push   eax
10007a8d:	e8 fe 07 00 00       	call   0x10008290
10007a92:	8d 85 60 ff ff ff    	lea    eax,[ebp-0xa0]
10007a98:	57                   	push   edi
10007a99:	50                   	push   eax
10007a9a:	e8 01 08 00 00       	call   0x100082a0
10007a9f:	8d 85 60 ff ff ff    	lea    eax,[ebp-0xa0]
10007aa5:	68 54 d5 00 10       	push   0x1000d554
10007aaa:	50                   	push   eax
10007aab:	e8 f0 07 00 00       	call   0x100082a0
10007ab0:	ff b6 b4 ec 00 10    	push   DWORD PTR [esi+0x1000ecb4]
10007ab6:	8d 85 60 ff ff ff    	lea    eax,[ebp-0xa0]
10007abc:	50                   	push   eax
10007abd:	e8 de 07 00 00       	call   0x100082a0
10007ac2:	68 10 20 01 00       	push   0x12010
10007ac7:	8d 85 60 ff ff ff    	lea    eax,[ebp-0xa0]
10007acd:	68 2c d5 00 10       	push   0x1000d52c
10007ad2:	50                   	push   eax
10007ad3:	e8 6d 2d 00 00       	call   0x1000a845
10007ad8:	83 c4 2c             	add    esp,0x2c
10007adb:	5f                   	pop    edi
10007adc:	eb 26                	jmp    0x10007b04
10007ade:	8d 45 08             	lea    eax,[ebp+0x8]
10007ae1:	8d b6 b4 ec 00 10    	lea    esi,[esi+0x1000ecb4]
10007ae7:	6a 00                	push   0x0
10007ae9:	50                   	push   eax
10007aea:	ff 36                	push   DWORD PTR [esi]
10007aec:	e8 cf 0d 00 00       	call   0x100088c0
10007af1:	59                   	pop    ecx
10007af2:	50                   	push   eax
10007af3:	ff 36                	push   DWORD PTR [esi]
10007af5:	6a f4                	push   0xfffffff4
10007af7:	ff 15 58 d0 00 10    	call   DWORD PTR ds:0x1000d058
10007afd:	50                   	push   eax
10007afe:	ff 15 7c d0 00 10    	call   DWORD PTR ds:0x1000d07c
10007b04:	5e                   	pop    esi
10007b05:	c9                   	leave
10007b06:	c3                   	ret
10007b07:	8b 4c 24 04          	mov    ecx,DWORD PTR [esp+0x4]
10007b0b:	33 d2                	xor    edx,edx
10007b0d:	b8 b0 ec 00 10       	mov    eax,0x1000ecb0
10007b12:	3b 08                	cmp    ecx,DWORD PTR [eax]
10007b14:	74 0b                	je     0x10007b21
10007b16:	83 c0 08             	add    eax,0x8
10007b19:	42                   	inc    edx
10007b1a:	3d 40 ed 00 10       	cmp    eax,0x1000ed40
10007b1f:	7c f1                	jl     0x10007b12
10007b21:	8b c2                	mov    eax,edx
10007b23:	c1 e0 03             	shl    eax,0x3
10007b26:	3b 88 b0 ec 00 10    	cmp    ecx,DWORD PTR [eax+0x1000ecb0]
10007b2c:	75 07                	jne    0x10007b35
10007b2e:	8b 80 b4 ec 00 10    	mov    eax,DWORD PTR [eax+0x1000ecb4]
10007b34:	c3                   	ret
10007b35:	33 c0                	xor    eax,eax
10007b37:	c3                   	ret
10007b38:	55                   	push   ebp
10007b39:	8b ec                	mov    ebp,esp
10007b3b:	51                   	push   ecx
10007b3c:	9b dd 7d fc          	fstsw  WORD PTR [ebp-0x4]
10007b40:	ff 75 fc             	push   DWORD PTR [ebp-0x4]
10007b43:	e8 a7 01 00 00       	call   0x10007cef
10007b48:	59                   	pop    ecx
10007b49:	c9                   	leave
10007b4a:	c3                   	ret
10007b4b:	55                   	push   ebp
10007b4c:	8b ec                	mov    ebp,esp
10007b4e:	51                   	push   ecx
10007b4f:	dd 7d fc             	fnstsw WORD PTR [ebp-0x4]
10007b52:	db e2                	fnclex
10007b54:	ff 75 fc             	push   DWORD PTR [ebp-0x4]
10007b57:	e8 93 01 00 00       	call   0x10007cef
10007b5c:	59                   	pop    ecx
10007b5d:	c9                   	leave
10007b5e:	c3                   	ret
10007b5f:	55                   	push   ebp
10007b60:	8b ec                	mov    ebp,esp
10007b62:	51                   	push   ecx
10007b63:	56                   	push   esi
10007b64:	9b d9 7d fc          	fstcw  WORD PTR [ebp-0x4]
10007b68:	ff 75 fc             	push   DWORD PTR [ebp-0x4]
10007b6b:	e8 64 00 00 00       	call   0x10007bd4
10007b70:	8b f0                	mov    esi,eax
10007b72:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10007b75:	f7 d0                	not    eax
10007b77:	23 f0                	and    esi,eax
10007b79:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10007b7c:	23 45 0c             	and    eax,DWORD PTR [ebp+0xc]
10007b7f:	0b f0                	or     esi,eax
10007b81:	56                   	push   esi
10007b82:	e8 df 00 00 00       	call   0x10007c66
10007b87:	59                   	pop    ecx
10007b88:	89 45 0c             	mov    DWORD PTR [ebp+0xc],eax
10007b8b:	59                   	pop    ecx
10007b8c:	d9 6d 0c             	fldcw  WORD PTR [ebp+0xc]
10007b8f:	8b c6                	mov    eax,esi
10007b91:	5e                   	pop    esi
10007b92:	c9                   	leave
10007b93:	c3                   	ret
10007b94:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
10007b98:	25 ff ff f7 ff       	and    eax,0xfff7ffff
10007b9d:	50                   	push   eax
10007b9e:	ff 74 24 08          	push   DWORD PTR [esp+0x8]
10007ba2:	e8 b8 ff ff ff       	call   0x10007b5f
10007ba7:	59                   	pop    ecx
10007ba8:	59                   	pop    ecx
10007ba9:	c3                   	ret
10007baa:	56                   	push   esi
10007bab:	8b 35 fc f7 00 10    	mov    esi,DWORD PTR ds:0x1000f7fc
10007bb1:	db e3                	fninit
10007bb3:	e8 be dd ff ff       	call   0x10005976
10007bb8:	85 f6                	test   esi,esi
10007bba:	74 16                	je     0x10007bd2
10007bbc:	8b 46 04             	mov    eax,DWORD PTR [esi+0x4]
10007bbf:	f7 00 08 00 01 00    	test   DWORD PTR [eax],0x10008
10007bc5:	74 0b                	je     0x10007bd2
10007bc7:	83 60 20 00          	and    DWORD PTR [eax+0x20],0x0
10007bcb:	c7 40 24 ff ff 00 00 	mov    DWORD PTR [eax+0x24],0xffff
10007bd2:	5e                   	pop    esi
10007bd3:	c3                   	ret
10007bd4:	53                   	push   ebx
10007bd5:	8b 5c 24 08          	mov    ebx,DWORD PTR [esp+0x8]
10007bd9:	33 c0                	xor    eax,eax
10007bdb:	55                   	push   ebp
10007bdc:	f6 c3 01             	test   bl,0x1
10007bdf:	57                   	push   edi
10007be0:	74 03                	je     0x10007be5
10007be2:	6a 10                	push   0x10
10007be4:	58                   	pop    eax
10007be5:	f6 c3 04             	test   bl,0x4
10007be8:	74 02                	je     0x10007bec
10007bea:	0c 08                	or     al,0x8
10007bec:	f6 c3 08             	test   bl,0x8
10007bef:	74 02                	je     0x10007bf3
10007bf1:	0c 04                	or     al,0x4
10007bf3:	f6 c3 10             	test   bl,0x10
10007bf6:	74 02                	je     0x10007bfa
10007bf8:	0c 02                	or     al,0x2
10007bfa:	f6 c3 20             	test   bl,0x20
10007bfd:	74 02                	je     0x10007c01
10007bff:	0c 01                	or     al,0x1
10007c01:	f6 c3 02             	test   bl,0x2
10007c04:	74 05                	je     0x10007c0b
10007c06:	0d 00 00 08 00       	or     eax,0x80000
10007c0b:	0f b7 cb             	movzx  ecx,bx
10007c0e:	56                   	push   esi
10007c0f:	8b d1                	mov    edx,ecx
10007c11:	be 00 0c 00 00       	mov    esi,0xc00
10007c16:	bf 00 03 00 00       	mov    edi,0x300
10007c1b:	23 d6                	and    edx,esi
10007c1d:	bd 00 02 00 00       	mov    ebp,0x200
10007c22:	74 1f                	je     0x10007c43
10007c24:	81 fa 00 04 00 00    	cmp    edx,0x400
10007c2a:	74 14                	je     0x10007c40
10007c2c:	81 fa 00 08 00 00    	cmp    edx,0x800
10007c32:	74 08                	je     0x10007c3c
10007c34:	3b d6                	cmp    edx,esi
10007c36:	75 0b                	jne    0x10007c43
10007c38:	0b c7                	or     eax,edi
10007c3a:	eb 07                	jmp    0x10007c43
10007c3c:	0b c5                	or     eax,ebp
10007c3e:	eb 03                	jmp    0x10007c43
10007c40:	80 cc 01             	or     ah,0x1
10007c43:	23 cf                	and    ecx,edi
10007c45:	5e                   	pop    esi
10007c46:	74 0b                	je     0x10007c53
10007c48:	3b cd                	cmp    ecx,ebp
10007c4a:	75 0c                	jne    0x10007c58
10007c4c:	0d 00 00 01 00       	or     eax,0x10000
10007c51:	eb 05                	jmp    0x10007c58
10007c53:	0d 00 00 02 00       	or     eax,0x20000
10007c58:	5f                   	pop    edi
10007c59:	5d                   	pop    ebp
10007c5a:	f6 c7 10             	test   bh,0x10
10007c5d:	5b                   	pop    ebx
10007c5e:	74 05                	je     0x10007c65
10007c60:	0d 00 00 04 00       	or     eax,0x40000
10007c65:	c3                   	ret
10007c66:	53                   	push   ebx
10007c67:	8b 5c 24 08          	mov    ebx,DWORD PTR [esp+0x8]
10007c6b:	33 c0                	xor    eax,eax
10007c6d:	56                   	push   esi
10007c6e:	f6 c3 10             	test   bl,0x10
10007c71:	74 03                	je     0x10007c76
10007c73:	6a 01                	push   0x1
10007c75:	58                   	pop    eax
10007c76:	f6 c3 08             	test   bl,0x8
10007c79:	74 02                	je     0x10007c7d
10007c7b:	0c 04                	or     al,0x4
10007c7d:	f6 c3 04             	test   bl,0x4
10007c80:	74 02                	je     0x10007c84
10007c82:	0c 08                	or     al,0x8
10007c84:	f6 c3 02             	test   bl,0x2
10007c87:	74 02                	je     0x10007c8b
10007c89:	0c 10                	or     al,0x10
10007c8b:	f6 c3 01             	test   bl,0x1
10007c8e:	74 02                	je     0x10007c92
10007c90:	0c 20                	or     al,0x20
10007c92:	f7 c3 00 00 08 00    	test   ebx,0x80000
10007c98:	74 02                	je     0x10007c9c
10007c9a:	0c 02                	or     al,0x2
10007c9c:	8b cb                	mov    ecx,ebx
10007c9e:	ba 00 03 00 00       	mov    edx,0x300
10007ca3:	23 ca                	and    ecx,edx
10007ca5:	be 00 02 00 00       	mov    esi,0x200
10007caa:	74 1d                	je     0x10007cc9
10007cac:	81 f9 00 01 00 00    	cmp    ecx,0x100
10007cb2:	74 12                	je     0x10007cc6
10007cb4:	3b ce                	cmp    ecx,esi
10007cb6:	74 09                	je     0x10007cc1
10007cb8:	3b ca                	cmp    ecx,edx
10007cba:	75 0d                	jne    0x10007cc9
10007cbc:	80 cc 0c             	or     ah,0xc
10007cbf:	eb 08                	jmp    0x10007cc9
10007cc1:	80 cc 08             	or     ah,0x8
10007cc4:	eb 03                	jmp    0x10007cc9
10007cc6:	80 cc 04             	or     ah,0x4
10007cc9:	8b cb                	mov    ecx,ebx
10007ccb:	81 e1 00 00 03 00    	and    ecx,0x30000
10007cd1:	74 0c                	je     0x10007cdf
10007cd3:	81 f9 00 00 01 00    	cmp    ecx,0x10000
10007cd9:	75 06                	jne    0x10007ce1
10007cdb:	0b c6                	or     eax,esi
10007cdd:	eb 02                	jmp    0x10007ce1
10007cdf:	0b c2                	or     eax,edx
10007ce1:	5e                   	pop    esi
10007ce2:	f7 c3 00 00 04 00    	test   ebx,0x40000
10007ce8:	5b                   	pop    ebx
10007ce9:	74 03                	je     0x10007cee
10007ceb:	80 cc 10             	or     ah,0x10
10007cee:	c3                   	ret
10007cef:	8a 4c 24 04          	mov    cl,BYTE PTR [esp+0x4]
10007cf3:	33 c0                	xor    eax,eax
10007cf5:	f6 c1 01             	test   cl,0x1
10007cf8:	74 03                	je     0x10007cfd
10007cfa:	6a 10                	push   0x10
10007cfc:	58                   	pop    eax
10007cfd:	f6 c1 04             	test   cl,0x4
10007d00:	74 02                	je     0x10007d04
10007d02:	0c 08                	or     al,0x8
10007d04:	f6 c1 08             	test   cl,0x8
10007d07:	74 02                	je     0x10007d0b
10007d09:	0c 04                	or     al,0x4
10007d0b:	f6 c1 10             	test   cl,0x10
10007d0e:	74 02                	je     0x10007d12
10007d10:	0c 02                	or     al,0x2
10007d12:	f6 c1 20             	test   cl,0x20
10007d15:	74 02                	je     0x10007d19
10007d17:	0c 01                	or     al,0x1
10007d19:	f6 c1 02             	test   cl,0x2
10007d1c:	74 05                	je     0x10007d23
10007d1e:	0d 00 00 08 00       	or     eax,0x80000
10007d23:	c3                   	ret
10007d24:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
10007d28:	83 c0 20             	add    eax,0x20
10007d2b:	c3                   	ret
10007d2c:	55                   	push   ebp
10007d2d:	8b ec                	mov    ebp,esp
10007d2f:	51                   	push   ecx
10007d30:	83 3d 0c f8 00 10 00 	cmp    DWORD PTR ds:0x1000f80c,0x0
10007d37:	53                   	push   ebx
10007d38:	56                   	push   esi
10007d39:	57                   	push   edi
10007d3a:	75 1d                	jne    0x10007d59
10007d3c:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10007d3f:	83 f8 41             	cmp    eax,0x41
10007d42:	0f 8c aa 00 00 00    	jl     0x10007df2
10007d48:	83 f8 5a             	cmp    eax,0x5a
10007d4b:	0f 8f a1 00 00 00    	jg     0x10007df2
10007d51:	83 c0 20             	add    eax,0x20
10007d54:	e9 99 00 00 00       	jmp    0x10007df2
10007d59:	8b 5d 08             	mov    ebx,DWORD PTR [ebp+0x8]
10007d5c:	bf 00 01 00 00       	mov    edi,0x100
10007d61:	6a 01                	push   0x1
10007d63:	3b df                	cmp    ebx,edi
10007d65:	5e                   	pop    esi
10007d66:	7d 25                	jge    0x10007d8d
10007d68:	39 35 94 ec 00 10    	cmp    DWORD PTR ds:0x1000ec94,esi
10007d6e:	7e 0b                	jle    0x10007d7b
10007d70:	56                   	push   esi
10007d71:	53                   	push   ebx
10007d72:	e8 81 f3 ff ff       	call   0x100070f8
10007d77:	59                   	pop    ecx
10007d78:	59                   	pop    ecx
10007d79:	eb 0a                	jmp    0x10007d85
10007d7b:	a1 88 ea 00 10       	mov    eax,ds:0x1000ea88
10007d80:	8a 04 58             	mov    al,BYTE PTR [eax+ebx*2]
10007d83:	23 c6                	and    eax,esi
10007d85:	85 c0                	test   eax,eax
10007d87:	75 04                	jne    0x10007d8d
10007d89:	8b c3                	mov    eax,ebx
10007d8b:	eb 65                	jmp    0x10007df2
10007d8d:	8b 15 88 ea 00 10    	mov    edx,DWORD PTR ds:0x1000ea88
10007d93:	8b c3                	mov    eax,ebx
10007d95:	c1 f8 08             	sar    eax,0x8
10007d98:	0f b6 c8             	movzx  ecx,al
10007d9b:	f6 44 4a 01 80       	test   BYTE PTR [edx+ecx*2+0x1],0x80
10007da0:	74 0f                	je     0x10007db1
10007da2:	80 65 0a 00          	and    BYTE PTR [ebp+0xa],0x0
10007da6:	6a 02                	push   0x2
10007da8:	88 45 08             	mov    BYTE PTR [ebp+0x8],al
10007dab:	88 5d 09             	mov    BYTE PTR [ebp+0x9],bl
10007dae:	58                   	pop    eax
10007daf:	eb 09                	jmp    0x10007dba
10007db1:	80 65 09 00          	and    BYTE PTR [ebp+0x9],0x0
10007db5:	88 5d 08             	mov    BYTE PTR [ebp+0x8],bl
10007db8:	8b c6                	mov    eax,esi
10007dba:	56                   	push   esi
10007dbb:	6a 00                	push   0x0
10007dbd:	8d 4d fc             	lea    ecx,[ebp-0x4]
10007dc0:	6a 03                	push   0x3
10007dc2:	51                   	push   ecx
10007dc3:	50                   	push   eax
10007dc4:	8d 45 08             	lea    eax,[ebp+0x8]
10007dc7:	50                   	push   eax
10007dc8:	57                   	push   edi
10007dc9:	ff 35 0c f8 00 10    	push   DWORD PTR ds:0x1000f80c
10007dcf:	e8 7e 2d 00 00       	call   0x1000ab52
10007dd4:	83 c4 20             	add    esp,0x20
10007dd7:	85 c0                	test   eax,eax
10007dd9:	74 ae                	je     0x10007d89
10007ddb:	3b c6                	cmp    eax,esi
10007ddd:	75 06                	jne    0x10007de5
10007ddf:	0f b6 45 fc          	movzx  eax,BYTE PTR [ebp-0x4]
10007de3:	eb 0d                	jmp    0x10007df2
10007de5:	0f b6 45 fd          	movzx  eax,BYTE PTR [ebp-0x3]
10007de9:	0f b6 4d fc          	movzx  ecx,BYTE PTR [ebp-0x4]
10007ded:	c1 e0 08             	shl    eax,0x8
10007df0:	0b c1                	or     eax,ecx
10007df2:	5f                   	pop    edi
10007df3:	5e                   	pop    esi
10007df4:	5b                   	pop    ebx
10007df5:	c9                   	leave
10007df6:	c3                   	ret
10007df7:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
10007dfb:	56                   	push   esi
10007dfc:	6a 20                	push   0x20
10007dfe:	99                   	cdq
10007dff:	59                   	pop    ecx
10007e00:	f7 f9                	idiv   ecx
10007e02:	6a 1f                	push   0x1f
10007e04:	8b f0                	mov    esi,eax
10007e06:	8b 44 24 10          	mov    eax,DWORD PTR [esp+0x10]
10007e0a:	99                   	cdq
10007e0b:	f7 f9                	idiv   ecx
10007e0d:	59                   	pop    ecx
10007e0e:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
10007e12:	2b ca                	sub    ecx,edx
10007e14:	83 ca ff             	or     edx,0xffffffff
10007e17:	d3 e2                	shl    edx,cl
10007e19:	f7 d2                	not    edx
10007e1b:	85 14 b0             	test   DWORD PTR [eax+esi*4],edx
10007e1e:	75 1c                	jne    0x10007e3c
10007e20:	46                   	inc    esi
10007e21:	83 fe 03             	cmp    esi,0x3
10007e24:	7d 11                	jge    0x10007e37
10007e26:	8d 04 b0             	lea    eax,[eax+esi*4]
10007e29:	83 38 00             	cmp    DWORD PTR [eax],0x0
10007e2c:	75 0e                	jne    0x10007e3c
10007e2e:	46                   	inc    esi
10007e2f:	83 c0 04             	add    eax,0x4
10007e32:	83 fe 03             	cmp    esi,0x3
10007e35:	7c f2                	jl     0x10007e29
10007e37:	6a 01                	push   0x1
10007e39:	58                   	pop    eax
10007e3a:	5e                   	pop    esi
10007e3b:	c3                   	ret
10007e3c:	33 c0                	xor    eax,eax
10007e3e:	5e                   	pop    esi
10007e3f:	c3                   	ret
10007e40:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
10007e44:	53                   	push   ebx
10007e45:	56                   	push   esi
10007e46:	57                   	push   edi
10007e47:	6a 20                	push   0x20
10007e49:	8b 5c 24 14          	mov    ebx,DWORD PTR [esp+0x14]
10007e4d:	99                   	cdq
10007e4e:	59                   	pop    ecx
10007e4f:	f7 f9                	idiv   ecx
10007e51:	8b f0                	mov    esi,eax
10007e53:	8b 44 24 14          	mov    eax,DWORD PTR [esp+0x14]
10007e57:	99                   	cdq
10007e58:	f7 f9                	idiv   ecx
10007e5a:	8d 3c b3             	lea    edi,[ebx+esi*4]
10007e5d:	57                   	push   edi
10007e5e:	6a 1f                	push   0x1f
10007e60:	59                   	pop    ecx
10007e61:	6a 01                	push   0x1
10007e63:	58                   	pop    eax
10007e64:	2b ca                	sub    ecx,edx
10007e66:	d3 e0                	shl    eax,cl
10007e68:	50                   	push   eax
10007e69:	ff 37                	push   DWORD PTR [edi]
10007e6b:	e8 31 2f 00 00       	call   0x1000ada1
10007e70:	83 c4 0c             	add    esp,0xc
10007e73:	4e                   	dec    esi
10007e74:	78 1c                	js     0x10007e92
10007e76:	8d 3c b3             	lea    edi,[ebx+esi*4]
10007e79:	85 c0                	test   eax,eax
10007e7b:	74 15                	je     0x10007e92
10007e7d:	57                   	push   edi
10007e7e:	6a 01                	push   0x1
10007e80:	ff 37                	push   DWORD PTR [edi]
10007e82:	e8 1a 2f 00 00       	call   0x1000ada1
10007e87:	83 c4 0c             	add    esp,0xc
10007e8a:	4e                   	dec    esi
10007e8b:	83 ef 04             	sub    edi,0x4
10007e8e:	85 f6                	test   esi,esi
10007e90:	7d e7                	jge    0x10007e79
10007e92:	5f                   	pop    edi
10007e93:	5e                   	pop    esi
10007e94:	5b                   	pop    ebx
10007e95:	c3                   	ret
10007e96:	55                   	push   ebp
10007e97:	8b ec                	mov    ebp,esp
10007e99:	51                   	push   ecx
10007e9a:	51                   	push   ecx
10007e9b:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10007e9e:	53                   	push   ebx
10007e9f:	56                   	push   esi
10007ea0:	57                   	push   edi
10007ea1:	8d 78 ff             	lea    edi,[eax-0x1]
10007ea4:	6a 20                	push   0x20
10007ea6:	59                   	pop    ecx
10007ea7:	83 65 fc 00          	and    DWORD PTR [ebp-0x4],0x0
10007eab:	8d 5f 01             	lea    ebx,[edi+0x1]
10007eae:	6a 20                	push   0x20
10007eb0:	8b c3                	mov    eax,ebx
10007eb2:	5e                   	pop    esi
10007eb3:	99                   	cdq
10007eb4:	f7 f9                	idiv   ecx
10007eb6:	6a 1f                	push   0x1f
10007eb8:	8b c8                	mov    ecx,eax
10007eba:	8b c3                	mov    eax,ebx
10007ebc:	99                   	cdq
10007ebd:	f7 fe                	idiv   esi
10007ebf:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10007ec2:	5e                   	pop    esi
10007ec3:	6a 01                	push   0x1
10007ec5:	89 4d f8             	mov    DWORD PTR [ebp-0x8],ecx
10007ec8:	8d 04 88             	lea    eax,[eax+ecx*4]
10007ecb:	89 45 0c             	mov    DWORD PTR [ebp+0xc],eax
10007ece:	2b f2                	sub    esi,edx
10007ed0:	5a                   	pop    edx
10007ed1:	8b ce                	mov    ecx,esi
10007ed3:	d3 e2                	shl    edx,cl
10007ed5:	85 10                	test   DWORD PTR [eax],edx
10007ed7:	74 21                	je     0x10007efa
10007ed9:	43                   	inc    ebx
10007eda:	53                   	push   ebx
10007edb:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10007ede:	e8 14 ff ff ff       	call   0x10007df7
10007ee3:	59                   	pop    ecx
10007ee4:	85 c0                	test   eax,eax
10007ee6:	59                   	pop    ecx
10007ee7:	75 0e                	jne    0x10007ef7
10007ee9:	57                   	push   edi
10007eea:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10007eed:	e8 4e ff ff ff       	call   0x10007e40
10007ef2:	59                   	pop    ecx
10007ef3:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
10007ef6:	59                   	pop    ecx
10007ef7:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10007efa:	83 ca ff             	or     edx,0xffffffff
10007efd:	8b ce                	mov    ecx,esi
10007eff:	d3 e2                	shl    edx,cl
10007f01:	6a 03                	push   0x3
10007f03:	59                   	pop    ecx
10007f04:	21 10                	and    DWORD PTR [eax],edx
10007f06:	8b 45 f8             	mov    eax,DWORD PTR [ebp-0x8]
10007f09:	40                   	inc    eax
10007f0a:	3b c1                	cmp    eax,ecx
10007f0c:	7d 0c                	jge    0x10007f1a
10007f0e:	8b 55 08             	mov    edx,DWORD PTR [ebp+0x8]
10007f11:	2b c8                	sub    ecx,eax
10007f13:	8d 3c 82             	lea    edi,[edx+eax*4]
10007f16:	33 c0                	xor    eax,eax
10007f18:	f3 ab                	rep stos DWORD PTR es:[edi],eax
10007f1a:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
10007f1d:	5f                   	pop    edi
10007f1e:	5e                   	pop    esi
10007f1f:	5b                   	pop    ebx
10007f20:	c9                   	leave
10007f21:	c3                   	ret
10007f22:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
10007f26:	8b 4c 24 04          	mov    ecx,DWORD PTR [esp+0x4]
10007f2a:	56                   	push   esi
10007f2b:	6a 03                	push   0x3
10007f2d:	2b c8                	sub    ecx,eax
10007f2f:	5a                   	pop    edx
10007f30:	8b 30                	mov    esi,DWORD PTR [eax]
10007f32:	89 34 01             	mov    DWORD PTR [ecx+eax*1],esi
10007f35:	83 c0 04             	add    eax,0x4
10007f38:	4a                   	dec    edx
10007f39:	75 f5                	jne    0x10007f30
10007f3b:	5e                   	pop    esi
10007f3c:	c3                   	ret
10007f3d:	57                   	push   edi
10007f3e:	8b 7c 24 08          	mov    edi,DWORD PTR [esp+0x8]
10007f42:	33 c0                	xor    eax,eax
10007f44:	ab                   	stos   DWORD PTR es:[edi],eax
10007f45:	ab                   	stos   DWORD PTR es:[edi],eax
10007f46:	ab                   	stos   DWORD PTR es:[edi],eax
10007f47:	5f                   	pop    edi
10007f48:	c3                   	ret
10007f49:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
10007f4d:	33 c9                	xor    ecx,ecx
10007f4f:	83 38 00             	cmp    DWORD PTR [eax],0x0
10007f52:	75 0d                	jne    0x10007f61
10007f54:	41                   	inc    ecx
10007f55:	83 c0 04             	add    eax,0x4
10007f58:	83 f9 03             	cmp    ecx,0x3
10007f5b:	7c f2                	jl     0x10007f4f
10007f5d:	6a 01                	push   0x1
10007f5f:	58                   	pop    eax
10007f60:	c3                   	ret
10007f61:	33 c0                	xor    eax,eax
10007f63:	c3                   	ret
10007f64:	55                   	push   ebp
10007f65:	8b ec                	mov    ebp,esp
10007f67:	83 ec 0c             	sub    esp,0xc
10007f6a:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10007f6d:	53                   	push   ebx
10007f6e:	56                   	push   esi
10007f6f:	57                   	push   edi
10007f70:	6a 20                	push   0x20
10007f72:	8b 7d 08             	mov    edi,DWORD PTR [ebp+0x8]
10007f75:	5b                   	pop    ebx
10007f76:	83 ce ff             	or     esi,0xffffffff
10007f79:	99                   	cdq
10007f7a:	8b cb                	mov    ecx,ebx
10007f7c:	c7 45 fc 03 00 00 00 	mov    DWORD PTR [ebp-0x4],0x3
10007f83:	f7 f9                	idiv   ecx
10007f85:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax
10007f88:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10007f8b:	99                   	cdq
10007f8c:	f7 f9                	idiv   ecx
10007f8e:	83 65 0c 00          	and    DWORD PTR [ebp+0xc],0x0
10007f92:	8b ca                	mov    ecx,edx
10007f94:	d3 e6                	shl    esi,cl
10007f96:	2b da                	sub    ebx,edx
10007f98:	f7 d6                	not    esi
10007f9a:	8b 07                	mov    eax,DWORD PTR [edi]
10007f9c:	8b c8                	mov    ecx,eax
10007f9e:	23 ce                	and    ecx,esi
10007fa0:	89 4d f8             	mov    DWORD PTR [ebp-0x8],ecx
10007fa3:	8b ca                	mov    ecx,edx
10007fa5:	d3 e8                	shr    eax,cl
10007fa7:	0b 45 0c             	or     eax,DWORD PTR [ebp+0xc]
10007faa:	89 07                	mov    DWORD PTR [edi],eax
10007fac:	8b 45 f8             	mov    eax,DWORD PTR [ebp-0x8]
10007faf:	8b cb                	mov    ecx,ebx
10007fb1:	83 c7 04             	add    edi,0x4
10007fb4:	d3 e0                	shl    eax,cl
10007fb6:	ff 4d fc             	dec    DWORD PTR [ebp-0x4]
10007fb9:	89 45 0c             	mov    DWORD PTR [ebp+0xc],eax
10007fbc:	75 dc                	jne    0x10007f9a
10007fbe:	8b 7d f4             	mov    edi,DWORD PTR [ebp-0xc]
10007fc1:	6a 02                	push   0x2
10007fc3:	5b                   	pop    ebx
10007fc4:	8b f7                	mov    esi,edi
10007fc6:	6a 08                	push   0x8
10007fc8:	59                   	pop    ecx
10007fc9:	c1 e6 02             	shl    esi,0x2
10007fcc:	3b df                	cmp    ebx,edi
10007fce:	7c 0f                	jl     0x10007fdf
10007fd0:	8b 55 08             	mov    edx,DWORD PTR [ebp+0x8]
10007fd3:	8b c1                	mov    eax,ecx
10007fd5:	2b c6                	sub    eax,esi
10007fd7:	8b 04 10             	mov    eax,DWORD PTR [eax+edx*1]
10007fda:	89 04 11             	mov    DWORD PTR [ecx+edx*1],eax
10007fdd:	eb 07                	jmp    0x10007fe6
10007fdf:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10007fe2:	83 24 01 00          	and    DWORD PTR [ecx+eax*1],0x0
10007fe6:	4b                   	dec    ebx
10007fe7:	83 e9 04             	sub    ecx,0x4
10007fea:	79 e0                	jns    0x10007fcc
10007fec:	5f                   	pop    edi
10007fed:	5e                   	pop    esi
10007fee:	5b                   	pop    ebx
10007fef:	c9                   	leave
10007ff0:	c3                   	ret
10007ff1:	55                   	push   ebp
10007ff2:	8b ec                	mov    ebp,esp
10007ff4:	83 ec 18             	sub    esp,0x18
10007ff7:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10007ffa:	53                   	push   ebx
10007ffb:	56                   	push   esi
10007ffc:	57                   	push   edi
10007ffd:	0f b7 48 0a          	movzx  ecx,WORD PTR [eax+0xa]
10008001:	8b d9                	mov    ebx,ecx
10008003:	81 e1 00 80 00 00    	and    ecx,0x8000
10008009:	89 4d 08             	mov    DWORD PTR [ebp+0x8],ecx
1000800c:	8b 48 06             	mov    ecx,DWORD PTR [eax+0x6]
1000800f:	89 4d f4             	mov    DWORD PTR [ebp-0xc],ecx
10008012:	8b 48 02             	mov    ecx,DWORD PTR [eax+0x2]
10008015:	0f b7 00             	movzx  eax,WORD PTR [eax]
10008018:	8b 7d 10             	mov    edi,DWORD PTR [ebp+0x10]
1000801b:	81 e3 ff 7f 00 00    	and    ebx,0x7fff
10008021:	81 eb ff 3f 00 00    	sub    ebx,0x3fff
10008027:	89 4d f8             	mov    DWORD PTR [ebp-0x8],ecx
1000802a:	c1 e0 10             	shl    eax,0x10
1000802d:	81 fb 01 c0 ff ff    	cmp    ebx,0xffffc001
10008033:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
10008036:	75 26                	jne    0x1000805e
10008038:	8d 45 f4             	lea    eax,[ebp-0xc]
1000803b:	33 f6                	xor    esi,esi
1000803d:	50                   	push   eax
1000803e:	e8 06 ff ff ff       	call   0x10007f49
10008043:	85 c0                	test   eax,eax
10008045:	59                   	pop    ecx
10008046:	0f 85 d1 00 00 00    	jne    0x1000811d
1000804c:	8d 45 f4             	lea    eax,[ebp-0xc]
1000804f:	50                   	push   eax
10008050:	e8 e8 fe ff ff       	call   0x10007f3d
10008055:	59                   	pop    ecx
10008056:	6a 02                	push   0x2
10008058:	58                   	pop    eax
10008059:	e9 c1 00 00 00       	jmp    0x1000811f
1000805e:	8d 45 f4             	lea    eax,[ebp-0xc]
10008061:	50                   	push   eax
10008062:	8d 45 e8             	lea    eax,[ebp-0x18]
10008065:	50                   	push   eax
10008066:	e8 b7 fe ff ff       	call   0x10007f22
1000806b:	ff 77 08             	push   DWORD PTR [edi+0x8]
1000806e:	8d 45 f4             	lea    eax,[ebp-0xc]
10008071:	50                   	push   eax
10008072:	e8 1f fe ff ff       	call   0x10007e96
10008077:	83 c4 10             	add    esp,0x10
1000807a:	85 c0                	test   eax,eax
1000807c:	74 01                	je     0x1000807f
1000807e:	43                   	inc    ebx
1000807f:	8b 47 04             	mov    eax,DWORD PTR [edi+0x4]
10008082:	8b c8                	mov    ecx,eax
10008084:	2b 4f 08             	sub    ecx,DWORD PTR [edi+0x8]
10008087:	3b d9                	cmp    ebx,ecx
10008089:	7d 0c                	jge    0x10008097
1000808b:	8d 45 f4             	lea    eax,[ebp-0xc]
1000808e:	50                   	push   eax
1000808f:	e8 a9 fe ff ff       	call   0x10007f3d
10008094:	59                   	pop    ecx
10008095:	eb 3c                	jmp    0x100080d3
10008097:	3b d8                	cmp    ebx,eax
10008099:	7f 3f                	jg     0x100080da
1000809b:	2b c3                	sub    eax,ebx
1000809d:	8b f0                	mov    esi,eax
1000809f:	8d 45 e8             	lea    eax,[ebp-0x18]
100080a2:	50                   	push   eax
100080a3:	8d 45 f4             	lea    eax,[ebp-0xc]
100080a6:	50                   	push   eax
100080a7:	e8 76 fe ff ff       	call   0x10007f22
100080ac:	8d 45 f4             	lea    eax,[ebp-0xc]
100080af:	56                   	push   esi
100080b0:	50                   	push   eax
100080b1:	e8 ae fe ff ff       	call   0x10007f64
100080b6:	ff 77 08             	push   DWORD PTR [edi+0x8]
100080b9:	8d 45 f4             	lea    eax,[ebp-0xc]
100080bc:	50                   	push   eax
100080bd:	e8 d4 fd ff ff       	call   0x10007e96
100080c2:	8b 47 0c             	mov    eax,DWORD PTR [edi+0xc]
100080c5:	40                   	inc    eax
100080c6:	50                   	push   eax
100080c7:	8d 45 f4             	lea    eax,[ebp-0xc]
100080ca:	50                   	push   eax
100080cb:	e8 94 fe ff ff       	call   0x10007f64
100080d0:	83 c4 20             	add    esp,0x20
100080d3:	33 f6                	xor    esi,esi
100080d5:	e9 7c ff ff ff       	jmp    0x10008056
100080da:	3b 1f                	cmp    ebx,DWORD PTR [edi]
100080dc:	7c 28                	jl     0x10008106
100080de:	8d 45 f4             	lea    eax,[ebp-0xc]
100080e1:	50                   	push   eax
100080e2:	e8 56 fe ff ff       	call   0x10007f3d
100080e7:	ff 77 0c             	push   DWORD PTR [edi+0xc]
100080ea:	80 4d f7 80          	or     BYTE PTR [ebp-0x9],0x80
100080ee:	8d 45 f4             	lea    eax,[ebp-0xc]
100080f1:	50                   	push   eax
100080f2:	e8 6d fe ff ff       	call   0x10007f64
100080f7:	8b 77 14             	mov    esi,DWORD PTR [edi+0x14]
100080fa:	83 c4 0c             	add    esp,0xc
100080fd:	03 37                	add    esi,DWORD PTR [edi]
100080ff:	6a 01                	push   0x1
10008101:	e9 52 ff ff ff       	jmp    0x10008058
10008106:	ff 77 0c             	push   DWORD PTR [edi+0xc]
10008109:	8b 77 14             	mov    esi,DWORD PTR [edi+0x14]
1000810c:	80 65 f7 7f          	and    BYTE PTR [ebp-0x9],0x7f
10008110:	8d 45 f4             	lea    eax,[ebp-0xc]
10008113:	50                   	push   eax
10008114:	03 f3                	add    esi,ebx
10008116:	e8 49 fe ff ff       	call   0x10007f64
1000811b:	59                   	pop    ecx
1000811c:	59                   	pop    ecx
1000811d:	33 c0                	xor    eax,eax
1000811f:	6a 1f                	push   0x1f
10008121:	59                   	pop    ecx
10008122:	2b 4f 0c             	sub    ecx,DWORD PTR [edi+0xc]
10008125:	8b 7f 10             	mov    edi,DWORD PTR [edi+0x10]
10008128:	d3 e6                	shl    esi,cl
1000812a:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
1000812d:	f7 d9                	neg    ecx
1000812f:	1b c9                	sbb    ecx,ecx
10008131:	81 e1 00 00 00 80    	and    ecx,0x80000000
10008137:	0b f1                	or     esi,ecx
10008139:	0b 75 f4             	or     esi,DWORD PTR [ebp-0xc]
1000813c:	83 ff 40             	cmp    edi,0x40
1000813f:	75 0d                	jne    0x1000814e
10008141:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
10008144:	8b 55 f8             	mov    edx,DWORD PTR [ebp-0x8]
10008147:	89 71 04             	mov    DWORD PTR [ecx+0x4],esi
1000814a:	89 11                	mov    DWORD PTR [ecx],edx
1000814c:	eb 0a                	jmp    0x10008158
1000814e:	83 ff 20             	cmp    edi,0x20
10008151:	75 05                	jne    0x10008158
10008153:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
10008156:	89 31                	mov    DWORD PTR [ecx],esi
10008158:	5f                   	pop    edi
10008159:	5e                   	pop    esi
1000815a:	5b                   	pop    ebx
1000815b:	c9                   	leave
1000815c:	c3                   	ret
1000815d:	68 40 ed 00 10       	push   0x1000ed40
10008162:	ff 74 24 0c          	push   DWORD PTR [esp+0xc]
10008166:	ff 74 24 0c          	push   DWORD PTR [esp+0xc]
1000816a:	e8 82 fe ff ff       	call   0x10007ff1
1000816f:	83 c4 0c             	add    esp,0xc
10008172:	c3                   	ret
10008173:	68 58 ed 00 10       	push   0x1000ed58
10008178:	ff 74 24 0c          	push   DWORD PTR [esp+0xc]
1000817c:	ff 74 24 0c          	push   DWORD PTR [esp+0xc]
10008180:	e8 6c fe ff ff       	call   0x10007ff1
10008185:	83 c4 0c             	add    esp,0xc
10008188:	c3                   	ret
10008189:	55                   	push   ebp
1000818a:	8b ec                	mov    ebp,esp
1000818c:	83 ec 10             	sub    esp,0x10
1000818f:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10008192:	56                   	push   esi
10008193:	57                   	push   edi
10008194:	83 65 fc 00          	and    DWORD PTR [ebp-0x4],0x0
10008198:	66 8b 48 0a          	mov    cx,WORD PTR [eax+0xa]
1000819c:	6a 40                	push   0x40
1000819e:	8b f1                	mov    esi,ecx
100081a0:	81 e1 00 80 00 00    	and    ecx,0x8000
100081a6:	8b f9                	mov    edi,ecx
100081a8:	8b 48 06             	mov    ecx,DWORD PTR [eax+0x6]
100081ab:	89 4d f0             	mov    DWORD PTR [ebp-0x10],ecx
100081ae:	8b 48 02             	mov    ecx,DWORD PTR [eax+0x2]
100081b1:	0f b7 00             	movzx  eax,WORD PTR [eax]
100081b4:	c1 e0 10             	shl    eax,0x10
100081b7:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
100081ba:	8d 45 f0             	lea    eax,[ebp-0x10]
100081bd:	50                   	push   eax
100081be:	81 e6 ff 7f 00 00    	and    esi,0x7fff
100081c4:	89 4d f4             	mov    DWORD PTR [ebp-0xc],ecx
100081c7:	e8 ca fc ff ff       	call   0x10007e96
100081cc:	59                   	pop    ecx
100081cd:	85 c0                	test   eax,eax
100081cf:	59                   	pop    ecx
100081d0:	74 08                	je     0x100081da
100081d2:	b9 00 00 00 80       	mov    ecx,0x80000000
100081d7:	46                   	inc    esi
100081d8:	eb 03                	jmp    0x100081dd
100081da:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
100081dd:	66 81 fe ff 7f       	cmp    si,0x7fff
100081e2:	75 07                	jne    0x100081eb
100081e4:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [ebp-0x4],0x1
100081eb:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
100081ee:	0b fe                	or     edi,esi
100081f0:	89 48 04             	mov    DWORD PTR [eax+0x4],ecx
100081f3:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
100081f6:	66 89 78 08          	mov    WORD PTR [eax+0x8],di
100081fa:	89 08                	mov    DWORD PTR [eax],ecx
100081fc:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
100081ff:	5f                   	pop    edi
10008200:	5e                   	pop    esi
10008201:	c9                   	leave
10008202:	c3                   	ret
10008203:	55                   	push   ebp
10008204:	8b ec                	mov    ebp,esp
10008206:	83 ec 0c             	sub    esp,0xc
10008209:	33 c0                	xor    eax,eax
1000820b:	50                   	push   eax
1000820c:	50                   	push   eax
1000820d:	50                   	push   eax
1000820e:	50                   	push   eax
1000820f:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
10008212:	8d 45 0c             	lea    eax,[ebp+0xc]
10008215:	50                   	push   eax
10008216:	8d 45 f4             	lea    eax,[ebp-0xc]
10008219:	50                   	push   eax
1000821a:	e8 23 2d 00 00       	call   0x1000af42
1000821f:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10008222:	8d 45 f4             	lea    eax,[ebp-0xc]
10008225:	50                   	push   eax
10008226:	e8 32 ff ff ff       	call   0x1000815d
1000822b:	83 c4 24             	add    esp,0x24
1000822e:	c9                   	leave
1000822f:	c3                   	ret
10008230:	55                   	push   ebp
10008231:	8b ec                	mov    ebp,esp
10008233:	83 ec 0c             	sub    esp,0xc
10008236:	33 c0                	xor    eax,eax
10008238:	50                   	push   eax
10008239:	50                   	push   eax
1000823a:	50                   	push   eax
1000823b:	6a 01                	push   0x1
1000823d:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
10008240:	8d 45 0c             	lea    eax,[ebp+0xc]
10008243:	50                   	push   eax
10008244:	8d 45 f4             	lea    eax,[ebp-0xc]
10008247:	50                   	push   eax
10008248:	e8 f5 2c 00 00       	call   0x1000af42
1000824d:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10008250:	8d 45 f4             	lea    eax,[ebp-0xc]
10008253:	50                   	push   eax
10008254:	e8 30 ff ff ff       	call   0x10008189
10008259:	83 c4 24             	add    esp,0x24
1000825c:	c9                   	leave
1000825d:	c3                   	ret
1000825e:	55                   	push   ebp
1000825f:	8b ec                	mov    ebp,esp
10008261:	83 ec 0c             	sub    esp,0xc
10008264:	33 c0                	xor    eax,eax
10008266:	50                   	push   eax
10008267:	50                   	push   eax
10008268:	50                   	push   eax
10008269:	50                   	push   eax
1000826a:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
1000826d:	8d 45 0c             	lea    eax,[ebp+0xc]
10008270:	50                   	push   eax
10008271:	8d 45 f4             	lea    eax,[ebp-0xc]
10008274:	50                   	push   eax
10008275:	e8 c8 2c 00 00       	call   0x1000af42
1000827a:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000827d:	8d 45 f4             	lea    eax,[ebp-0xc]
10008280:	50                   	push   eax
10008281:	e8 ed fe ff ff       	call   0x10008173
10008286:	83 c4 24             	add    esp,0x24
10008289:	c9                   	leave
1000828a:	c3                   	ret
1000828b:	cc                   	int3
1000828c:	cc                   	int3
1000828d:	cc                   	int3
1000828e:	cc                   	int3
1000828f:	cc                   	int3
10008290:	57                   	push   edi
10008291:	8b 7c 24 08          	mov    edi,DWORD PTR [esp+0x8]
10008295:	eb 6a                	jmp    0x10008301
10008297:	8d a4 24 00 00 00 00 	lea    esp,[esp+0x0]
1000829e:	8b ff                	mov    edi,edi
100082a0:	8b 4c 24 04          	mov    ecx,DWORD PTR [esp+0x4]
100082a4:	57                   	push   edi
100082a5:	f7 c1 03 00 00 00    	test   ecx,0x3
100082ab:	74 0f                	je     0x100082bc
100082ad:	8a 01                	mov    al,BYTE PTR [ecx]
100082af:	41                   	inc    ecx
100082b0:	84 c0                	test   al,al
100082b2:	74 3b                	je     0x100082ef
100082b4:	f7 c1 03 00 00 00    	test   ecx,0x3
100082ba:	75 f1                	jne    0x100082ad
100082bc:	8b 01                	mov    eax,DWORD PTR [ecx]
100082be:	ba ff fe fe 7e       	mov    edx,0x7efefeff
100082c3:	03 d0                	add    edx,eax
100082c5:	83 f0 ff             	xor    eax,0xffffffff
100082c8:	33 c2                	xor    eax,edx
100082ca:	83 c1 04             	add    ecx,0x4
100082cd:	a9 00 01 01 81       	test   eax,0x81010100
100082d2:	74 e8                	je     0x100082bc
100082d4:	8b 41 fc             	mov    eax,DWORD PTR [ecx-0x4]
100082d7:	84 c0                	test   al,al
100082d9:	74 23                	je     0x100082fe
100082db:	84 e4                	test   ah,ah
100082dd:	74 1a                	je     0x100082f9
100082df:	a9 00 00 ff 00       	test   eax,0xff0000
100082e4:	74 0e                	je     0x100082f4
100082e6:	a9 00 00 00 ff       	test   eax,0xff000000
100082eb:	74 02                	je     0x100082ef
100082ed:	eb cd                	jmp    0x100082bc
100082ef:	8d 79 ff             	lea    edi,[ecx-0x1]
100082f2:	eb 0d                	jmp    0x10008301
100082f4:	8d 79 fe             	lea    edi,[ecx-0x2]
100082f7:	eb 08                	jmp    0x10008301
100082f9:	8d 79 fd             	lea    edi,[ecx-0x3]
100082fc:	eb 03                	jmp    0x10008301
100082fe:	8d 79 fc             	lea    edi,[ecx-0x4]
10008301:	8b 4c 24 0c          	mov    ecx,DWORD PTR [esp+0xc]
10008305:	f7 c1 03 00 00 00    	test   ecx,0x3
1000830b:	74 19                	je     0x10008326
1000830d:	8a 11                	mov    dl,BYTE PTR [ecx]
1000830f:	41                   	inc    ecx
10008310:	84 d2                	test   dl,dl
10008312:	74 64                	je     0x10008378
10008314:	88 17                	mov    BYTE PTR [edi],dl
10008316:	47                   	inc    edi
10008317:	f7 c1 03 00 00 00    	test   ecx,0x3
1000831d:	75 ee                	jne    0x1000830d
1000831f:	eb 05                	jmp    0x10008326
10008321:	89 17                	mov    DWORD PTR [edi],edx
10008323:	83 c7 04             	add    edi,0x4
10008326:	ba ff fe fe 7e       	mov    edx,0x7efefeff
1000832b:	8b 01                	mov    eax,DWORD PTR [ecx]
1000832d:	03 d0                	add    edx,eax
1000832f:	83 f0 ff             	xor    eax,0xffffffff
10008332:	33 c2                	xor    eax,edx
10008334:	8b 11                	mov    edx,DWORD PTR [ecx]
10008336:	83 c1 04             	add    ecx,0x4
10008339:	a9 00 01 01 81       	test   eax,0x81010100
1000833e:	74 e1                	je     0x10008321
10008340:	84 d2                	test   dl,dl
10008342:	74 34                	je     0x10008378
10008344:	84 f6                	test   dh,dh
10008346:	74 27                	je     0x1000836f
10008348:	f7 c2 00 00 ff 00    	test   edx,0xff0000
1000834e:	74 12                	je     0x10008362
10008350:	f7 c2 00 00 00 ff    	test   edx,0xff000000
10008356:	74 02                	je     0x1000835a
10008358:	eb c7                	jmp    0x10008321
1000835a:	89 17                	mov    DWORD PTR [edi],edx
1000835c:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
10008360:	5f                   	pop    edi
10008361:	c3                   	ret
10008362:	66 89 17             	mov    WORD PTR [edi],dx
10008365:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
10008369:	c6 47 02 00          	mov    BYTE PTR [edi+0x2],0x0
1000836d:	5f                   	pop    edi
1000836e:	c3                   	ret
1000836f:	66 89 17             	mov    WORD PTR [edi],dx
10008372:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
10008376:	5f                   	pop    edi
10008377:	c3                   	ret
10008378:	88 17                	mov    BYTE PTR [edi],dl
1000837a:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
1000837e:	5f                   	pop    edi
1000837f:	c3                   	ret
10008380:	55                   	push   ebp
10008381:	8b ec                	mov    ebp,esp
10008383:	8b 55 10             	mov    edx,DWORD PTR [ebp+0x10]
10008386:	53                   	push   ebx
10008387:	8b 5d 0c             	mov    ebx,DWORD PTR [ebp+0xc]
1000838a:	56                   	push   esi
1000838b:	8b 75 08             	mov    esi,DWORD PTR [ebp+0x8]
1000838e:	8b 4a 0c             	mov    ecx,DWORD PTR [edx+0xc]
10008391:	57                   	push   edi
10008392:	8d 7e 01             	lea    edi,[esi+0x1]
10008395:	c6 06 30             	mov    BYTE PTR [esi],0x30
10008398:	85 db                	test   ebx,ebx
1000839a:	8b c7                	mov    eax,edi
1000839c:	7e 1f                	jle    0x100083bd
1000839e:	89 5d 08             	mov    DWORD PTR [ebp+0x8],ebx
100083a1:	33 db                	xor    ebx,ebx
100083a3:	8a 11                	mov    dl,BYTE PTR [ecx]
100083a5:	84 d2                	test   dl,dl
100083a7:	74 06                	je     0x100083af
100083a9:	0f be d2             	movsx  edx,dl
100083ac:	41                   	inc    ecx
100083ad:	eb 03                	jmp    0x100083b2
100083af:	6a 30                	push   0x30
100083b1:	5a                   	pop    edx
100083b2:	88 10                	mov    BYTE PTR [eax],dl
100083b4:	40                   	inc    eax
100083b5:	ff 4d 08             	dec    DWORD PTR [ebp+0x8]
100083b8:	75 e9                	jne    0x100083a3
100083ba:	8b 55 10             	mov    edx,DWORD PTR [ebp+0x10]
100083bd:	80 20 00             	and    BYTE PTR [eax],0x0
100083c0:	85 db                	test   ebx,ebx
100083c2:	7c 12                	jl     0x100083d6
100083c4:	80 39 35             	cmp    BYTE PTR [ecx],0x35
100083c7:	7c 0d                	jl     0x100083d6
100083c9:	48                   	dec    eax
100083ca:	80 38 39             	cmp    BYTE PTR [eax],0x39
100083cd:	75 05                	jne    0x100083d4
100083cf:	c6 00 30             	mov    BYTE PTR [eax],0x30
100083d2:	eb f5                	jmp    0x100083c9
100083d4:	fe 00                	inc    BYTE PTR [eax]
100083d6:	80 3e 31             	cmp    BYTE PTR [esi],0x31
100083d9:	75 05                	jne    0x100083e0
100083db:	ff 42 04             	inc    DWORD PTR [edx+0x4]
100083de:	eb 12                	jmp    0x100083f2
100083e0:	57                   	push   edi
100083e1:	e8 da 04 00 00       	call   0x100088c0
100083e6:	40                   	inc    eax
100083e7:	50                   	push   eax
100083e8:	57                   	push   edi
100083e9:	56                   	push   esi
100083ea:	e8 91 01 00 00       	call   0x10008580
100083ef:	83 c4 10             	add    esp,0x10
100083f2:	5f                   	pop    edi
100083f3:	5e                   	pop    esi
100083f4:	5b                   	pop    ebx
100083f5:	5d                   	pop    ebp
100083f6:	c3                   	ret
100083f7:	55                   	push   ebp
100083f8:	8b ec                	mov    ebp,esp
100083fa:	83 ec 0c             	sub    esp,0xc
100083fd:	56                   	push   esi
100083fe:	8d 45 08             	lea    eax,[ebp+0x8]
10008401:	57                   	push   edi
10008402:	50                   	push   eax
10008403:	8d 45 f4             	lea    eax,[ebp-0xc]
10008406:	50                   	push   eax
10008407:	e8 4f 00 00 00       	call   0x1000845b
1000840c:	59                   	pop    ecx
1000840d:	8d 75 f4             	lea    esi,[ebp-0xc]
10008410:	59                   	pop    ecx
10008411:	68 a8 f7 00 10       	push   0x1000f7a8
10008416:	6a 00                	push   0x0
10008418:	6a 11                	push   0x11
1000841a:	83 ec 0c             	sub    esp,0xc
1000841d:	8b fc                	mov    edi,esp
1000841f:	a5                   	movs   DWORD PTR es:[edi],DWORD PTR ds:[esi]
10008420:	a5                   	movs   DWORD PTR es:[edi],DWORD PTR ds:[esi]
10008421:	66 a5                	movs   WORD PTR es:[edi],WORD PTR ds:[esi]
10008423:	e8 27 30 00 00       	call   0x1000b44f
10008428:	a3 d0 f7 00 10       	mov    ds:0x1000f7d0,eax
1000842d:	83 c4 18             	add    esp,0x18
10008430:	0f be 05 aa f7 00 10 	movsx  eax,BYTE PTR ds:0x1000f7aa
10008437:	a3 c8 f7 00 10       	mov    ds:0x1000f7c8,eax
1000843c:	5f                   	pop    edi
1000843d:	0f bf 05 a8 f7 00 10 	movsx  eax,WORD PTR ds:0x1000f7a8
10008444:	a3 cc f7 00 10       	mov    ds:0x1000f7cc,eax
10008449:	c7 05 d4 f7 00 10 ac 	mov    DWORD PTR ds:0x1000f7d4,0x1000f7ac
10008450:	f7 00 10 
10008453:	b8 c8 f7 00 10       	mov    eax,0x1000f7c8
10008458:	5e                   	pop    esi
10008459:	c9                   	leave
1000845a:	c3                   	ret
1000845b:	55                   	push   ebp
1000845c:	8b ec                	mov    ebp,esp
1000845e:	51                   	push   ecx
1000845f:	8b 55 0c             	mov    edx,DWORD PTR [ebp+0xc]
10008462:	53                   	push   ebx
10008463:	56                   	push   esi
10008464:	57                   	push   edi
10008465:	66 8b 42 06          	mov    ax,WORD PTR [edx+0x6]
10008469:	bf ff 07 00 00       	mov    edi,0x7ff
1000846e:	8b c8                	mov    ecx,eax
10008470:	25 00 80 00 00       	and    eax,0x8000
10008475:	c1 e9 04             	shr    ecx,0x4
10008478:	23 cf                	and    ecx,edi
1000847a:	89 45 0c             	mov    DWORD PTR [ebp+0xc],eax
1000847d:	8b 42 04             	mov    eax,DWORD PTR [edx+0x4]
10008480:	8b 12                	mov    edx,DWORD PTR [edx]
10008482:	0f b7 d9             	movzx  ebx,cx
10008485:	be 00 00 00 80       	mov    esi,0x80000000
1000848a:	25 ff ff 0f 00       	and    eax,0xfffff
1000848f:	85 db                	test   ebx,ebx
10008491:	89 75 fc             	mov    DWORD PTR [ebp-0x4],esi
10008494:	74 13                	je     0x100084a9
10008496:	3b df                	cmp    ebx,edi
10008498:	74 08                	je     0x100084a2
1000849a:	8d b9 00 3c 00 00    	lea    edi,[ecx+0x3c00]
100084a0:	eb 28                	jmp    0x100084ca
100084a2:	bf ff 7f 00 00       	mov    edi,0x7fff
100084a7:	eb 21                	jmp    0x100084ca
100084a9:	33 db                	xor    ebx,ebx
100084ab:	3b c3                	cmp    eax,ebx
100084ad:	75 12                	jne    0x100084c1
100084af:	3b d3                	cmp    edx,ebx
100084b1:	75 0e                	jne    0x100084c1
100084b3:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100084b6:	89 58 04             	mov    DWORD PTR [eax+0x4],ebx
100084b9:	89 18                	mov    DWORD PTR [eax],ebx
100084bb:	66 89 58 08          	mov    WORD PTR [eax+0x8],bx
100084bf:	eb 4b                	jmp    0x1000850c
100084c1:	8d b9 01 3c 00 00    	lea    edi,[ecx+0x3c01]
100084c7:	89 5d fc             	mov    DWORD PTR [ebp-0x4],ebx
100084ca:	8b ca                	mov    ecx,edx
100084cc:	c1 e9 15             	shr    ecx,0x15
100084cf:	c1 e0 0b             	shl    eax,0xb
100084d2:	0b c8                	or     ecx,eax
100084d4:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100084d7:	0b 4d fc             	or     ecx,DWORD PTR [ebp-0x4]
100084da:	c1 e2 0b             	shl    edx,0xb
100084dd:	89 48 04             	mov    DWORD PTR [eax+0x4],ecx
100084e0:	89 10                	mov    DWORD PTR [eax],edx
100084e2:	85 ce                	test   esi,ecx
100084e4:	75 1d                	jne    0x10008503
100084e6:	8b 10                	mov    edx,DWORD PTR [eax]
100084e8:	03 c9                	add    ecx,ecx
100084ea:	8b da                	mov    ebx,edx
100084ec:	c1 eb 1f             	shr    ebx,0x1f
100084ef:	0b d9                	or     ebx,ecx
100084f1:	8d 0c 12             	lea    ecx,[edx+edx*1]
100084f4:	89 08                	mov    DWORD PTR [eax],ecx
100084f6:	89 58 04             	mov    DWORD PTR [eax+0x4],ebx
100084f9:	81 c7 ff ff 00 00    	add    edi,0xffff
100084ff:	8b cb                	mov    ecx,ebx
10008501:	eb df                	jmp    0x100084e2
10008503:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
10008506:	0b cf                	or     ecx,edi
10008508:	66 89 48 08          	mov    WORD PTR [eax+0x8],cx
1000850c:	5f                   	pop    edi
1000850d:	5e                   	pop    esi
1000850e:	5b                   	pop    ebx
1000850f:	c9                   	leave
10008510:	c3                   	ret
10008511:	cc                   	int3
10008512:	cc                   	int3
10008513:	cc                   	int3
10008514:	cc                   	int3
10008515:	cc                   	int3
10008516:	cc                   	int3
10008517:	cc                   	int3
10008518:	cc                   	int3
10008519:	cc                   	int3
1000851a:	cc                   	int3
1000851b:	cc                   	int3
1000851c:	cc                   	int3
1000851d:	cc                   	int3
1000851e:	cc                   	int3
1000851f:	cc                   	int3
10008520:	8b 54 24 0c          	mov    edx,DWORD PTR [esp+0xc]
10008524:	8b 4c 24 04          	mov    ecx,DWORD PTR [esp+0x4]
10008528:	85 d2                	test   edx,edx
1000852a:	74 47                	je     0x10008573
1000852c:	33 c0                	xor    eax,eax
1000852e:	8a 44 24 08          	mov    al,BYTE PTR [esp+0x8]
10008532:	57                   	push   edi
10008533:	8b f9                	mov    edi,ecx
10008535:	83 fa 04             	cmp    edx,0x4
10008538:	72 2d                	jb     0x10008567
1000853a:	f7 d9                	neg    ecx
1000853c:	83 e1 03             	and    ecx,0x3
1000853f:	74 08                	je     0x10008549
10008541:	2b d1                	sub    edx,ecx
10008543:	88 07                	mov    BYTE PTR [edi],al
10008545:	47                   	inc    edi
10008546:	49                   	dec    ecx
10008547:	75 fa                	jne    0x10008543
10008549:	8b c8                	mov    ecx,eax
1000854b:	c1 e0 08             	shl    eax,0x8
1000854e:	03 c1                	add    eax,ecx
10008550:	8b c8                	mov    ecx,eax
10008552:	c1 e0 10             	shl    eax,0x10
10008555:	03 c1                	add    eax,ecx
10008557:	8b ca                	mov    ecx,edx
10008559:	83 e2 03             	and    edx,0x3
1000855c:	c1 e9 02             	shr    ecx,0x2
1000855f:	74 06                	je     0x10008567
10008561:	f3 ab                	rep stos DWORD PTR es:[edi],eax
10008563:	85 d2                	test   edx,edx
10008565:	74 06                	je     0x1000856d
10008567:	88 07                	mov    BYTE PTR [edi],al
10008569:	47                   	inc    edi
1000856a:	4a                   	dec    edx
1000856b:	75 fa                	jne    0x10008567
1000856d:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
10008571:	5f                   	pop    edi
10008572:	c3                   	ret
10008573:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
10008577:	c3                   	ret
10008578:	cc                   	int3
10008579:	cc                   	int3
1000857a:	cc                   	int3
1000857b:	cc                   	int3
1000857c:	cc                   	int3
1000857d:	cc                   	int3
1000857e:	cc                   	int3
1000857f:	cc                   	int3
10008580:	55                   	push   ebp
10008581:	8b ec                	mov    ebp,esp
10008583:	57                   	push   edi
10008584:	56                   	push   esi
10008585:	8b 75 0c             	mov    esi,DWORD PTR [ebp+0xc]
10008588:	8b 4d 10             	mov    ecx,DWORD PTR [ebp+0x10]
1000858b:	8b 7d 08             	mov    edi,DWORD PTR [ebp+0x8]
1000858e:	8b c1                	mov    eax,ecx
10008590:	8b d1                	mov    edx,ecx
10008592:	03 c6                	add    eax,esi
10008594:	3b fe                	cmp    edi,esi
10008596:	76 08                	jbe    0x100085a0
10008598:	3b f8                	cmp    edi,eax
1000859a:	0f 82 78 01 00 00    	jb     0x10008718
100085a0:	f7 c7 03 00 00 00    	test   edi,0x3
100085a6:	75 14                	jne    0x100085bc
100085a8:	c1 e9 02             	shr    ecx,0x2
100085ab:	83 e2 03             	and    edx,0x3
100085ae:	83 f9 08             	cmp    ecx,0x8
100085b1:	72 29                	jb     0x100085dc
100085b3:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
100085b5:	ff 24 95 c8 86 00 10 	jmp    DWORD PTR [edx*4+0x100086c8]
100085bc:	8b c7                	mov    eax,edi
100085be:	ba 03 00 00 00       	mov    edx,0x3
100085c3:	83 e9 04             	sub    ecx,0x4
100085c6:	72 0c                	jb     0x100085d4
100085c8:	83 e0 03             	and    eax,0x3
100085cb:	03 c8                	add    ecx,eax
100085cd:	ff 24 85 e0 85 00 10 	jmp    DWORD PTR [eax*4+0x100085e0]
100085d4:	ff 24 8d d8 86 00 10 	jmp    DWORD PTR [ecx*4+0x100086d8]
100085db:	90                   	nop
100085dc:	ff 24 8d 5c 86 00 10 	jmp    DWORD PTR [ecx*4+0x1000865c]
100085e3:	90                   	nop
100085e4:	f0 85 00             	lock test DWORD PTR [eax],eax
100085e7:	10 1c 86             	adc    BYTE PTR [esi+eax*4],bl
100085ea:	00 10                	add    BYTE PTR [eax],dl
100085ec:	40                   	inc    eax
100085ed:	86 00                	xchg   BYTE PTR [eax],al
100085ef:	10 23                	adc    BYTE PTR [ebx],ah
100085f1:	d1 8a 06 88 07 8a    	ror    DWORD PTR [edx-0x75f877fa],1
100085f7:	46                   	inc    esi
100085f8:	01 88 47 01 8a 46    	add    DWORD PTR [eax+0x468a0147],ecx
100085fe:	02 c1                	add    al,cl
10008600:	e9 02 88 47 02       	jmp    0x12480e07
10008605:	83 c6 03             	add    esi,0x3
10008608:	83 c7 03             	add    edi,0x3
1000860b:	83 f9 08             	cmp    ecx,0x8
1000860e:	72 cc                	jb     0x100085dc
10008610:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
10008612:	ff 24 95 c8 86 00 10 	jmp    DWORD PTR [edx*4+0x100086c8]
10008619:	8d 49 00             	lea    ecx,[ecx+0x0]
1000861c:	23 d1                	and    edx,ecx
1000861e:	8a 06                	mov    al,BYTE PTR [esi]
10008620:	88 07                	mov    BYTE PTR [edi],al
10008622:	8a 46 01             	mov    al,BYTE PTR [esi+0x1]
10008625:	c1 e9 02             	shr    ecx,0x2
10008628:	88 47 01             	mov    BYTE PTR [edi+0x1],al
1000862b:	83 c6 02             	add    esi,0x2
1000862e:	83 c7 02             	add    edi,0x2
10008631:	83 f9 08             	cmp    ecx,0x8
10008634:	72 a6                	jb     0x100085dc
10008636:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
10008638:	ff 24 95 c8 86 00 10 	jmp    DWORD PTR [edx*4+0x100086c8]
1000863f:	90                   	nop
10008640:	23 d1                	and    edx,ecx
10008642:	8a 06                	mov    al,BYTE PTR [esi]
10008644:	88 07                	mov    BYTE PTR [edi],al
10008646:	46                   	inc    esi
10008647:	c1 e9 02             	shr    ecx,0x2
1000864a:	47                   	inc    edi
1000864b:	83 f9 08             	cmp    ecx,0x8
1000864e:	72 8c                	jb     0x100085dc
10008650:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
10008652:	ff 24 95 c8 86 00 10 	jmp    DWORD PTR [edx*4+0x100086c8]
10008659:	8d 49 00             	lea    ecx,[ecx+0x0]
1000865c:	bf 86 00 10 ac       	mov    edi,0xac100086
10008661:	86 00                	xchg   BYTE PTR [eax],al
10008663:	10 a4 86 00 10 9c 86 	adc    BYTE PTR [esi+eax*4-0x7963f000],ah
1000866a:	00 10                	add    BYTE PTR [eax],dl
1000866c:	94                   	xchg   esp,eax
1000866d:	86 00                	xchg   BYTE PTR [eax],al
1000866f:	10 8c 86 00 10 84 86 	adc    BYTE PTR [esi+eax*4-0x797bf000],cl
10008676:	00 10                	add    BYTE PTR [eax],dl
10008678:	7c 86                	jl     0x10008600
1000867a:	00 10                	add    BYTE PTR [eax],dl
1000867c:	8b 44 8e e4          	mov    eax,DWORD PTR [esi+ecx*4-0x1c]
10008680:	89 44 8f e4          	mov    DWORD PTR [edi+ecx*4-0x1c],eax
10008684:	8b 44 8e e8          	mov    eax,DWORD PTR [esi+ecx*4-0x18]
10008688:	89 44 8f e8          	mov    DWORD PTR [edi+ecx*4-0x18],eax
1000868c:	8b 44 8e ec          	mov    eax,DWORD PTR [esi+ecx*4-0x14]
10008690:	89 44 8f ec          	mov    DWORD PTR [edi+ecx*4-0x14],eax
10008694:	8b 44 8e f0          	mov    eax,DWORD PTR [esi+ecx*4-0x10]
10008698:	89 44 8f f0          	mov    DWORD PTR [edi+ecx*4-0x10],eax
1000869c:	8b 44 8e f4          	mov    eax,DWORD PTR [esi+ecx*4-0xc]
100086a0:	89 44 8f f4          	mov    DWORD PTR [edi+ecx*4-0xc],eax
100086a4:	8b 44 8e f8          	mov    eax,DWORD PTR [esi+ecx*4-0x8]
100086a8:	89 44 8f f8          	mov    DWORD PTR [edi+ecx*4-0x8],eax
100086ac:	8b 44 8e fc          	mov    eax,DWORD PTR [esi+ecx*4-0x4]
100086b0:	89 44 8f fc          	mov    DWORD PTR [edi+ecx*4-0x4],eax
100086b4:	8d 04 8d 00 00 00 00 	lea    eax,[ecx*4+0x0]
100086bb:	03 f0                	add    esi,eax
100086bd:	03 f8                	add    edi,eax
100086bf:	ff 24 95 c8 86 00 10 	jmp    DWORD PTR [edx*4+0x100086c8]
100086c6:	8b ff                	mov    edi,edi
100086c8:	d8 86 00 10 e0 86    	fadd   DWORD PTR [esi-0x791ff000]
100086ce:	00 10                	add    BYTE PTR [eax],dl
100086d0:	ec                   	in     al,dx
100086d1:	86 00                	xchg   BYTE PTR [eax],al
100086d3:	10 00                	adc    BYTE PTR [eax],al
100086d5:	87 00                	xchg   DWORD PTR [eax],eax
100086d7:	10 8b 45 08 5e 5f    	adc    BYTE PTR [ebx+0x5f5e0845],cl
100086dd:	c9                   	leave
100086de:	c3                   	ret
100086df:	90                   	nop
100086e0:	8a 06                	mov    al,BYTE PTR [esi]
100086e2:	88 07                	mov    BYTE PTR [edi],al
100086e4:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100086e7:	5e                   	pop    esi
100086e8:	5f                   	pop    edi
100086e9:	c9                   	leave
100086ea:	c3                   	ret
100086eb:	90                   	nop
100086ec:	8a 06                	mov    al,BYTE PTR [esi]
100086ee:	88 07                	mov    BYTE PTR [edi],al
100086f0:	8a 46 01             	mov    al,BYTE PTR [esi+0x1]
100086f3:	88 47 01             	mov    BYTE PTR [edi+0x1],al
100086f6:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100086f9:	5e                   	pop    esi
100086fa:	5f                   	pop    edi
100086fb:	c9                   	leave
100086fc:	c3                   	ret
100086fd:	8d 49 00             	lea    ecx,[ecx+0x0]
10008700:	8a 06                	mov    al,BYTE PTR [esi]
10008702:	88 07                	mov    BYTE PTR [edi],al
10008704:	8a 46 01             	mov    al,BYTE PTR [esi+0x1]
10008707:	88 47 01             	mov    BYTE PTR [edi+0x1],al
1000870a:	8a 46 02             	mov    al,BYTE PTR [esi+0x2]
1000870d:	88 47 02             	mov    BYTE PTR [edi+0x2],al
10008710:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10008713:	5e                   	pop    esi
10008714:	5f                   	pop    edi
10008715:	c9                   	leave
10008716:	c3                   	ret
10008717:	90                   	nop
10008718:	8d 74 31 fc          	lea    esi,[ecx+esi*1-0x4]
1000871c:	8d 7c 39 fc          	lea    edi,[ecx+edi*1-0x4]
10008720:	f7 c7 03 00 00 00    	test   edi,0x3
10008726:	75 24                	jne    0x1000874c
10008728:	c1 e9 02             	shr    ecx,0x2
1000872b:	83 e2 03             	and    edx,0x3
1000872e:	83 f9 08             	cmp    ecx,0x8
10008731:	72 0d                	jb     0x10008740
10008733:	fd                   	std
10008734:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
10008736:	fc                   	cld
10008737:	ff 24 95 60 88 00 10 	jmp    DWORD PTR [edx*4+0x10008860]
1000873e:	8b ff                	mov    edi,edi
10008740:	f7 d9                	neg    ecx
10008742:	ff 24 8d 10 88 00 10 	jmp    DWORD PTR [ecx*4+0x10008810]
10008749:	8d 49 00             	lea    ecx,[ecx+0x0]
1000874c:	8b c7                	mov    eax,edi
1000874e:	ba 03 00 00 00       	mov    edx,0x3
10008753:	83 f9 04             	cmp    ecx,0x4
10008756:	72 0c                	jb     0x10008764
10008758:	83 e0 03             	and    eax,0x3
1000875b:	2b c8                	sub    ecx,eax
1000875d:	ff 24 85 68 87 00 10 	jmp    DWORD PTR [eax*4+0x10008768]
10008764:	ff 24 8d 60 88 00 10 	jmp    DWORD PTR [ecx*4+0x10008860]
1000876b:	90                   	nop
1000876c:	78 87                	js     0x100086f5
1000876e:	00 10                	add    BYTE PTR [eax],dl
10008770:	98                   	cwde
10008771:	87 00                	xchg   DWORD PTR [eax],eax
10008773:	10 c0                	adc    al,al
10008775:	87 00                	xchg   DWORD PTR [eax],eax
10008777:	10 8a 46 03 23 d1    	adc    BYTE PTR [edx-0x2edcfcba],cl
1000877d:	88 47 03             	mov    BYTE PTR [edi+0x3],al
10008780:	4e                   	dec    esi
10008781:	c1 e9 02             	shr    ecx,0x2
10008784:	4f                   	dec    edi
10008785:	83 f9 08             	cmp    ecx,0x8
10008788:	72 b6                	jb     0x10008740
1000878a:	fd                   	std
1000878b:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000878d:	fc                   	cld
1000878e:	ff 24 95 60 88 00 10 	jmp    DWORD PTR [edx*4+0x10008860]
10008795:	8d 49 00             	lea    ecx,[ecx+0x0]
10008798:	8a 46 03             	mov    al,BYTE PTR [esi+0x3]
1000879b:	23 d1                	and    edx,ecx
1000879d:	88 47 03             	mov    BYTE PTR [edi+0x3],al
100087a0:	8a 46 02             	mov    al,BYTE PTR [esi+0x2]
100087a3:	c1 e9 02             	shr    ecx,0x2
100087a6:	88 47 02             	mov    BYTE PTR [edi+0x2],al
100087a9:	83 ee 02             	sub    esi,0x2
100087ac:	83 ef 02             	sub    edi,0x2
100087af:	83 f9 08             	cmp    ecx,0x8
100087b2:	72 8c                	jb     0x10008740
100087b4:	fd                   	std
100087b5:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
100087b7:	fc                   	cld
100087b8:	ff 24 95 60 88 00 10 	jmp    DWORD PTR [edx*4+0x10008860]
100087bf:	90                   	nop
100087c0:	8a 46 03             	mov    al,BYTE PTR [esi+0x3]
100087c3:	23 d1                	and    edx,ecx
100087c5:	88 47 03             	mov    BYTE PTR [edi+0x3],al
100087c8:	8a 46 02             	mov    al,BYTE PTR [esi+0x2]
100087cb:	88 47 02             	mov    BYTE PTR [edi+0x2],al
100087ce:	8a 46 01             	mov    al,BYTE PTR [esi+0x1]
100087d1:	c1 e9 02             	shr    ecx,0x2
100087d4:	88 47 01             	mov    BYTE PTR [edi+0x1],al
100087d7:	83 ee 03             	sub    esi,0x3
100087da:	83 ef 03             	sub    edi,0x3
100087dd:	83 f9 08             	cmp    ecx,0x8
100087e0:	0f 82 5a ff ff ff    	jb     0x10008740
100087e6:	fd                   	std
100087e7:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
100087e9:	fc                   	cld
100087ea:	ff 24 95 60 88 00 10 	jmp    DWORD PTR [edx*4+0x10008860]
100087f1:	8d 49 00             	lea    ecx,[ecx+0x0]
100087f4:	14 88                	adc    al,0x88
100087f6:	00 10                	add    BYTE PTR [eax],dl
100087f8:	1c 88                	sbb    al,0x88
100087fa:	00 10                	add    BYTE PTR [eax],dl
100087fc:	24 88                	and    al,0x88
100087fe:	00 10                	add    BYTE PTR [eax],dl
10008800:	2c 88                	sub    al,0x88
10008802:	00 10                	add    BYTE PTR [eax],dl
10008804:	34 88                	xor    al,0x88
10008806:	00 10                	add    BYTE PTR [eax],dl
10008808:	3c 88                	cmp    al,0x88
1000880a:	00 10                	add    BYTE PTR [eax],dl
1000880c:	44                   	inc    esp
1000880d:	88 00                	mov    BYTE PTR [eax],al
1000880f:	10 57 88             	adc    BYTE PTR [edi-0x78],dl
10008812:	00 10                	add    BYTE PTR [eax],dl
10008814:	8b 44 8e 1c          	mov    eax,DWORD PTR [esi+ecx*4+0x1c]
10008818:	89 44 8f 1c          	mov    DWORD PTR [edi+ecx*4+0x1c],eax
1000881c:	8b 44 8e 18          	mov    eax,DWORD PTR [esi+ecx*4+0x18]
10008820:	89 44 8f 18          	mov    DWORD PTR [edi+ecx*4+0x18],eax
10008824:	8b 44 8e 14          	mov    eax,DWORD PTR [esi+ecx*4+0x14]
10008828:	89 44 8f 14          	mov    DWORD PTR [edi+ecx*4+0x14],eax
1000882c:	8b 44 8e 10          	mov    eax,DWORD PTR [esi+ecx*4+0x10]
10008830:	89 44 8f 10          	mov    DWORD PTR [edi+ecx*4+0x10],eax
10008834:	8b 44 8e 0c          	mov    eax,DWORD PTR [esi+ecx*4+0xc]
10008838:	89 44 8f 0c          	mov    DWORD PTR [edi+ecx*4+0xc],eax
1000883c:	8b 44 8e 08          	mov    eax,DWORD PTR [esi+ecx*4+0x8]
10008840:	89 44 8f 08          	mov    DWORD PTR [edi+ecx*4+0x8],eax
10008844:	8b 44 8e 04          	mov    eax,DWORD PTR [esi+ecx*4+0x4]
10008848:	89 44 8f 04          	mov    DWORD PTR [edi+ecx*4+0x4],eax
1000884c:	8d 04 8d 00 00 00 00 	lea    eax,[ecx*4+0x0]
10008853:	03 f0                	add    esi,eax
10008855:	03 f8                	add    edi,eax
10008857:	ff 24 95 60 88 00 10 	jmp    DWORD PTR [edx*4+0x10008860]
1000885e:	8b ff                	mov    edi,edi
10008860:	70 88                	jo     0x100087ea
10008862:	00 10                	add    BYTE PTR [eax],dl
10008864:	78 88                	js     0x100087ee
10008866:	00 10                	add    BYTE PTR [eax],dl
10008868:	88 88 00 10 9c 88    	mov    BYTE PTR [eax-0x7763f000],cl
1000886e:	00 10                	add    BYTE PTR [eax],dl
10008870:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10008873:	5e                   	pop    esi
10008874:	5f                   	pop    edi
10008875:	c9                   	leave
10008876:	c3                   	ret
10008877:	90                   	nop
10008878:	8a 46 03             	mov    al,BYTE PTR [esi+0x3]
1000887b:	88 47 03             	mov    BYTE PTR [edi+0x3],al
1000887e:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10008881:	5e                   	pop    esi
10008882:	5f                   	pop    edi
10008883:	c9                   	leave
10008884:	c3                   	ret
10008885:	8d 49 00             	lea    ecx,[ecx+0x0]
10008888:	8a 46 03             	mov    al,BYTE PTR [esi+0x3]
1000888b:	88 47 03             	mov    BYTE PTR [edi+0x3],al
1000888e:	8a 46 02             	mov    al,BYTE PTR [esi+0x2]
10008891:	88 47 02             	mov    BYTE PTR [edi+0x2],al
10008894:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10008897:	5e                   	pop    esi
10008898:	5f                   	pop    edi
10008899:	c9                   	leave
1000889a:	c3                   	ret
1000889b:	90                   	nop
1000889c:	8a 46 03             	mov    al,BYTE PTR [esi+0x3]
1000889f:	88 47 03             	mov    BYTE PTR [edi+0x3],al
100088a2:	8a 46 02             	mov    al,BYTE PTR [esi+0x2]
100088a5:	88 47 02             	mov    BYTE PTR [edi+0x2],al
100088a8:	8a 46 01             	mov    al,BYTE PTR [esi+0x1]
100088ab:	88 47 01             	mov    BYTE PTR [edi+0x1],al
100088ae:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
100088b1:	5e                   	pop    esi
100088b2:	5f                   	pop    edi
100088b3:	c9                   	leave
100088b4:	c3                   	ret
100088b5:	cc                   	int3
100088b6:	cc                   	int3
100088b7:	cc                   	int3
100088b8:	cc                   	int3
100088b9:	cc                   	int3
100088ba:	cc                   	int3
100088bb:	cc                   	int3
100088bc:	cc                   	int3
100088bd:	cc                   	int3
100088be:	cc                   	int3
100088bf:	cc                   	int3
100088c0:	8b 4c 24 04          	mov    ecx,DWORD PTR [esp+0x4]
100088c4:	f7 c1 03 00 00 00    	test   ecx,0x3
100088ca:	74 14                	je     0x100088e0
100088cc:	8a 01                	mov    al,BYTE PTR [ecx]
100088ce:	41                   	inc    ecx
100088cf:	84 c0                	test   al,al
100088d1:	74 40                	je     0x10008913
100088d3:	f7 c1 03 00 00 00    	test   ecx,0x3
100088d9:	75 f1                	jne    0x100088cc
100088db:	05 00 00 00 00       	add    eax,0x0
100088e0:	8b 01                	mov    eax,DWORD PTR [ecx]
100088e2:	ba ff fe fe 7e       	mov    edx,0x7efefeff
100088e7:	03 d0                	add    edx,eax
100088e9:	83 f0 ff             	xor    eax,0xffffffff
100088ec:	33 c2                	xor    eax,edx
100088ee:	83 c1 04             	add    ecx,0x4
100088f1:	a9 00 01 01 81       	test   eax,0x81010100
100088f6:	74 e8                	je     0x100088e0
100088f8:	8b 41 fc             	mov    eax,DWORD PTR [ecx-0x4]
100088fb:	84 c0                	test   al,al
100088fd:	74 32                	je     0x10008931
100088ff:	84 e4                	test   ah,ah
10008901:	74 24                	je     0x10008927
10008903:	a9 00 00 ff 00       	test   eax,0xff0000
10008908:	74 13                	je     0x1000891d
1000890a:	a9 00 00 00 ff       	test   eax,0xff000000
1000890f:	74 02                	je     0x10008913
10008911:	eb cd                	jmp    0x100088e0
10008913:	8d 41 ff             	lea    eax,[ecx-0x1]
10008916:	8b 4c 24 04          	mov    ecx,DWORD PTR [esp+0x4]
1000891a:	2b c1                	sub    eax,ecx
1000891c:	c3                   	ret
1000891d:	8d 41 fe             	lea    eax,[ecx-0x2]
10008920:	8b 4c 24 04          	mov    ecx,DWORD PTR [esp+0x4]
10008924:	2b c1                	sub    eax,ecx
10008926:	c3                   	ret
10008927:	8d 41 fd             	lea    eax,[ecx-0x3]
1000892a:	8b 4c 24 04          	mov    ecx,DWORD PTR [esp+0x4]
1000892e:	2b c1                	sub    eax,ecx
10008930:	c3                   	ret
10008931:	8d 41 fc             	lea    eax,[ecx-0x4]
10008934:	8b 4c 24 04          	mov    ecx,DWORD PTR [esp+0x4]
10008938:	2b c1                	sub    eax,ecx
1000893a:	c3                   	ret
1000893b:	6a 02                	push   0x2
1000893d:	e8 01 d0 ff ff       	call   0x10005943
10008942:	59                   	pop    ecx
10008943:	c3                   	ret
10008944:	a1 70 ed 00 10       	mov    eax,ds:0x1000ed70
10008949:	c3                   	ret
1000894a:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
1000894e:	3d f8 03 00 00       	cmp    eax,0x3f8
10008953:	76 03                	jbe    0x10008958
10008955:	33 c0                	xor    eax,eax
10008957:	c3                   	ret
10008958:	6a 01                	push   0x1
1000895a:	a3 70 ed 00 10       	mov    ds:0x1000ed70,eax
1000895f:	58                   	pop    eax
10008960:	c3                   	ret
10008961:	68 40 01 00 00       	push   0x140
10008966:	6a 00                	push   0x0
10008968:	ff 35 a4 0b 01 10    	push   DWORD PTR ds:0x10010ba4
1000896e:	ff 15 38 d0 00 10    	call   DWORD PTR ds:0x1000d038
10008974:	85 c0                	test   eax,eax
10008976:	a3 98 0a 01 10       	mov    ds:0x10010a98,eax
1000897b:	75 01                	jne    0x1000897e
1000897d:	c3                   	ret
1000897e:	83 25 90 0a 01 10 00 	and    DWORD PTR ds:0x10010a90,0x0
10008985:	83 25 94 0a 01 10 00 	and    DWORD PTR ds:0x10010a94,0x0
1000898c:	6a 01                	push   0x1
1000898e:	a3 8c 0a 01 10       	mov    ds:0x10010a8c,eax
10008993:	c7 05 84 0a 01 10 10 	mov    DWORD PTR ds:0x10010a84,0x10
1000899a:	00 00 00 
1000899d:	58                   	pop    eax
1000899e:	c3                   	ret
1000899f:	a1 94 0a 01 10       	mov    eax,ds:0x10010a94
100089a4:	8d 0c 80             	lea    ecx,[eax+eax*4]
100089a7:	a1 98 0a 01 10       	mov    eax,ds:0x10010a98
100089ac:	8d 0c 88             	lea    ecx,[eax+ecx*4]
100089af:	3b c1                	cmp    eax,ecx
100089b1:	73 14                	jae    0x100089c7
100089b3:	8b 54 24 04          	mov    edx,DWORD PTR [esp+0x4]
100089b7:	2b 50 0c             	sub    edx,DWORD PTR [eax+0xc]
100089ba:	81 fa 00 00 10 00    	cmp    edx,0x100000
100089c0:	72 07                	jb     0x100089c9
100089c2:	83 c0 14             	add    eax,0x14
100089c5:	eb e8                	jmp    0x100089af
100089c7:	33 c0                	xor    eax,eax
100089c9:	c3                   	ret
100089ca:	55                   	push   ebp
100089cb:	8b ec                	mov    ebp,esp
100089cd:	83 ec 14             	sub    esp,0x14
100089d0:	8b 55 0c             	mov    edx,DWORD PTR [ebp+0xc]
100089d3:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
100089d6:	53                   	push   ebx
100089d7:	56                   	push   esi
100089d8:	8b 41 10             	mov    eax,DWORD PTR [ecx+0x10]
100089db:	8b f2                	mov    esi,edx
100089dd:	2b 71 0c             	sub    esi,DWORD PTR [ecx+0xc]
100089e0:	8b 5a fc             	mov    ebx,DWORD PTR [edx-0x4]
100089e3:	83 c2 fc             	add    edx,0xfffffffc
100089e6:	57                   	push   edi
100089e7:	c1 ee 0f             	shr    esi,0xf
100089ea:	8b ce                	mov    ecx,esi
100089ec:	8b 7a fc             	mov    edi,DWORD PTR [edx-0x4]
100089ef:	69 c9 04 02 00 00    	imul   ecx,ecx,0x204
100089f5:	4b                   	dec    ebx
100089f6:	89 7d fc             	mov    DWORD PTR [ebp-0x4],edi
100089f9:	8d 8c 01 44 01 00 00 	lea    ecx,[ecx+eax*1+0x144]
10008a00:	89 5d f4             	mov    DWORD PTR [ebp-0xc],ebx
10008a03:	89 4d f0             	mov    DWORD PTR [ebp-0x10],ecx
10008a06:	8b 0c 13             	mov    ecx,DWORD PTR [ebx+edx*1]
10008a09:	f6 c1 01             	test   cl,0x1
10008a0c:	89 4d f8             	mov    DWORD PTR [ebp-0x8],ecx
10008a0f:	75 7f                	jne    0x10008a90
10008a11:	c1 f9 04             	sar    ecx,0x4
10008a14:	6a 3f                	push   0x3f
10008a16:	49                   	dec    ecx
10008a17:	5f                   	pop    edi
10008a18:	89 4d 0c             	mov    DWORD PTR [ebp+0xc],ecx
10008a1b:	3b cf                	cmp    ecx,edi
10008a1d:	76 03                	jbe    0x10008a22
10008a1f:	89 7d 0c             	mov    DWORD PTR [ebp+0xc],edi
10008a22:	8b 4c 13 04          	mov    ecx,DWORD PTR [ebx+edx*1+0x4]
10008a26:	3b 4c 13 08          	cmp    ecx,DWORD PTR [ebx+edx*1+0x8]
10008a2a:	75 48                	jne    0x10008a74
10008a2c:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
10008a2f:	83 f9 20             	cmp    ecx,0x20
10008a32:	73 1c                	jae    0x10008a50
10008a34:	bf 00 00 00 80       	mov    edi,0x80000000
10008a39:	d3 ef                	shr    edi,cl
10008a3b:	8d 4c 01 04          	lea    ecx,[ecx+eax*1+0x4]
10008a3f:	f7 d7                	not    edi
10008a41:	21 7c b0 44          	and    DWORD PTR [eax+esi*4+0x44],edi
10008a45:	fe 09                	dec    BYTE PTR [ecx]
10008a47:	75 2b                	jne    0x10008a74
10008a49:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
10008a4c:	21 39                	and    DWORD PTR [ecx],edi
10008a4e:	eb 24                	jmp    0x10008a74
10008a50:	83 c1 e0             	add    ecx,0xffffffe0
10008a53:	bf 00 00 00 80       	mov    edi,0x80000000
10008a58:	d3 ef                	shr    edi,cl
10008a5a:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
10008a5d:	8d 4c 01 04          	lea    ecx,[ecx+eax*1+0x4]
10008a61:	f7 d7                	not    edi
10008a63:	21 bc b0 c4 00 00 00 	and    DWORD PTR [eax+esi*4+0xc4],edi
10008a6a:	fe 09                	dec    BYTE PTR [ecx]
10008a6c:	75 06                	jne    0x10008a74
10008a6e:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
10008a71:	21 79 04             	and    DWORD PTR [ecx+0x4],edi
10008a74:	8b 4c 13 08          	mov    ecx,DWORD PTR [ebx+edx*1+0x8]
10008a78:	8b 7c 13 04          	mov    edi,DWORD PTR [ebx+edx*1+0x4]
10008a7c:	89 79 04             	mov    DWORD PTR [ecx+0x4],edi
10008a7f:	8b 4c 13 04          	mov    ecx,DWORD PTR [ebx+edx*1+0x4]
10008a83:	8b 7c 13 08          	mov    edi,DWORD PTR [ebx+edx*1+0x8]
10008a87:	03 5d f8             	add    ebx,DWORD PTR [ebp-0x8]
10008a8a:	89 79 08             	mov    DWORD PTR [ecx+0x8],edi
10008a8d:	89 5d f4             	mov    DWORD PTR [ebp-0xc],ebx
10008a90:	8b fb                	mov    edi,ebx
10008a92:	c1 ff 04             	sar    edi,0x4
10008a95:	4f                   	dec    edi
10008a96:	83 ff 3f             	cmp    edi,0x3f
10008a99:	76 03                	jbe    0x10008a9e
10008a9b:	6a 3f                	push   0x3f
10008a9d:	5f                   	pop    edi
10008a9e:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10008aa1:	83 e1 01             	and    ecx,0x1
10008aa4:	89 4d ec             	mov    DWORD PTR [ebp-0x14],ecx
10008aa7:	0f 85 a0 00 00 00    	jne    0x10008b4d
10008aad:	2b 55 fc             	sub    edx,DWORD PTR [ebp-0x4]
10008ab0:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10008ab3:	c1 f9 04             	sar    ecx,0x4
10008ab6:	6a 3f                	push   0x3f
10008ab8:	89 55 f8             	mov    DWORD PTR [ebp-0x8],edx
10008abb:	49                   	dec    ecx
10008abc:	5a                   	pop    edx
10008abd:	3b ca                	cmp    ecx,edx
10008abf:	89 4d 0c             	mov    DWORD PTR [ebp+0xc],ecx
10008ac2:	76 05                	jbe    0x10008ac9
10008ac4:	89 55 0c             	mov    DWORD PTR [ebp+0xc],edx
10008ac7:	8b ca                	mov    ecx,edx
10008ac9:	03 5d fc             	add    ebx,DWORD PTR [ebp-0x4]
10008acc:	8b fb                	mov    edi,ebx
10008ace:	89 5d f4             	mov    DWORD PTR [ebp-0xc],ebx
10008ad1:	c1 ff 04             	sar    edi,0x4
10008ad4:	4f                   	dec    edi
10008ad5:	3b fa                	cmp    edi,edx
10008ad7:	76 02                	jbe    0x10008adb
10008ad9:	8b fa                	mov    edi,edx
10008adb:	3b cf                	cmp    ecx,edi
10008add:	74 6b                	je     0x10008b4a
10008adf:	8b 4d f8             	mov    ecx,DWORD PTR [ebp-0x8]
10008ae2:	8b 51 04             	mov    edx,DWORD PTR [ecx+0x4]
10008ae5:	3b 51 08             	cmp    edx,DWORD PTR [ecx+0x8]
10008ae8:	75 48                	jne    0x10008b32
10008aea:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
10008aed:	83 f9 20             	cmp    ecx,0x20
10008af0:	73 1c                	jae    0x10008b0e
10008af2:	ba 00 00 00 80       	mov    edx,0x80000000
10008af7:	d3 ea                	shr    edx,cl
10008af9:	8d 4c 01 04          	lea    ecx,[ecx+eax*1+0x4]
10008afd:	f7 d2                	not    edx
10008aff:	21 54 b0 44          	and    DWORD PTR [eax+esi*4+0x44],edx
10008b03:	fe 09                	dec    BYTE PTR [ecx]
10008b05:	75 2b                	jne    0x10008b32
10008b07:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
10008b0a:	21 11                	and    DWORD PTR [ecx],edx
10008b0c:	eb 24                	jmp    0x10008b32
10008b0e:	83 c1 e0             	add    ecx,0xffffffe0
10008b11:	ba 00 00 00 80       	mov    edx,0x80000000
10008b16:	d3 ea                	shr    edx,cl
10008b18:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
10008b1b:	8d 4c 01 04          	lea    ecx,[ecx+eax*1+0x4]
10008b1f:	f7 d2                	not    edx
10008b21:	21 94 b0 c4 00 00 00 	and    DWORD PTR [eax+esi*4+0xc4],edx
10008b28:	fe 09                	dec    BYTE PTR [ecx]
10008b2a:	75 06                	jne    0x10008b32
10008b2c:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
10008b2f:	21 51 04             	and    DWORD PTR [ecx+0x4],edx
10008b32:	8b 4d f8             	mov    ecx,DWORD PTR [ebp-0x8]
10008b35:	8b 51 08             	mov    edx,DWORD PTR [ecx+0x8]
10008b38:	8b 49 04             	mov    ecx,DWORD PTR [ecx+0x4]
10008b3b:	89 4a 04             	mov    DWORD PTR [edx+0x4],ecx
10008b3e:	8b 4d f8             	mov    ecx,DWORD PTR [ebp-0x8]
10008b41:	8b 51 04             	mov    edx,DWORD PTR [ecx+0x4]
10008b44:	8b 49 08             	mov    ecx,DWORD PTR [ecx+0x8]
10008b47:	89 4a 08             	mov    DWORD PTR [edx+0x8],ecx
10008b4a:	8b 55 f8             	mov    edx,DWORD PTR [ebp-0x8]
10008b4d:	83 7d ec 00          	cmp    DWORD PTR [ebp-0x14],0x0
10008b51:	75 09                	jne    0x10008b5c
10008b53:	39 7d 0c             	cmp    DWORD PTR [ebp+0xc],edi
10008b56:	0f 84 89 00 00 00    	je     0x10008be5
10008b5c:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
10008b5f:	8d 0c f9             	lea    ecx,[ecx+edi*8]
10008b62:	8b 49 04             	mov    ecx,DWORD PTR [ecx+0x4]
10008b65:	89 4a 04             	mov    DWORD PTR [edx+0x4],ecx
10008b68:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
10008b6b:	8d 0c f9             	lea    ecx,[ecx+edi*8]
10008b6e:	89 4a 08             	mov    DWORD PTR [edx+0x8],ecx
10008b71:	89 51 04             	mov    DWORD PTR [ecx+0x4],edx
10008b74:	8b 4a 04             	mov    ecx,DWORD PTR [edx+0x4]
10008b77:	89 51 08             	mov    DWORD PTR [ecx+0x8],edx
10008b7a:	8b 4a 04             	mov    ecx,DWORD PTR [edx+0x4]
10008b7d:	3b 4a 08             	cmp    ecx,DWORD PTR [edx+0x8]
10008b80:	75 63                	jne    0x10008be5
10008b82:	8a 4c 07 04          	mov    cl,BYTE PTR [edi+eax*1+0x4]
10008b86:	83 ff 20             	cmp    edi,0x20
10008b89:	88 4d 0f             	mov    BYTE PTR [ebp+0xf],cl
10008b8c:	fe c1                	inc    cl
10008b8e:	88 4c 07 04          	mov    BYTE PTR [edi+eax*1+0x4],cl
10008b92:	73 25                	jae    0x10008bb9
10008b94:	80 7d 0f 00          	cmp    BYTE PTR [ebp+0xf],0x0
10008b98:	75 0e                	jne    0x10008ba8
10008b9a:	bb 00 00 00 80       	mov    ebx,0x80000000
10008b9f:	8b cf                	mov    ecx,edi
10008ba1:	d3 eb                	shr    ebx,cl
10008ba3:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
10008ba6:	09 19                	or     DWORD PTR [ecx],ebx
10008ba8:	bb 00 00 00 80       	mov    ebx,0x80000000
10008bad:	8b cf                	mov    ecx,edi
10008baf:	d3 eb                	shr    ebx,cl
10008bb1:	8d 44 b0 44          	lea    eax,[eax+esi*4+0x44]
10008bb5:	09 18                	or     DWORD PTR [eax],ebx
10008bb7:	eb 29                	jmp    0x10008be2
10008bb9:	80 7d 0f 00          	cmp    BYTE PTR [ebp+0xf],0x0
10008bbd:	75 10                	jne    0x10008bcf
10008bbf:	8d 4f e0             	lea    ecx,[edi-0x20]
10008bc2:	bb 00 00 00 80       	mov    ebx,0x80000000
10008bc7:	d3 eb                	shr    ebx,cl
10008bc9:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
10008bcc:	09 59 04             	or     DWORD PTR [ecx+0x4],ebx
10008bcf:	8d 4f e0             	lea    ecx,[edi-0x20]
10008bd2:	bf 00 00 00 80       	mov    edi,0x80000000
10008bd7:	d3 ef                	shr    edi,cl
10008bd9:	8d 84 b0 c4 00 00 00 	lea    eax,[eax+esi*4+0xc4]
10008be0:	09 38                	or     DWORD PTR [eax],edi
10008be2:	8b 5d f4             	mov    ebx,DWORD PTR [ebp-0xc]
10008be5:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
10008be8:	89 1a                	mov    DWORD PTR [edx],ebx
10008bea:	89 5c 13 fc          	mov    DWORD PTR [ebx+edx*1-0x4],ebx
10008bee:	ff 08                	dec    DWORD PTR [eax]
10008bf0:	0f 85 fa 00 00 00    	jne    0x10008cf0
10008bf6:	a1 90 0a 01 10       	mov    eax,ds:0x10010a90
10008bfb:	85 c0                	test   eax,eax
10008bfd:	0f 84 df 00 00 00    	je     0x10008ce2
10008c03:	8b 0d 88 0a 01 10    	mov    ecx,DWORD PTR ds:0x10010a88
10008c09:	8b 3d 50 d0 00 10    	mov    edi,DWORD PTR ds:0x1000d050
10008c0f:	c1 e1 0f             	shl    ecx,0xf
10008c12:	03 48 0c             	add    ecx,DWORD PTR [eax+0xc]
10008c15:	bb 00 80 00 00       	mov    ebx,0x8000
10008c1a:	68 00 40 00 00       	push   0x4000
10008c1f:	53                   	push   ebx
10008c20:	51                   	push   ecx
10008c21:	ff d7                	call   edi
10008c23:	8b 0d 88 0a 01 10    	mov    ecx,DWORD PTR ds:0x10010a88
10008c29:	a1 90 0a 01 10       	mov    eax,ds:0x10010a90
10008c2e:	ba 00 00 00 80       	mov    edx,0x80000000
10008c33:	d3 ea                	shr    edx,cl
10008c35:	09 50 08             	or     DWORD PTR [eax+0x8],edx
10008c38:	a1 90 0a 01 10       	mov    eax,ds:0x10010a90
10008c3d:	8b 0d 88 0a 01 10    	mov    ecx,DWORD PTR ds:0x10010a88
10008c43:	8b 40 10             	mov    eax,DWORD PTR [eax+0x10]
10008c46:	83 a4 88 c4 00 00 00 	and    DWORD PTR [eax+ecx*4+0xc4],0x0
10008c4d:	00 
10008c4e:	a1 90 0a 01 10       	mov    eax,ds:0x10010a90
10008c53:	8b 40 10             	mov    eax,DWORD PTR [eax+0x10]
10008c56:	fe 48 43             	dec    BYTE PTR [eax+0x43]
10008c59:	a1 90 0a 01 10       	mov    eax,ds:0x10010a90
10008c5e:	8b 48 10             	mov    ecx,DWORD PTR [eax+0x10]
10008c61:	80 79 43 00          	cmp    BYTE PTR [ecx+0x43],0x0
10008c65:	75 09                	jne    0x10008c70
10008c67:	83 60 04 fe          	and    DWORD PTR [eax+0x4],0xfffffffe
10008c6b:	a1 90 0a 01 10       	mov    eax,ds:0x10010a90
10008c70:	83 78 08 ff          	cmp    DWORD PTR [eax+0x8],0xffffffff
10008c74:	75 6c                	jne    0x10008ce2
10008c76:	53                   	push   ebx
10008c77:	6a 00                	push   0x0
10008c79:	ff 70 0c             	push   DWORD PTR [eax+0xc]
10008c7c:	ff d7                	call   edi
10008c7e:	a1 90 0a 01 10       	mov    eax,ds:0x10010a90
10008c83:	ff 70 10             	push   DWORD PTR [eax+0x10]
10008c86:	6a 00                	push   0x0
10008c88:	ff 35 a4 0b 01 10    	push   DWORD PTR ds:0x10010ba4
10008c8e:	ff 15 34 d0 00 10    	call   DWORD PTR ds:0x1000d034
10008c94:	a1 94 0a 01 10       	mov    eax,ds:0x10010a94
10008c99:	8b 15 98 0a 01 10    	mov    edx,DWORD PTR ds:0x10010a98
10008c9f:	8d 04 80             	lea    eax,[eax+eax*4]
10008ca2:	c1 e0 02             	shl    eax,0x2
10008ca5:	8b c8                	mov    ecx,eax
10008ca7:	a1 90 0a 01 10       	mov    eax,ds:0x10010a90
10008cac:	2b c8                	sub    ecx,eax
10008cae:	8d 4c 11 ec          	lea    ecx,[ecx+edx*1-0x14]
10008cb2:	51                   	push   ecx
10008cb3:	8d 48 14             	lea    ecx,[eax+0x14]
10008cb6:	51                   	push   ecx
10008cb7:	50                   	push   eax
10008cb8:	e8 c3 f8 ff ff       	call   0x10008580
10008cbd:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10008cc0:	83 c4 0c             	add    esp,0xc
10008cc3:	ff 0d 94 0a 01 10    	dec    DWORD PTR ds:0x10010a94
10008cc9:	3b 05 90 0a 01 10    	cmp    eax,DWORD PTR ds:0x10010a90
10008ccf:	76 03                	jbe    0x10008cd4
10008cd1:	83 e8 14             	sub    eax,0x14
10008cd4:	8b 0d 98 0a 01 10    	mov    ecx,DWORD PTR ds:0x10010a98
10008cda:	89 0d 8c 0a 01 10    	mov    DWORD PTR ds:0x10010a8c,ecx
10008ce0:	eb 03                	jmp    0x10008ce5
10008ce2:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10008ce5:	a3 90 0a 01 10       	mov    ds:0x10010a90,eax
10008cea:	89 35 88 0a 01 10    	mov    DWORD PTR ds:0x10010a88,esi
10008cf0:	5f                   	pop    edi
10008cf1:	5e                   	pop    esi
10008cf2:	5b                   	pop    ebx
10008cf3:	c9                   	leave
10008cf4:	c3                   	ret
10008cf5:	55                   	push   ebp
10008cf6:	8b ec                	mov    ebp,esp
10008cf8:	83 ec 14             	sub    esp,0x14
10008cfb:	a1 94 0a 01 10       	mov    eax,ds:0x10010a94
10008d00:	8b 15 98 0a 01 10    	mov    edx,DWORD PTR ds:0x10010a98
10008d06:	53                   	push   ebx
10008d07:	56                   	push   esi
10008d08:	8d 04 80             	lea    eax,[eax+eax*4]
10008d0b:	57                   	push   edi
10008d0c:	8d 3c 82             	lea    edi,[edx+eax*4]
10008d0f:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10008d12:	89 7d fc             	mov    DWORD PTR [ebp-0x4],edi
10008d15:	8d 48 17             	lea    ecx,[eax+0x17]
10008d18:	83 e1 f0             	and    ecx,0xfffffff0
10008d1b:	89 4d f0             	mov    DWORD PTR [ebp-0x10],ecx
10008d1e:	c1 f9 04             	sar    ecx,0x4
10008d21:	49                   	dec    ecx
10008d22:	83 f9 20             	cmp    ecx,0x20
10008d25:	7d 0e                	jge    0x10008d35
10008d27:	83 ce ff             	or     esi,0xffffffff
10008d2a:	d3 ee                	shr    esi,cl
10008d2c:	83 4d f8 ff          	or     DWORD PTR [ebp-0x8],0xffffffff
10008d30:	89 75 f4             	mov    DWORD PTR [ebp-0xc],esi
10008d33:	eb 10                	jmp    0x10008d45
10008d35:	83 c1 e0             	add    ecx,0xffffffe0
10008d38:	83 c8 ff             	or     eax,0xffffffff
10008d3b:	33 f6                	xor    esi,esi
10008d3d:	d3 e8                	shr    eax,cl
10008d3f:	89 75 f4             	mov    DWORD PTR [ebp-0xc],esi
10008d42:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
10008d45:	a1 8c 0a 01 10       	mov    eax,ds:0x10010a8c
10008d4a:	8b d8                	mov    ebx,eax
10008d4c:	3b df                	cmp    ebx,edi
10008d4e:	89 5d 08             	mov    DWORD PTR [ebp+0x8],ebx
10008d51:	73 19                	jae    0x10008d6c
10008d53:	8b 4b 04             	mov    ecx,DWORD PTR [ebx+0x4]
10008d56:	8b 3b                	mov    edi,DWORD PTR [ebx]
10008d58:	23 4d f8             	and    ecx,DWORD PTR [ebp-0x8]
10008d5b:	23 fe                	and    edi,esi
10008d5d:	0b cf                	or     ecx,edi
10008d5f:	75 0b                	jne    0x10008d6c
10008d61:	83 c3 14             	add    ebx,0x14
10008d64:	3b 5d fc             	cmp    ebx,DWORD PTR [ebp-0x4]
10008d67:	89 5d 08             	mov    DWORD PTR [ebp+0x8],ebx
10008d6a:	72 e7                	jb     0x10008d53
10008d6c:	3b 5d fc             	cmp    ebx,DWORD PTR [ebp-0x4]
10008d6f:	75 79                	jne    0x10008dea
10008d71:	8b da                	mov    ebx,edx
10008d73:	3b d8                	cmp    ebx,eax
10008d75:	89 5d 08             	mov    DWORD PTR [ebp+0x8],ebx
10008d78:	73 15                	jae    0x10008d8f
10008d7a:	8b 4b 04             	mov    ecx,DWORD PTR [ebx+0x4]
10008d7d:	8b 3b                	mov    edi,DWORD PTR [ebx]
10008d7f:	23 4d f8             	and    ecx,DWORD PTR [ebp-0x8]
10008d82:	23 fe                	and    edi,esi
10008d84:	0b cf                	or     ecx,edi
10008d86:	75 05                	jne    0x10008d8d
10008d88:	83 c3 14             	add    ebx,0x14
10008d8b:	eb e6                	jmp    0x10008d73
10008d8d:	3b d8                	cmp    ebx,eax
10008d8f:	75 59                	jne    0x10008dea
10008d91:	3b 5d fc             	cmp    ebx,DWORD PTR [ebp-0x4]
10008d94:	73 11                	jae    0x10008da7
10008d96:	83 7b 08 00          	cmp    DWORD PTR [ebx+0x8],0x0
10008d9a:	75 08                	jne    0x10008da4
10008d9c:	83 c3 14             	add    ebx,0x14
10008d9f:	89 5d 08             	mov    DWORD PTR [ebp+0x8],ebx
10008da2:	eb ed                	jmp    0x10008d91
10008da4:	3b 5d fc             	cmp    ebx,DWORD PTR [ebp-0x4]
10008da7:	75 26                	jne    0x10008dcf
10008da9:	8b da                	mov    ebx,edx
10008dab:	3b d8                	cmp    ebx,eax
10008dad:	89 5d 08             	mov    DWORD PTR [ebp+0x8],ebx
10008db0:	73 0d                	jae    0x10008dbf
10008db2:	83 7b 08 00          	cmp    DWORD PTR [ebx+0x8],0x0
10008db6:	75 05                	jne    0x10008dbd
10008db8:	83 c3 14             	add    ebx,0x14
10008dbb:	eb ee                	jmp    0x10008dab
10008dbd:	3b d8                	cmp    ebx,eax
10008dbf:	75 0e                	jne    0x10008dcf
10008dc1:	e8 38 02 00 00       	call   0x10008ffe
10008dc6:	8b d8                	mov    ebx,eax
10008dc8:	85 db                	test   ebx,ebx
10008dca:	89 5d 08             	mov    DWORD PTR [ebp+0x8],ebx
10008dcd:	74 14                	je     0x10008de3
10008dcf:	53                   	push   ebx
10008dd0:	e8 da 02 00 00       	call   0x100090af
10008dd5:	59                   	pop    ecx
10008dd6:	8b 4b 10             	mov    ecx,DWORD PTR [ebx+0x10]
10008dd9:	89 01                	mov    DWORD PTR [ecx],eax
10008ddb:	8b 43 10             	mov    eax,DWORD PTR [ebx+0x10]
10008dde:	83 38 ff             	cmp    DWORD PTR [eax],0xffffffff
10008de1:	75 07                	jne    0x10008dea
10008de3:	33 c0                	xor    eax,eax
10008de5:	e9 0f 02 00 00       	jmp    0x10008ff9
10008dea:	89 1d 8c 0a 01 10    	mov    DWORD PTR ds:0x10010a8c,ebx
10008df0:	8b 43 10             	mov    eax,DWORD PTR [ebx+0x10]
10008df3:	8b 10                	mov    edx,DWORD PTR [eax]
10008df5:	83 fa ff             	cmp    edx,0xffffffff
10008df8:	89 55 fc             	mov    DWORD PTR [ebp-0x4],edx
10008dfb:	74 14                	je     0x10008e11
10008dfd:	8b 8c 90 c4 00 00 00 	mov    ecx,DWORD PTR [eax+edx*4+0xc4]
10008e04:	8b 7c 90 44          	mov    edi,DWORD PTR [eax+edx*4+0x44]
10008e08:	23 4d f8             	and    ecx,DWORD PTR [ebp-0x8]
10008e0b:	23 fe                	and    edi,esi
10008e0d:	0b cf                	or     ecx,edi
10008e0f:	75 37                	jne    0x10008e48
10008e11:	8b 90 c4 00 00 00    	mov    edx,DWORD PTR [eax+0xc4]
10008e17:	8b 70 44             	mov    esi,DWORD PTR [eax+0x44]
10008e1a:	23 55 f8             	and    edx,DWORD PTR [ebp-0x8]
10008e1d:	23 75 f4             	and    esi,DWORD PTR [ebp-0xc]
10008e20:	83 65 fc 00          	and    DWORD PTR [ebp-0x4],0x0
10008e24:	8d 48 44             	lea    ecx,[eax+0x44]
10008e27:	0b d6                	or     edx,esi
10008e29:	8b 75 f4             	mov    esi,DWORD PTR [ebp-0xc]
10008e2c:	75 17                	jne    0x10008e45
10008e2e:	8b 91 84 00 00 00    	mov    edx,DWORD PTR [ecx+0x84]
10008e34:	ff 45 fc             	inc    DWORD PTR [ebp-0x4]
10008e37:	23 55 f8             	and    edx,DWORD PTR [ebp-0x8]
10008e3a:	83 c1 04             	add    ecx,0x4
10008e3d:	8b fe                	mov    edi,esi
10008e3f:	23 39                	and    edi,DWORD PTR [ecx]
10008e41:	0b d7                	or     edx,edi
10008e43:	74 e9                	je     0x10008e2e
10008e45:	8b 55 fc             	mov    edx,DWORD PTR [ebp-0x4]
10008e48:	8b ca                	mov    ecx,edx
10008e4a:	33 ff                	xor    edi,edi
10008e4c:	69 c9 04 02 00 00    	imul   ecx,ecx,0x204
10008e52:	8d 8c 01 44 01 00 00 	lea    ecx,[ecx+eax*1+0x144]
10008e59:	89 4d f4             	mov    DWORD PTR [ebp-0xc],ecx
10008e5c:	8b 4c 90 44          	mov    ecx,DWORD PTR [eax+edx*4+0x44]
10008e60:	23 ce                	and    ecx,esi
10008e62:	75 0d                	jne    0x10008e71
10008e64:	8b 8c 90 c4 00 00 00 	mov    ecx,DWORD PTR [eax+edx*4+0xc4]
10008e6b:	6a 20                	push   0x20
10008e6d:	23 4d f8             	and    ecx,DWORD PTR [ebp-0x8]
10008e70:	5f                   	pop    edi
10008e71:	85 c9                	test   ecx,ecx
10008e73:	7c 05                	jl     0x10008e7a
10008e75:	d1 e1                	shl    ecx,1
10008e77:	47                   	inc    edi
10008e78:	eb f7                	jmp    0x10008e71
10008e7a:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
10008e7d:	8b 54 f9 04          	mov    edx,DWORD PTR [ecx+edi*8+0x4]
10008e81:	8b 0a                	mov    ecx,DWORD PTR [edx]
10008e83:	2b 4d f0             	sub    ecx,DWORD PTR [ebp-0x10]
10008e86:	8b f1                	mov    esi,ecx
10008e88:	89 4d f8             	mov    DWORD PTR [ebp-0x8],ecx
10008e8b:	c1 fe 04             	sar    esi,0x4
10008e8e:	4e                   	dec    esi
10008e8f:	83 fe 3f             	cmp    esi,0x3f
10008e92:	7e 03                	jle    0x10008e97
10008e94:	6a 3f                	push   0x3f
10008e96:	5e                   	pop    esi
10008e97:	3b f7                	cmp    esi,edi
10008e99:	0f 84 0d 01 00 00    	je     0x10008fac
10008e9f:	8b 4a 04             	mov    ecx,DWORD PTR [edx+0x4]
10008ea2:	3b 4a 08             	cmp    ecx,DWORD PTR [edx+0x8]
10008ea5:	75 61                	jne    0x10008f08
10008ea7:	83 ff 20             	cmp    edi,0x20
10008eaa:	7d 2b                	jge    0x10008ed7
10008eac:	bb 00 00 00 80       	mov    ebx,0x80000000
10008eb1:	8b cf                	mov    ecx,edi
10008eb3:	d3 eb                	shr    ebx,cl
10008eb5:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10008eb8:	8d 7c 38 04          	lea    edi,[eax+edi*1+0x4]
10008ebc:	f7 d3                	not    ebx
10008ebe:	89 5d ec             	mov    DWORD PTR [ebp-0x14],ebx
10008ec1:	23 5c 88 44          	and    ebx,DWORD PTR [eax+ecx*4+0x44]
10008ec5:	89 5c 88 44          	mov    DWORD PTR [eax+ecx*4+0x44],ebx
10008ec9:	fe 0f                	dec    BYTE PTR [edi]
10008ecb:	75 38                	jne    0x10008f05
10008ecd:	8b 5d 08             	mov    ebx,DWORD PTR [ebp+0x8]
10008ed0:	8b 4d ec             	mov    ecx,DWORD PTR [ebp-0x14]
10008ed3:	21 0b                	and    DWORD PTR [ebx],ecx
10008ed5:	eb 31                	jmp    0x10008f08
10008ed7:	8d 4f e0             	lea    ecx,[edi-0x20]
10008eda:	bb 00 00 00 80       	mov    ebx,0x80000000
10008edf:	d3 eb                	shr    ebx,cl
10008ee1:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10008ee4:	8d 7c 38 04          	lea    edi,[eax+edi*1+0x4]
10008ee8:	8d 8c 88 c4 00 00 00 	lea    ecx,[eax+ecx*4+0xc4]
10008eef:	f7 d3                	not    ebx
10008ef1:	21 19                	and    DWORD PTR [ecx],ebx
10008ef3:	fe 0f                	dec    BYTE PTR [edi]
10008ef5:	89 5d ec             	mov    DWORD PTR [ebp-0x14],ebx
10008ef8:	75 0b                	jne    0x10008f05
10008efa:	8b 5d 08             	mov    ebx,DWORD PTR [ebp+0x8]
10008efd:	8b 4d ec             	mov    ecx,DWORD PTR [ebp-0x14]
10008f00:	21 4b 04             	and    DWORD PTR [ebx+0x4],ecx
10008f03:	eb 03                	jmp    0x10008f08
10008f05:	8b 5d 08             	mov    ebx,DWORD PTR [ebp+0x8]
10008f08:	8b 4a 08             	mov    ecx,DWORD PTR [edx+0x8]
10008f0b:	8b 7a 04             	mov    edi,DWORD PTR [edx+0x4]
10008f0e:	83 7d f8 00          	cmp    DWORD PTR [ebp-0x8],0x0
10008f12:	89 79 04             	mov    DWORD PTR [ecx+0x4],edi
10008f15:	8b 4a 04             	mov    ecx,DWORD PTR [edx+0x4]
10008f18:	8b 7a 08             	mov    edi,DWORD PTR [edx+0x8]
10008f1b:	89 79 08             	mov    DWORD PTR [ecx+0x8],edi
10008f1e:	0f 84 94 00 00 00    	je     0x10008fb8
10008f24:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
10008f27:	8b 7c f1 04          	mov    edi,DWORD PTR [ecx+esi*8+0x4]
10008f2b:	8d 0c f1             	lea    ecx,[ecx+esi*8]
10008f2e:	89 7a 04             	mov    DWORD PTR [edx+0x4],edi
10008f31:	89 4a 08             	mov    DWORD PTR [edx+0x8],ecx
10008f34:	89 51 04             	mov    DWORD PTR [ecx+0x4],edx
10008f37:	8b 4a 04             	mov    ecx,DWORD PTR [edx+0x4]
10008f3a:	89 51 08             	mov    DWORD PTR [ecx+0x8],edx
10008f3d:	8b 4a 04             	mov    ecx,DWORD PTR [edx+0x4]
10008f40:	3b 4a 08             	cmp    ecx,DWORD PTR [edx+0x8]
10008f43:	75 64                	jne    0x10008fa9
10008f45:	8a 4c 06 04          	mov    cl,BYTE PTR [esi+eax*1+0x4]
10008f49:	83 fe 20             	cmp    esi,0x20
10008f4c:	88 4d 0b             	mov    BYTE PTR [ebp+0xb],cl
10008f4f:	7d 29                	jge    0x10008f7a
10008f51:	fe c1                	inc    cl
10008f53:	80 7d 0b 00          	cmp    BYTE PTR [ebp+0xb],0x0
10008f57:	88 4c 06 04          	mov    BYTE PTR [esi+eax*1+0x4],cl
10008f5b:	75 0b                	jne    0x10008f68
10008f5d:	bf 00 00 00 80       	mov    edi,0x80000000
10008f62:	8b ce                	mov    ecx,esi
10008f64:	d3 ef                	shr    edi,cl
10008f66:	09 3b                	or     DWORD PTR [ebx],edi
10008f68:	bf 00 00 00 80       	mov    edi,0x80000000
10008f6d:	8b ce                	mov    ecx,esi
10008f6f:	d3 ef                	shr    edi,cl
10008f71:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10008f74:	09 7c 88 44          	or     DWORD PTR [eax+ecx*4+0x44],edi
10008f78:	eb 2f                	jmp    0x10008fa9
10008f7a:	fe c1                	inc    cl
10008f7c:	80 7d 0b 00          	cmp    BYTE PTR [ebp+0xb],0x0
10008f80:	88 4c 06 04          	mov    BYTE PTR [esi+eax*1+0x4],cl
10008f84:	75 0d                	jne    0x10008f93
10008f86:	8d 4e e0             	lea    ecx,[esi-0x20]
10008f89:	bf 00 00 00 80       	mov    edi,0x80000000
10008f8e:	d3 ef                	shr    edi,cl
10008f90:	09 7b 04             	or     DWORD PTR [ebx+0x4],edi
10008f93:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10008f96:	8d bc 88 c4 00 00 00 	lea    edi,[eax+ecx*4+0xc4]
10008f9d:	8d 4e e0             	lea    ecx,[esi-0x20]
10008fa0:	be 00 00 00 80       	mov    esi,0x80000000
10008fa5:	d3 ee                	shr    esi,cl
10008fa7:	09 37                	or     DWORD PTR [edi],esi
10008fa9:	8b 4d f8             	mov    ecx,DWORD PTR [ebp-0x8]
10008fac:	85 c9                	test   ecx,ecx
10008fae:	74 0b                	je     0x10008fbb
10008fb0:	89 0a                	mov    DWORD PTR [edx],ecx
10008fb2:	89 4c 11 fc          	mov    DWORD PTR [ecx+edx*1-0x4],ecx
10008fb6:	eb 03                	jmp    0x10008fbb
10008fb8:	8b 4d f8             	mov    ecx,DWORD PTR [ebp-0x8]
10008fbb:	8b 75 f0             	mov    esi,DWORD PTR [ebp-0x10]
10008fbe:	03 d1                	add    edx,ecx
10008fc0:	8d 4e 01             	lea    ecx,[esi+0x1]
10008fc3:	89 0a                	mov    DWORD PTR [edx],ecx
10008fc5:	89 4c 32 fc          	mov    DWORD PTR [edx+esi*1-0x4],ecx
10008fc9:	8b 75 f4             	mov    esi,DWORD PTR [ebp-0xc]
10008fcc:	8b 0e                	mov    ecx,DWORD PTR [esi]
10008fce:	85 c9                	test   ecx,ecx
10008fd0:	8d 79 01             	lea    edi,[ecx+0x1]
10008fd3:	89 3e                	mov    DWORD PTR [esi],edi
10008fd5:	75 1a                	jne    0x10008ff1
10008fd7:	3b 1d 90 0a 01 10    	cmp    ebx,DWORD PTR ds:0x10010a90
10008fdd:	75 12                	jne    0x10008ff1
10008fdf:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10008fe2:	3b 0d 88 0a 01 10    	cmp    ecx,DWORD PTR ds:0x10010a88
10008fe8:	75 07                	jne    0x10008ff1
10008fea:	83 25 90 0a 01 10 00 	and    DWORD PTR ds:0x10010a90,0x0
10008ff1:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10008ff4:	89 08                	mov    DWORD PTR [eax],ecx
10008ff6:	8d 42 04             	lea    eax,[edx+0x4]
10008ff9:	5f                   	pop    edi
10008ffa:	5e                   	pop    esi
10008ffb:	5b                   	pop    ebx
10008ffc:	c9                   	leave
10008ffd:	c3                   	ret
10008ffe:	a1 94 0a 01 10       	mov    eax,ds:0x10010a94
10009003:	8b 0d 84 0a 01 10    	mov    ecx,DWORD PTR ds:0x10010a84
10009009:	56                   	push   esi
1000900a:	57                   	push   edi
1000900b:	33 ff                	xor    edi,edi
1000900d:	3b c1                	cmp    eax,ecx
1000900f:	75 30                	jne    0x10009041
10009011:	8d 44 89 50          	lea    eax,[ecx+ecx*4+0x50]
10009015:	c1 e0 02             	shl    eax,0x2
10009018:	50                   	push   eax
10009019:	ff 35 98 0a 01 10    	push   DWORD PTR ds:0x10010a98
1000901f:	57                   	push   edi
10009020:	ff 35 a4 0b 01 10    	push   DWORD PTR ds:0x10010ba4
10009026:	ff 15 84 d0 00 10    	call   DWORD PTR ds:0x1000d084
1000902c:	3b c7                	cmp    eax,edi
1000902e:	74 61                	je     0x10009091
10009030:	83 05 84 0a 01 10 10 	add    DWORD PTR ds:0x10010a84,0x10
10009037:	a3 98 0a 01 10       	mov    ds:0x10010a98,eax
1000903c:	a1 94 0a 01 10       	mov    eax,ds:0x10010a94
10009041:	8b 0d 98 0a 01 10    	mov    ecx,DWORD PTR ds:0x10010a98
10009047:	68 c4 41 00 00       	push   0x41c4
1000904c:	6a 08                	push   0x8
1000904e:	8d 04 80             	lea    eax,[eax+eax*4]
10009051:	ff 35 a4 0b 01 10    	push   DWORD PTR ds:0x10010ba4
10009057:	8d 34 81             	lea    esi,[ecx+eax*4]
1000905a:	ff 15 38 d0 00 10    	call   DWORD PTR ds:0x1000d038
10009060:	3b c7                	cmp    eax,edi
10009062:	89 46 10             	mov    DWORD PTR [esi+0x10],eax
10009065:	74 2a                	je     0x10009091
10009067:	6a 04                	push   0x4
10009069:	68 00 20 00 00       	push   0x2000
1000906e:	68 00 00 10 00       	push   0x100000
10009073:	57                   	push   edi
10009074:	ff 15 80 d0 00 10    	call   DWORD PTR ds:0x1000d080
1000907a:	3b c7                	cmp    eax,edi
1000907c:	89 46 0c             	mov    DWORD PTR [esi+0xc],eax
1000907f:	75 14                	jne    0x10009095
10009081:	ff 76 10             	push   DWORD PTR [esi+0x10]
10009084:	57                   	push   edi
10009085:	ff 35 a4 0b 01 10    	push   DWORD PTR ds:0x10010ba4
1000908b:	ff 15 34 d0 00 10    	call   DWORD PTR ds:0x1000d034
10009091:	33 c0                	xor    eax,eax
10009093:	eb 17                	jmp    0x100090ac
10009095:	83 4e 08 ff          	or     DWORD PTR [esi+0x8],0xffffffff
10009099:	89 3e                	mov    DWORD PTR [esi],edi
1000909b:	89 7e 04             	mov    DWORD PTR [esi+0x4],edi
1000909e:	ff 05 94 0a 01 10    	inc    DWORD PTR ds:0x10010a94
100090a4:	8b 46 10             	mov    eax,DWORD PTR [esi+0x10]
100090a7:	83 08 ff             	or     DWORD PTR [eax],0xffffffff
100090aa:	8b c6                	mov    eax,esi
100090ac:	5f                   	pop    edi
100090ad:	5e                   	pop    esi
100090ae:	c3                   	ret
100090af:	55                   	push   ebp
100090b0:	8b ec                	mov    ebp,esp
100090b2:	51                   	push   ecx
100090b3:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
100090b6:	53                   	push   ebx
100090b7:	56                   	push   esi
100090b8:	57                   	push   edi
100090b9:	8b 71 10             	mov    esi,DWORD PTR [ecx+0x10]
100090bc:	8b 41 08             	mov    eax,DWORD PTR [ecx+0x8]
100090bf:	33 db                	xor    ebx,ebx
100090c1:	85 c0                	test   eax,eax
100090c3:	7c 05                	jl     0x100090ca
100090c5:	d1 e0                	shl    eax,1
100090c7:	43                   	inc    ebx
100090c8:	eb f7                	jmp    0x100090c1
100090ca:	8b c3                	mov    eax,ebx
100090cc:	6a 3f                	push   0x3f
100090ce:	69 c0 04 02 00 00    	imul   eax,eax,0x204
100090d4:	5a                   	pop    edx
100090d5:	8d 84 30 44 01 00 00 	lea    eax,[eax+esi*1+0x144]
100090dc:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
100090df:	89 40 08             	mov    DWORD PTR [eax+0x8],eax
100090e2:	89 40 04             	mov    DWORD PTR [eax+0x4],eax
100090e5:	83 c0 08             	add    eax,0x8
100090e8:	4a                   	dec    edx
100090e9:	75 f4                	jne    0x100090df
100090eb:	8b fb                	mov    edi,ebx
100090ed:	6a 04                	push   0x4
100090ef:	c1 e7 0f             	shl    edi,0xf
100090f2:	03 79 0c             	add    edi,DWORD PTR [ecx+0xc]
100090f5:	68 00 10 00 00       	push   0x1000
100090fa:	68 00 80 00 00       	push   0x8000
100090ff:	57                   	push   edi
10009100:	ff 15 80 d0 00 10    	call   DWORD PTR ds:0x1000d080
10009106:	85 c0                	test   eax,eax
10009108:	75 08                	jne    0x10009112
1000910a:	83 c8 ff             	or     eax,0xffffffff
1000910d:	e9 93 00 00 00       	jmp    0x100091a5
10009112:	8d 97 00 70 00 00    	lea    edx,[edi+0x7000]
10009118:	3b fa                	cmp    edi,edx
1000911a:	77 3c                	ja     0x10009158
1000911c:	8d 47 10             	lea    eax,[edi+0x10]
1000911f:	83 48 f8 ff          	or     DWORD PTR [eax-0x8],0xffffffff
10009123:	83 88 ec 0f 00 00 ff 	or     DWORD PTR [eax+0xfec],0xffffffff
1000912a:	8d 88 fc 0f 00 00    	lea    ecx,[eax+0xffc]
10009130:	c7 40 fc f0 0f 00 00 	mov    DWORD PTR [eax-0x4],0xff0
10009137:	89 08                	mov    DWORD PTR [eax],ecx
10009139:	8d 88 fc ef ff ff    	lea    ecx,[eax-0x1004]
1000913f:	89 48 04             	mov    DWORD PTR [eax+0x4],ecx
10009142:	c7 80 e8 0f 00 00 f0 	mov    DWORD PTR [eax+0xfe8],0xff0
10009149:	0f 00 00 
1000914c:	05 00 10 00 00       	add    eax,0x1000
10009151:	8d 48 f0             	lea    ecx,[eax-0x10]
10009154:	3b ca                	cmp    ecx,edx
10009156:	76 c7                	jbe    0x1000911f
10009158:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
1000915b:	8d 4f 0c             	lea    ecx,[edi+0xc]
1000915e:	05 f8 01 00 00       	add    eax,0x1f8
10009163:	6a 01                	push   0x1
10009165:	5f                   	pop    edi
10009166:	89 48 04             	mov    DWORD PTR [eax+0x4],ecx
10009169:	89 41 08             	mov    DWORD PTR [ecx+0x8],eax
1000916c:	8d 4a 0c             	lea    ecx,[edx+0xc]
1000916f:	89 48 08             	mov    DWORD PTR [eax+0x8],ecx
10009172:	89 41 04             	mov    DWORD PTR [ecx+0x4],eax
10009175:	83 64 9e 44 00       	and    DWORD PTR [esi+ebx*4+0x44],0x0
1000917a:	89 bc 9e c4 00 00 00 	mov    DWORD PTR [esi+ebx*4+0xc4],edi
10009181:	8a 46 43             	mov    al,BYTE PTR [esi+0x43]
10009184:	8a c8                	mov    cl,al
10009186:	fe c1                	inc    cl
10009188:	84 c0                	test   al,al
1000918a:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000918d:	88 4e 43             	mov    BYTE PTR [esi+0x43],cl
10009190:	75 03                	jne    0x10009195
10009192:	09 78 04             	or     DWORD PTR [eax+0x4],edi
10009195:	ba 00 00 00 80       	mov    edx,0x80000000
1000919a:	8b cb                	mov    ecx,ebx
1000919c:	d3 ea                	shr    edx,cl
1000919e:	f7 d2                	not    edx
100091a0:	21 50 08             	and    DWORD PTR [eax+0x8],edx
100091a3:	8b c3                	mov    eax,ebx
100091a5:	5f                   	pop    edi
100091a6:	5e                   	pop    esi
100091a7:	5b                   	pop    ebx
100091a8:	c9                   	leave
100091a9:	c3                   	ret
100091aa:	55                   	push   ebp
100091ab:	8b ec                	mov    ebp,esp
100091ad:	83 ec 0c             	sub    esp,0xc
100091b0:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
100091b3:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
100091b6:	53                   	push   ebx
100091b7:	56                   	push   esi
100091b8:	57                   	push   edi
100091b9:	8b 7d 0c             	mov    edi,DWORD PTR [ebp+0xc]
100091bc:	8b d7                	mov    edx,edi
100091be:	8d 70 17             	lea    esi,[eax+0x17]
100091c1:	2b 51 0c             	sub    edx,DWORD PTR [ecx+0xc]
100091c4:	8b 41 10             	mov    eax,DWORD PTR [ecx+0x10]
100091c7:	83 e6 f0             	and    esi,0xfffffff0
100091ca:	c1 ea 0f             	shr    edx,0xf
100091cd:	8b ca                	mov    ecx,edx
100091cf:	69 c9 04 02 00 00    	imul   ecx,ecx,0x204
100091d5:	8d 8c 01 44 01 00 00 	lea    ecx,[ecx+eax*1+0x144]
100091dc:	89 4d f4             	mov    DWORD PTR [ebp-0xc],ecx
100091df:	8b 4f fc             	mov    ecx,DWORD PTR [edi-0x4]
100091e2:	49                   	dec    ecx
100091e3:	3b f1                	cmp    esi,ecx
100091e5:	89 4d 10             	mov    DWORD PTR [ebp+0x10],ecx
100091e8:	8b 5c 39 fc          	mov    ebx,DWORD PTR [ecx+edi*1-0x4]
100091ec:	8d 7c 39 fc          	lea    edi,[ecx+edi*1-0x4]
100091f0:	89 5d fc             	mov    DWORD PTR [ebp-0x4],ebx
100091f3:	0f 8e 5f 01 00 00    	jle    0x10009358
100091f9:	f6 c3 01             	test   bl,0x1
100091fc:	0f 85 4f 01 00 00    	jne    0x10009351
10009202:	03 d9                	add    ebx,ecx
10009204:	3b f3                	cmp    esi,ebx
10009206:	0f 8f 45 01 00 00    	jg     0x10009351
1000920c:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
1000920f:	c1 f9 04             	sar    ecx,0x4
10009212:	49                   	dec    ecx
10009213:	83 f9 3f             	cmp    ecx,0x3f
10009216:	89 4d f8             	mov    DWORD PTR [ebp-0x8],ecx
10009219:	76 06                	jbe    0x10009221
1000921b:	6a 3f                	push   0x3f
1000921d:	59                   	pop    ecx
1000921e:	89 4d f8             	mov    DWORD PTR [ebp-0x8],ecx
10009221:	8b 5f 04             	mov    ebx,DWORD PTR [edi+0x4]
10009224:	3b 5f 08             	cmp    ebx,DWORD PTR [edi+0x8]
10009227:	75 48                	jne    0x10009271
10009229:	83 f9 20             	cmp    ecx,0x20
1000922c:	73 1f                	jae    0x1000924d
1000922e:	bb 00 00 00 80       	mov    ebx,0x80000000
10009233:	d3 eb                	shr    ebx,cl
10009235:	8b 4d f8             	mov    ecx,DWORD PTR [ebp-0x8]
10009238:	8d 4c 01 04          	lea    ecx,[ecx+eax*1+0x4]
1000923c:	f7 d3                	not    ebx
1000923e:	21 5c 90 44          	and    DWORD PTR [eax+edx*4+0x44],ebx
10009242:	fe 09                	dec    BYTE PTR [ecx]
10009244:	75 2b                	jne    0x10009271
10009246:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
10009249:	21 19                	and    DWORD PTR [ecx],ebx
1000924b:	eb 24                	jmp    0x10009271
1000924d:	83 c1 e0             	add    ecx,0xffffffe0
10009250:	bb 00 00 00 80       	mov    ebx,0x80000000
10009255:	d3 eb                	shr    ebx,cl
10009257:	8b 4d f8             	mov    ecx,DWORD PTR [ebp-0x8]
1000925a:	8d 4c 01 04          	lea    ecx,[ecx+eax*1+0x4]
1000925e:	f7 d3                	not    ebx
10009260:	21 9c 90 c4 00 00 00 	and    DWORD PTR [eax+edx*4+0xc4],ebx
10009267:	fe 09                	dec    BYTE PTR [ecx]
10009269:	75 06                	jne    0x10009271
1000926b:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
1000926e:	21 59 04             	and    DWORD PTR [ecx+0x4],ebx
10009271:	8b 4f 08             	mov    ecx,DWORD PTR [edi+0x8]
10009274:	8b 5f 04             	mov    ebx,DWORD PTR [edi+0x4]
10009277:	89 59 04             	mov    DWORD PTR [ecx+0x4],ebx
1000927a:	8b 4f 04             	mov    ecx,DWORD PTR [edi+0x4]
1000927d:	8b 7f 08             	mov    edi,DWORD PTR [edi+0x8]
10009280:	89 79 08             	mov    DWORD PTR [ecx+0x8],edi
10009283:	8b 4d 10             	mov    ecx,DWORD PTR [ebp+0x10]
10009286:	2b ce                	sub    ecx,esi
10009288:	01 4d fc             	add    DWORD PTR [ebp-0x4],ecx
1000928b:	83 7d fc 00          	cmp    DWORD PTR [ebp-0x4],0x0
1000928f:	0f 8e aa 00 00 00    	jle    0x1000933f
10009295:	8b 7d fc             	mov    edi,DWORD PTR [ebp-0x4]
10009298:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
1000929b:	c1 ff 04             	sar    edi,0x4
1000929e:	4f                   	dec    edi
1000929f:	8d 4c 31 fc          	lea    ecx,[ecx+esi*1-0x4]
100092a3:	83 ff 3f             	cmp    edi,0x3f
100092a6:	76 03                	jbe    0x100092ab
100092a8:	6a 3f                	push   0x3f
100092aa:	5f                   	pop    edi
100092ab:	8b 5d f4             	mov    ebx,DWORD PTR [ebp-0xc]
100092ae:	8d 1c fb             	lea    ebx,[ebx+edi*8]
100092b1:	89 5d 10             	mov    DWORD PTR [ebp+0x10],ebx
100092b4:	8b 5b 04             	mov    ebx,DWORD PTR [ebx+0x4]
100092b7:	89 59 04             	mov    DWORD PTR [ecx+0x4],ebx
100092ba:	8b 5d 10             	mov    ebx,DWORD PTR [ebp+0x10]
100092bd:	89 59 08             	mov    DWORD PTR [ecx+0x8],ebx
100092c0:	89 4b 04             	mov    DWORD PTR [ebx+0x4],ecx
100092c3:	8b 59 04             	mov    ebx,DWORD PTR [ecx+0x4]
100092c6:	89 4b 08             	mov    DWORD PTR [ebx+0x8],ecx
100092c9:	8b 59 04             	mov    ebx,DWORD PTR [ecx+0x4]
100092cc:	3b 59 08             	cmp    ebx,DWORD PTR [ecx+0x8]
100092cf:	75 5c                	jne    0x1000932d
100092d1:	8a 4c 07 04          	mov    cl,BYTE PTR [edi+eax*1+0x4]
100092d5:	83 ff 20             	cmp    edi,0x20
100092d8:	88 4d 13             	mov    BYTE PTR [ebp+0x13],cl
100092db:	fe c1                	inc    cl
100092dd:	88 4c 07 04          	mov    BYTE PTR [edi+eax*1+0x4],cl
100092e1:	73 21                	jae    0x10009304
100092e3:	80 7d 13 00          	cmp    BYTE PTR [ebp+0x13],0x0
100092e7:	75 0e                	jne    0x100092f7
100092e9:	bb 00 00 00 80       	mov    ebx,0x80000000
100092ee:	8b cf                	mov    ecx,edi
100092f0:	d3 eb                	shr    ebx,cl
100092f2:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
100092f5:	09 19                	or     DWORD PTR [ecx],ebx
100092f7:	8d 44 90 44          	lea    eax,[eax+edx*4+0x44]
100092fb:	ba 00 00 00 80       	mov    edx,0x80000000
10009300:	8b cf                	mov    ecx,edi
10009302:	eb 25                	jmp    0x10009329
10009304:	80 7d 13 00          	cmp    BYTE PTR [ebp+0x13],0x0
10009308:	75 10                	jne    0x1000931a
1000930a:	8d 4f e0             	lea    ecx,[edi-0x20]
1000930d:	bb 00 00 00 80       	mov    ebx,0x80000000
10009312:	d3 eb                	shr    ebx,cl
10009314:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
10009317:	09 59 04             	or     DWORD PTR [ecx+0x4],ebx
1000931a:	8d 84 90 c4 00 00 00 	lea    eax,[eax+edx*4+0xc4]
10009321:	8d 4f e0             	lea    ecx,[edi-0x20]
10009324:	ba 00 00 00 80       	mov    edx,0x80000000
10009329:	d3 ea                	shr    edx,cl
1000932b:	09 10                	or     DWORD PTR [eax],edx
1000932d:	8b 55 0c             	mov    edx,DWORD PTR [ebp+0xc]
10009330:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10009333:	8d 44 32 fc          	lea    eax,[edx+esi*1-0x4]
10009337:	89 08                	mov    DWORD PTR [eax],ecx
10009339:	89 4c 01 fc          	mov    DWORD PTR [ecx+eax*1-0x4],ecx
1000933d:	eb 03                	jmp    0x10009342
1000933f:	8b 55 0c             	mov    edx,DWORD PTR [ebp+0xc]
10009342:	8d 46 01             	lea    eax,[esi+0x1]
10009345:	89 42 fc             	mov    DWORD PTR [edx-0x4],eax
10009348:	89 44 32 f8          	mov    DWORD PTR [edx+esi*1-0x8],eax
1000934c:	e9 47 01 00 00       	jmp    0x10009498
10009351:	33 c0                	xor    eax,eax
10009353:	e9 43 01 00 00       	jmp    0x1000949b
10009358:	0f 8d 3a 01 00 00    	jge    0x10009498
1000935e:	8b 5d 0c             	mov    ebx,DWORD PTR [ebp+0xc]
10009361:	29 75 10             	sub    DWORD PTR [ebp+0x10],esi
10009364:	8d 4e 01             	lea    ecx,[esi+0x1]
10009367:	89 4b fc             	mov    DWORD PTR [ebx-0x4],ecx
1000936a:	8d 5c 33 fc          	lea    ebx,[ebx+esi*1-0x4]
1000936e:	8b 75 10             	mov    esi,DWORD PTR [ebp+0x10]
10009371:	89 5d 0c             	mov    DWORD PTR [ebp+0xc],ebx
10009374:	c1 fe 04             	sar    esi,0x4
10009377:	4e                   	dec    esi
10009378:	89 4b fc             	mov    DWORD PTR [ebx-0x4],ecx
1000937b:	83 fe 3f             	cmp    esi,0x3f
1000937e:	76 03                	jbe    0x10009383
10009380:	6a 3f                	push   0x3f
10009382:	5e                   	pop    esi
10009383:	f6 45 fc 01          	test   BYTE PTR [ebp-0x4],0x1
10009387:	0f 85 85 00 00 00    	jne    0x10009412
1000938d:	8b 75 fc             	mov    esi,DWORD PTR [ebp-0x4]
10009390:	c1 fe 04             	sar    esi,0x4
10009393:	4e                   	dec    esi
10009394:	83 fe 3f             	cmp    esi,0x3f
10009397:	76 03                	jbe    0x1000939c
10009399:	6a 3f                	push   0x3f
1000939b:	5e                   	pop    esi
1000939c:	8b 4f 04             	mov    ecx,DWORD PTR [edi+0x4]
1000939f:	3b 4f 08             	cmp    ecx,DWORD PTR [edi+0x8]
100093a2:	75 47                	jne    0x100093eb
100093a4:	83 fe 20             	cmp    esi,0x20
100093a7:	73 1e                	jae    0x100093c7
100093a9:	bb 00 00 00 80       	mov    ebx,0x80000000
100093ae:	8b ce                	mov    ecx,esi
100093b0:	d3 eb                	shr    ebx,cl
100093b2:	8d 74 06 04          	lea    esi,[esi+eax*1+0x4]
100093b6:	f7 d3                	not    ebx
100093b8:	21 5c 90 44          	and    DWORD PTR [eax+edx*4+0x44],ebx
100093bc:	fe 0e                	dec    BYTE PTR [esi]
100093be:	75 28                	jne    0x100093e8
100093c0:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
100093c3:	21 19                	and    DWORD PTR [ecx],ebx
100093c5:	eb 21                	jmp    0x100093e8
100093c7:	8d 4e e0             	lea    ecx,[esi-0x20]
100093ca:	bb 00 00 00 80       	mov    ebx,0x80000000
100093cf:	d3 eb                	shr    ebx,cl
100093d1:	8d 4c 06 04          	lea    ecx,[esi+eax*1+0x4]
100093d5:	f7 d3                	not    ebx
100093d7:	21 9c 90 c4 00 00 00 	and    DWORD PTR [eax+edx*4+0xc4],ebx
100093de:	fe 09                	dec    BYTE PTR [ecx]
100093e0:	75 06                	jne    0x100093e8
100093e2:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
100093e5:	21 59 04             	and    DWORD PTR [ecx+0x4],ebx
100093e8:	8b 5d 0c             	mov    ebx,DWORD PTR [ebp+0xc]
100093eb:	8b 4f 08             	mov    ecx,DWORD PTR [edi+0x8]
100093ee:	8b 77 04             	mov    esi,DWORD PTR [edi+0x4]
100093f1:	89 71 04             	mov    DWORD PTR [ecx+0x4],esi
100093f4:	8b 4f 04             	mov    ecx,DWORD PTR [edi+0x4]
100093f7:	8b 77 08             	mov    esi,DWORD PTR [edi+0x8]
100093fa:	89 71 08             	mov    DWORD PTR [ecx+0x8],esi
100093fd:	8b 75 10             	mov    esi,DWORD PTR [ebp+0x10]
10009400:	03 75 fc             	add    esi,DWORD PTR [ebp-0x4]
10009403:	89 75 10             	mov    DWORD PTR [ebp+0x10],esi
10009406:	c1 fe 04             	sar    esi,0x4
10009409:	4e                   	dec    esi
1000940a:	83 fe 3f             	cmp    esi,0x3f
1000940d:	76 03                	jbe    0x10009412
1000940f:	6a 3f                	push   0x3f
10009411:	5e                   	pop    esi
10009412:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
10009415:	8b 7c f1 04          	mov    edi,DWORD PTR [ecx+esi*8+0x4]
10009419:	8d 0c f1             	lea    ecx,[ecx+esi*8]
1000941c:	89 7b 04             	mov    DWORD PTR [ebx+0x4],edi
1000941f:	89 4b 08             	mov    DWORD PTR [ebx+0x8],ecx
10009422:	89 59 04             	mov    DWORD PTR [ecx+0x4],ebx
10009425:	8b 4b 04             	mov    ecx,DWORD PTR [ebx+0x4]
10009428:	89 59 08             	mov    DWORD PTR [ecx+0x8],ebx
1000942b:	8b 4b 04             	mov    ecx,DWORD PTR [ebx+0x4]
1000942e:	3b 4b 08             	cmp    ecx,DWORD PTR [ebx+0x8]
10009431:	75 5c                	jne    0x1000948f
10009433:	8a 4c 06 04          	mov    cl,BYTE PTR [esi+eax*1+0x4]
10009437:	83 fe 20             	cmp    esi,0x20
1000943a:	88 4d 0f             	mov    BYTE PTR [ebp+0xf],cl
1000943d:	fe c1                	inc    cl
1000943f:	88 4c 06 04          	mov    BYTE PTR [esi+eax*1+0x4],cl
10009443:	73 21                	jae    0x10009466
10009445:	80 7d 0f 00          	cmp    BYTE PTR [ebp+0xf],0x0
10009449:	75 0e                	jne    0x10009459
1000944b:	bf 00 00 00 80       	mov    edi,0x80000000
10009450:	8b ce                	mov    ecx,esi
10009452:	d3 ef                	shr    edi,cl
10009454:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
10009457:	09 39                	or     DWORD PTR [ecx],edi
10009459:	8d 44 90 44          	lea    eax,[eax+edx*4+0x44]
1000945d:	ba 00 00 00 80       	mov    edx,0x80000000
10009462:	8b ce                	mov    ecx,esi
10009464:	eb 25                	jmp    0x1000948b
10009466:	80 7d 0f 00          	cmp    BYTE PTR [ebp+0xf],0x0
1000946a:	75 10                	jne    0x1000947c
1000946c:	8d 4e e0             	lea    ecx,[esi-0x20]
1000946f:	bf 00 00 00 80       	mov    edi,0x80000000
10009474:	d3 ef                	shr    edi,cl
10009476:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
10009479:	09 79 04             	or     DWORD PTR [ecx+0x4],edi
1000947c:	8d 84 90 c4 00 00 00 	lea    eax,[eax+edx*4+0xc4]
10009483:	8d 4e e0             	lea    ecx,[esi-0x20]
10009486:	ba 00 00 00 80       	mov    edx,0x80000000
1000948b:	d3 ea                	shr    edx,cl
1000948d:	09 10                	or     DWORD PTR [eax],edx
1000948f:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
10009492:	89 03                	mov    DWORD PTR [ebx],eax
10009494:	89 44 18 fc          	mov    DWORD PTR [eax+ebx*1-0x4],eax
10009498:	6a 01                	push   0x1
1000949a:	58                   	pop    eax
1000949b:	5f                   	pop    edi
1000949c:	5e                   	pop    esi
1000949d:	5b                   	pop    ebx
1000949e:	c9                   	leave
1000949f:	c3                   	ret
100094a0:	a1 90 0a 01 10       	mov    eax,ds:0x10010a90
100094a5:	85 c0                	test   eax,eax
100094a7:	0f 84 c3 00 00 00    	je     0x10009570
100094ad:	8b 0d 88 0a 01 10    	mov    ecx,DWORD PTR ds:0x10010a88
100094b3:	68 00 40 00 00       	push   0x4000
100094b8:	c1 e1 0f             	shl    ecx,0xf
100094bb:	03 48 0c             	add    ecx,DWORD PTR [eax+0xc]
100094be:	68 00 80 00 00       	push   0x8000
100094c3:	51                   	push   ecx
100094c4:	ff 15 50 d0 00 10    	call   DWORD PTR ds:0x1000d050
100094ca:	8b 0d 88 0a 01 10    	mov    ecx,DWORD PTR ds:0x10010a88
100094d0:	a1 90 0a 01 10       	mov    eax,ds:0x10010a90
100094d5:	ba 00 00 00 80       	mov    edx,0x80000000
100094da:	d3 ea                	shr    edx,cl
100094dc:	09 50 08             	or     DWORD PTR [eax+0x8],edx
100094df:	a1 90 0a 01 10       	mov    eax,ds:0x10010a90
100094e4:	8b 0d 88 0a 01 10    	mov    ecx,DWORD PTR ds:0x10010a88
100094ea:	8b 40 10             	mov    eax,DWORD PTR [eax+0x10]
100094ed:	83 a4 88 c4 00 00 00 	and    DWORD PTR [eax+ecx*4+0xc4],0x0
100094f4:	00 
100094f5:	a1 90 0a 01 10       	mov    eax,ds:0x10010a90
100094fa:	8b 40 10             	mov    eax,DWORD PTR [eax+0x10]
100094fd:	fe 48 43             	dec    BYTE PTR [eax+0x43]
10009500:	a1 90 0a 01 10       	mov    eax,ds:0x10010a90
10009505:	8b 48 10             	mov    ecx,DWORD PTR [eax+0x10]
10009508:	80 79 43 00          	cmp    BYTE PTR [ecx+0x43],0x0
1000950c:	75 09                	jne    0x10009517
1000950e:	83 60 04 fe          	and    DWORD PTR [eax+0x4],0xfffffffe
10009512:	a1 90 0a 01 10       	mov    eax,ds:0x10010a90
10009517:	83 78 08 ff          	cmp    DWORD PTR [eax+0x8],0xffffffff
1000951b:	75 4c                	jne    0x10009569
1000951d:	83 3d 94 0a 01 10 01 	cmp    DWORD PTR ds:0x10010a94,0x1
10009524:	7e 43                	jle    0x10009569
10009526:	ff 70 10             	push   DWORD PTR [eax+0x10]
10009529:	6a 00                	push   0x0
1000952b:	ff 35 a4 0b 01 10    	push   DWORD PTR ds:0x10010ba4
10009531:	ff 15 34 d0 00 10    	call   DWORD PTR ds:0x1000d034
10009537:	a1 94 0a 01 10       	mov    eax,ds:0x10010a94
1000953c:	8b 15 98 0a 01 10    	mov    edx,DWORD PTR ds:0x10010a98
10009542:	8d 04 80             	lea    eax,[eax+eax*4]
10009545:	c1 e0 02             	shl    eax,0x2
10009548:	8b c8                	mov    ecx,eax
1000954a:	a1 90 0a 01 10       	mov    eax,ds:0x10010a90
1000954f:	2b c8                	sub    ecx,eax
10009551:	8d 4c 11 ec          	lea    ecx,[ecx+edx*1-0x14]
10009555:	51                   	push   ecx
10009556:	8d 48 14             	lea    ecx,[eax+0x14]
10009559:	51                   	push   ecx
1000955a:	50                   	push   eax
1000955b:	e8 20 f0 ff ff       	call   0x10008580
10009560:	83 c4 0c             	add    esp,0xc
10009563:	ff 0d 94 0a 01 10    	dec    DWORD PTR ds:0x10010a94
10009569:	83 25 90 0a 01 10 00 	and    DWORD PTR ds:0x10010a90,0x0
10009570:	c3                   	ret
10009571:	55                   	push   ebp
10009572:	8b ec                	mov    ebp,esp
10009574:	81 ec 3c 01 00 00    	sub    esp,0x13c
1000957a:	a1 94 0a 01 10       	mov    eax,ds:0x10010a94
1000957f:	53                   	push   ebx
10009580:	56                   	push   esi
10009581:	57                   	push   edi
10009582:	8d 04 80             	lea    eax,[eax+eax*4]
10009585:	c1 e0 02             	shl    eax,0x2
10009588:	50                   	push   eax
10009589:	ff 35 98 0a 01 10    	push   DWORD PTR ds:0x10010a98
1000958f:	ff 15 88 d0 00 10    	call   DWORD PTR ds:0x1000d088
10009595:	85 c0                	test   eax,eax
10009597:	74 08                	je     0x100095a1
10009599:	83 c8 ff             	or     eax,0xffffffff
1000959c:	e9 bd 02 00 00       	jmp    0x1000985e
100095a1:	8b 1d 98 0a 01 10    	mov    ebx,DWORD PTR ds:0x10010a98
100095a7:	33 ff                	xor    edi,edi
100095a9:	39 3d 94 0a 01 10    	cmp    DWORD PTR ds:0x10010a94,edi
100095af:	89 5d c8             	mov    DWORD PTR [ebp-0x38],ebx
100095b2:	89 7d e0             	mov    DWORD PTR [ebp-0x20],edi
100095b5:	0f 8e a1 02 00 00    	jle    0x1000985c
100095bb:	eb 02                	jmp    0x100095bf
100095bd:	33 ff                	xor    edi,edi
100095bf:	8b 73 10             	mov    esi,DWORD PTR [ebx+0x10]
100095c2:	68 c4 41 00 00       	push   0x41c4
100095c7:	56                   	push   esi
100095c8:	ff 15 88 d0 00 10    	call   DWORD PTR ds:0x1000d088
100095ce:	85 c0                	test   eax,eax
100095d0:	0f 85 8d 02 00 00    	jne    0x10009863
100095d6:	8b 43 0c             	mov    eax,DWORD PTR [ebx+0xc]
100095d9:	89 7d d4             	mov    DWORD PTR [ebp-0x2c],edi
100095dc:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax
100095df:	8d 86 44 01 00 00    	lea    eax,[esi+0x144]
100095e5:	89 45 d8             	mov    DWORD PTR [ebp-0x28],eax
100095e8:	8b 43 08             	mov    eax,DWORD PTR [ebx+0x8]
100095eb:	81 c6 c4 00 00 00    	add    esi,0xc4
100095f1:	89 45 ec             	mov    DWORD PTR [ebp-0x14],eax
100095f4:	89 7d e8             	mov    DWORD PTR [ebp-0x18],edi
100095f7:	89 7d d0             	mov    DWORD PTR [ebp-0x30],edi
100095fa:	89 75 c4             	mov    DWORD PTR [ebp-0x3c],esi
100095fd:	eb 02                	jmp    0x10009601
100095ff:	33 ff                	xor    edi,edi
10009601:	6a 40                	push   0x40
10009603:	89 7d dc             	mov    DWORD PTR [ebp-0x24],edi
10009606:	89 7d e4             	mov    DWORD PTR [ebp-0x1c],edi
10009609:	89 7d fc             	mov    DWORD PTR [ebp-0x4],edi
1000960c:	33 c0                	xor    eax,eax
1000960e:	59                   	pop    ecx
1000960f:	39 45 ec             	cmp    DWORD PTR [ebp-0x14],eax
10009612:	8d bd c4 fe ff ff    	lea    edi,[ebp-0x13c]
10009618:	f3 ab                	rep stos DWORD PTR es:[edi],eax
1000961a:	0f 8c da 01 00 00    	jl     0x100097fa
10009620:	68 00 80 00 00       	push   0x8000
10009625:	ff 75 f4             	push   DWORD PTR [ebp-0xc]
10009628:	ff 15 88 d0 00 10    	call   DWORD PTR ds:0x1000d088
1000962e:	85 c0                	test   eax,eax
10009630:	0f 85 31 02 00 00    	jne    0x10009867
10009636:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
10009639:	33 db                	xor    ebx,ebx
1000963b:	8d 90 fc 0f 00 00    	lea    edx,[eax+0xffc]
10009641:	83 ba 0c f0 ff ff ff 	cmp    DWORD PTR [edx-0xff4],0xffffffff
10009648:	8d b2 10 f0 ff ff    	lea    esi,[edx-0xff0]
1000964e:	0f 85 23 02 00 00    	jne    0x10009877
10009654:	83 3a ff             	cmp    DWORD PTR [edx],0xffffffff
10009657:	0f 85 1a 02 00 00    	jne    0x10009877
1000965d:	8b 0e                	mov    ecx,DWORD PTR [esi]
1000965f:	f6 c1 01             	test   cl,0x1
10009662:	8b f9                	mov    edi,ecx
10009664:	74 12                	je     0x10009678
10009666:	49                   	dec    ecx
10009667:	81 f9 00 04 00 00    	cmp    ecx,0x400
1000966d:	0f 8f f8 01 00 00    	jg     0x1000986b
10009673:	ff 45 fc             	inc    DWORD PTR [ebp-0x4]
10009676:	eb 1c                	jmp    0x10009694
10009678:	8b c1                	mov    eax,ecx
1000967a:	c1 f8 04             	sar    eax,0x4
1000967d:	48                   	dec    eax
1000967e:	83 f8 3f             	cmp    eax,0x3f
10009681:	7e 03                	jle    0x10009686
10009683:	6a 3f                	push   0x3f
10009685:	58                   	pop    eax
10009686:	ff 84 85 c4 fe ff ff 	inc    DWORD PTR [ebp+eax*4-0x13c]
1000968d:	8d 84 85 c4 fe ff ff 	lea    eax,[ebp+eax*4-0x13c]
10009694:	83 f9 10             	cmp    ecx,0x10
10009697:	0f 8c d6 01 00 00    	jl     0x10009873
1000969d:	f6 c1 0f             	test   cl,0xf
100096a0:	0f 85 cd 01 00 00    	jne    0x10009873
100096a6:	81 f9 f0 0f 00 00    	cmp    ecx,0xff0
100096ac:	0f 8f c1 01 00 00    	jg     0x10009873
100096b2:	39 7c 31 fc          	cmp    DWORD PTR [ecx+esi*1-0x4],edi
100096b6:	8d 04 31             	lea    eax,[ecx+esi*1]
100096b9:	0f 85 b0 01 00 00    	jne    0x1000986f
100096bf:	8b f0                	mov    esi,eax
100096c1:	3b f2                	cmp    esi,edx
100096c3:	72 98                	jb     0x1000965d
100096c5:	0f 85 a4 01 00 00    	jne    0x1000986f
100096cb:	81 c2 00 10 00 00    	add    edx,0x1000
100096d1:	43                   	inc    ebx
100096d2:	83 fb 08             	cmp    ebx,0x8
100096d5:	0f 8c 66 ff ff ff    	jl     0x10009641
100096db:	8b 75 d8             	mov    esi,DWORD PTR [ebp-0x28]
100096de:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
100096e1:	39 06                	cmp    DWORD PTR [esi],eax
100096e3:	0f 85 92 01 00 00    	jne    0x1000987b
100096e9:	83 65 f8 00          	and    DWORD PTR [ebp-0x8],0x0
100096ed:	8d 85 c4 fe ff ff    	lea    eax,[ebp-0x13c]
100096f3:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
100096f6:	8b 46 04             	mov    eax,DWORD PTR [esi+0x4]
100096f9:	83 65 f0 00          	and    DWORD PTR [ebp-0x10],0x0
100096fd:	8d 7e 08             	lea    edi,[esi+0x8]
10009700:	8b d6                	mov    edx,esi
10009702:	3b c6                	cmp    eax,esi
10009704:	89 55 cc             	mov    DWORD PTR [ebp-0x34],edx
10009707:	0f 84 b5 00 00 00    	je     0x100097c2
1000970d:	8b 5d fc             	mov    ebx,DWORD PTR [ebp-0x4]
10009710:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
10009713:	3b 0b                	cmp    ecx,DWORD PTR [ebx]
10009715:	74 7e                	je     0x10009795
10009717:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
1000971a:	3b c1                	cmp    eax,ecx
1000971c:	0f 82 69 01 00 00    	jb     0x1000988b
10009722:	81 c1 00 80 00 00    	add    ecx,0x8000
10009728:	3b c1                	cmp    eax,ecx
1000972a:	0f 83 5b 01 00 00    	jae    0x1000988b
10009730:	8b c8                	mov    ecx,eax
10009732:	66 81 e1 00 f0       	and    cx,0xf000
10009737:	83 c1 0c             	add    ecx,0xc
1000973a:	8d 91 f0 0f 00 00    	lea    edx,[ecx+0xff0]
10009740:	3b ca                	cmp    ecx,edx
10009742:	0f 84 37 01 00 00    	je     0x1000987f
10009748:	3b c8                	cmp    ecx,eax
1000974a:	74 0b                	je     0x10009757
1000974c:	8b 19                	mov    ebx,DWORD PTR [ecx]
1000974e:	83 e3 fe             	and    ebx,0xfffffffe
10009751:	03 cb                	add    ecx,ebx
10009753:	3b ca                	cmp    ecx,edx
10009755:	75 f1                	jne    0x10009748
10009757:	3b ca                	cmp    ecx,edx
10009759:	0f 84 20 01 00 00    	je     0x1000987f
1000975f:	8b 08                	mov    ecx,DWORD PTR [eax]
10009761:	c1 f9 04             	sar    ecx,0x4
10009764:	49                   	dec    ecx
10009765:	83 f9 3f             	cmp    ecx,0x3f
10009768:	7e 03                	jle    0x1000976d
1000976a:	6a 3f                	push   0x3f
1000976c:	59                   	pop    ecx
1000976d:	3b 4d f8             	cmp    ecx,DWORD PTR [ebp-0x8]
10009770:	0f 85 0d 01 00 00    	jne    0x10009883
10009776:	8b 4d cc             	mov    ecx,DWORD PTR [ebp-0x34]
10009779:	39 48 08             	cmp    DWORD PTR [eax+0x8],ecx
1000977c:	0f 85 05 01 00 00    	jne    0x10009887
10009782:	ff 45 f0             	inc    DWORD PTR [ebp-0x10]
10009785:	8b d0                	mov    edx,eax
10009787:	8b 40 04             	mov    eax,DWORD PTR [eax+0x4]
1000978a:	89 55 cc             	mov    DWORD PTR [ebp-0x34],edx
1000978d:	3b c6                	cmp    eax,esi
1000978f:	0f 85 78 ff ff ff    	jne    0x1000970d
10009795:	83 7d f0 00          	cmp    DWORD PTR [ebp-0x10],0x0
10009799:	74 27                	je     0x100097c2
1000979b:	8b 4d f8             	mov    ecx,DWORD PTR [ebp-0x8]
1000979e:	83 f9 20             	cmp    ecx,0x20
100097a1:	7d 0f                	jge    0x100097b2
100097a3:	b8 00 00 00 80       	mov    eax,0x80000000
100097a8:	d3 e8                	shr    eax,cl
100097aa:	09 45 dc             	or     DWORD PTR [ebp-0x24],eax
100097ad:	09 45 d4             	or     DWORD PTR [ebp-0x2c],eax
100097b0:	eb 10                	jmp    0x100097c2
100097b2:	83 c1 e0             	add    ecx,0xffffffe0
100097b5:	b8 00 00 00 80       	mov    eax,0x80000000
100097ba:	d3 e8                	shr    eax,cl
100097bc:	09 45 e4             	or     DWORD PTR [ebp-0x1c],eax
100097bf:	09 45 e8             	or     DWORD PTR [ebp-0x18],eax
100097c2:	39 72 04             	cmp    DWORD PTR [edx+0x4],esi
100097c5:	0f 85 c8 00 00 00    	jne    0x10009893
100097cb:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
100097ce:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
100097d1:	3b 01                	cmp    eax,DWORD PTR [ecx]
100097d3:	0f 85 ba 00 00 00    	jne    0x10009893
100097d9:	39 17                	cmp    DWORD PTR [edi],edx
100097db:	0f 85 ae 00 00 00    	jne    0x1000988f
100097e1:	ff 45 f8             	inc    DWORD PTR [ebp-0x8]
100097e4:	83 45 fc 04          	add    DWORD PTR [ebp-0x4],0x4
100097e8:	83 7d f8 40          	cmp    DWORD PTR [ebp-0x8],0x40
100097ec:	8b f7                	mov    esi,edi
100097ee:	0f 8c 02 ff ff ff    	jl     0x100096f6
100097f4:	8b 75 c4             	mov    esi,DWORD PTR [ebp-0x3c]
100097f7:	8b 5d c8             	mov    ebx,DWORD PTR [ebp-0x38]
100097fa:	8b 45 dc             	mov    eax,DWORD PTR [ebp-0x24]
100097fd:	3b 46 80             	cmp    eax,DWORD PTR [esi-0x80]
10009800:	0f 85 91 00 00 00    	jne    0x10009897
10009806:	8b 45 e4             	mov    eax,DWORD PTR [ebp-0x1c]
10009809:	3b 06                	cmp    eax,DWORD PTR [esi]
1000980b:	0f 85 86 00 00 00    	jne    0x10009897
10009811:	81 45 f4 00 80 00 00 	add    DWORD PTR [ebp-0xc],0x8000
10009818:	81 45 d8 04 02 00 00 	add    DWORD PTR [ebp-0x28],0x204
1000981f:	d1 65 ec             	shl    DWORD PTR [ebp-0x14],1
10009822:	ff 45 d0             	inc    DWORD PTR [ebp-0x30]
10009825:	83 c6 04             	add    esi,0x4
10009828:	83 7d d0 20          	cmp    DWORD PTR [ebp-0x30],0x20
1000982c:	89 75 c4             	mov    DWORD PTR [ebp-0x3c],esi
1000982f:	0f 8c ca fd ff ff    	jl     0x100095ff
10009835:	8b 45 d4             	mov    eax,DWORD PTR [ebp-0x2c]
10009838:	3b 03                	cmp    eax,DWORD PTR [ebx]
1000983a:	75 5f                	jne    0x1000989b
1000983c:	8b 45 e8             	mov    eax,DWORD PTR [ebp-0x18]
1000983f:	3b 43 04             	cmp    eax,DWORD PTR [ebx+0x4]
10009842:	75 57                	jne    0x1000989b
10009844:	83 c3 14             	add    ebx,0x14
10009847:	ff 45 e0             	inc    DWORD PTR [ebp-0x20]
1000984a:	8b 45 e0             	mov    eax,DWORD PTR [ebp-0x20]
1000984d:	89 5d c8             	mov    DWORD PTR [ebp-0x38],ebx
10009850:	3b 05 94 0a 01 10    	cmp    eax,DWORD PTR ds:0x10010a94
10009856:	0f 8c 61 fd ff ff    	jl     0x100095bd
1000985c:	33 c0                	xor    eax,eax
1000985e:	5f                   	pop    edi
1000985f:	5e                   	pop    esi
10009860:	5b                   	pop    ebx
10009861:	c9                   	leave
10009862:	c3                   	ret
10009863:	6a fe                	push   0xfffffffe
10009865:	eb 36                	jmp    0x1000989d
10009867:	6a fc                	push   0xfffffffc
10009869:	eb 32                	jmp    0x1000989d
1000986b:	6a fa                	push   0xfffffffa
1000986d:	eb 2e                	jmp    0x1000989d
1000986f:	6a f8                	push   0xfffffff8
10009871:	eb 2a                	jmp    0x1000989d
10009873:	6a f9                	push   0xfffffff9
10009875:	eb 26                	jmp    0x1000989d
10009877:	6a fb                	push   0xfffffffb
10009879:	eb 22                	jmp    0x1000989d
1000987b:	6a f7                	push   0xfffffff7
1000987d:	eb 1e                	jmp    0x1000989d
1000987f:	6a f5                	push   0xfffffff5
10009881:	eb 1a                	jmp    0x1000989d
10009883:	6a f4                	push   0xfffffff4
10009885:	eb 16                	jmp    0x1000989d
10009887:	6a f3                	push   0xfffffff3
10009889:	eb 12                	jmp    0x1000989d
1000988b:	6a f6                	push   0xfffffff6
1000988d:	eb 0e                	jmp    0x1000989d
1000988f:	6a f1                	push   0xfffffff1
10009891:	eb 0a                	jmp    0x1000989d
10009893:	6a f2                	push   0xfffffff2
10009895:	eb 06                	jmp    0x1000989d
10009897:	6a f0                	push   0xfffffff0
10009899:	eb 02                	jmp    0x1000989d
1000989b:	6a ef                	push   0xffffffef
1000989d:	58                   	pop    eax
1000989e:	eb be                	jmp    0x1000985e
100098a0:	8b 4c 24 04          	mov    ecx,DWORD PTR [esp+0x4]
100098a4:	a1 dc f7 00 10       	mov    eax,ds:0x1000f7dc
100098a9:	89 0d dc f7 00 10    	mov    DWORD PTR ds:0x1000f7dc,ecx
100098af:	c3                   	ret
100098b0:	a1 dc f7 00 10       	mov    eax,ds:0x1000f7dc
100098b5:	c3                   	ret
100098b6:	a1 dc f7 00 10       	mov    eax,ds:0x1000f7dc
100098bb:	85 c0                	test   eax,eax
100098bd:	74 0f                	je     0x100098ce
100098bf:	ff 74 24 04          	push   DWORD PTR [esp+0x4]
100098c3:	ff d0                	call   eax
100098c5:	85 c0                	test   eax,eax
100098c7:	59                   	pop    ecx
100098c8:	74 04                	je     0x100098ce
100098ca:	6a 01                	push   0x1
100098cc:	58                   	pop    eax
100098cd:	c3                   	ret
100098ce:	33 c0                	xor    eax,eax
100098d0:	c3                   	ret
100098d1:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
100098d5:	53                   	push   ebx
100098d6:	3b 05 a0 0b 01 10    	cmp    eax,DWORD PTR ds:0x10010ba0
100098dc:	56                   	push   esi
100098dd:	57                   	push   edi
100098de:	73 73                	jae    0x10009953
100098e0:	8b c8                	mov    ecx,eax
100098e2:	8b f0                	mov    esi,eax
100098e4:	c1 f9 05             	sar    ecx,0x5
100098e7:	83 e6 1f             	and    esi,0x1f
100098ea:	8d 3c 8d a0 0a 01 10 	lea    edi,[ecx*4+0x10010aa0]
100098f1:	c1 e6 03             	shl    esi,0x3
100098f4:	8b 0f                	mov    ecx,DWORD PTR [edi]
100098f6:	f6 44 31 04 01       	test   BYTE PTR [ecx+esi*1+0x4],0x1
100098fb:	74 56                	je     0x10009953
100098fd:	50                   	push   eax
100098fe:	e8 cc 1f 00 00       	call   0x1000b8cf
10009903:	83 f8 ff             	cmp    eax,0xffffffff
10009906:	59                   	pop    ecx
10009907:	75 0c                	jne    0x10009915
10009909:	c7 05 4c f6 00 10 09 	mov    DWORD PTR ds:0x1000f64c,0x9
10009910:	00 00 00 
10009913:	eb 4f                	jmp    0x10009964
10009915:	ff 74 24 18          	push   DWORD PTR [esp+0x18]
10009919:	6a 00                	push   0x0
1000991b:	ff 74 24 1c          	push   DWORD PTR [esp+0x1c]
1000991f:	50                   	push   eax
10009920:	ff 15 90 d0 00 10    	call   DWORD PTR ds:0x1000d090
10009926:	8b d8                	mov    ebx,eax
10009928:	83 fb ff             	cmp    ebx,0xffffffff
1000992b:	75 08                	jne    0x10009935
1000992d:	ff 15 8c d0 00 10    	call   DWORD PTR ds:0x1000d08c
10009933:	eb 02                	jmp    0x10009937
10009935:	33 c0                	xor    eax,eax
10009937:	85 c0                	test   eax,eax
10009939:	74 09                	je     0x10009944
1000993b:	50                   	push   eax
1000993c:	e8 a1 1d 00 00       	call   0x1000b6e2
10009941:	59                   	pop    ecx
10009942:	eb 20                	jmp    0x10009964
10009944:	8b 07                	mov    eax,DWORD PTR [edi]
10009946:	80 64 30 04 fd       	and    BYTE PTR [eax+esi*1+0x4],0xfd
1000994b:	8d 44 30 04          	lea    eax,[eax+esi*1+0x4]
1000994f:	8b c3                	mov    eax,ebx
10009951:	eb 14                	jmp    0x10009967
10009953:	83 25 50 f6 00 10 00 	and    DWORD PTR ds:0x1000f650,0x0
1000995a:	c7 05 4c f6 00 10 09 	mov    DWORD PTR ds:0x1000f64c,0x9
10009961:	00 00 00 
10009964:	83 c8 ff             	or     eax,0xffffffff
10009967:	5f                   	pop    edi
10009968:	5e                   	pop    esi
10009969:	5b                   	pop    ebx
1000996a:	c3                   	ret
1000996b:	55                   	push   ebp
1000996c:	8b ec                	mov    ebp,esp
1000996e:	81 ec 14 04 00 00    	sub    esp,0x414
10009974:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
10009977:	53                   	push   ebx
10009978:	3b 0d a0 0b 01 10    	cmp    ecx,DWORD PTR ds:0x10010ba0
1000997e:	56                   	push   esi
1000997f:	57                   	push   edi
10009980:	0f 83 79 01 00 00    	jae    0x10009aff
10009986:	8b c1                	mov    eax,ecx
10009988:	8b f1                	mov    esi,ecx
1000998a:	c1 f8 05             	sar    eax,0x5
1000998d:	83 e6 1f             	and    esi,0x1f
10009990:	8d 1c 85 a0 0a 01 10 	lea    ebx,[eax*4+0x10010aa0]
10009997:	c1 e6 03             	shl    esi,0x3
1000999a:	8b 03                	mov    eax,DWORD PTR [ebx]
1000999c:	8a 44 30 04          	mov    al,BYTE PTR [eax+esi*1+0x4]
100099a0:	a8 01                	test   al,0x1
100099a2:	0f 84 57 01 00 00    	je     0x10009aff
100099a8:	33 ff                	xor    edi,edi
100099aa:	39 7d 10             	cmp    DWORD PTR [ebp+0x10],edi
100099ad:	89 7d f8             	mov    DWORD PTR [ebp-0x8],edi
100099b0:	89 7d f0             	mov    DWORD PTR [ebp-0x10],edi
100099b3:	75 07                	jne    0x100099bc
100099b5:	33 c0                	xor    eax,eax
100099b7:	e9 57 01 00 00       	jmp    0x10009b13
100099bc:	a8 20                	test   al,0x20
100099be:	74 0c                	je     0x100099cc
100099c0:	6a 02                	push   0x2
100099c2:	57                   	push   edi
100099c3:	51                   	push   ecx
100099c4:	e8 08 ff ff ff       	call   0x100098d1
100099c9:	83 c4 0c             	add    esp,0xc
100099cc:	8b 03                	mov    eax,DWORD PTR [ebx]
100099ce:	03 c6                	add    eax,esi
100099d0:	f6 40 04 80          	test   BYTE PTR [eax+0x4],0x80
100099d4:	0f 84 c1 00 00 00    	je     0x10009a9b
100099da:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
100099dd:	39 7d 10             	cmp    DWORD PTR [ebp+0x10],edi
100099e0:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
100099e3:	89 7d 08             	mov    DWORD PTR [ebp+0x8],edi
100099e6:	0f 86 e7 00 00 00    	jbe    0x10009ad3
100099ec:	8d 85 ec fb ff ff    	lea    eax,[ebp-0x414]
100099f2:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
100099f5:	2b 4d 0c             	sub    ecx,DWORD PTR [ebp+0xc]
100099f8:	3b 4d 10             	cmp    ecx,DWORD PTR [ebp+0x10]
100099fb:	73 29                	jae    0x10009a26
100099fd:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
10009a00:	ff 45 fc             	inc    DWORD PTR [ebp-0x4]
10009a03:	8a 09                	mov    cl,BYTE PTR [ecx]
10009a05:	80 f9 0a             	cmp    cl,0xa
10009a08:	75 07                	jne    0x10009a11
10009a0a:	ff 45 f0             	inc    DWORD PTR [ebp-0x10]
10009a0d:	c6 00 0d             	mov    BYTE PTR [eax],0xd
10009a10:	40                   	inc    eax
10009a11:	88 08                	mov    BYTE PTR [eax],cl
10009a13:	40                   	inc    eax
10009a14:	8b c8                	mov    ecx,eax
10009a16:	8d 95 ec fb ff ff    	lea    edx,[ebp-0x414]
10009a1c:	2b ca                	sub    ecx,edx
10009a1e:	81 f9 00 04 00 00    	cmp    ecx,0x400
10009a24:	7c cc                	jl     0x100099f2
10009a26:	8b f8                	mov    edi,eax
10009a28:	8d 85 ec fb ff ff    	lea    eax,[ebp-0x414]
10009a2e:	2b f8                	sub    edi,eax
10009a30:	8d 45 f4             	lea    eax,[ebp-0xc]
10009a33:	6a 00                	push   0x0
10009a35:	50                   	push   eax
10009a36:	8d 85 ec fb ff ff    	lea    eax,[ebp-0x414]
10009a3c:	57                   	push   edi
10009a3d:	50                   	push   eax
10009a3e:	8b 03                	mov    eax,DWORD PTR [ebx]
10009a40:	ff 34 30             	push   DWORD PTR [eax+esi*1]
10009a43:	ff 15 7c d0 00 10    	call   DWORD PTR ds:0x1000d07c
10009a49:	85 c0                	test   eax,eax
10009a4b:	74 43                	je     0x10009a90
10009a4d:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
10009a50:	01 45 f8             	add    DWORD PTR [ebp-0x8],eax
10009a53:	3b c7                	cmp    eax,edi
10009a55:	7c 0b                	jl     0x10009a62
10009a57:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
10009a5a:	2b 45 0c             	sub    eax,DWORD PTR [ebp+0xc]
10009a5d:	3b 45 10             	cmp    eax,DWORD PTR [ebp+0x10]
10009a60:	72 8a                	jb     0x100099ec
10009a62:	33 ff                	xor    edi,edi
10009a64:	8b 45 f8             	mov    eax,DWORD PTR [ebp-0x8]
10009a67:	3b c7                	cmp    eax,edi
10009a69:	0f 85 8b 00 00 00    	jne    0x10009afa
10009a6f:	39 7d 08             	cmp    DWORD PTR [ebp+0x8],edi
10009a72:	74 5f                	je     0x10009ad3
10009a74:	6a 05                	push   0x5
10009a76:	58                   	pop    eax
10009a77:	39 45 08             	cmp    DWORD PTR [ebp+0x8],eax
10009a7a:	75 4c                	jne    0x10009ac8
10009a7c:	c7 05 4c f6 00 10 09 	mov    DWORD PTR ds:0x1000f64c,0x9
10009a83:	00 00 00 
10009a86:	a3 50 f6 00 10       	mov    ds:0x1000f650,eax
10009a8b:	e9 80 00 00 00       	jmp    0x10009b10
10009a90:	ff 15 8c d0 00 10    	call   DWORD PTR ds:0x1000d08c
10009a96:	89 45 08             	mov    DWORD PTR [ebp+0x8],eax
10009a99:	eb c7                	jmp    0x10009a62
10009a9b:	8d 4d f4             	lea    ecx,[ebp-0xc]
10009a9e:	57                   	push   edi
10009a9f:	51                   	push   ecx
10009aa0:	ff 75 10             	push   DWORD PTR [ebp+0x10]
10009aa3:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
10009aa6:	ff 30                	push   DWORD PTR [eax]
10009aa8:	ff 15 7c d0 00 10    	call   DWORD PTR ds:0x1000d07c
10009aae:	85 c0                	test   eax,eax
10009ab0:	74 0b                	je     0x10009abd
10009ab2:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
10009ab5:	89 7d 08             	mov    DWORD PTR [ebp+0x8],edi
10009ab8:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
10009abb:	eb a7                	jmp    0x10009a64
10009abd:	ff 15 8c d0 00 10    	call   DWORD PTR ds:0x1000d08c
10009ac3:	89 45 08             	mov    DWORD PTR [ebp+0x8],eax
10009ac6:	eb 9c                	jmp    0x10009a64
10009ac8:	ff 75 08             	push   DWORD PTR [ebp+0x8]
10009acb:	e8 12 1c 00 00       	call   0x1000b6e2
10009ad0:	59                   	pop    ecx
10009ad1:	eb 3d                	jmp    0x10009b10
10009ad3:	8b 03                	mov    eax,DWORD PTR [ebx]
10009ad5:	f6 44 30 04 40       	test   BYTE PTR [eax+esi*1+0x4],0x40
10009ada:	74 0c                	je     0x10009ae8
10009adc:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
10009adf:	80 38 1a             	cmp    BYTE PTR [eax],0x1a
10009ae2:	0f 84 cd fe ff ff    	je     0x100099b5
10009ae8:	c7 05 4c f6 00 10 1c 	mov    DWORD PTR ds:0x1000f64c,0x1c
10009aef:	00 00 00 
10009af2:	89 3d 50 f6 00 10    	mov    DWORD PTR ds:0x1000f650,edi
10009af8:	eb 16                	jmp    0x10009b10
10009afa:	2b 45 f0             	sub    eax,DWORD PTR [ebp-0x10]
10009afd:	eb 14                	jmp    0x10009b13
10009aff:	83 25 50 f6 00 10 00 	and    DWORD PTR ds:0x1000f650,0x0
10009b06:	c7 05 4c f6 00 10 09 	mov    DWORD PTR ds:0x1000f64c,0x9
10009b0d:	00 00 00 
10009b10:	83 c8 ff             	or     eax,0xffffffff
10009b13:	5f                   	pop    edi
10009b14:	5e                   	pop    esi
10009b15:	5b                   	pop    ebx
10009b16:	c9                   	leave
10009b17:	c3                   	ret
10009b18:	ff 05 e0 f7 00 10    	inc    DWORD PTR ds:0x1000f7e0
10009b1e:	68 00 10 00 00       	push   0x1000
10009b23:	e8 31 c3 ff ff       	call   0x10005e59
10009b28:	59                   	pop    ecx
10009b29:	8b 4c 24 04          	mov    ecx,DWORD PTR [esp+0x4]
10009b2d:	85 c0                	test   eax,eax
10009b2f:	89 41 08             	mov    DWORD PTR [ecx+0x8],eax
10009b32:	74 0d                	je     0x10009b41
10009b34:	83 49 0c 08          	or     DWORD PTR [ecx+0xc],0x8
10009b38:	c7 41 18 00 10 00 00 	mov    DWORD PTR [ecx+0x18],0x1000
10009b3f:	eb 11                	jmp    0x10009b52
10009b41:	83 49 0c 04          	or     DWORD PTR [ecx+0xc],0x4
10009b45:	8d 41 14             	lea    eax,[ecx+0x14]
10009b48:	89 41 08             	mov    DWORD PTR [ecx+0x8],eax
10009b4b:	c7 41 18 02 00 00 00 	mov    DWORD PTR [ecx+0x18],0x2
10009b52:	8b 41 08             	mov    eax,DWORD PTR [ecx+0x8]
10009b55:	83 61 04 00          	and    DWORD PTR [ecx+0x4],0x0
10009b59:	89 01                	mov    DWORD PTR [ecx],eax
10009b5b:	c3                   	ret
10009b5c:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
10009b60:	3b 05 a0 0b 01 10    	cmp    eax,DWORD PTR ds:0x10010ba0
10009b66:	72 03                	jb     0x10009b6b
10009b68:	33 c0                	xor    eax,eax
10009b6a:	c3                   	ret
10009b6b:	8b c8                	mov    ecx,eax
10009b6d:	83 e0 1f             	and    eax,0x1f
10009b70:	c1 f9 05             	sar    ecx,0x5
10009b73:	8b 0c 8d a0 0a 01 10 	mov    ecx,DWORD PTR [ecx*4+0x10010aa0]
10009b7a:	8a 44 c1 04          	mov    al,BYTE PTR [ecx+eax*8+0x4]
10009b7e:	83 e0 40             	and    eax,0x40
10009b81:	c3                   	ret
10009b82:	a1 80 0a 01 10       	mov    eax,ds:0x10010a80
10009b87:	56                   	push   esi
10009b88:	6a 14                	push   0x14
10009b8a:	85 c0                	test   eax,eax
10009b8c:	5e                   	pop    esi
10009b8d:	75 07                	jne    0x10009b96
10009b8f:	b8 00 02 00 00       	mov    eax,0x200
10009b94:	eb 06                	jmp    0x10009b9c
10009b96:	3b c6                	cmp    eax,esi
10009b98:	7d 07                	jge    0x10009ba1
10009b9a:	8b c6                	mov    eax,esi
10009b9c:	a3 80 0a 01 10       	mov    ds:0x10010a80,eax
10009ba1:	6a 04                	push   0x4
10009ba3:	50                   	push   eax
10009ba4:	e8 00 1e 00 00       	call   0x1000b9a9
10009ba9:	59                   	pop    ecx
10009baa:	a3 68 fa 00 10       	mov    ds:0x1000fa68,eax
10009baf:	85 c0                	test   eax,eax
10009bb1:	59                   	pop    ecx
10009bb2:	75 21                	jne    0x10009bd5
10009bb4:	6a 04                	push   0x4
10009bb6:	56                   	push   esi
10009bb7:	89 35 80 0a 01 10    	mov    DWORD PTR ds:0x10010a80,esi
10009bbd:	e8 e7 1d 00 00       	call   0x1000b9a9
10009bc2:	59                   	pop    ecx
10009bc3:	a3 68 fa 00 10       	mov    ds:0x1000fa68,eax
10009bc8:	85 c0                	test   eax,eax
10009bca:	59                   	pop    ecx
10009bcb:	75 08                	jne    0x10009bd5
10009bcd:	6a 1a                	push   0x1a
10009bcf:	e8 6f bd ff ff       	call   0x10005943
10009bd4:	59                   	pop    ecx
10009bd5:	33 c9                	xor    ecx,ecx
10009bd7:	b8 78 ed 00 10       	mov    eax,0x1000ed78
10009bdc:	8b 15 68 fa 00 10    	mov    edx,DWORD PTR ds:0x1000fa68
10009be2:	89 04 11             	mov    DWORD PTR [ecx+edx*1],eax
10009be5:	83 c0 20             	add    eax,0x20
10009be8:	83 c1 04             	add    ecx,0x4
10009beb:	3d f8 ef 00 10       	cmp    eax,0x1000eff8
10009bf0:	7c ea                	jl     0x10009bdc
10009bf2:	33 d2                	xor    edx,edx
10009bf4:	b9 88 ed 00 10       	mov    ecx,0x1000ed88
10009bf9:	8b c2                	mov    eax,edx
10009bfb:	8b f2                	mov    esi,edx
10009bfd:	c1 f8 05             	sar    eax,0x5
10009c00:	83 e6 1f             	and    esi,0x1f
10009c03:	8b 04 85 a0 0a 01 10 	mov    eax,DWORD PTR [eax*4+0x10010aa0]
10009c0a:	8b 04 f0             	mov    eax,DWORD PTR [eax+esi*8]
10009c0d:	83 f8 ff             	cmp    eax,0xffffffff
10009c10:	74 04                	je     0x10009c16
10009c12:	85 c0                	test   eax,eax
10009c14:	75 03                	jne    0x10009c19
10009c16:	83 09 ff             	or     DWORD PTR [ecx],0xffffffff
10009c19:	83 c1 20             	add    ecx,0x20
10009c1c:	42                   	inc    edx
10009c1d:	81 f9 e8 ed 00 10    	cmp    ecx,0x1000ede8
10009c23:	7c d4                	jl     0x10009bf9
10009c25:	5e                   	pop    esi
10009c26:	c3                   	ret
10009c27:	e8 e9 1e 00 00       	call   0x1000bb15
10009c2c:	80 3d 8c f6 00 10 00 	cmp    BYTE PTR ds:0x1000f68c,0x0
10009c33:	74 05                	je     0x10009c3a
10009c35:	e9 ec 1d 00 00       	jmp    0x1000ba26
10009c3a:	c3                   	ret
10009c3b:	55                   	push   ebp
10009c3c:	8b ec                	mov    ebp,esp
10009c3e:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10009c41:	85 c0                	test   eax,eax
10009c43:	75 02                	jne    0x10009c47
10009c45:	5d                   	pop    ebp
10009c46:	c3                   	ret
10009c47:	83 3d 0c f8 00 10 00 	cmp    DWORD PTR ds:0x1000f80c,0x0
10009c4e:	75 12                	jne    0x10009c62
10009c50:	66 8b 4d 0c          	mov    cx,WORD PTR [ebp+0xc]
10009c54:	66 81 f9 ff 00       	cmp    cx,0xff
10009c59:	77 39                	ja     0x10009c94
10009c5b:	6a 01                	push   0x1
10009c5d:	88 08                	mov    BYTE PTR [eax],cl
10009c5f:	58                   	pop    eax
10009c60:	5d                   	pop    ebp
10009c61:	c3                   	ret
10009c62:	8d 4d 08             	lea    ecx,[ebp+0x8]
10009c65:	83 65 08 00          	and    DWORD PTR [ebp+0x8],0x0
10009c69:	51                   	push   ecx
10009c6a:	6a 00                	push   0x0
10009c6c:	ff 35 94 ec 00 10    	push   DWORD PTR ds:0x1000ec94
10009c72:	50                   	push   eax
10009c73:	8d 45 0c             	lea    eax,[ebp+0xc]
10009c76:	6a 01                	push   0x1
10009c78:	50                   	push   eax
10009c79:	68 20 02 00 00       	push   0x220
10009c7e:	ff 35 1c f8 00 10    	push   DWORD PTR ds:0x1000f81c
10009c84:	ff 15 70 d0 00 10    	call   DWORD PTR ds:0x1000d070
10009c8a:	85 c0                	test   eax,eax
10009c8c:	74 06                	je     0x10009c94
10009c8e:	83 7d 08 00          	cmp    DWORD PTR [ebp+0x8],0x0
10009c92:	74 0d                	je     0x10009ca1
10009c94:	c7 05 4c f6 00 10 2a 	mov    DWORD PTR ds:0x1000f64c,0x2a
10009c9b:	00 00 00 
10009c9e:	83 c8 ff             	or     eax,0xffffffff
10009ca1:	5d                   	pop    ebp
10009ca2:	c3                   	ret
10009ca3:	cc                   	int3
10009ca4:	cc                   	int3
10009ca5:	cc                   	int3
10009ca6:	cc                   	int3
10009ca7:	cc                   	int3
10009ca8:	cc                   	int3
10009ca9:	cc                   	int3
10009caa:	cc                   	int3
10009cab:	cc                   	int3
10009cac:	cc                   	int3
10009cad:	cc                   	int3
10009cae:	cc                   	int3
10009caf:	cc                   	int3
10009cb0:	53                   	push   ebx
10009cb1:	56                   	push   esi
10009cb2:	8b 44 24 18          	mov    eax,DWORD PTR [esp+0x18]
10009cb6:	0b c0                	or     eax,eax
10009cb8:	75 18                	jne    0x10009cd2
10009cba:	8b 4c 24 14          	mov    ecx,DWORD PTR [esp+0x14]
10009cbe:	8b 44 24 10          	mov    eax,DWORD PTR [esp+0x10]
10009cc2:	33 d2                	xor    edx,edx
10009cc4:	f7 f1                	div    ecx
10009cc6:	8b d8                	mov    ebx,eax
10009cc8:	8b 44 24 0c          	mov    eax,DWORD PTR [esp+0xc]
10009ccc:	f7 f1                	div    ecx
10009cce:	8b d3                	mov    edx,ebx
10009cd0:	eb 41                	jmp    0x10009d13
10009cd2:	8b c8                	mov    ecx,eax
10009cd4:	8b 5c 24 14          	mov    ebx,DWORD PTR [esp+0x14]
10009cd8:	8b 54 24 10          	mov    edx,DWORD PTR [esp+0x10]
10009cdc:	8b 44 24 0c          	mov    eax,DWORD PTR [esp+0xc]
10009ce0:	d1 e9                	shr    ecx,1
10009ce2:	d1 db                	rcr    ebx,1
10009ce4:	d1 ea                	shr    edx,1
10009ce6:	d1 d8                	rcr    eax,1
10009ce8:	0b c9                	or     ecx,ecx
10009cea:	75 f4                	jne    0x10009ce0
10009cec:	f7 f3                	div    ebx
10009cee:	8b f0                	mov    esi,eax
10009cf0:	f7 64 24 18          	mul    DWORD PTR [esp+0x18]
10009cf4:	8b c8                	mov    ecx,eax
10009cf6:	8b 44 24 14          	mov    eax,DWORD PTR [esp+0x14]
10009cfa:	f7 e6                	mul    esi
10009cfc:	03 d1                	add    edx,ecx
10009cfe:	72 0e                	jb     0x10009d0e
10009d00:	3b 54 24 10          	cmp    edx,DWORD PTR [esp+0x10]
10009d04:	77 08                	ja     0x10009d0e
10009d06:	72 07                	jb     0x10009d0f
10009d08:	3b 44 24 0c          	cmp    eax,DWORD PTR [esp+0xc]
10009d0c:	76 01                	jbe    0x10009d0f
10009d0e:	4e                   	dec    esi
10009d0f:	33 d2                	xor    edx,edx
10009d11:	8b c6                	mov    eax,esi
10009d13:	5e                   	pop    esi
10009d14:	5b                   	pop    ebx
10009d15:	c2 10 00             	ret    0x10
10009d18:	cc                   	int3
10009d19:	cc                   	int3
10009d1a:	cc                   	int3
10009d1b:	cc                   	int3
10009d1c:	cc                   	int3
10009d1d:	cc                   	int3
10009d1e:	cc                   	int3
10009d1f:	cc                   	int3
10009d20:	53                   	push   ebx
10009d21:	8b 44 24 14          	mov    eax,DWORD PTR [esp+0x14]
10009d25:	0b c0                	or     eax,eax
10009d27:	75 18                	jne    0x10009d41
10009d29:	8b 4c 24 10          	mov    ecx,DWORD PTR [esp+0x10]
10009d2d:	8b 44 24 0c          	mov    eax,DWORD PTR [esp+0xc]
10009d31:	33 d2                	xor    edx,edx
10009d33:	f7 f1                	div    ecx
10009d35:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
10009d39:	f7 f1                	div    ecx
10009d3b:	8b c2                	mov    eax,edx
10009d3d:	33 d2                	xor    edx,edx
10009d3f:	eb 50                	jmp    0x10009d91
10009d41:	8b c8                	mov    ecx,eax
10009d43:	8b 5c 24 10          	mov    ebx,DWORD PTR [esp+0x10]
10009d47:	8b 54 24 0c          	mov    edx,DWORD PTR [esp+0xc]
10009d4b:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
10009d4f:	d1 e9                	shr    ecx,1
10009d51:	d1 db                	rcr    ebx,1
10009d53:	d1 ea                	shr    edx,1
10009d55:	d1 d8                	rcr    eax,1
10009d57:	0b c9                	or     ecx,ecx
10009d59:	75 f4                	jne    0x10009d4f
10009d5b:	f7 f3                	div    ebx
10009d5d:	8b c8                	mov    ecx,eax
10009d5f:	f7 64 24 14          	mul    DWORD PTR [esp+0x14]
10009d63:	91                   	xchg   ecx,eax
10009d64:	f7 64 24 10          	mul    DWORD PTR [esp+0x10]
10009d68:	03 d1                	add    edx,ecx
10009d6a:	72 0e                	jb     0x10009d7a
10009d6c:	3b 54 24 0c          	cmp    edx,DWORD PTR [esp+0xc]
10009d70:	77 08                	ja     0x10009d7a
10009d72:	72 0e                	jb     0x10009d82
10009d74:	3b 44 24 08          	cmp    eax,DWORD PTR [esp+0x8]
10009d78:	76 08                	jbe    0x10009d82
10009d7a:	2b 44 24 10          	sub    eax,DWORD PTR [esp+0x10]
10009d7e:	1b 54 24 14          	sbb    edx,DWORD PTR [esp+0x14]
10009d82:	2b 44 24 08          	sub    eax,DWORD PTR [esp+0x8]
10009d86:	1b 54 24 0c          	sbb    edx,DWORD PTR [esp+0xc]
10009d8a:	f7 da                	neg    edx
10009d8c:	f7 d8                	neg    eax
10009d8e:	83 da 00             	sbb    edx,0x0
10009d91:	5b                   	pop    ebx
10009d92:	c2 10 00             	ret    0x10
10009d95:	56                   	push   esi
10009d96:	8b 74 24 08          	mov    esi,DWORD PTR [esp+0x8]
10009d9a:	8b 06                	mov    eax,DWORD PTR [esi]
10009d9c:	81 38 63 73 6d e0    	cmp    DWORD PTR [eax],0xe06d7363
10009da2:	75 14                	jne    0x10009db8
10009da4:	83 78 10 03          	cmp    DWORD PTR [eax+0x10],0x3
10009da8:	75 0e                	jne    0x10009db8
10009daa:	81 78 14 20 05 93 19 	cmp    DWORD PTR [eax+0x14],0x19930520
10009db1:	75 05                	jne    0x10009db8
10009db3:	e9 84 d2 ff ff       	jmp    0x1000703c
10009db8:	a1 e4 f7 00 10       	mov    eax,ds:0x1000f7e4
10009dbd:	85 c0                	test   eax,eax
10009dbf:	74 14                	je     0x10009dd5
10009dc1:	50                   	push   eax
10009dc2:	e8 6a 00 00 00       	call   0x10009e31
10009dc7:	85 c0                	test   eax,eax
10009dc9:	59                   	pop    ecx
10009dca:	74 09                	je     0x10009dd5
10009dcc:	56                   	push   esi
10009dcd:	ff 15 e4 f7 00 10    	call   DWORD PTR ds:0x1000f7e4
10009dd3:	eb 02                	jmp    0x10009dd7
10009dd5:	33 c0                	xor    eax,eax
10009dd7:	5e                   	pop    esi
10009dd8:	c2 04 00             	ret    0x4
10009ddb:	68 95 9d 00 10       	push   0x10009d95
10009de0:	ff 15 94 d0 00 10    	call   DWORD PTR ds:0x1000d094
10009de6:	a3 e4 f7 00 10       	mov    ds:0x1000f7e4,eax
10009deb:	c3                   	ret
10009dec:	ff 35 e4 f7 00 10    	push   DWORD PTR ds:0x1000f7e4
10009df2:	ff 15 94 d0 00 10    	call   DWORD PTR ds:0x1000d094
10009df8:	c3                   	ret
10009df9:	56                   	push   esi
10009dfa:	6a 01                	push   0x1
10009dfc:	5e                   	pop    esi
10009dfd:	ff 74 24 0c          	push   DWORD PTR [esp+0xc]
10009e01:	ff 74 24 0c          	push   DWORD PTR [esp+0xc]
10009e05:	ff 15 98 d0 00 10    	call   DWORD PTR ds:0x1000d098
10009e0b:	85 c0                	test   eax,eax
10009e0d:	74 02                	je     0x10009e11
10009e0f:	33 f6                	xor    esi,esi
10009e11:	8b c6                	mov    eax,esi
10009e13:	5e                   	pop    esi
10009e14:	c3                   	ret
10009e15:	56                   	push   esi
10009e16:	6a 01                	push   0x1
10009e18:	5e                   	pop    esi
10009e19:	ff 74 24 0c          	push   DWORD PTR [esp+0xc]
10009e1d:	ff 74 24 0c          	push   DWORD PTR [esp+0xc]
10009e21:	ff 15 88 d0 00 10    	call   DWORD PTR ds:0x1000d088
10009e27:	85 c0                	test   eax,eax
10009e29:	74 02                	je     0x10009e2d
10009e2b:	33 f6                	xor    esi,esi
10009e2d:	8b c6                	mov    eax,esi
10009e2f:	5e                   	pop    esi
10009e30:	c3                   	ret
10009e31:	56                   	push   esi
10009e32:	6a 01                	push   0x1
10009e34:	5e                   	pop    esi
10009e35:	ff 74 24 08          	push   DWORD PTR [esp+0x8]
10009e39:	ff 15 9c d0 00 10    	call   DWORD PTR ds:0x1000d09c
10009e3f:	85 c0                	test   eax,eax
10009e41:	74 02                	je     0x10009e45
10009e43:	33 f6                	xor    esi,esi
10009e45:	8b c6                	mov    eax,esi
10009e47:	5e                   	pop    esi
10009e48:	c3                   	ret
10009e49:	cc                   	int3
10009e4a:	cc                   	int3
10009e4b:	cc                   	int3
10009e4c:	cc                   	int3
10009e4d:	cc                   	int3
10009e4e:	cc                   	int3
10009e4f:	cc                   	int3
10009e50:	8b 54 24 04          	mov    edx,DWORD PTR [esp+0x4]
10009e54:	8b 4c 24 08          	mov    ecx,DWORD PTR [esp+0x8]
10009e58:	f7 c2 03 00 00 00    	test   edx,0x3
10009e5e:	75 3c                	jne    0x10009e9c
10009e60:	8b 02                	mov    eax,DWORD PTR [edx]
10009e62:	3a 01                	cmp    al,BYTE PTR [ecx]
10009e64:	75 2e                	jne    0x10009e94
10009e66:	0a c0                	or     al,al
10009e68:	74 26                	je     0x10009e90
10009e6a:	3a 61 01             	cmp    ah,BYTE PTR [ecx+0x1]
10009e6d:	75 25                	jne    0x10009e94
10009e6f:	0a e4                	or     ah,ah
10009e71:	74 1d                	je     0x10009e90
10009e73:	c1 e8 10             	shr    eax,0x10
10009e76:	3a 41 02             	cmp    al,BYTE PTR [ecx+0x2]
10009e79:	75 19                	jne    0x10009e94
10009e7b:	0a c0                	or     al,al
10009e7d:	74 11                	je     0x10009e90
10009e7f:	3a 61 03             	cmp    ah,BYTE PTR [ecx+0x3]
10009e82:	75 10                	jne    0x10009e94
10009e84:	83 c1 04             	add    ecx,0x4
10009e87:	83 c2 04             	add    edx,0x4
10009e8a:	0a e4                	or     ah,ah
10009e8c:	75 d2                	jne    0x10009e60
10009e8e:	8b ff                	mov    edi,edi
10009e90:	33 c0                	xor    eax,eax
10009e92:	c3                   	ret
10009e93:	90                   	nop
10009e94:	1b c0                	sbb    eax,eax
10009e96:	d1 e0                	shl    eax,1
10009e98:	40                   	inc    eax
10009e99:	c3                   	ret
10009e9a:	8b ff                	mov    edi,edi
10009e9c:	f7 c2 01 00 00 00    	test   edx,0x1
10009ea2:	74 14                	je     0x10009eb8
10009ea4:	8a 02                	mov    al,BYTE PTR [edx]
10009ea6:	42                   	inc    edx
10009ea7:	3a 01                	cmp    al,BYTE PTR [ecx]
10009ea9:	75 e9                	jne    0x10009e94
10009eab:	41                   	inc    ecx
10009eac:	0a c0                	or     al,al
10009eae:	74 e0                	je     0x10009e90
10009eb0:	f7 c2 02 00 00 00    	test   edx,0x2
10009eb6:	74 a8                	je     0x10009e60
10009eb8:	66 8b 02             	mov    ax,WORD PTR [edx]
10009ebb:	83 c2 02             	add    edx,0x2
10009ebe:	3a 01                	cmp    al,BYTE PTR [ecx]
10009ec0:	75 d2                	jne    0x10009e94
10009ec2:	0a c0                	or     al,al
10009ec4:	74 ca                	je     0x10009e90
10009ec6:	3a 61 01             	cmp    ah,BYTE PTR [ecx+0x1]
10009ec9:	75 c9                	jne    0x10009e94
10009ecb:	0a e4                	or     ah,ah
10009ecd:	74 c1                	je     0x10009e90
10009ecf:	83 c1 02             	add    ecx,0x2
10009ed2:	eb 8c                	jmp    0x10009e60
10009ed4:	56                   	push   esi
10009ed5:	43                   	inc    ebx
10009ed6:	32 30                	xor    dh,BYTE PTR [eax]
10009ed8:	58                   	pop    eax
10009ed9:	43                   	inc    ebx
10009eda:	30 30                	xor    BYTE PTR [eax],dh
10009edc:	55                   	push   ebp
10009edd:	8b ec                	mov    ebp,esp
10009edf:	83 ec 08             	sub    esp,0x8
10009ee2:	53                   	push   ebx
10009ee3:	56                   	push   esi
10009ee4:	57                   	push   edi
10009ee5:	55                   	push   ebp
10009ee6:	fc                   	cld
10009ee7:	8b 5d 0c             	mov    ebx,DWORD PTR [ebp+0xc]
10009eea:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
10009eed:	f7 40 04 06 00 00 00 	test   DWORD PTR [eax+0x4],0x6
10009ef4:	0f 85 82 00 00 00    	jne    0x10009f7c
10009efa:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
10009efd:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
10009f00:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
10009f03:	8d 45 f8             	lea    eax,[ebp-0x8]
10009f06:	89 43 fc             	mov    DWORD PTR [ebx-0x4],eax
10009f09:	8b 73 0c             	mov    esi,DWORD PTR [ebx+0xc]
10009f0c:	8b 7b 08             	mov    edi,DWORD PTR [ebx+0x8]
10009f0f:	83 fe ff             	cmp    esi,0xffffffff
10009f12:	74 61                	je     0x10009f75
10009f14:	8d 0c 76             	lea    ecx,[esi+esi*2]
10009f17:	83 7c 8f 04 00       	cmp    DWORD PTR [edi+ecx*4+0x4],0x0
10009f1c:	74 45                	je     0x10009f63
10009f1e:	56                   	push   esi
10009f1f:	55                   	push   ebp
10009f20:	8d 6b 10             	lea    ebp,[ebx+0x10]
10009f23:	ff 54 8f 04          	call   DWORD PTR [edi+ecx*4+0x4]
10009f27:	5d                   	pop    ebp
10009f28:	5e                   	pop    esi
10009f29:	8b 5d 0c             	mov    ebx,DWORD PTR [ebp+0xc]
10009f2c:	0b c0                	or     eax,eax
10009f2e:	74 33                	je     0x10009f63
10009f30:	78 3c                	js     0x10009f6e
10009f32:	8b 7b 08             	mov    edi,DWORD PTR [ebx+0x8]
10009f35:	53                   	push   ebx
10009f36:	e8 cd b5 ff ff       	call   0x10005508
10009f3b:	83 c4 04             	add    esp,0x4
10009f3e:	8d 6b 10             	lea    ebp,[ebx+0x10]
10009f41:	56                   	push   esi
10009f42:	53                   	push   ebx
10009f43:	e8 02 b6 ff ff       	call   0x1000554a
10009f48:	83 c4 08             	add    esp,0x8
10009f4b:	8d 0c 76             	lea    ecx,[esi+esi*2]
10009f4e:	6a 01                	push   0x1
10009f50:	8b 44 8f 08          	mov    eax,DWORD PTR [edi+ecx*4+0x8]
10009f54:	e8 85 b6 ff ff       	call   0x100055de
10009f59:	8b 04 8f             	mov    eax,DWORD PTR [edi+ecx*4]
10009f5c:	89 43 0c             	mov    DWORD PTR [ebx+0xc],eax
10009f5f:	ff 54 8f 08          	call   DWORD PTR [edi+ecx*4+0x8]
10009f63:	8b 7b 08             	mov    edi,DWORD PTR [ebx+0x8]
10009f66:	8d 0c 76             	lea    ecx,[esi+esi*2]
10009f69:	8b 34 8f             	mov    esi,DWORD PTR [edi+ecx*4]
10009f6c:	eb a1                	jmp    0x10009f0f
10009f6e:	b8 00 00 00 00       	mov    eax,0x0
10009f73:	eb 1c                	jmp    0x10009f91
10009f75:	b8 01 00 00 00       	mov    eax,0x1
10009f7a:	eb 15                	jmp    0x10009f91
10009f7c:	55                   	push   ebp
10009f7d:	8d 6b 10             	lea    ebp,[ebx+0x10]
10009f80:	6a ff                	push   0xffffffff
10009f82:	53                   	push   ebx
10009f83:	e8 c2 b5 ff ff       	call   0x1000554a
10009f88:	83 c4 08             	add    esp,0x8
10009f8b:	5d                   	pop    ebp
10009f8c:	b8 01 00 00 00       	mov    eax,0x1
10009f91:	5d                   	pop    ebp
10009f92:	5f                   	pop    edi
10009f93:	5e                   	pop    esi
10009f94:	5b                   	pop    ebx
10009f95:	8b e5                	mov    esp,ebp
10009f97:	5d                   	pop    ebp
10009f98:	c3                   	ret
10009f99:	55                   	push   ebp
10009f9a:	8b 4c 24 08          	mov    ecx,DWORD PTR [esp+0x8]
10009f9e:	8b 29                	mov    ebp,DWORD PTR [ecx]
10009fa0:	8b 41 1c             	mov    eax,DWORD PTR [ecx+0x1c]
10009fa3:	50                   	push   eax
10009fa4:	8b 41 18             	mov    eax,DWORD PTR [ecx+0x18]
10009fa7:	50                   	push   eax
10009fa8:	e8 9d b5 ff ff       	call   0x1000554a
10009fad:	83 c4 08             	add    esp,0x8
10009fb0:	5d                   	pop    ebp
10009fb1:	c2 04 00             	ret    0x4
10009fb4:	6a 0a                	push   0xa
10009fb6:	e8 f9 d9 ff ff       	call   0x100079b4
10009fbb:	6a 16                	push   0x16
10009fbd:	e8 0d 1d 00 00       	call   0x1000bccf
10009fc2:	59                   	pop    ecx
10009fc3:	59                   	pop    ecx
10009fc4:	6a 03                	push   0x3
10009fc6:	e8 17 d2 ff ff       	call   0x100071e2
10009fcb:	55                   	push   ebp
10009fcc:	8b ec                	mov    ebp,esp
10009fce:	6a ff                	push   0xffffffff
10009fd0:	68 98 d5 00 10       	push   0x1000d598
10009fd5:	68 dc 9e 00 10       	push   0x10009edc
10009fda:	64 a1 00 00 00 00    	mov    eax,fs:0x0
10009fe0:	50                   	push   eax
10009fe1:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
10009fe8:	83 ec 18             	sub    esp,0x18
10009feb:	53                   	push   ebx
10009fec:	56                   	push   esi
10009fed:	57                   	push   edi
10009fee:	89 65 e8             	mov    DWORD PTR [ebp-0x18],esp
10009ff1:	a1 e8 f7 00 10       	mov    eax,ds:0x1000f7e8
10009ff6:	33 db                	xor    ebx,ebx
10009ff8:	3b c3                	cmp    eax,ebx
10009ffa:	75 3e                	jne    0x1000a03a
10009ffc:	8d 45 e4             	lea    eax,[ebp-0x1c]
10009fff:	50                   	push   eax
1000a000:	6a 01                	push   0x1
1000a002:	5e                   	pop    esi
1000a003:	56                   	push   esi
1000a004:	68 94 d5 00 10       	push   0x1000d594
1000a009:	56                   	push   esi
1000a00a:	ff 15 a8 d0 00 10    	call   DWORD PTR ds:0x1000d0a8
1000a010:	85 c0                	test   eax,eax
1000a012:	74 04                	je     0x1000a018
1000a014:	8b c6                	mov    eax,esi
1000a016:	eb 1d                	jmp    0x1000a035
1000a018:	8d 45 e4             	lea    eax,[ebp-0x1c]
1000a01b:	50                   	push   eax
1000a01c:	56                   	push   esi
1000a01d:	68 90 d5 00 10       	push   0x1000d590
1000a022:	56                   	push   esi
1000a023:	53                   	push   ebx
1000a024:	ff 15 a4 d0 00 10    	call   DWORD PTR ds:0x1000d0a4
1000a02a:	85 c0                	test   eax,eax
1000a02c:	0f 84 ce 00 00 00    	je     0x1000a100
1000a032:	6a 02                	push   0x2
1000a034:	58                   	pop    eax
1000a035:	a3 e8 f7 00 10       	mov    ds:0x1000f7e8,eax
1000a03a:	83 f8 02             	cmp    eax,0x2
1000a03d:	75 24                	jne    0x1000a063
1000a03f:	8b 45 1c             	mov    eax,DWORD PTR [ebp+0x1c]
1000a042:	3b c3                	cmp    eax,ebx
1000a044:	75 05                	jne    0x1000a04b
1000a046:	a1 0c f8 00 10       	mov    eax,ds:0x1000f80c
1000a04b:	ff 75 14             	push   DWORD PTR [ebp+0x14]
1000a04e:	ff 75 10             	push   DWORD PTR [ebp+0x10]
1000a051:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
1000a054:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000a057:	50                   	push   eax
1000a058:	ff 15 a4 d0 00 10    	call   DWORD PTR ds:0x1000d0a4
1000a05e:	e9 9f 00 00 00       	jmp    0x1000a102
1000a063:	83 f8 01             	cmp    eax,0x1
1000a066:	0f 85 94 00 00 00    	jne    0x1000a100
1000a06c:	39 5d 18             	cmp    DWORD PTR [ebp+0x18],ebx
1000a06f:	75 08                	jne    0x1000a079
1000a071:	a1 1c f8 00 10       	mov    eax,ds:0x1000f81c
1000a076:	89 45 18             	mov    DWORD PTR [ebp+0x18],eax
1000a079:	53                   	push   ebx
1000a07a:	53                   	push   ebx
1000a07b:	ff 75 10             	push   DWORD PTR [ebp+0x10]
1000a07e:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
1000a081:	8b 45 20             	mov    eax,DWORD PTR [ebp+0x20]
1000a084:	f7 d8                	neg    eax
1000a086:	1b c0                	sbb    eax,eax
1000a088:	83 e0 08             	and    eax,0x8
1000a08b:	40                   	inc    eax
1000a08c:	50                   	push   eax
1000a08d:	ff 75 18             	push   DWORD PTR [ebp+0x18]
1000a090:	ff 15 a0 d0 00 10    	call   DWORD PTR ds:0x1000d0a0
1000a096:	89 45 e0             	mov    DWORD PTR [ebp-0x20],eax
1000a099:	3b c3                	cmp    eax,ebx
1000a09b:	74 63                	je     0x1000a100
1000a09d:	89 5d fc             	mov    DWORD PTR [ebp-0x4],ebx
1000a0a0:	8d 3c 00             	lea    edi,[eax+eax*1]
1000a0a3:	8b c7                	mov    eax,edi
1000a0a5:	83 c0 03             	add    eax,0x3
1000a0a8:	24 fc                	and    al,0xfc
1000a0aa:	e8 51 b5 ff ff       	call   0x10005600
1000a0af:	89 65 e8             	mov    DWORD PTR [ebp-0x18],esp
1000a0b2:	8b f4                	mov    esi,esp
1000a0b4:	89 75 dc             	mov    DWORD PTR [ebp-0x24],esi
1000a0b7:	57                   	push   edi
1000a0b8:	53                   	push   ebx
1000a0b9:	56                   	push   esi
1000a0ba:	e8 61 e4 ff ff       	call   0x10008520
1000a0bf:	83 c4 0c             	add    esp,0xc
1000a0c2:	eb 0b                	jmp    0x1000a0cf
1000a0c4:	6a 01                	push   0x1
1000a0c6:	58                   	pop    eax
1000a0c7:	c3                   	ret
1000a0c8:	8b 65 e8             	mov    esp,DWORD PTR [ebp-0x18]
1000a0cb:	33 db                	xor    ebx,ebx
1000a0cd:	33 f6                	xor    esi,esi
1000a0cf:	83 4d fc ff          	or     DWORD PTR [ebp-0x4],0xffffffff
1000a0d3:	3b f3                	cmp    esi,ebx
1000a0d5:	74 29                	je     0x1000a100
1000a0d7:	ff 75 e0             	push   DWORD PTR [ebp-0x20]
1000a0da:	56                   	push   esi
1000a0db:	ff 75 10             	push   DWORD PTR [ebp+0x10]
1000a0de:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
1000a0e1:	6a 01                	push   0x1
1000a0e3:	ff 75 18             	push   DWORD PTR [ebp+0x18]
1000a0e6:	ff 15 a0 d0 00 10    	call   DWORD PTR ds:0x1000d0a0
1000a0ec:	3b c3                	cmp    eax,ebx
1000a0ee:	74 10                	je     0x1000a100
1000a0f0:	ff 75 14             	push   DWORD PTR [ebp+0x14]
1000a0f3:	50                   	push   eax
1000a0f4:	56                   	push   esi
1000a0f5:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000a0f8:	ff 15 a8 d0 00 10    	call   DWORD PTR ds:0x1000d0a8
1000a0fe:	eb 02                	jmp    0x1000a102
1000a100:	33 c0                	xor    eax,eax
1000a102:	8d 65 cc             	lea    esp,[ebp-0x34]
1000a105:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
1000a108:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
1000a10f:	5f                   	pop    edi
1000a110:	5e                   	pop    esi
1000a111:	5b                   	pop    ebx
1000a112:	c9                   	leave
1000a113:	c3                   	ret
1000a114:	55                   	push   ebp
1000a115:	8b ec                	mov    ebp,esp
1000a117:	83 ec 18             	sub    esp,0x18
1000a11a:	53                   	push   ebx
1000a11b:	56                   	push   esi
1000a11c:	57                   	push   edi
1000a11d:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000a120:	e8 88 01 00 00       	call   0x1000a2ad
1000a125:	8b f0                	mov    esi,eax
1000a127:	59                   	pop    ecx
1000a128:	3b 35 38 f8 00 10    	cmp    esi,DWORD PTR ds:0x1000f838
1000a12e:	89 75 08             	mov    DWORD PTR [ebp+0x8],esi
1000a131:	0f 84 6a 01 00 00    	je     0x1000a2a1
1000a137:	33 db                	xor    ebx,ebx
1000a139:	3b f3                	cmp    esi,ebx
1000a13b:	0f 84 56 01 00 00    	je     0x1000a297
1000a141:	33 d2                	xor    edx,edx
1000a143:	b8 08 f0 00 10       	mov    eax,0x1000f008
1000a148:	39 30                	cmp    DWORD PTR [eax],esi
1000a14a:	74 72                	je     0x1000a1be
1000a14c:	83 c0 30             	add    eax,0x30
1000a14f:	42                   	inc    edx
1000a150:	3d f8 f0 00 10       	cmp    eax,0x1000f0f8
1000a155:	7c f1                	jl     0x1000a148
1000a157:	8d 45 e8             	lea    eax,[ebp-0x18]
1000a15a:	50                   	push   eax
1000a15b:	56                   	push   esi
1000a15c:	ff 15 ac d0 00 10    	call   DWORD PTR ds:0x1000d0ac
1000a162:	83 f8 01             	cmp    eax,0x1
1000a165:	0f 85 24 01 00 00    	jne    0x1000a28f
1000a16b:	6a 40                	push   0x40
1000a16d:	33 c0                	xor    eax,eax
1000a16f:	59                   	pop    ecx
1000a170:	bf 60 f9 00 10       	mov    edi,0x1000f960
1000a175:	83 7d e8 01          	cmp    DWORD PTR [ebp-0x18],0x1
1000a179:	89 35 38 f8 00 10    	mov    DWORD PTR ds:0x1000f838,esi
1000a17f:	f3 ab                	rep stos DWORD PTR es:[edi],eax
1000a181:	aa                   	stos   BYTE PTR es:[edi],al
1000a182:	89 1d 64 fa 00 10    	mov    DWORD PTR ds:0x1000fa64,ebx
1000a188:	0f 86 ef 00 00 00    	jbe    0x1000a27d
1000a18e:	80 7d ee 00          	cmp    BYTE PTR [ebp-0x12],0x0
1000a192:	0f 84 bb 00 00 00    	je     0x1000a253
1000a198:	8d 4d ef             	lea    ecx,[ebp-0x11]
1000a19b:	8a 11                	mov    dl,BYTE PTR [ecx]
1000a19d:	84 d2                	test   dl,dl
1000a19f:	0f 84 ae 00 00 00    	je     0x1000a253
1000a1a5:	0f b6 41 ff          	movzx  eax,BYTE PTR [ecx-0x1]
1000a1a9:	0f b6 d2             	movzx  edx,dl
1000a1ac:	3b c2                	cmp    eax,edx
1000a1ae:	0f 87 93 00 00 00    	ja     0x1000a247
1000a1b4:	80 88 61 f9 00 10 04 	or     BYTE PTR [eax+0x1000f961],0x4
1000a1bb:	40                   	inc    eax
1000a1bc:	eb ee                	jmp    0x1000a1ac
1000a1be:	6a 40                	push   0x40
1000a1c0:	33 c0                	xor    eax,eax
1000a1c2:	59                   	pop    ecx
1000a1c3:	bf 60 f9 00 10       	mov    edi,0x1000f960
1000a1c8:	f3 ab                	rep stos DWORD PTR es:[edi],eax
1000a1ca:	8d 34 52             	lea    esi,[edx+edx*2]
1000a1cd:	89 5d fc             	mov    DWORD PTR [ebp-0x4],ebx
1000a1d0:	c1 e6 04             	shl    esi,0x4
1000a1d3:	aa                   	stos   BYTE PTR es:[edi],al
1000a1d4:	8d 9e 18 f0 00 10    	lea    ebx,[esi+0x1000f018]
1000a1da:	80 3b 00             	cmp    BYTE PTR [ebx],0x0
1000a1dd:	8b cb                	mov    ecx,ebx
1000a1df:	74 2c                	je     0x1000a20d
1000a1e1:	8a 51 01             	mov    dl,BYTE PTR [ecx+0x1]
1000a1e4:	84 d2                	test   dl,dl
1000a1e6:	74 25                	je     0x1000a20d
1000a1e8:	0f b6 01             	movzx  eax,BYTE PTR [ecx]
1000a1eb:	0f b6 fa             	movzx  edi,dl
1000a1ee:	3b c7                	cmp    eax,edi
1000a1f0:	77 14                	ja     0x1000a206
1000a1f2:	8b 55 fc             	mov    edx,DWORD PTR [ebp-0x4]
1000a1f5:	8a 92 00 f0 00 10    	mov    dl,BYTE PTR [edx+0x1000f000]
1000a1fb:	08 90 61 f9 00 10    	or     BYTE PTR [eax+0x1000f961],dl
1000a201:	40                   	inc    eax
1000a202:	3b c7                	cmp    eax,edi
1000a204:	76 f5                	jbe    0x1000a1fb
1000a206:	41                   	inc    ecx
1000a207:	41                   	inc    ecx
1000a208:	80 39 00             	cmp    BYTE PTR [ecx],0x0
1000a20b:	75 d4                	jne    0x1000a1e1
1000a20d:	ff 45 fc             	inc    DWORD PTR [ebp-0x4]
1000a210:	83 c3 08             	add    ebx,0x8
1000a213:	83 7d fc 04          	cmp    DWORD PTR [ebp-0x4],0x4
1000a217:	72 c1                	jb     0x1000a1da
1000a219:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000a21c:	c7 05 4c f8 00 10 01 	mov    DWORD PTR ds:0x1000f84c,0x1
1000a223:	00 00 00 
1000a226:	50                   	push   eax
1000a227:	a3 38 f8 00 10       	mov    ds:0x1000f838,eax
1000a22c:	e8 c6 00 00 00       	call   0x1000a2f7
1000a231:	8d b6 0c f0 00 10    	lea    esi,[esi+0x1000f00c]
1000a237:	bf 40 f8 00 10       	mov    edi,0x1000f840
1000a23c:	a5                   	movs   DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000a23d:	a5                   	movs   DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000a23e:	59                   	pop    ecx
1000a23f:	a3 64 fa 00 10       	mov    ds:0x1000fa64,eax
1000a244:	a5                   	movs   DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000a245:	eb 55                	jmp    0x1000a29c
1000a247:	41                   	inc    ecx
1000a248:	41                   	inc    ecx
1000a249:	80 79 ff 00          	cmp    BYTE PTR [ecx-0x1],0x0
1000a24d:	0f 85 48 ff ff ff    	jne    0x1000a19b
1000a253:	6a 01                	push   0x1
1000a255:	58                   	pop    eax
1000a256:	80 88 61 f9 00 10 08 	or     BYTE PTR [eax+0x1000f961],0x8
1000a25d:	40                   	inc    eax
1000a25e:	3d ff 00 00 00       	cmp    eax,0xff
1000a263:	72 f1                	jb     0x1000a256
1000a265:	56                   	push   esi
1000a266:	e8 8c 00 00 00       	call   0x1000a2f7
1000a26b:	59                   	pop    ecx
1000a26c:	a3 64 fa 00 10       	mov    ds:0x1000fa64,eax
1000a271:	c7 05 4c f8 00 10 01 	mov    DWORD PTR ds:0x1000f84c,0x1
1000a278:	00 00 00 
1000a27b:	eb 06                	jmp    0x1000a283
1000a27d:	89 1d 4c f8 00 10    	mov    DWORD PTR ds:0x1000f84c,ebx
1000a283:	33 c0                	xor    eax,eax
1000a285:	bf 40 f8 00 10       	mov    edi,0x1000f840
1000a28a:	ab                   	stos   DWORD PTR es:[edi],eax
1000a28b:	ab                   	stos   DWORD PTR es:[edi],eax
1000a28c:	ab                   	stos   DWORD PTR es:[edi],eax
1000a28d:	eb 0d                	jmp    0x1000a29c
1000a28f:	39 1d ec f7 00 10    	cmp    DWORD PTR ds:0x1000f7ec,ebx
1000a295:	74 0e                	je     0x1000a2a5
1000a297:	e8 8e 00 00 00       	call   0x1000a32a
1000a29c:	e8 b2 00 00 00       	call   0x1000a353
1000a2a1:	33 c0                	xor    eax,eax
1000a2a3:	eb 03                	jmp    0x1000a2a8
1000a2a5:	83 c8 ff             	or     eax,0xffffffff
1000a2a8:	5f                   	pop    edi
1000a2a9:	5e                   	pop    esi
1000a2aa:	5b                   	pop    ebx
1000a2ab:	c9                   	leave
1000a2ac:	c3                   	ret
1000a2ad:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
1000a2b1:	83 25 ec f7 00 10 00 	and    DWORD PTR ds:0x1000f7ec,0x0
1000a2b8:	83 f8 fe             	cmp    eax,0xfffffffe
1000a2bb:	75 10                	jne    0x1000a2cd
1000a2bd:	c7 05 ec f7 00 10 01 	mov    DWORD PTR ds:0x1000f7ec,0x1
1000a2c4:	00 00 00 
1000a2c7:	ff 25 b4 d0 00 10    	jmp    DWORD PTR ds:0x1000d0b4
1000a2cd:	83 f8 fd             	cmp    eax,0xfffffffd
1000a2d0:	75 10                	jne    0x1000a2e2
1000a2d2:	c7 05 ec f7 00 10 01 	mov    DWORD PTR ds:0x1000f7ec,0x1
1000a2d9:	00 00 00 
1000a2dc:	ff 25 b0 d0 00 10    	jmp    DWORD PTR ds:0x1000d0b0
1000a2e2:	83 f8 fc             	cmp    eax,0xfffffffc
1000a2e5:	75 0f                	jne    0x1000a2f6
1000a2e7:	a1 1c f8 00 10       	mov    eax,ds:0x1000f81c
1000a2ec:	c7 05 ec f7 00 10 01 	mov    DWORD PTR ds:0x1000f7ec,0x1
1000a2f3:	00 00 00 
1000a2f6:	c3                   	ret
1000a2f7:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
1000a2fb:	2d a4 03 00 00       	sub    eax,0x3a4
1000a300:	74 22                	je     0x1000a324
1000a302:	83 e8 04             	sub    eax,0x4
1000a305:	74 17                	je     0x1000a31e
1000a307:	83 e8 0d             	sub    eax,0xd
1000a30a:	74 0c                	je     0x1000a318
1000a30c:	48                   	dec    eax
1000a30d:	74 03                	je     0x1000a312
1000a30f:	33 c0                	xor    eax,eax
1000a311:	c3                   	ret
1000a312:	b8 04 04 00 00       	mov    eax,0x404
1000a317:	c3                   	ret
1000a318:	b8 12 04 00 00       	mov    eax,0x412
1000a31d:	c3                   	ret
1000a31e:	b8 04 08 00 00       	mov    eax,0x804
1000a323:	c3                   	ret
1000a324:	b8 11 04 00 00       	mov    eax,0x411
1000a329:	c3                   	ret
1000a32a:	57                   	push   edi
1000a32b:	6a 40                	push   0x40
1000a32d:	59                   	pop    ecx
1000a32e:	33 c0                	xor    eax,eax
1000a330:	bf 60 f9 00 10       	mov    edi,0x1000f960
1000a335:	f3 ab                	rep stos DWORD PTR es:[edi],eax
1000a337:	aa                   	stos   BYTE PTR es:[edi],al
1000a338:	33 c0                	xor    eax,eax
1000a33a:	bf 40 f8 00 10       	mov    edi,0x1000f840
1000a33f:	a3 38 f8 00 10       	mov    ds:0x1000f838,eax
1000a344:	a3 4c f8 00 10       	mov    ds:0x1000f84c,eax
1000a349:	a3 64 fa 00 10       	mov    ds:0x1000fa64,eax
1000a34e:	ab                   	stos   DWORD PTR es:[edi],eax
1000a34f:	ab                   	stos   DWORD PTR es:[edi],eax
1000a350:	ab                   	stos   DWORD PTR es:[edi],eax
1000a351:	5f                   	pop    edi
1000a352:	c3                   	ret
1000a353:	55                   	push   ebp
1000a354:	8b ec                	mov    ebp,esp
1000a356:	81 ec 14 05 00 00    	sub    esp,0x514
1000a35c:	8d 45 ec             	lea    eax,[ebp-0x14]
1000a35f:	56                   	push   esi
1000a360:	50                   	push   eax
1000a361:	ff 35 38 f8 00 10    	push   DWORD PTR ds:0x1000f838
1000a367:	ff 15 ac d0 00 10    	call   DWORD PTR ds:0x1000d0ac
1000a36d:	83 f8 01             	cmp    eax,0x1
1000a370:	0f 85 16 01 00 00    	jne    0x1000a48c
1000a376:	33 c0                	xor    eax,eax
1000a378:	be 00 01 00 00       	mov    esi,0x100
1000a37d:	88 84 05 ec fe ff ff 	mov    BYTE PTR [ebp+eax*1-0x114],al
1000a384:	40                   	inc    eax
1000a385:	3b c6                	cmp    eax,esi
1000a387:	72 f4                	jb     0x1000a37d
1000a389:	8a 45 f2             	mov    al,BYTE PTR [ebp-0xe]
1000a38c:	c6 85 ec fe ff ff 20 	mov    BYTE PTR [ebp-0x114],0x20
1000a393:	84 c0                	test   al,al
1000a395:	74 37                	je     0x1000a3ce
1000a397:	53                   	push   ebx
1000a398:	57                   	push   edi
1000a399:	8d 55 f3             	lea    edx,[ebp-0xd]
1000a39c:	0f b6 0a             	movzx  ecx,BYTE PTR [edx]
1000a39f:	0f b6 c0             	movzx  eax,al
1000a3a2:	3b c1                	cmp    eax,ecx
1000a3a4:	77 1d                	ja     0x1000a3c3
1000a3a6:	2b c8                	sub    ecx,eax
1000a3a8:	8d bc 05 ec fe ff ff 	lea    edi,[ebp+eax*1-0x114]
1000a3af:	41                   	inc    ecx
1000a3b0:	b8 20 20 20 20       	mov    eax,0x20202020
1000a3b5:	8b d9                	mov    ebx,ecx
1000a3b7:	c1 e9 02             	shr    ecx,0x2
1000a3ba:	f3 ab                	rep stos DWORD PTR es:[edi],eax
1000a3bc:	8b cb                	mov    ecx,ebx
1000a3be:	83 e1 03             	and    ecx,0x3
1000a3c1:	f3 aa                	rep stos BYTE PTR es:[edi],al
1000a3c3:	42                   	inc    edx
1000a3c4:	42                   	inc    edx
1000a3c5:	8a 42 ff             	mov    al,BYTE PTR [edx-0x1]
1000a3c8:	84 c0                	test   al,al
1000a3ca:	75 d0                	jne    0x1000a39c
1000a3cc:	5f                   	pop    edi
1000a3cd:	5b                   	pop    ebx
1000a3ce:	6a 00                	push   0x0
1000a3d0:	8d 85 ec fa ff ff    	lea    eax,[ebp-0x514]
1000a3d6:	ff 35 64 fa 00 10    	push   DWORD PTR ds:0x1000fa64
1000a3dc:	ff 35 38 f8 00 10    	push   DWORD PTR ds:0x1000f838
1000a3e2:	50                   	push   eax
1000a3e3:	8d 85 ec fe ff ff    	lea    eax,[ebp-0x114]
1000a3e9:	56                   	push   esi
1000a3ea:	50                   	push   eax
1000a3eb:	6a 01                	push   0x1
1000a3ed:	e8 d9 fb ff ff       	call   0x10009fcb
1000a3f2:	6a 00                	push   0x0
1000a3f4:	8d 85 ec fd ff ff    	lea    eax,[ebp-0x214]
1000a3fa:	ff 35 38 f8 00 10    	push   DWORD PTR ds:0x1000f838
1000a400:	56                   	push   esi
1000a401:	50                   	push   eax
1000a402:	8d 85 ec fe ff ff    	lea    eax,[ebp-0x114]
1000a408:	56                   	push   esi
1000a409:	50                   	push   eax
1000a40a:	56                   	push   esi
1000a40b:	ff 35 64 fa 00 10    	push   DWORD PTR ds:0x1000fa64
1000a411:	e8 3c 07 00 00       	call   0x1000ab52
1000a416:	6a 00                	push   0x0
1000a418:	8d 85 ec fc ff ff    	lea    eax,[ebp-0x314]
1000a41e:	ff 35 38 f8 00 10    	push   DWORD PTR ds:0x1000f838
1000a424:	56                   	push   esi
1000a425:	50                   	push   eax
1000a426:	8d 85 ec fe ff ff    	lea    eax,[ebp-0x114]
1000a42c:	56                   	push   esi
1000a42d:	50                   	push   eax
1000a42e:	68 00 02 00 00       	push   0x200
1000a433:	ff 35 64 fa 00 10    	push   DWORD PTR ds:0x1000fa64
1000a439:	e8 14 07 00 00       	call   0x1000ab52
1000a43e:	83 c4 5c             	add    esp,0x5c
1000a441:	33 c0                	xor    eax,eax
1000a443:	8d 8d ec fa ff ff    	lea    ecx,[ebp-0x514]
1000a449:	66 8b 11             	mov    dx,WORD PTR [ecx]
1000a44c:	f6 c2 01             	test   dl,0x1
1000a44f:	74 16                	je     0x1000a467
1000a451:	80 88 61 f9 00 10 10 	or     BYTE PTR [eax+0x1000f961],0x10
1000a458:	8a 94 05 ec fd ff ff 	mov    dl,BYTE PTR [ebp+eax*1-0x214]
1000a45f:	88 90 60 f8 00 10    	mov    BYTE PTR [eax+0x1000f860],dl
1000a465:	eb 1c                	jmp    0x1000a483
1000a467:	f6 c2 02             	test   dl,0x2
1000a46a:	74 10                	je     0x1000a47c
1000a46c:	80 88 61 f9 00 10 20 	or     BYTE PTR [eax+0x1000f961],0x20
1000a473:	8a 94 05 ec fc ff ff 	mov    dl,BYTE PTR [ebp+eax*1-0x314]
1000a47a:	eb e3                	jmp    0x1000a45f
1000a47c:	80 a0 60 f8 00 10 00 	and    BYTE PTR [eax+0x1000f860],0x0
1000a483:	40                   	inc    eax
1000a484:	41                   	inc    ecx
1000a485:	41                   	inc    ecx
1000a486:	3b c6                	cmp    eax,esi
1000a488:	72 bf                	jb     0x1000a449
1000a48a:	eb 49                	jmp    0x1000a4d5
1000a48c:	33 c0                	xor    eax,eax
1000a48e:	be 00 01 00 00       	mov    esi,0x100
1000a493:	83 f8 41             	cmp    eax,0x41
1000a496:	72 19                	jb     0x1000a4b1
1000a498:	83 f8 5a             	cmp    eax,0x5a
1000a49b:	77 14                	ja     0x1000a4b1
1000a49d:	80 88 61 f9 00 10 10 	or     BYTE PTR [eax+0x1000f961],0x10
1000a4a4:	8a c8                	mov    cl,al
1000a4a6:	80 c1 20             	add    cl,0x20
1000a4a9:	88 88 60 f8 00 10    	mov    BYTE PTR [eax+0x1000f860],cl
1000a4af:	eb 1f                	jmp    0x1000a4d0
1000a4b1:	83 f8 61             	cmp    eax,0x61
1000a4b4:	72 13                	jb     0x1000a4c9
1000a4b6:	83 f8 7a             	cmp    eax,0x7a
1000a4b9:	77 0e                	ja     0x1000a4c9
1000a4bb:	80 88 61 f9 00 10 20 	or     BYTE PTR [eax+0x1000f961],0x20
1000a4c2:	8a c8                	mov    cl,al
1000a4c4:	80 e9 20             	sub    cl,0x20
1000a4c7:	eb e0                	jmp    0x1000a4a9
1000a4c9:	80 a0 60 f8 00 10 00 	and    BYTE PTR [eax+0x1000f860],0x0
1000a4d0:	40                   	inc    eax
1000a4d1:	3b c6                	cmp    eax,esi
1000a4d3:	72 be                	jb     0x1000a493
1000a4d5:	5e                   	pop    esi
1000a4d6:	c9                   	leave
1000a4d7:	c3                   	ret
1000a4d8:	a1 4c f8 00 10       	mov    eax,ds:0x1000f84c
1000a4dd:	f7 d8                	neg    eax
1000a4df:	1b c0                	sbb    eax,eax
1000a4e1:	23 05 38 f8 00 10    	and    eax,DWORD PTR ds:0x1000f838
1000a4e7:	c3                   	ret
1000a4e8:	83 3d ac 0b 01 10 00 	cmp    DWORD PTR ds:0x10010bac,0x0
1000a4ef:	75 12                	jne    0x1000a503
1000a4f1:	6a fd                	push   0xfffffffd
1000a4f3:	e8 1c fc ff ff       	call   0x1000a114
1000a4f8:	59                   	pop    ecx
1000a4f9:	c7 05 ac 0b 01 10 01 	mov    DWORD PTR ds:0x10010bac,0x1
1000a500:	00 00 00 
1000a503:	c3                   	ret
1000a504:	cc                   	int3
1000a505:	cc                   	int3
1000a506:	cc                   	int3
1000a507:	cc                   	int3
1000a508:	cc                   	int3
1000a509:	cc                   	int3
1000a50a:	cc                   	int3
1000a50b:	cc                   	int3
1000a50c:	cc                   	int3
1000a50d:	cc                   	int3
1000a50e:	cc                   	int3
1000a50f:	cc                   	int3
1000a510:	55                   	push   ebp
1000a511:	8b ec                	mov    ebp,esp
1000a513:	57                   	push   edi
1000a514:	56                   	push   esi
1000a515:	8b 75 0c             	mov    esi,DWORD PTR [ebp+0xc]
1000a518:	8b 4d 10             	mov    ecx,DWORD PTR [ebp+0x10]
1000a51b:	8b 7d 08             	mov    edi,DWORD PTR [ebp+0x8]
1000a51e:	8b c1                	mov    eax,ecx
1000a520:	8b d1                	mov    edx,ecx
1000a522:	03 c6                	add    eax,esi
1000a524:	3b fe                	cmp    edi,esi
1000a526:	76 08                	jbe    0x1000a530
1000a528:	3b f8                	cmp    edi,eax
1000a52a:	0f 82 78 01 00 00    	jb     0x1000a6a8
1000a530:	f7 c7 03 00 00 00    	test   edi,0x3
1000a536:	75 14                	jne    0x1000a54c
1000a538:	c1 e9 02             	shr    ecx,0x2
1000a53b:	83 e2 03             	and    edx,0x3
1000a53e:	83 f9 08             	cmp    ecx,0x8
1000a541:	72 29                	jb     0x1000a56c
1000a543:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000a545:	ff 24 95 58 a6 00 10 	jmp    DWORD PTR [edx*4+0x1000a658]
1000a54c:	8b c7                	mov    eax,edi
1000a54e:	ba 03 00 00 00       	mov    edx,0x3
1000a553:	83 e9 04             	sub    ecx,0x4
1000a556:	72 0c                	jb     0x1000a564
1000a558:	83 e0 03             	and    eax,0x3
1000a55b:	03 c8                	add    ecx,eax
1000a55d:	ff 24 85 70 a5 00 10 	jmp    DWORD PTR [eax*4+0x1000a570]
1000a564:	ff 24 8d 68 a6 00 10 	jmp    DWORD PTR [ecx*4+0x1000a668]
1000a56b:	90                   	nop
1000a56c:	ff 24 8d ec a5 00 10 	jmp    DWORD PTR [ecx*4+0x1000a5ec]
1000a573:	90                   	nop
1000a574:	80 a5 00 10 ac a5 00 	and    BYTE PTR [ebp-0x5a53f000],0x0
1000a57b:	10 d0                	adc    al,dl
1000a57d:	a5                   	movs   DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000a57e:	00 10                	add    BYTE PTR [eax],dl
1000a580:	23 d1                	and    edx,ecx
1000a582:	8a 06                	mov    al,BYTE PTR [esi]
1000a584:	88 07                	mov    BYTE PTR [edi],al
1000a586:	8a 46 01             	mov    al,BYTE PTR [esi+0x1]
1000a589:	88 47 01             	mov    BYTE PTR [edi+0x1],al
1000a58c:	8a 46 02             	mov    al,BYTE PTR [esi+0x2]
1000a58f:	c1 e9 02             	shr    ecx,0x2
1000a592:	88 47 02             	mov    BYTE PTR [edi+0x2],al
1000a595:	83 c6 03             	add    esi,0x3
1000a598:	83 c7 03             	add    edi,0x3
1000a59b:	83 f9 08             	cmp    ecx,0x8
1000a59e:	72 cc                	jb     0x1000a56c
1000a5a0:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000a5a2:	ff 24 95 58 a6 00 10 	jmp    DWORD PTR [edx*4+0x1000a658]
1000a5a9:	8d 49 00             	lea    ecx,[ecx+0x0]
1000a5ac:	23 d1                	and    edx,ecx
1000a5ae:	8a 06                	mov    al,BYTE PTR [esi]
1000a5b0:	88 07                	mov    BYTE PTR [edi],al
1000a5b2:	8a 46 01             	mov    al,BYTE PTR [esi+0x1]
1000a5b5:	c1 e9 02             	shr    ecx,0x2
1000a5b8:	88 47 01             	mov    BYTE PTR [edi+0x1],al
1000a5bb:	83 c6 02             	add    esi,0x2
1000a5be:	83 c7 02             	add    edi,0x2
1000a5c1:	83 f9 08             	cmp    ecx,0x8
1000a5c4:	72 a6                	jb     0x1000a56c
1000a5c6:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000a5c8:	ff 24 95 58 a6 00 10 	jmp    DWORD PTR [edx*4+0x1000a658]
1000a5cf:	90                   	nop
1000a5d0:	23 d1                	and    edx,ecx
1000a5d2:	8a 06                	mov    al,BYTE PTR [esi]
1000a5d4:	88 07                	mov    BYTE PTR [edi],al
1000a5d6:	46                   	inc    esi
1000a5d7:	c1 e9 02             	shr    ecx,0x2
1000a5da:	47                   	inc    edi
1000a5db:	83 f9 08             	cmp    ecx,0x8
1000a5de:	72 8c                	jb     0x1000a56c
1000a5e0:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000a5e2:	ff 24 95 58 a6 00 10 	jmp    DWORD PTR [edx*4+0x1000a658]
1000a5e9:	8d 49 00             	lea    ecx,[ecx+0x0]
1000a5ec:	4f                   	dec    edi
1000a5ed:	a6                   	cmps   BYTE PTR ds:[esi],BYTE PTR es:[edi]
1000a5ee:	00 10                	add    BYTE PTR [eax],dl
1000a5f0:	3c a6                	cmp    al,0xa6
1000a5f2:	00 10                	add    BYTE PTR [eax],dl
1000a5f4:	34 a6                	xor    al,0xa6
1000a5f6:	00 10                	add    BYTE PTR [eax],dl
1000a5f8:	2c a6                	sub    al,0xa6
1000a5fa:	00 10                	add    BYTE PTR [eax],dl
1000a5fc:	24 a6                	and    al,0xa6
1000a5fe:	00 10                	add    BYTE PTR [eax],dl
1000a600:	1c a6                	sbb    al,0xa6
1000a602:	00 10                	add    BYTE PTR [eax],dl
1000a604:	14 a6                	adc    al,0xa6
1000a606:	00 10                	add    BYTE PTR [eax],dl
1000a608:	0c a6                	or     al,0xa6
1000a60a:	00 10                	add    BYTE PTR [eax],dl
1000a60c:	8b 44 8e e4          	mov    eax,DWORD PTR [esi+ecx*4-0x1c]
1000a610:	89 44 8f e4          	mov    DWORD PTR [edi+ecx*4-0x1c],eax
1000a614:	8b 44 8e e8          	mov    eax,DWORD PTR [esi+ecx*4-0x18]
1000a618:	89 44 8f e8          	mov    DWORD PTR [edi+ecx*4-0x18],eax
1000a61c:	8b 44 8e ec          	mov    eax,DWORD PTR [esi+ecx*4-0x14]
1000a620:	89 44 8f ec          	mov    DWORD PTR [edi+ecx*4-0x14],eax
1000a624:	8b 44 8e f0          	mov    eax,DWORD PTR [esi+ecx*4-0x10]
1000a628:	89 44 8f f0          	mov    DWORD PTR [edi+ecx*4-0x10],eax
1000a62c:	8b 44 8e f4          	mov    eax,DWORD PTR [esi+ecx*4-0xc]
1000a630:	89 44 8f f4          	mov    DWORD PTR [edi+ecx*4-0xc],eax
1000a634:	8b 44 8e f8          	mov    eax,DWORD PTR [esi+ecx*4-0x8]
1000a638:	89 44 8f f8          	mov    DWORD PTR [edi+ecx*4-0x8],eax
1000a63c:	8b 44 8e fc          	mov    eax,DWORD PTR [esi+ecx*4-0x4]
1000a640:	89 44 8f fc          	mov    DWORD PTR [edi+ecx*4-0x4],eax
1000a644:	8d 04 8d 00 00 00 00 	lea    eax,[ecx*4+0x0]
1000a64b:	03 f0                	add    esi,eax
1000a64d:	03 f8                	add    edi,eax
1000a64f:	ff 24 95 58 a6 00 10 	jmp    DWORD PTR [edx*4+0x1000a658]
1000a656:	8b ff                	mov    edi,edi
1000a658:	68 a6 00 10 70       	push   0x701000a6
1000a65d:	a6                   	cmps   BYTE PTR ds:[esi],BYTE PTR es:[edi]
1000a65e:	00 10                	add    BYTE PTR [eax],dl
1000a660:	7c a6                	jl     0x1000a608
1000a662:	00 10                	add    BYTE PTR [eax],dl
1000a664:	90                   	nop
1000a665:	a6                   	cmps   BYTE PTR ds:[esi],BYTE PTR es:[edi]
1000a666:	00 10                	add    BYTE PTR [eax],dl
1000a668:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000a66b:	5e                   	pop    esi
1000a66c:	5f                   	pop    edi
1000a66d:	c9                   	leave
1000a66e:	c3                   	ret
1000a66f:	90                   	nop
1000a670:	8a 06                	mov    al,BYTE PTR [esi]
1000a672:	88 07                	mov    BYTE PTR [edi],al
1000a674:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000a677:	5e                   	pop    esi
1000a678:	5f                   	pop    edi
1000a679:	c9                   	leave
1000a67a:	c3                   	ret
1000a67b:	90                   	nop
1000a67c:	8a 06                	mov    al,BYTE PTR [esi]
1000a67e:	88 07                	mov    BYTE PTR [edi],al
1000a680:	8a 46 01             	mov    al,BYTE PTR [esi+0x1]
1000a683:	88 47 01             	mov    BYTE PTR [edi+0x1],al
1000a686:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000a689:	5e                   	pop    esi
1000a68a:	5f                   	pop    edi
1000a68b:	c9                   	leave
1000a68c:	c3                   	ret
1000a68d:	8d 49 00             	lea    ecx,[ecx+0x0]
1000a690:	8a 06                	mov    al,BYTE PTR [esi]
1000a692:	88 07                	mov    BYTE PTR [edi],al
1000a694:	8a 46 01             	mov    al,BYTE PTR [esi+0x1]
1000a697:	88 47 01             	mov    BYTE PTR [edi+0x1],al
1000a69a:	8a 46 02             	mov    al,BYTE PTR [esi+0x2]
1000a69d:	88 47 02             	mov    BYTE PTR [edi+0x2],al
1000a6a0:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000a6a3:	5e                   	pop    esi
1000a6a4:	5f                   	pop    edi
1000a6a5:	c9                   	leave
1000a6a6:	c3                   	ret
1000a6a7:	90                   	nop
1000a6a8:	8d 74 31 fc          	lea    esi,[ecx+esi*1-0x4]
1000a6ac:	8d 7c 39 fc          	lea    edi,[ecx+edi*1-0x4]
1000a6b0:	f7 c7 03 00 00 00    	test   edi,0x3
1000a6b6:	75 24                	jne    0x1000a6dc
1000a6b8:	c1 e9 02             	shr    ecx,0x2
1000a6bb:	83 e2 03             	and    edx,0x3
1000a6be:	83 f9 08             	cmp    ecx,0x8
1000a6c1:	72 0d                	jb     0x1000a6d0
1000a6c3:	fd                   	std
1000a6c4:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000a6c6:	fc                   	cld
1000a6c7:	ff 24 95 f0 a7 00 10 	jmp    DWORD PTR [edx*4+0x1000a7f0]
1000a6ce:	8b ff                	mov    edi,edi
1000a6d0:	f7 d9                	neg    ecx
1000a6d2:	ff 24 8d a0 a7 00 10 	jmp    DWORD PTR [ecx*4+0x1000a7a0]
1000a6d9:	8d 49 00             	lea    ecx,[ecx+0x0]
1000a6dc:	8b c7                	mov    eax,edi
1000a6de:	ba 03 00 00 00       	mov    edx,0x3
1000a6e3:	83 f9 04             	cmp    ecx,0x4
1000a6e6:	72 0c                	jb     0x1000a6f4
1000a6e8:	83 e0 03             	and    eax,0x3
1000a6eb:	2b c8                	sub    ecx,eax
1000a6ed:	ff 24 85 f8 a6 00 10 	jmp    DWORD PTR [eax*4+0x1000a6f8]
1000a6f4:	ff 24 8d f0 a7 00 10 	jmp    DWORD PTR [ecx*4+0x1000a7f0]
1000a6fb:	90                   	nop
1000a6fc:	08 a7 00 10 28 a7    	or     BYTE PTR [edi-0x58d7f000],ah
1000a702:	00 10                	add    BYTE PTR [eax],dl
1000a704:	50                   	push   eax
1000a705:	a7                   	cmps   DWORD PTR ds:[esi],DWORD PTR es:[edi]
1000a706:	00 10                	add    BYTE PTR [eax],dl
1000a708:	8a 46 03             	mov    al,BYTE PTR [esi+0x3]
1000a70b:	23 d1                	and    edx,ecx
1000a70d:	88 47 03             	mov    BYTE PTR [edi+0x3],al
1000a710:	4e                   	dec    esi
1000a711:	c1 e9 02             	shr    ecx,0x2
1000a714:	4f                   	dec    edi
1000a715:	83 f9 08             	cmp    ecx,0x8
1000a718:	72 b6                	jb     0x1000a6d0
1000a71a:	fd                   	std
1000a71b:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000a71d:	fc                   	cld
1000a71e:	ff 24 95 f0 a7 00 10 	jmp    DWORD PTR [edx*4+0x1000a7f0]
1000a725:	8d 49 00             	lea    ecx,[ecx+0x0]
1000a728:	8a 46 03             	mov    al,BYTE PTR [esi+0x3]
1000a72b:	23 d1                	and    edx,ecx
1000a72d:	88 47 03             	mov    BYTE PTR [edi+0x3],al
1000a730:	8a 46 02             	mov    al,BYTE PTR [esi+0x2]
1000a733:	c1 e9 02             	shr    ecx,0x2
1000a736:	88 47 02             	mov    BYTE PTR [edi+0x2],al
1000a739:	83 ee 02             	sub    esi,0x2
1000a73c:	83 ef 02             	sub    edi,0x2
1000a73f:	83 f9 08             	cmp    ecx,0x8
1000a742:	72 8c                	jb     0x1000a6d0
1000a744:	fd                   	std
1000a745:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000a747:	fc                   	cld
1000a748:	ff 24 95 f0 a7 00 10 	jmp    DWORD PTR [edx*4+0x1000a7f0]
1000a74f:	90                   	nop
1000a750:	8a 46 03             	mov    al,BYTE PTR [esi+0x3]
1000a753:	23 d1                	and    edx,ecx
1000a755:	88 47 03             	mov    BYTE PTR [edi+0x3],al
1000a758:	8a 46 02             	mov    al,BYTE PTR [esi+0x2]
1000a75b:	88 47 02             	mov    BYTE PTR [edi+0x2],al
1000a75e:	8a 46 01             	mov    al,BYTE PTR [esi+0x1]
1000a761:	c1 e9 02             	shr    ecx,0x2
1000a764:	88 47 01             	mov    BYTE PTR [edi+0x1],al
1000a767:	83 ee 03             	sub    esi,0x3
1000a76a:	83 ef 03             	sub    edi,0x3
1000a76d:	83 f9 08             	cmp    ecx,0x8
1000a770:	0f 82 5a ff ff ff    	jb     0x1000a6d0
1000a776:	fd                   	std
1000a777:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000a779:	fc                   	cld
1000a77a:	ff 24 95 f0 a7 00 10 	jmp    DWORD PTR [edx*4+0x1000a7f0]
1000a781:	8d 49 00             	lea    ecx,[ecx+0x0]
1000a784:	a4                   	movs   BYTE PTR es:[edi],BYTE PTR ds:[esi]
1000a785:	a7                   	cmps   DWORD PTR ds:[esi],DWORD PTR es:[edi]
1000a786:	00 10                	add    BYTE PTR [eax],dl
1000a788:	ac                   	lods   al,BYTE PTR ds:[esi]
1000a789:	a7                   	cmps   DWORD PTR ds:[esi],DWORD PTR es:[edi]
1000a78a:	00 10                	add    BYTE PTR [eax],dl
1000a78c:	b4 a7                	mov    ah,0xa7
1000a78e:	00 10                	add    BYTE PTR [eax],dl
1000a790:	bc a7 00 10 c4       	mov    esp,0xc41000a7
1000a795:	a7                   	cmps   DWORD PTR ds:[esi],DWORD PTR es:[edi]
1000a796:	00 10                	add    BYTE PTR [eax],dl
1000a798:	cc                   	int3
1000a799:	a7                   	cmps   DWORD PTR ds:[esi],DWORD PTR es:[edi]
1000a79a:	00 10                	add    BYTE PTR [eax],dl
1000a79c:	d4 a7                	aam    0xa7
1000a79e:	00 10                	add    BYTE PTR [eax],dl
1000a7a0:	e7 a7                	out    0xa7,eax
1000a7a2:	00 10                	add    BYTE PTR [eax],dl
1000a7a4:	8b 44 8e 1c          	mov    eax,DWORD PTR [esi+ecx*4+0x1c]
1000a7a8:	89 44 8f 1c          	mov    DWORD PTR [edi+ecx*4+0x1c],eax
1000a7ac:	8b 44 8e 18          	mov    eax,DWORD PTR [esi+ecx*4+0x18]
1000a7b0:	89 44 8f 18          	mov    DWORD PTR [edi+ecx*4+0x18],eax
1000a7b4:	8b 44 8e 14          	mov    eax,DWORD PTR [esi+ecx*4+0x14]
1000a7b8:	89 44 8f 14          	mov    DWORD PTR [edi+ecx*4+0x14],eax
1000a7bc:	8b 44 8e 10          	mov    eax,DWORD PTR [esi+ecx*4+0x10]
1000a7c0:	89 44 8f 10          	mov    DWORD PTR [edi+ecx*4+0x10],eax
1000a7c4:	8b 44 8e 0c          	mov    eax,DWORD PTR [esi+ecx*4+0xc]
1000a7c8:	89 44 8f 0c          	mov    DWORD PTR [edi+ecx*4+0xc],eax
1000a7cc:	8b 44 8e 08          	mov    eax,DWORD PTR [esi+ecx*4+0x8]
1000a7d0:	89 44 8f 08          	mov    DWORD PTR [edi+ecx*4+0x8],eax
1000a7d4:	8b 44 8e 04          	mov    eax,DWORD PTR [esi+ecx*4+0x4]
1000a7d8:	89 44 8f 04          	mov    DWORD PTR [edi+ecx*4+0x4],eax
1000a7dc:	8d 04 8d 00 00 00 00 	lea    eax,[ecx*4+0x0]
1000a7e3:	03 f0                	add    esi,eax
1000a7e5:	03 f8                	add    edi,eax
1000a7e7:	ff 24 95 f0 a7 00 10 	jmp    DWORD PTR [edx*4+0x1000a7f0]
1000a7ee:	8b ff                	mov    edi,edi
1000a7f0:	00 a8 00 10 08 a8    	add    BYTE PTR [eax-0x57f7f000],ch
1000a7f6:	00 10                	add    BYTE PTR [eax],dl
1000a7f8:	18 a8 00 10 2c a8    	sbb    BYTE PTR [eax-0x57d3f000],ch
1000a7fe:	00 10                	add    BYTE PTR [eax],dl
1000a800:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000a803:	5e                   	pop    esi
1000a804:	5f                   	pop    edi
1000a805:	c9                   	leave
1000a806:	c3                   	ret
1000a807:	90                   	nop
1000a808:	8a 46 03             	mov    al,BYTE PTR [esi+0x3]
1000a80b:	88 47 03             	mov    BYTE PTR [edi+0x3],al
1000a80e:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000a811:	5e                   	pop    esi
1000a812:	5f                   	pop    edi
1000a813:	c9                   	leave
1000a814:	c3                   	ret
1000a815:	8d 49 00             	lea    ecx,[ecx+0x0]
1000a818:	8a 46 03             	mov    al,BYTE PTR [esi+0x3]
1000a81b:	88 47 03             	mov    BYTE PTR [edi+0x3],al
1000a81e:	8a 46 02             	mov    al,BYTE PTR [esi+0x2]
1000a821:	88 47 02             	mov    BYTE PTR [edi+0x2],al
1000a824:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000a827:	5e                   	pop    esi
1000a828:	5f                   	pop    edi
1000a829:	c9                   	leave
1000a82a:	c3                   	ret
1000a82b:	90                   	nop
1000a82c:	8a 46 03             	mov    al,BYTE PTR [esi+0x3]
1000a82f:	88 47 03             	mov    BYTE PTR [edi+0x3],al
1000a832:	8a 46 02             	mov    al,BYTE PTR [esi+0x2]
1000a835:	88 47 02             	mov    BYTE PTR [edi+0x2],al
1000a838:	8a 46 01             	mov    al,BYTE PTR [esi+0x1]
1000a83b:	88 47 01             	mov    BYTE PTR [edi+0x1],al
1000a83e:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000a841:	5e                   	pop    esi
1000a842:	5f                   	pop    edi
1000a843:	c9                   	leave
1000a844:	c3                   	ret
1000a845:	53                   	push   ebx
1000a846:	33 db                	xor    ebx,ebx
1000a848:	39 1d f0 f7 00 10    	cmp    DWORD PTR ds:0x1000f7f0,ebx
1000a84e:	56                   	push   esi
1000a84f:	57                   	push   edi
1000a850:	75 42                	jne    0x1000a894
1000a852:	68 d4 d5 00 10       	push   0x1000d5d4
1000a857:	ff 15 b8 d0 00 10    	call   DWORD PTR ds:0x1000d0b8
1000a85d:	8b f8                	mov    edi,eax
1000a85f:	3b fb                	cmp    edi,ebx
1000a861:	74 67                	je     0x1000a8ca
1000a863:	8b 35 2c d0 00 10    	mov    esi,DWORD PTR ds:0x1000d02c
1000a869:	68 c8 d5 00 10       	push   0x1000d5c8
1000a86e:	57                   	push   edi
1000a86f:	ff d6                	call   esi
1000a871:	85 c0                	test   eax,eax
1000a873:	a3 f0 f7 00 10       	mov    ds:0x1000f7f0,eax
1000a878:	74 50                	je     0x1000a8ca
1000a87a:	68 b8 d5 00 10       	push   0x1000d5b8
1000a87f:	57                   	push   edi
1000a880:	ff d6                	call   esi
1000a882:	68 a4 d5 00 10       	push   0x1000d5a4
1000a887:	57                   	push   edi
1000a888:	a3 f4 f7 00 10       	mov    ds:0x1000f7f4,eax
1000a88d:	ff d6                	call   esi
1000a88f:	a3 f8 f7 00 10       	mov    ds:0x1000f7f8,eax
1000a894:	a1 f4 f7 00 10       	mov    eax,ds:0x1000f7f4
1000a899:	85 c0                	test   eax,eax
1000a89b:	74 16                	je     0x1000a8b3
1000a89d:	ff d0                	call   eax
1000a89f:	8b d8                	mov    ebx,eax
1000a8a1:	85 db                	test   ebx,ebx
1000a8a3:	74 0e                	je     0x1000a8b3
1000a8a5:	a1 f8 f7 00 10       	mov    eax,ds:0x1000f7f8
1000a8aa:	85 c0                	test   eax,eax
1000a8ac:	74 05                	je     0x1000a8b3
1000a8ae:	53                   	push   ebx
1000a8af:	ff d0                	call   eax
1000a8b1:	8b d8                	mov    ebx,eax
1000a8b3:	ff 74 24 18          	push   DWORD PTR [esp+0x18]
1000a8b7:	ff 74 24 18          	push   DWORD PTR [esp+0x18]
1000a8bb:	ff 74 24 18          	push   DWORD PTR [esp+0x18]
1000a8bf:	53                   	push   ebx
1000a8c0:	ff 15 f0 f7 00 10    	call   DWORD PTR ds:0x1000f7f0
1000a8c6:	5f                   	pop    edi
1000a8c7:	5e                   	pop    esi
1000a8c8:	5b                   	pop    ebx
1000a8c9:	c3                   	ret
1000a8ca:	33 c0                	xor    eax,eax
1000a8cc:	eb f8                	jmp    0x1000a8c6
1000a8ce:	cc                   	int3
1000a8cf:	cc                   	int3
1000a8d0:	8b 4c 24 0c          	mov    ecx,DWORD PTR [esp+0xc]
1000a8d4:	57                   	push   edi
1000a8d5:	85 c9                	test   ecx,ecx
1000a8d7:	74 7a                	je     0x1000a953
1000a8d9:	56                   	push   esi
1000a8da:	53                   	push   ebx
1000a8db:	8b d9                	mov    ebx,ecx
1000a8dd:	8b 74 24 14          	mov    esi,DWORD PTR [esp+0x14]
1000a8e1:	f7 c6 03 00 00 00    	test   esi,0x3
1000a8e7:	8b 7c 24 10          	mov    edi,DWORD PTR [esp+0x10]
1000a8eb:	75 07                	jne    0x1000a8f4
1000a8ed:	c1 e9 02             	shr    ecx,0x2
1000a8f0:	75 6f                	jne    0x1000a961
1000a8f2:	eb 21                	jmp    0x1000a915
1000a8f4:	8a 06                	mov    al,BYTE PTR [esi]
1000a8f6:	46                   	inc    esi
1000a8f7:	88 07                	mov    BYTE PTR [edi],al
1000a8f9:	47                   	inc    edi
1000a8fa:	49                   	dec    ecx
1000a8fb:	74 25                	je     0x1000a922
1000a8fd:	84 c0                	test   al,al
1000a8ff:	74 29                	je     0x1000a92a
1000a901:	f7 c6 03 00 00 00    	test   esi,0x3
1000a907:	75 eb                	jne    0x1000a8f4
1000a909:	8b d9                	mov    ebx,ecx
1000a90b:	c1 e9 02             	shr    ecx,0x2
1000a90e:	75 51                	jne    0x1000a961
1000a910:	83 e3 03             	and    ebx,0x3
1000a913:	74 0d                	je     0x1000a922
1000a915:	8a 06                	mov    al,BYTE PTR [esi]
1000a917:	46                   	inc    esi
1000a918:	88 07                	mov    BYTE PTR [edi],al
1000a91a:	47                   	inc    edi
1000a91b:	84 c0                	test   al,al
1000a91d:	74 2f                	je     0x1000a94e
1000a91f:	4b                   	dec    ebx
1000a920:	75 f3                	jne    0x1000a915
1000a922:	8b 44 24 10          	mov    eax,DWORD PTR [esp+0x10]
1000a926:	5b                   	pop    ebx
1000a927:	5e                   	pop    esi
1000a928:	5f                   	pop    edi
1000a929:	c3                   	ret
1000a92a:	f7 c7 03 00 00 00    	test   edi,0x3
1000a930:	74 12                	je     0x1000a944
1000a932:	88 07                	mov    BYTE PTR [edi],al
1000a934:	47                   	inc    edi
1000a935:	49                   	dec    ecx
1000a936:	0f 84 8a 00 00 00    	je     0x1000a9c6
1000a93c:	f7 c7 03 00 00 00    	test   edi,0x3
1000a942:	75 ee                	jne    0x1000a932
1000a944:	8b d9                	mov    ebx,ecx
1000a946:	c1 e9 02             	shr    ecx,0x2
1000a949:	75 6c                	jne    0x1000a9b7
1000a94b:	88 07                	mov    BYTE PTR [edi],al
1000a94d:	47                   	inc    edi
1000a94e:	4b                   	dec    ebx
1000a94f:	75 fa                	jne    0x1000a94b
1000a951:	5b                   	pop    ebx
1000a952:	5e                   	pop    esi
1000a953:	8b 44 24 08          	mov    eax,DWORD PTR [esp+0x8]
1000a957:	5f                   	pop    edi
1000a958:	c3                   	ret
1000a959:	89 17                	mov    DWORD PTR [edi],edx
1000a95b:	83 c7 04             	add    edi,0x4
1000a95e:	49                   	dec    ecx
1000a95f:	74 af                	je     0x1000a910
1000a961:	ba ff fe fe 7e       	mov    edx,0x7efefeff
1000a966:	8b 06                	mov    eax,DWORD PTR [esi]
1000a968:	03 d0                	add    edx,eax
1000a96a:	83 f0 ff             	xor    eax,0xffffffff
1000a96d:	33 c2                	xor    eax,edx
1000a96f:	8b 16                	mov    edx,DWORD PTR [esi]
1000a971:	83 c6 04             	add    esi,0x4
1000a974:	a9 00 01 01 81       	test   eax,0x81010100
1000a979:	74 de                	je     0x1000a959
1000a97b:	84 d2                	test   dl,dl
1000a97d:	74 2c                	je     0x1000a9ab
1000a97f:	84 f6                	test   dh,dh
1000a981:	74 1e                	je     0x1000a9a1
1000a983:	f7 c2 00 00 ff 00    	test   edx,0xff0000
1000a989:	74 0c                	je     0x1000a997
1000a98b:	f7 c2 00 00 00 ff    	test   edx,0xff000000
1000a991:	75 c6                	jne    0x1000a959
1000a993:	89 17                	mov    DWORD PTR [edi],edx
1000a995:	eb 18                	jmp    0x1000a9af
1000a997:	81 e2 ff ff 00 00    	and    edx,0xffff
1000a99d:	89 17                	mov    DWORD PTR [edi],edx
1000a99f:	eb 0e                	jmp    0x1000a9af
1000a9a1:	81 e2 ff 00 00 00    	and    edx,0xff
1000a9a7:	89 17                	mov    DWORD PTR [edi],edx
1000a9a9:	eb 04                	jmp    0x1000a9af
1000a9ab:	33 d2                	xor    edx,edx
1000a9ad:	89 17                	mov    DWORD PTR [edi],edx
1000a9af:	83 c7 04             	add    edi,0x4
1000a9b2:	33 c0                	xor    eax,eax
1000a9b4:	49                   	dec    ecx
1000a9b5:	74 0a                	je     0x1000a9c1
1000a9b7:	33 c0                	xor    eax,eax
1000a9b9:	89 07                	mov    DWORD PTR [edi],eax
1000a9bb:	83 c7 04             	add    edi,0x4
1000a9be:	49                   	dec    ecx
1000a9bf:	75 f8                	jne    0x1000a9b9
1000a9c1:	83 e3 03             	and    ebx,0x3
1000a9c4:	75 85                	jne    0x1000a94b
1000a9c6:	8b 44 24 10          	mov    eax,DWORD PTR [esp+0x10]
1000a9ca:	5b                   	pop    ebx
1000a9cb:	5e                   	pop    esi
1000a9cc:	5f                   	pop    edi
1000a9cd:	c3                   	ret
1000a9ce:	55                   	push   ebp
1000a9cf:	8b ec                	mov    ebp,esp
1000a9d1:	53                   	push   ebx
1000a9d2:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000a9d5:	e8 35 01 00 00       	call   0x1000ab0f
1000a9da:	85 c0                	test   eax,eax
1000a9dc:	59                   	pop    ecx
1000a9dd:	0f 84 20 01 00 00    	je     0x1000ab03
1000a9e3:	8b 58 08             	mov    ebx,DWORD PTR [eax+0x8]
1000a9e6:	85 db                	test   ebx,ebx
1000a9e8:	0f 84 15 01 00 00    	je     0x1000ab03
1000a9ee:	83 fb 05             	cmp    ebx,0x5
1000a9f1:	75 0c                	jne    0x1000a9ff
1000a9f3:	83 60 08 00          	and    DWORD PTR [eax+0x8],0x0
1000a9f7:	6a 01                	push   0x1
1000a9f9:	58                   	pop    eax
1000a9fa:	e9 0d 01 00 00       	jmp    0x1000ab0c
1000a9ff:	83 fb 01             	cmp    ebx,0x1
1000aa02:	0f 84 f6 00 00 00    	je     0x1000aafe
1000aa08:	8b 0d fc f7 00 10    	mov    ecx,DWORD PTR ds:0x1000f7fc
1000aa0e:	89 4d 08             	mov    DWORD PTR [ebp+0x8],ecx
1000aa11:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
1000aa14:	89 0d fc f7 00 10    	mov    DWORD PTR ds:0x1000f7fc,ecx
1000aa1a:	8b 48 04             	mov    ecx,DWORD PTR [eax+0x4]
1000aa1d:	83 f9 08             	cmp    ecx,0x8
1000aa20:	0f 85 c8 00 00 00    	jne    0x1000aaee
1000aa26:	8b 0d 78 f1 00 10    	mov    ecx,DWORD PTR ds:0x1000f178
1000aa2c:	8b 15 7c f1 00 10    	mov    edx,DWORD PTR ds:0x1000f17c
1000aa32:	03 d1                	add    edx,ecx
1000aa34:	56                   	push   esi
1000aa35:	3b ca                	cmp    ecx,edx
1000aa37:	7d 15                	jge    0x1000aa4e
1000aa39:	8d 34 49             	lea    esi,[ecx+ecx*2]
1000aa3c:	2b d1                	sub    edx,ecx
1000aa3e:	8d 34 b5 08 f1 00 10 	lea    esi,[esi*4+0x1000f108]
1000aa45:	83 26 00             	and    DWORD PTR [esi],0x0
1000aa48:	83 c6 0c             	add    esi,0xc
1000aa4b:	4a                   	dec    edx
1000aa4c:	75 f7                	jne    0x1000aa45
1000aa4e:	8b 00                	mov    eax,DWORD PTR [eax]
1000aa50:	8b 35 84 f1 00 10    	mov    esi,DWORD PTR ds:0x1000f184
1000aa56:	3d 8e 00 00 c0       	cmp    eax,0xc000008e
1000aa5b:	75 0c                	jne    0x1000aa69
1000aa5d:	c7 05 84 f1 00 10 83 	mov    DWORD PTR ds:0x1000f184,0x83
1000aa64:	00 00 00 
1000aa67:	eb 70                	jmp    0x1000aad9
1000aa69:	3d 90 00 00 c0       	cmp    eax,0xc0000090
1000aa6e:	75 0c                	jne    0x1000aa7c
1000aa70:	c7 05 84 f1 00 10 81 	mov    DWORD PTR ds:0x1000f184,0x81
1000aa77:	00 00 00 
1000aa7a:	eb 5d                	jmp    0x1000aad9
1000aa7c:	3d 91 00 00 c0       	cmp    eax,0xc0000091
1000aa81:	75 0c                	jne    0x1000aa8f
1000aa83:	c7 05 84 f1 00 10 84 	mov    DWORD PTR ds:0x1000f184,0x84
1000aa8a:	00 00 00 
1000aa8d:	eb 4a                	jmp    0x1000aad9
1000aa8f:	3d 93 00 00 c0       	cmp    eax,0xc0000093
1000aa94:	75 0c                	jne    0x1000aaa2
1000aa96:	c7 05 84 f1 00 10 85 	mov    DWORD PTR ds:0x1000f184,0x85
1000aa9d:	00 00 00 
1000aaa0:	eb 37                	jmp    0x1000aad9
1000aaa2:	3d 8d 00 00 c0       	cmp    eax,0xc000008d
1000aaa7:	75 0c                	jne    0x1000aab5
1000aaa9:	c7 05 84 f1 00 10 82 	mov    DWORD PTR ds:0x1000f184,0x82
1000aab0:	00 00 00 
1000aab3:	eb 24                	jmp    0x1000aad9
1000aab5:	3d 8f 00 00 c0       	cmp    eax,0xc000008f
1000aaba:	75 0c                	jne    0x1000aac8
1000aabc:	c7 05 84 f1 00 10 86 	mov    DWORD PTR ds:0x1000f184,0x86
1000aac3:	00 00 00 
1000aac6:	eb 11                	jmp    0x1000aad9
1000aac8:	3d 92 00 00 c0       	cmp    eax,0xc0000092
1000aacd:	75 0a                	jne    0x1000aad9
1000aacf:	c7 05 84 f1 00 10 8a 	mov    DWORD PTR ds:0x1000f184,0x8a
1000aad6:	00 00 00 
1000aad9:	ff 35 84 f1 00 10    	push   DWORD PTR ds:0x1000f184
1000aadf:	6a 08                	push   0x8
1000aae1:	ff d3                	call   ebx
1000aae3:	59                   	pop    ecx
1000aae4:	89 35 84 f1 00 10    	mov    DWORD PTR ds:0x1000f184,esi
1000aaea:	59                   	pop    ecx
1000aaeb:	5e                   	pop    esi
1000aaec:	eb 08                	jmp    0x1000aaf6
1000aaee:	83 60 08 00          	and    DWORD PTR [eax+0x8],0x0
1000aaf2:	51                   	push   ecx
1000aaf3:	ff d3                	call   ebx
1000aaf5:	59                   	pop    ecx
1000aaf6:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000aaf9:	a3 fc f7 00 10       	mov    ds:0x1000f7fc,eax
1000aafe:	83 c8 ff             	or     eax,0xffffffff
1000ab01:	eb 09                	jmp    0x1000ab0c
1000ab03:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
1000ab06:	ff 15 bc d0 00 10    	call   DWORD PTR ds:0x1000d0bc
1000ab0c:	5b                   	pop    ebx
1000ab0d:	5d                   	pop    ebp
1000ab0e:	c3                   	ret
1000ab0f:	8b 54 24 04          	mov    edx,DWORD PTR [esp+0x4]
1000ab13:	8b 0d 80 f1 00 10    	mov    ecx,DWORD PTR ds:0x1000f180
1000ab19:	39 15 00 f1 00 10    	cmp    DWORD PTR ds:0x1000f100,edx
1000ab1f:	56                   	push   esi
1000ab20:	b8 00 f1 00 10       	mov    eax,0x1000f100
1000ab25:	74 15                	je     0x1000ab3c
1000ab27:	8d 34 49             	lea    esi,[ecx+ecx*2]
1000ab2a:	8d 34 b5 00 f1 00 10 	lea    esi,[esi*4+0x1000f100]
1000ab31:	83 c0 0c             	add    eax,0xc
1000ab34:	3b c6                	cmp    eax,esi
1000ab36:	73 04                	jae    0x1000ab3c
1000ab38:	39 10                	cmp    DWORD PTR [eax],edx
1000ab3a:	75 f5                	jne    0x1000ab31
1000ab3c:	8d 0c 49             	lea    ecx,[ecx+ecx*2]
1000ab3f:	5e                   	pop    esi
1000ab40:	8d 0c 8d 00 f1 00 10 	lea    ecx,[ecx*4+0x1000f100]
1000ab47:	3b c1                	cmp    eax,ecx
1000ab49:	73 04                	jae    0x1000ab4f
1000ab4b:	39 10                	cmp    DWORD PTR [eax],edx
1000ab4d:	74 02                	je     0x1000ab51
1000ab4f:	33 c0                	xor    eax,eax
1000ab51:	c3                   	ret
1000ab52:	55                   	push   ebp
1000ab53:	8b ec                	mov    ebp,esp
1000ab55:	6a ff                	push   0xffffffff
1000ab57:	68 e0 d5 00 10       	push   0x1000d5e0
1000ab5c:	68 dc 9e 00 10       	push   0x10009edc
1000ab61:	64 a1 00 00 00 00    	mov    eax,fs:0x0
1000ab67:	50                   	push   eax
1000ab68:	64 89 25 00 00 00 00 	mov    DWORD PTR fs:0x0,esp
1000ab6f:	83 ec 1c             	sub    esp,0x1c
1000ab72:	53                   	push   ebx
1000ab73:	56                   	push   esi
1000ab74:	57                   	push   edi
1000ab75:	89 65 e8             	mov    DWORD PTR [ebp-0x18],esp
1000ab78:	33 ff                	xor    edi,edi
1000ab7a:	39 3d 00 f8 00 10    	cmp    DWORD PTR ds:0x1000f800,edi
1000ab80:	75 46                	jne    0x1000abc8
1000ab82:	57                   	push   edi
1000ab83:	57                   	push   edi
1000ab84:	6a 01                	push   0x1
1000ab86:	5b                   	pop    ebx
1000ab87:	53                   	push   ebx
1000ab88:	68 94 d5 00 10       	push   0x1000d594
1000ab8d:	be 00 01 00 00       	mov    esi,0x100
1000ab92:	56                   	push   esi
1000ab93:	57                   	push   edi
1000ab94:	ff 15 c4 d0 00 10    	call   DWORD PTR ds:0x1000d0c4
1000ab9a:	85 c0                	test   eax,eax
1000ab9c:	74 08                	je     0x1000aba6
1000ab9e:	89 1d 00 f8 00 10    	mov    DWORD PTR ds:0x1000f800,ebx
1000aba4:	eb 22                	jmp    0x1000abc8
1000aba6:	57                   	push   edi
1000aba7:	57                   	push   edi
1000aba8:	53                   	push   ebx
1000aba9:	68 90 d5 00 10       	push   0x1000d590
1000abae:	56                   	push   esi
1000abaf:	57                   	push   edi
1000abb0:	ff 15 c0 d0 00 10    	call   DWORD PTR ds:0x1000d0c0
1000abb6:	85 c0                	test   eax,eax
1000abb8:	0f 84 22 01 00 00    	je     0x1000ace0
1000abbe:	c7 05 00 f8 00 10 02 	mov    DWORD PTR ds:0x1000f800,0x2
1000abc5:	00 00 00 
1000abc8:	39 7d 14             	cmp    DWORD PTR [ebp+0x14],edi
1000abcb:	7e 10                	jle    0x1000abdd
1000abcd:	ff 75 14             	push   DWORD PTR [ebp+0x14]
1000abd0:	ff 75 10             	push   DWORD PTR [ebp+0x10]
1000abd3:	e8 9e 01 00 00       	call   0x1000ad76
1000abd8:	59                   	pop    ecx
1000abd9:	59                   	pop    ecx
1000abda:	89 45 14             	mov    DWORD PTR [ebp+0x14],eax
1000abdd:	a1 00 f8 00 10       	mov    eax,ds:0x1000f800
1000abe2:	83 f8 02             	cmp    eax,0x2
1000abe5:	75 1d                	jne    0x1000ac04
1000abe7:	ff 75 1c             	push   DWORD PTR [ebp+0x1c]
1000abea:	ff 75 18             	push   DWORD PTR [ebp+0x18]
1000abed:	ff 75 14             	push   DWORD PTR [ebp+0x14]
1000abf0:	ff 75 10             	push   DWORD PTR [ebp+0x10]
1000abf3:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
1000abf6:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000abf9:	ff 15 c0 d0 00 10    	call   DWORD PTR ds:0x1000d0c0
1000abff:	e9 de 00 00 00       	jmp    0x1000ace2
1000ac04:	83 f8 01             	cmp    eax,0x1
1000ac07:	0f 85 d3 00 00 00    	jne    0x1000ace0
1000ac0d:	39 7d 20             	cmp    DWORD PTR [ebp+0x20],edi
1000ac10:	75 08                	jne    0x1000ac1a
1000ac12:	a1 1c f8 00 10       	mov    eax,ds:0x1000f81c
1000ac17:	89 45 20             	mov    DWORD PTR [ebp+0x20],eax
1000ac1a:	57                   	push   edi
1000ac1b:	57                   	push   edi
1000ac1c:	ff 75 14             	push   DWORD PTR [ebp+0x14]
1000ac1f:	ff 75 10             	push   DWORD PTR [ebp+0x10]
1000ac22:	8b 45 24             	mov    eax,DWORD PTR [ebp+0x24]
1000ac25:	f7 d8                	neg    eax
1000ac27:	1b c0                	sbb    eax,eax
1000ac29:	83 e0 08             	and    eax,0x8
1000ac2c:	40                   	inc    eax
1000ac2d:	50                   	push   eax
1000ac2e:	ff 75 20             	push   DWORD PTR [ebp+0x20]
1000ac31:	ff 15 a0 d0 00 10    	call   DWORD PTR ds:0x1000d0a0
1000ac37:	8b d8                	mov    ebx,eax
1000ac39:	89 5d e4             	mov    DWORD PTR [ebp-0x1c],ebx
1000ac3c:	3b df                	cmp    ebx,edi
1000ac3e:	0f 84 9c 00 00 00    	je     0x1000ace0
1000ac44:	89 7d fc             	mov    DWORD PTR [ebp-0x4],edi
1000ac47:	8d 04 1b             	lea    eax,[ebx+ebx*1]
1000ac4a:	83 c0 03             	add    eax,0x3
1000ac4d:	24 fc                	and    al,0xfc
1000ac4f:	e8 ac a9 ff ff       	call   0x10005600
1000ac54:	89 65 e8             	mov    DWORD PTR [ebp-0x18],esp
1000ac57:	8b c4                	mov    eax,esp
1000ac59:	89 45 dc             	mov    DWORD PTR [ebp-0x24],eax
1000ac5c:	83 4d fc ff          	or     DWORD PTR [ebp-0x4],0xffffffff
1000ac60:	eb 13                	jmp    0x1000ac75
1000ac62:	6a 01                	push   0x1
1000ac64:	58                   	pop    eax
1000ac65:	c3                   	ret
1000ac66:	8b 65 e8             	mov    esp,DWORD PTR [ebp-0x18]
1000ac69:	33 ff                	xor    edi,edi
1000ac6b:	89 7d dc             	mov    DWORD PTR [ebp-0x24],edi
1000ac6e:	83 4d fc ff          	or     DWORD PTR [ebp-0x4],0xffffffff
1000ac72:	8b 5d e4             	mov    ebx,DWORD PTR [ebp-0x1c]
1000ac75:	39 7d dc             	cmp    DWORD PTR [ebp-0x24],edi
1000ac78:	74 66                	je     0x1000ace0
1000ac7a:	53                   	push   ebx
1000ac7b:	ff 75 dc             	push   DWORD PTR [ebp-0x24]
1000ac7e:	ff 75 14             	push   DWORD PTR [ebp+0x14]
1000ac81:	ff 75 10             	push   DWORD PTR [ebp+0x10]
1000ac84:	6a 01                	push   0x1
1000ac86:	ff 75 20             	push   DWORD PTR [ebp+0x20]
1000ac89:	ff 15 a0 d0 00 10    	call   DWORD PTR ds:0x1000d0a0
1000ac8f:	85 c0                	test   eax,eax
1000ac91:	74 4d                	je     0x1000ace0
1000ac93:	57                   	push   edi
1000ac94:	57                   	push   edi
1000ac95:	53                   	push   ebx
1000ac96:	ff 75 dc             	push   DWORD PTR [ebp-0x24]
1000ac99:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
1000ac9c:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000ac9f:	ff 15 c4 d0 00 10    	call   DWORD PTR ds:0x1000d0c4
1000aca5:	8b f0                	mov    esi,eax
1000aca7:	89 75 d8             	mov    DWORD PTR [ebp-0x28],esi
1000acaa:	3b f7                	cmp    esi,edi
1000acac:	74 32                	je     0x1000ace0
1000acae:	f6 45 0d 04          	test   BYTE PTR [ebp+0xd],0x4
1000acb2:	74 40                	je     0x1000acf4
1000acb4:	39 7d 1c             	cmp    DWORD PTR [ebp+0x1c],edi
1000acb7:	0f 84 b2 00 00 00    	je     0x1000ad6f
1000acbd:	3b 75 1c             	cmp    esi,DWORD PTR [ebp+0x1c]
1000acc0:	7f 1e                	jg     0x1000ace0
1000acc2:	ff 75 1c             	push   DWORD PTR [ebp+0x1c]
1000acc5:	ff 75 18             	push   DWORD PTR [ebp+0x18]
1000acc8:	53                   	push   ebx
1000acc9:	ff 75 dc             	push   DWORD PTR [ebp-0x24]
1000accc:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
1000accf:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000acd2:	ff 15 c4 d0 00 10    	call   DWORD PTR ds:0x1000d0c4
1000acd8:	85 c0                	test   eax,eax
1000acda:	0f 85 8f 00 00 00    	jne    0x1000ad6f
1000ace0:	33 c0                	xor    eax,eax
1000ace2:	8d 65 c8             	lea    esp,[ebp-0x38]
1000ace5:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
1000ace8:	64 89 0d 00 00 00 00 	mov    DWORD PTR fs:0x0,ecx
1000acef:	5f                   	pop    edi
1000acf0:	5e                   	pop    esi
1000acf1:	5b                   	pop    ebx
1000acf2:	c9                   	leave
1000acf3:	c3                   	ret
1000acf4:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [ebp-0x4],0x1
1000acfb:	8d 04 36             	lea    eax,[esi+esi*1]
1000acfe:	83 c0 03             	add    eax,0x3
1000ad01:	24 fc                	and    al,0xfc
1000ad03:	e8 f8 a8 ff ff       	call   0x10005600
1000ad08:	89 65 e8             	mov    DWORD PTR [ebp-0x18],esp
1000ad0b:	8b dc                	mov    ebx,esp
1000ad0d:	89 5d e0             	mov    DWORD PTR [ebp-0x20],ebx
1000ad10:	83 4d fc ff          	or     DWORD PTR [ebp-0x4],0xffffffff
1000ad14:	eb 12                	jmp    0x1000ad28
1000ad16:	6a 01                	push   0x1
1000ad18:	58                   	pop    eax
1000ad19:	c3                   	ret
1000ad1a:	8b 65 e8             	mov    esp,DWORD PTR [ebp-0x18]
1000ad1d:	33 ff                	xor    edi,edi
1000ad1f:	33 db                	xor    ebx,ebx
1000ad21:	83 4d fc ff          	or     DWORD PTR [ebp-0x4],0xffffffff
1000ad25:	8b 75 d8             	mov    esi,DWORD PTR [ebp-0x28]
1000ad28:	3b df                	cmp    ebx,edi
1000ad2a:	74 b4                	je     0x1000ace0
1000ad2c:	56                   	push   esi
1000ad2d:	53                   	push   ebx
1000ad2e:	ff 75 e4             	push   DWORD PTR [ebp-0x1c]
1000ad31:	ff 75 dc             	push   DWORD PTR [ebp-0x24]
1000ad34:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
1000ad37:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000ad3a:	ff 15 c4 d0 00 10    	call   DWORD PTR ds:0x1000d0c4
1000ad40:	85 c0                	test   eax,eax
1000ad42:	74 9c                	je     0x1000ace0
1000ad44:	39 7d 1c             	cmp    DWORD PTR [ebp+0x1c],edi
1000ad47:	57                   	push   edi
1000ad48:	57                   	push   edi
1000ad49:	75 04                	jne    0x1000ad4f
1000ad4b:	57                   	push   edi
1000ad4c:	57                   	push   edi
1000ad4d:	eb 06                	jmp    0x1000ad55
1000ad4f:	ff 75 1c             	push   DWORD PTR [ebp+0x1c]
1000ad52:	ff 75 18             	push   DWORD PTR [ebp+0x18]
1000ad55:	56                   	push   esi
1000ad56:	53                   	push   ebx
1000ad57:	68 20 02 00 00       	push   0x220
1000ad5c:	ff 75 20             	push   DWORD PTR [ebp+0x20]
1000ad5f:	ff 15 70 d0 00 10    	call   DWORD PTR ds:0x1000d070
1000ad65:	8b f0                	mov    esi,eax
1000ad67:	3b f7                	cmp    esi,edi
1000ad69:	0f 84 71 ff ff ff    	je     0x1000ace0
1000ad6f:	8b c6                	mov    eax,esi
1000ad71:	e9 6c ff ff ff       	jmp    0x1000ace2
1000ad76:	8b 54 24 08          	mov    edx,DWORD PTR [esp+0x8]
1000ad7a:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
1000ad7e:	85 d2                	test   edx,edx
1000ad80:	56                   	push   esi
1000ad81:	8d 4a ff             	lea    ecx,[edx-0x1]
1000ad84:	74 0d                	je     0x1000ad93
1000ad86:	80 38 00             	cmp    BYTE PTR [eax],0x0
1000ad89:	74 08                	je     0x1000ad93
1000ad8b:	40                   	inc    eax
1000ad8c:	8b f1                	mov    esi,ecx
1000ad8e:	49                   	dec    ecx
1000ad8f:	85 f6                	test   esi,esi
1000ad91:	75 f3                	jne    0x1000ad86
1000ad93:	80 38 00             	cmp    BYTE PTR [eax],0x0
1000ad96:	5e                   	pop    esi
1000ad97:	75 05                	jne    0x1000ad9e
1000ad99:	2b 44 24 04          	sub    eax,DWORD PTR [esp+0x4]
1000ad9d:	c3                   	ret
1000ad9e:	8b c2                	mov    eax,edx
1000ada0:	c3                   	ret
1000ada1:	8b 54 24 04          	mov    edx,DWORD PTR [esp+0x4]
1000ada5:	56                   	push   esi
1000ada6:	8b 74 24 0c          	mov    esi,DWORD PTR [esp+0xc]
1000adaa:	33 c0                	xor    eax,eax
1000adac:	8d 0c 32             	lea    ecx,[edx+esi*1]
1000adaf:	3b ca                	cmp    ecx,edx
1000adb1:	72 04                	jb     0x1000adb7
1000adb3:	3b ce                	cmp    ecx,esi
1000adb5:	73 03                	jae    0x1000adba
1000adb7:	6a 01                	push   0x1
1000adb9:	58                   	pop    eax
1000adba:	8b 54 24 10          	mov    edx,DWORD PTR [esp+0x10]
1000adbe:	5e                   	pop    esi
1000adbf:	89 0a                	mov    DWORD PTR [edx],ecx
1000adc1:	c3                   	ret
1000adc2:	56                   	push   esi
1000adc3:	8b 74 24 08          	mov    esi,DWORD PTR [esp+0x8]
1000adc7:	57                   	push   edi
1000adc8:	8b 7c 24 10          	mov    edi,DWORD PTR [esp+0x10]
1000adcc:	56                   	push   esi
1000adcd:	ff 37                	push   DWORD PTR [edi]
1000adcf:	ff 36                	push   DWORD PTR [esi]
1000add1:	e8 cb ff ff ff       	call   0x1000ada1
1000add6:	83 c4 0c             	add    esp,0xc
1000add9:	85 c0                	test   eax,eax
1000addb:	74 17                	je     0x1000adf4
1000addd:	8d 46 04             	lea    eax,[esi+0x4]
1000ade0:	50                   	push   eax
1000ade1:	6a 01                	push   0x1
1000ade3:	ff 30                	push   DWORD PTR [eax]
1000ade5:	e8 b7 ff ff ff       	call   0x1000ada1
1000adea:	83 c4 0c             	add    esp,0xc
1000aded:	85 c0                	test   eax,eax
1000adef:	74 03                	je     0x1000adf4
1000adf1:	ff 46 08             	inc    DWORD PTR [esi+0x8]
1000adf4:	8d 46 04             	lea    eax,[esi+0x4]
1000adf7:	50                   	push   eax
1000adf8:	ff 77 04             	push   DWORD PTR [edi+0x4]
1000adfb:	ff 30                	push   DWORD PTR [eax]
1000adfd:	e8 9f ff ff ff       	call   0x1000ada1
1000ae02:	83 c4 0c             	add    esp,0xc
1000ae05:	85 c0                	test   eax,eax
1000ae07:	74 03                	je     0x1000ae0c
1000ae09:	ff 46 08             	inc    DWORD PTR [esi+0x8]
1000ae0c:	8d 46 08             	lea    eax,[esi+0x8]
1000ae0f:	50                   	push   eax
1000ae10:	ff 77 08             	push   DWORD PTR [edi+0x8]
1000ae13:	ff 30                	push   DWORD PTR [eax]
1000ae15:	e8 87 ff ff ff       	call   0x1000ada1
1000ae1a:	83 c4 0c             	add    esp,0xc
1000ae1d:	5f                   	pop    edi
1000ae1e:	5e                   	pop    esi
1000ae1f:	c3                   	ret
1000ae20:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
1000ae24:	56                   	push   esi
1000ae25:	57                   	push   edi
1000ae26:	8b 30                	mov    esi,DWORD PTR [eax]
1000ae28:	8b 78 04             	mov    edi,DWORD PTR [eax+0x4]
1000ae2b:	8b ce                	mov    ecx,esi
1000ae2d:	03 f6                	add    esi,esi
1000ae2f:	89 30                	mov    DWORD PTR [eax],esi
1000ae31:	8d 34 3f             	lea    esi,[edi+edi*1]
1000ae34:	c1 e9 1f             	shr    ecx,0x1f
1000ae37:	0b f1                	or     esi,ecx
1000ae39:	8b 48 08             	mov    ecx,DWORD PTR [eax+0x8]
1000ae3c:	8b d7                	mov    edx,edi
1000ae3e:	89 70 04             	mov    DWORD PTR [eax+0x4],esi
1000ae41:	c1 ea 1f             	shr    edx,0x1f
1000ae44:	d1 e1                	shl    ecx,1
1000ae46:	0b ca                	or     ecx,edx
1000ae48:	5f                   	pop    edi
1000ae49:	89 48 08             	mov    DWORD PTR [eax+0x8],ecx
1000ae4c:	5e                   	pop    esi
1000ae4d:	c3                   	ret
1000ae4e:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
1000ae52:	56                   	push   esi
1000ae53:	57                   	push   edi
1000ae54:	8b 50 08             	mov    edx,DWORD PTR [eax+0x8]
1000ae57:	8b 48 04             	mov    ecx,DWORD PTR [eax+0x4]
1000ae5a:	8b f2                	mov    esi,edx
1000ae5c:	8b f9                	mov    edi,ecx
1000ae5e:	c1 e6 1f             	shl    esi,0x1f
1000ae61:	d1 e9                	shr    ecx,1
1000ae63:	0b ce                	or     ecx,esi
1000ae65:	89 48 04             	mov    DWORD PTR [eax+0x4],ecx
1000ae68:	8b 08                	mov    ecx,DWORD PTR [eax]
1000ae6a:	c1 e7 1f             	shl    edi,0x1f
1000ae6d:	d1 e9                	shr    ecx,1
1000ae6f:	d1 ea                	shr    edx,1
1000ae71:	0b cf                	or     ecx,edi
1000ae73:	5f                   	pop    edi
1000ae74:	89 50 08             	mov    DWORD PTR [eax+0x8],edx
1000ae77:	89 08                	mov    DWORD PTR [eax],ecx
1000ae79:	5e                   	pop    esi
1000ae7a:	c3                   	ret
1000ae7b:	55                   	push   ebp
1000ae7c:	8b ec                	mov    ebp,esp
1000ae7e:	83 ec 10             	sub    esp,0x10
1000ae81:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
1000ae84:	53                   	push   ebx
1000ae85:	8b 5d 10             	mov    ebx,DWORD PTR [ebp+0x10]
1000ae88:	33 d2                	xor    edx,edx
1000ae8a:	3b c2                	cmp    eax,edx
1000ae8c:	56                   	push   esi
1000ae8d:	c7 45 fc 4e 40 00 00 	mov    DWORD PTR [ebp-0x4],0x404e
1000ae94:	89 13                	mov    DWORD PTR [ebx],edx
1000ae96:	89 53 04             	mov    DWORD PTR [ebx+0x4],edx
1000ae99:	89 53 08             	mov    DWORD PTR [ebx+0x8],edx
1000ae9c:	76 51                	jbe    0x1000aeef
1000ae9e:	57                   	push   edi
1000ae9f:	89 45 10             	mov    DWORD PTR [ebp+0x10],eax
1000aea2:	8b f3                	mov    esi,ebx
1000aea4:	8d 7d f0             	lea    edi,[ebp-0x10]
1000aea7:	a5                   	movs   DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000aea8:	a5                   	movs   DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000aea9:	53                   	push   ebx
1000aeaa:	a5                   	movs   DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000aeab:	e8 70 ff ff ff       	call   0x1000ae20
1000aeb0:	53                   	push   ebx
1000aeb1:	e8 6a ff ff ff       	call   0x1000ae20
1000aeb6:	8d 45 f0             	lea    eax,[ebp-0x10]
1000aeb9:	50                   	push   eax
1000aeba:	53                   	push   ebx
1000aebb:	e8 02 ff ff ff       	call   0x1000adc2
1000aec0:	53                   	push   ebx
1000aec1:	e8 5a ff ff ff       	call   0x1000ae20
1000aec6:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000aec9:	83 65 f4 00          	and    DWORD PTR [ebp-0xc],0x0
1000aecd:	83 65 f8 00          	and    DWORD PTR [ebp-0x8],0x0
1000aed1:	0f be 00             	movsx  eax,BYTE PTR [eax]
1000aed4:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax
1000aed7:	8d 45 f0             	lea    eax,[ebp-0x10]
1000aeda:	50                   	push   eax
1000aedb:	53                   	push   ebx
1000aedc:	e8 e1 fe ff ff       	call   0x1000adc2
1000aee1:	83 c4 1c             	add    esp,0x1c
1000aee4:	ff 45 08             	inc    DWORD PTR [ebp+0x8]
1000aee7:	ff 4d 10             	dec    DWORD PTR [ebp+0x10]
1000aeea:	75 b6                	jne    0x1000aea2
1000aeec:	33 d2                	xor    edx,edx
1000aeee:	5f                   	pop    edi
1000aeef:	39 53 08             	cmp    DWORD PTR [ebx+0x8],edx
1000aef2:	75 28                	jne    0x1000af1c
1000aef4:	8b 4b 04             	mov    ecx,DWORD PTR [ebx+0x4]
1000aef7:	8b c1                	mov    eax,ecx
1000aef9:	c1 e8 10             	shr    eax,0x10
1000aefc:	89 43 08             	mov    DWORD PTR [ebx+0x8],eax
1000aeff:	8b 03                	mov    eax,DWORD PTR [ebx]
1000af01:	8b f0                	mov    esi,eax
1000af03:	c1 ee 10             	shr    esi,0x10
1000af06:	c1 e1 10             	shl    ecx,0x10
1000af09:	0b f1                	or     esi,ecx
1000af0b:	c1 e0 10             	shl    eax,0x10
1000af0e:	81 45 fc f0 ff 00 00 	add    DWORD PTR [ebp-0x4],0xfff0
1000af15:	89 73 04             	mov    DWORD PTR [ebx+0x4],esi
1000af18:	89 03                	mov    DWORD PTR [ebx],eax
1000af1a:	eb d3                	jmp    0x1000aeef
1000af1c:	be 00 80 00 00       	mov    esi,0x8000
1000af21:	85 73 08             	test   DWORD PTR [ebx+0x8],esi
1000af24:	75 10                	jne    0x1000af36
1000af26:	53                   	push   ebx
1000af27:	e8 f4 fe ff ff       	call   0x1000ae20
1000af2c:	81 45 fc ff ff 00 00 	add    DWORD PTR [ebp-0x4],0xffff
1000af33:	59                   	pop    ecx
1000af34:	eb eb                	jmp    0x1000af21
1000af36:	66 8b 45 fc          	mov    ax,WORD PTR [ebp-0x4]
1000af3a:	5e                   	pop    esi
1000af3b:	66 89 43 0a          	mov    WORD PTR [ebx+0xa],ax
1000af3f:	5b                   	pop    ebx
1000af40:	c9                   	leave
1000af41:	c3                   	ret
1000af42:	55                   	push   ebp
1000af43:	8b ec                	mov    ebp,esp
1000af45:	83 ec 5c             	sub    esp,0x5c
1000af48:	53                   	push   ebx
1000af49:	56                   	push   esi
1000af4a:	57                   	push   edi
1000af4b:	8b 7d 10             	mov    edi,DWORD PTR [ebp+0x10]
1000af4e:	8d 45 a4             	lea    eax,[ebp-0x5c]
1000af51:	6a 01                	push   0x1
1000af53:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax
1000af56:	33 c0                	xor    eax,eax
1000af58:	5a                   	pop    edx
1000af59:	89 45 d8             	mov    DWORD PTR [ebp-0x28],eax
1000af5c:	89 55 e8             	mov    DWORD PTR [ebp-0x18],edx
1000af5f:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
1000af62:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax
1000af65:	89 45 dc             	mov    DWORD PTR [ebp-0x24],eax
1000af68:	89 45 e0             	mov    DWORD PTR [ebp-0x20],eax
1000af6b:	89 45 d4             	mov    DWORD PTR [ebp-0x2c],eax
1000af6e:	89 45 d0             	mov    DWORD PTR [ebp-0x30],eax
1000af71:	89 45 e4             	mov    DWORD PTR [ebp-0x1c],eax
1000af74:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
1000af77:	89 45 ec             	mov    DWORD PTR [ebp-0x14],eax
1000af7a:	89 7d 10             	mov    DWORD PTR [ebp+0x10],edi
1000af7d:	8a 0f                	mov    cl,BYTE PTR [edi]
1000af7f:	80 f9 20             	cmp    cl,0x20
1000af82:	74 0f                	je     0x1000af93
1000af84:	80 f9 09             	cmp    cl,0x9
1000af87:	74 0a                	je     0x1000af93
1000af89:	80 f9 0a             	cmp    cl,0xa
1000af8c:	74 05                	je     0x1000af93
1000af8e:	80 f9 0d             	cmp    cl,0xd
1000af91:	75 03                	jne    0x1000af96
1000af93:	47                   	inc    edi
1000af94:	eb e7                	jmp    0x1000af7d
1000af96:	6a 04                	push   0x4
1000af98:	5e                   	pop    esi
1000af99:	8a 1f                	mov    bl,BYTE PTR [edi]
1000af9b:	47                   	inc    edi
1000af9c:	83 f8 0b             	cmp    eax,0xb
1000af9f:	0f 87 77 02 00 00    	ja     0x1000b21c
1000afa5:	ff 24 85 e3 b3 00 10 	jmp    DWORD PTR [eax*4+0x1000b3e3]
1000afac:	80 fb 31             	cmp    bl,0x31
1000afaf:	7c 0c                	jl     0x1000afbd
1000afb1:	80 fb 39             	cmp    bl,0x39
1000afb4:	7f 07                	jg     0x1000afbd
1000afb6:	6a 03                	push   0x3
1000afb8:	e9 1d 02 00 00       	jmp    0x1000b1da
1000afbd:	3a 1d 98 ec 00 10    	cmp    bl,BYTE PTR ds:0x1000ec98
1000afc3:	75 07                	jne    0x1000afcc
1000afc5:	6a 05                	push   0x5
1000afc7:	e9 46 02 00 00       	jmp    0x1000b212
1000afcc:	0f be c3             	movsx  eax,bl
1000afcf:	83 e8 2b             	sub    eax,0x2b
1000afd2:	74 1e                	je     0x1000aff2
1000afd4:	48                   	dec    eax
1000afd5:	48                   	dec    eax
1000afd6:	74 0e                	je     0x1000afe6
1000afd8:	83 e8 03             	sub    eax,0x3
1000afdb:	0f 85 d4 02 00 00    	jne    0x1000b2b5
1000afe1:	e9 8f 00 00 00       	jmp    0x1000b075
1000afe6:	6a 02                	push   0x2
1000afe8:	c7 45 d8 00 80 00 00 	mov    DWORD PTR [ebp-0x28],0x8000
1000afef:	58                   	pop    eax
1000aff0:	eb a7                	jmp    0x1000af99
1000aff2:	83 65 d8 00          	and    DWORD PTR [ebp-0x28],0x0
1000aff6:	6a 02                	push   0x2
1000aff8:	58                   	pop    eax
1000aff9:	eb 9e                	jmp    0x1000af99
1000affb:	80 fb 31             	cmp    bl,0x31
1000affe:	89 55 f0             	mov    DWORD PTR [ebp-0x10],edx
1000b001:	7c 05                	jl     0x1000b008
1000b003:	80 fb 39             	cmp    bl,0x39
1000b006:	7e ae                	jle    0x1000afb6
1000b008:	3a 1d 98 ec 00 10    	cmp    bl,BYTE PTR ds:0x1000ec98
1000b00e:	0f 84 bc 00 00 00    	je     0x1000b0d0
1000b014:	80 fb 2b             	cmp    bl,0x2b
1000b017:	74 31                	je     0x1000b04a
1000b019:	80 fb 2d             	cmp    bl,0x2d
1000b01c:	74 2c                	je     0x1000b04a
1000b01e:	80 fb 30             	cmp    bl,0x30
1000b021:	74 52                	je     0x1000b075
1000b023:	80 fb 43             	cmp    bl,0x43
1000b026:	0f 8e 89 02 00 00    	jle    0x1000b2b5
1000b02c:	80 fb 45             	cmp    bl,0x45
1000b02f:	7e 12                	jle    0x1000b043
1000b031:	80 fb 63             	cmp    bl,0x63
1000b034:	0f 8e 7b 02 00 00    	jle    0x1000b2b5
1000b03a:	80 fb 65             	cmp    bl,0x65
1000b03d:	0f 8f 72 02 00 00    	jg     0x1000b2b5
1000b043:	6a 06                	push   0x6
1000b045:	e9 c8 01 00 00       	jmp    0x1000b212
1000b04a:	4f                   	dec    edi
1000b04b:	6a 0b                	push   0xb
1000b04d:	e9 c0 01 00 00       	jmp    0x1000b212
1000b052:	80 fb 31             	cmp    bl,0x31
1000b055:	7c 09                	jl     0x1000b060
1000b057:	80 fb 39             	cmp    bl,0x39
1000b05a:	0f 8e 56 ff ff ff    	jle    0x1000afb6
1000b060:	3a 1d 98 ec 00 10    	cmp    bl,BYTE PTR ds:0x1000ec98
1000b066:	0f 84 59 ff ff ff    	je     0x1000afc5
1000b06c:	80 fb 30             	cmp    bl,0x30
1000b06f:	0f 85 b5 01 00 00    	jne    0x1000b22a
1000b075:	8b c2                	mov    eax,edx
1000b077:	e9 1d ff ff ff       	jmp    0x1000af99
1000b07c:	89 55 f0             	mov    DWORD PTR [ebp-0x10],edx
1000b07f:	39 15 94 ec 00 10    	cmp    DWORD PTR ds:0x1000ec94,edx
1000b085:	7e 11                	jle    0x1000b098
1000b087:	0f b6 c3             	movzx  eax,bl
1000b08a:	56                   	push   esi
1000b08b:	50                   	push   eax
1000b08c:	e8 67 c0 ff ff       	call   0x100070f8
1000b091:	59                   	pop    ecx
1000b092:	59                   	pop    ecx
1000b093:	6a 01                	push   0x1
1000b095:	5a                   	pop    edx
1000b096:	eb 0e                	jmp    0x1000b0a6
1000b098:	8b 0d 88 ea 00 10    	mov    ecx,DWORD PTR ds:0x1000ea88
1000b09e:	0f b6 c3             	movzx  eax,bl
1000b0a1:	8a 04 41             	mov    al,BYTE PTR [ecx+eax*2]
1000b0a4:	23 c6                	and    eax,esi
1000b0a6:	85 c0                	test   eax,eax
1000b0a8:	74 1e                	je     0x1000b0c8
1000b0aa:	83 7d fc 19          	cmp    DWORD PTR [ebp-0x4],0x19
1000b0ae:	73 10                	jae    0x1000b0c0
1000b0b0:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
1000b0b3:	ff 45 fc             	inc    DWORD PTR [ebp-0x4]
1000b0b6:	80 eb 30             	sub    bl,0x30
1000b0b9:	ff 45 f4             	inc    DWORD PTR [ebp-0xc]
1000b0bc:	88 18                	mov    BYTE PTR [eax],bl
1000b0be:	eb 03                	jmp    0x1000b0c3
1000b0c0:	ff 45 f8             	inc    DWORD PTR [ebp-0x8]
1000b0c3:	8a 1f                	mov    bl,BYTE PTR [edi]
1000b0c5:	47                   	inc    edi
1000b0c6:	eb b7                	jmp    0x1000b07f
1000b0c8:	3a 1d 98 ec 00 10    	cmp    bl,BYTE PTR ds:0x1000ec98
1000b0ce:	75 67                	jne    0x1000b137
1000b0d0:	8b c6                	mov    eax,esi
1000b0d2:	e9 c2 fe ff ff       	jmp    0x1000af99
1000b0d7:	83 7d fc 00          	cmp    DWORD PTR [ebp-0x4],0x0
1000b0db:	89 55 f0             	mov    DWORD PTR [ebp-0x10],edx
1000b0de:	89 55 dc             	mov    DWORD PTR [ebp-0x24],edx
1000b0e1:	75 0d                	jne    0x1000b0f0
1000b0e3:	80 fb 30             	cmp    bl,0x30
1000b0e6:	75 08                	jne    0x1000b0f0
1000b0e8:	ff 4d f8             	dec    DWORD PTR [ebp-0x8]
1000b0eb:	8a 1f                	mov    bl,BYTE PTR [edi]
1000b0ed:	47                   	inc    edi
1000b0ee:	eb f3                	jmp    0x1000b0e3
1000b0f0:	39 15 94 ec 00 10    	cmp    DWORD PTR ds:0x1000ec94,edx
1000b0f6:	7e 11                	jle    0x1000b109
1000b0f8:	0f b6 c3             	movzx  eax,bl
1000b0fb:	56                   	push   esi
1000b0fc:	50                   	push   eax
1000b0fd:	e8 f6 bf ff ff       	call   0x100070f8
1000b102:	59                   	pop    ecx
1000b103:	59                   	pop    ecx
1000b104:	6a 01                	push   0x1
1000b106:	5a                   	pop    edx
1000b107:	eb 0e                	jmp    0x1000b117
1000b109:	8b 0d 88 ea 00 10    	mov    ecx,DWORD PTR ds:0x1000ea88
1000b10f:	0f b6 c3             	movzx  eax,bl
1000b112:	8a 04 41             	mov    al,BYTE PTR [ecx+eax*2]
1000b115:	23 c6                	and    eax,esi
1000b117:	85 c0                	test   eax,eax
1000b119:	74 1c                	je     0x1000b137
1000b11b:	83 7d fc 19          	cmp    DWORD PTR [ebp-0x4],0x19
1000b11f:	73 11                	jae    0x1000b132
1000b121:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
1000b124:	ff 45 fc             	inc    DWORD PTR [ebp-0x4]
1000b127:	80 eb 30             	sub    bl,0x30
1000b12a:	ff 45 f4             	inc    DWORD PTR [ebp-0xc]
1000b12d:	ff 4d f8             	dec    DWORD PTR [ebp-0x8]
1000b130:	88 18                	mov    BYTE PTR [eax],bl
1000b132:	8a 1f                	mov    bl,BYTE PTR [edi]
1000b134:	47                   	inc    edi
1000b135:	eb b9                	jmp    0x1000b0f0
1000b137:	80 fb 2b             	cmp    bl,0x2b
1000b13a:	0f 84 0a ff ff ff    	je     0x1000b04a
1000b140:	80 fb 2d             	cmp    bl,0x2d
1000b143:	0f 84 01 ff ff ff    	je     0x1000b04a
1000b149:	e9 d5 fe ff ff       	jmp    0x1000b023
1000b14e:	39 15 94 ec 00 10    	cmp    DWORD PTR ds:0x1000ec94,edx
1000b154:	89 55 dc             	mov    DWORD PTR [ebp-0x24],edx
1000b157:	7e 11                	jle    0x1000b16a
1000b159:	0f b6 c3             	movzx  eax,bl
1000b15c:	56                   	push   esi
1000b15d:	50                   	push   eax
1000b15e:	e8 95 bf ff ff       	call   0x100070f8
1000b163:	59                   	pop    ecx
1000b164:	59                   	pop    ecx
1000b165:	6a 01                	push   0x1
1000b167:	5a                   	pop    edx
1000b168:	eb 0e                	jmp    0x1000b178
1000b16a:	8b 0d 88 ea 00 10    	mov    ecx,DWORD PTR ds:0x1000ea88
1000b170:	0f b6 c3             	movzx  eax,bl
1000b173:	8a 04 41             	mov    al,BYTE PTR [ecx+eax*2]
1000b176:	23 c6                	and    eax,esi
1000b178:	85 c0                	test   eax,eax
1000b17a:	0f 84 aa 00 00 00    	je     0x1000b22a
1000b180:	8b c6                	mov    eax,esi
1000b182:	eb 57                	jmp    0x1000b1db
1000b184:	8d 4f fe             	lea    ecx,[edi-0x2]
1000b187:	80 fb 31             	cmp    bl,0x31
1000b18a:	89 4d 10             	mov    DWORD PTR [ebp+0x10],ecx
1000b18d:	7c 05                	jl     0x1000b194
1000b18f:	80 fb 39             	cmp    bl,0x39
1000b192:	7e 44                	jle    0x1000b1d8
1000b194:	0f be c3             	movsx  eax,bl
1000b197:	83 e8 2b             	sub    eax,0x2b
1000b19a:	74 74                	je     0x1000b210
1000b19c:	48                   	dec    eax
1000b19d:	48                   	dec    eax
1000b19e:	74 64                	je     0x1000b204
1000b1a0:	83 e8 03             	sub    eax,0x3
1000b1a3:	0f 85 0f 01 00 00    	jne    0x1000b2b8
1000b1a9:	6a 08                	push   0x8
1000b1ab:	eb 65                	jmp    0x1000b212
1000b1ad:	89 55 e0             	mov    DWORD PTR [ebp-0x20],edx
1000b1b0:	80 fb 30             	cmp    bl,0x30
1000b1b3:	75 05                	jne    0x1000b1ba
1000b1b5:	8a 1f                	mov    bl,BYTE PTR [edi]
1000b1b7:	47                   	inc    edi
1000b1b8:	eb f6                	jmp    0x1000b1b0
1000b1ba:	80 fb 31             	cmp    bl,0x31
1000b1bd:	0f 8c f2 00 00 00    	jl     0x1000b2b5
1000b1c3:	80 fb 39             	cmp    bl,0x39
1000b1c6:	0f 8f e9 00 00 00    	jg     0x1000b2b5
1000b1cc:	eb 0a                	jmp    0x1000b1d8
1000b1ce:	80 fb 31             	cmp    bl,0x31
1000b1d1:	7c 0e                	jl     0x1000b1e1
1000b1d3:	80 fb 39             	cmp    bl,0x39
1000b1d6:	7f 09                	jg     0x1000b1e1
1000b1d8:	6a 09                	push   0x9
1000b1da:	58                   	pop    eax
1000b1db:	4f                   	dec    edi
1000b1dc:	e9 b8 fd ff ff       	jmp    0x1000af99
1000b1e1:	80 fb 30             	cmp    bl,0x30
1000b1e4:	75 44                	jne    0x1000b22a
1000b1e6:	eb c1                	jmp    0x1000b1a9
1000b1e8:	83 7d 20 00          	cmp    DWORD PTR [ebp+0x20],0x0
1000b1ec:	74 2a                	je     0x1000b218
1000b1ee:	0f be c3             	movsx  eax,bl
1000b1f1:	8d 4f ff             	lea    ecx,[edi-0x1]
1000b1f4:	83 e8 2b             	sub    eax,0x2b
1000b1f7:	89 4d 10             	mov    DWORD PTR [ebp+0x10],ecx
1000b1fa:	74 14                	je     0x1000b210
1000b1fc:	48                   	dec    eax
1000b1fd:	48                   	dec    eax
1000b1fe:	0f 85 b4 00 00 00    	jne    0x1000b2b8
1000b204:	83 4d e8 ff          	or     DWORD PTR [ebp-0x18],0xffffffff
1000b208:	6a 07                	push   0x7
1000b20a:	58                   	pop    eax
1000b20b:	e9 89 fd ff ff       	jmp    0x1000af99
1000b210:	6a 07                	push   0x7
1000b212:	58                   	pop    eax
1000b213:	e9 81 fd ff ff       	jmp    0x1000af99
1000b218:	6a 0a                	push   0xa
1000b21a:	4f                   	dec    edi
1000b21b:	58                   	pop    eax
1000b21c:	83 f8 0a             	cmp    eax,0xa
1000b21f:	0f 84 95 00 00 00    	je     0x1000b2ba
1000b225:	e9 6f fd ff ff       	jmp    0x1000af99
1000b22a:	8b 7d 10             	mov    edi,DWORD PTR [ebp+0x10]
1000b22d:	e9 88 00 00 00       	jmp    0x1000b2ba
1000b232:	c7 45 e0 01 00 00 00 	mov    DWORD PTR [ebp-0x20],0x1
1000b239:	33 f6                	xor    esi,esi
1000b23b:	83 3d 94 ec 00 10 01 	cmp    DWORD PTR ds:0x1000ec94,0x1
1000b242:	7e 0f                	jle    0x1000b253
1000b244:	0f b6 c3             	movzx  eax,bl
1000b247:	6a 04                	push   0x4
1000b249:	50                   	push   eax
1000b24a:	e8 a9 be ff ff       	call   0x100070f8
1000b24f:	59                   	pop    ecx
1000b250:	59                   	pop    ecx
1000b251:	eb 0f                	jmp    0x1000b262
1000b253:	8b 0d 88 ea 00 10    	mov    ecx,DWORD PTR ds:0x1000ea88
1000b259:	0f b6 c3             	movzx  eax,bl
1000b25c:	8a 04 41             	mov    al,BYTE PTR [ecx+eax*2]
1000b25f:	83 e0 04             	and    eax,0x4
1000b262:	85 c0                	test   eax,eax
1000b264:	74 1c                	je     0x1000b282
1000b266:	0f be cb             	movsx  ecx,bl
1000b269:	8d 04 b6             	lea    eax,[esi+esi*4]
1000b26c:	8d 74 41 d0          	lea    esi,[ecx+eax*2-0x30]
1000b270:	81 fe 50 14 00 00    	cmp    esi,0x1450
1000b276:	7f 05                	jg     0x1000b27d
1000b278:	8a 1f                	mov    bl,BYTE PTR [edi]
1000b27a:	47                   	inc    edi
1000b27b:	eb be                	jmp    0x1000b23b
1000b27d:	be 51 14 00 00       	mov    esi,0x1451
1000b282:	89 75 e4             	mov    DWORD PTR [ebp-0x1c],esi
1000b285:	83 3d 94 ec 00 10 01 	cmp    DWORD PTR ds:0x1000ec94,0x1
1000b28c:	7e 0f                	jle    0x1000b29d
1000b28e:	0f b6 c3             	movzx  eax,bl
1000b291:	6a 04                	push   0x4
1000b293:	50                   	push   eax
1000b294:	e8 5f be ff ff       	call   0x100070f8
1000b299:	59                   	pop    ecx
1000b29a:	59                   	pop    ecx
1000b29b:	eb 0f                	jmp    0x1000b2ac
1000b29d:	8b 0d 88 ea 00 10    	mov    ecx,DWORD PTR ds:0x1000ea88
1000b2a3:	0f b6 c3             	movzx  eax,bl
1000b2a6:	8a 04 41             	mov    al,BYTE PTR [ecx+eax*2]
1000b2a9:	83 e0 04             	and    eax,0x4
1000b2ac:	85 c0                	test   eax,eax
1000b2ae:	74 05                	je     0x1000b2b5
1000b2b0:	8a 1f                	mov    bl,BYTE PTR [edi]
1000b2b2:	47                   	inc    edi
1000b2b3:	eb d0                	jmp    0x1000b285
1000b2b5:	4f                   	dec    edi
1000b2b6:	eb 02                	jmp    0x1000b2ba
1000b2b8:	8b f9                	mov    edi,ecx
1000b2ba:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
1000b2bd:	83 7d f0 00          	cmp    DWORD PTR [ebp-0x10],0x0
1000b2c1:	89 38                	mov    DWORD PTR [eax],edi
1000b2c3:	0f 84 d9 00 00 00    	je     0x1000b3a2
1000b2c9:	6a 18                	push   0x18
1000b2cb:	58                   	pop    eax
1000b2cc:	39 45 fc             	cmp    DWORD PTR [ebp-0x4],eax
1000b2cf:	76 15                	jbe    0x1000b2e6
1000b2d1:	80 7d bb 05          	cmp    BYTE PTR [ebp-0x45],0x5
1000b2d5:	7c 03                	jl     0x1000b2da
1000b2d7:	fe 45 bb             	inc    BYTE PTR [ebp-0x45]
1000b2da:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
1000b2dd:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
1000b2e0:	48                   	dec    eax
1000b2e1:	ff 45 f8             	inc    DWORD PTR [ebp-0x8]
1000b2e4:	eb 03                	jmp    0x1000b2e9
1000b2e6:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
1000b2e9:	83 7d fc 00          	cmp    DWORD PTR [ebp-0x4],0x0
1000b2ed:	0f 86 a5 00 00 00    	jbe    0x1000b398
1000b2f3:	48                   	dec    eax
1000b2f4:	80 38 00             	cmp    BYTE PTR [eax],0x0
1000b2f7:	75 08                	jne    0x1000b301
1000b2f9:	ff 4d fc             	dec    DWORD PTR [ebp-0x4]
1000b2fc:	ff 45 f8             	inc    DWORD PTR [ebp-0x8]
1000b2ff:	eb f2                	jmp    0x1000b2f3
1000b301:	8d 45 c0             	lea    eax,[ebp-0x40]
1000b304:	50                   	push   eax
1000b305:	8d 45 a4             	lea    eax,[ebp-0x5c]
1000b308:	ff 75 fc             	push   DWORD PTR [ebp-0x4]
1000b30b:	50                   	push   eax
1000b30c:	e8 6a fb ff ff       	call   0x1000ae7b
1000b311:	8b 45 e4             	mov    eax,DWORD PTR [ebp-0x1c]
1000b314:	33 c9                	xor    ecx,ecx
1000b316:	83 c4 0c             	add    esp,0xc
1000b319:	39 4d e8             	cmp    DWORD PTR [ebp-0x18],ecx
1000b31c:	7d 02                	jge    0x1000b320
1000b31e:	f7 d8                	neg    eax
1000b320:	03 45 f8             	add    eax,DWORD PTR [ebp-0x8]
1000b323:	39 4d e0             	cmp    DWORD PTR [ebp-0x20],ecx
1000b326:	75 03                	jne    0x1000b32b
1000b328:	03 45 18             	add    eax,DWORD PTR [ebp+0x18]
1000b32b:	39 4d dc             	cmp    DWORD PTR [ebp-0x24],ecx
1000b32e:	75 03                	jne    0x1000b333
1000b330:	2b 45 1c             	sub    eax,DWORD PTR [ebp+0x1c]
1000b333:	3d 50 14 00 00       	cmp    eax,0x1450
1000b338:	7e 30                	jle    0x1000b36a
1000b33a:	c7 45 d4 01 00 00 00 	mov    DWORD PTR [ebp-0x2c],0x1
1000b341:	8b 5d 10             	mov    ebx,DWORD PTR [ebp+0x10]
1000b344:	8b 75 10             	mov    esi,DWORD PTR [ebp+0x10]
1000b347:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
1000b34a:	8b 55 10             	mov    edx,DWORD PTR [ebp+0x10]
1000b34d:	83 7d d4 00          	cmp    DWORD PTR [ebp-0x2c],0x0
1000b351:	74 60                	je     0x1000b3b3
1000b353:	33 db                	xor    ebx,ebx
1000b355:	b8 ff 7f 00 00       	mov    eax,0x7fff
1000b35a:	be 00 00 00 80       	mov    esi,0x80000000
1000b35f:	33 d2                	xor    edx,edx
1000b361:	c7 45 ec 02 00 00 00 	mov    DWORD PTR [ebp-0x14],0x2
1000b368:	eb 5e                	jmp    0x1000b3c8
1000b36a:	3d b0 eb ff ff       	cmp    eax,0xffffebb0
1000b36f:	7d 09                	jge    0x1000b37a
1000b371:	c7 45 d0 01 00 00 00 	mov    DWORD PTR [ebp-0x30],0x1
1000b378:	eb c7                	jmp    0x1000b341
1000b37a:	ff 75 14             	push   DWORD PTR [ebp+0x14]
1000b37d:	50                   	push   eax
1000b37e:	8d 45 c0             	lea    eax,[ebp-0x40]
1000b381:	50                   	push   eax
1000b382:	e8 da 0c 00 00       	call   0x1000c061
1000b387:	8b 55 c0             	mov    edx,DWORD PTR [ebp-0x40]
1000b38a:	8b 5d c2             	mov    ebx,DWORD PTR [ebp-0x3e]
1000b38d:	8b 75 c6             	mov    esi,DWORD PTR [ebp-0x3a]
1000b390:	8b 45 ca             	mov    eax,DWORD PTR [ebp-0x36]
1000b393:	83 c4 0c             	add    esp,0xc
1000b396:	eb b5                	jmp    0x1000b34d
1000b398:	33 d2                	xor    edx,edx
1000b39a:	33 c0                	xor    eax,eax
1000b39c:	33 f6                	xor    esi,esi
1000b39e:	33 db                	xor    ebx,ebx
1000b3a0:	eb ab                	jmp    0x1000b34d
1000b3a2:	33 d2                	xor    edx,edx
1000b3a4:	33 c0                	xor    eax,eax
1000b3a6:	33 f6                	xor    esi,esi
1000b3a8:	33 db                	xor    ebx,ebx
1000b3aa:	c7 45 ec 04 00 00 00 	mov    DWORD PTR [ebp-0x14],0x4
1000b3b1:	eb 15                	jmp    0x1000b3c8
1000b3b3:	83 7d d0 00          	cmp    DWORD PTR [ebp-0x30],0x0
1000b3b7:	74 0f                	je     0x1000b3c8
1000b3b9:	33 d2                	xor    edx,edx
1000b3bb:	33 c0                	xor    eax,eax
1000b3bd:	33 f6                	xor    esi,esi
1000b3bf:	33 db                	xor    ebx,ebx
1000b3c1:	c7 45 ec 01 00 00 00 	mov    DWORD PTR [ebp-0x14],0x1
1000b3c8:	8b 4d 08             	mov    ecx,DWORD PTR [ebp+0x8]
1000b3cb:	0b 45 d8             	or     eax,DWORD PTR [ebp-0x28]
1000b3ce:	5f                   	pop    edi
1000b3cf:	89 71 06             	mov    DWORD PTR [ecx+0x6],esi
1000b3d2:	89 59 02             	mov    DWORD PTR [ecx+0x2],ebx
1000b3d5:	66 89 41 0a          	mov    WORD PTR [ecx+0xa],ax
1000b3d9:	8b 45 ec             	mov    eax,DWORD PTR [ebp-0x14]
1000b3dc:	5e                   	pop    esi
1000b3dd:	66 89 11             	mov    WORD PTR [ecx],dx
1000b3e0:	5b                   	pop    ebx
1000b3e1:	c9                   	leave
1000b3e2:	c3                   	ret
1000b3e3:	ac                   	lods   al,BYTE PTR ds:[esi]
1000b3e4:	af                   	scas   eax,DWORD PTR es:[edi]
1000b3e5:	00 10                	add    BYTE PTR [eax],dl
1000b3e7:	fb                   	sti
1000b3e8:	af                   	scas   eax,DWORD PTR es:[edi]
1000b3e9:	00 10                	add    BYTE PTR [eax],dl
1000b3eb:	52                   	push   edx
1000b3ec:	b0 00                	mov    al,0x0
1000b3ee:	10 7c b0 00          	adc    BYTE PTR [eax+esi*4+0x0],bh
1000b3f2:	10 d7                	adc    bh,dl
1000b3f4:	b0 00                	mov    al,0x0
1000b3f6:	10 4e b1             	adc    BYTE PTR [esi-0x4f],cl
1000b3f9:	00 10                	add    BYTE PTR [eax],dl
1000b3fb:	84 b1 00 10 ce b1    	test   BYTE PTR [ecx-0x4e31f000],dh
1000b401:	00 10                	add    BYTE PTR [eax],dl
1000b403:	ad                   	lods   eax,DWORD PTR ds:[esi]
1000b404:	b1 00                	mov    cl,0x0
1000b406:	10 32                	adc    BYTE PTR [edx],dh
1000b408:	b2 00                	mov    dl,0x0
1000b40a:	10 1c b2             	adc    BYTE PTR [edx+esi*4],bl
1000b40d:	00 10                	add    BYTE PTR [eax],dl
1000b40f:	e8 b1 00 10 55       	call   0x6510b4c5
1000b414:	8b ec                	mov    ebp,esp
1000b416:	83 ec 0c             	sub    esp,0xc
1000b419:	33 c0                	xor    eax,eax
1000b41b:	56                   	push   esi
1000b41c:	50                   	push   eax
1000b41d:	50                   	push   eax
1000b41e:	50                   	push   eax
1000b41f:	8d 45 f4             	lea    eax,[ebp-0xc]
1000b422:	ff 75 14             	push   DWORD PTR [ebp+0x14]
1000b425:	ff 75 10             	push   DWORD PTR [ebp+0x10]
1000b428:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
1000b42b:	50                   	push   eax
1000b42c:	e8 11 fb ff ff       	call   0x1000af42
1000b431:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000b434:	8b f0                	mov    esi,eax
1000b436:	8d 45 f4             	lea    eax,[ebp-0xc]
1000b439:	50                   	push   eax
1000b43a:	e8 4a cd ff ff       	call   0x10008189
1000b43f:	83 c4 24             	add    esp,0x24
1000b442:	83 f8 01             	cmp    eax,0x1
1000b445:	75 03                	jne    0x1000b44a
1000b447:	83 ce 02             	or     esi,0x2
1000b44a:	8b c6                	mov    eax,esi
1000b44c:	5e                   	pop    esi
1000b44d:	c9                   	leave
1000b44e:	c3                   	ret
1000b44f:	55                   	push   ebp
1000b450:	8b ec                	mov    ebp,esp
1000b452:	83 ec 1c             	sub    esp,0x1c
1000b455:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
1000b458:	53                   	push   ebx
1000b459:	8b 5d 1c             	mov    ebx,DWORD PTR [ebp+0x1c]
1000b45c:	56                   	push   esi
1000b45d:	8b c8                	mov    ecx,eax
1000b45f:	be ff 7f 00 00       	mov    esi,0x7fff
1000b464:	81 e1 00 80 00 00    	and    ecx,0x8000
1000b46a:	23 c6                	and    eax,esi
1000b46c:	66 85 c9             	test   cx,cx
1000b46f:	57                   	push   edi
1000b470:	c6 45 e4 cc          	mov    BYTE PTR [ebp-0x1c],0xcc
1000b474:	c6 45 e5 cc          	mov    BYTE PTR [ebp-0x1b],0xcc
1000b478:	c6 45 e6 cc          	mov    BYTE PTR [ebp-0x1a],0xcc
1000b47c:	c6 45 e7 cc          	mov    BYTE PTR [ebp-0x19],0xcc
1000b480:	c6 45 e8 cc          	mov    BYTE PTR [ebp-0x18],0xcc
1000b484:	c6 45 e9 cc          	mov    BYTE PTR [ebp-0x17],0xcc
1000b488:	c6 45 ea cc          	mov    BYTE PTR [ebp-0x16],0xcc
1000b48c:	c6 45 eb cc          	mov    BYTE PTR [ebp-0x15],0xcc
1000b490:	c6 45 ec cc          	mov    BYTE PTR [ebp-0x14],0xcc
1000b494:	c6 45 ed cc          	mov    BYTE PTR [ebp-0x13],0xcc
1000b498:	c6 45 ee fb          	mov    BYTE PTR [ebp-0x12],0xfb
1000b49c:	c6 45 ef 3f          	mov    BYTE PTR [ebp-0x11],0x3f
1000b4a0:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [ebp-0x4],0x1
1000b4a7:	8b d0                	mov    edx,eax
1000b4a9:	74 06                	je     0x1000b4b1
1000b4ab:	c6 43 02 2d          	mov    BYTE PTR [ebx+0x2],0x2d
1000b4af:	eb 04                	jmp    0x1000b4b5
1000b4b1:	c6 43 02 20          	mov    BYTE PTR [ebx+0x2],0x20
1000b4b5:	8b 7d 0c             	mov    edi,DWORD PTR [ebp+0xc]
1000b4b8:	66 85 d2             	test   dx,dx
1000b4bb:	75 1e                	jne    0x1000b4db
1000b4bd:	85 ff                	test   edi,edi
1000b4bf:	75 1a                	jne    0x1000b4db
1000b4c1:	39 7d 08             	cmp    DWORD PTR [ebp+0x8],edi
1000b4c4:	75 15                	jne    0x1000b4db
1000b4c6:	66 83 23 00          	and    WORD PTR [ebx],0x0
1000b4ca:	c6 43 02 20          	mov    BYTE PTR [ebx+0x2],0x20
1000b4ce:	c6 43 03 01          	mov    BYTE PTR [ebx+0x3],0x1
1000b4d2:	c6 43 04 30          	mov    BYTE PTR [ebx+0x4],0x30
1000b4d6:	e9 fe 01 00 00       	jmp    0x1000b6d9
1000b4db:	66 3b d6             	cmp    dx,si
1000b4de:	75 7a                	jne    0x1000b55a
1000b4e0:	b8 00 00 00 80       	mov    eax,0x80000000
1000b4e5:	66 c7 03 01 00       	mov    WORD PTR [ebx],0x1
1000b4ea:	3b f8                	cmp    edi,eax
1000b4ec:	75 06                	jne    0x1000b4f4
1000b4ee:	83 7d 08 00          	cmp    DWORD PTR [ebp+0x8],0x0
1000b4f2:	74 0f                	je     0x1000b503
1000b4f4:	f7 c7 00 00 00 40    	test   edi,0x40000000
1000b4fa:	75 07                	jne    0x1000b503
1000b4fc:	68 10 d6 00 10       	push   0x1000d610
1000b501:	eb 46                	jmp    0x1000b549
1000b503:	66 85 c9             	test   cx,cx
1000b506:	74 15                	je     0x1000b51d
1000b508:	81 ff 00 00 00 c0    	cmp    edi,0xc0000000
1000b50e:	75 0d                	jne    0x1000b51d
1000b510:	83 7d 08 00          	cmp    DWORD PTR [ebp+0x8],0x0
1000b514:	75 2e                	jne    0x1000b544
1000b516:	68 08 d6 00 10       	push   0x1000d608
1000b51b:	eb 0f                	jmp    0x1000b52c
1000b51d:	3b f8                	cmp    edi,eax
1000b51f:	75 23                	jne    0x1000b544
1000b521:	83 7d 08 00          	cmp    DWORD PTR [ebp+0x8],0x0
1000b525:	75 1d                	jne    0x1000b544
1000b527:	68 00 d6 00 10       	push   0x1000d600
1000b52c:	8d 43 04             	lea    eax,[ebx+0x4]
1000b52f:	50                   	push   eax
1000b530:	e8 5b cd ff ff       	call   0x10008290
1000b535:	59                   	pop    ecx
1000b536:	c6 43 03 05          	mov    BYTE PTR [ebx+0x3],0x5
1000b53a:	59                   	pop    ecx
1000b53b:	83 65 fc 00          	and    DWORD PTR [ebp-0x4],0x0
1000b53f:	e9 6e 01 00 00       	jmp    0x1000b6b2
1000b544:	68 f8 d5 00 10       	push   0x1000d5f8
1000b549:	8d 43 04             	lea    eax,[ebx+0x4]
1000b54c:	50                   	push   eax
1000b54d:	e8 3e cd ff ff       	call   0x10008290
1000b552:	59                   	pop    ecx
1000b553:	c6 43 03 06          	mov    BYTE PTR [ebx+0x3],0x6
1000b557:	59                   	pop    ecx
1000b558:	eb e1                	jmp    0x1000b53b
1000b55a:	0f b7 c2             	movzx  eax,dx
1000b55d:	8b cf                	mov    ecx,edi
1000b55f:	8b f0                	mov    esi,eax
1000b561:	c1 e9 18             	shr    ecx,0x18
1000b564:	69 c0 10 4d 00 00    	imul   eax,eax,0x4d10
1000b56a:	c1 ee 08             	shr    esi,0x8
1000b56d:	66 83 65 f0 00       	and    WORD PTR [ebp-0x10],0x0
1000b572:	6a 01                	push   0x1
1000b574:	8d 0c 4e             	lea    ecx,[esi+ecx*2]
1000b577:	66 89 55 fa          	mov    WORD PTR [ebp-0x6],dx
1000b57b:	6b c9 4d             	imul   ecx,ecx,0x4d
1000b57e:	89 7d f6             	mov    DWORD PTR [ebp-0xa],edi
1000b581:	8d b4 01 0c ed bc ec 	lea    esi,[ecx+eax*1-0x134312f4]
1000b588:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000b58b:	c1 fe 10             	sar    esi,0x10
1000b58e:	89 45 f2             	mov    DWORD PTR [ebp-0xe],eax
1000b591:	0f bf c6             	movsx  eax,si
1000b594:	f7 d8                	neg    eax
1000b596:	50                   	push   eax
1000b597:	8d 45 f0             	lea    eax,[ebp-0x10]
1000b59a:	50                   	push   eax
1000b59b:	e8 c1 0a 00 00       	call   0x1000c061
1000b5a0:	83 c4 0c             	add    esp,0xc
1000b5a3:	66 81 7d fa ff 3f    	cmp    WORD PTR [ebp-0x6],0x3fff
1000b5a9:	72 10                	jb     0x1000b5bb
1000b5ab:	8d 45 e4             	lea    eax,[ebp-0x1c]
1000b5ae:	46                   	inc    esi
1000b5af:	50                   	push   eax
1000b5b0:	8d 45 f0             	lea    eax,[ebp-0x10]
1000b5b3:	50                   	push   eax
1000b5b4:	e8 88 08 00 00       	call   0x1000be41
1000b5b9:	59                   	pop    ecx
1000b5ba:	59                   	pop    ecx
1000b5bb:	f6 45 18 01          	test   BYTE PTR [ebp+0x18],0x1
1000b5bf:	66 89 33             	mov    WORD PTR [ebx],si
1000b5c2:	74 11                	je     0x1000b5d5
1000b5c4:	8b 7d 14             	mov    edi,DWORD PTR [ebp+0x14]
1000b5c7:	0f bf c6             	movsx  eax,si
1000b5ca:	03 f8                	add    edi,eax
1000b5cc:	85 ff                	test   edi,edi
1000b5ce:	7f 08                	jg     0x1000b5d8
1000b5d0:	e9 f1 fe ff ff       	jmp    0x1000b4c6
1000b5d5:	8b 7d 14             	mov    edi,DWORD PTR [ebp+0x14]
1000b5d8:	83 ff 15             	cmp    edi,0x15
1000b5db:	7e 03                	jle    0x1000b5e0
1000b5dd:	6a 15                	push   0x15
1000b5df:	5f                   	pop    edi
1000b5e0:	0f b7 75 fa          	movzx  esi,WORD PTR [ebp-0x6]
1000b5e4:	81 ee fe 3f 00 00    	sub    esi,0x3ffe
1000b5ea:	66 83 65 fa 00       	and    WORD PTR [ebp-0x6],0x0
1000b5ef:	c7 45 1c 08 00 00 00 	mov    DWORD PTR [ebp+0x1c],0x8
1000b5f6:	8d 45 f0             	lea    eax,[ebp-0x10]
1000b5f9:	50                   	push   eax
1000b5fa:	e8 21 f8 ff ff       	call   0x1000ae20
1000b5ff:	ff 4d 1c             	dec    DWORD PTR [ebp+0x1c]
1000b602:	59                   	pop    ecx
1000b603:	75 f1                	jne    0x1000b5f6
1000b605:	85 f6                	test   esi,esi
1000b607:	7d 17                	jge    0x1000b620
1000b609:	f7 de                	neg    esi
1000b60b:	81 e6 ff 00 00 00    	and    esi,0xff
1000b611:	7e 0d                	jle    0x1000b620
1000b613:	8d 45 f0             	lea    eax,[ebp-0x10]
1000b616:	50                   	push   eax
1000b617:	e8 32 f8 ff ff       	call   0x1000ae4e
1000b61c:	4e                   	dec    esi
1000b61d:	59                   	pop    ecx
1000b61e:	75 f3                	jne    0x1000b613
1000b620:	8d 4f 01             	lea    ecx,[edi+0x1]
1000b623:	8d 43 04             	lea    eax,[ebx+0x4]
1000b626:	85 c9                	test   ecx,ecx
1000b628:	89 45 1c             	mov    DWORD PTR [ebp+0x1c],eax
1000b62b:	7e 50                	jle    0x1000b67d
1000b62d:	89 4d 14             	mov    DWORD PTR [ebp+0x14],ecx
1000b630:	8d 75 f0             	lea    esi,[ebp-0x10]
1000b633:	8d 7d 08             	lea    edi,[ebp+0x8]
1000b636:	a5                   	movs   DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000b637:	a5                   	movs   DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000b638:	8d 45 f0             	lea    eax,[ebp-0x10]
1000b63b:	50                   	push   eax
1000b63c:	a5                   	movs   DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000b63d:	e8 de f7 ff ff       	call   0x1000ae20
1000b642:	8d 45 f0             	lea    eax,[ebp-0x10]
1000b645:	50                   	push   eax
1000b646:	e8 d5 f7 ff ff       	call   0x1000ae20
1000b64b:	8d 45 08             	lea    eax,[ebp+0x8]
1000b64e:	50                   	push   eax
1000b64f:	8d 45 f0             	lea    eax,[ebp-0x10]
1000b652:	50                   	push   eax
1000b653:	e8 6a f7 ff ff       	call   0x1000adc2
1000b658:	8d 45 f0             	lea    eax,[ebp-0x10]
1000b65b:	50                   	push   eax
1000b65c:	e8 bf f7 ff ff       	call   0x1000ae20
1000b661:	8a 45 fb             	mov    al,BYTE PTR [ebp-0x5]
1000b664:	8b 4d 1c             	mov    ecx,DWORD PTR [ebp+0x1c]
1000b667:	80 65 fb 00          	and    BYTE PTR [ebp-0x5],0x0
1000b66b:	83 c4 14             	add    esp,0x14
1000b66e:	04 30                	add    al,0x30
1000b670:	ff 45 1c             	inc    DWORD PTR [ebp+0x1c]
1000b673:	ff 4d 14             	dec    DWORD PTR [ebp+0x14]
1000b676:	88 01                	mov    BYTE PTR [ecx],al
1000b678:	75 b6                	jne    0x1000b630
1000b67a:	8b 45 1c             	mov    eax,DWORD PTR [ebp+0x1c]
1000b67d:	8a 48 ff             	mov    cl,BYTE PTR [eax-0x1]
1000b680:	48                   	dec    eax
1000b681:	48                   	dec    eax
1000b682:	80 f9 35             	cmp    cl,0x35
1000b685:	8d 4b 04             	lea    ecx,[ebx+0x4]
1000b688:	7c 30                	jl     0x1000b6ba
1000b68a:	3b c1                	cmp    eax,ecx
1000b68c:	72 0f                	jb     0x1000b69d
1000b68e:	80 38 39             	cmp    BYTE PTR [eax],0x39
1000b691:	75 06                	jne    0x1000b699
1000b693:	c6 00 30             	mov    BYTE PTR [eax],0x30
1000b696:	48                   	dec    eax
1000b697:	eb f1                	jmp    0x1000b68a
1000b699:	3b c1                	cmp    eax,ecx
1000b69b:	73 04                	jae    0x1000b6a1
1000b69d:	40                   	inc    eax
1000b69e:	66 ff 03             	inc    WORD PTR [ebx]
1000b6a1:	fe 00                	inc    BYTE PTR [eax]
1000b6a3:	2a c3                	sub    al,bl
1000b6a5:	2c 03                	sub    al,0x3
1000b6a7:	88 43 03             	mov    BYTE PTR [ebx+0x3],al
1000b6aa:	0f be c0             	movsx  eax,al
1000b6ad:	80 64 18 04 00       	and    BYTE PTR [eax+ebx*1+0x4],0x0
1000b6b2:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
1000b6b5:	5f                   	pop    edi
1000b6b6:	5e                   	pop    esi
1000b6b7:	5b                   	pop    ebx
1000b6b8:	c9                   	leave
1000b6b9:	c3                   	ret
1000b6ba:	3b c1                	cmp    eax,ecx
1000b6bc:	72 0c                	jb     0x1000b6ca
1000b6be:	80 38 30             	cmp    BYTE PTR [eax],0x30
1000b6c1:	75 03                	jne    0x1000b6c6
1000b6c3:	48                   	dec    eax
1000b6c4:	eb f4                	jmp    0x1000b6ba
1000b6c6:	3b c1                	cmp    eax,ecx
1000b6c8:	73 d9                	jae    0x1000b6a3
1000b6ca:	66 83 23 00          	and    WORD PTR [ebx],0x0
1000b6ce:	c6 43 02 20          	mov    BYTE PTR [ebx+0x2],0x20
1000b6d2:	c6 43 03 01          	mov    BYTE PTR [ebx+0x3],0x1
1000b6d6:	c6 01 30             	mov    BYTE PTR [ecx],0x30
1000b6d9:	80 63 05 00          	and    BYTE PTR [ebx+0x5],0x0
1000b6dd:	6a 01                	push   0x1
1000b6df:	58                   	pop    eax
1000b6e0:	eb d3                	jmp    0x1000b6b5
1000b6e2:	8b 4c 24 04          	mov    ecx,DWORD PTR [esp+0x4]
1000b6e6:	33 d2                	xor    edx,edx
1000b6e8:	89 0d 50 f6 00 10    	mov    DWORD PTR ds:0x1000f650,ecx
1000b6ee:	b8 88 f1 00 10       	mov    eax,0x1000f188
1000b6f3:	3b 08                	cmp    ecx,DWORD PTR [eax]
1000b6f5:	74 20                	je     0x1000b717
1000b6f7:	83 c0 08             	add    eax,0x8
1000b6fa:	42                   	inc    edx
1000b6fb:	3d f0 f2 00 10       	cmp    eax,0x1000f2f0
1000b700:	7c f1                	jl     0x1000b6f3
1000b702:	83 f9 13             	cmp    ecx,0x13
1000b705:	72 1d                	jb     0x1000b724
1000b707:	83 f9 24             	cmp    ecx,0x24
1000b70a:	77 18                	ja     0x1000b724
1000b70c:	c7 05 4c f6 00 10 0d 	mov    DWORD PTR ds:0x1000f64c,0xd
1000b713:	00 00 00 
1000b716:	c3                   	ret
1000b717:	8b 04 d5 8c f1 00 10 	mov    eax,DWORD PTR [edx*8+0x1000f18c]
1000b71e:	a3 4c f6 00 10       	mov    ds:0x1000f64c,eax
1000b723:	c3                   	ret
1000b724:	81 f9 bc 00 00 00    	cmp    ecx,0xbc
1000b72a:	72 12                	jb     0x1000b73e
1000b72c:	81 f9 ca 00 00 00    	cmp    ecx,0xca
1000b732:	c7 05 4c f6 00 10 08 	mov    DWORD PTR ds:0x1000f64c,0x8
1000b739:	00 00 00 
1000b73c:	76 0a                	jbe    0x1000b748
1000b73e:	c7 05 4c f6 00 10 16 	mov    DWORD PTR ds:0x1000f64c,0x16
1000b745:	00 00 00 
1000b748:	c3                   	ret
1000b749:	53                   	push   ebx
1000b74a:	56                   	push   esi
1000b74b:	57                   	push   edi
1000b74c:	83 cb ff             	or     ebx,0xffffffff
1000b74f:	33 ff                	xor    edi,edi
1000b751:	33 f6                	xor    esi,esi
1000b753:	b9 a0 0a 01 10       	mov    ecx,0x10010aa0
1000b758:	8b 01                	mov    eax,DWORD PTR [ecx]
1000b75a:	85 c0                	test   eax,eax
1000b75c:	74 37                	je     0x1000b795
1000b75e:	8d 90 00 01 00 00    	lea    edx,[eax+0x100]
1000b764:	3b c2                	cmp    eax,edx
1000b766:	73 1c                	jae    0x1000b784
1000b768:	f6 40 04 01          	test   BYTE PTR [eax+0x4],0x1
1000b76c:	74 05                	je     0x1000b773
1000b76e:	83 c0 08             	add    eax,0x8
1000b771:	eb f1                	jmp    0x1000b764
1000b773:	83 08 ff             	or     DWORD PTR [eax],0xffffffff
1000b776:	2b 01                	sub    eax,DWORD PTR [ecx]
1000b778:	c1 f8 03             	sar    eax,0x3
1000b77b:	03 c6                	add    eax,esi
1000b77d:	8b d8                	mov    ebx,eax
1000b77f:	83 fb ff             	cmp    ebx,0xffffffff
1000b782:	75 54                	jne    0x1000b7d8
1000b784:	83 c1 04             	add    ecx,0x4
1000b787:	47                   	inc    edi
1000b788:	83 c6 20             	add    esi,0x20
1000b78b:	81 f9 a0 0b 01 10    	cmp    ecx,0x10010ba0
1000b791:	7c c5                	jl     0x1000b758
1000b793:	eb 43                	jmp    0x1000b7d8
1000b795:	be 00 01 00 00       	mov    esi,0x100
1000b79a:	56                   	push   esi
1000b79b:	e8 b9 a6 ff ff       	call   0x10005e59
1000b7a0:	85 c0                	test   eax,eax
1000b7a2:	59                   	pop    ecx
1000b7a3:	74 33                	je     0x1000b7d8
1000b7a5:	83 05 a0 0b 01 10 20 	add    DWORD PTR ds:0x10010ba0,0x20
1000b7ac:	8d 0c bd a0 0a 01 10 	lea    ecx,[edi*4+0x10010aa0]
1000b7b3:	8d 90 00 01 00 00    	lea    edx,[eax+0x100]
1000b7b9:	89 01                	mov    DWORD PTR [ecx],eax
1000b7bb:	3b c2                	cmp    eax,edx
1000b7bd:	73 14                	jae    0x1000b7d3
1000b7bf:	80 60 04 00          	and    BYTE PTR [eax+0x4],0x0
1000b7c3:	83 08 ff             	or     DWORD PTR [eax],0xffffffff
1000b7c6:	c6 40 05 0a          	mov    BYTE PTR [eax+0x5],0xa
1000b7ca:	8b 11                	mov    edx,DWORD PTR [ecx]
1000b7cc:	83 c0 08             	add    eax,0x8
1000b7cf:	03 d6                	add    edx,esi
1000b7d1:	eb e8                	jmp    0x1000b7bb
1000b7d3:	c1 e7 05             	shl    edi,0x5
1000b7d6:	8b df                	mov    ebx,edi
1000b7d8:	5f                   	pop    edi
1000b7d9:	8b c3                	mov    eax,ebx
1000b7db:	5e                   	pop    esi
1000b7dc:	5b                   	pop    ebx
1000b7dd:	c3                   	ret
1000b7de:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
1000b7e2:	56                   	push   esi
1000b7e3:	3b 05 a0 0b 01 10    	cmp    eax,DWORD PTR ds:0x10010ba0
1000b7e9:	57                   	push   edi
1000b7ea:	73 52                	jae    0x1000b83e
1000b7ec:	8b c8                	mov    ecx,eax
1000b7ee:	8b f0                	mov    esi,eax
1000b7f0:	c1 f9 05             	sar    ecx,0x5
1000b7f3:	83 e6 1f             	and    esi,0x1f
1000b7f6:	8d 3c 8d a0 0a 01 10 	lea    edi,[ecx*4+0x10010aa0]
1000b7fd:	c1 e6 03             	shl    esi,0x3
1000b800:	8b 0f                	mov    ecx,DWORD PTR [edi]
1000b802:	83 3c 31 ff          	cmp    DWORD PTR [ecx+esi*1],0xffffffff
1000b806:	75 36                	jne    0x1000b83e
1000b808:	83 3d 28 f6 00 10 01 	cmp    DWORD PTR ds:0x1000f628,0x1
1000b80f:	53                   	push   ebx
1000b810:	8b 5c 24 14          	mov    ebx,DWORD PTR [esp+0x14]
1000b814:	75 1e                	jne    0x1000b834
1000b816:	83 e8 00             	sub    eax,0x0
1000b819:	74 10                	je     0x1000b82b
1000b81b:	48                   	dec    eax
1000b81c:	74 08                	je     0x1000b826
1000b81e:	48                   	dec    eax
1000b81f:	75 13                	jne    0x1000b834
1000b821:	53                   	push   ebx
1000b822:	6a f4                	push   0xfffffff4
1000b824:	eb 08                	jmp    0x1000b82e
1000b826:	53                   	push   ebx
1000b827:	6a f5                	push   0xfffffff5
1000b829:	eb 03                	jmp    0x1000b82e
1000b82b:	53                   	push   ebx
1000b82c:	6a f6                	push   0xfffffff6
1000b82e:	ff 15 c8 d0 00 10    	call   DWORD PTR ds:0x1000d0c8
1000b834:	8b 07                	mov    eax,DWORD PTR [edi]
1000b836:	89 1c 30             	mov    DWORD PTR [eax+esi*1],ebx
1000b839:	33 c0                	xor    eax,eax
1000b83b:	5b                   	pop    ebx
1000b83c:	eb 14                	jmp    0x1000b852
1000b83e:	83 25 50 f6 00 10 00 	and    DWORD PTR ds:0x1000f650,0x0
1000b845:	c7 05 4c f6 00 10 09 	mov    DWORD PTR ds:0x1000f64c,0x9
1000b84c:	00 00 00 
1000b84f:	83 c8 ff             	or     eax,0xffffffff
1000b852:	5f                   	pop    edi
1000b853:	5e                   	pop    esi
1000b854:	c3                   	ret
1000b855:	8b 4c 24 04          	mov    ecx,DWORD PTR [esp+0x4]
1000b859:	56                   	push   esi
1000b85a:	3b 0d a0 0b 01 10    	cmp    ecx,DWORD PTR ds:0x10010ba0
1000b860:	57                   	push   edi
1000b861:	73 55                	jae    0x1000b8b8
1000b863:	8b c1                	mov    eax,ecx
1000b865:	8b f1                	mov    esi,ecx
1000b867:	c1 f8 05             	sar    eax,0x5
1000b86a:	83 e6 1f             	and    esi,0x1f
1000b86d:	8d 3c 85 a0 0a 01 10 	lea    edi,[eax*4+0x10010aa0]
1000b874:	c1 e6 03             	shl    esi,0x3
1000b877:	8b 07                	mov    eax,DWORD PTR [edi]
1000b879:	03 c6                	add    eax,esi
1000b87b:	f6 40 04 01          	test   BYTE PTR [eax+0x4],0x1
1000b87f:	74 37                	je     0x1000b8b8
1000b881:	83 38 ff             	cmp    DWORD PTR [eax],0xffffffff
1000b884:	74 32                	je     0x1000b8b8
1000b886:	83 3d 28 f6 00 10 01 	cmp    DWORD PTR ds:0x1000f628,0x1
1000b88d:	75 1f                	jne    0x1000b8ae
1000b88f:	33 c0                	xor    eax,eax
1000b891:	2b c8                	sub    ecx,eax
1000b893:	74 10                	je     0x1000b8a5
1000b895:	49                   	dec    ecx
1000b896:	74 08                	je     0x1000b8a0
1000b898:	49                   	dec    ecx
1000b899:	75 13                	jne    0x1000b8ae
1000b89b:	50                   	push   eax
1000b89c:	6a f4                	push   0xfffffff4
1000b89e:	eb 08                	jmp    0x1000b8a8
1000b8a0:	50                   	push   eax
1000b8a1:	6a f5                	push   0xfffffff5
1000b8a3:	eb 03                	jmp    0x1000b8a8
1000b8a5:	50                   	push   eax
1000b8a6:	6a f6                	push   0xfffffff6
1000b8a8:	ff 15 c8 d0 00 10    	call   DWORD PTR ds:0x1000d0c8
1000b8ae:	8b 07                	mov    eax,DWORD PTR [edi]
1000b8b0:	83 0c 30 ff          	or     DWORD PTR [eax+esi*1],0xffffffff
1000b8b4:	33 c0                	xor    eax,eax
1000b8b6:	eb 14                	jmp    0x1000b8cc
1000b8b8:	83 25 50 f6 00 10 00 	and    DWORD PTR ds:0x1000f650,0x0
1000b8bf:	c7 05 4c f6 00 10 09 	mov    DWORD PTR ds:0x1000f64c,0x9
1000b8c6:	00 00 00 
1000b8c9:	83 c8 ff             	or     eax,0xffffffff
1000b8cc:	5f                   	pop    edi
1000b8cd:	5e                   	pop    esi
1000b8ce:	c3                   	ret
1000b8cf:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
1000b8d3:	3b 05 a0 0b 01 10    	cmp    eax,DWORD PTR ds:0x10010ba0
1000b8d9:	73 1c                	jae    0x1000b8f7
1000b8db:	8b c8                	mov    ecx,eax
1000b8dd:	83 e0 1f             	and    eax,0x1f
1000b8e0:	c1 f9 05             	sar    ecx,0x5
1000b8e3:	8b 0c 8d a0 0a 01 10 	mov    ecx,DWORD PTR [ecx*4+0x10010aa0]
1000b8ea:	f6 44 c1 04 01       	test   BYTE PTR [ecx+eax*8+0x4],0x1
1000b8ef:	8d 04 c1             	lea    eax,[ecx+eax*8]
1000b8f2:	74 03                	je     0x1000b8f7
1000b8f4:	8b 00                	mov    eax,DWORD PTR [eax]
1000b8f6:	c3                   	ret
1000b8f7:	83 25 50 f6 00 10 00 	and    DWORD PTR ds:0x1000f650,0x0
1000b8fe:	c7 05 4c f6 00 10 09 	mov    DWORD PTR ds:0x1000f64c,0x9
1000b905:	00 00 00 
1000b908:	83 c8 ff             	or     eax,0xffffffff
1000b90b:	c3                   	ret
1000b90c:	55                   	push   ebp
1000b90d:	8b ec                	mov    ebp,esp
1000b90f:	53                   	push   ebx
1000b910:	32 db                	xor    bl,bl
1000b912:	f6 45 0c 08          	test   BYTE PTR [ebp+0xc],0x8
1000b916:	56                   	push   esi
1000b917:	74 03                	je     0x1000b91c
1000b919:	80 c3 20             	add    bl,0x20
1000b91c:	f6 45 0d 40          	test   BYTE PTR [ebp+0xd],0x40
1000b920:	74 03                	je     0x1000b925
1000b922:	80 cb 80             	or     bl,0x80
1000b925:	f6 45 0c 80          	test   BYTE PTR [ebp+0xc],0x80
1000b929:	74 03                	je     0x1000b92e
1000b92b:	80 cb 10             	or     bl,0x10
1000b92e:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000b931:	ff 15 5c d0 00 10    	call   DWORD PTR ds:0x1000d05c
1000b937:	85 c0                	test   eax,eax
1000b939:	75 12                	jne    0x1000b94d
1000b93b:	ff 15 8c d0 00 10    	call   DWORD PTR ds:0x1000d08c
1000b941:	50                   	push   eax
1000b942:	e8 9b fd ff ff       	call   0x1000b6e2
1000b947:	59                   	pop    ecx
1000b948:	83 c8 ff             	or     eax,0xffffffff
1000b94b:	eb 58                	jmp    0x1000b9a5
1000b94d:	83 f8 02             	cmp    eax,0x2
1000b950:	75 05                	jne    0x1000b957
1000b952:	80 cb 40             	or     bl,0x40
1000b955:	eb 08                	jmp    0x1000b95f
1000b957:	83 f8 03             	cmp    eax,0x3
1000b95a:	75 03                	jne    0x1000b95f
1000b95c:	80 cb 08             	or     bl,0x8
1000b95f:	e8 e5 fd ff ff       	call   0x1000b749
1000b964:	8b f0                	mov    esi,eax
1000b966:	83 c8 ff             	or     eax,0xffffffff
1000b969:	3b f0                	cmp    esi,eax
1000b96b:	75 13                	jne    0x1000b980
1000b96d:	83 25 50 f6 00 10 00 	and    DWORD PTR ds:0x1000f650,0x0
1000b974:	c7 05 4c f6 00 10 18 	mov    DWORD PTR ds:0x1000f64c,0x18
1000b97b:	00 00 00 
1000b97e:	eb 25                	jmp    0x1000b9a5
1000b980:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000b983:	56                   	push   esi
1000b984:	e8 55 fe ff ff       	call   0x1000b7de
1000b989:	59                   	pop    ecx
1000b98a:	8b c6                	mov    eax,esi
1000b98c:	59                   	pop    ecx
1000b98d:	80 cb 01             	or     bl,0x1
1000b990:	c1 f8 05             	sar    eax,0x5
1000b993:	8b ce                	mov    ecx,esi
1000b995:	8b 04 85 a0 0a 01 10 	mov    eax,DWORD PTR [eax*4+0x10010aa0]
1000b99c:	83 e1 1f             	and    ecx,0x1f
1000b99f:	88 5c c8 04          	mov    BYTE PTR [eax+ecx*8+0x4],bl
1000b9a3:	8b c6                	mov    eax,esi
1000b9a5:	5e                   	pop    esi
1000b9a6:	5b                   	pop    ebx
1000b9a7:	5d                   	pop    ebp
1000b9a8:	c3                   	ret
1000b9a9:	53                   	push   ebx
1000b9aa:	56                   	push   esi
1000b9ab:	8b 74 24 0c          	mov    esi,DWORD PTR [esp+0xc]
1000b9af:	57                   	push   edi
1000b9b0:	0f af 74 24 14       	imul   esi,DWORD PTR [esp+0x14]
1000b9b5:	83 fe e0             	cmp    esi,0xffffffe0
1000b9b8:	8b de                	mov    ebx,esi
1000b9ba:	77 0d                	ja     0x1000b9c9
1000b9bc:	85 f6                	test   esi,esi
1000b9be:	75 03                	jne    0x1000b9c3
1000b9c0:	6a 01                	push   0x1
1000b9c2:	5e                   	pop    esi
1000b9c3:	83 c6 0f             	add    esi,0xf
1000b9c6:	83 e6 f0             	and    esi,0xfffffff0
1000b9c9:	33 ff                	xor    edi,edi
1000b9cb:	83 fe e0             	cmp    esi,0xffffffe0
1000b9ce:	77 2a                	ja     0x1000b9fa
1000b9d0:	3b 1d 70 ed 00 10    	cmp    ebx,DWORD PTR ds:0x1000ed70
1000b9d6:	77 0d                	ja     0x1000b9e5
1000b9d8:	53                   	push   ebx
1000b9d9:	e8 17 d3 ff ff       	call   0x10008cf5
1000b9de:	8b f8                	mov    edi,eax
1000b9e0:	59                   	pop    ecx
1000b9e1:	85 ff                	test   edi,edi
1000b9e3:	75 2b                	jne    0x1000ba10
1000b9e5:	56                   	push   esi
1000b9e6:	6a 08                	push   0x8
1000b9e8:	ff 35 a4 0b 01 10    	push   DWORD PTR ds:0x10010ba4
1000b9ee:	ff 15 38 d0 00 10    	call   DWORD PTR ds:0x1000d038
1000b9f4:	8b f8                	mov    edi,eax
1000b9f6:	85 ff                	test   edi,edi
1000b9f8:	75 22                	jne    0x1000ba1c
1000b9fa:	83 3d d8 f7 00 10 00 	cmp    DWORD PTR ds:0x1000f7d8,0x0
1000ba01:	74 19                	je     0x1000ba1c
1000ba03:	56                   	push   esi
1000ba04:	e8 ad de ff ff       	call   0x100098b6
1000ba09:	85 c0                	test   eax,eax
1000ba0b:	59                   	pop    ecx
1000ba0c:	74 14                	je     0x1000ba22
1000ba0e:	eb b9                	jmp    0x1000b9c9
1000ba10:	53                   	push   ebx
1000ba11:	6a 00                	push   0x0
1000ba13:	57                   	push   edi
1000ba14:	e8 07 cb ff ff       	call   0x10008520
1000ba19:	83 c4 0c             	add    esp,0xc
1000ba1c:	8b c7                	mov    eax,edi
1000ba1e:	5f                   	pop    edi
1000ba1f:	5e                   	pop    esi
1000ba20:	5b                   	pop    ebx
1000ba21:	c3                   	ret
1000ba22:	33 c0                	xor    eax,eax
1000ba24:	eb f8                	jmp    0x1000ba1e
1000ba26:	56                   	push   esi
1000ba27:	57                   	push   edi
1000ba28:	6a 03                	push   0x3
1000ba2a:	33 ff                	xor    edi,edi
1000ba2c:	5e                   	pop    esi
1000ba2d:	39 35 80 0a 01 10    	cmp    DWORD PTR ds:0x10010a80,esi
1000ba33:	7e 44                	jle    0x1000ba79
1000ba35:	a1 68 fa 00 10       	mov    eax,ds:0x1000fa68
1000ba3a:	8b 04 b0             	mov    eax,DWORD PTR [eax+esi*4]
1000ba3d:	85 c0                	test   eax,eax
1000ba3f:	74 2f                	je     0x1000ba70
1000ba41:	f6 40 0c 83          	test   BYTE PTR [eax+0xc],0x83
1000ba45:	74 0d                	je     0x1000ba54
1000ba47:	50                   	push   eax
1000ba48:	e8 90 06 00 00       	call   0x1000c0dd
1000ba4d:	83 f8 ff             	cmp    eax,0xffffffff
1000ba50:	59                   	pop    ecx
1000ba51:	74 01                	je     0x1000ba54
1000ba53:	47                   	inc    edi
1000ba54:	83 fe 14             	cmp    esi,0x14
1000ba57:	7c 17                	jl     0x1000ba70
1000ba59:	a1 68 fa 00 10       	mov    eax,ds:0x1000fa68
1000ba5e:	ff 34 b0             	push   DWORD PTR [eax+esi*4]
1000ba61:	e8 c4 a3 ff ff       	call   0x10005e2a
1000ba66:	a1 68 fa 00 10       	mov    eax,ds:0x1000fa68
1000ba6b:	59                   	pop    ecx
1000ba6c:	83 24 b0 00          	and    DWORD PTR [eax+esi*4],0x0
1000ba70:	46                   	inc    esi
1000ba71:	3b 35 80 0a 01 10    	cmp    esi,DWORD PTR ds:0x10010a80
1000ba77:	7c bc                	jl     0x1000ba35
1000ba79:	8b c7                	mov    eax,edi
1000ba7b:	5f                   	pop    edi
1000ba7c:	5e                   	pop    esi
1000ba7d:	c3                   	ret
1000ba7e:	56                   	push   esi
1000ba7f:	8b 74 24 08          	mov    esi,DWORD PTR [esp+0x8]
1000ba83:	85 f6                	test   esi,esi
1000ba85:	75 09                	jne    0x1000ba90
1000ba87:	56                   	push   esi
1000ba88:	e8 91 00 00 00       	call   0x1000bb1e
1000ba8d:	59                   	pop    ecx
1000ba8e:	5e                   	pop    esi
1000ba8f:	c3                   	ret
1000ba90:	56                   	push   esi
1000ba91:	e8 23 00 00 00       	call   0x1000bab9
1000ba96:	85 c0                	test   eax,eax
1000ba98:	59                   	pop    ecx
1000ba99:	74 05                	je     0x1000baa0
1000ba9b:	83 c8 ff             	or     eax,0xffffffff
1000ba9e:	5e                   	pop    esi
1000ba9f:	c3                   	ret
1000baa0:	f6 46 0d 40          	test   BYTE PTR [esi+0xd],0x40
1000baa4:	74 0f                	je     0x1000bab5
1000baa6:	ff 76 10             	push   DWORD PTR [esi+0x10]
1000baa9:	e8 85 06 00 00       	call   0x1000c133
1000baae:	f7 d8                	neg    eax
1000bab0:	59                   	pop    ecx
1000bab1:	5e                   	pop    esi
1000bab2:	1b c0                	sbb    eax,eax
1000bab4:	c3                   	ret
1000bab5:	33 c0                	xor    eax,eax
1000bab7:	5e                   	pop    esi
1000bab8:	c3                   	ret
1000bab9:	53                   	push   ebx
1000baba:	56                   	push   esi
1000babb:	8b 74 24 0c          	mov    esi,DWORD PTR [esp+0xc]
1000babf:	33 db                	xor    ebx,ebx
1000bac1:	57                   	push   edi
1000bac2:	8b 46 0c             	mov    eax,DWORD PTR [esi+0xc]
1000bac5:	8b c8                	mov    ecx,eax
1000bac7:	83 e1 03             	and    ecx,0x3
1000baca:	80 f9 02             	cmp    cl,0x2
1000bacd:	75 37                	jne    0x1000bb06
1000bacf:	66 a9 08 01          	test   ax,0x108
1000bad3:	74 31                	je     0x1000bb06
1000bad5:	8b 46 08             	mov    eax,DWORD PTR [esi+0x8]
1000bad8:	8b 3e                	mov    edi,DWORD PTR [esi]
1000bada:	2b f8                	sub    edi,eax
1000badc:	85 ff                	test   edi,edi
1000bade:	7e 26                	jle    0x1000bb06
1000bae0:	57                   	push   edi
1000bae1:	50                   	push   eax
1000bae2:	ff 76 10             	push   DWORD PTR [esi+0x10]
1000bae5:	e8 81 de ff ff       	call   0x1000996b
1000baea:	83 c4 0c             	add    esp,0xc
1000baed:	3b c7                	cmp    eax,edi
1000baef:	75 0e                	jne    0x1000baff
1000baf1:	8b 46 0c             	mov    eax,DWORD PTR [esi+0xc]
1000baf4:	a8 80                	test   al,0x80
1000baf6:	74 0e                	je     0x1000bb06
1000baf8:	24 fd                	and    al,0xfd
1000bafa:	89 46 0c             	mov    DWORD PTR [esi+0xc],eax
1000bafd:	eb 07                	jmp    0x1000bb06
1000baff:	83 4e 0c 20          	or     DWORD PTR [esi+0xc],0x20
1000bb03:	83 cb ff             	or     ebx,0xffffffff
1000bb06:	8b 46 08             	mov    eax,DWORD PTR [esi+0x8]
1000bb09:	83 66 04 00          	and    DWORD PTR [esi+0x4],0x0
1000bb0d:	89 06                	mov    DWORD PTR [esi],eax
1000bb0f:	5f                   	pop    edi
1000bb10:	8b c3                	mov    eax,ebx
1000bb12:	5e                   	pop    esi
1000bb13:	5b                   	pop    ebx
1000bb14:	c3                   	ret
1000bb15:	6a 01                	push   0x1
1000bb17:	e8 02 00 00 00       	call   0x1000bb1e
1000bb1c:	59                   	pop    ecx
1000bb1d:	c3                   	ret
1000bb1e:	53                   	push   ebx
1000bb1f:	56                   	push   esi
1000bb20:	57                   	push   edi
1000bb21:	33 f6                	xor    esi,esi
1000bb23:	33 db                	xor    ebx,ebx
1000bb25:	33 ff                	xor    edi,edi
1000bb27:	39 35 80 0a 01 10    	cmp    DWORD PTR ds:0x10010a80,esi
1000bb2d:	7e 4d                	jle    0x1000bb7c
1000bb2f:	a1 68 fa 00 10       	mov    eax,ds:0x1000fa68
1000bb34:	8b 04 b0             	mov    eax,DWORD PTR [eax+esi*4]
1000bb37:	85 c0                	test   eax,eax
1000bb39:	74 38                	je     0x1000bb73
1000bb3b:	8b 48 0c             	mov    ecx,DWORD PTR [eax+0xc]
1000bb3e:	f6 c1 83             	test   cl,0x83
1000bb41:	74 30                	je     0x1000bb73
1000bb43:	83 7c 24 10 01       	cmp    DWORD PTR [esp+0x10],0x1
1000bb48:	75 0f                	jne    0x1000bb59
1000bb4a:	50                   	push   eax
1000bb4b:	e8 2e ff ff ff       	call   0x1000ba7e
1000bb50:	83 f8 ff             	cmp    eax,0xffffffff
1000bb53:	59                   	pop    ecx
1000bb54:	74 1d                	je     0x1000bb73
1000bb56:	43                   	inc    ebx
1000bb57:	eb 1a                	jmp    0x1000bb73
1000bb59:	83 7c 24 10 00       	cmp    DWORD PTR [esp+0x10],0x0
1000bb5e:	75 13                	jne    0x1000bb73
1000bb60:	f6 c1 02             	test   cl,0x2
1000bb63:	74 0e                	je     0x1000bb73
1000bb65:	50                   	push   eax
1000bb66:	e8 13 ff ff ff       	call   0x1000ba7e
1000bb6b:	83 f8 ff             	cmp    eax,0xffffffff
1000bb6e:	59                   	pop    ecx
1000bb6f:	75 02                	jne    0x1000bb73
1000bb71:	0b f8                	or     edi,eax
1000bb73:	46                   	inc    esi
1000bb74:	3b 35 80 0a 01 10    	cmp    esi,DWORD PTR ds:0x10010a80
1000bb7a:	7c b3                	jl     0x1000bb2f
1000bb7c:	83 7c 24 10 01       	cmp    DWORD PTR [esp+0x10],0x1
1000bb81:	8b c3                	mov    eax,ebx
1000bb83:	74 02                	je     0x1000bb87
1000bb85:	8b c7                	mov    eax,edi
1000bb87:	5f                   	pop    edi
1000bb88:	5e                   	pop    esi
1000bb89:	5b                   	pop    ebx
1000bb8a:	c3                   	ret
1000bb8b:	55                   	push   ebp
1000bb8c:	8b ec                	mov    ebp,esp
1000bb8e:	56                   	push   esi
1000bb8f:	57                   	push   edi
1000bb90:	8b 7d 0c             	mov    edi,DWORD PTR [ebp+0xc]
1000bb93:	83 ff 04             	cmp    edi,0x4
1000bb96:	0f 84 b9 00 00 00    	je     0x1000bc55
1000bb9c:	83 ff 03             	cmp    edi,0x3
1000bb9f:	0f 84 b0 00 00 00    	je     0x1000bc55
1000bba5:	8b 75 08             	mov    esi,DWORD PTR [ebp+0x8]
1000bba8:	83 fe 02             	cmp    esi,0x2
1000bbab:	74 5e                	je     0x1000bc0b
1000bbad:	83 fe 15             	cmp    esi,0x15
1000bbb0:	74 59                	je     0x1000bc0b
1000bbb2:	83 fe 16             	cmp    esi,0x16
1000bbb5:	74 4f                	je     0x1000bc06
1000bbb7:	83 fe 0f             	cmp    esi,0xf
1000bbba:	74 4a                	je     0x1000bc06
1000bbbc:	83 fe 08             	cmp    esi,0x8
1000bbbf:	74 0e                	je     0x1000bbcf
1000bbc1:	83 fe 04             	cmp    esi,0x4
1000bbc4:	74 09                	je     0x1000bbcf
1000bbc6:	83 fe 0b             	cmp    esi,0xb
1000bbc9:	0f 85 86 00 00 00    	jne    0x1000bc55
1000bbcf:	56                   	push   esi
1000bbd0:	e8 27 02 00 00       	call   0x1000bdfc
1000bbd5:	85 c0                	test   eax,eax
1000bbd7:	59                   	pop    ecx
1000bbd8:	74 7b                	je     0x1000bc55
1000bbda:	8b 48 08             	mov    ecx,DWORD PTR [eax+0x8]
1000bbdd:	39 70 04             	cmp    DWORD PTR [eax+0x4],esi
1000bbe0:	0f 85 ad 00 00 00    	jne    0x1000bc93
1000bbe6:	89 78 08             	mov    DWORD PTR [eax+0x8],edi
1000bbe9:	8b 15 80 f1 00 10    	mov    edx,DWORD PTR ds:0x1000f180
1000bbef:	83 c0 0c             	add    eax,0xc
1000bbf2:	8d 14 52             	lea    edx,[edx+edx*2]
1000bbf5:	8d 14 95 00 f1 00 10 	lea    edx,[edx*4+0x1000f100]
1000bbfc:	3b c2                	cmp    eax,edx
1000bbfe:	0f 83 8f 00 00 00    	jae    0x1000bc93
1000bc04:	eb d7                	jmp    0x1000bbdd
1000bc06:	83 fe 15             	cmp    esi,0x15
1000bc09:	75 20                	jne    0x1000bc2b
1000bc0b:	83 3d 34 f8 00 10 00 	cmp    DWORD PTR ds:0x1000f834,0x0
1000bc12:	75 17                	jne    0x1000bc2b
1000bc14:	6a 01                	push   0x1
1000bc16:	68 97 bc 00 10       	push   0x1000bc97
1000bc1b:	ff 15 cc d0 00 10    	call   DWORD PTR ds:0x1000d0cc
1000bc21:	83 f8 01             	cmp    eax,0x1
1000bc24:	75 24                	jne    0x1000bc4a
1000bc26:	a3 34 f8 00 10       	mov    ds:0x1000f834,eax
1000bc2b:	4e                   	dec    esi
1000bc2c:	4e                   	dec    esi
1000bc2d:	74 53                	je     0x1000bc82
1000bc2f:	83 ee 0d             	sub    esi,0xd
1000bc32:	74 40                	je     0x1000bc74
1000bc34:	83 ee 06             	sub    esi,0x6
1000bc37:	74 2d                	je     0x1000bc66
1000bc39:	4e                   	dec    esi
1000bc3a:	75 54                	jne    0x1000bc90
1000bc3c:	8b 0d 2c f8 00 10    	mov    ecx,DWORD PTR ds:0x1000f82c
1000bc42:	89 3d 2c f8 00 10    	mov    DWORD PTR ds:0x1000f82c,edi
1000bc48:	eb 49                	jmp    0x1000bc93
1000bc4a:	ff 15 8c d0 00 10    	call   DWORD PTR ds:0x1000d08c
1000bc50:	a3 50 f6 00 10       	mov    ds:0x1000f650,eax
1000bc55:	c7 05 4c f6 00 10 16 	mov    DWORD PTR ds:0x1000f64c,0x16
1000bc5c:	00 00 00 
1000bc5f:	83 c8 ff             	or     eax,0xffffffff
1000bc62:	5f                   	pop    edi
1000bc63:	5e                   	pop    esi
1000bc64:	5d                   	pop    ebp
1000bc65:	c3                   	ret
1000bc66:	8b 0d 28 f8 00 10    	mov    ecx,DWORD PTR ds:0x1000f828
1000bc6c:	89 3d 28 f8 00 10    	mov    DWORD PTR ds:0x1000f828,edi
1000bc72:	eb 1f                	jmp    0x1000bc93
1000bc74:	8b 0d 30 f8 00 10    	mov    ecx,DWORD PTR ds:0x1000f830
1000bc7a:	89 3d 30 f8 00 10    	mov    DWORD PTR ds:0x1000f830,edi
1000bc80:	eb 11                	jmp    0x1000bc93
1000bc82:	8b 0d 24 f8 00 10    	mov    ecx,DWORD PTR ds:0x1000f824
1000bc88:	89 3d 24 f8 00 10    	mov    DWORD PTR ds:0x1000f824,edi
1000bc8e:	eb 03                	jmp    0x1000bc93
1000bc90:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
1000bc93:	8b c1                	mov    eax,ecx
1000bc95:	eb cb                	jmp    0x1000bc62
1000bc97:	83 7c 24 04 00       	cmp    DWORD PTR [esp+0x4],0x0
1000bc9c:	75 0e                	jne    0x1000bcac
1000bc9e:	a1 24 f8 00 10       	mov    eax,ds:0x1000f824
1000bca3:	b9 24 f8 00 10       	mov    ecx,0x1000f824
1000bca8:	6a 02                	push   0x2
1000bcaa:	eb 0c                	jmp    0x1000bcb8
1000bcac:	a1 28 f8 00 10       	mov    eax,ds:0x1000f828
1000bcb1:	b9 28 f8 00 10       	mov    ecx,0x1000f828
1000bcb6:	6a 15                	push   0x15
1000bcb8:	85 c0                	test   eax,eax
1000bcba:	5a                   	pop    edx
1000bcbb:	74 0f                	je     0x1000bccc
1000bcbd:	83 f8 01             	cmp    eax,0x1
1000bcc0:	74 07                	je     0x1000bcc9
1000bcc2:	83 21 00             	and    DWORD PTR [ecx],0x0
1000bcc5:	52                   	push   edx
1000bcc6:	ff d0                	call   eax
1000bcc8:	59                   	pop    ecx
1000bcc9:	6a 01                	push   0x1
1000bccb:	58                   	pop    eax
1000bccc:	c2 04 00             	ret    0x4
1000bccf:	55                   	push   ebp
1000bcd0:	8b ec                	mov    ebp,esp
1000bcd2:	56                   	push   esi
1000bcd3:	57                   	push   edi
1000bcd4:	8b 7d 08             	mov    edi,DWORD PTR [ebp+0x8]
1000bcd7:	8b c7                	mov    eax,edi
1000bcd9:	48                   	dec    eax
1000bcda:	48                   	dec    eax
1000bcdb:	74 59                	je     0x1000bd36
1000bcdd:	48                   	dec    eax
1000bcde:	48                   	dec    eax
1000bcdf:	74 46                	je     0x1000bd27
1000bce1:	83 e8 04             	sub    eax,0x4
1000bce4:	74 41                	je     0x1000bd27
1000bce6:	83 e8 03             	sub    eax,0x3
1000bce9:	74 3c                	je     0x1000bd27
1000bceb:	83 e8 04             	sub    eax,0x4
1000bcee:	74 2a                	je     0x1000bd1a
1000bcf0:	83 e8 06             	sub    eax,0x6
1000bcf3:	74 18                	je     0x1000bd0d
1000bcf5:	48                   	dec    eax
1000bcf6:	74 08                	je     0x1000bd00
1000bcf8:	83 c8 ff             	or     eax,0xffffffff
1000bcfb:	e9 f8 00 00 00       	jmp    0x1000bdf8
1000bd00:	8b 35 2c f8 00 10    	mov    esi,DWORD PTR ds:0x1000f82c
1000bd06:	b8 2c f8 00 10       	mov    eax,0x1000f82c
1000bd0b:	eb 34                	jmp    0x1000bd41
1000bd0d:	8b 35 28 f8 00 10    	mov    esi,DWORD PTR ds:0x1000f828
1000bd13:	b8 28 f8 00 10       	mov    eax,0x1000f828
1000bd18:	eb 27                	jmp    0x1000bd41
1000bd1a:	8b 35 30 f8 00 10    	mov    esi,DWORD PTR ds:0x1000f830
1000bd20:	b8 30 f8 00 10       	mov    eax,0x1000f830
1000bd25:	eb 1a                	jmp    0x1000bd41
1000bd27:	57                   	push   edi
1000bd28:	e8 cf 00 00 00       	call   0x1000bdfc
1000bd2d:	8b 70 08             	mov    esi,DWORD PTR [eax+0x8]
1000bd30:	83 c0 08             	add    eax,0x8
1000bd33:	59                   	pop    ecx
1000bd34:	eb 0b                	jmp    0x1000bd41
1000bd36:	8b 35 24 f8 00 10    	mov    esi,DWORD PTR ds:0x1000f824
1000bd3c:	b8 24 f8 00 10       	mov    eax,0x1000f824
1000bd41:	83 fe 01             	cmp    esi,0x1
1000bd44:	75 07                	jne    0x1000bd4d
1000bd46:	33 c0                	xor    eax,eax
1000bd48:	e9 ab 00 00 00       	jmp    0x1000bdf8
1000bd4d:	85 f6                	test   esi,esi
1000bd4f:	75 07                	jne    0x1000bd58
1000bd51:	6a 03                	push   0x3
1000bd53:	e8 8a b4 ff ff       	call   0x100071e2
1000bd58:	53                   	push   ebx
1000bd59:	6a 08                	push   0x8
1000bd5b:	59                   	pop    ecx
1000bd5c:	3b f9                	cmp    edi,ecx
1000bd5e:	74 0a                	je     0x1000bd6a
1000bd60:	83 ff 0b             	cmp    edi,0xb
1000bd63:	74 05                	je     0x1000bd6a
1000bd65:	83 ff 04             	cmp    edi,0x4
1000bd68:	75 26                	jne    0x1000bd90
1000bd6a:	8b 1d fc f7 00 10    	mov    ebx,DWORD PTR ds:0x1000f7fc
1000bd70:	83 25 fc f7 00 10 00 	and    DWORD PTR ds:0x1000f7fc,0x0
1000bd77:	3b f9                	cmp    edi,ecx
1000bd79:	75 44                	jne    0x1000bdbf
1000bd7b:	8b 15 84 f1 00 10    	mov    edx,DWORD PTR ds:0x1000f184
1000bd81:	c7 05 84 f1 00 10 8c 	mov    DWORD PTR ds:0x1000f184,0x8c
1000bd88:	00 00 00 
1000bd8b:	89 55 08             	mov    DWORD PTR [ebp+0x8],edx
1000bd8e:	eb 03                	jmp    0x1000bd93
1000bd90:	8b 5d 08             	mov    ebx,DWORD PTR [ebp+0x8]
1000bd93:	3b f9                	cmp    edi,ecx
1000bd95:	75 28                	jne    0x1000bdbf
1000bd97:	a1 78 f1 00 10       	mov    eax,ds:0x1000f178
1000bd9c:	8b 0d 7c f1 00 10    	mov    ecx,DWORD PTR ds:0x1000f17c
1000bda2:	03 c8                	add    ecx,eax
1000bda4:	3b c1                	cmp    eax,ecx
1000bda6:	7d 1e                	jge    0x1000bdc6
1000bda8:	8d 14 40             	lea    edx,[eax+eax*2]
1000bdab:	2b c8                	sub    ecx,eax
1000bdad:	8d 14 95 08 f1 00 10 	lea    edx,[edx*4+0x1000f108]
1000bdb4:	83 22 00             	and    DWORD PTR [edx],0x0
1000bdb7:	83 c2 0c             	add    edx,0xc
1000bdba:	49                   	dec    ecx
1000bdbb:	75 f7                	jne    0x1000bdb4
1000bdbd:	eb 07                	jmp    0x1000bdc6
1000bdbf:	83 20 00             	and    DWORD PTR [eax],0x0
1000bdc2:	3b f9                	cmp    edi,ecx
1000bdc4:	75 0e                	jne    0x1000bdd4
1000bdc6:	ff 35 84 f1 00 10    	push   DWORD PTR ds:0x1000f184
1000bdcc:	6a 08                	push   0x8
1000bdce:	ff d6                	call   esi
1000bdd0:	59                   	pop    ecx
1000bdd1:	59                   	pop    ecx
1000bdd2:	eb 0e                	jmp    0x1000bde2
1000bdd4:	57                   	push   edi
1000bdd5:	ff d6                	call   esi
1000bdd7:	83 ff 0b             	cmp    edi,0xb
1000bdda:	59                   	pop    ecx
1000bddb:	74 05                	je     0x1000bde2
1000bddd:	83 ff 04             	cmp    edi,0x4
1000bde0:	75 13                	jne    0x1000bdf5
1000bde2:	83 ff 08             	cmp    edi,0x8
1000bde5:	89 1d fc f7 00 10    	mov    DWORD PTR ds:0x1000f7fc,ebx
1000bdeb:	75 08                	jne    0x1000bdf5
1000bded:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000bdf0:	a3 84 f1 00 10       	mov    ds:0x1000f184,eax
1000bdf5:	33 c0                	xor    eax,eax
1000bdf7:	5b                   	pop    ebx
1000bdf8:	5f                   	pop    edi
1000bdf9:	5e                   	pop    esi
1000bdfa:	5d                   	pop    ebp
1000bdfb:	c3                   	ret
1000bdfc:	8b 54 24 04          	mov    edx,DWORD PTR [esp+0x4]
1000be00:	8b 0d 80 f1 00 10    	mov    ecx,DWORD PTR ds:0x1000f180
1000be06:	39 15 04 f1 00 10    	cmp    DWORD PTR ds:0x1000f104,edx
1000be0c:	56                   	push   esi
1000be0d:	b8 00 f1 00 10       	mov    eax,0x1000f100
1000be12:	74 16                	je     0x1000be2a
1000be14:	8d 34 49             	lea    esi,[ecx+ecx*2]
1000be17:	8d 34 b5 00 f1 00 10 	lea    esi,[esi*4+0x1000f100]
1000be1e:	83 c0 0c             	add    eax,0xc
1000be21:	3b c6                	cmp    eax,esi
1000be23:	73 05                	jae    0x1000be2a
1000be25:	39 50 04             	cmp    DWORD PTR [eax+0x4],edx
1000be28:	75 f4                	jne    0x1000be1e
1000be2a:	8d 0c 49             	lea    ecx,[ecx+ecx*2]
1000be2d:	5e                   	pop    esi
1000be2e:	8d 0c 8d 00 f1 00 10 	lea    ecx,[ecx*4+0x1000f100]
1000be35:	3b c1                	cmp    eax,ecx
1000be37:	73 05                	jae    0x1000be3e
1000be39:	39 50 04             	cmp    DWORD PTR [eax+0x4],edx
1000be3c:	74 02                	je     0x1000be40
1000be3e:	33 c0                	xor    eax,eax
1000be40:	c3                   	ret
1000be41:	55                   	push   ebp
1000be42:	8b ec                	mov    ebp,esp
1000be44:	83 ec 24             	sub    esp,0x24
1000be47:	53                   	push   ebx
1000be48:	8b 5d 0c             	mov    ebx,DWORD PTR [ebp+0xc]
1000be4b:	56                   	push   esi
1000be4c:	8b 75 08             	mov    esi,DWORD PTR [ebp+0x8]
1000be4f:	66 8b 4b 0a          	mov    cx,WORD PTR [ebx+0xa]
1000be53:	33 c0                	xor    eax,eax
1000be55:	57                   	push   edi
1000be56:	89 45 ec             	mov    DWORD PTR [ebp-0x14],eax
1000be59:	89 45 dc             	mov    DWORD PTR [ebp-0x24],eax
1000be5c:	89 45 e0             	mov    DWORD PTR [ebp-0x20],eax
1000be5f:	89 45 e4             	mov    DWORD PTR [ebp-0x1c],eax
1000be62:	66 8b 46 0a          	mov    ax,WORD PTR [esi+0xa]
1000be66:	8b f9                	mov    edi,ecx
1000be68:	ba ff 7f 00 00       	mov    edx,0x7fff
1000be6d:	33 f8                	xor    edi,eax
1000be6f:	23 c2                	and    eax,edx
1000be71:	23 ca                	and    ecx,edx
1000be73:	81 e7 00 80 00 00    	and    edi,0x8000
1000be79:	66 3d ff 7f          	cmp    ax,0x7fff
1000be7d:	8d 14 01             	lea    edx,[ecx+eax*1]
1000be80:	89 55 08             	mov    DWORD PTR [ebp+0x8],edx
1000be83:	0f 83 b8 01 00 00    	jae    0x1000c041
1000be89:	66 81 f9 ff 7f       	cmp    cx,0x7fff
1000be8e:	0f 83 ad 01 00 00    	jae    0x1000c041
1000be94:	66 81 fa fd bf       	cmp    dx,0xbffd
1000be99:	0f 87 a2 01 00 00    	ja     0x1000c041
1000be9f:	66 81 fa bf 3f       	cmp    dx,0x3fbf
1000bea4:	77 04                	ja     0x1000beaa
1000bea6:	33 c0                	xor    eax,eax
1000bea8:	eb 3a                	jmp    0x1000bee4
1000beaa:	66 85 c0             	test   ax,ax
1000bead:	ba ff ff ff 7f       	mov    edx,0x7fffffff
1000beb2:	75 18                	jne    0x1000becc
1000beb4:	ff 45 08             	inc    DWORD PTR [ebp+0x8]
1000beb7:	85 56 08             	test   DWORD PTR [esi+0x8],edx
1000beba:	75 10                	jne    0x1000becc
1000bebc:	33 c0                	xor    eax,eax
1000bebe:	39 46 04             	cmp    DWORD PTR [esi+0x4],eax
1000bec1:	75 0b                	jne    0x1000bece
1000bec3:	39 06                	cmp    DWORD PTR [esi],eax
1000bec5:	75 07                	jne    0x1000bece
1000bec7:	e9 6f 01 00 00       	jmp    0x1000c03b
1000becc:	33 c0                	xor    eax,eax
1000bece:	66 3b c8             	cmp    cx,ax
1000bed1:	75 1e                	jne    0x1000bef1
1000bed3:	ff 45 08             	inc    DWORD PTR [ebp+0x8]
1000bed6:	85 53 08             	test   DWORD PTR [ebx+0x8],edx
1000bed9:	75 16                	jne    0x1000bef1
1000bedb:	39 43 04             	cmp    DWORD PTR [ebx+0x4],eax
1000bede:	75 11                	jne    0x1000bef1
1000bee0:	39 03                	cmp    DWORD PTR [ebx],eax
1000bee2:	75 0d                	jne    0x1000bef1
1000bee4:	89 46 08             	mov    DWORD PTR [esi+0x8],eax
1000bee7:	89 46 04             	mov    DWORD PTR [esi+0x4],eax
1000beea:	89 06                	mov    DWORD PTR [esi],eax
1000beec:	e9 6b 01 00 00       	jmp    0x1000c05c
1000bef1:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax
1000bef4:	8d 45 e0             	lea    eax,[ebp-0x20]
1000bef7:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
1000befa:	c7 45 0c 05 00 00 00 	mov    DWORD PTR [ebp+0xc],0x5
1000bf01:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
1000bf04:	03 c0                	add    eax,eax
1000bf06:	83 7d 0c 00          	cmp    DWORD PTR [ebp+0xc],0x0
1000bf0a:	7e 49                	jle    0x1000bf55
1000bf0c:	03 c6                	add    eax,esi
1000bf0e:	8d 4b 08             	lea    ecx,[ebx+0x8]
1000bf11:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
1000bf14:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
1000bf17:	89 4d f4             	mov    DWORD PTR [ebp-0xc],ecx
1000bf1a:	89 45 e8             	mov    DWORD PTR [ebp-0x18],eax
1000bf1d:	8b 45 f8             	mov    eax,DWORD PTR [ebp-0x8]
1000bf20:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
1000bf23:	0f b7 00             	movzx  eax,WORD PTR [eax]
1000bf26:	0f b7 09             	movzx  ecx,WORD PTR [ecx]
1000bf29:	0f af c1             	imul   eax,ecx
1000bf2c:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
1000bf2f:	83 c1 fc             	add    ecx,0xfffffffc
1000bf32:	51                   	push   ecx
1000bf33:	50                   	push   eax
1000bf34:	ff 31                	push   DWORD PTR [ecx]
1000bf36:	e8 66 ee ff ff       	call   0x1000ada1
1000bf3b:	83 c4 0c             	add    esp,0xc
1000bf3e:	85 c0                	test   eax,eax
1000bf40:	74 06                	je     0x1000bf48
1000bf42:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
1000bf45:	66 ff 00             	inc    WORD PTR [eax]
1000bf48:	83 45 f8 02          	add    DWORD PTR [ebp-0x8],0x2
1000bf4c:	83 6d f4 02          	sub    DWORD PTR [ebp-0xc],0x2
1000bf50:	ff 4d e8             	dec    DWORD PTR [ebp-0x18]
1000bf53:	75 c8                	jne    0x1000bf1d
1000bf55:	83 45 fc 02          	add    DWORD PTR [ebp-0x4],0x2
1000bf59:	ff 45 f0             	inc    DWORD PTR [ebp-0x10]
1000bf5c:	ff 4d 0c             	dec    DWORD PTR [ebp+0xc]
1000bf5f:	83 7d 0c 00          	cmp    DWORD PTR [ebp+0xc],0x0
1000bf63:	7f 9c                	jg     0x1000bf01
1000bf65:	81 45 08 02 c0 00 00 	add    DWORD PTR [ebp+0x8],0xc002
1000bf6c:	66 83 7d 08 00       	cmp    WORD PTR [ebp+0x8],0x0
1000bf71:	7e 25                	jle    0x1000bf98
1000bf73:	f6 45 e7 80          	test   BYTE PTR [ebp-0x19],0x80
1000bf77:	75 18                	jne    0x1000bf91
1000bf79:	8d 45 dc             	lea    eax,[ebp-0x24]
1000bf7c:	50                   	push   eax
1000bf7d:	e8 9e ee ff ff       	call   0x1000ae20
1000bf82:	81 45 08 ff ff 00 00 	add    DWORD PTR [ebp+0x8],0xffff
1000bf89:	59                   	pop    ecx
1000bf8a:	66 83 7d 08 00       	cmp    WORD PTR [ebp+0x8],0x0
1000bf8f:	7f e2                	jg     0x1000bf73
1000bf91:	66 83 7d 08 00       	cmp    WORD PTR [ebp+0x8],0x0
1000bf96:	7f 39                	jg     0x1000bfd1
1000bf98:	81 45 08 ff ff 00 00 	add    DWORD PTR [ebp+0x8],0xffff
1000bf9f:	66 83 7d 08 00       	cmp    WORD PTR [ebp+0x8],0x0
1000bfa4:	7d 2b                	jge    0x1000bfd1
1000bfa6:	0f bf 45 08          	movsx  eax,WORD PTR [ebp+0x8]
1000bfaa:	f7 d8                	neg    eax
1000bfac:	01 45 08             	add    DWORD PTR [ebp+0x8],eax
1000bfaf:	8b d8                	mov    ebx,eax
1000bfb1:	f6 45 dc 01          	test   BYTE PTR [ebp-0x24],0x1
1000bfb5:	74 03                	je     0x1000bfba
1000bfb7:	ff 45 ec             	inc    DWORD PTR [ebp-0x14]
1000bfba:	8d 45 dc             	lea    eax,[ebp-0x24]
1000bfbd:	50                   	push   eax
1000bfbe:	e8 8b ee ff ff       	call   0x1000ae4e
1000bfc3:	4b                   	dec    ebx
1000bfc4:	59                   	pop    ecx
1000bfc5:	75 ea                	jne    0x1000bfb1
1000bfc7:	83 7d ec 00          	cmp    DWORD PTR [ebp-0x14],0x0
1000bfcb:	74 04                	je     0x1000bfd1
1000bfcd:	80 4d dc 01          	or     BYTE PTR [ebp-0x24],0x1
1000bfd1:	66 81 7d dc 00 80    	cmp    WORD PTR [ebp-0x24],0x8000
1000bfd7:	77 0f                	ja     0x1000bfe8
1000bfd9:	8b 45 dc             	mov    eax,DWORD PTR [ebp-0x24]
1000bfdc:	25 ff ff 01 00       	and    eax,0x1ffff
1000bfe1:	3d 00 80 01 00       	cmp    eax,0x18000
1000bfe6:	75 35                	jne    0x1000c01d
1000bfe8:	83 7d de ff          	cmp    DWORD PTR [ebp-0x22],0xffffffff
1000bfec:	75 2c                	jne    0x1000c01a
1000bfee:	83 65 de 00          	and    DWORD PTR [ebp-0x22],0x0
1000bff2:	83 7d e2 ff          	cmp    DWORD PTR [ebp-0x1e],0xffffffff
1000bff6:	75 1d                	jne    0x1000c015
1000bff8:	83 65 e2 00          	and    DWORD PTR [ebp-0x1e],0x0
1000bffc:	66 81 7d e6 ff ff    	cmp    WORD PTR [ebp-0x1a],0xffff
1000c002:	75 0b                	jne    0x1000c00f
1000c004:	ff 45 08             	inc    DWORD PTR [ebp+0x8]
1000c007:	66 c7 45 e6 00 80    	mov    WORD PTR [ebp-0x1a],0x8000
1000c00d:	eb 0e                	jmp    0x1000c01d
1000c00f:	66 ff 45 e6          	inc    WORD PTR [ebp-0x1a]
1000c013:	eb 08                	jmp    0x1000c01d
1000c015:	ff 45 e2             	inc    DWORD PTR [ebp-0x1e]
1000c018:	eb 03                	jmp    0x1000c01d
1000c01a:	ff 45 de             	inc    DWORD PTR [ebp-0x22]
1000c01d:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000c020:	66 3d ff 7f          	cmp    ax,0x7fff
1000c024:	73 1b                	jae    0x1000c041
1000c026:	66 8b 4d de          	mov    cx,WORD PTR [ebp-0x22]
1000c02a:	0b c7                	or     eax,edi
1000c02c:	66 89 0e             	mov    WORD PTR [esi],cx
1000c02f:	8b 4d e0             	mov    ecx,DWORD PTR [ebp-0x20]
1000c032:	89 4e 02             	mov    DWORD PTR [esi+0x2],ecx
1000c035:	8b 4d e4             	mov    ecx,DWORD PTR [ebp-0x1c]
1000c038:	89 4e 06             	mov    DWORD PTR [esi+0x6],ecx
1000c03b:	66 89 46 0a          	mov    WORD PTR [esi+0xa],ax
1000c03f:	eb 1b                	jmp    0x1000c05c
1000c041:	66 f7 df             	neg    di
1000c044:	1b ff                	sbb    edi,edi
1000c046:	83 66 04 00          	and    DWORD PTR [esi+0x4],0x0
1000c04a:	81 e7 00 00 00 80    	and    edi,0x80000000
1000c050:	81 c7 00 80 ff 7f    	add    edi,0x7fff8000
1000c056:	83 26 00             	and    DWORD PTR [esi],0x0
1000c059:	89 7e 08             	mov    DWORD PTR [esi+0x8],edi
1000c05c:	5f                   	pop    edi
1000c05d:	5e                   	pop    esi
1000c05e:	5b                   	pop    ebx
1000c05f:	c9                   	leave
1000c060:	c3                   	ret
1000c061:	55                   	push   ebp
1000c062:	8b ec                	mov    ebp,esp
1000c064:	83 ec 0c             	sub    esp,0xc
1000c067:	53                   	push   ebx
1000c068:	bb f0 f2 00 10       	mov    ebx,0x1000f2f0
1000c06d:	33 c9                	xor    ecx,ecx
1000c06f:	83 eb 60             	sub    ebx,0x60
1000c072:	39 4d 0c             	cmp    DWORD PTR [ebp+0xc],ecx
1000c075:	74 63                	je     0x1000c0da
1000c077:	7d 10                	jge    0x1000c089
1000c079:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
1000c07c:	bb 50 f4 00 10       	mov    ebx,0x1000f450
1000c081:	f7 d8                	neg    eax
1000c083:	89 45 0c             	mov    DWORD PTR [ebp+0xc],eax
1000c086:	83 eb 60             	sub    ebx,0x60
1000c089:	39 4d 10             	cmp    DWORD PTR [ebp+0x10],ecx
1000c08c:	75 06                	jne    0x1000c094
1000c08e:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000c091:	66 89 08             	mov    WORD PTR [eax],cx
1000c094:	39 4d 0c             	cmp    DWORD PTR [ebp+0xc],ecx
1000c097:	74 41                	je     0x1000c0da
1000c099:	56                   	push   esi
1000c09a:	57                   	push   edi
1000c09b:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
1000c09e:	83 c3 54             	add    ebx,0x54
1000c0a1:	c1 7d 0c 03          	sar    DWORD PTR [ebp+0xc],0x3
1000c0a5:	83 e0 07             	and    eax,0x7
1000c0a8:	3b c1                	cmp    eax,ecx
1000c0aa:	74 27                	je     0x1000c0d3
1000c0ac:	8d 04 40             	lea    eax,[eax+eax*2]
1000c0af:	66 81 3c 83 00 80    	cmp    WORD PTR [ebx+eax*4],0x8000
1000c0b5:	8d 34 83             	lea    esi,[ebx+eax*4]
1000c0b8:	72 0c                	jb     0x1000c0c6
1000c0ba:	8d 7d f4             	lea    edi,[ebp-0xc]
1000c0bd:	a5                   	movs   DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000c0be:	a5                   	movs   DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000c0bf:	a5                   	movs   DWORD PTR es:[edi],DWORD PTR ds:[esi]
1000c0c0:	ff 4d f6             	dec    DWORD PTR [ebp-0xa]
1000c0c3:	8d 75 f4             	lea    esi,[ebp-0xc]
1000c0c6:	56                   	push   esi
1000c0c7:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000c0ca:	e8 72 fd ff ff       	call   0x1000be41
1000c0cf:	59                   	pop    ecx
1000c0d0:	59                   	pop    ecx
1000c0d1:	33 c9                	xor    ecx,ecx
1000c0d3:	39 4d 0c             	cmp    DWORD PTR [ebp+0xc],ecx
1000c0d6:	75 c3                	jne    0x1000c09b
1000c0d8:	5f                   	pop    edi
1000c0d9:	5e                   	pop    esi
1000c0da:	5b                   	pop    ebx
1000c0db:	c9                   	leave
1000c0dc:	c3                   	ret
1000c0dd:	56                   	push   esi
1000c0de:	8b 74 24 08          	mov    esi,DWORD PTR [esp+0x8]
1000c0e2:	57                   	push   edi
1000c0e3:	83 cf ff             	or     edi,0xffffffff
1000c0e6:	8b 46 0c             	mov    eax,DWORD PTR [esi+0xc]
1000c0e9:	a8 40                	test   al,0x40
1000c0eb:	74 05                	je     0x1000c0f2
1000c0ed:	83 c8 ff             	or     eax,0xffffffff
1000c0f0:	eb 3a                	jmp    0x1000c12c
1000c0f2:	a8 83                	test   al,0x83
1000c0f4:	74 34                	je     0x1000c12a
1000c0f6:	56                   	push   esi
1000c0f7:	e8 bd f9 ff ff       	call   0x1000bab9
1000c0fc:	56                   	push   esi
1000c0fd:	8b f8                	mov    edi,eax
1000c0ff:	e8 39 01 00 00       	call   0x1000c23d
1000c104:	ff 76 10             	push   DWORD PTR [esi+0x10]
1000c107:	e8 7e 00 00 00       	call   0x1000c18a
1000c10c:	83 c4 0c             	add    esp,0xc
1000c10f:	85 c0                	test   eax,eax
1000c111:	7d 05                	jge    0x1000c118
1000c113:	83 cf ff             	or     edi,0xffffffff
1000c116:	eb 12                	jmp    0x1000c12a
1000c118:	8b 46 1c             	mov    eax,DWORD PTR [esi+0x1c]
1000c11b:	85 c0                	test   eax,eax
1000c11d:	74 0b                	je     0x1000c12a
1000c11f:	50                   	push   eax
1000c120:	e8 05 9d ff ff       	call   0x10005e2a
1000c125:	83 66 1c 00          	and    DWORD PTR [esi+0x1c],0x0
1000c129:	59                   	pop    ecx
1000c12a:	8b c7                	mov    eax,edi
1000c12c:	83 66 0c 00          	and    DWORD PTR [esi+0xc],0x0
1000c130:	5f                   	pop    edi
1000c131:	5e                   	pop    esi
1000c132:	c3                   	ret
1000c133:	8b 44 24 04          	mov    eax,DWORD PTR [esp+0x4]
1000c137:	3b 05 a0 0b 01 10    	cmp    eax,DWORD PTR ds:0x10010ba0
1000c13d:	73 3d                	jae    0x1000c17c
1000c13f:	8b c8                	mov    ecx,eax
1000c141:	8b d0                	mov    edx,eax
1000c143:	c1 f9 05             	sar    ecx,0x5
1000c146:	83 e2 1f             	and    edx,0x1f
1000c149:	8b 0c 8d a0 0a 01 10 	mov    ecx,DWORD PTR [ecx*4+0x10010aa0]
1000c150:	f6 44 d1 04 01       	test   BYTE PTR [ecx+edx*8+0x4],0x1
1000c155:	74 25                	je     0x1000c17c
1000c157:	50                   	push   eax
1000c158:	e8 72 f7 ff ff       	call   0x1000b8cf
1000c15d:	59                   	pop    ecx
1000c15e:	50                   	push   eax
1000c15f:	ff 15 d0 d0 00 10    	call   DWORD PTR ds:0x1000d0d0
1000c165:	85 c0                	test   eax,eax
1000c167:	75 08                	jne    0x1000c171
1000c169:	ff 15 8c d0 00 10    	call   DWORD PTR ds:0x1000d08c
1000c16f:	eb 02                	jmp    0x1000c173
1000c171:	33 c0                	xor    eax,eax
1000c173:	85 c0                	test   eax,eax
1000c175:	74 12                	je     0x1000c189
1000c177:	a3 50 f6 00 10       	mov    ds:0x1000f650,eax
1000c17c:	c7 05 4c f6 00 10 09 	mov    DWORD PTR ds:0x1000f64c,0x9
1000c183:	00 00 00 
1000c186:	83 c8 ff             	or     eax,0xffffffff
1000c189:	c3                   	ret
1000c18a:	53                   	push   ebx
1000c18b:	55                   	push   ebp
1000c18c:	56                   	push   esi
1000c18d:	57                   	push   edi
1000c18e:	8b 7c 24 14          	mov    edi,DWORD PTR [esp+0x14]
1000c192:	3b 3d a0 0b 01 10    	cmp    edi,DWORD PTR ds:0x10010ba0
1000c198:	0f 83 86 00 00 00    	jae    0x1000c224
1000c19e:	8b c7                	mov    eax,edi
1000c1a0:	8b f7                	mov    esi,edi
1000c1a2:	c1 f8 05             	sar    eax,0x5
1000c1a5:	83 e6 1f             	and    esi,0x1f
1000c1a8:	8d 1c 85 a0 0a 01 10 	lea    ebx,[eax*4+0x10010aa0]
1000c1af:	c1 e6 03             	shl    esi,0x3
1000c1b2:	8b 03                	mov    eax,DWORD PTR [ebx]
1000c1b4:	f6 44 30 04 01       	test   BYTE PTR [eax+esi*1+0x4],0x1
1000c1b9:	74 69                	je     0x1000c224
1000c1bb:	57                   	push   edi
1000c1bc:	e8 0e f7 ff ff       	call   0x1000b8cf
1000c1c1:	83 f8 ff             	cmp    eax,0xffffffff
1000c1c4:	59                   	pop    ecx
1000c1c5:	74 3c                	je     0x1000c203
1000c1c7:	83 ff 01             	cmp    edi,0x1
1000c1ca:	74 05                	je     0x1000c1d1
1000c1cc:	83 ff 02             	cmp    edi,0x2
1000c1cf:	75 16                	jne    0x1000c1e7
1000c1d1:	6a 02                	push   0x2
1000c1d3:	e8 f7 f6 ff ff       	call   0x1000b8cf
1000c1d8:	6a 01                	push   0x1
1000c1da:	8b e8                	mov    ebp,eax
1000c1dc:	e8 ee f6 ff ff       	call   0x1000b8cf
1000c1e1:	59                   	pop    ecx
1000c1e2:	3b c5                	cmp    eax,ebp
1000c1e4:	59                   	pop    ecx
1000c1e5:	74 1c                	je     0x1000c203
1000c1e7:	57                   	push   edi
1000c1e8:	e8 e2 f6 ff ff       	call   0x1000b8cf
1000c1ed:	59                   	pop    ecx
1000c1ee:	50                   	push   eax
1000c1ef:	ff 15 0c d0 00 10    	call   DWORD PTR ds:0x1000d00c
1000c1f5:	85 c0                	test   eax,eax
1000c1f7:	75 0a                	jne    0x1000c203
1000c1f9:	ff 15 8c d0 00 10    	call   DWORD PTR ds:0x1000d08c
1000c1ff:	8b e8                	mov    ebp,eax
1000c201:	eb 02                	jmp    0x1000c205
1000c203:	33 ed                	xor    ebp,ebp
1000c205:	57                   	push   edi
1000c206:	e8 4a f6 ff ff       	call   0x1000b855
1000c20b:	8b 03                	mov    eax,DWORD PTR [ebx]
1000c20d:	59                   	pop    ecx
1000c20e:	80 64 30 04 00       	and    BYTE PTR [eax+esi*1+0x4],0x0
1000c213:	85 ed                	test   ebp,ebp
1000c215:	74 09                	je     0x1000c220
1000c217:	55                   	push   ebp
1000c218:	e8 c5 f4 ff ff       	call   0x1000b6e2
1000c21d:	59                   	pop    ecx
1000c21e:	eb 15                	jmp    0x1000c235
1000c220:	33 c0                	xor    eax,eax
1000c222:	eb 14                	jmp    0x1000c238
1000c224:	83 25 50 f6 00 10 00 	and    DWORD PTR ds:0x1000f650,0x0
1000c22b:	c7 05 4c f6 00 10 09 	mov    DWORD PTR ds:0x1000f64c,0x9
1000c232:	00 00 00 
1000c235:	83 c8 ff             	or     eax,0xffffffff
1000c238:	5f                   	pop    edi
1000c239:	5e                   	pop    esi
1000c23a:	5d                   	pop    ebp
1000c23b:	5b                   	pop    ebx
1000c23c:	c3                   	ret
1000c23d:	56                   	push   esi
1000c23e:	8b 74 24 08          	mov    esi,DWORD PTR [esp+0x8]
1000c242:	8b 46 0c             	mov    eax,DWORD PTR [esi+0xc]
1000c245:	a8 83                	test   al,0x83
1000c247:	74 1d                	je     0x1000c266
1000c249:	a8 08                	test   al,0x8
1000c24b:	74 19                	je     0x1000c266
1000c24d:	ff 76 08             	push   DWORD PTR [esi+0x8]
1000c250:	e8 d5 9b ff ff       	call   0x10005e2a
1000c255:	66 81 66 0c f7 fb    	and    WORD PTR [esi+0xc],0xfbf7
1000c25b:	33 c0                	xor    eax,eax
1000c25d:	59                   	pop    ecx
1000c25e:	89 06                	mov    DWORD PTR [esi],eax
1000c260:	89 46 08             	mov    DWORD PTR [esi+0x8],eax
1000c263:	89 46 04             	mov    DWORD PTR [esi+0x4],eax
1000c266:	5e                   	pop    esi
1000c267:	c3                   	ret
1000c268:	cc                   	int3
1000c269:	cc                   	int3
1000c26a:	cc                   	int3
1000c26b:	cc                   	int3
1000c26c:	cc                   	int3
1000c26d:	cc                   	int3
1000c26e:	cc                   	int3
1000c26f:	cc                   	int3
1000c270:	ff 25 6c d0 00 10    	jmp    DWORD PTR ds:0x1000d06c
1000c276:	ff 25 04 d0 00 10    	jmp    DWORD PTR ds:0x1000d004
1000c27c:	ff 25 08 d0 00 10    	jmp    DWORD PTR ds:0x1000d008
1000c282:	ff 25 0c d0 00 10    	jmp    DWORD PTR ds:0x1000d00c
1000c288:	ff 25 10 d0 00 10    	jmp    DWORD PTR ds:0x1000d010
1000c28e:	ff 25 14 d0 00 10    	jmp    DWORD PTR ds:0x1000d014
1000c294:	ff 25 18 d0 00 10    	jmp    DWORD PTR ds:0x1000d018
1000c29a:	ff 25 1c d0 00 10    	jmp    DWORD PTR ds:0x1000d01c
1000c2a0:	ff 25 20 d0 00 10    	jmp    DWORD PTR ds:0x1000d020
1000c2a6:	ff 25 24 d0 00 10    	jmp    DWORD PTR ds:0x1000d024
1000c2ac:	ff 25 28 d0 00 10    	jmp    DWORD PTR ds:0x1000d028
1000c2b2:	ff 25 2c d0 00 10    	jmp    DWORD PTR ds:0x1000d02c
1000c2b8:	ff 25 30 d0 00 10    	jmp    DWORD PTR ds:0x1000d030
1000c2be:	ff 25 34 d0 00 10    	jmp    DWORD PTR ds:0x1000d034
1000c2c4:	ff 25 38 d0 00 10    	jmp    DWORD PTR ds:0x1000d038
1000c2ca:	ff 25 3c d0 00 10    	jmp    DWORD PTR ds:0x1000d03c
1000c2d0:	ff 25 40 d0 00 10    	jmp    DWORD PTR ds:0x1000d040
1000c2d6:	ff 25 44 d0 00 10    	jmp    DWORD PTR ds:0x1000d044
1000c2dc:	ff 25 48 d0 00 10    	jmp    DWORD PTR ds:0x1000d048
1000c2e2:	ff 25 4c d0 00 10    	jmp    DWORD PTR ds:0x1000d04c
1000c2e8:	ff 25 50 d0 00 10    	jmp    DWORD PTR ds:0x1000d050
1000c2ee:	ff 25 54 d0 00 10    	jmp    DWORD PTR ds:0x1000d054
1000c2f4:	ff 25 58 d0 00 10    	jmp    DWORD PTR ds:0x1000d058
1000c2fa:	ff 25 5c d0 00 10    	jmp    DWORD PTR ds:0x1000d05c
1000c300:	ff 25 60 d0 00 10    	jmp    DWORD PTR ds:0x1000d060
1000c306:	ff 25 64 d0 00 10    	jmp    DWORD PTR ds:0x1000d064
1000c30c:	ff 25 68 d0 00 10    	jmp    DWORD PTR ds:0x1000d068
1000c312:	ff 25 00 d0 00 10    	jmp    DWORD PTR ds:0x1000d000
1000c318:	ff 25 70 d0 00 10    	jmp    DWORD PTR ds:0x1000d070
1000c31e:	ff 25 74 d0 00 10    	jmp    DWORD PTR ds:0x1000d074
1000c324:	ff 25 78 d0 00 10    	jmp    DWORD PTR ds:0x1000d078
1000c32a:	ff 25 7c d0 00 10    	jmp    DWORD PTR ds:0x1000d07c
1000c330:	ff 25 80 d0 00 10    	jmp    DWORD PTR ds:0x1000d080
1000c336:	ff 25 84 d0 00 10    	jmp    DWORD PTR ds:0x1000d084
1000c33c:	ff 25 88 d0 00 10    	jmp    DWORD PTR ds:0x1000d088
1000c342:	ff 25 8c d0 00 10    	jmp    DWORD PTR ds:0x1000d08c
1000c348:	ff 25 90 d0 00 10    	jmp    DWORD PTR ds:0x1000d090
1000c34e:	ff 25 94 d0 00 10    	jmp    DWORD PTR ds:0x1000d094
1000c354:	ff 25 98 d0 00 10    	jmp    DWORD PTR ds:0x1000d098
1000c35a:	ff 25 9c d0 00 10    	jmp    DWORD PTR ds:0x1000d09c
1000c360:	ff 25 a0 d0 00 10    	jmp    DWORD PTR ds:0x1000d0a0
1000c366:	ff 25 a4 d0 00 10    	jmp    DWORD PTR ds:0x1000d0a4
1000c36c:	ff 25 a8 d0 00 10    	jmp    DWORD PTR ds:0x1000d0a8
1000c372:	ff 25 ac d0 00 10    	jmp    DWORD PTR ds:0x1000d0ac
1000c378:	ff 25 b0 d0 00 10    	jmp    DWORD PTR ds:0x1000d0b0
1000c37e:	ff 25 b4 d0 00 10    	jmp    DWORD PTR ds:0x1000d0b4
1000c384:	ff 25 b8 d0 00 10    	jmp    DWORD PTR ds:0x1000d0b8
1000c38a:	ff 25 bc d0 00 10    	jmp    DWORD PTR ds:0x1000d0bc
1000c390:	ff 25 c0 d0 00 10    	jmp    DWORD PTR ds:0x1000d0c0
1000c396:	ff 25 c4 d0 00 10    	jmp    DWORD PTR ds:0x1000d0c4
1000c39c:	ff 25 c8 d0 00 10    	jmp    DWORD PTR ds:0x1000d0c8
1000c3a2:	ff 25 cc d0 00 10    	jmp    DWORD PTR ds:0x1000d0cc
1000c3a8:	ff 25 d0 d0 00 10    	jmp    DWORD PTR ds:0x1000d0d0
1000c3ae:	55                   	push   ebp
1000c3af:	8b ec                	mov    ebp,esp
1000c3b1:	83 7d 10 0a          	cmp    DWORD PTR [ebp+0x10],0xa
1000c3b5:	75 0c                	jne    0x1000c3c3
1000c3b7:	83 7d 08 00          	cmp    DWORD PTR [ebp+0x8],0x0
1000c3bb:	7d 06                	jge    0x1000c3c3
1000c3bd:	6a 01                	push   0x1
1000c3bf:	6a 0a                	push   0xa
1000c3c1:	eb 05                	jmp    0x1000c3c8
1000c3c3:	6a 00                	push   0x0
1000c3c5:	ff 75 10             	push   DWORD PTR [ebp+0x10]
1000c3c8:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
1000c3cb:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000c3ce:	e8 08 00 00 00       	call   0x1000c3db
1000c3d3:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
1000c3d6:	83 c4 10             	add    esp,0x10
1000c3d9:	5d                   	pop    ebp
1000c3da:	c3                   	ret
1000c3db:	55                   	push   ebp
1000c3dc:	8b ec                	mov    ebp,esp
1000c3de:	83 7d 14 00          	cmp    DWORD PTR [ebp+0x14],0x0
1000c3e2:	8b 4d 0c             	mov    ecx,DWORD PTR [ebp+0xc]
1000c3e5:	53                   	push   ebx
1000c3e6:	56                   	push   esi
1000c3e7:	57                   	push   edi
1000c3e8:	74 0b                	je     0x1000c3f5
1000c3ea:	8b 75 08             	mov    esi,DWORD PTR [ebp+0x8]
1000c3ed:	c6 01 2d             	mov    BYTE PTR [ecx],0x2d
1000c3f0:	41                   	inc    ecx
1000c3f1:	f7 de                	neg    esi
1000c3f3:	eb 03                	jmp    0x1000c3f8
1000c3f5:	8b 75 08             	mov    esi,DWORD PTR [ebp+0x8]
1000c3f8:	8b f9                	mov    edi,ecx
1000c3fa:	8b c6                	mov    eax,esi
1000c3fc:	33 d2                	xor    edx,edx
1000c3fe:	f7 75 10             	div    DWORD PTR [ebp+0x10]
1000c401:	8b c6                	mov    eax,esi
1000c403:	8b da                	mov    ebx,edx
1000c405:	33 d2                	xor    edx,edx
1000c407:	f7 75 10             	div    DWORD PTR [ebp+0x10]
1000c40a:	83 fb 09             	cmp    ebx,0x9
1000c40d:	8b f0                	mov    esi,eax
1000c40f:	76 05                	jbe    0x1000c416
1000c411:	80 c3 57             	add    bl,0x57
1000c414:	eb 03                	jmp    0x1000c419
1000c416:	80 c3 30             	add    bl,0x30
1000c419:	88 19                	mov    BYTE PTR [ecx],bl
1000c41b:	41                   	inc    ecx
1000c41c:	85 f6                	test   esi,esi
1000c41e:	77 da                	ja     0x1000c3fa
1000c420:	80 21 00             	and    BYTE PTR [ecx],0x0
1000c423:	49                   	dec    ecx
1000c424:	8a 17                	mov    dl,BYTE PTR [edi]
1000c426:	8a 01                	mov    al,BYTE PTR [ecx]
1000c428:	88 11                	mov    BYTE PTR [ecx],dl
1000c42a:	88 07                	mov    BYTE PTR [edi],al
1000c42c:	49                   	dec    ecx
1000c42d:	47                   	inc    edi
1000c42e:	3b f9                	cmp    edi,ecx
1000c430:	72 f2                	jb     0x1000c424
1000c432:	5f                   	pop    edi
1000c433:	5e                   	pop    esi
1000c434:	5b                   	pop    ebx
1000c435:	5d                   	pop    ebp
1000c436:	c3                   	ret
1000c437:	55                   	push   ebp
1000c438:	8b ec                	mov    ebp,esp
1000c43a:	33 c0                	xor    eax,eax
1000c43c:	83 7d 10 0a          	cmp    DWORD PTR [ebp+0x10],0xa
1000c440:	75 08                	jne    0x1000c44a
1000c442:	39 45 08             	cmp    DWORD PTR [ebp+0x8],eax
1000c445:	7d 03                	jge    0x1000c44a
1000c447:	6a 01                	push   0x1
1000c449:	58                   	pop    eax
1000c44a:	50                   	push   eax
1000c44b:	ff 75 10             	push   DWORD PTR [ebp+0x10]
1000c44e:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
1000c451:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000c454:	e8 82 ff ff ff       	call   0x1000c3db
1000c459:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
1000c45c:	83 c4 10             	add    esp,0x10
1000c45f:	5d                   	pop    ebp
1000c460:	c3                   	ret
1000c461:	6a 00                	push   0x0
1000c463:	ff 74 24 10          	push   DWORD PTR [esp+0x10]
1000c467:	ff 74 24 10          	push   DWORD PTR [esp+0x10]
1000c46b:	ff 74 24 10          	push   DWORD PTR [esp+0x10]
1000c46f:	e8 67 ff ff ff       	call   0x1000c3db
1000c474:	8b 44 24 18          	mov    eax,DWORD PTR [esp+0x18]
1000c478:	83 c4 10             	add    esp,0x10
1000c47b:	c3                   	ret
1000c47c:	55                   	push   ebp
1000c47d:	8b ec                	mov    ebp,esp
1000c47f:	33 c0                	xor    eax,eax
1000c481:	83 7d 14 0a          	cmp    DWORD PTR [ebp+0x14],0xa
1000c485:	75 0f                	jne    0x1000c496
1000c487:	39 45 0c             	cmp    DWORD PTR [ebp+0xc],eax
1000c48a:	7f 0a                	jg     0x1000c496
1000c48c:	7c 05                	jl     0x1000c493
1000c48e:	39 45 08             	cmp    DWORD PTR [ebp+0x8],eax
1000c491:	73 03                	jae    0x1000c496
1000c493:	6a 01                	push   0x1
1000c495:	58                   	pop    eax
1000c496:	50                   	push   eax
1000c497:	ff 75 14             	push   DWORD PTR [ebp+0x14]
1000c49a:	ff 75 10             	push   DWORD PTR [ebp+0x10]
1000c49d:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
1000c4a0:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000c4a3:	e8 05 00 00 00       	call   0x1000c4ad
1000c4a8:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
1000c4ab:	5d                   	pop    ebp
1000c4ac:	c3                   	ret
1000c4ad:	55                   	push   ebp
1000c4ae:	8b ec                	mov    ebp,esp
1000c4b0:	83 7d 18 00          	cmp    DWORD PTR [ebp+0x18],0x0
1000c4b4:	53                   	push   ebx
1000c4b5:	56                   	push   esi
1000c4b6:	8b 75 10             	mov    esi,DWORD PTR [ebp+0x10]
1000c4b9:	57                   	push   edi
1000c4ba:	74 13                	je     0x1000c4cf
1000c4bc:	8b 5d 08             	mov    ebx,DWORD PTR [ebp+0x8]
1000c4bf:	8b 7d 0c             	mov    edi,DWORD PTR [ebp+0xc]
1000c4c2:	c6 06 2d             	mov    BYTE PTR [esi],0x2d
1000c4c5:	46                   	inc    esi
1000c4c6:	f7 db                	neg    ebx
1000c4c8:	83 d7 00             	adc    edi,0x0
1000c4cb:	f7 df                	neg    edi
1000c4cd:	eb 06                	jmp    0x1000c4d5
1000c4cf:	8b 7d 0c             	mov    edi,DWORD PTR [ebp+0xc]
1000c4d2:	8b 5d 08             	mov    ebx,DWORD PTR [ebp+0x8]
1000c4d5:	89 75 10             	mov    DWORD PTR [ebp+0x10],esi
1000c4d8:	33 c0                	xor    eax,eax
1000c4da:	50                   	push   eax
1000c4db:	ff 75 14             	push   DWORD PTR [ebp+0x14]
1000c4de:	57                   	push   edi
1000c4df:	53                   	push   ebx
1000c4e0:	e8 3b d8 ff ff       	call   0x10009d20
1000c4e5:	89 45 18             	mov    DWORD PTR [ebp+0x18],eax
1000c4e8:	33 c0                	xor    eax,eax
1000c4ea:	50                   	push   eax
1000c4eb:	ff 75 14             	push   DWORD PTR [ebp+0x14]
1000c4ee:	57                   	push   edi
1000c4ef:	53                   	push   ebx
1000c4f0:	e8 bb d7 ff ff       	call   0x10009cb0
1000c4f5:	8b d8                	mov    ebx,eax
1000c4f7:	8b 45 18             	mov    eax,DWORD PTR [ebp+0x18]
1000c4fa:	83 f8 09             	cmp    eax,0x9
1000c4fd:	8b fa                	mov    edi,edx
1000c4ff:	76 04                	jbe    0x1000c505
1000c501:	04 57                	add    al,0x57
1000c503:	eb 02                	jmp    0x1000c507
1000c505:	04 30                	add    al,0x30
1000c507:	88 06                	mov    BYTE PTR [esi],al
1000c509:	46                   	inc    esi
1000c50a:	85 ff                	test   edi,edi
1000c50c:	77 ca                	ja     0x1000c4d8
1000c50e:	72 04                	jb     0x1000c514
1000c510:	85 db                	test   ebx,ebx
1000c512:	77 c4                	ja     0x1000c4d8
1000c514:	80 26 00             	and    BYTE PTR [esi],0x0
1000c517:	4e                   	dec    esi
1000c518:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
1000c51b:	8a 0e                	mov    cl,BYTE PTR [esi]
1000c51d:	8a 10                	mov    dl,BYTE PTR [eax]
1000c51f:	88 16                	mov    BYTE PTR [esi],dl
1000c521:	88 08                	mov    BYTE PTR [eax],cl
1000c523:	4e                   	dec    esi
1000c524:	40                   	inc    eax
1000c525:	3b c6                	cmp    eax,esi
1000c527:	89 45 10             	mov    DWORD PTR [ebp+0x10],eax
1000c52a:	72 ec                	jb     0x1000c518
1000c52c:	5f                   	pop    edi
1000c52d:	5e                   	pop    esi
1000c52e:	5b                   	pop    ebx
1000c52f:	5d                   	pop    ebp
1000c530:	c2 14 00             	ret    0x14
1000c533:	55                   	push   ebp
1000c534:	8b ec                	mov    ebp,esp
1000c536:	6a 00                	push   0x0
1000c538:	ff 75 14             	push   DWORD PTR [ebp+0x14]
1000c53b:	ff 75 10             	push   DWORD PTR [ebp+0x10]
1000c53e:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
1000c541:	ff 75 08             	push   DWORD PTR [ebp+0x8]
1000c544:	e8 64 ff ff ff       	call   0x1000c4ad
1000c549:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
1000c54c:	5d                   	pop    ebp
1000c54d:	c3                   	ret
1000c54e:	cc                   	int3
1000c54f:	cc                   	int3
1000c550:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000c553:	50                   	push   eax
1000c554:	e8 3e 8c ff ff       	call   0x10005197
1000c559:	59                   	pop    ecx
1000c55a:	c3                   	ret
1000c55b:	b8 18 d6 00 10       	mov    eax,0x1000d618
1000c560:	e9 35 8d ff ff       	jmp    0x1000529a
1000c565:	cc                   	int3
1000c566:	cc                   	int3
1000c567:	cc                   	int3
1000c568:	cc                   	int3
1000c569:	cc                   	int3
1000c56a:	cc                   	int3
1000c56b:	cc                   	int3
1000c56c:	cc                   	int3
1000c56d:	cc                   	int3
1000c56e:	cc                   	int3
1000c56f:	cc                   	int3
1000c570:	8b 45 ec             	mov    eax,DWORD PTR [ebp-0x14]
1000c573:	50                   	push   eax
1000c574:	e8 1e 8c ff ff       	call   0x10005197
1000c579:	59                   	pop    ecx
1000c57a:	c3                   	ret
1000c57b:	b8 40 d6 00 10       	mov    eax,0x1000d640
1000c580:	e9 15 8d ff ff       	jmp    0x1000529a
1000c585:	cc                   	int3
1000c586:	cc                   	int3
1000c587:	cc                   	int3
1000c588:	cc                   	int3
1000c589:	cc                   	int3
1000c58a:	cc                   	int3
1000c58b:	cc                   	int3
1000c58c:	cc                   	int3
1000c58d:	cc                   	int3
1000c58e:	cc                   	int3
1000c58f:	cc                   	int3
1000c590:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
1000c593:	e9 18 61 ff ff       	jmp    0x100026b0
1000c598:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000c59b:	50                   	push   eax
1000c59c:	e8 f6 8b ff ff       	call   0x10005197
1000c5a1:	59                   	pop    ecx
1000c5a2:	c3                   	ret
1000c5a3:	b8 68 d6 00 10       	mov    eax,0x1000d668
1000c5a8:	e9 ed 8c ff ff       	jmp    0x1000529a
1000c5ad:	cc                   	int3
1000c5ae:	cc                   	int3
1000c5af:	cc                   	int3
1000c5b0:	8b 4d ec             	mov    ecx,DWORD PTR [ebp-0x14]
1000c5b3:	e9 f8 60 ff ff       	jmp    0x100026b0
1000c5b8:	b8 98 d6 00 10       	mov    eax,0x1000d698
1000c5bd:	e9 d8 8c ff ff       	jmp    0x1000529a
1000c5c2:	cc                   	int3
1000c5c3:	cc                   	int3
1000c5c4:	cc                   	int3
1000c5c5:	cc                   	int3
1000c5c6:	cc                   	int3
1000c5c7:	cc                   	int3
1000c5c8:	cc                   	int3
1000c5c9:	cc                   	int3
1000c5ca:	cc                   	int3
1000c5cb:	cc                   	int3
1000c5cc:	cc                   	int3
1000c5cd:	cc                   	int3
1000c5ce:	cc                   	int3
1000c5cf:	cc                   	int3
1000c5d0:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
1000c5d3:	50                   	push   eax
1000c5d4:	e8 be 8b ff ff       	call   0x10005197
1000c5d9:	59                   	pop    ecx
1000c5da:	c3                   	ret
1000c5db:	b8 c0 d6 00 10       	mov    eax,0x1000d6c0
1000c5e0:	e9 b5 8c ff ff       	jmp    0x1000529a
1000c5e5:	cc                   	int3
1000c5e6:	cc                   	int3
1000c5e7:	cc                   	int3
1000c5e8:	cc                   	int3
1000c5e9:	cc                   	int3
1000c5ea:	cc                   	int3
1000c5eb:	cc                   	int3
1000c5ec:	cc                   	int3
1000c5ed:	cc                   	int3
1000c5ee:	cc                   	int3
1000c5ef:	cc                   	int3
1000c5f0:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
1000c5f3:	e9 b8 60 ff ff       	jmp    0x100026b0
1000c5f8:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000c5fb:	50                   	push   eax
1000c5fc:	e8 96 8b ff ff       	call   0x10005197
1000c601:	59                   	pop    ecx
1000c602:	c3                   	ret
1000c603:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000c606:	50                   	push   eax
1000c607:	e8 8b 8b ff ff       	call   0x10005197
1000c60c:	59                   	pop    ecx
1000c60d:	c3                   	ret
1000c60e:	b8 e8 d6 00 10       	mov    eax,0x1000d6e8
1000c613:	e9 82 8c ff ff       	jmp    0x1000529a
1000c618:	cc                   	int3
1000c619:	cc                   	int3
1000c61a:	cc                   	int3
1000c61b:	cc                   	int3
1000c61c:	cc                   	int3
1000c61d:	cc                   	int3
1000c61e:	cc                   	int3
1000c61f:	cc                   	int3
1000c620:	8b 4d ec             	mov    ecx,DWORD PTR [ebp-0x14]
1000c623:	e9 88 60 ff ff       	jmp    0x100026b0
1000c628:	b8 20 d7 00 10       	mov    eax,0x1000d720
1000c62d:	e9 68 8c ff ff       	jmp    0x1000529a
1000c632:	cc                   	int3
1000c633:	cc                   	int3
1000c634:	cc                   	int3
1000c635:	cc                   	int3
1000c636:	cc                   	int3
1000c637:	cc                   	int3
1000c638:	cc                   	int3
1000c639:	cc                   	int3
1000c63a:	cc                   	int3
1000c63b:	cc                   	int3
1000c63c:	cc                   	int3
1000c63d:	cc                   	int3
1000c63e:	cc                   	int3
1000c63f:	cc                   	int3
1000c640:	8b 45 e8             	mov    eax,DWORD PTR [ebp-0x18]
1000c643:	50                   	push   eax
1000c644:	e8 4e 8b ff ff       	call   0x10005197
1000c649:	59                   	pop    ecx
1000c64a:	c3                   	ret
1000c64b:	8b 45 e8             	mov    eax,DWORD PTR [ebp-0x18]
1000c64e:	50                   	push   eax
1000c64f:	e8 43 8b ff ff       	call   0x10005197
1000c654:	59                   	pop    ecx
1000c655:	c3                   	ret
1000c656:	8b 45 e8             	mov    eax,DWORD PTR [ebp-0x18]
1000c659:	50                   	push   eax
1000c65a:	e8 38 8b ff ff       	call   0x10005197
1000c65f:	59                   	pop    ecx
1000c660:	c3                   	ret
1000c661:	b8 48 d7 00 10       	mov    eax,0x1000d748
1000c666:	e9 2f 8c ff ff       	jmp    0x1000529a
1000c66b:	cc                   	int3
1000c66c:	cc                   	int3
1000c66d:	cc                   	int3
1000c66e:	cc                   	int3
1000c66f:	cc                   	int3
1000c670:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
1000c673:	50                   	push   eax
1000c674:	e8 1e 8b ff ff       	call   0x10005197
1000c679:	59                   	pop    ecx
1000c67a:	c3                   	ret
1000c67b:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
1000c67e:	50                   	push   eax
1000c67f:	e8 13 8b ff ff       	call   0x10005197
1000c684:	59                   	pop    ecx
1000c685:	c3                   	ret
1000c686:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
1000c689:	50                   	push   eax
1000c68a:	e8 08 8b ff ff       	call   0x10005197
1000c68f:	59                   	pop    ecx
1000c690:	c3                   	ret
1000c691:	b8 80 d7 00 10       	mov    eax,0x1000d780
1000c696:	e9 ff 8b ff ff       	jmp    0x1000529a
1000c69b:	cc                   	int3
1000c69c:	cc                   	int3
1000c69d:	cc                   	int3
1000c69e:	cc                   	int3
1000c69f:	cc                   	int3
1000c6a0:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000c6a3:	50                   	push   eax
1000c6a4:	e8 ee 8a ff ff       	call   0x10005197
1000c6a9:	59                   	pop    ecx
1000c6aa:	c3                   	ret
1000c6ab:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000c6ae:	50                   	push   eax
1000c6af:	e8 e3 8a ff ff       	call   0x10005197
1000c6b4:	59                   	pop    ecx
1000c6b5:	c3                   	ret
1000c6b6:	b8 b8 d7 00 10       	mov    eax,0x1000d7b8
1000c6bb:	e9 da 8b ff ff       	jmp    0x1000529a
1000c6c0:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
1000c6c3:	50                   	push   eax
1000c6c4:	e8 ce 8a ff ff       	call   0x10005197
1000c6c9:	59                   	pop    ecx
1000c6ca:	c3                   	ret
1000c6cb:	b8 e8 d7 00 10       	mov    eax,0x1000d7e8
1000c6d0:	e9 c5 8b ff ff       	jmp    0x1000529a
1000c6d5:	cc                   	int3
1000c6d6:	cc                   	int3
1000c6d7:	cc                   	int3
1000c6d8:	cc                   	int3
1000c6d9:	cc                   	int3
1000c6da:	cc                   	int3
1000c6db:	cc                   	int3
1000c6dc:	cc                   	int3
1000c6dd:	cc                   	int3
1000c6de:	cc                   	int3
1000c6df:	cc                   	int3
1000c6e0:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
1000c6e3:	e9 c8 5f ff ff       	jmp    0x100026b0
1000c6e8:	b8 10 d8 00 10       	mov    eax,0x1000d810
1000c6ed:	e9 a8 8b ff ff       	jmp    0x1000529a
1000c6f2:	cc                   	int3
1000c6f3:	cc                   	int3
1000c6f4:	cc                   	int3
1000c6f5:	cc                   	int3
1000c6f6:	cc                   	int3
1000c6f7:	cc                   	int3
1000c6f8:	cc                   	int3
1000c6f9:	cc                   	int3
1000c6fa:	cc                   	int3
1000c6fb:	cc                   	int3
1000c6fc:	cc                   	int3
1000c6fd:	cc                   	int3
1000c6fe:	cc                   	int3
1000c6ff:	cc                   	int3
1000c700:	8b 4d f0             	mov    ecx,DWORD PTR [ebp-0x10]
1000c703:	e9 a8 5f ff ff       	jmp    0x100026b0
1000c708:	b8 38 d8 00 10       	mov    eax,0x1000d838
1000c70d:	e9 88 8b ff ff       	jmp    0x1000529a
1000c712:	cc                   	int3
1000c713:	cc                   	int3
1000c714:	cc                   	int3
1000c715:	cc                   	int3
1000c716:	cc                   	int3
1000c717:	cc                   	int3
1000c718:	cc                   	int3
1000c719:	cc                   	int3
1000c71a:	cc                   	int3
1000c71b:	cc                   	int3
1000c71c:	cc                   	int3
1000c71d:	cc                   	int3
1000c71e:	cc                   	int3
1000c71f:	cc                   	int3
1000c720:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000c723:	50                   	push   eax
1000c724:	e8 6e 8a ff ff       	call   0x10005197
1000c729:	59                   	pop    ecx
1000c72a:	c3                   	ret
1000c72b:	b8 60 d8 00 10       	mov    eax,0x1000d860
1000c730:	e9 65 8b ff ff       	jmp    0x1000529a
1000c735:	cc                   	int3
1000c736:	cc                   	int3
1000c737:	cc                   	int3
1000c738:	cc                   	int3
1000c739:	cc                   	int3
1000c73a:	cc                   	int3
1000c73b:	cc                   	int3
1000c73c:	cc                   	int3
1000c73d:	cc                   	int3
1000c73e:	cc                   	int3
1000c73f:	cc                   	int3
1000c740:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
1000c743:	50                   	push   eax
1000c744:	e8 4e 8a ff ff       	call   0x10005197
1000c749:	59                   	pop    ecx
1000c74a:	c3                   	ret
1000c74b:	b8 88 d8 00 10       	mov    eax,0x1000d888
1000c750:	e9 45 8b ff ff       	jmp    0x1000529a
