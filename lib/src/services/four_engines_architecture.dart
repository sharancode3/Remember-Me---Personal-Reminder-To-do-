import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/utils/natural_language_parser.dart';
import '../data/models/task_model.dart';
import 'context_engine.dart';
import 'personal_prediction_engine.dart';

/// 1. INPUT ENGINE: Decodes what the user wants into structured intent
@immutable
class UserIntent {
  const UserIntent({
    required this.rawInput,
    required this.parsedTask,
    required this.isConstraintScheduleRequest,
    this.requestedDeadline,
    this.requestedCategory = 'general',
  });

  final String rawInput;
  final ParsedTaskInput parsedTask;
  final bool isConstraintScheduleRequest;
  final DateTime? requestedDeadline;
  final String requestedCategory;
}

class InputEngine {
  UserIntent processInput(String rawInput, {DateTime? referenceTime}) {
    final parsed = NaturalLanguageTaskParser.parse(rawInput, referenceTime: referenceTime);
    final lower = rawInput.toLowerCase();
    final isConstraint = lower.contains('before') || lower.contains('by') || lower.contains('due');

    return UserIntent(
      rawInput: rawInput,
      parsedTask: parsed,
      isConstraintScheduleRequest: isConstraint,
      requestedCategory: parsed.tag ?? 'general',
    );
  }
}

/// 2. PLANNING ENGINE: Consumes Predictions & Context Signals to optimize schedule
@immutable
class AdaptiveSchedulePlan {
  const AdaptiveSchedulePlan({
    required this.scheduledTasks,
    required this.appliedSignals,
    required this.planRevisions,
    required this.totalPlannedMinutes,
    required this.capacityUtilizationPercentage,
    required this.isFeasible,
  });

  final List<TaskModel> scheduledTasks;
  final List<PlanningSignal> appliedSignals;
  final List<PlanRevision> planRevisions;
  final int totalPlannedMinutes;
  final int capacityUtilizationPercentage;
  final bool isFeasible;
}

class AdaptivePlanningEngine {
  AdaptivePlanningEngine({
    required PersonalPredictionEngine predictionEngine,
  }) : _predictionEngine = predictionEngine;

  final PersonalPredictionEngine _predictionEngine;

  /// Generates a realistic, context-aware schedule plan
  AdaptiveSchedulePlan createAdaptivePlan({
    required List<TaskModel> existingTasks,
    required List<PlanningSignal> activeSignals,
    required DateTime targetDay,
    int maxWakingMinutes = 16 * 60, // 960 minutes
  }) {
    final scheduled = <TaskModel>[];
    final revisions = <PlanRevision>[];
    final now = DateTime.now();

    // Sort tasks: Hard commitments first, then priority, then original start time
    final sorted = List<TaskModel>.from(existingTasks)
      ..sort((a, b) {
        if (a.priority != b.priority) return b.priority.compareTo(a.priority);
        return a.startAt.compareTo(b.startAt);
      });

    var cursor = DateTime(targetDay.year, targetDay.month, targetDay.day, 9, 0);
    if (targetDay.day == now.day && now.isAfter(cursor)) {
      cursor = now.add(const Duration(minutes: 10));
    }

    int totalMins = 0;

    for (final task in sorted) {
      // 1. Get Prediction from Prediction Engine
      final prediction = _predictionEngine.predict(
        TaskPredictionContext(
          taskTitle: task.title,
          plannedDurationMinutes: task.endAt.difference(task.startAt).inMinutes,
          targetDateTime: cursor,
          category: task.tag?.name ?? 'general',
          isHardCommitment: task.priority >= 2,
        ),
      );

      final adjustedDuration = Duration(minutes: prediction.predictedDurationMinutes);
      final newStart = cursor;
      final newEnd = newStart.add(adjustedDuration);

      // Record revision if plan shifted meaningfully (> 15 min difference)
      if (task.startAt.difference(newStart).inMinutes.abs() > 15) {
        revisions.add(
          PlanRevision(
            revisionId: 'rev_${task.id}_${DateTime.now().millisecondsSinceEpoch}',
            taskId: task.id,
            taskTitle: task.title,
            originalStart: task.startAt,
            originalEnd: task.endAt,
            revisedStart: newStart,
            revisedEnd: newEnd,
            reason: 'Optimized for ${prediction.primaryFactor} with ${prediction.recommendedBufferMinutes}m buffer',
            triggeringSignal: activeSignals.isNotEmpty ? activeSignals.first.type : PlanningSignalType.lowRemainingCapacity,
            timestamp: DateTime.now(),
          ),
        );
      }

      task.startAt = newStart;
      task.endAt = newEnd;
      scheduled.add(task);

      totalMins += prediction.predictedDurationMinutes;
      // Advance cursor with recommended transition buffer
      cursor = newEnd.add(Duration(minutes: prediction.recommendedBufferMinutes));
    }

    final utilization = ((totalMins / maxWakingMinutes) * 100).round().clamp(0, 150);

    return AdaptiveSchedulePlan(
      scheduledTasks: scheduled,
      appliedSignals: activeSignals,
      planRevisions: revisions,
      totalPlannedMinutes: totalMins,
      capacityUtilizationPercentage: utilization,
      isFeasible: utilization <= 100,
    );
  }
}
