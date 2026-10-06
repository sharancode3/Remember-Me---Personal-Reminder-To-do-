import 'dart:async';
import 'package:flutter/foundation.dart';
import '../domain/repositories/provider_abstractions.dart';

/// Standardized Planning Signals emitted by Context & Behavior Engines
enum PlanningSignalType {
  rainIncoming,
  extremeWeather,
  userNearTaskLocation,
  travelTimeHigh,
  stepGoalBehind,
  stepGoalNearComplete,
  taskRunningLong,
  taskStartedLate,
  lowRemainingCapacity,
  deadlineAtRisk,
  focusInterrupted,
  routinePatternDetected,
}

/// A structured signal consumed by the Adaptive Planning Engine
@immutable
class PlanningSignal {
  const PlanningSignal({
    required this.type,
    required this.title,
    required this.description,
    required this.confidence,
    required this.timestamp,
    this.suggestedActionTitle,
    this.suggestedTaskDeltaMinutes,
    this.targetTaskId,
  });

  final PlanningSignalType type;
  final String title;
  final String description;
  final double confidence; // 0.0 to 1.0 internal confidence
  final DateTime timestamp;
  final String? suggestedActionTitle;
  final int? suggestedTaskDeltaMinutes;
  final int? targetTaskId;
}

/// Plan Revision History Model for explainable scheduling changes
@immutable
class PlanRevision {
  const PlanRevision({
    required this.revisionId,
    required this.taskId,
    required this.taskTitle,
    required this.originalStart,
    required this.originalEnd,
    required this.revisedStart,
    required this.revisedEnd,
    required this.reason,
    required this.triggeringSignal,
    required this.timestamp,
  });

  final String revisionId;
  final int taskId;
  final String taskTitle;
  final DateTime originalStart;
  final DateTime originalEnd;
  final DateTime revisedStart;
  final DateTime revisedEnd;
  final String reason;
  final PlanningSignalType triggeringSignal;
  final DateTime timestamp;
}

/// Snapshot of the user's real-world environment
@immutable
class UserEnvironmentalContext {
  const UserEnvironmentalContext({
    required this.currentTime,
    required this.weather,
    required this.location,
    required this.todayStepCount,
    required this.stepGoal,
    required this.availableFreeMinutesToday,
    required this.isFocusActive,
    required this.activeTaskId,
  });

  final DateTime currentTime;
  final WeatherContext? weather;
  final LocationSnapshot? location;
  final int todayStepCount;
  final int stepGoal;
  final int availableFreeMinutesToday;
  final bool isFocusActive;
  final int? activeTaskId;
}

/// The Context Engine: Collects reality signals without directly mutating tasks
class ContextEngine {
  ContextEngine({
    required WeatherProvider weatherProvider,
    required LocationProvider locationProvider,
    required HealthProvider healthProvider,
  })  : _weatherProvider = weatherProvider,
        _locationProvider = locationProvider,
        _healthProvider = healthProvider;

  final WeatherProvider _weatherProvider;
  final LocationProvider _locationProvider;
  final HealthProvider _healthProvider;

  final StreamController<List<PlanningSignal>> _signalController =
      StreamController<List<PlanningSignal>>.broadcast();

  Stream<List<PlanningSignal>> get signalsStream => _signalController.stream;

  /// Evaluate the current context and produce reactive Planning Signals
  Future<List<PlanningSignal>> evaluateSignals({
    required int availableFreeMinutesToday,
    required bool isFocusActive,
    required int? activeTaskId,
  }) async {
    final signals = <PlanningSignal>[];
    final now = DateTime.now();

    // 1. Evaluate Weather Signal
    try {
      final weather = await _weatherProvider.getWeatherForecast(
        latitude: 12.9716,
        longitude: 77.5946,
        date: now,
      );

      if (weather != null) {
        if (weather.rainProbabilityPercentage >= 60 ||
            weather.condition == WeatherConditionType.rain ||
            weather.condition == WeatherConditionType.heavyRain) {
          signals.add(
            PlanningSignal(
              type: PlanningSignalType.rainIncoming,
              title: 'RAIN INCOMING (${weather.rainProbabilityPercentage}%)',
              description: 'Rain is expected. Outdoor sessions should be moved to clearer hours.',
              confidence: 0.92,
              timestamp: now,
              suggestedActionTitle: 'SHIFT OUTDOOR TASKS',
            ),
          );
        } else if (weather.temperatureCelsius > 36) {
          signals.add(
            PlanningSignal(
              type: PlanningSignalType.extremeWeather,
              title: 'EXTREME HEAT (${weather.temperatureCelsius.toInt()}°C)',
              description: 'High thermal index. Recommend shifting heavy focus or runs to evening.',
              confidence: 0.88,
              timestamp: now,
              suggestedActionTitle: 'ADJUST SCHEDULE',
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('[ContextEngine] Weather check skipped: $e');
    }

    // 2. Evaluate Health & Steps Signal
    try {
      final steps = await _healthProvider.getTodayStepCount();
      const goal = 10000;
      final remainingSteps = goal - steps;

      if (remainingSteps > 0 && now.hour >= 17) {
        final estWalkMins = (remainingSteps / 110).round().clamp(10, 60);
        signals.add(
          PlanningSignal(
            type: PlanningSignalType.stepGoalBehind,
            title: '$remainingSteps STEPS REMAINING',
            description: 'You have $availableFreeMinutesToday min free. A ~$estWalkMins min walk completes your goal.',
            confidence: 0.85,
            timestamp: now,
            suggestedActionTitle: 'START WALK',
            suggestedTaskDeltaMinutes: estWalkMins,
          ),
        );
      } else if (remainingSteps <= 0) {
        signals.add(
          PlanningSignal(
            type: PlanningSignalType.stepGoalNearComplete,
            title: '10,000 STEP GOAL COMPLETED',
            description: 'Target reached today with $steps steps recorded.',
            confidence: 1.0,
            timestamp: now,
          ),
        );
      }
    } catch (e) {
      debugPrint('[ContextEngine] Step count check skipped: $e');
    }

    _signalController.add(signals);
    return signals;
  }
}
