-- ResearchFrontier — aggregate statistics computed from OpenAlex counts
-- (group_by), NOT from the stored paper sample. This decouples true recent
-- volume (for ranking, momentum, directions, "N of total") from the small feed
-- sample we store for display. Filled by the sync_stats job.

CREATE TABLE IF NOT EXISTS subfield_stats (
    subfield_id    INTEGER PRIMARY KEY REFERENCES subfield(id) ON DELETE CASCADE,
    works_7d       BIGINT NOT NULL DEFAULT 0,
    works_30d      BIGINT NOT NULL DEFAULT 0,   -- true count, last 30 days
    works_prev_30d BIGINT NOT NULL DEFAULT 0,   -- 30 days before that (for momentum)
    computed_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS topic_stats (
    topic_id    INTEGER PRIMARY KEY REFERENCES topic(id) ON DELETE CASCADE,
    works_30d   BIGINT NOT NULL DEFAULT 0,       -- true count, last 30 days
    computed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
