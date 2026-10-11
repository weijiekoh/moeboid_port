/* ==== FUNCTION FUN_10001000 @ 10001000 size=92 ==== */

void __thiscall FUN_10001000(void *this,int *param_1)

{
  longlong lVar1;
  
  lVar1 = __ftol();
  *param_1 = ((int)lVar1 - *(int *)((int)this + 0x1c) / 2) + 3;
  lVar1 = __ftol();
  param_1[1] = ((int)lVar1 - *(int *)((int)this + 0x20) / 2) + 3;
  param_1[2] = *param_1 + -3 + *(int *)((int)this + 0x1c);
  param_1[3] = *(int *)((int)this + 0x20) + -3 + param_1[1];
  return;
}


/* ==== FUNCTION FUN_10001060 @ 10001060 size=159 ==== */

void __fastcall FUN_10001060(int *param_1)

{
  uint uVar1;
  
  uVar1 = (**(code **)(*DAT_1000f5b4 + 8))();
  param_1[5] = (int)((float)(uVar1 % 0x32) * 0.01);
  uVar1 = (**(code **)(*DAT_1000f5b4 + 8))();
  if ((uVar1 & 1) == 0) {
    param_1[5] = (int)((float)param_1[5] * -1.0);
  }
  uVar1 = (**(code **)(*DAT_1000f5b4 + 8))();
  param_1[6] = (int)((float)(uVar1 % 0x32) * 0.01);
  uVar1 = (**(code **)(*DAT_1000f5b4 + 8))();
  if ((uVar1 & 1) == 0) {
    param_1[6] = (int)((float)param_1[6] * -1.0);
  }
  FUN_10001100(param_1);
  return;
}


/* ==== FUNCTION FUN_10001100 @ 10001100 size=160 ==== */

void __fastcall FUN_10001100(int *param_1)

{
  int *piVar1;
  int iVar2;
  
  *(bool *)(param_1 + 9) = (float)param_1[5] < 0.0;
  if (param_1[2] != 0) {
    (**(code **)(*DAT_1000f5bc + 0x1c))(param_1[2]);
    (**(code **)(*(int *)param_1[2] + 4))();
  }
  piVar1 = (int *)(**(code **)(*DAT_1000f5b0 + 0x14))
                            (*(undefined4 *)
                              (DAT_1000f5cc + ((uint)*(byte *)(param_1 + 9) + *param_1 * 2) * 4));
  iVar2 = (**(code **)(*DAT_1000f5b0 + 8))(piVar1,0);
  param_1[2] = iVar2;
  (**(code **)(*piVar1 + 4))();
  (**(code **)(*(int *)param_1[2] + 0x2c))();
  (**(code **)(*DAT_1000f5bc + 0x18))(param_1[2]);
  (**(code **)(*(int *)param_1[2] + 0x48))(param_1 + 7,param_1 + 8);
  return;
}


/* ==== FUNCTION FUN_100011a0 @ 100011a0 size=414 ==== */

int * __thiscall FUN_100011a0(void *this,int param_1)

{
  int iVar1;
  uint uVar2;
  uint uVar3;
  int *piVar4;
  undefined4 uVar5;
  float10 fVar6;
  float10 fVar7;
  longlong lVar8;
  undefined4 uVar9;
  
  *(int *)this = param_1;
  *(undefined4 *)((int)this + 8) = 0;
  *(undefined1 *)((int)this + 0x25) = 0;
  *(undefined4 *)((int)this + 0x34) = 0;
  FUN_10001060(this);
  if (DAT_1000f605 == '\0') {
    do {
      uVar2 = (**(code **)(*DAT_1000f5b4 + 8))();
      uVar2 = uVar2 % (0xbeU - *(int *)((int)this + 0x1c));
      uVar3 = (**(code **)(*DAT_1000f5b4 + 8))();
      fVar6 = (float10)(uVar3 % 1000) * (float10)0.0062831854;
      fVar7 = (float10)fsin(fVar6);
      fVar7 = fVar7 * (float10)uVar2 + (float10)249.0;
      *(float *)((int)this + 0xc) = (float)fVar7;
      fVar6 = (float10)fcos(fVar6);
      fVar6 = fVar6 * (float10)uVar2 + (float10)207.0;
      *(float *)((int)this + 0x10) = (float)fVar6;
      fVar6 = fVar6 - (float10)*(float *)(*(int *)(DAT_1000f5e4 + 0xc) + 0x14);
      fVar7 = (float10)(float)fVar7 - (float10)*(float *)(*(int *)(DAT_1000f5e4 + 0xc) + 0x10);
    } while (SQRT(fVar6 * fVar6 + fVar7 * fVar7) <= (float10)80.0);
  }
  else {
    uVar2 = (**(code **)(*DAT_1000f5b4 + 8))();
    *(float *)((int)this + 0xc) = (float)(uVar2 % 300 + 100);
    uVar2 = (**(code **)(*DAT_1000f5b4 + 8))();
    *(float *)((int)this + 0x10) = (float)(uVar2 % 200 + 100);
  }
  uVar9 = 0;
  iVar1 = **(int **)((int)this + 8);
  lVar8 = __ftol();
  uVar5 = (undefined4)lVar8;
  lVar8 = __ftol();
  (**(code **)(iVar1 + 8))((int)lVar8,uVar5,uVar9);
  (**(code **)(**(int **)((int)this + 8) + 0x10))(0,0);
  piVar4 = (int *)(**(code **)(*DAT_1000f5b0 + 0x14))(*(undefined4 *)(DAT_1000f5cc + 0xa8));
  uVar5 = (**(code **)(*DAT_1000f5b0 + 8))(piVar4,0);
  *(undefined4 *)((int)this + 4) = uVar5;
  (**(code **)(*piVar4 + 4))();
  *(undefined4 *)((int)this + 0x28) = DAT_1000f5e0;
  uVar2 = (**(code **)(*DAT_1000f5b4 + 8))();
  *(undefined1 *)((int)this + 0x30) = 1;
  *(uint *)((int)this + 0x2c) = uVar2 % 4000;
  return this;
}


/* ==== FUNCTION FUN_10001340 @ 10001340 size=62 ==== */

void __fastcall FUN_10001340(int param_1)

{
  (**(code **)(*DAT_1000f5bc + 0x1c))(*(undefined4 *)(param_1 + 8));
  (**(code **)(**(int **)(param_1 + 8) + 4))();
  if (*(int *)(param_1 + 4) != 0) {
    if (*(char *)(param_1 + 0x25) != '\0') {
      (**(code **)(*DAT_1000f5bc + 0x1c))(*(int *)(param_1 + 4));
    }
    (**(code **)(**(int **)(param_1 + 4) + 4))();
  }
  return;
}


/* ==== FUNCTION FUN_10001380 @ 10001380 size=791 ==== */

void __thiscall FUN_10001380(void *this,int param_1)

{
  int iVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  int iVar8;
  uint uVar9;
  longlong lVar10;
  undefined4 uVar11;
  undefined4 uVar12;
  
  if ((*(char *)((int)this + 0x30) == '\0') ||
     ((uint)(param_1 - *(int *)((int)this + 0x28)) <= *(uint *)((int)this + 0x2c))) {
    if (*(int *)((int)this + 4) != 0) {
      if ((uint)(param_1 - *(int *)((int)this + 0x28)) <= *(int *)((int)this + 0x2c) + 600U) {
        return;
      }
      *(undefined1 *)((int)this + 0x25) = 0;
      (**(code **)(*DAT_1000f5bc + 0x1c))(*(int *)((int)this + 4));
      (**(code **)(**(int **)((int)this + 4) + 4))();
      *(undefined4 *)((int)this + 4) = 0;
      (**(code **)(**(int **)((int)this + 8) + 0x10))(1,0);
    }
    uVar9 = (**(code **)(*DAT_1000f5b4 + 8))();
    if (uVar9 % 100 == 0) {
      FUN_10001060(this);
    }
    else {
      if (*(int *)((int)this + 0x34) == 0) {
        *(int *)((int)this + 0x34) = DAT_1000f5e0;
      }
      fVar3 = (float)(uint)(DAT_1000f5e0 - *(int *)((int)this + 0x34));
      fVar2 = fVar3 * *(float *)((int)this + 0x14) * 0.09;
      fVar3 = fVar3 * *(float *)((int)this + 0x18) * 0.09;
      fVar4 = (*(float *)((int)this + 0xc) - 245.0) + (float)(*(int *)((int)this + 0x1c) / 2) +
              fVar2;
      fVar5 = (*(float *)((int)this + 0x10) - 209.0) + (float)(*(int *)((int)this + 0x20) / 2) +
              fVar3;
      fVar6 = fVar4 * fVar4 + fVar5 * fVar5;
      fVar7 = 205.0 - (float)*(int *)((int)this + 0x1c) * 0.5;
      fVar7 = fVar7 * fVar7;
      if ((DAT_1000f605 != '\0') &&
         ((((175.0 <= *(float *)((int)this + 0xc) && (*(float *)((int)this + 0xc) <= 250.0)) &&
           (0.0 < *(float *)((int)this + 0x14))) ||
          (((250.0 < *(float *)((int)this + 0xc) && (*(float *)((int)this + 0xc) <= 295.0)) &&
           (*(float *)((int)this + 0x14) < 0.0)))))) {
        *(float *)((int)this + 0x14) = -*(float *)((int)this + 0x14);
        FUN_10001100(this);
      }
      if (fVar6 < fVar7) {
        *(float *)((int)this + 0xc) = fVar2 + *(float *)((int)this + 0xc);
        *(float *)((int)this + 0x10) = fVar3 + *(float *)((int)this + 0x10);
      }
      else {
        *(float *)((int)this + 0xc) =
             ((fVar7 * fVar4) / fVar6 + 245.0) - (float)(*(int *)((int)this + 0x1c) / 2);
        *(float *)((int)this + 0x10) =
             ((fVar7 * fVar5) / fVar6 + 209.0) - (float)(*(int *)((int)this + 0x20) / 2);
        *(float *)((int)this + 0x14) = *(float *)((int)this + 0x14) * -1.0;
        *(float *)((int)this + 0x18) = *(float *)((int)this + 0x18) * -1.0;
      }
      uVar12 = 0;
      iVar1 = **(int **)((int)this + 8);
      lVar10 = __ftol();
      uVar11 = (undefined4)lVar10;
      lVar10 = __ftol();
      (**(code **)(iVar1 + 8))((int)lVar10,uVar11,uVar12);
      *(int *)((int)this + 0x34) = DAT_1000f5e0;
    }
    uVar12 = 0;
    iVar1 = **(int **)((int)this + 8);
    lVar10 = __ftol();
    uVar11 = (undefined4)lVar10;
    lVar10 = __ftol();
    (**(code **)(iVar1 + 8))((int)lVar10,uVar11,uVar12);
    return;
  }
  *(undefined1 *)((int)this + 0x25) = 1;
  (**(code **)(*DAT_1000f5bc + 0x18))(*(undefined4 *)((int)this + 4));
  (**(code **)(**(int **)((int)this + 4) + 0x2c))();
  uVar11 = 0;
  iVar1 = **(int **)((int)this + 4);
  lVar10 = __ftol();
  iVar8 = (int)lVar10 + -10;
  lVar10 = __ftol();
  (**(code **)(iVar1 + 8))((int)lVar10 + -10,iVar8,uVar11);
  *(undefined1 *)((int)this + 0x30) = 0;
  if ((DAT_1000f5e4 != 0) && (**(int **)(DAT_1000f5e4 + 0xc) < *(int *)this)) {
    (**(code **)(**(int **)(DAT_1000f5cc + 0xe8) + 8))(0);
    return;
  }
  (**(code **)(**(int **)(DAT_1000f5cc + 0xe4) + 8))(0);
  return;
}


/* ==== FUNCTION FUN_100016a0 @ 100016a0 size=1189 ==== */

void * __thiscall FUN_100016a0(void *this,int *param_1)

{
  undefined4 uVar1;
  int *piVar2;
  undefined4 *puVar3;
  int iVar4;
  undefined1 local_114 [100];
  undefined1 local_b0 [100];
  undefined4 local_4c;
  undefined4 local_48;
  undefined4 local_44;
  undefined4 local_40;
  undefined4 local_3c;
  undefined4 local_38;
  undefined4 local_34;
  undefined4 local_30;
  undefined4 local_2c;
  undefined4 local_28;
  int *local_24;
  int local_20;
  int local_1c;
  undefined4 *local_18;
  int *local_14;
  void *local_10;
  undefined1 *puStack_c;
  undefined4 local_8;
  
  piVar2 = param_1;
  local_8 = 0xffffffff;
  puStack_c = &LAB_1000c55b;
  local_10 = ExceptionList;
  DAT_1000f5b4 = param_1;
  DAT_1000f5bc = (int *)param_1[2];
  DAT_1000f5cc = this;
  ExceptionList = &local_10;
  (**(code **)(*DAT_1000f5bc + 0x44))(&DAT_1000f5b8);
  DAT_1000f5c0 = piVar2[3];
  DAT_1000f5c8 = piVar2[5];
  DAT_1000f5c4 = piVar2[6];
  DAT_1000f5b0 = (int *)piVar2[4];
  uVar1 = (**(code **)(*DAT_1000f5b0 + 0x44))(piVar2[5],0x10,this,FUN_10001f40);
  *(undefined4 *)((int)this + 4) = uVar1;
  (**(code **)(*(int *)DAT_1000f5b4[5] + 0x10))(0x33);
  local_18 = &local_4c;
  local_1c = (int)this + 0xc;
  local_4c = 0xb;
  local_48 = 0xf;
  local_44 = 0x13;
  local_40 = 0x17;
  local_3c = 0x1b;
  local_38 = 0x1f;
  local_34 = 0x23;
  local_30 = 0x27;
  local_2c = 0x2b;
  local_28 = 0x2f;
  local_20 = 10;
  do {
    FUN_100051b0(local_b0,(byte *)s_ani_baddie_right__dx_d_gif_1000e21c);
    piVar2 = (int *)(**(code **)(*DAT_1000f5b0 + 0xc))(local_b0,0);
    (**(code **)(*piVar2 + 0x3c))(&param_1);
    (**(code **)(*param_1 + 0x10))(local_1c + -4);
    (**(code **)(*param_1 + 4))();
    (**(code **)(*piVar2 + 4))();
    FUN_100051b0(local_b0,(byte *)s_ani_baddie_left__dx_d_gif_1000e200);
    piVar2 = (int *)(**(code **)(*DAT_1000f5b0 + 0xc))(local_b0,0);
    (**(code **)(*piVar2 + 0x3c))(&param_1);
    iVar4 = local_1c;
    (**(code **)(*param_1 + 0x10))(local_1c);
    (**(code **)(*param_1 + 4))();
    (**(code **)(*piVar2 + 4))();
    local_18 = local_18 + 1;
    local_1c = iVar4 + 8;
    local_20 = local_20 + -1;
  } while (local_20 != 0);
  iVar4 = 0;
  local_20 = 0;
  do {
    FUN_100051b0(local_114,(byte *)s_ani_meboid_right__dx_d_gif_1000e1e4);
    piVar2 = (int *)(**(code **)(*DAT_1000f5b0 + 0xc))(local_114,0);
    (**(code **)(*piVar2 + 0x3c))((int)this + iVar4 * 4 + 0x80);
    if (iVar4 == 2) {
      (**(code **)(*piVar2 + 0x44))((int)this + 0xb8);
    }
    (**(code **)(*piVar2 + 4))();
    FUN_100051b0(local_114,(byte *)s_ani_meboid_left__dx_d_gif_1000e1c8);
    piVar2 = (int *)(**(code **)(*DAT_1000f5b0 + 0xc))(local_114,0);
    (**(code **)(*piVar2 + 0x3c))((int)this + iVar4 * 4 + 0x58);
    (**(code **)(*piVar2 + 4))();
    iVar4 = iVar4 + 1;
  } while (iVar4 < 10);
  piVar2 = (int *)(**(code **)(*DAT_1000f5b0 + 0xc))(s_img_titlescreen_500x420_gif_1000e1ac,0);
  (**(code **)(*piVar2 + 0x44))((int)this + 0xbc);
  (**(code **)(*piVar2 + 4))();
  piVar2 = (int *)(**(code **)(*DAT_1000f5b0 + 0xc))(s_img_backgroundscreen_500x420_gif_1000e188,0);
  *(int **)((int)this + 0xac) = piVar2;
  (**(code **)(*piVar2 + 0x3c))(&local_14);
  (**(code **)(*local_14 + 0x10))(&local_24);
  (**(code **)(*local_24 + 0x10))(2,(int)this + 0xc0);
  (**(code **)(*local_24 + 4))();
  (**(code **)(*local_14 + 4))();
  piVar2 = (int *)(**(code **)(*DAT_1000f5b0 + 0xc))(s_ani_baddie_blob_39x39_gif_1000e16c,0);
  (**(code **)(*piVar2 + 0x3c))(&local_14);
  (**(code **)(*local_14 + 0x10))((int)this + 0xa8);
  (**(code **)(*piVar2 + 4))();
  (**(code **)(*local_14 + 4))();
  piVar2 = (int *)(**(code **)(*DAT_1000f5b0 + 0xc))(s_ani_meboid_angel_19x19_gif_1000e150,0);
  (**(code **)(*piVar2 + 0x3c))((int)this + 0xc4);
  (**(code **)(*piVar2 + 4))();
  uVar1 = (**(code **)(*DAT_1000f5b0 + 0xc))(s_ani_titlescreen_animation_500x79_1000e128,0);
  *(undefined4 *)((int)this + 0xb0) = uVar1;
  *(undefined1 *)((int)this + 0xb4) = 0;
  uVar1 = (**(code **)(*DAT_1000f5b0 + 0x40))(s_snd_gameopen_wav_1000e114,0);
  *(undefined4 *)((int)this + 200) = uVar1;
  uVar1 = (**(code **)(*DAT_1000f5b0 + 0x40))(s_snd_gameover_highscore_wav_1000e0f8,0);
  *(undefined4 *)((int)this + 0xd0) = uVar1;
  uVar1 = (**(code **)(*DAT_1000f5b0 + 0x40))(s_snd_gameover_wav_1000e0e4,0);
  *(undefined4 *)((int)this + 0xcc) = uVar1;
  uVar1 = (**(code **)(*DAT_1000f5b0 + 0x40))(s_snd_gamestart_wav_1000e0d0,0);
  *(undefined4 *)((int)this + 0xd4) = uVar1;
  uVar1 = (**(code **)(*DAT_1000f5b0 + 0x40))(s_snd_loselife_wav_1000e0bc,0);
  *(undefined4 *)((int)this + 0xd8) = uVar1;
  uVar1 = (**(code **)(*DAT_1000f5b0 + 0x40))(s_snd_moebeats_wav_1000e0a8,0);
  *(undefined4 *)((int)this + 0xdc) = uVar1;
  uVar1 = (**(code **)(*DAT_1000f5b0 + 0x40))(s_snd_moebgrowth_wav_1000e094,0);
  *(undefined4 *)((int)this + 0xe0) = uVar1;
  uVar1 = (**(code **)(*DAT_1000f5b0 + 0x40))(s_snd_newbaddieGood_wav_1000e07c,0);
  *(undefined4 *)((int)this + 0xe4) = uVar1;
  uVar1 = (**(code **)(*DAT_1000f5b0 + 0x40))(s_snd_newbaddieBad_wav_1000e064,0);
  *(undefined4 *)((int)this + 0xe8) = uVar1;
  uVar1 = (**(code **)(*DAT_1000f5b0 + 0x40))(s_snd_randbg_wav_1000e054,0);
  *(undefined4 *)((int)this + 0xec) = uVar1;
  uVar1 = (**(code **)(*DAT_1000f5b0 + 0x40))(s_snd_ExtraLife_wav_1000e040,0);
  *(undefined4 *)((int)this + 0xf0) = uVar1;
  param_1 = operator_new(0x20);
  local_8 = 0;
  if (param_1 == (int *)0x0) {
    puVar3 = (undefined4 *)0x0;
  }
  else {
    puVar3 = FUN_100041a0(param_1,this);
  }
  local_8 = 0xffffffff;
  FUN_10001db0(this,(undefined4 *)0x0,puVar3);
  ExceptionList = local_10;
  return this;
}


/* ==== FUNCTION FUN_10001b50 @ 10001b50 size=308 ==== */

void __fastcall FUN_10001b50(int *param_1)

{
  int iVar1;
  int *piVar2;
  
  (**(code **)(*DAT_1000f5b8 + 4))();
  (**(code **)(*(int *)param_1[1] + 4))();
  (**(code **)(*(int *)param_1[0x2f] + 4))();
  if ((char)param_1[0x2d] != '\0') {
    (**(code **)(*DAT_1000f5bc + 0x1c))(param_1[0x2b]);
  }
  (**(code **)(*(int *)param_1[0x30] + 4))();
  piVar2 = param_1 + 0x20;
  iVar1 = 10;
  do {
    (**(code **)(*(int *)piVar2[-10] + 4))();
    (**(code **)(*(int *)*piVar2 + 4))();
    piVar2 = piVar2 + 1;
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  (**(code **)(*(int *)param_1[0x32] + 4))();
  (**(code **)(*(int *)param_1[0x33] + 4))();
  (**(code **)(*(int *)param_1[0x34] + 4))();
  (**(code **)(*(int *)param_1[0x35] + 4))();
  (**(code **)(*(int *)param_1[0x36] + 4))();
  (**(code **)(*(int *)param_1[0x37] + 4))();
  (**(code **)(*(int *)param_1[0x38] + 4))();
  (**(code **)(*(int *)param_1[0x39] + 4))();
  (**(code **)(*(int *)param_1[0x3a] + 4))();
  (**(code **)(*(int *)param_1[0x3b] + 4))();
  (**(code **)(*(int *)param_1[0x3c] + 4))();
  (**(code **)(*(int *)param_1[0x31] + 4))();
  (**(code **)(*(int *)param_1[0x2a] + 4))();
  (**(code **)(*(int *)param_1[0x2e] + 4))();
  piVar2 = param_1 + 2;
  iVar1 = 0x14;
  do {
    (**(code **)(*(int *)*piVar2 + 4))();
    piVar2 = piVar2 + 1;
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  if ((undefined4 *)*param_1 != (undefined4 *)0x0) {
    (*(code *)**(undefined4 **)*param_1)(1);
  }
  (**(code **)(*(int *)param_1[0x2c] + 4))();
  return;
}


/* ==== FUNCTION FUN_10001c90 @ 10001c90 size=281 ==== */

undefined4 FUN_10001c90(void)

{
  byte bVar1;
  void *this;
  undefined4 *this_00;
  int iVar2;
  uint uVar3;
  int *unaff_ESI;
  byte *pbVar4;
  byte local_2728 [9976];
  undefined4 uStackY_30;
  void *local_10;
  undefined1 *puStack_c;
  undefined4 local_8;
  
  local_8 = 0xffffffff;
  puStack_c = &LAB_1000c57b;
  local_10 = ExceptionList;
  ExceptionList = &local_10;
  FUN_10005600();
  (**(code **)(*DAT_1000f5c0 + 0x44))();
  this = operator_new(0x10);
  local_8 = 0;
  if (this == (void *)0x0) {
    this_00 = (undefined4 *)0x0;
  }
  else {
    this_00 = FUN_10004e90(this,s_Help_zml_1000e270);
  }
  local_8 = 0xffffffff;
  iVar2 = FUN_10004fb0(this_00,(int)local_2728,10000);
  if (iVar2 != 8) {
    FUN_10004f60();
    FUN_10005197(this_00);
    uVar3 = 0xffffffff;
    iVar2 = 0;
    pbVar4 = local_2728;
    do {
      if (uVar3 == 0) break;
      uVar3 = uVar3 - 1;
      bVar1 = *pbVar4;
      pbVar4 = pbVar4 + 1;
    } while (bVar1 != 0);
    if (0 < (int)(~uVar3 - 1)) {
      do {
        if ((local_2728[iVar2] == 0xd) || (local_2728[iVar2] == 10)) {
          local_2728[iVar2] = 0x20;
        }
        uVar3 = 0xffffffff;
        iVar2 = iVar2 + 1;
        pbVar4 = local_2728;
        do {
          if (uVar3 == 0) break;
          uVar3 = uVar3 - 1;
          bVar1 = *pbVar4;
          pbVar4 = pbVar4 + 1;
        } while (bVar1 != 0);
      } while (iVar2 < (int)(~uVar3 - 1));
    }
    uStackY_30 = 0x10001d72;
    FUN_10004a00(unaff_ESI,local_2728,(int *)0x0,10);
  }
  FUN_10004a00(unaff_ESI,(byte *)s_<C999999><s4>Moeboid_is_a_tradem_1000e238,(int *)0x12f,0);
  (**(code **)(*unaff_ESI + 4))();
  ExceptionList = local_10;
  return 0;
}


/* ==== FUNCTION FUN_10001db0 @ 10001db0 size=43 ==== */

undefined4 __thiscall FUN_10001db0(void *this,undefined4 *param_1,undefined4 param_2)

{
  if (param_1 != (undefined4 *)0x0) {
    (**(code **)*param_1)(1);
    *(undefined4 *)this = param_2;
    return 0;
  }
  *(undefined4 *)this = param_2;
  return 0;
}


/* ==== FUNCTION FUN_10001de0 @ 10001de0 size=351 ==== */

undefined4
FUN_10001de0(undefined4 param_1,byte *param_2,undefined4 param_3,undefined4 param_4,int param_5,
            undefined4 param_6,undefined4 param_7,undefined4 param_8)

{
  int *piVar1;
  byte bVar2;
  int *piVar3;
  int *piVar4;
  int iVar5;
  uint uVar6;
  byte *pbVar7;
  undefined4 uVar8;
  undefined4 uVar9;
  undefined4 uVar10;
  int local_c;
  undefined4 local_8;
  
  piVar3 = (int *)(**(code **)(*DAT_1000f5b0 + 0x28))(s_Arial_1000e290,param_6,1);
  uVar6 = 0xffffffff;
  pbVar7 = param_2;
  do {
    if (uVar6 == 0) break;
    uVar6 = uVar6 - 1;
    bVar2 = *pbVar7;
    pbVar7 = pbVar7 + 1;
  } while (bVar2 != 0);
  (**(code **)(*DAT_1000f5b8 + 0x58))(piVar3,param_2,~uVar6 - 1,&local_c);
  piVar1 = (int *)(local_c + 4);
  piVar4 = (int *)(**(code **)(*DAT_1000f5b0 + 0x20))((int)piVar1 * 2,local_8,1);
  (**(code **)(*piVar4 + 0x48))(piVar3);
  if (DAT_1000f605 == '\0') {
    if (param_5 == -1) {
      (**(code **)(*piVar4 + 0x34))(0x66,0xcc,0xff);
      goto LAB_10001e97;
    }
    iVar5 = *piVar4;
    uVar10 = 0xff;
    uVar9 = 0xcc;
    uVar8 = 0x99;
  }
  else {
    iVar5 = *piVar4;
    uVar10 = 0x33;
    uVar9 = 0x99;
    uVar8 = 0xff;
  }
  (**(code **)(iVar5 + 0x34))(uVar8,uVar9,uVar10);
LAB_10001e97:
  (**(code **)(*piVar4 + 0x24))(0,0,0);
  FUN_10004a00(piVar4,(byte *)s_<B><U>_1000e288,(int *)0x0,0);
  FUN_10004a00(piVar4,param_2,(int *)0x0,0);
  (**(code **)(*piVar4 + 0x24))(0xff,0xff,0xff);
  FUN_10004a00(piVar4,param_2,piVar1,0);
  FUN_10004a00(piVar4,(byte *)s_<_B><_U>_1000e27c,(int *)0x0,0);
  (**(code **)(*piVar3 + 4))();
  uVar8 = (**(code **)(*DAT_1000f5b0 + 0x30))
                    (param_1,param_7,param_3,param_4,piVar1,local_8,piVar4,0,param_5,param_8);
  (**(code **)(*piVar4 + 4))();
  return uVar8;
}


/* ==== FUNCTION FUN_10001f40 @ 10001f40 size=16 ==== */

void FUN_10001f40(void)

{
  FUN_10001c90();
  return;
}


/* ==== FUNCTION FUN_10001f50 @ 10001f50 size=189 ==== */

int * __thiscall FUN_10001f50(void *this,int param_1)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int local_28 [9];
  
  local_28[0] = 7;
  *(int *)((int)this + 0x38) = param_1;
  local_28[1] = 10;
  local_28[2] = 0xd;
  local_28[3] = 0x12;
  local_28[4] = 0x17;
  local_28[5] = 0x1e;
  local_28[6] = 0x23;
  local_28[7] = 0x28;
  local_28[8] = 0x2d;
  iVar3 = 1;
  iVar1 = 0;
  do {
    iVar3 = iVar3 + 1;
    iVar2 = iVar1 + 4;
    *(int *)((int)&DAT_1000e29c + iVar1) =
         *(int *)((int)local_28 + iVar1) * iVar3 + *(int *)((int)&DAT_1000e298 + iVar1);
    iVar1 = iVar2;
  } while (iVar2 < 0x24);
  *(undefined4 *)this = DAT_1000f608;
  *(undefined4 *)((int)this + 0xc) = 0;
  FUN_10002090(this,1);
  *(undefined4 *)((int)this + 0x2c) = 0;
  *(undefined4 *)((int)this + 0x34) = 0;
  *(undefined4 *)((int)this + 0x30) = *(undefined4 *)(s_Arial_1000e290 + *(int *)this * 4 + 4);
  FUN_10002030(this);
  return this;
}


/* ==== FUNCTION FUN_10002010 @ 10002010 size=28 ==== */

void __fastcall FUN_10002010(int param_1)

{
  (**(code **)(*DAT_1000f5bc + 0x1c))(*(undefined4 *)(param_1 + 0xc));
  (**(code **)(**(int **)(param_1 + 0xc) + 4))();
  return;
}


/* ==== FUNCTION FUN_10002030 @ 10002030 size=94 ==== */

void __fastcall FUN_10002030(void *param_1)

{
  int iVar1;
  undefined4 uVar2;
  longlong lVar3;
  undefined4 uVar4;
  
  *(undefined1 *)((int)param_1 + 4) = 0;
  *(float *)((int)param_1 + 0x10) = 248.0 - (float)*(int *)((int)param_1 + 0x20) * 0.5;
  *(float *)((int)param_1 + 0x14) = 208.0 - (float)*(int *)((int)param_1 + 0x24) * 0.5;
  FUN_10002090(param_1,1);
  uVar4 = 0;
  iVar1 = **(int **)((int)param_1 + 0xc);
  lVar3 = __ftol();
  uVar2 = (undefined4)lVar3;
  lVar3 = __ftol();
  (**(code **)(iVar1 + 8))((int)lVar3,uVar2,uVar4);
  *(undefined4 *)((int)param_1 + 0x18) = 0;
  *(undefined4 *)((int)param_1 + 0x1c) = 0;
  return;
}


/* ==== FUNCTION FUN_10002090 @ 10002090 size=124 ==== */

void __thiscall FUN_10002090(void *this,undefined1 param_1)

{
  undefined4 uVar1;
  
  *(undefined1 *)((int)this + 0x28) = param_1;
  if (*(int *)((int)this + 0xc) != 0) {
    (**(code **)(*DAT_1000f5bc + 0x1c))(*(int *)((int)this + 0xc));
    (**(code **)(**(int **)((int)this + 0xc) + 4))();
  }
  if (*(char *)((int)this + 0x28) == '\0') {
    uVar1 = *(undefined4 *)(DAT_1000f5cc + 0x7c + *(int *)this * 4);
  }
  else {
    uVar1 = *(undefined4 *)(DAT_1000f5cc + 0x54 + *(int *)this * 4);
  }
  uVar1 = (**(code **)(*DAT_1000f5b0 + 8))(uVar1,0);
  *(undefined4 *)((int)this + 0xc) = uVar1;
  (**(code **)(*DAT_1000f5bc + 0x18))(uVar1);
  (**(code **)(**(int **)((int)this + 0xc) + 0x2c))();
  (**(code **)(**(int **)((int)this + 0xc) + 0x48))((int)this + 0x20,(int)this + 0x24);
  return;
}


/* ==== FUNCTION FUN_10002110 @ 10002110 size=516 ==== */

void __thiscall FUN_10002110(void *this,undefined4 param_1)

{
  float fVar1;
  float fVar2;
  float local_c;
  float local_8;
  
  local_c = 0.1;
  local_8 = 1.0;
  switch(param_1) {
  case 1:
    if (*(char *)((int)this + 0x28) == '\0') {
      FUN_10002090(this,1);
    }
    if (((byte)DAT_1000f5f0 & 0xc) != 0) {
      local_c = 0.070700005;
      local_8 = 0.707;
    }
    local_8 = -local_8;
    if (0.0 < *(float *)((int)this + 0x18)) {
      fVar1 = *(float *)((int)this + 0x18) - (local_c + local_c);
      if (local_8 <= fVar1) {
        local_8 = fVar1;
      }
      *(float *)((int)this + 0x18) = local_8;
      FUN_10002330((int)this);
      return;
    }
    local_c = *(float *)((int)this + 0x18) - local_c;
    if (local_8 <= local_c) {
      local_8 = local_c;
    }
    *(float *)((int)this + 0x18) = local_8;
    FUN_10002330((int)this);
    return;
  case 2:
    if (*(char *)((int)this + 0x28) != '\0') {
      FUN_10002090(this,0);
    }
    if (((byte)DAT_1000f5f0 & 0xc) != 0) {
      local_c = 0.070700005;
      local_8 = 0.707;
    }
    if (*(float *)((int)this + 0x18) < 0.0) {
      local_c = local_c + local_c;
    }
    local_c = local_c + *(float *)((int)this + 0x18);
    if (local_8 < local_c) {
      local_c = local_8;
    }
    *(float *)((int)this + 0x18) = local_c;
    FUN_10002330((int)this);
    return;
  case 3:
    if (((byte)DAT_1000f5f0 & 3) != 0) {
      local_c = 0.070700005;
      local_8 = 0.707;
    }
    fVar1 = -local_8;
    if (*(float *)((int)this + 0x1c) <= 0.0) {
      local_c = *(float *)((int)this + 0x1c) - local_c;
      if (fVar1 <= local_c) {
        *(float *)((int)this + 0x1c) = local_c;
        FUN_10002330((int)this);
        return;
      }
    }
    else {
      fVar2 = *(float *)((int)this + 0x1c) - (local_c + local_c);
      if (fVar1 <= fVar2) {
        *(float *)((int)this + 0x1c) = fVar2;
        FUN_10002330((int)this);
        return;
      }
    }
    break;
  case 4:
    if (((byte)DAT_1000f5f0 & 3) != 0) {
      local_c = 0.070700005;
      local_8 = 0.707;
    }
    if (0.0 <= *(float *)((int)this + 0x1c)) {
      fVar1 = local_c + *(float *)((int)this + 0x1c);
    }
    else {
      fVar1 = local_c + local_c + *(float *)((int)this + 0x1c);
    }
    if (local_8 < fVar1) {
      fVar1 = local_8;
    }
    break;
  default:
    goto switchD_10002138_default;
  }
  *(float *)((int)this + 0x1c) = fVar1;
switchD_10002138_default:
  FUN_10002330((int)this);
  return;
}


/* ==== FUNCTION FUN_10002330 @ 10002330 size=321 ==== */

void __fastcall FUN_10002330(int param_1)

{
  int iVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  float fVar8;
  float fVar9;
  undefined4 uVar10;
  longlong lVar11;
  undefined4 uVar12;
  
  if ((DAT_1000f5d4 & 1) == 0) {
    DAT_1000f5d0 = DAT_1000f5e0;
    DAT_1000f5d4 = DAT_1000f5d4 | 1;
  }
  fVar2 = (float)(uint)(DAT_1000f5e0 - DAT_1000f5d0) * *(float *)(param_1 + 0x18) * 0.1;
  fVar3 = (float)(uint)(DAT_1000f5e0 - DAT_1000f5d0) * *(float *)(param_1 + 0x1c) * 0.1;
  fVar6 = (float)(*(int *)(param_1 + 0x20) / 2);
  fVar7 = (*(float *)(param_1 + 0x10) - 245.0) + fVar6 + fVar2;
  fVar8 = (float)(*(int *)(param_1 + 0x24) / 2);
  fVar4 = (*(float *)(param_1 + 0x14) - 209.0) + fVar8 + fVar3;
  fVar5 = fVar7 * fVar7 + fVar4 * fVar4;
  fVar9 = 205.0 - (float)*(int *)(param_1 + 0x20) * 0.5;
  fVar9 = fVar9 * fVar9;
  if (fVar5 < fVar9) {
    *(float *)(param_1 + 0x10) = fVar2 + *(float *)(param_1 + 0x10);
    *(float *)(param_1 + 0x14) = fVar3 + *(float *)(param_1 + 0x14);
  }
  else {
    *(undefined4 *)(param_1 + 0x18) = 0;
    *(undefined4 *)(param_1 + 0x1c) = 0;
    *(float *)(param_1 + 0x10) = ((fVar9 * fVar7) / fVar5 + 245.0) - fVar6;
    *(float *)(param_1 + 0x14) = ((fVar9 * fVar4) / fVar5 + 209.0) - fVar8;
  }
  uVar12 = 0;
  iVar1 = **(int **)(param_1 + 0xc);
  lVar11 = __ftol();
  uVar10 = (undefined4)lVar11;
  lVar11 = __ftol();
  (**(code **)(iVar1 + 8))((int)lVar11,uVar10,uVar12);
  DAT_1000f5d0 = DAT_1000f5e0;
  return;
}


/* ==== FUNCTION FUN_10002480 @ 10002480 size=81 ==== */

void __thiscall FUN_10002480(void *this,int *param_1)

{
  int iVar1;
  longlong lVar2;
  
  lVar2 = __ftol();
  *param_1 = (int)lVar2 - *(int *)((int)this + 0x20) / 2;
  lVar2 = __ftol();
  iVar1 = (int)lVar2 - *(int *)((int)this + 0x24) / 2;
  param_1[1] = iVar1;
  param_1[2] = *param_1 + *(int *)((int)this + 0x20);
  param_1[3] = iVar1 + *(int *)((int)this + 0x24);
  return;
}


/* ==== FUNCTION FUN_100024e0 @ 100024e0 size=265 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __thiscall FUN_100024e0(void *this,int *param_1)

{
  uint uVar1;
  int iVar2;
  longlong lVar3;
  
  iVar2 = *param_1;
  if (*(int *)this < iVar2) {
    return CONCAT31((int3)((uint)iVar2 >> 8),1);
  }
  *(int *)((int)this + 0x2c) = *(int *)((int)this + 0x2c) + iVar2;
  *(int *)(*(int *)((int)this + 0x38) + 8) = *(int *)(*(int *)((int)this + 0x38) + 8) + iVar2 * 10;
  FUN_10003ad0();
  (**(code **)(**(int **)(DAT_1000f5cc + 0xdc) + 8))(0);
  uVar1 = *(uint *)((int)this + 0x2c);
  if (*(int *)((int)this + 0x30) <= (int)uVar1) {
    (**(code **)(**(int **)(DAT_1000f5cc + 0xe0) + 8))(0);
    iVar2 = *(int *)this;
    if (iVar2 == 9) {
      lVar3 = __ftol();
      *(int *)((int)this + 0x30) = (int)lVar3;
      FUN_10003670(DAT_1000f5e4);
    }
    else {
      *(undefined4 *)((int)this + 0x30) = (&DAT_1000e298)[iVar2];
      *(int *)this = iVar2 + 1;
      _DAT_1000f5dc = _DAT_1000f5dc + 1;
    }
    FUN_10002090(this,*(undefined1 *)((int)this + 0x28));
    iVar2 = *(int *)((int)this + 0x34) + 1;
    *(int *)((int)this + 0x34) = iVar2;
    if (iVar2 % 3 == 0) {
      *(int *)(*(int *)((int)this + 0x38) + 0x1a4) =
           *(int *)(*(int *)((int)this + 0x38) + 0x1a4) + 1;
      FUN_10003a60();
      (**(code **)(**(int **)(DAT_1000f5cc + 0xf0) + 8))(0);
    }
    FUN_10003bc0(DAT_1000f5e4);
    uVar1 = FUN_10003670(DAT_1000f5e4);
  }
  return uVar1 & 0xffffff00;
}


/* ==== FUNCTION Shell_StartApplet @ 100025f0 size=57 ==== */

void __cdecl Shell_StartApplet(int *param_1)

{
  void *this;
  
                    /* 0x25f0  1  Shell_StartApplet */
  this = operator_new(0xf4);
  if (this == (void *)0x0) {
    DAT_1000f5d8 = (void *)0x0;
  }
  else {
    DAT_1000f5d8 = FUN_100016a0(this,param_1);
  }
  (**(code **)(*(int *)param_1[5] + 8))(s_Moeboid_1000e360);
  return;
}


/* ==== FUNCTION Shell_StopApplet @ 10002630 size=34 ==== */

undefined4 Shell_StopApplet(void)

{
  int *piVar1;
  
                    /* 0x2630  2  Shell_StopApplet */
  piVar1 = DAT_1000f5d8;
  if (DAT_1000f5d8 != (int *)0x0) {
    FUN_10001b50(DAT_1000f5d8);
    FUN_10005197(piVar1);
    return 0;
  }
  return 0;
}


/* ==== FUNCTION FUN_10002660 @ 10002660 size=21 ==== */

void __thiscall FUN_10002660(void *this,undefined4 param_1)

{
  *(undefined ***)this = &PTR_FUN_1000d150;
  *(undefined4 *)((int)this + 4) = param_1;
  return;
}


/* ==== FUNCTION FUN_10002680 @ 10002680 size=33 ==== */

undefined4 * __thiscall FUN_10002680(void *this,byte param_1)

{
  FUN_100026b0(this);
  if ((param_1 & 1) != 0) {
    FUN_10005197(this);
  }
  return this;
}


/* ==== FUNCTION FUN_100026b0 @ 100026b0 size=7 ==== */

void __fastcall FUN_100026b0(undefined4 *param_1)

{
  *param_1 = &PTR_FUN_1000d150;
  return;
}


/* ==== FUNCTION FUN_100026c0 @ 100026c0 size=498 ==== */

undefined4 * __thiscall FUN_100026c0(void *this,undefined4 param_1)

{
  undefined4 uVar1;
  void *this_00;
  uint uVar2;
  int *piVar3;
  int iVar4;
  undefined **ppuVar5;
  byte local_3fc [1000];
  void *local_14;
  void *local_10;
  undefined1 *puStack_c;
  undefined4 local_8;
  
  local_8 = 0xffffffff;
  puStack_c = &LAB_1000c5a3;
  local_10 = ExceptionList;
  ExceptionList = &local_10;
  local_14 = this;
  FUN_10002660(this,param_1);
  *(undefined ***)this = &PTR_FUN_1000d154;
  DAT_1000f605 = 1;
  local_8._0_1_ = 0;
  local_8._1_3_ = 0;
  (**(code **)(*DAT_1000f5b8 + 0x40))(*(undefined4 *)(*(int *)((int)this + 4) + 0xc0),0,0);
  (**(code **)(*DAT_1000f5b8 + 0x1c))(0xff,0x99,0x33);
  (**(code **)(*DAT_1000f5b8 + 0x10))(0,0,0x46,0x28);
  (**(code **)(*DAT_1000f5b8 + 0x10))(0x1ac,0x177,500,0x1a4);
  (**(code **)(*DAT_1000f5b8 + 0x1c))(0,0,0);
  (**(code **)(*DAT_1000f5b8 + 0x10))(0x1ac,0,500,0x28);
  uVar1 = FUN_10001de0(DAT_1000f5bc,&DAT_1000e540,0x1ac,0x181,0,0x12,this,FUN_10002a60);
  *(undefined4 *)((int)this + 0x19c) = uVar1;
  FUN_10004a00(DAT_1000f5b8,(byte *)s_<S2><c><b><c000000><u>The_ZapSpo_1000e50c,(int *)0x0,0x1e);
  iVar4 = 0x32;
  ppuVar5 = &PTR_s_Adam_Smith_1000e368;
  do {
    FUN_100051b0(local_3fc,(byte *)s_<S3><c><b><c000000>_s<_b><_c>_1000e4ec);
    FUN_10004a00(DAT_1000f5b8,local_3fc,(int *)0x0,iVar4);
    ppuVar5 = ppuVar5 + 1;
    iVar4 = iVar4 + 0x10;
  } while ((int)ppuVar5 < 0x1000e3c0);
  *(undefined4 *)((int)this + 0x198) = 0;
  do {
    this_00 = operator_new(0x38);
    local_8._0_1_ = 1;
    if (this_00 == (void *)0x0) {
      piVar3 = (int *)0x0;
    }
    else {
      uVar2 = (**(code **)(*DAT_1000f5b4 + 8))();
      piVar3 = FUN_100011a0(this_00,uVar2 % 10 + 1);
    }
    local_8._0_1_ = 0;
    *(int **)((int)this + *(int *)((int)this + 0x198) * 4 + 8) = piVar3;
    iVar4 = *(int *)((int)this + 0x198) + 1;
    *(int *)((int)this + 0x198) = iVar4;
  } while (iVar4 < 100);
  piVar3 = (int *)(**(code **)(*DAT_1000f5b0 + 0x34))(this,0x14,FUN_10002a70);
  *(int **)((int)this + 0x1a0) = piVar3;
  (**(code **)(*piVar3 + 8))();
  ExceptionList = local_10;
  return this;
}


/* ==== FUNCTION FUN_100028c0 @ 100028c0 size=33 ==== */

undefined4 * __thiscall FUN_100028c0(void *this,byte param_1)

{
  FUN_100028f0(this);
  if ((param_1 & 1) != 0) {
    FUN_10005197(this);
  }
  return this;
}


/* ==== FUNCTION FUN_100028f0 @ 100028f0 size=176 ==== */

void __fastcall FUN_100028f0(undefined4 *param_1)

{
  LPVOID pvVar1;
  int iVar2;
  undefined4 *local_14;
  void *local_10;
  undefined1 *puStack_c;
  undefined4 local_8;
  
  puStack_c = &LAB_1000c5b8;
  local_10 = ExceptionList;
  ExceptionList = &local_10;
  *param_1 = &PTR_FUN_1000d154;
  iVar2 = 0;
  local_8 = 0;
  (**(code **)(*DAT_1000f5bc + 0x1c))(param_1[0x67]);
  (**(code **)(*(int *)param_1[0x67] + 4))();
  if (0 < (int)param_1[0x66]) {
    local_14 = param_1 + 2;
    do {
      pvVar1 = (LPVOID)*local_14;
      if (pvVar1 != (LPVOID)0x0) {
        FUN_10001340((int)pvVar1);
        FUN_10005197(pvVar1);
      }
      iVar2 = iVar2 + 1;
      local_14 = local_14 + 1;
    } while (iVar2 < (int)param_1[0x66]);
  }
  (**(code **)(*(int *)param_1[0x68] + 4))();
  local_8 = 0xffffffff;
  FUN_100026b0(param_1);
  ExceptionList = local_10;
  return;
}


/* ==== FUNCTION FUN_100029a0 @ 100029a0 size=103 ==== */

undefined4 __fastcall FUN_100029a0(undefined4 *param_1)

{
  void *this;
  undefined4 *puVar1;
  void *local_10;
  undefined1 *puStack_c;
  undefined4 local_8;
  
  local_8 = 0xffffffff;
  puStack_c = &LAB_1000c5db;
  local_10 = ExceptionList;
  ExceptionList = &local_10;
  this = operator_new(0x20);
  local_8 = 0;
  if (this == (void *)0x0) {
    puVar1 = (undefined4 *)0x0;
  }
  else {
    puVar1 = FUN_100041a0(this,param_1[1]);
  }
  local_8 = 0xffffffff;
  FUN_10001db0((void *)param_1[1],param_1,puVar1);
  ExceptionList = local_10;
  return 0;
}


/* ==== FUNCTION FUN_10002a10 @ 10002a10 size=80 ==== */

undefined4 __thiscall FUN_10002a10(void *this,int param_1)

{
  int iVar1;
  undefined4 *puVar2;
  
  DAT_1000f5e0 = *(undefined4 *)(param_1 + 8);
  iVar1 = 0;
  if (0 < *(int *)((int)this + 0x198)) {
    puVar2 = (undefined4 *)((int)this + 8);
    do {
      FUN_10001380((void *)*puVar2,*(int *)(param_1 + 8));
      iVar1 = iVar1 + 1;
      puVar2 = puVar2 + 1;
    } while (iVar1 < *(int *)((int)this + 0x198));
    return 0;
  }
  return 0;
}


/* ==== FUNCTION FUN_10002a60 @ 10002a60 size=16 ==== */

void __cdecl FUN_10002a60(undefined4 *param_1)

{
  FUN_100029a0((undefined4 *)*param_1);
  return;
}


/* ==== FUNCTION FUN_10002a70 @ 10002a70 size=16 ==== */

void __cdecl FUN_10002a70(undefined4 *param_1)

{
  FUN_10002a10((void *)*param_1,(int)param_1);
  return;
}


/* ==== FUNCTION FUN_10002a80 @ 10002a80 size=565 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 * __thiscall FUN_10002a80(void *this,undefined4 param_1)

{
  void *pvVar1;
  int *piVar2;
  undefined4 uVar3;
  uint uVar4;
  int iVar5;
  void *local_10;
  undefined1 *puStack_c;
  int local_8;
  
  local_8 = 0xffffffff;
  puStack_c = &LAB_1000c60e;
  local_10 = ExceptionList;
  ExceptionList = &local_10;
  FUN_10002660(this,param_1);
  *(undefined ***)this = &PTR_FUN_1000d158;
  DAT_1000f605 = 0;
  DAT_1000f5e0 = 0;
  DAT_1000f5cc = param_1;
  DAT_1000f5e4 = this;
  *(undefined4 *)((int)this + 0x1bc) = 0;
  local_8 = 0;
  (**(code **)(*DAT_1000f5b8 + 0x40))(*(undefined4 *)(*(int *)((int)this + 4) + 0xc0),0,0);
  *(undefined4 *)((int)this + 8) = 0;
  *(undefined4 *)((int)this + 0x1a4) = 2;
  _DAT_1000f5dc = DAT_1000f608;
  pvVar1 = operator_new(0x3c);
  local_8._0_1_ = 1;
  if (pvVar1 == (void *)0x0) {
    piVar2 = (int *)0x0;
  }
  else {
    piVar2 = FUN_10001f50(pvVar1,(int)this);
  }
  *(int **)((int)this + 0xc) = piVar2;
  *(undefined4 *)((int)this + 0x1a0) = 0;
  local_8 = (uint)local_8._1_3_ << 8;
  if (0 < *piVar2 * 2 + 4) {
    do {
      uVar4 = **(uint **)((int)this + 0xc);
      if ((int)(uVar4 * 2 + 4) / 3 <= *(int *)((int)this + 0x1a0)) {
        uVar4 = (**(code **)(*DAT_1000f5b4 + 8))();
        uVar4 = uVar4 % **(uint **)((int)this + 0xc);
      }
      pvVar1 = operator_new(0x38);
      local_8._0_1_ = 2;
      if (pvVar1 == (void *)0x0) {
        piVar2 = (int *)0x0;
      }
      else {
        piVar2 = FUN_100011a0(pvVar1,uVar4 + 1);
      }
      local_8 = (uint)local_8._1_3_ << 8;
      *(int **)((int)this + *(int *)((int)this + 0x1a0) * 4 + 0x10) = piVar2;
      iVar5 = *(int *)((int)this + 0x1a0) + 1;
      *(int *)((int)this + 0x1a0) = iVar5;
    } while (iVar5 < **(int **)((int)this + 0xc) * 2 + 4);
  }
  *(undefined1 *)((int)this + 0x1c0) = 0;
  *(undefined1 *)((int)this + 0x1c1) = 0;
  *(undefined1 *)((int)this + 0x1c2) = 0;
  *(undefined1 *)((int)this + 0x1c3) = 0;
  *(undefined4 *)((int)this + 0x1c4) = 0;
  *(undefined4 *)((int)this + 0x1c8) = 0;
  *(undefined4 *)((int)this + 0x1cc) = 0;
  *(undefined4 *)((int)this + 0x1d0) = 0;
  *(undefined4 *)((int)this + 0x1e4) = 0;
  *(undefined4 *)((int)this + 0x1e0) = 0;
  uVar3 = (**(code **)(*DAT_1000f5b0 + 0x44))(DAT_1000f5c8,0xb,this,FUN_100031f0);
  *(undefined4 *)((int)this + 0x1b4) = uVar3;
  piVar2 = (int *)(**(code **)(*DAT_1000f5b0 + 0x34))(this,0x14,FUN_100031e0);
  *(int **)((int)this + 0x1b0) = piVar2;
  (**(code **)(*piVar2 + 8))();
  FUN_10003a60();
  FUN_10003ad0();
  FUN_10003bc0((int)this);
  *(undefined1 *)((int)this + 0x1ad) = 0;
  *(undefined1 *)((int)this + 0x1ae) = 0;
  *(undefined1 *)((int)this + 0x1ac) = 0;
  uVar4 = (**(code **)(*DAT_1000f5b4 + 8))();
  *(undefined4 *)((int)this + 0x1d8) = 0;
  *(undefined4 *)((int)this + 0x1dc) = 0;
  *(uint *)((int)this + 0x1a8) = uVar4 % 4000 + 3000;
  (**(code **)(*DAT_1000f5c8 + 0xc))(1);
  ExceptionList = local_10;
  return this;
}


/* ==== FUNCTION FUN_10002cc0 @ 10002cc0 size=33 ==== */

undefined4 * __thiscall FUN_10002cc0(void *this,byte param_1)

{
  FUN_10002cf0(this);
  if ((param_1 & 1) != 0) {
    FUN_10005197(this);
  }
  return this;
}


/* ==== FUNCTION FUN_10002cf0 @ 10002cf0 size=295 ==== */

void __fastcall FUN_10002cf0(undefined4 *param_1)

{
  LPVOID pvVar1;
  int iVar2;
  undefined4 *local_14;
  void *local_10;
  undefined1 *puStack_c;
  undefined4 local_8;
  
  puStack_c = &LAB_1000c628;
  local_10 = ExceptionList;
  ExceptionList = &local_10;
  *param_1 = &PTR_FUN_1000d158;
  iVar2 = 0;
  local_8 = 0;
  (**(code **)(*(int *)param_1[0x6c] + 4))();
  if (0 < (int)param_1[0x68]) {
    local_14 = param_1 + 4;
    do {
      pvVar1 = (LPVOID)*local_14;
      if (pvVar1 != (LPVOID)0x0) {
        FUN_10001340((int)pvVar1);
        FUN_10005197(pvVar1);
      }
      iVar2 = iVar2 + 1;
      local_14 = local_14 + 1;
    } while (iVar2 < (int)param_1[0x68]);
  }
  pvVar1 = (LPVOID)param_1[3];
  if (pvVar1 != (LPVOID)0x0) {
    FUN_10002010((int)pvVar1);
    FUN_10005197(pvVar1);
  }
  if ((int *)param_1[0x76] != (int *)0x0) {
    (**(code **)(*(int *)param_1[0x76] + 4))();
  }
  if (param_1[0x78] != 0) {
    (**(code **)(*DAT_1000f5bc + 0x1c))(param_1[0x78]);
    (**(code **)(*(int *)param_1[0x78] + 4))();
  }
  if (param_1[0x79] != 0) {
    (**(code **)(*DAT_1000f5bc + 0x1c))(param_1[0x79]);
    (**(code **)(*(int *)param_1[0x79] + 4))();
  }
  if (param_1[0x77] != 0) {
    (**(code **)(*DAT_1000f5bc + 0x1c))(param_1[0x77]);
    (**(code **)(*(int *)param_1[0x77] + 4))();
  }
  (**(code **)(*(int *)param_1[0x6d] + 4))();
  local_8 = 0xffffffff;
  FUN_100026b0(param_1);
  ExceptionList = local_10;
  return;
}


/* ==== FUNCTION FUN_10002e20 @ 10002e20 size=121 ==== */

undefined4 __thiscall FUN_10002e20(void *this,int param_1)

{
  int iVar1;
  undefined1 local_10 [4];
  undefined4 local_c;
  undefined4 local_8;
  
  if (*(int *)((int)this + 0x1bc) == 1) {
    iVar1 = *(int *)(param_1 + 8);
    if ((iVar1 == 0x59) || (iVar1 == 0x79)) {
      local_8 = 0;
      local_c = 0;
      FUN_10003f60(this,(int)local_10);
    }
    else if ((iVar1 == 0x4e) || (iVar1 == 0x6e)) {
      local_8 = 1;
      local_c = 1;
      FUN_10003f60(this,(int)local_10);
      return 0;
    }
  }
  else if ((*(int *)((int)this + 0x1bc) == 2) && (*(int *)(param_1 + 8) == 0x20)) {
    FUN_10004000((int)this);
    return 0;
  }
  return 0;
}


/* ==== FUNCTION FUN_10002ea0 @ 10002ea0 size=644 ==== */

undefined4 __thiscall FUN_10002ea0(void *this,int param_1)

{
  uint uVar1;
  undefined4 uVar2;
  int iVar3;
  undefined4 *puVar4;
  void *local_8;
  
  DAT_1000f5e0 = *(undefined4 *)(param_1 + 8);
  *(undefined4 *)((int)this + 0x1d4) = DAT_1000f5e0;
  local_8 = this;
  if (DAT_1000f5ec == '\0') {
    if (*(int *)((int)this + 0x1bc) != 0) {
      return 0;
    }
    if (*(uint *)((int)this + 0x1a8) < *(uint *)((int)this + 0x1d4)) {
      (**(code **)(**(int **)(DAT_1000f5cc + 0xec) + 8))(0);
      uVar1 = (**(code **)(*DAT_1000f5b4 + 8))();
      *(uint *)((int)this + 0x1a8) = *(int *)((int)this + 0x1a8) + uVar1 % 4000 + 5000;
    }
    uVar2 = FUN_10003460((int)this);
    if (((char)uVar2 != '\0') && (DAT_1000f604 == '\0')) {
      iVar3 = *(int *)((int)this + 0x1a4) + -1;
      *(int *)((int)this + 0x1a4) = iVar3;
      if (-1 < iVar3) {
        (**(code **)(**(int **)(DAT_1000f5cc + 0xd8) + 8))(0);
        *(undefined1 *)((int)this + 0x1ad) = 1;
        FUN_10003130((int)this);
        return 0;
      }
      uVar2 = FUN_100037d0((int)this);
      if ((char)uVar2 == '\0') {
        (**(code **)(**(int **)(DAT_1000f5cc + 0xcc) + 8))(0);
      }
      *(undefined1 *)((int)this + 0x1ae) = 1;
      FUN_10003130((int)this);
      return 0;
    }
    FUN_10003200((int)this);
    FUN_10002330(*(int *)((int)this + 0xc));
    iVar3 = 0;
    if (0 < *(int *)((int)this + 0x1a0)) {
      puVar4 = (undefined4 *)((int)this + 0x10);
      do {
        FUN_10001380((void *)*puVar4,*(int *)((int)this + 0x1d4));
        iVar3 = iVar3 + 1;
        puVar4 = puVar4 + 1;
      } while (iVar3 < *(int *)((int)this + 0x1a0));
    }
    return 0;
  }
  if ((*(char *)((int)this + 0x1ac) == '\0') &&
     (1000 < (uint)(*(int *)((int)this + 0x1d4) - DAT_1000f5f8))) {
    if (*(char *)((int)this + 0x1ad) != '\0') {
      FUN_10003d80(this);
      *(undefined1 *)((int)this + 0x1ac) = 1;
      return 0;
    }
    if (*(char *)((int)this + 0x1ae) != '\0') {
      FUN_10003e70(this);
    }
    *(undefined1 *)((int)this + 0x1ac) = 1;
    return 0;
  }
  if (2000 < (uint)(*(int *)((int)this + 0x1d4) - DAT_1000f5f8)) {
    (**(code **)(*DAT_1000f5bc + 0x1c))(DAT_1000f5e8);
    (**(code **)(*DAT_1000f5e8 + 4))();
    DAT_1000f5ec = 0;
    return 0;
  }
  if (5 < (int)((DAT_1000f5f4 ^ (int)DAT_1000f5f4 >> 0x1f) - ((int)DAT_1000f5f4 >> 0x1f))) {
    DAT_1000f5fc = -DAT_1000f5fc;
  }
  DAT_1000f5f4 = DAT_1000f5f4 + DAT_1000f5fc;
  (**(code **)(*DAT_1000f5e8 + 0xc))(&param_1,&local_8);
  uVar1 = FUN_10005639();
  if ((int)uVar1 % 3 == 1) {
    param_1 = param_1 + 1;
  }
  if (DAT_1000f5fc < 0) {
    (**(code **)(*DAT_1000f5e8 + 8))(param_1 + -1,(int)local_8 + -1);
    return 0;
  }
  (**(code **)(*DAT_1000f5e8 + 8))(param_1 + 1,(int)local_8 + -1,0);
  return 0;
}


/* ==== FUNCTION FUN_10003130 @ 10003130 size=165 ==== */

void __fastcall FUN_10003130(int param_1)

{
  int iVar1;
  int iVar2;
  int iVar3;
  longlong lVar4;
  undefined4 uVar5;
  
  DAT_1000f5ec = 1;
  DAT_1000f5f8 = *(undefined4 *)(param_1 + 0x1d4);
  *(undefined1 *)(param_1 + 0x1ac) = 0;
  DAT_1000f5fc = 1;
  DAT_1000f5f4 = 0;
  DAT_1000f5e8 = (int *)(**(code **)(*DAT_1000f5b0 + 8))(*(undefined4 *)(DAT_1000f5cc + 0xc4),0);
  (**(code **)(*DAT_1000f5bc + 0x18))(DAT_1000f5e8);
  (**(code **)(*DAT_1000f5e8 + 0x2c))();
  iVar1 = *(int *)(param_1 + 0xc);
  uVar5 = 0;
  iVar3 = *(int *)(iVar1 + 0x24);
  iVar2 = *DAT_1000f5e8;
  lVar4 = __ftol();
  iVar3 = (int)lVar4 - iVar3 / 2;
  iVar1 = *(int *)(iVar1 + 0x20);
  lVar4 = __ftol();
  (**(code **)(iVar2 + 8))((int)lVar4 - iVar1 / 2,iVar3,uVar5);
  return;
}


/* ==== FUNCTION FUN_100031e0 @ 100031e0 size=16 ==== */

void __cdecl FUN_100031e0(undefined4 *param_1)

{
  FUN_10002ea0((void *)*param_1,(int)param_1);
  return;
}


/* ==== FUNCTION FUN_100031f0 @ 100031f0 size=16 ==== */

void __cdecl FUN_100031f0(undefined4 *param_1)

{
  FUN_10002e20((void *)*param_1,(int)param_1);
  return;
}


/* ==== FUNCTION FUN_10003200 @ 10003200 size=540 ==== */

void __fastcall FUN_10003200(int param_1)

{
  uint uVar1;
  
  if (*(char *)(param_1 + 0x1c0) == '\0') {
    uVar1 = (**(code **)(*DAT_1000f5c8 + 0x20))(7);
    if ((uVar1 & 0x80) != 0) {
      *(undefined4 *)(param_1 + 0x1c4) = *(undefined4 *)(param_1 + 0x1d4);
      *(undefined1 *)(param_1 + 0x1c0) = 1;
      FUN_10002110(*(void **)(param_1 + 0xc),2);
      DAT_1000f5f0 = DAT_1000f5f0 | 2;
    }
  }
  else {
    uVar1 = (**(code **)(*DAT_1000f5c8 + 0x20))(7);
    if ((uVar1 & 0x80) == 0) {
      *(undefined1 *)(param_1 + 0x1c0) = 0;
      DAT_1000f5f0 = DAT_1000f5f0 & 0xfffffffd;
    }
    else if ((10 < (uint)(*(int *)(param_1 + 0x1d4) - *(int *)(param_1 + 0x1c4))) &&
            ((DAT_1000f5f0 & 2) != 0)) {
      FUN_10002110(*(void **)(param_1 + 0xc),2);
    }
  }
  if (*(char *)(param_1 + 0x1c1) == '\0') {
    uVar1 = (**(code **)(*DAT_1000f5c8 + 0x20))(6);
    if ((uVar1 & 0x80) != 0) {
      *(undefined4 *)(param_1 + 0x1c8) = *(undefined4 *)(param_1 + 0x1d4);
      *(undefined1 *)(param_1 + 0x1c1) = 1;
      FUN_10002110(*(void **)(param_1 + 0xc),1);
      DAT_1000f5f0 = DAT_1000f5f0 | 1;
    }
  }
  else {
    uVar1 = (**(code **)(*DAT_1000f5c8 + 0x20))();
    if ((uVar1 & 0x80) == 0) {
      *(undefined1 *)(param_1 + 0x1c1) = 0;
      DAT_1000f5f0 = DAT_1000f5f0 & 0xfffffffe;
    }
    else if ((10 < (uint)(*(int *)(param_1 + 0x1d4) - *(int *)(param_1 + 0x1c8))) &&
            ((DAT_1000f5f0 & 1) != 0)) {
      FUN_10002110(*(void **)(param_1 + 0xc),1);
    }
  }
  if (*(char *)(param_1 + 0x1c2) == '\0') {
    uVar1 = (**(code **)(*DAT_1000f5c8 + 0x20))(8);
    if ((uVar1 & 0x80) != 0) {
      *(undefined4 *)(param_1 + 0x1cc) = *(undefined4 *)(param_1 + 0x1d4);
      *(undefined1 *)(param_1 + 0x1c2) = 1;
      FUN_10002110(*(void **)(param_1 + 0xc),3);
      DAT_1000f5f0 = DAT_1000f5f0 | 4;
    }
  }
  else {
    uVar1 = (**(code **)(*DAT_1000f5c8 + 0x20))();
    if ((uVar1 & 0x80) == 0) {
      *(undefined1 *)(param_1 + 0x1c2) = 0;
      DAT_1000f5f0 = DAT_1000f5f0 & 0xfffffffb;
    }
    else if ((10 < (uint)(*(int *)(param_1 + 0x1d4) - *(int *)(param_1 + 0x1cc))) &&
            ((DAT_1000f5f0 & 4) != 0)) {
      FUN_10002110(*(void **)(param_1 + 0xc),3);
    }
  }
  if (*(char *)(param_1 + 0x1c3) == '\0') {
    uVar1 = (**(code **)(*DAT_1000f5c8 + 0x20))(9);
    if ((uVar1 & 0x80) != 0) {
      *(undefined4 *)(param_1 + 0x1d0) = *(undefined4 *)(param_1 + 0x1d4);
      *(undefined1 *)(param_1 + 0x1c3) = 1;
      FUN_10002110(*(void **)(param_1 + 0xc),4);
      DAT_1000f5f0 = DAT_1000f5f0 | 8;
    }
  }
  else {
    uVar1 = (**(code **)(*DAT_1000f5c8 + 0x20))();
    if ((uVar1 & 0x80) == 0) {
      *(undefined1 *)(param_1 + 0x1c3) = 0;
      DAT_1000f5f0 = DAT_1000f5f0 & 0xfffffff7;
      return;
    }
    if ((10 < (uint)(*(int *)(param_1 + 0x1d4) - *(int *)(param_1 + 0x1d0))) &&
       ((DAT_1000f5f0 & 8) != 0)) {
      FUN_10002110(*(void **)(param_1 + 0xc),4);
      return;
    }
  }
  return;
}


/* ==== FUNCTION FUN_10003420 @ 10003420 size=61 ==== */

undefined4 __cdecl FUN_10003420(int *param_1,int *param_2)

{
  if ((((*param_1 <= param_2[2]) && (*param_2 <= param_1[2])) && (param_1[1] <= param_2[3])) &&
     (param_2[1] <= param_1[3])) {
    return 1;
  }
  return 0;
}


/* ==== FUNCTION FUN_10003460 @ 10003460 size=520 ==== */

uint __fastcall FUN_10003460(int param_1)

{
  LPVOID pvVar1;
  undefined4 *puVar2;
  undefined4 uVar3;
  uint uVar4;
  void *pvVar5;
  int *piVar6;
  int iVar7;
  int iVar8;
  undefined4 *puVar9;
  int local_3c [4];
  int local_2c [4];
  void *local_1c;
  undefined4 *local_18;
  int local_14;
  void *local_10;
  undefined1 *puStack_c;
  undefined4 local_8;
  
  local_8 = 0xffffffff;
  puStack_c = &LAB_1000c661;
  local_10 = ExceptionList;
  ExceptionList = &local_10;
  puVar2 = (undefined4 *)FUN_10002480(*(void **)(param_1 + 0xc),local_3c);
  iVar8 = *(int *)(param_1 + 0x1a0);
  local_14 = 0;
  if (0 < iVar8) {
    puVar2 = (undefined4 *)(param_1 + 0x10);
    iVar7 = iVar8;
    do {
      if (*(int *)*puVar2 <= **(int **)(param_1 + 0xc)) {
        local_14 = local_14 + 1;
      }
      puVar2 = puVar2 + 1;
      iVar7 = iVar7 + -1;
    } while (iVar7 != 0);
  }
  local_18 = (undefined4 *)0x0;
  if (0 < iVar8) {
    puVar9 = (undefined4 *)(param_1 + 0x10);
    do {
      FUN_10001000((void *)*puVar9,local_2c);
      uVar3 = FUN_10003420(local_3c,local_2c);
      if (((char)uVar3 != '\0') && (((int *)*puVar9)[1] == 0)) {
        uVar4 = FUN_100024e0(*(void **)(param_1 + 0xc),(int *)*puVar9);
        if ((char)uVar4 != '\0') {
          ExceptionList = local_10;
          return CONCAT31((int3)(uVar4 >> 8),1);
        }
        pvVar1 = (LPVOID)*puVar9;
        if (pvVar1 != (LPVOID)0x0) {
          FUN_10001340((int)pvVar1);
          FUN_10005197(pvVar1);
        }
        iVar8 = **(int **)(param_1 + 0xc) * 2 + 4;
        if ((int)(iVar8 + (iVar8 >> 0x1f & 3U)) >> 2 < local_14) {
          iVar8 = *(int *)(param_1 + 0x1a0) * 3;
          if (local_14 < (int)(iVar8 + (iVar8 >> 0x1f & 3U)) >> 2) {
            pvVar5 = operator_new(0x38);
            local_8 = 2;
            local_1c = pvVar5;
            if (pvVar5 == (void *)0x0) goto LAB_10003618;
            uVar4 = (**(code **)(*DAT_1000f5b4 + 8))();
            if (uVar4 % **(uint **)(param_1 + 0xc) + 1 < 10) {
              uVar4 = (**(code **)(*DAT_1000f5b4 + 8))();
              piVar6 = FUN_100011a0(pvVar5,uVar4 % **(uint **)(param_1 + 0xc) + 1);
            }
            else {
              piVar6 = FUN_100011a0(pvVar5,10);
            }
          }
          else {
            local_1c = operator_new(0x38);
            local_8 = 1;
            if (local_1c == (void *)0x0) {
LAB_10003618:
              piVar6 = (int *)0x0;
            }
            else {
              iVar8 = **(int **)(param_1 + 0xc) + 1;
              if (9 < iVar8) {
                iVar8 = 10;
              }
              piVar6 = FUN_100011a0(local_1c,iVar8);
            }
          }
        }
        else {
          pvVar5 = operator_new(0x38);
          piVar6 = (int *)0x0;
          local_8 = 0;
          local_1c = pvVar5;
          if (pvVar5 != (void *)0x0) {
            uVar4 = (**(code **)(*DAT_1000f5b4 + 8))();
            piVar6 = FUN_100011a0(pvVar5,uVar4 % **(uint **)(param_1 + 0xc) + 1);
          }
        }
        *puVar9 = piVar6;
        local_14 = local_14 + -1;
        local_8 = 0xffffffff;
      }
      puVar2 = (undefined4 *)((int)local_18 + 1);
      puVar9 = puVar9 + 1;
      local_18 = puVar2;
    } while ((int)puVar2 < *(int *)(param_1 + 0x1a0));
  }
  ExceptionList = local_10;
  return (uint)puVar2 & 0xffffff00;
}


/* ==== FUNCTION FUN_10003670 @ 10003670 size=348 ==== */

void __fastcall FUN_10003670(int param_1)

{
  undefined4 *puVar1;
  void *pvVar2;
  int *piVar3;
  uint uVar4;
  int iVar5;
  int iVar6;
  void *local_10;
  undefined1 *puStack_c;
  undefined4 local_8;
  
  local_8 = 0xffffffff;
  puStack_c = &LAB_1000c691;
  local_10 = ExceptionList;
  iVar6 = 0;
  iVar5 = *(int *)(param_1 + 0x1a0);
  if (0 < iVar5) {
    puVar1 = (undefined4 *)(param_1 + 0x10);
    do {
      if (*(int *)*puVar1 <= **(int **)(param_1 + 0xc)) {
        iVar6 = iVar6 + 1;
      }
      puVar1 = puVar1 + 1;
      iVar5 = iVar5 + -1;
    } while (iVar5 != 0);
  }
  iVar5 = **(int **)(param_1 + 0xc) * 2 + 4;
  if (iVar6 < (int)(iVar5 + (iVar5 >> 0x1f & 3U)) >> 2) {
    ExceptionList = &local_10;
    pvVar2 = operator_new(0x38);
    piVar3 = (int *)0x0;
    local_8 = 0;
    if (pvVar2 != (void *)0x0) {
      uVar4 = (**(code **)(*DAT_1000f5b4 + 8))();
      piVar3 = FUN_100011a0(pvVar2,uVar4 % **(uint **)(param_1 + 0xc) + 1);
    }
  }
  else {
    iVar5 = (**(int **)(param_1 + 0xc) * 3 + 6) * 2;
    if ((int)(iVar5 + (iVar5 >> 0x1f & 3U)) >> 2 < iVar6) {
      ExceptionList = &local_10;
      pvVar2 = operator_new(0x38);
      local_8 = 1;
      if (pvVar2 != (void *)0x0) {
        iVar5 = **(int **)(param_1 + 0xc) + 1;
        if (9 < iVar5) {
          iVar5 = 10;
        }
        piVar3 = FUN_100011a0(pvVar2,iVar5);
        goto LAB_100037a5;
      }
    }
    else {
      ExceptionList = &local_10;
      pvVar2 = operator_new(0x38);
      local_8 = 2;
      if (pvVar2 != (void *)0x0) {
        uVar4 = (**(code **)(*DAT_1000f5b4 + 8))();
        if (uVar4 % **(uint **)(param_1 + 0xc) + 1 < 10) {
          uVar4 = (**(code **)(*DAT_1000f5b4 + 8))();
          piVar3 = FUN_100011a0(pvVar2,uVar4 % **(uint **)(param_1 + 0xc) + 1);
        }
        else {
          piVar3 = FUN_100011a0(pvVar2,10);
        }
        goto LAB_100037a5;
      }
    }
    piVar3 = (int *)0x0;
  }
LAB_100037a5:
  *(int **)(param_1 + 0x10 + *(int *)(param_1 + 0x1a0) * 4) = piVar3;
  *(int *)(param_1 + 0x1a0) = *(int *)(param_1 + 0x1a0) + 1;
  ExceptionList = local_10;
  return;
}


/* ==== FUNCTION FUN_100037d0 @ 100037d0 size=647 ==== */

uint __fastcall FUN_100037d0(int param_1)

{
  char cVar1;
  uint uVar2;
  int iVar3;
  undefined4 uVar4;
  uint uVar5;
  int iVar6;
  char *pcVar7;
  char *pcVar8;
  char local_a8 [100];
  int local_44;
  undefined4 local_40;
  undefined4 local_3c;
  undefined4 local_38;
  undefined4 local_34;
  undefined4 local_30;
  undefined4 local_2c [5];
  undefined1 local_18 [20];
  
  iVar6 = 1;
  local_44 = param_1;
  while( true ) {
    FUN_100051b0(local_18,(byte *)s_Score_dScore_1000e61c);
    (**(code **)(*DAT_1000f5c4 + 0x14))(local_18,local_a8);
    uVar2 = FUN_100056e2(local_a8,(byte *)local_a8);
    if ((int)uVar2 <= *(int *)(param_1 + 8)) break;
    iVar6 = iVar6 + 1;
    if (5 < iVar6) {
      return uVar2 & 0xffffff00;
    }
  }
  (**(code **)(**(int **)(DAT_1000f5cc + 0xd0) + 8))(0);
  local_2c[0] = 0;
  local_40 = 0;
  local_2c[1] = 0;
  local_3c = 0;
  local_2c[2] = 0;
  local_38 = 0;
  local_2c[3] = 0;
  local_34 = 0;
  local_2c[4] = 0;
  local_30 = 0;
  iVar3 = (**(code **)(*DAT_1000f5c4 + 0x14))(s_LastNameEntered_1000e60c,local_2c);
  if (iVar3 == 0x19) {
    uVar2 = 0xffffffff;
    pcVar7 = &DAT_1000e604;
    do {
      pcVar8 = pcVar7;
      if (uVar2 == 0) break;
      uVar2 = uVar2 - 1;
      pcVar8 = pcVar7 + 1;
      cVar1 = *pcVar7;
      pcVar7 = pcVar8;
    } while (cVar1 != '\0');
    uVar2 = ~uVar2;
    pcVar7 = pcVar8 + -uVar2;
    pcVar8 = (char *)local_2c;
    for (uVar5 = uVar2 >> 2; uVar5 != 0; uVar5 = uVar5 - 1) {
      *(undefined4 *)pcVar8 = *(undefined4 *)pcVar7;
      pcVar7 = pcVar7 + 4;
      pcVar8 = pcVar8 + 4;
    }
    for (uVar2 = uVar2 & 3; uVar2 != 0; uVar2 = uVar2 - 1) {
      *pcVar8 = *pcVar7;
      pcVar7 = pcVar7 + 1;
      pcVar8 = pcVar8 + 1;
    }
  }
  (**(code **)(*DAT_1000f5c8 + 0x18))
            (s_Congratulations_1000e59c,s_You_got_a_high_score__Survival_o_1000e5ac,local_2c,
             &local_40,0x10,1);
  uVar2 = 0xffffffff;
  pcVar7 = (char *)&local_40;
  do {
    if (uVar2 == 0) break;
    uVar2 = uVar2 - 1;
    cVar1 = *pcVar7;
    pcVar7 = pcVar7 + 1;
  } while (cVar1 != '\0');
  do {
    if (~uVar2 - 1 < 0xd) {
      (**(code **)(*DAT_1000f5c4 + 0x10))(s_LastNameEntered_1000e60c,&local_40);
      iVar3 = 4;
      if (iVar6 < 5) {
        do {
          FUN_100051b0(local_18,(byte *)s_Score_dName_1000e548);
          (**(code **)(*DAT_1000f5c4 + 0x14))(local_18,local_2c);
          FUN_100051b0(local_18,(byte *)s_Score_dScore_1000e61c);
          (**(code **)(*DAT_1000f5c4 + 0x14))(local_18,local_a8);
          FUN_100051b0(local_18,(byte *)s_Score_dName_1000e548);
          (**(code **)(*DAT_1000f5c4 + 0x10))(local_18,local_2c);
          FUN_100051b0(local_18,(byte *)s_Score_dScore_1000e61c);
          (**(code **)(*DAT_1000f5c4 + 0x10))(local_18,local_a8);
          iVar3 = iVar3 + -1;
        } while (iVar6 <= iVar3);
      }
      FUN_100051b0(local_18,(byte *)s_Score_dName_1000e548);
      (**(code **)(*DAT_1000f5c4 + 0x10))(local_18,&local_40);
      FUN_100051b0(local_18,(byte *)s_Score_dScore_1000e61c);
      FUN_1000c3ae(*(uint *)(local_44 + 8),local_a8,10);
      uVar4 = (**(code **)(*DAT_1000f5c4 + 0x10))(local_18,local_a8);
      return CONCAT31((int3)((uint)uVar4 >> 8),1);
    }
    (**(code **)(*DAT_1000f5c8 + 0x14))
              (s_Name_too_long_1000e554,s_We_re_sorry__but_names_must_be_1_1000e564,0x101);
    (**(code **)(*DAT_1000f5c8 + 0x18))
              (s_Congratulations_1000e59c,s_You_got_a_high_score__Survival_o_1000e5ac,local_2c,
               &local_40,0x10,1);
    uVar2 = 0xffffffff;
    pcVar7 = (char *)&local_40;
    do {
      if (uVar2 == 0) break;
      uVar2 = uVar2 - 1;
      cVar1 = *pcVar7;
      pcVar7 = pcVar7 + 1;
    } while (cVar1 != '\0');
  } while( true );
}


/* ==== FUNCTION FUN_10003a60 @ 10003a60 size=99 ==== */

void FUN_10003a60(void)

{
  byte local_38 [52];
  
  (**(code **)(*DAT_1000f5b8 + 0x1c))(0xff,0x99,0x33);
  (**(code **)(*DAT_1000f5b8 + 0x10))(0x39,7,0x4e,0x20);
  FUN_100051b0(local_38,(byte *)s_<s0><ccc3399><b>_d<_b>_1000e62c);
  FUN_10004a00(DAT_1000f5b8,local_38,(int *)0x35,4);
  return;
}


/* ==== FUNCTION FUN_10003ad0 @ 10003ad0 size=225 ==== */

void FUN_10003ad0(void)

{
  byte bVar1;
  undefined4 uVar2;
  uint uVar3;
  byte *pbVar4;
  byte local_70 [100];
  int local_c [2];
  
  (**(code **)(*DAT_1000f5b8 + 0x1c))(0xff,0x99,0x33);
  (**(code **)(*DAT_1000f5b8 + 0x10))(0x1a9,0x186,500,0x1a4);
  FUN_100051b0(local_70,&DAT_1000e644);
  uVar2 = (**(code **)(*DAT_1000f5b0 + 0x28))(s_Arial_1000e290,0x18,1);
  (**(code **)(*DAT_1000f5b8 + 0x48))(uVar2);
  uVar3 = 0xffffffff;
  pbVar4 = local_70;
  do {
    if (uVar3 == 0) break;
    uVar3 = uVar3 - 1;
    bVar1 = *pbVar4;
    pbVar4 = pbVar4 + 1;
  } while (bVar1 != 0);
  (**(code **)(*DAT_1000f5b8 + 0x58))(uVar2,local_70,~uVar3 - 1,local_c);
  (**(code **)(*DAT_1000f5b8 + 0x24))(0xcc,0x33,0x99);
  FUN_10004a00(DAT_1000f5b8,local_70,(int *)(0x1c9 - local_c[0] / 2),0x186);
  return;
}


/* ==== FUNCTION FUN_10003bc0 @ 10003bc0 size=137 ==== */

void __fastcall FUN_10003bc0(int param_1)

{
  undefined1 local_10 [4];
  int local_c;
  int *local_8;
  
  (**(code **)(**(int **)(DAT_1000f5cc + 8 + **(int **)(param_1 + 0xc) * 8) + 0x10))(1,&local_8);
  (**(code **)(*local_8 + 0x50))(&local_c,local_10);
  (**(code **)(*DAT_1000f5b8 + 0x1c))(0,0,0);
  (**(code **)(*DAT_1000f5b8 + 0x10))(0x1ad,0x17,500,0x4e);
  (**(code **)(*DAT_1000f5b8 + 0x40))(local_8,0x1c9 - local_c / 2,0x1b);
  (**(code **)(*local_8 + 4))();
  return;
}


/* ==== FUNCTION FUN_10003c50 @ 10003c50 size=304 ==== */

void __thiscall FUN_10003c50(void *this,int param_1,int param_2,int param_3,int param_4)

{
  undefined4 uVar1;
  int iVar2;
  undefined4 *puVar3;
  int iVar4;
  
  iVar4 = param_4 - param_2;
  iVar2 = param_3 - param_1;
  uVar1 = (**(code **)(*DAT_1000f5b0 + 0x10))(iVar2 + 2,iVar4 + 2,1);
  *(undefined4 *)((int)this + 0x1dc) = uVar1;
  (**(code **)(*DAT_1000f5bc + 0x18))(uVar1);
  (**(code **)(**(int **)((int)this + 0x1dc) + 8))(param_1,param_2,0);
  puVar3 = (undefined4 *)((int)this + 0x1d8);
  (**(code **)(**(int **)((int)this + 0x1dc) + 0x44))(puVar3);
  (**(code **)(*(int *)*puVar3 + 0x1c))(0,99,99);
  (**(code **)(*(int *)*puVar3 + 0xc))(1,1,iVar2,iVar4);
  (**(code **)(*(int *)*puVar3 + 0xc))(2,2,iVar2 + -1,iVar4 + -1);
  (**(code **)(*(int *)*puVar3 + 0x1c))(0x99,0xcc,0xff);
  (**(code **)(*(int *)*puVar3 + 0xc))(0,0,iVar2 + 1,iVar4 + 1);
  (**(code **)(*(int *)*puVar3 + 0x10))(4,4,iVar2 + -2,iVar4 + -2);
  (**(code **)(*(int *)*puVar3 + 0xc))(3,3,iVar2 + -2,iVar4 + -2);
  (**(code **)(*(int *)*puVar3 + 0x1c))(0,0,0);
  (**(code **)(*(int *)*puVar3 + 0xc))(0,0,iVar2 + 1,iVar4 + 1);
  (**(code **)(*(int *)*puVar3 + 0xc))(4,4,iVar2 + -3,iVar4 + -3);
  return;
}


/* ==== FUNCTION FUN_10003d80 @ 10003d80 size=238 ==== */

void __fastcall FUN_10003d80(void *param_1)

{
  int *piVar1;
  char *pcVar2;
  byte local_404 [1024];
  
  FUN_10003c50(param_1,0x9b,0xa0,0x168,0x140);
  FUN_10004a00(*(int **)((int)param_1 + 0x1d8),(byte *)s_<s3><c333399><b>Hmm____When_we_s_1000e720,
               (int *)0xb,0x15);
  FUN_10004a00(*(int **)((int)param_1 + 0x1d8),(byte *)s_<s3><c333399><b>be_eaten__we_rea_1000e6f0,
               (int *)0xb,0x24);
  FUN_10004a00(*(int **)((int)param_1 + 0x1d8),(byte *)s_<s3><c333399><b>should_do_the_ea_1000e6c0,
               (int *)0xb,0x33);
  FUN_100051b0(local_404,(byte *)s_<s3><c333399><b>That_s_ok__you_h_1000e694);
  FUN_10004a00(*(int **)((int)param_1 + 0x1d8),local_404,(int *)0xb,0x51);
  if (*(int *)((int)param_1 + 0x1a4) < 1) {
    piVar1 = *(int **)((int)param_1 + 0x1d8);
    pcVar2 = s_life_left____1000e674;
  }
  else {
    piVar1 = *(int **)((int)param_1 + 0x1d8);
    pcVar2 = s_lives_left____1000e684;
  }
  FUN_10004a00(piVar1,(byte *)pcVar2,(int *)0xb,0x60);
  *(undefined4 *)((int)param_1 + 0x1bc) = 2;
  FUN_10004a00(*(int **)((int)param_1 + 0x1d8),(byte *)s_<C000000>Press_the_space_bar_to_c_1000e648,
               (int *)0x5,0x7e);
  return;
}


/* ==== FUNCTION FUN_10003e70 @ 10003e70 size=213 ==== */

void __fastcall FUN_10003e70(void *param_1)

{
  undefined4 uVar1;
  
  FUN_10003c50(param_1,0x9b,0xa0,0x163,0x122);
  FUN_10004a00(*(int **)((int)param_1 + 0x1d8),(byte *)s_<s3><c333399><b>That_was_good__U_1000e7d8,
               (int *)0xb,0x15);
  FUN_10004a00(*(int **)((int)param_1 + 0x1d8),(byte *)s_<s3><c333399><b>that_was_also_al_1000e7ac,
               (int *)0xb,0x24);
  FUN_10004a00(*(int **)((int)param_1 + 0x1d8),(byte *)s_<s3><c333399><b>for_this_little_m_1000e780,
               (int *)0xb,0x33);
  FUN_10004a00(*(int **)((int)param_1 + 0x1d8),(byte *)s_<s3><c333399><b><c>Play_Again_<__1000e75c,
               (int *)0xb,0x51);
  *(undefined4 *)((int)param_1 + 0x1bc) = 1;
  uVar1 = FUN_10001de0(*(undefined4 *)((int)param_1 + 0x1dc),(byte *)s_Yes__Y__1000e754,0x1b,0x6b,0,
                       0xc,param_1,FUN_10003f50);
  *(undefined4 *)((int)param_1 + 0x1e0) = uVar1;
  uVar1 = FUN_10001de0(*(undefined4 *)((int)param_1 + 0x1dc),(byte *)s_No__N__1000e74c,0x7f,0x6b,1,
                       0xc,param_1,FUN_10003f50);
  *(undefined4 *)((int)param_1 + 0x1e4) = uVar1;
  return;
}


/* ==== FUNCTION FUN_10003f50 @ 10003f50 size=16 ==== */

void __cdecl FUN_10003f50(undefined4 *param_1)

{
  FUN_10003f60((void *)*param_1,(int)param_1);
  return;
}


/* ==== FUNCTION FUN_10003f60 @ 10003f60 size=154 ==== */

undefined4 __thiscall FUN_10003f60(void *this,int param_1)

{
  void *pvVar1;
  undefined4 *puVar2;
  void *local_10;
  undefined1 *puStack_c;
  undefined4 local_8;
  
  local_8 = 0xffffffff;
  puStack_c = &LAB_1000c6b6;
  local_10 = ExceptionList;
  if (*(int *)(param_1 + 4) == 0) {
    ExceptionList = &local_10;
    pvVar1 = operator_new(0x1e8);
    local_8 = 0;
    if (pvVar1 != (void *)0x0) {
      puVar2 = FUN_10002a80(pvVar1,*(undefined4 *)((int)this + 4));
      goto LAB_10003fd6;
    }
  }
  else {
    ExceptionList = &local_10;
    pvVar1 = operator_new(0x20);
    local_8 = 1;
    if (pvVar1 != (void *)0x0) {
      puVar2 = FUN_100041a0(pvVar1,*(undefined4 *)((int)this + 4));
      goto LAB_10003fd6;
    }
  }
  puVar2 = (undefined4 *)0x0;
LAB_10003fd6:
  local_8 = 0xffffffff;
  FUN_10001db0(*(void **)((int)this + 4),this,puVar2);
  ExceptionList = local_10;
  return 0;
}


/* ==== FUNCTION FUN_10004000 @ 10004000 size=407 ==== */

undefined4 __fastcall FUN_10004000(int param_1)

{
  LPVOID pvVar1;
  uint uVar2;
  void *this;
  int *piVar3;
  int iVar4;
  undefined4 *puVar5;
  int iVar6;
  int local_14;
  void *local_10;
  undefined1 *puStack_c;
  undefined4 local_8;
  
  local_8 = 0xffffffff;
  puStack_c = &LAB_1000c6cb;
  local_10 = ExceptionList;
  ExceptionList = &local_10;
  if (*(int **)(param_1 + 0x1d8) != (int *)0x0) {
    ExceptionList = &local_10;
    (**(code **)(**(int **)(param_1 + 0x1d8) + 4))();
    *(undefined4 *)(param_1 + 0x1d8) = 0;
  }
  if (*(int *)(param_1 + 0x1dc) != 0) {
    (**(code **)(*DAT_1000f5bc + 0x1c))(*(int *)(param_1 + 0x1dc));
    (**(code **)(**(int **)(param_1 + 0x1dc) + 4))();
    *(undefined4 *)(param_1 + 0x1dc) = 0;
  }
  local_14 = 0;
  if (0 < *(int *)(param_1 + 0x1a0)) {
    puVar5 = (undefined4 *)(param_1 + 0x10);
    do {
      pvVar1 = (LPVOID)*puVar5;
      if (pvVar1 != (LPVOID)0x0) {
        FUN_10001340((int)pvVar1);
        FUN_10005197(pvVar1);
      }
      local_14 = local_14 + 1;
      puVar5 = puVar5 + 1;
    } while (local_14 < *(int *)(param_1 + 0x1a0));
  }
  FUN_10002030(*(void **)(param_1 + 0xc));
  *(undefined1 *)(param_1 + 0x1ac) = 0;
  *(undefined1 *)(param_1 + 0x1ad) = 0;
  *(undefined1 *)(param_1 + 0x1ae) = 0;
  *(undefined4 *)(param_1 + 0x1a0) = 0;
  uVar2 = **(uint **)(param_1 + 0xc);
  iVar4 = uVar2 * 2 + 4;
  if (0 < iVar4) {
    do {
      if (iVar4 / 3 <= *(int *)(param_1 + 0x1a0)) {
        uVar2 = (**(code **)(*DAT_1000f5b4 + 8))();
        uVar2 = uVar2 % **(uint **)(param_1 + 0xc);
      }
      this = operator_new(0x38);
      local_8 = 0;
      if (this == (void *)0x0) {
        piVar3 = (int *)0x0;
      }
      else {
        piVar3 = FUN_100011a0(this,uVar2 + 1);
      }
      local_8 = 0xffffffff;
      *(int **)(param_1 + 0x10 + *(int *)(param_1 + 0x1a0) * 4) = piVar3;
      iVar6 = *(int *)(param_1 + 0x1a0) + 1;
      *(int *)(param_1 + 0x1a0) = iVar6;
      uVar2 = **(uint **)(param_1 + 0xc);
      iVar4 = uVar2 * 2 + 4;
    } while (iVar6 < iVar4);
  }
  if (DAT_1000f5ec != '\0') {
    (**(code **)(*DAT_1000f5bc + 0x1c))(DAT_1000f5e8);
    (**(code **)(*DAT_1000f5e8 + 4))();
    DAT_1000f5ec = '\0';
  }
  FUN_10003a60();
  *(undefined4 *)(param_1 + 0x1bc) = 0;
  ExceptionList = local_10;
  return 0;
}


/* ==== FUNCTION FUN_100041a0 @ 100041a0 size=370 ==== */

undefined4 * __thiscall FUN_100041a0(void *this,undefined4 param_1)

{
  undefined4 uVar1;
  void *local_10;
  undefined1 *puStack_c;
  undefined4 local_8;
  
  local_8 = 0xffffffff;
  puStack_c = &LAB_1000c6e8;
  local_10 = ExceptionList;
  ExceptionList = &local_10;
  FUN_10002660(this,param_1);
  *(undefined ***)this = &PTR_FUN_1000d15c;
  local_8 = 0;
  (**(code **)(**(int **)(DAT_1000f5cc + 200) + 8))(0);
  DAT_1000f605 = 0;
  DAT_1000f604 = 0;
  DAT_1000f608 = 1;
  (**(code **)(*DAT_1000f5b8 + 0x34))(0x99,0x99,0xcc);
  (**(code **)(*DAT_1000f5bc + 0x18))(*(undefined4 *)(DAT_1000f5cc + 0xb0));
  (**(code **)(**(int **)(DAT_1000f5cc + 0xb0) + 8))(0,0x14a,0);
  (**(code **)(**(int **)(DAT_1000f5cc + 0xb0) + 0x2c))();
  (**(code **)(*DAT_1000f5b8 + 0x40))(*(undefined4 *)(*(int *)((int)this + 4) + 0xbc),0,0);
  uVar1 = FUN_10001de0(DAT_1000f5bc,(byte *)s_Start_1000e830,0xfa,0xbe,-1,0x18,this,FUN_10004990);
  *(undefined4 *)((int)this + 0xc) = uVar1;
  FUN_10004a00(DAT_1000f5b8,(byte *)s_<C000000><S1><b><u>Top_Moeboids<_1000e808,(int *)0x32,0xbb);
  *(undefined4 *)((int)this + 0x14) = 0;
  *(undefined4 *)((int)this + 0x18) = 0;
  uVar1 = (**(code **)(*DAT_1000f5b0 + 0x44))(DAT_1000f5c8,0xb,this,FUN_100049a0);
  *(undefined4 *)((int)this + 0x10) = uVar1;
  FUN_10004640();
  uVar1 = (**(code **)(*DAT_1000f5b0 + 0x34))(this,100,FUN_100049b0);
  *(undefined4 *)((int)this + 0x1c) = uVar1;
  (**(code **)(**(int **)(DAT_1000f5b4 + 0x14) + 0xc))(0);
  ExceptionList = local_10;
  return this;
}


/* ==== FUNCTION FUN_10004320 @ 10004320 size=33 ==== */

undefined4 * __thiscall FUN_10004320(void *this,byte param_1)

{
  FUN_10004350(this);
  if ((param_1 & 1) != 0) {
    FUN_10005197(this);
  }
  return this;
}


/* ==== FUNCTION FUN_10004350 @ 10004350 size=152 ==== */

void __fastcall FUN_10004350(undefined4 *param_1)

{
  void *local_10;
  undefined1 *puStack_c;
  undefined4 local_8;
  
  puStack_c = &LAB_1000c708;
  local_10 = ExceptionList;
  ExceptionList = &local_10;
  *param_1 = &PTR_FUN_1000d15c;
  local_8 = 0;
  (**(code **)(*DAT_1000f5bc + 0x1c))(param_1[3]);
  (**(code **)(*(int *)param_1[3] + 4))();
  (**(code **)(*(int *)param_1[4] + 4))();
  (**(code **)(*(int *)param_1[7] + 4))();
  (**(code **)(*DAT_1000f5bc + 0x1c))(*(undefined4 *)(DAT_1000f5cc + 0xb0));
  (**(code **)(**(int **)(DAT_1000f5cc + 0xb0) + 0x34))();
  local_8 = 0xffffffff;
  FUN_100026b0(param_1);
  ExceptionList = local_10;
  return;
}


/* ==== FUNCTION FUN_100043f0 @ 100043f0 size=311 ==== */

undefined4 __thiscall FUN_100043f0(void *this,int param_1)

{
  char cVar1;
  int iVar2;
  void *this_00;
  undefined4 *puVar3;
  uint uVar4;
  char *pcVar5;
  char local_2c [4];
  char local_28 [4];
  char local_24 [2];
  char local_22;
  char local_20 [4];
  char local_1c [4];
  char local_18 [4];
  char local_14 [4];
  void *local_10;
  undefined1 *puStack_c;
  undefined4 local_8;
  
  local_8 = 0xffffffff;
  puStack_c = &LAB_1000c72b;
  local_10 = ExceptionList;
  local_18 = (char  [4])s_CREDITS_1000e84c._0_4_;
  local_20 = (char  [4])s_credits_1000e844._0_4_;
  local_1c = (char  [4])s_credits_1000e844._4_4_;
  local_28 = (char  [4])s_INVINCIBLE_1000e838._4_4_;
  local_14 = (char  [4])s_CREDITS_1000e84c._4_4_;
  local_24 = (char  [2])s_INVINCIBLE_1000e838._8_2_;
  local_2c = (char  [4])s_INVINCIBLE_1000e838._0_4_;
  local_22 = s_INVINCIBLE_1000e838[10];
  if (*(char *)(*(int *)((int)this + 4) + 0xb4) == '\0') {
    iVar2 = *(int *)((int)this + 0x14);
    if ((*(int *)(param_1 + 8) == (int)local_18[iVar2]) ||
       (*(int *)(param_1 + 8) == (int)local_20[iVar2])) {
      ExceptionList = &local_10;
      *(int *)((int)this + 0x14) = iVar2 + 1;
    }
    else {
      ExceptionList = &local_10;
      *(undefined4 *)((int)this + 0x14) = 0;
    }
    if (*(int *)(param_1 + 8) == (int)local_2c[*(int *)((int)this + 0x18)]) {
      *(int *)((int)this + 0x18) = *(int *)((int)this + 0x18) + 1;
    }
    else {
      *(undefined4 *)((int)this + 0x18) = 0;
    }
    uVar4 = 0xffffffff;
    pcVar5 = local_2c;
    do {
      if (uVar4 == 0) break;
      uVar4 = uVar4 - 1;
      cVar1 = *pcVar5;
      pcVar5 = pcVar5 + 1;
    } while (cVar1 != '\0');
    if (*(int *)((int)this + 0x18) == ~uVar4 - 1) {
      DAT_1000f604 = 1;
      *(undefined4 *)((int)this + 0x18) = 0;
    }
    uVar4 = 0xffffffff;
    pcVar5 = local_18;
    do {
      if (uVar4 == 0) break;
      uVar4 = uVar4 - 1;
      cVar1 = *pcVar5;
      pcVar5 = pcVar5 + 1;
    } while (cVar1 != '\0');
    if (*(int *)((int)this + 0x14) == ~uVar4 - 1) {
      this_00 = operator_new(0x1a4);
      local_8 = 0;
      if (this_00 == (void *)0x0) {
        puVar3 = (undefined4 *)0x0;
      }
      else {
        puVar3 = FUN_100026c0(this_00,*(undefined4 *)((int)this + 4));
      }
      local_8 = 0xffffffff;
      FUN_10001db0(*(void **)((int)this + 4),this,puVar3);
      *(undefined4 *)((int)this + 0x14) = 0;
    }
  }
  ExceptionList = local_10;
  return 0;
}


/* ==== FUNCTION FUN_10004530 @ 10004530 size=100 ==== */

undefined4 __fastcall FUN_10004530(int param_1)

{
  (**(code **)(*DAT_1000f5bc + 0x18))(*(undefined4 *)(*(int *)(param_1 + 4) + 0xac));
  *(undefined1 *)(*(int *)(param_1 + 4) + 0xb4) = 1;
  (**(code **)(**(int **)(*(int *)(param_1 + 4) + 0xac) + 8))(0,0,0);
  (**(code **)(**(int **)(*(int *)(param_1 + 4) + 0xac) + 0x2c))();
  (**(code **)(**(int **)(DAT_1000f5cc + 0xd4) + 8))(0);
  (**(code **)(**(int **)(param_1 + 0x1c) + 8))();
  return 0;
}


/* ==== FUNCTION FUN_100045a0 @ 100045a0 size=150 ==== */

undefined4 __thiscall FUN_100045a0(void *this,int param_1)

{
  void *this_00;
  undefined4 *puVar1;
  void *local_10;
  undefined1 *puStack_c;
  undefined4 local_8;
  
  local_8 = 0xffffffff;
  puStack_c = &LAB_1000c74b;
  local_10 = ExceptionList;
  if (3000 < *(uint *)(param_1 + 8)) {
    ExceptionList = &local_10;
    (**(code **)(*DAT_1000f5bc + 0x1c))(*(undefined4 *)(*(int *)((int)this + 4) + 0xac));
    *(undefined1 *)(*(int *)((int)this + 4) + 0xb4) = 0;
    this_00 = operator_new(0x1e8);
    local_8 = 0;
    if (this_00 == (void *)0x0) {
      puVar1 = (undefined4 *)0x0;
    }
    else {
      puVar1 = FUN_10002a80(this_00,*(undefined4 *)((int)this + 4));
    }
    local_8 = 0xffffffff;
    FUN_10001db0(*(void **)((int)this + 4),this,puVar1);
  }
  ExceptionList = local_10;
  return 0;
}


/* ==== FUNCTION FUN_10004640 @ 10004640 size=841 ==== */

void FUN_10004640(void)

{
  int iVar1;
  byte bVar2;
  bool bVar3;
  int iVar4;
  int iVar5;
  int *piVar6;
  uint uVar7;
  byte *pbVar8;
  undefined1 local_d4 [52];
  byte local_a0 [100];
  undefined1 local_3c [20];
  undefined1 local_28 [20];
  int local_14 [2];
  int local_c;
  int local_8;
  
  iVar5 = (**(code **)(*DAT_1000f5c4 + 0x14))(s_Score1Name_1000e998,local_d4);
  if (iVar5 == 0x19) {
    (**(code **)(*DAT_1000f5c4 + 0x10))(s_Score1Name_1000e998,s_ZapSpot_1000e990);
    (**(code **)(*DAT_1000f5c4 + 0x10))(s_Score1Score_1000e97c,s_10000_1000e988);
    (**(code **)(*DAT_1000f5c4 + 0x10))(s_Score2Name_1000e970,s_ZapSpot_1000e990);
    (**(code **)(*DAT_1000f5c4 + 0x10))(s_Score2Score_1000e95c,&DAT_1000e968);
    (**(code **)(*DAT_1000f5c4 + 0x10))(s_Score3Name_1000e950,s_ZapSpot_1000e990);
    (**(code **)(*DAT_1000f5c4 + 0x10))(s_Score3Score_1000e93c,&DAT_1000e948);
    (**(code **)(*DAT_1000f5c4 + 0x10))(s_Score4Name_1000e930,s_ZapSpot_1000e990);
    (**(code **)(*DAT_1000f5c4 + 0x10))(s_Score4Score_1000e91c,&DAT_1000e928);
    (**(code **)(*DAT_1000f5c4 + 0x10))(s_Score5Name_1000e910,s_ZapSpot_1000e990);
    (**(code **)(*DAT_1000f5c4 + 0x10))(s_Score5Score_1000e900,&DAT_1000e90c);
  }
  iVar5 = 0xd4;
  do {
    FUN_10004a00(DAT_1000f5b8,(byte *)s_<s3><c000000><b>__________________1000e8c8,(int *)0x32,iVar5
                );
    iVar5 = iVar5 + 0x11;
  } while (iVar5 < 0x129);
  local_8 = 0xd4;
  local_c = 1;
  do {
    FUN_100051b0(local_28,(byte *)s_Score_dName_1000e548);
    (**(code **)(*DAT_1000f5c4 + 0x14))(local_28,local_d4);
    FUN_100051b0(local_28,(byte *)s_Score_dScore_1000e61c);
    (**(code **)(*DAT_1000f5c4 + 0x14))(local_28,local_3c);
    iVar5 = FUN_100056e2(local_3c,local_3c);
    FUN_100051b0(local_a0,&DAT_1000e8c4);
    piVar6 = (int *)(**(code **)(*DAT_1000f5b0 + 0x28))(s_Arial_1000e290,0xc,1);
    (**(code **)(*DAT_1000f5b8 + 0x48))(piVar6);
    uVar7 = 0xffffffff;
    pbVar8 = local_a0;
    do {
      if (uVar7 == 0) break;
      uVar7 = uVar7 - 1;
      bVar2 = *pbVar8;
      pbVar8 = pbVar8 + 1;
    } while (bVar2 != 0);
    (**(code **)(*DAT_1000f5b8 + 0x58))(piVar6,local_a0,~uVar7 - 1,local_14);
    (**(code **)(*DAT_1000f5b8 + 0x1c))(0x33,0x99,0xff);
    iVar1 = local_8 + 0x11;
    (**(code **)(*DAT_1000f5b8 + 0x10))(0x32,local_8,local_14[0] + 0x3a,iVar1);
    (**(code **)(*piVar6 + 4))();
    FUN_100051b0(local_a0,(byte *)s_<s3><b><c000000>_s<_b>_1000e8ac);
    iVar4 = local_8;
    FUN_10004a00(DAT_1000f5b8,local_a0,(int *)0x32,local_8);
    if (iVar5 < 1000000) {
      if (iVar5 < 1000) {
        FUN_100051b0(local_a0,(byte *)s_<s3><b><c000000>_d<_b>_1000e854);
      }
      else {
        FUN_100051b0(local_a0,(byte *)s_<s3><b><c000000>_d__03d<_b>_1000e86c);
      }
    }
    else {
      FUN_100051b0(local_a0,(byte *)s_<s3><b><c000000>_d__03d__03d<_b>_1000e888);
    }
    FUN_10004a00(DAT_1000f5b8,local_a0,(int *)0x9b,iVar4);
    bVar3 = 4 < local_c;
    local_c = local_c + 1;
    local_8 = iVar1;
    if (bVar3) {
      return;
    }
  } while( true );
}


/* ==== FUNCTION FUN_10004990 @ 10004990 size=16 ==== */

void __cdecl FUN_10004990(int *param_1)

{
  FUN_10004530(*param_1);
  return;
}


/* ==== FUNCTION FUN_100049a0 @ 100049a0 size=16 ==== */

void __cdecl FUN_100049a0(undefined4 *param_1)

{
  FUN_100043f0((void *)*param_1,(int)param_1);
  return;
}


/* ==== FUNCTION FUN_100049b0 @ 100049b0 size=16 ==== */

void __cdecl FUN_100049b0(undefined4 *param_1)

{
  FUN_100045a0((void *)*param_1,(int)param_1);
  return;
}


/* ==== FUNCTION FUN_100049c0 @ 100049c0 size=58 ==== */

int __cdecl FUN_100049c0(char param_1)

{
  if (('`' < param_1) && (param_1 < 'g')) {
    return param_1 + -0x57;
  }
  if (('/' < param_1) && (param_1 < ':')) {
    return param_1 + -0x30;
  }
  if (('@' < param_1) && (param_1 < 'G')) {
    return param_1 + -0x37;
  }
  return 0;
}


/* ==== FUNCTION FUN_10004a00 @ 10004a00 size=1044 ==== */

/* WARNING: Type propagation algorithm not settling */

undefined4 __cdecl FUN_10004a00(int *param_1,byte *param_2,int *param_3,undefined4 param_4)

{
  char cVar1;
  byte bVar2;
  int iVar3;
  uint uVar4;
  int *piVar5;
  int *unaff_EBX;
  uint unaff_ESI;
  byte *pbVar6;
  int *piVar7;
  int iVar8;
  int local_5e7c;
  byte local_5e78 [23992];
  undefined1 local_c0 [112];
  undefined4 uStackY_50;
  int *piStackY_4c;
  undefined1 *puStackY_48;
  undefined1 *puVar9;
  undefined1 local_2c [4];
  undefined *local_28;
  int *local_24;
  undefined1 *local_20;
  undefined1 *local_1c;
  byte *pbVar10;
  byte *pbVar11;
  undefined1 *puVar12;
  
  FUN_10005600();
  uVar4 = 0xffffffff;
  pbVar6 = param_2;
  do {
    if (uVar4 == 0) break;
    uVar4 = uVar4 - 1;
    bVar2 = *pbVar6;
    pbVar6 = pbVar6 + 1;
  } while (bVar2 != 0);
  local_28 = (undefined *)(~uVar4 - 1);
  local_24 = param_3;
  bVar2 = *param_2;
  local_20 = (undefined1 *)param_4;
  if (bVar2 != 0) {
    piVar5 = &local_5e7c;
    pbVar6 = param_2;
    param_2 = local_5e78;
    param_3 = piVar5;
    do {
      iVar8 = 0;
      local_1c = (undefined1 *)0x0;
      if (bVar2 != 0x3c) {
        local_1c = (undefined1 *)0x10004a6a;
        pbVar10 = pbVar6;
        iVar8 = FUN_100057b0(pbVar6,&DAT_1000ea14);
        bVar2 = pbVar6[iVar8];
        param_2[0] = 0;
        param_2[1] = 0;
        param_2[2] = 0;
        param_2[3] = 0;
        *piVar5 = iVar8;
        if (bVar2 == 0x20) {
          iVar8 = iVar8 + 1;
          *piVar5 = iVar8;
        }
        *(byte **)pbVar10 = pbVar6;
        param_2 = param_2 + 0xc;
        piVar5 = piVar5 + 3;
        param_3 = piVar5;
      }
      if (iVar8 < (int)local_28) {
        bVar2 = pbVar6[iVar8];
        while (bVar2 == 0x20) {
          iVar3 = iVar8 + 1;
          iVar8 = iVar8 + 1;
          bVar2 = pbVar6[iVar3];
        }
        if (pbVar6[iVar8] == 0x3c) {
          pbVar6 = pbVar6 + 1;
          pbVar10 = pbVar6 + iVar8;
          local_1c = (undefined1 *)0x10004ace;
          pbVar11 = pbVar10;
          iVar3 = FUN_100057b0(pbVar10,&DAT_1000ea10);
          param_2[0] = 1;
          param_2[1] = 0;
          param_2[2] = 0;
          param_2[3] = 0;
          *(byte **)pbVar11 = pbVar10;
          param_2 = param_2 + 0xc;
          *param_3 = iVar3;
          piVar5 = param_3 + 3;
          local_1c = (undefined1 *)(iVar3 + 1);
          param_3 = piVar5;
        }
      }
      bVar2 = pbVar6[iVar8 + (int)local_1c];
      pbVar6 = pbVar6 + iVar8 + (int)local_1c;
    } while (bVar2 != 0);
  }
  puVar12 = &stack0xfffffff8;
  (**(code **)(*param_1 + 0x4c))();
  local_1c = local_2c;
  local_20 = (undefined1 *)0x10004b36;
  (**(code **)(*param_1 + 0x50))();
  local_20 = &stack0xffffffc0;
  local_24 = (int *)0x4;
  local_28 = &DAT_1000ea08;
  (**(code **)(*param_1 + 0x58))();
  if (0 < (int)puVar12) {
    piVar5 = &local_5e7c;
    local_1c = puVar12;
    do {
      piVar7 = (int *)piVar5[-1];
      puVar12 = (undefined1 *)*piVar5;
      if (piVar5[1] == 0) {
        puVar9 = puVar12;
        (**(code **)(*param_1 + 0x58))();
        uStackY_50 = 0x10004de2;
        piStackY_4c = piVar7;
        puStackY_48 = puVar12;
        (**(code **)(*param_1 + 0x18))();
        local_24 = (int *)((int)local_24 + (int)puVar9);
        goto switchD_10004ba5_caseD_44;
      }
      if (piVar5[1] != 1) goto switchD_10004ba5_caseD_44;
      if ((char)*piVar7 == '/') {
        piVar7 = (int *)((int)piVar7 + 1);
      }
      switch((char)*piVar7) {
      case 'B':
      case 'b':
        if ((*(char *)((int)piVar7 + 1) != 'r') && (*(char *)((int)piVar7 + 1) != 'R')) {
          (**(code **)(*unaff_EBX + 0xc))();
          goto LAB_10004c31;
        }
        local_24 = (int *)0x0;
        local_20 = local_20 + 0xf;
        break;
      case 'C':
      case 'c':
        cVar1 = *(char *)((int)piVar7 + 1);
        if (cVar1 != '>') {
          FUN_100049c0(*(char *)((int)piVar7 + 2));
          FUN_100049c0(cVar1);
          FUN_100049c0(*(char *)((int)piVar7 + 3));
          FUN_100049c0((char)piVar7[1]);
          iVar8 = FUN_100049c0(*(char *)((int)piVar7 + 5));
          puStackY_48 = (undefined1 *)0x10004d8a;
          iVar3 = FUN_100049c0(*(char *)((int)piVar7 + 6));
          local_28 = (undefined *)CONCAT31(local_28._1_3_,(char)iVar8 * '\x10' + (char)iVar3);
          (**(code **)(*param_1 + 0x24))();
        }
        break;
      case 'I':
      case 'i':
        (**(code **)(*unaff_EBX + 0xc))();
        goto LAB_10004c31;
      case 'P':
      case 'p':
        local_24 = (int *)0x0;
        local_20 = local_20 + 0x1e;
        break;
      case 'S':
      case 's':
        (**(code **)(*unaff_EBX + 0xc))();
        cVar1 = *(char *)((int)piVar7 + 1);
        if (cVar1 == '-') {
          unaff_ESI = unaff_ESI + 1;
          if (4 < (int)unaff_ESI) {
            unaff_ESI = 5;
          }
        }
        else if (cVar1 == '+') {
          unaff_ESI = unaff_ESI - 1 & ((int)(unaff_ESI - 1) < 1) - 1;
        }
        else {
          unaff_ESI = (int)cVar1 - 0x30;
        }
        (**(code **)(*unaff_EBX + 4))();
        puStackY_48 = local_c0;
        piStackY_4c = (int *)0x10004d12;
        unaff_EBX = (int *)(**(code **)(*DAT_1000f5b0 + 0x28))();
        uStackY_50 = 0x10004d1d;
        piStackY_4c = unaff_EBX;
        (**(code **)(*param_1 + 0x48))();
        break;
      case 'U':
      case 'u':
        (**(code **)(*unaff_EBX + 0xc))();
LAB_10004c31:
        (**(code **)(*unaff_EBX + 4))();
        puStackY_48 = local_c0;
        piStackY_4c = (int *)0x10004c56;
        unaff_EBX = (int *)(**(code **)(*DAT_1000f5b0 + 0x28))();
        uStackY_50 = 0x10004c61;
        piStackY_4c = unaff_EBX;
        (**(code **)(*param_1 + 0x48))();
      }
switchD_10004ba5_caseD_44:
      piVar5 = piVar5 + 3;
      local_1c = local_1c + -1;
    } while (local_1c != (undefined1 *)0x0);
  }
  (**(code **)(*unaff_EBX + 4))();
  return 0;
}


/* ==== FUNCTION FUN_10004e70 @ 10004e70 size=17 ==== */

undefined4 FUN_10004e70(undefined4 param_1)

{
  DAT_1000f60c = param_1;
  return CONCAT31((int3)((uint)param_1 >> 8),1);
}


/* ==== FUNCTION FUN_10004e90 @ 10004e90 size=202 ==== */

undefined4 * __thiscall FUN_10004e90(void *this,LPCSTR param_1)

{
  LPCSTR lpFileName;
  HRSRC hResInfo;
  HANDLE hFile;
  DWORD DVar1;
  void *lpBuffer;
  HGLOBAL hResData;
  LPVOID pvVar2;
  
  lpFileName = param_1;
  *(undefined4 *)this = 0;
  *(undefined4 *)((int)this + 8) = 0;
  *(undefined1 *)((int)this + 0xc) = 0;
  hResInfo = FindResourceA(DAT_1000f60c,param_1,(LPCSTR)0xa);
  if (hResInfo == (HRSRC)0x0) {
    hFile = CreateFileA(lpFileName,0x80000000,0,(LPSECURITY_ATTRIBUTES)0x0,3,0x80,(HANDLE)0x0);
    if (hFile != (HANDLE)0xffffffff) {
      DVar1 = GetFileSize(hFile,(LPDWORD)0x0);
      *(DWORD *)((int)this + 4) = DVar1;
      lpBuffer = operator_new(DVar1 + 2);
      *(void **)this = lpBuffer;
      ReadFile(hFile,lpBuffer,*(DWORD *)((int)this + 4),(LPDWORD)&param_1,(LPOVERLAPPED)0x0);
      CloseHandle(hFile);
      *(undefined1 *)((int)this + 0xc) = 1;
      return this;
    }
  }
  else {
    hResData = LoadResource(DAT_1000f60c,hResInfo);
    if (hResData != (HGLOBAL)0x0) {
      pvVar2 = LockResource(hResData);
      *(LPVOID *)this = pvVar2;
      if (pvVar2 != (LPVOID)0x0) {
        DVar1 = SizeofResource(DAT_1000f60c,hResInfo);
        *(DWORD *)((int)this + 4) = DVar1;
        *(undefined1 *)((int)this + 0xc) = 1;
      }
    }
  }
  return this;
}


/* ==== FUNCTION FUN_10004f60 @ 10004f60 size=3 ==== */

undefined4 FUN_10004f60(void)

{
  return 0;
}


/* ==== FUNCTION FUN_10004f70 @ 10004f70 size=59 ==== */

undefined1 __thiscall FUN_10004f70(void *this,uint *param_1)

{
  undefined1 uVar1;
  int iVar2;
  
  if (*(char *)((int)this + 0xc) == '\0') {
    return 1;
  }
  uVar1 = **(undefined1 **)this;
  *(undefined1 **)this = *(undefined1 **)this + 1;
  iVar2 = *(int *)((int)this + 8) + 1;
  *(int *)((int)this + 8) = iVar2;
  if (param_1 != (uint *)0x0) {
    *param_1 = (uint)(iVar2 <= *(int *)((int)this + 4));
  }
  return uVar1;
}


/* ==== FUNCTION FUN_10004fb0 @ 10004fb0 size=121 ==== */

undefined4 __thiscall FUN_10004fb0(void *this,int param_1,int param_2)

{
  char cVar1;
  int iVar2;
  uint local_8;
  
  iVar2 = 0;
  if (*(char *)((int)this + 0xc) == '\0') {
    return 1;
  }
  local_8 = 1;
  do {
    if (local_8 == 0) break;
    cVar1 = FUN_10004f70(this,&local_8);
  } while (cVar1 != '\"');
  if (0 < param_2) {
    do {
      cVar1 = FUN_10004f70(this,&local_8);
      if ((local_8 == 0) || (cVar1 == '\"')) break;
      *(char *)(iVar2 + param_1) = cVar1;
      iVar2 = iVar2 + 1;
    } while (iVar2 < param_2);
  }
  *(undefined1 *)(iVar2 + param_1) = 0;
  return 0;
}


/* ==== FUNCTION FUN_10005030 @ 10005030 size=204 ==== */

undefined4 __thiscall FUN_10005030(void *this,int *param_1)

{
  bool bVar1;
  bool bVar2;
  char cVar3;
  uint local_8;
  
  if (*(char *)((int)this + 0xc) == '\0') {
    return 1;
  }
  do {
    cVar3 = FUN_10004f70(this,&local_8);
    if ((((cVar3 != ' ') && (cVar3 != '\r')) && (cVar3 != '\t')) && (cVar3 != '\n')) break;
  } while (0 < (int)local_8);
  bVar1 = false;
  bVar2 = false;
  *param_1 = 0;
  while (cVar3 == '/') {
    cVar3 = '/';
    while (cVar3 != '\n') {
      cVar3 = FUN_10004f70(this,&local_8);
    }
    cVar3 = FUN_10004f70(this,&local_8);
  }
  do {
    if ((cVar3 < '0') || ('9' < cVar3)) {
      if (bVar1) break;
      if (cVar3 == '-') {
        bVar2 = true;
      }
    }
    else {
      bVar1 = true;
      *param_1 = cVar3 + -0x30 + *param_1 * 10;
    }
    cVar3 = FUN_10004f70(this,&local_8);
  } while (local_8 != 0);
  if (bVar2) {
    *param_1 = -*param_1;
  }
  return 0;
}


/* ==== FUNCTION __ftol @ 10005110 size=39 ==== */

/* Library Function - Single Match
    __ftol
   
   Library: Visual Studio */

longlong __ftol(void)

{
  float10 in_ST0;
  
  return (longlong)ROUND(in_ST0);
}


/* ==== FUNCTION FUN_10005137 @ 10005137 size=23 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10005137(void)

{
  void *extraout_ECX;
  
  FUN_1000514f();
  _DAT_1000f614 = FUN_100059c6();
  FUN_10005976(extraout_ECX);
  return;
}


/* ==== FUNCTION FUN_1000514f @ 1000514f size=56 ==== */

void FUN_1000514f(void)

{
  PTR___fptrap_1000ea58 = &LAB_10005a49;
  PTR___fptrap_1000ea54 = __cfltcvt;
  PTR___fptrap_1000ea5c = __fassign;
  PTR___fptrap_1000ea60 = FUN_100059ef;
  PTR___fptrap_1000ea64 = &LAB_10005a97;
  PTR___fptrap_1000ea68 = __cfltcvt;
  return;
}


/* ==== FUNCTION FUN_10005197 @ 10005197 size=11 ==== */

void __cdecl FUN_10005197(LPVOID param_1)

{
  FUN_10005e2a(param_1);
  return;
}


/* ==== FUNCTION operator_new @ 100051a2 size=14 ==== */

/* Library Function - Single Match
    void * __cdecl operator new(unsigned int)
   
   Library: Visual Studio 2003 Release */

void * __cdecl operator_new(uint param_1)

{
  void *pvVar1;
  
  pvVar1 = __nh_malloc(param_1,1);
  return pvVar1;
}


/* ==== FUNCTION FUN_100051b0 @ 100051b0 size=82 ==== */

int __cdecl FUN_100051b0(undefined1 *param_1,byte *param_2)

{
  int iVar1;
  undefined1 *local_24;
  int local_20;
  undefined1 *local_1c;
  undefined4 local_18;
  
  local_1c = param_1;
  local_24 = param_1;
  local_18 = 0x42;
  local_20 = 0x7fffffff;
  iVar1 = FUN_10005fe2((int *)&local_24,param_2,(undefined4 *)&stack0x0000000c);
  local_20 = local_20 + -1;
  if (local_20 < 0) {
    FUN_10005ecd(0,(int *)&local_24);
  }
  else {
    *local_24 = 0;
  }
  return iVar1;
}


/* ==== FUNCTION FUN_10005202 @ 10005202 size=45 ==== */

void FUN_10005202(undefined *UNRECOVERED_JUMPTABLE)

{
  ExceptionList = *(void **)ExceptionList;
                    /* WARNING: Could not recover jumptable at 0x1000522d. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (*(code *)UNRECOVERED_JUMPTABLE)();
  return;
}


/* ==== FUNCTION FUN_10005236 @ 10005236 size=7 ==== */

void FUN_10005236(undefined4 param_1,undefined *UNRECOVERED_JUMPTABLE)

{
  LOCK();
  UNLOCK();
                    /* WARNING: Could not recover jumptable at 0x1000523b. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (*(code *)UNRECOVERED_JUMPTABLE)();
  return;
}


/* ==== FUNCTION FUN_1000523d @ 1000523d size=7 ==== */

void FUN_1000523d(undefined4 param_1,undefined *UNRECOVERED_JUMPTABLE)

{
  LOCK();
  UNLOCK();
                    /* WARNING: Could not recover jumptable at 0x10005242. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (*(code *)UNRECOVERED_JUMPTABLE)();
  return;
}


/* ==== FUNCTION FUN_10005244 @ 10005244 size=7 ==== */

void FUN_10005244(undefined4 param_1,undefined *UNRECOVERED_JUMPTABLE)

{
  LOCK();
  UNLOCK();
                    /* WARNING: Could not recover jumptable at 0x10005249. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (*(code *)UNRECOVERED_JUMPTABLE)();
  return;
}


/* ==== FUNCTION FUN_1000524b @ 1000524b size=79 ==== */

void FUN_1000524b(PVOID param_1,PEXCEPTION_RECORD param_2)

{
  void *pvVar1;
  
  pvVar1 = ExceptionList;
  RtlUnwind(param_1,(PVOID)0x10005273,param_2,(PVOID)0x0);
  param_2->ExceptionFlags = param_2->ExceptionFlags & 0xfffffffd;
  *(void **)pvVar1 = ExceptionList;
  ExceptionList = pvVar1;
  return;
}


/* ==== FUNCTION FUN_1000529a @ 1000529a size=54 ==== */

undefined4 __cdecl
FUN_1000529a(PEXCEPTION_RECORD param_1,PVOID param_2,undefined4 param_3,undefined4 param_4)

{
  int *in_EAX;
  undefined4 uVar1;
  
  uVar1 = FUN_100067ec(param_1,param_2,param_3,param_4,in_EAX,0,(PVOID)0x0,'\0');
  return uVar1;
}


/* ==== FUNCTION FUN_100052ea @ 100052ea size=84 ==== */

undefined4 __cdecl
FUN_100052ea(undefined4 param_1,undefined4 param_2,undefined4 param_3,int param_4,int param_5)

{
  undefined4 uVar1;
  void *local_18;
  code *local_14;
  undefined4 local_10;
  undefined4 local_c;
  int local_8;
  
  local_10 = param_2;
  local_14 = FUN_1000533e;
  local_8 = param_4 + 1;
  local_c = param_1;
  local_18 = ExceptionList;
  ExceptionList = &local_18;
  uVar1 = __CallSettingFrame_12(param_3,param_1,param_5);
  ExceptionList = local_18;
  return uVar1;
}


/* ==== FUNCTION FUN_1000533e @ 1000533e size=37 ==== */

void __cdecl FUN_1000533e(PEXCEPTION_RECORD param_1,PVOID param_2,undefined4 param_3)

{
  FUN_100067ec(param_1,*(PVOID *)((int)param_2 + 0xc),param_3,0,*(int **)((int)param_2 + 8),
               *(int *)((int)param_2 + 0x10),param_2,'\0');
  return;
}


/* ==== FUNCTION FUN_10005363 @ 10005363 size=180 ==== */

undefined4 __cdecl
FUN_10005363(undefined4 *param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4,
            undefined4 param_5,undefined4 param_6,undefined4 param_7)

{
  undefined4 *local_34;
  undefined4 local_30;
  undefined4 *local_2c;
  code *local_28;
  undefined4 local_24;
  undefined4 local_20;
  undefined4 local_1c;
  undefined4 local_18;
  undefined4 local_14;
  undefined1 *local_10;
  undefined1 *local_c;
  int local_8;
  
  local_c = &stack0xfffffffc;
  local_10 = &stack0xffffffbc;
  local_28 = FUN_10005417;
  local_24 = param_5;
  local_20 = param_2;
  local_1c = param_6;
  local_18 = param_7;
  local_8 = 0;
  local_14 = 0x100053e9;
  local_2c = ExceptionList;
  ExceptionList = &local_2c;
  local_34 = param_1;
  local_30 = param_3;
  (*DAT_1000f644)(*param_1,&local_34);
  if (local_8 != 0) {
    *local_2c = *(undefined4 *)ExceptionList;
  }
  ExceptionList = local_2c;
  return 0;
}


/* ==== FUNCTION FUN_10005417 @ 10005417 size=114 ==== */

undefined4 __cdecl FUN_10005417(PEXCEPTION_RECORD param_1,PVOID param_2,undefined4 param_3)

{
  undefined4 uVar1;
  
  if ((param_1->ExceptionFlags & 0x66) != 0) {
    *(undefined4 *)((int)param_2 + 0x24) = 1;
    return 1;
  }
  FUN_100067ec(param_1,*(PVOID *)((int)param_2 + 0xc),param_3,0,*(int **)((int)param_2 + 8),
               *(int *)((int)param_2 + 0x10),*(PVOID *)((int)param_2 + 0x14),'\x01');
  if (*(int *)((int)param_2 + 0x24) == 0) {
    FUN_1000524b(param_2,param_1);
  }
                    /* WARNING: Could not recover jumptable at 0x10005481. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  uVar1 = (**(code **)((int)param_2 + 0x18))();
  return uVar1;
}


/* ==== FUNCTION FUN_1000548c @ 1000548c size=123 ==== */

int __cdecl FUN_1000548c(int param_1,int param_2,int param_3,uint *param_4,uint *param_5)

{
  int iVar1;
  uint uVar2;
  uint uVar3;
  uint uVar4;
  uint uVar5;
  
  uVar5 = *(uint *)(param_1 + 0xc);
  iVar1 = *(int *)(param_1 + 0x10);
  uVar4 = uVar5;
  uVar3 = uVar5;
  while (uVar2 = uVar4, -1 < param_2) {
    if (uVar5 == 0xffffffff) {
      FUN_100070a2();
    }
    uVar5 = uVar5 - 1;
    if (((*(int *)(iVar1 + 4 + uVar5 * 0x14) < param_3) &&
        (param_3 <= *(int *)(iVar1 + uVar5 * 0x14 + 8))) || (uVar4 = uVar2, uVar5 == 0xffffffff)) {
      param_2 = param_2 + -1;
      uVar4 = uVar5;
      uVar3 = uVar2;
    }
  }
  uVar5 = uVar5 + 1;
  *param_4 = uVar5;
  *param_5 = uVar3;
  if ((*(uint *)(param_1 + 0xc) < uVar3) || (uVar3 < uVar5)) {
    FUN_100070a2();
  }
  return iVar1 + uVar5 * 0x14;
}


/* ==== FUNCTION __global_unwind2 @ 10005508 size=32 ==== */

/* Library Function - Single Match
    __global_unwind2
   
   Library: Visual Studio */

void __cdecl __global_unwind2(PVOID param_1)

{
  RtlUnwind(param_1,(PVOID)0x10005520,(PEXCEPTION_RECORD)0x0,(PVOID)0x0);
  return;
}


/* ==== FUNCTION __local_unwind2 @ 1000554a size=104 ==== */

/* Library Function - Single Match
    __local_unwind2
   
   Libraries: Visual Studio 1998 Debug, Visual Studio 1998 Release, Visual Studio 2003 Debug, Visual
   Studio 2003 Release */

void __cdecl __local_unwind2(int param_1,int param_2)

{
  int iVar1;
  int iVar2;
  void *pvStack_1c;
  undefined1 *puStack_18;
  undefined4 local_14;
  int iStack_10;
  
  iStack_10 = param_1;
  puStack_18 = &LAB_10005528;
  pvStack_1c = ExceptionList;
  ExceptionList = &pvStack_1c;
  while( true ) {
    iVar1 = *(int *)(param_1 + 8);
    iVar2 = *(int *)(param_1 + 0xc);
    if ((iVar2 == -1) || (iVar2 == param_2)) break;
    local_14 = *(undefined4 *)(iVar1 + iVar2 * 0xc);
    *(undefined4 *)(param_1 + 0xc) = local_14;
    if (*(int *)(iVar1 + 4 + iVar2 * 0xc) == 0) {
      FUN_100055de();
      (**(code **)(iVar1 + 8 + iVar2 * 0xc))();
    }
  }
  ExceptionList = pvStack_1c;
  return;
}


/* ==== FUNCTION __abnormal_termination @ 100055b2 size=35 ==== */

/* Library Function - Single Match
    __abnormal_termination
   
   Library: Visual Studio */

int __cdecl __abnormal_termination(void)

{
  int iVar1;
  
  iVar1 = 0;
  if ((*(undefined1 **)((int)ExceptionList + 4) == &LAB_10005528) &&
     (*(int *)((int)ExceptionList + 8) == *(int *)(*(int *)((int)ExceptionList + 0xc) + 0xc))) {
    iVar1 = 1;
  }
  return iVar1;
}


/* ==== FUNCTION __NLG_Notify1 @ 100055d5 size=9 ==== */

/* Library Function - Single Match
    __NLG_Notify1
   
   Libraries: Visual Studio 2017 Debug, Visual Studio 2017 Release, Visual Studio 2019 Debug, Visual
   Studio 2019 Release */

void __fastcall __NLG_Notify1(undefined4 param_1)

{
  undefined4 in_EAX;
  undefined4 unaff_EBP;
  
  DAT_1000ea34 = param_1;
  DAT_1000ea30 = in_EAX;
  DAT_1000ea38 = unaff_EBP;
  return;
}


/* ==== FUNCTION FUN_100055de @ 100055de size=24 ==== */

void FUN_100055de(void)

{
  undefined4 in_EAX;
  int unaff_EBP;
  
  DAT_1000ea34 = *(undefined4 *)(unaff_EBP + 8);
  DAT_1000ea30 = in_EAX;
  DAT_1000ea38 = unaff_EBP;
  return;
}


/* ==== FUNCTION FUN_10005600 @ 10005600 size=47 ==== */

/* WARNING: Unable to track spacebase fully for stack */

void FUN_10005600(void)

{
  uint in_EAX;
  undefined1 *puVar1;
  undefined4 unaff_retaddr;
  
  puVar1 = &stack0x00000004;
  for (; 0xfff < in_EAX; in_EAX = in_EAX - 0x1000) {
    puVar1 = puVar1 + -0x1000;
  }
  *(undefined4 *)(puVar1 + (-4 - in_EAX)) = unaff_retaddr;
  return;
}


/* ==== FUNCTION FUN_10005639 @ 10005639 size=30 ==== */

uint FUN_10005639(void)

{
  DAT_1000ea40 = DAT_1000ea40 * 0x343fd + 0x269ec3;
  return DAT_1000ea40 >> 0x10 & 0x7fff;
}


/* ==== FUNCTION FUN_10005657 @ 10005657 size=139 ==== */

int __thiscall FUN_10005657(void *this,byte *param_1)

{
  uint uVar1;
  uint uVar2;
  int iVar3;
  uint uVar4;
  byte *pbVar5;
  undefined *puVar6;
  
  while( true ) {
    if (DAT_1000ec94 < 2) {
      uVar1 = (byte)PTR_DAT_1000ea88[(uint)*param_1 * 2] & 8;
      this = PTR_DAT_1000ea88;
    }
    else {
      puVar6 = (undefined *)0x8;
      uVar1 = FUN_100070f8(this,(uint)*param_1,8);
      this = puVar6;
    }
    if (uVar1 == 0) break;
    param_1 = param_1 + 1;
  }
  uVar1 = (uint)*param_1;
  pbVar5 = param_1 + 1;
  if ((uVar1 == 0x2d) || (uVar4 = uVar1, uVar1 == 0x2b)) {
    uVar4 = (uint)*pbVar5;
    pbVar5 = param_1 + 2;
  }
  iVar3 = 0;
  while( true ) {
    if (DAT_1000ec94 < 2) {
      uVar2 = (byte)PTR_DAT_1000ea88[uVar4 * 2] & 4;
    }
    else {
      puVar6 = (undefined *)0x4;
      uVar2 = FUN_100070f8(this,uVar4,4);
      this = puVar6;
    }
    if (uVar2 == 0) break;
    iVar3 = (uVar4 - 0x30) + iVar3 * 10;
    uVar4 = (uint)*pbVar5;
    pbVar5 = pbVar5 + 1;
  }
  if (uVar1 == 0x2d) {
    iVar3 = -iVar3;
  }
  return iVar3;
}


/* ==== FUNCTION FUN_100056e2 @ 100056e2 size=11 ==== */

void __thiscall FUN_100056e2(void *this,byte *param_1)

{
  FUN_10005657(this,param_1);
  return;
}


/* ==== FUNCTION FUN_100057b0 @ 100057b0 size=62 ==== */

int __cdecl FUN_100057b0(byte *param_1,byte *param_2)

{
  byte bVar1;
  int iVar2;
  byte abStack_28 [32];
  
  abStack_28[0x1c] = 0;
  abStack_28[0x1d] = 0;
  abStack_28[0x1e] = 0;
  abStack_28[0x1f] = 0;
  abStack_28[0x18] = 0;
  abStack_28[0x19] = 0;
  abStack_28[0x1a] = 0;
  abStack_28[0x1b] = 0;
  abStack_28[0x14] = 0;
  abStack_28[0x15] = 0;
  abStack_28[0x16] = 0;
  abStack_28[0x17] = 0;
  abStack_28[0x10] = 0;
  abStack_28[0x11] = 0;
  abStack_28[0x12] = 0;
  abStack_28[0x13] = 0;
  abStack_28[0xc] = 0;
  abStack_28[0xd] = 0;
  abStack_28[0xe] = 0;
  abStack_28[0xf] = 0;
  abStack_28[8] = 0;
  abStack_28[9] = 0;
  abStack_28[10] = 0;
  abStack_28[0xb] = 0;
  abStack_28[4] = 0;
  abStack_28[5] = 0;
  abStack_28[6] = 0;
  abStack_28[7] = 0;
  abStack_28[0] = 0;
  abStack_28[1] = 0;
  abStack_28[2] = 0;
  abStack_28[3] = 0;
  while( true ) {
    bVar1 = *param_2;
    if (bVar1 == 0) break;
    param_2 = param_2 + 1;
    abStack_28[(int)(uint)bVar1 >> 3] = abStack_28[(int)(uint)bVar1 >> 3] | '\x01' << (bVar1 & 7);
  }
  iVar2 = -1;
  do {
    iVar2 = iVar2 + 1;
    bVar1 = *param_1;
    if (bVar1 == 0) {
      return iVar2;
    }
    param_1 = param_1 + 1;
  } while ((abStack_28[(int)(uint)bVar1 >> 3] >> (bVar1 & 7) & 1) == 0);
  return iVar2;
}


/* ==== FUNCTION FUN_100057ee @ 100057ee size=184 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_100057ee(undefined4 param_1,int param_2)

{
  int iVar1;
  
  if (param_2 == 1) {
    DAT_1000f658 = GetVersion();
    iVar1 = FUN_100072c4(0);
    if (iVar1 == 0) {
      return 0;
    }
    _DAT_1000f664 = DAT_1000f658 >> 8 & 0xff;
    _DAT_1000f660 = DAT_1000f658 & 0xff;
    DAT_1000f658 = DAT_1000f658 >> 0x10;
    _DAT_1000f65c = _DAT_1000f660 * 0x100 + _DAT_1000f664;
    DAT_10010bb8 = GetCommandLineA();
    DAT_1000f61c = FUN_10007849();
    FUN_10007375();
    FUN_100075fc();
    FUN_10007543();
    FUN_100071a4();
    DAT_1000f618 = DAT_1000f618 + 1;
  }
  else if (param_2 == 0) {
    if (DAT_1000f618 < 1) {
      return 0;
    }
    DAT_1000f618 = DAT_1000f618 + -1;
    if (DAT_1000f690 == 0) {
      FUN_100071f3();
    }
    FUN_10007520();
    FUN_10007300();
  }
  return 1;
}


/* ==== FUNCTION entry @ 100058a6 size=157 ==== */

int entry(undefined4 param_1,int param_2,undefined4 param_3)

{
  int iVar1;
  int iVar2;
  int iVar3;
  
  iVar1 = param_2;
  iVar2 = DAT_1000f618;
  if (param_2 != 0) {
    if ((param_2 != 1) && (param_2 != 2)) goto LAB_100058ee;
    if ((DAT_10010bbc != (code *)0x0) &&
       (iVar2 = (*DAT_10010bbc)(param_1,param_2,param_3), iVar2 == 0)) {
      return 0;
    }
    iVar2 = FUN_100057ee(param_1,param_2);
  }
  if (iVar2 == 0) {
    return 0;
  }
LAB_100058ee:
  iVar2 = FUN_10004e70(param_1);
  if (param_2 == 1) {
    if (iVar2 != 0) {
      return iVar2;
    }
    FUN_100057ee(param_1,0);
  }
  if ((param_2 != 0) && (param_2 != 3)) {
    return iVar2;
  }
  iVar3 = FUN_100057ee(param_1,param_2);
  param_2 = iVar2;
  if (iVar3 == 0) {
    param_2 = 0;
  }
  if (param_2 != 0) {
    if (DAT_10010bbc != (code *)0x0) {
      iVar2 = (*DAT_10010bbc)(param_1,iVar1,param_3);
      return iVar2;
    }
    return param_2;
  }
  return 0;
}


/* ==== FUNCTION __amsg_exit @ 10005943 size=48 ==== */

/* Library Function - Single Match
    __amsg_exit
   
   Library: Visual Studio 2003 Release */

void __cdecl __amsg_exit(int param_1)

{
  if ((DAT_1000f624 == 1) || ((DAT_1000f624 == 0 && (DAT_1000f628 == 1)))) {
    FUN_1000797b();
  }
  FUN_100079b4(param_1);
  (*(code *)PTR___exit_1000ea50)(0xff);
  return;
}


/* ==== FUNCTION FUN_10005976 @ 10005976 size=18 ==== */

void __fastcall FUN_10005976(void *param_1)

{
  FUN_10007b94(param_1,0x10000,0x30000);
  return;
}


/* ==== FUNCTION FUN_10005988 @ 10005988 size=62 ==== */

/* WARNING: Removing unreachable block (ram,0x100059bd) */

undefined4 FUN_10005988(void)

{
  return 0;
}


/* ==== FUNCTION FUN_100059c6 @ 100059c6 size=41 ==== */

void FUN_100059c6(void)

{
  HMODULE hModule;
  FARPROC pFVar1;
  
  hModule = GetModuleHandleA("KERNEL32");
  if (hModule != (HMODULE)0x0) {
    pFVar1 = GetProcAddress(hModule,"IsProcessorFeaturePresent");
    if (pFVar1 != (FARPROC)0x0) {
      (*pFVar1)(0);
      return;
    }
  }
  FUN_10005988();
  return;
}


/* ==== FUNCTION FUN_100059ef @ 100059ef size=90 ==== */

void __thiscall FUN_100059ef(void *this,char *param_1)

{
  char cVar1;
  char cVar2;
  undefined *this_00;
  uint uVar3;
  undefined *puVar4;
  
  this_00 = (undefined *)(int)*param_1;
  uVar3 = FUN_10007d2c(this,(uint)this_00);
  if (uVar3 != 0x65) {
    do {
      param_1 = param_1 + 1;
      if (DAT_1000ec94 < 2) {
        uVar3 = (byte)PTR_DAT_1000ea88[*param_1 * 2] & 4;
        this_00 = PTR_DAT_1000ea88;
      }
      else {
        puVar4 = (undefined *)0x4;
        uVar3 = FUN_100070f8(this_00,(int)*param_1,4);
        this_00 = puVar4;
      }
    } while (uVar3 != 0);
  }
  cVar2 = *param_1;
  *param_1 = DAT_1000ec98;
  do {
    param_1 = param_1 + 1;
    cVar1 = *param_1;
    *param_1 = cVar2;
    cVar2 = cVar1;
  } while (*param_1 != '\0');
  return;
}


/* ==== FUNCTION __fassign @ 10005aaf size=62 ==== */

/* Library Function - Single Match
    __fassign
   
   Library: Visual Studio 2003 Release */

void __cdecl __fassign(int flag,char *argument,char *number)

{
  void *in_ECX;
  void *local_c;
  void *local_8;
  
  if (flag != 0) {
    local_c = in_ECX;
    local_8 = in_ECX;
    FUN_10008203(in_ECX,(uint *)&local_c,(byte *)number);
    *(void **)argument = local_c;
    *(void **)(argument + 4) = local_8;
    return;
  }
  FUN_1000825e(in_ECX,(uint *)&number,(byte *)number);
  *(char **)argument = number;
  return;
}


/* ==== FUNCTION FUN_10005aed @ 10005aed size=260 ==== */

undefined1 * __cdecl FUN_10005aed(undefined4 param_1,undefined1 *param_2,int param_3,int param_4)

{
  int *piVar1;
  undefined1 *puVar2;
  undefined1 *puVar3;
  uint *puVar4;
  int iVar5;
  
  piVar1 = DAT_1000f62c;
  if (DAT_1000f630 == '\0') {
    piVar1 = (int *)FUN_100083f7();
    FUN_10008380(param_2 + (uint)(0 < param_3) + (uint)(*piVar1 == 0x2d),param_3 + 1,(int)piVar1);
  }
  else {
    FUN_10005e05(param_2 + (*DAT_1000f62c == 0x2d),(uint)(0 < param_3));
  }
  puVar2 = param_2;
  if (*piVar1 == 0x2d) {
    *param_2 = 0x2d;
    puVar2 = param_2 + 1;
  }
  puVar3 = puVar2;
  if (0 < param_3) {
    puVar3 = puVar2 + 1;
    *puVar2 = puVar2[1];
    *puVar3 = DAT_1000ec98;
  }
  puVar4 = FUN_10008290((uint *)(puVar3 + param_3 + (uint)(DAT_1000f630 == '\0')),(uint *)"e+000");
  if (param_4 != 0) {
    *(undefined1 *)puVar4 = 0x45;
  }
  if (*(char *)piVar1[3] != '0') {
    iVar5 = piVar1[1] + -1;
    if (iVar5 < 0) {
      iVar5 = -iVar5;
      *(undefined1 *)((int)puVar4 + 1) = 0x2d;
    }
    if (99 < iVar5) {
      *(char *)((int)puVar4 + 2) = *(char *)((int)puVar4 + 2) + (char)(iVar5 / 100);
      iVar5 = iVar5 % 100;
    }
    if (9 < iVar5) {
      *(char *)((int)puVar4 + 3) = *(char *)((int)puVar4 + 3) + (char)(iVar5 / 10);
      iVar5 = iVar5 % 10;
    }
    *(char *)(puVar4 + 1) = (char)puVar4[1] + (char)iVar5;
  }
  return param_2;
}


/* ==== FUNCTION FUN_10005bf1 @ 10005bf1 size=222 ==== */

char * __cdecl FUN_10005bf1(undefined4 param_1,char *param_2,size_t param_3)

{
  int *piVar1;
  int iVar2;
  char *pcVar3;
  
  piVar1 = DAT_1000f62c;
  if (DAT_1000f630 == '\0') {
    piVar1 = (int *)FUN_100083f7();
    FUN_10008380(param_2 + (*piVar1 == 0x2d),piVar1[1] + param_3,(int)piVar1);
  }
  else if (DAT_1000f634 == param_3) {
    iVar2 = (*DAT_1000f62c == 0x2d) + DAT_1000f634;
    param_2[iVar2] = '0';
    (param_2 + iVar2)[1] = '\0';
  }
  pcVar3 = param_2;
  if (*piVar1 == 0x2d) {
    *param_2 = '-';
    pcVar3 = param_2 + 1;
  }
  if (piVar1[1] < 1) {
    FUN_10005e05(pcVar3,1);
    *pcVar3 = '0';
    pcVar3 = pcVar3 + 1;
  }
  else {
    pcVar3 = pcVar3 + piVar1[1];
  }
  if (0 < (int)param_3) {
    FUN_10005e05(pcVar3,1);
    *pcVar3 = DAT_1000ec98;
    iVar2 = piVar1[1];
    if (iVar2 < 0) {
      if ((DAT_1000f630 != '\0') || (-iVar2 <= (int)param_3)) {
        param_3 = -iVar2;
      }
      FUN_10005e05(pcVar3 + 1,param_3);
      _memset(pcVar3 + 1,0x30,param_3);
    }
  }
  return param_2;
}


/* ==== FUNCTION FUN_10005ccf @ 10005ccf size=155 ==== */

void __cdecl FUN_10005ccf(undefined4 param_1,char *param_2,size_t param_3,int param_4)

{
  int iVar1;
  char *pcVar2;
  char *pcVar3;
  
  DAT_1000f62c = (int *)FUN_100083f7();
  DAT_1000f634 = DAT_1000f62c[1] + -1;
  iVar1 = *DAT_1000f62c;
  FUN_10008380(param_2 + (iVar1 == 0x2d),param_3,(int)DAT_1000f62c);
  DAT_1000f638 = DAT_1000f634 < DAT_1000f62c[1] + -1;
  DAT_1000f634 = DAT_1000f62c[1] + -1;
  if ((DAT_1000f634 < -4) || ((int)param_3 <= DAT_1000f634)) {
    FUN_10005d6a(param_1,param_2,param_3,param_4);
  }
  else {
    pcVar2 = param_2 + (iVar1 == 0x2d);
    if ((bool)DAT_1000f638) {
      do {
        pcVar3 = pcVar2;
        pcVar2 = pcVar3 + 1;
      } while (*pcVar3 != '\0');
      pcVar3[-1] = '\0';
    }
    FUN_10005d91(param_1,param_2,param_3);
  }
  return;
}


/* ==== FUNCTION FUN_10005d6a @ 10005d6a size=39 ==== */

void __cdecl FUN_10005d6a(undefined4 param_1,undefined1 *param_2,int param_3,int param_4)

{
  DAT_1000f630 = 1;
  FUN_10005aed(param_1,param_2,param_3,param_4);
  DAT_1000f630 = 0;
  return;
}


/* ==== FUNCTION FUN_10005d91 @ 10005d91 size=35 ==== */

void __cdecl FUN_10005d91(undefined4 param_1,char *param_2,size_t param_3)

{
  DAT_1000f630 = 1;
  FUN_10005bf1(param_1,param_2,param_3);
  DAT_1000f630 = 0;
  return;
}


/* ==== FUNCTION __cfltcvt @ 10005db4 size=81 ==== */

/* Library Function - Single Match
    __cfltcvt
   
   Library: Visual Studio 2003 Release */

errno_t __cdecl
__cfltcvt(double *arg,char *buffer,size_t sizeInBytes,int format,int precision,int caps)

{
  char *pcVar1;
  undefined1 *puVar2;
  
  if ((sizeInBytes == 0x65) || (sizeInBytes == 0x45)) {
    puVar2 = FUN_10005aed(arg,buffer,format,precision);
  }
  else {
    if (sizeInBytes == 0x66) {
      pcVar1 = FUN_10005bf1(arg,buffer,format);
      return (errno_t)pcVar1;
    }
    puVar2 = (undefined1 *)FUN_10005ccf(arg,buffer,format,precision);
  }
  return (errno_t)puVar2;
}


/* ==== FUNCTION FUN_10005e05 @ 10005e05 size=37 ==== */

void __cdecl FUN_10005e05(char *param_1,int param_2)

{
  size_t sVar1;
  
  if (param_2 != 0) {
    sVar1 = _strlen(param_1);
    FUN_10008580((undefined4 *)(param_1 + param_2),(undefined4 *)param_1,sVar1 + 1);
  }
  return;
}


/* ==== FUNCTION FUN_10005e2a @ 10005e2a size=47 ==== */

void __cdecl FUN_10005e2a(LPVOID param_1)

{
  uint *puVar1;
  
  if (param_1 != (LPVOID)0x0) {
    puVar1 = (uint *)FUN_1000899f((int)param_1);
    if (puVar1 != (uint *)0x0) {
      FUN_100089ca(puVar1,(uint)param_1);
      return;
    }
    HeapFree(DAT_10010ba4,0,param_1);
  }
  return;
}


/* ==== FUNCTION _malloc @ 10005e59 size=18 ==== */

/* Library Function - Single Match
    _malloc
   
   Library: Visual Studio 2003 Release */

void * __cdecl _malloc(size_t _Size)

{
  void *pvVar1;
  
  pvVar1 = __nh_malloc(_Size,DAT_1000f7d8);
  return pvVar1;
}


/* ==== FUNCTION __nh_malloc @ 10005e6b size=44 ==== */

/* Library Function - Single Match
    __nh_malloc
   
   Library: Visual Studio 2003 Release */

void * __cdecl __nh_malloc(size_t _Size,int _NhFlag)

{
  void *pvVar1;
  int iVar2;
  
  if (_Size < 0xffffffe1) {
    do {
      pvVar1 = (void *)FUN_10005e97((uint *)_Size);
      if (pvVar1 != (void *)0x0) {
        return pvVar1;
      }
      if (_NhFlag == 0) {
        return (void *)0x0;
      }
      iVar2 = FUN_100098b6(_Size);
    } while (iVar2 != 0);
  }
  return (void *)0x0;
}


/* ==== FUNCTION FUN_10005e97 @ 10005e97 size=54 ==== */

void __cdecl FUN_10005e97(uint *param_1)

{
  int *piVar1;
  
  if ((param_1 <= DAT_1000ed70) && (piVar1 = FUN_10008cf5(param_1), piVar1 != (int *)0x0)) {
    return;
  }
  if (param_1 == (uint *)0x0) {
    param_1 = (uint *)0x1;
  }
  HeapAlloc(DAT_10010ba4,0,(int)param_1 + 0xfU & 0xfffffff0);
  return;
}


/* ==== FUNCTION FUN_10005ecd @ 10005ecd size=277 ==== */

uint __cdecl FUN_10005ecd(uint param_1,int *param_2)

{
  uint uVar1;
  uint uVar2;
  char *pcVar3;
  int *piVar4;
  byte bVar5;
  undefined3 extraout_var;
  undefined *puVar6;
  int *piVar7;
  
  piVar4 = param_2;
  uVar1 = param_2[3];
  uVar2 = param_2[4];
  if (((uVar1 & 0x82) == 0) || ((uVar1 & 0x40) != 0)) {
LAB_10005fd6:
    param_2[3] = uVar1 | 0x20;
  }
  else {
    if ((uVar1 & 1) != 0) {
      param_2[1] = 0;
      if ((uVar1 & 0x10) == 0) goto LAB_10005fd6;
      *param_2 = param_2[2];
      param_2[3] = uVar1 & 0xfffffffe;
    }
    uVar1 = param_2[3];
    param_2[1] = 0;
    param_2 = (int *)0x0;
    piVar4[3] = uVar1 & 0xffffffef | 2;
    if (((uVar1 & 0x10c) == 0) &&
       (((piVar4 != (int *)&DAT_1000ed98 && (piVar4 != (int *)&DAT_1000edb8)) ||
        (bVar5 = FUN_10009b5c(uVar2), CONCAT31(extraout_var,bVar5) == 0)))) {
      FUN_10009b18(piVar4);
    }
    if ((*(ushort *)(piVar4 + 3) & 0x108) == 0) {
      piVar7 = (int *)0x1;
      param_2 = (int *)FUN_1000996b(uVar2,(char *)&param_1,1);
    }
    else {
      pcVar3 = (char *)piVar4[2];
      piVar7 = (int *)(*piVar4 - (int)pcVar3);
      *piVar4 = (int)(pcVar3 + 1);
      piVar4[1] = piVar4[6] + -1;
      if ((int)piVar7 < 1) {
        if (uVar2 == 0xffffffff) {
          puVar6 = &DAT_1000eca8;
        }
        else {
          puVar6 = (undefined *)((&DAT_10010aa0)[(int)uVar2 >> 5] + (uVar2 & 0x1f) * 8);
        }
        if ((puVar6[4] & 0x20) != 0) {
          FUN_100098d1(uVar2,0,2);
        }
      }
      else {
        param_2 = (int *)FUN_1000996b(uVar2,pcVar3,(uint)piVar7);
      }
      *(undefined1 *)piVar4[2] = (undefined1)param_1;
    }
    if (param_2 == piVar7) {
      return param_1 & 0xff;
    }
    piVar4[3] = piVar4[3] | 0x20;
  }
  return 0xffffffff;
}


/* ==== FUNCTION FUN_10005fe2 @ 10005fe2 size=1825 ==== */

int __cdecl FUN_10005fe2(int *param_1,byte *param_2,undefined4 *param_3)

{
  byte *pbVar1;
  uint uVar2;
  WCHAR *pWVar3;
  WCHAR *pWVar4;
  undefined4 uVar5;
  short *psVar6;
  int *piVar7;
  int iVar8;
  byte bVar9;
  int iVar10;
  uint uVar11;
  undefined1 *puVar12;
  ulonglong uVar13;
  undefined8 uVar14;
  ulonglong uVar15;
  undefined1 local_24c [511];
  undefined1 local_4d;
  undefined4 local_4c;
  undefined4 local_48;
  uint local_44;
  uint local_40;
  CHAR local_3c [4];
  undefined4 local_38;
  int local_34;
  int local_30;
  int local_2c;
  int local_28;
  int local_24;
  int local_20;
  char local_1a;
  char local_19;
  int local_18;
  int local_14;
  undefined1 *local_10;
  WCHAR *local_c;
  uint local_8;
  
  local_34 = 0;
  bVar9 = *param_2;
  local_10 = (undefined1 *)0x0;
  local_18 = 0;
  pbVar1 = param_2;
  do {
    if ((bVar9 == 0) || (param_2 = pbVar1 + 1, local_18 < 0)) {
      return local_18;
    }
    if (((char)bVar9 < ' ') || ('x' < (char)bVar9)) {
      uVar2 = 0;
    }
    else {
      uVar2 = (byte)"GAIsProcessorFeaturePresent"[(char)bVar9 + 0x1a] & 0xf;
    }
    local_34 = (int)(char)(&DAT_1000d1b0)[uVar2 * 8 + local_34] >> 4;
    switch(local_34) {
    case 0:
switchD_10006050_caseD_0:
      local_28 = 0;
      if ((PTR_DAT_1000ea88[(uint)bVar9 * 2 + 1] & 0x80) != 0) {
        FUN_10006723((int)(char)bVar9,param_1,&local_18);
        bVar9 = *param_2;
        param_2 = pbVar1 + 2;
      }
      FUN_10006723((int)(char)bVar9,param_1,&local_18);
      break;
    case 1:
      local_14 = -1;
      local_38 = 0;
      local_2c = 0;
      local_24 = 0;
      local_20 = 0;
      local_8 = 0;
      local_28 = 0;
      break;
    case 2:
      if (bVar9 == 0x20) {
        local_8 = local_8 | 2;
      }
      else if (bVar9 == 0x23) {
        local_8 = local_8 | 0x80;
      }
      else if (bVar9 == 0x2b) {
        local_8 = local_8 | 1;
      }
      else if (bVar9 == 0x2d) {
        local_8 = local_8 | 4;
      }
      else if (bVar9 == 0x30) {
        local_8 = local_8 | 8;
      }
      break;
    case 3:
      if (bVar9 == 0x2a) {
        local_24 = FUN_100067c1((int *)&param_3);
        if (local_24 < 0) {
          local_8 = local_8 | 4;
          local_24 = -local_24;
        }
      }
      else {
        local_24 = (char)bVar9 + -0x30 + local_24 * 10;
      }
      break;
    case 4:
      local_14 = 0;
      break;
    case 5:
      if (bVar9 == 0x2a) {
        local_14 = FUN_100067c1((int *)&param_3);
        if (local_14 < 0) {
          local_14 = -1;
        }
      }
      else {
        local_14 = (char)bVar9 + -0x30 + local_14 * 10;
      }
      break;
    case 6:
      if (bVar9 == 0x49) {
        if ((*param_2 != 0x36) || (pbVar1[2] != 0x34)) {
          local_34 = 0;
          goto switchD_10006050_caseD_0;
        }
        param_2 = pbVar1 + 3;
        local_8 = local_8 | 0x8000;
      }
      else if (bVar9 == 0x68) {
        local_8 = local_8 | 0x20;
      }
      else if (bVar9 == 0x6c) {
        local_8 = local_8 | 0x10;
      }
      else if (bVar9 == 0x77) {
        local_8 = local_8 | 0x800;
      }
      break;
    case 7:
      pWVar4 = local_c;
      if ((char)bVar9 < 'h') {
        if ((char)bVar9 < 'e') {
          if ((char)bVar9 < 'Y') {
            if (bVar9 == 0x58) {
LAB_10006461:
              local_30 = 7;
LAB_10006468:
              local_10 = (undefined1 *)0x10;
              if ((local_8 & 0x80) != 0) {
                local_1a = '0';
                local_19 = (char)local_30 + 'Q';
                local_20 = 2;
              }
              goto LAB_100064d2;
            }
            if (bVar9 != 0x43) {
              if ((bVar9 != 0x45) && (bVar9 != 0x47)) {
                if (bVar9 == 0x53) {
                  if ((local_8 & 0x830) == 0) {
                    local_8 = local_8 | 0x800;
                  }
                  goto LAB_1000620f;
                }
                goto LAB_100065ec;
              }
              local_38 = 1;
              bVar9 = bVar9 + 0x20;
              goto LAB_10006270;
            }
            if ((local_8 & 0x830) == 0) {
              local_8 = local_8 | 0x800;
            }
LAB_1000629d:
            if ((local_8 & 0x810) == 0) {
              uVar5 = FUN_100067c1((int *)&param_3);
              local_24c[0] = (char)uVar5;
              local_10 = (undefined1 *)0x1;
            }
            else {
              uVar5 = FUN_100067de((int *)&param_3);
              local_10 = (undefined1 *)FUN_10009c3b(local_24c,(WCHAR)uVar5);
              if ((int)local_10 < 0) {
                local_2c = 1;
              }
            }
            pWVar4 = (WCHAR *)local_24c;
          }
          else if (bVar9 == 0x5a) {
            psVar6 = (short *)FUN_100067c1((int *)&param_3);
            if ((psVar6 == (short *)0x0) ||
               (pWVar4 = *(WCHAR **)(psVar6 + 2), pWVar4 == (WCHAR *)0x0)) {
              local_c = (WCHAR *)PTR_DAT_1000ea6c;
              pWVar4 = (WCHAR *)PTR_DAT_1000ea6c;
              goto LAB_100063e2;
            }
            if ((local_8 & 0x800) == 0) {
              local_28 = 0;
              local_10 = (undefined1 *)(int)*psVar6;
            }
            else {
              local_28 = 1;
              local_10 = (undefined1 *)((uint)(int)*psVar6 >> 1);
            }
          }
          else {
            if (bVar9 == 99) goto LAB_1000629d;
            if (bVar9 == 100) goto LAB_100064c7;
          }
        }
        else {
LAB_10006270:
          local_8 = local_8 | 0x40;
          pWVar4 = (WCHAR *)local_24c;
          if (local_14 < 0) {
            local_14 = 6;
          }
          else if ((local_14 == 0) && (bVar9 == 0x67)) {
            local_14 = 1;
          }
          local_4c = *param_3;
          local_48 = param_3[1];
          param_3 = param_3 + 2;
          local_c = pWVar4;
          (*(code *)PTR___fptrap_1000ea54)(&local_4c,local_24c,(int)(char)bVar9,local_14,local_38);
          uVar2 = local_8 & 0x80;
          if ((uVar2 != 0) && (local_14 == 0)) {
            (*(code *)PTR___fptrap_1000ea60)(local_24c);
          }
          if ((bVar9 == 0x67) && (uVar2 == 0)) {
            (*(code *)PTR___fptrap_1000ea58)(local_24c);
          }
          if (local_24c[0] == '-') {
            local_8 = local_8 | 0x100;
            pWVar4 = (WCHAR *)(local_24c + 1);
            local_c = pWVar4;
          }
LAB_100063e2:
          local_10 = (undefined1 *)_strlen((char *)pWVar4);
          pWVar4 = local_c;
        }
      }
      else {
        if (bVar9 == 0x69) {
LAB_100064c7:
          local_8 = local_8 | 0x40;
        }
        else {
          if (bVar9 == 0x6e) {
            piVar7 = (int *)FUN_100067c1((int *)&param_3);
            if ((local_8 & 0x20) == 0) {
              *piVar7 = local_18;
            }
            else {
              *(undefined2 *)piVar7 = (undefined2)local_18;
            }
            local_2c = 1;
            break;
          }
          if (bVar9 == 0x6f) {
            local_10 = (undefined1 *)0x8;
            if ((local_8 & 0x80) != 0) {
              local_8 = local_8 | 0x200;
            }
            goto LAB_100064d2;
          }
          if (bVar9 == 0x70) {
            local_14 = 8;
            goto LAB_10006461;
          }
          if (bVar9 == 0x73) {
LAB_1000620f:
            iVar10 = local_14;
            if (local_14 == -1) {
              iVar10 = 0x7fffffff;
            }
            pWVar3 = (WCHAR *)FUN_100067c1((int *)&param_3);
            if ((local_8 & 0x810) == 0) {
              pWVar4 = pWVar3;
              if (pWVar3 == (WCHAR *)0x0) {
                pWVar3 = (WCHAR *)PTR_DAT_1000ea6c;
                pWVar4 = (WCHAR *)PTR_DAT_1000ea6c;
              }
              for (; (iVar10 != 0 && ((char)*pWVar3 != '\0')); pWVar3 = (WCHAR *)((int)pWVar3 + 1))
              {
                iVar10 = iVar10 + -1;
              }
              local_10 = (undefined1 *)((int)pWVar3 - (int)pWVar4);
            }
            else {
              if (pWVar3 == (WCHAR *)0x0) {
                pWVar3 = (WCHAR *)PTR_DAT_1000ea70;
              }
              local_28 = 1;
              for (pWVar4 = pWVar3; (iVar10 != 0 && (*pWVar4 != L'\0')); pWVar4 = pWVar4 + 1) {
                iVar10 = iVar10 + -1;
              }
              local_10 = (undefined1 *)((int)pWVar4 - (int)pWVar3 >> 1);
              pWVar4 = pWVar3;
            }
            goto LAB_100065ec;
          }
          if (bVar9 != 0x75) {
            if (bVar9 != 0x78) goto LAB_100065ec;
            local_30 = 0x27;
            goto LAB_10006468;
          }
        }
        local_10 = (undefined1 *)0xa;
LAB_100064d2:
        if ((local_8 & 0x8000) == 0) {
          if ((local_8 & 0x20) == 0) {
            if ((local_8 & 0x40) == 0) {
              uVar2 = FUN_100067c1((int *)&param_3);
              uVar13 = (ulonglong)uVar2;
              goto LAB_10006525;
            }
            uVar2 = FUN_100067c1((int *)&param_3);
          }
          else if ((local_8 & 0x40) == 0) {
            uVar2 = FUN_100067c1((int *)&param_3);
            uVar2 = uVar2 & 0xffff;
          }
          else {
            uVar5 = FUN_100067c1((int *)&param_3);
            uVar2 = (uint)(short)uVar5;
          }
          uVar13 = (ulonglong)(int)uVar2;
        }
        else {
          uVar13 = FUN_100067ce((int *)&param_3);
        }
LAB_10006525:
        iVar10 = (int)(uVar13 >> 0x20);
        if ((((local_8 & 0x40) != 0) && (iVar10 == 0 || (longlong)uVar13 < 0)) &&
           ((longlong)uVar13 < 0)) {
          local_8 = local_8 | 0x100;
          uVar13 = CONCAT44(-(iVar10 + (uint)((int)uVar13 != 0)),-(int)uVar13);
        }
        uVar2 = (uint)(uVar13 >> 0x20);
        uVar15 = uVar13 & 0xffffffff;
        if ((local_8 & 0x8000) == 0) {
          uVar2 = 0;
        }
        if (local_14 < 0) {
          local_14 = 1;
        }
        else {
          local_8 = local_8 & 0xfffffff7;
        }
        if ((int)uVar13 == 0 && uVar2 == 0) {
          local_20 = 0;
        }
        local_c = (WCHAR *)&local_4d;
        while( true ) {
          uVar11 = (uint)uVar15;
          iVar10 = local_14 + -1;
          if ((local_14 < 1) && (uVar11 == 0 && uVar2 == 0)) break;
          local_40 = (int)local_10 >> 0x1f;
          local_44 = (uint)local_10;
          local_14 = iVar10;
          uVar14 = __aullrem(uVar11,uVar2,(uint)local_10,local_40);
          iVar10 = (int)uVar14 + 0x30;
          uVar15 = __aulldiv(uVar11,uVar2,local_44,local_40);
          uVar2 = (uint)(uVar15 >> 0x20);
          if (0x39 < iVar10) {
            iVar10 = iVar10 + local_30;
          }
          pWVar4 = (WCHAR *)((int)local_c + -1);
          *(char *)local_c = (char)iVar10;
          local_c = pWVar4;
        }
        iVar8 = -(int)local_c;
        local_10 = &local_4d + iVar8;
        pWVar4 = (WCHAR *)((int)local_c + 1);
        local_14 = iVar10;
        if (((local_8 & 0x200) != 0) &&
           ((*(char *)pWVar4 != '0' || (local_10 == (undefined1 *)0x0)))) {
          *(char *)local_c = '0';
          local_10 = (undefined1 *)((int)&local_4c + iVar8);
          pWVar4 = local_c;
        }
      }
LAB_100065ec:
      local_c = pWVar4;
      uVar2 = local_8;
      if (local_2c == 0) {
        if ((local_8 & 0x40) != 0) {
          if ((local_8 & 0x100) == 0) {
            if ((local_8 & 1) == 0) {
              if ((local_8 & 2) == 0) goto LAB_10006624;
              local_1a = ' ';
            }
            else {
              local_1a = '+';
            }
          }
          else {
            local_1a = '-';
          }
          local_20 = 1;
        }
LAB_10006624:
        iVar10 = (local_24 - local_20) - (int)local_10;
        if ((local_8 & 0xc) == 0) {
          FUN_10006758(0x20,iVar10,param_1,&local_18);
        }
        FUN_10006789(&local_1a,local_20,param_1,&local_18);
        if (((uVar2 & 8) != 0) && ((uVar2 & 4) == 0)) {
          FUN_10006758(0x30,iVar10,param_1,&local_18);
        }
        if ((local_28 == 0) || (puVar12 = local_10, pWVar4 = local_c, (int)local_10 < 1)) {
          FUN_10006789((char *)local_c,(int)local_10,param_1,&local_18);
        }
        else {
          do {
            puVar12 = puVar12 + -1;
            iVar8 = FUN_10009c3b(local_3c,*pWVar4);
            if (iVar8 < 1) break;
            FUN_10006789(local_3c,iVar8,param_1,&local_18);
            pWVar4 = pWVar4 + 1;
          } while (puVar12 != (undefined1 *)0x0);
        }
        if ((local_8 & 4) != 0) {
          FUN_10006758(0x20,iVar10,param_1,&local_18);
        }
      }
    }
    bVar9 = *param_2;
    pbVar1 = param_2;
  } while( true );
}


/* ==== FUNCTION FUN_10006723 @ 10006723 size=53 ==== */

void __cdecl FUN_10006723(uint param_1,int *param_2,int *param_3)

{
  int *piVar1;
  uint uVar2;
  
  piVar1 = param_2 + 1;
  *piVar1 = *piVar1 + -1;
  if (*piVar1 < 0) {
    uVar2 = FUN_10005ecd(param_1,param_2);
  }
  else {
    *(undefined1 *)*param_2 = (undefined1)param_1;
    *param_2 = *param_2 + 1;
    uVar2 = param_1 & 0xff;
  }
  if (uVar2 == 0xffffffff) {
    *param_3 = -1;
    return;
  }
  *param_3 = *param_3 + 1;
  return;
}


/* ==== FUNCTION FUN_10006758 @ 10006758 size=49 ==== */

void __cdecl FUN_10006758(uint param_1,int param_2,int *param_3,int *param_4)

{
  do {
    if (param_2 < 1) {
      return;
    }
    param_2 = param_2 + -1;
    FUN_10006723(param_1,param_3,param_4);
  } while (*param_4 != -1);
  return;
}


/* ==== FUNCTION FUN_10006789 @ 10006789 size=56 ==== */

void __cdecl FUN_10006789(char *param_1,int param_2,int *param_3,int *param_4)

{
  char cVar1;
  
  do {
    if (param_2 < 1) {
      return;
    }
    param_2 = param_2 + -1;
    cVar1 = *param_1;
    param_1 = param_1 + 1;
    FUN_10006723((int)cVar1,param_3,param_4);
  } while (*param_4 != -1);
  return;
}


/* ==== FUNCTION FUN_100067c1 @ 100067c1 size=13 ==== */

undefined4 __cdecl FUN_100067c1(int *param_1)

{
  *param_1 = *param_1 + 4;
  return *(undefined4 *)(*param_1 + -4);
}


/* ==== FUNCTION FUN_100067ce @ 100067ce size=16 ==== */

undefined8 __cdecl FUN_100067ce(int *param_1)

{
  *param_1 = *param_1 + 8;
  return *(undefined8 *)(*param_1 + -8);
}


/* ==== FUNCTION FUN_100067de @ 100067de size=14 ==== */

undefined4 __cdecl FUN_100067de(int *param_1)

{
  *param_1 = *param_1 + 4;
  return CONCAT22((short)((uint)*param_1 >> 0x10),*(undefined2 *)(*param_1 + -4));
}


/* ==== FUNCTION FUN_100067ec @ 100067ec size=155 ==== */

undefined4 __cdecl
FUN_100067ec(PEXCEPTION_RECORD param_1,PVOID param_2,undefined4 param_3,undefined4 param_4,
            int *param_5,int param_6,PVOID param_7,char param_8)

{
  code *pcVar1;
  undefined4 uVar2;
  
  if (*param_5 != 0x19930520) {
    FUN_100070a2();
  }
  if ((param_1->ExceptionFlags & 0x66) == 0) {
    if (param_5[3] != 0) {
      if (((param_1->ExceptionCode == 0xe06d7363) && (0x19930520 < param_1->ExceptionInformation[0])
          ) && (pcVar1 = *(code **)(param_1->ExceptionInformation[2] + 8), pcVar1 != (code *)0x0)) {
        uVar2 = (*pcVar1)(param_1,param_2,param_3,param_4,param_5,param_6,param_7,param_8);
        return uVar2;
      }
      FUN_10006887(param_1,param_2,param_3,param_4,(int)param_5,param_8,param_6,param_7);
    }
  }
  else if ((param_5[1] != 0) && (param_6 == 0)) {
    FUN_10006b33((int)param_2,param_4,(int)param_5,-1);
  }
  return 1;
}


/* ==== FUNCTION FUN_10006887 @ 10006887 size=423 ==== */

void __cdecl
FUN_10006887(PEXCEPTION_RECORD param_1,PVOID param_2,undefined4 param_3,undefined4 param_4,
            int param_5,char param_6,int param_7,PVOID param_8)

{
  byte *pbVar1;
  PEXCEPTION_RECORD pEVar2;
  bool bVar3;
  undefined3 extraout_var;
  int *piVar4;
  int iVar5;
  int *piVar6;
  uint local_1c;
  uint local_18;
  int local_14;
  int local_10;
  int local_c;
  uint local_8;
  
  local_18 = local_18 & 0xffffff00;
  local_14 = *(int *)((int)param_2 + 8);
  if ((local_14 < -1) || (*(int *)(param_5 + 4) <= local_14)) {
    FUN_100070a2();
  }
  pEVar2 = DAT_1000f63c;
  if (param_1->ExceptionCode == 0xe06d7363) {
    if (((param_1->NumberParameters == 3) && (param_1->ExceptionInformation[0] == 0x19930520)) &&
       (param_1->ExceptionInformation[2] == 0)) {
      if (DAT_1000f63c == (PEXCEPTION_RECORD)0x0) {
        return;
      }
      param_3 = DAT_1000f640;
      local_18 = CONCAT31(local_18._1_3_,1);
      bVar3 = FUN_10009df9(DAT_1000f63c,1);
      if (CONCAT31(extraout_var,bVar3) == 0) {
        FUN_100070a2();
      }
      param_1 = pEVar2;
      if (pEVar2->ExceptionCode != 0xe06d7363) goto LAB_10006a03;
      if (((pEVar2->NumberParameters == 3) && (pEVar2->ExceptionInformation[0] == 0x19930520)) &&
         (pEVar2->ExceptionInformation[2] == 0)) {
        FUN_100070a2();
      }
    }
    iVar5 = local_14;
    if (((param_1->ExceptionCode == 0xe06d7363) && (param_1->NumberParameters == 3)) &&
       (param_1->ExceptionInformation[0] == 0x19930520)) {
      piVar4 = (int *)FUN_1000548c(param_5,param_7,local_14,&local_8,&local_1c);
      do {
        if (local_1c <= local_8) {
          if (param_6 == '\0') {
            return;
          }
          FUN_10006f5c((int)param_1);
          return;
        }
        if ((*piVar4 <= iVar5) && (iVar5 <= piVar4[1])) {
          pbVar1 = (byte *)piVar4[4];
          for (local_10 = piVar4[3]; iVar5 = local_14, 0 < local_10; local_10 = local_10 + -1) {
            piVar6 = *(int **)(param_1->ExceptionInformation[2] + 0xc);
            for (local_c = *piVar6; 0 < local_c; local_c = local_c + -1) {
              piVar6 = piVar6 + 1;
              iVar5 = FUN_10006ad6(pbVar1,(byte *)*piVar6,(uint *)param_1->ExceptionInformation[2]);
              if (iVar5 != 0) {
                FUN_10006be7(param_1,param_2,param_3,param_4,param_5,pbVar1,(byte *)*piVar6,piVar4,
                             param_7,param_8);
                iVar5 = local_14;
                goto LAB_100069e3;
              }
            }
            pbVar1 = pbVar1 + 0x10;
          }
        }
LAB_100069e3:
        local_8 = local_8 + 1;
        piVar4 = piVar4 + 5;
      } while( true );
    }
  }
LAB_10006a03:
  if (param_6 == '\0') {
    FUN_10006a2e(param_1,param_2,param_3,param_4,param_5,local_14,param_7,param_8);
    return;
  }
  FUN_1000703c();
  return;
}


/* ==== FUNCTION FUN_10006a2e @ 10006a2e size=168 ==== */

void __cdecl
FUN_10006a2e(PEXCEPTION_RECORD param_1,PVOID param_2,undefined4 param_3,undefined4 param_4,
            int param_5,int param_6,int param_7,PVOID param_8)

{
  int iVar1;
  int *piVar2;
  int iVar3;
  uint local_c;
  uint local_8;
  
  if ((DAT_1000f644 != 0) &&
     (iVar1 = FUN_10005363(&param_1->ExceptionCode,param_2,param_3,param_4,param_5,param_7,param_8),
     iVar1 != 0)) {
    return;
  }
  piVar2 = (int *)FUN_1000548c(param_5,param_7,param_6,&local_8,&local_c);
  for (; local_8 < local_c; local_8 = local_8 + 1) {
    if ((*piVar2 <= param_6) && (param_6 <= piVar2[1])) {
      iVar3 = piVar2[3] * 0x10 + piVar2[4];
      iVar1 = *(int *)(iVar3 + -0xc);
      if ((iVar1 == 0) || (*(char *)(iVar1 + 8) == '\0')) {
        FUN_10006be7(param_1,param_2,param_3,param_4,param_5,(byte *)(iVar3 + -0x10),(byte *)0x0,
                     piVar2,param_7,param_8);
      }
    }
    piVar2 = piVar2 + 5;
  }
  return;
}


/* ==== FUNCTION FUN_10006ad6 @ 10006ad6 size=93 ==== */

undefined4 __cdecl FUN_10006ad6(byte *param_1,byte *param_2,uint *param_3)

{
  int iVar1;
  undefined4 uVar2;
  
  iVar1 = *(int *)(param_1 + 4);
  if ((iVar1 == 0) || (*(char *)(iVar1 + 8) == '\0')) {
LAB_10006b2d:
    uVar2 = 1;
  }
  else {
    if (iVar1 == *(int *)(param_2 + 4)) {
LAB_10006b07:
      if (((((*param_2 & 2) == 0) || ((*param_1 & 8) != 0)) &&
          (((*param_3 & 1) == 0 || ((*param_1 & 1) != 0)))) &&
         (((*param_3 & 2) == 0 || ((*param_1 & 2) != 0)))) goto LAB_10006b2d;
    }
    else {
      iVar1 = _strcmp((char *)(iVar1 + 8),(char *)(*(int *)(param_2 + 4) + 8));
      if (iVar1 == 0) goto LAB_10006b07;
    }
    uVar2 = 0;
  }
  return uVar2;
}


/* ==== FUNCTION FUN_10006b33 @ 10006b33 size=132 ==== */

void __cdecl FUN_10006b33(int param_1,undefined4 param_2,int param_3,int param_4)

{
  int iVar1;
  int iVar2;
  void *local_14;
  undefined1 *puStack_10;
  undefined *puStack_c;
  undefined4 local_8;
  
  puStack_c = &DAT_1000d228;
  puStack_10 = &LAB_10009edc;
  local_14 = ExceptionList;
  ExceptionList = &local_14;
  for (iVar2 = *(int *)(param_1 + 8); local_8 = 0xffffffff, iVar2 != param_4;
      iVar2 = *(int *)(*(int *)(param_3 + 8) + iVar2 * 8)) {
    if ((iVar2 < 0) || (*(int *)(param_3 + 4) <= iVar2)) {
      FUN_100070a2();
    }
    local_8 = 0;
    iVar1 = *(int *)(*(int *)(param_3 + 8) + 4 + iVar2 * 8);
    if (iVar1 != 0) {
      __CallSettingFrame_12(iVar1,param_1,0x103);
    }
  }
  *(int *)(param_1 + 8) = iVar2;
  ExceptionList = local_14;
  return;
}


/* ==== FUNCTION FUN_10006be7 @ 10006be7 size=123 ==== */

void __cdecl
FUN_10006be7(PEXCEPTION_RECORD param_1,PVOID param_2,undefined4 param_3,undefined4 param_4,
            int param_5,byte *param_6,byte *param_7,int *param_8,int param_9,PVOID param_10)

{
  undefined *UNRECOVERED_JUMPTABLE;
  
  if (param_7 != (byte *)0x0) {
    FUN_10006d98((int)param_1,(int)param_2,param_6,param_7);
  }
  if (param_10 == (PVOID)0x0) {
    param_10 = param_2;
  }
  FUN_1000524b(param_10,param_1);
  FUN_10006b33((int)param_2,param_4,param_5,*param_8);
  *(int *)((int)param_2 + 8) = param_8[1] + 1;
  UNRECOVERED_JUMPTABLE =
       (undefined *)
       FUN_10006c62(param_1,param_2,param_3,param_5,*(undefined4 *)(param_6 + 0xc),param_9,0x100);
  if (UNRECOVERED_JUMPTABLE != (undefined *)0x0) {
    FUN_10005202(UNRECOVERED_JUMPTABLE);
  }
  return;
}


/* ==== FUNCTION FUN_10006c62 @ 10006c62 size=156 ==== */

undefined4 __cdecl
FUN_10006c62(undefined4 param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4,
            undefined4 param_5,int param_6,int param_7)

{
  undefined4 uVar1;
  void *local_14;
  undefined1 *puStack_10;
  undefined *puStack_c;
  undefined4 local_8;
  
  puStack_c = &DAT_1000d238;
  puStack_10 = &LAB_10009edc;
  local_14 = ExceptionList;
  DAT_1000f63c = param_1;
  DAT_1000f640 = param_3;
  local_8 = 1;
  ExceptionList = &local_14;
  uVar1 = FUN_100052ea(param_2,param_4,param_5,param_6,param_7);
  local_8 = 0xffffffff;
  FUN_10006d28();
  ExceptionList = local_14;
  return uVar1;
}


/* ==== FUNCTION FUN_10006d28 @ 10006d28 size=70 ==== */

void FUN_10006d28(void)

{
  int unaff_EBX;
  int unaff_EBP;
  int unaff_ESI;
  int *unaff_EDI;
  
  *(undefined4 *)(unaff_ESI + -4) = *(undefined4 *)(unaff_EBP + -0x28);
  DAT_1000f63c = *(undefined4 *)(unaff_EBP + -0x1c);
  DAT_1000f640 = *(undefined4 *)(unaff_EBP + -0x20);
  if ((((*unaff_EDI == -0x1f928c9d) && (unaff_EDI[4] == 3)) && (unaff_EDI[5] == 0x19930520)) &&
     ((*(int *)(unaff_EBP + -0x24) == unaff_EBX && (*(int *)(unaff_EBP + -0x2c) != unaff_EBX)))) {
    __abnormal_termination();
    FUN_10006f5c((int)unaff_EDI);
  }
  return;
}


/* ==== FUNCTION FUN_10006d98 @ 10006d98 size=440 ==== */

void __cdecl FUN_10006d98(int param_1,int param_2,byte *param_3,byte *param_4)

{
  int *piVar1;
  bool bVar2;
  undefined3 extraout_var;
  undefined3 extraout_var_00;
  int iVar3;
  undefined3 extraout_var_01;
  undefined3 extraout_var_02;
  undefined3 extraout_var_03;
  undefined3 extraout_var_04;
  undefined4 *puVar4;
  undefined3 extraout_var_05;
  undefined3 extraout_var_06;
  undefined3 extraout_var_07;
  uint uVar5;
  void *local_14;
  undefined1 *puStack_10;
  undefined *puStack_c;
  undefined4 local_8;
  
  puStack_c = &DAT_1000d250;
  puStack_10 = &LAB_10009edc;
  local_14 = ExceptionList;
  if (*(int *)(param_3 + 4) == 0) {
    return;
  }
  if (*(char *)(*(int *)(param_3 + 4) + 8) == '\0') {
    return;
  }
  if (*(int *)(param_3 + 8) == 0) {
    return;
  }
  piVar1 = (int *)(*(int *)(param_3 + 8) + 0xc + param_2);
  local_8 = 0;
  if ((*param_3 & 8) == 0) {
    if ((*param_4 & 1) == 0) {
      if (*(int *)(param_4 + 0x18) == 0) {
        ExceptionList = &local_14;
        bVar2 = FUN_10009df9(*(void **)(param_1 + 0x18),1);
        if ((CONCAT31(extraout_var_03,bVar2) != 0) &&
           (bVar2 = FUN_10009e15(piVar1,1), CONCAT31(extraout_var_04,bVar2) != 0)) {
          uVar5 = *(uint *)(param_4 + 0x14);
          puVar4 = (undefined4 *)FUN_10006fc3(*(int *)(param_1 + 0x18),(int *)(param_4 + 8));
          FUN_10008580(piVar1,puVar4,uVar5);
          ExceptionList = local_14;
          return;
        }
      }
      else {
        ExceptionList = &local_14;
        bVar2 = FUN_10009df9(*(void **)(param_1 + 0x18),1);
        if (((CONCAT31(extraout_var_05,bVar2) != 0) &&
            (bVar2 = FUN_10009e15(piVar1,1), CONCAT31(extraout_var_06,bVar2) != 0)) &&
           (bVar2 = FUN_10009e31(*(FARPROC *)(param_4 + 0x18)), CONCAT31(extraout_var_07,bVar2) != 0
           )) {
          if ((*param_4 & 4) != 0) {
            FUN_10006fc3(*(int *)(param_1 + 0x18),(int *)(param_4 + 8));
            FUN_10005244(piVar1,*(undefined **)(param_4 + 0x18));
            ExceptionList = local_14;
            return;
          }
          FUN_10006fc3(*(int *)(param_1 + 0x18),(int *)(param_4 + 8));
          FUN_1000523d(piVar1,*(undefined **)(param_4 + 0x18));
          ExceptionList = local_14;
          return;
        }
      }
    }
    else {
      ExceptionList = &local_14;
      bVar2 = FUN_10009df9(*(void **)(param_1 + 0x18),1);
      if ((CONCAT31(extraout_var_01,bVar2) != 0) &&
         (bVar2 = FUN_10009e15(piVar1,1), CONCAT31(extraout_var_02,bVar2) != 0)) {
        FUN_10008580(piVar1,*(undefined4 **)(param_1 + 0x18),*(uint *)(param_4 + 0x14));
        if (*(int *)(param_4 + 0x14) != 4) {
          ExceptionList = local_14;
          return;
        }
        iVar3 = *piVar1;
        if (iVar3 == 0) {
          ExceptionList = local_14;
          return;
        }
        goto LAB_10006e26;
      }
    }
  }
  else {
    ExceptionList = &local_14;
    bVar2 = FUN_10009df9(*(void **)(param_1 + 0x18),1);
    if ((CONCAT31(extraout_var,bVar2) != 0) &&
       (bVar2 = FUN_10009e15(piVar1,1), CONCAT31(extraout_var_00,bVar2) != 0)) {
      iVar3 = *(int *)(param_1 + 0x18);
      *piVar1 = iVar3;
LAB_10006e26:
      iVar3 = FUN_10006fc3(iVar3,(int *)(param_4 + 8));
      *piVar1 = iVar3;
      ExceptionList = local_14;
      return;
    }
  }
  FUN_100070a2();
  ExceptionList = local_14;
  return;
}


/* ==== FUNCTION FUN_10006f5c @ 10006f5c size=86 ==== */

void __cdecl FUN_10006f5c(int param_1)

{
  undefined *UNRECOVERED_JUMPTABLE;
  void *local_14;
  undefined1 *puStack_10;
  undefined *puStack_c;
  undefined4 local_8;
  
  puStack_c = &DAT_1000d260;
  puStack_10 = &LAB_10009edc;
  local_14 = ExceptionList;
  if ((param_1 != 0) &&
     (UNRECOVERED_JUMPTABLE = *(undefined **)(*(int *)(param_1 + 0x1c) + 4),
     UNRECOVERED_JUMPTABLE != (undefined *)0x0)) {
    local_8 = 0;
    ExceptionList = &local_14;
    FUN_10005236(*(undefined4 *)(param_1 + 0x18),UNRECOVERED_JUMPTABLE);
  }
  ExceptionList = local_14;
  return;
}


/* ==== FUNCTION FUN_10006fc3 @ 10006fc3 size=35 ==== */

int __cdecl FUN_10006fc3(int param_1,int *param_2)

{
  int iVar1;
  int iVar2;
  
  iVar1 = param_2[1];
  iVar2 = *param_2 + param_1;
  if (-1 < iVar1) {
    iVar2 = iVar2 + *(int *)(*(int *)(iVar1 + param_1) + param_2[2]) + iVar1;
  }
  return iVar2;
}


/* ==== FUNCTION __CallSettingFrame@12 @ 10006ff0 size=76 ==== */

/* WARNING: Restarted to delay deadcode elimination for space: stack */
/* Library Function - Single Match
    __CallSettingFrame@12
   
   Libraries: Visual Studio 2017 Debug, Visual Studio 2017 Release, Visual Studio 2019 Debug, Visual
   Studio 2019 Release */

void __CallSettingFrame_12(undefined4 param_1,undefined4 param_2,int param_3)

{
  code *pcVar1;
  
  pcVar1 = (code *)__NLG_Notify1(param_3);
  (*pcVar1)();
  if (param_3 == 0x100) {
    param_3 = 2;
  }
  __NLG_Notify1(param_3);
  return;
}


/* ==== FUNCTION FUN_1000703c @ 1000703c size=79 ==== */

void FUN_1000703c(void)

{
  void *pvStack_14;
  undefined1 *puStack_10;
  undefined *puStack_c;
  undefined4 local_8;
  
  puStack_c = &DAT_1000d270;
  puStack_10 = &LAB_10009edc;
  pvStack_14 = ExceptionList;
  ExceptionList = &pvStack_14;
  if (DAT_1000f648 != (code *)0x0) {
    local_8 = 1;
    ExceptionList = &pvStack_14;
    (*DAT_1000f648)();
  }
  local_8 = 0xffffffff;
  FUN_10009fb4();
  return;
}


/* ==== FUNCTION FUN_100070a2 @ 100070a2 size=79 ==== */

void FUN_100070a2(void)

{
  void *pvStack_14;
  undefined1 *puStack_10;
  undefined *puStack_c;
  undefined4 local_8;
  
  puStack_c = &DAT_1000d288;
  puStack_10 = &LAB_10009edc;
  pvStack_14 = ExceptionList;
  ExceptionList = &pvStack_14;
  if (PTR_FUN_1000ea84 != (undefined *)0x0) {
    local_8 = 1;
    ExceptionList = &pvStack_14;
    (*(code *)PTR_FUN_1000ea84)();
  }
  local_8 = 0xffffffff;
  FUN_1000703c();
  return;
}


/* ==== FUNCTION FUN_100070f8 @ 100070f8 size=117 ==== */

uint __thiscall FUN_100070f8(void *this,int param_1,uint param_2)

{
  BOOL BVar1;
  int iVar2;
  undefined4 local_8;
  
  if (param_1 + 1U < 0x101) {
    param_1._2_2_ = *(ushort *)(PTR_DAT_1000ea88 + param_1 * 2);
  }
  else {
    if ((PTR_DAT_1000ea88[(param_1 >> 8 & 0xffU) * 2 + 1] & 0x80) == 0) {
      local_8 = CONCAT31((int3)((uint)this >> 8),(char)param_1) & 0xffff00ff;
      iVar2 = 1;
    }
    else {
      local_8._0_2_ = CONCAT11((char)param_1,(char)((uint)param_1 >> 8));
      local_8 = CONCAT22((short)((uint)this >> 0x10),(undefined2)local_8) & 0xff00ffff;
      iVar2 = 2;
    }
    BVar1 = FUN_10009fcb(1,(LPCSTR)&local_8,iVar2,(LPWORD)((int)&param_1 + 2),0,0,1);
    if (BVar1 == 0) {
      return 0;
    }
  }
  return param_1._2_2_ & param_2;
}


/* ==== FUNCTION FUN_100071a4 @ 100071a4 size=45 ==== */

void FUN_100071a4(void)

{
  if (PTR_FUN_1000ea20 != (undefined *)0x0) {
    (*(code *)PTR_FUN_1000ea20)();
  }
  FUN_100072aa((undefined4 *)&DAT_1000e008,(undefined4 *)&DAT_1000e018);
  FUN_100072aa((undefined4 *)&DAT_1000e000,(undefined4 *)&DAT_1000e004);
  return;
}


/* ==== FUNCTION __exit @ 100071e2 size=17 ==== */

/* Library Function - Single Match
    __exit
   
   Library: Visual Studio 2003 Release */

void __cdecl __exit(int _Code)

{
  FUN_10007211(_Code,1,0);
  return;
}


/* ==== FUNCTION FUN_100071f3 @ 100071f3 size=15 ==== */

void FUN_100071f3(void)

{
  FUN_10007211(0,0,1);
  return;
}


/* ==== FUNCTION FUN_10007211 @ 10007211 size=153 ==== */

void __cdecl FUN_10007211(UINT param_1,int param_2,int param_3)

{
  HANDLE hProcess;
  undefined4 *puVar1;
  UINT uExitCode;
  
  if (DAT_1000f694 == 1) {
    uExitCode = param_1;
    hProcess = GetCurrentProcess();
    TerminateProcess(hProcess,uExitCode);
  }
  DAT_1000f690 = 1;
  DAT_1000f68c = (undefined1)param_3;
  if (param_2 == 0) {
    if ((DAT_10010bb4 != (undefined4 *)0x0) &&
       (puVar1 = (undefined4 *)(DAT_10010bb0 - 4), DAT_10010bb4 <= puVar1)) {
      do {
        if ((code *)*puVar1 != (code *)0x0) {
          (*(code *)*puVar1)();
        }
        puVar1 = puVar1 + -1;
      } while (DAT_10010bb4 <= puVar1);
    }
    FUN_100072aa((undefined4 *)&DAT_1000e01c,(undefined4 *)&DAT_1000e024);
  }
  FUN_100072aa((undefined4 *)&DAT_1000e028,(undefined4 *)&DAT_1000e030);
  if (param_3 != 0) {
    return;
  }
  DAT_1000f694 = 1;
                    /* WARNING: Subroutine does not return */
  ExitProcess(param_1);
}


/* ==== FUNCTION FUN_100072aa @ 100072aa size=26 ==== */

void __cdecl FUN_100072aa(undefined4 *param_1,undefined4 *param_2)

{
  for (; param_1 < param_2; param_1 = param_1 + 1) {
    if ((code *)*param_1 != (code *)0x0) {
      (*(code *)*param_1)();
    }
  }
  return;
}


/* ==== FUNCTION FUN_100072c4 @ 100072c4 size=60 ==== */

undefined4 __cdecl FUN_100072c4(int param_1)

{
  int iVar1;
  
  DAT_10010ba4 = HeapCreate((uint)(param_1 == 0),0x1000,0);
  if (DAT_10010ba4 != (HANDLE)0x0) {
    iVar1 = FUN_10008961();
    if (iVar1 != 0) {
      return 1;
    }
    HeapDestroy(DAT_10010ba4);
  }
  return 0;
}


/* ==== FUNCTION FUN_10007300 @ 10007300 size=117 ==== */

void FUN_10007300(void)

{
  int iVar1;
  undefined4 *puVar2;
  
  iVar1 = 0;
  if (0 < DAT_10010a94) {
    puVar2 = (undefined4 *)((int)DAT_10010a98 + 0xc);
    do {
      VirtualFree((LPVOID)*puVar2,0x100000,0x4000);
      VirtualFree((LPVOID)*puVar2,0,0x8000);
      HeapFree(DAT_10010ba4,0,(LPVOID)puVar2[1]);
      puVar2 = puVar2 + 5;
      iVar1 = iVar1 + 1;
    } while (iVar1 < DAT_10010a94);
  }
  HeapFree(DAT_10010ba4,0,DAT_10010a98);
  HeapDestroy(DAT_10010ba4);
  return;
}


/* ==== FUNCTION FUN_10007375 @ 10007375 size=427 ==== */

void FUN_10007375(void)

{
  undefined4 *puVar1;
  undefined4 *puVar2;
  undefined4 *puVar3;
  DWORD DVar4;
  HANDLE hFile;
  byte *pbVar5;
  int iVar6;
  UINT *pUVar7;
  UINT UVar8;
  UINT UVar9;
  uint uVar10;
  _STARTUPINFOA local_44;
  
  puVar2 = _malloc(0x100);
  if (puVar2 == (undefined4 *)0x0) {
    __amsg_exit(0x1b);
  }
  DAT_10010ba0 = 0x20;
  DAT_10010aa0 = puVar2;
  for (; puVar2 < DAT_10010aa0 + 0x40; puVar2 = puVar2 + 2) {
    *(undefined1 *)(puVar2 + 1) = 0;
    *puVar2 = 0xffffffff;
    *(undefined1 *)((int)puVar2 + 5) = 10;
  }
  GetStartupInfoA(&local_44);
  if ((local_44.cbReserved2 != 0) && ((UINT *)local_44.lpReserved2 != (UINT *)0x0)) {
    UVar8 = *(UINT *)local_44.lpReserved2;
    pUVar7 = (UINT *)((int)local_44.lpReserved2 + 4);
    pbVar5 = (byte *)(UVar8 + (int)pUVar7);
    if (0x7ff < (int)UVar8) {
      UVar8 = 0x800;
    }
    UVar9 = UVar8;
    if ((int)DAT_10010ba0 < (int)UVar8) {
      puVar2 = &DAT_10010aa4;
      do {
        puVar3 = _malloc(0x100);
        UVar9 = DAT_10010ba0;
        if (puVar3 == (undefined4 *)0x0) break;
        DAT_10010ba0 = DAT_10010ba0 + 0x20;
        *puVar2 = puVar3;
        puVar1 = puVar3;
        for (; puVar3 < puVar1 + 0x40; puVar3 = puVar3 + 2) {
          *(undefined1 *)(puVar3 + 1) = 0;
          *puVar3 = 0xffffffff;
          *(undefined1 *)((int)puVar3 + 5) = 10;
          puVar1 = (undefined4 *)*puVar2;
        }
        puVar2 = puVar2 + 1;
        UVar9 = UVar8;
      } while ((int)DAT_10010ba0 < (int)UVar8);
    }
    uVar10 = 0;
    if (0 < (int)UVar9) {
      do {
        if (((*(HANDLE *)pbVar5 != (HANDLE)0xffffffff) && ((*pUVar7 & 1) != 0)) &&
           (((*pUVar7 & 8) != 0 || (DVar4 = GetFileType(*(HANDLE *)pbVar5), DVar4 != 0)))) {
          puVar2 = (undefined4 *)((int)(&DAT_10010aa0)[(int)uVar10 >> 5] + (uVar10 & 0x1f) * 8);
          *puVar2 = *(undefined4 *)pbVar5;
          *(byte *)(puVar2 + 1) = (byte)*pUVar7;
        }
        uVar10 = uVar10 + 1;
        pUVar7 = (UINT *)((int)pUVar7 + 1);
        pbVar5 = pbVar5 + 4;
      } while ((int)uVar10 < (int)UVar9);
    }
  }
  iVar6 = 0;
  do {
    puVar2 = DAT_10010aa0 + iVar6 * 2;
    if (DAT_10010aa0[iVar6 * 2] == -1) {
      *(undefined1 *)(puVar2 + 1) = 0x81;
      if (iVar6 == 0) {
        DVar4 = 0xfffffff6;
      }
      else {
        DVar4 = 0xfffffff5 - (iVar6 != 1);
      }
      hFile = GetStdHandle(DVar4);
      if ((hFile != (HANDLE)0xffffffff) && (DVar4 = GetFileType(hFile), DVar4 != 0)) {
        *puVar2 = hFile;
        if ((DVar4 & 0xff) != 2) {
          if ((DVar4 & 0xff) == 3) {
            *(byte *)(puVar2 + 1) = *(byte *)(puVar2 + 1) | 8;
          }
          goto LAB_10007506;
        }
      }
      *(byte *)(puVar2 + 1) = *(byte *)(puVar2 + 1) | 0x40;
    }
    else {
      *(byte *)(puVar2 + 1) = *(byte *)(puVar2 + 1) | 0x80;
    }
LAB_10007506:
    iVar6 = iVar6 + 1;
    if (2 < iVar6) {
      SetHandleCount(DAT_10010ba0);
      return;
    }
  } while( true );
}


/* ==== FUNCTION FUN_10007520 @ 10007520 size=35 ==== */

void FUN_10007520(void)

{
  undefined4 *puVar1;
  
  puVar1 = &DAT_10010aa0;
  do {
    if ((LPVOID)*puVar1 != (LPVOID)0x0) {
      FUN_10005e2a((LPVOID)*puVar1);
      *puVar1 = 0;
    }
    puVar1 = puVar1 + 1;
  } while ((int)puVar1 < 0x10010ba0);
  return;
}


/* ==== FUNCTION FUN_10007543 @ 10007543 size=185 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10007543(void)

{
  char cVar1;
  size_t sVar2;
  undefined4 *puVar3;
  void *pvVar4;
  int iVar5;
  uint *puVar6;
  
  if (DAT_10010bac == 0) {
    FUN_1000a4e8();
  }
  iVar5 = 0;
  for (puVar6 = DAT_1000f61c; (char)*puVar6 != '\0'; puVar6 = (uint *)((int)puVar6 + sVar2 + 1)) {
    if ((char)*puVar6 != '=') {
      iVar5 = iVar5 + 1;
    }
    sVar2 = _strlen((char *)puVar6);
  }
  puVar3 = _malloc(iVar5 * 4 + 4);
  _DAT_1000f674 = puVar3;
  if (puVar3 == (undefined4 *)0x0) {
    __amsg_exit(9);
  }
  cVar1 = (char)*DAT_1000f61c;
  puVar6 = DAT_1000f61c;
  while (cVar1 != '\0') {
    sVar2 = _strlen((char *)puVar6);
    if ((char)*puVar6 != '=') {
      pvVar4 = _malloc(sVar2 + 1);
      *puVar3 = pvVar4;
      if (pvVar4 == (void *)0x0) {
        __amsg_exit(9);
      }
      FUN_10008290((uint *)*puVar3,puVar6);
      puVar3 = puVar3 + 1;
    }
    puVar6 = (uint *)((int)puVar6 + sVar2 + 1);
    cVar1 = (char)*puVar6;
  }
  FUN_10005e2a(DAT_1000f61c);
  DAT_1000f61c = (uint *)0x0;
  *puVar3 = 0;
  _DAT_10010ba8 = 1;
  return;
}


/* ==== FUNCTION FUN_100075fc @ 100075fc size=153 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100075fc(void)

{
  undefined4 *puVar1;
  byte *pbVar2;
  int local_c;
  int local_8;
  
  if (DAT_10010bac == 0) {
    FUN_1000a4e8();
  }
  GetModuleFileNameA((HMODULE)0x0,&DAT_1000f698,0x104);
  _DAT_1000f684 = &DAT_1000f698;
  pbVar2 = &DAT_1000f698;
  if (*DAT_10010bb8 != 0) {
    pbVar2 = DAT_10010bb8;
  }
  FUN_10007695(pbVar2,(undefined4 *)0x0,(byte *)0x0,&local_8,&local_c);
  puVar1 = _malloc(local_c + local_8 * 4);
  if (puVar1 == (undefined4 *)0x0) {
    __amsg_exit(8);
  }
  FUN_10007695(pbVar2,puVar1,(byte *)(puVar1 + local_8),&local_8,&local_c);
  _DAT_1000f66c = puVar1;
  _DAT_1000f668 = local_8 + -1;
  return;
}


/* ==== FUNCTION FUN_10007695 @ 10007695 size=436 ==== */

void __cdecl FUN_10007695(byte *param_1,undefined4 *param_2,byte *param_3,int *param_4,int *param_5)

{
  byte bVar1;
  bool bVar2;
  bool bVar3;
  byte *pbVar4;
  byte *pbVar5;
  uint uVar6;
  undefined4 *puVar7;
  
  *param_5 = 0;
  *param_4 = 1;
  if (param_2 != (undefined4 *)0x0) {
    *param_2 = param_3;
    param_2 = param_2 + 1;
  }
  if (*param_1 == 0x22) {
    while( true ) {
      bVar1 = param_1[1];
      pbVar4 = param_1 + 1;
      if ((bVar1 == 0x22) || (bVar1 == 0)) break;
      if (((*(byte *)((int)&DAT_1000f960 + bVar1 + 1) & 4) != 0) &&
         (*param_5 = *param_5 + 1, param_3 != (byte *)0x0)) {
        *param_3 = *pbVar4;
        param_3 = param_3 + 1;
        pbVar4 = param_1 + 2;
      }
      *param_5 = *param_5 + 1;
      param_1 = pbVar4;
      if (param_3 != (byte *)0x0) {
        *param_3 = *pbVar4;
        param_3 = param_3 + 1;
      }
    }
    *param_5 = *param_5 + 1;
    if (param_3 != (byte *)0x0) {
      *param_3 = 0;
      param_3 = param_3 + 1;
    }
    if (*pbVar4 == 0x22) {
      pbVar4 = param_1 + 2;
    }
  }
  else {
    do {
      *param_5 = *param_5 + 1;
      if (param_3 != (byte *)0x0) {
        *param_3 = *param_1;
        param_3 = param_3 + 1;
      }
      bVar1 = *param_1;
      pbVar4 = param_1 + 1;
      if ((*(byte *)((int)&DAT_1000f960 + bVar1 + 1) & 4) != 0) {
        *param_5 = *param_5 + 1;
        if (param_3 != (byte *)0x0) {
          *param_3 = *pbVar4;
          param_3 = param_3 + 1;
        }
        pbVar4 = param_1 + 2;
      }
      if (bVar1 == 0x20) break;
      if (bVar1 == 0) goto LAB_10007740;
      param_1 = pbVar4;
    } while (bVar1 != 9);
    if (bVar1 == 0) {
LAB_10007740:
      pbVar4 = pbVar4 + -1;
    }
    else if (param_3 != (byte *)0x0) {
      param_3[-1] = 0;
    }
  }
  bVar2 = false;
  puVar7 = param_2;
  while (*pbVar4 != 0) {
    for (; (*pbVar4 == 0x20 || (*pbVar4 == 9)); pbVar4 = pbVar4 + 1) {
    }
    if (*pbVar4 == 0) break;
    if (puVar7 != (undefined4 *)0x0) {
      *puVar7 = param_3;
      puVar7 = puVar7 + 1;
      param_2 = puVar7;
    }
    *param_4 = *param_4 + 1;
    while( true ) {
      bVar3 = true;
      uVar6 = 0;
      for (; *pbVar4 == 0x5c; pbVar4 = pbVar4 + 1) {
        uVar6 = uVar6 + 1;
      }
      if (*pbVar4 == 0x22) {
        pbVar5 = pbVar4;
        if ((uVar6 & 1) == 0) {
          if ((!bVar2) || (pbVar5 = pbVar4 + 1, pbVar4[1] != 0x22)) {
            bVar3 = false;
            pbVar5 = pbVar4;
          }
          bVar2 = !bVar2;
          puVar7 = param_2;
        }
        uVar6 = uVar6 >> 1;
        pbVar4 = pbVar5;
      }
      for (; uVar6 != 0; uVar6 = uVar6 - 1) {
        if (param_3 != (byte *)0x0) {
          *param_3 = 0x5c;
          param_3 = param_3 + 1;
        }
        *param_5 = *param_5 + 1;
      }
      bVar1 = *pbVar4;
      if ((bVar1 == 0) || ((!bVar2 && ((bVar1 == 0x20 || (bVar1 == 9)))))) break;
      if (bVar3) {
        if (param_3 == (byte *)0x0) {
          if ((*(byte *)((int)&DAT_1000f960 + bVar1 + 1) & 4) != 0) {
            pbVar4 = pbVar4 + 1;
            *param_5 = *param_5 + 1;
          }
        }
        else {
          if ((*(byte *)((int)&DAT_1000f960 + bVar1 + 1) & 4) != 0) {
            *param_3 = bVar1;
            param_3 = param_3 + 1;
            pbVar4 = pbVar4 + 1;
            *param_5 = *param_5 + 1;
          }
          *param_3 = *pbVar4;
          param_3 = param_3 + 1;
        }
        *param_5 = *param_5 + 1;
      }
      pbVar4 = pbVar4 + 1;
    }
    if (param_3 != (byte *)0x0) {
      *param_3 = 0;
      param_3 = param_3 + 1;
    }
    *param_5 = *param_5 + 1;
  }
  if (puVar7 != (undefined4 *)0x0) {
    *puVar7 = 0;
  }
  *param_4 = *param_4 + 1;
  return;
}


/* ==== FUNCTION FUN_10007849 @ 10007849 size=306 ==== */

LPSTR FUN_10007849(void)

{
  char cVar1;
  WCHAR WVar2;
  WCHAR *pWVar3;
  WCHAR *pWVar4;
  int iVar5;
  size_t _Size;
  LPSTR pCVar6;
  char *pcVar7;
  LPWCH lpWideCharStr;
  LPCH pCVar9;
  LPSTR local_8;
  char *pcVar8;
  
  lpWideCharStr = (LPWCH)0x0;
  pCVar9 = (LPCH)0x0;
  if (DAT_1000f79c == 0) {
    lpWideCharStr = GetEnvironmentStringsW();
    if (lpWideCharStr != (LPWCH)0x0) {
      DAT_1000f79c = 1;
LAB_100078a0:
      if ((lpWideCharStr == (LPWCH)0x0) &&
         (lpWideCharStr = GetEnvironmentStringsW(), lpWideCharStr == (LPWCH)0x0)) {
        return (LPSTR)0x0;
      }
      WVar2 = *lpWideCharStr;
      pWVar4 = lpWideCharStr;
      while (WVar2 != L'\0') {
        do {
          pWVar3 = pWVar4;
          pWVar4 = pWVar3 + 1;
        } while (*pWVar4 != L'\0');
        pWVar4 = pWVar3 + 2;
        WVar2 = *pWVar4;
      }
      iVar5 = ((int)pWVar4 - (int)lpWideCharStr >> 1) + 1;
      _Size = WideCharToMultiByte(0,0,lpWideCharStr,iVar5,(LPSTR)0x0,0,(LPCSTR)0x0,(LPBOOL)0x0);
      local_8 = (LPSTR)0x0;
      if (((_Size != 0) && (pCVar6 = _malloc(_Size), pCVar6 != (LPSTR)0x0)) &&
         (iVar5 = WideCharToMultiByte(0,0,lpWideCharStr,iVar5,pCVar6,_Size,(LPCSTR)0x0,(LPBOOL)0x0),
         local_8 = pCVar6, iVar5 == 0)) {
        FUN_10005e2a(pCVar6);
        local_8 = (LPSTR)0x0;
      }
      FreeEnvironmentStringsW(lpWideCharStr);
      return local_8;
    }
    pCVar9 = GetEnvironmentStrings();
    if (pCVar9 == (LPCH)0x0) {
      return (LPSTR)0x0;
    }
    DAT_1000f79c = 2;
  }
  else {
    if (DAT_1000f79c == 1) goto LAB_100078a0;
    if (DAT_1000f79c != 2) {
      return (LPSTR)0x0;
    }
  }
  if ((pCVar9 == (LPCH)0x0) && (pCVar9 = GetEnvironmentStrings(), pCVar9 == (LPCH)0x0)) {
    return (LPSTR)0x0;
  }
  cVar1 = *pCVar9;
  pcVar7 = pCVar9;
  while (cVar1 != '\0') {
    do {
      pcVar8 = pcVar7;
      pcVar7 = pcVar8 + 1;
    } while (*pcVar7 != '\0');
    pcVar7 = pcVar8 + 2;
    cVar1 = *pcVar7;
  }
  pCVar6 = _malloc((size_t)(pcVar7 + (1 - (int)pCVar9)));
  if (pCVar6 == (LPSTR)0x0) {
    pCVar6 = (LPSTR)0x0;
  }
  else {
    FUN_1000a510((undefined4 *)pCVar6,(undefined4 *)pCVar9,(uint)(pcVar7 + (1 - (int)pCVar9)));
  }
  FreeEnvironmentStringsA(pCVar9);
  return pCVar6;
}


/* ==== FUNCTION FUN_1000797b @ 1000797b size=57 ==== */

void FUN_1000797b(void)

{
  if ((DAT_1000f624 == 1) || ((DAT_1000f624 == 0 && (DAT_1000f628 == 1)))) {
    FUN_100079b4(0xfc);
    if (DAT_1000f7a0 != (code *)0x0) {
      (*DAT_1000f7a0)();
    }
    FUN_100079b4(0xff);
  }
  return;
}


/* ==== FUNCTION FUN_100079b4 @ 100079b4 size=339 ==== */

void __cdecl FUN_100079b4(DWORD param_1)

{
  undefined4 *puVar1;
  DWORD *pDVar2;
  DWORD DVar3;
  size_t sVar4;
  HANDLE hFile;
  int iVar5;
  uint *_Dest;
  undefined1 auStackY_1e3 [7];
  LPCVOID lpBuffer;
  LPOVERLAPPED lpOverlapped;
  uint local_1a8 [65];
  uint local_a4 [40];
  
  iVar5 = 0;
  pDVar2 = &DAT_1000ecb0;
  do {
    if (param_1 == *pDVar2) break;
    pDVar2 = pDVar2 + 2;
    iVar5 = iVar5 + 1;
  } while ((int)pDVar2 < 0x1000ed40);
  if (param_1 == (&DAT_1000ecb0)[iVar5 * 2]) {
    if ((DAT_1000f624 == 1) || ((DAT_1000f624 == 0 && (DAT_1000f628 == 1)))) {
      pDVar2 = &param_1;
      puVar1 = (undefined4 *)(iVar5 * 8 + 0x1000ecb4);
      lpOverlapped = (LPOVERLAPPED)0x0;
      sVar4 = _strlen((char *)*puVar1);
      lpBuffer = (LPCVOID)*puVar1;
      hFile = GetStdHandle(0xfffffff4);
      WriteFile(hFile,lpBuffer,sVar4,pDVar2,lpOverlapped);
    }
    else if (param_1 != 0xfc) {
      DVar3 = GetModuleFileNameA((HMODULE)0x0,(LPSTR)local_1a8,0x104);
      if (DVar3 == 0) {
        FUN_10008290(local_1a8,(uint *)"<program name unknown>");
      }
      _Dest = local_1a8;
      sVar4 = _strlen((char *)local_1a8);
      if (0x3c < sVar4 + 1) {
        sVar4 = _strlen((char *)local_1a8);
        _Dest = (uint *)(auStackY_1e3 + sVar4);
        _strncpy((char *)_Dest,"...",3);
      }
      FUN_10008290(local_a4,(uint *)"Runtime Error!\n\nProgram: ");
      FUN_100082a0(local_a4,_Dest);
      FUN_100082a0(local_a4,(uint *)&DAT_1000d554);
      FUN_100082a0(local_a4,*(uint **)(iVar5 * 8 + 0x1000ecb4));
      auStackY_1e3._3_4_ = 0x10007ad8;
      FUN_1000a845(local_a4,"Microsoft Visual C++ Runtime Library",0x12010);
    }
  }
  return;
}


/* ==== FUNCTION FUN_10007b38 @ 10007b38 size=19 ==== */

void FUN_10007b38(void)

{
  byte in_FPUStatusWord;
  
  FUN_10007cef(in_FPUStatusWord);
  return;
}


/* ==== FUNCTION FUN_10007b4b @ 10007b4b size=20 ==== */

void FUN_10007b4b(void)

{
  byte in_FPUStatusWord;
  
  FUN_10007cef(in_FPUStatusWord);
  return;
}


/* ==== FUNCTION FUN_10007b5f @ 10007b5f size=53 ==== */

uint __thiscall FUN_10007b5f(void *this,uint param_1,uint param_2)

{
  uint uVar1;
  undefined2 in_FPUControlWord;
  undefined4 local_8;
  
  local_8 = CONCAT22((short)((uint)this >> 0x10),in_FPUControlWord);
  uVar1 = FUN_10007bd4(local_8);
  uVar1 = uVar1 & ~param_2 | param_1 & param_2;
  FUN_10007c66(uVar1);
  return uVar1;
}


/* ==== FUNCTION FUN_10007b94 @ 10007b94 size=22 ==== */

void __thiscall FUN_10007b94(void *this,uint param_1,uint param_2)

{
  FUN_10007b5f(this,param_1,param_2 & 0xfff7ffff);
  return;
}


/* ==== FUNCTION FUN_10007bd4 @ 10007bd4 size=146 ==== */

uint __cdecl FUN_10007bd4(uint param_1)

{
  uint uVar1;
  uint uVar2;
  
  uVar1 = 0;
  if ((param_1 & 1) != 0) {
    uVar1 = 0x10;
  }
  if ((param_1 & 4) != 0) {
    uVar1 = uVar1 | 8;
  }
  if ((param_1 & 8) != 0) {
    uVar1 = uVar1 | 4;
  }
  if ((param_1 & 0x10) != 0) {
    uVar1 = uVar1 | 2;
  }
  if ((param_1 & 0x20) != 0) {
    uVar1 = uVar1 | 1;
  }
  if ((param_1 & 2) != 0) {
    uVar1 = uVar1 | 0x80000;
  }
  uVar2 = param_1 & 0xc00;
  if (uVar2 != 0) {
    if (uVar2 == 0x400) {
      uVar1 = uVar1 | 0x100;
    }
    else if (uVar2 == 0x800) {
      uVar1 = uVar1 | 0x200;
    }
    else if (uVar2 == 0xc00) {
      uVar1 = uVar1 | 0x300;
    }
  }
  if ((param_1 & 0x300) == 0) {
    uVar1 = uVar1 | 0x20000;
  }
  else if ((param_1 & 0x300) == 0x200) {
    uVar1 = uVar1 | 0x10000;
  }
  if ((param_1 & 0x1000) != 0) {
    uVar1 = uVar1 | 0x40000;
  }
  return uVar1;
}


/* ==== FUNCTION FUN_10007c66 @ 10007c66 size=137 ==== */

uint __cdecl FUN_10007c66(uint param_1)

{
  uint uVar1;
  uint uVar2;
  
  uVar1 = (uint)((param_1 & 0x10) != 0);
  if ((param_1 & 8) != 0) {
    uVar1 = uVar1 | 4;
  }
  if ((param_1 & 4) != 0) {
    uVar1 = uVar1 | 8;
  }
  if ((param_1 & 2) != 0) {
    uVar1 = uVar1 | 0x10;
  }
  if ((param_1 & 1) != 0) {
    uVar1 = uVar1 | 0x20;
  }
  if ((param_1 & 0x80000) != 0) {
    uVar1 = uVar1 | 2;
  }
  uVar2 = param_1 & 0x300;
  if (uVar2 != 0) {
    if (uVar2 == 0x100) {
      uVar1 = uVar1 | 0x400;
    }
    else if (uVar2 == 0x200) {
      uVar1 = uVar1 | 0x800;
    }
    else if (uVar2 == 0x300) {
      uVar1 = uVar1 | 0xc00;
    }
  }
  if ((param_1 & 0x30000) == 0) {
    uVar1 = uVar1 | 0x300;
  }
  else if ((param_1 & 0x30000) == 0x10000) {
    uVar1 = uVar1 | 0x200;
  }
  if ((param_1 & 0x40000) != 0) {
    uVar1 = uVar1 | 0x1000;
  }
  return uVar1;
}


/* ==== FUNCTION FUN_10007cef @ 10007cef size=53 ==== */

uint __cdecl FUN_10007cef(byte param_1)

{
  uint uVar1;
  
  uVar1 = 0;
  if ((param_1 & 1) != 0) {
    uVar1 = 0x10;
  }
  if ((param_1 & 4) != 0) {
    uVar1 = uVar1 | 8;
  }
  if ((param_1 & 8) != 0) {
    uVar1 = uVar1 | 4;
  }
  if ((param_1 & 0x10) != 0) {
    uVar1 = uVar1 | 2;
  }
  if ((param_1 & 0x20) != 0) {
    uVar1 = uVar1 | 1;
  }
  if ((param_1 & 2) != 0) {
    uVar1 = uVar1 | 0x80000;
  }
  return uVar1;
}


/* ==== FUNCTION FUN_10007d2c @ 10007d2c size=203 ==== */

uint __thiscall FUN_10007d2c(void *this,uint param_1)

{
  uint uVar1;
  uint uVar2;
  int iVar3;
  void *local_8;
  
  uVar1 = param_1;
  if (DAT_1000f80c == 0) {
    if ((0x40 < (int)param_1) && ((int)param_1 < 0x5b)) {
      uVar1 = param_1 + 0x20;
    }
  }
  else {
    iVar3 = 1;
    local_8 = this;
    if ((int)param_1 < 0x100) {
      if (DAT_1000ec94 < 2) {
        uVar2 = (byte)PTR_DAT_1000ea88[param_1 * 2] & 1;
      }
      else {
        uVar2 = FUN_100070f8(this,param_1,1);
      }
      if (uVar2 == 0) {
        return uVar1;
      }
    }
    if ((PTR_DAT_1000ea88[((int)uVar1 >> 8 & 0xffU) * 2 + 1] & 0x80) == 0) {
      param_1 = CONCAT31((int3)(param_1 >> 8),(char)uVar1) & 0xffff00ff;
    }
    else {
      uVar2 = param_1 >> 0x10;
      param_1._0_2_ = CONCAT11((char)uVar1,(char)(uVar1 >> 8));
      param_1 = CONCAT22((short)uVar2,(undefined2)param_1) & 0xff00ffff;
      iVar3 = 2;
    }
    iVar3 = FUN_1000ab52(DAT_1000f80c,0x100,(char *)&param_1,iVar3,(LPWSTR)&local_8,3,0,1);
    if (iVar3 != 0) {
      if (iVar3 == 1) {
        uVar1 = (uint)local_8 & 0xff;
      }
      else {
        uVar1 = (uint)local_8 & 0xffff;
      }
    }
  }
  return uVar1;
}


/* ==== FUNCTION FUN_10007df7 @ 10007df7 size=73 ==== */

undefined4 __cdecl FUN_10007df7(int param_1,int param_2)

{
  int *piVar1;
  int iVar2;
  
  if ((*(uint *)(param_1 + (param_2 / 0x20) * 4) & ~(-1 << (0x1fU - (char)(param_2 % 0x20) & 0x1f)))
      != 0) {
    return 0;
  }
  iVar2 = param_2 / 0x20 + 1;
  if (iVar2 < 3) {
    piVar1 = (int *)(param_1 + iVar2 * 4);
    do {
      if (*piVar1 != 0) {
        return 0;
      }
      iVar2 = iVar2 + 1;
      piVar1 = piVar1 + 1;
    } while (iVar2 < 3);
  }
  return 1;
}


/* ==== FUNCTION FUN_10007e40 @ 10007e40 size=86 ==== */

void __cdecl FUN_10007e40(int param_1,int param_2)

{
  int iVar1;
  int iVar2;
  uint *puVar3;
  
  puVar3 = (uint *)(param_1 + (param_2 / 0x20) * 4);
  iVar1 = FUN_1000ada1(*puVar3,1 << (0x1fU - (char)(param_2 % 0x20) & 0x1f),puVar3);
  iVar2 = param_2 / 0x20 + -1;
  if (-1 < iVar2) {
    puVar3 = (uint *)(param_1 + iVar2 * 4);
    do {
      if (iVar1 == 0) {
        return;
      }
      iVar1 = FUN_1000ada1(*puVar3,1,puVar3);
      iVar2 = iVar2 + -1;
      puVar3 = puVar3 + -1;
    } while (-1 < iVar2);
  }
  return;
}


/* ==== FUNCTION FUN_10007e96 @ 10007e96 size=140 ==== */

undefined4 __cdecl FUN_10007e96(int param_1,int param_2)

{
  uint *puVar1;
  int iVar2;
  byte bVar3;
  int iVar4;
  undefined4 *puVar5;
  undefined4 local_8;
  
  local_8 = 0;
  puVar1 = (uint *)(param_1 + (param_2 / 0x20) * 4);
  bVar3 = 0x1f - (char)(param_2 % 0x20);
  if (((*puVar1 & 1 << (bVar3 & 0x1f)) != 0) &&
     (iVar2 = FUN_10007df7(param_1,param_2 + 1), iVar2 == 0)) {
    local_8 = FUN_10007e40(param_1,param_2 + -1);
  }
  *puVar1 = *puVar1 & -1 << (bVar3 & 0x1f);
  iVar2 = param_2 / 0x20 + 1;
  if (iVar2 < 3) {
    puVar5 = (undefined4 *)(param_1 + iVar2 * 4);
    for (iVar4 = 3 - iVar2; iVar4 != 0; iVar4 = iVar4 + -1) {
      *puVar5 = 0;
      puVar5 = puVar5 + 1;
    }
  }
  return local_8;
}


/* ==== FUNCTION FUN_10007f22 @ 10007f22 size=27 ==== */

void __cdecl FUN_10007f22(int param_1,undefined4 *param_2)

{
  int iVar1;
  int iVar2;
  
  iVar1 = param_1 - (int)param_2;
  iVar2 = 3;
  do {
    *(undefined4 *)(iVar1 + (int)param_2) = *param_2;
    param_2 = param_2 + 1;
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  return;
}


/* ==== FUNCTION FUN_10007f3d @ 10007f3d size=12 ==== */

void __cdecl FUN_10007f3d(undefined4 *param_1)

{
  *param_1 = 0;
  param_1[1] = 0;
  param_1[2] = 0;
  return;
}


/* ==== FUNCTION FUN_10007f49 @ 10007f49 size=27 ==== */

undefined4 __cdecl FUN_10007f49(int *param_1)

{
  int iVar1;
  
  iVar1 = 0;
  do {
    if (*param_1 != 0) {
      return 0;
    }
    iVar1 = iVar1 + 1;
    param_1 = param_1 + 1;
  } while (iVar1 < 3);
  return 1;
}


/* ==== FUNCTION FUN_10007f64 @ 10007f64 size=141 ==== */

void __cdecl FUN_10007f64(uint *param_1,uint param_2)

{
  uint uVar1;
  int iVar2;
  byte bVar3;
  int iVar4;
  int iVar5;
  uint *puVar6;
  int local_8;
  
  local_8 = 3;
  iVar2 = (int)param_2 / 0x20;
  iVar5 = (int)param_2 % 0x20;
  param_2 = 0;
  bVar3 = (byte)iVar5;
  puVar6 = param_1;
  do {
    uVar1 = *puVar6;
    *puVar6 = uVar1 >> (bVar3 & 0x1f) | param_2;
    puVar6 = puVar6 + 1;
    param_2 = (uVar1 & ~(-1 << (bVar3 & 0x1f))) << (0x20 - bVar3 & 0x1f);
    local_8 = local_8 + -1;
  } while (local_8 != 0);
  iVar5 = 2;
  iVar4 = 8;
  do {
    if (iVar5 < iVar2) {
      *(undefined4 *)(iVar4 + (int)param_1) = 0;
    }
    else {
      *(undefined4 *)(iVar4 + (int)param_1) = *(undefined4 *)(iVar4 + iVar2 * -4 + (int)param_1);
    }
    iVar5 = iVar5 + -1;
    iVar4 = iVar4 + -4;
  } while (-1 < iVar4);
  return;
}


/* ==== FUNCTION FUN_10007ff1 @ 10007ff1 size=364 ==== */

undefined4 __cdecl FUN_10007ff1(ushort *param_1,uint *param_2,int *param_3)

{
  ushort uVar1;
  int iVar2;
  uint uVar3;
  int iVar4;
  undefined4 uVar5;
  undefined4 local_1c [3];
  uint local_10;
  uint local_c;
  int local_8;
  
  uVar1 = param_1[5];
  local_10 = *(uint *)(param_1 + 3);
  local_c = *(uint *)(param_1 + 1);
  uVar3 = uVar1 & 0x7fff;
  iVar4 = uVar3 - 0x3fff;
  local_8 = (uint)*param_1 << 0x10;
  if (iVar4 == -0x3fff) {
    iVar4 = 0;
    iVar2 = FUN_10007f49((int *)&local_10);
    if (iVar2 != 0) {
LAB_1000811d:
      uVar5 = 0;
      goto LAB_1000811f;
    }
    FUN_10007f3d(&local_10);
  }
  else {
    FUN_10007f22((int)local_1c,&local_10);
    iVar2 = FUN_10007e96((int)&local_10,param_3[2]);
    if (iVar2 != 0) {
      iVar4 = uVar3 - 0x3ffe;
    }
    iVar2 = param_3[1];
    if (iVar4 < iVar2 - param_3[2]) {
      FUN_10007f3d(&local_10);
    }
    else {
      if (iVar2 < iVar4) {
        if (*param_3 <= iVar4) {
          FUN_10007f3d(&local_10);
          local_10 = local_10 | 0x80000000;
          FUN_10007f64(&local_10,param_3[3]);
          iVar4 = param_3[5] + *param_3;
          uVar5 = 1;
          goto LAB_1000811f;
        }
        local_10 = local_10 & 0x7fffffff;
        iVar4 = param_3[5] + iVar4;
        FUN_10007f64(&local_10,param_3[3]);
        goto LAB_1000811d;
      }
      FUN_10007f22((int)&local_10,local_1c);
      FUN_10007f64(&local_10,iVar2 - iVar4);
      FUN_10007e96((int)&local_10,param_3[2]);
      FUN_10007f64(&local_10,param_3[3] + 1);
    }
  }
  iVar4 = 0;
  uVar5 = 2;
LAB_1000811f:
  local_10 = iVar4 << (0x1fU - (char)param_3[3] & 0x1f) |
             -(uint)((uVar1 & 0x8000) != 0) & 0x80000000 | local_10;
  if (param_3[4] == 0x40) {
    param_2[1] = local_10;
    *param_2 = local_c;
  }
  else if (param_3[4] == 0x20) {
    *param_2 = local_10;
  }
  return uVar5;
}


/* ==== FUNCTION FUN_1000815d @ 1000815d size=22 ==== */

void __cdecl FUN_1000815d(ushort *param_1,uint *param_2)

{
  FUN_10007ff1(param_1,param_2,(int *)&DAT_1000ed40);
  return;
}


/* ==== FUNCTION FUN_10008173 @ 10008173 size=22 ==== */

void __cdecl FUN_10008173(ushort *param_1,uint *param_2)

{
  FUN_10007ff1(param_1,param_2,(int *)&DAT_1000ed58);
  return;
}


/* ==== FUNCTION FUN_10008189 @ 10008189 size=122 ==== */

undefined4 __cdecl FUN_10008189(ushort *param_1,undefined4 *param_2)

{
  ushort uVar1;
  int iVar2;
  ushort uVar3;
  undefined4 local_14;
  undefined4 local_10;
  int local_c;
  undefined4 local_8;
  
  local_8 = 0;
  uVar1 = param_1[5];
  local_14 = *(undefined4 *)(param_1 + 3);
  local_10 = *(undefined4 *)(param_1 + 1);
  local_c = (uint)*param_1 << 0x10;
  uVar3 = uVar1 & 0x7fff;
  iVar2 = FUN_10007e96((int)&local_14,0x40);
  if (iVar2 != 0) {
    local_14 = 0x80000000;
    uVar3 = uVar3 + 1;
  }
  if (uVar3 == 0x7fff) {
    local_8 = 1;
  }
  param_2[1] = local_14;
  *(ushort *)(param_2 + 2) = uVar1 & 0x8000 | uVar3;
  *param_2 = local_10;
  return local_8;
}


/* ==== FUNCTION FUN_10008203 @ 10008203 size=45 ==== */

void __thiscall FUN_10008203(void *this,uint *param_1,byte *param_2)

{
  ushort local_10 [6];
  
  FUN_1000af42(this,local_10,(int *)&param_2,param_2,0,0,0,0);
  FUN_1000815d(local_10,param_1);
  return;
}


/* ==== FUNCTION FUN_10008230 @ 10008230 size=46 ==== */

void __thiscall FUN_10008230(void *this,undefined4 *param_1,byte *param_2)

{
  ushort local_10 [6];
  
  FUN_1000af42(this,local_10,(int *)&param_2,param_2,1,0,0,0);
  FUN_10008189(local_10,param_1);
  return;
}


/* ==== FUNCTION FUN_1000825e @ 1000825e size=45 ==== */

void __thiscall FUN_1000825e(void *this,uint *param_1,byte *param_2)

{
  ushort local_10 [6];
  
  FUN_1000af42(this,local_10,(int *)&param_2,param_2,0,0,0,0);
  FUN_10008173(local_10,param_1);
  return;
}


/* ==== FUNCTION FUN_10008290 @ 10008290 size=7 ==== */

uint * __cdecl FUN_10008290(uint *param_1,uint *param_2)

{
  byte bVar1;
  uint uVar2;
  uint uVar3;
  uint *puVar4;
  
  puVar4 = param_1;
  while (((uint)param_2 & 3) != 0) {
    bVar1 = (byte)*param_2;
    uVar3 = (uint)bVar1;
    param_2 = (uint *)((int)param_2 + 1);
    if (bVar1 == 0) goto LAB_10008378;
    *(byte *)puVar4 = bVar1;
    puVar4 = (uint *)((int)puVar4 + 1);
  }
  do {
    uVar2 = *param_2;
    uVar3 = *param_2;
    param_2 = param_2 + 1;
    if (((uVar2 ^ 0xffffffff ^ uVar2 + 0x7efefeff) & 0x81010100) != 0) {
      if ((char)uVar3 == '\0') {
LAB_10008378:
        *(byte *)puVar4 = (byte)uVar3;
        return param_1;
      }
      if ((char)(uVar3 >> 8) == '\0') {
        *(short *)puVar4 = (short)uVar3;
        return param_1;
      }
      if ((uVar3 & 0xff0000) == 0) {
        *(short *)puVar4 = (short)uVar3;
        *(byte *)((int)puVar4 + 2) = 0;
        return param_1;
      }
      if ((uVar3 & 0xff000000) == 0) {
        *puVar4 = uVar3;
        return param_1;
      }
    }
    *puVar4 = uVar3;
    puVar4 = puVar4 + 1;
  } while( true );
}


/* ==== FUNCTION FUN_100082a0 @ 100082a0 size=224 ==== */

uint * __cdecl FUN_100082a0(uint *param_1,uint *param_2)

{
  byte bVar1;
  uint uVar2;
  uint *puVar3;
  uint uVar4;
  uint *puVar5;
  
  puVar3 = param_1;
  do {
    if (((uint)puVar3 & 3) == 0) goto LAB_100082bc;
    uVar4 = *puVar3;
    puVar3 = (uint *)((int)puVar3 + 1);
  } while ((byte)uVar4 != 0);
  goto LAB_100082ef;
  while( true ) {
    if ((uVar4 & 0xff0000) == 0) {
      puVar5 = (uint *)((int)puVar5 + 2);
      goto joined_r0x1000830b;
    }
    if ((uVar4 & 0xff000000) == 0) break;
LAB_100082bc:
    do {
      puVar5 = puVar3;
      puVar3 = puVar5 + 1;
    } while (((*puVar5 ^ 0xffffffff ^ *puVar5 + 0x7efefeff) & 0x81010100) == 0);
    uVar4 = *puVar5;
    if ((char)uVar4 == '\0') goto joined_r0x1000830b;
    if ((char)(uVar4 >> 8) == '\0') {
      puVar5 = (uint *)((int)puVar5 + 1);
      goto joined_r0x1000830b;
    }
  }
LAB_100082ef:
  puVar5 = (uint *)((int)puVar3 + -1);
joined_r0x1000830b:
  do {
    if (((uint)param_2 & 3) == 0) {
      do {
        uVar2 = *param_2;
        uVar4 = *param_2;
        param_2 = param_2 + 1;
        if (((uVar2 ^ 0xffffffff ^ uVar2 + 0x7efefeff) & 0x81010100) != 0) {
          if ((char)uVar4 == '\0') {
LAB_10008378:
            *(byte *)puVar5 = (byte)uVar4;
            return param_1;
          }
          if ((char)(uVar4 >> 8) == '\0') {
            *(short *)puVar5 = (short)uVar4;
            return param_1;
          }
          if ((uVar4 & 0xff0000) == 0) {
            *(short *)puVar5 = (short)uVar4;
            *(byte *)((int)puVar5 + 2) = 0;
            return param_1;
          }
          if ((uVar4 & 0xff000000) == 0) {
            *puVar5 = uVar4;
            return param_1;
          }
        }
        *puVar5 = uVar4;
        puVar5 = puVar5 + 1;
      } while( true );
    }
    bVar1 = (byte)*param_2;
    uVar4 = (uint)bVar1;
    param_2 = (uint *)((int)param_2 + 1);
    if (bVar1 == 0) goto LAB_10008378;
    *(byte *)puVar5 = bVar1;
    puVar5 = (uint *)((int)puVar5 + 1);
  } while( true );
}


/* ==== FUNCTION FUN_10008380 @ 10008380 size=119 ==== */

void __cdecl FUN_10008380(char *param_1,int param_2,int param_3)

{
  char *_Str;
  char *pcVar1;
  char *pcVar2;
  size_t sVar3;
  char *pcVar4;
  char cVar5;
  
  pcVar1 = param_1;
  pcVar4 = *(char **)(param_3 + 0xc);
  _Str = param_1 + 1;
  *param_1 = '0';
  pcVar2 = _Str;
  if (0 < param_2) {
    param_1 = (char *)param_2;
    param_2 = 0;
    do {
      cVar5 = *pcVar4;
      if (cVar5 == '\0') {
        cVar5 = '0';
      }
      else {
        pcVar4 = pcVar4 + 1;
      }
      *pcVar2 = cVar5;
      pcVar2 = pcVar2 + 1;
      param_1 = param_1 + -1;
    } while (param_1 != (char *)0x0);
  }
  *pcVar2 = '\0';
  if ((-1 < param_2) && ('4' < *pcVar4)) {
    while (pcVar2 = pcVar2 + -1, *pcVar2 == '9') {
      *pcVar2 = '0';
    }
    *pcVar2 = *pcVar2 + '\x01';
  }
  if (*pcVar1 == '1') {
    *(int *)(param_3 + 4) = *(int *)(param_3 + 4) + 1;
  }
  else {
    sVar3 = _strlen(_Str);
    FUN_10008580((undefined4 *)pcVar1,(undefined4 *)_Str,sVar3 + 1);
  }
  return;
}


/* ==== FUNCTION FUN_100083f7 @ 100083f7 size=100 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined * FUN_100083f7(void)

{
  undefined4 in_stack_ffffffd8;
  undefined2 uVar1;
  uint local_10;
  uint uStack_c;
  undefined2 uStack_8;
  
  uVar1 = (undefined2)((uint)in_stack_ffffffd8 >> 0x10);
  FUN_1000845b(&local_10,(uint *)&stack0x00000004);
  _DAT_1000f7d0 = FUN_1000b44f(local_10,uStack_c,CONCAT22(uVar1,uStack_8),0x11,0,&DAT_1000f7a8);
  _DAT_1000f7c8 = (int)DAT_1000f7aa;
  _DAT_1000f7cc = (int)DAT_1000f7a8;
  _DAT_1000f7d4 = &DAT_1000f7ac;
  return &DAT_1000f7c8;
}


/* ==== FUNCTION FUN_1000845b @ 1000845b size=182 ==== */

void __cdecl FUN_1000845b(uint *param_1,uint *param_2)

{
  ushort uVar1;
  uint uVar2;
  uint uVar3;
  int iVar4;
  uint local_8;
  
  uVar1 = *(ushort *)((int)param_2 + 6);
  uVar3 = (uVar1 & 0x7ff0) >> 4;
  uVar2 = *param_2;
  local_8 = 0x80000000;
  if (uVar3 == 0) {
    if (((param_2[1] & 0xfffff) == 0) && (uVar2 == 0)) {
      param_1[1] = 0;
      *param_1 = 0;
      *(undefined2 *)(param_1 + 2) = 0;
      return;
    }
    iVar4 = 0x3c01;
    local_8 = 0;
  }
  else if (uVar3 == 0x7ff) {
    iVar4 = 0x7fff;
  }
  else {
    iVar4 = uVar3 + 0x3c00;
  }
  local_8 = uVar2 >> 0x15 | (param_2[1] & 0xfffff) << 0xb | local_8;
  param_1[1] = local_8;
  *param_1 = uVar2 << 0xb;
  while ((local_8 & 0x80000000) == 0) {
    local_8 = *param_1 >> 0x1f | local_8 * 2;
    *param_1 = *param_1 * 2;
    param_1[1] = local_8;
    iVar4 = iVar4 + 0xffff;
  }
  *(ushort *)(param_1 + 2) = uVar1 & 0x8000 | (ushort)iVar4;
  return;
}


/* ==== FUNCTION _memset @ 10008520 size=88 ==== */

/* Library Function - Single Match
    _memset
   
   Libraries: Visual Studio 1998 Debug, Visual Studio 1998 Release */

void * __cdecl _memset(void *_Dst,int _Val,size_t _Size)

{
  uint uVar1;
  uint uVar2;
  size_t sVar3;
  uint *puVar4;
  
  if (_Size == 0) {
    return _Dst;
  }
  uVar1 = _Val & 0xff;
  puVar4 = _Dst;
  if (3 < _Size) {
    uVar2 = -(int)_Dst & 3;
    sVar3 = _Size;
    if (uVar2 != 0) {
      sVar3 = _Size - uVar2;
      do {
        *(undefined1 *)puVar4 = (undefined1)_Val;
        puVar4 = (uint *)((int)puVar4 + 1);
        uVar2 = uVar2 - 1;
      } while (uVar2 != 0);
    }
    uVar1 = uVar1 * 0x1010101;
    _Size = sVar3 & 3;
    uVar2 = sVar3 >> 2;
    if (uVar2 != 0) {
      for (; uVar2 != 0; uVar2 = uVar2 - 1) {
        *puVar4 = uVar1;
        puVar4 = puVar4 + 1;
      }
      if (_Size == 0) {
        return _Dst;
      }
    }
  }
  do {
    *(char *)puVar4 = (char)uVar1;
    puVar4 = (uint *)((int)puVar4 + 1);
    _Size = _Size - 1;
  } while (_Size != 0);
  return _Dst;
}


/* ==== FUNCTION FUN_10008580 @ 10008580 size=664 ==== */

undefined4 * __cdecl FUN_10008580(undefined4 *param_1,undefined4 *param_2,uint param_3)

{
  uint uVar1;
  uint uVar2;
  undefined4 *puVar3;
  undefined4 *puVar4;
  
  if ((param_2 < param_1) && (param_1 < (undefined4 *)(param_3 + (int)param_2))) {
    puVar3 = (undefined4 *)((param_3 - 4) + (int)param_2);
    puVar4 = (undefined4 *)((param_3 - 4) + (int)param_1);
    if (((uint)puVar4 & 3) == 0) {
      uVar1 = param_3 >> 2;
      uVar2 = param_3 & 3;
      if (7 < uVar1) {
        for (; uVar1 != 0; uVar1 = uVar1 - 1) {
          *puVar4 = *puVar3;
          puVar3 = puVar3 + -1;
          puVar4 = puVar4 + -1;
        }
        switch(uVar2) {
        case 0:
          return param_1;
        case 2:
          goto switchD_10008737_caseD_2;
        case 3:
          goto switchD_10008737_caseD_3;
        }
        goto switchD_10008737_caseD_1;
      }
    }
    else {
      switch(param_3) {
      case 0:
        goto switchD_10008737_caseD_0;
      case 1:
        goto switchD_10008737_caseD_1;
      case 2:
        goto switchD_10008737_caseD_2;
      case 3:
        goto switchD_10008737_caseD_3;
      default:
        uVar1 = param_3 - ((uint)puVar4 & 3);
        switch((uint)puVar4 & 3) {
        case 1:
          uVar2 = uVar1 & 3;
          *(undefined1 *)((int)puVar4 + 3) = *(undefined1 *)((int)puVar3 + 3);
          puVar3 = (undefined4 *)((int)puVar3 + -1);
          uVar1 = uVar1 >> 2;
          puVar4 = (undefined4 *)((int)puVar4 - 1);
          if (7 < uVar1) {
            for (; uVar1 != 0; uVar1 = uVar1 - 1) {
              *puVar4 = *puVar3;
              puVar3 = puVar3 + -1;
              puVar4 = puVar4 + -1;
            }
            switch(uVar2) {
            case 0:
              return param_1;
            case 2:
              goto switchD_10008737_caseD_2;
            case 3:
              goto switchD_10008737_caseD_3;
            }
            goto switchD_10008737_caseD_1;
          }
          break;
        case 2:
          uVar2 = uVar1 & 3;
          *(undefined1 *)((int)puVar4 + 3) = *(undefined1 *)((int)puVar3 + 3);
          uVar1 = uVar1 >> 2;
          *(undefined1 *)((int)puVar4 + 2) = *(undefined1 *)((int)puVar3 + 2);
          puVar3 = (undefined4 *)((int)puVar3 + -2);
          puVar4 = (undefined4 *)((int)puVar4 - 2);
          if (7 < uVar1) {
            for (; uVar1 != 0; uVar1 = uVar1 - 1) {
              *puVar4 = *puVar3;
              puVar3 = puVar3 + -1;
              puVar4 = puVar4 + -1;
            }
            switch(uVar2) {
            case 0:
              return param_1;
            case 2:
              goto switchD_10008737_caseD_2;
            case 3:
              goto switchD_10008737_caseD_3;
            }
            goto switchD_10008737_caseD_1;
          }
          break;
        case 3:
          uVar2 = uVar1 & 3;
          *(undefined1 *)((int)puVar4 + 3) = *(undefined1 *)((int)puVar3 + 3);
          *(undefined1 *)((int)puVar4 + 2) = *(undefined1 *)((int)puVar3 + 2);
          uVar1 = uVar1 >> 2;
          *(undefined1 *)((int)puVar4 + 1) = *(undefined1 *)((int)puVar3 + 1);
          puVar3 = (undefined4 *)((int)puVar3 + -3);
          puVar4 = (undefined4 *)((int)puVar4 - 3);
          if (7 < uVar1) {
            for (; uVar1 != 0; uVar1 = uVar1 - 1) {
              *puVar4 = *puVar3;
              puVar3 = puVar3 + -1;
              puVar4 = puVar4 + -1;
            }
            switch(uVar2) {
            case 0:
              return param_1;
            case 2:
              goto switchD_10008737_caseD_2;
            case 3:
              goto switchD_10008737_caseD_3;
            }
            goto switchD_10008737_caseD_1;
          }
        }
      }
    }
    switch(uVar1) {
    case 7:
      puVar4[7 - uVar1] = puVar3[7 - uVar1];
    case 6:
      puVar4[6 - uVar1] = puVar3[6 - uVar1];
    case 5:
      puVar4[5 - uVar1] = puVar3[5 - uVar1];
    case 4:
      puVar4[4 - uVar1] = puVar3[4 - uVar1];
    case 3:
      puVar4[3 - uVar1] = puVar3[3 - uVar1];
    case 2:
      puVar4[2 - uVar1] = puVar3[2 - uVar1];
    case 1:
      puVar4[1 - uVar1] = puVar3[1 - uVar1];
      puVar3 = puVar3 + -uVar1;
      puVar4 = puVar4 + -uVar1;
    }
    switch(uVar2) {
    case 1:
switchD_10008737_caseD_1:
      *(undefined1 *)((int)puVar4 + 3) = *(undefined1 *)((int)puVar3 + 3);
      return param_1;
    case 2:
switchD_10008737_caseD_2:
      *(undefined1 *)((int)puVar4 + 3) = *(undefined1 *)((int)puVar3 + 3);
      *(undefined1 *)((int)puVar4 + 2) = *(undefined1 *)((int)puVar3 + 2);
      return param_1;
    case 3:
switchD_10008737_caseD_3:
      *(undefined1 *)((int)puVar4 + 3) = *(undefined1 *)((int)puVar3 + 3);
      *(undefined1 *)((int)puVar4 + 2) = *(undefined1 *)((int)puVar3 + 2);
      *(undefined1 *)((int)puVar4 + 1) = *(undefined1 *)((int)puVar3 + 1);
      return param_1;
    }
switchD_10008737_caseD_0:
    return param_1;
  }
  puVar3 = param_1;
  if (((uint)param_1 & 3) == 0) {
    uVar1 = param_3 >> 2;
    uVar2 = param_3 & 3;
    if (7 < uVar1) {
      for (; uVar1 != 0; uVar1 = uVar1 - 1) {
        *puVar3 = *param_2;
        param_2 = param_2 + 1;
        puVar3 = puVar3 + 1;
      }
      switch(uVar2) {
      case 0:
        return param_1;
      case 2:
        goto switchD_100085b5_caseD_2;
      case 3:
        goto switchD_100085b5_caseD_3;
      }
      goto switchD_100085b5_caseD_1;
    }
  }
  else {
    switch(param_3) {
    case 0:
      goto switchD_100085b5_caseD_0;
    case 1:
      goto switchD_100085b5_caseD_1;
    case 2:
      goto switchD_100085b5_caseD_2;
    case 3:
      goto switchD_100085b5_caseD_3;
    default:
      uVar1 = (param_3 - 4) + ((uint)param_1 & 3);
      switch((uint)param_1 & 3) {
      case 1:
        uVar2 = uVar1 & 3;
        *(undefined1 *)param_1 = *(undefined1 *)param_2;
        *(undefined1 *)((int)param_1 + 1) = *(undefined1 *)((int)param_2 + 1);
        uVar1 = uVar1 >> 2;
        *(undefined1 *)((int)param_1 + 2) = *(undefined1 *)((int)param_2 + 2);
        param_2 = (undefined4 *)((int)param_2 + 3);
        puVar3 = (undefined4 *)((int)param_1 + 3);
        if (7 < uVar1) {
          for (; uVar1 != 0; uVar1 = uVar1 - 1) {
            *puVar3 = *param_2;
            param_2 = param_2 + 1;
            puVar3 = puVar3 + 1;
          }
          switch(uVar2) {
          case 0:
            return param_1;
          case 2:
            goto switchD_100085b5_caseD_2;
          case 3:
            goto switchD_100085b5_caseD_3;
          }
          goto switchD_100085b5_caseD_1;
        }
        break;
      case 2:
        uVar2 = uVar1 & 3;
        *(undefined1 *)param_1 = *(undefined1 *)param_2;
        uVar1 = uVar1 >> 2;
        *(undefined1 *)((int)param_1 + 1) = *(undefined1 *)((int)param_2 + 1);
        param_2 = (undefined4 *)((int)param_2 + 2);
        puVar3 = (undefined4 *)((int)param_1 + 2);
        if (7 < uVar1) {
          for (; uVar1 != 0; uVar1 = uVar1 - 1) {
            *puVar3 = *param_2;
            param_2 = param_2 + 1;
            puVar3 = puVar3 + 1;
          }
          switch(uVar2) {
          case 0:
            return param_1;
          case 2:
            goto switchD_100085b5_caseD_2;
          case 3:
            goto switchD_100085b5_caseD_3;
          }
          goto switchD_100085b5_caseD_1;
        }
        break;
      case 3:
        uVar2 = uVar1 & 3;
        *(undefined1 *)param_1 = *(undefined1 *)param_2;
        param_2 = (undefined4 *)((int)param_2 + 1);
        uVar1 = uVar1 >> 2;
        puVar3 = (undefined4 *)((int)param_1 + 1);
        if (7 < uVar1) {
          for (; uVar1 != 0; uVar1 = uVar1 - 1) {
            *puVar3 = *param_2;
            param_2 = param_2 + 1;
            puVar3 = puVar3 + 1;
          }
          switch(uVar2) {
          case 0:
            return param_1;
          case 2:
            goto switchD_100085b5_caseD_2;
          case 3:
            goto switchD_100085b5_caseD_3;
          }
          goto switchD_100085b5_caseD_1;
        }
      }
    }
  }
  switch(uVar1) {
  case 7:
    puVar3[uVar1 - 7] = param_2[uVar1 - 7];
  case 6:
    puVar3[uVar1 - 6] = param_2[uVar1 - 6];
  case 5:
    puVar3[uVar1 - 5] = param_2[uVar1 - 5];
  case 4:
    puVar3[uVar1 - 4] = param_2[uVar1 - 4];
  case 3:
    puVar3[uVar1 - 3] = param_2[uVar1 - 3];
  case 2:
    puVar3[uVar1 - 2] = param_2[uVar1 - 2];
  case 1:
    puVar3[uVar1 - 1] = param_2[uVar1 - 1];
    param_2 = param_2 + uVar1;
    puVar3 = puVar3 + uVar1;
  }
  switch(uVar2) {
  case 1:
switchD_100085b5_caseD_1:
    *(undefined1 *)puVar3 = *(undefined1 *)param_2;
    return param_1;
  case 2:
switchD_100085b5_caseD_2:
    *(undefined1 *)puVar3 = *(undefined1 *)param_2;
    *(undefined1 *)((int)puVar3 + 1) = *(undefined1 *)((int)param_2 + 1);
    return param_1;
  case 3:
switchD_100085b5_caseD_3:
    *(undefined1 *)puVar3 = *(undefined1 *)param_2;
    *(undefined1 *)((int)puVar3 + 1) = *(undefined1 *)((int)param_2 + 1);
    *(undefined1 *)((int)puVar3 + 2) = *(undefined1 *)((int)param_2 + 2);
    return param_1;
  }
switchD_100085b5_caseD_0:
  return param_1;
}


/* ==== FUNCTION _strlen @ 100088c0 size=123 ==== */

/* Library Function - Single Match
    _strlen
   
   Libraries: Visual Studio 1998 Debug, Visual Studio 1998 Release */

size_t __cdecl _strlen(char *_Str)

{
  uint uVar1;
  uint *puVar2;
  uint *puVar3;
  
  puVar2 = (uint *)_Str;
  do {
    if (((uint)puVar2 & 3) == 0) goto LAB_100088e0;
    uVar1 = *puVar2;
    puVar2 = (uint *)((int)puVar2 + 1);
  } while ((char)uVar1 != '\0');
LAB_10008913:
  return (size_t)((int)puVar2 + (-1 - (int)_Str));
LAB_100088e0:
  do {
    do {
      puVar3 = puVar2;
      puVar2 = puVar3 + 1;
    } while (((*puVar3 ^ 0xffffffff ^ *puVar3 + 0x7efefeff) & 0x81010100) == 0);
    uVar1 = *puVar3;
    if ((char)uVar1 == '\0') {
      return (int)puVar3 - (int)_Str;
    }
    if ((char)(uVar1 >> 8) == '\0') {
      return (size_t)((int)puVar3 + (1 - (int)_Str));
    }
    if ((uVar1 & 0xff0000) == 0) {
      return (size_t)((int)puVar3 + (2 - (int)_Str));
    }
  } while ((uVar1 & 0xff000000) != 0);
  goto LAB_10008913;
}


/* ==== FUNCTION __fptrap @ 1000893b size=9 ==== */

/* Library Function - Single Match
    __fptrap
   
   Library: Visual Studio 2003 Release */

void __cdecl __fptrap(void)

{
  __amsg_exit(2);
  return;
}


/* ==== FUNCTION FUN_10008961 @ 10008961 size=62 ==== */

undefined4 FUN_10008961(void)

{
  DAT_10010a98 = HeapAlloc(DAT_10010ba4,0,0x140);
  if (DAT_10010a98 == (LPVOID)0x0) {
    return 0;
  }
  DAT_10010a90 = 0;
  DAT_10010a94 = 0;
  DAT_10010a8c = DAT_10010a98;
  DAT_10010a84 = 0x10;
  return 1;
}


/* ==== FUNCTION FUN_1000899f @ 1000899f size=43 ==== */

uint __cdecl FUN_1000899f(int param_1)

{
  uint uVar1;
  
  uVar1 = DAT_10010a98;
  while( true ) {
    if (DAT_10010a98 + DAT_10010a94 * 0x14 <= uVar1) {
      return 0;
    }
    if ((uint)(param_1 - *(int *)(uVar1 + 0xc)) < 0x100000) break;
    uVar1 = uVar1 + 0x14;
  }
  return uVar1;
}


/* ==== FUNCTION FUN_100089ca @ 100089ca size=811 ==== */

void __cdecl FUN_100089ca(uint *param_1,uint param_2)

{
  char *pcVar1;
  uint *puVar2;
  int *piVar3;
  char cVar4;
  uint uVar5;
  int iVar6;
  uint uVar7;
  byte bVar8;
  int *piVar9;
  uint uVar10;
  uint uVar11;
  uint uVar12;
  int local_10;
  
  uVar5 = param_1[4];
  iVar6 = *(int *)(param_2 - 4);
  piVar9 = (int *)(param_2 - 4);
  uVar10 = param_2 - param_1[3] >> 0xf;
  uVar7 = *(uint *)(param_2 - 8);
  local_10 = iVar6 + -1;
  piVar3 = (int *)(uVar10 * 0x204 + 0x144 + uVar5);
  uVar12 = *(uint *)(local_10 + (int)piVar9);
  if ((uVar12 & 1) == 0) {
    param_2 = ((int)uVar12 >> 4) - 1;
    if (0x3f < param_2) {
      param_2 = 0x3f;
    }
    if (*(int *)(iVar6 + 3 + (int)piVar9) == *(int *)(iVar6 + 7 + (int)piVar9)) {
      if (param_2 < 0x20) {
        pcVar1 = (char *)(param_2 + 4 + uVar5);
        uVar11 = ~(0x80000000U >> ((byte)param_2 & 0x1f));
        puVar2 = (uint *)(uVar5 + 0x44 + uVar10 * 4);
        *puVar2 = *puVar2 & uVar11;
        *pcVar1 = *pcVar1 + -1;
        if (*pcVar1 == '\0') {
          *param_1 = *param_1 & uVar11;
        }
      }
      else {
        pcVar1 = (char *)(param_2 + 4 + uVar5);
        uVar11 = ~(0x80000000U >> ((byte)param_2 - 0x20 & 0x1f));
        puVar2 = (uint *)(uVar5 + 0xc4 + uVar10 * 4);
        *puVar2 = *puVar2 & uVar11;
        *pcVar1 = *pcVar1 + -1;
        if (*pcVar1 == '\0') {
          param_1[1] = param_1[1] & uVar11;
        }
      }
    }
    *(undefined4 *)(*(int *)(iVar6 + 7 + (int)piVar9) + 4) =
         *(undefined4 *)(iVar6 + 3 + (int)piVar9);
    local_10 = local_10 + uVar12;
    *(undefined4 *)(*(int *)(iVar6 + 3 + (int)piVar9) + 8) =
         *(undefined4 *)(iVar6 + 7 + (int)piVar9);
  }
  uVar12 = (local_10 >> 4) - 1;
  if (0x3f < uVar12) {
    uVar12 = 0x3f;
  }
  if ((uVar7 & 1) == 0) {
    piVar9 = (int *)((int)piVar9 - uVar7);
    param_2 = ((int)uVar7 >> 4) - 1;
    if (0x3f < param_2) {
      param_2 = 0x3f;
    }
    local_10 = local_10 + uVar7;
    uVar12 = (local_10 >> 4) - 1;
    if (0x3f < uVar12) {
      uVar12 = 0x3f;
    }
    if (param_2 != uVar12) {
      if (piVar9[1] == piVar9[2]) {
        if (param_2 < 0x20) {
          pcVar1 = (char *)(param_2 + 4 + uVar5);
          uVar11 = ~(0x80000000U >> ((byte)param_2 & 0x1f));
          puVar2 = (uint *)(uVar5 + 0x44 + uVar10 * 4);
          *puVar2 = *puVar2 & uVar11;
          *pcVar1 = *pcVar1 + -1;
          if (*pcVar1 == '\0') {
            *param_1 = *param_1 & uVar11;
          }
        }
        else {
          pcVar1 = (char *)(param_2 + 4 + uVar5);
          uVar11 = ~(0x80000000U >> ((byte)param_2 - 0x20 & 0x1f));
          puVar2 = (uint *)(uVar5 + 0xc4 + uVar10 * 4);
          *puVar2 = *puVar2 & uVar11;
          *pcVar1 = *pcVar1 + -1;
          if (*pcVar1 == '\0') {
            param_1[1] = param_1[1] & uVar11;
          }
        }
      }
      *(int *)(piVar9[2] + 4) = piVar9[1];
      *(int *)(piVar9[1] + 8) = piVar9[2];
    }
  }
  if (((uVar7 & 1) != 0) || (param_2 != uVar12)) {
    piVar9[1] = piVar3[uVar12 * 2 + 1];
    piVar9[2] = (int)(piVar3 + uVar12 * 2);
    (piVar3 + uVar12 * 2)[1] = (int)piVar9;
    *(int **)(piVar9[1] + 8) = piVar9;
    if (piVar9[1] == piVar9[2]) {
      cVar4 = *(char *)(uVar12 + 4 + uVar5);
      *(char *)(uVar12 + 4 + uVar5) = cVar4 + '\x01';
      bVar8 = (byte)uVar12;
      if (uVar12 < 0x20) {
        if (cVar4 == '\0') {
          *param_1 = *param_1 | 0x80000000U >> (bVar8 & 0x1f);
        }
        puVar2 = (uint *)(uVar5 + 0x44 + uVar10 * 4);
        *puVar2 = *puVar2 | 0x80000000U >> (bVar8 & 0x1f);
      }
      else {
        if (cVar4 == '\0') {
          param_1[1] = param_1[1] | 0x80000000U >> (bVar8 - 0x20 & 0x1f);
        }
        puVar2 = (uint *)(uVar5 + 0xc4 + uVar10 * 4);
        *puVar2 = *puVar2 | 0x80000000U >> (bVar8 - 0x20 & 0x1f);
      }
    }
  }
  *piVar9 = local_10;
  *(int *)(local_10 + -4 + (int)piVar9) = local_10;
  *piVar3 = *piVar3 + -1;
  uVar5 = DAT_10010a88;
  puVar2 = DAT_10010a90;
  if ((*piVar3 == 0) && (uVar5 = uVar10, puVar2 = param_1, DAT_10010a90 != (uint *)0x0)) {
    VirtualFree((LPVOID)(DAT_10010a88 * 0x8000 + DAT_10010a90[3]),0x8000,0x4000);
    DAT_10010a90[2] = DAT_10010a90[2] | 0x80000000U >> ((byte)DAT_10010a88 & 0x1f);
    *(undefined4 *)(DAT_10010a90[4] + 0xc4 + DAT_10010a88 * 4) = 0;
    *(char *)(DAT_10010a90[4] + 0x43) = *(char *)(DAT_10010a90[4] + 0x43) + -1;
    if (*(char *)(DAT_10010a90[4] + 0x43) == '\0') {
      DAT_10010a90[1] = DAT_10010a90[1] & 0xfffffffe;
    }
    puVar2 = param_1;
    if (DAT_10010a90[2] == 0xffffffff) {
      VirtualFree((LPVOID)DAT_10010a90[3],0,0x8000);
      HeapFree(DAT_10010ba4,0,(LPVOID)DAT_10010a90[4]);
      FUN_10008580(DAT_10010a90,DAT_10010a90 + 5,
                   (DAT_10010a94 * 0x14 - (int)DAT_10010a90) + -0x14 + DAT_10010a98);
      DAT_10010a94 = DAT_10010a94 + -1;
      if (DAT_10010a90 < param_1) {
        param_1 = param_1 + -5;
      }
      DAT_10010a8c = DAT_10010a98;
      puVar2 = param_1;
    }
  }
  DAT_10010a90 = puVar2;
  DAT_10010a88 = uVar5;
  return;
}


/* ==== FUNCTION FUN_10008cf5 @ 10008cf5 size=777 ==== */

int * __cdecl FUN_10008cf5(uint *param_1)

{
  char *pcVar1;
  int *piVar2;
  char cVar3;
  int *piVar4;
  byte bVar5;
  uint uVar6;
  int iVar7;
  uint *puVar8;
  int iVar9;
  int *piVar10;
  uint *puVar11;
  uint *puVar12;
  uint uVar13;
  int iVar14;
  uint local_10;
  uint local_c;
  int local_8;
  
  puVar8 = DAT_10010a98 + DAT_10010a94 * 5;
  uVar6 = (int)param_1 + 0x17U & 0xfffffff0;
  iVar7 = ((int)((int)param_1 + 0x17U) >> 4) + -1;
  bVar5 = (byte)iVar7;
  param_1 = DAT_10010a8c;
  if (iVar7 < 0x20) {
    local_10 = 0xffffffff >> (bVar5 & 0x1f);
    local_c = 0xffffffff;
  }
  else {
    local_c = 0xffffffff >> (bVar5 - 0x20 & 0x1f);
    local_10 = 0;
  }
  for (; (param_1 < puVar8 && ((param_1[1] & local_c) == 0 && (*param_1 & local_10) == 0));
      param_1 = param_1 + 5) {
  }
  puVar11 = DAT_10010a98;
  if (param_1 == puVar8) {
    for (; (puVar11 < DAT_10010a8c && ((puVar11[1] & local_c) == 0 && (*puVar11 & local_10) == 0));
        puVar11 = puVar11 + 5) {
    }
    param_1 = puVar11;
    if (puVar11 == DAT_10010a8c) {
      for (; (puVar11 < puVar8 && (puVar11[2] == 0)); puVar11 = puVar11 + 5) {
      }
      puVar12 = DAT_10010a98;
      param_1 = puVar11;
      if (puVar11 == puVar8) {
        for (; (puVar12 < DAT_10010a8c && (puVar12[2] == 0)); puVar12 = puVar12 + 5) {
        }
        param_1 = puVar12;
        if ((puVar12 == DAT_10010a8c) && (param_1 = FUN_10008ffe(), param_1 == (uint *)0x0)) {
          return (int *)0x0;
        }
      }
      iVar7 = FUN_100090af((int)param_1);
      *(int *)param_1[4] = iVar7;
      if (*(int *)param_1[4] == -1) {
        return (int *)0x0;
      }
    }
  }
  piVar4 = (int *)param_1[4];
  local_8 = *piVar4;
  if ((local_8 == -1) ||
     ((piVar4[local_8 + 0x31] & local_c) == 0 && (piVar4[local_8 + 0x11] & local_10) == 0)) {
    local_8 = 0;
    puVar8 = (uint *)(piVar4 + 0x11);
    if ((piVar4[0x31] & local_c) == 0 && (piVar4[0x11] & local_10) == 0) {
      do {
        puVar11 = puVar8 + 0x21;
        local_8 = local_8 + 1;
        puVar8 = puVar8 + 1;
      } while ((*puVar11 & local_c) == 0 && (local_10 & *puVar8) == 0);
    }
  }
  iVar7 = 0;
  piVar2 = piVar4 + local_8 * 0x81 + 0x51;
  local_10 = piVar4[local_8 + 0x11] & local_10;
  if (local_10 == 0) {
    local_10 = piVar4[local_8 + 0x31] & local_c;
    iVar7 = 0x20;
  }
  for (; -1 < (int)local_10; local_10 = local_10 << 1) {
    iVar7 = iVar7 + 1;
  }
  piVar10 = (int *)piVar2[iVar7 * 2 + 1];
  iVar9 = *piVar10 - uVar6;
  iVar14 = (iVar9 >> 4) + -1;
  if (0x3f < iVar14) {
    iVar14 = 0x3f;
  }
  DAT_10010a8c = param_1;
  if (iVar14 != iVar7) {
    if (piVar10[1] == piVar10[2]) {
      if (iVar7 < 0x20) {
        pcVar1 = (char *)((int)piVar4 + iVar7 + 4);
        uVar13 = ~(0x80000000U >> ((byte)iVar7 & 0x1f));
        piVar4[local_8 + 0x11] = uVar13 & piVar4[local_8 + 0x11];
        *pcVar1 = *pcVar1 + -1;
        if (*pcVar1 == '\0') {
          *param_1 = *param_1 & uVar13;
        }
      }
      else {
        pcVar1 = (char *)((int)piVar4 + iVar7 + 4);
        uVar13 = ~(0x80000000U >> ((byte)iVar7 - 0x20 & 0x1f));
        piVar4[local_8 + 0x31] = piVar4[local_8 + 0x31] & uVar13;
        *pcVar1 = *pcVar1 + -1;
        if (*pcVar1 == '\0') {
          param_1[1] = param_1[1] & uVar13;
        }
      }
    }
    *(int *)(piVar10[2] + 4) = piVar10[1];
    *(int *)(piVar10[1] + 8) = piVar10[2];
    if (iVar9 == 0) goto LAB_10008fbb;
    piVar10[1] = piVar2[iVar14 * 2 + 1];
    piVar10[2] = (int)(piVar2 + iVar14 * 2);
    (piVar2 + iVar14 * 2)[1] = (int)piVar10;
    *(int **)(piVar10[1] + 8) = piVar10;
    if (piVar10[1] == piVar10[2]) {
      cVar3 = *(char *)(iVar14 + 4 + (int)piVar4);
      bVar5 = (byte)iVar14;
      if (iVar14 < 0x20) {
        *(char *)(iVar14 + 4 + (int)piVar4) = cVar3 + '\x01';
        if (cVar3 == '\0') {
          *param_1 = *param_1 | 0x80000000U >> (bVar5 & 0x1f);
        }
        piVar4[local_8 + 0x11] = piVar4[local_8 + 0x11] | 0x80000000U >> (bVar5 & 0x1f);
      }
      else {
        *(char *)(iVar14 + 4 + (int)piVar4) = cVar3 + '\x01';
        if (cVar3 == '\0') {
          param_1[1] = param_1[1] | 0x80000000U >> (bVar5 - 0x20 & 0x1f);
        }
        piVar4[local_8 + 0x31] = piVar4[local_8 + 0x31] | 0x80000000U >> (bVar5 - 0x20 & 0x1f);
      }
    }
  }
  if (iVar9 != 0) {
    *piVar10 = iVar9;
    *(int *)(iVar9 + -4 + (int)piVar10) = iVar9;
  }
LAB_10008fbb:
  piVar10 = (int *)((int)piVar10 + iVar9);
  *piVar10 = uVar6 + 1;
  *(uint *)((int)piVar10 + (uVar6 - 4)) = uVar6 + 1;
  iVar7 = *piVar2;
  *piVar2 = iVar7 + 1;
  if (((iVar7 == 0) && (param_1 == DAT_10010a90)) && (local_8 == DAT_10010a88)) {
    DAT_10010a90 = (uint *)0x0;
  }
  *piVar4 = local_8;
  return piVar10 + 1;
}


/* ==== FUNCTION FUN_10008ffe @ 10008ffe size=177 ==== */

undefined4 * FUN_10008ffe(void)

{
  undefined4 *puVar1;
  LPVOID pvVar2;
  
  if (DAT_10010a94 == DAT_10010a84) {
    pvVar2 = HeapReAlloc(DAT_10010ba4,0,DAT_10010a98,(DAT_10010a84 * 5 + 0x50) * 4);
    if (pvVar2 == (LPVOID)0x0) {
      return (undefined4 *)0x0;
    }
    DAT_10010a84 = DAT_10010a84 + 0x10;
    DAT_10010a98 = pvVar2;
  }
  puVar1 = (undefined4 *)((int)DAT_10010a98 + DAT_10010a94 * 0x14);
  pvVar2 = HeapAlloc(DAT_10010ba4,8,0x41c4);
  puVar1[4] = pvVar2;
  if (pvVar2 != (LPVOID)0x0) {
    pvVar2 = VirtualAlloc((LPVOID)0x0,0x100000,0x2000,4);
    puVar1[3] = pvVar2;
    if (pvVar2 != (LPVOID)0x0) {
      puVar1[2] = 0xffffffff;
      *puVar1 = 0;
      puVar1[1] = 0;
      DAT_10010a94 = DAT_10010a94 + 1;
      *(undefined4 *)puVar1[4] = 0xffffffff;
      return puVar1;
    }
    HeapFree(DAT_10010ba4,0,(LPVOID)puVar1[4]);
  }
  return (undefined4 *)0x0;
}


/* ==== FUNCTION FUN_100090af @ 100090af size=251 ==== */

int __cdecl FUN_100090af(int param_1)

{
  int *piVar1;
  char cVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  LPVOID pvVar6;
  int *piVar7;
  int iVar8;
  int iVar9;
  int *lpAddress;
  
  iVar3 = *(int *)(param_1 + 0x10);
  iVar9 = 0;
  for (iVar4 = *(int *)(param_1 + 8); -1 < iVar4; iVar4 = iVar4 << 1) {
    iVar9 = iVar9 + 1;
  }
  iVar8 = 0x3f;
  iVar4 = iVar9 * 0x204 + 0x144 + iVar3;
  iVar5 = iVar4;
  do {
    *(int *)(iVar5 + 8) = iVar5;
    *(int *)(iVar5 + 4) = iVar5;
    iVar5 = iVar5 + 8;
    iVar8 = iVar8 + -1;
  } while (iVar8 != 0);
  lpAddress = (int *)(iVar9 * 0x8000 + *(int *)(param_1 + 0xc));
  pvVar6 = VirtualAlloc(lpAddress,0x8000,0x1000,4);
  if (pvVar6 == (LPVOID)0x0) {
    iVar9 = -1;
  }
  else {
    if (lpAddress <= lpAddress + 0x1c00) {
      piVar7 = lpAddress + 4;
      do {
        piVar7[-2] = -1;
        piVar7[0x3fb] = -1;
        piVar7[-1] = 0xff0;
        *piVar7 = (int)(piVar7 + 0x3ff);
        piVar7[1] = (int)(piVar7 + -0x401);
        piVar7[0x3fa] = 0xff0;
        piVar1 = piVar7 + 0x3fc;
        piVar7 = piVar7 + 0x400;
      } while (piVar1 <= lpAddress + 0x1c00);
    }
    *(int **)(iVar4 + 0x1fc) = lpAddress + 3;
    lpAddress[5] = iVar4 + 0x1f8;
    *(int **)(iVar4 + 0x200) = lpAddress + 0x1c03;
    lpAddress[0x1c04] = iVar4 + 0x1f8;
    *(undefined4 *)(iVar3 + 0x44 + iVar9 * 4) = 0;
    *(undefined4 *)(iVar3 + 0xc4 + iVar9 * 4) = 1;
    cVar2 = *(char *)(iVar3 + 0x43);
    *(char *)(iVar3 + 0x43) = cVar2 + '\x01';
    if (cVar2 == '\0') {
      *(uint *)(param_1 + 4) = *(uint *)(param_1 + 4) | 1;
    }
    *(uint *)(param_1 + 8) = *(uint *)(param_1 + 8) & ~(0x80000000U >> ((byte)iVar9 & 0x1f));
  }
  return iVar9;
}


/* ==== FUNCTION FUN_100091aa @ 100091aa size=758 ==== */

undefined4 __cdecl FUN_100091aa(uint *param_1,int param_2,int param_3)

{
  char *pcVar1;
  int *piVar2;
  int iVar3;
  char cVar4;
  uint uVar5;
  int iVar6;
  uint *puVar7;
  byte bVar8;
  int iVar9;
  uint uVar10;
  uint uVar11;
  uint uVar12;
  uint uVar13;
  uint local_c;
  
  uVar5 = param_1[4];
  uVar12 = param_3 + 0x17U & 0xfffffff0;
  uVar10 = param_2 - param_1[3] >> 0xf;
  iVar3 = uVar10 * 0x204 + 0x144 + uVar5;
  iVar6 = *(int *)(param_2 + -4);
  iVar9 = iVar6 + -1;
  uVar13 = *(uint *)(iVar6 + -5 + param_2);
  iVar6 = iVar6 + -5 + param_2;
  if (iVar9 < (int)uVar12) {
    if (((uVar13 & 1) != 0) || ((int)(uVar13 + iVar9) < (int)uVar12)) {
      return 0;
    }
    local_c = ((int)uVar13 >> 4) - 1;
    if (0x3f < local_c) {
      local_c = 0x3f;
    }
    if (*(int *)(iVar6 + 4) == *(int *)(iVar6 + 8)) {
      if (local_c < 0x20) {
        pcVar1 = (char *)(local_c + 4 + uVar5);
        uVar11 = ~(0x80000000U >> ((byte)local_c & 0x1f));
        puVar7 = (uint *)(uVar5 + 0x44 + uVar10 * 4);
        *puVar7 = *puVar7 & uVar11;
        *pcVar1 = *pcVar1 + -1;
        if (*pcVar1 == '\0') {
          *param_1 = *param_1 & uVar11;
        }
      }
      else {
        pcVar1 = (char *)(local_c + 4 + uVar5);
        uVar11 = ~(0x80000000U >> ((byte)local_c - 0x20 & 0x1f));
        puVar7 = (uint *)(uVar5 + 0xc4 + uVar10 * 4);
        *puVar7 = *puVar7 & uVar11;
        *pcVar1 = *pcVar1 + -1;
        if (*pcVar1 == '\0') {
          param_1[1] = param_1[1] & uVar11;
        }
      }
    }
    *(undefined4 *)(*(int *)(iVar6 + 8) + 4) = *(undefined4 *)(iVar6 + 4);
    *(undefined4 *)(*(int *)(iVar6 + 4) + 8) = *(undefined4 *)(iVar6 + 8);
    iVar6 = uVar13 + (iVar9 - uVar12);
    if (0 < iVar6) {
      uVar13 = (iVar6 >> 4) - 1;
      iVar9 = param_2 + -4 + uVar12;
      if (0x3f < uVar13) {
        uVar13 = 0x3f;
      }
      iVar3 = iVar3 + uVar13 * 8;
      *(undefined4 *)(iVar9 + 4) = *(undefined4 *)(iVar3 + 4);
      *(int *)(iVar9 + 8) = iVar3;
      *(int *)(iVar3 + 4) = iVar9;
      *(int *)(*(int *)(iVar9 + 4) + 8) = iVar9;
      if (*(int *)(iVar9 + 4) == *(int *)(iVar9 + 8)) {
        cVar4 = *(char *)(uVar13 + 4 + uVar5);
        *(char *)(uVar13 + 4 + uVar5) = cVar4 + '\x01';
        bVar8 = (byte)uVar13;
        if (uVar13 < 0x20) {
          if (cVar4 == '\0') {
            *param_1 = *param_1 | 0x80000000U >> (bVar8 & 0x1f);
          }
          puVar7 = (uint *)(uVar5 + 0x44 + uVar10 * 4);
        }
        else {
          if (cVar4 == '\0') {
            param_1[1] = param_1[1] | 0x80000000U >> (bVar8 - 0x20 & 0x1f);
          }
          puVar7 = (uint *)(uVar5 + 0xc4 + uVar10 * 4);
          bVar8 = bVar8 - 0x20;
        }
        *puVar7 = *puVar7 | 0x80000000U >> (bVar8 & 0x1f);
      }
      piVar2 = (int *)(param_2 + -4 + uVar12);
      *piVar2 = iVar6;
      *(int *)(iVar6 + -4 + (int)piVar2) = iVar6;
    }
    *(uint *)(param_2 + -4) = uVar12 + 1;
    *(uint *)(param_2 + -8 + uVar12) = uVar12 + 1;
  }
  else if ((int)uVar12 < iVar9) {
    param_3 = iVar9 - uVar12;
    *(uint *)(param_2 + -4) = uVar12 + 1;
    piVar2 = (int *)(param_2 + -4 + uVar12);
    uVar11 = (param_3 >> 4) - 1;
    piVar2[-1] = uVar12 + 1;
    if (0x3f < uVar11) {
      uVar11 = 0x3f;
    }
    if ((uVar13 & 1) == 0) {
      uVar12 = ((int)uVar13 >> 4) - 1;
      if (0x3f < uVar12) {
        uVar12 = 0x3f;
      }
      if (*(int *)(iVar6 + 4) == *(int *)(iVar6 + 8)) {
        if (uVar12 < 0x20) {
          pcVar1 = (char *)(uVar12 + 4 + uVar5);
          uVar12 = ~(0x80000000U >> ((byte)uVar12 & 0x1f));
          puVar7 = (uint *)(uVar5 + 0x44 + uVar10 * 4);
          *puVar7 = *puVar7 & uVar12;
          *pcVar1 = *pcVar1 + -1;
          if (*pcVar1 == '\0') {
            *param_1 = *param_1 & uVar12;
          }
        }
        else {
          pcVar1 = (char *)(uVar12 + 4 + uVar5);
          uVar12 = ~(0x80000000U >> ((byte)uVar12 - 0x20 & 0x1f));
          puVar7 = (uint *)(uVar5 + 0xc4 + uVar10 * 4);
          *puVar7 = *puVar7 & uVar12;
          *pcVar1 = *pcVar1 + -1;
          if (*pcVar1 == '\0') {
            param_1[1] = param_1[1] & uVar12;
          }
        }
      }
      *(undefined4 *)(*(int *)(iVar6 + 8) + 4) = *(undefined4 *)(iVar6 + 4);
      *(undefined4 *)(*(int *)(iVar6 + 4) + 8) = *(undefined4 *)(iVar6 + 8);
      param_3 = param_3 + uVar13;
      uVar11 = (param_3 >> 4) - 1;
      if (0x3f < uVar11) {
        uVar11 = 0x3f;
      }
    }
    iVar6 = iVar3 + uVar11 * 8;
    piVar2[1] = *(int *)(iVar3 + 4 + uVar11 * 8);
    piVar2[2] = iVar6;
    *(int **)(iVar6 + 4) = piVar2;
    *(int **)(piVar2[1] + 8) = piVar2;
    if (piVar2[1] == piVar2[2]) {
      cVar4 = *(char *)(uVar11 + 4 + uVar5);
      *(char *)(uVar11 + 4 + uVar5) = cVar4 + '\x01';
      bVar8 = (byte)uVar11;
      if (uVar11 < 0x20) {
        if (cVar4 == '\0') {
          *param_1 = *param_1 | 0x80000000U >> (bVar8 & 0x1f);
        }
        puVar7 = (uint *)(uVar5 + 0x44 + uVar10 * 4);
      }
      else {
        if (cVar4 == '\0') {
          param_1[1] = param_1[1] | 0x80000000U >> (bVar8 - 0x20 & 0x1f);
        }
        puVar7 = (uint *)(uVar5 + 0xc4 + uVar10 * 4);
        bVar8 = bVar8 - 0x20;
      }
      *puVar7 = *puVar7 | 0x80000000U >> (bVar8 & 0x1f);
    }
    *piVar2 = param_3;
    *(int *)(param_3 + -4 + (int)piVar2) = param_3;
  }
  return 1;
}


/* ==== FUNCTION FUN_10009571 @ 10009571 size=815 ==== */

undefined4 FUN_10009571(void)

{
  LPVOID lp;
  BOOL BVar1;
  undefined4 uVar2;
  int iVar3;
  uint uVar4;
  int iVar5;
  uint uVar6;
  uint *puVar7;
  uint *puVar8;
  uint *puVar9;
  uint *puVar10;
  int *piVar11;
  bool bVar12;
  int local_140 [64];
  uint *local_40;
  uint *local_3c;
  uint *local_38;
  int local_34;
  uint local_30;
  uint *local_2c;
  uint local_28;
  int local_24;
  uint local_20;
  uint local_1c;
  uint local_18;
  int local_14;
  uint *local_10;
  int local_c;
  int *local_8;
  
  BVar1 = IsBadWritePtr(DAT_10010a98,DAT_10010a94 * 0x14);
  if (BVar1 == 0) {
    local_24 = 0;
    puVar8 = DAT_10010a98;
    if (0 < DAT_10010a94) {
      do {
        lp = (LPVOID)puVar8[4];
        local_3c = puVar8;
        BVar1 = IsBadWritePtr(lp,0x41c4);
        if (BVar1 != 0) {
          return 0xfffffffe;
        }
        local_10 = (uint *)puVar8[3];
        local_30 = 0;
        local_2c = (uint *)((int)lp + 0x144);
        local_18 = puVar8[2];
        puVar9 = (uint *)((int)lp + 0xc4);
        local_1c = 0;
        local_34 = 0;
        do {
          local_28 = 0;
          local_20 = 0;
          local_8 = (int *)0x0;
          bVar12 = -1 < (int)local_18;
          piVar11 = local_140;
          local_40 = puVar9;
          for (iVar5 = 0x40; iVar5 != 0; iVar5 = iVar5 + -1) {
            *piVar11 = 0;
            piVar11 = piVar11 + 1;
          }
          if (bVar12) {
            BVar1 = IsBadWritePtr(local_10,0x8000);
            if (BVar1 != 0) {
              return 0xfffffffc;
            }
            iVar5 = 0;
            puVar8 = local_10 + 0x3ff;
            do {
              puVar9 = puVar8 + -0x3fc;
              if ((puVar8[-0x3fd] != 0xffffffff) || (*puVar8 != 0xffffffff)) {
                return 0xfffffffb;
              }
              do {
                uVar4 = *puVar9;
                if ((uVar4 & 1) == 0) {
                  iVar3 = ((int)uVar4 >> 4) + -1;
                  if (0x3f < iVar3) {
                    iVar3 = 0x3f;
                  }
                  local_140[iVar3] = local_140[iVar3] + 1;
                  uVar6 = uVar4;
                }
                else {
                  if (0x400 < (int)(uVar4 - 1)) {
                    return 0xfffffffa;
                  }
                  local_8 = (int *)((int)local_8 + 1);
                  uVar6 = uVar4 - 1;
                }
                if ((((int)uVar6 < 0x10) || ((uVar6 & 0xf) != 0)) || (0xff0 < (int)uVar6)) {
                  return 0xfffffff9;
                }
                puVar10 = (uint *)((uVar6 - 4) + (int)puVar9);
                puVar9 = (uint *)(uVar6 + (int)puVar9);
                if (*puVar10 != uVar4) {
                  return 0xfffffff8;
                }
              } while (puVar9 < puVar8);
              if (puVar9 != puVar8) {
                return 0xfffffff8;
              }
              puVar8 = puVar8 + 0x400;
              iVar5 = iVar5 + 1;
            } while (iVar5 < 8);
            if ((int *)*local_2c != local_8) {
              return 0xfffffff7;
            }
            local_c = 0;
            local_8 = local_140;
            puVar10 = local_2c;
            do {
              local_14 = 0;
              puVar8 = (uint *)puVar10[1];
              local_38 = puVar10;
              if ((uint *)puVar10[1] != puVar10) {
                do {
                  puVar9 = puVar8;
                  if (local_14 == *local_8) break;
                  if ((puVar9 < local_10) || (local_10 + 0x2000 <= puVar9)) {
                    return 0xfffffff6;
                  }
                  puVar7 = (uint *)(((uint)puVar9 & 0xfffff000) + 0xc);
                  puVar8 = (uint *)(((uint)puVar9 & 0xfffff000) + 0xffc);
                  if (puVar7 == puVar8) {
                    return 0xfffffff5;
                  }
                  do {
                    if (puVar7 == puVar9) break;
                    puVar7 = (uint *)((int)puVar7 + (*puVar7 & 0xfffffffe));
                  } while (puVar7 != puVar8);
                  if (puVar7 == puVar8) {
                    return 0xfffffff5;
                  }
                  iVar5 = ((int)*puVar9 >> 4) + -1;
                  if (0x3f < iVar5) {
                    iVar5 = 0x3f;
                  }
                  if (iVar5 != local_c) {
                    return 0xfffffff4;
                  }
                  if ((uint *)puVar9[2] != local_38) {
                    return 0xfffffff3;
                  }
                  local_14 = local_14 + 1;
                  puVar8 = (uint *)puVar9[1];
                  local_38 = puVar9;
                } while ((uint *)puVar9[1] != puVar10);
                if (local_14 != 0) {
                  if (local_c < 0x20) {
                    uVar4 = 0x80000000 >> ((byte)local_c & 0x1f);
                    local_28 = local_28 | uVar4;
                    local_30 = local_30 | uVar4;
                  }
                  else {
                    uVar4 = 0x80000000 >> ((byte)local_c - 0x20 & 0x1f);
                    local_20 = local_20 | uVar4;
                    local_1c = local_1c | uVar4;
                  }
                }
              }
              if (((uint *)local_38[1] != puVar10) || (local_14 != *local_8)) {
                return 0xfffffff2;
              }
              if ((uint *)puVar10[2] != local_38) {
                return 0xfffffff1;
              }
              local_c = local_c + 1;
              local_8 = local_8 + 1;
              puVar8 = local_3c;
              puVar9 = local_40;
              puVar10 = puVar10 + 2;
            } while (local_c < 0x40);
          }
          if ((local_28 != puVar9[-0x20]) || (local_20 != *puVar9)) {
            return 0xfffffff0;
          }
          local_10 = local_10 + 0x2000;
          local_2c = local_2c + 0x81;
          local_18 = local_18 << 1;
          local_34 = local_34 + 1;
          puVar9 = puVar9 + 1;
        } while (local_34 < 0x20);
        if ((local_30 != *puVar8) || (local_1c != puVar8[1])) {
          return 0xffffffef;
        }
        puVar8 = puVar8 + 5;
        local_24 = local_24 + 1;
        local_40 = puVar9;
      } while (local_24 < DAT_10010a94);
    }
    uVar2 = 0;
  }
  else {
    uVar2 = 0xffffffff;
  }
  return uVar2;
}


/* ==== FUNCTION FUN_100098b6 @ 100098b6 size=27 ==== */

undefined4 __cdecl FUN_100098b6(undefined4 param_1)

{
  int iVar1;
  
  if (DAT_1000f7dc != (code *)0x0) {
    iVar1 = (*DAT_1000f7dc)(param_1);
    if (iVar1 != 0) {
      return 1;
    }
  }
  return 0;
}


/* ==== FUNCTION FUN_100098d1 @ 100098d1 size=154 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

DWORD __cdecl FUN_100098d1(uint param_1,LONG param_2,DWORD param_3)

{
  byte *pbVar1;
  HANDLE hFile;
  DWORD DVar2;
  uint uVar3;
  int iVar4;
  
  if (param_1 < DAT_10010ba0) {
    iVar4 = (param_1 & 0x1f) * 8;
    if ((*(byte *)((&DAT_10010aa0)[(int)param_1 >> 5] + 4 + iVar4) & 1) != 0) {
      hFile = (HANDLE)FUN_1000b8cf(param_1);
      if (hFile == (HANDLE)0xffffffff) {
        _DAT_1000f64c = 9;
        return 0xffffffff;
      }
      DVar2 = SetFilePointer(hFile,param_2,(PLONG)0x0,param_3);
      if (DVar2 == 0xffffffff) {
        uVar3 = GetLastError();
      }
      else {
        uVar3 = 0;
      }
      if (uVar3 != 0) {
        FUN_1000b6e2(uVar3);
        return 0xffffffff;
      }
      pbVar1 = (byte *)((&DAT_10010aa0)[(int)param_1 >> 5] + 4 + iVar4);
      *pbVar1 = *pbVar1 & 0xfd;
      return DVar2;
    }
  }
  _DAT_1000f650 = 0;
  _DAT_1000f64c = 9;
  return 0xffffffff;
}


/* ==== FUNCTION FUN_1000996b @ 1000996b size=429 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int __cdecl FUN_1000996b(DWORD param_1,char *param_2,uint param_3)

{
  int *piVar1;
  char *pcVar2;
  byte bVar3;
  char cVar4;
  char *pcVar5;
  BOOL BVar6;
  int iVar7;
  char local_418 [1028];
  int local_14;
  DWORD local_10;
  DWORD local_c;
  char *local_8;
  
  if (param_1 < DAT_10010ba0) {
    piVar1 = &DAT_10010aa0 + ((int)param_1 >> 5);
    iVar7 = (param_1 & 0x1f) * 8;
    bVar3 = *(byte *)(*piVar1 + 4 + iVar7);
    if ((bVar3 & 1) != 0) {
      local_c = 0;
      local_14 = 0;
      if (param_3 == 0) {
        return 0;
      }
      if ((bVar3 & 0x20) != 0) {
        FUN_100098d1(param_1,0,2);
      }
      if ((*(byte *)((undefined4 *)(*piVar1 + iVar7) + 1) & 0x80) == 0) {
        BVar6 = WriteFile(*(HANDLE *)(*piVar1 + iVar7),param_2,param_3,&local_10,(LPOVERLAPPED)0x0);
        if (BVar6 == 0) {
          param_1 = GetLastError();
        }
        else {
          local_c = local_10;
          param_1 = 0;
        }
LAB_10009a64:
        if (local_c != 0) {
          return local_c - local_14;
        }
        if (param_1 != 0) {
          if (param_1 == 5) {
            _DAT_1000f64c = 9;
            _DAT_1000f650 = 5;
            return -1;
          }
          FUN_1000b6e2(param_1);
          return -1;
        }
      }
      else {
        local_8 = param_2;
        param_1 = 0;
        if (param_3 != 0) {
          do {
            pcVar5 = local_418;
            do {
              if (param_3 <= (uint)((int)local_8 - (int)param_2)) break;
              pcVar2 = local_8 + 1;
              cVar4 = *local_8;
              local_8 = pcVar2;
              if (cVar4 == '\n') {
                local_14 = local_14 + 1;
                *pcVar5 = '\r';
                pcVar5 = pcVar5 + 1;
              }
              *pcVar5 = cVar4;
              pcVar5 = pcVar5 + 1;
            } while ((int)pcVar5 - (int)local_418 < 0x400);
            BVar6 = WriteFile(*(HANDLE *)(*piVar1 + iVar7),local_418,(int)pcVar5 - (int)local_418,
                              &local_10,(LPOVERLAPPED)0x0);
            if (BVar6 == 0) {
              param_1 = GetLastError();
              goto LAB_10009a64;
            }
            local_c = local_c + local_10;
            if (((int)local_10 < (int)pcVar5 - (int)local_418) ||
               (param_3 <= (uint)((int)local_8 - (int)param_2))) goto LAB_10009a64;
          } while( true );
        }
      }
      if (((*(byte *)(*piVar1 + 4 + iVar7) & 0x40) != 0) && (*param_2 == '\x1a')) {
        return 0;
      }
      _DAT_1000f64c = 0x1c;
      _DAT_1000f650 = 0;
      return -1;
    }
  }
  _DAT_1000f650 = 0;
  _DAT_1000f64c = 9;
  return -1;
}


/* ==== FUNCTION FUN_10009b18 @ 10009b18 size=68 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __cdecl FUN_10009b18(undefined4 *param_1)

{
  void *pvVar1;
  
  _DAT_1000f7e0 = _DAT_1000f7e0 + 1;
  pvVar1 = _malloc(0x1000);
  param_1[2] = pvVar1;
  if (pvVar1 == (void *)0x0) {
    param_1[3] = param_1[3] | 4;
    param_1[2] = param_1 + 5;
    param_1[6] = 2;
  }
  else {
    param_1[3] = param_1[3] | 8;
    param_1[6] = 0x1000;
  }
  param_1[1] = 0;
  *param_1 = param_1[2];
  return;
}


/* ==== FUNCTION FUN_10009b5c @ 10009b5c size=38 ==== */

byte __cdecl FUN_10009b5c(uint param_1)

{
  if (DAT_10010ba0 <= param_1) {
    return 0;
  }
  return *(byte *)((&DAT_10010aa0)[(int)param_1 >> 5] + 4 + (param_1 & 0x1f) * 8) & 0x40;
}


/* ==== FUNCTION FUN_10009c3b @ 10009c3b size=104 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int __cdecl FUN_10009c3b(LPSTR param_1,WCHAR param_2)

{
  LPSTR lpMultiByteStr;
  int iVar1;
  
  lpMultiByteStr = param_1;
  if (param_1 == (LPSTR)0x0) {
    return 0;
  }
  if (DAT_1000f80c == 0) {
    if ((ushort)param_2 < 0x100) {
      *param_1 = (CHAR)param_2;
      return 1;
    }
  }
  else {
    param_1 = (LPSTR)0x0;
    iVar1 = WideCharToMultiByte(DAT_1000f81c,0x220,&param_2,1,lpMultiByteStr,DAT_1000ec94,
                                (LPCSTR)0x0,(LPBOOL)&param_1);
    if ((iVar1 != 0) && (param_1 == (LPSTR)0x0)) {
      return iVar1;
    }
  }
  _DAT_1000f64c = 0x2a;
  return -1;
}


/* ==== FUNCTION __aulldiv @ 10009cb0 size=104 ==== */

/* Library Function - Single Match
    __aulldiv
   
   Library: Visual Studio */

undefined8 __aulldiv(uint param_1,uint param_2,uint param_3,uint param_4)

{
  ulonglong uVar1;
  longlong lVar2;
  uint uVar3;
  int iVar4;
  uint uVar5;
  uint uVar7;
  uint uVar8;
  uint uVar9;
  uint uVar6;
  
  uVar9 = param_1;
  uVar6 = param_4;
  uVar7 = param_2;
  uVar3 = param_3;
  if (param_4 == 0) {
    uVar3 = param_2 / param_3;
    iVar4 = (int)(((ulonglong)param_2 % (ulonglong)param_3 << 0x20 | (ulonglong)param_1) /
                 (ulonglong)param_3);
  }
  else {
    do {
      uVar5 = uVar6 >> 1;
      uVar3 = (uint)(CONCAT14((uVar6 & 1) != 0,uVar3) >> 1);
      uVar8 = uVar7 >> 1;
      uVar9 = (uint)(CONCAT14((uVar7 & 1) != 0,uVar9) >> 1);
      uVar6 = uVar5;
      uVar7 = uVar8;
    } while (uVar5 != 0);
    uVar1 = CONCAT44(uVar8,uVar9) / (ulonglong)uVar3;
    iVar4 = (int)uVar1;
    lVar2 = (ulonglong)param_3 * (uVar1 & 0xffffffff);
    uVar3 = (uint)((ulonglong)lVar2 >> 0x20);
    uVar9 = uVar3 + iVar4 * param_4;
    if (((CARRY4(uVar3,iVar4 * param_4)) || (param_2 < uVar9)) ||
       ((param_2 <= uVar9 && (param_1 < (uint)lVar2)))) {
      iVar4 = iVar4 + -1;
    }
    uVar3 = 0;
  }
  return CONCAT44(uVar3,iVar4);
}


/* ==== FUNCTION __aullrem @ 10009d20 size=117 ==== */

/* Library Function - Single Match
    __aullrem
   
   Library: Visual Studio */

undefined8 __aullrem(uint param_1,uint param_2,uint param_3,uint param_4)

{
  ulonglong uVar1;
  longlong lVar2;
  uint uVar3;
  uint uVar4;
  uint uVar5;
  int iVar6;
  int iVar7;
  uint uVar8;
  uint uVar9;
  uint uVar10;
  bool bVar11;
  
  uVar4 = param_1;
  uVar9 = param_4;
  uVar10 = param_2;
  uVar3 = param_3;
  if (param_4 == 0) {
    iVar6 = (int)(((ulonglong)param_2 % (ulonglong)param_3 << 0x20 | (ulonglong)param_1) %
                 (ulonglong)param_3);
    iVar7 = 0;
  }
  else {
    do {
      uVar5 = uVar9 >> 1;
      uVar3 = (uint)(CONCAT14((uVar9 & 1) != 0,uVar3) >> 1);
      uVar8 = uVar10 >> 1;
      uVar4 = (uint)(CONCAT14((uVar10 & 1) != 0,uVar4) >> 1);
      uVar9 = uVar5;
      uVar10 = uVar8;
    } while (uVar5 != 0);
    uVar1 = CONCAT44(uVar8,uVar4) / (ulonglong)uVar3;
    uVar3 = (int)uVar1 * param_4;
    lVar2 = (uVar1 & 0xffffffff) * (ulonglong)param_3;
    uVar9 = (uint)((ulonglong)lVar2 >> 0x20);
    uVar4 = (uint)lVar2;
    uVar10 = uVar9 + uVar3;
    if (((CARRY4(uVar9,uVar3)) || (param_2 < uVar10)) || ((param_2 <= uVar10 && (param_1 < uVar4))))
    {
      bVar11 = uVar4 < param_3;
      uVar4 = uVar4 - param_3;
      uVar10 = (uVar10 - param_4) - (uint)bVar11;
    }
    iVar6 = -(uVar4 - param_1);
    iVar7 = -(uint)(uVar4 - param_1 != 0) - ((uVar10 - param_2) - (uint)(uVar4 < param_1));
  }
  return CONCAT44(iVar7,iVar6);
}


/* ==== FUNCTION FUN_10009d95 @ 10009d95 size=70 ==== */

int FUN_10009d95(int *param_1)

{
  int *piVar1;
  bool bVar2;
  int iVar3;
  undefined3 extraout_var;
  
  piVar1 = (int *)*param_1;
  if (((*piVar1 == -0x1f928c9d) && (piVar1[4] == 3)) && (piVar1[5] == 0x19930520)) {
    iVar3 = FUN_1000703c();
    return iVar3;
  }
  if ((DAT_1000f7e4 != (FARPROC)0x0) &&
     (bVar2 = FUN_10009e31(DAT_1000f7e4), CONCAT31(extraout_var,bVar2) != 0)) {
    iVar3 = (*DAT_1000f7e4)(param_1);
    return iVar3;
  }
  return 0;
}


/* ==== FUNCTION FUN_10009df9 @ 10009df9 size=28 ==== */

bool __cdecl FUN_10009df9(void *param_1,UINT_PTR param_2)

{
  BOOL BVar1;
  
  BVar1 = IsBadReadPtr(param_1,param_2);
  return BVar1 == 0;
}


/* ==== FUNCTION FUN_10009e15 @ 10009e15 size=28 ==== */

bool __cdecl FUN_10009e15(LPVOID param_1,UINT_PTR param_2)

{
  BOOL BVar1;
  
  BVar1 = IsBadWritePtr(param_1,param_2);
  return BVar1 == 0;
}


/* ==== FUNCTION FUN_10009e31 @ 10009e31 size=24 ==== */

bool __cdecl FUN_10009e31(FARPROC param_1)

{
  BOOL BVar1;
  
  BVar1 = IsBadCodePtr(param_1);
  return BVar1 == 0;
}


/* ==== FUNCTION _strcmp @ 10009e50 size=129 ==== */

/* Library Function - Single Match
    _strcmp
   
   Libraries: Visual Studio 1998 Debug, Visual Studio 1998 Release */

int __cdecl _strcmp(char *_Str1,char *_Str2)

{
  undefined2 uVar1;
  undefined4 uVar2;
  byte bVar3;
  byte bVar4;
  bool bVar5;
  
  if (((uint)_Str1 & 3) != 0) {
    if (((uint)_Str1 & 1) != 0) {
      bVar4 = *_Str1;
      _Str1 = _Str1 + 1;
      bVar5 = bVar4 < (byte)*_Str2;
      if (bVar4 != *_Str2) goto LAB_10009e94;
      _Str2 = _Str2 + 1;
      if (bVar4 == 0) {
        return 0;
      }
      if (((uint)_Str1 & 2) == 0) goto LAB_10009e60;
    }
    uVar1 = *(undefined2 *)_Str1;
    _Str1 = _Str1 + 2;
    bVar4 = (byte)uVar1;
    bVar5 = bVar4 < (byte)*_Str2;
    if (bVar4 != *_Str2) goto LAB_10009e94;
    if (bVar4 == 0) {
      return 0;
    }
    bVar4 = (byte)((ushort)uVar1 >> 8);
    bVar5 = bVar4 < (byte)_Str2[1];
    if (bVar4 != _Str2[1]) goto LAB_10009e94;
    if (bVar4 == 0) {
      return 0;
    }
    _Str2 = _Str2 + 2;
  }
LAB_10009e60:
  while( true ) {
    uVar2 = *(undefined4 *)_Str1;
    bVar4 = (byte)uVar2;
    bVar5 = bVar4 < (byte)*_Str2;
    if (bVar4 != *_Str2) break;
    if (bVar4 == 0) {
      return 0;
    }
    bVar4 = (byte)((uint)uVar2 >> 8);
    bVar5 = bVar4 < (byte)_Str2[1];
    if (bVar4 != _Str2[1]) break;
    if (bVar4 == 0) {
      return 0;
    }
    bVar4 = (byte)((uint)uVar2 >> 0x10);
    bVar5 = bVar4 < (byte)_Str2[2];
    if (bVar4 != _Str2[2]) break;
    bVar3 = (byte)((uint)uVar2 >> 0x18);
    if (bVar4 == 0) {
      return 0;
    }
    bVar5 = bVar3 < (byte)_Str2[3];
    if (bVar3 != _Str2[3]) break;
    _Str2 = _Str2 + 4;
    _Str1 = _Str1 + 4;
    if (bVar3 == 0) {
      return 0;
    }
  }
LAB_10009e94:
  return (uint)bVar5 * -2 + 1;
}


/* ==== FUNCTION FUN_10009f99 @ 10009f99 size=27 ==== */

void FUN_10009f99(int param_1)

{
  __local_unwind2(*(int *)(param_1 + 0x18),*(int *)(param_1 + 0x1c));
  return;
}


/* ==== FUNCTION FUN_10009fb4 @ 10009fb4 size=23 ==== */

void FUN_10009fb4(void)

{
  FUN_100079b4(10);
  FUN_1000bccf(0x16);
                    /* WARNING: Subroutine does not return */
  __exit(3);
}


/* ==== FUNCTION FUN_10009fcb @ 10009fcb size=318 ==== */

BOOL __cdecl
FUN_10009fcb(DWORD param_1,LPCSTR param_2,int param_3,LPWORD param_4,UINT param_5,LCID param_6,
            int param_7)

{
  undefined1 *puVar1;
  BOOL BVar2;
  int iVar3;
  WORD local_20 [2];
  undefined1 *local_1c;
  void *local_14;
  undefined1 *puStack_10;
  undefined *puStack_c;
  undefined4 local_8;
  
  local_8 = 0xffffffff;
  puStack_c = &DAT_1000d598;
  puStack_10 = &LAB_10009edc;
  local_14 = ExceptionList;
  local_1c = &stack0xffffffc8;
  iVar3 = DAT_1000f7e8;
  ExceptionList = &local_14;
  puVar1 = &stack0xffffffc8;
  if (DAT_1000f7e8 == 0) {
    ExceptionList = &local_14;
    BVar2 = GetStringTypeW(1,L"",1,local_20);
    iVar3 = 1;
    puVar1 = local_1c;
    if (BVar2 == 0) {
      BVar2 = GetStringTypeA(0,1,"",1,local_20);
      if (BVar2 == 0) {
        ExceptionList = local_14;
        return 0;
      }
      iVar3 = 2;
      puVar1 = local_1c;
    }
  }
  local_1c = puVar1;
  DAT_1000f7e8 = iVar3;
  if (DAT_1000f7e8 != 2) {
    if (DAT_1000f7e8 == 1) {
      if (param_5 == 0) {
        param_5 = DAT_1000f81c;
      }
      iVar3 = MultiByteToWideChar(param_5,(-(uint)(param_7 != 0) & 8) + 1,param_2,param_3,
                                  (LPWSTR)0x0,0);
      if (iVar3 != 0) {
        local_8 = 0;
        FUN_10005600();
        local_1c = &stack0xffffffc8;
        _memset(&stack0xffffffc8,0,iVar3 * 2);
        local_8 = 0xffffffff;
        if ((&stack0x00000000 != (undefined1 *)0x38) &&
           (iVar3 = MultiByteToWideChar(param_5,1,param_2,param_3,(LPWSTR)&stack0xffffffc8,iVar3),
           iVar3 != 0)) {
          BVar2 = GetStringTypeW(param_1,(LPCWSTR)&stack0xffffffc8,iVar3,param_4);
          ExceptionList = local_14;
          return BVar2;
        }
      }
    }
    ExceptionList = local_14;
    return 0;
  }
  if (param_6 == 0) {
    param_6 = DAT_1000f80c;
  }
  BVar2 = GetStringTypeA(param_6,param_1,param_2,param_3,param_4);
  ExceptionList = local_14;
  return BVar2;
}


/* ==== FUNCTION FUN_1000a114 @ 1000a114 size=409 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __cdecl FUN_1000a114(int param_1)

{
  BYTE *pBVar1;
  byte *pbVar2;
  byte bVar3;
  byte bVar4;
  UINT CodePage;
  UINT *pUVar5;
  BOOL BVar6;
  uint uVar7;
  BYTE *pBVar8;
  int iVar9;
  byte *pbVar10;
  int iVar11;
  byte *pbVar12;
  undefined4 *puVar13;
  _cpinfo local_1c;
  uint local_8;
  
  CodePage = FUN_1000a2ad(param_1);
  if (CodePage == DAT_1000f838) {
    return 0;
  }
  if (CodePage != 0) {
    iVar11 = 0;
    pUVar5 = &DAT_1000f008;
    do {
      if (*pUVar5 == CodePage) {
        puVar13 = &DAT_1000f960;
        for (iVar9 = 0x40; iVar9 != 0; iVar9 = iVar9 + -1) {
          *puVar13 = 0;
          puVar13 = puVar13 + 1;
        }
        local_8 = 0;
        iVar11 = iVar11 * 0x30;
        *(undefined1 *)puVar13 = 0;
        pbVar12 = (byte *)(iVar11 + 0x1000f018);
        do {
          bVar3 = *pbVar12;
          pbVar10 = pbVar12;
          while ((bVar3 != 0 && (bVar3 = pbVar10[1], bVar3 != 0))) {
            uVar7 = (uint)*pbVar10;
            if (uVar7 <= bVar3) {
              bVar4 = (&DAT_1000f000)[local_8];
              do {
                pbVar2 = (byte *)((int)&DAT_1000f960 + uVar7 + 1);
                *pbVar2 = *pbVar2 | bVar4;
                uVar7 = uVar7 + 1;
              } while (uVar7 <= bVar3);
            }
            pbVar10 = pbVar10 + 2;
            bVar3 = *pbVar10;
          }
          local_8 = local_8 + 1;
          pbVar12 = pbVar12 + 8;
        } while (local_8 < 4);
        _DAT_1000f84c = 1;
        DAT_1000f838 = CodePage;
        DAT_1000fa64 = FUN_1000a2f7(CodePage);
        DAT_1000f840 = *(undefined4 *)(iVar11 + 0x1000f00c);
        DAT_1000f844 = *(undefined4 *)(iVar11 + 0x1000f010);
        DAT_1000f848 = *(undefined4 *)(iVar11 + 0x1000f014);
        goto LAB_1000a29c;
      }
      pUVar5 = pUVar5 + 0xc;
      iVar11 = iVar11 + 1;
    } while ((int)pUVar5 < 0x1000f0f8);
    BVar6 = GetCPInfo(CodePage,&local_1c);
    if (BVar6 == 1) {
      puVar13 = &DAT_1000f960;
      DAT_1000f838 = CodePage;
      for (iVar11 = 0x40; iVar11 != 0; iVar11 = iVar11 + -1) {
        *puVar13 = 0;
        puVar13 = puVar13 + 1;
      }
      *(undefined1 *)puVar13 = 0;
      DAT_1000fa64 = 0;
      if (local_1c.MaxCharSize < 2) {
        _DAT_1000f84c = 0;
      }
      else {
        if (local_1c.LeadByte[0] != '\0') {
          pBVar8 = local_1c.LeadByte + 1;
          do {
            bVar3 = *pBVar8;
            if (bVar3 == 0) break;
            for (uVar7 = (uint)pBVar8[-1]; uVar7 <= bVar3; uVar7 = uVar7 + 1) {
              pbVar12 = (byte *)((int)&DAT_1000f960 + uVar7 + 1);
              *pbVar12 = *pbVar12 | 4;
            }
            pBVar1 = pBVar8 + 1;
            pBVar8 = pBVar8 + 2;
          } while (*pBVar1 != 0);
        }
        uVar7 = 1;
        do {
          pbVar12 = (byte *)((int)&DAT_1000f960 + uVar7 + 1);
          *pbVar12 = *pbVar12 | 8;
          uVar7 = uVar7 + 1;
        } while (uVar7 < 0xff);
        DAT_1000fa64 = FUN_1000a2f7(CodePage);
        _DAT_1000f84c = 1;
      }
      DAT_1000f840 = 0;
      DAT_1000f844 = 0;
      DAT_1000f848 = 0;
      goto LAB_1000a29c;
    }
    if (DAT_1000f7ec == 0) {
      return 0xffffffff;
    }
  }
  FUN_1000a32a();
LAB_1000a29c:
  FUN_1000a353();
  return 0;
}


/* ==== FUNCTION FUN_1000a2ad @ 1000a2ad size=74 ==== */

int __cdecl FUN_1000a2ad(int param_1)

{
  int iVar1;
  bool bVar2;
  
  if (param_1 == -2) {
    DAT_1000f7ec = 1;
                    /* WARNING: Could not recover jumptable at 0x1000a2c7. Too many branches */
                    /* WARNING: Treating indirect jump as call */
    iVar1 = GetOEMCP();
    return iVar1;
  }
  if (param_1 == -3) {
    DAT_1000f7ec = 1;
                    /* WARNING: Could not recover jumptable at 0x1000a2dc. Too many branches */
                    /* WARNING: Treating indirect jump as call */
    iVar1 = GetACP();
    return iVar1;
  }
  bVar2 = param_1 == -4;
  if (bVar2) {
    param_1 = DAT_1000f81c;
  }
  DAT_1000f7ec = (uint)bVar2;
  return param_1;
}


/* ==== FUNCTION FUN_1000a2f7 @ 1000a2f7 size=51 ==== */

undefined4 __cdecl FUN_1000a2f7(int param_1)

{
  if (param_1 == 0x3a4) {
    return 0x411;
  }
  if (param_1 == 0x3a8) {
    return 0x804;
  }
  if (param_1 == 0x3b5) {
    return 0x412;
  }
  if (param_1 != 0x3b6) {
    return 0;
  }
  return 0x404;
}


/* ==== FUNCTION FUN_1000a32a @ 1000a32a size=41 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1000a32a(void)

{
  int iVar1;
  undefined4 *puVar2;
  
  puVar2 = &DAT_1000f960;
  for (iVar1 = 0x40; iVar1 != 0; iVar1 = iVar1 + -1) {
    *puVar2 = 0;
    puVar2 = puVar2 + 1;
  }
  *(undefined1 *)puVar2 = 0;
  DAT_1000f838 = 0;
  _DAT_1000f84c = 0;
  DAT_1000fa64 = 0;
  DAT_1000f840 = 0;
  DAT_1000f844 = 0;
  DAT_1000f848 = 0;
  return;
}


/* ==== FUNCTION FUN_1000a353 @ 1000a353 size=389 ==== */

void FUN_1000a353(void)

{
  byte *pbVar1;
  BOOL BVar2;
  uint uVar3;
  char cVar4;
  uint uVar5;
  uint uVar6;
  ushort *puVar7;
  undefined1 uVar8;
  BYTE *pBVar9;
  CHAR *pCVar10;
  WORD local_518 [256];
  WCHAR local_318 [128];
  WCHAR local_218 [128];
  CHAR local_118 [256];
  _cpinfo local_18;
  
  BVar2 = GetCPInfo(DAT_1000f838,&local_18);
  if (BVar2 == 1) {
    uVar3 = 0;
    do {
      local_118[uVar3] = (CHAR)uVar3;
      uVar3 = uVar3 + 1;
    } while (uVar3 < 0x100);
    local_118[0] = ' ';
    if (local_18.LeadByte[0] != 0) {
      pBVar9 = local_18.LeadByte + 1;
      do {
        uVar3 = (uint)local_18.LeadByte[0];
        if (uVar3 <= *pBVar9) {
          uVar5 = (*pBVar9 - uVar3) + 1;
          uVar6 = uVar5 >> 2;
          pCVar10 = local_118 + uVar3;
          while (uVar6 != 0) {
            uVar6 = uVar6 - 1;
            builtin_memcpy(pCVar10,"    ",4);
            pCVar10 = pCVar10 + 4;
          }
          for (uVar5 = uVar5 & 3; uVar5 != 0; uVar5 = uVar5 - 1) {
            *pCVar10 = ' ';
            pCVar10 = pCVar10 + 1;
          }
        }
        local_18.LeadByte[0] = pBVar9[1];
        pBVar9 = pBVar9 + 2;
      } while (local_18.LeadByte[0] != 0);
    }
    FUN_10009fcb(1,local_118,0x100,local_518,DAT_1000f838,DAT_1000fa64,0);
    FUN_1000ab52(DAT_1000fa64,0x100,local_118,0x100,local_218,0x100,DAT_1000f838,0);
    FUN_1000ab52(DAT_1000fa64,0x200,local_118,0x100,local_318,0x100,DAT_1000f838,0);
    uVar3 = 0;
    puVar7 = local_518;
    do {
      if ((*puVar7 & 1) == 0) {
        if ((*puVar7 & 2) != 0) {
          pbVar1 = (byte *)((int)&DAT_1000f960 + uVar3 + 1);
          *pbVar1 = *pbVar1 | 0x20;
          uVar8 = *(undefined1 *)((int)local_318 + uVar3);
          goto LAB_1000a45f;
        }
        (&DAT_1000f860)[uVar3] = 0;
      }
      else {
        pbVar1 = (byte *)((int)&DAT_1000f960 + uVar3 + 1);
        *pbVar1 = *pbVar1 | 0x10;
        uVar8 = *(undefined1 *)((int)local_218 + uVar3);
LAB_1000a45f:
        (&DAT_1000f860)[uVar3] = uVar8;
      }
      uVar3 = uVar3 + 1;
      puVar7 = puVar7 + 1;
    } while (uVar3 < 0x100);
  }
  else {
    uVar3 = 0;
    do {
      if ((uVar3 < 0x41) || (0x5a < uVar3)) {
        if ((0x60 < uVar3) && (uVar3 < 0x7b)) {
          pbVar1 = (byte *)((int)&DAT_1000f960 + uVar3 + 1);
          *pbVar1 = *pbVar1 | 0x20;
          cVar4 = (char)uVar3 + -0x20;
          goto LAB_1000a4a9;
        }
        (&DAT_1000f860)[uVar3] = 0;
      }
      else {
        pbVar1 = (byte *)((int)&DAT_1000f960 + uVar3 + 1);
        *pbVar1 = *pbVar1 | 0x10;
        cVar4 = (char)uVar3 + ' ';
LAB_1000a4a9:
        (&DAT_1000f860)[uVar3] = cVar4;
      }
      uVar3 = uVar3 + 1;
    } while (uVar3 < 0x100);
  }
  return;
}


/* ==== FUNCTION FUN_1000a4e8 @ 1000a4e8 size=28 ==== */

void FUN_1000a4e8(void)

{
  if (DAT_10010bac == 0) {
    FUN_1000a114(-3);
    DAT_10010bac = 1;
  }
  return;
}


/* ==== FUNCTION FUN_1000a510 @ 1000a510 size=664 ==== */

undefined4 * __cdecl FUN_1000a510(undefined4 *param_1,undefined4 *param_2,uint param_3)

{
  uint uVar1;
  uint uVar2;
  undefined4 *puVar3;
  undefined4 *puVar4;
  
  if ((param_2 < param_1) && (param_1 < (undefined4 *)(param_3 + (int)param_2))) {
    puVar3 = (undefined4 *)((param_3 - 4) + (int)param_2);
    puVar4 = (undefined4 *)((param_3 - 4) + (int)param_1);
    if (((uint)puVar4 & 3) == 0) {
      uVar1 = param_3 >> 2;
      uVar2 = param_3 & 3;
      if (7 < uVar1) {
        for (; uVar1 != 0; uVar1 = uVar1 - 1) {
          *puVar4 = *puVar3;
          puVar3 = puVar3 + -1;
          puVar4 = puVar4 + -1;
        }
        switch(uVar2) {
        case 0:
          return param_1;
        case 2:
          goto switchD_1000a6c7_caseD_2;
        case 3:
          goto switchD_1000a6c7_caseD_3;
        }
        goto switchD_1000a6c7_caseD_1;
      }
    }
    else {
      switch(param_3) {
      case 0:
        goto switchD_1000a6c7_caseD_0;
      case 1:
        goto switchD_1000a6c7_caseD_1;
      case 2:
        goto switchD_1000a6c7_caseD_2;
      case 3:
        goto switchD_1000a6c7_caseD_3;
      default:
        uVar1 = param_3 - ((uint)puVar4 & 3);
        switch((uint)puVar4 & 3) {
        case 1:
          uVar2 = uVar1 & 3;
          *(undefined1 *)((int)puVar4 + 3) = *(undefined1 *)((int)puVar3 + 3);
          puVar3 = (undefined4 *)((int)puVar3 + -1);
          uVar1 = uVar1 >> 2;
          puVar4 = (undefined4 *)((int)puVar4 - 1);
          if (7 < uVar1) {
            for (; uVar1 != 0; uVar1 = uVar1 - 1) {
              *puVar4 = *puVar3;
              puVar3 = puVar3 + -1;
              puVar4 = puVar4 + -1;
            }
            switch(uVar2) {
            case 0:
              return param_1;
            case 2:
              goto switchD_1000a6c7_caseD_2;
            case 3:
              goto switchD_1000a6c7_caseD_3;
            }
            goto switchD_1000a6c7_caseD_1;
          }
          break;
        case 2:
          uVar2 = uVar1 & 3;
          *(undefined1 *)((int)puVar4 + 3) = *(undefined1 *)((int)puVar3 + 3);
          uVar1 = uVar1 >> 2;
          *(undefined1 *)((int)puVar4 + 2) = *(undefined1 *)((int)puVar3 + 2);
          puVar3 = (undefined4 *)((int)puVar3 + -2);
          puVar4 = (undefined4 *)((int)puVar4 - 2);
          if (7 < uVar1) {
            for (; uVar1 != 0; uVar1 = uVar1 - 1) {
              *puVar4 = *puVar3;
              puVar3 = puVar3 + -1;
              puVar4 = puVar4 + -1;
            }
            switch(uVar2) {
            case 0:
              return param_1;
            case 2:
              goto switchD_1000a6c7_caseD_2;
            case 3:
              goto switchD_1000a6c7_caseD_3;
            }
            goto switchD_1000a6c7_caseD_1;
          }
          break;
        case 3:
          uVar2 = uVar1 & 3;
          *(undefined1 *)((int)puVar4 + 3) = *(undefined1 *)((int)puVar3 + 3);
          *(undefined1 *)((int)puVar4 + 2) = *(undefined1 *)((int)puVar3 + 2);
          uVar1 = uVar1 >> 2;
          *(undefined1 *)((int)puVar4 + 1) = *(undefined1 *)((int)puVar3 + 1);
          puVar3 = (undefined4 *)((int)puVar3 + -3);
          puVar4 = (undefined4 *)((int)puVar4 - 3);
          if (7 < uVar1) {
            for (; uVar1 != 0; uVar1 = uVar1 - 1) {
              *puVar4 = *puVar3;
              puVar3 = puVar3 + -1;
              puVar4 = puVar4 + -1;
            }
            switch(uVar2) {
            case 0:
              return param_1;
            case 2:
              goto switchD_1000a6c7_caseD_2;
            case 3:
              goto switchD_1000a6c7_caseD_3;
            }
            goto switchD_1000a6c7_caseD_1;
          }
        }
      }
    }
    switch(uVar1) {
    case 7:
      puVar4[7 - uVar1] = puVar3[7 - uVar1];
    case 6:
      puVar4[6 - uVar1] = puVar3[6 - uVar1];
    case 5:
      puVar4[5 - uVar1] = puVar3[5 - uVar1];
    case 4:
      puVar4[4 - uVar1] = puVar3[4 - uVar1];
    case 3:
      puVar4[3 - uVar1] = puVar3[3 - uVar1];
    case 2:
      puVar4[2 - uVar1] = puVar3[2 - uVar1];
    case 1:
      puVar4[1 - uVar1] = puVar3[1 - uVar1];
      puVar3 = puVar3 + -uVar1;
      puVar4 = puVar4 + -uVar1;
    }
    switch(uVar2) {
    case 1:
switchD_1000a6c7_caseD_1:
      *(undefined1 *)((int)puVar4 + 3) = *(undefined1 *)((int)puVar3 + 3);
      return param_1;
    case 2:
switchD_1000a6c7_caseD_2:
      *(undefined1 *)((int)puVar4 + 3) = *(undefined1 *)((int)puVar3 + 3);
      *(undefined1 *)((int)puVar4 + 2) = *(undefined1 *)((int)puVar3 + 2);
      return param_1;
    case 3:
switchD_1000a6c7_caseD_3:
      *(undefined1 *)((int)puVar4 + 3) = *(undefined1 *)((int)puVar3 + 3);
      *(undefined1 *)((int)puVar4 + 2) = *(undefined1 *)((int)puVar3 + 2);
      *(undefined1 *)((int)puVar4 + 1) = *(undefined1 *)((int)puVar3 + 1);
      return param_1;
    }
switchD_1000a6c7_caseD_0:
    return param_1;
  }
  puVar3 = param_1;
  if (((uint)param_1 & 3) == 0) {
    uVar1 = param_3 >> 2;
    uVar2 = param_3 & 3;
    if (7 < uVar1) {
      for (; uVar1 != 0; uVar1 = uVar1 - 1) {
        *puVar3 = *param_2;
        param_2 = param_2 + 1;
        puVar3 = puVar3 + 1;
      }
      switch(uVar2) {
      case 0:
        return param_1;
      case 2:
        goto switchD_1000a545_caseD_2;
      case 3:
        goto switchD_1000a545_caseD_3;
      }
      goto switchD_1000a545_caseD_1;
    }
  }
  else {
    switch(param_3) {
    case 0:
      goto switchD_1000a545_caseD_0;
    case 1:
      goto switchD_1000a545_caseD_1;
    case 2:
      goto switchD_1000a545_caseD_2;
    case 3:
      goto switchD_1000a545_caseD_3;
    default:
      uVar1 = (param_3 - 4) + ((uint)param_1 & 3);
      switch((uint)param_1 & 3) {
      case 1:
        uVar2 = uVar1 & 3;
        *(undefined1 *)param_1 = *(undefined1 *)param_2;
        *(undefined1 *)((int)param_1 + 1) = *(undefined1 *)((int)param_2 + 1);
        uVar1 = uVar1 >> 2;
        *(undefined1 *)((int)param_1 + 2) = *(undefined1 *)((int)param_2 + 2);
        param_2 = (undefined4 *)((int)param_2 + 3);
        puVar3 = (undefined4 *)((int)param_1 + 3);
        if (7 < uVar1) {
          for (; uVar1 != 0; uVar1 = uVar1 - 1) {
            *puVar3 = *param_2;
            param_2 = param_2 + 1;
            puVar3 = puVar3 + 1;
          }
          switch(uVar2) {
          case 0:
            return param_1;
          case 2:
            goto switchD_1000a545_caseD_2;
          case 3:
            goto switchD_1000a545_caseD_3;
          }
          goto switchD_1000a545_caseD_1;
        }
        break;
      case 2:
        uVar2 = uVar1 & 3;
        *(undefined1 *)param_1 = *(undefined1 *)param_2;
        uVar1 = uVar1 >> 2;
        *(undefined1 *)((int)param_1 + 1) = *(undefined1 *)((int)param_2 + 1);
        param_2 = (undefined4 *)((int)param_2 + 2);
        puVar3 = (undefined4 *)((int)param_1 + 2);
        if (7 < uVar1) {
          for (; uVar1 != 0; uVar1 = uVar1 - 1) {
            *puVar3 = *param_2;
            param_2 = param_2 + 1;
            puVar3 = puVar3 + 1;
          }
          switch(uVar2) {
          case 0:
            return param_1;
          case 2:
            goto switchD_1000a545_caseD_2;
          case 3:
            goto switchD_1000a545_caseD_3;
          }
          goto switchD_1000a545_caseD_1;
        }
        break;
      case 3:
        uVar2 = uVar1 & 3;
        *(undefined1 *)param_1 = *(undefined1 *)param_2;
        param_2 = (undefined4 *)((int)param_2 + 1);
        uVar1 = uVar1 >> 2;
        puVar3 = (undefined4 *)((int)param_1 + 1);
        if (7 < uVar1) {
          for (; uVar1 != 0; uVar1 = uVar1 - 1) {
            *puVar3 = *param_2;
            param_2 = param_2 + 1;
            puVar3 = puVar3 + 1;
          }
          switch(uVar2) {
          case 0:
            return param_1;
          case 2:
            goto switchD_1000a545_caseD_2;
          case 3:
            goto switchD_1000a545_caseD_3;
          }
          goto switchD_1000a545_caseD_1;
        }
      }
    }
  }
  switch(uVar1) {
  case 7:
    puVar3[uVar1 - 7] = param_2[uVar1 - 7];
  case 6:
    puVar3[uVar1 - 6] = param_2[uVar1 - 6];
  case 5:
    puVar3[uVar1 - 5] = param_2[uVar1 - 5];
  case 4:
    puVar3[uVar1 - 4] = param_2[uVar1 - 4];
  case 3:
    puVar3[uVar1 - 3] = param_2[uVar1 - 3];
  case 2:
    puVar3[uVar1 - 2] = param_2[uVar1 - 2];
  case 1:
    puVar3[uVar1 - 1] = param_2[uVar1 - 1];
    param_2 = param_2 + uVar1;
    puVar3 = puVar3 + uVar1;
  }
  switch(uVar2) {
  case 1:
switchD_1000a545_caseD_1:
    *(undefined1 *)puVar3 = *(undefined1 *)param_2;
    return param_1;
  case 2:
switchD_1000a545_caseD_2:
    *(undefined1 *)puVar3 = *(undefined1 *)param_2;
    *(undefined1 *)((int)puVar3 + 1) = *(undefined1 *)((int)param_2 + 1);
    return param_1;
  case 3:
switchD_1000a545_caseD_3:
    *(undefined1 *)puVar3 = *(undefined1 *)param_2;
    *(undefined1 *)((int)puVar3 + 1) = *(undefined1 *)((int)param_2 + 1);
    *(undefined1 *)((int)puVar3 + 2) = *(undefined1 *)((int)param_2 + 2);
    return param_1;
  }
switchD_1000a545_caseD_0:
  return param_1;
}


/* ==== FUNCTION FUN_1000a845 @ 1000a845 size=137 ==== */

int __cdecl FUN_1000a845(undefined4 param_1,undefined4 param_2,undefined4 param_3)

{
  HMODULE hModule;
  int iVar1;
  
  iVar1 = 0;
  if (DAT_1000f7f0 == (FARPROC)0x0) {
    hModule = LoadLibraryA("user32.dll");
    if (hModule != (HMODULE)0x0) {
      DAT_1000f7f0 = GetProcAddress(hModule,"MessageBoxA");
      if (DAT_1000f7f0 != (FARPROC)0x0) {
        DAT_1000f7f4 = GetProcAddress(hModule,"GetActiveWindow");
        DAT_1000f7f8 = GetProcAddress(hModule,"GetLastActivePopup");
        goto LAB_1000a894;
      }
    }
    iVar1 = 0;
  }
  else {
LAB_1000a894:
    if (DAT_1000f7f4 != (FARPROC)0x0) {
      iVar1 = (*DAT_1000f7f4)();
      if ((iVar1 != 0) && (DAT_1000f7f8 != (FARPROC)0x0)) {
        iVar1 = (*DAT_1000f7f8)(iVar1);
      }
    }
    iVar1 = (*DAT_1000f7f0)(iVar1,param_1,param_2,param_3);
  }
  return iVar1;
}


/* ==== FUNCTION _strncpy @ 1000a8d0 size=254 ==== */

/* Library Function - Single Match
    _strncpy
   
   Libraries: Visual Studio 1998 Debug, Visual Studio 1998 Release */

char * __cdecl _strncpy(char *_Dest,char *_Source,size_t _Count)

{
  uint uVar1;
  uint uVar2;
  char cVar3;
  uint uVar4;
  uint *puVar5;
  
  if (_Count == 0) {
    return _Dest;
  }
  puVar5 = (uint *)_Dest;
  if (((uint)_Source & 3) != 0) {
    while( true ) {
      uVar4 = *(uint *)_Source;
      _Source = (char *)((int)_Source + 1);
      *(char *)puVar5 = (char)uVar4;
      puVar5 = (uint *)((int)puVar5 + 1);
      _Count = _Count - 1;
      if (_Count == 0) {
        return _Dest;
      }
      if ((char)uVar4 == '\0') break;
      if (((uint)_Source & 3) == 0) {
        uVar4 = _Count >> 2;
        goto joined_r0x1000a90e;
      }
    }
    do {
      if (((uint)puVar5 & 3) == 0) {
        uVar4 = _Count >> 2;
        cVar3 = '\0';
        if (uVar4 == 0) goto LAB_1000a94b;
        goto LAB_1000a9b9;
      }
      *(char *)puVar5 = '\0';
      puVar5 = (uint *)((int)puVar5 + 1);
      _Count = _Count - 1;
    } while (_Count != 0);
    return _Dest;
  }
  uVar4 = _Count >> 2;
  if (uVar4 != 0) {
    do {
      uVar1 = *(uint *)_Source;
      uVar2 = *(uint *)_Source;
      _Source = (char *)((int)_Source + 4);
      if (((uVar1 ^ 0xffffffff ^ uVar1 + 0x7efefeff) & 0x81010100) != 0) {
        if ((char)uVar2 == '\0') {
          *puVar5 = 0;
joined_r0x1000a9b5:
          while( true ) {
            uVar4 = uVar4 - 1;
            puVar5 = puVar5 + 1;
            if (uVar4 == 0) break;
LAB_1000a9b9:
            *puVar5 = 0;
          }
          cVar3 = '\0';
          _Count = _Count & 3;
          if (_Count != 0) goto LAB_1000a94b;
          return _Dest;
        }
        if ((char)(uVar2 >> 8) == '\0') {
          *puVar5 = uVar2 & 0xff;
          goto joined_r0x1000a9b5;
        }
        if ((uVar2 & 0xff0000) == 0) {
          *puVar5 = uVar2 & 0xffff;
          goto joined_r0x1000a9b5;
        }
        if ((uVar2 & 0xff000000) == 0) {
          *puVar5 = uVar2;
          goto joined_r0x1000a9b5;
        }
      }
      *puVar5 = uVar2;
      puVar5 = puVar5 + 1;
      uVar4 = uVar4 - 1;
joined_r0x1000a90e:
    } while (uVar4 != 0);
    _Count = _Count & 3;
    if (_Count == 0) {
      return _Dest;
    }
  }
  do {
    cVar3 = (char)*(uint *)_Source;
    _Source = (char *)((int)_Source + 1);
    *(char *)puVar5 = cVar3;
    puVar5 = (uint *)((int)puVar5 + 1);
    if (cVar3 == '\0') {
      while (_Count = _Count - 1, _Count != 0) {
LAB_1000a94b:
        *(char *)puVar5 = cVar3;
        puVar5 = (uint *)((int)puVar5 + 1);
      }
      return _Dest;
    }
    _Count = _Count - 1;
  } while (_Count != 0);
  return _Dest;
}


/* ==== FUNCTION FUN_1000a9ce @ 1000a9ce size=321 ==== */

LONG __cdecl FUN_1000a9ce(int param_1,_EXCEPTION_POINTERS *param_2)

{
  code *pcVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  int *piVar4;
  LONG LVar5;
  int iVar6;
  undefined4 *puVar7;
  
  piVar4 = FUN_1000ab0f(param_1);
  uVar3 = DAT_1000f7fc;
  if ((piVar4 == (int *)0x0) || (pcVar1 = (code *)piVar4[2], pcVar1 == (code *)0x0)) {
    LVar5 = UnhandledExceptionFilter(param_2);
  }
  else if (pcVar1 == (code *)0x5) {
    piVar4[2] = 0;
    LVar5 = 1;
  }
  else {
    if (pcVar1 != (code *)0x1) {
      DAT_1000f7fc = param_2;
      if (piVar4[1] == 8) {
        if (DAT_1000f178 < DAT_1000f17c + DAT_1000f178) {
          iVar6 = (DAT_1000f17c + DAT_1000f178) - DAT_1000f178;
          puVar7 = (undefined4 *)(DAT_1000f178 * 0xc + 0x1000f108);
          do {
            *puVar7 = 0;
            puVar7 = puVar7 + 3;
            iVar6 = iVar6 + -1;
          } while (iVar6 != 0);
        }
        uVar2 = DAT_1000f184;
        iVar6 = *piVar4;
        if (iVar6 == -0x3fffff72) {
          DAT_1000f184 = 0x83;
        }
        else if (iVar6 == -0x3fffff70) {
          DAT_1000f184 = 0x81;
        }
        else if (iVar6 == -0x3fffff6f) {
          DAT_1000f184 = 0x84;
        }
        else if (iVar6 == -0x3fffff6d) {
          DAT_1000f184 = 0x85;
        }
        else if (iVar6 == -0x3fffff73) {
          DAT_1000f184 = 0x82;
        }
        else if (iVar6 == -0x3fffff71) {
          DAT_1000f184 = 0x86;
        }
        else if (iVar6 == -0x3fffff6e) {
          DAT_1000f184 = 0x8a;
        }
        (*pcVar1)(8,DAT_1000f184);
        DAT_1000f184 = uVar2;
      }
      else {
        piVar4[2] = 0;
        (*pcVar1)(piVar4[1]);
      }
    }
    LVar5 = -1;
    DAT_1000f7fc = (_EXCEPTION_POINTERS *)uVar3;
  }
  return LVar5;
}


/* ==== FUNCTION FUN_1000ab0f @ 1000ab0f size=67 ==== */

int * __cdecl FUN_1000ab0f(int param_1)

{
  int *piVar1;
  
  piVar1 = &DAT_1000f100;
  if (DAT_1000f100 != param_1) {
    do {
      piVar1 = piVar1 + 3;
      if (&DAT_1000f100 + DAT_1000f180 * 3 <= piVar1) break;
    } while (*piVar1 != param_1);
  }
  if ((&DAT_1000f100 + DAT_1000f180 * 3 <= piVar1) || (*piVar1 != param_1)) {
    piVar1 = (int *)0x0;
  }
  return piVar1;
}


/* ==== FUNCTION FUN_1000ab52 @ 1000ab52 size=511 ==== */

int __cdecl
FUN_1000ab52(LCID param_1,uint param_2,char *param_3,int param_4,LPWSTR param_5,int param_6,
            UINT param_7,int param_8)

{
  int iVar1;
  int iVar2;
  void *local_14;
  undefined1 *puStack_10;
  undefined *puStack_c;
  undefined4 local_8;
  
  local_8 = 0xffffffff;
  puStack_c = &DAT_1000d5e0;
  puStack_10 = &LAB_10009edc;
  local_14 = ExceptionList;
  ExceptionList = &local_14;
  if (DAT_1000f800 == 0) {
    ExceptionList = &local_14;
    iVar1 = LCMapStringW(0,0x100,L"",1,(LPWSTR)0x0,0);
    if (iVar1 == 0) {
      iVar1 = LCMapStringA(0,0x100,"",1,(LPSTR)0x0,0);
      if (iVar1 == 0) {
        ExceptionList = local_14;
        return 0;
      }
      DAT_1000f800 = 2;
    }
    else {
      DAT_1000f800 = 1;
    }
  }
  if (0 < param_4) {
    param_4 = FUN_1000ad76(param_3,param_4);
  }
  if (DAT_1000f800 == 2) {
    iVar1 = LCMapStringA(param_1,param_2,param_3,param_4,(LPSTR)param_5,param_6);
    ExceptionList = local_14;
    return iVar1;
  }
  if (DAT_1000f800 == 1) {
    if (param_7 == 0) {
      param_7 = DAT_1000f81c;
    }
    iVar1 = MultiByteToWideChar(param_7,(-(uint)(param_8 != 0) & 8) + 1,param_3,param_4,(LPWSTR)0x0,
                                0);
    if (iVar1 != 0) {
      local_8 = 0;
      FUN_10005600();
      local_8 = 0xffffffff;
      if ((&stack0x00000000 != (undefined1 *)0x3c) &&
         (iVar2 = MultiByteToWideChar(param_7,1,param_3,param_4,(LPWSTR)&stack0xffffffc4,iVar1),
         iVar2 != 0)) {
        iVar2 = LCMapStringW(param_1,param_2,(LPCWSTR)&stack0xffffffc4,iVar1,(LPWSTR)0x0,0);
        if (iVar2 != 0) {
          if ((param_2 & 0x400) == 0) {
            local_8 = 1;
            FUN_10005600();
            local_8 = 0xffffffff;
            if (&stack0x00000000 == (undefined1 *)0x3c) {
              ExceptionList = local_14;
              return 0;
            }
            iVar1 = LCMapStringW(param_1,param_2,(LPCWSTR)&stack0xffffffc4,iVar1,
                                 (LPWSTR)&stack0xffffffc4,iVar2);
            if (iVar1 == 0) {
              ExceptionList = local_14;
              return 0;
            }
            if (param_6 == 0) {
              param_6 = 0;
              param_5 = (LPWSTR)0x0;
            }
            iVar2 = WideCharToMultiByte(param_7,0x220,(LPCWSTR)&stack0xffffffc4,iVar2,(LPSTR)param_5
                                        ,param_6,(LPCSTR)0x0,(LPBOOL)0x0);
            iVar1 = iVar2;
          }
          else {
            if (param_6 == 0) {
              ExceptionList = local_14;
              return iVar2;
            }
            if (param_6 < iVar2) {
              ExceptionList = local_14;
              return 0;
            }
            iVar1 = LCMapStringW(param_1,param_2,(LPCWSTR)&stack0xffffffc4,iVar1,param_5,param_6);
          }
          if (iVar1 != 0) {
            ExceptionList = local_14;
            return iVar2;
          }
        }
      }
    }
  }
  ExceptionList = local_14;
  return 0;
}


/* ==== FUNCTION FUN_1000ad76 @ 1000ad76 size=43 ==== */

int __cdecl FUN_1000ad76(char *param_1,int param_2)

{
  char *pcVar1;
  int iVar2;
  
  iVar2 = param_2;
  for (pcVar1 = param_1; (iVar2 != 0 && (iVar2 = iVar2 + -1, *pcVar1 != '\0')); pcVar1 = pcVar1 + 1)
  {
  }
  if (*pcVar1 != '\0') {
    return param_2;
  }
  return (int)pcVar1 - (int)param_1;
}


/* ==== FUNCTION FUN_1000ada1 @ 1000ada1 size=33 ==== */

undefined4 __cdecl FUN_1000ada1(uint param_1,uint param_2,uint *param_3)

{
  uint uVar1;
  undefined4 uVar2;
  
  uVar2 = 0;
  uVar1 = param_1 + param_2;
  if ((uVar1 < param_1) || (uVar1 < param_2)) {
    uVar2 = 1;
  }
  *param_3 = uVar1;
  return uVar2;
}


/* ==== FUNCTION ___add_12 @ 1000adc2 size=94 ==== */

/* Library Function - Single Match
    ___add_12
   
   Library: Visual Studio 2003 Release */

void __cdecl ___add_12(uint *param_1,uint *param_2)

{
  int iVar1;
  
  iVar1 = FUN_1000ada1(*param_1,*param_2,param_1);
  if (iVar1 != 0) {
    iVar1 = FUN_1000ada1(param_1[1],1,param_1 + 1);
    if (iVar1 != 0) {
      param_1[2] = param_1[2] + 1;
    }
  }
  iVar1 = FUN_1000ada1(param_1[1],param_2[1],param_1 + 1);
  if (iVar1 != 0) {
    param_1[2] = param_1[2] + 1;
  }
  FUN_1000ada1(param_1[2],param_2[2],param_1 + 2);
  return;
}


/* ==== FUNCTION FUN_1000ae20 @ 1000ae20 size=46 ==== */

void __cdecl FUN_1000ae20(uint *param_1)

{
  uint uVar1;
  uint uVar2;
  
  uVar1 = *param_1;
  uVar2 = param_1[1];
  *param_1 = uVar1 * 2;
  param_1[1] = uVar2 * 2 | uVar1 >> 0x1f;
  param_1[2] = param_1[2] << 1 | uVar2 >> 0x1f;
  return;
}


/* ==== FUNCTION FUN_1000ae4e @ 1000ae4e size=45 ==== */

void __cdecl FUN_1000ae4e(uint *param_1)

{
  uint uVar1;
  
  uVar1 = param_1[1];
  param_1[1] = uVar1 >> 1 | param_1[2] << 0x1f;
  param_1[2] = param_1[2] >> 1;
  *param_1 = *param_1 >> 1 | uVar1 << 0x1f;
  return;
}


/* ==== FUNCTION FUN_1000ae7b @ 1000ae7b size=199 ==== */

void __cdecl FUN_1000ae7b(char *param_1,int param_2,uint *param_3)

{
  uint *puVar1;
  uint local_14;
  uint local_10;
  uint local_c;
  int local_8;
  
  puVar1 = param_3;
  local_8 = 0x404e;
  *param_3 = 0;
  param_3[1] = 0;
  param_3[2] = 0;
  if (param_2 != 0) {
    param_3 = (uint *)param_2;
    do {
      local_14 = *puVar1;
      local_10 = puVar1[1];
      local_c = puVar1[2];
      FUN_1000ae20(puVar1);
      FUN_1000ae20(puVar1);
      ___add_12(puVar1,&local_14);
      FUN_1000ae20(puVar1);
      local_10 = 0;
      local_c = 0;
      local_14 = (uint)*param_1;
      ___add_12(puVar1,&local_14);
      param_1 = param_1 + 1;
      param_3 = (uint *)((int)param_3 + -1);
    } while (param_3 != (uint *)0x0);
  }
  while (puVar1[2] == 0) {
    puVar1[2] = puVar1[1] >> 0x10;
    local_8 = local_8 + 0xfff0;
    puVar1[1] = *puVar1 >> 0x10 | puVar1[1] << 0x10;
    *puVar1 = *puVar1 << 0x10;
  }
  while ((puVar1[2] & 0x8000) == 0) {
    FUN_1000ae20(puVar1);
    local_8 = local_8 + 0xffff;
  }
  *(undefined2 *)((int)puVar1 + 10) = (undefined2)local_8;
  return;
}


/* ==== FUNCTION FUN_1000af42 @ 1000af42 size=1185 ==== */

undefined4 __thiscall
FUN_1000af42(void *this,ushort *param_1,int *param_2,byte *param_3,int param_4,int param_5,
            int param_6,int param_7)

{
  int iVar1;
  int iVar2;
  uint uVar3;
  char *pcVar4;
  int iVar5;
  byte bVar6;
  byte *pbVar7;
  byte *pbVar8;
  int iVar9;
  byte *pbVar10;
  char local_60 [23];
  char local_49;
  ushort local_44;
  undefined2 uStack_42;
  undefined2 uStack_40;
  byte *local_3e;
  ushort local_3a;
  int local_34;
  int local_30;
  undefined4 local_2c;
  int local_28;
  int local_24;
  byte *local_20;
  int local_1c;
  undefined4 local_18;
  int local_14;
  char *local_10;
  int local_c;
  uint local_8;
  
  local_10 = local_60;
  local_2c = 0;
  local_1c = 1;
  local_8 = 0;
  local_14 = 0;
  local_28 = 0;
  local_24 = 0;
  local_30 = 0;
  local_34 = 0;
  local_20 = (byte *)0x0;
  local_c = 0;
  local_18 = 0;
  pbVar8 = param_3;
  while( true ) {
    bVar6 = *pbVar8;
    this = (void *)CONCAT31((int3)((uint)this >> 8),bVar6);
    if ((((bVar6 != 0x20) && (bVar6 != 9)) && (bVar6 != 10)) && (bVar6 != 0xd)) break;
    pbVar8 = pbVar8 + 1;
  }
  iVar1 = 4;
  iVar9 = 0;
  iVar5 = local_14;
LAB_1000af99:
  local_14 = iVar5;
  pbVar7 = pbVar8;
  iVar5 = 1;
  bVar6 = *pbVar7;
  pbVar8 = pbVar7 + 1;
  iVar2 = local_14;
  switch(iVar9) {
  case 0:
    if (('0' < (char)bVar6) && ((char)bVar6 < ':')) {
LAB_1000afb6:
      local_14 = iVar2;
      iVar9 = 3;
      goto LAB_1000b1db;
    }
    if (bVar6 == DAT_1000ec98) goto LAB_1000afc5;
    if (bVar6 == 0x2b) {
      local_2c = 0;
      iVar9 = 2;
      iVar5 = local_14;
    }
    else if (bVar6 == 0x2d) {
      local_2c = 0x8000;
      iVar9 = 2;
      iVar5 = local_14;
    }
    else {
      iVar9 = iVar5;
      iVar5 = local_14;
      if (bVar6 != 0x30) goto LAB_1000b2b5;
    }
    goto LAB_1000af99;
  case 1:
    local_14 = 1;
    if (('0' < (char)bVar6) && (iVar2 = iVar5, (char)bVar6 < ':')) goto LAB_1000afb6;
    iVar9 = iVar1;
    if (bVar6 != DAT_1000ec98) {
      iVar9 = iVar5;
      if ((bVar6 == 0x2b) || (iVar9 = local_14, bVar6 == 0x2d)) goto LAB_1000b04a;
      iVar9 = iVar5;
      local_14 = iVar5;
      if (bVar6 != 0x30) goto LAB_1000b023;
    }
    goto LAB_1000af99;
  case 2:
    if (('0' < (char)bVar6) && ((char)bVar6 < ':')) goto LAB_1000afb6;
    if (bVar6 == DAT_1000ec98) {
LAB_1000afc5:
      iVar9 = 5;
      iVar5 = local_14;
    }
    else {
      iVar9 = iVar5;
      pbVar7 = param_3;
      iVar5 = local_14;
      if (bVar6 != 0x30) goto LAB_1000b2ba;
    }
    goto LAB_1000af99;
  case 3:
    local_14 = iVar5;
    while( true ) {
      if (DAT_1000ec94 < 2) {
        uVar3 = (byte)PTR_DAT_1000ea88[(uint)bVar6 * 2] & 4;
        this = PTR_DAT_1000ea88;
      }
      else {
        pbVar7 = (byte *)0x4;
        uVar3 = FUN_100070f8(this,(uint)bVar6,4);
        this = pbVar7;
      }
      if (uVar3 == 0) break;
      if (local_8 < 0x19) {
        local_8 = local_8 + 1;
        pcVar4 = local_10 + 1;
        *local_10 = bVar6 - 0x30;
        local_10 = pcVar4;
      }
      else {
        local_c = local_c + 1;
      }
      bVar6 = *pbVar8;
      pbVar8 = pbVar8 + 1;
    }
    iVar9 = iVar1;
    iVar5 = local_14;
    if (bVar6 != DAT_1000ec98) goto LAB_1000b137;
    goto LAB_1000af99;
  case 4:
    local_14 = 1;
    local_28 = 1;
    iVar9 = iVar5;
    if (local_8 == 0) {
      while (iVar5 = local_28, iVar9 = local_14, bVar6 == 0x30) {
        local_c = local_c + -1;
        bVar6 = *pbVar8;
        pbVar8 = pbVar8 + 1;
      }
    }
    while( true ) {
      local_14 = iVar9;
      local_28 = iVar5;
      if (DAT_1000ec94 < 2) {
        uVar3 = (byte)PTR_DAT_1000ea88[(uint)bVar6 * 2] & 4;
        this = PTR_DAT_1000ea88;
      }
      else {
        pbVar7 = (byte *)0x4;
        uVar3 = FUN_100070f8(this,(uint)bVar6,4);
        this = pbVar7;
      }
      if (uVar3 == 0) break;
      if (local_8 < 0x19) {
        local_8 = local_8 + 1;
        local_c = local_c + -1;
        pcVar4 = local_10 + 1;
        *local_10 = bVar6 - 0x30;
        local_10 = pcVar4;
      }
      bVar6 = *pbVar8;
      pbVar8 = pbVar8 + 1;
      iVar5 = local_28;
      iVar9 = local_14;
    }
LAB_1000b137:
    iVar9 = local_14;
    if ((bVar6 == 0x2b) || (bVar6 == 0x2d)) {
LAB_1000b04a:
      local_14 = iVar9;
      iVar9 = 0xb;
      pbVar8 = pbVar8 + -1;
      iVar5 = local_14;
    }
    else {
LAB_1000b023:
      if (((char)bVar6 < 'D') ||
         (('E' < (char)bVar6 && (((char)bVar6 < 'd' || ('e' < (char)bVar6)))))) goto LAB_1000b2b5;
      iVar9 = 6;
      iVar5 = local_14;
    }
    goto LAB_1000af99;
  case 5:
    local_28 = iVar5;
    if (DAT_1000ec94 < 2) {
      uVar3 = (byte)PTR_DAT_1000ea88[(uint)bVar6 * 2] & 4;
      this = PTR_DAT_1000ea88;
    }
    else {
      pbVar7 = (byte *)0x4;
      uVar3 = FUN_100070f8(this,(uint)bVar6,4);
      this = pbVar7;
    }
    iVar9 = iVar1;
    pbVar7 = param_3;
    if (uVar3 != 0) goto LAB_1000b1db;
    goto LAB_1000b2ba;
  case 6:
    pbVar7 = pbVar7 + -1;
    this = pbVar7;
    param_3 = pbVar7;
    if (((char)bVar6 < '1') || ('9' < (char)bVar6)) {
      if (bVar6 == 0x2b) goto LAB_1000b210;
      if (bVar6 == 0x2d) goto LAB_1000b204;
      if (bVar6 != 0x30) goto LAB_1000b2ba;
LAB_1000b1a9:
      iVar9 = 8;
      iVar5 = local_14;
      goto LAB_1000af99;
    }
    break;
  case 7:
    if (((char)bVar6 < '1') || ('9' < (char)bVar6)) {
      pbVar7 = param_3;
      if (bVar6 == 0x30) goto LAB_1000b1a9;
      goto LAB_1000b2ba;
    }
    break;
  case 8:
    local_24 = 1;
    while (bVar6 == 0x30) {
      bVar6 = *pbVar8;
      pbVar8 = pbVar8 + 1;
    }
    if (((char)bVar6 < '1') || ('9' < (char)bVar6)) goto LAB_1000b2b5;
    break;
  case 9:
    local_24 = 1;
    pbVar7 = (byte *)0x0;
    goto LAB_1000b23b;
  default:
    goto switchD_1000afa5_caseD_a;
  case 0xb:
    if (param_7 != 0) {
      if (bVar6 == 0x2b) {
LAB_1000b210:
        iVar9 = 7;
        this = pbVar7;
        param_3 = pbVar7;
        iVar5 = local_14;
      }
      else {
        param_3 = pbVar7;
        if (bVar6 != 0x2d) goto LAB_1000b2ba;
LAB_1000b204:
        local_1c = -1;
        iVar9 = 7;
        this = pbVar7;
        param_3 = pbVar7;
        iVar5 = local_14;
      }
      goto LAB_1000af99;
    }
    iVar9 = 10;
    pbVar8 = pbVar7;
switchD_1000afa5_caseD_a:
    pbVar7 = pbVar8;
    iVar5 = local_14;
    if (iVar9 != 10) goto LAB_1000af99;
    goto LAB_1000b2ba;
  }
  iVar9 = 9;
LAB_1000b1db:
  pbVar8 = pbVar8 + -1;
  iVar5 = local_14;
  goto LAB_1000af99;
LAB_1000b23b:
  if (DAT_1000ec94 < 2) {
    uVar3 = (byte)PTR_DAT_1000ea88[(uint)bVar6 * 2] & 4;
    this = PTR_DAT_1000ea88;
  }
  else {
    pbVar10 = (byte *)0x4;
    uVar3 = FUN_100070f8(this,(uint)bVar6,4);
    this = pbVar10;
  }
  if (uVar3 == 0) goto LAB_1000b285;
  this = (void *)(int)(char)bVar6;
  pbVar7 = (byte *)((int)this + (int)pbVar7 * 10 + -0x30);
  if (0x1450 < (int)pbVar7) goto LAB_1000b27d;
  bVar6 = *pbVar8;
  pbVar8 = pbVar8 + 1;
  goto LAB_1000b23b;
LAB_1000b27d:
  pbVar7 = (byte *)0x1451;
LAB_1000b285:
  while( true ) {
    local_20 = pbVar7;
    if (DAT_1000ec94 < 2) {
      uVar3 = (byte)PTR_DAT_1000ea88[(uint)bVar6 * 2] & 4;
      this = PTR_DAT_1000ea88;
    }
    else {
      pbVar7 = (byte *)0x4;
      uVar3 = FUN_100070f8(this,(uint)bVar6,4);
      this = pbVar7;
    }
    if (uVar3 == 0) break;
    bVar6 = *pbVar8;
    pbVar8 = pbVar8 + 1;
    pbVar7 = local_20;
  }
LAB_1000b2b5:
  pbVar7 = pbVar8 + -1;
LAB_1000b2ba:
  *param_2 = (int)pbVar7;
  if (local_14 == 0) {
    local_44 = 0;
    local_3a = 0;
    local_3e = (byte *)0x0;
    param_3 = (byte *)0x0;
    local_18 = 4;
    goto LAB_1000b3c8;
  }
  pcVar4 = local_10;
  if (0x18 < local_8) {
    if ('\x04' < local_49) {
      local_49 = local_49 + '\x01';
    }
    local_8 = 0x18;
    local_c = local_c + 1;
    pcVar4 = local_10 + -1;
  }
  if (local_8 == 0) {
    local_44 = 0;
    local_3a = 0;
    local_3e = (byte *)0x0;
    param_3 = (byte *)0x0;
  }
  else {
    while (pcVar4 = pcVar4 + -1, *pcVar4 == '\0') {
      local_8 = local_8 - 1;
      local_c = local_c + 1;
    }
    FUN_1000ae7b(local_60,local_8,(uint *)&local_44);
    pbVar8 = local_20;
    if (local_1c < 0) {
      pbVar8 = (byte *)-(int)local_20;
    }
    pbVar8 = pbVar8 + local_c;
    if (local_24 == 0) {
      pbVar8 = pbVar8 + param_5;
    }
    if (local_28 == 0) {
      pbVar8 = pbVar8 + -param_6;
    }
    if ((int)pbVar8 < 0x1451) {
      if (-0x1451 < (int)pbVar8) {
        FUN_1000c061((int *)&local_44,(uint)pbVar8,param_4);
        param_3 = (byte *)CONCAT22(uStack_40,uStack_42);
        goto LAB_1000b34d;
      }
      local_34 = 1;
    }
    else {
      local_30 = 1;
    }
    local_3a = (ushort)param_3;
    local_3e = param_3;
    local_44 = local_3a;
  }
LAB_1000b34d:
  if (local_30 == 0) {
    if (local_34 != 0) {
      local_44 = 0;
      local_3a = 0;
      local_3e = (byte *)0x0;
      param_3 = (byte *)0x0;
      local_18 = 1;
    }
  }
  else {
    param_3 = (byte *)0x0;
    local_3a = 0x7fff;
    local_3e = (byte *)0x80000000;
    local_44 = 0;
    local_18 = 2;
  }
LAB_1000b3c8:
  *(byte **)(param_1 + 3) = local_3e;
  *(byte **)(param_1 + 1) = param_3;
  param_1[5] = local_3a | (ushort)local_2c;
  *param_1 = local_44;
  return local_18;
}


/* ==== FUNCTION FUN_1000b413 @ 1000b413 size=60 ==== */

uint __thiscall FUN_1000b413(void *this,undefined4 *param_1,int *param_2,byte *param_3,int param_4)

{
  uint uVar1;
  int iVar2;
  ushort local_10 [6];
  
  uVar1 = FUN_1000af42(this,local_10,param_2,param_3,param_4,0,0,0);
  iVar2 = FUN_10008189(local_10,param_1);
  if (iVar2 == 1) {
    uVar1 = uVar1 | 2;
  }
  return uVar1;
}


/* ==== FUNCTION FUN_1000b44f @ 1000b44f size=659 ==== */

undefined4 __cdecl
FUN_1000b44f(uint param_1,uint param_2,uint param_3,int param_4,byte param_5,short *param_6)

{
  short *psVar1;
  uint uVar2;
  short *psVar3;
  char cVar4;
  uint uVar5;
  short *psVar6;
  short *psVar7;
  short sVar8;
  int iVar9;
  int iVar10;
  char *pcVar11;
  undefined1 local_20;
  undefined1 local_1f;
  undefined1 local_1e;
  undefined1 local_1d;
  undefined1 local_1c;
  undefined1 local_1b;
  undefined1 local_1a;
  undefined1 local_19;
  undefined1 local_18;
  undefined1 local_17;
  undefined1 local_16;
  undefined1 local_15;
  undefined2 local_14;
  undefined4 local_12;
  undefined4 local_e;
  undefined1 local_a;
  char cStack_9;
  undefined4 local_8;
  
  psVar3 = param_6;
  uVar5 = param_3 & 0x7fff;
  local_20 = 0xcc;
  local_1f = 0xcc;
  local_1e = 0xcc;
  local_1d = 0xcc;
  local_1c = 0xcc;
  local_1b = 0xcc;
  local_1a = 0xcc;
  local_19 = 0xcc;
  local_18 = 0xcc;
  local_17 = 0xcc;
  local_16 = 0xfb;
  local_15 = 0x3f;
  local_8 = 1;
  if ((param_3 & 0x8000) == 0) {
    *(undefined1 *)(param_6 + 1) = 0x20;
  }
  else {
    *(undefined1 *)(param_6 + 1) = 0x2d;
  }
  if ((((short)uVar5 != 0) || (param_2 != 0)) || (param_1 != 0)) {
    if ((short)uVar5 == 0x7fff) {
      *param_6 = 1;
      if (((param_2 == 0x80000000) && (param_1 == 0)) || ((param_2 & 0x40000000) != 0)) {
        if (((param_3 & 0x8000) == 0) || (param_2 != 0xc0000000)) {
          if ((param_2 != 0x80000000) || (param_1 != 0)) goto LAB_1000b544;
          pcVar11 = "1#INF";
        }
        else {
          if (param_1 != 0) {
LAB_1000b544:
            pcVar11 = "1#QNAN";
            goto LAB_1000b549;
          }
          pcVar11 = "1#IND";
        }
        FUN_10008290((uint *)(param_6 + 2),(uint *)pcVar11);
        *(undefined1 *)((int)psVar3 + 3) = 5;
      }
      else {
        pcVar11 = "1#SNAN";
LAB_1000b549:
        FUN_10008290((uint *)(param_6 + 2),(uint *)pcVar11);
        *(undefined1 *)((int)psVar3 + 3) = 6;
      }
      return 0;
    }
    local_14 = 0;
    local_a = (undefined1)uVar5;
    cStack_9 = (char)(uVar5 >> 8);
    sVar8 = (short)(((uVar5 >> 8) + (param_2 >> 0x18) * 2) * 0x4d + -0x134312f4 + uVar5 * 0x4d10 >>
                   0x10);
    local_e = param_2;
    local_12 = param_1;
    FUN_1000c061((int *)&local_14,-(int)sVar8,1);
    if (0x3ffe < CONCAT11(cStack_9,local_a)) {
      sVar8 = sVar8 + 1;
      FUN_1000be41((int *)&local_14,(int *)&local_20);
    }
    *psVar3 = sVar8;
    iVar10 = param_4;
    if (((param_5 & 1) == 0) || (iVar10 = param_4 + sVar8, 0 < param_4 + sVar8)) {
      if (0x15 < iVar10) {
        iVar10 = 0x15;
      }
      iVar9 = CONCAT11(cStack_9,local_a) - 0x3ffe;
      local_a = 0;
      cStack_9 = '\0';
      param_6 = (short *)0x8;
      do {
        FUN_1000ae20((uint *)&local_14);
        param_6 = (short *)((int)param_6 + -1);
      } while (param_6 != (short *)0x0);
      if (iVar9 < 0) {
        param_6 = (short *)0x0;
        for (uVar5 = -iVar9 & 0xff; uVar5 != 0; uVar5 = uVar5 - 1) {
          FUN_1000ae4e((uint *)&local_14);
        }
      }
      param_4 = iVar10 + 1;
      psVar6 = psVar3 + 2;
      param_6 = psVar6;
      uVar5 = local_12;
      uVar2 = local_e;
      if (0 < param_4) {
        do {
          local_e._2_2_ = (undefined2)(uVar2 >> 0x10);
          local_e._0_2_ = (undefined2)uVar2;
          local_12._2_2_ = (undefined2)(uVar5 >> 0x10);
          local_12._0_2_ = (undefined2)uVar5;
          param_1 = CONCAT22((undefined2)local_12,local_14);
          param_2 = CONCAT22((undefined2)local_e,local_12._2_2_);
          param_3 = CONCAT13(cStack_9,CONCAT12(local_a,local_e._2_2_));
          local_12 = uVar5;
          local_e = uVar2;
          FUN_1000ae20((uint *)&local_14);
          FUN_1000ae20((uint *)&local_14);
          ___add_12((uint *)&local_14,&param_1);
          FUN_1000ae20((uint *)&local_14);
          cVar4 = cStack_9;
          cStack_9 = '\0';
          psVar6 = (short *)((int)param_6 + 1);
          param_4 = param_4 + -1;
          *(char *)param_6 = cVar4 + '0';
          param_6 = psVar6;
          uVar5 = local_12;
          uVar2 = local_e;
        } while (param_4 != 0);
      }
      psVar7 = psVar6 + -1;
      psVar1 = psVar3 + 2;
      if ('4' < *(char *)((int)psVar6 + -1)) {
        for (; psVar1 <= psVar7; psVar7 = (short *)((int)psVar7 + -1)) {
          if ((char)*psVar7 != '9') {
            if (psVar1 <= psVar7) goto LAB_1000b6a1;
            break;
          }
          *(char *)psVar7 = '0';
        }
        psVar7 = (short *)((int)psVar7 + 1);
        *psVar3 = *psVar3 + 1;
LAB_1000b6a1:
        *(char *)psVar7 = (char)*psVar7 + '\x01';
LAB_1000b6a3:
        cVar4 = ((char)psVar7 - (char)psVar3) + -3;
        *(char *)((int)psVar3 + 3) = cVar4;
        *(undefined1 *)(cVar4 + 4 + (int)psVar3) = 0;
        return local_8;
      }
      for (; psVar1 <= psVar7; psVar7 = (short *)((int)psVar7 + -1)) {
        if ((char)*psVar7 != '0') {
          if (psVar1 <= psVar7) goto LAB_1000b6a3;
          break;
        }
      }
      *psVar3 = 0;
      *(undefined1 *)(psVar3 + 1) = 0x20;
      *(undefined1 *)((int)psVar3 + 3) = 1;
      *(char *)psVar1 = '0';
      goto LAB_1000b6d9;
    }
  }
  *psVar3 = 0;
  *(undefined1 *)(psVar3 + 1) = 0x20;
  *(undefined1 *)((int)psVar3 + 3) = 1;
  *(undefined1 *)(psVar3 + 2) = 0x30;
LAB_1000b6d9:
  *(undefined1 *)((int)psVar3 + 5) = 0;
  return 1;
}


/* ==== FUNCTION FUN_1000b6e2 @ 1000b6e2 size=103 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __cdecl FUN_1000b6e2(uint param_1)

{
  uint *puVar1;
  int iVar2;
  
  iVar2 = 0;
  _DAT_1000f650 = param_1;
  puVar1 = &DAT_1000f188;
  do {
    if (param_1 == *puVar1) {
      _DAT_1000f64c = *(undefined4 *)(iVar2 * 8 + 0x1000f18c);
      return;
    }
    puVar1 = puVar1 + 2;
    iVar2 = iVar2 + 1;
  } while ((int)puVar1 < 0x1000f2f0);
  if ((0x12 < param_1) && (param_1 < 0x25)) {
    _DAT_1000f64c = 0xd;
    return;
  }
  if ((param_1 < 0xbc) || (_DAT_1000f64c = 8, 0xca < param_1)) {
    _DAT_1000f64c = 0x16;
  }
  return;
}


/* ==== FUNCTION FUN_1000b749 @ 1000b749 size=149 ==== */

int FUN_1000b749(void)

{
  undefined4 *puVar1;
  undefined4 *puVar2;
  int *piVar3;
  int iVar4;
  int iVar5;
  int iVar6;
  
  iVar4 = -1;
  iVar6 = 0;
  iVar5 = 0;
  piVar3 = &DAT_10010aa0;
  do {
    puVar2 = (undefined4 *)*piVar3;
    if (puVar2 == (undefined4 *)0x0) {
      puVar2 = _malloc(0x100);
      if (puVar2 != (undefined4 *)0x0) {
        DAT_10010ba0 = DAT_10010ba0 + 0x20;
        (&DAT_10010aa0)[iVar6] = puVar2;
        puVar1 = puVar2;
        for (; puVar2 < puVar1 + 0x40; puVar2 = puVar2 + 2) {
          *(undefined1 *)(puVar2 + 1) = 0;
          *puVar2 = 0xffffffff;
          *(undefined1 *)((int)puVar2 + 5) = 10;
          puVar1 = (undefined4 *)(&DAT_10010aa0)[iVar6];
        }
        iVar4 = iVar6 << 5;
      }
      return iVar4;
    }
    puVar1 = puVar2 + 0x40;
    for (; puVar2 < puVar1; puVar2 = puVar2 + 2) {
      if ((*(byte *)(puVar2 + 1) & 1) == 0) {
        *puVar2 = 0xffffffff;
        iVar4 = ((int)puVar2 - *piVar3 >> 3) + iVar5;
        if (iVar4 != -1) {
          return iVar4;
        }
        break;
      }
    }
    piVar3 = piVar3 + 1;
    iVar6 = iVar6 + 1;
    iVar5 = iVar5 + 0x20;
    if (0x10010b9f < (int)piVar3) {
      return iVar4;
    }
  } while( true );
}


/* ==== FUNCTION FUN_1000b7de @ 1000b7de size=119 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __cdecl FUN_1000b7de(uint param_1,HANDLE param_2)

{
  int iVar1;
  DWORD nStdHandle;
  
  if (param_1 < DAT_10010ba0) {
    iVar1 = (param_1 & 0x1f) * 8;
    if (*(int *)((&DAT_10010aa0)[(int)param_1 >> 5] + iVar1) == -1) {
      if (DAT_1000f628 == 1) {
        if (param_1 == 0) {
          nStdHandle = 0xfffffff6;
        }
        else if (param_1 == 1) {
          nStdHandle = 0xfffffff5;
        }
        else {
          if (param_1 != 2) goto LAB_1000b834;
          nStdHandle = 0xfffffff4;
        }
        SetStdHandle(nStdHandle,param_2);
      }
LAB_1000b834:
      *(HANDLE *)((&DAT_10010aa0)[(int)param_1 >> 5] + iVar1) = param_2;
      return 0;
    }
  }
  _DAT_1000f650 = 0;
  _DAT_1000f64c = 9;
  return 0xffffffff;
}


/* ==== FUNCTION FUN_1000b855 @ 1000b855 size=122 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __cdecl FUN_1000b855(uint param_1)

{
  int *piVar1;
  int iVar2;
  DWORD nStdHandle;
  
  if (param_1 < DAT_10010ba0) {
    iVar2 = (param_1 & 0x1f) * 8;
    piVar1 = (int *)((&DAT_10010aa0)[(int)param_1 >> 5] + iVar2);
    if (((*(byte *)(piVar1 + 1) & 1) != 0) && (*piVar1 != -1)) {
      if (DAT_1000f628 == 1) {
        if (param_1 == 0) {
          nStdHandle = 0xfffffff6;
        }
        else if (param_1 == 1) {
          nStdHandle = 0xfffffff5;
        }
        else {
          if (param_1 != 2) goto LAB_1000b8ae;
          nStdHandle = 0xfffffff4;
        }
        SetStdHandle(nStdHandle,(HANDLE)0x0);
      }
LAB_1000b8ae:
      *(undefined4 *)((&DAT_10010aa0)[(int)param_1 >> 5] + iVar2) = 0xffffffff;
      return 0;
    }
  }
  _DAT_1000f650 = 0;
  _DAT_1000f64c = 9;
  return 0xffffffff;
}


/* ==== FUNCTION FUN_1000b8cf @ 1000b8cf size=61 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __cdecl FUN_1000b8cf(uint param_1)

{
  if ((param_1 < DAT_10010ba0) &&
     ((*(byte *)((&DAT_10010aa0)[(int)param_1 >> 5] + 4 + (param_1 & 0x1f) * 8) & 1) != 0)) {
    return *(undefined4 *)((&DAT_10010aa0)[(int)param_1 >> 5] + (param_1 & 0x1f) * 8);
  }
  _DAT_1000f650 = 0;
  _DAT_1000f64c = 9;
  return 0xffffffff;
}


/* ==== FUNCTION FUN_1000b90c @ 1000b90c size=157 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __cdecl FUN_1000b90c(HANDLE param_1,uint param_2)

{
  DWORD DVar1;
  uint uVar2;
  byte bVar3;
  
  bVar3 = 0;
  if ((param_2 & 8) != 0) {
    bVar3 = 0x20;
  }
  if ((param_2 & 0x4000) != 0) {
    bVar3 = bVar3 | 0x80;
  }
  if ((param_2 & 0x80) != 0) {
    bVar3 = bVar3 | 0x10;
  }
  DVar1 = GetFileType(param_1);
  if (DVar1 == 0) {
    DVar1 = GetLastError();
    FUN_1000b6e2(DVar1);
    uVar2 = 0xffffffff;
  }
  else {
    if (DVar1 == 2) {
      bVar3 = bVar3 | 0x40;
    }
    else if (DVar1 == 3) {
      bVar3 = bVar3 | 8;
    }
    uVar2 = FUN_1000b749();
    if (uVar2 == 0xffffffff) {
      _DAT_1000f650 = 0;
      _DAT_1000f64c = 0x18;
      uVar2 = 0xffffffff;
    }
    else {
      FUN_1000b7de(uVar2,param_1);
      *(byte *)((&DAT_10010aa0)[(int)uVar2 >> 5] + 4 + (uVar2 & 0x1f) * 8) = bVar3 | 1;
    }
  }
  return uVar2;
}


/* ==== FUNCTION FUN_1000b9a9 @ 1000b9a9 size=125 ==== */

int * __cdecl FUN_1000b9a9(int param_1,int param_2)

{
  int *piVar1;
  int iVar2;
  uint *_Size;
  uint *puVar3;
  
  _Size = (uint *)(param_1 * param_2);
  puVar3 = _Size;
  if (_Size < (uint *)0xffffffe1) {
    if (_Size == (uint *)0x0) {
      puVar3 = (uint *)0x1;
    }
    puVar3 = (uint *)((int)puVar3 + 0xfU & 0xfffffff0);
  }
  do {
    if (puVar3 < (uint *)0xffffffe1) {
      if ((_Size < DAT_1000ed70 || (int)_Size - (int)DAT_1000ed70 == 0) &&
         (piVar1 = FUN_10008cf5(_Size), piVar1 != (int *)0x0)) {
        _memset(piVar1,0,(size_t)_Size);
        return piVar1;
      }
      piVar1 = HeapAlloc(DAT_10010ba4,8,(SIZE_T)puVar3);
      if (piVar1 != (int *)0x0) {
        return piVar1;
      }
    }
    if (DAT_1000f7d8 == 0) {
      return (int *)0x0;
    }
    iVar2 = FUN_100098b6(puVar3);
  } while (iVar2 != 0);
  return (int *)0x0;
}


/* ==== FUNCTION FUN_1000ba7e @ 1000ba7e size=59 ==== */

int __cdecl FUN_1000ba7e(int *param_1)

{
  int iVar1;
  
  if (param_1 == (int *)0x0) {
    iVar1 = flsall(0);
    return iVar1;
  }
  iVar1 = FUN_1000bab9(param_1);
  if (iVar1 != 0) {
    return -1;
  }
  if ((*(byte *)((int)param_1 + 0xd) & 0x40) != 0) {
    iVar1 = FUN_1000c133(param_1[4]);
    return -(uint)(iVar1 != 0);
  }
  return 0;
}


/* ==== FUNCTION FUN_1000bab9 @ 1000bab9 size=92 ==== */

undefined4 __cdecl FUN_1000bab9(int *param_1)

{
  uint uVar1;
  undefined4 uVar2;
  uint uVar3;
  
  uVar2 = 0;
  if ((((byte)param_1[3] & 3) == 2) && ((param_1[3] & 0x108U) != 0)) {
    uVar3 = *param_1 - param_1[2];
    if (0 < (int)uVar3) {
      uVar1 = FUN_1000996b(param_1[4],(char *)param_1[2],uVar3);
      if (uVar1 == uVar3) {
        if ((param_1[3] & 0x80U) != 0) {
          param_1[3] = param_1[3] & 0xfffffffd;
        }
      }
      else {
        param_1[3] = param_1[3] | 0x20;
        uVar2 = 0xffffffff;
      }
    }
  }
  param_1[1] = 0;
  *param_1 = param_1[2];
  return uVar2;
}


/* ==== FUNCTION flsall @ 1000bb1e size=109 ==== */

/* Library Function - Single Match
    _flsall
   
   Library: Visual Studio 2003 Release */

int __cdecl flsall(int param_1)

{
  int *piVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  
  iVar4 = 0;
  iVar3 = 0;
  iVar5 = 0;
  if (0 < DAT_10010a80) {
    do {
      piVar1 = *(int **)(DAT_1000fa68 + iVar4 * 4);
      if ((piVar1 != (int *)0x0) && ((piVar1[3] & 0x83U) != 0)) {
        if (param_1 == 1) {
          iVar2 = FUN_1000ba7e(piVar1);
          if (iVar2 != -1) {
            iVar3 = iVar3 + 1;
          }
        }
        else if ((param_1 == 0) && ((piVar1[3] & 2U) != 0)) {
          iVar2 = FUN_1000ba7e(piVar1);
          if (iVar2 == -1) {
            iVar5 = -1;
          }
        }
      }
      iVar4 = iVar4 + 1;
    } while (iVar4 < DAT_10010a80);
  }
  if (param_1 != 1) {
    iVar3 = iVar5;
  }
  return iVar3;
}


/* ==== FUNCTION FUN_1000bb8b @ 1000bb8b size=268 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int __cdecl FUN_1000bb8b(int param_1,int param_2)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  undefined4 *puVar5;
  BOOL BVar6;
  
  if ((param_2 == 4) || (param_2 == 3)) {
LAB_1000bc55:
    _DAT_1000f64c = 0x16;
    param_2 = -1;
  }
  else {
    if ((param_1 == 2) || (param_1 == 0x15)) {
LAB_1000bc0b:
      if (DAT_1000f834 == 0) {
        BVar6 = SetConsoleCtrlHandler((PHANDLER_ROUTINE)&LAB_1000bc97,1);
        if (BVar6 != 1) {
          _DAT_1000f650 = GetLastError();
          goto LAB_1000bc55;
        }
        DAT_1000f834 = 1;
      }
    }
    else {
      if ((param_1 != 0x16) && (param_1 != 0xf)) {
        if (((param_1 == 8) || ((param_1 == 4 || (param_1 == 0xb)))) &&
           (puVar5 = FUN_1000bdfc(param_1), puVar5 != (undefined4 *)0x0)) {
          iVar1 = puVar5[2];
          do {
            if (puVar5[1] != param_1) {
              return iVar1;
            }
            puVar5[2] = param_2;
            puVar5 = puVar5 + 3;
          } while (puVar5 < &DAT_1000f100 + DAT_1000f180 * 3);
          return iVar1;
        }
        goto LAB_1000bc55;
      }
      if (param_1 == 0x15) goto LAB_1000bc0b;
    }
    iVar4 = DAT_1000f830;
    iVar3 = DAT_1000f82c;
    iVar2 = DAT_1000f828;
    iVar1 = DAT_1000f824;
    if (param_1 == 2) {
      DAT_1000f824 = param_2;
      param_2 = iVar1;
    }
    else if (param_1 == 0xf) {
      DAT_1000f830 = param_2;
      param_2 = iVar4;
    }
    else if (param_1 == 0x15) {
      DAT_1000f828 = param_2;
      param_2 = iVar2;
    }
    else if (param_1 == 0x16) {
      DAT_1000f82c = param_2;
      param_2 = iVar3;
    }
  }
  return param_2;
}


/* ==== FUNCTION FUN_1000bccf @ 1000bccf size=301 ==== */

undefined4 __cdecl FUN_1000bccf(int param_1)

{
  int iVar1;
  int iVar2;
  undefined4 *puVar3;
  int iVar4;
  int iVar5;
  code *pcVar6;
  
  iVar2 = param_1;
  if (param_1 == 2) {
    puVar3 = &DAT_1000f824;
    pcVar6 = DAT_1000f824;
  }
  else if (((param_1 == 4) || (param_1 == 8)) || (param_1 == 0xb)) {
    puVar3 = FUN_1000bdfc(param_1);
    pcVar6 = (code *)puVar3[2];
    puVar3 = puVar3 + 2;
  }
  else if (param_1 == 0xf) {
    puVar3 = &DAT_1000f830;
    pcVar6 = DAT_1000f830;
  }
  else if (param_1 == 0x15) {
    puVar3 = &DAT_1000f828;
    pcVar6 = DAT_1000f828;
  }
  else {
    if (param_1 != 0x16) {
      return 0xffffffff;
    }
    puVar3 = &DAT_1000f82c;
    pcVar6 = DAT_1000f82c;
  }
  iVar1 = DAT_1000f7fc;
  iVar4 = DAT_1000f184;
  if (pcVar6 == (code *)0x1) {
    return 0;
  }
  if (pcVar6 == (code *)0x0) {
                    /* WARNING: Subroutine does not return */
    __exit(3);
  }
  if (((param_1 == 8) || (param_1 == 0xb)) || (iVar5 = param_1, param_1 == 4)) {
    DAT_1000f7fc = 0;
    iVar5 = iVar1;
    if (param_1 == 8) {
      DAT_1000f184 = 0x8c;
      param_1 = iVar4;
      goto LAB_1000bd93;
    }
LAB_1000bdbf:
    *puVar3 = 0;
    if (iVar2 != 8) {
      (*pcVar6)(iVar2);
      if ((iVar2 != 0xb) && (iVar2 != 4)) {
        return 0;
      }
      goto LAB_1000bde2;
    }
  }
  else {
LAB_1000bd93:
    if (iVar2 != 8) goto LAB_1000bdbf;
    if (DAT_1000f178 < DAT_1000f17c + DAT_1000f178) {
      iVar4 = (DAT_1000f17c + DAT_1000f178) - DAT_1000f178;
      puVar3 = (undefined4 *)(DAT_1000f178 * 0xc + 0x1000f108);
      do {
        *puVar3 = 0;
        puVar3 = puVar3 + 3;
        iVar4 = iVar4 + -1;
      } while (iVar4 != 0);
    }
  }
  (*pcVar6)(8,DAT_1000f184);
LAB_1000bde2:
  if (iVar2 == 8) {
    DAT_1000f184 = param_1;
  }
  DAT_1000f7fc = iVar5;
  return 0;
}


/* ==== FUNCTION FUN_1000bdfc @ 1000bdfc size=69 ==== */

undefined4 * __cdecl FUN_1000bdfc(int param_1)

{
  int *piVar1;
  undefined4 *puVar2;
  undefined4 *puVar3;
  
  puVar2 = &DAT_1000f100;
  if (DAT_1000f104 != param_1) {
    puVar3 = puVar2;
    do {
      puVar2 = puVar3 + 3;
      if (&DAT_1000f100 + DAT_1000f180 * 3 <= puVar2) break;
      piVar1 = puVar3 + 4;
      puVar3 = puVar2;
    } while (*piVar1 != param_1);
  }
  if ((&DAT_1000f100 + DAT_1000f180 * 3 <= puVar2) || (puVar2[1] != param_1)) {
    puVar2 = (undefined4 *)0x0;
  }
  return puVar2;
}


/* ==== FUNCTION FUN_1000be41 @ 1000be41 size=544 ==== */

void __cdecl FUN_1000be41(int *param_1,int *param_2)

{
  int *piVar1;
  short sVar2;
  int iVar3;
  int *piVar4;
  int *piVar5;
  ushort uVar6;
  uint uVar7;
  int iVar8;
  ushort uVar9;
  uint uVar10;
  ushort uVar11;
  byte local_28;
  undefined1 uStack_27;
  undefined2 uStack_26;
  short local_24;
  undefined2 uStack_22;
  undefined2 local_20;
  undefined1 uStack_1e;
  byte bStack_1d;
  int *local_1c;
  int local_18;
  int local_14;
  ushort *local_10;
  ushort *local_c;
  short *local_8;
  
  piVar5 = param_2;
  piVar4 = param_1;
  local_18 = 0;
  local_28 = 0;
  uStack_27 = 0;
  uStack_26 = 0;
  local_24 = 0;
  uStack_22 = 0;
  local_20 = 0;
  uStack_1e = 0;
  bStack_1d = 0;
  uVar7 = *(ushort *)((int)param_1 + 10) & 0x7fff;
  uVar10 = *(ushort *)((int)param_2 + 10) & 0x7fff;
  uVar11 = (*(ushort *)((int)param_2 + 10) ^ *(ushort *)((int)param_1 + 10)) & 0x8000;
  uVar6 = (ushort)uVar7;
  piVar1 = (int *)(uVar10 + uVar7);
  if (((uVar6 < 0x7fff) && (uVar9 = (ushort)uVar10, uVar9 < 0x7fff)) && ((ushort)piVar1 < 0xbffe)) {
    if ((ushort)piVar1 < 0x3fc0) {
LAB_1000bee4:
      piVar4[2] = 0;
      piVar4[1] = 0;
      *piVar4 = 0;
      return;
    }
    if (((uVar6 != 0) || (piVar1 = (int *)((int)piVar1 + 1), (param_1[2] & 0x7fffffffU) != 0)) ||
       ((uVar6 = 0, param_1[1] != 0 || (*param_1 != 0)))) {
      param_1 = piVar1;
      if (((uVar9 == 0) && (param_1 = (int *)((int)param_1 + 1), (param_2[2] & 0x7fffffffU) == 0))
         && ((param_2[1] == 0 && (*param_2 == 0)))) goto LAB_1000bee4;
      local_14 = 0;
      local_8 = &local_24;
      param_2 = (int *)0x5;
      do {
        if (0 < (int)param_2) {
          local_c = (ushort *)(local_14 * 2 + (int)piVar4);
          local_10 = (ushort *)(piVar5 + 2);
          local_1c = param_2;
          do {
            iVar8 = FUN_1000ada1(*(uint *)(local_8 + -2),(uint)*local_c * (uint)*local_10,
                                 (uint *)(local_8 + -2));
            if (iVar8 != 0) {
              *local_8 = *local_8 + 1;
            }
            local_c = local_c + 1;
            local_10 = local_10 + -1;
            local_1c = (int *)((int)local_1c + -1);
          } while (local_1c != (int *)0x0);
        }
        local_8 = local_8 + 1;
        local_14 = local_14 + 1;
        param_2 = (int *)((int)param_2 + -1);
      } while (0 < (int)param_2);
      param_1 = (int *)((int)param_1 + 0xc002);
      if ((short)(ushort)param_1 < 1) {
LAB_1000bf98:
        param_1._0_2_ = (ushort)param_1 - 1;
        if ((short)(ushort)param_1 < 0) {
          iVar8 = -(int)(short)(ushort)param_1;
          param_1._0_2_ = (ushort)param_1 + (short)iVar8;
          do {
            if ((local_28 & 1) != 0) {
              local_18 = local_18 + 1;
            }
            FUN_1000ae4e((uint *)&local_28);
            iVar8 = iVar8 + -1;
          } while (iVar8 != 0);
          if (local_18 != 0) {
            local_28 = local_28 | 1;
          }
        }
      }
      else {
        do {
          if ((bStack_1d & 0x80) != 0) break;
          FUN_1000ae20((uint *)&local_28);
          param_1 = (int *)((int)param_1 + 0xffff);
        } while (0 < (short)(ushort)param_1);
        if ((short)(ushort)param_1 < 1) goto LAB_1000bf98;
      }
      if ((0x8000 < CONCAT11(uStack_27,local_28)) ||
         (sVar2 = CONCAT11(bStack_1d,uStack_1e), iVar3 = CONCAT22(local_20,uStack_22),
         iVar8 = CONCAT22(local_24,uStack_26),
         (CONCAT22(uStack_26,CONCAT11(uStack_27,local_28)) & 0x1ffff) == 0x18000)) {
        if (CONCAT22(local_24,uStack_26) == -1) {
          iVar8 = 0;
          if (CONCAT22(local_20,uStack_22) == -1) {
            if (CONCAT11(bStack_1d,uStack_1e) == -1) {
              param_1._0_2_ = (ushort)param_1 + 1;
              sVar2 = -0x8000;
              iVar3 = 0;
              iVar8 = 0;
            }
            else {
              sVar2 = CONCAT11(bStack_1d,uStack_1e) + 1;
              iVar3 = 0;
              iVar8 = 0;
            }
          }
          else {
            sVar2 = CONCAT11(bStack_1d,uStack_1e);
            iVar3 = CONCAT22(local_20,uStack_22) + 1;
          }
        }
        else {
          iVar8 = CONCAT22(local_24,uStack_26) + 1;
          sVar2 = CONCAT11(bStack_1d,uStack_1e);
          iVar3 = CONCAT22(local_20,uStack_22);
        }
      }
      local_24 = (short)((uint)iVar8 >> 0x10);
      uStack_26 = (undefined2)iVar8;
      local_20 = (undefined2)((uint)iVar3 >> 0x10);
      uStack_22 = (undefined2)iVar3;
      bStack_1d = (byte)((ushort)sVar2 >> 8);
      uStack_1e = (undefined1)sVar2;
      if (0x7ffe < (ushort)param_1) goto LAB_1000c041;
      uVar6 = (ushort)param_1 | uVar11;
      *(undefined2 *)piVar4 = uStack_26;
      *(uint *)((int)piVar4 + 2) = CONCAT22(uStack_22,local_24);
      *(uint *)((int)piVar4 + 6) = CONCAT13(bStack_1d,CONCAT12(uStack_1e,local_20));
    }
    *(ushort *)((int)piVar4 + 10) = uVar6;
  }
  else {
LAB_1000c041:
    piVar4[1] = 0;
    *piVar4 = 0;
    piVar4[2] = (-(uint)(uVar11 != 0) & 0x80000000) + 0x7fff8000;
  }
  return;
}


/* ==== FUNCTION FUN_1000c061 @ 1000c061 size=124 ==== */

void __cdecl FUN_1000c061(int *param_1,uint param_2,int param_3)

{
  uint uVar1;
  uint uVar2;
  int iVar3;
  int *piVar4;
  undefined2 local_10;
  undefined4 local_e;
  undefined2 uStack_a;
  int iStack_8;
  
  iVar3 = 0x1000f290;
  if (param_2 != 0) {
    if ((int)param_2 < 0) {
      param_2 = -param_2;
      iVar3 = 0x1000f3f0;
    }
    if (param_3 == 0) {
      *(undefined2 *)param_1 = 0;
    }
    while (param_2 != 0) {
      iVar3 = iVar3 + 0x54;
      uVar1 = (int)param_2 >> 3;
      uVar2 = param_2 & 7;
      param_2 = uVar1;
      if (uVar2 != 0) {
        piVar4 = (int *)(iVar3 + uVar2 * 0xc);
        if (0x7fff < *(ushort *)(iVar3 + uVar2 * 0xc)) {
          local_10 = (undefined2)*piVar4;
          local_e._0_2_ = (undefined2)((uint)*piVar4 >> 0x10);
          local_e._2_2_ = (undefined2)piVar4[1];
          uStack_a = (undefined2)((uint)piVar4[1] >> 0x10);
          iStack_8 = piVar4[2];
          local_e = CONCAT22(local_e._2_2_,(undefined2)local_e) + -1;
          piVar4 = (int *)&local_10;
        }
        FUN_1000be41(param_1,piVar4);
      }
    }
  }
  return;
}


/* ==== FUNCTION FUN_1000c0dd @ 1000c0dd size=86 ==== */

undefined4 __cdecl FUN_1000c0dd(int *param_1)

{
  int iVar1;
  undefined4 uVar2;
  
  uVar2 = 0xffffffff;
  if ((param_1[3] & 0x40U) == 0) {
    if ((param_1[3] & 0x83U) != 0) {
      uVar2 = FUN_1000bab9(param_1);
      FUN_1000c23d(param_1);
      iVar1 = FUN_1000c18a(param_1[4]);
      if (iVar1 < 0) {
        uVar2 = 0xffffffff;
      }
      else if ((LPVOID)param_1[7] != (LPVOID)0x0) {
        FUN_10005e2a((LPVOID)param_1[7]);
        param_1[7] = 0;
      }
    }
  }
  else {
    uVar2 = 0xffffffff;
  }
  param_1[3] = 0;
  return uVar2;
}


/* ==== FUNCTION FUN_1000c133 @ 1000c133 size=87 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __cdecl FUN_1000c133(uint param_1)

{
  HANDLE hFile;
  BOOL BVar1;
  DWORD DVar2;
  
  DVar2 = _DAT_1000f650;
  if ((param_1 < DAT_10010ba0) &&
     ((*(byte *)((&DAT_10010aa0)[(int)param_1 >> 5] + 4 + (param_1 & 0x1f) * 8) & 1) != 0)) {
    hFile = (HANDLE)FUN_1000b8cf(param_1);
    BVar1 = FlushFileBuffers(hFile);
    if (BVar1 == 0) {
      DVar2 = GetLastError();
    }
    else {
      DVar2 = 0;
    }
    if (DVar2 == 0) {
      return 0;
    }
  }
  _DAT_1000f650 = DVar2;
  _DAT_1000f64c = 9;
  return 0xffffffff;
}


/* ==== FUNCTION FUN_1000c18a @ 1000c18a size=179 ==== */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __cdecl FUN_1000c18a(uint param_1)

{
  int iVar1;
  int iVar2;
  HANDLE hObject;
  BOOL BVar3;
  DWORD DVar4;
  int iVar5;
  
  if (DAT_10010ba0 <= param_1) {
    _DAT_1000f650 = 0;
    _DAT_1000f64c = 9;
    return 0xffffffff;
  }
  iVar5 = (param_1 & 0x1f) * 8;
  if ((*(byte *)((&DAT_10010aa0)[(int)param_1 >> 5] + 4 + iVar5) & 1) == 0) {
    _DAT_1000f64c = 9;
    _DAT_1000f650 = 0;
    return 0xffffffff;
  }
  iVar1 = FUN_1000b8cf(param_1);
  if (iVar1 != -1) {
    if ((param_1 == 1) || (param_1 == 2)) {
      iVar1 = FUN_1000b8cf(2);
      iVar2 = FUN_1000b8cf(1);
      if (iVar2 == iVar1) goto LAB_1000c203;
    }
    hObject = (HANDLE)FUN_1000b8cf(param_1);
    BVar3 = CloseHandle(hObject);
    if (BVar3 == 0) {
      DVar4 = GetLastError();
      goto LAB_1000c205;
    }
  }
LAB_1000c203:
  DVar4 = 0;
LAB_1000c205:
  FUN_1000b855(param_1);
  *(undefined1 *)((&DAT_10010aa0)[(int)param_1 >> 5] + 4 + iVar5) = 0;
  if (DVar4 == 0) {
    return 0;
  }
  FUN_1000b6e2(DVar4);
  return 0xffffffff;
}


/* ==== FUNCTION FUN_1000c23d @ 1000c23d size=43 ==== */

void __cdecl FUN_1000c23d(undefined4 *param_1)

{
  if (((param_1[3] & 0x83) != 0) && ((param_1[3] & 8) != 0)) {
    FUN_10005e2a((LPVOID)param_1[2]);
    *(ushort *)(param_1 + 3) = *(ushort *)(param_1 + 3) & 0xfbf7;
    *param_1 = 0;
    param_1[2] = 0;
    param_1[1] = 0;
  }
  return;
}


/* ==== FUNCTION RtlUnwind @ 1000c2a0 size=6 ==== */

void RtlUnwind(PVOID TargetFrame,PVOID TargetIp,PEXCEPTION_RECORD ExceptionRecord,PVOID ReturnValue)

{
                    /* WARNING: Could not recover jumptable at 0x1000c2a0. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  RtlUnwind(TargetFrame,TargetIp,ExceptionRecord,ReturnValue);
  return;
}


/* ==== FUNCTION FUN_1000c3ae @ 1000c3ae size=45 ==== */

char * __cdecl FUN_1000c3ae(uint param_1,char *param_2,uint param_3)

{
  int iVar1;
  
  if ((param_3 == 10) && ((int)param_1 < 0)) {
    iVar1 = 1;
    param_3 = 10;
  }
  else {
    iVar1 = 0;
  }
  FUN_1000c3db(param_1,param_2,param_3,iVar1);
  return param_2;
}


/* ==== FUNCTION FUN_1000c3db @ 1000c3db size=92 ==== */

void __cdecl FUN_1000c3db(uint param_1,char *param_2,uint param_3,int param_4)

{
  ulonglong uVar1;
  char *pcVar2;
  char *pcVar3;
  char cVar4;
  
  pcVar2 = param_2;
  if (param_4 != 0) {
    *param_2 = '-';
    param_2 = param_2 + 1;
    param_1 = -param_1;
    pcVar2 = param_2;
  }
  do {
    pcVar3 = pcVar2;
    uVar1 = (ulonglong)param_1;
    param_1 = param_1 / param_3;
    cVar4 = (char)(uVar1 % (ulonglong)param_3);
    if ((uint)(uVar1 % (ulonglong)param_3) < 10) {
      cVar4 = cVar4 + '0';
    }
    else {
      cVar4 = cVar4 + 'W';
    }
    *pcVar3 = cVar4;
    pcVar2 = pcVar3 + 1;
  } while (param_1 != 0);
  pcVar3[1] = '\0';
  do {
    cVar4 = *pcVar3;
    *pcVar3 = *param_2;
    *param_2 = cVar4;
    pcVar3 = pcVar3 + -1;
    param_2 = param_2 + 1;
  } while (param_2 < pcVar3);
  return;
}


/* ==== FUNCTION FUN_1000c437 @ 1000c437 size=42 ==== */

char * __cdecl FUN_1000c437(uint param_1,char *param_2,uint param_3)

{
  int iVar1;
  
  iVar1 = 0;
  if ((param_3 == 10) && ((int)param_1 < 0)) {
    iVar1 = 1;
  }
  FUN_1000c3db(param_1,param_2,param_3,iVar1);
  return param_2;
}


/* ==== FUNCTION FUN_1000c47c @ 1000c47c size=49 ==== */

char * __cdecl FUN_1000c47c(int param_1,int param_2,char *param_3,uint param_4)

{
  int iVar1;
  
  iVar1 = 0;
  if (((param_4 == 10) && (param_2 < 1)) && (param_2 < 0)) {
    iVar1 = 1;
  }
  FUN_1000c4ad(param_1,param_2,param_3,param_4,iVar1);
  return param_3;
}


/* ==== FUNCTION FUN_1000c4ad @ 1000c4ad size=134 ==== */

void FUN_1000c4ad(int param_1,int param_2,char *param_3,uint param_4,int param_5)

{
  char *pcVar1;
  char cVar2;
  char *pcVar3;
  bool bVar4;
  undefined8 uVar5;
  longlong lVar6;
  uint uVar7;
  
  if (param_5 != 0) {
    *param_3 = '-';
    param_3 = param_3 + 1;
    bVar4 = param_1 != 0;
    param_1 = -param_1;
    param_2 = -(param_2 + (uint)bVar4);
  }
  lVar6 = CONCAT44(param_2,param_1);
  pcVar1 = param_3;
  do {
    pcVar3 = pcVar1;
    uVar7 = (uint)((ulonglong)lVar6 >> 0x20);
    uVar5 = __aullrem((uint)lVar6,uVar7,param_4,0);
    lVar6 = __aulldiv((uint)lVar6,uVar7,param_4,0);
    if ((uint)uVar5 < 10) {
      cVar2 = (char)uVar5 + '0';
    }
    else {
      cVar2 = (char)uVar5 + 'W';
    }
    *pcVar3 = cVar2;
    pcVar1 = pcVar3 + 1;
  } while (lVar6 != 0);
  pcVar3[1] = '\0';
  do {
    cVar2 = *pcVar3;
    *pcVar3 = *param_3;
    *param_3 = cVar2;
    pcVar3 = pcVar3 + -1;
    param_3 = param_3 + 1;
  } while (param_3 < pcVar3);
  return;
}


/* ==== FUNCTION FUN_1000c533 @ 1000c533 size=27 ==== */

char * __cdecl FUN_1000c533(int param_1,int param_2,char *param_3,uint param_4)

{
  FUN_1000c4ad(param_1,param_2,param_3,param_4,0);
  return param_3;
}


/* ==== FUNCTION Unwind@1000c550 @ 1000c550 size=11 ==== */

void Unwind_1000c550(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + 8));
  return;
}


/* ==== FUNCTION Unwind@1000c570 @ 1000c570 size=11 ==== */

void Unwind_1000c570(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + -0x14));
  return;
}


/* ==== FUNCTION Unwind@1000c590 @ 1000c590 size=8 ==== */

void Unwind_1000c590(void)

{
  int unaff_EBP;
  
  FUN_100026b0(*(undefined4 **)(unaff_EBP + -0x10));
  return;
}


/* ==== FUNCTION Unwind@1000c598 @ 1000c598 size=11 ==== */

void Unwind_1000c598(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + 8));
  return;
}


/* ==== FUNCTION Unwind@1000c5b0 @ 1000c5b0 size=8 ==== */

void Unwind_1000c5b0(void)

{
  int unaff_EBP;
  
  FUN_100026b0(*(undefined4 **)(unaff_EBP + -0x14));
  return;
}


/* ==== FUNCTION Unwind@1000c5d0 @ 1000c5d0 size=11 ==== */

void Unwind_1000c5d0(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + -0x10));
  return;
}


/* ==== FUNCTION Unwind@1000c5f0 @ 1000c5f0 size=8 ==== */

void Unwind_1000c5f0(void)

{
  int unaff_EBP;
  
  FUN_100026b0(*(undefined4 **)(unaff_EBP + -0x10));
  return;
}


/* ==== FUNCTION Unwind@1000c5f8 @ 1000c5f8 size=11 ==== */

void Unwind_1000c5f8(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + 8));
  return;
}


/* ==== FUNCTION Unwind@1000c603 @ 1000c603 size=11 ==== */

void Unwind_1000c603(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + 8));
  return;
}


/* ==== FUNCTION Unwind@1000c620 @ 1000c620 size=8 ==== */

void Unwind_1000c620(void)

{
  int unaff_EBP;
  
  FUN_100026b0(*(undefined4 **)(unaff_EBP + -0x14));
  return;
}


/* ==== FUNCTION Unwind@1000c640 @ 1000c640 size=11 ==== */

void Unwind_1000c640(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + -0x18));
  return;
}


/* ==== FUNCTION Unwind@1000c64b @ 1000c64b size=11 ==== */

void Unwind_1000c64b(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + -0x18));
  return;
}


/* ==== FUNCTION Unwind@1000c656 @ 1000c656 size=11 ==== */

void Unwind_1000c656(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + -0x18));
  return;
}


/* ==== FUNCTION Unwind@1000c670 @ 1000c670 size=11 ==== */

void Unwind_1000c670(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + -0x10));
  return;
}


/* ==== FUNCTION Unwind@1000c67b @ 1000c67b size=11 ==== */

void Unwind_1000c67b(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + -0x10));
  return;
}


/* ==== FUNCTION Unwind@1000c686 @ 1000c686 size=11 ==== */

void Unwind_1000c686(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + -0x10));
  return;
}


/* ==== FUNCTION Unwind@1000c6a0 @ 1000c6a0 size=11 ==== */

void Unwind_1000c6a0(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + 8));
  return;
}


/* ==== FUNCTION Unwind@1000c6ab @ 1000c6ab size=11 ==== */

void Unwind_1000c6ab(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + 8));
  return;
}


/* ==== FUNCTION Unwind@1000c6c0 @ 1000c6c0 size=11 ==== */

void Unwind_1000c6c0(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + -0x10));
  return;
}


/* ==== FUNCTION Unwind@1000c6e0 @ 1000c6e0 size=8 ==== */

void Unwind_1000c6e0(void)

{
  int unaff_EBP;
  
  FUN_100026b0(*(undefined4 **)(unaff_EBP + -0x10));
  return;
}


/* ==== FUNCTION Unwind@1000c700 @ 1000c700 size=8 ==== */

void Unwind_1000c700(void)

{
  int unaff_EBP;
  
  FUN_100026b0(*(undefined4 **)(unaff_EBP + -0x10));
  return;
}


/* ==== FUNCTION Unwind@1000c720 @ 1000c720 size=11 ==== */

void Unwind_1000c720(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + 8));
  return;
}


/* ==== FUNCTION Unwind@1000c740 @ 1000c740 size=11 ==== */

void Unwind_1000c740(void)

{
  int unaff_EBP;
  
  FUN_10005197(*(LPVOID *)(unaff_EBP + 8));
  return;
}


