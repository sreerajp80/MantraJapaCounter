package com.sreerajp.mantrajapacounter.database

import androidx.room.*
import kotlinx.coroutines.flow.Flow

@Dao
interface CounterDao {
    @Query("SELECT * FROM counters ORDER BY createdAt DESC")
    fun getAllCounters(): Flow<List<CounterEntity>>

    @Query("SELECT * FROM counters WHERE id = :counterId")
    suspend fun getCounterById(counterId: String): CounterEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertCounter(counter: CounterEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertCounters(counters: List<CounterEntity>)

    @Update
    suspend fun updateCounter(counter: CounterEntity)

    @Delete
    suspend fun deleteCounter(counter: CounterEntity)

    @Query("DELETE FROM counters")
    suspend fun deleteAllCounters()
}
