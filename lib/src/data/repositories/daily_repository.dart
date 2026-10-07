import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../local/isar_service.dart';
import '../models/task_model.dart';
import '../models/task_occurrence_model.dart';
import '../models/focus_session_model.dart';
import '../../core/notifications/reminder_scheduler.dart';
import '../../services/reminder_recurrence.dart';
import '../../services/local_notification_service.dart';
import '../../core/logging/app_logger.dart';
import '../../core/platform/native_daily_bridge.dart';

DateTime dayOnly(DateTime day) => DateTime(day.year, day.month, day.day);

String formatDateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

enum EditRecurrenceScope { thisOccurrenceOnly, thisAndFuture, all }

/// Production DailyRepository with materialized occurrences,
/// durable outbox processing, and unified native scheduler integration.
class DailyRepository {
  DailyRepository(
    this.database,
    this.scheduler, [
    this.notifications,
    NativeDailyBridge? bridge,
  ]) : bridge = bridge ?? NativeDailyBridge.instance;

  final IsarService? database;
  final ReminderScheduler scheduler;
  final LocalNotificationService? notifications;
  final NativeDailyBridge bridge;

  static final _logger = AppLogger.create('DailyRepository');

  // In-memory fallbacks for testing and web previews
  final List<TaskModel> _memory = [];
  final List<TaskOccurrence> _occurrencesMemory = [];
  final List<FocusSessionModel> _focusMemory = [];
  final _changes = StreamController<void>.broadcast();
  int _nextTaskId = 1;
  int _nextOccurrenceId = 1;

  Stream<List<TaskModel>> watchDay(DateTime date) async* {
    final start = dayOnly(date);
    final dateKey = formatDateKey(date);
    final isar = database?.isar;

    if (isar != null) {
      await _ensureOccurrencesForDay(date);
      yield* isar.taskOccurrences
          .filter()
          .occurrenceDateEqualTo(dateKey)
          .watch(fireImmediately: true)
          .asyncMap((occurrences) async {
            final tasks = <TaskModel>[];

            // 1. One-off tasks for this day
            final oneOffs = await isar.taskModels
                .filter()
                .isArchivedEqualTo(false)
                .findAll();
            for (final t in oneOffs) {
              if (ReminderRecurrence.decode(t.recurrenceRule).repeating) {
                continue;
              }
              if (dayOnly(t.startAt) != start) continue;
              final occ = await isar.taskOccurrences
                  .filter()
                  .taskIdEqualTo(t.id)
                  .findFirst();
              if (occ != null && occ.status == OccurrenceStatus.skipped) {
                continue;
              }
              if (occ != null) {
                t.status = occ.status == OccurrenceStatus.completed
                    ? TaskStatus.completed
                    : TaskStatus.pending;
                t.completionPercentage =
                    occ.status == OccurrenceStatus.completed ? 100 : 0;
              }
              tasks.add(t);
            }

            // 2. Repeating task occurrences
            for (final occ in occurrences) {
              if (occ.status == OccurrenceStatus.skipped) continue;
              final parent = await isar.taskModels.get(occ.taskId);
              if (parent != null &&
                  !parent.isArchived &&
                  ReminderRecurrence.decode(parent.recurrenceRule).repeating) {
                tasks.add(_buildDisplayTask(parent, occ));
              }
            }
            return _sorted(tasks);
          });
    } else {
      await _ensureOccurrencesForDay(date);
      List<TaskModel> current() {
        final tasks = <TaskModel>[];

        // 1. One-off tasks
        for (final t in _memory) {
          if (t.isArchived) continue;
          if (ReminderRecurrence.decode(t.recurrenceRule).repeating) continue;
          if (dayOnly(t.startAt) != start) continue;
          final occ = _occurrencesMemory
              .where((o) => o.taskId == t.id)
              .firstOrNull;
          if (occ != null && occ.status == OccurrenceStatus.skipped) continue;
          if (occ != null) {
            t.status = occ.status == OccurrenceStatus.completed
                ? TaskStatus.completed
                : TaskStatus.pending;
            t.completionPercentage = occ.status == OccurrenceStatus.completed
                ? 100
                : 0;
          }
          tasks.add(t);
        }

        // 2. Repeating occurrences
        for (final occ in _occurrencesMemory) {
          if (occ.occurrenceDate != dateKey ||
              occ.status == OccurrenceStatus.skipped) {
            continue;
          }
          final parent = _memory.where((t) => t.id == occ.taskId).firstOrNull;
          if (parent != null &&
              !parent.isArchived &&
              ReminderRecurrence.decode(parent.recurrenceRule).repeating) {
            tasks.add(_buildDisplayTask(parent, occ));
          }
        }
        return _sorted(tasks);
      }

      yield current();
      yield* _changes.stream.map((_) => current());
    }
  }

