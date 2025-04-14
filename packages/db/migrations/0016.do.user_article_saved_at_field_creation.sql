-- Type: DO
-- Name: user_articles_saved_at_field_creation
-- Description: Creates the "saved_at" field for the user_articles table

BEGIN;

ALTER TABLE ruminer.user_articles
    ADD column saved_at timestamptz DEFAULT current_timestamp;

UPDATE ruminer.user_articles
    SET saved_at = created_at;

ALTER TABLE ruminer.user_articles
    ALTER COLUMN saved_at SET NOT NULL;

COMMIT;
