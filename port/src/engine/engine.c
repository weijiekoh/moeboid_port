/* Engine start-up, applet manager, rendering, input routing, sounds and settings (M4).
 * See engine.h, README.md. Addresses: ZapSpot.exe (Z:) and Moeboid.gam (G:). */
#include "eng_int.h"
#include "shell_api.h"

#define SHELL_KEY 0x5348454cu /* protect key of ctx[2]; the original uses the CShell pointer (Z:0x41d6c0) */

Engine *engine_of(Port *p) { return p ? p->engine : NULL; }

bool eng_str_ieq(const char *a, const char *b) {
    for (;; a++, b++) {
        uint8_t x = (uint8_t)*a, y = (uint8_t)*b;
        if (x >= 'a' && x <= 'z') x = (uint8_t)(x - 32);
        if (y >= 'a' && y <= 'z') y = (uint8_t)(y - 32);
        if (x != y) return false;
        if (!x) return true;
    }
}

uint32_t eng_game_time(Engine *e) { return timersys_game_time(&e->p->timers); } /* Z:0x427510 */
uint32_t eng_real_time(Engine *e) { return timersys_real_time(&e->p->timers); } /* Z:0x4274f0 */

/* ------------------------------------------------------------------ resources */
const uint8_t *eng_resource(Engine *e, const char *name, uint32_t *len) {
    /* CFile Z:0x427ef0: FindResourceA(ZapSpot.exe, name, RT_RCDATA), then the running game (names are
     * case-insensitive; the pack stores them upper-case). */
    char key[160];
    uint32_t n = 0;
    const char *pre[2] = {"zap/RCDATA/", "gam/RCDATA/"};
    for (int k = 0; k < 2; k++) {
        n = 0;
        for (const char *s = pre[k]; *s && n + 1 < sizeof key; s++) key[n++] = *s;
        for (const char *s = name; *s && n + 1 < sizeof key; s++) {
            char c = *s;
            if (c >= 'a' && c <= 'z') c = (char)(c - 32);
            key[n++] = c;
        }
        key[n] = 0;
        const uint8_t *d = mpack_find(&e->pack, key, len);
        if (d) return d;
    }
    return NULL;
}

/* LoadStringA(game, id) from the pack copy of the string table (block id / 16 + 1). */
static void game_string(Engine *e, uint32_t id, char *out, uint32_t cap) {
    char key[32];
    rt_snprintf(key, sizeof key, "gam/STRING/%u", id / 16u + 1u);
    uint32_t len = 0, pos = 0;
    const uint8_t *d = mpack_find(&e->pack, key, &len);
    out[0] = 0;
    if (!d) return;
    for (uint32_t i = 0; i < 16 && pos + 2 <= len; i++) {
        uint32_t n = (uint32_t)d[pos] | (uint32_t)d[pos + 1] << 8;
        pos += 2;
        if (i == id % 16u) {
            uint32_t k = 0;
            for (; k < n && k + 1 < cap && pos + 2 * k + 1 < len; k++) {
                uint32_t c = (uint32_t)d[pos + 2 * k] | (uint32_t)d[pos + 2 * k + 1] << 8;
                out[k] = (char)(c < 256 ? c : '?');
            }
            out[k] = 0;
            return;
        }
        pos += 2 * n;
    }
}

/* ------------------------------------------------------------------ settings */
#define GAME_PREFIX "game/"

static void game_key(Engine *e, const char *name, char *key, uint32_t cap) {
    rt_snprintf(key, cap, GAME_PREFIX "%s/%s", e->owner_id, name);
}

/* existing storage key for the game property (lstrcmpiA on the name) */
static const char *game_find(Engine *e, const char *name) {
    char pre[96];
    rt_snprintf(pre, sizeof pre, GAME_PREFIX "%s/", e->owner_id);
    size_t pl = rt_strlen(pre);
    Storage *s = &e->p->storage;
    for (uint32_t i = 0; i < s->count; i++) {
        const char *k = s->e[i].key;
        if (rt_strncmp(k, pre, pl) == 0 && eng_str_ieq(k + pl, name)) return k;
    }
    return NULL;
}

int32_t eng_prop_get_game(Engine *e, const char *name, char *out, uint32_t cap) {
    /* Z:0x4294f0: found: copy, 0; missing: out = "" (the property group exists), 0x19. */
    const char *k = game_find(e, name);
    const char *v = k ? storage_get(&e->p->storage, k) : NULL;
    uint32_t i = 0;
    if (v)
        for (; v[i] && i + 1 < cap; i++) out[i] = v[i];
    out[i] = 0;
    return v ? 0 : 0x19;
}

