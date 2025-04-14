-- Type: DO
-- Name: reminders
-- Description: Add reminders table

BEGIN;

CREATE TABLE ruminer.reminders (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
    article_saving_request_id uuid REFERENCES ruminer.article_saving_request ON DELETE CASCADE,
    link_id uuid REFERENCES ruminer.links ON DELETE CASCADE
);

ALTER TABLE ruminer.reminders ENABLE ROW LEVEL SECURITY;

CREATE POLICY read_reminders on ruminer.reminders
  FOR SELECT TO ruminer_user
  USING (true);

CREATE POLICY create_reminders on ruminer.reminders
  FOR INSERT TO ruminer_user
  WITH CHECK (true);

CREATE POLICY update_reminders on ruminer.reminders
  FOR UPDATE TO ruminer_user
  USING (user_id = ruminer.get_current_user_id());

CREATE POLICY delete_reminders on ruminer.reminders
  FOR DELETE TO ruminer_user
  USING (user_id = ruminer.get_current_user_id());

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.reminders TO ruminer_user;

COMMIT;
