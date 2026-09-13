# storage implementation

Status: measured read-only 2026-09-12.

## Devices

```text
/dev/nvme0n1  476.9 GiB  Silicon Motion SM2263EN/XT NVMe (DRAM-less), system disk
  nvme0n1p1     300 MiB  vfat   EFI, UUID DB94-92C0, mounted /boot/efi
  nvme0n1p2   476.6 GiB  btrfs  UUID 4517b60b-00c4-4f0a-8c8a-bec493d88b17

/dev/sda      465.8 GiB  HGST 5400 RPM HDD (internal)
  sda1        465.8 GiB  ext4   label candy-hdd
                                UUID b6c2de9f-12ba-4b1c-8f9c-07380e33c66b

/dev/sdb      476.9 GiB  external Samsung SSD over USB (ASM1051 bridge)
  sdb1        476.9 GiB  ntfs   label VAULT_512
                                UUID 76D8C71C1B6196A8
```

## Btrfs subvolumes

```text
/@       -> /
/@home   -> /home
/@cache  -> /var/cache
/@log    -> /var/log
```

All Btrfs mounts use `compress=zstd:1`.

## Mounts

```text
/grp          btrfs subvolume group (@, @home, @cache, @log)
/boot/efi     vfat, 300 MiB partition
/home/slasten/hdd   ext4, bulk HDD
/run/media/slasten/VAULT_512   ntfs, external vault, on demand
/tmp          tmpfs, mode 1777, noatime
```

## Capacity and usage

```text
/                 328 GiB used of 476.6 GiB
VAULT_512         706 MiB used
/home/slasten/hdd bulk HDD, roughly 20 GiB used at first measurement
```

For comparison, the predecessor measured `/` at 11 GiB used on 2026-08-21. The
growth is game and media content, not corruption and not a snapshot pile-up:

```text
/home/slasten total        309 GiB
  PortProton               106 GiB
    data/prefixes           99 GiB   (Wine prefixes, one per installed game)
    data/dist              3.7 GiB
    data/tmp               3.1 GiB
  work                     578 MiB
  pic                      197 MiB
  codex                    143 MiB
  downloads                126 MiB
/var                      7.5 GiB
```

Roughly 99 GiB sits under the single directory `PortProton/data/prefixes`, from
installing games. That plus ordinary home growth accounts for the jump.

The bulk HDD, a separate filesystem mounted under the home path, held:

```text
/home/slasten/hdd total    379 GiB
  nsfw                     217 GiB
  Games                    113 GiB
  downloads                 49 GiB
  Steam                     12 KiB
```

Here `du -x` on `/home/slasten` reports 309 GiB while `/home/slasten/hdd`
reports 379 GiB, because the HDD is mounted inside the home path but is its own
filesystem. The 328 GiB figure above is the root Btrfs filesystem itself.

Not investigated: whether `PortProton/data/tmp` (3.1 GiB) is safe to clear.

## /etc/fstab (live)

```fstab
UUID=DB94-92C0                            /boot/efi      vfat    defaults,umask=0077 0 2
UUID=4517b60b-00c4-4f0a-8c8a-bec493d88b17 /              btrfs   subvol=/@,defaults,compress=zstd:1 0 0
UUID=4517b60b-00c4-4f0a-8c8a-bec493d88b17 /home          btrfs   subvol=/@home,defaults,compress=zstd:1 0 0
UUID=4517b60b-00c4-4f0a-8c8a-bec493d88b17 /var/cache     btrfs   subvol=/@cache,defaults,compress=zstd:1 0 0
UUID=4517b60b-00c4-4f0a-8c8a-bec493d88b17 /var/log       btrfs   subvol=/@log,defaults,compress=zstd:1 0 0
tmpfs                                     /tmp           tmpfs   defaults,noatime,mode=1777 0 0
UUID=b6c2de9f-12ba-4b1c-8f9c-07380e33c66b /home/slasten/hdd ext4 defaults,noatime,nofail,x-systemd.device-timeout=10s 0 2
/swap/swapfile                            none           swap    defaults,pri=10 0 0
```

The external vault is not in `fstab`; it mounts on demand under `/run/media`.

## HDD history

The bulk HDD previously held a FAT32 + BitLocker layout. It was erased and
re-formatted to ext4 during the predecessor work (2026-08-21). The old data is
not recoverable. The pre-change `fstab` backup is
`/etc/fstab.candy-shop-before-hdd-20260821`.

## Contents at measurement

```text
bulk HDD:      downloads, Games, Steam (plus standard lost+found)
external vault: a migration archive and application installer archives
```

Individual directory contents are not enumerated in this public snapshot.

---

machines only. not for humans.
