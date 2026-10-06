import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/isar_service.dart';
import '../../domain/entities/weekly_productivity.dart';
import '../../data/models/advanced_models.dart';
import '../../data/models/journey_record_model.dart';
import '../../data/models/routine_template_model.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/journey_history_repository.dart';
import '../../data/repositories/planner_repository_impl.dart';
import '../../domain/entities/weekly_log_stats.dart';
import '../../domain/repositories/planner_repository.dart';
import '../../domain/repositories/provider_abstractions.dart';
import '../../services/context_engine.dart';
import '../../services/geocoding_routing_services.dart';
import '../../services/local_movement_journey_service.dart';
import '../../services/local_notification_service.dart';
import '../../services/four_engines_architecture.dart';
import '../../services/master_adaptive_day_orchestrator.dart';
import '../../services/observation_store.dart';
import '../../services/open_meteo_weather_service.dart';
import '../../services/personal_planning_profile.dart';
import '../../services/personal_prediction_engine.dart';
import '../../services/master_journey_engine.dart';
import '../../services/project_simulation_engine.dart';
import '../../services/unified_notification_engine.dart';
import '../../services/backup_service.dart';

final isarServiceProvider = Provider<IsarService>((ref) {
  throw UnimplementedError('Overridden during bootstrap');
});

final localNotificationServiceProvider = Provider<LocalNotificationService>((ref) {
  throw UnimplementedError('Overridden during bootstrap');
});

final plannerRepositoryProvider = Provider<PlannerRepository>((ref) {
  final isarService = ref.watch(isarServiceProvider);
  final notifications = ref.watch(localNotificationServiceProvider);
  return PlannerRepositoryImpl(isarService, notifications: notifications);
});

final observationStoreProvider = Provider<ObservationStore>((ref) {
  return ObservationStore();
});

final backupServiceProvider = Provider<BackupService>((ref) {
  final isar = ref.watch(isarServiceProvider);
  return BackupService(isar);
});

final profileSynthesizerProvider = Provider<ProfileSynthesizer>((ref) {
  return ProfileSynthesizer();
});

final personalPlanningProfileProvider = Provider<PersonalPlanningProfile>((ref) {
  final store = ref.watch(observationStoreProvider);
  final synthesizer = ref.watch(profileSynthesizerProvider);
  return synthesizer.synthesizeProfile(store.allObservations);
});

final inputEngineProvider = Provider<InputEngine>((ref) {
  return InputEngine();
});

final personalPredictionEngineProvider = Provider<PersonalPredictionEngine>((ref) {
  return PersonalPredictionEngine();
});

final adaptivePlanningEngineProvider = Provider<AdaptivePlanningEngine>((ref) {
  final predictor = ref.watch(personalPredictionEngineProvider);
  return AdaptivePlanningEngine(predictionEngine: predictor);
});

final masterAdaptiveDayOrchestratorProvider = Provider<MasterAdaptiveDayOrchestrator>((ref) {
  final predictor = ref.watch(personalPredictionEngineProvider);
  final profile = ref.watch(personalPlanningProfileProvider);
  return MasterAdaptiveDayOrchestrator(predictionEngine: predictor, profile: profile);
});

final projectSimulationEngineProvider = Provider<ProjectSimulationEngine>((ref) {
  final orchestrator = ref.watch(masterAdaptiveDayOrchestratorProvider);
  final profile = ref.watch(personalPlanningProfileProvider);
  return ProjectSimulationEngine(orchestrator: orchestrator, profile: profile);
});

final unifiedNotificationEngineProvider = Provider<UnifiedNotificationEngine>((ref) {
  final obsStore = ref.watch(observationStoreProvider);
  return UnifiedNotificationEngine(observationStore: obsStore);
});

final weatherServiceProvider = Provider<WeatherProvider>((ref) {
  return OpenMeteoWeatherService();
});

final journeyHistoryRepositoryProvider = Provider<JourneyHistoryRepository>((ref) {
  try {
    final isar = ref.watch(isarServiceProvider);
    return JourneyHistoryRepositoryImpl(isar);
  } catch (_) {
    return JourneyHistoryRepositoryImpl(null);
  }
});

