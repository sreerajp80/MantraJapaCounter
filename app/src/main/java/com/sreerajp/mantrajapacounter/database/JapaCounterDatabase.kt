package com.sreerajp.mantrajapacounter.database

import android.content.Context
import androidx.room.*
import androidx.room.migration.Migration
import androidx.sqlite.db.SupportSQLiteDatabase
import com.sreerajp.mantrajapacounter.data.CounterStatus

@Database(
    entities = [CounterEntity::class, JapaSessionEntity::class],
    version = 2,
    exportSchema = true
)
@TypeConverters(Converters::class)
abstract class JapaCounterDatabase : RoomDatabase() {
    abstract fun counterDao(): CounterDao
    abstract fun sessionDao(): JapaSessionDao

    companion object {
        @Volatile
        private var INSTANCE: JapaCounterDatabase? = null

        private val MIGRATION_1_2 = object : Migration(1, 2) {
            override fun migrate(database: SupportSQLiteDatabase) {
                // Add new columns with default values
                database.execSQL("ALTER TABLE counters ADD COLUMN status TEXT NOT NULL DEFAULT 'ACTIVE'")
                database.execSQL("ALTER TABLE counters ADD COLUMN disabledAt INTEGER DEFAULT NULL")
                database.execSQL("ALTER TABLE counters ADD COLUMN disabledReason TEXT DEFAULT NULL")
            }
        }

        fun getDatabase(context: Context): JapaCounterDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    JapaCounterDatabase::class.java,
                    "japa_counter_database"
                )
                    .addMigrations(MIGRATION_1_2)
                    .build()
                INSTANCE = instance
                instance
            }
        }
    }
}

// Type converters for CounterStatus enum
class Converters {
    @TypeConverter
    fun fromCounterStatus(status: CounterStatus): String {
        return status.name
    }

    @TypeConverter
    fun toCounterStatus(status: String): CounterStatus {
        return try {
            CounterStatus.valueOf(status)
        } catch (e: IllegalArgumentException) {
            CounterStatus.ACTIVE
        }
    }
}
