
# Lab 06 — Exercise 6.6: Cloud Provider Comparison

## Objective

Compare four cloud providers and evaluate their services, pricing models, geographic availability, security and compliance capabilities, and suitability for the BlueHarbor TrackIt application.

## 1. Providers Overview

The comparison includes:

- Vercel — application hosting platform.
- Supabase — managed PostgreSQL and Backend-as-a-Service platform.
- Amazon Web Services (AWS) — major US-based hyperscaler.
- OVHcloud — European cloud provider headquartered in France.

## 2. Service and Platform Comparison

| Criteria | Vercel | Supabase | AWS | OVHcloud |
|---|---|---|---|---|
| Provider origin | United States | United States | United States | France |
| Main cloud model | PaaS | DBaaS / BaaS | IaaS / PaaS | IaaS / PaaS |
| Main services | Web hosting, deployments, CDN, serverless functions | Managed PostgreSQL, authentication, storage, APIs | EC2, RDS, S3, VPC, Lambda | Public Cloud instances, managed databases, storage, Kubernetes |
| Managed PostgreSQL | No native PostgreSQL database service | Yes | Yes, through Amazon RDS | Yes |
| Application deployment | Git-based deployment and serverless compute | Backend services and APIs | Multiple deployment options | Multiple deployment options |
| Infrastructure control | Limited compared with IaaS | Limited database infrastructure control | Extensive | Extensive |
| Pricing model | Subscription and usage-based | Subscription, compute and usage-based | Pay-as-you-go and reserved pricing | Hourly and monthly pricing options |
| European regions | Multiple deployment regions; availability depends on plan and product | Project region selection | Multiple European AWS regions | Multiple European regions |
| Terraform support | Vercel Terraform provider | Terraform provider ecosystem | Mature official AWS Terraform provider | Terraform provider available |

## 3. Pricing Comparison

Pricing is indicative and subject to change. Actual costs depend on region, resource size, traffic, storage, data transfer, and additional services.

| Provider | Entry-level option | Paid option / pricing approach |
|---|---|---|
| Vercel | Hobby: $0/month | Pro: from $20/month, including $20 usage credit |
| Supabase | Free: $0/month | Pro: from $25/month, with additional compute and usage charges |
| AWS | Free Tier credits for eligible new accounts | Pay-as-you-go; EC2 and RDS costs depend on instance, storage, region and usage |
| OVHcloud | Public Cloud resources billed according to selected resources | Hourly or monthly pricing; managed database cost depends on engine, plan and region |

### Pricing observations

- Vercel and Supabase provide accessible free tiers for prototypes and small projects.
- Supabase Free includes a 500 MB database and 5 GB egress. Free projects may be paused after one week of inactivity.
- Vercel Hobby is intended for personal, non-commercial projects. Pro is designed for professional usage.
- AWS provides flexible infrastructure pricing but requires careful cost estimation and monitoring.
- OVHcloud publishes hourly and monthly prices for compute and managed database resources.

The free tiers should not be treated as guaranteed production capacity. Limits, inactivity policies, backups, support and availability requirements must be considered.

## 4. Geographic Availability and Data Residency

| Provider | European presence | BlueHarbor relevance |
|---|---|---|
| Vercel | Global platform with European infrastructure options | Suitable for deploying the application close to European users |
| Supabase | Supports European project regions, including Paris | The BlueHarbor database was deployed in Paris (`eu-west-3`) |
| AWS | Multiple European regions, including Paris (`eu-west-3`) and Ireland (`eu-west-1`) | Offers regional infrastructure and multi-Availability Zone architectures |
| OVHcloud | French and other European regions, including Paris | Strong option when European infrastructure and data residency are priorities |

### Data residency considerations

Choosing a European region can reduce latency and support data residency requirements. However, selecting a European region alone does not automatically guarantee GDPR compliance.

Organizations must also evaluate:
- Data processing agreements.
- Subprocessors and international data transfers.
- Access controls and encryption.
- Backup and disaster recovery locations.
- Retention and deletion policies.
- Applicable certifications and contractual commitments.

## 5. Security and Compliance

