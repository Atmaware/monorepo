-- Type: DO
-- Name: users
-- Description: users table

BEGIN;

CREATE ROLE ruminer_user;
CREATE EXTENSION "pgcrypto";
CREATE EXTENSION "uuid-ossp";

CREATE SCHEMA ruminer;

GRANT usage ON SCHEMA ruminer TO ruminer_user;

CREATE OR REPLACE FUNCTION ruminer.set_claims(
	  user_id uuid,
	  user_role text
) RETURNS VOID AS $$
BEGIN
	  EXECUTE format('set local ruminer_user.uid to %I', user_id);
	  EXECUTE format('set local role %I', user_role);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ruminer.get_current_user_id()
RETURNS uuid AS $$
BEGIN
	  RETURN COALESCE(NULLIF(current_setting('ruminer_user.uid', true), '')::uuid, UUID('00000000-0000-0000-0000-000000000000'));
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_updated_at_column()   
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;   
END;
$$ language 'plpgsql';

CREATE TYPE registration_type AS ENUM ('EMAIL', 'GOOGLE', 'TWITTER');

CREATE TABLE ruminer.user (
	  id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
	  first_name text,
	  last_name text,
	  username text NOT NULL,
	  bio text,
	  source registration_type NOT NULL,
	  email text,
	  phone text,
	  picture text,
	  twitter_id text NOT NULL UNIQUE,
	  created_at timestamptz NOT NULL default current_timestamp
);

CREATE TRIGGER update_user_modtime BEFORE UPDATE ON ruminer.user FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

ALTER TABLE ruminer.user ENABLE ROW LEVEL SECURITY;

CREATE POLICY read_user on ruminer.user
  FOR SELECT TO ruminer_user
  USING (true);

CREATE POLICY create_user on ruminer.user
  FOR INSERT TO ruminer_user
  WITH CHECK (true);

CREATE POLICY update_user on ruminer.user
  FOR UPDATE TO ruminer_user
  USING (id = ruminer.get_current_user_id());

GRANT SELECT, INSERT, UPDATE ON ruminer.user TO ruminer_user;


COMMIT;
