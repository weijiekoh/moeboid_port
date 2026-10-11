/* Windows XP dialog component (milestone M5a): template parser, dialog manager and classic controls,
 * drawn into an RGBA image that the shell composes above the 800x572 frame.
 *
 * Scope (analysis/shell.md 3.2, 3.4, 4; decisions 4a-4c, 5, O1, O6): the kept ZapSpot dialogs
 * IDD_INPUT_BOX2, IDD_QUIT_SAVED, IDD_TERMSOFSERVICE (dialog procedure Z:0x404f60) and the
 * MessageBox of Z:0x4058c0 (built by msgbox.c). Non-client frame: Windows XP Luna (luna.h). Client
 * controls: classic (unthemed) user32 controls in the Luna system colours, because ZapSpot.exe has no
 * manifest (O1). Rule sources and status (verified / inferred): file headers of dialog.c,
 * dialog_edit.c, msgbox.c, inputbox.c, tos.c.
 *
 * Model: one Dialog = one modal dialog window. The owner (shell_modal.c) creates it from a template
 * (dlg_create) or builds it (dlg_init + dlg_add_control, MessageBox), sets texts, calls dlg_start,
 * then routes input (dlg_input, dlg_wheel), timers (dlg_tick) and reads WM_COMMAND ids
 * (dlg_take_command), which its dialog procedure maps to a result. Drawing: dlg_draw renders the
 * whole window into d->img (window size, colour-keyed corners) when d->dirty is set; dlg_compose
 * copies it into a frame buffer.
 *
 * Coordinates: window = (0, 0) at the outer top-left corner of the dialog window; client = relative
 * to the client area; frame = port canvas pixels (800x572). Input comes in frame pixels.
 * Time: virtual clock ms (GetTickCount model, core_ticks), never wall time.
 * No allocation, no floating point, no static state. */
#ifndef MOEBOID_SHELL_DIALOG_H
#define MOEBOID_SHELL_DIALOG_H

#include "../rt/rt.h"
#include "../gfx/image.h"
#include "../text/atlas.h"
#include "../text/gdi_text.h"
#include "luna.h"

/* ---- limits (port) */
#define DLG_MAX_CTL 16         /* controls per dialog (kept templates: at most 4; DUMPINFO2: 12) */
#define DLG_LABEL_MAX 256      /* label bytes of a button or static (longest kept: 234) */
#define DLG_EDIT_MAX 512       /* editable edit text bytes (original NT limit 0x7FFFFFFE; port cap) */
#define DLG_ML_LINES 2048      /* line table of a multi-line edit (ToS: 360 lines) */
#define DLG_CAPTION_MAX 128
#define DLG_MAX_W 800          /* window must fit the frame canvas (PORT_W x PORT_H) */
#define DLG_MAX_H 572

/* ---- Win32 style bits used here (winuser.h values) */
#define DLG_WS_TABSTOP 0x00010000u
#define DLG_WS_GROUP 0x00020000u
#define DLG_WS_VSCROLL 0x00200000u
#define DLG_WS_BORDER 0x00800000u
#define DLG_WS_SYSMENU 0x00080000u
#define DLG_WS_DISABLED 0x08000000u
#define DLG_WS_VISIBLE 0x10000000u
#define DLG_WS_EX_CLIENTEDGE 0x00000200u
#define DLG_DS_SETFONT 0x40u
#define DLG_DS_CENTER 0x0800u
#define DLG_BS_TYPEMASK 0x0Fu
#define DLG_BS_PUSHBUTTON 0x0u
#define DLG_BS_DEFPUSHBUTTON 0x1u
#define DLG_BS_AUTOCHECKBOX 0x3u
#define DLG_ES_CENTER 0x0001u
#define DLG_ES_RIGHT 0x0002u
#define DLG_ES_MULTILINE 0x0004u
#define DLG_ES_AUTOHSCROLL 0x0080u
#define DLG_ES_NOHIDESEL 0x0100u
#define DLG_ES_READONLY 0x0800u
#define DLG_SS_TYPEMASK 0x1Fu
#define DLG_SS_LEFT 0x0u
#define DLG_SS_CENTER 0x1u
#define DLG_SS_RIGHT 0x2u
#define DLG_SS_ICON 0x3u
#define DLG_SS_NOPREFIX 0x80u
#define DLG_SS_EDITCONTROL 0x2000u

