-- Type: UNDO
-- Name: add_task_name_to_reminders
-- Description: Add task_name field to reminders table

BEGIN;

ALTER TABLE ruminer.reminders
    DROP COLUMN task_name;

COMMIT;
