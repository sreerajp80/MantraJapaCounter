package com.sreerajp.mantrajapacounter.database

import android.content.Context
import com.sreerajp.mantrajapacounter.data.Counter
import com.sreerajp.mantrajapacounter.data.JapaSession
import com.sreerajp.mantrajapacounter.data.ExportData
//import com.sreerajp.mantrajapacounter.data.CounterStatus
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import java.util.*
import java.util.Calendar

/**
 * Repository for managing counter and session data from Room database
 * Provides a clean API layer between UI/business logic and the database DAOs
 * Handles entity-to-model conversions and complex queries
 *
 * @param context Android application context for database initialization
 */
class JapaCounterRepository(context: Context) {
    // ===== DATABASE INITIALIZATION =====
    private val database = JapaCounterDatabase.getDatabase(context)
    private val counterDao = database.counterDao()
    private val sessionDao = database.sessionDao()

    // ===== COUNTER OPERATIONS =====

    /**
     * Retrieves all counters from the database as a Flow
     * @return Flow of list of all counters
     */
    fun getAllCounters(): Flow<List<Counter>> {
        return counterDao.getAllCounters().map { entities ->
            entities.map { it.toCounter() }
        }
    }

    /**
     * Retrieves a specific counter by ID
     * @param counterId The counter ID to look up
     * @return Counter if found, null otherwise
     */
    suspend fun getCounterById(counterId: String): Counter? {
        return counterDao.getCounterById(counterId)?.toCounter()
    }

    /**
     * Inserts a new counter into the database
     * @param counter The counter to insert
     */
    suspend fun insertCounter(counter: Counter) {
        counterDao.insertCounter(counter.toEntity())
    }

    /**
     * Updates an existing counter in the database
     * @param counter The counter with updated values
     */
    suspend fun updateCounter(counter: Counter) {
        counterDao.updateCounter(counter.toEntity())
    }

    /**
     * Deletes a counter from the database
     * Associated sessions are deleted due to foreign key cascade
     * @param counter The counter to delete
     */
    suspend fun deleteCounter(counter: Counter) {
        counterDao.deleteCounter(counter.toEntity())
    }

    // ===== SESSION OPERATIONS =====

    /**
     * Retrieves all sessions from the database as a Flow
     * @return Flow of list of all sessions
     */
    fun getAllSessions(): Flow<List<JapaSession>> {
        return sessionDao.getAllSessions().map { entities ->
            entities.map { it.toJapaSession() }
        }
    }

    /*fun getSessionsByCounterId(counterId: String): Flow<List<JapaSession>> {
        return sessionDao.getSessionsByCounterId(counterId).map { entities ->
            entities.map { it.toJapaSession() }
        }
    }*/

    /**
     * Calculates the total count for a specific counter since the start of today
     * @param counterId The counter ID to calculate for
     * @return Total count for today, or 0 if no sessions today
     */
    suspend fun getTodayCountForCounter(counterId: String): Int {
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        calendar.set(Calendar.MILLISECOND, 0)
        val todayStart = calendar.timeInMillis

        return sessionDao.getCountForCounterSince(counterId, todayStart) ?: 0
    }

    /**
     * Calculates the total count for a specific counter across all time
     * @param counterId The counter ID to calculate for
     * @return Total count, or 0 if no sessions exist
     */
    suspend fun getTotalCountForCounter(counterId: String): Int {
        return sessionDao.getTotalCountForCounter(counterId) ?: 0
    }

    /**
     * Calculates the average daily count for a counter since a specific date
     * Groups sessions by date and averages the daily totals
     * @param counterId The counter ID to calculate for
     * @param startDate Start date in milliseconds since epoch
     * @return Average count per day, or 0.0 if no sessions
     */
    suspend fun getAverageDailyCountForCounter(counterId: String, startDate: Long): Double {
        val sessions = sessionDao.getSessionsByCounterId(counterId).first()
            .filter { it.timestamp >= startDate }
            .map { it.toJapaSession() }

        if (sessions.isEmpty()) return 0.0

        // Group sessions by date
        val calendar = Calendar.getInstance()
        val dailyCounts = mutableMapOf<String, Int>()

        sessions.forEach { session ->
            calendar.timeInMillis = session.timestamp
            val dayKey = "${calendar.get(Calendar.YEAR)}-${calendar.get(Calendar.MONTH)}-${calendar.get(Calendar.DAY_OF_MONTH)}"
            dailyCounts[dayKey] = (dailyCounts[dayKey] ?: 0) + session.count
        }

        val totalCount = dailyCounts.values.sum()
        val numberOfDays = dailyCounts.size

        return if (numberOfDays > 0) totalCount.toDouble() / numberOfDays else 0.0
    }

