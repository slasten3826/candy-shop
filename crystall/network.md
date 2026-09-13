# network implementation

Status: measured read-only 2026-09-12.

## Interfaces

```text
enp9s0            up, NetworkManager-managed         192.168.31.42/24
                  Realtek RTL8111/8168/8211/8411 (PCI 09:00.0)
                  link-local  fe80::289a:7b79:4ade:5b9
throne-tun        up, tun type, active
                  virtual tunnel interface, address not published
lo                up
```

The wired link is the primary path. The VPN tunnel is a live part of the
network path, not a leftover, and is intended to stay up at all times. This
network blocks large parts of the internet at the carrier level, so the tunnel
is what makes the machine usable rather than an optional privacy measure. If
the tunnel drops, expect ordinary traffic to fail; check `throne-tun` first
when diagnosing connectivity.

The tunnel's own address and link-local address are deliberately not published.
They identify a network exit point rather than describing this machine's LAN,
and the operator keeps them on the machine instead. See
`local/facts.local.md`, section "Network", for the live values.

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