  Future<void> _ensureOccurrencesForDay(DateTime day) async {
    final dateKey = formatDateKey(day);
    final isar = database?.isar;
    if (isar != null) {
      final repeatingTasks = await isar.taskModels
          .filter()
          .isArchivedEqualTo(false)
          .findAll();
      for (final root in repeatingTasks) {
        final recurrence = ReminderRecurrence.decode(root.recurrenceRule);
        if (!recurrence.repeating) continue;
        if (!recurrence.includes(day, root.startAt)) continue;

        final exists = await isar.taskOccurrences
            .filter()
            .taskIdEqualTo(root.id)
            .and()
            .occurrenceDateEqualTo(dateKey)
            .findFirst();
        if (exists == null) {
          final occ = TaskOccurrence()
            ..id = Isar.autoIncrement
            ..taskId = root.id
            ..occurrenceDate = dateKey
            ..scheduledAt = DateTime(
              day.year,
              day.month,
              day.day,
              root.startAt.hour,
              root.startAt.minute,
            )
            ..status = OccurrenceStatus.pending
            ..notificationId = ((root.id * 1000 + day.day) & 0x7FFFFFFF)
            ..updatedAt = DateTime.now();
          await isar.writeTxn(() => isar.taskOccurrences.put(occ));
        }
      }
    } else {
      for (final root in _memory.where((t) => !t.isArchived)) {
        final recurrence = ReminderRecurrence.decode(root.recurrenceRule);
        if (!recurrence.repeating) continue;
        if (!recurrence.includes(day, root.startAt)) continue;

        final exists = _occurrencesMemory
            .where((o) => o.taskId == root.id && o.occurrenceDate == dateKey)
            .firstOrNull;
        if (exists == null) {
          final occ = TaskOccurrence()
            ..id = _nextOccurrenceId++
            ..taskId = root.id
            ..occurrenceDate = dateKey
            ..scheduledAt = DateTime(
              day.year,
              day.month,
              day.day,
              root.startAt.hour,
              root.startAt.minute,
            )
            ..status = OccurrenceStatus.pending
            ..notificationId = ((root.id * 1000 + day.day) & 0x7FFFFFFF)
            ..updatedAt = DateTime.now();
          _occurrencesMemory.add(occ);
        }
      }
    }
  }

  TaskModel _buildDisplayTask(TaskModel parent, TaskOccurrence occ) {
    final repeating = ReminderRecurrence.decode(
      parent.recurrenceRule,
    ).repeating;
    return TaskModel()
      ..id = occ.id
      ..templateId = parent.id
      ..title = occ.titleOverride ?? parent.title
      ..description = occ.noteOverride ?? parent.description
      ..startAt = occ.scheduledAt
      ..endAt = occ.scheduledAt.add(
        Duration(minutes: occ.durationMinutesOverride ?? 1),
      )
      ..reminderOffsetMinutes = parent.reminderOffsetMinutes
      ..recurrenceRule = repeating ? 'occurrence' : parent.recurrenceRule
      ..status = occ.status == OccurrenceStatus.completed
          ? TaskStatus.completed
          : (occ.status == OccurrenceStatus.skipped
                ? TaskStatus.archived
                : TaskStatus.pending)
      ..completionPercentage = occ.status == OccurrenceStatus.completed
          ? 100
          : 0
      ..isAlarmStyle = parent.isAlarmStyle
      ..nagMinutes = parent.nagMinutes
      ..placeId = parent.placeId
      ..tag = parent.tag
      ..checklist = parent.checklist
      ..isArchived =
          parent.isArchived || occ.status == OccurrenceStatus.skipped;
  }

  List<TaskModel> _sorted(List<TaskModel> tasks) =>
      tasks..sort((a, b) => a.startAt.compareTo(b.startAt));

