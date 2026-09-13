# ProcessGlyph numpad policy

[⊞]

Accepted policy for addressing the 8BitDo Retro 18 Numpad on candy-shop.

## Decision

The numpad is connected over its **2.4 GHz USB dongle**, not Bluetooth.

```text
transport     USB dongle (2dc8:5204)
bluetooth     not used; the bluetooth service is inactive on candy-shop
```

It emits the ProcessLang glyphs, matching Slastpad's behaviour, but through a
different transport and a different session manager.

## Addressing rules

```text
device is found by name      "8BitDo Retro 18 Numpad Keyboard"
access is granted per-device by udev, not by group membership
the daemon runs as a systemd user service, not from a window manager
```

Granting access per-device is deliberate. Adding the user to the `input` group
would also work, but would expose every input device on the machine to any
process running as that user. The udev rule grants the minimum: this numpad,
and nothing else.

## Consequence accepted

The daemon holds the keyboard interface with `EVIOCGRAB`. While it runs, the
desktop does not see ordinary digits from the numpad — only glyphs. To get
plain digits back, stop the service.

## Why not Bluetooth

Bluetooth would require enabling a service that is otherwise off, and would
add pairing state to maintain. The dongle needs no pairing and no Bluetooth
stack. Slastpad uses Bluetooth because that is what it has; candy-shop has a
dongle, so it uses the dongle.

---

machines only. not for humans.
