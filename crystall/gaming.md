# gaming implementation

Status: measured read-only 2026-09-12.

## Packages

```text
steam 1.0.0.87-2
steam-devices 1.0.0.87-2
portproton 1.7.5-1 (AUR)
vulkan-icd-loader 1.4.357.0-1
lib32-vulkan-icd-loader 1.4.357.0-1
vulkan-tools 1.4.357.0-1
vulkan-headers 1:1.4.357.0-1
```

## State at measurement

```text
Steam: running (steamwebhelper active, mDNS 5353 sockets held)
VRAM: 706 MiB used, no compute processes
```

## Absent

```text
system wine
lutris
heroic
gamemode
mangohud
```

## PortProton

```text
launcher: /usr/bin/portproton
data root: /home/slasten/PortProton
dependencies pulled with the package: yad, cabextract, perl-image-exiftool, jq
```

A legacy copy of PortProton state from a previous installation remains at
`/run/media/slasten/VAULT_512/slasten_migration/40_manifest/portproton_keep`.

## Vulkan

Both 64-bit and 32-bit Vulkan loaders are present, which is required for
running 32-bit Windows games through Proton/PortProton.

---

machines only. not for humans.
