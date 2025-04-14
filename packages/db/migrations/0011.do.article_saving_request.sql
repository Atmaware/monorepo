-- Type: DO
-- Name: article_saving_request
-- Description: Creates article saving request table

BEGIN;

CREATE TABLE ruminer.article_saving_request (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
  article_id uuid REFERENCES ruminer.article ON DELETE CASCADE,
  status text DEFAULT 'PROCESSING',
  error_code text,
  created_at timestamptz NOT NULL DEFAULT current_timestamp,
  updated_at timestamptz NOT NULL DEFAULT current_timestamp
);

CREATE TRIGGER update_article_saving_request_modtime BEFORE UPDATE ON ruminer.article_saving_request FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

ALTER TABLE ruminer.article_saving_request ENABLE ROW LEVEL SECURITY;

-- Enabling reading policy for everybody to reduce trx amount and in case we would need any analytics on this
CREATE POLICY read_article_saving_request on ruminer.article_saving_request
  FOR SELECT TO ruminer_user
  USING (true);

CREATE POLICY create_article_saving_request on ruminer.article_saving_request
  FOR INSERT TO ruminer_user
  WITH CHECK (true);

CREATE POLICY update_article_saving_request on ruminer.article_saving_request
  FOR UPDATE TO ruminer_user
  USING (user_id = ruminer.get_current_user_id());

CREATE POLICY delete_article_saving_request on ruminer.article_saving_request
  FOR DELETE TO ruminer_user
  USING (user_id = ruminer.get_current_user_id());

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.article_saving_request TO ruminer_user;

COMMIT;
