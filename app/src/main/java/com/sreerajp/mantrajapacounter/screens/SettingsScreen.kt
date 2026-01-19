package com.sreerajp.mantrajapacounter.screens

import android.content.Intent
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.VolumeUp
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.filled.Brightness6
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.sreerajp.mantrajapacounter.utils.DailyGoalNotificationHelper

// Data class to hold ringtone info
private data class RingtoneItem(
    val name: String,
    val uri: Uri?
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SettingsScreen(
    notificationHelper: DailyGoalNotificationHelper,
    onBack: () -> Unit
) {
    val context = LocalContext.current
    val scrollState = rememberScrollState()

    // State for settings
    var notificationEnabled by remember { mutableStateOf(notificationHelper.isNotificationEnabled()) }
    var vibrationEnabled by remember { mutableStateOf(notificationHelper.isVibrationEnabled()) }
    var soundEnabled by remember { mutableStateOf(notificationHelper.isSoundEnabled()) }
    var toneName by remember { mutableStateOf(notificationHelper.getNotificationToneName()) }
    var malaSoundEnabled by remember { mutableStateOf(notificationHelper.isMalaSoundEnabled()) }
    var reduceBrightnessEnabled by remember { mutableStateOf(notificationHelper.isReduceBrightnessEnabled()) }
    var brightnessLevel by remember { mutableStateOf(notificationHelper.getBrightnessLevel()) }
    
    // State for ringtone picker dialog
    var showRingtoneDialog by remember { mutableStateOf(false) }
    var availableRingtones by remember { mutableStateOf<List<RingtoneItem>>(emptyList()) }
    
    // Load available ringtones when dialog is shown
    LaunchedEffect(showRingtoneDialog) {
        if (showRingtoneDialog && availableRingtones.isEmpty()) {
            val ringtones = mutableListOf<RingtoneItem>()
            
            // Add default notification sound
            RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)?.let { defaultUri ->
                val defaultRingtone = RingtoneManager.getRingtone(context, defaultUri)
                ringtones.add(RingtoneItem("Default notification sound", defaultUri))
            }
            
            // Get all notification tones
            val manager = RingtoneManager(context)
            manager.setType(RingtoneManager.TYPE_NOTIFICATION)
            val cursor = manager.cursor
            
            while (cursor.moveToNext()) {
                val title = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
                val uri = manager.getRingtoneUri(cursor.position)
                if (uri != null) {
                    ringtones.add(RingtoneItem(title, uri))
                }
            }
            
            availableRingtones = ringtones.distinctBy { it.uri?.toString() }
        }
    }

    // File picker launcher for custom audio files
    val filePicker = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.OpenDocument()
    ) { uri ->
        if (uri != null) {
            // Take persistent permission
            try {
                context.contentResolver.takePersistableUriPermission(
                    uri,
                    Intent.FLAG_GRANT_READ_URI_PERMISSION
                )
            } catch (e: Exception) {
                // Permission might not be grantable for all URIs
            }
            
            // Get the file name
            val cursor = context.contentResolver.query(uri, null, null, null, null)
            val name = cursor?.use {
                if (it.moveToFirst()) {
                    val nameIndex = it.getColumnIndex(android.provider.OpenableColumns.DISPLAY_NAME)
                    if (nameIndex >= 0) it.getString(nameIndex) else "Custom Audio"
                } else "Custom Audio"
            } ?: "Custom Audio"
            
            notificationHelper.setNotificationTone(uri, name)
            toneName = name
        }
    }

    Box(
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
    ) {
        Column(
            modifier = Modifier.fillMaxSize()
        ) {
            // Top App Bar
            TopAppBar(
                title = {
                    Text(
                        "Settings",
                        color = Color.White,
                        fontWeight = FontWeight.Bold
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back",
                            tint = Color.White
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = Color.Transparent
                )
            )

            // Settings Content
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .verticalScroll(scrollState)
                    .padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                // Daily Goal Notification Section
                SettingsSection(title = "Daily Goal Notification") {
                    // Master toggle
                    SettingsToggleItem(
                        icon = Icons.Default.Notifications,
                        title = "Enable Notification",
                        subtitle = "Vibrate and play sound when daily goal is reached",
                        checked = notificationEnabled,
                        onCheckedChange = { enabled ->
                            notificationEnabled = enabled
                            notificationHelper.setNotificationEnabled(enabled)
                        }
                    )

                    if (notificationEnabled) {
                        HorizontalDivider(
                            color = Color.White.copy(alpha = 0.1f),
                            modifier = Modifier.padding(vertical = 8.dp)
                        )

                        // Vibration toggle
                        SettingsToggleItem(
                            icon = Icons.Default.Vibration,
                            title = "Vibration",
                            subtitle = "Vibrate when daily goal is reached",
                            checked = vibrationEnabled,
                            onCheckedChange = { enabled ->
                                vibrationEnabled = enabled
                                notificationHelper.setVibrationEnabled(enabled)
                            }
                        )

                        Spacer(modifier = Modifier.height(8.dp))

                        // Sound toggle
                        SettingsToggleItem(
                            icon = Icons.AutoMirrored.Filled.VolumeUp,
                            title = "Sound",
                            subtitle = "Play tone when daily goal is reached",
                            checked = soundEnabled,
                            onCheckedChange = { enabled ->
                                soundEnabled = enabled
                                notificationHelper.setSoundEnabled(enabled)
                            }
                        )

                        if (soundEnabled) {
                            Spacer(modifier = Modifier.height(16.dp))

                            // Tone selection
                            SettingsClickableItem(
                                icon = Icons.Default.MusicNote,
                                title = "Notification Tone",
                                subtitle = toneName,
                                onClick = {
                                    showRingtoneDialog = true
                                }
                            )

                            Spacer(modifier = Modifier.height(8.dp))

                            // Custom file picker
                            SettingsClickableItem(
                                icon = Icons.Default.AudioFile,
                                title = "Choose from Files",
                                subtitle = "Select a custom audio file from device",
                                onClick = {
                                    filePicker.launch(arrayOf("audio/*"))
                                }
                            )

                            Spacer(modifier = Modifier.height(8.dp))

                            // Preview button
                            SettingsClickableItem(
                                icon = Icons.Default.PlayArrow,
                                title = "Preview Sound",
                                subtitle = "Play the selected notification tone",
                                onClick = {
                                    notificationHelper.previewSound()
                                }
                            )
                        }
                    }
                }
                
                // Mala Completion Sound Section
                SettingsSection(title = "Mala Completion Sound") {
                    SettingsToggleItem(
                        icon = Icons.Default.Alarm,
                        title = "Enable Mala Sound",
                        subtitle = "Play a short tick sound when each mala (108 counts) is completed",
                        checked = malaSoundEnabled,
                        onCheckedChange = { enabled ->
                            malaSoundEnabled = enabled
                            notificationHelper.setMalaSoundEnabled(enabled)
                        }
                    )
                    
                    if (malaSoundEnabled) {
                        Spacer(modifier = Modifier.height(8.dp))
                        
                        // Preview mala sound
                        SettingsClickableItem(
                            icon = Icons.Default.PlayArrow,
                            title = "Preview Mala Sound",
                            subtitle = "Play the mala completion sound",
                            onClick = {
                                notificationHelper.playMalaCompletionNotification()
                            }
                        )
                    }
                }

                // Power Optimization Section
                SettingsSection(title = "Power Optimization") {
                    SettingsToggleItem(
                        icon = Icons.Default.Brightness6,
                        title = "Reduce Screen Brightness",
                        subtitle = "Lower screen brightness during counting to save battery",
                        checked = reduceBrightnessEnabled,
                        onCheckedChange = { enabled ->
                            reduceBrightnessEnabled = enabled
                            notificationHelper.setReduceBrightnessEnabled(enabled)
                        }
                    )
                    
                    if (reduceBrightnessEnabled) {
                        Spacer(modifier = Modifier.height(16.dp))
                        
                        Text(
                            text = "Brightness Level: ${(brightnessLevel * 100).toInt()}%",
                            color = Color.White,
                            fontSize = 14.sp,
                            modifier = Modifier.padding(vertical = 8.dp)
                        )
                        
                        Slider(
                            value = brightnessLevel,
                            onValueChange = { newValue ->
                                brightnessLevel = newValue
                                notificationHelper.setBrightnessLevel(newValue)
                            },
                            valueRange = 0.1f..1.0f,
                            steps = 8, // 9 steps: 10%, 20%, ..., 90%, 100%
                            colors = SliderDefaults.colors(
                                thumbColor = Color.White,
                                activeTrackColor = Color(0xFF10B981),
                                inactiveTrackColor = Color.White.copy(alpha = 0.3f)
                            )
                        )
                        
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text(
                                text = "10%",
                                color = Color.White.copy(alpha = 0.6f),
                                fontSize = 12.sp
                            )
                            Text(
                                text = "100%",
                                color = Color.White.copy(alpha = 0.6f),
                                fontSize = 12.sp
                            )
                        }
                    }
                }
                
                // Information card
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(
                        containerColor = Color.White.copy(alpha = 0.1f)
                    ),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Row(
                        modifier = Modifier.padding(16.dp),
                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        Icon(
                            imageVector = Icons.Default.Info,
                            contentDescription = null,
                            tint = Color.White.copy(alpha = 0.7f)
                        )
                        Text(
                            text = "The daily goal notification plays when your daily goal is achieved. The mala completion sound plays a short tick after every 108 counts (if it's not also the daily goal).",
                            color = Color.White.copy(alpha = 0.7f),
                            fontSize = 14.sp,
                            lineHeight = 20.sp
                        )
                    }
                }

                Spacer(modifier = Modifier.height(32.dp))
            }
        }
        
        // Ringtone picker dialog
        if (showRingtoneDialog) {
            AlertDialog(
                onDismissRequest = { showRingtoneDialog = false },
                title = {
                    Text(
                        "Select Notification Tone",
                        fontWeight = FontWeight.Bold
                    )
                },
                text = {
                    if (availableRingtones.isEmpty()) {
                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(200.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            CircularProgressIndicator()
                        }
                    } else {
                        LazyColumn(
                            modifier = Modifier
                                .fillMaxWidth()
                                .heightIn(max = 400.dp)
                        ) {
                            items(availableRingtones) { ringtoneItem ->
                                val isSelected = ringtoneItem.uri?.toString() == 
                                    notificationHelper.getNotificationToneUri()?.toString()
                                Row(
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .clip(RoundedCornerShape(8.dp))
                                        .clickable {
                                            notificationHelper.setNotificationTone(
                                                ringtoneItem.uri,
                                                ringtoneItem.name
                                            )
                                            toneName = ringtoneItem.name
                                            // Preview the selected tone
                                            notificationHelper.previewSound()
                                            showRingtoneDialog = false
                                        }
                                        .padding(vertical = 12.dp, horizontal = 8.dp),
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    RadioButton(
                                        selected = isSelected,
                                        onClick = null
                                    )
                                    Spacer(modifier = Modifier.width(12.dp))
                                    Text(
                                        text = ringtoneItem.name,
                                        modifier = Modifier.weight(1f)
                                    )
                                }
                            }
                        }
                    }
                },
                confirmButton = {
                    TextButton(onClick = { showRingtoneDialog = false }) {
                        Text("Cancel")
                    }
                }
            )
        }
    }
}

