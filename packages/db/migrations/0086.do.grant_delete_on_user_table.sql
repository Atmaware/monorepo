-- Type: DO
-- Name: grant_delete_on_user_table
-- Description: Allows the Ruminer User to delete themselves (for delete account app feature)

BEGIN;

GRANT DELETE ON ruminer.user TO ruminer_user;

COMMIT;
