# 002. Persistence Isolation & Isar Maintenance Strategy

## Context
Isar 3.x is unmaintained upstream. Migrating immediately to Drift carries schema migration risk across active models (`TaskModel`, `FocusSessionModel`, `JourneyRecord`).

## Decision
Keep persistence strictly hidden behind domain repository interfaces (`TaskRepository`, `OccurrenceRepository`, etc.). Keep Isar for current storage while decoupling domain/presentation layers completely from Isar types.

## Consequences
No persistence leakage into UI or business logic. A future migration to Drift or SQLite will require modifying only repository implementations, not application code.
