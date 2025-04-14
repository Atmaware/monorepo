-- Type: UNDO
-- Name: user_unique_email
-- Description: add unique index to email

BEGIN;

ALTER TABLE ruminer.user
    DROP CONSTRAINT email_unique;

COMMIT;
