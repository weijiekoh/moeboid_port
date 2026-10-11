/* Input queue and key-state table (M1). See input.h. */
#include "input.h"

void inq_clear(InputQueue *q) { rt_memset(q, 0, sizeof *q); }

bool inq_push(InputQueue *q, PortInput ev) {
    if (q->count >= PORT_INPUT_QUEUE_MAX) {
        q->dropped++;
        return false;
    }
    ev.seq = q->seq++;
    ev.step = 0;
    q->ev[(q->head + q->count) % PORT_INPUT_QUEUE_MAX] = ev;
    q->count++;
    return true;
}

const PortInput *inq_peek(const InputQueue *q) { return q->count ? &q->ev[q->head] : NULL; }

const PortInput *inq_peek2(const InputQueue *q) {
    return q->count > 1 ? &q->ev[(q->head + 1) % PORT_INPUT_QUEUE_MAX] : NULL;
}

void inq_pop(InputQueue *q) {
    if (!q->count) return;
    q->head = (q->head + 1) % PORT_INPUT_QUEUE_MAX;
    q->count--;
}

void keys_clear(KeyState *k) { rt_memset(k, 0, sizeof *k); }

static void key_down(KeyState *k, uint32_t vk) {
    uint8_t *s = &k->st[vk & 0xffu];
    if (!(*s & 0x80u)) *s ^= 1u;
    *s |= 0x80u;
}

static void key_up(KeyState *k, uint32_t vk) { k->st[vk & 0xffu] &= (uint8_t)~0x80u; }

static uint32_t button_vk(uint32_t kind) {
    switch (PORT_IN_BUTTON(kind)) {
    case 0: return VK_LBUTTON;
    case 1: return VK_MBUTTON;
    case 2: return VK_RBUTTON;
    default: return 0;
    }
}

void keys_apply(KeyState *k, const PortInput *ev) {
    switch (PORT_IN_KIND(ev->kind)) {
    case PORT_IN_KEYDOWN: key_down(k, (uint32_t)ev->a); break;
    case PORT_IN_KEYUP: key_up(k, (uint32_t)ev->a); break;
    case PORT_IN_BUTTONDOWN:
        if (button_vk(ev->kind)) key_down(k, button_vk(ev->kind));
        break;
    case PORT_IN_BUTTONUP:
        if (button_vk(ev->kind)) key_up(k, button_vk(ev->kind));
        break;
    case PORT_IN_FOCUS_LOST:
        for (uint32_t i = 0; i < 256; i++) k->st[i] &= (uint8_t)~0x80u;
        break;
    default: break;
    }
}

int16_t keys_get(const KeyState *k, uint32_t vk) {
    uint8_t s = k->st[vk & 0xffu];
    uint16_t v = (s & 0x80u) ? (uint16_t)(0xff80u | (s & 1u)) : (uint16_t)(s & 1u);
    return (int16_t)v;
}
