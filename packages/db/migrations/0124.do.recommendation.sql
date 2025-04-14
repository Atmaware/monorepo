-- Type: DO
-- Name: recommendation
-- Description: Create recommendation table

BEGIN;

CREATE TABLE ruminer.recommendation (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    library_item_id uuid NOT NULL REFERENCES ruminer.library_item ON DELETE CASCADE,
    recommender_id uuid NOT NULL REFERENCES ruminer.user ON DELETE CASCADE,
    group_id uuid NOT NULL REFERENCES ruminer.group ON DELETE CASCADE,
    note text,
    created_at timestamptz NOT NULL DEFAULT current_timestamp,
    UNIQUE (library_item_id, recommender_id, group_id)
);

GRANT SELECT, INSERT ON ruminer.recommendation TO ruminer_user;

COMMIT;
