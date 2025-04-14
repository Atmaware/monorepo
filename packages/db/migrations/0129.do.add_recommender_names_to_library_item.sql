-- Type: DO
-- Name: add_recommender_names_to_library_item
-- Description: Add recommender names field to library item table

BEGIN;

ALTER TABLE ruminer.library_item ADD COLUMN IF NOT EXISTS recommender_names text[] DEFAULT '{}'::text[];

CREATE OR REPLACE FUNCTION update_library_item_recommenders()
RETURNS trigger AS $$
BEGIN
    -- update library_item recommender names from user and group table name column
    UPDATE ruminer.library_item
    SET recommender_names = array_cat(recommender_names, (
        SELECT array_agg(DISTINCT name)
        FROM (
            SELECT name
            FROM ruminer.user
            WHERE id = NEW.recommender_id
            UNION
            SELECT name
            FROM ruminer.group
            WHERE id = NEW.group_id
        ) AS recommender_names
    ))
    WHERE id = NEW.library_item_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER library_item_recommenders_update
BEFORE INSERT ON ruminer.recommendation
FOR EACH ROW
EXECUTE FUNCTION update_library_item_recommenders();

COMMIT;
