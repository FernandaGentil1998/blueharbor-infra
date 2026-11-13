# Lab 03 — Exercise 3.4: Linux Hardening



## 1. Firewall Configuration



UFW is enabled on WEB01.



- Default incoming policy: deny.

- Default outgoing policy: allow.

- SSH (TCP 22): allowed only from `10.10.20.0/24`.

- HTTP (TCP 80): allowed for IPv4 and IPv6.



The SSH restriction preserves administrative access from the management network while preventing unrestricted SSH access.



## 2. Kernel Network Hardening



The configuration file `/etc/sysctl.d/99-bh.conf` contains:



```ini

net.ipv4.conf.all.accept_redirects = 0

net.ipv4.conf.all.send_redirects = 0

net.ipv4.conf.all.log_martians = 1

net.ipv4.tcp_syncookies = 1

```



The settings were applied using `sudo sysctl --system` and verified:



- `accept_redirects = 0`

- `send_redirects = 0`

- `log_martians = 1`

- `tcp_syncookies = 1`



An additional configuration file, `/etc/sysctl.d/99-blueharbor-hardening.conf`, also disables default IPv4 redirects and source routing.



## 3. Automatic Security Updates



The `unattended-upgrades` package is installed and its service is enabled and running.



APT periodic configuration enables package-list updates and unattended upgrades.



## 4. Enabled Services



The system reported 84 enabled unit files, including services, sockets, timers, and targets.



Relevant enabled units:



- `ssh.service`: remote administration.

- `nginx.service`: HTTP web server.

- `ufw.service`: firewall.

- `unattended-upgrades.service`: automatic security updates.

- `bh-health.timer`: periodic system health checks.
- `sysstat.service`: system performance monitoring.
- `cron.service`: scheduled task execution.

Other enabled units support Ubuntu initialization, networking, logging, storage, and package management.

## 5. Listening Ports

The `sudo ss -tulpn` command identified:

| Port | Protocol | Service | Justification |
|---|---|---|---|
| 22 | TCP | OpenSSH (`sshd`) | Remote administration, restricted by UFW to `10.10.20.0/24`. |
| 80 | TCP | Nginx | Required to serve HTTP traffic. |
| 53 | TCP/UDP | `systemd-resolved` | Local DNS stub bound to `127.0.0.53` and `127.0.0.54`. |

No other listening services were identified.

## 6. Additional Lynis Recommendations Applied

Two recommendations were implemented:

1. `apt-listchanges`: displays significant changes before APT upgrades.
2. `libpam-tmpdir`: configures private temporary directories for PAM sessions.

Both packages were installed successfully.

## 7. Lynis Audit Results

| Audit | Hardening Index |
|---|---:|
| Initial audit (`lynis-before.txt`) | 59 |
| Intermediate audit (`lynis-after.txt`) | 60 |
| Final audit (`lynis-final.txt`) | 61 |

The final hardening index increased by 2 points compared with the initial audit.

The final audit performed 264 tests. The firewall component was detected as enabled. Lynis still identified areas for improvement, including malware-scanner coverage and additional system configuration recommendations.

The final warning and suggestion totals were not separately verified.

## 8. Evidence

The `evidence/` directory contains:

- `lynis-before.txt`
- `lynis-after.txt`
- `lynis-final.txt`
- `99-bh.conf`

## 9. Conclusion

WEB01 received additional Linux security hardening through firewall restrictions, kernel network settings, automatic updates, and additional security utilities.

The Lynis hardening index improved from 59 to 61. SSH access and HTTP service remain available under the configured firewall rules.

