import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/ui_helpers.dart';
import '../../../data/models/task_model.dart';
import '../../../presentation/providers/daily_providers.dart';
import 'task_editor_sheet.dart';

class TaskRow extends ConsumerWidget {
  const TaskRow({super.key, required this.task});
  final TaskModel task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = task.status == TaskStatus.completed;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: done
            ? Theme.of(context).colorScheme.primary.withValues(alpha: .06)
            : Colors.white.withValues(alpha: .82),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E9E5)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: done,
            onChanged: (_) async {
              try {
                await ref.read(dailyRepositoryProvider).toggle(task);
              } catch (e) {
                if (context.mounted) showMessage(context, readableError(e));
              }
            },
          ),
          Expanded(
            child: InkWell(
              onTap: () => showDailyEditor(context, ref, task: task),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        decoration: done ? TextDecoration.lineThrough : null,
                        color: done
                            ? const Color(0xFF7D8A83)
                            : const Color(0xFF202B27),
                      ),
                    ),
                    if (task.reminderOffsetMinutes >= 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          DateFormat.jm().format(task.startAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF3577B5),
                          ),
                        ),
                      ),
                    if (task.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF68756E),
                          ),
                        ),
                      ),
                    if (task.recurrenceRule == 'occurrence')
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(Icons.repeat, size: 12),
                            SizedBox(width: 4),
                            Text('Repeating', style: TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                    if (task.resolvedPlaceTag != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.place,
                              size: 12,
                              color: Color(0xFF107C41),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              task.resolvedPlaceTag!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF107C41),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Reminder options',
            icon: const Icon(Icons.more_horiz, size: 20),
            onSelected: (value) async {
              if (value == 'edit') {
                unawaited(showDailyEditor(context, ref, task: task));
                return;
              }
              try {
                final repository = ref.read(dailyRepositoryProvider);
                if (value == 'stop') {
                  final root = await repository.find(task.templateId!);
                  if (root != null) await repository.remove(root);
                } else {
                  await repository.remove(task);
                }
              } catch (e) {
                if (context.mounted) showMessage(context, readableError(e));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              if (task.recurrenceRule == 'occurrence')
                const PopupMenuItem(
                  value: 'stop',
                  child: Text('Stop repeating'),
                ),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  task.recurrenceRule == 'occurrence'
                      ? 'Delete this day only'
                      : 'Delete',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
