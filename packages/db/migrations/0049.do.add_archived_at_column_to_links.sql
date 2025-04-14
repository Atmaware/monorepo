-- Type: DO
-- Name: add_archived_at_column_to_links
-- Description: Add an archivedAt column to the links model

BEGIN;

ALTER TABLE ruminer.links ADD archived_at timestamp;

COMMIT;
