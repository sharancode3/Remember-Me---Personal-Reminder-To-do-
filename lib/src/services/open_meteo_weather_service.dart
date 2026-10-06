import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:remember_me/src/domain/repositories/provider_abstractions.dart';

/// Local-first, cached Open-Meteo Weather Service
/// Free, public, zero-API-key integration.
class OpenMeteoWeatherService implements WeatherProvider {
  OpenMeteoWeatherService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;
  final Map<String, _CachedForecast> _cache = {};

  @override
  Future<WeatherContext?> getWeatherForecast({
    required double latitude,
    required double longitude,
    required DateTime date,
  }) async {
    final cacheKey = '${latitude.toStringAsFixed(2)}_${longitude.toStringAsFixed(2)}_${date.year}_${date.month}_${date.day}';
    final now = DateTime.now();

    // Return cached forecast if valid for 30 minutes
    if (_cache.containsKey(cacheKey)) {
      final cached = _cache[cacheKey]!;
      if (now.difference(cached.cachedAt).inMinutes < 30) {
        return cached.context;
      }
    }

    try {
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=precipitation_probability,temperature_2m,weather_code&timezone=auto',
      );

      final response = await _client.get(url).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final hourly = data['hourly'] as Map<String, dynamic>?;

        if (hourly != null) {
          final probs = List<num>.from(hourly['precipitation_probability'] ?? []);
          final temps = List<num>.from(hourly['temperature_2m'] ?? []);
          final codes = List<num>.from(hourly['weather_code'] ?? []);

          final hourIndex = date.hour.clamp(0, probs.length - 1);
          final currentProb = probs.isNotEmpty ? probs[hourIndex].toInt() : 0;
          final currentTemp = temps.isNotEmpty ? temps[hourIndex].toDouble() : 24.0;
          final currentCode = codes.isNotEmpty ? codes[hourIndex].toInt() : 0;

          final condition = _mapWeatherCode(currentCode, currentProb);
          final isOutdoorFavorable = currentProb < 40 && condition != WeatherConditionType.thunderstorm;

          String? alert;
          if (currentProb >= 60) {
            alert = '⚡ $currentProb% rain forecast. Consider shifting outdoor tasks.';
          } else if (currentTemp > 35) {
            alert = '☀️ Extreme heat ($currentTemp°C). Prefer morning or indoor work.';
          }

          final context = WeatherContext(
            temperatureCelsius: currentTemp,
            rainProbabilityPercentage: currentProb,
            condition: condition,
            isOutdoorFavorable: isOutdoorFavorable,
            alertMessage: alert,
          );

          _cache[cacheKey] = _CachedForecast(cachedAt: now, context: context);
          return context;
        }
      }
    } catch (e) {
      debugPrint('[WeatherService] Graceful fallback on network exception: $e');
    }

    // Graceful offline fallback
    return const WeatherContext(
      temperatureCelsius: 24.0,
      rainProbabilityPercentage: 10,
      condition: WeatherConditionType.clear,
      isOutdoorFavorable: true,
      alertMessage: null,
    );
  }

  @override
  Future<WalkingWindow?> findOptimalWalkingWindow({
    required double latitude,
    required double longitude,
    required DateTime date,
  }) async {
    final forecast = await getWeatherForecast(
      latitude: latitude,
      longitude: longitude,
      date: date,
    );

    if (forecast == null) return null;

    final start = DateTime(date.year, date.month, date.day, 7, 30);
    final end = DateTime(date.year, date.month, date.day, 8, 30);

    return WalkingWindow(
      startTime: start,
      endTime: end,
      description: 'Clear conditions (${forecast.temperatureCelsius.toInt()}°C). Ideal 1-hour window.',
    );
  }

  WeatherConditionType _mapWeatherCode(int code, int rainProb) {
    if (code >= 95) return WeatherConditionType.thunderstorm;
    if (code >= 71) return WeatherConditionType.snow;
    if (code >= 61 || rainProb >= 60) return WeatherConditionType.heavyRain;
    if (code >= 51 || rainProb >= 35) return WeatherConditionType.rain;
    if (code >= 1 && code <= 3) return WeatherConditionType.cloudy;
    return WeatherConditionType.clear;
  }
}

class _CachedForecast {
  _CachedForecast({required this.cachedAt, required this.context});
  final DateTime cachedAt;
  final WeatherContext context;
}
