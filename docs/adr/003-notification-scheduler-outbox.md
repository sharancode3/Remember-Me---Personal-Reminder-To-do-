# 003. Single Native Alarm Scheduler & Durable Action Outbox

## Context
Notification actions (Done/Snooze) executed in Kotlin while Isar database lived in Dart, losing actions when the app was killed. Schedulers diverged between Flutter Local Notifications and native AlarmManager, causing sound failures.

## Decision
1. Unify scheduling onto one native Android `AlarmManager` pipeline backed by `reminders_v2` and `reminders_alarm_v2` channels with explicit audio attributes.
2. Notification actions dispatch to a native `BroadcastReceiver` that commits immutable action events to a durable SharedPreferences outbox queue.
3. The Flutter layer drains and acknowledges outbox events idempotently on start and resume.

## Consequences
Sound and delivery succeed under Doze. Notification actions update task status reliably even when the app process is terminated.
