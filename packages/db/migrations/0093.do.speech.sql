-- Type: DO
-- Name: speech
-- Description: Add speech table containing text to speech audio_url and speech_marks

BEGIN;

CREATE TABLE ruminer.speech (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
    elastic_page_id TEXT NOT NULL,
    voice text,
    audio_url text NOT NULL,
    speech_marks_url text NOT NULL,
    created_at timestamptz NOT NULL DEFAULT current_timestamp,
    updated_at timestamptz NOT NULL DEFAULT current_timestamp
);

CREATE TRIGGER speech_modtime BEFORE UPDATE ON ruminer.speech FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- No permission to delete on the speech table, only superuser can delete.
GRANT SELECT, INSERT, UPDATE ON ruminer.speech TO ruminer_user;

ALTER TABLE ruminer.user_personalization
    ADD COLUMN speech_voice TEXT,
    ADD COLUMN speech_rate INTEGER,
    ADD COLUMN speech_volume INTEGER;

COMMIT;
