-- Type: DO
-- Name: create_export_table
-- Description: Create a table to store the export information

BEGIN;

CREATE TABLE ruminer.export (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    user_id UUID NOT NULL REFERENCES ruminer.user(id) ON DELETE CASCADE,
    state TEXT NOT NULL,
    total_items INT DEFAULT 0,
    processed_items INT DEFAULT 0,
    task_id TEXT,
    signed_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX export_user_id_idx ON ruminer.export(user_id);

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.export TO ruminer_user;

COMMIT;
