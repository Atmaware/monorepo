-- Type: UNDO
-- Name: add_position_to_labels
-- Description: Add position column to labels table

BEGIN;

DROP TRIGGER IF EXISTS increment_label_position ON ruminer.labels;

DROP TRIGGER IF EXISTS decrement_label_position ON ruminer.labels;

DROP FUNCTION IF EXISTS update_label_position;

ALTER TABLE ruminer.labels DROP COLUMN IF EXISTS position;

COMMIT;
