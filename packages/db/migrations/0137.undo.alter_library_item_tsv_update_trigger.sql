-- Type: UNDO
-- Name: alter_library_item_tsv_update_trigger
-- Description: Alter library_item_tsv_update trigger on ruminer.library_item table to add conditions

BEGIN;

DROP TRIGGER IF EXISTS library_item_tsv_update ON ruminer.library_item;

CREATE TRIGGER library_item_tsv_update
    BEFORE INSERT OR UPDATE
    ON ruminer.library_item
    FOR EACH ROW
    EXECUTE PROCEDURE update_library_item_tsv();

COMMIT;
