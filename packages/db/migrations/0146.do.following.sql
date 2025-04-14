-- Type: DO
-- Name: following
-- Description: Create tables for following feature

BEGIN;

ALTER TABLE ruminer.subscriptions
    ADD COLUMN is_private boolean,
    ADD COLUMN auto_add_to_library boolean;

ALTER TABLE ruminer.library_item
    ADD COLUMN links jsonb,
    ADD COLUMN preview_content text,
    ADD COLUMN preview_content_type text,
    ADD COLUMN folder text NOT NULL DEFAULT 'inbox';

CREATE POLICY library_item_admin_policy on ruminer.library_item
    FOR ALL
    TO ruminer_admin
    USING (true);

COMMIT;
