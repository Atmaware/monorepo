-- Type: DO
-- Name: drop_slow_db_triggers
-- Description: Drop some db triggers which are slow and have cascading effect

BEGIN;

DROP TRIGGER IF EXISTS library_item_labels_update ON ruminer.entity_labels;
DROP TRIGGER IF EXISTS library_item_highlight_annotations_update ON ruminer.highlight;
DROP TRIGGER IF EXISTS label_names_update ON ruminer.labels;

COMMIT;
