package com.sreerajp.mantrajapacounter.database

import androidx.room.*
import kotlinx.coroutines.flow.Flow

/**
 * Data Access Object (DAO) for Counter entities
 * Provides database operations for storing, retrieving, and managing counters
 */
@Dao
interface CounterDao {
    /**
     * Retrieves all counters from the database, ordered by creation date (newest first)
     * @return Flow of list of all counters
     */
    @Query("SELECT * FROM counters ORDER BY createdAt DESC")
    fun getAllCounters(): Flow<List<CounterEntity>>

    /**
     * Retrieves a specific counter by its ID
     * @param counterId The unique identifier of the counter
     * @return The counter entity if found, null otherwise
     */
    @Query("SELECT * FROM counters WHERE id = :counterId")
    suspend fun getCounterById(counterId: String): CounterEntity?

    /**
     * Inserts a new counter into the database
     * If a counter with the same ID exists, it will be replaced
     * @param counter The counter entity to insert
     */
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertCounter(counter: CounterEntity)

    /**
     * Inserts multiple counters into the database
     * If counters with same IDs exist, they will be replaced
     * @param counters List of counter entities to insert
     */
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertCounters(counters: List<CounterEntity>)

    /**
     * Updates an existing counter in the database
     * @param counter The counter entity with updated values
     */
    @Update
    suspend fun updateCounter(counter: CounterEntity)

    /**
     * Deletes a specific counter from the database
     * Associated sessions will be deleted due to foreign key cascade
     * @param counter The counter entity to delete
     */
    @Delete
    suspend fun deleteCounter(counter: CounterEntity)

    /**
     * Deletes all counters from the database
     * Associated sessions will be deleted due to foreign key cascade
     */
    @Query("DELETE FROM counters")
    suspend fun deleteAllCounters()
}
