-- Type: UNDO
-- Name: create_label_names_update_trigger
-- Description: Create label_names_update trigger in library_item table

BEGIN;

CREATE INDEX IF NOT EXISTS library_item_saved_at_idx ON ruminer.library_item (saved_at);
CREATE INDEX IF NOT EXISTS library_item_updated_at_idx ON ruminer.library_item (updated_at);
CREATE INDEX IF NOT EXISTS library_item_read_at_idx ON ruminer.library_item (read_at);

CREATE OR REPLACE FUNCTION update_entity_labels()
RETURNS trigger AS $$
BEGIN
    -- update entity_labels table to trigger update on library_item table
    UPDATE ruminer.entity_labels
    SET label_id = NEW.id
    WHERE label_id = OLD.id;

    return NEW;
END;
$$ LANGUAGE plpgsql;

-- triggers when label name is updated
CREATE TRIGGER entity_labels_update
AFTER UPDATE ON ruminer.labels
FOR EACH ROW
WHEN (OLD.name <> NEW.name)
EXECUTE FUNCTION update_entity_labels();

DROP TRIGGER IF EXISTS label_names_update ON ruminer.labels;

DROP FUNCTION IF EXISTS ruminer.update_label_names();

COMMIT;
