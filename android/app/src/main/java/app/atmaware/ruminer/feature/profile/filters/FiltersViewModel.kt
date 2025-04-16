package app.atmaware.ruminer.feature.profile.filters

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import app.atmaware.ruminer.core.datastore.DatastoreRepository
import app.atmaware.ruminer.core.datastore.followingTabActive
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class FiltersViewModel @Inject constructor(
    private val datastoreRepository: DatastoreRepository
) : ViewModel() {

    val followingTabActiveState: StateFlow<Boolean> = datastoreRepository.getBoolean(followingTabActive).stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(),
        initialValue = false
    )

    fun setFollowingTabActiveState(value: Boolean) {
        viewModelScope.launch {
            datastoreRepository.putBoolean(followingTabActive, value)
        }
    }
}
