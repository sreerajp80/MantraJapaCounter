package com.sreerajp.mantrajapacounter.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.layout.systemBars
import androidx.compose.foundation.clickable
import androidx.compose.animation.animateContentSize
import androidx.compose.animation.core.tween
import com.sreerajp.mantrajapacounter.data.JapaSession
import com.sreerajp.mantrajapacounter.data.formatDateTime
import com.sreerajp.mantrajapacounter.data.formatTime
import java.text.SimpleDateFormat
import java.util.*
import androidx.compose.material.icons.automirrored.filled.ArrowBack

// Data class to represent a day's summary
data class DaySessionGroup(
    val date: String, // Formatted date string (e.g., "Today", "Yesterday", "Dec 15, 2024")
    val timestamp: Long, // For sorting
    val sessions: List<JapaSession>,
    val totalCount: Int,
    val totalMalas: Int,
    val totalDuration: Long,
    val sessionCount: Int
)

@Composable
fun HistoryScreen(
    sessions: List<JapaSession>,
    selectedCounterId: String? = null, // Filter by counter ID if provided
    onBack: () -> Unit,
    onClearHistory: (String?) -> Unit, // Pass counter ID to clear specific counter's history
    onDeleteSession: (JapaSession) -> Unit
) {
    var showClearDialog by remember { mutableStateOf(false) }
    var sessionToDelete by remember { mutableStateOf<JapaSession?>(null) }
    var expandedDays by remember { mutableStateOf(setOf<String>()) }

    // Filter sessions based on selected counter
    val filteredSessions = remember(sessions.size, selectedCounterId) {
        if (selectedCounterId != null) {
            sessions.filter { it.counterId == selectedCounterId }
        } else {
            sessions
        }
    }

    // Group sessions by day
    val dayGroups = remember(filteredSessions) {
        groupSessionsByDay(filteredSessions)
    }

    // Get counter name for title from filtered sessions
    val counterName = remember(filteredSessions) {
        filteredSessions.firstOrNull()?.counterName
    }

    val screenTitle = if (selectedCounterId != null && counterName != null) {
        "$counterName History"
    } else {
        "Session History"
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(
                Brush.verticalGradient(
                    colors = listOf(
                        Color(0xFF1E3A8A),
                        Color(0xFF0F766E)
                    )
                )
            )
            .windowInsetsPadding(WindowInsets.systemBars)
            .padding(16.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            IconButton(onClick = onBack) {
                Icon(
                    imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                    contentDescription = "Back",
                    tint = Color.White
                )
            }

            Text(
                text = screenTitle,
                color = Color.White,
                fontSize = 18.sp,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.weight(1f),
                textAlign = androidx.compose.ui.text.style.TextAlign.Center
            )

            if (filteredSessions.isNotEmpty()) {
                IconButton(onClick = { showClearDialog = true }) {
                    Icon(
                        imageVector = Icons.Default.Delete,
                        contentDescription = "Clear History",
                        tint = Color.White
                    )
                }
            } else {
                Spacer(modifier = Modifier.width(48.dp))
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        if (dayGroups.isEmpty()) {
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = if (selectedCounterId != null)
                        "No sessions recorded for this counter yet"
                    else
                        "No sessions recorded yet",
                    color = Color.White.copy(alpha = 0.7f),
                    fontSize = 16.sp
                )
            }
        } else {
            LazyColumn(
                verticalArrangement = Arrangement.spacedBy(12.dp),
                modifier = Modifier.fillMaxSize(),
                contentPadding = PaddingValues(bottom = 16.dp)
            ) {
                items(
                    items = dayGroups,
                    key = { dayGroup -> dayGroup.date }
                ) { dayGroup ->
                    DayGroupCard(
                        dayGroup = dayGroup,
                        isExpanded = expandedDays.contains(dayGroup.date),
                        showCounterName = selectedCounterId == null,
                        onToggleExpanded = {
                            expandedDays = if (expandedDays.contains(dayGroup.date)) {
                                expandedDays - dayGroup.date
                            } else {
                                expandedDays + dayGroup.date
                            }
                        },
                        onDeleteSession = { sessionToDelete = it }
                    )
                }
            }
        }
    }

    // Clear history dialog
    if (showClearDialog) {
        AlertDialog(
            onDismissRequest = { showClearDialog = false },
            title = { Text("Clear History") },
            text = {
                Text(
                    if (selectedCounterId != null)
                        "Are you sure you want to clear all session history for this counter? This will reduce the counter's total count and cannot be undone."
                    else
                        "Are you sure you want to clear all session history? This action cannot be undone."
                )
            },
            confirmButton = {
                TextButton(
                    onClick = {
                        onClearHistory(selectedCounterId)
                        showClearDialog = false
                    }
                ) {
                    Text("Clear", color = Color.Red)
                }
            },
            dismissButton = {
                TextButton(onClick = { showClearDialog = false }) {
                    Text("Cancel")
                }
            }
        )
    }

    // Delete single session dialog
    sessionToDelete?.let { session ->
        AlertDialog(
            onDismissRequest = { sessionToDelete = null },
            title = { Text("Delete Session") },
            text = {
                Text("Are you sure you want to delete this session? This will reduce the counter's total count by ${session.count} and cannot be undone.")
            },
            confirmButton = {
                TextButton(
                    onClick = {
                        onDeleteSession(session)
                        sessionToDelete = null
                    }
                ) {
                    Text("Delete", color = Color.Red)
                }
            },
            dismissButton = {
                TextButton(onClick = { sessionToDelete = null }) {
                    Text("Cancel")
                }
            }
        )
    }
}

