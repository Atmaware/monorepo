package app.ruminer.ruminer.feature.library

import androidx.lifecycle.MutableLiveData
import app.ruminer.ruminer.core.database.entities.SavedItemWithLabelsAndHighlights

interface SavedItemViewModel {

    val actionsMenuItemLiveData: MutableLiveData<SavedItemWithLabelsAndHighlights?>
        get() = MutableLiveData<SavedItemWithLabelsAndHighlights?>(null)

    fun handleSavedItemAction(itemId: String, action: SavedItemAction)
}