  Future<TaskModel?> find(int id) async {
    final isar = database?.isar;
    if (isar != null) {
      final parent = await isar.taskModels.get(id);
      if (parent != null) return parent;

      final occ = await isar.taskOccurrences.get(id);
      if (occ != null) {
        final p = await isar.taskModels.get(occ.taskId);
        if (p != null) return _buildDisplayTask(p, occ);
      }
      return null;
    } else {
      final parent = _memory.where((t) => t.id == id).firstOrNull;
      if (parent != null) return parent;
      final occ = _occurrencesMemory.where((o) => o.id == id).firstOrNull;
      if (occ != null) {
        final p = _memory.where((t) => t.id == occ.taskId).firstOrNull;
        if (p != null) return _buildDisplayTask(p, occ);
      }
      return null;
    }
  }

  Future<TaskModel?> notificationOccurrence(int id, DateTime date) async {
    final dateKey = formatDateKey(date);
    final isar = database?.isar;
    if (isar != null) {
      final occ = await isar.taskOccurrences
          .filter()
          .taskIdEqualTo(id)
          .and()
          .occurrenceDateEqualTo(dateKey)
          .findFirst();
      if (occ != null) {
        if (occ.status == OccurrenceStatus.skipped) return null;
        final parent = await isar.taskModels.get(occ.taskId);
        if (parent != null && !parent.isArchived) {
          return _buildDisplayTask(parent, occ);
        }
      }
      final parent = await isar.taskModels.get(id);
      if (parent != null && !parent.isArchived) {
        return parent;
      }
      return null;
    } else {
      final occ = _occurrencesMemory
          .where((o) => o.taskId == id && o.occurrenceDate == dateKey)
          .firstOrNull;
      if (occ != null) {
        if (occ.status == OccurrenceStatus.skipped) return null;
        final parent = _memory.where((t) => t.id == occ.taskId).firstOrNull;
        if (parent != null && !parent.isArchived) {
          return _buildDisplayTask(parent, occ);
        }
      }
      final parent = _memory.where((t) => t.id == id).firstOrNull;
      if (parent != null && !parent.isArchived) {
        return parent;
      }
      return null;
    }
  }

  Future<void> save(
    TaskModel task, {
    EditRecurrenceScope scope = EditRecurrenceScope.all,
  }) async {
    final isar = database?.isar;
    task.updatedAt = DateTime.now();

    // Check if this is an occurrence edit
    if (task.templateId != null && task.templateId != task.id) {
      await _saveOccurrenceEdit(task, scope);
      _changes.add(null);
      await reconcile();
      return;
    }

    // Normal or root task save
    if (isar != null) {
      await isar.writeTxn(() async {
        if (task.id == 0) {
          task.id = Isar.autoIncrement;
        }
        task.id = await isar.taskModels.put(task);
      });
    } else {
      if (task.id == 0 || task.id == Isar.autoIncrement) {
        task.id = _nextTaskId++;
      }
      _memory.removeWhere((t) => t.id == task.id);
      _memory.add(task);
    }

    // Materialize occurrences
    final recurrence = ReminderRecurrence.decode(task.recurrenceRule);
    if (recurrence.repeating) {
      await _materializeRollingOccurrencesForTask(task);
      if (task.status == TaskStatus.completed ||
          task.isArchived ||
          task.reminderOffsetMinutes < 0) {
        await notifications?.cancelTaskReminder(task.id);
        await notifications?.cancelRecurring(task.id);
      } else {
        await notifications?.cancelTaskReminder(task.id);
        await notifications?.scheduleRecurring(task);
      }
    } else {
      await _materializeOneOffOccurrence(task);
      if (task.status == TaskStatus.completed ||
          task.isArchived ||
          task.reminderOffsetMinutes < 0) {
        await notifications?.cancelTaskReminder(task.id);
        await notifications?.cancelRecurring(task.id);
      } else {
        await notifications?.cancelRecurring(task.id);
        await notifications?.scheduleTaskNudge(task, offsetMinutes: 0);
      }
    }

    _changes.add(null);
    await reconcile();
  }

