-- Type: DO
-- Name: webhook_permission
-- Description: webhook table permissions

BEGIN;

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.webhooks TO ruminer_user;

COMMIT;
