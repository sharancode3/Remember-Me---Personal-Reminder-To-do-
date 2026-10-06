import 'dart:math';
import 'package:flutter/foundation.dart';

/// Full Statistical Duration Distribution for Uncertainty-Aware Scheduling
@immutable
class DurationDistribution {
  const DurationDistribution({
    required this.typicalMinutes, // Median / Mode (P50)
    required this.minMinutes, // Optimistic scenario (P10)
    required this.maxMinutes, // Realistic upper bound (P90)
    required this.worstCaseMinutes, // Extreme tail scenario (P99)
    required this.varianceMinutes, // Measure of uncertainty / volatility
    required this.confidenceScore, // 0.0 (low/unknown) to 1.0 (high certainty)
  });

  final int typicalMinutes;
  final int minMinutes;
  final int maxMinutes;
  final int worstCaseMinutes;
  final double varianceMinutes;
  final double confidenceScore;

  /// High variance implies loose scheduling needed; low variance enables tight time-blocking
  bool get isHighUncertainty => (maxMinutes - minMinutes) > (typicalMinutes * 0.6);

  String get summaryText =>
      'Typical: ${typicalMinutes}m (Usually $minMinutes–${maxMinutes}m, Worst-case: ${worstCaseMinutes}m+)';
}

/// Context factors supplied to the Personal Prediction Engine
@immutable
class TaskPredictionContext {
  const TaskPredictionContext({
    required this.taskTitle,
    required this.plannedDurationMinutes,
    required this.targetDateTime,
    this.category = 'general',
    this.isHardCommitment = false,
    this.consecutiveTaskCountBefore = 0,
    this.currentFatigueIndex = 0.0,
    this.isOutdoor = false,
    this.rainProbability = 0,
    this.temperatureCelsius = 24.0,
  });

  final String taskTitle;
  final int plannedDurationMinutes;
  final DateTime targetDateTime;
  final String category;
  final bool isHardCommitment;
  final int consecutiveTaskCountBefore;
  final double currentFatigueIndex;
  final bool isOutdoor;
  final int rainProbability;
  final double temperatureCelsius;
}

/// Rich prediction result containing estimated distribution, completion likelihood, and confidence
@immutable
class PredictionResult {
  const PredictionResult({
    required this.predictedDurationMinutes,
    required this.distribution,
    required this.completionProbability,
    required this.confidence,
    required this.recommendedBufferMinutes,
    required this.primaryFactor,
    required this.usedFallback,
  });

  final int predictedDurationMinutes;
  final DurationDistribution distribution;
  final double completionProbability; // 0.0 to 1.0
  final double confidence; // 0.0 to 1.0
  final int recommendedBufferMinutes;
  final String primaryFactor;
  final bool usedFallback;
}

/// Historical observation datapoint for learning
@immutable
class TaskExecutionRecord {
  const TaskExecutionRecord({
    required this.taskTitle,
    required this.category,
    required this.plannedDurationMinutes,
    required this.actualDurationMinutes,
    required this.startDelayMinutes,
    required this.timeOfDayHour,
    required this.dayOfWeek,
    required this.wasCompleted,
    required this.postponementCount,
    required this.timestamp,
  });

  final String taskTitle;
  final String category;
  final int plannedDurationMinutes;
  final int actualDurationMinutes;
  final int startDelayMinutes;
  final int timeOfDayHour;
  final int dayOfWeek;
  final bool wasCompleted;
  final int postponementCount;
  final DateTime timestamp;
}

/// Personal Prediction Engine with Distribution & Uncertainty Modeling
class PersonalPredictionEngine {
  PersonalPredictionEngine({double ewmaAlpha = 0.3}) : _alpha = ewmaAlpha;

  final double _alpha;
  final List<TaskExecutionRecord> _history = [];

  void recordExecution(TaskExecutionRecord record) {
    _history.add(record);
    if (_history.length > 500) {
      _history.removeAt(0);
    }
  }

