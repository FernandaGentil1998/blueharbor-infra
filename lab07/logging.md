# Lab 07 — Centralised Logging

## 1. Architecture

WEB01 acts as the central rsyslog collector, receiving logs from WEB02 over TCP port 514.

Remote logs are stored by hostname and program name under:

`/var/log/remote/<hostname>/<program>.log`

WEB02 forwards its logs to WEB01 using TCP with an action queue configured to retry indefinitely.

## 2. Log Search Commands

### Failed SSH logins

Search centralised logs for failed password attempts, authentication failures, and invalid users:

```bash
sudo find /var/log/remote -type f -name '*.log' -exec grep -hiE 'failed password|authentication failure|invalid user' {} +
```

### BlueHarbor health check events

Search for messages related to the `bh-health` service:

```bash
sudo find /var/log/remote -type f -name '*.log' -exec grep -hi 'bh-health' {} +
```

### Sudo command usage

Identify commands executed with sudo:

```bash
sudo find /var/log/remote -type f -name 'sudo.log' -exec grep -hi 'COMMAND=' {} +
```

## 3. Queue and Recovery Validation

The collector on WEB01 was temporarily stopped while WEB02 remained operational. Three test messages were generated on WEB02:

- `queued message 1`
- `queued message 2`
- `queued message 3`

After restarting the collector, all three messages appeared in `/var/log/remote/web02/bhtest.log`.

This confirmed that the rsyslog forwarding action queue retained messages during the collector outage and successfully forwarded them after connectivity was restored.

## 4. Conclusion

Centralised logging was successfully configured and tested. WEB02 forwards logs to WEB01, where they are organised by hostname and program. The forwarding queue was validated during a collector outage, and three useful log searches were tested successfully.
