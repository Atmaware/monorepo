-- Type: DO
-- Name: add_index_for_cleanup_to_user
-- Description: Add index of status and updated_at to ruminer.user table for cleanup of deleted users

BEGIN;

CREATE INDEX IF NOT EXISTS user_status_updated_at_idx ON ruminer.user (status, updated_at);

COMMIT;
