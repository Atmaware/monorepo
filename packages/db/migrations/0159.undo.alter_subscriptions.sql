-- Type: UNDO
-- Name: alter_subscriptions
-- Description: Alter ruminer.subscriptions table to add a new state and date column

BEGIN;

ALTER TABLE ruminer.subscriptions
    RENAME COLUMN most_recent_item_date TO last_fetched_at;

ALTER TABLE ruminer.subscriptions
    DROP COLUMN failed_at,
    DROP COLUMN refreshed_at;

COMMIT;
