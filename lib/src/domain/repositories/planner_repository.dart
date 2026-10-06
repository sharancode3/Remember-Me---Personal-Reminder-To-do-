import '../../data/models/routine_template_model.dart';
import '../../data/models/task_model.dart';
import '../../data/models/advanced_models.dart';
import '../entities/weekly_productivity.dart';
import '../entities/weekly_log_stats.dart';

enum ScheduleConflictType {
  sleepWindow,
 fixedBlock,
 taskOverlap,
}

class ScheduleCheckResult {
  const ScheduleCheckResult({this.allowed = true, this.type, this.message});

  final bool allowed;
  final ScheduleConflictType? type;
  final String? message;
}

abstract class PlannerRepository {
  Stream<List<TaskModel>> watchTasksForDay(DateTime day);
  Stream<List<TaskModel>> watchCurrentInProgress(DateTime day);
  Future<List<TaskModel>> getOverflowForDay(DateTime day);
  Future<void> upsertTask(TaskModel task);
  Future<void> upsertTasks(List<TaskModel> tasks);
  Future<TaskModel?> getTaskById(int id);
  Future<List<TaskModel>> getTasksInRange(DateTime startInclusive, DateTime endExclusive);
  Future<void> updateTaskChecklist(TaskModel task, int itemIndex, bool value);
  Future<void> saveRoutineTemplate(RoutineTemplateModel template);
  Future<void> generateWeekFromTemplates(DateTime weekAnchor);
  Future<WeeklyLogStats> getWeeklyStats(DateTime weekAnchor);
  Future<Map<DateTime, double>> getWeekDayCompletion(DateTime weekAnchor);
  Future<Map<DateTime, double>> getMonthDayCompletion(DateTime monthAnchor);
  Future<void> archiveTask(TaskModel task);
  Future<void> syncLifecycleStates(DateTime now);
  Future<void> quickCompleteTask(TaskModel task);
  Future<void> rescheduleOverflowTask(TaskModel sourceTask, DateTime targetDate, int startMinuteOfDay);
  Future<WeeklyProductivity> getWeeklyProductivity(DateTime weekAnchor, {bool useCache = true});
  Future<BehavioralInsights> getBehavioralInsights(DateTime weekAnchor);
  Future<void> startFocusSession({int? taskId, bool deepFocus = false});
  Future<int> stopFocusSession();
  Future<String?> exportBackup();
  Future<void> restoreBackup(String path);
  Future<void> autoBackupIfDue();
  Future<AppSettingsModel> initializeForLaunch();
  Future<AppSettingsModel> getAppSettings();
  Future<void> saveAppSettings(AppSettingsModel settings);
  Future<TaskDraftModel?> getTaskDraft();
  Future<void> saveTaskDraft(TaskDraftModel draft);
  Future<void> clearTaskDraft();
  Future<BlueprintProfileModel> getBlueprintProfile();
  Future<void> saveBlueprintProfile(BlueprintProfileModel profile);
  Stream<List<FixedActivityBlockModel>> watchFixedBlocksForDay(DateTime day);
  Stream<List<FixedActivityBlockModel>> watchAllFixedBlocks();
  Future<void> upsertFixedBlock(FixedActivityBlockModel block);
  Future<void> deleteFixedBlock(int id);
  Future<double> getAvailableProductiveHours(DateTime day);
  Future<double> getWeeklyOverloadIndex(DateTime weekAnchor);
  Future<ScheduleCheckResult> checkSchedule(TaskModel task, {bool allowSleepOverride = false});
}
