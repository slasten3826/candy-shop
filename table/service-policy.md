# service policy

Status: measured 2026-09-12. This records the security posture as-is, not a
decision to change it.

## Exposed services

```text
sshd:        active, enabled, listening on port 22 (IPv4 + IPv6)
cups:        active (printing)
kdeconnect:  running, mDNS 5353
ModemManager: active
networking:  NetworkManager on enp9s0, plus an active VPN tun (throne-tun)
```

## Firewall

```text
firewalld: inactive
ufw:       inactive
no host firewall is active
```

This is the measured state. SSH is open and no firewall filters it. Every host
on the LAN can reach port 22.

## Rules

```text
do not change service or firewall state without confirming remote-access intent
if a firewall is added, preserve SSH access explicitly before enabling it
confirm whether printing, Bluetooth, and KDE Connect are wanted before touching them
```

## Rationale

The predecessor audit listed these as observations and deferred the decision.
This snapshot keeps that posture: the state is recorded, the decision is not
made.

---

machines only. not for humans.
