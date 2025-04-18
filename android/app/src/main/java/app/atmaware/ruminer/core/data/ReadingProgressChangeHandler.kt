package app.atmaware.ruminer.core.data

import app.atmaware.ruminer.core.data.model.ServerSyncStatus
import app.atmaware.ruminer.core.database.dao.SavedItemDao
import app.atmaware.ruminer.core.network.ReadingProgressParams
import app.atmaware.ruminer.core.network.updateReadingProgress
import com.google.gson.Gson
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

suspend fun DataService.updateWebReadingProgress(
    jsonString: String,
    savedItemDao: SavedItemDao
) {
    val readingProgressParams = Gson().fromJson(jsonString, ReadingProgressParams::class.java)
    val savedItemId = readingProgressParams.id ?: return

    withContext(Dispatchers.IO) {
        val savedItem = savedItemDao.findById(savedItemId) ?: return@withContext
        val updatedItem = savedItem.copy(
            readingProgress = readingProgressParams.readingProgressPercent ?: 0.0,
            readingProgressAnchor = readingProgressParams.readingProgressAnchorIndex ?: 0,
            serverSyncStatus = ServerSyncStatus.NEEDS_UPDATE.rawValue
        )
        savedItemDao.update(updatedItem)

        val isUpdatedOnServer = networker.updateReadingProgress(readingProgressParams)

        if (isUpdatedOnServer) {
            updatedItem.serverSyncStatus = ServerSyncStatus.IS_SYNCED.rawValue
            savedItemDao.update(updatedItem)
        }
    }
}
