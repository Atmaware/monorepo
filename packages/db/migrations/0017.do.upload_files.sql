-- Type: DO
-- Name: upload_files
-- Description: uploaded files in storage

BEGIN;

CREATE TYPE upload_status_type AS ENUM ('INITIALIZED', 'COMPLETED');

CREATE TABLE ruminer.upload_files (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  user_id uuid NOT NULL REFERENCES ruminer.user,
  url text NOT NULL,
  status upload_status_type DEFAULT 'INITIALIZED' NOT NULL,
  file_name text NOT NULL,
  content_type text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT current_timestamp,
  updated_at timestamptz NOT NULL DEFAULT current_timestamp
);

CREATE TRIGGER upload_files_modtime BEFORE UPDATE ON ruminer.upload_files FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

ALTER TABLE ruminer.upload_files ENABLE ROW LEVEL SECURITY;

-- Enabling reading policy for everybody to reduce trx amount and in case we share file to other users
CREATE POLICY read_upload_file on ruminer.upload_files
  FOR SELECT TO ruminer_user
  USING (true);

CREATE POLICY create_upload_file on ruminer.upload_files
  FOR INSERT TO ruminer_user
  WITH CHECK (true);

CREATE POLICY update_upload_file on ruminer.upload_files
  FOR UPDATE TO ruminer_user
  USING (user_id = ruminer.get_current_user_id());

-- No permission to delete on the upload_files table, only superuser can delete.
GRANT SELECT, INSERT, UPDATE ON ruminer.upload_files TO ruminer_user;

COMMIT;
