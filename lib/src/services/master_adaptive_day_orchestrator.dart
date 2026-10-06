import 'dart:math';
import 'package:flutter/foundation.dart';
import '../data/models/task_model.dart';
import 'context_engine.dart';
import 'observation_store.dart';
import 'personal_planning_profile.dart';
import 'personal_prediction_engine.dart';

/// 1. TASK FRICTION & RESISTANCE PROFILE
@immutable
class TaskFrictionProfile {
  const TaskFrictionProfile({
    required this.startFriction, // 0.0 (starts immediately) to 1.0 (heavy procrastination)
    required this.completionFriction, // 0.0 to 1.0 (abandonment rate)
    required this.interruptionRisk, // 0.0 to 1.0 (probability of split focus)
    required this.recoveryCostMinutes, // Minutes required to regain focus after interruption
    required this.planGravity, // 1.0 = hard commitment (immovable), 0.2 = soft/fluid
  });

  final double startFriction;
  final double completionFriction;
  final double interruptionRisk;
  final int recoveryCostMinutes;
  final double planGravity;
}

/// 2. VARIABLE CAPACITY & ATTENTION BUDGET MODEL
@immutable
class VariableDailyCapacity {
  const VariableDailyCapacity({
    required this.totalWakingMinutes,
    required this.fixedCommitmentMinutes,
    required this.mealAndRoutineMinutes,
    required this.expectedTransitionMinutes,
    required this.fatigueBufferMinutes,
    required this.realisticSchedulableMinutes,
    required this.deepWorkBudgetMinutes,
    required this.adminBudgetMinutes,
    required this.physicalBudgetMinutes,
  });

  final int totalWakingMinutes; // e.g. 960m (16h)
  final int fixedCommitmentMinutes; // Classes, work shifts, hard appointments
  final int mealAndRoutineMinutes; // Breakfast, lunch, dinner, wind-down
  final int expectedTransitionMinutes; // Cumulative inter-task context switching
  final int fatigueBufferMinutes; // Cognitive recovery buffer
  final int realisticSchedulableMinutes; // Actual available capacity
  final int deepWorkBudgetMinutes; // Max deep focus blocks (e.g. 240m max)
  final int adminBudgetMinutes;
  final int physicalBudgetMinutes;

  int get remainingUncommittedMinutes => realisticSchedulableMinutes;

  String get formattedCapacity =>
      '${realisticSchedulableMinutes ~/ 60}h ${realisticSchedulableMinutes % 60}m Realistic Capacity';
}

/// 3. SCHEDULE SHOCK & ELASTICITY
@immutable
class ScheduleElasticity {
  const ScheduleElasticity({
    required this.earliestStart,
    required this.latestStart,
    required this.preferredStart,
    this.hardDeadline,
    this.allowedShiftMinutes = 60,
  });

  final DateTime earliestStart;
  final DateTime latestStart;
  final DateTime preferredStart;
  final DateTime? hardDeadline;
  final int allowedShiftMinutes;

  bool canFitAt(DateTime candidateTime) {
    return candidateTime.isAfter(earliestStart.subtract(const Duration(minutes: 1))) &&
        candidateTime.isBefore(latestStart.add(const Duration(minutes: 1)));
  }
}

/// 4. CANDIDATE SCHEDULE EVALUATION METRIC (Internal Plan Quality Score)
@immutable
class PlanQualityScore {
  const PlanQualityScore({
    required this.totalScore, // 0 to 100
    required this.deadlineSafetyScore,
    required this.loadBalanceScore,
    required this.contextSwitchPenalty,
    required this.bufferAdequacyScore,
    required this.userFitScore,
  });

  final double totalScore;
  final double deadlineSafetyScore;
  final double loadBalanceScore;
  final double contextSwitchPenalty; // Lower is better (fewer jarring task hops)
  final double bufferAdequacyScore;
  final double userFitScore;
}

/// 5. MASTER ADAPTIVE DAY ORCHESTRATOR
/// The unified intelligence engine powering the Adaptive Day hero loop
class MasterAdaptiveDayOrchestrator {
  MasterAdaptiveDayOrchestrator({
    required PersonalPredictionEngine predictionEngine,
    required PersonalPlanningProfile profile,
  })  : _predictionEngine = predictionEngine,
        _profile = profile;

  final PersonalPredictionEngine _predictionEngine;
  final PersonalPlanningProfile _profile;

