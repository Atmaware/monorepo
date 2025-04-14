-- Type: DO
-- Name: user_personalization
-- Description: Creates user personalization table

BEGIN;

CREATE TABLE ruminer.user_personalization (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  user_id uuid NOT NULL UNIQUE REFERENCES ruminer.user ON DELETE CASCADE,
  font_size integer,
  font_family text,
  theme text,
  created_at timestamptz NOT NULL DEFAULT current_timestamp,
  updated_at timestamptz NOT NULL DEFAULT current_timestamp
);

CREATE TRIGGER update_user_personalization_modtime BEFORE UPDATE ON ruminer.user_personalization FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

ALTER TABLE ruminer.user_personalization ENABLE ROW LEVEL SECURITY;

-- Enabling reading policy for everybody to reduce trx amount and in case we would need any analytics on this
CREATE POLICY read_user_personalization on ruminer.user_personalization
  FOR SELECT TO ruminer_user
  USING (true);

CREATE POLICY create_user_personalization on ruminer.user_personalization
  FOR INSERT TO ruminer_user
  WITH CHECK (true);

CREATE POLICY update_user_personalization on ruminer.user_personalization
  FOR UPDATE TO ruminer_user
  USING (user_id = ruminer.get_current_user_id());

CREATE POLICY delete_user_personalization on ruminer.user_personalization
  FOR DELETE TO ruminer_user
  USING (user_id = ruminer.get_current_user_id());

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.user_personalization TO ruminer_user;

COMMIT;
