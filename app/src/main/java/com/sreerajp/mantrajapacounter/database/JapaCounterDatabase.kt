package com.sreerajp.mantrajapacounter.database

import android.content.Context
import androidx.room.*
import androidx.room.migration.Migration
import androidx.sqlite.db.SupportSQLiteDatabase
import com.sreerajp.mantrajapacounter.data.CounterStatus

/**
 * Room database configuration for MantraJapaCounter
 * Manages SQLite database for storing counters and sessions with automatic migrations
 *
 * Database Details:
 * - Name: japa_counter_database
 * - Entities: CounterEntity, JapaSessionEntity
 * - Version: 3 (with migrations from v1 and v2)
 * - Export Schema: true (for versioning support)
 */
@Database(
    entities = [CounterEntity::class, JapaSessionEntity::class],
    version = 3,
    exportSchema = true
)
@TypeConverters(Converters::class)
abstract class JapaCounterDatabase : RoomDatabase() {
    // ===== DATA ACCESS OBJECTS =====
    /**
     * DAO for counter operations
     */
    abstract fun counterDao(): CounterDao

    /**
     * DAO for session operations
     */
    abstract fun sessionDao(): JapaSessionDao

    companion object {
        @Volatile
        private var INSTANCE: JapaCounterDatabase? = null

        // ===== DATABASE MIGRATIONS =====
        /**
         * Migration from version 1 to 2
         * Adds counter status tracking fields (status, disabledAt, disabledReason)
         */
        private val MIGRATION_1_2 = object : Migration(1, 2) {
            override fun migrate(db: SupportSQLiteDatabase) {
                // Add new columns with default values for existing records
                db.execSQL("ALTER TABLE counters ADD COLUMN status TEXT NOT NULL DEFAULT 'ACTIVE'")
                db.execSQL("ALTER TABLE counters ADD COLUMN disabledAt INTEGER DEFAULT NULL")
                db.execSQL("ALTER TABLE counters ADD COLUMN disabledReason TEXT DEFAULT NULL")
            }
        }

        /**
         * Migration from version 2 to 3
         * Adds counter start date tracking for daily goal calculations
         * Populates startDate from createdAt if not already set
         */
        private val MIGRATION_2_3 = object : Migration(2, 3) {
            override fun migrate(db: SupportSQLiteDatabase) {
                db.execSQL("ALTER TABLE counters ADD COLUMN startDate INTEGER NOT NULL DEFAULT 0")
                db.execSQL("UPDATE counters SET startDate = createdAt WHERE startDate = 0")
            }
        }


        /**
         * Gets or creates the singleton database instance
         * Uses thread-safe double-checked locking pattern
         * @param context Android application context
         * @return JapaCounterDatabase singleton instance
         */
        fun getDatabase(context: Context): JapaCounterDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    JapaCounterDatabase::class.java,
                    "japa_counter_database"
                )
                    .addMigrations(MIGRATION_1_2, MIGRATION_2_3)
                    .build()
                INSTANCE = instance
                instance
            }
        }
    }
}

/**
 * Type converters for custom data types in Room database
 * Converts CounterStatus enum to/from String for database storage
 */
class Converters {
    /**
     * Converts CounterStatus enum to String for storage
     * @param status The CounterStatus enum value
     * @return String representation of the status
     */
    @TypeConverter
    fun fromCounterStatus(status: CounterStatus): String {
        return status.name
    }

    /**
     * Converts String to CounterStatus enum from storage
     * Handles invalid values gracefully by defaulting to ACTIVE
     * @param status The string value from database
     * @return CounterStatus enum value, or ACTIVE if invalid
     */
    @TypeConverter
    fun toCounterStatus(status: String): CounterStatus {
        return try {
            CounterStatus.valueOf(status)
        } catch (_: IllegalArgumentException) {
            CounterStatus.ACTIVE
        }
    }
}
