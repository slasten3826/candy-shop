# desktop implementation

Status: measured read-only 2026-09-12.

## Session

```text
display manager: SDDM
session type: X11
desktop: KDE Plasma 6.7.4 (plasmashell 6.7.4)
window manager: kwin 6.7.4
```

X11 is the accepted session type, consistent with the NVIDIA/Pascal stack.

## Display

```text
connected: HDMI-0, primary, 1920x1080 at 60 Hz, 477x268 mm physical
disconnected: DVI-D-0, DP-0 through DP-5
```

## Audio

```text
server: PipeWire 1.6.8 with WirePlumber 0.5.17
compatibility: PulseAudio layer present
               (pactl reports "PulseAudio (on PipeWire 1.6.8)")
```

## Flatpak

```text
installed, Flathub configured
applications: none
runtimes only: Mesa GL (26.1.6), NVIDIA GL (580-178-04), VAAPI NVIDIA,
               KDE Platform 6.10, Breeze GTK theme, codecs-extra
```

## Desktop integration installed

```text
timeshift 25.12.4-1, configured (/etc/timeshift, autosnap config present)
kdeconnect running
```

---

machines only. not for humans.