final journeysListStreamProvider = StreamProvider<List<JourneyRecord>>((ref) {
  final repo = ref.watch(journeyHistoryRepositoryProvider);
  return repo.watchAllJourneys();
});

final journeyServiceProvider = Provider<MasterJourneyEngine>((ref) {
  final obsStore = ref.watch(observationStoreProvider);
  final historyRepo = ref.watch(journeyHistoryRepositoryProvider);
  return MasterJourneyEngine(observationStore: obsStore, historyRepository: historyRepo);
});

final geocodingServiceProvider = Provider<GeocodingProvider>((ref) {
  return NominatimGeocodingService();
});

final routingServiceProvider = Provider<RoutingProvider>((ref) {
  return OsrmRoutingService();
});

class MockHealthService implements HealthProvider {
  @override
  Future<int> getTodayStepCount() async => 7640;

  @override
  Stream<int> watchStepUpdates() => Stream.value(7640);
}

class MockLocationService implements LocationProvider {
  @override
  Future<LocationSnapshot?> getCurrentLocation() async => LocationSnapshot(
        latitude: 12.9716,
        longitude: 77.5946,
        timestamp: DateTime.now(),
      );

  @override
  Stream<LocationSnapshot> watchLocationUpdates({bool isStationary = false}) => Stream.value(
        LocationSnapshot(
          latitude: 12.9716,
          longitude: 77.5946,
          timestamp: DateTime.now(),
        ),
      );
}

final contextEngineProvider = Provider<ContextEngine>((ref) {
  final weather = ref.watch(weatherServiceProvider);
  return ContextEngine(
    weatherProvider: weather,
    locationProvider: MockLocationService(),
    healthProvider: MockHealthService(),
  );
});

final activePlanningSignalsProvider = FutureProvider<List<PlanningSignal>>((ref) async {
  final engine = ref.watch(contextEngineProvider);
  return engine.evaluateSignals(
    availableFreeMinutesToday: 180,
    isFocusActive: false,
    activeTaskId: null,
  );
});

final todayWeatherForecastProvider = FutureProvider<WeatherContext?>((ref) async {
  final weatherService = ref.watch(weatherServiceProvider);
  // Default to user's localized coordinate with graceful offline fallback
  return weatherService.getWeatherForecast(
    latitude: 12.9716,
    longitude: 77.5946,
    date: DateTime.now(),
  );
});

final selectedDayProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

enum AppSection { today, plan, insights }

final appSectionProvider = StateProvider<AppSection>((ref) => AppSection.today);

final showRecurringTasksProvider = StateProvider<bool>((ref) => true);
final animationsEnabledProvider = StateProvider<bool>((ref) => true);
final aiSchedulingProvider = StateProvider<bool>((ref) => true);
final autoCarryForwardProvider = StateProvider<bool>((ref) => true);
final remindersEnabledProvider = StateProvider<bool>((ref) => true);
final defaultReminderOffsetProvider = StateProvider<int>((ref) => 10);
final dailySummaryEnabledProvider = StateProvider<bool>((ref) => true);
final overdueAlertsEnabledProvider = StateProvider<bool>((ref) => true);
final allowSleepOverrideProvider = StateProvider<bool>((ref) => false);
final autoBufferMinutesProvider = StateProvider<int>((ref) => 5);
final showRealismLegendProvider = StateProvider<bool>((ref) => true);
final focusModeLockedProvider = StateProvider<bool>((ref) => false);
final selectedAccentIndexProvider = StateProvider<int>((ref) => 0);
final selectedThemeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