  /// Evaluates Task Friction based on task category and title
  TaskFrictionProfile evaluateFriction(String taskTitle, String category, int priority) {
    final lowerTitle = taskTitle.toLowerCase();
    final lowerCat = category.toLowerCase();

    double startFric = 0.20;
    double compFric = 0.15;
    double intRisk = 0.20;
    int recCost = 8;
    double gravity = 0.5;

    // Hard commitments (priority 2+) have maximum plan gravity (immovable)
    if (priority >= 2 || lowerTitle.contains('exam') || lowerTitle.contains('flight') || lowerTitle.contains('doctor')) {
      gravity = 1.0;
    } else if (priority == 0 || lowerTitle.contains('optional') || lowerTitle.contains('someday')) {
      gravity = 0.2;
    }

    // High friction tasks (writing, editing, complex problem solving)
    if (lowerTitle.contains('edit') || lowerTitle.contains('write') || lowerTitle.contains('paper') || lowerCat == 'study') {
      startFric = 0.65;
      compFric = 0.35;
      intRisk = 0.40;
      recCost = 15;
    } else if (lowerTitle.contains('email') || lowerTitle.contains('text') || lowerTitle.contains('call') || lowerCat == 'admin') {
      startFric = 0.10;
      compFric = 0.05;
      intRisk = 0.15;
      recCost = 3;
    }

    return TaskFrictionProfile(
      startFriction: startFric,
      completionFriction: compFric,
      interruptionRisk: intRisk,
      recoveryCostMinutes: recCost,
      planGravity: gravity,
    );
  }

  /// Calculates Realistic Variable Daily Capacity
  VariableDailyCapacity calculateRealisticCapacity({
    required DateTime targetDay,
    required List<TaskModel> fixedCommitments,
  }) {
    final totalWaking = (16 * 60); // 960m default awake
    final fixedMins = fixedCommitments.fold<int>(
      0,
      (sum, t) => sum + t.endAt.difference(t.startAt).inMinutes,
    );
    final mealsAndRoutines = 120; // 2h meals + morning/evening routine
    final expectedTransitions = 60; // 1h total inter-task friction
    final fatigueBuffer = (totalWaking * 0.08).round(); // 8% cognitive buffer (~75m)

    final schedulable = max(0, totalWaking - fixedMins - mealsAndRoutines - expectedTransitions - fatigueBuffer);

    return VariableDailyCapacity(
      totalWakingMinutes: totalWaking,
      fixedCommitmentMinutes: fixedMins,
      mealAndRoutineMinutes: mealsAndRoutines,
      expectedTransitionMinutes: expectedTransitions,
      fatigueBufferMinutes: fatigueBuffer,
      realisticSchedulableMinutes: schedulable,
      deepWorkBudgetMinutes: min(240, (schedulable * 0.5).round()), // Max 4h deep focus
      adminBudgetMinutes: (schedulable * 0.3).round(),
      physicalBudgetMinutes: 90,
    );
  }

  /// Opportunity Detector: Context-triggered micro-opportunities
  List<PlanningSignal> detectNaturalOpportunities({
    required List<TaskModel> pendingTasks,
    required int availableGapMinutes,
    required bool isNearCommercialLocation,
    required bool isRainIncoming,
    required int remainingSteps,
  }) {
    final signals = <PlanningSignal>[];

    // Opportunity 1: Errand proximity fit
    if (isNearCommercialLocation && availableGapMinutes >= 20) {
      final errand = pendingTasks.where((t) => t.tag?.name.toLowerCase() == 'errands' || t.title.toLowerCase().contains('buy') || t.title.toLowerCase().contains('pharmacy')).firstOrNull;
      if (errand != null) {
        signals.add(
          PlanningSignal(
            type: PlanningSignalType.userNearTaskLocation,
            title: 'NATURAL OPPORTUNITY: ${errand.title.toUpperCase()}',
            description: 'You are nearby with $availableGapMinutes min free before your next task.',
            suggestedActionTitle: 'COMPLETE ERRAND NOW',
            confidence: 0.92,
            timestamp: DateTime.now(),
          ),
        );
      }
    }

    // Opportunity 2: Step Goal gap fit before weather changes
    if (remainingSteps > 1500 && availableGapMinutes >= 25 && !isRainIncoming) {
      signals.add(
        PlanningSignal(
          type: PlanningSignalType.stepGoalBehind,
          title: 'STEP OPPORTUNITY: FINISH WALKING GOAL',
          description: 'Weather is clear with $availableGapMinutes min available. A 20-min walk finishes your steps.',
          suggestedActionTitle: 'START 20M WALK',
          confidence: 0.88,
          timestamp: DateTime.now(),
        ),
      );
    }

    return signals;
  }
}
