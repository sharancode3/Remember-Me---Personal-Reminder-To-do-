import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/neo_colors.dart';
import '../../core/theme/neo_shadows.dart';
import '../../core/theme/neo_typography.dart';
import '../../core/widgets/neo_button.dart';
import '../../core/widgets/neo_card.dart';
import '../../data/models/task_model.dart';
import '../providers/providers.dart';

class NeoNotificationCenterSheet extends ConsumerWidget {
  const NeoNotificationCenterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NeoNotificationCenterSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.neo;
    final tasksAsync = ref.watch(tasksForSelectedDayProvider);

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
        14,
        20,
        24 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: colors.border,
                border: Border.all(color: colors.border, width: 1),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.accentYellow,
                  border: Border.all(color: colors.border, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active, size: 16, color: Colors.black),
                    const SizedBox(width: 6),
                    Text(
                      'NOTIFICATIONS & REMINDERS',
                      style: NeoTypography.label(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colors.accentRed,
                    border: Border.all(color: colors.border, width: 2),
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Subtitle
          Text(
            'Active local reminders & smart scheduling alerts:',
            style: NeoTypography.body(color: colors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 14),

          tasksAsync.when(
            data: (tasks) {
              final activeWithReminders = tasks
                  .where((t) => !t.isArchived && t.reminderOffsetMinutes != -1)
                  .toList()
                ..sort((a, b) => a.startAt.compareTo(b.startAt));

              if (activeWithReminders.isEmpty) {
                return NeoCard(
                  backgroundColor: colors.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.notifications_off_outlined, size: 36, color: colors.textSecondary),
                          const SizedBox(height: 8),
                          Text(
                            'NO PENDING ALERTS',
                            style: NeoTypography.headline(color: colors.textPrimary, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Scheduled tasks with reminders will appear here.',
                            style: NeoTypography.body(color: colors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 340),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: activeWithReminders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final task = activeWithReminders[index];
                    final triggerAt = task.startAt.subtract(
                      Duration(minutes: task.reminderOffsetMinutes),
                    );
                    final timeStr = DateFormat('h:mm a').format(triggerAt);
                    final isOverdue = task.endAt.isBefore(DateTime.now()) &&
                        task.status != TaskStatus.completed;

                    return NeoCard(
                      backgroundColor: isOverdue ? colors.accentRed : colors.surface,
                      borderColor: colors.border,
                      borderWidth: 2.5,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            color: isOverdue ? Colors.black : colors.accentYellow,
                            child: Text(
                              isOverdue ? 'OVERDUE' : 'REMIND $timeStr',
                              style: NeoTypography.label(
                                color: isOverdue ? Colors.white : Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title.toUpperCase(),
                                  style: NeoTypography.headline(
                                    color: isOverdue ? Colors.white : colors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Starts ${DateFormat('h:mm a').format(task.startAt)} (${task.reminderOffsetMinutes}m offset)',
                                  style: NeoTypography.body(
                                    color: isOverdue
                                        ? Colors.white70
                                        : colors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: isOverdue ? Colors.white : colors.textPrimary,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              ref.read(plannerActionsProvider).enterFocusMode(taskId: task.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
          ),

          const SizedBox(height: 16),
          NeoButton(
            text: 'DISMISS',
            variant: NeoButtonVariant.surface,
            isFullWidth: true,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
