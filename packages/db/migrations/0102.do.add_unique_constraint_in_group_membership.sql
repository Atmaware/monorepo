-- Type: DO
-- Name: add_unique_constraint_in_group_membership
-- Description: Add unique constraint in group_membership table

BEGIN;

ALTER TABLE ruminer.group_membership ADD CONSTRAINT group_membership_unique UNIQUE (group_id, user_id);

GRANT UPDATE ON TABLE ruminer.invite TO ruminer_user;

GRANT UPDATE ON TABLE ruminer.group TO ruminer_user;

GRANT UPDATE ON TABLE ruminer.group_membership TO ruminer_user;

COMMIT;
