\# Network Segmentation — Lab 05



\## Network Zones



| Zone | Subnet | Purpose |

|---|---|---|

| Admin | 10.10.10.0/24 | Administrative workstations |

| Servers | 10.10.20.0/24 | Internal servers |

| Users | 10.10.30.0/24 | User workstations |

| Management | 10.10.99.0/24 | Network device management |

| Warehouse | 10.20.40.0/24 | Warehouse network |



\## Traffic Flow Matrix



| Source Zone | Destination Zone | Allowed Services | Policy |

|---|---|---|---|

| Users | Servers | Required application services and ICMP for lab testing | Allow |

| Users | Admin | None | Deny |

| Users | Management | None | Deny |

| Admin | Management | SSH | Allow |

| Admin | Servers | Required administrative services | Allow |

| Management | Network Devices | SSH | Allow |

| Warehouse | Servers | Required business services | Allow |



\## Implemented Security Controls



\- Extended ACL USERS-IN applied inbound on R-HQ G0/0.30.

\- Traffic from Users to Admin and Management subnets is denied.

\- Remaining traffic is permitted by the ACL.

\- Standard ACL 10 restricts SSH access to SW-ACC1 to the Admin subnet on VTY lines 0–4.

\- WEB01 UFW logging enabled.

\- DC01 Windows Firewall profiles checked.



\## Validation Evidence



\- PC-U1 ping to 10.10.20.10: successful after initial timeout.

\- PC-U1 ping to 10.10.10.1: blocked.

\- PC-U1 ping to 10.10.99.12: blocked.

\- ACL counters confirmed 4 matches on each deny rule.



