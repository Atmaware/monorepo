-- Type: UNDO
-- Name: add_failed_at_to_rule
-- Description: Add failed_at column to rules table

BEGIN;

ALTER TABLE ruminer.rules DROP COLUMN failed_at;

COMMIT;
