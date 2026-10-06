import 'package:isar/isar.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/weekly_productivity.dart';
import '../../domain/entities/weekly_log_stats.dart';
import '../../domain/repositories/planner_repository.dart';
import '../local/isar_service.dart';
import '../models/advanced_models.dart';
import '../models/routine_template_model.dart';
import '../models/task_model.dart';
import '../../services/backup_service.dart';
import '../../services/local_notification_service.dart';

class PlannerRepositoryImpl implements PlannerRepository {
  PlannerRepositoryImpl(this._isarService, {LocalNotificationService? notifications})
      : _backupService = BackupService(_isarService),
        _notifications = notifications;

  final IsarService _isarService;
  final BackupService _backupService;
  final LocalNotificationService? _notifications;

  Isar get _isar => _isarService.isar;

  @override
  Stream<List<TaskModel>> watchTasksForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return _isar.taskModels
      .filter()
      .startAtGreaterThan(start.subtract(const Duration(milliseconds: 1)))
      .and()
      .startAtLessThan(end)
      .and()
      .isArchivedEqualTo(false)
        .watch(fireImmediately: true);
  }

  @override
  Stream<List<TaskModel>> watchCurrentInProgress(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return _isar.taskModels
        .filter()
        .startAtLessThan(end)
        .and()
        .endAtGreaterThan(start)
        .watch(fireImmediately: true)
        .map((items) {
      final now = DateTime.now();
      return items
          .where((task) => !task.isArchived && now.isAfter(task.startAt) && now.isBefore(task.endAt))
          .toList()
        ..sort((a, b) => a.startAt.compareTo(b.startAt));
    });
  }

  @override
  Future<List<TaskModel>> getOverflowForDay(DateTime day) async {
    final target = DateTime(day.year, day.month, day.day);
    final yesterdayStart = target.subtract(const Duration(days: 1));
    final yesterdayEnd = target;
    final previousDayTasks = await _isar.taskModels
        .where()
        .startAtBetween(yesterdayStart, yesterdayEnd, includeUpper: false)
        .findAll();

    return previousDayTasks.where((task) => !task.isArchived && task.status == TaskStatus.missed).toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
  }

  @override
  Future<void> upsertTask(TaskModel task) async {
    final settings = await getAppSettings();
    final scheduleCheck = await checkSchedule(task, allowSleepOverride: settings.allowSleepOverride);
    if (!scheduleCheck.allowed) {
      throw StateError(scheduleCheck.message ?? 'Task conflicts with blueprint constraints.');
    }

    task = await _applyBuffer(task, settings.bufferMinutes);
    task.completionPercentage = _deriveCompletionPercentage(task);
    task.status = _deriveStatus(task, DateTime.now());
    task.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.taskModels.put(task);

      final normalizedDate = DateTime(task.startAt.year, task.startAt.month, task.startAt.day);
      TaskInstanceModel? mirror;
      if (task.id != 0) {
        mirror = await _isar.taskInstanceModels.where().idEqualTo(task.id).findFirst();
      }
      mirror ??= TaskInstanceModel();
      mirror
        ..id = task.id == 0 ? mirror.id : task.id
        ..templateId = task.templateId
        ..date = normalizedDate
        ..startTime = task.startAt.hour * 60 + task.startAt.minute
        ..endTime = task.endAt.hour * 60 + task.endAt.minute
        ..title = task.title
        ..description = task.description
        ..categoryId = task.categoryId
        ..status = _toLifecycle(task.status)
        ..completionPercentage = task.completionPercentage
        ..manuallyRescheduled = task.manuallyRescheduled
        ..isArchived = task.isArchived
        ..createdAt = task.createdAt
        ..updatedAt = task.updatedAt;

      final instanceId = await _isar.taskInstanceModels.put(mirror);
      task.id = instanceId;

      await _isar.checklistItems.filter().taskInstanceIdEqualTo(instanceId).deleteAll();
      if (task.checklist.isNotEmpty) {
        final checklist = task.checklist
            .map(
              (item) => ChecklistItem()
                ..taskInstanceId = instanceId
                ..title = item.text
                ..isCompleted = item.isChecked,
            )
            .toList();
        await _isar.checklistItems.putAll(checklist);
      }

      if (task.tag != null) {
        await _upsertCategoryFromTag(task);
      }
    });

    if (_notifications != null) {
      if (task.isArchived || task.status == TaskStatus.completed || task.reminderOffsetMinutes == -1) {
        await _notifications.cancelTaskReminder(task.id);
      } else {
        await _notifications.scheduleTaskNudge(task, offsetMinutes: _effectiveReminderOffset(task));
      }
    }
  }

  @override
  Future<void> upsertTasks(List<TaskModel> tasks) async {
    if (tasks.isEmpty) return;
    for (final task in tasks) {
      await upsertTask(task);
    }
  }

  @override
  Future<TaskModel?> getTaskById(int id) {
    return _isar.taskModels.where().idEqualTo(id).findFirst();
  }

  @override
  Future<List<TaskModel>> getTasksInRange(DateTime startInclusive, DateTime endExclusive) {
    return _isar.taskModels
        .filter()
        .startAtGreaterThan(startInclusive.subtract(const Duration(milliseconds: 1)))
        .and()
        .startAtLessThan(endExclusive)
        .and()
        .isArchivedEqualTo(false)
        .findAll();
  }

  @override
  Future<void> updateTaskChecklist(TaskModel task, int itemIndex, bool value) async {
    if (itemIndex < 0 || itemIndex >= task.checklist.length) return;
    task.checklist[itemIndex].isChecked = value;
    task.completionPercentage = _deriveCompletionPercentage(task);
    task.status = _deriveStatus(task, DateTime.now());
    await upsertTask(task);
  }

  @override
  Future<void> saveRoutineTemplate(RoutineTemplateModel template) async {
    await _isar.writeTxn(() async {
      await _isar.routineTemplateModels.put(template);

      final advanced = TaskTemplateModel()
        ..title = template.title
        ..description = ''
        ..startTime = template.startMinuteOfDay
        ..endTime = template.endMinuteOfDay
        ..recurrencePattern = RecurrencePattern.customWeekdays
        ..weekdayMask = _weekdayMaskFromList(template.weekdays)
        ..isStaticRoutine = true
        ..defaultReminderOffsetMinutes = template.reminderOffsetMinutes
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();
      if (template.tag != null) {
        final categoryId = await _upsertCategoryFromTagValue(template.tag!);
        advanced.categoryId = categoryId;
      }
      await _isar.taskTemplateModels.put(advanced);
    });
  }

  @override
  Future<void> generateWeekFromTemplates(DateTime weekAnchor) async {
    final weekStart = _startOfWeek(weekAnchor);
    final templates = await _isar.taskTemplateModels.where().findAll();
    final toInsert = <TaskModel>[];
    final reminderByTask = <MapEntry<TaskModel, int>>[];

    for (var index = 0; index < 7; index++) {
      final day = weekStart.add(Duration(days: index));
      for (final template in templates.where((template) => _matchesRecurrence(template, day.weekday))) {
        final start = DateTime(day.year, day.month, day.day)
            .add(Duration(minutes: template.startTime));
        final end = DateTime(day.year, day.month, day.day)
            .add(Duration(minutes: template.endTime));

        final existing = await _isar.taskModels
            .filter()
            .templateIdEqualTo(template.id)
            .and()
            .startAtEqualTo(start)
            .findFirst();
        if (existing != null) {
          continue;
        }

        final task = TaskModel()
          ..templateId = template.id
          ..title = template.title
          ..description = template.description
          ..categoryId = template.categoryId
          ..startAt = start
          ..endAt = end
          ..reminderOffsetMinutes = template.defaultReminderOffsetMinutes
          ..status = TaskStatus.pending
          ..completionPercentage = 0
          ..checklist = [ChecklistItemModel(text: 'Planned block', isChecked: false)];
        toInsert.add(task);
        reminderByTask.add(MapEntry(task, template.defaultReminderOffsetMinutes));
      }
    }

    if (toInsert.isEmpty) return;

    await _isar.writeTxn(() async {
      await _isar.taskModels.putAll(toInsert);
    });

    if (_notifications != null) {
      for (final entry in reminderByTask) {
        await _notifications.scheduleTaskNudge(entry.key, offsetMinutes: entry.value);
      }
    }
  }

  @override
  Future<WeeklyLogStats> getWeeklyStats(DateTime weekAnchor) async {
    await syncLifecycleStates(DateTime.now());
    final weekStart = _startOfWeek(weekAnchor);
    final weekEnd = weekStart.add(const Duration(days: 7));
    final tasks = await _isar.taskModels
        .filter()
        .startAtGreaterThan(weekStart.subtract(const Duration(milliseconds: 1)))
        .and()
        .startAtLessThan(weekEnd)
        .and()
        .isArchivedEqualTo(false)
        .findAll();
    final completed = tasks.where((task) => task.status == TaskStatus.completed).length;

    return WeeklyLogStats(
      total: tasks.length,
      completed: completed,
      pending: tasks.length - completed,
    );
  }

  @override
  Future<Map<DateTime, double>> getWeekDayCompletion(DateTime weekAnchor) async {
    final weekStart = _startOfWeek(weekAnchor);
    final weekEnd = weekStart.add(const Duration(days: 7));
    final tasks = await _isar.taskModels
        .filter()
        .startAtGreaterThan(weekStart.subtract(const Duration(milliseconds: 1)))
        .and()
        .startAtLessThan(weekEnd)
        .and()
        .isArchivedEqualTo(false)
        .findAll();

    final map = <DateTime, double>{};
    for (var i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      final dayTasks = tasks
          .where((task) => !task.startAt.isBefore(dayStart) && task.startAt.isBefore(dayEnd))
          .toList();
      if (dayTasks.isEmpty) {
        map[dayStart] = 0;
        continue;
      }
      final done = dayTasks.where((task) => task.status == TaskStatus.completed).length;
      map[dayStart] = done / dayTasks.length;
    }
    return map;
  }

  @override
  Future<Map<DateTime, double>> getMonthDayCompletion(DateTime monthAnchor) async {
    final monthStart = DateTime(monthAnchor.year, monthAnchor.month, 1);
    final monthEnd = DateTime(monthAnchor.year, monthAnchor.month + 1, 1);
    final tasks = await _isar.taskModels
        .filter()
        .startAtGreaterThan(monthStart.subtract(const Duration(milliseconds: 1)))
        .and()
        .startAtLessThan(monthEnd)
        .and()
        .isArchivedEqualTo(false)
        .findAll();

    final map = <DateTime, double>{};
    final totalDays = DateTime(monthAnchor.year, monthAnchor.month + 1, 0).day;
    for (var day = 1; day <= totalDays; day++) {
      final start = DateTime(monthAnchor.year, monthAnchor.month, day);
      final end = start.add(const Duration(days: 1));
      final dayTasks = tasks
          .where((task) => !task.startAt.isBefore(start) && task.startAt.isBefore(end))
          .toList();
      if (dayTasks.isEmpty) {
        map[start] = 0;
        continue;
      }
      final completed = dayTasks.where((task) => task.status == TaskStatus.completed).length;
      map[start] = completed / dayTasks.length;
    }
    return map;
  }

  @override
  Future<void> archiveTask(TaskModel task) async {
    task
      ..isArchived = true
      ..status = TaskStatus.archived
      ..updatedAt = DateTime.now();
    await upsertTask(task);
    if (_notifications != null) {
      await _notifications.cancelTaskReminder(task.id);
    }
  }

  @override
  Future<void> syncLifecycleStates(DateTime now) async {
    final tasks = await _isar.taskModels.where().findAll();
    final settings = await getAppSettings();
    final overdueNudges = <TaskModel>[];
    await _isar.writeTxn(() async {
      for (final task in tasks) {
        if (task.isArchived) {
          task.status = TaskStatus.archived;
          continue;
        }
        task.completionPercentage = _deriveCompletionPercentage(task);
        task.status = _deriveStatus(task, now);
        if (settings.overdueAlertsEnabled &&
            task.status != TaskStatus.completed &&
            now.isAfter(task.endAt.add(const Duration(hours: 2))) &&
            (task.lastOverdueNudgeAt == null || now.difference(task.lastOverdueNudgeAt!).inHours >= 6)) {
          overdueNudges.add(task);
          task.lastOverdueNudgeAt = now;
        }
        task.updatedAt = now;
      }
      await _isar.taskModels.putAll(tasks);
    });

    if (_notifications != null) {
      for (final task in overdueNudges) {
        await _notifications.showOverdueNudge(task);
      }
    }

    await _trySendDailySummary(now, settings);
  }

  @override
  Future<void> quickCompleteTask(TaskModel task) async {
    if (task.checklist.isEmpty) {
      task.checklist = [ChecklistItemModel(text: 'Completed', isChecked: true)];
    } else {
      for (final item in task.checklist) {
        item.isChecked = true;
      }
    }
    task.completionPercentage = 100;
    task.status = TaskStatus.completed;
    await upsertTask(task);
    if (_notifications != null) {
      await _notifications.cancelTaskReminder(task.id);
    }
  }

  @override
  Future<void> rescheduleOverflowTask(TaskModel sourceTask, DateTime targetDate, int startMinuteOfDay) async {
    final duration = sourceTask.endAt.difference(sourceTask.startAt).inMinutes;
    final newStart = DateTime(targetDate.year, targetDate.month, targetDate.day)
        .add(Duration(minutes: startMinuteOfDay));
    final newTask = TaskModel()
      ..templateId = sourceTask.templateId
      ..title = sourceTask.title
      ..description = sourceTask.description
      ..categoryId = sourceTask.categoryId
      ..startAt = newStart
      ..endAt = newStart.add(Duration(minutes: duration))
        ..reminderOffsetMinutes = sourceTask.reminderOffsetMinutes
      ..tag = sourceTask.tag
      ..checklist = sourceTask.checklist
          .map((item) => ChecklistItemModel(text: item.text, isChecked: false))
          .toList()
      ..manuallyRescheduled = true;
    await upsertTask(newTask);
  }

  @override
  Future<WeeklyProductivity> getWeeklyProductivity(DateTime weekAnchor, {bool useCache = true}) async {
    final weekStart = _startOfWeek(weekAnchor);
    if (useCache) {
        final cached = await _isar.weeklySummaryCaches
          .filter()
          .weekStartDateEqualTo(weekStart)
          .findFirst();
      if (cached != null) {
        return WeeklyProductivity(
          totalScheduledMinutes: cached.totalScheduledMinutes,
          totalCompletedMinutes: cached.totalCompletedMinutes,
          completionRatio: cached.completionRate,
          categoryWiseProductivity: _decodeCategoryProductivity(cached.categoryWiseProductivityJson),
          mostProductive2HourWindow: cached.mostProductive2HourWindow,
          mostFrequentMissedTimeSlot: cached.mostMissedTimeSlot,
          missedCount: cached.missedCount,
        );
      }
    }

    final weekEnd = weekStart.add(const Duration(days: 7));
    final tasks = await _isar.taskModels
        .filter()
        .startAtGreaterThan(weekStart.subtract(const Duration(milliseconds: 1)))
        .and()
        .startAtLessThan(weekEnd)
        .and()
        .isArchivedEqualTo(false)
        .findAll();

    final totalScheduledMinutes = tasks.fold<int>(0, (sum, task) => sum + task.endAt.difference(task.startAt).inMinutes);
    final completedTasks = tasks.where((task) => task.status == TaskStatus.completed).toList();
    final totalCompletedMinutes = completedTasks.fold<int>(0, (sum, task) => sum + task.endAt.difference(task.startAt).inMinutes);
    final completionRatio = totalScheduledMinutes == 0 ? 0.0 : totalCompletedMinutes / totalScheduledMinutes;
    final missedCount = tasks.where((task) => task.status == TaskStatus.missed).length;

    final categoryDurations = <String, int>{};
    final hourWindowScore = <int, int>{};
    final missedSlotFrequency = <int, int>{};
    final productiveDayScore = <int, int>{};

    for (final task in tasks) {
      final minutes = task.endAt.difference(task.startAt).inMinutes;
      final category = task.tag?.name ?? 'Uncategorized';
      categoryDurations[category] = (categoryDurations[category] ?? 0) +
          (task.status == TaskStatus.completed ? minutes : 0);

      final hour = task.startAt.hour;
      final bucket = hour ~/ 2;
      hourWindowScore[bucket] = (hourWindowScore[bucket] ?? 0) +
          (task.status == TaskStatus.completed ? minutes : 0);

      if (task.status == TaskStatus.missed) {
        missedSlotFrequency[hour] = (missedSlotFrequency[hour] ?? 0) + 1;
      }
      if (task.status == TaskStatus.completed) {
        productiveDayScore[task.startAt.weekday] = (productiveDayScore[task.startAt.weekday] ?? 0) + minutes;
      }
    }

    final topWindow = hourWindowScore.entries.isEmpty
        ? 'N/A'
        : _windowLabel(hourWindowScore.entries.reduce((a, b) => a.value >= b.value ? a : b).key);
    final topMissed = missedSlotFrequency.entries.isEmpty
        ? 'N/A'
        : '${missedSlotFrequency.entries.reduce((a, b) => a.value >= b.value ? a : b).key}:00';
    final mostProductiveDay = productiveDayScore.entries.isEmpty
        ? 1
        : productiveDayScore.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

    final categoryWise = <String, double>{};
    categoryDurations.forEach((key, value) {
      categoryWise[key] = totalCompletedMinutes == 0 ? 0 : value / totalCompletedMinutes;
    });

    final focusMinutes = await _focusedMinutesForWeek(weekStart);

    await _isar.writeTxn(() async {
      final cache = WeeklySummaryCache()
        ..weekStartDate = weekStart
        ..completionRate = completionRatio
        ..totalFocusedMinutes = focusMinutes
        ..missedCount = missedCount
        ..mostProductiveDay = mostProductiveDay
        ..totalScheduledMinutes = totalScheduledMinutes
        ..totalCompletedMinutes = totalCompletedMinutes
        ..categoryWiseProductivityJson = _encodeCategoryProductivity(categoryWise)
        ..mostProductive2HourWindow = topWindow
        ..mostMissedTimeSlot = topMissed
        ..updatedAt = DateTime.now();
      await _isar.weeklySummaryCaches.put(cache);
    });

    return WeeklyProductivity(
      totalScheduledMinutes: totalScheduledMinutes,
      totalCompletedMinutes: totalCompletedMinutes,
      completionRatio: completionRatio,
      categoryWiseProductivity: categoryWise,
      mostProductive2HourWindow: topWindow,
      mostFrequentMissedTimeSlot: topMissed,
      missedCount: missedCount,
    );
  }

  @override
  Future<BehavioralInsights> getBehavioralInsights(DateTime weekAnchor) async {
    final weekStart = _startOfWeek(weekAnchor).subtract(const Duration(days: 21));
    final tasks = await _isar.taskModels
        .filter()
        .startAtGreaterThan(weekStart.subtract(const Duration(milliseconds: 1)))
        .findAll();

    final missesBySlot = <String, int>{};
    final rescheduledTitles = <String, int>{};

    for (final task in tasks) {
      if (task.status == TaskStatus.missed) {
        final key = '${DateFormat.E().format(task.startAt)} ${task.startAt.hour}:00';
        missesBySlot[key] = (missesBySlot[key] ?? 0) + 1;
      }
      if (task.manuallyRescheduled) {
        rescheduledTitles[task.title] = (rescheduledTitles[task.title] ?? 0) + 1;
      }
    }

    final recurringMissPatterns = missesBySlot.entries
        .where((entry) => entry.value >= 2)
        .map((entry) => '${entry.key} (${entry.value}x)')
        .toList();
    final frequentlyRescheduled = rescheduledTitles.entries
        .where((entry) => entry.value >= 2)
        .map((entry) => '${entry.key} (${entry.value}x)')
        .toList();

    final suggestedWindow = recurringMissPatterns.isEmpty
        ? 'Keep current scheduling pattern.'
        : 'Shift repeated misses by +60 minutes for one week.';

    return BehavioralInsights(
      recurringMissPatterns: recurringMissPatterns,
      frequentlyRescheduled: frequentlyRescheduled,
      suggestedWindow: suggestedWindow,
    );
  }

  @override
  Future<void> startFocusSession({int? taskId, bool deepFocus = false}) async {
    await _isar.writeTxn(() async {
      final session = FocusSessionModel()
        ..startedAt = DateTime.now()
        ..taskInstanceId = taskId
        ..deepFocus = deepFocus;
      await _isar.focusSessionModels.put(session);
    });
  }

  @override
  Future<int> stopFocusSession() async {
    final active = await _isar.focusSessionModels
        .filter()
        .endedAtIsNull()
        .sortByStartedAtDesc()
        .findFirst();
    if (active == null) return 0;
    final end = DateTime.now();
    final minutes = end.difference(active.startedAt).inMinutes;
    await _isar.writeTxn(() async {
      active
        ..endedAt = end
        ..uninterruptedMinutes = minutes;
      await _isar.focusSessionModels.put(active);
    });
    return minutes;
  }

  @override
  Future<String?> exportBackup() => _backupService.exportNow();

  @override
  Future<void> restoreBackup(String path) => _backupService.restoreFromFile(path);

  @override
  Future<void> autoBackupIfDue() => _backupService.autoBackupIfDue();

  @override
  Future<AppSettingsModel> initializeForLaunch() async {
    final settings = await getAppSettings();
    await syncLifecycleStates(DateTime.now());
    await _autoCarryForwardMissedTasksIfNeeded(settings);
    await _reschedulePendingNotifications(settings);
    return settings;
  }

  @override
  Future<AppSettingsModel> getAppSettings() async {
    final existing = await _isar.appSettingsModels.where().idEqualTo(1).findFirst();
    if (existing != null) return existing;

    final defaults = AppSettingsModel();
    await _isar.writeTxn(() async {
      await _isar.appSettingsModels.put(defaults);
    });
    return defaults;
  }

  @override
  Future<void> saveAppSettings(AppSettingsModel settings) async {
    settings.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.appSettingsModels.put(settings);
    });

    if (_notifications != null) {
      if (settings.dailySummaryEnabled) {
        await _notifications.scheduleDailySummary(
          hour: settings.dailySummaryHour,
          minute: settings.dailySummaryMinute,
          body: 'Open Remember Me and review your progress for today.',
        );
      } else {
        await _notifications.cancelDailySummary();
      }
    }
    await _reschedulePendingNotifications(settings);
  }

  @override
  Future<TaskDraftModel?> getTaskDraft() {
    return _isar.taskDraftModels.where().idEqualTo(1).findFirst();
  }

  @override
  Future<void> saveTaskDraft(TaskDraftModel draft) async {
    draft
      ..id = 1
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.taskDraftModels.put(draft);
    });
  }

  @override
  Future<void> clearTaskDraft() async {
    await _isar.writeTxn(() async {
      await _isar.taskDraftModels.delete(1);
    });
  }

  @override
  Future<BlueprintProfileModel> getBlueprintProfile() async {
    final existing = await _isar.blueprintProfileModels.where().idEqualTo(1).findFirst();
    if (existing != null) return existing;
    final profile = BlueprintProfileModel();
    await _isar.writeTxn(() async {
      await _isar.blueprintProfileModels.put(profile);
    });
    return profile;
  }

  @override
  Future<void> saveBlueprintProfile(BlueprintProfileModel profile) async {
    profile
      ..id = 1
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.blueprintProfileModels.put(profile);
    });
  }

  @override
  Stream<List<FixedActivityBlockModel>> watchFixedBlocksForDay(DateTime day) {
    final weekdayMask = 1 << (day.weekday - 1);
    return _isar.fixedActivityBlockModels.where().watch(fireImmediately: true).map(
      (items) {
        final filtered = items.where((item) => (item.weekdayMask & weekdayMask) != 0).toList()
          ..sort((a, b) => a.startMinuteOfDay.compareTo(b.startMinuteOfDay));
        return filtered;
      },
    );
  }

  @override
  Stream<List<FixedActivityBlockModel>> watchAllFixedBlocks() {
    return _isar.fixedActivityBlockModels.where().watch(fireImmediately: true).map((items) {
      final sorted = items.toList()
        ..sort((a, b) {
          final weekdayA = _firstWeekdayForMask(a.weekdayMask);
          final weekdayB = _firstWeekdayForMask(b.weekdayMask);
          final dayCompare = weekdayA.compareTo(weekdayB);
          if (dayCompare != 0) return dayCompare;
          return a.startMinuteOfDay.compareTo(b.startMinuteOfDay);
        });
      return sorted;
    });
  }

  @override
  Future<void> upsertFixedBlock(FixedActivityBlockModel block) async {
    block.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.fixedActivityBlockModels.put(block);
    });
  }

  @override
  Future<void> deleteFixedBlock(int id) async {
    await _isar.writeTxn(() async {
      await _isar.fixedActivityBlockModels.delete(id);
    });
  }

  @override
  Future<double> getAvailableProductiveHours(DateTime day) async {
    final profile = await getBlueprintProfile();
    final blocks = await watchFixedBlocksForDay(day).first;
    final sleepMinutes = _sleepMinutes(profile);
    final fixedMinutes = blocks.fold<int>(0, (sum, block) {
      return sum + (block.endMinuteOfDay - block.startMinuteOfDay).clamp(0, 24 * 60);
    });
    final raw = (24 * 60) - sleepMinutes - fixedMinutes;
    final withBuffer = (raw * 0.9).round();
    return (withBuffer.clamp(0, 24 * 60)) / 60.0;
  }

  @override
  Future<double> getWeeklyOverloadIndex(DateTime weekAnchor) async {
    final weekStart = _startOfWeek(weekAnchor);
    double totalAvailable = 0;
    int totalScheduledMinutes = 0;
    final weekEnd = weekStart.add(const Duration(days: 7));
    final tasks = await _isar.taskModels
        .filter()
        .startAtGreaterThan(weekStart.subtract(const Duration(milliseconds: 1)))
        .and()
        .startAtLessThan(weekEnd)
        .and()
        .isArchivedEqualTo(false)
        .findAll();
    for (var i = 0; i < 7; i++) {
      totalAvailable += await getAvailableProductiveHours(weekStart.add(Duration(days: i)));
    }
    totalScheduledMinutes = tasks.fold<int>(0, (sum, task) => sum + task.endAt.difference(task.startAt).inMinutes);
    if (totalAvailable <= 0) return 0;
    return (totalScheduledMinutes / 60.0) / totalAvailable;
  }

  @override
  Future<ScheduleCheckResult> checkSchedule(TaskModel task, {bool allowSleepOverride = false}) async {
    final profile = await getBlueprintProfile();
    final day = DateTime(task.startAt.year, task.startAt.month, task.startAt.day);
    final blocks = await watchFixedBlocksForDay(day).first;

    if (!_outsideSleepWindow(task.startAt, task.endAt, profile) && !allowSleepOverride) {
      return const ScheduleCheckResult(
        allowed: false,
        type: ScheduleConflictType.sleepWindow,
        message: 'Task falls in sleep window.',
      );
    }

    final startMinute = task.startAt.hour * 60 + task.startAt.minute;
    final endMinute = task.endAt.hour * 60 + task.endAt.minute;
    for (final block in blocks) {
      final overlap = startMinute < block.endMinuteOfDay && endMinute > block.startMinuteOfDay;
      if (overlap) {
        return ScheduleCheckResult(
          allowed: false,
          type: ScheduleConflictType.fixedBlock,
          message: 'Task overlaps fixed block: ${block.title}.',
        );
      }
    }

    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final existing = await _isar.taskModels
        .filter()
        .startAtGreaterThan(dayStart.subtract(const Duration(milliseconds: 1)))
        .and()
        .startAtLessThan(dayEnd)
        .and()
        .isArchivedEqualTo(false)
        .findAll();
    for (final item in existing.where((element) => element.id != task.id)) {
      final overlap = task.startAt.isBefore(item.endAt) && task.endAt.isAfter(item.startAt);
      if (overlap) {
        return const ScheduleCheckResult(
          allowed: false,
          type: ScheduleConflictType.taskOverlap,
          message: 'Task overlaps another task.',
        );
      }
    }
    return const ScheduleCheckResult(allowed: true);
  }

  Future<void> _upsertCategoryFromTag(TaskModel task) async {
    if (task.tag == null) return;
    final categoryId = await _upsertCategoryFromTagValue(task.tag!);
    task.categoryId = categoryId;
  }

  Future<int> _upsertCategoryFromTagValue(TaskTagModel tag) async {
    final existing = await _isar.categoryModels.filter().nameEqualTo(tag.name).findFirst();
    if (existing != null) return existing.id;

    final category = CategoryModel()
      ..name = tag.name
      ..colorHex = '#${tag.colorValue.toRadixString(16).toUpperCase()}'
      ..iconCodePoint = tag.iconCodePoint;
    return _isar.categoryModels.put(category);
  }

  int _deriveCompletionPercentage(TaskModel task) {
    if (task.checklist.isEmpty) {
      return task.completionPercentage;
    }
    final completed = task.checklist.where((item) => item.isChecked).length;
    return ((completed / task.checklist.length) * 100).round();
  }

  TaskStatus _deriveStatus(TaskModel task, DateTime now) {
    if (task.isArchived) return TaskStatus.archived;
    if (task.completionPercentage >= 100) return TaskStatus.completed;
    if (!now.isBefore(task.startAt) && now.isBefore(task.endAt)) {
      return TaskStatus.inProgress;
    }
    if (now.isAfter(task.endAt) && task.completionPercentage < 100) {
      return TaskStatus.missed;
    }
    return TaskStatus.pending;
  }

  TaskLifecycleStatus _toLifecycle(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return TaskLifecycleStatus.pending;
      case TaskStatus.inProgress:
        return TaskLifecycleStatus.inProgress;
      case TaskStatus.completed:
        return TaskLifecycleStatus.completed;
      case TaskStatus.missed:
        return TaskLifecycleStatus.missed;
      case TaskStatus.archived:
        return TaskLifecycleStatus.archived;
    }
  }

  bool _matchesRecurrence(TaskTemplateModel template, int weekday) {
    switch (template.recurrencePattern) {
      case RecurrencePattern.daily:
        return true;
      case RecurrencePattern.weekly:
      case RecurrencePattern.customWeekdays:
        return (template.weekdayMask & (1 << (weekday - 1))) != 0;
    }
  }

  int _weekdayMaskFromList(List<int> weekdays) {
    var mask = 0;
    for (final day in weekdays) {
      if (day >= 1 && day <= 7) {
        mask |= 1 << (day - 1);
      }
    }
    return mask;
  }

  String _windowLabel(int bucket) {
    final start = bucket * 2;
    final end = start + 2;
    return '${start.toString().padLeft(2, '0')}:00-${end.toString().padLeft(2, '0')}:00';
  }

  String _encodeCategoryProductivity(Map<String, double> value) {
    return value.entries.map((entry) => '${entry.key}:${entry.value}').join('|');
  }

  Map<String, double> _decodeCategoryProductivity(String value) {
    if (value.isEmpty || value == '{}') return {};
    final map = <String, double>{};
    for (final item in value.split('|')) {
      final parts = item.split(':');
      if (parts.length == 2) {
        map[parts[0]] = double.tryParse(parts[1]) ?? 0;
      }
    }
    return map;
  }

  Future<int> _focusedMinutesForWeek(DateTime weekStart) async {
    final weekEnd = weekStart.add(const Duration(days: 7));
    final sessions = await _isar.focusSessionModels
        .filter()
        .startedAtGreaterThan(weekStart.subtract(const Duration(milliseconds: 1)))
        .and()
        .startedAtLessThan(weekEnd)
        .findAll();
    return sessions.fold<int>(0, (sum, session) => sum + session.uninterruptedMinutes);
  }

  DateTime _startOfWeek(DateTime value) {
    final day = DateTime(value.year, value.month, value.day);
    return day.subtract(Duration(days: day.weekday - 1));
  }

  int _sleepMinutes(BlueprintProfileModel profile) {
    final wake = profile.wakeMinuteOfDay;
    final sleep = profile.sleepMinuteOfDay;
    if (sleep == wake) return 8 * 60;
    if (sleep > wake) return sleep - wake;
    return (24 * 60 - wake) + sleep;
  }

  int _firstWeekdayForMask(int mask) {
    for (var i = 0; i < 7; i++) {
      if ((mask & (1 << i)) != 0) return i + 1;
    }
    return 8;
  }

  bool _outsideSleepWindow(DateTime start, DateTime end, BlueprintProfileModel profile) {
    final wake = profile.wakeMinuteOfDay;
    final sleep = profile.sleepMinuteOfDay;
    final s = start.hour * 60 + start.minute;
    final e = end.hour * 60 + end.minute;

    bool inSleepMinute(int minute) {
      if (sleep == wake) return false;
      if (sleep > wake) {
        return minute >= sleep || minute < wake;
      }
      return minute >= sleep && minute < wake;
    }

    for (var minute = s; minute < e; minute += 15) {
      if (inSleepMinute(minute % (24 * 60))) return false;
    }
    return true;
  }

  Future<TaskModel> _applyBuffer(TaskModel task, int bufferMinutes) async {
    if (bufferMinutes <= 0) return task;
    final day = DateTime(task.startAt.year, task.startAt.month, task.startAt.day);
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final existing = await _isar.taskModels
        .filter()
        .startAtGreaterThan(dayStart.subtract(const Duration(milliseconds: 1)))
        .and()
        .startAtLessThan(dayEnd)
        .and()
        .isArchivedEqualTo(false)
        .findAll();
    final sorted = existing.where((item) => item.id != task.id).toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));

    var start = task.startAt;
    var end = task.endAt;
    final duration = end.difference(start);
    for (final item in sorted) {
      final blockedEnd = item.endAt.add(Duration(minutes: bufferMinutes));
      if (!start.isBefore(item.startAt) && start.isBefore(blockedEnd)) {
        start = blockedEnd;
        end = start.add(duration);
      }
    }
    task
      ..startAt = start
      ..endAt = end;
    return task;
  }

  Future<void> _autoCarryForwardMissedTasksIfNeeded(AppSettingsModel settings) async {
    if (!settings.autoCarryForwardEnabled) return;
    final now = DateTime.now();
    final missedTasks = await _isar.taskModels
        .filter()
        .statusEqualTo(TaskStatus.missed)
        .and()
        .isArchivedEqualTo(false)
        .findAll();
    if (missedTasks.isEmpty) return;

    final nextTasks = <TaskModel>[];
    for (final task in missedTasks) {
      if (task.manuallyRescheduled) continue;
      final nextStart = task.startAt.add(const Duration(days: 1));
      if (!nextStart.isAfter(now.subtract(const Duration(minutes: 5)))) {
        continue;
      }

      final exists = await _isar.taskModels
          .filter()
          .titleEqualTo(task.title)
          .and()
          .startAtEqualTo(nextStart)
          .findFirst();
      if (exists != null) continue;

      nextTasks.add(
        TaskModel()
          ..templateId = task.templateId
          ..title = task.title
          ..description = task.description
          ..categoryId = task.categoryId
          ..startAt = nextStart
          ..endAt = nextStart.add(task.endAt.difference(task.startAt))
          ..priority = task.priority
          ..recurrenceRule = task.recurrenceRule
          ..reminderOffsetMinutes = task.reminderOffsetMinutes
          ..tag = task.tag
          ..manuallyRescheduled = true
          ..checklist = task.checklist
              .map((item) => ChecklistItemModel(text: item.text, isChecked: false))
              .toList(),
      );
    }

    if (nextTasks.isEmpty) return;
    await _isar.writeTxn(() async {
      await _isar.taskModels.putAll(nextTasks);
    });
  }

  Future<void> _reschedulePendingNotifications(AppSettingsModel settings) async {
    if (_notifications == null) return;
    final now = DateTime.now();
    final tasks = await _isar.taskModels.where().findAll();
    for (final task in tasks) {
      final shouldNotify = settings.remindersEnabled &&
          !task.isArchived &&
          task.status != TaskStatus.completed &&
          task.startAt.isAfter(now) &&
          task.reminderOffsetMinutes != -1;
      if (shouldNotify) {
        await _notifications.scheduleTaskNudge(task, offsetMinutes: _effectiveReminderOffset(task));
      } else {
        await _notifications.cancelTaskReminder(task.id);
      }
    }

    if (settings.dailySummaryEnabled) {
      await _notifications.scheduleDailySummary(
        hour: settings.dailySummaryHour,
        minute: settings.dailySummaryMinute,
        body: 'Open Remember Me and review your progress for today.',
      );
    } else {
      await _notifications.cancelDailySummary();
    }
  }

  Future<void> _trySendDailySummary(DateTime now, AppSettingsModel settings) async {
    if (_notifications == null || !settings.dailySummaryEnabled) return;

    final lastSent = settings.lastDailySummarySentAt;
    final alreadySentToday = lastSent != null &&
        lastSent.year == now.year &&
        lastSent.month == now.month &&
        lastSent.day == now.day;
    final summaryTime = DateTime(now.year, now.month, now.day, settings.dailySummaryHour, settings.dailySummaryMinute);

    if (alreadySentToday || now.isBefore(summaryTime)) return;

    final dayStart = DateTime(now.year, now.month, now.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final tasks = await _isar.taskModels
        .filter()
        .startAtGreaterThan(dayStart.subtract(const Duration(milliseconds: 1)))
        .and()
        .startAtLessThan(dayEnd)
        .and()
        .isArchivedEqualTo(false)
        .findAll();
    final total = tasks.length;
    final completed = tasks.where((task) => task.status == TaskStatus.completed).length;

    await _notifications.scheduleDailySummary(
      hour: settings.dailySummaryHour,
      minute: settings.dailySummaryMinute,
      body: 'You completed $completed/$total tasks today. Keep the streak going 🔥',
    );

    settings.lastDailySummarySentAt = now;
    await saveAppSettings(settings);
  }

  int _effectiveReminderOffset(TaskModel task) {
    if (task.reminderOffsetMinutes != -2) return task.reminderOffsetMinutes;
    final duration = task.endAt.difference(task.startAt).inMinutes;
    var base = switch ((task.categoryId ?? 1).clamp(0, 2)) {
      2 => 30,
      1 => 15,
      _ => 10,
    };
    if (duration >= 120) {
      base += 10;
    } else if (duration >= 90) {
      base += 5;
    }
    return base.clamp(0, 60);
  }
}
