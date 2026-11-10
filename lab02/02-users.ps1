# BlueHarbor - Lab 02 - Exercise 2.2
# Import users into Active Directory

# Request the initial password securely
$initialPassword = Read-Host -AsSecureString "Initial password"

# Import users from CSV and create their AD accounts
Import-Csv "C:\Lab\users.csv" | ForEach-Object {
    New-ADUser `
        -Name "$($_.FirstName) $($_.LastName)" `
        -GivenName $_.FirstName `
        -Surname $_.LastName `
        -SamAccountName $_.Sam `
        -UserPrincipalName "$($_.Sam)@blueharbor.internal" `
        -Department $_.Department `
        -Title $_.Title `
        -Path "OU=$($_.Department),OU=Users,OU=BlueHarbor,DC=blueharbor,DC=internal" `
        -AccountPassword $initialPassword `
        -ChangePasswordAtLogon $true `
        -Enabled $true
}
