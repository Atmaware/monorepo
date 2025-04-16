package app.atmaware.ruminer.feature.library

import androidx.lifecycle.MutableLiveData
import app.atmaware.ruminer.core.database.entities.SavedItemWithLabelsAndHighlights

interface SavedItemViewModel {

    val actionsMenuItemLiveData: MutableLiveData<SavedItemWithLabelsAndHighlights?>
        get() = MutableLiveData<SavedItemWithLabelsAndHighlights?>(null)

    fun handleSavedItemAction(itemId: String, action: SavedItemAction)
}
