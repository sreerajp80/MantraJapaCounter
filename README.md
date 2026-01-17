# 📿 Mantra Japa Counter

<div align="center">

A simple and elegant Android app for counting mantras and tracking japa meditation sessions. Built with love for spiritual practice.

![Version](https://img.shields.io/badge/version-4.20-blue.svg)
![Min SDK](https://img.shields.io/badge/min%20SDK-29-green.svg)
![Target SDK](https://img.shields.io/badge/target%20SDK-35-orange.svg)
![Kotlin](https://img.shields.io/badge/kotlin-2.3.0-purple.svg)

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Contributing](#-contributing)

</div>

---

## 📖 About

Mantra Japa Counter is a modern Android application designed to help practitioners track their mantra chanting and japa meditation sessions. The app provides an intuitive interface for counting, session tracking, goal setting, and progress monitoring. Whether you're practicing a single mantra or multiple mantras, this app helps you maintain consistency and track your spiritual journey.

## ✨ Features

### Core Features
- **📊 Multiple Counters**: Create and manage multiple counters for different mantras
- **👆 Tap to Count**: Simple tap interface with customizable increment steps (1, 3, 5, etc.)
- **⏱️ Session Tracking**: Automatic tracking of session duration and counts
- **📿 Mala Counting**: Automatic calculation of malas (rounds of 108 beads)
- **📅 History Management**: View detailed session history grouped by days
- **🎯 Goal Setting**: Set daily and lifetime goals for each counter
- **📈 Progress Tracking**: Visual progress indicators for goals with real-time updates

### Advanced Features
- **💾 Import/Export**: Backup and restore your data in JSON format
- **🔢 Initial Count**: Set starting counts for existing practice
- **⚙️ Custom Increment**: Configure counting steps to match your practice style
- **🔄 Session Persistence**: Resume interrupted sessions automatically
- **📱 Responsive Design**: Optimized for phones and tablets with Material Design 3
- **🔔 Notifications**: Customizable vibration and sound alerts for:
  - Daily goal achievement
  - Mala completion (every 108 counts)
- **🌙 Settings Screen**: Configure notification preferences, tones, and vibration patterns
- **📊 Statistics**: View average daily counts and detailed counter information
- **🚫 Counter Management**: Enable/disable counters with reasons

## 🚀 Getting Started

### Prerequisites

- **Android Studio**: Hedgehog (2023.1.1) or later (recommended: Latest version)
- **Android SDK**: 
  - Minimum SDK: 29 (Android 10)
  - Target SDK: 35 (Android 15)
  - Compile SDK: 36
- **Kotlin**: 2.3.0 or higher
- **JDK**: 17 or higher
- **Gradle**: 8.13.0 or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/sreerajp80/MantraJapaCounter.git
   cd MantraJapaCounter
   ```

2. **Open the project in Android Studio**
   - Launch Android Studio
   - Select `File` → `Open`
   - Navigate to the cloned directory and select it

3. **Sync project with Gradle files**
   - Android Studio will automatically prompt to sync
   - Or click `Sync Now` if prompted
   - Wait for Gradle to download dependencies

4. **Run the app**
   - Connect an Android device or start an emulator (API 29+)
   - Click the `Run` button (▶️) or press `Shift + F10`
   - Select your target device

### Building from Source

```bash
# Build debug APK
./gradlew assembleDebug

# Build release APK (requires signing configuration)
./gradlew assembleRelease

# Install on connected device
./gradlew installDebug
```

The APK will be generated at:
- Debug: `app/build/outputs/apk/debug/MantraJapaCounter-v4.20-debug.apk`
- Release: `app/build/outputs/apk/release/MantraJapaCounter-v4.20.apk`

## 📖 Usage

### Creating a Counter

1. Tap the **+** button on the main screen
2. Enter counter name (e.g., "Om Namah Shivaya", "Hare Krishna", etc.)
3. Set initial count (if continuing existing practice)
4. Configure increment step (default: 1, can be 1, 3, 5, etc.)
5. Set daily and lifetime goals (optional)
6. Tap **Save** to create the counter

### Counting

1. Select a counter from the list on the main screen
2. Tap the large circular area to increment count
3. Use the red **-** button to decrement if needed
4. Session automatically tracks time and counts
5. Progress towards goals shown at the top with visual indicators
6. Mala count (rounds of 108) is automatically calculated
7. Session is saved every 10 seconds automatically

### Viewing History

1. Tap the menu (⋮) and select **"History"**
2. View sessions grouped by day
3. Tap on a day to expand and see individual sessions
4. Each session shows:
   - Date and time
   - Duration
   - Count and malas
   - Counter name
5. Delete individual sessions or clear all history

### Import/Export

1. Open menu and select **"Import/Export"**
2. Choose **Export** to save all data to a JSON file
3. Choose **Import** to restore from a backup
4. **⚠️ Warning**: Import replaces all existing data

### Settings

1. Open menu and select **"Settings"**
2. Configure notification preferences:
   - Enable/disable daily goal notifications
   - Enable/disable vibration
   - Enable/disable sound
   - Select custom notification tone
   - Enable/disable mala completion sound

### Counter Details

1. Tap on a counter's info icon (ℹ️) to view:
   - Total count and malas
   - Average daily count
   - Start date
   - Goals and progress

## 🏗️ Architecture

The app follows **MVVM architecture** with **Repository pattern**:

```
app/src/main/java/com/sreerajp/mantrajapacounter/
├── MainActivity.kt                    # Main entry point, navigation
├── screens/                           # UI screens (Jetpack Compose)
│   ├── CounterListScreen.kt          # Main counter list
│   ├── CountingScreen.kt             # Active counting interface
│   ├── HistoryScreen.kt               # Session history view
│   ├── AboutScreen.kt                 # App information
│   ├── AboutCounterScreen.kt         # Counter details
│   └── SettingsScreen.kt               # App settings
├── database/                          # Room database layer
│   ├── JapaCounterDatabase.kt        # Room database instance
│   ├── CounterEntity.kt               # Counter data entity
│   ├── JapaSessionEntity.kt          # Session data entity
│   ├── CounterDao.kt                  # Counter data access
│   ├── JapaSessionDao.kt             # Session data access
│   ├── JapaCounterRepository.kt      # Repository implementation
│   └── DatabaseMigrationHelper.kt    # Migration utilities
├── data/                              # Data models and utilities
│   ├── Models.kt                      # Data classes
│   ├── DataUtils.kt                   # Data utilities
│   └── ExportData.kt                 # Import/Export models
├── ui/                                # UI theme and styling
│   └── theme/
│       ├── Color.kt                   # Color definitions
│       ├── Theme.kt                   # Material 3 theme
│       ├── Type.kt                    # Typography
│       └── Typography.kt              # Text styles
└── utils/                             # Utility classes
    ├── FileUtils.kt                   # File operations
    └── DailyGoalNotificationHelper.kt # Notification management
```

### Key Design Patterns

- **MVVM**: Separation of UI and business logic
- **Repository Pattern**: Single source of truth for data
- **Observer Pattern**: Reactive UI with Kotlin Flow
- **Singleton**: Database instance management

## 🛠️ Tech Stack

| Category | Technology | Version |
|----------|-----------|---------|
| **Language** | Kotlin | 2.3.0 |
| **UI Framework** | Jetpack Compose | Latest (via BOM) |
| **Material Design** | Material 3 | Latest |
| **Database** | Room | 2.8.0 |
| **Architecture** | MVVM + Repository | - |
| **Async** | Kotlin Coroutines & Flow | - |
| **Serialization** | Gson | 2.13.2 |
| **Build System** | Gradle (Kotlin DSL) | 8.13.0 |
| **Android Gradle Plugin** | 8.13.2 | - |
| **Min SDK** | 29 (Android 10) | - |
| **Target SDK** | 35 (Android 15) | - |
| **Compile SDK** | 36 | - |

### Key Libraries

- **Jetpack Compose BOM**: 2025.09.00
- **Activity Compose**: 1.11.0
- **Lifecycle Runtime KTX**: 2.9.3
- **Room Runtime**: 2.8.0
- **Room KTX**: 2.8.0
- **Preference KTX**: 1.2.1
- **Material 3 Window Size Class**: 1.3.2

## 🔐 Permissions

The app requires the following permissions:

| Permission | Purpose |
|------------|---------|
| `VIBRATE` | Alert when daily goal is reached or mala is completed |
| `READ_MEDIA_AUDIO` (Android 13+) | Select custom notification tones |
| `READ_EXTERNAL_STORAGE` (Android ≤12) | Legacy file access for import/export |
| `WAKE_LOCK` | Keep screen on during japa sessions |
| `INTERNET` | Future features (currently unused) |
| `RECORD_AUDIO` | Future voice counting feature (currently unused) |

All permissions are requested with clear explanations and can be managed in the app Settings.

## 🎯 Key Features Implementation

### Goal System
- **Daily Goals**: Reset automatically each day at midnight
- **Lifetime Goals**: Track overall progress across all sessions
- **Visual Indicators**: Progress bars and achievement badges
- **Smart Validation**: Daily goals must be less than lifetime goals
- **Notifications**: Alert when daily goal is achieved

### Session Management
- **Auto-save**: Sessions saved every 10 seconds during active counting
- **Persistence**: Resume sessions after app restart or crash
- **Duration Tracking**: Accurate time measurement with millisecond precision
- **Crash Recovery**: Active sessions preserved across app restarts
- **Session Finalization**: Sessions are finalized when leaving counting screen

### Data Management
- **Room Database**: Reliable local storage with SQLite
- **Migration Support**: Automatic migration from SharedPreferences to Room
- **Export Format**: Human-readable JSON with all counters and sessions
- **Data Integrity**: Transaction support for atomic operations
- **Schema Versioning**: Database schema versioning for future updates

### Notifications
- **Daily Goal Alert**: Vibration and/or sound when daily goal is reached
- **Mala Completion**: Optional notification every 108 counts
- **Customizable**: Enable/disable vibration and sound independently
- **Custom Tones**: Select from system notification tones

## 📱 Screenshots

> **Note**: Add screenshots of your app here. You can add them to a `screenshots/` directory and reference them like:
> 
> ```markdown
> ![Counter List](screenshots/counter_list.png)
> ![Counting Screen](screenshots/counting_screen.png)
> ![History](screenshots/history.png)
> ![Settings](screenshots/settings.png)
> ```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. **Fork the project**
2. **Create your feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit your changes** (`git commit -m 'Add some AmazingFeature'`)
4. **Push to the branch** (`git push origin feature/AmazingFeature`)
5. **Open a Pull Request**

### Development Guidelines

- Follow Kotlin coding conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Test on multiple Android versions (29+)
- Ensure Material Design 3 compliance
- Update documentation for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Sreeraj P**

- GitHub: [@sreerajp80](https://github.com/sreerajp80)

## 🙏 Acknowledgments

- Built with love for spiritual practice
- Inspired by traditional japa mala counting
- Thanks to all beta testers and contributors
- Material Design 3 for beautiful UI components
- Android Jetpack team for excellent libraries

## 📞 Support

For support, feature requests, or bug reports, please open an issue in the [GitHub repository](https://github.com/sreerajp80/MantraJapaCounter/issues).

## 🔮 Future Enhancements

Potential features for future releases:
- Voice counting recognition
- Cloud backup and sync
- Widget support for quick access
- Dark mode enhancements
- Multiple language support
- Statistics and analytics dashboard
- Reminder notifications
- Export to CSV/Excel

---

<div align="center">

**Made with ❤️ for spiritual practice**

*May this tool help you on your spiritual journey*

</div>
