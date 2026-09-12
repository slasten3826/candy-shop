# machine role

Status: role carried over from the predecessor tree, re-confirmed 2026-09-12.

`candy-shop` is a desktop built primarily for:

```text
games
local model inference and experimentation
parameter-efficient local-model fine-tuning
bulk local storage
```

The installed Manjaro Linux and KDE Plasma desktop are the accepted base.

The machine is not expected to reproduce Slastpad's Void Linux, runit, Xorg,
and AwesomeWM stack. Slastpad supplies preferences and the four-layer operating
method; `candy-shop` keeps machine-specific implementation and verification of
its own.

General rule:

```text
inspect live Manjaro/KDE behavior
keep working defaults
change only what serves the machine role
verify gaming and model workloads after relevant changes
```

Measured confirmation of the role on 2026-09-12:

```text
games         Steam installed and running, PortProton installed, xone adapter present
local models  ollama.service active with qwen3:8b pulled
storage       Btrfs system disk, ext4 bulk HDD mounted, 512 GB NTFS vault
```

---

machines only. not for humans.
