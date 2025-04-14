-- Type: DO
-- Name: labels
-- Description: Create labels table

BEGIN;

CREATE TABLE ruminer.labels (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
    link_id uuid NOT NULL REFERENCES ruminer.links ON DELETE CASCADE,
    name text NOT NULL,
    created_at timestamptz NOT NULL DEFAULT current_timestamp,
    UNIQUE (link_id, name)
);

ALTER TABLE ruminer.labels ENABLE ROW LEVEL SECURITY;

CREATE POLICY read_labels on ruminer.labels
    FOR SELECT TO ruminer_user
    USING (true);

CREATE POLICY create_labels on ruminer.labels
    FOR INSERT TO ruminer_user
    WITH CHECK (true);

CREATE POLICY delete_labels on ruminer.labels
    FOR DELETE TO ruminer_user
    USING (user_id = ruminer.get_current_user_id());

GRANT SELECT, INSERT, DELETE ON ruminer.labels TO ruminer_user;

COMMIT;
