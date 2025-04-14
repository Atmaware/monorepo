-- Type: UNDO
-- Name: integrations
-- Description: Create integrations table

BEGIN;

DROP TABLE IF EXISTS ruminer.integrations;

DROP TYPE IF EXISTS ruminer.integration_type CASCADE;

COMMIT;
