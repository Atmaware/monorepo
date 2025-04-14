-- Type: DO
-- Name: allow_admin_to_delete_filters
-- Description: Add permissions to delete data from filters table to the ruminer_admin role

BEGIN;

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.filters TO ruminer_admin;

CREATE POLICY filters_admin_policy on ruminer.filters
    FOR ALL
    TO ruminer_admin
    USING (true);

COMMIT;
