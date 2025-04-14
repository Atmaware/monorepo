-- Type: UNDO
-- Name: library_item_user_id_state_index
-- Description: Create an index on ruminer.library_item table for querying by user_id and state

BEGIN;

DROP INDEX IF EXISTS ruminer.library_item_user_id_state_idx;

COMMIT;
