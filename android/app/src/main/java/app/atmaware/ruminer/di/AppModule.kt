package app.atmaware.ruminer.di

import android.content.Context
import app.atmaware.ruminer.core.analytics.EventTracker
import app.atmaware.ruminer.core.data.DataService
import app.atmaware.ruminer.core.database.RuminerDatabase
import app.atmaware.ruminer.core.datastore.DatastoreRepository
import app.atmaware.ruminer.core.datastore.RuminerDatastore
import app.atmaware.ruminer.core.network.Networker
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

  @Singleton
  @Provides
  fun provideDataStoreRepository(
    @ApplicationContext app: Context
  ): DatastoreRepository = RuminerDatastore(app)

  @Singleton
  @Provides
  fun provideNetworker(datastore: DatastoreRepository) = Networker(datastore)

  @Singleton
  @Provides
  fun provideAnalytics(@ApplicationContext app: Context) = EventTracker(app)

  @Singleton
  @Provides
  fun provideDataService(
      networker: Networker,
      ruminerDatabase: RuminerDatabase
  ) = DataService(networker, ruminerDatabase)

}
