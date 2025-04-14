package app.ruminer.ruminer.core.data

import app.ruminer.ruminer.core.database.RuminerDatabase
import app.ruminer.ruminer.core.database.entities.SavedItem
import app.ruminer.ruminer.core.network.Networker
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.launch
import javax.inject.Inject

class DataService @Inject constructor(
    val networker: Networker,
    ruminerDatabase: RuminerDatabase
) {
    val savedItemSyncChannel = Channel<SavedItem>(capacity = Channel.UNLIMITED)

    val db = ruminerDatabase

    init {
        CoroutineScope(Dispatchers.IO).launch {
            startSyncChannels()
        }
    }

    fun clearDatabase() {
        CoroutineScope(Dispatchers.IO).launch {
            db.clearAllTables()
        }
    }
}
