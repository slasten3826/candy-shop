# network implementation

Status: measured read-only 2026-09-12.

## Interfaces

```text
wired ethernet   up, NetworkManager-managed
                 Realtek RTL8111/8168/8211/8411 (PCI 09:00.0)
VPN tunnel       up, tun type, active
loopback         up
```

Concrete interface names and addresses are intentionally omitted from this
public snapshot. The wired link is the primary path; the VPN tunnel is a live
part of the network path, not a leftover.

## Exposed listeners

```text
sshd:        port 22, IPv4 + IPv6
cups:        local printing
kdeconnectd: mDNS 5353 (plus a large number of UDP sockets)
steam:       steamwebhelper mDNS 5353, and game-related sockets
```

## Firewall

```text
firewalld: inactive
ufw:       inactive
no host firewall active
```

## DNS / routing

Routing was not enumerated in this snapshot beyond interface state. NTP is
active and the clock is synchronized (see `crystall/system.md`).

---

machines only. not for humans.
