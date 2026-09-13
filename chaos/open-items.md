# open items

Unresolved questions and unknowns left by the 2026-09-12 snapshot. These are
not defects; they are facts that were not measured or decisions not made.

## Not measured

```text
RAM module type, speed, and slot population      (dmidecode requires root)
Btrfs subvolume list                             (requires root)
Explicit vulkaninfo enumeration                  (inferred from packages, not captured)
End-to-end ollama inference on GPU               (service checked, request not run)
Controller input read                            (modules loaded, button not pressed)
DNS servers and routing table
Full installed package manifest                  (only count recorded: 1363)
```

## Not decided

```text
Should a host firewall be configured, given sshd is open and unfiltered?
Should gamemode / mangohud be added for gaming?
```

Settled by the operator on 2026-09-13:

```text
VPN always on      yes, by necessity. The carrier blocks large parts of the
                   internet; the tunnel is what makes the machine usable.
Btrfs snapshots    already taken before package updates. No schedule needed.
```

## Waiting for a reboot

```text
Does processglyphd start correctly after a real reboot?

The service is enabled and its wrapper resolves DISPLAY/XAUTHORITY from the
live KDE session at start time. What has not been observed is the ordering: the
unit carries After=graphical-session.target but is WantedBy=default.target, so
After= imposes order, not dependency. If the service starts before plasmashell
exists, the wrapper falls back to probing /run/sddm/* and /tmp/xauth_*, and
could pick up a stale authority file from a previous login. The daemon would
then hold the device (log shows "grab ok") while its glyphs reach no window.

Check after the next reboot:

    systemctl --user status processglyphd.service
    journalctl --user -u processglyphd.service -n 20

A healthy start shows a "session env:" line naming a freshly resolved
XAUTHORITY, then "grab ok". If glyphs do not appear while grab succeeded, the
authority file is the first thing to suspect.

Deliberately not changed: hard-binding the unit to graphical-session.target
(Requisite=/PartOf=/WantedBy=) would guarantee ordering but risks blocking the
service entirely if KDE does not raise that target on this system. The operator
chose to leave it working and observe the reboot rather than trade a known-good
setup for an unverified one.
```

## Changes since predecessor

```text
kernel updated
ollama installed (predecessor had no local runtime)
VPN tunnel now present
external vault now mounted
```

## Resolved after measurement

```text
Root filesystem growth 11 GiB -> 328 GiB between the predecessor measurement
and the snapshot. Explained on 2026-09-12: it is not corruption and not a
snapshot pile-up. It is game and media content, dominated by PortProton
prefixes under the home directory and bulk media on the HDD. Figures are in
crystall/storage.md, section "Capacity and usage".
```

---

machines only. not for humans.
