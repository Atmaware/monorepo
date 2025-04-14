-- Type: UNDO
-- Name: replace_unique_index_on_library_item
-- Description: Create a unique index of MD5 hashed url and userId on library item table

BEGIN;

DROP INDEX IF EXISTS ruminer.library_item_user_id_hashed_original_url_key;
ALTER TABLE ruminer.library_item ADD CONSTRAINT library_item_user_id_original_url_key UNIQUE (user_id, original_url);

COMMIT;
