/* Internal definitions of the engine (M4). Other modules use engine.h.
 *
 * Object model (analysis/interface.md 3): every engine object has an external (+4) and an internal
 * (+8) reference count (Z:0x414f70, Z:0x414f80, Z:0x414f90, Z:0x414fc0) and is freed when both are 0.
 * Objects live in host memory and are named by a handle (generation << 20 | index); the guest sees
 * 8-byte wrappers {vtable, handle} in the fake-object region (port-design.md section 4). */
#ifndef MOEBOID_ENGINE_ENG_INT_H
#define MOEBOID_ENGINE_ENG_INT_H

#include "../core/port.h"
#include "../cpu/cpu.h"
#include "../gfx/dirty.h"
#include "../gfx/draw.h"
#include "../gfx/gif.h"
#include "../snd/snd.h"
#include "../text/atlas.h"
#include "../text/gdi_text.h"
#include "engine.h"

/* ------------------------------------------------------------------ handle lists */
/* Growable array of handles with the append / remove-first-match-and-shift rules of the engine's
 * CArray-like lists (for example Z:0x414780 append, Z:0x4147f0 remove). */
typedef struct HList {
    uint32_t *v;
    int32_t n, cap;
} HList;

void hl_push(HList *l, uint32_t h);
bool hl_remove(HList *l, uint32_t h); /* false when absent */
int32_t hl_find(const HList *l, uint32_t h);
void hl_free(HList *l);

/* ------------------------------------------------------------------ objects */
enum {
    OT_NONE = 0,
    OT_SURFACE,  /* CSurface, vtable Z:0x42eab8 (button: Z:0x42ee58) */
    OT_ANIM,     /* animation player, vtable Z:0x42ec78 */
    OT_SEQ,      /* CImageSeq, vtable Z:0x42ec64 */
    OT_IMAGE,    /* CImage, vtable Z:0x42eaa4 */
    OT_FONT,     /* font, vtable Z:0x42f0dc */
    OT_TIMER,    /* timer, vtable Z:0x42ea40 */
    OT_SOUND,    /* sound, vtable Z:0x42e860 */
    OT_LISTENER, /* event listener, vtable Z:0x42ef88 */
    OT_CHANNEL,  /* event channel (source, type), vtable Z:0x42f0a0 */
    OT_COUNT
};

typedef struct EngObj {
    uint8_t type;
    uint8_t dying;  /* destructor running */
    uint32_t serial; /* creation order (port) */
    uint32_t owner;  /* applet start number when the game made it (port: sweep at New Game), 0 engine/shell */
    int32_t ext; /* +4 */
    int32_t in;  /* +8 */
    uint32_t h;  /* own handle */
} EngObj;

typedef struct CImage {
    EngObj o;
    Image img;           /* render target pixels (Z:0x40b950) */
    uint8_t keyed;       /* +0x1c */
    uint8_t transparent; /* +0x1d T flag (ZML <T>), 1 at construction */
    uint8_t centre;      /* +0x24 */
    uint8_t shadow;      /* +0x25 */
    uint32_t font;       /* +0x28 current font (handle, internal reference) */
    uint32_t pen;        /* render target +0x1f..+0x21 pen and brush colour (pixel) */
    uint32_t text_color; /* render target +0x38 (pixel) */
    uint32_t bk_color;   /* render target +0x34 (pixel) */
    HList seqs;          /* +0x2c..+0x34 sequences that hold this image */
    HList links;         /* +0x10..+0x14, count +0x0c: ZML hyperlink surfaces (engine ZML only) */
    char label[96];      /* port test aid: DrawText strings drawn into the image (mock.py button label) */
} CImage;

typedef struct CSeq {
    EngObj o;
    HList images;        /* +0x0c..+0x14 (internal references) */
    uint32_t *delays;    /* +0x18..+0x1c ms per image */
    int32_t ndelays, cap_delays;
    uint8_t *slots;      /* +0x24 50 ms slot table (Z:0x4171b0) */
    int32_t nslots;      /* +0x20 */
    uint8_t loop;        /* +0x28 NETSCAPE2.0 */
    HList anims;         /* +0x2c..+0x34 animation players using this sequence */
} CSeq;

