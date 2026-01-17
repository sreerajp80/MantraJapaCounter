package com.sreerajp.mantrajapacounter.database

import android.content.Context
import androidx.room.*
import androidx.room.migration.Migration
import androidx.sqlite.db.SupportSQLiteDatabase
import com.sreerajp.mantrajapacounter.data.CounterStatus

@Database(
    entities = [CounterEntity::class, JapaSessionEntity::class],
    version = 3,
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
            override fun migrate(db: SupportSQLiteDatabase) {
                // Add new columns with default values
                db.execSQL("ALTER TABLE counters ADD COLUMN status TEXT NOT NULL DEFAULT 'ACTIVE'")
                db.execSQL("ALTER TABLE counters ADD COLUMN disabledAt INTEGER DEFAULT NULL")
                db.execSQL("ALTER TABLE counters ADD COLUMN disabledReason TEXT DEFAULT NULL")
            }
        }

        private val MIGRATION_2_3 = object : Migration(2, 3) {
            override fun migrate(db: SupportSQLiteDatabase) {
                db.execSQL("ALTER TABLE counters ADD COLUMN startDate INTEGER NOT NULL DEFAULT 0")
                db.execSQL("UPDATE counters SET startDate = createdAt WHERE startDate = 0")
            }
        }


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
        } catch (_: IllegalArgumentException) {
            CounterStatus.ACTIVE
        }
    }
}
