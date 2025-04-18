package com.yangdai.opennote.service

import android.app.Service
import android.content.Intent
import android.os.FileObserver
import android.os.IBinder
import com.yangdai.opennote.domain.usecase.AddNote
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.launch
import java.io.File
import javax.inject.Inject

interface MonitoredDirectoriesRepository {
    val monitoredDirectories: Flow<Set<String>>
    suspend fun addMonitoredDirectory(path: String)
    suspend fun removeMonitoredDirectory(path: String)
}

@AndroidEntryPoint
class DirectoryMonitorService : Service() {
    @Inject
    lateinit var monitoredDirectoriesRepository: MonitoredDirectoriesRepository
    
    @Inject
    lateinit var addNote: AddNote

    private val serviceScope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    private val observers = mutableMapOf<String, FileObserver>()

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        startMonitoring()
    }

    private fun startMonitoring() {
        serviceScope.launch {
            monitoredDirectoriesRepository.monitoredDirectories.collect { directories ->
                // Remove observers for directories that are no longer monitored
                observers.keys.toSet().forEach { path ->
                    if (path !in directories) {
                        observers.remove(path)?.stopWatching()
                    }
                }

                // Add observers for new directories
                directories.forEach { path ->
                    if (path !in observers.keys) {
                        val observer = createObserver(path)
                        observers[path] = observer
                        observer.startWatching()
                    }
                }
            }
        }
    }

    private fun createObserver(path: String): FileObserver {
        return object : FileObserver(File(path), CREATE) {
            override fun onEvent(event: Int, filePath: String?) {
                if (filePath == null) return
                
                val file = File(path, filePath)
                if (!file.isFile) return

                serviceScope.launch {
                    val title = file.nameWithoutExtension
                    val timestamp = System.currentTimeMillis()
                    
                    addNote(
                        title = title,
                        content = "Source: ${file.absolutePath}",
                        folderId = null,
                        isMarkdown = true,
                        timestamp = timestamp
                    )
                }
            }
        }
    }

    override fun onDestroy() {
        observers.values.forEach { it.stopWatching() }
        observers.clear()
        super.onDestroy()
    }
}
