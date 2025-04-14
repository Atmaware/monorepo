-- Type: UNDO
-- Name: article_with_uploaded_file
-- Description: article column pointing to uploaded file

BEGIN;

ALTER TABLE ruminer.article
    DROP COLUMN upload_file_id;

COMMIT;
