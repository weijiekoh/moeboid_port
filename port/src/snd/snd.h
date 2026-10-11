/* Sound voice table of the DirectSound subsystem (M4; analysis/audio-input.md 2.3-2.6).
 *
 * Model of Z:0x409280 (Play: first free slot of DAT_00459ea0[16], drop when full, no stealing) and
 * of the voice thread Z:0x409340 (a slot is freed by the first thread pass after the voice stopped).
 * The thread sleeps 10 ms per pass (Sleep(10), Z:0x4093d8); the port puts the passes at every 10 ms
 * of the GetTickCount model from engine start (inferred: the real period is 10 to 16 ms and its
 * phase is unknown). A voice stops at start + data bytes / (block align x sample rate).
 * The release is evaluated when the table is read (every Play), which gives the same slot state as
 * a thread pass, because only Play reads it. Deterministic: depends only on the clock. */
#ifndef PORT_SND_SND_H
#define PORT_SND_SND_H

#include <stdbool.h>
#include <stdint.h>
#include "../core/sound_ids.h"

#define SND_PASS_MS 10u

typedef struct SndInfo {   /* WAV facts per sound id (RIFF rules of Z:0x40c540) */
    uint32_t data_bytes;   /* first "data" chunk size */
    uint32_t block_align;  /* fmt nBlockAlign */
    uint32_t rate;         /* fmt nSamplesPerSec */
    bool ok;
} SndInfo;

typedef struct SndVoice {
    bool busy;
    uint32_t owner;        /* engine sound object handle (owner table DAT_00459e5c) */
    uint32_t sound_id;
    int32_t repeat;        /* DAT_00459ee4: Play count */
    uint32_t release_ms;   /* first thread pass at or after the end of the voice */
} SndVoice;

typedef struct SndVoices {
    SndVoice v[PORT_SND_VOICES];
    SndInfo info[PORT_SND_ID_END];
    bool ready;            /* subsystem +0x08: DirectSound initialised */
    bool enabled;          /* subsystem +0x10: "Sound" setting */
    uint32_t plays, drops; /* statistics */
} SndVoices;

/* Parse a RIFF WAV like Z:0x40c540: "RIFF", "WAVE", chunks from offset 12, step (size + 1) & ~1,
 * first "fmt " (size >= 14) and first "data". */
bool snd_parse_wav(const uint8_t *d, uint32_t n, SndInfo *out);

/* Release every voice whose release time has passed (voice thread passes up to now_ms). Voices
 * with repeat >= 2 restart (repeat - 1) at their release time; *restart_voice receives the slot
 * of one restarted voice (or -1) so that the caller can queue the PLAY command; call again until
 * it returns false. */
bool snd_poll(SndVoices *s, uint32_t now_ms, int32_t *restart_voice);

/* Z:0x409280 after the enabled check: first free slot or -1 (dropped). */
int32_t snd_alloc(SndVoices *s, uint32_t owner, uint32_t sound_id, int32_t count, uint32_t now_ms);

/* Remove an owner from the table (DeleteSound Z:0x4090a0): its voices stay until they end. */
void snd_forget_owner(SndVoices *s, uint32_t owner);

#endif
