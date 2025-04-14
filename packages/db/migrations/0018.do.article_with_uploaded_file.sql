-- Type: DO
-- Name: article_with_uploaded_file
-- Description: article column pointing to uploaded file

BEGIN;

ALTER TABLE ruminer.article
    ADD COLUMN upload_file_id uuid REFERENCES ruminer.upload_files;

COMMIT;
