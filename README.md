# candy-shop

Operational memory for one real machine:

```text
hostname     candy-shop
board        ASRock B450 Gaming K4
cpu          AMD Ryzen 5 5600X (6/12)
gpu          NVIDIA GeForce GTX 1080 8 GiB
ram          31 GiB usable
system disk  Silicon Motion SM2263EN NVMe, 477 GiB, Btrfs
bulk disk    HGST 5400 RPM HDD, 466 GiB, ext4
external     Samsung SSD over USB, 477 GiB, NTFS vault
desktop      Manjaro Linux + systemd + SDDM + KDE Plasma 6.7.4 on X11
```

This repository exists so that the next agent can understand, repair, and
rebuild this machine without prior context. It records what was observed, what
was decided, and what was verified.

It is not a dotfiles collection, not a Manjaro installation guide, and not a
claim that another machine should be configured the same way.

## What The Machine Is For

```text
games
local model inference and experimentation
parameter-efficient local-model fine-tuning
bulk local storage
```

Everything configured on this machine serves one of those four. The installed
Manjaro/KDE stack is the accepted base and is not expected to be replaced.

## Authority

The running machine is the source of truth.

```text
observe live state -> read relevant policy -> patch smallest surface -> test -> document evidence
```

Documents describe previously observed reality. They go stale after a package
update, a hardware change, or a live experiment. Never overwrite working state
merely because a document says something different. Inspect first.

## Layer Map

Four layers, in the order a machine should read them:

- [`chaos/`](chaos/) — raw observations, failures, open questions.
- [`table/`](table/) — accepted policies and the machine role.
- [`crystall/`](crystall/) — how each subsystem is actually configured.
- [`manifest/`](manifest/) — verified state with dates, plus a snapshot of
  selected runtime artifacts under [`manifest/runtime/`](manifest/runtime/).

```text
chaos -> table -> crystall -> manifest
⋯        ⊞        ◈          ▲
```

Do not flatten the layers. Each answers a different question: what was noticed,
what was decided, what is configured, what was proven.

## Agent Entry Point

Entering with no prior context:

1. Read this file.
2. Read [`chaos/open-items.md`](chaos/open-items.md) — what is still unresolved
   or unmeasured, so you do not assume it is settled.
3. Read only the relevant policy in [`table/`](table/).
4. Read the matching subsystem note in [`crystall/`](crystall/).
5. Check [`manifest/`](manifest/) for the last verification of that subsystem
   and its date.
6. Read [`manifest/runtime/`](manifest/runtime/) when the task touches something
   that is versioned as an actual file.
7. Inspect the live process, device, service, or configuration before editing.
8. Keep a rollback path for changes that affect networking, input, display,
   session startup, or storage.
9. Record an observed result, not an assumed result.

## Reading Order

```text
table/machine-role.md          what the machine is for
manifest/audit-2026-09-12.md   measured state of the whole machine
crystall/                      configuration, per subsystem
table/                         policy, per subsystem
chaos/                         raw capture, open items, history
index.snapshot.json            machine-readable index
```

## Current System Shape

```text
Manjaro Linux
systemd
SDDM
KDE Plasma 6.7.4 on X11
PipeWire
NVIDIA 580.178.04 (Pascal, GTX 1080)
ollama 0.33.3 on Vulkan (qwen3:8b)
sshd + X11 forwarding
VPN tunnel, always on
```

Notable machine-specific configuration:

- an 8BitDo Retro 18 Numpad over its USB dongle, captured as a ProcessGlyph
  input device and served by a systemd user unit;
- a swapfile plus zswap, 16 GiB;
- PortProton and Steam for Windows titles;
- an always-on VPN tunnel, required on this network;
- bulk storage split across an internal HDD and an external NTFS vault.

## Scope And Security

This repository is public. Real secrets stay out of it: API keys, tokens,
passwords, private keys, `.env` files. Interface names, addresses, host paths,
device serials, and capacity figures are machine facts and are published, the
same way the Slastpad repository publishes its own.

[`tools/redact-check.sh`](tools/redact-check.sh) enforces the secret rule as a
pre-commit hook. [`local/`](local/) holds machine-local material that is not
published; it is gitignored.

## Provenance

The founding measurement was taken read-only on 2026-09-12 during one session.
No configuration, mount, package, or service was changed by it.

Two privileged reads were denied without root and are therefore absent, not
negative:

```text
btrfs subvolume list /     -> Operation not permitted
dmidecode -t memory        -> not available without root
```

An earlier documentation tree for this machine was measured 2026-08-21 through
2026-09-03. Some of its facts are now stale; see
[`manifest/audit-2026-09-12.md`](manifest/audit-2026-09-12.md) section
"Drift From Predecessor".

## Design Rule

```text
make the real machine work
understand why it works
preserve the useful evidence
generalize only after an invariant appears
```

---

machines only. not for humans.
