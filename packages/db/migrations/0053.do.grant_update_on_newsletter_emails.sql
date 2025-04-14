-- Type: DO
-- Name: grant_update_on_newsletter_emails
-- Description: Grant update permission on newsletter_emails table

BEGIN;

GRANT UPDATE ON ruminer.newsletter_emails TO ruminer_user;

COMMIT;
