import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/neo_colors.dart';
import '../../core/theme/neo_shadows.dart';
import '../../core/theme/neo_typography.dart';
import '../../data/models/task_model.dart';

class TaskBlockCard extends StatelessWidget {
  const TaskBlockCard({
    super.key,
    required this.task,
    required this.onTap,
    this.onLongPress,
    this.onQuickComplete,
    this.onDelete,
    this.isFocused = false,
  });

  final TaskModel task;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onQuickComplete;
  final VoidCallback? onDelete;
  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    final colors = context.neo;
    final isDone = task.status == TaskStatus.completed;
    final timeStr =
        '${DateFormat('h:mm a').format(task.startAt)} – ${DateFormat('h:mm a').format(task.endAt)}';

    Color cardBg = colors.surface;
    if (isDone) {
      cardBg = colors.canvas;
    } else if (isFocused) {
      cardBg = colors.accentRed;
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          border: Border.all(
            color: colors.border,
            width: isFocused ? 3.5 : 2.5,
          ),
          boxShadow: isDone ? null : NeoShadows.small(colors.shadow),
        ),
        child: Row(
          children: [
            // Checkmark button
            GestureDetector(
              onTap: onQuickComplete,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isDone ? colors.accentYellow : colors.canvas,
                  border: Border.all(color: colors.border, width: 2),
                ),
                child: isDone
                    ? const Icon(Icons.check, size: 12, color: Colors.black)
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    task.title.toUpperCase(),
                    style: NeoTypography.headline(
                      color: isFocused
                          ? Colors.white
                          : (isDone ? colors.textSecondary : colors.textPrimary),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeStr,
                    style: NeoTypography.body(
                      color: isFocused
                          ? Colors.white70
                          : colors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (task.tag != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.accentViolet.withValues(alpha: 0.5),
                  border: Border.all(color: colors.border, width: 1.5),
                ),
                child: Text(
                  task.tag!.name.toUpperCase(),
                  style: NeoTypography.label(
                    color: Colors.black,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
