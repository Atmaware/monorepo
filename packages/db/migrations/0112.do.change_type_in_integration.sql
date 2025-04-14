-- Type: DO
-- Name: change_type_in_integration
-- Description: Change type field in integration table

BEGIN;

ALTER TABLE ruminer.integrations RENAME COLUMN "type" TO "name";
ALTER TABLE ruminer.integrations
    DROP CONSTRAINT integrations_user_id_type_key,
    ALTER COLUMN "name" TYPE VARCHAR(40) USING "name"::VARCHAR(40);
DROP TYPE ruminer.integration_type;
CREATE TYPE ruminer.integration_type AS ENUM ('EXPORT', 'IMPORT');
ALTER TABLE ruminer.integrations
    ADD COLUMN "type" ruminer.integration_type NOT NULL DEFAULT 'EXPORT';

COMMIT;
