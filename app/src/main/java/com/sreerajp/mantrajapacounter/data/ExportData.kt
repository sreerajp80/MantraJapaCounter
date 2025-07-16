package com.sreerajp.mantrajapacounter.data

data class ExportData(
    val exportVersion: Int = 1,
    val exportDate: Long = System.currentTimeMillis(),
    val counters: List<Counter>,
    val sessions: List<JapaSession>
)
