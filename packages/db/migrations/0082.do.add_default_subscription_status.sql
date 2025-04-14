-- Type: DO
-- Name: add_default_subscription_status
-- Description: Add default value to subscription status field

BEGIN;

ALTER TABLE ruminer.subscriptions
    ALTER COLUMN status SET DEFAULT 'ACTIVE';

COMMIT;
