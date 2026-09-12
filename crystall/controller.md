# controller implementation

Status: installed 2026-08-22, re-measured 2026-09-12.

## Hardware

```text
adapter: Microsoft Xbox Wireless Adapter for Windows
USB ID: 045e:02fe
location at measurement: bus 001, device 004
```

## Software

```text
dkms: xone/0.5.8 built for 7.1.13-2-MANJARO, installed
firmware: /usr/lib/firmware/xone_dongle_02fe.bin
loaded modules: xone_dongle, xone_gip, xone_gip_gamepad
                xone_gip_headset not loaded (no headset attached)
```

The `xone-dkms` package installs `/usr/lib/modprobe.d/xone-blacklist.conf`
blacklisting `xpad` and `mt76x2u`.

## Binding verification

The adapter interface must resolve to the `xone-dongle` driver:

```sh
readlink -f /sys/bus/usb/devices/1-9:1.0/driver
# expected suffix: /sys/bus/usb/drivers/xone-dongle
```

The exact USB path depends on which port the adapter is in; the module set
loaded at measurement confirms `xone` owns it.

## Conflict recovery

If the binding resolves to `mt76x2u`:

```sh
sudo modprobe -r mt76x2u
```

Then unplug the adapter for at least five seconds and reconnect physically.

## After kernel updates

```sh
dkms status
modinfo xone-dongle
```

The `xone` entry must show installed for the running kernel before the adapter
is relied upon after reboot.

---

machines only. not for humans.
