-- Type: DO
-- Name: grant_update_permission_on_labels
-- Description: Add the update permission on labels

BEGIN;

GRANT UPDATE ON ruminer.link_labels TO ruminer_user;

COMMIT;
