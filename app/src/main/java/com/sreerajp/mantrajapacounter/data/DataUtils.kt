package com.sreerajp.mantrajapacounter.data

import android.content.SharedPreferences
import androidx.compose.runtime.snapshots.SnapshotStateList
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.text.SimpleDateFormat
import java.util.*

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

fun saveCounters(prefs: SharedPreferences, counters: List<Counter>) {
    val gson = Gson()
    val json = gson.toJson(counters)
    prefs.edit().putString("counters", json).apply()
}

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

fun saveSessions(prefs: SharedPreferences, sessions: List<JapaSession>) {
    val gson = Gson()
    val json = gson.toJson(sessions)
    prefs.edit().putString("sessions", json).apply()
}

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

fun formatTimeShort(timeInMillis: Long): String {
    val minutes = (timeInMillis / (1000 * 60))
    return "${minutes}m"
}

fun formatDate(timestamp: Long): String {
    val sdf = SimpleDateFormat("MMM dd, yyyy", Locale.getDefault())
    return sdf.format(Date(timestamp))
}

fun formatDateTime(timestamp: Long): String {
    val sdf = SimpleDateFormat("MMM dd, HH:mm", Locale.getDefault())
    return sdf.format(Date(timestamp))
}

fun calculateGoalProgress(currentCount: Int, goal: Int): Float {
    return if (goal > 0) {
        (currentCount.toFloat() / goal.toFloat()).coerceAtMost(1f)
    } else {
        0f
    }
}

fun isGoalReached(currentCount: Int, goal: Int): Boolean {
    return goal > 0 && currentCount >= goal
}
