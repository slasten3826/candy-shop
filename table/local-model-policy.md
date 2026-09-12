# local model policy

Status: measured 2026-09-12. Supersedes the predecessor's inference plan, which
assumed no runtime was installed.

## Current state

```text
runtime: ollama 0.33.3-1, service active
backend: Vulkan (ollama-vulkan 0.33.3-1 installed)
models: qwen3:8b (5.2 GB)
CUDA toolkit: none (nvcc absent, /opt/cuda absent)
python ML env: none observed
```

Inference already works. The Vulkan backend needs no CUDA toolkit, which is a
good fit for a Pascal card with no current CUDA 13 support.

## Rules

```text
keep inference on ollama/Vulkan while it meets the workload
do not install the repository cuda package for inference — it is CUDA 13 and drops Pascal
keep fine-tuning separate from inference; they have different requirements
verify real GPU execution before accepting any new runtime
```

## Fine-tuning

Fine-tuning is not currently set up. If pursued, the Pascal policy applies:

```text
use CUDA 12.6 userspace (bitsandbytes wheels for 11.8-12.6 still carry sm60)
CUDA 12.8+ wheels start at sm70 and are wrong for this card
isolated Python environment, not system packages
reproducibility target: 4-bit NF4 LoRA, fp16, seq len 128, micro-batch 1,
  grad accumulation 256, small LoRA rank (a known working slow path on this GPU)
```

## Constraint

One GPU, 8 GiB VRAM, shared with gaming. Do not plan concurrent heavy inference
and gaming. Either can also drive host RAM pressure; swap is load-bearing here.

---

machines only. not for humans.
