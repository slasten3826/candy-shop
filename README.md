# candy-shop snapshot

```text
machine: candy-shop
snapshot_date: 2026-09-12
mode: live_read_only_measurement
audience: public_repository
```

Machine-facing operational snapshot of the `candy-shop` desktop.

This repository records what is actually on the machine on the snapshot date.
It is a measurement, not a plan. Where a policy exists it is recorded, but the
measured state is authoritative for facts about the machine.

This is a public repository. Interface names, IP addresses, keys, and capacity
figures are deliberately excluded. `tools/redact-check.sh` enforces this.

## Layers

```text
⋯ chaos     raw observations taken during the snapshot run
⊞ table     accepted policies, machine role, routes
◈ crystall  implementation and exact current configuration
▲ manifest  verified state with dates
```

Do not flatten the layers.

## Entry Points

```text
table/machine-role.md
table/README.md
crystall/README.md
manifest/README.md
manifest/audit-2026-09-12.md
index.snapshot.json
```

## Reading Order

1. `table/machine-role.md` — what the machine is for
2. `manifest/audit-2026-09-12.md` — measured state of the whole machine
3. `crystall/` — exact configuration per subsystem
4. `table/` — accepted policies per subsystem
5. `chaos/` — raw capture transcript and open items
6. `index.snapshot.json` — machine-readable index

## Provenance

All measurements were taken read-only on 2026-09-12 during one session.
No configuration, mount, package, or service was changed.

Two privileged reads were attempted and denied without root:

```text
btrfs subvolume list /     -> Operation not permitted
dmidecode -t memory        -> not available without root
```

Those two facts are therefore absent, not negative.

## Predecessor

An earlier documentation tree for this machine was measured 2026-08-21 through
2026-09-03. Several of its recorded facts are now stale; see
`manifest/audit-2026-09-12.md` section "Drift From Predecessor".

---

machines only. not for humans.
