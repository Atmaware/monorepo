-- Type: DO
-- Name: create_link_share_info_table
-- Description: Create the link_share_info table which is used for customizing the title and description of a shared link

BEGIN;

-- Create the link_share_info table in the ruminer schema, 
-- it has a title and description fields and forign key to
-- the links table.
CREATE TABLE ruminer.link_share_info (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    link_id uuid UNIQUE NOT NULL REFERENCES ruminer.links(id) ON DELETE CASCADE,

    created_at timestamptz NOT NULL DEFAULT current_timestamp,
    updated_at timestamptz NOT NULL DEFAULT current_timestamp
);

CREATE TRIGGER update_link_share_info_modtime BEFORE UPDATE ON ruminer.link_share_info FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

GRANT SELECT, INSERT, UPDATE ON ruminer.link_share_info TO ruminer_user;

COMMIT;