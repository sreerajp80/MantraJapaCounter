package com.sreerajp.mantrajapacounter.database

import android.content.Context
import com.sreerajp.mantrajapacounter.data.*
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import java.util.*

class JapaCounterRepository(context: Context) {
    private val database = JapaCounterDatabase.getDatabase(context)
    private val counterDao = database.counterDao()
    private val sessionDao = database.sessionDao()

    // Counter operations
    fun getAllCounters(): Flow<List<Counter>> {
        return counterDao.getAllCounters().map { entities ->
            entities.map { it.toCounter() }
        }
    }

    suspend fun getCounterById(counterId: String): Counter? {
        return counterDao.getCounterById(counterId)?.toCounter()
    }

    suspend fun insertCounter(counter: Counter) {
        counterDao.insertCounter(counter.toEntity())
    }

    suspend fun updateCounter(counter: Counter) {
        counterDao.updateCounter(counter.toEntity())
    }

    suspend fun deleteCounter(counter: Counter) {
        counterDao.deleteCounter(counter.toEntity())
    }

    // Session operations
    fun getAllSessions(): Flow<List<JapaSession>> {
        return sessionDao.getAllSessions().map { entities ->
            entities.map { it.toJapaSession() }
        }
    }

    fun getSessionsByCounterId(counterId: String): Flow<List<JapaSession>> {
        return sessionDao.getSessionsByCounterId(counterId).map { entities ->
            entities.map { it.toJapaSession() }
        }
    }

    suspend fun getTodayCountForCounter(counterId: String): Int {
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        calendar.set(Calendar.MILLISECOND, 0)
        val todayStart = calendar.timeInMillis

        return sessionDao.getCountForCounterSince(counterId, todayStart) ?: 0
    }

    suspend fun getTotalCountForCounter(counterId: String): Int {
        return sessionDao.getTotalCountForCounter(counterId) ?: 0
    }

    suspend fun insertSession(session: JapaSession) {
        sessionDao.insertSession(session.toEntity())
    }

    suspend fun updateSession(session: JapaSession) {
        sessionDao.updateSession(session.toEntity())
    }

    suspend fun deleteSession(session: JapaSession) {
        sessionDao.deleteSession(session.toEntity())
    }

    suspend fun deleteSessionsByCounterId(counterId: String) {
        sessionDao.deleteSessionsByCounterId(counterId)
    }

    // Import/Export operations
    suspend fun exportData(): ExportData {
        val counters = counterDao.getAllCounters().first().map { it.toCounter() }
        val sessions = sessionDao.getAllSessions().first().map { it.toJapaSession() }

        return ExportData(
            counters = counters,
            sessions = sessions
        )
    }

    suspend fun importData(exportData: ExportData) {
        // Clear existing data
        sessionDao.deleteAllSessions()
        counterDao.deleteAllCounters()

        // Import new data
        counterDao.insertCounters(exportData.counters.map { it.toEntity() })
        sessionDao.insertSessions(exportData.sessions.map { it.toEntity() })
    }
}

// Extension functions to convert between entities and data models
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
        createdAt = createdAt
    )
}

fun Counter.toEntity(): CounterEntity {
    return CounterEntity(
        id = id,
        name = name,
        initialCount = initialCount,
        incrementStep = incrementStep,
        goal = goal,
        dailyGoal = dailyGoal,
        createdAt = createdAt
    )
}

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
