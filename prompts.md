# Session prompt log

## 1

> @moeboid.exe is an old Windows game (it could run on Windows XP)
>
> the goal: port it to run perfectly in the modern browser. perhaps wasm + canvas is a good choice, but we can decide which target is ideal later.
>
> for now, do a brief analysis on the executable. find ways to convert the binary into opcodes. the goal is not to decompile it, even though that could be a helpful intermediate step.
>
> i'd like to understand which windows OS APIs binary calls. or are they called syscalls? or WinAPI? explain.
> generate a table of the categories of WinAPI (or whatever they're called) functions that the binary invokes. again, don't decompile it yet

**Summary:** `moeboid.exe` is a 44 KB ZapSpot launcher with a zlib-compressed payload appended to the file. The payload contains `Moeboid.gam` (game logic DLL: 47 KB code, plus GIF and WAV assets) and `ZapSpot.exe` (engine: DirectDraw, DirectSound, DirectInput, GDI, Winsock). The binaries call WinAPI functions through the import table and call DirectX through COM vtables; they make no direct syscalls. The unpacked binaries and their `objdump` disassembly are in `extracted/`, and the resource parser is in `tools/pe_rsrc.py`. Next step: map the vtable interface that `Moeboid.gam` calls on the engine.

## 2

> by the way, every prompt in this claude session should be saved to @prompts.md, followed by a terse, standard technical english max 5-sentence summary of your response. the intention is to keep track of what this claude code session does.

**Summary:** Created `prompts.md` with prompts 1 and 2. Each later prompt goes into this file word for word, followed by a summary of the response of 5 sentences or fewer.

## 3

> 1. exact gameplay, timing, and visuals, but absolutely no ads, or network communication.
> 2. keep the ZapSpot frame, platform menu, etc but don't include any ad banners.
> 3. yes to both. but first tell me if ghidra or rizin can be installed just in this directory, not system-wide, so I can keep my system tidy

**Summary:** Ghidra 12.1.4 and rizin 0.9.1 can both run from inside the project directory without root. Ghidra uses the existing system JDK 27 (minimum 21, no maximum); environment overrides keep its settings and cache in the project. Proposed layout: `tools/` with the Ghidra zip, the rizin static tarball, a Python venv for pefile and capstone, and an `env.sh` that sets the `XDG_*` variables. Flagged risks for the requirements: frame-rate timing, GDI font rendering, browser audio autoplay, and menu items that need the network. Waiting for approval before the downloads (about 710 MB).

## 4

> install all the tools you need locally. only install cutter if the non-GUI rizin isn't enough. maybe you can decide this later.
>
> 1. match the origial game's own update rate. e.g. obviously the game's visuals should not run aat different speeds depending on the screen's refresh rate
> 2. get exact copies of the Microsoft fonts
> 3. exact colours please
> 4. ok, just have a simple click-to-start screen to launch the game in the webpage
> 5. local high scores. no accounts, no bfast.com. remove the game downloads menu.
> 6. leave it blank for now
> 7. keep it for now if that's easy to do. otherwise, let me know and i can decide.
>
> use Fable to orchestrate subagents to get this done.

**Summary:** Installed Ghidra 12.1.4, rizin 0.9.1, portable Wine 11.19 and a Python venv (pefile, capstone, unicorn, pillow) under `tools/`, with checksums verified; `tools/env.sh` keeps all tool state inside the project. Added `tools/bin/nonet`, which runs the original binaries with no network access, DNS included. Ghidra imported and analysed both binaries into `analysis/ghidra_project`. Fonts needed so far: Arial (available in Microsoft's free Core Fonts package) and MS Sans Serif (a Windows bitmap font, not freely available). Started a Fable orchestrator for phase 1 (analysis, asset extraction, design proposal); it stops before implementation for user decisions.

## 5

> ~/moeboid_port$ ls sserifee.fon
> sserifee.fon

**Summary:** `sserifee.fon` is MS Sans Serif with 6 bitmap sizes (13 to 37 px), but it is the Central European variant (charset 238, code page 1250), not the Western `sserife.fon` (charset 0, code page 1252) that English Windows used. Characters 0x80 to 0xFF can differ between the two files; the ASCII range is probably the same but is not verified. Sent the font details to the orchestrator, which must find which non-ASCII characters the dialogs display. The hosting question (public or private) is still open.

## 6

> try this: https://github.com/chyyuu/msfonts/raw/refs/heads/master/sserifee.fon

> it will only be run locally

**Summary:** The linked file is byte-identical to the user's `sserifee.fon` (Central European). The same repository has the Western `sserife.fon` (charset 0); it is now in `fonts/` with its source and hash in `fonts/SOURCES.md`. A glyph comparison shows the two files differ even in ASCII at 16 px and 20 px, so the Western file is necessary. The repository's `arial.ttf` is a much newer version than the Arial 2.82 of Windows 2000/XP; the orchestrator must get Arial from Microsoft's Core fonts package. Local-only deployment removes the font licence limits on packaging; the orchestrator received both updates.

## 7

> delete sserifee.fon, we don't need it

**Summary:** Deleted `sserifee.fon` from the project root and the scratchpad copy. Removed its row from `fonts/SOURCES.md` but kept the glyph comparison result as a note. Told the orchestrator to use only `fonts/sserife.fon`.

## 8

> resume

**Summary:** The phase 1 orchestrator had stopped on an API spend-limit error (HTTP 429). Before it stopped, it exported the decompiled code to `analysis/decomp/`, extracted the game files to `assets/`, and started the reference-run and verification scripts; no workstream report existed. Resumed the orchestrator with that state, an instruction to finish only the missing work, and an instruction to pass model "fable" to each subagent, because the error showed requests sent to `claude-opus-5-5`.

## 9

> subagents can use Opus or any model that the orchestrator sees fit.

**Summary:** Told the orchestrator to choose the model for each subagent itself; Opus is allowed. This replaces the earlier instruction to force Fable.

## 10

> what's the progress so far?

**Summary:** Seven of the planned outputs are finished: the interface, timing, rendering, fonts, audio/input, shell and verification reports in `analysis/`. The game files are extracted, there are 36 reference screenshots from Wine, and Arial 2.82 (regular and bold) is in `fonts/`. The architecture proposal (`docs/architecture.md`) and the orchestrator's final report do not exist yet. New decisions surfaced: which Windows clock step defines "exact timing" (game speed and feel depend on it), Tahoma for message boxes and dialog titles, and the font-smoothing setting.

## Event (not a prompt): phase 1 report received

**Summary:** The orchestrator finished phase 1: 10 workstreams and `docs/architecture.md`. It recommends option (d): the original `Moeboid.gam` runs unchanged in a small x86 interpreter, and a rewritten ZapSpot engine and shell in C, compiled to wasm, plus a thin TypeScript host. A Wine crash at 09:03 left a core dump in `/var/lib/systemd/coredump` and a KDE crash record in `~/.cache/drkonqi/crashes/`, both outside the project; `tools/bin/nonet` now sets `ulimit -c 0`. No screenshot of the user's own screen remains; the scratch contact sheets show only the Wine desktop and the game. 13 decisions from `docs/architecture.md` section 6 wait for the user.
