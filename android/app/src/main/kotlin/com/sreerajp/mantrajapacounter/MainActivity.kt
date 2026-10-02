package com.sreerajp.mantrajapacounter

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
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
import android.provider.Settings
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private val channelName = "com.sreerajp.mantrajapacounter/haptic"
    private val qrDecoderChannelName = "com.sreerajp.mantrajapacounter/qr_decoder"
    private val screenChannelName = "com.sreerajp.mantrajapacounter/screen"

    // The user's in-app brightness setting (window only; the system level is
    // never changed). BRIGHTNESS_OVERRIDE_NONE (-1) = follow the system.
    private var appBrightness: Float = WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE

    // True while Optical Sync send mode keeps the screen on.
    private var sendModeOn = false

    // Extra brightness the user picked with the slider on the Optical Sync
    // send screen. BRIGHTNESS_OVERRIDE_NONE (-1) = no boost, use the normal
    // brightness. Dropped when send mode ends.
    private var sendBrightness: Float = WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE

    // Lowest custom level, so "still" at 0% is very dim but never black.
    private val minAppBrightness = 0.02f

    // QR decoding runs on one background thread so it never blocks the UI.
    private val qrExecutor = Executors.newSingleThreadExecutor()

    // Private native prefs that keep the user's original alarm volume and
    // DND mode while the app has changed them. If Android kills the process
    // before onPause/onDestroy run, the next start restores them from here.
    private val restorePrefsName = "native_restore_state"
    private val keySavedAlarmVolume = "saved_alarm_volume"
    private val keySavedInterruptionFilter = "saved_interruption_filter"

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
    // Saved interruption filter captured before enabling DND. Restored by [restoreDndNow].
    private var savedInterruptionFilter: Int? = null
    private val volumeHandler = Handler(Looper.getMainLooper())
    private val restoreAlarmVolumeRunnable = Runnable { restoreAlarmVolumeNow() }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        restoreLeftoverDeviceState()

        // On-device QR decoding for Optical Sync receive (ZXing). Dart sends
        // the brightness plane of one camera frame; the answer is the QR text
        // or null.
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            qrDecoderChannelName,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "decodeFrame" -> {
                    val bytes = call.argument<ByteArray>("bytes")
                    val width = call.argument<Int>("width")
                    val height = call.argument<Int>("height")
                    val rowStride = call.argument<Int>("rowStride")
                    if (bytes == null || width == null || height == null || rowStride == null) {
                        result.error("ARG_FRAME", "bytes, width, height and rowStride are required", null)
                        return@setMethodCallHandler
                    }
                    // Optional crop: decode only this part of the frame.
                    val cropLeft = call.argument<Int>("cropLeft") ?: 0
                    val cropTop = call.argument<Int>("cropTop") ?: 0
                    val cropWidth = call.argument<Int>("cropWidth") ?: width
                    val cropHeight = call.argument<Int>("cropHeight") ?: height
                    qrExecutor.execute {
                        try {
                            val text = QrFrameDecoder.decode(
                                bytes, width, height, rowStride,
                                cropLeft, cropTop, cropWidth, cropHeight,
                            )
                            runOnUiThread { result.success(text) }
                        } catch (e: Exception) {
                            runOnUiThread { result.error("QR_FAILURE", e.message, null) }
                        }
                    }
                }
                else -> result.notImplemented()
            }
        }

        // Screen brightness and Optical Sync send mode. Send mode keeps the
        // screen on at the normal brightness; the send screen's slider can
        // make it brighter while sending.
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            screenChannelName,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "setSendMode" -> {
                    setSendMode(call.argument<Boolean>("on") ?: false)
                    result.success(null)
                }
                "setAppBrightness" -> {
                    val value = call.argument<Double>("value")
                    if (value == null) {
                        result.error("ARG_VALUE", "value is required", null)
                    } else {
                        setAppBrightness(value.toFloat())
                        result.success(null)
                    }
                }
                "setSendBrightness" -> {
                    val value = call.argument<Double>("value")
                    if (value == null) {
                        result.error("ARG_VALUE", "value is required", null)
                    } else {
                        setSendBrightness(value.toFloat())
                        result.success(null)
                    }
                }
                "getCurrentBrightness" -> {
                    result.success(getCurrentBrightness().toDouble())
                }
                else -> result.notImplemented()
            }
        }

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
                "isDndAccessGranted" -> {
                    result.success(isDndAccessGranted())
                }
                "openDndSettings" -> {
                    openDndSettings()
                    result.success(null)
                }
                "setDndEnabled" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    result.success(setDndEnabled(enabled))
                }
                "restoreDnd" -> {
                    restoreDndNow()
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
        restoreDndNow()
        super.onPause()
    }

    override fun onDestroy() {
        volumeHandler.removeCallbacks(restoreAlarmVolumeRunnable)
        restoreAlarmVolumeNow()
        restoreDndNow()
        stopPreviewTone()
        qrExecutor.shutdown()
        setSendMode(false)
        super.onDestroy()
    }

    /**
     * Turns Optical Sync send mode on or off. On keeps the screen on at the
     * normal brightness. Off also drops any slider boost, so the user's own
     * brightness always comes back.
     */
    private fun setSendMode(on: Boolean) {
        if (on) {
            sendModeOn = true
            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        } else {
            if (!sendModeOn) return
            sendModeOn = false
            sendBrightness = WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE
            window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        }
        applyWindowBrightness(effectiveBrightness())
    }

    /**
     * Sets the send screen's brightness boost. A value below 0 goes back to
     * the normal brightness. Ignored when send mode is off.
     */
    private fun setSendBrightness(value: Float) {
        if (!sendModeOn) return
        sendBrightness = if (value < 0f) {
            WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE
        } else {
            value.coerceIn(minAppBrightness, 1f)
        }
        applyWindowBrightness(effectiveBrightness())
    }

    /** The window brightness that should be in effect right now. */
    private fun effectiveBrightness(): Float =
        if (sendModeOn && sendBrightness >= 0f) sendBrightness else appBrightness

    /**
     * The normal brightness, from 0 to 1: the in-app setting if one is set,
     * otherwise the system level (an approximation on devices whose system
     * scale is not 0..255). Falls back to 0.5 if it cannot be read.
     */
    private fun getCurrentBrightness(): Float {
        if (appBrightness >= 0f) return appBrightness
        return try {
            val level = Settings.System.getInt(
                contentResolver,
                Settings.System.SCREEN_BRIGHTNESS,
            )
            (level / 255f).coerceIn(0f, 1f)
        } catch (_: Exception) {
            0.5f
        }
    }

    /**
     * Applies the user's in-app brightness setting to this window. A value
     * below 0 follows the system. While a send-screen boost is active the
     * value is only stored, and applied when send mode turns off.
     */
    private fun setAppBrightness(value: Float) {
        appBrightness = if (value < 0f) {
            WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE
        } else {
            value.coerceIn(minAppBrightness, 1f)
        }
        applyWindowBrightness(effectiveBrightness())
    }

    private fun applyWindowBrightness(value: Float) {
        val attrs = window.attributes
        attrs.screenBrightness = value
        window.attributes = attrs
    }

    private fun isDndAccessGranted(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val nm = getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
            nm?.isNotificationPolicyAccessGranted ?: false
        } else {
            true
        }
    }

    private fun openDndSettings() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            try {
                val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                startActivity(intent)
            } catch (_: Exception) {}
        }
    }

    private fun setDndEnabled(enabled: Boolean): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val nm = getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager ?: return false
            if (!nm.isNotificationPolicyAccessGranted) return false
            return try {
                if (enabled) {
                    if (savedInterruptionFilter == null) {
                        val current = nm.currentInterruptionFilter
                        savedInterruptionFilter = current
                        restorePrefs().edit()
                            .putInt(keySavedInterruptionFilter, current)
                            .commit()
                    }
                    nm.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_PRIORITY)
                } else {
                    restoreDndNow()
                }
                true
            } catch (_: Exception) {
                false
            }
        }
        return false
    }

    private fun restoreDndNow() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val filter = savedInterruptionFilter ?: return
            val nm = getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
            if (nm?.isNotificationPolicyAccessGranted == true) {
                try {
                    nm.setInterruptionFilter(filter)
                } catch (_: Exception) {}
            }
            savedInterruptionFilter = null
            restorePrefs().edit().remove(keySavedInterruptionFilter).commit()
        }
    }

    private fun restorePrefs(): SharedPreferences =
        getSharedPreferences(restorePrefsName, Context.MODE_PRIVATE)

    /**
     * Undoes DND / alarm-volume changes left behind when Android killed the
     * process before [onPause] or [onDestroy] could restore them. A value is
     * only put back if it is still the one this app set (DND = priority,
     * alarm volume = max), so a change the user made later is never undone.
     */
    private fun restoreLeftoverDeviceState() {
        val prefs = restorePrefs()
        if (prefs.contains(keySavedAlarmVolume)) {
            val saved = prefs.getInt(keySavedAlarmVolume, -1)
            try {
                val am = getSystemService(Context.AUDIO_SERVICE) as? AudioManager
                if (am != null && saved >= 0) {
                    val max = am.getStreamMaxVolume(AudioManager.STREAM_ALARM)
                    if (am.getStreamVolume(AudioManager.STREAM_ALARM) == max) {
                        am.setStreamVolume(AudioManager.STREAM_ALARM, saved, 0)
                    }
                }
            } catch (_: Exception) {
                // best-effort
            }
            prefs.edit().remove(keySavedAlarmVolume).commit()
        }
        if (prefs.contains(keySavedInterruptionFilter)) {
            val saved = prefs.getInt(keySavedInterruptionFilter, -1)
            try {
                val nm = getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
                if (nm != null && saved >= 0 &&
                    nm.isNotificationPolicyAccessGranted &&
                    nm.currentInterruptionFilter == NotificationManager.INTERRUPTION_FILTER_PRIORITY
                ) {
                    nm.setInterruptionFilter(saved)
                }
            } catch (_: Exception) {
                // best-effort
            }
            prefs.edit().remove(keySavedInterruptionFilter).commit()
        }
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
                val current = am.getStreamVolume(AudioManager.STREAM_ALARM)
                savedAlarmVolume = current
                restorePrefs().edit().putInt(keySavedAlarmVolume, current).commit()
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
            restorePrefs().edit().remove(keySavedAlarmVolume).commit()
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
