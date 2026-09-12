# local models implementation

Status: measured read-only 2026-09-12.

## Runtime

```text
ollama 0.33.3-1
ollama-vulkan 0.33.3-1
service: ollama.service active, running (MainPID 780 at measurement)
service mode: enabled at boot
```

## Models

```text
qwen3:8b   500a1f067a9f   5.2 GB   pulled approximately 2026-08-31
```

## Backend

`ollama-vulkan` is installed, so inference targets the GPU through Vulkan. This
requires no CUDA toolkit and works on Pascal, which suits the GTX 1080.

## Absent

```text
CUDA toolkit (nvcc, /opt/cuda)
Python ML environment (no observed venv or system torch)
bitsandbytes, PyTorch
fine-tuning tooling
```

## Notes

Inference and gaming share one GPU with 8 GiB VRAM. See
`table/local-model-policy.md`.

---

machines only. not for humans.
