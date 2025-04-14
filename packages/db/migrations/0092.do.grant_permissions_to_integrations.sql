-- Type: DO
-- Name: grant_permissions_to_integrations
-- Description: Grant DB permissions to integrations table

BEGIN;

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.integrations TO ruminer_user;

COMMIT;
