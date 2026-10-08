-- ResearchFrontier — Works schema
-- A "work" is a normalized research paper aggregated from OpenAlex / Crossref /
-- arXiv / bioRxiv / medRxiv / Europe PMC. Deduplicated on DOI first, then on
-- preprint<->published clusters, then on fuzzy title+author+year.

-- Review/publication status shown as a badge in the UI. Derived from metadata,
-- never guessed. See researchfrontier-backend/app/services/badges.py.
--   peer_reviewed       -> journal "version of record"
--   preprint_published  -> a preprint that now has a peer-reviewed version
--   preprint            -> preprint / posted content, not peer reviewed
--   retracted           -> retracted or under expression of concern
--   unknown             -> insufficient / conflicting metadata
CREATE TYPE review_status AS ENUM (
    'peer_reviewed',
    'preprint_published',
    'preprint',
    'retracted',
    'unknown'
);

CREATE TYPE confidence_level AS ENUM ('high', 'medium', 'low');

CREATE TABLE IF NOT EXISTS work (
    id                  BIGSERIAL PRIMARY KEY,
    openalex_id         TEXT UNIQUE,                 -- e.g. 'https://openalex.org/W1234567890'
    doi                 TEXT UNIQUE,                 -- normalized: lowercase, no 'https://doi.org/'
    published_doi       TEXT,                        -- for a preprint, the journal DOI when it exists

    title               TEXT NOT NULL,
    abstract            TEXT,
    authors             JSONB NOT NULL DEFAULT '[]', -- [{"name": "...", "position": "first|middle|last"}]

    publication_date    DATE,                        -- user-facing "published" date
    publication_year    INTEGER,
    ingested_date       DATE NOT NULL DEFAULT CURRENT_DATE,  -- ingestion watermark (separate from pub date)

    language            TEXT,
    cited_by_count      INTEGER NOT NULL DEFAULT 0,

    -- Source / venue
    primary_source_name TEXT,                        -- journal or repository name
    primary_source_type TEXT,                        -- journal | repository | conference | book series | other
    openalex_type       TEXT,                        -- article | preprint | review | dataset | ...
    crossref_type       TEXT,                        -- journal-article | posted-content | ...
    landing_page_url    TEXT,
    pdf_url             TEXT,
    is_oa               BOOLEAN NOT NULL DEFAULT FALSE,

    -- Derived peer-review badge
    is_retracted        BOOLEAN NOT NULL DEFAULT FALSE,
    review_status       review_status NOT NULL DEFAULT 'unknown',
    review_confidence   confidence_level NOT NULL DEFAULT 'low',
    review_evidence     JSONB NOT NULL DEFAULT '{}', -- which signals drove the badge (shown as "why")

    -- Denormalized taxonomy pointers (from the primary topic) for fast field queries
    primary_topic_id    INTEGER REFERENCES topic(id) ON DELETE SET NULL,
    primary_subfield_id INTEGER REFERENCES subfield(id) ON DELETE SET NULL,
    primary_field_id    INTEGER REFERENCES field(id) ON DELETE SET NULL,
    primary_domain_id   INTEGER REFERENCES domain(id) ON DELETE SET NULL,

    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Up to 3 topics per work (OpenAlex primary_topic + topics[]), with calibrated score.
CREATE TABLE IF NOT EXISTS work_topic (
    work_id     BIGINT  NOT NULL REFERENCES work(id) ON DELETE CASCADE,
    topic_id    INTEGER NOT NULL REFERENCES topic(id) ON DELETE CASCADE,
    score       REAL    NOT NULL DEFAULT 0,
    is_primary  BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (work_id, topic_id)
);

-- All known external identifiers for a work — the dedup/alternate-key store.
CREATE TABLE IF NOT EXISTS work_identifier (
    work_id BIGINT NOT NULL REFERENCES work(id) ON DELETE CASCADE,
    scheme  TEXT   NOT NULL,   -- doi | arxiv | pmid | openalex | mag | s2 | core
    value   TEXT   NOT NULL,
    PRIMARY KEY (scheme, value)
);

-- Per-field digest editions (the Mon/Wed/Fri in-app brief), built by a scheduled job.
CREATE TABLE IF NOT EXISTS digest (
    id            BIGSERIAL PRIMARY KEY,
    subfield_id   INTEGER NOT NULL REFERENCES subfield(id) ON DELETE CASCADE,
    edition_date  DATE    NOT NULL,
    window_days   INTEGER NOT NULL DEFAULT 2,
    headline      TEXT,
    summary       TEXT,                    -- short editorial summary of the window
    work_ids      BIGINT[] NOT NULL DEFAULT '{}',
    stats         JSONB    NOT NULL DEFAULT '{}',   -- counts by badge, top directions, deltas
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (subfield_id, edition_date)
);

-- High-water marks per source, so incremental ingestion resumes correctly.
CREATE TABLE IF NOT EXISTS ingestion_state (
    source        TEXT PRIMARY KEY,        -- openalex | crossref | arxiv | biorxiv | ...
    last_cursor   TEXT,
    last_ingested TIMESTAMPTZ,
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);
