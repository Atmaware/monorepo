-- Type: DO
-- Name: highlight_replies
-- Description: Create ruminer.highlight_reply table

BEGIN;

CREATE TABLE ruminer.highlight_reply (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
    highlight_id uuid NOT NULL REFERENCES ruminer.highlight ON DELETE CASCADE,
    text text NOT NULL,
    created_at timestamptz NOT NULL default current_timestamp,
    updated_at timestamptz
);

CREATE TRIGGER update_highlight_reply_modtime BEFORE UPDATE ON ruminer.highlight_reply FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

ALTER TABLE ruminer.highlight_reply ENABLE ROW LEVEL SECURITY;

CREATE POLICY read_highlight_reply on ruminer.highlight_reply
  FOR SELECT TO ruminer_user
  USING (true);

CREATE POLICY create_highlight_reply on ruminer.highlight_reply
  FOR INSERT TO ruminer_user
  WITH CHECK (true);

CREATE POLICY update_highlight_reply on ruminer.highlight_reply
  FOR UPDATE TO ruminer_user
  USING (user_id = ruminer.get_current_user_id());

GRANT SELECT, INSERT, UPDATE ON ruminer.highlight_reply TO ruminer_user;

COMMIT;
