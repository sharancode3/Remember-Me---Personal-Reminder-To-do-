import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/neo_colors.dart';
import '../../core/theme/neo_shadows.dart';
import '../../core/theme/neo_typography.dart';
import '../../core/widgets/neo_bandaid_alarm_logo.dart';
import '../../core/widgets/neo_button.dart';
import '../../core/widgets/neo_card.dart';
import '../../data/models/task_model.dart';
import '../../domain/repositories/provider_abstractions.dart';
import '../../services/context_engine.dart';
import '../../services/master_adaptive_day_orchestrator.dart';
import '../../services/observation_store.dart';
import '../providers/providers.dart';
import '../widgets/checklist_sheet.dart';
import 'journey_screen.dart';
import 'neo_task_capture_sheet.dart';

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(lifecycleEngineProvider);
    final selected = ref.watch(selectedDayProvider);
    final tasksAsync = ref.watch(tasksForSelectedDayProvider);
    final inProgressAsync = ref.watch(inProgressTasksProvider);
    final dailyMetrics = ref.watch(dailyDashboardMetricsProvider);
    final colors = context.neo;

    return RefreshIndicator(
      color: colors.border,
      backgroundColor: colors.accentYellow,
      onRefresh: () async {
        ref.invalidate(tasksForSelectedDayProvider);
        ref.invalidate(inProgressTasksProvider);
        ref.invalidate(weeklyStatsProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. DATE & GREETING BANNER
            _buildHeaderBanner(context, selected),
            const SizedBox(height: 14),

            // 1.2 ACTIVE PLANNING SIGNALS (CROSS-CONTEXT INTELLIGENCE)
            _buildPlanningSignalsBanner(context),
            const SizedBox(height: 14),

            // 1.5 REALITY MODE & SCHEDULE SLIPPAGE RECOVERY BANNER
            tasksAsync.when(
              data: (tasks) => _buildRealityRecoveryBanner(context, tasks),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 14),

            // 2. HERO "NOW" CARD
            tasksAsync.when(
              data: (tasks) {
                final inProgress = inProgressAsync.valueOrNull ?? [];
                return _buildNowCard(context, tasks, inProgress);
              },
              loading: () => _buildLoadingCard(context),
              error: (e, _) => _buildErrorCard(context, e.toString()),
            ),
            const SizedBox(height: 18),

            // 3. DAY CAPACITY METER
            _buildDayCapacityMeter(context, dailyMetrics),
            const SizedBox(height: 18),

            // 4. TODAY VISUAL TIMELINE STRIP
            tasksAsync.when(
              data: (tasks) => _buildTodayVisualTimeline(context, tasks),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 18),

            // 5. "NEXT" UPCOMING QUEUE
            tasksAsync.when(
              data: (tasks) => _buildNextQueue(context, tasks),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),

            // 6. QUICK ACTIONS: + ADD TASK, AUTO-PLAN & JOURNEY
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: NeoButton(
                    text: '+ ADD TASK',
                    variant: NeoButtonVariant.accentRed,
                    shape: NeoButtonShape.sharp,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    onPressed: () => _openQuickTaskSheet(context),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  flex: 2,
                  child: NeoButton(
                    text: 'AUTO-PLAN',
                    variant: NeoButtonVariant.accentYellow,
                    shape: NeoButtonShape.sharp,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                    icon: const Icon(Icons.bolt, color: Colors.black, size: 16),
                    onPressed: () => _handleAutoPlan(context),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  flex: 2,
                  child: NeoButton(
                    text: 'JOURNEY',
                    variant: NeoButtonVariant.accentViolet,
                    shape: NeoButtonShape.sharp,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                    icon: const Icon(Icons.directions_run, color: Colors.black, size: 16),
                    onPressed: () => _startMovementJourney(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- HEADER BANNER ---
  Widget _buildHeaderBanner(BuildContext context, DateTime selected) {
    final colors = context.neo;
    final formattedDate = DateFormat('EEEE, d MMMM').format(selected).toUpperCase();
    final weatherAsync = ref.watch(todayWeatherForecastProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TODAY · $formattedDate',
                style: NeoTypography.label(
                  color: colors.accentRed,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _greeting().toUpperCase(),
                style: NeoTypography.display(
                  color: colors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        // Live Weather Planning Signal
        weatherAsync.when(
          data: (weather) {
            if (weather == null) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: weather.isOutdoorFavorable ? colors.accentYellow : colors.accentRed,
                border: Border.all(color: colors.border, width: 2.5),
                boxShadow: NeoShadows.small(colors.shadow),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    weather.condition == WeatherConditionType.rain ||
                            weather.condition == WeatherConditionType.heavyRain
                        ? Icons.water_drop
                        : Icons.wb_sunny,
                    size: 15,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${weather.temperatureCelsius.toInt()}°C',
                    style: NeoTypography.label(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  // --- ACTIVE PLANNING SIGNALS (CROSS-CONTEXT ENGINE) ---
  Widget _buildPlanningSignalsBanner(BuildContext context) {
    final colors = context.neo;
    final signalsAsync = ref.watch(activePlanningSignalsProvider);

    return signalsAsync.when(
      data: (signals) {
        if (signals.isEmpty) return const SizedBox.shrink();
        final first = signals.first;

        return NeoCard(
          backgroundColor: colors.surface,
          borderColor: colors.border,
          borderWidth: 3.5,
          shadowOffset: const Offset(6, 6),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    color: colors.accentYellow,
                    child: Text(
                      'PLANNING SIGNAL',
                      style: NeoTypography.label(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      first.title.toUpperCase(),
                      style: NeoTypography.headline(
                        color: colors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                first.description,
                style: NeoTypography.body(
                  color: colors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (first.suggestedActionTitle != null) ...[
                const SizedBox(height: 10),
                NeoButton(
                  text: first.suggestedActionTitle!,
                  variant: NeoButtonVariant.accentRed,
                  fontSize: 11,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  onPressed: () {
                    if (first.type == PlanningSignalType.stepGoalBehind) {
                      _startMovementJourney(context);
                    } else {
                      _handleAutoPlan(context);
                    }
                  },
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  // --- REALITY MODE & RECOVERY ENGINE BANNER ---
  Widget _buildRealityRecoveryBanner(BuildContext context, List<TaskModel> tasks) {
    final colors = context.neo;
    final now = DateTime.now();

    // Check for slippage: uncompleted tasks whose endAt is past current time
    final overdueTasks = tasks
        .where((t) => !t.isArchived && t.status == TaskStatus.pending && t.endAt.isBefore(now))
        .toList();

    if (overdueTasks.isEmpty) return const SizedBox.shrink();

    final totalOverdueMins = overdueTasks.fold<int>(
      0,
      (sum, t) => sum + t.endAt.difference(t.startAt).inMinutes,
    );

    return NeoCard(
      backgroundColor: colors.accentYellow,
      borderColor: colors.border,
      borderWidth: 3.5,
      shadowOffset: const Offset(6, 6),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                color: Colors.black,
                child: Text(
                  'REALITY MODE',
                  style: NeoTypography.label(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '⚡ ${overdueTasks.length} TASKS SLIPPED (~${totalOverdueMins}M)',
                  style: NeoTypography.headline(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Your day changed. No guilt — let\'s heal your timeline right now.',
            style: NeoTypography.body(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: NeoButton(
                  text: 'HEAL SCHEDULE',
                  variant: NeoButtonVariant.accentRed,
                  fontSize: 12,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  onPressed: () => _openRecoveryDialog(context, overdueTasks),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openRecoveryDialog(BuildContext context, List<TaskModel> overdueTasks) {
    final colors = context.neo;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: colors.canvas,
            border: Border(
              top: BorderSide(color: colors.border, width: 4),
              left: BorderSide(color: colors.border, width: 3),
              right: BorderSide(color: colors.border, width: 3),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            24 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '⚡ HEAL YOUR SCHEDULE',
                style: NeoTypography.headline(
                  color: colors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose how you want Remember Me to rebalance your day:',
                style: NeoTypography.body(color: colors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 16),

              // Option 1: SAVE EVERYTHING (Push to next open slots today)
              _recoveryOptionTile(
                context,
                title: 'SAVE EVERYTHING',
                description: 'Compress remaining buffers and push overdue tasks to later today.',
                badgeColor: colors.accentYellow,
                onTap: () async {
                  final now = DateTime.now();
                  final obsStore = ref.read(observationStoreProvider);
                  final orchestrator = ref.read(masterAdaptiveDayOrchestratorProvider);
                  var cursor = now.add(const Duration(minutes: 10));

                  for (final task in overdueTasks) {
                    final dur = task.endAt.difference(task.startAt);
                    final oldStart = task.startAt;
                    task.startAt = cursor;
                    task.endAt = cursor.add(dur);

                    final friction = orchestrator.evaluateFriction(
                      task.title,
                      task.tag?.name ?? 'general',
                      task.priority,
                    );

                    obsStore.recordTaskRescheduled(
                      taskId: task.id,
                      taskTitle: task.title,
                      oldStart: oldStart,
                      newStart: cursor,
                      reason: 'Reality Mode: Saved and shifted downstream (+${friction.recoveryCostMinutes}m friction buffer)',
                    );

                    await ref.read(plannerActionsProvider).saveTask(task);
                    cursor = task.endAt.add(Duration(minutes: friction.recoveryCostMinutes));
                  }
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),

              // Option 2: PROTECT ESSENTIALS (Keep High Priority, postpone rest)
              _recoveryOptionTile(
                context,
                title: 'PROTECT ESSENTIALS',
                description: 'Keep only high-priority tasks for today; move optional tasks to tomorrow.',
                badgeColor: colors.accentViolet,
                onTap: () async {
                  final now = DateTime.now();
                  final tomorrow = now.add(const Duration(days: 1));
                  final obsStore = ref.read(observationStoreProvider);
                  final orchestrator = ref.read(masterAdaptiveDayOrchestratorProvider);
                  var cursor = now.add(const Duration(minutes: 10));

                  for (final task in overdueTasks) {
                    final friction = orchestrator.evaluateFriction(
                      task.title,
                      task.tag?.name ?? 'general',
                      task.priority,
                    );

                    // High gravity (immovable commitments / priority >= 2) stay today
                    if (friction.planGravity >= 0.8 || task.priority >= 2) {
                      final dur = task.endAt.difference(task.startAt);
                      final oldStart = task.startAt;
                      task.startAt = cursor;
                      task.endAt = cursor.add(dur);
                      cursor = task.endAt.add(Duration(minutes: friction.recoveryCostMinutes));

                      obsStore.recordTaskRescheduled(
                        taskId: task.id,
                        taskTitle: task.title,
                        oldStart: oldStart,
                        newStart: task.startAt,
                        reason: 'Reality Mode: Essential commitment protected for today',
                      );
                    } else {
                      final dur = task.endAt.difference(task.startAt);
                      final oldStart = task.startAt;
                      task.startAt = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 10, 0);
                      task.endAt = task.startAt.add(dur);

                      obsStore.recordTaskRescheduled(
                        taskId: task.id,
                        taskTitle: task.title,
                        oldStart: oldStart,
                        newStart: task.startAt,
                        reason: 'Reality Mode: Optional task rolled to tomorrow to protect essentials',
                      );
                    }
                    await ref.read(plannerActionsProvider).saveTask(task);
                  }
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),

              // Option 3: RESET TO TOMORROW (Clean rest of today)
              _recoveryOptionTile(
                context,
                title: 'RESET TO TOMORROW',
                description: 'Move all uncompleted tasks to tomorrow morning so you can rest today.',
                badgeColor: colors.accentRed,
                onTap: () async {
                  final tomorrow = DateTime.now().add(const Duration(days: 1));
                  final obsStore = ref.read(observationStoreProvider);
                  var cursor = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0);

                  for (final task in overdueTasks) {
                    final dur = task.endAt.difference(task.startAt);
                    final oldStart = task.startAt;
                    task.startAt = cursor;
                    task.endAt = cursor.add(dur);

                    obsStore.recordTaskRescheduled(
                      taskId: task.id,
                      taskTitle: task.title,
                      oldStart: oldStart,
                      newStart: cursor,
                      reason: 'Reality Mode: Full day reset to tomorrow for rest',
                    );

                    await ref.read(plannerActionsProvider).saveTask(task);
                    cursor = task.endAt.add(const Duration(minutes: 15));
                  }
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _recoveryOptionTile(
    BuildContext context, {
    required String title,
    required String description,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    final colors = context.neo;
    final isRed = badgeColor == colors.accentRed;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.border, width: 2.5),
          boxShadow: NeoShadows.small(colors.shadow),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: badgeColor,
              child: Text(
                title,
                style: NeoTypography.label(
                  color: isRed ? Colors.white : Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                description,
                style: NeoTypography.body(
                  color: colors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
            Icon(Icons.arrow_forward, size: 18, color: colors.textPrimary),
          ],
        ),
      ),
    );
  }

  // --- THE "NOW" HERO CARD ---
  Widget _buildNowCard(BuildContext context, List<TaskModel> allTasks, List<TaskModel> inProgressList) {
    final colors = context.neo;
    final now = DateTime.now();

    final activeTasks = allTasks.where((t) => !t.isArchived && t.status != TaskStatus.completed).toList();
    activeTasks.sort((a, b) => a.startAt.compareTo(b.startAt));

    TaskModel? currentTask;
    if (inProgressList.isNotEmpty) {
      currentTask = inProgressList.first;
    } else {
      // Find task scheduled around right now
      for (final t in activeTasks) {
        if (!now.isBefore(t.startAt) && now.isBefore(t.endAt)) {
          currentTask = t;
          break;
        }
      }
      // If no task right now, pick next upcoming task
      currentTask ??= activeTasks.isNotEmpty ? activeTasks.first : null;
    }

    // Free State
    if (currentTask == null) {
      return NeoCard(
        backgroundColor: colors.surface,
        borderColor: colors.border,
        borderWidth: 3.5,
        shadowOffset: const Offset(8, 8),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.accentYellow,
                    border: Border.all(color: colors.border, width: 2),
                  ),
                  child: Text(
                    'NOW',
                    style: NeoTypography.label(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'YOU ARE FREE',
                  style: NeoTypography.headline(
                    color: colors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'No task is currently active. Want to tackle a micro-task or plan ahead?',
              style: NeoTypography.body(
                color: colors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            NeoButton(
              text: 'WHAT CAN I DO NOW?',
              variant: NeoButtonVariant.accentViolet,
              isFullWidth: true,
              icon: const Icon(Icons.psychology, color: Colors.black, size: 20),
              onPressed: () => _openWhatCanIDoSheet(context, allTasks),
            ),
          ],
        ),
      );
    }

    final startStr = DateFormat('h:mm a').format(currentTask.startAt);
    final endStr = DateFormat('h:mm a').format(currentTask.endAt);
    final durationMins = currentTask.endAt.difference(currentTask.startAt).inMinutes;

    return NeoCard(
      backgroundColor: colors.accentRed,
      borderColor: colors.border,
      borderWidth: 4.0,
      shadowOffset: const Offset(8, 8),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Text(
                  'NOW',
                  style: NeoTypography.label(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (currentTask.tag != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: colors.accentYellow,
                    border: Border.all(color: colors.border, width: 2),
                  ),
                  child: Text(
                    currentTask.tag!.name.toUpperCase(),
                    style: NeoTypography.label(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              const Spacer(),
              Text(
                '${durationMins}M',
                style: NeoTypography.headline(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            currentTask.title.toUpperCase(),
            style: NeoTypography.headline(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            '$startStr — $endStr',
            style: NeoTypography.body(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          NeoButton(
            text: 'START NOW →',
            variant: NeoButtonVariant.accentYellow,
            isFullWidth: true,
            fontSize: 15,
            padding: const EdgeInsets.symmetric(vertical: 16),
            onPressed: () async {
              await ref.read(plannerActionsProvider).enterFocusMode(taskId: currentTask!.id);
            },
          ),
        ],
      ),
    );
  }

  // --- VARIABLE DAY CAPACITY & ATTENTION BUDGET METER ---
  Widget _buildDayCapacityMeter(
    BuildContext context,
    ({int totalTasks, int completedTasks, double completion, double focusHours}) metrics,
  ) {
    final colors = context.neo;
    final orchestrator = ref.watch(masterAdaptiveDayOrchestratorProvider);
    final capacity = orchestrator.calculateRealisticCapacity(
      targetDay: DateTime.now(),
      fixedCommitments: [],
    );

    final percent = (metrics.completion * 100).clamp(0, 100).toInt();
    final isOverloaded = metrics.focusHours > (capacity.deepWorkBudgetMinutes / 60.0);

    return NeoCard(
      backgroundColor: colors.surface,
      borderColor: colors.border,
      borderWidth: 3.5,
      shadowOffset: const Offset(6, 6),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'REALISTIC CAPACITY',
                style: NeoTypography.label(
                  color: colors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              const Spacer(),
              Text(
                isOverloaded ? '⚠️ OVERLOADED ($percent%)' : '$percent%',
                style: NeoTypography.headline(
                  color: isOverloaded ? colors.accentRed : colors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress Bar with pure thick black border
          Container(
            height: 22,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.canvas,
              border: Border.all(color: colors.border, width: 2.5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (metrics.completion).clamp(0.02, 1.0),
              child: Container(
                color: isOverloaded ? colors.accentRed : colors.accentYellow,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '${metrics.completedTasks}/${metrics.totalTasks} TASKS DONE',
                  style: NeoTypography.body(
                    color: colors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '${capacity.formattedCapacity} • ${metrics.focusHours.toStringAsFixed(1)}h PLANNED',
                  style: NeoTypography.body(
                    color: colors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TODAY VISUAL TIMELINE STRIP ---
  Widget _buildTodayVisualTimeline(BuildContext context, List<TaskModel> tasks) {
    final colors = context.neo;
    final activeTasks = tasks.where((t) => !t.isArchived).toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));

    if (activeTasks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TIMELINE STRIP',
          style: NeoTypography.label(
            color: colors.textSecondary,
            fontSize: 12,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 62,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: activeTasks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final task = activeTasks[index];
              final isDone = task.status == TaskStatus.completed;
              final isFocused = task.status == TaskStatus.inProgress;

              Color blockColor = colors.surface;
              if (isDone) {
                blockColor = colors.borderMuted;
              } else if (isFocused) {
                blockColor = colors.accentRed;
              } else {
                blockColor = (index % 2 == 0) ? colors.accentYellow : colors.accentViolet;
              }

              return GestureDetector(
                onTap: () => _openChecklist(task),
                child: Container(
                  width: 120,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: blockColor,
                    border: Border.all(color: colors.border, width: 2.5),
                    boxShadow: NeoShadows.small(colors.shadow),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('h:mm a').format(task.startAt),
                        style: NeoTypography.label(
                          color: isFocused ? Colors.white : Colors.black,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        task.title.toUpperCase(),
                        style: NeoTypography.headline(
                          color: isFocused ? Colors.white : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- "NEXT" UPCOMING QUEUE ---
  Widget _buildNextQueue(BuildContext context, List<TaskModel> tasks) {
    final colors = context.neo;
    final now = DateTime.now();

    final upcoming = tasks.where((t) => !t.isArchived && t.status == TaskStatus.pending && t.endAt.isAfter(now)).toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));

    if (upcoming.isEmpty) return const SizedBox.shrink();

    final nextThree = upcoming.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NEXT UP',
          style: NeoTypography.label(
            color: colors.textSecondary,
            fontSize: 12,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        ...nextThree.map((task) {
          final timeStr = DateFormat('h:mm a').format(task.startAt);
          final durationMins = task.endAt.difference(task.startAt).inMinutes;
          final obsStore = ref.watch(observationStoreProvider);
          final lastObs = obsStore.getObservationsForTask(task.title).lastOrNull;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border.all(color: colors.border, width: 2.5),
              boxShadow: NeoShadows.small(colors.shadow),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: colors.accentYellow,
                        border: Border.all(color: colors.border, width: 2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title.toUpperCase(),
                            style: NeoTypography.headline(
                              color: colors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '$timeStr · ${durationMins}m',
                            style: NeoTypography.body(
                              color: colors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_arrow_rounded, size: 24),
                      color: colors.textPrimary,
                      onPressed: () async {
                        await ref.read(plannerActionsProvider).enterFocusMode(taskId: task.id);
                      },
                    ),
                  ],
                ),
                if (lastObs?.reason != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.canvas,
                      border: Border.all(color: colors.border, width: 1.5),
                    ),
                    child: Text(
                      '💡 ${lastObs!.reason}',
                      style: NeoTypography.label(
                        color: colors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  // --- LOADING & ERROR STATES ---
  Widget _buildLoadingCard(BuildContext context) {
    final colors = context.neo;
    return NeoCard(
      backgroundColor: colors.surface,
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String error) {
    final colors = context.neo;
    return NeoCard(
      backgroundColor: colors.accentRed,
      child: Text(
        'Error: $error',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // --- ACTIONS & SHEETS ---
  void _openChecklist(TaskModel task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChecklistSheet(
        task: task,
        onToggle: (index, val) async {
          await ref.read(plannerActionsProvider).toggleChecklist(task, index, val);
        },
        onManualComplete: () async {
          await ref.read(plannerActionsProvider).quickComplete(task);
          if (mounted) Navigator.pop(context);
        },
      ),
    );
  }

  void _openQuickTaskSheet(BuildContext context) {
    NeoTaskCaptureSheet.show(context);
  }

  void _openWhatCanIDoSheet(BuildContext context, List<TaskModel> allTasks) {
    final colors = context.neo;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: colors.canvas,
            border: Border(
              top: BorderSide(color: colors.border, width: 4),
              left: BorderSide(color: colors.border, width: 3),
              right: BorderSide(color: colors.border, width: 3),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            24 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '⚡ YOU HAVE 45 MINUTES FREE',
                style: NeoTypography.headline(
                  color: colors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Here are 3 quick actions you can execute right now:',
                style: NeoTypography.body(color: colors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 14),
              _microTaskOption(context, 'Reply to important emails', 15),
              _microTaskOption(context, 'Review today\'s notes', 20),
              _microTaskOption(context, 'Take a quick refreshing walk', 15),
            ],
          ),
        );
      },
    );
  }

  Widget _microTaskOption(BuildContext context, String title, int durationMins) {
    final colors = context.neo;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border, width: 2.5),
        boxShadow: NeoShadows.small(colors.shadow),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: NeoTypography.headline(
                    color: colors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '${durationMins} min sprint',
                  style: NeoTypography.body(
                    color: colors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          NeoButton(
            text: 'START',
            variant: NeoButtonVariant.accentYellow,
            fontSize: 12,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            onPressed: () async {
              Navigator.pop(context);
              final now = DateTime.now();
              final task = TaskModel()
                ..title = title
                ..startAt = now
                ..endAt = now.add(Duration(minutes: durationMins))
                ..checklist = [ChecklistItemModel(text: 'Sprint finished', isChecked: false)];

              await ref.read(plannerActionsProvider).saveTask(task);
              await ref.read(plannerActionsProvider).enterFocusMode(taskId: task.id);
            },
          ),
        ],
      ),
    );
  }

  void _startMovementJourney(BuildContext context) {
    final journeyService = ref.read(journeyServiceProvider);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JourneyScreen(
          journeyService: journeyService,
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _handleAutoPlan(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          '⚡ Auto-Plan analyzed your day and optimized timeline slots!',
          style: NeoTypography.body(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning, Sharan';
    if (hour < 17) return 'Good Afternoon, Sharan';
    return 'Good Evening, Sharan';
  }
}
