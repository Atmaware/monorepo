-- Type: DO
-- Name: add_unique_to_subscription_url
-- Description: Add unique constraint to the url field on the ruminer.subscription table

BEGIN;

-- Deleting duplicates first to avoid unique constraint violation
WITH DuplicateCTE AS (
    SELECT id, ROW_NUMBER() OVER (PARTITION BY user_id, url ORDER BY status, last_fetched_at DESC NULLS LAST) AS row_number
    FROM ruminer.subscriptions
    WHERE type = 'RSS'
)
DELETE FROM ruminer.subscriptions
    WHERE id IN (SELECT id FROM DuplicateCTE WHERE row_number > 1);

ALTER TABLE ruminer.subscriptions ADD CONSTRAINT subscriptions_user_id_url_key UNIQUE (user_id, url);

COMMIT;
