-- Type: DO
-- Name: move_slug_to_user_article
-- Description: Move the slug column from the article to the user article 

BEGIN;

ALTER TABLE ruminer.user_articles ADD COLUMN slug TEXT;
UPDATE ruminer.user_articles SET slug = a.slug FROM ruminer.article a WHERE article_id = a.id ;
ALTER TABLE ruminer.user_articles ALTER COLUMN slug SET NOT NULL;

ALTER TABLE ruminer.article DROP column slug;

COMMIT;
