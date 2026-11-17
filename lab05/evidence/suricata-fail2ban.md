

\# Lab 05.4 — Suricata and Fail2ban



\## Environment

\- Host: WEB01

\- Operating system: Ubuntu

\- Network interface: enp0s3

\- IP address: 10.10.20.20



\## Suricata Installation and Configuration

\- Suricata version: 7.0.3

\- ET Open rules installed using `suricata-update`.

\- Rules file: `/var/lib/suricata/rules/suricata.rules`

\- Rules file size: approximately 45 MB.

\- Alert rule occurrences reported by grep: 69,401.

\- Local test rule created in `/etc/suricata/rules/local.rules`.

\- Local rule copied to `/var/lib/suricata/rules/local.rules`.

\- Local rule added to the `rule-files` section of `suricata.yaml`.



\## Local Test Rule



```text

alert icmp any any -> any any (msg:"BLUEHARBOR ICMP TEST"; itype:8; sid:1000001; rev:1;)

```



\## Validation Results

\- Configuration test (`suricata -T`): successful.

\- Suricata service status: active.

\- Network interface configured: enp0s3.

\- Connectivity test to 8.8.8.8: successful (0% packet loss).

\- Suricata log files observed: eve.json, fasto.log, stats.log, suricata.log.

\- No `BLUEHARBOR ICMP TEST` alert observed during testing.



\## Fail2ban

\- Fail2ban service status: active.



\## Pending Validation

\- Confirm Suricata packet capture and alert generation.

\- Perform controlled traffic detection test.

\- Validate Fail2ban blocking behavior.

\- Complete testing requiring WEB02 once its boot issue is resolved.



\## Conclusion

Suricata and Fail2ban are installed and their services are active on WEB01. Suricata configuration validation succeeded and the local ICMP test rule was created and loaded. However, alert generation and Fail2ban blocking behavior remain pending verification.



