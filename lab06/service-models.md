# Lab 06 — Exercise 6.2: Service Model Classification

| Workload | Model | Provider | Justification | Three BlueHarbor responsibilities | One risk |
|---|---|---|---|---|---|
| Mail and office tools | SaaS | Microsoft 365 | Ready-to-use applications managed by the provider | Manage user accounts; configure permissions; protect company data | Provider outage or service dependency |
| TrackIt web application | PaaS | Vercel | Hosts and runs the application without requiring BlueHarbor to manage servers or the OS | Maintain application code; manage environment variables; configure access and domain | Free-plan limits or vendor lock-in |
| TrackIt database | DBaaS | Supabase | Managed PostgreSQL database without managing database infrastructure | Manage database access; configure security and RLS; manage data and backups | Provider dependency or data exposure due to misconfiguration |
| Active Directory | IaaS | Cloud VM (Azure/AWS) | Migrates the existing Windows Server domain controller while retaining OS-level control | Patch Windows Server; manage AD users and groups; maintain domain controller security | Incorrect configuration or unpatched vulnerabilities |
| File shares | IaaS | Cloud VM (Azure/AWS) | Preserves the existing Windows file server and its configuration | Patch the OS; manage file-share permissions; monitor storage capacity | Misconfigured permissions or data loss |
| Finance accounting software | IaaS | Cloud VM (Azure/AWS) | Supports software requiring a specific Windows Server version | Maintain the OS; install and update accounting software; manage access and licensing | Unsupported or outdated OS version |
| Backups | SaaS (BaaS) | Managed cloud backup provider | Provides backup and recovery capabilities without maintaining backup infrastructure | Define retention policies; configure backup scope and access; test restores | Backup misconfiguration or failed recovery |
| Monitoring | SaaS | Grafana Cloud | Managed monitoring platform without maintaining monitoring infrastructure | Configure monitoring agents; create dashboards and alerts; review and respond to alerts | Monitoring gaps or exposure of sensitive operational data |
