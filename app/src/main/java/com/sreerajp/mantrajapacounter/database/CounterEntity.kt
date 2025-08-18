package com.sreerajp.mantrajapacounter.database

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.sreerajp.mantrajapacounter.data.CounterStatus

@Entity(tableName = "counters")
data class CounterEntity(
    @PrimaryKey
    val id: String,
    val name: String,
    val initialCount: Int = 0,
    val incrementStep: Int = 1,
    val goal: Int = 0,
    val dailyGoal: Int = 0,
    val createdAt: Long = System.currentTimeMillis(),
    val status: CounterStatus = CounterStatus.ACTIVE,
    val disabledAt: Long? = null,
    val disabledReason: String? = null
)
