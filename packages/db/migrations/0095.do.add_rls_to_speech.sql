-- Type: DO
-- Name: add_rls_to_speech
-- Description: Add Row level security to speech table

BEGIN;

CREATE POLICY update_speech on ruminer.speech
    FOR UPDATE TO ruminer_user
    USING (user_id = ruminer.get_current_user_id());

COMMIT;
