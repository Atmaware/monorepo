-- Type: UNDO
-- Name: grant_update_permission_on_labels
-- Description: Add the update permission on labels

BEGIN;

REVOKE UPDATE ON ruminer.link_labels FROM ruminer_user;

COMMIT;
