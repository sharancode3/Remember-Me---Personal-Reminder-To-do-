import 'package:isar/isar.dart';

part 'advanced_models.g.dart';

enum RecurrencePattern {
  daily,
  weekly,
  customWeekdays,
}

enum BlueprintMode {
  normal,
  exam,
  light,
}

enum FixedActivityType {
  college,
  work,
  gym,
  commute,
  custom,
}

enum TaskLifecycleStatus {
  pending,
  inProgress,
  completed,
  missed,
  archived,
}

@collection
class TaskTemplateModel {
  Id id = Isar.autoIncrement;

  late String title;
  String description = '';

  @Index()
  int? categoryId;

  late int startTime;
  late int endTime;

  @enumerated
  RecurrencePattern recurrencePattern = RecurrencePattern.weekly;

  late int weekdayMask;
  bool isStaticRoutine = false;
  int defaultReminderOffsetMinutes = 10;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}

@collection
class TaskInstanceModel {
  Id id = Isar.autoIncrement;

  @Index()
  int? templateId;

  @Index()
  late DateTime date;

  late int startTime;
  late int endTime;
  late String title;
  String description = '';

  @Index()
  int? categoryId;

  @enumerated
  TaskLifecycleStatus status = TaskLifecycleStatus.pending;

  int completionPercentage = 0;
  bool manuallyRescheduled = false;
  bool isArchived = false;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}

@collection
class ChecklistItem {
  Id id = Isar.autoIncrement;

  @Index()
  late int taskInstanceId;

  late String title;
  bool isCompleted = false;
}

@collection
class CategoryModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String name;

  late String colorHex;
  late int iconCodePoint;
}

@collection
class WeeklySummaryCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime weekStartDate;

  late double completionRate;
  late int totalFocusedMinutes;
  late int missedCount;
  late int mostProductiveDay;

  int totalScheduledMinutes = 0;
  int totalCompletedMinutes = 0;
  String categoryWiseProductivityJson = '{}';
  String mostProductive2HourWindow = 'N/A';
  String mostMissedTimeSlot = 'N/A';
  DateTime updatedAt = DateTime.now();
}

@collection
class FocusSessionModel {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime startedAt;

  DateTime? endedAt;
  int? taskInstanceId;
  bool deepFocus = false;
  int uninterruptedMinutes = 0;
}

@collection
class AppSettingsModel {
  Id id = 1;

  bool remindersEnabled = true;
  int defaultReminderOffsetMinutes = 10;
  bool dailySummaryEnabled = true;
  int dailySummaryHour = 21;
  int dailySummaryMinute = 0;
  bool overdueAlertsEnabled = true;
  bool autoCarryForwardEnabled = true;
  bool allowSleepOverride = false;
  int bufferMinutes = 5;
  bool showRealismLegend = true;
  DateTime? lastDailySummarySentAt;
  DateTime updatedAt = DateTime.now();
}

@collection
class TaskDraftModel {
  Id id = 1;

  String title = '';
  String checklistCsv = '';
  int startMinuteOfDay = 9 * 60;
  int endMinuteOfDay = 10 * 60;
  int selectedTag = 0;
  int selectedEnergy = 1;
  int selectedPriority = 1;
  int reminderOffsetMinutes = 10;
  DateTime updatedAt = DateTime.now();
}

@collection
class BlueprintProfileModel {
  Id id = 1;

  int wakeMinuteOfDay = 7 * 60;
  int sleepMinuteOfDay = 23 * 60;
  @enumerated
  BlueprintMode mode = BlueprintMode.normal;
  DateTime updatedAt = DateTime.now();
}

@collection
class FixedActivityBlockModel {
  Id id = Isar.autoIncrement;

  late String title;
  late int startMinuteOfDay;
  late int endMinuteOfDay;
  int weekdayMask = 0;
  @enumerated
  FixedActivityType type = FixedActivityType.custom;
  int colorValue = 0xFF4F8CFF;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}
