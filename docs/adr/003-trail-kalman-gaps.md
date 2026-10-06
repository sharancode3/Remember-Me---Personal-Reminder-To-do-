# 003. 2D Metric Kalman Trail Filter, Gap Persistence, and Watchdog Resilience

## Context
Trail recording previously rejected post-tunnel coarse GPS fixes (accuracy > 40m), accumulated phantom distance from stationary jitter, and was vulnerable to background process kills without self-recovery.

## Decision
1. Rewrite `TrailQualityFilter` with a 2D metric Kalman filter (constant-velocity model) in a local ENU tangent plane, anchor voting for stationary jitter suppression, and tunnel recovery allowing probation fixes (accuracy <= 100m) confirmed within 30s.
2. Persist explicit `{"type":"gap"}` events in `trail_YYYY-MM-DD.jsonl` and render gaps in Flutter as dashed grey lines with duration/distance markers instead of teleport lines.
3. Add `DailyTrailWatchdogReceiver` with 90s interval monitoring 30s service heartbeats, and RDP decimation (epsilon = 5m, <= 2000 points).

## Consequences
Smooth tracking through metro tunnels and deadzones, zero stationary phantom distance, resilient service self-healing, and low-latency MethodChannel payloads.
