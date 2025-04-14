-- Type: UNDO
-- Name: users
-- Description: users table

BEGIN;

DROP POLICY read_user on ruminer.user;
DROP POLICY create_user on ruminer.user;
DROP POLICY update_user on ruminer.user;

DROP TRIGGER update_user_modtime ON ruminer.user;

REVOKE ALL PRIVILEGES on SCHEMA ruminer from ruminer_user;
REVOKE ALL PRIVILEGES on ruminer.user from ruminer_user;

DROP FUNCTION ruminer.set_claims(uuid,text);
DROP FUNCTION ruminer.get_current_user_id();

DROP TABLE ruminer.user;
DROP TYPE registration_type;

DROP SCHEMA ruminer CASCADE;
DROP ROLE ruminer_user;
DROP EXTENSION "pgcrypto";
DROP EXTENSION "uuid-ossp" CASCADE;

COMMIT;
