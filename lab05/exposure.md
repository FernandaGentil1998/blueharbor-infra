## DC01 — NetBIOS exposure remediation



- Host: DC01 (10.10.20.10)

- Port: TCP 139 (NetBIOS Session Service)

- Initial state: Open

- Firewall rule: File and Printer Sharing (NB-Session-In)

- Initial remote scope: Any

- Remediation: Restricted RemoteAddress to 10.10.10.0/24

- Validation: Nmap scan from WEB02 (10.10.20.21)

- Final result: 139/tcp filtered



The service remains enabled, but access is restricted to the

administrative subnet. The scan from WEB02 confirmed that

the port is no longer accessible from the server subnet.
