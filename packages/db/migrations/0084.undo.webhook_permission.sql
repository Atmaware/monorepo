-- Type: UNDO
-- Name: webhook_permission
-- Description: webhook table permissions

BEGIN;

REVOKE SELECT, INSERT, UPDATE, DELETE ON ruminer.webhooks FROM ruminer_user;

COMMIT;
