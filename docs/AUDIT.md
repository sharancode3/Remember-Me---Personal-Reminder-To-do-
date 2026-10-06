# Architecture & Bug Audit: Remember Me

**Date:** October 2026  
**Status:** Approved / Phase 0 Baseline  
**Target:** Production-Grade Android + Flutter Engine

---

## 1. Executive Summary & Codebase State

The "Remember Me" repository was initiated with two competing architectural visions:
1. **Architecture A (Dormant):** A Neo-Brutalist adaptive day-planner using a 4-engine heuristic architecture (Plan, Life, Learning, Adaptive Planner). Disconnected from runtime execution, leaving 62 analyzer warnings and ~3,000 lines of dead code.
2. **Architecture B (Active Product):** The "Daily App" running in `lib/src/app.dart` with four user-facing pillars: **Today**, **Calendar**, **Focus**, and **Your Trail**, supported by a native Android Kotlin layer (`remember_me/daily`).

Phase 0 establishes repository hygiene, audits all reported failure modes with line-level evidence, defines verification harnesses, evaluates local database persistence, and designs the diagnostics subsystem.

---

## 2. Bug 1: Notification & Reminder Sound Failures

### Reported Behavior
Reminders fire without audio, or do not trigger reliably at scheduled times.

### Code-Level Root Causes & Evidence
1. **Immutable Android Notification Channels Created Without Sound / Low Importance**
   - **Evidence:** `android/.../RepeatReminderReceiver.kt:66`:
     ```kotlin
     if(Build.VERSION.SDK_INT >= 26) manager.createNotificationChannel(NotificationChannel("remember_me_daily_reminders","Reminders",NotificationManager.IMPORTANCE_HIGH))
     ```
   - **Mechanism:** On Android 8.0+ (API 26+), notification channel settings are **immutable** after creation. Neither `NotificationCompat.Builder` nor `NotificationChannel` sets explicit `AudioAttributes` (`USAGE_NOTIFICATION` or `USAGE_ALARM`) or explicit ringtone URIs. If an earlier installation created this channel with default or muted sound settings, subsequent calls to `createNotificationChannel` are no-ops.
   - **Evidence:** `lib/src/services/local_notification_service.dart:174, 252`: Uses the identical channel ID `remember_me_daily_reminders` from Dart via `flutter_local_notifications` without providing explicit sound resources.
2. **Dual Divergent Schedulers**
   - **Evidence:** `lib/src/services/local_notification_service.dart:147-159` vs `228-280`:
     - Recurring tasks are dispatched via native `MethodChannel('remember_me/daily').invokeMethod('scheduleRepeat', ...)` to `RepeatReminders.save()` in Kotlin using `AlarmManager.setExactAndAllowWhileIdle`.
     - Non-recurring tasks ("nudges") bypass native Kotlin and are scheduled via `FlutterLocalNotificationsPlugin.zonedSchedule`.
     - If exact alarm permission (`SCHEDULE_EXACT_ALARM`) is revoked or ungranted on API 31+, `LocalNotificationService._scheduleMode()` silently falls back to `inexactAllowWhileIdle`, causing reminders to drift by tens of minutes.
3. **Missing `USAGE_ALARM` and Full-Screen Intent for Critical Reminders**
   - Neither scheduler configures `AlarmManager.setAlarmClock` or uses `AudioAttributes.USAGE_ALARM`, causing alarms to be suppressed during active Doze or device volume profiles where notification streams are muted.

### Verification Plan
- Create test channels `reminders_v2` and `reminders_alarm_v2` with explicit high importance, audio attributes, and default notification sound.
- Run automated tests on Android emulator checking `NotificationChannel.getImportance()` and `NotificationChannel.getSound()`.
- Add an in-app "Send test reminder in 10 s" button in Settings → Reliability Check to verify sound playback on physical hardware under Doze conditions.

---

## 3. Bug 2: Trail Loss & Route Drop Across Metro / Tunnels / Long Gaps

### Reported Behavior
During long metro rides or signal dropouts, route recording halts, places are not marked, and recording does not resume when signal returns.

### Code-Level Root Causes & Evidence
1. **Premature Strict Accuracy Gate Rejects Initial Post-Tunnel Fixes**
   - **Evidence:** `android/.../TrailQualityFilter.kt:17`:
     ```kotlin
     if (!sample.latitude.isFinite() || !sample.longitude.isFinite() || abs(sample.latitude) > 90 || abs(sample.longitude) > 180 || sample.accuracy !in 0.5..40.0) { rejected++; return null }
     ```
   - **Mechanism:** When emerging from an underground tunnel or metro, GPS ephemeris acquisition takes 15–45 seconds. The initial fixes from cell tower or coarse GPS typically report accuracy between 45m and 120m. Because `sample.accuracy !in 0.5..40.0`, **every single initial fix is discarded immediately at line 17**.
