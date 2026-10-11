# Moeboid.gam to ZapSpot.exe interface map (workstream B)

Status: complete for all 423 computed calls in game code and CRT. Companion table: `analysis/interface.tsv` (one row per engine method that the game calls; 54 rows; tab separated).

Conventions in this document:
- `Z:0x...` is an address in `extracted/ZapSpot.exe` (image base 0x400000). `G:0x...` is an address in `extracted/Moeboid.gam` (image base 0x10000000).
- "verified" means read in the disassembly or the decompiled C at the given address. "inferred" gives the reason. "unknown" means not determined.
- Names of interfaces and methods (`IFactory`, `SetLoc`, ...) are names given by this analysis. The binaries have no RTTI. Engine class names in quotes come from engine error strings (`analysis/decomp/ZapSpot.exe/strings.tsv`).
- Call-site lists per method are in `interface.tsv`, column `game_call_sites`.

## 1. Summary

| Item | Value | Status |
|---|---|---|
| Interfaces that the game uses | 13 (ctx itself plus 12) | verified |
| Vtable slots in these 13 engine vtables | 144 | verified (memory dump of each vtable) |
| (interface, offset) pairs called by the game | 54 | verified (295 call sites) |
| Distinct engine behaviours behind the 54 pairs | 46 (45 methods plus one shared `Release`) | verified |
| Engine-to-game entry points | 2 exports plus 9 callbacks | verified |
| Game-own vtables | 4 one-slot vtables (screen destructors), 2 call sites | verified |
| Calling convention of every interface method | `__thiscall`: ECX = wrapper object, stack arguments right to left, callee pops 4 x argc (`ret 4*argc`), result in EAX | verified for all 54 pairs (engine `ret N` equals 4 x pushes at every game call site; workstream J `callsites.tsv` argument counts agree at all 295 sites) |
| Floating-point values across the interface | none; all arguments are 32-bit integers or pointers | verified (game code has no x87 store into the outgoing argument area; `FSTP [ESP]` occurs only in the CRT, G:0x10005b29 and later; coordinates go through `__ftol` first, e.g. G:0x100011a0) |
| Callback convention | `int __cdecl cb(int* e)`, caller pops; e[0] = userdata | verified Z:0x427b10, Z:0x41355a |
| Game update rate | timer callbacks every 20 ms or more of game-clock time (`IFactory::CreateTimer(..., 0x14, ...)`), elapsed time is passed to the game | verified G:0x10002c30; effective rate depends on GetTickCount granularity (see timing.md, workstream C) |
| Random numbers | engine MSVC `rand()` through ctx+0x08 (seed `timeGetTime()`), plus a second game-local MSVC `rand()` with seed 1 | verified |

## 2. Engine side of the load

### 2.1 Load sequence (verified)

The applet manager object (engine global `DAT_0045cfc8`, created by Z:0x424250, vtable Z:0x42eeac) does the load.

| Step | Address | What happens |
|---|---|---|
| 1 | Z:0x4243b0 (vtable slot +0x04) | Enumerates/reads a `.gam`: `LoadLibraryA`, then `LoadStringA` ids 3 (version "00.01.01.08"), 4 (name "Moeboid"), 5 (owner id "{2BFDD7F8-0EC4-4E7C-9FF4-3B2F8DC1D0F2}"), 6 (icon "img-shell_icon-80x60.gif"), 7 ("Action"), 8 ("Sweat"). Strings: `assets/Moeboid.gam/decoded/strings.txt`. |
| 2 | Z:0x424620 (vtable slot +0x0c, "Start") | `SetCurrentDirectoryA(temp folder)`, reads the strings again (slot +0x04), `LoadLibraryA(path)` (Z:0x42467e), stores HMODULE at manager+0x29c, `GetProcAddress("Shell_StartApplet")` (Z:0x424690). Error "Error - file specified in call to Start (%s) is NOT a game DLL!" if missing. |
| 3 | Z:0x4246c2..0x4247b4 | Builds ctx (section 2.2). Stores ctx at manager+0x2a0. |
| 4 | Z:0x4247b7..0x424874 | Copies path (manager+5), name (+0x199), owner id (+0x105), version (+0x185). Sets the main window title to app name + name. Reads the system time into `DAT_0045e848` (timer manager slot +0x0c). Logs "GameStarted". |
| 5 | Z:0x424882 | Sets manager+4 = 1 (applet running). Calls `Shell_StartApplet(ctx)`: `PUSH ctx; CALL [EBP+0xc]; ADD ESP,4` (cdecl, 1 argument). Return value is not used. |
| Stop | Z:0x4248a0 (vtable slot +0x10) | `GetProcAddress("Shell_StopApplet")`, calls it with ctx (`PUSH ctx; CALL EAX`, frame restore pops), deletes the ctx[2], ctx[3], ctx[5], ctx[6] wrappers and ctx with their scalar deleting destructors (vtable slot +0, argument 1), `FreeLibrary`, logs "GameStopped2" with the play time, clears path and owner id, manager+4 = 0. ctx[4] (IFactory) is engine-global and is not deleted. |

Game side (verified): `Shell_StartApplet` G:0x100025f0 allocates the game object (0xf4 bytes), runs its constructor G:0x100016a0, stores it in `DAT_1000f5d8`, calls `ISystem::SetCaption("Moeboid")` (ctx[5]+0x08), returns with plain `ret` (cdecl). `Shell_StopApplet` G:0x10002630 ignores its argument, runs the game object destructor body G:0x10001b50, frees the object, returns 0 with plain `ret` (cdecl).

New Game (shell button, Z:0x41c910) calls the applet manager Stop and then Start: the game DLL is unloaded and loaded again (verified call sequence). Whether the DLL image is really unmapped depends on other module references (the engine `CFile` object also calls `LoadLibraryA` on the game path, Z:0x427fc3, and frees it in its close function Z:0x428130, `FreeLibrary` at Z:0x42814b). If it is unmapped, all game `.data` (including the game-local RNG state) is reset to the file values: unknown, must be checked in a reference run (workstream I).

### 2.2 ctx layout (verified, Z:0x4246c2..0x4247b4)

ctx is a 0x1c-byte heap object.

