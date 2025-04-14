-- Type: UNDO
-- Name: add_delete_permission_to_group
-- Description: Add delete permission to group and membership table

BEGIN;

REVOKE DELETE ON ruminer.group_membership FROM ruminer_user;

REVOKE DELETE ON ruminer."group" FROM ruminer_user;

COMMIT;
