# raw capture 2026-09-12

Verbatim notes and command outputs behind the snapshot. Kept raw so the
crystall and manifest layers can be re-derived without re-running everything.

## Commands that produced the snapshot

```sh
date -Iseconds ; hostnamectl
lscpu ; free -h ; cat /sys/devices/virtual/dmi/id/{board_vendor,board_name,bios_version,bios_date}
lspci -nn | grep -Ei 'vga|3d|audio|ethernet|usb controller|sata|nvme'
nvidia-smi --query-gpu=name,driver_version,vbios_version,memory.total,memory.used,compute_cap,temperature.gpu,power.draw --format=csv
lsmod | grep -Ei 'nvidia|amdgpu|nouveau|xone|xpad|mt76'
lsblk -o NAME,SIZE,TYPE,FSTYPE,LABEL,UUID,MOUNTPOINTS
df -hT ; swapon --show ; cat /sys/module/zswap/parameters/enabled ; cat /proc/sys/vm/swappiness
loginctl show-session <id> ; plasmashell --version ; xrandr --query
nmcli dev status ; ip -brief addr show
systemctl list-units --type=service --state=running ; systemctl --failed ; ss -tulpn
systemctl show ollama -p ActiveState,SubState,MainPID ; ollama --version ; ollama list
pacman -Q | grep -Ei 'cuda|nvidia|ollama|steam|portproton|wine|vulkan'
dkms status ; lsusb | grep 045e
sensors
grep -vE '^\s*#' /etc/fstab ; lsattr -d /swap
timedatectl ; pactl info ; efibootmgr ; powerprofilesctl get
journalctl -b -p err | tail
uptime ; who -b
```

## Denied without root

```text
btrfs subvolume list /
```

Output:

```text
ERROR: can't perform the search: Operation not permitted
```

The `sudo` prompt was not answered (non-interactive shell). Use
`lsblk`/`findmnt` output for the mount picture instead, or re-run with sudo.

```text
dmidecode -t memory
```

Not captured; requires root. RAM speed, type, and slot population are therefore
unknown in this snapshot.

## Raw observations not promoted to crystall

```text
sudo auth failure in journal on 2026-09-11 (password not entered) — benign
steam pressure-vessel-wrap assertion on 2026-09-11 — one occurrence, game still ran
kioworker TIFF "missing ImageLength" on 2026-09-12 — one malformed image file
kdeconnectd holds a large number of UDP sockets — normal for its discovery mode
```

## Machine fact policy

Interface names, IP addresses, host paths, device serials, and disk capacity
figures are machine facts and are published here, the same way the Slastpad
repository publishes its own. What stays out of this repository is secret
material: API keys, tokens, passwords, private keys, `.env` files. See
`crystall/network.md` and `crystall/storage.md` for the values themselves.

## Environment note

The shell resolved some output in Russian (locale). Values above were
transcribed into English; numeric values and identifiers are unchanged.

---

machines only. not for humans.
