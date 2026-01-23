package com.sreerajp.mantrajapacounter.data

/**
 * Data class representing exported counter and session data
 * Used for backup/restore and data sharing functionality
 *
 * @param exportVersion Version of the export format for compatibility checking
 * @param exportDate Timestamp when the data was exported (milliseconds since epoch)
 * @param counters List of all counters at the time of export
 * @param sessions List of all sessions at the time of export
 */
data class ExportData(
    val exportVersion: Int = 1,
    val exportDate: Long = System.currentTimeMillis(),
    val counters: List<Counter>,
    val sessions: List<JapaSession>
)
