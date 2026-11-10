# BlueHarbor - Lab 02 - Exercise 2.1
# DC01 initial configuration

# Set the Paris time zone
Set-TimeZone -Id "Romance Standard Time"
Get-TimeZone

# Check Windows Server licence
slmgr /dli

# Check network adapter
Get-NetAdapter

# Configure static IP address and default gateway
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "10.10.20.10" -PrefixLength 24 -DefaultGateway "10.10.20.1"

# Configure DNS
# The gateway DNS resolver (10.10.20.1) worked in this NAT Network setup.
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "10.10.20.1"

# Test network connectivity and DNS resolution
Test-NetConnection 1.1.1.1
Resolve-DnsName www.microsoft.com

# Rename the server
# Already executed; uncomment only if you need to run it again.
# Rename-Computer -NewName "DC01" -Restart
