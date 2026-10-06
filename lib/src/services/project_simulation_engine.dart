import 'dart:math';
import 'package:flutter/foundation.dart';
import '../data/models/task_model.dart';
import 'master_adaptive_day_orchestrator.dart';
import 'personal_planning_profile.dart';

/// Project Risk Status
enum ProjectRiskStatus {
  safe,
  watch,
  atRisk,
}

/// A structured Project entity
@immutable
class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.name,
    required this.goal,
    required this.deadline,
    required this.totalRequiredEffortMinutes,
    required this.completedEffortMinutes,
    required this.subtaskTitles,
    this.priority = 1,
  });

  final String id;
  final String name;
  final String goal;
  final DateTime deadline;
  final int totalRequiredEffortMinutes;
  final int completedEffortMinutes;
  final List<String> subtaskTitles;
  final int priority;

  int get remainingEffortMinutes => max(0, totalRequiredEffortMinutes - completedEffortMinutes);
  double get completionRatio => totalRequiredEffortMinutes > 0 ? (completedEffortMinutes / totalRequiredEffortMinutes).clamp(0.0, 1.0) : 0.0;
}

/// Result of a Counterfactual "What If?" Schedule Simulation
@immutable
class WhatIfSimulationResult {
  const WhatIfSimulationResult({
    required this.proposedScenario,
    required this.isFeasible,
    required this.impactedTaskTitles,
    required this.downstreamShiftMinutes,
    required this.deadlineRiskImpact,
    required this.explanation,
  });

  final String proposedScenario;
  final bool isFeasible;
  final List<String> impactedTaskTitles;
  final int downstreamShiftMinutes;
  final ProjectRiskStatus deadlineRiskImpact;
  final String explanation;
}

/// Project & Counterfactual Simulation Intelligence Engine
class ProjectSimulationEngine {
  ProjectSimulationEngine({
    required MasterAdaptiveDayOrchestrator orchestrator,
    required PersonalPlanningProfile profile,
  })  : _orchestrator = orchestrator,
        _profile = profile;

  final MasterAdaptiveDayOrchestrator _orchestrator;
  final PersonalPlanningProfile _profile;

  /// Evaluates mathematical feasibility and risk status of a project
  ProjectRiskStatus evaluateProjectRisk({
    required ProjectModel project,
    required int availableSchedulableMinutesUntilDeadline,
  }) {
    final remaining = project.remainingEffortMinutes;
    // Account for learned duration bias
    final estimatedRealNeed = (remaining * _profile.overallDurationBias).round();

    if (estimatedRealNeed > availableSchedulableMinutesUntilDeadline) {
      return ProjectRiskStatus.atRisk;
    } else if (estimatedRealNeed > (availableSchedulableMinutesUntilDeadline * 0.80)) {
      return ProjectRiskStatus.watch;
    }
    return ProjectRiskStatus.safe;
  }

  /// Distributes project effort into optimal daily session blocks across available days
  List<int> planProjectSessions({
    required ProjectModel project,
    required int daysUntilDeadline,
    required int dailyMaxDeepWorkMinutes,
  }) {
    if (daysUntilDeadline <= 0) return [project.remainingEffortMinutes];

    final sessions = <int>[];
    var remaining = project.remainingEffortMinutes;
    final idealSession = min(90, dailyMaxDeepWorkMinutes); // Cap single deep work block to 90m

    for (int day = 0; day < daysUntilDeadline; day++) {
      if (remaining <= 0) break;
      final allocated = min(remaining, idealSession);
      sessions.add(allocated);
      remaining -= allocated;
    }
    return sessions;
  }

  /// "What If?" Counterfactual Simulation: Previews downstream impact before moving a task
  WhatIfSimulationResult simulateTaskMove({
    required TaskModel taskToMove,
    required DateTime proposedNewStart,
    required List<TaskModel> allScheduledTasks,
    required DateTime hardSleepTime,
  }) {
    final taskDuration = taskToMove.endAt.difference(taskToMove.startAt);
    final proposedEnd = proposedNewStart.add(taskDuration);

    final affected = allScheduledTasks.where((t) {
      if (t.id == taskToMove.id || t.isArchived) return false;
      // Overlaps or pushes downstream
      return !proposedEnd.isBefore(t.startAt) && !proposedNewStart.isAfter(t.endAt);
    }).toList();

    final shiftMins = taskDuration.inMinutes + 10; // includes buffer
    final wouldExceedSleep = proposedEnd.isAfter(hardSleepTime);

    if (wouldExceedSleep) {
      return WhatIfSimulationResult(
        proposedScenario: 'Move ${taskToMove.title} to ${proposedNewStart.hour}:${proposedNewStart.minute.toString().padLeft(2, '0')}',
        isFeasible: false,
        impactedTaskTitles: affected.map((t) => t.title).toList(),
        downstreamShiftMinutes: shiftMins,
        deadlineRiskImpact: ProjectRiskStatus.atRisk,
        explanation: '❌ Collides with hard sleep time. Downstream tasks will be cut off.',
      );
    }

    if (affected.isEmpty) {
      return WhatIfSimulationResult(
        proposedScenario: 'Move ${taskToMove.title} to ${proposedNewStart.hour}:${proposedNewStart.minute.toString().padLeft(2, '0')}',
        isFeasible: true,
        impactedTaskTitles: [],
        downstreamShiftMinutes: 0,
        deadlineRiskImpact: ProjectRiskStatus.safe,
        explanation: '✓ Clean move: Zero downstream task collision.',
      );
    }

    return WhatIfSimulationResult(
      proposedScenario: 'Move ${taskToMove.title} to ${proposedNewStart.hour}:${proposedNewStart.minute.toString().padLeft(2, '0')}',
      isFeasible: true,
      impactedTaskTitles: affected.map((t) => t.title).toList(),
      downstreamShiftMinutes: shiftMins,
      deadlineRiskImpact: affected.any((t) => t.priority >= 2) ? ProjectRiskStatus.watch : ProjectRiskStatus.safe,
      explanation: '⚠️ Shifts ${affected.length} tasks downstream (~${shiftMins}m ripple buffer).',
    );
  }
}
