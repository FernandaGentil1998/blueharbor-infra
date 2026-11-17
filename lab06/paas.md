
# Lab 06 — Exercise 6.4: Deploy TrackIt on PaaS

## 1. Objective

Deploy the TrackIt Flask application to Vercel using GitHub integration and Terraform.

The objective was to understand how a Platform as a Service (PaaS) provider simplifies application deployment by managing the underlying infrastructure.

## 2. Architecture

| Component | Technology | Responsibility |
|---|---|---|
| Source code repository | GitHub | Version control and source code |
| Web application | Flask | TrackIt application and API endpoints |
| Application platform | Vercel | Application hosting and deployment |
| Infrastructure as Code | Terraform | Vercel project and environment variable provisioning |
| Python dependencies | requirements.txt | Application dependencies |
| Database integration | Supabase | Planned managed database integration |

Production URL: https://bh-trackit-fg.vercel.app/

## 3. Application implementation

The TrackIt application was created in the `trackit/` directory.

Main files:
- `app.py`: Flask application with homepage, health check and shipment endpoints.
- `requirements.txt`: Flask, Gunicorn and Redis dependencies.
- `test_app.py`: automated health check test.
- `.gitignore`: excludes virtual environments, cache files and Python bytecode.

Local validation:
- Installed dependencies in a Python virtual environment.
- Executed the automated test with pytest.
- Result: 1 test passed.
- Tested the Flask application locally through port 5000.

## 4. Terraform provisioning

Terraform was used to create and configure the Vercel project.

Configuration file: `cloud/platform/main.tf`

Resources provisioned:
- Vercel project: `bh-trackit-fg`.
- GitHub repository integration: `FernandaGentil1998/blueharbor-infra`.
- Production branch: `main`.
- Root directory: `trackit`.
- Environment variable: `APP_VERSION=1.1.0`.
- Environment variable targets: Production and Preview.

Terraform validation and execution:
- `terraform init` — successful.
- `terraform validate` — successful.
- `terraform plan` — 2 resources to add.
- `terraform apply` — 2 resources added.

The Vercel Framework Preset was subsequently configured as Flask in the Vercel dashboard. This was necessary because the initial deployment using the `Other` preset did not prepare the Python application.

## 5. Production deployment

The application was deployed automatically from the GitHub `main` branch.

A code change was committed and pushed to trigger a new Production deployment.

Production health check:

`GET /health`

Expected and observed response:

```json
{
  "status": "ok",
  "version": "1.1.0"
}
```

The production endpoint was successfully validated over HTTPS.

## 6. Preview deployment

A separate Git branch named `preview-test` was created to test changes without affecting Production.

The homepage title was modified to:

`BlueHarbor TrackIt - PREVIEW`

After committing and pushing the branch, Vercel automatically created a Preview deployment.

Validation:
- Preview deployment status: Ready.
- Preview homepage displayed the `PREVIEW` label.
- Production remained on the original homepage title.

This demonstrates how separate environments support testing before changes are introduced into Production.

## 7. Comparison: IaaS and PaaS

| Aspect | Lab 03 — IaaS | Lab 06.3 — Terraform / Docker | Lab 06.4 — Vercel PaaS |
|---|---|---|---|
| Infrastructure | Virtual machines and networks | Docker containers and network | Managed application platform |
| OS management | Customer responsibility | Managed by container host; image-based environment | Provider responsibility |
| Runtime | Customer installs and configures | Defined by container image | Managed by platform |
| Application deployment | Customer configures deployment | Terraform provisions containers | Git integration and automatic deployment |
| Scaling | Customer configures infrastructure | Customer adjusts container resources/count | Platform-managed capabilities |
| TLS certificates | Customer configures or uses a managed service | Not configured in this exercise | Managed by Vercel |
| Infrastructure provisioning | Manual or IaC | Terraform | Terraform |

## 8. Responsibilities in PaaS

### Managed by the provider
- Underlying servers and infrastructure.
- Operating system maintenance.
- Application hosting environment.
- HTTPS certificate management.
- Deployment infrastructure.

### Managed by the development team
- Application source code.
- Dependencies and application configuration.
- Environment variables and secrets.
- Application testing and monitoring.
- Access control and secure coding practices.
- Database design and data protection.

## 9. Conclusion

The exercise demonstrated how PaaS simplifies application deployment compared with managing virtual machines and container infrastructure directly.

By integrating GitHub, Vercel and Terraform, the TrackIt application could be deployed automatically from separate Git branches.

Production and Preview deployments were both successfully validated.

The exercise also demonstrated that PaaS reduces infrastructure management responsibilities but does not eliminate the team's responsibility for application security, configuration and data protection.
