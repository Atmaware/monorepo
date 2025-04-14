-- Type: UNDO
-- Name: allow_admin_to_delete_filters
-- Description: Add permissions to delete data from filters table to the ruminer_admin role

BEGIN;

DROP POLICY filters_admin_policy on ruminer.filters;

REVOKE SELECT, INSERT, UPDATE, DELETE ON ruminer.filters FROM ruminer_admin;

COMMIT;
