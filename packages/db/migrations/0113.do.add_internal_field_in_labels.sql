-- Type: DO
-- Name: add_internal_field_in_labels
-- Description: Add a new boolean field internal in labels table and set it to true for newsletters and favorites

BEGIN;

ALTER TABLE ruminer.labels ADD COLUMN internal boolean NOT NULL DEFAULT false;

UPDATE ruminer.labels SET internal = true WHERE LOWER(name) = 'newsletters' OR LOWER(name) = 'favorites';

COMMIT;
