# controller policy

Status: installed 2026-08-22, re-confirmed live 2026-09-12.

## Hardware

```text
adapter: Microsoft Xbox Wireless Adapter for Windows
USB ID: 045e:02fe (bus 001 device 004 at measurement)
```

## Driver

```text
dkms: xone/0.5.8, built for the running kernel (7.1.13-2-MANJARO at measurement)
loaded: xone_dongle, xone_gip, xone_gip_gamepad
```

`xone-dkms` installs `/usr/lib/modprobe.d/xone-blacklist.conf`:

```text
blacklist xpad
blacklist mt76x2u
```

The `mt76x2u` blacklist matters: that WiFi driver claims the same USB ID range
and would otherwise steal the adapter, initializing its radio firmware and
leaving it unusable for `xone`.

## Recovery after a driver conflict

If `xone_dongle` is not the bound driver, or the adapter does not respond:

```sh
sudo modprobe -r mt76x2u
```

Then physically unplug the adapter for at least five seconds and reconnect it.
Do not rely on manually rebinding an adapter whose radio firmware was already
initialized by `mt76x2u`; a physical USB power cycle is required.

## Update maintenance

After every kernel update, before relying on the adapter:

```sh
dkms status
modinfo xone-dongle
```

The `xone` entry must show as installed for the running kernel. A kernel update
without a rebuilt `xone` module silently breaks the controller.

---

machines only. not for humans.
