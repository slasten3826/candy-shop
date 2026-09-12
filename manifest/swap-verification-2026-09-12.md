# swap verification

Status: verified on the live machine 2026-09-12.

```text
/swap/swapfile active, 16 GiB, priority 10
zswap enabled
vm.swappiness 60
3.8 GiB swap in use at measurement
RAM in use at the same moment: 20 GiB of 31 GiB
```

Swap is functioning and is under real load in normal operation. The machine
does reach memory pressure without any artificial workload.

---

machines only. not for humans.
