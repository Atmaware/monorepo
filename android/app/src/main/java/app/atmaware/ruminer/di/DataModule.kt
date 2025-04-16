package app.atmaware.ruminer.di

import app.atmaware.ruminer.core.data.repository.LibraryRepository
import app.atmaware.ruminer.core.data.repository.impl.LibraryRepositoryImpl
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent

@Module
@InstallIn(SingletonComponent::class)
interface DataModule {

    @Binds
    fun bindsLibraryRepository(
        libraryRepository: LibraryRepositoryImpl,
    ): LibraryRepository
}
