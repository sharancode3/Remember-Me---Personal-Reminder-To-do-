import 'dart:math';
import 'package:flutter/foundation.dart';
import 'observation_store.dart';

/// The Learned Personal Planning Profile
/// Aggregates real-world behavioral observations into rich behavioral distributions
@immutable
class PersonalPlanningProfile {
  const PersonalPlanningProfile({
    this.overallDurationBias = 1.05, // e.g. 1.05 = tasks run 5% longer on avg
    this.categoryDurationBias = const {
      'work': 1.15,
      'study': 1.20,
      'fitness': 0.95,
      'errands': 1.10,
      'general': 1.00,
    },
    this.averageStartDelayMinutes = 6.5,
    this.overallCompletionProbability = 0.88,
    this.categoryCompletionProbability = const {
      'work': 0.92,
      'study': 0.80,
      'fitness': 0.85,
      'errands': 0.75,
    },
    this.preferredWorkWindows = const [
      WorkWindow(startHour: 9, endHour: 12, efficiencyMultiplier: 1.15),
      WorkWindow(startHour: 14, endHour: 18, efficiencyMultiplier: 1.00),
      WorkWindow(startHour: 20, endHour: 22, efficiencyMultiplier: 0.85),
    ],
    this.learnedTransitionTimeMinutes = 12,
    this.dailyRealisticCapacityMinutes = 720, // 12 productive hours max
    this.weekdayCapacityMinutes = 750,
    this.weekendCapacityMinutes = 480,
    this.reminderEffectivenessScore = 0.82, // 0.0 to 1.0 (how often user responds)
    this.postponementProbability = 0.15,
    this.travelTimeBias = 1.18, // Real travel is usually 18% slower than raw routing
    this.focusInterruptionProbability = 0.22,
    this.lastUpdatedAt,
  });

  final double overallDurationBias;
  final Map<String, double> categoryDurationBias;
  final double averageStartDelayMinutes;
  final double overallCompletionProbability;
  final Map<String, double> categoryCompletionProbability;
  final List<WorkWindow> preferredWorkWindows;
  final int learnedTransitionTimeMinutes;
  final int dailyRealisticCapacityMinutes;
  final int weekdayCapacityMinutes;
  final int weekendCapacityMinutes;
  final double reminderEffectivenessScore;
  final double postponementProbability;
  final double travelTimeBias;
  final double focusInterruptionProbability;
  final DateTime? lastUpdatedAt;

  PersonalPlanningProfile copyWith({
    double? overallDurationBias,
    Map<String, double>? categoryDurationBias,
    double? averageStartDelayMinutes,
    double? overallCompletionProbability,
    Map<String, double>? categoryCompletionProbability,
    List<WorkWindow>? preferredWorkWindows,
    int? learnedTransitionTimeMinutes,
    int? dailyRealisticCapacityMinutes,
    int? weekdayCapacityMinutes,
    int? weekendCapacityMinutes,
    double? reminderEffectivenessScore,
    double? postponementProbability,
    double? travelTimeBias,
    double? focusInterruptionProbability,
    DateTime? lastUpdatedAt,
  }) {
    return PersonalPlanningProfile(
      overallDurationBias: overallDurationBias ?? this.overallDurationBias,
      categoryDurationBias: categoryDurationBias ?? this.categoryDurationBias,
      averageStartDelayMinutes: averageStartDelayMinutes ?? this.averageStartDelayMinutes,
      overallCompletionProbability: overallCompletionProbability ?? this.overallCompletionProbability,
      categoryCompletionProbability: categoryCompletionProbability ?? this.categoryCompletionProbability,
      preferredWorkWindows: preferredWorkWindows ?? this.preferredWorkWindows,
      learnedTransitionTimeMinutes: learnedTransitionTimeMinutes ?? this.learnedTransitionTimeMinutes,
      dailyRealisticCapacityMinutes: dailyRealisticCapacityMinutes ?? this.dailyRealisticCapacityMinutes,
      weekdayCapacityMinutes: weekdayCapacityMinutes ?? this.weekdayCapacityMinutes,
      weekendCapacityMinutes: weekendCapacityMinutes ?? this.weekendCapacityMinutes,
      reminderEffectivenessScore: reminderEffectivenessScore ?? this.reminderEffectivenessScore,
      postponementProbability: postponementProbability ?? this.postponementProbability,
      travelTimeBias: travelTimeBias ?? this.travelTimeBias,
      focusInterruptionProbability: focusInterruptionProbability ?? this.focusInterruptionProbability,
      lastUpdatedAt: lastUpdatedAt ?? DateTime.now(),
    );
  }
}

@immutable
class WorkWindow {
  const WorkWindow({
    required this.startHour,
    required this.endHour,
    required this.efficiencyMultiplier,
  });

  final int startHour;
  final int endHour;
  final double efficiencyMultiplier; // > 1.0 = sharp/fast, < 1.0 = fatigued
}

/// Profile Synthesizer: Continuously converts raw observations into an evolving PersonalPlanningProfile
class ProfileSynthesizer {
  PersonalPlanningProfile synthesizeProfile(List<BehavioralObservation> observations) {
    if (observations.isEmpty) {
      return const PersonalPlanningProfile();
    }

    final completedTasks = observations.where((o) => o.type == ObservationType.taskCompleted).toList();
    final startedTasks = observations.where((o) => o.type == ObservationType.taskStarted).toList();
    final focusInterrupts = observations.where((o) => o.type == ObservationType.focusInterrupted).toList();
    final postponements = observations.where((o) => o.type == ObservationType.taskPostponed || o.type == ObservationType.taskRescheduled).toList();

    // 1. Compute Overall Duration Bias
    double durationBias = 1.0;
    if (completedTasks.isNotEmpty) {
      double totalPlanned = 0;
      double totalActual = 0;
      for (final t in completedTasks) {
        if (t.plannedDurationMinutes > 0) {
          totalPlanned += t.plannedDurationMinutes;
          totalActual += t.actualDurationMinutes;
        }
      }
      if (totalPlanned > 0) {
        durationBias = (totalActual / totalPlanned).clamp(0.5, 2.5);
      }
    }

    // 2. Compute Start Delay
    double avgDelay = 5.0;
    if (startedTasks.isNotEmpty) {
      final totalDelay = startedTasks.fold<int>(0, (sum, o) => sum + max(0, o.startDelayMinutes));
      avgDelay = totalDelay / startedTasks.length;
    }

    // 3. Compute Postponement Probability
    final totalScheduled = observations.where((o) => o.type == ObservationType.taskScheduled || o.type == ObservationType.taskStarted).length;
    final postProb = totalScheduled > 0 ? (postponements.length / totalScheduled).clamp(0.0, 0.9) : 0.15;

    // 4. Compute Focus Interruption Rate
    final totalFocus = observations.where((o) => o.type == ObservationType.focusStarted || o.type == ObservationType.focusCompleted).length;
    final intRate = totalFocus > 0 ? (focusInterrupts.length / totalFocus).clamp(0.05, 0.8) : 0.20;

    return PersonalPlanningProfile(
      overallDurationBias: durationBias,
      averageStartDelayMinutes: avgDelay,
      postponementProbability: postProb,
      focusInterruptionProbability: intRate,
      lastUpdatedAt: DateTime.now(),
    );
  }
}
