# BlueHarbor — Cloud Security, FinOps and Compliance Matrix

## 1. Purpose and Scope

This document maps the D10 learning outcomes to the security, infrastructure, storage, monitoring and cost-management controls implemented in the BlueHarbor project.

It also relates the implemented controls to relevant themes from:

- ISO/IEC 27017 — Information security controls for cloud services.
- ISO/IEC 27018 — Protection of personally identifiable information (PII) in public clouds acting as PII processors.

This is an educational control mapping, not a formal compliance assessment, certification or legal determination.

## 2. D10 Learning Outcomes

| Learning outcome | Evidence | Assessment |
|---|---|---|
| Explain the shared responsibility model | `lab06/providers.md`; `lab06/service-models.md` | Partially documented |
| Configure IAM, roles, policies and authentication | `lab10/access-matrix.md`; `lab06/supabase.md`; `lab09/exercise-9.3.md` | Implemented within documented scopes |
| Secure networks, storage, logs, keys and secrets | `lab05/`; `lab07/logging.md`; `lab08/exercise-8.5.md`; `lab10/security-controls.md` | Partially implemented; gaps documented |
| Analyze costs and cloud usage | `lab06/usage.md`; `lab06/providers.md` | Documented |
| Evaluate cloud security and privacy practices | This matrix and `lab10/security-controls.md` | Educational mapping completed; formal compliance not assessed |

## 3. Shared Responsibility Model

BlueHarbor uses multiple cloud service models. Security responsibilities vary according to the service and deployment model.

| Service | Model | Provider responsibilities | BlueHarbor responsibilities |
|---|---|---|---|
| Vercel | PaaS | Underlying hosting platform and managed runtime infrastructure | Application code, environment variables, access configuration and application security |
| Supabase PostgreSQL and Storage | DBaaS / managed cloud services | Managed service infrastructure and platform operations | Database permissions, RLS, data classification, credentials, backup configuration and application access |
| GitHub Actions and GHCR | Managed CI/CD and registry | GitHub platform availability and underlying service security | Workflow permissions, repository access, secrets, code review and image security |
| Self-managed Ubuntu VMs | IaaS-like / self-managed infrastructure | Virtualisation and physical infrastructure where applicable | Operating system, network, firewall, services, accounts, monitoring, patching and backups |
| Kubernetes workloads | Container orchestration | Depends on the underlying cluster provider; the documented Kind cluster is locally managed | Container images, manifests, workload configuration, access controls and application security |

### Shared responsibility principles

- Cloud providers secure the infrastructure and managed-service components assigned to them.
- Customers remain responsible for their data, identities, permissions, application configuration and use of cloud services.
- Managed services reduce infrastructure administration but do not automatically make an application secure or compliant.
- Selecting an EU region does not, by itself, establish GDPR compliance.
- Responsibility boundaries must be verified against the actual provider contract and service documentation.

Evidence: `lab06/providers.md`, `lab06/service-models.md`.

## 4. IAM, Authentication and Access Control

| Control | Implementation evidence | Assessment |
|---|---|---|
| Role-based database access | Supabase viewer and ops roles | Validated |
| Row Level Security | RLS enabled on `public.shipments` | Validated |
| Least privilege | Anonymous SELECT only; viewer write denied; ops write allowed | Validated within the application scope |
| Repository access | GitHub ops team Maintain; auditors team Read | Documented |
| CI access | GitHub Actions workflow and branch protection | Implemented; dedicated identity review remains open |
| Terraform access | No dedicated identity configured | Gap |

### Validation evidence

- Viewer shipment INSERT: HTTP 403.
- Ops shipment INSERT: HTTP 201.
- GitHub ops team: Maintain.
- GitHub auditors team: Read.
- Main branch requires a pull request and successful `test` status check.

Evidence: `lab10/access-matrix.md`, `lab09/exercise-9.3.md`.

## 5. Network, Storage, Logging, Keys and Secrets

| Security domain | Implemented controls | Remaining gaps |
|---|---|---|
| Network | VLAN segmentation, ACLs, SSH restrictions, Windows Firewall scope, UFW | Periodic rule review and centralised policy management |
| Storage | RAID 1, LVM, NFS, iSCSI and private Supabase Storage bucket | Independent audit of provider-side storage controls |
| Backup | Encrypted Restic repository, retention, off-site copy and restore tests | Full physical disaster simulation and backup failure alerting |
| Logging | Suricata, UFW, Fail2ban, rsyslog centralisation and queue recovery | Encrypted log transport, immutable retention and collector tamper protection |
| Secrets | Vercel Environment Variables and root-only Restic password file | Centralised vault, rotation process and external key lifecycle management |
| Application | Non-root Docker user, health checks and CI tests | Image vulnerability scanning and additional runtime controls |

