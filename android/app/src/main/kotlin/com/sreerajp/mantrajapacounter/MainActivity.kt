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

    // How long after the last boost we hold the alarm volume at max before
    // restoring. Covers the longest expected user-picked ringtone tail; rapid
    // successive completions extend the window so we never restore mid-tone.
    private val alarmVolumeRestoreDelayMs = 6000L

    private var previewRingtone: Ringtone? = null

    // Saved STREAM_ALARM volume captured on the first boost call. Null when
    // nothing is currently boosted. Restored by [scheduleAlarmVolumeRestore].
    private var savedAlarmVolume: Int? = null
    private val volumeHandler = Handler(Looper.getMainLooper())
    private val restoreAlarmVolumeRunnable = Runnable { restoreAlarmVolumeNow() }

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
                "boostAlarmVolume" -> {
                    // Used by the Dart audioplayers path before playing a
                    // user-picked file source so the file is audible in DND /
                    // silent / low-volume modes. Caller pairs this with
                    // `restoreAlarmVolume` (or relies on the auto-restore
                    // timer if playback length is unknown).
                    boostAlarmVolume()
                    result.success(null)
                }
                "restoreAlarmVolume" -> {
                    restoreAlarmVolumeNow()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onPause() {
        // Don't leave the user's alarm volume cranked if the app goes to the
        // background mid-boost. Restore immediately on pause; the next play
        // call will re-boost.
        restoreAlarmVolumeNow()
        super.onPause()
    }

    override fun onDestroy() {
        volumeHandler.removeCallbacks(restoreAlarmVolumeRunnable)
        restoreAlarmVolumeNow()
        stopPreviewTone()
        super.onDestroy()
    }

    /**
     * Plays the system default notification ringtone for the Settings preview
     * and for daily-goal completion. Forces USAGE_ALARM audio attributes so it
     * bypasses silent / DND / ringer-muted modes, and boosts STREAM_ALARM
     * volume so it remains audible when the user's alarm volume is low or 0.
     */
    private fun previewDefaultNotificationTone() {
        try {
            stopPreviewTone()
            val uri: Uri = RingtoneManager.getActualDefaultRingtoneUri(
                this, RingtoneManager.TYPE_NOTIFICATION,
            ) ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
            playRingtoneAsAlarm(uri)
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
     * [listNotificationRingtones]) with USAGE_ALARM attributes and a temporary
     * STREAM_ALARM volume boost so it plays loudly even with the phone in
     * silent / DND / very-low-volume modes.
     */
    private fun playRingtoneUri(uriString: String) {
        try {
            stopPreviewTone()
            playRingtoneAsAlarm(Uri.parse(uriString))
        } catch (_: Exception) {
            // best-effort
        }
    }

    private fun playRingtoneAsAlarm(uri: Uri) {
        val rt = RingtoneManager.getRingtone(this, uri) ?: return
        val attrs = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_ALARM)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()
        rt.audioAttributes = attrs
        boostAlarmVolume()
        previewRingtone = rt
        rt.play()
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
     * Built-in mala-completion beep — a 100ms DTMF tone on the alarm stream
     * at max volume, generated by ToneGenerator. Routed through STREAM_ALARM
     * (not STREAM_NOTIFICATION) so it bypasses silent / DND / notifications-
     * muted modes, with a temporary alarm-volume boost so it stays audible
     * when the user's alarm volume is low or 0.
     */
    private fun playMalaTone() {
        try {
            boostAlarmVolume()
            val tg = ToneGenerator(
                AudioManager.STREAM_ALARM,
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

    /**
     * Saves the current STREAM_ALARM volume on first call, then sets it to
     * max. A later call to [restoreAlarmVolumeNow] (or the auto-restore
     * runnable scheduled here) puts it back to the saved value. Repeated
     * boosts during the window extend the restore deadline so we never
     * restore mid-tone, and only the original pre-boost volume is saved.
     *
     * Note: setting STREAM_ALARM volume is allowed during DND without the
     * notification-policy-access permission — alarms are an explicit DND
     * exemption stream.
     */
    private fun boostAlarmVolume() {
        try {
            val am = getSystemService(Context.AUDIO_SERVICE) as? AudioManager ?: return
            val max = am.getStreamMaxVolume(AudioManager.STREAM_ALARM)
            if (savedAlarmVolume == null) {
                savedAlarmVolume = am.getStreamVolume(AudioManager.STREAM_ALARM)
            }
            am.setStreamVolume(AudioManager.STREAM_ALARM, max, 0)
            volumeHandler.removeCallbacks(restoreAlarmVolumeRunnable)
            volumeHandler.postDelayed(restoreAlarmVolumeRunnable, alarmVolumeRestoreDelayMs)
        } catch (_: SecurityException) {
            // Some OEMs surface a SecurityException when DND blocks volume
            // changes for non-alarm streams; we only touch STREAM_ALARM, but
            // swallow to stay best-effort.
        } catch (_: Exception) {
            // best-effort
        }
    }

    private fun restoreAlarmVolumeNow() {
        volumeHandler.removeCallbacks(restoreAlarmVolumeRunnable)
        val saved = savedAlarmVolume ?: return
        savedAlarmVolume = null
        try {
            val am = getSystemService(Context.AUDIO_SERVICE) as? AudioManager ?: return
            am.setStreamVolume(AudioManager.STREAM_ALARM, saved, 0)
        } catch (_: Exception) {
            // best-effort — if restore fails the next boost still captures
            // a fresh saved value because we cleared it above.
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
