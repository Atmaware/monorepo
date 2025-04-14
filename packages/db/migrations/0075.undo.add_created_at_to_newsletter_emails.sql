-- Type: UNDO
-- Name: add_created_at_to_newsletter_emails
-- Description: Add created_at and updated_at fields to newsletter_emails table

BEGIN;

ALTER TABLE ruminer.newsletter_emails
    DROP COLUMN created_at,
    DROP COLUMN updated_at;

COMMIT;
