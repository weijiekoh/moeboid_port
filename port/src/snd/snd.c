/* Sound voice table (M4). See snd.h. */
#include "snd.h"

static uint32_t rd32(const uint8_t *p) { return (uint32_t)p[0] | (uint32_t)p[1] << 8 | (uint32_t)p[2] << 16 | (uint32_t)p[3] << 24; }
static uint32_t rd16(const uint8_t *p) { return (uint32_t)p[0] | (uint32_t)p[1] << 8; }

bool snd_parse_wav(const uint8_t *d, uint32_t n, SndInfo *out) {
    /* Z:0x40c540 */
    out->ok = false;
    if (!d || n < 12) return false;
    if (d[0] != 'R' || d[1] != 'I' || d[2] != 'F' || d[3] != 'F') return false;
    if (d[8] != 'W' || d[9] != 'A' || d[10] != 'V' || d[11] != 'E') return false;
    uint64_t end = (uint64_t)rd32(d + 4) + 8u;
    if (end > n) end = n;
    bool have_fmt = false, have_data = false;
    for (uint64_t pos = 12; pos + 8 <= end && !(have_fmt && have_data);) {
        const uint8_t *c = d + pos;
        uint32_t size = rd32(c + 4);
        if (!have_fmt && c[0] == 'f' && c[1] == 'm' && c[2] == 't' && c[3] == ' ') {
            if (size < 14 || pos + 8 + 14 > n) return false;
            out->rate = rd32(c + 12);
            out->block_align = rd16(c + 20);
            have_fmt = true;
        } else if (!have_data && c[0] == 'd' && c[1] == 'a' && c[2] == 't' && c[3] == 'a') {
            out->data_bytes = size;
            have_data = true;
        }
        pos += 8u + (((uint64_t)size + 1u) & ~(uint64_t)1u);
    }
    if (!have_fmt || !have_data || out->rate == 0 || out->block_align == 0) return false;
    out->ok = true;
    return true;
}

/* First voice-thread pass at or after start + bytes / (block_align * rate) seconds. */
static uint32_t release_time(const SndInfo *in, uint32_t start_ms) {
    uint64_t den = (uint64_t)in->rate * in->block_align;
    uint64_t end_num = (uint64_t)start_ms * den + (uint64_t)in->data_bytes * 1000u; /* end = end_num / den ms */
    uint64_t step = (uint64_t)SND_PASS_MS * den;
    uint64_t k = (end_num + step - 1u) / step;
    return (uint32_t)(k * SND_PASS_MS);
}

bool snd_poll(SndVoices *s, uint32_t now_ms, int32_t *restart_voice) {
    /* Z:0x409340: a stopped voice with repeat < 2 is released; else repeat - 1 and Play again. */
    *restart_voice = -1;
    for (uint32_t i = 0; i < PORT_SND_VOICES; i++) {
        SndVoice *v = &s->v[i];
        if (!v->busy || (int32_t)(now_ms - v->release_ms) < 0) continue;
        if (v->repeat < 2) {
            v->busy = false;
            v->owner = 0;
            continue;
        }
        v->repeat--;
        uint32_t t = v->release_ms;
        const SndInfo *in = v->sound_id < PORT_SND_ID_END ? &s->info[v->sound_id] : 0;
        v->release_ms = (in && in->ok) ? release_time(in, t) : t + SND_PASS_MS;
        *restart_voice = (int32_t)i;
        return true;
    }
    return false;
}

int32_t snd_alloc(SndVoices *s, uint32_t owner, uint32_t sound_id, int32_t count, uint32_t now_ms) {
    for (uint32_t i = 0; i < PORT_SND_VOICES; i++) {
        SndVoice *v = &s->v[i];
        if (v->busy) continue;
        const SndInfo *in = sound_id < PORT_SND_ID_END ? &s->info[sound_id] : 0;
        v->busy = true;
        v->owner = owner;
        v->sound_id = sound_id;
        v->repeat = count;
        v->release_ms = (in && in->ok) ? release_time(in, now_ms) : now_ms + SND_PASS_MS;
        s->plays++;
        return (int32_t)i;
    }
    s->drops++;
    return -1;
}

void snd_forget_owner(SndVoices *s, uint32_t owner) {
    for (uint32_t i = 0; i < PORT_SND_VOICES; i++)
        if (s->v[i].owner == owner) s->v[i].owner = 0;
}
