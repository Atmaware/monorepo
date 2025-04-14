-- Type: DO
-- Name: rules
-- Description: Create rules table which contains user defines rules and actions

BEGIN;

CREATE TABLE ruminer.rules (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    user_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
    name text NOT NULL,
    description text,
    filter text NOT NULL,
    actions json NOT NULL, -- array of actions of type {type: 'action_type', params: [action_params]}
    enabled boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT current_timestamp,
    updated_at timestamptz NOT NULL DEFAULT current_timestamp,
    UNIQUE (user_id, filter)
);

CREATE TRIGGER rules_modtime BEFORE UPDATE ON ruminer.rules
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

GRANT SELECT, INSERT, UPDATE, DELETE ON ruminer.rules TO ruminer_user;

COMMIT;
