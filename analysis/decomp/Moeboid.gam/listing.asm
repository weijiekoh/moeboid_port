
;==== FUNCTION FUN_10001000 @ 10001000 : undefined FUN_10001000(void * this, int * param_1)
  10001000  PUSH EBP
  10001001  MOV EBP,ESP
  10001003  PUSH ESI
  10001004  MOV ESI,ECX
  10001006  PUSH EDI
  10001007  FLD float ptr [ESI + 0xc]
  1000100a  CALL 0x10005110    ; __ftol
  1000100f  MOV ECX,EAX
  10001011  MOV EAX,dword ptr [ESI + 0x1c]
  10001014  CDQ
  10001015  MOV EDI,dword ptr [EBP + 0x8]
  10001018  SUB EAX,EDX
  1000101a  SAR EAX,0x1
  1000101c  SUB ECX,EAX
  1000101e  ADD ECX,0x3
  10001021  MOV dword ptr [EDI],ECX
  10001023  FLD float ptr [ESI + 0x10]
  10001026  CALL 0x10005110    ; __ftol
  1000102b  MOV ECX,EAX
  1000102d  MOV EAX,dword ptr [ESI + 0x20]
  10001030  CDQ
  10001031  SUB EAX,EDX
  10001033  MOV EDX,dword ptr [EDI]
  10001035  SAR EAX,0x1
  10001037  SUB ECX,EAX
  10001039  ADD ECX,0x3
  1000103c  MOV dword ptr [EDI + 0x4],ECX
  1000103f  MOV EAX,dword ptr [ESI + 0x1c]
  10001042  LEA ECX,[EDX + EAX*0x1 + -0x3]
  10001046  MOV EAX,dword ptr [EDI + 0x4]
  10001049  MOV dword ptr [EDI + 0x8],ECX
  1000104c  MOV EDX,dword ptr [ESI + 0x20]
  1000104f  LEA ECX,[EDX + EAX*0x1 + -0x3]
  10001053  MOV dword ptr [EDI + 0xc],ECX
  10001056  POP EDI
  10001057  POP ESI
  10001058  POP EBP
  10001059  RET 0x4

;==== FUNCTION FUN_10001060 @ 10001060 : undefined FUN_10001060(int * param_1)
  10001060  PUSH EBP
  10001061  MOV EBP,ESP
  10001063  SUB ESP,0x8
  10001066  PUSH ESI
  10001067  MOV ESI,ECX
  10001069  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  1000106f  MOV EAX,dword ptr [ECX]
  10001071  CALL dword ptr [EAX + 0x8]
  10001074  XOR EDX,EDX
  10001076  MOV ECX,0x32
  1000107b  DIV ECX
  1000107d  MOV dword ptr [EBP + -0x4],0x0
  10001084  MOV dword ptr [EBP + -0x8],EDX
  10001087  FILD qword ptr [EBP + -0x8]
  1000108a  FMUL float ptr [0x1000d100]    ; DAT_1000d100
  10001090  FSTP float ptr [ESI + 0x14]
  10001093  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  10001099  MOV EDX,dword ptr [ECX]
  1000109b  CALL dword ptr [EDX + 0x8]
  1000109e  TEST AL,0x1
  100010a0  JNZ 0x100010ae    ; LAB_100010ae
  100010a2  FLD float ptr [ESI + 0x14]
  100010a5  FMUL float ptr [0x1000d0fc]    ; DAT_1000d0fc
  100010ab  FSTP float ptr [ESI + 0x14]
LAB_100010ae:
  100010ae  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  100010b4  MOV EAX,dword ptr [ECX]
  100010b6  CALL dword ptr [EAX + 0x8]
  100010b9  XOR EDX,EDX
  100010bb  MOV ECX,0x32
  100010c0  DIV ECX
  100010c2  MOV dword ptr [EBP + -0x4],0x0
  100010c9  MOV dword ptr [EBP + -0x8],EDX
  100010cc  FILD qword ptr [EBP + -0x8]
  100010cf  FMUL float ptr [0x1000d100]    ; DAT_1000d100
  100010d5  FSTP float ptr [ESI + 0x18]
  100010d8  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  100010de  MOV EDX,dword ptr [ECX]
  100010e0  CALL dword ptr [EDX + 0x8]
  100010e3  TEST AL,0x1
  100010e5  JNZ 0x100010f3    ; LAB_100010f3
  100010e7  FLD float ptr [ESI + 0x18]
  100010ea  FMUL float ptr [0x1000d0fc]    ; DAT_1000d0fc
  100010f0  FSTP float ptr [ESI + 0x18]
LAB_100010f3:
  100010f3  MOV ECX,ESI
  100010f5  CALL 0x10001100    ; FUN_10001100
  100010fa  POP ESI
  100010fb  MOV ESP,EBP
  100010fd  POP EBP
  100010fe  RET

;==== FUNCTION FUN_10001100 @ 10001100 : undefined FUN_10001100(int * param_1)
  10001100  PUSH EBX
  10001101  PUSH ESI
  10001102  MOV ESI,ECX
  10001104  PUSH EDI
  10001105  FLD float ptr [ESI + 0x14]
  10001108  FCOMP float ptr [0x1000d104]    ; DAT_1000d104
  1000110e  FNSTSW AX
  10001110  TEST AH,0x1
  10001113  JZ 0x1000111c    ; LAB_1000111c
  10001115  MOV EAX,0x1
  1000111a  JMP 0x1000111e    ; LAB_1000111e
LAB_1000111c:
  1000111c  XOR EAX,EAX
LAB_1000111e:
  1000111e  MOV byte ptr [ESI + 0x24],AL
  10001121  MOV EAX,dword ptr [ESI + 0x8]
  10001124  TEST EAX,EAX
  10001126  JZ 0x1000113c    ; LAB_1000113c
  10001128  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  1000112e  PUSH EAX
  1000112f  MOV EDX,dword ptr [ECX]
  10001131  CALL dword ptr [EDX + 0x1c]
  10001134  MOV ECX,dword ptr [ESI + 0x8]
  10001137  MOV EAX,dword ptr [ECX]
  10001139  CALL dword ptr [EAX + 0x4]
LAB_1000113c:
  1000113c  MOV EAX,dword ptr [ESI]
  1000113e  MOV EDI,dword ptr [0x1000f5cc]    ; DAT_1000f5cc
  10001144  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  1000114a  XOR EBX,EBX
  1000114c  MOV BL,byte ptr [ESI + 0x24]
  1000114f  MOV EDX,dword ptr [ECX]
  10001151  LEA EAX,[EBX + EAX*0x2]
  10001154  MOV EAX,dword ptr [EDI + EAX*0x4]
  10001157  PUSH EAX
  10001158  CALL dword ptr [EDX + 0x14]
  1000115b  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10001161  MOV EDI,EAX
  10001163  PUSH 0x0
  10001165  PUSH EDI
  10001166  MOV EDX,dword ptr [ECX]
  10001168  CALL dword ptr [EDX + 0x8]
  1000116b  MOV dword ptr [ESI + 0x8],EAX
  1000116e  MOV EAX,dword ptr [EDI]
  10001170  MOV ECX,EDI
  10001172  CALL dword ptr [EAX + 0x4]
  10001175  MOV ECX,dword ptr [ESI + 0x8]
  10001178  MOV EDX,dword ptr [ECX]
  1000117a  CALL dword ptr [EDX + 0x2c]
  1000117d  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  10001183  MOV EDX,dword ptr [ESI + 0x8]
  10001186  PUSH EDX
  10001187  MOV EAX,dword ptr [ECX]
  10001189  CALL dword ptr [EAX + 0x18]
  1000118c  MOV ECX,dword ptr [ESI + 0x8]
  1000118f  LEA EDX,[ESI + 0x20]
  10001192  ADD ESI,0x1c
  10001195  PUSH EDX
  10001196  MOV EAX,dword ptr [ECX]
  10001198  PUSH ESI
  10001199  CALL dword ptr [EAX + 0x48]
  1000119c  POP EDI
  1000119d  POP ESI
  1000119e  POP EBX
  1000119f  RET

;==== FUNCTION FUN_100011a0 @ 100011a0 : int * FUN_100011a0(void * this, int param_1)
  100011a0  PUSH EBP
  100011a1  MOV EBP,ESP
  100011a3  SUB ESP,0x18
  100011a6  MOV EAX,dword ptr [EBP + 0x8]
  100011a9  PUSH EBX
  100011aa  PUSH ESI
  100011ab  MOV ESI,ECX
  100011ad  XOR EBX,EBX
  100011af  PUSH EDI
  100011b0  MOV dword ptr [ESI],EAX
  100011b2  MOV dword ptr [ESI + 0x8],EBX
  100011b5  MOV byte ptr [ESI + 0x25],BL
  100011b8  MOV dword ptr [ESI + 0x34],EBX
  100011bb  CALL 0x10001060    ; FUN_10001060
  100011c0  CMP byte ptr [0x1000f605],BL    ; DAT_1000f605
  100011c6  JZ 0x10001213    ; LAB_10001213
  100011c8  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  100011ce  MOV EDX,dword ptr [ECX]
  100011d0  CALL dword ptr [EDX + 0x8]
  100011d3  XOR EDX,EDX
  100011d5  MOV ECX,0x12c
  100011da  DIV ECX
  100011dc  MOV dword ptr [EBP + -0x4],EBX
  100011df  ADD EDX,0x64
  100011e2  MOV dword ptr [EBP + -0x8],EDX
  100011e5  FILD qword ptr [EBP + -0x8]
  100011e8  FSTP float ptr [ESI + 0xc]
  100011eb  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  100011f1  MOV EDX,dword ptr [ECX]
  100011f3  CALL dword ptr [EDX + 0x8]
  100011f6  XOR EDX,EDX
  100011f8  MOV ECX,0xc8
  100011fd  DIV ECX
  100011ff  MOV dword ptr [EBP + -0x4],EBX
  10001202  ADD EDX,0x64
  10001205  MOV dword ptr [EBP + -0x8],EDX
  10001208  FILD qword ptr [EBP + -0x8]
  1000120b  FSTP float ptr [ESI + 0x10]
  1000120e  JMP 0x100012af    ; LAB_100012af
LAB_10001213:
  10001213  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  10001219  MOV EDX,dword ptr [ECX]
  1000121b  CALL dword ptr [EDX + 0x8]
  1000121e  MOV EDX,dword ptr [ESI + 0x1c]
  10001221  MOV ECX,0xbe
  10001226  SUB ECX,EDX
  10001228  XOR EDX,EDX
  1000122a  DIV ECX
  1000122c  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  10001232  MOV dword ptr [EBP + -0xc],EBX
  10001235  MOV dword ptr [EBP + -0x10],EDX
  10001238  MOV EDX,dword ptr [ECX]
  1000123a  FILD qword ptr [EBP + -0x10]
  1000123d  FSTP float ptr [EBP + 0x8]
  10001240  CALL dword ptr [EDX + 0x8]
  10001243  XOR EDX,EDX
  10001245  MOV ECX,0x3e8
  1000124a  DIV ECX
  1000124c  MOV dword ptr [EBP + -0x14],EBX
  1000124f  MOV dword ptr [EBP + -0x18],EDX
  10001252  FILD qword ptr [EBP + -0x18]
  10001255  FMUL float ptr [0x1000d118]    ; DAT_1000d118
  1000125b  FLD ST0
  1000125d  FSIN
  1000125f  FMUL float ptr [EBP + 0x8]
  10001262  FADD float ptr [0x1000d114]    ; DAT_1000d114
  10001268  FST float ptr [EBP + -0x4]
  1000126b  FSTP float ptr [ESI + 0xc]
  1000126e  FCOS
  10001270  FMUL float ptr [EBP + 0x8]
  10001273  FADD float ptr [0x1000d110]    ; DAT_1000d110
  10001279  FST float ptr [ESI + 0x10]
  1000127c  MOV EDX,dword ptr [0x1000f5e4]    ; DAT_1000f5e4
  10001282  MOV EAX,dword ptr [EDX + 0xc]
  10001285  FSUB float ptr [EAX + 0x14]
  10001288  FLD float ptr [EBP + -0x4]
  1000128b  FSUB float ptr [EAX + 0x10]
  1000128e  FLD ST0
  10001290  FMUL ST1
  10001292  FLD ST2
  10001294  FMUL ST3
  10001296  FADDP
  10001298  FSQRT
  1000129a  FCOMP double ptr [0x1000d108]    ; DAT_1000d108
  100012a0  FNSTSW AX
  100012a2  FSTP ST0
  100012a4  TEST AH,0x41
  100012a7  FSTP ST0
  100012a9  JNZ 0x10001213    ; LAB_10001213
LAB_100012af:
  100012af  MOV EDI,dword ptr [ESI + 0x8]
  100012b2  PUSH EBX
  100012b3  FLD float ptr [ESI + 0x10]
  100012b6  MOV EDX,dword ptr [EDI]
  100012b8  MOV dword ptr [EBP + 0x8],EDX
  100012bb  CALL 0x10005110    ; __ftol
  100012c0  FLD float ptr [ESI + 0xc]
  100012c3  PUSH EAX
  100012c4  CALL 0x10005110    ; __ftol
  100012c9  PUSH EAX
  100012ca  MOV EAX,dword ptr [EBP + 0x8]
  100012cd  MOV ECX,EDI
  100012cf  CALL dword ptr [EAX + 0x8]
  100012d2  MOV ECX,dword ptr [ESI + 0x8]
  100012d5  PUSH 0x0
  100012d7  PUSH 0x0
  100012d9  MOV EDX,dword ptr [ECX]
  100012db  CALL dword ptr [EDX + 0x10]
  100012de  MOV EDX,dword ptr [0x1000f5cc]    ; DAT_1000f5cc
  100012e4  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  100012ea  MOV EDX,dword ptr [EDX + 0xa8]
  100012f0  MOV EAX,dword ptr [ECX]
  100012f2  PUSH EDX
  100012f3  CALL dword ptr [EAX + 0x14]
  100012f6  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  100012fc  MOV EDI,EAX
  100012fe  PUSH 0x0
  10001300  PUSH EDI
  10001301  MOV EAX,dword ptr [ECX]
  10001303  CALL dword ptr [EAX + 0x8]
  10001306  MOV dword ptr [ESI + 0x4],EAX
  10001309  MOV EDX,dword ptr [EDI]
  1000130b  MOV ECX,EDI
  1000130d  CALL dword ptr [EDX + 0x4]
  10001310  MOV EAX,[0x1000f5e0]    ; DAT_1000f5e0
  10001315  MOV dword ptr [ESI + 0x28],EAX
  10001318  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  1000131e  MOV EDX,dword ptr [ECX]
  10001320  CALL dword ptr [EDX + 0x8]
  10001323  XOR EDX,EDX
  10001325  MOV ECX,0xfa0
  1000132a  DIV ECX
  1000132c  MOV byte ptr [ESI + 0x30],0x1
  10001330  MOV EAX,ESI
  10001332  POP EDI
  10001333  MOV dword ptr [ESI + 0x2c],EDX
  10001336  POP ESI
  10001337  POP EBX
  10001338  MOV ESP,EBP
  1000133a  POP EBP
  1000133b  RET 0x4

;==== FUNCTION FUN_10001340 @ 10001340 : undefined FUN_10001340(int param_1)
  10001340  PUSH ESI
  10001341  MOV ESI,ECX
  10001343  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  10001349  MOV EDX,dword ptr [ESI + 0x8]
  1000134c  MOV EAX,dword ptr [ECX]
  1000134e  PUSH EDX
  1000134f  CALL dword ptr [EAX + 0x1c]
  10001352  MOV ECX,dword ptr [ESI + 0x8]
  10001355  MOV EAX,dword ptr [ECX]
  10001357  CALL dword ptr [EAX + 0x4]
  1000135a  MOV EAX,dword ptr [ESI + 0x4]
  1000135d  TEST EAX,EAX
  1000135f  JZ 0x1000137c    ; LAB_1000137c
  10001361  MOV CL,byte ptr [ESI + 0x25]
  10001364  TEST CL,CL
  10001366  JZ 0x10001374    ; LAB_10001374
  10001368  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  1000136e  PUSH EAX
  1000136f  MOV EDX,dword ptr [ECX]
  10001371  CALL dword ptr [EDX + 0x1c]
LAB_10001374:
  10001374  MOV ECX,dword ptr [ESI + 0x4]
  10001377  MOV EAX,dword ptr [ECX]
  10001379  CALL dword ptr [EAX + 0x4]
LAB_1000137c:
  1000137c  POP ESI
  1000137d  RET

;==== FUNCTION FUN_10001380 @ 10001380 : undefined FUN_10001380(void * this, int param_1)
  10001380  PUSH EBP
  10001381  MOV EBP,ESP
  10001383  SUB ESP,0x18
  10001386  PUSH ESI
  10001387  MOV ESI,ECX
  10001389  MOV ECX,dword ptr [EBP + 0x8]
  1000138c  PUSH EDI
  1000138d  MOV AL,byte ptr [ESI + 0x30]
  10001390  TEST AL,AL
  10001392  JZ 0x10001439    ; LAB_10001439
  10001398  MOV EDI,dword ptr [ESI + 0x28]
  1000139b  MOV EDX,dword ptr [ESI + 0x2c]
  1000139e  MOV EAX,ECX
  100013a0  SUB EAX,EDI
  100013a2  CMP EAX,EDX
  100013a4  JBE 0x10001439    ; LAB_10001439
  100013aa  MOV EAX,dword ptr [ESI + 0x4]
  100013ad  MOV byte ptr [ESI + 0x25],0x1
  100013b1  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  100013b7  PUSH EAX
  100013b8  MOV EDX,dword ptr [ECX]
  100013ba  CALL dword ptr [EDX + 0x18]
  100013bd  MOV ECX,dword ptr [ESI + 0x4]
  100013c0  MOV EDX,dword ptr [ECX]
  100013c2  CALL dword ptr [EDX + 0x2c]
  100013c5  MOV EDI,dword ptr [ESI + 0x4]
  100013c8  PUSH 0x0
  100013ca  FLD float ptr [ESI + 0x10]
  100013cd  MOV EDX,dword ptr [EDI]
  100013cf  MOV dword ptr [EBP + 0x8],EDX
  100013d2  CALL 0x10005110    ; __ftol
  100013d7  FLD float ptr [ESI + 0xc]
  100013da  SUB EAX,0xa
  100013dd  PUSH EAX
  100013de  CALL 0x10005110    ; __ftol
  100013e3  SUB EAX,0xa
  100013e6  MOV ECX,EDI
  100013e8  PUSH EAX
  100013e9  MOV EAX,dword ptr [EBP + 0x8]
  100013ec  CALL dword ptr [EAX + 0x8]
  100013ef  MOV byte ptr [ESI + 0x30],0x0
  100013f3  MOV EAX,[0x1000f5e4]    ; DAT_1000f5e4
  100013f8  TEST EAX,EAX
  100013fa  JZ 0x1000141f    ; LAB_1000141f
  100013fc  MOV ECX,dword ptr [EAX + 0xc]
  100013ff  MOV EDX,dword ptr [ESI]
  10001401  CMP EDX,dword ptr [ECX]
  10001403  JLE 0x1000141f    ; LAB_1000141f
  10001405  MOV EAX,[0x1000f5cc]    ; DAT_1000f5cc
  1000140a  PUSH 0x0
  1000140c  MOV ECX,dword ptr [EAX + 0xe8]
  10001412  MOV EDX,dword ptr [ECX]
  10001414  CALL dword ptr [EDX + 0x8]
  10001417  POP EDI
  10001418  POP ESI
  10001419  MOV ESP,EBP
  1000141b  POP EBP
  1000141c  RET 0x4
LAB_1000141f:
  1000141f  MOV EAX,[0x1000f5cc]    ; DAT_1000f5cc
  10001424  PUSH 0x0
  10001426  MOV ECX,dword ptr [EAX + 0xe4]
  1000142c  MOV EDX,dword ptr [ECX]
  1000142e  CALL dword ptr [EDX + 0x8]
  10001431  POP EDI
  10001432  POP ESI
  10001433  MOV ESP,EBP
  10001435  POP EBP
  10001436  RET 0x4
LAB_10001439:
  10001439  MOV EAX,dword ptr [ESI + 0x4]
  1000143c  TEST EAX,EAX
  1000143e  JZ 0x10001481    ; LAB_10001481
  10001440  MOV EDX,dword ptr [ESI + 0x28]
  10001443  SUB ECX,EDX
  10001445  MOV EDX,dword ptr [ESI + 0x2c]
  10001448  ADD EDX,0x258
  1000144e  CMP ECX,EDX
  10001450  JBE 0x1000168f    ; LAB_1000168f
  10001456  MOV byte ptr [ESI + 0x25],0x0
  1000145a  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  10001460  PUSH EAX
  10001461  MOV EDX,dword ptr [ECX]
  10001463  CALL dword ptr [EDX + 0x1c]
  10001466  MOV ECX,dword ptr [ESI + 0x4]
  10001469  MOV EAX,dword ptr [ECX]
  1000146b  CALL dword ptr [EAX + 0x4]
  1000146e  MOV ECX,dword ptr [ESI + 0x8]
  10001471  MOV dword ptr [ESI + 0x4],0x0
  10001478  PUSH 0x0
  1000147a  PUSH 0x1
  1000147c  MOV EDX,dword ptr [ECX]
  1000147e  CALL dword ptr [EDX + 0x10]
LAB_10001481:
  10001481  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  10001487  MOV EAX,dword ptr [ECX]
  10001489  CALL dword ptr [EAX + 0x8]
  1000148c  XOR EDX,EDX
  1000148e  MOV ECX,0x64
  10001493  DIV ECX
  10001495  TEST EDX,EDX
  10001497  JNZ 0x100014a5    ; LAB_100014a5
  10001499  MOV ECX,ESI
  1000149b  CALL 0x10001060    ; FUN_10001060
  100014a0  JMP 0x1000166b    ; LAB_1000166b
LAB_100014a5:
  100014a5  MOV EAX,dword ptr [ESI + 0x34]
  100014a8  TEST EAX,EAX
  100014aa  JNZ 0x100014b5    ; LAB_100014b5
  100014ac  MOV EDX,dword ptr [0x1000f5e0]    ; DAT_1000f5e0
  100014b2  MOV dword ptr [ESI + 0x34],EDX
LAB_100014b5:
  100014b5  MOV EAX,[0x1000f5e0]    ; DAT_1000f5e0
  100014ba  MOV ECX,dword ptr [ESI + 0x34]
  100014bd  SUB EAX,ECX
  100014bf  MOV dword ptr [EBP + -0x14],0x0
  100014c6  MOV dword ptr [EBP + -0x18],EAX
  100014c9  MOV EAX,dword ptr [ESI + 0x1c]
  100014cc  FILD qword ptr [EBP + -0x18]
  100014cf  MOV dword ptr [EBP + -0x4],EAX
  100014d2  CDQ
  100014d3  FLD ST0
  100014d5  FMUL float ptr [ESI + 0x14]
  100014d8  SUB EAX,EDX
  100014da  SAR EAX,0x1
  100014dc  FMUL float ptr [0x1000d138]    ; DAT_1000d138
  100014e2  MOV dword ptr [EBP + 0x8],EAX
  100014e5  MOV EAX,dword ptr [ESI + 0x20]
  100014e8  CDQ
  100014e9  FSTP float ptr [EBP + -0x10]
  100014ec  SUB EAX,EDX
  100014ee  FMUL float ptr [ESI + 0x18]
  100014f1  SAR EAX,0x1
  100014f3  MOV dword ptr [EBP + -0xc],EAX
  100014f6  MOV AL,[0x1000f605]    ; DAT_1000f605
  100014fb  FMUL float ptr [0x1000d138]    ; DAT_1000d138
  10001501  TEST AL,AL
  10001503  FSTP float ptr [EBP + -0x14]
  10001506  FILD dword ptr [EBP + 0x8]
  10001509  FLD float ptr [ESI + 0xc]
  1000150c  FSUB float ptr [0x1000d134]    ; DAT_1000d134
  10001512  FADDP
  10001514  FADD float ptr [EBP + -0x10]
  10001517  FSTP float ptr [EBP + 0x8]
  1000151a  FILD dword ptr [EBP + -0xc]
  1000151d  FLD float ptr [ESI + 0x10]
  10001520  FSUB float ptr [0x1000d130]    ; DAT_1000d130
  10001526  FADDP
  10001528  FADD float ptr [EBP + -0x14]
  1000152b  FST float ptr [EBP + -0x8]
  1000152e  FMUL float ptr [EBP + -0x8]
  10001531  FLD float ptr [EBP + 0x8]
  10001534  FMUL float ptr [EBP + 0x8]
  10001537  FADDP
  10001539  FSTP float ptr [EBP + -0xc]
  1000153c  FILD dword ptr [EBP + -0x4]
  1000153f  FMUL float ptr [0x1000d12c]    ; DAT_1000d12c
  10001545  FSUBR float ptr [0x1000d128]    ; DAT_1000d128
  1000154b  FLD ST0
  1000154d  FMUL ST1
  1000154f  FSTP float ptr [EBP + -0x4]
  10001552  FSTP ST0
  10001554  JZ 0x100015c5    ; LAB_100015c5
  10001556  FLD float ptr [ESI + 0xc]
  10001559  FCOMP float ptr [0x1000d124]    ; DAT_1000d124
  1000155f  FNSTSW AX
  10001561  TEST AH,0x1
  10001564  JNZ 0x10001586    ; LAB_10001586
  10001566  FLD float ptr [ESI + 0xc]
  10001569  FCOMP float ptr [0x1000d120]    ; DAT_1000d120
  1000156f  FNSTSW AX
  10001571  TEST AH,0x41
  10001574  JZ 0x10001586    ; LAB_10001586
  10001576  FLD float ptr [ESI + 0x14]
  10001579  FCOMP float ptr [0x1000d104]    ; DAT_1000d104
  1000157f  FNSTSW AX
  10001581  TEST AH,0x41
  10001584  JZ 0x100015b6    ; LAB_100015b6
LAB_10001586:
  10001586  FLD float ptr [ESI + 0xc]
  10001589  FCOMP float ptr [0x1000d120]    ; DAT_1000d120
  1000158f  FNSTSW AX
  10001591  TEST AH,0x41
  10001594  JNZ 0x100015c5    ; LAB_100015c5
  10001596  FLD float ptr [ESI + 0xc]
  10001599  FCOMP float ptr [0x1000d11c]    ; DAT_1000d11c
  1000159f  FNSTSW AX
  100015a1  TEST AH,0x41
  100015a4  JZ 0x100015c5    ; LAB_100015c5
  100015a6  FLD float ptr [ESI + 0x14]
  100015a9  FCOMP float ptr [0x1000d104]    ; DAT_1000d104
  100015af  FNSTSW AX
  100015b1  TEST AH,0x1
  100015b4  JZ 0x100015c5    ; LAB_100015c5
LAB_100015b6:
  100015b6  FLD float ptr [ESI + 0x14]
  100015b9  FCHS
  100015bb  FSTP float ptr [ESI + 0x14]
  100015be  MOV ECX,ESI
  100015c0  CALL 0x10001100    ; FUN_10001100
LAB_100015c5:
  100015c5  FLD float ptr [EBP + -0xc]
  100015c8  FCOMP float ptr [EBP + -0x4]
  100015cb  FNSTSW AX
  100015cd  TEST AH,0x1
  100015d0  JNZ 0x1000162c    ; LAB_1000162c
  100015d2  FLD float ptr [EBP + -0x4]
  100015d5  FMUL float ptr [EBP + 0x8]
  100015d8  MOV EAX,dword ptr [ESI + 0x1c]
  100015db  CDQ
  100015dc  FDIV float ptr [EBP + -0xc]
  100015df  SUB EAX,EDX
  100015e1  SAR EAX,0x1
  100015e3  MOV dword ptr [EBP + 0x8],EAX
  100015e6  MOV EAX,dword ptr [ESI + 0x20]
  100015e9  CDQ
  100015ea  SUB EAX,EDX
  100015ec  SAR EAX,0x1
  100015ee  FADD float ptr [0x1000d134]    ; DAT_1000d134
  100015f4  FISUB dword ptr [EBP + 0x8]
  100015f7  MOV dword ptr [EBP + 0x8],EAX
  100015fa  FSTP float ptr [ESI + 0xc]
  100015fd  FLD float ptr [EBP + -0x4]
  10001600  FMUL float ptr [EBP + -0x8]
  10001603  FDIV float ptr [EBP + -0xc]
  10001606  FADD float ptr [0x1000d130]    ; DAT_1000d130
  1000160c  FISUB dword ptr [EBP + 0x8]
  1000160f  FSTP float ptr [ESI + 0x10]
  10001612  FLD float ptr [ESI + 0x14]
  10001615  FMUL float ptr [0x1000d0fc]    ; DAT_1000d0fc
  1000161b  FSTP float ptr [ESI + 0x14]
  1000161e  FLD float ptr [ESI + 0x18]
  10001621  FMUL float ptr [0x1000d0fc]    ; DAT_1000d0fc
  10001627  FSTP float ptr [ESI + 0x18]
  1000162a  JMP 0x1000163e    ; LAB_1000163e
LAB_1000162c:
  1000162c  FLD float ptr [EBP + -0x10]
  1000162f  FADD float ptr [ESI + 0xc]
  10001632  FSTP float ptr [ESI + 0xc]
  10001635  FLD float ptr [EBP + -0x14]
  10001638  FADD float ptr [ESI + 0x10]
  1000163b  FSTP float ptr [ESI + 0x10]
LAB_1000163e:
  1000163e  MOV EDI,dword ptr [ESI + 0x8]
  10001641  PUSH 0x0
  10001643  FLD float ptr [ESI + 0x10]
  10001646  MOV EDX,dword ptr [EDI]
  10001648  MOV dword ptr [EBP + 0x8],EDX
  1000164b  CALL 0x10005110    ; __ftol
  10001650  FLD float ptr [ESI + 0xc]
  10001653  PUSH EAX
  10001654  CALL 0x10005110    ; __ftol
  10001659  PUSH EAX
  1000165a  MOV EAX,dword ptr [EBP + 0x8]
  1000165d  MOV ECX,EDI
  1000165f  CALL dword ptr [EAX + 0x8]
  10001662  MOV ECX,dword ptr [0x1000f5e0]    ; DAT_1000f5e0
  10001668  MOV dword ptr [ESI + 0x34],ECX
LAB_1000166b:
  1000166b  MOV EDI,dword ptr [ESI + 0x8]
  1000166e  PUSH 0x0
  10001670  FLD float ptr [ESI + 0x10]
  10001673  MOV EDX,dword ptr [EDI]
  10001675  MOV dword ptr [EBP + 0x8],EDX
  10001678  CALL 0x10005110    ; __ftol
  1000167d  FLD float ptr [ESI + 0xc]
  10001680  PUSH EAX
  10001681  CALL 0x10005110    ; __ftol
  10001686  MOV EDX,dword ptr [EBP + 0x8]
  10001689  PUSH EAX
  1000168a  MOV ECX,EDI
  1000168c  CALL dword ptr [EDX + 0x8]
LAB_1000168f:
  1000168f  POP EDI
  10001690  POP ESI
  10001691  MOV ESP,EBP
  10001693  POP EBP
  10001694  RET 0x4

;==== FUNCTION FUN_100016a0 @ 100016a0 : void * FUN_100016a0(void * this, int * param_1)
  100016a0  PUSH EBP
  100016a1  MOV EBP,ESP
  100016a3  PUSH -0x1
  100016a5  PUSH 0x1000c55b    ; LAB_1000c55b
  100016aa  MOV EAX,FS:[0x0]    ; ExceptionList
  100016b0  PUSH EAX
  100016b1  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  100016b8  SUB ESP,0x104
  100016be  PUSH EBX
  100016bf  PUSH ESI
  100016c0  PUSH EDI
  100016c1  MOV EDI,dword ptr [EBP + 0x8]
  100016c4  MOV ESI,ECX
  100016c6  MOV dword ptr [0x1000f5b4],EDI    ; DAT_1000f5b4
  100016cc  MOV dword ptr [0x1000f5cc],ESI    ; DAT_1000f5cc
  100016d2  MOV ECX,dword ptr [EDI + 0x8]
  100016d5  MOV dword ptr [0x1000f5bc],ECX    ; DAT_1000f5bc
  100016db  PUSH 0x1000f5b8    ; DAT_1000f5b8
  100016e0  MOV EAX,dword ptr [ECX]
  100016e2  CALL dword ptr [EAX + 0x44]
  100016e5  MOV ECX,dword ptr [EDI + 0xc]
  100016e8  PUSH 0x10001f40    ; FUN_10001f40
  100016ed  MOV dword ptr [0x1000f5c0],ECX    ; DAT_1000f5c0
  100016f3  MOV EDX,dword ptr [EDI + 0x14]
  100016f6  MOV dword ptr [0x1000f5c8],EDX    ; DAT_1000f5c8
  100016fc  MOV EAX,dword ptr [EDI + 0x18]
  100016ff  MOV [0x1000f5c4],EAX    ; DAT_1000f5c4
  10001704  MOV ECX,dword ptr [EDI + 0x10]
  10001707  MOV dword ptr [0x1000f5b0],ECX    ; DAT_1000f5b0
  1000170d  MOV EAX,dword ptr [EDI + 0x14]
  10001710  MOV EDX,dword ptr [ECX]
  10001712  PUSH ESI
  10001713  PUSH 0x10
  10001715  PUSH EAX
  10001716  CALL dword ptr [EDX + 0x44]
  10001719  MOV dword ptr [ESI + 0x4],EAX
  1000171c  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  10001722  PUSH 0x33
  10001724  MOV ECX,dword ptr [ECX + 0x14]
  10001727  MOV EDX,dword ptr [ECX]
  10001729  CALL dword ptr [EDX + 0x10]
  1000172c  LEA EAX,[EBP + -0x48]
  1000172f  LEA ECX,[ESI + 0xc]
  10001732  MOV dword ptr [EBP + -0x48],0xb
  10001739  MOV dword ptr [EBP + -0x44],0xf
  10001740  MOV dword ptr [EBP + -0x40],0x13
  10001747  MOV dword ptr [EBP + -0x3c],0x17
  1000174e  MOV dword ptr [EBP + -0x38],0x1b
  10001755  MOV dword ptr [EBP + -0x34],0x1f
  1000175c  MOV dword ptr [EBP + -0x30],0x23
  10001763  MOV dword ptr [EBP + -0x2c],0x27
  1000176a  MOV dword ptr [EBP + -0x28],0x2b
  10001771  MOV dword ptr [EBP + -0x24],0x2f
  10001778  MOV dword ptr [EBP + -0x14],EAX
  1000177b  MOV dword ptr [EBP + -0x18],ECX
  1000177e  MOV dword ptr [EBP + -0x1c],0xa
LAB_10001785:
  10001785  MOV EDX,dword ptr [EBP + -0x14]
  10001788  LEA EAX,[EBP + 0xffffff54]
  1000178e  MOV EDI,dword ptr [EDX]
  10001790  PUSH EDI
  10001791  PUSH EDI
  10001792  PUSH 0x1000e21c    ; s_ani-baddie_right-%dx%d.gif_1000e21c
  10001797  PUSH EAX
  10001798  CALL 0x100051b0    ; FUN_100051b0
  1000179d  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  100017a3  ADD ESP,0x10
  100017a6  LEA EAX,[EBP + 0xffffff54]
  100017ac  MOV EDX,dword ptr [ECX]
  100017ae  PUSH 0x0
  100017b0  PUSH EAX
  100017b1  CALL dword ptr [EDX + 0xc]
  100017b4  MOV EBX,EAX
  100017b6  LEA EAX,[EBP + 0x8]
  100017b9  PUSH EAX
  100017ba  MOV ECX,EBX
  100017bc  MOV EDX,dword ptr [EBX]
  100017be  CALL dword ptr [EDX + 0x3c]
  100017c1  MOV ECX,dword ptr [EBP + 0x8]
  100017c4  MOV EAX,dword ptr [EBP + -0x18]
  100017c7  ADD EAX,-0x4
  100017ca  MOV EDX,dword ptr [ECX]
  100017cc  PUSH EAX
  100017cd  CALL dword ptr [EDX + 0x10]
  100017d0  MOV ECX,dword ptr [EBP + 0x8]
  100017d3  MOV EDX,dword ptr [ECX]
  100017d5  CALL dword ptr [EDX + 0x4]
  100017d8  MOV EAX,dword ptr [EBX]
  100017da  MOV ECX,EBX
  100017dc  CALL dword ptr [EAX + 0x4]
  100017df  PUSH EDI
  100017e0  PUSH EDI
  100017e1  LEA ECX,[EBP + 0xffffff54]
  100017e7  PUSH 0x1000e200    ; s_ani-baddie_left-%dx%d.gif_1000e200
  100017ec  PUSH ECX
  100017ed  CALL 0x100051b0    ; FUN_100051b0
  100017f2  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  100017f8  ADD ESP,0x10
  100017fb  LEA EAX,[EBP + 0xffffff54]
  10001801  MOV EDX,dword ptr [ECX]
  10001803  PUSH 0x0
  10001805  PUSH EAX
  10001806  CALL dword ptr [EDX + 0xc]
  10001809  MOV EDI,EAX
  1000180b  LEA EAX,[EBP + 0x8]
  1000180e  PUSH EAX
  1000180f  MOV ECX,EDI
  10001811  MOV EDX,dword ptr [EDI]
  10001813  CALL dword ptr [EDX + 0x3c]
  10001816  MOV ECX,dword ptr [EBP + 0x8]
  10001819  MOV EBX,dword ptr [EBP + -0x18]
  1000181c  PUSH EBX
  1000181d  MOV EDX,dword ptr [ECX]
  1000181f  CALL dword ptr [EDX + 0x10]
  10001822  MOV ECX,dword ptr [EBP + 0x8]
  10001825  MOV EAX,dword ptr [ECX]
  10001827  CALL dword ptr [EAX + 0x4]
  1000182a  MOV EDX,dword ptr [EDI]
  1000182c  MOV ECX,EDI
  1000182e  CALL dword ptr [EDX + 0x4]
  10001831  MOV EDX,dword ptr [EBP + -0x14]
  10001834  MOV EAX,dword ptr [EBP + -0x1c]
  10001837  ADD EDX,0x4
  1000183a  ADD EBX,0x8
  1000183d  DEC EAX
  1000183e  MOV dword ptr [EBP + -0x14],EDX
  10001841  MOV dword ptr [EBP + -0x18],EBX
  10001844  MOV dword ptr [EBP + -0x1c],EAX
  10001847  JNZ 0x10001785    ; LAB_10001785
  1000184d  XOR EDI,EDI
LAB_1000184f:
  1000184f  MOV EAX,dword ptr [EBP + EDI*0x4 + -0x48]
  10001853  PUSH EAX
  10001854  PUSH EAX
  10001855  LEA EAX,[EBP + 0xfffffef0]
  1000185b  PUSH 0x1000e1e4    ; s_ani-meboid_right-%dx%d.gif_1000e1e4
  10001860  PUSH EAX
  10001861  CALL 0x100051b0    ; FUN_100051b0
  10001866  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  1000186c  ADD ESP,0x10
  1000186f  LEA EAX,[EBP + 0xfffffef0]
  10001875  MOV EDX,dword ptr [ECX]
  10001877  PUSH 0x0
  10001879  PUSH EAX
  1000187a  CALL dword ptr [EDX + 0xc]
  1000187d  MOV EBX,EAX
  1000187f  LEA EAX,[ESI + EDI*0x4 + 0x80]
  10001886  PUSH EAX
  10001887  MOV ECX,EBX
  10001889  MOV EDX,dword ptr [EBX]
  1000188b  CALL dword ptr [EDX + 0x3c]
  1000188e  CMP EDI,0x2
  10001891  JNZ 0x100018a1    ; LAB_100018a1
  10001893  MOV EDX,dword ptr [EBX]
  10001895  LEA EAX,[ESI + 0xb8]
  1000189b  PUSH EAX
  1000189c  MOV ECX,EBX
  1000189e  CALL dword ptr [EDX + 0x44]
LAB_100018a1:
  100018a1  MOV EDX,dword ptr [EBX]
  100018a3  MOV ECX,EBX
  100018a5  CALL dword ptr [EDX + 0x4]
  100018a8  MOV EAX,dword ptr [EBP + EDI*0x4 + -0x48]
  100018ac  PUSH EAX
  100018ad  PUSH EAX
  100018ae  LEA EAX,[EBP + 0xfffffef0]
  100018b4  PUSH 0x1000e1c8    ; s_ani-meboid_left-%dx%d.gif_1000e1c8
  100018b9  PUSH EAX
  100018ba  CALL 0x100051b0    ; FUN_100051b0
  100018bf  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  100018c5  ADD ESP,0x10
  100018c8  LEA EAX,[EBP + 0xfffffef0]
  100018ce  MOV EDX,dword ptr [ECX]
  100018d0  PUSH 0x0
  100018d2  PUSH EAX
  100018d3  CALL dword ptr [EDX + 0xc]
  100018d6  MOV EBX,EAX
  100018d8  LEA EAX,[ESI + EDI*0x4 + 0x58]
  100018dc  PUSH EAX
  100018dd  MOV ECX,EBX
  100018df  MOV EDX,dword ptr [EBX]
  100018e1  CALL dword ptr [EDX + 0x3c]
  100018e4  MOV EDX,dword ptr [EBX]
  100018e6  MOV ECX,EBX
  100018e8  CALL dword ptr [EDX + 0x4]
  100018eb  INC EDI
  100018ec  CMP EDI,0xa
  100018ef  JL 0x1000184f    ; LAB_1000184f
  100018f5  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  100018fb  PUSH 0x0
  100018fd  PUSH 0x1000e1ac    ; s_img-titlescreen-500x420.gif_1000e1ac
  10001902  MOV EAX,dword ptr [ECX]
  10001904  CALL dword ptr [EAX + 0xc]
  10001907  MOV EDI,EAX
  10001909  LEA EAX,[ESI + 0xbc]
  1000190f  PUSH EAX
  10001910  MOV ECX,EDI
  10001912  MOV EDX,dword ptr [EDI]
  10001914  CALL dword ptr [EDX + 0x44]
  10001917  MOV EDX,dword ptr [EDI]
  10001919  MOV ECX,EDI
  1000191b  CALL dword ptr [EDX + 0x4]
  1000191e  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10001924  PUSH 0x0
  10001926  PUSH 0x1000e188    ; s_img-backgroundscreen-500x420.gif_1000e188
  1000192b  MOV EAX,dword ptr [ECX]
  1000192d  CALL dword ptr [EAX + 0xc]
  10001930  LEA ECX,[EBP + -0x10]
  10001933  MOV dword ptr [ESI + 0xac],EAX
  10001939  MOV EDX,dword ptr [EAX]
  1000193b  PUSH ECX
  1000193c  MOV ECX,EAX
  1000193e  CALL dword ptr [EDX + 0x3c]
  10001941  MOV ECX,dword ptr [EBP + -0x10]
  10001944  LEA EAX,[EBP + -0x20]
  10001947  PUSH EAX
  10001948  MOV EDX,dword ptr [ECX]
  1000194a  CALL dword ptr [EDX + 0x10]
  1000194d  MOV ECX,dword ptr [EBP + -0x20]
  10001950  LEA EAX,[ESI + 0xc0]
  10001956  PUSH EAX
  10001957  PUSH 0x2
  10001959  MOV EDX,dword ptr [ECX]
  1000195b  CALL dword ptr [EDX + 0x10]
  1000195e  MOV ECX,dword ptr [EBP + -0x20]
  10001961  MOV EDX,dword ptr [ECX]
  10001963  CALL dword ptr [EDX + 0x4]
  10001966  MOV ECX,dword ptr [EBP + -0x10]
  10001969  MOV EAX,dword ptr [ECX]
  1000196b  CALL dword ptr [EAX + 0x4]
  1000196e  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10001974  PUSH 0x0
  10001976  PUSH 0x1000e16c    ; s_ani-baddie-blob-39x39.gif_1000e16c
  1000197b  MOV EDX,dword ptr [ECX]
  1000197d  CALL dword ptr [EDX + 0xc]
  10001980  MOV EDI,EAX
  10001982  LEA ECX,[EBP + -0x10]
  10001985  PUSH ECX
  10001986  MOV ECX,EDI
  10001988  MOV EAX,dword ptr [EDI]
  1000198a  CALL dword ptr [EAX + 0x3c]
  1000198d  MOV ECX,dword ptr [EBP + -0x10]
  10001990  LEA EAX,[ESI + 0xa8]
  10001996  PUSH EAX
  10001997  MOV EDX,dword ptr [ECX]
  10001999  CALL dword ptr [EDX + 0x10]
  1000199c  MOV EDX,dword ptr [EDI]
  1000199e  MOV ECX,EDI
  100019a0  CALL dword ptr [EDX + 0x4]
  100019a3  MOV ECX,dword ptr [EBP + -0x10]
  100019a6  MOV EAX,dword ptr [ECX]
  100019a8  CALL dword ptr [EAX + 0x4]
  100019ab  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  100019b1  PUSH 0x0
  100019b3  PUSH 0x1000e150    ; s_ani-meboid_angel-19x19.gif_1000e150
  100019b8  MOV EDX,dword ptr [ECX]
  100019ba  CALL dword ptr [EDX + 0xc]
  100019bd  MOV EDI,EAX
  100019bf  LEA ECX,[ESI + 0xc4]
  100019c5  PUSH ECX
  100019c6  MOV ECX,EDI
  100019c8  MOV EAX,dword ptr [EDI]
  100019ca  CALL dword ptr [EAX + 0x3c]
  100019cd  MOV EDX,dword ptr [EDI]
  100019cf  MOV ECX,EDI
  100019d1  CALL dword ptr [EDX + 0x4]
  100019d4  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  100019da  PUSH 0x0
  100019dc  MOV EAX,dword ptr [ECX]
  100019de  PUSH 0x1000e128    ; s_ani-titlescreen_animation-500x79_1000e128
  100019e3  CALL dword ptr [EAX + 0xc]
  100019e6  MOV dword ptr [ESI + 0xb0],EAX
  100019ec  MOV byte ptr [ESI + 0xb4],0x0
  100019f3  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  100019f9  PUSH 0x0
  100019fb  PUSH 0x1000e114    ; s_snd-gameopen.wav_1000e114
  10001a00  MOV EDX,dword ptr [ECX]
  10001a02  CALL dword ptr [EDX + 0x40]
  10001a05  MOV dword ptr [ESI + 0xc8],EAX
  10001a0b  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10001a11  PUSH 0x0
  10001a13  PUSH 0x1000e0f8    ; s_snd-gameover-highscore.wav_1000e0f8
  10001a18  MOV EAX,dword ptr [ECX]
  10001a1a  CALL dword ptr [EAX + 0x40]
  10001a1d  MOV dword ptr [ESI + 0xd0],EAX
  10001a23  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10001a29  PUSH 0x0
  10001a2b  PUSH 0x1000e0e4    ; s_snd-gameover.wav_1000e0e4
  10001a30  MOV EDX,dword ptr [ECX]
  10001a32  CALL dword ptr [EDX + 0x40]
  10001a35  MOV dword ptr [ESI + 0xcc],EAX
  10001a3b  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10001a41  PUSH 0x0
  10001a43  PUSH 0x1000e0d0    ; s_snd-gamestart.wav_1000e0d0
  10001a48  MOV EAX,dword ptr [ECX]
  10001a4a  CALL dword ptr [EAX + 0x40]
  10001a4d  MOV dword ptr [ESI + 0xd4],EAX
  10001a53  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10001a59  PUSH 0x0
  10001a5b  PUSH 0x1000e0bc    ; s_snd-loselife.wav_1000e0bc
  10001a60  MOV EDX,dword ptr [ECX]
  10001a62  CALL dword ptr [EDX + 0x40]
  10001a65  MOV dword ptr [ESI + 0xd8],EAX
  10001a6b  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10001a71  PUSH 0x0
  10001a73  PUSH 0x1000e0a8    ; s_snd-moebeats.wav_1000e0a8
  10001a78  MOV EAX,dword ptr [ECX]
  10001a7a  CALL dword ptr [EAX + 0x40]
  10001a7d  MOV dword ptr [ESI + 0xdc],EAX
  10001a83  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10001a89  PUSH 0x0
  10001a8b  PUSH 0x1000e094    ; s_snd-moebgrowth.wav_1000e094
  10001a90  MOV EDX,dword ptr [ECX]
  10001a92  CALL dword ptr [EDX + 0x40]
  10001a95  MOV dword ptr [ESI + 0xe0],EAX
  10001a9b  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10001aa1  PUSH 0x0
  10001aa3  PUSH 0x1000e07c    ; s_snd-newbaddieGood.wav_1000e07c
  10001aa8  MOV EAX,dword ptr [ECX]
  10001aaa  CALL dword ptr [EAX + 0x40]
  10001aad  MOV dword ptr [ESI + 0xe4],EAX
  10001ab3  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10001ab9  PUSH 0x0
  10001abb  PUSH 0x1000e064    ; s_snd-newbaddieBad.wav_1000e064
  10001ac0  MOV EDX,dword ptr [ECX]
  10001ac2  CALL dword ptr [EDX + 0x40]
  10001ac5  MOV dword ptr [ESI + 0xe8],EAX
  10001acb  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10001ad1  PUSH 0x0
  10001ad3  PUSH 0x1000e054    ; s_snd-randbg.wav_1000e054
  10001ad8  MOV EAX,dword ptr [ECX]
  10001ada  CALL dword ptr [EAX + 0x40]
  10001add  MOV dword ptr [ESI + 0xec],EAX
  10001ae3  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10001ae9  PUSH 0x0
  10001aeb  PUSH 0x1000e040    ; s_snd-ExtraLife.wav_1000e040
  10001af0  MOV EDX,dword ptr [ECX]
  10001af2  CALL dword ptr [EDX + 0x40]
  10001af5  PUSH 0x20
  10001af7  MOV dword ptr [ESI + 0xf0],EAX
  10001afd  CALL 0x100051a2    ; operator_new
  10001b02  ADD ESP,0x4
  10001b05  MOV dword ptr [EBP + 0x8],EAX
  10001b08  TEST EAX,EAX
  10001b0a  MOV dword ptr [EBP + -0x4],0x0
  10001b11  JZ 0x10001b1d    ; LAB_10001b1d
  10001b13  PUSH ESI
  10001b14  MOV ECX,EAX
  10001b16  CALL 0x100041a0    ; FUN_100041a0
  10001b1b  JMP 0x10001b1f    ; LAB_10001b1f
LAB_10001b1d:
  10001b1d  XOR EAX,EAX
LAB_10001b1f:
  10001b1f  PUSH EAX
  10001b20  PUSH 0x0
  10001b22  MOV ECX,ESI
  10001b24  MOV dword ptr [EBP + -0x4],0xffffffff
  10001b2b  CALL 0x10001db0    ; FUN_10001db0
  10001b30  MOV ECX,dword ptr [EBP + -0xc]
  10001b33  MOV EAX,ESI
  10001b35  POP EDI
  10001b36  POP ESI
  10001b37  POP EBX
  10001b38  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  10001b3f  MOV ESP,EBP
  10001b41  POP EBP
  10001b42  RET 0x4

;==== FUNCTION FUN_10001b50 @ 10001b50 : undefined FUN_10001b50(int * param_1)
  10001b50  PUSH ESI
  10001b51  MOV ESI,ECX
  10001b53  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10001b59  MOV EAX,dword ptr [ECX]
  10001b5b  CALL dword ptr [EAX + 0x4]
  10001b5e  MOV ECX,dword ptr [ESI + 0x4]
  10001b61  MOV EDX,dword ptr [ECX]
  10001b63  CALL dword ptr [EDX + 0x4]
  10001b66  MOV ECX,dword ptr [ESI + 0xbc]
  10001b6c  MOV EAX,dword ptr [ECX]
  10001b6e  CALL dword ptr [EAX + 0x4]
  10001b71  MOV AL,byte ptr [ESI + 0xb4]
  10001b77  TEST AL,AL
  10001b79  JZ 0x10001b8d    ; LAB_10001b8d
  10001b7b  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  10001b81  MOV EAX,dword ptr [ESI + 0xac]
  10001b87  PUSH EAX
  10001b88  MOV EDX,dword ptr [ECX]
  10001b8a  CALL dword ptr [EDX + 0x1c]
LAB_10001b8d:
  10001b8d  MOV ECX,dword ptr [ESI + 0xc0]
  10001b93  PUSH EBX
  10001b94  PUSH EDI
  10001b95  MOV EDX,dword ptr [ECX]
  10001b97  CALL dword ptr [EDX + 0x4]
  10001b9a  LEA EDI,[ESI + 0x80]
  10001ba0  MOV EBX,0xa
LAB_10001ba5:
  10001ba5  MOV ECX,dword ptr [EDI + -0x28]
  10001ba8  MOV EAX,dword ptr [ECX]
  10001baa  CALL dword ptr [EAX + 0x4]
  10001bad  MOV ECX,dword ptr [EDI]
  10001baf  MOV EDX,dword ptr [ECX]
  10001bb1  CALL dword ptr [EDX + 0x4]
  10001bb4  ADD EDI,0x4
  10001bb7  DEC EBX
  10001bb8  JNZ 0x10001ba5    ; LAB_10001ba5
  10001bba  MOV ECX,dword ptr [ESI + 0xc8]
  10001bc0  MOV EAX,dword ptr [ECX]
  10001bc2  CALL dword ptr [EAX + 0x4]
  10001bc5  MOV ECX,dword ptr [ESI + 0xcc]
  10001bcb  MOV EDX,dword ptr [ECX]
  10001bcd  CALL dword ptr [EDX + 0x4]
  10001bd0  MOV ECX,dword ptr [ESI + 0xd0]
  10001bd6  MOV EAX,dword ptr [ECX]
  10001bd8  CALL dword ptr [EAX + 0x4]
  10001bdb  MOV ECX,dword ptr [ESI + 0xd4]
  10001be1  MOV EDX,dword ptr [ECX]
  10001be3  CALL dword ptr [EDX + 0x4]
  10001be6  MOV ECX,dword ptr [ESI + 0xd8]
  10001bec  MOV EAX,dword ptr [ECX]
  10001bee  CALL dword ptr [EAX + 0x4]
  10001bf1  MOV ECX,dword ptr [ESI + 0xdc]
  10001bf7  MOV EDX,dword ptr [ECX]
  10001bf9  CALL dword ptr [EDX + 0x4]
  10001bfc  MOV ECX,dword ptr [ESI + 0xe0]
  10001c02  MOV EAX,dword ptr [ECX]
  10001c04  CALL dword ptr [EAX + 0x4]
  10001c07  MOV ECX,dword ptr [ESI + 0xe4]
  10001c0d  MOV EDX,dword ptr [ECX]
  10001c0f  CALL dword ptr [EDX + 0x4]
  10001c12  MOV ECX,dword ptr [ESI + 0xe8]
  10001c18  MOV EAX,dword ptr [ECX]
  10001c1a  CALL dword ptr [EAX + 0x4]
  10001c1d  MOV ECX,dword ptr [ESI + 0xec]
  10001c23  MOV EDX,dword ptr [ECX]
  10001c25  CALL dword ptr [EDX + 0x4]
  10001c28  MOV ECX,dword ptr [ESI + 0xf0]
  10001c2e  MOV EAX,dword ptr [ECX]
  10001c30  CALL dword ptr [EAX + 0x4]
  10001c33  MOV ECX,dword ptr [ESI + 0xc4]
  10001c39  MOV EDX,dword ptr [ECX]
  10001c3b  CALL dword ptr [EDX + 0x4]
  10001c3e  MOV ECX,dword ptr [ESI + 0xa8]
  10001c44  MOV EAX,dword ptr [ECX]
  10001c46  CALL dword ptr [EAX + 0x4]
  10001c49  MOV ECX,dword ptr [ESI + 0xb8]
  10001c4f  MOV EDX,dword ptr [ECX]
  10001c51  CALL dword ptr [EDX + 0x4]
  10001c54  LEA EDI,[ESI + 0x8]
  10001c57  MOV EBX,0x14
LAB_10001c5c:
  10001c5c  MOV ECX,dword ptr [EDI]
  10001c5e  MOV EAX,dword ptr [ECX]
  10001c60  CALL dword ptr [EAX + 0x4]
  10001c63  ADD EDI,0x4
  10001c66  DEC EBX
  10001c67  JNZ 0x10001c5c    ; LAB_10001c5c
  10001c69  MOV ECX,dword ptr [ESI]
  10001c6b  POP EDI
  10001c6c  TEST ECX,ECX
  10001c6e  POP EBX
  10001c6f  JZ 0x10001c77    ; LAB_10001c77
  10001c71  MOV EDX,dword ptr [ECX]
  10001c73  PUSH 0x1
  10001c75  CALL dword ptr [EDX]
LAB_10001c77:
  10001c77  MOV ECX,dword ptr [ESI + 0xb0]
  10001c7d  MOV EAX,dword ptr [ECX]
  10001c7f  CALL dword ptr [EAX + 0x4]
  10001c82  POP ESI
  10001c83  RET

;==== FUNCTION FUN_10001c90 @ 10001c90 : undefined4 FUN_10001c90(void)
  10001c90  PUSH EBP
  10001c91  MOV EBP,ESP
  10001c93  MOV EAX,FS:[0x0]    ; ExceptionList
  10001c99  PUSH -0x1
  10001c9b  PUSH 0x1000c57b    ; LAB_1000c57b
  10001ca0  PUSH EAX
  10001ca1  MOV EAX,0x2718
  10001ca6  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  10001cad  CALL 0x10005600    ; FUN_10005600
  10001cb2  MOV ECX,dword ptr [0x1000f5c0]    ; DAT_1000f5c0
  10001cb8  LEA EDX,[EBP + -0x10]
  10001cbb  PUSH ESI
  10001cbc  PUSH EDX
  10001cbd  MOV EAX,dword ptr [ECX]
  10001cbf  CALL dword ptr [EAX + 0x44]
  10001cc2  PUSH 0x10
  10001cc4  CALL 0x100051a2    ; operator_new
  10001cc9  ADD ESP,0x4
  10001ccc  MOV dword ptr [EBP + -0x14],EAX
  10001ccf  TEST EAX,EAX
  10001cd1  MOV dword ptr [EBP + -0x4],0x0
  10001cd8  JZ 0x10001cea    ; LAB_10001cea
  10001cda  PUSH 0x1000e270    ; s_Help.zml_1000e270
  10001cdf  MOV ECX,EAX
  10001ce1  CALL 0x10004e90    ; FUN_10004e90
  10001ce6  MOV ESI,EAX
  10001ce8  JMP 0x10001cec    ; LAB_10001cec
LAB_10001cea:
  10001cea  XOR ESI,ESI
LAB_10001cec:
  10001cec  LEA EAX,[EBP + 0xffffd8dc]
  10001cf2  PUSH 0x2710
  10001cf7  PUSH EAX
  10001cf8  MOV ECX,ESI
  10001cfa  MOV dword ptr [EBP + -0x4],0xffffffff
  10001d01  CALL 0x10004fb0    ; FUN_10004fb0
  10001d06  CMP EAX,0x8
  10001d09  JZ 0x10001d76    ; LAB_10001d76
  10001d0b  PUSH EDI
  10001d0c  MOV ECX,ESI
  10001d0e  CALL 0x10004f60    ; FUN_10004f60
  10001d13  PUSH ESI
  10001d14  CALL 0x10005197    ; FUN_10005197
  10001d19  LEA EDI,[EBP + 0xffffd8dc]
  10001d1f  OR ECX,0xffffffff
  10001d22  XOR EAX,EAX
  10001d24  ADD ESP,0x4
  10001d27  XOR EDX,EDX
  10001d29  SCASB.REPNE ES:EDI
  10001d2b  NOT ECX
  10001d2d  DEC ECX
  10001d2e  TEST ECX,ECX
  10001d30  JLE 0x10001d5e    ; LAB_10001d5e
LAB_10001d32:
  10001d32  MOV AL,byte ptr [EBP + EDX*0x1 + 0xffffd8dc]
  10001d39  CMP AL,0xd
  10001d3b  JZ 0x10001d41    ; LAB_10001d41
  10001d3d  CMP AL,0xa
  10001d3f  JNZ 0x10001d49    ; LAB_10001d49
LAB_10001d41:
  10001d41  MOV byte ptr [EBP + EDX*0x1 + 0xffffd8dc],0x20
LAB_10001d49:
  10001d49  LEA EDI,[EBP + 0xffffd8dc]
  10001d4f  OR ECX,0xffffffff
  10001d52  XOR EAX,EAX
  10001d54  INC EDX
  10001d55  SCASB.REPNE ES:EDI
  10001d57  NOT ECX
  10001d59  DEC ECX
  10001d5a  CMP EDX,ECX
  10001d5c  JL 0x10001d32    ; LAB_10001d32
LAB_10001d5e:
  10001d5e  MOV EDX,dword ptr [EBP + -0x10]
  10001d61  PUSH 0xa
  10001d63  LEA ECX,[EBP + 0xffffd8dc]
  10001d69  PUSH 0x0
  10001d6b  PUSH ECX
  10001d6c  PUSH EDX
  10001d6d  CALL 0x10004a00    ; FUN_10004a00
  10001d72  ADD ESP,0x10
  10001d75  POP EDI
LAB_10001d76:
  10001d76  MOV EAX,dword ptr [EBP + -0x10]
  10001d79  PUSH 0x0
  10001d7b  PUSH 0x12f
  10001d80  PUSH 0x1000e238    ; s_<C999999><s4>Moeboid_is_a_tradem_1000e238
  10001d85  PUSH EAX
  10001d86  CALL 0x10004a00    ; FUN_10004a00
  10001d8b  MOV ECX,dword ptr [EBP + -0x10]
  10001d8e  ADD ESP,0x10
  10001d91  MOV EDX,dword ptr [ECX]
  10001d93  CALL dword ptr [EDX + 0x4]
  10001d96  MOV ECX,dword ptr [EBP + -0xc]
  10001d99  XOR EAX,EAX
  10001d9b  POP ESI
  10001d9c  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  10001da3  MOV ESP,EBP
  10001da5  POP EBP
  10001da6  RET 0x4

;==== FUNCTION FUN_10001db0 @ 10001db0 : undefined4 FUN_10001db0(void * this, undefined4 * param_1, undefined4 param_2)
  10001db0  PUSH EBP
  10001db1  MOV EBP,ESP
  10001db3  PUSH ESI
  10001db4  MOV ESI,ECX
  10001db6  MOV ECX,dword ptr [EBP + 0x8]
  10001db9  TEST ECX,ECX
  10001dbb  JZ 0x10001dcf    ; LAB_10001dcf
  10001dbd  MOV EAX,dword ptr [ECX]
  10001dbf  PUSH 0x1
  10001dc1  CALL dword ptr [EAX]
  10001dc3  MOV ECX,dword ptr [EBP + 0xc]
  10001dc6  XOR EAX,EAX
  10001dc8  MOV dword ptr [ESI],ECX
  10001dca  POP ESI
  10001dcb  POP EBP
  10001dcc  RET 0x8
LAB_10001dcf:
  10001dcf  MOV EDX,dword ptr [EBP + 0xc]
  10001dd2  XOR EAX,EAX
  10001dd4  MOV dword ptr [ESI],EDX
  10001dd6  POP ESI
  10001dd7  POP EBP
  10001dd8  RET 0x8

;==== FUNCTION FUN_10001de0 @ 10001de0 : undefined4 FUN_10001de0(undefined4 param_1, byte * param_2, undefined4 param_3, undefined4 param_4, int param_5, undefined4 param_6, undefined4 param_7, undefined4 param_8)
  10001de0  PUSH EBP
  10001de1  MOV EBP,ESP
  10001de3  SUB ESP,0x8
  10001de6  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10001dec  MOV EDX,dword ptr [EBP + 0x1c]
  10001def  PUSH EBX
  10001df0  PUSH ESI
  10001df1  MOV EAX,dword ptr [ECX]
  10001df3  PUSH EDI
  10001df4  PUSH 0x1
  10001df6  PUSH EDX
  10001df7  PUSH 0x1000e290    ; s_Arial_1000e290
  10001dfc  CALL dword ptr [EAX + 0x28]
  10001dff  MOV EDI,dword ptr [EBP + 0xc]
  10001e02  MOV EBX,EAX
  10001e04  LEA EAX,[EBP + -0x8]
  10001e07  OR ECX,0xffffffff
  10001e0a  PUSH EAX
  10001e0b  XOR EAX,EAX
  10001e0d  SCASB.REPNE ES:EDI
  10001e0f  MOV EDX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10001e15  NOT ECX
  10001e17  MOV ESI,dword ptr [EDX]
  10001e19  DEC ECX
  10001e1a  PUSH ECX
  10001e1b  MOV ECX,dword ptr [EBP + 0xc]
  10001e1e  PUSH ECX
  10001e1f  PUSH EBX
  10001e20  MOV ECX,EDX
  10001e22  CALL dword ptr [ESI + 0x58]
  10001e25  MOV EDX,dword ptr [EBP + -0x8]
  10001e28  MOV EAX,dword ptr [EBP + -0x4]
  10001e2b  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10001e31  PUSH 0x1
  10001e33  LEA EDI,[EDX + 0x4]
  10001e36  MOV dword ptr [EBP + 0x1c],EAX
  10001e39  MOV EDX,dword ptr [ECX]
  10001e3b  PUSH EAX
  10001e3c  LEA EAX,[EDI + EDI*0x1]
  10001e3f  PUSH EAX
  10001e40  CALL dword ptr [EDX + 0x20]
  10001e43  MOV ESI,EAX
  10001e45  PUSH EBX
  10001e46  MOV ECX,ESI
  10001e48  MOV EDX,dword ptr [ESI]
  10001e4a  CALL dword ptr [EDX + 0x48]
  10001e4d  MOV AL,[0x1000f605]    ; DAT_1000f605
  10001e52  TEST AL,AL
  10001e54  JZ 0x10001e66    ; LAB_10001e66
  10001e56  MOV EAX,dword ptr [ESI]
  10001e58  PUSH 0x33
  10001e5a  PUSH 0x99
  10001e5f  PUSH 0xff
  10001e64  JMP 0x10001e92    ; LAB_10001e92
LAB_10001e66:
  10001e66  CMP dword ptr [EBP + 0x18],-0x1
  10001e6a  JNZ 0x10001e81    ; LAB_10001e81
  10001e6c  MOV EDX,dword ptr [ESI]
  10001e6e  PUSH 0xff
  10001e73  PUSH 0xcc
  10001e78  PUSH 0x66
  10001e7a  MOV ECX,ESI
  10001e7c  CALL dword ptr [EDX + 0x34]
  10001e7f  JMP 0x10001e97    ; LAB_10001e97
LAB_10001e81:
  10001e81  MOV EAX,dword ptr [ESI]
  10001e83  PUSH 0xff
  10001e88  PUSH 0xcc
  10001e8d  PUSH 0x99
LAB_10001e92:
  10001e92  MOV ECX,ESI
  10001e94  CALL dword ptr [EAX + 0x34]
LAB_10001e97:
  10001e97  MOV EDX,dword ptr [ESI]
  10001e99  PUSH 0x0
  10001e9b  PUSH 0x0
  10001e9d  PUSH 0x0
  10001e9f  MOV ECX,ESI
  10001ea1  CALL dword ptr [EDX + 0x24]
  10001ea4  PUSH 0x0
  10001ea6  PUSH 0x0
  10001ea8  PUSH 0x1000e288    ; s_<B><U>_1000e288
  10001ead  PUSH ESI
  10001eae  CALL 0x10004a00    ; FUN_10004a00
  10001eb3  MOV EAX,dword ptr [EBP + 0xc]
  10001eb6  PUSH 0x0
  10001eb8  PUSH 0x0
  10001eba  PUSH EAX
  10001ebb  PUSH ESI
  10001ebc  CALL 0x10004a00    ; FUN_10004a00
  10001ec1  MOV EDX,dword ptr [ESI]
  10001ec3  ADD ESP,0x20
  10001ec6  MOV ECX,ESI
  10001ec8  PUSH 0xff
  10001ecd  PUSH 0xff
  10001ed2  PUSH 0xff
  10001ed7  CALL dword ptr [EDX + 0x24]
  10001eda  MOV EAX,dword ptr [EBP + 0xc]
  10001edd  PUSH 0x0
  10001edf  PUSH EDI
  10001ee0  PUSH EAX
  10001ee1  PUSH ESI
  10001ee2  CALL 0x10004a00    ; FUN_10004a00
  10001ee7  PUSH 0x0
  10001ee9  PUSH 0x0
  10001eeb  PUSH 0x1000e27c    ; s_</B></U>_1000e27c
  10001ef0  PUSH ESI
  10001ef1  CALL 0x10004a00    ; FUN_10004a00
  10001ef6  MOV EDX,dword ptr [EBX]
  10001ef8  ADD ESP,0x20
  10001efb  MOV ECX,EBX
  10001efd  CALL dword ptr [EDX + 0x4]
  10001f00  MOV EDX,dword ptr [EBP + 0x24]
  10001f03  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10001f09  PUSH EDX
  10001f0a  MOV EDX,dword ptr [EBP + 0x18]
  10001f0d  PUSH EDX
  10001f0e  MOV EDX,dword ptr [EBP + 0x1c]
  10001f11  PUSH 0x0
  10001f13  PUSH ESI
  10001f14  PUSH EDX
  10001f15  MOV EDX,dword ptr [EBP + 0x14]
  10001f18  PUSH EDI
  10001f19  MOV EAX,dword ptr [ECX]
  10001f1b  PUSH EDX
  10001f1c  MOV EDX,dword ptr [EBP + 0x10]
  10001f1f  PUSH EDX
  10001f20  MOV EDX,dword ptr [EBP + 0x20]
  10001f23  PUSH EDX
  10001f24  MOV EDX,dword ptr [EBP + 0x8]
  10001f27  PUSH EDX
  10001f28  CALL dword ptr [EAX + 0x30]
  10001f2b  MOV EDI,EAX
  10001f2d  MOV EAX,dword ptr [ESI]
  10001f2f  MOV ECX,ESI
  10001f31  CALL dword ptr [EAX + 0x4]
  10001f34  MOV EAX,EDI
  10001f36  POP EDI
  10001f37  POP ESI
  10001f38  POP EBX
  10001f39  MOV ESP,EBP
  10001f3b  POP EBP
  10001f3c  RET 0x20

;==== FUNCTION FUN_10001f40 @ 10001f40 : undefined FUN_10001f40(void)
  10001f40  PUSH EBP
  10001f41  MOV EBP,ESP
  10001f43  MOV EAX,dword ptr [EBP + 0x8]
  10001f46  PUSH EAX
  10001f47  MOV ECX,dword ptr [EAX]
  10001f49  CALL 0x10001c90    ; FUN_10001c90
  10001f4e  POP EBP
  10001f4f  RET

;==== FUNCTION FUN_10001f50 @ 10001f50 : int * FUN_10001f50(void * this, int param_1)
  10001f50  PUSH EBP
  10001f51  MOV EBP,ESP
  10001f53  SUB ESP,0x28
  10001f56  MOV EAX,dword ptr [EBP + 0x8]
  10001f59  PUSH EBX
  10001f5a  PUSH ESI
  10001f5b  MOV ESI,ECX
  10001f5d  MOV dword ptr [EBP + -0x28],0x5
  10001f64  MOV dword ptr [EBP + -0x24],0x7
  10001f6b  MOV dword ptr [ESI + 0x38],EAX
  10001f6e  MOV dword ptr [EBP + -0x20],0xa
  10001f75  MOV dword ptr [EBP + -0x1c],0xd
  10001f7c  MOV dword ptr [EBP + -0x18],0x12
  10001f83  MOV dword ptr [EBP + -0x14],0x17
  10001f8a  MOV dword ptr [EBP + -0x10],0x1e
  10001f91  MOV dword ptr [EBP + -0xc],0x23
  10001f98  MOV dword ptr [EBP + -0x8],0x28
  10001f9f  MOV dword ptr [EBP + -0x4],0x2d
  10001fa6  MOV ECX,0x1
  10001fab  XOR EAX,EAX
LAB_10001fad:
  10001fad  MOV EDX,dword ptr [EBP + EAX*0x1 + -0x24]
  10001fb1  INC ECX
  10001fb2  IMUL EDX,ECX
  10001fb5  MOV EBX,dword ptr [EAX + 0x1000e298]    ; DAT_1000e298 DAT_1000e29c
  10001fbb  ADD EAX,0x4
  10001fbe  ADD EDX,EBX
  10001fc0  CMP EAX,0x24
  10001fc3  MOV dword ptr [EAX + 0x1000e298],EDX    ; DAT_1000e29c DAT_1000e2a0
  10001fc9  JL 0x10001fad    ; LAB_10001fad
  10001fcb  MOV EAX,[0x1000f608]    ; DAT_1000f608
  10001fd0  PUSH 0x1
  10001fd2  MOV ECX,ESI
  10001fd4  MOV dword ptr [ESI],EAX
  10001fd6  MOV dword ptr [ESI + 0xc],0x0
  10001fdd  CALL 0x10002090    ; FUN_10002090
  10001fe2  MOV ECX,dword ptr [ESI]
  10001fe4  MOV dword ptr [ESI + 0x2c],0x0
  10001feb  MOV dword ptr [ESI + 0x34],0x0
  10001ff2  MOV EDX,dword ptr [ECX*0x4 + 0x1000e294]    ; s_l_1000e290+4
  10001ff9  MOV ECX,ESI
  10001ffb  MOV dword ptr [ESI + 0x30],EDX
  10001ffe  CALL 0x10002030    ; FUN_10002030
  10002003  MOV EAX,ESI
  10002005  POP ESI
  10002006  POP EBX
  10002007  MOV ESP,EBP
  10002009  POP EBP
  1000200a  RET 0x4

;==== FUNCTION FUN_10002010 @ 10002010 : undefined FUN_10002010(int param_1)
  10002010  PUSH ESI
  10002011  MOV ESI,ECX
  10002013  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  10002019  MOV EDX,dword ptr [ESI + 0xc]
  1000201c  MOV EAX,dword ptr [ECX]
  1000201e  PUSH EDX
  1000201f  CALL dword ptr [EAX + 0x1c]
  10002022  MOV ECX,dword ptr [ESI + 0xc]
  10002025  MOV EAX,dword ptr [ECX]
  10002027  CALL dword ptr [EAX + 0x4]
  1000202a  POP ESI
  1000202b  RET

;==== FUNCTION FUN_10002030 @ 10002030 : undefined FUN_10002030(void * param_1)
  10002030  PUSH EBX
  10002031  PUSH ESI
  10002032  MOV ESI,ECX
  10002034  PUSH EDI
  10002035  PUSH 0x1
  10002037  FILD dword ptr [ESI + 0x20]
  1000203a  MOV byte ptr [ESI + 0x4],0x0
  1000203e  FMUL float ptr [0x1000d12c]    ; DAT_1000d12c
  10002044  FSUBR float ptr [0x1000d140]    ; DAT_1000d140
  1000204a  FSTP float ptr [ESI + 0x10]
  1000204d  FILD dword ptr [ESI + 0x24]
  10002050  FMUL float ptr [0x1000d12c]    ; DAT_1000d12c
  10002056  FSUBR float ptr [0x1000d13c]    ; DAT_1000d13c
  1000205c  FSTP float ptr [ESI + 0x14]
  1000205f  CALL 0x10002090    ; FUN_10002090
  10002064  MOV EDI,dword ptr [ESI + 0xc]
  10002067  PUSH 0x0
  10002069  FLD float ptr [ESI + 0x14]
  1000206c  MOV EBX,dword ptr [EDI]
  1000206e  CALL 0x10005110    ; __ftol
  10002073  FLD float ptr [ESI + 0x10]
  10002076  PUSH EAX
  10002077  CALL 0x10005110    ; __ftol
  1000207c  PUSH EAX
  1000207d  MOV ECX,EDI
  1000207f  CALL dword ptr [EBX + 0x8]
  10002082  XOR EAX,EAX
  10002084  POP EDI
  10002085  MOV dword ptr [ESI + 0x18],EAX
  10002088  MOV dword ptr [ESI + 0x1c],EAX
  1000208b  POP ESI
  1000208c  POP EBX
  1000208d  RET

;==== FUNCTION FUN_10002090 @ 10002090 : undefined FUN_10002090(void * this, undefined1 param_1)
  10002090  PUSH EBP
  10002091  MOV EBP,ESP
  10002093  MOV AL,byte ptr [EBP + 0x8]
  10002096  PUSH ESI
  10002097  MOV ESI,ECX
  10002099  PUSH EDI
  1000209a  MOV byte ptr [ESI + 0x28],AL
  1000209d  MOV EAX,dword ptr [ESI + 0xc]
  100020a0  TEST EAX,EAX
  100020a2  JZ 0x100020b8    ; LAB_100020b8
  100020a4  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  100020aa  PUSH EAX
  100020ab  MOV EDX,dword ptr [ECX]
  100020ad  CALL dword ptr [EDX + 0x1c]
  100020b0  MOV ECX,dword ptr [ESI + 0xc]
  100020b3  MOV EAX,dword ptr [ECX]
  100020b5  CALL dword ptr [EAX + 0x4]
LAB_100020b8:
  100020b8  MOV AL,byte ptr [ESI + 0x28]
  100020bb  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  100020c1  MOV EDI,dword ptr [0x1000f5cc]    ; DAT_1000f5cc
  100020c7  PUSH 0x0
  100020c9  MOV EDX,dword ptr [ECX]
  100020cb  TEST AL,AL
  100020cd  MOV EAX,dword ptr [ESI]
  100020cf  JZ 0x100020d7    ; LAB_100020d7
  100020d1  MOV EAX,dword ptr [EDI + EAX*0x4 + 0x54]
  100020d5  JMP 0x100020db    ; LAB_100020db
LAB_100020d7:
  100020d7  MOV EAX,dword ptr [EDI + EAX*0x4 + 0x7c]
LAB_100020db:
  100020db  PUSH EAX
  100020dc  CALL dword ptr [EDX + 0x8]
  100020df  MOV dword ptr [ESI + 0xc],EAX
  100020e2  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  100020e8  PUSH EAX
  100020e9  MOV EDX,dword ptr [ECX]
  100020eb  CALL dword ptr [EDX + 0x18]
  100020ee  MOV ECX,dword ptr [ESI + 0xc]
  100020f1  MOV EDX,dword ptr [ECX]
  100020f3  CALL dword ptr [EDX + 0x2c]
  100020f6  MOV ECX,dword ptr [ESI + 0xc]
  100020f9  LEA EDX,[ESI + 0x24]
  100020fc  ADD ESI,0x20
  100020ff  PUSH EDX
  10002100  MOV EAX,dword ptr [ECX]
  10002102  PUSH ESI
  10002103  CALL dword ptr [EAX + 0x48]
  10002106  POP EDI
  10002107  POP ESI
  10002108  POP EBP
  10002109  RET 0x4

;==== FUNCTION FUN_10002110 @ 10002110 : undefined FUN_10002110(void * this, undefined4 param_1)
  10002110  PUSH EBP
  10002111  MOV EBP,ESP
  10002113  SUB ESP,0x8
  10002116  MOV EAX,dword ptr [EBP + 0x8]
  10002119  PUSH ESI
  1000211a  MOV ESI,ECX
  1000211c  DEC EAX
  1000211d  MOV ECX,0x3
  10002122  MOV dword ptr [EBP + -0x8],0x3dcccccd
  10002129  CMP EAX,ECX
  1000212b  MOV dword ptr [EBP + -0x4],0x3f800000
  10002132  JA 0x10002306    ; switchD_10002138::default
switchD:
  10002138  JMP dword ptr [EAX*0x4 + 0x10002314]    ; switchD_10002138::caseD_1 switchD_10002138::caseD_2 switchD_10002138::caseD_3 switchD_10002138::caseD_4 switchD_10002138::switchdataD_10002314
caseD_1:
  1000213f  MOV AL,byte ptr [ESI + 0x28]
  10002142  TEST AL,AL
  10002144  JNZ 0x1000214f    ; LAB_1000214f
  10002146  PUSH 0x1
  10002148  MOV ECX,ESI
  1000214a  CALL 0x10002090    ; FUN_10002090
LAB_1000214f:
  1000214f  TEST byte ptr [0x1000f5f0],0xc    ; DAT_1000f5f0
  10002156  JZ 0x10002166    ; LAB_10002166
  10002158  MOV dword ptr [EBP + -0x8],0x3d90cb2a
  1000215f  MOV dword ptr [EBP + -0x4],0x3f34fdf4
LAB_10002166:
  10002166  FLD float ptr [ESI + 0x18]
  10002169  FCOMP float ptr [0x1000d104]    ; DAT_1000d104
  1000216f  FLD float ptr [EBP + -0x4]
  10002172  FCHS
  10002174  FNSTSW AX
  10002176  TEST AH,0x41
  10002179  JNZ 0x100021a6    ; LAB_100021a6
  1000217b  FLD float ptr [EBP + -0x8]
  1000217e  FADD ST0,ST0
  10002180  FSUBR float ptr [ESI + 0x18]
  10002183  FSTP float ptr [EBP + 0x8]
  10002186  FCOM float ptr [EBP + 0x8]
  10002189  FNSTSW AX
  1000218b  TEST AH,0x41
  1000218e  JZ 0x10002195    ; LAB_10002195
  10002190  FSTP ST0
  10002192  FLD float ptr [EBP + 0x8]
LAB_10002195:
  10002195  FSTP float ptr [ESI + 0x18]
  10002198  MOV ECX,ESI
  1000219a  CALL 0x10002330    ; FUN_10002330
  1000219f  POP ESI
  100021a0  MOV ESP,EBP
  100021a2  POP EBP
  100021a3  RET 0x4
LAB_100021a6:
  100021a6  FLD float ptr [ESI + 0x18]
  100021a9  FSUB float ptr [EBP + -0x8]
  100021ac  FSTP float ptr [EBP + 0x8]
  100021af  FCOM float ptr [EBP + 0x8]
  100021b2  FNSTSW AX
  100021b4  TEST AH,0x41
  100021b7  JZ 0x100021be    ; LAB_100021be
  100021b9  FSTP ST0
  100021bb  FLD float ptr [EBP + 0x8]
LAB_100021be:
  100021be  FSTP float ptr [ESI + 0x18]
  100021c1  MOV ECX,ESI
  100021c3  CALL 0x10002330    ; FUN_10002330
  100021c8  POP ESI
  100021c9  MOV ESP,EBP
  100021cb  POP EBP
  100021cc  RET 0x4
caseD_2:
  100021cf  MOV AL,byte ptr [ESI + 0x28]
  100021d2  TEST AL,AL
  100021d4  JZ 0x100021df    ; LAB_100021df
  100021d6  PUSH 0x0
  100021d8  MOV ECX,ESI
  100021da  CALL 0x10002090    ; FUN_10002090
LAB_100021df:
  100021df  TEST byte ptr [0x1000f5f0],0xc    ; DAT_1000f5f0
  100021e6  JZ 0x100021f6    ; LAB_100021f6
  100021e8  MOV dword ptr [EBP + -0x8],0x3d90cb2a
  100021ef  MOV dword ptr [EBP + -0x4],0x3f34fdf4
LAB_100021f6:
  100021f6  FLD float ptr [ESI + 0x18]
  100021f9  FCOMP float ptr [0x1000d104]    ; DAT_1000d104
  100021ff  FLD float ptr [EBP + -0x8]
  10002202  FNSTSW AX
  10002204  TEST AH,0x1
  10002207  JZ 0x1000220b    ; LAB_1000220b
  10002209  FADD ST0,ST0
LAB_1000220b:
  1000220b  FADD float ptr [ESI + 0x18]
  1000220e  FLD float ptr [EBP + -0x4]
  10002211  FCOMP
  10002213  FNSTSW AX
  10002215  TEST AH,0x1
  10002218  JZ 0x1000221f    ; LAB_1000221f
  1000221a  FSTP ST0
  1000221c  FLD float ptr [EBP + -0x4]
LAB_1000221f:
  1000221f  FSTP float ptr [ESI + 0x18]
  10002222  MOV ECX,ESI
  10002224  CALL 0x10002330    ; FUN_10002330
  10002229  POP ESI
  1000222a  MOV ESP,EBP
  1000222c  POP EBP
  1000222d  RET 0x4
caseD_3:
  10002230  TEST byte ptr [0x1000f5f0],CL    ; DAT_1000f5f0
  10002236  JZ 0x10002246    ; LAB_10002246
  10002238  MOV dword ptr [EBP + -0x8],0x3d90cb2a
  1000223f  MOV dword ptr [EBP + -0x4],0x3f34fdf4
LAB_10002246:
  10002246  FLD float ptr [ESI + 0x1c]
  10002249  FCOMP float ptr [0x1000d104]    ; DAT_1000d104
  1000224f  FLD float ptr [EBP + -0x4]
  10002252  FCHS
  10002254  FNSTSW AX
  10002256  TEST AH,0x41
  10002259  JNZ 0x1000228a    ; LAB_1000228a
  1000225b  FLD float ptr [EBP + -0x8]
  1000225e  FADD ST0,ST0
  10002260  FSUBR float ptr [ESI + 0x1c]
  10002263  FSTP float ptr [EBP + 0x8]
  10002266  FCOM float ptr [EBP + 0x8]
  10002269  FNSTSW AX
  1000226b  TEST AH,0x41
  1000226e  JZ 0x10002303    ; LAB_10002303
  10002274  FSTP ST0
  10002276  FLD float ptr [EBP + 0x8]
  10002279  MOV ECX,ESI
  1000227b  FSTP float ptr [ESI + 0x1c]
  1000227e  CALL 0x10002330    ; FUN_10002330
  10002283  POP ESI
  10002284  MOV ESP,EBP
  10002286  POP EBP
  10002287  RET 0x4
LAB_1000228a:
  1000228a  FLD float ptr [ESI + 0x1c]
  1000228d  FSUB float ptr [EBP + -0x8]
  10002290  FSTP float ptr [EBP + 0x8]
  10002293  FCOM float ptr [EBP + 0x8]
  10002296  FNSTSW AX
  10002298  TEST AH,0x41
  1000229b  JZ 0x10002303    ; LAB_10002303
  1000229d  FSTP ST0
  1000229f  FLD float ptr [EBP + 0x8]
  100022a2  MOV ECX,ESI
  100022a4  FSTP float ptr [ESI + 0x1c]
  100022a7  CALL 0x10002330    ; FUN_10002330
  100022ac  POP ESI
  100022ad  MOV ESP,EBP
  100022af  POP EBP
  100022b0  RET 0x4
caseD_4:
  100022b3  TEST byte ptr [0x1000f5f0],CL    ; DAT_1000f5f0
  100022b9  JZ 0x100022c9    ; LAB_100022c9
  100022bb  MOV dword ptr [EBP + -0x8],0x3d90cb2a
  100022c2  MOV dword ptr [EBP + -0x4],0x3f34fdf4
LAB_100022c9:
  100022c9  FLD float ptr [ESI + 0x1c]
  100022cc  FCOMP float ptr [0x1000d104]    ; DAT_1000d104
  100022d2  FLD float ptr [EBP + -0x8]
  100022d5  FNSTSW AX
  100022d7  TEST AH,0x1
  100022da  JZ 0x100022ef    ; LAB_100022ef
  100022dc  FADD ST0,ST0
  100022de  FADD float ptr [ESI + 0x1c]
  100022e1  FLD float ptr [EBP + -0x4]
  100022e4  FCOMP
  100022e6  FNSTSW AX
  100022e8  TEST AH,0x1
  100022eb  JZ 0x10002303    ; LAB_10002303
  100022ed  JMP 0x100022fe    ; LAB_100022fe
LAB_100022ef:
  100022ef  FADD float ptr [ESI + 0x1c]
  100022f2  FLD float ptr [EBP + -0x4]
  100022f5  FCOMP
  100022f7  FNSTSW AX
  100022f9  TEST AH,0x1
  100022fc  JZ 0x10002303    ; LAB_10002303
LAB_100022fe:
  100022fe  FSTP ST0
  10002300  FLD float ptr [EBP + -0x4]
LAB_10002303:
  10002303  FSTP float ptr [ESI + 0x1c]
default:
  10002306  MOV ECX,ESI
  10002308  CALL 0x10002330    ; FUN_10002330
  1000230d  POP ESI
  1000230e  MOV ESP,EBP
  10002310  POP EBP
  10002311  RET 0x4

;==== FUNCTION FUN_10002330 @ 10002330 : undefined FUN_10002330(int param_1)
  10002330  PUSH EBP
  10002331  MOV EBP,ESP
  10002333  SUB ESP,0x20
  10002336  MOV AL,[0x1000f5d4]    ; DAT_1000f5d4
  1000233b  PUSH EBX
  1000233c  PUSH ESI
  1000233d  MOV ESI,ECX
  1000233f  MOV CL,0x1
  10002341  PUSH EDI
  10002342  TEST CL,AL
  10002344  MOV EAX,[0x1000f5e0]    ; DAT_1000f5e0
  10002349  JNZ 0x1000235e    ; LAB_1000235e
  1000234b  MOV DL,byte ptr [0x1000f5d4]    ; DAT_1000f5d4
  10002351  MOV [0x1000f5d0],EAX    ; DAT_1000f5d0
  10002356  OR DL,CL
  10002358  MOV byte ptr [0x1000f5d4],DL    ; DAT_1000f5d4
LAB_1000235e:
  1000235e  MOV EBX,dword ptr [0x1000f5d0]    ; DAT_1000f5d0
  10002364  XOR ECX,ECX
  10002366  SUB EAX,EBX
  10002368  MOV dword ptr [EBP + -0x1c],ECX
  1000236b  MOV dword ptr [EBP + -0x20],EAX
  1000236e  MOV EAX,dword ptr [ESI + 0x20]
  10002371  FILD qword ptr [EBP + -0x20]
  10002374  MOV dword ptr [EBP + -0x8],EAX
  10002377  CDQ
  10002378  FLD ST0
  1000237a  FMUL float ptr [ESI + 0x18]
  1000237d  SUB EAX,EDX
  1000237f  SAR EAX,0x1
  10002381  FMUL float ptr [0x1000d144]    ; DAT_1000d144
  10002387  MOV dword ptr [EBP + -0x18],EAX
  1000238a  MOV EAX,dword ptr [ESI + 0x24]
  1000238d  CDQ
  1000238e  FSTP float ptr [EBP + -0x1c]
  10002391  SUB EAX,EDX
  10002393  FMUL float ptr [ESI + 0x1c]
  10002396  SAR EAX,0x1
  10002398  FMUL float ptr [0x1000d144]    ; DAT_1000d144
  1000239e  FILD dword ptr [EBP + -0x18]
  100023a1  MOV dword ptr [EBP + -0x18],EAX
  100023a4  FSTP float ptr [EBP + -0x10]
  100023a7  FLD float ptr [ESI + 0x10]
  100023aa  FSUB float ptr [0x1000d134]    ; DAT_1000d134
  100023b0  FADD float ptr [EBP + -0x10]
  100023b3  FADD float ptr [EBP + -0x1c]
  100023b6  FSTP float ptr [EBP + -0x4]
  100023b9  FILD dword ptr [EBP + -0x18]
  100023bc  FSTP float ptr [EBP + -0x18]
  100023bf  FLD float ptr [ESI + 0x14]
  100023c2  FSUB float ptr [0x1000d130]    ; DAT_1000d130
  100023c8  FADD float ptr [EBP + -0x18]
  100023cb  FADD ST0,ST1
  100023cd  FST float ptr [EBP + -0xc]
  100023d0  FMUL float ptr [EBP + -0xc]
  100023d3  FLD float ptr [EBP + -0x4]
  100023d6  FMUL float ptr [EBP + -0x4]
  100023d9  FADDP
  100023db  FST float ptr [EBP + -0x14]
  100023de  FILD dword ptr [EBP + -0x8]
  100023e1  FMUL float ptr [0x1000d12c]    ; DAT_1000d12c
  100023e7  FSUBR float ptr [0x1000d128]    ; DAT_1000d128
  100023ed  FLD ST0
  100023ef  FMUL ST1
  100023f1  FSTP float ptr [EBP + -0x8]
  100023f4  FSTP ST0
  100023f6  FCOMP float ptr [EBP + -0x8]
  100023f9  FNSTSW AX
  100023fb  TEST AH,0x1
  100023fe  JNZ 0x10002434    ; LAB_10002434
  10002400  FSTP ST0
  10002402  FLD float ptr [EBP + -0x8]
  10002405  FMUL float ptr [EBP + -0x4]
  10002408  MOV dword ptr [ESI + 0x18],ECX
  1000240b  MOV dword ptr [ESI + 0x1c],ECX
  1000240e  FDIV float ptr [EBP + -0x14]
  10002411  FADD float ptr [0x1000d134]    ; DAT_1000d134
  10002417  FSUB float ptr [EBP + -0x10]
  1000241a  FSTP float ptr [ESI + 0x10]
  1000241d  FLD float ptr [EBP + -0x8]
  10002420  FMUL float ptr [EBP + -0xc]
  10002423  FDIV float ptr [EBP + -0x14]
  10002426  FADD float ptr [0x1000d130]    ; DAT_1000d130
  1000242c  FSUB float ptr [EBP + -0x18]
  1000242f  FSTP float ptr [ESI + 0x14]
  10002432  JMP 0x10002443    ; LAB_10002443
LAB_10002434:
  10002434  FLD float ptr [EBP + -0x1c]
  10002437  FADD float ptr [ESI + 0x10]
  1000243a  FSTP float ptr [ESI + 0x10]
  1000243d  FADD float ptr [ESI + 0x14]
  10002440  FSTP float ptr [ESI + 0x14]
LAB_10002443:
  10002443  MOV EDI,dword ptr [ESI + 0xc]
  10002446  PUSH ECX
  10002447  FLD float ptr [ESI + 0x14]
  1000244a  MOV EBX,dword ptr [EDI]
  1000244c  CALL 0x10005110    ; __ftol
  10002451  FLD float ptr [ESI + 0x10]
  10002454  PUSH EAX
  10002455  CALL 0x10005110    ; __ftol
  1000245a  PUSH EAX
  1000245b  MOV ECX,EDI
  1000245d  CALL dword ptr [EBX + 0x8]
  10002460  MOV EAX,[0x1000f5e0]    ; DAT_1000f5e0
  10002465  POP EDI
  10002466  POP ESI
  10002467  MOV [0x1000f5d0],EAX    ; DAT_1000f5d0
  1000246c  POP EBX
  1000246d  MOV ESP,EBP
  1000246f  POP EBP
  10002470  RET

;==== FUNCTION FUN_10002480 @ 10002480 : undefined FUN_10002480(void * this, int * param_1)
  10002480  PUSH EBP
  10002481  MOV EBP,ESP
  10002483  PUSH ESI
  10002484  MOV ESI,ECX
  10002486  PUSH EDI
  10002487  FLD float ptr [ESI + 0x10]
  1000248a  CALL 0x10005110    ; __ftol
  1000248f  MOV ECX,EAX
  10002491  MOV EAX,dword ptr [ESI + 0x20]
  10002494  MOV EDI,dword ptr [EBP + 0x8]
  10002497  CDQ
  10002498  SUB EAX,EDX
  1000249a  SAR EAX,0x1
  1000249c  SUB ECX,EAX
  1000249e  MOV dword ptr [EDI],ECX
  100024a0  FLD float ptr [ESI + 0x14]
  100024a3  CALL 0x10005110    ; __ftol
  100024a8  MOV ECX,EAX
  100024aa  MOV EAX,dword ptr [ESI + 0x24]
  100024ad  CDQ
  100024ae  SUB EAX,EDX
  100024b0  MOV EDX,dword ptr [EDI]
  100024b2  SAR EAX,0x1
  100024b4  SUB ECX,EAX
  100024b6  MOV dword ptr [EDI + 0x4],ECX
  100024b9  MOV EAX,dword ptr [ESI + 0x20]
  100024bc  ADD EDX,EAX
  100024be  MOV EAX,ECX
  100024c0  MOV dword ptr [EDI + 0x8],EDX
  100024c3  MOV ECX,dword ptr [ESI + 0x24]
  100024c6  ADD EAX,ECX
  100024c8  MOV dword ptr [EDI + 0xc],EAX
  100024cb  POP EDI
  100024cc  POP ESI
  100024cd  POP EBP
  100024ce  RET 0x4

;==== FUNCTION FUN_100024e0 @ 100024e0 : uint FUN_100024e0(void * this, int * param_1)
  100024e0  PUSH EBP
  100024e1  MOV EBP,ESP
  100024e3  MOV EAX,dword ptr [EBP + 0x8]
  100024e6  PUSH ESI
  100024e7  MOV ESI,ECX
  100024e9  MOV EAX,dword ptr [EAX]
  100024eb  CMP dword ptr [ESI],EAX
  100024ed  JGE 0x100024f6    ; LAB_100024f6
  100024ef  MOV AL,0x1
  100024f1  POP ESI
  100024f2  POP EBP
  100024f3  RET 0x4
LAB_100024f6:
  100024f6  MOV ECX,dword ptr [ESI + 0x2c]
  100024f9  LEA EDX,[EAX + EAX*0x4]
  100024fc  ADD ECX,EAX
  100024fe  MOV dword ptr [ESI + 0x2c],ECX
  10002501  MOV ECX,dword ptr [ESI + 0x38]
  10002504  SHL EDX,0x1
  10002506  MOV EAX,dword ptr [ECX + 0x8]
  10002509  ADD EAX,EDX
  1000250b  MOV dword ptr [ECX + 0x8],EAX
  1000250e  MOV ECX,dword ptr [ESI + 0x38]
  10002511  CALL 0x10003ad0    ; FUN_10003ad0
  10002516  MOV EAX,[0x1000f5cc]    ; DAT_1000f5cc
  1000251b  PUSH 0x0
  1000251d  MOV ECX,dword ptr [EAX + 0xdc]
  10002523  MOV EDX,dword ptr [ECX]
  10002525  CALL dword ptr [EDX + 0x8]
  10002528  MOV EAX,dword ptr [ESI + 0x2c]
  1000252b  MOV ECX,dword ptr [ESI + 0x30]
  1000252e  CMP EAX,ECX
  10002530  JL 0x100025e2    ; LAB_100025e2
  10002536  MOV ECX,dword ptr [0x1000f5cc]    ; DAT_1000f5cc
  1000253c  PUSH 0x0
  1000253e  MOV ECX,dword ptr [ECX + 0xe0]
  10002544  MOV EDX,dword ptr [ECX]
  10002546  CALL dword ptr [EDX + 0x8]
  10002549  MOV EAX,dword ptr [ESI]
  1000254b  CMP EAX,0x9
  1000254e  JNZ 0x1000256e    ; LAB_1000256e
  10002550  FILD dword ptr [ESI + 0x30]
  10002553  FMUL double ptr [0x1000d148]    ; DAT_1000d148
  10002559  CALL 0x10005110    ; __ftol
  1000255e  MOV dword ptr [ESI + 0x30],EAX
  10002561  MOV ECX,dword ptr [0x1000f5e4]    ; DAT_1000f5e4
  10002567  CALL 0x10003670    ; FUN_10003670
  1000256c  JMP 0x10002581    ; LAB_10002581
LAB_1000256e:
  1000256e  MOV ECX,dword ptr [EAX*0x4 + 0x1000e298]    ; DAT_1000e298
  10002575  INC EAX
  10002576  MOV dword ptr [ESI + 0x30],ECX
  10002579  MOV dword ptr [ESI],EAX
  1000257b  INC dword ptr [0x1000f5dc]    ; DAT_1000f5dc
LAB_10002581:
  10002581  MOV DL,byte ptr [ESI + 0x28]
  10002584  MOV ECX,ESI
  10002586  PUSH EDX
  10002587  CALL 0x10002090    ; FUN_10002090
  1000258c  MOV ECX,dword ptr [ESI + 0x34]
  1000258f  INC ECX
  10002590  MOV EAX,ECX
  10002592  MOV dword ptr [ESI + 0x34],ECX
  10002595  CDQ
  10002596  MOV ECX,0x3
  1000259b  IDIV ECX
  1000259d  TEST EDX,EDX
  1000259f  JNZ 0x100025cc    ; LAB_100025cc
  100025a1  MOV EAX,dword ptr [ESI + 0x38]
  100025a4  MOV ECX,dword ptr [EAX + 0x1a4]
  100025aa  INC ECX
  100025ab  MOV dword ptr [EAX + 0x1a4],ECX
  100025b1  MOV ECX,dword ptr [ESI + 0x38]
  100025b4  CALL 0x10003a60    ; FUN_10003a60
  100025b9  MOV EDX,dword ptr [0x1000f5cc]    ; DAT_1000f5cc
  100025bf  PUSH 0x0
  100025c1  MOV ECX,dword ptr [EDX + 0xf0]
  100025c7  MOV EAX,dword ptr [ECX]
  100025c9  CALL dword ptr [EAX + 0x8]
LAB_100025cc:
  100025cc  MOV ECX,dword ptr [0x1000f5e4]    ; DAT_1000f5e4
  100025d2  CALL 0x10003bc0    ; FUN_10003bc0
  100025d7  MOV ECX,dword ptr [0x1000f5e4]    ; DAT_1000f5e4
  100025dd  CALL 0x10003670    ; FUN_10003670
LAB_100025e2:
  100025e2  XOR AL,AL
  100025e4  POP ESI
  100025e5  POP EBP
  100025e6  RET 0x4

;==== FUNCTION Shell_StartApplet @ 100025f0 : undefined Shell_StartApplet(int * param_1)
  100025f0  PUSH EBP
  100025f1  MOV EBP,ESP
  100025f3  PUSH ESI
  100025f4  PUSH 0xf4
  100025f9  CALL 0x100051a2    ; operator_new
  100025fe  MOV ESI,dword ptr [EBP + 0x8]
  10002601  ADD ESP,0x4
  10002604  TEST EAX,EAX
  10002606  JZ 0x10002612    ; LAB_10002612
  10002608  PUSH ESI
  10002609  MOV ECX,EAX
  1000260b  CALL 0x100016a0    ; FUN_100016a0
  10002610  JMP 0x10002614    ; LAB_10002614
LAB_10002612:
  10002612  XOR EAX,EAX
LAB_10002614:
  10002614  MOV [0x1000f5d8],EAX    ; DAT_1000f5d8
  10002619  MOV ECX,dword ptr [ESI + 0x14]
  1000261c  PUSH 0x1000e360    ; s_Moeboid_1000e360
  10002621  MOV EAX,dword ptr [ECX]
  10002623  CALL dword ptr [EAX + 0x8]
  10002626  POP ESI
  10002627  POP EBP
  10002628  RET

;==== FUNCTION Shell_StopApplet @ 10002630 : undefined4 Shell_StopApplet(void)
  10002630  MOV ECX,dword ptr [0x1000f5d8]    ; DAT_1000f5d8
  10002636  TEST ECX,ECX
  10002638  JZ 0x1000264f    ; LAB_1000264f
  1000263a  PUSH ESI
  1000263b  MOV ESI,ECX
  1000263d  CALL 0x10001b50    ; FUN_10001b50
  10002642  PUSH ESI
  10002643  CALL 0x10005197    ; FUN_10005197
  10002648  ADD ESP,0x4
  1000264b  XOR EAX,EAX
  1000264d  POP ESI
  1000264e  RET
LAB_1000264f:
  1000264f  XOR EAX,EAX
  10002651  RET

;==== FUNCTION FUN_10002660 @ 10002660 : undefined FUN_10002660(void * this, undefined4 param_1)
  10002660  PUSH EBP
  10002661  MOV EBP,ESP
  10002663  MOV EAX,ECX
  10002665  MOV ECX,dword ptr [EBP + 0x8]
  10002668  MOV dword ptr [EAX],0x1000d150    ; PTR_FUN_1000d150
  1000266e  MOV dword ptr [EAX + 0x4],ECX
  10002671  POP EBP
  10002672  RET 0x4

;==== FUNCTION FUN_10002680 @ 10002680 : undefined4 * FUN_10002680(void * this, byte param_1)
  10002680  PUSH EBP
  10002681  MOV EBP,ESP
  10002683  PUSH ESI
  10002684  MOV ESI,ECX
  10002686  CALL 0x100026b0    ; FUN_100026b0
  1000268b  TEST byte ptr [EBP + 0x8],0x1
  1000268f  JZ 0x1000269a    ; LAB_1000269a
  10002691  PUSH ESI
  10002692  CALL 0x10005197    ; FUN_10005197
  10002697  ADD ESP,0x4
LAB_1000269a:
  1000269a  MOV EAX,ESI
  1000269c  POP ESI
  1000269d  POP EBP
  1000269e  RET 0x4

;==== FUNCTION FUN_100026b0 @ 100026b0 : undefined FUN_100026b0(undefined4 * param_1)
  100026b0  MOV dword ptr [ECX],0x1000d150    ; PTR_FUN_1000d150
  100026b6  RET

;==== FUNCTION FUN_100026c0 @ 100026c0 : undefined4 * FUN_100026c0(void * this, undefined4 param_1)
  100026c0  PUSH EBP
  100026c1  MOV EBP,ESP
  100026c3  PUSH -0x1
  100026c5  PUSH 0x1000c5a3    ; LAB_1000c5a3
  100026ca  MOV EAX,FS:[0x0]    ; ExceptionList
  100026d0  PUSH EAX
  100026d1  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  100026d8  SUB ESP,0x3ec
  100026de  MOV EAX,dword ptr [EBP + 0x8]
  100026e1  PUSH EBX
  100026e2  PUSH ESI
  100026e3  PUSH EDI
  100026e4  MOV ESI,ECX
  100026e6  PUSH EAX
  100026e7  MOV dword ptr [EBP + -0x10],ESI
  100026ea  CALL 0x10002660    ; FUN_10002660
  100026ef  MOV dword ptr [ESI],0x1000d154    ; PTR_FUN_1000d154
  100026f5  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  100026fb  MOV byte ptr [0x1000f605],0x1    ; DAT_1000f605
  10002702  MOV EAX,dword ptr [ESI + 0x4]
  10002705  MOV EDX,dword ptr [ECX]
  10002707  PUSH 0x0
  10002709  MOV EAX,dword ptr [EAX + 0xc0]
  1000270f  PUSH 0x0
  10002711  PUSH EAX
  10002712  MOV dword ptr [EBP + -0x4],0x0
  10002719  CALL dword ptr [EDX + 0x40]
  1000271c  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10002722  PUSH 0x33
  10002724  PUSH 0x99
  10002729  PUSH 0xff
  1000272e  MOV EDX,dword ptr [ECX]
  10002730  CALL dword ptr [EDX + 0x1c]
  10002733  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10002739  PUSH 0x28
  1000273b  PUSH 0x46
  1000273d  PUSH 0x0
  1000273f  MOV EAX,dword ptr [ECX]
  10002741  PUSH 0x0
  10002743  CALL dword ptr [EAX + 0x10]
  10002746  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  1000274c  PUSH 0x1a4
  10002751  PUSH 0x1f4
  10002756  PUSH 0x177
  1000275b  MOV EDX,dword ptr [ECX]
  1000275d  PUSH 0x1ac
  10002762  CALL dword ptr [EDX + 0x10]
  10002765  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  1000276b  PUSH 0x0
  1000276d  PUSH 0x0
  1000276f  PUSH 0x0
  10002771  MOV EAX,dword ptr [ECX]
  10002773  CALL dword ptr [EAX + 0x1c]
  10002776  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  1000277c  PUSH 0x28
  1000277e  PUSH 0x1f4
  10002783  PUSH 0x0
  10002785  MOV EDX,dword ptr [ECX]
  10002787  PUSH 0x1ac
  1000278c  CALL dword ptr [EDX + 0x10]
  1000278f  MOV EAX,[0x1000f5bc]    ; DAT_1000f5bc
  10002794  MOV ECX,dword ptr [ESI + 0x4]
  10002797  PUSH 0x10002a60    ; FUN_10002a60
  1000279c  PUSH ESI
  1000279d  PUSH 0x12
  1000279f  PUSH 0x0
  100027a1  PUSH 0x181
  100027a6  PUSH 0x1ac
  100027ab  PUSH 0x1000e540    ; DAT_1000e540
  100027b0  PUSH EAX
  100027b1  CALL 0x10001de0    ; FUN_10001de0
  100027b6  MOV dword ptr [ESI + 0x19c],EAX
  100027bc  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  100027c2  PUSH 0x1e
  100027c4  PUSH 0x0
  100027c6  PUSH 0x1000e50c    ; s_<S2><c><b><c000000><u>The_ZapSpo_1000e50c
  100027cb  PUSH ECX
  100027cc  CALL 0x10004a00    ; FUN_10004a00
  100027d1  ADD ESP,0x10
  100027d4  MOV EBX,0x32
  100027d9  MOV EDI,0x1000e368    ; PTR_s_Adam_Smith_1000e368
LAB_100027de:
  100027de  MOV EDX,dword ptr [EDI]    ; PTR_s_Adam_Smith_1000e368 PTR_s_Ari_Feldman_1000e36c
  100027e0  LEA EAX,[EBP + 0xfffffc08]
  100027e6  PUSH EDX    ; s_Adam_Smith_1000e4e0 s_Ari_Feldman_1000e4d4
  100027e7  PUSH 0x1000e4ec    ; s_<S3><c><b><c000000>%s</b></c>_1000e4ec
  100027ec  PUSH EAX
  100027ed  CALL 0x100051b0    ; FUN_100051b0
  100027f2  MOV EDX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  100027f8  PUSH EBX
  100027f9  LEA ECX,[EBP + 0xfffffc08]
  100027ff  PUSH 0x0
  10002801  PUSH ECX
  10002802  PUSH EDX
  10002803  CALL 0x10004a00    ; FUN_10004a00
  10002808  ADD EDI,0x4
  1000280b  ADD ESP,0x1c
  1000280e  ADD EBX,0x10
  10002811  CMP EDI,0x1000e3c0    ; s_Xenia_Lok_1000e3c0
  10002817  JL 0x100027de    ; LAB_100027de
  10002819  MOV dword ptr [ESI + 0x198],0x0
LAB_10002823:
  10002823  PUSH 0x38
  10002825  CALL 0x100051a2    ; operator_new
  1000282a  MOV EDI,EAX
  1000282c  ADD ESP,0x4
  1000282f  MOV dword ptr [EBP + 0x8],EDI
  10002832  TEST EDI,EDI
  10002834  MOV byte ptr [EBP + -0x4],0x1
  10002838  JZ 0x10002859    ; LAB_10002859
  1000283a  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  10002840  MOV EAX,dword ptr [ECX]
  10002842  CALL dword ptr [EAX + 0x8]
  10002845  XOR EDX,EDX
  10002847  MOV ECX,0xa
  1000284c  DIV ECX
  1000284e  MOV ECX,EDI
  10002850  INC EDX
  10002851  PUSH EDX
  10002852  CALL 0x100011a0    ; FUN_100011a0
  10002857  JMP 0x1000285b    ; LAB_1000285b
LAB_10002859:
  10002859  XOR EAX,EAX
LAB_1000285b:
  1000285b  MOV EDX,dword ptr [ESI + 0x198]
  10002861  MOV byte ptr [EBP + -0x4],0x0
  10002865  MOV dword ptr [ESI + EDX*0x4 + 0x8],EAX
  10002869  MOV ECX,dword ptr [ESI + 0x198]
  1000286f  INC ECX
  10002870  MOV EAX,ECX
  10002872  MOV dword ptr [ESI + 0x198],ECX
  10002878  CMP EAX,0x64
  1000287b  JL 0x10002823    ; LAB_10002823
  1000287d  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10002883  PUSH 0x10002a70    ; FUN_10002a70
  10002888  PUSH 0x14
  1000288a  PUSH ESI
  1000288b  MOV EAX,dword ptr [ECX]
  1000288d  CALL dword ptr [EAX + 0x34]
  10002890  MOV dword ptr [ESI + 0x1a0],EAX
  10002896  MOV EDX,dword ptr [EAX]
  10002898  MOV ECX,EAX
  1000289a  CALL dword ptr [EDX + 0x8]
  1000289d  MOV ECX,dword ptr [EBP + -0xc]
  100028a0  MOV EAX,ESI
  100028a2  POP EDI
  100028a3  POP ESI
  100028a4  POP EBX
  100028a5  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  100028ac  MOV ESP,EBP
  100028ae  POP EBP
  100028af  RET 0x4

;==== FUNCTION FUN_100028c0 @ 100028c0 : undefined4 * FUN_100028c0(void * this, byte param_1)
  100028c0  PUSH EBP
  100028c1  MOV EBP,ESP
  100028c3  PUSH ESI
  100028c4  MOV ESI,ECX
  100028c6  CALL 0x100028f0    ; FUN_100028f0
  100028cb  TEST byte ptr [EBP + 0x8],0x1
  100028cf  JZ 0x100028da    ; LAB_100028da
  100028d1  PUSH ESI
  100028d2  CALL 0x10005197    ; FUN_10005197
  100028d7  ADD ESP,0x4
LAB_100028da:
  100028da  MOV EAX,ESI
  100028dc  POP ESI
  100028dd  POP EBP
  100028de  RET 0x4

;==== FUNCTION FUN_100028f0 @ 100028f0 : undefined FUN_100028f0(undefined4 * param_1)
  100028f0  PUSH EBP
  100028f1  MOV EBP,ESP
  100028f3  PUSH -0x1
  100028f5  PUSH 0x1000c5b8    ; LAB_1000c5b8
  100028fa  MOV EAX,FS:[0x0]    ; ExceptionList
  10002900  PUSH EAX
  10002901  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  10002908  SUB ESP,0x8
  1000290b  PUSH EBX
  1000290c  PUSH ESI
  1000290d  MOV ESI,ECX
  1000290f  MOV dword ptr [EBP + -0x14],ESI
  10002912  MOV dword ptr [ESI],0x1000d154    ; PTR_FUN_1000d154
  10002918  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  1000291e  MOV EDX,dword ptr [ESI + 0x19c]
  10002924  XOR EBX,EBX
  10002926  PUSH EDX
  10002927  MOV EAX,dword ptr [ECX]
  10002929  MOV dword ptr [EBP + -0x4],EBX
  1000292c  CALL dword ptr [EAX + 0x1c]
  1000292f  MOV ECX,dword ptr [ESI + 0x19c]
  10002935  MOV EAX,dword ptr [ECX]
  10002937  CALL dword ptr [EAX + 0x4]
  1000293a  CMP dword ptr [ESI + 0x198],EBX
  10002940  JLE 0x10002977    ; LAB_10002977
  10002942  LEA ECX,[ESI + 0x8]
  10002945  PUSH EDI
  10002946  MOV dword ptr [EBP + -0x10],ECX
LAB_10002949:
  10002949  MOV EDX,dword ptr [EBP + -0x10]
  1000294c  MOV EDI,dword ptr [EDX]
  1000294e  TEST EDI,EDI
  10002950  JZ 0x10002962    ; LAB_10002962
  10002952  MOV ECX,EDI
  10002954  CALL 0x10001340    ; FUN_10001340
  10002959  PUSH EDI
  1000295a  CALL 0x10005197    ; FUN_10005197
  1000295f  ADD ESP,0x4
LAB_10002962:
  10002962  MOV ECX,dword ptr [EBP + -0x10]
  10002965  MOV EAX,dword ptr [ESI + 0x198]
  1000296b  INC EBX
  1000296c  ADD ECX,0x4
  1000296f  CMP EBX,EAX
  10002971  MOV dword ptr [EBP + -0x10],ECX
  10002974  JL 0x10002949    ; LAB_10002949
  10002976  POP EDI
LAB_10002977:
  10002977  MOV ECX,dword ptr [ESI + 0x1a0]
  1000297d  MOV EAX,dword ptr [ECX]
  1000297f  CALL dword ptr [EAX + 0x4]
  10002982  MOV ECX,ESI
  10002984  MOV dword ptr [EBP + -0x4],0xffffffff
  1000298b  CALL 0x100026b0    ; FUN_100026b0
  10002990  MOV ECX,dword ptr [EBP + -0xc]
  10002993  POP ESI
  10002994  POP EBX
  10002995  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  1000299c  MOV ESP,EBP
  1000299e  POP EBP
  1000299f  RET

;==== FUNCTION FUN_100029a0 @ 100029a0 : undefined4 FUN_100029a0(undefined4 * param_1)
  100029a0  PUSH EBP
  100029a1  MOV EBP,ESP
  100029a3  PUSH -0x1
  100029a5  PUSH 0x1000c5db    ; LAB_1000c5db
  100029aa  MOV EAX,FS:[0x0]    ; ExceptionList
  100029b0  PUSH EAX
  100029b1  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  100029b8  PUSH ECX
  100029b9  PUSH ESI
  100029ba  MOV ESI,ECX
  100029bc  PUSH 0x20
  100029be  CALL 0x100051a2    ; operator_new
  100029c3  ADD ESP,0x4
  100029c6  MOV dword ptr [EBP + -0x10],EAX
  100029c9  TEST EAX,EAX
  100029cb  MOV dword ptr [EBP + -0x4],0x0
  100029d2  JZ 0x100029e1    ; LAB_100029e1
  100029d4  MOV ECX,dword ptr [ESI + 0x4]
  100029d7  PUSH ECX
  100029d8  MOV ECX,EAX
  100029da  CALL 0x100041a0    ; FUN_100041a0
  100029df  JMP 0x100029e3    ; LAB_100029e3
LAB_100029e1:
  100029e1  XOR EAX,EAX
LAB_100029e3:
  100029e3  MOV ECX,dword ptr [ESI + 0x4]
  100029e6  PUSH EAX
  100029e7  PUSH ESI
  100029e8  MOV dword ptr [EBP + -0x4],0xffffffff
  100029ef  CALL 0x10001db0    ; FUN_10001db0
  100029f4  MOV ECX,dword ptr [EBP + -0xc]
  100029f7  XOR EAX,EAX
  100029f9  POP ESI
  100029fa  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  10002a01  MOV ESP,EBP
  10002a03  POP EBP
  10002a04  RET 0x4

;==== FUNCTION FUN_10002a10 @ 10002a10 : undefined4 FUN_10002a10(void * this, int param_1)
  10002a10  PUSH EBP
  10002a11  MOV EBP,ESP
  10002a13  MOV EAX,dword ptr [EBP + 0x8]
  10002a16  PUSH EBX
  10002a17  MOV EBX,ECX
  10002a19  PUSH ESI
  10002a1a  MOV ECX,dword ptr [EAX + 0x8]
  10002a1d  XOR ESI,ESI
  10002a1f  MOV dword ptr [0x1000f5e0],ECX    ; DAT_1000f5e0
  10002a25  MOV EAX,dword ptr [EBX + 0x198]
  10002a2b  TEST EAX,EAX
  10002a2d  JLE 0x10002a58    ; LAB_10002a58
  10002a2f  PUSH EDI
  10002a30  LEA EDI,[EBX + 0x8]
LAB_10002a33:
  10002a33  MOV EDX,dword ptr [EBP + 0x8]
  10002a36  MOV ECX,dword ptr [EDI]
  10002a38  MOV EAX,dword ptr [EDX + 0x8]
  10002a3b  PUSH EAX
  10002a3c  CALL 0x10001380    ; FUN_10001380
  10002a41  MOV EAX,dword ptr [EBX + 0x198]
  10002a47  INC ESI
  10002a48  ADD EDI,0x4
  10002a4b  CMP ESI,EAX
  10002a4d  JL 0x10002a33    ; LAB_10002a33
  10002a4f  POP EDI
  10002a50  POP ESI
  10002a51  XOR EAX,EAX
  10002a53  POP EBX
  10002a54  POP EBP
  10002a55  RET 0x4
LAB_10002a58:
  10002a58  POP ESI
  10002a59  XOR EAX,EAX
  10002a5b  POP EBX
  10002a5c  POP EBP
  10002a5d  RET 0x4

;==== FUNCTION FUN_10002a60 @ 10002a60 : undefined FUN_10002a60(undefined4 * param_1)
  10002a60  PUSH EBP
  10002a61  MOV EBP,ESP
  10002a63  MOV EAX,dword ptr [EBP + 0x8]
  10002a66  PUSH EAX
  10002a67  MOV ECX,dword ptr [EAX]
  10002a69  CALL 0x100029a0    ; FUN_100029a0
  10002a6e  POP EBP
  10002a6f  RET

;==== FUNCTION FUN_10002a70 @ 10002a70 : undefined FUN_10002a70(undefined4 * param_1)
  10002a70  PUSH EBP
  10002a71  MOV EBP,ESP
  10002a73  MOV EAX,dword ptr [EBP + 0x8]
  10002a76  PUSH EAX
  10002a77  MOV ECX,dword ptr [EAX]
  10002a79  CALL 0x10002a10    ; FUN_10002a10
  10002a7e  POP EBP
  10002a7f  RET

;==== FUNCTION FUN_10002a80 @ 10002a80 : undefined4 * FUN_10002a80(void * this, undefined4 param_1)
  10002a80  PUSH EBP
  10002a81  MOV EBP,ESP
  10002a83  PUSH -0x1
  10002a85  PUSH 0x1000c60e    ; LAB_1000c60e
  10002a8a  MOV EAX,FS:[0x0]    ; ExceptionList
  10002a90  PUSH EAX
  10002a91  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  10002a98  PUSH ECX
  10002a99  PUSH EBX
  10002a9a  PUSH ESI
  10002a9b  PUSH EDI
  10002a9c  MOV EDI,dword ptr [EBP + 0x8]
  10002a9f  MOV ESI,ECX
  10002aa1  PUSH EDI
  10002aa2  MOV dword ptr [EBP + -0x10],ESI
  10002aa5  CALL 0x10002660    ; FUN_10002660
  10002aaa  XOR EBX,EBX
  10002aac  MOV dword ptr [ESI],0x1000d158    ; PTR_FUN_1000d158
  10002ab2  MOV byte ptr [0x1000f605],BL    ; DAT_1000f605
  10002ab8  MOV dword ptr [0x1000f5e0],EBX    ; DAT_1000f5e0
  10002abe  MOV dword ptr [0x1000f5cc],EDI    ; DAT_1000f5cc
  10002ac4  MOV dword ptr [0x1000f5e4],ESI    ; DAT_1000f5e4
  10002aca  MOV EDX,dword ptr [ESI + 0x4]
  10002acd  MOV dword ptr [ESI + 0x1bc],EBX
  10002ad3  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10002ad9  PUSH EBX
  10002ada  MOV EDX,dword ptr [EDX + 0xc0]
  10002ae0  PUSH EBX
  10002ae1  MOV EAX,dword ptr [ECX]
  10002ae3  PUSH EDX
  10002ae4  MOV dword ptr [EBP + -0x4],EBX
  10002ae7  CALL dword ptr [EAX + 0x40]
  10002aea  MOV dword ptr [ESI + 0x8],EBX
  10002aed  MOV dword ptr [ESI + 0x1a4],0x2
  10002af7  MOV EAX,[0x1000f608]    ; DAT_1000f608
  10002afc  PUSH 0x3c
  10002afe  MOV [0x1000f5dc],EAX    ; DAT_1000f5dc
  10002b03  CALL 0x100051a2    ; operator_new
  10002b08  ADD ESP,0x4
  10002b0b  MOV dword ptr [EBP + 0x8],EAX
  10002b0e  CMP EAX,EBX
  10002b10  MOV byte ptr [EBP + -0x4],0x1
  10002b14  JZ 0x10002b20    ; LAB_10002b20
  10002b16  PUSH ESI
  10002b17  MOV ECX,EAX
  10002b19  CALL 0x10001f50    ; FUN_10001f50
  10002b1e  JMP 0x10002b22    ; LAB_10002b22
LAB_10002b20:
  10002b20  XOR EAX,EAX
LAB_10002b22:
  10002b22  MOV dword ptr [ESI + 0xc],EAX
  10002b25  MOV dword ptr [ESI + 0x1a0],EBX
  10002b2b  MOV ECX,dword ptr [EAX]
  10002b2d  MOV byte ptr [EBP + -0x4],BL
  10002b30  LEA EDX,[ECX + ECX*0x1 + 0x4]
  10002b34  TEST EDX,EDX
  10002b36  JLE 0x10002bc5    ; LAB_10002bc5
LAB_10002b3c:
  10002b3c  MOV EAX,dword ptr [ESI + 0xc]
  10002b3f  MOV ECX,dword ptr [EAX]
  10002b41  MOV EAX,0x55555556
  10002b46  LEA EDX,[ECX + ECX*0x1 + 0x4]
  10002b4a  IMUL EDX
  10002b4c  MOV EAX,EDX
  10002b4e  SHR EAX,0x1f
  10002b51  ADD EDX,EAX
  10002b53  MOV EAX,dword ptr [ESI + 0x1a0]
  10002b59  CMP EAX,EDX
  10002b5b  JGE 0x10002b62    ; LAB_10002b62
  10002b5d  LEA EDI,[ECX + 0x1]
  10002b60  JMP 0x10002b77    ; LAB_10002b77
LAB_10002b62:
  10002b62  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  10002b68  MOV EDX,dword ptr [ECX]
  10002b6a  CALL dword ptr [EDX + 0x8]
  10002b6d  MOV ECX,dword ptr [ESI + 0xc]
  10002b70  XOR EDX,EDX
  10002b72  DIV dword ptr [ECX]
  10002b74  MOV EDI,EDX
  10002b76  INC EDI
LAB_10002b77:
  10002b77  PUSH 0x38
  10002b79  CALL 0x100051a2    ; operator_new
  10002b7e  ADD ESP,0x4
  10002b81  MOV dword ptr [EBP + 0x8],EAX
  10002b84  CMP EAX,EBX
  10002b86  MOV byte ptr [EBP + -0x4],0x2
  10002b8a  JZ 0x10002b96    ; LAB_10002b96
  10002b8c  PUSH EDI
  10002b8d  MOV ECX,EAX
  10002b8f  CALL 0x100011a0    ; FUN_100011a0
  10002b94  JMP 0x10002b98    ; LAB_10002b98
LAB_10002b96:
  10002b96  XOR EAX,EAX
LAB_10002b98:
  10002b98  MOV EDX,dword ptr [ESI + 0x1a0]
  10002b9e  MOV byte ptr [EBP + -0x4],BL
  10002ba1  MOV dword ptr [ESI + EDX*0x4 + 0x10],EAX
  10002ba5  MOV EDI,dword ptr [ESI + 0x1a0]
  10002bab  MOV ECX,dword ptr [ESI + 0xc]
  10002bae  INC EDI
  10002baf  MOV dword ptr [ESI + 0x1a0],EDI
  10002bb5  MOV EAX,EDI
  10002bb7  MOV EDX,dword ptr [ECX]
  10002bb9  LEA ECX,[EDX + EDX*0x1 + 0x4]
  10002bbd  CMP EAX,ECX
  10002bbf  JL 0x10002b3c    ; LAB_10002b3c
LAB_10002bc5:
  10002bc5  MOV byte ptr [ESI + 0x1c0],BL
  10002bcb  MOV byte ptr [ESI + 0x1c1],BL
  10002bd1  MOV byte ptr [ESI + 0x1c2],BL
  10002bd7  MOV byte ptr [ESI + 0x1c3],BL
  10002bdd  MOV dword ptr [ESI + 0x1c4],EBX
  10002be3  MOV dword ptr [ESI + 0x1c8],EBX
  10002be9  MOV dword ptr [ESI + 0x1cc],EBX
  10002bef  MOV dword ptr [ESI + 0x1d0],EBX
  10002bf5  MOV dword ptr [ESI + 0x1e4],EBX
  10002bfb  MOV dword ptr [ESI + 0x1e0],EBX
  10002c01  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10002c07  MOV EAX,[0x1000f5c8]    ; DAT_1000f5c8
  10002c0c  PUSH 0x100031f0    ; FUN_100031f0
  10002c11  PUSH ESI
  10002c12  MOV EDX,dword ptr [ECX]
  10002c14  PUSH 0xb
  10002c16  PUSH EAX
  10002c17  CALL dword ptr [EDX + 0x44]
  10002c1a  MOV dword ptr [ESI + 0x1b4],EAX
  10002c20  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10002c26  PUSH 0x100031e0    ; FUN_100031e0
  10002c2b  PUSH 0x14
  10002c2d  MOV EDX,dword ptr [ECX]
  10002c2f  PUSH ESI
  10002c30  CALL dword ptr [EDX + 0x34]
  10002c33  MOV dword ptr [ESI + 0x1b0],EAX
  10002c39  MOV EDX,dword ptr [EAX]
  10002c3b  MOV ECX,EAX
  10002c3d  CALL dword ptr [EDX + 0x8]
  10002c40  MOV ECX,ESI
  10002c42  CALL 0x10003a60    ; FUN_10003a60
  10002c47  MOV ECX,ESI
  10002c49  CALL 0x10003ad0    ; FUN_10003ad0
  10002c4e  MOV ECX,ESI
  10002c50  CALL 0x10003bc0    ; FUN_10003bc0
  10002c55  MOV byte ptr [ESI + 0x1ad],BL
  10002c5b  MOV byte ptr [ESI + 0x1ae],BL
  10002c61  MOV byte ptr [ESI + 0x1ac],BL
  10002c67  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  10002c6d  MOV EAX,dword ptr [ECX]
  10002c6f  CALL dword ptr [EAX + 0x8]
  10002c72  XOR EDX,EDX
  10002c74  MOV ECX,0xfa0
  10002c79  DIV ECX
  10002c7b  MOV dword ptr [ESI + 0x1d8],EBX
  10002c81  MOV dword ptr [ESI + 0x1dc],EBX
  10002c87  PUSH 0x1
  10002c89  ADD EDX,0xbb8
  10002c8f  MOV dword ptr [ESI + 0x1a8],EDX
  10002c95  MOV ECX,dword ptr [0x1000f5c8]    ; DAT_1000f5c8
  10002c9b  MOV EDX,dword ptr [ECX]
  10002c9d  CALL dword ptr [EDX + 0xc]
  10002ca0  MOV ECX,dword ptr [EBP + -0xc]
  10002ca3  MOV EAX,ESI
  10002ca5  POP EDI
  10002ca6  POP ESI
  10002ca7  POP EBX
  10002ca8  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  10002caf  MOV ESP,EBP
  10002cb1  POP EBP
  10002cb2  RET 0x8

;==== FUNCTION FUN_10002cc0 @ 10002cc0 : undefined4 * FUN_10002cc0(void * this, byte param_1)
  10002cc0  PUSH EBP
  10002cc1  MOV EBP,ESP
  10002cc3  PUSH ESI
  10002cc4  MOV ESI,ECX
  10002cc6  CALL 0x10002cf0    ; FUN_10002cf0
  10002ccb  TEST byte ptr [EBP + 0x8],0x1
  10002ccf  JZ 0x10002cda    ; LAB_10002cda
  10002cd1  PUSH ESI
  10002cd2  CALL 0x10005197    ; FUN_10005197
  10002cd7  ADD ESP,0x4
LAB_10002cda:
  10002cda  MOV EAX,ESI
  10002cdc  POP ESI
  10002cdd  POP EBP
  10002cde  RET 0x4

;==== FUNCTION FUN_10002cf0 @ 10002cf0 : undefined FUN_10002cf0(undefined4 * param_1)
  10002cf0  PUSH EBP
  10002cf1  MOV EBP,ESP
  10002cf3  PUSH -0x1
  10002cf5  PUSH 0x1000c628    ; LAB_1000c628
  10002cfa  MOV EAX,FS:[0x0]    ; ExceptionList
  10002d00  PUSH EAX
  10002d01  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  10002d08  SUB ESP,0x8
  10002d0b  PUSH EBX
  10002d0c  PUSH ESI
  10002d0d  MOV ESI,ECX
  10002d0f  PUSH EDI
  10002d10  MOV dword ptr [EBP + -0x14],ESI
  10002d13  MOV dword ptr [ESI],0x1000d158    ; PTR_FUN_1000d158
  10002d19  MOV ECX,dword ptr [ESI + 0x1b0]
  10002d1f  XOR EBX,EBX
  10002d21  MOV dword ptr [EBP + -0x4],EBX
  10002d24  MOV EAX,dword ptr [ECX]
  10002d26  CALL dword ptr [EAX + 0x4]
  10002d29  CMP dword ptr [ESI + 0x1a0],EBX
  10002d2f  JLE 0x10002d64    ; LAB_10002d64
  10002d31  LEA ECX,[ESI + 0x10]
  10002d34  MOV dword ptr [EBP + -0x10],ECX
LAB_10002d37:
  10002d37  MOV EDX,dword ptr [EBP + -0x10]
  10002d3a  MOV EDI,dword ptr [EDX]
  10002d3c  TEST EDI,EDI
  10002d3e  JZ 0x10002d50    ; LAB_10002d50
  10002d40  MOV ECX,EDI
  10002d42  CALL 0x10001340    ; FUN_10001340
  10002d47  PUSH EDI
  10002d48  CALL 0x10005197    ; FUN_10005197
  10002d4d  ADD ESP,0x4
LAB_10002d50:
  10002d50  MOV ECX,dword ptr [EBP + -0x10]
  10002d53  MOV EAX,dword ptr [ESI + 0x1a0]
  10002d59  INC EBX
  10002d5a  ADD ECX,0x4
  10002d5d  CMP EBX,EAX
  10002d5f  MOV dword ptr [EBP + -0x10],ECX
  10002d62  JL 0x10002d37    ; LAB_10002d37
LAB_10002d64:
  10002d64  MOV EDI,dword ptr [ESI + 0xc]
  10002d67  TEST EDI,EDI
  10002d69  JZ 0x10002d7b    ; LAB_10002d7b
  10002d6b  MOV ECX,EDI
  10002d6d  CALL 0x10002010    ; FUN_10002010
  10002d72  PUSH EDI
  10002d73  CALL 0x10005197    ; FUN_10005197
  10002d78  ADD ESP,0x4
LAB_10002d7b:
  10002d7b  MOV ECX,dword ptr [ESI + 0x1d8]
  10002d81  TEST ECX,ECX
  10002d83  JZ 0x10002d8a    ; LAB_10002d8a
  10002d85  MOV EAX,dword ptr [ECX]
  10002d87  CALL dword ptr [EAX + 0x4]
LAB_10002d8a:
  10002d8a  MOV EAX,dword ptr [ESI + 0x1e0]
  10002d90  TEST EAX,EAX
  10002d92  JZ 0x10002dab    ; LAB_10002dab
  10002d94  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  10002d9a  PUSH EAX
  10002d9b  MOV EDX,dword ptr [ECX]
  10002d9d  CALL dword ptr [EDX + 0x1c]
  10002da0  MOV ECX,dword ptr [ESI + 0x1e0]
  10002da6  MOV EAX,dword ptr [ECX]
  10002da8  CALL dword ptr [EAX + 0x4]
LAB_10002dab:
  10002dab  MOV EAX,dword ptr [ESI + 0x1e4]
  10002db1  TEST EAX,EAX
  10002db3  JZ 0x10002dcc    ; LAB_10002dcc
  10002db5  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  10002dbb  PUSH EAX
  10002dbc  MOV EDX,dword ptr [ECX]
  10002dbe  CALL dword ptr [EDX + 0x1c]
  10002dc1  MOV ECX,dword ptr [ESI + 0x1e4]
  10002dc7  MOV EAX,dword ptr [ECX]
  10002dc9  CALL dword ptr [EAX + 0x4]
LAB_10002dcc:
  10002dcc  MOV EAX,dword ptr [ESI + 0x1dc]
  10002dd2  TEST EAX,EAX
  10002dd4  JZ 0x10002ded    ; LAB_10002ded
  10002dd6  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  10002ddc  PUSH EAX
  10002ddd  MOV EDX,dword ptr [ECX]
  10002ddf  CALL dword ptr [EDX + 0x1c]
  10002de2  MOV ECX,dword ptr [ESI + 0x1dc]
  10002de8  MOV EAX,dword ptr [ECX]
  10002dea  CALL dword ptr [EAX + 0x4]
LAB_10002ded:
  10002ded  MOV ECX,dword ptr [ESI + 0x1b4]
  10002df3  MOV EDX,dword ptr [ECX]
  10002df5  CALL dword ptr [EDX + 0x4]
  10002df8  MOV ECX,ESI
  10002dfa  MOV dword ptr [EBP + -0x4],0xffffffff
  10002e01  CALL 0x100026b0    ; FUN_100026b0
  10002e06  MOV ECX,dword ptr [EBP + -0xc]
  10002e09  POP EDI
  10002e0a  POP ESI
  10002e0b  POP EBX
  10002e0c  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  10002e13  MOV ESP,EBP
  10002e15  POP EBP
  10002e16  RET

;==== FUNCTION FUN_10002e20 @ 10002e20 : undefined4 FUN_10002e20(void * this, int param_1)
  10002e20  PUSH EBP
  10002e21  MOV EBP,ESP
  10002e23  SUB ESP,0xc
  10002e26  MOV EAX,dword ptr [ECX + 0x1bc]
  10002e2c  DEC EAX
  10002e2d  JZ 0x10002e4a    ; LAB_10002e4a
  10002e2f  DEC EAX
  10002e30  JNZ 0x10002e91    ; LAB_10002e91
  10002e32  MOV EAX,dword ptr [EBP + 0x8]
  10002e35  CMP dword ptr [EAX + 0x8],0x20
  10002e39  JNZ 0x10002e91    ; LAB_10002e91
  10002e3b  PUSH 0x0
  10002e3d  CALL 0x10004000    ; FUN_10004000
  10002e42  XOR EAX,EAX
  10002e44  MOV ESP,EBP
  10002e46  POP EBP
  10002e47  RET 0x4
LAB_10002e4a:
  10002e4a  MOV EDX,dword ptr [EBP + 0x8]
  10002e4d  MOV EAX,dword ptr [EDX + 0x8]
  10002e50  CMP EAX,0x59
  10002e53  JZ 0x10002e80    ; LAB_10002e80
  10002e55  CMP EAX,0x79
  10002e58  JZ 0x10002e80    ; LAB_10002e80
  10002e5a  CMP EAX,0x4e
  10002e5d  JZ 0x10002e64    ; LAB_10002e64
  10002e5f  CMP EAX,0x6e
  10002e62  JNZ 0x10002e91    ; LAB_10002e91
LAB_10002e64:
  10002e64  MOV EAX,0x1
  10002e69  MOV dword ptr [EBP + -0x4],EAX
  10002e6c  MOV dword ptr [EBP + -0x8],EAX
  10002e6f  LEA EAX,[EBP + -0xc]
  10002e72  PUSH EAX
  10002e73  CALL 0x10003f60    ; FUN_10003f60
  10002e78  XOR EAX,EAX
  10002e7a  MOV ESP,EBP
  10002e7c  POP EBP
  10002e7d  RET 0x4
LAB_10002e80:
  10002e80  LEA EDX,[EBP + -0xc]
  10002e83  XOR EAX,EAX
  10002e85  PUSH EDX
  10002e86  MOV dword ptr [EBP + -0x4],EAX
  10002e89  MOV dword ptr [EBP + -0x8],EAX
  10002e8c  CALL 0x10003f60    ; FUN_10003f60
LAB_10002e91:
  10002e91  XOR EAX,EAX
  10002e93  MOV ESP,EBP
  10002e95  POP EBP
  10002e96  RET 0x4

;==== FUNCTION FUN_10002ea0 @ 10002ea0 : undefined4 FUN_10002ea0(void * this, int param_1)
  10002ea0  PUSH EBP
  10002ea1  MOV EBP,ESP
  10002ea3  PUSH ECX
  10002ea4  MOV EAX,dword ptr [EBP + 0x8]
  10002ea7  PUSH EBX
  10002ea8  PUSH ESI
  10002ea9  MOV ESI,ECX
  10002eab  MOV EAX,dword ptr [EAX + 0x8]
  10002eae  MOV dword ptr [ESI + 0x1d4],EAX
  10002eb4  MOV [0x1000f5e0],EAX    ; DAT_1000f5e0
  10002eb9  MOV AL,[0x1000f5ec]    ; DAT_1000f5ec
  10002ebe  TEST AL,AL
  10002ec0  JZ 0x10002ff6    ; LAB_10002ff6
  10002ec6  MOV AL,byte ptr [ESI + 0x1ac]
  10002ecc  TEST AL,AL
  10002ece  MOV EAX,[0x1000f5f8]    ; DAT_1000f5f8
  10002ed3  JNZ 0x10002f29    ; LAB_10002f29
  10002ed5  MOV ECX,dword ptr [ESI + 0x1d4]
  10002edb  SUB ECX,EAX
  10002edd  CMP ECX,0x3e8
  10002ee3  JBE 0x10002f29    ; LAB_10002f29
  10002ee5  MOV AL,byte ptr [ESI + 0x1ad]
  10002eeb  TEST AL,AL
  10002eed  JZ 0x10002f07    ; LAB_10002f07
  10002eef  MOV ECX,ESI
  10002ef1  CALL 0x10003d80    ; FUN_10003d80
  10002ef6  MOV byte ptr [ESI + 0x1ac],0x1
  10002efd  POP ESI
  10002efe  XOR EAX,EAX
  10002f00  POP EBX
  10002f01  MOV ESP,EBP
  10002f03  POP EBP
  10002f04  RET 0x4
LAB_10002f07:
  10002f07  MOV AL,byte ptr [ESI + 0x1ae]
  10002f0d  TEST AL,AL
  10002f0f  JZ 0x10002f18    ; LAB_10002f18
  10002f11  MOV ECX,ESI
  10002f13  CALL 0x10003e70    ; FUN_10003e70
LAB_10002f18:
  10002f18  MOV byte ptr [ESI + 0x1ac],0x1
  10002f1f  POP ESI
  10002f20  XOR EAX,EAX
  10002f22  POP EBX
  10002f23  MOV ESP,EBP
  10002f25  POP EBP
  10002f26  RET 0x4
LAB_10002f29:
  10002f29  MOV EDX,dword ptr [ESI + 0x1d4]
  10002f2f  SUB EDX,EAX
  10002f31  CMP EDX,0x7d0
  10002f37  JBE 0x10002f67    ; LAB_10002f67
  10002f39  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  10002f3f  MOV EDX,dword ptr [0x1000f5e8]    ; DAT_1000f5e8
  10002f45  PUSH EDX
  10002f46  MOV EAX,dword ptr [ECX]
  10002f48  CALL dword ptr [EAX + 0x1c]
  10002f4b  MOV ECX,dword ptr [0x1000f5e8]    ; DAT_1000f5e8
  10002f51  MOV EAX,dword ptr [ECX]
  10002f53  CALL dword ptr [EAX + 0x4]
  10002f56  POP ESI
  10002f57  MOV byte ptr [0x1000f5ec],0x0    ; DAT_1000f5ec
  10002f5e  XOR EAX,EAX
  10002f60  POP EBX
  10002f61  MOV ESP,EBP
  10002f63  POP EBP
  10002f64  RET 0x4
LAB_10002f67:
  10002f67  MOV EAX,[0x1000f5f4]    ; DAT_1000f5f4
  10002f6c  CDQ
  10002f6d  XOR EAX,EDX
  10002f6f  SUB EAX,EDX
  10002f71  CMP EAX,0x5
  10002f74  MOV EAX,[0x1000f5fc]    ; DAT_1000f5fc
  10002f79  JLE 0x10002f82    ; LAB_10002f82
  10002f7b  NEG EAX
  10002f7d  MOV [0x1000f5fc],EAX    ; DAT_1000f5fc
LAB_10002f82:
  10002f82  MOV EBX,dword ptr [0x1000f5f4]    ; DAT_1000f5f4
  10002f88  MOV ECX,dword ptr [0x1000f5e8]    ; DAT_1000f5e8
  10002f8e  ADD EBX,EAX
  10002f90  LEA EAX,[EBP + -0x4]
  10002f93  PUSH EAX
  10002f94  MOV dword ptr [0x1000f5f4],EBX    ; DAT_1000f5f4
  10002f9a  MOV EDX,dword ptr [ECX]
  10002f9c  LEA EAX,[EBP + 0x8]
  10002f9f  PUSH EAX
  10002fa0  CALL dword ptr [EDX + 0xc]
  10002fa3  CALL 0x10005639    ; FUN_10005639
  10002fa8  CDQ
  10002fa9  MOV ECX,0x3
  10002fae  IDIV ECX
  10002fb0  CMP EDX,0x1
  10002fb3  JNZ 0x10002fb8    ; LAB_10002fb8
  10002fb5  INC dword ptr [EBP + 0x8]
LAB_10002fb8:
  10002fb8  MOV EAX,[0x1000f5fc]    ; DAT_1000f5fc
  10002fbd  MOV ECX,dword ptr [0x1000f5e8]    ; DAT_1000f5e8
  10002fc3  TEST EAX,EAX
  10002fc5  MOV EDX,dword ptr [ECX]
  10002fc7  MOV EAX,dword ptr [EBP + -0x4]
  10002fca  PUSH 0x0
  10002fcc  JGE 0x10002fe2    ; LAB_10002fe2
  10002fce  DEC EAX
  10002fcf  PUSH EAX
  10002fd0  MOV EAX,dword ptr [EBP + 0x8]
  10002fd3  DEC EAX
  10002fd4  PUSH EAX
  10002fd5  CALL dword ptr [EDX + 0x8]
  10002fd8  POP ESI
  10002fd9  XOR EAX,EAX
  10002fdb  POP EBX
  10002fdc  MOV ESP,EBP
  10002fde  POP EBP
  10002fdf  RET 0x4
LAB_10002fe2:
  10002fe2  DEC EAX
  10002fe3  PUSH EAX
  10002fe4  MOV EAX,dword ptr [EBP + 0x8]
  10002fe7  INC EAX
  10002fe8  PUSH EAX
  10002fe9  CALL dword ptr [EDX + 0x8]
  10002fec  POP ESI
  10002fed  XOR EAX,EAX
  10002fef  POP EBX
  10002ff0  MOV ESP,EBP
  10002ff2  POP EBP
  10002ff3  RET 0x4
LAB_10002ff6:
  10002ff6  MOV EAX,dword ptr [ESI + 0x1bc]
  10002ffc  TEST EAX,EAX
  10002ffe  JZ 0x1000300a    ; LAB_1000300a
  10003000  POP ESI
  10003001  XOR EAX,EAX
  10003003  POP EBX
  10003004  MOV ESP,EBP
  10003006  POP EBP
  10003007  RET 0x4
LAB_1000300a:
  1000300a  MOV ECX,dword ptr [ESI + 0x1d4]
  10003010  MOV EAX,dword ptr [ESI + 0x1a8]
  10003016  CMP ECX,EAX
  10003018  JBE 0x10003055    ; LAB_10003055
  1000301a  MOV EDX,dword ptr [0x1000f5cc]    ; DAT_1000f5cc
  10003020  PUSH 0x0
  10003022  MOV ECX,dword ptr [EDX + 0xec]
  10003028  MOV EAX,dword ptr [ECX]
  1000302a  CALL dword ptr [EAX + 0x8]
  1000302d  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  10003033  MOV EDX,dword ptr [ECX]
  10003035  CALL dword ptr [EDX + 0x8]
  10003038  XOR EDX,EDX
  1000303a  MOV ECX,0xfa0
  1000303f  DIV ECX
  10003041  MOV EAX,dword ptr [ESI + 0x1a8]
  10003047  ADD EDX,0x1388
  1000304d  ADD EAX,EDX
  1000304f  MOV dword ptr [ESI + 0x1a8],EAX
LAB_10003055:
  10003055  MOV ECX,ESI
  10003057  CALL 0x10003460    ; FUN_10003460
  1000305c  TEST AL,AL
  1000305e  JZ 0x100030de    ; LAB_100030de
  10003060  MOV AL,[0x1000f604]    ; DAT_1000f604
  10003065  TEST AL,AL
  10003067  JNZ 0x100030de    ; LAB_100030de
  10003069  MOV ECX,dword ptr [ESI + 0x1a4]
  1000306f  DEC ECX
  10003070  MOV EAX,ECX
  10003072  MOV dword ptr [ESI + 0x1a4],ECX
  10003078  CMP EAX,-0x1
  1000307b  JLE 0x100030a8    ; LAB_100030a8
  1000307d  MOV EDX,dword ptr [0x1000f5cc]    ; DAT_1000f5cc
  10003083  PUSH 0x0
  10003085  MOV ECX,dword ptr [EDX + 0xd8]
  1000308b  MOV EAX,dword ptr [ECX]
  1000308d  CALL dword ptr [EAX + 0x8]
  10003090  MOV ECX,ESI
  10003092  MOV byte ptr [ESI + 0x1ad],0x1
  10003099  CALL 0x10003130    ; FUN_10003130
  1000309e  POP ESI
  1000309f  XOR EAX,EAX
  100030a1  POP EBX
  100030a2  MOV ESP,EBP
  100030a4  POP EBP
  100030a5  RET 0x4
LAB_100030a8:
  100030a8  MOV ECX,ESI
  100030aa  CALL 0x100037d0    ; FUN_100037d0
  100030af  TEST AL,AL
  100030b1  JNZ 0x100030c6    ; LAB_100030c6
  100030b3  MOV ECX,dword ptr [0x1000f5cc]    ; DAT_1000f5cc
  100030b9  PUSH 0x0
  100030bb  MOV ECX,dword ptr [ECX + 0xcc]
  100030c1  MOV EDX,dword ptr [ECX]
  100030c3  CALL dword ptr [EDX + 0x8]
LAB_100030c6:
  100030c6  MOV ECX,ESI
  100030c8  MOV byte ptr [ESI + 0x1ae],0x1
  100030cf  CALL 0x10003130    ; FUN_10003130
  100030d4  POP ESI
  100030d5  XOR EAX,EAX
  100030d7  POP EBX
  100030d8  MOV ESP,EBP
  100030da  POP EBP
  100030db  RET 0x4
LAB_100030de:
  100030de  PUSH EDI
  100030df  MOV ECX,ESI
  100030e1  CALL 0x10003200    ; FUN_10003200
  100030e6  MOV ECX,dword ptr [ESI + 0xc]
  100030e9  CALL 0x10002330    ; FUN_10002330
  100030ee  MOV EAX,dword ptr [ESI + 0x1a0]
  100030f4  XOR EDI,EDI
  100030f6  TEST EAX,EAX
  100030f8  JLE 0x10003119    ; LAB_10003119
  100030fa  LEA EBX,[ESI + 0x10]
LAB_100030fd:
  100030fd  MOV EAX,dword ptr [ESI + 0x1d4]
  10003103  MOV ECX,dword ptr [EBX]
  10003105  PUSH EAX
  10003106  CALL 0x10001380    ; FUN_10001380
  1000310b  MOV EAX,dword ptr [ESI + 0x1a0]
  10003111  INC EDI
  10003112  ADD EBX,0x4
  10003115  CMP EDI,EAX
  10003117  JL 0x100030fd    ; LAB_100030fd
LAB_10003119:
  10003119  POP EDI
  1000311a  POP ESI
  1000311b  XOR EAX,EAX
  1000311d  POP EBX
  1000311e  MOV ESP,EBP
  10003120  POP EBP
  10003121  RET 0x4

;==== FUNCTION FUN_10003130 @ 10003130 : undefined FUN_10003130(int param_1)
  10003130  PUSH EBX
  10003131  PUSH ESI
  10003132  MOV ESI,ECX
  10003134  MOV EAX,0x1
  10003139  XOR EBX,EBX
  1000313b  MOV [0x1000f5ec],AL    ; DAT_1000f5ec
  10003140  MOV ECX,dword ptr [ESI + 0x1d4]
  10003146  MOV byte ptr [ESI + 0x1ac],BL
  1000314c  MOV [0x1000f5fc],EAX    ; DAT_1000f5fc
  10003151  MOV EAX,[0x1000f5cc]    ; DAT_1000f5cc
  10003156  MOV dword ptr [0x1000f5f8],ECX    ; DAT_1000f5f8
  1000315c  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10003162  MOV dword ptr [0x1000f5f4],EBX    ; DAT_1000f5f4
  10003168  MOV EAX,dword ptr [EAX + 0xc4]
  1000316e  MOV EDX,dword ptr [ECX]
  10003170  PUSH EDI
  10003171  PUSH EBX
  10003172  PUSH EAX
  10003173  CALL dword ptr [EDX + 0x8]
  10003176  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  1000317c  MOV [0x1000f5e8],EAX    ; DAT_1000f5e8
  10003181  PUSH EAX
  10003182  MOV EDX,dword ptr [ECX]
  10003184  CALL dword ptr [EDX + 0x18]
  10003187  MOV ECX,dword ptr [0x1000f5e8]    ; DAT_1000f5e8
  1000318d  MOV EAX,dword ptr [ECX]
  1000318f  CALL dword ptr [EAX + 0x2c]
  10003192  MOV ESI,dword ptr [ESI + 0xc]
  10003195  MOV ECX,dword ptr [0x1000f5e8]    ; DAT_1000f5e8
  1000319b  PUSH EBX
  1000319c  MOV EAX,dword ptr [ESI + 0x24]
  1000319f  MOV EDI,dword ptr [ECX]
  100031a1  FLD float ptr [ESI + 0x14]
  100031a4  CDQ
  100031a5  SUB EAX,EDX
  100031a7  MOV EBX,EAX
  100031a9  SAR EBX,0x1
  100031ab  CALL 0x10005110    ; __ftol
  100031b0  SUB EAX,EBX
  100031b2  PUSH EAX
  100031b3  MOV EAX,dword ptr [ESI + 0x20]
  100031b6  FLD float ptr [ESI + 0x10]
  100031b9  CDQ
  100031ba  SUB EAX,EDX
  100031bc  MOV EBX,EAX
  100031be  SAR EBX,0x1
  100031c0  CALL 0x10005110    ; __ftol
  100031c5  MOV ECX,dword ptr [0x1000f5e8]    ; DAT_1000f5e8
  100031cb  SUB EAX,EBX
  100031cd  PUSH EAX
  100031ce  CALL dword ptr [EDI + 0x8]
  100031d1  POP EDI
  100031d2  POP ESI
  100031d3  POP EBX
  100031d4  RET

;==== FUNCTION FUN_100031e0 @ 100031e0 : undefined FUN_100031e0(undefined4 * param_1)
  100031e0  PUSH EBP
  100031e1  MOV EBP,ESP
  100031e3  MOV EAX,dword ptr [EBP + 0x8]
  100031e6  PUSH EAX
  100031e7  MOV ECX,dword ptr [EAX]
  100031e9  CALL 0x10002ea0    ; FUN_10002ea0
  100031ee  POP EBP
  100031ef  RET

;==== FUNCTION FUN_100031f0 @ 100031f0 : undefined FUN_100031f0(undefined4 * param_1)
  100031f0  PUSH EBP
  100031f1  MOV EBP,ESP
  100031f3  MOV EAX,dword ptr [EBP + 0x8]
  100031f6  PUSH EAX
  100031f7  MOV ECX,dword ptr [EAX]
  100031f9  CALL 0x10002e20    ; FUN_10002e20
  100031fe  POP EBP
  100031ff  RET

;==== FUNCTION FUN_10003200 @ 10003200 : undefined FUN_10003200(int param_1)
  10003200  PUSH EBX
  10003201  PUSH ESI
  10003202  MOV ESI,ECX
  10003204  MOV EBX,0x1
  10003209  MOV ECX,dword ptr [0x1000f5c8]    ; DAT_1000f5c8
  1000320f  MOV AL,byte ptr [ESI + 0x1c0]
  10003215  TEST AL,AL
  10003217  JZ 0x1000325c    ; LAB_1000325c
  10003219  MOV EAX,dword ptr [ECX]
  1000321b  PUSH 0x7
  1000321d  CALL dword ptr [EAX + 0x20]
  10003220  TEST AL,0x80
  10003222  JZ 0x1000324c    ; LAB_1000324c
  10003224  MOV ECX,dword ptr [ESI + 0x1d4]
  1000322a  MOV EDX,dword ptr [ESI + 0x1c4]
  10003230  SUB ECX,EDX
  10003232  CMP ECX,0xa
  10003235  JBE 0x1000328f    ; LAB_1000328f
  10003237  TEST byte ptr [0x1000f5f0],0x2    ; DAT_1000f5f0
  1000323e  JZ 0x1000328f    ; LAB_1000328f
  10003240  MOV ECX,dword ptr [ESI + 0xc]
  10003243  PUSH 0x2
  10003245  CALL 0x10002110    ; FUN_10002110
  1000324a  JMP 0x1000328f    ; LAB_1000328f
LAB_1000324c:
  1000324c  MOV byte ptr [ESI + 0x1c0],0x0
  10003253  MOV EAX,[0x1000f5f0]    ; DAT_1000f5f0
  10003258  AND AL,0xfd
  1000325a  JMP 0x1000328a    ; LAB_1000328a
LAB_1000325c:
  1000325c  MOV EDX,dword ptr [ECX]
  1000325e  PUSH 0x7
  10003260  CALL dword ptr [EDX + 0x20]
  10003263  TEST AL,0x80
  10003265  JZ 0x1000328f    ; LAB_1000328f
  10003267  MOV EAX,dword ptr [ESI + 0x1d4]
  1000326d  MOV ECX,dword ptr [ESI + 0xc]
  10003270  PUSH 0x2
  10003272  MOV dword ptr [ESI + 0x1c4],EAX
  10003278  MOV byte ptr [ESI + 0x1c0],BL
  1000327e  CALL 0x10002110    ; FUN_10002110
  10003283  MOV EAX,[0x1000f5f0]    ; DAT_1000f5f0
  10003288  OR AL,0x2
LAB_1000328a:
  1000328a  MOV [0x1000f5f0],EAX    ; DAT_1000f5f0
LAB_1000328f:
  1000328f  MOV AL,byte ptr [ESI + 0x1c1]
  10003295  MOV ECX,dword ptr [0x1000f5c8]    ; DAT_1000f5c8
  1000329b  TEST AL,AL
  1000329d  MOV EDX,dword ptr [ECX]
  1000329f  PUSH 0x6
  100032a1  JZ 0x100032e0    ; LAB_100032e0
  100032a3  CALL dword ptr [EDX + 0x20]
  100032a6  TEST AL,0x80
  100032a8  JZ 0x100032d0    ; LAB_100032d0
  100032aa  MOV EAX,dword ptr [ESI + 0x1d4]
  100032b0  MOV EDX,dword ptr [ESI + 0x1c8]
  100032b6  SUB EAX,EDX
  100032b8  CMP EAX,0xa
  100032bb  JBE 0x1000330e    ; LAB_1000330e
  100032bd  TEST byte ptr [0x1000f5f0],BL    ; DAT_1000f5f0
  100032c3  JZ 0x1000330e    ; LAB_1000330e
  100032c5  MOV ECX,dword ptr [ESI + 0xc]
  100032c8  PUSH EBX
  100032c9  CALL 0x10002110    ; FUN_10002110
  100032ce  JMP 0x1000330e    ; LAB_1000330e
LAB_100032d0:
  100032d0  MOV byte ptr [ESI + 0x1c1],0x0
  100032d7  MOV EAX,[0x1000f5f0]    ; DAT_1000f5f0
  100032dc  AND AL,0xfe
  100032de  JMP 0x10003309    ; LAB_10003309
LAB_100032e0:
  100032e0  CALL dword ptr [EDX + 0x20]
  100032e3  TEST AL,0x80
  100032e5  JZ 0x1000330e    ; LAB_1000330e
  100032e7  MOV EAX,dword ptr [ESI + 0x1d4]
  100032ed  MOV ECX,dword ptr [ESI + 0xc]
  100032f0  PUSH EBX
  100032f1  MOV dword ptr [ESI + 0x1c8],EAX
  100032f7  MOV byte ptr [ESI + 0x1c1],BL
  100032fd  CALL 0x10002110    ; FUN_10002110
  10003302  MOV EAX,[0x1000f5f0]    ; DAT_1000f5f0
  10003307  OR EAX,EBX
LAB_10003309:
  10003309  MOV [0x1000f5f0],EAX    ; DAT_1000f5f0
LAB_1000330e:
  1000330e  MOV AL,byte ptr [ESI + 0x1c2]
  10003314  MOV ECX,dword ptr [0x1000f5c8]    ; DAT_1000f5c8
  1000331a  TEST AL,AL
  1000331c  MOV EDX,dword ptr [ECX]
  1000331e  PUSH 0x8
  10003320  JZ 0x10003361    ; LAB_10003361
  10003322  CALL dword ptr [EDX + 0x20]
  10003325  TEST AL,0x80
  10003327  JZ 0x10003351    ; LAB_10003351
  10003329  MOV EAX,dword ptr [ESI + 0x1d4]
  1000332f  MOV EDX,dword ptr [ESI + 0x1cc]
  10003335  SUB EAX,EDX
  10003337  CMP EAX,0xa
  1000333a  JBE 0x10003390    ; LAB_10003390
  1000333c  TEST byte ptr [0x1000f5f0],0x4    ; DAT_1000f5f0
  10003343  JZ 0x10003390    ; LAB_10003390
  10003345  MOV ECX,dword ptr [ESI + 0xc]
  10003348  PUSH 0x3
  1000334a  CALL 0x10002110    ; FUN_10002110
  1000334f  JMP 0x10003390    ; LAB_10003390
LAB_10003351:
  10003351  MOV byte ptr [ESI + 0x1c2],0x0
  10003358  MOV EAX,[0x1000f5f0]    ; DAT_1000f5f0
  1000335d  AND AL,0xfb
  1000335f  JMP 0x1000338b    ; LAB_1000338b
LAB_10003361:
  10003361  CALL dword ptr [EDX + 0x20]
  10003364  TEST AL,0x80
  10003366  JZ 0x10003390    ; LAB_10003390
  10003368  MOV EAX,dword ptr [ESI + 0x1d4]
  1000336e  MOV ECX,dword ptr [ESI + 0xc]
  10003371  PUSH 0x3
  10003373  MOV dword ptr [ESI + 0x1cc],EAX
  10003379  MOV byte ptr [ESI + 0x1c2],BL
  1000337f  CALL 0x10002110    ; FUN_10002110
  10003384  MOV EAX,[0x1000f5f0]    ; DAT_1000f5f0
  10003389  OR AL,0x4
LAB_1000338b:
  1000338b  MOV [0x1000f5f0],EAX    ; DAT_1000f5f0
LAB_10003390:
  10003390  MOV AL,byte ptr [ESI + 0x1c3]
  10003396  MOV ECX,dword ptr [0x1000f5c8]    ; DAT_1000f5c8
  1000339c  TEST AL,AL
  1000339e  MOV EDX,dword ptr [ECX]
  100033a0  PUSH 0x9
  100033a2  JZ 0x100033ea    ; LAB_100033ea
  100033a4  CALL dword ptr [EDX + 0x20]
  100033a7  TEST AL,0x80
  100033a9  JZ 0x100033d4    ; LAB_100033d4
  100033ab  MOV EAX,dword ptr [ESI + 0x1d4]
  100033b1  MOV EDX,dword ptr [ESI + 0x1d0]
  100033b7  SUB EAX,EDX
  100033b9  CMP EAX,0xa
  100033bc  JBE 0x10003419    ; LAB_10003419
  100033be  TEST byte ptr [0x1000f5f0],0x8    ; DAT_1000f5f0
  100033c5  JZ 0x10003419    ; LAB_10003419
  100033c7  MOV ECX,dword ptr [ESI + 0xc]
  100033ca  PUSH 0x4
  100033cc  CALL 0x10002110    ; FUN_10002110
  100033d1  POP ESI
  100033d2  POP EBX
  100033d3  RET
LAB_100033d4:
  100033d4  MOV byte ptr [ESI + 0x1c3],0x0
  100033db  MOV EAX,[0x1000f5f0]    ; DAT_1000f5f0
  100033e0  AND AL,0xf7
  100033e2  POP ESI
  100033e3  MOV [0x1000f5f0],EAX    ; DAT_1000f5f0
  100033e8  POP EBX
  100033e9  RET
LAB_100033ea:
  100033ea  CALL dword ptr [EDX + 0x20]
  100033ed  TEST AL,0x80
  100033ef  JZ 0x10003419    ; LAB_10003419
  100033f1  MOV EAX,dword ptr [ESI + 0x1d4]
  100033f7  MOV ECX,dword ptr [ESI + 0xc]
  100033fa  PUSH 0x4
  100033fc  MOV dword ptr [ESI + 0x1d0],EAX
  10003402  MOV byte ptr [ESI + 0x1c3],BL
  10003408  CALL 0x10002110    ; FUN_10002110
  1000340d  MOV EAX,[0x1000f5f0]    ; DAT_1000f5f0
  10003412  OR AL,0x8
  10003414  MOV [0x1000f5f0],EAX    ; DAT_1000f5f0
LAB_10003419:
  10003419  POP ESI
  1000341a  POP EBX
  1000341b  RET

;==== FUNCTION FUN_10003420 @ 10003420 : undefined4 FUN_10003420(int * param_1, int * param_2)
  10003420  PUSH EBP
  10003421  MOV EBP,ESP
  10003423  MOV EAX,dword ptr [EBP + 0x8]
  10003426  MOV ECX,dword ptr [EBP + 0xc]
  10003429  PUSH ESI
  1000342a  MOV EDX,dword ptr [EAX]
  1000342c  MOV ESI,dword ptr [ECX + 0x8]
  1000342f  CMP EDX,ESI
  10003431  JG 0x10003458    ; LAB_10003458
  10003433  MOV EDX,dword ptr [EAX + 0x8]
  10003436  MOV ESI,dword ptr [ECX]
  10003438  CMP EDX,ESI
  1000343a  JL 0x10003458    ; LAB_10003458
  1000343c  MOV EDX,dword ptr [EAX + 0x4]
  1000343f  MOV ESI,dword ptr [ECX + 0xc]
  10003442  CMP EDX,ESI
  10003444  JG 0x10003458    ; LAB_10003458
  10003446  MOV EAX,dword ptr [EAX + 0xc]
  10003449  MOV EDX,dword ptr [ECX + 0x4]
  1000344c  CMP EAX,EDX
  1000344e  JL 0x10003458    ; LAB_10003458
  10003450  MOV EAX,0x1
  10003455  POP ESI
  10003456  POP EBP
  10003457  RET
LAB_10003458:
  10003458  XOR EAX,EAX
  1000345a  POP ESI
  1000345b  POP EBP
  1000345c  RET

;==== FUNCTION FUN_10003460 @ 10003460 : undefined4 FUN_10003460(int param_1)
  10003460  PUSH EBP
  10003461  MOV EBP,ESP
  10003463  PUSH -0x1
  10003465  PUSH 0x1000c661    ; LAB_1000c661
  1000346a  MOV EAX,FS:[0x0]    ; ExceptionList
  10003470  PUSH EAX
  10003471  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  10003478  SUB ESP,0x2c
  1000347b  PUSH EBX
  1000347c  PUSH ESI
  1000347d  MOV ESI,ECX
  1000347f  LEA EAX,[EBP + -0x38]
  10003482  PUSH EDI
  10003483  PUSH EAX
  10003484  MOV ECX,dword ptr [ESI + 0xc]
  10003487  CALL 0x10002480    ; FUN_10002480
  1000348c  MOV ECX,dword ptr [ESI + 0x1a0]
  10003492  MOV dword ptr [EBP + -0x10],0x0
  10003499  TEST ECX,ECX
  1000349b  JLE 0x100034b6    ; LAB_100034b6
  1000349d  MOV EDX,dword ptr [ESI + 0xc]
  100034a0  LEA EAX,[ESI + 0x10]
  100034a3  MOV EDI,dword ptr [EDX]
  100034a5  MOV EDX,ECX
LAB_100034a7:
  100034a7  MOV EBX,dword ptr [EAX]
  100034a9  CMP dword ptr [EBX],EDI
  100034ab  JG 0x100034b0    ; LAB_100034b0
  100034ad  INC dword ptr [EBP + -0x10]
LAB_100034b0:
  100034b0  ADD EAX,0x4
  100034b3  DEC EDX
  100034b4  JNZ 0x100034a7    ; LAB_100034a7
LAB_100034b6:
  100034b6  TEST ECX,ECX
  100034b8  MOV dword ptr [EBP + -0x14],0x0
  100034bf  JLE 0x10003642    ; LAB_10003642
  100034c5  LEA EBX,[ESI + 0x10]
LAB_100034c8:
  100034c8  MOV ECX,dword ptr [EBX]
  100034ca  LEA EAX,[EBP + -0x28]
  100034cd  PUSH EAX
  100034ce  CALL 0x10001000    ; FUN_10001000
  100034d3  LEA ECX,[EBP + -0x28]
  100034d6  LEA EDX,[EBP + -0x38]
  100034d9  PUSH ECX
  100034da  PUSH EDX
  100034db  CALL 0x10003420    ; FUN_10003420
  100034e0  ADD ESP,0x8
  100034e3  TEST AL,AL
  100034e5  JZ 0x1000362a    ; LAB_1000362a
  100034eb  MOV EAX,dword ptr [EBX]
  100034ed  MOV ECX,dword ptr [EAX + 0x4]
  100034f0  TEST ECX,ECX
  100034f2  JNZ 0x1000362a    ; LAB_1000362a
  100034f8  MOV ECX,dword ptr [ESI + 0xc]
  100034fb  PUSH EAX
  100034fc  CALL 0x100024e0    ; FUN_100024e0
  10003501  TEST AL,AL
  10003503  JNZ 0x10003655    ; LAB_10003655
  10003509  MOV EDI,dword ptr [EBX]
  1000350b  TEST EDI,EDI
  1000350d  JZ 0x1000351f    ; LAB_1000351f
  1000350f  MOV ECX,EDI
  10003511  CALL 0x10001340    ; FUN_10001340
  10003516  PUSH EDI
  10003517  CALL 0x10005197    ; FUN_10005197
  1000351c  ADD ESP,0x4
LAB_1000351f:
  1000351f  MOV EAX,dword ptr [ESI + 0xc]
  10003522  MOV ECX,dword ptr [EAX]
  10003524  LEA EAX,[ECX + ECX*0x1 + 0x4]
  10003528  MOV ECX,dword ptr [EBP + -0x10]
  1000352b  CDQ
  1000352c  AND EDX,0x3
  1000352f  ADD EAX,EDX
  10003531  SAR EAX,0x2
  10003534  CMP ECX,EAX
  10003536  JG 0x10003574    ; LAB_10003574
  10003538  PUSH 0x38
  1000353a  CALL 0x100051a2    ; operator_new
  1000353f  MOV EDI,EAX
  10003541  ADD ESP,0x4
  10003544  MOV dword ptr [EBP + -0x18],EDI
  10003547  XOR EAX,EAX
  10003549  CMP EDI,EAX
  1000354b  MOV dword ptr [EBP + -0x4],EAX
  1000354e  JZ 0x1000361a    ; LAB_1000361a
  10003554  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  1000355a  MOV EDX,dword ptr [ECX]
  1000355c  CALL dword ptr [EDX + 0x8]
  1000355f  MOV ECX,dword ptr [ESI + 0xc]
  10003562  XOR EDX,EDX
  10003564  DIV dword ptr [ECX]
  10003566  MOV ECX,EDI
  10003568  INC EDX
  10003569  PUSH EDX
  1000356a  CALL 0x100011a0    ; FUN_100011a0
  1000356f  JMP 0x1000361a    ; LAB_1000361a
LAB_10003574:
  10003574  MOV EAX,dword ptr [ESI + 0x1a0]
  1000357a  PUSH 0x38
  1000357c  LEA EAX,[EAX + EAX*0x2]
  1000357f  CDQ
  10003580  AND EDX,0x3
  10003583  ADD EAX,EDX
  10003585  SAR EAX,0x2
  10003588  CMP ECX,EAX
  1000358a  JL 0x100035bc    ; LAB_100035bc
  1000358c  CALL 0x100051a2    ; operator_new
  10003591  ADD ESP,0x4
  10003594  MOV dword ptr [EBP + -0x18],EAX
  10003597  TEST EAX,EAX
  10003599  MOV dword ptr [EBP + -0x4],0x1
  100035a0  JZ 0x10003618    ; LAB_10003618
  100035a2  MOV EDX,dword ptr [ESI + 0xc]
  100035a5  MOV EDX,dword ptr [EDX]
  100035a7  INC EDX
  100035a8  CMP EDX,0xa
  100035ab  JL 0x100035b2    ; LAB_100035b2
  100035ad  MOV EDX,0xa
LAB_100035b2:
  100035b2  PUSH EDX
  100035b3  MOV ECX,EAX
  100035b5  CALL 0x100011a0    ; FUN_100011a0
  100035ba  JMP 0x1000361a    ; LAB_1000361a
LAB_100035bc:
  100035bc  CALL 0x100051a2    ; operator_new
  100035c1  MOV EDI,EAX
  100035c3  ADD ESP,0x4
  100035c6  MOV dword ptr [EBP + -0x18],EDI
  100035c9  TEST EDI,EDI
  100035cb  MOV dword ptr [EBP + -0x4],0x2
  100035d2  JZ 0x10003618    ; LAB_10003618
  100035d4  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  100035da  MOV EAX,dword ptr [ECX]
  100035dc  CALL dword ptr [EAX + 0x8]
  100035df  MOV ECX,dword ptr [ESI + 0xc]
  100035e2  XOR EDX,EDX
  100035e4  DIV dword ptr [ECX]
  100035e6  INC EDX
  100035e7  CMP EDX,0xa
  100035ea  JNC 0x10003609    ; LAB_10003609
  100035ec  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  100035f2  MOV EDX,dword ptr [ECX]
  100035f4  CALL dword ptr [EDX + 0x8]
  100035f7  MOV ECX,dword ptr [ESI + 0xc]
  100035fa  XOR EDX,EDX
  100035fc  DIV dword ptr [ECX]
  100035fe  MOV ECX,EDI
  10003600  INC EDX
  10003601  PUSH EDX
  10003602  CALL 0x100011a0    ; FUN_100011a0
  10003607  JMP 0x1000361a    ; LAB_1000361a
LAB_10003609:
  10003609  MOV EDX,0xa
  1000360e  MOV ECX,EDI
  10003610  PUSH EDX
  10003611  CALL 0x100011a0    ; FUN_100011a0
  10003616  JMP 0x1000361a    ; LAB_1000361a
LAB_10003618:
  10003618  XOR EAX,EAX
LAB_1000361a:
  1000361a  MOV dword ptr [EBX],EAX
  1000361c  MOV EAX,dword ptr [EBP + -0x10]
  1000361f  DEC EAX
  10003620  MOV dword ptr [EBP + -0x4],0xffffffff
  10003627  MOV dword ptr [EBP + -0x10],EAX
LAB_1000362a:
  1000362a  MOV EAX,dword ptr [EBP + -0x14]
  1000362d  MOV ECX,dword ptr [ESI + 0x1a0]
  10003633  INC EAX
  10003634  ADD EBX,0x4
  10003637  CMP EAX,ECX
  10003639  MOV dword ptr [EBP + -0x14],EAX
  1000363c  JL 0x100034c8    ; LAB_100034c8
LAB_10003642:
  10003642  POP EDI
  10003643  POP ESI
  10003644  XOR AL,AL
  10003646  POP EBX
  10003647  MOV ECX,dword ptr [EBP + -0xc]
  1000364a  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  10003651  MOV ESP,EBP
  10003653  POP EBP
  10003654  RET
LAB_10003655:
  10003655  MOV ECX,dword ptr [EBP + -0xc]
  10003658  POP EDI
  10003659  POP ESI
  1000365a  MOV AL,0x1
  1000365c  POP EBX
  1000365d  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  10003664  MOV ESP,EBP
  10003666  POP EBP
  10003667  RET

;==== FUNCTION FUN_10003670 @ 10003670 : undefined FUN_10003670(int param_1)
  10003670  PUSH EBP
  10003671  MOV EBP,ESP
  10003673  PUSH -0x1
  10003675  PUSH 0x1000c691    ; LAB_1000c691
  1000367a  MOV EAX,FS:[0x0]    ; ExceptionList
  10003680  PUSH EAX
  10003681  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  10003688  PUSH ECX
  10003689  PUSH ESI
  1000368a  MOV ESI,ECX
  1000368c  PUSH EDI
  1000368d  XOR EDI,EDI
  1000368f  MOV ECX,dword ptr [ESI + 0x1a0]
  10003695  TEST ECX,ECX
  10003697  JLE 0x100036b0    ; LAB_100036b0
  10003699  MOV EAX,dword ptr [ESI + 0xc]
  1000369c  PUSH EBX
  1000369d  MOV EDX,dword ptr [EAX]
  1000369f  LEA EAX,[ESI + 0x10]
LAB_100036a2:
  100036a2  MOV EBX,dword ptr [EAX]
  100036a4  CMP dword ptr [EBX],EDX
  100036a6  JG 0x100036a9    ; LAB_100036a9
  100036a8  INC EDI
LAB_100036a9:
  100036a9  ADD EAX,0x4
  100036ac  DEC ECX
  100036ad  JNZ 0x100036a2    ; LAB_100036a2
  100036af  POP EBX
LAB_100036b0:
  100036b0  MOV ECX,dword ptr [ESI + 0xc]
  100036b3  MOV ECX,dword ptr [ECX]
  100036b5  LEA EAX,[ECX + ECX*0x1 + 0x4]
  100036b9  CDQ
  100036ba  AND EDX,0x3
  100036bd  ADD EAX,EDX
  100036bf  SAR EAX,0x2
  100036c2  CMP EDI,EAX
  100036c4  JGE 0x10003702    ; LAB_10003702
  100036c6  PUSH 0x38
  100036c8  CALL 0x100051a2    ; operator_new
  100036cd  MOV EDI,EAX
  100036cf  ADD ESP,0x4
  100036d2  MOV dword ptr [EBP + -0x10],EDI
  100036d5  XOR EAX,EAX
  100036d7  CMP EDI,EAX
  100036d9  MOV dword ptr [EBP + -0x4],EAX
  100036dc  JZ 0x100037a5    ; LAB_100037a5
  100036e2  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  100036e8  MOV EDX,dword ptr [ECX]
  100036ea  CALL dword ptr [EDX + 0x8]
  100036ed  MOV ECX,dword ptr [ESI + 0xc]
  100036f0  XOR EDX,EDX
  100036f2  DIV dword ptr [ECX]
  100036f4  MOV ECX,EDI
  100036f6  INC EDX
  100036f7  PUSH EDX
  100036f8  CALL 0x100011a0    ; FUN_100011a0
  100036fd  JMP 0x100037a5    ; LAB_100037a5
LAB_10003702:
  10003702  LEA EAX,[ECX + ECX*0x2 + 0x6]
  10003706  PUSH 0x38
  10003708  SHL EAX,0x1
  1000370a  CDQ
  1000370b  AND EDX,0x3
  1000370e  ADD EAX,EDX
  10003710  SAR EAX,0x2
  10003713  CMP EDI,EAX
  10003715  JLE 0x10003747    ; LAB_10003747
  10003717  CALL 0x100051a2    ; operator_new
  1000371c  ADD ESP,0x4
  1000371f  MOV dword ptr [EBP + -0x10],EAX
  10003722  TEST EAX,EAX
  10003724  MOV dword ptr [EBP + -0x4],0x1
  1000372b  JZ 0x100037a3    ; LAB_100037a3
  1000372d  MOV ECX,dword ptr [ESI + 0xc]
  10003730  MOV EDX,dword ptr [ECX]
  10003732  INC EDX
  10003733  CMP EDX,0xa
  10003736  JL 0x1000373d    ; LAB_1000373d
  10003738  MOV EDX,0xa
LAB_1000373d:
  1000373d  PUSH EDX
  1000373e  MOV ECX,EAX
  10003740  CALL 0x100011a0    ; FUN_100011a0
  10003745  JMP 0x100037a5    ; LAB_100037a5
LAB_10003747:
  10003747  CALL 0x100051a2    ; operator_new
  1000374c  MOV EDI,EAX
  1000374e  ADD ESP,0x4
  10003751  MOV dword ptr [EBP + -0x10],EDI
  10003754  TEST EDI,EDI
  10003756  MOV dword ptr [EBP + -0x4],0x2
  1000375d  JZ 0x100037a3    ; LAB_100037a3
  1000375f  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  10003765  MOV EAX,dword ptr [ECX]
  10003767  CALL dword ptr [EAX + 0x8]
  1000376a  MOV ECX,dword ptr [ESI + 0xc]
  1000376d  XOR EDX,EDX
  1000376f  DIV dword ptr [ECX]
  10003771  INC EDX
  10003772  CMP EDX,0xa
  10003775  JNC 0x10003794    ; LAB_10003794
  10003777  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  1000377d  MOV EDX,dword ptr [ECX]
  1000377f  CALL dword ptr [EDX + 0x8]
  10003782  MOV ECX,dword ptr [ESI + 0xc]
  10003785  XOR EDX,EDX
  10003787  DIV dword ptr [ECX]
  10003789  MOV ECX,EDI
  1000378b  INC EDX
  1000378c  PUSH EDX
  1000378d  CALL 0x100011a0    ; FUN_100011a0
  10003792  JMP 0x100037a5    ; LAB_100037a5
LAB_10003794:
  10003794  MOV EDX,0xa
  10003799  MOV ECX,EDI
  1000379b  PUSH EDX
  1000379c  CALL 0x100011a0    ; FUN_100011a0
  100037a1  JMP 0x100037a5    ; LAB_100037a5
LAB_100037a3:
  100037a3  XOR EAX,EAX
LAB_100037a5:
  100037a5  MOV EDX,dword ptr [ESI + 0x1a0]
  100037ab  MOV ECX,dword ptr [EBP + -0xc]
  100037ae  POP EDI
  100037af  MOV dword ptr [ESI + EDX*0x4 + 0x10],EAX
  100037b3  MOV EAX,dword ptr [ESI + 0x1a0]
  100037b9  INC EAX
  100037ba  MOV dword ptr [ESI + 0x1a0],EAX
  100037c0  POP ESI
  100037c1  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  100037c8  MOV ESP,EBP
  100037ca  POP EBP
  100037cb  RET

;==== FUNCTION FUN_100037d0 @ 100037d0 : undefined4 FUN_100037d0(int param_1)
  100037d0  PUSH EBP
  100037d1  MOV EBP,ESP
  100037d3  SUB ESP,0xa4
  100037d9  PUSH EBX
  100037da  PUSH ESI
  100037db  MOV ESI,ECX
  100037dd  MOV EBX,0x1
  100037e2  MOV dword ptr [EBP + -0x40],ESI
LAB_100037e5:
  100037e5  PUSH EBX
  100037e6  LEA EAX,[EBP + -0x14]
  100037e9  PUSH 0x1000e61c    ; s_Score%dScore_1000e61c
  100037ee  PUSH EAX
  100037ef  CALL 0x100051b0    ; FUN_100051b0
  100037f4  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  100037fa  ADD ESP,0xc
  100037fd  LEA EAX,[EBP + 0xffffff5c]
  10003803  MOV EDX,dword ptr [ECX]
  10003805  PUSH EAX
  10003806  LEA EAX,[EBP + -0x14]
  10003809  PUSH EAX
  1000380a  CALL dword ptr [EDX + 0x14]
  1000380d  LEA ECX,[EBP + 0xffffff5c]
  10003813  PUSH ECX
  10003814  CALL 0x100056e2    ; FUN_100056e2
  10003819  MOV ECX,dword ptr [ESI + 0x8]
  1000381c  ADD ESP,0x4
  1000381f  CMP ECX,EAX
  10003821  JGE 0x10003831    ; LAB_10003831
  10003823  INC EBX
  10003824  CMP EBX,0x5
  10003827  JLE 0x100037e5    ; LAB_100037e5
  10003829  POP ESI
  1000382a  XOR AL,AL
  1000382c  POP EBX
  1000382d  MOV ESP,EBP
  1000382f  POP EBP
  10003830  RET
LAB_10003831:
  10003831  MOV EDX,dword ptr [0x1000f5cc]    ; DAT_1000f5cc
  10003837  PUSH EDI
  10003838  PUSH 0x0
  1000383a  MOV ECX,dword ptr [EDX + 0xd0]
  10003840  MOV EAX,dword ptr [ECX]
  10003842  CALL dword ptr [EAX + 0x8]
  10003845  XOR ECX,ECX
  10003847  XOR EDX,EDX
  10003849  MOV dword ptr [EBP + -0x28],ECX
  1000384c  MOV dword ptr [EBP + -0x3c],EDX
  1000384f  MOV dword ptr [EBP + -0x24],ECX
  10003852  MOV dword ptr [EBP + -0x38],EDX
  10003855  MOV dword ptr [EBP + -0x20],ECX
  10003858  MOV dword ptr [EBP + -0x34],EDX
  1000385b  MOV dword ptr [EBP + -0x1c],ECX
  1000385e  MOV dword ptr [EBP + -0x30],EDX
  10003861  MOV dword ptr [EBP + -0x18],ECX
  10003864  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  1000386a  MOV dword ptr [EBP + -0x2c],EDX
  1000386d  LEA EDX,[EBP + -0x28]
  10003870  MOV EAX,dword ptr [ECX]
  10003872  PUSH EDX
  10003873  PUSH 0x1000e60c    ; s_LastNameEntered_1000e60c
  10003878  CALL dword ptr [EAX + 0x14]
  1000387b  CMP EAX,0x19
  1000387e  JNZ 0x100038a5    ; LAB_100038a5
  10003880  MOV EDI,0x1000e604    ; DAT_1000e604
  10003885  OR ECX,0xffffffff
  10003888  XOR EAX,EAX
  1000388a  LEA EDX,[EBP + -0x28]
  1000388d  SCASB.REPNE ES:EDI    ; DAT_1000e604 DAT_1000e605
  1000388f  NOT ECX
  10003891  SUB EDI,ECX
  10003893  MOV EAX,ECX
  10003895  MOV ESI,EDI
  10003897  MOV EDI,EDX
  10003899  SHR ECX,0x2
  1000389c  MOVSD.REP ES:EDI,ESI
  1000389e  MOV ECX,EAX
  100038a0  AND ECX,0x3
  100038a3  MOVSB.REP ES:EDI,ESI
LAB_100038a5:
  100038a5  MOV ECX,dword ptr [0x1000f5c8]    ; DAT_1000f5c8
  100038ab  PUSH 0x1
  100038ad  LEA EAX,[EBP + -0x3c]
  100038b0  PUSH 0x10
  100038b2  MOV EDX,dword ptr [ECX]
  100038b4  PUSH EAX
  100038b5  LEA EAX,[EBP + -0x28]
  100038b8  PUSH EAX
  100038b9  PUSH 0x1000e5ac    ; s_You_got_a_high_score!_Survival_o_1000e5ac
  100038be  PUSH 0x1000e59c    ; s_Congratulations_1000e59c
  100038c3  CALL dword ptr [EDX + 0x18]
  100038c6  LEA EDI,[EBP + -0x3c]
  100038c9  OR ECX,0xffffffff
  100038cc  XOR EAX,EAX
  100038ce  SCASB.REPNE ES:EDI
  100038d0  NOT ECX
  100038d2  DEC ECX
  100038d3  CMP ECX,0xc
  100038d6  JBE 0x10003925    ; LAB_10003925
LAB_100038d8:
  100038d8  MOV ECX,dword ptr [0x1000f5c8]    ; DAT_1000f5c8
  100038de  PUSH 0x101
  100038e3  PUSH 0x1000e564    ; s_We're_sorry,_but_names_must_be_1_1000e564
  100038e8  PUSH 0x1000e554    ; s_Name_too_long_1000e554
  100038ed  MOV EDX,dword ptr [ECX]
  100038ef  CALL dword ptr [EDX + 0x14]
  100038f2  MOV ECX,dword ptr [0x1000f5c8]    ; DAT_1000f5c8
  100038f8  PUSH 0x1
  100038fa  LEA EDX,[EBP + -0x3c]
  100038fd  PUSH 0x10
  100038ff  MOV EAX,dword ptr [ECX]
  10003901  PUSH EDX
  10003902  LEA EDX,[EBP + -0x28]
  10003905  PUSH EDX
  10003906  PUSH 0x1000e5ac    ; s_You_got_a_high_score!_Survival_o_1000e5ac
  1000390b  PUSH 0x1000e59c    ; s_Congratulations_1000e59c
  10003910  CALL dword ptr [EAX + 0x18]
  10003913  LEA EDI,[EBP + -0x3c]
  10003916  OR ECX,0xffffffff
  10003919  XOR EAX,EAX
  1000391b  SCASB.REPNE ES:EDI
  1000391d  NOT ECX
  1000391f  DEC ECX
  10003920  CMP ECX,0xc
  10003923  JA 0x100038d8    ; LAB_100038d8
LAB_10003925:
  10003925  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  1000392b  LEA EDX,[EBP + -0x3c]
  1000392e  PUSH EDX
  1000392f  PUSH 0x1000e60c    ; s_LastNameEntered_1000e60c
  10003934  MOV EAX,dword ptr [ECX]
  10003936  CALL dword ptr [EAX + 0x10]
  10003939  MOV ESI,0x4
  1000393e  CMP EBX,ESI
  10003940  JG 0x100039ec    ; LAB_100039ec
LAB_10003946:
  10003946  PUSH ESI
  10003947  LEA EAX,[EBP + -0x14]
  1000394a  PUSH 0x1000e548    ; s_Score%dName_1000e548
  1000394f  PUSH EAX
  10003950  CALL 0x100051b0    ; FUN_100051b0
  10003955  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  1000395b  ADD ESP,0xc
  1000395e  LEA EAX,[EBP + -0x28]
  10003961  MOV EDX,dword ptr [ECX]
  10003963  PUSH EAX
  10003964  LEA EAX,[EBP + -0x14]
  10003967  PUSH EAX
  10003968  CALL dword ptr [EDX + 0x14]
  1000396b  PUSH ESI
  1000396c  LEA ECX,[EBP + -0x14]
  1000396f  PUSH 0x1000e61c    ; s_Score%dScore_1000e61c
  10003974  PUSH ECX
  10003975  CALL 0x100051b0    ; FUN_100051b0
  1000397a  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  10003980  ADD ESP,0xc
  10003983  LEA EAX,[EBP + 0xffffff5c]
  10003989  MOV EDX,dword ptr [ECX]
  1000398b  PUSH EAX
  1000398c  LEA EAX,[EBP + -0x14]
  1000398f  PUSH EAX
  10003990  CALL dword ptr [EDX + 0x14]
  10003993  LEA EDI,[ESI + 0x1]
  10003996  LEA ECX,[EBP + -0x14]
  10003999  PUSH EDI
  1000399a  PUSH 0x1000e548    ; s_Score%dName_1000e548
  1000399f  PUSH ECX
  100039a0  CALL 0x100051b0    ; FUN_100051b0
  100039a5  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  100039ab  ADD ESP,0xc
  100039ae  LEA EAX,[EBP + -0x28]
  100039b1  MOV EDX,dword ptr [ECX]
  100039b3  PUSH EAX
  100039b4  LEA EAX,[EBP + -0x14]
  100039b7  PUSH EAX
  100039b8  CALL dword ptr [EDX + 0x10]
  100039bb  PUSH EDI
  100039bc  LEA ECX,[EBP + -0x14]
  100039bf  PUSH 0x1000e61c    ; s_Score%dScore_1000e61c
  100039c4  PUSH ECX
  100039c5  CALL 0x100051b0    ; FUN_100051b0
  100039ca  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  100039d0  ADD ESP,0xc
  100039d3  LEA EAX,[EBP + 0xffffff5c]
  100039d9  MOV EDX,dword ptr [ECX]
  100039db  PUSH EAX
  100039dc  LEA EAX,[EBP + -0x14]
  100039df  PUSH EAX
  100039e0  CALL dword ptr [EDX + 0x10]
  100039e3  DEC ESI
  100039e4  CMP ESI,EBX
  100039e6  JGE 0x10003946    ; LAB_10003946
LAB_100039ec:
  100039ec  PUSH EBX
  100039ed  LEA ECX,[EBP + -0x14]
  100039f0  PUSH 0x1000e548    ; s_Score%dName_1000e548
  100039f5  PUSH ECX
  100039f6  CALL 0x100051b0    ; FUN_100051b0
  100039fb  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  10003a01  ADD ESP,0xc
  10003a04  LEA EAX,[EBP + -0x3c]
  10003a07  MOV EDX,dword ptr [ECX]
  10003a09  PUSH EAX
  10003a0a  LEA EAX,[EBP + -0x14]
  10003a0d  PUSH EAX
  10003a0e  CALL dword ptr [EDX + 0x10]
  10003a11  PUSH EBX
  10003a12  LEA ECX,[EBP + -0x14]
  10003a15  PUSH 0x1000e61c    ; s_Score%dScore_1000e61c
  10003a1a  PUSH ECX
  10003a1b  CALL 0x100051b0    ; FUN_100051b0
  10003a20  MOV EAX,dword ptr [EBP + -0x40]
  10003a23  LEA EDX,[EBP + 0xffffff5c]
  10003a29  PUSH 0xa
  10003a2b  PUSH EDX
  10003a2c  MOV ECX,dword ptr [EAX + 0x8]
  10003a2f  PUSH ECX
  10003a30  CALL 0x1000c3ae    ; FUN_1000c3ae
  10003a35  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  10003a3b  ADD ESP,0x18
  10003a3e  LEA EAX,[EBP + 0xffffff5c]
  10003a44  MOV EDX,dword ptr [ECX]
  10003a46  PUSH EAX
  10003a47  LEA EAX,[EBP + -0x14]
  10003a4a  PUSH EAX
  10003a4b  CALL dword ptr [EDX + 0x10]
  10003a4e  POP EDI
  10003a4f  POP ESI
  10003a50  MOV AL,0x1
  10003a52  POP EBX
  10003a53  MOV ESP,EBP
  10003a55  POP EBP
  10003a56  RET

;==== FUNCTION FUN_10003a60 @ 10003a60 : undefined FUN_10003a60(void)
  10003a60  PUSH EBP
  10003a61  MOV EBP,ESP
  10003a63  SUB ESP,0x34
  10003a66  PUSH ESI
  10003a67  MOV ESI,ECX
  10003a69  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10003a6f  PUSH 0x33
  10003a71  PUSH 0x99
  10003a76  PUSH 0xff
  10003a7b  MOV EAX,dword ptr [ECX]
  10003a7d  CALL dword ptr [EAX + 0x1c]
  10003a80  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10003a86  PUSH 0x20
  10003a88  PUSH 0x4e
  10003a8a  PUSH 0x7
  10003a8c  MOV EDX,dword ptr [ECX]
  10003a8e  PUSH 0x39
  10003a90  CALL dword ptr [EDX + 0x10]
  10003a93  MOV EAX,dword ptr [ESI + 0x1a4]
  10003a99  LEA ECX,[EBP + -0x34]
  10003a9c  PUSH EAX
  10003a9d  PUSH 0x1000e62c    ; s_<s0><ccc3399><b>%d</b>_1000e62c
  10003aa2  PUSH ECX
  10003aa3  CALL 0x100051b0    ; FUN_100051b0
  10003aa8  MOV EAX,[0x1000f5b8]    ; DAT_1000f5b8
  10003aad  PUSH 0x4
  10003aaf  LEA EDX,[EBP + -0x34]
  10003ab2  PUSH 0x35
  10003ab4  PUSH EDX
  10003ab5  PUSH EAX
  10003ab6  CALL 0x10004a00    ; FUN_10004a00
  10003abb  ADD ESP,0x1c
  10003abe  POP ESI
  10003abf  MOV ESP,EBP
  10003ac1  POP EBP
  10003ac2  RET

;==== FUNCTION FUN_10003ad0 @ 10003ad0 : undefined FUN_10003ad0(void)
  10003ad0  PUSH EBP
  10003ad1  MOV EBP,ESP
  10003ad3  SUB ESP,0x6c
  10003ad6  PUSH EBX
  10003ad7  PUSH ESI
  10003ad8  MOV ESI,ECX
  10003ada  PUSH EDI
  10003adb  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10003ae1  PUSH 0x33
  10003ae3  PUSH 0x99
  10003ae8  PUSH 0xff
  10003aed  MOV EAX,dword ptr [ECX]
  10003aef  CALL dword ptr [EAX + 0x1c]
  10003af2  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10003af8  PUSH 0x1a4
  10003afd  PUSH 0x1f4
  10003b02  PUSH 0x186
  10003b07  MOV EDX,dword ptr [ECX]
  10003b09  PUSH 0x1a9
  10003b0e  CALL dword ptr [EDX + 0x10]
  10003b11  MOV EAX,dword ptr [ESI + 0x8]
  10003b14  LEA ECX,[EBP + -0x6c]
  10003b17  PUSH EAX
  10003b18  PUSH 0x1000e644    ; DAT_1000e644
  10003b1d  PUSH ECX
  10003b1e  CALL 0x100051b0    ; FUN_100051b0
  10003b23  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10003b29  ADD ESP,0xc
  10003b2c  MOV EDX,dword ptr [ECX]
  10003b2e  PUSH 0x1
  10003b30  PUSH 0x18
  10003b32  PUSH 0x1000e290    ; s_Arial_1000e290
  10003b37  CALL dword ptr [EDX + 0x28]
  10003b3a  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10003b40  MOV ESI,EAX
  10003b42  PUSH ESI
  10003b43  MOV EAX,dword ptr [ECX]
  10003b45  CALL dword ptr [EAX + 0x48]
  10003b48  LEA ECX,[EBP + -0x8]
  10003b4b  LEA EDI,[EBP + -0x6c]
  10003b4e  PUSH ECX
  10003b4f  OR ECX,0xffffffff
  10003b52  XOR EAX,EAX
  10003b54  MOV EDX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10003b5a  SCASB.REPNE ES:EDI
  10003b5c  MOV EBX,dword ptr [EDX]
  10003b5e  LEA EAX,[EBP + -0x6c]
  10003b61  NOT ECX
  10003b63  DEC ECX
  10003b64  PUSH ECX
  10003b65  PUSH EAX
  10003b66  PUSH ESI
  10003b67  MOV ECX,EDX
  10003b69  CALL dword ptr [EBX + 0x58]
  10003b6c  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10003b72  PUSH 0x99
  10003b77  PUSH 0x33
  10003b79  PUSH 0xcc
  10003b7e  MOV EDX,dword ptr [ECX]
  10003b80  CALL dword ptr [EDX + 0x24]
  10003b83  MOV EAX,dword ptr [EBP + -0x8]
  10003b86  MOV ECX,0x1c9
  10003b8b  CDQ
  10003b8c  SUB EAX,EDX
  10003b8e  PUSH 0x186
  10003b93  SAR EAX,0x1
  10003b95  SUB ECX,EAX
  10003b97  MOV EAX,[0x1000f5b8]    ; DAT_1000f5b8
  10003b9c  LEA EDX,[EBP + -0x6c]
  10003b9f  PUSH ECX
  10003ba0  PUSH EDX
  10003ba1  PUSH EAX
  10003ba2  CALL 0x10004a00    ; FUN_10004a00
  10003ba7  ADD ESP,0x10
  10003baa  POP EDI
  10003bab  POP ESI
  10003bac  POP EBX
  10003bad  MOV ESP,EBP
  10003baf  POP EBP
  10003bb0  RET

;==== FUNCTION FUN_10003bc0 @ 10003bc0 : undefined FUN_10003bc0(int param_1)
  10003bc0  PUSH EBP
  10003bc1  MOV EBP,ESP
  10003bc3  SUB ESP,0xc
  10003bc6  MOV EAX,dword ptr [ECX + 0xc]
  10003bc9  MOV EDX,dword ptr [0x1000f5cc]    ; DAT_1000f5cc
  10003bcf  PUSH ESI
  10003bd0  MOV ECX,dword ptr [EAX]
  10003bd2  MOV ECX,dword ptr [EDX + ECX*0x8 + 0x8]
  10003bd6  LEA EDX,[EBP + -0x4]
  10003bd9  PUSH EDX
  10003bda  PUSH 0x1
  10003bdc  MOV EAX,dword ptr [ECX]
  10003bde  CALL dword ptr [EAX + 0x10]
  10003be1  MOV ECX,dword ptr [EBP + -0x4]
  10003be4  LEA EDX,[EBP + -0xc]
  10003be7  PUSH EDX
  10003be8  LEA EDX,[EBP + -0x8]
  10003beb  MOV EAX,dword ptr [ECX]
  10003bed  PUSH EDX
  10003bee  CALL dword ptr [EAX + 0x50]
  10003bf1  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10003bf7  PUSH 0x0
  10003bf9  PUSH 0x0
  10003bfb  PUSH 0x0
  10003bfd  MOV EAX,dword ptr [ECX]
  10003bff  CALL dword ptr [EAX + 0x1c]
  10003c02  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10003c08  PUSH 0x4e
  10003c0a  PUSH 0x1f4
  10003c0f  PUSH 0x17
  10003c11  MOV EDX,dword ptr [ECX]
  10003c13  PUSH 0x1ad
  10003c18  CALL dword ptr [EDX + 0x10]
  10003c1b  MOV EAX,dword ptr [EBP + -0x8]
  10003c1e  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10003c24  CDQ
  10003c25  MOV ESI,dword ptr [ECX]
  10003c27  SUB EAX,EDX
  10003c29  SAR EAX,0x1
  10003c2b  MOV EDX,0x1c9
  10003c30  PUSH 0x1b
  10003c32  SUB EDX,EAX
  10003c34  MOV EAX,dword ptr [EBP + -0x4]
  10003c37  PUSH EDX
  10003c38  PUSH EAX
  10003c39  CALL dword ptr [ESI + 0x40]
  10003c3c  MOV ECX,dword ptr [EBP + -0x4]
  10003c3f  MOV EDX,dword ptr [ECX]
  10003c41  CALL dword ptr [EDX + 0x4]
  10003c44  POP ESI
  10003c45  MOV ESP,EBP
  10003c47  POP EBP
  10003c48  RET

;==== FUNCTION FUN_10003c50 @ 10003c50 : undefined FUN_10003c50(void * this, int param_1, int param_2, int param_3, int param_4)
  10003c50  PUSH EBP
  10003c51  MOV EBP,ESP
  10003c53  MOV EAX,dword ptr [EBP + 0x8]
  10003c56  PUSH EBX
  10003c57  MOV EBX,dword ptr [EBP + 0x10]
  10003c5a  PUSH ESI
  10003c5b  MOV ESI,ECX
  10003c5d  PUSH EDI
  10003c5e  MOV EDI,dword ptr [EBP + 0x14]
  10003c61  MOV ECX,dword ptr [EBP + 0xc]
  10003c64  SUB EDI,ECX
  10003c66  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10003c6c  SUB EBX,EAX
  10003c6e  PUSH 0x1
  10003c70  MOV EAX,dword ptr [ECX]
  10003c72  LEA EDX,[EDI + 0x2]
  10003c75  PUSH EDX
  10003c76  LEA EDX,[EBX + 0x2]
  10003c79  PUSH EDX
  10003c7a  CALL dword ptr [EAX + 0x10]
  10003c7d  MOV dword ptr [ESI + 0x1dc],EAX
  10003c83  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  10003c89  PUSH EAX
  10003c8a  MOV EDX,dword ptr [ECX]
  10003c8c  CALL dword ptr [EDX + 0x18]
  10003c8f  MOV EDX,dword ptr [EBP + 0xc]
  10003c92  MOV ECX,dword ptr [ESI + 0x1dc]
  10003c98  PUSH 0x0
  10003c9a  PUSH EDX
  10003c9b  MOV EDX,dword ptr [EBP + 0x8]
  10003c9e  MOV EAX,dword ptr [ECX]
  10003ca0  PUSH EDX
  10003ca1  CALL dword ptr [EAX + 0x8]
  10003ca4  MOV ECX,dword ptr [ESI + 0x1dc]
  10003caa  ADD ESI,0x1d8
  10003cb0  PUSH ESI
  10003cb1  MOV EAX,dword ptr [ECX]
  10003cb3  CALL dword ptr [EAX + 0x44]
  10003cb6  MOV ECX,dword ptr [ESI]
  10003cb8  PUSH 0x63
  10003cba  PUSH 0x63
  10003cbc  PUSH 0x0
  10003cbe  MOV EDX,dword ptr [ECX]
  10003cc0  CALL dword ptr [EDX + 0x1c]
  10003cc3  MOV ECX,dword ptr [ESI]
  10003cc5  PUSH EDI
  10003cc6  PUSH EBX
  10003cc7  PUSH 0x1
  10003cc9  MOV EAX,dword ptr [ECX]
  10003ccb  PUSH 0x1
  10003ccd  CALL dword ptr [EAX + 0xc]
  10003cd0  MOV ECX,dword ptr [ESI]
  10003cd2  LEA EAX,[EDI + -0x1]
  10003cd5  PUSH EAX
  10003cd6  LEA EAX,[EBX + -0x1]
  10003cd9  MOV EDX,dword ptr [ECX]
  10003cdb  PUSH EAX
  10003cdc  PUSH 0x2
  10003cde  PUSH 0x2
  10003ce0  CALL dword ptr [EDX + 0xc]
  10003ce3  MOV ECX,dword ptr [ESI]
  10003ce5  PUSH 0xff
  10003cea  PUSH 0xcc
  10003cef  PUSH 0x99
  10003cf4  MOV EDX,dword ptr [ECX]
  10003cf6  CALL dword ptr [EDX + 0x1c]
  10003cf9  MOV ECX,dword ptr [ESI]
  10003cfb  LEA EDX,[EBX + 0x1]
  10003cfe  LEA EAX,[EDI + 0x1]
  10003d01  MOV dword ptr [EBP + 0x8],EDX
  10003d04  MOV EDX,dword ptr [ECX]
  10003d06  MOV dword ptr [EBP + 0x10],EAX
  10003d09  PUSH EAX
  10003d0a  MOV EAX,dword ptr [EBP + 0x8]
  10003d0d  PUSH EAX
  10003d0e  PUSH 0x0
  10003d10  PUSH 0x0
  10003d12  CALL dword ptr [EDX + 0xc]
  10003d15  MOV ECX,dword ptr [ESI]
  10003d17  LEA EAX,[EDI + -0x2]
  10003d1a  LEA EDX,[EBX + -0x2]
  10003d1d  MOV dword ptr [EBP + 0x14],EAX
  10003d20  MOV dword ptr [EBP + 0xc],EDX
  10003d23  MOV EDX,dword ptr [ECX]
  10003d25  PUSH EAX
  10003d26  MOV EAX,dword ptr [EBP + 0xc]
  10003d29  PUSH EAX
  10003d2a  PUSH 0x4
  10003d2c  PUSH 0x4
  10003d2e  CALL dword ptr [EDX + 0x10]
  10003d31  MOV EAX,dword ptr [EBP + 0x14]
  10003d34  MOV ECX,dword ptr [ESI]
  10003d36  PUSH EAX
  10003d37  MOV EAX,dword ptr [EBP + 0xc]
  10003d3a  MOV EDX,dword ptr [ECX]
  10003d3c  PUSH EAX
  10003d3d  PUSH 0x3
  10003d3f  PUSH 0x3
  10003d41  CALL dword ptr [EDX + 0xc]
  10003d44  MOV ECX,dword ptr [ESI]
  10003d46  PUSH 0x0
  10003d48  PUSH 0x0
  10003d4a  PUSH 0x0
  10003d4c  MOV EDX,dword ptr [ECX]
  10003d4e  CALL dword ptr [EDX + 0x1c]
  10003d51  MOV EDX,dword ptr [EBP + 0x10]
  10003d54  MOV ECX,dword ptr [ESI]
  10003d56  PUSH EDX
  10003d57  MOV EDX,dword ptr [EBP + 0x8]
  10003d5a  MOV EAX,dword ptr [ECX]
  10003d5c  PUSH EDX
  10003d5d  PUSH 0x0
  10003d5f  PUSH 0x0
  10003d61  CALL dword ptr [EAX + 0xc]
  10003d64  MOV ESI,dword ptr [ESI]
  10003d66  ADD EDI,-0x3
  10003d69  ADD EBX,-0x3
  10003d6c  PUSH EDI
  10003d6d  MOV EAX,dword ptr [ESI]
  10003d6f  PUSH EBX
  10003d70  PUSH 0x4
  10003d72  PUSH 0x4
  10003d74  MOV ECX,ESI
  10003d76  CALL dword ptr [EAX + 0xc]
  10003d79  POP EDI
  10003d7a  POP ESI
  10003d7b  POP EBX
  10003d7c  POP EBP
  10003d7d  RET 0x10

;==== FUNCTION FUN_10003d80 @ 10003d80 : undefined FUN_10003d80(void * param_1)
  10003d80  PUSH EBP
  10003d81  MOV EBP,ESP
  10003d83  SUB ESP,0x400
  10003d89  PUSH ESI
  10003d8a  PUSH 0x140
  10003d8f  PUSH 0x168
  10003d94  PUSH 0xa0
  10003d99  MOV ESI,ECX
  10003d9b  PUSH 0x9b
  10003da0  CALL 0x10003c50    ; FUN_10003c50
  10003da5  MOV EAX,dword ptr [ESI + 0x1d8]
  10003dab  PUSH 0x15
  10003dad  PUSH 0xb
  10003daf  PUSH 0x1000e720    ; s_<s3><c333399><b>Hmm..._When_we_s_1000e720
  10003db4  PUSH EAX
  10003db5  CALL 0x10004a00    ; FUN_10004a00
  10003dba  MOV ECX,dword ptr [ESI + 0x1d8]
  10003dc0  PUSH 0x24
  10003dc2  PUSH 0xb
  10003dc4  PUSH 0x1000e6f0    ; s_<s3><c333399><b>be_eaten"_we_rea_1000e6f0
  10003dc9  PUSH ECX
  10003dca  CALL 0x10004a00    ; FUN_10004a00
  10003dcf  MOV EDX,dword ptr [ESI + 0x1d8]
  10003dd5  PUSH 0x33
  10003dd7  PUSH 0xb
  10003dd9  PUSH 0x1000e6c0    ; s_<s3><c333399><b>should_do_the_ea_1000e6c0
  10003dde  PUSH EDX
  10003ddf  CALL 0x10004a00    ; FUN_10004a00
  10003de4  MOV EAX,dword ptr [ESI + 0x1a4]
  10003dea  LEA ECX,[EBP + 0xfffffc00]
  10003df0  INC EAX
  10003df1  PUSH EAX
  10003df2  PUSH 0x1000e694    ; s_<s3><c333399><b>That's_ok,_you_h_1000e694
  10003df7  PUSH ECX
  10003df8  CALL 0x100051b0    ; FUN_100051b0
  10003dfd  MOV EAX,dword ptr [ESI + 0x1d8]
  10003e03  PUSH 0x51
  10003e05  LEA EDX,[EBP + 0xfffffc00]
  10003e0b  PUSH 0xb
  10003e0d  PUSH EDX
  10003e0e  PUSH EAX
  10003e0f  CALL 0x10004a00    ; FUN_10004a00
  10003e14  MOV EAX,dword ptr [ESI + 0x1a4]
  10003e1a  ADD ESP,0x4c
  10003e1d  TEST EAX,EAX
  10003e1f  PUSH 0x60
  10003e21  PUSH 0xb
  10003e23  JLE 0x10003e33    ; LAB_10003e33
  10003e25  MOV ECX,dword ptr [ESI + 0x1d8]
  10003e2b  PUSH 0x1000e684    ; s_lives_left..._1000e684
  10003e30  PUSH ECX
  10003e31  JMP 0x10003e3f    ; LAB_10003e3f
LAB_10003e33:
  10003e33  MOV EDX,dword ptr [ESI + 0x1d8]
  10003e39  PUSH 0x1000e674    ; s_life_left..._1000e674
  10003e3e  PUSH EDX
LAB_10003e3f:
  10003e3f  CALL 0x10004a00    ; FUN_10004a00
  10003e44  MOV EAX,dword ptr [ESI + 0x1d8]
  10003e4a  ADD ESP,0x10
  10003e4d  MOV dword ptr [ESI + 0x1bc],0x2
  10003e57  PUSH 0x7e
  10003e59  PUSH 0x5
  10003e5b  PUSH 0x1000e648    ; s_<C000000>Press_the_space_bar_to_c_1000e648
  10003e60  PUSH EAX
  10003e61  CALL 0x10004a00    ; FUN_10004a00
  10003e66  ADD ESP,0x10
  10003e69  POP ESI
  10003e6a  MOV ESP,EBP
  10003e6c  POP EBP
  10003e6d  RET

;==== FUNCTION FUN_10003e70 @ 10003e70 : undefined FUN_10003e70(void * param_1)
  10003e70  PUSH ESI
  10003e71  PUSH 0x122
  10003e76  PUSH 0x163
  10003e7b  PUSH 0xa0
  10003e80  MOV ESI,ECX
  10003e82  PUSH 0x9b
  10003e87  CALL 0x10003c50    ; FUN_10003c50
  10003e8c  MOV EAX,dword ptr [ESI + 0x1d8]
  10003e92  PUSH 0x15
  10003e94  PUSH 0xb
  10003e96  PUSH 0x1000e7d8    ; s_<s3><c333399><b>That_was_good._U_1000e7d8
  10003e9b  PUSH EAX
  10003e9c  CALL 0x10004a00    ; FUN_10004a00
  10003ea1  MOV ECX,dword ptr [ESI + 0x1d8]
  10003ea7  PUSH 0x24
  10003ea9  PUSH 0xb
  10003eab  PUSH 0x1000e7ac    ; s_<s3><c333399><b>that_was_also_al_1000e7ac
  10003eb0  PUSH ECX
  10003eb1  CALL 0x10004a00    ; FUN_10004a00
  10003eb6  MOV EDX,dword ptr [ESI + 0x1d8]
  10003ebc  PUSH 0x33
  10003ebe  PUSH 0xb
  10003ec0  PUSH 0x1000e780    ; s_<s3><c333399><b>for_this_little_m_1000e780
  10003ec5  PUSH EDX
  10003ec6  CALL 0x10004a00    ; FUN_10004a00
  10003ecb  MOV EAX,dword ptr [ESI + 0x1d8]
  10003ed1  PUSH 0x51
  10003ed3  PUSH 0xb
  10003ed5  PUSH 0x1000e75c    ; s_<s3><c333399><b><c>Play_Again?</_1000e75c
  10003eda  PUSH EAX
  10003edb  CALL 0x10004a00    ; FUN_10004a00
  10003ee0  ADD ESP,0x40
  10003ee3  MOV ECX,dword ptr [ESI + 0x1dc]
  10003ee9  MOV dword ptr [ESI + 0x1bc],0x1
  10003ef3  PUSH 0x10003f50    ; FUN_10003f50
  10003ef8  PUSH ESI
  10003ef9  PUSH 0xc
  10003efb  PUSH 0x0
  10003efd  PUSH 0x6b
  10003eff  PUSH 0x1b
  10003f01  PUSH 0x1000e754    ; s_Yes_(Y)_1000e754
  10003f06  PUSH ECX
  10003f07  MOV ECX,dword ptr [0x1000f5cc]    ; DAT_1000f5cc
  10003f0d  CALL 0x10001de0    ; FUN_10001de0
  10003f12  MOV EDX,dword ptr [ESI + 0x1dc]
  10003f18  PUSH 0x10003f50    ; FUN_10003f50
  10003f1d  PUSH ESI
  10003f1e  PUSH 0xc
  10003f20  PUSH 0x1
  10003f22  PUSH 0x6b
  10003f24  PUSH 0x7f
  10003f26  MOV dword ptr [ESI + 0x1e0],EAX
  10003f2c  MOV ECX,dword ptr [0x1000f5cc]    ; DAT_1000f5cc
  10003f32  PUSH 0x1000e74c    ; s_No_(N)_1000e74c
  10003f37  PUSH EDX
  10003f38  CALL 0x10001de0    ; FUN_10001de0
  10003f3d  MOV dword ptr [ESI + 0x1e4],EAX
  10003f43  POP ESI
  10003f44  RET

;==== FUNCTION FUN_10003f50 @ 10003f50 : undefined FUN_10003f50(undefined4 * param_1)
  10003f50  PUSH EBP
  10003f51  MOV EBP,ESP
  10003f53  MOV EAX,dword ptr [EBP + 0x8]
  10003f56  PUSH EAX
  10003f57  MOV ECX,dword ptr [EAX]
  10003f59  CALL 0x10003f60    ; FUN_10003f60
  10003f5e  POP EBP
  10003f5f  RET

;==== FUNCTION FUN_10003f60 @ 10003f60 : undefined4 FUN_10003f60(void * this, int param_1)
  10003f60  PUSH EBP
  10003f61  MOV EBP,ESP
  10003f63  MOV EAX,FS:[0x0]    ; ExceptionList
  10003f69  PUSH -0x1
  10003f6b  PUSH 0x1000c6b6    ; LAB_1000c6b6
  10003f70  PUSH EAX
  10003f71  MOV EAX,dword ptr [EBP + 0x8]
  10003f74  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  10003f7b  PUSH ESI
  10003f7c  MOV ESI,ECX
  10003f7e  MOV ECX,dword ptr [EAX + 0x4]
  10003f81  TEST ECX,ECX
  10003f83  JNZ 0x10003faf    ; LAB_10003faf
  10003f85  PUSH 0x1e8
  10003f8a  CALL 0x100051a2    ; operator_new
  10003f8f  ADD ESP,0x4
  10003f92  MOV dword ptr [EBP + 0x8],EAX
  10003f95  TEST EAX,EAX
  10003f97  MOV dword ptr [EBP + -0x4],0x0
  10003f9e  JZ 0x10003fd4    ; LAB_10003fd4
  10003fa0  MOV ECX,dword ptr [ESI + 0x4]
  10003fa3  PUSH 0x0
  10003fa5  PUSH ECX
  10003fa6  MOV ECX,EAX
  10003fa8  CALL 0x10002a80    ; FUN_10002a80
  10003fad  JMP 0x10003fd6    ; LAB_10003fd6
LAB_10003faf:
  10003faf  PUSH 0x20
  10003fb1  CALL 0x100051a2    ; operator_new
  10003fb6  ADD ESP,0x4
  10003fb9  MOV dword ptr [EBP + 0x8],EAX
  10003fbc  TEST EAX,EAX
  10003fbe  MOV dword ptr [EBP + -0x4],0x1
  10003fc5  JZ 0x10003fd4    ; LAB_10003fd4
  10003fc7  MOV EDX,dword ptr [ESI + 0x4]
  10003fca  MOV ECX,EAX
  10003fcc  PUSH EDX
  10003fcd  CALL 0x100041a0    ; FUN_100041a0
  10003fd2  JMP 0x10003fd6    ; LAB_10003fd6
LAB_10003fd4:
  10003fd4  XOR EAX,EAX
LAB_10003fd6:
  10003fd6  MOV ECX,dword ptr [ESI + 0x4]
  10003fd9  PUSH EAX
  10003fda  PUSH ESI
  10003fdb  MOV dword ptr [EBP + -0x4],0xffffffff
  10003fe2  CALL 0x10001db0    ; FUN_10001db0
  10003fe7  MOV ECX,dword ptr [EBP + -0xc]
  10003fea  XOR EAX,EAX
  10003fec  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  10003ff3  POP ESI
  10003ff4  MOV ESP,EBP
  10003ff6  POP EBP
  10003ff7  RET 0x4

;==== FUNCTION FUN_10004000 @ 10004000 : undefined4 FUN_10004000(int param_1)
  10004000  PUSH EBP
  10004001  MOV EBP,ESP
  10004003  PUSH -0x1
  10004005  PUSH 0x1000c6cb    ; LAB_1000c6cb
  1000400a  MOV EAX,FS:[0x0]    ; ExceptionList
  10004010  PUSH EAX
  10004011  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  10004018  PUSH ECX
  10004019  PUSH ESI
  1000401a  MOV ESI,ECX
  1000401c  PUSH EDI
  1000401d  XOR EDI,EDI
  1000401f  MOV ECX,dword ptr [ESI + 0x1d8]
  10004025  CMP ECX,EDI
  10004027  JZ 0x10004034    ; LAB_10004034
  10004029  MOV EAX,dword ptr [ECX]
  1000402b  CALL dword ptr [EAX + 0x4]
  1000402e  MOV dword ptr [ESI + 0x1d8],EDI
LAB_10004034:
  10004034  MOV EAX,dword ptr [ESI + 0x1dc]
  1000403a  CMP EAX,EDI
  1000403c  JZ 0x1000405b    ; LAB_1000405b
  1000403e  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  10004044  PUSH EAX
  10004045  MOV EDX,dword ptr [ECX]
  10004047  CALL dword ptr [EDX + 0x1c]
  1000404a  MOV ECX,dword ptr [ESI + 0x1dc]
  10004050  MOV EAX,dword ptr [ECX]
  10004052  CALL dword ptr [EAX + 0x4]
  10004055  MOV dword ptr [ESI + 0x1dc],EDI
LAB_1000405b:
  1000405b  MOV EAX,dword ptr [ESI + 0x1a0]
  10004061  PUSH EBX
  10004062  CMP EAX,EDI
  10004064  MOV dword ptr [EBP + -0x10],EDI
  10004067  JLE 0x10004098    ; LAB_10004098
  10004069  LEA EBX,[ESI + 0x10]
LAB_1000406c:
  1000406c  MOV EDI,dword ptr [EBX]
  1000406e  TEST EDI,EDI
  10004070  JZ 0x10004082    ; LAB_10004082
  10004072  MOV ECX,EDI
  10004074  CALL 0x10001340    ; FUN_10001340
  10004079  PUSH EDI
  1000407a  CALL 0x10005197    ; FUN_10005197
  1000407f  ADD ESP,0x4
LAB_10004082:
  10004082  MOV EAX,dword ptr [EBP + -0x10]
  10004085  MOV ECX,dword ptr [ESI + 0x1a0]
  1000408b  INC EAX
  1000408c  ADD EBX,0x4
  1000408f  CMP EAX,ECX
  10004091  MOV dword ptr [EBP + -0x10],EAX
  10004094  JL 0x1000406c    ; LAB_1000406c
  10004096  XOR EDI,EDI
LAB_10004098:
  10004098  MOV ECX,dword ptr [ESI + 0xc]
  1000409b  CALL 0x10002030    ; FUN_10002030
  100040a0  MOV ECX,dword ptr [ESI + 0xc]
  100040a3  MOV byte ptr [ESI + 0x1ac],0x0
  100040aa  MOV byte ptr [ESI + 0x1ad],0x0
  100040b1  MOV byte ptr [ESI + 0x1ae],0x0
  100040b8  MOV dword ptr [ESI + 0x1a0],EDI
  100040be  MOV EDI,dword ptr [ECX]
  100040c0  LEA ECX,[EDI + EDI*0x1 + 0x4]
  100040c4  TEST ECX,ECX
  100040c6  JLE 0x10004145    ; LAB_10004145
  100040c8  OR EBX,0xffffffff
LAB_100040cb:
  100040cb  MOV EAX,0x55555556
  100040d0  IMUL ECX
  100040d2  MOV EAX,EDX
  100040d4  SHR EAX,0x1f
  100040d7  ADD EDX,EAX
  100040d9  MOV EAX,dword ptr [ESI + 0x1a0]
  100040df  CMP EAX,EDX
  100040e1  JL 0x100040f7    ; LAB_100040f7
  100040e3  MOV ECX,dword ptr [0x1000f5b4]    ; DAT_1000f5b4
  100040e9  MOV EDX,dword ptr [ECX]
  100040eb  CALL dword ptr [EDX + 0x8]
  100040ee  MOV ECX,dword ptr [ESI + 0xc]
  100040f1  XOR EDX,EDX
  100040f3  DIV dword ptr [ECX]
  100040f5  MOV EDI,EDX
LAB_100040f7:
  100040f7  PUSH 0x38
  100040f9  INC EDI
  100040fa  CALL 0x100051a2    ; operator_new
  100040ff  ADD ESP,0x4
  10004102  MOV dword ptr [EBP + -0x10],EAX
  10004105  TEST EAX,EAX
  10004107  MOV dword ptr [EBP + -0x4],0x0
  1000410e  JZ 0x1000411a    ; LAB_1000411a
  10004110  PUSH EDI
  10004111  MOV ECX,EAX
  10004113  CALL 0x100011a0    ; FUN_100011a0
  10004118  JMP 0x1000411c    ; LAB_1000411c
LAB_1000411a:
  1000411a  XOR EAX,EAX
LAB_1000411c:
  1000411c  MOV EDX,dword ptr [ESI + 0x1a0]
  10004122  MOV dword ptr [EBP + -0x4],EBX
  10004125  MOV dword ptr [ESI + EDX*0x4 + 0x10],EAX
  10004129  MOV EDI,dword ptr [ESI + 0x1a0]
  1000412f  MOV ECX,dword ptr [ESI + 0xc]
  10004132  INC EDI
  10004133  MOV dword ptr [ESI + 0x1a0],EDI
  10004139  MOV EAX,EDI
  1000413b  MOV EDI,dword ptr [ECX]
  1000413d  LEA ECX,[EDI + EDI*0x1 + 0x4]
  10004141  CMP EAX,ECX
  10004143  JL 0x100040cb    ; LAB_100040cb
LAB_10004145:
  10004145  MOV AL,[0x1000f5ec]    ; DAT_1000f5ec
  1000414a  POP EBX
  1000414b  TEST AL,AL
  1000414d  JZ 0x10004172    ; LAB_10004172
  1000414f  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  10004155  MOV EAX,[0x1000f5e8]    ; DAT_1000f5e8
  1000415a  PUSH EAX
  1000415b  MOV EDX,dword ptr [ECX]
  1000415d  CALL dword ptr [EDX + 0x1c]
  10004160  MOV ECX,dword ptr [0x1000f5e8]    ; DAT_1000f5e8
  10004166  MOV EDX,dword ptr [ECX]
  10004168  CALL dword ptr [EDX + 0x4]
  1000416b  MOV byte ptr [0x1000f5ec],0x0    ; DAT_1000f5ec
LAB_10004172:
  10004172  MOV ECX,ESI
  10004174  CALL 0x10003a60    ; FUN_10003a60
  10004179  MOV ECX,dword ptr [EBP + -0xc]
  1000417c  MOV dword ptr [ESI + 0x1bc],0x0
  10004186  POP EDI
  10004187  XOR EAX,EAX
  10004189  POP ESI
  1000418a  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  10004191  MOV ESP,EBP
  10004193  POP EBP
  10004194  RET 0x4

;==== FUNCTION FUN_100041a0 @ 100041a0 : undefined4 * FUN_100041a0(void * this, undefined4 param_1)
  100041a0  PUSH EBP
  100041a1  MOV EBP,ESP
  100041a3  PUSH -0x1
  100041a5  PUSH 0x1000c6e8    ; LAB_1000c6e8
  100041aa  MOV EAX,FS:[0x0]    ; ExceptionList
  100041b0  PUSH EAX
  100041b1  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  100041b8  PUSH ECX
  100041b9  MOV EAX,dword ptr [EBP + 0x8]
  100041bc  PUSH EBX
  100041bd  PUSH ESI
  100041be  MOV ESI,ECX
  100041c0  PUSH EAX
  100041c1  MOV dword ptr [EBP + -0x10],ESI
  100041c4  CALL 0x10002660    ; FUN_10002660
  100041c9  MOV dword ptr [ESI],0x1000d15c    ; PTR_FUN_1000d15c
  100041cf  MOV ECX,dword ptr [0x1000f5cc]    ; DAT_1000f5cc
  100041d5  XOR EBX,EBX
  100041d7  MOV ECX,dword ptr [ECX + 0xc8]
  100041dd  PUSH EBX
  100041de  MOV dword ptr [EBP + -0x4],EBX
  100041e1  MOV EDX,dword ptr [ECX]
  100041e3  CALL dword ptr [EDX + 0x8]
  100041e6  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  100041ec  MOV byte ptr [0x1000f605],BL    ; DAT_1000f605
  100041f2  MOV byte ptr [0x1000f604],BL    ; DAT_1000f604
  100041f8  MOV dword ptr [0x1000f608],0x1    ; DAT_1000f608
  10004202  MOV EAX,dword ptr [ECX]
  10004204  PUSH 0xcc
  10004209  PUSH 0x99
  1000420e  PUSH 0x99
  10004213  CALL dword ptr [EAX + 0x34]
  10004216  MOV EAX,[0x1000f5cc]    ; DAT_1000f5cc
  1000421b  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  10004221  MOV EAX,dword ptr [EAX + 0xb0]
  10004227  MOV EDX,dword ptr [ECX]
  10004229  PUSH EAX
  1000422a  CALL dword ptr [EDX + 0x18]
  1000422d  MOV ECX,dword ptr [0x1000f5cc]    ; DAT_1000f5cc
  10004233  PUSH EBX
  10004234  PUSH 0x14a
  10004239  PUSH EBX
  1000423a  MOV ECX,dword ptr [ECX + 0xb0]
  10004240  MOV EDX,dword ptr [ECX]
  10004242  CALL dword ptr [EDX + 0x8]
  10004245  MOV EAX,[0x1000f5cc]    ; DAT_1000f5cc
  1000424a  MOV ECX,dword ptr [EAX + 0xb0]
  10004250  MOV EDX,dword ptr [ECX]
  10004252  CALL dword ptr [EDX + 0x2c]
  10004255  MOV EDX,dword ptr [ESI + 0x4]
  10004258  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  1000425e  PUSH EBX
  1000425f  PUSH EBX
  10004260  MOV EDX,dword ptr [EDX + 0xbc]
  10004266  MOV EAX,dword ptr [ECX]
  10004268  PUSH EDX
  10004269  CALL dword ptr [EAX + 0x40]
  1000426c  MOV EAX,[0x1000f5bc]    ; DAT_1000f5bc
  10004271  MOV ECX,dword ptr [ESI + 0x4]
  10004274  PUSH 0x10004990    ; FUN_10004990
  10004279  PUSH ESI
  1000427a  PUSH 0x18
  1000427c  PUSH -0x1
  1000427e  PUSH 0xbe
  10004283  PUSH 0xfa
  10004288  PUSH 0x1000e830    ; s_Start_1000e830
  1000428d  PUSH EAX
  1000428e  CALL 0x10001de0    ; FUN_10001de0
  10004293  MOV dword ptr [ESI + 0xc],EAX
  10004296  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  1000429c  PUSH 0xbb
  100042a1  PUSH 0x32
  100042a3  PUSH 0x1000e808    ; s_<C000000><S1><b><u>Top_Moeboids<_1000e808
  100042a8  PUSH ECX
  100042a9  CALL 0x10004a00    ; FUN_10004a00
  100042ae  ADD ESP,0x10
  100042b1  MOV dword ptr [ESI + 0x14],EBX
  100042b4  MOV dword ptr [ESI + 0x18],EBX
  100042b7  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  100042bd  MOV EAX,[0x1000f5c8]    ; DAT_1000f5c8
  100042c2  PUSH 0x100049a0    ; FUN_100049a0
  100042c7  MOV EDX,dword ptr [ECX]
  100042c9  PUSH ESI
  100042ca  PUSH 0xb
  100042cc  PUSH EAX
  100042cd  CALL dword ptr [EDX + 0x44]
  100042d0  MOV dword ptr [ESI + 0x10],EAX
  100042d3  MOV ECX,ESI
  100042d5  CALL 0x10004640    ; FUN_10004640
  100042da  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  100042e0  PUSH 0x100049b0    ; FUN_100049b0
  100042e5  PUSH 0x64
  100042e7  PUSH ESI
  100042e8  MOV EDX,dword ptr [ECX]
  100042ea  CALL dword ptr [EDX + 0x34]
  100042ed  MOV dword ptr [ESI + 0x1c],EAX
  100042f0  MOV EAX,[0x1000f5b4]    ; DAT_1000f5b4
  100042f5  PUSH EBX
  100042f6  MOV ECX,dword ptr [EAX + 0x14]
  100042f9  MOV EDX,dword ptr [ECX]
  100042fb  CALL dword ptr [EDX + 0xc]
  100042fe  MOV ECX,dword ptr [EBP + -0xc]
  10004301  MOV EAX,ESI
  10004303  POP ESI
  10004304  POP EBX
  10004305  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  1000430c  MOV ESP,EBP
  1000430e  POP EBP
  1000430f  RET 0x4

;==== FUNCTION FUN_10004320 @ 10004320 : undefined4 * FUN_10004320(void * this, byte param_1)
  10004320  PUSH EBP
  10004321  MOV EBP,ESP
  10004323  PUSH ESI
  10004324  MOV ESI,ECX
  10004326  CALL 0x10004350    ; FUN_10004350
  1000432b  TEST byte ptr [EBP + 0x8],0x1
  1000432f  JZ 0x1000433a    ; LAB_1000433a
  10004331  PUSH ESI
  10004332  CALL 0x10005197    ; FUN_10005197
  10004337  ADD ESP,0x4
LAB_1000433a:
  1000433a  MOV EAX,ESI
  1000433c  POP ESI
  1000433d  POP EBP
  1000433e  RET 0x4

;==== FUNCTION FUN_10004350 @ 10004350 : undefined FUN_10004350(undefined4 * param_1)
  10004350  PUSH EBP
  10004351  MOV EBP,ESP
  10004353  PUSH -0x1
  10004355  PUSH 0x1000c708    ; LAB_1000c708
  1000435a  MOV EAX,FS:[0x0]    ; ExceptionList
  10004360  PUSH EAX
  10004361  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  10004368  PUSH ECX
  10004369  PUSH ESI
  1000436a  MOV ESI,ECX
  1000436c  MOV dword ptr [EBP + -0x10],ESI
  1000436f  MOV dword ptr [ESI],0x1000d15c    ; PTR_FUN_1000d15c
  10004375  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  1000437b  MOV EDX,dword ptr [ESI + 0xc]
  1000437e  PUSH EDX
  1000437f  MOV dword ptr [EBP + -0x4],0x0
  10004386  MOV EAX,dword ptr [ECX]
  10004388  CALL dword ptr [EAX + 0x1c]
  1000438b  MOV ECX,dword ptr [ESI + 0xc]
  1000438e  MOV EAX,dword ptr [ECX]
  10004390  CALL dword ptr [EAX + 0x4]
  10004393  MOV ECX,dword ptr [ESI + 0x10]
  10004396  MOV EDX,dword ptr [ECX]
  10004398  CALL dword ptr [EDX + 0x4]
  1000439b  MOV ECX,dword ptr [ESI + 0x1c]
  1000439e  MOV EAX,dword ptr [ECX]
  100043a0  CALL dword ptr [EAX + 0x4]
  100043a3  MOV EAX,[0x1000f5cc]    ; DAT_1000f5cc
  100043a8  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  100043ae  MOV EAX,dword ptr [EAX + 0xb0]
  100043b4  MOV EDX,dword ptr [ECX]
  100043b6  PUSH EAX
  100043b7  CALL dword ptr [EDX + 0x1c]
  100043ba  MOV ECX,dword ptr [0x1000f5cc]    ; DAT_1000f5cc
  100043c0  MOV ECX,dword ptr [ECX + 0xb0]
  100043c6  MOV EDX,dword ptr [ECX]
  100043c8  CALL dword ptr [EDX + 0x34]
  100043cb  MOV ECX,ESI
  100043cd  MOV dword ptr [EBP + -0x4],0xffffffff
  100043d4  CALL 0x100026b0    ; FUN_100026b0
  100043d9  MOV ECX,dword ptr [EBP + -0xc]
  100043dc  POP ESI
  100043dd  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  100043e4  MOV ESP,EBP
  100043e6  POP EBP
  100043e7  RET

;==== FUNCTION FUN_100043f0 @ 100043f0 : undefined4 FUN_100043f0(void * this, int param_1)
  100043f0  PUSH EBP
  100043f1  MOV EBP,ESP
  100043f3  PUSH -0x1
  100043f5  PUSH 0x1000c72b    ; LAB_1000c72b
  100043fa  MOV EAX,FS:[0x0]    ; ExceptionList
  10004400  PUSH EAX
  10004401  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  10004408  SUB ESP,0x1c
  1000440b  MOV EAX,[0x1000e84c]    ; s_CREDITS_1000e84c
  10004410  MOV EDX,dword ptr [0x1000e844]    ; s_credits_1000e844
  10004416  PUSH EBX
  10004417  PUSH ESI
  10004418  MOV ESI,ECX
  1000441a  MOV dword ptr [EBP + -0x14],EAX
  1000441d  MOV EAX,[0x1000e848]    ; s_its_1000e844+4
  10004422  MOV ECX,dword ptr [0x1000e850]    ; s_ITS_1000e84c+4
  10004428  MOV dword ptr [EBP + -0x1c],EDX
  1000442b  MOV EDX,dword ptr [0x1000e83c]    ; s_NCIBLE_1000e838+4
  10004431  MOV dword ptr [EBP + -0x18],EAX
  10004434  MOV AX,[0x1000e840]    ; s_LE_1000e838+8
  1000443a  MOV dword ptr [EBP + -0x24],EDX
  1000443d  MOV EDX,dword ptr [ESI + 0x4]
  10004440  MOV dword ptr [EBP + -0x10],ECX
  10004443  MOV ECX,dword ptr [0x1000e838]    ; s_INVINCIBLE_1000e838
  10004449  MOV word ptr [EBP + -0x20],AX
  1000444d  MOV AL,byte ptr [EDX + 0xb4]
  10004453  MOV dword ptr [EBP + -0x28],ECX
  10004456  MOV CL,byte ptr [0x1000e842]    ; s__1000e838+0xa
  1000445c  XOR EBX,EBX
  1000445e  MOV byte ptr [EBP + -0x1e],CL
  10004461  CMP AL,BL
  10004463  JNZ 0x10004513    ; LAB_10004513
  10004469  MOV EAX,dword ptr [ESI + 0x14]
  1000446c  MOV EDX,dword ptr [EBP + 0x8]
  1000446f  PUSH EDI
  10004470  MOVSX EDI,byte ptr [EBP + EAX*0x1 + -0x14]
  10004475  MOV ECX,dword ptr [EDX + 0x8]
  10004478  CMP ECX,EDI
  1000447a  JZ 0x1000448a    ; LAB_1000448a
  1000447c  MOVSX EDI,byte ptr [EBP + EAX*0x1 + -0x1c]
  10004481  CMP ECX,EDI
  10004483  JZ 0x1000448a    ; LAB_1000448a
  10004485  MOV dword ptr [ESI + 0x14],EBX
  10004488  JMP 0x1000448e    ; LAB_1000448e
LAB_1000448a:
  1000448a  INC EAX
  1000448b  MOV dword ptr [ESI + 0x14],EAX
LAB_1000448e:
  1000448e  MOV EAX,dword ptr [ESI + 0x18]
  10004491  MOV EDI,dword ptr [EDX + 0x8]
  10004494  MOVSX ECX,byte ptr [EBP + EAX*0x1 + -0x28]
  10004499  CMP EDI,ECX
  1000449b  JNZ 0x100044a3    ; LAB_100044a3
  1000449d  INC EAX
  1000449e  MOV dword ptr [ESI + 0x18],EAX
  100044a1  JMP 0x100044a6    ; LAB_100044a6
LAB_100044a3:
  100044a3  MOV dword ptr [ESI + 0x18],EBX
LAB_100044a6:
  100044a6  LEA EDI,[EBP + -0x28]
  100044a9  OR ECX,0xffffffff
  100044ac  XOR EAX,EAX
  100044ae  SCASB.REPNE ES:EDI
  100044b0  MOV EAX,dword ptr [ESI + 0x18]
  100044b3  NOT ECX
  100044b5  DEC ECX
  100044b6  CMP EAX,ECX
  100044b8  JNZ 0x100044c4    ; LAB_100044c4
  100044ba  MOV byte ptr [0x1000f604],0x1    ; DAT_1000f604
  100044c1  MOV dword ptr [ESI + 0x18],EBX
LAB_100044c4:
  100044c4  LEA EDI,[EBP + -0x14]
  100044c7  OR ECX,0xffffffff
  100044ca  XOR EAX,EAX
  100044cc  SCASB.REPNE ES:EDI
  100044ce  MOV EAX,dword ptr [ESI + 0x14]
  100044d1  POP EDI
  100044d2  NOT ECX
  100044d4  DEC ECX
  100044d5  CMP EAX,ECX
  100044d7  JNZ 0x10004513    ; LAB_10004513
  100044d9  PUSH 0x1a4
  100044de  CALL 0x100051a2    ; operator_new
  100044e3  ADD ESP,0x4
  100044e6  MOV dword ptr [EBP + 0x8],EAX
  100044e9  CMP EAX,EBX
  100044eb  MOV dword ptr [EBP + -0x4],EBX
  100044ee  JZ 0x100044fd    ; LAB_100044fd
  100044f0  MOV EDX,dword ptr [ESI + 0x4]
  100044f3  MOV ECX,EAX
  100044f5  PUSH EDX
  100044f6  CALL 0x100026c0    ; FUN_100026c0
  100044fb  JMP 0x100044ff    ; LAB_100044ff
LAB_100044fd:
  100044fd  XOR EAX,EAX
LAB_100044ff:
  100044ff  MOV ECX,dword ptr [ESI + 0x4]
  10004502  PUSH EAX
  10004503  PUSH ESI
  10004504  MOV dword ptr [EBP + -0x4],0xffffffff
  1000450b  CALL 0x10001db0    ; FUN_10001db0
  10004510  MOV dword ptr [ESI + 0x14],EBX
LAB_10004513:
  10004513  MOV ECX,dword ptr [EBP + -0xc]
  10004516  POP ESI
  10004517  XOR EAX,EAX
  10004519  POP EBX
  1000451a  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  10004521  MOV ESP,EBP
  10004523  POP EBP
  10004524  RET 0x4

;==== FUNCTION FUN_10004530 @ 10004530 : undefined4 FUN_10004530(int param_1)
  10004530  PUSH ESI
  10004531  MOV ESI,ECX
  10004533  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  10004539  MOV EDX,dword ptr [ESI + 0x4]
  1000453c  MOV EAX,dword ptr [ECX]
  1000453e  MOV EDX,dword ptr [EDX + 0xac]
  10004544  PUSH EDX
  10004545  CALL dword ptr [EAX + 0x18]
  10004548  MOV EAX,dword ptr [ESI + 0x4]
  1000454b  PUSH 0x0
  1000454d  PUSH 0x0
  1000454f  PUSH 0x0
  10004551  MOV byte ptr [EAX + 0xb4],0x1
  10004558  MOV ECX,dword ptr [ESI + 0x4]
  1000455b  MOV ECX,dword ptr [ECX + 0xac]
  10004561  MOV EDX,dword ptr [ECX]
  10004563  CALL dword ptr [EDX + 0x8]
  10004566  MOV EAX,dword ptr [ESI + 0x4]
  10004569  MOV ECX,dword ptr [EAX + 0xac]
  1000456f  MOV EDX,dword ptr [ECX]
  10004571  CALL dword ptr [EDX + 0x2c]
  10004574  MOV EAX,[0x1000f5cc]    ; DAT_1000f5cc
  10004579  PUSH 0x0
  1000457b  MOV ECX,dword ptr [EAX + 0xd4]
  10004581  MOV EDX,dword ptr [ECX]
  10004583  CALL dword ptr [EDX + 0x8]
  10004586  MOV ECX,dword ptr [ESI + 0x1c]
  10004589  MOV EAX,dword ptr [ECX]
  1000458b  CALL dword ptr [EAX + 0x8]
  1000458e  XOR EAX,EAX
  10004590  POP ESI
  10004591  RET 0x4

;==== FUNCTION FUN_100045a0 @ 100045a0 : undefined4 FUN_100045a0(void * this, int param_1)
  100045a0  PUSH EBP
  100045a1  MOV EBP,ESP
  100045a3  MOV EAX,FS:[0x0]    ; ExceptionList
  100045a9  PUSH -0x1
  100045ab  PUSH 0x1000c74b    ; LAB_1000c74b
  100045b0  PUSH EAX
  100045b1  MOV EAX,dword ptr [EBP + 0x8]
  100045b4  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  100045bb  PUSH ESI
  100045bc  MOV ESI,ECX
  100045be  CMP dword ptr [EAX + 0x8],0xbb8
  100045c5  JBE 0x10004623    ; LAB_10004623
  100045c7  MOV EAX,dword ptr [ESI + 0x4]
  100045ca  MOV ECX,dword ptr [0x1000f5bc]    ; DAT_1000f5bc
  100045d0  MOV EAX,dword ptr [EAX + 0xac]
  100045d6  MOV EDX,dword ptr [ECX]
  100045d8  PUSH EAX
  100045d9  CALL dword ptr [EDX + 0x1c]
  100045dc  MOV ECX,dword ptr [ESI + 0x4]
  100045df  PUSH 0x1e8
  100045e4  MOV byte ptr [ECX + 0xb4],0x0
  100045eb  CALL 0x100051a2    ; operator_new
  100045f0  ADD ESP,0x4
  100045f3  MOV dword ptr [EBP + 0x8],EAX
  100045f6  TEST EAX,EAX
  100045f8  MOV dword ptr [EBP + -0x4],0x0
  100045ff  JZ 0x10004610    ; LAB_10004610
  10004601  MOV EDX,dword ptr [ESI + 0x4]
  10004604  PUSH 0x1
  10004606  PUSH EDX
  10004607  MOV ECX,EAX
  10004609  CALL 0x10002a80    ; FUN_10002a80
  1000460e  JMP 0x10004612    ; LAB_10004612
LAB_10004610:
  10004610  XOR EAX,EAX
LAB_10004612:
  10004612  MOV ECX,dword ptr [ESI + 0x4]
  10004615  PUSH EAX
  10004616  PUSH ESI
  10004617  MOV dword ptr [EBP + -0x4],0xffffffff
  1000461e  CALL 0x10001db0    ; FUN_10001db0
LAB_10004623:
  10004623  MOV ECX,dword ptr [EBP + -0xc]
  10004626  XOR EAX,EAX
  10004628  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  1000462f  POP ESI
  10004630  MOV ESP,EBP
  10004632  POP EBP
  10004633  RET 0x4

;==== FUNCTION FUN_10004640 @ 10004640 : undefined FUN_10004640(void)
  10004640  PUSH EBP
  10004641  MOV EBP,ESP
  10004643  SUB ESP,0xd0
  10004649  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  1000464f  LEA EDX,[EBP + 0xffffff30]
  10004655  PUSH EDX
  10004656  PUSH 0x1000e998    ; s_Score1Name_1000e998
  1000465b  MOV EAX,dword ptr [ECX]
  1000465d  CALL dword ptr [EAX + 0x14]
  10004660  CMP EAX,0x19
  10004663  JNZ 0x1000473b    ; LAB_1000473b
  10004669  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  1000466f  PUSH 0x1000e990    ; s_ZapSpot_1000e990
  10004674  PUSH 0x1000e998    ; s_Score1Name_1000e998
  10004679  MOV EAX,dword ptr [ECX]
  1000467b  CALL dword ptr [EAX + 0x10]
  1000467e  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  10004684  PUSH 0x1000e988    ; s_10000_1000e988
  10004689  PUSH 0x1000e97c    ; s_Score1Score_1000e97c
  1000468e  MOV EDX,dword ptr [ECX]
  10004690  CALL dword ptr [EDX + 0x10]
  10004693  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  10004699  PUSH 0x1000e990    ; s_ZapSpot_1000e990
  1000469e  PUSH 0x1000e970    ; s_Score2Name_1000e970
  100046a3  MOV EAX,dword ptr [ECX]
  100046a5  CALL dword ptr [EAX + 0x10]
  100046a8  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  100046ae  PUSH 0x1000e968    ; DAT_1000e968
  100046b3  PUSH 0x1000e95c    ; s_Score2Score_1000e95c
  100046b8  MOV EDX,dword ptr [ECX]
  100046ba  CALL dword ptr [EDX + 0x10]
  100046bd  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  100046c3  PUSH 0x1000e990    ; s_ZapSpot_1000e990
  100046c8  PUSH 0x1000e950    ; s_Score3Name_1000e950
  100046cd  MOV EAX,dword ptr [ECX]
  100046cf  CALL dword ptr [EAX + 0x10]
  100046d2  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  100046d8  PUSH 0x1000e948    ; DAT_1000e948
  100046dd  PUSH 0x1000e93c    ; s_Score3Score_1000e93c
  100046e2  MOV EDX,dword ptr [ECX]
  100046e4  CALL dword ptr [EDX + 0x10]
  100046e7  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  100046ed  PUSH 0x1000e990    ; s_ZapSpot_1000e990
  100046f2  PUSH 0x1000e930    ; s_Score4Name_1000e930
  100046f7  MOV EAX,dword ptr [ECX]
  100046f9  CALL dword ptr [EAX + 0x10]
  100046fc  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  10004702  PUSH 0x1000e928    ; DAT_1000e928
  10004707  PUSH 0x1000e91c    ; s_Score4Score_1000e91c
  1000470c  MOV EDX,dword ptr [ECX]
  1000470e  CALL dword ptr [EDX + 0x10]
  10004711  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  10004717  PUSH 0x1000e990    ; s_ZapSpot_1000e990
  1000471c  PUSH 0x1000e910    ; s_Score5Name_1000e910
  10004721  MOV EAX,dword ptr [ECX]
  10004723  CALL dword ptr [EAX + 0x10]
  10004726  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  1000472c  PUSH 0x1000e90c    ; DAT_1000e90c
  10004731  PUSH 0x1000e900    ; s_Score5Score_1000e900
  10004736  MOV EDX,dword ptr [ECX]
  10004738  CALL dword ptr [EDX + 0x10]
LAB_1000473b:
  1000473b  PUSH EBX
  1000473c  PUSH ESI
  1000473d  PUSH EDI
  1000473e  MOV ESI,0xd4
LAB_10004743:
  10004743  MOV EAX,[0x1000f5b8]    ; DAT_1000f5b8
  10004748  PUSH ESI
  10004749  PUSH 0x32
  1000474b  PUSH 0x1000e8c8    ; s_<s3><c000000><b>._._._._._._._._._1000e8c8
  10004750  PUSH EAX
  10004751  CALL 0x10004a00    ; FUN_10004a00
  10004756  ADD ESI,0x11
  10004759  ADD ESP,0x10
  1000475c  CMP ESI,0x129
  10004762  JL 0x10004743    ; LAB_10004743
  10004764  MOV ESI,0x1
  10004769  MOV dword ptr [EBP + -0x4],0xd4
  10004770  MOV dword ptr [EBP + -0x8],ESI
  10004773  JMP 0x10004778    ; LAB_10004778
LAB_10004775:
  10004775  MOV ESI,dword ptr [EBP + -0x8]
LAB_10004778:
  10004778  PUSH ESI
  10004779  LEA ECX,[EBP + -0x24]
  1000477c  PUSH 0x1000e548    ; s_Score%dName_1000e548
  10004781  PUSH ECX
  10004782  CALL 0x100051b0    ; FUN_100051b0
  10004787  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  1000478d  ADD ESP,0xc
  10004790  LEA EAX,[EBP + 0xffffff30]
  10004796  MOV EDX,dword ptr [ECX]
  10004798  PUSH EAX
  10004799  LEA EAX,[EBP + -0x24]
  1000479c  PUSH EAX
  1000479d  CALL dword ptr [EDX + 0x14]
  100047a0  PUSH ESI
  100047a1  LEA ECX,[EBP + -0x24]
  100047a4  PUSH 0x1000e61c    ; s_Score%dScore_1000e61c
  100047a9  PUSH ECX
  100047aa  CALL 0x100051b0    ; FUN_100051b0
  100047af  MOV ECX,dword ptr [0x1000f5c4]    ; DAT_1000f5c4
  100047b5  ADD ESP,0xc
  100047b8  LEA EAX,[EBP + -0x38]
  100047bb  MOV EDX,dword ptr [ECX]
  100047bd  PUSH EAX
  100047be  LEA EAX,[EBP + -0x24]
  100047c1  PUSH EAX
  100047c2  CALL dword ptr [EDX + 0x14]
  100047c5  LEA ECX,[EBP + -0x38]
  100047c8  PUSH ECX
  100047c9  CALL 0x100056e2    ; FUN_100056e2
  100047ce  LEA EDX,[EBP + 0xffffff30]
  100047d4  MOV EBX,EAX
  100047d6  PUSH EDX
  100047d7  LEA EAX,[EBP + 0xffffff64]
  100047dd  PUSH 0x1000e8c4    ; DAT_1000e8c4
  100047e2  PUSH EAX
  100047e3  CALL 0x100051b0    ; FUN_100051b0
  100047e8  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  100047ee  ADD ESP,0x10
  100047f1  MOV EDX,dword ptr [ECX]
  100047f3  PUSH 0x1
  100047f5  PUSH 0xc
  100047f7  PUSH 0x1000e290    ; s_Arial_1000e290
  100047fc  CALL dword ptr [EDX + 0x28]
  100047ff  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10004805  MOV ESI,EAX
  10004807  PUSH ESI
  10004808  MOV EAX,dword ptr [ECX]
  1000480a  CALL dword ptr [EAX + 0x48]
  1000480d  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10004813  LEA EAX,[EBP + -0x10]
  10004816  PUSH EAX
  10004817  LEA EDI,[EBP + 0xffffff64]
  1000481d  MOV EDX,dword ptr [ECX]
  1000481f  OR ECX,0xffffffff
  10004822  XOR EAX,EAX
  10004824  SCASB.REPNE ES:EDI
  10004826  NOT ECX
  10004828  DEC ECX
  10004829  PUSH ECX
  1000482a  LEA ECX,[EBP + 0xffffff64]
  10004830  PUSH ECX
  10004831  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10004837  PUSH ESI
  10004838  CALL dword ptr [EDX + 0x58]
  1000483b  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10004841  PUSH 0xff
  10004846  PUSH 0x99
  1000484b  PUSH 0x33
  1000484d  MOV EDX,dword ptr [ECX]
  1000484f  CALL dword ptr [EDX + 0x1c]
  10004852  MOV EAX,dword ptr [EBP + -0x4]
  10004855  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  1000485b  LEA EDI,[EAX + 0x11]
  1000485e  MOV EAX,dword ptr [EBP + -0x10]
  10004861  MOV EDX,dword ptr [ECX]
  10004863  ADD EAX,0x3a
  10004866  PUSH EDI
  10004867  PUSH EAX
  10004868  MOV EAX,dword ptr [EBP + -0x4]
  1000486b  PUSH EAX
  1000486c  PUSH 0x32
  1000486e  CALL dword ptr [EDX + 0x10]
  10004871  MOV EDX,dword ptr [ESI]
  10004873  MOV ECX,ESI
  10004875  CALL dword ptr [EDX + 0x4]
  10004878  LEA EAX,[EBP + 0xffffff30]
  1000487e  LEA ECX,[EBP + 0xffffff64]
  10004884  PUSH EAX
  10004885  PUSH 0x1000e8ac    ; s_<s3><b><c000000>%s</b>_1000e8ac
  1000488a  PUSH ECX
  1000488b  CALL 0x100051b0    ; FUN_100051b0
  10004890  MOV ESI,dword ptr [EBP + -0x4]
  10004893  MOV EAX,[0x1000f5b8]    ; DAT_1000f5b8
  10004898  PUSH ESI
  10004899  LEA EDX,[EBP + 0xffffff64]
  1000489f  PUSH 0x32
  100048a1  PUSH EDX
  100048a2  PUSH EAX
  100048a3  CALL 0x10004a00    ; FUN_10004a00
  100048a8  ADD ESP,0x1c
  100048ab  CMP EBX,0xf423f
  100048b1  JLE 0x10004902    ; LAB_10004902
  100048b3  MOV EAX,EBX
  100048b5  MOV ECX,0x3e8
  100048ba  CDQ
  100048bb  IDIV ECX
  100048bd  MOV EAX,0x10624dd3
  100048c2  PUSH EDX
  100048c3  IMUL EBX
  100048c5  SAR EDX,0x6
  100048c8  MOV ECX,EDX
  100048ca  MOV EAX,EDX
  100048cc  SHR ECX,0x1f
  100048cf  ADD EAX,ECX
  100048d1  MOV ECX,0x3e8
  100048d6  CDQ
  100048d7  IDIV ECX
  100048d9  MOV EAX,0x431bde83
  100048de  LEA ECX,[EBP + 0xffffff64]
  100048e4  PUSH EDX
  100048e5  IMUL EBX
  100048e7  SAR EDX,0x12
  100048ea  MOV EAX,EDX
  100048ec  SHR EAX,0x1f
  100048ef  ADD EDX,EAX
  100048f1  PUSH EDX
  100048f2  PUSH 0x1000e888    ; s_<s3><b><c000000>%d,%03d,%03d</b>_1000e888
  100048f7  PUSH ECX
  100048f8  CALL 0x100051b0    ; FUN_100051b0
  100048fd  ADD ESP,0x14
  10004900  JMP 0x10004952    ; LAB_10004952
LAB_10004902:
  10004902  CMP EBX,0x3e7
  10004908  JLE 0x1000493d    ; LAB_1000493d
  1000490a  MOV EAX,EBX
  1000490c  MOV ECX,0x3e8
  10004911  CDQ
  10004912  IDIV ECX
  10004914  MOV EAX,0x10624dd3
  10004919  LEA ECX,[EBP + 0xffffff64]
  1000491f  PUSH EDX
  10004920  IMUL EBX
  10004922  SAR EDX,0x6
  10004925  MOV EAX,EDX
  10004927  SHR EAX,0x1f
  1000492a  ADD EDX,EAX
  1000492c  PUSH EDX
  1000492d  PUSH 0x1000e86c    ; s_<s3><b><c000000>%d,%03d</b>_1000e86c
  10004932  PUSH ECX
  10004933  CALL 0x100051b0    ; FUN_100051b0
  10004938  ADD ESP,0x10
  1000493b  JMP 0x10004952    ; LAB_10004952
LAB_1000493d:
  1000493d  PUSH EBX
  1000493e  LEA EDX,[EBP + 0xffffff64]
  10004944  PUSH 0x1000e854    ; s_<s3><b><c000000>%d</b>_1000e854
  10004949  PUSH EDX
  1000494a  CALL 0x100051b0    ; FUN_100051b0
  1000494f  ADD ESP,0xc
LAB_10004952:
  10004952  MOV ECX,dword ptr [0x1000f5b8]    ; DAT_1000f5b8
  10004958  PUSH ESI
  10004959  LEA EAX,[EBP + 0xffffff64]
  1000495f  PUSH 0x9b
  10004964  PUSH EAX
  10004965  PUSH ECX
  10004966  CALL 0x10004a00    ; FUN_10004a00
  1000496b  MOV EAX,dword ptr [EBP + -0x8]
  1000496e  ADD ESP,0x10
  10004971  INC EAX
  10004972  MOV dword ptr [EBP + -0x4],EDI
  10004975  MOV dword ptr [EBP + -0x8],EAX
  10004978  DEC EAX
  10004979  CMP EAX,0x5
  1000497c  JL 0x10004775    ; LAB_10004775
  10004982  POP EDI
  10004983  POP ESI
  10004984  POP EBX
  10004985  MOV ESP,EBP
  10004987  POP EBP
  10004988  RET

;==== FUNCTION FUN_10004990 @ 10004990 : undefined FUN_10004990(int * param_1)
  10004990  PUSH EBP
  10004991  MOV EBP,ESP
  10004993  MOV EAX,dword ptr [EBP + 0x8]
  10004996  PUSH EAX
  10004997  MOV ECX,dword ptr [EAX]
  10004999  CALL 0x10004530    ; FUN_10004530
  1000499e  POP EBP
  1000499f  RET

;==== FUNCTION FUN_100049a0 @ 100049a0 : undefined FUN_100049a0(undefined4 * param_1)
  100049a0  PUSH EBP
  100049a1  MOV EBP,ESP
  100049a3  MOV EAX,dword ptr [EBP + 0x8]
  100049a6  PUSH EAX
  100049a7  MOV ECX,dword ptr [EAX]
  100049a9  CALL 0x100043f0    ; FUN_100043f0
  100049ae  POP EBP
  100049af  RET

;==== FUNCTION FUN_100049b0 @ 100049b0 : undefined FUN_100049b0(undefined4 * param_1)
  100049b0  PUSH EBP
  100049b1  MOV EBP,ESP
  100049b3  MOV EAX,dword ptr [EBP + 0x8]
  100049b6  PUSH EAX
  100049b7  MOV ECX,dword ptr [EAX]
  100049b9  CALL 0x100045a0    ; FUN_100045a0
  100049be  POP EBP
  100049bf  RET

;==== FUNCTION FUN_100049c0 @ 100049c0 : int FUN_100049c0(char param_1)
  100049c0  PUSH EBP
  100049c1  MOV EBP,ESP
  100049c3  MOV AL,byte ptr [EBP + 0x8]
  100049c6  CMP AL,0x61
  100049c8  JL 0x100049d6    ; LAB_100049d6
  100049ca  CMP AL,0x66
  100049cc  JG 0x100049d6    ; LAB_100049d6
  100049ce  MOVSX EAX,AL
  100049d1  SUB EAX,0x57
  100049d4  POP EBP
  100049d5  RET
LAB_100049d6:
  100049d6  CMP AL,0x30
  100049d8  JL 0x100049e6    ; LAB_100049e6
  100049da  CMP AL,0x39
  100049dc  JG 0x100049e6    ; LAB_100049e6
  100049de  MOVSX EAX,AL
  100049e1  SUB EAX,0x30
  100049e4  POP EBP
  100049e5  RET
LAB_100049e6:
  100049e6  CMP AL,0x41
  100049e8  JL 0x100049f6    ; LAB_100049f6
  100049ea  CMP AL,0x46
  100049ec  JG 0x100049f6    ; LAB_100049f6
  100049ee  MOVSX EAX,AL
  100049f1  SUB EAX,0x37
  100049f4  POP EBP
  100049f5  RET
LAB_100049f6:
  100049f6  XOR EAX,EAX
  100049f8  POP EBP
  100049f9  RET

;==== FUNCTION FUN_10004a00 @ 10004a00 : undefined4 FUN_10004a00(int * param_1, byte * param_2, int * param_3, undefined4 param_4)
  10004a00  PUSH EBP
  10004a01  MOV EBP,ESP
  10004a03  MOV EAX,0x5e7c
  10004a08  CALL 0x10005600    ; FUN_10005600
  10004a0d  PUSH EBX
  10004a0e  PUSH ESI
  10004a0f  MOV ESI,dword ptr [EBP + 0xc]
  10004a12  PUSH EDI
  10004a13  MOV EDI,ESI
  10004a15  OR ECX,0xffffffff
  10004a18  XOR EAX,EAX
  10004a1a  SCASB.REPNE ES:EDI
  10004a1c  NOT ECX
  10004a1e  MOV dword ptr [EBP + -0x10],EAX
  10004a21  MOV EAX,dword ptr [EBP + 0x10]
  10004a24  DEC ECX
  10004a25  MOV dword ptr [EBP + -0x20],EAX
  10004a28  MOV AL,byte ptr [ESI]
  10004a2a  MOV dword ptr [EBP + -0x24],ECX
  10004a2d  MOV ECX,dword ptr [EBP + 0x14]
  10004a30  TEST AL,AL
  10004a32  MOV dword ptr [EBP + -0x1c],ECX
  10004a35  JZ 0x10004b19    ; LAB_10004b19
  10004a3b  LEA EBX,[EBP + 0xffffa188]
  10004a41  LEA EDX,[EBP + 0xffffa184]
  10004a47  LEA ECX,[EBP + 0xffffa18c]
  10004a4d  MOV dword ptr [EBP + 0x10],EBX
  10004a50  MOV dword ptr [EBP + -0x14],EDX
  10004a53  MOV dword ptr [EBP + 0xc],ECX
LAB_10004a56:
  10004a56  XOR EDI,EDI
  10004a58  CMP AL,0x3c
  10004a5a  MOV dword ptr [EBP + -0x18],EDI
  10004a5d  JZ 0x10004aa5    ; LAB_10004aa5
  10004a5f  PUSH 0x1000ea14    ; DAT_1000ea14
  10004a64  PUSH ESI
  10004a65  CALL 0x100057b0    ; FUN_100057b0
  10004a6a  MOV EDX,dword ptr [EBP + 0xc]
  10004a6d  MOV EDI,EAX
  10004a6f  ADD ESP,0x8
  10004a72  MOV AL,byte ptr [EDI + ESI*0x1]
  10004a75  MOV dword ptr [EDX],0x0
  10004a7b  CMP AL,0x20
  10004a7d  MOV dword ptr [EBX],EDI
  10004a7f  JNZ 0x10004a84    ; LAB_10004a84
  10004a81  INC EDI
  10004a82  MOV dword ptr [EBX],EDI
LAB_10004a84:
  10004a84  MOV EAX,dword ptr [EBP + -0x14]
  10004a87  MOV ECX,dword ptr [EBP + -0x10]
  10004a8a  MOV EDX,dword ptr [EBP + 0xc]
  10004a8d  INC ECX
  10004a8e  MOV dword ptr [EAX],ESI
  10004a90  ADD EDX,0xc
  10004a93  ADD EAX,0xc
  10004a96  ADD EBX,0xc
  10004a99  MOV dword ptr [EBP + -0x10],ECX    ; DAT_1000ea15
  10004a9c  MOV dword ptr [EBP + 0xc],EDX
  10004a9f  MOV dword ptr [EBP + -0x14],EAX
  10004aa2  MOV dword ptr [EBP + 0x10],EBX
LAB_10004aa5:
  10004aa5  CMP EDI,dword ptr [EBP + -0x24]
  10004aa8  JGE 0x10004b07    ; LAB_10004b07
  10004aaa  CMP byte ptr [EDI + ESI*0x1],0x20
  10004aae  JNZ 0x10004ab9    ; LAB_10004ab9
LAB_10004ab0:
  10004ab0  MOV AL,byte ptr [EDI + ESI*0x1 + 0x1]
  10004ab4  INC EDI
  10004ab5  CMP AL,0x20
  10004ab7  JZ 0x10004ab0    ; LAB_10004ab0
LAB_10004ab9:
  10004ab9  CMP byte ptr [EDI + ESI*0x1],0x3c
  10004abd  JNZ 0x10004b07    ; LAB_10004b07
  10004abf  INC ESI
  10004ac0  PUSH 0x1000ea10    ; DAT_1000ea10
  10004ac5  LEA EBX,[EDI + ESI*0x1]
  10004ac8  PUSH EBX
  10004ac9  CALL 0x100057b0    ; FUN_100057b0
  10004ace  MOV ECX,dword ptr [EBP + 0xc]
  10004ad1  MOV EDX,dword ptr [EBP + -0x14]
  10004ad4  ADD EDX,0xc
  10004ad7  ADD ESP,0x8
  10004ada  MOV dword ptr [ECX],0x1
  10004ae0  MOV dword ptr [EDX + -0xc],EBX
  10004ae3  MOV EBX,dword ptr [EBP + 0x10]
  10004ae6  MOV dword ptr [EBP + -0x14],EDX
  10004ae9  MOV EDX,dword ptr [EBP + 0x10]
  10004aec  ADD ECX,0xc
  10004aef  MOV dword ptr [EBX],EAX
  10004af1  MOV EBX,dword ptr [EBP + -0x10]
  10004af4  INC EBX
  10004af5  ADD EDX,0xc
  10004af8  INC EAX
  10004af9  MOV dword ptr [EBP + -0x10],EBX    ; DAT_1000ea11
  10004afc  MOV dword ptr [EBP + 0xc],ECX
  10004aff  MOV dword ptr [EBP + 0x10],EDX
  10004b02  MOV dword ptr [EBP + -0x18],EAX
  10004b05  MOV EBX,EDX
LAB_10004b07:
  10004b07  MOV EAX,dword ptr [EBP + -0x18]
  10004b0a  ADD EDI,EAX
  10004b0c  MOV AL,byte ptr [ESI + EDI*0x1]
  10004b0f  ADD ESI,EDI
  10004b11  TEST AL,AL
  10004b13  JNZ 0x10004a56    ; LAB_10004a56
LAB_10004b19:
  10004b19  MOV EDI,dword ptr [EBP + 0x8]
  10004b1c  LEA EAX,[EBP + -0x4]
  10004b1f  PUSH EAX
  10004b20  MOV ECX,EDI
  10004b22  MOV EDX,dword ptr [EDI]
  10004b24  CALL dword ptr [EDX + 0x4c]
  10004b27  MOV EDX,dword ptr [EDI]
  10004b29  LEA EAX,[EBP + -0x34]
  10004b2c  LEA ECX,[EBP + -0x28]
  10004b2f  PUSH EAX
  10004b30  PUSH ECX
  10004b31  MOV ECX,EDI
  10004b33  CALL dword ptr [EDX + 0x50]
  10004b36  MOV ECX,dword ptr [EBP + -0x4]
  10004b39  MOV EDX,dword ptr [EDI]
  10004b3b  LEA EAX,[EBP + -0x3c]
  10004b3e  MOV byte ptr [EBP + 0x13],0x0
  10004b42  PUSH EAX
  10004b43  PUSH 0x4
  10004b45  PUSH 0x1000ea08    ; DAT_1000ea08
  10004b4a  PUSH ECX
  10004b4b  MOV ECX,EDI
  10004b4d  CALL dword ptr [EDX + 0x58]
  10004b50  MOV EAX,dword ptr [EBP + -0x10]
  10004b53  TEST EAX,EAX
  10004b55  JLE 0x10004e03    ; LAB_10004e03
  10004b5b  LEA ECX,[EBP + 0xffffa188]
  10004b61  MOV dword ptr [EBP + -0x18],EAX
  10004b64  MOV dword ptr [EBP + 0x8],ECX
LAB_10004b67:
  10004b67  MOV ESI,dword ptr [ECX + -0x4]
  10004b6a  MOV EBX,dword ptr [ECX]
  10004b6c  MOV EAX,dword ptr [ECX + 0x4]
  10004b6f  XOR ECX,ECX
  10004b71  SUB EAX,ECX
  10004b73  MOV byte ptr [EBP + 0xf],0x0
  10004b77  JZ 0x10004da7    ; LAB_10004da7
  10004b7d  DEC EAX
  10004b7e  JNZ 0x10004ded    ; switchD_10004ba5::caseD_44
  10004b84  CMP byte ptr [ESI],0x2f
  10004b87  JNZ 0x10004b8e    ; LAB_10004b8e
  10004b89  MOV byte ptr [EBP + 0xf],0x1
  10004b8d  INC ESI
LAB_10004b8e:
  10004b8e  MOVSX EAX,byte ptr [ESI]
  10004b91  ADD EAX,-0x42
  10004b94  CMP EAX,0x33
  10004b97  JA 0x10004ded    ; switchD_10004ba5::caseD_44
  10004b9d  XOR EDX,EDX
  10004b9f  MOV DL,byte ptr [EAX + 0x10004e30]    ; switchD_10004ba5::switchdataD_10004e30
switchD:
  10004ba5  JMP dword ptr [EDX*0x4 + 0x10004e14]    ; switchD_10004ba5::caseD_42 switchD_10004ba5::caseD_43 switchD_10004ba5::caseD_44 switchD_10004ba5::caseD_49 switchD_10004ba5::caseD_50 switchD_10004ba5::caseD_53 switchD_10004ba5::caseD_55 switchD_10004ba5::switchdataD_10004e14
caseD_50:
  10004bac  MOV EAX,dword ptr [EBP + -0x1c]
  10004baf  MOV dword ptr [EBP + -0x20],ECX
  10004bb2  ADD EAX,0x1e
  10004bb5  MOV dword ptr [EBP + -0x1c],EAX
  10004bb8  JMP 0x10004ded    ; switchD_10004ba5::caseD_44
caseD_42:
  10004bbd  MOV AL,byte ptr [ESI + 0x1]
  10004bc0  CMP AL,0x72
  10004bc2  JZ 0x10004bf5    ; LAB_10004bf5
  10004bc4  CMP AL,0x52
  10004bc6  JZ 0x10004bf5    ; LAB_10004bf5
  10004bc8  MOV ECX,dword ptr [EBP + -0x4]
  10004bcb  LEA EDX,[EBP + 0x14]
  10004bce  PUSH EDX
  10004bcf  LEA EDX,[EBP + -0x8]
  10004bd2  MOV EAX,dword ptr [ECX]
  10004bd4  PUSH EDX
  10004bd5  LEA EDX,[EBP + -0xc]
  10004bd8  PUSH EDX
  10004bd9  LEA EDX,[EBP + 0xffffff44]
  10004bdf  PUSH EDX
  10004be0  CALL dword ptr [EAX + 0xc]
  10004be3  MOV AL,byte ptr [EBP + 0xf]
  10004be6  TEST AL,AL
  10004be8  MOV EAX,dword ptr [EBP + 0x14]
  10004beb  JZ 0x10004bf1    ; LAB_10004bf1
  10004bed  AND AL,0xfe
  10004bef  JMP 0x10004c31    ; LAB_10004c31
LAB_10004bf1:
  10004bf1  OR AL,0x1
  10004bf3  JMP 0x10004c31    ; LAB_10004c31
LAB_10004bf5:
  10004bf5  MOV EAX,dword ptr [EBP + -0x1c]
  10004bf8  MOV dword ptr [EBP + -0x20],ECX
  10004bfb  ADD EAX,0xf
  10004bfe  MOV dword ptr [EBP + -0x1c],EAX
  10004c01  JMP 0x10004ded    ; switchD_10004ba5::caseD_44
caseD_49:
  10004c06  MOV ECX,dword ptr [EBP + -0x4]
  10004c09  LEA EDX,[EBP + 0x14]
  10004c0c  PUSH EDX
  10004c0d  LEA EDX,[EBP + -0x8]
  10004c10  MOV EAX,dword ptr [ECX]
  10004c12  PUSH EDX
  10004c13  LEA EDX,[EBP + -0xc]
  10004c16  PUSH EDX
  10004c17  LEA EDX,[EBP + 0xffffff44]
  10004c1d  PUSH EDX
  10004c1e  CALL dword ptr [EAX + 0xc]
  10004c21  MOV AL,byte ptr [EBP + 0xf]
  10004c24  TEST AL,AL
  10004c26  MOV EAX,dword ptr [EBP + 0x14]
  10004c29  JZ 0x10004c2f    ; LAB_10004c2f
  10004c2b  AND AL,0xfd
  10004c2d  JMP 0x10004c31    ; LAB_10004c31
LAB_10004c2f:
  10004c2f  OR AL,0x2
LAB_10004c31:
  10004c31  MOV ECX,dword ptr [EBP + -0x4]
  10004c34  MOV dword ptr [EBP + 0x14],EAX
  10004c37  MOV EAX,dword ptr [ECX]
  10004c39  CALL dword ptr [EAX + 0x4]
  10004c3c  MOV EAX,dword ptr [EBP + 0x14]
  10004c3f  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10004c45  PUSH EAX
  10004c46  MOV EAX,dword ptr [EBP + -0xc]
  10004c49  MOV EDX,dword ptr [ECX]
  10004c4b  PUSH EAX
  10004c4c  LEA EAX,[EBP + 0xffffff44]
  10004c52  PUSH EAX
  10004c53  CALL dword ptr [EDX + 0x28]
  10004c56  MOV EDX,dword ptr [EDI]
  10004c58  PUSH EAX
  10004c59  MOV ECX,EDI
  10004c5b  MOV dword ptr [EBP + -0x4],EAX
  10004c5e  CALL dword ptr [EDX + 0x48]
  10004c61  JMP 0x10004ded    ; switchD_10004ba5::caseD_44
caseD_55:
  10004c66  MOV ECX,dword ptr [EBP + -0x4]
  10004c69  LEA EDX,[EBP + 0x14]
  10004c6c  PUSH EDX
  10004c6d  LEA EDX,[EBP + -0x8]
  10004c70  MOV EAX,dword ptr [ECX]
  10004c72  PUSH EDX
  10004c73  LEA EDX,[EBP + -0xc]
  10004c76  PUSH EDX
  10004c77  LEA EDX,[EBP + 0xffffff44]
  10004c7d  PUSH EDX
  10004c7e  CALL dword ptr [EAX + 0xc]
  10004c81  MOV AL,byte ptr [EBP + 0xf]
  10004c84  TEST AL,AL
  10004c86  MOV EAX,dword ptr [EBP + 0x14]
  10004c89  JZ 0x10004c8f    ; LAB_10004c8f
  10004c8b  AND AL,0xfb
  10004c8d  JMP 0x10004c31    ; LAB_10004c31
LAB_10004c8f:
  10004c8f  OR AL,0x4
  10004c91  JMP 0x10004c31    ; LAB_10004c31
caseD_53:
  10004c93  MOV ECX,dword ptr [EBP + -0x4]
  10004c96  LEA EDX,[EBP + 0x14]
  10004c99  PUSH EDX
  10004c9a  LEA EDX,[EBP + -0x8]
  10004c9d  MOV EAX,dword ptr [ECX]
  10004c9f  PUSH EDX
  10004ca0  LEA EDX,[EBP + -0xc]
  10004ca3  PUSH EDX
  10004ca4  LEA EDX,[EBP + 0xffffff44]
  10004caa  PUSH EDX
  10004cab  CALL dword ptr [EAX + 0xc]
  10004cae  MOV AL,byte ptr [ESI + 0x1]
  10004cb1  CMP AL,0x2d
  10004cb3  JNZ 0x10004cc5    ; LAB_10004cc5
  10004cb5  MOV EAX,dword ptr [EBP + -0x8]
  10004cb8  INC EAX
  10004cb9  CMP EAX,0x5
  10004cbc  JL 0x10004ce1    ; LAB_10004ce1
  10004cbe  MOV EAX,0x5
  10004cc3  JMP 0x10004ce1    ; LAB_10004ce1
LAB_10004cc5:
  10004cc5  CMP AL,0x2b
  10004cc7  JNZ 0x10004cdb    ; LAB_10004cdb
  10004cc9  MOV ECX,dword ptr [EBP + -0x8]
  10004ccc  XOR EDX,EDX
  10004cce  LEA EAX,[ECX + -0x1]
  10004cd1  TEST EAX,EAX
  10004cd3  SETLE DL
  10004cd6  DEC EDX
  10004cd7  AND EAX,EDX
  10004cd9  JMP 0x10004ce1    ; LAB_10004ce1
LAB_10004cdb:
  10004cdb  MOVSX EAX,AL
  10004cde  SUB EAX,0x30
LAB_10004ce1:
  10004ce1  MOV ECX,dword ptr [EBP + -0x4]
  10004ce4  MOV dword ptr [EBP + -0x8],EAX
  10004ce7  SHL EAX,0x4
  10004cea  MOV EAX,dword ptr [EAX + 0x1000e9ac]    ; DAT_1000e9fc DAT_1000e9ac
  10004cf0  MOV dword ptr [EBP + -0xc],EAX
  10004cf3  MOV EDX,dword ptr [ECX]
  10004cf5  CALL dword ptr [EDX + 0x4]
  10004cf8  MOV EDX,dword ptr [EBP + 0x14]
  10004cfb  MOV ECX,dword ptr [0x1000f5b0]    ; DAT_1000f5b0
  10004d01  PUSH EDX
  10004d02  MOV EDX,dword ptr [EBP + -0xc]
  10004d05  MOV EAX,dword ptr [ECX]
  10004d07  PUSH EDX
  10004d08  LEA EDX,[EBP + 0xffffff44]
  10004d0e  PUSH EDX
  10004d0f  CALL dword ptr [EAX + 0x28]
  10004d12  MOV EDX,dword ptr [EDI]
  10004d14  PUSH EAX
  10004d15  MOV ECX,EDI
  10004d17  MOV dword ptr [EBP + -0x4],EAX
  10004d1a  CALL dword ptr [EDX + 0x48]
  10004d1d  JMP 0x10004ded    ; switchD_10004ba5::caseD_44
caseD_43:
  10004d22  MOV BL,byte ptr [ESI + 0x1]
  10004d25  CMP BL,0x3e
  10004d28  JNZ 0x10004d38    ; LAB_10004d38
  10004d2a  MOV AL,byte ptr [EBP + 0xf]
  10004d2d  TEST AL,AL
  10004d2f  SETZ byte ptr [EBP + 0x13]
  10004d33  JMP 0x10004ded    ; switchD_10004ba5::caseD_44
LAB_10004d38:
  10004d38  MOV AL,byte ptr [ESI + 0x2]
  10004d3b  PUSH EAX
  10004d3c  CALL 0x100049c0    ; FUN_100049c0
  10004d41  MOV EDX,EAX
  10004d43  PUSH EBX
  10004d44  MOV dword ptr [EBP + 0xc],EDX
  10004d47  CALL 0x100049c0    ; FUN_100049c0
  10004d4c  MOV ECX,dword ptr [EBP + 0xc]
  10004d4f  MOV DL,byte ptr [ESI + 0x3]
  10004d52  SHL AL,0x4
  10004d55  ADD CL,AL
  10004d57  PUSH EDX
  10004d58  MOV byte ptr [EBP + -0x10],CL
  10004d5b  CALL 0x100049c0    ; FUN_100049c0
  10004d60  MOV EBX,EAX
  10004d62  MOV AL,byte ptr [ESI + 0x4]
  10004d65  PUSH EAX
  10004d66  SHL BL,0x4
  10004d69  CALL 0x100049c0    ; FUN_100049c0
  10004d6e  MOV CL,byte ptr [ESI + 0x5]
  10004d71  ADD BL,AL
  10004d73  PUSH ECX
  10004d74  MOV byte ptr [EBP + -0x14],BL
  10004d77  CALL 0x100049c0    ; FUN_100049c0
  10004d7c  MOV DL,byte ptr [ESI + 0x6]
  10004d7f  MOV EBX,EAX
  10004d81  PUSH EDX
  10004d82  SHL BL,0x4
  10004d85  CALL 0x100049c0    ; FUN_100049c0
  10004d8a  MOV EDX,dword ptr [EBP + -0x14]
  10004d8d  ADD BL,AL
  10004d8f  MOV EAX,dword ptr [EDI]
  10004d91  MOV byte ptr [EBP + -0x24],BL
  10004d94  MOV ECX,dword ptr [EBP + -0x24]
  10004d97  ADD ESP,0x18
  10004d9a  PUSH ECX
  10004d9b  MOV ECX,dword ptr [EBP + -0x10]
  10004d9e  PUSH EDX
  10004d9f  PUSH ECX
  10004da0  MOV ECX,EDI
  10004da2  CALL dword ptr [EAX + 0x24]
  10004da5  JMP 0x10004ded    ; switchD_10004ba5::caseD_44
LAB_10004da7:
  10004da7  MOV ECX,dword ptr [EBP + -0x4]
  10004daa  MOV EDX,dword ptr [EDI]
  10004dac  LEA EAX,[EBP + -0x30]
  10004daf  PUSH EAX
  10004db0  PUSH EBX
  10004db1  PUSH ESI
  10004db2  PUSH ECX
  10004db3  MOV ECX,EDI
  10004db5  CALL dword ptr [EDX + 0x58]
  10004db8  MOV AL,byte ptr [EBP + 0x13]
  10004dbb  TEST AL,AL
  10004dbd  JZ 0x10004dce    ; LAB_10004dce
  10004dbf  MOV EAX,dword ptr [EBP + -0x28]
  10004dc2  MOV EDX,dword ptr [EBP + -0x30]
  10004dc5  SUB EAX,EDX
  10004dc7  CDQ
  10004dc8  SUB EAX,EDX
  10004dca  SAR EAX,0x1
  10004dcc  JMP 0x10004dd4    ; LAB_10004dd4
LAB_10004dce:
  10004dce  MOV EDX,dword ptr [EBP + -0x20]
  10004dd1  LEA EAX,[EDX + 0x4]
LAB_10004dd4:
  10004dd4  MOV ECX,dword ptr [EBP + -0x1c]
  10004dd7  MOV EDX,dword ptr [EDI]
  10004dd9  PUSH ECX
  10004dda  PUSH EAX
  10004ddb  PUSH EBX
  10004ddc  PUSH ESI
  10004ddd  MOV ECX,EDI
  10004ddf  CALL dword ptr [EDX + 0x18]
  10004de2  MOV EDX,dword ptr [EBP + -0x30]
  10004de5  MOV EAX,dword ptr [EBP + -0x20]
  10004de8  ADD EAX,EDX
  10004dea  MOV dword ptr [EBP + -0x20],EAX
caseD_44:
  10004ded  MOV ECX,dword ptr [EBP + 0x8]
  10004df0  MOV EAX,dword ptr [EBP + -0x18]
  10004df3  ADD ECX,0xc
  10004df6  DEC EAX
  10004df7  MOV dword ptr [EBP + 0x8],ECX
  10004dfa  MOV dword ptr [EBP + -0x18],EAX
  10004dfd  JNZ 0x10004b67    ; LAB_10004b67
LAB_10004e03:
  10004e03  MOV ECX,dword ptr [EBP + -0x4]
  10004e06  MOV EAX,dword ptr [ECX]
  10004e08  CALL dword ptr [EAX + 0x4]
  10004e0b  POP EDI
  10004e0c  POP ESI
  10004e0d  XOR EAX,EAX
  10004e0f  POP EBX
  10004e10  MOV ESP,EBP
  10004e12  POP EBP
  10004e13  RET

;==== FUNCTION FUN_10004e70 @ 10004e70 : undefined4 FUN_10004e70(undefined4 param_1)
  10004e70  PUSH EBP
  10004e71  MOV EBP,ESP
  10004e73  MOV EAX,dword ptr [EBP + 0x8]
  10004e76  MOV [0x1000f60c],EAX    ; DAT_1000f60c
  10004e7b  MOV AL,0x1
  10004e7d  POP EBP
  10004e7e  RET 0xc

;==== FUNCTION FUN_10004e90 @ 10004e90 : undefined4 * FUN_10004e90(void * this, LPCSTR param_1)
  10004e90  PUSH EBP
  10004e91  MOV EBP,ESP
  10004e93  PUSH EBX
  10004e94  MOV EBX,dword ptr [EBP + 0x8]
  10004e97  PUSH ESI
  10004e98  MOV ESI,ECX
  10004e9a  PUSH EDI
  10004e9b  PUSH 0xa
  10004e9d  MOV dword ptr [ESI],0x0
  10004ea3  MOV dword ptr [ESI + 0x8],0x0
  10004eaa  MOV byte ptr [ESI + 0xc],0x0
  10004eae  MOV EAX,[0x1000f60c]    ; DAT_1000f60c
  10004eb3  PUSH EBX
  10004eb4  PUSH EAX
  10004eb5  CALL dword ptr [0x1000d01c]    ; PTR_FindResourceA_1000d01c KERNEL32.DLL::FindResourceA
  10004ebb  MOV EDI,EAX
  10004ebd  TEST EDI,EDI
  10004ebf  JNZ 0x10004f1e    ; LAB_10004f1e
  10004ec1  PUSH EAX
  10004ec2  PUSH 0x80
  10004ec7  PUSH 0x3
  10004ec9  PUSH EAX
  10004eca  PUSH EAX
  10004ecb  PUSH 0x80000000
  10004ed0  PUSH EBX
  10004ed1  CALL dword ptr [0x1000d018]    ; PTR_CreateFileA_1000d018 KERNEL32.DLL::CreateFileA
  10004ed7  MOV EDI,EAX
  10004ed9  CMP EDI,-0x1
  10004edc  JZ 0x10004f51    ; LAB_10004f51
  10004ede  PUSH 0x0
  10004ee0  PUSH EDI
  10004ee1  CALL dword ptr [0x1000d014]    ; PTR_GetFileSize_1000d014 KERNEL32.DLL::GetFileSize
  10004ee7  MOV dword ptr [ESI + 0x4],EAX
  10004eea  ADD EAX,0x2
  10004eed  PUSH EAX
  10004eee  CALL 0x100051a2    ; operator_new
  10004ef3  MOV EDX,dword ptr [ESI + 0x4]
  10004ef6  ADD ESP,0x4
  10004ef9  LEA ECX,[EBP + 0x8]
  10004efc  MOV dword ptr [ESI],EAX
  10004efe  PUSH 0x0
  10004f00  PUSH ECX
  10004f01  PUSH EDX
  10004f02  PUSH EAX
  10004f03  PUSH EDI
  10004f04  CALL dword ptr [0x1000d010]    ; PTR_ReadFile_1000d010 KERNEL32.DLL::ReadFile
  10004f0a  PUSH EDI
  10004f0b  CALL dword ptr [0x1000d00c]    ; PTR_CloseHandle_1000d00c KERNEL32.DLL::CloseHandle
  10004f11  MOV byte ptr [ESI + 0xc],0x1
  10004f15  MOV EAX,ESI
  10004f17  POP EDI
  10004f18  POP ESI
  10004f19  POP EBX
  10004f1a  POP EBP
  10004f1b  RET 0x4
LAB_10004f1e:
  10004f1e  MOV EAX,[0x1000f60c]    ; DAT_1000f60c
  10004f23  PUSH EDI
  10004f24  PUSH EAX
  10004f25  CALL dword ptr [0x1000d008]    ; PTR_LoadResource_1000d008 KERNEL32.DLL::LoadResource
  10004f2b  TEST EAX,EAX
  10004f2d  JZ 0x10004f51    ; LAB_10004f51
  10004f2f  PUSH EAX
  10004f30  CALL dword ptr [0x1000d004]    ; PTR_LockResource_1000d004 KERNEL32.DLL::LockResource
  10004f36  TEST EAX,EAX
  10004f38  MOV dword ptr [ESI],EAX
  10004f3a  JZ 0x10004f51    ; LAB_10004f51
  10004f3c  MOV ECX,dword ptr [0x1000f60c]    ; DAT_1000f60c
  10004f42  PUSH EDI
  10004f43  PUSH ECX
  10004f44  CALL dword ptr [0x1000d06c]    ; PTR_SizeofResource_1000d06c KERNEL32.DLL::SizeofResource
  10004f4a  MOV dword ptr [ESI + 0x4],EAX
  10004f4d  MOV byte ptr [ESI + 0xc],0x1
LAB_10004f51:
  10004f51  MOV EAX,ESI
  10004f53  POP EDI
  10004f54  POP ESI
  10004f55  POP EBX
  10004f56  POP EBP
  10004f57  RET 0x4

;==== FUNCTION FUN_10004f60 @ 10004f60 : undefined4 FUN_10004f60(void)
  10004f60  XOR EAX,EAX
  10004f62  RET

;==== FUNCTION FUN_10004f70 @ 10004f70 : undefined1 FUN_10004f70(void * this, uint * param_1)
  10004f70  PUSH EBP
  10004f71  MOV EBP,ESP
  10004f73  MOV AL,byte ptr [ECX + 0xc]
  10004f76  TEST AL,AL
  10004f78  JNZ 0x10004f80    ; LAB_10004f80
  10004f7a  MOV AL,0x1
  10004f7c  POP EBP
  10004f7d  RET 0x4
LAB_10004f80:
  10004f80  MOV EDX,dword ptr [ECX]
  10004f82  PUSH ESI
  10004f83  MOV ESI,dword ptr [EBP + 0x8]
  10004f86  MOV AL,byte ptr [EDX]
  10004f88  INC EDX
  10004f89  MOV dword ptr [ECX],EDX
  10004f8b  MOV EDX,dword ptr [ECX + 0x8]
  10004f8e  INC EDX
  10004f8f  TEST ESI,ESI
  10004f91  MOV dword ptr [ECX + 0x8],EDX
  10004f94  JZ 0x10004fa6    ; LAB_10004fa6
  10004f96  PUSH EBX
  10004f97  PUSH EDI
  10004f98  MOV EDI,dword ptr [ECX + 0x4]
  10004f9b  XOR EBX,EBX
  10004f9d  CMP EDX,EDI
  10004f9f  POP EDI
  10004fa0  SETLE BL
  10004fa3  MOV dword ptr [ESI],EBX
  10004fa5  POP EBX
LAB_10004fa6:
  10004fa6  POP ESI
  10004fa7  POP EBP
  10004fa8  RET 0x4

;==== FUNCTION FUN_10004fb0 @ 10004fb0 : undefined4 FUN_10004fb0(void * this, int param_1, int param_2)
  10004fb0  PUSH EBP
  10004fb1  MOV EBP,ESP
  10004fb3  SUB ESP,0x8
  10004fb6  PUSH ESI
  10004fb7  PUSH EDI
  10004fb8  MOV EDI,ECX
  10004fba  XOR ESI,ESI
  10004fbc  MOV dword ptr [EBP + -0x8],EDI
  10004fbf  MOV AL,byte ptr [EDI + 0xc]
  10004fc2  TEST AL,AL
  10004fc4  JNZ 0x10004fd3    ; LAB_10004fd3
  10004fc6  POP EDI
  10004fc7  MOV EAX,0x1
  10004fcc  POP ESI
  10004fcd  MOV ESP,EBP
  10004fcf  POP EBP
  10004fd0  RET 0x8
LAB_10004fd3:
  10004fd3  MOV dword ptr [EBP + -0x4],0x1
LAB_10004fda:
  10004fda  MOV EAX,dword ptr [EBP + -0x4]
  10004fdd  TEST EAX,EAX
  10004fdf  JZ 0x10004ff0    ; LAB_10004ff0
  10004fe1  LEA EAX,[EBP + -0x4]
  10004fe4  MOV ECX,EDI
  10004fe6  PUSH EAX
  10004fe7  CALL 0x10004f70    ; FUN_10004f70
  10004fec  CMP AL,0x22
  10004fee  JNZ 0x10004fda    ; LAB_10004fda
LAB_10004ff0:
  10004ff0  MOV EDI,dword ptr [EBP + 0xc]
  10004ff3  PUSH EBX
  10004ff4  MOV EBX,dword ptr [EBP + 0x8]
  10004ff7  TEST EDI,EDI
  10004ff9  JLE 0x1000501a    ; LAB_1000501a
LAB_10004ffb:
  10004ffb  LEA ECX,[EBP + -0x4]
  10004ffe  PUSH ECX
  10004fff  MOV ECX,dword ptr [EBP + -0x8]
  10005002  CALL 0x10004f70    ; FUN_10004f70
  10005007  MOV ECX,dword ptr [EBP + -0x4]
  1000500a  TEST ECX,ECX
  1000500c  JZ 0x1000501a    ; LAB_1000501a
  1000500e  CMP AL,0x22
  10005010  JZ 0x1000501a    ; LAB_1000501a
  10005012  MOV byte ptr [ESI + EBX*0x1],AL
  10005015  INC ESI
  10005016  CMP ESI,EDI
  10005018  JL 0x10004ffb    ; LAB_10004ffb
LAB_1000501a:
  1000501a  MOV byte ptr [ESI + EBX*0x1],0x0
  1000501e  POP EBX
  1000501f  POP EDI
  10005020  XOR EAX,EAX
  10005022  POP ESI
  10005023  MOV ESP,EBP
  10005025  POP EBP
  10005026  RET 0x8

;==== FUNCTION FUN_10005030 @ 10005030 : undefined4 FUN_10005030(void * this, int * param_1)
  10005030  PUSH EBP
  10005031  MOV EBP,ESP
  10005033  SUB ESP,0x8
  10005036  PUSH EBX
  10005037  MOV EBX,ECX
  10005039  MOV AL,byte ptr [EBX + 0xc]
  1000503c  TEST AL,AL
  1000503e  JNZ 0x1000504c    ; LAB_1000504c
  10005040  MOV EAX,0x1
  10005045  POP EBX
  10005046  MOV ESP,EBP
  10005048  POP EBP
  10005049  RET 0x4
LAB_1000504c:
  1000504c  LEA EAX,[EBP + -0x4]
  1000504f  PUSH EAX
LAB_10005050:
  10005050  MOV ECX,EBX
  10005052  CALL 0x10004f70    ; FUN_10004f70
  10005057  CMP AL,0x20
  10005059  JZ 0x10005067    ; LAB_10005067
  1000505b  CMP AL,0xd
  1000505d  JZ 0x10005067    ; LAB_10005067
  1000505f  CMP AL,0x9
  10005061  JZ 0x10005067    ; LAB_10005067
  10005063  CMP AL,0xa
  10005065  JNZ 0x10005074    ; LAB_10005074
LAB_10005067:
  10005067  MOV ECX,dword ptr [EBP + -0x4]
  1000506a  TEST ECX,ECX
  1000506c  JLE 0x10005074    ; LAB_10005074
  1000506e  LEA ECX,[EBP + -0x4]
  10005071  PUSH ECX
  10005072  JMP 0x10005050    ; LAB_10005050
LAB_10005074:
  10005074  PUSH ESI
  10005075  MOV ESI,dword ptr [EBP + 0x8]
  10005078  PUSH EDI
  10005079  XOR EDI,EDI
  1000507b  CMP AL,0x2f
  1000507d  MOV dword ptr [EBP + -0x8],EDI
  10005080  MOV dword ptr [ESI],EDI
  10005082  JNZ 0x100050a6    ; LAB_100050a6
LAB_10005084:
  10005084  CMP AL,0xa
  10005086  JZ 0x10005097    ; LAB_10005097
LAB_10005088:
  10005088  LEA EDX,[EBP + -0x4]
  1000508b  MOV ECX,EBX
  1000508d  PUSH EDX
  1000508e  CALL 0x10004f70    ; FUN_10004f70
  10005093  CMP AL,0xa
  10005095  JNZ 0x10005088    ; LAB_10005088
LAB_10005097:
  10005097  LEA EAX,[EBP + -0x4]
  1000509a  MOV ECX,EBX
  1000509c  PUSH EAX
  1000509d  CALL 0x10004f70    ; FUN_10004f70
  100050a2  CMP AL,0x2f
  100050a4  JZ 0x10005084    ; LAB_10005084
LAB_100050a6:
  100050a6  CMP AL,0x30
  100050a8  JL 0x100050c3    ; LAB_100050c3
  100050aa  CMP AL,0x39
  100050ac  JG 0x100050c3    ; LAB_100050c3
  100050ae  MOV ECX,dword ptr [ESI]
  100050b0  MOV EDI,0x1
  100050b5  MOVSX EDX,AL
  100050b8  LEA ECX,[ECX + ECX*0x4]
  100050bb  LEA EAX,[EDX + ECX*0x2 + -0x30]
  100050bf  MOV dword ptr [ESI],EAX
  100050c1  JMP 0x100050d2    ; LAB_100050d2
LAB_100050c3:
  100050c3  TEST EDI,EDI
  100050c5  JNZ 0x100050e4    ; LAB_100050e4
  100050c7  CMP AL,0x2d
  100050c9  JNZ 0x100050d2    ; LAB_100050d2
  100050cb  MOV dword ptr [EBP + -0x8],0x1
LAB_100050d2:
  100050d2  LEA ECX,[EBP + -0x4]
  100050d5  PUSH ECX
  100050d6  MOV ECX,EBX
  100050d8  CALL 0x10004f70    ; FUN_10004f70
  100050dd  MOV ECX,dword ptr [EBP + -0x4]
  100050e0  TEST ECX,ECX
  100050e2  JNZ 0x100050a6    ; LAB_100050a6
LAB_100050e4:
  100050e4  MOV EAX,dword ptr [EBP + -0x8]
  100050e7  TEST EAX,EAX
  100050e9  JZ 0x100050f1    ; LAB_100050f1
  100050eb  MOV EDX,dword ptr [ESI]
  100050ed  NEG EDX
  100050ef  MOV dword ptr [ESI],EDX
LAB_100050f1:
  100050f1  POP EDI
  100050f2  POP ESI
  100050f3  XOR EAX,EAX
  100050f5  POP EBX
  100050f6  MOV ESP,EBP
  100050f8  POP EBP
  100050f9  RET 0x4

;==== FUNCTION __ftol @ 10005110 : longlong __ftol(void)
  10005110  PUSH EBP
  10005111  MOV EBP,ESP
  10005113  ADD ESP,-0xc
  10005116  FSTCW word ptr [EBP + -0x2]
  1000511a  WAIT
  1000511b  MOV AX,word ptr [EBP + -0x2]
  1000511f  OR AH,0xc
  10005122  MOV word ptr [EBP + -0x4],AX
  10005126  FLDCW word ptr [EBP + -0x4]
  10005129  FISTP qword ptr [EBP + -0xc]
  1000512c  FLDCW word ptr [EBP + -0x2]
  1000512f  MOV EAX,dword ptr [EBP + -0xc]
  10005132  MOV EDX,dword ptr [EBP + -0x8]
  10005135  LEAVE
  10005136  RET

;==== FUNCTION FUN_10005137 @ 10005137 : undefined FUN_10005137(void)
  10005137  CALL 0x1000514f    ; FUN_1000514f
  1000513c  CALL 0x100059c6    ; FUN_100059c6
  10005141  MOV [0x1000f614],EAX    ; DAT_1000f614
  10005146  CALL 0x10005976    ; FUN_10005976
  1000514b  FNCLEX
  1000514d  RET
LAB_1000514e:
  1000514e  RET

;==== FUNCTION FUN_1000514f @ 1000514f : undefined FUN_1000514f(void)
  1000514f  MOV EAX,0x10005db4    ; __cfltcvt
  10005154  MOV dword ptr [0x1000ea58],0x10005a49    ; PTR___fptrap_1000ea58 LAB_10005a49
  1000515e  MOV [0x1000ea54],EAX    ; PTR___fptrap_1000ea54
  10005163  MOV dword ptr [0x1000ea5c],0x10005aaf    ; PTR___fptrap_1000ea5c __fassign
  1000516d  MOV dword ptr [0x1000ea60],0x100059ef    ; PTR___fptrap_1000ea60 FUN_100059ef
  10005177  MOV dword ptr [0x1000ea64],0x10005a97    ; PTR___fptrap_1000ea64 LAB_10005a97
  10005181  MOV [0x1000ea68],EAX    ; PTR___fptrap_1000ea68
  10005186  RET

;==== FUNCTION FUN_10005197 @ 10005197 : undefined FUN_10005197(LPVOID param_1)
  10005197  PUSH dword ptr [ESP + 0x4]
  1000519b  CALL 0x10005e2a    ; FUN_10005e2a
  100051a0  POP ECX
  100051a1  RET

;==== FUNCTION operator_new @ 100051a2 : void * operator_new(uint param_1)
  100051a2  PUSH 0x1
  100051a4  PUSH dword ptr [ESP + 0x8]
  100051a8  CALL 0x10005e6b    ; __nh_malloc
  100051ad  POP ECX
  100051ae  POP ECX
  100051af  RET

;==== FUNCTION FUN_100051b0 @ 100051b0 : int FUN_100051b0(undefined1 * param_1, byte * param_2)
  100051b0  PUSH EBP
  100051b1  MOV EBP,ESP
  100051b3  SUB ESP,0x20
  100051b6  MOV EAX,dword ptr [EBP + 0x8]
  100051b9  PUSH ESI
  100051ba  MOV dword ptr [EBP + -0x18],EAX
  100051bd  MOV dword ptr [EBP + -0x20],EAX
  100051c0  LEA EAX,[EBP + 0x10]
  100051c3  MOV dword ptr [EBP + -0x14],0x42
  100051ca  PUSH EAX
  100051cb  LEA EAX,[EBP + -0x20]
  100051ce  PUSH dword ptr [EBP + 0xc]
  100051d1  MOV dword ptr [EBP + -0x1c],0x7fffffff
  100051d8  PUSH EAX
  100051d9  CALL 0x10005fe2    ; FUN_10005fe2
  100051de  ADD ESP,0xc
  100051e1  DEC dword ptr [EBP + -0x1c]
  100051e4  MOV ESI,EAX
  100051e6  JS 0x100051f0    ; LAB_100051f0
  100051e8  MOV EAX,dword ptr [EBP + -0x20]
  100051eb  AND byte ptr [EAX],0x0
  100051ee  JMP 0x100051fd    ; LAB_100051fd
LAB_100051f0:
  100051f0  LEA EAX,[EBP + -0x20]
  100051f3  PUSH EAX
  100051f4  PUSH 0x0
  100051f6  CALL 0x10005ecd    ; FUN_10005ecd
  100051fb  POP ECX
  100051fc  POP ECX
LAB_100051fd:
  100051fd  MOV EAX,ESI
  100051ff  POP ESI
  10005200  LEAVE
  10005201  RET

;==== FUNCTION FUN_10005202 @ 10005202 : undefined FUN_10005202(undefined * UNRECOVERED_JUMPTABLE)
  10005202  PUSH EBP
  10005203  MOV EBP,ESP
  10005205  PUSH ECX
  10005206  PUSH EBX
  10005207  PUSH ESI
  10005208  PUSH EDI
  10005209  MOV EAX,dword ptr [EBP + 0xc]
  1000520c  ADD EAX,0xc
  1000520f  MOV dword ptr [EBP + -0x4],EAX
  10005212  MOV EBX,dword ptr FS:[0x0]    ; ExceptionList
  10005219  MOV EAX,dword ptr [EBX]
  1000521b  MOV FS:[0x0],EAX    ; ExceptionList
  10005221  MOV EAX,dword ptr [EBP + 0x8]
  10005224  MOV EBX,dword ptr [EBP + 0xc]
  10005227  MOV ESP,dword ptr [EBX + -0x4]
  1000522a  MOV EBP,dword ptr [EBP + -0x4]
  1000522d  JMP EAX

;==== FUNCTION FUN_10005236 @ 10005236 : undefined FUN_10005236(undefined4 param_1, undefined * UNRECOVERED_JUMPTABLE)
  10005236  POP EAX
  10005237  POP ECX
  10005238  XCHG dword ptr [ESP],EAX
  1000523b  JMP EAX

;==== FUNCTION FUN_1000523d @ 1000523d : undefined FUN_1000523d(undefined4 param_1, undefined * UNRECOVERED_JUMPTABLE)
  1000523d  POP EAX
  1000523e  POP ECX
  1000523f  XCHG dword ptr [ESP],EAX
  10005242  JMP EAX

;==== FUNCTION FUN_10005244 @ 10005244 : undefined FUN_10005244(undefined4 param_1, undefined * UNRECOVERED_JUMPTABLE)
  10005244  POP EAX
  10005245  POP ECX
  10005246  XCHG dword ptr [ESP],EAX
  10005249  JMP EAX

;==== FUNCTION FUN_1000524b @ 1000524b : undefined FUN_1000524b(PVOID param_1, PEXCEPTION_RECORD param_2)
  1000524b  PUSH EBP
  1000524c  MOV EBP,ESP
  1000524e  PUSH ECX
  1000524f  PUSH ECX
  10005250  PUSH EBX
  10005251  PUSH ESI
  10005252  PUSH EDI
  10005253  MOV EAX,FS:[0x0]    ; ExceptionList
  10005259  MOV dword ptr [EBP + -0x8],EAX
  1000525c  MOV dword ptr [EBP + -0x4],0x10005273
  10005263  PUSH 0x0
  10005265  PUSH dword ptr [EBP + 0xc]
  10005268  PUSH dword ptr [EBP + -0x4]
  1000526b  PUSH dword ptr [EBP + 0x8]
  1000526e  CALL 0x1000c2a0    ; KERNEL32.DLL::RtlUnwind
  10005273  MOV EAX,dword ptr [EBP + 0xc]
  10005276  MOV EAX,dword ptr [EAX + 0x4]
  10005279  AND AL,0xfd
  1000527b  MOV ECX,dword ptr [EBP + 0xc]
  1000527e  MOV dword ptr [ECX + 0x4],EAX
  10005281  MOV EAX,FS:[0x0]    ; ExceptionList
  10005287  MOV EBX,dword ptr [EBP + -0x8]
  1000528a  MOV dword ptr [EBX],EAX
  1000528c  MOV dword ptr FS:[0x0],EBX    ; ExceptionList
  10005293  POP EDI
  10005294  POP ESI
  10005295  POP EBX
  10005296  LEAVE
  10005297  RET 0x8

;==== FUNCTION FUN_1000529a @ 1000529a : undefined4 FUN_1000529a(PEXCEPTION_RECORD param_1, PVOID param_2, undefined4 param_3, undefined4 param_4)
  1000529a  PUSH EBP
  1000529b  MOV EBP,ESP
  1000529d  SUB ESP,0x4
  100052a0  PUSH EBX
  100052a1  PUSH ESI
  100052a2  PUSH EDI
  100052a3  CLD
  100052a4  MOV dword ptr [EBP + -0x4],EAX
  100052a7  XOR EAX,EAX
  100052a9  PUSH EAX
  100052aa  PUSH EAX
  100052ab  PUSH EAX
  100052ac  PUSH dword ptr [EBP + -0x4]
  100052af  PUSH dword ptr [EBP + 0x14]
  100052b2  PUSH dword ptr [EBP + 0x10]
  100052b5  PUSH dword ptr [EBP + 0xc]
  100052b8  PUSH dword ptr [EBP + 0x8]
  100052bb  CALL 0x100067ec    ; FUN_100067ec
  100052c0  ADD ESP,0x20
  100052c3  MOV dword ptr [EBP + 0x14],EAX
  100052c6  POP EDI
  100052c7  POP ESI
  100052c8  POP EBX
  100052c9  MOV EAX,dword ptr [EBP + 0x14]
  100052cc  MOV ESP,EBP
  100052ce  POP EBP
  100052cf  RET

;==== FUNCTION FUN_100052ea @ 100052ea : undefined4 FUN_100052ea(undefined4 param_1, undefined4 param_2, undefined4 param_3, int param_4, int param_5)
  100052ea  PUSH EBP
  100052eb  MOV EBP,ESP
  100052ed  SUB ESP,0x14
  100052f0  MOV EAX,dword ptr [EBP + 0xc]
  100052f3  AND dword ptr [EBP + -0x14],0x0
  100052f7  MOV ECX,dword ptr [EBP + 0x8]
  100052fa  MOV dword ptr [EBP + -0xc],EAX
  100052fd  MOV EAX,dword ptr [EBP + 0x14]
  10005300  MOV dword ptr [EBP + -0x10],0x1000533e    ; FUN_1000533e
  10005307  INC EAX
  10005308  MOV dword ptr [EBP + -0x8],ECX
  1000530b  MOV dword ptr [EBP + -0x4],EAX
  1000530e  MOV EAX,FS:[0x0]    ; ExceptionList
  10005314  MOV dword ptr [EBP + -0x14],EAX
  10005317  LEA EAX,[EBP + 0xffffffec]
  1000531d  MOV FS:[0x0],EAX    ; ExceptionList
  10005323  PUSH dword ptr [EBP + 0x18]
  10005326  PUSH ECX
  10005327  PUSH dword ptr [EBP + 0x10]
  1000532a  CALL 0x10006ff0    ; __CallSettingFrame@12
  1000532f  MOV ECX,EAX
  10005331  MOV EAX,dword ptr [EBP + -0x14]
  10005334  MOV FS:[0x0],EAX    ; ExceptionList
  1000533a  MOV EAX,ECX
  1000533c  LEAVE
  1000533d  RET

;==== FUNCTION FUN_1000533e @ 1000533e : undefined FUN_1000533e(PEXCEPTION_RECORD param_1, PVOID param_2, undefined4 param_3)
  1000533e  PUSH EBP
  1000533f  MOV EBP,ESP
  10005341  CLD
  10005342  MOV EAX,dword ptr [EBP + 0xc]
  10005345  PUSH 0x0
  10005347  PUSH EAX
  10005348  PUSH dword ptr [EAX + 0x10]
  1000534b  PUSH dword ptr [EAX + 0x8]
  1000534e  PUSH 0x0
  10005350  PUSH dword ptr [EBP + 0x10]
  10005353  PUSH dword ptr [EAX + 0xc]
  10005356  PUSH dword ptr [EBP + 0x8]
  10005359  CALL 0x100067ec    ; FUN_100067ec
  1000535e  ADD ESP,0x20
  10005361  POP EBP
  10005362  RET

;==== FUNCTION FUN_10005363 @ 10005363 : undefined4 FUN_10005363(undefined4 * param_1, undefined4 param_2, undefined4 param_3, undefined4 param_4, undefined4 param_5, undefined4 param_6, undefined4 param_7)
  10005363  PUSH EBP
  10005364  MOV EBP,ESP
  10005366  SUB ESP,0x34
  10005369  PUSH EBX
  1000536a  PUSH ESI
  1000536b  PUSH EDI
  1000536c  AND dword ptr [EBP + -0x28],0x0
  10005370  MOV dword ptr [EBP + -0x24],0x10005417    ; FUN_10005417
  10005377  MOV EAX,dword ptr [EBP + 0x18]
  1000537a  MOV dword ptr [EBP + -0x20],EAX
  1000537d  MOV EAX,dword ptr [EBP + 0xc]
  10005380  MOV dword ptr [EBP + -0x1c],EAX
  10005383  MOV EAX,dword ptr [EBP + 0x1c]
  10005386  MOV dword ptr [EBP + -0x18],EAX
  10005389  MOV EAX,dword ptr [EBP + 0x20]
  1000538c  MOV dword ptr [EBP + -0x14],EAX
  1000538f  AND dword ptr [EBP + -0x10],0x0
  10005393  AND dword ptr [EBP + -0xc],0x0
  10005397  AND dword ptr [EBP + -0x8],0x0
  1000539b  AND dword ptr [EBP + -0x4],0x0
  1000539f  MOV dword ptr [EBP + -0x10],0x100053e9
  100053a6  MOV dword ptr [EBP + -0xc],ESP
  100053a9  MOV dword ptr [EBP + -0x8],EBP
  100053ac  MOV EAX,FS:[0x0]    ; ExceptionList
  100053b2  MOV dword ptr [EBP + -0x28],EAX
  100053b5  LEA EAX,[EBP + 0xffffffd8]
  100053bb  MOV FS:[0x0],EAX    ; ExceptionList
  100053c1  MOV dword ptr [EBP + -0x34],0x1
  100053c8  MOV EAX,dword ptr [EBP + 0x8]
  100053cb  MOV dword ptr [EBP + -0x30],EAX
  100053ce  MOV EAX,dword ptr [EBP + 0x10]
  100053d1  MOV dword ptr [EBP + -0x2c],EAX
  100053d4  LEA EAX,[EBP + -0x30]
  100053d7  PUSH EAX
  100053d8  MOV EAX,dword ptr [EBP + 0x8]
  100053db  PUSH dword ptr [EAX]
  100053dd  CALL dword ptr [0x1000f644]    ; DAT_1000f644
  100053e3  POP ECX
  100053e4  POP ECX
  100053e5  AND dword ptr [EBP + -0x34],0x0
  100053e9  CMP dword ptr [EBP + -0x4],0x0
  100053ed  JZ 0x10005406    ; LAB_10005406
  100053ef  MOV EBX,dword ptr FS:[0x0]    ; ExceptionList
  100053f6  MOV EAX,dword ptr [EBX]
  100053f8  MOV EBX,dword ptr [EBP + -0x28]
  100053fb  MOV dword ptr [EBX],EAX
  100053fd  MOV dword ptr FS:[0x0],EBX    ; ExceptionList
  10005404  JMP 0x1000540f    ; LAB_1000540f
LAB_10005406:
  10005406  MOV EAX,dword ptr [EBP + -0x28]
  10005409  MOV FS:[0x0],EAX    ; ExceptionList
LAB_1000540f:
  1000540f  MOV EAX,dword ptr [EBP + -0x34]
  10005412  POP EDI
  10005413  POP ESI
  10005414  POP EBX
  10005415  LEAVE
  10005416  RET

;==== FUNCTION FUN_10005417 @ 10005417 : undefined4 FUN_10005417(PEXCEPTION_RECORD param_1, PVOID param_2, undefined4 param_3)
  10005417  PUSH EBP
  10005418  MOV EBP,ESP
  1000541a  PUSH EBX
  1000541b  PUSH ESI
  1000541c  PUSH EDI
  1000541d  CLD
  1000541e  MOV EAX,dword ptr [EBP + 0x8]
  10005421  MOV EAX,dword ptr [EAX + 0x4]
  10005424  AND EAX,0x66
  10005427  TEST EAX,EAX
  10005429  JZ 0x1000543a    ; LAB_1000543a
  1000542b  MOV EAX,dword ptr [EBP + 0xc]
  1000542e  MOV dword ptr [EAX + 0x24],0x1
  10005435  PUSH 0x1
  10005437  POP EAX
  10005438  JMP 0x10005487    ; LAB_10005487
LAB_1000543a:
  1000543a  PUSH 0x1
  1000543c  MOV EAX,dword ptr [EBP + 0xc]
  1000543f  PUSH dword ptr [EAX + 0x14]
  10005442  MOV EAX,dword ptr [EBP + 0xc]
  10005445  PUSH dword ptr [EAX + 0x10]
  10005448  MOV EAX,dword ptr [EBP + 0xc]
  1000544b  PUSH dword ptr [EAX + 0x8]
  1000544e  PUSH 0x0
  10005450  PUSH dword ptr [EBP + 0x10]
  10005453  MOV EAX,dword ptr [EBP + 0xc]
  10005456  PUSH dword ptr [EAX + 0xc]
  10005459  PUSH dword ptr [EBP + 0x8]
  1000545c  CALL 0x100067ec    ; FUN_100067ec
  10005461  ADD ESP,0x20
  10005464  MOV EAX,dword ptr [EBP + 0xc]
  10005467  CMP dword ptr [EAX + 0x24],0x0
  1000546b  JNZ 0x10005478    ; LAB_10005478
  1000546d  PUSH dword ptr [EBP + 0x8]
  10005470  PUSH dword ptr [EBP + 0xc]
  10005473  CALL 0x1000524b    ; FUN_1000524b
LAB_10005478:
  10005478  MOV EBX,dword ptr [EBP + 0xc]
  1000547b  MOV ESP,dword ptr [EBX + 0x1c]
  1000547e  MOV EBP,dword ptr [EBX + 0x20]
  10005481  JMP dword ptr [EBX + 0x18]
LAB_10005487:
  10005487  POP EDI
  10005488  POP ESI
  10005489  POP EBX
  1000548a  POP EBP
  1000548b  RET

;==== FUNCTION FUN_1000548c @ 1000548c : int FUN_1000548c(int param_1, int param_2, int param_3, uint * param_4, uint * param_5)
  1000548c  PUSH EBP
  1000548d  MOV EBP,ESP
  1000548f  PUSH ECX
  10005490  PUSH EBX
  10005491  PUSH ESI
  10005492  CMP dword ptr [EBP + 0xc],0x0
  10005496  PUSH EDI
  10005497  MOV EDI,dword ptr [EBP + 0x8]
  1000549a  MOV ESI,dword ptr [EDI + 0xc]
  1000549d  MOV EBX,dword ptr [EDI + 0x10]
  100054a0  MOV EAX,ESI
  100054a2  MOV dword ptr [EBP + 0x8],ESI
  100054a5  MOV dword ptr [EBP + -0x4],EAX
  100054a8  JL 0x100054e3    ; LAB_100054e3
LAB_100054aa:
  100054aa  CMP ESI,-0x1
  100054ad  JNZ 0x100054b4    ; LAB_100054b4
  100054af  CALL 0x100070a2    ; FUN_100070a2
LAB_100054b4:
  100054b4  MOV ECX,dword ptr [EBP + 0x10]
  100054b7  DEC ESI
  100054b8  LEA EAX,[ESI + ESI*0x4]
  100054bb  CMP dword ptr [EBX + EAX*0x4 + 0x4],ECX
  100054bf  LEA EAX,[EBX + EAX*0x4]
  100054c2  JGE 0x100054c9    ; LAB_100054c9
  100054c4  CMP ECX,dword ptr [EAX + 0x8]
  100054c7  JLE 0x100054ce    ; LAB_100054ce
LAB_100054c9:
  100054c9  CMP ESI,-0x1
  100054cc  JNZ 0x100054da    ; LAB_100054da
LAB_100054ce:
  100054ce  MOV EAX,dword ptr [EBP + 0x8]
  100054d1  DEC dword ptr [EBP + 0xc]
  100054d4  MOV dword ptr [EBP + -0x4],EAX
  100054d7  MOV dword ptr [EBP + 0x8],ESI
LAB_100054da:
  100054da  CMP dword ptr [EBP + 0xc],0x0
  100054de  JGE 0x100054aa    ; LAB_100054aa
  100054e0  MOV EAX,dword ptr [EBP + -0x4]
LAB_100054e3:
  100054e3  MOV ECX,dword ptr [EBP + 0x14]
  100054e6  INC ESI
  100054e7  MOV dword ptr [ECX],ESI
  100054e9  MOV ECX,dword ptr [EBP + 0x18]
  100054ec  MOV dword ptr [ECX],EAX
  100054ee  CMP EAX,dword ptr [EDI + 0xc]
  100054f1  JA 0x100054f7    ; LAB_100054f7
  100054f3  CMP ESI,EAX
  100054f5  JBE 0x100054fc    ; LAB_100054fc
LAB_100054f7:
  100054f7  CALL 0x100070a2    ; FUN_100070a2
LAB_100054fc:
  100054fc  LEA EAX,[ESI + ESI*0x4]
  100054ff  POP EDI
  10005500  POP ESI
  10005501  LEA EAX,[EBX + EAX*0x4]
  10005504  POP EBX
  10005505  LEAVE
  10005506  RET

;==== FUNCTION __global_unwind2 @ 10005508 : undefined __global_unwind2(PVOID param_1)
  10005508  PUSH EBP
  10005509  MOV EBP,ESP
  1000550b  PUSH EBX
  1000550c  PUSH ESI
  1000550d  PUSH EDI
  1000550e  PUSH EBP
  1000550f  PUSH 0x0
  10005511  PUSH 0x0
  10005513  PUSH 0x10005520
  10005518  PUSH dword ptr [EBP + 0x8]
  1000551b  CALL 0x1000c2a0    ; KERNEL32.DLL::RtlUnwind
  10005520  POP EBP
  10005521  POP EDI
  10005522  POP ESI
  10005523  POP EBX
  10005524  MOV ESP,EBP
  10005526  POP EBP
  10005527  RET
LAB_10005528:
  10005528  MOV ECX,dword ptr [ESP + 0x4]
  1000552c  TEST dword ptr [ECX + 0x4],0x6
  10005533  MOV EAX,0x1
  10005538  JZ 0x10005549    ; LAB_10005549
  1000553a  MOV EAX,dword ptr [ESP + 0x8]
  1000553e  MOV EDX,dword ptr [ESP + 0x10]
  10005542  MOV dword ptr [EDX],EAX
  10005544  MOV EAX,0x3
LAB_10005549:
  10005549  RET

;==== FUNCTION __local_unwind2 @ 1000554a : undefined __local_unwind2(int param_1, int param_2)
  1000554a  PUSH EBX
  1000554b  PUSH ESI
  1000554c  PUSH EDI
  1000554d  MOV EAX,dword ptr [ESP + 0x10]
  10005551  PUSH EAX
  10005552  PUSH -0x2
  10005554  PUSH 0x10005528    ; LAB_10005528
  10005559  PUSH dword ptr FS:[0x0]    ; ExceptionList
  10005560  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
LAB_10005567:
  10005567  MOV EAX,dword ptr [ESP + 0x20]
  1000556b  MOV EBX,dword ptr [EAX + 0x8]
  1000556e  MOV ESI,dword ptr [EAX + 0xc]
  10005571  CMP ESI,-0x1
  10005574  JZ 0x100055a4    ; LAB_100055a4
  10005576  CMP ESI,dword ptr [ESP + 0x24]
  1000557a  JZ 0x100055a4    ; LAB_100055a4
  1000557c  LEA ESI,[ESI + ESI*0x2]
  1000557f  MOV ECX,dword ptr [EBX + ESI*0x4]
  10005582  MOV dword ptr [ESP + 0x8],ECX
  10005586  MOV dword ptr [EAX + 0xc],ECX
  10005589  CMP dword ptr [EBX + ESI*0x4 + 0x4],0x0
  1000558e  JNZ 0x100055a2    ; LAB_100055a2
  10005590  PUSH 0x101
  10005595  MOV EAX,dword ptr [EBX + ESI*0x4 + 0x8]
  10005599  CALL 0x100055de    ; FUN_100055de
  1000559e  CALL dword ptr [EBX + ESI*0x4 + 0x8]
LAB_100055a2:
  100055a2  JMP 0x10005567    ; LAB_10005567
LAB_100055a4:
  100055a4  POP dword ptr FS:[0x0]    ; ExceptionList
  100055ab  ADD ESP,0xc
  100055ae  POP EDI
  100055af  POP ESI
  100055b0  POP EBX
  100055b1  RET

;==== FUNCTION __abnormal_termination @ 100055b2 : int __abnormal_termination(void)
  100055b2  XOR EAX,EAX
  100055b4  MOV ECX,dword ptr FS:[0x0]    ; ExceptionList
  100055bb  CMP dword ptr [ECX + 0x4],0x10005528    ; LAB_10005528
  100055c2  JNZ 0x100055d4    ; LAB_100055d4
  100055c4  MOV EDX,dword ptr [ECX + 0xc]
  100055c7  MOV EDX,dword ptr [EDX + 0xc]
  100055ca  CMP dword ptr [ECX + 0x8],EDX
  100055cd  JNZ 0x100055d4    ; LAB_100055d4
  100055cf  MOV EAX,0x1
LAB_100055d4:
  100055d4  RET

;==== FUNCTION __NLG_Notify1 @ 100055d5 : undefined __NLG_Notify1(undefined4 param_1)
  100055d5  PUSH EBX
  100055d6  PUSH ECX
  100055d7  MOV EBX,0x1000ea2c    ; DAT_1000ea2c
  100055dc  JMP 0x100055e8    ; LAB_100055e8

;==== FUNCTION FUN_100055de @ 100055de : undefined FUN_100055de(void)
  100055de  PUSH EBX
  100055df  PUSH ECX
  100055e0  MOV EBX,0x1000ea2c    ; DAT_1000ea2c
  100055e5  MOV ECX,dword ptr [EBP + 0x8]
LAB_100055e8:
  100055e8  MOV dword ptr [EBX + 0x8],ECX    ; DAT_1000ea34
  100055eb  MOV dword ptr [EBX + 0x4],EAX    ; DAT_1000ea30
  100055ee  MOV dword ptr [EBX + 0xc],EBP    ; DAT_1000ea38
  100055f1  POP ECX
  100055f2  POP EBX
  100055f3  RET 0x4

;==== FUNCTION FUN_10005600 @ 10005600 : undefined FUN_10005600(void)
  10005600  PUSH ECX
  10005601  CMP EAX,0x1000
  10005606  LEA ECX,[ESP + 0x8]
  1000560a  JC 0x10005620    ; LAB_10005620
LAB_1000560c:
  1000560c  SUB ECX,0x1000
  10005612  SUB EAX,0x1000
  10005617  TEST dword ptr [ECX],EAX
  10005619  CMP EAX,0x1000
  1000561e  JNC 0x1000560c    ; LAB_1000560c
LAB_10005620:
  10005620  SUB ECX,EAX
  10005622  MOV EAX,ESP
  10005624  TEST dword ptr [ECX],EAX
  10005626  MOV ESP,ECX
  10005628  MOV ECX,dword ptr [EAX]
  1000562a  MOV EAX,dword ptr [EAX + 0x4]
  1000562d  PUSH EAX
  1000562e  RET

;==== FUNCTION FUN_10005639 @ 10005639 : uint FUN_10005639(void)
  10005639  MOV EAX,[0x1000ea40]    ; DAT_1000ea40
  1000563e  IMUL EAX,EAX,0x343fd
  10005644  ADD EAX,0x269ec3
  10005649  MOV [0x1000ea40],EAX    ; DAT_1000ea40
  1000564e  SAR EAX,0x10
  10005651  AND EAX,0x7fff
  10005656  RET

;==== FUNCTION FUN_10005657 @ 10005657 : int FUN_10005657(void * this, byte * param_1)
  10005657  PUSH EBX
  10005658  PUSH EBP
  10005659  PUSH ESI
  1000565a  PUSH EDI
  1000565b  MOV EDI,dword ptr [ESP + 0x14]
LAB_1000565f:
  1000565f  CMP dword ptr [0x1000ec94],0x1    ; DAT_1000ec94
  10005666  JLE 0x10005677    ; LAB_10005677
  10005668  MOVZX EAX,byte ptr [EDI]
  1000566b  PUSH 0x8
  1000566d  PUSH EAX
  1000566e  CALL 0x100070f8    ; FUN_100070f8
  10005673  POP ECX
  10005674  POP ECX
  10005675  JMP 0x10005686    ; LAB_10005686
LAB_10005677:
  10005677  MOVZX EAX,byte ptr [EDI]
  1000567a  MOV ECX,dword ptr [0x1000ea88]    ; PTR_DAT_1000ea88
  10005680  MOV AL,byte ptr [ECX + EAX*0x2]    ; DAT_1000ea92
  10005683  AND EAX,0x8
LAB_10005686:
  10005686  TEST EAX,EAX
  10005688  JZ 0x1000568d    ; LAB_1000568d
  1000568a  INC EDI
  1000568b  JMP 0x1000565f    ; LAB_1000565f
LAB_1000568d:
  1000568d  MOVZX ESI,byte ptr [EDI]
  10005690  INC EDI
  10005691  CMP ESI,0x2d
  10005694  MOV EBP,ESI
  10005696  JZ 0x1000569d    ; LAB_1000569d
  10005698  CMP ESI,0x2b
  1000569b  JNZ 0x100056a1    ; LAB_100056a1
LAB_1000569d:
  1000569d  MOVZX ESI,byte ptr [EDI]
  100056a0  INC EDI
LAB_100056a1:
  100056a1  XOR EBX,EBX
LAB_100056a3:
  100056a3  CMP dword ptr [0x1000ec94],0x1    ; DAT_1000ec94
  100056aa  JLE 0x100056b8    ; LAB_100056b8
  100056ac  PUSH 0x4
  100056ae  PUSH ESI
  100056af  CALL 0x100070f8    ; FUN_100070f8
  100056b4  POP ECX
  100056b5  POP ECX
  100056b6  JMP 0x100056c3    ; LAB_100056c3
LAB_100056b8:
  100056b8  MOV EAX,[0x1000ea88]    ; PTR_DAT_1000ea88
  100056bd  MOV AL,byte ptr [EAX + ESI*0x2]    ; DAT_1000ea92
  100056c0  AND EAX,0x4
LAB_100056c3:
  100056c3  TEST EAX,EAX
  100056c5  JZ 0x100056d4    ; LAB_100056d4
  100056c7  LEA EAX,[EBX + EBX*0x4]
  100056ca  LEA EBX,[ESI + EAX*0x2 + -0x30]
  100056ce  MOVZX ESI,byte ptr [EDI]
  100056d1  INC EDI
  100056d2  JMP 0x100056a3    ; LAB_100056a3
LAB_100056d4:
  100056d4  CMP EBP,0x2d
  100056d7  MOV EAX,EBX
  100056d9  JNZ 0x100056dd    ; LAB_100056dd
  100056db  NEG EAX
LAB_100056dd:
  100056dd  POP EDI
  100056de  POP ESI
  100056df  POP EBP
  100056e0  POP EBX
  100056e1  RET

;==== FUNCTION FUN_100056e2 @ 100056e2 : undefined FUN_100056e2(void * this, byte * param_1)
  100056e2  PUSH dword ptr [ESP + 0x4]
  100056e6  CALL 0x10005657    ; FUN_10005657
  100056eb  POP ECX
  100056ec  RET

;==== FUNCTION FUN_100057b0 @ 100057b0 : int FUN_100057b0(byte * param_1, byte * param_2)
  100057b0  PUSH EBP
  100057b1  MOV EBP,ESP
  100057b3  PUSH ESI
  100057b4  XOR EAX,EAX
  100057b6  PUSH EAX
  100057b7  PUSH EAX
  100057b8  PUSH EAX
  100057b9  PUSH EAX
  100057ba  PUSH EAX
  100057bb  PUSH EAX
  100057bc  PUSH EAX
  100057bd  PUSH EAX
  100057be  MOV EDX,dword ptr [EBP + 0xc]
  100057c1  LEA ECX,[ECX]
LAB_100057c4:
  100057c4  MOV AL,byte ptr [EDX]
  100057c6  OR AL,AL
  100057c8  JZ 0x100057d1    ; LAB_100057d1
  100057ca  INC EDX
  100057cb  BTS [ESP],EAX
  100057cf  JMP 0x100057c4    ; LAB_100057c4
LAB_100057d1:
  100057d1  MOV ESI,dword ptr [EBP + 0x8]
  100057d4  OR ECX,0xffffffff
  100057d7  NOP
LAB_100057d8:
  100057d8  INC ECX
  100057d9  MOV AL,byte ptr [ESI]
  100057db  OR AL,AL
  100057dd  JZ 0x100057e6    ; LAB_100057e6
  100057df  INC ESI
  100057e0  BT [ESP],EAX
  100057e4  JNC 0x100057d8    ; LAB_100057d8
LAB_100057e6:
  100057e6  MOV EAX,ECX
  100057e8  ADD ESP,0x20
  100057eb  POP ESI
  100057ec  LEAVE
  100057ed  RET

;==== FUNCTION FUN_100057ee @ 100057ee : undefined4 FUN_100057ee(undefined4 param_1, int param_2)
  100057ee  CMP dword ptr [ESP + 0x8],0x1
  100057f3  JNZ 0x10005873    ; LAB_10005873
  100057f5  CALL dword ptr [0x1000d028]    ; PTR_GetVersion_1000d028 KERNEL32.DLL::GetVersion
  100057fb  PUSH 0x0
  100057fd  MOV [0x1000f658],EAX    ; DAT_1000f658
  10005802  CALL 0x100072c4    ; FUN_100072c4
  10005807  TEST EAX,EAX
  10005809  POP ECX
  1000580a  JZ 0x100058a2    ; LAB_100058a2
  10005810  MOV EAX,[0x1000f658]    ; DAT_1000f658
  10005815  XOR ECX,ECX
  10005817  MOV CL,byte ptr [0x1000f659]    ; DAT_1000f658+1
  1000581d  AND EAX,0xff
  10005822  SHR dword ptr [0x1000f658],0x10    ; DAT_1000f658
  10005829  MOV [0x1000f660],EAX    ; DAT_1000f660
  1000582e  MOV dword ptr [0x1000f664],ECX    ; DAT_1000f664
  10005834  SHL EAX,0x8
  10005837  ADD EAX,ECX
  10005839  MOV [0x1000f65c],EAX    ; DAT_1000f65c
  1000583e  CALL dword ptr [0x1000d024]    ; PTR_GetCommandLineA_1000d024 KERNEL32.DLL::GetCommandLineA
  10005844  MOV [0x10010bb8],EAX    ; DAT_10010bb8
  10005849  CALL 0x10007849    ; FUN_10007849
  1000584e  MOV [0x1000f61c],EAX    ; DAT_1000f61c
  10005853  CALL 0x10007375    ; FUN_10007375
  10005858  CALL 0x100075fc    ; FUN_100075fc
  1000585d  CALL 0x10007543    ; FUN_10007543
  10005862  CALL 0x100071a4    ; FUN_100071a4
  10005867  INC dword ptr [0x1000f618]    ; DAT_1000f618
LAB_1000586d:
  1000586d  PUSH 0x1
  1000586f  POP EAX
LAB_10005870:
  10005870  RET 0xc
LAB_10005873:
  10005873  XOR EAX,EAX
  10005875  CMP dword ptr [ESP + 0x8],EAX
  10005879  JNZ 0x1000586d    ; LAB_1000586d
  1000587b  CMP dword ptr [0x1000f618],EAX    ; DAT_1000f618
  10005881  JLE 0x100058a2    ; LAB_100058a2
  10005883  DEC dword ptr [0x1000f618]    ; DAT_1000f618
  10005889  CMP dword ptr [0x1000f690],EAX    ; DAT_1000f690
  1000588f  JNZ 0x10005896    ; LAB_10005896
  10005891  CALL 0x100071f3    ; FUN_100071f3
LAB_10005896:
  10005896  CALL 0x10007520    ; FUN_10007520
  1000589b  CALL 0x10007300    ; FUN_10007300
  100058a0  JMP 0x1000586d    ; LAB_1000586d
LAB_100058a2:
  100058a2  XOR EAX,EAX
  100058a4  JMP 0x10005870    ; LAB_10005870

;==== FUNCTION entry @ 100058a6 : int entry(undefined4 param_1, int param_2, undefined4 param_3)
  100058a6  PUSH EBP
  100058a7  MOV EBP,ESP
  100058a9  PUSH EBX
  100058aa  MOV EBX,dword ptr [EBP + 0x8]
  100058ad  PUSH ESI
  100058ae  MOV ESI,dword ptr [EBP + 0xc]
  100058b1  PUSH EDI
  100058b2  MOV EDI,dword ptr [EBP + 0x10]
  100058b5  TEST ESI,ESI
  100058b7  JNZ 0x100058c2    ; LAB_100058c2
  100058b9  CMP dword ptr [0x1000f618],0x0    ; DAT_1000f618
  100058c0  JMP 0x100058e8    ; LAB_100058e8
LAB_100058c2:
  100058c2  CMP ESI,0x1
  100058c5  JZ 0x100058cc    ; LAB_100058cc
  100058c7  CMP ESI,0x2
  100058ca  JNZ 0x100058ee    ; LAB_100058ee
LAB_100058cc:
  100058cc  MOV EAX,[0x10010bbc]    ; DAT_10010bbc
  100058d1  TEST EAX,EAX
  100058d3  JZ 0x100058de    ; LAB_100058de
  100058d5  PUSH EDI
  100058d6  PUSH ESI
  100058d7  PUSH EBX
  100058d8  CALL EAX
  100058da  TEST EAX,EAX
  100058dc  JZ 0x100058ea    ; LAB_100058ea
LAB_100058de:
  100058de  PUSH EDI
  100058df  PUSH ESI
  100058e0  PUSH EBX
  100058e1  CALL 0x100057ee    ; FUN_100057ee
  100058e6  TEST EAX,EAX
LAB_100058e8:
  100058e8  JNZ 0x100058ee    ; LAB_100058ee
LAB_100058ea:
  100058ea  XOR EAX,EAX
  100058ec  JMP 0x1000593c    ; LAB_1000593c
LAB_100058ee:
  100058ee  PUSH EDI
  100058ef  PUSH ESI
  100058f0  PUSH EBX
  100058f1  CALL 0x10004e70    ; FUN_10004e70
  100058f6  CMP ESI,0x1
  100058f9  MOV dword ptr [EBP + 0xc],EAX
  100058fc  JNZ 0x1000590a    ; LAB_1000590a
  100058fe  TEST EAX,EAX
  10005900  JNZ 0x10005939    ; LAB_10005939
  10005902  PUSH EDI
  10005903  PUSH EAX
  10005904  PUSH EBX
  10005905  CALL 0x100057ee    ; FUN_100057ee
LAB_1000590a:
  1000590a  TEST ESI,ESI
  1000590c  JZ 0x10005913    ; LAB_10005913
  1000590e  CMP ESI,0x3
  10005911  JNZ 0x10005939    ; LAB_10005939
LAB_10005913:
  10005913  PUSH EDI
  10005914  PUSH ESI
  10005915  PUSH EBX
  10005916  CALL 0x100057ee    ; FUN_100057ee
  1000591b  TEST EAX,EAX
  1000591d  JNZ 0x10005922    ; LAB_10005922
  1000591f  AND dword ptr [EBP + 0xc],EAX
LAB_10005922:
  10005922  CMP dword ptr [EBP + 0xc],0x0
  10005926  JZ 0x10005939    ; LAB_10005939
  10005928  MOV EAX,[0x10010bbc]    ; DAT_10010bbc
  1000592d  TEST EAX,EAX
  1000592f  JZ 0x10005939    ; LAB_10005939
  10005931  PUSH EDI
  10005932  PUSH ESI
  10005933  PUSH EBX
  10005934  CALL EAX
  10005936  MOV dword ptr [EBP + 0xc],EAX
LAB_10005939:
  10005939  MOV EAX,dword ptr [EBP + 0xc]
LAB_1000593c:
  1000593c  POP EDI
  1000593d  POP ESI
  1000593e  POP EBX
  1000593f  POP EBP
  10005940  RET 0xc

;==== FUNCTION __amsg_exit @ 10005943 : void __amsg_exit(int param_1)
  10005943  MOV EAX,[0x1000f624]    ; DAT_1000f624
  10005948  CMP EAX,0x1
  1000594b  JZ 0x1000595a    ; LAB_1000595a
  1000594d  TEST EAX,EAX
  1000594f  JNZ 0x1000595f    ; LAB_1000595f
  10005951  CMP dword ptr [0x1000f628],0x1    ; DAT_1000f628
  10005958  JNZ 0x1000595f    ; LAB_1000595f
LAB_1000595a:
  1000595a  CALL 0x1000797b    ; FUN_1000797b
LAB_1000595f:
  1000595f  PUSH dword ptr [ESP + 0x4]
  10005963  CALL 0x100079b4    ; FUN_100079b4
  10005968  PUSH 0xff
  1000596d  CALL dword ptr [0x1000ea50]    ; PTR___exit_1000ea50 __exit

;==== FUNCTION FUN_10005976 @ 10005976 : undefined FUN_10005976(void * param_1)
  10005976  PUSH 0x30000
  1000597b  PUSH 0x10000
  10005980  CALL 0x10007b94    ; FUN_10007b94
  10005985  POP ECX
  10005986  POP ECX
  10005987  RET

;==== FUNCTION FUN_10005988 @ 10005988 : undefined4 FUN_10005988(void)
  10005988  PUSH EBP
  10005989  MOV EBP,ESP
  1000598b  SUB ESP,0x18
  1000598e  FLD double ptr [0x1000d170]    ; DAT_1000d170
  10005994  FSTP double ptr [EBP + -0x8]
  10005997  FLD double ptr [0x1000d168]    ; DAT_1000d168
  1000599d  FSTP double ptr [EBP + -0x10]
  100059a0  FLD double ptr [EBP + -0x10]
  100059a3  FDIV double ptr [EBP + -0x8]
  100059a6  FMUL double ptr [EBP + -0x8]
  100059a9  FSUBR double ptr [EBP + -0x10]
  100059ac  FSTP double ptr [EBP + -0x18]
  100059af  FLD double ptr [EBP + -0x18]
  100059b2  FCOMP double ptr [0x1000d160]    ; DAT_1000d160
  100059b8  FNSTSW AX
  100059ba  SAHF
  100059bb  JBE 0x100059c2    ; LAB_100059c2
  100059bd  PUSH 0x1
  100059bf  POP EAX
  100059c0  LEAVE
  100059c1  RET
LAB_100059c2:
  100059c2  XOR EAX,EAX
  100059c4  LEAVE
  100059c5  RET

;==== FUNCTION FUN_100059c6 @ 100059c6 : undefined FUN_100059c6(void)
  100059c6  PUSH 0x1000d194    ; s_KERNEL32_1000d194
  100059cb  CALL dword ptr [0x1000d030]    ; PTR_GetModuleHandleA_1000d030 KERNEL32.DLL::GetModuleHandleA
  100059d1  TEST EAX,EAX
  100059d3  JZ 0x100059ea    ; LAB_100059ea
  100059d5  PUSH 0x1000d178    ; s_IsProcessorFeaturePresent_1000d176+2
  100059da  PUSH EAX
  100059db  CALL dword ptr [0x1000d02c]    ; PTR_GetProcAddress_1000d02c KERNEL32.DLL::GetProcAddress
  100059e1  TEST EAX,EAX
  100059e3  JZ 0x100059ea    ; LAB_100059ea
  100059e5  PUSH 0x0
  100059e7  CALL EAX
  100059e9  RET
LAB_100059ea:
  100059ea  JMP 0x10005988    ; FUN_10005988

;==== FUNCTION FUN_100059ef @ 100059ef : undefined FUN_100059ef(void * this, char * param_1)
  100059ef  PUSH ESI
  100059f0  MOV ESI,dword ptr [ESP + 0x8]
  100059f4  MOVSX EAX,byte ptr [ESI]
  100059f7  PUSH EAX
  100059f8  CALL 0x10007d2c    ; FUN_10007d2c
  100059fd  CMP EAX,0x65
  10005a00  POP ECX
  10005a01  JZ 0x10005a2f    ; LAB_10005a2f
LAB_10005a03:
  10005a03  INC ESI
  10005a04  CMP dword ptr [0x1000ec94],0x1    ; DAT_1000ec94
  10005a0b  JLE 0x10005a1c    ; LAB_10005a1c
  10005a0d  MOVSX EAX,byte ptr [ESI]
  10005a10  PUSH 0x4
  10005a12  PUSH EAX
  10005a13  CALL 0x100070f8    ; FUN_100070f8
  10005a18  POP ECX
  10005a19  POP ECX
  10005a1a  JMP 0x10005a2b    ; LAB_10005a2b
LAB_10005a1c:
  10005a1c  MOVSX EAX,byte ptr [ESI]
  10005a1f  MOV ECX,dword ptr [0x1000ea88]    ; PTR_DAT_1000ea88
  10005a25  MOV AL,byte ptr [ECX + EAX*0x2]    ; DAT_1000ea92
  10005a28  AND EAX,0x4
LAB_10005a2b:
  10005a2b  TEST EAX,EAX
  10005a2d  JNZ 0x10005a03    ; LAB_10005a03
LAB_10005a2f:
  10005a2f  MOV CL,byte ptr [0x1000ec98]    ; DAT_1000ec98
  10005a35  MOV AL,byte ptr [ESI]
  10005a37  MOV byte ptr [ESI],CL
  10005a39  INC ESI
LAB_10005a3a:
  10005a3a  MOV CL,byte ptr [ESI]
  10005a3c  MOV byte ptr [ESI],AL
  10005a3e  MOV AL,CL
  10005a40  MOV CL,byte ptr [ESI]
  10005a42  INC ESI
  10005a43  TEST CL,CL
  10005a45  JNZ 0x10005a3a    ; LAB_10005a3a
  10005a47  POP ESI
  10005a48  RET
LAB_10005a49:
  10005a49  MOV EAX,dword ptr [ESP + 0x4]
  10005a4d  MOV DL,byte ptr [0x1000ec98]    ; DAT_1000ec98
  10005a53  MOV CL,byte ptr [EAX]
  10005a55  TEST CL,CL
  10005a57  JZ 0x10005a65    ; LAB_10005a65
LAB_10005a59:
  10005a59  CMP CL,DL
  10005a5b  JZ 0x10005a65    ; LAB_10005a65
  10005a5d  MOV CL,byte ptr [EAX + 0x1]
  10005a60  INC EAX
  10005a61  TEST CL,CL
  10005a63  JNZ 0x10005a59    ; LAB_10005a59
LAB_10005a65:
  10005a65  MOV CL,byte ptr [EAX]
  10005a67  INC EAX
  10005a68  TEST CL,CL
  10005a6a  JZ 0x10005a96    ; LAB_10005a96
LAB_10005a6c:
  10005a6c  MOV CL,byte ptr [EAX]
  10005a6e  TEST CL,CL
  10005a70  JZ 0x10005a7f    ; LAB_10005a7f
  10005a72  CMP CL,0x65
  10005a75  JZ 0x10005a7f    ; LAB_10005a7f
  10005a77  CMP CL,0x45
  10005a7a  JZ 0x10005a7f    ; LAB_10005a7f
  10005a7c  INC EAX
  10005a7d  JMP 0x10005a6c    ; LAB_10005a6c
LAB_10005a7f:
  10005a7f  MOV ECX,EAX
LAB_10005a81:
  10005a81  DEC EAX
  10005a82  CMP byte ptr [EAX],0x30
  10005a85  JZ 0x10005a81    ; LAB_10005a81
  10005a87  CMP byte ptr [EAX],DL
  10005a89  JNZ 0x10005a8c    ; LAB_10005a8c
  10005a8b  DEC EAX
LAB_10005a8c:
  10005a8c  MOV DL,byte ptr [ECX]
  10005a8e  INC EAX
  10005a8f  INC ECX
  10005a90  TEST DL,DL
  10005a92  MOV byte ptr [EAX],DL
  10005a94  JNZ 0x10005a8c    ; LAB_10005a8c
LAB_10005a96:
  10005a96  RET
LAB_10005a97:
  10005a97  MOV EAX,dword ptr [ESP + 0x4]
  10005a9b  FLD double ptr [EAX]
  10005a9d  FCOMP double ptr [0x1000d1a0]    ; DAT_1000d1a0
  10005aa3  FNSTSW AX
  10005aa5  SAHF
  10005aa6  JC 0x10005aac    ; LAB_10005aac
  10005aa8  PUSH 0x1
  10005aaa  POP EAX
  10005aab  RET
LAB_10005aac:
  10005aac  XOR EAX,EAX
  10005aae  RET

;==== FUNCTION __fassign @ 10005aaf : void __fassign(int flag, char * argument, char * number)
  10005aaf  PUSH EBP
  10005ab0  MOV EBP,ESP
  10005ab2  PUSH ECX
  10005ab3  PUSH ECX
  10005ab4  CMP dword ptr [EBP + 0x8],0x0
  10005ab8  PUSH dword ptr [EBP + 0x10]
  10005abb  JZ 0x10005ad8    ; LAB_10005ad8
  10005abd  LEA EAX,[EBP + -0x8]
  10005ac0  PUSH EAX
  10005ac1  CALL 0x10008203    ; FUN_10008203
  10005ac6  MOV EAX,dword ptr [EBP + 0xc]
  10005ac9  POP ECX
  10005aca  POP ECX
  10005acb  MOV ECX,dword ptr [EBP + -0x8]
  10005ace  MOV dword ptr [EAX],ECX
  10005ad0  MOV ECX,dword ptr [EBP + -0x4]
  10005ad3  MOV dword ptr [EAX + 0x4],ECX
  10005ad6  LEAVE
  10005ad7  RET
LAB_10005ad8:
  10005ad8  LEA EAX,[EBP + 0x10]
  10005adb  PUSH EAX
  10005adc  CALL 0x1000825e    ; FUN_1000825e
  10005ae1  MOV EAX,dword ptr [EBP + 0xc]
  10005ae4  POP ECX
  10005ae5  POP ECX
  10005ae6  MOV ECX,dword ptr [EBP + 0x10]
  10005ae9  MOV dword ptr [EAX],ECX
  10005aeb  LEAVE
  10005aec  RET

;==== FUNCTION FUN_10005aed @ 10005aed : undefined1 * FUN_10005aed(undefined4 param_1, undefined1 * param_2, int param_3, int param_4)
  10005aed  PUSH EBP
  10005aee  MOV EBP,ESP
  10005af0  CMP byte ptr [0x1000f630],0x0    ; DAT_1000f630
  10005af7  PUSH EBX
  10005af8  PUSH ESI
  10005af9  JZ 0x10005b22    ; LAB_10005b22
  10005afb  MOV EBX,dword ptr [EBP + 0x10]
  10005afe  MOV EAX,[0x1000f62c]    ; DAT_1000f62c
  10005b03  XOR ECX,ECX
  10005b05  MOV ESI,EAX
  10005b07  TEST EBX,EBX
  10005b09  SETG CL
  10005b0c  PUSH ECX
  10005b0d  XOR ECX,ECX
  10005b0f  CMP dword ptr [EAX],0x2d
  10005b12  SETZ CL
  10005b15  ADD ECX,dword ptr [EBP + 0xc]
  10005b18  PUSH ECX
  10005b19  CALL 0x10005e05    ; FUN_10005e05
  10005b1e  POP ECX
  10005b1f  POP ECX
  10005b20  JMP 0x10005b5a    ; LAB_10005b5a
LAB_10005b22:
  10005b22  MOV EAX,dword ptr [EBP + 0x8]
  10005b25  PUSH ECX
  10005b26  PUSH ECX
  10005b27  FLD double ptr [EAX]
  10005b29  FSTP double ptr [ESP]
  10005b2c  CALL 0x100083f7    ; FUN_100083f7
  10005b31  MOV EBX,dword ptr [EBP + 0x10]
  10005b34  MOV ESI,EAX
  10005b36  PUSH ESI
  10005b37  MOV EDX,dword ptr [EBP + 0xc]
  10005b3a  LEA EAX,[EBX + 0x1]
  10005b3d  PUSH EAX
  10005b3e  XOR EAX,EAX
  10005b40  CMP dword ptr [ESI],0x2d
  10005b43  SETZ AL
  10005b46  XOR ECX,ECX
  10005b48  TEST EBX,EBX
  10005b4a  SETG CL
  10005b4d  ADD EDX,EAX
  10005b4f  ADD ECX,EDX
  10005b51  PUSH ECX
  10005b52  CALL 0x10008380    ; FUN_10008380
  10005b57  ADD ESP,0x14
LAB_10005b5a:
  10005b5a  CMP dword ptr [ESI],0x2d
  10005b5d  MOV EAX,dword ptr [EBP + 0xc]
  10005b60  JNZ 0x10005b66    ; LAB_10005b66
  10005b62  MOV byte ptr [EAX],0x2d
  10005b65  INC EAX
LAB_10005b66:
  10005b66  TEST EBX,EBX
  10005b68  JLE 0x10005b7e    ; LAB_10005b7e
  10005b6a  MOV CL,byte ptr [EAX + 0x1]
  10005b6d  PUSH EDI
  10005b6e  LEA EDI,[EAX + 0x1]
  10005b71  MOV byte ptr [EAX],CL
  10005b73  MOV CL,byte ptr [0x1000ec98]    ; DAT_1000ec98
  10005b79  MOV EAX,EDI
  10005b7b  POP EDI
  10005b7c  MOV byte ptr [EAX],CL
LAB_10005b7e:
  10005b7e  XOR ECX,ECX
  10005b80  PUSH 0x1000d1a8    ; s_e+000_1000d1a8
  10005b85  CMP byte ptr [0x1000f630],CL    ; DAT_1000f630
  10005b8b  SETZ CL
  10005b8e  ADD ECX,EAX
  10005b90  ADD ECX,EBX
  10005b92  PUSH ECX
  10005b93  CALL 0x10008290    ; FUN_10008290
  10005b98  CMP dword ptr [EBP + 0x14],0x0
  10005b9c  POP ECX
  10005b9d  POP ECX
  10005b9e  MOV ECX,EAX
  10005ba0  JZ 0x10005ba5    ; LAB_10005ba5
  10005ba2  MOV byte ptr [ECX],0x45
LAB_10005ba5:
  10005ba5  MOV EAX,dword ptr [ESI + 0xc]
  10005ba8  INC ECX
  10005ba9  CMP byte ptr [EAX],0x30
  10005bac  JZ 0x10005bea    ; LAB_10005bea
  10005bae  MOV EBX,dword ptr [ESI + 0x4]
  10005bb1  DEC EBX
  10005bb2  JNS 0x10005bb9    ; LAB_10005bb9
  10005bb4  NEG EBX
  10005bb6  MOV byte ptr [ECX],0x2d
LAB_10005bb9:
  10005bb9  INC ECX
  10005bba  CMP EBX,0x64
  10005bbd  JL 0x10005bd0    ; LAB_10005bd0
  10005bbf  MOV EAX,EBX
  10005bc1  PUSH 0x64
  10005bc3  CDQ
  10005bc4  POP ESI
  10005bc5  IDIV ESI
  10005bc7  ADD byte ptr [ECX],AL
  10005bc9  MOV EAX,EBX
  10005bcb  CDQ
  10005bcc  IDIV ESI
  10005bce  MOV EBX,EDX
LAB_10005bd0:
  10005bd0  INC ECX
  10005bd1  CMP EBX,0xa
  10005bd4  JL 0x10005be7    ; LAB_10005be7
  10005bd6  MOV EAX,EBX
  10005bd8  PUSH 0xa
  10005bda  CDQ
  10005bdb  POP ESI
  10005bdc  IDIV ESI
  10005bde  ADD byte ptr [ECX],AL
  10005be0  MOV EAX,EBX
  10005be2  CDQ
  10005be3  IDIV ESI
  10005be5  MOV EBX,EDX
LAB_10005be7:
  10005be7  ADD byte ptr [ECX + 0x1],BL
LAB_10005bea:
  10005bea  MOV EAX,dword ptr [EBP + 0xc]
  10005bed  POP ESI
  10005bee  POP EBX
  10005bef  POP EBP
  10005bf0  RET

;==== FUNCTION FUN_10005bf1 @ 10005bf1 : char * FUN_10005bf1(undefined4 param_1, char * param_2, size_t param_3)
  10005bf1  CMP byte ptr [0x1000f630],0x0    ; DAT_1000f630
  10005bf8  PUSH EBX
  10005bf9  PUSH EBP
  10005bfa  MOV EBP,dword ptr [ESP + 0x10]
  10005bfe  PUSH ESI
  10005bff  PUSH EDI
  10005c00  JZ 0x10005c2c    ; LAB_10005c2c
  10005c02  MOV EAX,[0x1000f634]    ; DAT_1000f634
  10005c07  MOV EBX,dword ptr [ESP + 0x1c]
  10005c0b  MOV ESI,dword ptr [0x1000f62c]    ; DAT_1000f62c
  10005c11  CMP EAX,EBX
  10005c13  JNZ 0x10005c5c    ; LAB_10005c5c
  10005c15  XOR ECX,ECX
  10005c17  CMP dword ptr [ESI],0x2d
  10005c1a  SETZ CL
  10005c1d  ADD ECX,EAX
  10005c1f  ADD ECX,EBP
  10005c21  MOV EAX,ECX
  10005c23  MOV byte ptr [EAX],0x30
  10005c26  AND byte ptr [EAX + 0x1],0x0
  10005c2a  JMP 0x10005c5c    ; LAB_10005c5c
LAB_10005c2c:
  10005c2c  MOV EAX,dword ptr [ESP + 0x14]
  10005c30  PUSH ECX
  10005c31  PUSH ECX
  10005c32  FLD double ptr [EAX]
  10005c34  FSTP double ptr [ESP]
  10005c37  CALL 0x100083f7    ; FUN_100083f7
  10005c3c  MOV EBX,dword ptr [ESP + 0x24]
  10005c40  MOV ESI,EAX
  10005c42  PUSH ESI
  10005c43  MOV EAX,dword ptr [ESI + 0x4]
  10005c46  ADD EAX,EBX
  10005c48  PUSH EAX
  10005c49  XOR EAX,EAX
  10005c4b  CMP dword ptr [ESI],0x2d
  10005c4e  SETZ AL
  10005c51  ADD EAX,EBP
  10005c53  PUSH EAX
  10005c54  CALL 0x10008380    ; FUN_10008380
  10005c59  ADD ESP,0x14
LAB_10005c5c:
  10005c5c  CMP dword ptr [ESI],0x2d
  10005c5f  MOV EDI,EBP
  10005c61  JNZ 0x10005c6a    ; LAB_10005c6a
  10005c63  MOV byte ptr [EBP],0x2d
  10005c67  LEA EDI,[EBP + 0x1]
LAB_10005c6a:
  10005c6a  MOV EAX,dword ptr [ESI + 0x4]
  10005c6d  TEST EAX,EAX
  10005c6f  JG 0x10005c81    ; LAB_10005c81
  10005c71  PUSH 0x1
  10005c73  PUSH EDI
  10005c74  CALL 0x10005e05    ; FUN_10005e05
  10005c79  POP ECX
  10005c7a  MOV byte ptr [EDI],0x30
  10005c7d  POP ECX
  10005c7e  INC EDI
  10005c7f  JMP 0x10005c83    ; LAB_10005c83
LAB_10005c81:
  10005c81  ADD EDI,EAX
LAB_10005c83:
  10005c83  TEST EBX,EBX
  10005c85  JLE 0x10005cc8    ; LAB_10005cc8
  10005c87  PUSH 0x1
  10005c89  PUSH EDI
  10005c8a  CALL 0x10005e05    ; FUN_10005e05
  10005c8f  MOV AL,[0x1000ec98]    ; DAT_1000ec98
  10005c94  POP ECX
  10005c95  MOV byte ptr [EDI],AL
  10005c97  MOV ESI,dword ptr [ESI + 0x4]
  10005c9a  INC EDI
  10005c9b  POP ECX
  10005c9c  TEST ESI,ESI
  10005c9e  JGE 0x10005cc8    ; LAB_10005cc8
  10005ca0  CMP byte ptr [0x1000f630],0x0    ; DAT_1000f630
  10005ca7  JZ 0x10005cad    ; LAB_10005cad
  10005ca9  NEG ESI
  10005cab  JMP 0x10005cb3    ; LAB_10005cb3
LAB_10005cad:
  10005cad  NEG ESI
  10005caf  CMP EBX,ESI
  10005cb1  JL 0x10005cb5    ; LAB_10005cb5
LAB_10005cb3:
  10005cb3  MOV EBX,ESI
LAB_10005cb5:
  10005cb5  PUSH EBX
  10005cb6  PUSH EDI
  10005cb7  CALL 0x10005e05    ; FUN_10005e05
  10005cbc  PUSH EBX
  10005cbd  PUSH 0x30
  10005cbf  PUSH EDI
  10005cc0  CALL 0x10008520    ; _memset
  10005cc5  ADD ESP,0x14
LAB_10005cc8:
  10005cc8  POP EDI
  10005cc9  MOV EAX,EBP
  10005ccb  POP ESI
  10005ccc  POP EBP
  10005ccd  POP EBX
  10005cce  RET

;==== FUNCTION FUN_10005ccf @ 10005ccf : undefined FUN_10005ccf(undefined4 param_1, char * param_2, size_t param_3, int param_4)
  10005ccf  PUSH EBP
  10005cd0  MOV EBP,ESP
  10005cd2  PUSH EBX
  10005cd3  PUSH ESI
  10005cd4  PUSH EDI
  10005cd5  MOV EDI,dword ptr [EBP + 0x8]
  10005cd8  PUSH ECX
  10005cd9  PUSH ECX
  10005cda  FLD double ptr [EDI]
  10005cdc  FSTP double ptr [ESP]
  10005cdf  CALL 0x100083f7    ; FUN_100083f7
  10005ce4  MOV [0x1000f62c],EAX    ; DAT_1000f62c
  10005ce9  MOV ECX,dword ptr [EAX + 0x4]
  10005cec  DEC ECX
  10005ced  MOV EBX,dword ptr [EBP + 0x10]
  10005cf0  MOV dword ptr [0x1000f634],ECX    ; DAT_1000f634
  10005cf6  XOR ECX,ECX
  10005cf8  CMP dword ptr [EAX],0x2d
  10005cfb  PUSH EAX
  10005cfc  PUSH EBX
  10005cfd  SETZ CL
  10005d00  ADD ECX,dword ptr [EBP + 0xc]
  10005d03  MOV ESI,ECX
  10005d05  PUSH ESI
  10005d06  CALL 0x10008380    ; FUN_10008380
  10005d0b  MOV EAX,[0x1000f62c]    ; DAT_1000f62c
  10005d10  ADD ESP,0x14
  10005d13  MOV ECX,dword ptr [EAX + 0x4]
  10005d16  DEC ECX
  10005d17  CMP dword ptr [0x1000f634],ECX    ; DAT_1000f634
  10005d1d  SETL CL
  10005d20  MOV byte ptr [0x1000f638],CL    ; DAT_1000f638
  10005d26  MOV EAX,dword ptr [EAX + 0x4]
  10005d29  DEC EAX
  10005d2a  CMP EAX,-0x4
  10005d2d  MOV [0x1000f634],EAX    ; DAT_1000f634
  10005d32  JL 0x10005d55    ; LAB_10005d55
  10005d34  CMP EAX,EBX
  10005d36  JGE 0x10005d55    ; LAB_10005d55
  10005d38  TEST CL,CL
  10005d3a  JZ 0x10005d46    ; LAB_10005d46
LAB_10005d3c:
  10005d3c  MOV AL,byte ptr [ESI]
  10005d3e  INC ESI
  10005d3f  TEST AL,AL
  10005d41  JNZ 0x10005d3c    ; LAB_10005d3c
  10005d43  AND byte ptr [ESI + -0x2],AL
LAB_10005d46:
  10005d46  PUSH EBX
  10005d47  PUSH dword ptr [EBP + 0xc]
  10005d4a  PUSH EDI
  10005d4b  CALL 0x10005d91    ; FUN_10005d91
  10005d50  ADD ESP,0xc
  10005d53  JMP 0x10005d65    ; LAB_10005d65
LAB_10005d55:
  10005d55  PUSH dword ptr [EBP + 0x14]
  10005d58  PUSH EBX
  10005d59  PUSH dword ptr [EBP + 0xc]
  10005d5c  PUSH EDI
  10005d5d  CALL 0x10005d6a    ; FUN_10005d6a
  10005d62  ADD ESP,0x10
LAB_10005d65:
  10005d65  POP EDI
  10005d66  POP ESI
  10005d67  POP EBX
  10005d68  POP EBP
  10005d69  RET

;==== FUNCTION FUN_10005d6a @ 10005d6a : undefined FUN_10005d6a(undefined4 param_1, undefined1 * param_2, int param_3, int param_4)
  10005d6a  PUSH dword ptr [ESP + 0x10]
  10005d6e  MOV byte ptr [0x1000f630],0x1    ; DAT_1000f630
  10005d75  PUSH dword ptr [ESP + 0x10]
  10005d79  PUSH dword ptr [ESP + 0x10]
  10005d7d  PUSH dword ptr [ESP + 0x10]
  10005d81  CALL 0x10005aed    ; FUN_10005aed
  10005d86  AND byte ptr [0x1000f630],0x0    ; DAT_1000f630
  10005d8d  ADD ESP,0x10
  10005d90  RET

;==== FUNCTION FUN_10005d91 @ 10005d91 : undefined FUN_10005d91(undefined4 param_1, char * param_2, size_t param_3)
  10005d91  PUSH dword ptr [ESP + 0xc]
  10005d95  MOV byte ptr [0x1000f630],0x1    ; DAT_1000f630
  10005d9c  PUSH dword ptr [ESP + 0xc]
  10005da0  PUSH dword ptr [ESP + 0xc]
  10005da4  CALL 0x10005bf1    ; FUN_10005bf1
  10005da9  AND byte ptr [0x1000f630],0x0    ; DAT_1000f630
  10005db0  ADD ESP,0xc
  10005db3  RET

;==== FUNCTION __cfltcvt @ 10005db4 : errno_t __cfltcvt(double * arg, char * buffer, size_t sizeInBytes, int format, int precision, int caps)
  10005db4  PUSH EBP
  10005db5  MOV EBP,ESP
  10005db7  CMP dword ptr [EBP + 0x10],0x65
  10005dbb  JZ 0x10005def    ; LAB_10005def
  10005dbd  CMP dword ptr [EBP + 0x10],0x45
  10005dc1  JZ 0x10005def    ; LAB_10005def
  10005dc3  CMP dword ptr [EBP + 0x10],0x66
  10005dc7  JNZ 0x10005ddc    ; LAB_10005ddc
  10005dc9  PUSH dword ptr [EBP + 0x14]
  10005dcc  PUSH dword ptr [EBP + 0xc]
  10005dcf  PUSH dword ptr [EBP + 0x8]
  10005dd2  CALL 0x10005bf1    ; FUN_10005bf1
  10005dd7  ADD ESP,0xc
  10005dda  POP EBP
  10005ddb  RET
LAB_10005ddc:
  10005ddc  PUSH dword ptr [EBP + 0x18]
  10005ddf  PUSH dword ptr [EBP + 0x14]
  10005de2  PUSH dword ptr [EBP + 0xc]
  10005de5  PUSH dword ptr [EBP + 0x8]
  10005de8  CALL 0x10005ccf    ; FUN_10005ccf
  10005ded  JMP 0x10005e00    ; LAB_10005e00
LAB_10005def:
  10005def  PUSH dword ptr [EBP + 0x18]
  10005df2  PUSH dword ptr [EBP + 0x14]
  10005df5  PUSH dword ptr [EBP + 0xc]
  10005df8  PUSH dword ptr [EBP + 0x8]
  10005dfb  CALL 0x10005aed    ; FUN_10005aed
LAB_10005e00:
  10005e00  ADD ESP,0x10
  10005e03  POP EBP
  10005e04  RET

;==== FUNCTION FUN_10005e05 @ 10005e05 : undefined FUN_10005e05(char * param_1, int param_2)
  10005e05  PUSH EDI
  10005e06  MOV EDI,dword ptr [ESP + 0xc]
  10005e0a  TEST EDI,EDI
  10005e0c  JZ 0x10005e28    ; LAB_10005e28
  10005e0e  PUSH ESI
  10005e0f  MOV ESI,dword ptr [ESP + 0xc]
  10005e13  PUSH ESI
  10005e14  CALL 0x100088c0    ; _strlen
  10005e19  INC EAX
  10005e1a  PUSH EAX
  10005e1b  PUSH ESI
  10005e1c  ADD ESI,EDI
  10005e1e  PUSH ESI
  10005e1f  CALL 0x10008580    ; FUN_10008580
  10005e24  ADD ESP,0x10
  10005e27  POP ESI
LAB_10005e28:
  10005e28  POP EDI
  10005e29  RET

;==== FUNCTION FUN_10005e2a @ 10005e2a : undefined FUN_10005e2a(LPVOID param_1)
  10005e2a  PUSH ESI
  10005e2b  MOV ESI,dword ptr [ESP + 0x8]
  10005e2f  TEST ESI,ESI
  10005e31  JZ 0x10005e57    ; LAB_10005e57
  10005e33  PUSH ESI
  10005e34  CALL 0x1000899f    ; FUN_1000899f
  10005e39  POP ECX
  10005e3a  TEST EAX,EAX
  10005e3c  PUSH ESI
  10005e3d  JZ 0x10005e49    ; LAB_10005e49
  10005e3f  PUSH EAX
  10005e40  CALL 0x100089ca    ; FUN_100089ca
  10005e45  POP ECX
  10005e46  POP ECX
  10005e47  POP ESI
  10005e48  RET
LAB_10005e49:
  10005e49  PUSH 0x0
  10005e4b  PUSH dword ptr [0x10010ba4]    ; DAT_10010ba4
  10005e51  CALL dword ptr [0x1000d034]    ; PTR_HeapFree_1000d034 KERNEL32.DLL::HeapFree
LAB_10005e57:
  10005e57  POP ESI
  10005e58  RET

;==== FUNCTION _malloc @ 10005e59 : void * _malloc(size_t _Size)
  10005e59  PUSH dword ptr [0x1000f7d8]    ; DAT_1000f7d8
  10005e5f  PUSH dword ptr [ESP + 0x8]
  10005e63  CALL 0x10005e6b    ; __nh_malloc
  10005e68  POP ECX
  10005e69  POP ECX
  10005e6a  RET

;==== FUNCTION __nh_malloc @ 10005e6b : void * __nh_malloc(size_t _Size, int _NhFlag)
  10005e6b  CMP dword ptr [ESP + 0x4],-0x20
  10005e70  JA 0x10005e94    ; LAB_10005e94
LAB_10005e72:
  10005e72  PUSH dword ptr [ESP + 0x4]
  10005e76  CALL 0x10005e97    ; FUN_10005e97
  10005e7b  TEST EAX,EAX
  10005e7d  POP ECX
  10005e7e  JNZ 0x10005e96    ; LAB_10005e96
  10005e80  CMP dword ptr [ESP + 0x8],EAX
  10005e84  JZ 0x10005e96    ; LAB_10005e96
  10005e86  PUSH dword ptr [ESP + 0x4]
  10005e8a  CALL 0x100098b6    ; FUN_100098b6
  10005e8f  TEST EAX,EAX
  10005e91  POP ECX
  10005e92  JNZ 0x10005e72    ; LAB_10005e72
LAB_10005e94:
  10005e94  XOR EAX,EAX
LAB_10005e96:
  10005e96  RET

;==== FUNCTION FUN_10005e97 @ 10005e97 : undefined FUN_10005e97(uint * param_1)
  10005e97  PUSH ESI
  10005e98  MOV ESI,dword ptr [ESP + 0x8]
  10005e9c  CMP ESI,dword ptr [0x1000ed70]    ; DAT_1000ed70
  10005ea2  JA 0x10005eaf    ; LAB_10005eaf
  10005ea4  PUSH ESI
  10005ea5  CALL 0x10008cf5    ; FUN_10008cf5
  10005eaa  TEST EAX,EAX
  10005eac  POP ECX
  10005ead  JNZ 0x10005ecb    ; LAB_10005ecb
LAB_10005eaf:
  10005eaf  TEST ESI,ESI
  10005eb1  JNZ 0x10005eb6    ; LAB_10005eb6
  10005eb3  PUSH 0x1
  10005eb5  POP ESI
LAB_10005eb6:
  10005eb6  ADD ESI,0xf
  10005eb9  AND ESI,0xfffffff0
  10005ebc  PUSH ESI
  10005ebd  PUSH 0x0
  10005ebf  PUSH dword ptr [0x10010ba4]    ; DAT_10010ba4
  10005ec5  CALL dword ptr [0x1000d038]    ; PTR_HeapAlloc_1000d038 KERNEL32.DLL::HeapAlloc
LAB_10005ecb:
  10005ecb  POP ESI
  10005ecc  RET

;==== FUNCTION FUN_10005ecd @ 10005ecd : uint FUN_10005ecd(uint param_1, int * param_2)
  10005ecd  PUSH EBP
  10005ece  MOV EBP,ESP
  10005ed0  PUSH EBX
  10005ed1  PUSH ESI
  10005ed2  MOV ESI,dword ptr [EBP + 0xc]
  10005ed5  MOV EAX,dword ptr [ESI + 0xc]
  10005ed8  MOV EBX,dword ptr [ESI + 0x10]
  10005edb  TEST AL,0x82
  10005edd  JZ 0x10005fd6    ; LAB_10005fd6
  10005ee3  TEST AL,0x40
  10005ee5  JNZ 0x10005fd6    ; LAB_10005fd6
  10005eeb  TEST AL,0x1
  10005eed  JZ 0x10005f05    ; LAB_10005f05
  10005eef  AND dword ptr [ESI + 0x4],0x0
  10005ef3  TEST AL,0x10
  10005ef5  JZ 0x10005fd6    ; LAB_10005fd6
  10005efb  MOV ECX,dword ptr [ESI + 0x8]
  10005efe  AND AL,0xfe
  10005f00  MOV dword ptr [ESI],ECX
  10005f02  MOV dword ptr [ESI + 0xc],EAX
LAB_10005f05:
  10005f05  MOV EAX,dword ptr [ESI + 0xc]
  10005f08  AND dword ptr [ESI + 0x4],0x0
  10005f0c  AND dword ptr [EBP + 0xc],0x0
  10005f10  AND AL,0xef
  10005f12  OR AL,0x2
  10005f14  TEST AX,0x10c
  10005f18  MOV dword ptr [ESI + 0xc],EAX
  10005f1b  JNZ 0x10005f3f    ; LAB_10005f3f
  10005f1d  CMP ESI,0x1000ed98    ; DAT_1000ed98
  10005f23  JZ 0x10005f2d    ; LAB_10005f2d
  10005f25  CMP ESI,0x1000edb8    ; DAT_1000edb8
  10005f2b  JNZ 0x10005f38    ; LAB_10005f38
LAB_10005f2d:
  10005f2d  PUSH EBX
  10005f2e  CALL 0x10009b5c    ; FUN_10009b5c
  10005f33  TEST EAX,EAX
  10005f35  POP ECX
  10005f36  JNZ 0x10005f3f    ; LAB_10005f3f
LAB_10005f38:
  10005f38  PUSH ESI
  10005f39  CALL 0x10009b18    ; FUN_10009b18
  10005f3e  POP ECX
LAB_10005f3f:
  10005f3f  TEST word ptr [ESI + 0xc],0x108
  10005f45  PUSH EDI
  10005f46  JZ 0x10005fac    ; LAB_10005fac
  10005f48  MOV EAX,dword ptr [ESI + 0x8]
  10005f4b  MOV EDI,dword ptr [ESI]
  10005f4d  SUB EDI,EAX
  10005f4f  LEA ECX,[EAX + 0x1]
  10005f52  MOV dword ptr [ESI],ECX
  10005f54  MOV ECX,dword ptr [ESI + 0x18]
  10005f57  DEC ECX
  10005f58  TEST EDI,EDI
  10005f5a  MOV dword ptr [ESI + 0x4],ECX
  10005f5d  JLE 0x10005f6f    ; LAB_10005f6f
  10005f5f  PUSH EDI
  10005f60  PUSH EAX
  10005f61  PUSH EBX
  10005f62  CALL 0x1000996b    ; FUN_1000996b
  10005f67  ADD ESP,0xc
  10005f6a  MOV dword ptr [EBP + 0xc],EAX
  10005f6d  JMP 0x10005fa2    ; LAB_10005fa2
LAB_10005f6f:
  10005f6f  CMP EBX,-0x1
  10005f72  JZ 0x10005f8a    ; LAB_10005f8a
  10005f74  MOV EAX,EBX
  10005f76  MOV ECX,EBX
  10005f78  SAR EAX,0x5
  10005f7b  AND ECX,0x1f
  10005f7e  MOV EAX,dword ptr [EAX*0x4 + 0x10010aa0]    ; DAT_10010aa0
  10005f85  LEA EAX,[EAX + ECX*0x8]
  10005f88  JMP 0x10005f8f    ; LAB_10005f8f
LAB_10005f8a:
  10005f8a  MOV EAX,0x1000eca8    ; DAT_1000eca8
LAB_10005f8f:
  10005f8f  TEST byte ptr [EAX + 0x4],0x20    ; DAT_1000ecac
  10005f93  JZ 0x10005fa2    ; LAB_10005fa2
  10005f95  PUSH 0x2
  10005f97  PUSH 0x0
  10005f99  PUSH EBX
  10005f9a  CALL 0x100098d1    ; FUN_100098d1
  10005f9f  ADD ESP,0xc
LAB_10005fa2:
  10005fa2  MOV EAX,dword ptr [ESI + 0x8]
  10005fa5  MOV CL,byte ptr [EBP + 0x8]
  10005fa8  MOV byte ptr [EAX],CL
  10005faa  JMP 0x10005fc0    ; LAB_10005fc0
LAB_10005fac:
  10005fac  PUSH 0x1
  10005fae  LEA EAX,[EBP + 0x8]
  10005fb1  POP EDI
  10005fb2  PUSH EDI
  10005fb3  PUSH EAX
  10005fb4  PUSH EBX
  10005fb5  CALL 0x1000996b    ; FUN_1000996b
  10005fba  ADD ESP,0xc
  10005fbd  MOV dword ptr [EBP + 0xc],EAX
LAB_10005fc0:
  10005fc0  CMP dword ptr [EBP + 0xc],EDI
  10005fc3  POP EDI
  10005fc4  JZ 0x10005fcc    ; LAB_10005fcc
  10005fc6  OR dword ptr [ESI + 0xc],0x20
  10005fca  JMP 0x10005fdb    ; LAB_10005fdb
LAB_10005fcc:
  10005fcc  MOV EAX,dword ptr [EBP + 0x8]
  10005fcf  AND EAX,0xff
  10005fd4  JMP 0x10005fde    ; LAB_10005fde
LAB_10005fd6:
  10005fd6  OR AL,0x20
  10005fd8  MOV dword ptr [ESI + 0xc],EAX
LAB_10005fdb:
  10005fdb  OR EAX,0xffffffff
LAB_10005fde:
  10005fde  POP ESI
  10005fdf  POP EBX
  10005fe0  POP EBP
  10005fe1  RET

;==== FUNCTION FUN_10005fe2 @ 10005fe2 : int FUN_10005fe2(int * param_1, byte * param_2, undefined4 * param_3)
  10005fe2  PUSH EBP
  10005fe3  MOV EBP,ESP
  10005fe5  SUB ESP,0x248
  10005feb  PUSH EBX
  10005fec  PUSH ESI
  10005fed  PUSH EDI
  10005fee  MOV EDI,dword ptr [EBP + 0xc]
  10005ff1  XOR ESI,ESI
  10005ff3  MOV BL,byte ptr [EDI]
  10005ff5  INC EDI
  10005ff6  TEST BL,BL
  10005ff8  MOV dword ptr [EBP + -0xc],ESI
  10005ffb  MOV dword ptr [EBP + -0x14],ESI
  10005ffe  MOV dword ptr [EBP + 0xc],EDI
  10006001  JZ 0x100066fb    ; LAB_100066fb
  10006007  MOV ECX,dword ptr [EBP + -0x10]
  1000600a  XOR EDX,EDX
  1000600c  JMP 0x10006016    ; LAB_10006016
LAB_1000600e:
  1000600e  MOV ECX,dword ptr [EBP + -0x10]
  10006011  MOV ESI,dword ptr [EBP + -0x30]
  10006014  XOR EDX,EDX
LAB_10006016:
  10006016  CMP dword ptr [EBP + -0x14],EDX
  10006019  JL 0x100066fb    ; LAB_100066fb
  1000601f  CMP BL,0x20
  10006022  JL 0x10006037    ; LAB_10006037
  10006024  CMP BL,0x78
  10006027  JG 0x10006037    ; LAB_10006037
  10006029  MOVSX EAX,BL
  1000602c  MOV AL,byte ptr [EAX + 0x1000d190]    ; s_t_1000d176+0x1a
  10006032  AND EAX,0xf
  10006035  JMP 0x10006039    ; LAB_10006039
LAB_10006037:
  10006037  XOR EAX,EAX
LAB_10006039:
  10006039  MOVSX EAX,byte ptr [ESI + EAX*0x8 + 0x1000d1b0]    ; DAT_1000d1b0
  10006041  SAR EAX,0x4
  10006044  CMP EAX,0x7
  10006047  MOV dword ptr [EBP + -0x30],EAX
  1000604a  JA 0x100066ea    ; switchD_10006050::default
switchD:
  10006050  JMP dword ptr [EAX*0x4 + 0x10006703]    ; switchD_10006050::caseD_0 switchD_10006050::caseD_1 switchD_10006050::caseD_2 switchD_10006050::caseD_3 switchD_10006050::caseD_4 switchD_10006050::caseD_5 switchD_10006050::caseD_6 switchD_10006050::caseD_7 switchD_10006050::switchdataD_10006703
caseD_1:
  10006057  OR dword ptr [EBP + -0x10],0xffffffff
  1000605b  MOV dword ptr [EBP + -0x34],EDX
  1000605e  MOV dword ptr [EBP + -0x28],EDX
  10006061  MOV dword ptr [EBP + -0x20],EDX
  10006064  MOV dword ptr [EBP + -0x1c],EDX
  10006067  MOV dword ptr [EBP + -0x4],EDX
  1000606a  MOV dword ptr [EBP + -0x24],EDX
  1000606d  JMP 0x100066ea    ; switchD_10006050::default
caseD_2:
  10006072  MOVSX EAX,BL
  10006075  SUB EAX,0x20
  10006078  JZ 0x100060b5    ; LAB_100060b5
  1000607a  SUB EAX,0x3
  1000607d  JZ 0x100060ac    ; LAB_100060ac
  1000607f  SUB EAX,0x8
  10006082  JZ 0x100060a3    ; LAB_100060a3
  10006084  DEC EAX
  10006085  DEC EAX
  10006086  JZ 0x1000609a    ; LAB_1000609a
  10006088  SUB EAX,0x3
  1000608b  JNZ 0x100066ea    ; switchD_10006050::default
  10006091  OR dword ptr [EBP + -0x4],0x8
  10006095  JMP 0x100066ea    ; switchD_10006050::default
LAB_1000609a:
  1000609a  OR dword ptr [EBP + -0x4],0x4
  1000609e  JMP 0x100066ea    ; switchD_10006050::default
LAB_100060a3:
  100060a3  OR dword ptr [EBP + -0x4],0x1
  100060a7  JMP 0x100066ea    ; switchD_10006050::default
LAB_100060ac:
  100060ac  OR byte ptr [EBP + -0x4],0x80
  100060b0  JMP 0x100066ea    ; switchD_10006050::default
LAB_100060b5:
  100060b5  OR dword ptr [EBP + -0x4],0x2
  100060b9  JMP 0x100066ea    ; switchD_10006050::default
caseD_3:
  100060be  CMP BL,0x2a
  100060c1  JNZ 0x100060e6    ; LAB_100060e6
  100060c3  LEA EAX,[EBP + 0x10]
  100060c6  PUSH EAX
  100060c7  CALL 0x100067c1    ; FUN_100067c1
  100060cc  TEST EAX,EAX
  100060ce  POP ECX
  100060cf  MOV dword ptr [EBP + -0x20],EAX
  100060d2  JGE 0x100066ea    ; switchD_10006050::default
  100060d8  OR dword ptr [EBP + -0x4],0x4
  100060dc  NEG EAX
LAB_100060de:
  100060de  MOV dword ptr [EBP + -0x20],EAX
  100060e1  JMP 0x100066ea    ; switchD_10006050::default
LAB_100060e6:
  100060e6  MOV EAX,dword ptr [EBP + -0x20]
  100060e9  MOVSX ECX,BL
  100060ec  LEA EAX,[EAX + EAX*0x4]
  100060ef  LEA EAX,[ECX + EAX*0x2 + -0x30]
  100060f3  JMP 0x100060de    ; LAB_100060de
caseD_4:
  100060f5  MOV dword ptr [EBP + -0x10],EDX
  100060f8  JMP 0x100066ea    ; switchD_10006050::default
caseD_5:
  100060fd  CMP BL,0x2a
  10006100  JNZ 0x10006120    ; LAB_10006120
  10006102  LEA EAX,[EBP + 0x10]
  10006105  PUSH EAX
  10006106  CALL 0x100067c1    ; FUN_100067c1
  1000610b  TEST EAX,EAX
  1000610d  POP ECX
  1000610e  MOV dword ptr [EBP + -0x10],EAX
  10006111  JGE 0x100066ea    ; switchD_10006050::default
  10006117  OR dword ptr [EBP + -0x10],0xffffffff
  1000611b  JMP 0x100066ea    ; switchD_10006050::default
LAB_10006120:
  10006120  LEA EAX,[ECX + ECX*0x4]
  10006123  MOVSX ECX,BL
  10006126  LEA EAX,[ECX + EAX*0x2 + -0x30]
  1000612a  MOV dword ptr [EBP + -0x10],EAX
  1000612d  JMP 0x100066ea    ; switchD_10006050::default
caseD_6:
  10006132  CMP BL,0x49
  10006135  JZ 0x10006165    ; LAB_10006165
  10006137  CMP BL,0x68
  1000613a  JZ 0x1000615c    ; LAB_1000615c
  1000613c  CMP BL,0x6c
  1000613f  JZ 0x10006153    ; LAB_10006153
  10006141  CMP BL,0x77
  10006144  JNZ 0x100066ea    ; switchD_10006050::default
  1000614a  OR byte ptr [EBP + -0x3],0x8
  1000614e  JMP 0x100066ea    ; switchD_10006050::default
LAB_10006153:
  10006153  OR dword ptr [EBP + -0x4],0x10
  10006157  JMP 0x100066ea    ; switchD_10006050::default
LAB_1000615c:
  1000615c  OR dword ptr [EBP + -0x4],0x20
  10006160  JMP 0x100066ea    ; switchD_10006050::default
LAB_10006165:
  10006165  CMP byte ptr [EDI],0x36
  10006168  JNZ 0x1000617e    ; LAB_1000617e
  1000616a  CMP byte ptr [EDI + 0x1],0x34
  1000616e  JNZ 0x1000617e    ; LAB_1000617e
  10006170  INC EDI
  10006171  INC EDI
  10006172  OR byte ptr [EBP + -0x3],0x80
  10006176  MOV dword ptr [EBP + 0xc],EDI
  10006179  JMP 0x100066ea    ; switchD_10006050::default
LAB_1000617e:
  1000617e  MOV dword ptr [EBP + -0x30],EDX
caseD_0:
  10006181  MOV ECX,dword ptr [0x1000ea88]    ; PTR_DAT_1000ea88
  10006187  MOV dword ptr [EBP + -0x24],EDX
  1000618a  MOVZX EAX,BL
  1000618d  TEST byte ptr [ECX + EAX*0x2 + 0x1],0x80    ; DAT_1000ea93
  10006192  JZ 0x100061ad    ; LAB_100061ad
  10006194  LEA EAX,[EBP + -0x14]
  10006197  PUSH EAX
  10006198  PUSH dword ptr [EBP + 0x8]
  1000619b  MOVSX EAX,BL
  1000619e  PUSH EAX
  1000619f  CALL 0x10006723    ; FUN_10006723
  100061a4  MOV BL,byte ptr [EDI]
  100061a6  ADD ESP,0xc
  100061a9  INC EDI
  100061aa  MOV dword ptr [EBP + 0xc],EDI
LAB_100061ad:
  100061ad  LEA EAX,[EBP + -0x14]
  100061b0  PUSH EAX
  100061b1  PUSH dword ptr [EBP + 0x8]
  100061b4  MOVSX EAX,BL
  100061b7  PUSH EAX
  100061b8  CALL 0x10006723    ; FUN_10006723
  100061bd  ADD ESP,0xc
  100061c0  JMP 0x100066ea    ; switchD_10006050::default
caseD_7:
  100061c5  MOVSX EAX,BL
  100061c8  CMP EAX,0x67
  100061cb  JG 0x100063ed    ; LAB_100063ed
  100061d1  CMP EAX,0x65
  100061d4  JGE 0x10006270    ; LAB_10006270
  100061da  CMP EAX,0x58
  100061dd  JG 0x100062ce    ; LAB_100062ce
  100061e3  JZ 0x10006461    ; LAB_10006461
  100061e9  SUB EAX,0x43
  100061ec  JZ 0x10006291    ; LAB_10006291
  100061f2  DEC EAX
  100061f3  DEC EAX
  100061f4  JZ 0x10006266    ; LAB_10006266
  100061f6  DEC EAX
  100061f7  DEC EAX
  100061f8  JZ 0x10006266    ; LAB_10006266
  100061fa  SUB EAX,0xc
  100061fd  JNZ 0x100065ec    ; LAB_100065ec
  10006203  TEST word ptr [EBP + -0x4],0x830
  10006209  JNZ 0x1000620f    ; LAB_1000620f
  1000620b  OR byte ptr [EBP + -0x3],0x8
LAB_1000620f:
  1000620f  MOV ESI,dword ptr [EBP + -0x10]
  10006212  CMP ESI,-0x1
  10006215  JNZ 0x1000621c    ; LAB_1000621c
  10006217  MOV ESI,0x7fffffff
LAB_1000621c:
  1000621c  LEA EAX,[EBP + 0x10]
  1000621f  PUSH EAX
  10006220  CALL 0x100067c1    ; FUN_100067c1
  10006225  TEST word ptr [EBP + -0x4],0x810
  1000622b  POP ECX
  1000622c  MOV ECX,EAX
  1000622e  MOV dword ptr [EBP + -0x8],ECX
  10006231  JZ 0x10006435    ; LAB_10006435
  10006237  TEST ECX,ECX
  10006239  JNZ 0x10006244    ; LAB_10006244
  1000623b  MOV ECX,dword ptr [0x1000ea70]    ; PTR_DAT_1000ea70
  10006241  MOV dword ptr [EBP + -0x8],ECX    ; DAT_1000d20c
LAB_10006244:
  10006244  MOV dword ptr [EBP + -0x24],0x1
  1000624b  MOV EAX,ECX
LAB_1000624d:
  1000624d  MOV EDX,ESI
  1000624f  DEC ESI
  10006250  TEST EDX,EDX
  10006252  JZ 0x1000642c    ; LAB_1000642c
  10006258  CMP word ptr [EAX],0x0    ; DAT_1000d20c u_null)_1000d20e
  1000625c  JZ 0x1000642c    ; LAB_1000642c
  10006262  INC EAX
  10006263  INC EAX
  10006264  JMP 0x1000624d    ; LAB_1000624d
LAB_10006266:
  10006266  MOV dword ptr [EBP + -0x34],0x1
  1000626d  ADD BL,0x20
LAB_10006270:
  10006270  OR dword ptr [EBP + -0x4],0x40
  10006274  LEA EDI,[EBP + 0xfffffdb8]
  1000627a  CMP ECX,EDX
  1000627c  MOV dword ptr [EBP + -0x8],EDI
  1000627f  JGE 0x10006354    ; LAB_10006354
  10006285  MOV dword ptr [EBP + -0x10],0x6
  1000628c  JMP 0x10006362    ; LAB_10006362
LAB_10006291:
  10006291  TEST word ptr [EBP + -0x4],0x830
  10006297  JNZ 0x1000629d    ; LAB_1000629d
  10006299  OR byte ptr [EBP + -0x3],0x8
LAB_1000629d:
  1000629d  TEST word ptr [EBP + -0x4],0x810
  100062a3  LEA EAX,[EBP + 0x10]
  100062a6  PUSH EAX
  100062a7  JZ 0x100062e4    ; LAB_100062e4
  100062a9  CALL 0x100067de    ; FUN_100067de
  100062ae  PUSH EAX
  100062af  LEA EAX,[EBP + 0xfffffdb8]
  100062b5  PUSH EAX
  100062b6  CALL 0x10009c3b    ; FUN_10009c3b
  100062bb  ADD ESP,0xc
  100062be  MOV dword ptr [EBP + -0xc],EAX
  100062c1  TEST EAX,EAX
  100062c3  JGE 0x100062f7    ; LAB_100062f7
  100062c5  MOV dword ptr [EBP + -0x28],0x1
  100062cc  JMP 0x100062f7    ; LAB_100062f7
LAB_100062ce:
  100062ce  SUB EAX,0x5a
  100062d1  JZ 0x10006305    ; LAB_10006305
  100062d3  SUB EAX,0x9
  100062d6  JZ 0x1000629d    ; LAB_1000629d
  100062d8  DEC EAX
  100062d9  JZ 0x100064c7    ; LAB_100064c7
  100062df  JMP 0x100065ec    ; LAB_100065ec
LAB_100062e4:
  100062e4  CALL 0x100067c1    ; FUN_100067c1
  100062e9  POP ECX
  100062ea  MOV byte ptr [EBP + 0xfffffdb8],AL
  100062f0  MOV dword ptr [EBP + -0xc],0x1
LAB_100062f7:
  100062f7  LEA EAX,[EBP + 0xfffffdb8]
  100062fd  MOV dword ptr [EBP + -0x8],EAX
  10006300  JMP 0x100065ec    ; LAB_100065ec
LAB_10006305:
  10006305  LEA EAX,[EBP + 0x10]
  10006308  PUSH EAX
  10006309  CALL 0x100067c1    ; FUN_100067c1
  1000630e  TEST EAX,EAX
  10006310  POP ECX
  10006311  JZ 0x10006346    ; LAB_10006346
  10006313  MOV ECX,dword ptr [EAX + 0x4]
  10006316  TEST ECX,ECX
  10006318  JZ 0x10006346    ; LAB_10006346
  1000631a  TEST byte ptr [EBP + -0x3],0x8
  1000631e  JZ 0x10006337    ; LAB_10006337
  10006320  MOVSX EAX,word ptr [EAX]
  10006323  SHR EAX,0x1
  10006325  MOV dword ptr [EBP + -0x8],ECX
  10006328  MOV dword ptr [EBP + -0xc],EAX
  1000632b  MOV dword ptr [EBP + -0x24],0x1
  10006332  JMP 0x100065ec    ; LAB_100065ec
LAB_10006337:
  10006337  AND dword ptr [EBP + -0x24],0x0
  1000633b  MOV dword ptr [EBP + -0x8],ECX
  1000633e  MOVSX EAX,word ptr [EAX]
  10006341  JMP 0x100065e9    ; LAB_100065e9
LAB_10006346:
  10006346  MOV EAX,[0x1000ea6c]    ; PTR_DAT_1000ea6c
  1000634b  MOV dword ptr [EBP + -0x8],EAX    ; DAT_1000d21c
  1000634e  PUSH EAX    ; DAT_1000d21c
  1000634f  JMP 0x100063e2    ; LAB_100063e2
LAB_10006354:
  10006354  JNZ 0x10006362    ; LAB_10006362
  10006356  CMP BL,0x67
  10006359  JNZ 0x10006362    ; LAB_10006362
  1000635b  MOV dword ptr [EBP + -0x10],0x1
LAB_10006362:
  10006362  MOV EAX,dword ptr [EBP + 0x10]
  10006365  PUSH dword ptr [EBP + -0x34]
  10006368  ADD EAX,0x8
  1000636b  MOV dword ptr [EBP + 0x10],EAX
  1000636e  PUSH dword ptr [EBP + -0x10]
  10006371  MOV ECX,dword ptr [EAX + -0x8]
  10006374  MOV dword ptr [EBP + -0x48],ECX
  10006377  MOV EAX,dword ptr [EAX + -0x4]
  1000637a  MOV dword ptr [EBP + -0x44],EAX
  1000637d  MOVSX EAX,BL
  10006380  PUSH EAX
  10006381  LEA EAX,[EBP + 0xfffffdb8]
  10006387  PUSH EAX
  10006388  LEA EAX,[EBP + -0x48]
  1000638b  PUSH EAX
  1000638c  CALL dword ptr [0x1000ea54]    ; PTR___fptrap_1000ea54 __fptrap
  10006392  MOV ESI,dword ptr [EBP + -0x4]
  10006395  ADD ESP,0x14
  10006398  AND ESI,0x80
  1000639e  JZ 0x100063b4    ; LAB_100063b4
  100063a0  CMP dword ptr [EBP + -0x10],0x0
  100063a4  JNZ 0x100063b4    ; LAB_100063b4
  100063a6  LEA EAX,[EBP + 0xfffffdb8]
  100063ac  PUSH EAX
  100063ad  CALL dword ptr [0x1000ea60]    ; PTR___fptrap_1000ea60 __fptrap
  100063b3  POP ECX
LAB_100063b4:
  100063b4  CMP BL,0x67
  100063b7  JNZ 0x100063cb    ; LAB_100063cb
  100063b9  TEST ESI,ESI
  100063bb  JNZ 0x100063cb    ; LAB_100063cb
  100063bd  LEA EAX,[EBP + 0xfffffdb8]
  100063c3  PUSH EAX
  100063c4  CALL dword ptr [0x1000ea58]    ; PTR___fptrap_1000ea58 __fptrap
  100063ca  POP ECX
LAB_100063cb:
  100063cb  CMP byte ptr [EBP + 0xfffffdb8],0x2d
  100063d2  JNZ 0x100063e1    ; LAB_100063e1
  100063d4  OR byte ptr [EBP + -0x3],0x1
  100063d8  LEA EDI,[EBP + 0xfffffdb9]
  100063de  MOV dword ptr [EBP + -0x8],EDI
LAB_100063e1:
  100063e1  PUSH EDI
LAB_100063e2:
  100063e2  CALL 0x100088c0    ; _strlen
  100063e7  POP ECX
  100063e8  JMP 0x100065e9    ; LAB_100065e9
LAB_100063ed:
  100063ed  SUB EAX,0x69
  100063f0  JZ 0x100064c7    ; LAB_100064c7
  100063f6  SUB EAX,0x5
  100063f9  JZ 0x1000649d    ; LAB_1000649d
  100063ff  DEC EAX
  10006400  JZ 0x1000648a    ; LAB_1000648a
  10006406  DEC EAX
  10006407  JZ 0x1000645a    ; LAB_1000645a
  10006409  SUB EAX,0x3
  1000640c  JZ 0x1000620f    ; LAB_1000620f
  10006412  DEC EAX
  10006413  DEC EAX
  10006414  JZ 0x100064cb    ; LAB_100064cb
  1000641a  SUB EAX,0x3
  1000641d  JNZ 0x100065ec    ; LAB_100065ec
  10006423  MOV dword ptr [EBP + -0x2c],0x27
  1000642a  JMP 0x10006468    ; LAB_10006468
LAB_1000642c:
  1000642c  SUB EAX,ECX
  1000642e  SAR EAX,0x1
  10006430  JMP 0x100065e9    ; LAB_100065e9
LAB_10006435:
  10006435  TEST ECX,ECX
  10006437  JNZ 0x10006442    ; LAB_10006442
  10006439  MOV ECX,dword ptr [0x1000ea6c]    ; PTR_DAT_1000ea6c
  1000643f  MOV dword ptr [EBP + -0x8],ECX    ; DAT_1000d21c
LAB_10006442:
  10006442  MOV EAX,ECX
LAB_10006444:
  10006444  MOV EDX,ESI
  10006446  DEC ESI
  10006447  TEST EDX,EDX
  10006449  JZ 0x10006453    ; LAB_10006453
  1000644b  CMP byte ptr [EAX],0x0    ; DAT_1000d21c s_null)_1000d21d
  1000644e  JZ 0x10006453    ; LAB_10006453
  10006450  INC EAX
  10006451  JMP 0x10006444    ; LAB_10006444
LAB_10006453:
  10006453  SUB EAX,ECX
  10006455  JMP 0x100065e9    ; LAB_100065e9
LAB_1000645a:
  1000645a  MOV dword ptr [EBP + -0x10],0x8
LAB_10006461:
  10006461  MOV dword ptr [EBP + -0x2c],0x7
LAB_10006468:
  10006468  TEST byte ptr [EBP + -0x4],0x80
  1000646c  MOV dword ptr [EBP + -0xc],0x10
  10006473  JZ 0x100064d2    ; LAB_100064d2
  10006475  MOV AL,byte ptr [EBP + -0x2c]
  10006478  MOV byte ptr [EBP + -0x16],0x30
  1000647c  ADD AL,0x51
  1000647e  MOV dword ptr [EBP + -0x1c],0x2
  10006485  MOV byte ptr [EBP + -0x15],AL
  10006488  JMP 0x100064d2    ; LAB_100064d2
LAB_1000648a:
  1000648a  TEST byte ptr [EBP + -0x4],0x80
  1000648e  MOV dword ptr [EBP + -0xc],0x8
  10006495  JZ 0x100064d2    ; LAB_100064d2
  10006497  OR byte ptr [EBP + -0x3],0x2
  1000649b  JMP 0x100064d2    ; LAB_100064d2
LAB_1000649d:
  1000649d  LEA EAX,[EBP + 0x10]
  100064a0  PUSH EAX
  100064a1  CALL 0x100067c1    ; FUN_100067c1
  100064a6  TEST byte ptr [EBP + -0x4],0x20
  100064aa  POP ECX
  100064ab  JZ 0x100064b6    ; LAB_100064b6
  100064ad  MOV CX,word ptr [EBP + -0x14]
  100064b1  MOV word ptr [EAX],CX
  100064b4  JMP 0x100064bb    ; LAB_100064bb
LAB_100064b6:
  100064b6  MOV ECX,dword ptr [EBP + -0x14]
  100064b9  MOV dword ptr [EAX],ECX
LAB_100064bb:
  100064bb  MOV dword ptr [EBP + -0x28],0x1
  100064c2  JMP 0x100066ea    ; switchD_10006050::default
LAB_100064c7:
  100064c7  OR dword ptr [EBP + -0x4],0x40
LAB_100064cb:
  100064cb  MOV dword ptr [EBP + -0xc],0xa
LAB_100064d2:
  100064d2  TEST byte ptr [EBP + -0x3],0x80
  100064d6  JZ 0x100064e4    ; LAB_100064e4
  100064d8  LEA EAX,[EBP + 0x10]
  100064db  PUSH EAX
  100064dc  CALL 0x100067ce    ; FUN_100067ce
  100064e1  POP ECX
  100064e2  JMP 0x10006525    ; LAB_10006525
LAB_100064e4:
  100064e4  TEST byte ptr [EBP + -0x4],0x20
  100064e8  JZ 0x1000650b    ; LAB_1000650b
  100064ea  TEST byte ptr [EBP + -0x4],0x40
  100064ee  LEA EAX,[EBP + 0x10]
  100064f1  PUSH EAX
  100064f2  JZ 0x10006500    ; LAB_10006500
  100064f4  CALL 0x100067c1    ; FUN_100067c1
  100064f9  POP ECX
  100064fa  MOVSX EAX,AX
LAB_100064fd:
  100064fd  CDQ
  100064fe  JMP 0x10006525    ; LAB_10006525
LAB_10006500:
  10006500  CALL 0x100067c1    ; FUN_100067c1
  10006505  POP ECX
  10006506  MOVZX EAX,AX
  10006509  JMP 0x100064fd    ; LAB_100064fd
LAB_1000650b:
  1000650b  TEST byte ptr [EBP + -0x4],0x40
  1000650f  LEA EAX,[EBP + 0x10]
  10006512  PUSH EAX
  10006513  JZ 0x1000651d    ; LAB_1000651d
  10006515  CALL 0x100067c1    ; FUN_100067c1
  1000651a  POP ECX
  1000651b  JMP 0x100064fd    ; LAB_100064fd
LAB_1000651d:
  1000651d  CALL 0x100067c1    ; FUN_100067c1
  10006522  POP ECX
  10006523  XOR EDX,EDX
LAB_10006525:
  10006525  TEST byte ptr [EBP + -0x4],0x40
  10006529  JZ 0x10006546    ; LAB_10006546
  1000652b  TEST EDX,EDX
  1000652d  JG 0x10006546    ; LAB_10006546
  1000652f  JL 0x10006535    ; LAB_10006535
  10006531  TEST EAX,EAX
  10006533  JNC 0x10006546    ; LAB_10006546
LAB_10006535:
  10006535  NEG EAX
  10006537  ADC EDX,0x0
  1000653a  MOV ESI,EAX
  1000653c  NEG EDX
  1000653e  OR byte ptr [EBP + -0x3],0x1
  10006542  MOV EDI,EDX
  10006544  JMP 0x1000654a    ; LAB_1000654a
LAB_10006546:
  10006546  MOV ESI,EAX
  10006548  MOV EDI,EDX
LAB_1000654a:
  1000654a  TEST byte ptr [EBP + -0x3],0x80
  1000654e  JNZ 0x10006553    ; LAB_10006553
  10006550  AND EDI,0x0
LAB_10006553:
  10006553  CMP dword ptr [EBP + -0x10],0x0
  10006557  JGE 0x10006562    ; LAB_10006562
  10006559  MOV dword ptr [EBP + -0x10],0x1
  10006560  JMP 0x10006566    ; LAB_10006566
LAB_10006562:
  10006562  AND dword ptr [EBP + -0x4],0xfffffff7
LAB_10006566:
  10006566  MOV EAX,ESI
  10006568  OR EAX,EDI
  1000656a  JNZ 0x10006570    ; LAB_10006570
  1000656c  AND dword ptr [EBP + -0x1c],0x0
LAB_10006570:
  10006570  LEA EAX,[EBP + -0x49]
  10006573  MOV dword ptr [EBP + -0x8],EAX
LAB_10006576:
  10006576  MOV EAX,dword ptr [EBP + -0x10]
  10006579  DEC dword ptr [EBP + -0x10]
  1000657c  TEST EAX,EAX
  1000657e  JG 0x10006586    ; LAB_10006586
  10006580  MOV EAX,ESI
  10006582  OR EAX,EDI
  10006584  JZ 0x100065c1    ; LAB_100065c1
LAB_10006586:
  10006586  MOV EAX,dword ptr [EBP + -0xc]
  10006589  CDQ
  1000658a  PUSH EDX
  1000658b  PUSH EAX
  1000658c  PUSH EDI
  1000658d  PUSH ESI
  1000658e  MOV dword ptr [EBP + -0x40],EAX
  10006591  MOV dword ptr [EBP + -0x3c],EDX
  10006594  CALL 0x10009d20    ; __aullrem
  10006599  PUSH dword ptr [EBP + -0x3c]
  1000659c  MOV EBX,EAX
  1000659e  ADD EBX,0x30
  100065a1  PUSH dword ptr [EBP + -0x40]
  100065a4  PUSH EDI
  100065a5  PUSH ESI
  100065a6  CALL 0x10009cb0    ; __aulldiv
  100065ab  CMP EBX,0x39
  100065ae  MOV ESI,EAX
  100065b0  MOV EDI,EDX
  100065b2  JLE 0x100065b7    ; LAB_100065b7
  100065b4  ADD EBX,dword ptr [EBP + -0x2c]
LAB_100065b7:
  100065b7  MOV EAX,dword ptr [EBP + -0x8]
  100065ba  DEC dword ptr [EBP + -0x8]
  100065bd  MOV byte ptr [EAX],BL
  100065bf  JMP 0x10006576    ; LAB_10006576
LAB_100065c1:
  100065c1  LEA EAX,[EBP + -0x49]
  100065c4  SUB EAX,dword ptr [EBP + -0x8]
  100065c7  INC dword ptr [EBP + -0x8]
  100065ca  TEST byte ptr [EBP + -0x3],0x2
  100065ce  MOV dword ptr [EBP + -0xc],EAX
  100065d1  JZ 0x100065ec    ; LAB_100065ec
  100065d3  MOV ECX,dword ptr [EBP + -0x8]
  100065d6  CMP byte ptr [ECX],0x30
  100065d9  JNZ 0x100065df    ; LAB_100065df
  100065db  TEST EAX,EAX
  100065dd  JNZ 0x100065ec    ; LAB_100065ec
LAB_100065df:
  100065df  DEC dword ptr [EBP + -0x8]
  100065e2  INC EAX
  100065e3  MOV ECX,dword ptr [EBP + -0x8]
  100065e6  MOV byte ptr [ECX],0x30
LAB_100065e9:
  100065e9  MOV dword ptr [EBP + -0xc],EAX
LAB_100065ec:
  100065ec  CMP dword ptr [EBP + -0x28],0x0
  100065f0  JNZ 0x100066ea    ; switchD_10006050::default
  100065f6  MOV EBX,dword ptr [EBP + -0x4]
  100065f9  TEST BL,0x40
  100065fc  JZ 0x10006624    ; LAB_10006624
  100065fe  TEST BH,0x1
  10006601  JZ 0x10006609    ; LAB_10006609
  10006603  MOV byte ptr [EBP + -0x16],0x2d
  10006607  JMP 0x1000661d    ; LAB_1000661d
LAB_10006609:
  10006609  TEST BL,0x1
  1000660c  JZ 0x10006614    ; LAB_10006614
  1000660e  MOV byte ptr [EBP + -0x16],0x2b
  10006612  JMP 0x1000661d    ; LAB_1000661d
LAB_10006614:
  10006614  TEST BL,0x2
  10006617  JZ 0x10006624    ; LAB_10006624
  10006619  MOV byte ptr [EBP + -0x16],0x20
LAB_1000661d:
  1000661d  MOV dword ptr [EBP + -0x1c],0x1
LAB_10006624:
  10006624  MOV ESI,dword ptr [EBP + -0x20]
  10006627  SUB ESI,dword ptr [EBP + -0x1c]
  1000662a  SUB ESI,dword ptr [EBP + -0xc]
  1000662d  TEST BL,0xc
  10006630  JNZ 0x10006644    ; LAB_10006644
  10006632  LEA EAX,[EBP + -0x14]
  10006635  PUSH EAX
  10006636  PUSH dword ptr [EBP + 0x8]
  10006639  PUSH ESI
  1000663a  PUSH 0x20
  1000663c  CALL 0x10006758    ; FUN_10006758
  10006641  ADD ESP,0x10
LAB_10006644:
  10006644  LEA EAX,[EBP + -0x14]
  10006647  PUSH EAX
  10006648  LEA EAX,[EBP + -0x16]
  1000664b  PUSH dword ptr [EBP + 0x8]
  1000664e  PUSH dword ptr [EBP + -0x1c]
  10006651  PUSH EAX
  10006652  CALL 0x10006789    ; FUN_10006789
  10006657  ADD ESP,0x10
  1000665a  TEST BL,0x8
  1000665d  JZ 0x10006676    ; LAB_10006676
  1000665f  TEST BL,0x4
  10006662  JNZ 0x10006676    ; LAB_10006676
  10006664  LEA EAX,[EBP + -0x14]
  10006667  PUSH EAX
  10006668  PUSH dword ptr [EBP + 0x8]
  1000666b  PUSH ESI
  1000666c  PUSH 0x30
  1000666e  CALL 0x10006758    ; FUN_10006758
  10006673  ADD ESP,0x10
LAB_10006676:
  10006676  CMP dword ptr [EBP + -0x24],0x0
  1000667a  JZ 0x100066bd    ; LAB_100066bd
  1000667c  CMP dword ptr [EBP + -0xc],0x0
  10006680  JLE 0x100066bd    ; LAB_100066bd
  10006682  MOV EAX,dword ptr [EBP + -0xc]
  10006685  MOV EBX,dword ptr [EBP + -0x8]
  10006688  LEA EDI,[EAX + -0x1]
LAB_1000668b:
  1000668b  MOV AX,word ptr [EBX]    ; DAT_1000d20c u_null)_1000d20e
  1000668e  INC EBX
  1000668f  PUSH EAX
  10006690  LEA EAX,[EBP + -0x38]
  10006693  PUSH EAX
  10006694  INC EBX
  10006695  CALL 0x10009c3b    ; FUN_10009c3b
  1000669a  POP ECX
  1000669b  TEST EAX,EAX
  1000669d  POP ECX
  1000669e  JLE 0x100066d2    ; LAB_100066d2
  100066a0  LEA ECX,[EBP + -0x14]
  100066a3  PUSH ECX
  100066a4  PUSH dword ptr [EBP + 0x8]
  100066a7  PUSH EAX
  100066a8  LEA EAX,[EBP + -0x38]
  100066ab  PUSH EAX
  100066ac  CALL 0x10006789    ; FUN_10006789
  100066b1  ADD ESP,0x10
  100066b4  MOV EAX,EDI
  100066b6  DEC EDI
  100066b7  TEST EAX,EAX
  100066b9  JNZ 0x1000668b    ; LAB_1000668b
  100066bb  JMP 0x100066d2    ; LAB_100066d2
LAB_100066bd:
  100066bd  LEA EAX,[EBP + -0x14]
  100066c0  PUSH EAX
  100066c1  PUSH dword ptr [EBP + 0x8]
  100066c4  PUSH dword ptr [EBP + -0xc]
  100066c7  PUSH dword ptr [EBP + -0x8]    ; DAT_1000d20c
  100066ca  CALL 0x10006789    ; FUN_10006789
  100066cf  ADD ESP,0x10
LAB_100066d2:
  100066d2  TEST byte ptr [EBP + -0x4],0x4
  100066d6  JZ 0x100066ea    ; switchD_10006050::default
  100066d8  LEA EAX,[EBP + -0x14]
  100066db  PUSH EAX
  100066dc  PUSH dword ptr [EBP + 0x8]
  100066df  PUSH ESI
  100066e0  PUSH 0x20
  100066e2  CALL 0x10006758    ; FUN_10006758
  100066e7  ADD ESP,0x10
default:
  100066ea  MOV EDI,dword ptr [EBP + 0xc]
  100066ed  MOV BL,byte ptr [EDI]
  100066ef  INC EDI
  100066f0  TEST BL,BL
  100066f2  MOV dword ptr [EBP + 0xc],EDI
  100066f5  JNZ 0x1000600e    ; LAB_1000600e
LAB_100066fb:
  100066fb  MOV EAX,dword ptr [EBP + -0x14]
  100066fe  POP EDI
  100066ff  POP ESI
  10006700  POP EBX
  10006701  LEAVE
  10006702  RET

;==== FUNCTION FUN_10006723 @ 10006723 : undefined FUN_10006723(uint param_1, int * param_2, int * param_3)
  10006723  PUSH EBP
  10006724  MOV EBP,ESP
  10006726  MOV ECX,dword ptr [EBP + 0xc]
  10006729  DEC dword ptr [ECX + 0x4]
  1000672c  JS 0x1000673c    ; LAB_1000673c
  1000672e  MOV EDX,dword ptr [ECX]
  10006730  MOV AL,byte ptr [EBP + 0x8]
  10006733  MOV byte ptr [EDX],AL
  10006735  INC dword ptr [ECX]
  10006737  MOVZX EAX,AL
  1000673a  JMP 0x10006747    ; LAB_10006747
LAB_1000673c:
  1000673c  PUSH ECX
  1000673d  PUSH dword ptr [EBP + 0x8]
  10006740  CALL 0x10005ecd    ; FUN_10005ecd
  10006745  POP ECX
  10006746  POP ECX
LAB_10006747:
  10006747  CMP EAX,-0x1
  1000674a  MOV EAX,dword ptr [EBP + 0x10]
  1000674d  JNZ 0x10006754    ; LAB_10006754
  1000674f  OR dword ptr [EAX],0xffffffff
  10006752  POP EBP
  10006753  RET
LAB_10006754:
  10006754  INC dword ptr [EAX]
  10006756  POP EBP
  10006757  RET

;==== FUNCTION FUN_10006758 @ 10006758 : undefined FUN_10006758(uint param_1, int param_2, int * param_3, int * param_4)
  10006758  PUSH ESI
  10006759  PUSH EDI
  1000675a  MOV EDI,dword ptr [ESP + 0x10]
  1000675e  MOV EAX,EDI
  10006760  DEC EDI
  10006761  TEST EAX,EAX
  10006763  JLE 0x10006786    ; LAB_10006786
  10006765  MOV ESI,dword ptr [ESP + 0x18]
LAB_10006769:
  10006769  PUSH ESI
  1000676a  PUSH dword ptr [ESP + 0x18]
  1000676e  PUSH dword ptr [ESP + 0x14]
  10006772  CALL 0x10006723    ; FUN_10006723
  10006777  ADD ESP,0xc
  1000677a  CMP dword ptr [ESI],-0x1
  1000677d  JZ 0x10006786    ; LAB_10006786
  1000677f  MOV EAX,EDI
  10006781  DEC EDI
  10006782  TEST EAX,EAX
  10006784  JG 0x10006769    ; LAB_10006769
LAB_10006786:
  10006786  POP EDI
  10006787  POP ESI
  10006788  RET

;==== FUNCTION FUN_10006789 @ 10006789 : undefined FUN_10006789(char * param_1, int param_2, int * param_3, int * param_4)
  10006789  PUSH EBX
  1000678a  MOV EBX,dword ptr [ESP + 0xc]
  1000678e  MOV EAX,EBX
  10006790  DEC EBX
  10006791  PUSH ESI
  10006792  PUSH EDI
  10006793  TEST EAX,EAX
  10006795  JLE 0x100067bd    ; LAB_100067bd
  10006797  MOV EDI,dword ptr [ESP + 0x1c]
  1000679b  MOV ESI,dword ptr [ESP + 0x10]
LAB_1000679f:
  1000679f  MOVSX EAX,byte ptr [ESI]
  100067a2  PUSH EDI
  100067a3  INC ESI
  100067a4  PUSH dword ptr [ESP + 0x1c]
  100067a8  PUSH EAX
  100067a9  CALL 0x10006723    ; FUN_10006723
  100067ae  ADD ESP,0xc
  100067b1  CMP dword ptr [EDI],-0x1
  100067b4  JZ 0x100067bd    ; LAB_100067bd
  100067b6  MOV EAX,EBX
  100067b8  DEC EBX
  100067b9  TEST EAX,EAX
  100067bb  JG 0x1000679f    ; LAB_1000679f
LAB_100067bd:
  100067bd  POP EDI
  100067be  POP ESI
  100067bf  POP EBX
  100067c0  RET

;==== FUNCTION FUN_100067c1 @ 100067c1 : undefined4 FUN_100067c1(int * param_1)
  100067c1  MOV EAX,dword ptr [ESP + 0x4]
  100067c5  ADD dword ptr [EAX],0x4
  100067c8  MOV EAX,dword ptr [EAX]
  100067ca  MOV EAX,dword ptr [EAX + -0x4]
  100067cd  RET

;==== FUNCTION FUN_100067ce @ 100067ce : undefined8 FUN_100067ce(int * param_1)
  100067ce  MOV EAX,dword ptr [ESP + 0x4]
  100067d2  ADD dword ptr [EAX],0x8
  100067d5  MOV ECX,dword ptr [EAX]
  100067d7  MOV EAX,dword ptr [ECX + -0x8]
  100067da  MOV EDX,dword ptr [ECX + -0x4]
  100067dd  RET

;==== FUNCTION FUN_100067de @ 100067de : undefined4 FUN_100067de(int * param_1)
  100067de  MOV EAX,dword ptr [ESP + 0x4]
  100067e2  ADD dword ptr [EAX],0x4
  100067e5  MOV EAX,dword ptr [EAX]
  100067e7  MOV AX,word ptr [EAX + -0x4]
  100067eb  RET

;==== FUNCTION FUN_100067ec @ 100067ec : undefined4 FUN_100067ec(PEXCEPTION_RECORD param_1, PVOID param_2, undefined4 param_3, undefined4 param_4, int * param_5, int param_6, PVOID param_7, char param_8)
  100067ec  PUSH EBP
  100067ed  MOV EBP,ESP
  100067ef  PUSH ESI
  100067f0  MOV ESI,dword ptr [EBP + 0x18]
  100067f3  PUSH EDI
  100067f4  MOV EDI,0x19930520
  100067f9  CMP dword ptr [ESI],EDI
  100067fb  JZ 0x10006802    ; LAB_10006802
  100067fd  CALL 0x100070a2    ; FUN_100070a2
LAB_10006802:
  10006802  MOV EAX,dword ptr [EBP + 0x8]
  10006805  TEST byte ptr [EAX + 0x4],0x66
  10006809  JZ 0x1000682a    ; LAB_1000682a
  1000680b  CMP dword ptr [ESI + 0x4],0x0
  1000680f  JZ 0x10006880    ; LAB_10006880
  10006811  CMP dword ptr [EBP + 0x1c],0x0
  10006815  JNZ 0x10006880    ; LAB_10006880
  10006817  PUSH -0x1
  10006819  PUSH ESI
  1000681a  PUSH dword ptr [EBP + 0x14]
  1000681d  PUSH dword ptr [EBP + 0xc]
  10006820  CALL 0x10006b33    ; FUN_10006b33
  10006825  ADD ESP,0x10
  10006828  JMP 0x10006880    ; LAB_10006880
LAB_1000682a:
  1000682a  CMP dword ptr [ESI + 0xc],0x0
  1000682e  JZ 0x10006880    ; LAB_10006880
  10006830  CMP dword ptr [EAX],0xe06d7363
  10006836  JNZ 0x10006864    ; LAB_10006864
  10006838  CMP dword ptr [EAX + 0x14],EDI
  1000683b  JBE 0x10006864    ; LAB_10006864
  1000683d  MOV ECX,dword ptr [EAX + 0x1c]
  10006840  MOV ECX,dword ptr [ECX + 0x8]
  10006843  TEST ECX,ECX
  10006845  JZ 0x10006864    ; LAB_10006864
  10006847  MOVZX EDX,byte ptr [EBP + 0x24]
  1000684b  PUSH EDX
  1000684c  PUSH dword ptr [EBP + 0x20]
  1000684f  PUSH dword ptr [EBP + 0x1c]
  10006852  PUSH ESI
  10006853  PUSH dword ptr [EBP + 0x14]
  10006856  PUSH dword ptr [EBP + 0x10]
  10006859  PUSH dword ptr [EBP + 0xc]
  1000685c  PUSH EAX
  1000685d  CALL ECX
  1000685f  ADD ESP,0x20
  10006862  JMP 0x10006883    ; LAB_10006883
LAB_10006864:
  10006864  PUSH dword ptr [EBP + 0x20]
  10006867  PUSH dword ptr [EBP + 0x1c]
  1000686a  PUSH dword ptr [EBP + 0x24]
  1000686d  PUSH ESI
  1000686e  PUSH dword ptr [EBP + 0x14]
  10006871  PUSH dword ptr [EBP + 0x10]
  10006874  PUSH dword ptr [EBP + 0xc]
  10006877  PUSH EAX
  10006878  CALL 0x10006887    ; FUN_10006887
  1000687d  ADD ESP,0x20
LAB_10006880:
  10006880  PUSH 0x1
  10006882  POP EAX
LAB_10006883:
  10006883  POP EDI
  10006884  POP ESI
  10006885  POP EBP
  10006886  RET

;==== FUNCTION FUN_10006887 @ 10006887 : undefined FUN_10006887(PEXCEPTION_RECORD param_1, PVOID param_2, undefined4 param_3, undefined4 param_4, int param_5, char param_6, int param_7, PVOID param_8)
  10006887  PUSH EBP
  10006888  MOV EBP,ESP
  1000688a  SUB ESP,0x18
  1000688d  MOV EAX,dword ptr [EBP + 0xc]
  10006890  AND byte ptr [EBP + -0x14],0x0
  10006894  MOV EAX,dword ptr [EAX + 0x8]
  10006897  CMP EAX,-0x1
  1000689a  MOV dword ptr [EBP + -0x10],EAX
  1000689d  JL 0x100068a7    ; LAB_100068a7
  1000689f  MOV ECX,dword ptr [EBP + 0x18]
  100068a2  CMP EAX,dword ptr [ECX + 0x4]
  100068a5  JL 0x100068ac    ; LAB_100068ac
LAB_100068a7:
  100068a7  CALL 0x100070a2    ; FUN_100070a2
LAB_100068ac:
  100068ac  PUSH EBX
  100068ad  PUSH ESI
  100068ae  MOV ESI,dword ptr [EBP + 0x8]
  100068b1  MOV EBX,0xe06d7363
  100068b6  PUSH EDI
  100068b7  MOV EDI,0x19930520
  100068bc  CMP dword ptr [ESI],EBX
  100068be  JNZ 0x10006a03    ; LAB_10006a03
  100068c4  CMP dword ptr [ESI + 0x10],0x3
  100068c8  JNZ 0x10006920    ; LAB_10006920
  100068ca  CMP dword ptr [ESI + 0x14],EDI
  100068cd  JNZ 0x10006920    ; LAB_10006920
  100068cf  CMP dword ptr [ESI + 0x1c],0x0
  100068d3  JNZ 0x10006920    ; LAB_10006920
  100068d5  MOV ESI,dword ptr [0x1000f63c]    ; DAT_1000f63c
  100068db  TEST ESI,ESI
  100068dd  JZ 0x100069fe    ; LAB_100069fe
  100068e3  MOV EAX,[0x1000f640]    ; DAT_1000f640
  100068e8  PUSH 0x1
  100068ea  PUSH ESI
  100068eb  MOV dword ptr [EBP + 0x10],EAX
  100068ee  MOV byte ptr [EBP + -0x14],0x1
  100068f2  CALL 0x10009df9    ; FUN_10009df9
  100068f7  POP ECX
  100068f8  TEST EAX,EAX
  100068fa  POP ECX
  100068fb  JNZ 0x10006902    ; LAB_10006902
  100068fd  CALL 0x100070a2    ; FUN_100070a2
LAB_10006902:
  10006902  CMP dword ptr [ESI],EBX
  10006904  JNZ 0x10006a03    ; LAB_10006a03
  1000690a  CMP dword ptr [ESI + 0x10],0x3
  1000690e  JNZ 0x10006920    ; LAB_10006920
  10006910  CMP dword ptr [ESI + 0x14],EDI
  10006913  JNZ 0x10006920    ; LAB_10006920
  10006915  CMP dword ptr [ESI + 0x1c],0x0
  10006919  JNZ 0x10006920    ; LAB_10006920
  1000691b  CALL 0x100070a2    ; FUN_100070a2
LAB_10006920:
  10006920  CMP dword ptr [ESI],EBX
  10006922  JNZ 0x10006a03    ; LAB_10006a03
  10006928  CMP dword ptr [ESI + 0x10],0x3
  1000692c  JNZ 0x10006a03    ; LAB_10006a03
  10006932  CMP dword ptr [ESI + 0x14],EDI
  10006935  JNZ 0x10006a03    ; LAB_10006a03
  1000693b  MOV EDI,dword ptr [EBP + -0x10]
  1000693e  LEA EAX,[EBP + -0x18]
  10006941  PUSH EAX
  10006942  LEA EAX,[EBP + -0x4]
  10006945  PUSH EAX
  10006946  PUSH EDI
  10006947  PUSH dword ptr [EBP + 0x20]
  1000694a  PUSH dword ptr [EBP + 0x18]
  1000694d  CALL 0x1000548c    ; FUN_1000548c
  10006952  ADD ESP,0x14
  10006955  MOV EBX,EAX
LAB_10006957:
  10006957  MOV EAX,dword ptr [EBP + -0x4]
  1000695a  CMP EAX,dword ptr [EBP + -0x18]
  1000695d  JNC 0x100069ee    ; LAB_100069ee
  10006963  CMP dword ptr [EBX],EDI
  10006965  JG 0x100069e3    ; LAB_100069e3
  10006967  CMP EDI,dword ptr [EBX + 0x4]
  1000696a  JG 0x100069e3    ; LAB_100069e3
  1000696c  MOV EAX,dword ptr [EBX + 0x10]
  1000696f  MOV dword ptr [EBP + 0x8],EAX
  10006972  MOV EAX,dword ptr [EBX + 0xc]
  10006975  TEST EAX,EAX
  10006977  MOV dword ptr [EBP + -0xc],EAX
  1000697a  JLE 0x100069e0    ; LAB_100069e0
LAB_1000697c:
  1000697c  MOV EAX,dword ptr [ESI + 0x1c]
  1000697f  MOV EAX,dword ptr [EAX + 0xc]
  10006982  LEA EDI,[EAX + 0x4]
  10006985  MOV EAX,dword ptr [EAX]
  10006987  TEST EAX,EAX
  10006989  MOV dword ptr [EBP + -0x8],EAX
  1000698c  JLE 0x100069ad    ; LAB_100069ad
LAB_1000698e:
  1000698e  PUSH dword ptr [ESI + 0x1c]
  10006991  PUSH dword ptr [EDI]
  10006993  PUSH dword ptr [EBP + 0x8]
  10006996  CALL 0x10006ad6    ; FUN_10006ad6
  1000699b  ADD ESP,0xc
  1000699e  TEST EAX,EAX
  100069a0  JNZ 0x100069bc    ; LAB_100069bc
  100069a2  DEC dword ptr [EBP + -0x8]
  100069a5  ADD EDI,0x4
  100069a8  CMP dword ptr [EBP + -0x8],EAX
  100069ab  JG 0x1000698e    ; LAB_1000698e
LAB_100069ad:
  100069ad  DEC dword ptr [EBP + -0xc]
  100069b0  ADD dword ptr [EBP + 0x8],0x10
  100069b4  CMP dword ptr [EBP + -0xc],0x0
  100069b8  JG 0x1000697c    ; LAB_1000697c
  100069ba  JMP 0x100069e0    ; LAB_100069e0
LAB_100069bc:
  100069bc  PUSH dword ptr [EBP + -0x14]
  100069bf  PUSH dword ptr [EBP + 0x24]
  100069c2  PUSH dword ptr [EBP + 0x20]
  100069c5  PUSH EBX
  100069c6  PUSH dword ptr [EDI]
  100069c8  PUSH dword ptr [EBP + 0x8]
  100069cb  PUSH dword ptr [EBP + 0x18]
  100069ce  PUSH dword ptr [EBP + 0x14]
  100069d1  PUSH dword ptr [EBP + 0x10]
  100069d4  PUSH dword ptr [EBP + 0xc]
  100069d7  PUSH ESI
  100069d8  CALL 0x10006be7    ; FUN_10006be7
  100069dd  ADD ESP,0x2c
LAB_100069e0:
  100069e0  MOV EDI,dword ptr [EBP + -0x10]
LAB_100069e3:
  100069e3  INC dword ptr [EBP + -0x4]
  100069e6  ADD EBX,0x14
  100069e9  JMP 0x10006957    ; LAB_10006957
LAB_100069ee:
  100069ee  CMP byte ptr [EBP + 0x1c],0x0
  100069f2  JZ 0x100069fe    ; LAB_100069fe
  100069f4  PUSH 0x1
  100069f6  PUSH ESI
  100069f7  CALL 0x10006f5c    ; FUN_10006f5c
  100069fc  POP ECX
  100069fd  POP ECX
LAB_100069fe:
  100069fe  POP EDI
  100069ff  POP ESI
  10006a00  POP EBX
  10006a01  LEAVE
  10006a02  RET
LAB_10006a03:
  10006a03  CMP byte ptr [EBP + 0x1c],0x0
  10006a07  JNZ 0x10006a29    ; LAB_10006a29
  10006a09  PUSH dword ptr [EBP + 0x24]
  10006a0c  PUSH dword ptr [EBP + 0x20]
  10006a0f  PUSH dword ptr [EBP + -0x10]
  10006a12  PUSH dword ptr [EBP + 0x18]
  10006a15  PUSH dword ptr [EBP + 0x14]
  10006a18  PUSH dword ptr [EBP + 0x10]
  10006a1b  PUSH dword ptr [EBP + 0xc]
  10006a1e  PUSH ESI
  10006a1f  CALL 0x10006a2e    ; FUN_10006a2e
  10006a24  ADD ESP,0x20
  10006a27  JMP 0x100069fe    ; LAB_100069fe
LAB_10006a29:
  10006a29  JMP 0x1000703c    ; FUN_1000703c

;==== FUNCTION FUN_10006a2e @ 10006a2e : undefined FUN_10006a2e(PEXCEPTION_RECORD param_1, PVOID param_2, undefined4 param_3, undefined4 param_4, int param_5, int param_6, int param_7, PVOID param_8)
  10006a2e  PUSH EBP
  10006a2f  MOV EBP,ESP
  10006a31  PUSH ECX
  10006a32  PUSH ECX
  10006a33  CMP dword ptr [0x1000f644],0x0    ; DAT_1000f644
  10006a3a  PUSH ESI
  10006a3b  PUSH EDI
  10006a3c  JZ 0x10006a5f    ; LAB_10006a5f
  10006a3e  PUSH dword ptr [EBP + 0x24]
  10006a41  PUSH dword ptr [EBP + 0x20]
  10006a44  PUSH dword ptr [EBP + 0x18]
  10006a47  PUSH dword ptr [EBP + 0x14]
  10006a4a  PUSH dword ptr [EBP + 0x10]
  10006a4d  PUSH dword ptr [EBP + 0xc]
  10006a50  PUSH dword ptr [EBP + 0x8]
  10006a53  CALL 0x10005363    ; FUN_10005363
  10006a58  ADD ESP,0x1c
  10006a5b  TEST EAX,EAX
  10006a5d  JNZ 0x10006ad2    ; LAB_10006ad2
LAB_10006a5f:
  10006a5f  MOV EDI,dword ptr [EBP + 0x1c]
  10006a62  LEA EAX,[EBP + -0x8]
  10006a65  PUSH EAX
  10006a66  LEA EAX,[EBP + -0x4]
  10006a69  PUSH EAX
  10006a6a  PUSH EDI
  10006a6b  PUSH dword ptr [EBP + 0x20]
  10006a6e  PUSH dword ptr [EBP + 0x18]
  10006a71  CALL 0x1000548c    ; FUN_1000548c
  10006a76  ADD ESP,0x14
  10006a79  MOV ESI,EAX
LAB_10006a7b:
  10006a7b  MOV EAX,dword ptr [EBP + -0x4]
  10006a7e  CMP EAX,dword ptr [EBP + -0x8]
  10006a81  JNC 0x10006ad2    ; LAB_10006ad2
  10006a83  CMP EDI,dword ptr [ESI]
  10006a85  JL 0x10006aca    ; LAB_10006aca
  10006a87  CMP EDI,dword ptr [ESI + 0x4]
  10006a8a  JG 0x10006aca    ; LAB_10006aca
  10006a8c  MOV EAX,dword ptr [ESI + 0xc]
  10006a8f  MOV ECX,dword ptr [ESI + 0x10]
  10006a92  SHL EAX,0x4
  10006a95  ADD EAX,ECX
  10006a97  MOV ECX,dword ptr [EAX + -0xc]
  10006a9a  TEST ECX,ECX
  10006a9c  JZ 0x10006aa4    ; LAB_10006aa4
  10006a9e  CMP byte ptr [ECX + 0x8],0x0
  10006aa2  JNZ 0x10006aca    ; LAB_10006aca
LAB_10006aa4:
  10006aa4  PUSH 0x1
  10006aa6  ADD EAX,-0x10
  10006aa9  PUSH dword ptr [EBP + 0x24]
  10006aac  PUSH dword ptr [EBP + 0x20]
  10006aaf  PUSH ESI
  10006ab0  PUSH 0x0
  10006ab2  PUSH EAX
  10006ab3  PUSH dword ptr [EBP + 0x18]
  10006ab6  PUSH dword ptr [EBP + 0x14]
  10006ab9  PUSH dword ptr [EBP + 0x10]
  10006abc  PUSH dword ptr [EBP + 0xc]
  10006abf  PUSH dword ptr [EBP + 0x8]
  10006ac2  CALL 0x10006be7    ; FUN_10006be7
  10006ac7  ADD ESP,0x2c
LAB_10006aca:
  10006aca  INC dword ptr [EBP + -0x4]
  10006acd  ADD ESI,0x14
  10006ad0  JMP 0x10006a7b    ; LAB_10006a7b
LAB_10006ad2:
  10006ad2  POP EDI
  10006ad3  POP ESI
  10006ad4  LEAVE
  10006ad5  RET

;==== FUNCTION FUN_10006ad6 @ 10006ad6 : undefined4 FUN_10006ad6(byte * param_1, byte * param_2, uint * param_3)
  10006ad6  PUSH ESI
  10006ad7  PUSH EDI
  10006ad8  MOV EDI,dword ptr [ESP + 0xc]
  10006adc  MOV EAX,dword ptr [EDI + 0x4]
  10006adf  TEST EAX,EAX
  10006ae1  JZ 0x10006b2d    ; LAB_10006b2d
  10006ae3  CMP byte ptr [EAX + 0x8],0x0
  10006ae7  LEA EDX,[EAX + 0x8]
  10006aea  JZ 0x10006b2d    ; LAB_10006b2d
  10006aec  MOV ESI,dword ptr [ESP + 0x10]
  10006af0  MOV ECX,dword ptr [ESI + 0x4]
  10006af3  CMP EAX,ECX
  10006af5  JZ 0x10006b07    ; LAB_10006b07
  10006af7  ADD ECX,0x8
  10006afa  PUSH ECX
  10006afb  PUSH EDX
  10006afc  CALL 0x10009e50    ; _strcmp
  10006b01  POP ECX
  10006b02  TEST EAX,EAX
  10006b04  POP ECX
  10006b05  JNZ 0x10006b29    ; LAB_10006b29
LAB_10006b07:
  10006b07  TEST byte ptr [ESI],0x2
  10006b0a  JZ 0x10006b11    ; LAB_10006b11
  10006b0c  TEST byte ptr [EDI],0x8
  10006b0f  JZ 0x10006b29    ; LAB_10006b29
LAB_10006b11:
  10006b11  MOV EAX,dword ptr [ESP + 0x14]
  10006b15  MOV EAX,dword ptr [EAX]
  10006b17  TEST AL,0x1
  10006b19  JZ 0x10006b20    ; LAB_10006b20
  10006b1b  TEST byte ptr [EDI],0x1
  10006b1e  JZ 0x10006b29    ; LAB_10006b29
LAB_10006b20:
  10006b20  TEST AL,0x2
  10006b22  JZ 0x10006b2d    ; LAB_10006b2d
  10006b24  TEST byte ptr [EDI],0x2
  10006b27  JNZ 0x10006b2d    ; LAB_10006b2d
LAB_10006b29:
  10006b29  XOR EAX,EAX
  10006b2b  JMP 0x10006b30    ; LAB_10006b30
LAB_10006b2d:
  10006b2d  PUSH 0x1
  10006b2f  POP EAX
LAB_10006b30:
  10006b30  POP EDI
  10006b31  POP ESI
  10006b32  RET

;==== FUNCTION FUN_10006b33 @ 10006b33 : undefined FUN_10006b33(int param_1, undefined4 param_2, int param_3, int param_4)
  10006b33  PUSH EBP
  10006b34  MOV EBP,ESP
  10006b36  PUSH -0x1
  10006b38  PUSH 0x1000d228    ; DAT_1000d228
  10006b3d  PUSH 0x10009edc    ; LAB_10009edc
  10006b42  MOV EAX,FS:[0x0]    ; ExceptionList
  10006b48  PUSH EAX
  10006b49  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  10006b50  SUB ESP,0xc
  10006b53  PUSH EBX
  10006b54  PUSH ESI
  10006b55  PUSH EDI
  10006b56  MOV dword ptr [EBP + -0x18],ESP
  10006b59  MOV EBX,dword ptr [EBP + 0x8]
  10006b5c  MOV ESI,dword ptr [EBX + 0x8]
  10006b5f  MOV dword ptr [EBP + -0x1c],ESI
  10006b62  MOV EDI,dword ptr [EBP + 0x10]
LAB_10006b65:
  10006b65  CMP ESI,dword ptr [EBP + 0x14]
  10006b68  JZ 0x10006bbf    ; LAB_10006bbf
  10006b6a  CMP ESI,-0x1
  10006b6d  JLE 0x10006b74    ; LAB_10006b74
  10006b6f  CMP ESI,dword ptr [EDI + 0x4]
  10006b72  JL 0x10006b79    ; LAB_10006b79
LAB_10006b74:
  10006b74  CALL 0x100070a2    ; FUN_100070a2
LAB_10006b79:
  10006b79  AND dword ptr [EBP + -0x4],0x0
  10006b7d  MOV EAX,dword ptr [EDI + 0x8]
  10006b80  MOV EAX,dword ptr [EAX + ESI*0x8 + 0x4]
  10006b84  TEST EAX,EAX
  10006b86  JZ 0x10006b94    ; LAB_10006b94
  10006b88  PUSH 0x103
  10006b8d  PUSH EBX
  10006b8e  PUSH EAX
  10006b8f  CALL 0x10006ff0    ; __CallSettingFrame@12
LAB_10006b94:
  10006b94  OR dword ptr [EBP + -0x4],0xffffffff
  10006b98  JMP 0x10006bb4    ; LAB_10006bb4
LAB_10006bb4:
  10006bb4  MOV EAX,dword ptr [EDI + 0x8]
  10006bb7  MOV ESI,dword ptr [EAX + ESI*0x8]
  10006bba  MOV dword ptr [EBP + -0x1c],ESI
  10006bbd  JMP 0x10006b65    ; LAB_10006b65
LAB_10006bbf:
  10006bbf  MOV dword ptr [EBX + 0x8],ESI
  10006bc2  MOV ECX,dword ptr [EBP + -0x10]
  10006bc5  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  10006bcc  POP EDI
  10006bcd  POP ESI
  10006bce  POP EBX
  10006bcf  LEAVE
  10006bd0  RET

;==== FUNCTION FUN_10006be7 @ 10006be7 : undefined FUN_10006be7(PEXCEPTION_RECORD param_1, PVOID param_2, undefined4 param_3, undefined4 param_4, int param_5, byte * param_6, byte * param_7, int * param_8, int param_9, PVOID param_10)
  10006be7  PUSH EBP
  10006be8  MOV EBP,ESP
  10006bea  CMP dword ptr [EBP + 0x20],0x0
  10006bee  PUSH EBX
  10006bef  MOV EBX,dword ptr [EBP + 0x1c]
  10006bf2  PUSH ESI
  10006bf3  PUSH EDI
  10006bf4  MOV EDI,dword ptr [EBP + 0xc]
  10006bf7  JZ 0x10006c09    ; LAB_10006c09
  10006bf9  PUSH dword ptr [EBP + 0x20]
  10006bfc  PUSH EBX
  10006bfd  PUSH EDI
  10006bfe  PUSH dword ptr [EBP + 0x8]
  10006c01  CALL 0x10006d98    ; FUN_10006d98
  10006c06  ADD ESP,0x10
LAB_10006c09:
  10006c09  CMP dword ptr [EBP + 0x2c],0x0
  10006c0d  PUSH dword ptr [EBP + 0x8]
  10006c10  JNZ 0x10006c15    ; LAB_10006c15
  10006c12  PUSH EDI
  10006c13  JMP 0x10006c18    ; LAB_10006c18
LAB_10006c15:
  10006c15  PUSH dword ptr [EBP + 0x2c]
LAB_10006c18:
  10006c18  CALL 0x1000524b    ; FUN_1000524b
  10006c1d  MOV ESI,dword ptr [EBP + 0x24]
  10006c20  PUSH dword ptr [ESI]
  10006c22  PUSH dword ptr [EBP + 0x18]
  10006c25  PUSH dword ptr [EBP + 0x14]
  10006c28  PUSH EDI
  10006c29  CALL 0x10006b33    ; FUN_10006b33
  10006c2e  MOV EAX,dword ptr [ESI + 0x4]
  10006c31  PUSH 0x100
  10006c36  PUSH dword ptr [EBP + 0x28]
  10006c39  INC EAX
  10006c3a  MOV dword ptr [EDI + 0x8],EAX
  10006c3d  PUSH dword ptr [EBX + 0xc]
  10006c40  PUSH dword ptr [EBP + 0x18]
  10006c43  PUSH dword ptr [EBP + 0x10]
  10006c46  PUSH EDI
  10006c47  PUSH dword ptr [EBP + 0x8]
  10006c4a  CALL 0x10006c62    ; FUN_10006c62
  10006c4f  ADD ESP,0x2c
  10006c52  TEST EAX,EAX
  10006c54  JZ 0x10006c5d    ; LAB_10006c5d
  10006c56  PUSH EDI
  10006c57  PUSH EAX
  10006c58  CALL 0x10005202    ; FUN_10005202
LAB_10006c5d:
  10006c5d  POP EDI
  10006c5e  POP ESI
  10006c5f  POP EBX
  10006c60  POP EBP
  10006c61  RET

;==== FUNCTION FUN_10006c62 @ 10006c62 : undefined4 FUN_10006c62(undefined4 param_1, undefined4 param_2, undefined4 param_3, undefined4 param_4, undefined4 param_5, int param_6, int param_7)
  10006c62  PUSH EBP
  10006c63  MOV EBP,ESP
  10006c65  PUSH -0x1
  10006c67  PUSH 0x1000d238    ; DAT_1000d238
  10006c6c  PUSH 0x10009edc    ; LAB_10009edc
  10006c71  MOV EAX,FS:[0x0]    ; ExceptionList
  10006c77  PUSH EAX
  10006c78  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  10006c7f  SUB ESP,0x1c
  10006c82  PUSH EBX
  10006c83  PUSH ESI
  10006c84  PUSH EDI
  10006c85  MOV dword ptr [EBP + -0x18],ESP
  10006c88  MOV EAX,dword ptr [EBP + 0x18]
  10006c8b  MOV dword ptr [EBP + -0x2c],EAX
  10006c8e  XOR EBX,EBX
  10006c90  MOV dword ptr [EBP + -0x24],EBX
  10006c93  MOV ESI,dword ptr [EBP + 0xc]
  10006c96  MOV ECX,dword ptr [ESI + -0x4]
  10006c99  MOV dword ptr [EBP + -0x28],ECX
  10006c9c  MOV ECX,dword ptr [0x1000f63c]    ; DAT_1000f63c
  10006ca2  MOV dword ptr [EBP + -0x1c],ECX
  10006ca5  MOV ECX,dword ptr [0x1000f640]    ; DAT_1000f640
  10006cab  MOV dword ptr [EBP + -0x20],ECX
  10006cae  MOV EDI,dword ptr [EBP + 0x8]
  10006cb1  MOV dword ptr [0x1000f63c],EDI    ; DAT_1000f63c
  10006cb7  MOV ECX,dword ptr [EBP + 0x10]
  10006cba  MOV dword ptr [0x1000f640],ECX    ; DAT_1000f640
  10006cc0  MOV dword ptr [EBP + -0x4],EBX
  10006cc3  MOV dword ptr [EBP + -0x4],0x1
  10006cca  PUSH dword ptr [EBP + 0x20]
  10006ccd  PUSH dword ptr [EBP + 0x1c]
  10006cd0  PUSH EAX
  10006cd1  PUSH dword ptr [EBP + 0x14]
  10006cd4  PUSH ESI
  10006cd5  CALL 0x100052ea    ; FUN_100052ea
  10006cda  ADD ESP,0x14
  10006cdd  MOV dword ptr [EBP + -0x2c],EAX
  10006ce0  MOV dword ptr [EBP + -0x4],EBX
  10006ce3  OR dword ptr [EBP + -0x4],0xffffffff
  10006ce7  CALL 0x10006d28    ; FUN_10006d28
  10006cec  MOV EAX,dword ptr [EBP + -0x2c]
  10006cef  MOV ECX,dword ptr [EBP + -0x10]
  10006cf2  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  10006cf9  POP EDI
  10006cfa  POP ESI
  10006cfb  POP EBX
  10006cfc  LEAVE
  10006cfd  RET

;==== FUNCTION FUN_10006d28 @ 10006d28 : undefined FUN_10006d28(void)
  10006d28  MOV EAX,dword ptr [EBP + -0x28]
  10006d2b  MOV dword ptr [ESI + -0x4],EAX
  10006d2e  MOV EAX,dword ptr [EBP + -0x1c]
  10006d31  MOV [0x1000f63c],EAX    ; DAT_1000f63c
  10006d36  MOV EAX,dword ptr [EBP + -0x20]
  10006d39  MOV [0x1000f640],EAX    ; DAT_1000f640
  10006d3e  CMP dword ptr [EDI],0xe06d7363
  10006d44  JNZ 0x10006d6d    ; LAB_10006d6d
  10006d46  CMP dword ptr [EDI + 0x10],0x3
  10006d4a  JNZ 0x10006d6d    ; LAB_10006d6d
  10006d4c  CMP dword ptr [EDI + 0x14],0x19930520
  10006d53  JNZ 0x10006d6d    ; LAB_10006d6d
  10006d55  CMP dword ptr [EBP + -0x24],EBX
  10006d58  JNZ 0x10006d6d    ; LAB_10006d6d
  10006d5a  CMP dword ptr [EBP + -0x2c],EBX
  10006d5d  JZ 0x10006d6d    ; LAB_10006d6d
  10006d5f  CALL 0x100055b2    ; __abnormal_termination
  10006d64  PUSH EAX
  10006d65  PUSH EDI
  10006d66  CALL 0x10006f5c    ; FUN_10006f5c
  10006d6b  POP ECX
  10006d6c  POP ECX
LAB_10006d6d:
  10006d6d  RET

;==== FUNCTION FUN_10006d98 @ 10006d98 : undefined FUN_10006d98(int param_1, int param_2, byte * param_3, byte * param_4)
  10006d98  PUSH EBP
  10006d99  MOV EBP,ESP
  10006d9b  PUSH -0x1
  10006d9d  PUSH 0x1000d250    ; DAT_1000d250
  10006da2  PUSH 0x10009edc    ; LAB_10009edc
  10006da7  MOV EAX,FS:[0x0]    ; ExceptionList
  10006dad  PUSH EAX
  10006dae  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  10006db5  SUB ESP,0xc
  10006db8  PUSH EBX
  10006db9  PUSH ESI
  10006dba  PUSH EDI
  10006dbb  MOV dword ptr [EBP + -0x18],ESP
  10006dbe  MOV ECX,dword ptr [EBP + 0x10]
  10006dc1  MOV EAX,dword ptr [ECX + 0x4]
  10006dc4  TEST EAX,EAX
  10006dc6  JZ 0x10006f41    ; LAB_10006f41
  10006dcc  CMP byte ptr [EAX + 0x8],0x0
  10006dd0  JZ 0x10006f41    ; LAB_10006f41
  10006dd6  MOV EAX,dword ptr [ECX + 0x8]
  10006dd9  TEST EAX,EAX
  10006ddb  JZ 0x10006f41    ; LAB_10006f41
  10006de1  MOV EDX,dword ptr [EBP + 0xc]
  10006de4  LEA EDI,[EAX + EDX*0x1 + 0xc]
  10006de8  AND dword ptr [EBP + -0x4],0x0
  10006dec  TEST byte ptr [ECX],0x8
  10006def  JZ 0x10006e35    ; LAB_10006e35
  10006df1  MOV ESI,dword ptr [EBP + 0x8]
  10006df4  PUSH 0x1
  10006df6  PUSH dword ptr [ESI + 0x18]
  10006df9  CALL 0x10009df9    ; FUN_10009df9
  10006dfe  POP ECX
  10006dff  POP ECX
  10006e00  TEST EAX,EAX
  10006e02  JZ 0x10006f38    ; LAB_10006f38
  10006e08  PUSH 0x1
  10006e0a  PUSH EDI
  10006e0b  CALL 0x10009e15    ; FUN_10009e15
  10006e10  POP ECX
  10006e11  POP ECX
  10006e12  TEST EAX,EAX
  10006e14  JZ 0x10006f38    ; LAB_10006f38
  10006e1a  MOV EAX,dword ptr [ESI + 0x18]
  10006e1d  MOV dword ptr [EDI],EAX
  10006e1f  MOV ECX,dword ptr [EBP + 0x14]
  10006e22  ADD ECX,0x8
  10006e25  PUSH ECX
LAB_10006e26:
  10006e26  PUSH EAX
  10006e27  CALL 0x10006fc3    ; FUN_10006fc3
  10006e2c  POP ECX
  10006e2d  POP ECX
  10006e2e  MOV dword ptr [EDI],EAX
  10006e30  JMP 0x10006f3d    ; LAB_10006f3d
LAB_10006e35:
  10006e35  MOV ESI,dword ptr [EBP + 0x14]
  10006e38  TEST byte ptr [ESI],0x1
  10006e3b  JZ 0x10006e8f    ; LAB_10006e8f
  10006e3d  MOV EBX,dword ptr [EBP + 0x8]
  10006e40  PUSH 0x1
  10006e42  PUSH dword ptr [EBX + 0x18]
  10006e45  CALL 0x10009df9    ; FUN_10009df9
  10006e4a  POP ECX
  10006e4b  POP ECX
  10006e4c  TEST EAX,EAX
  10006e4e  JZ 0x10006f38    ; LAB_10006f38
  10006e54  PUSH 0x1
  10006e56  PUSH EDI
  10006e57  CALL 0x10009e15    ; FUN_10009e15
  10006e5c  POP ECX
  10006e5d  POP ECX
  10006e5e  TEST EAX,EAX
  10006e60  JZ 0x10006f38    ; LAB_10006f38
  10006e66  PUSH dword ptr [ESI + 0x14]
  10006e69  PUSH dword ptr [EBX + 0x18]
  10006e6c  PUSH EDI
  10006e6d  CALL 0x10008580    ; FUN_10008580
  10006e72  ADD ESP,0xc
  10006e75  CMP dword ptr [ESI + 0x14],0x4
  10006e79  JNZ 0x10006f3d    ; LAB_10006f3d
  10006e7f  MOV EAX,dword ptr [EDI]
  10006e81  TEST EAX,EAX
  10006e83  JZ 0x10006f3d    ; LAB_10006f3d
  10006e89  ADD ESI,0x8
  10006e8c  PUSH ESI
  10006e8d  JMP 0x10006e26    ; LAB_10006e26
LAB_10006e8f:
  10006e8f  CMP dword ptr [ESI + 0x18],0x0
  10006e93  MOV EBX,dword ptr [EBP + 0x8]
  10006e96  PUSH 0x1
  10006e98  PUSH dword ptr [EBX + 0x18]
  10006e9b  JNZ 0x10006ed7    ; LAB_10006ed7
  10006e9d  CALL 0x10009df9    ; FUN_10009df9
  10006ea2  POP ECX
  10006ea3  POP ECX
  10006ea4  TEST EAX,EAX
  10006ea6  JZ 0x10006f38    ; LAB_10006f38
  10006eac  PUSH 0x1
  10006eae  PUSH EDI
  10006eaf  CALL 0x10009e15    ; FUN_10009e15
  10006eb4  POP ECX
  10006eb5  POP ECX
  10006eb6  TEST EAX,EAX
  10006eb8  JZ 0x10006f38    ; LAB_10006f38
  10006eba  PUSH dword ptr [ESI + 0x14]
  10006ebd  ADD ESI,0x8
  10006ec0  PUSH ESI
  10006ec1  PUSH dword ptr [EBX + 0x18]
  10006ec4  CALL 0x10006fc3    ; FUN_10006fc3
  10006ec9  POP ECX
  10006eca  POP ECX
  10006ecb  PUSH EAX
  10006ecc  PUSH EDI
  10006ecd  CALL 0x10008580    ; FUN_10008580
  10006ed2  ADD ESP,0xc
  10006ed5  JMP 0x10006f3d    ; LAB_10006f3d
LAB_10006ed7:
  10006ed7  CALL 0x10009df9    ; FUN_10009df9
  10006edc  POP ECX
  10006edd  POP ECX
  10006ede  TEST EAX,EAX
  10006ee0  JZ 0x10006f38    ; LAB_10006f38
  10006ee2  PUSH 0x1
  10006ee4  PUSH EDI
  10006ee5  CALL 0x10009e15    ; FUN_10009e15
  10006eea  POP ECX
  10006eeb  POP ECX
  10006eec  TEST EAX,EAX
  10006eee  JZ 0x10006f38    ; LAB_10006f38
  10006ef0  PUSH dword ptr [ESI + 0x18]
  10006ef3  CALL 0x10009e31    ; FUN_10009e31
  10006ef8  POP ECX
  10006ef9  TEST EAX,EAX
  10006efb  JZ 0x10006f38    ; LAB_10006f38
  10006efd  TEST byte ptr [ESI],0x4
  10006f00  JZ 0x10006f1e    ; LAB_10006f1e
  10006f02  PUSH 0x1
  10006f04  LEA EAX,[ESI + 0x8]
  10006f07  PUSH EAX
  10006f08  PUSH dword ptr [EBX + 0x18]
  10006f0b  CALL 0x10006fc3    ; FUN_10006fc3
  10006f10  POP ECX
  10006f11  POP ECX
  10006f12  PUSH EAX
  10006f13  PUSH dword ptr [ESI + 0x18]
  10006f16  PUSH EDI
  10006f17  CALL 0x10005244    ; FUN_10005244
  10006f1c  JMP 0x10006f3d    ; LAB_10006f3d
LAB_10006f1e:
  10006f1e  LEA EAX,[ESI + 0x8]
  10006f21  PUSH EAX
  10006f22  PUSH dword ptr [EBX + 0x18]
  10006f25  CALL 0x10006fc3    ; FUN_10006fc3
  10006f2a  POP ECX
  10006f2b  POP ECX
  10006f2c  PUSH EAX
  10006f2d  PUSH dword ptr [ESI + 0x18]
  10006f30  PUSH EDI
  10006f31  CALL 0x1000523d    ; FUN_1000523d
  10006f36  JMP 0x10006f3d    ; LAB_10006f3d
LAB_10006f38:
  10006f38  CALL 0x100070a2    ; FUN_100070a2
LAB_10006f3d:
  10006f3d  OR dword ptr [EBP + -0x4],0xffffffff
LAB_10006f41:
  10006f41  MOV ECX,dword ptr [EBP + -0x10]
  10006f44  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  10006f4b  POP EDI
  10006f4c  POP ESI
  10006f4d  POP EBX
  10006f4e  LEAVE
  10006f4f  RET

;==== FUNCTION FUN_10006f5c @ 10006f5c : undefined FUN_10006f5c(int param_1)
  10006f5c  PUSH EBP
  10006f5d  MOV EBP,ESP
  10006f5f  PUSH -0x1
  10006f61  PUSH 0x1000d260    ; DAT_1000d260
  10006f66  PUSH 0x10009edc    ; LAB_10009edc
  10006f6b  MOV EAX,FS:[0x0]    ; ExceptionList
  10006f71  PUSH EAX
  10006f72  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  10006f79  PUSH ECX
  10006f7a  PUSH ECX
  10006f7b  PUSH EBX
  10006f7c  PUSH ESI
  10006f7d  PUSH EDI
  10006f7e  MOV dword ptr [EBP + -0x18],ESP
  10006f81  MOV EAX,dword ptr [EBP + 0x8]
  10006f84  TEST EAX,EAX
  10006f86  JZ 0x10006fa3    ; LAB_10006fa3
  10006f88  MOV ECX,dword ptr [EAX + 0x1c]
  10006f8b  MOV ECX,dword ptr [ECX + 0x4]
  10006f8e  TEST ECX,ECX
  10006f90  JZ 0x10006fa3    ; LAB_10006fa3
  10006f92  AND dword ptr [EBP + -0x4],0x0
  10006f96  PUSH ECX
  10006f97  PUSH dword ptr [EAX + 0x18]
  10006f9a  CALL 0x10005236    ; FUN_10005236
  10006f9f  OR dword ptr [EBP + -0x4],0xffffffff
LAB_10006fa3:
  10006fa3  MOV ECX,dword ptr [EBP + -0x10]
  10006fa6  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  10006fad  POP EDI
  10006fae  POP ESI
  10006faf  POP EBX
  10006fb0  LEAVE
  10006fb1  RET

;==== FUNCTION FUN_10006fc3 @ 10006fc3 : int FUN_10006fc3(int param_1, int * param_2)
  10006fc3  MOV ECX,dword ptr [ESP + 0x8]
  10006fc7  PUSH ESI
  10006fc8  MOV ESI,dword ptr [ESP + 0x8]
  10006fcc  MOV EAX,dword ptr [ECX]
  10006fce  MOV EDX,dword ptr [ECX + 0x4]
  10006fd1  ADD EAX,ESI
  10006fd3  TEST EDX,EDX
  10006fd5  JL 0x10006fe4    ; LAB_10006fe4
  10006fd7  MOV ESI,dword ptr [EDX + ESI*0x1]
  10006fda  MOV ECX,dword ptr [ECX + 0x8]
  10006fdd  MOV ECX,dword ptr [ESI + ECX*0x1]
  10006fe0  ADD ECX,EDX
  10006fe2  ADD EAX,ECX
LAB_10006fe4:
  10006fe4  POP ESI
  10006fe5  RET

;==== FUNCTION __CallSettingFrame@12 @ 10006ff0 : undefined __CallSettingFrame@12(undefined4 param_1, undefined4 param_2, int param_3)
  10006ff0  PUSH EBP
  10006ff1  MOV EBP,ESP
  10006ff3  SUB ESP,0x4
  10006ff6  PUSH EBX
  10006ff7  PUSH ECX
  10006ff8  MOV EAX,dword ptr [EBP + 0xc]
  10006ffb  ADD EAX,0xc
  10006ffe  MOV dword ptr [EBP + -0x4],EAX
  10007001  MOV EAX,dword ptr [EBP + 0x8]
  10007004  PUSH EBP
  10007005  PUSH dword ptr [EBP + 0x10]
  10007008  MOV ECX,dword ptr [EBP + 0x10]
  1000700b  MOV EBP,dword ptr [EBP + -0x4]
  1000700e  CALL 0x100055d5    ; __NLG_Notify1
  10007013  PUSH ESI
  10007014  PUSH EDI
  10007015  CALL EAX
  10007017  POP EDI
  10007018  POP ESI
  10007019  MOV EBX,EBP
  1000701b  POP EBP
  1000701c  MOV ECX,dword ptr [EBP + 0x10]
  1000701f  PUSH EBP
  10007020  MOV EBP,EBX
  10007022  CMP ECX,0x100
  10007028  JNZ 0x1000702f    ; LAB_1000702f
  1000702a  MOV ECX,0x2
LAB_1000702f:
  1000702f  PUSH ECX
  10007030  CALL 0x100055d5    ; __NLG_Notify1
  10007035  POP EBP
  10007036  POP ECX
  10007037  POP EBX
  10007038  LEAVE
  10007039  RET 0xc

;==== FUNCTION FUN_1000703c @ 1000703c : undefined FUN_1000703c(void)
  1000703c  PUSH EBP
  1000703d  MOV EBP,ESP
  1000703f  PUSH -0x1
  10007041  PUSH 0x1000d270    ; DAT_1000d270
  10007046  PUSH 0x10009edc    ; LAB_10009edc
  1000704b  MOV EAX,FS:[0x0]    ; ExceptionList
  10007051  PUSH EAX
  10007052  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  10007059  PUSH ECX
  1000705a  PUSH ECX
  1000705b  PUSH EBX
  1000705c  PUSH ESI
  1000705d  PUSH EDI
  1000705e  MOV dword ptr [EBP + -0x18],ESP
  10007061  AND dword ptr [EBP + -0x4],0x0
  10007065  MOV EAX,[0x1000f648]    ; DAT_1000f648
  1000706a  TEST EAX,EAX
  1000706c  JZ 0x10007084    ; LAB_10007084
  1000706e  MOV dword ptr [EBP + -0x4],0x1
  10007075  CALL EAX
  10007077  JMP 0x10007080    ; LAB_10007080
LAB_10007080:
  10007080  AND dword ptr [EBP + -0x4],0x0
LAB_10007084:
  10007084  OR dword ptr [EBP + -0x4],0xffffffff
  10007088  CALL 0x1000708d    ; LAB_1000708d
LAB_1000708d:
  1000708d  JMP 0x10009fb4    ; FUN_10009fb4

;==== FUNCTION FUN_100070a2 @ 100070a2 : undefined FUN_100070a2(void)
  100070a2  PUSH EBP
  100070a3  MOV EBP,ESP
  100070a5  PUSH -0x1
  100070a7  PUSH 0x1000d288    ; DAT_1000d288
  100070ac  PUSH 0x10009edc    ; LAB_10009edc
  100070b1  MOV EAX,FS:[0x0]    ; ExceptionList
  100070b7  PUSH EAX
  100070b8  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  100070bf  PUSH ECX
  100070c0  PUSH ECX
  100070c1  PUSH EBX
  100070c2  PUSH ESI
  100070c3  PUSH EDI
  100070c4  MOV dword ptr [EBP + -0x18],ESP
  100070c7  AND dword ptr [EBP + -0x4],0x0
  100070cb  MOV EAX,[0x1000ea84]    ; PTR_FUN_1000ea84
  100070d0  TEST EAX,EAX
  100070d2  JZ 0x100070ea    ; LAB_100070ea
  100070d4  MOV dword ptr [EBP + -0x4],0x1
  100070db  CALL EAX    ; FUN_1000703c
  100070dd  JMP 0x100070e6    ; LAB_100070e6
LAB_100070e6:
  100070e6  AND dword ptr [EBP + -0x4],0x0
LAB_100070ea:
  100070ea  OR dword ptr [EBP + -0x4],0xffffffff
  100070ee  CALL 0x100070f3    ; LAB_100070f3
LAB_100070f3:
  100070f3  JMP 0x1000703c    ; FUN_1000703c

;==== FUNCTION FUN_100070f8 @ 100070f8 : uint FUN_100070f8(void * this, int param_1, uint param_2)
  100070f8  PUSH EBP
  100070f9  MOV EBP,ESP
  100070fb  PUSH ECX
  100070fc  MOV EAX,dword ptr [EBP + 0x8]
  100070ff  LEA ECX,[EAX + 0x1]
  10007102  CMP ECX,0x100
  10007108  JA 0x10007116    ; LAB_10007116
  1000710a  MOV ECX,dword ptr [0x1000ea88]    ; PTR_DAT_1000ea88
  10007110  MOVZX EAX,word ptr [ECX + EAX*0x2]    ; DAT_1000ea92
  10007114  JMP 0x10007168    ; LAB_10007168
LAB_10007116:
  10007116  MOV ECX,EAX
  10007118  PUSH ESI
  10007119  MOV ESI,dword ptr [0x1000ea88]    ; PTR_DAT_1000ea88
  1000711f  SAR ECX,0x8
  10007122  MOVZX EDX,CL
  10007125  TEST byte ptr [ESI + EDX*0x2 + 0x1],0x80    ; DAT_1000ea93
  1000712a  POP ESI
  1000712b  JZ 0x1000713b    ; LAB_1000713b
  1000712d  AND byte ptr [EBP + -0x2],0x0
  10007131  MOV byte ptr [EBP + -0x4],CL
  10007134  MOV byte ptr [EBP + -0x3],AL
  10007137  PUSH 0x2
  10007139  JMP 0x10007144    ; LAB_10007144
LAB_1000713b:
  1000713b  AND byte ptr [EBP + -0x3],0x0
  1000713f  MOV byte ptr [EBP + -0x4],AL
  10007142  PUSH 0x1
LAB_10007144:
  10007144  POP EAX
  10007145  LEA ECX,[EBP + 0xa]
  10007148  PUSH 0x1
  1000714a  PUSH 0x0
  1000714c  PUSH 0x0
  1000714e  PUSH ECX
  1000714f  PUSH EAX
  10007150  LEA EAX,[EBP + -0x4]
  10007153  PUSH EAX
  10007154  PUSH 0x1
  10007156  CALL 0x10009fcb    ; FUN_10009fcb
  1000715b  ADD ESP,0x1c
  1000715e  TEST EAX,EAX
  10007160  JNZ 0x10007164    ; LAB_10007164
  10007162  LEAVE
  10007163  RET
LAB_10007164:
  10007164  MOVZX EAX,word ptr [EBP + 0xa]
LAB_10007168:
  10007168  AND EAX,dword ptr [EBP + 0xc]
  1000716b  LEAVE
  1000716c  RET

;==== FUNCTION FUN_100071a4 @ 100071a4 : undefined FUN_100071a4(void)
  100071a4  MOV EAX,[0x1000ea20]    ; PTR_FUN_1000ea20
  100071a9  TEST EAX,EAX
  100071ab  JZ 0x100071af    ; LAB_100071af
  100071ad  CALL EAX    ; FUN_10005137
LAB_100071af:
  100071af  PUSH 0x1000e018    ; DAT_1000e018
  100071b4  PUSH 0x1000e008    ; DAT_1000e008
  100071b9  CALL 0x100072aa    ; FUN_100072aa
  100071be  PUSH 0x1000e004    ; DAT_1000e004
  100071c3  PUSH 0x1000e000    ; DAT_1000e000
  100071c8  CALL 0x100072aa    ; FUN_100072aa
  100071cd  ADD ESP,0x10
  100071d0  RET

;==== FUNCTION __exit @ 100071e2 : void __exit(int _Code)
  100071e2  PUSH 0x0
  100071e4  PUSH 0x1
  100071e6  PUSH dword ptr [ESP + 0xc]
  100071ea  CALL 0x10007211    ; FUN_10007211
  100071ef  ADD ESP,0xc
  100071f2  RET

;==== FUNCTION FUN_100071f3 @ 100071f3 : undefined FUN_100071f3(void)
  100071f3  PUSH 0x1
  100071f5  PUSH 0x0
  100071f7  PUSH 0x0
  100071f9  CALL 0x10007211    ; FUN_10007211
  100071fe  ADD ESP,0xc
  10007201  RET

;==== FUNCTION FUN_10007211 @ 10007211 : undefined FUN_10007211(UINT param_1, int param_2, int param_3)
  10007211  PUSH EDI
  10007212  PUSH 0x1
  10007214  POP EDI
  10007215  CMP dword ptr [0x1000f694],EDI    ; DAT_1000f694
  1000721b  JNZ 0x1000722e    ; LAB_1000722e
  1000721d  PUSH dword ptr [ESP + 0x8]
  10007221  CALL dword ptr [0x1000d044]    ; PTR_GetCurrentProcess_1000d044 KERNEL32.DLL::GetCurrentProcess
  10007227  PUSH EAX
  10007228  CALL dword ptr [0x1000d040]    ; PTR_TerminateProcess_1000d040 KERNEL32.DLL::TerminateProcess
LAB_1000722e:
  1000722e  CMP dword ptr [ESP + 0xc],0x0
  10007233  PUSH EBX
  10007234  MOV EBX,dword ptr [ESP + 0x14]
  10007238  MOV dword ptr [0x1000f690],EDI    ; DAT_1000f690
  1000723e  MOV byte ptr [0x1000f68c],BL    ; DAT_1000f68c
  10007244  JNZ 0x10007282    ; LAB_10007282
  10007246  MOV EAX,[0x10010bb4]    ; DAT_10010bb4
  1000724b  TEST EAX,EAX
  1000724d  JZ 0x10007271    ; LAB_10007271
  1000724f  MOV ECX,dword ptr [0x10010bb0]    ; DAT_10010bb0
  10007255  PUSH ESI
  10007256  LEA ESI,[ECX + -0x4]
  10007259  CMP ESI,EAX
  1000725b  JC 0x10007270    ; LAB_10007270
LAB_1000725d:
  1000725d  MOV EAX,dword ptr [ESI]
  1000725f  TEST EAX,EAX
  10007261  JZ 0x10007265    ; LAB_10007265
  10007263  CALL EAX
LAB_10007265:
  10007265  SUB ESI,0x4
  10007268  CMP ESI,dword ptr [0x10010bb4]    ; DAT_10010bb4
  1000726e  JNC 0x1000725d    ; LAB_1000725d
LAB_10007270:
  10007270  POP ESI
LAB_10007271:
  10007271  PUSH 0x1000e024    ; DAT_1000e024
  10007276  PUSH 0x1000e01c    ; DAT_1000e01c
  1000727b  CALL 0x100072aa    ; FUN_100072aa
  10007280  POP ECX
  10007281  POP ECX
LAB_10007282:
  10007282  PUSH 0x1000e030    ; DAT_1000e030
  10007287  PUSH 0x1000e028    ; DAT_1000e028
  1000728c  CALL 0x100072aa    ; FUN_100072aa
  10007291  POP ECX
  10007292  POP ECX
  10007293  TEST EBX,EBX
  10007295  POP EBX
  10007296  JNZ 0x100072a8    ; LAB_100072a8
  10007298  PUSH dword ptr [ESP + 0x8]
  1000729c  MOV dword ptr [0x1000f694],EDI    ; DAT_1000f694
  100072a2  CALL dword ptr [0x1000d03c]    ; PTR_ExitProcess_1000d03c KERNEL32.DLL::ExitProcess
LAB_100072a8:
  100072a8  POP EDI
  100072a9  RET

;==== FUNCTION FUN_100072aa @ 100072aa : undefined FUN_100072aa(undefined4 * param_1, undefined4 * param_2)
  100072aa  PUSH ESI
  100072ab  MOV ESI,dword ptr [ESP + 0x8]
LAB_100072af:
  100072af  CMP ESI,dword ptr [ESP + 0xc]
  100072b3  JNC 0x100072c2    ; LAB_100072c2
  100072b5  MOV EAX,dword ptr [ESI]
  100072b7  TEST EAX,EAX
  100072b9  JZ 0x100072bd    ; LAB_100072bd
  100072bb  CALL EAX
LAB_100072bd:
  100072bd  ADD ESI,0x4
  100072c0  JMP 0x100072af    ; LAB_100072af
LAB_100072c2:
  100072c2  POP ESI
  100072c3  RET

;==== FUNCTION FUN_100072c4 @ 100072c4 : undefined4 FUN_100072c4(int param_1)
  100072c4  XOR EAX,EAX
  100072c6  PUSH 0x0
  100072c8  CMP dword ptr [ESP + 0x8],EAX
  100072cc  PUSH 0x1000
  100072d1  SETZ AL
  100072d4  PUSH EAX
  100072d5  CALL dword ptr [0x1000d04c]    ; PTR_HeapCreate_1000d04c KERNEL32.DLL::HeapCreate
  100072db  TEST EAX,EAX
  100072dd  MOV [0x10010ba4],EAX    ; DAT_10010ba4
  100072e2  JZ 0x100072f9    ; LAB_100072f9
  100072e4  CALL 0x10008961    ; FUN_10008961
  100072e9  TEST EAX,EAX
  100072eb  JNZ 0x100072fc    ; LAB_100072fc
  100072ed  PUSH dword ptr [0x10010ba4]    ; DAT_10010ba4
  100072f3  CALL dword ptr [0x1000d048]    ; PTR_HeapDestroy_1000d048 KERNEL32.DLL::HeapDestroy
LAB_100072f9:
  100072f9  XOR EAX,EAX
  100072fb  RET
LAB_100072fc:
  100072fc  PUSH 0x1
  100072fe  POP EAX
  100072ff  RET

;==== FUNCTION FUN_10007300 @ 10007300 : undefined FUN_10007300(void)
  10007300  PUSH EBX
  10007301  XOR EBX,EBX
  10007303  CMP dword ptr [0x10010a94],EBX    ; DAT_10010a94
  10007309  PUSH EBP
  1000730a  MOV EBP,dword ptr [0x1000d034]    ; PTR_HeapFree_1000d034
  10007310  JLE 0x10007356    ; LAB_10007356
  10007312  MOV EAX,[0x10010a98]    ; DAT_10010a98
  10007317  PUSH ESI
  10007318  PUSH EDI
  10007319  MOV EDI,dword ptr [0x1000d050]    ; PTR_VirtualFree_1000d050
  1000731f  LEA ESI,[EAX + 0xc]
LAB_10007322:
  10007322  PUSH 0x4000
  10007327  PUSH 0x100000
  1000732c  PUSH dword ptr [ESI]
  1000732e  CALL EDI    ; KERNEL32.DLL::VirtualFree
  10007330  PUSH 0x8000
  10007335  PUSH 0x0
  10007337  PUSH dword ptr [ESI]
  10007339  CALL EDI    ; KERNEL32.DLL::VirtualFree
  1000733b  PUSH dword ptr [ESI + 0x4]
  1000733e  PUSH 0x0
  10007340  PUSH dword ptr [0x10010ba4]    ; DAT_10010ba4
  10007346  CALL EBP    ; KERNEL32.DLL::HeapFree
  10007348  ADD ESI,0x14
  1000734b  INC EBX
  1000734c  CMP EBX,dword ptr [0x10010a94]    ; DAT_10010a94
  10007352  JL 0x10007322    ; LAB_10007322
  10007354  POP EDI
  10007355  POP ESI
LAB_10007356:
  10007356  PUSH dword ptr [0x10010a98]    ; DAT_10010a98
  1000735c  PUSH 0x0
  1000735e  PUSH dword ptr [0x10010ba4]    ; DAT_10010ba4
  10007364  CALL EBP    ; KERNEL32.DLL::HeapFree
  10007366  PUSH dword ptr [0x10010ba4]    ; DAT_10010ba4
  1000736c  CALL dword ptr [0x1000d048]    ; PTR_HeapDestroy_1000d048 KERNEL32.DLL::HeapDestroy
  10007372  POP EBP
  10007373  POP EBX
  10007374  RET

;==== FUNCTION FUN_10007375 @ 10007375 : undefined FUN_10007375(void)
  10007375  SUB ESP,0x44
  10007378  PUSH EBX
  10007379  PUSH EBP
  1000737a  PUSH ESI
  1000737b  PUSH EDI
  1000737c  PUSH 0x100
  10007381  CALL 0x10005e59    ; _malloc
  10007386  MOV ESI,EAX
  10007388  POP ECX
  10007389  TEST ESI,ESI
  1000738b  JNZ 0x10007395    ; LAB_10007395
  1000738d  PUSH 0x1b
  1000738f  CALL 0x10005943    ; __amsg_exit
  10007394  POP ECX
LAB_10007395:
  10007395  MOV dword ptr [0x10010aa0],ESI    ; DAT_10010aa0
  1000739b  MOV dword ptr [0x10010ba0],0x20    ; DAT_10010ba0
  100073a5  LEA EAX,[ESI + 0x100]
LAB_100073ab:
  100073ab  CMP ESI,EAX
  100073ad  JNC 0x100073c9    ; LAB_100073c9
  100073af  AND byte ptr [ESI + 0x4],0x0
  100073b3  OR dword ptr [ESI],0xffffffff
  100073b6  MOV byte ptr [ESI + 0x5],0xa
  100073ba  MOV EAX,[0x10010aa0]    ; DAT_10010aa0
  100073bf  ADD ESI,0x8
  100073c2  ADD EAX,0x100
  100073c7  JMP 0x100073ab    ; LAB_100073ab
LAB_100073c9:
  100073c9  LEA EAX,[ESP + 0x10]
  100073cd  PUSH EAX
  100073ce  CALL dword ptr [0x1000d060]    ; PTR_GetStartupInfoA_1000d060 KERNEL32.DLL::GetStartupInfoA
  100073d4  CMP word ptr [ESP + 0x42],0x0
  100073da  JZ 0x100074a5    ; LAB_100074a5
  100073e0  MOV EAX,dword ptr [ESP + 0x44]
  100073e4  TEST EAX,EAX
  100073e6  JZ 0x100074a5    ; LAB_100074a5
  100073ec  MOV ESI,dword ptr [EAX]
  100073ee  LEA EBP,[EAX + 0x4]
  100073f1  MOV EAX,0x800
  100073f6  CMP ESI,EAX
  100073f8  LEA EBX,[ESI + EBP*0x1]
  100073fb  JL 0x100073ff    ; LAB_100073ff
  100073fd  MOV ESI,EAX
LAB_100073ff:
  100073ff  CMP dword ptr [0x10010ba0],ESI    ; DAT_10010ba0
  10007405  JGE 0x10007459    ; LAB_10007459
  10007407  MOV EDI,0x10010aa4    ; DAT_10010aa4
LAB_1000740c:
  1000740c  PUSH 0x100
  10007411  CALL 0x10005e59    ; _malloc
  10007416  TEST EAX,EAX
  10007418  POP ECX
  10007419  JZ 0x10007453    ; LAB_10007453
  1000741b  ADD dword ptr [0x10010ba0],0x20    ; DAT_10010ba0
  10007422  MOV dword ptr [EDI],EAX    ; DAT_10010aa4
  10007424  LEA ECX,[EAX + 0x100]
LAB_1000742a:
  1000742a  CMP EAX,ECX
  1000742c  JNC 0x10007446    ; LAB_10007446
  1000742e  AND byte ptr [EAX + 0x4],0x0
  10007432  OR dword ptr [EAX],0xffffffff
  10007435  MOV byte ptr [EAX + 0x5],0xa
  10007439  MOV ECX,dword ptr [EDI]    ; DAT_10010aa4
  1000743b  ADD EAX,0x8
  1000743e  ADD ECX,0x100
  10007444  JMP 0x1000742a    ; LAB_1000742a
LAB_10007446:
  10007446  ADD EDI,0x4
  10007449  CMP dword ptr [0x10010ba0],ESI    ; DAT_10010ba0
  1000744f  JL 0x1000740c    ; LAB_1000740c
  10007451  JMP 0x10007459    ; LAB_10007459
LAB_10007453:
  10007453  MOV ESI,dword ptr [0x10010ba0]    ; DAT_10010ba0
LAB_10007459:
  10007459  XOR EDI,EDI
  1000745b  TEST ESI,ESI
  1000745d  JLE 0x100074a5    ; LAB_100074a5
LAB_1000745f:
  1000745f  MOV EAX,dword ptr [EBX]
  10007461  CMP EAX,-0x1
  10007464  JZ 0x1000749c    ; LAB_1000749c
  10007466  MOV CL,byte ptr [EBP]
  10007469  TEST CL,0x1
  1000746c  JZ 0x1000749c    ; LAB_1000749c
  1000746e  TEST CL,0x8
  10007471  JNZ 0x1000747e    ; LAB_1000747e
  10007473  PUSH EAX
  10007474  CALL dword ptr [0x1000d05c]    ; PTR_GetFileType_1000d05c KERNEL32.DLL::GetFileType
  1000747a  TEST EAX,EAX
  1000747c  JZ 0x1000749c    ; LAB_1000749c
LAB_1000747e:
  1000747e  MOV EAX,EDI
  10007480  MOV ECX,EDI
  10007482  SAR EAX,0x5
  10007485  AND ECX,0x1f
  10007488  MOV EAX,dword ptr [EAX*0x4 + 0x10010aa0]    ; DAT_10010aa0
  1000748f  LEA EAX,[EAX + ECX*0x8]
  10007492  MOV ECX,dword ptr [EBX]
  10007494  MOV dword ptr [EAX],ECX
  10007496  MOV CL,byte ptr [EBP]
  10007499  MOV byte ptr [EAX + 0x4],CL
LAB_1000749c:
  1000749c  INC EDI
  1000749d  INC EBP
  1000749e  ADD EBX,0x4
  100074a1  CMP EDI,ESI
  100074a3  JL 0x1000745f    ; LAB_1000745f
LAB_100074a5:
  100074a5  XOR EBX,EBX
LAB_100074a7:
  100074a7  MOV EAX,[0x10010aa0]    ; DAT_10010aa0
  100074ac  CMP dword ptr [EAX + EBX*0x8],-0x1
  100074b0  LEA ESI,[EAX + EBX*0x8]
  100074b3  JNZ 0x10007502    ; LAB_10007502
  100074b5  TEST EBX,EBX
  100074b7  MOV byte ptr [ESI + 0x4],0x81
  100074bb  JNZ 0x100074c2    ; LAB_100074c2
  100074bd  PUSH -0xa
  100074bf  POP EAX
  100074c0  JMP 0x100074cc    ; LAB_100074cc
LAB_100074c2:
  100074c2  MOV EAX,EBX
  100074c4  DEC EAX
  100074c5  NEG EAX
  100074c7  SBB EAX,EAX
  100074c9  ADD EAX,-0xb
LAB_100074cc:
  100074cc  PUSH EAX
  100074cd  CALL dword ptr [0x1000d058]    ; PTR_GetStdHandle_1000d058 KERNEL32.DLL::GetStdHandle
  100074d3  MOV EDI,EAX
  100074d5  CMP EDI,-0x1
  100074d8  JZ 0x100074f1    ; LAB_100074f1
  100074da  PUSH EDI
  100074db  CALL dword ptr [0x1000d05c]    ; PTR_GetFileType_1000d05c KERNEL32.DLL::GetFileType
  100074e1  TEST EAX,EAX
  100074e3  JZ 0x100074f1    ; LAB_100074f1
  100074e5  AND EAX,0xff
  100074ea  MOV dword ptr [ESI],EDI
  100074ec  CMP EAX,0x2
  100074ef  JNZ 0x100074f7    ; LAB_100074f7
LAB_100074f1:
  100074f1  OR byte ptr [ESI + 0x4],0x40
  100074f5  JMP 0x10007506    ; LAB_10007506
LAB_100074f7:
  100074f7  CMP EAX,0x3
  100074fa  JNZ 0x10007506    ; LAB_10007506
  100074fc  OR byte ptr [ESI + 0x4],0x8
  10007500  JMP 0x10007506    ; LAB_10007506
LAB_10007502:
  10007502  OR byte ptr [ESI + 0x4],0x80
LAB_10007506:
  10007506  INC EBX
  10007507  CMP EBX,0x3
  1000750a  JL 0x100074a7    ; LAB_100074a7
  1000750c  PUSH dword ptr [0x10010ba0]    ; DAT_10010ba0
  10007512  CALL dword ptr [0x1000d054]    ; PTR_SetHandleCount_1000d054 KERNEL32.DLL::SetHandleCount
  10007518  POP EDI
  10007519  POP ESI
  1000751a  POP EBP
  1000751b  POP EBX
  1000751c  ADD ESP,0x44
  1000751f  RET

;==== FUNCTION FUN_10007520 @ 10007520 : undefined FUN_10007520(void)
  10007520  PUSH ESI
  10007521  MOV ESI,0x10010aa0    ; DAT_10010aa0
LAB_10007526:
  10007526  MOV EAX,dword ptr [ESI]    ; DAT_10010aa0 DAT_10010aa4
  10007528  TEST EAX,EAX
  1000752a  JZ 0x10007536    ; LAB_10007536
  1000752c  PUSH EAX
  1000752d  CALL 0x10005e2a    ; FUN_10005e2a
  10007532  AND dword ptr [ESI],0x0    ; DAT_10010aa0
  10007535  POP ECX
LAB_10007536:
  10007536  ADD ESI,0x4
  10007539  CMP ESI,0x10010ba0    ; DAT_10010ba0
  1000753f  JL 0x10007526    ; LAB_10007526
  10007541  POP ESI
  10007542  RET

;==== FUNCTION FUN_10007543 @ 10007543 : undefined FUN_10007543(void)
  10007543  PUSH EBX
  10007544  XOR EBX,EBX
  10007546  CMP dword ptr [0x10010bac],EBX    ; DAT_10010bac
  1000754c  PUSH ESI
  1000754d  PUSH EDI
  1000754e  JNZ 0x10007555    ; LAB_10007555
  10007550  CALL 0x1000a4e8    ; FUN_1000a4e8
LAB_10007555:
  10007555  MOV ESI,dword ptr [0x1000f61c]    ; DAT_1000f61c
  1000755b  XOR EDI,EDI
LAB_1000755d:
  1000755d  MOV AL,byte ptr [ESI]
  1000755f  CMP AL,BL
  10007561  JZ 0x10007575    ; LAB_10007575
  10007563  CMP AL,0x3d
  10007565  JZ 0x10007568    ; LAB_10007568
  10007567  INC EDI
LAB_10007568:
  10007568  PUSH ESI
  10007569  CALL 0x100088c0    ; _strlen
  1000756e  POP ECX
  1000756f  LEA ESI,[ESI + EAX*0x1 + 0x1]
  10007573  JMP 0x1000755d    ; LAB_1000755d
LAB_10007575:
  10007575  LEA EAX,[EDI*0x4 + 0x4]
  1000757c  PUSH EAX
  1000757d  CALL 0x10005e59    ; _malloc
  10007582  MOV ESI,EAX
  10007584  POP ECX
  10007585  CMP ESI,EBX
  10007587  MOV dword ptr [0x1000f674],ESI    ; DAT_1000f674
  1000758d  JNZ 0x10007597    ; LAB_10007597
  1000758f  PUSH 0x9
  10007591  CALL 0x10005943    ; __amsg_exit
  10007596  POP ECX
LAB_10007597:
  10007597  MOV EDI,dword ptr [0x1000f61c]    ; DAT_1000f61c
  1000759d  CMP byte ptr [EDI],BL
  1000759f  JZ 0x100075da    ; LAB_100075da
  100075a1  PUSH EBP
LAB_100075a2:
  100075a2  PUSH EDI
  100075a3  CALL 0x100088c0    ; _strlen
  100075a8  MOV EBP,EAX
  100075aa  POP ECX
  100075ab  INC EBP
  100075ac  CMP byte ptr [EDI],0x3d
  100075af  JZ 0x100075d3    ; LAB_100075d3
  100075b1  PUSH EBP
  100075b2  CALL 0x10005e59    ; _malloc
  100075b7  CMP EAX,EBX
  100075b9  POP ECX
  100075ba  MOV dword ptr [ESI],EAX
  100075bc  JNZ 0x100075c6    ; LAB_100075c6
  100075be  PUSH 0x9
  100075c0  CALL 0x10005943    ; __amsg_exit
  100075c5  POP ECX
LAB_100075c6:
  100075c6  PUSH EDI
  100075c7  PUSH dword ptr [ESI]
  100075c9  CALL 0x10008290    ; FUN_10008290
  100075ce  POP ECX
  100075cf  ADD ESI,0x4
  100075d2  POP ECX
LAB_100075d3:
  100075d3  ADD EDI,EBP
  100075d5  CMP byte ptr [EDI],BL
  100075d7  JNZ 0x100075a2    ; LAB_100075a2
  100075d9  POP EBP
LAB_100075da:
  100075da  PUSH dword ptr [0x1000f61c]    ; DAT_1000f61c
  100075e0  CALL 0x10005e2a    ; FUN_10005e2a
  100075e5  POP ECX
  100075e6  MOV dword ptr [0x1000f61c],EBX    ; DAT_1000f61c
  100075ec  MOV dword ptr [ESI],EBX
  100075ee  POP EDI
  100075ef  POP ESI
  100075f0  MOV dword ptr [0x10010ba8],0x1    ; DAT_10010ba8
  100075fa  POP EBX
  100075fb  RET

;==== FUNCTION FUN_100075fc @ 100075fc : undefined FUN_100075fc(void)
  100075fc  PUSH EBP
  100075fd  MOV EBP,ESP
  100075ff  PUSH ECX
  10007600  PUSH ECX
  10007601  PUSH EBX
  10007602  XOR EBX,EBX
  10007604  CMP dword ptr [0x10010bac],EBX    ; DAT_10010bac
  1000760a  PUSH ESI
  1000760b  PUSH EDI
  1000760c  JNZ 0x10007613    ; LAB_10007613
  1000760e  CALL 0x1000a4e8    ; FUN_1000a4e8
LAB_10007613:
  10007613  MOV ESI,0x1000f698    ; DAT_1000f698
  10007618  PUSH 0x104
  1000761d  PUSH ESI    ; DAT_1000f698
  1000761e  PUSH EBX
  1000761f  CALL dword ptr [0x1000d064]    ; PTR_GetModuleFileNameA_1000d064 KERNEL32.DLL::GetModuleFileNameA
  10007625  MOV EAX,[0x10010bb8]    ; DAT_10010bb8
  1000762a  MOV dword ptr [0x1000f684],ESI    ; DAT_1000f684
  10007630  MOV EDI,ESI
  10007632  CMP byte ptr [EAX],BL
  10007634  JZ 0x10007638    ; LAB_10007638
  10007636  MOV EDI,EAX
LAB_10007638:
  10007638  LEA EAX,[EBP + -0x8]
  1000763b  PUSH EAX
  1000763c  LEA EAX,[EBP + -0x4]
  1000763f  PUSH EAX
  10007640  PUSH EBX
  10007641  PUSH EBX
  10007642  PUSH EDI    ; DAT_1000f698
  10007643  CALL 0x10007695    ; FUN_10007695
  10007648  MOV EAX,dword ptr [EBP + -0x8]
  1000764b  MOV ECX,dword ptr [EBP + -0x4]
  1000764e  LEA EAX,[EAX + ECX*0x4]
  10007651  PUSH EAX
  10007652  CALL 0x10005e59    ; _malloc
  10007657  MOV ESI,EAX
  10007659  ADD ESP,0x18
  1000765c  CMP ESI,EBX
  1000765e  JNZ 0x10007668    ; LAB_10007668
  10007660  PUSH 0x8
  10007662  CALL 0x10005943    ; __amsg_exit
  10007667  POP ECX
LAB_10007668:
  10007668  LEA EAX,[EBP + -0x8]
  1000766b  PUSH EAX
  1000766c  LEA EAX,[EBP + -0x4]
  1000766f  PUSH EAX
  10007670  MOV EAX,dword ptr [EBP + -0x4]
  10007673  LEA EAX,[ESI + EAX*0x4]
  10007676  PUSH EAX
  10007677  PUSH ESI
  10007678  PUSH EDI
  10007679  CALL 0x10007695    ; FUN_10007695
  1000767e  MOV EAX,dword ptr [EBP + -0x4]
  10007681  ADD ESP,0x14
  10007684  DEC EAX
  10007685  MOV dword ptr [0x1000f66c],ESI    ; DAT_1000f66c
  1000768b  POP EDI
  1000768c  POP ESI
  1000768d  MOV [0x1000f668],EAX    ; DAT_1000f668
  10007692  POP EBX
  10007693  LEAVE
  10007694  RET

;==== FUNCTION FUN_10007695 @ 10007695 : undefined FUN_10007695(byte * param_1, undefined4 * param_2, byte * param_3, int * param_4, int * param_5)
  10007695  PUSH EBP
  10007696  MOV EBP,ESP
  10007698  MOV ECX,dword ptr [EBP + 0x18]
  1000769b  MOV EAX,dword ptr [EBP + 0x14]
  1000769e  PUSH EBX
  1000769f  PUSH ESI
  100076a0  AND dword ptr [ECX],0x0
  100076a3  MOV ESI,dword ptr [EBP + 0x10]
  100076a6  PUSH EDI
  100076a7  MOV EDI,dword ptr [EBP + 0xc]
  100076aa  MOV dword ptr [EAX],0x1
  100076b0  MOV EAX,dword ptr [EBP + 0x8]
  100076b3  TEST EDI,EDI
  100076b5  JZ 0x100076bf    ; LAB_100076bf
  100076b7  MOV dword ptr [EDI],ESI
  100076b9  ADD EDI,0x4
  100076bc  MOV dword ptr [EBP + 0xc],EDI
LAB_100076bf:
  100076bf  CMP byte ptr [EAX],0x22
  100076c2  JNZ 0x10007708    ; LAB_10007708
LAB_100076c4:
  100076c4  MOV DL,byte ptr [EAX + 0x1]
  100076c7  INC EAX
  100076c8  CMP DL,0x22
  100076cb  JZ 0x100076f6    ; LAB_100076f6
  100076cd  TEST DL,DL
  100076cf  JZ 0x100076f6    ; LAB_100076f6
  100076d1  MOVZX EDX,DL
  100076d4  TEST byte ptr [EDX + 0x1000f961],0x4    ; DAT_1000f960+1
  100076db  JZ 0x100076e9    ; LAB_100076e9
  100076dd  INC dword ptr [ECX]
  100076df  TEST ESI,ESI
  100076e1  JZ 0x100076e9    ; LAB_100076e9
  100076e3  MOV DL,byte ptr [EAX]
  100076e5  MOV byte ptr [ESI],DL
  100076e7  INC ESI
  100076e8  INC EAX
LAB_100076e9:
  100076e9  INC dword ptr [ECX]
  100076eb  TEST ESI,ESI
  100076ed  JZ 0x100076c4    ; LAB_100076c4
  100076ef  MOV DL,byte ptr [EAX]
  100076f1  MOV byte ptr [ESI],DL
  100076f3  INC ESI
  100076f4  JMP 0x100076c4    ; LAB_100076c4
LAB_100076f6:
  100076f6  INC dword ptr [ECX]
  100076f8  TEST ESI,ESI
  100076fa  JZ 0x10007700    ; LAB_10007700
  100076fc  AND byte ptr [ESI],0x0
  100076ff  INC ESI
LAB_10007700:
  10007700  CMP byte ptr [EAX],0x22
  10007703  JNZ 0x1000774b    ; LAB_1000774b
  10007705  INC EAX
  10007706  JMP 0x1000774b    ; LAB_1000774b
LAB_10007708:
  10007708  INC dword ptr [ECX]
  1000770a  TEST ESI,ESI
  1000770c  JZ 0x10007713    ; LAB_10007713
  1000770e  MOV DL,byte ptr [EAX]
  10007710  MOV byte ptr [ESI],DL
  10007712  INC ESI
LAB_10007713:
  10007713  MOV DL,byte ptr [EAX]
  10007715  INC EAX
  10007716  MOVZX EBX,DL
  10007719  TEST byte ptr [EBX + 0x1000f961],0x4    ; DAT_1000f960+1
  10007720  JZ 0x1000772e    ; LAB_1000772e
  10007722  INC dword ptr [ECX]
  10007724  TEST ESI,ESI
  10007726  JZ 0x1000772d    ; LAB_1000772d
  10007728  MOV BL,byte ptr [EAX]
  1000772a  MOV byte ptr [ESI],BL
  1000772c  INC ESI
LAB_1000772d:
  1000772d  INC EAX
LAB_1000772e:
  1000772e  CMP DL,0x20
  10007731  JZ 0x1000773c    ; LAB_1000773c
  10007733  TEST DL,DL
  10007735  JZ 0x10007740    ; LAB_10007740
  10007737  CMP DL,0x9
  1000773a  JNZ 0x10007708    ; LAB_10007708
LAB_1000773c:
  1000773c  TEST DL,DL
  1000773e  JNZ 0x10007743    ; LAB_10007743
LAB_10007740:
  10007740  DEC EAX
  10007741  JMP 0x1000774b    ; LAB_1000774b
LAB_10007743:
  10007743  TEST ESI,ESI
  10007745  JZ 0x1000774b    ; LAB_1000774b
  10007747  AND byte ptr [ESI + -0x1],0x0
LAB_1000774b:
  1000774b  AND dword ptr [EBP + 0x18],0x0
LAB_1000774f:
  1000774f  CMP byte ptr [EAX],0x0
  10007752  JZ 0x10007838    ; LAB_10007838
LAB_10007758:
  10007758  MOV DL,byte ptr [EAX]
  1000775a  CMP DL,0x20
  1000775d  JZ 0x10007764    ; LAB_10007764
  1000775f  CMP DL,0x9
  10007762  JNZ 0x10007767    ; LAB_10007767
LAB_10007764:
  10007764  INC EAX
  10007765  JMP 0x10007758    ; LAB_10007758
LAB_10007767:
  10007767  CMP byte ptr [EAX],0x0
  1000776a  JZ 0x10007838    ; LAB_10007838
  10007770  TEST EDI,EDI
  10007772  JZ 0x1000777c    ; LAB_1000777c
  10007774  MOV dword ptr [EDI],ESI
  10007776  ADD EDI,0x4
  10007779  MOV dword ptr [EBP + 0xc],EDI
LAB_1000777c:
  1000777c  MOV EDX,dword ptr [EBP + 0x14]
  1000777f  INC dword ptr [EDX]
LAB_10007781:
  10007781  MOV dword ptr [EBP + 0x8],0x1
  10007788  XOR EBX,EBX
LAB_1000778a:
  1000778a  CMP byte ptr [EAX],0x5c
  1000778d  JNZ 0x10007793    ; LAB_10007793
  1000778f  INC EAX
  10007790  INC EBX
  10007791  JMP 0x1000778a    ; LAB_1000778a
LAB_10007793:
  10007793  CMP byte ptr [EAX],0x22
  10007796  JNZ 0x100077c4    ; LAB_100077c4
  10007798  TEST BL,0x1
  1000779b  JNZ 0x100077c2    ; LAB_100077c2
  1000779d  XOR EDI,EDI
  1000779f  CMP dword ptr [EBP + 0x18],EDI
  100077a2  JZ 0x100077b1    ; LAB_100077b1
  100077a4  CMP byte ptr [EAX + 0x1],0x22
  100077a8  LEA EDX,[EAX + 0x1]
  100077ab  JNZ 0x100077b1    ; LAB_100077b1
  100077ad  MOV EAX,EDX
  100077af  JMP 0x100077b4    ; LAB_100077b4
LAB_100077b1:
  100077b1  MOV dword ptr [EBP + 0x8],EDI
LAB_100077b4:
  100077b4  MOV EDI,dword ptr [EBP + 0xc]
  100077b7  XOR EDX,EDX
  100077b9  CMP dword ptr [EBP + 0x18],EDX
  100077bc  SETZ DL
  100077bf  MOV dword ptr [EBP + 0x18],EDX
LAB_100077c2:
  100077c2  SHR EBX,0x1
LAB_100077c4:
  100077c4  MOV EDX,EBX
  100077c6  DEC EBX
  100077c7  TEST EDX,EDX
  100077c9  JZ 0x100077d9    ; LAB_100077d9
  100077cb  INC EBX
LAB_100077cc:
  100077cc  TEST ESI,ESI
  100077ce  JZ 0x100077d4    ; LAB_100077d4
  100077d0  MOV byte ptr [ESI],0x5c
  100077d3  INC ESI
LAB_100077d4:
  100077d4  INC dword ptr [ECX]
  100077d6  DEC EBX
  100077d7  JNZ 0x100077cc    ; LAB_100077cc
LAB_100077d9:
  100077d9  MOV DL,byte ptr [EAX]
  100077db  TEST DL,DL
  100077dd  JZ 0x10007829    ; LAB_10007829
  100077df  CMP dword ptr [EBP + 0x18],0x0
  100077e3  JNZ 0x100077ef    ; LAB_100077ef
  100077e5  CMP DL,0x20
  100077e8  JZ 0x10007829    ; LAB_10007829
  100077ea  CMP DL,0x9
  100077ed  JZ 0x10007829    ; LAB_10007829
LAB_100077ef:
  100077ef  CMP dword ptr [EBP + 0x8],0x0
  100077f3  JZ 0x10007823    ; LAB_10007823
  100077f5  TEST ESI,ESI
  100077f7  JZ 0x10007812    ; LAB_10007812
  100077f9  MOVZX EBX,DL
  100077fc  TEST byte ptr [EBX + 0x1000f961],0x4    ; DAT_1000f960+1
  10007803  JZ 0x1000780b    ; LAB_1000780b
  10007805  MOV byte ptr [ESI],DL
  10007807  INC ESI
  10007808  INC EAX
  10007809  INC dword ptr [ECX]
LAB_1000780b:
  1000780b  MOV DL,byte ptr [EAX]
  1000780d  MOV byte ptr [ESI],DL
  1000780f  INC ESI
  10007810  JMP 0x10007821    ; LAB_10007821
LAB_10007812:
  10007812  MOVZX EDX,DL
  10007815  TEST byte ptr [EDX + 0x1000f961],0x4    ; DAT_1000f960+1
  1000781c  JZ 0x10007821    ; LAB_10007821
  1000781e  INC EAX
  1000781f  INC dword ptr [ECX]
LAB_10007821:
  10007821  INC dword ptr [ECX]
LAB_10007823:
  10007823  INC EAX
  10007824  JMP 0x10007781    ; LAB_10007781
LAB_10007829:
  10007829  TEST ESI,ESI
  1000782b  JZ 0x10007831    ; LAB_10007831
  1000782d  AND byte ptr [ESI],0x0
  10007830  INC ESI
LAB_10007831:
  10007831  INC dword ptr [ECX]
  10007833  JMP 0x1000774f    ; LAB_1000774f
LAB_10007838:
  10007838  TEST EDI,EDI
  1000783a  JZ 0x1000783f    ; LAB_1000783f
  1000783c  AND dword ptr [EDI],0x0
LAB_1000783f:
  1000783f  MOV EAX,dword ptr [EBP + 0x14]
  10007842  POP EDI
  10007843  POP ESI
  10007844  POP EBX
  10007845  INC dword ptr [EAX]
  10007847  POP EBP
  10007848  RET

;==== FUNCTION FUN_10007849 @ 10007849 : LPSTR FUN_10007849(void)
  10007849  PUSH ECX
  1000784a  PUSH ECX
  1000784b  MOV EAX,[0x1000f79c]    ; DAT_1000f79c
  10007850  PUSH EBX
  10007851  PUSH EBP
  10007852  MOV EBP,dword ptr [0x1000d078]    ; PTR_GetEnvironmentStringsW_1000d078
  10007858  PUSH ESI
  10007859  PUSH EDI
  1000785a  XOR EBX,EBX
  1000785c  XOR ESI,ESI
  1000785e  XOR EDI,EDI
  10007860  CMP EAX,EBX
  10007862  JNZ 0x10007897    ; LAB_10007897
  10007864  CALL EBP    ; KERNEL32.DLL::GetEnvironmentStringsW
  10007866  MOV ESI,EAX
  10007868  CMP ESI,EBX
  1000786a  JZ 0x10007878    ; LAB_10007878
  1000786c  MOV dword ptr [0x1000f79c],0x1    ; DAT_1000f79c
  10007876  JMP 0x100078a0    ; LAB_100078a0
LAB_10007878:
  10007878  CALL dword ptr [0x1000d074]    ; PTR_GetEnvironmentStrings_1000d074 KERNEL32.DLL::GetEnvironmentStrings
  1000787e  MOV EDI,EAX
  10007880  CMP EDI,EBX
  10007882  JZ 0x10007972    ; LAB_10007972
  10007888  MOV dword ptr [0x1000f79c],0x2    ; DAT_1000f79c
  10007892  JMP 0x10007926    ; LAB_10007926
LAB_10007897:
  10007897  CMP EAX,0x1
  1000789a  JNZ 0x10007921    ; LAB_10007921
LAB_100078a0:
  100078a0  CMP ESI,EBX
  100078a2  JNZ 0x100078b0    ; LAB_100078b0
  100078a4  CALL EBP    ; KERNEL32.DLL::GetEnvironmentStringsW
  100078a6  MOV ESI,EAX
  100078a8  CMP ESI,EBX
  100078aa  JZ 0x10007972    ; LAB_10007972
LAB_100078b0:
  100078b0  CMP word ptr [ESI],BX
  100078b3  MOV EAX,ESI
  100078b5  JZ 0x100078c5    ; LAB_100078c5
LAB_100078b7:
  100078b7  INC EAX
  100078b8  INC EAX
  100078b9  CMP word ptr [EAX],BX
  100078bc  JNZ 0x100078b7    ; LAB_100078b7
  100078be  INC EAX
  100078bf  INC EAX
  100078c0  CMP word ptr [EAX],BX
  100078c3  JNZ 0x100078b7    ; LAB_100078b7
LAB_100078c5:
  100078c5  SUB EAX,ESI
  100078c7  MOV EDI,dword ptr [0x1000d070]    ; PTR_WideCharToMultiByte_1000d070
  100078cd  SAR EAX,0x1
  100078cf  PUSH EBX
  100078d0  PUSH EBX
  100078d1  INC EAX
  100078d2  PUSH EBX
  100078d3  PUSH EBX
  100078d4  PUSH EAX
  100078d5  PUSH ESI
  100078d6  PUSH EBX
  100078d7  PUSH EBX
  100078d8  MOV dword ptr [ESP + 0x34],EAX
  100078dc  CALL EDI    ; KERNEL32.DLL::WideCharToMultiByte
  100078de  MOV EBP,EAX
  100078e0  CMP EBP,EBX
  100078e2  JZ 0x10007916    ; LAB_10007916
  100078e4  PUSH EBP
  100078e5  CALL 0x10005e59    ; _malloc
  100078ea  CMP EAX,EBX
  100078ec  POP ECX
  100078ed  MOV dword ptr [ESP + 0x10],EAX
  100078f1  JZ 0x10007916    ; LAB_10007916
  100078f3  PUSH EBX
  100078f4  PUSH EBX
  100078f5  PUSH EBP
  100078f6  PUSH EAX
  100078f7  PUSH dword ptr [ESP + 0x24]
  100078fb  PUSH ESI
  100078fc  PUSH EBX
  100078fd  PUSH EBX
  100078fe  CALL EDI    ; KERNEL32.DLL::WideCharToMultiByte
  10007900  TEST EAX,EAX
  10007902  JNZ 0x10007912    ; LAB_10007912
  10007904  PUSH dword ptr [ESP + 0x10]
  10007908  CALL 0x10005e2a    ; FUN_10005e2a
  1000790d  POP ECX
  1000790e  MOV dword ptr [ESP + 0x10],EBX
LAB_10007912:
  10007912  MOV EBX,dword ptr [ESP + 0x10]
LAB_10007916:
  10007916  PUSH ESI
  10007917  CALL dword ptr [0x1000d000]    ; PTR_FreeEnvironmentStringsW_1000d000 KERNEL32.DLL::FreeEnvironmentStringsW
  1000791d  MOV EAX,EBX
  1000791f  JMP 0x10007974    ; LAB_10007974
LAB_10007921:
  10007921  CMP EAX,0x2
  10007924  JNZ 0x10007972    ; LAB_10007972
LAB_10007926:
  10007926  CMP EDI,EBX
  10007928  JNZ 0x10007936    ; LAB_10007936
  1000792a  CALL dword ptr [0x1000d074]    ; PTR_GetEnvironmentStrings_1000d074 KERNEL32.DLL::GetEnvironmentStrings
  10007930  MOV EDI,EAX
  10007932  CMP EDI,EBX
  10007934  JZ 0x10007972    ; LAB_10007972
LAB_10007936:
  10007936  CMP byte ptr [EDI],BL
  10007938  MOV EAX,EDI
  1000793a  JZ 0x10007946    ; LAB_10007946
LAB_1000793c:
  1000793c  INC EAX
  1000793d  CMP byte ptr [EAX],BL
  1000793f  JNZ 0x1000793c    ; LAB_1000793c
  10007941  INC EAX
  10007942  CMP byte ptr [EAX],BL
  10007944  JNZ 0x1000793c    ; LAB_1000793c
LAB_10007946:
  10007946  SUB EAX,EDI
  10007948  INC EAX
  10007949  MOV EBP,EAX
  1000794b  PUSH EBP
  1000794c  CALL 0x10005e59    ; _malloc
  10007951  MOV ESI,EAX
  10007953  POP ECX
  10007954  CMP ESI,EBX
  10007956  JNZ 0x1000795c    ; LAB_1000795c
  10007958  XOR ESI,ESI
  1000795a  JMP 0x10007967    ; LAB_10007967
LAB_1000795c:
  1000795c  PUSH EBP
  1000795d  PUSH EDI
  1000795e  PUSH ESI
  1000795f  CALL 0x1000a510    ; FUN_1000a510
  10007964  ADD ESP,0xc
LAB_10007967:
  10007967  PUSH EDI
  10007968  CALL dword ptr [0x1000d068]    ; PTR_FreeEnvironmentStringsA_1000d068 KERNEL32.DLL::FreeEnvironmentStringsA
  1000796e  MOV EAX,ESI
  10007970  JMP 0x10007974    ; LAB_10007974
LAB_10007972:
  10007972  XOR EAX,EAX
LAB_10007974:
  10007974  POP EDI
  10007975  POP ESI
  10007976  POP EBP
  10007977  POP EBX
  10007978  POP ECX
  10007979  POP ECX
  1000797a  RET

;==== FUNCTION FUN_1000797b @ 1000797b : undefined FUN_1000797b(void)
  1000797b  MOV EAX,[0x1000f624]    ; DAT_1000f624
  10007980  CMP EAX,0x1
  10007983  JZ 0x10007992    ; LAB_10007992
  10007985  TEST EAX,EAX
  10007987  JNZ 0x100079b3    ; LAB_100079b3
  10007989  CMP dword ptr [0x1000f628],0x1    ; DAT_1000f628
  10007990  JNZ 0x100079b3    ; LAB_100079b3
LAB_10007992:
  10007992  PUSH 0xfc
  10007997  CALL 0x100079b4    ; FUN_100079b4
  1000799c  MOV EAX,[0x1000f7a0]    ; DAT_1000f7a0
  100079a1  POP ECX
  100079a2  TEST EAX,EAX
  100079a4  JZ 0x100079a8    ; LAB_100079a8
  100079a6  CALL EAX
LAB_100079a8:
  100079a8  PUSH 0xff
  100079ad  CALL 0x100079b4    ; FUN_100079b4
  100079b2  POP ECX
LAB_100079b3:
  100079b3  RET

;==== FUNCTION FUN_100079b4 @ 100079b4 : undefined FUN_100079b4(DWORD param_1)
  100079b4  PUSH EBP
  100079b5  MOV EBP,ESP
  100079b7  SUB ESP,0x1a4
  100079bd  MOV EDX,dword ptr [EBP + 0x8]
  100079c0  XOR ECX,ECX
  100079c2  MOV EAX,0x1000ecb0    ; DAT_1000ecb0
LAB_100079c7:
  100079c7  CMP EDX,dword ptr [EAX]    ; DAT_1000ecb0 DAT_1000ecb8
  100079c9  JZ 0x100079d6    ; LAB_100079d6
  100079cb  ADD EAX,0x8    ; DAT_1000ecc0
  100079ce  INC ECX
  100079cf  CMP EAX,0x1000ed40    ; DAT_1000ed40
  100079d4  JL 0x100079c7    ; LAB_100079c7
LAB_100079d6:
  100079d6  PUSH ESI
  100079d7  MOV ESI,ECX
  100079d9  SHL ESI,0x3
  100079dc  CMP EDX,dword ptr [ESI + 0x1000ecb0]    ; DAT_1000ecc0 DAT_1000ecb8
  100079e2  JNZ 0x10007b04    ; LAB_10007b04
  100079e8  MOV EAX,[0x1000f624]    ; DAT_1000f624
  100079ed  CMP EAX,0x1
  100079f0  JZ 0x10007ade    ; LAB_10007ade
  100079f6  TEST EAX,EAX
  100079f8  JNZ 0x10007a07    ; LAB_10007a07
  100079fa  CMP dword ptr [0x1000f628],0x1    ; DAT_1000f628
  10007a01  JZ 0x10007ade    ; LAB_10007ade
LAB_10007a07:
  10007a07  CMP EDX,0xfc
  10007a0d  JZ 0x10007b04    ; LAB_10007b04
  10007a13  LEA EAX,[EBP + 0xfffffe5c]
  10007a19  PUSH 0x104
  10007a1e  PUSH EAX
  10007a1f  PUSH 0x0
  10007a21  CALL dword ptr [0x1000d064]    ; PTR_GetModuleFileNameA_1000d064 KERNEL32.DLL::GetModuleFileNameA
  10007a27  TEST EAX,EAX
  10007a29  JNZ 0x10007a3e    ; LAB_10007a3e
  10007a2b  LEA EAX,[EBP + 0xfffffe5c]
  10007a31  PUSH 0x1000d578    ; s_<program_name_unknown>_1000d578
  10007a36  PUSH EAX
  10007a37  CALL 0x10008290    ; FUN_10008290
  10007a3c  POP ECX
  10007a3d  POP ECX
LAB_10007a3e:
  10007a3e  LEA EAX,[EBP + 0xfffffe5c]
  10007a44  PUSH EDI
  10007a45  PUSH EAX
  10007a46  LEA EDI,[EBP + 0xfffffe5c]
  10007a4c  CALL 0x100088c0    ; _strlen
  10007a51  INC EAX
  10007a52  POP ECX
  10007a53  CMP EAX,0x3c
  10007a56  JBE 0x10007a81    ; LAB_10007a81
  10007a58  LEA EAX,[EBP + 0xfffffe5c]
  10007a5e  PUSH EAX
  10007a5f  CALL 0x100088c0    ; _strlen
  10007a64  MOV EDI,EAX
  10007a66  LEA EAX,[EBP + 0xfffffe5c]
  10007a6c  SUB EAX,0x3b
  10007a6f  PUSH 0x3
  10007a71  ADD EDI,EAX
  10007a73  PUSH 0x1000d574    ; DAT_1000d574
  10007a78  PUSH EDI
  10007a79  CALL 0x1000a8d0    ; _strncpy
  10007a7e  ADD ESP,0x10
LAB_10007a81:
  10007a81  LEA EAX,[EBP + 0xffffff60]
  10007a87  PUSH 0x1000d558    ; s_Runtime_Error!_Program:_1000d558
  10007a8c  PUSH EAX
  10007a8d  CALL 0x10008290    ; FUN_10008290
  10007a92  LEA EAX,[EBP + 0xffffff60]
  10007a98  PUSH EDI
  10007a99  PUSH EAX
  10007a9a  CALL 0x100082a0    ; FUN_100082a0
  10007a9f  LEA EAX,[EBP + 0xffffff60]
  10007aa5  PUSH 0x1000d554    ; DAT_1000d554
  10007aaa  PUSH EAX
  10007aab  CALL 0x100082a0    ; FUN_100082a0
  10007ab0  PUSH dword ptr [ESI + 0x1000ecb4]    ; PTR_s_R6009_-_not_enough_space_for_env_1000ecc4 s_R6009_-_not_enough_space_for_env_1000d4ac
  10007ab6  LEA EAX,[EBP + 0xffffff60]
  10007abc  PUSH EAX
  10007abd  CALL 0x100082a0    ; FUN_100082a0
  10007ac2  PUSH 0x12010
  10007ac7  LEA EAX,[EBP + 0xffffff60]
  10007acd  PUSH 0x1000d52c    ; s_Microsoft_Visual_C++_Runtime_Lib_1000d52c
  10007ad2  PUSH EAX
  10007ad3  CALL 0x1000a845    ; FUN_1000a845
  10007ad8  ADD ESP,0x2c
  10007adb  POP EDI
  10007adc  JMP 0x10007b04    ; LAB_10007b04
LAB_10007ade:
  10007ade  LEA EAX,[EBP + 0x8]
  10007ae1  LEA ESI,[ESI + 0x1000ecb4]    ; PTR_s_R6009_-_not_enough_space_for_env_1000ecc4
  10007ae7  PUSH 0x0
  10007ae9  PUSH EAX
  10007aea  PUSH dword ptr [ESI]    ; PTR_s_R6009_-_not_enough_space_for_env_1000ecc4 s_R6009_-_not_enough_space_for_env_1000d4ac
  10007aec  CALL 0x100088c0    ; _strlen
  10007af1  POP ECX
  10007af2  PUSH EAX
  10007af3  PUSH dword ptr [ESI]    ; PTR_s_R6009_-_not_enough_space_for_env_1000ecc4 s_R6009_-_not_enough_space_for_env_1000d4ac
  10007af5  PUSH -0xc
  10007af7  CALL dword ptr [0x1000d058]    ; PTR_GetStdHandle_1000d058 KERNEL32.DLL::GetStdHandle
  10007afd  PUSH EAX
  10007afe  CALL dword ptr [0x1000d07c]    ; PTR_WriteFile_1000d07c KERNEL32.DLL::WriteFile
LAB_10007b04:
  10007b04  POP ESI
  10007b05  LEAVE
  10007b06  RET

;==== FUNCTION FUN_10007b38 @ 10007b38 : undefined FUN_10007b38(void)
  10007b38  PUSH EBP
  10007b39  MOV EBP,ESP
  10007b3b  PUSH ECX
  10007b3c  FSTSW word ptr [EBP + -0x4]
  10007b40  PUSH dword ptr [EBP + -0x4]
  10007b43  CALL 0x10007cef    ; FUN_10007cef
  10007b48  POP ECX
  10007b49  LEAVE
  10007b4a  RET

;==== FUNCTION FUN_10007b4b @ 10007b4b : undefined FUN_10007b4b(void)
  10007b4b  PUSH EBP
  10007b4c  MOV EBP,ESP
  10007b4e  PUSH ECX
  10007b4f  FNSTSW word ptr [EBP + -0x4]
  10007b52  FNCLEX
  10007b54  PUSH dword ptr [EBP + -0x4]
  10007b57  CALL 0x10007cef    ; FUN_10007cef
  10007b5c  POP ECX
  10007b5d  LEAVE
  10007b5e  RET

;==== FUNCTION FUN_10007b5f @ 10007b5f : uint FUN_10007b5f(void * this, uint param_1, uint param_2)
  10007b5f  PUSH EBP
  10007b60  MOV EBP,ESP
  10007b62  PUSH ECX
  10007b63  PUSH ESI
  10007b64  FSTCW word ptr [EBP + -0x4]
  10007b68  PUSH dword ptr [EBP + -0x4]
  10007b6b  CALL 0x10007bd4    ; FUN_10007bd4
  10007b70  MOV ESI,EAX
  10007b72  MOV EAX,dword ptr [EBP + 0xc]
  10007b75  NOT EAX
  10007b77  AND ESI,EAX
  10007b79  MOV EAX,dword ptr [EBP + 0x8]
  10007b7c  AND EAX,dword ptr [EBP + 0xc]
  10007b7f  OR ESI,EAX
  10007b81  PUSH ESI
  10007b82  CALL 0x10007c66    ; FUN_10007c66
  10007b87  POP ECX
  10007b88  MOV dword ptr [EBP + 0xc],EAX
  10007b8b  POP ECX
  10007b8c  FLDCW word ptr [EBP + 0xc]
  10007b8f  MOV EAX,ESI
  10007b91  POP ESI
  10007b92  LEAVE
  10007b93  RET

;==== FUNCTION FUN_10007b94 @ 10007b94 : undefined FUN_10007b94(void * this, uint param_1, uint param_2)
  10007b94  MOV EAX,dword ptr [ESP + 0x8]
  10007b98  AND EAX,0xfff7ffff
  10007b9d  PUSH EAX
  10007b9e  PUSH dword ptr [ESP + 0x8]
  10007ba2  CALL 0x10007b5f    ; FUN_10007b5f
  10007ba7  POP ECX
  10007ba8  POP ECX
  10007ba9  RET

;==== FUNCTION FUN_10007bd4 @ 10007bd4 : uint FUN_10007bd4(uint param_1)
  10007bd4  PUSH EBX
  10007bd5  MOV EBX,dword ptr [ESP + 0x8]
  10007bd9  XOR EAX,EAX
  10007bdb  PUSH EBP
  10007bdc  TEST BL,0x1
  10007bdf  PUSH EDI
  10007be0  JZ 0x10007be5    ; LAB_10007be5
  10007be2  PUSH 0x10
  10007be4  POP EAX
LAB_10007be5:
  10007be5  TEST BL,0x4
  10007be8  JZ 0x10007bec    ; LAB_10007bec
  10007bea  OR AL,0x8
LAB_10007bec:
  10007bec  TEST BL,0x8
  10007bef  JZ 0x10007bf3    ; LAB_10007bf3
  10007bf1  OR AL,0x4
LAB_10007bf3:
  10007bf3  TEST BL,0x10
  10007bf6  JZ 0x10007bfa    ; LAB_10007bfa
  10007bf8  OR AL,0x2
LAB_10007bfa:
  10007bfa  TEST BL,0x20
  10007bfd  JZ 0x10007c01    ; LAB_10007c01
  10007bff  OR AL,0x1
LAB_10007c01:
  10007c01  TEST BL,0x2
  10007c04  JZ 0x10007c0b    ; LAB_10007c0b
  10007c06  OR EAX,0x80000
LAB_10007c0b:
  10007c0b  MOVZX ECX,BX
  10007c0e  PUSH ESI
  10007c0f  MOV EDX,ECX
  10007c11  MOV ESI,0xc00
  10007c16  MOV EDI,0x300
  10007c1b  AND EDX,ESI
  10007c1d  MOV EBP,0x200
  10007c22  JZ 0x10007c43    ; LAB_10007c43
  10007c24  CMP EDX,0x400
  10007c2a  JZ 0x10007c40    ; LAB_10007c40
  10007c2c  CMP EDX,0x800
  10007c32  JZ 0x10007c3c    ; LAB_10007c3c
  10007c34  CMP EDX,ESI
  10007c36  JNZ 0x10007c43    ; LAB_10007c43
  10007c38  OR EAX,EDI
  10007c3a  JMP 0x10007c43    ; LAB_10007c43
LAB_10007c3c:
  10007c3c  OR EAX,EBP
  10007c3e  JMP 0x10007c43    ; LAB_10007c43
LAB_10007c40:
  10007c40  OR AH,0x1
LAB_10007c43:
  10007c43  AND ECX,EDI
  10007c45  POP ESI
  10007c46  JZ 0x10007c53    ; LAB_10007c53
  10007c48  CMP ECX,EBP
  10007c4a  JNZ 0x10007c58    ; LAB_10007c58
  10007c4c  OR EAX,0x10000
  10007c51  JMP 0x10007c58    ; LAB_10007c58
LAB_10007c53:
  10007c53  OR EAX,0x20000
LAB_10007c58:
  10007c58  POP EDI
  10007c59  POP EBP
  10007c5a  TEST BH,0x10
  10007c5d  POP EBX
  10007c5e  JZ 0x10007c65    ; LAB_10007c65
  10007c60  OR EAX,0x40000
LAB_10007c65:
  10007c65  RET

;==== FUNCTION FUN_10007c66 @ 10007c66 : uint FUN_10007c66(uint param_1)
  10007c66  PUSH EBX
  10007c67  MOV EBX,dword ptr [ESP + 0x8]
  10007c6b  XOR EAX,EAX
  10007c6d  PUSH ESI
  10007c6e  TEST BL,0x10
  10007c71  JZ 0x10007c76    ; LAB_10007c76
  10007c73  PUSH 0x1
  10007c75  POP EAX
LAB_10007c76:
  10007c76  TEST BL,0x8
  10007c79  JZ 0x10007c7d    ; LAB_10007c7d
  10007c7b  OR AL,0x4
LAB_10007c7d:
  10007c7d  TEST BL,0x4
  10007c80  JZ 0x10007c84    ; LAB_10007c84
  10007c82  OR AL,0x8
LAB_10007c84:
  10007c84  TEST BL,0x2
  10007c87  JZ 0x10007c8b    ; LAB_10007c8b
  10007c89  OR AL,0x10
LAB_10007c8b:
  10007c8b  TEST BL,0x1
  10007c8e  JZ 0x10007c92    ; LAB_10007c92
  10007c90  OR AL,0x20
LAB_10007c92:
  10007c92  TEST EBX,0x80000
  10007c98  JZ 0x10007c9c    ; LAB_10007c9c
  10007c9a  OR AL,0x2
LAB_10007c9c:
  10007c9c  MOV ECX,EBX
  10007c9e  MOV EDX,0x300
  10007ca3  AND ECX,EDX
  10007ca5  MOV ESI,0x200
  10007caa  JZ 0x10007cc9    ; LAB_10007cc9
  10007cac  CMP ECX,0x100
  10007cb2  JZ 0x10007cc6    ; LAB_10007cc6
  10007cb4  CMP ECX,ESI
  10007cb6  JZ 0x10007cc1    ; LAB_10007cc1
  10007cb8  CMP ECX,EDX
  10007cba  JNZ 0x10007cc9    ; LAB_10007cc9
  10007cbc  OR AH,0xc
  10007cbf  JMP 0x10007cc9    ; LAB_10007cc9
LAB_10007cc1:
  10007cc1  OR AH,0x8
  10007cc4  JMP 0x10007cc9    ; LAB_10007cc9
LAB_10007cc6:
  10007cc6  OR AH,0x4
LAB_10007cc9:
  10007cc9  MOV ECX,EBX
  10007ccb  AND ECX,0x30000
  10007cd1  JZ 0x10007cdf    ; LAB_10007cdf
  10007cd3  CMP ECX,0x10000
  10007cd9  JNZ 0x10007ce1    ; LAB_10007ce1
  10007cdb  OR EAX,ESI
  10007cdd  JMP 0x10007ce1    ; LAB_10007ce1
LAB_10007cdf:
  10007cdf  OR EAX,EDX
LAB_10007ce1:
  10007ce1  POP ESI
  10007ce2  TEST EBX,0x40000
  10007ce8  POP EBX
  10007ce9  JZ 0x10007cee    ; LAB_10007cee
  10007ceb  OR AH,0x10
LAB_10007cee:
  10007cee  RET

;==== FUNCTION FUN_10007cef @ 10007cef : uint FUN_10007cef(byte param_1)
  10007cef  MOV CL,byte ptr [ESP + 0x4]
  10007cf3  XOR EAX,EAX
  10007cf5  TEST CL,0x1
  10007cf8  JZ 0x10007cfd    ; LAB_10007cfd
  10007cfa  PUSH 0x10
  10007cfc  POP EAX
LAB_10007cfd:
  10007cfd  TEST CL,0x4
  10007d00  JZ 0x10007d04    ; LAB_10007d04
  10007d02  OR AL,0x8
LAB_10007d04:
  10007d04  TEST CL,0x8
  10007d07  JZ 0x10007d0b    ; LAB_10007d0b
  10007d09  OR AL,0x4
LAB_10007d0b:
  10007d0b  TEST CL,0x10
  10007d0e  JZ 0x10007d12    ; LAB_10007d12
  10007d10  OR AL,0x2
LAB_10007d12:
  10007d12  TEST CL,0x20
  10007d15  JZ 0x10007d19    ; LAB_10007d19
  10007d17  OR AL,0x1
LAB_10007d19:
  10007d19  TEST CL,0x2
  10007d1c  JZ 0x10007d23    ; LAB_10007d23
  10007d1e  OR EAX,0x80000
LAB_10007d23:
  10007d23  RET

;==== FUNCTION FUN_10007d2c @ 10007d2c : uint FUN_10007d2c(void * this, uint param_1)
  10007d2c  PUSH EBP
  10007d2d  MOV EBP,ESP
  10007d2f  PUSH ECX
  10007d30  CMP dword ptr [0x1000f80c],0x0    ; DAT_1000f80c
  10007d37  PUSH EBX
  10007d38  PUSH ESI
  10007d39  PUSH EDI
  10007d3a  JNZ 0x10007d59    ; LAB_10007d59
  10007d3c  MOV EAX,dword ptr [EBP + 0x8]
  10007d3f  CMP EAX,0x41
  10007d42  JL 0x10007df2    ; LAB_10007df2
  10007d48  CMP EAX,0x5a
  10007d4b  JG 0x10007df2    ; LAB_10007df2
  10007d51  ADD EAX,0x20
  10007d54  JMP 0x10007df2    ; LAB_10007df2
LAB_10007d59:
  10007d59  MOV EBX,dword ptr [EBP + 0x8]
  10007d5c  MOV EDI,0x100
  10007d61  PUSH 0x1
  10007d63  CMP EBX,EDI
  10007d65  POP ESI
  10007d66  JGE 0x10007d8d    ; LAB_10007d8d
  10007d68  CMP dword ptr [0x1000ec94],ESI    ; DAT_1000ec94
  10007d6e  JLE 0x10007d7b    ; LAB_10007d7b
  10007d70  PUSH ESI
  10007d71  PUSH EBX
  10007d72  CALL 0x100070f8    ; FUN_100070f8
  10007d77  POP ECX
  10007d78  POP ECX
  10007d79  JMP 0x10007d85    ; LAB_10007d85
LAB_10007d7b:
  10007d7b  MOV EAX,[0x1000ea88]    ; PTR_DAT_1000ea88
  10007d80  MOV AL,byte ptr [EAX + EBX*0x2]    ; DAT_1000ea92
  10007d83  AND EAX,ESI
LAB_10007d85:
  10007d85  TEST EAX,EAX
  10007d87  JNZ 0x10007d8d    ; LAB_10007d8d
LAB_10007d89:
  10007d89  MOV EAX,EBX
  10007d8b  JMP 0x10007df2    ; LAB_10007df2
LAB_10007d8d:
  10007d8d  MOV EDX,dword ptr [0x1000ea88]    ; PTR_DAT_1000ea88
  10007d93  MOV EAX,EBX
  10007d95  SAR EAX,0x8
  10007d98  MOVZX ECX,AL
  10007d9b  TEST byte ptr [EDX + ECX*0x2 + 0x1],0x80    ; DAT_1000ea93
  10007da0  JZ 0x10007db1    ; LAB_10007db1
  10007da2  AND byte ptr [EBP + 0xa],0x0
  10007da6  PUSH 0x2
  10007da8  MOV byte ptr [EBP + 0x8],AL
  10007dab  MOV byte ptr [EBP + 0x9],BL
  10007dae  POP EAX
  10007daf  JMP 0x10007dba    ; LAB_10007dba
LAB_10007db1:
  10007db1  AND byte ptr [EBP + 0x9],0x0
  10007db5  MOV byte ptr [EBP + 0x8],BL
  10007db8  MOV EAX,ESI
LAB_10007dba:
  10007dba  PUSH ESI
  10007dbb  PUSH 0x0
  10007dbd  LEA ECX,[EBP + -0x4]
  10007dc0  PUSH 0x3
  10007dc2  PUSH ECX
  10007dc3  PUSH EAX
  10007dc4  LEA EAX,[EBP + 0x8]
  10007dc7  PUSH EAX
  10007dc8  PUSH EDI
  10007dc9  PUSH dword ptr [0x1000f80c]    ; DAT_1000f80c
  10007dcf  CALL 0x1000ab52    ; FUN_1000ab52
  10007dd4  ADD ESP,0x20
  10007dd7  TEST EAX,EAX
  10007dd9  JZ 0x10007d89    ; LAB_10007d89
  10007ddb  CMP EAX,ESI
  10007ddd  JNZ 0x10007de5    ; LAB_10007de5
  10007ddf  MOVZX EAX,byte ptr [EBP + -0x4]
  10007de3  JMP 0x10007df2    ; LAB_10007df2
LAB_10007de5:
  10007de5  MOVZX EAX,byte ptr [EBP + -0x3]
  10007de9  MOVZX ECX,byte ptr [EBP + -0x4]
  10007ded  SHL EAX,0x8
  10007df0  OR EAX,ECX
LAB_10007df2:
  10007df2  POP EDI
  10007df3  POP ESI
  10007df4  POP EBX
  10007df5  LEAVE
  10007df6  RET

;==== FUNCTION FUN_10007df7 @ 10007df7 : undefined4 FUN_10007df7(int param_1, int param_2)
  10007df7  MOV EAX,dword ptr [ESP + 0x8]
  10007dfb  PUSH ESI
  10007dfc  PUSH 0x20
  10007dfe  CDQ
  10007dff  POP ECX
  10007e00  IDIV ECX
  10007e02  PUSH 0x1f
  10007e04  MOV ESI,EAX
  10007e06  MOV EAX,dword ptr [ESP + 0x10]
  10007e0a  CDQ
  10007e0b  IDIV ECX
  10007e0d  POP ECX
  10007e0e  MOV EAX,dword ptr [ESP + 0x8]
  10007e12  SUB ECX,EDX
  10007e14  OR EDX,0xffffffff
  10007e17  SHL EDX,CL
  10007e19  NOT EDX
  10007e1b  TEST dword ptr [EAX + ESI*0x4],EDX
  10007e1e  JNZ 0x10007e3c    ; LAB_10007e3c
  10007e20  INC ESI
  10007e21  CMP ESI,0x3
  10007e24  JGE 0x10007e37    ; LAB_10007e37
  10007e26  LEA EAX,[EAX + ESI*0x4]
LAB_10007e29:
  10007e29  CMP dword ptr [EAX],0x0
  10007e2c  JNZ 0x10007e3c    ; LAB_10007e3c
  10007e2e  INC ESI
  10007e2f  ADD EAX,0x4
  10007e32  CMP ESI,0x3
  10007e35  JL 0x10007e29    ; LAB_10007e29
LAB_10007e37:
  10007e37  PUSH 0x1
  10007e39  POP EAX
  10007e3a  POP ESI
  10007e3b  RET
LAB_10007e3c:
  10007e3c  XOR EAX,EAX
  10007e3e  POP ESI
  10007e3f  RET

;==== FUNCTION FUN_10007e40 @ 10007e40 : undefined FUN_10007e40(int param_1, int param_2)
  10007e40  MOV EAX,dword ptr [ESP + 0x8]
  10007e44  PUSH EBX
  10007e45  PUSH ESI
  10007e46  PUSH EDI
  10007e47  PUSH 0x20
  10007e49  MOV EBX,dword ptr [ESP + 0x14]
  10007e4d  CDQ
  10007e4e  POP ECX
  10007e4f  IDIV ECX
  10007e51  MOV ESI,EAX
  10007e53  MOV EAX,dword ptr [ESP + 0x14]
  10007e57  CDQ
  10007e58  IDIV ECX
  10007e5a  LEA EDI,[EBX + ESI*0x4]
  10007e5d  PUSH EDI
  10007e5e  PUSH 0x1f
  10007e60  POP ECX
  10007e61  PUSH 0x1
  10007e63  POP EAX
  10007e64  SUB ECX,EDX
  10007e66  SHL EAX,CL
  10007e68  PUSH EAX
  10007e69  PUSH dword ptr [EDI]
  10007e6b  CALL 0x1000ada1    ; FUN_1000ada1
  10007e70  ADD ESP,0xc
  10007e73  DEC ESI
  10007e74  JS 0x10007e92    ; LAB_10007e92
  10007e76  LEA EDI,[EBX + ESI*0x4]
LAB_10007e79:
  10007e79  TEST EAX,EAX
  10007e7b  JZ 0x10007e92    ; LAB_10007e92
  10007e7d  PUSH EDI
  10007e7e  PUSH 0x1
  10007e80  PUSH dword ptr [EDI]
  10007e82  CALL 0x1000ada1    ; FUN_1000ada1
  10007e87  ADD ESP,0xc
  10007e8a  DEC ESI
  10007e8b  SUB EDI,0x4
  10007e8e  TEST ESI,ESI
  10007e90  JGE 0x10007e79    ; LAB_10007e79
LAB_10007e92:
  10007e92  POP EDI
  10007e93  POP ESI
  10007e94  POP EBX
  10007e95  RET

;==== FUNCTION FUN_10007e96 @ 10007e96 : undefined4 FUN_10007e96(int param_1, int param_2)
  10007e96  PUSH EBP
  10007e97  MOV EBP,ESP
  10007e99  PUSH ECX
  10007e9a  PUSH ECX
  10007e9b  MOV EAX,dword ptr [EBP + 0xc]
  10007e9e  PUSH EBX
  10007e9f  PUSH ESI
  10007ea0  PUSH EDI
  10007ea1  LEA EDI,[EAX + -0x1]
  10007ea4  PUSH 0x20
  10007ea6  POP ECX
  10007ea7  AND dword ptr [EBP + -0x4],0x0
  10007eab  LEA EBX,[EDI + 0x1]
  10007eae  PUSH 0x20
  10007eb0  MOV EAX,EBX
  10007eb2  POP ESI
  10007eb3  CDQ
  10007eb4  IDIV ECX
  10007eb6  PUSH 0x1f
  10007eb8  MOV ECX,EAX
  10007eba  MOV EAX,EBX
  10007ebc  CDQ
  10007ebd  IDIV ESI
  10007ebf  MOV EAX,dword ptr [EBP + 0x8]
  10007ec2  POP ESI
  10007ec3  PUSH 0x1
  10007ec5  MOV dword ptr [EBP + -0x8],ECX
  10007ec8  LEA EAX,[EAX + ECX*0x4]
  10007ecb  MOV dword ptr [EBP + 0xc],EAX
  10007ece  SUB ESI,EDX
  10007ed0  POP EDX
  10007ed1  MOV ECX,ESI
  10007ed3  SHL EDX,CL
  10007ed5  TEST dword ptr [EAX],EDX
  10007ed7  JZ 0x10007efa    ; LAB_10007efa
  10007ed9  INC EBX
  10007eda  PUSH EBX
  10007edb  PUSH dword ptr [EBP + 0x8]
  10007ede  CALL 0x10007df7    ; FUN_10007df7
  10007ee3  POP ECX
  10007ee4  TEST EAX,EAX
  10007ee6  POP ECX
  10007ee7  JNZ 0x10007ef7    ; LAB_10007ef7
  10007ee9  PUSH EDI
  10007eea  PUSH dword ptr [EBP + 0x8]
  10007eed  CALL 0x10007e40    ; FUN_10007e40
  10007ef2  POP ECX
  10007ef3  MOV dword ptr [EBP + -0x4],EAX
  10007ef6  POP ECX
LAB_10007ef7:
  10007ef7  MOV EAX,dword ptr [EBP + 0xc]
LAB_10007efa:
  10007efa  OR EDX,0xffffffff
  10007efd  MOV ECX,ESI
  10007eff  SHL EDX,CL
  10007f01  PUSH 0x3
  10007f03  POP ECX
  10007f04  AND dword ptr [EAX],EDX
  10007f06  MOV EAX,dword ptr [EBP + -0x8]
  10007f09  INC EAX
  10007f0a  CMP EAX,ECX
  10007f0c  JGE 0x10007f1a    ; LAB_10007f1a
  10007f0e  MOV EDX,dword ptr [EBP + 0x8]
  10007f11  SUB ECX,EAX
  10007f13  LEA EDI,[EDX + EAX*0x4]
  10007f16  XOR EAX,EAX
  10007f18  STOSD.REP ES:EDI
LAB_10007f1a:
  10007f1a  MOV EAX,dword ptr [EBP + -0x4]
  10007f1d  POP EDI
  10007f1e  POP ESI
  10007f1f  POP EBX
  10007f20  LEAVE
  10007f21  RET

;==== FUNCTION FUN_10007f22 @ 10007f22 : undefined FUN_10007f22(int param_1, undefined4 * param_2)
  10007f22  MOV EAX,dword ptr [ESP + 0x8]
  10007f26  MOV ECX,dword ptr [ESP + 0x4]
  10007f2a  PUSH ESI
  10007f2b  PUSH 0x3
  10007f2d  SUB ECX,EAX
  10007f2f  POP EDX
LAB_10007f30:
  10007f30  MOV ESI,dword ptr [EAX]
  10007f32  MOV dword ptr [ECX + EAX*0x1],ESI
  10007f35  ADD EAX,0x4
  10007f38  DEC EDX
  10007f39  JNZ 0x10007f30    ; LAB_10007f30
  10007f3b  POP ESI
  10007f3c  RET

;==== FUNCTION FUN_10007f3d @ 10007f3d : undefined FUN_10007f3d(undefined4 * param_1)
  10007f3d  PUSH EDI
  10007f3e  MOV EDI,dword ptr [ESP + 0x8]
  10007f42  XOR EAX,EAX
  10007f44  STOSD ES:EDI
  10007f45  STOSD ES:EDI
  10007f46  STOSD ES:EDI
  10007f47  POP EDI
  10007f48  RET

;==== FUNCTION FUN_10007f49 @ 10007f49 : undefined4 FUN_10007f49(int * param_1)
  10007f49  MOV EAX,dword ptr [ESP + 0x4]
  10007f4d  XOR ECX,ECX
LAB_10007f4f:
  10007f4f  CMP dword ptr [EAX],0x0
  10007f52  JNZ 0x10007f61    ; LAB_10007f61
  10007f54  INC ECX
  10007f55  ADD EAX,0x4
  10007f58  CMP ECX,0x3
  10007f5b  JL 0x10007f4f    ; LAB_10007f4f
  10007f5d  PUSH 0x1
  10007f5f  POP EAX
  10007f60  RET
LAB_10007f61:
  10007f61  XOR EAX,EAX
  10007f63  RET

;==== FUNCTION FUN_10007f64 @ 10007f64 : undefined FUN_10007f64(uint * param_1, uint param_2)
  10007f64  PUSH EBP
  10007f65  MOV EBP,ESP
  10007f67  SUB ESP,0xc
  10007f6a  MOV EAX,dword ptr [EBP + 0xc]
  10007f6d  PUSH EBX
  10007f6e  PUSH ESI
  10007f6f  PUSH EDI
  10007f70  PUSH 0x20
  10007f72  MOV EDI,dword ptr [EBP + 0x8]
  10007f75  POP EBX
  10007f76  OR ESI,0xffffffff
  10007f79  CDQ
  10007f7a  MOV ECX,EBX
  10007f7c  MOV dword ptr [EBP + -0x4],0x3
  10007f83  IDIV ECX
  10007f85  MOV dword ptr [EBP + -0xc],EAX
  10007f88  MOV EAX,dword ptr [EBP + 0xc]
  10007f8b  CDQ
  10007f8c  IDIV ECX
  10007f8e  AND dword ptr [EBP + 0xc],0x0
  10007f92  MOV ECX,EDX
  10007f94  SHL ESI,CL
  10007f96  SUB EBX,EDX
  10007f98  NOT ESI
LAB_10007f9a:
  10007f9a  MOV EAX,dword ptr [EDI]
  10007f9c  MOV ECX,EAX
  10007f9e  AND ECX,ESI
  10007fa0  MOV dword ptr [EBP + -0x8],ECX
  10007fa3  MOV ECX,EDX
  10007fa5  SHR EAX,CL
  10007fa7  OR EAX,dword ptr [EBP + 0xc]
  10007faa  MOV dword ptr [EDI],EAX
  10007fac  MOV EAX,dword ptr [EBP + -0x8]
  10007faf  MOV ECX,EBX
  10007fb1  ADD EDI,0x4
  10007fb4  SHL EAX,CL
  10007fb6  DEC dword ptr [EBP + -0x4]
  10007fb9  MOV dword ptr [EBP + 0xc],EAX
  10007fbc  JNZ 0x10007f9a    ; LAB_10007f9a
  10007fbe  MOV EDI,dword ptr [EBP + -0xc]
  10007fc1  PUSH 0x2
  10007fc3  POP EBX
  10007fc4  MOV ESI,EDI
  10007fc6  PUSH 0x8
  10007fc8  POP ECX
  10007fc9  SHL ESI,0x2
LAB_10007fcc:
  10007fcc  CMP EBX,EDI
  10007fce  JL 0x10007fdf    ; LAB_10007fdf
  10007fd0  MOV EDX,dword ptr [EBP + 0x8]
  10007fd3  MOV EAX,ECX
  10007fd5  SUB EAX,ESI
  10007fd7  MOV EAX,dword ptr [EAX + EDX*0x1]
  10007fda  MOV dword ptr [ECX + EDX*0x1],EAX
  10007fdd  JMP 0x10007fe6    ; LAB_10007fe6
LAB_10007fdf:
  10007fdf  MOV EAX,dword ptr [EBP + 0x8]
  10007fe2  AND dword ptr [ECX + EAX*0x1],0x0
LAB_10007fe6:
  10007fe6  DEC EBX
  10007fe7  SUB ECX,0x4
  10007fea  JNS 0x10007fcc    ; LAB_10007fcc
  10007fec  POP EDI
  10007fed  POP ESI
  10007fee  POP EBX
  10007fef  LEAVE
  10007ff0  RET

;==== FUNCTION FUN_10007ff1 @ 10007ff1 : undefined4 FUN_10007ff1(ushort * param_1, uint * param_2, int * param_3)
  10007ff1  PUSH EBP
  10007ff2  MOV EBP,ESP
  10007ff4  SUB ESP,0x18
  10007ff7  MOV EAX,dword ptr [EBP + 0x8]
  10007ffa  PUSH EBX
  10007ffb  PUSH ESI
  10007ffc  PUSH EDI
  10007ffd  MOVZX ECX,word ptr [EAX + 0xa]
  10008001  MOV EBX,ECX
  10008003  AND ECX,0x8000
  10008009  MOV dword ptr [EBP + 0x8],ECX
  1000800c  MOV ECX,dword ptr [EAX + 0x6]
  1000800f  MOV dword ptr [EBP + -0xc],ECX
  10008012  MOV ECX,dword ptr [EAX + 0x2]
  10008015  MOVZX EAX,word ptr [EAX]
  10008018  MOV EDI,dword ptr [EBP + 0x10]
  1000801b  AND EBX,0x7fff
  10008021  SUB EBX,0x3fff
  10008027  MOV dword ptr [EBP + -0x8],ECX
  1000802a  SHL EAX,0x10
  1000802d  CMP EBX,0xffffc001
  10008033  MOV dword ptr [EBP + -0x4],EAX
  10008036  JNZ 0x1000805e    ; LAB_1000805e
  10008038  LEA EAX,[EBP + -0xc]
  1000803b  XOR ESI,ESI
  1000803d  PUSH EAX
  1000803e  CALL 0x10007f49    ; FUN_10007f49
  10008043  TEST EAX,EAX
  10008045  POP ECX
  10008046  JNZ 0x1000811d    ; LAB_1000811d
  1000804c  LEA EAX,[EBP + -0xc]
  1000804f  PUSH EAX
  10008050  CALL 0x10007f3d    ; FUN_10007f3d
  10008055  POP ECX
LAB_10008056:
  10008056  PUSH 0x2
LAB_10008058:
  10008058  POP EAX
  10008059  JMP 0x1000811f    ; LAB_1000811f
LAB_1000805e:
  1000805e  LEA EAX,[EBP + -0xc]
  10008061  PUSH EAX
  10008062  LEA EAX,[EBP + -0x18]
  10008065  PUSH EAX
  10008066  CALL 0x10007f22    ; FUN_10007f22
  1000806b  PUSH dword ptr [EDI + 0x8]
  1000806e  LEA EAX,[EBP + -0xc]
  10008071  PUSH EAX
  10008072  CALL 0x10007e96    ; FUN_10007e96
  10008077  ADD ESP,0x10
  1000807a  TEST EAX,EAX
  1000807c  JZ 0x1000807f    ; LAB_1000807f
  1000807e  INC EBX
LAB_1000807f:
  1000807f  MOV EAX,dword ptr [EDI + 0x4]
  10008082  MOV ECX,EAX
  10008084  SUB ECX,dword ptr [EDI + 0x8]
  10008087  CMP EBX,ECX
  10008089  JGE 0x10008097    ; LAB_10008097
  1000808b  LEA EAX,[EBP + -0xc]
  1000808e  PUSH EAX
  1000808f  CALL 0x10007f3d    ; FUN_10007f3d
  10008094  POP ECX
  10008095  JMP 0x100080d3    ; LAB_100080d3
LAB_10008097:
  10008097  CMP EBX,EAX
  10008099  JG 0x100080da    ; LAB_100080da
  1000809b  SUB EAX,EBX
  1000809d  MOV ESI,EAX
  1000809f  LEA EAX,[EBP + -0x18]
  100080a2  PUSH EAX
  100080a3  LEA EAX,[EBP + -0xc]
  100080a6  PUSH EAX
  100080a7  CALL 0x10007f22    ; FUN_10007f22
  100080ac  LEA EAX,[EBP + -0xc]
  100080af  PUSH ESI
  100080b0  PUSH EAX
  100080b1  CALL 0x10007f64    ; FUN_10007f64
  100080b6  PUSH dword ptr [EDI + 0x8]
  100080b9  LEA EAX,[EBP + -0xc]
  100080bc  PUSH EAX
  100080bd  CALL 0x10007e96    ; FUN_10007e96
  100080c2  MOV EAX,dword ptr [EDI + 0xc]
  100080c5  INC EAX
  100080c6  PUSH EAX
  100080c7  LEA EAX,[EBP + -0xc]
  100080ca  PUSH EAX
  100080cb  CALL 0x10007f64    ; FUN_10007f64
  100080d0  ADD ESP,0x20
LAB_100080d3:
  100080d3  XOR ESI,ESI
  100080d5  JMP 0x10008056    ; LAB_10008056
LAB_100080da:
  100080da  CMP EBX,dword ptr [EDI]
  100080dc  JL 0x10008106    ; LAB_10008106
  100080de  LEA EAX,[EBP + -0xc]
  100080e1  PUSH EAX
  100080e2  CALL 0x10007f3d    ; FUN_10007f3d
  100080e7  PUSH dword ptr [EDI + 0xc]
  100080ea  OR byte ptr [EBP + -0x9],0x80
  100080ee  LEA EAX,[EBP + -0xc]
  100080f1  PUSH EAX
  100080f2  CALL 0x10007f64    ; FUN_10007f64
  100080f7  MOV ESI,dword ptr [EDI + 0x14]
  100080fa  ADD ESP,0xc
  100080fd  ADD ESI,dword ptr [EDI]
  100080ff  PUSH 0x1
  10008101  JMP 0x10008058    ; LAB_10008058
LAB_10008106:
  10008106  PUSH dword ptr [EDI + 0xc]
  10008109  MOV ESI,dword ptr [EDI + 0x14]
  1000810c  AND byte ptr [EBP + -0x9],0x7f
  10008110  LEA EAX,[EBP + -0xc]
  10008113  PUSH EAX
  10008114  ADD ESI,EBX
  10008116  CALL 0x10007f64    ; FUN_10007f64
  1000811b  POP ECX
  1000811c  POP ECX
LAB_1000811d:
  1000811d  XOR EAX,EAX
LAB_1000811f:
  1000811f  PUSH 0x1f
  10008121  POP ECX
  10008122  SUB ECX,dword ptr [EDI + 0xc]
  10008125  MOV EDI,dword ptr [EDI + 0x10]
  10008128  SHL ESI,CL
  1000812a  MOV ECX,dword ptr [EBP + 0x8]
  1000812d  NEG ECX
  1000812f  SBB ECX,ECX
  10008131  AND ECX,0x80000000
  10008137  OR ESI,ECX
  10008139  OR ESI,dword ptr [EBP + -0xc]
  1000813c  CMP EDI,0x40
  1000813f  JNZ 0x1000814e    ; LAB_1000814e
  10008141  MOV ECX,dword ptr [EBP + 0xc]
  10008144  MOV EDX,dword ptr [EBP + -0x8]
  10008147  MOV dword ptr [ECX + 0x4],ESI
  1000814a  MOV dword ptr [ECX],EDX
  1000814c  JMP 0x10008158    ; LAB_10008158
LAB_1000814e:
  1000814e  CMP EDI,0x20
  10008151  JNZ 0x10008158    ; LAB_10008158
  10008153  MOV ECX,dword ptr [EBP + 0xc]
  10008156  MOV dword ptr [ECX],ESI
LAB_10008158:
  10008158  POP EDI
  10008159  POP ESI
  1000815a  POP EBX
  1000815b  LEAVE
  1000815c  RET

;==== FUNCTION FUN_1000815d @ 1000815d : undefined FUN_1000815d(ushort * param_1, uint * param_2)
  1000815d  PUSH 0x1000ed40    ; DAT_1000ed40
  10008162  PUSH dword ptr [ESP + 0xc]
  10008166  PUSH dword ptr [ESP + 0xc]
  1000816a  CALL 0x10007ff1    ; FUN_10007ff1
  1000816f  ADD ESP,0xc
  10008172  RET

;==== FUNCTION FUN_10008173 @ 10008173 : undefined FUN_10008173(ushort * param_1, uint * param_2)
  10008173  PUSH 0x1000ed58    ; DAT_1000ed58
  10008178  PUSH dword ptr [ESP + 0xc]
  1000817c  PUSH dword ptr [ESP + 0xc]
  10008180  CALL 0x10007ff1    ; FUN_10007ff1
  10008185  ADD ESP,0xc
  10008188  RET

;==== FUNCTION FUN_10008189 @ 10008189 : undefined4 FUN_10008189(ushort * param_1, undefined4 * param_2)
  10008189  PUSH EBP
  1000818a  MOV EBP,ESP
  1000818c  SUB ESP,0x10
  1000818f  MOV EAX,dword ptr [EBP + 0x8]
  10008192  PUSH ESI
  10008193  PUSH EDI
  10008194  AND dword ptr [EBP + -0x4],0x0
  10008198  MOV CX,word ptr [EAX + 0xa]
  1000819c  PUSH 0x40
  1000819e  MOV ESI,ECX
  100081a0  AND ECX,0x8000
  100081a6  MOV EDI,ECX
  100081a8  MOV ECX,dword ptr [EAX + 0x6]
  100081ab  MOV dword ptr [EBP + -0x10],ECX
  100081ae  MOV ECX,dword ptr [EAX + 0x2]
  100081b1  MOVZX EAX,word ptr [EAX]
  100081b4  SHL EAX,0x10
  100081b7  MOV dword ptr [EBP + -0x8],EAX
  100081ba  LEA EAX,[EBP + -0x10]
  100081bd  PUSH EAX
  100081be  AND ESI,0x7fff
  100081c4  MOV dword ptr [EBP + -0xc],ECX
  100081c7  CALL 0x10007e96    ; FUN_10007e96
  100081cc  POP ECX
  100081cd  TEST EAX,EAX
  100081cf  POP ECX
  100081d0  JZ 0x100081da    ; LAB_100081da
  100081d2  MOV ECX,0x80000000
  100081d7  INC ESI
  100081d8  JMP 0x100081dd    ; LAB_100081dd
LAB_100081da:
  100081da  MOV ECX,dword ptr [EBP + -0x10]
LAB_100081dd:
  100081dd  CMP SI,0x7fff
  100081e2  JNZ 0x100081eb    ; LAB_100081eb
  100081e4  MOV dword ptr [EBP + -0x4],0x1
LAB_100081eb:
  100081eb  MOV EAX,dword ptr [EBP + 0xc]
  100081ee  OR EDI,ESI
  100081f0  MOV dword ptr [EAX + 0x4],ECX
  100081f3  MOV ECX,dword ptr [EBP + -0xc]
  100081f6  MOV word ptr [EAX + 0x8],DI
  100081fa  MOV dword ptr [EAX],ECX
  100081fc  MOV EAX,dword ptr [EBP + -0x4]
  100081ff  POP EDI
  10008200  POP ESI
  10008201  LEAVE
  10008202  RET

;==== FUNCTION FUN_10008203 @ 10008203 : undefined FUN_10008203(void * this, uint * param_1, byte * param_2)
  10008203  PUSH EBP
  10008204  MOV EBP,ESP
  10008206  SUB ESP,0xc
  10008209  XOR EAX,EAX
  1000820b  PUSH EAX
  1000820c  PUSH EAX
  1000820d  PUSH EAX
  1000820e  PUSH EAX
  1000820f  PUSH dword ptr [EBP + 0xc]
  10008212  LEA EAX,[EBP + 0xc]
  10008215  PUSH EAX
  10008216  LEA EAX,[EBP + -0xc]
  10008219  PUSH EAX
  1000821a  CALL 0x1000af42    ; FUN_1000af42
  1000821f  PUSH dword ptr [EBP + 0x8]
  10008222  LEA EAX,[EBP + -0xc]
  10008225  PUSH EAX
  10008226  CALL 0x1000815d    ; FUN_1000815d
  1000822b  ADD ESP,0x24
  1000822e  LEAVE
  1000822f  RET

;==== FUNCTION FUN_10008230 @ 10008230 : undefined FUN_10008230(void * this, undefined4 * param_1, byte * param_2)
  10008230  PUSH EBP
  10008231  MOV EBP,ESP
  10008233  SUB ESP,0xc
  10008236  XOR EAX,EAX
  10008238  PUSH EAX
  10008239  PUSH EAX
  1000823a  PUSH EAX
  1000823b  PUSH 0x1
  1000823d  PUSH dword ptr [EBP + 0xc]
  10008240  LEA EAX,[EBP + 0xc]
  10008243  PUSH EAX
  10008244  LEA EAX,[EBP + -0xc]
  10008247  PUSH EAX
  10008248  CALL 0x1000af42    ; FUN_1000af42
  1000824d  PUSH dword ptr [EBP + 0x8]
  10008250  LEA EAX,[EBP + -0xc]
  10008253  PUSH EAX
  10008254  CALL 0x10008189    ; FUN_10008189
  10008259  ADD ESP,0x24
  1000825c  LEAVE
  1000825d  RET

;==== FUNCTION FUN_1000825e @ 1000825e : undefined FUN_1000825e(void * this, uint * param_1, byte * param_2)
  1000825e  PUSH EBP
  1000825f  MOV EBP,ESP
  10008261  SUB ESP,0xc
  10008264  XOR EAX,EAX
  10008266  PUSH EAX
  10008267  PUSH EAX
  10008268  PUSH EAX
  10008269  PUSH EAX
  1000826a  PUSH dword ptr [EBP + 0xc]
  1000826d  LEA EAX,[EBP + 0xc]
  10008270  PUSH EAX
  10008271  LEA EAX,[EBP + -0xc]
  10008274  PUSH EAX
  10008275  CALL 0x1000af42    ; FUN_1000af42
  1000827a  PUSH dword ptr [EBP + 0x8]
  1000827d  LEA EAX,[EBP + -0xc]
  10008280  PUSH EAX
  10008281  CALL 0x10008173    ; FUN_10008173
  10008286  ADD ESP,0x24
  10008289  LEAVE
  1000828a  RET

;==== FUNCTION FUN_10008290 @ 10008290 : uint * FUN_10008290(uint * param_1, uint * param_2)
  10008290  PUSH EDI
  10008291  MOV EDI,dword ptr [ESP + 0x8]
  10008295  JMP 0x10008301    ; LAB_10008301

;==== FUNCTION FUN_100082a0 @ 100082a0 : uint * FUN_100082a0(uint * param_1, uint * param_2)
  100082a0  MOV ECX,dword ptr [ESP + 0x4]
  100082a4  PUSH EDI
  100082a5  TEST ECX,0x3
  100082ab  JZ 0x100082bc    ; LAB_100082bc
LAB_100082ad:
  100082ad  MOV AL,byte ptr [ECX]
  100082af  INC ECX
  100082b0  TEST AL,AL
  100082b2  JZ 0x100082ef    ; LAB_100082ef
  100082b4  TEST ECX,0x3
  100082ba  JNZ 0x100082ad    ; LAB_100082ad
LAB_100082bc:
  100082bc  MOV EAX,dword ptr [ECX]
  100082be  MOV EDX,0x7efefeff
  100082c3  ADD EDX,EAX
  100082c5  XOR EAX,0xffffffff
  100082c8  XOR EAX,EDX
  100082ca  ADD ECX,0x4
  100082cd  TEST EAX,0x81010100
  100082d2  JZ 0x100082bc    ; LAB_100082bc
  100082d4  MOV EAX,dword ptr [ECX + -0x4]
  100082d7  TEST AL,AL
  100082d9  JZ 0x100082fe    ; LAB_100082fe
  100082db  TEST AH,AH
  100082dd  JZ 0x100082f9    ; LAB_100082f9
  100082df  TEST EAX,0xff0000
  100082e4  JZ 0x100082f4    ; LAB_100082f4
  100082e6  TEST EAX,0xff000000
  100082eb  JZ 0x100082ef    ; LAB_100082ef
  100082ed  JMP 0x100082bc    ; LAB_100082bc
LAB_100082ef:
  100082ef  LEA EDI,[ECX + -0x1]
  100082f2  JMP 0x10008301    ; LAB_10008301
LAB_100082f4:
  100082f4  LEA EDI,[ECX + -0x2]
  100082f7  JMP 0x10008301    ; LAB_10008301
LAB_100082f9:
  100082f9  LEA EDI,[ECX + -0x3]
  100082fc  JMP 0x10008301    ; LAB_10008301
LAB_100082fe:
  100082fe  LEA EDI,[ECX + -0x4]
LAB_10008301:
  10008301  MOV ECX,dword ptr [ESP + 0xc]
  10008305  TEST ECX,0x3
  1000830b  JZ 0x10008326    ; LAB_10008326
LAB_1000830d:
  1000830d  MOV DL,byte ptr [ECX]
  1000830f  INC ECX
  10008310  TEST DL,DL
  10008312  JZ 0x10008378    ; LAB_10008378
  10008314  MOV byte ptr [EDI],DL
  10008316  INC EDI
  10008317  TEST ECX,0x3
  1000831d  JNZ 0x1000830d    ; LAB_1000830d
  1000831f  JMP 0x10008326    ; LAB_10008326
LAB_10008321:
  10008321  MOV dword ptr [EDI],EDX
  10008323  ADD EDI,0x4
LAB_10008326:
  10008326  MOV EDX,0x7efefeff
  1000832b  MOV EAX,dword ptr [ECX]
  1000832d  ADD EDX,EAX
  1000832f  XOR EAX,0xffffffff
  10008332  XOR EAX,EDX
  10008334  MOV EDX,dword ptr [ECX]
  10008336  ADD ECX,0x4
  10008339  TEST EAX,0x81010100
  1000833e  JZ 0x10008321    ; LAB_10008321
  10008340  TEST DL,DL
  10008342  JZ 0x10008378    ; LAB_10008378
  10008344  TEST DH,DH
  10008346  JZ 0x1000836f    ; LAB_1000836f
  10008348  TEST EDX,0xff0000
  1000834e  JZ 0x10008362    ; LAB_10008362
  10008350  TEST EDX,0xff000000
  10008356  JZ 0x1000835a    ; LAB_1000835a
  10008358  JMP 0x10008321    ; LAB_10008321
LAB_1000835a:
  1000835a  MOV dword ptr [EDI],EDX
  1000835c  MOV EAX,dword ptr [ESP + 0x8]
  10008360  POP EDI
  10008361  RET
LAB_10008362:
  10008362  MOV word ptr [EDI],DX
  10008365  MOV EAX,dword ptr [ESP + 0x8]
  10008369  MOV byte ptr [EDI + 0x2],0x0
  1000836d  POP EDI
  1000836e  RET
LAB_1000836f:
  1000836f  MOV word ptr [EDI],DX
  10008372  MOV EAX,dword ptr [ESP + 0x8]
  10008376  POP EDI
  10008377  RET
LAB_10008378:
  10008378  MOV byte ptr [EDI],DL
  1000837a  MOV EAX,dword ptr [ESP + 0x8]
  1000837e  POP EDI
  1000837f  RET

;==== FUNCTION FUN_10008380 @ 10008380 : undefined FUN_10008380(char * param_1, int param_2, int param_3)
  10008380  PUSH EBP
  10008381  MOV EBP,ESP
  10008383  MOV EDX,dword ptr [EBP + 0x10]
  10008386  PUSH EBX
  10008387  MOV EBX,dword ptr [EBP + 0xc]
  1000838a  PUSH ESI
  1000838b  MOV ESI,dword ptr [EBP + 0x8]
  1000838e  MOV ECX,dword ptr [EDX + 0xc]
  10008391  PUSH EDI
  10008392  LEA EDI,[ESI + 0x1]
  10008395  MOV byte ptr [ESI],0x30
  10008398  TEST EBX,EBX
  1000839a  MOV EAX,EDI
  1000839c  JLE 0x100083bd    ; LAB_100083bd
  1000839e  MOV dword ptr [EBP + 0x8],EBX
  100083a1  XOR EBX,EBX
LAB_100083a3:
  100083a3  MOV DL,byte ptr [ECX]
  100083a5  TEST DL,DL
  100083a7  JZ 0x100083af    ; LAB_100083af
  100083a9  MOVSX EDX,DL
  100083ac  INC ECX
  100083ad  JMP 0x100083b2    ; LAB_100083b2
LAB_100083af:
  100083af  PUSH 0x30
  100083b1  POP EDX
LAB_100083b2:
  100083b2  MOV byte ptr [EAX],DL
  100083b4  INC EAX
  100083b5  DEC dword ptr [EBP + 0x8]
  100083b8  JNZ 0x100083a3    ; LAB_100083a3
  100083ba  MOV EDX,dword ptr [EBP + 0x10]
LAB_100083bd:
  100083bd  AND byte ptr [EAX],0x0
  100083c0  TEST EBX,EBX
  100083c2  JL 0x100083d6    ; LAB_100083d6
  100083c4  CMP byte ptr [ECX],0x35
  100083c7  JL 0x100083d6    ; LAB_100083d6
LAB_100083c9:
  100083c9  DEC EAX
  100083ca  CMP byte ptr [EAX],0x39
  100083cd  JNZ 0x100083d4    ; LAB_100083d4
  100083cf  MOV byte ptr [EAX],0x30
  100083d2  JMP 0x100083c9    ; LAB_100083c9
LAB_100083d4:
  100083d4  INC byte ptr [EAX]
LAB_100083d6:
  100083d6  CMP byte ptr [ESI],0x31
  100083d9  JNZ 0x100083e0    ; LAB_100083e0
  100083db  INC dword ptr [EDX + 0x4]
  100083de  JMP 0x100083f2    ; LAB_100083f2
LAB_100083e0:
  100083e0  PUSH EDI
  100083e1  CALL 0x100088c0    ; _strlen
  100083e6  INC EAX
  100083e7  PUSH EAX
  100083e8  PUSH EDI
  100083e9  PUSH ESI
  100083ea  CALL 0x10008580    ; FUN_10008580
  100083ef  ADD ESP,0x10
LAB_100083f2:
  100083f2  POP EDI
  100083f3  POP ESI
  100083f4  POP EBX
  100083f5  POP EBP
  100083f6  RET

;==== FUNCTION FUN_100083f7 @ 100083f7 : undefined * FUN_100083f7(void)
  100083f7  PUSH EBP
  100083f8  MOV EBP,ESP
  100083fa  SUB ESP,0xc
  100083fd  PUSH ESI
  100083fe  LEA EAX,[EBP + 0x8]
  10008401  PUSH EDI
  10008402  PUSH EAX
  10008403  LEA EAX,[EBP + -0xc]
  10008406  PUSH EAX
  10008407  CALL 0x1000845b    ; FUN_1000845b
  1000840c  POP ECX
  1000840d  LEA ESI,[EBP + -0xc]
  10008410  POP ECX
  10008411  PUSH 0x1000f7a8    ; DAT_1000f7a8
  10008416  PUSH 0x0
  10008418  PUSH 0x11
  1000841a  SUB ESP,0xc
  1000841d  MOV EDI,ESP
  1000841f  MOVSD ES:EDI,ESI
  10008420  MOVSD ES:EDI,ESI
  10008421  MOVSW ES:EDI,ESI
  10008423  CALL 0x1000b44f    ; FUN_1000b44f
  10008428  MOV [0x1000f7d0],EAX    ; DAT_1000f7d0
  1000842d  ADD ESP,0x18
  10008430  MOVSX EAX,byte ptr [0x1000f7aa]    ; DAT_1000f7aa
  10008437  MOV [0x1000f7c8],EAX    ; DAT_1000f7c8
  1000843c  POP EDI
  1000843d  MOVSX EAX,word ptr [0x1000f7a8]    ; DAT_1000f7a8
  10008444  MOV [0x1000f7cc],EAX    ; DAT_1000f7cc
  10008449  MOV dword ptr [0x1000f7d4],0x1000f7ac    ; DAT_1000f7d4 DAT_1000f7ac
  10008453  MOV EAX,0x1000f7c8    ; DAT_1000f7c8
  10008458  POP ESI
  10008459  LEAVE
  1000845a  RET

;==== FUNCTION FUN_1000845b @ 1000845b : undefined FUN_1000845b(uint * param_1, uint * param_2)
  1000845b  PUSH EBP
  1000845c  MOV EBP,ESP
  1000845e  PUSH ECX
  1000845f  MOV EDX,dword ptr [EBP + 0xc]
  10008462  PUSH EBX
  10008463  PUSH ESI
  10008464  PUSH EDI
  10008465  MOV AX,word ptr [EDX + 0x6]
  10008469  MOV EDI,0x7ff
  1000846e  MOV ECX,EAX
  10008470  AND EAX,0x8000
  10008475  SHR ECX,0x4
  10008478  AND ECX,EDI
  1000847a  MOV dword ptr [EBP + 0xc],EAX
  1000847d  MOV EAX,dword ptr [EDX + 0x4]
  10008480  MOV EDX,dword ptr [EDX]
  10008482  MOVZX EBX,CX
  10008485  MOV ESI,0x80000000
  1000848a  AND EAX,0xfffff
  1000848f  TEST EBX,EBX
  10008491  MOV dword ptr [EBP + -0x4],ESI
  10008494  JZ 0x100084a9    ; LAB_100084a9
  10008496  CMP EBX,EDI
  10008498  JZ 0x100084a2    ; LAB_100084a2
  1000849a  LEA EDI,[ECX + 0x3c00]
  100084a0  JMP 0x100084ca    ; LAB_100084ca
LAB_100084a2:
  100084a2  MOV EDI,0x7fff
  100084a7  JMP 0x100084ca    ; LAB_100084ca
LAB_100084a9:
  100084a9  XOR EBX,EBX
  100084ab  CMP EAX,EBX
  100084ad  JNZ 0x100084c1    ; LAB_100084c1
  100084af  CMP EDX,EBX
  100084b1  JNZ 0x100084c1    ; LAB_100084c1
  100084b3  MOV EAX,dword ptr [EBP + 0x8]
  100084b6  MOV dword ptr [EAX + 0x4],EBX
  100084b9  MOV dword ptr [EAX],EBX
  100084bb  MOV word ptr [EAX + 0x8],BX
  100084bf  JMP 0x1000850c    ; LAB_1000850c
LAB_100084c1:
  100084c1  LEA EDI,[ECX + 0x3c01]
  100084c7  MOV dword ptr [EBP + -0x4],EBX
LAB_100084ca:
  100084ca  MOV ECX,EDX
  100084cc  SHR ECX,0x15
  100084cf  SHL EAX,0xb
  100084d2  OR ECX,EAX
  100084d4  MOV EAX,dword ptr [EBP + 0x8]
  100084d7  OR ECX,dword ptr [EBP + -0x4]
  100084da  SHL EDX,0xb
  100084dd  MOV dword ptr [EAX + 0x4],ECX
  100084e0  MOV dword ptr [EAX],EDX
LAB_100084e2:
  100084e2  TEST ESI,ECX
  100084e4  JNZ 0x10008503    ; LAB_10008503
  100084e6  MOV EDX,dword ptr [EAX]
  100084e8  ADD ECX,ECX
  100084ea  MOV EBX,EDX
  100084ec  SHR EBX,0x1f
  100084ef  OR EBX,ECX
  100084f1  LEA ECX,[EDX + EDX*0x1]
  100084f4  MOV dword ptr [EAX],ECX
  100084f6  MOV dword ptr [EAX + 0x4],EBX
  100084f9  ADD EDI,0xffff
  100084ff  MOV ECX,EBX
  10008501  JMP 0x100084e2    ; LAB_100084e2
LAB_10008503:
  10008503  MOV ECX,dword ptr [EBP + 0xc]
  10008506  OR ECX,EDI
  10008508  MOV word ptr [EAX + 0x8],CX
LAB_1000850c:
  1000850c  POP EDI
  1000850d  POP ESI
  1000850e  POP EBX
  1000850f  LEAVE
  10008510  RET

;==== FUNCTION _memset @ 10008520 : void * _memset(void * _Dst, int _Val, size_t _Size)
  10008520  MOV EDX,dword ptr [ESP + 0xc]
  10008524  MOV ECX,dword ptr [ESP + 0x4]
  10008528  TEST EDX,EDX
  1000852a  JZ 0x10008573    ; LAB_10008573
  1000852c  XOR EAX,EAX
  1000852e  MOV AL,byte ptr [ESP + 0x8]
  10008532  PUSH EDI
  10008533  MOV EDI,ECX
  10008535  CMP EDX,0x4
  10008538  JC 0x10008567    ; LAB_10008567
  1000853a  NEG ECX
  1000853c  AND ECX,0x3
  1000853f  JZ 0x10008549    ; LAB_10008549
  10008541  SUB EDX,ECX
LAB_10008543:
  10008543  MOV byte ptr [EDI],AL
  10008545  INC EDI
  10008546  DEC ECX
  10008547  JNZ 0x10008543    ; LAB_10008543
LAB_10008549:
  10008549  MOV ECX,EAX
  1000854b  SHL EAX,0x8
  1000854e  ADD EAX,ECX
  10008550  MOV ECX,EAX
  10008552  SHL EAX,0x10
  10008555  ADD EAX,ECX
  10008557  MOV ECX,EDX
  10008559  AND EDX,0x3
  1000855c  SHR ECX,0x2
  1000855f  JZ 0x10008567    ; LAB_10008567
  10008561  STOSD.REP ES:EDI
  10008563  TEST EDX,EDX
  10008565  JZ 0x1000856d    ; LAB_1000856d
LAB_10008567:
  10008567  MOV byte ptr [EDI],AL
  10008569  INC EDI
  1000856a  DEC EDX
  1000856b  JNZ 0x10008567    ; LAB_10008567
LAB_1000856d:
  1000856d  MOV EAX,dword ptr [ESP + 0x8]
  10008571  POP EDI
  10008572  RET
LAB_10008573:
  10008573  MOV EAX,dword ptr [ESP + 0x4]
  10008577  RET

;==== FUNCTION FUN_10008580 @ 10008580 : undefined4 * FUN_10008580(undefined4 * param_1, undefined4 * param_2, uint param_3)
  10008580  PUSH EBP
  10008581  MOV EBP,ESP
  10008583  PUSH EDI
  10008584  PUSH ESI
  10008585  MOV ESI,dword ptr [EBP + 0xc]
  10008588  MOV ECX,dword ptr [EBP + 0x10]
  1000858b  MOV EDI,dword ptr [EBP + 0x8]
  1000858e  MOV EAX,ECX
  10008590  MOV EDX,ECX
  10008592  ADD EAX,ESI
  10008594  CMP EDI,ESI
  10008596  JBE 0x100085a0    ; LAB_100085a0
  10008598  CMP EDI,EAX
  1000859a  JC 0x10008718    ; LAB_10008718
LAB_100085a0:
  100085a0  TEST EDI,0x3
  100085a6  JNZ 0x100085bc    ; LAB_100085bc
  100085a8  SHR ECX,0x2
  100085ab  AND EDX,0x3
  100085ae  CMP ECX,0x8
  100085b1  JC 0x100085dc    ; switchD_100085dc::switchD
  100085b3  MOVSD.REP ES:EDI,ESI
switchD:
  100085b5  JMP dword ptr [EDX*0x4 + 0x100086c8]    ; switchD_100085b5::caseD_0 switchD_100085b5::caseD_1 switchD_100085b5::caseD_2 switchD_100085b5::caseD_3 switchD_100085b5::switchdataD_100086c8
LAB_100085bc:
  100085bc  MOV EAX,EDI
  100085be  MOV EDX,0x3
  100085c3  SUB ECX,0x4
  100085c6  JC 0x100085d4    ; switchD_100085d4::switchD
default:
  100085c8  AND EAX,0x3
  100085cb  ADD ECX,EAX
switchD:
  100085cd  JMP dword ptr [EAX*0x4 + 0x100085e0]    ; switchD_100085cd::caseD_1 switchD_100085cd::caseD_2 switchD_100085cd::caseD_3 switchD_100085cd::switchdataD_100085e4
switchD:
  100085d4  JMP dword ptr [ECX*0x4 + 0x100086d8]    ; switchD_100085b5::caseD_0 switchD_100085b5::caseD_1 switchD_100085b5::caseD_2 switchD_100085b5::caseD_3
switchD:
  100085dc  JMP dword ptr [ECX*0x4 + 0x1000865c]    ; switchD_100085dc::caseD_0 switchD_100085dc::caseD_1 switchD_100085dc::caseD_2 switchD_100085dc::caseD_3 switchD_100085dc::caseD_4 switchD_100085dc::caseD_5 switchD_100085dc::caseD_6 switchD_100085dc::caseD_7 switchD_100085dc::switchdataD_1000865c
caseD_1:
  100085f0  AND EDX,ECX
  100085f2  MOV AL,byte ptr [ESI]
  100085f4  MOV byte ptr [EDI],AL
  100085f6  MOV AL,byte ptr [ESI + 0x1]
  100085f9  MOV byte ptr [EDI + 0x1],AL
  100085fc  MOV AL,byte ptr [ESI + 0x2]
  100085ff  SHR ECX,0x2
  10008602  MOV byte ptr [EDI + 0x2],AL
  10008605  ADD ESI,0x3
  10008608  ADD EDI,0x3
  1000860b  CMP ECX,0x8
  1000860e  JC 0x100085dc    ; switchD_100085dc::switchD
  10008610  MOVSD.REP ES:EDI,ESI
switchD:
  10008612  JMP dword ptr [EDX*0x4 + 0x100086c8]    ; switchD_100085b5::caseD_0 switchD_100085b5::caseD_1 switchD_100085b5::caseD_2 switchD_100085b5::caseD_3 switchD_100085b5::switchdataD_100086c8
caseD_2:
  1000861c  AND EDX,ECX
  1000861e  MOV AL,byte ptr [ESI]
  10008620  MOV byte ptr [EDI],AL
  10008622  MOV AL,byte ptr [ESI + 0x1]
  10008625  SHR ECX,0x2
  10008628  MOV byte ptr [EDI + 0x1],AL
  1000862b  ADD ESI,0x2
  1000862e  ADD EDI,0x2
  10008631  CMP ECX,0x8
  10008634  JC 0x100085dc    ; switchD_100085dc::switchD
  10008636  MOVSD.REP ES:EDI,ESI
switchD:
  10008638  JMP dword ptr [EDX*0x4 + 0x100086c8]    ; switchD_100085b5::caseD_0 switchD_100085b5::caseD_1 switchD_100085b5::caseD_2 switchD_100085b5::caseD_3 switchD_100085b5::switchdataD_100086c8
caseD_3:
  10008640  AND EDX,ECX
  10008642  MOV AL,byte ptr [ESI]
  10008644  MOV byte ptr [EDI],AL
  10008646  INC ESI
  10008647  SHR ECX,0x2
  1000864a  INC EDI
  1000864b  CMP ECX,0x8
  1000864e  JC 0x100085dc    ; switchD_100085dc::switchD
  10008650  MOVSD.REP ES:EDI,ESI
switchD:
  10008652  JMP dword ptr [EDX*0x4 + 0x100086c8]    ; switchD_100085b5::caseD_0 switchD_100085b5::caseD_1 switchD_100085b5::caseD_2 switchD_100085b5::caseD_3 switchD_100085b5::switchdataD_100086c8
caseD_7:
  1000867c  MOV EAX,dword ptr [ESI + ECX*0x4 + -0x1c]
  10008680  MOV dword ptr [EDI + ECX*0x4 + -0x1c],EAX
caseD_6:
  10008684  MOV EAX,dword ptr [ESI + ECX*0x4 + -0x18]
  10008688  MOV dword ptr [EDI + ECX*0x4 + -0x18],EAX
caseD_5:
  1000868c  MOV EAX,dword ptr [ESI + ECX*0x4 + -0x14]
  10008690  MOV dword ptr [EDI + ECX*0x4 + -0x14],EAX
caseD_4:
  10008694  MOV EAX,dword ptr [ESI + ECX*0x4 + -0x10]
  10008698  MOV dword ptr [EDI + ECX*0x4 + -0x10],EAX
caseD_3:
  1000869c  MOV EAX,dword ptr [ESI + ECX*0x4 + -0xc]
  100086a0  MOV dword ptr [EDI + ECX*0x4 + -0xc],EAX
caseD_2:
  100086a4  MOV EAX,dword ptr [ESI + ECX*0x4 + -0x8]
  100086a8  MOV dword ptr [EDI + ECX*0x4 + -0x8],EAX
caseD_1:
  100086ac  MOV EAX,dword ptr [ESI + ECX*0x4 + -0x4]
  100086b0  MOV dword ptr [EDI + ECX*0x4 + -0x4],EAX
  100086b4  LEA EAX,[ECX*0x4 + 0x0]
  100086bb  ADD ESI,EAX
  100086bd  ADD EDI,EAX
caseD_0:
  100086bf  JMP dword ptr [EDX*0x4 + 0x100086c8]    ; switchD_100085b5::caseD_0 switchD_100085b5::caseD_1 switchD_100085b5::caseD_2 switchD_100085b5::caseD_3 switchD_100085b5::switchdataD_100086c8
caseD_0:
  100086d8  MOV EAX,dword ptr [EBP + 0x8]
  100086db  POP ESI
  100086dc  POP EDI
  100086dd  LEAVE
  100086de  RET
caseD_1:
  100086e0  MOV AL,byte ptr [ESI]
  100086e2  MOV byte ptr [EDI],AL
  100086e4  MOV EAX,dword ptr [EBP + 0x8]
  100086e7  POP ESI
  100086e8  POP EDI
  100086e9  LEAVE
  100086ea  RET
caseD_2:
  100086ec  MOV AL,byte ptr [ESI]
  100086ee  MOV byte ptr [EDI],AL
  100086f0  MOV AL,byte ptr [ESI + 0x1]
  100086f3  MOV byte ptr [EDI + 0x1],AL
  100086f6  MOV EAX,dword ptr [EBP + 0x8]
  100086f9  POP ESI
  100086fa  POP EDI
  100086fb  LEAVE
  100086fc  RET
caseD_3:
  10008700  MOV AL,byte ptr [ESI]
  10008702  MOV byte ptr [EDI],AL
  10008704  MOV AL,byte ptr [ESI + 0x1]
  10008707  MOV byte ptr [EDI + 0x1],AL
  1000870a  MOV AL,byte ptr [ESI + 0x2]
  1000870d  MOV byte ptr [EDI + 0x2],AL
  10008710  MOV EAX,dword ptr [EBP + 0x8]
  10008713  POP ESI
  10008714  POP EDI
  10008715  LEAVE
  10008716  RET
LAB_10008718:
  10008718  LEA ESI,[ECX + ESI*0x1 + -0x4]
  1000871c  LEA EDI,[ECX + EDI*0x1 + -0x4]
  10008720  TEST EDI,0x3
  10008726  JNZ 0x1000874c    ; LAB_1000874c
  10008728  SHR ECX,0x2
  1000872b  AND EDX,0x3
  1000872e  CMP ECX,0x8
  10008731  JC 0x10008740    ; LAB_10008740
  10008733  STD
  10008734  MOVSD.REP ES:EDI,ESI
  10008736  CLD
switchD:
  10008737  JMP dword ptr [EDX*0x4 + 0x10008860]    ; switchD_10008737::caseD_0 switchD_10008737::caseD_1 switchD_10008737::caseD_2 switchD_10008737::caseD_3 switchD_10008737::switchdataD_10008860
LAB_10008740:
  10008740  NEG ECX
switchD:
  10008742  JMP dword ptr [ECX*0x4 + 0x10008810]    ; switchD_10008742::caseD_0 switchD_10008742::caseD_1 switchD_10008742::caseD_2 switchD_10008742::caseD_3 switchD_10008742::caseD_4 switchD_10008742::caseD_5 switchD_10008742::caseD_6 switchD_10008742::caseD_7 PTR_caseD_0_10008810
LAB_1000874c:
  1000874c  MOV EAX,EDI
  1000874e  MOV EDX,0x3
  10008753  CMP ECX,0x4
  10008756  JC 0x10008764    ; switchD_10008764::switchD
default:
  10008758  AND EAX,0x3
  1000875b  SUB ECX,EAX
switchD:
  1000875d  JMP dword ptr [EAX*0x4 + 0x10008768]    ; switchD_1000875d::caseD_1 switchD_1000875d::caseD_2 switchD_1000875d::caseD_3 switchD_1000875d::switchdataD_1000876c
switchD:
  10008764  JMP dword ptr [ECX*0x4 + 0x10008860]    ; switchD_10008737::caseD_0 switchD_10008737::caseD_1 switchD_10008737::caseD_2 switchD_10008737::caseD_3 switchD_10008737::switchdataD_10008860
caseD_1:
  10008778  MOV AL,byte ptr [ESI + 0x3]
  1000877b  AND EDX,ECX
  1000877d  MOV byte ptr [EDI + 0x3],AL
  10008780  DEC ESI
  10008781  SHR ECX,0x2
  10008784  DEC EDI
  10008785  CMP ECX,0x8
  10008788  JC 0x10008740    ; LAB_10008740
  1000878a  STD
  1000878b  MOVSD.REP ES:EDI,ESI
  1000878d  CLD
switchD:
  1000878e  JMP dword ptr [EDX*0x4 + 0x10008860]    ; switchD_10008737::caseD_0 switchD_10008737::caseD_1 switchD_10008737::caseD_2 switchD_10008737::caseD_3 switchD_10008737::switchdataD_10008860
caseD_2:
  10008798  MOV AL,byte ptr [ESI + 0x3]
  1000879b  AND EDX,ECX
  1000879d  MOV byte ptr [EDI + 0x3],AL
  100087a0  MOV AL,byte ptr [ESI + 0x2]
  100087a3  SHR ECX,0x2
  100087a6  MOV byte ptr [EDI + 0x2],AL
  100087a9  SUB ESI,0x2
  100087ac  SUB EDI,0x2
  100087af  CMP ECX,0x8
  100087b2  JC 0x10008740    ; LAB_10008740
  100087b4  STD
  100087b5  MOVSD.REP ES:EDI,ESI
  100087b7  CLD
switchD:
  100087b8  JMP dword ptr [EDX*0x4 + 0x10008860]    ; switchD_10008737::caseD_0 switchD_10008737::caseD_1 switchD_10008737::caseD_2 switchD_10008737::caseD_3 switchD_10008737::switchdataD_10008860
caseD_3:
  100087c0  MOV AL,byte ptr [ESI + 0x3]
  100087c3  AND EDX,ECX
  100087c5  MOV byte ptr [EDI + 0x3],AL
  100087c8  MOV AL,byte ptr [ESI + 0x2]
  100087cb  MOV byte ptr [EDI + 0x2],AL
  100087ce  MOV AL,byte ptr [ESI + 0x1]
  100087d1  SHR ECX,0x2
  100087d4  MOV byte ptr [EDI + 0x1],AL
  100087d7  SUB ESI,0x3
  100087da  SUB EDI,0x3
  100087dd  CMP ECX,0x8
  100087e0  JC 0x10008740    ; LAB_10008740
  100087e6  STD
  100087e7  MOVSD.REP ES:EDI,ESI
  100087e9  CLD
switchD:
  100087ea  JMP dword ptr [EDX*0x4 + 0x10008860]    ; switchD_10008737::caseD_0 switchD_10008737::caseD_1 switchD_10008737::caseD_2 switchD_10008737::caseD_3 switchD_10008737::switchdataD_10008860
caseD_7:
  10008814  MOV EAX,dword ptr [ESI + ECX*0x4 + 0x1c]
  10008818  MOV dword ptr [EDI + ECX*0x4 + 0x1c],EAX
caseD_6:
  1000881c  MOV EAX,dword ptr [ESI + ECX*0x4 + 0x18]
  10008820  MOV dword ptr [EDI + ECX*0x4 + 0x18],EAX
caseD_5:
  10008824  MOV EAX,dword ptr [ESI + ECX*0x4 + 0x14]
  10008828  MOV dword ptr [EDI + ECX*0x4 + 0x14],EAX
caseD_4:
  1000882c  MOV EAX,dword ptr [ESI + ECX*0x4 + 0x10]
  10008830  MOV dword ptr [EDI + ECX*0x4 + 0x10],EAX
caseD_3:
  10008834  MOV EAX,dword ptr [ESI + ECX*0x4 + 0xc]
  10008838  MOV dword ptr [EDI + ECX*0x4 + 0xc],EAX
caseD_2:
  1000883c  MOV EAX,dword ptr [ESI + ECX*0x4 + 0x8]
  10008840  MOV dword ptr [EDI + ECX*0x4 + 0x8],EAX
caseD_1:
  10008844  MOV EAX,dword ptr [ESI + ECX*0x4 + 0x4]
  10008848  MOV dword ptr [EDI + ECX*0x4 + 0x4],EAX
  1000884c  LEA EAX,[ECX*0x4 + 0x0]
  10008853  ADD ESI,EAX
  10008855  ADD EDI,EAX
caseD_0:
  10008857  JMP dword ptr [EDX*0x4 + 0x10008860]    ; switchD_10008737::caseD_0 switchD_10008737::caseD_1 switchD_10008737::caseD_2 switchD_10008737::caseD_3 switchD_10008737::switchdataD_10008860
caseD_0:
  10008870  MOV EAX,dword ptr [EBP + 0x8]
  10008873  POP ESI
  10008874  POP EDI
  10008875  LEAVE
  10008876  RET
caseD_1:
  10008878  MOV AL,byte ptr [ESI + 0x3]
  1000887b  MOV byte ptr [EDI + 0x3],AL
  1000887e  MOV EAX,dword ptr [EBP + 0x8]
  10008881  POP ESI
  10008882  POP EDI
  10008883  LEAVE
  10008884  RET
caseD_2:
  10008888  MOV AL,byte ptr [ESI + 0x3]
  1000888b  MOV byte ptr [EDI + 0x3],AL
  1000888e  MOV AL,byte ptr [ESI + 0x2]
  10008891  MOV byte ptr [EDI + 0x2],AL
  10008894  MOV EAX,dword ptr [EBP + 0x8]
  10008897  POP ESI
  10008898  POP EDI
  10008899  LEAVE
  1000889a  RET
caseD_3:
  1000889c  MOV AL,byte ptr [ESI + 0x3]
  1000889f  MOV byte ptr [EDI + 0x3],AL
  100088a2  MOV AL,byte ptr [ESI + 0x2]
  100088a5  MOV byte ptr [EDI + 0x2],AL
  100088a8  MOV AL,byte ptr [ESI + 0x1]
  100088ab  MOV byte ptr [EDI + 0x1],AL
  100088ae  MOV EAX,dword ptr [EBP + 0x8]
  100088b1  POP ESI
  100088b2  POP EDI
  100088b3  LEAVE
  100088b4  RET

;==== FUNCTION _strlen @ 100088c0 : size_t _strlen(char * _Str)
  100088c0  MOV ECX,dword ptr [ESP + 0x4]
  100088c4  TEST ECX,0x3
  100088ca  JZ 0x100088e0    ; LAB_100088e0
LAB_100088cc:
  100088cc  MOV AL,byte ptr [ECX]
  100088ce  INC ECX
  100088cf  TEST AL,AL
  100088d1  JZ 0x10008913    ; LAB_10008913
  100088d3  TEST ECX,0x3
  100088d9  JNZ 0x100088cc    ; LAB_100088cc
  100088db  ADD EAX,0x0
LAB_100088e0:
  100088e0  MOV EAX,dword ptr [ECX]
  100088e2  MOV EDX,0x7efefeff
  100088e7  ADD EDX,EAX
  100088e9  XOR EAX,0xffffffff
  100088ec  XOR EAX,EDX
  100088ee  ADD ECX,0x4
  100088f1  TEST EAX,0x81010100
  100088f6  JZ 0x100088e0    ; LAB_100088e0
  100088f8  MOV EAX,dword ptr [ECX + -0x4]
  100088fb  TEST AL,AL
  100088fd  JZ 0x10008931    ; LAB_10008931
  100088ff  TEST AH,AH
  10008901  JZ 0x10008927    ; LAB_10008927
  10008903  TEST EAX,0xff0000
  10008908  JZ 0x1000891d    ; LAB_1000891d
  1000890a  TEST EAX,0xff000000
  1000890f  JZ 0x10008913    ; LAB_10008913
  10008911  JMP 0x100088e0    ; LAB_100088e0
LAB_10008913:
  10008913  LEA EAX,[ECX + -0x1]
  10008916  MOV ECX,dword ptr [ESP + 0x4]
  1000891a  SUB EAX,ECX
  1000891c  RET
LAB_1000891d:
  1000891d  LEA EAX,[ECX + -0x2]
  10008920  MOV ECX,dword ptr [ESP + 0x4]
  10008924  SUB EAX,ECX
  10008926  RET
LAB_10008927:
  10008927  LEA EAX,[ECX + -0x3]
  1000892a  MOV ECX,dword ptr [ESP + 0x4]
  1000892e  SUB EAX,ECX
  10008930  RET
LAB_10008931:
  10008931  LEA EAX,[ECX + -0x4]
  10008934  MOV ECX,dword ptr [ESP + 0x4]
  10008938  SUB EAX,ECX
  1000893a  RET

;==== FUNCTION __fptrap @ 1000893b : void __fptrap(void)
  1000893b  PUSH 0x2
  1000893d  CALL 0x10005943    ; __amsg_exit
  10008942  POP ECX
  10008943  RET

;==== FUNCTION FUN_10008961 @ 10008961 : undefined4 FUN_10008961(void)
  10008961  PUSH 0x140
  10008966  PUSH 0x0
  10008968  PUSH dword ptr [0x10010ba4]    ; DAT_10010ba4
  1000896e  CALL dword ptr [0x1000d038]    ; PTR_HeapAlloc_1000d038 KERNEL32.DLL::HeapAlloc
  10008974  TEST EAX,EAX
  10008976  MOV [0x10010a98],EAX    ; DAT_10010a98
  1000897b  JNZ 0x1000897e    ; LAB_1000897e
  1000897d  RET
LAB_1000897e:
  1000897e  AND dword ptr [0x10010a90],0x0    ; DAT_10010a90
  10008985  AND dword ptr [0x10010a94],0x0    ; DAT_10010a94
  1000898c  PUSH 0x1
  1000898e  MOV [0x10010a8c],EAX    ; DAT_10010a8c
  10008993  MOV dword ptr [0x10010a84],0x10    ; DAT_10010a84
  1000899d  POP EAX
  1000899e  RET

;==== FUNCTION FUN_1000899f @ 1000899f : uint FUN_1000899f(int param_1)
  1000899f  MOV EAX,[0x10010a94]    ; DAT_10010a94
  100089a4  LEA ECX,[EAX + EAX*0x4]
  100089a7  MOV EAX,[0x10010a98]    ; DAT_10010a98
  100089ac  LEA ECX,[EAX + ECX*0x4]
LAB_100089af:
  100089af  CMP EAX,ECX
  100089b1  JNC 0x100089c7    ; LAB_100089c7
  100089b3  MOV EDX,dword ptr [ESP + 0x4]
  100089b7  SUB EDX,dword ptr [EAX + 0xc]
  100089ba  CMP EDX,0x100000
  100089c0  JC 0x100089c9    ; LAB_100089c9
  100089c2  ADD EAX,0x14
  100089c5  JMP 0x100089af    ; LAB_100089af
LAB_100089c7:
  100089c7  XOR EAX,EAX
LAB_100089c9:
  100089c9  RET

;==== FUNCTION FUN_100089ca @ 100089ca : undefined FUN_100089ca(uint * param_1, uint param_2)
  100089ca  PUSH EBP
  100089cb  MOV EBP,ESP
  100089cd  SUB ESP,0x14
  100089d0  MOV EDX,dword ptr [EBP + 0xc]
  100089d3  MOV ECX,dword ptr [EBP + 0x8]
  100089d6  PUSH EBX
  100089d7  PUSH ESI
  100089d8  MOV EAX,dword ptr [ECX + 0x10]
  100089db  MOV ESI,EDX
  100089dd  SUB ESI,dword ptr [ECX + 0xc]
  100089e0  MOV EBX,dword ptr [EDX + -0x4]
  100089e3  ADD EDX,-0x4
  100089e6  PUSH EDI
  100089e7  SHR ESI,0xf
  100089ea  MOV ECX,ESI
  100089ec  MOV EDI,dword ptr [EDX + -0x4]
  100089ef  IMUL ECX,ECX,0x204
  100089f5  DEC EBX
  100089f6  MOV dword ptr [EBP + -0x4],EDI
  100089f9  LEA ECX,[ECX + EAX*0x1 + 0x144]
  10008a00  MOV dword ptr [EBP + -0xc],EBX
  10008a03  MOV dword ptr [EBP + -0x10],ECX
  10008a06  MOV ECX,dword ptr [EBX + EDX*0x1]
  10008a09  TEST CL,0x1
  10008a0c  MOV dword ptr [EBP + -0x8],ECX
  10008a0f  JNZ 0x10008a90    ; LAB_10008a90
  10008a11  SAR ECX,0x4
  10008a14  PUSH 0x3f
  10008a16  DEC ECX
  10008a17  POP EDI
  10008a18  MOV dword ptr [EBP + 0xc],ECX
  10008a1b  CMP ECX,EDI
  10008a1d  JBE 0x10008a22    ; LAB_10008a22
  10008a1f  MOV dword ptr [EBP + 0xc],EDI
LAB_10008a22:
  10008a22  MOV ECX,dword ptr [EBX + EDX*0x1 + 0x4]
  10008a26  CMP ECX,dword ptr [EBX + EDX*0x1 + 0x8]
  10008a2a  JNZ 0x10008a74    ; LAB_10008a74
  10008a2c  MOV ECX,dword ptr [EBP + 0xc]
  10008a2f  CMP ECX,0x20
  10008a32  JNC 0x10008a50    ; LAB_10008a50
  10008a34  MOV EDI,0x80000000
  10008a39  SHR EDI,CL
  10008a3b  LEA ECX,[ECX + EAX*0x1 + 0x4]
  10008a3f  NOT EDI
  10008a41  AND dword ptr [EAX + ESI*0x4 + 0x44],EDI
  10008a45  DEC byte ptr [ECX]
  10008a47  JNZ 0x10008a74    ; LAB_10008a74
  10008a49  MOV ECX,dword ptr [EBP + 0x8]
  10008a4c  AND dword ptr [ECX],EDI
  10008a4e  JMP 0x10008a74    ; LAB_10008a74
LAB_10008a50:
  10008a50  ADD ECX,-0x20
  10008a53  MOV EDI,0x80000000
  10008a58  SHR EDI,CL
  10008a5a  MOV ECX,dword ptr [EBP + 0xc]
  10008a5d  LEA ECX,[ECX + EAX*0x1 + 0x4]
  10008a61  NOT EDI
  10008a63  AND dword ptr [EAX + ESI*0x4 + 0xc4],EDI
  10008a6a  DEC byte ptr [ECX]
  10008a6c  JNZ 0x10008a74    ; LAB_10008a74
  10008a6e  MOV ECX,dword ptr [EBP + 0x8]
  10008a71  AND dword ptr [ECX + 0x4],EDI
LAB_10008a74:
  10008a74  MOV ECX,dword ptr [EBX + EDX*0x1 + 0x8]
  10008a78  MOV EDI,dword ptr [EBX + EDX*0x1 + 0x4]
  10008a7c  MOV dword ptr [ECX + 0x4],EDI
  10008a7f  MOV ECX,dword ptr [EBX + EDX*0x1 + 0x4]
  10008a83  MOV EDI,dword ptr [EBX + EDX*0x1 + 0x8]
  10008a87  ADD EBX,dword ptr [EBP + -0x8]
  10008a8a  MOV dword ptr [ECX + 0x8],EDI
  10008a8d  MOV dword ptr [EBP + -0xc],EBX
LAB_10008a90:
  10008a90  MOV EDI,EBX
  10008a92  SAR EDI,0x4
  10008a95  DEC EDI
  10008a96  CMP EDI,0x3f
  10008a99  JBE 0x10008a9e    ; LAB_10008a9e
  10008a9b  PUSH 0x3f
  10008a9d  POP EDI
LAB_10008a9e:
  10008a9e  MOV ECX,dword ptr [EBP + -0x4]
  10008aa1  AND ECX,0x1
  10008aa4  MOV dword ptr [EBP + -0x14],ECX
  10008aa7  JNZ 0x10008b4d    ; LAB_10008b4d
  10008aad  SUB EDX,dword ptr [EBP + -0x4]
  10008ab0  MOV ECX,dword ptr [EBP + -0x4]
  10008ab3  SAR ECX,0x4
  10008ab6  PUSH 0x3f
  10008ab8  MOV dword ptr [EBP + -0x8],EDX
  10008abb  DEC ECX
  10008abc  POP EDX
  10008abd  CMP ECX,EDX
  10008abf  MOV dword ptr [EBP + 0xc],ECX
  10008ac2  JBE 0x10008ac9    ; LAB_10008ac9
  10008ac4  MOV dword ptr [EBP + 0xc],EDX
  10008ac7  MOV ECX,EDX
LAB_10008ac9:
  10008ac9  ADD EBX,dword ptr [EBP + -0x4]
  10008acc  MOV EDI,EBX
  10008ace  MOV dword ptr [EBP + -0xc],EBX
  10008ad1  SAR EDI,0x4
  10008ad4  DEC EDI
  10008ad5  CMP EDI,EDX
  10008ad7  JBE 0x10008adb    ; LAB_10008adb
  10008ad9  MOV EDI,EDX
LAB_10008adb:
  10008adb  CMP ECX,EDI
  10008add  JZ 0x10008b4a    ; LAB_10008b4a
  10008adf  MOV ECX,dword ptr [EBP + -0x8]
  10008ae2  MOV EDX,dword ptr [ECX + 0x4]
  10008ae5  CMP EDX,dword ptr [ECX + 0x8]
  10008ae8  JNZ 0x10008b32    ; LAB_10008b32
  10008aea  MOV ECX,dword ptr [EBP + 0xc]
  10008aed  CMP ECX,0x20
  10008af0  JNC 0x10008b0e    ; LAB_10008b0e
  10008af2  MOV EDX,0x80000000
  10008af7  SHR EDX,CL
  10008af9  LEA ECX,[ECX + EAX*0x1 + 0x4]
  10008afd  NOT EDX
  10008aff  AND dword ptr [EAX + ESI*0x4 + 0x44],EDX
  10008b03  DEC byte ptr [ECX]
  10008b05  JNZ 0x10008b32    ; LAB_10008b32
  10008b07  MOV ECX,dword ptr [EBP + 0x8]
  10008b0a  AND dword ptr [ECX],EDX
  10008b0c  JMP 0x10008b32    ; LAB_10008b32
LAB_10008b0e:
  10008b0e  ADD ECX,-0x20
  10008b11  MOV EDX,0x80000000
  10008b16  SHR EDX,CL
  10008b18  MOV ECX,dword ptr [EBP + 0xc]
  10008b1b  LEA ECX,[ECX + EAX*0x1 + 0x4]
  10008b1f  NOT EDX
  10008b21  AND dword ptr [EAX + ESI*0x4 + 0xc4],EDX
  10008b28  DEC byte ptr [ECX]
  10008b2a  JNZ 0x10008b32    ; LAB_10008b32
  10008b2c  MOV ECX,dword ptr [EBP + 0x8]
  10008b2f  AND dword ptr [ECX + 0x4],EDX
LAB_10008b32:
  10008b32  MOV ECX,dword ptr [EBP + -0x8]
  10008b35  MOV EDX,dword ptr [ECX + 0x8]
  10008b38  MOV ECX,dword ptr [ECX + 0x4]
  10008b3b  MOV dword ptr [EDX + 0x4],ECX
  10008b3e  MOV ECX,dword ptr [EBP + -0x8]
  10008b41  MOV EDX,dword ptr [ECX + 0x4]
  10008b44  MOV ECX,dword ptr [ECX + 0x8]
  10008b47  MOV dword ptr [EDX + 0x8],ECX
LAB_10008b4a:
  10008b4a  MOV EDX,dword ptr [EBP + -0x8]
LAB_10008b4d:
  10008b4d  CMP dword ptr [EBP + -0x14],0x0
  10008b51  JNZ 0x10008b5c    ; LAB_10008b5c
  10008b53  CMP dword ptr [EBP + 0xc],EDI
  10008b56  JZ 0x10008be5    ; LAB_10008be5
LAB_10008b5c:
  10008b5c  MOV ECX,dword ptr [EBP + -0x10]
  10008b5f  LEA ECX,[ECX + EDI*0x8]
  10008b62  MOV ECX,dword ptr [ECX + 0x4]
  10008b65  MOV dword ptr [EDX + 0x4],ECX
  10008b68  MOV ECX,dword ptr [EBP + -0x10]
  10008b6b  LEA ECX,[ECX + EDI*0x8]
  10008b6e  MOV dword ptr [EDX + 0x8],ECX
  10008b71  MOV dword ptr [ECX + 0x4],EDX
  10008b74  MOV ECX,dword ptr [EDX + 0x4]
  10008b77  MOV dword ptr [ECX + 0x8],EDX
  10008b7a  MOV ECX,dword ptr [EDX + 0x4]
  10008b7d  CMP ECX,dword ptr [EDX + 0x8]
  10008b80  JNZ 0x10008be5    ; LAB_10008be5
  10008b82  MOV CL,byte ptr [EDI + EAX*0x1 + 0x4]
  10008b86  CMP EDI,0x20
  10008b89  MOV byte ptr [EBP + 0xf],CL
  10008b8c  INC CL
  10008b8e  MOV byte ptr [EDI + EAX*0x1 + 0x4],CL
  10008b92  JNC 0x10008bb9    ; LAB_10008bb9
  10008b94  CMP byte ptr [EBP + 0xf],0x0
  10008b98  JNZ 0x10008ba8    ; LAB_10008ba8
  10008b9a  MOV EBX,0x80000000
  10008b9f  MOV ECX,EDI
  10008ba1  SHR EBX,CL
  10008ba3  MOV ECX,dword ptr [EBP + 0x8]
  10008ba6  OR dword ptr [ECX],EBX
LAB_10008ba8:
  10008ba8  MOV EBX,0x80000000
  10008bad  MOV ECX,EDI
  10008baf  SHR EBX,CL
  10008bb1  LEA EAX,[EAX + ESI*0x4 + 0x44]
  10008bb5  OR dword ptr [EAX],EBX
  10008bb7  JMP 0x10008be2    ; LAB_10008be2
LAB_10008bb9:
  10008bb9  CMP byte ptr [EBP + 0xf],0x0
  10008bbd  JNZ 0x10008bcf    ; LAB_10008bcf
  10008bbf  LEA ECX,[EDI + -0x20]
  10008bc2  MOV EBX,0x80000000
  10008bc7  SHR EBX,CL
  10008bc9  MOV ECX,dword ptr [EBP + 0x8]
  10008bcc  OR dword ptr [ECX + 0x4],EBX
LAB_10008bcf:
  10008bcf  LEA ECX,[EDI + -0x20]
  10008bd2  MOV EDI,0x80000000
  10008bd7  SHR EDI,CL
  10008bd9  LEA EAX,[EAX + ESI*0x4 + 0xc4]
  10008be0  OR dword ptr [EAX],EDI
LAB_10008be2:
  10008be2  MOV EBX,dword ptr [EBP + -0xc]
LAB_10008be5:
  10008be5  MOV EAX,dword ptr [EBP + -0x10]
  10008be8  MOV dword ptr [EDX],EBX
  10008bea  MOV dword ptr [EBX + EDX*0x1 + -0x4],EBX
  10008bee  DEC dword ptr [EAX]
  10008bf0  JNZ 0x10008cf0    ; LAB_10008cf0
  10008bf6  MOV EAX,[0x10010a90]    ; DAT_10010a90
  10008bfb  TEST EAX,EAX
  10008bfd  JZ 0x10008ce2    ; LAB_10008ce2
  10008c03  MOV ECX,dword ptr [0x10010a88]    ; DAT_10010a88
  10008c09  MOV EDI,dword ptr [0x1000d050]    ; PTR_VirtualFree_1000d050
  10008c0f  SHL ECX,0xf
  10008c12  ADD ECX,dword ptr [EAX + 0xc]
  10008c15  MOV EBX,0x8000
  10008c1a  PUSH 0x4000
  10008c1f  PUSH EBX
  10008c20  PUSH ECX
  10008c21  CALL EDI    ; KERNEL32.DLL::VirtualFree
  10008c23  MOV ECX,dword ptr [0x10010a88]    ; DAT_10010a88
  10008c29  MOV EAX,[0x10010a90]    ; DAT_10010a90
  10008c2e  MOV EDX,0x80000000
  10008c33  SHR EDX,CL
  10008c35  OR dword ptr [EAX + 0x8],EDX
  10008c38  MOV EAX,[0x10010a90]    ; DAT_10010a90
  10008c3d  MOV ECX,dword ptr [0x10010a88]    ; DAT_10010a88
  10008c43  MOV EAX,dword ptr [EAX + 0x10]
  10008c46  AND dword ptr [EAX + ECX*0x4 + 0xc4],0x0
  10008c4e  MOV EAX,[0x10010a90]    ; DAT_10010a90
  10008c53  MOV EAX,dword ptr [EAX + 0x10]
  10008c56  DEC byte ptr [EAX + 0x43]
  10008c59  MOV EAX,[0x10010a90]    ; DAT_10010a90
  10008c5e  MOV ECX,dword ptr [EAX + 0x10]
  10008c61  CMP byte ptr [ECX + 0x43],0x0
  10008c65  JNZ 0x10008c70    ; LAB_10008c70
  10008c67  AND dword ptr [EAX + 0x4],0xfffffffe
  10008c6b  MOV EAX,[0x10010a90]    ; DAT_10010a90
LAB_10008c70:
  10008c70  CMP dword ptr [EAX + 0x8],-0x1
  10008c74  JNZ 0x10008ce2    ; LAB_10008ce2
  10008c76  PUSH EBX
  10008c77  PUSH 0x0
  10008c79  PUSH dword ptr [EAX + 0xc]
  10008c7c  CALL EDI    ; KERNEL32.DLL::VirtualFree
  10008c7e  MOV EAX,[0x10010a90]    ; DAT_10010a90
  10008c83  PUSH dword ptr [EAX + 0x10]
  10008c86  PUSH 0x0
  10008c88  PUSH dword ptr [0x10010ba4]    ; DAT_10010ba4
  10008c8e  CALL dword ptr [0x1000d034]    ; PTR_HeapFree_1000d034 KERNEL32.DLL::HeapFree
  10008c94  MOV EAX,[0x10010a94]    ; DAT_10010a94
  10008c99  MOV EDX,dword ptr [0x10010a98]    ; DAT_10010a98
  10008c9f  LEA EAX,[EAX + EAX*0x4]
  10008ca2  SHL EAX,0x2
  10008ca5  MOV ECX,EAX
  10008ca7  MOV EAX,[0x10010a90]    ; DAT_10010a90
  10008cac  SUB ECX,EAX
  10008cae  LEA ECX,[ECX + EDX*0x1 + -0x14]
  10008cb2  PUSH ECX
  10008cb3  LEA ECX,[EAX + 0x14]
  10008cb6  PUSH ECX
  10008cb7  PUSH EAX
  10008cb8  CALL 0x10008580    ; FUN_10008580
  10008cbd  MOV EAX,dword ptr [EBP + 0x8]
  10008cc0  ADD ESP,0xc
  10008cc3  DEC dword ptr [0x10010a94]    ; DAT_10010a94
  10008cc9  CMP EAX,dword ptr [0x10010a90]    ; DAT_10010a90
  10008ccf  JBE 0x10008cd4    ; LAB_10008cd4
  10008cd1  SUB EAX,0x14
LAB_10008cd4:
  10008cd4  MOV ECX,dword ptr [0x10010a98]    ; DAT_10010a98
  10008cda  MOV dword ptr [0x10010a8c],ECX    ; DAT_10010a8c
  10008ce0  JMP 0x10008ce5    ; LAB_10008ce5
LAB_10008ce2:
  10008ce2  MOV EAX,dword ptr [EBP + 0x8]
LAB_10008ce5:
  10008ce5  MOV [0x10010a90],EAX    ; DAT_10010a90
  10008cea  MOV dword ptr [0x10010a88],ESI    ; DAT_10010a88
LAB_10008cf0:
  10008cf0  POP EDI
  10008cf1  POP ESI
  10008cf2  POP EBX
  10008cf3  LEAVE
  10008cf4  RET

;==== FUNCTION FUN_10008cf5 @ 10008cf5 : int * FUN_10008cf5(uint * param_1)
  10008cf5  PUSH EBP
  10008cf6  MOV EBP,ESP
  10008cf8  SUB ESP,0x14
  10008cfb  MOV EAX,[0x10010a94]    ; DAT_10010a94
  10008d00  MOV EDX,dword ptr [0x10010a98]    ; DAT_10010a98
  10008d06  PUSH EBX
  10008d07  PUSH ESI
  10008d08  LEA EAX,[EAX + EAX*0x4]
  10008d0b  PUSH EDI
  10008d0c  LEA EDI,[EDX + EAX*0x4]
  10008d0f  MOV EAX,dword ptr [EBP + 0x8]
  10008d12  MOV dword ptr [EBP + -0x4],EDI
  10008d15  LEA ECX,[EAX + 0x17]
  10008d18  AND ECX,0xfffffff0
  10008d1b  MOV dword ptr [EBP + -0x10],ECX
  10008d1e  SAR ECX,0x4
  10008d21  DEC ECX
  10008d22  CMP ECX,0x20
  10008d25  JGE 0x10008d35    ; LAB_10008d35
  10008d27  OR ESI,0xffffffff
  10008d2a  SHR ESI,CL
  10008d2c  OR dword ptr [EBP + -0x8],0xffffffff
  10008d30  MOV dword ptr [EBP + -0xc],ESI
  10008d33  JMP 0x10008d45    ; LAB_10008d45
LAB_10008d35:
  10008d35  ADD ECX,-0x20
  10008d38  OR EAX,0xffffffff
  10008d3b  XOR ESI,ESI
  10008d3d  SHR EAX,CL
  10008d3f  MOV dword ptr [EBP + -0xc],ESI
  10008d42  MOV dword ptr [EBP + -0x8],EAX
LAB_10008d45:
  10008d45  MOV EAX,[0x10010a8c]    ; DAT_10010a8c
  10008d4a  MOV EBX,EAX
  10008d4c  CMP EBX,EDI
  10008d4e  MOV dword ptr [EBP + 0x8],EBX
  10008d51  JNC 0x10008d6c    ; LAB_10008d6c
LAB_10008d53:
  10008d53  MOV ECX,dword ptr [EBX + 0x4]
  10008d56  MOV EDI,dword ptr [EBX]
  10008d58  AND ECX,dword ptr [EBP + -0x8]
  10008d5b  AND EDI,ESI
  10008d5d  OR ECX,EDI
  10008d5f  JNZ 0x10008d6c    ; LAB_10008d6c
  10008d61  ADD EBX,0x14
  10008d64  CMP EBX,dword ptr [EBP + -0x4]
  10008d67  MOV dword ptr [EBP + 0x8],EBX
  10008d6a  JC 0x10008d53    ; LAB_10008d53
LAB_10008d6c:
  10008d6c  CMP EBX,dword ptr [EBP + -0x4]
  10008d6f  JNZ 0x10008dea    ; LAB_10008dea
  10008d71  MOV EBX,EDX
LAB_10008d73:
  10008d73  CMP EBX,EAX
  10008d75  MOV dword ptr [EBP + 0x8],EBX
  10008d78  JNC 0x10008d8f    ; LAB_10008d8f
  10008d7a  MOV ECX,dword ptr [EBX + 0x4]
  10008d7d  MOV EDI,dword ptr [EBX]
  10008d7f  AND ECX,dword ptr [EBP + -0x8]
  10008d82  AND EDI,ESI
  10008d84  OR ECX,EDI
  10008d86  JNZ 0x10008d8d    ; LAB_10008d8d
  10008d88  ADD EBX,0x14
  10008d8b  JMP 0x10008d73    ; LAB_10008d73
LAB_10008d8d:
  10008d8d  CMP EBX,EAX
LAB_10008d8f:
  10008d8f  JNZ 0x10008dea    ; LAB_10008dea
LAB_10008d91:
  10008d91  CMP EBX,dword ptr [EBP + -0x4]
  10008d94  JNC 0x10008da7    ; LAB_10008da7
  10008d96  CMP dword ptr [EBX + 0x8],0x0
  10008d9a  JNZ 0x10008da4    ; LAB_10008da4
  10008d9c  ADD EBX,0x14
  10008d9f  MOV dword ptr [EBP + 0x8],EBX
  10008da2  JMP 0x10008d91    ; LAB_10008d91
LAB_10008da4:
  10008da4  CMP EBX,dword ptr [EBP + -0x4]
LAB_10008da7:
  10008da7  JNZ 0x10008dcf    ; LAB_10008dcf
  10008da9  MOV EBX,EDX
LAB_10008dab:
  10008dab  CMP EBX,EAX
  10008dad  MOV dword ptr [EBP + 0x8],EBX
  10008db0  JNC 0x10008dbf    ; LAB_10008dbf
  10008db2  CMP dword ptr [EBX + 0x8],0x0
  10008db6  JNZ 0x10008dbd    ; LAB_10008dbd
  10008db8  ADD EBX,0x14
  10008dbb  JMP 0x10008dab    ; LAB_10008dab
LAB_10008dbd:
  10008dbd  CMP EBX,EAX
LAB_10008dbf:
  10008dbf  JNZ 0x10008dcf    ; LAB_10008dcf
  10008dc1  CALL 0x10008ffe    ; FUN_10008ffe
  10008dc6  MOV EBX,EAX
  10008dc8  TEST EBX,EBX
  10008dca  MOV dword ptr [EBP + 0x8],EBX
  10008dcd  JZ 0x10008de3    ; LAB_10008de3
LAB_10008dcf:
  10008dcf  PUSH EBX
  10008dd0  CALL 0x100090af    ; FUN_100090af
  10008dd5  POP ECX
  10008dd6  MOV ECX,dword ptr [EBX + 0x10]
  10008dd9  MOV dword ptr [ECX],EAX
  10008ddb  MOV EAX,dword ptr [EBX + 0x10]
  10008dde  CMP dword ptr [EAX],-0x1
  10008de1  JNZ 0x10008dea    ; LAB_10008dea
LAB_10008de3:
  10008de3  XOR EAX,EAX
  10008de5  JMP 0x10008ff9    ; LAB_10008ff9
LAB_10008dea:
  10008dea  MOV dword ptr [0x10010a8c],EBX    ; DAT_10010a8c
  10008df0  MOV EAX,dword ptr [EBX + 0x10]
  10008df3  MOV EDX,dword ptr [EAX]
  10008df5  CMP EDX,-0x1
  10008df8  MOV dword ptr [EBP + -0x4],EDX
  10008dfb  JZ 0x10008e11    ; LAB_10008e11
  10008dfd  MOV ECX,dword ptr [EAX + EDX*0x4 + 0xc4]
  10008e04  MOV EDI,dword ptr [EAX + EDX*0x4 + 0x44]
  10008e08  AND ECX,dword ptr [EBP + -0x8]
  10008e0b  AND EDI,ESI
  10008e0d  OR ECX,EDI
  10008e0f  JNZ 0x10008e48    ; LAB_10008e48
LAB_10008e11:
  10008e11  MOV EDX,dword ptr [EAX + 0xc4]
  10008e17  MOV ESI,dword ptr [EAX + 0x44]
  10008e1a  AND EDX,dword ptr [EBP + -0x8]
  10008e1d  AND ESI,dword ptr [EBP + -0xc]
  10008e20  AND dword ptr [EBP + -0x4],0x0
  10008e24  LEA ECX,[EAX + 0x44]
  10008e27  OR EDX,ESI
  10008e29  MOV ESI,dword ptr [EBP + -0xc]
  10008e2c  JNZ 0x10008e45    ; LAB_10008e45
LAB_10008e2e:
  10008e2e  MOV EDX,dword ptr [ECX + 0x84]
  10008e34  INC dword ptr [EBP + -0x4]
  10008e37  AND EDX,dword ptr [EBP + -0x8]
  10008e3a  ADD ECX,0x4
  10008e3d  MOV EDI,ESI
  10008e3f  AND EDI,dword ptr [ECX]
  10008e41  OR EDX,EDI
  10008e43  JZ 0x10008e2e    ; LAB_10008e2e
LAB_10008e45:
  10008e45  MOV EDX,dword ptr [EBP + -0x4]
LAB_10008e48:
  10008e48  MOV ECX,EDX
  10008e4a  XOR EDI,EDI
  10008e4c  IMUL ECX,ECX,0x204
  10008e52  LEA ECX,[ECX + EAX*0x1 + 0x144]
  10008e59  MOV dword ptr [EBP + -0xc],ECX
  10008e5c  MOV ECX,dword ptr [EAX + EDX*0x4 + 0x44]
  10008e60  AND ECX,ESI
  10008e62  JNZ 0x10008e71    ; LAB_10008e71
  10008e64  MOV ECX,dword ptr [EAX + EDX*0x4 + 0xc4]
  10008e6b  PUSH 0x20
  10008e6d  AND ECX,dword ptr [EBP + -0x8]
  10008e70  POP EDI
LAB_10008e71:
  10008e71  TEST ECX,ECX
  10008e73  JL 0x10008e7a    ; LAB_10008e7a
  10008e75  SHL ECX,0x1
  10008e77  INC EDI
  10008e78  JMP 0x10008e71    ; LAB_10008e71
LAB_10008e7a:
  10008e7a  MOV ECX,dword ptr [EBP + -0xc]
  10008e7d  MOV EDX,dword ptr [ECX + EDI*0x8 + 0x4]
  10008e81  MOV ECX,dword ptr [EDX]
  10008e83  SUB ECX,dword ptr [EBP + -0x10]
  10008e86  MOV ESI,ECX
  10008e88  MOV dword ptr [EBP + -0x8],ECX
  10008e8b  SAR ESI,0x4
  10008e8e  DEC ESI
  10008e8f  CMP ESI,0x3f
  10008e92  JLE 0x10008e97    ; LAB_10008e97
  10008e94  PUSH 0x3f
  10008e96  POP ESI
LAB_10008e97:
  10008e97  CMP ESI,EDI
  10008e99  JZ 0x10008fac    ; LAB_10008fac
  10008e9f  MOV ECX,dword ptr [EDX + 0x4]
  10008ea2  CMP ECX,dword ptr [EDX + 0x8]
  10008ea5  JNZ 0x10008f08    ; LAB_10008f08
  10008ea7  CMP EDI,0x20
  10008eaa  JGE 0x10008ed7    ; LAB_10008ed7
  10008eac  MOV EBX,0x80000000
  10008eb1  MOV ECX,EDI
  10008eb3  SHR EBX,CL
  10008eb5  MOV ECX,dword ptr [EBP + -0x4]
  10008eb8  LEA EDI,[EAX + EDI*0x1 + 0x4]
  10008ebc  NOT EBX
  10008ebe  MOV dword ptr [EBP + -0x14],EBX
  10008ec1  AND EBX,dword ptr [EAX + ECX*0x4 + 0x44]
  10008ec5  MOV dword ptr [EAX + ECX*0x4 + 0x44],EBX
  10008ec9  DEC byte ptr [EDI]
  10008ecb  JNZ 0x10008f05    ; LAB_10008f05
  10008ecd  MOV EBX,dword ptr [EBP + 0x8]
  10008ed0  MOV ECX,dword ptr [EBP + -0x14]
  10008ed3  AND dword ptr [EBX],ECX
  10008ed5  JMP 0x10008f08    ; LAB_10008f08
LAB_10008ed7:
  10008ed7  LEA ECX,[EDI + -0x20]
  10008eda  MOV EBX,0x80000000
  10008edf  SHR EBX,CL
  10008ee1  MOV ECX,dword ptr [EBP + -0x4]
  10008ee4  LEA EDI,[EAX + EDI*0x1 + 0x4]
  10008ee8  LEA ECX,[EAX + ECX*0x4 + 0xc4]
  10008eef  NOT EBX
  10008ef1  AND dword ptr [ECX],EBX
  10008ef3  DEC byte ptr [EDI]
  10008ef5  MOV dword ptr [EBP + -0x14],EBX
  10008ef8  JNZ 0x10008f05    ; LAB_10008f05
  10008efa  MOV EBX,dword ptr [EBP + 0x8]
  10008efd  MOV ECX,dword ptr [EBP + -0x14]
  10008f00  AND dword ptr [EBX + 0x4],ECX
  10008f03  JMP 0x10008f08    ; LAB_10008f08
LAB_10008f05:
  10008f05  MOV EBX,dword ptr [EBP + 0x8]
LAB_10008f08:
  10008f08  MOV ECX,dword ptr [EDX + 0x8]
  10008f0b  MOV EDI,dword ptr [EDX + 0x4]
  10008f0e  CMP dword ptr [EBP + -0x8],0x0
  10008f12  MOV dword ptr [ECX + 0x4],EDI
  10008f15  MOV ECX,dword ptr [EDX + 0x4]
  10008f18  MOV EDI,dword ptr [EDX + 0x8]
  10008f1b  MOV dword ptr [ECX + 0x8],EDI
  10008f1e  JZ 0x10008fb8    ; LAB_10008fb8
  10008f24  MOV ECX,dword ptr [EBP + -0xc]
  10008f27  MOV EDI,dword ptr [ECX + ESI*0x8 + 0x4]
  10008f2b  LEA ECX,[ECX + ESI*0x8]
  10008f2e  MOV dword ptr [EDX + 0x4],EDI
  10008f31  MOV dword ptr [EDX + 0x8],ECX
  10008f34  MOV dword ptr [ECX + 0x4],EDX
  10008f37  MOV ECX,dword ptr [EDX + 0x4]
  10008f3a  MOV dword ptr [ECX + 0x8],EDX
  10008f3d  MOV ECX,dword ptr [EDX + 0x4]
  10008f40  CMP ECX,dword ptr [EDX + 0x8]
  10008f43  JNZ 0x10008fa9    ; LAB_10008fa9
  10008f45  MOV CL,byte ptr [ESI + EAX*0x1 + 0x4]
  10008f49  CMP ESI,0x20
  10008f4c  MOV byte ptr [EBP + 0xb],CL
  10008f4f  JGE 0x10008f7a    ; LAB_10008f7a
  10008f51  INC CL
  10008f53  CMP byte ptr [EBP + 0xb],0x0
  10008f57  MOV byte ptr [ESI + EAX*0x1 + 0x4],CL
  10008f5b  JNZ 0x10008f68    ; LAB_10008f68
  10008f5d  MOV EDI,0x80000000
  10008f62  MOV ECX,ESI
  10008f64  SHR EDI,CL
  10008f66  OR dword ptr [EBX],EDI
LAB_10008f68:
  10008f68  MOV EDI,0x80000000
  10008f6d  MOV ECX,ESI
  10008f6f  SHR EDI,CL
  10008f71  MOV ECX,dword ptr [EBP + -0x4]
  10008f74  OR dword ptr [EAX + ECX*0x4 + 0x44],EDI
  10008f78  JMP 0x10008fa9    ; LAB_10008fa9
LAB_10008f7a:
  10008f7a  INC CL
  10008f7c  CMP byte ptr [EBP + 0xb],0x0
  10008f80  MOV byte ptr [ESI + EAX*0x1 + 0x4],CL
  10008f84  JNZ 0x10008f93    ; LAB_10008f93
  10008f86  LEA ECX,[ESI + -0x20]
  10008f89  MOV EDI,0x80000000
  10008f8e  SHR EDI,CL
  10008f90  OR dword ptr [EBX + 0x4],EDI
LAB_10008f93:
  10008f93  MOV ECX,dword ptr [EBP + -0x4]
  10008f96  LEA EDI,[EAX + ECX*0x4 + 0xc4]
  10008f9d  LEA ECX,[ESI + -0x20]
  10008fa0  MOV ESI,0x80000000
  10008fa5  SHR ESI,CL
  10008fa7  OR dword ptr [EDI],ESI
LAB_10008fa9:
  10008fa9  MOV ECX,dword ptr [EBP + -0x8]
LAB_10008fac:
  10008fac  TEST ECX,ECX
  10008fae  JZ 0x10008fbb    ; LAB_10008fbb
  10008fb0  MOV dword ptr [EDX],ECX
  10008fb2  MOV dword ptr [ECX + EDX*0x1 + -0x4],ECX
  10008fb6  JMP 0x10008fbb    ; LAB_10008fbb
LAB_10008fb8:
  10008fb8  MOV ECX,dword ptr [EBP + -0x8]
LAB_10008fbb:
  10008fbb  MOV ESI,dword ptr [EBP + -0x10]
  10008fbe  ADD EDX,ECX
  10008fc0  LEA ECX,[ESI + 0x1]
  10008fc3  MOV dword ptr [EDX],ECX
  10008fc5  MOV dword ptr [EDX + ESI*0x1 + -0x4],ECX
  10008fc9  MOV ESI,dword ptr [EBP + -0xc]
  10008fcc  MOV ECX,dword ptr [ESI]
  10008fce  TEST ECX,ECX
  10008fd0  LEA EDI,[ECX + 0x1]
  10008fd3  MOV dword ptr [ESI],EDI
  10008fd5  JNZ 0x10008ff1    ; LAB_10008ff1
  10008fd7  CMP EBX,dword ptr [0x10010a90]    ; DAT_10010a90
  10008fdd  JNZ 0x10008ff1    ; LAB_10008ff1
  10008fdf  MOV ECX,dword ptr [EBP + -0x4]
  10008fe2  CMP ECX,dword ptr [0x10010a88]    ; DAT_10010a88
  10008fe8  JNZ 0x10008ff1    ; LAB_10008ff1
  10008fea  AND dword ptr [0x10010a90],0x0    ; DAT_10010a90
LAB_10008ff1:
  10008ff1  MOV ECX,dword ptr [EBP + -0x4]
  10008ff4  MOV dword ptr [EAX],ECX
  10008ff6  LEA EAX,[EDX + 0x4]
LAB_10008ff9:
  10008ff9  POP EDI
  10008ffa  POP ESI
  10008ffb  POP EBX
  10008ffc  LEAVE
  10008ffd  RET

;==== FUNCTION FUN_10008ffe @ 10008ffe : undefined4 * FUN_10008ffe(void)
  10008ffe  MOV EAX,[0x10010a94]    ; DAT_10010a94
  10009003  MOV ECX,dword ptr [0x10010a84]    ; DAT_10010a84
  10009009  PUSH ESI
  1000900a  PUSH EDI
  1000900b  XOR EDI,EDI
  1000900d  CMP EAX,ECX
  1000900f  JNZ 0x10009041    ; LAB_10009041
  10009011  LEA EAX,[ECX + ECX*0x4 + 0x50]
  10009015  SHL EAX,0x2
  10009018  PUSH EAX
  10009019  PUSH dword ptr [0x10010a98]    ; DAT_10010a98
  1000901f  PUSH EDI
  10009020  PUSH dword ptr [0x10010ba4]    ; DAT_10010ba4
  10009026  CALL dword ptr [0x1000d084]    ; PTR_HeapReAlloc_1000d084 KERNEL32.DLL::HeapReAlloc
  1000902c  CMP EAX,EDI
  1000902e  JZ 0x10009091    ; LAB_10009091
  10009030  ADD dword ptr [0x10010a84],0x10    ; DAT_10010a84
  10009037  MOV [0x10010a98],EAX    ; DAT_10010a98
  1000903c  MOV EAX,[0x10010a94]    ; DAT_10010a94
LAB_10009041:
  10009041  MOV ECX,dword ptr [0x10010a98]    ; DAT_10010a98
  10009047  PUSH 0x41c4
  1000904c  PUSH 0x8
  1000904e  LEA EAX,[EAX + EAX*0x4]
  10009051  PUSH dword ptr [0x10010ba4]    ; DAT_10010ba4
  10009057  LEA ESI,[ECX + EAX*0x4]
  1000905a  CALL dword ptr [0x1000d038]    ; PTR_HeapAlloc_1000d038 KERNEL32.DLL::HeapAlloc
  10009060  CMP EAX,EDI
  10009062  MOV dword ptr [ESI + 0x10],EAX
  10009065  JZ 0x10009091    ; LAB_10009091
  10009067  PUSH 0x4
  10009069  PUSH 0x2000
  1000906e  PUSH 0x100000
  10009073  PUSH EDI
  10009074  CALL dword ptr [0x1000d080]    ; PTR_VirtualAlloc_1000d080 KERNEL32.DLL::VirtualAlloc
  1000907a  CMP EAX,EDI
  1000907c  MOV dword ptr [ESI + 0xc],EAX
  1000907f  JNZ 0x10009095    ; LAB_10009095
  10009081  PUSH dword ptr [ESI + 0x10]
  10009084  PUSH EDI
  10009085  PUSH dword ptr [0x10010ba4]    ; DAT_10010ba4
  1000908b  CALL dword ptr [0x1000d034]    ; PTR_HeapFree_1000d034 KERNEL32.DLL::HeapFree
LAB_10009091:
  10009091  XOR EAX,EAX
  10009093  JMP 0x100090ac    ; LAB_100090ac
LAB_10009095:
  10009095  OR dword ptr [ESI + 0x8],0xffffffff
  10009099  MOV dword ptr [ESI],EDI
  1000909b  MOV dword ptr [ESI + 0x4],EDI
  1000909e  INC dword ptr [0x10010a94]    ; DAT_10010a94
  100090a4  MOV EAX,dword ptr [ESI + 0x10]
  100090a7  OR dword ptr [EAX],0xffffffff
  100090aa  MOV EAX,ESI
LAB_100090ac:
  100090ac  POP EDI
  100090ad  POP ESI
  100090ae  RET

;==== FUNCTION FUN_100090af @ 100090af : int FUN_100090af(int param_1)
  100090af  PUSH EBP
  100090b0  MOV EBP,ESP
  100090b2  PUSH ECX
  100090b3  MOV ECX,dword ptr [EBP + 0x8]
  100090b6  PUSH EBX
  100090b7  PUSH ESI
  100090b8  PUSH EDI
  100090b9  MOV ESI,dword ptr [ECX + 0x10]
  100090bc  MOV EAX,dword ptr [ECX + 0x8]
  100090bf  XOR EBX,EBX
LAB_100090c1:
  100090c1  TEST EAX,EAX
  100090c3  JL 0x100090ca    ; LAB_100090ca
  100090c5  SHL EAX,0x1
  100090c7  INC EBX
  100090c8  JMP 0x100090c1    ; LAB_100090c1
LAB_100090ca:
  100090ca  MOV EAX,EBX
  100090cc  PUSH 0x3f
  100090ce  IMUL EAX,EAX,0x204
  100090d4  POP EDX
  100090d5  LEA EAX,[EAX + ESI*0x1 + 0x144]
  100090dc  MOV dword ptr [EBP + -0x4],EAX
LAB_100090df:
  100090df  MOV dword ptr [EAX + 0x8],EAX
  100090e2  MOV dword ptr [EAX + 0x4],EAX
  100090e5  ADD EAX,0x8
  100090e8  DEC EDX
  100090e9  JNZ 0x100090df    ; LAB_100090df
  100090eb  MOV EDI,EBX
  100090ed  PUSH 0x4
  100090ef  SHL EDI,0xf
  100090f2  ADD EDI,dword ptr [ECX + 0xc]
  100090f5  PUSH 0x1000
  100090fa  PUSH 0x8000
  100090ff  PUSH EDI
  10009100  CALL dword ptr [0x1000d080]    ; PTR_VirtualAlloc_1000d080 KERNEL32.DLL::VirtualAlloc
  10009106  TEST EAX,EAX
  10009108  JNZ 0x10009112    ; LAB_10009112
  1000910a  OR EAX,0xffffffff
  1000910d  JMP 0x100091a5    ; LAB_100091a5
LAB_10009112:
  10009112  LEA EDX,[EDI + 0x7000]
  10009118  CMP EDI,EDX
  1000911a  JA 0x10009158    ; LAB_10009158
  1000911c  LEA EAX,[EDI + 0x10]
LAB_1000911f:
  1000911f  OR dword ptr [EAX + -0x8],0xffffffff
  10009123  OR dword ptr [EAX + 0xfec],0xffffffff
  1000912a  LEA ECX,[EAX + 0xffc]
  10009130  MOV dword ptr [EAX + -0x4],0xff0
  10009137  MOV dword ptr [EAX],ECX
  10009139  LEA ECX,[EAX + 0xffffeffc]
  1000913f  MOV dword ptr [EAX + 0x4],ECX
  10009142  MOV dword ptr [EAX + 0xfe8],0xff0
  1000914c  ADD EAX,0x1000
  10009151  LEA ECX,[EAX + -0x10]
  10009154  CMP ECX,EDX
  10009156  JBE 0x1000911f    ; LAB_1000911f
LAB_10009158:
  10009158  MOV EAX,dword ptr [EBP + -0x4]
  1000915b  LEA ECX,[EDI + 0xc]
  1000915e  ADD EAX,0x1f8
  10009163  PUSH 0x1
  10009165  POP EDI
  10009166  MOV dword ptr [EAX + 0x4],ECX
  10009169  MOV dword ptr [ECX + 0x8],EAX
  1000916c  LEA ECX,[EDX + 0xc]
  1000916f  MOV dword ptr [EAX + 0x8],ECX
  10009172  MOV dword ptr [ECX + 0x4],EAX
  10009175  AND dword ptr [ESI + EBX*0x4 + 0x44],0x0
  1000917a  MOV dword ptr [ESI + EBX*0x4 + 0xc4],EDI
  10009181  MOV AL,byte ptr [ESI + 0x43]
  10009184  MOV CL,AL
  10009186  INC CL
  10009188  TEST AL,AL
  1000918a  MOV EAX,dword ptr [EBP + 0x8]
  1000918d  MOV byte ptr [ESI + 0x43],CL
  10009190  JNZ 0x10009195    ; LAB_10009195
  10009192  OR dword ptr [EAX + 0x4],EDI
LAB_10009195:
  10009195  MOV EDX,0x80000000
  1000919a  MOV ECX,EBX
  1000919c  SHR EDX,CL
  1000919e  NOT EDX
  100091a0  AND dword ptr [EAX + 0x8],EDX
  100091a3  MOV EAX,EBX
LAB_100091a5:
  100091a5  POP EDI
  100091a6  POP ESI
  100091a7  POP EBX
  100091a8  LEAVE
  100091a9  RET

;==== FUNCTION FUN_100091aa @ 100091aa : undefined4 FUN_100091aa(uint * param_1, int param_2, int param_3)
  100091aa  PUSH EBP
  100091ab  MOV EBP,ESP
  100091ad  SUB ESP,0xc
  100091b0  MOV ECX,dword ptr [EBP + 0x8]
  100091b3  MOV EAX,dword ptr [EBP + 0x10]
  100091b6  PUSH EBX
  100091b7  PUSH ESI
  100091b8  PUSH EDI
  100091b9  MOV EDI,dword ptr [EBP + 0xc]
  100091bc  MOV EDX,EDI
  100091be  LEA ESI,[EAX + 0x17]
  100091c1  SUB EDX,dword ptr [ECX + 0xc]
  100091c4  MOV EAX,dword ptr [ECX + 0x10]
  100091c7  AND ESI,0xfffffff0
  100091ca  SHR EDX,0xf
  100091cd  MOV ECX,EDX
  100091cf  IMUL ECX,ECX,0x204
  100091d5  LEA ECX,[ECX + EAX*0x1 + 0x144]
  100091dc  MOV dword ptr [EBP + -0xc],ECX
  100091df  MOV ECX,dword ptr [EDI + -0x4]
  100091e2  DEC ECX
  100091e3  CMP ESI,ECX
  100091e5  MOV dword ptr [EBP + 0x10],ECX
  100091e8  MOV EBX,dword ptr [ECX + EDI*0x1 + -0x4]
  100091ec  LEA EDI,[ECX + EDI*0x1 + -0x4]
  100091f0  MOV dword ptr [EBP + -0x4],EBX
  100091f3  JLE 0x10009358    ; LAB_10009358
  100091f9  TEST BL,0x1
  100091fc  JNZ 0x10009351    ; LAB_10009351
  10009202  ADD EBX,ECX
  10009204  CMP ESI,EBX
  10009206  JG 0x10009351    ; LAB_10009351
  1000920c  MOV ECX,dword ptr [EBP + -0x4]
  1000920f  SAR ECX,0x4
  10009212  DEC ECX
  10009213  CMP ECX,0x3f
  10009216  MOV dword ptr [EBP + -0x8],ECX
  10009219  JBE 0x10009221    ; LAB_10009221
  1000921b  PUSH 0x3f
  1000921d  POP ECX
  1000921e  MOV dword ptr [EBP + -0x8],ECX
LAB_10009221:
  10009221  MOV EBX,dword ptr [EDI + 0x4]
  10009224  CMP EBX,dword ptr [EDI + 0x8]
  10009227  JNZ 0x10009271    ; LAB_10009271
  10009229  CMP ECX,0x20
  1000922c  JNC 0x1000924d    ; LAB_1000924d
  1000922e  MOV EBX,0x80000000
  10009233  SHR EBX,CL
  10009235  MOV ECX,dword ptr [EBP + -0x8]
  10009238  LEA ECX,[ECX + EAX*0x1 + 0x4]
  1000923c  NOT EBX
  1000923e  AND dword ptr [EAX + EDX*0x4 + 0x44],EBX
  10009242  DEC byte ptr [ECX]
  10009244  JNZ 0x10009271    ; LAB_10009271
  10009246  MOV ECX,dword ptr [EBP + 0x8]
  10009249  AND dword ptr [ECX],EBX
  1000924b  JMP 0x10009271    ; LAB_10009271
LAB_1000924d:
  1000924d  ADD ECX,-0x20
  10009250  MOV EBX,0x80000000
  10009255  SHR EBX,CL
  10009257  MOV ECX,dword ptr [EBP + -0x8]
  1000925a  LEA ECX,[ECX + EAX*0x1 + 0x4]
  1000925e  NOT EBX
  10009260  AND dword ptr [EAX + EDX*0x4 + 0xc4],EBX
  10009267  DEC byte ptr [ECX]
  10009269  JNZ 0x10009271    ; LAB_10009271
  1000926b  MOV ECX,dword ptr [EBP + 0x8]
  1000926e  AND dword ptr [ECX + 0x4],EBX
LAB_10009271:
  10009271  MOV ECX,dword ptr [EDI + 0x8]
  10009274  MOV EBX,dword ptr [EDI + 0x4]
  10009277  MOV dword ptr [ECX + 0x4],EBX
  1000927a  MOV ECX,dword ptr [EDI + 0x4]
  1000927d  MOV EDI,dword ptr [EDI + 0x8]
  10009280  MOV dword ptr [ECX + 0x8],EDI
  10009283  MOV ECX,dword ptr [EBP + 0x10]
  10009286  SUB ECX,ESI
  10009288  ADD dword ptr [EBP + -0x4],ECX
  1000928b  CMP dword ptr [EBP + -0x4],0x0
  1000928f  JLE 0x1000933f    ; LAB_1000933f
  10009295  MOV EDI,dword ptr [EBP + -0x4]
  10009298  MOV ECX,dword ptr [EBP + 0xc]
  1000929b  SAR EDI,0x4
  1000929e  DEC EDI
  1000929f  LEA ECX,[ECX + ESI*0x1 + -0x4]
  100092a3  CMP EDI,0x3f
  100092a6  JBE 0x100092ab    ; LAB_100092ab
  100092a8  PUSH 0x3f
  100092aa  POP EDI
LAB_100092ab:
  100092ab  MOV EBX,dword ptr [EBP + -0xc]
  100092ae  LEA EBX,[EBX + EDI*0x8]
  100092b1  MOV dword ptr [EBP + 0x10],EBX
  100092b4  MOV EBX,dword ptr [EBX + 0x4]
  100092b7  MOV dword ptr [ECX + 0x4],EBX
  100092ba  MOV EBX,dword ptr [EBP + 0x10]
  100092bd  MOV dword ptr [ECX + 0x8],EBX
  100092c0  MOV dword ptr [EBX + 0x4],ECX
  100092c3  MOV EBX,dword ptr [ECX + 0x4]
  100092c6  MOV dword ptr [EBX + 0x8],ECX
  100092c9  MOV EBX,dword ptr [ECX + 0x4]
  100092cc  CMP EBX,dword ptr [ECX + 0x8]
  100092cf  JNZ 0x1000932d    ; LAB_1000932d
  100092d1  MOV CL,byte ptr [EDI + EAX*0x1 + 0x4]
  100092d5  CMP EDI,0x20
  100092d8  MOV byte ptr [EBP + 0x13],CL
  100092db  INC CL
  100092dd  MOV byte ptr [EDI + EAX*0x1 + 0x4],CL
  100092e1  JNC 0x10009304    ; LAB_10009304
  100092e3  CMP byte ptr [EBP + 0x13],0x0
  100092e7  JNZ 0x100092f7    ; LAB_100092f7
  100092e9  MOV EBX,0x80000000
  100092ee  MOV ECX,EDI
  100092f0  SHR EBX,CL
  100092f2  MOV ECX,dword ptr [EBP + 0x8]
  100092f5  OR dword ptr [ECX],EBX
LAB_100092f7:
  100092f7  LEA EAX,[EAX + EDX*0x4 + 0x44]
  100092fb  MOV EDX,0x80000000
  10009300  MOV ECX,EDI
  10009302  JMP 0x10009329    ; LAB_10009329
LAB_10009304:
  10009304  CMP byte ptr [EBP + 0x13],0x0
  10009308  JNZ 0x1000931a    ; LAB_1000931a
  1000930a  LEA ECX,[EDI + -0x20]
  1000930d  MOV EBX,0x80000000
  10009312  SHR EBX,CL
  10009314  MOV ECX,dword ptr [EBP + 0x8]
  10009317  OR dword ptr [ECX + 0x4],EBX
LAB_1000931a:
  1000931a  LEA EAX,[EAX + EDX*0x4 + 0xc4]
  10009321  LEA ECX,[EDI + -0x20]
  10009324  MOV EDX,0x80000000
LAB_10009329:
  10009329  SHR EDX,CL
  1000932b  OR dword ptr [EAX],EDX
LAB_1000932d:
  1000932d  MOV EDX,dword ptr [EBP + 0xc]
  10009330  MOV ECX,dword ptr [EBP + -0x4]
  10009333  LEA EAX,[EDX + ESI*0x1 + -0x4]
  10009337  MOV dword ptr [EAX],ECX
  10009339  MOV dword ptr [ECX + EAX*0x1 + -0x4],ECX
  1000933d  JMP 0x10009342    ; LAB_10009342
LAB_1000933f:
  1000933f  MOV EDX,dword ptr [EBP + 0xc]
LAB_10009342:
  10009342  LEA EAX,[ESI + 0x1]
  10009345  MOV dword ptr [EDX + -0x4],EAX
  10009348  MOV dword ptr [EDX + ESI*0x1 + -0x8],EAX
  1000934c  JMP 0x10009498    ; LAB_10009498
LAB_10009351:
  10009351  XOR EAX,EAX
  10009353  JMP 0x1000949b    ; LAB_1000949b
LAB_10009358:
  10009358  JGE 0x10009498    ; LAB_10009498
  1000935e  MOV EBX,dword ptr [EBP + 0xc]
  10009361  SUB dword ptr [EBP + 0x10],ESI
  10009364  LEA ECX,[ESI + 0x1]
  10009367  MOV dword ptr [EBX + -0x4],ECX
  1000936a  LEA EBX,[EBX + ESI*0x1 + -0x4]
  1000936e  MOV ESI,dword ptr [EBP + 0x10]
  10009371  MOV dword ptr [EBP + 0xc],EBX
  10009374  SAR ESI,0x4
  10009377  DEC ESI
  10009378  MOV dword ptr [EBX + -0x4],ECX
  1000937b  CMP ESI,0x3f
  1000937e  JBE 0x10009383    ; LAB_10009383
  10009380  PUSH 0x3f
  10009382  POP ESI
LAB_10009383:
  10009383  TEST byte ptr [EBP + -0x4],0x1
  10009387  JNZ 0x10009412    ; LAB_10009412
  1000938d  MOV ESI,dword ptr [EBP + -0x4]
  10009390  SAR ESI,0x4
  10009393  DEC ESI
  10009394  CMP ESI,0x3f
  10009397  JBE 0x1000939c    ; LAB_1000939c
  10009399  PUSH 0x3f
  1000939b  POP ESI
LAB_1000939c:
  1000939c  MOV ECX,dword ptr [EDI + 0x4]
  1000939f  CMP ECX,dword ptr [EDI + 0x8]
  100093a2  JNZ 0x100093eb    ; LAB_100093eb
  100093a4  CMP ESI,0x20
  100093a7  JNC 0x100093c7    ; LAB_100093c7
  100093a9  MOV EBX,0x80000000
  100093ae  MOV ECX,ESI
  100093b0  SHR EBX,CL
  100093b2  LEA ESI,[ESI + EAX*0x1 + 0x4]
  100093b6  NOT EBX
  100093b8  AND dword ptr [EAX + EDX*0x4 + 0x44],EBX
  100093bc  DEC byte ptr [ESI]
  100093be  JNZ 0x100093e8    ; LAB_100093e8
  100093c0  MOV ECX,dword ptr [EBP + 0x8]
  100093c3  AND dword ptr [ECX],EBX
  100093c5  JMP 0x100093e8    ; LAB_100093e8
LAB_100093c7:
  100093c7  LEA ECX,[ESI + -0x20]
  100093ca  MOV EBX,0x80000000
  100093cf  SHR EBX,CL
  100093d1  LEA ECX,[ESI + EAX*0x1 + 0x4]
  100093d5  NOT EBX
  100093d7  AND dword ptr [EAX + EDX*0x4 + 0xc4],EBX
  100093de  DEC byte ptr [ECX]
  100093e0  JNZ 0x100093e8    ; LAB_100093e8
  100093e2  MOV ECX,dword ptr [EBP + 0x8]
  100093e5  AND dword ptr [ECX + 0x4],EBX
LAB_100093e8:
  100093e8  MOV EBX,dword ptr [EBP + 0xc]
LAB_100093eb:
  100093eb  MOV ECX,dword ptr [EDI + 0x8]
  100093ee  MOV ESI,dword ptr [EDI + 0x4]
  100093f1  MOV dword ptr [ECX + 0x4],ESI
  100093f4  MOV ECX,dword ptr [EDI + 0x4]
  100093f7  MOV ESI,dword ptr [EDI + 0x8]
  100093fa  MOV dword ptr [ECX + 0x8],ESI
  100093fd  MOV ESI,dword ptr [EBP + 0x10]
  10009400  ADD ESI,dword ptr [EBP + -0x4]
  10009403  MOV dword ptr [EBP + 0x10],ESI
  10009406  SAR ESI,0x4
  10009409  DEC ESI
  1000940a  CMP ESI,0x3f
  1000940d  JBE 0x10009412    ; LAB_10009412
  1000940f  PUSH 0x3f
  10009411  POP ESI
LAB_10009412:
  10009412  MOV ECX,dword ptr [EBP + -0xc]
  10009415  MOV EDI,dword ptr [ECX + ESI*0x8 + 0x4]
  10009419  LEA ECX,[ECX + ESI*0x8]
  1000941c  MOV dword ptr [EBX + 0x4],EDI
  1000941f  MOV dword ptr [EBX + 0x8],ECX
  10009422  MOV dword ptr [ECX + 0x4],EBX
  10009425  MOV ECX,dword ptr [EBX + 0x4]
  10009428  MOV dword ptr [ECX + 0x8],EBX
  1000942b  MOV ECX,dword ptr [EBX + 0x4]
  1000942e  CMP ECX,dword ptr [EBX + 0x8]
  10009431  JNZ 0x1000948f    ; LAB_1000948f
  10009433  MOV CL,byte ptr [ESI + EAX*0x1 + 0x4]
  10009437  CMP ESI,0x20
  1000943a  MOV byte ptr [EBP + 0xf],CL
  1000943d  INC CL
  1000943f  MOV byte ptr [ESI + EAX*0x1 + 0x4],CL
  10009443  JNC 0x10009466    ; LAB_10009466
  10009445  CMP byte ptr [EBP + 0xf],0x0
  10009449  JNZ 0x10009459    ; LAB_10009459
  1000944b  MOV EDI,0x80000000
  10009450  MOV ECX,ESI
  10009452  SHR EDI,CL
  10009454  MOV ECX,dword ptr [EBP + 0x8]
  10009457  OR dword ptr [ECX],EDI
LAB_10009459:
  10009459  LEA EAX,[EAX + EDX*0x4 + 0x44]
  1000945d  MOV EDX,0x80000000
  10009462  MOV ECX,ESI
  10009464  JMP 0x1000948b    ; LAB_1000948b
LAB_10009466:
  10009466  CMP byte ptr [EBP + 0xf],0x0
  1000946a  JNZ 0x1000947c    ; LAB_1000947c
  1000946c  LEA ECX,[ESI + -0x20]
  1000946f  MOV EDI,0x80000000
  10009474  SHR EDI,CL
  10009476  MOV ECX,dword ptr [EBP + 0x8]
  10009479  OR dword ptr [ECX + 0x4],EDI
LAB_1000947c:
  1000947c  LEA EAX,[EAX + EDX*0x4 + 0xc4]
  10009483  LEA ECX,[ESI + -0x20]
  10009486  MOV EDX,0x80000000
LAB_1000948b:
  1000948b  SHR EDX,CL
  1000948d  OR dword ptr [EAX],EDX
LAB_1000948f:
  1000948f  MOV EAX,dword ptr [EBP + 0x10]
  10009492  MOV dword ptr [EBX],EAX
  10009494  MOV dword ptr [EAX + EBX*0x1 + -0x4],EAX
LAB_10009498:
  10009498  PUSH 0x1
  1000949a  POP EAX
LAB_1000949b:
  1000949b  POP EDI
  1000949c  POP ESI
  1000949d  POP EBX
  1000949e  LEAVE
  1000949f  RET

;==== FUNCTION FUN_10009571 @ 10009571 : undefined4 FUN_10009571(void)
  10009571  PUSH EBP
  10009572  MOV EBP,ESP
  10009574  SUB ESP,0x13c
  1000957a  MOV EAX,[0x10010a94]    ; DAT_10010a94
  1000957f  PUSH EBX
  10009580  PUSH ESI
  10009581  PUSH EDI
  10009582  LEA EAX,[EAX + EAX*0x4]
  10009585  SHL EAX,0x2
  10009588  PUSH EAX
  10009589  PUSH dword ptr [0x10010a98]    ; DAT_10010a98
  1000958f  CALL dword ptr [0x1000d088]    ; PTR_IsBadWritePtr_1000d088 KERNEL32.DLL::IsBadWritePtr
  10009595  TEST EAX,EAX
  10009597  JZ 0x100095a1    ; LAB_100095a1
  10009599  OR EAX,0xffffffff
  1000959c  JMP 0x1000985e    ; LAB_1000985e
LAB_100095a1:
  100095a1  MOV EBX,dword ptr [0x10010a98]    ; DAT_10010a98
  100095a7  XOR EDI,EDI
  100095a9  CMP dword ptr [0x10010a94],EDI    ; DAT_10010a94
  100095af  MOV dword ptr [EBP + -0x38],EBX
  100095b2  MOV dword ptr [EBP + -0x20],EDI
  100095b5  JLE 0x1000985c    ; LAB_1000985c
  100095bb  JMP 0x100095bf    ; LAB_100095bf
LAB_100095bd:
  100095bd  XOR EDI,EDI
LAB_100095bf:
  100095bf  MOV ESI,dword ptr [EBX + 0x10]
  100095c2  PUSH 0x41c4
  100095c7  PUSH ESI
  100095c8  CALL dword ptr [0x1000d088]    ; PTR_IsBadWritePtr_1000d088 KERNEL32.DLL::IsBadWritePtr
  100095ce  TEST EAX,EAX
  100095d0  JNZ 0x10009863    ; LAB_10009863
  100095d6  MOV EAX,dword ptr [EBX + 0xc]
  100095d9  MOV dword ptr [EBP + -0x2c],EDI
  100095dc  MOV dword ptr [EBP + -0xc],EAX
  100095df  LEA EAX,[ESI + 0x144]
  100095e5  MOV dword ptr [EBP + -0x28],EAX
  100095e8  MOV EAX,dword ptr [EBX + 0x8]
  100095eb  ADD ESI,0xc4
  100095f1  MOV dword ptr [EBP + -0x14],EAX
  100095f4  MOV dword ptr [EBP + -0x18],EDI
  100095f7  MOV dword ptr [EBP + -0x30],EDI
  100095fa  MOV dword ptr [EBP + -0x3c],ESI
  100095fd  JMP 0x10009601    ; LAB_10009601
LAB_100095ff:
  100095ff  XOR EDI,EDI
LAB_10009601:
  10009601  PUSH 0x40
  10009603  MOV dword ptr [EBP + -0x24],EDI
  10009606  MOV dword ptr [EBP + -0x1c],EDI
  10009609  MOV dword ptr [EBP + -0x4],EDI
  1000960c  XOR EAX,EAX
  1000960e  POP ECX
  1000960f  CMP dword ptr [EBP + -0x14],EAX
  10009612  LEA EDI,[EBP + 0xfffffec4]
  10009618  STOSD.REP ES:EDI
  1000961a  JL 0x100097fa    ; LAB_100097fa
  10009620  PUSH 0x8000
  10009625  PUSH dword ptr [EBP + -0xc]
  10009628  CALL dword ptr [0x1000d088]    ; PTR_IsBadWritePtr_1000d088 KERNEL32.DLL::IsBadWritePtr
  1000962e  TEST EAX,EAX
  10009630  JNZ 0x10009867    ; LAB_10009867
  10009636  MOV EAX,dword ptr [EBP + -0xc]
  10009639  XOR EBX,EBX
  1000963b  LEA EDX,[EAX + 0xffc]
LAB_10009641:
  10009641  CMP dword ptr [EDX + 0xfffff00c],-0x1
  10009648  LEA ESI,[EDX + 0xfffff010]
  1000964e  JNZ 0x10009877    ; LAB_10009877
  10009654  CMP dword ptr [EDX],-0x1
  10009657  JNZ 0x10009877    ; LAB_10009877
LAB_1000965d:
  1000965d  MOV ECX,dword ptr [ESI]
  1000965f  TEST CL,0x1
  10009662  MOV EDI,ECX
  10009664  JZ 0x10009678    ; LAB_10009678
  10009666  DEC ECX
  10009667  CMP ECX,0x400
  1000966d  JG 0x1000986b    ; LAB_1000986b
  10009673  INC dword ptr [EBP + -0x4]
  10009676  JMP 0x10009694    ; LAB_10009694
LAB_10009678:
  10009678  MOV EAX,ECX
  1000967a  SAR EAX,0x4
  1000967d  DEC EAX
  1000967e  CMP EAX,0x3f
  10009681  JLE 0x10009686    ; LAB_10009686
  10009683  PUSH 0x3f
  10009685  POP EAX
LAB_10009686:
  10009686  INC dword ptr [EBP + EAX*0x4 + 0xfffffec4]
  1000968d  LEA EAX,[EBP + EAX*0x4 + 0xfffffec4]
LAB_10009694:
  10009694  CMP ECX,0x10
  10009697  JL 0x10009873    ; LAB_10009873
  1000969d  TEST CL,0xf
  100096a0  JNZ 0x10009873    ; LAB_10009873
  100096a6  CMP ECX,0xff0
  100096ac  JG 0x10009873    ; LAB_10009873
  100096b2  CMP dword ptr [ECX + ESI*0x1 + -0x4],EDI
  100096b6  LEA EAX,[ECX + ESI*0x1]
  100096b9  JNZ 0x1000986f    ; LAB_1000986f
  100096bf  MOV ESI,EAX
  100096c1  CMP ESI,EDX
  100096c3  JC 0x1000965d    ; LAB_1000965d
  100096c5  JNZ 0x1000986f    ; LAB_1000986f
  100096cb  ADD EDX,0x1000
  100096d1  INC EBX
  100096d2  CMP EBX,0x8
  100096d5  JL 0x10009641    ; LAB_10009641
  100096db  MOV ESI,dword ptr [EBP + -0x28]
  100096de  MOV EAX,dword ptr [EBP + -0x4]
  100096e1  CMP dword ptr [ESI],EAX
  100096e3  JNZ 0x1000987b    ; LAB_1000987b
  100096e9  AND dword ptr [EBP + -0x8],0x0
  100096ed  LEA EAX,[EBP + 0xfffffec4]
  100096f3  MOV dword ptr [EBP + -0x4],EAX
LAB_100096f6:
  100096f6  MOV EAX,dword ptr [ESI + 0x4]
  100096f9  AND dword ptr [EBP + -0x10],0x0
  100096fd  LEA EDI,[ESI + 0x8]
  10009700  MOV EDX,ESI
  10009702  CMP EAX,ESI
  10009704  MOV dword ptr [EBP + -0x34],EDX
  10009707  JZ 0x100097c2    ; LAB_100097c2
LAB_1000970d:
  1000970d  MOV EBX,dword ptr [EBP + -0x4]
  10009710  MOV ECX,dword ptr [EBP + -0x10]
  10009713  CMP ECX,dword ptr [EBX]
  10009715  JZ 0x10009795    ; LAB_10009795
  10009717  MOV ECX,dword ptr [EBP + -0xc]
  1000971a  CMP EAX,ECX
  1000971c  JC 0x1000988b    ; LAB_1000988b
  10009722  ADD ECX,0x8000
  10009728  CMP EAX,ECX
  1000972a  JNC 0x1000988b    ; LAB_1000988b
  10009730  MOV ECX,EAX
  10009732  AND CX,0xf000
  10009737  ADD ECX,0xc
  1000973a  LEA EDX,[ECX + 0xff0]
  10009740  CMP ECX,EDX
  10009742  JZ 0x1000987f    ; LAB_1000987f
LAB_10009748:
  10009748  CMP ECX,EAX
  1000974a  JZ 0x10009757    ; LAB_10009757
  1000974c  MOV EBX,dword ptr [ECX]
  1000974e  AND EBX,0xfffffffe
  10009751  ADD ECX,EBX
  10009753  CMP ECX,EDX
  10009755  JNZ 0x10009748    ; LAB_10009748
LAB_10009757:
  10009757  CMP ECX,EDX
  10009759  JZ 0x1000987f    ; LAB_1000987f
  1000975f  MOV ECX,dword ptr [EAX]
  10009761  SAR ECX,0x4
  10009764  DEC ECX
  10009765  CMP ECX,0x3f
  10009768  JLE 0x1000976d    ; LAB_1000976d
  1000976a  PUSH 0x3f
  1000976c  POP ECX
LAB_1000976d:
  1000976d  CMP ECX,dword ptr [EBP + -0x8]
  10009770  JNZ 0x10009883    ; LAB_10009883
  10009776  MOV ECX,dword ptr [EBP + -0x34]
  10009779  CMP dword ptr [EAX + 0x8],ECX
  1000977c  JNZ 0x10009887    ; LAB_10009887
  10009782  INC dword ptr [EBP + -0x10]
  10009785  MOV EDX,EAX
  10009787  MOV EAX,dword ptr [EAX + 0x4]
  1000978a  MOV dword ptr [EBP + -0x34],EDX
  1000978d  CMP EAX,ESI
  1000978f  JNZ 0x1000970d    ; LAB_1000970d
LAB_10009795:
  10009795  CMP dword ptr [EBP + -0x10],0x0
  10009799  JZ 0x100097c2    ; LAB_100097c2
  1000979b  MOV ECX,dword ptr [EBP + -0x8]
  1000979e  CMP ECX,0x20
  100097a1  JGE 0x100097b2    ; LAB_100097b2
  100097a3  MOV EAX,0x80000000
  100097a8  SHR EAX,CL
  100097aa  OR dword ptr [EBP + -0x24],EAX
  100097ad  OR dword ptr [EBP + -0x2c],EAX
  100097b0  JMP 0x100097c2    ; LAB_100097c2
LAB_100097b2:
  100097b2  ADD ECX,-0x20
  100097b5  MOV EAX,0x80000000
  100097ba  SHR EAX,CL
  100097bc  OR dword ptr [EBP + -0x1c],EAX
  100097bf  OR dword ptr [EBP + -0x18],EAX
LAB_100097c2:
  100097c2  CMP dword ptr [EDX + 0x4],ESI
  100097c5  JNZ 0x10009893    ; LAB_10009893
  100097cb  MOV ECX,dword ptr [EBP + -0x4]
  100097ce  MOV EAX,dword ptr [EBP + -0x10]
  100097d1  CMP EAX,dword ptr [ECX]
  100097d3  JNZ 0x10009893    ; LAB_10009893
  100097d9  CMP dword ptr [EDI],EDX
  100097db  JNZ 0x1000988f    ; LAB_1000988f
  100097e1  INC dword ptr [EBP + -0x8]
  100097e4  ADD dword ptr [EBP + -0x4],0x4
  100097e8  CMP dword ptr [EBP + -0x8],0x40
  100097ec  MOV ESI,EDI
  100097ee  JL 0x100096f6    ; LAB_100096f6
  100097f4  MOV ESI,dword ptr [EBP + -0x3c]
  100097f7  MOV EBX,dword ptr [EBP + -0x38]
LAB_100097fa:
  100097fa  MOV EAX,dword ptr [EBP + -0x24]
  100097fd  CMP EAX,dword ptr [ESI + -0x80]
  10009800  JNZ 0x10009897    ; LAB_10009897
  10009806  MOV EAX,dword ptr [EBP + -0x1c]
  10009809  CMP EAX,dword ptr [ESI]
  1000980b  JNZ 0x10009897    ; LAB_10009897
  10009811  ADD dword ptr [EBP + -0xc],0x8000
  10009818  ADD dword ptr [EBP + -0x28],0x204
  1000981f  SHL dword ptr [EBP + -0x14],0x1
  10009822  INC dword ptr [EBP + -0x30]
  10009825  ADD ESI,0x4
  10009828  CMP dword ptr [EBP + -0x30],0x20
  1000982c  MOV dword ptr [EBP + -0x3c],ESI
  1000982f  JL 0x100095ff    ; LAB_100095ff
  10009835  MOV EAX,dword ptr [EBP + -0x2c]
  10009838  CMP EAX,dword ptr [EBX]
  1000983a  JNZ 0x1000989b    ; LAB_1000989b
  1000983c  MOV EAX,dword ptr [EBP + -0x18]
  1000983f  CMP EAX,dword ptr [EBX + 0x4]
  10009842  JNZ 0x1000989b    ; LAB_1000989b
  10009844  ADD EBX,0x14
  10009847  INC dword ptr [EBP + -0x20]
  1000984a  MOV EAX,dword ptr [EBP + -0x20]
  1000984d  MOV dword ptr [EBP + -0x38],EBX
  10009850  CMP EAX,dword ptr [0x10010a94]    ; DAT_10010a94
  10009856  JL 0x100095bd    ; LAB_100095bd
LAB_1000985c:
  1000985c  XOR EAX,EAX
LAB_1000985e:
  1000985e  POP EDI
  1000985f  POP ESI
  10009860  POP EBX
  10009861  LEAVE
  10009862  RET
LAB_10009863:
  10009863  PUSH -0x2
  10009865  JMP 0x1000989d    ; LAB_1000989d
LAB_10009867:
  10009867  PUSH -0x4
  10009869  JMP 0x1000989d    ; LAB_1000989d
LAB_1000986b:
  1000986b  PUSH -0x6
  1000986d  JMP 0x1000989d    ; LAB_1000989d
LAB_1000986f:
  1000986f  PUSH -0x8
  10009871  JMP 0x1000989d    ; LAB_1000989d
LAB_10009873:
  10009873  PUSH -0x7
  10009875  JMP 0x1000989d    ; LAB_1000989d
LAB_10009877:
  10009877  PUSH -0x5
  10009879  JMP 0x1000989d    ; LAB_1000989d
LAB_1000987b:
  1000987b  PUSH -0x9
  1000987d  JMP 0x1000989d    ; LAB_1000989d
LAB_1000987f:
  1000987f  PUSH -0xb
  10009881  JMP 0x1000989d    ; LAB_1000989d
LAB_10009883:
  10009883  PUSH -0xc
  10009885  JMP 0x1000989d    ; LAB_1000989d
LAB_10009887:
  10009887  PUSH -0xd
  10009889  JMP 0x1000989d    ; LAB_1000989d
LAB_1000988b:
  1000988b  PUSH -0xa
  1000988d  JMP 0x1000989d    ; LAB_1000989d
LAB_1000988f:
  1000988f  PUSH -0xf
  10009891  JMP 0x1000989d    ; LAB_1000989d
LAB_10009893:
  10009893  PUSH -0xe
  10009895  JMP 0x1000989d    ; LAB_1000989d
LAB_10009897:
  10009897  PUSH -0x10
  10009899  JMP 0x1000989d    ; LAB_1000989d
LAB_1000989b:
  1000989b  PUSH -0x11
LAB_1000989d:
  1000989d  POP EAX
  1000989e  JMP 0x1000985e    ; LAB_1000985e

;==== FUNCTION FUN_100098b6 @ 100098b6 : undefined4 FUN_100098b6(undefined4 param_1)
  100098b6  MOV EAX,[0x1000f7dc]    ; DAT_1000f7dc
  100098bb  TEST EAX,EAX
  100098bd  JZ 0x100098ce    ; LAB_100098ce
  100098bf  PUSH dword ptr [ESP + 0x4]
  100098c3  CALL EAX
  100098c5  TEST EAX,EAX
  100098c7  POP ECX
  100098c8  JZ 0x100098ce    ; LAB_100098ce
  100098ca  PUSH 0x1
  100098cc  POP EAX
  100098cd  RET
LAB_100098ce:
  100098ce  XOR EAX,EAX
  100098d0  RET

;==== FUNCTION FUN_100098d1 @ 100098d1 : DWORD FUN_100098d1(uint param_1, LONG param_2, DWORD param_3)
  100098d1  MOV EAX,dword ptr [ESP + 0x4]
  100098d5  PUSH EBX
  100098d6  CMP EAX,dword ptr [0x10010ba0]    ; DAT_10010ba0
  100098dc  PUSH ESI
  100098dd  PUSH EDI
  100098de  JNC 0x10009953    ; LAB_10009953
  100098e0  MOV ECX,EAX
  100098e2  MOV ESI,EAX
  100098e4  SAR ECX,0x5
  100098e7  AND ESI,0x1f
  100098ea  LEA EDI,[ECX*0x4 + 0x10010aa0]    ; DAT_10010aa0
  100098f1  SHL ESI,0x3
  100098f4  MOV ECX,dword ptr [EDI]    ; DAT_10010aa0
  100098f6  TEST byte ptr [ECX + ESI*0x1 + 0x4],0x1
  100098fb  JZ 0x10009953    ; LAB_10009953
  100098fd  PUSH EAX
  100098fe  CALL 0x1000b8cf    ; FUN_1000b8cf
  10009903  CMP EAX,-0x1
  10009906  POP ECX
  10009907  JNZ 0x10009915    ; LAB_10009915
  10009909  MOV dword ptr [0x1000f64c],0x9    ; DAT_1000f64c
  10009913  JMP 0x10009964    ; LAB_10009964
LAB_10009915:
  10009915  PUSH dword ptr [ESP + 0x18]
  10009919  PUSH 0x0
  1000991b  PUSH dword ptr [ESP + 0x1c]
  1000991f  PUSH EAX
  10009920  CALL dword ptr [0x1000d090]    ; PTR_SetFilePointer_1000d090 KERNEL32.DLL::SetFilePointer
  10009926  MOV EBX,EAX
  10009928  CMP EBX,-0x1
  1000992b  JNZ 0x10009935    ; LAB_10009935
  1000992d  CALL dword ptr [0x1000d08c]    ; PTR_GetLastError_1000d08c KERNEL32.DLL::GetLastError
  10009933  JMP 0x10009937    ; LAB_10009937
LAB_10009935:
  10009935  XOR EAX,EAX
LAB_10009937:
  10009937  TEST EAX,EAX
  10009939  JZ 0x10009944    ; LAB_10009944
  1000993b  PUSH EAX
  1000993c  CALL 0x1000b6e2    ; FUN_1000b6e2
  10009941  POP ECX
  10009942  JMP 0x10009964    ; LAB_10009964
LAB_10009944:
  10009944  MOV EAX,dword ptr [EDI]    ; DAT_10010aa0
  10009946  AND byte ptr [EAX + ESI*0x1 + 0x4],0xfd
  1000994b  LEA EAX,[EAX + ESI*0x1 + 0x4]
  1000994f  MOV EAX,EBX
  10009951  JMP 0x10009967    ; LAB_10009967
LAB_10009953:
  10009953  AND dword ptr [0x1000f650],0x0    ; DAT_1000f650
  1000995a  MOV dword ptr [0x1000f64c],0x9    ; DAT_1000f64c
LAB_10009964:
  10009964  OR EAX,0xffffffff
LAB_10009967:
  10009967  POP EDI
  10009968  POP ESI
  10009969  POP EBX
  1000996a  RET

;==== FUNCTION FUN_1000996b @ 1000996b : int FUN_1000996b(DWORD param_1, char * param_2, uint param_3)
  1000996b  PUSH EBP
  1000996c  MOV EBP,ESP
  1000996e  SUB ESP,0x414
  10009974  MOV ECX,dword ptr [EBP + 0x8]
  10009977  PUSH EBX
  10009978  CMP ECX,dword ptr [0x10010ba0]    ; DAT_10010ba0
  1000997e  PUSH ESI
  1000997f  PUSH EDI
  10009980  JNC 0x10009aff    ; LAB_10009aff
  10009986  MOV EAX,ECX
  10009988  MOV ESI,ECX
  1000998a  SAR EAX,0x5
  1000998d  AND ESI,0x1f
  10009990  LEA EBX,[EAX*0x4 + 0x10010aa0]    ; DAT_10010aa0
  10009997  SHL ESI,0x3
  1000999a  MOV EAX,dword ptr [EBX]    ; DAT_10010aa0
  1000999c  MOV AL,byte ptr [EAX + ESI*0x1 + 0x4]
  100099a0  TEST AL,0x1
  100099a2  JZ 0x10009aff    ; LAB_10009aff
  100099a8  XOR EDI,EDI
  100099aa  CMP dword ptr [EBP + 0x10],EDI
  100099ad  MOV dword ptr [EBP + -0x8],EDI
  100099b0  MOV dword ptr [EBP + -0x10],EDI
  100099b3  JNZ 0x100099bc    ; LAB_100099bc
LAB_100099b5:
  100099b5  XOR EAX,EAX
  100099b7  JMP 0x10009b13    ; LAB_10009b13
LAB_100099bc:
  100099bc  TEST AL,0x20
  100099be  JZ 0x100099cc    ; LAB_100099cc
  100099c0  PUSH 0x2
  100099c2  PUSH EDI
  100099c3  PUSH ECX
  100099c4  CALL 0x100098d1    ; FUN_100098d1
  100099c9  ADD ESP,0xc
LAB_100099cc:
  100099cc  MOV EAX,dword ptr [EBX]    ; DAT_10010aa0
  100099ce  ADD EAX,ESI
  100099d0  TEST byte ptr [EAX + 0x4],0x80
  100099d4  JZ 0x10009a9b    ; LAB_10009a9b
  100099da  MOV EAX,dword ptr [EBP + 0xc]
  100099dd  CMP dword ptr [EBP + 0x10],EDI
  100099e0  MOV dword ptr [EBP + -0x4],EAX
  100099e3  MOV dword ptr [EBP + 0x8],EDI
  100099e6  JBE 0x10009ad3    ; LAB_10009ad3
LAB_100099ec:
  100099ec  LEA EAX,[EBP + 0xfffffbec]
LAB_100099f2:
  100099f2  MOV ECX,dword ptr [EBP + -0x4]
  100099f5  SUB ECX,dword ptr [EBP + 0xc]
  100099f8  CMP ECX,dword ptr [EBP + 0x10]
  100099fb  JNC 0x10009a26    ; LAB_10009a26
  100099fd  MOV ECX,dword ptr [EBP + -0x4]
  10009a00  INC dword ptr [EBP + -0x4]
  10009a03  MOV CL,byte ptr [ECX]
  10009a05  CMP CL,0xa
  10009a08  JNZ 0x10009a11    ; LAB_10009a11
  10009a0a  INC dword ptr [EBP + -0x10]
  10009a0d  MOV byte ptr [EAX],0xd
  10009a10  INC EAX
LAB_10009a11:
  10009a11  MOV byte ptr [EAX],CL
  10009a13  INC EAX
  10009a14  MOV ECX,EAX
  10009a16  LEA EDX,[EBP + 0xfffffbec]
  10009a1c  SUB ECX,EDX
  10009a1e  CMP ECX,0x400
  10009a24  JL 0x100099f2    ; LAB_100099f2
LAB_10009a26:
  10009a26  MOV EDI,EAX
  10009a28  LEA EAX,[EBP + 0xfffffbec]
  10009a2e  SUB EDI,EAX
  10009a30  LEA EAX,[EBP + -0xc]
  10009a33  PUSH 0x0
  10009a35  PUSH EAX
  10009a36  LEA EAX,[EBP + 0xfffffbec]
  10009a3c  PUSH EDI
  10009a3d  PUSH EAX
  10009a3e  MOV EAX,dword ptr [EBX]    ; DAT_10010aa0
  10009a40  PUSH dword ptr [EAX + ESI*0x1]
  10009a43  CALL dword ptr [0x1000d07c]    ; PTR_WriteFile_1000d07c KERNEL32.DLL::WriteFile
  10009a49  TEST EAX,EAX
  10009a4b  JZ 0x10009a90    ; LAB_10009a90
  10009a4d  MOV EAX,dword ptr [EBP + -0xc]
  10009a50  ADD dword ptr [EBP + -0x8],EAX
  10009a53  CMP EAX,EDI
  10009a55  JL 0x10009a62    ; LAB_10009a62
  10009a57  MOV EAX,dword ptr [EBP + -0x4]
  10009a5a  SUB EAX,dword ptr [EBP + 0xc]
  10009a5d  CMP EAX,dword ptr [EBP + 0x10]
  10009a60  JC 0x100099ec    ; LAB_100099ec
LAB_10009a62:
  10009a62  XOR EDI,EDI
LAB_10009a64:
  10009a64  MOV EAX,dword ptr [EBP + -0x8]
  10009a67  CMP EAX,EDI
  10009a69  JNZ 0x10009afa    ; LAB_10009afa
  10009a6f  CMP dword ptr [EBP + 0x8],EDI
  10009a72  JZ 0x10009ad3    ; LAB_10009ad3
  10009a74  PUSH 0x5
  10009a76  POP EAX
  10009a77  CMP dword ptr [EBP + 0x8],EAX
  10009a7a  JNZ 0x10009ac8    ; LAB_10009ac8
  10009a7c  MOV dword ptr [0x1000f64c],0x9    ; DAT_1000f64c
  10009a86  MOV [0x1000f650],EAX    ; DAT_1000f650
  10009a8b  JMP 0x10009b10    ; LAB_10009b10
LAB_10009a90:
  10009a90  CALL dword ptr [0x1000d08c]    ; PTR_GetLastError_1000d08c KERNEL32.DLL::GetLastError
  10009a96  MOV dword ptr [EBP + 0x8],EAX
  10009a99  JMP 0x10009a62    ; LAB_10009a62
LAB_10009a9b:
  10009a9b  LEA ECX,[EBP + -0xc]
  10009a9e  PUSH EDI
  10009a9f  PUSH ECX
  10009aa0  PUSH dword ptr [EBP + 0x10]
  10009aa3  PUSH dword ptr [EBP + 0xc]
  10009aa6  PUSH dword ptr [EAX]
  10009aa8  CALL dword ptr [0x1000d07c]    ; PTR_WriteFile_1000d07c KERNEL32.DLL::WriteFile
  10009aae  TEST EAX,EAX
  10009ab0  JZ 0x10009abd    ; LAB_10009abd
  10009ab2  MOV EAX,dword ptr [EBP + -0xc]
  10009ab5  MOV dword ptr [EBP + 0x8],EDI
  10009ab8  MOV dword ptr [EBP + -0x8],EAX
  10009abb  JMP 0x10009a64    ; LAB_10009a64
LAB_10009abd:
  10009abd  CALL dword ptr [0x1000d08c]    ; PTR_GetLastError_1000d08c KERNEL32.DLL::GetLastError
  10009ac3  MOV dword ptr [EBP + 0x8],EAX
  10009ac6  JMP 0x10009a64    ; LAB_10009a64
LAB_10009ac8:
  10009ac8  PUSH dword ptr [EBP + 0x8]
  10009acb  CALL 0x1000b6e2    ; FUN_1000b6e2
  10009ad0  POP ECX
  10009ad1  JMP 0x10009b10    ; LAB_10009b10
LAB_10009ad3:
  10009ad3  MOV EAX,dword ptr [EBX]    ; DAT_10010aa0
  10009ad5  TEST byte ptr [EAX + ESI*0x1 + 0x4],0x40
  10009ada  JZ 0x10009ae8    ; LAB_10009ae8
  10009adc  MOV EAX,dword ptr [EBP + 0xc]
  10009adf  CMP byte ptr [EAX],0x1a
  10009ae2  JZ 0x100099b5    ; LAB_100099b5
LAB_10009ae8:
  10009ae8  MOV dword ptr [0x1000f64c],0x1c    ; DAT_1000f64c
  10009af2  MOV dword ptr [0x1000f650],EDI    ; DAT_1000f650
  10009af8  JMP 0x10009b10    ; LAB_10009b10
LAB_10009afa:
  10009afa  SUB EAX,dword ptr [EBP + -0x10]
  10009afd  JMP 0x10009b13    ; LAB_10009b13
LAB_10009aff:
  10009aff  AND dword ptr [0x1000f650],0x0    ; DAT_1000f650
  10009b06  MOV dword ptr [0x1000f64c],0x9    ; DAT_1000f64c
LAB_10009b10:
  10009b10  OR EAX,0xffffffff
LAB_10009b13:
  10009b13  POP EDI
  10009b14  POP ESI
  10009b15  POP EBX
  10009b16  LEAVE
  10009b17  RET

;==== FUNCTION FUN_10009b18 @ 10009b18 : undefined FUN_10009b18(undefined4 * param_1)
  10009b18  INC dword ptr [0x1000f7e0]    ; DAT_1000f7e0
  10009b1e  PUSH 0x1000
  10009b23  CALL 0x10005e59    ; _malloc
  10009b28  POP ECX
  10009b29  MOV ECX,dword ptr [ESP + 0x4]
  10009b2d  TEST EAX,EAX
  10009b2f  MOV dword ptr [ECX + 0x8],EAX
  10009b32  JZ 0x10009b41    ; LAB_10009b41
  10009b34  OR dword ptr [ECX + 0xc],0x8
  10009b38  MOV dword ptr [ECX + 0x18],0x1000
  10009b3f  JMP 0x10009b52    ; LAB_10009b52
LAB_10009b41:
  10009b41  OR dword ptr [ECX + 0xc],0x4
  10009b45  LEA EAX,[ECX + 0x14]
  10009b48  MOV dword ptr [ECX + 0x8],EAX
  10009b4b  MOV dword ptr [ECX + 0x18],0x2
LAB_10009b52:
  10009b52  MOV EAX,dword ptr [ECX + 0x8]
  10009b55  AND dword ptr [ECX + 0x4],0x0
  10009b59  MOV dword ptr [ECX],EAX
  10009b5b  RET

;==== FUNCTION FUN_10009b5c @ 10009b5c : byte FUN_10009b5c(uint param_1)
  10009b5c  MOV EAX,dword ptr [ESP + 0x4]
  10009b60  CMP EAX,dword ptr [0x10010ba0]    ; DAT_10010ba0
  10009b66  JC 0x10009b6b    ; LAB_10009b6b
  10009b68  XOR EAX,EAX
  10009b6a  RET
LAB_10009b6b:
  10009b6b  MOV ECX,EAX
  10009b6d  AND EAX,0x1f
  10009b70  SAR ECX,0x5
  10009b73  MOV ECX,dword ptr [ECX*0x4 + 0x10010aa0]    ; DAT_10010aa0
  10009b7a  MOV AL,byte ptr [ECX + EAX*0x8 + 0x4]
  10009b7e  AND EAX,0x40
  10009b81  RET
LAB_10009b82:
  10009b82  MOV EAX,[0x10010a80]    ; DAT_10010a80
  10009b87  PUSH ESI
  10009b88  PUSH 0x14
  10009b8a  TEST EAX,EAX
  10009b8c  POP ESI
  10009b8d  JNZ 0x10009b96    ; LAB_10009b96
  10009b8f  MOV EAX,0x200
  10009b94  JMP 0x10009b9c    ; LAB_10009b9c
LAB_10009b96:
  10009b96  CMP EAX,ESI
  10009b98  JGE 0x10009ba1    ; LAB_10009ba1
  10009b9a  MOV EAX,ESI
LAB_10009b9c:
  10009b9c  MOV [0x10010a80],EAX    ; DAT_10010a80
LAB_10009ba1:
  10009ba1  PUSH 0x4
  10009ba3  PUSH EAX
  10009ba4  CALL 0x1000b9a9    ; FUN_1000b9a9
  10009ba9  POP ECX
  10009baa  MOV [0x1000fa68],EAX    ; DAT_1000fa68
  10009baf  TEST EAX,EAX
  10009bb1  POP ECX
  10009bb2  JNZ 0x10009bd5    ; LAB_10009bd5
  10009bb4  PUSH 0x4
  10009bb6  PUSH ESI
  10009bb7  MOV dword ptr [0x10010a80],ESI    ; DAT_10010a80
  10009bbd  CALL 0x1000b9a9    ; FUN_1000b9a9
  10009bc2  POP ECX
  10009bc3  MOV [0x1000fa68],EAX    ; DAT_1000fa68
  10009bc8  TEST EAX,EAX
  10009bca  POP ECX
  10009bcb  JNZ 0x10009bd5    ; LAB_10009bd5
  10009bcd  PUSH 0x1a
  10009bcf  CALL 0x10005943    ; __amsg_exit
  10009bd4  POP ECX
LAB_10009bd5:
  10009bd5  XOR ECX,ECX
  10009bd7  MOV EAX,0x1000ed78    ; PTR_DAT_1000ed78
LAB_10009bdc:
  10009bdc  MOV EDX,dword ptr [0x1000fa68]    ; DAT_1000fa68
  10009be2  MOV dword ptr [ECX + EDX*0x1],EAX    ; PTR_DAT_1000ed78 DAT_1000ed98
  10009be5  ADD EAX,0x20
  10009be8  ADD ECX,0x4
  10009beb  CMP EAX,0x1000eff8    ; DAT_1000eff8
  10009bf0  JL 0x10009bdc    ; LAB_10009bdc
  10009bf2  XOR EDX,EDX
  10009bf4  MOV ECX,0x1000ed88    ; DAT_1000ed88
LAB_10009bf9:
  10009bf9  MOV EAX,EDX
  10009bfb  MOV ESI,EDX
  10009bfd  SAR EAX,0x5
  10009c00  AND ESI,0x1f
  10009c03  MOV EAX,dword ptr [EAX*0x4 + 0x10010aa0]    ; DAT_10010aa0
  10009c0a  MOV EAX,dword ptr [EAX + ESI*0x8]
  10009c0d  CMP EAX,-0x1
  10009c10  JZ 0x10009c16    ; LAB_10009c16
  10009c12  TEST EAX,EAX
  10009c14  JNZ 0x10009c19    ; LAB_10009c19
LAB_10009c16:
  10009c16  OR dword ptr [ECX],0xffffffff    ; DAT_1000ed88 DAT_1000eda8
LAB_10009c19:
  10009c19  ADD ECX,0x20
  10009c1c  INC EDX
  10009c1d  CMP ECX,0x1000ede8    ; DAT_1000ede8
  10009c23  JL 0x10009bf9    ; LAB_10009bf9
  10009c25  POP ESI
  10009c26  RET

;==== FUNCTION FUN_10009c3b @ 10009c3b : int FUN_10009c3b(LPSTR param_1, WCHAR param_2)
  10009c3b  PUSH EBP
  10009c3c  MOV EBP,ESP
  10009c3e  MOV EAX,dword ptr [EBP + 0x8]
  10009c41  TEST EAX,EAX
  10009c43  JNZ 0x10009c47    ; LAB_10009c47
  10009c45  POP EBP
  10009c46  RET
LAB_10009c47:
  10009c47  CMP dword ptr [0x1000f80c],0x0    ; DAT_1000f80c
  10009c4e  JNZ 0x10009c62    ; LAB_10009c62
  10009c50  MOV CX,word ptr [EBP + 0xc]
  10009c54  CMP CX,0xff
  10009c59  JA 0x10009c94    ; LAB_10009c94
  10009c5b  PUSH 0x1
  10009c5d  MOV byte ptr [EAX],CL
  10009c5f  POP EAX
  10009c60  POP EBP
  10009c61  RET
LAB_10009c62:
  10009c62  LEA ECX,[EBP + 0x8]
  10009c65  AND dword ptr [EBP + 0x8],0x0
  10009c69  PUSH ECX
  10009c6a  PUSH 0x0
  10009c6c  PUSH dword ptr [0x1000ec94]    ; DAT_1000ec94
  10009c72  PUSH EAX
  10009c73  LEA EAX,[EBP + 0xc]
  10009c76  PUSH 0x1
  10009c78  PUSH EAX
  10009c79  PUSH 0x220
  10009c7e  PUSH dword ptr [0x1000f81c]    ; DAT_1000f81c
  10009c84  CALL dword ptr [0x1000d070]    ; PTR_WideCharToMultiByte_1000d070 KERNEL32.DLL::WideCharToMultiByte
  10009c8a  TEST EAX,EAX
  10009c8c  JZ 0x10009c94    ; LAB_10009c94
  10009c8e  CMP dword ptr [EBP + 0x8],0x0
  10009c92  JZ 0x10009ca1    ; LAB_10009ca1
LAB_10009c94:
  10009c94  MOV dword ptr [0x1000f64c],0x2a    ; DAT_1000f64c
  10009c9e  OR EAX,0xffffffff
LAB_10009ca1:
  10009ca1  POP EBP
  10009ca2  RET

;==== FUNCTION __aulldiv @ 10009cb0 : undefined8 __aulldiv(uint param_1, uint param_2, uint param_3, uint param_4)
  10009cb0  PUSH EBX
  10009cb1  PUSH ESI
  10009cb2  MOV EAX,dword ptr [ESP + 0x18]
  10009cb6  OR EAX,EAX
  10009cb8  JNZ 0x10009cd2    ; LAB_10009cd2
  10009cba  MOV ECX,dword ptr [ESP + 0x14]
  10009cbe  MOV EAX,dword ptr [ESP + 0x10]
  10009cc2  XOR EDX,EDX
  10009cc4  DIV ECX
  10009cc6  MOV EBX,EAX
  10009cc8  MOV EAX,dword ptr [ESP + 0xc]
  10009ccc  DIV ECX
  10009cce  MOV EDX,EBX
  10009cd0  JMP 0x10009d13    ; LAB_10009d13
LAB_10009cd2:
  10009cd2  MOV ECX,EAX
  10009cd4  MOV EBX,dword ptr [ESP + 0x14]
  10009cd8  MOV EDX,dword ptr [ESP + 0x10]
  10009cdc  MOV EAX,dword ptr [ESP + 0xc]
LAB_10009ce0:
  10009ce0  SHR ECX,0x1
  10009ce2  RCR EBX,0x1
  10009ce4  SHR EDX,0x1
  10009ce6  RCR EAX,0x1
  10009ce8  OR ECX,ECX
  10009cea  JNZ 0x10009ce0    ; LAB_10009ce0
  10009cec  DIV EBX
  10009cee  MOV ESI,EAX
  10009cf0  MUL dword ptr [ESP + 0x18]
  10009cf4  MOV ECX,EAX
  10009cf6  MOV EAX,dword ptr [ESP + 0x14]
  10009cfa  MUL ESI
  10009cfc  ADD EDX,ECX
  10009cfe  JC 0x10009d0e    ; LAB_10009d0e
  10009d00  CMP EDX,dword ptr [ESP + 0x10]
  10009d04  JA 0x10009d0e    ; LAB_10009d0e
  10009d06  JC 0x10009d0f    ; LAB_10009d0f
  10009d08  CMP EAX,dword ptr [ESP + 0xc]
  10009d0c  JBE 0x10009d0f    ; LAB_10009d0f
LAB_10009d0e:
  10009d0e  DEC ESI
LAB_10009d0f:
  10009d0f  XOR EDX,EDX
  10009d11  MOV EAX,ESI
LAB_10009d13:
  10009d13  POP ESI
  10009d14  POP EBX
  10009d15  RET 0x10

;==== FUNCTION __aullrem @ 10009d20 : undefined8 __aullrem(uint param_1, uint param_2, uint param_3, uint param_4)
  10009d20  PUSH EBX
  10009d21  MOV EAX,dword ptr [ESP + 0x14]
  10009d25  OR EAX,EAX
  10009d27  JNZ 0x10009d41    ; LAB_10009d41
  10009d29  MOV ECX,dword ptr [ESP + 0x10]
  10009d2d  MOV EAX,dword ptr [ESP + 0xc]
  10009d31  XOR EDX,EDX
  10009d33  DIV ECX
  10009d35  MOV EAX,dword ptr [ESP + 0x8]
  10009d39  DIV ECX
  10009d3b  MOV EAX,EDX
  10009d3d  XOR EDX,EDX
  10009d3f  JMP 0x10009d91    ; LAB_10009d91
LAB_10009d41:
  10009d41  MOV ECX,EAX
  10009d43  MOV EBX,dword ptr [ESP + 0x10]
  10009d47  MOV EDX,dword ptr [ESP + 0xc]
  10009d4b  MOV EAX,dword ptr [ESP + 0x8]
LAB_10009d4f:
  10009d4f  SHR ECX,0x1
  10009d51  RCR EBX,0x1
  10009d53  SHR EDX,0x1
  10009d55  RCR EAX,0x1
  10009d57  OR ECX,ECX
  10009d59  JNZ 0x10009d4f    ; LAB_10009d4f
  10009d5b  DIV EBX
  10009d5d  MOV ECX,EAX
  10009d5f  MUL dword ptr [ESP + 0x14]
  10009d63  XCHG EAX,ECX
  10009d64  MUL dword ptr [ESP + 0x10]
  10009d68  ADD EDX,ECX
  10009d6a  JC 0x10009d7a    ; LAB_10009d7a
  10009d6c  CMP EDX,dword ptr [ESP + 0xc]
  10009d70  JA 0x10009d7a    ; LAB_10009d7a
  10009d72  JC 0x10009d82    ; LAB_10009d82
  10009d74  CMP EAX,dword ptr [ESP + 0x8]
  10009d78  JBE 0x10009d82    ; LAB_10009d82
LAB_10009d7a:
  10009d7a  SUB EAX,dword ptr [ESP + 0x10]
  10009d7e  SBB EDX,dword ptr [ESP + 0x14]
LAB_10009d82:
  10009d82  SUB EAX,dword ptr [ESP + 0x8]
  10009d86  SBB EDX,dword ptr [ESP + 0xc]
  10009d8a  NEG EDX
  10009d8c  NEG EAX
  10009d8e  SBB EDX,0x0
LAB_10009d91:
  10009d91  POP EBX
  10009d92  RET 0x10

;==== FUNCTION FUN_10009d95 @ 10009d95 : int FUN_10009d95(int * param_1)
  10009d95  PUSH ESI
  10009d96  MOV ESI,dword ptr [ESP + 0x8]
  10009d9a  MOV EAX,dword ptr [ESI]
  10009d9c  CMP dword ptr [EAX],0xe06d7363
  10009da2  JNZ 0x10009db8    ; LAB_10009db8
  10009da4  CMP dword ptr [EAX + 0x10],0x3
  10009da8  JNZ 0x10009db8    ; LAB_10009db8
  10009daa  CMP dword ptr [EAX + 0x14],0x19930520
  10009db1  JNZ 0x10009db8    ; LAB_10009db8
  10009db3  JMP 0x1000703c    ; FUN_1000703c
LAB_10009db8:
  10009db8  MOV EAX,[0x1000f7e4]    ; DAT_1000f7e4
  10009dbd  TEST EAX,EAX
  10009dbf  JZ 0x10009dd5    ; LAB_10009dd5
  10009dc1  PUSH EAX
  10009dc2  CALL 0x10009e31    ; FUN_10009e31
  10009dc7  TEST EAX,EAX
  10009dc9  POP ECX
  10009dca  JZ 0x10009dd5    ; LAB_10009dd5
  10009dcc  PUSH ESI
  10009dcd  CALL dword ptr [0x1000f7e4]    ; DAT_1000f7e4
  10009dd3  JMP 0x10009dd7    ; LAB_10009dd7
LAB_10009dd5:
  10009dd5  XOR EAX,EAX
LAB_10009dd7:
  10009dd7  POP ESI
  10009dd8  RET 0x4
LAB_10009ddb:
  10009ddb  PUSH 0x10009d95    ; FUN_10009d95
  10009de0  CALL dword ptr [0x1000d094]    ; PTR_SetUnhandledExceptionFilter_1000d094 KERNEL32.DLL::SetUnhandledExceptionFilter
  10009de6  MOV [0x1000f7e4],EAX    ; DAT_1000f7e4
  10009deb  RET

;==== FUNCTION FUN_10009df9 @ 10009df9 : bool FUN_10009df9(void * param_1, UINT_PTR param_2)
  10009df9  PUSH ESI
  10009dfa  PUSH 0x1
  10009dfc  POP ESI
  10009dfd  PUSH dword ptr [ESP + 0xc]
  10009e01  PUSH dword ptr [ESP + 0xc]
  10009e05  CALL dword ptr [0x1000d098]    ; PTR_IsBadReadPtr_1000d098 KERNEL32.DLL::IsBadReadPtr
  10009e0b  TEST EAX,EAX
  10009e0d  JZ 0x10009e11    ; LAB_10009e11
  10009e0f  XOR ESI,ESI
LAB_10009e11:
  10009e11  MOV EAX,ESI
  10009e13  POP ESI
  10009e14  RET

;==== FUNCTION FUN_10009e15 @ 10009e15 : bool FUN_10009e15(LPVOID param_1, UINT_PTR param_2)
  10009e15  PUSH ESI
  10009e16  PUSH 0x1
  10009e18  POP ESI
  10009e19  PUSH dword ptr [ESP + 0xc]
  10009e1d  PUSH dword ptr [ESP + 0xc]
  10009e21  CALL dword ptr [0x1000d088]    ; PTR_IsBadWritePtr_1000d088 KERNEL32.DLL::IsBadWritePtr
  10009e27  TEST EAX,EAX
  10009e29  JZ 0x10009e2d    ; LAB_10009e2d
  10009e2b  XOR ESI,ESI
LAB_10009e2d:
  10009e2d  MOV EAX,ESI
  10009e2f  POP ESI
  10009e30  RET

;==== FUNCTION FUN_10009e31 @ 10009e31 : bool FUN_10009e31(FARPROC param_1)
  10009e31  PUSH ESI
  10009e32  PUSH 0x1
  10009e34  POP ESI
  10009e35  PUSH dword ptr [ESP + 0x8]
  10009e39  CALL dword ptr [0x1000d09c]    ; PTR_IsBadCodePtr_1000d09c KERNEL32.DLL::IsBadCodePtr
  10009e3f  TEST EAX,EAX
  10009e41  JZ 0x10009e45    ; LAB_10009e45
  10009e43  XOR ESI,ESI
LAB_10009e45:
  10009e45  MOV EAX,ESI
  10009e47  POP ESI
  10009e48  RET

;==== FUNCTION _strcmp @ 10009e50 : int _strcmp(char * _Str1, char * _Str2)
  10009e50  MOV EDX,dword ptr [ESP + 0x4]
  10009e54  MOV ECX,dword ptr [ESP + 0x8]
  10009e58  TEST EDX,0x3
  10009e5e  JNZ 0x10009e9c    ; LAB_10009e9c
LAB_10009e60:
  10009e60  MOV EAX,dword ptr [EDX]
  10009e62  CMP AL,byte ptr [ECX]
  10009e64  JNZ 0x10009e94    ; LAB_10009e94
  10009e66  OR AL,AL
  10009e68  JZ 0x10009e90    ; LAB_10009e90
  10009e6a  CMP AH,byte ptr [ECX + 0x1]
  10009e6d  JNZ 0x10009e94    ; LAB_10009e94
  10009e6f  OR AH,AH
  10009e71  JZ 0x10009e90    ; LAB_10009e90
  10009e73  SHR EAX,0x10
  10009e76  CMP AL,byte ptr [ECX + 0x2]
  10009e79  JNZ 0x10009e94    ; LAB_10009e94
  10009e7b  OR AL,AL
  10009e7d  JZ 0x10009e90    ; LAB_10009e90
  10009e7f  CMP AH,byte ptr [ECX + 0x3]
  10009e82  JNZ 0x10009e94    ; LAB_10009e94
  10009e84  ADD ECX,0x4
  10009e87  ADD EDX,0x4
  10009e8a  OR AH,AH
  10009e8c  JNZ 0x10009e60    ; LAB_10009e60
  10009e8e  MOV EDI,EDI
LAB_10009e90:
  10009e90  XOR EAX,EAX
  10009e92  RET
LAB_10009e94:
  10009e94  SBB EAX,EAX
  10009e96  SHL EAX,0x1
  10009e98  INC EAX
  10009e99  RET
LAB_10009e9c:
  10009e9c  TEST EDX,0x1
  10009ea2  JZ 0x10009eb8    ; LAB_10009eb8
  10009ea4  MOV AL,byte ptr [EDX]
  10009ea6  INC EDX
  10009ea7  CMP AL,byte ptr [ECX]
  10009ea9  JNZ 0x10009e94    ; LAB_10009e94
  10009eab  INC ECX
  10009eac  OR AL,AL
  10009eae  JZ 0x10009e90    ; LAB_10009e90
  10009eb0  TEST EDX,0x2
  10009eb6  JZ 0x10009e60    ; LAB_10009e60
LAB_10009eb8:
  10009eb8  MOV AX,word ptr [EDX]
  10009ebb  ADD EDX,0x2
  10009ebe  CMP AL,byte ptr [ECX]
  10009ec0  JNZ 0x10009e94    ; LAB_10009e94
  10009ec2  OR AL,AL
  10009ec4  JZ 0x10009e90    ; LAB_10009e90
  10009ec6  CMP AH,byte ptr [ECX + 0x1]
  10009ec9  JNZ 0x10009e94    ; LAB_10009e94
  10009ecb  OR AH,AH
  10009ecd  JZ 0x10009e90    ; LAB_10009e90
  10009ecf  ADD ECX,0x2
  10009ed2  JMP 0x10009e60    ; LAB_10009e60
LAB_10009edc:
  10009edc  PUSH EBP
  10009edd  MOV EBP,ESP
  10009edf  SUB ESP,0x8
  10009ee2  PUSH EBX
  10009ee3  PUSH ESI
  10009ee4  PUSH EDI
  10009ee5  PUSH EBP
  10009ee6  CLD
  10009ee7  MOV EBX,dword ptr [EBP + 0xc]
  10009eea  MOV EAX,dword ptr [EBP + 0x8]
  10009eed  TEST dword ptr [EAX + 0x4],0x6
  10009ef4  JNZ 0x10009f7c    ; LAB_10009f7c
  10009efa  MOV dword ptr [EBP + -0x8],EAX
  10009efd  MOV EAX,dword ptr [EBP + 0x10]
  10009f00  MOV dword ptr [EBP + -0x4],EAX
  10009f03  LEA EAX,[EBP + -0x8]
  10009f06  MOV dword ptr [EBX + -0x4],EAX
  10009f09  MOV ESI,dword ptr [EBX + 0xc]
  10009f0c  MOV EDI,dword ptr [EBX + 0x8]
LAB_10009f0f:
  10009f0f  CMP ESI,-0x1
  10009f12  JZ 0x10009f75    ; LAB_10009f75
  10009f14  LEA ECX,[ESI + ESI*0x2]
  10009f17  CMP dword ptr [EDI + ECX*0x4 + 0x4],0x0
  10009f1c  JZ 0x10009f63    ; LAB_10009f63
  10009f1e  PUSH ESI
  10009f1f  PUSH EBP
  10009f20  LEA EBP,[EBX + 0x10]
  10009f23  CALL dword ptr [EDI + ECX*0x4 + 0x4]
  10009f27  POP EBP
  10009f28  POP ESI
  10009f29  MOV EBX,dword ptr [EBP + 0xc]
  10009f2c  OR EAX,EAX
  10009f2e  JZ 0x10009f63    ; LAB_10009f63
  10009f30  JS 0x10009f6e    ; LAB_10009f6e
  10009f32  MOV EDI,dword ptr [EBX + 0x8]
  10009f35  PUSH EBX
  10009f36  CALL 0x10005508    ; __global_unwind2
  10009f3b  ADD ESP,0x4
  10009f3e  LEA EBP,[EBX + 0x10]
  10009f41  PUSH ESI
  10009f42  PUSH EBX
  10009f43  CALL 0x1000554a    ; __local_unwind2
  10009f48  ADD ESP,0x8
  10009f4b  LEA ECX,[ESI + ESI*0x2]
  10009f4e  PUSH 0x1
  10009f50  MOV EAX,dword ptr [EDI + ECX*0x4 + 0x8]
  10009f54  CALL 0x100055de    ; FUN_100055de
  10009f59  MOV EAX,dword ptr [EDI + ECX*0x4]
  10009f5c  MOV dword ptr [EBX + 0xc],EAX
  10009f5f  CALL dword ptr [EDI + ECX*0x4 + 0x8]
LAB_10009f63:
  10009f63  MOV EDI,dword ptr [EBX + 0x8]
  10009f66  LEA ECX,[ESI + ESI*0x2]
  10009f69  MOV ESI,dword ptr [EDI + ECX*0x4]
  10009f6c  JMP 0x10009f0f    ; LAB_10009f0f
LAB_10009f6e:
  10009f6e  MOV EAX,0x0
  10009f73  JMP 0x10009f91    ; LAB_10009f91
LAB_10009f75:
  10009f75  MOV EAX,0x1
  10009f7a  JMP 0x10009f91    ; LAB_10009f91
LAB_10009f7c:
  10009f7c  PUSH EBP
  10009f7d  LEA EBP,[EBX + 0x10]
  10009f80  PUSH -0x1
  10009f82  PUSH EBX
  10009f83  CALL 0x1000554a    ; __local_unwind2
  10009f88  ADD ESP,0x8
  10009f8b  POP EBP
  10009f8c  MOV EAX,0x1
LAB_10009f91:
  10009f91  POP EBP
  10009f92  POP EDI
  10009f93  POP ESI
  10009f94  POP EBX
  10009f95  MOV ESP,EBP
  10009f97  POP EBP
  10009f98  RET

;==== FUNCTION FUN_10009f99 @ 10009f99 : undefined FUN_10009f99(int param_1)
  10009f99  PUSH EBP
  10009f9a  MOV ECX,dword ptr [ESP + 0x8]
  10009f9e  MOV EBP,dword ptr [ECX]
  10009fa0  MOV EAX,dword ptr [ECX + 0x1c]
  10009fa3  PUSH EAX
  10009fa4  MOV EAX,dword ptr [ECX + 0x18]
  10009fa7  PUSH EAX
  10009fa8  CALL 0x1000554a    ; __local_unwind2
  10009fad  ADD ESP,0x8
  10009fb0  POP EBP
  10009fb1  RET 0x4

;==== FUNCTION FUN_10009fb4 @ 10009fb4 : undefined FUN_10009fb4(void)
  10009fb4  PUSH 0xa
  10009fb6  CALL 0x100079b4    ; FUN_100079b4
  10009fbb  PUSH 0x16
  10009fbd  CALL 0x1000bccf    ; FUN_1000bccf
  10009fc2  POP ECX
  10009fc3  POP ECX
  10009fc4  PUSH 0x3
  10009fc6  CALL 0x100071e2    ; __exit

;==== FUNCTION FUN_10009fcb @ 10009fcb : BOOL FUN_10009fcb(DWORD param_1, LPCSTR param_2, int param_3, LPWORD param_4, UINT param_5, LCID param_6, int param_7)
  10009fcb  PUSH EBP
  10009fcc  MOV EBP,ESP
  10009fce  PUSH -0x1
  10009fd0  PUSH 0x1000d598    ; DAT_1000d598
  10009fd5  PUSH 0x10009edc    ; LAB_10009edc
  10009fda  MOV EAX,FS:[0x0]    ; ExceptionList
  10009fe0  PUSH EAX
  10009fe1  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  10009fe8  SUB ESP,0x18
  10009feb  PUSH EBX
  10009fec  PUSH ESI
  10009fed  PUSH EDI
  10009fee  MOV dword ptr [EBP + -0x18],ESP
  10009ff1  MOV EAX,[0x1000f7e8]    ; DAT_1000f7e8
  10009ff6  XOR EBX,EBX
  10009ff8  CMP EAX,EBX
  10009ffa  JNZ 0x1000a03a    ; LAB_1000a03a
  10009ffc  LEA EAX,[EBP + -0x1c]
  10009fff  PUSH EAX
  1000a000  PUSH 0x1
  1000a002  POP ESI
  1000a003  PUSH ESI
  1000a004  PUSH 0x1000d594    ; DAT_1000d594
  1000a009  PUSH ESI
  1000a00a  CALL dword ptr [0x1000d0a8]    ; PTR_GetStringTypeW_1000d0a8 KERNEL32.DLL::GetStringTypeW
  1000a010  TEST EAX,EAX
  1000a012  JZ 0x1000a018    ; LAB_1000a018
  1000a014  MOV EAX,ESI
  1000a016  JMP 0x1000a035    ; LAB_1000a035
LAB_1000a018:
  1000a018  LEA EAX,[EBP + -0x1c]
  1000a01b  PUSH EAX
  1000a01c  PUSH ESI
  1000a01d  PUSH 0x1000d590    ; DAT_1000d590
  1000a022  PUSH ESI
  1000a023  PUSH EBX
  1000a024  CALL dword ptr [0x1000d0a4]    ; PTR_GetStringTypeA_1000d0a4 KERNEL32.DLL::GetStringTypeA
  1000a02a  TEST EAX,EAX
  1000a02c  JZ 0x1000a100    ; LAB_1000a100
  1000a032  PUSH 0x2
  1000a034  POP EAX
LAB_1000a035:
  1000a035  MOV [0x1000f7e8],EAX    ; DAT_1000f7e8
LAB_1000a03a:
  1000a03a  CMP EAX,0x2
  1000a03d  JNZ 0x1000a063    ; LAB_1000a063
  1000a03f  MOV EAX,dword ptr [EBP + 0x1c]
  1000a042  CMP EAX,EBX
  1000a044  JNZ 0x1000a04b    ; LAB_1000a04b
  1000a046  MOV EAX,[0x1000f80c]    ; DAT_1000f80c
LAB_1000a04b:
  1000a04b  PUSH dword ptr [EBP + 0x14]
  1000a04e  PUSH dword ptr [EBP + 0x10]
  1000a051  PUSH dword ptr [EBP + 0xc]
  1000a054  PUSH dword ptr [EBP + 0x8]
  1000a057  PUSH EAX
  1000a058  CALL dword ptr [0x1000d0a4]    ; PTR_GetStringTypeA_1000d0a4 KERNEL32.DLL::GetStringTypeA
  1000a05e  JMP 0x1000a102    ; LAB_1000a102
LAB_1000a063:
  1000a063  CMP EAX,0x1
  1000a066  JNZ 0x1000a100    ; LAB_1000a100
  1000a06c  CMP dword ptr [EBP + 0x18],EBX
  1000a06f  JNZ 0x1000a079    ; LAB_1000a079
  1000a071  MOV EAX,[0x1000f81c]    ; DAT_1000f81c
  1000a076  MOV dword ptr [EBP + 0x18],EAX
LAB_1000a079:
  1000a079  PUSH EBX
  1000a07a  PUSH EBX
  1000a07b  PUSH dword ptr [EBP + 0x10]
  1000a07e  PUSH dword ptr [EBP + 0xc]
  1000a081  MOV EAX,dword ptr [EBP + 0x20]
  1000a084  NEG EAX
  1000a086  SBB EAX,EAX
  1000a088  AND EAX,0x8
  1000a08b  INC EAX
  1000a08c  PUSH EAX
  1000a08d  PUSH dword ptr [EBP + 0x18]
  1000a090  CALL dword ptr [0x1000d0a0]    ; PTR_MultiByteToWideChar_1000d0a0 KERNEL32.DLL::MultiByteToWideChar
  1000a096  MOV dword ptr [EBP + -0x20],EAX
  1000a099  CMP EAX,EBX
  1000a09b  JZ 0x1000a100    ; LAB_1000a100
  1000a09d  MOV dword ptr [EBP + -0x4],EBX
  1000a0a0  LEA EDI,[EAX + EAX*0x1]
  1000a0a3  MOV EAX,EDI
  1000a0a5  ADD EAX,0x3
  1000a0a8  AND AL,0xfc
  1000a0aa  CALL 0x10005600    ; FUN_10005600
  1000a0af  MOV dword ptr [EBP + -0x18],ESP
  1000a0b2  MOV ESI,ESP
  1000a0b4  MOV dword ptr [EBP + -0x24],ESI
  1000a0b7  PUSH EDI
  1000a0b8  PUSH EBX
  1000a0b9  PUSH ESI
  1000a0ba  CALL 0x10008520    ; _memset
  1000a0bf  ADD ESP,0xc
  1000a0c2  JMP 0x1000a0cf    ; LAB_1000a0cf
LAB_1000a0cf:
  1000a0cf  OR dword ptr [EBP + -0x4],0xffffffff
  1000a0d3  CMP ESI,EBX
  1000a0d5  JZ 0x1000a100    ; LAB_1000a100
  1000a0d7  PUSH dword ptr [EBP + -0x20]
  1000a0da  PUSH ESI
  1000a0db  PUSH dword ptr [EBP + 0x10]
  1000a0de  PUSH dword ptr [EBP + 0xc]
  1000a0e1  PUSH 0x1
  1000a0e3  PUSH dword ptr [EBP + 0x18]
  1000a0e6  CALL dword ptr [0x1000d0a0]    ; PTR_MultiByteToWideChar_1000d0a0 KERNEL32.DLL::MultiByteToWideChar
  1000a0ec  CMP EAX,EBX
  1000a0ee  JZ 0x1000a100    ; LAB_1000a100
  1000a0f0  PUSH dword ptr [EBP + 0x14]
  1000a0f3  PUSH EAX
  1000a0f4  PUSH ESI
  1000a0f5  PUSH dword ptr [EBP + 0x8]
  1000a0f8  CALL dword ptr [0x1000d0a8]    ; PTR_GetStringTypeW_1000d0a8 KERNEL32.DLL::GetStringTypeW
  1000a0fe  JMP 0x1000a102    ; LAB_1000a102
LAB_1000a100:
  1000a100  XOR EAX,EAX
LAB_1000a102:
  1000a102  LEA ESP,[EBP + -0x34]
  1000a105  MOV ECX,dword ptr [EBP + -0x10]
  1000a108  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  1000a10f  POP EDI
  1000a110  POP ESI
  1000a111  POP EBX
  1000a112  LEAVE
  1000a113  RET

;==== FUNCTION FUN_1000a114 @ 1000a114 : undefined4 FUN_1000a114(int param_1)
  1000a114  PUSH EBP
  1000a115  MOV EBP,ESP
  1000a117  SUB ESP,0x18
  1000a11a  PUSH EBX
  1000a11b  PUSH ESI
  1000a11c  PUSH EDI
  1000a11d  PUSH dword ptr [EBP + 0x8]
  1000a120  CALL 0x1000a2ad    ; FUN_1000a2ad
  1000a125  MOV ESI,EAX
  1000a127  POP ECX
  1000a128  CMP ESI,dword ptr [0x1000f838]    ; DAT_1000f838
  1000a12e  MOV dword ptr [EBP + 0x8],ESI
  1000a131  JZ 0x1000a2a1    ; LAB_1000a2a1
  1000a137  XOR EBX,EBX
  1000a139  CMP ESI,EBX
  1000a13b  JZ 0x1000a297    ; LAB_1000a297
  1000a141  XOR EDX,EDX
  1000a143  MOV EAX,0x1000f008    ; DAT_1000f008
LAB_1000a148:
  1000a148  CMP dword ptr [EAX],ESI    ; DAT_1000f008 DAT_1000f038
  1000a14a  JZ 0x1000a1be    ; LAB_1000a1be
  1000a14c  ADD EAX,0x30
  1000a14f  INC EDX
  1000a150  CMP EAX,0x1000f0f8    ; DAT_1000f0f8
  1000a155  JL 0x1000a148    ; LAB_1000a148
  1000a157  LEA EAX,[EBP + -0x18]
  1000a15a  PUSH EAX
  1000a15b  PUSH ESI
  1000a15c  CALL dword ptr [0x1000d0ac]    ; PTR_GetCPInfo_1000d0ac KERNEL32.DLL::GetCPInfo
  1000a162  CMP EAX,0x1
  1000a165  JNZ 0x1000a28f    ; LAB_1000a28f
  1000a16b  PUSH 0x40
  1000a16d  XOR EAX,EAX
  1000a16f  POP ECX
  1000a170  MOV EDI,0x1000f960    ; DAT_1000f960
  1000a175  CMP dword ptr [EBP + -0x18],0x1
  1000a179  MOV dword ptr [0x1000f838],ESI    ; DAT_1000f838
  1000a17f  STOSD.REP ES:EDI    ; DAT_1000f960 DAT_1000f964
  1000a181  STOSB ES:EDI    ; DAT_1000f964
  1000a182  MOV dword ptr [0x1000fa64],EBX    ; DAT_1000fa64
  1000a188  JBE 0x1000a27d    ; LAB_1000a27d
  1000a18e  CMP byte ptr [EBP + -0x12],0x0
  1000a192  JZ 0x1000a253    ; LAB_1000a253
  1000a198  LEA ECX,[EBP + -0x11]
LAB_1000a19b:
  1000a19b  MOV DL,byte ptr [ECX]
  1000a19d  TEST DL,DL
  1000a19f  JZ 0x1000a253    ; LAB_1000a253
  1000a1a5  MOVZX EAX,byte ptr [ECX + -0x1]
  1000a1a9  MOVZX EDX,DL
LAB_1000a1ac:
  1000a1ac  CMP EAX,EDX
  1000a1ae  JA 0x1000a247    ; LAB_1000a247
  1000a1b4  OR byte ptr [EAX + 0x1000f961],0x4    ; DAT_1000f960+1 DAT_1000f960+2
  1000a1bb  INC EAX
  1000a1bc  JMP 0x1000a1ac    ; LAB_1000a1ac
LAB_1000a1be:
  1000a1be  PUSH 0x40
  1000a1c0  XOR EAX,EAX
  1000a1c2  POP ECX
  1000a1c3  MOV EDI,0x1000f960    ; DAT_1000f960
  1000a1c8  STOSD.REP ES:EDI    ; DAT_1000f960 DAT_1000f964
  1000a1ca  LEA ESI,[EDX + EDX*0x2]
  1000a1cd  MOV dword ptr [EBP + -0x4],EBX
  1000a1d0  SHL ESI,0x4
  1000a1d3  STOSB ES:EDI    ; DAT_1000f964
  1000a1d4  LEA EBX,[ESI + 0x1000f018]    ; DAT_1000f048
LAB_1000a1da:
  1000a1da  CMP byte ptr [EBX],0x0    ; DAT_1000f048 DAT_1000f050
  1000a1dd  MOV ECX,EBX
  1000a1df  JZ 0x1000a20d    ; LAB_1000a20d
LAB_1000a1e1:
  1000a1e1  MOV DL,byte ptr [ECX + 0x1]    ; DAT_1000f049 DAT_1000f051 DAT_1000f053
  1000a1e4  TEST DL,DL
  1000a1e6  JZ 0x1000a20d    ; LAB_1000a20d
  1000a1e8  MOVZX EAX,byte ptr [ECX]    ; DAT_1000f048 DAT_1000f050 DAT_1000f052
  1000a1eb  MOVZX EDI,DL
  1000a1ee  CMP EAX,EDI
  1000a1f0  JA 0x1000a206    ; LAB_1000a206
  1000a1f2  MOV EDX,dword ptr [EBP + -0x4]
  1000a1f5  MOV DL,byte ptr [EDX + 0x1000f000]    ; DAT_1000f000 DAT_1000f001
LAB_1000a1fb:
  1000a1fb  OR byte ptr [EAX + 0x1000f961],DL    ; DAT_1000f960+1 DAT_1000f960+2
  1000a201  INC EAX
  1000a202  CMP EAX,EDI
  1000a204  JBE 0x1000a1fb    ; LAB_1000a1fb
LAB_1000a206:
  1000a206  INC ECX
  1000a207  INC ECX
  1000a208  CMP byte ptr [ECX],0x0    ; DAT_1000f04a DAT_1000f052
  1000a20b  JNZ 0x1000a1e1    ; LAB_1000a1e1
LAB_1000a20d:
  1000a20d  INC dword ptr [EBP + -0x4]
  1000a210  ADD EBX,0x8
  1000a213  CMP dword ptr [EBP + -0x4],0x4
  1000a217  JC 0x1000a1da    ; LAB_1000a1da
  1000a219  MOV EAX,dword ptr [EBP + 0x8]
  1000a21c  MOV dword ptr [0x1000f84c],0x1    ; DAT_1000f84c
  1000a226  PUSH EAX
  1000a227  MOV [0x1000f838],EAX    ; DAT_1000f838
  1000a22c  CALL 0x1000a2f7    ; FUN_1000a2f7
  1000a231  LEA ESI,[ESI + 0x1000f00c]    ; DAT_1000f03c
  1000a237  MOV EDI,0x1000f840    ; DAT_1000f840
  1000a23c  MOVSD ES:EDI,ESI    ; DAT_1000f03c DAT_1000f840
  1000a23d  MOVSD ES:EDI,ESI    ; DAT_1000f040 DAT_1000f844
  1000a23e  POP ECX
  1000a23f  MOV [0x1000fa64],EAX    ; DAT_1000fa64
  1000a244  MOVSD ES:EDI,ESI    ; DAT_1000f044 DAT_1000f848
  1000a245  JMP 0x1000a29c    ; LAB_1000a29c
LAB_1000a247:
  1000a247  INC ECX
  1000a248  INC ECX
  1000a249  CMP byte ptr [ECX + -0x1],0x0
  1000a24d  JNZ 0x1000a19b    ; LAB_1000a19b
LAB_1000a253:
  1000a253  PUSH 0x1
  1000a255  POP EAX
LAB_1000a256:
  1000a256  OR byte ptr [EAX + 0x1000f961],0x8    ; DAT_1000f960+2 DAT_1000f960+3
  1000a25d  INC EAX
  1000a25e  CMP EAX,0xff
  1000a263  JC 0x1000a256    ; LAB_1000a256
  1000a265  PUSH ESI
  1000a266  CALL 0x1000a2f7    ; FUN_1000a2f7
  1000a26b  POP ECX
  1000a26c  MOV [0x1000fa64],EAX    ; DAT_1000fa64
  1000a271  MOV dword ptr [0x1000f84c],0x1    ; DAT_1000f84c
  1000a27b  JMP 0x1000a283    ; LAB_1000a283
LAB_1000a27d:
  1000a27d  MOV dword ptr [0x1000f84c],EBX    ; DAT_1000f84c
LAB_1000a283:
  1000a283  XOR EAX,EAX
  1000a285  MOV EDI,0x1000f840    ; DAT_1000f840
  1000a28a  STOSD ES:EDI    ; DAT_1000f840
  1000a28b  STOSD ES:EDI    ; DAT_1000f844
  1000a28c  STOSD ES:EDI    ; DAT_1000f848
  1000a28d  JMP 0x1000a29c    ; LAB_1000a29c
LAB_1000a28f:
  1000a28f  CMP dword ptr [0x1000f7ec],EBX    ; DAT_1000f7ec
  1000a295  JZ 0x1000a2a5    ; LAB_1000a2a5
LAB_1000a297:
  1000a297  CALL 0x1000a32a    ; FUN_1000a32a
LAB_1000a29c:
  1000a29c  CALL 0x1000a353    ; FUN_1000a353
LAB_1000a2a1:
  1000a2a1  XOR EAX,EAX
  1000a2a3  JMP 0x1000a2a8    ; LAB_1000a2a8
LAB_1000a2a5:
  1000a2a5  OR EAX,0xffffffff
LAB_1000a2a8:
  1000a2a8  POP EDI
  1000a2a9  POP ESI
  1000a2aa  POP EBX
  1000a2ab  LEAVE
  1000a2ac  RET

;==== FUNCTION FUN_1000a2ad @ 1000a2ad : int FUN_1000a2ad(int param_1)
  1000a2ad  MOV EAX,dword ptr [ESP + 0x4]
  1000a2b1  AND dword ptr [0x1000f7ec],0x0    ; DAT_1000f7ec
  1000a2b8  CMP EAX,-0x2
  1000a2bb  JNZ 0x1000a2cd    ; LAB_1000a2cd
  1000a2bd  MOV dword ptr [0x1000f7ec],0x1    ; DAT_1000f7ec
  1000a2c7  JMP dword ptr [0x1000d0b4]    ; PTR_GetOEMCP_1000d0b4 KERNEL32.DLL::GetOEMCP
LAB_1000a2cd:
  1000a2cd  CMP EAX,-0x3
  1000a2d0  JNZ 0x1000a2e2    ; LAB_1000a2e2
  1000a2d2  MOV dword ptr [0x1000f7ec],0x1    ; DAT_1000f7ec
  1000a2dc  JMP dword ptr [0x1000d0b0]    ; PTR_GetACP_1000d0b0 KERNEL32.DLL::GetACP
LAB_1000a2e2:
  1000a2e2  CMP EAX,-0x4
  1000a2e5  JNZ 0x1000a2f6    ; LAB_1000a2f6
  1000a2e7  MOV EAX,[0x1000f81c]    ; DAT_1000f81c
  1000a2ec  MOV dword ptr [0x1000f7ec],0x1    ; DAT_1000f7ec
LAB_1000a2f6:
  1000a2f6  RET

;==== FUNCTION FUN_1000a2f7 @ 1000a2f7 : undefined4 FUN_1000a2f7(int param_1)
  1000a2f7  MOV EAX,dword ptr [ESP + 0x4]
  1000a2fb  SUB EAX,0x3a4
  1000a300  JZ 0x1000a324    ; LAB_1000a324
  1000a302  SUB EAX,0x4
  1000a305  JZ 0x1000a31e    ; LAB_1000a31e
  1000a307  SUB EAX,0xd
  1000a30a  JZ 0x1000a318    ; LAB_1000a318
  1000a30c  DEC EAX
  1000a30d  JZ 0x1000a312    ; LAB_1000a312
  1000a30f  XOR EAX,EAX
  1000a311  RET
LAB_1000a312:
  1000a312  MOV EAX,0x404
  1000a317  RET
LAB_1000a318:
  1000a318  MOV EAX,0x412
  1000a31d  RET
LAB_1000a31e:
  1000a31e  MOV EAX,0x804
  1000a323  RET
LAB_1000a324:
  1000a324  MOV EAX,0x411
  1000a329  RET

;==== FUNCTION FUN_1000a32a @ 1000a32a : undefined FUN_1000a32a(void)
  1000a32a  PUSH EDI
  1000a32b  PUSH 0x40
  1000a32d  POP ECX
  1000a32e  XOR EAX,EAX
  1000a330  MOV EDI,0x1000f960    ; DAT_1000f960
  1000a335  STOSD.REP ES:EDI    ; DAT_1000f960 DAT_1000f964
  1000a337  STOSB ES:EDI    ; DAT_1000f964
  1000a338  XOR EAX,EAX
  1000a33a  MOV EDI,0x1000f840    ; DAT_1000f840
  1000a33f  MOV [0x1000f838],EAX    ; DAT_1000f838
  1000a344  MOV [0x1000f84c],EAX    ; DAT_1000f84c
  1000a349  MOV [0x1000fa64],EAX    ; DAT_1000fa64
  1000a34e  STOSD ES:EDI    ; DAT_1000f840
  1000a34f  STOSD ES:EDI    ; DAT_1000f844
  1000a350  STOSD ES:EDI    ; DAT_1000f848
  1000a351  POP EDI
  1000a352  RET

;==== FUNCTION FUN_1000a353 @ 1000a353 : undefined FUN_1000a353(void)
  1000a353  PUSH EBP
  1000a354  MOV EBP,ESP
  1000a356  SUB ESP,0x514
  1000a35c  LEA EAX,[EBP + -0x14]
  1000a35f  PUSH ESI
  1000a360  PUSH EAX
  1000a361  PUSH dword ptr [0x1000f838]    ; DAT_1000f838
  1000a367  CALL dword ptr [0x1000d0ac]    ; PTR_GetCPInfo_1000d0ac KERNEL32.DLL::GetCPInfo
  1000a36d  CMP EAX,0x1
  1000a370  JNZ 0x1000a48c    ; LAB_1000a48c
  1000a376  XOR EAX,EAX
  1000a378  MOV ESI,0x100
LAB_1000a37d:
  1000a37d  MOV byte ptr [EBP + EAX*0x1 + 0xfffffeec],AL
  1000a384  INC EAX
  1000a385  CMP EAX,ESI
  1000a387  JC 0x1000a37d    ; LAB_1000a37d
  1000a389  MOV AL,byte ptr [EBP + -0xe]
  1000a38c  MOV byte ptr [EBP + 0xfffffeec],0x20
  1000a393  TEST AL,AL
  1000a395  JZ 0x1000a3ce    ; LAB_1000a3ce
  1000a397  PUSH EBX
  1000a398  PUSH EDI
  1000a399  LEA EDX,[EBP + -0xd]
LAB_1000a39c:
  1000a39c  MOVZX ECX,byte ptr [EDX]
  1000a39f  MOVZX EAX,AL
  1000a3a2  CMP EAX,ECX
  1000a3a4  JA 0x1000a3c3    ; LAB_1000a3c3
  1000a3a6  SUB ECX,EAX
  1000a3a8  LEA EDI,[EBP + EAX*0x1 + 0xfffffeec]
  1000a3af  INC ECX
  1000a3b0  MOV EAX,0x20202020
  1000a3b5  MOV EBX,ECX
  1000a3b7  SHR ECX,0x2
  1000a3ba  STOSD.REP ES:EDI
  1000a3bc  MOV ECX,EBX
  1000a3be  AND ECX,0x3
  1000a3c1  STOSB.REP ES:EDI
LAB_1000a3c3:
  1000a3c3  INC EDX
  1000a3c4  INC EDX
  1000a3c5  MOV AL,byte ptr [EDX + -0x1]
  1000a3c8  TEST AL,AL
  1000a3ca  JNZ 0x1000a39c    ; LAB_1000a39c
  1000a3cc  POP EDI
  1000a3cd  POP EBX
LAB_1000a3ce:
  1000a3ce  PUSH 0x0
  1000a3d0  LEA EAX,[EBP + 0xfffffaec]
  1000a3d6  PUSH dword ptr [0x1000fa64]    ; DAT_1000fa64
  1000a3dc  PUSH dword ptr [0x1000f838]    ; DAT_1000f838
  1000a3e2  PUSH EAX
  1000a3e3  LEA EAX,[EBP + 0xfffffeec]
  1000a3e9  PUSH ESI
  1000a3ea  PUSH EAX
  1000a3eb  PUSH 0x1
  1000a3ed  CALL 0x10009fcb    ; FUN_10009fcb
  1000a3f2  PUSH 0x0
  1000a3f4  LEA EAX,[EBP + 0xfffffdec]
  1000a3fa  PUSH dword ptr [0x1000f838]    ; DAT_1000f838
  1000a400  PUSH ESI
  1000a401  PUSH EAX
  1000a402  LEA EAX,[EBP + 0xfffffeec]
  1000a408  PUSH ESI
  1000a409  PUSH EAX
  1000a40a  PUSH ESI
  1000a40b  PUSH dword ptr [0x1000fa64]    ; DAT_1000fa64
  1000a411  CALL 0x1000ab52    ; FUN_1000ab52
  1000a416  PUSH 0x0
  1000a418  LEA EAX,[EBP + 0xfffffcec]
  1000a41e  PUSH dword ptr [0x1000f838]    ; DAT_1000f838
  1000a424  PUSH ESI
  1000a425  PUSH EAX
  1000a426  LEA EAX,[EBP + 0xfffffeec]
  1000a42c  PUSH ESI
  1000a42d  PUSH EAX
  1000a42e  PUSH 0x200
  1000a433  PUSH dword ptr [0x1000fa64]    ; DAT_1000fa64
  1000a439  CALL 0x1000ab52    ; FUN_1000ab52
  1000a43e  ADD ESP,0x5c
  1000a441  XOR EAX,EAX
  1000a443  LEA ECX,[EBP + 0xfffffaec]
LAB_1000a449:
  1000a449  MOV DX,word ptr [ECX]
  1000a44c  TEST DL,0x1
  1000a44f  JZ 0x1000a467    ; LAB_1000a467
  1000a451  OR byte ptr [EAX + 0x1000f961],0x10    ; DAT_1000f960+1 DAT_1000f960+2
  1000a458  MOV DL,byte ptr [EBP + EAX*0x1 + 0xfffffdec]
LAB_1000a45f:
  1000a45f  MOV byte ptr [EAX + 0x1000f860],DL    ; DAT_1000f860 DAT_1000f861
  1000a465  JMP 0x1000a483    ; LAB_1000a483
LAB_1000a467:
  1000a467  TEST DL,0x2
  1000a46a  JZ 0x1000a47c    ; LAB_1000a47c
  1000a46c  OR byte ptr [EAX + 0x1000f961],0x20    ; DAT_1000f960+2
  1000a473  MOV DL,byte ptr [EBP + EAX*0x1 + 0xfffffcec]
  1000a47a  JMP 0x1000a45f    ; LAB_1000a45f
LAB_1000a47c:
  1000a47c  AND byte ptr [EAX + 0x1000f860],0x0    ; DAT_1000f861
LAB_1000a483:
  1000a483  INC EAX
  1000a484  INC ECX
  1000a485  INC ECX
  1000a486  CMP EAX,ESI
  1000a488  JC 0x1000a449    ; LAB_1000a449
  1000a48a  JMP 0x1000a4d5    ; LAB_1000a4d5
LAB_1000a48c:
  1000a48c  XOR EAX,EAX
  1000a48e  MOV ESI,0x100
LAB_1000a493:
  1000a493  CMP EAX,0x41
  1000a496  JC 0x1000a4b1    ; LAB_1000a4b1
  1000a498  CMP EAX,0x5a
  1000a49b  JA 0x1000a4b1    ; LAB_1000a4b1
  1000a49d  OR byte ptr [EAX + 0x1000f961],0x10    ; DAT_1000f960+2
  1000a4a4  MOV CL,AL
  1000a4a6  ADD CL,0x20
LAB_1000a4a9:
  1000a4a9  MOV byte ptr [EAX + 0x1000f860],CL    ; DAT_1000f861
  1000a4af  JMP 0x1000a4d0    ; LAB_1000a4d0
LAB_1000a4b1:
  1000a4b1  CMP EAX,0x61
  1000a4b4  JC 0x1000a4c9    ; LAB_1000a4c9
  1000a4b6  CMP EAX,0x7a
  1000a4b9  JA 0x1000a4c9    ; LAB_1000a4c9
  1000a4bb  OR byte ptr [EAX + 0x1000f961],0x20    ; DAT_1000f960+2
  1000a4c2  MOV CL,AL
  1000a4c4  SUB CL,0x20
  1000a4c7  JMP 0x1000a4a9    ; LAB_1000a4a9
LAB_1000a4c9:
  1000a4c9  AND byte ptr [EAX + 0x1000f860],0x0    ; DAT_1000f860 DAT_1000f861
LAB_1000a4d0:
  1000a4d0  INC EAX
  1000a4d1  CMP EAX,ESI
  1000a4d3  JC 0x1000a493    ; LAB_1000a493
LAB_1000a4d5:
  1000a4d5  POP ESI
  1000a4d6  LEAVE
  1000a4d7  RET

;==== FUNCTION FUN_1000a4e8 @ 1000a4e8 : undefined FUN_1000a4e8(void)
  1000a4e8  CMP dword ptr [0x10010bac],0x0    ; DAT_10010bac
  1000a4ef  JNZ 0x1000a503    ; LAB_1000a503
  1000a4f1  PUSH -0x3
  1000a4f3  CALL 0x1000a114    ; FUN_1000a114
  1000a4f8  POP ECX
  1000a4f9  MOV dword ptr [0x10010bac],0x1    ; DAT_10010bac
LAB_1000a503:
  1000a503  RET

;==== FUNCTION FUN_1000a510 @ 1000a510 : undefined4 * FUN_1000a510(undefined4 * param_1, undefined4 * param_2, uint param_3)
  1000a510  PUSH EBP
  1000a511  MOV EBP,ESP
  1000a513  PUSH EDI
  1000a514  PUSH ESI
  1000a515  MOV ESI,dword ptr [EBP + 0xc]
  1000a518  MOV ECX,dword ptr [EBP + 0x10]
  1000a51b  MOV EDI,dword ptr [EBP + 0x8]
  1000a51e  MOV EAX,ECX
  1000a520  MOV EDX,ECX
  1000a522  ADD EAX,ESI
  1000a524  CMP EDI,ESI
  1000a526  JBE 0x1000a530    ; LAB_1000a530
  1000a528  CMP EDI,EAX
  1000a52a  JC 0x1000a6a8    ; LAB_1000a6a8
LAB_1000a530:
  1000a530  TEST EDI,0x3
  1000a536  JNZ 0x1000a54c    ; LAB_1000a54c
  1000a538  SHR ECX,0x2
  1000a53b  AND EDX,0x3
  1000a53e  CMP ECX,0x8
  1000a541  JC 0x1000a56c    ; switchD_1000a56c::switchD
  1000a543  MOVSD.REP ES:EDI,ESI
switchD:
  1000a545  JMP dword ptr [EDX*0x4 + 0x1000a658]    ; switchD_1000a545::caseD_0 switchD_1000a545::caseD_1 switchD_1000a545::caseD_2 switchD_1000a545::caseD_3 switchD_1000a545::switchdataD_1000a658
LAB_1000a54c:
  1000a54c  MOV EAX,EDI
  1000a54e  MOV EDX,0x3
  1000a553  SUB ECX,0x4
  1000a556  JC 0x1000a564    ; switchD_1000a564::switchD
default:
  1000a558  AND EAX,0x3
  1000a55b  ADD ECX,EAX
switchD:
  1000a55d  JMP dword ptr [EAX*0x4 + 0x1000a570]    ; switchD_1000a55d::caseD_1 switchD_1000a55d::caseD_2 switchD_1000a55d::caseD_3 switchD_1000a55d::switchdataD_1000a574
switchD:
  1000a564  JMP dword ptr [ECX*0x4 + 0x1000a668]    ; switchD_1000a545::caseD_0 switchD_1000a545::caseD_1 switchD_1000a545::caseD_2 switchD_1000a545::caseD_3
switchD:
  1000a56c  JMP dword ptr [ECX*0x4 + 0x1000a5ec]    ; switchD_1000a56c::caseD_0 switchD_1000a56c::caseD_1 switchD_1000a56c::caseD_2 switchD_1000a56c::caseD_3 switchD_1000a56c::caseD_4 switchD_1000a56c::caseD_5 switchD_1000a56c::caseD_6 switchD_1000a56c::caseD_7 switchD_1000a56c::switchdataD_1000a5ec
caseD_1:
  1000a580  AND EDX,ECX
  1000a582  MOV AL,byte ptr [ESI]
  1000a584  MOV byte ptr [EDI],AL
  1000a586  MOV AL,byte ptr [ESI + 0x1]
  1000a589  MOV byte ptr [EDI + 0x1],AL
  1000a58c  MOV AL,byte ptr [ESI + 0x2]
  1000a58f  SHR ECX,0x2
  1000a592  MOV byte ptr [EDI + 0x2],AL
  1000a595  ADD ESI,0x3
  1000a598  ADD EDI,0x3
  1000a59b  CMP ECX,0x8
  1000a59e  JC 0x1000a56c    ; switchD_1000a56c::switchD
  1000a5a0  MOVSD.REP ES:EDI,ESI
switchD:
  1000a5a2  JMP dword ptr [EDX*0x4 + 0x1000a658]    ; switchD_1000a545::caseD_0 switchD_1000a545::caseD_1 switchD_1000a545::caseD_2 switchD_1000a545::caseD_3 switchD_1000a545::switchdataD_1000a658
caseD_2:
  1000a5ac  AND EDX,ECX
  1000a5ae  MOV AL,byte ptr [ESI]
  1000a5b0  MOV byte ptr [EDI],AL
  1000a5b2  MOV AL,byte ptr [ESI + 0x1]
  1000a5b5  SHR ECX,0x2
  1000a5b8  MOV byte ptr [EDI + 0x1],AL
  1000a5bb  ADD ESI,0x2
  1000a5be  ADD EDI,0x2
  1000a5c1  CMP ECX,0x8
  1000a5c4  JC 0x1000a56c    ; switchD_1000a56c::switchD
  1000a5c6  MOVSD.REP ES:EDI,ESI
switchD:
  1000a5c8  JMP dword ptr [EDX*0x4 + 0x1000a658]    ; switchD_1000a545::caseD_0 switchD_1000a545::caseD_1 switchD_1000a545::caseD_2 switchD_1000a545::caseD_3 switchD_1000a545::switchdataD_1000a658
caseD_3:
  1000a5d0  AND EDX,ECX
  1000a5d2  MOV AL,byte ptr [ESI]
  1000a5d4  MOV byte ptr [EDI],AL
  1000a5d6  INC ESI
  1000a5d7  SHR ECX,0x2
  1000a5da  INC EDI
  1000a5db  CMP ECX,0x8
  1000a5de  JC 0x1000a56c    ; switchD_1000a56c::switchD
  1000a5e0  MOVSD.REP ES:EDI,ESI
switchD:
  1000a5e2  JMP dword ptr [EDX*0x4 + 0x1000a658]    ; switchD_1000a545::caseD_0 switchD_1000a545::caseD_1 switchD_1000a545::caseD_2 switchD_1000a545::caseD_3 switchD_1000a545::switchdataD_1000a658
caseD_7:
  1000a60c  MOV EAX,dword ptr [ESI + ECX*0x4 + -0x1c]
  1000a610  MOV dword ptr [EDI + ECX*0x4 + -0x1c],EAX
caseD_6:
  1000a614  MOV EAX,dword ptr [ESI + ECX*0x4 + -0x18]
  1000a618  MOV dword ptr [EDI + ECX*0x4 + -0x18],EAX
caseD_5:
  1000a61c  MOV EAX,dword ptr [ESI + ECX*0x4 + -0x14]
  1000a620  MOV dword ptr [EDI + ECX*0x4 + -0x14],EAX
caseD_4:
  1000a624  MOV EAX,dword ptr [ESI + ECX*0x4 + -0x10]
  1000a628  MOV dword ptr [EDI + ECX*0x4 + -0x10],EAX
caseD_3:
  1000a62c  MOV EAX,dword ptr [ESI + ECX*0x4 + -0xc]
  1000a630  MOV dword ptr [EDI + ECX*0x4 + -0xc],EAX
caseD_2:
  1000a634  MOV EAX,dword ptr [ESI + ECX*0x4 + -0x8]
  1000a638  MOV dword ptr [EDI + ECX*0x4 + -0x8],EAX
caseD_1:
  1000a63c  MOV EAX,dword ptr [ESI + ECX*0x4 + -0x4]
  1000a640  MOV dword ptr [EDI + ECX*0x4 + -0x4],EAX
  1000a644  LEA EAX,[ECX*0x4 + 0x0]
  1000a64b  ADD ESI,EAX
  1000a64d  ADD EDI,EAX
caseD_0:
  1000a64f  JMP dword ptr [EDX*0x4 + 0x1000a658]    ; switchD_1000a545::caseD_0 switchD_1000a545::caseD_1 switchD_1000a545::caseD_2 switchD_1000a545::caseD_3 switchD_1000a545::switchdataD_1000a658
caseD_0:
  1000a668  MOV EAX,dword ptr [EBP + 0x8]
  1000a66b  POP ESI
  1000a66c  POP EDI
  1000a66d  LEAVE
  1000a66e  RET
caseD_1:
  1000a670  MOV AL,byte ptr [ESI]
  1000a672  MOV byte ptr [EDI],AL
  1000a674  MOV EAX,dword ptr [EBP + 0x8]
  1000a677  POP ESI
  1000a678  POP EDI
  1000a679  LEAVE
  1000a67a  RET
caseD_2:
  1000a67c  MOV AL,byte ptr [ESI]
  1000a67e  MOV byte ptr [EDI],AL
  1000a680  MOV AL,byte ptr [ESI + 0x1]
  1000a683  MOV byte ptr [EDI + 0x1],AL
  1000a686  MOV EAX,dword ptr [EBP + 0x8]
  1000a689  POP ESI
  1000a68a  POP EDI
  1000a68b  LEAVE
  1000a68c  RET
caseD_3:
  1000a690  MOV AL,byte ptr [ESI]
  1000a692  MOV byte ptr [EDI],AL
  1000a694  MOV AL,byte ptr [ESI + 0x1]
  1000a697  MOV byte ptr [EDI + 0x1],AL
  1000a69a  MOV AL,byte ptr [ESI + 0x2]
  1000a69d  MOV byte ptr [EDI + 0x2],AL
  1000a6a0  MOV EAX,dword ptr [EBP + 0x8]
  1000a6a3  POP ESI
  1000a6a4  POP EDI
  1000a6a5  LEAVE
  1000a6a6  RET
LAB_1000a6a8:
  1000a6a8  LEA ESI,[ECX + ESI*0x1 + -0x4]
  1000a6ac  LEA EDI,[ECX + EDI*0x1 + -0x4]
  1000a6b0  TEST EDI,0x3
  1000a6b6  JNZ 0x1000a6dc    ; LAB_1000a6dc
  1000a6b8  SHR ECX,0x2
  1000a6bb  AND EDX,0x3
  1000a6be  CMP ECX,0x8
  1000a6c1  JC 0x1000a6d0    ; LAB_1000a6d0
  1000a6c3  STD
  1000a6c4  MOVSD.REP ES:EDI,ESI
  1000a6c6  CLD
switchD:
  1000a6c7  JMP dword ptr [EDX*0x4 + 0x1000a7f0]    ; switchD_1000a6c7::caseD_0 switchD_1000a6c7::caseD_1 switchD_1000a6c7::caseD_2 switchD_1000a6c7::caseD_3 switchD_1000a6c7::switchdataD_1000a7f0
LAB_1000a6d0:
  1000a6d0  NEG ECX
switchD:
  1000a6d2  JMP dword ptr [ECX*0x4 + 0x1000a7a0]    ; switchD_1000a6d2::caseD_0 switchD_1000a6d2::caseD_1 switchD_1000a6d2::caseD_2 switchD_1000a6d2::caseD_3 switchD_1000a6d2::caseD_4 switchD_1000a6d2::caseD_5 switchD_1000a6d2::caseD_6 switchD_1000a6d2::caseD_7 PTR_caseD_0_1000a7a0
LAB_1000a6dc:
  1000a6dc  MOV EAX,EDI
  1000a6de  MOV EDX,0x3
  1000a6e3  CMP ECX,0x4
  1000a6e6  JC 0x1000a6f4    ; switchD_1000a6f4::switchD
default:
  1000a6e8  AND EAX,0x3
  1000a6eb  SUB ECX,EAX
switchD:
  1000a6ed  JMP dword ptr [EAX*0x4 + 0x1000a6f8]    ; switchD_1000a6ed::caseD_1 switchD_1000a6ed::caseD_2 switchD_1000a6ed::caseD_3 switchD_1000a6ed::switchdataD_1000a6fc
switchD:
  1000a6f4  JMP dword ptr [ECX*0x4 + 0x1000a7f0]    ; switchD_1000a6c7::caseD_0 switchD_1000a6c7::caseD_1 switchD_1000a6c7::caseD_2 switchD_1000a6c7::caseD_3 switchD_1000a6c7::switchdataD_1000a7f0
caseD_1:
  1000a708  MOV AL,byte ptr [ESI + 0x3]
  1000a70b  AND EDX,ECX
  1000a70d  MOV byte ptr [EDI + 0x3],AL
  1000a710  DEC ESI
  1000a711  SHR ECX,0x2
  1000a714  DEC EDI
  1000a715  CMP ECX,0x8
  1000a718  JC 0x1000a6d0    ; LAB_1000a6d0
  1000a71a  STD
  1000a71b  MOVSD.REP ES:EDI,ESI
  1000a71d  CLD
switchD:
  1000a71e  JMP dword ptr [EDX*0x4 + 0x1000a7f0]    ; switchD_1000a6c7::caseD_0 switchD_1000a6c7::caseD_1 switchD_1000a6c7::caseD_2 switchD_1000a6c7::caseD_3 switchD_1000a6c7::switchdataD_1000a7f0
caseD_2:
  1000a728  MOV AL,byte ptr [ESI + 0x3]
  1000a72b  AND EDX,ECX
  1000a72d  MOV byte ptr [EDI + 0x3],AL
  1000a730  MOV AL,byte ptr [ESI + 0x2]
  1000a733  SHR ECX,0x2
  1000a736  MOV byte ptr [EDI + 0x2],AL
  1000a739  SUB ESI,0x2
  1000a73c  SUB EDI,0x2
  1000a73f  CMP ECX,0x8
  1000a742  JC 0x1000a6d0    ; LAB_1000a6d0
  1000a744  STD
  1000a745  MOVSD.REP ES:EDI,ESI
  1000a747  CLD
switchD:
  1000a748  JMP dword ptr [EDX*0x4 + 0x1000a7f0]    ; switchD_1000a6c7::caseD_0 switchD_1000a6c7::caseD_1 switchD_1000a6c7::caseD_2 switchD_1000a6c7::caseD_3 switchD_1000a6c7::switchdataD_1000a7f0
caseD_3:
  1000a750  MOV AL,byte ptr [ESI + 0x3]
  1000a753  AND EDX,ECX
  1000a755  MOV byte ptr [EDI + 0x3],AL
  1000a758  MOV AL,byte ptr [ESI + 0x2]
  1000a75b  MOV byte ptr [EDI + 0x2],AL
  1000a75e  MOV AL,byte ptr [ESI + 0x1]
  1000a761  SHR ECX,0x2
  1000a764  MOV byte ptr [EDI + 0x1],AL
  1000a767  SUB ESI,0x3
  1000a76a  SUB EDI,0x3
  1000a76d  CMP ECX,0x8
  1000a770  JC 0x1000a6d0    ; LAB_1000a6d0
  1000a776  STD
  1000a777  MOVSD.REP ES:EDI,ESI
  1000a779  CLD
switchD:
  1000a77a  JMP dword ptr [EDX*0x4 + 0x1000a7f0]    ; switchD_1000a6c7::caseD_0 switchD_1000a6c7::caseD_1 switchD_1000a6c7::caseD_2 switchD_1000a6c7::caseD_3 switchD_1000a6c7::switchdataD_1000a7f0
caseD_7:
  1000a7a4  MOV EAX,dword ptr [ESI + ECX*0x4 + 0x1c]
  1000a7a8  MOV dword ptr [EDI + ECX*0x4 + 0x1c],EAX
caseD_6:
  1000a7ac  MOV EAX,dword ptr [ESI + ECX*0x4 + 0x18]
  1000a7b0  MOV dword ptr [EDI + ECX*0x4 + 0x18],EAX
caseD_5:
  1000a7b4  MOV EAX,dword ptr [ESI + ECX*0x4 + 0x14]
  1000a7b8  MOV dword ptr [EDI + ECX*0x4 + 0x14],EAX
caseD_4:
  1000a7bc  MOV EAX,dword ptr [ESI + ECX*0x4 + 0x10]
  1000a7c0  MOV dword ptr [EDI + ECX*0x4 + 0x10],EAX
caseD_3:
  1000a7c4  MOV EAX,dword ptr [ESI + ECX*0x4 + 0xc]
  1000a7c8  MOV dword ptr [EDI + ECX*0x4 + 0xc],EAX
caseD_2:
  1000a7cc  MOV EAX,dword ptr [ESI + ECX*0x4 + 0x8]
  1000a7d0  MOV dword ptr [EDI + ECX*0x4 + 0x8],EAX
caseD_1:
  1000a7d4  MOV EAX,dword ptr [ESI + ECX*0x4 + 0x4]
  1000a7d8  MOV dword ptr [EDI + ECX*0x4 + 0x4],EAX
  1000a7dc  LEA EAX,[ECX*0x4 + 0x0]
  1000a7e3  ADD ESI,EAX
  1000a7e5  ADD EDI,EAX
caseD_0:
  1000a7e7  JMP dword ptr [EDX*0x4 + 0x1000a7f0]    ; switchD_1000a6c7::caseD_0 switchD_1000a6c7::caseD_1 switchD_1000a6c7::caseD_2 switchD_1000a6c7::caseD_3 switchD_1000a6c7::switchdataD_1000a7f0
caseD_0:
  1000a800  MOV EAX,dword ptr [EBP + 0x8]
  1000a803  POP ESI
  1000a804  POP EDI
  1000a805  LEAVE
  1000a806  RET
caseD_1:
  1000a808  MOV AL,byte ptr [ESI + 0x3]
  1000a80b  MOV byte ptr [EDI + 0x3],AL
  1000a80e  MOV EAX,dword ptr [EBP + 0x8]
  1000a811  POP ESI
  1000a812  POP EDI
  1000a813  LEAVE
  1000a814  RET
caseD_2:
  1000a818  MOV AL,byte ptr [ESI + 0x3]
  1000a81b  MOV byte ptr [EDI + 0x3],AL
  1000a81e  MOV AL,byte ptr [ESI + 0x2]
  1000a821  MOV byte ptr [EDI + 0x2],AL
  1000a824  MOV EAX,dword ptr [EBP + 0x8]
  1000a827  POP ESI
  1000a828  POP EDI
  1000a829  LEAVE
  1000a82a  RET
caseD_3:
  1000a82c  MOV AL,byte ptr [ESI + 0x3]
  1000a82f  MOV byte ptr [EDI + 0x3],AL
  1000a832  MOV AL,byte ptr [ESI + 0x2]
  1000a835  MOV byte ptr [EDI + 0x2],AL
  1000a838  MOV AL,byte ptr [ESI + 0x1]
  1000a83b  MOV byte ptr [EDI + 0x1],AL
  1000a83e  MOV EAX,dword ptr [EBP + 0x8]
  1000a841  POP ESI
  1000a842  POP EDI
  1000a843  LEAVE
  1000a844  RET

;==== FUNCTION FUN_1000a845 @ 1000a845 : int FUN_1000a845(undefined4 param_1, undefined4 param_2, undefined4 param_3)
  1000a845  PUSH EBX
  1000a846  XOR EBX,EBX
  1000a848  CMP dword ptr [0x1000f7f0],EBX    ; DAT_1000f7f0
  1000a84e  PUSH ESI
  1000a84f  PUSH EDI
  1000a850  JNZ 0x1000a894    ; LAB_1000a894
  1000a852  PUSH 0x1000d5d4    ; s_user32.dll_1000d5d4
  1000a857  CALL dword ptr [0x1000d0b8]    ; PTR_LoadLibraryA_1000d0b8 KERNEL32.DLL::LoadLibraryA
  1000a85d  MOV EDI,EAX
  1000a85f  CMP EDI,EBX
  1000a861  JZ 0x1000a8ca    ; LAB_1000a8ca
  1000a863  MOV ESI,dword ptr [0x1000d02c]    ; PTR_GetProcAddress_1000d02c
  1000a869  PUSH 0x1000d5c8    ; s_MessageBoxA_1000d5c8
  1000a86e  PUSH EDI
  1000a86f  CALL ESI    ; KERNEL32.DLL::GetProcAddress
  1000a871  TEST EAX,EAX
  1000a873  MOV [0x1000f7f0],EAX    ; DAT_1000f7f0
  1000a878  JZ 0x1000a8ca    ; LAB_1000a8ca
  1000a87a  PUSH 0x1000d5b8    ; s_GetActiveWindow_1000d5b8
  1000a87f  PUSH EDI
  1000a880  CALL ESI    ; KERNEL32.DLL::GetProcAddress
  1000a882  PUSH 0x1000d5a4    ; s_GetLastActivePopup_1000d5a4
  1000a887  PUSH EDI
  1000a888  MOV [0x1000f7f4],EAX    ; DAT_1000f7f4
  1000a88d  CALL ESI    ; KERNEL32.DLL::GetProcAddress
  1000a88f  MOV [0x1000f7f8],EAX    ; DAT_1000f7f8
LAB_1000a894:
  1000a894  MOV EAX,[0x1000f7f4]    ; DAT_1000f7f4
  1000a899  TEST EAX,EAX
  1000a89b  JZ 0x1000a8b3    ; LAB_1000a8b3
  1000a89d  CALL EAX
  1000a89f  MOV EBX,EAX
  1000a8a1  TEST EBX,EBX
  1000a8a3  JZ 0x1000a8b3    ; LAB_1000a8b3
  1000a8a5  MOV EAX,[0x1000f7f8]    ; DAT_1000f7f8
  1000a8aa  TEST EAX,EAX
  1000a8ac  JZ 0x1000a8b3    ; LAB_1000a8b3
  1000a8ae  PUSH EBX
  1000a8af  CALL EAX
  1000a8b1  MOV EBX,EAX
LAB_1000a8b3:
  1000a8b3  PUSH dword ptr [ESP + 0x18]
  1000a8b7  PUSH dword ptr [ESP + 0x18]
  1000a8bb  PUSH dword ptr [ESP + 0x18]
  1000a8bf  PUSH EBX
  1000a8c0  CALL dword ptr [0x1000f7f0]    ; DAT_1000f7f0
LAB_1000a8c6:
  1000a8c6  POP EDI
  1000a8c7  POP ESI
  1000a8c8  POP EBX
  1000a8c9  RET
LAB_1000a8ca:
  1000a8ca  XOR EAX,EAX
  1000a8cc  JMP 0x1000a8c6    ; LAB_1000a8c6

;==== FUNCTION _strncpy @ 1000a8d0 : char * _strncpy(char * _Dest, char * _Source, size_t _Count)
  1000a8d0  MOV ECX,dword ptr [ESP + 0xc]
  1000a8d4  PUSH EDI
  1000a8d5  TEST ECX,ECX
  1000a8d7  JZ 0x1000a953    ; LAB_1000a953
  1000a8d9  PUSH ESI
  1000a8da  PUSH EBX
  1000a8db  MOV EBX,ECX
  1000a8dd  MOV ESI,dword ptr [ESP + 0x14]
  1000a8e1  TEST ESI,0x3
  1000a8e7  MOV EDI,dword ptr [ESP + 0x10]
  1000a8eb  JNZ 0x1000a8f4    ; LAB_1000a8f4
  1000a8ed  SHR ECX,0x2
  1000a8f0  JNZ 0x1000a961    ; LAB_1000a961
  1000a8f2  JMP 0x1000a915    ; LAB_1000a915
LAB_1000a8f4:
  1000a8f4  MOV AL,byte ptr [ESI]
  1000a8f6  INC ESI
  1000a8f7  MOV byte ptr [EDI],AL
  1000a8f9  INC EDI
  1000a8fa  DEC ECX
  1000a8fb  JZ 0x1000a922    ; LAB_1000a922
  1000a8fd  TEST AL,AL
  1000a8ff  JZ 0x1000a92a    ; LAB_1000a92a
  1000a901  TEST ESI,0x3
  1000a907  JNZ 0x1000a8f4    ; LAB_1000a8f4
  1000a909  MOV EBX,ECX
  1000a90b  SHR ECX,0x2
  1000a90e  JNZ 0x1000a961    ; LAB_1000a961
LAB_1000a910:
  1000a910  AND EBX,0x3
  1000a913  JZ 0x1000a922    ; LAB_1000a922
LAB_1000a915:
  1000a915  MOV AL,byte ptr [ESI]
  1000a917  INC ESI
  1000a918  MOV byte ptr [EDI],AL
  1000a91a  INC EDI
  1000a91b  TEST AL,AL
  1000a91d  JZ 0x1000a94e    ; LAB_1000a94e
  1000a91f  DEC EBX
  1000a920  JNZ 0x1000a915    ; LAB_1000a915
LAB_1000a922:
  1000a922  MOV EAX,dword ptr [ESP + 0x10]
  1000a926  POP EBX
  1000a927  POP ESI
  1000a928  POP EDI
  1000a929  RET
LAB_1000a92a:
  1000a92a  TEST EDI,0x3
  1000a930  JZ 0x1000a944    ; LAB_1000a944
LAB_1000a932:
  1000a932  MOV byte ptr [EDI],AL
  1000a934  INC EDI
  1000a935  DEC ECX
  1000a936  JZ 0x1000a9c6    ; LAB_1000a9c6
  1000a93c  TEST EDI,0x3
  1000a942  JNZ 0x1000a932    ; LAB_1000a932
LAB_1000a944:
  1000a944  MOV EBX,ECX
  1000a946  SHR ECX,0x2
  1000a949  JNZ 0x1000a9b7    ; LAB_1000a9b7
LAB_1000a94b:
  1000a94b  MOV byte ptr [EDI],AL
  1000a94d  INC EDI
LAB_1000a94e:
  1000a94e  DEC EBX
  1000a94f  JNZ 0x1000a94b    ; LAB_1000a94b
  1000a951  POP EBX
  1000a952  POP ESI
LAB_1000a953:
  1000a953  MOV EAX,dword ptr [ESP + 0x8]
  1000a957  POP EDI
  1000a958  RET
LAB_1000a959:
  1000a959  MOV dword ptr [EDI],EDX
  1000a95b  ADD EDI,0x4
  1000a95e  DEC ECX
  1000a95f  JZ 0x1000a910    ; LAB_1000a910
LAB_1000a961:
  1000a961  MOV EDX,0x7efefeff
  1000a966  MOV EAX,dword ptr [ESI]
  1000a968  ADD EDX,EAX
  1000a96a  XOR EAX,0xffffffff
  1000a96d  XOR EAX,EDX
  1000a96f  MOV EDX,dword ptr [ESI]
  1000a971  ADD ESI,0x4
  1000a974  TEST EAX,0x81010100
  1000a979  JZ 0x1000a959    ; LAB_1000a959
  1000a97b  TEST DL,DL
  1000a97d  JZ 0x1000a9ab    ; LAB_1000a9ab
  1000a97f  TEST DH,DH
  1000a981  JZ 0x1000a9a1    ; LAB_1000a9a1
  1000a983  TEST EDX,0xff0000
  1000a989  JZ 0x1000a997    ; LAB_1000a997
  1000a98b  TEST EDX,0xff000000
  1000a991  JNZ 0x1000a959    ; LAB_1000a959
  1000a993  MOV dword ptr [EDI],EDX
  1000a995  JMP 0x1000a9af    ; LAB_1000a9af
LAB_1000a997:
  1000a997  AND EDX,0xffff
  1000a99d  MOV dword ptr [EDI],EDX
  1000a99f  JMP 0x1000a9af    ; LAB_1000a9af
LAB_1000a9a1:
  1000a9a1  AND EDX,0xff
  1000a9a7  MOV dword ptr [EDI],EDX
  1000a9a9  JMP 0x1000a9af    ; LAB_1000a9af
LAB_1000a9ab:
  1000a9ab  XOR EDX,EDX
  1000a9ad  MOV dword ptr [EDI],EDX
LAB_1000a9af:
  1000a9af  ADD EDI,0x4
  1000a9b2  XOR EAX,EAX
  1000a9b4  DEC ECX
  1000a9b5  JZ 0x1000a9c1    ; LAB_1000a9c1
LAB_1000a9b7:
  1000a9b7  XOR EAX,EAX
LAB_1000a9b9:
  1000a9b9  MOV dword ptr [EDI],EAX
  1000a9bb  ADD EDI,0x4
  1000a9be  DEC ECX
  1000a9bf  JNZ 0x1000a9b9    ; LAB_1000a9b9
LAB_1000a9c1:
  1000a9c1  AND EBX,0x3
  1000a9c4  JNZ 0x1000a94b    ; LAB_1000a94b
LAB_1000a9c6:
  1000a9c6  MOV EAX,dword ptr [ESP + 0x10]
  1000a9ca  POP EBX
  1000a9cb  POP ESI
  1000a9cc  POP EDI
  1000a9cd  RET

;==== FUNCTION FUN_1000a9ce @ 1000a9ce : LONG FUN_1000a9ce(int param_1, _EXCEPTION_POINTERS * param_2)
  1000a9ce  PUSH EBP
  1000a9cf  MOV EBP,ESP
  1000a9d1  PUSH EBX
  1000a9d2  PUSH dword ptr [EBP + 0x8]
  1000a9d5  CALL 0x1000ab0f    ; FUN_1000ab0f
  1000a9da  TEST EAX,EAX
  1000a9dc  POP ECX
  1000a9dd  JZ 0x1000ab03    ; LAB_1000ab03
  1000a9e3  MOV EBX,dword ptr [EAX + 0x8]
  1000a9e6  TEST EBX,EBX
  1000a9e8  JZ 0x1000ab03    ; LAB_1000ab03
  1000a9ee  CMP EBX,0x5
  1000a9f1  JNZ 0x1000a9ff    ; LAB_1000a9ff
  1000a9f3  AND dword ptr [EAX + 0x8],0x0
  1000a9f7  PUSH 0x1
  1000a9f9  POP EAX
  1000a9fa  JMP 0x1000ab0c    ; LAB_1000ab0c
LAB_1000a9ff:
  1000a9ff  CMP EBX,0x1
  1000aa02  JZ 0x1000aafe    ; LAB_1000aafe
  1000aa08  MOV ECX,dword ptr [0x1000f7fc]    ; DAT_1000f7fc
  1000aa0e  MOV dword ptr [EBP + 0x8],ECX
  1000aa11  MOV ECX,dword ptr [EBP + 0xc]
  1000aa14  MOV dword ptr [0x1000f7fc],ECX    ; DAT_1000f7fc
  1000aa1a  MOV ECX,dword ptr [EAX + 0x4]
  1000aa1d  CMP ECX,0x8
  1000aa20  JNZ 0x1000aaee    ; LAB_1000aaee
  1000aa26  MOV ECX,dword ptr [0x1000f178]    ; DAT_1000f178
  1000aa2c  MOV EDX,dword ptr [0x1000f17c]    ; DAT_1000f17c
  1000aa32  ADD EDX,ECX
  1000aa34  PUSH ESI
  1000aa35  CMP ECX,EDX
  1000aa37  JGE 0x1000aa4e    ; LAB_1000aa4e
  1000aa39  LEA ESI,[ECX + ECX*0x2]
  1000aa3c  SUB EDX,ECX
  1000aa3e  LEA ESI,[ESI*0x4 + 0x1000f108]    ; DAT_1000f12c
LAB_1000aa45:
  1000aa45  AND dword ptr [ESI],0x0    ; DAT_1000f12c DAT_1000f138
  1000aa48  ADD ESI,0xc
  1000aa4b  DEC EDX
  1000aa4c  JNZ 0x1000aa45    ; LAB_1000aa45
LAB_1000aa4e:
  1000aa4e  MOV EAX,dword ptr [EAX]
  1000aa50  MOV ESI,dword ptr [0x1000f184]    ; DAT_1000f184
  1000aa56  CMP EAX,0xc000008e
  1000aa5b  JNZ 0x1000aa69    ; LAB_1000aa69
  1000aa5d  MOV dword ptr [0x1000f184],0x83    ; DAT_1000f184
  1000aa67  JMP 0x1000aad9    ; LAB_1000aad9
LAB_1000aa69:
  1000aa69  CMP EAX,0xc0000090
  1000aa6e  JNZ 0x1000aa7c    ; LAB_1000aa7c
  1000aa70  MOV dword ptr [0x1000f184],0x81    ; DAT_1000f184
  1000aa7a  JMP 0x1000aad9    ; LAB_1000aad9
LAB_1000aa7c:
  1000aa7c  CMP EAX,0xc0000091
  1000aa81  JNZ 0x1000aa8f    ; LAB_1000aa8f
  1000aa83  MOV dword ptr [0x1000f184],0x84    ; DAT_1000f184
  1000aa8d  JMP 0x1000aad9    ; LAB_1000aad9
LAB_1000aa8f:
  1000aa8f  CMP EAX,0xc0000093
  1000aa94  JNZ 0x1000aaa2    ; LAB_1000aaa2
  1000aa96  MOV dword ptr [0x1000f184],0x85    ; DAT_1000f184
  1000aaa0  JMP 0x1000aad9    ; LAB_1000aad9
LAB_1000aaa2:
  1000aaa2  CMP EAX,0xc000008d
  1000aaa7  JNZ 0x1000aab5    ; LAB_1000aab5
  1000aaa9  MOV dword ptr [0x1000f184],0x82    ; DAT_1000f184
  1000aab3  JMP 0x1000aad9    ; LAB_1000aad9
LAB_1000aab5:
  1000aab5  CMP EAX,0xc000008f
  1000aaba  JNZ 0x1000aac8    ; LAB_1000aac8
  1000aabc  MOV dword ptr [0x1000f184],0x86    ; DAT_1000f184
  1000aac6  JMP 0x1000aad9    ; LAB_1000aad9
LAB_1000aac8:
  1000aac8  CMP EAX,0xc0000092
  1000aacd  JNZ 0x1000aad9    ; LAB_1000aad9
  1000aacf  MOV dword ptr [0x1000f184],0x8a    ; DAT_1000f184
LAB_1000aad9:
  1000aad9  PUSH dword ptr [0x1000f184]    ; DAT_1000f184
  1000aadf  PUSH 0x8
  1000aae1  CALL EBX
  1000aae3  POP ECX
  1000aae4  MOV dword ptr [0x1000f184],ESI    ; DAT_1000f184
  1000aaea  POP ECX
  1000aaeb  POP ESI
  1000aaec  JMP 0x1000aaf6    ; LAB_1000aaf6
LAB_1000aaee:
  1000aaee  AND dword ptr [EAX + 0x8],0x0
  1000aaf2  PUSH ECX
  1000aaf3  CALL EBX
  1000aaf5  POP ECX
LAB_1000aaf6:
  1000aaf6  MOV EAX,dword ptr [EBP + 0x8]
  1000aaf9  MOV [0x1000f7fc],EAX    ; DAT_1000f7fc
LAB_1000aafe:
  1000aafe  OR EAX,0xffffffff
  1000ab01  JMP 0x1000ab0c    ; LAB_1000ab0c
LAB_1000ab03:
  1000ab03  PUSH dword ptr [EBP + 0xc]
  1000ab06  CALL dword ptr [0x1000d0bc]    ; PTR_UnhandledExceptionFilter_1000d0bc KERNEL32.DLL::UnhandledExceptionFilter
LAB_1000ab0c:
  1000ab0c  POP EBX
  1000ab0d  POP EBP
  1000ab0e  RET

;==== FUNCTION FUN_1000ab0f @ 1000ab0f : int * FUN_1000ab0f(int param_1)
  1000ab0f  MOV EDX,dword ptr [ESP + 0x4]
  1000ab13  MOV ECX,dword ptr [0x1000f180]    ; DAT_1000f180
  1000ab19  CMP dword ptr [0x1000f100],EDX    ; DAT_1000f100
  1000ab1f  PUSH ESI
  1000ab20  MOV EAX,0x1000f100    ; DAT_1000f100
  1000ab25  JZ 0x1000ab3c    ; LAB_1000ab3c
  1000ab27  LEA ESI,[ECX + ECX*0x2]
  1000ab2a  LEA ESI,[ESI*0x4 + 0x1000f100]    ; DAT_1000f178
LAB_1000ab31:
  1000ab31  ADD EAX,0xc    ; DAT_1000f10c
  1000ab34  CMP EAX,ESI
  1000ab36  JNC 0x1000ab3c    ; LAB_1000ab3c
  1000ab38  CMP dword ptr [EAX],EDX    ; DAT_1000f10c DAT_1000f118
  1000ab3a  JNZ 0x1000ab31    ; LAB_1000ab31
LAB_1000ab3c:
  1000ab3c  LEA ECX,[ECX + ECX*0x2]
  1000ab3f  POP ESI
  1000ab40  LEA ECX,[ECX*0x4 + 0x1000f100]    ; DAT_1000f178
  1000ab47  CMP EAX,ECX
  1000ab49  JNC 0x1000ab4f    ; LAB_1000ab4f
  1000ab4b  CMP dword ptr [EAX],EDX    ; DAT_1000f10c DAT_1000f118 DAT_1000f100
  1000ab4d  JZ 0x1000ab51    ; LAB_1000ab51
LAB_1000ab4f:
  1000ab4f  XOR EAX,EAX
LAB_1000ab51:
  1000ab51  RET

;==== FUNCTION FUN_1000ab52 @ 1000ab52 : int FUN_1000ab52(LCID param_1, uint param_2, char * param_3, int param_4, LPWSTR param_5, int param_6, UINT param_7, int param_8)
  1000ab52  PUSH EBP
  1000ab53  MOV EBP,ESP
  1000ab55  PUSH -0x1
  1000ab57  PUSH 0x1000d5e0    ; DAT_1000d5e0
  1000ab5c  PUSH 0x10009edc    ; LAB_10009edc
  1000ab61  MOV EAX,FS:[0x0]    ; ExceptionList
  1000ab67  PUSH EAX
  1000ab68  MOV dword ptr FS:[0x0],ESP    ; ExceptionList
  1000ab6f  SUB ESP,0x1c
  1000ab72  PUSH EBX
  1000ab73  PUSH ESI
  1000ab74  PUSH EDI
  1000ab75  MOV dword ptr [EBP + -0x18],ESP
  1000ab78  XOR EDI,EDI
  1000ab7a  CMP dword ptr [0x1000f800],EDI    ; DAT_1000f800
  1000ab80  JNZ 0x1000abc8    ; LAB_1000abc8
  1000ab82  PUSH EDI
  1000ab83  PUSH EDI
  1000ab84  PUSH 0x1
  1000ab86  POP EBX
  1000ab87  PUSH EBX
  1000ab88  PUSH 0x1000d594    ; DAT_1000d594
  1000ab8d  MOV ESI,0x100
  1000ab92  PUSH ESI
  1000ab93  PUSH EDI
  1000ab94  CALL dword ptr [0x1000d0c4]    ; PTR_LCMapStringW_1000d0c4 KERNEL32.DLL::LCMapStringW
  1000ab9a  TEST EAX,EAX
  1000ab9c  JZ 0x1000aba6    ; LAB_1000aba6
  1000ab9e  MOV dword ptr [0x1000f800],EBX    ; DAT_1000f800
  1000aba4  JMP 0x1000abc8    ; LAB_1000abc8
LAB_1000aba6:
  1000aba6  PUSH EDI
  1000aba7  PUSH EDI
  1000aba8  PUSH EBX
  1000aba9  PUSH 0x1000d590    ; DAT_1000d590
  1000abae  PUSH ESI
  1000abaf  PUSH EDI
  1000abb0  CALL dword ptr [0x1000d0c0]    ; PTR_LCMapStringA_1000d0c0 KERNEL32.DLL::LCMapStringA
  1000abb6  TEST EAX,EAX
  1000abb8  JZ 0x1000ace0    ; LAB_1000ace0
  1000abbe  MOV dword ptr [0x1000f800],0x2    ; DAT_1000f800
LAB_1000abc8:
  1000abc8  CMP dword ptr [EBP + 0x14],EDI
  1000abcb  JLE 0x1000abdd    ; LAB_1000abdd
  1000abcd  PUSH dword ptr [EBP + 0x14]
  1000abd0  PUSH dword ptr [EBP + 0x10]
  1000abd3  CALL 0x1000ad76    ; FUN_1000ad76
  1000abd8  POP ECX
  1000abd9  POP ECX
  1000abda  MOV dword ptr [EBP + 0x14],EAX
LAB_1000abdd:
  1000abdd  MOV EAX,[0x1000f800]    ; DAT_1000f800
  1000abe2  CMP EAX,0x2
  1000abe5  JNZ 0x1000ac04    ; LAB_1000ac04
  1000abe7  PUSH dword ptr [EBP + 0x1c]
  1000abea  PUSH dword ptr [EBP + 0x18]
  1000abed  PUSH dword ptr [EBP + 0x14]
  1000abf0  PUSH dword ptr [EBP + 0x10]
  1000abf3  PUSH dword ptr [EBP + 0xc]
  1000abf6  PUSH dword ptr [EBP + 0x8]
  1000abf9  CALL dword ptr [0x1000d0c0]    ; PTR_LCMapStringA_1000d0c0 KERNEL32.DLL::LCMapStringA
  1000abff  JMP 0x1000ace2    ; LAB_1000ace2
LAB_1000ac04:
  1000ac04  CMP EAX,0x1
  1000ac07  JNZ 0x1000ace0    ; LAB_1000ace0
  1000ac0d  CMP dword ptr [EBP + 0x20],EDI
  1000ac10  JNZ 0x1000ac1a    ; LAB_1000ac1a
  1000ac12  MOV EAX,[0x1000f81c]    ; DAT_1000f81c
  1000ac17  MOV dword ptr [EBP + 0x20],EAX
LAB_1000ac1a:
  1000ac1a  PUSH EDI
  1000ac1b  PUSH EDI
  1000ac1c  PUSH dword ptr [EBP + 0x14]
  1000ac1f  PUSH dword ptr [EBP + 0x10]
  1000ac22  MOV EAX,dword ptr [EBP + 0x24]
  1000ac25  NEG EAX
  1000ac27  SBB EAX,EAX
  1000ac29  AND EAX,0x8
  1000ac2c  INC EAX
  1000ac2d  PUSH EAX
  1000ac2e  PUSH dword ptr [EBP + 0x20]
  1000ac31  CALL dword ptr [0x1000d0a0]    ; PTR_MultiByteToWideChar_1000d0a0 KERNEL32.DLL::MultiByteToWideChar
  1000ac37  MOV EBX,EAX
  1000ac39  MOV dword ptr [EBP + -0x1c],EBX
  1000ac3c  CMP EBX,EDI
  1000ac3e  JZ 0x1000ace0    ; LAB_1000ace0
  1000ac44  MOV dword ptr [EBP + -0x4],EDI
  1000ac47  LEA EAX,[EBX + EBX*0x1]
  1000ac4a  ADD EAX,0x3
  1000ac4d  AND AL,0xfc
  1000ac4f  CALL 0x10005600    ; FUN_10005600
  1000ac54  MOV dword ptr [EBP + -0x18],ESP
  1000ac57  MOV EAX,ESP
  1000ac59  MOV dword ptr [EBP + -0x24],EAX
  1000ac5c  OR dword ptr [EBP + -0x4],0xffffffff
  1000ac60  JMP 0x1000ac75    ; LAB_1000ac75
LAB_1000ac75:
  1000ac75  CMP dword ptr [EBP + -0x24],EDI
  1000ac78  JZ 0x1000ace0    ; LAB_1000ace0
  1000ac7a  PUSH EBX
  1000ac7b  PUSH dword ptr [EBP + -0x24]
  1000ac7e  PUSH dword ptr [EBP + 0x14]
  1000ac81  PUSH dword ptr [EBP + 0x10]
  1000ac84  PUSH 0x1
  1000ac86  PUSH dword ptr [EBP + 0x20]
  1000ac89  CALL dword ptr [0x1000d0a0]    ; PTR_MultiByteToWideChar_1000d0a0 KERNEL32.DLL::MultiByteToWideChar
  1000ac8f  TEST EAX,EAX
  1000ac91  JZ 0x1000ace0    ; LAB_1000ace0
  1000ac93  PUSH EDI
  1000ac94  PUSH EDI
  1000ac95  PUSH EBX
  1000ac96  PUSH dword ptr [EBP + -0x24]
  1000ac99  PUSH dword ptr [EBP + 0xc]
  1000ac9c  PUSH dword ptr [EBP + 0x8]
  1000ac9f  CALL dword ptr [0x1000d0c4]    ; PTR_LCMapStringW_1000d0c4 KERNEL32.DLL::LCMapStringW
  1000aca5  MOV ESI,EAX
  1000aca7  MOV dword ptr [EBP + -0x28],ESI
  1000acaa  CMP ESI,EDI
  1000acac  JZ 0x1000ace0    ; LAB_1000ace0
  1000acae  TEST byte ptr [EBP + 0xd],0x4
  1000acb2  JZ 0x1000acf4    ; LAB_1000acf4
  1000acb4  CMP dword ptr [EBP + 0x1c],EDI
  1000acb7  JZ 0x1000ad6f    ; LAB_1000ad6f
  1000acbd  CMP ESI,dword ptr [EBP + 0x1c]
  1000acc0  JG 0x1000ace0    ; LAB_1000ace0
  1000acc2  PUSH dword ptr [EBP + 0x1c]
  1000acc5  PUSH dword ptr [EBP + 0x18]
  1000acc8  PUSH EBX
  1000acc9  PUSH dword ptr [EBP + -0x24]
  1000accc  PUSH dword ptr [EBP + 0xc]
  1000accf  PUSH dword ptr [EBP + 0x8]
  1000acd2  CALL dword ptr [0x1000d0c4]    ; PTR_LCMapStringW_1000d0c4 KERNEL32.DLL::LCMapStringW
  1000acd8  TEST EAX,EAX
  1000acda  JNZ 0x1000ad6f    ; LAB_1000ad6f
LAB_1000ace0:
  1000ace0  XOR EAX,EAX
LAB_1000ace2:
  1000ace2  LEA ESP,[EBP + -0x38]
  1000ace5  MOV ECX,dword ptr [EBP + -0x10]
  1000ace8  MOV dword ptr FS:[0x0],ECX    ; ExceptionList
  1000acef  POP EDI
  1000acf0  POP ESI
  1000acf1  POP EBX
  1000acf2  LEAVE
  1000acf3  RET
LAB_1000acf4:
  1000acf4  MOV dword ptr [EBP + -0x4],0x1
  1000acfb  LEA EAX,[ESI + ESI*0x1]
  1000acfe  ADD EAX,0x3
  1000ad01  AND AL,0xfc
  1000ad03  CALL 0x10005600    ; FUN_10005600
  1000ad08  MOV dword ptr [EBP + -0x18],ESP
  1000ad0b  MOV EBX,ESP
  1000ad0d  MOV dword ptr [EBP + -0x20],EBX
  1000ad10  OR dword ptr [EBP + -0x4],0xffffffff
  1000ad14  JMP 0x1000ad28    ; LAB_1000ad28
LAB_1000ad28:
  1000ad28  CMP EBX,EDI
  1000ad2a  JZ 0x1000ace0    ; LAB_1000ace0
  1000ad2c  PUSH ESI
  1000ad2d  PUSH EBX
  1000ad2e  PUSH dword ptr [EBP + -0x1c]
  1000ad31  PUSH dword ptr [EBP + -0x24]
  1000ad34  PUSH dword ptr [EBP + 0xc]
  1000ad37  PUSH dword ptr [EBP + 0x8]
  1000ad3a  CALL dword ptr [0x1000d0c4]    ; PTR_LCMapStringW_1000d0c4 KERNEL32.DLL::LCMapStringW
  1000ad40  TEST EAX,EAX
  1000ad42  JZ 0x1000ace0    ; LAB_1000ace0
  1000ad44  CMP dword ptr [EBP + 0x1c],EDI
  1000ad47  PUSH EDI
  1000ad48  PUSH EDI
  1000ad49  JNZ 0x1000ad4f    ; LAB_1000ad4f
  1000ad4b  PUSH EDI
  1000ad4c  PUSH EDI
  1000ad4d  JMP 0x1000ad55    ; LAB_1000ad55
LAB_1000ad4f:
  1000ad4f  PUSH dword ptr [EBP + 0x1c]
  1000ad52  PUSH dword ptr [EBP + 0x18]
LAB_1000ad55:
  1000ad55  PUSH ESI
  1000ad56  PUSH EBX
  1000ad57  PUSH 0x220
  1000ad5c  PUSH dword ptr [EBP + 0x20]
  1000ad5f  CALL dword ptr [0x1000d070]    ; PTR_WideCharToMultiByte_1000d070 KERNEL32.DLL::WideCharToMultiByte
  1000ad65  MOV ESI,EAX
  1000ad67  CMP ESI,EDI
  1000ad69  JZ 0x1000ace0    ; LAB_1000ace0
LAB_1000ad6f:
  1000ad6f  MOV EAX,ESI
  1000ad71  JMP 0x1000ace2    ; LAB_1000ace2

;==== FUNCTION FUN_1000ad76 @ 1000ad76 : int FUN_1000ad76(char * param_1, int param_2)
  1000ad76  MOV EDX,dword ptr [ESP + 0x8]
  1000ad7a  MOV EAX,dword ptr [ESP + 0x4]
  1000ad7e  TEST EDX,EDX
  1000ad80  PUSH ESI
  1000ad81  LEA ECX,[EDX + -0x1]
  1000ad84  JZ 0x1000ad93    ; LAB_1000ad93
LAB_1000ad86:
  1000ad86  CMP byte ptr [EAX],0x0
  1000ad89  JZ 0x1000ad93    ; LAB_1000ad93
  1000ad8b  INC EAX
  1000ad8c  MOV ESI,ECX
  1000ad8e  DEC ECX
  1000ad8f  TEST ESI,ESI
  1000ad91  JNZ 0x1000ad86    ; LAB_1000ad86
LAB_1000ad93:
  1000ad93  CMP byte ptr [EAX],0x0
  1000ad96  POP ESI
  1000ad97  JNZ 0x1000ad9e    ; LAB_1000ad9e
  1000ad99  SUB EAX,dword ptr [ESP + 0x4]
  1000ad9d  RET
LAB_1000ad9e:
  1000ad9e  MOV EAX,EDX
  1000ada0  RET

;==== FUNCTION FUN_1000ada1 @ 1000ada1 : undefined4 FUN_1000ada1(uint param_1, uint param_2, uint * param_3)
  1000ada1  MOV EDX,dword ptr [ESP + 0x4]
  1000ada5  PUSH ESI
  1000ada6  MOV ESI,dword ptr [ESP + 0xc]
  1000adaa  XOR EAX,EAX
  1000adac  LEA ECX,[EDX + ESI*0x1]
  1000adaf  CMP ECX,EDX
  1000adb1  JC 0x1000adb7    ; LAB_1000adb7
  1000adb3  CMP ECX,ESI
  1000adb5  JNC 0x1000adba    ; LAB_1000adba
LAB_1000adb7:
  1000adb7  PUSH 0x1
  1000adb9  POP EAX
LAB_1000adba:
  1000adba  MOV EDX,dword ptr [ESP + 0x10]
  1000adbe  POP ESI
  1000adbf  MOV dword ptr [EDX],ECX
  1000adc1  RET

;==== FUNCTION ___add_12 @ 1000adc2 : undefined ___add_12(uint * param_1, uint * param_2)
  1000adc2  PUSH ESI
  1000adc3  MOV ESI,dword ptr [ESP + 0x8]
  1000adc7  PUSH EDI
  1000adc8  MOV EDI,dword ptr [ESP + 0x10]
  1000adcc  PUSH ESI
  1000adcd  PUSH dword ptr [EDI]
  1000adcf  PUSH dword ptr [ESI]
  1000add1  CALL 0x1000ada1    ; FUN_1000ada1
  1000add6  ADD ESP,0xc
  1000add9  TEST EAX,EAX
  1000addb  JZ 0x1000adf4    ; LAB_1000adf4
  1000addd  LEA EAX,[ESI + 0x4]
  1000ade0  PUSH EAX
  1000ade1  PUSH 0x1
  1000ade3  PUSH dword ptr [EAX]
  1000ade5  CALL 0x1000ada1    ; FUN_1000ada1
  1000adea  ADD ESP,0xc
  1000aded  TEST EAX,EAX
  1000adef  JZ 0x1000adf4    ; LAB_1000adf4
  1000adf1  INC dword ptr [ESI + 0x8]
LAB_1000adf4:
  1000adf4  LEA EAX,[ESI + 0x4]
  1000adf7  PUSH EAX
  1000adf8  PUSH dword ptr [EDI + 0x4]
  1000adfb  PUSH dword ptr [EAX]
  1000adfd  CALL 0x1000ada1    ; FUN_1000ada1
  1000ae02  ADD ESP,0xc
  1000ae05  TEST EAX,EAX
  1000ae07  JZ 0x1000ae0c    ; LAB_1000ae0c
  1000ae09  INC dword ptr [ESI + 0x8]
LAB_1000ae0c:
  1000ae0c  LEA EAX,[ESI + 0x8]
  1000ae0f  PUSH EAX
  1000ae10  PUSH dword ptr [EDI + 0x8]
  1000ae13  PUSH dword ptr [EAX]
  1000ae15  CALL 0x1000ada1    ; FUN_1000ada1
  1000ae1a  ADD ESP,0xc
  1000ae1d  POP EDI
  1000ae1e  POP ESI
  1000ae1f  RET

;==== FUNCTION FUN_1000ae20 @ 1000ae20 : undefined FUN_1000ae20(uint * param_1)
  1000ae20  MOV EAX,dword ptr [ESP + 0x4]
  1000ae24  PUSH ESI
  1000ae25  PUSH EDI
  1000ae26  MOV ESI,dword ptr [EAX]
  1000ae28  MOV EDI,dword ptr [EAX + 0x4]
  1000ae2b  MOV ECX,ESI
  1000ae2d  ADD ESI,ESI
  1000ae2f  MOV dword ptr [EAX],ESI
  1000ae31  LEA ESI,[EDI + EDI*0x1]
  1000ae34  SHR ECX,0x1f
  1000ae37  OR ESI,ECX
  1000ae39  MOV ECX,dword ptr [EAX + 0x8]
  1000ae3c  MOV EDX,EDI
  1000ae3e  MOV dword ptr [EAX + 0x4],ESI
  1000ae41  SHR EDX,0x1f
  1000ae44  SHL ECX,0x1
  1000ae46  OR ECX,EDX
  1000ae48  POP EDI
  1000ae49  MOV dword ptr [EAX + 0x8],ECX
  1000ae4c  POP ESI
  1000ae4d  RET

;==== FUNCTION FUN_1000ae4e @ 1000ae4e : undefined FUN_1000ae4e(uint * param_1)
  1000ae4e  MOV EAX,dword ptr [ESP + 0x4]
  1000ae52  PUSH ESI
  1000ae53  PUSH EDI
  1000ae54  MOV EDX,dword ptr [EAX + 0x8]
  1000ae57  MOV ECX,dword ptr [EAX + 0x4]
  1000ae5a  MOV ESI,EDX
  1000ae5c  MOV EDI,ECX
  1000ae5e  SHL ESI,0x1f
  1000ae61  SHR ECX,0x1
  1000ae63  OR ECX,ESI
  1000ae65  MOV dword ptr [EAX + 0x4],ECX
  1000ae68  MOV ECX,dword ptr [EAX]
  1000ae6a  SHL EDI,0x1f
  1000ae6d  SHR ECX,0x1
  1000ae6f  SHR EDX,0x1
  1000ae71  OR ECX,EDI
  1000ae73  POP EDI
  1000ae74  MOV dword ptr [EAX + 0x8],EDX
  1000ae77  MOV dword ptr [EAX],ECX
  1000ae79  POP ESI
  1000ae7a  RET

;==== FUNCTION FUN_1000ae7b @ 1000ae7b : undefined FUN_1000ae7b(char * param_1, int param_2, uint * param_3)
  1000ae7b  PUSH EBP
  1000ae7c  MOV EBP,ESP
  1000ae7e  SUB ESP,0x10
  1000ae81  MOV EAX,dword ptr [EBP + 0xc]
  1000ae84  PUSH EBX
  1000ae85  MOV EBX,dword ptr [EBP + 0x10]
  1000ae88  XOR EDX,EDX
  1000ae8a  CMP EAX,EDX
  1000ae8c  PUSH ESI
  1000ae8d  MOV dword ptr [EBP + -0x4],0x404e
  1000ae94  MOV dword ptr [EBX],EDX
  1000ae96  MOV dword ptr [EBX + 0x4],EDX
  1000ae99  MOV dword ptr [EBX + 0x8],EDX
  1000ae9c  JBE 0x1000aeef    ; LAB_1000aeef
  1000ae9e  PUSH EDI
  1000ae9f  MOV dword ptr [EBP + 0x10],EAX
LAB_1000aea2:
  1000aea2  MOV ESI,EBX
  1000aea4  LEA EDI,[EBP + -0x10]
  1000aea7  MOVSD ES:EDI,ESI
  1000aea8  MOVSD ES:EDI,ESI
  1000aea9  PUSH EBX
  1000aeaa  MOVSD ES:EDI,ESI
  1000aeab  CALL 0x1000ae20    ; FUN_1000ae20
  1000aeb0  PUSH EBX
  1000aeb1  CALL 0x1000ae20    ; FUN_1000ae20
  1000aeb6  LEA EAX,[EBP + -0x10]
  1000aeb9  PUSH EAX
  1000aeba  PUSH EBX
  1000aebb  CALL 0x1000adc2    ; ___add_12
  1000aec0  PUSH EBX
  1000aec1  CALL 0x1000ae20    ; FUN_1000ae20
  1000aec6  MOV EAX,dword ptr [EBP + 0x8]
  1000aec9  AND dword ptr [EBP + -0xc],0x0
  1000aecd  AND dword ptr [EBP + -0x8],0x0
  1000aed1  MOVSX EAX,byte ptr [EAX]
  1000aed4  MOV dword ptr [EBP + -0x10],EAX
  1000aed7  LEA EAX,[EBP + -0x10]
  1000aeda  PUSH EAX
  1000aedb  PUSH EBX
  1000aedc  CALL 0x1000adc2    ; ___add_12
  1000aee1  ADD ESP,0x1c
  1000aee4  INC dword ptr [EBP + 0x8]
  1000aee7  DEC dword ptr [EBP + 0x10]
  1000aeea  JNZ 0x1000aea2    ; LAB_1000aea2
  1000aeec  XOR EDX,EDX
  1000aeee  POP EDI
LAB_1000aeef:
  1000aeef  CMP dword ptr [EBX + 0x8],EDX
  1000aef2  JNZ 0x1000af1c    ; LAB_1000af1c
  1000aef4  MOV ECX,dword ptr [EBX + 0x4]
  1000aef7  MOV EAX,ECX
  1000aef9  SHR EAX,0x10
  1000aefc  MOV dword ptr [EBX + 0x8],EAX
  1000aeff  MOV EAX,dword ptr [EBX]
  1000af01  MOV ESI,EAX
  1000af03  SHR ESI,0x10
  1000af06  SHL ECX,0x10
  1000af09  OR ESI,ECX
  1000af0b  SHL EAX,0x10
  1000af0e  ADD dword ptr [EBP + -0x4],0xfff0
  1000af15  MOV dword ptr [EBX + 0x4],ESI
  1000af18  MOV dword ptr [EBX],EAX
  1000af1a  JMP 0x1000aeef    ; LAB_1000aeef
LAB_1000af1c:
  1000af1c  MOV ESI,0x8000
LAB_1000af21:
  1000af21  TEST dword ptr [EBX + 0x8],ESI
  1000af24  JNZ 0x1000af36    ; LAB_1000af36
  1000af26  PUSH EBX
  1000af27  CALL 0x1000ae20    ; FUN_1000ae20
  1000af2c  ADD dword ptr [EBP + -0x4],0xffff
  1000af33  POP ECX
  1000af34  JMP 0x1000af21    ; LAB_1000af21
LAB_1000af36:
  1000af36  MOV AX,word ptr [EBP + -0x4]
  1000af3a  POP ESI
  1000af3b  MOV word ptr [EBX + 0xa],AX
  1000af3f  POP EBX
  1000af40  LEAVE
  1000af41  RET

;==== FUNCTION FUN_1000af42 @ 1000af42 : undefined4 FUN_1000af42(void * this, ushort * param_1, int * param_2, byte * param_3, int param_4, int param_5, int param_6, int param_7)
  1000af42  PUSH EBP
  1000af43  MOV EBP,ESP
  1000af45  SUB ESP,0x5c
  1000af48  PUSH EBX
  1000af49  PUSH ESI
  1000af4a  PUSH EDI
  1000af4b  MOV EDI,dword ptr [EBP + 0x10]
  1000af4e  LEA EAX,[EBP + -0x5c]
  1000af51  PUSH 0x1
  1000af53  MOV dword ptr [EBP + -0xc],EAX
  1000af56  XOR EAX,EAX
  1000af58  POP EDX
  1000af59  MOV dword ptr [EBP + -0x28],EAX
  1000af5c  MOV dword ptr [EBP + -0x18],EDX
  1000af5f  MOV dword ptr [EBP + -0x4],EAX
  1000af62  MOV dword ptr [EBP + -0x10],EAX
  1000af65  MOV dword ptr [EBP + -0x24],EAX
  1000af68  MOV dword ptr [EBP + -0x20],EAX
  1000af6b  MOV dword ptr [EBP + -0x2c],EAX
  1000af6e  MOV dword ptr [EBP + -0x30],EAX
  1000af71  MOV dword ptr [EBP + -0x1c],EAX
  1000af74  MOV dword ptr [EBP + -0x8],EAX
  1000af77  MOV dword ptr [EBP + -0x14],EAX
  1000af7a  MOV dword ptr [EBP + 0x10],EDI
LAB_1000af7d:
  1000af7d  MOV CL,byte ptr [EDI]
  1000af7f  CMP CL,0x20
  1000af82  JZ 0x1000af93    ; LAB_1000af93
  1000af84  CMP CL,0x9
  1000af87  JZ 0x1000af93    ; LAB_1000af93
  1000af89  CMP CL,0xa
  1000af8c  JZ 0x1000af93    ; LAB_1000af93
  1000af8e  CMP CL,0xd
  1000af91  JNZ 0x1000af96    ; LAB_1000af96
LAB_1000af93:
  1000af93  INC EDI
  1000af94  JMP 0x1000af7d    ; LAB_1000af7d
LAB_1000af96:
  1000af96  PUSH 0x4
  1000af98  POP ESI
LAB_1000af99:
  1000af99  MOV BL,byte ptr [EDI]
  1000af9b  INC EDI
  1000af9c  CMP EAX,0xb
  1000af9f  JA 0x1000b21c    ; switchD_1000afa5::caseD_a
switchD:
  1000afa5  JMP dword ptr [EAX*0x4 + 0x1000b3e3]    ; switchD_1000afa5::caseD_0 switchD_1000afa5::caseD_1 switchD_1000afa5::caseD_2 switchD_1000afa5::caseD_3 switchD_1000afa5::caseD_4 switchD_1000afa5::caseD_5 switchD_1000afa5::caseD_6 switchD_1000afa5::caseD_7 switchD_1000afa5::caseD_8 switchD_1000afa5::caseD_9 switchD_1000afa5::caseD_a switchD_1000afa5::caseD_b switchD_1000afa5::switchdataD_1000b3e3 PTR_caseD_7_1000b3ff PTR_caseD_9_1000b407 PTR_caseD_8_1000b403 PTR_caseD_4_1000b3f3 PTR_caseD_1_1000b3e7 PTR_caseD_2_1000b3eb
caseD_0:
  1000afac  CMP BL,0x31
  1000afaf  JL 0x1000afbd    ; LAB_1000afbd
  1000afb1  CMP BL,0x39
  1000afb4  JG 0x1000afbd    ; LAB_1000afbd
LAB_1000afb6:
  1000afb6  PUSH 0x3
  1000afb8  JMP 0x1000b1da    ; LAB_1000b1da
LAB_1000afbd:
  1000afbd  CMP BL,byte ptr [0x1000ec98]    ; DAT_1000ec98
  1000afc3  JNZ 0x1000afcc    ; LAB_1000afcc
LAB_1000afc5:
  1000afc5  PUSH 0x5
  1000afc7  JMP 0x1000b212    ; LAB_1000b212
LAB_1000afcc:
  1000afcc  MOVSX EAX,BL
  1000afcf  SUB EAX,0x2b
  1000afd2  JZ 0x1000aff2    ; LAB_1000aff2
  1000afd4  DEC EAX
  1000afd5  DEC EAX
  1000afd6  JZ 0x1000afe6    ; LAB_1000afe6
  1000afd8  SUB EAX,0x3
  1000afdb  JNZ 0x1000b2b5    ; LAB_1000b2b5
  1000afe1  JMP 0x1000b075    ; LAB_1000b075
LAB_1000afe6:
  1000afe6  PUSH 0x2
  1000afe8  MOV dword ptr [EBP + -0x28],0x8000
  1000afef  POP EAX
  1000aff0  JMP 0x1000af99    ; LAB_1000af99
LAB_1000aff2:
  1000aff2  AND dword ptr [EBP + -0x28],0x0
  1000aff6  PUSH 0x2
  1000aff8  POP EAX
  1000aff9  JMP 0x1000af99    ; LAB_1000af99
caseD_1:
  1000affb  CMP BL,0x31
  1000affe  MOV dword ptr [EBP + -0x10],EDX
  1000b001  JL 0x1000b008    ; LAB_1000b008
  1000b003  CMP BL,0x39
  1000b006  JLE 0x1000afb6    ; LAB_1000afb6
LAB_1000b008:
  1000b008  CMP BL,byte ptr [0x1000ec98]    ; DAT_1000ec98
  1000b00e  JZ 0x1000b0d0    ; LAB_1000b0d0
  1000b014  CMP BL,0x2b
  1000b017  JZ 0x1000b04a    ; LAB_1000b04a
  1000b019  CMP BL,0x2d
  1000b01c  JZ 0x1000b04a    ; LAB_1000b04a
  1000b01e  CMP BL,0x30
  1000b021  JZ 0x1000b075    ; LAB_1000b075
LAB_1000b023:
  1000b023  CMP BL,0x43
  1000b026  JLE 0x1000b2b5    ; LAB_1000b2b5
  1000b02c  CMP BL,0x45
  1000b02f  JLE 0x1000b043    ; LAB_1000b043
  1000b031  CMP BL,0x63
  1000b034  JLE 0x1000b2b5    ; LAB_1000b2b5
  1000b03a  CMP BL,0x65
  1000b03d  JG 0x1000b2b5    ; LAB_1000b2b5
LAB_1000b043:
  1000b043  PUSH 0x6
  1000b045  JMP 0x1000b212    ; LAB_1000b212
LAB_1000b04a:
  1000b04a  DEC EDI
  1000b04b  PUSH 0xb
  1000b04d  JMP 0x1000b212    ; LAB_1000b212
caseD_2:
  1000b052  CMP BL,0x31
  1000b055  JL 0x1000b060    ; LAB_1000b060
  1000b057  CMP BL,0x39
  1000b05a  JLE 0x1000afb6    ; LAB_1000afb6
LAB_1000b060:
  1000b060  CMP BL,byte ptr [0x1000ec98]    ; DAT_1000ec98
  1000b066  JZ 0x1000afc5    ; LAB_1000afc5
  1000b06c  CMP BL,0x30
  1000b06f  JNZ 0x1000b22a    ; LAB_1000b22a
LAB_1000b075:
  1000b075  MOV EAX,EDX
  1000b077  JMP 0x1000af99    ; LAB_1000af99
caseD_3:
  1000b07c  MOV dword ptr [EBP + -0x10],EDX
LAB_1000b07f:
  1000b07f  CMP dword ptr [0x1000ec94],EDX    ; DAT_1000ec94
  1000b085  JLE 0x1000b098    ; LAB_1000b098
  1000b087  MOVZX EAX,BL
  1000b08a  PUSH ESI
  1000b08b  PUSH EAX
  1000b08c  CALL 0x100070f8    ; FUN_100070f8
  1000b091  POP ECX
  1000b092  POP ECX
  1000b093  PUSH 0x1
  1000b095  POP EDX
  1000b096  JMP 0x1000b0a6    ; LAB_1000b0a6
LAB_1000b098:
  1000b098  MOV ECX,dword ptr [0x1000ea88]    ; PTR_DAT_1000ea88
  1000b09e  MOVZX EAX,BL
  1000b0a1  MOV AL,byte ptr [ECX + EAX*0x2]    ; DAT_1000ea92
  1000b0a4  AND EAX,ESI
LAB_1000b0a6:
  1000b0a6  TEST EAX,EAX
  1000b0a8  JZ 0x1000b0c8    ; LAB_1000b0c8
  1000b0aa  CMP dword ptr [EBP + -0x4],0x19
  1000b0ae  JNC 0x1000b0c0    ; LAB_1000b0c0
  1000b0b0  MOV EAX,dword ptr [EBP + -0xc]
  1000b0b3  INC dword ptr [EBP + -0x4]
  1000b0b6  SUB BL,0x30
  1000b0b9  INC dword ptr [EBP + -0xc]
  1000b0bc  MOV byte ptr [EAX],BL
  1000b0be  JMP 0x1000b0c3    ; LAB_1000b0c3
LAB_1000b0c0:
  1000b0c0  INC dword ptr [EBP + -0x8]
LAB_1000b0c3:
  1000b0c3  MOV BL,byte ptr [EDI]
  1000b0c5  INC EDI
  1000b0c6  JMP 0x1000b07f    ; LAB_1000b07f
LAB_1000b0c8:
  1000b0c8  CMP BL,byte ptr [0x1000ec98]    ; DAT_1000ec98
  1000b0ce  JNZ 0x1000b137    ; LAB_1000b137
LAB_1000b0d0:
  1000b0d0  MOV EAX,ESI
  1000b0d2  JMP 0x1000af99    ; LAB_1000af99
caseD_4:
  1000b0d7  CMP dword ptr [EBP + -0x4],0x0
  1000b0db  MOV dword ptr [EBP + -0x10],EDX
  1000b0de  MOV dword ptr [EBP + -0x24],EDX
  1000b0e1  JNZ 0x1000b0f0    ; LAB_1000b0f0
LAB_1000b0e3:
  1000b0e3  CMP BL,0x30
  1000b0e6  JNZ 0x1000b0f0    ; LAB_1000b0f0
  1000b0e8  DEC dword ptr [EBP + -0x8]
  1000b0eb  MOV BL,byte ptr [EDI]
  1000b0ed  INC EDI
  1000b0ee  JMP 0x1000b0e3    ; LAB_1000b0e3
LAB_1000b0f0:
  1000b0f0  CMP dword ptr [0x1000ec94],EDX    ; DAT_1000ec94
  1000b0f6  JLE 0x1000b109    ; LAB_1000b109
  1000b0f8  MOVZX EAX,BL
  1000b0fb  PUSH ESI
  1000b0fc  PUSH EAX
  1000b0fd  CALL 0x100070f8    ; FUN_100070f8
  1000b102  POP ECX
  1000b103  POP ECX
  1000b104  PUSH 0x1
  1000b106  POP EDX
  1000b107  JMP 0x1000b117    ; LAB_1000b117
LAB_1000b109:
  1000b109  MOV ECX,dword ptr [0x1000ea88]    ; PTR_DAT_1000ea88
  1000b10f  MOVZX EAX,BL
  1000b112  MOV AL,byte ptr [ECX + EAX*0x2]    ; DAT_1000ea92
  1000b115  AND EAX,ESI
LAB_1000b117:
  1000b117  TEST EAX,EAX
  1000b119  JZ 0x1000b137    ; LAB_1000b137
  1000b11b  CMP dword ptr [EBP + -0x4],0x19
  1000b11f  JNC 0x1000b132    ; LAB_1000b132
  1000b121  MOV EAX,dword ptr [EBP + -0xc]
  1000b124  INC dword ptr [EBP + -0x4]
  1000b127  SUB BL,0x30
  1000b12a  INC dword ptr [EBP + -0xc]
  1000b12d  DEC dword ptr [EBP + -0x8]
  1000b130  MOV byte ptr [EAX],BL
LAB_1000b132:
  1000b132  MOV BL,byte ptr [EDI]
  1000b134  INC EDI
  1000b135  JMP 0x1000b0f0    ; LAB_1000b0f0
LAB_1000b137:
  1000b137  CMP BL,0x2b
  1000b13a  JZ 0x1000b04a    ; LAB_1000b04a
  1000b140  CMP BL,0x2d
  1000b143  JZ 0x1000b04a    ; LAB_1000b04a
  1000b149  JMP 0x1000b023    ; LAB_1000b023
caseD_5:
  1000b14e  CMP dword ptr [0x1000ec94],EDX    ; DAT_1000ec94
  1000b154  MOV dword ptr [EBP + -0x24],EDX
  1000b157  JLE 0x1000b16a    ; LAB_1000b16a
  1000b159  MOVZX EAX,BL
  1000b15c  PUSH ESI
  1000b15d  PUSH EAX
  1000b15e  CALL 0x100070f8    ; FUN_100070f8
  1000b163  POP ECX
  1000b164  POP ECX
  1000b165  PUSH 0x1
  1000b167  POP EDX
  1000b168  JMP 0x1000b178    ; LAB_1000b178
LAB_1000b16a:
  1000b16a  MOV ECX,dword ptr [0x1000ea88]    ; PTR_DAT_1000ea88
  1000b170  MOVZX EAX,BL
  1000b173  MOV AL,byte ptr [ECX + EAX*0x2]    ; DAT_1000ea92
  1000b176  AND EAX,ESI
LAB_1000b178:
  1000b178  TEST EAX,EAX
  1000b17a  JZ 0x1000b22a    ; LAB_1000b22a
  1000b180  MOV EAX,ESI
  1000b182  JMP 0x1000b1db    ; LAB_1000b1db
caseD_6:
  1000b184  LEA ECX,[EDI + -0x2]
  1000b187  CMP BL,0x31
  1000b18a  MOV dword ptr [EBP + 0x10],ECX
  1000b18d  JL 0x1000b194    ; LAB_1000b194
  1000b18f  CMP BL,0x39
  1000b192  JLE 0x1000b1d8    ; LAB_1000b1d8
LAB_1000b194:
  1000b194  MOVSX EAX,BL
  1000b197  SUB EAX,0x2b
  1000b19a  JZ 0x1000b210    ; LAB_1000b210
  1000b19c  DEC EAX
  1000b19d  DEC EAX
  1000b19e  JZ 0x1000b204    ; LAB_1000b204
  1000b1a0  SUB EAX,0x3
  1000b1a3  JNZ 0x1000b2b8    ; LAB_1000b2b8
LAB_1000b1a9:
  1000b1a9  PUSH 0x8
  1000b1ab  JMP 0x1000b212    ; LAB_1000b212
caseD_8:
  1000b1ad  MOV dword ptr [EBP + -0x20],EDX
LAB_1000b1b0:
  1000b1b0  CMP BL,0x30
  1000b1b3  JNZ 0x1000b1ba    ; LAB_1000b1ba
  1000b1b5  MOV BL,byte ptr [EDI]
  1000b1b7  INC EDI
  1000b1b8  JMP 0x1000b1b0    ; LAB_1000b1b0
LAB_1000b1ba:
  1000b1ba  CMP BL,0x31
  1000b1bd  JL 0x1000b2b5    ; LAB_1000b2b5
  1000b1c3  CMP BL,0x39
  1000b1c6  JG 0x1000b2b5    ; LAB_1000b2b5
  1000b1cc  JMP 0x1000b1d8    ; LAB_1000b1d8
caseD_7:
  1000b1ce  CMP BL,0x31
  1000b1d1  JL 0x1000b1e1    ; LAB_1000b1e1
  1000b1d3  CMP BL,0x39
  1000b1d6  JG 0x1000b1e1    ; LAB_1000b1e1
LAB_1000b1d8:
  1000b1d8  PUSH 0x9
LAB_1000b1da:
  1000b1da  POP EAX
LAB_1000b1db:
  1000b1db  DEC EDI
  1000b1dc  JMP 0x1000af99    ; LAB_1000af99
LAB_1000b1e1:
  1000b1e1  CMP BL,0x30
  1000b1e4  JNZ 0x1000b22a    ; LAB_1000b22a
  1000b1e6  JMP 0x1000b1a9    ; LAB_1000b1a9
caseD_b:
  1000b1e8  CMP dword ptr [EBP + 0x20],0x0
  1000b1ec  JZ 0x1000b218    ; LAB_1000b218
  1000b1ee  MOVSX EAX,BL
  1000b1f1  LEA ECX,[EDI + -0x1]
  1000b1f4  SUB EAX,0x2b
  1000b1f7  MOV dword ptr [EBP + 0x10],ECX
  1000b1fa  JZ 0x1000b210    ; LAB_1000b210
  1000b1fc  DEC EAX
  1000b1fd  DEC EAX
  1000b1fe  JNZ 0x1000b2b8    ; LAB_1000b2b8
LAB_1000b204:
  1000b204  OR dword ptr [EBP + -0x18],0xffffffff
  1000b208  PUSH 0x7
  1000b20a  POP EAX
  1000b20b  JMP 0x1000af99    ; LAB_1000af99
LAB_1000b210:
  1000b210  PUSH 0x7
LAB_1000b212:
  1000b212  POP EAX
  1000b213  JMP 0x1000af99    ; LAB_1000af99
LAB_1000b218:
  1000b218  PUSH 0xa
  1000b21a  DEC EDI
  1000b21b  POP EAX
caseD_a:
  1000b21c  CMP EAX,0xa
  1000b21f  JZ 0x1000b2ba    ; LAB_1000b2ba
  1000b225  JMP 0x1000af99    ; LAB_1000af99
LAB_1000b22a:
  1000b22a  MOV EDI,dword ptr [EBP + 0x10]
  1000b22d  JMP 0x1000b2ba    ; LAB_1000b2ba
caseD_9:
  1000b232  MOV dword ptr [EBP + -0x20],0x1
  1000b239  XOR ESI,ESI
LAB_1000b23b:
  1000b23b  CMP dword ptr [0x1000ec94],0x1    ; DAT_1000ec94
  1000b242  JLE 0x1000b253    ; LAB_1000b253
  1000b244  MOVZX EAX,BL
  1000b247  PUSH 0x4
  1000b249  PUSH EAX
  1000b24a  CALL 0x100070f8    ; FUN_100070f8
  1000b24f  POP ECX
  1000b250  POP ECX
  1000b251  JMP 0x1000b262    ; LAB_1000b262
LAB_1000b253:
  1000b253  MOV ECX,dword ptr [0x1000ea88]    ; PTR_DAT_1000ea88
  1000b259  MOVZX EAX,BL
  1000b25c  MOV AL,byte ptr [ECX + EAX*0x2]    ; DAT_1000ea92
  1000b25f  AND EAX,0x4
LAB_1000b262:
  1000b262  TEST EAX,EAX
  1000b264  JZ 0x1000b282    ; LAB_1000b282
  1000b266  MOVSX ECX,BL
  1000b269  LEA EAX,[ESI + ESI*0x4]
  1000b26c  LEA ESI,[ECX + EAX*0x2 + -0x30]
  1000b270  CMP ESI,0x1450
  1000b276  JG 0x1000b27d    ; LAB_1000b27d
  1000b278  MOV BL,byte ptr [EDI]
  1000b27a  INC EDI
  1000b27b  JMP 0x1000b23b    ; LAB_1000b23b
LAB_1000b27d:
  1000b27d  MOV ESI,0x1451
LAB_1000b282:
  1000b282  MOV dword ptr [EBP + -0x1c],ESI
LAB_1000b285:
  1000b285  CMP dword ptr [0x1000ec94],0x1    ; DAT_1000ec94
  1000b28c  JLE 0x1000b29d    ; LAB_1000b29d
  1000b28e  MOVZX EAX,BL
  1000b291  PUSH 0x4
  1000b293  PUSH EAX
  1000b294  CALL 0x100070f8    ; FUN_100070f8
  1000b299  POP ECX
  1000b29a  POP ECX
  1000b29b  JMP 0x1000b2ac    ; LAB_1000b2ac
LAB_1000b29d:
  1000b29d  MOV ECX,dword ptr [0x1000ea88]    ; PTR_DAT_1000ea88
  1000b2a3  MOVZX EAX,BL
  1000b2a6  MOV AL,byte ptr [ECX + EAX*0x2]    ; DAT_1000ea92
  1000b2a9  AND EAX,0x4
LAB_1000b2ac:
  1000b2ac  TEST EAX,EAX
  1000b2ae  JZ 0x1000b2b5    ; LAB_1000b2b5
  1000b2b0  MOV BL,byte ptr [EDI]
  1000b2b2  INC EDI
  1000b2b3  JMP 0x1000b285    ; LAB_1000b285
LAB_1000b2b5:
  1000b2b5  DEC EDI
  1000b2b6  JMP 0x1000b2ba    ; LAB_1000b2ba
LAB_1000b2b8:
  1000b2b8  MOV EDI,ECX
LAB_1000b2ba:
  1000b2ba  MOV EAX,dword ptr [EBP + 0xc]
  1000b2bd  CMP dword ptr [EBP + -0x10],0x0
  1000b2c1  MOV dword ptr [EAX],EDI
  1000b2c3  JZ 0x1000b3a2    ; LAB_1000b3a2
  1000b2c9  PUSH 0x18
  1000b2cb  POP EAX
  1000b2cc  CMP dword ptr [EBP + -0x4],EAX
  1000b2cf  JBE 0x1000b2e6    ; LAB_1000b2e6
  1000b2d1  CMP byte ptr [EBP + -0x45],0x5
  1000b2d5  JL 0x1000b2da    ; LAB_1000b2da
  1000b2d7  INC byte ptr [EBP + -0x45]
LAB_1000b2da:
  1000b2da  MOV dword ptr [EBP + -0x4],EAX
  1000b2dd  MOV EAX,dword ptr [EBP + -0xc]
  1000b2e0  DEC EAX
  1000b2e1  INC dword ptr [EBP + -0x8]
  1000b2e4  JMP 0x1000b2e9    ; LAB_1000b2e9
LAB_1000b2e6:
  1000b2e6  MOV EAX,dword ptr [EBP + -0xc]
LAB_1000b2e9:
  1000b2e9  CMP dword ptr [EBP + -0x4],0x0
  1000b2ed  JBE 0x1000b398    ; LAB_1000b398
LAB_1000b2f3:
  1000b2f3  DEC EAX
  1000b2f4  CMP byte ptr [EAX],0x0
  1000b2f7  JNZ 0x1000b301    ; LAB_1000b301
  1000b2f9  DEC dword ptr [EBP + -0x4]
  1000b2fc  INC dword ptr [EBP + -0x8]
  1000b2ff  JMP 0x1000b2f3    ; LAB_1000b2f3
LAB_1000b301:
  1000b301  LEA EAX,[EBP + -0x40]
  1000b304  PUSH EAX
  1000b305  LEA EAX,[EBP + -0x5c]
  1000b308  PUSH dword ptr [EBP + -0x4]
  1000b30b  PUSH EAX
  1000b30c  CALL 0x1000ae7b    ; FUN_1000ae7b
  1000b311  MOV EAX,dword ptr [EBP + -0x1c]
  1000b314  XOR ECX,ECX
  1000b316  ADD ESP,0xc
  1000b319  CMP dword ptr [EBP + -0x18],ECX
  1000b31c  JGE 0x1000b320    ; LAB_1000b320
  1000b31e  NEG EAX
LAB_1000b320:
  1000b320  ADD EAX,dword ptr [EBP + -0x8]
  1000b323  CMP dword ptr [EBP + -0x20],ECX
  1000b326  JNZ 0x1000b32b    ; LAB_1000b32b
  1000b328  ADD EAX,dword ptr [EBP + 0x18]
LAB_1000b32b:
  1000b32b  CMP dword ptr [EBP + -0x24],ECX
  1000b32e  JNZ 0x1000b333    ; LAB_1000b333
  1000b330  SUB EAX,dword ptr [EBP + 0x1c]
LAB_1000b333:
  1000b333  CMP EAX,0x1450
  1000b338  JLE 0x1000b36a    ; LAB_1000b36a
  1000b33a  MOV dword ptr [EBP + -0x2c],0x1
LAB_1000b341:
  1000b341  MOV EBX,dword ptr [EBP + 0x10]
  1000b344  MOV ESI,dword ptr [EBP + 0x10]
  1000b347  MOV EAX,dword ptr [EBP + 0x10]
  1000b34a  MOV EDX,dword ptr [EBP + 0x10]
LAB_1000b34d:
  1000b34d  CMP dword ptr [EBP + -0x2c],0x0
  1000b351  JZ 0x1000b3b3    ; LAB_1000b3b3
  1000b353  XOR EBX,EBX
  1000b355  MOV EAX,0x7fff
  1000b35a  MOV ESI,0x80000000
  1000b35f  XOR EDX,EDX
  1000b361  MOV dword ptr [EBP + -0x14],0x2
  1000b368  JMP 0x1000b3c8    ; LAB_1000b3c8
LAB_1000b36a:
  1000b36a  CMP EAX,0xffffebb0
  1000b36f  JGE 0x1000b37a    ; LAB_1000b37a
  1000b371  MOV dword ptr [EBP + -0x30],0x1
  1000b378  JMP 0x1000b341    ; LAB_1000b341
LAB_1000b37a:
  1000b37a  PUSH dword ptr [EBP + 0x14]
  1000b37d  PUSH EAX
  1000b37e  LEA EAX,[EBP + -0x40]
  1000b381  PUSH EAX
  1000b382  CALL 0x1000c061    ; FUN_1000c061
  1000b387  MOV EDX,dword ptr [EBP + -0x40]
  1000b38a  MOV EBX,dword ptr [EBP + -0x3e]
  1000b38d  MOV ESI,dword ptr [EBP + -0x3a]
  1000b390  MOV EAX,dword ptr [EBP + -0x36]
  1000b393  ADD ESP,0xc
  1000b396  JMP 0x1000b34d    ; LAB_1000b34d
LAB_1000b398:
  1000b398  XOR EDX,EDX
  1000b39a  XOR EAX,EAX
  1000b39c  XOR ESI,ESI
  1000b39e  XOR EBX,EBX
  1000b3a0  JMP 0x1000b34d    ; LAB_1000b34d
LAB_1000b3a2:
  1000b3a2  XOR EDX,EDX
  1000b3a4  XOR EAX,EAX
  1000b3a6  XOR ESI,ESI
  1000b3a8  XOR EBX,EBX
  1000b3aa  MOV dword ptr [EBP + -0x14],0x4
  1000b3b1  JMP 0x1000b3c8    ; LAB_1000b3c8
LAB_1000b3b3:
  1000b3b3  CMP dword ptr [EBP + -0x30],0x0
  1000b3b7  JZ 0x1000b3c8    ; LAB_1000b3c8
  1000b3b9  XOR EDX,EDX
  1000b3bb  XOR EAX,EAX
  1000b3bd  XOR ESI,ESI
  1000b3bf  XOR EBX,EBX
  1000b3c1  MOV dword ptr [EBP + -0x14],0x1
LAB_1000b3c8:
  1000b3c8  MOV ECX,dword ptr [EBP + 0x8]
  1000b3cb  OR EAX,dword ptr [EBP + -0x28]
  1000b3ce  POP EDI
  1000b3cf  MOV dword ptr [ECX + 0x6],ESI
  1000b3d2  MOV dword ptr [ECX + 0x2],EBX
  1000b3d5  MOV word ptr [ECX + 0xa],AX
  1000b3d9  MOV EAX,dword ptr [EBP + -0x14]
  1000b3dc  POP ESI
  1000b3dd  MOV word ptr [ECX],DX
  1000b3e0  POP EBX
  1000b3e1  LEAVE
  1000b3e2  RET

;==== FUNCTION FUN_1000b413 @ 1000b413 : uint FUN_1000b413(void * this, undefined4 * param_1, int * param_2, byte * param_3, int param_4)
  1000b413  PUSH EBP
  1000b414  MOV EBP,ESP
  1000b416  SUB ESP,0xc
  1000b419  XOR EAX,EAX
  1000b41b  PUSH ESI
  1000b41c  PUSH EAX
  1000b41d  PUSH EAX
  1000b41e  PUSH EAX
  1000b41f  LEA EAX,[EBP + -0xc]
  1000b422  PUSH dword ptr [EBP + 0x14]
  1000b425  PUSH dword ptr [EBP + 0x10]
  1000b428  PUSH dword ptr [EBP + 0xc]
  1000b42b  PUSH EAX
  1000b42c  CALL 0x1000af42    ; FUN_1000af42
  1000b431  PUSH dword ptr [EBP + 0x8]
  1000b434  MOV ESI,EAX
  1000b436  LEA EAX,[EBP + -0xc]
  1000b439  PUSH EAX
  1000b43a  CALL 0x10008189    ; FUN_10008189
  1000b43f  ADD ESP,0x24
  1000b442  CMP EAX,0x1
  1000b445  JNZ 0x1000b44a    ; LAB_1000b44a
  1000b447  OR ESI,0x2
LAB_1000b44a:
  1000b44a  MOV EAX,ESI
  1000b44c  POP ESI
  1000b44d  LEAVE
  1000b44e  RET

;==== FUNCTION FUN_1000b44f @ 1000b44f : undefined4 FUN_1000b44f(uint param_1, uint param_2, uint param_3, int param_4, byte param_5, short * param_6)
  1000b44f  PUSH EBP
  1000b450  MOV EBP,ESP
  1000b452  SUB ESP,0x1c
  1000b455  MOV EAX,dword ptr [EBP + 0x10]
  1000b458  PUSH EBX
  1000b459  MOV EBX,dword ptr [EBP + 0x1c]
  1000b45c  PUSH ESI
  1000b45d  MOV ECX,EAX
  1000b45f  MOV ESI,0x7fff
  1000b464  AND ECX,0x8000
  1000b46a  AND EAX,ESI
  1000b46c  TEST CX,CX
  1000b46f  PUSH EDI
  1000b470  MOV byte ptr [EBP + -0x1c],0xcc
  1000b474  MOV byte ptr [EBP + -0x1b],0xcc
  1000b478  MOV byte ptr [EBP + -0x1a],0xcc
  1000b47c  MOV byte ptr [EBP + -0x19],0xcc
  1000b480  MOV byte ptr [EBP + -0x18],0xcc
  1000b484  MOV byte ptr [EBP + -0x17],0xcc
  1000b488  MOV byte ptr [EBP + -0x16],0xcc
  1000b48c  MOV byte ptr [EBP + -0x15],0xcc
  1000b490  MOV byte ptr [EBP + -0x14],0xcc
  1000b494  MOV byte ptr [EBP + -0x13],0xcc
  1000b498  MOV byte ptr [EBP + -0x12],0xfb
  1000b49c  MOV byte ptr [EBP + -0x11],0x3f
  1000b4a0  MOV dword ptr [EBP + -0x4],0x1
  1000b4a7  MOV EDX,EAX
  1000b4a9  JZ 0x1000b4b1    ; LAB_1000b4b1
  1000b4ab  MOV byte ptr [EBX + 0x2],0x2d
  1000b4af  JMP 0x1000b4b5    ; LAB_1000b4b5
LAB_1000b4b1:
  1000b4b1  MOV byte ptr [EBX + 0x2],0x20
LAB_1000b4b5:
  1000b4b5  MOV EDI,dword ptr [EBP + 0xc]
  1000b4b8  TEST DX,DX
  1000b4bb  JNZ 0x1000b4db    ; LAB_1000b4db
  1000b4bd  TEST EDI,EDI
  1000b4bf  JNZ 0x1000b4db    ; LAB_1000b4db
  1000b4c1  CMP dword ptr [EBP + 0x8],EDI
  1000b4c4  JNZ 0x1000b4db    ; LAB_1000b4db
LAB_1000b4c6:
  1000b4c6  AND word ptr [EBX],0x0
  1000b4ca  MOV byte ptr [EBX + 0x2],0x20
  1000b4ce  MOV byte ptr [EBX + 0x3],0x1
  1000b4d2  MOV byte ptr [EBX + 0x4],0x30
  1000b4d6  JMP 0x1000b6d9    ; LAB_1000b6d9
LAB_1000b4db:
  1000b4db  CMP DX,SI
  1000b4de  JNZ 0x1000b55a    ; LAB_1000b55a
  1000b4e0  MOV EAX,0x80000000
  1000b4e5  MOV word ptr [EBX],0x1
  1000b4ea  CMP EDI,EAX
  1000b4ec  JNZ 0x1000b4f4    ; LAB_1000b4f4
  1000b4ee  CMP dword ptr [EBP + 0x8],0x0
  1000b4f2  JZ 0x1000b503    ; LAB_1000b503
LAB_1000b4f4:
  1000b4f4  TEST EDI,0x40000000
  1000b4fa  JNZ 0x1000b503    ; LAB_1000b503
  1000b4fc  PUSH 0x1000d610    ; s_1#SNAN_1000d610
  1000b501  JMP 0x1000b549    ; LAB_1000b549
LAB_1000b503:
  1000b503  TEST CX,CX
  1000b506  JZ 0x1000b51d    ; LAB_1000b51d
  1000b508  CMP EDI,0xc0000000
  1000b50e  JNZ 0x1000b51d    ; LAB_1000b51d
  1000b510  CMP dword ptr [EBP + 0x8],0x0
  1000b514  JNZ 0x1000b544    ; LAB_1000b544
  1000b516  PUSH 0x1000d608    ; s_1#IND_1000d608
  1000b51b  JMP 0x1000b52c    ; LAB_1000b52c
LAB_1000b51d:
  1000b51d  CMP EDI,EAX
  1000b51f  JNZ 0x1000b544    ; LAB_1000b544
  1000b521  CMP dword ptr [EBP + 0x8],0x0
  1000b525  JNZ 0x1000b544    ; LAB_1000b544
  1000b527  PUSH 0x1000d600    ; s_1#INF_1000d600
LAB_1000b52c:
  1000b52c  LEA EAX,[EBX + 0x4]
  1000b52f  PUSH EAX
  1000b530  CALL 0x10008290    ; FUN_10008290
  1000b535  POP ECX
  1000b536  MOV byte ptr [EBX + 0x3],0x5
  1000b53a  POP ECX
LAB_1000b53b:
  1000b53b  AND dword ptr [EBP + -0x4],0x0
  1000b53f  JMP 0x1000b6b2    ; LAB_1000b6b2
LAB_1000b544:
  1000b544  PUSH 0x1000d5f8    ; s_1#QNAN_1000d5f8
LAB_1000b549:
  1000b549  LEA EAX,[EBX + 0x4]
  1000b54c  PUSH EAX
  1000b54d  CALL 0x10008290    ; FUN_10008290
  1000b552  POP ECX
  1000b553  MOV byte ptr [EBX + 0x3],0x6
  1000b557  POP ECX
  1000b558  JMP 0x1000b53b    ; LAB_1000b53b
LAB_1000b55a:
  1000b55a  MOVZX EAX,DX
  1000b55d  MOV ECX,EDI
  1000b55f  MOV ESI,EAX
  1000b561  SHR ECX,0x18
  1000b564  IMUL EAX,EAX,0x4d10
  1000b56a  SHR ESI,0x8
  1000b56d  AND word ptr [EBP + -0x10],0x0
  1000b572  PUSH 0x1
  1000b574  LEA ECX,[ESI + ECX*0x2]
  1000b577  MOV word ptr [EBP + -0x6],DX
  1000b57b  IMUL ECX,ECX,0x4d
  1000b57e  MOV dword ptr [EBP + -0xa],EDI
  1000b581  LEA ESI,[ECX + EAX*0x1 + 0xecbced0c]
  1000b588  MOV EAX,dword ptr [EBP + 0x8]
  1000b58b  SAR ESI,0x10
  1000b58e  MOV dword ptr [EBP + -0xe],EAX
  1000b591  MOVSX EAX,SI
  1000b594  NEG EAX
  1000b596  PUSH EAX
  1000b597  LEA EAX,[EBP + -0x10]
  1000b59a  PUSH EAX
  1000b59b  CALL 0x1000c061    ; FUN_1000c061
  1000b5a0  ADD ESP,0xc
  1000b5a3  CMP word ptr [EBP + -0x6],0x3fff
  1000b5a9  JC 0x1000b5bb    ; LAB_1000b5bb
  1000b5ab  LEA EAX,[EBP + -0x1c]
  1000b5ae  INC ESI
  1000b5af  PUSH EAX
  1000b5b0  LEA EAX,[EBP + -0x10]
  1000b5b3  PUSH EAX
  1000b5b4  CALL 0x1000be41    ; FUN_1000be41
  1000b5b9  POP ECX
  1000b5ba  POP ECX
LAB_1000b5bb:
  1000b5bb  TEST byte ptr [EBP + 0x18],0x1
  1000b5bf  MOV word ptr [EBX],SI
  1000b5c2  JZ 0x1000b5d5    ; LAB_1000b5d5
  1000b5c4  MOV EDI,dword ptr [EBP + 0x14]
  1000b5c7  MOVSX EAX,SI
  1000b5ca  ADD EDI,EAX
  1000b5cc  TEST EDI,EDI
  1000b5ce  JG 0x1000b5d8    ; LAB_1000b5d8
  1000b5d0  JMP 0x1000b4c6    ; LAB_1000b4c6
LAB_1000b5d5:
  1000b5d5  MOV EDI,dword ptr [EBP + 0x14]
LAB_1000b5d8:
  1000b5d8  CMP EDI,0x15
  1000b5db  JLE 0x1000b5e0    ; LAB_1000b5e0
  1000b5dd  PUSH 0x15
  1000b5df  POP EDI
LAB_1000b5e0:
  1000b5e0  MOVZX ESI,word ptr [EBP + -0x6]
  1000b5e4  SUB ESI,0x3ffe
  1000b5ea  AND word ptr [EBP + -0x6],0x0
  1000b5ef  MOV dword ptr [EBP + 0x1c],0x8
LAB_1000b5f6:
  1000b5f6  LEA EAX,[EBP + -0x10]
  1000b5f9  PUSH EAX
  1000b5fa  CALL 0x1000ae20    ; FUN_1000ae20
  1000b5ff  DEC dword ptr [EBP + 0x1c]
  1000b602  POP ECX
  1000b603  JNZ 0x1000b5f6    ; LAB_1000b5f6
  1000b605  TEST ESI,ESI
  1000b607  JGE 0x1000b620    ; LAB_1000b620
  1000b609  NEG ESI
  1000b60b  AND ESI,0xff
  1000b611  JLE 0x1000b620    ; LAB_1000b620
LAB_1000b613:
  1000b613  LEA EAX,[EBP + -0x10]
  1000b616  PUSH EAX
  1000b617  CALL 0x1000ae4e    ; FUN_1000ae4e
  1000b61c  DEC ESI
  1000b61d  POP ECX
  1000b61e  JNZ 0x1000b613    ; LAB_1000b613
LAB_1000b620:
  1000b620  LEA ECX,[EDI + 0x1]
  1000b623  LEA EAX,[EBX + 0x4]
  1000b626  TEST ECX,ECX
  1000b628  MOV dword ptr [EBP + 0x1c],EAX
  1000b62b  JLE 0x1000b67d    ; LAB_1000b67d
  1000b62d  MOV dword ptr [EBP + 0x14],ECX
LAB_1000b630:
  1000b630  LEA ESI,[EBP + -0x10]
  1000b633  LEA EDI,[EBP + 0x8]
  1000b636  MOVSD ES:EDI,ESI
  1000b637  MOVSD ES:EDI,ESI
  1000b638  LEA EAX,[EBP + -0x10]
  1000b63b  PUSH EAX
  1000b63c  MOVSD ES:EDI,ESI
  1000b63d  CALL 0x1000ae20    ; FUN_1000ae20
  1000b642  LEA EAX,[EBP + -0x10]
  1000b645  PUSH EAX
  1000b646  CALL 0x1000ae20    ; FUN_1000ae20
  1000b64b  LEA EAX,[EBP + 0x8]
  1000b64e  PUSH EAX
  1000b64f  LEA EAX,[EBP + -0x10]
  1000b652  PUSH EAX
  1000b653  CALL 0x1000adc2    ; ___add_12
  1000b658  LEA EAX,[EBP + -0x10]
  1000b65b  PUSH EAX
  1000b65c  CALL 0x1000ae20    ; FUN_1000ae20
  1000b661  MOV AL,byte ptr [EBP + -0x5]
  1000b664  MOV ECX,dword ptr [EBP + 0x1c]
  1000b667  AND byte ptr [EBP + -0x5],0x0
  1000b66b  ADD ESP,0x14
  1000b66e  ADD AL,0x30
  1000b670  INC dword ptr [EBP + 0x1c]
  1000b673  DEC dword ptr [EBP + 0x14]
  1000b676  MOV byte ptr [ECX],AL
  1000b678  JNZ 0x1000b630    ; LAB_1000b630
  1000b67a  MOV EAX,dword ptr [EBP + 0x1c]
LAB_1000b67d:
  1000b67d  MOV CL,byte ptr [EAX + -0x1]
  1000b680  DEC EAX
  1000b681  DEC EAX
  1000b682  CMP CL,0x35
  1000b685  LEA ECX,[EBX + 0x4]
  1000b688  JL 0x1000b6ba    ; LAB_1000b6ba
LAB_1000b68a:
  1000b68a  CMP EAX,ECX
  1000b68c  JC 0x1000b69d    ; LAB_1000b69d
  1000b68e  CMP byte ptr [EAX],0x39
  1000b691  JNZ 0x1000b699    ; LAB_1000b699
  1000b693  MOV byte ptr [EAX],0x30
  1000b696  DEC EAX
  1000b697  JMP 0x1000b68a    ; LAB_1000b68a
LAB_1000b699:
  1000b699  CMP EAX,ECX
  1000b69b  JNC 0x1000b6a1    ; LAB_1000b6a1
LAB_1000b69d:
  1000b69d  INC EAX
  1000b69e  INC word ptr [EBX]
LAB_1000b6a1:
  1000b6a1  INC byte ptr [EAX]
LAB_1000b6a3:
  1000b6a3  SUB AL,BL
  1000b6a5  SUB AL,0x3
  1000b6a7  MOV byte ptr [EBX + 0x3],AL
  1000b6aa  MOVSX EAX,AL
  1000b6ad  AND byte ptr [EAX + EBX*0x1 + 0x4],0x0
LAB_1000b6b2:
  1000b6b2  MOV EAX,dword ptr [EBP + -0x4]
LAB_1000b6b5:
  1000b6b5  POP EDI
  1000b6b6  POP ESI
  1000b6b7  POP EBX
  1000b6b8  LEAVE
  1000b6b9  RET
LAB_1000b6ba:
  1000b6ba  CMP EAX,ECX
  1000b6bc  JC 0x1000b6ca    ; LAB_1000b6ca
  1000b6be  CMP byte ptr [EAX],0x30
  1000b6c1  JNZ 0x1000b6c6    ; LAB_1000b6c6
  1000b6c3  DEC EAX
  1000b6c4  JMP 0x1000b6ba    ; LAB_1000b6ba
LAB_1000b6c6:
  1000b6c6  CMP EAX,ECX
  1000b6c8  JNC 0x1000b6a3    ; LAB_1000b6a3
LAB_1000b6ca:
  1000b6ca  AND word ptr [EBX],0x0
  1000b6ce  MOV byte ptr [EBX + 0x2],0x20
  1000b6d2  MOV byte ptr [EBX + 0x3],0x1
  1000b6d6  MOV byte ptr [ECX],0x30
LAB_1000b6d9:
  1000b6d9  AND byte ptr [EBX + 0x5],0x0
  1000b6dd  PUSH 0x1
  1000b6df  POP EAX
  1000b6e0  JMP 0x1000b6b5    ; LAB_1000b6b5

;==== FUNCTION FUN_1000b6e2 @ 1000b6e2 : undefined FUN_1000b6e2(uint param_1)
  1000b6e2  MOV ECX,dword ptr [ESP + 0x4]
  1000b6e6  XOR EDX,EDX
  1000b6e8  MOV dword ptr [0x1000f650],ECX    ; DAT_1000f650
  1000b6ee  MOV EAX,0x1000f188    ; DAT_1000f188
LAB_1000b6f3:
  1000b6f3  CMP ECX,dword ptr [EAX]    ; DAT_1000f188 DAT_1000f190
  1000b6f5  JZ 0x1000b717    ; LAB_1000b717
  1000b6f7  ADD EAX,0x8    ; DAT_1000f198
  1000b6fa  INC EDX
  1000b6fb  CMP EAX,0x1000f2f0    ; DAT_1000f2f0
  1000b700  JL 0x1000b6f3    ; LAB_1000b6f3
  1000b702  CMP ECX,0x13
  1000b705  JC 0x1000b724    ; LAB_1000b724
  1000b707  CMP ECX,0x24
  1000b70a  JA 0x1000b724    ; LAB_1000b724
  1000b70c  MOV dword ptr [0x1000f64c],0xd    ; DAT_1000f64c
  1000b716  RET
LAB_1000b717:
  1000b717  MOV EAX,dword ptr [EDX*0x8 + 0x1000f18c]    ; DAT_1000f194
  1000b71e  MOV [0x1000f64c],EAX    ; DAT_1000f64c
  1000b723  RET
LAB_1000b724:
  1000b724  CMP ECX,0xbc
  1000b72a  JC 0x1000b73e    ; LAB_1000b73e
  1000b72c  CMP ECX,0xca
  1000b732  MOV dword ptr [0x1000f64c],0x8    ; DAT_1000f64c
  1000b73c  JBE 0x1000b748    ; LAB_1000b748
LAB_1000b73e:
  1000b73e  MOV dword ptr [0x1000f64c],0x16    ; DAT_1000f64c
LAB_1000b748:
  1000b748  RET

;==== FUNCTION FUN_1000b749 @ 1000b749 : int FUN_1000b749(void)
  1000b749  PUSH EBX
  1000b74a  PUSH ESI
  1000b74b  PUSH EDI
  1000b74c  OR EBX,0xffffffff
  1000b74f  XOR EDI,EDI
  1000b751  XOR ESI,ESI
  1000b753  MOV ECX,0x10010aa0    ; DAT_10010aa0
LAB_1000b758:
  1000b758  MOV EAX,dword ptr [ECX]    ; DAT_10010aa0 DAT_10010aa4
  1000b75a  TEST EAX,EAX
  1000b75c  JZ 0x1000b795    ; LAB_1000b795
  1000b75e  LEA EDX,[EAX + 0x100]
LAB_1000b764:
  1000b764  CMP EAX,EDX
  1000b766  JNC 0x1000b784    ; LAB_1000b784
  1000b768  TEST byte ptr [EAX + 0x4],0x1
  1000b76c  JZ 0x1000b773    ; LAB_1000b773
  1000b76e  ADD EAX,0x8
  1000b771  JMP 0x1000b764    ; LAB_1000b764
LAB_1000b773:
  1000b773  OR dword ptr [EAX],0xffffffff
  1000b776  SUB EAX,dword ptr [ECX]    ; DAT_10010aa0
  1000b778  SAR EAX,0x3
  1000b77b  ADD EAX,ESI
  1000b77d  MOV EBX,EAX
  1000b77f  CMP EBX,-0x1
  1000b782  JNZ 0x1000b7d8    ; LAB_1000b7d8
LAB_1000b784:
  1000b784  ADD ECX,0x4
  1000b787  INC EDI
  1000b788  ADD ESI,0x20
  1000b78b  CMP ECX,0x10010ba0    ; DAT_10010ba0
  1000b791  JL 0x1000b758    ; LAB_1000b758
  1000b793  JMP 0x1000b7d8    ; LAB_1000b7d8
LAB_1000b795:
  1000b795  MOV ESI,0x100
  1000b79a  PUSH ESI
  1000b79b  CALL 0x10005e59    ; _malloc
  1000b7a0  TEST EAX,EAX
  1000b7a2  POP ECX
  1000b7a3  JZ 0x1000b7d8    ; LAB_1000b7d8
  1000b7a5  ADD dword ptr [0x10010ba0],0x20    ; DAT_10010ba0
  1000b7ac  LEA ECX,[EDI*0x4 + 0x10010aa0]    ; DAT_10010aa4
  1000b7b3  LEA EDX,[EAX + 0x100]
  1000b7b9  MOV dword ptr [ECX],EAX    ; DAT_10010aa4
LAB_1000b7bb:
  1000b7bb  CMP EAX,EDX
  1000b7bd  JNC 0x1000b7d3    ; LAB_1000b7d3
  1000b7bf  AND byte ptr [EAX + 0x4],0x0
  1000b7c3  OR dword ptr [EAX],0xffffffff
  1000b7c6  MOV byte ptr [EAX + 0x5],0xa
  1000b7ca  MOV EDX,dword ptr [ECX]    ; DAT_10010aa4
  1000b7cc  ADD EAX,0x8
  1000b7cf  ADD EDX,ESI
  1000b7d1  JMP 0x1000b7bb    ; LAB_1000b7bb
LAB_1000b7d3:
  1000b7d3  SHL EDI,0x5
  1000b7d6  MOV EBX,EDI
LAB_1000b7d8:
  1000b7d8  POP EDI
  1000b7d9  MOV EAX,EBX
  1000b7db  POP ESI
  1000b7dc  POP EBX
  1000b7dd  RET

;==== FUNCTION FUN_1000b7de @ 1000b7de : undefined4 FUN_1000b7de(uint param_1, HANDLE param_2)
  1000b7de  MOV EAX,dword ptr [ESP + 0x4]
  1000b7e2  PUSH ESI
  1000b7e3  CMP EAX,dword ptr [0x10010ba0]    ; DAT_10010ba0
  1000b7e9  PUSH EDI
  1000b7ea  JNC 0x1000b83e    ; LAB_1000b83e
  1000b7ec  MOV ECX,EAX
  1000b7ee  MOV ESI,EAX
  1000b7f0  SAR ECX,0x5
  1000b7f3  AND ESI,0x1f
  1000b7f6  LEA EDI,[ECX*0x4 + 0x10010aa0]    ; DAT_10010aa0
  1000b7fd  SHL ESI,0x3
  1000b800  MOV ECX,dword ptr [EDI]    ; DAT_10010aa0
  1000b802  CMP dword ptr [ECX + ESI*0x1],-0x1
  1000b806  JNZ 0x1000b83e    ; LAB_1000b83e
  1000b808  CMP dword ptr [0x1000f628],0x1    ; DAT_1000f628
  1000b80f  PUSH EBX
  1000b810  MOV EBX,dword ptr [ESP + 0x14]
  1000b814  JNZ 0x1000b834    ; LAB_1000b834
  1000b816  SUB EAX,0x0
  1000b819  JZ 0x1000b82b    ; LAB_1000b82b
  1000b81b  DEC EAX
  1000b81c  JZ 0x1000b826    ; LAB_1000b826
  1000b81e  DEC EAX
  1000b81f  JNZ 0x1000b834    ; LAB_1000b834
  1000b821  PUSH EBX
  1000b822  PUSH -0xc
  1000b824  JMP 0x1000b82e    ; LAB_1000b82e
LAB_1000b826:
  1000b826  PUSH EBX
  1000b827  PUSH -0xb
  1000b829  JMP 0x1000b82e    ; LAB_1000b82e
LAB_1000b82b:
  1000b82b  PUSH EBX
  1000b82c  PUSH -0xa
LAB_1000b82e:
  1000b82e  CALL dword ptr [0x1000d0c8]    ; PTR_SetStdHandle_1000d0c8 KERNEL32.DLL::SetStdHandle
LAB_1000b834:
  1000b834  MOV EAX,dword ptr [EDI]    ; DAT_10010aa0
  1000b836  MOV dword ptr [EAX + ESI*0x1],EBX
  1000b839  XOR EAX,EAX
  1000b83b  POP EBX
  1000b83c  JMP 0x1000b852    ; LAB_1000b852
LAB_1000b83e:
  1000b83e  AND dword ptr [0x1000f650],0x0    ; DAT_1000f650
  1000b845  MOV dword ptr [0x1000f64c],0x9    ; DAT_1000f64c
  1000b84f  OR EAX,0xffffffff
LAB_1000b852:
  1000b852  POP EDI
  1000b853  POP ESI
  1000b854  RET

;==== FUNCTION FUN_1000b855 @ 1000b855 : undefined4 FUN_1000b855(uint param_1)
  1000b855  MOV ECX,dword ptr [ESP + 0x4]
  1000b859  PUSH ESI
  1000b85a  CMP ECX,dword ptr [0x10010ba0]    ; DAT_10010ba0
  1000b860  PUSH EDI
  1000b861  JNC 0x1000b8b8    ; LAB_1000b8b8
  1000b863  MOV EAX,ECX
  1000b865  MOV ESI,ECX
  1000b867  SAR EAX,0x5
  1000b86a  AND ESI,0x1f
  1000b86d  LEA EDI,[EAX*0x4 + 0x10010aa0]    ; DAT_10010aa0
  1000b874  SHL ESI,0x3
  1000b877  MOV EAX,dword ptr [EDI]    ; DAT_10010aa0
  1000b879  ADD EAX,ESI
  1000b87b  TEST byte ptr [EAX + 0x4],0x1
  1000b87f  JZ 0x1000b8b8    ; LAB_1000b8b8
  1000b881  CMP dword ptr [EAX],-0x1
  1000b884  JZ 0x1000b8b8    ; LAB_1000b8b8
  1000b886  CMP dword ptr [0x1000f628],0x1    ; DAT_1000f628
  1000b88d  JNZ 0x1000b8ae    ; LAB_1000b8ae
  1000b88f  XOR EAX,EAX
  1000b891  SUB ECX,EAX
  1000b893  JZ 0x1000b8a5    ; LAB_1000b8a5
  1000b895  DEC ECX
  1000b896  JZ 0x1000b8a0    ; LAB_1000b8a0
  1000b898  DEC ECX
  1000b899  JNZ 0x1000b8ae    ; LAB_1000b8ae
  1000b89b  PUSH EAX
  1000b89c  PUSH -0xc
  1000b89e  JMP 0x1000b8a8    ; LAB_1000b8a8
LAB_1000b8a0:
  1000b8a0  PUSH EAX
  1000b8a1  PUSH -0xb
  1000b8a3  JMP 0x1000b8a8    ; LAB_1000b8a8
LAB_1000b8a5:
  1000b8a5  PUSH EAX
  1000b8a6  PUSH -0xa
LAB_1000b8a8:
  1000b8a8  CALL dword ptr [0x1000d0c8]    ; PTR_SetStdHandle_1000d0c8 KERNEL32.DLL::SetStdHandle
LAB_1000b8ae:
  1000b8ae  MOV EAX,dword ptr [EDI]    ; DAT_10010aa0
  1000b8b0  OR dword ptr [EAX + ESI*0x1],0xffffffff
  1000b8b4  XOR EAX,EAX
  1000b8b6  JMP 0x1000b8cc    ; LAB_1000b8cc
LAB_1000b8b8:
  1000b8b8  AND dword ptr [0x1000f650],0x0    ; DAT_1000f650
  1000b8bf  MOV dword ptr [0x1000f64c],0x9    ; DAT_1000f64c
  1000b8c9  OR EAX,0xffffffff
LAB_1000b8cc:
  1000b8cc  POP EDI
  1000b8cd  POP ESI
  1000b8ce  RET

;==== FUNCTION FUN_1000b8cf @ 1000b8cf : undefined4 FUN_1000b8cf(uint param_1)
  1000b8cf  MOV EAX,dword ptr [ESP + 0x4]
  1000b8d3  CMP EAX,dword ptr [0x10010ba0]    ; DAT_10010ba0
  1000b8d9  JNC 0x1000b8f7    ; LAB_1000b8f7
  1000b8db  MOV ECX,EAX
  1000b8dd  AND EAX,0x1f
  1000b8e0  SAR ECX,0x5
  1000b8e3  MOV ECX,dword ptr [ECX*0x4 + 0x10010aa0]    ; DAT_10010aa0
  1000b8ea  TEST byte ptr [ECX + EAX*0x8 + 0x4],0x1
  1000b8ef  LEA EAX,[ECX + EAX*0x8]
  1000b8f2  JZ 0x1000b8f7    ; LAB_1000b8f7
  1000b8f4  MOV EAX,dword ptr [EAX]
  1000b8f6  RET
LAB_1000b8f7:
  1000b8f7  AND dword ptr [0x1000f650],0x0    ; DAT_1000f650
  1000b8fe  MOV dword ptr [0x1000f64c],0x9    ; DAT_1000f64c
  1000b908  OR EAX,0xffffffff
  1000b90b  RET

;==== FUNCTION FUN_1000b90c @ 1000b90c : uint FUN_1000b90c(HANDLE param_1, uint param_2)
  1000b90c  PUSH EBP
  1000b90d  MOV EBP,ESP
  1000b90f  PUSH EBX
  1000b910  XOR BL,BL
  1000b912  TEST byte ptr [EBP + 0xc],0x8
  1000b916  PUSH ESI
  1000b917  JZ 0x1000b91c    ; LAB_1000b91c
  1000b919  ADD BL,0x20
LAB_1000b91c:
  1000b91c  TEST byte ptr [EBP + 0xd],0x40
  1000b920  JZ 0x1000b925    ; LAB_1000b925
  1000b922  OR BL,0x80
LAB_1000b925:
  1000b925  TEST byte ptr [EBP + 0xc],0x80
  1000b929  JZ 0x1000b92e    ; LAB_1000b92e
  1000b92b  OR BL,0x10
LAB_1000b92e:
  1000b92e  PUSH dword ptr [EBP + 0x8]
  1000b931  CALL dword ptr [0x1000d05c]    ; PTR_GetFileType_1000d05c KERNEL32.DLL::GetFileType
  1000b937  TEST EAX,EAX
  1000b939  JNZ 0x1000b94d    ; LAB_1000b94d
  1000b93b  CALL dword ptr [0x1000d08c]    ; PTR_GetLastError_1000d08c KERNEL32.DLL::GetLastError
  1000b941  PUSH EAX
  1000b942  CALL 0x1000b6e2    ; FUN_1000b6e2
  1000b947  POP ECX
  1000b948  OR EAX,0xffffffff
  1000b94b  JMP 0x1000b9a5    ; LAB_1000b9a5
LAB_1000b94d:
  1000b94d  CMP EAX,0x2
  1000b950  JNZ 0x1000b957    ; LAB_1000b957
  1000b952  OR BL,0x40
  1000b955  JMP 0x1000b95f    ; LAB_1000b95f
LAB_1000b957:
  1000b957  CMP EAX,0x3
  1000b95a  JNZ 0x1000b95f    ; LAB_1000b95f
  1000b95c  OR BL,0x8
LAB_1000b95f:
  1000b95f  CALL 0x1000b749    ; FUN_1000b749
  1000b964  MOV ESI,EAX
  1000b966  OR EAX,0xffffffff
  1000b969  CMP ESI,EAX
  1000b96b  JNZ 0x1000b980    ; LAB_1000b980
  1000b96d  AND dword ptr [0x1000f650],0x0    ; DAT_1000f650
  1000b974  MOV dword ptr [0x1000f64c],0x18    ; DAT_1000f64c
  1000b97e  JMP 0x1000b9a5    ; LAB_1000b9a5
LAB_1000b980:
  1000b980  PUSH dword ptr [EBP + 0x8]
  1000b983  PUSH ESI
  1000b984  CALL 0x1000b7de    ; FUN_1000b7de
  1000b989  POP ECX
  1000b98a  MOV EAX,ESI
  1000b98c  POP ECX
  1000b98d  OR BL,0x1
  1000b990  SAR EAX,0x5
  1000b993  MOV ECX,ESI
  1000b995  MOV EAX,dword ptr [EAX*0x4 + 0x10010aa0]    ; DAT_10010aa0
  1000b99c  AND ECX,0x1f
  1000b99f  MOV byte ptr [EAX + ECX*0x8 + 0x4],BL
  1000b9a3  MOV EAX,ESI
LAB_1000b9a5:
  1000b9a5  POP ESI
  1000b9a6  POP EBX
  1000b9a7  POP EBP
  1000b9a8  RET

;==== FUNCTION FUN_1000b9a9 @ 1000b9a9 : int * FUN_1000b9a9(int param_1, int param_2)
  1000b9a9  PUSH EBX
  1000b9aa  PUSH ESI
  1000b9ab  MOV ESI,dword ptr [ESP + 0xc]
  1000b9af  PUSH EDI
  1000b9b0  IMUL ESI,dword ptr [ESP + 0x14]
  1000b9b5  CMP ESI,-0x20
  1000b9b8  MOV EBX,ESI
  1000b9ba  JA 0x1000b9c9    ; LAB_1000b9c9
  1000b9bc  TEST ESI,ESI
  1000b9be  JNZ 0x1000b9c3    ; LAB_1000b9c3
  1000b9c0  PUSH 0x1
  1000b9c2  POP ESI
LAB_1000b9c3:
  1000b9c3  ADD ESI,0xf
  1000b9c6  AND ESI,0xfffffff0
LAB_1000b9c9:
  1000b9c9  XOR EDI,EDI
  1000b9cb  CMP ESI,-0x20
  1000b9ce  JA 0x1000b9fa    ; LAB_1000b9fa
  1000b9d0  CMP EBX,dword ptr [0x1000ed70]    ; DAT_1000ed70
  1000b9d6  JA 0x1000b9e5    ; LAB_1000b9e5
  1000b9d8  PUSH EBX
  1000b9d9  CALL 0x10008cf5    ; FUN_10008cf5
  1000b9de  MOV EDI,EAX
  1000b9e0  POP ECX
  1000b9e1  TEST EDI,EDI
  1000b9e3  JNZ 0x1000ba10    ; LAB_1000ba10
LAB_1000b9e5:
  1000b9e5  PUSH ESI
  1000b9e6  PUSH 0x8
  1000b9e8  PUSH dword ptr [0x10010ba4]    ; DAT_10010ba4
  1000b9ee  CALL dword ptr [0x1000d038]    ; PTR_HeapAlloc_1000d038 KERNEL32.DLL::HeapAlloc
  1000b9f4  MOV EDI,EAX
  1000b9f6  TEST EDI,EDI
  1000b9f8  JNZ 0x1000ba1c    ; LAB_1000ba1c
LAB_1000b9fa:
  1000b9fa  CMP dword ptr [0x1000f7d8],0x0    ; DAT_1000f7d8
  1000ba01  JZ 0x1000ba1c    ; LAB_1000ba1c
  1000ba03  PUSH ESI
  1000ba04  CALL 0x100098b6    ; FUN_100098b6
  1000ba09  TEST EAX,EAX
  1000ba0b  POP ECX
  1000ba0c  JZ 0x1000ba22    ; LAB_1000ba22
  1000ba0e  JMP 0x1000b9c9    ; LAB_1000b9c9
LAB_1000ba10:
  1000ba10  PUSH EBX
  1000ba11  PUSH 0x0
  1000ba13  PUSH EDI
  1000ba14  CALL 0x10008520    ; _memset
  1000ba19  ADD ESP,0xc
LAB_1000ba1c:
  1000ba1c  MOV EAX,EDI
LAB_1000ba1e:
  1000ba1e  POP EDI
  1000ba1f  POP ESI
  1000ba20  POP EBX
  1000ba21  RET
LAB_1000ba22:
  1000ba22  XOR EAX,EAX
  1000ba24  JMP 0x1000ba1e    ; LAB_1000ba1e

;==== FUNCTION FUN_1000ba7e @ 1000ba7e : int FUN_1000ba7e(int * param_1)
  1000ba7e  PUSH ESI
  1000ba7f  MOV ESI,dword ptr [ESP + 0x8]
  1000ba83  TEST ESI,ESI
  1000ba85  JNZ 0x1000ba90    ; LAB_1000ba90
  1000ba87  PUSH ESI
  1000ba88  CALL 0x1000bb1e    ; flsall
  1000ba8d  POP ECX
  1000ba8e  POP ESI
  1000ba8f  RET
LAB_1000ba90:
  1000ba90  PUSH ESI
  1000ba91  CALL 0x1000bab9    ; FUN_1000bab9
  1000ba96  TEST EAX,EAX
  1000ba98  POP ECX
  1000ba99  JZ 0x1000baa0    ; LAB_1000baa0
  1000ba9b  OR EAX,0xffffffff
  1000ba9e  POP ESI
  1000ba9f  RET
LAB_1000baa0:
  1000baa0  TEST byte ptr [ESI + 0xd],0x40
  1000baa4  JZ 0x1000bab5    ; LAB_1000bab5
  1000baa6  PUSH dword ptr [ESI + 0x10]
  1000baa9  CALL 0x1000c133    ; FUN_1000c133
  1000baae  NEG EAX
  1000bab0  POP ECX
  1000bab1  POP ESI
  1000bab2  SBB EAX,EAX
  1000bab4  RET
LAB_1000bab5:
  1000bab5  XOR EAX,EAX
  1000bab7  POP ESI
  1000bab8  RET

;==== FUNCTION FUN_1000bab9 @ 1000bab9 : undefined4 FUN_1000bab9(int * param_1)
  1000bab9  PUSH EBX
  1000baba  PUSH ESI
  1000babb  MOV ESI,dword ptr [ESP + 0xc]
  1000babf  XOR EBX,EBX
  1000bac1  PUSH EDI
  1000bac2  MOV EAX,dword ptr [ESI + 0xc]
  1000bac5  MOV ECX,EAX
  1000bac7  AND ECX,0x3
  1000baca  CMP CL,0x2
  1000bacd  JNZ 0x1000bb06    ; LAB_1000bb06
  1000bacf  TEST AX,0x108
  1000bad3  JZ 0x1000bb06    ; LAB_1000bb06
  1000bad5  MOV EAX,dword ptr [ESI + 0x8]
  1000bad8  MOV EDI,dword ptr [ESI]
  1000bada  SUB EDI,EAX
  1000badc  TEST EDI,EDI
  1000bade  JLE 0x1000bb06    ; LAB_1000bb06
  1000bae0  PUSH EDI
  1000bae1  PUSH EAX
  1000bae2  PUSH dword ptr [ESI + 0x10]
  1000bae5  CALL 0x1000996b    ; FUN_1000996b
  1000baea  ADD ESP,0xc
  1000baed  CMP EAX,EDI
  1000baef  JNZ 0x1000baff    ; LAB_1000baff
  1000baf1  MOV EAX,dword ptr [ESI + 0xc]
  1000baf4  TEST AL,0x80
  1000baf6  JZ 0x1000bb06    ; LAB_1000bb06
  1000baf8  AND AL,0xfd
  1000bafa  MOV dword ptr [ESI + 0xc],EAX
  1000bafd  JMP 0x1000bb06    ; LAB_1000bb06
LAB_1000baff:
  1000baff  OR dword ptr [ESI + 0xc],0x20
  1000bb03  OR EBX,0xffffffff
LAB_1000bb06:
  1000bb06  MOV EAX,dword ptr [ESI + 0x8]
  1000bb09  AND dword ptr [ESI + 0x4],0x0
  1000bb0d  MOV dword ptr [ESI],EAX
  1000bb0f  POP EDI
  1000bb10  MOV EAX,EBX
  1000bb12  POP ESI
  1000bb13  POP EBX
  1000bb14  RET

;==== FUNCTION flsall @ 1000bb1e : int flsall(int param_1)
  1000bb1e  PUSH EBX
  1000bb1f  PUSH ESI
  1000bb20  PUSH EDI
  1000bb21  XOR ESI,ESI
  1000bb23  XOR EBX,EBX
  1000bb25  XOR EDI,EDI
  1000bb27  CMP dword ptr [0x10010a80],ESI    ; DAT_10010a80
  1000bb2d  JLE 0x1000bb7c    ; LAB_1000bb7c
LAB_1000bb2f:
  1000bb2f  MOV EAX,[0x1000fa68]    ; DAT_1000fa68
  1000bb34  MOV EAX,dword ptr [EAX + ESI*0x4]
  1000bb37  TEST EAX,EAX
  1000bb39  JZ 0x1000bb73    ; LAB_1000bb73
  1000bb3b  MOV ECX,dword ptr [EAX + 0xc]
  1000bb3e  TEST CL,0x83
  1000bb41  JZ 0x1000bb73    ; LAB_1000bb73
  1000bb43  CMP dword ptr [ESP + 0x10],0x1
  1000bb48  JNZ 0x1000bb59    ; LAB_1000bb59
  1000bb4a  PUSH EAX
  1000bb4b  CALL 0x1000ba7e    ; FUN_1000ba7e
  1000bb50  CMP EAX,-0x1
  1000bb53  POP ECX
  1000bb54  JZ 0x1000bb73    ; LAB_1000bb73
  1000bb56  INC EBX
  1000bb57  JMP 0x1000bb73    ; LAB_1000bb73
LAB_1000bb59:
  1000bb59  CMP dword ptr [ESP + 0x10],0x0
  1000bb5e  JNZ 0x1000bb73    ; LAB_1000bb73
  1000bb60  TEST CL,0x2
  1000bb63  JZ 0x1000bb73    ; LAB_1000bb73
  1000bb65  PUSH EAX
  1000bb66  CALL 0x1000ba7e    ; FUN_1000ba7e
  1000bb6b  CMP EAX,-0x1
  1000bb6e  POP ECX
  1000bb6f  JNZ 0x1000bb73    ; LAB_1000bb73
  1000bb71  OR EDI,EAX
LAB_1000bb73:
  1000bb73  INC ESI
  1000bb74  CMP ESI,dword ptr [0x10010a80]    ; DAT_10010a80
  1000bb7a  JL 0x1000bb2f    ; LAB_1000bb2f
LAB_1000bb7c:
  1000bb7c  CMP dword ptr [ESP + 0x10],0x1
  1000bb81  MOV EAX,EBX
  1000bb83  JZ 0x1000bb87    ; LAB_1000bb87
  1000bb85  MOV EAX,EDI
LAB_1000bb87:
  1000bb87  POP EDI
  1000bb88  POP ESI
  1000bb89  POP EBX
  1000bb8a  RET

;==== FUNCTION FUN_1000bb8b @ 1000bb8b : int FUN_1000bb8b(int param_1, int param_2)
  1000bb8b  PUSH EBP
  1000bb8c  MOV EBP,ESP
  1000bb8e  PUSH ESI
  1000bb8f  PUSH EDI
  1000bb90  MOV EDI,dword ptr [EBP + 0xc]
  1000bb93  CMP EDI,0x4
  1000bb96  JZ 0x1000bc55    ; LAB_1000bc55
  1000bb9c  CMP EDI,0x3
  1000bb9f  JZ 0x1000bc55    ; LAB_1000bc55
  1000bba5  MOV ESI,dword ptr [EBP + 0x8]
  1000bba8  CMP ESI,0x2
  1000bbab  JZ 0x1000bc0b    ; LAB_1000bc0b
  1000bbad  CMP ESI,0x15
  1000bbb0  JZ 0x1000bc0b    ; LAB_1000bc0b
  1000bbb2  CMP ESI,0x16
  1000bbb5  JZ 0x1000bc06    ; LAB_1000bc06
  1000bbb7  CMP ESI,0xf
  1000bbba  JZ 0x1000bc06    ; LAB_1000bc06
  1000bbbc  CMP ESI,0x8
  1000bbbf  JZ 0x1000bbcf    ; LAB_1000bbcf
  1000bbc1  CMP ESI,0x4
  1000bbc4  JZ 0x1000bbcf    ; LAB_1000bbcf
  1000bbc6  CMP ESI,0xb
  1000bbc9  JNZ 0x1000bc55    ; LAB_1000bc55
LAB_1000bbcf:
  1000bbcf  PUSH ESI
  1000bbd0  CALL 0x1000bdfc    ; FUN_1000bdfc
  1000bbd5  TEST EAX,EAX
  1000bbd7  POP ECX
  1000bbd8  JZ 0x1000bc55    ; LAB_1000bc55
  1000bbda  MOV ECX,dword ptr [EAX + 0x8]
LAB_1000bbdd:
  1000bbdd  CMP dword ptr [EAX + 0x4],ESI
  1000bbe0  JNZ 0x1000bc93    ; LAB_1000bc93
  1000bbe6  MOV dword ptr [EAX + 0x8],EDI
  1000bbe9  MOV EDX,dword ptr [0x1000f180]    ; DAT_1000f180
  1000bbef  ADD EAX,0xc
  1000bbf2  LEA EDX,[EDX + EDX*0x2]
  1000bbf5  LEA EDX,[EDX*0x4 + 0x1000f100]    ; DAT_1000f178
  1000bbfc  CMP EAX,EDX
  1000bbfe  JNC 0x1000bc93    ; LAB_1000bc93
  1000bc04  JMP 0x1000bbdd    ; LAB_1000bbdd
LAB_1000bc06:
  1000bc06  CMP ESI,0x15
  1000bc09  JNZ 0x1000bc2b    ; LAB_1000bc2b
LAB_1000bc0b:
  1000bc0b  CMP dword ptr [0x1000f834],0x0    ; DAT_1000f834
  1000bc12  JNZ 0x1000bc2b    ; LAB_1000bc2b
  1000bc14  PUSH 0x1
  1000bc16  PUSH 0x1000bc97    ; LAB_1000bc97
  1000bc1b  CALL dword ptr [0x1000d0cc]    ; PTR_SetConsoleCtrlHandler_1000d0cc KERNEL32.DLL::SetConsoleCtrlHandler
  1000bc21  CMP EAX,0x1
  1000bc24  JNZ 0x1000bc4a    ; LAB_1000bc4a
  1000bc26  MOV [0x1000f834],EAX    ; DAT_1000f834
LAB_1000bc2b:
  1000bc2b  DEC ESI
  1000bc2c  DEC ESI
  1000bc2d  JZ 0x1000bc82    ; LAB_1000bc82
  1000bc2f  SUB ESI,0xd
  1000bc32  JZ 0x1000bc74    ; LAB_1000bc74
  1000bc34  SUB ESI,0x6
  1000bc37  JZ 0x1000bc66    ; LAB_1000bc66
  1000bc39  DEC ESI
  1000bc3a  JNZ 0x1000bc90    ; LAB_1000bc90
  1000bc3c  MOV ECX,dword ptr [0x1000f82c]    ; DAT_1000f82c
  1000bc42  MOV dword ptr [0x1000f82c],EDI    ; DAT_1000f82c
  1000bc48  JMP 0x1000bc93    ; LAB_1000bc93
LAB_1000bc4a:
  1000bc4a  CALL dword ptr [0x1000d08c]    ; PTR_GetLastError_1000d08c KERNEL32.DLL::GetLastError
  1000bc50  MOV [0x1000f650],EAX    ; DAT_1000f650
LAB_1000bc55:
  1000bc55  MOV dword ptr [0x1000f64c],0x16    ; DAT_1000f64c
  1000bc5f  OR EAX,0xffffffff
LAB_1000bc62:
  1000bc62  POP EDI
  1000bc63  POP ESI
  1000bc64  POP EBP
  1000bc65  RET
LAB_1000bc66:
  1000bc66  MOV ECX,dword ptr [0x1000f828]    ; DAT_1000f828
  1000bc6c  MOV dword ptr [0x1000f828],EDI    ; DAT_1000f828
  1000bc72  JMP 0x1000bc93    ; LAB_1000bc93
LAB_1000bc74:
  1000bc74  MOV ECX,dword ptr [0x1000f830]    ; DAT_1000f830
  1000bc7a  MOV dword ptr [0x1000f830],EDI    ; DAT_1000f830
  1000bc80  JMP 0x1000bc93    ; LAB_1000bc93
LAB_1000bc82:
  1000bc82  MOV ECX,dword ptr [0x1000f824]    ; DAT_1000f824
  1000bc88  MOV dword ptr [0x1000f824],EDI    ; DAT_1000f824
  1000bc8e  JMP 0x1000bc93    ; LAB_1000bc93
LAB_1000bc90:
  1000bc90  MOV ECX,dword ptr [EBP + 0xc]
LAB_1000bc93:
  1000bc93  MOV EAX,ECX
  1000bc95  JMP 0x1000bc62    ; LAB_1000bc62
LAB_1000bc97:
  1000bc97  CMP dword ptr [ESP + 0x4],0x0
  1000bc9c  JNZ 0x1000bcac    ; LAB_1000bcac
  1000bc9e  MOV EAX,[0x1000f824]    ; DAT_1000f824
  1000bca3  MOV ECX,0x1000f824    ; DAT_1000f824
  1000bca8  PUSH 0x2
  1000bcaa  JMP 0x1000bcb8    ; LAB_1000bcb8
LAB_1000bcac:
  1000bcac  MOV EAX,[0x1000f828]    ; DAT_1000f828
  1000bcb1  MOV ECX,0x1000f828    ; DAT_1000f828
  1000bcb6  PUSH 0x15
LAB_1000bcb8:
  1000bcb8  TEST EAX,EAX
  1000bcba  POP EDX
  1000bcbb  JZ 0x1000bccc    ; LAB_1000bccc
  1000bcbd  CMP EAX,0x1
  1000bcc0  JZ 0x1000bcc9    ; LAB_1000bcc9
  1000bcc2  AND dword ptr [ECX],0x0    ; DAT_1000f824 DAT_1000f828
  1000bcc5  PUSH EDX
  1000bcc6  CALL EAX
  1000bcc8  POP ECX
LAB_1000bcc9:
  1000bcc9  PUSH 0x1
  1000bccb  POP EAX
LAB_1000bccc:
  1000bccc  RET 0x4

;==== FUNCTION FUN_1000bccf @ 1000bccf : undefined4 FUN_1000bccf(int param_1)
  1000bccf  PUSH EBP
  1000bcd0  MOV EBP,ESP
  1000bcd2  PUSH ESI
  1000bcd3  PUSH EDI
  1000bcd4  MOV EDI,dword ptr [EBP + 0x8]
  1000bcd7  MOV EAX,EDI
  1000bcd9  DEC EAX
  1000bcda  DEC EAX
  1000bcdb  JZ 0x1000bd36    ; LAB_1000bd36
  1000bcdd  DEC EAX
  1000bcde  DEC EAX
  1000bcdf  JZ 0x1000bd27    ; LAB_1000bd27
  1000bce1  SUB EAX,0x4
  1000bce4  JZ 0x1000bd27    ; LAB_1000bd27
  1000bce6  SUB EAX,0x3
  1000bce9  JZ 0x1000bd27    ; LAB_1000bd27
  1000bceb  SUB EAX,0x4
  1000bcee  JZ 0x1000bd1a    ; LAB_1000bd1a
  1000bcf0  SUB EAX,0x6
  1000bcf3  JZ 0x1000bd0d    ; LAB_1000bd0d
  1000bcf5  DEC EAX
  1000bcf6  JZ 0x1000bd00    ; LAB_1000bd00
  1000bcf8  OR EAX,0xffffffff
  1000bcfb  JMP 0x1000bdf8    ; LAB_1000bdf8
LAB_1000bd00:
  1000bd00  MOV ESI,dword ptr [0x1000f82c]    ; DAT_1000f82c
  1000bd06  MOV EAX,0x1000f82c    ; DAT_1000f82c
  1000bd0b  JMP 0x1000bd41    ; LAB_1000bd41
LAB_1000bd0d:
  1000bd0d  MOV ESI,dword ptr [0x1000f828]    ; DAT_1000f828
  1000bd13  MOV EAX,0x1000f828    ; DAT_1000f828
  1000bd18  JMP 0x1000bd41    ; LAB_1000bd41
LAB_1000bd1a:
  1000bd1a  MOV ESI,dword ptr [0x1000f830]    ; DAT_1000f830
  1000bd20  MOV EAX,0x1000f830    ; DAT_1000f830
  1000bd25  JMP 0x1000bd41    ; LAB_1000bd41
LAB_1000bd27:
  1000bd27  PUSH EDI
  1000bd28  CALL 0x1000bdfc    ; FUN_1000bdfc
  1000bd2d  MOV ESI,dword ptr [EAX + 0x8]
  1000bd30  ADD EAX,0x8
  1000bd33  POP ECX
  1000bd34  JMP 0x1000bd41    ; LAB_1000bd41
LAB_1000bd36:
  1000bd36  MOV ESI,dword ptr [0x1000f824]    ; DAT_1000f824
  1000bd3c  MOV EAX,0x1000f824    ; DAT_1000f824
LAB_1000bd41:
  1000bd41  CMP ESI,0x1
  1000bd44  JNZ 0x1000bd4d    ; LAB_1000bd4d
  1000bd46  XOR EAX,EAX
  1000bd48  JMP 0x1000bdf8    ; LAB_1000bdf8
LAB_1000bd4d:
  1000bd4d  TEST ESI,ESI
  1000bd4f  JNZ 0x1000bd58    ; LAB_1000bd58
  1000bd51  PUSH 0x3
  1000bd53  CALL 0x100071e2    ; __exit
LAB_1000bd58:
  1000bd58  PUSH EBX
  1000bd59  PUSH 0x8
  1000bd5b  POP ECX
  1000bd5c  CMP EDI,ECX
  1000bd5e  JZ 0x1000bd6a    ; LAB_1000bd6a
  1000bd60  CMP EDI,0xb
  1000bd63  JZ 0x1000bd6a    ; LAB_1000bd6a
  1000bd65  CMP EDI,0x4
  1000bd68  JNZ 0x1000bd90    ; LAB_1000bd90
LAB_1000bd6a:
  1000bd6a  MOV EBX,dword ptr [0x1000f7fc]    ; DAT_1000f7fc
  1000bd70  AND dword ptr [0x1000f7fc],0x0    ; DAT_1000f7fc
  1000bd77  CMP EDI,ECX
  1000bd79  JNZ 0x1000bdbf    ; LAB_1000bdbf
  1000bd7b  MOV EDX,dword ptr [0x1000f184]    ; DAT_1000f184
  1000bd81  MOV dword ptr [0x1000f184],0x8c    ; DAT_1000f184
  1000bd8b  MOV dword ptr [EBP + 0x8],EDX
  1000bd8e  JMP 0x1000bd93    ; LAB_1000bd93
LAB_1000bd90:
  1000bd90  MOV EBX,dword ptr [EBP + 0x8]
LAB_1000bd93:
  1000bd93  CMP EDI,ECX
  1000bd95  JNZ 0x1000bdbf    ; LAB_1000bdbf
  1000bd97  MOV EAX,[0x1000f178]    ; DAT_1000f178
  1000bd9c  MOV ECX,dword ptr [0x1000f17c]    ; DAT_1000f17c
  1000bda2  ADD ECX,EAX
  1000bda4  CMP EAX,ECX
  1000bda6  JGE 0x1000bdc6    ; LAB_1000bdc6
  1000bda8  LEA EDX,[EAX + EAX*0x2]
  1000bdab  SUB ECX,EAX
  1000bdad  LEA EDX,[EDX*0x4 + 0x1000f108]    ; DAT_1000f12c
LAB_1000bdb4:
  1000bdb4  AND dword ptr [EDX],0x0    ; DAT_1000f12c DAT_1000f138
  1000bdb7  ADD EDX,0xc
  1000bdba  DEC ECX
  1000bdbb  JNZ 0x1000bdb4    ; LAB_1000bdb4
  1000bdbd  JMP 0x1000bdc6    ; LAB_1000bdc6
LAB_1000bdbf:
  1000bdbf  AND dword ptr [EAX],0x0    ; DAT_1000f82c
  1000bdc2  CMP EDI,ECX
  1000bdc4  JNZ 0x1000bdd4    ; LAB_1000bdd4
LAB_1000bdc6:
  1000bdc6  PUSH dword ptr [0x1000f184]    ; DAT_1000f184
  1000bdcc  PUSH 0x8
  1000bdce  CALL ESI
  1000bdd0  POP ECX
  1000bdd1  POP ECX
  1000bdd2  JMP 0x1000bde2    ; LAB_1000bde2
LAB_1000bdd4:
  1000bdd4  PUSH EDI
  1000bdd5  CALL ESI
  1000bdd7  CMP EDI,0xb
  1000bdda  POP ECX
  1000bddb  JZ 0x1000bde2    ; LAB_1000bde2
  1000bddd  CMP EDI,0x4
  1000bde0  JNZ 0x1000bdf5    ; LAB_1000bdf5
LAB_1000bde2:
  1000bde2  CMP EDI,0x8
  1000bde5  MOV dword ptr [0x1000f7fc],EBX    ; DAT_1000f7fc
  1000bdeb  JNZ 0x1000bdf5    ; LAB_1000bdf5
  1000bded  MOV EAX,dword ptr [EBP + 0x8]
  1000bdf0  MOV [0x1000f184],EAX    ; DAT_1000f184
LAB_1000bdf5:
  1000bdf5  XOR EAX,EAX
  1000bdf7  POP EBX
LAB_1000bdf8:
  1000bdf8  POP EDI
  1000bdf9  POP ESI
  1000bdfa  POP EBP
  1000bdfb  RET

;==== FUNCTION FUN_1000bdfc @ 1000bdfc : undefined4 * FUN_1000bdfc(int param_1)
  1000bdfc  MOV EDX,dword ptr [ESP + 0x4]
  1000be00  MOV ECX,dword ptr [0x1000f180]    ; DAT_1000f180
  1000be06  CMP dword ptr [0x1000f104],EDX    ; DAT_1000f104
  1000be0c  PUSH ESI
  1000be0d  MOV EAX,0x1000f100    ; DAT_1000f100
  1000be12  JZ 0x1000be2a    ; LAB_1000be2a
  1000be14  LEA ESI,[ECX + ECX*0x2]
  1000be17  LEA ESI,[ESI*0x4 + 0x1000f100]    ; DAT_1000f178
LAB_1000be1e:
  1000be1e  ADD EAX,0xc    ; DAT_1000f10c
  1000be21  CMP EAX,ESI
  1000be23  JNC 0x1000be2a    ; LAB_1000be2a
  1000be25  CMP dword ptr [EAX + 0x4],EDX    ; DAT_1000f110 DAT_1000f11c
  1000be28  JNZ 0x1000be1e    ; LAB_1000be1e
LAB_1000be2a:
  1000be2a  LEA ECX,[ECX + ECX*0x2]
  1000be2d  POP ESI
  1000be2e  LEA ECX,[ECX*0x4 + 0x1000f100]    ; DAT_1000f178
  1000be35  CMP EAX,ECX
  1000be37  JNC 0x1000be3e    ; LAB_1000be3e
  1000be39  CMP dword ptr [EAX + 0x4],EDX    ; DAT_1000f110 DAT_1000f11c DAT_1000f104
  1000be3c  JZ 0x1000be40    ; LAB_1000be40
LAB_1000be3e:
  1000be3e  XOR EAX,EAX
LAB_1000be40:
  1000be40  RET

;==== FUNCTION FUN_1000be41 @ 1000be41 : undefined FUN_1000be41(int * param_1, int * param_2)
  1000be41  PUSH EBP
  1000be42  MOV EBP,ESP
  1000be44  SUB ESP,0x24
  1000be47  PUSH EBX
  1000be48  MOV EBX,dword ptr [EBP + 0xc]
  1000be4b  PUSH ESI
  1000be4c  MOV ESI,dword ptr [EBP + 0x8]
  1000be4f  MOV CX,word ptr [EBX + 0xa]
  1000be53  XOR EAX,EAX
  1000be55  PUSH EDI
  1000be56  MOV dword ptr [EBP + -0x14],EAX
  1000be59  MOV dword ptr [EBP + -0x24],EAX
  1000be5c  MOV dword ptr [EBP + -0x20],EAX
  1000be5f  MOV dword ptr [EBP + -0x1c],EAX
  1000be62  MOV AX,word ptr [ESI + 0xa]
  1000be66  MOV EDI,ECX
  1000be68  MOV EDX,0x7fff
  1000be6d  XOR EDI,EAX
  1000be6f  AND EAX,EDX
  1000be71  AND ECX,EDX
  1000be73  AND EDI,0x8000
  1000be79  CMP AX,0x7fff
  1000be7d  LEA EDX,[ECX + EAX*0x1]
  1000be80  MOV dword ptr [EBP + 0x8],EDX
  1000be83  JNC 0x1000c041    ; LAB_1000c041
  1000be89  CMP CX,0x7fff
  1000be8e  JNC 0x1000c041    ; LAB_1000c041
  1000be94  CMP DX,0xbffd
  1000be99  JA 0x1000c041    ; LAB_1000c041
  1000be9f  CMP DX,0x3fbf
  1000bea4  JA 0x1000beaa    ; LAB_1000beaa
  1000bea6  XOR EAX,EAX
  1000bea8  JMP 0x1000bee4    ; LAB_1000bee4
LAB_1000beaa:
  1000beaa  TEST AX,AX
  1000bead  MOV EDX,0x7fffffff
  1000beb2  JNZ 0x1000becc    ; LAB_1000becc
  1000beb4  INC dword ptr [EBP + 0x8]
  1000beb7  TEST dword ptr [ESI + 0x8],EDX
  1000beba  JNZ 0x1000becc    ; LAB_1000becc
  1000bebc  XOR EAX,EAX
  1000bebe  CMP dword ptr [ESI + 0x4],EAX
  1000bec1  JNZ 0x1000bece    ; LAB_1000bece
  1000bec3  CMP dword ptr [ESI],EAX
  1000bec5  JNZ 0x1000bece    ; LAB_1000bece
  1000bec7  JMP 0x1000c03b    ; LAB_1000c03b
LAB_1000becc:
  1000becc  XOR EAX,EAX
LAB_1000bece:
  1000bece  CMP CX,AX
  1000bed1  JNZ 0x1000bef1    ; LAB_1000bef1
  1000bed3  INC dword ptr [EBP + 0x8]
  1000bed6  TEST dword ptr [EBX + 0x8],EDX
  1000bed9  JNZ 0x1000bef1    ; LAB_1000bef1
  1000bedb  CMP dword ptr [EBX + 0x4],EAX
  1000bede  JNZ 0x1000bef1    ; LAB_1000bef1
  1000bee0  CMP dword ptr [EBX],EAX
  1000bee2  JNZ 0x1000bef1    ; LAB_1000bef1
LAB_1000bee4:
  1000bee4  MOV dword ptr [ESI + 0x8],EAX
  1000bee7  MOV dword ptr [ESI + 0x4],EAX
  1000beea  MOV dword ptr [ESI],EAX
  1000beec  JMP 0x1000c05c    ; LAB_1000c05c
LAB_1000bef1:
  1000bef1  MOV dword ptr [EBP + -0x10],EAX
  1000bef4  LEA EAX,[EBP + -0x20]
  1000bef7  MOV dword ptr [EBP + -0x4],EAX
  1000befa  MOV dword ptr [EBP + 0xc],0x5
LAB_1000bf01:
  1000bf01  MOV EAX,dword ptr [EBP + -0x10]
  1000bf04  ADD EAX,EAX
  1000bf06  CMP dword ptr [EBP + 0xc],0x0
  1000bf0a  JLE 0x1000bf55    ; LAB_1000bf55
  1000bf0c  ADD EAX,ESI
  1000bf0e  LEA ECX,[EBX + 0x8]
  1000bf11  MOV dword ptr [EBP + -0x8],EAX
  1000bf14  MOV EAX,dword ptr [EBP + 0xc]
  1000bf17  MOV dword ptr [EBP + -0xc],ECX
  1000bf1a  MOV dword ptr [EBP + -0x18],EAX
LAB_1000bf1d:
  1000bf1d  MOV EAX,dword ptr [EBP + -0x8]
  1000bf20  MOV ECX,dword ptr [EBP + -0xc]
  1000bf23  MOVZX EAX,word ptr [EAX]
  1000bf26  MOVZX ECX,word ptr [ECX]
  1000bf29  IMUL EAX,ECX
  1000bf2c  MOV ECX,dword ptr [EBP + -0x4]
  1000bf2f  ADD ECX,-0x4
  1000bf32  PUSH ECX
  1000bf33  PUSH EAX
  1000bf34  PUSH dword ptr [ECX]
  1000bf36  CALL 0x1000ada1    ; FUN_1000ada1
  1000bf3b  ADD ESP,0xc
  1000bf3e  TEST EAX,EAX
  1000bf40  JZ 0x1000bf48    ; LAB_1000bf48
  1000bf42  MOV EAX,dword ptr [EBP + -0x4]
  1000bf45  INC word ptr [EAX]
LAB_1000bf48:
  1000bf48  ADD dword ptr [EBP + -0x8],0x2
  1000bf4c  SUB dword ptr [EBP + -0xc],0x2
  1000bf50  DEC dword ptr [EBP + -0x18]
  1000bf53  JNZ 0x1000bf1d    ; LAB_1000bf1d
LAB_1000bf55:
  1000bf55  ADD dword ptr [EBP + -0x4],0x2
  1000bf59  INC dword ptr [EBP + -0x10]
  1000bf5c  DEC dword ptr [EBP + 0xc]
  1000bf5f  CMP dword ptr [EBP + 0xc],0x0
  1000bf63  JG 0x1000bf01    ; LAB_1000bf01
  1000bf65  ADD dword ptr [EBP + 0x8],0xc002
  1000bf6c  CMP word ptr [EBP + 0x8],0x0
  1000bf71  JLE 0x1000bf98    ; LAB_1000bf98
LAB_1000bf73:
  1000bf73  TEST byte ptr [EBP + -0x19],0x80
  1000bf77  JNZ 0x1000bf91    ; LAB_1000bf91
  1000bf79  LEA EAX,[EBP + -0x24]
  1000bf7c  PUSH EAX
  1000bf7d  CALL 0x1000ae20    ; FUN_1000ae20
  1000bf82  ADD dword ptr [EBP + 0x8],0xffff
  1000bf89  POP ECX
  1000bf8a  CMP word ptr [EBP + 0x8],0x0
  1000bf8f  JG 0x1000bf73    ; LAB_1000bf73
LAB_1000bf91:
  1000bf91  CMP word ptr [EBP + 0x8],0x0
  1000bf96  JG 0x1000bfd1    ; LAB_1000bfd1
LAB_1000bf98:
  1000bf98  ADD dword ptr [EBP + 0x8],0xffff
  1000bf9f  CMP word ptr [EBP + 0x8],0x0
  1000bfa4  JGE 0x1000bfd1    ; LAB_1000bfd1
  1000bfa6  MOVSX EAX,word ptr [EBP + 0x8]
  1000bfaa  NEG EAX
  1000bfac  ADD dword ptr [EBP + 0x8],EAX
  1000bfaf  MOV EBX,EAX
LAB_1000bfb1:
  1000bfb1  TEST byte ptr [EBP + -0x24],0x1
  1000bfb5  JZ 0x1000bfba    ; LAB_1000bfba
  1000bfb7  INC dword ptr [EBP + -0x14]
LAB_1000bfba:
  1000bfba  LEA EAX,[EBP + -0x24]
  1000bfbd  PUSH EAX
  1000bfbe  CALL 0x1000ae4e    ; FUN_1000ae4e
  1000bfc3  DEC EBX
  1000bfc4  POP ECX
  1000bfc5  JNZ 0x1000bfb1    ; LAB_1000bfb1
  1000bfc7  CMP dword ptr [EBP + -0x14],0x0
  1000bfcb  JZ 0x1000bfd1    ; LAB_1000bfd1
  1000bfcd  OR byte ptr [EBP + -0x24],0x1
LAB_1000bfd1:
  1000bfd1  CMP word ptr [EBP + -0x24],0x8000
  1000bfd7  JA 0x1000bfe8    ; LAB_1000bfe8
  1000bfd9  MOV EAX,dword ptr [EBP + -0x24]
  1000bfdc  AND EAX,0x1ffff
  1000bfe1  CMP EAX,0x18000
  1000bfe6  JNZ 0x1000c01d    ; LAB_1000c01d
LAB_1000bfe8:
  1000bfe8  CMP dword ptr [EBP + -0x22],-0x1
  1000bfec  JNZ 0x1000c01a    ; LAB_1000c01a
  1000bfee  AND dword ptr [EBP + -0x22],0x0
  1000bff2  CMP dword ptr [EBP + -0x1e],-0x1
  1000bff6  JNZ 0x1000c015    ; LAB_1000c015
  1000bff8  AND dword ptr [EBP + -0x1e],0x0
  1000bffc  CMP word ptr [EBP + -0x1a],0xffff
  1000c002  JNZ 0x1000c00f    ; LAB_1000c00f
  1000c004  INC dword ptr [EBP + 0x8]
  1000c007  MOV word ptr [EBP + -0x1a],0x8000
  1000c00d  JMP 0x1000c01d    ; LAB_1000c01d
LAB_1000c00f:
  1000c00f  INC word ptr [EBP + -0x1a]
  1000c013  JMP 0x1000c01d    ; LAB_1000c01d
LAB_1000c015:
  1000c015  INC dword ptr [EBP + -0x1e]
  1000c018  JMP 0x1000c01d    ; LAB_1000c01d
LAB_1000c01a:
  1000c01a  INC dword ptr [EBP + -0x22]
LAB_1000c01d:
  1000c01d  MOV EAX,dword ptr [EBP + 0x8]
  1000c020  CMP AX,0x7fff
  1000c024  JNC 0x1000c041    ; LAB_1000c041
  1000c026  MOV CX,word ptr [EBP + -0x22]
  1000c02a  OR EAX,EDI
  1000c02c  MOV word ptr [ESI],CX
  1000c02f  MOV ECX,dword ptr [EBP + -0x20]
  1000c032  MOV dword ptr [ESI + 0x2],ECX
  1000c035  MOV ECX,dword ptr [EBP + -0x1c]
  1000c038  MOV dword ptr [ESI + 0x6],ECX
LAB_1000c03b:
  1000c03b  MOV word ptr [ESI + 0xa],AX
  1000c03f  JMP 0x1000c05c    ; LAB_1000c05c
LAB_1000c041:
  1000c041  NEG DI
  1000c044  SBB EDI,EDI
  1000c046  AND dword ptr [ESI + 0x4],0x0
  1000c04a  AND EDI,0x80000000
  1000c050  ADD EDI,0x7fff8000
  1000c056  AND dword ptr [ESI],0x0
  1000c059  MOV dword ptr [ESI + 0x8],EDI
LAB_1000c05c:
  1000c05c  POP EDI
  1000c05d  POP ESI
  1000c05e  POP EBX
  1000c05f  LEAVE
  1000c060  RET

;==== FUNCTION FUN_1000c061 @ 1000c061 : undefined FUN_1000c061(int * param_1, uint param_2, int param_3)
  1000c061  PUSH EBP
  1000c062  MOV EBP,ESP
  1000c064  SUB ESP,0xc
  1000c067  PUSH EBX
  1000c068  MOV EBX,0x1000f2f0    ; DAT_1000f2f0
  1000c06d  XOR ECX,ECX
  1000c06f  SUB EBX,0x60
  1000c072  CMP dword ptr [EBP + 0xc],ECX
  1000c075  JZ 0x1000c0da    ; LAB_1000c0da
  1000c077  JGE 0x1000c089    ; LAB_1000c089
  1000c079  MOV EAX,dword ptr [EBP + 0xc]
  1000c07c  MOV EBX,0x1000f450    ; DAT_1000f450
  1000c081  NEG EAX
  1000c083  MOV dword ptr [EBP + 0xc],EAX
  1000c086  SUB EBX,0x60
LAB_1000c089:
  1000c089  CMP dword ptr [EBP + 0x10],ECX
  1000c08c  JNZ 0x1000c094    ; LAB_1000c094
  1000c08e  MOV EAX,dword ptr [EBP + 0x8]
  1000c091  MOV word ptr [EAX],CX
LAB_1000c094:
  1000c094  CMP dword ptr [EBP + 0xc],ECX
  1000c097  JZ 0x1000c0da    ; LAB_1000c0da
  1000c099  PUSH ESI
  1000c09a  PUSH EDI
LAB_1000c09b:
  1000c09b  MOV EAX,dword ptr [EBP + 0xc]
  1000c09e  ADD EBX,0x54
  1000c0a1  SAR dword ptr [EBP + 0xc],0x3
  1000c0a5  AND EAX,0x7
  1000c0a8  CMP EAX,ECX
  1000c0aa  JZ 0x1000c0d3    ; LAB_1000c0d3
  1000c0ac  LEA EAX,[EAX + EAX*0x2]
  1000c0af  CMP word ptr [EBX + EAX*0x4],0x8000    ; DAT_1000f444 DAT_1000f498 DAT_1000f2e4
  1000c0b5  LEA ESI,[EBX + EAX*0x4]
  1000c0b8  JC 0x1000c0c6    ; LAB_1000c0c6
  1000c0ba  LEA EDI,[EBP + -0xc]
  1000c0bd  MOVSD ES:EDI,ESI    ; DAT_1000f444 DAT_1000f498
  1000c0be  MOVSD ES:EDI,ESI    ; DAT_1000f448 DAT_1000f49c
  1000c0bf  MOVSD ES:EDI,ESI    ; DAT_1000f44c DAT_1000f4a0
  1000c0c0  DEC dword ptr [EBP + -0xa]
  1000c0c3  LEA ESI,[EBP + -0xc]
LAB_1000c0c6:
  1000c0c6  PUSH ESI
  1000c0c7  PUSH dword ptr [EBP + 0x8]
  1000c0ca  CALL 0x1000be41    ; FUN_1000be41
  1000c0cf  POP ECX
  1000c0d0  POP ECX
  1000c0d1  XOR ECX,ECX
LAB_1000c0d3:
  1000c0d3  CMP dword ptr [EBP + 0xc],ECX
  1000c0d6  JNZ 0x1000c09b    ; LAB_1000c09b
  1000c0d8  POP EDI
  1000c0d9  POP ESI
LAB_1000c0da:
  1000c0da  POP EBX
  1000c0db  LEAVE
  1000c0dc  RET

;==== FUNCTION FUN_1000c0dd @ 1000c0dd : undefined4 FUN_1000c0dd(int * param_1)
  1000c0dd  PUSH ESI
  1000c0de  MOV ESI,dword ptr [ESP + 0x8]
  1000c0e2  PUSH EDI
  1000c0e3  OR EDI,0xffffffff
  1000c0e6  MOV EAX,dword ptr [ESI + 0xc]
  1000c0e9  TEST AL,0x40
  1000c0eb  JZ 0x1000c0f2    ; LAB_1000c0f2
  1000c0ed  OR EAX,0xffffffff
  1000c0f0  JMP 0x1000c12c    ; LAB_1000c12c
LAB_1000c0f2:
  1000c0f2  TEST AL,0x83
  1000c0f4  JZ 0x1000c12a    ; LAB_1000c12a
  1000c0f6  PUSH ESI
  1000c0f7  CALL 0x1000bab9    ; FUN_1000bab9
  1000c0fc  PUSH ESI
  1000c0fd  MOV EDI,EAX
  1000c0ff  CALL 0x1000c23d    ; FUN_1000c23d
  1000c104  PUSH dword ptr [ESI + 0x10]
  1000c107  CALL 0x1000c18a    ; FUN_1000c18a
  1000c10c  ADD ESP,0xc
  1000c10f  TEST EAX,EAX
  1000c111  JGE 0x1000c118    ; LAB_1000c118
  1000c113  OR EDI,0xffffffff
  1000c116  JMP 0x1000c12a    ; LAB_1000c12a
LAB_1000c118:
  1000c118  MOV EAX,dword ptr [ESI + 0x1c]
  1000c11b  TEST EAX,EAX
  1000c11d  JZ 0x1000c12a    ; LAB_1000c12a
  1000c11f  PUSH EAX
  1000c120  CALL 0x10005e2a    ; FUN_10005e2a
  1000c125  AND dword ptr [ESI + 0x1c],0x0
  1000c129  POP ECX
LAB_1000c12a:
  1000c12a  MOV EAX,EDI
LAB_1000c12c:
  1000c12c  AND dword ptr [ESI + 0xc],0x0
  1000c130  POP EDI
  1000c131  POP ESI
  1000c132  RET

;==== FUNCTION FUN_1000c133 @ 1000c133 : undefined4 FUN_1000c133(uint param_1)
  1000c133  MOV EAX,dword ptr [ESP + 0x4]
  1000c137  CMP EAX,dword ptr [0x10010ba0]    ; DAT_10010ba0
  1000c13d  JNC 0x1000c17c    ; LAB_1000c17c
  1000c13f  MOV ECX,EAX
  1000c141  MOV EDX,EAX
  1000c143  SAR ECX,0x5
  1000c146  AND EDX,0x1f
  1000c149  MOV ECX,dword ptr [ECX*0x4 + 0x10010aa0]    ; DAT_10010aa0
  1000c150  TEST byte ptr [ECX + EDX*0x8 + 0x4],0x1
  1000c155  JZ 0x1000c17c    ; LAB_1000c17c
  1000c157  PUSH EAX
  1000c158  CALL 0x1000b8cf    ; FUN_1000b8cf
  1000c15d  POP ECX
  1000c15e  PUSH EAX
  1000c15f  CALL dword ptr [0x1000d0d0]    ; PTR_FlushFileBuffers_1000d0d0 KERNEL32.DLL::FlushFileBuffers
  1000c165  TEST EAX,EAX
  1000c167  JNZ 0x1000c171    ; LAB_1000c171
  1000c169  CALL dword ptr [0x1000d08c]    ; PTR_GetLastError_1000d08c KERNEL32.DLL::GetLastError
  1000c16f  JMP 0x1000c173    ; LAB_1000c173
LAB_1000c171:
  1000c171  XOR EAX,EAX
LAB_1000c173:
  1000c173  TEST EAX,EAX
  1000c175  JZ 0x1000c189    ; LAB_1000c189
  1000c177  MOV [0x1000f650],EAX    ; DAT_1000f650
LAB_1000c17c:
  1000c17c  MOV dword ptr [0x1000f64c],0x9    ; DAT_1000f64c
  1000c186  OR EAX,0xffffffff
LAB_1000c189:
  1000c189  RET

;==== FUNCTION FUN_1000c18a @ 1000c18a : undefined4 FUN_1000c18a(uint param_1)
  1000c18a  PUSH EBX
  1000c18b  PUSH EBP
  1000c18c  PUSH ESI
  1000c18d  PUSH EDI
  1000c18e  MOV EDI,dword ptr [ESP + 0x14]
  1000c192  CMP EDI,dword ptr [0x10010ba0]    ; DAT_10010ba0
  1000c198  JNC 0x1000c224    ; LAB_1000c224
  1000c19e  MOV EAX,EDI
  1000c1a0  MOV ESI,EDI
  1000c1a2  SAR EAX,0x5
  1000c1a5  AND ESI,0x1f
  1000c1a8  LEA EBX,[EAX*0x4 + 0x10010aa0]    ; DAT_10010aa0
  1000c1af  SHL ESI,0x3
  1000c1b2  MOV EAX,dword ptr [EBX]    ; DAT_10010aa0
  1000c1b4  TEST byte ptr [EAX + ESI*0x1 + 0x4],0x1
  1000c1b9  JZ 0x1000c224    ; LAB_1000c224
  1000c1bb  PUSH EDI
  1000c1bc  CALL 0x1000b8cf    ; FUN_1000b8cf
  1000c1c1  CMP EAX,-0x1
  1000c1c4  POP ECX
  1000c1c5  JZ 0x1000c203    ; LAB_1000c203
  1000c1c7  CMP EDI,0x1
  1000c1ca  JZ 0x1000c1d1    ; LAB_1000c1d1
  1000c1cc  CMP EDI,0x2
  1000c1cf  JNZ 0x1000c1e7    ; LAB_1000c1e7
LAB_1000c1d1:
  1000c1d1  PUSH 0x2
  1000c1d3  CALL 0x1000b8cf    ; FUN_1000b8cf
  1000c1d8  PUSH 0x1
  1000c1da  MOV EBP,EAX
  1000c1dc  CALL 0x1000b8cf    ; FUN_1000b8cf
  1000c1e1  POP ECX
  1000c1e2  CMP EAX,EBP
  1000c1e4  POP ECX
  1000c1e5  JZ 0x1000c203    ; LAB_1000c203
LAB_1000c1e7:
  1000c1e7  PUSH EDI
  1000c1e8  CALL 0x1000b8cf    ; FUN_1000b8cf
  1000c1ed  POP ECX
  1000c1ee  PUSH EAX
  1000c1ef  CALL dword ptr [0x1000d00c]    ; PTR_CloseHandle_1000d00c KERNEL32.DLL::CloseHandle
  1000c1f5  TEST EAX,EAX
  1000c1f7  JNZ 0x1000c203    ; LAB_1000c203
  1000c1f9  CALL dword ptr [0x1000d08c]    ; PTR_GetLastError_1000d08c KERNEL32.DLL::GetLastError
  1000c1ff  MOV EBP,EAX
  1000c201  JMP 0x1000c205    ; LAB_1000c205
LAB_1000c203:
  1000c203  XOR EBP,EBP
LAB_1000c205:
  1000c205  PUSH EDI
  1000c206  CALL 0x1000b855    ; FUN_1000b855
  1000c20b  MOV EAX,dword ptr [EBX]    ; DAT_10010aa0
  1000c20d  POP ECX
  1000c20e  AND byte ptr [EAX + ESI*0x1 + 0x4],0x0
  1000c213  TEST EBP,EBP
  1000c215  JZ 0x1000c220    ; LAB_1000c220
  1000c217  PUSH EBP
  1000c218  CALL 0x1000b6e2    ; FUN_1000b6e2
  1000c21d  POP ECX
  1000c21e  JMP 0x1000c235    ; LAB_1000c235
LAB_1000c220:
  1000c220  XOR EAX,EAX
  1000c222  JMP 0x1000c238    ; LAB_1000c238
LAB_1000c224:
  1000c224  AND dword ptr [0x1000f650],0x0    ; DAT_1000f650
  1000c22b  MOV dword ptr [0x1000f64c],0x9    ; DAT_1000f64c
LAB_1000c235:
  1000c235  OR EAX,0xffffffff
LAB_1000c238:
  1000c238  POP EDI
  1000c239  POP ESI
  1000c23a  POP EBP
  1000c23b  POP EBX
  1000c23c  RET

;==== FUNCTION FUN_1000c23d @ 1000c23d : undefined FUN_1000c23d(undefined4 * param_1)
  1000c23d  PUSH ESI
  1000c23e  MOV ESI,dword ptr [ESP + 0x8]
  1000c242  MOV EAX,dword ptr [ESI + 0xc]
  1000c245  TEST AL,0x83
  1000c247  JZ 0x1000c266    ; LAB_1000c266
  1000c249  TEST AL,0x8
  1000c24b  JZ 0x1000c266    ; LAB_1000c266
  1000c24d  PUSH dword ptr [ESI + 0x8]
  1000c250  CALL 0x10005e2a    ; FUN_10005e2a
  1000c255  AND word ptr [ESI + 0xc],0xfbf7
  1000c25b  XOR EAX,EAX
  1000c25d  POP ECX
  1000c25e  MOV dword ptr [ESI],EAX
  1000c260  MOV dword ptr [ESI + 0x8],EAX
  1000c263  MOV dword ptr [ESI + 0x4],EAX
LAB_1000c266:
  1000c266  POP ESI
  1000c267  RET

;==== FUNCTION RtlUnwind @ 1000c2a0 : void RtlUnwind(PVOID TargetFrame, PVOID TargetIp, PEXCEPTION_RECORD ExceptionRecord, PVOID ReturnValue)
  1000c2a0  JMP dword ptr [0x1000d020]    ; PTR_RtlUnwind_1000d020 KERNEL32.DLL::RtlUnwind

;==== FUNCTION FUN_1000c3ae @ 1000c3ae : char * FUN_1000c3ae(uint param_1, char * param_2, uint param_3)
  1000c3ae  PUSH EBP
  1000c3af  MOV EBP,ESP
  1000c3b1  CMP dword ptr [EBP + 0x10],0xa
  1000c3b5  JNZ 0x1000c3c3    ; LAB_1000c3c3
  1000c3b7  CMP dword ptr [EBP + 0x8],0x0
  1000c3bb  JGE 0x1000c3c3    ; LAB_1000c3c3
  1000c3bd  PUSH 0x1
  1000c3bf  PUSH 0xa
  1000c3c1  JMP 0x1000c3c8    ; LAB_1000c3c8
LAB_1000c3c3:
  1000c3c3  PUSH 0x0
  1000c3c5  PUSH dword ptr [EBP + 0x10]
LAB_1000c3c8:
  1000c3c8  PUSH dword ptr [EBP + 0xc]
  1000c3cb  PUSH dword ptr [EBP + 0x8]
  1000c3ce  CALL 0x1000c3db    ; FUN_1000c3db
  1000c3d3  MOV EAX,dword ptr [EBP + 0xc]
  1000c3d6  ADD ESP,0x10
  1000c3d9  POP EBP
  1000c3da  RET

;==== FUNCTION FUN_1000c3db @ 1000c3db : undefined FUN_1000c3db(uint param_1, char * param_2, uint param_3, int param_4)
  1000c3db  PUSH EBP
  1000c3dc  MOV EBP,ESP
  1000c3de  CMP dword ptr [EBP + 0x14],0x0
  1000c3e2  MOV ECX,dword ptr [EBP + 0xc]
  1000c3e5  PUSH EBX
  1000c3e6  PUSH ESI
  1000c3e7  PUSH EDI
  1000c3e8  JZ 0x1000c3f5    ; LAB_1000c3f5
  1000c3ea  MOV ESI,dword ptr [EBP + 0x8]
  1000c3ed  MOV byte ptr [ECX],0x2d
  1000c3f0  INC ECX
  1000c3f1  NEG ESI
  1000c3f3  JMP 0x1000c3f8    ; LAB_1000c3f8
LAB_1000c3f5:
  1000c3f5  MOV ESI,dword ptr [EBP + 0x8]
LAB_1000c3f8:
  1000c3f8  MOV EDI,ECX
LAB_1000c3fa:
  1000c3fa  MOV EAX,ESI
  1000c3fc  XOR EDX,EDX
  1000c3fe  DIV dword ptr [EBP + 0x10]
  1000c401  MOV EAX,ESI
  1000c403  MOV EBX,EDX
  1000c405  XOR EDX,EDX
  1000c407  DIV dword ptr [EBP + 0x10]
  1000c40a  CMP EBX,0x9
  1000c40d  MOV ESI,EAX
  1000c40f  JBE 0x1000c416    ; LAB_1000c416
  1000c411  ADD BL,0x57
  1000c414  JMP 0x1000c419    ; LAB_1000c419
LAB_1000c416:
  1000c416  ADD BL,0x30
LAB_1000c419:
  1000c419  MOV byte ptr [ECX],BL
  1000c41b  INC ECX
  1000c41c  TEST ESI,ESI
  1000c41e  JA 0x1000c3fa    ; LAB_1000c3fa
  1000c420  AND byte ptr [ECX],0x0
  1000c423  DEC ECX
LAB_1000c424:
  1000c424  MOV DL,byte ptr [EDI]
  1000c426  MOV AL,byte ptr [ECX]
  1000c428  MOV byte ptr [ECX],DL
  1000c42a  MOV byte ptr [EDI],AL
  1000c42c  DEC ECX
  1000c42d  INC EDI
  1000c42e  CMP EDI,ECX
  1000c430  JC 0x1000c424    ; LAB_1000c424
  1000c432  POP EDI
  1000c433  POP ESI
  1000c434  POP EBX
  1000c435  POP EBP
  1000c436  RET

;==== FUNCTION FUN_1000c437 @ 1000c437 : char * FUN_1000c437(uint param_1, char * param_2, uint param_3)
  1000c437  PUSH EBP
  1000c438  MOV EBP,ESP
  1000c43a  XOR EAX,EAX
  1000c43c  CMP dword ptr [EBP + 0x10],0xa
  1000c440  JNZ 0x1000c44a    ; LAB_1000c44a
  1000c442  CMP dword ptr [EBP + 0x8],EAX
  1000c445  JGE 0x1000c44a    ; LAB_1000c44a
  1000c447  PUSH 0x1
  1000c449  POP EAX
LAB_1000c44a:
  1000c44a  PUSH EAX
  1000c44b  PUSH dword ptr [EBP + 0x10]
  1000c44e  PUSH dword ptr [EBP + 0xc]
  1000c451  PUSH dword ptr [EBP + 0x8]
  1000c454  CALL 0x1000c3db    ; FUN_1000c3db
  1000c459  MOV EAX,dword ptr [EBP + 0xc]
  1000c45c  ADD ESP,0x10
  1000c45f  POP EBP
  1000c460  RET

;==== FUNCTION FUN_1000c47c @ 1000c47c : char * FUN_1000c47c(int param_1, int param_2, char * param_3, uint param_4)
  1000c47c  PUSH EBP
  1000c47d  MOV EBP,ESP
  1000c47f  XOR EAX,EAX
  1000c481  CMP dword ptr [EBP + 0x14],0xa
  1000c485  JNZ 0x1000c496    ; LAB_1000c496
  1000c487  CMP dword ptr [EBP + 0xc],EAX
  1000c48a  JG 0x1000c496    ; LAB_1000c496
  1000c48c  JL 0x1000c493    ; LAB_1000c493
  1000c48e  CMP dword ptr [EBP + 0x8],EAX
  1000c491  JNC 0x1000c496    ; LAB_1000c496
LAB_1000c493:
  1000c493  PUSH 0x1
  1000c495  POP EAX
LAB_1000c496:
  1000c496  PUSH EAX
  1000c497  PUSH dword ptr [EBP + 0x14]
  1000c49a  PUSH dword ptr [EBP + 0x10]
  1000c49d  PUSH dword ptr [EBP + 0xc]
  1000c4a0  PUSH dword ptr [EBP + 0x8]
  1000c4a3  CALL 0x1000c4ad    ; FUN_1000c4ad
  1000c4a8  MOV EAX,dword ptr [EBP + 0x10]
  1000c4ab  POP EBP
  1000c4ac  RET

;==== FUNCTION FUN_1000c4ad @ 1000c4ad : undefined FUN_1000c4ad(int param_1, int param_2, char * param_3, uint param_4, int param_5)
  1000c4ad  PUSH EBP
  1000c4ae  MOV EBP,ESP
  1000c4b0  CMP dword ptr [EBP + 0x18],0x0
  1000c4b4  PUSH EBX
  1000c4b5  PUSH ESI
  1000c4b6  MOV ESI,dword ptr [EBP + 0x10]
  1000c4b9  PUSH EDI
  1000c4ba  JZ 0x1000c4cf    ; LAB_1000c4cf
  1000c4bc  MOV EBX,dword ptr [EBP + 0x8]
  1000c4bf  MOV EDI,dword ptr [EBP + 0xc]
  1000c4c2  MOV byte ptr [ESI],0x2d
  1000c4c5  INC ESI
  1000c4c6  NEG EBX
  1000c4c8  ADC EDI,0x0
  1000c4cb  NEG EDI
  1000c4cd  JMP 0x1000c4d5    ; LAB_1000c4d5
LAB_1000c4cf:
  1000c4cf  MOV EDI,dword ptr [EBP + 0xc]
  1000c4d2  MOV EBX,dword ptr [EBP + 0x8]
LAB_1000c4d5:
  1000c4d5  MOV dword ptr [EBP + 0x10],ESI
LAB_1000c4d8:
  1000c4d8  XOR EAX,EAX
  1000c4da  PUSH EAX
  1000c4db  PUSH dword ptr [EBP + 0x14]
  1000c4de  PUSH EDI
  1000c4df  PUSH EBX
  1000c4e0  CALL 0x10009d20    ; __aullrem
  1000c4e5  MOV dword ptr [EBP + 0x18],EAX
  1000c4e8  XOR EAX,EAX
  1000c4ea  PUSH EAX
  1000c4eb  PUSH dword ptr [EBP + 0x14]
  1000c4ee  PUSH EDI
  1000c4ef  PUSH EBX
  1000c4f0  CALL 0x10009cb0    ; __aulldiv
  1000c4f5  MOV EBX,EAX
  1000c4f7  MOV EAX,dword ptr [EBP + 0x18]
  1000c4fa  CMP EAX,0x9
  1000c4fd  MOV EDI,EDX
  1000c4ff  JBE 0x1000c505    ; LAB_1000c505
  1000c501  ADD AL,0x57
  1000c503  JMP 0x1000c507    ; LAB_1000c507
LAB_1000c505:
  1000c505  ADD AL,0x30
LAB_1000c507:
  1000c507  MOV byte ptr [ESI],AL
  1000c509  INC ESI
  1000c50a  TEST EDI,EDI
  1000c50c  JA 0x1000c4d8    ; LAB_1000c4d8
  1000c50e  JC 0x1000c514    ; LAB_1000c514
  1000c510  TEST EBX,EBX
  1000c512  JA 0x1000c4d8    ; LAB_1000c4d8
LAB_1000c514:
  1000c514  AND byte ptr [ESI],0x0
  1000c517  DEC ESI
LAB_1000c518:
  1000c518  MOV EAX,dword ptr [EBP + 0x10]
  1000c51b  MOV CL,byte ptr [ESI]
  1000c51d  MOV DL,byte ptr [EAX]
  1000c51f  MOV byte ptr [ESI],DL
  1000c521  MOV byte ptr [EAX],CL
  1000c523  DEC ESI
  1000c524  INC EAX
  1000c525  CMP EAX,ESI
  1000c527  MOV dword ptr [EBP + 0x10],EAX
  1000c52a  JC 0x1000c518    ; LAB_1000c518
  1000c52c  POP EDI
  1000c52d  POP ESI
  1000c52e  POP EBX
  1000c52f  POP EBP
  1000c530  RET 0x14

;==== FUNCTION FUN_1000c533 @ 1000c533 : char * FUN_1000c533(int param_1, int param_2, char * param_3, uint param_4)
  1000c533  PUSH EBP
  1000c534  MOV EBP,ESP
  1000c536  PUSH 0x0
  1000c538  PUSH dword ptr [EBP + 0x14]
  1000c53b  PUSH dword ptr [EBP + 0x10]
  1000c53e  PUSH dword ptr [EBP + 0xc]
  1000c541  PUSH dword ptr [EBP + 0x8]
  1000c544  CALL 0x1000c4ad    ; FUN_1000c4ad
  1000c549  MOV EAX,dword ptr [EBP + 0x10]
  1000c54c  POP EBP
  1000c54d  RET

;==== FUNCTION Unwind@1000c550 @ 1000c550 : undefined Unwind@1000c550(void)
  1000c550  MOV EAX,dword ptr [EBP + 0x8]
  1000c553  PUSH EAX
  1000c554  CALL 0x10005197    ; FUN_10005197
  1000c559  POP ECX
  1000c55a  RET
LAB_1000c55b:
  1000c55b  MOV EAX,0x1000d618    ; FuncInfo_1000d618
  1000c560  JMP 0x1000529a    ; FUN_1000529a

;==== FUNCTION Unwind@1000c570 @ 1000c570 : undefined Unwind@1000c570(void)
  1000c570  MOV EAX,dword ptr [EBP + -0x14]
  1000c573  PUSH EAX
  1000c574  CALL 0x10005197    ; FUN_10005197
  1000c579  POP ECX
  1000c57a  RET
LAB_1000c57b:
  1000c57b  MOV EAX,0x1000d640    ; FuncInfo_1000d640
  1000c580  JMP 0x1000529a    ; FUN_1000529a

;==== FUNCTION Unwind@1000c590 @ 1000c590 : undefined Unwind@1000c590(void)
  1000c590  MOV ECX,dword ptr [EBP + -0x10]
  1000c593  JMP 0x100026b0    ; FUN_100026b0

;==== FUNCTION Unwind@1000c598 @ 1000c598 : undefined Unwind@1000c598(void)
  1000c598  MOV EAX,dword ptr [EBP + 0x8]
  1000c59b  PUSH EAX
  1000c59c  CALL 0x10005197    ; FUN_10005197
  1000c5a1  POP ECX
  1000c5a2  RET
LAB_1000c5a3:
  1000c5a3  MOV EAX,0x1000d668    ; FuncInfo_1000d668
  1000c5a8  JMP 0x1000529a    ; FUN_1000529a

;==== FUNCTION Unwind@1000c5b0 @ 1000c5b0 : undefined Unwind@1000c5b0(void)
  1000c5b0  MOV ECX,dword ptr [EBP + -0x14]
  1000c5b3  JMP 0x100026b0    ; FUN_100026b0
LAB_1000c5b8:
  1000c5b8  MOV EAX,0x1000d698    ; FuncInfo_1000d698
  1000c5bd  JMP 0x1000529a    ; FUN_1000529a

;==== FUNCTION Unwind@1000c5d0 @ 1000c5d0 : undefined Unwind@1000c5d0(void)
  1000c5d0  MOV EAX,dword ptr [EBP + -0x10]
  1000c5d3  PUSH EAX
  1000c5d4  CALL 0x10005197    ; FUN_10005197
  1000c5d9  POP ECX
  1000c5da  RET
LAB_1000c5db:
  1000c5db  MOV EAX,0x1000d6c0    ; FuncInfo_1000d6c0
  1000c5e0  JMP 0x1000529a    ; FUN_1000529a

;==== FUNCTION Unwind@1000c5f0 @ 1000c5f0 : undefined Unwind@1000c5f0(void)
  1000c5f0  MOV ECX,dword ptr [EBP + -0x10]
  1000c5f3  JMP 0x100026b0    ; FUN_100026b0

;==== FUNCTION Unwind@1000c5f8 @ 1000c5f8 : undefined Unwind@1000c5f8(void)
  1000c5f8  MOV EAX,dword ptr [EBP + 0x8]
  1000c5fb  PUSH EAX
  1000c5fc  CALL 0x10005197    ; FUN_10005197
  1000c601  POP ECX
  1000c602  RET

;==== FUNCTION Unwind@1000c603 @ 1000c603 : undefined Unwind@1000c603(void)
  1000c603  MOV EAX,dword ptr [EBP + 0x8]
  1000c606  PUSH EAX
  1000c607  CALL 0x10005197    ; FUN_10005197
  1000c60c  POP ECX
  1000c60d  RET
LAB_1000c60e:
  1000c60e  MOV EAX,0x1000d6e8    ; FuncInfo_1000d6e8
  1000c613  JMP 0x1000529a    ; FUN_1000529a

;==== FUNCTION Unwind@1000c620 @ 1000c620 : undefined Unwind@1000c620(void)
  1000c620  MOV ECX,dword ptr [EBP + -0x14]
  1000c623  JMP 0x100026b0    ; FUN_100026b0
LAB_1000c628:
  1000c628  MOV EAX,0x1000d720    ; FuncInfo_1000d720
  1000c62d  JMP 0x1000529a    ; FUN_1000529a

;==== FUNCTION Unwind@1000c640 @ 1000c640 : undefined Unwind@1000c640(void)
  1000c640  MOV EAX,dword ptr [EBP + -0x18]
  1000c643  PUSH EAX
  1000c644  CALL 0x10005197    ; FUN_10005197
  1000c649  POP ECX
  1000c64a  RET

;==== FUNCTION Unwind@1000c64b @ 1000c64b : undefined Unwind@1000c64b(void)
  1000c64b  MOV EAX,dword ptr [EBP + -0x18]
  1000c64e  PUSH EAX
  1000c64f  CALL 0x10005197    ; FUN_10005197
  1000c654  POP ECX
  1000c655  RET

;==== FUNCTION Unwind@1000c656 @ 1000c656 : undefined Unwind@1000c656(void)
  1000c656  MOV EAX,dword ptr [EBP + -0x18]
  1000c659  PUSH EAX
  1000c65a  CALL 0x10005197    ; FUN_10005197
  1000c65f  POP ECX
  1000c660  RET
LAB_1000c661:
  1000c661  MOV EAX,0x1000d748    ; FuncInfo_1000d748
  1000c666  JMP 0x1000529a    ; FUN_1000529a

;==== FUNCTION Unwind@1000c670 @ 1000c670 : undefined Unwind@1000c670(void)
  1000c670  MOV EAX,dword ptr [EBP + -0x10]
  1000c673  PUSH EAX
  1000c674  CALL 0x10005197    ; FUN_10005197
  1000c679  POP ECX
  1000c67a  RET

;==== FUNCTION Unwind@1000c67b @ 1000c67b : undefined Unwind@1000c67b(void)
  1000c67b  MOV EAX,dword ptr [EBP + -0x10]
  1000c67e  PUSH EAX
  1000c67f  CALL 0x10005197    ; FUN_10005197
  1000c684  POP ECX
  1000c685  RET

;==== FUNCTION Unwind@1000c686 @ 1000c686 : undefined Unwind@1000c686(void)
  1000c686  MOV EAX,dword ptr [EBP + -0x10]
  1000c689  PUSH EAX
  1000c68a  CALL 0x10005197    ; FUN_10005197
  1000c68f  POP ECX
  1000c690  RET
LAB_1000c691:
  1000c691  MOV EAX,0x1000d780    ; FuncInfo_1000d780
  1000c696  JMP 0x1000529a    ; FUN_1000529a

;==== FUNCTION Unwind@1000c6a0 @ 1000c6a0 : undefined Unwind@1000c6a0(void)
  1000c6a0  MOV EAX,dword ptr [EBP + 0x8]
  1000c6a3  PUSH EAX
  1000c6a4  CALL 0x10005197    ; FUN_10005197
  1000c6a9  POP ECX
  1000c6aa  RET

;==== FUNCTION Unwind@1000c6ab @ 1000c6ab : undefined Unwind@1000c6ab(void)
  1000c6ab  MOV EAX,dword ptr [EBP + 0x8]
  1000c6ae  PUSH EAX
  1000c6af  CALL 0x10005197    ; FUN_10005197
  1000c6b4  POP ECX
  1000c6b5  RET
LAB_1000c6b6:
  1000c6b6  MOV EAX,0x1000d7b8    ; FuncInfo_1000d7b8
  1000c6bb  JMP 0x1000529a    ; FUN_1000529a

;==== FUNCTION Unwind@1000c6c0 @ 1000c6c0 : undefined Unwind@1000c6c0(void)
  1000c6c0  MOV EAX,dword ptr [EBP + -0x10]
  1000c6c3  PUSH EAX
  1000c6c4  CALL 0x10005197    ; FUN_10005197
  1000c6c9  POP ECX
  1000c6ca  RET
LAB_1000c6cb:
  1000c6cb  MOV EAX,0x1000d7e8    ; FuncInfo_1000d7e8
  1000c6d0  JMP 0x1000529a    ; FUN_1000529a

;==== FUNCTION Unwind@1000c6e0 @ 1000c6e0 : undefined Unwind@1000c6e0(void)
  1000c6e0  MOV ECX,dword ptr [EBP + -0x10]
  1000c6e3  JMP 0x100026b0    ; FUN_100026b0
LAB_1000c6e8:
  1000c6e8  MOV EAX,0x1000d810    ; FuncInfo_1000d810
  1000c6ed  JMP 0x1000529a    ; FUN_1000529a

;==== FUNCTION Unwind@1000c700 @ 1000c700 : undefined Unwind@1000c700(void)
  1000c700  MOV ECX,dword ptr [EBP + -0x10]
  1000c703  JMP 0x100026b0    ; FUN_100026b0
LAB_1000c708:
  1000c708  MOV EAX,0x1000d838    ; FuncInfo_1000d838
  1000c70d  JMP 0x1000529a    ; FUN_1000529a

;==== FUNCTION Unwind@1000c720 @ 1000c720 : undefined Unwind@1000c720(void)
  1000c720  MOV EAX,dword ptr [EBP + 0x8]
  1000c723  PUSH EAX
  1000c724  CALL 0x10005197    ; FUN_10005197
  1000c729  POP ECX
  1000c72a  RET
LAB_1000c72b:
  1000c72b  MOV EAX,0x1000d860    ; FuncInfo_1000d860
  1000c730  JMP 0x1000529a    ; FUN_1000529a

;==== FUNCTION Unwind@1000c740 @ 1000c740 : undefined Unwind@1000c740(void)
  1000c740  MOV EAX,dword ptr [EBP + 0x8]
  1000c743  PUSH EAX
  1000c744  CALL 0x10005197    ; FUN_10005197
  1000c749  POP ECX
  1000c74a  RET
LAB_1000c74b:
  1000c74b  MOV EAX,0x1000d888    ; FuncInfo_1000d888
  1000c750  JMP 0x1000529a    ; FUN_1000529a
