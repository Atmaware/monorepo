-- Type: DO
-- Name: reactions
-- Description: Create ruminer.reaction table

BEGIN;

CREATE TABLE ruminer.reaction (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
    highlight_id uuid REFERENCES ruminer.highlight ON DELETE CASCADE,
    user_article_id uuid REFERENCES ruminer.user_articles ON DELETE CASCADE,
    highlight_reply_id uuid REFERENCES ruminer.highlight_reply ON DELETE CASCADE,
    code varchar(50) NOT NULL,
    deleted boolean NOT NULL default false,
    created_at timestamptz NOT NULL default current_timestamp,
    updated_at timestamptz
);

CREATE TRIGGER update_reaction_modtime BEFORE UPDATE ON ruminer.reaction FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

ALTER TABLE ruminer.reaction ENABLE ROW LEVEL SECURITY;

CREATE POLICY read_reaction on ruminer.reaction
  FOR SELECT TO ruminer_user
  USING (true);

CREATE POLICY create_reaction on ruminer.reaction
  FOR INSERT TO ruminer_user
  WITH CHECK (true);

CREATE POLICY update_reaction on ruminer.reaction
  FOR UPDATE TO ruminer_user
  USING (user_id = ruminer.get_current_user_id());

GRANT SELECT, INSERT, UPDATE ON ruminer.reaction TO ruminer_user;

COMMIT;
