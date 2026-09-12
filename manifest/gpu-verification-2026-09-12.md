# GPU verification

Status: verified on the live machine 2026-09-12.

```text
nvidia-smi responds and reports the GTX 1080
driver 580.178.04 loaded
VRAM: 8192 MiB total, 706 MiB used at rest
compute capability: 6.1
temperature: 37 C, power 14.4 W at idle
modules nvidia, nvidia_uvm, nvidia_modeset, nvidia_drm present
no compute processes running
```

Vulkan enumeration was not separately re-run in this snapshot; the presence of
`vulkan-icd-loader`, `lib32-vulkan-icd-loader`, and a running Steam session with
the NVIDIA driver active is consistent with working Vulkan, but no explicit
`vulkaninfo` capture was taken.

---

machines only. not for humans.
