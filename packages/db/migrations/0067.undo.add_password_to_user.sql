-- Type: UNDO
-- Name: add_password_to_user
-- Description: Add password field to user table

BEGIN;

ALTER TABLE ruminer.user DROP COLUMN password;

COMMIT;
