-- Type: DO
-- Name: add_membership_type_column_to_user_table
-- Description: Add a new membership type and set it on all users. 

BEGIN;

CREATE TYPE ruminer.membership_tier AS ENUM ('WAIT_LIST', 'BETA');

ALTER TABLE ruminer.user
    ADD column membership ruminer.membership_tier NOT NULL DEFAULT 'WAIT_LIST';

UPDATE ruminer.user SET membership = 'BETA';

COMMIT;
