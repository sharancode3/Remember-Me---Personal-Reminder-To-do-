# Remember Me

A local-first Flutter Android app for reminders, daily to-dos, focus, and movement history. No subscription or paid API is required.

## Daily Experience

- **Today:** reminders and checklist, without priorities or automatic rescheduling. Repeat daily, on selected weekdays, or selected monthly dates. Complete/skip one day without cancelling future repeats. Edit the series or stop repeating from its menu.
- **Calendar:** each day's tasks, completion, focused minutes, and trail.
- **Focus:** 5-120 minutes. Opt-in Android Accessibility blocks distracting apps with a full-screen overlay while chosen allowed apps remain usable. Allowed apps show a small timer overlay. Phone, Home, Settings, and permission screens remain available for safety. Screen pinning is a separate option. Sessions persist with an absolute end time.
- **Trail:** full-screen map, route sketch, distance, average/max speed, and meters per minute. Long-press or use the pin button to name a saved place. Add arrival messages with a 75-500 m radius. Alerts require opted-in daily recording, precise location, and notifications. Trails can be copied, deleted, and shared as map images.
- **Appearance:** Mint, Ocean, and Rose light themes, translucent blurred navigation/map controls, animated transitions/completion/time wheel, and a new launcher mark. Android persists theme choice.
- **Widget:** home-screen reminder/completion snapshot with Add and Focus shortcuts. Add from Settings or the launcher. It refreshes on app changes and launcher updates; it is not a second live checklist.

OpenStreetMap is the free default without a key or billing account. Optional official Google Android Maps supports street/satellite maps and the same local route/pins. They are selectable basemaps, not scraped Google tiles layered over OSM. Google's basic Maps SDK SKU currently has unlimited no-cost usage, but Google still requires billing to be enabled for a key. No paid Places, Roads, Routes, Street View, or cloud AI APIs are called. See [API Setup](docs/API_SETUP.md).

GPS recording works offline; street tiles need connectivity. Offline map downloading is not implemented. Attribution remains on shared images.

## Build And Install

```powershell
flutter pub get
flutter run
flutter test
flutter build apk --release --tree-shake-icons --split-debug-info=build/symbols/1.0.1
./scripts/check_notification_release.ps1
```

Install `build/app/outputs/flutter-apk/app-release.apk`: one universal release for ARM64, ARMv7, and x86-64. Native libraries are compressed to reduce APK size and extracted by Android during installation; the download size is not the installed footprint. Dart debugging symbols remain outside the APK in `build/symbols/1.0.1`; retain them for diagnosing this release. Code/resource shrinking and icon tree shaking remain enabled. The release check verifies that notification-storage reflection metadata survives shrinking. Local builds use the existing debug signing key, not a production Play Store signing configuration, so this APK can update earlier local builds without clearing data.

Original Isar task data is preserved. Advanced planner code remains in source but is disconnected from the active daily app. Legacy daily-summary scheduling is cancelled at startup. Android is the target verified by builds; browser release builds remain unsupported by existing Isar generated models.

## Phone Behavior And Limits

Allow notifications. Precise-alarm access is requested for time reminders; denied access permits late delivery. Done and Snooze 10m actions are provided. Android repeating reminders use one rolling native alarm per series, restored after reboot/update/clock changes, and honor future start dates, skipped dates, and short months: 31 means the 31st, not the last day. Force-stopping the app stops alarms until reopened. iOS recurrence has not been device-verified.

Trail recording begins only after consent, resumes on app launch if enabled, and rolls to a new local-date file at midnight. Reopen after reboot or force-stop. OS/battery restrictions, permission removal, poor reception, or service termination can create gaps. Gaps over two minutes are not connected. The local accuracy-weighted Kalman estimator combines a stationary anchor, motion/speed evidence, innovation rejection, and minimum displacement. Fixes over 40 m reported uncertainty or implausible jumps are rejected. Sampling slows from 3 to 30 seconds when stationary. This reduces jitter but cannot promise survey-grade accuracy or reconstruct missing travel. Statistics cover recorded segments, exclude gaps, and are estimates rather than sports-grade measurements. Arrival detection includes reported uncertainty, 20 s dwell, exit hysteresis, and a persisted 30 min cooldown. There is no trained ML model or cloud location upload. Online map requests reveal the viewed region to the map provider.

Accessibility access is manually enabled after disclosure. The service observes app package changes, not window contents, passwords, or typed text. Blocking covers apps rather than disabling packages or suppressing their notifications. It is not a bypass-proof kiosk: the user can end a session or revoke access; OEM/system screens can behave differently. Recent Android may require allowing restricted settings for this sideloaded app. Screen pinning retains the OS emergency unpin gesture. iOS has foreground-only trails and no cross-app blocking.

## Verification

Flutter tests cover reminder timing, per-day history, recurrence/completion/skip, focus exit/allowlist, saved places without silent recording, themes, and narrow layouts. Native JUnit tests cover stationary jitter, walking, GPS jumps/gaps, future starts, skipped dates, monthly dates, and daylight-saving transitions:

```powershell
cd android
./gradlew.bat :app:testDebugUnitTest
```

Optional screenshot captures:

```powershell
$env:REMEMBER_ME_CAPTURE = 'true'
$env:REMEMBER_ME_FONT_DIR = 'C:/flutter_sdk/bin/cache/artifacts/material_fonts'
flutter test test/daily_visual_test.dart
```

Captures go to `docs/screenshots`. Widget tests block real HTTP, so maps can show unavailable tiles. No Android phone was connected: locked-screen/background GPS, accessibility blocking/expiry, widget refresh, notification timing/actions, arrival alerts, Google authorization, and image sharing still need real-device validation before daily reliance.
