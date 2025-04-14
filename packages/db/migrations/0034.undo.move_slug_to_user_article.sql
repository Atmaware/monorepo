-- Type: UNDO
-- Name: move_slug_to_user_article
-- Description: Move the slug column from the article to the user article 

BEGIN;

ALTER TABLE ruminer.article ADD COLUMN slug TEXT;
UPDATE ruminer.article a SET slug = ua.slug FROM ruminer.user_articles ua WHERE article_id = a.id;

ALTER TABLE ruminer.user_articles DROP COLUMN slug;
ALTER TABLE ruminer.article ALTER COLUMN slug SET NOT NULL;
CREATE INDEX article_slug_idx ON ruminer.article(slug);

COMMIT;
