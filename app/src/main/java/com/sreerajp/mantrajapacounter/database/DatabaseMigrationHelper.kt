package com.sreerajp.mantrajapacounter.database

import android.content.Context
import android.content.SharedPreferences
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.sreerajp.mantrajapacounter.data.Counter
import com.sreerajp.mantrajapacounter.data.JapaSession
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class DatabaseMigrationHelper(
    private val context: Context,
    private val repository: JapaCounterRepository
) {
    private val prefs: SharedPreferences = context.getSharedPreferences("japa_counter", Context.MODE_PRIVATE)
    private val gson = Gson()

    suspend fun migrateFromSharedPreferences(): Boolean = withContext(Dispatchers.IO) {
        try {
            // Check if migration is needed
            if (prefs.getBoolean("migrated_to_sqlite", false)) {
                return@withContext true
            }

            // Load counters from SharedPreferences
            val countersJson = prefs.getString("counters", null)
            if (countersJson != null) {
                val type = object : TypeToken<List<Counter>>() {}.type
                val counters: List<Counter> = gson.fromJson(countersJson, type)

                // Insert counters into database
                counters.forEach { counter ->
                    repository.insertCounter(counter)
                }
            }

            // Load sessions from SharedPreferences
            val sessionsJson = prefs.getString("sessions", null)
            if (sessionsJson != null) {
                val type = object : TypeToken<List<JapaSession>>() {}.type
                val sessions: List<JapaSession> = gson.fromJson(sessionsJson, type)

                // Insert sessions into database
                sessions.forEach { session ->
                    repository.insertSession(session)
                }
            }

            // Mark as migrated
            prefs.edit().putBoolean("migrated_to_sqlite", true).apply()

            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
