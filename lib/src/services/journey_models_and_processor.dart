import 'dart:math';
import 'package:flutter/foundation.dart';

/// Movement state machine states
enum MovementState {
  unknown,
  moving,
  possiblyStopped,
  stopped,
  pausedByUser,
  trackingLost,
}

/// Rich, sensor-evaluated GPS observation
@immutable
class GpsObservation {
  const GpsObservation({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.elapsedRealtimeNanos,
    required this.horizontalAccuracyMeters,
    this.altitudeMeters,
    this.bearingDegrees,
    this.sensorSpeedMps,
    this.speedAccuracyMps,
    this.provider = 'fused',
  });

  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final int elapsedRealtimeNanos;
  final double horizontalAccuracyMeters;
  final double? altitudeMeters;
  final double? bearingDegrees;
  final double? sensorSpeedMps;
  final double? speedAccuracyMps;
  final String provider;

  bool get isHighAccuracy => horizontalAccuracyMeters <= 20.0;
  bool get isUsableAccuracy => horizontalAccuracyMeters <= 50.0;
}

/// Processed, filtered, and smoothed track node
@immutable
class TrackPoint {
  const TrackPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.elapsedSeconds,
    required this.validatedSpeedKmh,
    required this.cumulativeDistanceMeters,
    required this.state,
    this.altitudeMeters,
  });

  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final int elapsedSeconds;
  final double validatedSpeedKmh;
  final double cumulativeDistanceMeters;
  final MovementState state;
  final double? altitudeMeters;
}

/// 1-Kilometer Split record
@immutable
class JourneySplit {
  const JourneySplit({
    required this.splitIndex,
    required this.distanceKm,
    required this.splitDuration,
    required this.paceMinPerKm,
    required this.avgSpeedKmh,
  });

  final int splitIndex;
  final double distanceKm;
  final Duration splitDuration;
  final double paceMinPerKm;
  final double avgSpeedKmh;
}

/// Stop event record along route
@immutable
class JourneyStopEvent {
  const JourneyStopEvent({
    required this.stopIndex,
    required this.latitude,
    required this.longitude,
    required this.startedAt,
    required this.endedAt,
    required this.duration,
  });

  final int stopIndex;
  final double latitude;
  final double longitude;
  final DateTime startedAt;
  final DateTime endedAt;
  final Duration duration;
}

/// Track Quality Processor: cleans raw GPS stream and computes motion metrics
class TrackQualityProcessor {
  TrackQualityProcessor({
    this.maxFeasibleSpeedKmh = 60.0, // Walking/running max threshold
    this.minDisplacementMeters = 2.5, // Stationary jitter threshold
  });

  final double maxFeasibleSpeedKmh;
  final double minDisplacementMeters;

  final List<TrackPoint> _acceptedPoints = [];
  final List<JourneyStopEvent> _stops = [];
  final List<JourneySplit> _splits = [];

  GpsObservation? _lastObservation;
  DateTime? _stopStartedAt;
  int _consecutiveSlowSamples = 0;
  double _peakValidatedSpeedKmh = 0.0;
  int _lastSplitDistanceM = 0;
  DateTime? _lastSplitTimestamp;

  List<TrackPoint> get acceptedPoints => List.unmodifiable(_acceptedPoints);
  List<JourneyStopEvent> get stops => List.unmodifiable(_stops);
  List<JourneySplit> get splits => List.unmodifiable(_splits);
  double get peakValidatedSpeedKmh => _peakValidatedSpeedKmh;