void eng_prop_set_game(Engine *e, const char *name, const char *value) {
    /* Z:0x429710: replace the value of the first ZLSProp with this name, else append one; the port
     * writes through to the storage blob at every set (shell.md 2.4). */
    const char *k = game_find(e, name);
    char key[256];
    if (k) {
        rt_snprintf(key, sizeof key, "%s", k);
    } else {
        game_key(e, name, key, sizeof key);
    }
    if (!storage_set(&e->p->storage, key, value)) rt_log("engine: property %s not stored", key);
}

const char *engine_prop_get(Port *p, const char *name) {
    char key[256];
    rt_snprintf(key, sizeof key, "core/%s", name);
    return storage_get(&p->storage, key);
}

void engine_prop_set(Port *p, const char *name, const char *value) {
    char key[256];
    rt_snprintf(key, sizeof key, "core/%s", name);
    storage_set(&p->storage, key, value);
}

/* ------------------------------------------------------------------ sound */
#define SND_NAME_(id, name, entry, flags) entry,
static const char *const k_snd_entries[] = {"", PORT_SOUND_TABLE(SND_NAME_)};
#undef SND_NAME_

static uint32_t sound_id_of(const char *name) {
    for (uint32_t id = 1; id < PORT_SND_ID_END; id++) {
        const char *ent = k_snd_entries[id];
        const char *base = ent;
        for (const char *s = ent; *s; s++)
            if (*s == '/') base = s + 1;
        if (eng_str_ieq(base, name)) return id;
    }
    return 0;
}

uint32_t eng_sound_load(Engine *e, const char *name, uint32_t flag) {
    /* Z:0x409030: NULL when DirectSound is not ready; else a sound object (Z:0x40c440) whose buffer
     * holds the WAV data (Z:0x40c780); a loaded buffer gives the object an internal reference. */
    if (!e->voices.ready) return 0;
    CSound *s = (CSound *)eng_obj_new(e, OT_SOUND, sizeof(CSound));
    s->sound_id = sound_id_of(name);
    if (s->sound_id && e->voices.info[s->sound_id].ok) eng_addref_int(&s->o);
    else rt_log("engine: Error loading sound buffer (%s)", name);
    s->flag = (uint8_t)(flag & 1u);
    return s->o.h;
}

int32_t eng_sound_play(Engine *e, uint32_t h, int32_t count) {
    /* Z:0x40c510: +0x14 = count; Z:0x409280: voice in the first free of 16 slots, dropped when all
     * are busy or sound is off; the voice thread frees a slot after the sound ended (snd.h). */
    CSound *s = ENG_GET(e, h, CSound, OT_SOUND);
    if (!s) return 0;
    s->count = count;
    SndVoices *v = &e->voices;
    uint32_t now = core_ticks(e->p);
    int32_t rv;
    while (snd_poll(v, now, &rv)) core_sound_push(e->p, PORT_SND_OP_PLAY, v->v[rv].sound_id, (uint32_t)rv);
    if (!v->ready || !v->enabled) return 0;
    if (!s->sound_id || !v->info[s->sound_id].ok) return 0; /* DuplicateSoundBuffer of a NULL buffer fails */
    int32_t slot = snd_alloc(v, h, s->sound_id, count, now);
    if (slot >= 0) core_sound_push(e->p, PORT_SND_OP_PLAY, s->sound_id, (uint32_t)slot);
    return 0;
}

bool engine_sound_enabled(Port *p) {
    Engine *e = engine_of(p);
    return e && e->voices.enabled;
}

void engine_sound_set_enabled(Port *p, bool on) {
    /* Z:0x408f80 SetEnabled; the shell toggle Z:0x423260 writes "Sound" = "true"/"false" */
    Engine *e = engine_of(p);
    if (!e) return;
    e->voices.enabled = on;
    engine_prop_set(p, "Sound", on ? "true" : "false");
}

int32_t engine_play_sound(Port *p, const char *name) {
    Engine *e = engine_of(p);
    if (!e) return 8;
    uint32_t id = sound_id_of(name);
    if (!id) return 8;
    if (!e->sounds_by_name[id] || !ENG_GET(e, e->sounds_by_name[id], CSound, OT_SOUND))
        e->sounds_by_name[id] = eng_sound_load(e, name, 0);
    return e->sounds_by_name[id] ? eng_sound_play(e, e->sounds_by_name[id], 0) : 8;
}

