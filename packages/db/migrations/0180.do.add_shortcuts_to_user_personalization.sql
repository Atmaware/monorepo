-- Type: DO
-- Name: add_shortcuts_to_user_personalization
-- Description: Add a new shortcuts column to the user personalization table

BEGIN;

ALTER TABLE ruminer.user_personalization ADD COLUMN shortcuts JSONB DEFAULT NULL;

COMMIT;
