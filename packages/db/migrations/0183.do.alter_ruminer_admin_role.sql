-- Type: DO
-- Name: alter_ruminer_admin_role
-- Description: Alter ruminer_admin role to prevent ruminer_admin to be inherited by app_user or ruminer_user

BEGIN;

DROP POLICY user_admin_policy ON ruminer.user;
DROP POLICY library_item_admin_policy ON ruminer.library_item;

REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA ruminer from ruminer_admin;
REVOKE ALL PRIVILEGES ON SCHEMA ruminer from ruminer_admin;

DROP ROLE ruminer_admin;

CREATE ROLE ruminer_admin;

GRANT USAGE ON SCHEMA ruminer TO ruminer_admin;

ALTER ROLE ruminer_user NOINHERIT; -- This is to prevent ruminer_user from inheriting ruminer_admin role

GRANT ruminer_admin TO ruminer_user; -- This is to allow app_user to set ruminer_admin role

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.user TO ruminer_admin;
CREATE POLICY user_admin_policy on ruminer.user
    FOR ALL
    TO ruminer_admin
    USING (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.library_item TO ruminer_admin;
CREATE POLICY library_item_admin_policy ON ruminer.library_item 
    FOR ALL
    TO ruminer_admin
    USING (true);

COMMIT;