  Future<void> _saveOccurrenceEdit(
    TaskModel task,
    EditRecurrenceScope scope,
  ) async {
    final isar = database?.isar;
    final occId = task.id;
    final parentId = task.templateId!;

    if (scope == EditRecurrenceScope.thisOccurrenceOnly) {
      if (isar != null) {
        final occ = await isar.taskOccurrences.get(occId);
        if (occ != null) {
          occ.scheduledAt = task.startAt;
          occ.occurrenceDate = formatDateKey(task.startAt);
          occ.noteOverride = task.description;
          occ.updatedAt = DateTime.now();
          await isar.writeTxn(() => isar.taskOccurrences.put(occ));
        }
      } else {
        final occ = _occurrencesMemory.where((o) => o.id == occId).firstOrNull;
        if (occ != null) {
          occ.scheduledAt = task.startAt;
          occ.occurrenceDate = formatDateKey(task.startAt);
          occ.noteOverride = task.description;
          occ.updatedAt = DateTime.now();
        }
      }
    } else if (scope == EditRecurrenceScope.thisAndFuture) {
      final now = task.startAt;
      if (isar != null) {
        final futureOccs = await isar.taskOccurrences
            .filter()
            .taskIdEqualTo(parentId)
            .and()
            .scheduledAtGreaterThan(now.subtract(const Duration(minutes: 1)))
            .findAll();
        await isar.writeTxn(() async {
          for (final occ in futureOccs) {
            occ.scheduledAt = DateTime(
              occ.scheduledAt.year,
              occ.scheduledAt.month,
              occ.scheduledAt.day,
              task.startAt.hour,
              task.startAt.minute,
            );
            occ.noteOverride = task.description;
            occ.updatedAt = DateTime.now();
            await isar.taskOccurrences.put(occ);
          }
        });
      } else {
        for (final occ in _occurrencesMemory.where(
          (o) => o.taskId == parentId && !o.scheduledAt.isBefore(now),
        )) {
          occ.scheduledAt = DateTime(
            occ.scheduledAt.year,
            occ.scheduledAt.month,
            occ.scheduledAt.day,
            task.startAt.hour,
            task.startAt.minute,
          );
          occ.noteOverride = task.description;
          occ.updatedAt = DateTime.now();
        }
      }
    } else {
      final parent = await find(parentId);
      if (parent != null) {
        parent.title = task.title;
        parent.description = task.description;
        parent.startAt = DateTime(
          parent.startAt.year,
          parent.startAt.month,
          parent.startAt.day,
          task.startAt.hour,
          task.startAt.minute,
        );
        parent.endAt = parent.startAt.add(const Duration(minutes: 1));
        parent.reminderOffsetMinutes = task.reminderOffsetMinutes;
        parent.isAlarmStyle = task.isAlarmStyle;
        parent.nagMinutes = task.nagMinutes;
        parent.recurrenceRule = task.recurrenceRule;
        await save(parent);
      }
    }
  }

  Future<void> _materializeOneOffOccurrence(TaskModel task) async {
    final isar = database?.isar;
    final dateKey = formatDateKey(task.startAt);

    if (isar != null) {
      var occ = await isar.taskOccurrences
          .filter()
          .taskIdEqualTo(task.id)
          .findFirst();
      await isar.writeTxn(() async {
        if (occ == null) {
          occ = TaskOccurrence()
            ..id = Isar.autoIncrement
            ..taskId = task.id
            ..occurrenceDate = dateKey
            ..scheduledAt = task.startAt
            ..status = task.status == TaskStatus.completed
                ? OccurrenceStatus.completed
                : OccurrenceStatus.pending
            ..notificationId = (task.id & 0x7FFFFFFF)
            ..updatedAt = DateTime.now();
        } else {
          occ!.occurrenceDate = dateKey;
          occ!.scheduledAt = task.startAt;
          occ!.status = task.status == TaskStatus.completed
              ? OccurrenceStatus.completed
              : OccurrenceStatus.pending;
          occ!.updatedAt = DateTime.now();
        }
        await isar.taskOccurrences.put(occ!);
      });
    } else {
      var occ = _occurrencesMemory
          .where((o) => o.taskId == task.id)
          .firstOrNull;
      if (occ == null) {
        occ = TaskOccurrence()
          ..id = _nextOccurrenceId++
          ..taskId = task.id
          ..occurrenceDate = dateKey
          ..scheduledAt = task.startAt
          ..status = task.status == TaskStatus.completed
              ? OccurrenceStatus.completed
              : OccurrenceStatus.pending
          ..notificationId = (task.id & 0x7FFFFFFF)
          ..updatedAt = DateTime.now();
        _occurrencesMemory.add(occ);
      } else {
        occ.occurrenceDate = dateKey;
        occ.scheduledAt = task.startAt;
        occ.status = task.status == TaskStatus.completed
            ? OccurrenceStatus.completed
            : OccurrenceStatus.pending;
        occ.updatedAt = DateTime.now();
      }
    }
  }

