import 'dart:async';
import 'dart:math';
import 'package:remember_me/src/domain/repositories/provider_abstractions.dart';

/// Local-first, privacy-respecting Mock Movement & Journey Engine
/// Handles route recording, speed calculation, pace, moving vs stopped durations.
class LocalMovementJourneyService implements MovementJourneyProvider {
  JourneyLiveState? _currentLiveState;
  final StreamController<JourneyLiveState> _liveStateController =
      StreamController<JourneyLiveState>.broadcast();

  Timer? _ticker;
  DateTime? _startedAt;
  DateTime? _lastTickAt;
  int _elapsedSeconds = 0;
  int _movingSeconds = 0;
  int _stoppedSeconds = 0;
  double _distanceKm = 0.0;
  double _peakSpeedKmh = 0.0;
  int _stepsCount = 0;
  bool _isPaused = false;
  JourneyType _type = JourneyType.walk;

  final List<LocationSnapshot> _routeCoordinates = [];
  final Random _random = Random();

  @override
  JourneyLiveState? get currentLiveState => _currentLiveState;

  @override
  Future<void> startJourney(JourneyType type) async {
    _type = type;
    _elapsedSeconds = 0;
    _movingSeconds = 0;
    _stoppedSeconds = 0;
    _distanceKm = 0.0;
    _peakSpeedKmh = 0.0;
    _stepsCount = 0;
    _isPaused = false;
    _routeCoordinates.clear();

    _startedAt = DateTime.now();
    _lastTickAt = _startedAt;

    // Add initial location point
    _routeCoordinates.add(
      LocationSnapshot(
        latitude: 12.9716,
        longitude: 77.5946,
        speedKmh: 0,
        timestamp: _startedAt!,
      ),
    );

    _emitState(0.0);

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_isPaused) {
      _stoppedSeconds++;
      _elapsedSeconds++;
      _emitState(0.0);
      return;
    }

    _elapsedSeconds++;
    _movingSeconds++;

    // Simulate natural human movement progression
    final currentSpeed = _type == JourneyType.run
        ? (9.0 + _random.nextDouble() * 2.5)
        : (_type == JourneyType.cycling
            ? (18.0 + _random.nextDouble() * 5.0)
            : (4.8 + _random.nextDouble() * 1.2));

    if (currentSpeed > _peakSpeedKmh) {
      _peakSpeedKmh = currentSpeed;
    }

    final incrementalDistKm = (currentSpeed / 3600.0);
    _distanceKm += incrementalDistKm;

    if (_type != JourneyType.cycling) {
      _stepsCount += (_type == JourneyType.run ? 3 : 2);
    }

    // Add small GPS coordinate jitter
    final lastLat = _routeCoordinates.last.latitude;
    final lastLon = _routeCoordinates.last.longitude;
    final newLat = lastLat + (_random.nextDouble() - 0.48) * 0.0001;
    final newLon = lastLon + (_random.nextDouble() - 0.48) * 0.0001;

    _routeCoordinates.add(
      LocationSnapshot(
        latitude: newLat,
        longitude: newLon,
        speedKmh: currentSpeed,
        timestamp: DateTime.now(),
      ),
    );

    _emitState(currentSpeed);
  }

  void _emitState(double currentSpeed) {
    final avgSpeed = _elapsedSeconds > 0 ? (_distanceKm / (_elapsedSeconds / 3600.0)) : 0.0;
    final paceMinPerKm = avgSpeed > 0 ? (60.0 / avgSpeed) : 0.0;

    _currentLiveState = JourneyLiveState(
      type: _type,
      elapsedSeconds: _elapsedSeconds,
      movingSeconds: _movingSeconds,
      stoppedSeconds: _stoppedSeconds,
      distanceKm: _distanceKm,
      currentSpeedKmh: currentSpeed,
      averageSpeedKmh: avgSpeed,
      peakSpeedKmh: _peakSpeedKmh,
      currentPaceMinPerKm: paceMinPerKm,
      stepsCount: _stepsCount,
      routeCoordinates: List.unmodifiable(_routeCoordinates),
      isPaused: _isPaused,
    );

    _liveStateController.add(_currentLiveState!);
  }

  @override
  Future<void> pauseJourney() async {
    _isPaused = true;
    _emitState(0.0);
  }

  @override
  Future<void> resumeJourney() async {
    _isPaused = false;
  }

  @override
  Future<JourneySummary> finishJourney() async {
    _ticker?.cancel();
    _ticker = null;
    final completedAt = DateTime.now();
    final avgSpeed = _elapsedSeconds > 0 ? (_distanceKm / (_elapsedSeconds / 3600.0)) : 0.0;

    final summary = JourneySummary(
      type: _type,
      totalDuration: Duration(seconds: _elapsedSeconds),
      movingDuration: Duration(seconds: _movingSeconds),
      stoppedDuration: Duration(seconds: _stoppedSeconds),
      totalDistanceKm: _distanceKm,
      averageSpeedKmh: avgSpeed,
      peakSpeedKmh: _peakSpeedKmh,
      totalSteps: _stepsCount,
      routePoints: List.from(_routeCoordinates),
      startedAt: _startedAt ?? completedAt,
      completedAt: completedAt,
    );

    _currentLiveState = null;
    return summary;
  }

  @override
  Stream<JourneyLiveState> watchLiveJourney() => _liveStateController.stream;
}