| Offset | Type | Engine object | Wrapper vtable | Game global | Notes |
|---|---|---|---|---|---|
| +0x00 | vtable | ctx own vtable | Z:0x42ef20 (`IShell`) | `DAT_1000f5b4` holds ctx | slots below |
| +0x04 | (not written) | none | none | not read | heap garbage; the game never reads it |
| +0x08 | `ISurface*` ctx[2] | game surface = shell surface field `shell+0x2c8` (shell = `DAT_0045cfcc`, object of Z:0x41acb0) | Z:0x42eb34 | `DAT_1000f5bc` | 8-byte wrapper, no AddRef. The shell shows it during play. Protected: the shell calls `CSurface::Protect(0, shell)` on it (Z:0x41d937, Z:0x41e1b8), so SetLoc/SetVisible by the game with key 0 is rejected. |
| +0x0c | `ISurface*` ctx[3] | overlay page surface `shell+0x2cc` | Z:0x42eb34 | `DAT_1000f5c0` | the shell shows it for its own pages (pause, help). The game draws Help.zml into its image. |
| +0x10 | `IFactory*` ctx[4] | engine global `DAT_0045cfd4` (Z:0x415020, inner vtable Z:0x42eacc) | Z:0x42eae0 | `DAT_1000f5b0` | shared engine object |
| +0x14 | `ISystem*` ctx[5] | 0x10-byte object, ctor Z:0x415df0: [1] = shell `DAT_0045cfcc`, [2] = event source (shell, 0x11), [3] = event source (shell, 0x10) | Z:0x42ec3c | `DAT_1000f5c8` | event sources are created with `IFactory`+0x3c |
| +0x18 | `ISettings*` ctx[6] | 8-byte wrapper; methods use engine global `DAT_0045cfa8` (settings store, vtable Z:0x42f008) | Z:0x42ef04 | `DAT_1000f5c4` | wrapper+4 not written, not used |

ctx own vtable Z:0x42ef20 (4 slots):

| Slot | Implementation | Meaning | Used by game |
|---|---|---|---|
| +0x00 | Z:0x415460 | wrapper scalar deleting destructor (`this`, flags) | no (engine calls it at Stop) |
| +0x04 | Z:0x414ff0 | common `Release`; on ctx it would read the garbage at ctx+4 | no |
| +0x08 | Z:0x4160b0 = `JMP Z:0x40e396` | `Random()`: MSVC CRT `rand()` (section 7.3) | yes, 21 sites |
| +0x0c | Z:0x4160c0 | tail jump to app object (`DAT_0045cf9c`) vtable +0x64 | no; meaning unknown |

## 3. Object model (verified)

- Every object that the game sees is an 8-byte wrapper: `[0]` = wrapper vtable, `[1]` = inner engine object. A wrapper method forwards to the inner object (`MOV ECX,[ECX+4]`, e.g. Z:0x4150d9).
- When a method takes another interface pointer as argument, the wrapper replaces it by the inner pointer `[arg+4]` ("unwrapped" in the tables). Example Z:0x41511d.
- Every factory method and every getter that returns an interface allocates a new wrapper and adds one external reference to the inner object (inner vtable +0x04, Z:0x414f70). Example Z:0x415410, Z:0x417860.
- Engine objects have two reference counts: external at +4 (inner vtable +0x04 AddRef, +0x0c Release, Z:0x414f90) and internal at +8 (+0x08, +0x10, Z:0x414fc0). An object is freed when both are 0.
- `Release` (wrapper slot +0x04, Z:0x414ff0, the same function in all 13 vtables): calls inner Release (+0x0c), deletes the wrapper, returns the remaining external count. Each wrapper must be released once. The game never releases ctx[2], ctx[3], ctx[5], ctx[6] (correct: the engine deletes them).
- Wrapper slot +0x00 (Z:0x415460, Z:0x415e90 for ISystem) is the scalar deleting destructor of the wrapper only. The game never calls it on engine objects.
- A surface that is attached to a parent holds an internal reference; the game detaches surfaces before it releases them (e.g. G:0x10001340).

### 3.1 Interfaces

| Interface | Wrapper vtable (slots) | Origin | Inner engine object | Game uses |
|---|---|---|---|---|
| IShell (ctx) | Z:0x42ef20 (4) | Shell_StartApplet argument | ctx itself | +0x08 |
| IFactory | Z:0x42eae0 (19) | ctx[4] | factory, inner vtable Z:0x42eacc | 10 methods |
| ISystem | Z:0x42ec3c (10) | ctx[5] | shell `DAT_0045cfcc`, input subsystem `DAT_0045cfa4` | 6 methods |
| ISettings | Z:0x42ef04 (7) | ctx[6] | settings store `DAT_0045cfa8` | 2 methods |
| ISurface | Z:0x42eb34 (22) | ctx[2], ctx[3], IFactory +0x08/+0x0c/+0x10 | "CSurface", vtable Z:0x42eab8, 0x58 bytes, ctors Z:0x414190/0x414330/0x414470 | 11 slots incl. Release |
| IButton | Z:0x42ed10 (22, same functions as ISurface) | IFactory +0x30 | button (CSurface subclass), vtable Z:0x42ee58, 0x74 bytes, ctor Z:0x419730 | Release only |
| IAnim | Z:0x42eb8c (9) | ISurface +0x3c, IFactory +0x14 | animation player, vtable Z:0x42ec78, 0x30 bytes, ctor Z:0x4173f0 (class name unknown) | Release, +0x10 |
| IImageSeq | Z:0x42ec10 (7) | IAnim +0x10, IFactory +0x18/+0x1c | "CImageSeq", vtable Z:0x42ec64, 0x38 bytes, ctors Z:0x416c30 (from image), Z:0x416d00 (from GIF) | Release, +0x10 |
| IImage | Z:0x42ebb0 (24) | ISurface +0x40/+0x44, IAnim +0x08, IFactory +0x20, IImageSeq +0x10/+0x14 | "CImage", vtable Z:0x42eaa4, 0x38 bytes, ctors Z:0x4138f0/0x413a00; owns a render target (GDI vtable Z:0x42f188, DirectX vtable see rendering.md) | 12 slots incl. Release |
| IFont | Z:0x42ec2c (4) | IFactory +0x28, IImage +0x4c | font, vtable Z:0x42f0dc, 0x30 bytes, ctor Z:0x427c10, cache Z:0x426070 ("CSubsystem_Font_Win32") | Release, +0x0c |
| ITimer | Z:0x42ed68 (8) | IFactory +0x34 | timer, vtable Z:0x42ea40, 0x2c bytes, ctor Z:0x413440 | Release, +0x08 |
| ISound | Z:0x42ed90 (4) | IFactory +0x40 | sound, vtable Z:0x42e860, 0x18 bytes, ctor Z:0x40c440 (DirectSound subsystem `DAT_0045cfc4`) | Release, +0x08 |
| IListener | Z:0x42edac (4) | IFactory +0x44 | event listener, vtable Z:0x42ef88, 0x1c bytes, ctor Z:0x427b30; Release unregisters it (dtor Z:0x4259b0 calls Z:0x427810) | Release only |

