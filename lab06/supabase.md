
# Lab 06 — Exercise 6.5: Managed Database with Supabase

## Objective

Connect the BlueHarbor TrackIt Flask application, deployed on Vercel, to a managed PostgreSQL database hosted by Supabase. Validate database access through the application's REST API endpoint.

## Architecture

| Component | Service | Role |
|---|---|---|
| Application hosting | Vercel | Hosts the TrackIt Flask application (PaaS) |
| Managed database | Supabase | Hosts the PostgreSQL database (DBaaS) |
| Application backend | Flask | Calls the Supabase REST API |
| Database table | `public.shipments` | Stores shipment records |

**Supabase region:** Paris (`eu-west-3`)  
**Supabase project:** `blueharbor-trackit` (Paris project)  
**Supabase project URL:** `https://ptbtescajqyqoiogjuei.supabase.co`

> The earlier Supabase project created in Ireland (`eu-west-1`) was retained and not used for this integration. The Paris project is the active database for this exercise.

## Database Configuration

Created the table `public.shipments` using the Supabase SQL Editor:

```sql
create table if not exists public.shipments (
    id text primary key,
    status text not null,
    hub text not null,
    created_at timestamptz default now()
);

alter table public.shipments enable row level security;

grant select on public.shipments to anon;

drop policy if exists "Allow public shipment reads"
on public.shipments;

create policy "Allow public shipment reads"
on public.shipments
for select
to anon
using (true);

insert into public.shipments (id, status, hub)
values
    ('BH-1001', 'in transit', 'Lille'),
    ('BH-1002', 'delivered', 'Paris')
on conflict (id) do nothing;
```

### Row Level Security (RLS)

- Row Level Security is enabled on `public.shipments`.
- The `anon` role has `SELECT` permission.
- The `Allow public shipment reads` policy permits read access to shipment rows.
- No public insert, update, or delete policy was created.

This is a demonstration policy for the lab dataset. In a production system, shipment records should be protected by an appropriate authentication and authorization model.

## Vercel Environment Variables

The following environment variables were configured in the Vercel project `bh-trackit-fg` for **Production** and **Preview**:

| Variable | Purpose |
|---|---|
| `SUPABASE_URL` | Supabase project URL |
| `SUPABASE_KEY` | Supabase publishable key |

Credential values are intentionally not stored in this repository. API keys, passwords, `.env` files, and Supabase secret/service-role keys must never be committed.

The application was redeployed after adding the environment variables.

## Application Integration

The TrackIt Flask backend reads a shipment from Supabase through its REST API:

```python
def fetch_shipment(sid):
    """Read one shipment from Supabase through its REST API."""
    base = os.environ["SUPABASE_URL"].rstrip("/")
    url = f"{base}/rest/v1/shipments?id=eq.{urllib.parse.quote(sid)}&select=*"
    req = urllib.request.Request(url, headers={"apikey": os.environ["SUPABASE_KEY"]})
    with urllib.request.urlopen(req, timeout=5) as r:
        rows = json.load(r)
    return rows[0] if rows else None
```

Endpoint:

```text
GET /api/shipments/<sid>
```

When both `SUPABASE_URL` and `SUPABASE_KEY` are configured, the application queries Supabase. Otherwise, the route falls back to the static demonstration response.

## Validation

After the Vercel Production redeployment, both test records were retrieved successfully through the deployed application endpoint.

### Test 1 — Shipment BH-1001

Request:

```text
https://bh-trackit-fg.vercel.app/api/shipments/BH-1001
```

Response:

```json
{
  "created_at": "2026-11-17T15:04:06.665263+00:00",
  "hub": "Lille",
  "id": "BH-1001",
  "status": "in transit"
}
```

**Result:** PASS

### Test 2 — Shipment BH-1002

Request:

```text
https://bh-trackit-fg.vercel.app/api/shipments/BH-1002
```

Response:

```json
{
  "created_at": "2026-11-17T15:04:06.665263+00:00",
  "hub": "Paris",
  "id": "BH-1002",
  "status": "delivered"
}
```

**Result:** PASS

## Outcome

Exercise 6.5 is complete.

The TrackIt application hosted on Vercel successfully retrieved records from a managed PostgreSQL database hosted by Supabase in the Paris region. The integration was validated through two successful HTTP requests to the deployed Flask endpoint.

## Evidence to Capture

Add screenshots to the `lab06/evidence/` directory when available:

- [ ] Supabase Table Editor showing `public.shipments` and the two test records.
- [ ] Supabase project settings showing the Paris region (`eu-west-3`).
- [ ] Vercel environment variable names (hide all values).
- [ ] Vercel Production deployment showing `Ready`.
- [ ] Successful response for `BH-1001`.
- [ ] Successful response for `BH-1002`.

Do not include screenshots that reveal API key values or other credentials.
