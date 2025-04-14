-- Type: UNDO
-- Name: add_unique_constraint_in_group_membership
-- Description: Add unique constraint in group_membership table

BEGIN;

ALTER TABLE ruminer.group_membership DROP CONSTRAINT IF EXISTS group_membership_unique;

REVOKE UPDATE ON ruminer.invite FROM ruminer_user;

REVOKE UPDATE ON ruminer.group FROM ruminer_user;

REVOKE UPDATE ON ruminer.group_membership FROM ruminer_user;

COMMIT;
