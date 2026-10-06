import 'dart:async';

import '../../domain/entities/weekly_productivity.dart';
import '../../domain/entities/weekly_log_stats.dart';
import '../../domain/repositories/planner_repository.dart';
import '../models/advanced_models.dart';
import '../models/routine_template_model.dart';
import '../models/task_model.dart';

class InMemoryPlannerRepository implements PlannerRepository {
  final List<TaskModel> _tasks = [];
  final List<RoutineTemplateModel> _templates = [];
  final StreamController<void> _updates = StreamController<void>.broadcast();
  int _nextId = 1;
  AppSettingsModel _settings = AppSettingsModel();
  TaskDraftModel? _draft;
  BlueprintProfileModel _blueprint = BlueprintProfileModel();
  final List<FixedActivityBlockModel> _fixedBlocks = [];

  @override
  Stream<List<TaskModel>> watchTasksForDay(DateTime day) async* {
    await syncLifecycleStates(DateTime.now());
    yield _tasksForDay(day);
    yield* _updates.stream.map((_) => _tasksForDay(day));
  }

  @override
  Stream<List<TaskModel>> watchCurrentInProgress(DateTime day) async* {
    await syncLifecycleStates(DateTime.now());
    yield _inProgressForDay(day);
    yield* _updates.stream.map((_) => _inProgressForDay(day));
  }

  @override
  Future<List<TaskModel>> getOverflowForDay(DateTime day) async {
    final target = DateTime(day.year, day.month, day.day);
    final yesterdayStart = target.subtract(const Duration(days: 1));
    final yesterdayEnd = target;
    await syncLifecycleStates(DateTime.now());
    return _tasks
        .where((task) =>
        task.status == TaskStatus.missed &&
        !task.isArchived &&
            !task.startAt.isBefore(yesterdayStart) &&
            task.startAt.isBefore(yesterdayEnd))
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
  }

  @override
  Future<void> upsertTask(TaskModel task) async {
    task.completionPercentage = _deriveCompletion(task);
    task.status = _deriveStatus(task, DateTime.now());
    task.updatedAt = DateTime.now();
    if (task.id == 0) {
      task.id = _nextId++;
      _tasks.add(task);
    } else {
      final index = _tasks.indexWhere((existing) => existing.id == task.id);
      if (index >= 0) {
        _tasks[index] = task;
      } else {
        _tasks.add(task);
      }
    }
    _updates.add(null);
  }

  @override
  Future<void> upsertTasks(List<TaskModel> tasks) async {
    for (final task in tasks) {
      await upsertTask(task);
    }
  }

  @override
  Future<TaskModel?> getTaskById(int id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    return index < 0 ? null : _tasks[index];
  }

  @override
  Future<List<TaskModel>> getTasksInRange(DateTime startInclusive, DateTime endExclusive) async {
    return _tasks
        .where((task) =>
            !task.isArchived &&
            !task.startAt.isBefore(startInclusive) &&
            task.startAt.isBefore(endExclusive))
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
  }

  @override
  Future<void> updateTaskChecklist(TaskModel task, int itemIndex, bool value) async {
    if (itemIndex < 0 || itemIndex >= task.checklist.length) return;
    task.checklist[itemIndex].isChecked = value;
    task.completionPercentage = _deriveCompletion(task);
    task.status = _deriveStatus(task, DateTime.now());
    await upsertTask(task);
  }

  @override
  Future<void> saveRoutineTemplate(RoutineTemplateModel template) async {
    if (template.id == 0) {
      template.id = _templates.length + 1;
      _templates.add(template);
    } else {
      final index = _templates.indexWhere((item) => item.id == template.id);
      if (index >= 0) {
        _templates[index] = template;
      } else {
        _templates.add(template);
      }
    }
    _updates.add(null);
  }

