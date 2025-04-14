-- Type: DO
-- Name: create_group_tables
-- Description: Add tables for groups and group memberships

BEGIN;


CREATE TABLE ruminer.group (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  created_by_id uuid NOT NULL REFERENCES ruminer.user(id) ON DELETE CASCADE,

  name text NOT NULL,

  created_at timestamptz NOT NULL DEFAULT current_timestamp,
  updated_at timestamptz NOT NULL DEFAULT current_timestamp
);

CREATE TRIGGER update_group_modtime BEFORE UPDATE ON ruminer.group FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
GRANT SELECT, INSERT ON ruminer.group TO ruminer_user;


CREATE TABLE ruminer.invite (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  group_id uuid NOT NULL REFERENCES ruminer.group(id) ON DELETE CASCADE,
  created_by_id uuid NOT NULL REFERENCES ruminer.user(id) ON DELETE CASCADE,

  code text NOT NULL,
  max_members integer NOT NULL,

  expiration_time timestamptz NOT NULL,

  created_at timestamptz NOT NULL DEFAULT current_timestamp,
  updated_at timestamptz NOT NULL DEFAULT current_timestamp
);

CREATE TRIGGER update_invite_modtime BEFORE UPDATE ON ruminer.invite FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
GRANT SELECT, INSERT ON ruminer.invite TO ruminer_user;


CREATE TABLE ruminer.group_membership (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),

  user_id uuid NOT NULL REFERENCES ruminer.user(id) ON DELETE CASCADE,
  group_id uuid NOT NULL REFERENCES ruminer.group(id) ON DELETE CASCADE,
  invite_id uuid NOT NULL REFERENCES ruminer.invite(id) ON DELETE CASCADE,

  created_at timestamptz NOT NULL DEFAULT current_timestamp,
  updated_at timestamptz NOT NULL DEFAULT current_timestamp
);

CREATE TRIGGER update_group_membership_modtime BEFORE UPDATE ON ruminer.group_membership FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
GRANT SELECT, INSERT ON ruminer.group_membership TO ruminer_user;

COMMIT;