final startupInitializationProvider = FutureProvider<void>((ref) async {
  final repository = ref.watch(plannerRepositoryProvider);
  final settings = await repository.initializeForLaunch();
  ref.read(autoCarryForwardProvider.notifier).state = settings.autoCarryForwardEnabled;
  ref.read(remindersEnabledProvider.notifier).state = settings.remindersEnabled;
  ref.read(defaultReminderOffsetProvider.notifier).state = settings.defaultReminderOffsetMinutes;
  ref.read(dailySummaryEnabledProvider.notifier).state = settings.dailySummaryEnabled;
  ref.read(overdueAlertsEnabledProvider.notifier).state = settings.overdueAlertsEnabled;
  ref.read(allowSleepOverrideProvider.notifier).state = settings.allowSleepOverride;
  ref.read(autoBufferMinutesProvider.notifier).state = settings.bufferMinutes;
  ref.read(showRealismLegendProvider.notifier).state = settings.showRealismLegend;
});

final tasksForSelectedDayProvider = StreamProvider<List<TaskModel>>((ref) {
  final selected = ref.watch(selectedDayProvider);
  return ref.watch(plannerRepositoryProvider).watchTasksForDay(selected);
});

final minuteTickerProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  while (true) {
    await Future<void>.delayed(const Duration(minutes: 1));
    yield DateTime.now();
  }
});

final lifecycleEngineProvider = FutureProvider<void>((ref) async {
  final tick = ref.watch(minuteTickerProvider).valueOrNull;
  if (tick == null) return;
  final repository = ref.watch(plannerRepositoryProvider);
  await repository.syncLifecycleStates(tick);
  ref.invalidate(tasksForSelectedDayProvider);
  ref.invalidate(inProgressTasksProvider);
  ref.invalidate(overflowTasksProvider);
  ref.invalidate(weeklyStatsProvider);
  ref.invalidate(weeklyProductivityProvider);
  ref.invalidate(behavioralInsightsProvider);
});

final notificationActionListenerProvider = FutureProvider<void>((ref) async {
  final notifications = ref.watch(localNotificationServiceProvider);
  await for (final event in notifications.actionEvents) {
    final actions = ref.read(plannerActionsProvider);
    await actions.handleNotificationAction(event.taskId, event.actionId);
  }
});

final inProgressTasksProvider = StreamProvider<List<TaskModel>>((ref) {
  final selected = ref.watch(selectedDayProvider);
  return ref.watch(plannerRepositoryProvider).watchCurrentInProgress(selected);
});

final overflowTasksProvider = FutureProvider<List<TaskModel>>((ref) {
  final selected = ref.watch(selectedDayProvider);
  return ref.watch(plannerRepositoryProvider).getOverflowForDay(selected);
});

final weekAnchorProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final monthAnchorProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

final weekDayCompletionProvider = FutureProvider<Map<DateTime, double>>((ref) {
  final anchor = ref.watch(weekAnchorProvider);
  return ref.watch(plannerRepositoryProvider).getWeekDayCompletion(anchor);
});

final monthDayCompletionProvider = FutureProvider<Map<DateTime, double>>((ref) {
  final anchor = ref.watch(monthAnchorProvider);
  return ref.watch(plannerRepositoryProvider).getMonthDayCompletion(anchor);
});

final blueprintProfileProvider = FutureProvider<BlueprintProfileModel>((ref) {
  return ref.watch(plannerRepositoryProvider).getBlueprintProfile();
});

final fixedBlocksForSelectedDayProvider = StreamProvider<List<FixedActivityBlockModel>>((ref) {
  final selected = ref.watch(selectedDayProvider);
  return ref.watch(plannerRepositoryProvider).watchFixedBlocksForDay(selected);
});

final fixedBlocksForWeekProvider = StreamProvider<List<FixedActivityBlockModel>>((ref) {
  return ref.watch(plannerRepositoryProvider).watchAllFixedBlocks();
});

final availabilityHoursProvider = FutureProvider<double>((ref) {
  final selected = ref.watch(selectedDayProvider);
  return ref.watch(plannerRepositoryProvider).getAvailableProductiveHours(selected);
});

final weeklyOverloadIndexProvider = FutureProvider<double>((ref) {
  final anchor = ref.watch(weekAnchorProvider);
  return ref.watch(plannerRepositoryProvider).getWeeklyOverloadIndex(anchor);
});