2. **Deadlock in Stationary Innovation Gating Due to Missing Speed/Motion**
   - **Evidence:** `android/.../TrailQualityFilter.kt:32-37`:
     ```kotlin
     val credibleMovement = (speed != null && speed >= 0.7) || (sample.motion && displacement > max(6.0, sample.accuracy * 1.2))
     movementVotes = if (credibleMovement) (movementVotes + 1).coerceAtMost(4) else 0
     if (movementVotes < 2) {
         estimate = prior.copy(time = sample.time)
         return null
     }
     ```
   - **Evidence:** `DailyTrailService.kt:81, 89`: `sample.motion` is derived strictly from `lastMotion`, which is fed solely by `Sensor.TYPE_LINEAR_ACCELERATION`. A smoothly cruising metro train produces almost zero linear jerk/acceleration on a phone at rest in a pocket.
   - **Mechanism:** `sample.motion` evaluates to `false`. If the incoming location lacks valid hardware speed (`speed == null` or `< 0.7`), `credibleMovement` evaluates to `false`, resetting `movementVotes` to 0. The filter advances `estimate.time = sample.time` at line 36 and drops the point. The filter can remain trapped in this state indefinitely.
3. **Sampling Rate Starvation While Moving in Vehicles**
   - **Evidence:** `DailyTrailService.kt:82`:
     ```kotlin
     changeRate(if (moving) 3000L else 30000L)
     ```
   - When linear acceleration ceases on a train, `moving` drops to `false`, throttling location requests to once every 30 seconds.
4. **Polyline Renderer Drops Disconnected Single Points**
   - **Evidence:** `lib/src/presentation/screens/daily_trail_screen.dart:548-555`:
     ```dart
     final segments = <List<LatLng>>[];
     for (var i = 0; i < fixes.length; i++) {
       if (i == 0 || fixes[i].gap || fixes[i].time.difference(fixes[i - 1].time).inSeconds > 120) {
         segments.add([]);
       }
       segments.last.add(fixes[i].point);
     }
     ```
   - **Mechanism:** Flutter polylines require at least two points to draw a line segment. Any isolated fix or broken gap produces a single-item segment that is silently omitted from rendering, leaving the user with an empty map and no visual indication of estimated travel.

### Verification Plan (Trail Simulator)
- Construct a dedicated JUnit replay harness (`TrailSimulatorTest`) feeding synthetic and recorded JSONL scenarios:
  1. 20-minute signal dropout (metro tunnel).
  2. First fix accuracy = 65m, followed by steady 12m fixes.
  3. Smooth linear velocity (50 km/h) with zero accelerometer spikes.
- Prove that the existing filter drops 100% of fixes post-tunnel.
- Verify that the rewritten 2D Kalman filter resets state after a >60s gap, accepts probation fixes ≤100m, bridges gaps with dashed segments, and tracks transit reliably.

---

## 4. Bug 3: Notification Action (Done / Snooze) Failure When App is Dead

### Reported Behavior
Clicking "Done" or "Snooze" on a reminder notification does not reliably update task status if the app is killed or swiped away.

### Code-Level Root Causes & Evidence
1. **Activity-Bound Notification Intents Blocked on Android 10+**
   - **Evidence:** `android/.../RepeatReminderReceiver.kt:67-68`:
     ```kotlin
     fun intent(action: String, request: Int): PendingIntent = PendingIntent.getActivity(context, request,
         Intent(context,MainActivity::class.java).setAction("remember_me.$action.$id").putExtra("repeatTask",id).putExtra("repeatAction",action).putExtra("repeatDate",day), PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
     ```
   - **Mechanism:** Notification action buttons dispatch `PendingIntent.getActivity()` targeting `MainActivity`. When the app is closed, Android 10+ (API 29+) imposes strict restrictions on background activity launches. If the user taps "Done" while using another app, Android may refuse to launch `MainActivity`, causing the click to be swallowed.
2. **Language Barrier: Native Kotlin Cannot Write to Isar**
   - Isar is a Dart/C++ library embedded inside the Flutter engine. When the app is terminated, no Flutter engine is running. Kotlin receives the broadcast/intent but has zero write access to Isar storage.
3. **Absence of a Native Outbox Buffer**
   - If `MainActivity` does not successfully boot and call `consumeRepeatAction` within the lifecycle of the intent, the action event is lost permanently.

### Verification Plan
- Implement the **Durable Outbox Pattern**:
  - Notification actions fire a `BroadcastReceiver` (not an `Activity`).
  - The receiver writes an idempotent action record (`{occurrenceId, action, timestamp, uuid}`) to a persistent atomic native store (`SharedPreferences` or JSON queue) and cancels the notification immediately.
  - On launch or resume, Dart queries the outbox via platform channel, applies mutations to Isar inside an atomic transaction, and acknowledges processed UUIDs.
