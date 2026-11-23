# BlueHarbor — Security Controls and Evidence

## 1. Purpose

This document consolidates the security controls implemented across the BlueHarbor infrastructure. It maps each control to its implementation, validation evidence and known limitations.

The document records practical implementation evidence. It does not represent an independent security audit or a certification claim.

## 2. Network Security

| Control | Implementation | Evidence | Limitations |
|---|---|---|---|
| Network segmentation | Admin, Servers, Users, Management and Warehouse zones | `lab05/segmentation.md` | Segmentation is limited to the documented lab topology |
| Traffic filtering | Extended ACL on the Users VLAN | `lab05/segmentation.md` | Rules require periodic review |
| Management access | SSH restricted to the Admin subnet | `lab05/segmentation.md` | No centralised privileged access management |
| Service exposure reduction | DC01 TCP 139 restricted to `10.10.10.0/24` | `lab05/exposure.md`; `lab05/evidence/dc01-port139-nmap.txt` | Validation reflects the tested source and network conditions |
| Host firewall | UFW logging and firewall blocks | `lab05/evidence/ufw-blocks-2026-11-23.log` | Log protection and long-term retention are not independently validated |

## 3. Host Security and Threat Detection

| Control | Implementation | Evidence | Limitations |
|---|---|---|---|
| Network threat detection | Suricata 7.0.3 with Emerging Threats Open rules | `lab05/evidence/suricata-fail2ban.md` | Lab validation does not establish continuous production monitoring |
| Local detection rule | ICMP test rule loaded and validated | `lab05/evidence/suricata-icmp-2026-11-23-local.log` | Test rule is a validation mechanism, not a complete detection strategy |
| SSH brute-force protection | Fail2ban detects repeated authentication failures and bans the source IP | `lab05/evidence/ssh-authentication-utc.log`; `lab05/incident-report.md` | Exact ban timestamp was not captured |
| Host firewall | UFW enabled with logging | `lab05/evidence/ufw-blocks-2026-11-23.log` | Centralised firewall policy management is not configured |

## 4. Identity and Access Management

| Area | Implemented control | Evidence | Limitations |
|---|---|---|---|
| Supabase database | RLS enabled on `public.shipments`; anonymous role has SELECT only | `lab06/supabase.md` | Public read policy is suitable only for demonstration data |
| Supabase application roles | Viewer and ops permissions validated using RLS and SQL privileges | `lab10/access-matrix.md` | Role design is limited to the documented application scope |
| GitHub repository | Ops team has Maintain; auditors team has Read | `lab10/access-matrix.md` | No evidence of a periodic access review |
| CI pipeline | GitHub Actions tests and image publishing configured | `lab09/exercise-9.3.md` | Dedicated least-privilege pipeline identity and credential review are not documented |
| Branch protection | Pull requests and successful test checks required on main | `lab09/exercise-9.3.md` | Mandatory reviewer approval is not configured |
| Terraform identity | No dedicated Terraform identity configured | `lab10/access-matrix.md` | Infrastructure automation identity remains a gap |

## 5. Application and Container Security

| Control | Implementation | Evidence | Limitations |
|---|---|---|---|
| Non-root container | TrackIt image runs as `appuser` UID 10001 | `lab09/exercise-9.1.md` | Runtime hardening beyond the documented configuration is not claimed |
| Container orchestration | Docker Compose and Kubernetes workloads configured | `lab09/exercise-9.2.md`; `lab09/exercise-9.4.md` | Kubernetes network policies and dedicated workload identities are not evidenced |
| Health monitoring | Application health endpoint and Kubernetes probes | `lab09/exercise-9.1.md`; `lab09/exercise-9.4.md` | Health checks do not replace security monitoring |
| CI validation | Automated pytest execution and container image publishing | `lab09/exercise-9.3.md` | Image vulnerability scanning is not evidenced |

## 6. Storage, Backup and Data Protection