final weekDayRealismProvider = FutureProvider<Map<DateTime, bool>>((ref) async {
  final anchor = ref.watch(weekAnchorProvider);
  final repository = ref.watch(plannerRepositoryProvider);
  final weekStart = DateTime(anchor.year, anchor.month, anchor.day)
      .subtract(Duration(days: anchor.weekday - 1));
  final weekEnd = weekStart.add(const Duration(days: 7));
  final weekTasks = await repository.getTasksInRange(weekStart, weekEnd);
  final completion = await repository.getWeekDayCompletion(weekStart);
  final completionValues = completion.values.where((value) => value > 0).toList();
  final historicalBaseline = completionValues.isEmpty
      ? 3.0
      : (completionValues.reduce((a, b) => a + b) / completionValues.length) * 6.0;

  final map = <DateTime, bool>{};
  for (var i = 0; i < 7; i++) {
    final day = weekStart.add(Duration(days: i));
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final tasks = weekTasks
        .where((task) => !task.startAt.isBefore(dayStart) && task.startAt.isBefore(dayEnd))
        .toList();
    final plannedHours = tasks.fold<int>(0, (sum, task) => sum + task.endAt.difference(task.startAt).inMinutes) / 60.0;
    final availableHours = await repository.getAvailableProductiveHours(day);
    final unrealistic = plannedHours > historicalBaseline * 1.5 ||
        (availableHours > 0 && plannedHours > availableHours * 0.95);
    map[DateTime(day.year, day.month, day.day)] = unrealistic;
  }
  return map;
});

final realismWarningProvider = FutureProvider<bool>((ref) async {
  final selected = ref.watch(selectedDayProvider);
  final available = await ref.watch(plannerRepositoryProvider).getAvailableProductiveHours(selected);
  final stats = await ref.watch(plannerRepositoryProvider).getWeeklyStats(selected);
  if (stats.total == 0) return false;
  final avgCompleted = (stats.completed * 60.0) / 7.0;
  final planned = ((ref.watch(tasksForSelectedDayProvider).valueOrNull ?? const <TaskModel>[])
          .fold<int>(0, (sum, task) => sum + task.endAt.difference(task.startAt).inMinutes)) /
      60.0;
  final baseline = avgCompleted <= 0 ? available : avgCompleted;
  return planned > baseline * 1.5;
});

final weeklyStatsProvider = FutureProvider<WeeklyLogStats>((ref) {
  final anchor = ref.watch(weekAnchorProvider);
  return ref.watch(plannerRepositoryProvider).getWeeklyStats(anchor);
});

final dailyDashboardMetricsProvider = Provider<({int totalTasks, int completedTasks, double completion, double focusHours})>((ref) {
  final tasks = ref.watch(tasksForSelectedDayProvider).valueOrNull ?? const <TaskModel>[];
  final total = tasks.where((task) => !task.isArchived).length;
  final completed = tasks.where((task) => task.status == TaskStatus.completed).length;
  final completedMinutes = tasks
      .where((task) => task.status == TaskStatus.completed)
      .fold<int>(0, (sum, task) => sum + task.endAt.difference(task.startAt).inMinutes);
  final completion = total == 0 ? 0.0 : completed / total;
  final focusHours = completedMinutes / 60;
  return (
    totalTasks: total,
    completedTasks: completed,
    completion: completion,
    focusHours: focusHours,
  );
});

final streakDaysProvider = Provider<int>((ref) {
  final completion = ref.watch(weekDayCompletionProvider).valueOrNull;
  if (completion == null || completion.isEmpty) return 0;
  final now = DateTime.now();
  final sortedDays = completion.keys.toList()..sort();
  var streak = 0;
  for (final day in sortedDays.reversed) {
    if (day.isAfter(DateTime(now.year, now.month, now.day))) continue;
    final value = completion[day] ?? 0;
    if (value >= 0.5) {
      streak++;
    } else {
      if (streak > 0) break;
    }
  }
  return streak;
});