  Future<void> _materializeRollingOccurrencesForTask(TaskModel task) async {
    final isar = database?.isar;
    final recurrence = ReminderRecurrence.decode(task.recurrenceRule);
    if (!recurrence.repeating) return;

    final startDay = dayOnly(task.startAt);
    final limit = startDay.add(const Duration(days: 30));

    for (
      var d = startDay;
      !d.isAfter(limit);
      d = d.add(const Duration(days: 1))
    ) {
      if (!recurrence.includes(d, task.startAt)) continue;
      final dateKey = formatDateKey(d);
      final scheduledAt = DateTime(
        d.year,
        d.month,
        d.day,
        task.startAt.hour,
        task.startAt.minute,
      );

      if (isar != null) {
        final exists = await isar.taskOccurrences
            .filter()
            .taskIdEqualTo(task.id)
            .and()
            .occurrenceDateEqualTo(dateKey)
            .findFirst();
        if (exists == null) {
          final occ = TaskOccurrence()
            ..id = Isar.autoIncrement
            ..taskId = task.id
            ..occurrenceDate = dateKey
            ..scheduledAt = scheduledAt
            ..status = OccurrenceStatus.pending
            ..notificationId = ((task.id * 1000 + d.day) & 0x7FFFFFFF)
            ..updatedAt = DateTime.now();
          await isar.writeTxn(() => isar.taskOccurrences.put(occ));
        }
      } else {
        final exists = _occurrencesMemory
            .where((o) => o.taskId == task.id && o.occurrenceDate == dateKey)
            .firstOrNull;
        if (exists == null) {
          final occ = TaskOccurrence()
            ..id = _nextOccurrenceId++
            ..taskId = task.id
            ..occurrenceDate = dateKey
            ..scheduledAt = scheduledAt
            ..status = OccurrenceStatus.pending
            ..notificationId = ((task.id * 1000 + d.day) & 0x7FFFFFFF)
            ..updatedAt = DateTime.now();
          _occurrencesMemory.add(occ);
        }
      }
    }
  }

  Future<void> toggle(TaskModel task) async {
    final isar = database?.isar;
    final occId = task.id;

    if (isar != null) {
      final occ =
          await isar.taskOccurrences.get(occId) ??
          await isar.taskOccurrences
              .filter()
              .taskIdEqualTo(task.id)
              .findFirst();
      if (occ != null) {
        final parent = await isar.taskModels.get(occ.taskId);
        final isDone = occ.status == OccurrenceStatus.completed;
        occ.status = isDone
            ? OccurrenceStatus.pending
            : OccurrenceStatus.completed;
        occ.completedAt = isDone ? null : DateTime.now();
        occ.titleOverride = isDone ? null : (parent?.title ?? task.title);
        occ.updatedAt = DateTime.now();
        await isar.writeTxn(() => isar.taskOccurrences.put(occ));

        if (occ.status == OccurrenceStatus.completed) {
          await scheduler.cancelOccurrence(occ.id);
          await notifications?.cancelTaskReminder(task.id);
        } else if (task.reminderOffsetMinutes >= 0) {
          await notifications?.scheduleTaskNudge(task, offsetMinutes: 0);
        }

        task.status = occ.status == OccurrenceStatus.completed
            ? TaskStatus.completed
            : TaskStatus.pending;
        task.completionPercentage = occ.status == OccurrenceStatus.completed
            ? 100
            : 0;

        if (parent != null &&
            !ReminderRecurrence.decode(parent.recurrenceRule).repeating) {
          parent.status = task.status;
          parent.completionPercentage = task.completionPercentage;
          parent.updatedAt = DateTime.now();
          await isar.writeTxn(() => isar.taskModels.put(parent));
        }
      }
    } else {
      final occ =
          _occurrencesMemory.where((o) => o.id == occId).firstOrNull ??
          _occurrencesMemory.where((o) => o.taskId == task.id).firstOrNull;
      if (occ != null) {
        final parent = _memory.where((t) => t.id == occ.taskId).firstOrNull;
        final isDone = occ.status == OccurrenceStatus.completed;
        occ.status = isDone
            ? OccurrenceStatus.pending
            : OccurrenceStatus.completed;
        occ.completedAt = isDone ? null : DateTime.now();
        occ.titleOverride = isDone ? null : (parent?.title ?? task.title);
        occ.updatedAt = DateTime.now();

        if (occ.status == OccurrenceStatus.completed) {
          await scheduler.cancelOccurrence(occ.id);
          await notifications?.cancelTaskReminder(task.id);
        } else if (task.reminderOffsetMinutes >= 0) {
          await notifications?.scheduleTaskNudge(task, offsetMinutes: 0);
        }

        task.status = occ.status == OccurrenceStatus.completed
            ? TaskStatus.completed
            : TaskStatus.pending;
        task.completionPercentage = occ.status == OccurrenceStatus.completed
            ? 100
            : 0;

        if (parent != null &&
            !ReminderRecurrence.decode(parent.recurrenceRule).repeating) {
          parent.status = task.status;
          parent.completionPercentage = task.completionPercentage;
        }
      }
    }

    _changes.add(null);
    await reconcile();
  }

