-- Type: DO
-- Name: remove_default_folder_in_subscription
-- Description: Remove default value of folder column in subscriptions and newsletter_emails tables

BEGIN;

-- Drop the column first because we can't remove the default value of an existing column
ALTER TABLE ruminer.subscriptions DROP COLUMN folder;
ALTER TABLE ruminer.newsletter_emails DROP COLUMN folder;

ALTER TABLE ruminer.subscriptions ADD COLUMN folder TEXT;
ALTER TABLE ruminer.newsletter_emails ADD COLUMN folder TEXT;

COMMIT;
