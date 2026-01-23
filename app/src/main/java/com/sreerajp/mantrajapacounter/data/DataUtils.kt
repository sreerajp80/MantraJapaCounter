package com.sreerajp.mantrajapacounter.data

import android.content.SharedPreferences
import androidx.compose.runtime.snapshots.SnapshotStateList
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.text.SimpleDateFormat
import java.util.*

/**
 * Loads counters from SharedPreferences JSON storage into the provided list
 * @param prefs SharedPreferences instance to read from
 * @param counters SnapshotStateList to populate with loaded counters
 */
fun loadCounters(prefs: SharedPreferences, counters: SnapshotStateList<Counter>) {
    val gson = Gson()
    val json = prefs.getString("counters", null)
    if (json != null) {
        val type = object : TypeToken<List<Counter>>() {}.type
        val loadedCounters: List<Counter> = gson.fromJson(json, type)
        counters.clear()
        counters.addAll(loadedCounters)
    }
}

/**
 * Saves a list of counters to SharedPreferences as JSON
 * @param prefs SharedPreferences instance to write to
 * @param counters List of counters to save
 */
fun saveCounters(prefs: SharedPreferences, counters: List<Counter>) {
    val gson = Gson()
    val json = gson.toJson(counters)
    prefs.edit().putString("counters", json).apply()
}

/**
 * Loads sessions from SharedPreferences JSON storage into the provided list
 * @param prefs SharedPreferences instance to read from
 * @param sessions SnapshotStateList to populate with loaded sessions
 */
fun loadSessions(prefs: SharedPreferences, sessions: SnapshotStateList<JapaSession>) {
    val gson = Gson()
    val json = prefs.getString("sessions", null)
    if (json != null) {
        val type = object : TypeToken<List<JapaSession>>() {}.type
        val loadedSessions: List<JapaSession> = gson.fromJson(json, type)
        sessions.clear()
        sessions.addAll(loadedSessions)
    }
}

/**
 * Saves a list of sessions to SharedPreferences as JSON
 * @param prefs SharedPreferences instance to write to
 * @param sessions List of sessions to save
 */
fun saveSessions(prefs: SharedPreferences, sessions: List<JapaSession>) {
    val gson = Gson()
    val json = gson.toJson(sessions)
    prefs.edit().putString("sessions", json).apply()
}

/**
 * Formats elapsed time in milliseconds to a readable string (HH:MM:SS or MM:SS)
 * @param timeInMillis Duration in milliseconds
 * @return Formatted time string
 * @example formatTime(3661000) returns "01:01:01"
 */
fun formatTime(timeInMillis: Long): String {
    val seconds = (timeInMillis / 1000) % 60
    val minutes = (timeInMillis / (1000 * 60)) % 60
    val hours = (timeInMillis / (1000 * 60 * 60))
    return if (hours > 0) {
        String.format("%02d:%02d:%02d", hours, minutes, seconds)
    } else {
        String.format("%02d:%02d", minutes, seconds)
    }
}

/**
 * Formats time to a short string showing only minutes (e.g., "45m")
 * @param timeInMillis Duration in milliseconds
 * @return Formatted short time string
 * @example formatTimeShort(2700000) returns "45m"
 */
fun formatTimeShort(timeInMillis: Long): String {
    val minutes = (timeInMillis / (1000 * 60))
    return "${minutes}m"
}

/**
 * Formats timestamp to a readable date string (e.g., "Jan 23, 2025")
 * @param timestamp Milliseconds since epoch
 * @return Formatted date string
 */
fun formatDate(timestamp: Long): String {
    val sdf = SimpleDateFormat("MMM dd, yyyy", Locale.getDefault())
    return sdf.format(Date(timestamp))
}

/**
 * Formats timestamp to a readable date-time string (e.g., "Jan 23, 14:30")
 * @param timestamp Milliseconds since epoch
 * @return Formatted date-time string
 */
fun formatDateTime(timestamp: Long): String {
    val sdf = SimpleDateFormat("MMM dd, HH:mm", Locale.getDefault())
    return sdf.format(Date(timestamp))
}

/**
 * Calculates the progress towards a goal as a fraction between 0 and 1
 * @param currentCount The current count value
 * @param goal The target goal value (if 0, returns 0)
 * @return Progress as a float between 0 and 1, capped at 1.0
 * @example calculateGoalProgress(50, 100) returns 0.5
 */
fun calculateGoalProgress(currentCount: Int, goal: Int): Float {
    return if (goal > 0) {
        (currentCount.toFloat() / goal.toFloat()).coerceAtMost(1f)
    } else {
        0f
    }
}

/**
 * Checks if a goal has been reached or exceeded
 * @param currentCount The current count value
 * @param goal The target goal value
 * @return true if goal > 0 and currentCount >= goal, false otherwise
 */
fun isGoalReached(currentCount: Int, goal: Int): Boolean {
    return goal > 0 && currentCount >= goal
}