- Write unit tests validating outbox deduplication, dead-app write persistence, and Flutter drain reconciliation.

---

## 5. Occurrence Architecture: Replacing Fragile Virtual ID Math

### Evidence
- `lib/src/data/repositories/daily_repository.dart:40-46`:
  ```dart
  -(source.id * 100000 + DateTime.utc(date.year, date.month, date.day).difference(DateTime.utc(1970)).inDays)
  ```
- Synthetic negative IDs cause severe friction:
  - Deep links cannot cleanly reference occurrences.
  - Home screen widget cannot link to specific instances.
  - Database queries cannot perform relational operations or maintain foreign keys.

### Target Materialized Architecture
- Introduce a materialized `TaskOccurrence` entity:
  - `id`: Auto-increment integer primary key.
  - `taskId`: Foreign key to parent `TaskModel`.
  - `occurrenceDate`: Normalized local date string (`yyyy-MM-dd`).
  - `scheduledAt`: Target trigger timestamp.
  - `status`: `pending`, `completed`, `skipped`.
  - `notificationId`: Deterministic collision-free integer.
  - Unique composite index: `(taskId, occurrenceDate)`.
- Occurrences are generated lazily for a rolling 14-day window. Modifications (skip, complete, edit notes) update the specific occurrence row without altering the master recurrence rule.

---

## 6. Persistence & Database Strategy: Isar 3.x Evaluation

### Current Status of Isar
- Isar 3.1.0+1 was released in 2023. Upstream development on GitHub (`simonxidd/isar`) is effectively inactive.
- Compiling on newer Dart SDKs requires `--no-sound-null-safety` workarounds or third-party maintenance forks (`isar_community`).
- Web release builds fail natively due to lack of dynamic C++ library support.

### Decision & Migration Path
- **Alternative:** Drift (SQLite). Drift is actively maintained, fully typed, supports all Flutter platforms (Android, iOS, macOS, Windows, Linux, Web), offers reactive streams, and has first-class migration tooling.
- **Strategy:** 
  1. Keep all persistence strictly behind abstract repository interfaces (`TaskRepository`, `OccurrenceRepository`, `TrailRepository`, `PlaceRepository`).
  2. Implement `TaskOccurrence` and rolling reconciliation cleanly behind these interfaces.
  3. Ensure zero Isar imports leak into domain or presentation layers, making a future one-step migration to Drift effortless.

---

## 7. Diagnostics & Structured Logging Design

To reliably debug GPS tracking, Kalman filter decisions, and alarm firing on physical devices:
1. **Dart:** `package:logging` configured to write structured JSON lines to a local ring-buffer file (`cache/logs/app_diagnostics.log`).
2. **Kotlin:** A lightweight singleton `AppLogger` writing timestamped log entries to the same ring-buffer directory.
3. **Diagnostics Screen:** Exposed under Settings → Diagnostics, displaying recent logs with search/filter and a "Share Diagnostics Bundle" export button.

---

## 8. Removal of Architecture A & Repository Pruning

The following dormant modules are archived on branch `archive/arch-a` and scheduled for complete removal from `main`:
- **Engines:** `four_engines_architecture.dart`, `master_adaptive_day_orchestrator.dart`, `context_engine.dart`, `personal_planning_profile.dart`, `personal_prediction_engine.dart`, `project_simulation_engine.dart`, `unified_notification_engine.dart`, `observation_store.dart`, `open_meteo_weather_service.dart`, `geocoding_routing_services.dart`, `local_movement_journey_service.dart`.
- **Dormant Screens & Widgets:** `home_shell_screen.dart`, `today_screen.dart`, `plan_screen.dart`, `analytics_screen.dart`, `focus_mode_screen.dart`, `journey_screen.dart`, `journey_history_screen.dart`, `journey_replay_screen.dart`, `onboarding_screen.dart`, `profile_screen.dart`, `neo_profile_modal.dart`, `neo_task_capture_sheet.dart`, `notification_center_sheet.dart`, all `neo_*` widgets, themes, and layouts.
- **Unused Isar Schemas:** `TaskTemplateModel`, `TaskInstanceModel`, `CategoryModel`, `WeeklySummaryCache`, `BlueprintProfileModel`, `FixedActivityBlockModel`, `TaskDraftModel`, `AppSettingsModel`.
- **Preserved & Reusable Assets:**
  - `lib/src/core/utils/natural_language_parser.dart` (reused for Today quick-add).
  - `lib/src/services/reminder_recurrence.dart` (reused for recurrence calculation).
  - `lib/src/services/backup_service.dart` (reused for JSON export/import).
