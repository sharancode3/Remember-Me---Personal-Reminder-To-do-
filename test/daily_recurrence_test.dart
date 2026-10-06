import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:remember_me/src/data/models/task_model.dart';
import 'package:remember_me/src/data/repositories/daily_repository.dart';
import 'package:remember_me/src/services/daily_trail_service.dart';
import 'package:remember_me/src/services/local_notification_service.dart';
import 'package:remember_me/src/services/reminder_recurrence.dart';

class _Notifications extends LocalNotificationService {
  @override
  Future<void> cancelTaskReminder(int id) async {}
  @override
  Future<void> scheduleTaskNudge(
    TaskModel task, {
    int offsetMinutes = 10,
  }) async {}
}

void main() {
  test('Weekly selection respects start date and chosen weekdays', () {
    const rule = ReminderRecurrence(kind: RepeatKind.weekly, days: [1, 3]);
    final anchor = DateTime(2026, 10, 5, 9, 30);
    expect(rule.includes(DateTime(2026, 10, 1), anchor), false);
    expect(rule.includes(DateTime(2026, 10, 6), anchor), false);
    expect(rule.nextAfter(anchor, anchor), DateTime(2026, 10, 7, 9, 30));
    expect(ReminderRecurrence.decode(rule.encode()).days, [1, 3]);
  });
  test('Monthly 31 skips short months without moving the date', () {
    const rule = ReminderRecurrence(kind: RepeatKind.monthly, days: [31]);
    expect(
      rule.nextAfter(DateTime(2026, 1, 31, 12), DateTime(2026, 1, 1, 9)),
      DateTime(2026, 3, 31, 9),
    );
    expect(rule.includes(DateTime(2026, 2, 28), DateTime(2026)), false);
  });
  test('Daily repeats start at chosen future date', () {
    const rule = ReminderRecurrence(kind: RepeatKind.daily);
    expect(
      rule.nextAfter(DateTime(2026, 10, 1), DateTime(2026, 10, 10, 18)),
      DateTime(2026, 10, 10, 18),
    );
  });
  test(
    'Complete and skip only one occurrence, preserving future repeats',
    () async {
      final repository = DailyRepository(null, _Notifications());
      final root = TaskModel()
        ..title = 'Walk'
        ..startAt = DateTime(2026, 10, 1, 8)
        ..endAt = DateTime(2026, 10, 1, 8, 1)
        ..reminderOffsetMinutes = -1
        ..recurrenceRule = const ReminderRecurrence(
          kind: RepeatKind.daily,
        ).encode();
      await repository.save(root);
      final today =
          (await repository.watchDay(DateTime(2026, 10, 3)).first).single;
      await repository.toggle(today);
      expect(
        (await repository.watchDay(DateTime(2026, 10, 3)).first).single.status,
        TaskStatus.completed,
      );
      expect(
        (await repository.watchDay(DateTime(2026, 10, 4)).first).single.status,
        TaskStatus.pending,
      );
      await repository.remove(
        (await repository.watchDay(DateTime(2026, 10, 4)).first).single,
      );
      expect(await repository.watchDay(DateTime(2026, 10, 4)).first, isEmpty);
      expect(
        await repository.watchDay(DateTime(2026, 10, 5)).first,
        hasLength(1),
      );
      expect(
        await repository.notificationOccurrence(root.id, DateTime(2026, 10, 4)),
        isNull,
      );
      expect(
        (await repository.monthCounts(DateTime(2026, 10)))[DateTime(
          2026,
          10,
          4,
        )],
        isNull,
      );
      repository.dispose();
    },
  );
  test(
    'Repeated item edit updates future occurrences, not completion history',
    () async {
      final repository = DailyRepository(null, _Notifications());
      final root = TaskModel()
        ..title = 'Old'
        ..startAt = DateTime(2026, 10, 1)
        ..endAt = DateTime(2026, 10, 1, 0, 1)
        ..reminderOffsetMinutes = -1
        ..recurrenceRule = const ReminderRecurrence(
          kind: RepeatKind.daily,
        ).encode();
      await repository.save(root);
      await repository.toggle(
        (await repository.watchDay(DateTime(2026, 10, 2)).first).single,
      );
      root.title = 'New';
      await repository.save(root);
      expect(
        (await repository.watchDay(DateTime(2026, 10, 2)).first).single.title,
        'Old',
      );
      expect(
        (await repository.watchDay(DateTime(2026, 10, 3)).first).single.title,
        'New',
      );
      repository.dispose();
    },
  );
  test('Stats ignore signal gaps and impossible travel', () {
    final start = DateTime(2026);
    final stats = TrailStats([
      TrailFix(const LatLng(12, 77), start, 5),
      TrailFix(
        const LatLng(12.0001, 77),
        start.add(const Duration(seconds: 10)),
        5,
        speed: 1,
      ),
      TrailFix(
        const LatLng(13, 77),
        start.add(const Duration(minutes: 5)),
        5,
        gap: true,
      ),
      TrailFix(
        const LatLng(14, 77),
        start.add(const Duration(minutes: 5, seconds: 3)),
        5,
      ),
    ]);
    expect(stats.distance, inInclusiveRange(10, 12));
    expect(stats.duration, 10);
    expect(stats.maximumSpeed, 1);
    expect(stats.metersPerMinute, inInclusiveRange(60, 72));
  });
  test('Place and GPS fields survive persistence', () {
    const place = SavedPlace(
      id: 'home',
      name: 'Home',
      point: LatLng(12, 77),
      notify: true,
      radius: 125,
      message: 'Pick up keys',
    );
    final saved = SavedPlace.fromJson(place.toJson());
    expect(saved.message, place.message);
    expect(saved.notify, true);
    final fix = TrailFix(
      const LatLng(12, 77),
      DateTime(2026),
      5,
      speed: 2,
      gap: true,
    );
    final restored = TrailFix.fromJson(fix.toJson());
    expect(restored.speed, 2);
    expect(restored.gap, true);
  });
}
