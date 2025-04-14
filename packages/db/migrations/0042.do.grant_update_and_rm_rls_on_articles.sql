-- Type: DO
-- Name: grant_update_on_articles
-- Description: Allow articles table to be updated so we can update PDF content async

BEGIN;

GRANT UPDATE ON ruminer.article TO ruminer_user;
ALTER TABLE ruminer.article DISABLE ROW LEVEL SECURITY;

COMMIT;
