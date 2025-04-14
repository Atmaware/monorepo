-- Type: DO
-- Name: newsletter_emails
-- Description: newsletter_emails model

BEGIN;

CREATE TABLE ruminer.newsletter_emails (
    address varchar(50) PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
    confirmation_code varchar(50)
);

ALTER TABLE ruminer.newsletter_emails ENABLE ROW LEVEL SECURITY;

CREATE POLICY read_newsletter_emails on ruminer.newsletter_emails
  FOR SELECT TO ruminer_user
  USING (true);

CREATE POLICY create_newsletter_emails on ruminer.newsletter_emails
  FOR INSERT TO ruminer_user
  WITH CHECK (true);

GRANT SELECT, INSERT ON ruminer.newsletter_emails TO ruminer_user;

COMMIT;