Note on names: the string "CAnim::RecalcTimes" (Z:0x434abc) is in Z:0x4171b0, which operates on the CImageSeq object. The animation player class has no name string. This analysis calls it IAnim.

### 3.2 Methods called by the game

argc excludes `this` (ECX). Pop = callee pop bytes = 4 x argc. `uint8`/`int8` means a byte value that the caller pushes as a dword. All results are in EAX. Call-site lists: `interface.tsv`.

IShell (ctx), vtable Z:0x42ef20

| Off | Method | argc/pop | Arguments | Result | Impl | Sites |
|---|---|---|---|---|---|---|
| +0x08 | Random | 0/0 | none | int 0..0x7fff | Z:0x40e396 | 21 |

IFactory, vtable Z:0x42eae0

| Off | Method | argc/pop | Arguments | Result | Wrapper; inner | Sites |
|---|---|---|---|---|---|---|
| +0x08 | CreateSurfaceFromAnim | 2/8 | IAnim* (unwrapped), uint8 flags | new ISurface* | Z:0x415110; Z:0x417980, ctor Z:0x414470 | 4 |
| +0x0c | CreateSurfaceFromFile | 2/8 | const char* gif name, uint8 flags | new ISurface* | Z:0x4150f0; Z:0x4178f0, ctor Z:0x414330, GIF loader Z:0x418d90 | 9 |
| +0x10 | CreateSurface | 3/12 | int w, int h, uint8 flags | new ISurface* (blank image) | Z:0x4150d0; Z:0x417860, ctor Z:0x414190 | 1 |
| +0x14 | CreateAnim | 1/4 | IImageSeq* (unwrapped) | new IAnim* | Z:0x415130; Z:0x417a10 | 2 |
| +0x20 | CreateImage | 3/12 | int w, int h, uint8 flags | new IImage* (font Arial 18, text colour white) | Z:0x415190; Z:0x417b90, ctor Z:0x4138f0 | 1 |
| +0x28 | CreateFont | 3/12 | const char* face, int pixel height, uint style (bit0 bold 700, bit1 italic, bit2 underline, bit3 strikeout) | new IFont* (cached by face, size, style) | Z:0x4151d0; Z:0x417c80, Z:0x426070, ctor Z:0x427c10 | 5 |
| +0x30 | CreateButton | 10/40 | ISurface* parent (unwrapped), void* userdata, int x, int y, int w, int h, IImage* faces (unwrapped), int face index, int id, callback | new IButton* | Z:0x415230; Z:0x417d90, ctor Z:0x419730 | 1 |
| +0x34 | CreateTimer | 3/12 | void* userdata, uint interval ms, callback | new ITimer* (stopped) | Z:0x415270; Z:0x417e40, ctor Z:0x413440 | 3 |
| +0x40 | CreateSound | 2/8 | const char* wav name, uint8 flags (bit0 stored at sound+0x10, meaning unknown) | new ISound* (inner NULL if sound is off) | Z:0x415300; Z:0x417f30, Z:0x409030, ctor Z:0x40c440 | 11 |
| +0x44 | CreateListener | 4/16 | event source (ISurface* or ISystem*, unwrapped), int event type, void* userdata, callback | new IListener* | Z:0x4152d0; Z:0x417fe0, event manager slot +0x08 Z:0x424c70 | 3 |

Flags of +0x08/+0x0c/+0x10: bit1 (2) adds mouse enter/leave listeners and a cursor to the surface (test at Z:0x41428c in ctor Z:0x414190); bit0 is passed to the renderer as the third argument of `CreateSurface` (meaning: see rendering.md). The game passes 0 to +0x08/+0x0c and 1 to +0x10/+0x20.

Unused IFactory slots: +0x18 CreateImageSeqFromFile(gif name) Z:0x415170 (ctor Z:0x416d00), +0x1c CreateImageSeqFromImage(IImage*) Z:0x415150 (ctor Z:0x416c30), +0x24 Z:0x4151b0 (cursor subsystem object, vtable Z:0x42ec8c), +0x2c Z:0x4151f0 (10 arguments, object vtable Z:0x42ecb8), +0x38 Z:0x415290 (object vtable Z:0x42ed88), +0x3c CreateEventSource(source, type) Z:0x4152b0, +0x48 CreateEditBox Z:0x415320 (Win32 EDIT control, 8 arguments).

ISystem, vtable Z:0x42ec3c