typedef struct CAnim {
    EngObj o;
    uint8_t realtime;    /* +0x0c real clock instead of the game clock (Z:0x4177d0) */
    uint32_t seq;        /* +0x10 (internal reference) */
    uint32_t img;        /* +0x14 current image (no reference) */
    uint8_t autodelete;  /* +0x18 */
    EngineTimer timer;   /* +0x1c 50 ms frame timer (Z:0x413440(this, 0x32, Z:0x417850)) */
    uint32_t start;      /* +0x20 clock value of StartAnim */
    HList surfaces;      /* +0x24..+0x2c surfaces that show this player */
} CAnim;

typedef void (*EngCFn)(Engine *e, uint32_t surface, void *ctx);

typedef struct CSurface {
    EngObj o;
    uint8_t nohit;       /* +0x0c (Z:0x4177f0 skipped by the hit test) */
    uint8_t visible;     /* +0x0d */
    HList children;      /* +0x10..+0x18 */
    uint32_t parent;     /* +0x1c */
    int32_t x, y;        /* +0x20, +0x24 */
    HList anims;         /* +0x28..+0x30 (internal references) */
    uint32_t anim;       /* +0x34 current animation player */
    uint32_t key;        /* +0x38 protect key */
    int32_t cursor;      /* +0x3c cursor id, -1 none */
    uint32_t ch_enter;   /* +0x40 channel (this, 8) */
    uint32_t ch_leave;   /* +0x44 channel (this, 9) */
    /* button (vtable Z:0x42ee58, ctor Z:0x419730) */
    uint8_t is_button;
    int32_t button_id;   /* +0x58 */
    uint32_t ch_activate; /* +0x5c channel (this, 0xe) */
    uint32_t l_click, l_enter, l_leave, l_game; /* +0x60, +0x64, +0x68, +0x70 */
    char label[96];      /* port test aid: label text of the faces image */
} CSurface;

typedef struct CFont {
    EngObj o;
    char face[64];       /* +0x1c copy of the CreateFont argument */
    int32_t px;          /* +0x20 */
    int32_t index;       /* +0x24 size class (always 0, fonts.md 3.1) */
    uint32_t style;      /* +0x28 bit0 bold, bit1 italic, bit2 underline, bit3 strikeout */
    int32_t ave_w;       /* +0x0c tmAveCharWidth */
    int32_t line_h;      /* +0x10 tmHeight + tmExternalLeading */
    int32_t space_w;     /* +0x14 */
    int32_t dot_w;       /* +0x18 */
    bool ok;             /* port: an atlas exists */
    GdiFont gdi;         /* +0x2c HFONT */
} CFont;

typedef struct CTimer {
    EngObj o;
    EngineTimer t;       /* core timer (period, last, start, started, userdata, realtime) */
    uint32_t guest_cb;   /* +0x1c game callback (cdecl cb(e)) */
} CTimer;

typedef struct CSound {
    EngObj o;
    uint32_t sound_id;   /* PORT_SND_* (sound_ids.h); +0x0c buffer */
    uint8_t flag;        /* +0x10 */
    int32_t count;       /* +0x14 repeat count */
} CSound;

/* Event record of a listener call (Z:0x427b10): w[0] userdata, w[1] listener value, then the
 * source-specific words (key: wParam, type, key code; mouse: local x, y; button: id). */
typedef struct EvRec {
    uint32_t w[8];
} EvRec;

/* C listener callback (engine and shell listeners). Returns the listener result: 0 stops the
 * dispatch (Z:0x427750). */
typedef uint32_t (*EngListenFn)(Engine *e, void *ctx, EvRec *rec);

typedef struct CListener {
    EngObj o;
    uint32_t channel;    /* +0x0c */
    uint32_t guest_cb;   /* +0x10 game callback, 0 for a C callback */
    uint32_t value;      /* +0x14 (SetValue Z:0x427b60) */
    uint32_t user;       /* +0x18 */
    EngListenFn cfn;
    void *cctx;
} CListener;

typedef struct CChannel {
    EngObj o;
    HList listeners;     /* +0x0c..+0x14 */
    uint32_t source;     /* +0x18 surface handle */
    int32_t type;        /* +0x1c */
    uint8_t autodel;     /* +0x20 delete when the last listener goes (Z:0x427810) */
} CChannel;