#define DLG_IDOK 1
#define DLG_IDCANCEL 2

/* DrawText flags (winuser.h values) used by the text layout helpers. */
#define DLG_DT_CENTER 0x0001u
#define DLG_DT_RIGHT 0x0002u
#define DLG_DT_VCENTER 0x0004u
#define DLG_DT_WORDBREAK 0x0010u
#define DLG_DT_SINGLELINE 0x0020u
#define DLG_DT_EXPANDTABS 0x0040u
#define DLG_DT_EXTERNALLEADING 0x0200u
#define DLG_DT_NOPREFIX 0x0800u
#define DLG_DT_EDITCONTROL 0x2000u
#define DLG_DT_HIDEPREFIX 0x00100000u

/* UI state bits (WM_CHANGEUISTATE). */
#define DLG_UISF_HIDEFOCUS 0x1u
#define DLG_UISF_HIDEACCEL 0x2u

/* Windows virtual keys used by the dialog manager and the controls. */
#define DLG_VK_BACK 0x08u
#define DLG_VK_TAB 0x09u
#define DLG_VK_RETURN 0x0Du
#define DLG_VK_SHIFT 0x10u
#define DLG_VK_CONTROL 0x11u
#define DLG_VK_ESCAPE 0x1Bu
#define DLG_VK_SPACE 0x20u
#define DLG_VK_PRIOR 0x21u
#define DLG_VK_NEXT 0x22u
#define DLG_VK_END 0x23u
#define DLG_VK_HOME 0x24u
#define DLG_VK_LEFT 0x25u
#define DLG_VK_UP 0x26u
#define DLG_VK_RIGHT 0x27u
#define DLG_VK_DOWN 0x28u
#define DLG_VK_DELETE 0x2Eu

/* Host input kinds (src/core/input.h, PORT_IN_*), repeated so that this module needs no core header. */
#define DLG_IN_KEYDOWN 1u
#define DLG_IN_KEYUP 2u
#define DLG_IN_MOUSEMOVE 3u
#define DLG_IN_BUTTONDOWN 4u
#define DLG_IN_BUTTONUP 5u
#define DLG_IN_FOCUS_LOST 6u
#define DLG_IN_FOCUS_GAINED 7u
#define DLG_IN_CHAR 9u

/* Timing (inferred XP defaults, see dialog.c). */
#define DLG_CARET_BLINK_MS 530u    /* GetCaretBlinkTime default */
#define DLG_DBLCLK_MS 500u         /* GetDoubleClickTime default */
#define DLG_SCROLL_FIRST_MS 200u   /* scroll bar auto-repeat: first delay (inferred, Wine value) */
#define DLG_SCROLL_REPEAT_MS 50u   /* repeat period (inferred, Wine value) */
#define DLG_WHEEL_LINES 3          /* SPI_GETWHEELSCROLLLINES default */

/* Cursor kinds the dialog asks for (the host maps them; the system cursors are not in the pack). */
#define DLG_CURSOR_NONE 0      /* pointer is not over the dialog */
#define DLG_CURSOR_ARROW 1     /* IDC_ARROW (dialog class cursor) */
#define DLG_CURSOR_IBEAM 2     /* IDC_IBEAM (edit control client area) */

enum { DLG_K_NONE = 0, DLG_K_BUTTON, DLG_K_EDIT, DLG_K_STATIC, DLG_K_ICON, DLG_K_CHECKBOX };

typedef struct DlgRect {
    int32_t x, y, w, h;
} DlgRect;

/* Common environment: theme, caption font, smoothing, canvas size. */
typedef struct DlgEnv {
    const LunaTheme *luna;
    const GdiFont *caption_font; /* Trebuchet MS 13 px bold (luna.h); NULL: no caption text */
    uint8_t smoothing;           /* decision 4b: 1 */
    int32_t frame_w, frame_h;    /* 800, 572 */
} DlgEnv;

