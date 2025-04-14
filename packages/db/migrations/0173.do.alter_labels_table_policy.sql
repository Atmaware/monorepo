-- Type: DO
-- Name: alter_labels_table_policy
-- Description: Alter labels table select policy to check user_id

BEGIN;

ALTER POLICY read_labels ON ruminer.labels
    TO ruminer_user
    USING (user_id = ruminer.get_current_user_id());

COMMIT;
