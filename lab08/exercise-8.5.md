# Exercise 8.5 — Backup, Restore and Disaster Recovery

## 1. Objective

Implement a backup and disaster recovery solution for the BlueHarbor infrastructure using Restic, NFS and Supabase cloud object storage.

The solution provides:
- Encrypted backups of the WEB01 web root.
- Centralized backup storage on the NFS server.
- Off-site backup synchronization to Supabase.
- Local and off-site restoration tests.
- Automated retention and scheduled backups using systemd.

## 2. Architecture

| Component | Configuration |
|---|---|
| Backup client | WEB01 |
| WEB01 storage IP | 172.16.30.20 |
| NFS server | STOR01 |
| STOR01 storage IP | 172.16.30.30 |
| NFS export | /mnt/storage/nfs-share |
| WEB01 mount point | /mnt/shared |
| Restic repository | /mnt/shared/restic-repo |
| Backup source | /var/www/html |
| Off-site provider | Supabase Storage |
| Supabase bucket | backups |
| Remote repository | s3://backups/restic-repo/ |

### Backup flow

1. WEB01 reads the web root directory.
2. Restic creates an encrypted snapshot in the NFS repository hosted on STOR01.
3. The retention policy preserves daily, weekly and monthly snapshots.
4. AWS CLI synchronizes the repository to the private Supabase bucket.
5. A systemd timer schedules the process daily.

## 3. Restic Installation and Repository Configuration

Installed Restic on WEB01:

```bash
apt update && apt -y install restic
restic version
```

Mounted the NFS export:

```bash
mount -t nfs 172.16.30.30:/mnt/storage/nfs-share /mnt/shared
```

Created the repository directory:

```bash
mkdir -p /mnt/shared/restic-repo
```

Initialized the encrypted repository:

```bash
restic -r /mnt/shared/restic-repo init
```

Repository ID: `ddec8788` (short ID).

The repository is password-protected. Its password is stored in `/root/.restic-password` with permissions `600`.

## 4. Initial Backup

Created the first backup:

```bash
restic -r /mnt/shared/restic-repo backup /var/www/html/
```

Initial snapshot:

- Snapshot ID: `32c5cf46`
- Host: `web01`
- Source: `/var/www/html`
- Files: 2
- Data processed: 879 B

Verified the snapshot:

```bash
restic -r /mnt/shared/restic-repo snapshots
```

## 5. Local Restore Test

Simulated accidental deletion of the web page:

```bash
mv /var/www/html/index.html /var/www/html/index.html.deleted
```

Restored the snapshot to a temporary directory:

```bash
restic -r /mnt/shared/restic-repo restore 32c5cf46 --target /tmp/restic-restore
```

Compared the restored file with the preserved original:

```bash
cmp /var/www/html/index.html.deleted \
  /tmp/restic-restore/var/www/html/index.html
```

The files matched. The restored file was copied back to the web root and ownership was restored:

```bash
cp /tmp/restic-restore/var/www/html/index.html /var/www/html/index.html
chown www-data:www-data /var/www/html/index.html
```

**Result:** Local restoration successful.

## 6. Supabase Off-Site Backup

Configured AWS CLI with the `supabase` profile and the Supabase S3-compatible endpoint.

Endpoint:

```text
https://ptbtescajqyqoiogjuei.storage.supabase.co/storage/v1/s3
```

Synchronized the Restic repository to Supabase:

```bash
aws s3 sync /mnt/shared/restic-repo s3://backups/restic-repo/ \
  --profile supabase \
  --endpoint-url "https://ptbtescajqyqoiogjuei.storage.supabase.co/storage/v1/s3"
```

Verified remote objects:

```bash
aws s3 ls s3://backups/restic-repo/ --recursive \
  --profile supabase \
  --endpoint-url "https://ptbtescajqyqoiogjuei.storage.supabase.co/storage/v1/s3"
```

Downloaded the off-site repository to a separate local directory:

```bash
mkdir -p /tmp/restic-offsite-repo

aws s3 sync s3://backups/restic-repo/ /tmp/restic-offsite-repo/ \
  --profile supabase \
  --endpoint-url "https://ptbtescajqyqoiogjuei.storage.supabase.co/storage/v1/s3"
```

