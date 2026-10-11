/* Cursor ids of the cursor manager (M4; analysis/rendering.md 8, Z:0x425a80).
 * The manager loads six cursors in this order (+0x08 returns one by index, +0x0c sets it with
 * SetCursor). The port reports the current id through port_cursor(); the host sets the CSS cursor. */
#ifndef PORT_GFX_CURSOR_H
#define PORT_GFX_CURSOR_H

enum {
    CURSOR_POINTER = 0,    /* Pointer.cur: default */
    CURSOR_HAND = 1,       /* Hand.cur: surfaces with flag bit 1, buttons */
    CURSOR_NOLINK = 2,     /* NoLink.cur */
    CURSOR_OPENHAND = 3,   /* OpenHand.cur: frame border (shell) */
    CURSOR_CLOSEDHAND = 4, /* ClosedHand.cur: window drag (removed in the port) */
    CURSOR_HOURGLASS = 5,  /* Hourglass.cur */
    CURSOR_COUNT = 6
};

#endif
