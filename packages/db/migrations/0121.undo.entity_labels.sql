-- Type: UNDO
-- Name: entity_labels
-- Description: Create table entity_labels

BEGIN;

DROP TRIGGER library_item_labels_update ON ruminer.entity_labels;
DROP FUNCTION update_library_item_labels();

DROP TABLE ruminer.entity_labels;

COMMIT;
