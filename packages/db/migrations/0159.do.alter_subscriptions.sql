-- Type: DO
-- Name: alter_subscriptions
-- Description: Alter ruminer.subscriptions table to add a new state and date column

BEGIN;

ALTER TABLE ruminer.subscriptions
    ADD COLUMN failed_at timestamptz,
    ADD COLUMN refreshed_at timestamptz;
UPDATE ruminer.subscriptions
    SET refreshed_at = last_fetched_at
    WHERE last_fetched_at IS NOT NULL;

ALTER TABLE ruminer.subscriptions
    RENAME COLUMN last_fetched_at TO most_recent_item_date;

COMMIT;
