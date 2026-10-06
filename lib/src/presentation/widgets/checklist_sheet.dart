import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/pressable_action.dart';
import '../../data/models/task_model.dart';
import 'task_block_card.dart';

class ChecklistSheet extends StatefulWidget {
  const ChecklistSheet({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onManualComplete,
  });

  final TaskModel task;
  final Future<void> Function(int index, bool value) onToggle;
  final Future<void> Function() onManualComplete;

  @override
  State<ChecklistSheet> createState() => _ChecklistSheetState();
}

class _ChecklistSheetState extends State<ChecklistSheet> {
  late final List<ChecklistItemModel> _items;
  bool _allDonePulse = false;
  final Set<int> _pulsing = <int>{};

  @override
  void initState() {
    super.initState();
    _items = widget.task.checklist
        .map((item) => ChecklistItemModel(text: item.text, isChecked: item.isChecked))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = _items.length;
    final completedItems = _items.where((item) => item.isChecked).length;
    final completion = totalItems == 0 ? 0.0 : completedItems / totalItems;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: AppTheme.micro,
              curve: Curves.easeInOutCubic,
              scale: _allDonePulse ? 1.02 : 1,
              child: TaskBlockCard(task: widget.task, onTap: () {}),
            ),
            const SizedBox(height: 10),
            if (_items.isNotEmpty) ...[
              Row(
                children: [
                  Text(
                    'Checklist ${(completion * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: completion,
                        minHeight: 6,
                        backgroundColor: Colors.white12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (_items.isEmpty)
              PressableAction(
                onTap: widget.onManualComplete,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Center(child: Text('Mark Completed')),
                ),
              )
            else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                      gradient: item.isChecked
                          ? RadialGradient(
                              center: Alignment.centerLeft,
                              radius: 2,
                              colors: [
                                Colors.white.withValues(alpha: 0.08),
                                Colors.transparent,
                              ],
                            )
                          : null,
                    ),
                    child: ListTile(
                      leading: AnimatedScale(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeInOutCubic,
                        scale: _pulsing.contains(index) ? 1.2 : 1,
                        child: Checkbox(
                          value: item.isChecked,
                          onChanged: (value) async {
                            final next = value ?? false;
                            setState(() {
                              _items[index].isChecked = next;
                              _pulsing.add(index);
                            });
                            widget.task.checklist[index].isChecked = next;
                            await HapticFeedback.selectionClick();
                            await widget.onToggle(index, next);
                            if (!mounted) return;
                            await Future<void>.delayed(const Duration(milliseconds: 180));
                            if (mounted) {
                              setState(() => _pulsing.remove(index));
                            }

                            final done = _items.isNotEmpty && _items.every((entry) => entry.isChecked);
                            if (done) {
                              setState(() => _allDonePulse = true);
                              await HapticFeedback.mediumImpact();
                              await Future<void>.delayed(const Duration(milliseconds: 180));
                              if (mounted) {
                                setState(() => _allDonePulse = false);
                              }
                            }
                          },
                        ),
                      ),
                      title: LayoutBuilder(
                        builder: (context, constraints) {
                          final maxWidth = constraints.maxWidth;
                          return Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 180),
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: item.isChecked ? Colors.white70 : Colors.white,
                                    ),
                                child: Text(item.text),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOutCubic,
                                width: item.isChecked ? maxWidth : 0,
                                height: 1.4,
                                color: Colors.white70,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
