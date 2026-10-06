# Remember Me

A local-first, privacy-respecting Android application built with Flutter, Riverpod, Isar, and native Kotlin. Provides rock-solid reminders, natural language quick-add, focus timer with distraction blocking, and battery-efficient daily movement trails with offline vector maps. No subscription or paid cloud API required.

---

## Architecture Overview (Architecture B)

The application is structured into modular feature packages with a decoupled data layer and a typed native platform bridge:

```
lib/src/
├── app.dart                              # App root, orientation lock & theme wiring
├── core/
│   ├── bootstrap/bootstrap.dart          # Database and service initialization
│   ├── logging/app_logger.dart           # Ring-buffered structured logger
│   ├── notifications/                    # ReminderScheduler interface & unified scheduler
│   ├── platform/native_daily_bridge.dart # Compile-time checked native method channel bridge
│   ├── theme/daily_theme.dart            # Multi-palette theme engine (Mint, Ocean, Rose)
│   └── utils/                            # Natural language parser, RDP decimator, UI helpers
├── data/
│   ├── local/isar_service.dart           # Local persistence lifecycle
│   ├── models/                           # TaskModel, TaskOccurrence, FocusSessionModel
│   └── repositories/daily_repository.dart# Persistence logic behind abstract interfaces
├── features/
│   ├── calendar/presentation/            # CalendarTab with day/month grid
│   ├── splash/presentation/              # EntranceReveal with spring-physics bubbles
│   ├── tasks/presentation/               # QuickAddBar, TaskRow, TaskEditorSheet
│   └── today/presentation/               # TodayTab with metrics, quick-add & task lists
└── presentation/
    ├── providers/daily_providers.dart    # Riverpod reactive state
    └── screens/                          # DailyHomeScreen, DailyFocusScreen, DailyTrailScreen
```

---

## Key Features & Production Enhancements

### 1. Reminders That Actually Fire (With Sound & Alarms)
- **Immutable Notification Channels:** Versioned channels (`reminders_v2`, `reminders_alarm_v2`, `place_alerts_v2`, `trail_status`) created with proper audio attributes and notification categories.
- **Unified Native Alarm Scheduler:** Replaces diverging schedulers with a single native Kotlin `AlarmManager` receiver (`setAlarmClock` + `setExactAndAllowWhileIdle`) with optional nag loops.
- **Headless Outbox Pattern:** Action buttons ("Done" and "Snooze 10m") execute immediately in Kotlin and write to a durable disk outbox, processed seamlessly without needing to boot Dart.
- **Natural Language Quick-Add:** Type `"Gym tomorrow 7am #fitness"` directly in the Today view to schedule tasks with live chip parsing.

### 2. High-Precision Movement Tracking & Gap Detection
- **2D Metric Kalman Filter:** Local ENU tangent plane filter with stationary jitter suppression (<12m std dev).
- **Tunnel & Outage Detection:** Explicit `TrailGap` detection for prolonged GPS loss (>120s or >180 km/h) rendered as dashed lines.
- **Decimation on Background Isolate:** Dense coordinates (10,000+ fixes) deserialized and linked on background isolates via `compute()`, then simplified using iterative RDP decimation (`TrailDecimator`) to guarantee 60fps map rendering.

### 3. Battery-Efficient Geofencing & Place Linking
- **Sliding Geofence Window:** Monitors up to 20 nearest places via Google Play Services `GeofencingClient` when continuous tracking is turned OFF, automatically recentering when moving >1km.
- **Arrival Dwell & Hysteresis:** Enforces 90-second dwell and `radius + 50m` exit hysteresis to eliminate boundary bounce.
- **Headless Task Linking:** Places linked by ID or `@tag`/`#tag` sync to native preferences, alerting with pending task counts without waking the Dart runtime.

### 4. Vector Map Stack & Ambient Offline Caching
- **OpenFreeMap Bright Vector Tiles:** Free, fast vector tiles via MapLibre GL with a Google-like aesthetic and zero API cost or card requirements.
- **150MB LRU Tile Cache:** Two-tier cache (L1 memory + L2 disk) providing ambient offline availability during commutes.
- **Optional Native Google View:** Opt-in toggle to view trails and markers on native Google Maps SDK when an API key is supplied.
- **OSM Attribution:** Clean, non-intrusive `© OpenStreetMap contributors · OpenFreeMap` attribution.

### 5. Focus Guard
- **Distraction Blocking:** Accessibility-based overlay preventing app distraction while preserving access to essential utilities (Phone, Settings, Home).
- **Persisted Sessions:** Survives process death and calculates exact focused minutes per day.

---

## Build, Run, and Test

### Prerequisites
- Flutter 3.24+ (Dart 3.5+)
- Android SDK (API 26 to 35)
- Java 17 / Gradle 8.14

### Verification Commands
```powershell
# Analyze codebase (Strict zero-warning policy)
flutter analyze

# Run all Flutter unit & widget tests (57+ tests)
flutter test

# Run native Android JVM unit tests
cd android
.\gradlew.bat :app:testDebugUnitTest
cd ..
```

### Build Universal Release APK
```powershell
flutter build apk --release --tree-shake-icons --split-debug-info=build/symbols/1.0.1
```
Output artifact: `build/app/outputs/flutter-apk/app-release.apk`.

---

## Architecture Decision Records (ADRs)
- [001. Audit and Repository Hygiene](docs/adr/001-audit-and-repo-hygiene.md)
- [002. Immutable Notification Channels and Scheduler](docs/adr/002-notification-channels-scheduler.md)
- [003. Kalman Filter, Gap Detection, and Watchdog](docs/adr/003-kalman-gaps-watchdog.md)
- [004. Native Geofencing and Place Tasks](docs/adr/004-native-geofencing-places.md)
- [005. Map Stack, Vector Tiles, and Tile Cache](docs/adr/005-map-stack.md)
- [006. Feature-First Modularization and Platform Bridge](docs/adr/006-feature-architecture.md)
- [007. Isolate Decimation and CI Pipeline](docs/adr/007-performance-ci.md)
- [008. Entrance Reveal and Final Sign-Off](docs/adr/008-final-polish.md)
