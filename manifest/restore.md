# restore this machine from scratch

[▲]

The only document here written as instructions rather than as observation. Every
other file describes what this machine *is*. This one says what to *do* when the
system disk is gone and you are standing at a fresh install with this repository
as your only context.

Read it top to bottom. Each section assumes the previous one is done.

The distinction that matters: Slastpad's repository can specify its machine
because AwesomeWM expresses the whole session in one `rc.lua`. This machine
runs KDE Plasma, whose configuration is spread across many files and is partly
GUI-only, so this document cannot be a specification. It is a restoration
instruction, and it is deliberately incomplete in one place — section 9 — where
no file can substitute for looking at the screen.

---

## 0. Before you touch anything

```text
This machine is not reproducible on different hardware.
```

The B450 board, Ryzen 5 5600X, GTX 1080 (Pascal), and the exact disk layout are
load-bearing. In particular the GPU is Pascal-generation: the NVIDIA driver
branch is pinned to 580xx, and current branches have dropped Pascal. A newer
card means a different driver branch, which means this document is wrong for it.

If the hardware differs, stop and re-derive from `manifest/audit-2026-09-12.md`
rather than following these steps.

```text
username        slasten
home            /home/slasten
```

The username is not cosmetic. Every absolute path in this repository is written
for `/home/slasten`, including the runtime artifacts in `manifest/runtime/` and
the wallpapers in `plasmarc`. A different username breaks them silently.

---

## 1. Base system

Install Manjaro Linux, KDE edition. Accept the defaults for the installer.

```text
edition      Manjaro KDE
bootloader   GRUB, EFI
filesystem   Btrfs
```

The installer will produce the subvolume layout this machine uses. Confirm it
afterward, because section 5 depends on it:

```sh
mount | grep btrfs
```

Expected: `/@`, `/@home`, `/@cache`, `/@log`, all on the same NVMe partition,
all with `compress=zstd:1`.

Notable choices that differ from a fresh Manjaro install, and must be redone:

```text
session      X11, not Wayland
             the ProcessGlyph numpad cannot be wired without it (section 7)
kernel       linux71
swap         none at install; a swapfile is added in section 5
```

Confirm the session type at login: SDDM offers Plasma (X11). Use that one.

---

## 2. Disks

The physical layout the restore must reproduce:

```text
nvme0n1  476.9 GiB  system SSD
  p1       300 MiB  vfat   /boot/efi
  p2     476.6 GiB  btrfs  /@ /@home /@cache /@log

sda      465.8 GiB  HDD, ext4, label candy-hdd, mounted /home/slasten/hdd
sdb      476.9 GiB  external USB SSD, NTFS, label VAULT_512
                    mounted /run/media/slasten/VAULT_512
```

The HDD is mounted by UUID, not by device node, so replacing it is a matter of
taking the new UUID from `blkid` and editing `/etc/fstab`. Do not copy the UUID
from `manifest/audit-2026-09-12.md` — it belongs to the physical disk that was
in the machine on 2026-09-12 and a replacement will have its own.

The vault is NTFS and mounts through `udisks2` when plugged in. Nothing in
`/etc/fstab` is configured for it, and nothing needs to be.

After the disks are mounted, create the swapfile (section 5) before doing
anything memory-hungry. This machine had real memory pressure at 31 GiB.

---

## 3. Packages

Manjaro ships the installer's package selection. Then add what this machine
actually has.

The full explicit list is recoverable, but the important set is small:

```sh
# graphics and Vulkan
sudo pacman -S --needed nvidia-580xx-utils lib32-nvidia-580xx-utils \
    linux71-nvidia-580xx nvidia-580xx-settings vulkan-icd-loader \
    lib32-vulkan-icd-loader vulkan-tools

# local inference on Vulkan
sudo pacman -S --needed ollama ollama-vulkan

# input and window tooling the numpad needs
sudo pacman -S --needed xorg-server xorg-xinit xdotool numlockx

# session and desktop
sudo pacman -S --needed sddm plasma-desktop plasma-x11-session \
    kdeconnect kscreen kscreenlocker kwallet-pam

# time travel
sudo pacman -S --needed timeshift timeshift-autosnap-manjaro grub-btrfs
```

From the AUR (installed here with `yay`):

```text
portproton      Windows game launcher
xone-dkms       Xbox Wireless Adapter driver (built via DKMS)
xone-dongle-firmware
serioussam      game
pcsx2           PS2 emulator
opencode-bin
```

```sh
yay -S --needed portproton xone-dkms xone-dongle-firmware
```