  Future<void> remove(TaskModel task, {bool deleteAll = false}) async {
    final isar = database?.isar;
    final isRepeatingOccurrence =
        task.templateId != null && task.templateId != task.id;

    if (isRepeatingOccurrence && !deleteAll) {
      if (isar != null) {
        final occ = await isar.taskOccurrences.get(task.id);
        if (occ != null) {
          occ.status = OccurrenceStatus.skipped;
          occ.updatedAt = DateTime.now();
          await isar.writeTxn(() => isar.taskOccurrences.put(occ));
          await scheduler.cancelOccurrence(occ.id);
        }
      } else {
        final occ = _occurrencesMemory
            .where((o) => o.id == task.id)
            .firstOrNull;
        if (occ != null) {
          occ.status = OccurrenceStatus.skipped;
          occ.updatedAt = DateTime.now();
          await scheduler.cancelOccurrence(occ.id);
        }
      }
    } else {
      final parentId = task.templateId ?? task.id;
      task.isArchived = true;
      await notifications?.cancelTaskReminder(parentId);
      await notifications?.cancelRecurring(parentId);

      if (isar != null) {
        final parent = await isar.taskModels.get(parentId);
        if (parent != null) {
          parent.isArchived = true;
          parent.updatedAt = DateTime.now();
          await isar.writeTxn(() => isar.taskModels.put(parent));
        }
        final occs = await isar.taskOccurrences
            .filter()
            .taskIdEqualTo(parentId)
            .findAll();
        await isar.writeTxn(() async {
          for (final occ in occs) {
            occ.status = OccurrenceStatus.skipped;
            occ.updatedAt = DateTime.now();
            await isar.taskOccurrences.put(occ);
            await scheduler.cancelOccurrence(occ.id);
          }
        });
      } else {
        final parent = _memory.where((t) => t.id == parentId).firstOrNull;
        if (parent != null) parent.isArchived = true;
        for (final occ in _occurrencesMemory.where(
          (o) => o.taskId == parentId,
        )) {
          occ.status = OccurrenceStatus.skipped;
          occ.updatedAt = DateTime.now();
          await scheduler.cancelOccurrence(occ.id);
        }
      }
    }

    _changes.add(null);
    await reconcile();
  }

