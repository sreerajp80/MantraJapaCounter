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
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.ui.draw.clip
import com.sreerajp.mantrajapacounter.data.JapaSession
import com.sreerajp.mantrajapacounter.data.Counter
import com.sreerajp.mantrajapacounter.data.formatDateTime
import com.sreerajp.mantrajapacounter.data.formatTime
import java.text.SimpleDateFormat
import java.util.*
import androidx.compose.material.icons.automirrored.filled.ArrowBack

// Enhanced session data to include goal achievements
data class SessionWithGoalStatus(
    val session: JapaSession,
    val achievedDailyGoal: Boolean = false,
    val achievedLifetimeGoal: Boolean = false,
    val cumulativeCount: Int = 0,
    val dailyCountBeforeSession: Int = 0,
    val totalCountBeforeSession: Int = 0
)

// Enhanced data class to include both daily and lifetime goal status
data class DaySessionGroup(
    val date: String,
    val timestamp: Long,
    val sessions: List<SessionWithGoalStatus>,
    val totalCount: Int,
    val totalMalas: Int,
    val totalDuration: Long,
    val sessionCount: Int,
    val dailyGoalAchieved: Boolean = false,
    val dailyGoalProgress: Float = 0f,
    val dailyGoalTarget: Int = 0,
    // New fields for lifetime goal
    val lifetimeGoalTarget: Int = 0,
    val cumulativeCountUpToDay: Int = 0,
    val lifetimeGoalProgress: Float = 0f,
    val lifetimeGoalAchieved: Boolean = false
)

// Data class to hold counter information with goals
data class CounterGoalInfo(
    val counter: Counter,
    val totalCount: Int,
    val lifetimeGoalAchieved: Boolean,
    val lifetimeGoalProgress: Float,
    val lifetimeGoalAchievedInSession: String? = null // Session ID where goal was achieved
)

