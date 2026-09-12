# gpu implementation

Status: measured read-only 2026-09-12. Existing implementation accepted.

## Device

```text
model: NVIDIA GeForce GTX 1080 (GP104)
PCI address: 0a:00.0, id 10de:1b80
VRAM: 8192 MiB
compute capability: 6.1 (sm_61, Pascal)
VBIOS: 86.04.3B.40.51
audio function: 0a:00.1, id 10de:10f0
```

## Driver

```text
version: 580.178.04 (proprietary)
packages:
  nvidia-580xx-utils 580.178.04-1
  lib32-nvidia-580xx-utils 580.178.04-1
  linux71-nvidia-580xx 580.178.04-12
  nvidia-580xx-settings 580.178.04-1
  linux-firmware-nvidia 20260810-2
mhwd profile family: video-nvidia-580xx
loaded modules: nvidia, nvidia_uvm, nvidia_modeset, nvidia_drm
```

## State at measurement

```text
temperature: 37 C
power draw: 14.4 W
VRAM used: 706 MiB of 8192 MiB
compute processes: none
```

## Compute capability reported

`nvidia-smi` advertises `CUDA Version: 13.0`. This is the maximum the driver
supports in principle, not what the GPU can run. The GTX 1080 is Pascal and
CUDA 13 drops pre-Turing support. Treat the advertised version as informational
only.

No CUDA toolkit is installed (`nvcc` absent, `/opt/cuda` absent).

---

machines only. not for humans.