| Control | Implementation | Evidence | Limitations |
|---|---|---|---|
| Storage redundancy | RAID 1, LVM, NFS and iSCSI | `lab08/exercise-8.1.md`; `lab08/exercise-8.2.md`; `lab08/exercise-8.3.md` | Redundancy does not replace backup |
| Cloud object storage | Private Supabase Storage bucket for off-site backups | `lab08/exercise-8.5.md` | Provider-side configuration and access logs are not independently audited |
| Backup encryption | Restic encrypted repository | `lab08/exercise-8.5.md` | Encryption key lifecycle and external key management are not implemented in the documented lab |
| Password protection | Restic password file stored at `/root/.restic-password` with mode 600 | `lab08/exercise-8.5.md` | Local root-level storage is not a centralised secrets vault |
| Backup retention | 7 daily, 4 weekly and 3 monthly snapshots | `lab08/exercise-8.5.md` | Retention is configured for the documented repository |
| Disaster recovery | Local and off-site restore tests completed successfully | `lab08/exercise-8.5.md` | Full physical failure of WEB01 or STOR01 was not simulated |
| Automated backup | systemd service and daily timer | `lab08/exercise-8.5.md` | Alerting for failed scheduled backups is not evidenced |

## 7. Secrets and Application Credentials

- Supabase project URL and publishable key are configured as Vercel Environment Variables for Production and Preview.
- Credential values are intentionally excluded from the repository.
- The application reads `SUPABASE_URL` and `SUPABASE_KEY` from environment variables.
- The documented key is a Supabase publishable key, not a service-role secret.
- The Docker Compose configuration does not inject Supabase credentials.
- The Restic repository password is stored in a root-only local file with permissions 600.

Known gaps:
- No dedicated centralised secrets manager is documented.
- Key rotation procedures and periodic credential reviews are not evidenced.
- No dedicated Terraform identity is configured.
- No evidence of a separate key-management service for Restic encryption keys.

Evidence: `lab06/supabase.md`, `lab08/exercise-8.5.md`, `trackit/app.py`, `trackit/compose.yaml`.

## 8. Logging, Monitoring and Incident Response

| Control | Implementation | Evidence | Limitations |
|---|---|---|---|
| Centralised logging | WEB02 forwards logs to WEB01 using rsyslog over TCP 514 | `lab07/logging.md` | Transport encryption is not documented |
| Forwarding resilience | rsyslog action queue retries during collector outage | `lab07/logging.md` | Queue recovery does not protect against tampering at the collector |
| Security event detection | Suricata, UFW and Fail2ban events inspected | `lab05/evidence/suricata-fail2ban.md` | No SIEM or immutable log archive is documented |
| Infrastructure monitoring | Prometheus and Grafana monitor host metrics | `lab07/exercise-7.4.md` | Monitoring coverage is limited to configured targets and metrics |
| Incident response | UTC timeline, evidence preservation, assessment and follow-up actions | `lab05/incident-report.md` | Available events were not all proven to belong to one correlated attack |

## 9. Security Risk Assessment

The infrastructure risk register identifies assets, confidentiality, integrity and availability ratings, likelihood, impact and proposed controls.

Evidence: `lab05/risk-register.md`.

Risk treatment should be reviewed as the infrastructure evolves. A documented proposed control must not be interpreted as an implemented control unless implementation evidence exists.

## 10. Overall Assessment

BlueHarbor demonstrates practical security controls across network segmentation, host protection, access management, container security, encrypted backups, monitoring and incident response.

The following areas remain partially implemented or not evidenced:

- Centralised secrets and encryption key lifecycle management.
- Encrypted transport for centralised log forwarding.
- Immutable or tamper-resistant log retention.
- Dedicated least-privilege identities for CI and Terraform.
- Image vulnerability scanning and Kubernetes network policies.
- Automated alerting for backup failures.
- Formal periodic access reviews.

These gaps are recorded for future improvement. Their presence does not invalidate the controls that were implemented and tested, but they prevent a claim of comprehensive security coverage.
