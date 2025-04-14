-- Type: DO
-- Name: library_item_user_id_state_index
-- Description: Create an index on ruminer.library_item table for querying by user_id and state

CREATE INDEX CONCURRENTLY IF NOT EXISTS library_item_user_id_state_idx ON ruminer.library_item (user_id, state);