| Off | Method | argc/pop | Arguments | Result | Impl | Sites |
|---|---|---|---|---|---|---|
| +0x08 | SetCaption | 1/4 | const char* text | 0 | Z:0x415f20: copy to shell+0x88, draw as ZML on the shell title surface (Z:0x41b7f0) | 1 |
| +0x0c | SetGameInProgress (inferred name) | 1/4 | int flag | 0 | Z:0x415f50: shell+0x37c = flag. Shell checks it before New Game and similar actions and then pauses and asks (Z:0x41b4ed..0x41b553) | 2 (1 at game start G:0x10002c9d, 0 on title screen G:0x100042fb) |
| +0x10 | SetShellButtons | 1/4 | uint mask | 0 | Z:0x415f70: shell+0x378 = mask, rebuild (Z:0x41b9b0). Bits tested at Z:0x41ba7f..0x41c057: 0x01 string 10011 "New Game", 0x02 string 10013, 0x04 string 10015, 0x10 string 10014 "How To Play", 0x20 string 10010 "Mail This" | 1 (0x33) |
| +0x14 | MessageBox | 3/12 | const char* title, const char* text, uint flags | unknown | Z:0x415f90, app object vtable +0x40 | 1 (flags 0x101) |
| +0x18 | InputBox | 6/24 | const char* title, const char* prompt, const char* default, char* out, int max length, int flag | unknown | Z:0x415fb0, app object vtable +0x44 | 2 (max 0x10, flag 1) |
| +0x20 | GetKeyState | 1/4 | int8 key index (`MOVSX`) | GetKeyState result; game tests bit 0x80 | Z:0x416000, input subsystem slot +0x0c Z:0x426bf0 | 8 |

Key index table of +0x20 (Z:0x426bf0, verified): 0 VK_BACK, 1 VK_DELETE, 2 VK_TAB, 3 VK_RETURN, 5 VK_CONTROL, 6 VK_LEFT, 7 VK_RIGHT, 8 VK_UP, 9 VK_DOWN, 10 VK_HOME, 11 VK_END, 12 VK_SHIFT, any other value is passed to `GetKeyState` unchanged (including 4 = VK_MBUTTON). The game polls 6, 7, 8, 9 only.

Unused: +0x1c Z:0x415fe0 (app object vtable +0x0c), +0x24 (same function as +0x20).

ISettings, vtable Z:0x42ef04

| Off | Method | argc/pop | Arguments | Result | Impl | Sites |
|---|---|---|---|---|---|---|
| +0x10 | SetGameValue | 2/8 | const char* name, const char* value | 0 | Z:0x416060, store slot +0x08 Z:0x429710 | 15 |
| +0x14 | GetGameValue | 2/8 | const char* name, char* out (no size) | 0 found, 0x19 not found | Z:0x416080, store slot +0x0c Z:0x4294f0 | 7 |

Values are strings in a per-game property list ("ZLSProp" elements with name/value). The list is selected by owner id = game string 5 "{2BFDD7F8-0EC4-4E7C-9FF4-3B2F8DC1D0F2}" (store slot +0x24 Z:0x409950 reads it through applet manager slot +0x20 Z:0x424a60 = manager+0x105). Where the store is saved: see shell.md (workstream G). Unused: +0x08/+0x0c (global properties, Z:0x429200/Z:0x428fe0), +0x18 (app object vtable +0x48).

ISurface, vtable Z:0x42eb34 (inner "CSurface")

| Off | Method | argc/pop | Arguments | Result | Inner | Sites |
|---|---|---|---|---|---|---|
| +0x04 | Release | 0/0 | none | remaining count | Z:0x414ff0 | 18 |
| +0x08 | SetLoc | 3/12 | int x, int y (relative to parent), int key | 0; 0xb if key differs from surface+0x38 | Z:0x4146a0 "CSurface::SetLoc" | 12 |
| +0x0c | GetLoc | 2/8 | int* x, int* y | 0 | Z:0x414700 | 1 |
| +0x10 | SetVisible | 2/8 | uint8 visible, int key | 0; 0xb on key error | Z:0x414720 "CSurface::SetVisible" | 2 |
| +0x18 | AttachSurface | 1/4 | ISurface* child (unwrapped) | 0 | Z:0x414780: append (top of z-order), set parent | 7 |
| +0x1c | DetachSurface | 1/4 | ISurface* child (unwrapped) | 0; 4 if not a child | Z:0x4147f0 "CSurface::DetachSurface" | 17 |
| +0x2c | PlayAnim | 0/0 | none | 0 | Z:0x414b60 to Z:0x4176f0: frame for t=0, start 50 ms frame timer | 6 |
| +0x34 | StopAnim | 0/0 | none | 0 | Z:0x414bb0 to Z:0x417740 to Z:0x4135d0 | 1 |
| +0x3c | GetAnim | 1/4 | IAnim** out | 0 | Z:0x414c20 (surface+0x34) | 7 |
| +0x44 | GetImage | 1/4 | IImage** out | 0 | Z:0x414c40 (current frame image) | 5 |
| +0x48 | GetSize | 2/8 | int* w, int* h | 0 | Z:0x414c70 | 2 |

IButton, vtable Z:0x42ed10: the game calls +0x04 Release only (4 sites).

IAnim, vtable Z:0x42eb8c: +0x04 Release (9 sites); +0x10 GetImageSeq(IImageSeq** out), 1/4, result 0, Z:0x415720 / Z:0x40c1f0 (4 sites).

IImageSeq, vtable Z:0x42ec10: +0x04 Release (3 sites); +0x10 GetImage(int index, IImage** out), 2/8, result 0, Z:0x4157f0 / Z:0x417060 "CImageSeq::GetImage" (2 sites, index 1 and 2). The inner check is `count < index`, so index == count passes (off by one). On an inner error the wrapper dereferences NULL (Z:0x415829). The game indexes are valid (background GIF has 3 frames, baddie GIFs 3 frames: `assets/Moeboid.gam/decoded/gifs.json`).

IImage, vtable Z:0x42ebb0 (inner "CImage"; render target slots are for GDI vtable Z:0x42f188)

