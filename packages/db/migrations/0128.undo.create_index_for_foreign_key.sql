-- Type: UNDO
-- Name: create_index_for_foreign_key
-- Description: Create index for foreign keys on entity_label and highlight tables

BEGIN;

DROP INDEX IF EXISTS ruminer.library_item_read_at_idx;
DROP INDEX IF EXISTS ruminer.library_item_updated_at_idx;
DROP INDEX IF EXISTS ruminer.library_item_saved_at_idx;
DROP INDEX IF EXISTS ruminer.library_item_slug_idx;

DROP INDEX IF EXISTS ruminer.user_profile_user_id_idx;

DROP INDEX IF EXISTS ruminer.highlight_library_item_id_idx;

DROP INDEX IF EXISTS ruminer.entity_labels_highlight_id_idx;
DROP INDEX IF EXISTS ruminer.entity_labels_library_item_id_idx;

COMMIT;