`xone-dkms` builds against the running kernel. After a kernel update it must
rebuild, which DKMS does automatically; verify with `dkms status`.

Do not reproduce the whole package list blindly. Many of the 258 explicit
packages are Manjaro's own defaults and arrive with the edition.

---

## 4. Network

The wired interface is the primary path and is managed by NetworkManager. No
static configuration is needed: plug in, and DHCP assigns it.

```text
interface    enp9s0, Realtek RTL8111/8168/8211/8411
address      192.168.31.42/24 (from DHCP)
```

The VPN tunnel is **mandatory on this network**, not a preference. The machine
lives behind carrier-level blocking that makes large parts of the internet
unreachable without it. Treat the tunnel as part of the network path the same
way the default gateway is.

```text
tunnel       throne-tun, TUN type, always up
```

This repository does not record the tunnel's addresses or its configuration
because they identify a network exit point rather than describing this machine.
Those live in `local/facts.local.md`, section "Network", on the machine itself.
If that file is lost, the tunnel must be re-derived from the provider's own
credentials, which are not in this repository either.

The tunnel is brought up by a userspace client that is not one of the
NetworkManager VPN plugins installed here. It is started independently of the
desktop session.

Verify after bringing it up:

```sh
ip -br link show throne-tun
ping -c1 one.one.one.one   # should succeed only with the tunnel up
```

When connectivity is broken, check `throne-tun` before anything else.

---

## 5. Swap

The swapfile is not part of the installer. Create it explicitly.

```sh
sudo btrfs subvolume create /swap
sudo chattr +C /swap                       # disable COW, required for swap on Btrfs
sudo touch /swap/swapfile
sudo chattr +C /swap/swapfile
sudo fallocate -l 16G /swap/swapfile
sudo chmod 600 /swap/swapfile
sudo mkswap /swap/swapfile
```

Add to `/etc/fstab`:

```text
/swap/swapfile none swap defaults,pri=10 0 0
```

The `C` attribute is the part that fails silently. A swapfile on Btrfs without
COW disabled will refuse to activate. Verify with `lsattr /swap/swapfile` — the
output must contain `C`.

Then enable zswap:

```sh
echo 1 | sudo tee /sys/module/zswap/parameters/enabled
```

and persist it in `/etc/modprobe.d/` or the kernel command line. Swappiness is
60, the default.

Verify: `swapon --show` and `cat /proc/swaps` must both list the file.

---

## 6. GPU and display

The driver is the proprietary NVIDIA branch for Pascal.

```sh
sudo mhwd -a pci nonfree 0300
```

or, on this machine's configuration, the branch is `video-nvidia-580xx`. Do not
install a newer branch: support for Pascal (compute capability 6.1) has been
dropped upstream, and this card depends on 580xx.

The display is a single HDMI output:

```text
HDMI-0   1920x1080 at 60 Hz   primary
```

Other outputs are disconnected. No custom modelines, no scaling, no
multi-monitor arrangement. `AllowTearing` is explicitly `false`.

Verify:

```sh
nvidia-smi
glxinfo | grep -E 'OpenGL renderer|OpenGL version'
```

`glxinfo` comes from `mesa-utils`. Expected: `NVIDIA GeForce GTX 1080/PCIe/SSE2`.

---

## 7. ProcessGlyph numpad

The non-obvious subsystem, and the one most likely to be done wrong.

An 8BitDo Retro 18 Numpad connects over its 2.4 GHz USB dongle and is captured
directly by a daemon that translates its keycodes into ProcessLang glyphs and
injects them into the focused X window.

Four artifacts, all snapshotted under `manifest/runtime/`:

| Artifact | Restore to |
| --- | --- |
| `runtime/processglyphd/processglyphd.py` | `~/.local/bin/processglyphd.py` |
| `runtime/processglyphd/processglyphd-start.sh` | `~/.local/bin/processglyphd-start.sh` |
| `runtime/systemd/processglyphd.service` | `~/.config/systemd/user/processglyphd.service` |
| `runtime/udev/99-8bitdo-processglyph.rules` | `/etc/udev/rules.d/99-8bitdo-processglyph.rules` |

```sh
install -Dm755 manifest/runtime/processglyphd/processglyphd.py       ~/.local/bin/processglyphd.py
install -Dm755 manifest/runtime/processglyphd/processglyphd-start.sh ~/.local/bin/processglyphd-start.sh
install -Dm644 manifest/runtime/systemd/processglyphd.service        ~/.config/systemd/user/processglyphd.service
sudo install -Dm644 manifest/runtime/udev/99-8bitdo-processglyph.rules /etc/udev/rules.d/99-8bitdo-processglyph.rules

sudo udevadm control --reload
systemctl --user daemon-reload
systemctl --user enable --now processglyphd.service
```

