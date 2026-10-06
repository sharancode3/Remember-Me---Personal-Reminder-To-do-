import 'package:flutter/material.dart';

import '../../core/widgets/neo_card.dart';
import '../../data/models/task_model.dart';

class InProgressBanner extends StatelessWidget {
  const InProgressBanner({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF63F5A9),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'In Progress • ${task.title}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