/* ------------------------------------------------------------------ wrappers */
#define ENG_WRAP_LO (CPU_FAKE_LO + 0x00010000u)
#define ENG_WRAP_HI (CPU_FAKE_LO + 0x00800000u)
#define ENG_VT_LO (CPU_FAKE_LO + 0x00800000u) /* 13 vtables of CPU_ENGINE_SLOTS thunks */
#define ENG_CTX_LO (CPU_FAKE_LO + 0x00000100u) /* ctx (0x1c bytes) and the ISystem object (0x10) */

typedef struct WrapSlot {
    uint32_t trace_id; /* mock.py object number (#id) */
    uint8_t iface;     /* CPU_IF_* */
    uint8_t live;
    uint32_t next_free;
} WrapSlot;

/* ------------------------------------------------------------------ suspend / resume */
enum { RS_NONE = 0, RS_UNWIND = 1, RS_REWIND = 2 };
enum {
    FR_ORIGIN_TIMER = 1, /* v0 = timer handle (game timer) */
    FR_ORIGIN_KEY,       /* v0..v2 = type, key code, wParam */
    FR_ORIGIN_MOUSE,     /* v0..v2 = type, x, y */
    FR_ORIGIN_APPEVENT,  /* v0 = argument of Z:0x424aa0 */
    FR_KEYDISP,          /* Z:0x425870 loop: v0 = channel index */
    FR_MOUSE,            /* Z:0x425020: v0 phase, v1 index, v2 hit, v3 lx, v4 ly, v5 flags, v6 r */
    FR_FIRE              /* Z:0x427750: v0 channel handle, v1 listener index, rec */
};
#define ENG_MAX_FRAMES 16

typedef struct EngFrame {
    uint32_t kind;
    int32_t v[8];
    EvRec rec;
} EngFrame;

typedef struct EngModal {
    bool active;           /* the guest waits for a dialog */
    uint32_t kind;         /* SHELL_DLG_* */
    uint32_t out_addr;     /* InputBox output buffer (guest) */
    int32_t out_len;       /* InputBox size argument */
    bool saved_paused;     /* IsPaused before the dialog (Z:0x405480, Z:0x4058c0) */
    bool trace_pending;    /* the call line waits for the result */
    char line[600];
} EngModal;

/* ------------------------------------------------------------------ engine */
#define ENG_EVREC_MAX 32

struct Engine {
    Port *p;
    MPack pack;
    TextFonts fonts;
    int32_t smoothing;   /* decision 4b: greyscale text where gasp allows it */
    Cpu *cpu;
    uint32_t delta;      /* image base - preferred base */
    bool dead;           /* a guest fault stopped the applet */
    char fault[240];

    /* objects */
    EngObj **obj;
    uint32_t *gen;       /* generation per index */
    uint32_t nobj, capobj;
    uint32_t free_head;  /* free index list through obj[] slots (0 = none) */
    uint32_t serial;
    uint32_t alloc_owner; /* owner of new objects: e->starts inside a game call, else 0 */
    uint32_t live;

    /* wrappers */
    WrapSlot *wrap;
    uint32_t nwrap, capwrap, wrap_free;
    uint32_t next_trace_id;

    /* video, shell root, applet surfaces */
    DirtyList *dirty;
    uint32_t root;       /* shell root surface (CShell is a CSurface, Z:0x41acb0) */
    uint32_t game;       /* shell +0x2c8 = ctx[2] */
    uint32_t page;       /* shell +0x2cc = ctx[3] */
    uint32_t shell_key;  /* protect key of ctx[2] (shell pointer in the original) */
    EngineTimer render_timer; /* Z:0x41d7c9: 50 ms, run while paused */
    uint32_t renders;
    bool render_started;

    /* fonts: cache of Z:0x426070 (internal references) */
    HList font_cache;

    /* events (event manager DAT_0045cfc0, Z:0x424c00) */
    HList channels;      /* +0x04 count, +0x18 array */
    uint32_t hover;      /* +0x08 */
    uint32_t pressed;    /* +0x0c */
    int32_t mouse_x, mouse_y; /* +0x20, +0x24 */
    uint32_t last_hit;   /* DAT_0045e878 */
    bool hit_destroyed;  /* DAT_0045e87c */
    uint32_t evrec_addr; /* guest records, ENG_EVREC_MAX x 64 bytes */
    int32_t evrec_depth;

