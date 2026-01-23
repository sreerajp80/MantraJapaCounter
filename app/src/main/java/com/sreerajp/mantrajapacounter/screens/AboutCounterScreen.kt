package com.sreerajp.mantrajapacounter.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.TrendingUp
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.layout.systemBars
import androidx.compose.ui.graphics.vector.ImageVector
import com.sreerajp.mantrajapacounter.data.Counter
import com.sreerajp.mantrajapacounter.data.formatDate

/**
 * Composable screen for displaying detailed statistics about a specific counter
 * Shows lifetime totals, daily averages, goal progress, and other counter-specific metrics
 *
 * @param counter The counter to display statistics for
 * @param totalCount Lifetime total count for the counter
 * @param averageDailyCount Average daily count since counter creation
 * @param onBack Callback to return to main screen
 */
@Composable
fun AboutCounterScreen(
    counter: Counter,
    totalCount: Int,
    averageDailyCount: Double,
    onBack: () -> Unit
) {
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
        // Header
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
                text = "About Counter",
                color = Color.White,
                fontSize = 20.sp,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.width(48.dp))
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Counter Name Card
        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(
                containerColor = Color.White.copy(alpha = 0.2f)
            ),
            elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
        ) {
            Column(
                modifier = Modifier.padding(16.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Icon(
                    imageVector = Icons.Default.Psychology,
                    contentDescription = "Counter",
                    modifier = Modifier.size(48.dp),
                    tint = Color.White
                )
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = counter.name,
                    color = Color.White,
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Bold,
                    textAlign = TextAlign.Center
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Details Cards
        LazyColumn(
            verticalArrangement = Arrangement.spacedBy(12.dp),
            modifier = Modifier.weight(1f)
        ) {
            item {
                InfoCard(
                    icon = Icons.Default.CalendarToday,
                    title = "Start Date",
                    value = formatDate(counter.startDate)
                )
            }

            item {
                InfoCard(
                    icon = Icons.Default.Add,
                    title = "Increment Step",
                    value = counter.incrementStep.toString()
                )
            }

            item {
                InfoCard(
                    icon = Icons.Default.Numbers,
                    title = "Initial Count",
                    value = counter.initialCount.toString()
                )
            }

            item {
                InfoCard(
                    icon = Icons.AutoMirrored.Filled.TrendingUp,
                    title = "Total Count Done",
                    value = totalCount.toString()
                )
            }

            item {
                InfoCard(
                    icon = Icons.Default.BarChart,
                    title = "Average Daily Count",
                    value = String.format("%.1f", averageDailyCount)
                )
            }

            if (counter.goal > 0) {
                item {
                    InfoCard(
                        icon = Icons.Default.EmojiEvents,
                        title = "Lifetime Goal",
                        value = counter.goal.toString()
                    )
                }
            }

            if (counter.dailyGoal > 0) {
                item {
                    InfoCard(
                        icon = Icons.Default.Today,
                        title = "Daily Goal",
                        value = counter.dailyGoal.toString()
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))
    }
}

@Composable
private fun InfoCard(
    icon: ImageVector,
    title: String,
    value: String
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = Color.White.copy(alpha = 0.15f)
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                imageVector = icon,
                contentDescription = title,
                modifier = Modifier.size(24.dp),
                tint = Color.White.copy(alpha = 0.8f)
            )

            Spacer(modifier = Modifier.width(16.dp))

            Column(
                modifier = Modifier.weight(1f)
            ) {
                Text(
                    text = title,
                    color = Color.White.copy(alpha = 0.7f),
                    fontSize = 12.sp,
                    fontWeight = FontWeight.Medium
                )
                Text(
                    text = value,
                    color = Color.White,
                    fontSize = 16.sp,
                    fontWeight = FontWeight.SemiBold
                )
            }
        }
    }
}
