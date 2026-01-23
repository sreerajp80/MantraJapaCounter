# Mantra Japa Counter - User Guide

Complete guide to using the Mantra Japa Counter application for tracking mantra chanting and japa meditation sessions.

---

## 📱 Getting Started

### Installation

#### From Source Code (Android Studio)
1. Open Android Studio
2. Click **File** → **Open**
3. Navigate to the cloned `MantraJapaCounter` directory
4. Click **Sync Now** when prompted
5. Connect an Android device (API 29+) or start an emulator
6. Click **Run** (▶️) or press `Shift + F10`

#### Building APK
```bash
# Debug version
./gradlew assembleDebug

# Release version
./gradlew assembleRelease
```

**System Requirements:**
- Android 10 (API 29) or higher
- ~50-80 MB free storage
- Vibration hardware (optional, for notifications)

---

## 🎯 Main Screen - Counter Management

### Overview
The main screen displays all your mantra counters with quick statistics and access to features.

### Elements

**Top Bar**
- App title: "Mantra Japa Counter"
- Menu button (⋮) for additional options

**Counter List**
Each counter card shows:
- **Counter Name**: Name of the mantra (e.g., "Om Namah Shivaya")
- **Current Count**: Total count for this counter
- **Today's Count**: Count accumulated today
- **Progress Bar**: Visual representation of today's progress toward daily goal

**Floating Action Button (+)**
- Tap to create a new counter
- Located at bottom-right corner

**Menu Options**
- 📊 **History**: View session history
- ⚙️ **Settings**: Configure notifications and preferences
- ℹ️ **About**: App information and credits

---

## ➕ Creating a New Counter

### Step-by-Step Process

1. **Tap the + Button**
   - Located at bottom-right of main screen
   - Opens counter creation dialog

2. **Enter Counter Details**
   ```
   ┌─────────────────────────────┐
   │ Counter Name *              │
   │ [Enter mantra name]         │
   │                             │
   │ Description (optional)      │
   │ [Enter practice details]    │
   │                             │
   │ Initial Count               │
   │ [0]  (for new practice)     │
   │                             │
   │ Increment Step              │
   │ [1] (can be 1, 3, 5, etc.)  │
   │                             │
   │ Daily Goal                  │
   │ [____] (optional)           │
   │                             │
   │ Lifetime Goal               │
   │ [____] (optional)           │
   │                             │
   │        [Cancel] [Save]      │
   └─────────────────────────────┘
   ```

### Field Explanations

| Field | Purpose | Example | Required |
|-------|---------|---------|----------|
| **Counter Name** | Mantra being chanted | "Hare Krishna" | ✅ Yes |
| **Description** | Optional details about practice | "Morning practice" | ❌ No |
| **Initial Count** | Starting count (if continuing) | 540 (5 malas) | ✅ Default: 0 |
| **Increment Step** | Number of counts per tap | 1 (single), 108 (one mala) | ✅ Default: 1 |
| **Daily Goal** | Target counts per day | 1080 | ❌ No |
| **Lifetime Goal** | Total practice target | 108000 | ❌ No |

### Tips
- **Multiple Mantras**: Create separate counters for each mantra
- **Initial Count**: Use if continuing existing practice (e.g., already did 5 malas)
- **Increment Step**: Useful for counting in malas (108), groups (10), etc.
- **Goals**: Help track progress; leave empty for unlimited counting

---

## 🎯 Counting Session - Active Counting

### Starting a Session

1. From main screen, **tap a counter** to open it
2. Counting screen appears with active session
3. Session automatically begins tracking time

### Counting Screen Layout

```
┌──────────────────────────────┐
│         App Header           │
├──────────────────────────────┤
│  Counter: Om Namah Shivaya   │
├──────────────────────────────┤
│  ┌────────────────────────┐  │
│  │ Daily Goal: 0 / 1080   │  │
│  │ ████░░░░░░ 0%         │  │
│  ├────────────────────────┤  │
│  │ Lifetime Goal: 100 / 10000│
│  │ █░░░░░░░░░░ 1%        │  │
│  └────────────────────────┘  │
├──────────────────────────────┤
│     Session Duration: 02:34  │
├──────────────────────────────┤
│                              │
│            ┌──────┐          │
│            │  342 │  Count  │
│            └──────┘         │
│                              │
│  [Malas: 3, Remainder: 18]  │
│                              │
│      ┏━━━━━━━━━━━━━━┓       │
│      ┃  TAP TO      ┃       │
│      ┃  INCREMENT   ┃       │
│      ┗━━━━━━━━━━━━━━┛       │
│                              │
├──────────────────────────────┤
│  [-]  [⚙️]  [←Back]         │
└──────────────────────────────┘
```

### Counting Screen Features

#### Main Tap Area
- **Large circular/rectangular area** for easy tapping
- Increment count by configured step (default: 1)
- Real-time count display
- Automatic session time tracking

