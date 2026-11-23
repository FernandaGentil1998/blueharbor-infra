# BlueHarbor — Access Control Matrix

| Role | Platform | Permission | Scope | How granted | How removed |
|---|---|---|---|---|---|
| Anonymous customer | Supabase | SELECT | Public shipment reads | RLS policy `Allow public shipment reads` for `anon` | Drop the policy |
| Viewer | Supabase Auth / Database | No INSERT or UPDATE | `public.shipments` | Auth user `viewer@blueharbor.test`; no ops role | Delete or disable the Auth user |
| Ops | GitHub | Maintain | `bh-runbooks` repository | `ops` team membership with Maintain permission | Remove user from team or revoke repository access |
| Ops | Supabase | INSERT and UPDATE | `public.shipments` | `app_metadata.role = ops`, RLS policies, and SQL GRANT | Remove the role, drop policies, or revoke SQL privileges |
| Auditor | GitHub | Read | `bh-runbooks` repository | `auditors` team membership with Read permission | Remove user from team or revoke repository access |
| CI pipeline | GitHub Actions | Not configured in this lab | No additional access granted | No dedicated pipeline permission configured | Revoke or rotate any future workflow credentials |
| Terraform | Cloud infrastructure | Not configured in this lab | No additional access granted | No dedicated Terraform identity configured | Revoke or rotate its future credentials |

## Verification

- `viewer` shipment INSERT attempt: HTTP 403 — denied.
- `ops` shipment INSERT attempt: HTTP 201 — created.
- GitHub teams: `ops` = Maintain; `auditors` = Read.

## Security notes

- Keep credentials, passwords, API keys, and access tokens out of Git.
- Apply least privilege: grant only the permissions required for each role.
- RLS policies and SQL privileges work together; both must allow an operation.
