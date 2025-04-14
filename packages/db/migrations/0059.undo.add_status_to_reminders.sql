-- Type: UNDO
-- Name: add_status_to_reminders
-- Description: Add status, created_at, updated_at fields to the reminders table

BEGIN;

DROP TRIGGER reminders_modtime ON ruminer.reminders;

DROP TYPE reminder_status CASCADE;

ALTER TABLE ruminer.reminders
    DROP COLUMN created_at,
    DROP COLUMN updated_at;

COMMIT;
