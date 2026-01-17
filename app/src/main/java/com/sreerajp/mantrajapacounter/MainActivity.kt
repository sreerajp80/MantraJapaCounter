package com.sreerajp.mantrajapacounter

import android.Manifest
import android.content.Context
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.content.ContextCompat
import androidx.core.content.edit
import com.google.gson.Gson
import com.sreerajp.mantrajapacounter.data.*
import com.sreerajp.mantrajapacounter.database.*
import com.sreerajp.mantrajapacounter.screens.AboutCounterScreen
import com.sreerajp.mantrajapacounter.screens.AboutScreen
import com.sreerajp.mantrajapacounter.screens.CounterListScreen
import com.sreerajp.mantrajapacounter.screens.CountingScreen
import com.sreerajp.mantrajapacounter.screens.HistoryScreen
import com.sreerajp.mantrajapacounter.screens.SettingsScreen
import com.sreerajp.mantrajapacounter.ui.theme.MantraJapaCounterTheme
import com.sreerajp.mantrajapacounter.utils.DailyGoalNotificationHelper
import com.sreerajp.mantrajapacounter.utils.FileUtils
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.*

enum class Screen {
    COUNTER_LIST, COUNTING, HISTORY, ABOUT, ABOUT_COUNTER, SETTINGS
}

data class ActiveSession(
    val counterId: String,
    val counterName: String,
    val currentTapCount: Int,
    val sessionTotalTaps: Int,
    val startTime: Long,
    val sessionId: String = UUID.randomUUID().toString(),
    val date: String = ""
)

