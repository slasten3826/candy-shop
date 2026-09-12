# NVIDIA Pascal policy

Status: policy carried from predecessor, re-confirmed against the live machine
on 2026-09-12.

## Hardware

```text
GPU: NVIDIA GeForce GTX 1080 (GP104 / Pascal)
VRAM: 8 GiB
CUDA compute capability: 6.1 (sm_61)
```

## Driver decision

Keep the proprietary NVIDIA 580xx branch supplied by Manjaro. Do not downgrade
the display driver merely to run Pascal-compatible compute software.

Live confirmation 2026-09-12:

```text
driver 580.178.04 active, nvidia-smi responds
packages: nvidia-580xx-utils, lib32-nvidia-580xx-utils, linux71-nvidia-580xx
mhwd profile family: video-nvidia-580xx
```

## Compute policy

The display driver and the CUDA compute layer are separate. CUDA 13 removed
support for pre-Turing GPUs, so Candy Shop must not assume the repository
`cuda` package is suitable merely because `nvidia-smi` advertises
`CUDA Version: 13.0`.

For CUDA workloads:

```text
use CUDA 12.x userspace/runtime
require the application or binary to include sm_61
prefer isolated per-application environments over replacing the system driver
verify actual GPU execution before accepting a runtime
```

Current measured state: no CUDA toolkit is installed (`nvcc` absent, `/opt/cuda`
absent). Inference currently runs through `ollama` with the Vulkan backend,
which needs no CUDA toolkit. Any CUDA-dependent workload would be a new
installation, not a modification of an existing one.

## Pascal constraints to respect

```text
8 GiB VRAM
no bfloat16
no Tensor Cores
limited consumer Pascal FP16 throughput
```

---

machines only. not for humans.
