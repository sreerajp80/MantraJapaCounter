package com.sreerajp.mantrajapacounter.database

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.sreerajp.mantrajapacounter.data.CounterStatus

/**
 * Room database entity representing a counter
 * Stores counter configuration and metadata in the "counters" table
 *
 * @param id Unique identifier (primary key) for the counter
 * @param name Display name of the counter
 * @param initialCount Starting count value (default 0)
 * @param incrementStep How much the count increases per tap (default 1)
 * @param goal Lifetime goal for total count (default 0 = no goal)
 * @param dailyGoal Daily goal for count per day (default 0 = no goal)
 * @param startDate When the counter started being tracked
 * @param createdAt When the counter was first created
 * @param status Current status (ACTIVE, DISABLED_SUCCESS, DISABLED_FAILURE)
 * @param disabledAt Timestamp when counter was disabled (null if active)
 * @param disabledReason Reason provided when counter was disabled (null if active)
 */
@Entity(tableName = "counters")
data class CounterEntity(
    @PrimaryKey
    val id: String,
    val name: String,
    val initialCount: Int = 0,
    val incrementStep: Int = 1,
    val goal: Int = 0,
    val dailyGoal: Int = 0,
    val startDate: Long = System.currentTimeMillis(),
    val createdAt: Long = System.currentTimeMillis(),
    val status: CounterStatus = CounterStatus.ACTIVE,
    val disabledAt: Long? = null,
    val disabledReason: String? = null
)