class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContent {
            MantraJapaCounterTheme {
                MantraCounterApp()
            }
        }
    }

    override fun onDestroy() {
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
    
    // Notification helper for daily goal alerts
    val notificationHelper = remember { DailyGoalNotificationHelper(context) }

    var currentScreen by remember { mutableStateOf(Screen.COUNTER_LIST) }
    var previousScreen by remember { mutableStateOf(Screen.COUNTER_LIST) }
    var selectedCounter by remember { mutableStateOf<Counter?>(null) }
    var aboutCounter by remember { mutableStateOf<Counter?>(null) }
    var averageDailyCount by remember { mutableStateOf(0.0) }
    var currentTapCount by remember { mutableIntStateOf(0) }
    var sessionTotalTaps by remember { mutableIntStateOf(0) }
    var startTime by remember { mutableLongStateOf(0L) }
    var elapsedTime by remember { mutableLongStateOf(0L) }
    var currentSessionId by remember { mutableStateOf<String?>(null) }
    
    // Track if daily goal notification has been played for current session
    var dailyGoalNotificationPlayed by remember { mutableStateOf(false) }

    // Collect data from database
    val counters by repository.getAllCounters().collectAsState(initial = emptyList())
    val sessions by repository.getAllSessions().collectAsState(initial = emptyList())

    // State for tracking today's counts and total counts
    var todayCountsMap by remember { mutableStateOf<Map<String, Int>>(emptyMap()) }
    var totalCountsMap by remember { mutableStateOf<Map<String, Int>>(emptyMap()) }

    // Import/Export dialog and message states
    var showImportExportDialog by remember { mutableStateOf(false) }
    var importExportMessage by remember { mutableStateOf<String?>(null) }
    
    // Permission dialog state
    var showPermissionDialog by remember { mutableStateOf(false) }
    var permissionsRequested by remember { mutableStateOf(false) }
    
    // Permission launcher
    val permissionLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.RequestMultiplePermissions()
    ) { permissions ->
        // Permissions granted or denied - just proceed, user can change later in settings
        permissionsRequested = true
        prefs.edit { putBoolean("permissions_requested", true) }
    }
    
    // Check if we need to request permissions on first launch
    LaunchedEffect(Unit) {
        val alreadyRequested = prefs.getBoolean("permissions_requested", false)
        if (!alreadyRequested) {
            showPermissionDialog = true
        }
    }

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
    LaunchedEffect(
        selectedCounter,
        currentTapCount,
        sessionTotalTaps,
        startTime,
        currentSessionId
    ) {
        if (selectedCounter != null && currentSessionId != null) {
            val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            val currentDate = sdf.format(Date())
            val activeSession = ActiveSession(
                counterId = selectedCounter!!.id,
                counterName = selectedCounter!!.name,
                currentTapCount = currentTapCount,
                sessionTotalTaps = sessionTotalTaps,
                startTime = startTime,
                sessionId = currentSessionId!!,
                date = currentDate
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
                    dailyGoalNotificationPlayed = false // Reset notification state for new session
                    currentScreen = Screen.COUNTING
                },
                onAddCounter = { name, startDate, initialCount, incrementStep, goal, dailyGoal ->
                    val newCounter = Counter(
                        name = name,
                        initialCount = initialCount,
                        incrementStep = maxOf(1, incrementStep),
                        goal = goal,
                        dailyGoal = dailyGoal,
                        startDate = startDate
                    )
                    coroutineScope.launch {
                        repository.insertCounter(newCounter)
                    }
                },
                onEditCounter = { counter, name, startDate, initialCount, incrementStep, goal, dailyGoal ->
                    val updatedCounter = counter.copy(
                        name = name,
                        initialCount = initialCount,
                        incrementStep = maxOf(1, incrementStep),
                        goal = goal,
                        dailyGoal = dailyGoal,
                        startDate = startDate
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
                onDisableCounter = { counter, status, reason ->
                    val updatedCounter = counter.copy(
                        status = status,
                        disabledAt = if (status != CounterStatus.ACTIVE) System.currentTimeMillis() else null,
                        disabledReason = reason
                    )
                    coroutineScope.launch {
                        repository.updateCounter(updatedCounter)
                    }
                    // Clear active session if disabling active counter
                    if (status != CounterStatus.ACTIVE) {
                        loadActiveSession(prefs)?.let { activeSession ->
                            if (activeSession.counterId == counter.id) {
                                clearActiveSession(prefs)
                                currentScreen = Screen.COUNTER_LIST
                            }
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
                onShowAboutCounter = { counter ->
                    aboutCounter = counter
                    previousScreen = Screen.COUNTER_LIST
                    currentScreen = Screen.ABOUT_COUNTER
                    coroutineScope.launch {
                        val startDate = if (counter.startDate > 0L) counter.startDate else counter.createdAt
                        averageDailyCount = repository.getAverageDailyCountForCounter(counter.id, startDate)
                    }
                },
                onShowImportExport = {
                    showImportExportDialog = true
                },
                onShowSettings = {
                    previousScreen = Screen.COUNTER_LIST
                    currentScreen = Screen.SETTINGS
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
                    
                    // Track currentTapCount before increment for mala completion check
                    val tapCountBefore = currentTapCount
                    
                    // Check if daily goal was NOT achieved before this increment
                    val todayCountBefore = selectedCounter?.let { getTodayCountForCounter(it) } ?: 0
                    val wasDailyGoalAchievedBefore = selectedCounter?.isDailyGoalAchieved(todayCountBefore) == true

                    currentTapCount += step
                    sessionTotalTaps += step

                    // Check if a mala was completed (crossed 108)
                    val malaCompleted = currentTapCount >= 108
                    
                    if (currentTapCount >= 108) {
                        currentTapCount %= 108
                    }

                    if (wasZero) {
                        createSessionInDatabase()
                    } else {
                        updateCurrentSessionInDatabase()
                    }
                    
                    // Check if daily goal is NOW achieved after this increment
                    val todayCountAfter = todayCountBefore + step
                    val isDailyGoalAchievedNow = selectedCounter?.isDailyGoalAchieved(todayCountAfter) == true
                    
                    // Play notification only when crossing the threshold (not already achieved before)
                    if (isDailyGoalAchievedNow && !wasDailyGoalAchievedBefore && !dailyGoalNotificationPlayed) {
                        dailyGoalNotificationPlayed = true
                        notificationHelper.playDailyGoalNotification()
                    } else if (malaCompleted) {
                        // Play mala completion sound only if it's not also the daily goal
                        notificationHelper.playMalaCompletionNotification()
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
                onShowHistory = { _ ->
                    previousScreen = Screen.COUNTER_LIST
                    currentScreen = Screen.HISTORY
                },
                onShowAbout = {
                    previousScreen = Screen.COUNTER_LIST
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
                counters = counters,
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
                            sessions.forEach { session ->
                                if (session.id != currentSessionId) {
                                    repository.deleteSession(session)
                                }
                            }
                        }
                    }
                },
                onDeleteSession = { session -> deleteSession(session) }
            )
        }
        Screen.ABOUT -> {
            AboutScreen(
                onBack = {
                    currentScreen = previousScreen
                }
            )
        }
        Screen.ABOUT_COUNTER -> {
            aboutCounter?.let { counter ->
                val totalCount = getTotalCountForCounter(counter)
                AboutCounterScreen(
                    counter = counter,
                    totalCount = totalCount,
                    averageDailyCount = averageDailyCount,
                    onBack = {
                        currentScreen = previousScreen
                        aboutCounter = null
                    }
                )
            }
        }
        Screen.SETTINGS -> {
            SettingsScreen(
                notificationHelper = notificationHelper,
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
    
    // Permission request dialog
    if (showPermissionDialog) {
        AlertDialog(
            onDismissRequest = { 
                showPermissionDialog = false
                prefs.edit { putBoolean("permissions_requested", true) }
            },
            icon = {
                Icon(
                    imageVector = Icons.Default.Notifications,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.size(48.dp)
                )
            },
            title = { 
                Text(
                    "Permissions Required",
                    fontWeight = FontWeight.Bold
                ) 
            },
            text = {
                Column(
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    Text(
                        "Mantra Japa Counter needs the following permissions for the best experience:"
                    )
                    
                    Card(
                        colors = CardDefaults.cardColors(
                            containerColor = MaterialTheme.colorScheme.surfaceVariant
                        ),
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Column(
                            modifier = Modifier.padding(12.dp),
                            verticalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            Row(
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.spacedBy(8.dp)
                            ) {
                                Icon(
                                    imageVector = Icons.Default.Vibration,
                                    contentDescription = null,
                                    modifier = Modifier.size(20.dp)
                                )
                                Text(
                                    "Vibration - Alert when daily goal is reached",
                                    fontSize = 14.sp
                                )
                            }
                            Row(
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.spacedBy(8.dp)
                            ) {
                                Icon(
                                    imageVector = Icons.Default.MusicNote,
                                    contentDescription = null,
                                    modifier = Modifier.size(20.dp)
                                )
                                Text(
                                    "Audio - Select custom notification tones",
                                    fontSize = 14.sp
                                )
                            }
                        }
                    }
                    
                    Text(
                        "You can change these settings later in the app Settings.",
                        fontSize = 13.sp,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            },
            confirmButton = {
                Button(
                    onClick = {
                        showPermissionDialog = false
                        
                        // Request permissions
                        val permissionsToRequest = mutableListOf<String>()
                        
                        // Check and request audio permission for Android 13+
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                            if (ContextCompat.checkSelfPermission(
                                    context,
                                    Manifest.permission.READ_MEDIA_AUDIO
                                ) != PackageManager.PERMISSION_GRANTED
                            ) {
                                permissionsToRequest.add(Manifest.permission.READ_MEDIA_AUDIO)
                            }
                        }
                        
                        if (permissionsToRequest.isNotEmpty()) {
                            permissionLauncher.launch(permissionsToRequest.toTypedArray())
                        } else {
                            prefs.edit { putBoolean("permissions_requested", true) }
                        }
                    }
                ) {
                    Text("Grant Permissions")
                }
            },
            dismissButton = {
                TextButton(
                    onClick = { 
                        showPermissionDialog = false
                        prefs.edit { putBoolean("permissions_requested", true) }
                    }
                ) {
                    Text("Skip")
                }
            }
        )
    }
}

// Active session persistence functions
fun saveActiveSession(prefs: SharedPreferences, activeSession: ActiveSession) {
    val gson = Gson()
    val json = gson.toJson(activeSession)
    prefs.edit {
        putString("active_session", json)
    }
}

fun loadActiveSession(prefs: SharedPreferences): ActiveSession? {
    val gson = Gson()
    val json = prefs.getString("active_session", null)
    if (json != null) {
        try {
            val session = gson.fromJson(json, ActiveSession::class.java)
            val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            val currentDate = sdf.format(Date())
            // Check if session is from today
            return if (session.date == currentDate) {
                session
            } else {
                // It's a new day, clear the old session
                clearActiveSession(prefs)
                null
            }
        } catch (e: Exception) {
            // In case of parsing error (e.g., old ActiveSession format without date)
            clearActiveSession(prefs)
            return null
        }
    }
    return null
}

fun clearActiveSession(prefs: SharedPreferences) {
    prefs.edit {
        remove("active_session")
    }
}
