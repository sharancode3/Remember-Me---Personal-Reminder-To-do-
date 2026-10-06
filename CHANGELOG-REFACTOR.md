# Changelog: Remember Me Refactor to Production Quality

All phases executed under strict quality standards: 0 `flutter analyze` warnings, 0 Kotlin compiler warnings, 100% passing Dart & Android unit tests, and persistent repository decoupling.

---

## Phase 0: Audit and Repository Hygiene
- **Branch Archiving:** Archived dormant Architecture A (neo-brutalist 4-engine planner) to `archive/arch-a` and pruned unused schemas and dependencies from `main`.
- **Strict Analyzer:** Configured `analysis_options.yaml` with `flutter_lints`, `strict-casts`, `strict-inference`, `strict-raw-types`, `prefer_const_constructors`, `unawaited_futures`, `avoid_print`, `always_declare_return_types`.
- **Audit Documentation:** Authored `docs/AUDIT.md` tracing root causes for silent notifications, tunnel dropouts, and notification action desync.
- **Diagnostics Ring Buffer:** Added size-capped ring-buffered structured logger in Dart (`AppLogger`) and Kotlin (`Log`), exportable from Settings → Diagnostics.

## Phase 1: Reliable Reminders, Alarms & Audio
- **Immutable Notification Channels:** Created `reminders_v2` (IMPORTANCE_HIGH), `reminders_alarm_v2` (USAGE_ALARM), `place_alerts_v2` (HIGH), and `trail_status` (LOW).
- **Unified Native Scheduler:** Replaced duplicate Dart/Kotlin scheduling with single `UnifiedAlarmScheduler.kt` using `AlarmManager.setAlarmClock` + `setExactAndAllowWhileIdle` and nag loop.
- **Dead-Engine Outbox:** Implemented `NotificationActionReceiver.kt` writing `mark_done` and `snooze` events to atomic JSON outbox processed even when Flutter engine is dead.
- **Materialized Rolling Window:** Migrated recurrence expansion to `TaskOccurrence` rolling 14-day window; fixed narrow 360px overflow.

## Phase 2: Movement Tracking & Tunnel/Gap Detection
- **2D Metric Kalman Filter:** Implemented `TrailQualityFilter.kt` in local ENU tangent plane with stationary noise suppression (<12m std dev).
- **Explicit Gap Detection:** Detected tunnel outages (>120s or speed > 180 km/h) and persisted explicit `TrailGap` markers with probation acceptance (<100m from expected tangent).
- **Watchdog Receiver:** Built `DailyTrailWatchdogReceiver.kt` validating 90s tracking heartbeat against silent OEM kills.
- **Pure Kotlin RDP Decimation:** Added `TrailDecimator.kt` simplifying dense polyline geometry without losing corners.

## Phase 3: Battery-Efficient Geofencing & Place Linking
- **Sliding Geofence Window:** Implemented `NativeGeofenceManager.kt` maintaining 20 nearest places via Google Play Services GeofencingClient when tracking is OFF, recentering on >1km moves.
- **Arrival Hysteresis & Dwell:** Built `ArrivalEngine.kt` enforcing 90s dwell and `radius + 50m` exit hysteresis to eliminate edge bouncing.
- **Task Linking & Counters:** Synced `tasks_by_place` to SharedPreferences; notification titles display pending task counts for arriving places without waking Dart.
- **Place Selector UI:** Added place dropdown to task editor and place chip on task list items.

## Phase 4: Map Stack, Vector Tiles & Offline Caching
- **OpenFreeMap Vector Tiles:** Adopted MapLibre GL with OpenFreeMap Bright vector style (`https://tiles.openfreemap.org/styles/bright`) delivering Google-like aesthetics at zero API cost.
- **150MB LRU Tile Cache:** Implemented two-tier `TileCacheManager.dart` (L1 memory + L2 disk LRU) capping storage at 150MB with instant offline readiness.
- **Native Google View Toggle:** Retained optional native Google Maps platform view (`Google view`) rendering matching polylines, gap dashes (`Dash(20f), Gap(15f)`), and place markers.
- **OSM Attribution:** Integrated non-obtrusive `© OpenStreetMap contributors · OpenFreeMap` attribution link.

## Phase 5: Feature-First Modularization & Typed Bridge
- **Modular Directory Structure:** Extracted `features/today` (`TodayTab`), `features/calendar` (`CalendarTab`), and `features/tasks` (`TaskRow`, `TaskEditorSheet`, `QuickAddBar`).
- **Natural Language Quick-Add:** Connected `NaturalLanguageTaskParser` to `QuickAddBar` supporting input like `"Gym tomorrow 7am #fitness"` with live chip preview and route-aware focus handling.
- **Typed Platform Bridge:** Built `NativeDailyBridge.dart` eliminating raw method channel strings and providing compile-time type safety.
- **Slim Home Shell:** Reduced `daily_home_screen.dart` from 1450 lines to <300 lines with zero circular dependencies.

## Phase 6: Isolate Trail Processing & GitHub Actions CI
- **Background Isolate Deserialization:** Offloaded large trail JSON parsing and gap linking to background isolate via Flutter `compute(parseAndProcessTrail, ...)`, ensuring smooth 60fps UI.
- **Dart RDP Decimator:** Implemented `TrailDecimator.dart` with iterative stack preventing stack overflow on 10,000+ coordinates.
- **Automated CI Workflow:** Created `.github/workflows/ci.yml` running Flutter analyze, Flutter test suite, and Gradle Android unit tests.

## Phase 7: Entrance Reveal Animation & Final Polish
- **Bouncy Spring Reveal:** Built `EntranceReveal` with spring-physics bubbles, haptic feedback, and smooth brand reveal on cold launch.
- **Architecture Documentation:** Authored complete ADRs (001 through 008) and comprehensive `README.md`.
