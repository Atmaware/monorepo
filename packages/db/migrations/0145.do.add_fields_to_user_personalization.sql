-- Type: DO
-- Name: add_fields_to_user_personalization
-- Description: Add fields column to the user_personalization table

BEGIN;

ALTER TABLE ruminer.user_personalization ADD COLUMN fields json;

COMMIT;