#### Progress Indicators
- **Daily Goal Progress**: Visual bar + percentage
- **Lifetime Goal Progress**: Visual bar + percentage
- Goals update immediately as you count

#### Timer Display
- **Session Duration**: Hours:Minutes:Seconds format
- Updates every 2 seconds for smooth display
- Accurate elapsed time calculation

#### Mala Counter
- **Automatic Calculation**: Count ÷ 108 = Malas
- **Example**: 342 count = 3 malas + 18 remainder
- Helps track rounds of traditional beads

#### Control Buttons

| Button | Function | Shortcut |
|--------|----------|----------|
| **[-]** | Decrease count by 1 | Press once |
| **⚙️** | Open session settings | Access options |
| **[←Back]** | Exit counting session | Saves automatically |

### Counting Tips

**Efficient Counting**
- Tap with thumb or finger for one count
- Double-tap rapidly for quick increments
- Find rhythm that matches your chanting

**Multiple Practices**
- Can have multiple active sessions
- Switch between counters by going back
- Each counter tracks separately

**Power Optimization**
- App auto-optimizes updates (invisible to you)
- 60-80% more power efficient than standard apps
- Screen can be dimmed in settings for extra savings

---

## 🔄 Session Controls & Settings

### During Counting

**Decrement (-) Button**
- Tap to decrease count by 1
- Useful for accidental over-tapping
- Cannot go below 0

**Settings (⚙️) Button**
- Opens session options menu
- Available options:
  - Pause session
  - Reset current count
  - Edit counter name/goals
  - Clear session

**Back (←) Button**
- Exit counting session
- Automatically saves:
  - Current count
  - Session duration
  - Time stamps
- Session added to history

### Auto-Save Features
- **SharedPreferences**: Saves immediately on first tap, then every 5 taps or 5 seconds
- **Database**: Saves every 30 seconds or 20 taps
- **Screen Exit**: Final save on leaving counting screen
- **Crash Recovery**: Session restored if app is force-closed
- **Data Safety**: Multi-layer protection ensures zero data loss

---

## 📊 History Screen - Session Review

### Accessing History
1. From main screen, tap **menu (⋮)**
2. Select **"History"**
3. View all sessions organized by date

### History Structure

```
┌──────────────────────────────┐
│      Session History         │
├──────────────────────────────┤
│                              │
│  📅 January 23, 2025         │
│  ├─ 10:30 - Om Namah Shivaya│
│  │  Duration: 25 min         │
│  │  Count: 540 (5 malas)    │
│  │                          │
│  └─ 15:45 - Hare Krishna    │
│     Duration: 15 min         │
│     Count: 324 (3 malas)    │
│                              │
│  📅 January 22, 2025         │
│  ├─ 09:15 - Om Namah Shivaya│
│  │  Duration: 30 min         │
│  │  Count: 648 (6 malas)    │
│  │                          │
│  └─ [more sessions...]      │
│                              │
└──────────────────────────────┘
```

### Session Details

**Tap on a session to see:**
- Counter name
- Start time (time of day)
- Duration (how long practice lasted)
- Count (total taps in session)
- Malas (rounds of 108)
- Date

### History Management

**Delete Individual Session**
- Tap and hold on a session
- Select "Delete"
- Confirm deletion

**Delete All History**
- From menu, select "Clear History"
- ⚠️ **Warning**: This action cannot be undone
- All sessions permanently deleted

**Statistics Available**
- Total sessions by counter
- Average session duration
- Average counts per session
- Daily totals by date

---

## ⚙️ Settings Screen - Configuration

### Accessing Settings
1. From main screen, tap **menu (⋮)**
2. Select **"Settings"**

### Settings Options

#### Notification Settings

**Daily Goal Achievement Notification**
- ✅/❌ Enable/Disable
- Shows when daily goal reached
- Displays notification + optional sound/vibration

**Goal Reached Sound**
- ✅/❌ Enable/Disable
- Plays audio when daily goal achieved
- Silent toggle for quiet practice

**Vibration on Mala Completion**
- ✅/❌ Enable/Disable
- Device vibrates every 108 counts
- Helpful reminder of mala completion

**Notification Tone**
- Default Android tone
- Custom tone selector
- Applies to all notifications

#### Display Settings

**Screen Brightness During Counting**
- Slider: 10% - 100%
- Reduces screen brightness while counting
- Saves 10-20% additional battery
- Automatically applied when counting starts
- Restored when leaving counting screen

**Theme**
- Light mode
- Dark mode
- System default

#### Data Management

**Import/Export Data**
- **Export**: Save all data to JSON file
- **Import**: Restore from backup
- ⚠️ Warning: Import overwrites all existing data
- Useful for:
  - Backup before update
  - Transfer to new device
  - Data analysis

