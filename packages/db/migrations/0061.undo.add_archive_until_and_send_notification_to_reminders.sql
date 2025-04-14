-- Type: UNDO
-- Name: add_archive_until_and_send_notification_to_reminders
-- Description: Add an archiveUntil and sendNotification flags to the reminders table

BEGIN;

ALTER TABLE ruminer.reminders
  DROP COLUMN archive_until,
  DROP COLUMN send_notification ;

COMMIT;