/* ------------------------------------------------------------------ rendering */
void eng_present(Engine *e) {
    /* video +0x34 (Z:0x408a90): one Blt of the whole 800x572 frame buffer to the window */
    CImage *im = eng_image(e, eng_surface_image(e, e->root));
    if (!im) return;
    uint8_t *f = e->p->frame;
    for (int32_t y = 0; y < (int32_t)PORT_H && y < im->img.h; y++) {
        const uint32_t *row = im->img.px + (size_t)y * (size_t)im->img.stride;
        uint8_t *dst = f + (size_t)y * PORT_W * 4u;
        for (int32_t x = 0; x < (int32_t)PORT_W && x < im->img.w; x++) {
            uint32_t px = row[x];
            dst[4 * x + 0] = (uint8_t)IMG_R(px);
            dst[4 * x + 1] = (uint8_t)IMG_G(px);
            dst[4 * x + 2] = (uint8_t)IMG_B(px);
            dst[4 * x + 3] = 255u;
        }
    }
    core_frame_changed(e->p);
    e->renders++;
}

void eng_render(Engine *e) {
    /* Z:0x41b210: when the dirty flag is set: Render(root, NULL, {0, 0, w, h}), present, clear. */
    if (!dirty_flag(e->dirty)) return;
    int32_t w, h;
    eng_surface_size(e, e->root, &w, &h);
    DrawRect clip = {0, 0, w, h};
    eng_surface_render(e, e->root, 0, &clip, 0, 0, 0, 0);
    eng_present(e);
    dirty_clear(e->dirty);
}

static void render_timer_cb(EngineTimer *t, const TimerEvent *ev) {
    /* Z:0x41f1d0 -> Z:0x41b170 (first call: shell sounds, M5) -> Z:0x41b210 */
    (void)ev;
    eng_render((Engine *)t->ctx);
}

/* ------------------------------------------------------------------ applet manager */
static void write_vtables(Engine *e) {
    for (uint32_t i = 0; i < CPU_IF_COUNT; i++)
        for (uint32_t s = 0; s < CPU_ENGINE_SLOTS; s++)
            cpu_wr32(e->cpu, ENG_VT_LO + i * CPU_ENGINE_SLOTS * 4u + 4u * s, cpu_engine_thunk(i, s));
}

/* Engine-to-game call that cannot suspend (DllMain, Shell_StartApplet, Shell_StopApplet). */
static uint32_t top_call(Engine *e, uint32_t func, uint32_t nargs, const uint32_t *args, const char *what, bool trace) {
    if (trace) eng_trace_begin(e, what);
    uint32_t r = cpu_call(e->cpu, func, nargs, args, NULL);
    if (cpu_suspended(e->cpu)) eng_fail(e, "%s opened a modal dialog (not supported)", what);
    else if (cpu_fault(e->cpu)->kind != CPU_FAULT_NONE) eng_fail(e, "guest fault in %s: %s", what, cpu_fault(e->cpu)->text);
    if (trace) eng_trace_end(e);
    return r;
}

static int32_t load_game(Engine *e) {
    /* LoadLibraryA (Z:0x42467e): a fresh image of Moeboid.gam; DllMain(DLL_PROCESS_ATTACH). */
    Port *p = e->p;
    e->cpu = cpu_create();
    if (!e->cpu || cpu_machine_init(e->cpu, p->gam, p->gam_len, CPU_IMAGE_BASE, 0x00, 0x027f) != 0) {
        eng_fail(e, "game image: %s", e->cpu ? cpu_fault(e->cpu)->text : "out of memory");
        return -2;
    }
    e->delta = cpu_machine_base(e->cpu) - CPU_IMAGE_BASE;
    cpu_set_engine_dispatch(e->cpu, eng_dispatch, e);
    write_vtables(e);
    e->evrec_addr = cpu_machine_alloc_data(e->cpu, NULL, ENG_EVREC_MAX * 64u, 16);
    e->evrec_depth = 0;
    e->nwrap = 0;
    e->wrap_free = 0;
    e->dead = false;
    e->fault[0] = 0;
    uint32_t dll[3] = {cpu_machine_base(e->cpu), 1, 0};
    top_call(e, cpu_machine_entry(e->cpu), 3, dll, "DllMain(DLL_PROCESS_ATTACH)", true);
    if (e->dead) return -3;
    e->loaded = true;
    return 0;
}