final gamificationProvider = Provider<({int xp, int level})>((ref) {
  final stats = ref.watch(weeklyStatsProvider).valueOrNull;
  final completed = stats?.completed ?? 0;
  final streak = ref.watch(streakDaysProvider);
  final xp = completed * 20 + streak * 15;
  final level = (xp / 120).floor() + 1;
  return (xp: xp, level: level);
});

final schedulerSuggestionProvider = Provider<String?>((ref) {
  final enabled = ref.watch(aiSchedulingProvider);
  if (!enabled) return null;
  final tasks = [...(ref.watch(tasksForSelectedDayProvider).valueOrNull ?? const <TaskModel>[])];
  if (tasks.isEmpty) return 'Suggested: 09:00 AM - no tasks scheduled yet.';
  tasks.sort((a, b) => a.startAt.compareTo(b.startAt));
  final now = DateTime.now();
  final currentHour = now.hour;
  final highEnergyUpcoming = tasks.where((task) {
    if ((task.categoryId ?? 1) < 2) return false;
    final difference = task.startAt.difference(now).inMinutes;
    return difference >= 0 && difference <= 180;
  }).length;
  if (currentHour >= 14 && highEnergyUpcoming >= 2) {
    return 'Energy tip: shift one high-focus task to tomorrow morning for better execution.';
  }

  DateTime cursor = DateTime(now.year, now.month, now.day, now.hour, (now.minute ~/ 15) * 15);
  for (final task in tasks) {
    if (cursor.add(const Duration(minutes: 45)).isBefore(task.startAt)) {
      final end = cursor.add(const Duration(minutes: 45));
      return 'Suggested slot: ${_labelTime(cursor)} - ${_labelTime(end)}';
    }
    if (task.endAt.isAfter(cursor)) {
      cursor = task.endAt;
    }
  }
  final end = cursor.add(const Duration(minutes: 45));
  return 'Suggested slot: ${_labelTime(cursor)} - ${_labelTime(end)}';
});

String _labelTime(DateTime value) {
  final hour = value.hour == 0 ? 12 : (value.hour > 12 ? value.hour - 12 : value.hour);
  final minute = value.minute.toString().padLeft(2, '0');
  final suffix = value.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $suffix';
}

final weeklyProductivityProvider = FutureProvider<WeeklyProductivity>((ref) {
  final anchor = ref.watch(weekAnchorProvider);
  return ref.watch(plannerRepositoryProvider).getWeeklyProductivity(anchor);
});

final behavioralInsightsProvider = FutureProvider<BehavioralInsights>((ref) {
  final anchor = ref.watch(weekAnchorProvider);
  return ref.watch(plannerRepositoryProvider).getBehavioralInsights(anchor);
});

class FocusModeState {
  const FocusModeState({
    this.enabled = false,
    this.deepFocus = false,
    this.startedAt,
    this.activeTaskId,
  });

  final bool enabled;
  final bool deepFocus;
  final DateTime? startedAt;
  final int? activeTaskId;

  FocusModeState copyWith({
    bool? enabled,
    bool? deepFocus,
    DateTime? startedAt,
    int? activeTaskId,
  }) {
    return FocusModeState(
      enabled: enabled ?? this.enabled,
      deepFocus: deepFocus ?? this.deepFocus,
      startedAt: startedAt ?? this.startedAt,
      activeTaskId: activeTaskId ?? this.activeTaskId,
    );
  }
}

final focusModeProvider = StateProvider<FocusModeState>((ref) => const FocusModeState());

final plannerActionsProvider = Provider<PlannerActions>((ref) {
  return PlannerActions(
    repository: ref.watch(plannerRepositoryProvider),
    notifications: ref.watch(localNotificationServiceProvider),
    ref: ref,
  );
});

class PlannerActions {
  PlannerActions({
    required PlannerRepository repository,
    required LocalNotificationService notifications,
    required Ref ref,
  })  : _repository = repository,
        _notifications = notifications,
        _ref = ref;

