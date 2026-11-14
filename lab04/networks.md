\# Lab 04 — Network Configuration and Isolation



\## 1. NAT Network — BH-SRV



Both WEB01 and WEB02 use the `BH-SRV` NAT Network through their first network adapter.



Test	Observed Result
VM → Internet (IP connectivity)	Successful — 0% packet loss
VM → Internet (DNS resolution)	Successful — google.com resolved and responded
WEB01 → WEB02 (10.10.20.21)	Successful — 0% packet loss
Windows host → WEB01 (10.10.20.20)	Unsuccessful — 100% packet loss
Windows host → WEB01 via SSH port forwarding	Successful — SSH connection through localhost:2220


\## 2. Internal Network — BH-STORAGE



A second network adapter was added to WEB01 and WEB02 and connected to the `BH-STORAGE` Internal Network.



| Test | Observed Result |

|---|---|

| WEB01 → WEB02 (172.16.30.21) | Successful — 3 packets received, 0% packet loss |

| Windows host → WEB02 (172.16.30.21) | Unsuccessful — 100% packet loss |



\### IP Configuration



| VM | Interface | IP Address |

|---|---|---|

| WEB01 | enp0s8 | 172.16.30.20/24 |

| WEB02 | enp0s8 | 172.16.30.21/24 |



\## 3. Network Segmentation



The `BH-STORAGE` Internal Network allows direct communication between WEB01 and WEB02 while remaining isolated from the Windows host.



Separating storage traffic from the primary `BH-SRV` NAT Network reduces exposure and keeps internal VM-to-VM communication independent from external network access.



\## 4. Conclusion



The internal network was successfully configured on both VMs. Connectivity between WEB01 and WEB02 was verified, while the Windows host could not reach the internal IP address of WEB02.



The NAT Network tests for Internet access and VM-to-VM connectivity were not recorded and remain to be verified.

