# swap policy

Status: installed 2026-08-22, re-confirmed live 2026-09-12.

## Configuration

```text
path: /swap/swapfile on Btrfs subvolume /swap
size: 16 GiB (17179865088 bytes)
priority: 10
zswap: enabled
vm.swappiness: 60
hibernation: not configured
```

## Why

Swap exists for memory-pressure absorption: Wine/Proton unpackers and
local-model workloads can spike host RAM beyond the 31 GiB installed.

```text
fstab: /swap/swapfile none swap defaults,pri=10 0 0
```

## Rules

```text
keep the Btrfs no-COW (C) attribute on /swap and /swap/swapfile
never delete the swapfile or subvolume while active
do not configure hibernation without first confirming a resume-capable setup
```

## Live observation

Measured 2026-09-12: 3.8 GiB of swap in use alongside 20 GiB of 31 GiB RAM
used. The machine does reach memory pressure in normal operation, so swap is
load-bearing, not decorative.

---

machines only. not for humans.
