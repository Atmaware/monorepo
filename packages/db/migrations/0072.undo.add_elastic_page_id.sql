-- Type: UNDO
-- Name: add_elastic_page_id
-- Description: Add elastic_page_id to link/page related tables

BEGIN;

ALTER TABLE ruminer.article_saving_request DROP COLUMN elastic_page_id;
ALTER TABLE ruminer.reaction DROP COLUMN elastic_page_id;
ALTER TABLE ruminer.highlight DROP COLUMN elastic_page_id;
ALTER TABLE ruminer.reminders DROP COLUMN elastic_page_id;
ALTER TABLE ruminer.abuse_report DROP COLUMN elastic_page_id;
ALTER TABLE ruminer.content_display_report DROP COLUMN elastic_page_id;
ALTER TABLE ruminer.link_share_info DROP COLUMN elastic_page_id;

COMMIT;