Detailed evidence: `security-controls.md`.

## 6. FinOps and Cloud Usage

BlueHarbor documented cloud provider comparison, pricing models, usage dashboards, quotas and a qualitative 100x traffic scenario.

### Cost management practices

- Compared Vercel, Supabase, AWS and OVHcloud.
- Recorded actual usage and billing observations.
- Reviewed free-tier quotas and service limits.
- Identified possible cost drivers under increased traffic.
- Documented the limitations of estimating future costs without a measurable baseline.

### Assessment

The documented dashboards showed low or zero reported consumption during the observed periods. This does not prove that no requests occurred, because reporting windows and dashboard delays may affect the measurements.

A reliable monetary forecast for the 100x scenario was not produced due to the lack of a sufficiently measurable baseline.

Evidence: `lab06/providers.md`, `lab06/usage.md`.

## 7. ISO/IEC 27017 — Cloud Security Control Mapping

The following table maps selected cloud-security themes to BlueHarbor evidence. It is an educational mapping, not a clause-by-clause conformity assessment.

| Cloud security theme | BlueHarbor evidence | Assessment |
|---|---|---|
| Shared roles and responsibilities | Provider comparison and service model analysis | Partially documented |
| Cloud administration and privileged access | Supabase roles, GitHub teams and SSH restrictions | Implemented in documented scopes |
| Virtual network and service isolation | VLAN segmentation, ACLs, firewall restrictions | Implemented in lab infrastructure |
| Monitoring of cloud and infrastructure activity | Prometheus, Grafana, Suricata, UFW and rsyslog | Partially implemented |
| Protection of stored information | Restic encryption and private off-site storage | Implemented for documented backups |
| Secure deletion and lifecycle management | Retention policy documented for Restic snapshots | Partial; secure deletion across all cloud services not evidenced |
| Cloud service configuration | Vercel environment variables, Supabase RLS and application configuration | Partially implemented |
| Cloud provider assurance | Provider comparison includes certifications and regional considerations | Provider information reviewed; BlueHarbor compliance not established |

## 8. ISO/IEC 27018 — Public Cloud PII Protection Mapping

ISO/IEC 27018 concerns protection of personally identifiable information in public clouds acting as PII processors.

The BlueHarbor lab dataset contains demonstration shipment records. The project does not demonstrate a complete production PII processing lifecycle.

| Privacy theme | BlueHarbor evidence | Assessment |
|---|---|---|
| Data access restriction | Supabase RLS and role-based access | Implemented for documented table operations |
| Data minimisation | Demonstration records contain shipment ID, status, hub and timestamp | Limited demonstration dataset |
| Processing transparency and instructions | Provider/service model documentation | Partially documented |
| PII disclosure and subprocessor transparency | No complete PII processing inventory or subprocessor assessment | Not evidenced |
| Retention and deletion | Restic backup retention policy | Backup retention documented; application-data lifecycle not established |
| Data return and portability | Restic repository can be downloaded from Supabase and restored | Backup portability validated; complete customer data export process not established |
| Breach notification and privacy incident handling | Infrastructure incident report exists | Privacy-specific breach notification process not evidenced |
| Data subject rights | No documented access, correction or erasure workflow | Not evidenced |

### Privacy considerations

- The demonstration shipment records must not be treated as proof of a production PII governance programme.
- Public read access is limited to the documented demonstration table and should not be reused for confidential customer data.
- A production deployment would require data classification, lawful processing assessment, retention rules, access governance and appropriate contractual safeguards.
- Provider region selection alone does not establish GDPR compliance.

## 9. Prioritised Improvement Plan

| Priority | Improvement | Reason |
|---|---|---|
| High | Introduce centralised secrets and key management | Reduce reliance on local password files and improve credential lifecycle control |
| High | Define production data classification and privacy controls | Establish appropriate safeguards before processing real customer PII |
| High | Protect centralised logs against tampering and use encrypted transport | Improve confidentiality and integrity of security evidence |
| Medium | Review CI workflow permissions and introduce dedicated identities | Strengthen automation least privilege |
| Medium | Implement image vulnerability scanning | Identify vulnerable container dependencies and images |
| Medium | Add backup failure alerting and perform full disaster recovery exercises | Improve recovery assurance |
| Medium | Establish periodic IAM and access reviews | Detect excessive or obsolete permissions |
| Low | Improve cost forecasting using measurable workload baselines | Support more reliable capacity and budget planning |

