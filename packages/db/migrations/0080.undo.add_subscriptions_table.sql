-- Type: UNDO
-- Name: add_subscriptions_table
-- Description: Add subscriptions table

BEGIN;

DROP TABLE ruminer.subscriptions;
DROP TYPE subscription_status_type;

COMMIT;
