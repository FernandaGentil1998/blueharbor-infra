# Lab 02 – Exercise 2.4: Group Policy
## 1. Domain Password Policy

Configured the default domain password policy for `blueharbor.internal` using PowerShell:
```powershell
Set-ADDefaultDomainPasswordPolicy -Identity blueharbor.internal -MinPasswordLength 12 -ComplexityEnabled $true -LockoutThreshold 5 -LockoutDuration 00:15:00 -LockoutObservationWindow 00:15:00
```
Configuration:
- Minimum password length: 12 characters.
- Password complexity: Enabled.
- Account lockout threshold: 5 invalid attempts.
- Account lockout duration: 15 minutes.
- Observation window: 15 minutes.

Verified with:
```powershell
Get-ADDefaultDomainPasswordPolicy
```

## 2. Screen-lock Policy

Configured the following setting in Group Policy Management:

**GPO:** Default Domain Policy

**Path:**

Computer Configuration → Policies → Windows Settings → Security Settings → Local Policies → Security Options

**Policy:** Interactive logon: Machine inactivity limit

**Value:** 600 seconds (10 minutes).

## 3. Apply and Verify Group Policy

Updated the policies using:

```powershell
gpupdate /force
```

Verified the applied settings using:

```powershell
gpresult /scope computer /v
```

The report confirmed:
- Default Domain Policy was applied to DC01.
- Minimum password length: 12.
- Account lockout threshold: 5.
- InactivityTimeoutSecs: 600.

## 4. Result

The domain password policy and automatic screen-lock inactivity setting were successfully configured and verified on DC01.
