-- Type: DO
-- Name: create_abuse_report_table
-- Description: Create a new table for saving abuse reports

BEGIN;

CREATE TYPE report_type AS ENUM ('SPAM', 'ABUSIVE', 'CONTENT_VIOLATION');

CREATE TABLE ruminer.abuse_reports (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  page_id uuid NOT NULL REFERENCES ruminer.article,

  item_url text NOT NULL,
  shared_by uuid NOT NULL REFERENCES ruminer.user(id),

  -- reported_by can be null to allow non-logged in users to submit reports. 
  reported_by uuid REFERENCES ruminer.article,
  report_types report_type[] NOT NULL,
  report_comment text,

  created_at timestamptz NOT NULL DEFAULT current_timestamp,
  updated_at timestamptz NOT NULL DEFAULT current_timestamp
);

CREATE TRIGGER update_abuse_report_modtime BEFORE UPDATE ON ruminer.abuse_reports FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

GRANT SELECT, INSERT ON ruminer.abuse_reports TO ruminer_user;

COMMIT;