| Provider | Security and compliance considerations |
|---|---|
| Vercel | Provides platform security features, deployment protections, DDoS mitigation and compliance resources. |
| Supabase | Provides PostgreSQL Row Level Security (RLS), access controls and managed database services. Higher plans include additional organizational and compliance features. |
| AWS | Offers extensive IAM, encryption, network security, logging and compliance services. Customers remain responsible for secure configuration. |
| OVHcloud | Provides security and compliance programs, including ISO 27001, ISO 27017, ISO 27018 and ISO 27701 certifications for applicable services. |

### Shared responsibility

Cloud providers secure the underlying services and infrastructure according to their responsibilities. Customers must still configure identity and access management, network rules, application security, data permissions, backups and monitoring correctly.

## 6. Infrastructure as Code and Portability

| Provider | Infrastructure automation |
|---|---|
| Vercel | Terraform provider available; Git integration supports automated deployments. |
| Supabase | Terraform provider ecosystem available; database schema can also be managed through SQL migrations. |
| AWS | Mature Terraform provider and extensive infrastructure automation capabilities. |
| OVHcloud | Terraform provider and API-based infrastructure management. |

Infrastructure as Code improves repeatability, reviewability and consistency. However, provider-specific services and configurations can create vendor lock-in.

BlueHarbor already uses Terraform for Vercel project configuration. The Supabase database schema is currently created through SQL.

## 7. Weighted Decision Matrix

Scores range from 1 (weak) to 5 (excellent). These are qualitative project assessment scores, not independent provider benchmarks.

| Evaluation criterion | Weight | Vercel | Supabase | AWS | OVHcloud |
|---|---:|---:|---:|---:|---:|
| Ease of deployment | 20% | 5 | 5 | 3 | 3 |
| Cost accessibility for a small project | 20% | 5 | 5 | 3 | 4 |
| European infrastructure options | 20% | 4 | 5 | 5 | 5 |
| Managed service capabilities | 15% | 4 | 5 | 5 | 4 |
| Infrastructure control | 10% | 2 | 2 | 5 | 5 |
| Automation and scalability | 15% | 4 | 4 | 5 | 4 |

### Weighted results

### Weighted results

| Provider | Weighted score |
|---|---:|
| Vercel | 4.20 / 5 |
| Supabase | 4.55 / 5 |
| AWS | 4.20 / 5 |
| OVHcloud | 4.10 / 5 |

Supabase scores highest for this particular project because of its managed PostgreSQL capabilities, ease of integration and European region selection. AWS offers the greatest infrastructure flexibility, while OVHcloud is a strong European alternative.

The scores reflect the priorities of a small application such as TrackIt. A regulated enterprise workload or a large-scale system could produce a different ranking.

## 8. Recommendation for BlueHarbor

The current Vercel + Supabase architecture is appropriate for the TrackIt learning project.

Reasons:

1. Vercel simplifies application deployment and Git-based CI/CD.
2. Supabase provides managed PostgreSQL without requiring manual database server administration.
3. Both services offer accessible entry-level plans.
4. The database is deployed in Paris, reducing geographic distance from the application's intended European user base.
5. The architecture allows the application and database to scale independently.

For a future enterprise deployment, AWS and OVHcloud should be evaluated against requirements for availability, resilience, network isolation, compliance, support and total cost of ownership.

## 9. Official References

- Vercel Pricing: https://vercel.com/pricing
- Supabase Pricing: https://supabase.com/pricing
- AWS RDS Pricing: https://aws.amazon.com/rds/pricing/
- AWS European Availability Zones: https://docs.aws.amazon.com/global-infrastructure/latest/regions/aws-availability-zones.html
- OVHcloud Public Cloud Pricing: https://www.ovhcloud.com/en/public-cloud/prices/
- OVHcloud Managed PostgreSQL: https://www.ovhcloud.com/en/public-cloud/postgresql/
- OVHcloud Regional Availability: https://www.ovhcloud.com/en/public-cloud/regions-availability/
- OVHcloud Compliance: https://www.ovhcloud.com/en/compliance/

---

**Exercise 6.6 — Provider comparison: documented.**

The next part of the exercise is to record actual resource usage and estimate how costs could evolve as the application scales.
