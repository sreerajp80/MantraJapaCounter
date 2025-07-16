package com.sreerajp.mantrajapacounter.database

import android.content.Context
import androidx.room.*

@Database(
    entities = [CounterEntity::class, JapaSessionEntity::class],
    version = 1,
    exportSchema = true
)
abstract class JapaCounterDatabase : RoomDatabase() {
    abstract fun counterDao(): CounterDao
    abstract fun sessionDao(): JapaSessionDao

    companion object {
        @Volatile
        private var INSTANCE: JapaCounterDatabase? = null

        fun getDatabase(context: Context): JapaCounterDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    JapaCounterDatabase::class.java,
                    "japa_counter_database"
                )
                    .fallbackToDestructiveMigration()
                    .build()
                INSTANCE = instance
                instance
            }
        }
    }
}
