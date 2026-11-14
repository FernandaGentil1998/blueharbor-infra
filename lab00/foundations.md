\## Step 1 — On-premises



\### 1. The six layers of BlueHarbor's on-premises infrastructure



| Layer | Description | Who operates it today |

|---|---|---|

| 1. Building | HQ premises and server room | BlueHarbor, as the company operating its HQ. |

| 2. Facilities | Electricity, power protection and cooling | BlueHarbor; the specific facilities provider is not documented. |

| 3. Network | LAN connecting PCs, printers and servers | BlueHarbor's internal IT operations; the network is currently flat. |

| 4. Physical infrastructure | Physical servers and storage devices | BlueHarbor owns the on-premises infrastructure; the server room contains ageing equipment. |

| 5. Operating systems and platforms | Windows Server and server software | BlueHarbor manages its servers manually. The domain controller was originally installed by a contractor. |

| 6. Applications and data | Active Directory, company data and backups | BlueHarbor manages its business systems and local backups. Microsoft operates the Microsoft 365 email service. |



\*\*Note:\*\* The case does not identify specific facilities or network providers. The contractor is documented as the original installer of the domain controller, not necessarily its current operator.





\### 2.

&#x20;\*\*Advantage:\*\* BlueHarbor has full control over its infrastructure, including hardware, network configuration, security policies and data management. This allows the company to customise the environment to its business requirements.



&#x20;  \*\*Drawback:\*\* BlueHarbor is responsible for all costs and maintenance, including hardware purchases, electricity, cooling, upgrades, backups and technical staff. This can be expensive and requires specialised expertise.



\## Step 2 — Virtualisation



\### 1. Total CPU cores and RAM used



\*\*CPU calculation:\*\*



Each physical server has 8 CPU cores.



\- Directory: 8 × 8% = 0.64 cores

\- Files: 8 × 15% = 1.20 cores

\- Finance: 8 × 20% = 1.60 cores

\- Print: 8 × 5% = 0.40 cores

\- Web: 8 × 10% = 0.80 cores

\- Backup: 8 × 12% = 0.96 cores



\*\*Total CPU usage: 5.60 cores\*\*



\*\*RAM calculation:\*\*



6 + 10 + 14 + 3 + 6 + 8 = \*\*47 GB\*\*



\*\*Total RAM used: 47 GB\*\*



\### 2. Virtualisation host capacity



Each host provides 16 CPU cores and 128 GB RAM. With a maximum utilisation of 70%:



\- Usable CPU per host: 16 × 70% = 11.2 cores.

\- Usable RAM per host: 128 × 70% = 89.6 GB.



BlueHarbor requires 5.6 CPU cores and 47 GB RAM.



\*\*One host is sufficient for capacity\*\*, since both requirements are below the 70% limits.



However, I would buy \*\*two hosts\*\* to provide redundancy, allow maintenance without stopping all services, and improve availability if one host fails.



\### 3. Benefits and risk of server consolidation



\*\*Benefits:\*\*

1\. Lower hardware and electricity costs because multiple virtual machines share the same physical host.

2\. Easier administration, resource allocation and backup management through a centralised virtualisation platform.



\*\*Risk:\*\*

\- A single host failure could affect all six virtual machines, causing multiple services to become unavailable simultaneously.



\## Step 3 — Hypervisor type



\### 1. Choosing the hypervisor type



\*\*a) Future production hosts in BlueHarbor's server room: Type 1\*\*



A Type 1 hypervisor runs directly on physical hardware without requiring a general-purpose host operating system. It provides better performance and is suitable for production environments. Examples include VMware ESXi, Microsoft Hyper-V and Proxmox VE/KVM.



\*\*b) My laptop for this course: Type 2\*\*



A Type 2 hypervisor runs as an application on an existing operating system. VirtualBox is suitable because it allows me to run virtual machines on my laptop without replacing the host operating system.



\*\*c) An accountant's laptop running an old Windows application: Type 2\*\*



A Type 2 hypervisor can run a virtual machine with a compatible older version of Windows alongside the laptop's current operating system. This provides application compatibility without replacing the existing system.



\## Step 4 — From on-premises to cloud



\### 1. From a virtualised data centre to cloud



\*\*What BlueHarbor still lacks to become a private cloud:\*\*



\- Self-service: users or administrators should be able to request and provision resources when needed.

\- Automation: infrastructure provisioning and management should be automated instead of relying on manual operations.



Virtualisation alone does not make an infrastructure a private cloud.



\*\*What BlueHarbor would gain from a public cloud:\*\*



\- Access to shared infrastructure operated and maintained by a cloud provider.

\- On-demand resources that can be provisioned when needed.

\- Pay-per-use pricing instead of purchasing and maintaining all physical hardware.

\- Greater flexibility to scale resources according to demand.



\## Step 5 — Deployment model



\### 1. Workload placement



| Workload | Deployment model | Reason |

|---|---|---|

| Active Directory | Private | Contains internal identities and controls access to company resources. |

| Finance application | On-premises | Keeps a critical business application within the company's controlled infrastructure. |

| TrackIt website | Public | Needs to be accessible to customers and handle changing traffic. |

| TrackIt shipment data | Public | Can use a managed cloud database for availability and scalability. |

| Off-site backups | Public | Keeps backup copies outside HQ, protecting against local disasters. |



\### 2. Why the resulting model is hybrid



The model is hybrid because Active Directory and the Finance application remain on private or on-premises infrastructure, while the TrackIt website, shipment data and off-site backups use public cloud services.



The two environments must be securely connected through a VPN or another protected network connection, with controlled access and data exchange.



\## Step 6 — Scalability



\### 1. Vertical scaling vs. horizontal scaling



TrackIt normally receives 500 visits per hour. During Black Friday, traffic increases to 5,000 visits per hour for two days.



| Aspect | Vertical scaling (2 to 16 vCPU) | Horizontal scaling (2 to 8 instances) |

|---|---|---|

| Downtime during the change | May require restarting the server, causing downtime. | Can be performed with little or no downtime when instances are added behind a load balancer. |

| Maximum capacity | Increases the resources of one server, but is limited by the maximum capacity of that machine. | Distributes requests across multiple instances and can provide greater overall capacity. |

| Cost after the peak | The server may remain oversized unless its resources are reduced again. | Extra instances can be removed after the peak, reducing costs. |

| Application requirements | The application must benefit from additional CPU and memory on a single machine. | The application should support multiple instances, ideally be stateless, and use shared storage or an external session store when necessary. |



Vertical scaling increases the resources of one machine. Horizontal scaling adds more instances to distribute the workload.



\### 2. Scaling strategy for the web tier and database



\*\*Web tier: Horizontal scaling.\*\*



I would choose horizontal scaling for the TrackIt web tier because it distributes incoming traffic across multiple instances, improves availability and allows BlueHarbor to remove additional instances after Black Friday.



\*\*Database: Vertical scaling.\*\*



I would initially choose vertical scaling for the database because it increases CPU and RAM on the existing database server without introducing the additional complexity of database replication, synchronisation and distributed transactions.



Database performance should be monitored, and further scaling options can be considered if vertical scaling is no longer sufficient.</
