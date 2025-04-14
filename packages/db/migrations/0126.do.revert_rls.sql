-- Type: DO
-- Name: revert_rls
-- Description: Revert rls on rows

BEGIN;

ALTER TABLE ruminer.filters DISABLE ROW LEVEL SECURITY;
DROP POLICY filters_policy on ruminer.filters;

ALTER TABLE ruminer.integrations DISABLE ROW LEVEL SECURITY;
DROP POLICY integrations_policy on ruminer.integrations;

DROP POLICY labels_policy on ruminer.labels;
CREATE POLICY read_labels on ruminer.labels
    FOR SELECT TO ruminer_user
    USING (true);
CREATE POLICY create_labels on ruminer.labels
    FOR INSERT TO ruminer_user
    WITH CHECK (true);

ALTER TABLE ruminer.received_emails DISABLE ROW LEVEL SECURITY;
DROP POLICY received_emails_policy on ruminer.received_emails;

ALTER TABLE ruminer.rules DISABLE ROW LEVEL SECURITY;
DROP POLICY rules_policy on ruminer.rules;

ALTER TABLE ruminer.webhooks DISABLE ROW LEVEL SECURITY;
DROP POLICY webhooks_policy on ruminer.webhooks;

DROP POLICY user_device_tokens_policy on ruminer.user_device_tokens;
CREATE POLICY read_user_device_tokens on ruminer.user_device_tokens
    FOR SELECT TO ruminer_user
    USING (true);
CREATE POLICY create_user_device_tokens on ruminer.user_device_tokens
    FOR INSERT TO ruminer_user
    WITH CHECK (true);

COMMIT;
