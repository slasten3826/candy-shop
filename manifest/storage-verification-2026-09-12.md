# storage verification

Status: verified on the live machine 2026-09-12.

```text
system NVMe (/dev/nvme0n1p2) mounted as /, /home, /var/cache, /var/log via subvolumes
Btrfs compression zstd:1 active per fstab
EFI partition mounted at /boot/efi
bulk HDD (/dev/sda1, ext4, label candy-hdd) mounted at /home/slasten/hdd
external vault (/dev/sdb1, NTFS, label VAULT_512) mounted at /run/media/slasten/VAULT_512
```

All three filesystems were readable and writable-mounted. Capacity figures are
not recorded in this repository.

---

machines only. not for humans.
