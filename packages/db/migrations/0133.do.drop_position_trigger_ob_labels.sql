-- Type: DO
-- Name: drop_position_trigger_ob_labels
-- Description: Drop increment_label_position and decrement_label_position trigger on ruminer.labels table

BEGIN;

DROP TRIGGER IF EXISTS increment_label_position ON ruminer.labels;
DROP TRIGGER IF EXISTS decrement_label_position ON ruminer.labels;

COMMIT;
