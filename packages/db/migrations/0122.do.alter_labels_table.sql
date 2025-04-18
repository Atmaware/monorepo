-- Type: DO
-- Name: alter_labels_table
-- Description: Alter labels table

BEGIN;

ALTER TABLE ruminer.labels ADD COLUMN updated_at timestamptz;

CREATE TRIGGER update_labels_modtime BEFORE UPDATE ON ruminer.labels 
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

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

ALTER TABLE ruminer.abuse_report DROP COLUMN page_id;
ALTER TABLE ruminer.abuse_report RENAME COLUMN elastic_page_id TO library_item_id;
ALTER TABLE ruminer.content_display_report DROP COLUMN page_id;
ALTER TABLE ruminer.content_display_report RENAME COLUMN elastic_page_id TO library_item_id;

COMMIT;
