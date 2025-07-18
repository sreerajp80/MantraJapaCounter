package com.sreerajp.mantrajapacounter.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Shadow
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.layout.systemBars
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.foundation.gestures.detectTapGestures
import com.sreerajp.mantrajapacounter.data.Counter
import com.sreerajp.mantrajapacounter.data.*
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.material.icons.automirrored.filled.ArrowBack

@Composable
fun CountingScreen(
    counter: Counter?,
    currentTapCount: Int,
    sessionTotalTaps: Int,
    elapsedTime: Long,
    lifetimeTotal: Int,
    todayTotal: Int,
    onCountClick: () -> Unit,
    onDecrementClick: () -> Unit,
    onBack: () -> Unit,
    onShowHistory: (String?) -> Unit,
    onShowAbout: () -> Unit,
    onReset: () -> Unit,
    onResetCounter: () -> Unit
) {
    var showMenu by remember { mutableStateOf(false) }

    // Use extension functions for goal calculations
    val isLifetimeGoalReached = counter?.isLifetimeGoalAchieved(lifetimeTotal) ?: false
    val isDailyGoalReached = counter?.isDailyGoalAchieved(todayTotal) ?: false
    val lifetimeProgress = counter?.getLifetimeProgress(lifetimeTotal) ?: 0f
    val dailyProgress = counter?.getDailyProgress(todayTotal) ?: 0f

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                // Change background gradient when any goal is reached
                if (isLifetimeGoalReached || isDailyGoalReached) {
                    Brush.verticalGradient(
                        colors = listOf(
                            Color(0xFF059669), // Success green
                            Color(0xFF047857)
                        )
                    )
                } else {
                    Brush.verticalGradient(
                        colors = listOf(
                            Color(0xFF1E3A8A),
                            Color(0xFF0F766E)
                        )
                    )
                }
            )
            .windowInsetsPadding(WindowInsets.systemBars)
    ) {
        Column(
            modifier = Modifier.fillMaxSize(),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            // Top section with header and goal progress
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                // Top bar with goal achievement indicator
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(top = 16.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    IconButton(onClick = onBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back",
                            tint = Color.White,
                            modifier = Modifier.size(24.dp)
                        )
                    }

                    // Show goal achievement status
                    when {
                        isLifetimeGoalReached -> {
                            Row(
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.spacedBy(4.dp)
                            ) {
                                Icon(
                                    imageVector = Icons.Default.EmojiEvents,
                                    contentDescription = "Lifetime Goal Achieved",
                                    tint = Color(0xFFFFD700), // Gold color
                                    modifier = Modifier.size(20.dp)
                                )
                                Text(
                                    text = "LIFETIME GOAL ACHIEVED! - ${formatTime(elapsedTime)}",
                                    color = Color(0xFFFFD700),
                                    fontSize = 12.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }
                        }
                        isDailyGoalReached -> {
                            Row(
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.spacedBy(4.dp)
                            ) {
                                Icon(
                                    imageVector = Icons.Default.Today,
                                    contentDescription = "Daily Goal Achieved",
                                    tint = Color(0xFF00FF7F), // Spring green
                                    modifier = Modifier.size(20.dp)
                                )
                                Text(
                                    text = "DAILY GOAL ACHIEVED! - ${formatTime(elapsedTime)}",
                                    color = Color(0xFF00FF7F),
                                    fontSize = 12.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }
                        }
                        else -> {
                            Text(
                                text = formatTime(elapsedTime),
                                color = Color.White,
                                fontSize = 18.sp
                            )
                        }
                    }

                    IconButton(onClick = { showMenu = !showMenu }) {
                        Icon(
                            imageVector = Icons.Default.Menu,
                            contentDescription = "Menu",
                            tint = Color.White,
                            modifier = Modifier.size(24.dp)
                        )
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))

                // Counter name and decrement button row
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column {
                        Text(
                            text = counter?.name ?: "No Counter Selected",
                            color = Color.White.copy(alpha = 0.8f),
                            fontSize = 16.sp
                        )
                        // Show increment step if it's not default
                        counter?.let {
                            if (it.incrementStep != 1) {
                                Text(
                                    text = "Step: +${it.incrementStep}",
                                    color = Color.White.copy(alpha = 0.6f),
                                    fontSize = 12.sp
                                )
                            }
                        }
                    }

                    FloatingActionButton(
                        onClick = onDecrementClick,
                        containerColor = Color(0xFFDC2626),
                        modifier = Modifier.size(48.dp)
                    ) {
                        Icon(
                            imageVector = Icons.Default.Remove,
                            contentDescription = "Decrement",
                            tint = Color.White,
                            modifier = Modifier.size(20.dp)
                        )
                    }
                }

                Spacer(modifier = Modifier.height(10.dp))

                // Enhanced Goal Progress Cards
                counter?.let { counter ->
                    val hasLifetimeGoal = counter.hasLifetimeGoal()
                    val hasDailyGoal = counter.hasDailyGoal()

                    if (hasLifetimeGoal || hasDailyGoal) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            // Lifetime Goal Progress
                            if (hasLifetimeGoal) {
                                GoalProgressCard(
                                    title = if (isLifetimeGoalReached) "Lifetime!" else "Lifetime",
                                    progress = lifetimeProgress,
                                    current = lifetimeTotal,
                                    target = counter.goal,
                                    isComplete = isLifetimeGoalReached,
                                    icon = Icons.Default.EmojiEvents,
                                    modifier = Modifier.weight(1f)
                                )
                            }

                            // Daily Goal Progress
                            if (hasDailyGoal) {
                                GoalProgressCard(
                                    title = if (isDailyGoalReached) "Daily!" else "Daily",
                                    progress = dailyProgress,
                                    current = todayTotal,
                                    target = counter.dailyGoal,
                                    isComplete = isDailyGoalReached,
                                    icon = Icons.Default.Today,
                                    modifier = Modifier.weight(1f)
                                )
                            }
                        }
                        Spacer(modifier = Modifier.height(8.dp))
                    }
                }
            }

            // Main count area with celebration effect
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f)
                    .clip(RoundedCornerShape(20.dp))
                    .background(
                        if (isLifetimeGoalReached) {
                            Brush.radialGradient(
                                colors = listOf(
                                    Color(0xFFFF9933), // Gold
                                    Color(0xFFE67E00)  // Dark orange
                                )
                            )
                        } else if (isDailyGoalReached) {
                            Brush.radialGradient(
                                colors = listOf(
                                    Color(0xFFFF9933), // Spring green
                                    Color(0xFFE67E00)  // Lime green
                                )
                            )
                        } else {
                            Brush.radialGradient(
                                colors = listOf(
                                    Color(0xFFFF9933),
                                    Color(0xFFE67E00)
                                )
                            )
                        }
                    )
                    .clickable { onCountClick() },
                contentAlignment = Alignment.Center
            ) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    // Add celebration emoji for goal achievement
                    when {
                        isLifetimeGoalReached -> {
                            Text(
                                text = "🎉 🏆 🎉",
                                fontSize = 24.sp,
                                color = Color.White
                            )
                            Spacer(modifier = Modifier.height(8.dp))
                        }
                        isDailyGoalReached -> {
                            Text(
                                text = "🌟 ✨ 🌟",
                                fontSize = 24.sp,
                                color = Color.White
                            )
                            Spacer(modifier = Modifier.height(8.dp))
                        }
                    }

                    Text(
                        text = currentTapCount.toString(),
                        color = Color.White,
                        fontSize = 100.sp,
                        fontWeight = FontWeight.Bold,
                        style = TextStyle(
                            shadow = Shadow(
                                color = Color.Black.copy(alpha = 0.9f),
                                offset = Offset(4f, 4f),
                                blurRadius = 8f
                            )
                        )
                    )

                    counter?.let {
                        if (it.incrementStep != 1) {
                            Text(
                                text = "+${it.incrementStep}",
                                color = Color.Black.copy(alpha = 0.8f),
                                fontSize = 16.sp,
                                fontWeight = FontWeight.Bold
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    // Session and Today stats
                    Card(
                        modifier = Modifier
                            .padding(horizontal = 16.dp)
                            .shadow(
                                elevation = 10.dp,
                                shape = RoundedCornerShape(12.dp)
                            )
                            .clip(RoundedCornerShape(12.dp)),
                        colors = CardDefaults.cardColors(
                            containerColor = when {
                                isLifetimeGoalReached -> Color(0xFFFFF8DC).copy(alpha = 0.95f) // Light golden
                                isDailyGoalReached -> Color(0xF0FFF0).copy(alpha = 0.95f) // Honeydew
                                else -> Color(0xFFFFE5B4).copy(alpha = 0.95f)
                            }
                        )
                    ) {
                        Column(
                            modifier = Modifier.padding(16.dp),
                            horizontalAlignment = Alignment.CenterHorizontally,
                            verticalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            Row(
                                horizontalArrangement = Arrangement.spacedBy(24.dp)
                            ) {
                                Text(
                                    text = "Session Count: $sessionTotalTaps",
                                    color = Color.Black,
                                    fontSize = 13.sp,
                                    fontWeight = FontWeight.ExtraBold
                                )
                                Text(
                                    text = "Session Mala: ${sessionTotalTaps / 108}",
                                    color = Color.Black,
                                    fontSize = 13.sp,
                                    fontWeight = FontWeight.ExtraBold
                                )
                            }
                            Row(
                                horizontalArrangement = Arrangement.spacedBy(24.dp)
                            ) {
                                Text(
                                    text = "Today's Count: $todayTotal",
                                    color = Color.Black,
                                    fontSize = 13.sp,
                                    fontWeight = FontWeight.ExtraBold
                                )
                                Text(
                                    text = "Today's Mala: ${todayTotal / 108}",
                                    color = Color.Black,
                                    fontSize = 13.sp,
                                    fontWeight = FontWeight.ExtraBold
                                )
                            }
                        }
                    }
                }
            }

            // Bottom stats with goal achievement highlighting
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp)
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 8.dp),
                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    StatCard(
                        label = "Total Mala",
                        value = (lifetimeTotal / 108).toString(),
                        modifier = Modifier.weight(1f),
                        isHighlighted = isLifetimeGoalReached
                    )
                    StatCard(
                        label = "Total Count",
                        value = lifetimeTotal.toString(),
                        modifier = Modifier.weight(1f),
                        isHighlighted = isLifetimeGoalReached
                    )
                }

                Spacer(modifier = Modifier.height(8.dp))
            }
        }

        // Menu overlay
        if (showMenu) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(Color.Transparent)
                    .pointerInput(Unit) {
                        detectTapGestures(onTap = { showMenu = false })
                    }
            )

            Card(
                modifier = Modifier
                    .align(Alignment.TopEnd)
                    .padding(top = 60.dp, end = 16.dp)
                    .width(180.dp),
                colors = CardDefaults.cardColors(
                    containerColor = Color.White.copy(alpha = 0.95f)
                ),
                elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
            ) {
                Column(modifier = Modifier.padding(8.dp)) {
                    MenuRow(
                        icon = Icons.Default.History,
                        text = "History",
                        color = Color.Black,
                        onClick = {
                            onShowHistory(counter?.id)
                            showMenu = false
                        }
                    )

                    MenuDivider()

                    MenuRow(
                        icon = Icons.Default.Info,
                        text = "About",
                        color = Color.Blue,
                        onClick = {
                            onShowAbout()
                            showMenu = false
                        }
                    )

                    MenuDivider()

                    MenuRow(
                        icon = Icons.Default.Refresh,
                        text = "Reset Session",
                        color = Color.Red,
                        onClick = {
                            onReset()
                            showMenu = false
                        }
                    )

                    MenuDivider()

                    MenuRow(
                        icon = Icons.Default.RestartAlt,
                        text = "Reset Counter",
                        color = Color.Red,
                        onClick = {
                            onResetCounter()
                            showMenu = false
                        }
                    )
                }
            }
        }
    }
}

