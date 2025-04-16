package app.atmaware.ruminer.core.database

import androidx.room.Database
import androidx.room.RoomDatabase
import app.atmaware.ruminer.core.database.dao.HighlightChangesDao
import app.atmaware.ruminer.core.database.dao.HighlightDao
import app.atmaware.ruminer.core.database.dao.SavedItemAndSavedItemLabelCrossRefDao
import app.atmaware.ruminer.core.database.dao.SavedItemDao
import app.atmaware.ruminer.core.database.dao.SavedItemLabelDao
import app.atmaware.ruminer.core.database.dao.SavedItemWithLabelsAndHighlightsDao
import app.atmaware.ruminer.core.database.entities.Highlight
import app.atmaware.ruminer.core.database.entities.HighlightChange
import app.atmaware.ruminer.core.database.entities.SavedItem
import app.atmaware.ruminer.core.database.entities.SavedItemAndHighlightCrossRef
import app.atmaware.ruminer.core.database.entities.SavedItemAndHighlightCrossRefDao
import app.atmaware.ruminer.core.database.entities.SavedItemAndSavedItemLabelCrossRef
import app.atmaware.ruminer.core.database.entities.SavedItemLabel
import app.atmaware.ruminer.core.database.entities.Viewer
import app.atmaware.ruminer.core.database.entities.ViewerDao

@Database(
    entities = [
        Viewer::class,
        SavedItem::class,
        SavedItemLabel::class,
        Highlight::class,
        HighlightChange::class,
        SavedItemAndSavedItemLabelCrossRef::class,
        SavedItemAndHighlightCrossRef::class],
    version = 28,
    exportSchema = true
)
abstract class RuminerDatabase : RoomDatabase() {
    abstract fun viewerDao(): ViewerDao
    abstract fun savedItemDao(): SavedItemDao
    abstract fun highlightDao(): HighlightDao
    abstract fun highlightChangesDao(): HighlightChangesDao
    abstract fun savedItemLabelDao(): SavedItemLabelDao
    abstract fun savedItemWithLabelsAndHighlightsDao(): SavedItemWithLabelsAndHighlightsDao
    abstract fun savedItemAndSavedItemLabelCrossRefDao(): SavedItemAndSavedItemLabelCrossRefDao
    abstract fun savedItemAndHighlightCrossRefDao(): SavedItemAndHighlightCrossRefDao
}
