-- Type: DO
-- Name: add_default_value_to_updated_at
-- Description: Add default = now() to updated_at field in profile, labels and highlight table

BEGIN;

UPDATE ruminer.highlight SET updated_at = created_at WHERE updated_at IS NULL;
ALTER TABLE ruminer.highlight
    ALTER COLUMN updated_at SET DEFAULT current_timestamp;

COMMIT;
