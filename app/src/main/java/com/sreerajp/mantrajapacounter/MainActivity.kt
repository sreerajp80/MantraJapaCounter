package com.sreerajp.mantrajapacounter

import android.content.Context
import android.content.SharedPreferences
import android.os.Bundle
import android.speech.tts.TextToSpeech
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.sreerajp.mantrajapacounter.ui.theme.MantraJapaCounterTheme
import com.sreerajp.mantrajapacounter.screens.CounterListScreen
import com.sreerajp.mantrajapacounter.screens.CountingScreen
import com.sreerajp.mantrajapacounter.screens.HistoryScreen
import com.sreerajp.mantrajapacounter.screens.AboutScreen
import com.sreerajp.mantrajapacounter.data.*
import com.sreerajp.mantrajapacounter.database.*
import com.sreerajp.mantrajapacounter.utils.FileUtils
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.*

enum class Screen {
    COUNTER_LIST, COUNTING, HISTORY, ABOUT
}

data class ActiveSession(
    val counterId: String,
    val counterName: String,
    val currentTapCount: Int,
    val sessionTotalTaps: Int,
    val startTime: Long,
    val sessionId: String = UUID.randomUUID().toString()
)

class MainActivity : ComponentActivity(), TextToSpeech.OnInitListener {
    private lateinit var textToSpeech: TextToSpeech
    private var ttsInitialized = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        textToSpeech = TextToSpeech(this, this)

        setContent {
            MantraJapaCounterTheme {
                MantraCounterApp()
            }
        }
    }

    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            ttsInitialized = true
            textToSpeech.language = Locale.getDefault()
        }
    }

    override fun onDestroy() {
        textToSpeech.shutdown()
        super.onDestroy()
    }
}

// Import/Export handler composable
@Composable
fun rememberImportExportHandlers(
    context: Context,
    repository: JapaCounterRepository,
    onImportSuccess: () -> Unit,
    onImportError: (String) -> Unit,
    onExportSuccess: () -> Unit,
    onExportError: (String) -> Unit
): Pair<() -> Unit, () -> Unit> {
    val coroutineScope = rememberCoroutineScope()

    // Export launcher
    val exportLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.CreateDocument("application/json")
    ) { uri ->
        if (uri != null) {
            coroutineScope.launch {
                try {
                    val exportData = repository.exportData()
                    val jsonContent = FileUtils.exportDataToJson(exportData)
                    val success = FileUtils.writeToUri(context, uri, jsonContent)

                    if (success) {
                        onExportSuccess()
                    } else {
                        onExportError("Failed to write export file")
                    }
                } catch (e: Exception) {
                    onExportError("Export error: ${e.message}")
                }
            }
        }
    }

    // Import launcher
    val importLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.OpenDocument()
    ) { uri ->
        if (uri != null) {
            coroutineScope.launch {
                try {
                    val jsonContent = FileUtils.readFromUri(context, uri)
                    if (jsonContent != null) {
                        val importData = FileUtils.importDataFromJson(jsonContent)
                        if (importData != null) {
                            repository.importData(importData)
                            onImportSuccess()
                        } else {
                            onImportError("Invalid import file format")
                        }
                    } else {
                        onImportError("Failed to read import file")
                    }
                } catch (e: Exception) {
                    onImportError("Import error: ${e.message}")
                }
            }
        }
    }

    val startExport = {
        exportLauncher.launch(FileUtils.createExportFilename())
    }

    val startImport = {
        importLauncher.launch(arrayOf("application/json"))
    }

    return Pair(startExport, startImport)
}

