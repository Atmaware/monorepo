-- Type: UNDO
-- Name: grant_delete_on_user_table
-- Description: Allows the Ruminer User to delete themselves (for delete account app feature)

BEGIN;

REVOKE DELETE ON ruminer.user FROM ruminer_user;

COMMIT;
