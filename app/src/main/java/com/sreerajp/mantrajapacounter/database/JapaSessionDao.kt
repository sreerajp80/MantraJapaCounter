package com.sreerajp.mantrajapacounter.database

import androidx.room.*
import kotlinx.coroutines.flow.Flow

@Dao
interface JapaSessionDao {
    @Query("SELECT * FROM japa_sessions ORDER BY timestamp DESC")
    fun getAllSessions(): Flow<List<JapaSessionEntity>>

    @Query("SELECT * FROM japa_sessions WHERE counterId = :counterId ORDER BY timestamp DESC")
    fun getSessionsByCounterId(counterId: String): Flow<List<JapaSessionEntity>>

    @Query("SELECT * FROM japa_sessions WHERE timestamp >= :startTime AND timestamp < :endTime ORDER BY timestamp DESC")
    suspend fun getSessionsInTimeRange(startTime: Long, endTime: Long): List<JapaSessionEntity>

    @Query("SELECT SUM(count) FROM japa_sessions WHERE counterId = :counterId")
    suspend fun getTotalCountForCounter(counterId: String): Int?

    @Query("SELECT SUM(count) FROM japa_sessions WHERE counterId = :counterId AND timestamp >= :startTime")
    suspend fun getCountForCounterSince(counterId: String, startTime: Long): Int?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertSession(session: JapaSessionEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertSessions(sessions: List<JapaSessionEntity>)

    @Update
    suspend fun updateSession(session: JapaSessionEntity)

    @Delete
    suspend fun deleteSession(session: JapaSessionEntity)

    @Query("DELETE FROM japa_sessions WHERE counterId = :counterId")
    suspend fun deleteSessionsByCounterId(counterId: String)

    @Query("DELETE FROM japa_sessions")
    suspend fun deleteAllSessions()
}
