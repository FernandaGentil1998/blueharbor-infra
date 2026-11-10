# BlueHarbor - Active Directory Audit

Write-Host "=== Domain Administrators ==="
Get-ADGroupMember "Domain Admins" |
    Select Name, SamAccountName

Write-Host "`n=== Inactive Accounts (90 days) ==="
Search-ADAccount -AccountInactive -TimeSpan 90.00:00:00 -UsersOnly |
    Select Name, SamAccountName

Write-Host "`n=== Exporting User Audit ==="
Get-ADUser -Filter * -Properties LastLogonDate, PasswordLastSet, Enabled |
    Select Name, Enabled, LastLogonDate, PasswordLastSet |
    Export-Csv C:\Lab\ad-audit.csv -NoTypeInformation

Write-Host "Audit report exported to C:\Lab\ad-audit.csv"
