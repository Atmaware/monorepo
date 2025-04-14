-- Type: DO
-- Name: user_feed_and_friends
-- Description: user feed and user friends

BEGIN;

CREATE TABLE ruminer.user_friends (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
  friend_user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT current_timestamp,
  UNIQUE (user_id, friend_user_id)
);

ALTER TABLE ruminer.user_friends ENABLE ROW LEVEL SECURITY;

CREATE POLICY read_user_friends on ruminer.user_friends
  FOR SELECT TO ruminer_user
  USING (user_id = ruminer.get_current_user_id() OR friend_user_id = ruminer.get_current_user_id());

CREATE POLICY create_user_friends on ruminer.user_friends
  FOR INSERT TO ruminer_user
  WITH CHECK (true);

CREATE POLICY delete_user_friends on ruminer.user_friends
  FOR DELETE TO ruminer_user
  USING (user_id = ruminer.get_current_user_id());

GRANT SELECT, INSERT, DELETE ON ruminer.user_friends TO ruminer_user;

COMMIT;
