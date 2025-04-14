-- Type: DO
-- Name: add_rls
-- Description: Add RLS to the tables

BEGIN;

ALTER TABLE ruminer.filters ENABLE ROW LEVEL SECURITY;
CREATE POLICY filters_policy on ruminer.filters
  USING (user_id = ruminer.get_current_user_id())
  WITH CHECK (user_id = ruminer.get_current_user_id());
GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.filters TO ruminer_user;

ALTER TABLE ruminer.integrations ENABLE ROW LEVEL SECURITY;
CREATE POLICY integrations_policy on ruminer.integrations
  USING (user_id = ruminer.get_current_user_id())
  WITH CHECK (user_id = ruminer.get_current_user_id());
GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.integrations TO ruminer_user;

DROP POLICY read_labels ON ruminer.labels;
DROP POLICY create_labels ON ruminer.labels;
CREATE POLICY labels_policy on ruminer.labels
  USING (user_id = ruminer.get_current_user_id())
  WITH CHECK (user_id = ruminer.get_current_user_id());

ALTER TABLE ruminer.received_emails ENABLE ROW LEVEL SECURITY;
CREATE POLICY received_emails_policy on ruminer.received_emails
  USING (user_id = ruminer.get_current_user_id())
  WITH CHECK (user_id = ruminer.get_current_user_id());
GRANT SELECT, INSERT, UPDATE ON ruminer.received_emails TO ruminer_user;

ALTER TABLE ruminer.rules ENABLE ROW LEVEL SECURITY;
CREATE POLICY rules_policy on ruminer.rules
  USING (user_id = ruminer.get_current_user_id())
  WITH CHECK (user_id = ruminer.get_current_user_id());
GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.rules TO ruminer_user;

ALTER TABLE ruminer.webhooks ENABLE ROW LEVEL SECURITY;
CREATE POLICY webhooks_policy on ruminer.webhooks
  USING (user_id = ruminer.get_current_user_id())
  WITH CHECK (user_id = ruminer.get_current_user_id());
GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.webhooks TO ruminer_user;

DROP POLICY read_user_device_tokens ON ruminer.user_device_tokens;
DROP POLICY create_user_device_tokens ON ruminer.user_device_tokens;
CREATE POLICY user_device_tokens_policy on ruminer.user_device_tokens
  USING (user_id = ruminer.get_current_user_id())
  WITH CHECK (user_id = ruminer.get_current_user_id());
GRANT SELECT, INSERT, DELETE ON ruminer.user_device_tokens TO ruminer_user;

COMMIT;