    /* sound */
    SndVoices voices;

    /* applet (applet manager DAT_0045cfc8) */
    bool running;        /* manager +4 */
    bool loaded;         /* game image mapped (LoadLibraryA done) */
    uint32_t ctx;        /* ctx guest address */
    uint32_t sysobj;     /* ISystem object (0x10 bytes) */
    uint32_t w_game, w_page, w_factory, w_settings;
    uint32_t sys_ch11, sys_ch10; /* ISystem channels (shell, 0x11) and (shell, 0x10) */
    char owner_id[64];   /* game string 5 (GUID) */
    char game_name[64];  /* game string 4 */
    char caption[256];   /* shell +0x88 */
    uint32_t shell_buttons; /* shell +0x378 */
    int32_t game_in_progress; /* shell +0x37c */
    uint32_t starts;     /* applet starts (New Game count + 1) */
    uint32_t ctx_tid, sys_tid; /* trace ids of ctx and of the ISystem object (mock.py #1, #5) */
    uint32_t sounds_by_name[PORT_SND_ID_END]; /* platform sound objects of engine_play_sound */

    /* modal suspend / resume */
    int32_t rs;
    EngFrame frames[ENG_MAX_FRAMES];
    int32_t nframes;
    uint32_t resume_eax;
    EngModal modal;
    char test_answers[8][64]; /* test aid: InputBox answers (FIFO) */
    int32_t n_answers;
    bool test_auto_dialogs;   /* test aid: dialogs close at once (answers above), shell not asked */
    bool shell_hold;          /* a shell-opened modal dialog runs (engine_modal_hold) */

    /* trace */
    bool tick_open;
    bool in_input;       /* an input event is being delivered (for ShellDialog.input_seq) */
    uint32_t input_seq;

    GifWork gifwork;
};

/* ---- object table (eng_obj.c) ---- */
EngObj *eng_obj_new(Engine *e, uint8_t type, uint32_t size);
EngObj *eng_obj_get(Engine *e, uint32_t h, uint8_t type); /* NULL when stale or another type */
void eng_obj_destroy(Engine *e, EngObj *o);
static inline void eng_addref_ext(EngObj *o) { o->ext++; }   /* Z:0x414f70 */
static inline void eng_addref_int(EngObj *o) { o->in++; }    /* Z:0x414f80 */
int32_t eng_release_ext(Engine *e, EngObj *o);               /* Z:0x414f90 */
int32_t eng_release_int(Engine *e, EngObj *o);               /* Z:0x414fc0 */
uint32_t eng_release_int_h(Engine *e, uint32_t h);
#define ENG_GET(e, h, T, ot) ((T *)eng_obj_get((e), (h), (ot)))

/* ---- wrappers (eng_obj.c) ---- */
uint32_t eng_wrap_new(Engine *e, uint32_t iface, uint32_t handle); /* guest address, 0 if full */
void eng_wrap_free(Engine *e, uint32_t addr);
uint32_t eng_wrap_handle(Engine *e, uint32_t addr);               /* [addr + 4] */
const WrapSlot *eng_wrap_slot(const Engine *e, uint32_t addr);   /* NULL if not a live wrapper */
uint32_t eng_trace_id_assign(Engine *e, uint32_t addr, uint32_t iface);