  final PlannerRepository _repository;
  final LocalNotificationService _notifications;
  final Ref _ref;

  Future<void> saveTask(TaskModel task, {int? reminderOffsetMinutes}) async {
    final remindersEnabled = _ref.read(remindersEnabledProvider);
    final defaultReminder = _ref.read(defaultReminderOffsetProvider);
    final selected = reminderOffsetMinutes ?? defaultReminder;
    task.reminderOffsetMinutes = remindersEnabled
        ? (selected == -2 ? _smartReminderOffset(task) : selected)
        : -1;
    await _repository.upsertTask(task);
    _ref.invalidate(tasksForSelectedDayProvider);
    _ref.invalidate(weekDayCompletionProvider);
    _ref.invalidate(weeklyProductivityProvider);
  }

  Future<void> toggleChecklist(TaskModel task, int index, bool value) async {
    await _repository.updateTaskChecklist(task, index, value);
    _ref.invalidate(tasksForSelectedDayProvider);
    _ref.invalidate(overflowTasksProvider);
    _ref.invalidate(weeklyStatsProvider);
    _ref.invalidate(weekDayCompletionProvider);
    _ref.invalidate(weeklyProductivityProvider);
  }

  Future<void> quickComplete(TaskModel task) async {
    await _repository.quickCompleteTask(task);
    _ref.invalidate(tasksForSelectedDayProvider);
    _ref.invalidate(overflowTasksProvider);
    _ref.invalidate(weeklyStatsProvider);
    _ref.invalidate(weekDayCompletionProvider);
    _ref.invalidate(weeklyProductivityProvider);
  }

  Future<void> archive(TaskModel task) async {
    await _repository.archiveTask(task);
    _ref.invalidate(tasksForSelectedDayProvider);
    _ref.invalidate(overflowTasksProvider);
    _ref.invalidate(weeklyStatsProvider);
    _ref.invalidate(weeklyProductivityProvider);
    _ref.invalidate(weekDayCompletionProvider);
  }

  Future<void> rescheduleOverflow(TaskModel sourceTask, DateTime day, int startMinute) async {
    await _repository.rescheduleOverflowTask(sourceTask, day, startMinute);
    _ref.invalidate(tasksForSelectedDayProvider);
    _ref.invalidate(overflowTasksProvider);
    _ref.invalidate(weeklyStatsProvider);
    _ref.invalidate(weekDayCompletionProvider);
    _ref.invalidate(weeklyProductivityProvider);
  }

  Future<void> seedTemplateRoutine() async {
    final routine = RoutineTemplateModel()
      ..title = 'College Timings'
      ..weekdays = [1, 2, 3, 4, 5]
      ..startMinuteOfDay = 9 * 60
      ..endMinuteOfDay = 15 * 60
      ..checklistBlueprint = ['Attendance', 'Class Notes', 'Assignments'];
    routine.tag = TaskTagModel(
      name: 'College',
      colorValue: 0xFF68D8CF,
      iconCodePoint: 0xe80c,
    );
    await _repository.saveRoutineTemplate(routine);
    await _repository.generateWeekFromTemplates(_ref.read(selectedDayProvider));
    _ref.invalidate(tasksForSelectedDayProvider);
  }

  Future<void> generateCurrentWeek() async {
    await _repository.generateWeekFromTemplates(_ref.read(selectedDayProvider));
    _ref.invalidate(tasksForSelectedDayProvider);
    _ref.invalidate(weekDayCompletionProvider);
  }

  Future<void> createRoutineTemplate(RoutineTemplateModel template) async {
    await _repository.saveRoutineTemplate(template);
    await _repository.generateWeekFromTemplates(_ref.read(selectedDayProvider));
    _ref.invalidate(tasksForSelectedDayProvider);
    _ref.invalidate(weekDayCompletionProvider);
    _ref.invalidate(weeklyStatsProvider);
  }

