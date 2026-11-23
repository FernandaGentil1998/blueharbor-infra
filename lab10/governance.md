# BlueHarbor — Cloud Governance

## 1. Purpose

This document defines the naming conventions, Terraform validation rules, security scanning evidence and governance limitations for the BlueHarbor educational cloud environment.

It records the controls currently present in the repository. It does not imply formal compliance or production readiness.

## 2. Resource Naming Conventions

The Terraform configurations use the following naming patterns:

| Resource | Naming convention | Example |
|---|---|---|
| Vercel project | `bh-trackit-<initials>` | `bh-trackit-fgs` |
| Docker network | `bh-<env>-net` | `bh-dev-net` |
| Docker web container | `bh-web-<env>-<number>` | `bh-web-dev-1` |

The environment identifier must be one of `dev`, `test` or `prod`.

Docker containers must include an owner label. The owner value is supplied through the required Terraform variable `owner`.

## 3. Terraform Validation Rules

### 3.1 Vercel platform

File: `cloud/platform/main.tf`

| Variable | Rule | Enforcement |
|---|---|---|
| `initials` | Two or three lowercase letters | Regex `^[a-z]{2,3}$` |
| `region` | Must be `eu-west-3` or `eu-central-1` | Terraform `contains()` validation |
| `github_repo` | GitHub repository in `owner/name` format | Description only; no explicit validation |

The project name is generated using the `bh-trackit-` prefix and lowercase initials.

The `region` variable currently validates its allowed values but is not connected to a Vercel project deployment-region attribute. It must not be treated as an enforced hosting-location control.

### 3.2 Docker lab infrastructure

File: `cloud/lab-infra/main.tf`

| Variable | Rule | Enforcement |
|---|---|---|
| `env` | Only `dev`, `test` or `prod` | Terraform `contains()` validation |
| `web_count` | Numeric container count | Number type only; no explicit range validation |
| `owner` | Required resource owner | Required string variable; no format validation |

Docker resources follow the naming conventions in Section 2. The web containers are connected to the environment-specific Docker network and receive an owner label.

The Nginx image uses the `1.27-alpine` tag. The image is not pinned by immutable digest.

## 4. Validation and CI Governance

The GitHub Actions policy job performs Terraform initialization and validation for both directories:

- `cloud/lab-infra`
- `cloud/platform`

Initialization uses `-backend=false`, `-input=false` and `-lockfile=readonly`.

Terraform validation checks configuration syntax and internal consistency. It does not prove that deployed infrastructure is secure or compliant.

The policy job also runs Checkov against Terraform, the Dockerfile and Kubernetes manifests.

## 5. Checkov Results and Coverage

Recorded scan results:

| Scope | Checkov version | Result | Interpretation |
|---|---|---|---|
| `trackit/Dockerfile` | 3.4.7 | 31 passed, 0 failed, 0 skipped | Dockerfile checks executed |
| `trackit/k8s` | 3.4.7 | 180 passed, 0 failed, 0 skipped | Kubernetes checks executed |
| `cloud/` | 3.4.6 | 0 resources evaluated; 0 passed, 0 failed, 0 skipped; 0 parsing errors | No Terraform resources were evaluated |

The Terraform Checkov result is a coverage limitation. It is not a successful security assessment of the Docker or Vercel Terraform resources.

The tested Checkov configuration did not evaluate the Docker and Vercel provider resources. No claim is made that Terraform security findings were fixed.

No Terraform Checkov exceptions are recorded because no Terraform resources were evaluated. Any future exception must identify the affected resource, policy/check ID, rationale, risk owner and review date.

## 6. Change Governance

Changes to Terraform configurations and CI policy should:

1. Be submitted through a pull request rather than pushed directly to `main`.
2. Be reviewed before merge.
3. Pass the required CI checks configured by repository branch protection.
4. Include updated evidence when validation rules, resources or security policies change.
5. Document unresolved findings and accepted exceptions rather than silently suppressing them.

The repository currently has a `policy` CI job. The exact required status checks and reviewer assignments must be verified in GitHub branch protection settings.

## 7. Known Governance Gaps

The following improvements remain open:

- Add a numeric range validation for `web_count`.
- Validate the format of `owner` and `github_repo`.
- Connect the Vercel region control to an effective deployment setting, if supported.
- Pin container images by immutable digest.
- Establish meaningful Terraform security scanning for the resource providers in use.
- Define and verify code ownership and reviewer responsibilities.
- Record formal approval and expiry details for policy exceptions.

## 8. Evidence References

- `cloud/platform/main.tf`
- `cloud/lab-infra/main.tf`
- `.github/workflows/ci.yml`
- `lab10/compliance-matrix.md`
- `lab10/security-controls.md`

This governance document describes the current educational implementation and its limitations. It does not constitute a formal governance framework, security certification or compliance attestation.