    /**
     * Inserts a new session into the database
     * @param session The session to insert
     */
    suspend fun insertSession(session: JapaSession) {
        sessionDao.insertSession(session.toEntity())
    }

    /**
     * Updates an existing session in the database
     * @param session The session with updated values
     */
    suspend fun updateSession(session: JapaSession) {
        sessionDao.updateSession(session.toEntity())
    }

    /**
     * Deletes a session from the database
     * @param session The session to delete
     */
    suspend fun deleteSession(session: JapaSession) {
        sessionDao.deleteSession(session.toEntity())
    }

    /**
     * Deletes all sessions for a specific counter
     * @param counterId The counter ID whose sessions should be deleted
     */
    suspend fun deleteSessionsByCounterId(counterId: String) {
        sessionDao.deleteSessionsByCounterId(counterId)
    }

    // ===== IMPORT/EXPORT OPERATIONS =====

    /**
     * Exports all counters and sessions to an ExportData object
     * @return ExportData containing all counters and sessions
     */
    suspend fun exportData(): ExportData {
        val counters = counterDao.getAllCounters().first().map { it.toCounter() }
        val sessions = sessionDao.getAllSessions().first().map { it.toJapaSession() }

        return ExportData(
            counters = counters,
            sessions = sessions
        )
    }

    /**
     * Imports counters and sessions from an ExportData object
     * Clears existing data before importing to ensure clean import
     * Fixes invalid data (e.g., zero timestamps) during import
     * @param exportData The export data to import
     */
    suspend fun importData(exportData: ExportData) {
        // Clear existing data
        sessionDao.deleteAllSessions()
        counterDao.deleteAllCounters()

        // Import new data - use individual inserts since bulk methods don't exist
        exportData.counters.forEach { counter ->
            val fixedCounter = if (counter.startDate == 0L) {
                counter.copy(startDate = if (counter.createdAt > 0L) counter.createdAt else System.currentTimeMillis())
            } else counter
            counterDao.insertCounter(fixedCounter.toEntity())
        }

        exportData.sessions.forEach { session ->
            sessionDao.insertSession(session.toEntity())
        }
    }
}

// ===== EXTENSION FUNCTIONS FOR ENTITY-TO-MODEL CONVERSION =====

/**
 * Converts a CounterEntity database object to a Counter data model
 * @return Counter data model with all fields populated
 */
fun CounterEntity.toCounter(): Counter {
    return Counter(
        id = id,
        name = name,
        count = 0, // These fields are not used in the new implementation
        malas = 0,
        chants = 0,
        initialCount = initialCount,
        incrementStep = incrementStep,
        goal = goal,
        dailyGoal = dailyGoal,
        startDate = startDate,
        createdAt = createdAt,
        status = status,
        disabledAt = disabledAt,
        disabledReason = disabledReason
    )
}

/**
 * Converts a Counter data model to a CounterEntity database object
 * @return CounterEntity ready for database operations
 */
fun Counter.toEntity(): CounterEntity {
    return CounterEntity(
        id = id,
        name = name,
        initialCount = initialCount,
        incrementStep = incrementStep,
        goal = goal,
        dailyGoal = dailyGoal,
        startDate = startDate,
        createdAt = createdAt,
        status = status,
        disabledAt = disabledAt,
        disabledReason = disabledReason
    )
}

/**
 * Converts a JapaSessionEntity database object to a JapaSession data model
 * @return JapaSession data model with all fields populated
 */
fun JapaSessionEntity.toJapaSession(): JapaSession {
    return JapaSession(
        id = id,
        counterId = counterId,
        counterName = counterName,
        count = count,
        malas = malas,
        chants = chants,
        timestamp = timestamp,
        duration = duration
    )
}

/**
 * Converts a JapaSession data model to a JapaSessionEntity database object
 * @return JapaSessionEntity ready for database operations
 */
fun JapaSession.toEntity(): JapaSessionEntity {
    return JapaSessionEntity(
        id = id,
        counterId = counterId,
        counterName = counterName,
        count = count,
        malas = malas,
        chants = chants,
        timestamp = timestamp,
        duration = duration
    )
}
