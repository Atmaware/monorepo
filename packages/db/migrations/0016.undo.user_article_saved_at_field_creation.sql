-- Type: UNDO
-- Name: user_articles_saved_at_field_creation
-- Description: Creates the "saved_at" field for the user_articles table

BEGIN;

ALTER TABLE ruminer.user_articles
    DROP COLUMN saved_at;

COMMIT;
