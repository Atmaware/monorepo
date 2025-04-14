-- Type: UNDO
-- Name: grant_permissions_to_integrations
-- Description: Grant DB permissions to integrations table

BEGIN;

REVOKE SELECT, INSERT, UPDATE, DELETE ON ruminer.integrations FROM ruminer_user;

COMMIT;
