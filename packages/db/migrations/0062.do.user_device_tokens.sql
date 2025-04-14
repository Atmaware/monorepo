-- Type: DO
-- Name: user_device_tokens
-- Description: Create user_device_tokens table

BEGIN;

CREATE TABLE ruminer.user_device_tokens (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
    token text NOT NULL,
    created_at timestamptz NOT NULL DEFAULT current_timestamp
);

ALTER TABLE ruminer.user_device_tokens ENABLE ROW LEVEL SECURITY;

CREATE POLICY read_user_device_tokens on ruminer.user_device_tokens
    FOR SELECT TO ruminer_user
    USING (true);

CREATE POLICY create_user_device_tokens on ruminer.user_device_tokens
    FOR INSERT TO ruminer_user
    WITH CHECK (true);

CREATE POLICY delete_user_device_tokens on ruminer.user_device_tokens
    FOR DELETE TO ruminer_user
    USING (user_id = ruminer.get_current_user_id());

GRANT SELECT, INSERT, DELETE ON ruminer.user_device_tokens TO ruminer_user;

COMMIT;
