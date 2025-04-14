-- Type: DO
-- Name: add_subscriptions_table
-- Description: Add subscriptions table

BEGIN;

CREATE TYPE subscription_status_type AS ENUM ('ACTIVE', 'UNSUBSCRIBED', 'DELETED');

CREATE TABLE ruminer.subscriptions (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    user_id uuid NOT NULL REFERENCES ruminer.user (id) ON DELETE CASCADE,
    name text NOT NULL,
    description text,
    url text,
    status subscription_status_type NOT NULL,
    unsubscribe_mail_to text,
    unsubscribe_http_url text,
    created_at timestamptz NOT NULL DEFAULT current_timestamp,
    updated_at timestamptz NOT NULL DEFAULT current_timestamp
);

CREATE TRIGGER update_subscription_modtime BEFORE UPDATE ON ruminer.subscriptions
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

GRANT SELECT, INSERT, UPDATE ON ruminer.subscriptions TO ruminer_user;

COMMIT;
