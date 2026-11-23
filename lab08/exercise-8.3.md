# Lab 08.3 — iSCSI Storage Area Network (SAN)

## Objective

Configure an iSCSI Storage Area Network (SAN) using an Ubuntu storage server as the iSCSI Target and Windows Server as the iSCSI Initiator.

The objective is to provide block-level storage over a dedicated network and validate remote disk access from Windows Server.

## Environment

| Component | Configuration |
|---|---|
| Storage Server | STOR01 (Ubuntu Server) |
| iSCSI Initiator | DC01 (Windows Server) |
| Storage Network | BH-STORAGE |
| STOR01 Storage IP | 172.16.30.30/24 |
| DC01 Storage IP | 172.16.30.10/24 |
| iSCSI Protocol Port | TCP 3260 |
| Logical Volume | vg_storage/lv_iscsi |
| Backstore | blueharbor_lun |
| LUN Capacity | 4 GB |
| Windows Volume | F: |
| Filesystem | NTFS |
| Volume Label | BlueHarbor-iSCSI |

## 1. Storage Preparation

A dedicated 4 GB logical volume was created on STOR01 using LVM.

```bash
sudo lvcreate -L 4G -n lv_iscsi vg_storage
```

The logical volume was assigned to an iSCSI block backstore.

```bash
sudo targetcli /backstores/block create name=blueharbor_lun dev=/dev/vg_storage/lv_iscsi
```

## 2. iSCSI Target Configuration

Created the iSCSI target on STOR01.

Target IQN:

```text
iqn.2003-01.org.linux-iscsi.stor01.x8664:sn.3b8e97134934
```

Created the LUN and verified the target portal on TCP port 3260.

The target configuration was saved and the service enabled.

```bash
sudo targetcli saveconfig
sudo systemctl enable --now rtslib-fb-targetctl
```

## 3. Access Control

Configured an ACL to authorize the DC01 initiator.

Initiator IQN:

```text
iqn.1991-05.com.microsoft:dc01.blueharbor.internal
```

The target uses explicit ACL-based access control (`no-gen-acls`).

CHAP authentication was not configured in this lab.

## 4. Network Connectivity

Configured the dedicated storage network interface on DC01.

| Source | Destination | Test | Result |
|---|---|---|---|
| DC01 — 172.16.30.10 | STOR01 — 172.16.30.30 | ICMP Ping | Successful |
| DC01 — 172.16.30.10 | STOR01 — TCP 3260 | Test-NetConnection | Successful |

## 5. Windows iSCSI Initiator

Enabled the Microsoft iSCSI Initiator service and configured automatic startup.

```powershell
Set-Service -Name MSiSCSI -StartupType Automatic
Start-Service -Name MSiSCSI
```

Registered the STOR01 target portal.

```powershell
New-IscsiTargetPortal -TargetPortalAddress 172.16.30.30
```

Discovered the target and established a persistent connection.

```powershell
Connect-IscsiTarget -NodeAddress "iqn.2003-01.org.linux-iscsi.stor01.x8664:sn.3b8e97134934" -IsPersistent $true
```

The iSCSI session was verified using:

```powershell
Get-IscsiSession
```

Connection status: `IsConnected = True`.

## 6. Disk Initialization and Formatting

The 4 GB iSCSI disk was detected on DC01.

The disk was brought online and initialized using GPT.

```powershell
Set-Disk -Number 1 -IsOffline $false
Initialize-Disk -Number 1 -PartitionStyle GPT
```

Created a partition and assigned drive letter F:.

```powershell
New-Partition -DiskNumber 1 -UseMaximumSize -AssignDriveLetter
```

Formatted the volume using NTFS.

```powershell
Format-Volume -DriveLetter F -FileSystem NTFS -NewFileSystemLabel "BlueHarbor-iSCSI" -Confirm:$false
```

## 7. Read/Write Validation

Created a test file on the iSCSI volume.

```powershell
Set-Content -Path "F:\iscsi-test.txt" -Value "BlueHarbor iSCSI SAN - DC01 test successful"
```

Read the file to validate storage access.

```powershell
Get-Content "F:\iscsi-test.txt"
```

Expected output:

```text
BlueHarbor iSCSI SAN - DC01 test successful
```

The test completed successfully, confirming read/write access to the remote block storage.

## 8. Final Validation

| Validation | Status |
|---|---|
| Dedicated storage network connectivity | PASS |
| TCP 3260 connectivity | PASS |
| iSCSI Target configured on STOR01 | PASS |
| DC01 initiator ACL configured | PASS |
| Windows iSCSI service running | PASS |
| Persistent iSCSI session established | PASS |
| 4 GB disk detected and online | PASS |
| GPT partition created | PASS |
| NTFS volume formatted | PASS |
| Read/write test successful | PASS |

## Conclusion

The iSCSI SAN implementation was successfully completed.

STOR01 provides a 4 GB block storage device through an iSCSI Target, while DC01 connects as an iSCSI Initiator over the dedicated BH-STORAGE network.

The Windows server successfully discovered, connected, initialized, formatted, and accessed the remote storage volume.

**Result: SUCCESS**