import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/config/app_config.dart';
import '../domain/repositories/provider_abstractions.dart';

/// Geocoding result representation
class GeocodingResult {
  const GeocodingResult({
    required this.displayName,
    required this.latitude,
    required this.longitude,
    this.category,
  });

  final String displayName;
  final double latitude;
  final double longitude;
  final String? category;
}

/// Routing result representation
class RouteEstimate {
  const RouteEstimate({
    required this.distanceMeters,
    required this.durationMinutes,
    required this.geometryPolyline,
  });

  final double distanceMeters;
  final int durationMinutes;
  final List<LocationSnapshot> geometryPolyline;
}

/// Geocoding Provider Interface
abstract class GeocodingProvider {
  Future<List<GeocodingResult>> searchAddress(String query);
  Future<String?> reverseGeocode({required double latitude, required double longitude});
}

/// Routing Provider Interface
abstract class RoutingProvider {
  Future<RouteEstimate?> calculateRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    String profile = 'walking', // 'walking', 'driving', 'cycling'
  });
}

/// Public OpenStreetMap Nominatim implementation (100% Free, zero-API-key)
class NominatimGeocodingService implements GeocodingProvider {
  NominatimGeocodingService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final Map<String, List<GeocodingResult>> _cache = {};

  @override
  Future<List<GeocodingResult>> searchAddress(String query) async {
    final clean = query.trim().toLowerCase();
    if (clean.isEmpty) return const [];
    if (_cache.containsKey(clean)) return _cache[clean]!;

    try {
      final url = Uri.parse(
        '${AppConfig.nominatimBaseUrl}/search?q=${Uri.encodeComponent(clean)}&format=json&limit=5&addressdetails=1',
      );

      final response = await _client.get(
        url,
        headers: {'User-Agent': 'RememberMe-AdaptivePlanner/1.0 (local-first; open-source)'},
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List<dynamic>;
        final results = list.map((item) {
          final map = item as Map<String, dynamic>;
          return GeocodingResult(
            displayName: map['display_name'] as String? ?? 'Unknown Location',
            latitude: double.tryParse(map['lat']?.toString() ?? '0') ?? 0.0,
            longitude: double.tryParse(map['lon']?.toString() ?? '0') ?? 0.0,
            category: map['category'] as String?,
          );
        }).toList();

        _cache[clean] = results;
        return results;
      }
    } catch (e) {
      debugPrint('[Geocoding] Graceful fallback on network exception: $e');
    }

    return const [];
  }

  @override
  Future<String?> reverseGeocode({required double latitude, required double longitude}) async {
    try {
      final url = Uri.parse(
        '${AppConfig.nominatimBaseUrl}/reverse?lat=$latitude&lon=$longitude&format=json',
      );

      final response = await _client.get(
        url,
        headers: {'User-Agent': 'RememberMe-AdaptivePlanner/1.0 (local-first; open-source)'},
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['display_name'] as String?;
      }
    } catch (e) {
      debugPrint('[ReverseGeocoding] Graceful fallback: $e');
    }
    return null;
  }
}

/// Public OSRM Routing Implementation (100% Free, zero-API-key)
class OsrmRoutingService implements RoutingProvider {
  OsrmRoutingService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<RouteEstimate?> calculateRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    String profile = 'walking',
  }) async {
    try {
      final osrmProfile = profile == 'driving' ? 'car' : (profile == 'cycling' ? 'bike' : 'foot');
      final url = Uri.parse(
        '${AppConfig.osrmBaseUrl}/route/v1/$osrmProfile/$startLng,$startLat;$endLng,$endLat?overview=simplified&geometries=geojson',
      );

      final response = await _client.get(url).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final routes = data['routes'] as List<dynamic>?;
        if (routes != null && routes.isNotEmpty) {
          final first = routes.first as Map<String, dynamic>;
          final distance = (first['distance'] as num?)?.toDouble() ?? 0.0;
          final durationSec = (first['duration'] as num?)?.toDouble() ?? 0.0;

          final geometry = first['geometry'] as Map<String, dynamic>?;
          final coordinates = geometry?['coordinates'] as List<dynamic>? ?? [];

          final points = coordinates.map((c) {
            final coord = c as List<dynamic>;
            return LocationSnapshot(
              longitude: (coord[0] as num).toDouble(),
              latitude: (coord[1] as num).toDouble(),
              timestamp: DateTime.now(),
            );
          }).toList();

          return RouteEstimate(
            distanceMeters: distance,
            durationMinutes: (durationSec / 60).round(),
            geometryPolyline: points,
          );
        }
      }
    } catch (e) {
      debugPrint('[Routing] Fallback to Haversine distance on network exception: $e');
    }

    // Offline Haversine fallback
    return _fallbackHaversine(startLat, startLng, endLat, endLng);
  }

  RouteEstimate _fallbackHaversine(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        ((lat2 - lat1) * p / 2).abs() -
        (1 - ((lat2 - lat1) * p).abs()) / 2 * ((lon2 - lon1) * p).abs();
    final distanceKm = 12742 * a.abs() * 100;
    final distanceMeters = distanceKm * 1000;
    final durationMins = ((distanceKm / 5.0) * 60).round().clamp(5, 120);

    return RouteEstimate(
      distanceMeters: distanceMeters,
      durationMinutes: durationMins,
      geometryPolyline: [
        LocationSnapshot(latitude: lat1, longitude: lon1, timestamp: DateTime.now()),
        LocationSnapshot(latitude: lat2, longitude: lon2, timestamp: DateTime.now()),
      ],
    );
  }
}