## 10. Final Assessment

BlueHarbor demonstrates practical implementation of cloud security, IAM, network segmentation, monitoring, encrypted backup, recovery and cost-management practices.

The project also identifies limitations in secrets lifecycle management, log protection, production privacy governance, automation identities and formal compliance assurance.

The ISO/IEC 27017 and ISO/IEC 27018 mappings are intended to demonstrate understanding of relevant cloud-security and privacy themes. They do not establish certification or full conformity with either standard.

The D10 learning outcomes are documented through implementation evidence and explicit gap analysis.

## 11. NIST CSF 2.0 and ISO/IEC 27001:2022 Annex A Mapping

This table maps selected security controls to NIST CSF 2.0 and ISO/IEC 27001:2022 Annex A. The mapping is educational and does not constitute a formal compliance assessment.

| # | Security control | NIST CSF 2.0 | ISO/IEC 27001:2022 Annex A | BlueHarbor evidence | Status |
|---|---|---|---|---|---|
| 1 | Security roles and responsibilities | GV.RR | A.5.2 | `lab10/access-matrix.md`; `lab06/service-models.md` | Partially implemented |
| 2 | Risk assessment and treatment | GV.RM; ID.RA | A.5.4; A.5.7 | `lab05/risk-register.md`; `lab05/incident-report.md` | Implemented in documented scope |
| 3 | Asset and service inventory | ID.AM | A.5.9; A.5.12 | `lab04/resources.md`; `lab06/providers.md` | Partially implemented |
| 4 | Identity and access management | PR.AA | A.5.15; A.5.16; A.5.18 | `lab10/access-matrix.md`; `lab06/supabase.md` | Implemented in documented scope |
| 5 | Authentication and privileged access | PR.AA | A.5.17; A.8.2; A.8.5 | `lab10/access-matrix.md`; `lab05/segmentation.md` | Partially implemented |
| 6 | Network security and segmentation | PR.IR | A.8.20; A.8.21; A.8.22 | `lab05/segmentation.md`; `lab05/exposure.md` | Implemented in lab infrastructure |
| 7 | Secure configuration and hardening | PR.PS | A.8.9; A.8.32 | `lab03/hardening.md`; `lab10/security-controls.md` | Implemented in documented scope |
| 8 | Data protection and backup | PR.DS | A.8.10; A.8.13; A.8.24 | `lab08/exercise-8.5.md`; `lab10/security-controls.md` | Partially implemented |
| 9 | Logging and monitoring | DE.CM; DE.AE | A.8.15; A.8.16 | `lab07/logging.md`; `lab05/incident-report.md` | Partially implemented |
| 10 | Vulnerability and security testing | ID.RA; DE.CM | A.8.8; A.8.29 | `.github/workflows/ci.yml`; Checkov scans | Partially implemented |
| 11 | Incident response and communication | RS.MA; RS.AN; RS.CO | A.5.24; A.5.25; A.5.26 | `lab05/incident-report.md` | Documented |
| 12 | Recovery and continuity | RC.RP; RC.CO | A.5.29; A.5.30; A.8.13 | `lab08/exercise-8.5.md`; backup and restore evidence | Partially implemented |

The status describes the evidence available in this educational repository. A mapped control does not imply full implementation or certification. Control applicability and exact mapping should be validated against the organisation's scope and Statement of Applicability.

## 12. Terraform Validation and Checkov Scan Evidence

Validation and security scanning are separate activities and their results must not be interpreted interchangeably.

| Scope | Tool | Result | Interpretation |
|---|---|---|---|
| `cloud/lab-infra` | Terraform init and validate | Successful | Configuration initialized and validated |
| `cloud/platform` | Terraform init and validate | Successful | Configuration initialized and validated |
| `trackit/Dockerfile` | Checkov 3.4.7 | 31 passed, 0 failed, 0 skipped | Dockerfile security checks completed |
| `trackit/k8s` | Checkov 3.4.7 | 180 passed, 0 failed, 0 skipped | Kubernetes security checks completed |
| `cloud/` | Checkov 3.4.6 | 0 resources, 0 passed, 0 failed, 0 skipped, 0 parsing errors | No Terraform resources were evaluated |

The Terraform Checkov result is a coverage limitation, not evidence that the Terraform resources passed security checks. The Docker and Vercel providers contain resources that were not recognized by the tested Checkov configuration.

Terraform initialization and validation confirm configuration validity but do not replace security policy checks. The GitHub Actions workflow therefore includes explicit Terraform initialization and validation for both directories. Its execution must be confirmed after this workflow change is pushed.
