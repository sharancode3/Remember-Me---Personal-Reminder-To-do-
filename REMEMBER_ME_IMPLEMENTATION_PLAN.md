# REMEMBER ME — MASTER PRODUCT + ENGINEERING SPECIFICATION
*Adaptive Personal Planner · Privacy-First · Local-First Architecture*

> **Core Identity:** *"Plan less. Live more. Remember Me learns how you actually live."*
> **Design Philosophy:** Functional Bauhaus / Neo-Brutalist design (Off-white `#FFFDF5` canvas, heavy ink `#000000` borders, hard offset shadows, zero generic rounded cards, bold typography, tactile mechanical micro-interactions).

---

## 1. The 4-Layer Adaptive Architecture

```
                       REMEMBER ME
                            │
             ┌──────────────┴──────────────┐
             │                             │
        PLAN ENGINE                   LIFE ENGINE
             │                             │
      Tasks / Timelines              GPS / Movement (Journeys)
      Routines / Deadlines           Open-Meteo Weather
      Hard vs Soft Commitments       Health & Steps (Sensors)
      Capacity & Reset Buffers       Focus Telemetry & Shields
             │                             │
             └──────────────┬──────────────┘
                            │
                     LEARNING ENGINE
                            │
             "What works for you in reality?"
             (Rules → Stats → Predictions → Opt)
                            │
                            ▼
                   ADAPTIVE PLANNER
         "Here's what makes sense right now."
```

---

## 2. Core Modules & Provider Abstraction Layer

To ensure local-first resilience, battery preservation, and zero hard dependencies on cloud services, all contextual capabilities are abstracted behind pure interfaces:

```dart
// Abstraction Interfaces
abstract class WeatherProvider {
  Future<WeatherContext?> getWeatherForecast({required double lat, required double lon});
  Future<WalkingWindow?> findOptimalWalkingWindow({required DateTime date});
}

abstract class LocationProvider {
  Future<LocationSnapshot?> getCurrentLocation();
  Stream<LocationSnapshot> watchLocationUpdates({bool isStationary = false});
}

abstract class MovementJourneyProvider {
  Future<void> startJourney(ActivityType type);
  Future<void> pauseJourney();
  Future<JourneySummary> finishJourney();
  Stream<JourneyLiveState> watchLiveJourney();
}

abstract class HealthProvider {
  Future<int> getTodayStepCount();
  Stream<int> watchStepUpdates();
}

abstract class NotificationProvider {
  Future<void> showLiveJourneyNotification(JourneyLiveState state);
  Future<void> showFocusProgressNotification(FocusProgressState state);
  Future<void> showLeaveNowNotification(LeaveNowAlert alert);
  Future<void> dismissAll();
}
```

---

## 3. The 7-Phase Execution Plan

### **PHASE 1: Core Clean Architecture & UI Polish**
- **Screens:** `TODAY`, `PLAN`, `INSIGHTS`
- **Widgets:** Bauhaus / Neo-Brutalist tactile buttons, sticker cards, app bar with cracked bandaid-alarm logo.
- **Routines Engine:** Reusable template sequences (replaces "Blueprint").
- **Task Capture:** Fast deterministic offline natural language parser (`#tag`, `!priority`, `time`).

### **PHASE 2: Planner Engine, Capacity & Auto-Plan**
- **Hard vs Soft Task Distinction:** Immovable anchors (exams, meetings, flights) vs flexible tasks (study, workout).
- **Auto-Plan:** Multi-constraint day optimizer resolving deadlines, preferred working windows, and realistic capacity limits.
- **Dynamic Transition Buffers:** Context-aware gaps (labeled `RESET`) learned from user behavior.
- **Reality Mode:** Non-punitive schedule slippage repair (*"Your day changed. Let's fix it."*).

### **PHASE 3: Focus Mode, Focus Shield & Live Progress Notifications**
- **Focus Mode:** Minimal Space Grotesk countdown timer with silent performance telemetry.
- **3-Tier Focus Shield:** `OFF` / `REMIND` / `SHIELD` with gentle recovery prompt (*"Back to work?"*).
- **Android Live Progress Notification Bar:** Mini-app in system tray with `[PAUSE]`, `[+10M]`, `[DONE]`.

### **PHASE 4: Weather Intelligence, Location & Leave-Now Engine**
- **Open-Meteo Weather Integration:** Cached, rate-limited forecast analysis serving as a planning signal (e.g. rain at 6 PM ➔ suggest 7:30 AM run).
- **Proximity Scheduling & "Detour Tasks":** Geographical errand bundling (`Work` ➔ `📦 Package` ➔ `🛒 Groceries` ➔ `Home`).
- **Leave-Now Notifications:** Dynamic commute alert factoring estimated travel time and prep buffers.

### **PHASE 5: Movement & Journey HUD Engine**
- **First-Class Journey Activity:** Dedicated HUD tracking GPS route coordinates, distance, pace, speed, moving vs stopped time, and real-time step counter.
- **Route Summary & History:** Post-workout summary card with vector route preview saved to permanent activity history.
- **Automatic Step Goal Progression:** Live sensor updates (`7,340 / 10,000 steps [73%]`) without manual check-offs.

### **PHASE 6: Learning Engine & Behavioral Intelligence**
- **Duration Prediction:** Historical task duration learning vs planned estimates.
- **Deadline Risk Alerting:** Proactive notification when a multi-day project falls behind pace with 1-tap rebuild.
- **Weekly Tiny AI Review:** 4-bullet executive summary of planned vs actual hours, peak focus windows, and adjusted baseline estimates.

### **PHASE 7: Full Verification, Test Suite & Production Build**
- **Battery & GPS profiling:** Stationary throttling, immediate sensor teardown on finish.
- **Widget & Unit Tests:** 100% test coverage across all engines and providers.
- **Release Compilation:** Standalone production APK with zero startup crashes and offline resilience.
