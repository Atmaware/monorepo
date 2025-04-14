-- Type: DO
-- Name: profiles
-- Description: Create profiles table

BEGIN;

CREATE TABLE ruminer.user_profile (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    username text UNIQUE NOT NULL,
    private boolean NOT NULL DEFAULT false,
    bio text,
    picture_url text,
    user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
    created_at timestamptz NOT NULL default current_timestamp,
    updated_at timestamptz
);

CREATE TRIGGER update_profile_modtime BEFORE UPDATE ON ruminer.user_profile FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

ALTER TABLE ruminer.user_profile ENABLE ROW LEVEL SECURITY;

CREATE POLICY read_user_profile on ruminer.user_profile
  FOR SELECT TO ruminer_user
  USING (true);

CREATE POLICY create_user_profile on ruminer.user_profile
  FOR INSERT TO ruminer_user
  WITH CHECK (true);

CREATE POLICY update_user_profile on ruminer.user_profile
  FOR UPDATE TO ruminer_user
  USING (user_id = ruminer.get_current_user_id());

GRANT SELECT, INSERT, UPDATE ON ruminer.user_profile TO ruminer_user;

COMMIT;