@Composable
fun HistoryScreen(
    sessions: List<JapaSession>,
    counters: List<Counter>,
    selectedCounterId: String? = null,
    onBack: () -> Unit,
    onClearHistory: (String?) -> Unit,
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

    // Get counter information for goals
    val counterGoalInfo = remember(counters, filteredSessions, selectedCounterId) {
        if (selectedCounterId != null) {
            val counter = counters.find { it.id == selectedCounterId }
            if (counter != null) {
                val totalCount = filteredSessions.sumOf { it.count }

                // Find which session achieved the lifetime goal
                var lifetimeGoalSessionId: String? = null
                if (counter.goal > 0) {
                    var runningTotal = 0
                    // Sort sessions by timestamp to find when goal was first achieved
                    val sortedSessions = filteredSessions.sortedBy { it.timestamp }
                    for (session in sortedSessions) {
                        runningTotal += session.count
                        if (runningTotal >= counter.goal) {
                            lifetimeGoalSessionId = session.id
                            break
                        }
                    }
                }

                CounterGoalInfo(
                    counter = counter,
                    totalCount = totalCount,
                    lifetimeGoalAchieved = counter.goal > 0 && totalCount >= counter.goal,
                    lifetimeGoalProgress = if (counter.goal > 0) (totalCount.toFloat() / counter.goal.toFloat()).coerceAtMost(1f) else 0f,
                    lifetimeGoalAchievedInSession = lifetimeGoalSessionId
                )
            } else null
        } else null
    }

    // Group sessions by day with goal information
    val dayGroups = remember(filteredSessions, counterGoalInfo) {
        groupSessionsByDayWithGoals(filteredSessions, counterGoalInfo?.counter, counterGoalInfo?.lifetimeGoalAchievedInSession)
    }

    val screenTitle = if (selectedCounterId != null && counterGoalInfo != null) {
        "${counterGoalInfo.counter.name} History"
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

        // Show lifetime goal status for specific counter
        if (counterGoalInfo != null && counterGoalInfo.counter.goal > 0) {
            LifetimeGoalCard(counterGoalInfo = counterGoalInfo)
            Spacer(modifier = Modifier.height(12.dp))
        }

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
fun LifetimeGoalCard(counterGoalInfo: CounterGoalInfo) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = if (counterGoalInfo.lifetimeGoalAchieved)
                Color(0xFF4CAF50).copy(alpha = 0.9f)
            else
                Color.White.copy(alpha = 0.95f)
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Lifetime Goal",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold,
                    color = if (counterGoalInfo.lifetimeGoalAchieved) Color.White else Color.Black
                )

                if (counterGoalInfo.lifetimeGoalAchieved) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Default.CheckCircle,
                            contentDescription = "Goal Achieved",
                            tint = Color.White,
                            modifier = Modifier.size(20.dp)
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Text(
                            text = "Achieved!",
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Medium,
                            color = Color.White
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                text = "${counterGoalInfo.totalCount} / ${counterGoalInfo.counter.goal} chants",
                fontSize = 14.sp,
                color = if (counterGoalInfo.lifetimeGoalAchieved) Color.White.copy(alpha = 0.9f) else Color.Black
            )

            if (!counterGoalInfo.lifetimeGoalAchieved) {
                Spacer(modifier = Modifier.height(8.dp))

                LinearProgressIndicator(
                    progress = { counterGoalInfo.lifetimeGoalProgress },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(8.dp)
                        .clip(RoundedCornerShape(4.dp)),
                    color = Color(0xFF4CAF50),
                    trackColor = Color.Gray.copy(alpha = 0.3f)
                )

                Spacer(modifier = Modifier.height(4.dp))

                Text(
                    text = "${(counterGoalInfo.lifetimeGoalProgress * 100).toInt()}% complete",
                    fontSize = 12.sp,
                    color = Color.Gray
                )
            }
        }
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
                    Row(
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = dayGroup.date,
                            fontSize = 16.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color.Black
                        )

                        // Goal achievement indicators
                        if (dayGroup.lifetimeGoalTarget > 0 || dayGroup.dailyGoalTarget > 0) {
                            Spacer(modifier = Modifier.width(8.dp))

                            if (dayGroup.lifetimeGoalAchieved) {
                                Icon(
                                    imageVector = Icons.Default.EmojiEvents,
                                    contentDescription = "Lifetime Goal Achieved",
                                    tint = Color(0xFFFF9800),
                                    modifier = Modifier.size(16.dp)
                                )
                            }

                            if (dayGroup.dailyGoalAchieved) {
                                Icon(
                                    imageVector = Icons.Default.CheckCircle,
                                    contentDescription = "Daily Goal Achieved",
                                    tint = Color(0xFF4CAF50),
                                    modifier = Modifier.size(16.dp)
                                )
                            }
                        }
                    }

                    Text(
                        text = "${dayGroup.sessionCount} session${if (dayGroup.sessionCount != 1) "s" else ""}",
                        fontSize = 12.sp,
                        color = Color.Gray
                    )

                    // Daily goal progress text
                    if (dayGroup.dailyGoalTarget > 0) {
                        Text(
                            text = "Daily goal: ${dayGroup.totalCount}/${dayGroup.dailyGoalTarget} " +
                                    if (dayGroup.dailyGoalAchieved) "✓" else "(${(dayGroup.dailyGoalProgress * 100).toInt()}%)",
                            fontSize = 11.sp,
                            color = if (dayGroup.dailyGoalAchieved) Color(0xFF4CAF50) else Color.Gray,
                            fontWeight = if (dayGroup.dailyGoalAchieved) FontWeight.Medium else FontWeight.Normal
                        )
                    }

                    // Lifetime goal progress text
                    if (dayGroup.lifetimeGoalTarget > 0) {
                        Text(
                            text = "Lifetime goal: ${dayGroup.cumulativeCountUpToDay}/${dayGroup.lifetimeGoalTarget} " +
                                    if (dayGroup.lifetimeGoalAchieved) "✓" else "(${(dayGroup.lifetimeGoalProgress * 100).toInt()}%)",
                            fontSize = 11.sp,
                            color = if (dayGroup.lifetimeGoalAchieved) Color(0xFFFF9800) else Color.Gray,
                            fontWeight = if (dayGroup.lifetimeGoalAchieved) FontWeight.Medium else FontWeight.Normal
                        )
                    }
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
                dayGroup.sessions.forEachIndexed { index, sessionWithStatus ->
                    SessionRow(
                        sessionWithStatus = sessionWithStatus,
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
    sessionWithStatus: SessionWithGoalStatus,
    showCounterName: Boolean = true,
    onDeleteSession: (JapaSession) -> Unit
) {
    val session = sessionWithStatus.session

    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                if (showCounterName) {
                    Text(
                        text = session.counterName,
                        fontSize = 14.sp,
                        fontWeight = FontWeight.Medium,
                        color = Color.Black
                    )
                }

                // Show goal achievement badges
                if (sessionWithStatus.achievedDailyGoal || sessionWithStatus.achievedLifetimeGoal) {
                    Spacer(modifier = Modifier.width(8.dp))
                    Row(
                        horizontalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        if (sessionWithStatus.achievedDailyGoal) {
                            Card(
                                colors = CardDefaults.cardColors(
                                    containerColor = Color(0xFF4CAF50)
                                ),
                                shape = RoundedCornerShape(4.dp),
                                modifier = Modifier.padding(vertical = 2.dp)
                            ) {
                                Text(
                                    text = "Daily Goal ✓",
                                    fontSize = 10.sp,
                                    color = Color.White,
                                    fontWeight = FontWeight.Medium,
                                    modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                                )
                            }
                        }

                        if (sessionWithStatus.achievedLifetimeGoal) {
                            Card(
                                colors = CardDefaults.cardColors(
                                    containerColor = Color(0xFFFF9800)
                                ),
                                shape = RoundedCornerShape(4.dp),
                                modifier = Modifier.padding(vertical = 2.dp)
                            ) {
                                Text(
                                    text = "Lifetime Goal ✓",
                                    fontSize = 10.sp,
                                    color = Color.White,
                                    fontWeight = FontWeight.Medium,
                                    modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                                )
                            }
                        }
                    }
                }
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

// Enhanced helper function to group sessions by day with goal information
fun groupSessionsByDayWithGoals(
    sessions: List<JapaSession>,
    counter: Counter?,
    lifetimeGoalAchievedInSession: String?
): List<DaySessionGroup> {
    val calendar = Calendar.getInstance()
    val today = Calendar.getInstance()
    val yesterday = Calendar.getInstance().apply { add(Calendar.DAY_OF_YEAR, -1) }

    val dateFormat = SimpleDateFormat("MMM dd, yyyy", Locale.getDefault())

    // Calculate cumulative counts
    var totalCumulativeCount = 0
    val sortedSessions = sessions.sortedBy { it.timestamp }
    val sessionWithCumulativeCounts = mutableMapOf<String, Pair<Int, Int>>() // sessionId to (totalBefore, dailyBefore)

    // Group by day to calculate daily cumulative counts
    val dailyCounts = mutableMapOf<String, Int>()
    val cumulativeCountsByDay = mutableMapOf<String, Int>()

    sortedSessions.forEach { session ->
        calendar.timeInMillis = session.timestamp
        val dayKey = "${calendar.get(Calendar.YEAR)}-${calendar.get(Calendar.MONTH)}-${calendar.get(Calendar.DAY_OF_MONTH)}"

        val dailyCountBefore = dailyCounts[dayKey] ?: 0
        sessionWithCumulativeCounts[session.id] = Pair(totalCumulativeCount, dailyCountBefore)

        totalCumulativeCount += session.count
        dailyCounts[dayKey] = dailyCountBefore + session.count
        cumulativeCountsByDay[dayKey] = totalCumulativeCount
    }

    return sessions
        .groupBy { session ->
            calendar.timeInMillis = session.timestamp
            "${calendar.get(Calendar.YEAR)}-${calendar.get(Calendar.MONTH)}-${calendar.get(Calendar.DAY_OF_MONTH)}"
        }
        .map { (dayKey, sessionsInDay) ->
            val firstSession = sessionsInDay.first()
            calendar.timeInMillis = firstSession.timestamp

            val dateString = when {
                isSameDay(calendar, today) -> "Today"
                isSameDay(calendar, yesterday) -> "Yesterday"
                else -> dateFormat.format(Date(firstSession.timestamp))
            }

            val dailyGoal = counter?.dailyGoal ?: 0
            val lifetimeGoal = counter?.goal ?: 0
            val cumulativeCount = cumulativeCountsByDay[dayKey] ?: 0

            // Process sessions for this day to determine goal achievements
            val sessionsWithStatus = sessionsInDay.sortedBy { it.timestamp }.map { session ->
                val (totalBefore, dailyBefore) = sessionWithCumulativeCounts[session.id] ?: Pair(0, 0)

                val achievedDailyGoal = dailyGoal > 0 &&
                        dailyBefore < dailyGoal &&
                        (dailyBefore + session.count) >= dailyGoal

                val achievedLifetimeGoal = session.id == lifetimeGoalAchievedInSession

                SessionWithGoalStatus(
                    session = session,
                    achievedDailyGoal = achievedDailyGoal,
                    achievedLifetimeGoal = achievedLifetimeGoal,
                    cumulativeCount = totalBefore + session.count,
                    dailyCountBeforeSession = dailyBefore,
                    totalCountBeforeSession = totalBefore
                )
            }.sortedByDescending { it.session.timestamp } // Show most recent first within day

            val totalCount = sessionsInDay.sumOf { it.count }

            DaySessionGroup(
                date = dateString,
                timestamp = firstSession.timestamp,
                sessions = sessionsWithStatus,
                totalCount = totalCount,
                totalMalas = sessionsInDay.sumOf { it.malas },
                totalDuration = sessionsInDay.sumOf { it.duration },
                sessionCount = sessionsInDay.size,
                dailyGoalAchieved = dailyGoal > 0 && totalCount >= dailyGoal,
                dailyGoalProgress = if (dailyGoal > 0) (totalCount.toFloat() / dailyGoal.toFloat()).coerceAtMost(1f) else 0f,
                dailyGoalTarget = dailyGoal,
                lifetimeGoalTarget = lifetimeGoal,
                cumulativeCountUpToDay = cumulativeCount,
                lifetimeGoalProgress = if (lifetimeGoal > 0) (cumulativeCount.toFloat() / lifetimeGoal.toFloat()).coerceAtMost(1f) else 0f,
                lifetimeGoalAchieved = lifetimeGoal > 0 && cumulativeCount >= lifetimeGoal
            )
        }
        .sortedByDescending { it.timestamp }
}

// Helper function to check if two calendars represent the same day
fun isSameDay(cal1: Calendar, cal2: Calendar): Boolean {
    return cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR) &&
            cal1.get(Calendar.MONTH) == cal2.get(Calendar.MONTH) &&
            cal1.get(Calendar.DAY_OF_MONTH) == cal2.get(Calendar.DAY_OF_MONTH)
}
