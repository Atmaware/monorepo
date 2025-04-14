-- Type: UNDO
-- Name: add_unique_to_subscription_url
-- Description: Add unique constraint to the url field on the ruminer.subscription table

BEGIN;

ALTER TABLE ruminer.subscriptions DROP CONSTRAINT IF EXISTS subscriptions_user_id_url_key;

COMMIT;
