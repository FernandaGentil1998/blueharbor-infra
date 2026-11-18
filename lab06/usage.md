# Lab 06 — Cloud Usage Tracking

## 1. GitHub Codespaces

- Billing period: November 2026
- Date recorded: 17 November 2026
- SKU: Codespaces storage
- Usage: 0.04 GB-month
- Price per unit: $0.07
- Gross amount: Less than $0.01
- Billed amount: $0.00

Daily gross usage increased to $0.10 on November 9.
All daily billed amounts displayed (November 1–17): $0.00.

## 2. Vercel

- Plan: Hobby
- Usage period: Last 30 days
- Fast Data Transfer: 0 B
- Fast Origin Transfer: 0 B
- CDN Requests: 0
- Function Invocations: 0
- Function Duration: 0 GB-Hrs
- Build Minutes: 0
- Deployment Storage: 0 B

No measurable usage was displayed for the listed resources.
No monetary invoice amount was provided in the usage screen.

## 3. Supabase

- Organization: bh-FG
- Plan: Free
- Billing cycle: 09 November – 09 December 2026
- Past invoices: None
- Quota status: No Free Plan quota exceeded

| Resource | Used | Included quota |
|---|---:|---:|
| Database Size | 0 GB | 0.5 GB |
| Egress | 0 GB | 5 GB |
| Cached Egress | 0 GB | 5 GB |
| Monthly Active Users | 0 | 50,000 |
| Third-Party Users | 0 | 50,000 |
| Storage Size | 0 GB | 1 GB |
| Realtime Connections | 0 | 200 |
| Realtime Messages | 0 | 2,000,000 |
| Edge Function Invocations | 0 | 500,000 |
| Log Ingestion | 0 GB | 1 GB |
| Log Query | 0 GB | 100 GB |

## 4. Cost and Usage Notes

- GitHub Codespaces storage showed less than $0.01 gross and $0 billed on November 1.
- Vercel displayed zero usage for the listed resources during the selected period.
- Supabase is on the Free Plan, with no quota exceeded.
- Supabase Free Plan overages are not billed; exceeding quotas may cause service restrictions.
- Usage dashboards may have refresh delays.
- These values are snapshots, not final monthly invoices.

## 5. Usage Analysis and Monitoring

### Current Usage Assessment

The project is currently operating with low resource consumption.

- GitHub Codespaces storage generated a gross amount below $0.01, with no billed amount displayed.
- Vercel Hobby showed no measurable usage for the listed resources during the selected 30-day period.
- Supabase Free showed no quota exceeded and no measurable consumption for the listed resources.

These observations indicate that the current project workload is small and remains within the available free-tier limits.

However, zero usage displayed in a dashboard does not necessarily mean that no requests were processed. The TrackIt application was successfully deployed and two shipment API requests were validated. Usage dashboards may have reporting delays, aggregation thresholds or different measurement periods.

### Monitoring Strategy

The following metrics should be monitored regularly:

| Platform | Metric | Monitoring Objective |
|---|---|---|
| GitHub Codespaces | Storage usage | Avoid unnecessary storage costs |
| GitHub Codespaces | Compute hours | Control development environment usage |
| Vercel | Function Invocations | Track application request volume |
| Vercel | Function Duration | Identify inefficient backend operations |
| Vercel | Data Transfer | Monitor network consumption |
| Supabase | Database Size | Prevent database quota exhaustion |
| Supabase | Egress | Monitor data transferred from the database |
| Supabase | Database Health | Identify performance or availability issues |
| Supabase | API usage | Track application access patterns |

### Recommended Monitoring Practices

1. Review provider dashboards weekly.
2. Check billing and usage before the end of each billing cycle.
3. Configure alerts where supported.
4. Investigate unexpected increases in database size or data transfer.
5. Remove unused resources and deployments when appropriate.
6. Review application logs to identify errors and excessive API requests.
7. Keep credentials and billing information out of Git repositories.

## 6. Scalability Scenario — 100x Traffic Growth

Assume that TrackIt experiences a 100-fold increase in traffic compared with its current workload.

Potential impacts include:

- More Vercel Function Invocations.
- Increased function execution duration and compute consumption.
- Higher database query volume.
- Increased Supabase egress and connection usage.
- Potential database performance bottlenecks.
- Increased risk of reaching free-tier quotas.

### Scalability Recommendations

| Component | Recommended Action |
|---|---|
| Vercel | Monitor function usage and consider a paid plan if limits are reached |
| Flask application | Optimize database queries and implement appropriate caching |
| Supabase | Monitor database performance, connections and egress |
| PostgreSQL | Add indexes to frequently queried columns when justified |
| Application architecture | Consider connection pooling and request optimization |
| Monitoring | Configure usage alerts and review trends regularly |

A reliable monetary estimate cannot be calculated from the current dashboard snapshot because the measured usage is zero or below the reporting threshold. A realistic forecast requires a defined request volume, workload profile and resource consumption baseline.

## 7. Conclusion

The current BlueHarbor TrackIt deployment operates within the free-tier limits displayed by GitHub Codespaces, Vercel and Supabase.

The application successfully retrieves shipment records from the managed Supabase database through its Vercel deployment.

The next step for production readiness is continuous monitoring of resource consumption, performance, availability and billing.

The 100x growth scenario highlights the importance of monitoring, query optimization, caching and capacity planning before increasing infrastructure resources.

---

**Exercise 6.6 — Usage tracking and scalability assessment: documented.**