| Off | Method | argc/pop | Arguments | Result | Inner, render target | Sites |
|---|---|---|---|---|---|---|
| +0x04 | Release | 0/0 | none | count | Z:0x414ff0 | 9 |
| +0x0c | DrawRect (outline) | 4/16 | int x1, y1, x2, y2 | int | Z:0x413bd0, rt+0x08 (4 lines, Z:0x40bc00) | 6 |
| +0x10 | FillRect | 4/16 | int x1, y1, x2, y2 | int | Z:0x413c00, rt+0x0c (Z:0x429c50) | 8 |
| +0x18 | DrawText | 4/16 | const char* text, int len, int x, int y | int | Z:0x413c30, rt+0x3c (Z:0x42a250 `ExtTextOutA`, `ETO_CLIPPED` 0,0,800,600, transparent by default) | 1 |
| +0x1c | SetColor | 3/12 | uint8 r, g, b | int | Z:0x413d10, rt+0x14 "SetCurColor" | 9 |
| +0x24 | SetTextColor | 3/12 | uint8 r, g, b | int | Z:0x413d50, rt+0x1c | 4 |
| +0x34 | ClearToColor | 3/12 | uint8 r, g, b | int | Z:0x413dd0, rt+0x2c "ClearToColor" | 3 |
| +0x40 | DrawImage | 3/12 | IImage* src (unwrapped), int x, int y | int | Z:0x413f00, rt+0x38 (colour-key blit) | 4 |
| +0x48 | SetFont | 1/4 | IFont* (unwrapped) | 0 | Z:0x413f80 | 5 |
| +0x4c | GetFont | 1/4 | IFont** out | 0 | Z:0x413fb0 | 1 |
| +0x50 | GetSize | 2/8 | int* w, int* h | int | Z:0x413fd0, rt+0x54 | 2 |
| +0x58 | MeasureText | 4/16 | IFont* (unwrapped), const char* text, int len, SIZE* out | int | Z:0x414030, rt+0x60 (Z:0x42a330 `GetTextExtentPoint32A`) | 5 |

Unused IImage slots: +0x08 DrawLine (rt+0x04), +0x14 DrawZML (engine ZML renderer Z:0x416190), +0x20/+0x28/+0x30 colour getters and SetBackgroundColor, +0x38 Clear, +0x3c blit with rectangles, +0x44, +0x54, +0x5c.

IFont, vtable Z:0x42ec2c: +0x04 Release (5 sites); +0x0c GetInfo(char* face out, int* pixel height, int* size class, uint* style), 4/16, result 0, Z:0x415cc0 / font slot +0x18 Z:0x427e60 (4 sites). Unused +0x08 GetMetrics(int* average char width, int* line height) Z:0x427e40.

ITimer, vtable Z:0x42ed68: +0x04 Release (3 sites; the destructor Z:0x4134b0 unregisters a running timer); +0x08 Start, 0/0, result 0, Z:0x415ce0 to Z:0x413580 (3 sites): registers with the timer manager, start = last = game clock now; no effect if already running. Unused: +0x0c Stop, +0x10 Tick, +0x14 select real clock, +0x18 is-real-clock, +0x1c Restart.

ISound, vtable Z:0x42ed90: +0x04 Release (11 sites); +0x08 Play(int param), 1/4, Z:0x415db0 to sound slot +0x14 Z:0x40c510: stores param at sound+0x14 and queues the sound on the sound thread (Z:0x409280). Result 0, or 8 if the inner sound is NULL. Meaning of param: unknown (game always passes 0; see audio-input.md).

IListener, vtable Z:0x42edac: +0x04 Release (3 sites). Unused: +0x08 Z:0x427af0 (reorder in event), +0x0c SetValue Z:0x427b60 (sets e[1]).

## 4. Classification of all computed calls (verified)

`analysis/decomp/Moeboid.gam/indirect_calls.tsv` lists 423 computed calls.

| Class | Count | Where |
|---|---|---|
| Engine interface methods | 295 | game code; this document and `interface.tsv` |
| Game-own vtables (screen scalar deleting destructor, argument 1) | 2 | G:0x10001c75 (in G:0x10001b50, Stop), G:0x10001dc1 (in G:0x10001db0, screen change) |
| KERNEL32 through IAT in game code | 8 | G:0x10004e90 (Help.zml loader): FindResourceA, CreateFileA, GetFileSize, ReadFile, CloseHandle, LoadResource, LockResource, SizeofResource |
| CRT (G:0x10005110 and above) | 118 | 83 KERNEL32 IAT calls; 35 register or table calls (CRT init/term tables, `_onexit`, signal, FP and SEH helpers) |

Game-own vtables (verified, memory at G:0x1000d150): 0x1000d150 base screen [G:0x10002680], 0x1000d154 credits screen [G:0x100028c0], 0x1000d158 play screen [G:0x10002cc0], 0x1000d15c title screen [G:0x10004320]. Each has one slot: `__thiscall` scalar deleting destructor, 1 argument, `ret 4`.

## 5. Engine to game

### 5.1 Entry points (verified)

| Function | Convention | Called by | When |
|---|---|---|---|
| `Shell_StartApplet(ctx)` G:0x100025f0 | cdecl, 1 argument | Z:0x424882 | game start, and again after New Game |
| `Shell_StopApplet(ctx)` G:0x10002630 | cdecl, argument ignored, returns 0 | Z:0x4248e9 | game stop (shell leaves the game, New Game, exit) |
| DllMain G:0x100058a6 | stdcall | Windows loader | stores hinstDLL in `DAT_1000f60c` (G:0x10004e70), CRT init |

### 5.2 Callbacks (verified)

All callbacks are `int __cdecl cb(int* e)`. Each game callback does `MOV ECX,[e]; PUSH e; CALL handler` (e.g. G:0x10001f40) and returns the handler result, which is 0 for every handler (verified by reading each handler). The engine uses the result: for listeners, 0 stops the dispatch to further listeners (Z:0x427750, Z:0x425928).