@Composable
private fun SettingsSection(
    title: String,
    content: @Composable ColumnScope.() -> Unit
) {
    Column(
        modifier = Modifier.fillMaxWidth()
    ) {
        Text(
            text = title,
            color = Color(0xFF60A5FA),
            fontSize = 14.sp,
            fontWeight = FontWeight.SemiBold,
            modifier = Modifier.padding(bottom = 8.dp)
        )
        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(
                containerColor = Color.White.copy(alpha = 0.1f)
            ),
            shape = RoundedCornerShape(12.dp)
        ) {
            Column(
                modifier = Modifier.padding(16.dp),
                content = content
            )
        }
    }
}

@Composable
private fun SettingsToggleItem(
    icon: ImageVector,
    title: String,
    subtitle: String,
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(8.dp))
            .clickable { onCheckedChange(!checked) }
            .padding(vertical = 8.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            tint = Color.White.copy(alpha = 0.8f),
            modifier = Modifier.size(24.dp)
        )
        Spacer(modifier = Modifier.width(16.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = title,
                color = Color.White,
                fontSize = 16.sp,
                fontWeight = FontWeight.Medium
            )
            Text(
                text = subtitle,
                color = Color.White.copy(alpha = 0.6f),
                fontSize = 13.sp
            )
        }
        Switch(
            checked = checked,
            onCheckedChange = onCheckedChange,
            colors = SwitchDefaults.colors(
                checkedThumbColor = Color.White,
                checkedTrackColor = Color(0xFF10B981),
                uncheckedThumbColor = Color.White.copy(alpha = 0.8f),
                uncheckedTrackColor = Color.White.copy(alpha = 0.2f)
            )
        )
    }
}

@Composable
private fun SettingsClickableItem(
    icon: ImageVector,
    title: String,
    subtitle: String,
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(8.dp))
            .clickable(onClick = onClick)
            .padding(vertical = 8.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            tint = Color.White.copy(alpha = 0.8f),
            modifier = Modifier.size(24.dp)
        )
        Spacer(modifier = Modifier.width(16.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = title,
                color = Color.White,
                fontSize = 16.sp,
                fontWeight = FontWeight.Medium
            )
            Text(
                text = subtitle,
                color = Color.White.copy(alpha = 0.6f),
                fontSize = 13.sp
            )
        }
        Icon(
            imageVector = Icons.Default.ChevronRight,
            contentDescription = null,
            tint = Color.White.copy(alpha = 0.5f),
            modifier = Modifier.size(24.dp)
        )
    }
}

