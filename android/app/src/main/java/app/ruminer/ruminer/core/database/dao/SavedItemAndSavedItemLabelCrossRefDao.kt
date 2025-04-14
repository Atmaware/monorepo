package app.ruminer.ruminer.core.database.dao

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import app.ruminer.ruminer.core.database.entities.SavedItemAndSavedItemLabelCrossRef

@Dao
interface SavedItemAndSavedItemLabelCrossRefDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(items: List<SavedItemAndSavedItemLabelCrossRef>)

    @Query("DELETE FROM savedItemAndSavedItemLabelCrossRef WHERE savedItemId = :savedItemId")
    suspend fun deleteRefsBySavedItemId(savedItemId: String)
}