/* Multi-line or single-line edit control state (one per dialog). */
typedef struct DlgEdit {
    bool multiline, readonly, autohscroll, nohidesel;
    const char *ext;             /* read-only external text (points into the pack) or NULL */
    char buf[DLG_EDIT_MAX];      /* own text when ext == NULL */
    uint32_t len;                /* text length in bytes */
    uint32_t sel_start, sel_end; /* sel_end = caret position */
    bool after_wrap;             /* caret shown at the end of the previous wrapped line */
    int32_t x_offset;            /* single-line: first visible character */
    int32_t y_offset;            /* multi-line: first visible line */
    DlgRect client;              /* client area (inside the client edge, left of the scroll bar), control coords */
    DlgRect fmt;                 /* formatting rectangle, control coords */
    int32_t line_h;              /* tmHeight */
    int32_t vlc;                 /* visible line count */
    int32_t nlines;
    uint32_t line_start[DLG_ML_LINES];
    uint32_t line_len[DLG_ML_LINES]; /* bytes on the line without the CRLF */
    /* undo (single level, inferred Wine model of EM_UNDO) */
    char undo_text[DLG_EDIT_MAX];
    uint32_t undo_len, undo_pos, undo_ins;
    /* vertical scroll bar (WS_VSCROLL) */
    bool vscroll;
    DlgRect sb;                  /* scroll bar rectangle, control coords */
    int32_t wheel_acc;           /* accumulated wheel delta */
    /* mouse */
    bool selecting;
    uint32_t last_click_ms;
    int32_t last_click_x, last_click_y;
    bool has_last_click;
} DlgEdit;

typedef struct DlgControl {
    uint8_t kind;               /* DLG_K_* */
    int32_t id;                 /* signed: -1 for unnamed statics */
    uint32_t style, exstyle;
    DlgRect r;                  /* window rectangle in client coordinates */
    bool visible;
    char text[DLG_LABEL_MAX];   /* cp1252 */
    int32_t text_len;
    bool is_def;                /* drawn as BS_DEFPUSHBUTTON now */
    bool pushed;                /* BST_PUSHED */
    bool space_down;            /* pushed by the space key */
} DlgControl;

/* Scroll bar tracking (mouse on the edit's vertical scroll bar). */
enum { DLG_SB_NONE = 0, DLG_SB_LINEUP, DLG_SB_LINEDOWN, DLG_SB_PAGEUP, DLG_SB_PAGEDOWN, DLG_SB_THUMB };

typedef struct Dialog {
    bool open;
    DlgEnv env;
    GdiFont font_own;           /* storage for font */
    const GdiFont *font;        /* dialog font: MS Sans Serif 8 (templates) or Tahoma 8 (MessageBox) */
    GdiTextMetrics tm;
    int32_t base_x, base_y;     /* dialog base units (GdiGetCharDimensions model) */
    uint32_t style;
    char caption[DLG_CAPTION_MAX];
    int32_t caption_len;
    int32_t client_w, client_h;
    LunaGeom geom;
    int32_t win_x, win_y;       /* window position in frame coordinates */
    DlgControl ctl[DLG_MAX_CTL];
    int32_t n;
    int32_t focus;              /* control index with the keyboard focus, -1 none */
    int32_t def_id;             /* dialog default id (DM_GETDEFID), 0 = none */
    uint8_t ui_state;           /* DLG_UISF_* */
    bool active;                /* caption active */
    /* close button (MessageBox only) */
    bool close_button;
    bool close_hot, close_pushed, close_capture;
    /* mouse capture */
    int32_t capture;            /* control index that owns the mouse capture, -1 none */
    int32_t mouse_x, mouse_y;   /* last mouse position, frame coordinates */
    bool mouse_inside;          /* last mouse position over the dialog window */
    /* caption drag (moves the window inside the frame) */
    bool dragging;
    int32_t drag_dx, drag_dy;
    /* key state for Shift and Ctrl (from key down/up events seen by the dialog) */
    bool shift_down, ctrl_down;
    bool drop_char;             /* the next WM_CHAR does not exist (key handled by the dialog manager) */
    /* edit control */
    int32_t edit_ctl;           /* control index of the edit, -1 none */
    DlgEdit edit;
    bool caret_on;              /* caret drawn now (blink phase) */
    uint32_t caret_t0;          /* clock ms of the last caret reset */
    /* scroll bar tracking */
    int32_t sb_mode;            /* DLG_SB_* */
    bool sb_pressed;            /* mouse is over the pressed part */
    uint32_t sb_next_ms;        /* next auto-repeat */
    int32_t sb_thumb_px;        /* tracked thumb top (scroll bar coords) */
    int32_t sb_drag_off;        /* mouse y - thumb top at the start of the drag */
    int32_t sb_track_y;         /* mouse y for page repeat (scroll bar coords) */
    /* icon (MessageBox): 32x32 RGBA straight alpha, NULL = none drawn (place kept) */
    const uint8_t *icon_rgba;
    /* pending WM_COMMAND ids */
    int32_t cmd[8];
    int32_t ncmd;
    uint32_t now;               /* clock ms of the latest call */
    bool dirty;                 /* image must be redrawn */
    bool moved;                 /* window position changed since the last compose (old area needs repaint) */
    int32_t old_x, old_y;       /* previous position when moved */
    Image img;                  /* window image, w = geom.win_w, h = geom.win_h, keyed */
    uint32_t px[DLG_MAX_W * DLG_MAX_H];
} Dialog;

