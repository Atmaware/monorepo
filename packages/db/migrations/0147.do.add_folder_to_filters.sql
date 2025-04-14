-- Type: DO
-- Name: update_category_in_filters
-- Description: Update category column in filters table

BEGIN;

ALTER TABLE ruminer.filters ADD COLUMN folder text NOT NULL DEFAULT 'inbox';

COMMIT;
