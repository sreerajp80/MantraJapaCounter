package com.sreerajp.mantrajapacounter

import android.Manifest
import android.content.Context
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import androidx.compose.ui.platform.LocalView
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
import kotlinx.coroutines.delay
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.first
import java.text.SimpleDateFormat
import java.util.*

// Enum representing all navigation screens in the app
enum class Screen {
    COUNTER_LIST,      // Main screen showing all counters
    COUNTING,          // Active counting session screen
    HISTORY,           // Historical data and session records
    ABOUT,             // General about/info screen
    ABOUT_COUNTER,     // Detailed statistics for a specific counter
    SETTINGS           // App settings and preferences
}

// Data class tracking the current active counting session
// Persisted to SharedPreferences to recover from app crashes
data class ActiveSession(
    val counterId: String,
    val counterName: String,
    val currentTapCount: Int,
    val sessionTotalTaps: Int,
    val startTime: Long,
    val sessionId: String = UUID.randomUUID().toString(),
    val date: String = "",
    val isWrittenToDatabase: Boolean = false // Track if session has been written to DB
)

// Main activity - entry point for the Mantra Japa Counter application
class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize the Compose UI with the app theme and main composable
        setContent {
            MantraJapaCounterTheme {
                MantraCounterApp()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        // Any cleanup is handled by Compose and the composable lifecycle
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

// Main composable function for the Mantra Japa Counter application
// Manages all state, navigation, and business logic for the entire app
@Composable
fun MantraCounterApp() {
    // UI context and local references
    val context = LocalContext.current
    val view = LocalView.current

    // Database repository for all data operations
    val repository = remember { JapaCounterRepository(context) }

    // SharedPreferences for lightweight data persistence (active sessions, settings)
    val prefs = remember { context.getSharedPreferences("japa_counter", Context.MODE_PRIVATE) }

    // Coroutine scope for async database and file operations
    val coroutineScope = rememberCoroutineScope()

    // Helper for managing notification sounds and vibrations
    val notificationHelper = remember { DailyGoalNotificationHelper(context) }

    // ===== POWER OPTIMIZATION: Screen brightness control =====
    // Reduces screen brightness during counting sessions to save battery
    var originalBrightness by remember { mutableStateOf(-1f) }     // Original brightness before reduction
    var isBrightnessReduced by remember { mutableStateOf(false) }  // Track if brightness is currently reduced

    // ===== NAVIGATION STATE =====
    var currentScreen by remember { mutableStateOf(Screen.COUNTER_LIST) }   // Active screen being displayed
    var previousScreen by remember { mutableStateOf(Screen.COUNTER_LIST) }  // Previous screen for back navigation

    // ===== COUNTER AND SESSION STATE =====
    var selectedCounter by remember { mutableStateOf<Counter?>(null) }      // Currently selected counter for counting
    var aboutCounter by remember { mutableStateOf<Counter?>(null) }         // Counter being viewed in about screen
    var averageDailyCount by remember { mutableStateOf(0.0) }              // Average daily count for selected counter
    var currentTapCount by remember { mutableIntStateOf(0) }               // Taps in current mala (0-107)
    var sessionTotalTaps by remember { mutableIntStateOf(0) }              // Total taps in current session
    var startTime by remember { mutableLongStateOf(0L) }                   // Session start timestamp (milliseconds)
    var elapsedTime by remember { mutableLongStateOf(0L) }                 // Elapsed time since session start
    var currentSessionId by remember { mutableStateOf<String?>(null) }     // Unique ID for current session

    // ===== NOTIFICATION STATE =====
    // Prevents multiple daily goal notifications in the same session
    var dailyGoalNotificationPlayed by remember { mutableStateOf(false) }

    // ===== POWER OPTIMIZATION: DATABASE BATCHING =====
    // Reduces database I/O operations by batching writes (every 30 seconds or 20 taps)
    // Improves battery life while maintaining data safety
    var pendingDatabaseWrite by remember { mutableStateOf(false) }         // Is a database write scheduled?
    var tapCountSinceLastDbWrite by remember { mutableIntStateOf(0) }      // Taps since last database update
    var lastDatabaseWriteTime by remember { mutableLongStateOf(0L) }       // Timestamp of last database write
    var databaseWriteJob by remember { mutableStateOf<Job?>(null) }        // Scheduled database write coroutine

    // Critical for accuracy: tracks count written to DB vs current session total
    // Used to avoid double-counting when session is partially in database
    var lastDbWrittenCount by remember { mutableIntStateOf(0) }            // Session taps that are saved in database

    // ===== POWER OPTIMIZATION: SHARED PREFERENCES BATCHING =====
    // Batches SharedPreferences writes (every 5 taps or 5 seconds) for efficiency
    // Allows quick crash recovery while reducing I/O operations
    var pendingPrefsWrite by remember { mutableStateOf(false) }            // Is a SharedPreferences write scheduled?
    var prefsWriteJob by remember { mutableStateOf<Job?>(null) }           // Scheduled SharedPreferences write coroutine
    var tapCountSinceLastPrefsWrite by remember { mutableIntStateOf(0) }   // Taps since last SharedPreferences save
    var lastPrefsWriteTime by remember { mutableLongStateOf(0L) }          // Timestamp of last SharedPreferences write

    // ===== SCREEN BRIGHTNESS MANAGEMENT FUNCTION =====
    // Applies or removes reduced brightness to save battery during counting
    // Saves original brightness to restore it when leaving counting screen
    fun applyBrightness(reduce: Boolean) {
        val activity = view.context as? ComponentActivity
        val window = activity?.window
        if (window != null) {
            val layoutParams = window.attributes
            if (reduce && notificationHelper.isReduceBrightnessEnabled()) {
                // Save original brightness if not already saved
                if (originalBrightness < 0) {
                    originalBrightness = layoutParams.screenBrightness
                }
                // Apply reduced brightness
                layoutParams.screenBrightness = notificationHelper.getBrightnessLevel()
                isBrightnessReduced = true
            } else {
                // Restore original brightness
                if (originalBrightness >= 0) {
                    layoutParams.screenBrightness = originalBrightness
                    originalBrightness = -1f
                }
                isBrightnessReduced = false
            }
            window.attributes = layoutParams
        }
    }

    // Apply brightness when entering/exiting counting screen
    LaunchedEffect(currentScreen) {
        when (currentScreen) {
            Screen.COUNTING -> {
                applyBrightness(reduce = true)
            }
            else -> {
                if (isBrightnessReduced) {
                    applyBrightness(reduce = false)
                }
            }
        }
    }

    // ===== DATABASE DATA FLOWS =====
    // Collect and observe counter and session data from database
    // distinctUntilChanged() prevents recomposition when data hasn't actually changed
    // Improves performance by avoiding unnecessary UI updates
    val counters by repository.getAllCounters()
        .distinctUntilChanged()
        .collectAsState(initial = emptyList())  // All counters defined by user
    val sessions by repository.getAllSessions()
        .distinctUntilChanged()
        .collectAsState(initial = emptyList())  // All recorded sessions

    // ===== COUNT CACHING STATE =====
    // Cached count totals from database to avoid recalculating on every recomposition
    var todayCountsMap by remember { mutableStateOf<Map<String, Int>>(emptyMap()) }    // Today's counts per counter ID
    var totalCountsMap by remember { mutableStateOf<Map<String, Int>>(emptyMap()) }    // Lifetime counts per counter ID

    // ===== DIALOG STATE =====
    // Controls visibility and content of various dialogs
    var showImportExportDialog by remember { mutableStateOf(false) }       // Import/Export options dialog
    var importExportMessage by remember { mutableStateOf<String?>(null) }  // Success/error message from import/export

    // ===== PERMISSION REQUEST STATE =====
    // Tracks if permissions have been requested to avoid repeated prompts
    var showPermissionDialog by remember { mutableStateOf(false) }         // Show permission request dialog?
    var permissionsRequested by remember { mutableStateOf(false) }         // Have permissions been requested before?

    // Activity result launcher for requesting runtime permissions
    // Handles user's response to permission requests (grant or deny)
    val permissionLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.RequestMultiplePermissions()
    ) { permissions ->
        // Record that permissions have been requested (don't prompt again)
        // User can change permissions later in device settings
        permissionsRequested = true
        prefs.edit { putBoolean("permissions_requested", true) }
    }

    // ===== INITIAL SETUP: Check if permissions need to be requested =====
    // Runs once on app startup to show permission dialog on first launch
    LaunchedEffect(Unit) {
        val alreadyRequested = prefs.getBoolean("permissions_requested", false)
        if (!alreadyRequested) {
            showPermissionDialog = true
        }
    }

    // ===== IMPORT/EXPORT HANDLERS =====
    // Create lambdas for triggering import/export operations
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

    // ===== UTILITY FUNCTION: Refresh count maps from database =====
    // Recalculates all counters' today and lifetime counts from database
    // Called after database updates to ensure UI shows correct totals
    suspend fun refreshCountMaps() {
        val todayMap = mutableMapOf<String, Int>()
        val totalMap = mutableMapOf<String, Int>()

        counters.forEach { counter ->
            todayMap[counter.id] = repository.getTodayCountForCounter(counter.id)
            totalMap[counter.id] = repository.getTotalCountForCounter(counter.id)
        }

        todayCountsMap = todayMap
        totalCountsMap = totalMap
    }

    // ===== INITIAL SETUP: Database migration and session recovery =====
    // Runs once to migrate old SharedPreferences data to database
    // Recovers active session from crash, ensuring data safety
    LaunchedEffect(Unit) {
        val migrationHelper = DatabaseMigrationHelper(context, repository)
        migrationHelper.migrateFromSharedPreferences()

        // Load active session if exists
        loadActiveSession(prefs)?.let { activeSession ->
            val counter = repository.getCounterById(activeSession.counterId)
            selectedCounter = counter
            if (counter != null) {
                currentTapCount = activeSession.currentTapCount
                sessionTotalTaps = activeSession.sessionTotalTaps
                startTime = activeSession.startTime
                currentSessionId = activeSession.sessionId

                // DATA SAFETY: Check if session exists in database
                // If not, write it immediately to prevent data loss
                val allSessions = repository.getAllSessions().first()
                val existingSession = allSessions.find {
                    it.id == activeSession.sessionId
                }

                if (existingSession == null && activeSession.sessionTotalTaps > 0) {
                    // Session not in DB - write it immediately for data safety
                    val elapsedTime = System.currentTimeMillis() - activeSession.startTime
                    val session = JapaSession(
                        id = activeSession.sessionId,
                        counterId = activeSession.counterId,
                        counterName = activeSession.counterName,
                        count = activeSession.sessionTotalTaps,
                        malas = activeSession.sessionTotalTaps / 108,
                        chants = activeSession.sessionTotalTaps,
                        duration = elapsedTime,
                        timestamp = activeSession.startTime
                    )
                    repository.insertSession(session)

                    // Update flag to indicate it's now in DB
                    val updatedSession = activeSession.copy(isWrittenToDatabase = true)
                    saveActiveSession(prefs, updatedSession)

                    // Update tracking variables
                    lastDatabaseWriteTime = System.currentTimeMillis()
                    tapCountSinceLastDbWrite = 0
                    lastDbWrittenCount = activeSession.sessionTotalTaps // Track what's in DB

                    // Refresh count maps after inserting session
                    refreshCountMaps()
                } else if (existingSession != null) {
                    // Session exists in DB - check if SharedPreferences has newer data
                    // This handles the case where app crashed after SharedPreferences save but before DB write
                    if (activeSession.sessionTotalTaps > existingSession.count) {
                        // SharedPreferences has more recent data - update DB
                        val elapsedTime = System.currentTimeMillis() - activeSession.startTime
                        repository.updateSession(
                            existingSession.copy(
                                count = activeSession.sessionTotalTaps,
                                malas = activeSession.sessionTotalTaps / 108,
                                chants = activeSession.sessionTotalTaps,
                                duration = elapsedTime
                            )
                        )
                        lastDbWrittenCount = activeSession.sessionTotalTaps // Track what's in DB now
                    } else {
                        // DB has the same or more recent data
                        lastDbWrittenCount = existingSession.count // Track what's already in DB
                    }

                    // Update flag
                    val updatedSession = activeSession.copy(isWrittenToDatabase = true)
                    saveActiveSession(prefs, updatedSession)

                    // Update tracking variables
                    lastDatabaseWriteTime = System.currentTimeMillis()
                    tapCountSinceLastDbWrite = 0

                    // Refresh count maps to ensure accuracy
                    refreshCountMaps()
                }

                currentScreen = Screen.COUNTING
            } else {
                clearActiveSession(prefs)
            }
        }
    }

    // ===== REACTIVE: Update count maps when database data changes =====
    // Recalculates today and total counts whenever counters or sessions update
    // Ensures display always reflects current database state
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

    // ===== TIMER LOOP: Update elapsed time and batch database writes =====
    // Runs while counting screen is active to:
    // 1. Update elapsed time state every 5 seconds (for smooth UI)
    // 2. Batch database writes every 30 seconds (power optimization)
    // UI can calculate exact elapsed time on-demand for display accuracy
    LaunchedEffect(currentScreen, startTime) {
        if (currentScreen == Screen.COUNTING && startTime > 0) {
            while (currentScreen == Screen.COUNTING) {
                // Update elapsed time state every 5 seconds (for power optimization)
                // But UI can calculate it on-demand for accurate display
                elapsedTime = System.currentTimeMillis() - startTime
                delay(5000)

                // Batch database update every 30 seconds (instead of 10 seconds)
                // This reduces I/O operations while still maintaining data safety
                val currentTime = System.currentTimeMillis()
                if (currentSessionId != null && sessionTotalTaps > 0) {
                    val timeSinceLastWrite = currentTime - lastDatabaseWriteTime
                    if (timeSinceLastWrite >= 30000) { // 30 seconds
                        val existingSession = sessions.find { it.id == currentSessionId }
                        if (existingSession != null) {
                            val countBeingWritten = sessionTotalTaps
                            coroutineScope.launch {
                                repository.updateSession(
                                    existingSession.copy(
                                        count = countBeingWritten,
                                        malas = countBeingWritten / 108,
                                        chants = countBeingWritten,
                                        duration = elapsedTime
                                    )
                                )
                                lastDatabaseWriteTime = currentTime
                                tapCountSinceLastDbWrite = 0
                                pendingDatabaseWrite = false
                                lastDbWrittenCount = countBeingWritten // Track what we wrote to DB
                            }
                        }
                    }
                }
            }
        }
    }

    // ===== OPTIMIZED SESSION SAVE: Batched SharedPreferences writes =====
    // Intelligently batches SharedPreferences saves to reduce I/O
    // Strategy: Save if 5 seconds passed OR 5 taps occurred (whichever comes first)
    // More efficient than writing on every tap while maintaining crash recovery capability
    fun saveActiveSessionBatched() {
        if (selectedCounter != null && currentSessionId != null) {
            tapCountSinceLastPrefsWrite++
            val currentTime = System.currentTimeMillis()
            val timeSinceLastWrite = if (lastPrefsWriteTime > 0) currentTime - lastPrefsWriteTime else Long.MAX_VALUE

            // Batch writes: save if 5 seconds passed OR 5 taps occurred (whichever comes first)
            val shouldWriteNow = timeSinceLastWrite >= 5000 || tapCountSinceLastPrefsWrite >= 5

            if (shouldWriteNow) {
                // Write immediately
                val isInDb = sessions.any { it.id == currentSessionId }
                val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                val currentDate = sdf.format(Date())
                val activeSession = ActiveSession(
                    counterId = selectedCounter!!.id,
                    counterName = selectedCounter!!.name,
                    currentTapCount = currentTapCount,
                    sessionTotalTaps = sessionTotalTaps,
                    startTime = startTime,
                    sessionId = currentSessionId!!,
                    date = currentDate,
                    isWrittenToDatabase = isInDb
                )
                saveActiveSession(prefs, activeSession)
                lastPrefsWriteTime = currentTime
                tapCountSinceLastPrefsWrite = 0
                pendingPrefsWrite = false
                prefsWriteJob?.cancel()
            } else {
                // Schedule a debounced write
                pendingPrefsWrite = true
                prefsWriteJob?.cancel()
                prefsWriteJob = coroutineScope.launch {
                    delay(5000 - timeSinceLastWrite) // Wait until 5 seconds total
                    if (pendingPrefsWrite && selectedCounter != null && currentSessionId != null) {
                        val isInDb = sessions.any { it.id == currentSessionId }
                        val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                        val currentDate = sdf.format(Date())
                        val activeSession = ActiveSession(
                            counterId = selectedCounter!!.id,
                            counterName = selectedCounter!!.name,
                            currentTapCount = currentTapCount,
                            sessionTotalTaps = sessionTotalTaps,
                            startTime = startTime,
                            sessionId = currentSessionId!!,
                            date = currentDate,
                            isWrittenToDatabase = isInDb
                        )
                        saveActiveSession(prefs, activeSession)
                        lastPrefsWriteTime = System.currentTimeMillis()
                        tapCountSinceLastPrefsWrite = 0
                        pendingPrefsWrite = false
                    }
                }
            }
        }
    }

    // ===== CRITICAL SAVE: Force immediate SharedPreferences write =====
    // Bypasses batching to immediately save session state
    // Used for critical moments: first tap, leaving screen, app termination
    fun saveActiveSessionImmediately() {
        if (selectedCounter != null && currentSessionId != null) {
            prefsWriteJob?.cancel()
            val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            val currentDate = sdf.format(Date())

            // Check if session is already in database
            val isInDb = sessions.any { it.id == currentSessionId }

            val activeSession = ActiveSession(
                counterId = selectedCounter!!.id,
                counterName = selectedCounter!!.name,
                currentTapCount = currentTapCount,
                sessionTotalTaps = sessionTotalTaps,
                startTime = startTime,
                sessionId = currentSessionId!!,
                date = currentDate,
                isWrittenToDatabase = isInDb
            )
            saveActiveSession(prefs, activeSession)
            lastPrefsWriteTime = System.currentTimeMillis()
            tapCountSinceLastPrefsWrite = 0
            pendingPrefsWrite = false
        }
    }

    // ===== COUNT CALCULATION: Get total count including unsaved taps =====
    // Combines database count with in-memory taps for real-time display
    // CRITICAL LOGIC: Only adds NEW taps (sessionTotalTaps - lastDbWrittenCount)
    // This prevents double-counting when session is already partially in database
    // Formula: initialCount + historicalTotal + newTapsNotYetInDb
    fun getTotalCountForCounter(counter: Counter): Int {
        val historicalTotal = totalCountsMap[counter.id] ?: 0
        val baseTotal = counter.initialCount + historicalTotal

        // Only add NEW taps that haven't been written to DB yet
        // This prevents double-counting when totalCountsMap already includes part of the session
        val newTapsNotInDb = if (selectedCounter?.id == counter.id && currentSessionId != null) {
            // sessionTotalTaps - lastDbWrittenCount = taps since last DB write
            (sessionTotalTaps - lastDbWrittenCount).coerceAtLeast(0)
        } else {
            0
        }

        return baseTotal + newTapsNotInDb
    }

    // ===== COUNT CALCULATION: Get today's count including unsaved taps =====
    // Similar to getTotalCountForCounter but only includes today's taps
    // Only adds unsaved taps if session started today
    fun getTodayCountForCounter(counter: Counter): Int {
        val todayFromDb = todayCountsMap[counter.id] ?: 0

        // Only add NEW taps (not yet in DB) if this is the active counter and session started today
        val newTapsNotInDb = if (selectedCounter?.id == counter.id && currentSessionId != null) {
            // Check if session started today
            val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            val today = sdf.format(Date())
            val sessionDate = sdf.format(Date(startTime))
            if (sessionDate == today) {
                // sessionTotalTaps - lastDbWrittenCount = taps since last DB write
                (sessionTotalTaps - lastDbWrittenCount).coerceAtLeast(0)
            } else {
                0
            }
        } else {
            0
        }

        return todayFromDb + newTapsNotInDb
    }

    // ===== DATABASE OPERATION: Create new session on first tap =====
    // Inserts new session into database immediately for data safety
    // Updates tracking variables to enable smart batching for subsequent saves
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

            // First session creation - save immediately for data safety
            val countBeingWritten = sessionTotalTaps
            coroutineScope.launch {
                repository.insertSession(session)
                lastDatabaseWriteTime = System.currentTimeMillis()
                tapCountSinceLastDbWrite = 0
                lastDbWrittenCount = countBeingWritten // Track what we wrote to DB

                // Update flag in SharedPreferences to indicate session is in DB
                // Use immediate save for first session creation
                val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                val currentDate = sdf.format(Date())
                val activeSession = ActiveSession(
                    counterId = selectedCounter!!.id,
                    counterName = selectedCounter!!.name,
                    currentTapCount = currentTapCount,
                    sessionTotalTaps = sessionTotalTaps,
                    startTime = startTime,
                    sessionId = currentSessionId!!,
                    date = currentDate,
                    isWrittenToDatabase = true
                )
                saveActiveSession(prefs, activeSession)
                lastPrefsWriteTime = System.currentTimeMillis()
                tapCountSinceLastPrefsWrite = 0
            }
        }
    }

    // ===== DATABASE OPERATION: Update existing session with batching =====
    // Intelligently batches database writes for performance
    // Strategy: Update if 30 seconds passed OR 20 taps occurred (whichever comes first)
    // Balances data safety with reduced I/O operations for battery efficiency
    fun updateCurrentSessionInDatabase() {
        if (currentSessionId != null && sessionTotalTaps > 0) {
            val existingSession = sessions.find { it.id == currentSessionId }
            if (existingSession != null) {
                tapCountSinceLastDbWrite++
                val currentTime = System.currentTimeMillis()
                val timeSinceLastWrite = currentTime - lastDatabaseWriteTime

                // Cancel any pending write job
                databaseWriteJob?.cancel()

                // Batch writes: save if 30 seconds passed OR 20 taps occurred
                val shouldWriteNow = timeSinceLastWrite >= 30000 || tapCountSinceLastDbWrite >= 20

                if (shouldWriteNow) {
                    // Write immediately
                    val countBeingWritten = sessionTotalTaps
                    coroutineScope.launch {
                        repository.updateSession(
                            existingSession.copy(
                                count = countBeingWritten,
                                malas = countBeingWritten / 108,
                                chants = countBeingWritten,
                                duration = elapsedTime
                            )
                        )
                        lastDatabaseWriteTime = currentTime
                        tapCountSinceLastDbWrite = 0
                        pendingDatabaseWrite = false
                        lastDbWrittenCount = countBeingWritten // Track what we wrote to DB

                        // Update flag in SharedPreferences to indicate session is in DB
                        val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                        val currentDate = sdf.format(Date())
                        val activeSession = ActiveSession(
                            counterId = selectedCounter!!.id,
                            counterName = selectedCounter!!.name,
                            currentTapCount = currentTapCount,
                            sessionTotalTaps = sessionTotalTaps,
                            startTime = startTime,
                            sessionId = currentSessionId!!,
                            date = currentDate,
                            isWrittenToDatabase = true
                        )
                        saveActiveSession(prefs, activeSession)
                    }
                } else {
                    // Schedule a debounced write
                    pendingDatabaseWrite = true
                    databaseWriteJob = coroutineScope.launch {
                        delay(30000 - timeSinceLastWrite) // Wait until 30 seconds total
                        if (pendingDatabaseWrite && currentSessionId != null && selectedCounter != null) {
                            val session = sessions.find { it.id == currentSessionId }
                            if (session != null) {
                                val countBeingWritten = sessionTotalTaps
                                repository.updateSession(
                                    session.copy(
                                        count = countBeingWritten,
                                        malas = countBeingWritten / 108,
                                        chants = countBeingWritten,
                                        duration = elapsedTime
                                    )
                                )
                                lastDatabaseWriteTime = System.currentTimeMillis()
                                tapCountSinceLastDbWrite = 0
                                pendingDatabaseWrite = false
                                lastDbWrittenCount = countBeingWritten // Track what we wrote to DB

                                // Update flag in SharedPreferences to indicate session is in DB
                                val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                                val currentDate = sdf.format(Date())
                                val activeSession = ActiveSession(
                                    counterId = selectedCounter!!.id,
                                    counterName = selectedCounter!!.name,
                                    currentTapCount = currentTapCount,
                                    sessionTotalTaps = sessionTotalTaps,
                                    startTime = startTime,
                                    sessionId = currentSessionId!!,
                                    date = currentDate,
                                    isWrittenToDatabase = true
                                )
                                saveActiveSession(prefs, activeSession)
                            }
                        }
                    }
                }
            }
        }
    }

    // ===== SESSION FINALIZATION: Ensure all data is saved =====
    // Critical function called when leaving counting screen
    // Ensures both SharedPreferences and database are up-to-date
    // Cancels pending batched writes and forces immediate saves
    fun finalizeSession() {
        // Cancel any pending debounced writes and force immediate save
        databaseWriteJob?.cancel()
        prefsWriteJob?.cancel()

        // Save active session to SharedPreferences first (synchronous, immediate)
        saveActiveSessionImmediately()

        // Force immediate database write to ensure data is saved
        // CRITICAL: We must save even if session isn't in the local sessions list yet
        // (The Flow might not have emitted the newly created session)
        if (currentSessionId != null && sessionTotalTaps > 0) {
            val sessionIdToSave = currentSessionId!!
            val counterIdToSave = selectedCounter?.id ?: return
            val counterNameToSave = selectedCounter?.name ?: return
            val tapsToSave = sessionTotalTaps
            val elapsedToSave = elapsedTime
            val startTimeToSave = startTime

            coroutineScope.launch {
                // Try to find existing session, or create new one if not found
                val existingSession = sessions.find { it.id == sessionIdToSave }

                if (existingSession != null) {
                    // Update existing session with final values
                    repository.updateSession(
                        existingSession.copy(
                            count = tapsToSave,
                            malas = tapsToSave / 108,
                            chants = tapsToSave,
                            duration = elapsedToSave
                        )
                    )
                } else {
                    // Session not in list yet - insert/update directly
                    // This handles the race condition where Flow hasn't emitted yet
                    val newSession = JapaSession(
                        id = sessionIdToSave,
                        counterId = counterIdToSave,
                        counterName = counterNameToSave,
                        count = tapsToSave,
                        malas = tapsToSave / 108,
                        chants = tapsToSave,
                        duration = elapsedToSave,
                        timestamp = startTimeToSave
                    )
                    // Use insertSession with REPLACE strategy to handle both insert and update
                    repository.insertSession(newSession)
                }

                // Refresh count maps after database update to ensure accuracy
                refreshCountMaps()
            }
        }

        clearActiveSession(prefs)
        currentSessionId = null
        pendingDatabaseWrite = false
        pendingPrefsWrite = false
        lastDbWrittenCount = 0 // Reset for next session
    }

    // ===== SESSION CANCELLATION: Delete current session and reset state =====
    // Called when user taps decrement and reaches zero taps
    // Removes session from database and clears active session data
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
        lastDbWrittenCount = 0 // Reset for next session
    }

    // ===== COUNTER RESET: Delete all sessions for selected counter =====
    // Clears all historical data for current counter and starts fresh session
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

    // ===== SESSION DELETION: Remove specific session from database =====
    // Prevents deletion of currently active session (safety check)
    fun deleteSession(sessionToDelete: JapaSession) {
        if (sessionToDelete.id == currentSessionId) {
            return
        }
        coroutineScope.launch {
            repository.deleteSession(sessionToDelete)
        }
    }

    // ===== SCREEN RENDERING: Navigate between app screens based on currentScreen state =====
    // Main UI routing logic - displays different composables for each screen
    when (currentScreen) {
        // ===== COUNTER LIST SCREEN =====
        // Displays all counters with today/lifetime stats and options to add/edit/delete
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
                    // Reset batching counters for new session
                    lastPrefsWriteTime = System.currentTimeMillis()
                    tapCountSinceLastPrefsWrite = 0
                    lastDatabaseWriteTime = System.currentTimeMillis()
                    tapCountSinceLastDbWrite = 0
                    lastDbWrittenCount = 0 // Reset for new session - no taps written yet
                    // Refresh count maps to ensure accurate counts when selecting counter
                    coroutineScope.launch {
                        refreshCountMaps()
                    }
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
        // ===== COUNTING SCREEN =====
        // Main counting interface with tap/decrement buttons, timer, and session data
        Screen.COUNTING -> {
            CountingScreen(
                counter = selectedCounter,
                currentTapCount = currentTapCount,
                sessionTotalTaps = sessionTotalTaps,
                elapsedTime = elapsedTime,
                startTime = startTime, // Pass startTime for on-demand calculation
                lifetimeTotal = selectedCounter?.let { getTotalCountForCounter(it) } ?: 0,
                todayTotal = selectedCounter?.let { getTodayCountForCounter(it) } ?: 0,
                onCountClick = {
                    // ===== TAP INCREMENT LOGIC =====
                    val step = maxOf(1, selectedCounter?.incrementStep ?: 1)
                    val wasZero = sessionTotalTaps == 0  // Is this the first tap?

                    // Store pre-increment values to check for milestone events
                    val tapCountBefore = currentTapCount
                    val todayCountBefore = selectedCounter?.let { getTodayCountForCounter(it) } ?: 0
                    val wasDailyGoalAchievedBefore = selectedCounter?.isDailyGoalAchieved(todayCountBefore) == true

                    // Perform increment
                    currentTapCount += step
                    sessionTotalTaps += step

                    // Check if a mala was completed (tapped past 108 in current mala)
                    val malaCompleted = currentTapCount >= 108

                    if (currentTapCount >= 108) {
                        currentTapCount %= 108
                    }

                    // ===== SAVE TO PERSISTENT STORAGE =====
                    if (wasZero) {
                        // First tap in new session - save immediately for data safety
                        createSessionInDatabase()                    // Insert to database
                        saveActiveSessionImmediately()               // Save to SharedPreferences
                    } else {
                        // Subsequent taps - use batching for efficiency
                        updateCurrentSessionInDatabase()             // Database update (batched every 30s or 20 taps)
                        saveActiveSessionBatched()                   // SharedPreferences (batched every 5s or 5 taps)
                    }

                    // ===== HANDLE MILESTONE NOTIFICATIONS =====
                    val todayCountAfter = todayCountBefore + step
                    val isDailyGoalAchievedNow = selectedCounter?.isDailyGoalAchieved(todayCountAfter) == true

                    // Daily goal notification: Play only when first crossing threshold
                    if (isDailyGoalAchievedNow && !wasDailyGoalAchievedBefore && !dailyGoalNotificationPlayed) {
                        dailyGoalNotificationPlayed = true  // Prevent duplicate notifications
                        notificationHelper.playDailyGoalNotification()
                    } else if (malaCompleted) {
                        // Mala completion sound: Play unless this tap also reached daily goal
                        notificationHelper.playMalaCompletionNotification()
                    }
                },
                onDecrementClick = {
                    // ===== TAP DECREMENT LOGIC =====
                    val step = maxOf(1, selectedCounter?.incrementStep ?: 1)
                    if (sessionTotalTaps >= step) {
                        // Decrement total taps
                        sessionTotalTaps -= step

                        // Decrement mala counter, wrapping if necessary
                        if (currentTapCount >= step) {
                            currentTapCount -= step
                        } else {
                            // Wrap around: go back to previous mala
                            currentTapCount = 108 - (step - currentTapCount)
                        }

                        // Save to persistent storage
                        if (sessionTotalTaps > 0) {
                            updateCurrentSessionInDatabase()        // Update session in database
                            saveActiveSessionBatched()               // Save to SharedPreferences
                        } else {
                            // Reached zero taps - cancel session
                            cancelSession()
                        }
                    }
                },
                onBack = {
                    // ===== LEAVE COUNTING SCREEN =====
                    // Ensure all pending data is saved before navigating away
                    finalizeSession()                              // Save all pending writes
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
                    // ===== RESET CURRENT SESSION =====
                    // Clears current session data and starts fresh (keeps counter selected)
                    cancelSession()                                 // Delete session from database
                    currentTapCount = 0
                    sessionTotalTaps = 0
                    startTime = System.currentTimeMillis()
                    elapsedTime = 0L
                    currentSessionId = UUID.randomUUID().toString() // New session ID
                },
                onResetCounter = {
                    resetCounter()
                }
            )
        }
        // ===== HISTORY SCREEN =====
        // Displays all recorded sessions with filtering and deletion options
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
        // ===== ABOUT SCREEN =====
        // General information about the app
        Screen.ABOUT -> {
            AboutScreen(
                onBack = {
                    currentScreen = previousScreen
                }
            )
        }
        // ===== COUNTER STATISTICS SCREEN =====
        // Detailed analytics for a specific counter (average daily count, total progress, etc.)
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
        // ===== SETTINGS SCREEN =====
        // App preferences including notifications, brightness, and permission management
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

// ===== ACTIVE SESSION PERSISTENCE FUNCTIONS =====
// SharedPreferences-based serialization for crash recovery

// Saves active session to SharedPreferences as JSON for fast recovery on app restart
fun saveActiveSession(prefs: SharedPreferences, activeSession: ActiveSession) {
    val gson = Gson()
    val json = gson.toJson(activeSession)
    prefs.edit {
        putString("active_session", json)
    }
}

// Retrieves active session from SharedPreferences, or null if none exists
// Returns session regardless of date if it has taps (for data safety)
// Clears empty sessions from previous days
fun loadActiveSession(prefs: SharedPreferences): ActiveSession? {
    val gson = Gson()
    val json = prefs.getString("active_session", null)
    if (json != null) {
        try {
            val session = gson.fromJson(json, ActiveSession::class.java)
            val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            val currentDate = sdf.format(Date())

            // DATA SAFETY: Always return the session if it has taps
            // The session will be written to database on load if it's not already there
            // This prevents data loss when session spans midnight
            if (session.sessionTotalTaps > 0) {
                // Return session regardless of date - the database write logic in LaunchedEffect
                // will handle persisting this data before clearing for a new day
                return session
            }

            // For empty sessions, check if it's from today
            return if (session.date == currentDate) {
                session
            } else {
                // It's a new day with no taps, clear the old session
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

// Clears active session from SharedPreferences (called when session is finalized)
fun clearActiveSession(prefs: SharedPreferences) {
    prefs.edit {
        remove("active_session")
    }
}
