-- Type: UNDO
-- Name: user_articles
-- Description: user to article map model

BEGIN;

DROP TRIGGER update_user_articles_modtime ON ruminer.user_articles;

DROP TABLE ruminer.user_articles;

COMMIT;
