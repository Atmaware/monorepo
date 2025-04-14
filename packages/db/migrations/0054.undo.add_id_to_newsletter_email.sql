-- Type: UNDO
-- Name: add_id_to_newsletter_email
-- Description: Add id field to newsletter_email table

BEGIN;

ALTER TABLE ruminer.newsletter_emails
    DROP COLUMN id;

ALTER TABLE ruminer.newsletter_emails
    ADD CONSTRAINT newsletter_emails_pkey PRIMARY KEY (address);

COMMIT;
