-- Type: UNDO
-- Name: change_type_in_integration
-- Description: Change type field in integration table

BEGIN;

ALTER TABLE ruminer.integrations DROP COLUMN "type";
DROP TYPE ruminer.integration_type;
CREATE TYPE ruminer.integration_type AS ENUM ('READWISE', 'POCKET');
ALTER TABLE ruminer.integrations
    ALTER COLUMN "name" TYPE ruminer.integration_type USING "name"::ruminer.integration_type,
    ADD CONSTRAINT integrations_user_id_type_key UNIQUE (user_id, "name");
ALTER TABLE ruminer.integrations RENAME COLUMN "name" TO "type";

COMMIT;