  @override
  Future<void> generateWeekFromTemplates(DateTime weekAnchor) async {
    final weekStart = _startOfWeek(weekAnchor);
    for (var index = 0; index < 7; index++) {
      final day = weekStart.add(Duration(days: index));
      final weekday = day.weekday;

      for (final template
          in _templates.where((template) => template.isActive && template.weekdays.contains(weekday))) {
        final start = DateTime(day.year, day.month, day.day)
            .add(Duration(minutes: template.startMinuteOfDay));
        final end = DateTime(day.year, day.month, day.day)
            .add(Duration(minutes: template.endMinuteOfDay));
        final exists = _tasks.any((task) => task.title == template.title && task.startAt == start);
        if (exists) continue;

        final task = TaskModel()
          ..id = _nextId++
          ..title = template.title
          ..startAt = start
          ..endAt = end
          ..tag = template.tag
          ..checklist = template.checklistBlueprint
              .map((label) => ChecklistItemModel(text: label, isChecked: false))
              .toList();
        _tasks.add(task);
      }
    }
    _updates.add(null);
  }

  @override
  Future<WeeklyLogStats> getWeeklyStats(DateTime weekAnchor) async {
    await syncLifecycleStates(DateTime.now());
    final weekStart = _startOfWeek(weekAnchor);
    final weekEnd = weekStart.add(const Duration(days: 7));
    final weekly = _tasks
        .where((task) =>
            !task.isArchived &&
            !task.startAt.isBefore(weekStart) &&
            task.startAt.isBefore(weekEnd))
        .toList();
    final completed = weekly.where((task) => task.status == TaskStatus.completed).length;
    return WeeklyLogStats(
      total: weekly.length,
      completed: completed,
      pending: weekly.length - completed,
    );
  }

  @override
  Future<Map<DateTime, double>> getWeekDayCompletion(DateTime weekAnchor) async {
    final weekStart = _startOfWeek(weekAnchor);
    final map = <DateTime, double>{};
    for (var i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      final dayTasks = _tasks
          .where((task) =>
              !task.isArchived &&
              !task.startAt.isBefore(dayStart) &&
              task.startAt.isBefore(dayEnd))
          .toList();
      if (dayTasks.isEmpty) {
        map[dayStart] = 0;
      } else {
        final done = dayTasks.where((task) => task.status == TaskStatus.completed).length;
        map[dayStart] = done / dayTasks.length;
      }
    }
    return map;
  }