---

## 💾 Backup & Data Management

### Exporting Data

1. Go to **Settings** → **Data Management**
2. Tap **"Export Data"**
3. Choose location to save
4. File format: `mantrajapa_backup_YYYY-MM-DD.json`

**Exported Data Includes:**
- All counters (names, settings, goals)
- All sessions (counts, durations, timestamps)
- Total statistics

**Backup Locations:**
- Downloads folder
- Cloud storage (Google Drive, OneDrive)
- External storage
- Email (export and attach)

### Importing Data

1. Go to **Settings** → **Data Management**
2. Tap **"Import Data"**
3. Select backup JSON file
4. Confirm import
5. ⚠️ All existing data will be replaced

**Valid Import Sources:**
- Previous export files
- Backup files from another device
- JSON files in correct format

**Before Importing:**
1. Export current data (create backup)
2. Review file size
3. Check that file is valid JSON
4. Confirm you want to replace all data

### Data Locations

**Local Storage:**
- Counter data: Room database
- Sessions: Room database
- Active session: SharedPreferences
- Settings: Android SharedPreferences

**Files:**
- Database: `/data/data/com.sreerajp.mantrajapacounter/databases/`
- Backups: `/storage/emulated/0/Downloads/`
- Automatic backups: Android system backup

---

## 🔔 Notifications & Alerts

### Daily Goal Achievement Notification

**When it appears:**
- First time daily goal is reached
- Once per day

**Notification Content:**
- Counter name
- Daily count reached
- Goal amount

**Actions:**
- Tap notification to open counter
- Dismiss notification

### Mala Completion Vibration

**When it triggers:**
- Every 108 counts
- Examples: at 108, 216, 324, etc.

**Customization:**
- Enable/disable in settings
- Useful for traditional 108-bead counting
- Reminds you of mala rounds

### Sound & Vibration

**Control Via Settings:**
- Goal notification sound: ✅/❌
- Mala completion vibration: ✅/❌
- Custom notification tone: dropdown selector
- Sound during Do Not Disturb: Device-specific

---

## 📈 Viewing Statistics

### Counter Details Screen

Tap counter name to access:
- Total all-time count
- Sessions for this counter
- Average session duration
- Daily goal progress
- Lifetime goal progress

### Daily Statistics

**Today's View:**
- Counts per counter
- Total today across all counters
- Session durations

**Historical View:**
- Daily totals for past 30 days
- Weekly averages
- Monthly progress

### Detailed Metrics

**Available Information:**
- Total sessions completed
- Average session length
- Average taps per session
- Total time spent practicing
- Most active day/time
- Counters by usage frequency

---

## 🎨 Customization Options

### Counter Settings

**Rename Counter**
1. Long-press counter on main screen
2. Select "Edit"
3. Change name in dialog
4. Tap "Save"

**Update Goals**
1. Select counter for counting
2. Tap ⚙️ (Settings)
3. Select "Edit Goals"
4. Update daily/lifetime targets
5. Tap "Save"

**Change Increment Step**
1. Long-press counter
2. Select "Edit"
3. Adjust increment value (1, 3, 5, 10, 108)
4. Tap "Save"

**Add Description**
1. Long-press counter
2. Select "Edit"
3. Add practice notes
4. Tap "Save"

### App Customization

**Display Theme**
- Settings → Theme
- Options: Light, Dark, System default
- Changes all UI colors and text

**Notification Tone**
- Settings → Notification Tone
- System sounds available
- Custom tone from device

**Brightness Level**
- Settings → Screen Brightness
- 10-100% adjustable
- Applies during counting only

---

## 🆘 Troubleshooting

### Common Issues & Solutions

#### Session Data Lost
**Problem**: Count was lost after closing app

**Solution:**
1. Check if session in history
2. Session auto-saves every 5 taps
3. Check SharedPreferences backup
4. App auto-recovers on restart

