-- Type: DO
-- Name: rename_user_articles_to_links
-- Description: Rename the user_article table to links

BEGIN;

AlTER TABLE ruminer.user_articles RENAME TO links;

COMMIT;
