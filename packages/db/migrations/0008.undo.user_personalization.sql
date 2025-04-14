-- Type: UNDO
-- Name: user_personalization
-- Description: Creates user personalization table

BEGIN;

DROP TRIGGER update_user_personalization_modtime ON ruminer.user_personalization;

DROP TABLE ruminer.user_personalization;

COMMIT;
