# gaming policy

Status: policy carried from predecessor, re-confirmed against the live machine
on 2026-09-12.

## Stack

```text
steam 1.0.0.87-2          native, primary launcher
portproton 1.7.5-1        AUR, non-Steam Windows games
vulkan-icd-loader + lib32  present (64-bit and 32-bit)
```

Measured 2026-09-12: Steam running, `steamwebhelper` active. No system `wine`,
`lutris`, `heroic`, `gamemode`, or `mangohud` installed.

## Rules

```text
prefer Steam for Steam titles
use PortProton for non-Steam Windows titles instead of a system wine
keep the 580xx display driver; required for the GTX 1080
add observability (gamemode, mangohud) only when a workload needs it
```

Do not install a system `wine` package as a general fix; PortProton carries its
own runtime.

## Controllers

Xbox Wireless Adapter uses the `xone` DKMS driver, not `xpad`. See
`table/controller-policy.md` for the binding rules and the `mt76x2u` conflict.

## GPU sharing

Gaming and local-model inference both target the single GTX 1080. The GPU has
8 GiB VRAM. Do not assume a game and a model can run on the GPU at once; the
`ollama` Vulkan backend will contend for the same device.

---

machines only. not for humans.
