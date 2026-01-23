package com.sreerajp.mantrajapacounter.utils

import android.content.Context
import android.content.SharedPreferences
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.media.ToneGenerator
import android.net.Uri
import android.os.Build
import android.os.VibrationAttributes
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import androidx.core.content.edit

/**
 * Helper class to manage daily goal and mala completion notifications (vibration, sound, and UI effects)
 *
 * Features:
 * - Daily goal achievement notifications with customizable vibration and sound
 * - Mala completion quick feedback (short vibration + tick sound)
 * - Screen brightness control during counting sessions
 * - Persistent settings storage in SharedPreferences
 * - Android version compatibility (supports API 21+)
 */
class DailyGoalNotificationHelper(private val context: Context) {

    // ===== SHARED PREFERENCES STORAGE =====
    // Stores all user preferences for notifications, sounds, and UI effects
    private val prefs: SharedPreferences = context.getSharedPreferences("japa_counter_settings", Context.MODE_PRIVATE)

    // ===== MEDIA PLAYER REFERENCE =====
    // Kept as instance variable to manage lifecycle and prevent multiple instances
    private var mediaPlayer: MediaPlayer? = null

    companion object {
        // ===== PREFERENCE KEYS =====
        // Daily goal notification settings
        const val PREF_NOTIFICATION_ENABLED = "daily_goal_notification_enabled"
        const val PREF_VIBRATION_ENABLED = "daily_goal_vibration_enabled"
        const val PREF_SOUND_ENABLED = "daily_goal_sound_enabled"
        const val PREF_NOTIFICATION_TONE_URI = "daily_goal_notification_tone_uri"
        const val PREF_NOTIFICATION_TONE_NAME = "daily_goal_notification_tone_name"

        // Mala completion notification settings
        const val PREF_MALA_SOUND_ENABLED = "mala_completion_sound_enabled"

        // Screen brightness settings
        const val PREF_REDUCE_BRIGHTNESS_ENABLED = "reduce_brightness_enabled"
        const val PREF_BRIGHTNESS_LEVEL = "brightness_level" // 0.0 to 1.0, default 0.3

        // ===== VIBRATION PATTERNS =====
        // Short double vibration pattern for daily goal: wait 0ms, vibrate 100ms, pause 80ms, vibrate 100ms
        private val VIBRATION_PATTERN = longArrayOf(0, 100, 80, 100)

        // Mala completion vibration duration in milliseconds (quick feedback)
        private const val MALA_VIBRATION_DURATION_MS = 100L
    }

    // ==================== DAILY GOAL NOTIFICATION SETTINGS ====================

    /**
     * Check if daily goal notification is enabled
     */
    fun isNotificationEnabled(): Boolean {
        return prefs.getBoolean(PREF_NOTIFICATION_ENABLED, true)
    }

    /**
     * Set daily goal notification enabled/disabled
     */
    fun setNotificationEnabled(enabled: Boolean) {
        prefs.edit { putBoolean(PREF_NOTIFICATION_ENABLED, enabled) }
    }

    /**
     * Check if vibration is enabled
     */
    fun isVibrationEnabled(): Boolean {
        return prefs.getBoolean(PREF_VIBRATION_ENABLED, true)
    }

    /**
     * Set vibration enabled/disabled
     */
    fun setVibrationEnabled(enabled: Boolean) {
        prefs.edit { putBoolean(PREF_VIBRATION_ENABLED, enabled) }
    }

    /**
     * Check if sound is enabled
     */
    fun isSoundEnabled(): Boolean {
        return prefs.getBoolean(PREF_SOUND_ENABLED, true)
    }

    /**
     * Set sound enabled/disabled
     */
    fun setSoundEnabled(enabled: Boolean) {
        prefs.edit { putBoolean(PREF_SOUND_ENABLED, enabled) }
    }

    /**
     * Get the current notification tone URI
     */
    fun getNotificationToneUri(): Uri? {
        val uriString = prefs.getString(PREF_NOTIFICATION_TONE_URI, null)
        return if (uriString != null) {
            try {
                Uri.parse(uriString)
            } catch (e: Exception) {
                getDefaultNotificationToneUri()
            }
        } else {
            getDefaultNotificationToneUri()
        }
    }

