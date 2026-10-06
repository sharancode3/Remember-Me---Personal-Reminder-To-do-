import 'dart:async';
import 'package:flutter/foundation.dart';

/// All recognized observation/event types in the personal planning life cycle
enum ObservationType {
  taskScheduled,
  taskStarted,
  taskCompleted,
  taskPostponed,
  taskAbandoned,
  taskRescheduled,
  focusStarted,
  focusInterrupted,
  focusCompleted,
  journeyStarted,
  journeyPaused,
  journeyFinished,
  realityModeTriggered,
  realityModeHealed,
  signalTriggered,
}

/// A structured, immutable observation data point capturing real-world user behavior
@immutable
class BehavioralObservation {
  const BehavioralObservation({
    required this.id,
    required this.type,
    required this.timestamp,
    this.taskId,
    this.taskTitle,
    this.category = 'general',
    this.scheduledStart,
    this.actualStart,
    this.startDelayMinutes = 0,
    this.plannedDurationMinutes = 0,
    this.actualDurationMinutes = 0,
    this.durationDeltaMinutes = 0,
    this.interruptionCount = 0,
    this.reason,
    this.metadata = const {},
  });

  final String id;
  final ObservationType type;
  final DateTime timestamp;
  final int? taskId;
  final String? taskTitle;
  final String category;
  final DateTime? scheduledStart;
  final DateTime? actualStart;
  final int startDelayMinutes;
  final int plannedDurationMinutes;
  final int actualDurationMinutes;
  final int durationDeltaMinutes;
  final int interruptionCount;
  final String? reason;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'timestamp': timestamp.toIso8601String(),
        'taskId': taskId,
        'taskTitle': taskTitle,
        'category': category,
        'scheduledStart': scheduledStart?.toIso8601String(),
        'actualStart': actualStart?.toIso8601String(),
        'startDelayMinutes': startDelayMinutes,
        'plannedDurationMinutes': plannedDurationMinutes,
        'actualDurationMinutes': actualDurationMinutes,
        'durationDeltaMinutes': durationDeltaMinutes,
        'interruptionCount': interruptionCount,
        'reason': reason,
        'metadata': metadata,
      };
}

/// Central Observation Store: First-Class Event Store for on-device learning
class ObservationStore {
  ObservationStore({int maxMemoryEntries = 1000}) : _maxEntries = maxMemoryEntries;

  final int _maxEntries;
  final List<BehavioralObservation> _records = [];
  final _eventStreamController = StreamController<BehavioralObservation>.broadcast();

  Stream<BehavioralObservation> get stream => _eventStreamController.stream;

  List<BehavioralObservation> get allObservations => List.unmodifiable(_records);

  /// Record a new behavioral observation event
  void record(BehavioralObservation observation) {
    _records.add(observation);
    if (_records.length > _maxEntries) {
      _records.removeAt(0); // Maintain bounded memory window
    }
    _eventStreamController.add(observation);
  }

  /// Specialized Helper: Record Task Started
  void recordTaskStarted({
    required int taskId,
    required String taskTitle,
    required DateTime scheduledStart,
    required DateTime actualStart,
    String category = 'general',
    int plannedDurationMinutes = 30,
  }) {
    final delay = actualStart.difference(scheduledStart).inMinutes;
    record(
      BehavioralObservation(
        id: 'obs_start_${taskId}_${DateTime.now().millisecondsSinceEpoch}',
        type: ObservationType.taskStarted,
        timestamp: actualStart,
        taskId: taskId,
        taskTitle: taskTitle,
        category: category,
        scheduledStart: scheduledStart,
        actualStart: actualStart,
        startDelayMinutes: delay,
        plannedDurationMinutes: plannedDurationMinutes,
      ),
    );
  }

  /// Specialized Helper: Record Task Completed
  void recordTaskCompleted({
    required int taskId,
    required String taskTitle,
    required int plannedDurationMinutes,
    required int actualDurationMinutes,
    String category = 'general',
    int interruptions = 0,
  }) {
    final delta = actualDurationMinutes - plannedDurationMinutes;
    record(
      BehavioralObservation(
        id: 'obs_comp_${taskId}_${DateTime.now().millisecondsSinceEpoch}',
        type: ObservationType.taskCompleted,
        timestamp: DateTime.now(),
        taskId: taskId,
        taskTitle: taskTitle,
        category: category,
        plannedDurationMinutes: plannedDurationMinutes,
        actualDurationMinutes: actualDurationMinutes,
        durationDeltaMinutes: delta,
        interruptionCount: interruptions,
      ),
    );
  }

  /// Specialized Helper: Record Task Rescheduled
  void recordTaskRescheduled({
    required int taskId,
    required String taskTitle,
    required DateTime oldStart,
    required DateTime newStart,
    required String reason,
  }) {
    record(
      BehavioralObservation(
        id: 'obs_resched_${taskId}_${DateTime.now().millisecondsSinceEpoch}',
        type: ObservationType.taskRescheduled,
        timestamp: DateTime.now(),
        taskId: taskId,
        taskTitle: taskTitle,
        scheduledStart: oldStart,
        actualStart: newStart,
        reason: reason,
      ),
    );
  }

  /// Specialized Helper: Record Focus Session Interrupted
  void recordFocusInterrupted({
    required String sessionName,
    required int uninterruptedDurationMinutes,
    required String interruptionReason,
  }) {
    record(
      BehavioralObservation(
        id: 'obs_focus_int_${DateTime.now().millisecondsSinceEpoch}',
        type: ObservationType.focusInterrupted,
        timestamp: DateTime.now(),
        taskTitle: sessionName,
        actualDurationMinutes: uninterruptedDurationMinutes,
        reason: interruptionReason,
      ),
    );
  }

  /// Specialized Helper: Record Journey Finished
  void recordJourneyFinished({
    required String mode,
    required double distanceKm,
    required int durationSeconds,
    required int steps,
    required double avgSpeedKmh,
  }) {
    record(
      BehavioralObservation(
        id: 'obs_journey_${DateTime.now().millisecondsSinceEpoch}',
        type: ObservationType.journeyFinished,
        timestamp: DateTime.now(),
        taskTitle: 'Journey ($mode)',
        actualDurationMinutes: (durationSeconds / 60).round(),
        metadata: {
          'mode': mode,
          'distanceKm': distanceKm,
          'steps': steps,
          'avgSpeedKmh': avgSpeedKmh,
        },
      ),
    );
  }

  /// Query observations for a specific task title
  List<BehavioralObservation> getObservationsForTask(String title) {
    return _records
        .where((r) => r.taskTitle?.toLowerCase() == title.toLowerCase())
        .toList();
  }

  /// Query observations by type
  List<BehavioralObservation> getObservationsByType(ObservationType type) {
    return _records.where((r) => r.type == type).toList();
  }

  /// Compute average start delay for a given category
  double getAverageStartDelay(String category) {
    final matching = _records
        .where((r) => r.category.toLowerCase() == category.toLowerCase() && r.type == ObservationType.taskStarted)
        .toList();
    if (matching.isEmpty) return 0.0;
    final total = matching.fold<int>(0, (sum, r) => sum + r.startDelayMinutes);
    return total / matching.length;
  }

  /// Clear all stored observations
  void clear() {
    _records.clear();
  }
}
