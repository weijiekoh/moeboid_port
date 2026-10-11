/* Guest calls, modal dialogs and the suspend/resume of engine passes (M4).
 *
 * ISystem::MessageBox (Z:0x4058c0) and ISystem::InputBox (Z:0x405480) run a modal loop in the
 * original and return the dialog result to the game. The port cannot block: the dispatch of these
 * methods opens the dialog through shell_api.h and suspends the interpreter (cpu_suspend) at the
 * return point of the call. Every engine loop between the origin (timer pass, key or mouse dispatch,
 * applet event) and the game callback then saves its position in a frame (RS_UNWIND) and returns.
 * engine_dialog_done rewinds: the origin and every loop pop their frames (RS_REWIND) and call inward
 * again at the saved position; the innermost guest call resumes the interpreter with EAX = result.
 * After that the loops continue as if the call had returned at once. README.md has the details. */
#include "eng_int.h"
#include "shell_api.h"

void eng_fail(Engine *e, const char *fmt, ...) {
    rt_va_list ap;
    rt_va_start(ap, fmt);
    rt_vsnprintf(e->fault, sizeof e->fault, fmt, ap);
    rt_va_end(ap);
    rt_log("engine: %s", e->fault);
    e->dead = true;
}

void eng_frame_push(Engine *e, uint32_t kind, const int32_t *v, int32_t nv, const EvRec *rec) {
    if (e->nframes >= ENG_MAX_FRAMES) {
        eng_fail(e, "suspend: too many frames");
        return;
    }
    EngFrame *f = &e->frames[e->nframes++];
    rt_memset(f, 0, sizeof *f);
    f->kind = kind;
    for (int32_t i = 0; i < nv && i < 8; i++) f->v[i] = v[i];
    if (rec) f->rec = *rec;
}

EngFrame *eng_frame_pop(Engine *e, uint32_t kind) {
    if (e->nframes <= 0 || e->frames[e->nframes - 1].kind != kind) {
        eng_fail(e, "rewind: expected frame %u, found %u", kind, e->nframes > 0 ? e->frames[e->nframes - 1].kind : 0u);
        e->rs = RS_NONE;
        return NULL;
    }
    return &e->frames[--e->nframes];
}

uint32_t eng_guest_call(Engine *e, uint32_t func, const uint32_t *words, uint32_t nwords, const char *what) {
    uint32_t eax;
    if (e->dead) return 0;
    if (eng_rewinding(e)) {
        /* innermost level of the rewind: continue the suspended game call */
        if (e->nframes != 0) {
            eng_fail(e, "rewind: %d frames left at the guest call", e->nframes);
            return 0;
        }
        e->rs = RS_NONE;
        eax = cpu_resume(e->cpu, e->resume_eax);
    } else {
        if (cpu_suspended(e->cpu)) {
            rt_log("engine: guest call %08x refused while a call is suspended", func);
            return 0;
        }
        if (e->evrec_depth >= ENG_EVREC_MAX) {
            eng_fail(e, "event records exhausted");
            return 0;
        }
        uint32_t rec = e->evrec_addr + (uint32_t)e->evrec_depth * 64u;
        uint32_t buf[16] = {0};
        for (uint32_t i = 0; i < nwords && i < 16; i++) buf[i] = words[i];
        cpu_mem_write(e->cpu, rec, buf, sizeof buf);
        if (e->evrec_depth == 0) eng_trace_begin(e, what);
        e->evrec_depth++;
        eax = cpu_call_cdecl(e->cpu, func, 1, &rec);
    }
    if (cpu_suspended(e->cpu)) {
        e->rs = RS_UNWIND; /* the record and the trace tick stay open */
        return 0;
    }
    e->evrec_depth--;
    const CpuFault *f = cpu_fault(e->cpu);
    if (f->kind != CPU_FAULT_NONE) {
        eng_fail(e, "guest fault in %s: %s", what ? what : "callback", f->text);
        return 0;
    }
    if (e->evrec_depth == 0) eng_trace_end(e);
    return eax;
}

