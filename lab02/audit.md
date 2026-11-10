# Active Directory Audit

## Findings and Recommended Actions

### 1. Accounts without logon history
Several user accounts have no recorded LastLogonDate.

Risk: Accounts may remain enabled without being actively used.

Action: Verify account owners, creation dates and business requirements. Disable accounts confirmed as unnecessary.

### 2. Missing password timestamps
Several user accounts have no recorded PasswordLastSet value.

Risk: Password configuration and initial credential management cannot be confirmed.

Action: Verify password initialization and enforce password changes at the first logon where appropriate.

### 3. Domain Administrator account usage
Only the built-in Administrator account is currently a member of Domain Admins.

Risk: Using a shared built-in administrative account can reduce accountability and traceability.

Action: Create individual named administrative accounts, apply least privilege and restrict built-in Administrator usage.

## Notes

Guest and krbtgt are special Active Directory accounts. Their status must be evaluated according to their specific roles rather than treated as ordinary inactive user accounts.
