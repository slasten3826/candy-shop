# swap implementation

Status: installed 2026-08-22, re-measured 2026-09-12.

## Configuration

```text
path: /swap/swapfile
size: 17179865088 bytes (16 GiB)
priority: 10
filesystem: Btrfs on the system NVMe, subvolume /swap
zswap: enabled
vm.swappiness: 60
hibernation: not configured
```

## Btrfs attributes

```text
---------------C------ /swap
```

`/swap/swapfile` could not be read for attributes without root
(`Operation not permitted`). The parent subvolume carries the no-COW (`C`)
attribute, which is the required condition for a Btrfs swapfile.

## State at measurement

```text
used: 4090966016 bytes (3.8 GiB)
RAM in use at the same moment: 20 GiB of 31 GiB
```

## /etc/fstab entry

```fstab
/swap/swapfile none swap defaults,pri=10 0 0
```

## Backups

```text
/etc/fstab.before-candy-swap-20260822
```

## Verification commands

```sh
swapon --show=NAME,TYPE,SIZE,USED,PRIO --bytes
free -h
lsattr -d /swap /swap/swapfile
findmnt --verify --tab-file /etc/fstab
```

---

machines only. not for humans.
