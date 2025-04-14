-- Type: DO
-- Name: user_rename_username
-- Description: rename username column to source_username

BEGIN;

ALTER TABLE ruminer.user
    ALTER COLUMN username DROP NOT NULL;

ALTER TABLE ruminer.user
    RENAME COLUMN username TO source_username;

COMMIT;
