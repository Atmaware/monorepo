-- Type: UNDO
-- Name: create_ruminer_admin_role
-- Description: Create ruminer_admin role with admin permissions

BEGIN;

DROP POLICY user_admin_policy ON ruminer.user;

REVOKE ALL PRIVILEGES on ruminer.user from ruminer_admin;
REVOKE ALL PRIVILEGES on SCHEMA ruminer from ruminer_admin;

DROP OWNED BY ruminer_admin;

DROP ROLE IF EXISTS ruminer_admin;

COMMIT;
