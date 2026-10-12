/* Input event queue and key-state table (M1; analysis/timing.md 9 rule 5, audio-input.md 3, 5).
 *
 * Event kinds (port_input `kind`, port-design.md section 6). The low byte is the kind:
 *   1 key down     a = Windows VK, b = 1 for an auto-repeat
 *   2 key up       a = Windows VK
 *   3 mouse move   a = x, b = y (frame pixels, signed)
 *   4 button down  a = x, b = y; bits 8-15 of kind = DOM button (0 left, 1 middle, 2 right)
 *   5 button up    as 4
 *   6 focus lost   7 focus gained   8 page start
 *   9 character    a = character code (Windows-1252), b = 1 for an auto-repeat
 *                  (port extension: TranslateMessage/WM_CHAR needs the host keyboard layout)
 *  10 mouse wheel  a = signed delta in WHEEL_DELTA units (120 per notch, positive = wheel turned away
 *                  from the user, as WM_MOUSEWHEEL), b = 0 (port extension, host/input.ts wheelUnits).
 *                  Only an open modal dialog reads it (src/shell/shell_modal.c: scroll the focused
 *                  edit control); the frame and the game ignore it (the frame WndProc Z:0x4040e0 has
 *                  no WM_MOUSEWHEEL case, audio-input.md 3.2). It does not change the key state.
 * Time stamps: host ms in the same time base as port_advance. */
#ifndef MOEBOID_CORE_INPUT_H
#define MOEBOID_CORE_INPUT_H

#include "../rt/rt.h"

enum {
    PORT_IN_KEYDOWN = 1,
    PORT_IN_KEYUP = 2,
    PORT_IN_MOUSEMOVE = 3,
    PORT_IN_BUTTONDOWN = 4,
    PORT_IN_BUTTONUP = 5,
    PORT_IN_FOCUS_LOST = 6,
    PORT_IN_FOCUS_GAINED = 7,
    PORT_IN_START = 8,
    PORT_IN_CHAR = 9,
    PORT_IN_WHEEL = 10,
};
#define PORT_IN_KIND(k) ((k) & 0xffu)
#define PORT_IN_BUTTON(k) (((k) >> 8) & 0xffu)

/* Windows virtual keys used by the core. */
#define VK_LBUTTON 0x01u
#define VK_RBUTTON 0x02u
#define VK_MBUTTON 0x04u

typedef struct PortInput {
    uint32_t kind;
    int32_t a, b;
    int32_t t;     /* time stamp in ms relative to the wall base (can be negative) */
    uint32_t seq;  /* arrival number since port_init */
    uint64_t step; /* clock step of the delivery (set at delivery) */
} PortInput;

#define PORT_INPUT_QUEUE_MAX 1024u

typedef struct InputQueue {
    PortInput ev[PORT_INPUT_QUEUE_MAX];
    uint32_t head, count;
    uint32_t seq;
    uint32_t dropped; /* events lost because the queue was full */
} InputQueue;

void inq_clear(InputQueue *q);
/* Append; false (and dropped++) when full. Sets ev->seq. */
bool inq_push(InputQueue *q, PortInput ev);
/* Oldest event or NULL. */
const PortInput *inq_peek(const InputQueue *q);
/* Second-oldest event or NULL. */
const PortInput *inq_peek2(const InputQueue *q);
void inq_pop(InputQueue *q);

/* GetKeyState model: per VK, bit 0x80 = down, bit 0x01 = toggle (flips on each up-to-down
 * transition; an auto-repeat does not flip it). */
typedef struct KeyState {
    uint8_t st[256];
} KeyState;

void keys_clear(KeyState *k);
/* Update for a delivered event: key down/up, button down/up; focus lost releases every key
 * and button (audio-input.md 5: avoid stuck keys; the toggles stay). Other kinds: no change. */
void keys_apply(KeyState *k, const PortInput *ev);
/* GetKeyState(vk) as SHORT: down 0xff80 | toggle, up 0x0000 | toggle (audio-input.md 3.4:
 * the game tests bit 0x80 of the low byte; the low byte value is inferred from Wine/ReactOS). */
int16_t keys_get(const KeyState *k, uint32_t vk);

#endif
