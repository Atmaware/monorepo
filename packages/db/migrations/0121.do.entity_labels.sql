-- Type: DO
-- Name: entity_labels
-- Description: Create table entity_labels

BEGIN;

CREATE TABLE ruminer.entity_labels (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    library_item_id uuid REFERENCES ruminer.library_item(id) ON DELETE CASCADE,
    highlight_id uuid REFERENCES ruminer.highlight(id) ON DELETE CASCADE,
    label_id uuid NOT NULL REFERENCES ruminer.labels(id) ON DELETE CASCADE,
    unique(label_id, library_item_id, highlight_id)
);

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.entity_labels TO ruminer_user;

CREATE OR REPLACE FUNCTION update_library_item_labels()
RETURNS trigger AS $$
DECLARE
    current_library_item_id uuid;
    current_highlight_id uuid;
BEGIN
    IF TG_OP = 'DELETE' THEN
        current_library_item_id = OLD.library_item_id;
        current_highlight_id = OLD.highlight_id;
    ELSE
        current_library_item_id = NEW.library_item_id;
        current_highlight_id = NEW.highlight_id;
    END IF;

    IF current_library_item_id IS NOT NULL THEN
        -- for labels of the library_item
        WITH labels_agg AS (
            SELECT array_agg(l.name) as names_agg
            FROM ruminer.labels l
            INNER JOIN ruminer.entity_labels el ON el.label_id = l.id AND el.library_item_id = current_library_item_id
        )
        -- Update label_names on library_item
        UPDATE ruminer.library_item li
        SET label_names = coalesce(l.names_agg, array[]::text[]) 
        FROM labels_agg l
        WHERE li.id = current_library_item_id;
    ELSIF current_highlight_id IS NOT NULL THEN
        -- for labels of highlights of the library item
        current_library_item_id = (SELECT library_item_id FROM ruminer.highlight WHERE id = current_highlight_id);

        WITH labels_agg AS (
            SELECT array_agg(l.name) as names_agg
            FROM ruminer.labels l
            INNER JOIN ruminer.entity_labels el ON el.label_id = l.id 
            INNER JOIN ruminer.highlight h ON h.id = el.highlight_id AND h.library_item_id = current_library_item_id
        )
        -- Update highlight_labels on library_item
        UPDATE ruminer.library_item li
        SET highlight_labels = coalesce(l.names_agg, array[]::text[]) 
        FROM labels_agg l
        WHERE li.id = current_library_item_id;
    END IF;

    return NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER library_item_labels_update
AFTER INSERT OR UPDATE OR DELETE ON ruminer.entity_labels
FOR EACH ROW
EXECUTE FUNCTION update_library_item_labels();

COMMIT;