  /// Predict duration distribution and optimal buffer using multi-factor contextual modeling
  PredictionResult predict(TaskPredictionContext context) {
    final titleMatch = _history
        .where((r) => r.taskTitle.toLowerCase() == context.taskTitle.toLowerCase())
        .toList();

    final categoryMatch = _history
        .where((r) => r.category.toLowerCase() == context.category.toLowerCase())
        .toList();

    // 1. BASELINE: Exponentially Weighted Moving Average (EWMA)
    double baselineDuration = context.plannedDurationMinutes.toDouble();
    if (titleMatch.isNotEmpty) {
      double ewma = titleMatch.first.actualDurationMinutes.toDouble();
      for (final r in titleMatch.skip(1)) {
        ewma = _alpha * r.actualDurationMinutes + (1 - _alpha) * ewma;
      }
      baselineDuration = ewma;
    } else if (categoryMatch.isNotEmpty) {
      final avg = categoryMatch.map((e) => e.actualDurationMinutes).reduce((a, b) => a + b) /
          categoryMatch.length;
      baselineDuration = (baselineDuration * 0.4) + (avg * 0.6);
    }

    // 2. CONTEXT MULTIPLIERS (Fatigue, Time, Weather)
    double multiplier = 1.0;
    String primaryFactor = 'Historical baseline';
    double confidence = 0.5;

    final hour = context.targetDateTime.hour;
    if (hour >= 21 || hour < 6) {
      multiplier *= 1.22;
      primaryFactor = 'Evening fatigue slowdown multiplier';
      confidence += 0.15;
    } else if (hour >= 9 && hour <= 12) {
      multiplier *= 0.95;
      primaryFactor = 'Morning peak focus efficiency';
      confidence += 0.15;
    }

    if (context.consecutiveTaskCountBefore >= 3) {
      multiplier *= 1.15;
      primaryFactor = 'Cumulative task fatigue (${context.consecutiveTaskCountBefore} prior sessions)';
    }

    if (context.isOutdoor && context.rainProbability >= 50) {
      multiplier *= 1.30;
      primaryFactor = 'Weather disruption factor (${context.rainProbability}% rain)';
    }

    final finalTypicalDuration = (baselineDuration * multiplier).round().clamp(5, 480);

    // 3. STATISTICAL DISTRIBUTION (P10, P50, P90, P99 Tail)
    DurationDistribution distribution;
    if (titleMatch.length >= 3) {
      final durations = titleMatch.map((r) => (r.actualDurationMinutes * multiplier).round()).toList()..sort();
      final p10 = durations[(durations.length * 0.10).floor()].clamp(5, 480);
      final p50 = finalTypicalDuration;
      final p90 = durations[(durations.length * 0.90).floor()].clamp(p50, 600);
      final p99 = (durations.last * 1.2).round().clamp(p90, 720);
      final variance = (p90 - p10).toDouble();

      distribution = DurationDistribution(
        typicalMinutes: p50,
        minMinutes: p10,
        maxMinutes: p90,
        worstCaseMinutes: p99,
        varianceMinutes: variance,
        confidenceScore: min(0.95, 0.60 + (titleMatch.length * 0.05)),
      );
      confidence = distribution.confidenceScore;
    } else {
      // Synthetic heuristic distribution when cold-start
      final p10 = (finalTypicalDuration * 0.85).round().clamp(5, 480);
      final p90 = (finalTypicalDuration * 1.35).round().clamp(finalTypicalDuration, 600);
      final p99 = (finalTypicalDuration * 1.75).round().clamp(p90, 720);

      distribution = DurationDistribution(
        typicalMinutes: finalTypicalDuration,
        minMinutes: p10,
        maxMinutes: p90,
        worstCaseMinutes: p99,
        varianceMinutes: (p90 - p10).toDouble(),
        confidenceScore: 0.50,
      );
    }

    // 4. UNCERTAINTY-AWARE RECOMMENDED BUFFER
    int bufferMins = 5;
    if (distribution.isHighUncertainty || finalTypicalDuration > 60) {
      bufferMins = max(15, (distribution.varianceMinutes * 0.35).round());
    } else if (context.consecutiveTaskCountBefore >= 2) {
      bufferMins = 12;
    }

    // 5. COMPLETION PROBABILITY ESTIMATE
    double completionProb = 0.90;
    if (titleMatch.isNotEmpty) {
      final completedCount = titleMatch.where((r) => r.wasCompleted).length;
      completionProb = completedCount / titleMatch.length;
    }

    return PredictionResult(
      predictedDurationMinutes: finalTypicalDuration,
      distribution: distribution,
      completionProbability: completionProb,
      confidence: confidence.clamp(0.1, 0.99),
      recommendedBufferMinutes: bufferMins.clamp(5, 45),
      primaryFactor: primaryFactor,
      usedFallback: titleMatch.isEmpty && categoryMatch.isEmpty,
    );
  }
}
