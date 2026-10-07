import 'package:flutter_test/flutter_test.dart';
import 'package:remember_me/src/core/notifications/reminder_scheduler.dart';
import 'package:remember_me/src/data/models/task_model.dart';
import 'package:remember_me/src/data/models/task_occurrence_model.dart';
import 'package:remember_me/src/data/repositories/daily_repository.dart';
import 'package:remember_me/src/services/reminder_recurrence.dart';

class MockRecordingScheduler implements ReminderScheduler {
  final Map<int, TaskOccurrence> scheduled = {};
  final List<String> acknowledgedUuids = [];
  final List<Map<String, dynamic>> queuedOutbox = [];
  int reconcileCount = 0;

  @override
  Future<void> scheduleOccurrence(
    TaskOccurrence occurrence,
    String title, {
    bool isAlarmStyle = false,
    int nagMinutes = 0,
    int nagMax = 0,
  }) async {
    scheduled[occurrence.id] = occurrence;
  }

  @override
  Future<void> cancelOccurrence(int occurrenceId) async {
    scheduled.remove(occurrenceId);
  }

  @override
  Future<void> reconcile(
    List<TaskOccurrence> desired, {
    Map<int, String>? titles,
    Map<int, bool>? alarmStyles,
    Map<int, int>? nagMinutes,
  }) async {
    reconcileCount++;
    scheduled.clear();
    for (final occ in desired) {
      scheduled[occ.id] = occ;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> drainOutbox() async {
    return List.from(queuedOutbox);
  }

  @override
  Future<void> acknowledgeOutbox(List<String> uuids) async {
    acknowledgedUuids.addAll(uuids);
    queuedOutbox.removeWhere((item) => uuids.contains(item['uuid']));
  }

  @override
  Future<void> testReminderIn10s() async {}

  @override
  Future<Map<String, bool>> getReliabilityStatus() async => {
    'notificationsGranted': true,
    'exactAlarmsGranted': true,
    'batteryOptimizationsIgnored': true,
  };

  @override
  Future<void> openExactAlarmSettings() async {}

  @override
  Future<void> openBatteryOptSettings() async {}

  @override
  Future<void> openNotificationSettings() async {}

  @override
  Future<void> setReminderSound(String? soundUri) async {}
}

void main() {
  group('Phase 1 - Recurrence Rule Edge Cases', () {
    test('Daily recurrence includes every consecutive date', () {
      const daily = ReminderRecurrence(kind: RepeatKind.daily);
      final anchor = DateTime(2026, 10, 1, 9);
      for (int i = 0; i < 14; i++) {
        final d = anchor.add(Duration(days: i));
        expect(daily.includes(d, anchor), isTrue);
      }
    });

    test('Weekly recurrence only includes Mon (1), Wed (3), Fri (5)', () {
      const mwf = ReminderRecurrence(kind: RepeatKind.weekly, days: [1, 3, 5]);
      final monday = DateTime(2026, 10, 5, 10); // 2026-10-05 is a Monday
      expect(monday.weekday, 1);

      expect(mwf.includes(monday, monday), isTrue); // Mon
      expect(
        mwf.includes(monday.add(const Duration(days: 1)), monday),
        isFalse,
      ); // Tue
      expect(
        mwf.includes(monday.add(const Duration(days: 2)), monday),
        isTrue,
      ); // Wed
      expect(
        mwf.includes(monday.add(const Duration(days: 3)), monday),
        isFalse,
      ); // Thu
      expect(
        mwf.includes(monday.add(const Duration(days: 4)), monday),
        isTrue,
      ); // Fri
      expect(
        mwf.includes(monday.add(const Duration(days: 5)), monday),
        isFalse,
      ); // Sat
      expect(
        mwf.includes(monday.add(const Duration(days: 6)), monday),
        isFalse,
      ); // Sun
    });

    test('Monthly on 31st skips short months and fires on 31st', () {
      const month31 = ReminderRecurrence(kind: RepeatKind.monthly, days: [31]);
      final jan31 = DateTime(2026, 1, 31, 12);
      expect(month31.includes(jan31, jan31), isTrue);

      // February (28 days in 2026) has no 31st
      for (int day = 1; day <= 28; day++) {
        expect(month31.includes(DateTime(2026, 2, day), jan31), isFalse);
      }

      // March has 31 days
      expect(month31.includes(DateTime(2026, 3, 31), jan31), isTrue);
      expect(month31.includes(DateTime(2026, 3, 30), jan31), isFalse);

      // April has 30 days, no 31st
      expect(month31.includes(DateTime(2026, 4, 30), jan31), isFalse);
    });

    test('Leap year Feb 29 handling (2028 is a leap year, 2026 is not)', () {
      const feb29 = ReminderRecurrence(kind: RepeatKind.monthly, days: [29]);
      final anchor = DateTime(2024, 2, 29);
      // In 2028 (leap year), Feb 29 exists
      final leapFeb29 = DateTime(2028, 2, 29);
      expect(feb29.includes(leapFeb29, anchor), isTrue);

      // Non-leap year Feb 28 does not trigger 29th
      expect(feb29.includes(DateTime(2026, 2, 28), anchor), isFalse);
    });
  });

  group('Phase 1 - Reconcile Idempotency and Delta Calculation', () {
    test(
      'Multiple reconcile() calls produce idempotent scheduled results',
      () async {
        final scheduler = MockRecordingScheduler();
        final repository = DailyRepository(null, scheduler);

        final task1 = TaskModel()
          ..title = 'Standup'
          ..startAt = DateTime.now().add(const Duration(hours: 2))
          ..endAt = DateTime.now().add(const Duration(hours: 2, minutes: 15))
          ..reminderOffsetMinutes = 0
          ..recurrenceRule = 'none';

        final task2 = TaskModel()
          ..title = 'Lunch'
          ..startAt = DateTime.now().add(const Duration(hours: 5))
          ..endAt = DateTime.now().add(const Duration(hours: 6))
          ..reminderOffsetMinutes = 0
          ..recurrenceRule = 'none';

        await repository.save(task1);
        await repository.save(task2);

        final initialScheduledCount = scheduler.scheduled.length;
        expect(initialScheduledCount, 2);

        // Subsequent reconcile calls should not duplicate
        await repository.reconcile();
        expect(scheduler.scheduled.length, 2);

        await repository.reconcile();
        expect(scheduler.scheduled.length, 2);

        // Completing one task reduces scheduled count by 1
        await repository.toggle(task1);
        expect(scheduler.scheduled.length, 1);
        expect(scheduler.scheduled.containsKey(task1.id), isFalse);

        // Reconcile again remains 1
        await repository.reconcile();
        expect(scheduler.scheduled.length, 1);

        repository.dispose();
      },
    );
  });

  group('Phase 1 - Outbox Drain and Deduplication', () {
    test('Drains outbox actions and updates occurrences while dead', () async {
      final scheduler = MockRecordingScheduler();
      final repository = DailyRepository(null, scheduler);

      final task = TaskModel()
        ..title = 'Medicine'
        ..startAt = DateTime.now().add(const Duration(hours: 1))
        ..endAt = DateTime.now().add(const Duration(hours: 1, minutes: 1))
        ..reminderOffsetMinutes = 0
        ..recurrenceRule = 'none';

      await repository.save(task);

      // Simulate Kotlin NotificationActionReceiver writing mark_done while Dart was dead
      const actionUuid = 'action-uuid-12345';
      scheduler.queuedOutbox.add({
        'uuid': actionUuid,
        'action': 'mark_done',
        'occurrenceId': task.id,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      // App starts or resumes: drain and process
      await repository.drainAndProcessOutbox();

      // Check occurrence marked completed
      final found = await repository.find(task.id);
      expect(found, isNotNull);
      expect(found!.status, TaskStatus.completed);

      // Check UUID was acknowledged
      expect(scheduler.acknowledgedUuids, contains(actionUuid));
      expect(scheduler.queuedOutbox, isEmpty);

      // Secondary drain has nothing to process (idempotent deduplication)
      await repository.drainAndProcessOutbox();
      expect(scheduler.acknowledgedUuids.length, 1);

      repository.dispose();
    });

    test('Handles snooze outbox action', () async {
      final scheduler = MockRecordingScheduler();
      final repository = DailyRepository(null, scheduler);

      final task = TaskModel()
        ..title = 'Water Plants'
        ..startAt = DateTime.now().add(const Duration(hours: 1))
        ..endAt = DateTime.now().add(const Duration(hours: 1, minutes: 1))
        ..reminderOffsetMinutes = 0
        ..recurrenceRule = 'none';

      await repository.save(task);

      const snoozeUuid = 'snooze-uuid-999';
      scheduler.queuedOutbox.add({
        'uuid': snoozeUuid,
        'action': 'snooze_10m',
        'occurrenceId': task.id,
        'snoozeMinutes': 10,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      await repository.drainAndProcessOutbox();

      expect(scheduler.acknowledgedUuids, contains(snoozeUuid));
      expect(scheduler.queuedOutbox, isEmpty);

      repository.dispose();
    });
  });
}
