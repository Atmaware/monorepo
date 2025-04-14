package app.ruminer.ruminer.di

import android.content.Context
import androidx.room.Room
import app.ruminer.ruminer.core.database.RuminerDatabase
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {
    @Provides
    @Singleton
    fun providesRuminerDatabase(
        @ApplicationContext context: Context,
    ): RuminerDatabase = Room.databaseBuilder(
        context,
        RuminerDatabase::class.java,
        "ruminer-database",
    )
    .fallbackToDestructiveMigration()
    .build()
}
