-- ResearchFrontier — Indexes tuned for the slice's hot queries.

-- "Recent papers in a field" (the core field-page query)
CREATE INDEX IF NOT EXISTS idx_work_subfield_date
    ON work (primary_subfield_id, publication_date DESC);

CREATE INDEX IF NOT EXISTS idx_work_field_date
    ON work (primary_field_id, publication_date DESC);

-- "What's hot" / recency sweeps across everything
CREATE INDEX IF NOT EXISTS idx_work_pubdate   ON work (publication_date DESC);
CREATE INDEX IF NOT EXISTS idx_work_ingested  ON work (ingested_date DESC);

-- Badge filtering / counts
CREATE INDEX IF NOT EXISTS idx_work_status    ON work (review_status);

-- Directions (topic breakdown within a field)
CREATE INDEX IF NOT EXISTS idx_work_topic_topic ON work_topic (topic_id);

-- Author search later (GIN over the authors JSONB)
CREATE INDEX IF NOT EXISTS idx_work_authors_gin ON work USING GIN (authors);

-- Digest lookup
CREATE INDEX IF NOT EXISTS idx_digest_subfield_date ON digest (subfield_id, edition_date DESC);
