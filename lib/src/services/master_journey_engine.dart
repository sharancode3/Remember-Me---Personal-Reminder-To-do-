import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../data/models/journey_record_model.dart';
import '../data/repositories/journey_history_repository.dart';
import '../domain/repositories/provider_abstractions.dart';
import 'journey_models_and_processor.dart';
import 'observation_store.dart';

/// Pre-flight Journey Intent Goal
enum JourneyTargetType {
  justTrack,
  hitDistance,
  hitDuration,
  hitSteps,
}

@immutable
class JourneyIntentTarget {
  const JourneyIntentTarget({
    required this.type,
    this.targetDistanceKm,
    this.targetDurationMinutes,
    this.targetSteps,
  });

  final JourneyTargetType type;
  final double? targetDistanceKm;
  final int? targetDurationMinutes;
  final int? targetSteps;

  String get label {
    switch (type) {
      case JourneyTargetType.justTrack:
        return 'OPEN TRACKING';
      case JourneyTargetType.hitDistance:
        return '${targetDistanceKm?.toStringAsFixed(1) ?? "5"} KM TARGET';
      case JourneyTargetType.hitDuration:
        return '${targetDurationMinutes ?? 30} MIN TARGET';
      case JourneyTargetType.hitSteps:
        return '${targetSteps ?? 10000} STEPS TARGET';
    }
  }
}

/// Comprehensive Master Activity Tracking Engine
class MasterJourneyEngine implements MovementJourneyProvider {
  MasterJourneyEngine({
    required ObservationStore observationStore,
    JourneyHistoryRepository? historyRepository,
  })  : _obsStore = observationStore,
        _historyRepo = historyRepository,
        _processor = TrackQualityProcessor();

  final ObservationStore _obsStore;
  final JourneyHistoryRepository? _historyRepo;
  final TrackQualityProcessor _processor;

  final StreamController<JourneyLiveState> _liveStreamController = StreamController<JourneyLiveState>.broadcast();

  StreamSubscription<Position>? _positionSubscription;

  JourneyType _type = JourneyType.walk;
  JourneyIntentTarget _target = const JourneyIntentTarget(type: JourneyTargetType.justTrack);
  DateTime? _startedAt;
  DateTime? _completedAt;
  bool _isPaused = false;
  int _elapsedSeconds = 0;
  int _movingSeconds = 0;
  int _stoppedSeconds = 0;
  int _stepsCount = 0;
  double _liveAccuracyMeters = 5.0;
  Timer? _tickerTimer;
  JourneyLiveState? _latestState;

  JourneyType get currentType => _type;
  JourneyIntentTarget get currentTarget => _target;
  TrackQualityProcessor get processor => _processor;

  @override
  JourneyLiveState? get currentLiveState => _latestState;

  @override
  Stream<JourneyLiveState> watchLiveJourney() => _liveStreamController.stream;

  void configureIntent(JourneyIntentTarget target) {
    _target = target;
  }

  @override
  Future<void> startJourney(JourneyType type, {Position? initialPosition}) async {
    _type = type;
    _startedAt = DateTime.now();
    _completedAt = null;
    _isPaused = false;
    _elapsedSeconds = 0;
    _movingSeconds = 0;
    _stoppedSeconds = 0;
    _stepsCount = 0;
    _processor.reset();

    final lat = initialPosition?.latitude ?? 12.9716;
    final lng = initialPosition?.longitude ?? 77.5946;
    _liveAccuracyMeters = initialPosition?.accuracy ?? 5.0;

    // Start coordinate at exact user location with 0 movement
    final initialObservation = GpsObservation(
      latitude: lat,
      longitude: lng,
      timestamp: _startedAt!,
      elapsedRealtimeNanos: DateTime.now().microsecondsSinceEpoch * 1000,
      horizontalAccuracyMeters: _liveAccuracyMeters,
      sensorSpeedMps: 0.0,
    );
    _processor.processSample(initialObservation, isUserPaused: false);

    _emitLiveState();

    _tickerTimer?.cancel();
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());

