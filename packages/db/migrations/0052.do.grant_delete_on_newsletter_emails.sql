-- Type: DO
-- Name: grant_delete_on_newsletter_emails
-- Description: Grant DELETE permission on newsletter_emails table

BEGIN;

GRANT DELETE ON ruminer.newsletter_emails TO ruminer_user;

COMMIT;