/* ---- creation */
/* Dialog base units of a font: x = (extent of "A..Za..z" / 26 + 1) / 2, y = tmHeight (inferred
 * GdiGetCharDimensions rule; MS Sans Serif 8 = 6 x 13, verified against assets/ZapSpot.exe/decoded). */
void dlg_base_units(const GdiFont *f, int32_t *bx, int32_t *by);
/* MulDiv with rounding half away from zero (Win32 MulDiv). */
int32_t dlg_muldiv(int32_t a, int32_t b, int32_t c);

/* Parse a DLGTEMPLATE or DLGTEMPLATEEX (pack entry zap/DIALOG/<NAME>), select the template font from
 * fonts, convert DLU to pixels, centre the window in the frame (DS_CENTER). Returns 0 or -1. */
int32_t dlg_create(Dialog *d, const DlgEnv *env, const TextFonts *fonts, const uint8_t *tmpl, uint32_t len);
/* Empty dialog with a pixel-size client area (MessageBox). Window centred in the frame. */
void dlg_init(Dialog *d, const DlgEnv *env, const GdiFont *font, int32_t client_w, int32_t client_h, uint32_t style,
              bool close_button);
/* Add a control in client pixels. Returns the control index or -1. */
int32_t dlg_add_control(Dialog *d, uint8_t kind, int32_t id, uint32_t style, uint32_t exstyle, DlgRect r,
                        const char *text, int32_t n);

int32_t dlg_find(const Dialog *d, int32_t id);     /* control index for an id, -1 if absent */
void dlg_set_caption(Dialog *d, const char *s, int32_t n);   /* SetWindowTextA; n < 0: NUL-terminated */
/* SetDlgItemTextA. Edit: replaces the text, selection 0..0, view at the top. n < 0: NUL-terminated. */
void dlg_set_item_text(Dialog *d, int32_t id, const char *s, int32_t n);
/* SetDlgItemTextA for a read-only edit with a long text that stays in the caller's memory (pack). */
void dlg_set_item_text_ext(Dialog *d, int32_t id, const char *s, uint32_t n);
void dlg_show_item(Dialog *d, int32_t id, bool visible);
/* GetDlgItemTextA(id, buf, max): copies at most max - 1 bytes and a NUL; returns the length copied. */
int32_t dlg_get_item_text(const Dialog *d, int32_t id, char *buf, int32_t max);

/* End of WM_INITDIALOG (procedure returned TRUE): focus to the first WS_TABSTOP control (an edit gets
 * EM_SETSEL(0, -1)); UI state from the last input (keyboard: cues shown; mouse: hidden). focus_id > 0
 * sets the focus to that control instead (MessageBox default button). */
void dlg_start(Dialog *d, uint32_t now, bool last_input_keyboard, int32_t focus_id);

/* ---- input (frame coordinates). Returns true when the dialog used the event. */
bool dlg_input(Dialog *d, uint32_t kind, int32_t a, int32_t b, uint32_t now);
/* WM_MOUSEWHEEL with delta in 1/120 notches (positive = away from the user); goes to the focus window. */
void dlg_wheel(Dialog *d, int32_t delta, uint32_t now);
/* Timers: caret blink, scroll bar auto-repeat. Returns true when the image changed. */
bool dlg_tick(Dialog *d, uint32_t now);
/* Next pending WM_COMMAND control id (0 when none). */
int32_t dlg_take_command(Dialog *d);
/* Cursor kind for frame point (x, y). */
int32_t dlg_cursor(const Dialog *d, int32_t x, int32_t y);

