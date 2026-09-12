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
Is the VPN tunnel meant to be always-on?
Should a host firewall be configured, given sshd is open and unfiltered?
Should Timeshift snapshots be scheduled for the Btrfs system disk?
Should gamemode / mangohud be added for gaming?
```

## Changes since predecessor

```text
kernel updated
ollama installed (predecessor had no local runtime)
VPN tunnel now present
external vault now mounted
```

---

machines only. not for humans.

---

machines only. not for humans.
