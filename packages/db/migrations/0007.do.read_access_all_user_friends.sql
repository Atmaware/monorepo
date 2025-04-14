-- Type: DO
-- Name: read_access_all_user_friends
-- Description: Grant read access to user_friends to app role

BEGIN;

DROP POLICY read_user_friends ON ruminer.user_friends;

CREATE POLICY read_all_user_friends ON ruminer.user_friends
  FOR SELECT TO ruminer_user
  USING(true);

COMMIT;
