# numpad bring-up — resolved

[⋯]

Started 2026-09-13 as an unknown, resolved the same day. Kept as a record of
the gap between "connected" and "working", because the failure was not where
it first appeared.

## The observation that opened this

The numpad was connected over its USB dongle and the daemon reported capturing
it, but no glyph reached any window. The daemon log looked healthy:

```text
grab ok: /dev/input/event16
KEY_KP1 -> ▽
```

Capture worked. Injection did not. The log said nothing about the failure.

## What it looked like from outside

The operator pressed keys and "nothing printed". The natural first guesses —
wrong device, missing permissions, broken keymap — were all wrong. The device
was right, permissions were right, the keymap was right.

## Where it actually was

The X authority file. candy-shop's KDE session uses a per-login authority file
under `/tmp` (SDDM-generated), not `~/.Xauthority` as Slastpad's AwesomeWM
session does. `xdotool` could not open the display and failed with:

```text
Authorization required, but no authorization protocol specified
Failed creating new xdo instance.
```

The daemon swallowed that error, because it runs `xdotool` with output
redirected to `/dev/null`. That is why the log showed successful key mapping
and nothing else: the capture path logged, the injection path did not.

## Lesson recorded here

A two-stage pipeline where only the first stage logs will look healthy while
the second stage fails completely. The device capture log was not evidence that
the feature worked.

## Resolution

Written up as accepted policy and implementation:

```text
table/processglyph-numpad-policy.md
crystall/processglyph-numpad.md
manifest/processglyph-verification-2026-09-13.md
```

Nothing here is open.

---

machines only. not for humans.
