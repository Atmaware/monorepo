-- Type: UNDO
-- Name: alter_ruminer_admin_role
-- Description: Alter ruminer_admin role to prevent ruminer_admin to be inherited by app_user or ruminer_user

BEGIN;

DROP POLICY library_item_admin_policy ON ruminer.library_item;
REVOKE SELECT, INSERT, UPDATE, DELETE ON ruminer.library_item FROM ruminer_admin;

DROP POLICY user_admin_policy ON ruminer.user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON ruminer.user FROM ruminer_admin;

REVOKE USAGE ON SCHEMA ruminer FROM ruminer_admin;

DROP ROLE ruminer_admin;

ALTER ROLE ruminer_user INHERIT;

CREATE ROLE ruminer_admin;

GRANT ruminer_admin TO app_user;

GRANT ALL PRIVILEGES ON SCHEMA ruminer TO ruminer_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA ruminer TO ruminer_admin;

CREATE POLICY user_admin_policy on ruminer.user
    FOR ALL
    TO ruminer_admin
    USING (true);

CREATE POLICY library_item_admin_policy on ruminer.library_item
    FOR ALL
    TO ruminer_admin
    USING (true);

COMMIT;