/* ------------------------------------------------------------------ modal dialogs */
static void copy_guest_str(Engine *e, uint32_t addr, char *out, uint32_t cap) {
    uint32_t i = 0;
    if (addr)
        for (; i + 1 < cap; i++) {
            uint8_t b = 0;
            if (!cpu_mem_read(e->cpu, addr + i, &b, 1) || !b) break;
            out[i] = (char)b;
        }
    out[i] = 0;
}

/* InputBox OK: GetDlgItemTextA(dlg, 0x3eb, out, size) copies at most size - 1 characters (Z:0x405004). */
static void write_input_text(Engine *e, const char *text) {
    if (!e->modal.out_addr || e->modal.out_len <= 0) return;
    uint32_t n = 0, max = (uint32_t)e->modal.out_len - 1u;
    if (text)
        while (text[n] && n < max) n++;
    cpu_mem_write(e->cpu, e->modal.out_addr, text, n);
    cpu_mem_write(e->cpu, e->modal.out_addr + n, "", 1);
}

static uint32_t dialog_result(Engine *e, uint32_t kind, int32_t res) {
    if (kind == SHELL_DLG_MESSAGEBOX) {
        /* Z:0x405928: IDOK -> 1, IDCANCEL -> 2, else 0 */
        if (res == 1) return 1;
        return res == 2 ? 2u : 0u;
    }
    /* Z:0x404f60 sets DAT_004362e8: OK 1, Cancel 2 */
    (void)e;
    return (uint32_t)res;
}

uint32_t eng_modal_dialog(Engine *e, uint32_t kind, const char *title, const char *text, const char *def,
                          uint32_t out, int32_t out_len, uint32_t flags) {
    Port *p = e->p;
    /* Z:0x405480 / Z:0x4058c0: save IsPaused, SetPaused(1), render (Z:0x41b210), modal dialog,
     * restore the pause state. */
    e->modal.saved_paused = timersys_is_paused(&p->timers);
    timersys_set_paused(&p->timers, true);
    eng_render(e);
    e->modal.kind = kind;
    e->modal.out_addr = out;
    e->modal.out_len = out_len;
    ShellDialog d;
    rt_memset(&d, 0, sizeof d);
    d.kind = kind;
    d.title = title;
    d.text = text;
    d.def = def;
    d.flags = flags;
    d.mb_type = ((flags & 2u) ? 1u : 0u) | ((flags & 0x100u) ? 0x30u : 0u);
    d.template_box = (flags & 2u) ? 1u : 2u;
    d.max_len = out_len;
    d.input_seq = e->input_seq;
    int32_t res = 1;
    char buf[1024];
    buf[0] = 0;
    int32_t st;
    if (e->test_auto_dialogs) {
        st = SHELL_DLG_DONE;
        res = 1;
        const char *ans = def ? def : "";
        if (e->n_answers > 0) ans = e->test_answers[0];
        uint32_t i = 0;
        for (; ans[i] && i + 1 < sizeof buf; i++) buf[i] = ans[i];
        buf[i] = 0;
        if (e->n_answers > 0) {
            for (int32_t k = 1; k < e->n_answers; k++) rt_memcpy(e->test_answers[k - 1], e->test_answers[k], 64);
            e->n_answers--;
        }
    } else {
        ENG_SHELL_CALL(e, st = shell_dialog_open(p, &d, &res, buf, sizeof buf));
    }
    if (st == SHELL_DLG_DONE) {
        if (kind == SHELL_DLG_INPUTBOX && res == 1) write_input_text(e, buf);
        timersys_set_paused(&p->timers, e->modal.saved_paused);
        return dialog_result(e, kind, res);
    }
    e->modal.active = true;
    cpu_suspend(e->cpu); /* the origin holds the timer list (eng_origin_suspended) */
    return 0;
}

void eng_origin_suspended(Engine *e, uint32_t kind, const int32_t *v, int32_t nv) {
    /* Outermost level of an unwind: remember how to restart, and stop the timer passes. A timer
     * origin runs inside a pass: that pass ends after this callback and continues after the dialog. */
    eng_frame_push(e, kind, v, nv, NULL);
    e->rs = RS_NONE;
    if (kind == FR_ORIGIN_TIMER) timersys_suspend_pass(&e->p->timers);
    else timersys_hold(&e->p->timers);
}