static void unload_game(Engine *e) {
    /* FreeLibrary (Z:0x4248a0): the last reference goes, so the image is unmapped (DLL_PROCESS_DETACH);
     * the next LoadLibraryA maps a fresh image (README.md: DLL reload). */
    if (!e->cpu) return;
    if (e->loaded && !e->dead) {
        uint32_t dll[3] = {cpu_machine_base(e->cpu), 0, 0};
        top_call(e, cpu_machine_entry(e->cpu), 3, dll, "DllMain(DLL_PROCESS_DETACH)", false);
    }
    cpu_destroy(e->cpu);
    e->cpu = NULL;
    e->loaded = false;
}

int32_t engine_applet_start(Port *p) {
    /* Z:0x424620 Start */
    Engine *e = engine_of(p);
    if (!e || e->running) return 4;
    game_string(e, 5, e->owner_id, sizeof e->owner_id);
    game_string(e, 4, e->game_name, sizeof e->game_name);
    if (!e->owner_id[0]) rt_snprintf(e->owner_id, sizeof e->owner_id, "%s", "{2BFDD7F8-0EC4-4E7C-9FF4-3B2F8DC1D0F2}");
    if (!e->cpu) {
        int32_t r = load_game(e);
        if (r) return r;
    }
    if (!cpu_machine_export(e->cpu, "Shell_StartApplet")) {
        eng_fail(e, "Error - file specified in call to Start is NOT a game DLL!");
        return 4;
    }
    e->starts++;
    /* ctx: 0x1c bytes, own vtable Z:0x42ef20 */
    e->ctx = ENG_CTX_LO;
    cpu_mem_fill(e->cpu, e->ctx, 0, 0x1c);
    cpu_wr32(e->cpu, e->ctx, ENG_VT_LO + CPU_IF_ISHELL * CPU_ENGINE_SLOTS * 4u);
    /* ISystem object (Z:0x415df0): [1] = shell, [2] = event source (shell, 0x11), [3] = (shell, 0x10) */
    e->sysobj = ENG_CTX_LO + 0x40u;
    cpu_wr32(e->cpu, e->sysobj, ENG_VT_LO + CPU_IF_ISYSTEM * CPU_ENGINE_SLOTS * 4u);
    cpu_wr32(e->cpu, e->sysobj + 4u, e->root);
    e->sys_ch11 = eng_channel_new(e, e->root, 0x11, false);
    eng_addref_ext(eng_obj_get(e, e->sys_ch11, OT_CHANNEL));
    e->sys_ch10 = eng_channel_new(e, e->root, 0x10, false);
    eng_addref_ext(eng_obj_get(e, e->sys_ch10, OT_CHANNEL));
    cpu_wr32(e->cpu, e->sysobj + 8u, e->sys_ch11);
    cpu_wr32(e->cpu, e->sysobj + 12u, e->sys_ch10);
    cpu_wr32(e->cpu, e->ctx + 0x14, e->sysobj);
    e->w_settings = eng_wrap_new(e, CPU_IF_ISETTINGS, 0);
    cpu_wr32(e->cpu, e->ctx + 0x18, e->w_settings);
    e->w_factory = eng_wrap_new(e, CPU_IF_IFACTORY, 0); /* engine global DAT_0045cfd4 (Z:0x415020) */
    cpu_wr32(e->cpu, e->ctx + 0x10, e->w_factory);
    e->w_game = eng_wrap_new(e, CPU_IF_ISURFACE, e->game); /* no AddRef (interface.md 2.2) */
    cpu_wr32(e->cpu, e->ctx + 0x08, e->w_game);
    e->w_page = eng_wrap_new(e, CPU_IF_ISURFACE, e->page);
    cpu_wr32(e->cpu, e->ctx + 0x0c, e->w_page);
    /* trace ids in the order of mock.py make_ctx: ctx, ctx[2], ctx[3], ctx[4], ctx[5], ctx[6] */
    if (e->starts == 1) e->next_trace_id = 0;
    e->ctx_tid = ++e->next_trace_id;
    eng_trace_id_assign(e, e->w_game, CPU_IF_ISURFACE);
    eng_trace_id_assign(e, e->w_page, CPU_IF_ISURFACE);
    eng_trace_id_assign(e, e->w_factory, CPU_IF_IFACTORY);
    e->sys_tid = ++e->next_trace_id;
    eng_trace_id_assign(e, e->w_settings, CPU_IF_ISETTINGS);
    /* window title, session time, "GameStarted" telemetry: removed (no network, decision 5) */
    e->running = true; /* manager +4 */
    uint32_t ctx = e->ctx;
    top_call(e, cpu_machine_export(e->cpu, "Shell_StartApplet"), 1, &ctx, "Shell_StartApplet(ctx)", true);
    shell_applet_changed(p, true);
    return e->dead ? 5 : 0;
}

