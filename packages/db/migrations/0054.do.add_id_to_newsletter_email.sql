-- Type: DO
-- Name: add_id_to_newsletter_email
-- Description: Add id field to newsletter_email table

BEGIN;

ALTER TABLE ruminer.newsletter_emails
    DROP CONSTRAINT newsletter_emails_pkey;

ALTER TABLE ruminer.newsletter_emails
    ADD COLUMN id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc();

COMMIT;
