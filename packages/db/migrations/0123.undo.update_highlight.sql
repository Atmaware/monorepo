-- Type: UNDO
-- Name: update_highlight
-- Description: Add fields to highlight table

BEGIN;

DROP TRIGGER IF EXISTS library_item_highlight_annotations_update ON ruminer.highlight;
DROP FUNCTION IF EXISTS update_library_item_highlight_annotations();

DROP POLICY delete_highlight on ruminer.highlight;
REVOKE DELETE ON ruminer.highlight FROM ruminer_user;

ALTER TABLE ruminer.highlight 
    ADD COLUMN deleted boolean DEFAULT false,
    ADD COLUMN article_id uuid,
    ADD COLUMN elastic_page_id uuid,
    DROP COLUMN library_item_id,
    DROP COLUMN html,
    DROP COLUMN color,
    DROP COLUMN highlight_type,
    DROP COLUMN highlight_position_anchor_index,
    DROP COLUMN highlight_position_percent;

DROP TYPE highlight_type;

COMMIT;