void engine_applet_stop(Port *p) {
    /* Z:0x4248a0 Stop */
    Engine *e = engine_of(p);
    if (!e || !e->cpu || !e->running) return;
    uint32_t ctx = e->ctx;
    if (!e->dead) top_call(e, cpu_machine_export(e->cpu, "Shell_StopApplet"), 1, &ctx, "Shell_StopApplet()", true);
    /* scalar deleting destructors: ctx[2], ctx[3] (wrapper only), ctx[5] (Z:0x415ec0 releases its
     * two event sources), ctx[6], ctx */
    eng_wrap_free(e, e->w_game);
    eng_wrap_free(e, e->w_page);
    EngObj *c11 = eng_obj_get(e, e->sys_ch11, OT_CHANNEL), *c10 = eng_obj_get(e, e->sys_ch10, OT_CHANNEL);
    if (c11) eng_release_ext(e, c11);
    if (c10) eng_release_ext(e, c10);
    e->sys_ch11 = e->sys_ch10 = 0;
    eng_wrap_free(e, e->w_settings);
    eng_wrap_free(e, e->w_factory);
    unload_game(e);
    e->running = false;
    e->ctx = e->sysobj = 0;
    shell_applet_changed(p, false);
}

/* Port only: free the objects that the stopped game made and never released (the game leaks its
 * sounds, some surfaces and images; about 2.5 MB per New Game). After Stop and the detach of every
 * child of ctx[2] and ctx[3] nothing can reach them, so freeing them has no visible effect. Fonts
 * stay (shared cache). */
static void sweep(Engine *e, uint32_t owner) {
    static const uint8_t order[] = {OT_SURFACE, OT_ANIM, OT_SEQ, OT_IMAGE, OT_TIMER, OT_SOUND, OT_LISTENER, OT_CHANNEL};
    if (!owner) return;
    for (uint32_t k = 0; k < sizeof order; k++)
        for (uint32_t i = 1; i <= e->nobj; i++) {
            EngObj *o = eng_obj_get(e, (e->gen[i] << 20) | i, order[k]);
            if (o && o->owner == owner) eng_obj_destroy(e, o);
        }
}

int32_t engine_new_game(Port *p) {
    /* Z:0x41c910 (engine part): page hidden, game shown (shell key) and cleared to its background
     * colour (Z:0x413e80), Stop, children of both surfaces detached (Z:0x414950), Start. */
    Engine *e = engine_of(p);
    if (!e) return 4;
    eng_surface_set_visible(e, e->page, false, 0);
    eng_surface_set_visible(e, e->game, true, e->shell_key);
    CImage *im = eng_image(e, eng_surface_image(e, e->game));
    if (im) {
        eng_image_changed(e, im->o.h);
        draw_clear(&im->img, im->bk_color);
    }
    uint32_t old = e->starts;
    if (e->running) engine_applet_stop(p);
    eng_surface_detach_all(e, e->page);
    eng_surface_detach_all(e, e->game);
    sweep(e, old);
    return engine_applet_start(p);
}

bool engine_applet_running(Port *p) {
    Engine *e = engine_of(p);
    return e && e->running;
}

void engine_applet_event(Port *p, int32_t arg) {
    Engine *e = engine_of(p);
    if (!e || e->dead || e->modal.active || e->shell_hold) return;
    eng_applet_event(e, arg);
    if (eng_unwinding(e)) {
        int32_t v[1] = {arg};
        eng_origin_suspended(e, FR_ORIGIN_APPEVENT, v, 1);
    }
}

const char *engine_caption(Port *p) { return engine_of(p) ? engine_of(p)->caption : ""; }
uint32_t engine_shell_buttons(Port *p) { return engine_of(p) ? engine_of(p)->shell_buttons : 0u; }
int32_t engine_game_in_progress(Port *p) { return engine_of(p) ? engine_of(p)->game_in_progress : 0; }

/* ------------------------------------------------------------------ input (WndProc Z:0x4040e0) */
static int32_t key_code(int32_t type, uint32_t vk, bool *drop) {
    /* Z:0x4269b0 */
    *drop = (type == 0xb && vk == 0xd);
    switch (vk) {
    case 0x08: return 0;
    case 0x09: return 2;
    case 0x0d: return 3;
    case 0x10: return 12;
    case 0x11: return 5;
    default: break;
    }
    if (type == 0xc) return 4;
    switch (vk) {
    case 0x23: return 11;
    case 0x24: return 10;
    case 0x25: return 6;
    case 0x26: return 8;
    case 0x27: return 7;
    case 0x28: return 9;
    case 0x2e: return 1;
    default: return -1;
    }
}

