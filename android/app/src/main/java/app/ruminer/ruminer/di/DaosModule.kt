package app.ruminer.ruminer.di

import app.ruminer.ruminer.core.database.RuminerDatabase
import app.ruminer.ruminer.core.database.dao.HighlightChangesDao
import app.ruminer.ruminer.core.database.dao.HighlightDao
import app.ruminer.ruminer.core.database.dao.SavedItemAndSavedItemLabelCrossRefDao
import app.ruminer.ruminer.core.database.dao.SavedItemDao
import app.ruminer.ruminer.core.database.dao.SavedItemLabelDao
import app.ruminer.ruminer.core.database.dao.SavedItemWithLabelsAndHighlightsDao
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent

@Module
@InstallIn(SingletonComponent::class)
object DaosModule {

    @Provides
    fun providesSavedItemDao(
        database: RuminerDatabase,
    ): SavedItemDao = database.savedItemDao()

    @Provides
    fun providesSavedItemLabelDao(
        database: RuminerDatabase,
    ): SavedItemLabelDao = database.savedItemLabelDao()

    @Provides
    fun providesHighlightDao(
        database: RuminerDatabase,
    ): HighlightDao = database.highlightDao()

    @Provides
    fun providesHighlightChangesDao(
        database: RuminerDatabase,
    ): HighlightChangesDao = database.highlightChangesDao()

    @Provides
    fun providesSavedItemWithLabelsAndHighlightsDao(
        database: RuminerDatabase,
    ): SavedItemWithLabelsAndHighlightsDao = database.savedItemWithLabelsAndHighlightsDao()

    @Provides
    fun providesSavedItemAndSavedItemLabelCrossRefDao(
        database: RuminerDatabase,
    ): SavedItemAndSavedItemLabelCrossRefDao = database.savedItemAndSavedItemLabelCrossRefDao()
}
