-- Type: DO
-- Name: add_delete_permission_to_group
-- Description: Add delete permission to group and membership table

BEGIN;

GRANT DELETE ON ruminer."group" TO ruminer_user;

GRANT DELETE ON ruminer.group_membership TO ruminer_user;

COMMIT;