| Callback | Registered at | Registration | Fires when | e[] contents |
|---|---|---|---|---|
| G:0x10001f40 help | G:0x10001716 | IFactory+0x44(ctx[5], 0x10, game, cb) | shell button "How To Play" (string 10014, handler Z:0x41c3d0 to Z:0x41c3f0, which fires event 0x10 through applet manager slot +0x08 Z:0x424aa0 with argument 1) | e[0]=game object, e[1]=0, e[2]=0. Handler G:0x10001c90 gets ctx[3] image and draws Help.zml into it; the shell then pauses timers (Z:0x41c46e) and shows the overlay. |
| G:0x10002a70 credits tick | G:0x1000288d | IFactory+0x34(screen, 20, cb), started at G:0x1000289a | every 20 ms of game clock or more | e[0]=screen, e[1]=e[2]=ms since Start |
| G:0x10002a60 credits Done | G:0x100027b1 via G:0x10001de0 (button created at G:0x10001f28) | IFactory+0x30(ctx[2], screen, 0x1ac, 0x181, w, h, faces, 0, id 0, cb) | left click on the button | e[0]=screen, e[1]=e[2]=id |
| G:0x100031e0 play tick | G:0x10002c30 | IFactory+0x34(screen, 20, cb), started at G:0x10002c3d | every 20 ms of game clock or more | e[0]=screen, e[1]=e[2]=ms since Start (stored in `DAT_1000f5e0` and screen+0x1d4) |
| G:0x100031f0 play keydown | G:0x10002c17 | IFactory+0x44(ctx[5], 0xb, screen, cb) | WM_KEYDOWN | e[0]=screen, e[1]=0, e[2]=VK code (wParam), e[3]=0xb, e[4]=engine key index or -1 |
| G:0x10003f50 Yes/No | G:0x10003f0d, G:0x10003f38 via G:0x10001de0 | IFactory+0x30(dialog surface, screen, x, y, w, h, faces, 0, id 0 or 1, cb) | left click | e[0]=screen, e[1]=e[2]=id (0 Yes, 1 No) |
| G:0x10004990 Start | G:0x1000428e via G:0x10001de0 | IFactory+0x30(ctx[2], screen, 0xfa, 0xbe, w, h, faces, 0, id -1, cb) | left click | e[0]=screen |
| G:0x100049a0 title keydown | G:0x100042cd | IFactory+0x44(ctx[5], 0xb, screen, cb) | WM_KEYDOWN | as play keydown |
| G:0x100049b0 title tick | G:0x100042ea | IFactory+0x34(screen, 100, cb), started by the Start button handler at G:0x1000458b | every 100 ms or more after Start | e[0]=screen, e[1]=e[2]=ms since Start |

Event structure sources: timer Z:0x413545..0x41355a (e[0]=timer+0x24, e[1]=e[2]=now - timer+0x18); listener Z:0x427b10 (e[0]=listener+0x18 userdata, e[1]=listener+0x14); key broadcast Z:0x425870 (e[2]=wParam, e[3]=type, e[4]=key index); button Z:0x4199a0 (e[2]=button+0x58 = id, e[1] set to id by Z:0x427b60 called at Z:0x41986c).

### 5.3 Event types and input delivery (verified)

| Type | Origin | Address |
|---|---|---|
| 1, 2, 3, 4, 5, 7 | WM_LBUTTONDOWN, LBUTTONUP, LBUTTONDBLCLK, RBUTTONDOWN, RBUTTONUP, MOUSEMOVE (window procedure Z:0x4040e0 through input subsystem slot +0x04 to event manager slot +0x00 Z:0x425020, hit test on the surface tree) | Z:0x4040e0 |
| 8, 9 | mouse enter / leave of a surface (from type 7) | Z:0x425020 |
| 10 | click: button up on the surface that got the button down | from Z:0x42563e |
| 0xb | WM_KEYDOWN, broadcast to all type-0xb listeners regardless of source; VK_ESCAPE is not delivered (shell uses it to toggle pause) | Z:0x4040e0 (0x100), Z:0x4269b0, Z:0x425870 |
| 0xc | WM_CHAR (key index 4 for characters without a special key index) | same |
| 0xd | WM_KEYUP | same |
| 0xe | button activated (fired by the button on type 10) | Z:0x4199a0 |
| 0x10 | "How To Play" | Z:0x424aa0 |
| 0x11 | defined (ISystem ctor), fired by Z:0x424aa0 with argument 0; no caller with 0 found | Z:0x415df0 |

Facts for the port:
- Keyboard events carry Windows VK codes, not characters. The play screen compares e[2] with 0x59 'Y', 0x79, 0x4e 'N', 0x6e, 0x20 space (G:0x10002e35..0x10002e5f). As VK codes, 0x79 is VK_F10 and 0x6e is VK_DECIMAL: in the original, F10 answers Yes and numeric-keypad '.' answers No (inferred from the VK table; not tested). The title cheats compare with "CREDITS"/"credits" and "INVINCIBLE" (G:0x100043f0); with VK codes only the upper-case letters match typed keys.
- Movement keys are polled (ISystem+0x20) once per play tick, not delivered as events (G:0x10003200).
- The game gets no pause, resume, focus or menu event. Pause (shell button, Escape key, window deactivation Z:0x4040e0 case WM_ACTIVATE) toggles the timer manager pause (Z:0x41cb30, timer manager slot +0x10 Z:0x427490). While paused, game timers do not fire and the game clock stops (game clock = `GetTickCount()` minus paused time, Z:0x427510). Help also pauses (Z:0x41c46e). Resume: Z:0x41b430.
- Mouse input reaches the game only through buttons.

## 6. Resource access (verified)

| Resource | Path |
|---|---|
| GIF (46) | `IFactory::CreateSurfaceFromFile(name, 0)` with the resource name. Engine `CImageSeq::LoadGIF` Z:0x418d90 opens it with the file subsystem (`DAT_0045cfac` slot +0x00), `CFile` ctor Z:0x427ef0: `FindResourceA(ZapSpot.exe, name, RT_RCDATA)`; if absent, `LoadLibraryA(path of the running game)` (applet manager slot +0x18 Z:0x424a10) and `FindResourceA` there; then the module registered by slot +0x10. No RCDATA name exists in both binaries (checked with `assets/index.json`), so the order does not change the result. Names with `%d` are built with `sprintf` (G:0x100051b0) for sizes 11, 15, ..., 47 (stack table written at G:0x10001732..0x10001771). |
| WAV (11) | `IFactory::CreateSound(name, 0)`; sound subsystem Z:0x409030, buffer loader Z:0x40c780 (same resource lookup inferred; see audio-input.md). |
| HELP.ZML | read by the game itself: G:0x10004e90 `FindResourceA(hinstDLL, "Help.zml", 10)`; if absent, `CreateFileA("Help.zml")` in the current directory (the temp folder). G:0x10004fb0 copies the text between the first two `"` characters (max 10000 bytes); G:0x10001c90 replaces CR and LF by spaces and draws it with the game's own ZML renderer G:0x10004a00 into the ctx[3] image, then draws "<C999999><s4>Moeboid is a trademark of ZapSpot, Inc." at x=0x12f, y=0 (G:0x10001d86; renderer arguments are image, text, x, y; `<BR>` sets x=0 and adds 15 to y). |
| Strings (8) | read by the engine only (`LoadStringA`, Z:0x4243b0): version, name, owner id, icon, category strings. Id 9 and 1000 are not read by these functions. |
| Fonts | `IFactory::CreateFont("Arial", size, 1)` (bold) with sizes 0x0c, 0x12, 0x18 (G:0x10001dfc, G:0x10003ad0, G:0x10004640), and the sizes and styles of the ZML renderer (fonts.md). |

