# Mantra Japa Counter — App Overview & Feature Catalog

## App Description

**Mantra Japa Counter** (Package ID: `com.sreerajp.mantrajapacounter`, Version: `6.9.1+1`) is a privacy-first, fully offline Flutter mobile application crafted for spiritual practitioners, meditators, sadhakas, and devotees of all traditions, paths, and backgrounds to track mantra recitations (*japa* practice), prayers, chants, dynamic sacred affirmations, and spiritual disciplines. The application seamlessly bridges ancient mala counting traditions (108 beads per round) with modern digital capabilities including daily offering goals, lifetime vow/sankalpa tracking, multi-counter management, detailed session history analytics, customizable audio/haptic feedback, and robust data backup and restore functionality.

Designed to foster deep stillness, reverence, and undivided focus during meditation, the app features an inclusive, high-contrast visual design system inspired by South Indian temple architecture ("Temple" theme). It combines a serene cream and sandalwood color palette (`#FBF6EC`, `#D8A13A`), sacred traditional iconography (Om badge, temple arch, diya flame, lotus motif, and a 27-segment mala circle), custom variable typography (EB Garamond serif, Inter sans-serif, and Noto Sans Malayalam for Indic Unicode text), and subtle haptic/gesture responses. 

The application welcomes practitioners across all spiritual paths—Hindu *japa*, Buddhist *nembutsu* and *dharani*, Jain *Navkar* recitations, Sikh *Simran*, Christian Rosary and Jesus Prayer, Islamic *Tasbih* and *dhikr*, Sufi chants, secular mindfulness mantras, positive affirmations, and personal spiritual vows. It features complete localization in English (`en`) and Malayalam (`ml`) with full support for any Unicode script (Devanagari, Malayalam, Tamil, Gurmukhi, Latin, etc.).

---

## Core Technical & Architectural Profile

| Concern | Details / Package |
|---|---|
| **Framework & Engine** | Flutter (`sdk ^3.12.2`), Target SDK 35 (Android 15), Min SDK 29 (Android 10), Java 17 |
| **Desugaring** | `com.android.tools:desugar_jdk_libs:2.1.4` (Core JDK library desugaring for Java 8+ APIs) |
| **State Management** | `flutter_riverpod` (v3.3.1) with `AsyncNotifier` and `StateNotifier` architecture |
| **Navigation** | `go_router` (v17.2.2) with declarative routing and parameter passing |
| **Local Database** | `sqflite` (v2.4.2) with SQLite schema version 3 & `path` (v1.9.1) |
| **Key-Value Storage** | `shared_preferences` (v2.5.3) for settings and crash-recovery session state |
| **Audio Playback** | `audioplayers` (v6.1.0) + Native Android MethodChannel (`com.sreerajp.mantrajapacounter/haptic`) |
| **Notifications** | `flutter_local_notifications` (v21.0.0) |
| **File Picker & Sharing** | `file_picker` (v11.0.2) + `share_plus` (v12.0.2) + `path_provider` (v2.1.5) |
| **App Metadata & Utilities** | `package_info_plus` (v9.0.1), `logger` (v2.5.0), `uuid` (v4.5.1), `cupertino_icons` (v1.0.8) |
| **Localization** | `flutter_localizations` (`intl`) supporting English (`en`) & Malayalam (`ml`) |
| **Typography** | `EBGaramond` (variable font), `Inter` (variable font), `NotoSansMalayalam` (variable font) |
| **Native Integration** | `MainActivity.kt` Kotlin plugin implementing native `ToneGenerator` DTMF beeps, `USAGE_ALARM` audio/vibration attributes, ringtone query via `RingtoneManager`, and `STREAM_ALARM` volume boost/auto-restore (`6000ms` window) |
| **App Build Flavors** | `prod` (`Mantra Japa Counter`) and `dev` (`Mantra Japa Counter Dev`) with release signing enforcement in Gradle |
| **Ergonomics & Layout** | Locked in portrait mode (`SystemChrome.setPreferredOrientations`) for single-handed counting |
| **Privacy & Network** | **100% Offline** — Zero internet permissions, zero network calls, zero third-party analytics |

---

## Detailed Feature Catalog

