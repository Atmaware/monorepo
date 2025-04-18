-- Type: DO
-- Name: library_item
-- Description: Create library_item table

BEGIN;

CREATE EXTENSION IF NOT EXISTS vector;

CREATE TYPE library_item_state AS ENUM ('SUCCEEDED', 'FAILED', 'PROCESSING', 'ARCHIVED', 'DELETED');
CREATE TYPE content_reader_type AS ENUM ('WEB', 'PDF', 'EPUB');
CREATE TYPE directionality_type AS ENUM ('LTR', 'RTL');

CREATE TABLE ruminer.library_item (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
    state library_item_state NOT NULL DEFAULT 'SUCCEEDED',
    original_url text NOT NULL,
    download_url text,
    slug text NOT NULL,
    title text NOT NULL,
    author text,
    description text,
    saved_at timestamptz NOT NULL DEFAULT current_timestamp,
    created_at timestamptz NOT NULL DEFAULT current_timestamp,
    published_at timestamptz,
    archived_at timestamptz,
    deleted_at timestamptz,
    read_at timestamptz,
    updated_at timestamptz NOT NULL DEFAULT current_timestamp,
    item_language text,
    word_count integer,
    site_name text,
    site_icon text,
    metadata JSON,
    reading_progress_last_read_anchor integer NOT NULL DEFAULT 0,
    reading_progress_highest_read_anchor integer NOT NULL DEFAULT 0,
    reading_progress_top_percent real NOT NULL DEFAULT 0,
    reading_progress_bottom_percent real NOT NULL DEFAULT 0,
    thumbnail text,
    item_type text NOT NULL DEFAULT 'UNKNOWN',
    upload_file_id uuid REFERENCES ruminer.upload_files ON DELETE CASCADE,
    content_reader content_reader_type NOT NULL DEFAULT 'WEB',
    original_content text,
    readable_content text NOT NULL DEFAULT '',
    content_tsv tsvector,
    site_tsv tsvector,
    title_tsv tsvector,
    author_tsv tsvector,
    description_tsv tsvector,
    search_tsv tsvector,
    model_name text,
    embedding vector(768),
    text_content_hash text,
    gcs_archive_id text,
    directionality directionality_type NOT NULL DEFAULT 'LTR',
    subscription text,
    label_names text[] NOT NULL DEFAULT array[]::text[], -- array of label names of the item
    highlight_labels text[] NOT NULL DEFAULT array[]::text[], -- array of label names of the item's highlights
    highlight_annotations text[] NOT NULL DEFAULT array[]::text[], -- array of highlight annotations of the item
    note text,
    note_tsv tsvector,
    UNIQUE (user_id, original_url)
);

CREATE TRIGGER update_library_item_modtime BEFORE UPDATE ON ruminer.library_item FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE INDEX library_item_content_tsv_idx ON ruminer.library_item USING GIN (content_tsv);
CREATE INDEX library_item_site_tsv_idx ON ruminer.library_item USING GIN (site_tsv);
CREATE INDEX library_item_title_tsv_idx ON ruminer.library_item USING GIN (title_tsv);
CREATE INDEX library_item_author_tsv_idx ON ruminer.library_item USING GIN (author_tsv);
CREATE INDEX library_item_description_tsv_idx ON ruminer.library_item USING GIN (description_tsv);
CREATE INDEX library_item_search_tsv_idx ON ruminer.library_item USING GIN (search_tsv);
CREATE INDEX library_item_note_tsv_idx ON ruminer.library_item USING GIN (note_tsv);

CREATE OR REPLACE FUNCTION update_library_item_tsv() RETURNS trigger AS $$
begin
    new.content_tsv := to_tsvector('pg_catalog.english', coalesce(new.readable_content, ''));
    new.site_tsv := to_tsvector('pg_catalog.english', coalesce(new.site_name, ''));
    new.title_tsv := to_tsvector('pg_catalog.english', coalesce(new.title, ''));
    new.author_tsv := to_tsvector('pg_catalog.english', coalesce(new.author, ''));
    new.description_tsv := to_tsvector('pg_catalog.english', coalesce(new.description, ''));
    -- note_tsv is generated by both note and highlight_annotations
    new.note_tsv := to_tsvector('pg_catalog.english', coalesce(new.note, '') || ' ' || array_to_string(new.highlight_annotations, ' '));
    new.search_tsv := 
        setweight(new.title_tsv, 'A') || 
        setweight(new.author_tsv, 'A') || 
        setweight(new.site_tsv, 'A') || 
        setweight(new.description_tsv, 'A') || 
        -- full hostname (eg www.ruminer.app)
        setweight(to_tsvector('pg_catalog.english', coalesce(regexp_replace(new.original_url, '^((http[s]?):\/)?\/?([^:\/\s]+)((\/\w+)*\/)([\w\-\.]+[^#?\s]+)(.*)?(#[\w\-]+)?$', '\3'), '')), 'A') || 
        -- secondary hostname (eg ruminer)
        setweight(to_tsvector('pg_catalog.english', coalesce(regexp_replace(new.original_url, '^((http[s]?):\/)?\/?(.*\.)?([^:\/\s]+)(\..*)((\/+)*\/)?([\w\-\.]+[^#?\s]+)(.*)?(#[\w\-]+)?$', '\4'), '')), 'A') ||
        setweight(new.note_tsv, 'A') ||
        setweight(new.content_tsv, 'B');
    return new;
end
$$ LANGUAGE plpgsql;

CREATE TRIGGER library_item_tsv_update BEFORE INSERT OR UPDATE
    ON ruminer.library_item FOR EACH ROW EXECUTE PROCEDURE update_library_item_tsv();

ALTER TABLE ruminer.library_item ENABLE ROW LEVEL SECURITY;

CREATE POLICY library_item_policy ON ruminer.library_item 
    USING (user_id = ruminer.get_current_user_id())
    WITH CHECK (user_id = ruminer.get_current_user_id());

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.library_item TO ruminer_user;

COMMIT;
