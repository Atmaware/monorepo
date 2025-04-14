-- Type: UNDO
-- Name: article_saving_request
-- Description: Creates article saving request table

BEGIN;

DROP TRIGGER update_article_saving_request_modtime ON ruminer.article_saving_request;

DROP TABLE ruminer.article_saving_request;

COMMIT;
