import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/neo_colors.dart';
import '../../core/theme/neo_shadows.dart';
import '../../core/theme/neo_typography.dart';
import '../../core/widgets/neo_button.dart';
import '../../core/widgets/neo_card.dart';
import '../../data/models/routine_template_model.dart';
import '../../data/models/task_model.dart';
import '../providers/providers.dart';
import '../widgets/checklist_sheet.dart';
import 'neo_task_capture_sheet.dart';

enum PlanViewMode { day, week, month }

class PlanScreen extends ConsumerStatefulWidget {
  const PlanScreen({super.key});

  @override
  ConsumerState<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends ConsumerState<PlanScreen> {
  PlanViewMode _viewMode = PlanViewMode.day;

  @override
  Widget build(BuildContext context) {
    final colors = context.neo;
    final selectedDay = ref.watch(selectedDayProvider);

    return Column(
      children: [
        // 1. Lens Switcher Header (DAY | WEEK | MONTH) + Date Navigator
        _buildLensHeader(context, selectedDay),

        // 2. Main Content Area based on Lens
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: _buildCurrentLens(context, selectedDay),
          ),
        ),
      ],
    );
  }

  // --- LENS SWITCHER HEADER ---
  Widget _buildLensHeader(BuildContext context, DateTime selectedDay) {
    final colors = context.neo;
    final monthStr = DateFormat('MMMM yyyy').format(selectedDay).toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          bottom: BorderSide(color: colors.border, width: 3.5),
        ),
      ),
      child: Column(
        children: [
          // Month / Week Shift Controls
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 20),
                onPressed: () {
                  final shift = _viewMode == PlanViewMode.month ? 30 : (_viewMode == PlanViewMode.week ? 7 : 1);
                  ref.read(selectedDayProvider.notifier).state = selectedDay.subtract(Duration(days: shift));
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    monthStr,
                    style: NeoTypography.headline(
                      color: colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, size: 20),
                onPressed: () {
                  final shift = _viewMode == PlanViewMode.month ? 30 : (_viewMode == PlanViewMode.week ? 7 : 1);
                  ref.read(selectedDayProvider.notifier).state = selectedDay.add(Duration(days: shift));
                },
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 3-Way Segmented Lens: [ DAY ] [ WEEK ] [ MONTH ]
          Row(
            children: [
              _lensSegment(context, 'DAY', PlanViewMode.day, colors.accentYellow),
              const SizedBox(width: 8),
              _lensSegment(context, 'WEEK', PlanViewMode.week, colors.accentViolet),
              const SizedBox(width: 8),
              _lensSegment(context, 'MONTH', PlanViewMode.month, colors.accentRed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _lensSegment(BuildContext context, String label, PlanViewMode mode, Color activeColor) {
    final colors = context.neo;
    final isSel = _viewMode == mode;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _viewMode = mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSel ? activeColor : colors.canvas,
            border: Border.all(
              color: colors.border,
              width: isSel ? 3.0 : 2.0,
            ),
            boxShadow: isSel ? NeoShadows.small(colors.shadow) : null,
          ),
          child: Center(
            child: Text(
              label,
              style: NeoTypography.label(
                color: (isSel && activeColor == colors.accentRed) ? Colors.white : Colors.black,
                fontSize: 12,
                fontWeight: isSel ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- LENS SWITCHER ---
  Widget _buildCurrentLens(BuildContext context, DateTime selectedDay) {
    switch (_viewMode) {
      case PlanViewMode.day:
        return _buildDayLens(context, selectedDay);
      case PlanViewMode.week:
        return _buildWeekLens(context, selectedDay);
      case PlanViewMode.month:
        return _buildMonthLens(context, selectedDay);
    }
  }

  // --- 1. DAY LENS: ROUTINE INSERTION + DETAILED TIMELINE ---
  Widget _buildDayLens(BuildContext context, DateTime selectedDay) {
    final colors = context.neo;
    final tasksAsync = ref.watch(tasksForSelectedDayProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Day Focus & Date Header Summary
          tasksAsync.when(
            data: (tasks) {
              final active = tasks.where((t) => !t.isArchived).toList();
              final totalMins = active.fold<int>(
                0,
                (sum, t) => sum + t.endAt.difference(t.startAt).inMinutes,
              );
              final completed = active.where((t) => t.status == TaskStatus.completed).length;
              final dateFormatted = DateFormat('EEEE, MMMM d').format(selectedDay).toUpperCase();

              return NeoCard(
                backgroundColor: colors.surface,
                borderColor: colors.border,
                borderWidth: 3.0,
                shadowOffset: const Offset(4, 4),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: colors.accentYellow,
                      child: Text(
                        'DAY SUMMARY',
                        style: NeoTypography.label(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateFormatted,
                            style: NeoTypography.label(
                              color: colors.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${active.length} TASKS · ${(totalMins / 60.0).toStringAsFixed(1)}H PLANNED ($completed DONE)',
                            style: NeoTypography.body(
                              color: colors.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 14),

          // Routines Quick Insertion Deck
          Text(
            'QUICK ROUTINE INSERTS',
            style: NeoTypography.label(color: colors.textSecondary, fontSize: 11),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _routineInsertChip(
                  context,
                  title: 'MORNING RITUAL',
                  durationMins: 45,
                  color: colors.accentYellow,
                  icon: Icons.wb_sunny_rounded,
                  startHour: 7,
                ),
                const SizedBox(width: 8),
                _routineInsertChip(
                  context,
                  title: 'DEEP WORK SPRINT',
                  durationMins: 90,
                  color: colors.accentViolet,
                  icon: Icons.bolt_rounded,
                  startHour: 10,
                ),
                const SizedBox(width: 8),
                _routineInsertChip(
                  context,
                  title: 'WORKOUT & GYM',
                  durationMins: 60,
                  color: colors.accentRed,
                  icon: Icons.fitness_center_rounded,
                  startHour: 18,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Day Timeline Schedule List
          Text(
            'SCHEDULED TASKS',
            style: NeoTypography.label(color: colors.textSecondary, fontSize: 11),
          ),
          const SizedBox(height: 8),
          tasksAsync.when(
            data: (tasks) {
              final active = tasks.where((t) => !t.isArchived).toList()
                ..sort((a, b) => a.startAt.compareTo(b.startAt));

              if (active.isEmpty) {
                return NeoCard(
                  backgroundColor: colors.surface,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 36, color: colors.textSecondary),
                          const SizedBox(height: 10),
                          Text(
                            'NO TASKS SCHEDULED',
                            style: NeoTypography.headline(color: colors.textPrimary, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap "+ Add Task" or insert a routine above to organize this day.',
                            style: NeoTypography.body(color: colors.textSecondary, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: active.map((task) {
                  final timeStr =
                      '${DateFormat('h:mm a').format(task.startAt)} – ${DateFormat('h:mm a').format(task.endAt)}';
                  final isDone = task.status == TaskStatus.completed;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDone ? colors.canvas : colors.surface,
                      border: Border.all(
                        color: colors.border,
                        width: 2.5,
                      ),
                      boxShadow: isDone ? null : NeoShadows.small(colors.shadow),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await ref.read(plannerActionsProvider).quickComplete(task);
                            HapticFeedback.selectionClick();
                          },
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: isDone ? colors.accentYellow : colors.canvas,
                              border: Border.all(color: colors.border, width: 2),
                            ),
                            child: isDone
                                ? const Icon(Icons.check, size: 14, color: Colors.black)
                                : null,
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
                                  color: isDone ? colors.textSecondary : colors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                timeStr,
                                style: NeoTypography.body(
                                  color: colors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (task.tag != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: colors.accentViolet.withValues(alpha: 0.4),
                              border: Border.all(color: colors.border, width: 1.5),
                            ),
                            child: Text(
                              task.tag!.name.toUpperCase(),
                              style: NeoTypography.label(
                                color: colors.textPrimary,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
            error: (e, _) => Text('Error: $e'),
          ),

          const SizedBox(height: 18),
          NeoButton(
            text: '+ ADD TASK TO THIS DAY',
            variant: NeoButtonVariant.accentYellow,
            isFullWidth: true,
            onPressed: () => NeoTaskCaptureSheet.show(context),
          ),
        ],
      ),
    );
  }

  Widget _routineInsertChip(
    BuildContext context, {
    required String title,
    required int durationMins,
    required Color color,
    required IconData icon,
    required int startHour,
  }) {
    final colors = context.neo;
    final isWhiteText = color == colors.accentRed;

    return GestureDetector(
      onTap: () async {
        final selectedDay = ref.read(selectedDayProvider);
        final startAt = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, startHour, 0);
        final endAt = startAt.add(Duration(minutes: durationMins));

        final task = TaskModel()
          ..title = title
          ..startAt = startAt
          ..endAt = endAt
          ..priority = 1
          ..checklist = [
            ChecklistItemModel(text: 'Part 1: Setup & Warmup', isChecked: false),
            ChecklistItemModel(text: 'Part 2: Execution', isChecked: false),
            ChecklistItemModel(text: 'Part 3: Review', isChecked: false),
          ];

        await ref.read(plannerActionsProvider).saveTask(task);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.black,
              content: Text(
                '⚡ Inserted "$title" at ${startHour}:00!',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: colors.border, width: 2.5),
          boxShadow: NeoShadows.small(colors.shadow),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isWhiteText ? Colors.white : Colors.black),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: NeoTypography.label(
                    color: isWhiteText ? Colors.white : Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '${durationMins}M · ${startHour}:00',
                  style: NeoTypography.body(
                    color: isWhiteText ? Colors.white70 : Colors.black87,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. WEEK LENS: 7-DAY WORKLOAD MATRIX ---
  Widget _buildWeekLens(BuildContext context, DateTime selectedDay) {
    final colors = context.neo;
    final weekAnchor = ref.watch(weekAnchorProvider);
    final weekStart = weekAnchor.subtract(Duration(days: weekAnchor.weekday - 1));
    final weekCompletion = ref.watch(weekDayCompletionProvider).valueOrNull ?? {};

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 7,
      itemBuilder: (context, index) {
        final day = weekStart.add(Duration(days: index));
        final isSelected = day.day == selectedDay.day && day.month == selectedDay.month;
        final completionVal = weekCompletion.entries
            .firstWhere(
              (e) => e.key.year == day.year && e.key.month == day.month && e.key.day == day.day,
              orElse: () => MapEntry(day, 0.0),
            )
            .value;

        return GestureDetector(
          onTap: () {
            ref.read(selectedDayProvider.notifier).state = day;
            setState(() => _viewMode = PlanViewMode.day);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? colors.accentYellow : colors.surface,
              border: Border.all(
                color: colors.border,
                width: isSelected ? 3.5 : 2.0,
              ),
              boxShadow: isSelected ? NeoShadows.small(colors.shadow) : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(
                    DateFormat('EEE, d MMM').format(day).toUpperCase(),
                    style: NeoTypography.label(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: colors.canvas,
                      border: Border.all(color: colors.border, width: 1.5),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: completionVal.clamp(0.0, 1.0),
                      child: Container(
                        color: colors.accentRed,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${(completionVal * 100).toInt()}%',
                  style: NeoTypography.label(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- 3. MONTH LENS: HIGH-LEVEL CALENDAR OVERVIEW ---
  Widget _buildMonthLens(BuildContext context, DateTime selectedDay) {
    final colors = context.neo;
    final firstDayOfMonth = DateTime(selectedDay.year, selectedDay.month, 1);
    final daysInMonth = DateTime(selectedDay.year, selectedDay.month + 1, 0).day;
    final startingWeekday = firstDayOfMonth.weekday; // 1 = Mon, 7 = Sun

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Weekday Labels
          Row(
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: NeoTypography.label(
                      color: colors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Month Grid
          Expanded(
            child: GridView.builder(
              itemCount: (startingWeekday - 1) + daysInMonth,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                if (index < startingWeekday - 1) {
                  return const SizedBox.shrink();
                }

                final dayNum = index - (startingWeekday - 1) + 1;
                final isSelected = selectedDay.day == dayNum;

                return GestureDetector(
                  onTap: () {
                    final newDate = DateTime(selectedDay.year, selectedDay.month, dayNum);
                    ref.read(selectedDayProvider.notifier).state = newDate;
                    setState(() => _viewMode = PlanViewMode.day);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? colors.accentYellow : colors.surface,
                      border: Border.all(
                        color: colors.border,
                        width: isSelected ? 3.0 : 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$dayNum',
                        style: NeoTypography.headline(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
