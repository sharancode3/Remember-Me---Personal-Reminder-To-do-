# 004. Native Geofencing Sliding Window, Arrival Dwell, and Task Proximity Linking

## Context
Background geofencing was prone to battery drain if unconstrained, generated drive-by false positives, and lacked integration between saved places and pending task reminders.

## Decision
1. Implement a 20-geofence sliding window via Google Play Services `GeofencingClient` when trail tracking is inactive; re-center active window when user moves > 1 km.
2. Require 90s dwell within radius before firing arrival notification (`place_alerts_v2`); enforce 50m exit hysteresis (`radius + 50m`) to eliminate perimeter jitter.
3. Link tasks to places via `placeId` or `@tag`/`#tag`; sync pending place tasks to SharedPreferences so native arrival triggers preview pending tasks without waking the Dart VM.

## Consequences
Sub-1% per day idle battery draw, zero drive-by false positives, and contextual arrival alerts displaying pending tasks.
