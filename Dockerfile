# ResearchFrontier — local/dev PostgreSQL image.
# Self-initializes with the canonical schema and (for dev) the demo seed.
# Postgres runs files in /docker-entrypoint-initdb.d/ in filename order, and
# ONLY on first init of an empty data volume.
#
# Production (Neon/Supabase) applies the files in schema/ as migrations instead;
# it does NOT load seed/900_seed.sql.
FROM postgres:16-alpine

# Canonical schema (source of truth) — ordered by numeric prefix.
COPY schema/001_taxonomy.sql /docker-entrypoint-initdb.d/001_taxonomy.sql
COPY schema/002_works.sql    /docker-entrypoint-initdb.d/002_works.sql
COPY schema/003_indexes.sql  /docker-entrypoint-initdb.d/003_indexes.sql
COPY schema/004_stats.sql    /docker-entrypoint-initdb.d/004_stats.sql

# Dev/demo seed — runs last. Remove this line for a production-shaped image.
COPY seed/900_seed.sql       /docker-entrypoint-initdb.d/900_seed.sql

HEALTHCHECK --interval=10s --timeout=5s --retries=10 \
  CMD pg_isready -U "${POSTGRES_USER:-postgres}" -d "${POSTGRES_DB:-researchfrontier}" || exit 1
