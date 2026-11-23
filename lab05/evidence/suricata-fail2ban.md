# Lab 05.4 — Suricata and Fail2ban

## Environment

- Host: WEB01
- Operating system: Ubuntu
- Network interface: enp0s3
- IP address: 10.10.20.20
- Test client: WEB02 (10.10.20.21)

## Suricata Installation and Configuration

- Suricata version: 7.0.3
- ET Open rules installed using `suricata-update`.
- Rules file: `/var/lib/suricata/rules/suricata.rules`
- Rules file size: approximately 45 MB.
- Alert rule occurrences reported by grep: 69,401.
- Local test rule created in `/etc/suricata/rules/local.rules`.
- Local rule copied to `/var/lib/suricata/rules/local.rules`.
- Local rule added to the `rule-files` section of `suricata.yaml`.

## Local Test Rule

```text
alert icmp any any -> any any (msg:"BLUEHARBOR ICMP TEST"; itype:8; sid:1000001; rev:1;)
```

## Suricata Validation Results

- Configuration test (`suricata -T`): successful.
- Suricata service status: active.
- Network interface configured: enp0s3.
- Connectivity test to 8.8.8.8: successful (0% packet loss).
- Suricata log files observed: eve.json, fast.log, stats.log, suricata.log.
- During initial validation, no local ICMP test alert was observed.
- During a later incident drill, eight ICMP test alert lines were observed in `/var/log/suricata/fast.log`.
- This later test confirmed ICMP alert generation.

## Fail2ban Installation and Configuration

- Fail2ban service status: active.
- SSH jail: `sshd`.
- Backend: systemd.
- Journal match: `_SYSTEMD_UNIT=sshd.service + _COMM=sshd`.
- `maxretry`: 5.
- `findtime`: 600 seconds.
- `bantime`: 600 seconds.
- SSH public-key authentication enabled.
- SSH password authentication disabled.

## Controlled Fail2ban Test

A controlled SSH authentication test was performed from WEB02 to WEB01.

- Source host: WEB02 (`10.10.20.21`).
- Destination host: WEB01 (`10.10.20.20`).
- Test account: `testuser` (invalid user).
- Authentication result: `Permission denied (publickey)`.
- WEB01 SSH journal recorded an invalid-user event from `10.10.20.21`.
- Fail2ban initially recorded two failures across the test activity.
- Four additional SSH attempts were executed from WEB02.
- Fail2ban subsequently reported:
  - Currently failed: 1
  - Total failed: 6
  - Currently banned: 1
  - Total banned: 1
  - Banned IP list: `10.10.20.21`

The test confirmed that Fail2ban detected repeated SSH authentication failures and banned the WEB02 source IP. The configured ban duration is 600 seconds.

## Conclusion

Suricata configuration validation succeeded, and ICMP alert generation was subsequently observed during the incident drill.

Fail2ban was also validated through a controlled SSH test. Repeated authentication failures from WEB02 caused the `sshd` jail to ban `10.10.20.21`.

Both Suricata alert generation and Fail2ban blocking behavior have now been demonstrated. The broader incident-response exercise still has separate outstanding tasks documented in `incident-report.md`.
