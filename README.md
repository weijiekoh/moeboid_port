# A WASM port of Moeboid (2000) from Zapspot

This is a port of the Moeboid game from Zapspot, released in 2000.
Run it using `port/run.sh`, then open http://127.0.0.1:8000/ in Firefox or Chromium.
The first run builds the port and needs clang (wasm32 target), Node.js 22.13 or later,
Python 3 with `pefile`, and FreeType.

<img src="start.png" alt="Moeboid title screen" />

Claude code wrote all the code in less than a day. The prompts I gave it are in
[`prompts.md`](prompts.md).
