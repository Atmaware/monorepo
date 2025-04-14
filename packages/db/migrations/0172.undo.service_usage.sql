-- Type: UNDO
-- Name: service_usage
-- Description: Create table for tracking service usage and enforce limit

BEGIN;

DROP TABLE IF EXISTS ruminer.service_usage;

DROP TABLE IF EXISTS ruminer.subscription_plan;

ATLER TABLE ruminer.received_emails
    DROP COLUMN IF EXISTS reply_to,
    DROP COLUMN IF EXISTS reply;

COMMIT;