/* ---- graphics objects (eng_gfx.c) ---- */
uint32_t eng_image_new(Engine *e, int32_t w, int32_t h, bool keyed);            /* Z:0x4138f0 */
uint32_t eng_image_new_cell(Engine *e, uint32_t src, int32_t index, int32_t w, int32_t h); /* Z:0x413a00 */
void eng_image_changed(Engine *e, uint32_t img);                                 /* Z:0x414120 */
int32_t eng_image_draw(Engine *e, uint32_t target, const DrawRect *dst, uint32_t src, const DrawRect *srect); /* Z:0x413f30 */
int32_t eng_image_draw_at(Engine *e, uint32_t target, uint32_t src, int32_t x, int32_t y); /* Z:0x413f00 */
int32_t eng_image_set_font(Engine *e, uint32_t img, uint32_t font);              /* Z:0x413f80 */
int32_t eng_image_clear(Engine *e, uint32_t img, uint32_t rgb);                  /* Z:0x413dd0 */
int32_t eng_image_text(Engine *e, uint32_t img, const char *s, int32_t n, int32_t x, int32_t y); /* Z:0x413c30 */
int32_t eng_image_measure(Engine *e, uint32_t img, uint32_t font, const char *s, int32_t n, int32_t *cx, int32_t *cy); /* Z:0x414030 */
uint32_t eng_seq_new_image(Engine *e, uint32_t img);                             /* Z:0x416c30 */
uint32_t eng_seq_new_gif(Engine *e, const char *name);                           /* Z:0x416d00 */
void eng_seq_add(Engine *e, uint32_t seq, uint32_t img, uint32_t delay);         /* Z:0x416e80 */
int32_t eng_seq_get(Engine *e, uint32_t seq, int32_t index, uint32_t *img);     /* Z:0x417060 */
uint32_t eng_anim_new(Engine *e, uint32_t seq);                                  /* Z:0x4173f0 */
int32_t eng_anim_start(Engine *e, uint32_t anim);                                /* Z:0x4176f0 */
int32_t eng_anim_stop(Engine *e, uint32_t anim);                                 /* Z:0x417740 */
void eng_anim_set_frame(Engine *e, uint32_t anim, int32_t index);                /* Z:0x417560 */
uint32_t eng_surface_new_blank(Engine *e, int32_t w, int32_t h, uint32_t flags); /* Z:0x414190 */
uint32_t eng_surface_new_gif(Engine *e, const char *name, uint32_t flags);       /* Z:0x414330 */
uint32_t eng_surface_new_anim(Engine *e, uint32_t anim, uint32_t flags);         /* Z:0x414470 */
uint32_t eng_button_new(Engine *e, uint32_t parent, uint32_t user, int32_t x, int32_t y, int32_t w, int32_t h,
                        uint32_t faces, int32_t index, int32_t id, uint32_t guest_cb, EngListenFn cfn, void *cctx); /* Z:0x419730 */
void eng_surface_invalidate(Engine *e, uint32_t s);                               /* Z:0x414ef0 */
int32_t eng_surface_set_loc(Engine *e, uint32_t s, int32_t x, int32_t y, uint32_t key); /* Z:0x4146a0 */
int32_t eng_surface_set_visible(Engine *e, uint32_t s, bool v, uint32_t key);    /* Z:0x414720 */
int32_t eng_surface_attach(Engine *e, uint32_t parent, uint32_t child);          /* Z:0x414780 */
int32_t eng_surface_detach(Engine *e, uint32_t parent, uint32_t child);          /* Z:0x4147f0 */
void eng_surface_detach_all(Engine *e, uint32_t s);                              /* Z:0x414950 */
int32_t eng_surface_protect(Engine *e, uint32_t s, uint32_t old_key, uint32_t key); /* Z:0x414ca0 */
uint32_t eng_surface_image(Engine *e, uint32_t s);                               /* Z:0x414c40 */
void eng_surface_size(Engine *e, uint32_t s, int32_t *w, int32_t *h);            /* Z:0x414c70 */
void eng_surface_hit(Engine *e, uint32_t s, int32_t x, int32_t y, uint32_t *out); /* Z:0x414a00 */
void eng_surface_render(Engine *e, uint32_t s, uint32_t target, const DrawRect *clip, int32_t x, int32_t y,
                        int32_t px, int32_t py);                                  /* Z:0x414cd0 */
uint32_t eng_font_create(Engine *e, const char *face, int32_t px, uint32_t style); /* Z:0x426070 */
CImage *eng_image(Engine *e, uint32_t h);
CSurface *eng_surface(Engine *e, uint32_t h);

/* ---- events (eng_event.c) ---- */
uint32_t eng_channel_new(Engine *e, uint32_t source, int32_t type, bool autodel); /* Z:0x427600 via Z:0x424da0 / Z:0x424e30 */
uint32_t eng_listener_add(Engine *e, uint32_t source, int32_t type, uint32_t user, uint32_t guest_cb,
                          EngListenFn cfn, void *cctx);                            /* Z:0x424c70 */
