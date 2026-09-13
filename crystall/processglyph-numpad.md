# ProcessGlyph numpad implementation

[◈]

How the numpad is wired on candy-shop. Measured and working 2026-09-13.

## Path

```text
8BitDo numpad (USB dongle)
  -> kernel input device "8BitDo Retro 18 Numpad Keyboard" (event16)
  -> processglyphd grabs it with EVIOCGRAB
  -> maps keycodes to ProcessLang glyphs
  -> xdotool type, inserting the glyph into the focused X window
```

## Components

| Artifact | Live path |
| --- | --- |
| `processglyphd.py` | `~/.local/bin/processglyphd.py` |
| `processglyphd-start.sh` | `~/.local/bin/processglyphd-start.sh` |
| systemd user unit | `~/.config/systemd/user/processglyphd.service` |
| udev rule | `/etc/udev/rules.d/99-8bitdo-processglyph.rules` |

Runtime copies of all four are under [`../manifest/runtime/`](../manifest/runtime/).

## Device identification

The daemon locates its device by name, never by event node or address:

```python
TARGET_NAME = "8BitDo Retro 18 Numpad Keyboard"
```

The kernel does not distinguish transport for HID devices, so the same name
appears over the dongle and would appear over Bluetooth. This is why the
Slastpad script runs unmodified here despite the different transport.

The numpad exposes two interfaces; only the keyboard one is grabbed:

```text
"8BitDo Retro 18 Numpad"           event15  mouse1   not used
"8BitDo Retro 18 Numpad Keyboard"  event16  kbd      grabbed
```

Device identity, for matching the udev rule and confirming the right numpad:

```text
USB id        2dc8:5204  (8BitDo Retro 18 Numpad)
serial        10379DA4D4
transport     2.4 GHz USB dongle, not Bluetooth
```

Note that `event15` and `event16` are whatever the kernel assigns at this boot.
Match the device by name or by USB id, never by event node.

## Glyph map

```text
KEY_KP1..KEY_KP0   ▽ ☰ ☷ ☵ ☳ ☴ ☲ ☶ ☱ △
KEY_KPSLASH        ⋯
KEY_KPASTERISK     ⊞
KEY_KPMINUS        ◈
KEY_KPPLUS         ▲
KEY_KPDOT          space
KEY_KPENTER        Return
KEY_BACKSPACE      BackSpace
```

## The X authority problem

The one non-obvious part, and the reason the unit does not simply set
`XAUTHORITY`.

Slastpad's AwesomeWM session inherits `~/.Xauthority`. candy-shop's KDE session
does not: SDDM starts Xorg with a **per-login authority file under `/tmp`**,
visible in the Xorg command line:

```text
/usr/lib/Xorg ... -auth /run/sddm/xauth_SqGKPf ...
```

and in the live session environment it is a generated path of that shape:

```text
XAUTHORITY=/tmp/xauth_XXXXXXXX
```

That path is regenerated on every login and cannot be hardcoded. Pointing the
unit at `~/.Xauthority` produced:

```text
Authorization required, but no authorization protocol specified
Failed creating new xdo instance.
```

while device capture kept working, so the daemon logged glyph mappings that
never reached any window. The capture half worked; the injection half silently
failed.

`processglyphd-start.sh` resolves the value at start time by reading `DISPLAY`
and `XAUTHORITY` from a live KDE process (`plasmashell`, `ksmserver`, `kwin_x11`,
`kded6`), falling back to probing `/run/sddm/*` and `/tmp/xauth_*`. It logs the
resolved pair before exec'ing the daemon, so the values in effect are always
visible in `journalctl`.

## Service

```sh
systemctl --user status processglyphd.service
systemctl --user restart processglyphd.service
journalctl --user -u processglyphd.service -f
```

Void of a window manager hook: the daemon is started by systemd user session,
with `Restart=always`. Where Slastpad starts it from `rc.lua`, candy-shop has
no `rc.lua` and uses the session manager instead.

## Known limitation

`EVIOCGRAB` requires the device to exist when the daemon starts, but the daemon
already loops and waits for it (`device not found; waiting`), so a late
reconnect is handled without restarting the service.

---

machines only. not for humans.
