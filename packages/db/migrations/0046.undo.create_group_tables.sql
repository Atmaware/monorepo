-- Type: UNDO
-- Name: create_group_tables
-- Description: Add tables for groups and group memberships

BEGIN;

DROP TABLE ruminer.group_membership ;
DROP TABLE ruminer.invite ;
DROP TABLE ruminer.group ;

COMMIT;