### 1. Counter Management & Vow Tracking
- **Multiple Named Counters**: Create, edit, and track unlimited separate mantra counters (e.g., *Om Namah Shivaya*, *Gayatri Mantra*, *Hare Krishna*, *Mahamrityunjaya Mantra*, *Lalitha Sahasranamam*, custom prayers, dynamic affirmations, etc.).
- **Multi-Script & Unicode Character Support**: Complete support for English, Malayalam, Devanagari, Tamil, Gurmukhi, and all other script text for mantra names.
- **Initial Count Offset**: Set an initial count (default: 0) to migrate pre-existing paper logs, tally records, or physical bead counts seamlessly.
- **Custom Increment Step**: Configure custom increment step per tap (default: 1 count per tap; custom steps for multi-bead counts).
- **Lifetime Goal (Vow / Sankalpa)**: Set a target total chant count for a long-term vow/sankalpa (e.g., 100,000 chants; 0 = no lifetime goal).
- **Daily Goal (Offering)**: Set a daily target chant count (0 = no daily goal). Built-in field validation enforces that daily goals cannot exceed lifetime goals and increment steps must be smaller than daily goals.
- **Custom Start Date Picker**: Pick practice start dates (`showDatePicker`) for accurate daily average calculations.
- **Counter Lifecycle & Status**:
  - `ACTIVE`: Active counter available for counting sittings.
  - `DISABLED (SUCCESS)`: Archive counter as completed with an optional completion reason (e.g., "Completed 1 Lakh vow").
  - `DISABLED (NOT COMPLETED)`: Pause/disable counter with an optional reason.
- **Active-First List Sorting**: Home screen counters are automatically sorted with active counters first, then disabled counters, ordered chronologically by creation date (newest first).
- **Deterministic Color Accents**: Each counter card receives a stable color accent (Vermillion Red `#C8401E`, Tulsi Green `#3F6B3A`, Sandal Yellow `#D8A13A`, or Rose `#B8506A`) derived deterministically using a string code-unit sum algorithm on its unique ID, remaining consistent regardless of list sorting or edits.
- **Today Aggregate Header Pill**: Home screen displays a summary pill showing combined daily totals across all active counters:
  - Total Chants offered today.
  - Total Malas completed today.
  - Total Active Counters used today.
- **Counter Options Bottom Sheet**: Long-press any counter card to access quick actions: Counter Info/Stats, History, Edit, Disable as Completed, Disable/Pause, and Delete (with safety confirmation dialog).

---

### 2. Home Screen Counter Cards & Visual Indicators
- **Lotus Watermark Medallion**: Soft lotus medallion rendered as a top-right background watermark in the card's accent color.
- **27-Segment Prayer-Bead Daily Progress Strip**: Horizontal 27-segment progress strip echoing a 108-bead mala (each segment represents 4 beads or 1/27th of the daily goal). Filled segments highlight in the counter's accent color; unfilled segments display in subtle line color.
- **Visual Goal Badges**:
  - **Tulsi Checkmark Badge**: Green circle checkmark icon appears upon completing today's daily goal.
  - **Sandal Gold Trophy Badge**: Gold circle trophy icon appears upon reaching the lifetime goal.
- **Lifetime Goal Progress Bar**: Continuous progress bar showing lifetime vow completion percentage (`totalCount / goal`). Upon 100% completion, the card background shifts to a soft sandal tone (`#F7EED8`) with a sandal border (`#D8A13A`) and golden gradient bar.
- **Count & Mala Ratio Breakdown**: Clear numeric display of total counts, total malas completed (`totalCount ~/ 108`), today's chants, and today's mala progress vs daily target.
- **Disabled Status Markers**: Distinct checkmark (`Icons.check_circle`) or cancel (`Icons.cancel`) icons for archived or paused counters.

---

### 3. Interactive Counting Session & Gesture Engine
- **Visual 108-Bead Mala Circle**:
  - Central interactive medallion representing a traditional 108-bead mala (rendered as 27 visual segments × 4 beads).
  - Dynamic progress ring that fills smoothly bead-by-bead as chants are counted.
  - Large center display in EB Garamond showing current count within the mala (0–107), "of one hundred eight" label, remaining beads in the current mala countdown, and total malas completed during the active session.
  - Responsive medallion sizing clamped between 240px and 520px depending on screen aspect ratio and dimensions.
- **Touch Gesture Controls**:
  - **Tap to Count**: Single-finger tap anywhere inside the bead circle increments the count by the counter's step. Taps outside the circle are ignored to prevent accidental counts.
  - **Two-Finger Undo Swipe**: Place two fingers on the medallion and swipe horizontally (left or right) to decrement the count by 1 step. Triggers medium haptic feedback to confirm undo.
- **Live Session Timer**:
  - Live duration clock pill (`HH:MM:SS` or `MM:SS`) tracking elapsed active session time.
  - Pause-aware: Automatically pauses timer when app is backgrounded or inactive (`WidgetsBindingObserver` lifecycle handling), excluding idle time between pause and resume.