  Future<void> drainAndProcessOutbox() async {
    try {
      final actions = await scheduler.drainOutbox();
      if (actions.isEmpty) return;

      final processedUuids = <String>[];
      final isar = database?.isar;

      for (final actionMap in actions) {
        final uuid = actionMap['uuid'] as String?;
        final action = actionMap['action'] as String?;
        final occurrenceId = (actionMap['occurrenceId'] as num?)?.toInt();
        if (uuid == null || action == null || occurrenceId == null) continue;

        if (isar != null) {
          final occ = await isar.taskOccurrences.get(occurrenceId);
          if (occ != null) {
            if (action == 'mark_done') {
              occ.status = OccurrenceStatus.completed;
              occ.completedAt = DateTime.now();
              occ.updatedAt = DateTime.now();
              await isar.writeTxn(() => isar.taskOccurrences.put(occ));
              await scheduler.cancelOccurrence(occ.id);

              final parent = await isar.taskModels.get(occ.taskId);
              if (parent != null &&
                  !ReminderRecurrence.decode(parent.recurrenceRule).repeating) {
                parent.status = TaskStatus.completed;
                parent.completionPercentage = 100;
                await isar.writeTxn(() => isar.taskModels.put(parent));
              }
            } else if (action.startsWith('snooze_')) {
              final minutes =
                  (actionMap['snoozeMinutes'] as num?)?.toInt() ??
                  (action == 'snooze_1h' ? 60 : 10);
              occ.snoozedUntil = DateTime.now().add(Duration(minutes: minutes));
              occ.updatedAt = DateTime.now();
              await isar.writeTxn(() => isar.taskOccurrences.put(occ));
            }
          }
        } else {
          final occ =
              _occurrencesMemory
                  .where((o) => o.id == occurrenceId)
                  .firstOrNull ??
              _occurrencesMemory
                  .where((o) => o.taskId == occurrenceId)
                  .firstOrNull;
          if (occ != null) {
            if (action == 'mark_done') {
              occ.status = OccurrenceStatus.completed;
              occ.completedAt = DateTime.now();
              await scheduler.cancelOccurrence(occ.id);

              final parent = _memory
                  .where((t) => t.id == occ.taskId)
                  .firstOrNull;
              if (parent != null &&
                  !ReminderRecurrence.decode(parent.recurrenceRule).repeating) {
                parent.status = TaskStatus.completed;
                parent.completionPercentage = 100;
              }
            } else if (action.startsWith('snooze_')) {
              final minutes =
                  (actionMap['snoozeMinutes'] as num?)?.toInt() ?? 10;
              occ.snoozedUntil = DateTime.now().add(Duration(minutes: minutes));
            }
          }
        }
        processedUuids.add(uuid);
      }

      if (processedUuids.isNotEmpty) {
        await scheduler.acknowledgeOutbox(processedUuids);
        _logger.info(
          'Processed and acknowledged ${processedUuids.length} outbox notifications',
        );
        _changes.add(null);
      }
    } catch (e, st) {
      _logger.severe('Failed to process notification outbox', e, st);
    }
  }

  Future<void> reconcile() async {
    final now = DateTime.now();
    final windowLimit = now.add(const Duration(days: 14));
    final isar = database?.isar;

    // 1. Materialize rolling occurrences for all repeating tasks
    if (isar != null) {
      final repeatingTasks = await isar.taskModels
          .filter()
          .isArchivedEqualTo(false)
          .findAll();
      for (final task in repeatingTasks) {
        if (ReminderRecurrence.decode(task.recurrenceRule).repeating) {
          await _materializeRollingOccurrencesForTask(task);
        }
      }
    } else {
      for (final task in _memory.where((t) => !t.isArchived)) {
        if (ReminderRecurrence.decode(task.recurrenceRule).repeating) {
          await _materializeRollingOccurrencesForTask(task);
        }
      }
    }

    // 2. Gather desired future occurrences
    final desired = <TaskOccurrence>[];
    final titles = <int, String>{};
    final alarmStyles = <int, bool>{};
    final nagMinutes = <int, int>{};

    if (isar != null) {
      final pendingOccurrences = await isar.taskOccurrences
          .filter()
          .statusEqualTo(OccurrenceStatus.pending)
          .and()
          .scheduledAtGreaterThan(now)
          .and()
          .scheduledAtLessThan(windowLimit)
          .findAll();

      for (final occ in pendingOccurrences) {
        final parent = await isar.taskModels.get(occ.taskId);
        if (parent != null &&
            !parent.isArchived &&
            parent.reminderOffsetMinutes >= 0) {
          desired.add(occ);
          titles[occ.taskId] = parent.title;
          alarmStyles[occ.taskId] = parent.isAlarmStyle;
          nagMinutes[occ.taskId] = parent.nagMinutes;
        }
      }
    } else {
      for (final occ in _occurrencesMemory) {
        if (occ.status == OccurrenceStatus.pending &&
            occ.scheduledAt.isAfter(now) &&
            occ.scheduledAt.isBefore(windowLimit)) {
          final parent = _memory.where((t) => t.id == occ.taskId).firstOrNull;
          if (parent != null &&
              !parent.isArchived &&
              parent.reminderOffsetMinutes >= 0) {
            desired.add(occ);
            titles[occ.taskId] = parent.title;
            alarmStyles[occ.taskId] = parent.isAlarmStyle;
            nagMinutes[occ.taskId] = parent.nagMinutes;
          }
        }
      }
    }

    // 3. Delegate reconciliation to scheduler
    await scheduler.reconcile(
      desired,
      titles: titles,
      alarmStyles: alarmStyles,
      nagMinutes: nagMinutes,
    );

    // 4. Sync linked tasks by place for native geofencing/arrival alerts
    await syncTasksByPlace();
  }