    /**
     * Get the current notification tone display name
     */
    fun getNotificationToneName(): String {
        return prefs.getString(PREF_NOTIFICATION_TONE_NAME, null) ?: "Default"
    }

    /**
     * Set the notification tone
     */
    fun setNotificationTone(uri: Uri?, name: String) {
        prefs.edit {
            putString(PREF_NOTIFICATION_TONE_URI, uri?.toString())
            putString(PREF_NOTIFICATION_TONE_NAME, name)
        }
    }

    /**
     * Get the default notification sound URI
     */
    private fun getDefaultNotificationToneUri(): Uri? {
        return RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
    }

    // ==================== VIBRATION FUNCTIONALITY ====================

    /**
     * Trigger vibration for daily goal achievement
     * Uses USAGE_ALARM to ensure vibration works even when phone is in silent/vibrate-off mode
     * Executes double vibration pattern for clear user feedback
     */
    fun vibrate() {
        if (!isVibrationEnabled()) return

        val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vibratorManager = context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
            vibratorManager.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        }

        if (vibrator.hasVibrator()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                // Android 13+ - Use VibrationAttributes with USAGE_ALARM to bypass ringer mode
                val effect = VibrationEffect.createWaveform(VIBRATION_PATTERN, -1)
                val attributes = VibrationAttributes.Builder()
                    .setUsage(VibrationAttributes.USAGE_ALARM)
                    .build()
                vibrator.vibrate(effect, attributes)
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                // Android 8-12 - Use AudioAttributes with USAGE_ALARM
                val effect = VibrationEffect.createWaveform(VIBRATION_PATTERN, -1)
                val audioAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build()
                @Suppress("DEPRECATION")
                vibrator.vibrate(effect, audioAttributes)
            } else {
                // Android 7 and below - Use deprecated but simpler API
                @Suppress("DEPRECATION")
                vibrator.vibrate(VIBRATION_PATTERN, -1)
            }
        }
    }

    /**
     * Play the notification sound
     */
    fun playSound() {
        if (!isSoundEnabled()) return

        try {
            // Release any previous media player instance to prevent resource leaks
            releaseMediaPlayer()

            val toneUri = getNotificationToneUri() ?: return

            mediaPlayer = MediaPlayer().apply {
                // Set audio attributes for notification stream
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build()
                )
                // Load the tone file from URI
                setDataSource(context, toneUri)
                // Cleanup when sound completes
                setOnCompletionListener { mp ->
                    mp.release()
                }
                // Handle playback errors gracefully
                setOnErrorListener { mp, _, _ ->
                    mp.release()
                    true
                }
                // Prepare and start playback
                prepare()
                start()
            }
        } catch (e: Exception) {
            // Silently handle errors - don't crash the app if sound can't play
            releaseMediaPlayer()
        }
    }

    // ==================== DAILY GOAL NOTIFICATION ====================

    /**
     * Play notification (both vibration and sound) for daily goal achievement
     */
    fun playDailyGoalNotification() {
        if (!isNotificationEnabled()) return

        vibrate()
        playSound()
    }

    /**
     * Release media player resources
     */
    fun releaseMediaPlayer() {
        try {
            mediaPlayer?.release()
            mediaPlayer = null
        } catch (e: Exception) {
            // Silently ignore cleanup errors
        }
    }

    /**
     * Preview the notification sound (used in settings screen)
     */
    fun previewSound() {
        playSound()
    }

    // ==================== MALA COMPLETION NOTIFICATION ====================

    /**
     * Check if mala completion sound is enabled
     */
    fun isMalaSoundEnabled(): Boolean {
        return prefs.getBoolean(PREF_MALA_SOUND_ENABLED, true)
    }

    /**
     * Set mala completion sound enabled/disabled
     */
    fun setMalaSoundEnabled(enabled: Boolean) {
        prefs.edit { putBoolean(PREF_MALA_SOUND_ENABLED, enabled) }
    }

    /**
     * Play a short tick sound for mala completion
     * Uses ToneGenerator for a quick, short beep (faster than MediaPlayer)
     * Provides immediate feedback without loading external files
     */
    fun playMalaCompletionSound() {
        if (!isMalaSoundEnabled()) return

        try {
            // Use ToneGenerator for quick immediate feedback
            val toneGenerator = ToneGenerator(
                android.media.AudioManager.STREAM_NOTIFICATION,
                ToneGenerator.MAX_VOLUME
            )
            // Play a short DTMF tone (very quick tick sound - 100ms duration)
            toneGenerator.startTone(ToneGenerator.TONE_PROP_BEEP, 100)

            // Release resources after a short delay to ensure sound completes
            android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                toneGenerator.release()
            }, 150)
        } catch (e: Exception) {
            // Silently handle errors - don't crash if tone generation fails
        }
    }

    /**
     * Short vibration for mala completion feedback
     * Quick single vibration using USAGE_ALARM to bypass phone's vibration settings
     */
    private fun vibrateMala() {
        try {
            val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vibratorManager = context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
                vibratorManager.defaultVibrator
            } else {
                @Suppress("DEPRECATION")
                context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
            }

            if (vibrator.hasVibrator()) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    // Android 13+ - Use VibrationAttributes with USAGE_ALARM to bypass ringer mode
                    val effect = VibrationEffect.createOneShot(MALA_VIBRATION_DURATION_MS, VibrationEffect.DEFAULT_AMPLITUDE)
                    val attributes = VibrationAttributes.Builder()
                        .setUsage(VibrationAttributes.USAGE_ALARM)
                        .build()
                    vibrator.vibrate(effect, attributes)
                } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    // Android 8-12 - Use AudioAttributes with USAGE_ALARM
                    val effect = VibrationEffect.createOneShot(MALA_VIBRATION_DURATION_MS, VibrationEffect.DEFAULT_AMPLITUDE)
                    val audioAttributes = AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build()
                    @Suppress("DEPRECATION")
                    vibrator.vibrate(effect, audioAttributes)
                } else {
                    // Android 7 and below - Use deprecated API
                    @Suppress("DEPRECATION")
                    vibrator.vibrate(MALA_VIBRATION_DURATION_MS)
                }
            }
        } catch (e: Exception) {
            // Silently handle errors - don't crash the app if vibration fails
        }
    }

    /**
     * Play mala completion notification (short vibration + tick sound)
     * Provides quick user feedback when completing a mala (108 chants)
     */
    fun playMalaCompletionNotification() {
        if (!isMalaSoundEnabled()) return

        vibrateMala()
        playMalaCompletionSound()
    }

    // ==================== SCREEN BRIGHTNESS CONTROL ====================

    /**
     * Check if brightness reduction is enabled
     * Brightness reduction helps reduce eye strain and save battery during long counting sessions
     */
    fun isReduceBrightnessEnabled(): Boolean {
        return prefs.getBoolean(PREF_REDUCE_BRIGHTNESS_ENABLED, false)
    }

    /**
     * Set brightness reduction enabled/disabled
     */
    fun setReduceBrightnessEnabled(enabled: Boolean) {
        prefs.edit { putBoolean(PREF_REDUCE_BRIGHTNESS_ENABLED, enabled) }
    }

    /**
     * Get the brightness level (0.0 to 1.0)
     * Default: 0.3 (30% brightness)
     * Minimum: 0.1 (10% brightness)
     * Maximum: 1.0 (100% brightness - full brightness)
     */
    fun getBrightnessLevel(): Float {
        return prefs.getFloat(PREF_BRIGHTNESS_LEVEL, 0.3f).coerceIn(0.1f, 1.0f)
    }

    /**
     * Set the brightness level (0.0 to 1.0)
     * Value is automatically clamped between 0.1 and 1.0
     */
    fun setBrightnessLevel(level: Float) {
        prefs.edit { putFloat(PREF_BRIGHTNESS_LEVEL, level.coerceIn(0.1f, 1.0f)) }
    }
}