The game ZML renderer G:0x10004a00 supports `<B>`, `<BR>`, `<C rrggbb>`, `<I>`, `<P>`, `<S n>`/`<S+>`/`<S->`, `<U>` and closing tags, using only IImage +0x18/+0x24/+0x48/+0x4c/+0x50/+0x58, IFont +0x0c/+0x04 and IFactory +0x28. It does not use the engine ZML renderer (IImage+0x14).

## 7. Game internals

### 7.1 Objects and globals (verified unless marked)

Game object, 0xf4 bytes, ctor G:0x100016a0, globals `DAT_1000f5cc` and `DAT_1000f5d8`:

| Offset | Content |
|---|---|
| +0x00 | current screen object (game vtable family 0x1000d150); replaced by G:0x10001db0 (old one deleted) |
| +0x04 | IListener* help (ctx[5], event 0x10) |
| +0x08..+0x54 | IImageSeq* baddie animations: size s = 1..10 at +8*s (right) and +8*s+4 (left) |
| +0x58..+0x7c | IAnim* meboid left, size s at +0x54+4*s |
| +0x80..+0xa4 | IAnim* meboid right, size s at +0x7c+4*s |
| +0xa8 | IImageSeq* "ani-baddie-blob-39x39.gif" (spawn blob) |
| +0xac | ISurface* "img-backgroundscreen-500x420.gif" (3-frame intro animation) |
| +0xb0 | ISurface* "ani-titlescreen_animation-500x79.gif" (500x89, 24 frames) |
| +0xb4 | uint8 intro running (Start was clicked) |
| +0xb8 | IImage* meboid right size 3 (19x19) current image |
| +0xbc | IImage* "img-titlescreen-500x420.gif" |
| +0xc0 | IImage* background frame 2 (play field) |
| +0xc4 | IAnim* "ani-meboid_angel-19x19.gif" |
| +0xc8..+0xf0 | ISound*: gameopen, gameover, gameover-highscore, gamestart, loselife, moebeats, moebgrowth, newbaddieGood, newbaddieBad, randbg, ExtraLife |

Screens: title (0x20 bytes, ctor G:0x100041a0), credits (0x1a4 bytes, G:0x100026c0, up to 100 baddies), play (0x1e8 bytes, G:0x10002a80: +0x08 score, +0x0c player, +0x10.. baddie pointers (count +0x1a0), +0x1a4 lives (start 2), +0x1a8 next random background sound time, +0x1b0 ITimer, +0x1b4 IListener, +0x1bc dialog state (0 none, 1 "Play Again?", 2 "press space"), +0x1c0..+0x1d0 key held flags and press times, +0x1d4 current tick time, +0x1d8/+0x1dc dialog image and surface, +0x1e0/+0x1e4 Yes/No buttons). Player 0x3c bytes (G:0x10001f50): +0x00 size 1..10, +0x0c ISurface*, +0x10/+0x14 float x,y, +0x18/+0x1c float vx,vy, +0x20/+0x24 w,h, +0x28 facing left, +0x2c growth points, +0x30 next threshold, +0x34 size-ups. Baddie 0x38 bytes (G:0x100011a0): +0x00 size, +0x04 blob surface, +0x08 surface, +0x0c..+0x18 float x,y,vx,vy, +0x1c/+0x20 w,h, +0x24 facing, +0x28 spawn time, +0x2c spawn delay, +0x30 spawning, +0x34 last move time.

Globals: `DAT_1000f5b0` IFactory, `DAT_1000f5b4` ctx, `DAT_1000f5b8` IImage of ctx[2] (all drawing of backgrounds and HUD), `DAT_1000f5bc` ctx[2], `DAT_1000f5c0` ctx[3], `DAT_1000f5c4` ISettings, `DAT_1000f5c8` ISystem, `DAT_1000f5e0` current tick time, `DAT_1000f5e4` play screen, `DAT_1000f5e8` angel surface, `DAT_1000f5ec` death animation running, `DAT_1000f5f0` arrow-key bits, `DAT_1000f604` INVINCIBLE cheat, `DAT_1000f605` credits mode, `DAT_1000f608` start size (1), `DAT_1000f60c` hinstDLL. G:0x10001f50 rewrites the growth table G:0x1000e29c..0x1000e2bc from the constant G:0x1000e298 each time (same values every time).

### 7.2 State machine (verified)

1. Start: game object, then title screen. Title: plays gameopen, title animation, title image, "Start" button, "Top Moeboids" table (G:0x10004640), keydown listener, 100 ms timer (not started). `ISystem::SetGameInProgress(0)` (G:0x100042fb).
2. Start button (G:0x10004530): attach and play the background intro animation, play gamestart, start the 100 ms timer. Tick G:0x100045a0: when e[2] > 3000 ms, detach intro and switch to the play screen.
3. Title keydown: "CREDITS" switches to the credits screen (`DAT_1000f605`=1, 100 random baddies, 20 ms timer, "Done" returns to title). "INVINCIBLE" sets `DAT_1000f604` (no death).
4. Play screen: `SetGameInProgress(1)` (G:0x10002c9d), 20 ms timer. Tick G:0x10002ea0: random background sound at screen+0x1a8 (then +5000..8999 ms); collision test G:0x10003460 (eat smaller baddies, G:0x100024e0; be eaten by bigger ones); key polling and player motion; baddie motion G:0x10001380.
5. Eaten: lives - 1. If lives >= 0: loselife sound, angel animation (G:0x10003130); after 1000 ms dialog "That's ok..." (state 2), space restarts the round (G:0x10004000); after 2000 ms angel removed. If lives < 0: high-score entry (G:0x100037d0) or gameover sound, angel, then dialog "Play Again?" (state 1): Yes (button 0 or key 0x59/0x79) gives a new play screen; No (button 1 or 0x4e/0x6e) gives the title screen.

