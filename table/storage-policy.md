# storage policy

Status: policy carried from predecessor, re-confirmed against the live machine
on 2026-09-12.

## Layout

```text
system   /dev/nvme0n1 — 476.9 GiB NVMe SSD, Btrfs, zstd:1 compression
         subvolumes /@ =/ , /@home =/home , /@cache =/var/cache , /@log =/var/log
bulk     /dev/sda1 — 465.8 GiB HGST HDD, ext4, label candy-hdd
         mounted /home/slasten/hdd
vault    /dev/sdb1 — 476.9 GiB external Samsung SSD, NTFS, label VAULT_512
         mounted /run/media/slasten/VAULT_512
```

## Rules

```text
keep the system disk on Btrfs with subvolumes and zstd:1
keep the bulk HDD under nofail so a missing or failed disk never blocks boot
treat the external vault as removable; never depend on it for boot
do not raise ext4 reserved block percentage on the bulk HDD (set to 0)
```

The bulk HDD `fstab` entry intentionally carries:

```text
defaults,noatime,nofail,x-systemd.device-timeout=10s
```

## Placement

Route bulk data by intent, not by free space:

```text
system NVMe  the OS and home; keep it for the system
bulk HDD     games and working bulk data
vault        archives, migrations, and infrequent bulk data
```

Capacity figures are not tracked in this repository.

## Failure behavior

A failed or disconnected bulk HDD must not prevent boot. `nofail` plus the
10s device timeout enforce this. The external vault is not in `fstab` and is
mounted on demand under `/run/media`.

---

machines only. not for humans.
