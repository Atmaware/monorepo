-- Type: UNDO
-- Name: add_type_to_reminders
-- Description: Add type field to reminders table

BEGIN;

ALTER TABLE ruminer.reminders DROP COLUMN remind_at;

ALTER TYPE reminder_type RENAME TO remind_at;

ALTER TABLE ruminer.reminders RENAME COLUMN type TO remind_at;

COMMIT;
