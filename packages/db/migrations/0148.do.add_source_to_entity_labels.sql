-- Type: DO
-- Name: add_source_to_entity_labels
-- Description: Add source column to ruminer.entity_labels table

BEGIN;

ALTER TABLE ruminer.entity_labels ADD COLUMN source TEXT NOT NULL DEFAULT 'user';

COMMIT;
