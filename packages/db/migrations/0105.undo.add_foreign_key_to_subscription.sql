-- Type: UNDO
-- Name: add_foreign_key_to_subscription
-- Description: Add newsletter_email_id as foreign key to the subscription table

BEGIN;

-- remove old column
ALTER TABLE ruminer.subscriptions
    DROP CONSTRAINT subscriptions_user_id_name_key,
    ADD COLUMN newsletter_email text;

-- migrate existing data
UPDATE ruminer.subscriptions
    SET newsletter_email = ruminer.newsletter_emails.address
    FROM ruminer.newsletter_emails
    WHERE ruminer.newsletter_emails.id = ruminer.subscriptions.newsletter_email_id;

ALTER TABLE ruminer.subscriptions
    DROP COLUMN newsletter_email_id;

COMMIT;
