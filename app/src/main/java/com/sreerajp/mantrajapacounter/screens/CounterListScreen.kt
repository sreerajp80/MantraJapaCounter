package com.sreerajp.mantrajapacounter.screens

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid
import androidx.compose.foundation.lazy.staggeredgrid.StaggeredGridCells
import androidx.compose.foundation.lazy.staggeredgrid.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.layout.systemBars
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Shadow
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.style.TextAlign
import com.sreerajp.mantrajapacounter.data.Counter

@OptIn(ExperimentalMaterial3Api::class, ExperimentalFoundationApi::class)
@Composable
fun CounterListScreen(
    counters: List<Counter>,
    getTotalCount: (Counter) -> Int,
    getTotalMalas: (Counter) -> Int,
    getTodayCount: (Counter) -> Int, // New parameter for today's count
    onSelectCounter: (Counter) -> Unit,
    onAddCounter: (String, Int, Int, Int, Int) -> Unit, // Added dailyGoal parameter
    onEditCounter: (Counter, String, Int, Int, Int, Int) -> Unit, // Added dailyGoal parameter
    onDeleteCounter: (Counter) -> Unit,
    onShowHistory: (String?) -> Unit,
    onShowAbout: () -> Unit,
    onShowImportExport: () -> Unit // New parameter for import/export
) {
    var showAddDialog by remember { mutableStateOf(false) }
    var showEditDialog by remember { mutableStateOf<Counter?>(null) }
    var selectedCounter by remember { mutableStateOf<Counter?>(null) }
    var showMenu by remember { mutableStateOf(false) }
    var newCounterName by remember { mutableStateOf("") }
    var newInitialCount by remember { mutableStateOf("0") }
    var newIncrementStep by remember { mutableStateOf("1") }
    var newGoal by remember { mutableStateOf("0") }
    var newDailyGoal by remember { mutableStateOf("0") } // New state for daily goal

    // Get screen configuration for responsive design
    val configuration = LocalConfiguration.current
    val screenWidth = configuration.screenWidthDp.dp
    val screenHeight = configuration.screenHeightDp.dp
    val isTablet = screenWidth >= 600.dp
    val isLandscape = screenWidth > screenHeight

    // Responsive values
    val headerFontSize = if (isTablet) 32.sp else 24.sp
    val cardPadding = if (isTablet) 24.dp else 16.dp
    val itemSpacing = if (isTablet) 16.dp else 12.dp
    val containerPadding = if (isTablet) 24.dp else 16.dp

    // Reset dialog fields when dialogs are closed
    LaunchedEffect(showAddDialog, showEditDialog) {
        if (!showAddDialog && showEditDialog == null) {
            newCounterName = ""
            newInitialCount = "0"
            newIncrementStep = "1"
            newGoal = "0"
            newDailyGoal = "0"
        }
    }

    // Set fields when editing
    LaunchedEffect(showEditDialog) {
        showEditDialog?.let { counter ->
            newCounterName = counter.name
            newInitialCount = counter.initialCount.toString()
            newIncrementStep = counter.incrementStep.toString()
            newGoal = counter.goal.toString()
            newDailyGoal = counter.dailyGoal.toString()
        }
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
            .padding(containerPadding)
    ) {
        // Header
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = "Mantra Counters",
                color = Color.White,
                fontSize = headerFontSize,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.weight(1f)
            )

            Row {
                IconButton(onClick = { showAddDialog = true }) {
                    Icon(
                        imageVector = Icons.Default.Add,
                        contentDescription = "Add Counter",
                        tint = Color.White,
                        modifier = Modifier.size(if (isTablet) 32.dp else 24.dp)
                    )
                }

                // Menu Button
                Box {
                    IconButton(onClick = { showMenu = true }) {
                        Icon(
                            imageVector = Icons.Default.MoreVert,
                            contentDescription = "Menu",
                            tint = Color.White,
                            modifier = Modifier.size(if (isTablet) 32.dp else 24.dp)
                        )
                    }

                    DropdownMenu(
                        expanded = showMenu,
                        onDismissRequest = { showMenu = false }
                    ) {
                        DropdownMenuItem(
                            text = { Text("History") },
                            onClick = {
                                showMenu = false
                                onShowHistory(selectedCounter?.id)
                            },
                            leadingIcon = {
                                Icon(
                                    imageVector = Icons.Default.History,
                                    contentDescription = null
                                )
                            }
                        )

                        DropdownMenuItem(
                            text = { Text("Import/Export") },
                            onClick = {
                                showMenu = false
                                onShowImportExport()
                            },
                            leadingIcon = {
                                Icon(
                                    imageVector = Icons.Default.SwapHoriz,
                                    contentDescription = null
                                )
                            }
                        )

                        HorizontalDivider()

                        DropdownMenuItem(
                            text = { Text("About") },
                            onClick = {
                                showMenu = false
                                onShowAbout()
                            },
                            leadingIcon = {
                                Icon(
                                    imageVector = Icons.Default.Info,
                                    contentDescription = null
                                )
                            }
                        )

                        HorizontalDivider()

                        DropdownMenuItem(
                            text = {
                                Text(
                                    "Edit Counter",
                                    color = if (selectedCounter != null) Color.Unspecified else Color.Gray
                                )
                            },
                            onClick = {
                                showMenu = false
                                selectedCounter?.let { counter ->
                                    showEditDialog = counter
                                }
                            },
                            enabled = selectedCounter != null,
                            leadingIcon = {
                                Icon(
                                    imageVector = Icons.Default.Edit,
                                    contentDescription = null,
                                    tint = if (selectedCounter != null) Color.Unspecified else Color.Gray
                                )
                            }
                        )

                        DropdownMenuItem(
                            text = {
                                Text(
                                    "Delete Counter",
                                    color = if (selectedCounter != null && counters.size > 1) Color.Red else Color.Gray
                                )
                            },
                            onClick = {
                                showMenu = false
                                selectedCounter?.let { counter ->
                                    if (counters.size > 1) {
                                        onDeleteCounter(counter)
                                        selectedCounter = null
                                    }
                                }
                            },
                            enabled = selectedCounter != null && counters.size > 1,
                            leadingIcon = {
                                Icon(
                                    imageVector = Icons.Default.Delete,
                                    contentDescription = null,
                                    tint = if (selectedCounter != null && counters.size > 1) Color.Red else Color.Gray
                                )
                            }
                        )
                    }
                }
            }
        }

        Spacer(modifier = Modifier.height(itemSpacing))

        // Counter List - Responsive layout
        if (isTablet && isLandscape) {
            // Staggered grid for tablets in landscape
            LazyVerticalStaggeredGrid(
                columns = StaggeredGridCells.Adaptive(minSize = 300.dp),
                verticalItemSpacing = itemSpacing,
                horizontalArrangement = Arrangement.spacedBy(itemSpacing),
                modifier = Modifier.fillMaxSize(),
                contentPadding = PaddingValues(bottom = itemSpacing)
            ) {
                items(counters) { counter ->
                    CounterListItem(
                        counter = counter,
                        totalCount = getTotalCount(counter),
                        totalMalas = getTotalMalas(counter),
                        todayCount = getTodayCount(counter),
                        isSelected = selectedCounter == counter,
                        onTap = { onSelectCounter(counter) },
                        onLongPress = {
                            selectedCounter = if (selectedCounter == counter) null else counter
                        },
                        isTablet = isTablet,
                        cardPadding = cardPadding
                    )
                }
            }
        } else if (isTablet) {
            // Two column grid for tablets in portrait
            LazyVerticalStaggeredGrid(
                columns = StaggeredGridCells.Fixed(2),
                verticalItemSpacing = itemSpacing,
                horizontalArrangement = Arrangement.spacedBy(itemSpacing),
                modifier = Modifier.fillMaxSize(),
                contentPadding = PaddingValues(bottom = itemSpacing)
            ) {
                items(counters) { counter ->
                    CounterListItem(
                        counter = counter,
                        totalCount = getTotalCount(counter),
                        totalMalas = getTotalMalas(counter),
                        todayCount = getTodayCount(counter),
                        isSelected = selectedCounter == counter,
                        onTap = { onSelectCounter(counter) },
                        onLongPress = {
                            selectedCounter = if (selectedCounter == counter) null else counter
                        },
                        isTablet = isTablet,
                        cardPadding = cardPadding
                    )
                }
            }
        } else {
            // Single column list for phones
            LazyColumn(
                verticalArrangement = Arrangement.spacedBy(itemSpacing),
                modifier = Modifier.fillMaxSize(),
                contentPadding = PaddingValues(bottom = itemSpacing)
            ) {
                items(counters) { counter ->
                    CounterListItem(
                        counter = counter,
                        totalCount = getTotalCount(counter),
                        totalMalas = getTotalMalas(counter),
                        todayCount = getTodayCount(counter),
                        isSelected = selectedCounter == counter,
                        onTap = { onSelectCounter(counter) },
                        onLongPress = {
                            selectedCounter = if (selectedCounter == counter) null else counter
                        },
                        isTablet = isTablet,
                        cardPadding = cardPadding
                    )
                }
            }
        }
    }

    // Add Counter Dialog
    if (showAddDialog) {
        CounterDialog(
            title = "Add New Counter",
            name = newCounterName,
            initialCount = newInitialCount,
            incrementStep = newIncrementStep,
            goal = newGoal,
            dailyGoal = newDailyGoal,
            onNameChange = { newCounterName = it },
            onInitialCountChange = { newInitialCount = it },
            onIncrementStepChange = { newIncrementStep = it },
            onGoalChange = { newGoal = it },
            onDailyGoalChange = { newDailyGoal = it },
            onConfirm = {
                if (newCounterName.isNotBlank()) {
                    onAddCounter(
                        newCounterName.trim(),
                        newInitialCount.toIntOrNull() ?: 0,
                        maxOf(1, newIncrementStep.toIntOrNull() ?: 1),
                        maxOf(0, newGoal.toIntOrNull() ?: 0),
                        maxOf(0, newDailyGoal.toIntOrNull() ?: 0)
                    )
                    showAddDialog = false
                }
            },
            onDismiss = { showAddDialog = false },
            isTablet = isTablet
        )
    }

    // Edit Counter Dialog
    showEditDialog?.let { counter ->
        CounterDialog(
            title = "Edit Counter",
            name = newCounterName,
            initialCount = newInitialCount,
            incrementStep = newIncrementStep,
            goal = newGoal,
            dailyGoal = newDailyGoal,
            onNameChange = { newCounterName = it },
            onInitialCountChange = { newInitialCount = it },
            onIncrementStepChange = { newIncrementStep = it },
            onGoalChange = { newGoal = it },
            onDailyGoalChange = { newDailyGoal = it },
            onConfirm = {
                if (newCounterName.isNotBlank()) {
                    onEditCounter(
                        counter,
                        newCounterName.trim(),
                        newInitialCount.toIntOrNull() ?: counter.initialCount,
                        maxOf(1, newIncrementStep.toIntOrNull() ?: counter.incrementStep),
                        maxOf(0, newGoal.toIntOrNull() ?: counter.goal),
                        maxOf(0, newDailyGoal.toIntOrNull() ?: counter.dailyGoal)
                    )
                    showEditDialog = null
                }
            },
            onDismiss = { showEditDialog = null },
            isTablet = isTablet
        )
    }
}

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun CounterListItem(
    counter: Counter,
    totalCount: Int,
    totalMalas: Int,
    todayCount: Int, // New parameter
    isSelected: Boolean,
    onTap: () -> Unit,
    onLongPress: () -> Unit,
    isTablet: Boolean,
    cardPadding: Dp
) {
    val titleFontSize = if (isTablet) 22.sp else 18.sp
    val countFontSize = if (isTablet) 16.sp else 14.sp
    val detailFontSize = if (isTablet) 14.sp else 12.sp

    // Check goal achievements
    val isLifetimeGoalAchieved = counter.goal > 0 && totalCount >= counter.goal
    val isDailyGoalAchieved = counter.dailyGoal > 0 && todayCount >= counter.dailyGoal

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .combinedClickable(
                onClick = onTap,
                onLongClick = onLongPress
            ),
        colors = CardDefaults.cardColors(
            containerColor = when {
                isSelected -> Color(0xFFFFD54F)
                isLifetimeGoalAchieved && isDailyGoalAchieved -> Color(0xFFA6D3F8) // Light green for both goals
                isLifetimeGoalAchieved -> Color(0xFF86BDF5)
                isDailyGoalAchieved -> Color(0xFFCCF2FD)
                else -> Color(0xFFCCF2FD)
            }
        ),
        elevation = CardDefaults.cardElevation(
            defaultElevation = if (isSelected) 8.dp else 4.dp
        )
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(cardPadding)
        ) {
            // Header row with title, achievements icons, and checkbox
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.Top
            ) {
                Row(
                    modifier = Modifier.weight(1f),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = counter.name,
                        fontSize = titleFontSize,
                        fontWeight = FontWeight.Bold,
                        color = Color.Black,
                        style = TextStyle(
                            shadow = Shadow(
                                color = Color.Black.copy(alpha = 0.9f),
                                offset = Offset(2f, 2f),
                                blurRadius = 4f
                            )
                        ),
                        modifier = Modifier.weight(1f)
                    )

                    // Achievement icons
                    Row(
                        horizontalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        if (isDailyGoalAchieved) {
                            Icon(
                                imageVector = Icons.Default.Today,
                                contentDescription = "Daily Goal Achieved",
                                tint = Color(0xFF063A62),
                                modifier = Modifier.size(16.dp)
                            )
                        }
                        if (isLifetimeGoalAchieved) {
                            Icon(
                                imageVector = Icons.Default.EmojiEvents,
                                contentDescription = "Lifetime Goal Achieved",
                                tint = Color(0xFFFFD700),
                                modifier = Modifier.size(16.dp)
                            )
                        }
                    }
                }

                // Checkbox for selection
                Checkbox(
                    checked = isSelected,
                    onCheckedChange = { onLongPress() },
                    modifier = Modifier.size(if (isTablet) 28.dp else 24.dp),
                    colors = CheckboxDefaults.colors(
                        checkedColor = Color(0xFF4CAF50),
                        uncheckedColor = Color.Gray,
                        checkmarkColor = Color.White
                    )
                )
            }

            Spacer(modifier = Modifier.height(if (isTablet) 8.dp else 4.dp))

            // Count and malas information
            val countsText = buildString {
                append("$totalCount (c)")
                if (totalMalas > 0) {
                    append(" • $totalMalas (m)")
                }
            }

            Text(
                text = countsText,
                fontSize = countFontSize,
                fontWeight = FontWeight.Bold,
                color = Color.Red,
                lineHeight = (countFontSize.value * 1.2).sp,
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(if (isTablet) 6.dp else 2.dp))

            // Today's count information
            Text(
                text = "Today: $todayCount (c) • ${todayCount / 108} (m)",
                fontSize = detailFontSize,
                color = Color(0xFFB66711),
                fontWeight = FontWeight.Medium,
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(if (isTablet) 6.dp else 2.dp))

            // Daily goal progress
            if (counter.dailyGoal > 0) {
                val dailyProgress = (todayCount.toFloat() / counter.dailyGoal.toFloat()) * 100
                val dailyGoalText = buildString {
                    append("Daily Goal: ${counter.dailyGoal} (c)")
                    append(" • Progress: ${"%.1f".format(dailyProgress)}%")
                    if (isDailyGoalAchieved) {
                        append(" ✓")
                    }
                }

                Text(
                    text = dailyGoalText,
                    fontSize = detailFontSize,
                    color = if (isDailyGoalAchieved) Color(0xFF064D09) else Color(0xFF083D65),
                    fontWeight = FontWeight.Bold,
                    lineHeight = (detailFontSize.value * 1.2).sp,
                    modifier = Modifier.fillMaxWidth()
                )

                Spacer(modifier = Modifier.height(if (isTablet) 4.dp else 2.dp))
            }

            // Lifetime goal progress
            if (counter.goal > 0) {
                val lifetimeProgress = (totalCount.toFloat() / counter.goal.toFloat()) * 100
                val goalText = buildString {
                    append("Lifetime Goal: ${counter.goal} (c)")
                    append(" • Progress: ${"%.1f".format(lifetimeProgress)}%")
                    if (isLifetimeGoalAchieved) {
                        append(" ✓")
                    }
                }

                Text(
                    text = goalText,
                    fontSize = detailFontSize,
                    color = if (isLifetimeGoalAchieved) Color(0xFF1E6B23) else Color(0xFF2196F3),
                    fontWeight = FontWeight.Bold,
                    lineHeight = (detailFontSize.value * 1.2).sp,
                    modifier = Modifier.fillMaxWidth()
                )
            } else if (counter.dailyGoal == 0) {
                Text(
                    text = "No goals set",
                    fontSize = detailFontSize,
                    color = Color.Gray
                )
            }
        }
    }
}

