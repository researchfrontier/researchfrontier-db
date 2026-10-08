-- ResearchFrontier — Taxonomy schema
-- Mirrors the OpenAlex Topics hierarchy: Domain -> Field -> Subfield -> Topic
-- (4 domains, 26 fields, 252 subfields, ~4,516 topics; CC0-licensed).
-- This SQL is the CANONICAL source of truth for the schema. The backend's
-- SQLAlchemy models mirror these tables; they do not generate them.

CREATE TABLE IF NOT EXISTS domain (
    id            INTEGER PRIMARY KEY,              -- OpenAlex numeric id (1..4)
    openalex_id   TEXT UNIQUE NOT NULL,             -- e.g. 'https://openalex.org/domains/3'
    display_name  TEXT NOT NULL,
    description   TEXT,
    works_count   BIGINT NOT NULL DEFAULT 0,
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS field (
    id            INTEGER PRIMARY KEY,              -- OpenAlex numeric id
    openalex_id   TEXT UNIQUE NOT NULL,
    display_name  TEXT NOT NULL,
    description   TEXT,
    domain_id     INTEGER NOT NULL REFERENCES domain(id) ON DELETE CASCADE,
    works_count   BIGINT NOT NULL DEFAULT 0,
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS subfield (
    id            INTEGER PRIMARY KEY,              -- OpenAlex numeric id
    openalex_id   TEXT UNIQUE NOT NULL,
    display_name  TEXT NOT NULL,
    description   TEXT,
    field_id      INTEGER NOT NULL REFERENCES field(id) ON DELETE CASCADE,
    works_count   BIGINT NOT NULL DEFAULT 0,
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- A "research field" in product terms = an OpenAlex SUBFIELD (252 specific areas,
-- e.g. "Artificial Intelligence", "Cardiology"). Its "directions" = the TOPICS below it.
CREATE TABLE IF NOT EXISTS topic (
    id            INTEGER PRIMARY KEY,              -- OpenAlex numeric id (the N in 'T{N}')
    openalex_id   TEXT UNIQUE NOT NULL,             -- e.g. 'https://openalex.org/T10017'
    display_name  TEXT NOT NULL,
    description   TEXT,
    keywords      TEXT[] NOT NULL DEFAULT '{}',
    subfield_id   INTEGER NOT NULL REFERENCES subfield(id) ON DELETE CASCADE,
    works_count   BIGINT NOT NULL DEFAULT 0,
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_field_domain      ON field(domain_id);
CREATE INDEX IF NOT EXISTS idx_subfield_field    ON subfield(field_id);
CREATE INDEX IF NOT EXISTS idx_topic_subfield    ON topic(subfield_id);
