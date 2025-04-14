-- Type: DO
-- Name: drop_membership_from_user
-- Description: drop membership column from user table

BEGIN;

ALTER TABLE ruminer.user
    DROP column membership;

DROP TYPE ruminer.membership_tier;

COMMIT;
