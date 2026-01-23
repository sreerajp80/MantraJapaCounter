package com.sreerajp.mantrajapacounter.database

import androidx.room.*
import kotlinx.coroutines.flow.Flow

/**
 * Data Access Object (DAO) for JapaSession entities
 * Provides database operations for storing, retrieving, and managing counting sessions
 */
@Dao
interface JapaSessionDao {
    /**
     * Retrieves all sessions from the database, ordered by timestamp (newest first)
     * @return Flow of list of all sessions
     */
    @Query("SELECT * FROM japa_sessions ORDER BY timestamp DESC")
    fun getAllSessions(): Flow<List<JapaSessionEntity>>

    /**
     * Retrieves all sessions for a specific counter, ordered by timestamp (newest first)
     * @param counterId The ID of the counter to filter sessions by
     * @return Flow of list of sessions for the counter
     */
    @Query("SELECT * FROM japa_sessions WHERE counterId = :counterId ORDER BY timestamp DESC")
    fun getSessionsByCounterId(counterId: String): Flow<List<JapaSessionEntity>>

    /**
     * Retrieves sessions that occurred within a specific time range
     * @param startTime Start of time range (milliseconds since epoch)
     * @param endTime End of time range (milliseconds since epoch)
     * @return List of sessions in the time range, ordered by timestamp (newest first)
     */
    @Query("SELECT * FROM japa_sessions WHERE timestamp >= :startTime AND timestamp < :endTime ORDER BY timestamp DESC")
    suspend fun getSessionsInTimeRange(startTime: Long, endTime: Long): List<JapaSessionEntity>

    /**
     * Calculates the total count for a specific counter across all sessions
     * @param counterId The ID of the counter
     * @return Total count, or null if no sessions exist
     */
    @Query("SELECT SUM(count) FROM japa_sessions WHERE counterId = :counterId")
    suspend fun getTotalCountForCounter(counterId: String): Int?

    /**
     * Calculates the count for a specific counter since a given timestamp
     * Useful for calculating today's count or other time-window statistics
     * @param counterId The ID of the counter
     * @param startTime Start time (milliseconds since epoch)
     * @return Sum of counts since startTime, or null if no sessions exist
     */
    @Query("SELECT SUM(count) FROM japa_sessions WHERE counterId = :counterId AND timestamp >= :startTime")
    suspend fun getCountForCounterSince(counterId: String, startTime: Long): Int?

    /**
     * Inserts a new session into the database
     * If a session with the same ID exists, it will be replaced
     * @param session The session entity to insert
     */
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertSession(session: JapaSessionEntity)

    /**
     * Inserts multiple sessions into the database
     * If sessions with same IDs exist, they will be replaced
     * @param sessions List of session entities to insert
     */
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertSessions(sessions: List<JapaSessionEntity>)

    /**
     * Updates an existing session in the database
     * @param session The session entity with updated values
     */
    @Update
    suspend fun updateSession(session: JapaSessionEntity)

    /**
     * Deletes a specific session from the database
     * @param session The session entity to delete
     */
    @Delete
    suspend fun deleteSession(session: JapaSessionEntity)

    /**
     * Deletes all sessions for a specific counter
     * @param counterId The ID of the counter whose sessions should be deleted
     */
    @Query("DELETE FROM japa_sessions WHERE counterId = :counterId")
    suspend fun deleteSessionsByCounterId(counterId: String)

    /**
     * Deletes all sessions from the database
     */
    @Query("DELETE FROM japa_sessions")
    suspend fun deleteAllSessions()
}