  Future<void> enterFocusMode({int? taskId, bool deepFocus = false}) async {
    await _repository.startFocusSession(taskId: taskId, deepFocus: deepFocus);
    _ref.read(focusModeProvider.notifier).state = FocusModeState(
      enabled: true,
      deepFocus: deepFocus,
      startedAt: DateTime.now(),
      activeTaskId: taskId,
    );
  }

  Future<void> exitFocusMode() async {
    await _repository.stopFocusSession();
    _ref.read(focusModeProvider.notifier).state = const FocusModeState();
    _ref.invalidate(weeklyProductivityProvider);
  }

  Future<String?> exportBackup() {
    return _repository.exportBackup();
  }

  Future<void> restoreBackup(String path) async {
    await _repository.restoreBackup(path);
    _ref.invalidate(tasksForSelectedDayProvider);
    _ref.invalidate(overflowTasksProvider);
    _ref.invalidate(weeklyStatsProvider);
    _ref.invalidate(weeklyProductivityProvider);
    _ref.invalidate(behavioralInsightsProvider);
  }

  Future<void> runAutoBackupIfDue() {
    return _repository.autoBackupIfDue();
  }

  Future<void> updateNotificationSettings({
    bool? remindersEnabled,
    int? defaultReminderOffsetMinutes,
    bool? dailySummaryEnabled,
    bool? overdueAlertsEnabled,
    bool? autoCarryForwardEnabled,
    bool? allowSleepOverride,
    int? bufferMinutes,
    bool? showRealismLegend,
  }) async {
    final settings = await _repository.getAppSettings();
    settings
      ..remindersEnabled = remindersEnabled ?? settings.remindersEnabled
      ..defaultReminderOffsetMinutes = defaultReminderOffsetMinutes ?? settings.defaultReminderOffsetMinutes
      ..dailySummaryEnabled = dailySummaryEnabled ?? settings.dailySummaryEnabled
      ..overdueAlertsEnabled = overdueAlertsEnabled ?? settings.overdueAlertsEnabled
      ..autoCarryForwardEnabled = autoCarryForwardEnabled ?? settings.autoCarryForwardEnabled
      ..allowSleepOverride = allowSleepOverride ?? settings.allowSleepOverride
      ..bufferMinutes = bufferMinutes ?? settings.bufferMinutes
      ..showRealismLegend = showRealismLegend ?? settings.showRealismLegend;
    await _repository.saveAppSettings(settings);

    _ref.read(remindersEnabledProvider.notifier).state = settings.remindersEnabled;
    _ref.read(defaultReminderOffsetProvider.notifier).state = settings.defaultReminderOffsetMinutes;
    _ref.read(dailySummaryEnabledProvider.notifier).state = settings.dailySummaryEnabled;
    _ref.read(overdueAlertsEnabledProvider.notifier).state = settings.overdueAlertsEnabled;
    _ref.read(autoCarryForwardProvider.notifier).state = settings.autoCarryForwardEnabled;
    _ref.read(allowSleepOverrideProvider.notifier).state = settings.allowSleepOverride;
    _ref.read(autoBufferMinutesProvider.notifier).state = settings.bufferMinutes;
    _ref.read(showRealismLegendProvider.notifier).state = settings.showRealismLegend;
  }

  Future<void> saveBlueprintProfile(BlueprintProfileModel profile) async {
    await _repository.saveBlueprintProfile(profile);
    _ref.invalidate(blueprintProfileProvider);
    _ref.invalidate(availabilityHoursProvider);
    _ref.invalidate(weeklyOverloadIndexProvider);
  }

  Future<void> saveFixedBlock(FixedActivityBlockModel block) async {
    await _repository.upsertFixedBlock(block);
    _ref.invalidate(fixedBlocksForSelectedDayProvider);
    _ref.invalidate(availabilityHoursProvider);
    _ref.invalidate(weeklyOverloadIndexProvider);
    _ref.invalidate(tasksForSelectedDayProvider);
  }

  Future<void> deleteFixedBlock(int id) async {
    await _repository.deleteFixedBlock(id);
    _ref.invalidate(fixedBlocksForSelectedDayProvider);
    _ref.invalidate(availabilityHoursProvider);
    _ref.invalidate(weeklyOverloadIndexProvider);
    _ref.invalidate(tasksForSelectedDayProvider);
  }