- **Smart Session Finalization**:
  - Mid-mala exits (`tapCount % 108 != 0`) automatically pause the active session so the user can resume from the exact same bead upon returning.
  - Exception: When a sub-mala daily goal (e.g., 50 chants) was set and already met today, exiting mid-mala auto-finalizes the session instead of pausing.
- **Goal Achievement Visual Highlights**:
  - Top bar diya flame icon and indicator dot change color upon reaching daily or lifetime goals.
  - Medallion background glow shifts to deep vermillion when daily goal is completed.
- **Session & Counter Quick Menu**:
  - Access Counter History (filtered to current counter).
  - Access Counter Statistics (`AboutCounterScreen`).
  - **Reset Session**: Discard current sitting and reset session tap count to 0 with confirmation dialog.
  - **Reset Counter**: Reset all session history and counters back to initial state with confirmation dialog.
- **Data Protection on Exit**:
  - Intercepts system back button/gesture (`PopScope`) to flush all pending in-memory taps to SQLite before navigating back, preventing data loss.

---

### 4. Session History, Analytics & Daily Summaries
- **Date-Grouped History Log**:
  - View full practice history grouped chronologically by date ("Today", "Day N").
  - Overall stats hero banner showing total chants offered, total malas, active days count, and percentage of vow completed.
  - Interactive Diya progress bar track showing lifetime vow completion progress.
  - Filter history log by individual mantra counter or view across all counters.
- **Date-Level Cumulative Progress Tracking**:
  - Displays cumulative total at the end of each day (`count / lifetimeGoal`) and daily completion percentage.
- **Session Detail Records**:
  - Displays timestamp (`HH:MM`), duration (formatted in hours, minutes, and seconds), total count, and mala breakdown for each sitting.
  - Expands to show individual session rows with counter name when viewing history across all counters.
- **Session Deletion & Management**:
  - **Delete Single Session**: Delete an individual sitting with immediate recalculation of cumulative totals and date group summaries.
  - **Clear Counter History**: Delete all historical sessions for a specific counter with confirmation dialog.
  - **Clear All History**: Wipe all session records across all counters with confirmation dialog.
- **Counter Statistics & Details (`AboutCounterScreen`)**:
  - Three circular progress gauges showing Lifetime Progress %, Today's Goal Progress %, and Total Malas Completed.
  - Status badge highlighting completed or disabled counters with optional reason.
  - Comprehensive details table: Name, Status, Increment Step, Initial Count, Lifetime Goal, Daily Goal, Started Date, Created Date, Average Daily Chants (calculated from start date to current date), Disabled Date, and Disabled Reason.

---

### 5. Audio, Haptic & Notification System
- **Mala Round Completion (108 Beads)**:
  - **Mala Soft Beep**: Synthesized native 100ms DTMF tone via Android `ToneGenerator` (requires no external audio assets; plays on `STREAM_ALARM` at boosted volume to bypass silent/DND modes).
  - **Mala Vibration**: Native single-pulse vibration (250ms at max amplitude using `USAGE_ALARM` attributes to bypass silent/DND modes).
  - Configurable toggle in Settings ("Enable mala sound").
- **Daily Goal Completion**:
  - **Goal Ringtone Playback**: Plays configured notification sound on reaching the daily goal.
  - **Goal Vibration**: Native triple-pulse vibration pattern (`220ms / 90ms / 220ms / 90ms / 220ms` at max amplitude using `USAGE_ALARM`).
  - **Status-Bar Notification Toast**: Displays a system status-bar notification ("Daily Goal Achieved").
  - Configurable notification & vibration toggles in Settings.
- **Smart Audio Suppression**: When the 108th bead in a mala also completes the daily goal, the mala sound is automatically omitted to avoid audio overlap with the daily goal completion tone.
- **Notification Ringtone Customization**:
  - **System Default Tone**: Use device default notification ringtone.
  - **System Ringtone Picker**: Browse and select from native Android system notification ringtones via `RingtoneManager`.
  - **Custom Audio File Picker**: Select custom MP3/WAV/AAC audio files from local storage using `file_picker`.
  - **Native Volume Boost**: Native MethodChannel boosts `STREAM_ALARM` volume during playback so completion tones remain audible in low-volume modes, with a 6-second auto-restore timeout and automatic restoration in `onPause`/`onDestroy`.
  - **Preview Tone**: In-settings button to preview the selected notification tone immediately.

---

