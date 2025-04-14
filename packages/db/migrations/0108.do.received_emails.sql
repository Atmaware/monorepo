-- Type: DO
-- Name: received_emails
-- Description: Create a table for received emails

BEGIN;

CREATE TABLE ruminer.received_emails (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
    "from" text NOT NULL,
    "to" text NOT NULL,
    subject text NOT NULL DEFAULT '',
    "text" text NOT NULL,
    html text NOT NULL DEFAULT '',
    "type" text NOT NULL,
    created_at timestamptz NOT NULL DEFAULT current_timestamp,
    updated_at timestamptz NOT NULL DEFAULT current_timestamp
);

CREATE TRIGGER received_emails_modtime BEFORE UPDATE ON ruminer.received_emails
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.received_emails TO ruminer_user;

-- Create a trigger to keep the most recent 20 emails for each user
CREATE OR REPLACE FUNCTION ruminer.delete_old_received_emails()
    RETURNS trigger AS $$
    BEGIN
        DELETE FROM ruminer.received_emails
        WHERE id NOT IN (
            SELECT id FROM ruminer.received_emails
            WHERE user_id = NEW.user_id
            ORDER BY created_at DESC
            LIMIT 20
        );
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_old_received_emails
    AFTER INSERT ON ruminer.received_emails
    FOR EACH ROW EXECUTE PROCEDURE ruminer.delete_old_received_emails();

COMMIT;
