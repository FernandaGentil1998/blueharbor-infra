
# Exercise 7.4 — Monitoring with Prometheus and Grafana

## Objective

Deploy a monitoring solution using Prometheus, Node Exporter and Grafana to monitor the BlueHarbor web infrastructure.

## 1. Node Exporter

Prometheus Node Exporter was installed on both web servers:

- WEB01: `10.10.20.20:9100`
- WEB02: `10.10.20.21:9100`

The service was verified as active on both servers, and the `/metrics` endpoint returned HTTP 200.

To allow Prometheus on WEB01 to scrape metrics from WEB02, a UFW rule was added on WEB02:

```bash
sudo ufw allow from 10.10.20.20 to any port 9100 proto tcp
```

This restricts access to port 9100 to the monitoring server.

## 2. Prometheus

Prometheus was installed and configured on WEB01.

Configuration file: `/etc/prometheus/prometheus.yml`

The Node Exporter scrape job was configured with both web servers:

```yaml
- job_name: node
  static_configs:
    - targets: ['localhost:9100', '10.10.20.21:9100']
```

Configuration validation was successful using:

```bash
sudo promtool check config /etc/prometheus/prometheus.yml
```

Prometheus was restarted and its targets were verified through the web interface.

**Monitoring status:**
- WEB01 Node Exporter: UP
- WEB02 Node Exporter: UP
- Prometheus server: UP

All 3 targets were reported as UP (3/3).

## 3. Grafana

Grafana OSS was installed on WEB01 and enabled as a system service.

The Grafana web interface was accessed through an SSH tunnel on port 3000.

Prometheus was added as a Grafana data source using:

`http://localhost:9090`

The connection test completed successfully.

## 4. Monitoring Dashboard

A dashboard named **BlueHarbor - Infrastructure Monitoring** was created.

It contains the following panels:

### CPU Usage (%)

PromQL query:

```promql
100 * (1 - avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])))
```

Displays CPU utilization for both web servers.

### Memory Usage (%)

PromQL query:

```promql
100 * (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)
```

Displays RAM utilization for both web servers.

### Disk Usage (%)

PromQL query:

```promql
100 * (
  1 - (
    node_filesystem_avail_bytes{fstype="ext4", mountpoint=~"/|/boot"}
    /
    node_filesystem_size_bytes{fstype="ext4", mountpoint=~"/|/boot"}
  )
)
```

Displays disk utilization for the root (`/`) and boot (`/boot`) filesystems on both servers.

## 5. CPU Alert Rule

A Grafana alert rule named **High CPU Usage - WEB02** was created.

The rule monitors CPU utilization on WEB02 using:

```promql
100 * (
  1 - avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle", instance="10.10.20.21:9100"}[5m])
  )
)
```

Alert condition:
- Threshold: CPU usage above 80%
- Pending period: 2 minutes
- Evaluation interval: 1 minute

A CPU load test was attempted on WEB02 using `stress-ng`. The alert state changed during testing, but the evaluation subsequently displayed `No data`. Therefore, the alert trigger has not yet been conclusively validated and requires further investigation.

## 6. Current Status

| Component | Status |
|---|---|
| Node Exporter on WEB01 and WEB02 | Completed |
| Prometheus installation and configuration | Completed |
| Prometheus targets | 3/3 UP |
| Grafana installation | Completed |
| Prometheus data source in Grafana | Connected |
| Infrastructure dashboard | Created |
| CPU alert rule | Created |
| CPU stress test and alert validation | Pending investigation |

## 7. Conclusion

Prometheus and Grafana were successfully deployed on WEB01 to monitor both BlueHarbor web servers. CPU, memory and disk metrics are available through the monitoring dashboard.

The CPU alert rule has been configured, but its behavior under sustained CPU load still needs to be validated. This will be addressed during the next troubleshooting session.
