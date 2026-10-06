# 006. Feature-First Modularization, Quick-Add Parser, and Typed Platform Bridge

## Context
Monolithic `daily_home_screen.dart` (1450 lines) coupled navigation, state, quick-add, bottom sheets, and raw method channel string calls, impairing maintainability and test isolation.

## Decision
1. Modularize by feature: `features/today` (`TodayTab`), `features/calendar` (`CalendarTab`), and `features/tasks` (`TaskRow`, `TaskEditorSheet`, `QuickAddBar`).
2. Wire `NaturalLanguageTaskParser` directly into `QuickAddBar` with live chip preview and route-aware focus handling.
3. Replace all magic-string method invocations with compile-time checked `NativeDailyBridge` methods across repositories and presentation layers.
4. Export centralized reactive state and services via `daily_providers.dart`.

## Consequences
Home shell reduced to <300 lines, zero circular dependencies, full testability, and 0 analyzer issues.