@Composable
fun DayGroupCard(
    dayGroup: DaySessionGroup,
    isExpanded: Boolean,
    showCounterName: Boolean = true,
    onToggleExpanded: () -> Unit,
    onDeleteSession: (JapaSession) -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .animateContentSize(animationSpec = tween(300)),
        colors = CardDefaults.cardColors(
            containerColor = Color.White.copy(alpha = 0.95f)
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .clickable { onToggleExpanded() }
                .padding(16.dp)
        ) {
            // Day header with summary
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = dayGroup.date,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color.Black
                    )
                    Text(
                        text = "${dayGroup.sessionCount} session${if (dayGroup.sessionCount != 1) "s" else ""}",
                        fontSize = 12.sp,
                        color = Color.Gray
                    )
                }

                Icon(
                    imageVector = if (isExpanded) Icons.Default.ExpandLess else Icons.Default.ExpandMore,
                    contentDescription = if (isExpanded) "Collapse" else "Expand",
                    tint = Color.Gray
                )
            }

            Spacer(modifier = Modifier.height(8.dp))

            // Day summary stats
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(
                    text = "${dayGroup.totalCount} chants",
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Medium,
                    color = Color.Black
                )
                Text(
                    text = "${dayGroup.totalMalas} malas",
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Medium,
                    color = Color.Black
                )
                Text(
                    text = formatTime(dayGroup.totalDuration),
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Medium,
                    color = Color.Black
                )
            }

            // Expanded session details
            if (isExpanded) {
                Spacer(modifier = Modifier.height(12.dp))

                // Divider
                HorizontalDivider(
                    thickness = 1.dp,
                    color = Color.Gray.copy(alpha = 0.3f)
                )

                Spacer(modifier = Modifier.height(12.dp))

                // Individual sessions
                dayGroup.sessions.forEachIndexed { index, session ->
                    SessionRow(
                        session = session,
                        showCounterName = showCounterName,
                        onDeleteSession = onDeleteSession
                    )

                    if (index < dayGroup.sessions.size - 1) {
                        Spacer(modifier = Modifier.height(8.dp))
                    }
                }
            }
        }
    }
}

@Composable
fun SessionRow(
    session: JapaSession,
    showCounterName: Boolean = true,
    onDeleteSession: (JapaSession) -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(modifier = Modifier.weight(1f)) {
            if (showCounterName) {
                Text(
                    text = session.counterName,
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Medium,
                    color = Color.Black
                )
            }
            Text(
                text = formatDateTime(session.timestamp).split(" ").drop(1).joinToString(" "), // Remove date part, keep time
                fontSize = 12.sp,
                color = Color.Gray
            )

            Spacer(modifier = Modifier.height(4.dp))

            Row(
                horizontalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                Text(
                    text = "${session.count} chants",
                    fontSize = 12.sp,
                    color = Color.Black
                )
                Text(
                    text = "${session.malas} malas",
                    fontSize = 12.sp,
                    color = Color.Black
                )
                Text(
                    text = formatTime(session.duration),
                    fontSize = 12.sp,
                    color = Color.Black
                )
            }
        }

        IconButton(
            onClick = { onDeleteSession(session) },
            modifier = Modifier.size(32.dp)
        ) {
            Icon(
                imageVector = Icons.Default.Delete,
                contentDescription = "Delete Session",
                tint = Color.Red,
                modifier = Modifier.size(18.dp)
            )
        }
    }
}

// Helper function to group sessions by day
fun groupSessionsByDay(sessions: List<JapaSession>): List<DaySessionGroup> {
    val calendar = Calendar.getInstance()
    val today = Calendar.getInstance()
    val yesterday = Calendar.getInstance().apply { add(Calendar.DAY_OF_YEAR, -1) }

    val dateFormat = SimpleDateFormat("MMM dd, yyyy", Locale.getDefault())

    return sessions
        .groupBy { session ->
            calendar.timeInMillis = session.timestamp
            // Create a key based on year, month, and day
            "${calendar.get(Calendar.YEAR)}-${calendar.get(Calendar.MONTH)}-${calendar.get(Calendar.DAY_OF_MONTH)}"
        }
        .map { (_, sessionsInDay) ->
            val firstSession = sessionsInDay.first()
            calendar.timeInMillis = firstSession.timestamp

            val dateString = when {
                isSameDay(calendar, today) -> "Today"
                isSameDay(calendar, yesterday) -> "Yesterday"
                else -> dateFormat.format(Date(firstSession.timestamp))
            }

            DaySessionGroup(
                date = dateString,
                timestamp = firstSession.timestamp,
                sessions = sessionsInDay.sortedByDescending { it.timestamp }, // Most recent first within the day
                totalCount = sessionsInDay.sumOf { it.count },
                totalMalas = sessionsInDay.sumOf { it.malas },
                totalDuration = sessionsInDay.sumOf { it.duration },
                sessionCount = sessionsInDay.size
            )
        }
        .sortedByDescending { it.timestamp } // Most recent days first
}

// Helper function to check if two calendars represent the same day
fun isSameDay(cal1: Calendar, cal2: Calendar): Boolean {
    return cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR) &&
            cal1.get(Calendar.MONTH) == cal2.get(Calendar.MONTH) &&
            cal1.get(Calendar.DAY_OF_MONTH) == cal2.get(Calendar.DAY_OF_MONTH)
}