-- Type: UNDO
-- Name: rename_user_articles_to_links
-- Description: Rename the user_article table to links

BEGIN;

AlTER TABLE ruminer.links RENAME TO user_articles;

COMMIT;