  /// Haversine distance formula in meters
  static double computeDistanceMeters(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371000.0; // Earth radius in meters
    final dLat = (lat2 - lat1) * (pi / 180.0);
    final dLon = (lon2 - lon1) * (pi / 180.0);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180.0)) * cos(lat2 * (pi / 180.0)) *
        sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  /// Evaluates sample and updates track state if accepted
  TrackPoint? processSample(GpsObservation sample, {required bool isUserPaused}) {
    if (isUserPaused) {
      return _recordStatePoint(sample, MovementState.pausedByUser);
    }

    // 1. Quality validation: reject bad accuracy (worse than 20m)
    if (sample.horizontalAccuracyMeters > 20.0) {
      return null; // Reject noisy GPS spike
    }

    if (_lastObservation == null) {
      _lastObservation = sample;
      final firstPoint = TrackPoint(
        latitude: sample.latitude,
        longitude: sample.longitude,
        timestamp: sample.timestamp,
        elapsedSeconds: 0,
        validatedSpeedKmh: 0.0,
        cumulativeDistanceMeters: 0.0,
        state: MovementState.moving,
        altitudeMeters: sample.altitudeMeters,
      );
      _acceptedPoints.add(firstPoint);
      _lastSplitTimestamp = sample.timestamp;
      return firstPoint;
    }

    final prev = _lastObservation!;
    final dtSeconds = (sample.elapsedRealtimeNanos - prev.elapsedRealtimeNanos) / 1e9;
    if (dtSeconds <= 0.2) return null; // Deduplicate / rapid duplicate sample

    final rawDistanceM = computeDistanceMeters(
      prev.latitude,
      prev.longitude,
      sample.latitude,
      sample.longitude,
    );

    final derivedSpeedMps = rawDistanceM / dtSeconds;
    final derivedSpeedKmh = derivedSpeedMps * 3.6;

    // 2. Reject impossible leap / teleportation
    if (derivedSpeedKmh > maxFeasibleSpeedKmh && (sample.sensorSpeedMps == null || (sample.sensorSpeedMps! * 3.6) > maxFeasibleSpeedKmh)) {
      return null; // GPS glitch leap rejected
    }

    // 3. Robust speed estimation (Doppler sensor speed + track derived speed)
    double validatedSpeedKmh = derivedSpeedKmh;
    if (sample.sensorSpeedMps != null && sample.sensorSpeedMps! >= 0) {
      final sensorKmh = sample.sensorSpeedMps! * 3.6;
      final speedAccuracyKmh = (sample.speedAccuracyMps ?? 1.0) * 3.6;
      if (speedAccuracyKmh < 5.0) {
        // High confidence sensor speed
        validatedSpeedKmh = (sensorKmh * 0.7) + (derivedSpeedKmh * 0.3);
      }
    }

    // 4. Movement state detection (Moving vs Stopped vs Jitter)
    MovementState state = MovementState.moving;
    double incrementalDistance = rawDistanceM;

    if (rawDistanceM < minDisplacementMeters && validatedSpeedKmh < 1.8) {
      _consecutiveSlowSamples++;
      if (_consecutiveSlowSamples >= 3) {
        state = MovementState.stopped;
        _stopStartedAt ??= sample.timestamp;
      } else {
        state = MovementState.possiblyStopped;
      }
      incrementalDistance = 0.0; // Filter out stationary GPS jitter
      validatedSpeedKmh = 0.0;
    } else {
      if (_stopStartedAt != null) {
        final stopDuration = sample.timestamp.difference(_stopStartedAt!);
        if (stopDuration.inSeconds >= 10) {
          _stops.add(
            JourneyStopEvent(
              stopIndex: _stops.length + 1,
              latitude: prev.latitude,
              longitude: prev.longitude,
              startedAt: _stopStartedAt!,
              endedAt: sample.timestamp,
              duration: stopDuration,
            ),
          );
        }
        _stopStartedAt = null;
      }
      _consecutiveSlowSamples = 0;
      state = MovementState.moving;
    }

    // 5. Update Peak Validated Speed (protected against isolated spikes)
    if (state == MovementState.moving && validatedSpeedKmh <= maxFeasibleSpeedKmh) {
      if (validatedSpeedKmh > _peakValidatedSpeedKmh) {
        _peakValidatedSpeedKmh = validatedSpeedKmh;
      }
    }

    final prevTotalDist = _acceptedPoints.isNotEmpty ? _acceptedPoints.last.cumulativeDistanceMeters : 0.0;
    final totalDistance = prevTotalDist + incrementalDistance;
    final elapsedSec = _acceptedPoints.isNotEmpty ? _acceptedPoints.last.elapsedSeconds + dtSeconds.round() : 0;

    final newPoint = TrackPoint(
      latitude: sample.latitude,
      longitude: sample.longitude,
      timestamp: sample.timestamp,
      elapsedSeconds: elapsedSec,
      validatedSpeedKmh: validatedSpeedKmh,
      cumulativeDistanceMeters: totalDistance,
      state: state,
      altitudeMeters: sample.altitudeMeters,
    );

    _acceptedPoints.add(newPoint);
    _lastObservation = sample;

    // 6. Kilometer Split Evaluator
    _checkSplits(totalDistance, sample.timestamp);

    return newPoint;
  }

  void _checkSplits(double totalDistanceMeters, DateTime currentTimestamp) {
    final currentKm = (totalDistanceMeters / 1000.0).floor();
    final prevKm = (_lastSplitDistanceM / 1000.0).floor();

    if (currentKm > prevKm && currentKm >= 1) {
      final splitDuration = _lastSplitTimestamp != null
          ? currentTimestamp.difference(_lastSplitTimestamp!)
          : const Duration(minutes: 5);

      final splitMinutes = splitDuration.inSeconds / 60.0;
      final paceMinPerKm = splitMinutes; // 1 km in X minutes
      final avgSpeedKmh = splitMinutes > 0 ? (60.0 / splitMinutes) : 0.0;

      _splits.add(
        JourneySplit(
          splitIndex: currentKm,
          distanceKm: currentKm.toDouble(),
          splitDuration: splitDuration,
          paceMinPerKm: paceMinPerKm,
          avgSpeedKmh: avgSpeedKmh,
        ),
      );

      _lastSplitDistanceM = currentKm * 1000;
      _lastSplitTimestamp = currentTimestamp;
    }
  }

  TrackPoint? _recordStatePoint(GpsObservation sample, MovementState state) {
    final prevDist = _acceptedPoints.isNotEmpty ? _acceptedPoints.last.cumulativeDistanceMeters : 0.0;
    final elapsedSec = _acceptedPoints.isNotEmpty ? _acceptedPoints.last.elapsedSeconds : 0;
    final point = TrackPoint(
      latitude: sample.latitude,
      longitude: sample.longitude,
      timestamp: sample.timestamp,
      elapsedSeconds: elapsedSec,
      validatedSpeedKmh: 0.0,
      cumulativeDistanceMeters: prevDist,
      state: state,
      altitudeMeters: sample.altitudeMeters,
    );
    _acceptedPoints.add(point);
    return point;
  }

  void reset() {
    _acceptedPoints.clear();
    _stops.clear();
    _splits.clear();
    _lastObservation = null;
    _stopStartedAt = null;
    _consecutiveSlowSamples = 0;
    _peakValidatedSpeedKmh = 0.0;
    _lastSplitDistanceM = 0;
    _lastSplitTimestamp = null;
  }
}
