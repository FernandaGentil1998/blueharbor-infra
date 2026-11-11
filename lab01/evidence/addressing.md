# Lab 01 — Exercise 1.1: Addressing Plan

## 1. Network Addressing

| Network | Subnet | Gateway | Purpose |
|---|---|---|---|
| VLAN 10 — ADMIN | 10.10.10.0/24 | 10.10.10.1 | IT administrators |
| VLAN 20 — SERVERS | 10.10.20.0/24 | 10.10.20.1 | Servers |
| VLAN 30 — USERS | 10.10.30.0/24 | 10.10.30.1 | Employees |
| VLAN 99 — MGMT | 10.10.99.0/24 | 10.10.99.1 | Switch management |
| WAN HQ–WH1 | 10.255.0.0/30 | N/A | Point-to-point link |
| WH1 LAN | 10.20.40.0/24 | 10.20.40.1 | Warehouse devices |

## 2. Device Interface Addressing

| Device | Interface | VLAN | IP Address | Subnet Mask | Gateway |
|---|---|---|---|---|---|
| R-HQ | G0/0 | Trunk | TBD | TBD | N/A |
| R-HQ | G0/1 | WAN | 10.255.0.1 | 255.255.255.252 | N/A |
| R-WH1 | G0/1 | WAN | 10.255.0.2 | 255.255.255.252 | N/A |
| R-WH1 | G0/0 | WH1 LAN | 10.20.40.1 | 255.255.255.0 | N/A |
| SW-DIST | VLAN 99 | 99 | 10.10.99.11 | 255.255.255.0 | 10.10.99.1 |
| SW-ACC1 | VLAN 99 | 99 | 10.10.99.12 | 255.255.255.0 | 10.10.99.1 |
| SW-ACC2 | VLAN 99 | 99 | 10.10.99.13 | 255.255.255.0 | 10.10.99.1 |
| PC-U1 | FastEthernet0 | 30 | DHCP | 255.255.255.0 | 10.10.30.1 |
| PC-U2 | FastEthernet0 | 30 | DHCP | 255.255.255.0 | 10.10.30.1 |
| PC-A1 | FastEthernet0 | 10 | DHCP | 255.255.255.0 | 10.10.10.1 |
| SRV-DC | FastEthernet0 | 20 | 10.10.20.10 | 255.255.255.0 | 10.10.20.1 |
| PC-WH1 | FastEthernet0 | WH1 LAN | DHCP | 255.255.255.0 | 10.20.40.1 |

## 3. Why use a dedicated VLAN 99 for switch management?

A dedicated management VLAN separates administrative traffic from normal user traffic. This reduces the attack surface, limits unauthorized access to network devices, and makes monitoring and access control easier to manage.
