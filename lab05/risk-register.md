# Lab 05 — Infrastructure Security



## 1. Asset Inventory



| Asset | Description | Confidentiality (C) | Integrity (I) | Availability (A) |

|---|---|---:|---:|---:|

| DC01 | Windows Server domain controller and directory services | 3 | 3 | 3 |

| WEB01 | Linux web server | 2 | 3 | 3 |

| WEB02 | Secondary Linux web server | 2 | 3 | 3 |

| Network switches and routers | Network connectivity and segmentation | 2 | 3 | 3 |

| Finance share | Shared financial documents and data | 3 | 3 | 2 |

| Git repository | Infrastructure configurations and project files | 2 | 3 | 2 |

| Cloud tokens | Credentials used to access cloud resources | 3 | 3 | 2 |



**Scoring:** 1 = Low, 2 = Medium, 3 = High.



## 2. Risk Register



| ID | Asset | Threat (Who / How) | Likelihood (1–4) | Impact (1–4) | Risk Score | Existing Control | Proposed Control |

|---|---|---|---:|---:|---:|---|---|

| R01 | DC01 | External attacker attempts password spraying against domain accounts | 3 | 4 | 12 | Account lockout policy | MFA for administrators and authentication monitoring |

| R02 | Cloud tokens | Attacker obtains exposed credentials from a repository or configuration file | 3 | 4 | 12 | Repository access restrictions | Secret scanning, token rotation and least-privilege permissions |

| R03 | Finance share | Unauthorized employee accesses or modifies confidential financial documents | 3 | 4 | 12 | User authentication | Role-based access control and access auditing |

| R04 | Network switches and routers | Attacker accesses network devices through unauthorized management connections | 2 | 4 | 8 | Network segmentation | Restrict SSH access to the Admin VLAN |

| R05 | WEB01 / WEB02 | Attacker exploits an exposed or unpatched web service | 3 | 3 | 9 | Basic host security | Regular vulnerability scanning and host-based firewall rules |



## 3. Risk Assessment Method



Risk Score = Likelihood × Impact



- Likelihood: 1 (Rare) to 4 (Almost Certain).

- Impact: 1 (Low) to 4 (Critical).

- Higher scores indicate higher-priority risks.
