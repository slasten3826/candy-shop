# network verification

Status: verified on the live machine 2026-09-12.

```text
wired ethernet up and NetworkManager-managed
VPN tunnel up and active
sshd listening on port 22
no host firewall active
clock synchronized via NTP
```

The VPN tunnel is confirmed live, not a leftover interface. Whether it is
intended to be always-on was not determined in this snapshot.

SSH is reachable and unfiltered on the LAN. See `table/service-policy.md`.

---

machines only. not for humans.