/* ---- keyboard focus helpers (exposed for tests) */
void dlg_set_focus(Dialog *d, int32_t index, bool select_all);
int32_t dlg_next_tab(const Dialog *d, int32_t from, bool previous);
int32_t dlg_next_group(const Dialog *d, int32_t from, bool previous);

/* ---- drawing */
/* Render the window into d->img when dirty (or force). Clears d->dirty. */
void dlg_draw(Dialog *d, bool force);
/* Copy the window image to an RGBA frame (bytes R, G, B, A; fw x fh, top-down) at (win_x, win_y);
 * colour-key pixels (the rounded caption corners) are skipped. */
void dlg_compose(const Dialog *d, uint8_t *frame_rgba, int32_t fw, int32_t fh);

/* ---- text layout (DrawText model, dialog.c) */
typedef struct DtLine {
    int32_t start, len;          /* bytes of the line in the display string (prefix characters removed) */
    int32_t width;
} DtLine;
typedef struct DtText {
    char s[DLG_LABEL_MAX];       /* display string: '&' prefixes removed ("&&" = "&") */
    int32_t n;
    int32_t underline;           /* index of the mnemonic character in s, -1 none */
    DtLine line[16];
    int32_t nlines;
    int32_t width, height;       /* DT_CALCRECT result */
} DtText;
/* Lay out text for a rectangle width (DT_WORDBREAK and DT_SINGLELINE rules; see dialog.c). */
void dt_layout(DtText *t, const GdiFont *f, const char *s, int32_t n, int32_t width, uint32_t flags);
/* Draw a laid-out text into dst at rectangle r (clipped to clip) with DrawText alignment flags. */
void dt_draw(Image *dst, const DtText *t, const GdiFont *f, DlgRect r, const GdiRect *clip, uint32_t flags,
             uint32_t color, uint8_t smoothing);

/* ---- edit helpers (dialog_edit.c; exposed for tests) */
void dlg_edit_layout(Dialog *d);                    /* rebuild line breaks (multi-line) */
int32_t dlg_edit_line_of(const DlgEdit *e, uint32_t index, bool after_wrap);
void dlg_edit_scroll_caret(Dialog *d);
void dlg_edit_scroll_lines(Dialog *d, int32_t dy);  /* EM_LINESCROLL, clamped */
void dlg_edit_set_sel(Dialog *d, uint32_t start, uint32_t end);
void dlg_edit_replace_sel(Dialog *d, const char *s, uint32_t n, bool can_undo);
void dlg_edit_undo(Dialog *d);
/* Scroll bar geometry (CalcSBStuff2 model), scroll bar coordinates (0 = top of the bar). */
typedef struct DlgSbCalc {
    int32_t px_up, px_down;      /* bottom of the up arrow, top of the down arrow */
    int32_t px_min, cpx;         /* thumb travel start and length */
    int32_t thumb_top, thumb_h;
    int32_t pos, page, range;    /* range = posMax - posMin + 1 */
} DlgSbCalc;
void dlg_sb_calc(const Dialog *d, DlgSbCalc *c);

/* internal (dialog_edit.c), called by dialog.c */
const char *dlg_edit_text(const DlgEdit *e);
bool dlg_edit_key(Dialog *d, uint32_t vk);
bool dlg_edit_char(Dialog *d, uint32_t ch);
void dlg_edit_mouse(Dialog *d, uint32_t kind, int32_t cx, int32_t cy);
void dlg_edit_draw(Dialog *d, const DlgControl *c, int32_t ox, int32_t oy);
void dlg_edit_focus(Dialog *d, bool gained);
void dlg_edit_init(Dialog *d, DlgControl *c);
bool dlg_sb_mouse(Dialog *d, uint32_t kind, int32_t sx, int32_t sy);
bool dlg_sb_tick(Dialog *d);
void dlg_caret_reset(Dialog *d);

#endif
