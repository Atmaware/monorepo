-- Type: UNDO
-- Name: add_tsv_column_to_articles
-- Description: Add a tsvcector column to the articles table to enable full text search

BEGIN;
DROP INDEX ruminer.article_tsv_idx ;
ALTER TABLE ruminer.article drop column tsv;
DROP TRIGGER article_tsv_update ON ruminer.article;
COMMIT;
