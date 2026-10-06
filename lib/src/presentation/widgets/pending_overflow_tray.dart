import 'package:flutter/material.dart';

import '../../core/widgets/neo_card.dart';
import '../../core/widgets/pressable_action.dart';
import '../../data/models/task_model.dart';

class PendingOverflowTray extends StatelessWidget {
  const PendingOverflowTray({
    super.key,
    required this.tasks,
    this.onTapTask,
  });

  final List<TaskModel> tasks;
  final ValueChanged<TaskModel>? onTapTask;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox.shrink();

    return NeoCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pending from yesterday',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Draggable<TaskModel>(
                  data: task,
                  feedback: Material(
                    color: Colors.transparent,
                    child: Transform.scale(
                      scale: 1.03,
                      child: Container(
                        width: 170,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white.withValues(alpha: 0.14),
                          border: Border.all(color: Colors.white30),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 14,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(task.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.4,
                    child: _chip(context, task),
                  ),
                  child: PressableAction(
                    onTap: () => onTapTask?.call(task),
                    child: _chip(context, task),
                  ),
                );
              },
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemCount: tasks.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, TaskModel task) {
    return Container(
      width: 170,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text('Drag to reschedule', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}
