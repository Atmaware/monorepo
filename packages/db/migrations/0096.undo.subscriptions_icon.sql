-- Type: UNDO
-- Name: subscriptions_icon
-- Description: Add icon field to subscriptions table

BEGIN;

ALTER TABLE ruminer.subscriptions DROP COLUMN IF EXISTS icon;

COMMIT;