void eng_listener_set_value(Engine *e, uint32_t l, uint32_t v);                   /* Z:0x427b60 */
uint32_t eng_fire(Engine *e, uint32_t channel, EvRec *rec);                       /* Z:0x427750 */
void eng_key_dispatch(Engine *e, int32_t type, int32_t keycode, uint32_t wparam); /* Z:0x425870 */
void eng_mouse_event(Engine *e, int32_t type, int32_t x, int32_t y);             /* Z:0x425020 */
void eng_surface_destroyed(Engine *e, uint32_t s);                                /* Z:0x424fb0 */
void eng_channel_removed(Engine *e, uint32_t ch);                                 /* Z:0x424ee0 */
uint32_t eng_applet_event(Engine *e, int32_t arg);                                /* Z:0x424aa0 */
void eng_set_cursor(Engine *e, int32_t id);

/* ---- guest calls, suspend and resume (eng_modal.c) ---- */
enum { GC_OK = 0, GC_SUSPENDED = 1, GC_FAULT = 2 };
/* cdecl cb(rec) in one trace tick; words are written to a guest event record. */
uint32_t eng_guest_call(Engine *e, uint32_t func, const uint32_t *words, uint32_t nwords, const char *what);
void eng_frame_push(Engine *e, uint32_t kind, const int32_t *v, int32_t nv, const EvRec *rec);
EngFrame *eng_frame_pop(Engine *e, uint32_t kind);  /* top frame; NULL (and an error) on mismatch */
static inline bool eng_unwinding(const Engine *e) { return e->rs == RS_UNWIND; }
static inline bool eng_rewinding(const Engine *e) { return e->rs == RS_REWIND; }
uint32_t eng_modal_dialog(Engine *e, uint32_t kind, const char *title, const char *text, const char *def,
                          uint32_t out, int32_t out_len, uint32_t flags);
void eng_fail(Engine *e, const char *fmt, ...) __attribute__((format(printf, 2, 3)));
/* An origin (timer callback, key or mouse dispatch, applet event) saw RS_UNWIND: push its frame,
 * end the unwind, stop the timer passes. */
void eng_origin_suspended(Engine *e, uint32_t kind, const int32_t *v, int32_t nv);
void eng_modal_strings(Engine *e, uint32_t a, char *out, uint32_t cap);

/* ---- dispatch and trace (eng_dispatch.c, eng_trace.c) ---- */
uint32_t eng_dispatch(void *ctx, uint32_t iface, uint32_t slot, uint32_t self, uint32_t args);
void eng_trace_begin(Engine *e, const char *what);
void eng_trace_end(Engine *e);
void eng_trace_call(Engine *e, uint32_t iface, uint32_t slot, uint32_t self, uint32_t args, uint32_t ret,
                    char *line, uint32_t cap, bool pending);
void eng_trace_finish_line(Engine *e, char *line, uint32_t ret);
extern const uint32_t eng_callsites[];
extern const uint32_t eng_callsite_count;

/* ---- engine services (engine.c) ---- */
void eng_render(Engine *e);                  /* Z:0x41b210 */
void eng_present(Engine *e);                 /* video +0x34 */
uint32_t eng_game_time(Engine *e);           /* Z:0x427510 */
uint32_t eng_real_time(Engine *e);           /* Z:0x4274f0 */
const uint8_t *eng_resource(Engine *e, const char *name, uint32_t *len); /* RT_RCDATA: ZapSpot.exe, then the game */
uint32_t eng_sound_load(Engine *e, const char *name, uint32_t flag); /* Z:0x409030; 0 when sound is off */
int32_t eng_sound_play(Engine *e, uint32_t snd, int32_t count);       /* Z:0x40c510 */
int32_t eng_prop_get_game(Engine *e, const char *name, char *out, uint32_t cap); /* Z:0x4294f0 */
void eng_prop_set_game(Engine *e, const char *name, const char *value);          /* Z:0x429710 */
bool eng_str_ieq(const char *a, const char *b); /* lstrcmpiA == 0 for ASCII */

#endif
