-- Type: UNDO
-- Name: update_highlights_saved_search
-- Description: Update highlights saved search to use all instead of inbox

BEGIN;

UPDATE ruminer.filters 
  SET filter = 'has:highlights mode:highlights' 
  WHERE name = 'Highlights' 
  AND filter = 'in:all has:highlights mode:highlights' ;

COMMIT;
