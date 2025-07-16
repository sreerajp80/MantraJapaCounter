package com.sreerajp.mantrajapacounter.data

import java.util.*

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
    val createdAt: Long = System.currentTimeMillis()
)

// Extension functions for goal calculations
fun Counter.hasLifetimeGoal(): Boolean = goal > 0
fun Counter.hasDailyGoal(): Boolean = dailyGoal > 0

fun Counter.getLifetimeProgress(totalCount: Int): Float {
    return if (hasLifetimeGoal()) {
        (totalCount.toFloat() / goal.toFloat()).coerceAtMost(1f)
    } else 0f
}

fun Counter.getDailyProgress(todayCount: Int): Float {
    return if (hasDailyGoal()) {
        (todayCount.toFloat() / dailyGoal.toFloat()).coerceAtMost(1f)
    } else 0f
}

fun Counter.isLifetimeGoalAchieved(totalCount: Int): Boolean {
    return hasLifetimeGoal() && totalCount >= goal
}

fun Counter.isDailyGoalAchieved(todayCount: Int): Boolean {
    return hasDailyGoal() && todayCount >= dailyGoal
}

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

data class DailySummary(
    val date: String,
    val totalCount: Int,
    val totalDuration: Long,
    val sessions: List<JapaSession>
)