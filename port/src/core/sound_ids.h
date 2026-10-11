/* Sound ids and sound command contract between the C side (M4 voice table) and the host
 * (host/audio.ts, M6). Proposed by M6; M4 may change it, but must change host/audio.ts
 * SOUND_TABLE and the test port/tests/browser/audio_wav.mjs (which compares both tables) at
 * the same time.
 *
 * Command record (PortSoundCmd, port.h; 16 bytes, 4 x u32 little-endian):
 *   op        PORT_SND_OP_PLAY or PORT_SND_OP_STOP
 *   sound_id  PORT_SND_* id below (PLAY); 0 for STOP
 *   voice     voice slot 0..15 that the C voice table assigned (PLAY); slot or
 *             PORT_SND_VOICE_ALL (STOP)
 *   at_ms     clock ms of the step that made the command (core_sound_push sets it)
 *
 * Host rules (host/audio.ts):
 *   - PLAY: one new AudioBufferSourceNode per command, gain 1.0, no pan, buffer at the WAV's own
 *     rate (analysis/audio-input.md 2.4, 2.5, 4). Start time = audio time now + latency +
 *     (at_ms - now_ms) / 1000, now_ms = port_now() after port_advance, so commands of one
 *     host frame keep their clock spacing. The host does not limit voices.
 *   - STOP: stop every source of that voice (or of all voices) at the same scheduled time.
 *     The original engine has no Stop method; STOP exists only for the shutdown path
 *     (Z:0x408f90 stops every voice).
 *   - Sounds with PORT_SND_F_GLOBALFOCUS bypass the focus mute.
 *
 * C side (M4) must implement (audio-input.md 2.4, 2.6; the host knows none of this):
 *   - LoadSound(name): map the game or shell resource name (case-insensitive, for example
 *     "snd-gameopen.wav" or "BtnClick.wav") to the id whose pack entry has that base name.
 *   - Play(count): drop the call when sound is disabled (Sound setting) or when all 16 voices
 *     are busy (no stealing); else take the first free slot in index order and push
 *     PORT_SND_OP_PLAY with that slot (core_sound_push).
 *   - Voice release: a slot is busy from the Play step until the first voice-thread pass after
 *     the sound ends. Duration = data bytes / block align / sample rate of the WAV (pack entry;
 *     same RIFF rules as host/audio.ts parseWav). Thread pass period 10 ms Sleep (real period
 *     10 to 16 ms, inferred; Z:0x409340). The release depends only on the clock, never on the
 *     host, so the voice table stays deterministic.
 *   - count >= 2 (never used by the game or shell): the voice thread restarts the voice at
 *     the pass that sees it stopped; push another PLAY with the same slot at that step.
 */
#ifndef MOEBOID_CORE_SOUND_IDS_H
#define MOEBOID_CORE_SOUND_IDS_H

/* PortSoundCmd.op */
#define PORT_SND_OP_PLAY 1u
#define PORT_SND_OP_STOP 2u

#define PORT_SND_VOICES 16u           /* DAT_00459ea0[16] (Z:0x409280) */
#define PORT_SND_VOICE_ALL 0xffffffffu /* STOP: every voice */

/* Sound flags (third column of the table). */
#define PORT_SND_F_GLOBALFOCUS 1u /* DSBCAPS_GLOBALFOCUS: not muted on focus loss (Z:0x40c780) */

/* X(id, name, pack entry, flags). Ids are stable: append new rows, never renumber. Id 0 = none.
 * Rows 1..11: the game sounds in the load order of Moeboid.gam (G:0x100016a0, game object
 * +0xc8..+0xf0, audio-input.md 2.9). Rows 12..15: the platform sounds (Z:0x41b170,
 * Z:0x41c830, audio-input.md 2.11). */
#define PORT_SOUND_TABLE(X)                                                    \
    X(1, SND_GAMEOPEN, "gam/RCDATA/SND-GAMEOPEN.WAV", 0)                       \
    X(2, SND_GAMEOVER_HIGHSCORE, "gam/RCDATA/SND-GAMEOVER-HIGHSCORE.WAV", 0)   \
    X(3, SND_GAMEOVER, "gam/RCDATA/SND-GAMEOVER.WAV", 0)                       \
    X(4, SND_GAMESTART, "gam/RCDATA/SND-GAMESTART.WAV", 0)                     \
    X(5, SND_LOSELIFE, "gam/RCDATA/SND-LOSELIFE.WAV", 0)                       \
    X(6, SND_MOEBEATS, "gam/RCDATA/SND-MOEBEATS.WAV", 0)                       \
    X(7, SND_MOEBGROWTH, "gam/RCDATA/SND-MOEBGROWTH.WAV", 0)                   \
    X(8, SND_NEWBADDIEGOOD, "gam/RCDATA/SND-NEWBADDIEGOOD.WAV", 0)             \
    X(9, SND_NEWBADDIEBAD, "gam/RCDATA/SND-NEWBADDIEBAD.WAV", 0)               \
    X(10, SND_RANDBG, "gam/RCDATA/SND-RANDBG.WAV", 0)                          \
    X(11, SND_EXTRALIFE, "gam/RCDATA/SND-EXTRALIFE.WAV", 0)                    \
    X(12, SND_BTNCLICK, "zap/RCDATA/BTNCLICK.WAV", 0)                          \
    X(13, SND_POPUP, "zap/RCDATA/POPUP.WAV", 0)                                \
    X(14, SND_OPENSHELL, "zap/RCDATA/OPENSHELL.WAV", 0)                        \
    X(15, SND_CLOSESHELL, "zap/RCDATA/CLOSESHELL.WAV", PORT_SND_F_GLOBALFOCUS)

#define PORT_SND_ENUM_(id, name, entry, flags) PORT_##name = id,
enum { PORT_SND_NONE = 0, PORT_SOUND_TABLE(PORT_SND_ENUM_) PORT_SND_ID_END /* last id + 1 */ };
#undef PORT_SND_ENUM_

#endif
