-- Type: DO
-- Name: grant_delete_rls_on_users
-- Description: Add RLS delete permission to the users table

BEGIN;

CREATE POLICY delete_users on ruminer.user
    FOR DELETE TO ruminer_user
    USING (id = ruminer.get_current_user_id());

COMMIT;