  Future<void> syncTasksByPlace() async {
    try {
      final isar = database?.isar;
      final pendingTasks = isar != null
          ? await isar.taskModels
                .filter()
                .statusEqualTo(TaskStatus.pending)
                .and()
                .isArchivedEqualTo(false)
                .findAll()
          : _memory
                .where((t) => t.status == TaskStatus.pending && !t.isArchived)
                .toList();

      final map = <String, List<String>>{};
      for (final t in pendingTasks) {
        final tag = t.resolvedPlaceTag;
        if (tag != null && tag.isNotEmpty) {
          map.putIfAbsent(tag, () => []).add(t.title);
          map.putIfAbsent(tag.toLowerCase(), () => []).add(t.title);
          final cleanTag = tag.replaceAll('@', '').toLowerCase();
          if (cleanTag.isNotEmpty) {
            map.putIfAbsent(cleanTag, () => []).add(t.title);
          }
        }
      }
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        await bridge.syncTasksByPlace(map);
      }
    } catch (e, st) {
      _logger.warning('Failed to sync tasks by place', e, st);
    }
  }

  Future<Map<DateTime, int>> monthCounts(DateTime month) async {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);
    final counts = <DateTime, int>{};

    // Ensure repeating occurrences for each day in this month exist
    for (var d = start; d.isBefore(end); d = d.add(const Duration(days: 1))) {
      await _ensureOccurrencesForDay(d);
    }

    final isar = database?.isar;
    if (isar != null) {
      // 1. One-offs
      final oneOffs = await isar.taskModels
          .filter()
          .isArchivedEqualTo(false)
          .findAll();
      for (final t in oneOffs) {
        if (ReminderRecurrence.decode(t.recurrenceRule).repeating) continue;
        if (t.startAt.isBefore(start) || !t.startAt.isBefore(end)) continue;
        final day = dayOnly(t.startAt);
        counts[day] = (counts[day] ?? 0) + 1;
      }

      // 2. Occurrences
      final occs = await isar.taskOccurrences
          .filter()
          .scheduledAtGreaterThan(start.subtract(const Duration(seconds: 1)))
          .and()
          .scheduledAtLessThan(end)
          .findAll();

      for (final occ in occs) {
        if (occ.status == OccurrenceStatus.skipped) continue;
        final parent = await isar.taskModels.get(occ.taskId);
        if (parent == null || parent.isArchived) continue;
        if (!ReminderRecurrence.decode(parent.recurrenceRule).repeating) {
          continue;
        }
        final day = dayOnly(occ.scheduledAt);
        counts[day] = (counts[day] ?? 0) + 1;
      }
    } else {
      for (final t in _memory) {
        if (t.isArchived) continue;
        if (ReminderRecurrence.decode(t.recurrenceRule).repeating) continue;
        if (t.startAt.isBefore(start) || !t.startAt.isBefore(end)) continue;
        final day = dayOnly(t.startAt);
        counts[day] = (counts[day] ?? 0) + 1;
      }

      for (final occ in _occurrencesMemory) {
        if (occ.status == OccurrenceStatus.skipped) continue;
        if (occ.scheduledAt.isBefore(start) || !occ.scheduledAt.isBefore(end)) {
          continue;
        }
        final parent = _memory.where((t) => t.id == occ.taskId).firstOrNull;
        if (parent == null || parent.isArchived) continue;
        if (!ReminderRecurrence.decode(parent.recurrenceRule).repeating) {
          continue;
        }
        final day = dayOnly(occ.scheduledAt);
        counts[day] = (counts[day] ?? 0) + 1;
      }
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
