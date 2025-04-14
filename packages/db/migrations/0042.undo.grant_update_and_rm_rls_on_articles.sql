-- Type: DO
-- Name: rm_article_row_level_security
-- Description: Remove row level security from the article model

BEGIN;

REVOKE GRANT UPDATE ON ruminer.article TO ruminer_user;
ALTER TABLE ruminer.article ENABLE ROW LEVEL SECURITY;

COMMIT;