static void key_origin(Engine *e, int32_t type, uint32_t vk) {
    bool drop;
    int32_t code = key_code(type, vk, &drop);
    if (drop) return;
    eng_key_dispatch(e, type, code, vk);
    if (eng_unwinding(e)) {
        int32_t v[3] = {type, code, (int32_t)vk};
        eng_origin_suspended(e, FR_ORIGIN_KEY, v, 3);
    }
}

static void mouse_origin(Engine *e, int32_t type, int32_t x, int32_t y) {
    eng_mouse_event(e, type, x, y);
    if (eng_unwinding(e)) {
        int32_t v[3] = {type, x, y};
        eng_origin_suspended(e, FR_ORIGIN_MOUSE, v, 3);
    }
}

static void eng_input(Port *p, const PortInput *ev) {
    Engine *e = engine_of(p);
    if (!e) return;
    e->input_seq = ev->seq;
    if (e->modal.active || e->shell_hold || e->dead) return; /* a modal dialog owns the input (shell_api.h) */
    uint32_t kind = PORT_IN_KIND(ev->kind), btn = PORT_IN_BUTTON(ev->kind);
    switch (kind) {
    case PORT_IN_KEYDOWN:
        if (ev->a == 0x1b) {
            /* VK_ESCAPE: pause toggle of a running game (Z:0x41cb30); the minimise (video +0x38) is
             * removed (decision 8a). Not passed to the game. */
            if (e->running) shell_pause_toggle(p);
            return;
        }
        key_origin(e, 0xb, (uint32_t)ev->a & 0xffffu);
        break;
    case PORT_IN_KEYUP:
        if (ev->a == 0x1b) return;
        key_origin(e, 0xd, (uint32_t)ev->a & 0xffffu);
        break;
    case PORT_IN_CHAR:
        if (ev->a == 0x1b) return;
        key_origin(e, 0xc, (uint32_t)ev->a & 0xffffu);
        break;
    case PORT_IN_MOUSEMOVE: /* (short)x, (short)y; then SetCursor(current) */
        mouse_origin(e, 7, (int16_t)ev->a, (int16_t)ev->b);
        break;
    case PORT_IN_BUTTONDOWN: /* LOWORD, HIWORD (unsigned) */
        if (btn == 0) mouse_origin(e, 1, ev->a & 0xffff, ev->b & 0xffff);
        else if (btn == 2) mouse_origin(e, 4, ev->a & 0xffff, ev->b & 0xffff);
        break;
    case PORT_IN_BUTTONUP:
        if (btn == 0) mouse_origin(e, 2, ev->a & 0xffff, ev->b & 0xffff);
        else if (btn == 2) mouse_origin(e, 5, ev->a & 0xffff, ev->b & 0xffff);
        break;
    case PORT_IN_FOCUS_LOST:
        /* WM_ACTIVATE WA_INACTIVE: pause a running unpaused game (Z:0x41cb30), render once; the core
         * then stops the timer passes (inactive). */
        if (!timersys_is_paused(&p->timers) && e->running) shell_pause_toggle(p);
        eng_render(e);
        break;
    default: break;
    }
}

