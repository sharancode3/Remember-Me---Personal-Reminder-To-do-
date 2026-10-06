import 'dart:async';
import 'package:isar/isar.dart';
import '../local/isar_service.dart';
import '../models/task_model.dart';
import '../models/focus_session_model.dart';
import '../../services/local_notification_service.dart';
import '../../services/reminder_recurrence.dart';

DateTime dayOnly(DateTime day) => DateTime(day.year, day.month, day.day);

/// The daily app keeps the original task storage without planner constraints.
class DailyRepository {
  DailyRepository(this.database, this.notifications);
  final IsarService? database;
  final LocalNotificationService notifications;
  final List<TaskModel> _memory = [];
  final List<FocusSessionModel> _focusMemory = [];
  final _changes = StreamController<void>.broadcast();
  int _nextId = 1;

  Stream<List<TaskModel>> watchDay(DateTime date) async* {
    final start = dayOnly(date);
    final isar = database?.isar;
    if (isar != null) {
      yield* isar.taskModels
          .where()
          .watch(fireImmediately: true)
          .map((tasks) => _forDay(tasks, start));
    } else {
      List<TaskModel> current() => _forDay(_memory, start);
      yield current();
      yield* _changes.stream.map((_) => current());
    }
  }

  List<TaskModel> _sorted(List<TaskModel> tasks) =>
      tasks..sort((a, b) => a.startAt.compareTo(b.startAt));

  TaskModel occurrence(TaskModel source, DateTime date) => TaskModel()
    ..id =
        -(source.id * 100000 +
            DateTime.utc(
              date.year,
              date.month,
              date.day,
            ).difference(DateTime.utc(1970)).inDays)
    ..templateId = source.id
    ..title = source.title
    ..description = source.description
    ..startAt = DateTime(
      date.year,
      date.month,
      date.day,
      source.startAt.hour,
      source.startAt.minute,
    )
    ..endAt = DateTime(
      date.year,
      date.month,
      date.day,
      source.startAt.hour,
      source.startAt.minute + 1,
    )
    ..reminderOffsetMinutes = source.reminderOffsetMinutes
    ..recurrenceRule = 'occurrence';

  List<TaskModel> _forDay(List<TaskModel> all, DateTime day) {
    final result = all
        .where(
          (t) =>
              !t.isArchived &&
              !ReminderRecurrence.decode(t.recurrenceRule).repeating &&
              dayOnly(t.startAt) == day,
        )
        .toList();
    for (final root in all.where(
      (t) =>
          !t.isArchived &&
          ReminderRecurrence.decode(t.recurrenceRule).repeating,
    )) {
      if (!ReminderRecurrence.decode(
        root.recurrenceRule,
      ).includes(day, root.startAt)) {
        continue;
      }
      final saved = all
          .where(
            (t) =>
                t.recurrenceRule == 'occurrence' &&
                t.templateId == root.id &&
                dayOnly(t.startAt) == day,
          )
          .firstOrNull;
      if (saved == null) result.add(occurrence(root, day));
    }
    return _sorted(result);
  }

  Future<List<TaskModel>> _all() async => database != null
      ? database!.isar.taskModels.where().findAll()
      : [..._memory];

  Future<TaskModel?> notificationOccurrence(int id, DateTime date) async {
    final root = await find(id);
    if (root == null || root.isArchived) return null;
    if (!ReminderRecurrence.decode(root.recurrenceRule).repeating) return root;
    return _forDay(
      await _all(),
      dayOnly(date),
    ).where((t) => t.templateId == id).firstOrNull;
  }

  Future<void> save(TaskModel task) async {
    final child = task.recurrenceRule == 'occurrence';
    if (child && task.id < 0) task.id = Isar.autoIncrement;
    task.updatedAt = DateTime.now();
    final isar = database?.isar;
    if (isar != null) {
      task.id = await isar.writeTxn(() => isar.taskModels.put(task));
    } else {
      if (task.id == Isar.autoIncrement || task.id == 0) task.id = _nextId++;
      _memory.removeWhere((t) => t.id == task.id);
      _memory.add(task);
      _changes.add(null);
    }
    if (child) {
      await notifications.setOccurrenceSkipped(task.templateId!, task.startAt, task.isArchived || task.status == TaskStatus.completed);
      return;
    }
    if (task.status == TaskStatus.completed ||
        task.isArchived ||
        task.reminderOffsetMinutes < 0) {
      await notifications.cancelTaskReminder(task.id);
      await notifications.cancelRecurring(task.id);
    } else {
      if (ReminderRecurrence.decode(task.recurrenceRule).repeating) {
        await notifications.cancelTaskReminder(task.id);
        await notifications.scheduleRecurring(task);
      } else {
        await notifications.cancelRecurring(task.id);
        await notifications.scheduleTaskNudge(task, offsetMinutes: 0);
      }
    }
  }

  Future<void> toggle(TaskModel task) async {
    task.status = task.status == TaskStatus.completed
        ? TaskStatus.pending
        : TaskStatus.completed;
    task.completionPercentage = task.status == TaskStatus.completed ? 100 : 0;
    await save(task);
  }

  Future<void> remove(TaskModel task) async {
    task.isArchived = true;
    await save(task);
  }

  Future<TaskModel?> find(int id) async => database != null
      ? database!.isar.taskModels.get(id)
      : _memory.where((t) => t.id == id).firstOrNull;

  Future<Map<DateTime, int>> monthCounts(DateTime month) async {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);
    final all = await _all();
    final counts = <DateTime, int>{};
    for (
      var day = start;
      day.isBefore(end);
      day = DateTime(day.year, day.month, day.day + 1)
    ) {
      final tasks = _forDay(all, day);
      if (tasks.isNotEmpty) counts[day] = tasks.length;
    }
    return counts;
  }

  Future<void> recordFocus(DateTime start, DateTime end, bool pinned) async {
    final session = FocusSessionModel()
      ..startedAt = start
      ..endedAt = end
      ..deepFocus = pinned
      ..uninterruptedMinutes = end.difference(start).inMinutes;
    if (database != null) {
      await database!.isar.writeTxn(
        () => database!.isar.focusSessionModels.put(session),
      );
    } else {
      _focusMemory.add(session);
    }
    _changes.add(null);
  }

  Future<int> focusMinutes(DateTime date) async {
    final start = dayOnly(date);
    final end = DateTime(start.year, start.month, start.day + 1);
    final sessions = database != null
        ? await database!.isar.focusSessionModels
              .filter()
              .startedAtLessThan(end)
              .findAll()
        : _focusMemory;
    return sessions.fold<int>(0, (sum, s) {
      if (s.endedAt == null || !s.endedAt!.isAfter(start)) return sum;
      final from = s.startedAt.isBefore(start) ? start : s.startedAt;
      final to = s.endedAt!.isAfter(end) ? end : s.endedAt!;
      return sum + to.difference(from).inMinutes;
    });
  }

  void dispose() => _changes.close();
}
