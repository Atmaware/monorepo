-- Type: DO
-- Name: add_foreign_key_to_subscription
-- Description: Add newsletter_email_id as foreign key to the subscription table

BEGIN;

ALTER TABLE ruminer.subscriptions
    ADD CONSTRAINT subscriptions_user_id_name_key UNIQUE (user_id, name),
    ADD COLUMN newsletter_email_id uuid REFERENCES ruminer.newsletter_emails(id);

-- migrate existing data
UPDATE ruminer.subscriptions
    SET newsletter_email_id = ruminer.newsletter_emails.id
    FROM ruminer.newsletter_emails
    WHERE ruminer.newsletter_emails.address = ruminer.subscriptions.newsletter_email;

-- remove old column
ALTER TABLE ruminer.subscriptions
    DROP COLUMN newsletter_email;

COMMIT;
