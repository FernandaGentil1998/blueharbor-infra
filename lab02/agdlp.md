# Lab 02 – Exercise 2.3: AGDLP

## 1. Adding a fourth Finance accountant

To grant access to a new Finance accountant:

1. Create the new user account in the Finance OU.
2. Add the user to the global security group `GG_Finance`.
3. The global group already belongs to the domain local group `DL_FinanceShare_RW`.
4. The new user automatically inherits Modify access to the Finance share.

No changes to the share permissions or NTFS ACLs are required.

## 2. Granting temporary read-only access to an auditor

To provide an auditor with read-only access for one month:

1. Create a global security group named `GG_Finance_Audit_Temp`.
2. Add the auditor's account to this group.
3. Add `GG_Finance_Audit_Temp` as a member of `DL_FinanceShare_R`.
4. The auditor receives Read access to the Finance share.
5. After one month, remove the auditor from the temporary global group and remove the temporary group from `DL_FinanceShare_R` if it is no longer needed.

This approach provides temporary access without changing the existing permissions assigned to Finance employees.

## 3. AGDLP principle

AGDLP stands for:

- **A**ccounts
- **G**lobal groups
- **D**omain **L**ocal groups
- **P**ermissions

Users are added to Global groups, Global groups are nested into Domain Local groups, and permissions are assigned to Domain Local groups.

This simplifies access management and makes it easier to scale and maintain permissions.
