-- Type: UNDO
-- Name: user_unique_email
-- Description: add unique index to email

BEGIN;

ALTER TABLE ruminer.user
    DROP COLUMN updated_at;

COMMIT;
