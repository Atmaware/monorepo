package app.atmaware.ruminer.feature.notebook

import androidx.lifecycle.*
import app.atmaware.ruminer.core.data.DataService
import app.atmaware.ruminer.core.data.createNoteHighlight
import app.atmaware.ruminer.graphql.generated.type.UpdateHighlightInput
import app.atmaware.ruminer.core.network.Networker
import app.atmaware.ruminer.core.network.updateHighlight
import app.atmaware.ruminer.core.database.entities.Highlight
import app.atmaware.ruminer.core.database.entities.SavedItemWithLabelsAndHighlights
import com.apollographql.apollo3.api.Optional
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class NotebookViewModel @Inject constructor(
    private val networker: Networker,
    private val dataService: DataService,
) : ViewModel() {
    var highlightUnderEdit: Highlight? = null

    fun getLibraryItemById(savedItemId: String): LiveData<SavedItemWithLabelsAndHighlights> {
        return dataService.db.savedItemDao().getLibraryItemById(savedItemId)
    }

    fun addArticleNote(savedItemId: String, note: String) = viewModelScope.launch(Dispatchers.IO) {
            val savedItem = dataService.db.savedItemDao().getById(savedItemId)
            savedItem?.let { item ->
                val noteHighlight = item.highlights.firstOrNull { it.type == "NOTE" }
                noteHighlight?.let {
                    dataService.db.highlightDao()
                        .updateNote(highlightId = noteHighlight.highlightId, note = note)

                    networker.updateHighlight(
                        input = UpdateHighlightInput(
                            highlightId = noteHighlight.highlightId,
                            annotation = Optional.presentIfNotNull(note),
                        )
                    )
                } ?: run {
                    dataService.createNoteHighlight(savedItemId, note)
                }
            }
        }

    fun updateHighlightNote(highlightId: String, note: String?) =
        viewModelScope.launch(Dispatchers.IO) {
            dataService.db.highlightDao().updateNote(highlightId, note ?: "")
            networker.updateHighlight(
                input = UpdateHighlightInput(
                    highlightId = highlightId,
                    annotation = Optional.presentIfNotNull(note),
                )
            )
        }
}
