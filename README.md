# researchfrontier-db

Canonical SQL schema for **ResearchFrontier** — the database layer, run as its
own container and the single source of truth for the data model.

> The backend's SQLAlchemy models *mirror* these tables for querying — they do
> not generate them. If you change the schema, change it here first.

## Data model

Papers are classified against the **OpenAlex Topics** hierarchy (CC0):

```
domain (4)        Physical / Life / Social / Health Sciences
  └─ field (26)        e.g. Computer Science, Medicine
       └─ subfield (252)   e.g. Artificial Intelligence, Oncology   ← a "research field" in the product
            └─ topic (~4,516)   e.g. "Large Language Models and Alignment"  ← a "direction"
```

- A user's **research field** = an OpenAlex *subfield*.
- Its **directions** (where the field is moving) = the *topics* beneath it.
- `work` holds normalized papers, deduplicated on DOI → preprint↔published
  cluster → fuzzy title+author+year. Each work carries a derived
  **peer-review badge** (`review_status` + `review_confidence` + `review_evidence`)
  and denormalized `primary_{topic,subfield,field,domain}_id` pointers for fast
  field queries.

## Files

| Path | Purpose |
|------|---------|
| `schema/001_taxonomy.sql` | domain / field / subfield / topic tables |
| `schema/002_works.sql` | work, work_topic, work_identifier, digest, ingestion_state + enums |
| `schema/003_indexes.sql` | indexes for the hot queries |
| `seed/900_seed.sql` | **dev-only** demo data (no network/API keys needed) |
| `Dockerfile` | self-initializing Postgres 16 image for local dev |

## Run locally (standalone)

```bash
docker build -t researchfrontier-db .
docker run --name rf-db -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=researchfrontier -p 5432:5432 researchfrontier-db
```

Normally you run it via `researchfrontier-infra/docker-compose.yml` instead.

Connection string used by the backend:
`postgresql+asyncpg://postgres:postgres@localhost:5432/researchfrontier`

## Production

Neon / Supabase apply `schema/*.sql` as migrations (via the backend's migration
step) and never load the seed. Init scripts only run on an **empty** data volume,
so to re-seed locally, drop the volume (`docker compose down -v`).
