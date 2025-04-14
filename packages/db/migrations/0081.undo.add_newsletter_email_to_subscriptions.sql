-- Type: UNDO
-- Name: add_newsletter_email_to_subscriptions
-- Description: Add newsletter email field to subscriptions table

BEGIN;

ALTER TABLE ruminer.subscriptions DROP COLUMN newsletter_email;

COMMIT;