    // Subscribe to real device GPS position stream
    await _startGpsStream();
  }

  Future<void> _startGpsStream() async {
    await _positionSubscription?.cancel();
    try {
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 3, // meters
      );

      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (position) {
          _liveAccuracyMeters = position.accuracy;
          final observation = GpsObservation(
            latitude: position.latitude,
            longitude: position.longitude,
            altitudeMeters: position.altitude,
            timestamp: position.timestamp,
            elapsedRealtimeNanos: DateTime.now().microsecondsSinceEpoch * 1000,
            horizontalAccuracyMeters: position.accuracy,
            sensorSpeedMps: position.speed >= 0 ? position.speed : null,
            speedAccuracyMps: position.speedAccuracy >= 0 ? position.speedAccuracy : null,
          );
          ingestGpsSample(observation);
        },
        onError: (error) {
          debugPrint('Geolocator stream error: $error');
        },
      );
    } catch (e) {
      debugPrint('Geolocator subscription error: $e');
    }
  }

  void _onTick() {
    _elapsedSeconds++;
    if (_isPaused) {
      _stoppedSeconds++;
    } else {
      if (_processor.acceptedPoints.length > 1 &&
          _processor.acceptedPoints.last.state == MovementState.moving) {
        _movingSeconds++;
      } else {
        _stoppedSeconds++;
      }
    }
    _emitLiveState();
  }

  void ingestGpsSample(GpsObservation sample) {
    _liveAccuracyMeters = sample.horizontalAccuracyMeters;
    _processor.processSample(sample, isUserPaused: _isPaused);
    _emitLiveState();
  }

  void _emitLiveState() {
    final totalDistKm = _processor.acceptedPoints.isNotEmpty
        ? _processor.acceptedPoints.last.cumulativeDistanceMeters / 1000.0
        : 0.0;

    final movingMinutes = _movingSeconds / 60.0;
    final avgMovingSpeedKmh = movingMinutes > 0 ? (totalDistKm / (movingMinutes / 60.0)) : 0.0;
    final currentPaceMinPerKm = totalDistKm > 0.05 && movingMinutes > 0 ? (movingMinutes / totalDistKm) : 0.0;

    final currentSpeed = _processor.acceptedPoints.isNotEmpty
        ? _processor.acceptedPoints.last.validatedSpeedKmh
        : 0.0;

    final state = JourneyLiveState(
      type: _type,
      elapsedSeconds: _elapsedSeconds,
      movingSeconds: _movingSeconds,
      stoppedSeconds: _stoppedSeconds,
      distanceKm: totalDistKm,
      currentSpeedKmh: currentSpeed,
      averageSpeedKmh: avgMovingSpeedKmh,
      peakSpeedKmh: _processor.peakValidatedSpeedKmh,
      currentPaceMinPerKm: currentPaceMinPerKm,
      stepsCount: _stepsCount,
      routeCoordinates: _processor.acceptedPoints.map((p) {
        return LocationSnapshot(
          latitude: p.latitude,
          longitude: p.longitude,
          altitude: p.altitudeMeters,
          speedKmh: p.validatedSpeedKmh,
          timestamp: p.timestamp,
        );
      }).toList(),
      isPaused: _isPaused,
      liveAccuracyMeters: _liveAccuracyMeters,
    );

    _latestState = state;
    _liveStreamController.add(state);
  }

  @override
  Future<void> pauseJourney() async {
    _isPaused = true;
    _emitLiveState();
  }

  @override
  Future<void> resumeJourney() async {
    _isPaused = false;
    _emitLiveState();
  }

  @override
  Future<JourneySummary> finishJourney({String? customTitle}) async {
    _tickerTimer?.cancel();
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _completedAt = DateTime.now();

    final totalDistKm = _processor.acceptedPoints.isNotEmpty
        ? _processor.acceptedPoints.last.cumulativeDistanceMeters / 1000.0
        : 0.0;

    final totalDuration = Duration(seconds: _elapsedSeconds);
    final movingDuration = Duration(seconds: _movingSeconds);
    final stoppedDuration = Duration(seconds: _stoppedSeconds);

    final movingHours = _movingSeconds / 3600.0;
    final avgMovingSpeed = movingHours > 0 ? (totalDistKm / movingHours) : 0.0;

    final summary = JourneySummary(
      type: _type,
      totalDuration: totalDuration,
      movingDuration: movingDuration,
      stoppedDuration: stoppedDuration,
      totalDistanceKm: totalDistKm,
      averageSpeedKmh: avgMovingSpeed,
      peakSpeedKmh: _processor.peakValidatedSpeedKmh,
      totalSteps: _stepsCount,
      routePoints: _processor.acceptedPoints.map((p) {
        return LocationSnapshot(
          latitude: p.latitude,
          longitude: p.longitude,
          altitude: p.altitudeMeters,
          speedKmh: p.validatedSpeedKmh,
          timestamp: p.timestamp,
        );
      }).toList(),
      startedAt: _startedAt ?? DateTime.now(),
      completedAt: _completedAt!,
    );

    // Persist to Isar JourneyRecord
    if (_historyRepo != null) {
      final start = _startedAt ?? DateTime.now();
      final record = JourneyRecord()
        ..title = customTitle ?? '${_type.name.toUpperCase()} Session'
        ..activityType = _type.name
        ..startTime = start
        ..endTime = _completedAt!
        ..totalDistanceMeters = _processor.acceptedPoints.isNotEmpty
            ? _processor.acceptedPoints.last.cumulativeDistanceMeters
            : 0.0
        ..totalDurationSeconds = _elapsedSeconds
        ..movingDurationSeconds = _movingSeconds
        ..averageSpeedKmh = avgMovingSpeed
        ..kmSplits = _processor.splits.map((s) {
          return KmSplitModel(
            km: s.splitIndex,
            elapsedSeconds: s.splitDuration.inSeconds,
          );
        }).toList()
        ..routePoints = _processor.acceptedPoints.map((p) {
          return RoutePointModel(
            latitude: p.latitude,
            longitude: p.longitude,
            timestampOffsetSeconds: p.timestamp.difference(start).inSeconds,
            speedKmh: p.validatedSpeedKmh,
          );
        }).toList();

      await _historyRepo.saveJourneyRecord(record);
    }

    // Record observation into the core observation store
    _obsStore.record(
      BehavioralObservation(
        id: 'obs_journey_${DateTime.now().millisecondsSinceEpoch}',
        type: ObservationType.journeyFinished,
        timestamp: DateTime.now(),
        reason: '${_type.name.toUpperCase()} Journey: ${totalDistKm.toStringAsFixed(2)} km in ${totalDuration.inMinutes}m',
      ),
    );

    return summary;
  }
}

