-- Type: UNDO
-- Name: add_settings_column_to_integrations
-- Description: Add settings column to integrations table

BEGIN;

ALTER TABLE ruminer.integrations DROP COLUMN settings;

COMMIT;