  Future<void> distributeProject({
    required String title,
    required DateTime deadline,
    required double totalHours,
  }) async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final last = DateTime(deadline.year, deadline.month, deadline.day);
    if (last.isBefore(start) || totalHours <= 0) return;

    final days = <DateTime>[];
    for (var day = start; !day.isAfter(last); day = day.add(const Duration(days: 1))) {
      days.add(DateTime(day.year, day.month, day.day));
    }
    final capacity = <DateTime, double>{};
    for (final day in days) {
      final available = await _repository.getAvailableProductiveHours(day);
      final already = (await _repository.watchTasksForDay(day).first)
          .fold<int>(0, (sum, task) => sum + task.endAt.difference(task.startAt).inMinutes) /
          60.0;
      capacity[day] = (available - already).clamp(0.0, 24.0);
    }

    var remaining = totalHours;
    final sortedDays = days.toList()
      ..sort((a, b) => (capacity[b] ?? 0).compareTo(capacity[a] ?? 0));
    final allocations = <DateTime, double>{for (final day in days) day: 0};

    while (remaining > 0.01) {
      var progressed = false;
      for (final day in sortedDays) {
        final free = (capacity[day] ?? 0) - (allocations[day] ?? 0);
        if (free <= 0.25) continue;
        final chunk = remaining >= 1.5 ? 1.5 : remaining;
        final use = chunk <= free ? chunk : free;
        if (use <= 0) continue;
        allocations[day] = (allocations[day] ?? 0) + use;
        remaining -= use;
        progressed = true;
        if (remaining <= 0.01) break;
      }
      if (!progressed) break;
    }

    final generatedTasks = <TaskModel>[];
    for (final entry in allocations.entries.where((item) => item.value > 0)) {
      final day = entry.key;
      final minutes = (entry.value * 60).round();
      final startAt = DateTime(day.year, day.month, day.day, 9, 0);
      final task = TaskModel()
        ..title = '$title • Deep Work'
        ..startAt = startAt
        ..endAt = startAt.add(Duration(minutes: minutes.clamp(45, 180)))
        ..categoryId = 2
        ..priority = 2
        ..recurrenceRule = 'none'
        ..reminderOffsetMinutes = _ref.read(defaultReminderOffsetProvider)
        ..checklist = [ChecklistItemModel(text: 'Focus sprint', isChecked: false)];
      generatedTasks.add(task);
    }

    if (generatedTasks.isNotEmpty) {
      await _repository.upsertTasks(generatedTasks);
      _ref.invalidate(tasksForSelectedDayProvider);
      _ref.invalidate(weekDayCompletionProvider);
      _ref.invalidate(weeklyProductivityProvider);
      _ref.invalidate(weeklyStatsProvider);
    }
  }

  Future<TaskDraftModel?> getTaskDraft() {
    return _repository.getTaskDraft();
  }

  Future<void> saveTaskDraft(TaskDraftModel draft) {
    return _repository.saveTaskDraft(draft);
  }

  Future<void> clearTaskDraft() {
    return _repository.clearTaskDraft();
  }

  Future<void> handleNotificationAction(int taskId, String actionId) async {
    final task = await _repository.getTaskById(taskId);
    if (task == null) return;

    if (actionId == 'mark_done') {
      await quickComplete(task);
      return;
    }
    if (actionId == 'snooze_10') {
      await _notifications.scheduleSnooze(task, minutes: 10);
    }
  }

  int _smartReminderOffset(TaskModel task) {
    final durationMinutes = task.endAt.difference(task.startAt).inMinutes;
    var base = switch ((task.categoryId ?? 1).clamp(0, 2)) {
      2 => 30,
      1 => 15,
      _ => 10,
    };
    if (durationMinutes >= 120) base += 10;
    if (durationMinutes >= 90 && durationMinutes < 120) base += 5;
    return base.clamp(0, 60);
  }
}
