package com.sreerajp.mantrajapacounter.database

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey

@Entity(
    tableName = "japa_sessions",
    foreignKeys = [
        ForeignKey(
            entity = CounterEntity::class,
            parentColumns = ["id"],
            childColumns = ["counterId"],
            onDelete = ForeignKey.CASCADE
        )
    ],
    indices = [Index("counterId"), Index("timestamp")]
)
data class JapaSessionEntity(
    @PrimaryKey
    val id: String,
    val counterId: String,
    val counterName: String,
    val count: Int,
    val malas: Int,
    val chants: Int,
    val timestamp: Long = System.currentTimeMillis(),
    val duration: Long = 0L
)
