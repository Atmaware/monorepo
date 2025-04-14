-- Type: UNDO
-- Name: update_labels_table
-- Description: Update labels table and create link_labels table

BEGIN;

ALTER TABLE ruminer.labels
    ADD COLUMN link_id uuid REFERENCES ruminer.links ON DELETE CASCADE,
    DROP COLUMN color,
    DROP COLUMN description,
    DROP CONSTRAINT label_name_unique;

DROP TABLE ruminer.link_labels;

COMMIT;