void engine_dialog_done(Port *p, int32_t result, const char *text) {
    Engine *e = engine_of(p);
    if (!e || !e->modal.active) return;
    e->modal.active = false;
    if (e->modal.kind == SHELL_DLG_INPUTBOX && result == 1) write_input_text(e, text);
    timersys_set_paused(&p->timers, e->modal.saved_paused);
    uint32_t r = dialog_result(e, e->modal.kind, result);
    if (e->modal.trace_pending) {
        e->modal.trace_pending = false;
        eng_trace_finish_line(e, e->modal.line, r);
    }
    if (!cpu_suspended(e->cpu)) {
        if (!e->shell_hold) timersys_resume(&p->timers);
        return;
    }
    /* rewind: the origin frame is on top */
    e->resume_eax = r;
    if (e->nframes <= 0) {
        eng_fail(e, "resume without an origin frame");
        return;
    }
    EngFrame of = e->frames[e->nframes - 1];
    e->nframes--;
    e->rs = RS_REWIND;
    switch (of.kind) {
    case FR_ORIGIN_TIMER:
        eng_guest_call(e, 0, NULL, 0, NULL);
        if (eng_unwinding(e)) {
            eng_frame_push(e, FR_ORIGIN_TIMER, of.v, 1, NULL); /* the pass stays suspended */
            e->rs = RS_NONE;
            return;
        }
        break;
    case FR_ORIGIN_KEY:
        eng_key_dispatch(e, of.v[0], of.v[1], (uint32_t)of.v[2]);
        if (eng_unwinding(e)) {
            eng_frame_push(e, FR_ORIGIN_KEY, of.v, 3, NULL);
            e->rs = RS_NONE;
            return;
        }
        break;
    case FR_ORIGIN_MOUSE:
        eng_mouse_event(e, of.v[0], of.v[1], of.v[2]);
        if (eng_unwinding(e)) {
            eng_frame_push(e, FR_ORIGIN_MOUSE, of.v, 3, NULL);
            e->rs = RS_NONE;
            return;
        }
        break;
    case FR_ORIGIN_APPEVENT:
        eng_applet_event(e, of.v[0]);
        if (eng_unwinding(e)) {
            eng_frame_push(e, FR_ORIGIN_APPEVENT, of.v, 1, NULL);
            e->rs = RS_NONE;
            return;
        }
        break;
    default:
        eng_fail(e, "resume: unknown origin frame %u", of.kind);
        return;
    }
    e->rs = RS_NONE;
    if (e->nframes) eng_fail(e, "resume: %d frames left", e->nframes);
    if (!e->shell_hold) timersys_resume(&p->timers);
}

void engine_modal_hold(Port *p, bool on) {
    Engine *e = engine_of(p);
    if (!e || e->shell_hold == on) return;
    e->shell_hold = on;
    if (on) timersys_hold(&p->timers);
    else if (!e->modal.active && !(e->cpu && cpu_suspended(e->cpu))) timersys_resume(&p->timers);
}

bool engine_dialog_waiting(Port *p) {
    Engine *e = engine_of(p);
    return e && e->modal.active;
}

void engine_test_answer(Port *p, const char *text) {
    Engine *e = engine_of(p);
    if (!e || e->n_answers >= 8) return;
    uint32_t i = 0;
    for (; text[i] && i + 1 < 64; i++) e->test_answers[e->n_answers][i] = text[i];
    e->test_answers[e->n_answers][i] = 0;
    e->n_answers++;
}

void engine_test_auto_dialogs(Port *p, bool on) {
    Engine *e = engine_of(p);
    if (e) e->test_auto_dialogs = on;
}

/* used by eng_dispatch.c */
void eng_modal_strings(Engine *e, uint32_t a, char *out, uint32_t cap) { copy_guest_str(e, a, out, cap); }
