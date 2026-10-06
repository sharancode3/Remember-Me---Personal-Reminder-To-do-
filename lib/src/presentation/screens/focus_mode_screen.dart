import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/neo_colors.dart';
import '../../core/theme/neo_shadows.dart';
import '../../core/theme/neo_typography.dart';
import '../../core/widgets/neo_bandaid_alarm_logo.dart';
import '../../core/widgets/neo_button.dart';
import '../../core/widgets/neo_card.dart';
import '../../data/models/task_model.dart';
import '../providers/providers.dart';

class FocusModeScreen extends ConsumerStatefulWidget {
  const FocusModeScreen({super.key});

  @override
  ConsumerState<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends ConsumerState<FocusModeScreen> {
  Timer? _ticker;
  int _extraMinutes = 0;
  bool _isPaused = false;
  int _pausedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && !_isPaused) {
        setState(() {});
      } else if (mounted && _isPaused) {
        _pausedSeconds++;
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focus = ref.watch(focusModeProvider);
    final tasks = ref.watch(tasksForSelectedDayProvider).valueOrNull ?? const <TaskModel>[];
    final active = tasks.where((task) => task.id == focus.activeTaskId).cast<TaskModel?>().firstWhere(
          (task) => task != null,
          orElse: () => null,
        );

    final colors = context.neo;
    final startedAt = focus.startedAt ?? DateTime.now();
    final plannedDurationMinutes = (active != null)
        ? active.endAt.difference(active.startAt).inMinutes + _extraMinutes
        : 30 + _extraMinutes;

    final elapsed = DateTime.now().difference(startedAt);
    final totalPlannedSeconds = plannedDurationMinutes * 60;
    final remainingSeconds = (totalPlannedSeconds - elapsed.inSeconds).clamp(-99999, totalPlannedSeconds);

    final isOvertime = remainingSeconds < 0;
    final absRemaining = remainingSeconds.abs();
    final mm = (absRemaining ~/ 60).toString().padLeft(2, '0');
    final ss = (absRemaining % 60).toString().padLeft(2, '0');

    final progressRatio = (elapsed.inSeconds / totalPlannedSeconds).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar with Bandaid Alarm Logo & Exit
              Row(
                children: [
                  NeoBandaidAlarmLogo(
                    size: 32,
                    alarmColor: colors.accentYellow,
                    bandaidColor: colors.accentRed,
                    borderColor: colors.border,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'FOCUS MODE',
                    style: NeoTypography.headline(
                      color: colors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => ref.read(plannerActionsProvider).exitFocusMode(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        border: Border.all(color: colors.border, width: 2.5),
                        boxShadow: NeoShadows.small(colors.shadow),
                      ),
                      child: Text(
                        'EXIT',
                        style: NeoTypography.label(
                          color: colors.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 2. Active Task Hero Banner
              if (active != null)
                NeoCard(
                  backgroundColor: colors.accentViolet,
                  borderColor: colors.border,
                  borderWidth: 3.5,
                  padding: const EdgeInsets.all(16),
                  shadowOffset: const Offset(6, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (active.tag != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: colors.accentYellow,
                            border: Border.all(color: colors.border, width: 2),
                          ),
                          child: Text(
                            active.tag!.name.toUpperCase(),
                            style: NeoTypography.label(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      Text(
                        active.title.toUpperCase(),
                        style: NeoTypography.headline(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 28),

              // 3. Giant Space Grotesk Countdown Display Box
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                        decoration: BoxDecoration(
                          color: isOvertime ? colors.accentRed : colors.surface,
                          border: Border.all(color: colors.border, width: 4.0),
                          boxShadow: NeoShadows.large(colors.shadow),
                        ),
                        child: Column(
                          children: [
                            if (isOvertime)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                margin: const EdgeInsets.only(bottom: 8),
                                color: Colors.black,
                                child: Text(
                                  '⚠️ OVERTIME',
                                  style: NeoTypography.label(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            Text(
                              isOvertime ? '+$mm:$ss' : '$mm:$ss',
                              style: NeoTypography.display(
                                color: isOvertime ? Colors.white : colors.textPrimary,
                                fontSize: 64,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -2.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isPaused ? 'PAUSED' : 'REMAINING TIME',
                              style: NeoTypography.label(
                                color: isOvertime ? Colors.white.withValues(alpha: 0.9) : colors.textSecondary,
                                fontSize: 12,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Mechanical Progress Bar
                      Container(
                        width: double.infinity,
                        height: 20,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          border: Border.all(color: colors.border, width: 2.5),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progressRatio,
                          child: Container(
                            color: isOvertime ? colors.accentRed : colors.accentYellow,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Checklist Items Preview
              if (active != null && active.checklist.isNotEmpty) ...[
                Text(
                  'CHECKLIST PROGRESS',
                  style: NeoTypography.label(color: colors.textSecondary, fontSize: 11),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    border: Border.all(color: colors.border, width: 2.5),
                  ),
                  child: Column(
                    children: active.checklist.take(3).map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: item.isChecked ? colors.accentYellow : colors.canvas,
                                border: Border.all(color: colors.border, width: 2),
                              ),
                              child: item.isChecked
                                  ? const Icon(Icons.check, size: 10, color: Colors.black)
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.text,
                                style: NeoTypography.body(
                                  color: item.isChecked ? colors.textSecondary : colors.textPrimary,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // 5. Tactical Action Controls: [ PAUSE ], [ +5 MIN ], [ FINISH ✓ ]
              Row(
                children: [
                  Expanded(
                    child: NeoButton(
                      text: _isPaused ? 'RESUME' : 'PAUSE',
                      variant: NeoButtonVariant.surface,
                      onPressed: () {
                        setState(() => _isPaused = !_isPaused);
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: NeoButton(
                      text: '+5 MIN',
                      variant: NeoButtonVariant.accentYellow,
                      onPressed: () {
                        setState(() => _extraMinutes += 5);
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: NeoButton(
                      text: 'FINISH ✓',
                      variant: NeoButtonVariant.accentRed,
                      onPressed: () async {
                        if (active != null) {
                          await ref.read(plannerActionsProvider).quickComplete(active);
                        }
                        if (mounted) {
                          await ref.read(plannerActionsProvider).exitFocusMode();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