/* ------------------------------------------------------------------ init */
static int32_t eng_init(Port *p, const uint8_t *pack, uint32_t pack_len, const uint8_t *gam, uint32_t gam_len) {
    (void)gam;
    (void)gam_len;
    Engine *e = (Engine *)rt_calloc(1, sizeof(Engine));
    if (!e) return -1;
    e->dirty = (DirtyList *)rt_calloc(1, sizeof(DirtyList));
    if (!e->dirty) return -1;
    e->p = p;
    p->engine = e;
    e->smoothing = 1; /* decision 4b */
    e->shell_key = SHELL_KEY;
    if (pack && pack_len && mpack_open(&e->pack, pack, pack_len) == 0) {
        text_fonts_load(&e->fonts, &e->pack);
    } else {
        rt_log("engine: no resource pack");
    }
    /* sound subsystem Z:0x408e80: DirectSound ready (the host plays the commands); "Sound" setting */
    e->voices.ready = true;
    const char *snd = engine_prop_get(p, "Sound");
    e->voices.enabled = !snd || eng_str_ieq(snd, "true");
    for (uint32_t id = 1; id < PORT_SND_ID_END; id++) {
        uint32_t len = 0;
        const uint8_t *d = mpack_find(&e->pack, k_snd_entries[id], &len);
        if (d) snd_parse_wav(d, len, &e->voices.info[id]);
    }
    /* CShell (Z:0x41acb0) = root CSurface 800x572 opaque; Z:0x41d6c0: 50 ms render timer (started, then
     * run-while-paused), root cleared to #3333cc, ctx[2] and ctx[3] 500x420 opaque at (282, 50), ctx[3]
     * hidden, ctx[2] protected with the shell key. */
    e->root = eng_surface_new_blank(e, (int32_t)PORT_W, (int32_t)PORT_H, 0);
    timer_init(&e->render_timer, 0, 0x32, render_timer_cb, e);
    timer_start(&p->timers, &e->render_timer);
    timer_set_realtime(&e->render_timer, true);
    eng_image_clear(e, eng_surface_image(e, e->root), ENG_FRAME_BG);
    e->game = eng_surface_new_blank(e, ENG_GAME_W, ENG_GAME_H, 0);
    eng_surface_attach(e, e->root, e->game);
    eng_surface_set_loc(e, e->game, ENG_GAME_X, ENG_GAME_Y, 0);
    e->page = eng_surface_new_blank(e, ENG_GAME_W, ENG_GAME_H, 0);
    eng_surface_attach(e, e->root, e->page);
    eng_surface_set_loc(e, e->page, ENG_GAME_X, ENG_GAME_Y, 0);
    eng_surface_set_visible(e, e->page, false, 0);
    eng_surface_protect(e, e->game, 0, e->shell_key);
    shell_frame_build(p);
    if (!gam || !gam_len) {
        rt_log("engine: no game image");
        return 0;
    }
    int32_t r = engine_applet_start(p);
    if (r) rt_log("engine: applet start failed (%d): %s", r, e->fault);
    return 0;
}

void port_hooks_engine(PortHooks *h) {
    h->name = "engine";
    h->init = eng_init;
    h->input = eng_input;
}

/* ------------------------------------------------------------------ public API */
bool engine_paused(Port *p) { return timersys_is_paused(&p->timers); }
void engine_set_paused(Port *p, bool paused) { timersys_set_paused(&p->timers, paused); }
uint32_t engine_game_time_ms(Port *p) { return timersys_game_time(&p->timers); }

void engine_render(Port *p) {
    Engine *e = engine_of(p);
    if (e) eng_render(e);
}

void engine_invalidate(Port *p, int32_t x, int32_t y, int32_t w, int32_t h) {
    Engine *e = engine_of(p);
    if (e) dirty_add(e->dirty, x, y, w, h);
}

uint32_t engine_render_count(Port *p) { return engine_of(p) ? engine_of(p)->renders : 0u; }
uint32_t engine_root(Port *p) { return engine_of(p) ? engine_of(p)->root : 0u; }
uint32_t engine_game_surface(Port *p) { return engine_of(p) ? engine_of(p)->game : 0u; }
uint32_t engine_page_surface(Port *p) { return engine_of(p) ? engine_of(p)->page : 0u; }
uint32_t engine_shell_key(Port *p) { return engine_of(p) ? engine_of(p)->shell_key : 0u; }

static uint32_t api_ref(Engine *e, uint32_t h) {
    EngObj *o = eng_obj_get(e, h, OT_NONE);
    if (o) eng_addref_ext(o);
    return h;
}

uint32_t engine_surface_blank(Port *p, int32_t w, int32_t h, uint32_t flags) {
    Engine *e = engine_of(p);
    return e ? api_ref(e, eng_surface_new_blank(e, w, h, flags)) : 0u;
}

uint32_t engine_surface_gif(Port *p, const char *name, uint32_t flags) {
    Engine *e = engine_of(p);
    return e ? api_ref(e, eng_surface_new_gif(e, name, flags)) : 0u;
}

int32_t engine_surface_attach(Port *p, uint32_t parent, uint32_t child) {
    Engine *e = engine_of(p);
    return e ? eng_surface_attach(e, parent, child) : 0;
}

int32_t engine_surface_detach(Port *p, uint32_t parent, uint32_t child) {
    Engine *e = engine_of(p);
    return e ? eng_surface_detach(e, parent, child) : 0;
}

void engine_surface_detach_all(Port *p, uint32_t s) {
    Engine *e = engine_of(p);
    if (e) eng_surface_detach_all(e, s);
}