### 7.3 Nondeterminism (verified unless marked)

| Source | Detail |
|---|---|
| Engine RNG, ctx+0x08 | MSVC `rand()`: state = state x 0x343fd + 0x269ec3 (mod 2^32), result (state >> 16) & 0x7fff; state Z:0x434100 (file value 1); `srand(timeGetTime())` once at engine start Z:0x403dcb. The only other engine call is Z:0x421c8f (`rand() % 2 or 3` in the ctor Z:0x421bf0 of a 470x62 shell surface), reached once from the shell ctor at engine start (call chain Z:0x4040a7, Z:0x41314e, Z:0x41ae59, Z:0x41ea83), after `srand`. The state is not reset between applet sessions. 21 game call sites: spawn positions, speeds, sizes, delays, random sound times. For replay: record the state when Shell_StartApplet runs. |
| Game-local RNG | static CRT `rand()` G:0x10005639, state G:0x1000ea40 (file value 1), never seeded (only references are in the function). One call site, G:0x10002fa3 (angel wobble). Sequence restarts only when the DLL image is really reloaded (section 2.1, unknown). |
| Time | Only the timer callback argument e[2] (ms since timer Start, game clock = `GetTickCount` minus pause, Z:0x427510). The game uses differences of e[2] to scale motion (`dt x v x 0.1` for the player G:0x10002330, `dt x v x 0.09` for baddies G:0x10001380), so motion depends on the real tick spacing. The game reads no other clock. |
| Tick spacing | the main loop Z:0x404a30 calls the timer manager tick between messages without sleeping; a timer fires when now - last >= interval and then sets last = now (no catch-up, Z:0x413541..0x413563). With GetTickCount steps of 10 to 16 ms the 20 ms timer fires at 20 to 32 ms spacing. See timing.md. |
| Input | key polling (ISystem+0x20) per tick; keydown VK codes; button clicks; name typed in the InputBox. |
| Persistent data | high-score table in settings decides the high-score path. |
| Floating point | x87 code with `fsin`, `fcos`, `fsqrt` (G:0x100011a0 spawn position) and float32 storage, `__ftol` truncation; results depend on x87 precision control (see verification.md, workstream J). |

For deterministic replay, record: engine RNG state at start, every timer callback (which timer, e[2]), every keydown e[2], GetKeyState results per tick, button clicks, InputBox text.

### 7.4 Scores (verified)

- Score = play screen +0x08. Eating a baddie of size s adds 10 x s to the score and s growth points (G:0x100024e0). At the threshold the player grows (G:0x1000256e); every third growth gives one life and plays ExtraLife (G:0x100025c9).
- HUD: score G:0x10003ad0 ("%d", Arial 24 bold, colour 204,51,153, centred on x=0x1c9, y=0x186; called after each score change); lives G:0x10003a60 ("<s0><ccc3399><b>%d</b>" at x=0x35, y=4; called when lives change); next-size icon G:0x10003bc0.
- Storage: ISettings per-game values "Score1Name".."Score5Name", "Score1Score".."Score5Score" (decimal strings), "LastNameEntered". Defaults written when "Score1Name" is missing (result 0x19): ZapSpot 10000, 5000, 2500, 1000, 500 (G:0x10004640). Default name "Name" (G:0x1000e604).
- Game over (G:0x100037d0): find the first rank i (1..5) with stored score <= score; if none, no entry. Else play gameover-highscore, `ISystem::InputBox("Congratulations", ..., last name, out, 0x10, 1)`; a name of 13 or more characters gives `ISystem::MessageBox("Name too long", ..., 0x101)` and a new prompt; then shift ranks i..4 down, write name and score. The scores go nowhere else (no network call in game code; the game imports only KERNEL32).

## 8. Size of the surface to reimplement

| Part | Count |
|---|---|
| Interfaces | 13 |
| Engine methods called (interface, offset) | 54 rows in `interface.tsv`; 46 distinct behaviours |
| Engine services behind them | surface tree with z-order, visibility, protect key and dirty regions; GIF loader and frame timing (50 ms quantum, Z:0x4170d0); image drawing (rect, fill, text, measure, colour-key blit, clear); fonts (GDI LOGFONT semantics); timers and game clock with pause; sounds; key polling and keydown broadcast; buttons with hover face and click; modal MessageBox and InputBox; per-game string settings; MSVC `rand()` |
| Engine-to-game calls | 2 exports, 9 callbacks |
| Game KERNEL32 use | 8 functions for Help.zml, plus static CRT (heap, environment, file handles) |

Facts for the choice of target technology:
- The boundary is small and regular (thiscall, integer arguments, callee pop = 4 x argc, results in EAX, callbacks cdecl with an int array). An x86 interpreter that runs the original Moeboid.gam needs: PE loading with relocations, the KERNEL32 functions of the static CRT and of G:0x10004e90, x87 FPU emulation including `fsin`/`fcos`, and the 46 engine behaviours.
- A source port (C/wasm or TypeScript) must copy the game code (about 16 KB of code, G:0x10001000..0x10005110), keep float32 storage and x87 `fsin`/`fcos`/`fsqrt` results, and reproduce the variable-dt motion.
- The game draws its text with its own ZML renderer through GDI `ExtTextOutA` semantics (`DrawText`, `MeasureText`); exact text needs exact Arial metrics (fonts.md).

## 9. Open questions

1. Is Moeboid.gam unmapped at New Game (resets game `.data` and the game-local RNG)? Needs a reference run or a trace (workstream I).
2. Meaning of `ISound::Play` argument and `IFactory::CreateSound` flag bit0 (audio-input.md, workstream F).
3. Result values and exact UI of `ISystem::MessageBox` and `ISystem::InputBox` (shell.md, workstream G); the game ignores both results.
4. Shell button bits 0x02 and 0x04: string ids 10013 and 10015 are pushed near the tests, but handler pairing was not traced (shell.md).
5. App object methods behind ctx slot +0x0c and ISettings +0x18 (unused by the game).
