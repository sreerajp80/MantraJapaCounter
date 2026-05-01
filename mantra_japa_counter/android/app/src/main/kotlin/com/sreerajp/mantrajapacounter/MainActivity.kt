package com.sreerajp.mantrajapacounter

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.Ringtone
import android.media.RingtoneManager
import android.media.ToneGenerator
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.VibrationAttributes
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.sreerajp.mantrajapacounter/haptic"

    // Daily-goal vibration pattern: three strong pulses with short gaps so the
    // completion is unmistakable even with the phone in a pocket. Pairs of
    // (wait, vibrate) — index 0 is the leading wait.
    private val dailyGoalPattern = longArrayOf(0, 220, 90, 220, 90, 220)
    private val malaVibrationMs = 250L

    private var previewRingtone: Ringtone? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "playMalaTone" -> {
                    playMalaTone()
                    result.success(null)
                }
                "vibrateMala" -> {
                    vibrateOneShot(malaVibrationMs)
                    result.success(null)
                }
                "vibrateDailyGoal" -> {
                    vibratePattern(dailyGoalPattern)
                    result.success(null)
                }
                "previewDefaultNotificationTone" -> {
                    previewDefaultNotificationTone()
                    result.success(null)
                }
                "playRingtoneUri" -> {
                    val uri = call.argument<String>("uri")
                    if (uri.isNullOrBlank()) {
                        result.error("ARG_URI", "uri is required", null)
                    } else {
                        playRingtoneUri(uri)
                        result.success(null)
                    }
                }
                "listNotificationRingtones" -> {
                    result.success(listNotificationRingtones())
                }
                "stopPreviewTone" -> {
                    stopPreviewTone()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        stopPreviewTone()
        super.onDestroy()
    }

    /**
     * Plays the system default notification ringtone for the Settings preview.
     * Uses RingtoneManager because audioplayers/ExoPlayer can't resolve the
     * `content://settings/system/notification_sound` alias URI directly.
     */
    private fun previewDefaultNotificationTone() {
        try {
            stopPreviewTone()
            val uri: Uri = RingtoneManager.getActualDefaultRingtoneUri(
                this, RingtoneManager.TYPE_NOTIFICATION,
            ) ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
            val rt = RingtoneManager.getRingtone(this, uri) ?: return
            previewRingtone = rt
            rt.play()
        } catch (_: Exception) {
            // best-effort — preview must never break the screen
        }
    }

    private fun stopPreviewTone() {
        try {
            previewRingtone?.stop()
        } catch (_: Exception) {}
        previewRingtone = null
    }

    /**
     * Plays a ringtone from a content:// URI (typically returned by
     * [listNotificationRingtones]). RingtoneManager handles `content://media/...`
     * URIs that ExoPlayer/audioplayers can't open directly.
     */
    private fun playRingtoneUri(uriString: String) {
        try {
            stopPreviewTone()
            val uri = Uri.parse(uriString)
            val rt = RingtoneManager.getRingtone(this, uri) ?: return
            previewRingtone = rt
            rt.play()
        } catch (_: Exception) {
            // best-effort
        }
    }

    /**
     * Returns the list of notification-type ringtones available on the device,
     * each as `{title, uri}` strings. Used by Settings to populate the picker.
     */
    private fun listNotificationRingtones(): List<Map<String, String>> {
        val out = mutableListOf<Map<String, String>>()
        try {
            val manager = RingtoneManager(this)
            manager.setType(RingtoneManager.TYPE_NOTIFICATION)
            val cursor = manager.cursor
            while (cursor.moveToNext()) {
                val title = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX) ?: continue
                val uri = manager.getRingtoneUri(cursor.position) ?: continue
                out.add(mapOf("title" to title, "uri" to uri.toString()))
            }
        } catch (_: Exception) {
            // best-effort — return whatever we collected
        }
        return out
    }

    /**
     * Built-in mala-completion beep — a 100ms DTMF tone on the notification
     * stream at max volume, generated by ToneGenerator. No audio asset shipped.
     */
    private fun playMalaTone() {
        try {
            val tg = ToneGenerator(
                AudioManager.STREAM_NOTIFICATION,
                ToneGenerator.MAX_VOLUME,
            )
            tg.startTone(ToneGenerator.TONE_PROP_BEEP, 100)
            Handler(Looper.getMainLooper()).postDelayed({
                try { tg.release() } catch (_: Exception) {}
            }, 150)
        } catch (_: Exception) {
            // best-effort — must never break a counting session
        }
    }

    private fun vibrator(): Vibrator? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            (getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager)
                ?.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
        }
    }

    /**
     * Single-pulse vibration that bypasses silent / DND / ringer mode.
     * Uses USAGE_ALARM vibration attributes (Android 13+) or USAGE_ALARM
     * audio attributes (Android 8–12). Drives the actuator at max amplitude
     * when the device supports amplitude control so it's clearly perceptible.
     */
    private fun vibrateOneShot(durationMs: Long) {
        try {
            val v = vibrator() ?: return
            if (!v.hasVibrator()) return
            val amplitude = strongestAmplitude(v)
            when {
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU -> {
                    val effect = VibrationEffect.createOneShot(durationMs, amplitude)
                    val attrs = VibrationAttributes.Builder()
                        .setUsage(VibrationAttributes.USAGE_ALARM)
                        .build()
                    v.vibrate(effect, attrs)
                }
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.O -> {
                    val effect = VibrationEffect.createOneShot(durationMs, amplitude)
                    val audioAttrs = AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build()
                    @Suppress("DEPRECATION")
                    v.vibrate(effect, audioAttrs)
                }
                else -> {
                    @Suppress("DEPRECATION")
                    v.vibrate(durationMs)
                }
            }
        } catch (_: Exception) {
            // best-effort
        }
    }

    private fun vibratePattern(pattern: LongArray) {
        try {
            val v = vibrator() ?: return
            if (!v.hasVibrator()) return
            when {
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.O -> {
                    // Per-segment amplitudes (matched to `pattern`): even indices
                    // are silent waits (0), odd indices are vibrate-at-max.
                    val effect = if (v.hasAmplitudeControl()) {
                        val amps = IntArray(pattern.size) { i -> if (i % 2 == 0) 0 else 255 }
                        VibrationEffect.createWaveform(pattern, amps, -1)
                    } else {
                        VibrationEffect.createWaveform(pattern, -1)
                    }
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        val attrs = VibrationAttributes.Builder()
                            .setUsage(VibrationAttributes.USAGE_ALARM)
                            .build()
                        v.vibrate(effect, attrs)
                    } else {
                        val audioAttrs = AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .build()
                        @Suppress("DEPRECATION")
                        v.vibrate(effect, audioAttrs)
                    }
                }
                else -> {
                    @Suppress("DEPRECATION")
                    v.vibrate(pattern, -1)
                }
            }
        } catch (_: Exception) {
            // best-effort
        }
    }

    private fun strongestAmplitude(v: Vibrator): Int {
        return if (
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && v.hasAmplitudeControl()
        ) 255 else VibrationEffect.DEFAULT_AMPLITUDE
    }
}
