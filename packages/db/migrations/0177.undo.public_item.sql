-- Type: UNDO
-- Name: public_item
-- Description: Create a table for public items

BEGIN;

DROP TABLE ruminer.public_item_interactions;
DROP TABLE ruminer.public_item_stats;
DROP TABLE ruminer.public_item;
DROP TABLE ruminer.public_item_source;

ALTER TABLE ruminer.library_item 
    DROP COLUMN seen_at,
    DROP COLUMN digested_at,
    DROP COLUMN topic,
    DROP COLUMN score;

DROP EXTENSION LTREE;

COMMIT;
