// Provider Abstraction Interfaces for Remember Me Adaptive Planner

enum WeatherConditionType {
  clear,
  cloudy,
  rain,
  heavyRain,
  snow,
  thunderstorm,
  windy,
}

class WeatherContext {
  const WeatherContext({
    required this.temperatureCelsius,
    required this.rainProbabilityPercentage,
    required this.condition,
    required this.isOutdoorFavorable,
    this.alertMessage,
  });

  final double temperatureCelsius;
  final int rainProbabilityPercentage;
  final WeatherConditionType condition;
  final bool isOutdoorFavorable;
  final String? alertMessage;
}

class WalkingWindow {
  const WalkingWindow({
    required this.startTime,
    required this.endTime,
    required this.description,
  });

  final DateTime startTime;
  final DateTime endTime;
  final String description;
}

abstract class WeatherProvider {
  Future<WeatherContext?> getWeatherForecast({
    required double latitude,
    required double longitude,
    required DateTime date,
  });

  Future<WalkingWindow?> findOptimalWalkingWindow({
    required double latitude,
    required double longitude,
    required DateTime date,
  });
}

class LocationSnapshot {
  const LocationSnapshot({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.speedKmh,
    required this.timestamp,
  });

  final double latitude;
  final double longitude;
  final double? altitude;
  final double? speedKmh;
  final DateTime timestamp;
}

abstract class LocationProvider {
  Future<LocationSnapshot?> getCurrentLocation();
  Stream<LocationSnapshot> watchLocationUpdates({bool isStationary = false});
}

enum JourneyType {
  walk,
  run,
  cycling,
  movement,
}

class JourneyLiveState {
  const JourneyLiveState({
    required this.type,
    required this.elapsedSeconds,
    required this.movingSeconds,
    required this.stoppedSeconds,
    required this.distanceKm,
    required this.currentSpeedKmh,
    required this.averageSpeedKmh,
    required this.peakSpeedKmh,
    required this.currentPaceMinPerKm,
    required this.stepsCount,
    required this.routeCoordinates,
    required this.isPaused,
    this.liveAccuracyMeters = 5.0,
  });

  final JourneyType type;
  final int elapsedSeconds;
  final int movingSeconds;
  final int stoppedSeconds;
  final double distanceKm;
  final double currentSpeedKmh;
  final double averageSpeedKmh;
  final double peakSpeedKmh;
  final double currentPaceMinPerKm;
  final int stepsCount;
  final List<LocationSnapshot> routeCoordinates;
  final bool isPaused;
  final double liveAccuracyMeters;
}

class JourneySummary {
  const JourneySummary({
    required this.type,
    required this.totalDuration,
    required this.movingDuration,
    required this.stoppedDuration,
    required this.totalDistanceKm,
    required this.averageSpeedKmh,
    required this.peakSpeedKmh,
    required this.totalSteps,
    required this.routePoints,
    required this.startedAt,
    required this.completedAt,
  });

  final JourneyType type;
  final Duration totalDuration;
  final Duration movingDuration;
  final Duration stoppedDuration;
  final double totalDistanceKm;
  final double averageSpeedKmh;
  final double peakSpeedKmh;
  final int totalSteps;
  final List<LocationSnapshot> routePoints;
  final DateTime startedAt;
  final DateTime completedAt;
}

abstract class MovementJourneyProvider {
  Future<void> startJourney(JourneyType type);
  Future<void> pauseJourney();
  Future<void> resumeJourney();
  Future<JourneySummary> finishJourney();
  Stream<JourneyLiveState> watchLiveJourney();
  JourneyLiveState? get currentLiveState;
}

abstract class HealthProvider {
  Future<int> getTodayStepCount();
  Stream<int> watchStepUpdates();
}

enum FocusShieldLevel {
  off,
  remind,
  shield,
}
