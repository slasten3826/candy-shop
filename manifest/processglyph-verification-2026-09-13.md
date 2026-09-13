# ProcessGlyph numpad verification

[▲]

Status: verified working 2026-09-13.

## What was verified

End-to-end: a physical keypress on the numpad produces the mapped glyph in a
focused X window.

Method: the operator pressed keys on the numpad while a KDE window held focus,
and reported the resulting characters.

Observed result:

```text
▽☰☷☵☳☴☲☶☱△⋯⊞◈▲
```

All fourteen mapped glyphs were produced. The full character set of the numpad
matches the intended map with no substitution, no missing key, and no stray
characters.

## Component states at verification

```text
udev rule        installed, applied; device group changed to slasten
device access    /dev/input/event16 readable by the user
capture          grab ok: /dev/input/event16
X injection      working; resolved XAUTHORITY bound to the live session
service          enabled and active under systemd --user
```

Daemon log excerpt at the moment of testing:

```text
session env: DISPLAY=:0 XAUTHORITY=/tmp/xauth_XXXXXXXX
processglyphd start: target=8BitDo Retro 18 Numpad Keyboard
grab ok: /dev/input/event16
KEY_KP1 -> ▽
KEY_KP0 -> △
KEY_KPSLASH -> ⋯
KEY_KPASTERISK -> ⊞
KEY_KPMINUS -> ◈
KEY_KPPLUS -> ▲
```

## Not verified

```text
behaviour after a real reboot        (service is enabled; not yet observed)
behaviour after numpad power cycle   (daemon waits for the device; not yet observed)
behaviour when the X authority path changes on next login
                                     (wrapper resolves it dynamically; not yet observed)
```

The first three are the reason this remains a verification with a date rather
than an unconditional claim. Each is expected to hold, and none has been seen
to fail yet, but none has been observed across its boundary either.

## The failure that was fixed

First attempt produced no output. Capture worked (the log showed keypresses
mapping to glyphs) but nothing appeared in any window. Cause was the X
authority file: the unit pointed at `~/.Xauthority`, while this KDE session
uses a per-login file under `/tmp`. Details in
[`../crystall/processglyph-numpad.md`](../crystall/processglyph-numpad.md),
section "The X authority problem".

---

machines only. not for humans.
