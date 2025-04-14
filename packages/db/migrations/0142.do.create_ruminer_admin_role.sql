-- Type: DO
-- Name: create_ruminer_admin_role
-- Description: Create ruminer_admin role with admin permissions

BEGIN;

CREATE ROLE ruminer_admin;

GRANT ruminer_admin TO app_user;

GRANT ALL PRIVILEGES ON SCHEMA ruminer TO ruminer_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA ruminer TO ruminer_admin;

CREATE POLICY user_admin_policy on ruminer.user
    FOR ALL
    TO ruminer_admin
    USING (true);

COMMIT;
