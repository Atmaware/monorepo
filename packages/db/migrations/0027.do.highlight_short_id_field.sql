-- Type: DO
-- Name: highlight_short_id_field
-- Description: Add short_id field to ruminer.highlight table

BEGIN;

ALTER TABLE ruminer.highlight
    ADD COLUMN short_id varchar(14) NOT NULL DEFAULT 'temp';

-- Assign short_id for existing highlight records
-- short_id has a form of - [1st part of uuid] + [row number in select *]
WITH numbered_highlights AS (
    SELECT id as highlight_id, row_number() over (ORDER BY created_at) AS rn
    FROM ruminer.highlight
)
UPDATE ruminer.highlight
    SET short_id = concat('', split_part(id::text, '-', 1), nh.rn)
FROM numbered_highlights nh
WHERE ruminer.highlight.id = highlight_id;

ALTER TABLE ruminer.highlight
    ALTER COLUMN short_id DROP DEFAULT;

ALTER TABLE ruminer.highlight
    ADD UNIQUE (short_id);

COMMIT;
