-- Type: DO
-- Name: highlights
-- Description: Create ruminer.highlight table

BEGIN;

CREATE TABLE ruminer.highlight (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
    article_id uuid NOT NULL REFERENCES ruminer.article ON DELETE CASCADE,
    quote text NOT NULL,
    prefix varchar(5000),
    suffix varchar(5000),
    patch text NOT NULL,
    annotation varchar(400),
    deleted boolean NOT NULL default false,
    created_at timestamptz NOT NULL default current_timestamp,
    updated_at timestamptz,
    shared_at timestamptz
);

CREATE TRIGGER update_highlight_modtime BEFORE UPDATE ON ruminer.highlight FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

ALTER TABLE ruminer.highlight ENABLE ROW LEVEL SECURITY;

CREATE POLICY read_highlight on ruminer.highlight
  FOR SELECT TO ruminer_user
  USING (true);

CREATE POLICY create_highlight on ruminer.highlight
  FOR INSERT TO ruminer_user
  WITH CHECK (true);

CREATE POLICY update_highlight on ruminer.highlight
  FOR UPDATE TO ruminer_user
  USING (user_id = ruminer.get_current_user_id());

GRANT SELECT, INSERT, UPDATE ON ruminer.highlight TO ruminer_user;

COMMIT;