@Composable
fun MantraCounterApp() {
    val context = LocalContext.current
    val repository = remember { JapaCounterRepository(context) }
    val prefs = remember { context.getSharedPreferences("japa_counter", Context.MODE_PRIVATE) }
    val coroutineScope = rememberCoroutineScope()

    var currentScreen by remember { mutableStateOf(Screen.COUNTER_LIST) }
    var previousScreen by remember { mutableStateOf(Screen.COUNTER_LIST) }
    var selectedCounter by remember { mutableStateOf<Counter?>(null) }
    var currentTapCount by remember { mutableStateOf(0) }
    var sessionTotalTaps by remember { mutableStateOf(0) }
    var startTime by remember { mutableStateOf(0L) }
    var elapsedTime by remember { mutableStateOf(0L) }
    var currentSessionId by remember { mutableStateOf<String?>(null) }

    // Collect data from database
    val counters by repository.getAllCounters().collectAsState(initial = emptyList())
    val sessions by repository.getAllSessions().collectAsState(initial = emptyList())

    // State for tracking today's counts and total counts
    var todayCountsMap by remember { mutableStateOf<Map<String, Int>>(emptyMap()) }
    var totalCountsMap by remember { mutableStateOf<Map<String, Int>>(emptyMap()) }

    // Import/Export dialog and message states
    var showImportExportDialog by remember { mutableStateOf(false) }
    var importExportMessage by remember { mutableStateOf<String?>(null) }

    // Create import/export handlers
    val (startExport, startImport) = rememberImportExportHandlers(
        context = context,
        repository = repository,
        onImportSuccess = {
            importExportMessage = "Data imported successfully!"
            currentScreen = Screen.COUNTER_LIST
            clearActiveSession(prefs)
            currentSessionId = null
            selectedCounter = null
        },
        onImportError = { error ->
            importExportMessage = "Import failed: $error"
        },
        onExportSuccess = {
            importExportMessage = "Data exported successfully!"
        },
        onExportError = { error ->
            importExportMessage = "Export failed: $error"
        }
    )

    // Perform migration on first launch
    LaunchedEffect(Unit) {
        val migrationHelper = DatabaseMigrationHelper(context, repository)
        migrationHelper.migrateFromSharedPreferences()

        // Load active session if exists
        loadActiveSession(prefs)?.let { activeSession ->
            selectedCounter = repository.getCounterById(activeSession.counterId)
            if (selectedCounter != null) {
                currentTapCount = activeSession.currentTapCount
                sessionTotalTaps = activeSession.sessionTotalTaps
                startTime = activeSession.startTime
                currentSessionId = activeSession.sessionId
                currentScreen = Screen.COUNTING
            } else {
                clearActiveSession(prefs)
            }
        }
    }

    // Update count maps when sessions or counters change
    LaunchedEffect(sessions, counters) {
        coroutineScope.launch {
            val todayMap = mutableMapOf<String, Int>()
            val totalMap = mutableMapOf<String, Int>()

            counters.forEach { counter ->
                todayMap[counter.id] = repository.getTodayCountForCounter(counter.id)
                totalMap[counter.id] = repository.getTotalCountForCounter(counter.id)
            }

            todayCountsMap = todayMap
            totalCountsMap = totalMap
        }
    }

    // Timer effect for elapsed time
    LaunchedEffect(currentScreen, startTime) {
        if (currentScreen == Screen.COUNTING && startTime > 0) {
            while (currentScreen == Screen.COUNTING) {
                kotlinx.coroutines.delay(1000)
                elapsedTime = System.currentTimeMillis() - startTime

                // Update session in database every 10 seconds if it exists
                if (currentSessionId != null && sessionTotalTaps > 0) {
                    val existingSession = sessions.find { it.id == currentSessionId }
                    if (existingSession != null) {
                        coroutineScope.launch {
                            repository.updateSession(
                                existingSession.copy(
                                    count = sessionTotalTaps,
                                    malas = sessionTotalTaps / 108,
                                    chants = sessionTotalTaps,
                                    duration = elapsedTime
                                )
                            )
                        }
                    }
                }
            }
        }
    }

    // Save active session whenever important state changes
    LaunchedEffect(selectedCounter, currentTapCount, sessionTotalTaps, startTime, currentSessionId) {
        if (selectedCounter != null && currentSessionId != null) {
            val activeSession = ActiveSession(
                counterId = selectedCounter!!.id,
                counterName = selectedCounter!!.name,
                currentTapCount = currentTapCount,
                sessionTotalTaps = sessionTotalTaps,
                startTime = startTime,
                sessionId = currentSessionId!!
            )
            saveActiveSession(prefs, activeSession)
        }
    }

    // Calculate total counts for display
    fun getTotalCountForCounter(counter: Counter): Int {
        val historicalTotal = totalCountsMap[counter.id] ?: 0
        return counter.initialCount + historicalTotal
    }

    fun getTodayCountForCounter(counter: Counter): Int {
        return todayCountsMap[counter.id] ?: 0
    }

    // Function to create session in database
    fun createSessionInDatabase() {
        if (selectedCounter != null && currentSessionId != null) {
            val session = JapaSession(
                id = currentSessionId!!,
                counterId = selectedCounter!!.id,
                counterName = selectedCounter!!.name,
                count = sessionTotalTaps,
                malas = sessionTotalTaps / 108,
                chants = sessionTotalTaps,
                duration = elapsedTime,
                timestamp = startTime
            )

            coroutineScope.launch {
                repository.insertSession(session)
            }
        }
    }

    // Function to update existing session
    fun updateCurrentSessionInDatabase() {
        if (currentSessionId != null && sessionTotalTaps > 0) {
            val existingSession = sessions.find { it.id == currentSessionId }
            if (existingSession != null) {
                coroutineScope.launch {
                    repository.updateSession(
                        existingSession.copy(
                            count = sessionTotalTaps,
                            malas = sessionTotalTaps / 108,
                            chants = sessionTotalTaps,
                            duration = elapsedTime
                        )
                    )
                }
            }
        }
    }

    // Function to finalize session
    fun finalizeSession() {
        updateCurrentSessionInDatabase()
        clearActiveSession(prefs)
        currentSessionId = null
    }

    // Function to cancel/reset session
    fun cancelSession() {
        if (currentSessionId != null) {
            val sessionToDelete = sessions.find { it.id == currentSessionId }
            if (sessionToDelete != null) {
                coroutineScope.launch {
                    repository.deleteSession(sessionToDelete)
                }
            }
        }
        clearActiveSession(prefs)
        currentSessionId = null
    }

    fun resetCounter() {
        if (selectedCounter != null) {
            coroutineScope.launch {
                repository.deleteSessionsByCounterId(selectedCounter!!.id)
            }
            clearActiveSession(prefs)
            currentSessionId = null
            currentTapCount = 0
            sessionTotalTaps = 0
            startTime = System.currentTimeMillis()
            elapsedTime = 0L
            currentSessionId = UUID.randomUUID().toString()
        }
    }

    fun deleteSession(sessionToDelete: JapaSession) {
        if (sessionToDelete.id == currentSessionId) {
            return
        }
        coroutineScope.launch {
            repository.deleteSession(sessionToDelete)
        }
    }

    when (currentScreen) {
        Screen.COUNTER_LIST -> {
            CounterListScreen(
                counters = counters,
                getTotalCount = { counter -> getTotalCountForCounter(counter) },
                getTotalMalas = { counter -> getTotalCountForCounter(counter) / 108 },
                getTodayCount = { counter -> getTodayCountForCounter(counter) },
                onSelectCounter = { counter ->
                    selectedCounter = counter
                    currentTapCount = 0
                    sessionTotalTaps = 0
                    startTime = System.currentTimeMillis()
                    elapsedTime = 0L
                    currentSessionId = UUID.randomUUID().toString()
                    previousScreen = Screen.COUNTER_LIST
                    currentScreen = Screen.COUNTING
                },
                onAddCounter = { name, initialCount, incrementStep, goal, dailyGoal ->
                    val newCounter = Counter(
                        name = name,
                        initialCount = initialCount,
                        incrementStep = maxOf(1, incrementStep),
                        goal = goal,
                        dailyGoal = dailyGoal
                    )
                    coroutineScope.launch {
                        repository.insertCounter(newCounter)
                    }
                },
                onEditCounter = { counter, name, initialCount, incrementStep, goal, dailyGoal ->
                    val updatedCounter = counter.copy(
                        name = name,
                        initialCount = initialCount,
                        incrementStep = maxOf(1, incrementStep),
                        goal = goal,
                        dailyGoal = dailyGoal
                    )
                    coroutineScope.launch {
                        repository.updateCounter(updatedCounter)
                    }
                },
                onDeleteCounter = { counter ->
                    coroutineScope.launch {
                        repository.deleteCounter(counter)
                        repository.deleteSessionsByCounterId(counter.id)
                    }
                    loadActiveSession(prefs)?.let { activeSession ->
                        if (activeSession.counterId == counter.id) {
                            clearActiveSession(prefs)
                        }
                    }
                },
                onShowHistory = { counterId ->
                    selectedCounter = if (counterId != null) {
                        counters.find { it.id == counterId }
                    } else {
                        null
                    }
                    previousScreen = Screen.COUNTER_LIST
                    currentScreen = Screen.HISTORY
                },
                onShowAbout = {
                    previousScreen = Screen.COUNTER_LIST
                    currentScreen = Screen.ABOUT
                },
                onShowImportExport = {
                    showImportExportDialog = true
                }
            )
        }
        Screen.COUNTING -> {
            CountingScreen(
                counter = selectedCounter,
                currentTapCount = currentTapCount,
                sessionTotalTaps = sessionTotalTaps,
                elapsedTime = elapsedTime,
                lifetimeTotal = selectedCounter?.let { getTotalCountForCounter(it) } ?: 0,
                todayTotal = selectedCounter?.let { getTodayCountForCounter(it) } ?: 0,
                onCountClick = {
                    val step = maxOf(1, selectedCounter?.incrementStep ?: 1)
                    val wasZero = sessionTotalTaps == 0

                    currentTapCount += step
                    sessionTotalTaps += step

                    if (currentTapCount >= 108) {
                        currentTapCount = currentTapCount % 108
                    }

                    if (wasZero) {
                        createSessionInDatabase()
                    } else {
                        updateCurrentSessionInDatabase()
                    }
                },
                onDecrementClick = {
                    val step = maxOf(1, selectedCounter?.incrementStep ?: 1)
                    if (sessionTotalTaps >= step) {
                        sessionTotalTaps -= step
                        if (currentTapCount >= step) {
                            currentTapCount -= step
                        } else {
                            currentTapCount = 108 - (step - currentTapCount)
                        }

                        if (sessionTotalTaps > 0) {
                            updateCurrentSessionInDatabase()
                        } else {
                            cancelSession()
                        }
                    }
                },
                onBack = {
                    finalizeSession()
                    selectedCounter = null
                    currentScreen = Screen.COUNTER_LIST
                },
                onShowHistory = { counterId ->
                    previousScreen = Screen.COUNTING
                    currentScreen = Screen.HISTORY
                },
                onShowAbout = {
                    previousScreen = Screen.COUNTING
                    currentScreen = Screen.ABOUT
                },
                onReset = {
                    cancelSession()
                    currentTapCount = 0
                    sessionTotalTaps = 0
                    startTime = System.currentTimeMillis()
                    elapsedTime = 0L
                    currentSessionId = UUID.randomUUID().toString()
                },
                onResetCounter = {
                    resetCounter()
                }
            )
        }
        Screen.HISTORY -> {
            HistoryScreen(
                sessions = sessions,
                selectedCounterId = selectedCounter?.id,
                onBack = {
                    currentScreen = previousScreen
                },
                onClearHistory = { counterId ->
                    coroutineScope.launch {
                        if (counterId != null) {
                            val sessionsToDelete = sessions.filter {
                                it.counterId == counterId && it.id != currentSessionId
                            }
                            sessionsToDelete.forEach { session ->
                                repository.deleteSession(session)
                            }
                        } else {
                            val currentSession = sessions.find { it.id == currentSessionId }
                            sessions.forEach { session ->
                                if (session.id != currentSessionId) {
                                    repository.deleteSession(session)
                                }
                            }
                        }
                    }
                },
                onDeleteSession = { session ->
                    deleteSession(session)
                }
            )
        }
        Screen.ABOUT -> {
            AboutScreen(
                onBack = {
                    currentScreen = previousScreen
                }
            )
        }
    }

    // Import/Export Dialog
    if (showImportExportDialog) {
        AlertDialog(
            onDismissRequest = { showImportExportDialog = false },
            title = { Text("Import/Export Data") },
            text = {
                Column(
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Text("Choose an option:")
                    Text(
                        "• Export: Save all counters and history to a file",
                        fontSize = 14.sp,
                        color = Color.Gray
                    )
                    Text(
                        "• Import: Replace all data with data from a file",
                        fontSize = 14.sp,
                        color = Color.Gray
                    )

                    Spacer(modifier = Modifier.height(8.dp))

                    Card(
                        colors = CardDefaults.cardColors(
                            containerColor = MaterialTheme.colorScheme.errorContainer.copy(alpha = 0.3f)
                        ),
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text(
                            text = "⚠️ Warning: Import will replace all existing data!",
                            modifier = Modifier.padding(12.dp),
                            color = MaterialTheme.colorScheme.error,
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Medium
                        )
                    }
                }
            },
            confirmButton = {
                Row(
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    TextButton(onClick = {
                        showImportExportDialog = false
                        startExport()
                    }) {
                        Icon(
                            imageVector = Icons.Default.Upload,
                            contentDescription = null,
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Text("Export")
                    }
                    TextButton(onClick = {
                        showImportExportDialog = false
                        startImport()
                    }) {
                        Icon(
                            imageVector = Icons.Default.Download,
                            contentDescription = null,
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Text("Import")
                    }
                }
            },
            dismissButton = {
                TextButton(onClick = { showImportExportDialog = false }) {
                    Text("Cancel")
                }
            }
        )
    }

    // Show import/export result message
    importExportMessage?.let { message ->
        AlertDialog(
            onDismissRequest = { importExportMessage = null },
            title = {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Icon(
                        imageVector = if (message.contains("failed")) Icons.Default.Error else Icons.Default.CheckCircle,
                        contentDescription = null,
                        tint = if (message.contains("failed")) MaterialTheme.colorScheme.error else Color(0xFF4CAF50)
                    )
                    Text("Import/Export")
                }
            },
            text = { Text(message) },
            confirmButton = {
                TextButton(onClick = { importExportMessage = null }) {
                    Text("OK")
                }
            }
        )
    }
}

// Active session persistence functions
fun saveActiveSession(prefs: SharedPreferences, activeSession: ActiveSession) {
    val gson = Gson()
    val json = gson.toJson(activeSession)
    prefs.edit().putString("active_session", json).apply()
}

fun loadActiveSession(prefs: SharedPreferences): ActiveSession? {
    val gson = Gson()
    val json = prefs.getString("active_session", null)
    return if (json != null) {
        try {
            gson.fromJson(json, ActiveSession::class.java)
        } catch (e: Exception) {
            null
        }
    } else {
        null
    }
}

fun clearActiveSession(prefs: SharedPreferences) {
    prefs.edit().remove("active_session").apply()
}

// Utility functions
fun formatTime(milliseconds: Long): String {
    val totalSeconds = milliseconds / 1000
    val hours = totalSeconds / 3600
    val minutes = (totalSeconds % 3600) / 60
    val seconds = totalSeconds % 60

    return when {
        hours > 0 -> String.format("%02d:%02d:%02d", hours, minutes, seconds)
        else -> String.format("%02d:%02d", minutes, seconds)
    }
}

fun formatTimeShort(milliseconds: Long): String {
    val totalMinutes = milliseconds / (1000 * 60)
    val hours = totalMinutes / 60
    val minutes = totalMinutes % 60

    return when {
        hours > 0 -> "${hours}h ${minutes}m"
        minutes > 0 -> "${minutes}m"
        else -> "<1m"
    }
}
