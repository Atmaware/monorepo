-- Type: UNDO
-- Name: add_delete_cascade_on_upload_files
-- Description: Add delete cascade on user_id field on upload_files table

BEGIN;

ALTER TABLE ruminer.upload_files
    DROP CONSTRAINT upload_files_user_id_fkey,
    ADD CONSTRAINT upload_files_user_id_fkey
        FOREIGN KEY (user_id)
        REFERENCES ruminer.user(id);

COMMIT;
