-- Type: DO
-- Name: upgrade_twitter_users
-- Description: Update the SOURCE on twitter users to google

BEGIN;

UPDATE ruminer.user set source = 'GOOGLE' where source = 'TWITTER';

COMMIT;