**The X authority trap.** This is the reason the start script exists and the
reason the unit does not simply set `XAUTHORITY`. SDDM starts Xorg with a
per-login authority file under `/tmp`, regenerated every login:

```text
XAUTHORITY=/tmp/xauth_XXXXXXXX
```

Pointing the unit at `~/.Xauthority` produces a silent half-failure: device
capture keeps working, glyphs are logged, and nothing reaches any window,
because injection fails with `Authorization required`. The start script resolves
`DISPLAY` and `XAUTHORITY` from a live KDE process at start time and logs the
pair before exec'ing the daemon. Do not replace it with a hardcoded path.

This is also why the session must be **X11** and not Wayland. `xdotool` cannot
inject into a Wayland session.

Verify after login:

```sh
systemctl --user status processglyphd.service
journalctl --user -u processglyphd.service -n 30
```

The log must show a resolved `DISPLAY`/`XAUTHORITY` pair and the device being
grabbed. Then type on the numpad into any text field and confirm glyphs appear.

Full detail: [`../crystall/processglyph-numpad.md`](../crystall/processglyph-numpad.md).

---

## 8. Desktop session

SDDM starts the session. Plasma 6.7.4 on X11. Most of the desktop is Plasma's
own default and restores itself; only the following are this machine's
deliberate choices.

```text
theme        org.manjaro.breath-dark, contrast=4
wallpaper    ~/pic/Сластёна/crystall/wallpaper-hdmi.png
lock screen  autolock off, lock on resume off, timeout 0
keyboard     layouts us,ru, switch mode Window
panel        floating, opacity 2, thickness 44
```

The lock-screen setting is the one with a history: it was disabled deliberately
on 2026-08-23 and the pre-change file is still on the machine as
`kscreenlockerrc.pre-disable-lock-2026-08-23`. Reproduce the *current* state
(lock disabled), not the backup.

The wallpaper lives outside this repository under `/home/slasten/pic/`. It is
not published here. If it is gone, pick any image and update `plasmarc`:

```ini
[Wallpapers]
usersWallpapers=/home/slasten/pic/Сластёна/crystall/wallpaper-hdmi.png
```

The layouts `us,ru` and the theme are set through System Settings; there is no
honest way to script them reliably.

---

## 9. What no file covers

This is the section Slastpad does not need and this machine does.

On an AwesomeWM machine, `rc.lua` *is* the desktop, and restoring it restores
everything. Plasma does not work that way. A meaningful part of this machine's
KDE configuration exists only as GUI state and cannot be reconstructed from
files with confidence: widget layout on the panel, per-application window
rules, notification per-application settings, the exact set of pinned
launchers, KDE Connect device pairings.

Do not attempt to diff the KDE config files against defaults and call the
result a specification. The files contain far more than the deliberate choices,
and separating one from the other requires knowing what the operator intended —
which no file records.

Two honest options instead:

```text
1. Restore the file-based settings in section 8, then rebuild the rest by hand
   from the physical screen. Expect this to take an hour.
2. If the old /home survived on a separate disk, copy ~/.config wholesale and
   accept that it carries stale state along with the good.
```

The operator's own position on this was that the desktop works and is not worth
documenting exhaustively. Take that as the scope: get it working, do not try to
make it byte-reproducible.

---

## 10. Verification

After the restore, these must hold. Each is checkable from the command line.

```sh
# identity
hostname                                  # candy-shop
whoami                                    # slasten
uname -r                                  # 7.1.13-2-MANJARO or newer

# storage
mount | grep btrfs                        # four subvolumes on nvme0n1p2
swapon --show                             # /swap/swapfile, 16G
lsattr /swap/swapfile                     # must contain C

# graphics
nvidia-smi                                # GTX 1080, driver 580.x
glxinfo | grep 'OpenGL renderer'          # NVIDIA GeForce GTX 1080

# network
ip -br addr show enp9s0                   # up, 192.168.31.42/24
ip -br link show throne-tun               # up
ping -c1 one.one.one.one                  # succeeds only through the tunnel

# session
echo $XDG_SESSION_TYPE                    # x11

# numpad
systemctl --user is-active processglyphd  # active
```

Then a manual check no script can do: type on the numpad and watch a glyph
appear in a text field. That is the single test that proves the X authority
resolution is correct, and it is the failure this machine is most likely to
reproduce.

---

machines only. not for humans.