// Goal Progress Card Component
@Composable
fun GoalProgressCard(
    title: String,
    progress: Float,
    current: Int,
    target: Int,
    isComplete: Boolean,
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    modifier: Modifier = Modifier  // Add this missing parameter
) {
    Card(
        modifier = modifier  // Use the modifier parameter directly
            .then(
                if (isComplete) {
                    Modifier.shadow(
                        elevation = 12.dp,
                        shape = RoundedCornerShape(12.dp)
                    )
                } else {
                    Modifier
                }
            ),
        colors = CardDefaults.cardColors(
            containerColor = if (isComplete) {
                Color(0xFF10B981).copy(alpha = 0.9f) // Success green with high opacity
            } else {
                Color.White.copy(alpha = 0.2f)
            }
        )
    ) {
        Column(
            modifier = Modifier.padding(10.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                if (isComplete) {
                    Icon(
                        imageVector = Icons.Default.CheckCircle,
                        contentDescription = "Goal Complete",
                        tint = Color.White,
                        modifier = Modifier.size(20.dp)
                    )
                } else {
                    Icon(
                        imageVector = icon,
                        contentDescription = "Goal Icon",
                        tint = Color.White,
                        modifier = Modifier.size(20.dp)
                    )
                }
                Text(
                    text = title,
                    color = Color.White,
                    fontSize = if (isComplete) 16.sp else 14.sp,
                    fontWeight = if (isComplete) FontWeight.Bold else FontWeight.Normal
                )
                if (isComplete) {
                    Icon(
                        imageVector = Icons.Default.CheckCircle,
                        contentDescription = "Goal Complete",
                        tint = Color.White,
                        modifier = Modifier.size(20.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.height(8.dp))

            LinearProgressIndicator(
                progress = { progress },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(if (isComplete) 8.dp else 4.dp),
                color = if (isComplete) Color.White else Color.Cyan,
                trackColor = if (isComplete) Color.White.copy(alpha = 0.3f) else Color.White.copy(alpha = 0.2f)
            )

            Spacer(modifier = Modifier.height(4.dp))

            Text(
                text = if (isComplete) {
                    "$current / $target ✓"
                } else {
                    "$current / $target"
                },
                color = Color.White,
                fontSize = if (isComplete) 14.sp else 12.sp,
                fontWeight = if (isComplete) FontWeight.Bold else FontWeight.Normal
            )

            // Show percentage and remaining count for incomplete goals
            /*if (!isComplete) {
                val percentage = (progress * 100).toInt()
                val remaining = target - current
                Text(
                    text = "$percentage% complete • $remaining remaining",
                    color = Color.White.copy(alpha = 0.8f),
                    fontSize = 10.sp
                )
            }*/
        }
    }
}

// Menu Row Component
@Composable
fun MenuRow(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    text: String,
    color: Color,
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onClick() }
            .padding(horizontal = 12.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(icon, contentDescription = null, tint = color)
        Spacer(Modifier.width(8.dp))
        Text(text, color = color, fontSize = 14.sp)
    }
}

// Menu Divider Component
@Composable
fun MenuDivider() {
    HorizontalDivider(
        modifier = Modifier.padding(vertical = 4.dp),
        color = Color.Gray.copy(alpha = 0.3f)
    )
}

// Enhanced StatCard with highlighting
@Composable
fun StatCard(
    label: String,
    value: String,
    modifier: Modifier = Modifier,
    isHighlighted: Boolean = false
) {
    Card(
        modifier = modifier.then(
            if (isHighlighted) {
                Modifier.shadow(
                    elevation = 8.dp,
                    shape = RoundedCornerShape(8.dp)
                )
            } else {
                Modifier
            }
        ),
        colors = CardDefaults.cardColors(
            containerColor = if (isHighlighted) {
                Color(0xFFFFD700).copy(alpha = 0.4f) // Gold highlight
            } else {
                Color(0xFFFF9933).copy(alpha = 0.25f)
            }
        )
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 12.dp, vertical = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                if (isHighlighted) {
                    Icon(
                        imageVector = Icons.Default.Star,
                        contentDescription = "Goal Achieved",
                        tint = Color(0xFFFFD700),
                        modifier = Modifier.size(12.dp)
                    )
                }
                Text(
                    text = label,
                    color = Color.White.copy(alpha = 0.95f),
                    fontSize = 11.sp,
                    fontWeight = if (isHighlighted) FontWeight.Bold else FontWeight.Medium
                )
            }
            Text(
                text = value,
                color = Color.White,
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold
            )
        }
    }
}