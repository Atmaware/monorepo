-- Type: UNDO
-- Name: add_scheduled_at_to_subscription
-- Description: Add scheduled_at field to ruminer.subscriptions table

BEGIN;

ALTER TABLE ruminer.subscriptions DROP COLUMN IF EXISTS scheduled_at;

COMMIT;
