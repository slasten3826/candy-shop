# machine role

[⊞]

Status: role carried over from the predecessor tree, re-confirmed 2026-09-12.

`candy-shop` is a desktop built primarily for:

```text
games
local model inference and experimentation
parameter-efficient local-model fine-tuning
bulk local storage
```

Everything configured on this machine serves one of those four. Manjaro Linux
and KDE Plasma are the accepted base.

## General Rule

```text
inspect live Manjaro/KDE behavior
keep working defaults
change only what serves the machine role
verify gaming and model workloads after relevant changes
```

## Measured Confirmation

On 2026-09-12 the role was confirmed against the live machine:

```text
games         Steam installed and running, PortProton installed, xone adapter present
local models  ollama.service active with qwen3:8b pulled
storage       Btrfs system disk, ext4 bulk HDD mounted, 512 GB NTFS vault
```

## Relation To Slastpad

Slastpad is the origin of the four-layer operating method used here. It runs a
different stack (Void Linux, runit, Xorg, AwesomeWM) on different hardware, and
its documents describe that machine, not this one.

What is borrowed is the method: layer the knowledge, observe before editing,
verify after, and record evidence with a date. What is not borrowed is the
stack. This machine keeps its own implementation and its own verification.

---

machines only. not for humans.
