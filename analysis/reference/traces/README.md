# Trace extracts (Wine 11.19 wow64, run through nonet)

Each file is a short extract. The full logs were up to 1.1 GB and are not kept.
Wine process id 00d8 = ZapSpot.exe in all runs; main thread 00dc.

- `startup_net_files_relay.txt` - run N (first-run state): every relay-traced engine call at start-up (ZDT reads, DDraw/DSound/wininet/Crypt32 loads, WSAStartup) plus +winsock/+wininet lines.
- `install_exit_files_relay.txt` - run I (click Install ZapSpot, then close) and run X (installed state, play, close): directories, CopyFileA, ZDT writes, IShellLink, InternetGetConnectedState return value, WSACleanup, timeEndPeriod(1).
- `timing_relay.txt` - run T: relay counts of timing calls per thread and caller address (GetTickCount, PeekMessageA, Sleep, timeGetTime), thread creation and priorities, call samples.
- `ddraw_dsound_setup.txt` - run D2: first 140 +ddraw/+dsound lines: DirectDrawCreate, SetCooperativeLevel, GetDisplayMode, primary surface, clipper, back buffer, DirectSoundCreate, primary format.
- `dsound_buffers.txt` - run D2: every CreateSoundBuffer (flags, size, WAVEFORMAT), DuplicateSoundBuffer and Play call.
- `frame_cadence.txt` - runs D2 and F2: primary Blts per second, intervals, histogram, one gameplay frame, +fps output.
- `scheduler_tasks.txt` - engine timer-task table (period, callback, time base) read from process memory with winedbg, title screen and gameplay.
- `registry_files_diff.txt` - registry value diffs (timestamps ignored) and file diffs of the Wine prefix before and after runs N, I and X.
