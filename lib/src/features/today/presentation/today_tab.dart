import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/ui_helpers.dart';
import '../../../data/models/task_model.dart';
import '../../../presentation/providers/daily_providers.dart';
import '../../tasks/presentation/quick_add_bar.dart';
import '../../tasks/presentation/task_editor_sheet.dart';
import '../../tasks/presentation/task_row.dart';

class TodayTab extends ConsumerWidget {
  const TodayTab({super.key, required this.onTrail});
  final VoidCallback onTrail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(dailyDateProvider);
    final isToday = day == dayOnly(DateTime.now());

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isToday ? 'Today' : DateFormat('EEEE').format(day),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMMM d, yyyy').format(day),
                    style: const TextStyle(
                      color: Color(0xFF68756E),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Choose day',
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: day,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (selected != null) {
                  ref.read(dailyDateProvider.notifier).state = selected;
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        QuickAddBar(selectedDate: day),
        const SizedBox(height: 16),
        DaySummary(onTrail: onTrail),
        const SizedBox(height: 28),
        const TodayTaskLists(),
      ],
    );
  }
}

class DaySummary extends ConsumerWidget {
  const DaySummary({super.key, required this.onTrail});
  final VoidCallback onTrail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(dailyTasksProvider).valueOrNull ?? [];
    final completed = tasks
        .where((t) => t.status == TaskStatus.completed)
        .length;
    final minutes = ref.watch(dailyFocusMinutesProvider).valueOrNull ?? 0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _metric(
                '$completed / ${tasks.length}',
                'Done',
                Icons.check_circle_outline,
                const Color(0xFF18765C),
              ),
            ),
            Expanded(
              child: _metric(
                '${minutes}m',
                'Focused',
                Icons.timelapse,
                const Color(0xFF3577B5),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: onTrail,
                borderRadius: BorderRadius.circular(8),
                child: _metric(
                  'View',
                  'Daily trail',
                  Icons.route,
                  const Color(0xFFB45D72),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: tasks.isEmpty ? 0 : completed / tasks.length,
            minHeight: 5,
            backgroundColor: const Color(0xFFE4EBE7),
          ),
        ),
      ],
    );
  }

  Widget _metric(String value, String label, IconData icon, Color color) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF68756E), fontSize: 12),
            ),
          ],
        ),
      );
}

class TodayTaskLists extends ConsumerWidget {
  const TodayTaskLists({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(dailyTasksProvider)
      .when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('Could not load this day. ${readableError(e)}'),
        data: (tasks) {
          final reminders = tasks
              .where((t) => t.reminderOffsetMinutes >= 0)
              .toList();
          final todos = tasks
              .where((t) => t.reminderOffsetMinutes < 0)
              .toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _section('Reminders', reminders.length),
              if (reminders.isEmpty)
                const EmptyTaskLine(
                  icon: Icons.notifications_none_rounded,
                  text: 'No reminders for this day.',
                ),
              ...reminders.map((t) => TaskRow(task: t)),
              const SizedBox(height: 28),
              _section('To-do', todos.length),
              if (todos.isEmpty)
                const EmptyTaskLine(
                  icon: Icons.checklist_rounded,
                  text: 'A little space for what needs doing.',
                ),
              ...todos.map((t) => TaskRow(task: t)),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: () => showDailyEditor(context, ref),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add something'),
              ),
            ],
          );
        },
      );

  Widget _section(String label, int count) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 8),
        Text('$count', style: const TextStyle(color: Color(0xFF68756E))),
      ],
    ),
  );
}

class EmptyTaskLine extends StatelessWidget {
  const EmptyTaskLine({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Row(
      children: [
        Icon(icon, color: const Color(0xFF81958A)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: const TextStyle(color: Color(0xFF68756E))),
        ),
      ],
    ),
  );
}
