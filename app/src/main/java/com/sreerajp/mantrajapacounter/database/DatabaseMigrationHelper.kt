package com.sreerajp.mantrajapacounter.database

import android.content.Context
import android.content.SharedPreferences
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.sreerajp.mantrajapacounter.data.Counter
import com.sreerajp.mantrajapacounter.data.JapaSession
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import androidx.core.content.edit

/**
 * Helper class for migrating counter and session data from SharedPreferences to Room database
 * Handles one-time migration of legacy data during app initialization
 *
 * @param context Android application context
 * @param repository Repository for database operations
 */
class DatabaseMigrationHelper(
    private val context: Context,
    private val repository: JapaCounterRepository
) {
    private val prefs: SharedPreferences = context.getSharedPreferences("japa_counter", Context.MODE_PRIVATE)
    private val gson = Gson()

    /**
     * Migrates all counter and session data from SharedPreferences (JSON) to Room database (SQLite)
     * Checks if migration has already been completed and skips if necessary
     * Fixes any invalid data during migration (e.g., zero timestamps)
     *
     * @return true if migration completed successfully or was already done, false if an error occurred
     */
    suspend fun migrateFromSharedPreferences(): Boolean = withContext(Dispatchers.IO) {
        try {
            // Check if migration has already been performed
            if (prefs.getBoolean("migrated_to_sqlite", false)) {
                return@withContext true
            }

            // Load and migrate counters from SharedPreferences JSON
            val countersJson = prefs.getString("counters", null)
            if (countersJson != null) {
                val type = object : TypeToken<List<Counter>>() {}.type
                val counters: List<Counter> = gson.fromJson(countersJson, type)

                // Insert each counter, fixing any data inconsistencies
                counters.forEach { counter ->
                    // Fix startDate if it's invalid (0 or unset)
                    val fixedCounter = if (counter.startDate == 0L) {
                        counter.copy(startDate = if (counter.createdAt > 0L) counter.createdAt else System.currentTimeMillis())
                    } else counter
                    repository.insertCounter(fixedCounter)
                }
            }

            // Load and migrate sessions from SharedPreferences JSON
            val sessionsJson = prefs.getString("sessions", null)
            if (sessionsJson != null) {
                val type = object : TypeToken<List<JapaSession>>() {}.type
                val sessions: List<JapaSession> = gson.fromJson(sessionsJson, type)

                // Insert all sessions into database
                sessions.forEach { session ->
                    repository.insertSession(session)
                }
            }

            // Mark migration as complete to prevent re-running
            prefs.edit { putBoolean("migrated_to_sqlite", true) }

            true
        } catch (e: Exception) {
            // Log error and return false to indicate migration failure
            e.printStackTrace()
            false
        }
    }
}
