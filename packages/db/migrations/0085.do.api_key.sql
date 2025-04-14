-- Type: DO
-- Name: api_key
-- Description: api_key model

BEGIN;

CREATE TABLE ruminer.api_key (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    user_id uuid NOT NULL REFERENCES ruminer.user (id) ON DELETE CASCADE,
    name text NOT NULL,
    key text NOT NULL,
    scopes text[] NOT NULL DEFAULT '{}',
    expires_at timestamptz NOT NULL,
    created_at timestamptz NOT NULL DEFAULT current_timestamp,
    used_at timestamptz,
    UNIQUE (user_id, name)
);

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.api_key TO ruminer_user;

COMMIT;
