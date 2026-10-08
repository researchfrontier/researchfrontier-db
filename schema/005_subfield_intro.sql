-- ResearchFrontier — migration: per-field encyclopedic intro columns.
-- Adds the Wikipedia/Wikidata anchors used for the field "Overview" (a non-expert
-- intro: CC0 description + a link to a canonical encyclopedia article). Idempotent,
-- so it is safe to re-apply and to run against a database created before these
-- columns existed (001_taxonomy.sql already defines them for fresh installs).
ALTER TABLE subfield ADD COLUMN IF NOT EXISTS wikipedia_url TEXT;
ALTER TABLE subfield ADD COLUMN IF NOT EXISTS wikidata_id   TEXT;
