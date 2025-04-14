-- Type: UNDO
-- Name: drop_membership_from_user
-- Description: drop membership column from user table

BEGIN;

CREATE TYPE ruminer.membership_tier AS ENUM ('WAIT_LIST', 'BETA');

ALTER TABLE ruminer.user
    ADD column membership ruminer.membership_tier NOT NULL DEFAULT 'WAIT_LIST';

UPDATE ruminer.user SET membership = 'BETA';

COMMIT;
