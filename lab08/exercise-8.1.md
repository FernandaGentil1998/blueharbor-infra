# Lab 08.1 — RAID 1 (Disk Mirroring)

## Objective

Implement software RAID 1 on STOR01 using two virtual disks to provide mirrored storage and redundancy.

The objective is to configure a Linux software RAID array, verify synchronization, and simulate disk failure and recovery.

## Environment

| Component | Configuration |
|---|---|
| Storage Server | STOR01 (Ubuntu Server) |
| RAID Technology | Linux Software RAID (mdadm) |
| RAID Level | RAID 1 |
| Disk 1 | /dev/sdb — 10 GB |
| Disk 2 | /dev/sdc — 10 GB |
| RAID Members | /dev/sdb1 and /dev/sdc1 |
| RAID Device | /dev/md127 (auto-assembled after reboot) |
| Usable Capacity | Approximately 10 GB |

## 1. Disk Preparation

Two additional 10 GB virtual disks were attached to STOR01.

The disks were partitioned for Linux RAID and prepared as members of the mirrored array.

RAID member partitions:

- `/dev/sdb1`
- `/dev/sdc1`

## 2. RAID 1 Configuration

Created a RAID 1 array using `mdadm`.

The array mirrors data across both disks, providing redundancy if one member fails.

The array was initially identified as `/dev/md0` and was subsequently auto-assembled as `/dev/md127` after reboot.

## 3. RAID Synchronization and Verification

Verified the RAID array using:

```bash
cat /proc/mdstat
```

The array status was checked to confirm synchronization and the presence of both active members.

Expected healthy state:

```text
[UU]
```

The `[UU]` status indicates that both RAID members are active.

## 4. Failure Simulation

A controlled failure simulation was performed on one RAID member.

The `/dev/sdc1` partition was marked as failed and removed from the array.

The RAID array continued operating in a degraded state using the remaining member.

## 5. Disk Recovery and Rebuild

The removed RAID member was re-added to the array.

The RAID rebuild process was monitored using:

```bash
cat /proc/mdstat
```

The rebuild completed successfully.

Final verification showed both members active:

```text
[UU]
```

## 6. Final Validation

| Validation | Status |
|---|---|
| Two virtual disks attached | PASS |
| RAID 1 array created | PASS |
| Initial synchronization completed | PASS |
| RAID status monitored | PASS |
| Disk failure simulated | PASS |
| Degraded array operation verified | PASS |
| Failed member re-added | PASS |
| RAID rebuild completed | PASS |
| Final array status `[UU]` | PASS |

## Conclusion

The RAID 1 implementation was successfully completed on STOR01 using two 10 GB virtual disks.

A controlled disk failure was simulated, and the array successfully recovered after the failed member was re-added.

The final `[UU]` status confirmed that both RAID members were active and synchronized.

**Result: SUCCESS**