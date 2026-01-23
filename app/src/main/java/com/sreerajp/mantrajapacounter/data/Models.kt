package com.sreerajp.mantrajapacounter.data

import java.util.*

/**
 * Enum representing the status of a counter
 * Used to track whether a counter is active or has been disabled (success/failure)
 */
enum class CounterStatus {
    ACTIVE,                 // Counter is currently in active use
    DISABLED_SUCCESS,       // Counter was disabled after achieving its goal
    DISABLED_FAILURE        // Counter was disabled without achieving the goal
}

/**
 * Data class representing a Mantra counter
 * Stores all counter configuration, progress, and metadata
 *
 * @param id Unique identifier for the counter (UUID)
 * @param name Display name of the counter (e.g., "Gayatri Mantra")
 * @param count Current count in the active session
 * @param malas Number of completed malas (count / 108)
 * @param chants Number of completed chants
 * @param initialCount Starting count value (default 0)
 * @param incrementStep How much the count increases per tap (default 1)
 * @param goal Lifetime goal for total count (0 = no goal)
 * @param dailyGoal Daily goal for count per day (0 = no goal)
 * @param startDate Timestamp when the counter started being tracked
 * @param createdAt Timestamp when the counter was first created
 * @param status Current status of the counter (ACTIVE, DISABLED_SUCCESS, DISABLED_FAILURE)
 * @param disabledAt Timestamp when the counter was disabled (null if active)
 * @param disabledReason Reason provided when counter was disabled
 */
data class Counter(
    val id: String = UUID.randomUUID().toString(),
    val name: String,
    val count: Int = 0,
    val malas: Int = 0,
    val chants: Int = 0,
    val initialCount: Int = 0,
    val incrementStep: Int = 1,
    val goal: Int = 0, // Lifetime goal (0 means no goal set)
    val dailyGoal: Int = 0, // Daily goal (0 means no daily goal set)
    val startDate: Long = System.currentTimeMillis(),
    val createdAt: Long = System.currentTimeMillis(),
    val status: CounterStatus = CounterStatus.ACTIVE,
    val disabledAt: Long? = null,
    val disabledReason: String? = null
)

/**
 * Extension function: Checks if the counter has a lifetime goal configured
 * @return true if goal > 0, false otherwise
 */
fun Counter.hasLifetimeGoal(): Boolean = goal > 0

/**
 * Extension function: Checks if the counter has a daily goal configured
 * @return true if dailyGoal > 0, false otherwise
 */
fun Counter.hasDailyGoal(): Boolean = dailyGoal > 0

/**
 * Extension function: Checks if the counter is currently active
 * @return true if status is ACTIVE, false otherwise
 */
fun Counter.isActive(): Boolean = status == CounterStatus.ACTIVE

/**
 * Extension function: Checks if the counter was disabled after success
 * @return true if status is DISABLED_SUCCESS, false otherwise
 */
fun Counter.isDisabledSuccess(): Boolean = status == CounterStatus.DISABLED_SUCCESS

/**
 * Extension function: Checks if the counter was disabled without achieving goal
 * @return true if status is DISABLED_FAILURE, false otherwise
 */
fun Counter.isDisabledFailure(): Boolean = status == CounterStatus.DISABLED_FAILURE

/**
 * Extension function: Calculates progress towards the lifetime goal (0.0 to 1.0)
 * @param totalCount The current total count for the counter
 * @return Progress as a float between 0 and 1, or 0 if no goal is set
 */
fun Counter.getLifetimeProgress(totalCount: Int): Float {
    return if (hasLifetimeGoal()) {
        (totalCount.toFloat() / goal.toFloat()).coerceAtMost(1f)
    } else 0f
}

/**
 * Extension function: Calculates progress towards the daily goal (0.0 to 1.0)
 * @param todayCount The count achieved today for the counter
 * @return Progress as a float between 0 and 1, or 0 if no daily goal is set
 */
fun Counter.getDailyProgress(todayCount: Int): Float {
    return if (hasDailyGoal()) {
        (todayCount.toFloat() / dailyGoal.toFloat()).coerceAtMost(1f)
    } else 0f
}

/**
 * Extension function: Checks if the lifetime goal has been achieved
 * @param totalCount The current total count for the counter
 * @return true if goal exists and totalCount >= goal, false otherwise
 */
fun Counter.isLifetimeGoalAchieved(totalCount: Int): Boolean {
    return hasLifetimeGoal() && totalCount >= goal
}

/**
 * Extension function: Checks if the daily goal has been achieved
 * @param todayCount The count achieved today for the counter
 * @return true if dailyGoal exists and todayCount >= dailyGoal, false otherwise
 */
fun Counter.isDailyGoalAchieved(todayCount: Int): Boolean {
    return hasDailyGoal() && todayCount >= dailyGoal
}

/**
 * Data class representing a single Japa counting session
 * Records one instance of mantra recitation with timing and count information
 *
 * @param id Unique identifier for the session (UUID)
 * @param counterId ID of the counter this session belongs to
 * @param counterName Display name of the counter at the time of session
 * @param count Number of chants completed in this session
 * @param malas Number of completed malas in this session (count / 108)
 * @param chants Number of completed chants in this session
 * @param timestamp When this session was recorded (milliseconds since epoch)
 * @param duration How long the session lasted (milliseconds)
 */
data class JapaSession(
    val id: String = UUID.randomUUID().toString(),
    val counterId: String = "",
    val counterName: String = "",
    val count: Int,
    val malas: Int,
    val chants: Int,
    val timestamp: Long = System.currentTimeMillis(),
    val duration: Long = 0L
)

/**
 * Data class representing a daily summary of counting activity
 * Aggregates all sessions and counts for a specific day
 *
 * @param date The date as a formatted string (e.g., "Jan 23, 2025")
 * @param totalCount Total number of chants completed that day
 * @param totalDuration Total time spent counting that day
 * @param sessions List of all sessions recorded on that day
 */
data class DailySummary(
    val date: String,
    val totalCount: Int,
    val totalDuration: Long,
    val sessions: List<JapaSession>
)
