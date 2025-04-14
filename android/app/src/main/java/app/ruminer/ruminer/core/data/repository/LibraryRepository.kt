package app.ruminer.ruminer.core.data.repository

import android.content.Context
import app.ruminer.ruminer.core.data.SavedItemSyncResult
import app.ruminer.ruminer.core.data.SearchResult
import app.ruminer.ruminer.core.data.model.LibraryQuery
import app.ruminer.ruminer.core.database.entities.HighlightChange
import app.ruminer.ruminer.core.database.entities.SavedItemLabel
import app.ruminer.ruminer.core.database.entities.SavedItemWithLabelsAndHighlights
import app.ruminer.ruminer.core.database.entities.TypeaheadCardData
import kotlinx.coroutines.flow.Flow

interface LibraryRepository  {

    fun getSavedItems(query: LibraryQuery): Flow<List<SavedItemWithLabelsAndHighlights>>

    fun getSavedItemsLabels(): Flow<List<SavedItemLabel>>

    suspend fun getLabels(): List<SavedItemLabel>

    suspend fun fetchSavedItemContent(context: Context, slug: String)

    suspend fun insertAllLabels(labels: List<SavedItemLabel>)

    suspend fun setSavedItemLabels(itemId: String, labels: List<SavedItemLabel>): Boolean

    suspend fun updateReadingProgress(
        itemId: String,
        readingProgressPercentage: Double,
        readingProgressAnchorIndex: Int
    )

    suspend fun createNewSavedItemLabel(labelName: String, hexColorValue: String)

    suspend fun librarySearch(context: Context, cursor: String?, query: String): SearchResult

    suspend fun isSavedItemContentStoredInDB(context: Context, slug: String): Boolean

    suspend fun deleteSavedItem(itemID: String)

    suspend fun archiveSavedItem(itemID: String)

    suspend fun unarchiveSavedItem(itemID: String)

    suspend fun syncOfflineItemsWithServerIfNeeded()

    suspend fun syncHighlightChange(highlightChange: HighlightChange): Boolean

    suspend fun sync(context: Context, since: String, cursor: String?, limit: Int = 20): SavedItemSyncResult

    suspend fun getTypeaheadData(query: String): List<TypeaheadCardData>
}
