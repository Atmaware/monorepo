-- Type: DO
-- Name: add_scheduled_at_to_subscription
-- Description: Add scheduled_at field to ruminer.subscriptions table

BEGIN;

ALTER TABLE ruminer.subscriptions ADD COLUMN scheduled_at timestamptz;

COMMIT;