Verified that Restic could open the downloaded repository:

```bash
restic -r /tmp/restic-offsite-repo snapshots
```

## 7. Off-Site Disaster Recovery Test

Restored the initial snapshot from the repository downloaded from Supabase:

```bash
restic -r /tmp/restic-offsite-repo restore 32c5cf46 \
  --target /tmp/dr-restore
```

Compared the restored file with the active web page:

```bash
cmp /var/www/html/index.html \
  /tmp/dr-restore/var/www/html/index.html
```

Output:

```text
Off-site DR successful: files match
```

**Result:** Successful restoration from the off-site copy.

This test validated recovery using the Supabase repository copy independently of the NFS repository path. It did not simulate a complete physical failure of STOR01 or WEB01.

## 8. Retention Policy

Configured the following retention policy:

- 7 daily snapshots.
- 4 weekly snapshots.
- 3 monthly snapshots.

Command:

```bash
restic -r /mnt/shared/restic-repo forget \
  --keep-daily 7 \
  --keep-weekly 4 \
  --keep-monthly 3 \
  --prune
```

The policy was executed successfully. The initial snapshot was preserved.

## 9. Automated Backup with systemd

### Password file

Stored the Restic password securely:

```bash
printf '%s' "$RESTIC_PASSWORD" > /root/.restic-password
chmod 600 /root/.restic-password
```

Verified that Restic could access the repository using `RESTIC_PASSWORD_FILE`.

### Backup script

Created:

`/usr/local/sbin/blueharbor-restic-backup.sh`

The script:
1. Sets `RESTIC_PASSWORD_FILE`.
2. Verifies that `/mnt/shared` is mounted.
3. Runs the Restic backup.
4. Applies the retention policy.
5. Synchronizes the repository to Supabase.
6. Exits with an error if a step fails.

The script was assigned permission `700` and validated using:

```bash
bash -n /usr/local/sbin/blueharbor-restic-backup.sh
```

### systemd service

Created:

`/etc/systemd/system/blueharbor-backup.service`

The service runs the backup script as root, waits for network availability and requires the NFS mount.

### systemd timer

Created:

`/etc/systemd/system/blueharbor-backup.timer`

Configuration:

```ini
[Unit]
Description=Run BlueHarbor Backup Daily

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true
Unit=blueharbor-backup.service

[Install]
WantedBy=timers.target
```

Activated the timer:

```bash
systemctl daemon-reload
systemctl enable --now blueharbor-backup.timer
```

Verified the timer:

```bash
systemctl is-enabled blueharbor-backup.timer
systemctl is-active blueharbor-backup.timer
```

Both returned:

```text
enabled
active
```

The next scheduled execution was November 24, 2026 at 02:00 CET.

### Automation test

Executed the service manually:

```bash
systemctl start blueharbor-backup.service
systemctl status blueharbor-backup.service --no-pager
```

Result:

```text
code=exited, status=0/SUCCESS
```

The script completed backup, retention and off-site synchronization successfully.

Two snapshots were subsequently verified in the Supabase bucket:

- `32c5cf46...`
- `7953d213...`

## 10. Final Validation

| Test | Result |
|---|---|
| Restic repository initialization | PASS |
| NFS repository access | PASS |
| Initial web root backup | PASS |
| Local restoration | PASS |
| Supabase off-site synchronization | PASS |
| Off-site repository access | PASS |
| Off-site restoration | PASS |
| Retention policy execution | PASS |
| Backup script syntax validation | PASS |
| systemd service execution | PASS |
| systemd timer activation | PASS |
| Remote snapshot verification | PASS |

## 11. Conclusion

The BlueHarbor backup and disaster recovery solution was successfully implemented.

WEB01 now creates encrypted backups on the NFS repository hosted by STOR01, maintains snapshots according to the configured retention policy, and synchronizes the repository to private Supabase object storage.

Both local and off-site restoration tests were successful. The automated backup workflow was also executed manually through systemd and completed with a successful exit status.

The daily systemd timer is enabled and active.