### 6. Data Backup, Restore & Dual-Tier Persistence
- **Optical Air-Gap Sync (High-Density Animated QR Stream)**:
  - **100% Offline Device-to-Device Sync**: Transfer all counters, active sitting progress, and practice history between nearby mobile devices using screen-to-camera animated QR streams (10–15 FPS) without Wi-Fi, Bluetooth, NFC, local sockets, or cloud infrastructure.
  - **Fountain Code Engine (Luby Transform / LT)**: Encodes full backup payloads into systematic chunks and LT XOR parity frames (`AIRQR|LT1` format) with IEEE 802.3 CRC32 checksum verification.
  - **Loss-Tolerant Scanning**: Camera frame drops do not block decoding; missing fragments are automatically reconstructed out-of-order via belief propagation / Gaussian elimination over GF(2).
  - **Interactive Import Preview**: Scanned streams trigger an interactive preview sheet detailing counter and session counts before merging atomically into local SQLite storage.
- **JSON Import / Export Backup System**:
  - **Export Data**: Backup all counters and session history into a single JSON file (`mantra_japa_counter_backup.json`) and open the native system share sheet (`share_plus`).
  - **Import Data**: Restore data from a JSON backup file. Replaces database contents atomically inside a single SQLite transaction to guarantee zero data corruption on invalid/corrupted files.
  - **Gson & Android Schema Compatibility**: JSON export/import format is 100% byte-compatible with the legacy Android/Kotlin app (Schema Version 3).
- **Dual-Tier Zero Data Loss Protection**:
  - **Tier 1 (SharedPreferences)**: Fast state persistence every 5 taps or 5 seconds for instant crash recovery.
  - **Tier 2 (sqflite DB)**: Batched database transaction write every 20 taps or 30 seconds (or immediately on the very first tap of a session).
  - **App Start Recovery (`SessionRecoveryService`)**: Auto-reconciles pending SharedPreferences active sessions with the SQLite database on app startup.
- **Clear All Data**: Settings option to permanently erase all counters, active session states, and historical data with double confirmation.

---

### 7. Display & Stillness Mode (Screen Brightness)
- **Stillness Brightness Control**:
  - Custom brightness slider in Settings designed for long meditation / *japa* sessions.
  - **Modes**: Follow System Default, Custom Dimmed ("still"), or Full Brightness ("full").
  - Percentage indicator display and quick "Use System" reset option (`-1.0`).

---

### 8. App Info & Metadata Screen (`AboutScreen`)
- **Dynamic App Versioning**: Automatically retrieves app version and build number at runtime via `package_info_plus`.
- **Purpose & Vision Statement**: Outlines the core philosophy of providing a sacred, distraction-free environment for mantra counting.
- **100% Offline Pledge**: Emphasizes complete offline operation without internet connectivity.
- **Privacy & Security Commitment**: Confirms that all practice records remain strictly on the user's local device.
- **Data Portability**: Explains the JSON backup/export feature for data ownership.
- **Spiritual Quote & Developer Credit**: Displays an inspirational mantra quote and devotional credit ("Made with love for sadhakas").

---

### 9. Privacy, Security & Battery Optimization
- **100% Offline & Private**:
  - Zero internet permissions requested in `AndroidManifest.xml`.
  - Zero network calls, zero third-party SDK analytics, zero crash reporting. All data stays strictly on the user's device.
- **Power & Battery Efficiency**:
  - Display timer ticks once per second without continuous background database polling.
  - Batched SQLite writes reduce disk write cycles and battery drain during extended counting sessions.

---

### 10. Localization, Design & Accessibility
- **Multilingual Support**: Fully localized in **English (`en`)** and **Malayalam (`ml`)**.
- **Devotional Temple Design System**:
  - Cream background (`#FBF6EC`), vermillion primary accents (`#C8401E`), sandalwood yellow highlights (`#D8A13A`), tulsi green completion markers (`#3F6B3A`), and rose accent (`#B8506A`).
  - Custom vector graphics: Om badge, South Indian temple arch, diya lamp, lotus flower, and 27-segment mala circle.
  - Custom typography: EB Garamond (italic serif numerals & captions), Inter (clean UI sans-serif), and Noto Sans Malayalam (Indic script).
- **Portrait Orientation Lock**: App locked in portrait mode (`SystemChrome.setPreferredOrientations`) for optimal one-handed counting ergonomics.

---

### 11. Help & Practice Guide (`HelpScreen`)
- **In-App Practice Guide (`HelpScreen`)**:
  - Explains counting gestures (tap to count inside bead circle).
  - Explains two-finger horizontal swipe for undo.
  - Explains session timer, pause state, and goal completion indicators.
  - Explains session reset vs. counter reset functionality.
