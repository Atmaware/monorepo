-- Type: DO
-- Name: add_elastic_page_id
-- Description: Add elastic_page_id to link/page related tables

BEGIN;

ALTER TABLE ruminer.article_saving_request ADD COLUMN elastic_page_id varchar(36);
ALTER TABLE ruminer.reaction ADD COLUMN elastic_page_id varchar(36);
ALTER TABLE ruminer.highlight ADD COLUMN elastic_page_id varchar(36);
ALTER TABLE ruminer.reminders ADD COLUMN elastic_page_id varchar(36);
ALTER TABLE ruminer.abuse_report ADD COLUMN elastic_page_id varchar(36);
ALTER TABLE ruminer.content_display_report ADD COLUMN elastic_page_id varchar(36);
ALTER TABLE ruminer.link_share_info ADD COLUMN elastic_page_id varchar(36);

COMMIT;
