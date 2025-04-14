-- Type: DO
-- Name: grant_update_rls_on_labels
-- Description: Add RLS update permission to the labels table

BEGIN;

CREATE POLICY update_labels on ruminer.labels
    FOR UPDATE TO ruminer_user
    USING (user_id = ruminer.get_current_user_id());

GRANT UPDATE ON ruminer.labels TO ruminer_user;

COMMIT;
