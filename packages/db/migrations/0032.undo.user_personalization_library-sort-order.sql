-- Type: DO
-- Name: user_personalization_library_sort_order
-- Description: Add "library_sort_order" field to the user_personalization table

BEGIN;

ALTER TABLE ruminer.user_personalization
    DROP column library_sort_order;

COMMIT;
