-- Type: DO
-- Name: drop_original_content
-- Description: Drop original_content column from library_item table

BEGIN;

ALTER TABLE ruminer.library_item DROP COLUMN IF EXISTS original_content;

COMMIT;