int32_t engine_surface_set_loc(Port *p, uint32_t s, int32_t x, int32_t y, uint32_t key) {
    Engine *e = engine_of(p);
    return e ? eng_surface_set_loc(e, s, x, y, key) : 0;
}

int32_t engine_surface_set_visible(Port *p, uint32_t s, bool visible, uint32_t key) {
    Engine *e = engine_of(p);
    return e ? eng_surface_set_visible(e, s, visible, key) : 0;
}

uint32_t engine_surface_image(Port *p, uint32_t s) {
    Engine *e = engine_of(p);
    return e ? eng_surface_image(e, s) : 0u;
}

int32_t engine_surface_play(Port *p, uint32_t s) {
    Engine *e = engine_of(p);
    CSurface *sf = e ? eng_surface(e, s) : NULL;
    return sf ? eng_anim_start(e, sf->anim) : 0;
}

void engine_release(Port *p, uint32_t h) {
    Engine *e = engine_of(p);
    EngObj *o = e ? eng_obj_get(e, h, OT_NONE) : NULL;
    if (o) eng_release_ext(e, o);
}

Image *engine_image_pixels(Port *p, uint32_t img) {
    Engine *e = engine_of(p);
    CImage *im = e ? eng_image(e, img) : NULL;
    return im ? &im->img : NULL;
}

void engine_image_changed(Port *p, uint32_t img) {
    Engine *e = engine_of(p);
    if (e) eng_image_changed(e, img);
}

typedef struct ApiButton {
    EngineButtonFn fn;
    void *ctx;
} ApiButton;

static uint32_t api_button_cb(Engine *e, void *ctx, EvRec *rec) {
    ApiButton *b = (ApiButton *)ctx;
    if (b && b->fn) b->fn(e->p, b->ctx, (int32_t)rec->w[2]);
    return 0;
}

uint32_t engine_button(Port *p, uint32_t parent, int32_t x, int32_t y, int32_t w, int32_t h, uint32_t faces_img,
                       int32_t face_index, int32_t id, EngineButtonFn cb, void *ctx) {
    Engine *e = engine_of(p);
    if (!e) return 0;
    ApiButton *b = (ApiButton *)rt_calloc(1, sizeof *b); /* lives as long as the engine (shell buttons) */
    if (!b) return 0;
    b->fn = cb;
    b->ctx = ctx;
    return api_ref(e, eng_button_new(e, parent, 0, x, y, w, h, faces_img, face_index, id, 0, api_button_cb, b));
}

uint32_t engine_test_live_objects(Port *p) { return engine_of(p) ? engine_of(p)->live : 0u; }
const char *engine_fault_text(Port *p) { return engine_of(p) ? engine_of(p)->fault : ""; }
struct Cpu *engine_cpu(Port *p) { return engine_of(p) ? engine_of(p)->cpu : NULL; }

bool engine_test_button_point(Port *p, const char *label, int32_t *px, int32_t *py) {
    Engine *e = engine_of(p);
    if (!e) return false;
    uint32_t best = 0;
    for (uint32_t i = 1; i <= e->nobj; i++) {
        EngObj *o = eng_obj_get(e, (e->gen[i] << 20) | i, OT_SURFACE);
        if (!o) continue;
        CSurface *s = (CSurface *)o;
        if (!s->is_button || !s->parent) continue;
        bool found = false;
        size_t ll = rt_strlen(label);
        for (size_t k = 0; s->label[k] && !found; k++)
            if (rt_strncmp(s->label + k, label, ll) == 0) found = true;
        if (found && (best == 0 || s->o.serial > eng_surface(e, best)->o.serial)) best = s->o.h;
    }
    if (!best) return false;
    CSurface *s = eng_surface(e, best);
    int32_t ax = s->x, ay = s->y, w, h;
    for (CSurface *q = eng_surface(e, s->parent); q; q = eng_surface(e, q->parent)) {
        ax += q->x;
        ay += q->y;
    }
    eng_surface_size(e, best, &w, &h);
    /* scan the button area from its centre outwards for a point whose hit test gives the button */
    for (int32_t r = 0; r < w + h; r++)
        for (int32_t dy = -r; dy <= r; dy++)
            for (int32_t dx = -r; dx <= r; dx++) {
                if (dx != -r && dx != r && dy != -r && dy != r) continue;
                int32_t x = ax + w / 2 + dx, y = ay + h / 2 + dy;
                uint32_t hit = 0;
                eng_surface_hit(e, e->root, x, y, &hit);
                if (hit == best) {
                    *px = x;
                    *py = y;
                    return true;
                }
            }
    return false;
}
