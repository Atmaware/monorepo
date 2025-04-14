-- Type: DO
-- Name: add_fetch_content_to_subscriptions
-- Description: Add fetch_content column to subscriptions tables

BEGIN;

ALTER TABLE ruminer.subscriptions
    ADD COLUMN fetch_content BOOLEAN NOT NULL DEFAULT TRUE,
    ADD COLUMN folder TEXT NOT NULL DEFAULT 'following';

ALTER TABLE ruminer.newsletter_emails
    ADD COLUMN name TEXT,
    ADD COLUMN description TEXT,
    ADD COLUMN folder TEXT NOT NULL DEFAULT 'inbox';

COMMIT;
