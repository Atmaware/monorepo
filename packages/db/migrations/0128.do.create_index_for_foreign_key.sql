-- Type: DO
-- Name: create_index_for_foreign_key
-- Description: Create index for foreign keys on entity_label and highlight tables

BEGIN;

CREATE INDEX IF NOT EXISTS entity_labels_library_item_id_idx ON ruminer.entity_labels(library_item_id);
CREATE INDEX IF NOT EXISTS entity_labels_highlight_id_idx ON ruminer.entity_labels(highlight_id);

CREATE INDEX IF NOT EXISTS highlight_library_item_id_idx ON ruminer.highlight (library_item_id);

CREATE INDEX IF NOT EXISTS user_profile_user_id_idx ON ruminer.user_profile (user_id);

CREATE INDEX IF NOT EXISTS library_item_slug_idx ON ruminer.library_item (slug);
-- create index for sorting
CREATE INDEX IF NOT EXISTS library_item_saved_at_idx ON ruminer.library_item (saved_at);
CREATE INDEX IF NOT EXISTS library_item_updated_at_idx ON ruminer.library_item (updated_at);
CREATE INDEX IF NOT EXISTS library_item_read_at_idx ON ruminer.library_item (read_at);

COMMIT;