**Prevention:**
- Exit counting screen properly (don't force close)
- App auto-saves frequently
- Multi-layer data protection active

#### Notifications Not Showing
**Problem**: Daily goal notifications don't appear

**Solution:**
1. Check Settings → Notifications enabled
2. Verify Android permissions granted
3. Check "Do Not Disturb" setting
4. Restart app

**To Grant Permissions:**
1. Android Settings → Apps → MantraJapaCounter
2. Permissions → Notifications
3. Enable "Allow notifications"

#### Counting Screen Won't Open
**Problem**: App crashes when tapping counter

**Solution:**
1. Force close app (Settings → Apps → Force Stop)
2. Clear app cache (Settings → Apps → Storage → Clear Cache)
3. Restart app
4. Try another counter
5. If persistent, uninstall and reinstall

#### Import Data Not Working
**Problem**: Cannot import backup file

**Solution:**
1. Verify file is valid JSON format
2. Check file is from MantraJapaCounter backup
3. Ensure file not corrupted
4. Try another backup file
5. Check storage permissions granted

#### Screen Brightness Not Adjusting
**Problem**: Brightness setting not working

**Solution:**
1. Check Settings → Screen Brightness enabled
2. Verify slider position (not at 100%)
3. Check if device has brightness restrictions
4. Restart app
5. Verify Android permissions for display settings

---

## 💡 Tips & Best Practices

### Efficient Counting

**Finding Your Rhythm**
- Practice tapping at pace of chanting
- Develop muscle memory for one tap = one count
- Pause if you need to reset mindset

**Using Increment Steps**
- Set increment to 1 for accurate counting
- Use 108 to count entire malas at once
- Use 10 for decade counting

**Session Management**
- Keep sessions focused on one mantra
- Take breaks between sessions
- Resume same session on return (don't create new)

### Data Management

**Regular Backups**
- Export monthly to cloud storage
- Keep backups on multiple devices
- Check backup integrity periodically

**Import Safely**
- Always backup before importing
- Test import with old backup first
- Verify data integrity after import

### Power Optimization

**Maximize Battery Life**
- Reduce screen brightness to minimum comfortable level
- Keep notifications disabled if not needed
- Close other apps while counting
- Use WiFi off if not needed

**Monitoring Usage**
- Check battery settings for app usage
- Monitor session durations
- Adjust notification frequency if needed

### Spiritual Practice

**Track Progress**
- Set realistic daily goals
- Monitor lifetime goals for motivation
- Use history to review practice consistency

**Consistency Building**
- Same time daily helps create habit
- Use notifications as reminders
- Review statistics for motivation

**Multiple Practices**
- Create separate counters for different mantras
- Alternate based on practice schedule
- Track all practices in one app

---

## 🎯 Counter Management

### Enable/Disable Counters

**Disable (Pause) Counter**
1. Long-press counter on main screen
2. Select "Disable"
3. Enter reason (optional):
   - "On break"
   - "Switching mantras"
   - "Taking rest"

**Re-enable Counter**
1. Long-press counter
2. Select "Enable"
3. Counter counts resume from last total

**Benefits:**
- Hide inactive counters from list
- Keep data intact
- Easy to resume later

### Delete Counters

**Delete Counter**
1. Long-press counter
2. Select "Delete"
3. ⚠️ Confirm - cannot be undone
4. All sessions deleted permanently

**Warning:**
- Deletion is permanent
- All associated sessions removed
- Consider exporting before deletion

### Merge Counters

**Manual Merge Process:**
1. Export data
2. Manually edit JSON file
3. Combine counts and sessions
4. Import updated file

**Alternative:**
1. Create new counter
2. Review history of both counters
3. Note combined total manually
4. Delete old counters

---

## 📞 Support & Feedback

### Getting Help

**In-App Support**
- Tap menu (⋮) → About
- Check app version and build info
- View contact information

**Common Issues Documentation**
- README.md - Installation guide
- Project_Details.md - Technical documentation
- This guide - Feature documentation

### Providing Feedback

**Report Issues**
1. Go to About screen
2. Note app version and Android version
3. Describe the issue with steps to reproduce
4. Share error messages if any

**Feature Requests**
- Describe desired feature
- Explain use case
- Provide detailed suggestions
- Check if feature already planned

---

## 🔄 Regular Maintenance

### Daily
- Review today's counts
- Check daily goal progress
- Note sessions if needed

### Weekly
- Review week's practice
- Check total counts
- Adjust goals if needed

### Monthly
- Export backup
- Review month statistics
- Celebrate milestones
- Plan next month practices

### Quarterly
- Deep review of progress
- Adjust settings/goals
- Clean up old data
- Verify backups work

---

## 📚 Additional Resources

- **Technical Details**: See [Project_Details.md](Project_Details.md)
- **Power Optimization**: See [POWER_OPTIMIZATION.md](POWER_OPTIMIZATION.md)
- **README**: See [README.md](README.md) for installation
- **Project Structure**: See [project_structure.md](project_structure.md)

---

## 🎉 Getting the Most from Mantra Japa Counter

1. **Set Goals**: Define daily and lifetime targets
2. **Create Counters**: One for each mantra practice
3. **Develop Habit**: Count at same time daily
4. **Track Progress**: Review statistics regularly
5. **Backup Data**: Export monthly for safety
6. **Optimize Battery**: Use brightness reduction
7. **Use Notifications**: Get reminders for goals
8. **Stay Consistent**: Use app daily for best results

---

**Happy Chanting! 🙏**

For technical questions, see [Project_Details.md](Project_Details.md)
For power optimization details, see [POWER_OPTIMIZATION.md](POWER_OPTIMIZATION.md)
For installation, see [README.md](README.md)

---

**Last Updated**: January 23, 2026
**Version**: 4.34
