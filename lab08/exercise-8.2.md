# Lab 08.2 — LVM and NFS Storage

## Objective

Configure Logical Volume Management (LVM) and Network File System (NFS) on STOR01 to provide flexible storage allocation and shared file access to Linux clients.

The objective is to create logical volumes, configure an NFS export, and validate shared storage access from WEB01 and WEB02.

## Environment

| Component | Configuration |
|---|---|
| Storage Server | STOR01 (Ubuntu Server) |
| NFS Clients | WEB01 and WEB02 (Ubuntu Server) |
| Storage Technology | LVM |
| Volume Group | vg_storage |
| NFS Logical Volume | lv_nfs |
| Logical Volume Size | 4 GB |
| Filesystem | ext4 |
| Mount Point | /mnt/storage |
| NFS Share | /mnt/storage/nfs-share |
| Client 1 | 172.16.30.20 |
| Client 2 | 172.16.30.21 |

## 1. LVM Configuration

Configured LVM storage on STOR01 using the RAID-backed storage device.

Created and configured the physical volume and volume group:

```bash
sudo pvcreate /dev/md127
sudo vgcreate vg_storage /dev/md127
```

Created the initial logical volume:

```bash
sudo lvcreate -L 8G -n lv_data vg_storage
```

The logical volume was formatted with ext4 and mounted at `/mnt/storage`.

## 2. NFS Share Configuration

Created the NFS shared directory:

```bash
sudo mkdir -p /mnt/storage/nfs-share
```

Configured the NFS exports in `/etc/exports`:

```text
/mnt/storage/nfs-share 172.16.30.20(rw,sync,no_subtree_check) 172.16.30.21(rw,sync,no_subtree_check)
```

Installed and enabled the NFS server service.

```bash
sudo apt install nfs-kernel-server -y
sudo systemctl enable --now nfs-kernel-server
```

Applied the export configuration:

```bash
sudo exportfs -ra
sudo exportfs -v
```

## 3. NFS Client Configuration

Configured WEB01 and WEB02 as NFS clients.

The NFS share was mounted at:

```text
/mnt/shared
```

The clients accessed the same exported directory hosted on STOR01.

## 4. Shared Storage Validation

A test file was created from WEB01:

```bash
echo "BlueHarbor NFS test" | sudo tee /mnt/shared/nfs-test.txt
```

The file was successfully accessed from WEB02, confirming shared storage functionality across both clients.

The file ownership appeared as `nobody:nogroup` because of the default NFS root squashing behavior.

## 5. LVM Reorganization

The original logical volume was reorganized to separate NFS and iSCSI storage.

The NFS logical volume was resized to 4 GB and renamed:

```bash
sudo lvrename vg_storage lv_data lv_nfs
```

A separate 4 GB logical volume was created for iSCSI:

```bash
sudo lvcreate -L 4G -n lv_iscsi vg_storage
```

Final logical volume layout:

| Logical Volume | Size | Purpose |
|---|---:|---|
| lv_nfs | 4 GB | NFS shared storage |
| lv_iscsi | 4 GB | iSCSI block storage |

The NFS filesystem was preserved during the reorganization, and the test file was verified after remounting.

## 6. Final Validation

| Validation | Status |
|---|---|
| LVM physical volume configured | PASS |
| Volume group created | PASS |
| Logical volume created and formatted | PASS |
| NFS server installed and enabled | PASS |
| NFS export configured | PASS |
| WEB01 mounted NFS share | PASS |
| WEB02 mounted NFS share | PASS |
| Cross-client file access verified | PASS |
| NFS data preserved during LVM reorganization | PASS |
| Separate NFS and iSCSI logical volumes created | PASS |

## Conclusion

The LVM and NFS implementation was successfully completed.

STOR01 provides shared file storage through an NFS export, accessible by WEB01 and WEB02.

The storage layout was subsequently reorganized into separate logical volumes for NFS and iSCSI, preserving the existing NFS data.

**Result: SUCCESS**