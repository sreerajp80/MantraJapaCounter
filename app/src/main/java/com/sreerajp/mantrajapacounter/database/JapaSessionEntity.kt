package com.sreerajp.mantrajapacounter.database

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey

/**
 * Room database entity representing a counting session
 * Stores data for each individual mantra counting session in the "japa_sessions" table
 *
 * Foreign Key Relationships:
 * - counterId references CounterEntity.id with CASCADE delete
 *   (deleting a counter automatically deletes its sessions)
 *
 * Indices:
 * - counterId: For fast filtering by counter
 * - timestamp: For efficient time-range queries
 *
 * @param id Unique identifier (primary key) for the session
 * @param counterId Foreign key reference to the counter this session belongs to
 * @param counterName Display name of the counter (stored for history even if counter is deleted)
 * @param count Number of chants completed in this session
 * @param malas Number of completed malas in this session (count / 108)
 * @param chants Number of completed chants in this session
 * @param timestamp When this session was recorded (milliseconds since epoch)
 * @param duration How long the session lasted (milliseconds)
 */
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
