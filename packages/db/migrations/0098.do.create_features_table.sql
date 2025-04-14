-- Type: DO
-- Name: create_features_table
-- Description: Create features table to store opt-in features by users

BEGIN;

CREATE TABLE IF NOT EXISTS ruminer.features (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
    name text NOT NULL,
    granted_at timestamptz,
    expires_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT current_timestamp,
    updated_at timestamptz NOT NULL DEFAULT current_timestamp,
    UNIQUE (user_id, name)
);

CREATE TRIGGER features_modtime BEFORE UPDATE ON ruminer.features
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.features TO ruminer_user;

ALTER TABLE ruminer.user_personalization
    ADD COLUMN IF NOT EXISTS speech_secondary_voice text,
    ALTER COLUMN speech_rate TYPE text,
    ALTER COLUMN speech_volume TYPE text;

COMMIT;