@Composable
fun CounterDialog(
    title: String,
    name: String,
    initialCount: String,
    incrementStep: String,
    goal: String,
    dailyGoal: String,
    onNameChange: (String) -> Unit,
    onInitialCountChange: (String) -> Unit,
    onIncrementStepChange: (String) -> Unit,
    onGoalChange: (String) -> Unit,
    onDailyGoalChange: (String) -> Unit,
    onConfirm: () -> Unit,
    onDismiss: () -> Unit,
    isTablet: Boolean
) {
    // Validation logic
    val lifetimeGoalValue = goal.toIntOrNull() ?: 0
    val dailyGoalValue = dailyGoal.toIntOrNull() ?: 0

    // Check if daily goal validation fails
    val isDailyGoalInvalid = lifetimeGoalValue > 0 && dailyGoalValue > 0 && dailyGoalValue >= lifetimeGoalValue

    // Check if form is valid
    val isFormValid = name.isNotBlank() && !isDailyGoalInvalid

    AlertDialog(
        onDismissRequest = onDismiss,
        title = {
            Text(
                text = title,
                fontSize = if (isTablet) 20.sp else 16.sp
            )
        },
        text = {
            Column(
                verticalArrangement = Arrangement.spacedBy(if (isTablet) 12.dp else 8.dp)
            ) {
                OutlinedTextField(
                    value = name,
                    onValueChange = onNameChange,
                    label = { Text("Counter Name") },
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true,
                    textStyle = LocalTextStyle.current.copy(fontSize = if (isTablet) 16.sp else 14.sp)
                )

                OutlinedTextField(
                    value = initialCount,
                    onValueChange = onInitialCountChange,
                    label = { Text("Initial Count") },
                    modifier = Modifier.fillMaxWidth(),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true,
                    textStyle = LocalTextStyle.current.copy(fontSize = if (isTablet) 16.sp else 14.sp)
                )

                OutlinedTextField(
                    value = incrementStep,
                    onValueChange = onIncrementStepChange,
                    label = { Text("Increment Step") },
                    modifier = Modifier.fillMaxWidth(),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true,
                    textStyle = LocalTextStyle.current.copy(fontSize = if (isTablet) 16.sp else 14.sp)
                )

                OutlinedTextField(
                    value = dailyGoal,
                    onValueChange = onDailyGoalChange,
                    label = { Text("Daily Goal (0 = no daily goal)") },
                    modifier = Modifier.fillMaxWidth(),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true,
                    textStyle = LocalTextStyle.current.copy(fontSize = if (isTablet) 16.sp else 14.sp),
                    isError = isDailyGoalInvalid,
                    supportingText = if (isDailyGoalInvalid) {
                        {
                            Text(
                                text = "Daily goal must be less than lifetime goal",
                                color = MaterialTheme.colorScheme.error,
                                fontSize = if (isTablet) 14.sp else 12.sp
                            )
                        }
                    } else null
                )

                OutlinedTextField(
                    value = goal,
                    onValueChange = onGoalChange,
                    label = { Text("Lifetime Goal (0 = no lifetime goal)") },
                    modifier = Modifier.fillMaxWidth(),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true,
                    textStyle = LocalTextStyle.current.copy(fontSize = if (isTablet) 16.sp else 14.sp),
                    isError = isDailyGoalInvalid,
                    supportingText = if (isDailyGoalInvalid && lifetimeGoalValue > 0) {
                        {
                            Text(
                                text = "Lifetime goal must be greater than daily goal",
                                color = MaterialTheme.colorScheme.error,
                                fontSize = if (isTablet) 14.sp else 12.sp
                            )
                        }
                    } else null
                )

                // Additional validation info
                if (lifetimeGoalValue > 0 && dailyGoalValue > 0 && !isDailyGoalInvalid) {
                    Card(
                        modifier = Modifier.fillMaxWidth(),
                        colors = CardDefaults.cardColors(
                            containerColor = MaterialTheme.colorScheme.primaryContainer.copy(alpha = 0.3f)
                        )
                    ) {
                        Text(
                            text = "✓ Daily goal ($dailyGoalValue) is less than lifetime goal ($lifetimeGoalValue)",
                            modifier = Modifier.padding(8.dp),
                            color = MaterialTheme.colorScheme.primary,
                            fontSize = if (isTablet) 14.sp else 12.sp
                        )
                    }
                }
            }
        },
        confirmButton = {
            TextButton(
                onClick = onConfirm,
                enabled = isFormValid
            ) {
                Text(
                    "Save",
                    fontSize = if (isTablet) 16.sp else 14.sp
                )
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text(
                    "Cancel",
                    fontSize = if (isTablet) 16.sp else 14.sp
                )
            }
        }
    )
}
