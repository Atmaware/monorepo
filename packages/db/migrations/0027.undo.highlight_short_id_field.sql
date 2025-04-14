-- Type: UNDO
-- Name: highlight_short_id_field
-- Description: Add short_id field to ruminer.highlight table

BEGIN;

ALTER TABLE ruminer.highlight
    DROP COLUMN short_id;

COMMIT;
