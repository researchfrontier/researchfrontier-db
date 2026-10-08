-- ResearchFrontier — Trends layer.
-- Append-only history snapshots (momentum accrues forward, cannot be backfilled) plus
-- precomputed analytics refreshed by the cron. Everything here is filled by scheduled
-- jobs (sync_stats appends history for free; sync_year_counts / sync_rankings refresh
-- the rest) so the Trends page is served entirely from Postgres — zero OpenAlex calls
-- per visitor.

-- Momentum history: one dated row per subfield/topic per sync run.
CREATE TABLE IF NOT EXISTS subfield_stats_history (
    subfield_id    INTEGER NOT NULL REFERENCES subfield(id) ON DELETE CASCADE,
    snapshot_date  DATE    NOT NULL,
    works_7d       BIGINT  NOT NULL DEFAULT 0,
    works_30d      BIGINT  NOT NULL DEFAULT 0,
    works_prev_30d BIGINT  NOT NULL DEFAULT 0,
    PRIMARY KEY (subfield_id, snapshot_date)
);

CREATE TABLE IF NOT EXISTS topic_stats_history (
    topic_id      INTEGER NOT NULL REFERENCES topic(id) ON DELETE CASCADE,
    snapshot_date DATE    NOT NULL,
    works_30d     BIGINT  NOT NULL DEFAULT 0,
    PRIMARY KEY (topic_id, snapshot_date)
);

-- Retroactive yearly output per subfield (OpenAlex group_by=publication_year); gives
-- multi-year curves from day one. Refreshed periodically (upsert).
CREATE TABLE IF NOT EXISTS subfield_year_counts (
    subfield_id      INTEGER NOT NULL REFERENCES subfield(id) ON DELETE CASCADE,
    publication_year INTEGER NOT NULL,
    works_count      BIGINT  NOT NULL DEFAULT 0,
    computed_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (subfield_id, publication_year)
);

-- Most-cited papers per subfield — compact list for the Trends page (latest snapshot).
CREATE TABLE IF NOT EXISTS subfield_top_cited (
    subfield_id      INTEGER NOT NULL REFERENCES subfield(id) ON DELETE CASCADE,
    rank             INTEGER NOT NULL,
    openalex_id      TEXT,
    title            TEXT    NOT NULL,
    doi              TEXT,
    landing_page_url TEXT,
    cited_by_count   BIGINT  NOT NULL DEFAULT 0,
    publication_year INTEGER,
    computed_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (subfield_id, rank)
);

-- Most-active institutions / countries per subfield (latest snapshot).
CREATE TABLE IF NOT EXISTS subfield_ranking (
    subfield_id  INTEGER NOT NULL REFERENCES subfield(id) ON DELETE CASCADE,
    dimension    TEXT    NOT NULL,       -- 'institution' | 'country'
    rank         INTEGER NOT NULL,
    entity_key   TEXT    NOT NULL,       -- OpenAlex id / ISO country code
    entity_name  TEXT    NOT NULL,
    works_count  BIGINT  NOT NULL DEFAULT 0,
    computed_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (subfield_id, dimension, rank)
);

CREATE INDEX IF NOT EXISTS idx_sf_hist_date ON subfield_stats_history(snapshot_date);
CREATE INDEX IF NOT EXISTS idx_tp_hist_date ON topic_stats_history(snapshot_date);