  @override
  Future<Map<DateTime, double>> getMonthDayCompletion(DateTime monthAnchor) async {
    final map = <DateTime, double>{};
    final totalDays = DateTime(monthAnchor.year, monthAnchor.month + 1, 0).day;
    for (var day = 1; day <= totalDays; day++) {
      final dayStart = DateTime(monthAnchor.year, monthAnchor.month, day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      final dayTasks = _tasks.where((task) {
        return !task.isArchived && !task.startAt.isBefore(dayStart) && task.startAt.isBefore(dayEnd);
      }).toList();
      if (dayTasks.isEmpty) {
        map[dayStart] = 0;
      } else {
        final done = dayTasks.where((task) => task.status == TaskStatus.completed).length;
        map[dayStart] = done / dayTasks.length;
      }
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
  }

  @override
  Future<void> syncLifecycleStates(DateTime now) async {
    for (final task in _tasks) {
      task.completionPercentage = _deriveCompletion(task);
      task.status = _deriveStatus(task, now);
    }
    _updates.add(null);
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
  }

  @override
  Future<void> rescheduleOverflowTask(TaskModel sourceTask, DateTime targetDate, int startMinuteOfDay) async {
    final duration = sourceTask.endAt.difference(sourceTask.startAt).inMinutes;
    final next = TaskModel()
      ..id = _nextId++
      ..templateId = sourceTask.templateId
      ..title = sourceTask.title
      ..description = sourceTask.description
      ..categoryId = sourceTask.categoryId
      ..startAt = DateTime(targetDate.year, targetDate.month, targetDate.day)
          .add(Duration(minutes: startMinuteOfDay))
      ..endAt = DateTime(targetDate.year, targetDate.month, targetDate.day)
          .add(Duration(minutes: startMinuteOfDay + duration))
      ..tag = sourceTask.tag
      ..manuallyRescheduled = true
      ..checklist = sourceTask.checklist
          .map((item) => ChecklistItemModel(text: item.text, isChecked: false))
          .toList();
    _tasks.add(next);
    _updates.add(null);
  }

  @override
  Future<WeeklyProductivity> getWeeklyProductivity(DateTime weekAnchor, {bool useCache = true}) async {
    final weekStart = _startOfWeek(weekAnchor);
    final weekEnd = weekStart.add(const Duration(days: 7));
    final weekly = _tasks.where((task) {
      return !task.isArchived && !task.startAt.isBefore(weekStart) && task.startAt.isBefore(weekEnd);
    }).toList();

    final totalScheduled = weekly.fold<int>(0, (sum, task) => sum + task.endAt.difference(task.startAt).inMinutes);
    final totalCompleted = weekly
        .where((task) => task.status == TaskStatus.completed)
        .fold<int>(0, (sum, task) => sum + task.endAt.difference(task.startAt).inMinutes);
    final ratio = totalScheduled == 0 ? 0.0 : totalCompleted / totalScheduled;

    return WeeklyProductivity(
      totalScheduledMinutes: totalScheduled,
      totalCompletedMinutes: totalCompleted,
      completionRatio: ratio,
      categoryWiseProductivity: const {},
      mostProductive2HourWindow: 'N/A',
      mostFrequentMissedTimeSlot: 'N/A',
      missedCount: weekly.where((task) => task.status == TaskStatus.missed).length,
    );
  }

  @override
  Future<BehavioralInsights> getBehavioralInsights(DateTime weekAnchor) async {
    final misses = _tasks.where((task) => task.status == TaskStatus.missed).length;
    final rescheduled = _tasks.where((task) => task.manuallyRescheduled).length;
    return BehavioralInsights(
      recurringMissPatterns: misses == 0 ? [] : ['Detected $misses recent missed blocks'],
      frequentlyRescheduled: rescheduled == 0 ? [] : ['Detected $rescheduled recent reschedules'],
      suggestedWindow: misses > 0 ? 'Try shifting tasks by +60 minutes.' : 'Current schedule looks stable.',
    );
  }

  @override
  Future<void> startFocusSession({int? taskId, bool deepFocus = false}) async {}

  @override
  Future<int> stopFocusSession() async => 0;

  @override
  Future<String?> exportBackup() async => null;

  @override
  Future<void> restoreBackup(String path) async {}

  @override
  Future<void> autoBackupIfDue() async {}

  @override
  Future<AppSettingsModel> initializeForLaunch() async => _settings;

  @override
  Future<AppSettingsModel> getAppSettings() async => _settings;

  @override
  Future<void> saveAppSettings(AppSettingsModel settings) async {
    _settings = settings;
  }

  @override
  Future<TaskDraftModel?> getTaskDraft() async => _draft;

  @override
  Future<void> saveTaskDraft(TaskDraftModel draft) async {
    _draft = draft;
  }

  @override
  Future<void> clearTaskDraft() async {
    _draft = null;
  }

  @override
  Future<BlueprintProfileModel> getBlueprintProfile() async => _blueprint;

  @override
  Future<void> saveBlueprintProfile(BlueprintProfileModel profile) async {
    _blueprint = profile;
  }

  @override
  Stream<List<FixedActivityBlockModel>> watchFixedBlocksForDay(DateTime day) async* {
    final mask = 1 << (day.weekday - 1);
    yield _fixedBlocks.where((item) => (item.weekdayMask & mask) != 0).toList()
      ..sort((a, b) => a.startMinuteOfDay.compareTo(b.startMinuteOfDay));
    yield* _updates.stream.map((_) {
      return _fixedBlocks.where((item) => (item.weekdayMask & mask) != 0).toList()
        ..sort((a, b) => a.startMinuteOfDay.compareTo(b.startMinuteOfDay));
    });
  }

  @override
  Stream<List<FixedActivityBlockModel>> watchAllFixedBlocks() async* {
    yield [..._fixedBlocks]..sort((a, b) => a.startMinuteOfDay.compareTo(b.startMinuteOfDay));
    yield* _updates.stream.map((_) {
      return [..._fixedBlocks]..sort((a, b) => a.startMinuteOfDay.compareTo(b.startMinuteOfDay));
    });
  }

  @override
  Future<void> upsertFixedBlock(FixedActivityBlockModel block) async {
    if (block.id == 0) {
      block.id = _fixedBlocks.length + 1;
      _fixedBlocks.add(block);
    } else {
      final index = _fixedBlocks.indexWhere((item) => item.id == block.id);
      if (index >= 0) {
        _fixedBlocks[index] = block;
      } else {
        _fixedBlocks.add(block);
      }
    }
    _updates.add(null);
  }

  @override
  Future<void> deleteFixedBlock(int id) async {
    _fixedBlocks.removeWhere((item) => item.id == id);
    _updates.add(null);
  }

  @override
  Future<double> getAvailableProductiveHours(DateTime day) async {
    final wake = _blueprint.wakeMinuteOfDay;
    final sleep = _blueprint.sleepMinuteOfDay;
    final sleepMinutes = sleep > wake ? (24 * 60 - sleep) + wake : wake - sleep;
    final mask = 1 << (day.weekday - 1);
    final fixedMinutes = _fixedBlocks
        .where((item) => (item.weekdayMask & mask) != 0)
        .fold<int>(0, (sum, item) => sum + (item.endMinuteOfDay - item.startMinuteOfDay));
    return (((24 * 60) - sleepMinutes - fixedMinutes) * 0.9).clamp(0, 24 * 60) / 60.0;
  }

  @override
  Future<double> getWeeklyOverloadIndex(DateTime weekAnchor) async {
    final start = _startOfWeek(weekAnchor);
    var available = 0.0;
    for (var i = 0; i < 7; i++) {
      available += await getAvailableProductiveHours(start.add(Duration(days: i)));
    }
    final end = start.add(const Duration(days: 7));
    final scheduledMinutes = _tasks
        .where((task) => !task.startAt.isBefore(start) && task.startAt.isBefore(end))
        .fold<int>(0, (sum, task) => sum + task.endAt.difference(task.startAt).inMinutes);
    if (available <= 0) return 0;
    return (scheduledMinutes / 60) / available;
  }

  @override
  Future<ScheduleCheckResult> checkSchedule(TaskModel task, {bool allowSleepOverride = false}) async {
    return const ScheduleCheckResult(allowed: true);
  }

  List<TaskModel> _tasksForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return _tasks
        .where((task) =>
            !task.isArchived &&
            !task.startAt.isBefore(start) &&
            task.startAt.isBefore(end))
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
  }

  List<TaskModel> _inProgressForDay(DateTime day) {
    final forDay = _tasksForDay(day);
    final now = DateTime.now();
    return forDay.where((task) => !task.isArchived && now.isAfter(task.startAt) && now.isBefore(task.endAt)).toList();
  }

  int _deriveCompletion(TaskModel task) {
    if (task.checklist.isEmpty) {
      return task.completionPercentage;
    }
    final checked = task.checklist.where((item) => item.isChecked).length;
    return ((checked / task.checklist.length) * 100).round();
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

  DateTime _startOfWeek(DateTime value) {
    final day = DateTime(value.year, value.month, value.day);
    return day.subtract(Duration(days: day.weekday - 1));
  }
}
