-- Type: DO
-- Name: post
-- Description: Create a post table

BEGIN;

CREATE TABLE ruminer.post (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    user_id UUID NOT NULL REFERENCES ruminer.user(id) ON DELETE CASCADE,
    library_item_ids UUID[] NOT NULL,
	highlight_ids UUID[],
    title TEXT NOT NULL,
	content TEXT NOT NULL, -- generated from template
	thumbnail TEXT,
	thought TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX post_user_id_idx ON ruminer.post(user_id);

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.post TO ruminer_user;

ALTER TABLE ruminer.post ENABLE ROW LEVEL SECURITY;

CREATE POLICY read_post ON ruminer.post
    FOR SELECT TO ruminer_user
    USING (true);

CREATE POLICY write_post ON ruminer.post
    FOR INSERT TO ruminer_user
    WITH CHECK (user_id = ruminer.get_current_user_id());

CREATE POLICY update_post ON ruminer.post
    FOR UPDATE TO ruminer_user
    USING (user_id = ruminer.get_current_user_id());

CREATE POLICY delete_post ON ruminer.post
    FOR DELETE TO ruminer_user
    USING (user_id = ruminer.get_current_user_id());

COMMIT;
