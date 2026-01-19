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
 * Helper class to manage daily goal notifications (vibration and sound)
 */
class DailyGoalNotificationHelper(private val context: Context) {

    private val prefs: SharedPreferences = context.getSharedPreferences("japa_counter_settings", Context.MODE_PRIVATE)
    private var mediaPlayer: MediaPlayer? = null

    companion object {
        const val PREF_NOTIFICATION_ENABLED = "daily_goal_notification_enabled"
        const val PREF_VIBRATION_ENABLED = "daily_goal_vibration_enabled"
        const val PREF_SOUND_ENABLED = "daily_goal_sound_enabled"
        const val PREF_NOTIFICATION_TONE_URI = "daily_goal_notification_tone_uri"
        const val PREF_NOTIFICATION_TONE_NAME = "daily_goal_notification_tone_name"
        const val PREF_MALA_SOUND_ENABLED = "mala_completion_sound_enabled"
        const val PREF_REDUCE_BRIGHTNESS_ENABLED = "reduce_brightness_enabled"
        const val PREF_BRIGHTNESS_LEVEL = "brightness_level" // 0.0 to 1.0, default 0.3

        // Short double vibration pattern: wait 0ms, vibrate 100ms, pause 80ms, vibrate 100ms
        private val VIBRATION_PATTERN = longArrayOf(0, 100, 80, 100)
        
        // Mala completion vibration duration in milliseconds
        private const val MALA_VIBRATION_DURATION_MS = 100L
    }

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

    /**
     * Trigger vibration for daily goal achievement
     * Uses USAGE_ALARM to ensure vibration works even when phone is in silent/vibrate-off mode
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
            // Release any previous media player
            releaseMediaPlayer()

            val toneUri = getNotificationToneUri() ?: return

            mediaPlayer = MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build()
                )
                setDataSource(context, toneUri)
                setOnCompletionListener { mp ->
                    mp.release()
                }
                setOnErrorListener { mp, _, _ ->
                    mp.release()
                    true
                }
                prepare()
                start()
            }
        } catch (e: Exception) {
            // Silently handle errors - don't crash the app if sound can't play
            releaseMediaPlayer()
        }
    }

    /**
     * Play notification (both vibration and sound)
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
            // Ignore
        }
    }

    /**
     * Preview the notification sound
     */
    fun previewSound() {
        playSound()
    }
    
    // ==================== Mala Completion Sound ====================
    
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
     * Uses ToneGenerator for a quick, short beep
     */
    fun playMalaCompletionSound() {
        if (!isMalaSoundEnabled()) return
        
        try {
            // Use ToneGenerator for a quick short tick
            val toneGenerator = ToneGenerator(
                android.media.AudioManager.STREAM_NOTIFICATION,
                ToneGenerator.MAX_VOLUME
            )
            // Play a short DTMF tone (very quick tick sound)
            toneGenerator.startTone(ToneGenerator.TONE_PROP_BEEP, 100) // 100ms duration
            
            // Release after a short delay
            android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                toneGenerator.release()
            }, 150)
        } catch (e: Exception) {
            // Silently handle errors
        }
    }
    
    /**
     * Short vibration for mala completion
     * Uses USAGE_ALARM to bypass phone's vibration/ringer settings
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
     */
    fun playMalaCompletionNotification() {
        if (!isMalaSoundEnabled()) return
        
        vibrateMala()
        playMalaCompletionSound()
    }
    
    // ==================== Screen Brightness Control ====================
    
    /**
     * Check if brightness reduction is enabled
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
     */
    fun getBrightnessLevel(): Float {
        return prefs.getFloat(PREF_BRIGHTNESS_LEVEL, 0.3f).coerceIn(0.1f, 1.0f)
    }
    
    /**
     * Set the brightness level (0.0 to 1.0)
     */
    fun setBrightnessLevel(level: Float) {
        prefs.edit { putFloat(PREF_BRIGHTNESS_LEVEL, level.coerceIn(0.1f, 1.0f)) }
    }
}

