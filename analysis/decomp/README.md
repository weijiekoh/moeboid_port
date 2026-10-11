# Ghidra text exports (workstream A)

Source: Ghidra 12.1.4 project `analysis/ghidra_project` (`moeboid`), default auto-analysis, opened read-only.
Script: `analysis/decomp/scripts/ExportAll.java`. Re-run (one Ghidra process per project at a time):

```
source tools/env.sh
analyzeHeadless /home/user/moeboid_port/analysis/ghidra_project moeboid -process ZapSpot.exe \
  -noanalysis -readOnly -scriptPath /home/user/moeboid_port/analysis/decomp/scripts \
  -postScript ExportAll.java /home/user/moeboid_port/analysis/decomp
```

One directory per program: `Moeboid.gam/` (281 functions), `ZapSpot.exe/` (1257 functions).
Function names are Ghidra defaults (`FUN_<address>`) unless Ghidra Function ID matched a MSVC library function (column `source` = ANALYSIS) or the name is an export/import. Refer to functions by address.

| File | Content |
|---|---|
| `decompiled.c` | Decompiled C of every function, address order. Each function starts with `/* ==== FUNCTION <name> @ <addr> size=<bytes> ==== */`. 0 failures. |
| `decompiled_index.tsv` | entry, name, first line of the function in `decompiled.c`. |
| `functions.tsv` | entry, name, symbol source, size, thunk, calling convention, parameter count, callers, callees, prototype. |
| `imports.tsv` | library, name, ordinal, reference address, reference type, containing function. A call through the IAT appears twice (`COMPUTED_CALL` and `READ_VIA_IAT`). |
| `strings.tsv` | address, data type, references (address:function), value (escaped). |
| `globals.tsv` | referenced addresses in non-executable blocks: address, block, symbol, data type, reference count, referencing functions. |
| `vtables.txt` | Heuristic: runs of 2 or more dwords in data that point into executable memory, with references to the table start. No MSVC RTTI exists in either binary (no `.?AV` type descriptors), so class names are not attached. Function pointer arrays that are not vtables also appear. |
| `indirect_calls.tsv` | every computed CALL: address, function, instruction. |
| `listing.asm` | Ghidra disassembly with function headers and symbol names of references. |

Known limits: Ghidra did not infer `this` for calls through vtables of unknown type, so `(**(code **)(*p + 0x44))(a, b)` hides the `ECX`/stack `this` argument. Check the call site in `listing.asm` for the calling convention (MSVC6 COM-style interfaces use `__stdcall` with `this` pushed last; C++ virtual methods use `__thiscall` with `this` in `ECX`).
