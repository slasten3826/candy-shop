# gaming and controller verification

Status: verified on the live machine 2026-09-12.

```text
Steam installed and running (steamwebhelper active)
PortProton 1.7.5 installed
Vulkan loaders present for 64-bit and 32-bit
GPU available to the session (driver loaded, no compute processes holding it)
```

## Controller

```text
Xbox Wireless Adapter present (045e:02fe)
xone/0.5.8 DKMS built for the running kernel
xone_dongle, xone_gip, xone_gip_gamepad loaded
```

The module set confirms the adapter is bound to `xone`, not `xpad` or
`mt76x2u`. An actual controller connection (button or input read) was not
exercised in this snapshot.

---

machines only. not for humans.
