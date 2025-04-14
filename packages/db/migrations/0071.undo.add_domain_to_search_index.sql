-- Type: UNDO
-- Name: add_domain_to_search_index
-- Description: Add the site's domain to the search index

BEGIN;

DROP TRIGGER IF EXISTS page_tsv_update ON ruminer.pages;
DROP FUNCTION IF EXISTS article_tsv_update();
DROP FUNCTION IF EXISTS update_page_tsv();

CREATE OR REPLACE TRIGGER article_tsv_update BEFORE INSERT OR UPDATE
    ON ruminer.pages FOR EACH ROW EXECUTE PROCEDURE
    tsvector_update_trigger(
    tsv, 'pg_catalog.english', content, title, description
);

COMMIT;
