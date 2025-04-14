-- Type: DO
-- Name: search_history
-- Description: Create search_history table which contains searched keyword and timestamp

BEGIN;

CREATE TABLE ruminer.search_history (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
    term VARCHAR(255) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT current_timestamp,
    unique (user_id, term)
);

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.search_history TO ruminer_user;

COMMIT;
